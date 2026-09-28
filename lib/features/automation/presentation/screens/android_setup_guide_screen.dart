import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Step-by-step MacroDroid setup, written against this app's actual backend:
/// a token-gated, unauthenticated Firestore document create (no Cloud
/// Functions). Keep field names in sync with firestore.rules'
/// `isValidInboxEntry` and `InboxDto.fromSnapshot`.
class AndroidSetupGuideScreen extends StatelessWidget {
  const AndroidSetupGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Android MacroDroid setup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('1. Get your token and endpoint', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Open Settings → Automation, tap "Generate", and copy the token and endpoint URL shown there.',
          ),
          const SizedBox(height: 20),
          Text('2. Install MacroDroid', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Install from the Play Store. When creating the macro below, grant SMS and/or '
            'Notification access only if you choose that trigger — don\'t grant permissions you won\'t use.',
          ),
          const SizedBox(height: 20),
          Text('3. Choose a trigger', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          _TriggerOption(
            context: context,
            title: 'Notification Received (recommended)',
            body: 'Category: Applications → Notification Received. App: your bank\'s app or PhonePe/'
                'Google Pay/etc. This is the only route that works for payment-app alerts (banks '
                'that only notify via their app, not SMS) — Android genuinely allows automation apps '
                'to read notification text, unlike iOS. Requires granting MacroDroid "Notification '
                'access" once in Android Settings → the prompt MacroDroid shows handles this.',
          ),
          const SizedBox(height: 8),
          _TriggerOption(
            context: context,
            title: 'SMS Received (fallback)',
            body: 'Category: Messaging → SMS Received. Message Content filter: Contains → "debited" '
                '(or whatever word your bank uses). Works only for actual SMS alerts, and on recent '
                'Android versions the Play Store build of MacroDroid may have restricted SMS access — '
                'if the SMS trigger doesn\'t fire, use Notification Received instead.',
          ),
          const SizedBox(height: 20),
          Text('4. Build the macro actions', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const _StepTile(
            number: '4.1',
            title: 'Dialog → List Selection Dialog',
            body: 'Title: "Type". Items: expense, income, transfer (lowercase — must match exactly). Store into lv_type.',
          ),
          const _StepTile(
            number: '4.2',
            title: 'Dialog → Get Text Input',
            body: 'Input Type: Numeric. Prompt: "Amount (₹)". Store into lv_amount.',
          ),
          const _StepTile(
            number: '4.3',
            title: 'Variables → Set Variable (Numeric)',
            body: 'lv_amount_minor = lv_amount × 100 — converts rupees to paise, matching how the app stores money.',
          ),
          const _StepTile(
            number: '4.4',
            title: 'Dialog → List Selection Dialog',
            body: 'Title: "Category". List your exact category names (check spelling in Settings → Categories). '
                'Store into lv_category. Skip for a transfer — use two text prompts for lv_from_account / lv_to_account instead.',
          ),
          const _StepTile(
            number: '4.5',
            title: 'Dialog → Get Text Input ×2',
            body: 'Prompt "Merchant" → lv_merchant, and "Remark" → lv_remark. Both optional, leave blank if unused.',
          ),
          const _StepTile(
            number: '4.6',
            title: 'Date/Time → Get Current Date/Time',
            body: 'Format: ISO 8601 (yyyy-MM-dd\'T\'HH:mm:ss\'Z\'). Store into lv_date.',
          ),
          const _StepTile(
            number: '4.7',
            title: 'Variables → Set Variable (Text) — build the JSON',
            body: 'MacroDroid has no native Dictionary action, so build the request body as a JSON string, '
                'inserting each [lv_xxx] via the variable picker to avoid typos. Firestore\'s REST API needs '
                'each field wrapped in a type — see the exact template below.',
          ),
          const SizedBox(height: 8),
          _CodeBlock(context: context, code: _jsonTemplate),
          const SizedBox(height: 12),
          const _StepTile(
            number: '4.8',
            title: 'Connectivity → HTTP Request',
            body: 'URL: your endpoint from step 1. Method: POST. Content Type: application/json. Body: lv_json.',
          ),
          const _StepTile(
            number: '4.9',
            title: 'Notifications → Show Notification',
            body: 'Title: "Expense Logged". Text: "[lv_amount] logged". Confirms the macro ran — the app '
                'shows the real transaction once you review/confirm it (or immediately in Automatic Mode).',
          ),
          const SizedBox(height: 20),
          Text('5. Exclude MacroDroid from battery optimization', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Android Settings → Battery → MacroDroid → Unrestricted. Without this, Android will kill the '
            'trigger in the background and it\'ll silently stop firing after a while.',
          ),
          const SizedBox(height: 20),
          Text('6. Test it', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Trigger the macro (send yourself a matching SMS, or a test payment notification) and check '
            'Settings → Automation → "Review imported transactions" in the app.',
          ),
        ],
      ),
    );
  }
}

class _TriggerOption extends StatelessWidget {
  const _TriggerOption({required this.context, required this.title, required this.body});

  final BuildContext context;
  final String title;
  final String body;

  @override
  Widget build(BuildContext _) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.title, required this.body});

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Text(number, style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 2),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.context, required this.code});

  final BuildContext context;
  final String code;

  @override
  Widget build(BuildContext _) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.copy_outlined, size: 18),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied')));
                },
              ),
            ),
            SelectableText(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

const _jsonTemplate = '''
{"fields":{
  "token":{"stringValue":"YOUR_TOKEN"},
  "amount":{"integerValue":"[lv_amount_minor]"},
  "type":{"stringValue":"[lv_type]"},
  "merchant":{"stringValue":"[lv_merchant]"},
  "categoryName":{"stringValue":"[lv_category]"},
  "remark":{"stringValue":"[lv_remark]"},
  "source":{"stringValue":"sms"},
  "platform":{"stringValue":"android"},
  "createdAt":{"timestampValue":"[lv_date]"}
}}''';
