import 'transaction_type.dart';

/// Filter/sort criteria for the transaction list screen. Kept as a single
/// plain value object so the repository can translate it into one Firestore
/// query instead of the UI composing ad-hoc `where` clauses.
class TransactionFilter {
  const TransactionFilter({
    this.types,
    this.categoryId,
    this.accountId,
    this.startDate,
    this.endDate,
    this.searchText,
    this.sortDescending = true,
  });

  final List<TransactionType>? types;
  final String? categoryId;
  final String? accountId;
  final DateTime? startDate;
  final DateTime? endDate;

  /// Matched client-side against merchant/remark (Firestore has no native
  /// full-text search); category name matching happens in the UI layer,
  /// which already has categories loaded.
  final String? searchText;

  final bool sortDescending;

  bool get hasSearch => searchText != null && searchText!.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionFilter &&
        _listEquals(types, other.types) &&
        categoryId == other.categoryId &&
        accountId == other.accountId &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        searchText == other.searchText &&
        sortDescending == other.sortDescending;
  }

  @override
  int get hashCode => Object.hash(
        types == null ? null : Object.hashAll(types!),
        categoryId,
        accountId,
        startDate,
        endDate,
        searchText,
        sortDescending,
      );

  static bool _listEquals(List<TransactionType>? a, List<TransactionType>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
