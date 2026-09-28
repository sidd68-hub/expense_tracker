import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../services/notifications/notification_service.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../settings/presentation/controllers/settings_providers.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/budget_notification_tracker.dart';
import '../../domain/entities/budget_entity.dart';
import 'budget_providers.dart';

final _previousBudgetStatusesProvider = StateProvider<Map<String, BudgetStatus>>((ref) => {});

/// Watched once (from [RootShell]) for the lifetime of a signed-in session.
/// Whenever this month's budget progress recomputes, fires a local
/// notification for any budget that just crossed a stricter threshold —
/// never for one that was already at that status, so the user isn't spammed
/// on every dashboard refresh.
final budgetNotificationEffectProvider = Provider<void>((ref) {
  ref.listen(budgetsWithProgressProvider, (previous, next) {
    next.whenData((progressList) async {
      if (progressList.isEmpty) return;

      final settings = await ref.read(userSettingsProvider.future);
      if (!settings.budgetNotificationsEnabled) return;

      final previousStatuses = ref.read(_previousBudgetStatusesProvider);
      final escalations = BudgetNotificationTracker.findEscalations(progressList, previousStatuses);
      ref.read(_previousBudgetStatusesProvider.notifier).state = BudgetNotificationTracker.nextStatuses(progressList);

      if (escalations.isEmpty) return;
      final categories = await ref.read(allCategoriesProvider.future);

      for (final progress in escalations) {
        final categoryName = progress.budget.scope == BudgetScope.overall
            ? 'Overall'
            : categories.where((c) => c.id == progress.budget.categoryId).map((c) => c.name).firstOrDefault('This category');

        final title = progress.status == BudgetStatus.exceeded ? 'Budget exceeded' : 'Budget warning';
        final body = '$categoryName budget is at ${progress.percentUsed}% '
            '(${progress.spent.format()} of ${progress.limit.format()})';
        await NotificationService.instance.show(
          title: title,
          body: body,
          channelId: 'budget_alerts',
          channelName: 'Budget alerts',
        );
      }
    });
  });
});

extension _FirstOrDefault<T> on Iterable<T> {
  T firstOrDefault(T fallback) {
    for (final item in this) {
      return item;
    }
    return fallback;
  }
}
