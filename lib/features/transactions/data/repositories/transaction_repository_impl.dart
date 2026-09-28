import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/common/utils/money.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../services/firebase/firestore_paths.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_filter.dart';
import '../../domain/entities/transaction_page.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_dto.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.transactions(uid));

  @override
  Stream<List<TransactionEntity>> watchRecent({int limit = 10}) {
    return _collection
        .where('isDeleted', isEqualTo: false)
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(TransactionDto.fromSnapshot).toList());
  }

  @override
  Future<TransactionPage> getPage({
    required TransactionFilter filter,
    int pageSize = 30,
    Object? startAfter,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection.where('isDeleted', isEqualTo: false);

      if (filter.types != null && filter.types!.isNotEmpty) {
        query = query.where('type', whereIn: filter.types!.map((t) => t.name).toList());
      }
      if (filter.categoryId != null) {
        query = query.where('categoryId', isEqualTo: filter.categoryId);
      }
      if (filter.accountId != null) {
        query = query.where('accountId', isEqualTo: filter.accountId);
      }
      if (filter.startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(filter.startDate!));
      }
      if (filter.endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(filter.endDate!));
      }

      query = query.orderBy('date', descending: filter.sortDescending);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter as DocumentSnapshot<Map<String, dynamic>>);
      }

      // Fetch one extra document to cheaply know whether another page exists.
      final snapshot = await query.limit(pageSize + 1).get();
      final docs = snapshot.docs;
      final hasMore = docs.length > pageSize;
      final pageDocs = hasMore ? docs.sublist(0, pageSize) : docs;

      var items = pageDocs.map(TransactionDto.fromSnapshot).toList();

      if (filter.hasSearch) {
        final needle = filter.searchText!.trim().toLowerCase();
        items = items.where((t) {
          return (t.merchant?.toLowerCase().contains(needle) ?? false) ||
              (t.remark?.toLowerCase().contains(needle) ?? false);
        }).toList();
      }

      return TransactionPage(
        items: items,
        hasMore: hasMore,
        cursor: pageDocs.isEmpty ? null : pageDocs.last,
      );
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<TransactionEntity?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return TransactionDto.fromSnapshot(doc);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<TransactionEntity?> findByExternalTransactionId(String externalTransactionId) async {
    try {
      final snapshot =
          await _collection.where('externalTransactionId', isEqualTo: externalTransactionId).limit(1).get();
      if (snapshot.docs.isEmpty) return null;
      return TransactionDto.fromSnapshot(snapshot.docs.first);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> create(TransactionEntity transaction) async {
    try {
      final ref = await _collection.add(TransactionDto.toMap(transaction));
      return ref.id;
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> update(TransactionEntity transaction) async {
    try {
      await _collection.doc(transaction.id).update(TransactionDto.toMap(transaction));
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> softDelete(String id) async {
    try {
      await _collection.doc(id).update({'isDeleted': true, 'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> restore(String id) async {
    try {
      await _collection.doc(id).update({'isDeleted': false, 'updatedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<MoneyAmount> getAggregateTotal({
    required TransactionType type,
    DateTime? start,
    DateTime? end,
    String? categoryId,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection
          .where('isDeleted', isEqualTo: false)
          .where('type', isEqualTo: type.name);
      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      if (start != null) {
        query = query.where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start));
      }
      if (end != null) {
        query = query.where('date', isLessThanOrEqualTo: Timestamp.fromDate(end));
      }
      final snapshot = await query.aggregate(sum('amountMinor')).get();
      final total = (snapshot.getSum('amountMinor') ?? 0).round();
      return MoneyAmount(minorUnits: total);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<List<TransactionEntity>> getTransactionsInRange({
    required DateTime start,
    required DateTime end,
    TransactionType? type,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _collection
          .where('isDeleted', isEqualTo: false)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end));
      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
      }
      final snapshot = await query.orderBy('date', descending: true).get();
      return snapshot.docs.map(TransactionDto.fromSnapshot).toList();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
