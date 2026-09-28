import '../../../core/common/utils/money.dart';
import 'entities/budget_entity.dart';

enum BudgetStatus { ok, warning, exceeded }

/// A budget joined with how much has actually been spent — everything a
/// widget needs to render a progress bar, with no Firestore/UI knowledge.
class BudgetProgress {
  const BudgetProgress({required this.budget, required this.spent});

  final BudgetEntity budget;
  final MoneyAmount spent;

  MoneyAmount get limit => MoneyAmount(minorUnits: budget.limitMinor, currency: budget.currency);

  MoneyAmount get remaining {
    final remainingMinor = budget.limitMinor - spent.minorUnits;
    return MoneyAmount(minorUnits: remainingMinor, currency: budget.currency);
  }

  /// 0-100+; can exceed 100 when over budget.
  int get percentUsed {
    if (budget.limitMinor <= 0) return 0;
    return ((spent.minorUnits / budget.limitMinor) * 100).round();
  }

  /// Status is driven by the budget's own [BudgetEntity.alertThresholds]
  /// (default [80, 100]) so a user who changes their warning threshold sees
  /// it reflected immediately, per rule "make thresholds configurable".
  BudgetStatus get status => BudgetCalculator.statusFor(percentUsed, budget.alertThresholds);
}

class BudgetCalculator {
  const BudgetCalculator._();

  static BudgetStatus statusFor(int percentUsed, List<int> thresholds) {
    if (percentUsed >= 100) return BudgetStatus.exceeded;

    final warnThreshold = thresholds.where((t) => t < 100 && t > 0).fold<int?>(
          null,
          (min, t) => min == null || t < min ? t : min,
        );
    if (warnThreshold != null && percentUsed >= warnThreshold) {
      return BudgetStatus.warning;
    }
    return BudgetStatus.ok;
  }
}
