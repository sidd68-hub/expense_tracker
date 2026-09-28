import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Step-by-step iOS Shortcuts setup, written against this app's actual
/// backend: a token-gated, unauthenticated Firestore document create (no
/// Cloud Functions — see AutomationScreen). Every field/value here must stay
/// in sync with firestore.rules' `isValidInboxEntry` and
/// `InboxDto.fromSnapshot`.
class IosSetupGuideScreen extends StatelessWidget {
  const IosSetupGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('iOS Shortcuts setup')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LimitationBanner(context: context),
          const SizedBox(height: 20),
          Text('1. Get your token and endpoint', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Open Settings → Automation, tap "Generate", and copy the token shown. '
            'Also copy the endpoint URL shown there — you\'ll paste both into the Shortcut below.',
          ),
          const SizedBox(height: 20),
          Text('2. Create the Shortcut', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('Open the Shortcuts app → tap + → name it "Log Expense". Add these actions in order:'),
          const SizedBox(height: 12),
          const _StepTile(
            number: '2.1',
            title: 'Choose from Menu',
            body: 'Prompt: "Type". Add three items: Expense, Income, Transfer. '
                'Under each, add a Text action containing the lowercase value the app expects — '
                '"expense", "income", "transfer" respectively (not the capitalized menu label) — '
                'and rename its output variable to Type (same name in all three branches).',
          ),
          const _StepTile(
            number: '2.2',
            title: 'Ask for Input',
            body: 'Input Type: Number. Prompt: "Amount (₹)". Rename output to Amount.',
          ),
          const _StepTile(
            number: '2.3',
            title: 'Calculate',
            body: 'Amount × 100, then Round — this converts rupees to paise, matching how '
                'the app stores money internally. Rename output to AmountMinor.',
          ),
          const _StepTile(
            number: '2.4',
            title: 'Choose from List',
            body: 'List the exact names of your expense/income categories (open Settings → '
                'Categories in the app to check spelling). Rename output to CategoryName. '
                'Skip this action entirely for a Transfer.',
          ),
          const _StepTile(
            number: '2.5',
            title: 'Ask for Input (Text) ×2',
            body: 'Prompt "Merchant" → rename to Merchant, and Prompt "Remark" → rename to Remark. Both optional — leave blank if not needed.',
          ),
          const _StepTile(
            number: '2.6',
            title: 'Current Date → Format Date',
            body: 'Format: ISO8601. Rename output to DateISO.',
          ),
          const _StepTile(
            number: '2.7',
            title: 'Build the Dictionary (Firestore\'s format — see below)',
            body: 'This is the fiddly part: Firestore\'s REST API wants each field wrapped in a '
                'type, e.g. {"stringValue": "..."}. Add a Dictionary action, key "fields", value: '
                'another Dictionary containing one nested Dictionary per field — see the exact '
                'shape below. Tap each value field, tap the variable icon, and insert the '
                'matching variable from steps 2.1–2.6.',
          ),
          const SizedBox(height: 8),
          _CodeBlock(context: context, code: _fieldsTemplate),
          const SizedBox(height: 8),
          const Text(
            'Rename the outer Dictionary\'s output to RequestBody. For a Transfer, replace '
            'categoryName with fromAccountName and toAccountName (text fields you ask for '
            'in 2.4 instead of a category).',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          const _StepTile(
            number: '2.8',
            title: 'Get Contents of URL',
            body: 'URL: paste your endpoint URL from Settings → Automation. Method: POST. '
                'Request Body: JSON, set to the RequestBody dictionary. Headers: none needed.',
          ),
          const _StepTile(
            number: '2.9',
            title: 'Show Notification',
            body: 'Text: "Expense logged: " + Amount. Confirms the Shortcut ran, since the app '
                'itself only shows the transaction after you review/confirm it (or immediately, '
                'if you\'ve turned off Confirmation Mode and everything matched).',
          ),
          const SizedBox(height: 12),
          const Text('Test it: tap ▶ Run at the bottom of the editor and step through the prompts.'),
          const SizedBox(height: 20),
          Text('3. Automate it (optional)', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Shortcuts app → Automation tab → + → Create Personal Automation → "Message" → '
            'Contains: "debited" → Run Shortcut → "Log Expense" → turn off "Ask Before Running". '
            'This only fires for actual SMS/iMessage text — see the limitation above.',
          ),
          const SizedBox(height: 20),
          Text('4. Review in the app', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text(
            'Open Settings → Automation → "Review imported transactions" to confirm the category/'
            'account and save it for real, unless Automatic Mode is on and every field matched.',
          ),
        ],
      ),
    );
  }
}

class _LimitationBanner extends StatelessWidget {
  const _LimitationBanner({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onErrorContainer),
                const SizedBox(width: 8),
                Text(
                  'Important limitation',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'iOS Shortcuts can auto-trigger on an incoming SMS/iMessage that contains a word '
              'like "debited" — but NOT on a push notification from a payment app (PhonePe, '
              'Google Pay, your bank\'s app). Apple does not expose third-party notification '
              'content to Shortcuts automations. If your bank sends transaction alerts as SMS, '
              'the automation below works. If it only sends app notifications, you\'ll need to '
              'run the Shortcut manually (e.g. via Back Tap — see Quick Launch) after seeing the alert.',
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
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

const _fieldsTemplate = '''
token:        {"stringValue": <YOUR TOKEN>}
amount:       {"integerValue": <AmountMinor>}
type:         {"stringValue": <Type, lowercased>}
merchant:     {"stringValue": <Merchant>}
categoryName: {"stringValue": <CategoryName>}
remark:       {"stringValue": <Remark>}
source:       {"stringValue": "sms"}
platform:     {"stringValue": "ios"}
createdAt:    {"timestampValue": <DateISO>}''';
