import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/utils/money.dart';
import '../../../transactions/domain/entities/transaction_type.dart';

part 'recurring_transaction_entity.freezed.dart';

enum RecurrenceFrequency {
  daily,
  weekly,
  monthly,
  yearly;

  static RecurrenceFrequency fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => RecurrenceFrequency.monthly,
      );
}

@freezed
abstract class RecurringTransactionEntity with _$RecurringTransactionEntity {
  const factory RecurringTransactionEntity({
    required String id,
    required TransactionType type,
    required MoneyAmount amount,
    required String categoryId,
    required String accountId,
    required RecurrenceFrequency frequency,
    required DateTime startDate,
    DateTime? endDate,
    DateTime? nextRunDate,
    String? remark,
    @Default(true) bool isActive,
  }) = _RecurringTransactionEntity;
}
