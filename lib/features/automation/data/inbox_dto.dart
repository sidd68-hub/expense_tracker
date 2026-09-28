import 'package:cloud_firestore/cloud_firestore.dart';

import '../../transactions/domain/entities/transaction_type.dart';
import '../domain/entities/inbox_entry.dart';

class InboxDto {
  static InboxEntry fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return InboxEntry(
      id: doc.id,
      amountMinor: (data['amount'] as num).toInt(),
      type: TransactionType.fromName(data['type'] as String? ?? 'expense'),
      currency: data['currency'] as String? ?? 'INR',
      merchant: data['merchant'] as String?,
      categoryName: data['categoryName'] as String?,
      accountName: data['accountName'] as String?,
      fromAccountName: data['fromAccountName'] as String?,
      toAccountName: data['toAccountName'] as String?,
      remark: data['remark'] as String?,
      date: (data['date'] as Timestamp?)?.toDate(),
      source: data['source'] as String?,
      platform: data['platform'] as String?,
      externalTransactionId: data['externalTransactionId'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
