import 'package:flutter/material.dart';

import '../../../../core/app/theme.dart';
import '../../../../core/common/constants/category_icons.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../domain/budget_calculator.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    super.key,
    required this.progress,
    required this.category,
    required this.onTap,
  });

  final BudgetProgress progress;

  /// Null for an overall budget.
  final CategoryEntity? category;
  final VoidCallback onTap;

  Color _colorFor(BuildContext context, BudgetStatus status) {
    return switch (status) {
      BudgetStatus.ok => TransactionColors.income,
      BudgetStatus.warning => const Color(0xFFF9A825),
      BudgetStatus.exceeded => TransactionColors.expense,
    };
  }

  String _statusLabel(BudgetStatus status) {
    return switch (status) {
      BudgetStatus.ok => 'On track',
      BudgetStatus.warning => 'Approaching limit',
      BudgetStatus.exceeded => 'Budget exceeded',
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(context, progress.status);
    final title = category?.name ?? 'Overall budget';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (category != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(category!.color).withValues(alpha: 0.15),
                        child: Icon(CategoryIcons.iconFor(category!.iconKey), color: Color(category!.color), size: 18),
                      ),
                    ),
                  Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                  Text('${progress.percentUsed}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (progress.percentUsed / 100).clamp(0, 1).toDouble(),
                  minHeight: 8,
                  backgroundColor: color.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progress.spent.format()} of ${progress.limit.format()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(_statusLabel(progress.status), style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
