enum CategoryType {
  expense,
  income;

  static CategoryType fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => CategoryType.expense,
      );
}
