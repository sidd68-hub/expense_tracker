import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_type.dart';

part 'account_entity.freezed.dart';

@freezed
abstract class AccountEntity with _$AccountEntity {
  const factory AccountEntity({
    required String id,
    required String name,
    required AccountType type,
    @Default(false) bool isArchived,
    DateTime? createdAt,
  }) = _AccountEntity;
}
