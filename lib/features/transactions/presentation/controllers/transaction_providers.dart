import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return TransactionRepositoryImpl(uid: uid);
});

final recentTransactionsProvider = StreamProvider.autoDispose<List<TransactionEntity>>((ref) {
  return ref.watch(transactionRepositoryProvider).watchRecent();
});
