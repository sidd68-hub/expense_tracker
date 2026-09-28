import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../transactions/domain/entities/transaction_type.dart';

part 'inbox_entry.freezed.dart';

/// A raw, unverified transaction reported by an automation client (iOS
/// Shortcut, MacroDroid) — written directly to Firestore via a token-gated,
/// unauthenticated create (see firestore.rules), since automation clients
/// can't run an interactive Firebase Auth sign-in and this app has no paid
/// Cloud Functions backend. Never a real transaction on its own: the app
/// resolves category/account names, checks for duplicates, and — unless
/// Automatic Mode is on for a high-confidence entry — asks the user to
/// confirm before [InboxRepository.commit] turns it into one (rule #16, #19).
@freezed
abstract class InboxEntry with _$InboxEntry {
  const factory InboxEntry({
    required String id,
    required int amountMinor,
    required TransactionType type,
    @Default('INR') String currency,
    String? merchant,
    String? categoryName,
    String? accountName,
    String? fromAccountName,
    String? toAccountName,
    String? remark,
    DateTime? date,
    String? source,
    String? platform,
    String? externalTransactionId,
    DateTime? createdAt,
  }) = _InboxEntry;
}
