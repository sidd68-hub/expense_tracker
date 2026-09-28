import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/utils/money.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.todayExpense,
    required this.todayIncome,
    required this.monthExpense,
    required this.monthIncome,
    required this.topCategories,
  });

  final MoneyAmount todayExpense;
  final MoneyAmount todayIncome;
  final MoneyAmount monthExpense;
  final MoneyAmount monthIncome;

  /// Up to 5 categories with the highest spend this month, richest first.
  final List<CategorySpend> topCategories;

  MoneyAmount get monthBalance => monthIncome - monthExpense;
}

class CategorySpend {
  const CategorySpend({required this.category, required this.amount});

  final CategoryEntity category;
  final MoneyAmount amount;
}

/// Drives the dashboard summary cards. Uses server-side aggregate sums for
/// the four totals (cheap regardless of history length — rule #43) and one
/// bounded read of this month's expenses to compute the per-category
/// breakdown, since Firestore has no server-side group-by.
final dashboardSummaryProvider = FutureProvider.autoDispose<DashboardSummary>((ref) async {
  final TransactionRepository transactionRepository = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final startOfToday = DateTime(now.year, now.month, now.day);
  final startOfMonth = DateTime(now.year, now.month, 1);

  final todayExpenseFuture =
      transactionRepository.getAggregateTotal(type: TransactionType.expense, start: startOfToday);
  final todayIncomeFuture =
      transactionRepository.getAggregateTotal(type: TransactionType.income, start: startOfToday);
  final monthExpenseFuture =
      transactionRepository.getAggregateTotal(type: TransactionType.expense, start: startOfMonth);
  final monthIncomeFuture =
      transactionRepository.getAggregateTotal(type: TransactionType.income, start: startOfMonth);
  final monthExpenseTransactionsFuture = transactionRepository.getTransactionsInRange(
    start: startOfMonth,
    end: now,
    type: TransactionType.expense,
  );

  final todayExpense = await todayExpenseFuture;
  final todayIncome = await todayIncomeFuture;
  final monthExpense = await monthExpenseFuture;
  final monthIncome = await monthIncomeFuture;
  final List<TransactionEntity> monthExpenseTransactions = await monthExpenseTransactionsFuture;

  final totalsByCategory = <String, int>{};
  for (final transaction in monthExpenseTransactions) {
    final categoryId = transaction.categoryId;
    if (categoryId == null) continue;
    totalsByCategory[categoryId] = (totalsByCategory[categoryId] ?? 0) + transaction.amount.minorUnits;
  }

  final categories = await ref.watch(allCategoriesProvider.future);
  final categoryById = {for (final c in categories) c.id: c};

  final topCategories = totalsByCategory.entries
      .map((entry) {
        final category = categoryById[entry.key];
        if (category == null) return null;
        return CategorySpend(category: category, amount: MoneyAmount(minorUnits: entry.value));
      })
      .whereType<CategorySpend>()
      .toList()
    ..sort((a, b) => b.amount.minorUnits.compareTo(a.amount.minorUnits));

  return DashboardSummary(
    todayExpense: todayExpense,
    todayIncome: todayIncome,
    monthExpense: monthExpense,
    monthIncome: monthIncome,
    topCategories: topCategories.take(5).toList(),
  );
});
