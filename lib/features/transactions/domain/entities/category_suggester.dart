/// Rule-based merchant → category-name suggestions (section 38 of the spec).
/// Deliberately simple and swappable for a smarter classifier later without
/// touching the transaction UI — callers look up a [CategoryEntity] by this
/// name in the user's own category list and must always let the user
/// override the suggestion.
class CategorySuggester {
  const CategorySuggester._();

  static const Map<String, String> _merchantKeywordToCategoryName = {
    'uber': 'Travel',
    'ola': 'Travel',
    'irctc': 'Travel',
    'redbus': 'Travel',
    'indigo': 'Travel',
    'swiggy': 'Food',
    'zomato': 'Food',
    'dominos': 'Food',
    'mcdonald': 'Food',
    'starbucks': 'Food',
    'bigbasket': 'Groceries',
    'blinkit': 'Groceries',
    'zepto': 'Groceries',
    'dmart': 'Groceries',
    'amazon': 'Shopping',
    'flipkart': 'Shopping',
    'myntra': 'Shopping',
    'ajio': 'Shopping',
    'netflix': 'Entertainment',
    'spotify': 'Entertainment',
    'primevideo': 'Entertainment',
    'bookmyshow': 'Entertainment',
    'hotstar': 'Entertainment',
    'electricity': 'Bills',
    'airtel': 'Bills',
    'jio': 'Bills',
    'vodafone': 'Bills',
    'petrol': 'Fuel',
    'indianoil': 'Fuel',
    'hpcl': 'Fuel',
    'bpcl': 'Fuel',
    'apollo': 'Health',
    'pharmeasy': 'Health',
    'practo': 'Health',
  };

  /// Returns a category name to pre-select, or null if no rule matches —
  /// callers should leave the category unselected in that case, never guess.
  static String? suggestCategoryName(String? merchant) {
    if (merchant == null) return null;
    final normalized = merchant.trim().toLowerCase();
    if (normalized.isEmpty) return null;

    for (final entry in _merchantKeywordToCategoryName.entries) {
      if (normalized.contains(entry.key)) return entry.value;
    }
    return null;
  }
}
