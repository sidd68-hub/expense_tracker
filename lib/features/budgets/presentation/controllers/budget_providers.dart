import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return BudgetRepositoryImpl(uid: uid);
});

String currentMonthKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}';
}

final currentMonthBudgetsProvider = StreamProvider.autoDispose<List<BudgetEntity>>((ref) {
  return ref.watch(budgetRepositoryProvider).watchBudgets(currentMonthKey());
});

/// Joins this month's budgets with how much has actually been spent against
/// each, computed via one aggregate query per budget (rule #43 — a handful
/// of aggregate reads regardless of how many transactions exist).
final budgetsWithProgressProvider = FutureProvider.autoDispose<List<BudgetProgress>>((ref) async {
  final budgets = await ref.watch(currentMonthBudgetsProvider.future);
  if (budgets.isEmpty) return const [];

  final transactionRepository = ref.watch(transactionRepositoryProvider);
  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  final progressList = await Future.wait(budgets.map((budget) async {
    final spent = await transactionRepository.getAggregateTotal(
      type: TransactionType.expense,
      start: startOfMonth,
      end: now,
      categoryId: budget.scope == BudgetScope.category ? budget.categoryId : null,
    );
    return BudgetProgress(budget: budget, spent: spent);
  }));

  return progressList;
});
