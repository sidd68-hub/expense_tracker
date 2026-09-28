import 'package:expense_tracker/core/common/utils/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoneyAmount', () {
    test('stores amounts as integer minor units, never floating point', () {
      final amount = MoneyAmount.fromMajorUnits(125.50);
      expect(amount.minorUnits, 12550);
    });

    test('majorUnits converts back correctly', () {
      const amount = MoneyAmount(minorUnits: 12550);
      expect(amount.majorUnits, 125.50);
    });

    test('addition stays exact across many operations (no float drift)', () {
      var total = const MoneyAmount(minorUnits: 0);
      for (var i = 0; i < 1000; i++) {
        total = total + const MoneyAmount(minorUnits: 10); // 1000 x 10 paise
      }
      expect(total.minorUnits, 10000); // exactly ₹100.00, not 99.999999...
    });

    test('isZeroOrNegative rejects zero and negative amounts', () {
      expect(const MoneyAmount(minorUnits: 0).isZeroOrNegative, isTrue);
      expect(const MoneyAmount(minorUnits: -100).isZeroOrNegative, isTrue);
      expect(const MoneyAmount(minorUnits: 1).isZeroOrNegative, isFalse);
    });

    test('format renders the correct currency symbol', () {
      expect(const MoneyAmount(minorUnits: 12550, currency: 'INR').format(), '₹125.5');
      expect(const MoneyAmount(minorUnits: 12550, currency: 'USD').format(), '\$125.5');
    });

    test('equality is value-based', () {
      expect(const MoneyAmount(minorUnits: 100), const MoneyAmount(minorUnits: 100));
      expect(const MoneyAmount(minorUnits: 100), isNot(const MoneyAmount(minorUnits: 200)));
    });
  });
}
