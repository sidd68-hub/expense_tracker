import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/category_repository_impl.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return CategoryRepositoryImpl(uid: uid);
});

final expenseCategoriesProvider = StreamProvider.autoDispose<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories(type: CategoryType.expense);
});

final incomeCategoriesProvider = StreamProvider.autoDispose<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories(type: CategoryType.income);
});

final allCategoriesProvider = StreamProvider.autoDispose<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
});
