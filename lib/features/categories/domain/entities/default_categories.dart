import 'category_type.dart';

/// Seed data written to `users/{uid}/categories` the first time a new user
/// signs in (see [CategoryRepository.seedDefaultsIfEmpty]).
class DefaultCategorySeed {
  const DefaultCategorySeed({
    required this.name,
    required this.type,
    required this.iconKey,
    required this.color,
  });

  final String name;
  final CategoryType type;
  final String iconKey;
  final int color;

  static const List<DefaultCategorySeed> all = [
    DefaultCategorySeed(name: 'Food', type: CategoryType.expense, iconKey: 'food', color: 0xFFE57373),
    DefaultCategorySeed(name: 'Travel', type: CategoryType.expense, iconKey: 'travel', color: 0xFF64B5F6),
    DefaultCategorySeed(name: 'Shopping', type: CategoryType.expense, iconKey: 'shopping', color: 0xFFBA68C8),
    DefaultCategorySeed(name: 'Bills', type: CategoryType.expense, iconKey: 'bills', color: 0xFF90A4AE),
    DefaultCategorySeed(name: 'Groceries', type: CategoryType.expense, iconKey: 'groceries', color: 0xFF81C784),
    DefaultCategorySeed(name: 'Entertainment', type: CategoryType.expense, iconKey: 'entertainment', color: 0xFFF06292),
    DefaultCategorySeed(name: 'Rent', type: CategoryType.expense, iconKey: 'rent', color: 0xFFA1887F),
    DefaultCategorySeed(name: 'Fuel', type: CategoryType.expense, iconKey: 'fuel', color: 0xFFFFB74D),
    DefaultCategorySeed(name: 'Health', type: CategoryType.expense, iconKey: 'health', color: 0xFFE57373),
    DefaultCategorySeed(name: 'Education', type: CategoryType.expense, iconKey: 'education', color: 0xFF7986CB),
    DefaultCategorySeed(name: 'Personal', type: CategoryType.expense, iconKey: 'personal', color: 0xFF4DD0E1),
    DefaultCategorySeed(name: 'Other', type: CategoryType.expense, iconKey: 'other', color: 0xFF9575CD),
    DefaultCategorySeed(name: 'Salary', type: CategoryType.income, iconKey: 'salary', color: 0xFF81C784),
    DefaultCategorySeed(name: 'Business', type: CategoryType.income, iconKey: 'business', color: 0xFF64B5F6),
    DefaultCategorySeed(name: 'Freelance', type: CategoryType.income, iconKey: 'freelance', color: 0xFF4FC3F7),
    DefaultCategorySeed(name: 'Investment', type: CategoryType.income, iconKey: 'investment', color: 0xFFAED581),
    DefaultCategorySeed(name: 'Gift', type: CategoryType.income, iconKey: 'gift', color: 0xFFF06292),
    DefaultCategorySeed(name: 'Other', type: CategoryType.income, iconKey: 'other', color: 0xFF9575CD),
  ];
}
