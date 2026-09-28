import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/budget_entity.dart';

class BudgetDto {
  static BudgetEntity fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return BudgetEntity(
      id: doc.id,
      scope: BudgetScope.fromName(data['scope'] as String),
      categoryId: data['categoryId'] as String?,
      monthKey: data['monthKey'] as String,
      limitMinor: data['limitMinor'] as int,
      currency: data['currency'] as String? ?? 'INR',
      alertThresholds: (data['alertThresholds'] as List<dynamic>?)?.cast<int>() ?? const [80, 100],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toMap(BudgetEntity entity) {
    return {
      'scope': entity.scope.name,
      'categoryId': entity.categoryId,
      'monthKey': entity.monthKey,
      'limitMinor': entity.limitMinor,
      'currency': entity.currency,
      'alertThresholds': entity.alertThresholds,
      'createdAt': entity.createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(entity.createdAt!),
    };
  }
}
