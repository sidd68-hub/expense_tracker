import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../accounts/presentation/controllers/account_providers.dart';
import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../../categories/presentation/controllers/category_providers.dart';
import '../../../settings/presentation/controllers/settings_providers.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../../../services/notifications/notification_service.dart';
import '../../data/inbox_repository.dart';
import '../../domain/entities/inbox_entry.dart';
import '../../domain/inbox_resolver.dart';

part 'automation_providers.g.dart';

final inboxRepositoryProvider = Provider<InboxRepository>((ref) {
  final uid = ref.watch(currentUidProvider);
  return InboxRepository(uid: uid);
});

final inboxProvider = StreamProvider.autoDispose<List<InboxEntry>>((ref) {
  return ref.watch(inboxRepositoryProvider).watchInbox();
});

/// One resolved entry ready to render in the review screen.
class InboxReviewItem {
  const InboxReviewItem({required this.entry, required this.resolved});

  final InboxEntry entry;
  final ResolvedInbox resolved;
}

final inboxReviewItemsProvider = Provider.autoDispose<AsyncValue<List<InboxReviewItem>>>((ref) {
  final inboxAsync = ref.watch(inboxProvider);
  final categories = ref.watch(allCategoriesProvider).value ?? const [];
  final accounts = ref.watch(activeAccountsProvider).value ?? const [];

  return inboxAsync.whenData((entries) {
    return entries
        .map((entry) => InboxReviewItem(
              entry: entry,
              resolved: InboxResolver.resolve(entry, categories: categories, accounts: accounts),
            ))
        .toList();
  });
});

@riverpod
class AutomationTokenController extends _$AutomationTokenController {
  @override
  FutureOr<void> build() {}

  /// Generates a fresh random token, persists it to Settings, and returns it
  /// for one-time display — regenerating overwrites (and so immediately
  /// invalidates) any previous token.
  Future<String?> regenerate() async {
    state = const AsyncLoading();
    final token = _randomToken();
    state = await AsyncValue.guard(() async {
      final settings = await ref.read(userSettingsProvider.future);
      await ref.read(settingsRepositoryProvider).updateSettings(settings.copyWith(automationToken: token));
    });
    return state.hasError ? null : token;
  }

  String _randomToken() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }
}

@riverpod
class InboxCommitController extends _$InboxCommitController {
  @override
  FutureOr<void> build() {}

  /// Commits [draft] as a real transaction (after any edits the user made in
  /// the review screen), skipping creation if the same externalTransactionId
  /// already produced a transaction — then removes the inbox entry either
  /// way (rule #21: never insert the same transaction twice).
  Future<void> commit(InboxEntry entry, {required TransactionEntity draft}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final transactionRepository = ref.read(transactionRepositoryProvider);
      if (entry.externalTransactionId != null) {
        final existing = await transactionRepository.findByExternalTransactionId(entry.externalTransactionId!);
        if (existing == null) {
          await transactionRepository.create(draft);
        }
      } else {
        await transactionRepository.create(draft);
      }
      await ref.read(inboxRepositoryProvider).discard(entry.id);
    });
  }

  Future<void> discard(String entryId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(inboxRepositoryProvider).discard(entryId));
  }
}

/// Watched once (from RootShell) for the session. When Automatic Mode is on
/// (automationConfirmationMode == false), silently commits any inbox entry
/// whose category/account names fully resolved — everything else still
/// waits in the review screen, since an unresolved field means the app
/// isn't sure, and rule #16 says never guess with real financial data.
final inboxAutoProcessEffectProvider = Provider<void>((ref) {
  ref.listen(inboxReviewItemsProvider, (previous, next) async {
    next.whenData((items) async {
      if (items.isEmpty) return;
      final settings = await ref.read(userSettingsProvider.future);
      if (settings.automationConfirmationMode) return;

      for (final item in items) {
        if (!item.resolved.isFullyResolved) continue;
        final draft = InboxResolver.buildDraft(item.entry, item.resolved);
        await ref.read(inboxCommitControllerProvider.notifier).commit(item.entry, draft: draft);
        if (settings.importedTransactionNotificationsEnabled) {
          await NotificationService.instance.show(
            title: 'Transaction imported',
            body: '${draft.amount.format()}${draft.merchant != null ? ' at ${draft.merchant}' : ''}',
            channelId: 'imported_transactions',
            channelName: 'Imported transactions',
          );
        }
      }
    });
  });
});
