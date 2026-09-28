import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/utils/money.dart';
import '../../../../core/common/widgets/state_views.dart';
import '../../../accounts/domain/entities/account_entity.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../accounts/presentation/widgets/account_picker_sheet.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../categories/presentation/widgets/category_picker_sheet.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../../transactions/domain/entities/transaction_validator.dart';
import '../controllers/automation_providers.dart';

/// Lists everything an automation client (iOS Shortcut, MacroDroid) has
/// dropped in the inbox, pre-filled with best-effort category/account
/// matches, and lets the user fix anything before it becomes a real
/// transaction — the "Confirmation Mode" screen from the spec.
class InboxReviewScreen extends ConsumerWidget {
  const InboxReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(inboxReviewItemsProvider);
    final categories = ref.watch(allCategoriesProvider).value ?? const <CategoryEntity>[];
    final accounts = ref.watch(activeAccountsProvider).value ?? const <AccountEntity>[];

    return Scaffold(
      appBar: AppBar(title: const Text('Review imported transactions')),
      body: itemsAsync.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(message: error.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const EmptyView(
              icon: Icons.inbox_outlined,
              title: 'Nothing to review',
              subtitle: 'Transactions captured by Shortcuts or MacroDroid will show up here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) => _InboxCard(
              item: items[index],
              categories: categories,
              accounts: accounts,
            ),
          );
        },
      ),
    );
  }
}

class _InboxCard extends ConsumerStatefulWidget {
  const _InboxCard({required this.item, required this.categories, required this.accounts});

  final InboxReviewItem item;
  final List<CategoryEntity> categories;
  final List<AccountEntity> accounts;

  @override
  ConsumerState<_InboxCard> createState() => _InboxCardState();
}

class _InboxCardState extends ConsumerState<_InboxCard> {
  late String? _categoryId = widget.item.resolved.categoryId;
  late String? _accountId = widget.item.resolved.accountId;
  late String? _fromAccountId = widget.item.resolved.fromAccountId;
  late String? _toAccountId = widget.item.resolved.toAccountId;

  CategoryEntity? _findCategory(String? id) {
    if (id == null) return null;
    for (final c in widget.categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  AccountEntity? _findAccount(String? id) {
    if (id == null) return null;
    for (final a in widget.accounts) {
      if (a.id == id) return a;
    }
    return null;
  }

  Future<void> _save() async {
    final entry = widget.item.entry;
    final draft = TransactionEntity(
      id: '',
      type: entry.type,
      amount: MoneyAmount(minorUnits: entry.amountMinor, currency: entry.currency),
      date: entry.date ?? entry.createdAt ?? DateTime.now(),
      categoryId: entry.type == TransactionType.transfer ? null : _categoryId,
      accountId: entry.type == TransactionType.transfer ? null : _accountId,
      fromAccountId: entry.type == TransactionType.transfer ? _fromAccountId : null,
      toAccountId: entry.type == TransactionType.transfer ? _toAccountId : null,
      merchant: entry.merchant,
      remark: entry.remark,
      isImported: true,
      externalTransactionId: entry.externalTransactionId,
      automationSource: entry.source,
    );

    final error = TransactionValidator.validate(draft);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    await ref.read(inboxCommitControllerProvider.notifier).commit(entry, draft: draft);
    final state = ref.read(inboxCommitControllerProvider);
    if (state.hasError && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
    }
  }

  Future<void> _discard() async {
    await ref.read(inboxCommitControllerProvider.notifier).discard(widget.item.entry.id);
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.item.entry;
    final isBusy = ref.watch(inboxCommitControllerProvider).isLoading;
    final title = entry.merchant?.isNotEmpty == true ? entry.merchant! : 'Imported ${entry.type.name}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                Text(
                  MoneyAmount(minorUnits: entry.amountMinor, currency: entry.currency).format(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (entry.source != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('Imported from ${entry.source}', style: Theme.of(context).textTheme.bodySmall),
              ),
            const SizedBox(height: 12),
            if (entry.type == TransactionType.transfer) ...[
              _FieldChip(
                label: 'From',
                value: _findAccount(_fromAccountId)?.name,
                onTap: () async {
                  final picked = await showAccountPickerSheet(context, accounts: widget.accounts, excludeAccountId: _toAccountId);
                  if (picked != null) setState(() => _fromAccountId = picked.id);
                },
              ),
              const SizedBox(height: 8),
              _FieldChip(
                label: 'To',
                value: _findAccount(_toAccountId)?.name,
                onTap: () async {
                  final picked = await showAccountPickerSheet(context, accounts: widget.accounts, excludeAccountId: _fromAccountId);
                  if (picked != null) setState(() => _toAccountId = picked.id);
                },
              ),
            ] else ...[
              _FieldChip(
                label: 'Category',
                value: _findCategory(_categoryId)?.name,
                onTap: () async {
                  final categoryType = entry.type == TransactionType.income
                      ? widget.categories.where((c) => c.type.name == 'income')
                      : widget.categories.where((c) => c.type.name == 'expense');
                  final picked = await showCategoryPickerSheet(context, categories: categoryType.toList());
                  if (picked != null) setState(() => _categoryId = picked.id);
                },
              ),
              const SizedBox(height: 8),
              _FieldChip(
                label: 'Account',
                value: _findAccount(_accountId)?.name,
                onTap: () async {
                  final picked = await showAccountPickerSheet(context, accounts: widget.accounts);
                  if (picked != null) setState(() => _accountId = picked.id);
                },
              ),
            ],
            if (entry.remark?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(entry.remark!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Text(
              DateFormat('d MMM yyyy, h:mm a').format(entry.date ?? entry.createdAt ?? DateTime.now()),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: isBusy ? null : _discard, child: const Text('Discard')),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(onPressed: isBusy ? null : _save, child: const Text('Save')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldChip extends StatelessWidget {
  const _FieldChip({required this.label, required this.value, required this.onTap});

  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label, style: Theme.of(context).textTheme.labelMedium)),
          Expanded(
            child: Text(
              value ?? 'Select',
              style: TextStyle(
                color: value == null ? Theme.of(context).colorScheme.error : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, size: 18),
        ],
      ),
    );
  }
}
