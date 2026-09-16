/// Money on screen (UX-W1-06, SRS-BIL-006, SRS-BIL-008, SRS-BIL-012).
///
/// The server carries money as integer minor units with a currency beside it,
/// and never as a float — a float cannot represent 0.10 exactly, so a hundred
/// lines summed as floats do not equal the invoice total, and an invoice that
/// does not add up is one a patient is right to dispute.
///
/// The client is where that discipline usually breaks. `value / 100` produces a
/// double; formatting it back rounds; and the number a cashier reads drifts
/// from the number in the ledger. So nothing here divides into a double.
/// Formatting splits the integer into whole and fractional parts with integer
/// arithmetic, and parsing goes the other way — a typed "1,234.50" becomes
/// 123450 minor units without ever being a double.
///
/// Dart's `int` is a true 64-bit integer on the platforms this app ships to,
/// which is exactly what the proto's `int64` carries, so no wider type is
/// needed. The web shell uses `bigint` for the same reason in a language where
/// the default number is a float.
///
/// Two amounts in different currencies are never added, compared or rendered as
/// one figure. A ward that takes a deposit in one currency and bills in another
/// is unusual; a screen that silently sums them is a reconciliation failure
/// nobody finds until year end.
library;

import 'package:meta/meta.dart';

/// An amount, as the server carries it.
@immutable
class Money {
  const Money({required this.minor, required this.currency});

  /// Integer minor units. Negative means the other direction.
  final int minor;

  /// ISO 4217 alphabetic code.
  final String currency;

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minor == minor &&
      other.currency.toUpperCase() == currency.toUpperCase();

  @override
  int get hashCode => Object.hash(minor, currency.toUpperCase());

  @override
  String toString() => '$currency $minor';
}

/// Thrown when two amounts cannot be combined.
class CurrencyMismatchError implements Exception {
  CurrencyMismatchError(this.left, this.right);

  final String left;
  final String right;

  @override
  String toString() => 'CurrencyMismatchError: cannot combine $left and $right';
}

/// How many minor units make one major unit.
///
/// Not universally 100: the dinar currencies use three decimal places and the
/// yen uses none. Getting this wrong renders ¥1,200 as ¥12.00, which is a
/// hundredfold error on a receipt.
const Map<String, int> _minorUnitsByCurrency = {
  'JPY': 0,
  'KRW': 0,
  'VND': 0,
  'BHD': 3,
  'IQD': 3,
  'JOD': 3,
  'KWD': 3,
  'OMR': 3,
  'TND': 3,
};

/// Decimal places for a currency. Two unless it is one of the exceptions.
int decimalsFor(String currency) =>
    _minorUnitsByCurrency[currency.toUpperCase()] ?? 2;

/// Ten to the power of [exponent], as an integer.
///
/// A loop rather than `pow`, which returns a `num` and goes through a double on
/// the way — the one place a rounding error could enter the whole module.
int _scaleFor(int exponent) {
  var scale = 1;
  for (var i = 0; i < exponent; i++) {
    scale *= 10;
  }
  return scale;
}

/// Renders an amount.
///
/// Integer arithmetic throughout: the whole and fractional parts are split with
/// integer division and remainder, never by dividing into a double. 1234567 in
/// a two-decimal currency is "12,345.67" exactly, and stays exact at any
/// magnitude a hospital's ledger reaches.
String formatMoney(
  Money amount, {
  bool withCurrency = true,
  MoneyGrouping grouping = MoneyGrouping.thousands,
}) {
  final decimals = decimalsFor(amount.currency);
  final negative = amount.minor < 0;
  final magnitude = negative ? -amount.minor : amount.minor;

  final scale = _scaleFor(decimals);
  final whole = magnitude ~/ scale;
  final fraction = magnitude % scale;

  final groupedWhole = grouping.apply(whole.toString());
  final rendered = decimals == 0
      ? groupedWhole
      : '$groupedWhole.${fraction.toString().padLeft(decimals, '0')}';

  final signed = negative ? '-$rendered' : rendered;
  // The currency code, not a symbol. A symbol is ambiguous across the several
  // currencies that use "$", and a receipt has to be unambiguous.
  return withCurrency ? '${amount.currency} $signed' : signed;
}

/// How the whole part is grouped.
///
/// An enum rather than a locale string because the grouping this app needs is
/// a deployment fact, and a locale the device happens to be set to is not it: a
/// hospital in Chennai bills in lakhs whether or not the phone is in en-US.
enum MoneyGrouping {
  /// 1,234,567 — most of the world.
  thousands,

  /// 12,34,567 — the Indian system, where grouping is by two after the first
  /// three digits.
  lakhs,

  /// No separators at all, for a field that will be re-parsed.
  none;

  String apply(String digits) => switch (this) {
        MoneyGrouping.none => digits,
        MoneyGrouping.thousands => _groupFromRight(digits, 3, 3),
        MoneyGrouping.lakhs => _groupFromRight(digits, 3, 2),
      };
}

