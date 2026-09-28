import 'package:flutter/material.dart';

/// Curated set of icons available for categories. Storing the *key* (not a
/// raw IconData codepoint) in Firestore means we can safely change the
/// underlying icon or Flutter/Material version later without corrupting
/// already-saved categories.
class CategoryIcons {
  const CategoryIcons._();

  static const Map<String, IconData> map = {
    'food': Icons.restaurant,
    'groceries': Icons.local_grocery_store_outlined,
    'travel': Icons.flight_takeoff,
    'shopping': Icons.shopping_bag_outlined,
    'bills': Icons.receipt_long_outlined,
    'entertainment': Icons.movie_outlined,
    'rent': Icons.home_outlined,
    'fuel': Icons.local_gas_station_outlined,
    'health': Icons.local_hospital_outlined,
    'education': Icons.school_outlined,
    'personal': Icons.person_outline,
    'salary': Icons.payments_outlined,
    'business': Icons.work_outline,
    'freelance': Icons.laptop_mac,
    'investment': Icons.trending_up,
    'gift': Icons.card_giftcard_outlined,
    'other': Icons.category_outlined,
  };

  static const String fallbackKey = 'other';

  static IconData iconFor(String key) => map[key] ?? map[fallbackKey]!;
}

/// A small curated palette so category colors stay visually consistent
/// (and accessible) instead of an unrestricted color wheel.
class CategoryColors {
  const CategoryColors._();

  static const List<Color> palette = [
    Color(0xFFE57373),
    Color(0xFFF06292),
    Color(0xFFBA68C8),
    Color(0xFF9575CD),
    Color(0xFF7986CB),
    Color(0xFF64B5F6),
    Color(0xFF4FC3F7),
    Color(0xFF4DD0E1),
    Color(0xFF4DB6AC),
    Color(0xFF81C784),
    Color(0xFFAED581),
    Color(0xFFFFD54F),
    Color(0xFFFFB74D),
    Color(0xFFA1887F),
    Color(0xFF90A4AE),
  ];
}
