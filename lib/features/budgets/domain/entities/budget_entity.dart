import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_entity.freezed.dart';

enum BudgetScope {
  overall,
  category;

  static BudgetScope fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => BudgetScope.overall,
      );
}

@freezed
abstract class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String id,
    required BudgetScope scope,
    /// Required when [scope] is [BudgetScope.category], null for overall budgets.
    String? categoryId,
    /// "yyyy-MM" — a budget is scoped to a single calendar month.
    required String monthKey,
    required int limitMinor,
    @Default('INR') String currency,
    @Default([80, 100]) List<int> alertThresholds,
    DateTime? createdAt,
  }) = _BudgetEntity;
}
