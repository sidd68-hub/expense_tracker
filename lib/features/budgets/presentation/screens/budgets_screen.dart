import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/widgets/state_views.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../domain/entities/budget_entity.dart';
import '../controllers/budget_providers.dart';
import '../widgets/budget_edit_sheet.dart';
import '../widgets/budget_progress_card.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  CategoryEntity? _categoryFor(List<CategoryEntity> categories, String? id) {
    if (id == null) return null;
    for (final c in categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, BudgetEntity budget) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this budget?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(budgetRepositoryProvider).delete(budget.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(budgetsWithProgressProvider);
    final categories = ref.watch(allCategoriesProvider).value ?? const <CategoryEntity>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: progressAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(budgetsWithProgressProvider),
        ),
        data: (progressList) {
          if (progressList.isEmpty) {
            return EmptyView(
              icon: Icons.pie_chart_outline,
              title: 'No budgets set for this month',
              subtitle: 'Set an overall monthly limit, or one per category.',
              action: FilledButton(onPressed: () => showBudgetEditSheet(context), child: const Text('Add budget')),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(budgetsWithProgressProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: progressList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final progress = progressList[index];
                final category =
                    progress.budget.scope == BudgetScope.category ? _categoryFor(categories, progress.budget.categoryId) : null;
                return BudgetProgressCard(
                  progress: progress,
                  category: category,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.edit_outlined),
                            title: const Text('Edit'),
                            onTap: () {
                              Navigator.pop(context);
                              showBudgetEditSheet(context, existing: progress.budget);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_outline),
                            title: const Text('Delete'),
                            onTap: () {
                              Navigator.pop(context);
                              _confirmDelete(context, ref, progress.budget);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBudgetEditSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
