import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../services/firebase/firestore_paths.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_type.dart';
import '../../domain/repositories/account_repository.dart';
import '../models/account_dto.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.accounts(uid));

  @override
  Stream<List<AccountEntity>> watchAccounts({bool includeArchived = false}) {
    Query<Map<String, dynamic>> query = _collection;
    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }
    return query.orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs.map(AccountDto.fromSnapshot).toList(),
        );
  }

  @override
  Future<AccountEntity?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return AccountDto.fromSnapshot(doc);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> create(AccountEntity account) async {
    try {
      final ref = await _collection.add(AccountDto.toMap(account));
      return ref.id;
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> update(AccountEntity account) async {
    try {
      await _collection.doc(account.id).update(AccountDto.toMap(account));
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> archive(String id) async {
    try {
      await _collection.doc(id).update({'isArchived': true});
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final usage = await _firestore
          .collection(FirestorePaths.transactions(uid))
          .where('accountId', isEqualTo: id)
          .limit(1)
          .count()
          .get();
      if ((usage.count ?? 0) > 0) {
        await archive(id);
        return;
      }
      await _collection.doc(id).delete();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> seedDefaultsIfEmpty() async {
    try {
      final existing = await _collection.limit(1).get();
      if (existing.docs.isNotEmpty) return;
      await _collection.add({
        'name': 'Cash',
        'type': AccountType.cash.name,
        'isArchived': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
