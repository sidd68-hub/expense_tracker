import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/transaction_entity.dart';
import 'transaction_providers.dart';

part 'transaction_form_controller.g.dart';

@riverpod
class TransactionFormController extends _$TransactionFormController {
  @override
  FutureOr<void> build() {}

  Future<void> save(TransactionEntity transaction, {required bool isEdit}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(transactionRepositoryProvider);
      if (isEdit) {
        await repository.update(transaction);
      } else {
        await repository.create(transaction);
      }
    });
  }
}

/// Loads a single transaction for editing. `autoDispose.family` so each
/// transaction id gets its own cached fetch and it's released once the edit
/// screen closes.
@riverpod
Future<TransactionEntity?> transactionById(Ref ref, String id) {
  return ref.watch(transactionRepositoryProvider).getById(id);
}
