import '../entities/account_entity.dart';

abstract class AccountRepository {
  Stream<List<AccountEntity>> watchAccounts({bool includeArchived = false});

  Future<AccountEntity?> getById(String id);

  Future<String> create(AccountEntity account);

  Future<void> update(AccountEntity account);

  Future<void> archive(String id);

  Future<void> delete(String id);

  /// Seeds a starter "Cash" account on first sign-in so the add-transaction
  /// screen always has at least one account to pick from.
  Future<void> seedDefaultsIfEmpty();
}
