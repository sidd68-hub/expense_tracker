import 'package:flutter/material.dart';

import '../../../../core/app/theme.dart';
import '../../domain/entities/transaction_type.dart';

class TransactionTypeSelector extends StatelessWidget {
  const TransactionTypeSelector({super.key, required this.value, required this.onChanged});

  final TransactionType value;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      segments: const [
        ButtonSegment(value: TransactionType.expense, label: Text('Expense')),
        ButtonSegment(value: TransactionType.income, label: Text('Income')),
        ButtonSegment(value: TransactionType.transfer, label: Text('Transfer')),
      ],
      selected: {value},
      onSelectionChanged: (selection) => onChanged(selection.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (!states.contains(WidgetState.selected)) return null;
          return switch (value) {
            TransactionType.expense => TransactionColors.expense.withValues(alpha: 0.15),
            TransactionType.income => TransactionColors.income.withValues(alpha: 0.15),
            TransactionType.transfer => TransactionColors.transfer.withValues(alpha: 0.15),
          };
        }),
      ),
    );
  }
}
