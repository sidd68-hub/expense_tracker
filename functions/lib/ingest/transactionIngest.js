"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.transactionIngest = void 0;
const https_1 = require("firebase-functions/v2/https");
const v2_1 = require("firebase-functions/v2");
const firestore_1 = require("firebase-admin/firestore");
const firebaseAdmin_1 = require("../lib/firebaseAdmin");
const automationAuth_1 = require("../lib/automationAuth");
const types_1 = require("../lib/types");
const idempotency_1 = require("../lib/idempotency");
const categoryResolver_1 = require("../lib/categoryResolver");
/**
 * POST /transactionIngest — the single entry point every automation
 * integration (iOS Shortcuts, Android MacroDroid, and anything added later)
 * POSTs to. See section 22 of the architecture doc for the payload contract.
 *
 * Pipeline: authenticate via bearer token → validate payload → check
 * idempotency → resolve category/account → write. Every stage is logged
 * (never the token itself) so a failed automation run is debuggable from
 * Cloud Logging alone.
 */
exports.transactionIngest = (0, https_1.onRequest)({ cors: false }, async (req, res) => {
    if (req.method !== "POST") {
        res.status(405).json({ error: "Method not allowed. Use POST." });
        return;
    }
    const auth = await (0, automationAuth_1.resolveAutomationToken)(req.headers.authorization);
    if (!auth) {
        v2_1.logger.warn("automation ingest: rejected — missing or invalid bearer token");
        res.status(401).json({ error: "Invalid or missing automation token" });
        return;
    }
    const { uid } = auth;
    let payload;
    try {
        payload = (0, types_1.parseIngestPayload)(req.body);
    }
    catch (error) {
        if (error instanceof types_1.IngestValidationError) {
            v2_1.logger.info("automation ingest: validation failed", { uid: shortUid(uid), reason: error.message });
            res.status(400).json({ error: error.message });
            return;
        }
        throw error;
    }
    const resolvedDate = payload.date ? new Date(payload.date) : new Date();
    const idempotencyKey = (0, idempotency_1.computeIdempotencyKey)(uid, payload, resolvedDate);
    v2_1.logger.info("automation ingest: received", {
        uid: shortUid(uid),
        type: payload.type,
        source: payload.source,
        platform: payload.platform,
        hasExternalId: Boolean(payload.externalTransactionId),
    });
    try {
        const idempotencyRef = firebaseAdmin_1.db.doc(`users/${uid}/transaction_idempotency/${idempotencyKey}`);
        const transactionsRef = firebaseAdmin_1.db.collection(`users/${uid}/transactions`);
        const result = await firebaseAdmin_1.db.runTransaction(async (tx) => {
            const existing = await tx.get(idempotencyRef);
            if (existing.exists) {
                return { status: "duplicate", transactionId: existing.data().transactionId };
            }
            const transactionDoc = await buildTransactionDoc(uid, payload, resolvedDate);
            const newTransactionRef = transactionsRef.doc();
            tx.set(newTransactionRef, transactionDoc);
            tx.set(idempotencyRef, {
                transactionId: newTransactionRef.id,
                createdAt: firestore_1.FieldValue.serverTimestamp(),
            });
            return { status: "created", transactionId: newTransactionRef.id };
        });
        if (result.status === "duplicate") {
            v2_1.logger.info("automation ingest: duplicate — returning existing transaction", {
                uid: shortUid(uid),
                transactionId: result.transactionId,
            });
            res.status(200).json(result);
            return;
        }
        v2_1.logger.info("automation ingest: created", { uid: shortUid(uid), transactionId: result.transactionId });
        res.status(201).json(result);
    }
    catch (error) {
        v2_1.logger.error("automation ingest: failed", { uid: shortUid(uid), error: String(error) });
        res.status(500).json({ error: "Internal error while saving the transaction" });
    }
});
async function buildTransactionDoc(uid, payload, date) {
    const source = payload.platform === "ios" ? "iosShortcut" : payload.platform === "android" ? "androidMacrodroid" : "api";
    const base = {
        type: payload.type,
        amountMinor: payload.amount,
        currency: payload.currency ?? "INR",
        date,
        merchant: payload.merchant ?? null,
        remark: payload.remark ?? null,
        source,
        isImported: true,
        externalTransactionId: payload.externalTransactionId ?? null,
        automationSource: payload.source ?? null,
        status: "confirmed",
        isDeleted: false,
        createdAt: firestore_1.FieldValue.serverTimestamp(),
        updatedAt: firestore_1.FieldValue.serverTimestamp(),
    };
    if (payload.type === "transfer") {
        const fromAccountId = await (0, categoryResolver_1.resolveAccountId)(uid, payload.fromAccountId, payload.fromAccountName);
        const toAccountId = await (0, categoryResolver_1.resolveAccountId)(uid, payload.toAccountId, payload.toAccountName);
        if (fromAccountId && toAccountId && fromAccountId === toAccountId) {
            throw new types_1.IngestValidationError("fromAccountId and toAccountId resolved to the same account");
        }
        return { ...base, categoryId: null, accountId: null, fromAccountId, toAccountId };
    }
    const categoryId = await (0, categoryResolver_1.resolveCategoryId)(uid, payload.type, payload.categoryId, payload.categoryName);
    const accountId = await (0, categoryResolver_1.resolveAccountId)(uid, payload.accountId, payload.accountName);
    return { ...base, categoryId, accountId, fromAccountId: null, toAccountId: null };
}
/** Never log a full uid alongside amounts/merchants in the clear — a short prefix is enough to correlate log lines. */
function shortUid(uid) {
    return uid.slice(0, 6);
}
//# sourceMappingURL=transactionIngest.js.map