"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.revokeAutomationToken = exports.listAutomationTokens = exports.generateAutomationToken = void 0;
const https_1 = require("firebase-functions/v2/https");
const v2_1 = require("firebase-functions/v2");
const firestore_1 = require("firebase-admin/firestore");
const firebaseAdmin_1 = require("../lib/firebaseAdmin");
const automationAuth_1 = require("../lib/automationAuth");
/**
 * Creates a new automation token for the calling (Firebase-Auth-signed-in)
 * user. The raw token is returned exactly once in this response — only its
 * hash is ever persisted — so the client must show it to the user
 * immediately and never expect to retrieve it again.
 */
exports.generateAutomationToken = (0, https_1.onCall)(async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
        throw new https_1.HttpsError("unauthenticated", "Sign in required.");
    }
    const rawToken = (0, automationAuth_1.generateRawToken)();
    const tokenHash = (0, automationAuth_1.hashToken)(rawToken);
    const tokenRef = firebaseAdmin_1.db.collection(`users/${uid}/automation_tokens`).doc();
    await tokenRef.set({
        tokenHash,
        createdAt: firestore_1.FieldValue.serverTimestamp(),
        lastUsedAt: null,
        revoked: false,
    });
    v2_1.logger.info("automation token generated", { uid: uid.slice(0, 6), tokenId: tokenRef.id });
    return { tokenId: tokenRef.id, token: rawToken };
});
/**
 * Lists the calling user's own automation tokens — metadata only
 * (id/createdAt/lastUsedAt/revoked). The client's Firestore rules deny
 * direct reads of `automation_tokens` entirely (it holds nothing but a
 * hash, which must never reach the client either way), so this callable is
 * the only way the Settings screen can render "1 active token, last used
 * ..." and offer a revoke action.
 */
exports.listAutomationTokens = (0, https_1.onCall)(async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
        throw new https_1.HttpsError("unauthenticated", "Sign in required.");
    }
    const snapshot = await firebaseAdmin_1.db.collection(`users/${uid}/automation_tokens`).orderBy("createdAt", "desc").get();
    return {
        tokens: snapshot.docs.map((doc) => {
            const data = doc.data();
            return {
                tokenId: doc.id,
                createdAt: data.createdAt?.toDate?.().toISOString() ?? null,
                lastUsedAt: data.lastUsedAt?.toDate?.().toISOString() ?? null,
                revoked: Boolean(data.revoked),
            };
        }),
    };
});
/**
 * Revokes one of the calling user's own automation tokens. Revocation is
 * immediate — the ingestion endpoint's lookup filters on `revoked == false`,
 * so a revoked token stops working on its very next request.
 */
exports.revokeAutomationToken = (0, https_1.onCall)(async (request) => {
    const uid = request.auth?.uid;
    if (!uid) {
        throw new https_1.HttpsError("unauthenticated", "Sign in required.");
    }
    const tokenId = request.data?.tokenId;
    if (typeof tokenId !== "string" || tokenId.length === 0) {
        throw new https_1.HttpsError("invalid-argument", "tokenId is required.");
    }
    const tokenRef = firebaseAdmin_1.db.doc(`users/${uid}/automation_tokens/${tokenId}`);
    const doc = await tokenRef.get();
    if (!doc.exists) {
        throw new https_1.HttpsError("not-found", "Token not found.");
    }
    await tokenRef.update({ revoked: true });
    v2_1.logger.info("automation token revoked", { uid: uid.slice(0, 6), tokenId });
    return { revoked: true };
});
//# sourceMappingURL=tokens.js.map