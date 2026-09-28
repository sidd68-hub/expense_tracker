enum TransactionType {
  expense,
  income,
  transfer;

  static TransactionType fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => TransactionType.expense,
      );
}
