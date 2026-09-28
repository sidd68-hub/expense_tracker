import 'package:expense_tracker/features/transactions/domain/entities/category_suggester.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CategorySuggester', () {
    test('suggests Travel for Uber', () {
      expect(CategorySuggester.suggestCategoryName('Uber Trip'), 'Travel');
    });

    test('suggests Food for Swiggy and Zomato', () {
      expect(CategorySuggester.suggestCategoryName('SWIGGY*ORDER123'), 'Food');
      expect(CategorySuggester.suggestCategoryName('Zomato'), 'Food');
    });

    test('suggests Shopping for Amazon', () {
      expect(CategorySuggester.suggestCategoryName('Amazon Pay'), 'Shopping');
    });

    test('is case-insensitive', () {
      expect(CategorySuggester.suggestCategoryName('UBER'), 'Travel');
      expect(CategorySuggester.suggestCategoryName('uber'), 'Travel');
    });

    test('returns null for an unrecognized merchant rather than guessing', () {
      expect(CategorySuggester.suggestCategoryName('Local Kirana Store'), isNull);
    });

    test('returns null for empty or null merchant', () {
      expect(CategorySuggester.suggestCategoryName(''), isNull);
      expect(CategorySuggester.suggestCategoryName('   '), isNull);
      expect(CategorySuggester.suggestCategoryName(null), isNull);
    });
  });
}
