import 'package:expense_tracker/features/budgets/domain/budget_calculator.dart';
import 'package:expense_tracker/features/budgets/domain/entities/budget_entity.dart';
import 'package:expense_tracker/core/common/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetEntity _budget({int limitMinor = 800000, List<int> thresholds = const [80, 100]}) {
  return BudgetEntity(
    id: 'b1',
    scope: BudgetScope.category,
    categoryId: 'food',
    monthKey: '2026-01',
    limitMinor: limitMinor,
    alertThresholds: thresholds,
  );
}

void main() {
  group('BudgetCalculator.statusFor', () {
    test('below the lowest threshold is ok', () {
      expect(BudgetCalculator.statusFor(50, [80, 100]), BudgetStatus.ok);
    });

    test('at or above 80% but below 100% is a warning', () {
      expect(BudgetCalculator.statusFor(80, [80, 100]), BudgetStatus.warning);
      expect(BudgetCalculator.statusFor(95, [80, 100]), BudgetStatus.warning);
    });

    test('at or above 100% is exceeded', () {
      expect(BudgetCalculator.statusFor(100, [80, 100]), BudgetStatus.exceeded);
      expect(BudgetCalculator.statusFor(150, [80, 100]), BudgetStatus.exceeded);
    });

    test('respects a custom configured threshold', () {
      expect(BudgetCalculator.statusFor(60, [50, 100]), BudgetStatus.warning);
      expect(BudgetCalculator.statusFor(40, [50, 100]), BudgetStatus.ok);
    });
  });

  group('BudgetProgress', () {
    test('computes remaining and percentUsed correctly', () {
      final progress = BudgetProgress(budget: _budget(limitMinor: 100000), spent: const MoneyAmount(minorUnits: 40000));
      expect(progress.percentUsed, 40);
      expect(progress.remaining.minorUnits, 60000);
      expect(progress.status, BudgetStatus.ok);
    });

    test('flags exceeded when spend surpasses the limit, with negative remaining', () {
      final progress = BudgetProgress(budget: _budget(limitMinor: 100000), spent: const MoneyAmount(minorUnits: 120000));
      expect(progress.percentUsed, 120);
      expect(progress.remaining.minorUnits, -20000);
      expect(progress.status, BudgetStatus.exceeded);
    });

    test('a zero-limit budget never divides by zero', () {
      final progress = BudgetProgress(budget: _budget(limitMinor: 0), spent: const MoneyAmount(minorUnits: 500));
      expect(progress.percentUsed, 0);
    });
  });
}
