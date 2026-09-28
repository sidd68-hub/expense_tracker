import { IngestValidationError, parseIngestPayload } from "./types";

describe("parseIngestPayload", () => {
  it("accepts a valid expense payload and defaults currency/source", () => {
    const result = parseIngestPayload({ amount: 25000, type: "expense", merchant: "ABC Restaurant" });
    expect(result.amount).toBe(25000);
    expect(result.type).toBe("expense");
    expect(result.currency).toBe("INR");
    expect(result.source).toBe("api");
  });

  it("rejects a non-object body", () => {
    expect(() => parseIngestPayload("not json")).toThrow(IngestValidationError);
    expect(() => parseIngestPayload(null)).toThrow(IngestValidationError);
  });

  it("rejects a missing amount", () => {
    expect(() => parseIngestPayload({ type: "expense" })).toThrow(/amount/);
  });

  it("rejects a zero or negative amount", () => {
    expect(() => parseIngestPayload({ amount: 0, type: "expense" })).toThrow(/greater than zero/);
    expect(() => parseIngestPayload({ amount: -500, type: "expense" })).toThrow(/greater than zero/);
  });

  it("rejects a non-integer amount (never trust a float rupee value from automation)", () => {
    expect(() => parseIngestPayload({ amount: 250.5, type: "expense" })).toThrow(/integer/);
  });

  it("rejects an invalid type", () => {
    expect(() => parseIngestPayload({ amount: 100, type: "refund" })).toThrow(/type must be one of/);
  });

  it("requires fromAccountId/Name and toAccountId/Name for a transfer", () => {
    expect(() => parseIngestPayload({ amount: 100, type: "transfer" })).toThrow(/fromAccountId or fromAccountName/);
    expect(() =>
      parseIngestPayload({ amount: 100, type: "transfer", fromAccountName: "Cash" }),
    ).toThrow(/toAccountId or toAccountName/);
  });

  it("accepts a transfer identified purely by account names", () => {
    const result = parseIngestPayload({
      amount: 500000,
      type: "transfer",
      fromAccountName: "HDFC Bank",
      toAccountName: "Cash",
    });
    expect(result.fromAccountName).toBe("HDFC Bank");
    expect(result.toAccountName).toBe("Cash");
  });

  it("rejects a transfer whose raw fromAccountId and toAccountId are identical", () => {
    expect(() =>
      parseIngestPayload({ amount: 100, type: "transfer", fromAccountId: "acc1", toAccountId: "acc1" }),
    ).toThrow(/must differ/);
  });

  it("rejects a malformed date", () => {
    expect(() => parseIngestPayload({ amount: 100, type: "expense", date: "not-a-date" })).toThrow(/date/);
  });

  it("accepts a valid ISO date", () => {
    const result = parseIngestPayload({ amount: 100, type: "expense", date: "2026-09-08T20:15:00+05:30" });
    expect(result.date).toBe("2026-09-08T20:15:00+05:30");
  });
});
