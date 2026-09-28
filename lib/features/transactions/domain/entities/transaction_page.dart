import 'transaction_entity.dart';

/// One page of a paginated transaction query. [cursor] is intentionally
/// `Object?` — it's whatever opaque pagination token the data source layer
/// produces (a Firestore `DocumentSnapshot` in practice) passed back into the
/// next `getPage` call. Keeping it opaque here means the domain layer never
/// imports `cloud_firestore`.
class TransactionPage {
  const TransactionPage({required this.items, required this.hasMore, this.cursor});

  final List<TransactionEntity> items;
  final bool hasMore;
  final Object? cursor;
}
