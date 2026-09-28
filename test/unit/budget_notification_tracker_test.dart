import 'package:expense_tracker/core/common/utils/money.dart';
import 'package:expense_tracker/features/budgets/domain/budget_calculator.dart';
import 'package:expense_tracker/features/budgets/domain/budget_notification_tracker.dart';
import 'package:expense_tracker/features/budgets/domain/entities/budget_entity.dart';
import 'package:flutter_test/flutter_test.dart';

BudgetProgress _progress(String id, int spentMinor, {int limitMinor = 100000}) {
  final budget = BudgetEntity(
    id: id,
    scope: BudgetScope.category,
    categoryId: 'food',
    monthKey: '2026-01',
    limitMinor: limitMinor,
  );
  return BudgetProgress(budget: budget, spent: MoneyAmount(minorUnits: spentMinor));
}

void main() {
  group('BudgetNotificationTracker.findEscalations', () {
    test('a fresh budget with no prior status still notifies if already over budget', () {
      final current = [_progress('b1', 120000)]; // 120% -> exceeded
      final result = BudgetNotificationTracker.findEscalations(current, {});
      expect(result.map((p) => p.budget.id), ['b1']);
    });

    test('does not notify again for a budget that stays in the same status', () {
      final current = [_progress('b1', 85000)]; // 85% -> warning
      final previous = {'b1': BudgetStatus.warning};
      final result = BudgetNotificationTracker.findEscalations(current, previous);
      expect(result, isEmpty);
    });

    test('notifies when status escalates from warning to exceeded', () {
      final current = [_progress('b1', 110000)]; // exceeded
      final previous = {'b1': BudgetStatus.warning};
      final result = BudgetNotificationTracker.findEscalations(current, previous);
      expect(result.map((p) => p.budget.id), ['b1']);
    });

    test('does not notify when a budget improves back to ok', () {
      final current = [_progress('b1', 10000)]; // 10% -> ok
      final previous = {'b1': BudgetStatus.exceeded};
      final result = BudgetNotificationTracker.findEscalations(current, previous);
      expect(result, isEmpty);
    });

    test('only escalated budgets are returned among several', () {
      final current = [
        _progress('stable', 10000), // ok, was ok
        _progress('escalating', 90000), // warning, was ok
      ];
      final previous = {'stable': BudgetStatus.ok, 'escalating': BudgetStatus.ok};
      final result = BudgetNotificationTracker.findEscalations(current, previous);
      expect(result.map((p) => p.budget.id), ['escalating']);
    });
  });

  group('BudgetNotificationTracker.nextStatuses', () {
    test('captures the latest status for every budget', () {
      final current = [_progress('b1', 50000), _progress('b2', 120000)];
      final result = BudgetNotificationTracker.nextStatuses(current);
      expect(result, {'b1': BudgetStatus.ok, 'b2': BudgetStatus.exceeded});
    });
  });
}
