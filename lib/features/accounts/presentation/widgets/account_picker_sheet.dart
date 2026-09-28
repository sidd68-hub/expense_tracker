import 'package:flutter/material.dart';

import '../../domain/entities/account_entity.dart';
import 'account_type_icon.dart';

/// Bottom sheet used to pick an account/payment method. [excludeAccountId]
/// hides one entry — used by the transfer form so the "to" picker can't
/// offer the account already chosen as "from" (and vice versa).
Future<AccountEntity?> showAccountPickerSheet(
  BuildContext context, {
  required List<AccountEntity> accounts,
  String? excludeAccountId,
}) {
  final options = excludeAccountId == null
      ? accounts
      : accounts.where((a) => a.id != excludeAccountId).toList();

  return showModalBottomSheet<AccountEntity>(
    context: context,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select account', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No accounts available. Add one from Settings → Accounts.'),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final account = options[index];
                    return ListTile(
                      leading: AccountTypeIcon(type: account.type),
                      title: Text(account.name),
                      onTap: () => Navigator.pop(context, account),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
