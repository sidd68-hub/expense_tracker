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
exports.hashToken = hashToken;
exports.generateRawToken = generateRawToken;
exports.resolveAutomationToken = resolveAutomationToken;
const crypto = __importStar(require("crypto"));
const firebaseAdmin_1 = require("./firebaseAdmin");
/**
 * Automation clients (iOS Shortcuts, MacroDroid) can't run an interactive
 * Firebase Auth sign-in, so they authenticate with a long-lived, revocable
 * bearer token instead — generated once from Settings → Automation and
 * pasted into the Shortcut/Macro's HTTP header. Only its SHA-256 hash is
 * ever stored (`users/{uid}/automation_tokens/{tokenId}.tokenHash`); the raw
 * token is shown to the user exactly once, at generation time, and never
 * logged (rule #29, #41).
 */
function hashToken(rawToken) {
    return crypto.createHash("sha256").update(rawToken).digest("hex");
}
function generateRawToken() {
    return crypto.randomBytes(32).toString("base64url");
}
/**
 * Resolves a bearer token to the uid that owns it, without ever trusting a
 * client-supplied uid directly (rule #29). Returns null for a missing,
 * malformed, unknown, or revoked token — callers must respond 401 in that
 * case and must not reveal which of those it was.
 */
async function resolveAutomationToken(authorizationHeader) {
    if (!authorizationHeader?.startsWith("Bearer "))
        return null;
    const rawToken = authorizationHeader.slice("Bearer ".length).trim();
    if (rawToken.length === 0)
        return null;
    const tokenHash = hashToken(rawToken);
    const snapshot = await firebaseAdmin_1.db
        .collectionGroup("automation_tokens")
        .where("tokenHash", "==", tokenHash)
        .where("revoked", "==", false)
        .limit(1)
        .get();
    if (snapshot.empty)
        return null;
    const tokenDoc = snapshot.docs[0];
    // Parent of a token doc is `users/{uid}/automation_tokens`, so its parent
    // (the `users` collection) contains the uid as the grandparent doc id.
    const uid = tokenDoc.ref.parent.parent?.id;
    if (!uid)
        return null;
    await tokenDoc.ref.update({ lastUsedAt: new Date() });
    return { uid, tokenId: tokenDoc.id };
}
//# sourceMappingURL=automationAuth.js.map