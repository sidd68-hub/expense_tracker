import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../services/firebase/firestore_paths.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_dto.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.budgets(uid));

  @override
  Stream<List<BudgetEntity>> watchBudgets(String monthKey) {
    return _collection
        .where('monthKey', isEqualTo: monthKey)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(BudgetDto.fromSnapshot).toList());
  }

  @override
  Future<String> create(BudgetEntity budget) async {
    try {
      final ref = await _collection.add(BudgetDto.toMap(budget));
      return ref.id;
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> update(BudgetEntity budget) async {
    try {
      await _collection.doc(budget.id).update(BudgetDto.toMap(budget));
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _collection.doc(id).delete();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
