import * as crypto from "crypto";
import { IngestPayload } from "./types";

/**
 * Computes the idempotency key used as the document id under
 * `users/{uid}/transaction_idempotency/{key}`. A second ingestion request
 * that hashes to the same key returns the existing transaction instead of
 * creating a new one (rule #21 — the same transaction must never be
 * inserted twice).
 *
 * Prefers the source's own reference (bank/UPI/notification id) when given —
 * that's the most reliable signal. Falls back to a hash of
 * (uid + source + amount + type + date-truncated-to-the-minute + merchant)
 * so a retried request with no reference id still dedupes, at the cost of
 * treating two genuinely distinct transactions with identical amount/
 * merchant in the same minute as one. Automation UIs should supply
 * externalTransactionId whenever the source exposes one to avoid that edge
 * case entirely.
 */
export function computeIdempotencyKey(uid: string, payload: IngestPayload, resolvedDate: Date): string {
  if (payload.externalTransactionId) {
    return hash([uid, payload.source ?? "api", payload.externalTransactionId].join("|"));
  }

  const minuteBucket = Math.floor(resolvedDate.getTime() / 60000);
  const parts = [
    uid,
    payload.source ?? "api",
    payload.type,
    String(payload.amount),
    String(minuteBucket),
    (payload.merchant ?? "").trim().toLowerCase(),
  ];
  return hash(parts.join("|"));
}

function hash(input: string): string {
  return crypto.createHash("sha256").update(input).digest("hex");
}
