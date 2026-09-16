import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/billing/account.dart';
import 'package:health_mobile/src/billing/money.dart';

Money inr(int minor) => Money(minor: minor, currency: 'INR');

void main() {
  group('money never becomes a float', () {
    test('a hundred ten-paise lines sum to exactly ten rupees', () {
      // The canonical float failure: 100 * 0.10 is 10.000000000000002.
      final lines = [for (var i = 0; i < 100; i++) inr(10)];
      expect(sumMoney(lines, 'INR'), inr(1000));
      expect(formatMoney(sumMoney(lines, 'INR')), 'INR 10.00');
    });

    test('three thirds of a rupee do not silently become a rupee', () {
      // 33 + 33 + 33 is 99, not 100. Integer arithmetic says so; a float
      // pipeline that rounded on display would show 1.00.
      expect(formatMoney(sumMoney([inr(33), inr(33), inr(33)], 'INR')),
          'INR 0.99');
    });

    test('a ledger-sized amount stays exact', () {
      expect(formatMoney(inr(123456789012345), withCurrency: false),
          '1,234,567,890,123.45');
      // The largest a 64-bit minor-unit ledger holds, rendered without losing a
      // digit. A double would have stopped being exact around 2^53, which is
      // nine thousand times smaller.
      expect(formatMoney(inr(9223372036854775807), withCurrency: false),
          '92,233,720,368,547,758.07');
    });

    test('formatting and parsing round-trip exactly', () {
      for (final minor in [0, 1, 99, 100, 101, 999, 123450, -4567]) {
        final formatted = formatMoney(inr(minor), withCurrency: false,
            grouping: MoneyGrouping.none);
        expect(parseMoney(formatted, 'INR'), inr(minor),
            reason: 'round trip failed for $minor');
      }
    });
  });

  group('rendering', () {
    test('the whole and fractional parts are split exactly', () {
      expect(formatMoney(inr(1234567), withCurrency: false), '12,345.67');
      expect(formatMoney(inr(5), withCurrency: false), '0.05');
      expect(formatMoney(inr(50), withCurrency: false), '0.50');
      expect(formatMoney(inr(100), withCurrency: false), '1.00');
    });

    test('a zero-decimal currency renders no decimal point', () {
      // ¥1,200 rendered as ¥12.00 is a hundredfold error on a receipt.
      expect(formatMoney(const Money(minor: 1200, currency: 'JPY')),
          'JPY 1,200');
    });

    test('a three-decimal currency keeps all three', () {
      expect(formatMoney(const Money(minor: 1234, currency: 'KWD')),
          'KWD 1.234');
      expect(decimalsFor('KWD'), 3);
      expect(decimalsFor('JPY'), 0);
      expect(decimalsFor('INR'), 2);
      expect(decimalsFor('unknown-code'), 2);
    });

    test('the currency code is shown, never a symbol', () {
      // "$" is ambiguous across several currencies and a receipt has to be
      // unambiguous.
      expect(formatMoney(const Money(minor: 100, currency: 'USD')), 'USD 1.00');
      expect(formatMoney(const Money(minor: 100, currency: 'AUD')), 'AUD 1.00');
    });

    test('a negative amount keeps its sign outside the grouping', () {
      expect(formatMoney(inr(-1234567), withCurrency: false), '-12,345.67');
    });

    test('lakh grouping is available for the deployments that bill in it', () {
      // A hospital in Chennai bills in lakhs whether or not the phone's locale
      // says so, which is why this is a deployment choice and not a device one.
      expect(
        formatMoney(inr(1234567890), withCurrency: false,
            grouping: MoneyGrouping.lakhs),
        '1,23,45,678.90',
      );
      expect(
        formatMoney(inr(1234567890), withCurrency: false,
            grouping: MoneyGrouping.thousands),
        '12,345,678.90',
      );
    });

    test('grouping can be switched off for a field that will be re-parsed', () {
      expect(formatMoney(inr(1234567), withCurrency: false,
          grouping: MoneyGrouping.none), '12345.67');
    });
  });

  group('parsing what a cashier typed', () {
    test('an unreadable amount is refused, never treated as zero', () {
      // Zero is exactly what a lenient parser produces from a typing slip, and
      // a zero payment taken against a bill is a receipt for nothing.
      for (final input in ['', '   ', 'abc', '1.2.3', '-', '.', '12x', '1,,2.3.4']) {
        expect(parseMoney(input, 'INR'), isNull, reason: 'accepted "$input"');
      }
    });

    test('grouping separators and spaces are stripped', () {
      expect(parseMoney('1,234.50', 'INR'), inr(123450));
      expect(parseMoney(' 1 234.50 ', 'INR'), inr(123450));
      expect(parseMoney('1,23,450.00', 'INR'), inr(12345000));
    });

    test('more precision than the currency has is refused, not rounded', () {
      // Silently turning 10.005 into 10.01 on a receipt is a discrepancy
      // somebody reconciles later.
      expect(parseMoney('10.005', 'INR'), isNull);
      expect(parseMoney('1.5', 'JPY'), isNull);
      expect(parseMoney('1.2345', 'KWD'), isNull);
      expect(parseMoney('1.234', 'KWD'), const Money(minor: 1234, currency: 'KWD'));
    });

    test('a short fraction is padded, not misread', () {
      expect(parseMoney('1.5', 'INR'), inr(150));
      expect(parseMoney('1.', 'INR'), inr(100));
      expect(parseMoney('.5', 'INR'), inr(50));
    });

    test('a negative amount parses, for an adjustment that goes the other way',
        () {
      expect(parseMoney('-12.34', 'INR'), inr(-1234));
    });

    test('an amount too large for the ledger is refused, not truncated', () {
      expect(parseMoney('99999999999999999999.99', 'INR'), isNull);
    });

    test('the currency is normalised to upper case', () {
      expect(parseMoney('1.00', 'inr')?.currency, 'INR');
    });
  });

  group('currencies are never mixed', () {
    test('adding two currencies throws rather than producing a figure', () {
      // A screen that silently sums them is a reconciliation failure nobody
      // finds until year end.
      expect(
        () => addMoney(inr(100), const Money(minor: 100, currency: 'USD')),
        throwsA(isA<CurrencyMismatchError>()),
      );
    });

    test('summing a mixed list throws', () {
      expect(
        () => sumMoney([inr(100), const Money(minor: 1, currency: 'USD')], 'INR'),
        throwsA(isA<CurrencyMismatchError>()),
      );
    });

    test('the error names both currencies', () {
      try {
        addMoney(inr(100), const Money(minor: 100, currency: 'USD'));
        fail('mixed currencies were combined');
      } on CurrencyMismatchError catch (e) {
        expect(e.toString(), contains('INR'));
        expect(e.toString(), contains('USD'));
      }
    });

    test('case differences are not a mismatch', () {
      expect(addMoney(inr(100), const Money(minor: 50, currency: 'inr')).minor,
          150);
    });

    test('an empty sum is zero of the currency asked for', () {
      expect(sumMoney([], 'INR'), inr(0));
    });
  });

  group('the balance derives from the ledger', () {
    PresentedEntry entry(String id, int minor, {DateTime? at}) => presentEntry(
          entryId: id,
          kind: minor > 0 ? EntryKind.invoice : EntryKind.payment,
          amount: inr(minor),
          occurredAt: at ?? DateTime.utc(2026, 9, 16, 9),
        );

    test('the statement recomputes rather than trusting the column', () {
      final statement = buildStatement(
        entries: [entry('a', 10000), entry('b', -4000)],
        reportedBalance: inr(6000),
        deposits: inr(0),
        currency: 'INR',
      );
      expect(statement.derivedBalance, inr(6000));
      expect(statement.reconciles, isTrue);
    });

    test('a disagreement is surfaced, not resolved', () {
      // Either the entry list is incomplete or something is wrong; both are
      // things a cashier should see before taking money against the figure.
      final statement = buildStatement(
        entries: [entry('a', 10000)],
        reportedBalance: inr(6000),
        deposits: inr(0),
        currency: 'INR',
      );
      expect(statement.reconciles, isFalse);
      expect(statement.derivedBalance, inr(10000));
      expect(statement.reportedBalance, inr(6000));
    });

    test('when they disagree the header shows the figure it can account for',
        () {
      final statement = buildStatement(
        entries: [entry('a', 10000)],
        reportedBalance: inr(6000),
        deposits: inr(0),
        currency: 'INR',
      );
      expect(describeAccountHeader(statement), contains('100.00 outstanding'));
    });

    test('direction comes from the sign, not from the kind', () {
      // An adjustment that goes the other way must not be read backwards.
      final credit = presentEntry(
        entryId: 'x', kind: EntryKind.adjustment, amount: inr(-500),
        occurredAt: DateTime.utc(2026, 9, 16),
      );
      expect(credit.increasesDebt, isFalse);

      final debit = presentEntry(
        entryId: 'y', kind: EntryKind.adjustment, amount: inr(500),
        occurredAt: DateTime.utc(2026, 9, 16),
      );
      expect(debit.increasesDebt, isTrue);
    });

    test('entries are shown newest first', () {
      final statement = buildStatement(
        entries: [
          entry('old', 100, at: DateTime.utc(2026, 9, 10)),
          entry('new', 100, at: DateTime.utc(2026, 9, 16)),
        ],
        reportedBalance: inr(200),
        deposits: inr(0),
        currency: 'INR',
      );
      expect(statement.entries.map((e) => e.entryId), ['new', 'old']);
    });

    test('a balance is described in words, not as a signed number', () {
      // A negative balance reads as an error to most people; the one thing a
      // patient at a desk needs is which way round it is.
      expect(describeBalance(inr(5000)), 'Owes INR 50.00');
      expect(describeBalance(inr(-5000)), 'In credit INR 50.00');
      expect(describeBalance(inr(0)), 'Settled');
    });

    test('deposits held are reported beside the balance', () {
      final statement = buildStatement(
        entries: [entry('a', 10000)],
        reportedBalance: inr(10000),
        deposits: inr(2500),
        currency: 'INR',
      );
      expect(describeAccountHeader(statement), contains('25.00 on deposit'));
      expect(describeAccountHeader(statement), contains('100.00 outstanding'));
    });
  });

  group('an issued invoice is never edited', () {
    PresentedInvoice invoice(InvoiceStatus status) => presentInvoice(
          invoiceId: 'i1', number: 'INV-1', status: status, total: inr(10000),
        );

    test('only a draft is editable', () {
      expect(invoice(InvoiceStatus.draft).editable, isTrue);
      for (final status in [
        InvoiceStatus.issued,
        InvoiceStatus.superseded,
        InvoiceStatus.cancelled,
        InvoiceStatus.unspecified,
        InvoiceStatus.unrecognised,
      ]) {
        expect(invoice(status).editable, isFalse,
            reason: '$status was editable');
      }
    });

    test('only an issued invoice may be corrected', () {
      // A superseded or cancelled document is not corrected again; the
      // correction goes against whatever replaced it.
      expect(invoice(InvoiceStatus.issued).correctable, isTrue);
      expect(invoice(InvoiceStatus.superseded).correctable, isFalse);
      expect(invoice(InvoiceStatus.cancelled).correctable, isFalse);
      expect(invoice(InvoiceStatus.draft).correctable, isFalse);
    });

    test('an unreadable status is neither editable nor correctable', () {
      expect(invoice(InvoiceStatus.unrecognised).editable, isFalse);
      expect(invoice(InvoiceStatus.unrecognised).correctable, isFalse);
    });
  });

  group('taking a payment', () {
    PaymentValidity check({
      Money? amount,
      PaymentMethod method = PaymentMethod.cash,
      String key = 'idem-1',
      String accountId = 'acc-1',
    }) =>
        validatePayment(
          amount: amount ?? inr(1000),
          method: method,
          idempotencyKey: key,
          accountId: accountId,
        );

    test('a valid payment is ready', () {
      expect(check().ready, isTrue);
    });

    test('an unreadable amount is refused as an amount, not as zero', () {
      final validity = validatePayment(
        amount: parseMoney('abc', 'INR'),
        method: PaymentMethod.cash,
        idempotencyKey: 'k',
        accountId: 'a',
      );
      expect(validity.ready, isFalse);
      expect(validity.problems, contains('Enter an amount.'));
    });

    test('zero and negative payments are refused with the right advice', () {
      // A refund is its own operation against the original payment.
      for (final minor in [0, -100]) {
        final validity = check(amount: inr(minor));
        expect(validity.ready, isFalse);
        expect(validity.problems.first, contains('Use a refund'));
      }
    });

    test('a payment with no method is refused', () {
      expect(check(method: PaymentMethod.unspecified).ready, isFalse);
      expect(check(method: PaymentMethod.unrecognised).ready, isFalse);
    });

    test('a payment with no idempotency key is refused', () {
      // A key minted on the click changes on every retry, so a double
      // submission produces two receipts (SRS-BIL-008).
      expect(check(key: '').ready, isFalse);
      expect(check(key: '  ').ready, isFalse);
    });

    test('a payment with no account is refused', () {
      expect(check(accountId: '').ready, isFalse);
    });

    test('every problem is reported at once', () {
      final validity = validatePayment(
        amount: null, method: PaymentMethod.unspecified,
        idempotencyKey: '', accountId: '',
      );
      expect(validity.problems, hasLength(4));
    });
  });

  group('closing an account', () {
    test('no exceptions means it can be closed', () {
      final readiness = closeReadiness([]);
      expect(readiness.ready, isTrue);
      expect(readiness.message, contains('can be closed'));
    });

    test('exceptions are listed, not summarised', () {
      // "Cannot close" with no list is a dead end for whoever is at the desk.
      final readiness = closeReadiness([
        CloseException(
          check: 'unbilled-charges',
          detail: 'Two charges are not on an invoice.',
          amount: inr(4500),
          references: const ['chg-1', 'chg-2'],
        ),
      ]);
      expect(readiness.ready, isFalse);
      expect(readiness.exceptions.single.references, ['chg-1', 'chg-2']);
      expect(readiness.message, startsWith('One thing'));
    });

    test('the message counts the exceptions', () {
      expect(
        closeReadiness([
          const CloseException(check: 'a', detail: 'a'),
          const CloseException(check: 'b', detail: 'b'),
        ]).message,
        startsWith('2 things'),
      );
    });
  });

  group('charges', () {
    PresentedCharge charge(ChargeStatus status) => presentCharge(
          chargeId: 'c1', display: 'Consultation', status: status,
          total: inr(50000),
        );

    test('posted and held charges are unbilled; invoiced and voided are not', () {
      expect(charge(ChargeStatus.posted).unbilled, isTrue);
      expect(charge(ChargeStatus.held).unbilled, isTrue);
      expect(charge(ChargeStatus.invoiced).unbilled, isFalse);
      expect(charge(ChargeStatus.voided).unbilled, isFalse);
    });

    test('the unbilled total counts only the unbilled', () {
      final total = unbilledTotal([
        charge(ChargeStatus.posted),
        charge(ChargeStatus.invoiced),
        charge(ChargeStatus.held),
      ], 'INR');
      expect(total, inr(100000));
    });

    test('an unreadable status is not counted as unbilled', () {
      expect(charge(ChargeStatus.unrecognised).unbilled, isFalse);
    });
  });

  group('tax rates', () {
    test('a rate held in basis points renders exactly', () {
      // 0.18 is not representable as a float; a tax line computed from one
      // does not reconcile against the server's.
      expect(formatRate(1800), '18%');
      expect(formatRate(500), '5%');
      expect(formatRate(1250), '12.5%');
      expect(formatRate(1234), '12.34%');
      expect(formatRate(0), '0%');
    });
  });
}
