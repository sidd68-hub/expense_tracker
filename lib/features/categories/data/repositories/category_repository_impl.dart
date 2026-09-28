import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/exception_mapper.dart';
import '../../../../services/firebase/firestore_paths.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_type.dart';
import '../../domain/entities/default_categories.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_dto.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl({required this.uid, FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final String uid;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(FirestorePaths.categories(uid));

  @override
  Stream<List<CategoryEntity>> watchCategories({CategoryType? type, bool includeArchived = false}) {
    Query<Map<String, dynamic>> query = _collection;
    if (type != null) {
      query = query.where('type', isEqualTo: type.name);
    }
    if (!includeArchived) {
      query = query.where('isArchived', isEqualTo: false);
    }
    return query.orderBy('name').snapshots().map(
          (snapshot) => snapshot.docs.map(CategoryDto.fromSnapshot).toList(),
        );
  }

  @override
  Future<CategoryEntity?> getById(String id) async {
    try {
      final doc = await _collection.doc(id).get();
      if (!doc.exists) return null;
      return CategoryDto.fromSnapshot(doc);
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<String> create(CategoryEntity category) async {
    try {
      final ref = await _collection.add(CategoryDto.toMap(category));
      return ref.id;
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }

  @override
  Future<void> update(CategoryEntity category) async {
    try {
      await _collection.doc(category.id).update(CategoryDto.toMap(category));
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
      final usageCount = await _firestore
          .collection(FirestorePaths.transactions(uid))
          .where('categoryId', isEqualTo: id)
          .limit(1)
          .count()
          .get();
      if ((usageCount.count ?? 0) > 0) {
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

      final batch = _firestore.batch();
      for (final seed in DefaultCategorySeed.all) {
        final docRef = _collection.doc();
        batch.set(docRef, {
          'name': seed.name,
          'type': seed.type.name,
          'iconKey': seed.iconKey,
          'color': seed.color,
          'isArchived': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      throw mapExceptionToFailure(e);
    }
  }
}
