"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.computeIdempotencyKey = computeIdempotencyKey;
const crypto = __importStar(require("crypto"));
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
function computeIdempotencyKey(uid, payload, resolvedDate) {
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
function hash(input) {
    return crypto.createHash("sha256").update(input).digest("hex");
}
//# sourceMappingURL=idempotency.js.map