import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/common/utils/money.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_source.dart';
import '../../domain/entities/transaction_type.dart';

class TransactionDto {
  static TransactionEntity fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TransactionEntity(
      id: doc.id,
      type: TransactionType.fromName(data['type'] as String),
      amount: MoneyAmount(
        minorUnits: data['amountMinor'] as int,
        currency: data['currency'] as String? ?? 'INR',
      ),
      date: (data['date'] as Timestamp).toDate(),
      categoryId: data['categoryId'] as String?,
      accountId: data['accountId'] as String?,
      fromAccountId: data['fromAccountId'] as String?,
      toAccountId: data['toAccountId'] as String?,
      merchant: data['merchant'] as String?,
      remark: data['remark'] as String?,
      source: TransactionSource.fromName(data['source'] as String? ?? 'manual'),
      isImported: data['isImported'] as bool? ?? false,
      externalTransactionId: data['externalTransactionId'] as String?,
      automationSource: data['automationSource'] as String?,
      status: TransactionStatus.fromName(data['status'] as String? ?? 'confirmed'),
      isDeleted: data['isDeleted'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toMap(TransactionEntity entity) {
    return {
      'type': entity.type.name,
      'amountMinor': entity.amount.minorUnits,
      'currency': entity.amount.currency,
      'date': Timestamp.fromDate(entity.date),
      'categoryId': entity.categoryId,
      'accountId': entity.accountId,
      'fromAccountId': entity.fromAccountId,
      'toAccountId': entity.toAccountId,
      'merchant': entity.merchant,
      'remark': entity.remark,
      'source': entity.source.name,
      'isImported': entity.isImported,
      'externalTransactionId': entity.externalTransactionId,
      'automationSource': entity.automationSource,
      'status': entity.status.name,
      'isDeleted': entity.isDeleted,
      'createdAt': entity.createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(entity.createdAt!),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
