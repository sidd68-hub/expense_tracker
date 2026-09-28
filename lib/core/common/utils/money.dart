import 'package:intl/intl.dart';

/// Represents a monetary amount stored in the smallest currency unit
/// (e.g. paise for INR) to avoid floating-point precision issues.
class MoneyAmount {
  const MoneyAmount({required this.minorUnits, this.currency = 'INR'});

  factory MoneyAmount.fromMajorUnits(double majorUnits, {String currency = 'INR'}) {
    return MoneyAmount(minorUnits: (majorUnits * 100).round(), currency: currency);
  }

  final int minorUnits;
  final String currency;

  double get majorUnits => minorUnits / 100;

  bool get isPositive => minorUnits > 0;
  bool get isZeroOrNegative => minorUnits <= 0;

  MoneyAmount operator +(MoneyAmount other) {
    assert(currency == other.currency, 'Cannot add amounts of different currencies');
    return MoneyAmount(minorUnits: minorUnits + other.minorUnits, currency: currency);
  }

  MoneyAmount operator -(MoneyAmount other) {
    assert(currency == other.currency, 'Cannot subtract amounts of different currencies');
    return MoneyAmount(minorUnits: minorUnits - other.minorUnits, currency: currency);
  }

  String format({bool showSymbol = true}) {
    final symbol = showSymbol ? _symbolFor(currency) : '';
    final formatter = NumberFormat.decimalPattern('en_IN');
    return '$symbol${formatter.format(majorUnits)}';
  }

  static String _symbolFor(String currency) {
    switch (currency) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currency ';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyAmount && minorUnits == other.minorUnits && currency == other.currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => format();
}
