"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.resolveCategoryId = resolveCategoryId;
exports.resolveAccountId = resolveAccountId;
const firebaseAdmin_1 = require("./firebaseAdmin");
/**
 * Resolves the category to attach to an ingested transaction. Automation
 * sources typically know a category *name* (a fixed picklist in the
 * Shortcut/Macro), not our internal Firestore id, so this checks an
 * explicit id first, then falls back to a case-insensitive name match
 * scoped to the right expense/income type. Never guesses a category that
 * doesn't clearly match — an unmatched transaction is saved uncategorized
 * rather than mis-categorized (rule #16).
 */
async function resolveCategoryId(uid, type, categoryId, categoryName) {
    const categoriesRef = firebaseAdmin_1.db.collection(`users/${uid}/categories`);
    if (categoryId) {
        const doc = await categoriesRef.doc(categoryId).get();
        if (doc.exists && doc.data()?.type === type) {
            return doc.id;
        }
    }
    if (categoryName) {
        const snapshot = await categoriesRef.where("type", "==", type).get();
        const needle = categoryName.trim().toLowerCase();
        const match = snapshot.docs.find((doc) => doc.data().name.trim().toLowerCase() === needle);
        if (match)
            return match.id;
    }
    return null;
}
/**
 * Same idea as [resolveCategoryId] but for accounts — resolves an explicit
 * id first, falling back to a case-insensitive name match. Returns null
 * (never guesses) when neither is given or nothing matches.
 */
async function resolveAccountId(uid, accountId, accountName) {
    const accountsRef = firebaseAdmin_1.db.collection(`users/${uid}/accounts`);
    if (accountId) {
        const doc = await accountsRef.doc(accountId).get();
        if (doc.exists)
            return doc.id;
    }
    if (accountName) {
        const snapshot = await accountsRef.get();
        const needle = accountName.trim().toLowerCase();
        const match = snapshot.docs.find((doc) => doc.data().name.trim().toLowerCase() === needle);
        if (match)
            return match.id;
    }
    return null;
}
//# sourceMappingURL=categoryResolver.js.map