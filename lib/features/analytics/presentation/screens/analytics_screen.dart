import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/theme.dart';
import '../../../../core/common/constants/category_icons.dart';
import '../../../../core/common/widgets/state_views.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../controllers/analytics_providers.dart';
import '../widgets/expense_trend_chart.dart';

T? _findById<T>(List<T> items, String Function(T) idOf, String id) {
  for (final item in items) {
    if (idOf(item) == id) return item;
  }
  return null;
}

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  DateTimeRange _thisWeek() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return DateTimeRange(start: DateTime(start.year, start.month, start.day), end: now);
  }

  DateTimeRange _thisMonth() {
    final now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, now.month, 1), end: now);
  }

  DateTimeRange _lastMonth() {
    final now = DateTime.now();
    final firstOfThisMonth = DateTime(now.year, now.month, 1);
    final lastMonthEnd = firstOfThisMonth.subtract(const Duration(days: 1));
    return DateTimeRange(start: DateTime(lastMonthEnd.year, lastMonthEnd.month, 1), end: lastMonthEnd);
  }

  DateTimeRange _thisYear() {
    final now = DateTime.now();
    return DateTimeRange(start: DateTime(now.year, 1, 1), end: now);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(analyticsRangeProvider);
    final dataAsync = ref.watch(analyticsDataProvider);
    final categories = ref.watch(allCategoriesProvider).value ?? const [];
    final accounts = ref.watch(activeAccountsProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('This week'),
                    selected: false,
                    onSelected: (_) => ref.read(analyticsRangeProvider.notifier).state = _thisWeek(),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('This month'),
                    selected: false,
                    onSelected: (_) => ref.read(analyticsRangeProvider.notifier).state = _thisMonth(),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Last month'),
                    selected: false,
                    onSelected: (_) => ref.read(analyticsRangeProvider.notifier).state = _lastMonth(),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('This year'),
                    selected: false,
                    onSelected: (_) => ref.read(analyticsRangeProvider.notifier).state = _thisYear(),
                  ),
                  const SizedBox(width: 8),
                  ActionChip(
                    label: Text(
                      '${DateFormat('d MMM').format(range.start)} – ${DateFormat('d MMM').format(range.end)}',
                    ),
                    avatar: const Icon(Icons.calendar_month, size: 18),
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: range,
                      );
                      if (picked != null) ref.read(analyticsRangeProvider.notifier).state = picked;
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: dataAsync.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(analyticsDataProvider),
              ),
              data: (data) {
                if (data.transactions.isEmpty) {
                  return const EmptyView(
                    icon: Icons.insights_outlined,
                    title: 'No data for this range',
                    subtitle: 'Try a different date range, or add some transactions.',
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _TotalTile(
                            label: 'Income',
                            value: data.totalIncome.format(),
                            color: TransactionColors.income,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _TotalTile(
                            label: 'Expense',
                            value: data.totalExpense.format(),
                            color: TransactionColors.expense,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('Spending trend', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ExpenseTrendChart(points: data.expenseTrend, isMonthlyBucketed: data.isMonthlyBucketed),
                    if (data.categoryBreakdown.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('By category', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _BreakdownList(
                        total: data.totalExpense.minorUnits,
                        rows: data.categoryBreakdown.map((c) {
                          final category = _findById<CategoryEntity>(categories, (cat) => cat.id, c.categoryId);
                          return _BreakdownRow(
                            label: category?.name ?? 'Uncategorized',
                            icon: category != null ? CategoryIcons.iconFor(category.iconKey) : Icons.category_outlined,
                            color: category != null ? Color(category.color) : Colors.grey,
                            amountMinor: c.amount.minorUnits,
                          );
                        }).toList(),
                      ),
                    ],
                    if (data.accountBreakdown.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Text('By account', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      _BreakdownList(
                        total: data.accountBreakdown.fold(0, (sum, a) => sum + a.amount.minorUnits),
                        rows: data.accountBreakdown.map((a) {
                          final account = _findById<AccountEntity>(accounts, (acc) => acc.id, a.accountId);
                          return _BreakdownRow(
                            label: account?.name ?? 'Unknown account',
                            icon: Icons.account_balance_wallet_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            amountMinor: a.amount.minorUnits,
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 6),
            Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow {
  const _BreakdownRow({required this.label, required this.icon, required this.color, required this.amountMinor});

  final String label;
  final IconData icon;
  final Color color;
  final int amountMinor;
}

class _BreakdownList extends StatelessWidget {
  const _BreakdownList({required this.rows, required this.total});

  final List<_BreakdownRow> rows;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: rows.map((row) {
            final fraction = total == 0 ? 0.0 : row.amountMinor / total;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(row.icon, color: row.color, size: 20),
                      const SizedBox(width: 10),
                      Expanded(child: Text(row.label)),
                      Text('₹${(row.amountMinor / 100).toStringAsFixed(0)}'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: fraction.clamp(0, 1),
                      minHeight: 6,
                      backgroundColor: row.color.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(row.color),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
