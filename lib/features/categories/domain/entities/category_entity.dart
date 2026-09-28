import 'package:freezed_annotation/freezed_annotation.dart';

import 'category_type.dart';

part 'category_entity.freezed.dart';

@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,
    required CategoryType type,
    /// Key into [CategoryIcons.map], not a raw codepoint — icon font
    /// codepoints are not guaranteed stable across Flutter/Material versions.
    required String iconKey,
    /// ARGB color value.
    required int color,
    @Default(false) bool isArchived,
    DateTime? createdAt,
  }) = _CategoryEntity;
}
