import 'package:expense_tracker/core/common/utils/money.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_type.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_validator.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionEntity _expense({
  int minorUnits = 10000,
  String? categoryId = 'cat_food',
  String? accountId = 'acc_cash',
}) {
  return TransactionEntity(
    id: 'tx1',
    type: TransactionType.expense,
    amount: MoneyAmount(minorUnits: minorUnits),
    date: DateTime(2026, 1, 1),
    categoryId: categoryId,
    accountId: accountId,
  );
}

TransactionEntity _transfer({
  int minorUnits = 10000,
  String? fromAccountId = 'acc_bank',
  String? toAccountId = 'acc_cash',
}) {
  return TransactionEntity(
    id: 'tx1',
    type: TransactionType.transfer,
    amount: MoneyAmount(minorUnits: minorUnits),
    date: DateTime(2026, 1, 1),
    fromAccountId: fromAccountId,
    toAccountId: toAccountId,
  );
}

void main() {
  group('TransactionValidator — expense/income', () {
    test('valid expense passes', () {
      expect(TransactionValidator.validate(_expense()), isNull);
    });

    test('rejects zero amount', () {
      expect(TransactionValidator.validate(_expense(minorUnits: 0)), isNotNull);
    });

    test('rejects negative amount', () {
      expect(TransactionValidator.validate(_expense(minorUnits: -500)), isNotNull);
    });

    test('rejects missing category', () {
      expect(TransactionValidator.validate(_expense(categoryId: null)), isNotNull);
    });

    test('rejects missing account', () {
      expect(TransactionValidator.validate(_expense(accountId: null)), isNotNull);
    });
  });

  group('TransactionValidator — transfer', () {
    test('valid transfer between different accounts passes', () {
      expect(TransactionValidator.validate(_transfer()), isNull);
    });

    test('rejects transfer from and to the same account', () {
      final tx = _transfer(fromAccountId: 'acc_cash', toAccountId: 'acc_cash');
      expect(TransactionValidator.validate(tx), isNotNull);
    });

    test('rejects transfer missing a destination account', () {
      expect(TransactionValidator.validate(_transfer(toAccountId: null)), isNotNull);
    });

    test('transfer does not require a category', () {
      final tx = _transfer();
      expect(tx.categoryId, isNull);
      expect(TransactionValidator.validate(tx), isNull);
    });
  });
}
