import 'package:flutter/material.dart';

import '../../../../core/common/utils/money.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.label, required this.amount, this.color});

  final String label;
  final MoneyAmount amount;
  final Color? color;

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
            Text(
              amount.format(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
