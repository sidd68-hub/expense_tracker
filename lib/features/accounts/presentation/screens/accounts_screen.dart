import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/common/widgets/state_views.dart';
import '../../domain/entities/account_entity.dart';
import '../controllers/account_providers.dart';
import '../widgets/account_edit_sheet.dart';
import '../widgets/account_type_icon.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _archiveOrDelete(BuildContext context, WidgetRef ref, AccountEntity account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove "${account.name}"?'),
        content: const Text(
          'If this account is used by any transactions it will be archived instead of deleted, so your history stays intact.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Remove')),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(accountRepositoryProvider).delete(account.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(activeAccountsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: accountsAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (accounts) {
          if (accounts.isEmpty) {
            return EmptyView(
              icon: Icons.account_balance_wallet_outlined,
              title: 'No accounts yet',
              subtitle: 'Add a bank account, card, or wallet to get started.',
              action: FilledButton(onPressed: () => showAccountEditSheet(context), child: const Text('Add account')),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              return ListTile(
                leading: AccountTypeIcon(type: account.type),
                title: Text(account.name),
                subtitle: Text(account.type.name),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') showAccountEditSheet(context, existing: account);
                    if (value == 'remove') _archiveOrDelete(context, ref, account);
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'remove', child: Text('Remove')),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAccountEditSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
