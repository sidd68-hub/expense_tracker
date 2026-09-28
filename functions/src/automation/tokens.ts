import { onCall, HttpsError } from "firebase-functions/v2/https";
import { logger } from "firebase-functions/v2";
import { FieldValue } from "firebase-admin/firestore";
import { db } from "../lib/firebaseAdmin";
import { generateRawToken, hashToken } from "../lib/automationAuth";

/**
 * Creates a new automation token for the calling (Firebase-Auth-signed-in)
 * user. The raw token is returned exactly once in this response — only its
 * hash is ever persisted — so the client must show it to the user
 * immediately and never expect to retrieve it again.
 */
export const generateAutomationToken = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }

  const rawToken = generateRawToken();
  const tokenHash = hashToken(rawToken);

  const tokenRef = db.collection(`users/${uid}/automation_tokens`).doc();
  await tokenRef.set({
    tokenHash,
    createdAt: FieldValue.serverTimestamp(),
    lastUsedAt: null,
    revoked: false,
  });

  logger.info("automation token generated", { uid: uid.slice(0, 6), tokenId: tokenRef.id });

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
export const listAutomationTokens = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }

  const snapshot = await db.collection(`users/${uid}/automation_tokens`).orderBy("createdAt", "desc").get();
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
export const revokeAutomationToken = onCall(async (request) => {
  const uid = request.auth?.uid;
  if (!uid) {
    throw new HttpsError("unauthenticated", "Sign in required.");
  }

  const tokenId = request.data?.tokenId;
  if (typeof tokenId !== "string" || tokenId.length === 0) {
    throw new HttpsError("invalid-argument", "tokenId is required.");
  }

  const tokenRef = db.doc(`users/${uid}/automation_tokens/${tokenId}`);
  const doc = await tokenRef.get();
  if (!doc.exists) {
    throw new HttpsError("not-found", "Token not found.");
  }

  await tokenRef.update({ revoked: true });
  logger.info("automation token revoked", { uid: uid.slice(0, 6), tokenId });

  return { revoked: true };
});
