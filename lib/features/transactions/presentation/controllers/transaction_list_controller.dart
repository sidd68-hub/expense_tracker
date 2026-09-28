import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import 'transaction_providers.dart';

part 'transaction_list_controller.g.dart';

class TransactionListState {
  const TransactionListState({
    required this.items,
    required this.hasMore,
    required this.cursor,
    this.isLoadingMore = false,
  });

  final List<TransactionEntity> items;
  final bool hasMore;
  final Object? cursor;
  final bool isLoadingMore;

  TransactionListState copyWith({
    List<TransactionEntity>? items,
    bool? hasMore,
    Object? cursor,
    bool? isLoadingMore,
  }) {
    return TransactionListState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      cursor: cursor ?? this.cursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Paginated transaction list for a given [filter]. Riverpod's generated
/// family treats each distinct filter as its own cached page sequence, so
/// switching filters and back doesn't necessarily refetch — see
/// [TransactionFilter]'s value equality.
@riverpod
class TransactionListController extends _$TransactionListController {
  static const _pageSize = 30;

  @override
  Future<TransactionListState> build(TransactionFilter filter) async {
    final page = await ref.read(transactionRepositoryProvider).getPage(filter: filter, pageSize: _pageSize);
    return TransactionListState(items: page.items, hasMore: page.hasMore, cursor: page.cursor);
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    state = AsyncData(current.copyWith(isLoadingMore: true));
    final page = await ref.read(transactionRepositoryProvider).getPage(
          filter: filter,
          pageSize: _pageSize,
          startAfter: current.cursor,
        );
    state = AsyncData(TransactionListState(
      items: [...current.items, ...page.items],
      hasMore: page.hasMore,
      cursor: page.cursor,
    ));
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
