import 'package:expense_tracker/features/accounts/domain/entities/account_entity.dart';
import 'package:expense_tracker/features/accounts/domain/entities/account_type.dart';
import 'package:expense_tracker/features/automation/domain/entities/inbox_entry.dart';
import 'package:expense_tracker/features/automation/domain/inbox_resolver.dart';
import 'package:expense_tracker/features/categories/domain/entities/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/entities/category_type.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

final categories = [
  const CategoryEntity(id: 'cat_food', name: 'Food', type: CategoryType.expense, iconKey: 'food', color: 0),
  const CategoryEntity(id: 'cat_salary', name: 'Salary', type: CategoryType.income, iconKey: 'salary', color: 0),
];

final accounts = [
  const AccountEntity(id: 'acc_cash', name: 'Cash', type: AccountType.cash),
  const AccountEntity(id: 'acc_bank', name: 'HDFC Bank', type: AccountType.bank),
];

InboxEntry _entry({
  TransactionType type = TransactionType.expense,
  String? categoryName,
  String? accountName,
  String? fromAccountName,
  String? toAccountName,
}) {
  return InboxEntry(
    id: 'inbox1',
    amountMinor: 25000,
    type: type,
    categoryName: categoryName,
    accountName: accountName,
    fromAccountName: fromAccountName,
    toAccountName: toAccountName,
  );
}

void main() {
  group('InboxResolver.resolve — expense/income', () {
    test('matches category and account by exact name', () {
      final resolved = InboxResolver.resolve(
        _entry(categoryName: 'Food', accountName: 'Cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.categoryId, 'cat_food');
      expect(resolved.accountId, 'acc_cash');
      expect(resolved.isFullyResolved, isTrue);
    });

    test('matches case-insensitively', () {
      final resolved = InboxResolver.resolve(
        _entry(categoryName: 'FOOD', accountName: 'cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.isFullyResolved, isTrue);
    });

    test('never matches a category of the wrong type', () {
      // "Salary" is an income category; an expense entry must not match it.
      final resolved = InboxResolver.resolve(
        _entry(categoryName: 'Salary', accountName: 'Cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.categoryId, isNull);
      expect(resolved.isFullyResolved, isFalse);
    });

    test('is unresolved (never guesses) when the name has no match', () {
      final resolved = InboxResolver.resolve(
        _entry(categoryName: 'Unknown Category', accountName: 'Cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.categoryId, isNull);
      expect(resolved.isFullyResolved, isFalse);
    });

    test('is unresolved when no category/account name was supplied at all', () {
      final resolved = InboxResolver.resolve(_entry(), categories: categories, accounts: accounts);
      expect(resolved.categoryId, isNull);
      expect(resolved.accountId, isNull);
      expect(resolved.isFullyResolved, isFalse);
    });
  });

  group('InboxResolver.resolve — transfer', () {
    test('matches both accounts by name', () {
      final resolved = InboxResolver.resolve(
        _entry(type: TransactionType.transfer, fromAccountName: 'HDFC Bank', toAccountName: 'Cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.fromAccountId, 'acc_bank');
      expect(resolved.toAccountId, 'acc_cash');
      expect(resolved.isFullyResolved, isTrue);
    });

    test('is unresolved if both names resolve to the same account', () {
      final resolved = InboxResolver.resolve(
        _entry(type: TransactionType.transfer, fromAccountName: 'Cash', toAccountName: 'Cash'),
        categories: categories,
        accounts: accounts,
      );
      expect(resolved.isFullyResolved, isFalse);
    });
  });

  group('InboxResolver.buildDraft', () {
    test('carries amount, merchant, and automation metadata into the draft transaction', () {
      final entry = InboxEntry(
        id: 'inbox1',
        amountMinor: 25000,
        type: TransactionType.expense,
        merchant: 'ABC Restaurant',
        source: 'phonepe',
        platform: 'ios',
        externalTransactionId: 'UPI123',
      );
      final resolved = InboxResolver.resolve(entry, categories: categories, accounts: accounts);
      final draft = InboxResolver.buildDraft(entry, resolved);

      expect(draft.amount.minorUnits, 25000);
      expect(draft.merchant, 'ABC Restaurant');
      expect(draft.isImported, isTrue);
      expect(draft.externalTransactionId, 'UPI123');
      expect(draft.automationSource, 'phonepe');
    });
  });
}
