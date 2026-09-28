import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/app/theme.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';

/// A single row in the transaction list/recent-transactions widget.
/// Color and sign of the amount communicate expense vs income vs transfer
/// at a glance, per the UI/UX requirements.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.categoryName, this.onTap});

  final TransactionEntity transaction;
  final String? categoryName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = switch (transaction.type) {
      TransactionType.expense => TransactionColors.expense,
      TransactionType.income => TransactionColors.income,
      TransactionType.transfer => TransactionColors.transfer,
    };
    final sign = switch (transaction.type) {
      TransactionType.expense => '-',
      TransactionType.income => '+',
      TransactionType.transfer => '',
    };
    final title = transaction.merchant?.isNotEmpty == true
        ? transaction.merchant!
        : (categoryName ?? (transaction.isTransfer ? 'Transfer' : 'Uncategorized'));

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(
          switch (transaction.type) {
            TransactionType.expense => Icons.arrow_upward,
            TransactionType.income => Icons.arrow_downward,
            TransactionType.transfer => Icons.swap_horiz,
          },
          color: color,
          size: 20,
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        DateFormat('d MMM, h:mm a').format(transaction.date) +
            (transaction.isImported ? ' · Imported' : ''),
      ),
      trailing: Text(
        '$sign${transaction.amount.format()}',
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 15),
      ),
    );
  }
}
