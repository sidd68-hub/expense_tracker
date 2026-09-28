/**
 * Shape of the JSON body accepted by the transaction-ingest endpoint.
 * Mirrors section 22 of the automation design: iOS Shortcuts / MacroDroid /
 * any future integration POST this exact shape. `amount` is always the
 * smallest currency unit (paise for INR), matching how the app itself
 * stores money — never a floating-point rupee value.
 */
export interface IngestPayload {
  amount: number;
  currency?: string;
  type: "expense" | "income" | "transfer";
  merchant?: string;
  /** Preferred when the caller knows the internal id. */
  categoryId?: string;
  /**
   * Fallback when the caller only knows a human-readable name (this is the
   * common case for Shortcuts/MacroDroid, which offer a fixed picklist of
   * category names, not our Firestore ids). Resolved case-insensitively
   * against the user's own categories; left uncategorized if no match
   * exists rather than guessing (rule #16).
   */
  categoryName?: string;
  accountId?: string;
  /** Fallback when the caller only knows the account's display name — same idea as categoryName. */
  accountName?: string;
  fromAccountId?: string;
  fromAccountName?: string;
  toAccountId?: string;
  toAccountName?: string;
  remark?: string;
  /** ISO-8601. Defaults to "now" (server time) if omitted. */
  date?: string;
  /** e.g. "phonepe", "hdfc_sms" — free text, surfaced in the UI as context. */
  source?: string;
  /** e.g. "ios", "android" — for observability only, not used in logic. */
  platform?: string;
  /**
   * The bank/UPI/app's own reference for this transaction, when available.
   * Strongly recommended — it's the most reliable de-duplication signal.
   * When absent, idempotency falls back to a hash of
   * (uid + amount + type + date truncated to the minute + merchant).
   */
  externalTransactionId?: string;
}

export type IngestResultStatus = "created" | "duplicate";

export interface IngestResult {
  status: IngestResultStatus;
  transactionId: string;
}

export class IngestValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "IngestValidationError";
  }
}

const VALID_TYPES = new Set(["expense", "income", "transfer"]);

/**
 * Validates and normalizes a raw JSON body into an [IngestPayload]. Automation
 * input is untrusted (rule #11) — every field is checked before anything
 * touches Firestore, mirroring the client-side TransactionValidator so
 * "invalid transaction" means the same thing everywhere.
 */
export function parseIngestPayload(body: unknown): IngestPayload {
  if (typeof body !== "object" || body === null) {
    throw new IngestValidationError("Request body must be a JSON object");
  }
  const data = body as Record<string, unknown>;

  const amount = data.amount;
  if (typeof amount !== "number" || !Number.isFinite(amount) || !Number.isInteger(amount)) {
    throw new IngestValidationError("amount is required and must be an integer (smallest currency unit)");
  }
  if (amount <= 0) {
    throw new IngestValidationError("amount must be greater than zero");
  }

  const type = data.type;
  if (typeof type !== "string" || !VALID_TYPES.has(type)) {
    throw new IngestValidationError('type must be one of "expense", "income", "transfer"');
  }

  if (type === "transfer") {
    const hasFrom = typeof data.fromAccountId === "string" || typeof data.fromAccountName === "string";
    const hasTo = typeof data.toAccountId === "string" || typeof data.toAccountName === "string";
    if (!hasFrom) {
      throw new IngestValidationError("fromAccountId or fromAccountName is required for a transfer");
    }
    if (!hasTo) {
      throw new IngestValidationError("toAccountId or toAccountName is required for a transfer");
    }
    // Exact equality here only catches the obvious case (same id/name given
    // for both sides) — the authoritative check happens after resolution,
    // since two different names could still resolve to the same account.
    if (data.fromAccountId && data.fromAccountId === data.toAccountId) {
      throw new IngestValidationError("fromAccountId and toAccountId must differ");
    }
  }

  let date: string | undefined;
  if (data.date !== undefined) {
    if (typeof data.date !== "string" || Number.isNaN(Date.parse(data.date))) {
      throw new IngestValidationError("date must be a valid ISO-8601 string");
    }
    date = data.date;
  }

  const asOptionalString = (value: unknown, field: string): string | undefined => {
    if (value === undefined || value === null) return undefined;
    if (typeof value !== "string") throw new IngestValidationError(`${field} must be a string`);
    return value;
  };

  return {
    amount,
    currency: asOptionalString(data.currency, "currency") ?? "INR",
    type: type as IngestPayload["type"],
    merchant: asOptionalString(data.merchant, "merchant"),
    categoryId: asOptionalString(data.categoryId, "categoryId"),
    categoryName: asOptionalString(data.categoryName, "categoryName"),
    accountId: asOptionalString(data.accountId, "accountId"),
    accountName: asOptionalString(data.accountName, "accountName"),
    fromAccountId: asOptionalString(data.fromAccountId, "fromAccountId"),
    fromAccountName: asOptionalString(data.fromAccountName, "fromAccountName"),
    toAccountId: asOptionalString(data.toAccountId, "toAccountId"),
    toAccountName: asOptionalString(data.toAccountName, "toAccountName"),
    remark: asOptionalString(data.remark, "remark"),
    date,
    source: asOptionalString(data.source, "source") ?? "api",
    platform: asOptionalString(data.platform, "platform"),
    externalTransactionId: asOptionalString(data.externalTransactionId, "externalTransactionId"),
  };
}
