import '../../../../core/common/utils/money.dart';
import '../entities/transaction_entity.dart';
import '../entities/transaction_filter.dart';
import '../entities/transaction_page.dart';
import '../entities/transaction_type.dart';

abstract class TransactionRepository {
  /// Live stream of the most recent [limit] transactions, for the dashboard.
  Stream<List<TransactionEntity>> watchRecent({int limit = 10});

  /// Server-side aggregate sum for [type] within an optional date range —
  /// used by the dashboard summary cards so opening the dashboard costs one
  /// aggregation query per figure instead of reading every transaction ever
  /// recorded (rule #43, Firebase cost awareness).
  Future<MoneyAmount> getAggregateTotal({
    required TransactionType type,
    DateTime? start,
    DateTime? end,
    String? categoryId,
  });

  /// All non-deleted transactions within [start, end] — used by Analytics,
  /// which needs full detail (for category/account breakdowns) rather than
  /// just a sum. Callers are expected to pass a bounded range (a week/month/
  /// year), not the user's entire history.
  Future<List<TransactionEntity>> getTransactionsInRange({
    required DateTime start,
    required DateTime end,
    TransactionType? type,
  });

  /// One filtered/sorted page of transactions for the transaction list
  /// screen. Pass the previous result's `cursor` as [startAfter] to fetch
  /// the next page — never load the full history into memory (rule #42).
  Future<TransactionPage> getPage({
    required TransactionFilter filter,
    int pageSize = 30,
    Object? startAfter,
  });

  Future<TransactionEntity?> getById(String id);

  /// Looks up a transaction already created from the same automation
  /// reference id — the client-side half of duplicate protection (rule #21)
  /// now that there's no server to make this check atomic. Checked before
  /// committing an [InboxEntry] so retried/duplicate automation writes never
  /// become two transactions.
  Future<TransactionEntity?> findByExternalTransactionId(String externalTransactionId);

  Future<String> create(TransactionEntity transaction);

  Future<void> update(TransactionEntity transaction);

  /// Soft delete — sets `isDeleted: true` rather than removing the document,
  /// so imported/automation metadata is retained and the action is reversible.
  Future<void> softDelete(String id);

  Future<void> restore(String id);
}
