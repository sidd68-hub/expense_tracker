import '../entities/category_entity.dart';
import '../entities/category_type.dart';

abstract class CategoryRepository {
  /// All non-archived categories, optionally filtered by [type].
  Stream<List<CategoryEntity>> watchCategories({CategoryType? type, bool includeArchived = false});

  Future<CategoryEntity?> getById(String id);

  Future<String> create(CategoryEntity category);

  Future<void> update(CategoryEntity category);

  /// Categories are never hard-deleted if transactions reference them —
  /// this archives instead. Hard delete is only safe for a category with
  /// zero transactions, which the repository verifies before deleting.
  Future<void> archive(String id);

  Future<void> delete(String id);

  /// Seeds `users/{uid}/categories` with the default set on first sign-in.
  /// No-ops if the collection already has any categories.
  Future<void> seedDefaultsIfEmpty();
}
