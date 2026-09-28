import * as crypto from "crypto";
import { db } from "./firebaseAdmin";

/**
 * Automation clients (iOS Shortcuts, MacroDroid) can't run an interactive
 * Firebase Auth sign-in, so they authenticate with a long-lived, revocable
 * bearer token instead — generated once from Settings → Automation and
 * pasted into the Shortcut/Macro's HTTP header. Only its SHA-256 hash is
 * ever stored (`users/{uid}/automation_tokens/{tokenId}.tokenHash`); the raw
 * token is shown to the user exactly once, at generation time, and never
 * logged (rule #29, #41).
 */
export function hashToken(rawToken: string): string {
  return crypto.createHash("sha256").update(rawToken).digest("hex");
}

export function generateRawToken(): string {
  return crypto.randomBytes(32).toString("base64url");
}

export interface AuthenticatedAutomationRequest {
  uid: string;
  tokenId: string;
}

/**
 * Resolves a bearer token to the uid that owns it, without ever trusting a
 * client-supplied uid directly (rule #29). Returns null for a missing,
 * malformed, unknown, or revoked token — callers must respond 401 in that
 * case and must not reveal which of those it was.
 */
export async function resolveAutomationToken(authorizationHeader: string | undefined): Promise<AuthenticatedAutomationRequest | null> {
  if (!authorizationHeader?.startsWith("Bearer ")) return null;
  const rawToken = authorizationHeader.slice("Bearer ".length).trim();
  if (rawToken.length === 0) return null;

  const tokenHash = hashToken(rawToken);
  const snapshot = await db
    .collectionGroup("automation_tokens")
    .where("tokenHash", "==", tokenHash)
    .where("revoked", "==", false)
    .limit(1)
    .get();

  if (snapshot.empty) return null;

  const tokenDoc = snapshot.docs[0];
  // Parent of a token doc is `users/{uid}/automation_tokens`, so its parent
  // (the `users` collection) contains the uid as the grandparent doc id.
  const uid = tokenDoc.ref.parent.parent?.id;
  if (!uid) return null;

  await tokenDoc.ref.update({ lastUsedAt: new Date() });

  return { uid, tokenId: tokenDoc.id };
}
