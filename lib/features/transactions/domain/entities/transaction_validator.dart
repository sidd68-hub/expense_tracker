import 'transaction_entity.dart';

/// Pure, testable validation independent of any widget — mirrors the checks
/// the ingestion Cloud Function re-runs server-side for automation payloads,
/// so "invalid transaction" is defined in exactly one place conceptually.
class TransactionValidator {
  const TransactionValidator._();

  /// Returns a user-facing error message, or null if [transaction] is valid.
  static String? validate(TransactionEntity transaction) {
    if (transaction.amount.isZeroOrNegative) {
      return 'Amount must be greater than zero';
    }

    if (transaction.isTransfer) {
      if (transaction.fromAccountId == null || transaction.toAccountId == null) {
        return 'Select both a from and to account for a transfer';
      }
      if (transaction.fromAccountId == transaction.toAccountId) {
        return 'From and to accounts must be different';
      }
      return null;
    }

    if (transaction.categoryId == null || transaction.categoryId!.isEmpty) {
      return 'Select a category';
    }
    if (transaction.accountId == null || transaction.accountId!.isEmpty) {
      return 'Select an account';
    }
    return null;
  }

  static bool isValid(TransactionEntity transaction) => validate(transaction) == null;
}
