import 'package:expense_tracker/core/common/utils/money.dart';
import 'package:expense_tracker/features/analytics/domain/analytics_calculator.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/entities/transaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

TransactionEntity _tx({
  required TransactionType type,
  required int minorUnits,
  String? categoryId,
  String? accountId,
  String? fromAccountId,
  String? toAccountId,
  required DateTime date,
}) {
  return TransactionEntity(
    id: 'tx',
    type: type,
    amount: MoneyAmount(minorUnits: minorUnits),
    date: date,
    categoryId: categoryId,
    accountId: accountId,
    fromAccountId: fromAccountId,
    toAccountId: toAccountId,
  );
}

void main() {
  final jan1 = DateTime(2026, 1, 1);
  final jan2 = DateTime(2026, 1, 2);

  group('AnalyticsCalculator.sumByType', () {
    test('sums only the requested type', () {
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 1000, categoryId: 'food', accountId: 'cash', date: jan1),
        _tx(type: TransactionType.income, minorUnits: 5000, categoryId: 'salary', accountId: 'bank', date: jan1),
        _tx(type: TransactionType.expense, minorUnits: 500, categoryId: 'food', accountId: 'cash', date: jan2),
      ];
      expect(AnalyticsCalculator.sumByType(transactions, TransactionType.expense).minorUnits, 1500);
      expect(AnalyticsCalculator.sumByType(transactions, TransactionType.income).minorUnits, 5000);
    });

    test('a transfer never contributes to expense or income totals', () {
      final transactions = [
        _tx(type: TransactionType.transfer, minorUnits: 100000, fromAccountId: 'bank', toAccountId: 'cash', date: jan1),
      ];
      expect(AnalyticsCalculator.sumByType(transactions, TransactionType.expense).minorUnits, 0);
      expect(AnalyticsCalculator.sumByType(transactions, TransactionType.income).minorUnits, 0);
    });
  });

  group('AnalyticsCalculator.categoryBreakdown', () {
    test('groups and sorts by highest spend first', () {
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 300, categoryId: 'food', accountId: 'cash', date: jan1),
        _tx(type: TransactionType.expense, minorUnits: 700, categoryId: 'travel', accountId: 'cash', date: jan1),
        _tx(type: TransactionType.expense, minorUnits: 200, categoryId: 'food', accountId: 'cash', date: jan2),
      ];
      final result = AnalyticsCalculator.categoryBreakdown(transactions);
      expect(result.length, 2);
      expect(result[0].categoryId, 'travel');
      expect(result[0].amount.minorUnits, 700);
      expect(result[1].categoryId, 'food');
      expect(result[1].amount.minorUnits, 500);
    });

    test('excludes transfers, which have no category', () {
      final transactions = [
        _tx(type: TransactionType.transfer, minorUnits: 5000, fromAccountId: 'bank', toAccountId: 'cash', date: jan1),
      ];
      expect(AnalyticsCalculator.categoryBreakdown(transactions), isEmpty);
    });
  });

  group('AnalyticsCalculator.accountBreakdown', () {
    test('attributes a transfer to its source account', () {
      final transactions = [
        _tx(type: TransactionType.transfer, minorUnits: 5000, fromAccountId: 'bank', toAccountId: 'cash', date: jan1),
      ];
      final result = AnalyticsCalculator.accountBreakdown(transactions);
      expect(result.length, 1);
      expect(result.first.accountId, 'bank');
      expect(result.first.amount.minorUnits, 5000);
    });

    test('groups expense/income by their account', () {
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 300, categoryId: 'food', accountId: 'cash', date: jan1),
        _tx(type: TransactionType.expense, minorUnits: 400, categoryId: 'food', accountId: 'cash', date: jan2),
      ];
      final result = AnalyticsCalculator.accountBreakdown(transactions);
      expect(result.single.accountId, 'cash');
      expect(result.single.amount.minorUnits, 700);
    });
  });

  group('AnalyticsCalculator.dailyTotals', () {
    test('fills zero-amount days so charts have no gaps', () {
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 1000, categoryId: 'food', accountId: 'cash', date: jan1),
      ];
      final result = AnalyticsCalculator.dailyTotals(transactions, TransactionType.expense, jan1, jan2);
      expect(result.length, 2);
      expect(result[0].day, jan1);
      expect(result[0].amount.minorUnits, 1000);
      expect(result[1].day, jan2);
      expect(result[1].amount.minorUnits, 0);
    });

    test('ignores a transaction date outside the requested range', () {
      final outsideDate = DateTime(2026, 2, 1);
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 1000, categoryId: 'food', accountId: 'cash', date: outsideDate),
      ];
      final result = AnalyticsCalculator.dailyTotals(transactions, TransactionType.expense, jan1, jan2);
      expect(result.every((d) => d.amount.minorUnits == 0), isTrue);
    });
  });

  group('AnalyticsCalculator.monthlyTotals', () {
    test('buckets by calendar month across the range', () {
      final feb15 = DateTime(2026, 2, 15);
      final transactions = [
        _tx(type: TransactionType.expense, minorUnits: 1000, categoryId: 'food', accountId: 'cash', date: jan1),
        _tx(type: TransactionType.expense, minorUnits: 2000, categoryId: 'food', accountId: 'cash', date: feb15),
      ];
      final result = AnalyticsCalculator.monthlyTotals(transactions, TransactionType.expense, jan1, feb15);
      expect(result.length, 2);
      expect(result[0].amount.minorUnits, 1000);
      expect(result[1].amount.minorUnits, 2000);
    });
  });
}
