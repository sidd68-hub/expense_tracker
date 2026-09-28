/// Where a transaction originated. Surfaced in the UI as "Imported" for
/// anything other than [manual], and essential for debugging automation
/// (rule #39 — always know where a transaction came from).
enum TransactionSource {
  manual,
  iosShortcut,
  androidMacrodroid,
  api;

  static TransactionSource fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => TransactionSource.manual,
      );
}

enum TransactionStatus {
  pending,
  confirmed,
  synced,
  failed,
  duplicate;

  static TransactionStatus fromName(String name) => values.firstWhere(
        (e) => e.name == name,
        orElse: () => TransactionStatus.confirmed,
      );
}
