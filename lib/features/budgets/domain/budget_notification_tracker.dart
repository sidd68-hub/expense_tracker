import 'budget_calculator.dart';

/// Decides which budgets should fire a new notification this check, given
/// the status each budget was at last time. A notification only fires when
/// a budget's status *escalates* (ok → warning, warning → exceeded, or
/// ok → exceeded) — re-checking an already-warned budget that's still in
/// the same state must never notify again (rule: "do not spam the user").
///
/// Pure and I/O-free so the escalation rule itself is unit-testable
/// independent of flutter_local_notifications.
class BudgetNotificationTracker {
  const BudgetNotificationTracker._();

  static int _severity(BudgetStatus status) => switch (status) {
        BudgetStatus.ok => 0,
        BudgetStatus.warning => 1,
        BudgetStatus.exceeded => 2,
      };

  /// Returns the subset of [current] whose status is strictly more severe
  /// than what's recorded in [previousStatuses] (keyed by budget id).
  /// A budget with no prior entry is treated as having started at "ok",
  /// so a budget freshly created already over its limit still notifies once.
  static List<BudgetProgress> findEscalations(
    List<BudgetProgress> current,
    Map<String, BudgetStatus> previousStatuses,
  ) {
    return current.where((progress) {
      final previous = previousStatuses[progress.budget.id] ?? BudgetStatus.ok;
      return _severity(progress.status) > _severity(previous);
    }).toList();
  }

  /// The status map to persist for next time — always the latest status per
  /// budget, regardless of whether it escalated.
  static Map<String, BudgetStatus> nextStatuses(List<BudgetProgress> current) {
    return {for (final p in current) p.budget.id: p.status};
  }
}
