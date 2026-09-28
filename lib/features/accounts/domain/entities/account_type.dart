enum AccountType {
  bank,
  cash,
  card,
  upi,
  wallet;

  static AccountType fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => AccountType.bank,
      );
}
