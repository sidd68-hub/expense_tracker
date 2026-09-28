import { computeIdempotencyKey } from "./idempotency";
import { parseIngestPayload } from "./types";

describe("computeIdempotencyKey", () => {
  const date = new Date("2026-09-08T20:15:00.000Z");

  it("is stable for the same externalTransactionId", () => {
    const payload = parseIngestPayload({ amount: 100, type: "expense", externalTransactionId: "UPI123", source: "phonepe" });
    const a = computeIdempotencyKey("uid1", payload, date);
    const b = computeIdempotencyKey("uid1", payload, date);
    expect(a).toBe(b);
  });

  it("differs across users even with the same externalTransactionId (never leak across accounts)", () => {
    const payload = parseIngestPayload({ amount: 100, type: "expense", externalTransactionId: "UPI123" });
    const a = computeIdempotencyKey("uid1", payload, date);
    const b = computeIdempotencyKey("uid2", payload, date);
    expect(a).not.toBe(b);
  });

  it("differs across sources for the same externalTransactionId (two banks could reuse ref numbers)", () => {
    const payloadA = parseIngestPayload({ amount: 100, type: "expense", externalTransactionId: "REF1", source: "hdfc" });
    const payloadB = parseIngestPayload({ amount: 100, type: "expense", externalTransactionId: "REF1", source: "sbi" });
    const a = computeIdempotencyKey("uid1", payloadA, date);
    const b = computeIdempotencyKey("uid1", payloadB, date);
    expect(a).not.toBe(b);
  });

  it("falls back to amount+type+minute+merchant when no externalTransactionId is given", () => {
    const payload = parseIngestPayload({ amount: 100, type: "expense", merchant: "Cafe" });
    const a = computeIdempotencyKey("uid1", payload, date);
    const b = computeIdempotencyKey("uid1", payload, date);
    expect(a).toBe(b);
  });

  it("the fallback key differs once the minute bucket changes", () => {
    const payload = parseIngestPayload({ amount: 100, type: "expense", merchant: "Cafe" });
    const a = computeIdempotencyKey("uid1", payload, date);
    const later = new Date(date.getTime() + 5 * 60000);
    const b = computeIdempotencyKey("uid1", payload, later);
    expect(a).not.toBe(b);
  });

  it("the fallback key is merchant-case-insensitive", () => {
    const payloadLower = parseIngestPayload({ amount: 100, type: "expense", merchant: "cafe" });
    const payloadUpper = parseIngestPayload({ amount: 100, type: "expense", merchant: "CAFE" });
    const a = computeIdempotencyKey("uid1", payloadLower, date);
    const b = computeIdempotencyKey("uid1", payloadUpper, date);
    expect(a).toBe(b);
  });
});
