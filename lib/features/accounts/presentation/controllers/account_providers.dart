import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../data/repositories/account_repository_impl.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/repositories/account_repository.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return AccountRepositoryImpl(uid: uid);
});

final activeAccountsProvider = StreamProvider.autoDispose<List<AccountEntity>>((ref) {
  return ref.watch(accountRepositoryProvider).watchAccounts();
});
