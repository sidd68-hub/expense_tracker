import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/entities/category_type.dart';

/// Maps between [CategoryEntity] and its Firestore document shape.
/// Kept separate from the domain entity so Firestore-specific quirks
/// (Timestamp, nullable server fields) never leak into domain/presentation code.
class CategoryDto {
  static CategoryEntity fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CategoryEntity(
      id: doc.id,
      name: data['name'] as String,
      type: CategoryType.fromName(data['type'] as String),
      iconKey: data['iconKey'] as String,
      color: data['color'] as int,
      isArchived: data['isArchived'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toMap(CategoryEntity entity) {
    return {
      'name': entity.name,
      'type': entity.type.name,
      'iconKey': entity.iconKey,
      'color': entity.color,
      'isArchived': entity.isArchived,
      'createdAt': entity.createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(entity.createdAt!),
    };
  }
}
