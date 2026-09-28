import { db } from "./firebaseAdmin";

/**
 * Resolves the category to attach to an ingested transaction. Automation
 * sources typically know a category *name* (a fixed picklist in the
 * Shortcut/Macro), not our internal Firestore id, so this checks an
 * explicit id first, then falls back to a case-insensitive name match
 * scoped to the right expense/income type. Never guesses a category that
 * doesn't clearly match — an unmatched transaction is saved uncategorized
 * rather than mis-categorized (rule #16).
 */
export async function resolveCategoryId(
  uid: string,
  type: "expense" | "income",
  categoryId: string | undefined,
  categoryName: string | undefined,
): Promise<string | null> {
  const categoriesRef = db.collection(`users/${uid}/categories`);

  if (categoryId) {
    const doc = await categoriesRef.doc(categoryId).get();
    if (doc.exists && doc.data()?.type === type) {
      return doc.id;
    }
  }

  if (categoryName) {
    const snapshot = await categoriesRef.where("type", "==", type).get();
    const needle = categoryName.trim().toLowerCase();
    const match = snapshot.docs.find((doc) => (doc.data().name as string).trim().toLowerCase() === needle);
    if (match) return match.id;
  }

  return null;
}

/**
 * Same idea as [resolveCategoryId] but for accounts — resolves an explicit
 * id first, falling back to a case-insensitive name match. Returns null
 * (never guesses) when neither is given or nothing matches.
 */
export async function resolveAccountId(
  uid: string,
  accountId: string | undefined,
  accountName: string | undefined,
): Promise<string | null> {
  const accountsRef = db.collection(`users/${uid}/accounts`);

  if (accountId) {
    const doc = await accountsRef.doc(accountId).get();
    if (doc.exists) return doc.id;
  }

  if (accountName) {
    const snapshot = await accountsRef.get();
    const needle = accountName.trim().toLowerCase();
    const match = snapshot.docs.find((doc) => (doc.data().name as string).trim().toLowerCase() === needle);
    if (match) return match.id;
  }

  return null;
}
