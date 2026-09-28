import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/accounts/presentation/controllers/account_providers.dart';
import '../../features/categories/presentation/controllers/category_providers.dart';

/// Seeds default categories/accounts the first time a user signs in.
/// Watched once from the router redirect after auth succeeds; safe to
/// evaluate repeatedly since both seed methods no-op once data exists.
final userBootstrapProvider = FutureProvider.autoDispose<void>((ref) async {
  final categoryRepo = ref.watch(categoryRepositoryProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  await Future.wait([
    categoryRepo.seedDefaultsIfEmpty(),
    accountRepo.seedDefaultsIfEmpty(),
  ]);
});