/// Groups [digits] from the right: [first] digits, then groups of [rest].
String _groupFromRight(String digits, int first, int rest) {
  if (digits.length <= first) {
    return digits;
  }
  final tail = digits.substring(digits.length - first);
  var head = digits.substring(0, digits.length - first);
  final groups = <String>[];
  while (head.length > rest) {
    groups.insert(0, head.substring(head.length - rest));
    head = head.substring(0, head.length - rest);
  }
  if (head.isNotEmpty) {
    groups.insert(0, head);
  }
  return '${groups.join(',')},$tail';
}

/// Parses what a cashier typed into minor units.
///
/// Returns null rather than guessing. A typed amount that cannot be read is a
/// refusal to accept the payment, not an amount of zero — and zero is exactly
/// what a lenient parser produces from a typing slip.
Money? parseMoney(String input, String currency) {
  final decimals = decimalsFor(currency);
  // Grouping separators and spaces are stripped; everything else must be
  // digits, at most one decimal point, and an optional leading minus.
  final cleaned = input.trim().replaceAll(RegExp(r'[\s,]'), '');
  if (cleaned.isEmpty || cleaned == '-' || cleaned == '.') {
    return null;
  }
  if (!RegExp(r'^-?\d*(\.\d*)?$').hasMatch(cleaned)) {
    return null;
  }

  final negative = cleaned.startsWith('-');
  final unsigned = negative ? cleaned.substring(1) : cleaned;
  final parts = unsigned.split('.');
  final wholePart = parts[0];
  final fractionPart = parts.length > 1 ? parts[1] : '';

  if (wholePart.isEmpty && fractionPart.isEmpty) {
    return null;
  }
  if (fractionPart.length > decimals) {
    // More precision than the currency has. Refused rather than rounded:
    // silently turning 10.005 into 10.01 on a receipt is a discrepancy
    // somebody has to reconcile later.
    return null;
  }

  final scale = _scaleFor(decimals);
  final whole = wholePart.isEmpty ? 0 : int.tryParse(wholePart);
  final fraction = fractionPart.isEmpty
      ? 0
      : int.tryParse(fractionPart.padRight(decimals, '0'));
  if (whole == null || fraction == null) {
    // Longer than a 64-bit integer holds. Refused rather than truncated.
    return null;
  }

  final minor = whole * scale + fraction;
  return Money(
    minor: negative ? -minor : minor,
    currency: currency.toUpperCase(),
  );
}

void _requireSameCurrency(Money left, Money right) {
  if (left.currency.toUpperCase() != right.currency.toUpperCase()) {
    // A screen that silently sums two currencies is a reconciliation failure
    // nobody finds until year end.
    throw CurrencyMismatchError(left.currency, right.currency);
  }
}

/// Adds two amounts, refusing to mix currencies.
Money addMoney(Money left, Money right) {
  _requireSameCurrency(left, right);
  return Money(minor: left.minor + right.minor, currency: left.currency);
}

/// Subtracts the second amount from the first.
Money subtractMoney(Money left, Money right) {
  _requireSameCurrency(left, right);
  return Money(minor: left.minor - right.minor, currency: left.currency);
}

/// Sums a list, refusing to mix currencies. Zero of [currency] when empty.
Money sumMoney(List<Money> amounts, String currency) {
  var total = Money(minor: 0, currency: currency.toUpperCase());
  for (final amount in amounts) {
    total = addMoney(total, amount);
  }
  return total;
}

/// True when the amount is exactly zero.
bool isZero(Money amount) => amount.minor == 0;

/// True when the patient owes money.
bool isOwed(Money balance) => balance.minor > 0;

/// Describes a balance in the terms a cashier speaks.
///
/// "Owes" and "in credit" rather than a signed number. A negative balance on a
/// screen reads as an error to most people, and the one thing a patient at a
/// desk actually needs is which way round it is.
String describeBalance(Money balance, {MoneyGrouping grouping = MoneyGrouping.thousands}) {
  if (isZero(balance)) {
    return 'Settled';
  }
  final magnitude = Money(
    minor: balance.minor < 0 ? -balance.minor : balance.minor,
    currency: balance.currency,
  );
  return balance.minor > 0
      ? 'Owes ${formatMoney(magnitude, grouping: grouping)}'
      : 'In credit ${formatMoney(magnitude, grouping: grouping)}';
}

/// Renders a tax rate held in basis points.
///
/// Basis points because a rate held as a float has the same problem money does:
/// 0.18 is not representable, and a tax line computed from it does not
/// reconcile against one computed by the server.
String formatRate(int basisPoints) {
  final whole = basisPoints ~/ 100;
  final fraction = (basisPoints % 100).abs();
  if (fraction == 0) {
    return '$whole%';
  }
  final rendered = fraction.toString().padLeft(2, '0');
  return '$whole.${rendered.endsWith('0') ? rendered.substring(0, 1) : rendered}%';
}
