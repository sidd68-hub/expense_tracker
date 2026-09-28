import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/automation/presentation/controllers/automation_providers.dart';
import '../../features/budgets/presentation/controllers/budget_notification_provider.dart';
import 'app_bootstrap.dart';

/// Bottom-nav shell wrapping Dashboard / Transactions / Analytics / Settings,
/// per the navigation structure in the architecture proposal.
class RootShell extends ConsumerWidget {
  const RootShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fire-and-forget: seeds default categories/accounts on first sign-in.
    ref.watch(userBootstrapProvider);
    // Keeps budget-threshold notifications active for the session.
    ref.watch(budgetNotificationEffectProvider);
    // Auto-commits fully-resolved automation inbox entries when Automatic Mode is on.
    ref.watch(inboxAutoProcessEffectProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Transactions'),
          NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
