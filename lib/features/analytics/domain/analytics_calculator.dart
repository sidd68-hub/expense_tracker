import '../../../core/common/utils/money.dart';
import '../../transactions/domain/entities/transaction_entity.dart';
import '../../transactions/domain/entities/transaction_type.dart';

class CategoryTotal {
  const CategoryTotal({required this.categoryId, required this.amount});

  final String categoryId;
  final MoneyAmount amount;
}

class AccountTotal {
  const AccountTotal({required this.accountId, required this.amount});

  final String accountId;
  final MoneyAmount amount;
}

class DayTotal {
  const DayTotal({required this.day, required this.amount});

  final DateTime day;
  final MoneyAmount amount;
}

/// Pure, dependency-free analytics math — kept out of widgets so it's
/// directly unit-testable (rule #36) and independent of how the data was
/// fetched. All inputs are a bounded, already-fetched list of transactions;
/// this class does no I/O.
class AnalyticsCalculator {
  const AnalyticsCalculator._();

  static MoneyAmount sumByType(List<TransactionEntity> transactions, TransactionType type) {
    final total = transactions.where((t) => t.type == type).fold<int>(0, (sum, t) => sum + t.amount.minorUnits);
    return MoneyAmount(minorUnits: total);
  }

  /// Highest-spend categories first. Transfers are excluded — they have no
  /// categoryId and must never be attributed to a spending category.
  static List<CategoryTotal> categoryBreakdown(List<TransactionEntity> transactions) {
    final totals = <String, int>{};
    for (final t in transactions) {
      final categoryId = t.categoryId;
      if (categoryId == null) continue;
      totals[categoryId] = (totals[categoryId] ?? 0) + t.amount.minorUnits;
    }
    final result = totals.entries
        .map((e) => CategoryTotal(categoryId: e.key, amount: MoneyAmount(minorUnits: e.value)))
        .toList()
      ..sort((a, b) => b.amount.minorUnits.compareTo(a.amount.minorUnits));
    return result;
  }

  /// Account-wise spend, using the transacting account for expense/income
  /// and both legs for a transfer (rule #11: analytics must handle transfers
  /// separately from expense/income, but an account-wise view still needs to
  /// reflect money moving out of / into each account).
  static List<AccountTotal> accountBreakdown(List<TransactionEntity> transactions) {
    final totals = <String, int>{};
    for (final t in transactions) {
      if (t.isTransfer) {
        if (t.fromAccountId != null) {
          totals[t.fromAccountId!] = (totals[t.fromAccountId!] ?? 0) + t.amount.minorUnits;
        }
        continue;
      }
      final accountId = t.accountId;
      if (accountId == null) continue;
      totals[accountId] = (totals[accountId] ?? 0) + t.amount.minorUnits;
    }
    final result = totals.entries
        .map((e) => AccountTotal(accountId: e.key, amount: MoneyAmount(minorUnits: e.value)))
        .toList()
      ..sort((a, b) => b.amount.minorUnits.compareTo(a.amount.minorUnits));
    return result;
  }

  /// Buckets [transactions] of [type] into one total per calendar day across
  /// [start, end] inclusive, filling in zero-amount days so charts don't
  /// show gaps. Intended for ranges short enough to chart per-day (roughly
  /// a month or less) — use [monthlyTotals] for longer ranges.
  static List<DayTotal> dailyTotals(
    List<TransactionEntity> transactions,
    TransactionType type,
    DateTime start,
    DateTime end,
  ) {
    final totals = <DateTime, int>{};
    var cursor = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    while (!cursor.isAfter(endDay)) {
      totals[cursor] = 0;
      cursor = cursor.add(const Duration(days: 1));
    }

    for (final t in transactions) {
      if (t.type != type) continue;
      final day = DateTime(t.date.year, t.date.month, t.date.day);
      if (!totals.containsKey(day)) continue;
      totals[day] = totals[day]! + t.amount.minorUnits;
    }

    final days = totals.keys.toList()..sort();
    return days.map((d) => DayTotal(day: d, amount: MoneyAmount(minorUnits: totals[d]!))).toList();
  }

  /// Same idea as [dailyTotals] but bucketed by calendar month — for ranges
  /// like "this year" where a per-day chart would be unreadable.
  static List<DayTotal> monthlyTotals(
    List<TransactionEntity> transactions,
    TransactionType type,
    DateTime start,
    DateTime end,
  ) {
    final totals = <DateTime, int>{};
    var cursor = DateTime(start.year, start.month, 1);
    final endMonth = DateTime(end.year, end.month, 1);
    while (!cursor.isAfter(endMonth)) {
      totals[cursor] = 0;
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    }

    for (final t in transactions) {
      if (t.type != type) continue;
      final month = DateTime(t.date.year, t.date.month, 1);
      if (!totals.containsKey(month)) continue;
      totals[month] = totals[month]! + t.amount.minorUnits;
    }

    final months = totals.keys.toList()..sort();
    return months.map((m) => DayTotal(day: m, amount: MoneyAmount(minorUnits: totals[m]!))).toList();
  }
}
