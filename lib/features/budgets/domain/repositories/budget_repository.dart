import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Stream<List<BudgetEntity>> watchBudgets(String monthKey);

  Future<String> create(BudgetEntity budget);

  Future<void> update(BudgetEntity budget);

  Future<void> delete(String id);
}
