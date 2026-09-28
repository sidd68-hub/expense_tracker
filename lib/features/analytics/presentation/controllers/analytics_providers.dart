import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/common/utils/money.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../domain/analytics_calculator.dart';

DateTimeRange defaultAnalyticsRange() {
  final now = DateTime.now();
  return DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
}

final analyticsRangeProvider = StateProvider<DateTimeRange>((ref) => defaultAnalyticsRange());

class AnalyticsData {
  const AnalyticsData({
    required this.transactions,
    required this.totalExpense,
    required this.totalIncome,
    required this.categoryBreakdown,
    required this.accountBreakdown,
    required this.expenseTrend,
    required this.isMonthlyBucketed,
  });

  final List<TransactionEntity> transactions;
  final MoneyAmount totalExpense;
  final MoneyAmount totalIncome;
  final List<CategoryTotal> categoryBreakdown;
  final List<AccountTotal> accountBreakdown;

  /// Expense totals bucketed by day (short ranges) or month (long ranges) —
  /// see [isMonthlyBucketed].
  final List<DayTotal> expenseTrend;
  final bool isMonthlyBucketed;
}

/// Fetches every transaction in the selected range once and derives every
/// analytics figure from that single list client-side — a range like "this
/// year" is still a bounded read, unlike the dashboard's aggregate queries
/// which cover unbounded history.
final analyticsDataProvider = FutureProvider.autoDispose<AnalyticsData>((ref) async {
  final range = ref.watch(analyticsRangeProvider);
  final repository = ref.watch(transactionRepositoryProvider);
  final transactions = await repository.getTransactionsInRange(start: range.start, end: range.end);

  final expenseOnly = transactions.where((t) => t.isExpense).toList();
  final rangeDays = range.end.difference(range.start).inDays;
  final useMonthly = rangeDays > 62;

  return AnalyticsData(
    transactions: transactions,
    totalExpense: AnalyticsCalculator.sumByType(transactions, TransactionType.expense),
    totalIncome: AnalyticsCalculator.sumByType(transactions, TransactionType.income),
    categoryBreakdown: AnalyticsCalculator.categoryBreakdown(expenseOnly),
    accountBreakdown: AnalyticsCalculator.accountBreakdown(transactions),
    expenseTrend: useMonthly
        ? AnalyticsCalculator.monthlyTotals(transactions, TransactionType.expense, range.start, range.end)
        : AnalyticsCalculator.dailyTotals(transactions, TransactionType.expense, range.start, range.end),
    isMonthlyBucketed: useMonthly,
  );
});
