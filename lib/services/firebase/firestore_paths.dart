/// Central definition of every Firestore path used by the app, so the
/// collection structure documented in the architecture proposal lives in
/// exactly one place. See also `firestore.rules`, which mirrors this shape.
class FirestorePaths {
  const FirestorePaths._();

  static String user(String uid) => 'users/$uid';
  static String categories(String uid) => '${user(uid)}/categories';
  static String accounts(String uid) => '${user(uid)}/accounts';
  static String transactions(String uid) => '${user(uid)}/transactions';
  static String transactionIdempotency(String uid) => '${user(uid)}/transaction_idempotency';
  static String budgets(String uid) => '${user(uid)}/budgets';
  static String recurringTransactions(String uid) => '${user(uid)}/recurring_transactions';
  static String monthlySummaries(String uid) => '${user(uid)}/monthly_summaries';
  static String automationTokens(String uid) => '${user(uid)}/automation_tokens';
  static String settings(String uid) => '${user(uid)}/settings';
}
