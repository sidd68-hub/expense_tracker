import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common/widgets/state_views.dart';
import '../../../auth/presentation/controllers/auth_providers.dart';
import '../../../settings/presentation/controllers/settings_providers.dart';
import '../controllers/automation_providers.dart';

/// This app runs on Firebase's free Spark plan (no Cloud Functions), so
/// automation capture works via a direct, token-gated Firestore write
/// instead of a server endpoint — see firestore.rules' automation_inbox
/// rule. The Firestore REST doc-create endpoint for the signed-in user.
String _inboxUrl(String uid) =>
    'https://firestore.googleapis.com/v1/projects/expense-tracker-sid/databases/(default)/documents/users/$uid/automation_inbox';

const _payloadTemplate = '''
{
  "fields": {
    "token": {"stringValue": "YOUR_TOKEN"},
    "amount": {"integerValue": "25000"},
    "type": {"stringValue": "expense"},
    "merchant": {"stringValue": "ABC Restaurant"},
    "categoryName": {"stringValue": "Food"},
    "remark": {"stringValue": ""},
    "source": {"stringValue": "phonepe"},
    "platform": {"stringValue": "ios"},
    "createdAt": {"timestampValue": "2026-09-08T20:15:00Z"}
  }
}''';

class AutomationScreen extends ConsumerWidget {
  const AutomationScreen({super.key});

  Future<void> _regenerateToken(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate a new token?'),
        content: const Text('Any Shortcut or Macro using the current token will stop working until you update it.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Generate')),
        ],
      ),
    );
    if (confirmed != true) return;

    final token = await ref.read(automationTokenControllerProvider.notifier).regenerate();
    if (!context.mounted) return;
    final state = ref.read(automationTokenControllerProvider);
    if (state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
      return;
    }
    if (token == null) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Your automation token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paste this into the "token" field of your Shortcut/Macro payload.'),
            const SizedBox(height: 12),
            SelectableText(token, style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: token));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
            },
            child: const Text('Copy'),
          ),
          FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(userSettingsProvider);
    final inboxCountAsync = ref.watch(inboxProvider);
    final uid = ref.watch(authStateChangesProvider).value?.uid;
    final isBusy = ref.watch(automationTokenControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Automation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.inbox_outlined),
              title: const Text('Review imported transactions'),
              subtitle: inboxCountAsync.when(
                data: (items) => Text(items.isEmpty ? 'Nothing pending' : '${items.length} waiting for review'),
                loading: () => const Text('Loading…'),
                error: (_, _) => const Text('—'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/automation/inbox'),
            ),
          ),
          const SizedBox(height: 24),
          Text('Endpoint URL', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Runs on the free Firebase plan — no server, just a token-gated Firestore write.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          if (uid != null)
            Card(
              child: ListTile(
                title: SelectableText(_inboxUrl(uid), style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
                trailing: IconButton(
                  icon: const Icon(Icons.copy_outlined),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _inboxUrl(uid)));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
                  },
                ),
              ),
            ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('POST body template', style: Theme.of(context).textTheme.labelLarge),
                      IconButton(
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        onPressed: () {
                          Clipboard.setData(const ClipboardData(text: _payloadTemplate));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
                        },
                      ),
                    ],
                  ),
                  SelectableText(_payloadTemplate, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Your token', style: Theme.of(context).textTheme.titleMedium),
              FilledButton.icon(
                onPressed: isBusy ? null : () => _regenerateToken(context, ref),
                icon: const Icon(Icons.autorenew, size: 18),
                label: const Text('Generate'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          settingsAsync.when(
            loading: () => const LoadingView(),
            error: (error, _) => ErrorView(message: error.toString()),
            data: (settings) => Card(
              child: ListTile(
                leading: const Icon(Icons.vpn_key_outlined),
                title: Text(settings.automationToken != null ? 'Token generated' : 'No token yet'),
                subtitle: const Text('Only shown once — regenerate if you\'ve lost it.'),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Capture mode', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (settings) => Card(
              child: SwitchListTile(
                title: const Text('Confirmation mode'),
                subtitle: const Text(
                  'Recommended. Off means fully-matched imports save immediately with no review.',
                ),
                value: settings.automationConfirmationMode,
                onChanged: (value) {
                  ref.read(settingsRepositoryProvider).updateSettings(
                        settings.copyWith(automationConfirmationMode: value),
                      );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text('Setup guides', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_iphone),
                  title: const Text('iOS Shortcuts setup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Setup guide arrives in Phase 6')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.android),
                  title: const Text('Android MacroDroid setup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Setup guide arrives in Phase 7')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
