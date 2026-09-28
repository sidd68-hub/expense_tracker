import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/utils/money.dart';
import 'transaction_source.dart';
import 'transaction_type.dart';

part 'transaction_entity.freezed.dart';

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const TransactionEntity._();

  const factory TransactionEntity({
    required String id,
    required TransactionType type,
    required MoneyAmount amount,
    required DateTime date,
    /// Required for expense/income, null for transfer.
    String? categoryId,
    /// Required for expense/income, null for transfer.
    String? accountId,
    /// Transfer only.
    String? fromAccountId,
    /// Transfer only.
    String? toAccountId,
    String? merchant,
    String? remark,
    @Default(TransactionSource.manual) TransactionSource source,
    @Default(false) bool isImported,
    String? externalTransactionId,
    String? automationSource,
    @Default(TransactionStatus.confirmed) TransactionStatus status,
    @Default(false) bool isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TransactionEntity;

  bool get isTransfer => type == TransactionType.transfer;
  bool get isExpense => type == TransactionType.expense;
  bool get isIncome => type == TransactionType.income;
}
