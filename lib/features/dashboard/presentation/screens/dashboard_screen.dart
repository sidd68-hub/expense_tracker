import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/app/theme.dart';
import '../../../../core/common/constants/category_icons.dart';
import '../../../../core/common/widgets/state_views.dart';
import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../../budgets/domain/entities/budget_entity.dart';
import '../../../budgets/presentation/controllers/budget_providers.dart';
import '../../../budgets/presentation/widgets/budget_progress_card.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_tile.dart';
import '../controllers/dashboard_providers.dart';
import '../widgets/summary_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  CategoryEntity? _categoryFor(List<CategoryEntity> categories, String? id) {
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentTransactions = ref.watch(recentTransactionsProvider);
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final budgetProgressAsync = ref.watch(budgetsWithProgressProvider);
    final categories = ref.watch(allCategoriesProvider).value ?? const <CategoryEntity>[];
    final user = ref.watch(authStateChangesProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi${user?.displayName != null ? ', ${user!.displayName}' : ''}'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(recentTransactionsProvider);
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(budgetsWithProgressProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            summaryAsync.when(
              loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: LoadingView()),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(dashboardSummaryProvider),
              ),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: 'Expense',
                          amount: summary.todayExpense,
                          color: TransactionColors.expense,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          label: 'Income',
                          amount: summary.todayIncome,
                          color: TransactionColors.income,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('This month', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(
                          label: 'Expense',
                          amount: summary.monthExpense,
                          color: TransactionColors.expense,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SummaryCard(
                          label: 'Income',
                          amount: summary.monthIncome,
                          color: TransactionColors.income,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SummaryCard(
                    label: 'Balance',
                    amount: summary.monthBalance,
                    color: summary.monthBalance.isZeroOrNegative ? TransactionColors.expense : TransactionColors.income,
                  ),
                  if (summary.topCategories.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('Top spending categories', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Card(
                      child: Column(
                        children: summary.topCategories.map((entry) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(entry.category.color).withValues(alpha: 0.15),
                              child: Icon(
                                CategoryIcons.iconFor(entry.category.iconKey),
                                color: Color(entry.category.color),
                              ),
                            ),
                            title: Text(entry.category.name),
                            trailing: Text(entry.amount.format(), style: const TextStyle(fontWeight: FontWeight.w600)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            budgetProgressAsync.maybeWhen(
              data: (progressList) {
                if (progressList.isEmpty) return const SizedBox.shrink();
                final sorted = [...progressList]
                  ..sort((a, b) => b.percentUsed.compareTo(a.percentUsed));
                final topBudgets = sorted.take(2).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Budget status', style: Theme.of(context).textTheme.titleMedium),
                        TextButton(onPressed: () => context.push('/budgets'), child: const Text('View all')),
                      ],
                    ),
                    ...topBudgets.map((progress) {
                      final category = progress.budget.scope == BudgetScope.category
                          ? _categoryFor(categories, progress.budget.categoryId)
                          : null;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BudgetProgressCard(
                          progress: progress,
                          category: category,
                          onTap: () => context.push('/budgets'),
                        ),
                      );
                    }),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            const SizedBox(height: 20),
            Text('Recent transactions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            recentTransactions.when(
              loading: () => const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: LoadingView()),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(recentTransactionsProvider),
              ),
              data: (transactions) {
                if (transactions.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: EmptyView(
                      icon: Icons.receipt_long_outlined,
                      title: 'No transactions yet',
                      subtitle: 'Add your first expense or income to see it here.',
                    ),
                  );
                }
                return Card(
                  child: Column(
                    children: transactions.map((t) => TransactionTile(transaction: t)).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
