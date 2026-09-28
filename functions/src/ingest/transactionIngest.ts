import { onRequest } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { FieldValue } from "firebase-admin/firestore";
import { db } from "../lib/firebaseAdmin";
import { resolveAutomationToken } from "../lib/automationAuth";
import { IngestValidationError, parseIngestPayload } from "../lib/types";
import { computeIdempotencyKey } from "../lib/idempotency";
import { resolveAccountId, resolveCategoryId } from "../lib/categoryResolver";
import type { IngestPayload } from "../lib/types";

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
export const transactionIngest = onRequest({ cors: false }, async (req, res) => {
  if (req.method !== "POST") {
    res.status(405).json({ error: "Method not allowed. Use POST." });
    return;
  }

  const auth = await resolveAutomationToken(req.headers.authorization);
  if (!auth) {
    logger.warn("automation ingest: rejected — missing or invalid bearer token");
    res.status(401).json({ error: "Invalid or missing automation token" });
    return;
  }
  const { uid } = auth;

  let payload: IngestPayload;
  try {
    payload = parseIngestPayload(req.body);
  } catch (error) {
    if (error instanceof IngestValidationError) {
      logger.info("automation ingest: validation failed", { uid: shortUid(uid), reason: error.message });
      res.status(400).json({ error: error.message });
      return;
    }
    throw error;
  }

  const resolvedDate = payload.date ? new Date(payload.date) : new Date();
  const idempotencyKey = computeIdempotencyKey(uid, payload, resolvedDate);

  logger.info("automation ingest: received", {
    uid: shortUid(uid),
    type: payload.type,
    source: payload.source,
    platform: payload.platform,
    hasExternalId: Boolean(payload.externalTransactionId),
  });

  try {
    const idempotencyRef = db.doc(`users/${uid}/transaction_idempotency/${idempotencyKey}`);
    const transactionsRef = db.collection(`users/${uid}/transactions`);

    const result = await db.runTransaction(async (tx) => {
      const existing = await tx.get(idempotencyRef);
      if (existing.exists) {
        return { status: "duplicate" as const, transactionId: existing.data()!.transactionId as string };
      }

      const transactionDoc = await buildTransactionDoc(uid, payload, resolvedDate);
      const newTransactionRef = transactionsRef.doc();
      tx.set(newTransactionRef, transactionDoc);
      tx.set(idempotencyRef, {
        transactionId: newTransactionRef.id,
        createdAt: FieldValue.serverTimestamp(),
      });
      return { status: "created" as const, transactionId: newTransactionRef.id };
    });

    if (result.status === "duplicate") {
      logger.info("automation ingest: duplicate — returning existing transaction", {
        uid: shortUid(uid),
        transactionId: result.transactionId,
      });
      res.status(200).json(result);
      return;
    }

    logger.info("automation ingest: created", { uid: shortUid(uid), transactionId: result.transactionId });
    res.status(201).json(result);
  } catch (error) {
    logger.error("automation ingest: failed", { uid: shortUid(uid), error: String(error) });
    res.status(500).json({ error: "Internal error while saving the transaction" });
  }
});

async function buildTransactionDoc(uid: string, payload: IngestPayload, date: Date) {
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
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  if (payload.type === "transfer") {
    const fromAccountId = await resolveAccountId(uid, payload.fromAccountId, payload.fromAccountName);
    const toAccountId = await resolveAccountId(uid, payload.toAccountId, payload.toAccountName);
    if (fromAccountId && toAccountId && fromAccountId === toAccountId) {
      throw new IngestValidationError("fromAccountId and toAccountId resolved to the same account");
    }
    return { ...base, categoryId: null, accountId: null, fromAccountId, toAccountId };
  }

  const categoryId = await resolveCategoryId(uid, payload.type, payload.categoryId, payload.categoryName);
  const accountId = await resolveAccountId(uid, payload.accountId, payload.accountName);
  return { ...base, categoryId, accountId, fromAccountId: null, toAccountId: null };
}

/** Never log a full uid alongside amounts/merchants in the clear — a short prefix is enough to correlate log lines. */
function shortUid(uid: string): string {
  return uid.slice(0, 6);
}
