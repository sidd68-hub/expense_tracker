import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/state_views.dart';
import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import '../controllers/transaction_list_controller.dart';
import '../controllers/transaction_providers.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionFilter _filter = const TransactionFilter();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionListControllerProvider(_filter).notifier).loadMore();
    }
  }

  Future<void> _openFilterSheet() async {
    final categories = ref.read(allCategoriesProvider).value ?? const [];
    final accounts = ref.read(activeAccountsProvider).value ?? const [];
    final result = await showTransactionFilterSheet(
      context,
      current: _filter,
      categories: categories,
      accounts: accounts,
    );
    if (result != null) setState(() => _filter = result);
  }

  Future<void> _confirmDelete(TransactionEntity transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('You can restore this from Settings if you delete it by mistake.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(transactionRepositoryProvider).softDelete(transaction.id);
    ref.invalidate(transactionListControllerProvider(_filter));
    ref.invalidate(recentTransactionsProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await ref.read(transactionRepositoryProvider).restore(transaction.id);
            ref.invalidate(transactionListControllerProvider(_filter));
            ref.invalidate(recentTransactionsProvider);
          },
        ),
      ),
    );
  }

  void _showAddTypeMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.arrow_upward),
              title: const Text('Expense'),
              onTap: () {
                Navigator.pop(context);
                context.push('/transactions/add?type=expense');
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_downward),
              title: const Text('Income'),
              onTap: () {
                Navigator.pop(context);
                context.push('/transactions/add?type=income');
              },
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: const Text('Transfer'),
              onTap: () {
                Navigator.pop(context);
                context.push('/transactions/add?type=transfer');
              },
            ),
          ],
        ),
      ),
    );
  }

  bool get _hasActiveFilters =>
      (_filter.types?.isNotEmpty ?? false) ||
      _filter.categoryId != null ||
      _filter.accountId != null ||
      _filter.startDate != null;

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(transactionListControllerProvider(_filter));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: Badge(isLabelVisible: _hasActiveFilters, child: const Icon(Icons.filter_list)),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search merchant or remark',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _filter = TransactionFilter(
                                types: _filter.types,
                                categoryId: _filter.categoryId,
                                accountId: _filter.accountId,
                                startDate: _filter.startDate,
                                endDate: _filter.endDate,
                              ));
                        },
                      ),
              ),
              onSubmitted: (value) => setState(() => _filter = TransactionFilter(
                    types: _filter.types,
                    categoryId: _filter.categoryId,
                    accountId: _filter.accountId,
                    startDate: _filter.startDate,
                    endDate: _filter.endDate,
                    searchText: value,
                  )),
            ),
          ),
          Expanded(
            child: listState.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(
                message: error.toString(),
                onRetry: () => ref.invalidate(transactionListControllerProvider(_filter)),
              ),
              data: (state) {
                if (state.items.isEmpty) {
                  return EmptyView(
                    icon: Icons.receipt_long_outlined,
                    title: _hasActiveFilters || _filter.hasSearch ? 'No matching transactions' : 'No transactions yet',
                    subtitle: 'Tap + to add your first transaction.',
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => ref.read(transactionListControllerProvider(_filter).notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.items.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      }
                      final transaction = state.items[index];
                      return Dismissible(
                        key: ValueKey(transaction.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                        ),
                        confirmDismiss: (_) async {
                          await _confirmDelete(transaction);
                          return false; // list refresh is driven by provider invalidation, not the dismiss animation
                        },
                        child: TransactionTile(
                          transaction: transaction,
                          onTap: () => context.push('/transactions/${transaction.id}/edit'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: _showAddTypeMenu, child: const Icon(Icons.add)),
    );
  }
}
