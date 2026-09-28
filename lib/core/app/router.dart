import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/presentation/screens/accounts_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/automation/presentation/screens/automation_screen.dart';
import '../../features/automation/presentation/screens/inbox_review_screen.dart';
import '../../features/auth/presentation/controllers/auth_providers.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/budgets/presentation/screens/budgets_screen.dart';
import '../../features/categories/presentation/screens/categories_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/transactions/domain/entities/transaction_type.dart';
import '../../features/transactions/presentation/screens/add_edit_transaction_screen.dart';
import '../../features/transactions/presentation/screens/transactions_screen.dart';
import 'root_shell.dart';

const _authRoutes = {'/sign-in', '/sign-up', '/forgot-password'};

/// Recreated whenever auth state changes — cheap for this app's size and
/// avoids a separate ChangeNotifier bridge just to trigger redirects.
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (authState.isLoading) return null;
      final isSignedIn = authState.value != null;
      final isAuthRoute = _authRoutes.contains(state.matchedLocation);
      if (!isSignedIn && !isAuthRoute) return '/sign-in';
      if (isSignedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/sign-in', builder: (context, state) => const SignInScreen()),
      GoRoute(path: '/sign-up', builder: (context, state) => const SignUpScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(
        path: '/transactions/add',
        builder: (context, state) {
          final typeParam = state.uri.queryParameters['type'];
          final initialType = typeParam == null ? null : TransactionType.fromName(typeParam);
          return AddEditTransactionScreen(initialType: initialType);
        },
      ),
      GoRoute(
        path: '/transactions/:id/edit',
        builder: (context, state) => AddEditTransactionScreen(transactionId: state.pathParameters['id']),
      ),
      GoRoute(path: '/categories', builder: (context, state) => const CategoriesScreen()),
      GoRoute(path: '/accounts', builder: (context, state) => const AccountsScreen()),
      GoRoute(path: '/budgets', builder: (context, state) => const BudgetsScreen()),
      GoRoute(path: '/automation', builder: (context, state) => const AutomationScreen()),
      GoRoute(path: '/automation/inbox', builder: (context, state) => const InboxReviewScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RootShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/', builder: (context, state) => const DashboardScreen())]),
          StatefulShellBranch(
            routes: [GoRoute(path: '/transactions', builder: (context, state) => const TransactionsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/analytics', builder: (context, state) => const AnalyticsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen())],
          ),
        ],
      ),
    ],
  );
});
