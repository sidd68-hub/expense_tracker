import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/account_type.dart';

class AccountDto {
  static AccountEntity fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return AccountEntity(
      id: doc.id,
      name: data['name'] as String,
      type: AccountType.fromName(data['type'] as String),
      isArchived: data['isArchived'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toMap(AccountEntity entity) {
    return {
      'name': entity.name,
      'type': entity.type.name,
      'isArchived': entity.isArchived,
      'createdAt': entity.createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(entity.createdAt!),
    };
  }
}
