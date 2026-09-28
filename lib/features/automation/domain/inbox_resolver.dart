import '../../../core/common/utils/money.dart';
import '../../accounts/domain/entities/account_entity.dart';
import '../../categories/domain/entities/category_entity.dart';
import '../../categories/domain/entities/category_type.dart';
import '../../transactions/domain/entities/transaction_entity.dart';
import '../../transactions/domain/entities/transaction_source.dart';
import '../../transactions/domain/entities/transaction_type.dart';
import 'entities/inbox_entry.dart';

class ResolvedInbox {
  const ResolvedInbox({
    this.categoryId,
    this.accountId,
    this.fromAccountId,
    this.toAccountId,
    required this.isFullyResolved,
  });

  final String? categoryId;
  final String? accountId;
  final String? fromAccountId;
  final String? toAccountId;

  /// True when every field the transaction type needs was matched by name —
  /// the entry is a candidate for Automatic Mode. An unresolved field always
  /// routes to manual confirmation instead of guessing (rule #16).
  final bool isFullyResolved;
}

/// Pure name-matching between an [InboxEntry] (which only knows category/
/// account *names*, since that's all an automation client can realistically
/// supply) and the user's actual categories/accounts. No I/O — the caller
/// fetches the lists once (already loaded for the UI) and passes them in.
class InboxResolver {
  const InboxResolver._();

  static ResolvedInbox resolve(
    InboxEntry entry, {
    required List<CategoryEntity> categories,
    required List<AccountEntity> accounts,
  }) {
    if (entry.type == TransactionType.transfer) {
      final from = _matchByName(accounts, (a) => a.name, entry.fromAccountName);
      final to = _matchByName(accounts, (a) => a.name, entry.toAccountName);
      final resolved = from != null && to != null && from.id != to.id;
      return ResolvedInbox(fromAccountId: from?.id, toAccountId: to?.id, isFullyResolved: resolved);
    }

    final categoryType = entry.type == TransactionType.income ? CategoryType.income : CategoryType.expense;
    final candidateCategories = categories.where((c) => c.type == categoryType).toList();
    final category = _matchByName(candidateCategories, (c) => c.name, entry.categoryName);
    final account = _matchByName(accounts, (a) => a.name, entry.accountName);

    return ResolvedInbox(
      categoryId: category?.id,
      accountId: account?.id,
      isFullyResolved: category != null && account != null,
    );
  }

  static TransactionEntity buildDraft(InboxEntry entry, ResolvedInbox resolved) {
    return TransactionEntity(
      id: '',
      type: entry.type,
      amount: MoneyAmount(minorUnits: entry.amountMinor, currency: entry.currency),
      date: entry.date ?? entry.createdAt ?? DateTime.now(),
      categoryId: resolved.categoryId,
      accountId: resolved.accountId,
      fromAccountId: resolved.fromAccountId,
      toAccountId: resolved.toAccountId,
      merchant: entry.merchant,
      remark: entry.remark,
      source: _sourceFor(entry.platform),
      isImported: true,
      externalTransactionId: entry.externalTransactionId,
      automationSource: entry.source,
    );
  }

  static T? _matchByName<T>(List<T> items, String Function(T) nameOf, String? needle) {
    if (needle == null || needle.trim().isEmpty) return null;
    final normalized = needle.trim().toLowerCase();
    for (final item in items) {
      if (nameOf(item).trim().toLowerCase() == normalized) return item;
    }
    return null;
  }

  static TransactionSource _sourceFor(String? platform) {
    switch (platform) {
      case 'ios':
        return TransactionSource.iosShortcut;
      case 'android':
        return TransactionSource.androidMacrodroid;
      default:
        return TransactionSource.api;
    }
  }
}
