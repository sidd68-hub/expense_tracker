"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.IngestValidationError = void 0;
exports.parseIngestPayload = parseIngestPayload;
class IngestValidationError extends Error {
    constructor(message) {
        super(message);
        this.name = "IngestValidationError";
    }
}
exports.IngestValidationError = IngestValidationError;
const VALID_TYPES = new Set(["expense", "income", "transfer"]);
/**
 * Validates and normalizes a raw JSON body into an [IngestPayload]. Automation
 * input is untrusted (rule #11) — every field is checked before anything
 * touches Firestore, mirroring the client-side TransactionValidator so
 * "invalid transaction" means the same thing everywhere.
 */
function parseIngestPayload(body) {
    if (typeof body !== "object" || body === null) {
        throw new IngestValidationError("Request body must be a JSON object");
    }
    const data = body;
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
    let date;
    if (data.date !== undefined) {
        if (typeof data.date !== "string" || Number.isNaN(Date.parse(data.date))) {
            throw new IngestValidationError("date must be a valid ISO-8601 string");
        }
        date = data.date;
    }
    const asOptionalString = (value, field) => {
        if (value === undefined || value === null)
            return undefined;
        if (typeof value !== "string")
            throw new IngestValidationError(`${field} must be a string`);
        return value;
    };
    return {
        amount,
        currency: asOptionalString(data.currency, "currency") ?? "INR",
        type: type,
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
//# sourceMappingURL=types.js.map