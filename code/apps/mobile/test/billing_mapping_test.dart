import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/billing/account.dart';
import 'package:health_mobile/src/billing/mapping.dart';
import 'package:health_mobile/src/billing/money.dart';
import 'package:health_mobile/src/gen/healthcare/billing/v1/billing.pb.dart' as wire;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';

List<int> withVarintField(List<int> encoded, int tag, int value) {
  final out = [...encoded];
  _varint(out, (tag << 3) | 0);
  _varint(out, value);
  return out;
}

void _varint(List<int> out, int value) {
  var v = value;
  while (v >= 0x80) {
    out.add((v & 0x7f) | 0x80);
    v >>= 7;
  }
  out.add(v);
}

wire.Money wireMoney(int minor, [String currency = 'INR']) =>
    wire.Money(minor: Int64(minor), currency: currency);

void main() {
  group('money crosses the boundary as an integer', () {
    test('minor units arrive exactly, at any magnitude the ledger holds', () {
      expect(moneyOf(wireMoney(1234567)).minor, 1234567);
      // Larger than a double stays exact past 2^53.
      expect(moneyOf(wireMoney(9007199254740993)).minor, 9007199254740993);
      expect(moneyOf(wireMoney(9223372036854775807)).minor,
          9223372036854775807);
    });

    test('a negative amount keeps its sign', () {
      expect(moneyOf(wireMoney(-4500)).minor, -4500);
    });

    test('the currency is normalised to upper case', () {
      expect(moneyOf(wireMoney(100, 'inr')).currency, 'INR');
    });

    test('an amount with no currency takes the account\'s rather than none', () {
      // A blank currency renders as a bare number, which on a receipt is worse
      // than a wrong one: it cannot even be questioned.
      expect(moneyOf(wire.Money(minor: Int64(0)), fallbackCurrency: 'INR')
          .currency, 'INR');
    });
  });

  group('an enum from a newer contract', () {
    test('an unreadable invoice status is never editable', () {
      // The patient may be holding a copy of it.
      final bytes = withVarintField(
        wire.Invoice(invoiceId: 'i1').writeToBuffer(),
        invoiceStatusField,
        9999,
      );
      final invoice = invoiceOf(wire.Invoice.fromBuffer(bytes));
      expect(invoice.status, InvoiceStatus.unrecognised);
      expect(invoice.editable, isFalse);
      expect(invoice.correctable, isFalse);
    });

    test('an unreadable charge status is not counted as unbilled', () {
      // Counting it would add it to a total somebody bills from.
      final bytes = withVarintField(
        wire.Charge(chargeId: 'c1').writeToBuffer(), chargeStatusField, 9999,
      );
      final charge = chargeOf(wire.Charge.fromBuffer(bytes));
      expect(charge.status, ChargeStatus.unrecognised);
      expect(charge.unbilled, isFalse);
      expect(unbilledTotal([charge], 'INR'), const Money(minor: 0, currency: 'INR'));
    });

    test('an unreadable entry kind does not change the ledger arithmetic', () {
      // The direction comes from the sign, so an unreadable kind is a label
      // problem and never a balance problem.
      final bytes = withVarintField(
        wire.LedgerEntry(entryId: 'e1', amount: wireMoney(-5000))
            .writeToBuffer(),
        entryKindField,
        9999,
      );
      final entry = entryOf(wire.LedgerEntry.fromBuffer(bytes));
      expect(entry.kind, EntryKind.unrecognised);
      expect(entry.increasesDebt, isFalse);
      expect(entry.amount.minor, -5000);
    });

    test('an unreadable payment method cannot be sent back', () {
      final bytes = withVarintField(
        wire.LedgerEntry(entryId: 'e1').writeToBuffer(), entryMethodField, 9999,
      );
      final method = methodOf(wire.LedgerEntry.fromBuffer(bytes));
      expect(method, PaymentMethod.unrecognised);
      expect(wireMethodOf(method), isNull);
      expect(wireMethodOf(PaymentMethod.unspecified), isNull);
      expect(wireMethodOf(PaymentMethod.cash),
          wire.PaymentMethod.PAYMENT_METHOD_CASH);
    });

    test('the field tags are the ones the contract actually uses', () {
      final entry = wire.LedgerEntry.getDefault().info_;
      expect(entry.byName['kind']!.tagNumber, entryKindField);
      expect(entry.byName['method']!.tagNumber, entryMethodField);
      expect(wire.Invoice.getDefault().info_.byName['status']!.tagNumber,
          invoiceStatusField);
      expect(wire.Charge.getDefault().info_.byName['status']!.tagNumber,
          chargeStatusField);
    });

    test('every enum the contract defines maps to something usable', () {
      for (final k in wire.EntryKind.values) {
        expect(entryKindOf(wire.LedgerEntry(kind: k)),
            isNot(EntryKind.unrecognised), reason: 'no mapping for ${k.name}');
      }
      for (final m in wire.PaymentMethod.values) {
        expect(methodOf(wire.LedgerEntry(method: m)),
            isNot(PaymentMethod.unrecognised),
            reason: 'no mapping for ${m.name}');
      }
      for (final s in wire.InvoiceStatus.values) {
        expect(invoiceStatusOf(wire.Invoice(status: s)),
            isNot(InvoiceStatus.unrecognised),
            reason: 'no mapping for ${s.name}');
      }
      for (final s in wire.ChargeStatus.values) {
        expect(chargeStatusOf(wire.Charge(status: s)),
            isNot(ChargeStatus.unrecognised),
            reason: 'no mapping for ${s.name}');
      }
    });
  });

  group('absent values stay absent', () {
    test('a draft invoice has no issue date, not the epoch', () {
      // The epoch rendered as an issue date reads as an invoice from 1970.
      final invoice = invoiceOf(wire.Invoice(
        invoiceId: 'i1',
        status: wire.InvoiceStatus.INVOICE_STATUS_DRAFT,
      ));
      expect(invoice.issuedAt, isNull);
    });

    test('an issued invoice carries its date in UTC', () {
      final issued = DateTime.utc(2026, 9, 16, 11);
      final invoice = invoiceOf(wire.Invoice(
        invoiceId: 'i1',
        status: wire.InvoiceStatus.INVOICE_STATUS_ISSUED,
        issuedAt: Timestamp.fromDateTime(issued),
      ));
      expect(invoice.issuedAt, issued);
      expect(invoice.issuedAt!.isUtc, isTrue);
    });

    test('a close exception with no amount has none, not zero', () {
      // Zero would render as "(INR 0.00)" beside a reason, which reads as
      // nothing being owed for it.
      final exception = closeExceptionOf(wire.CloseException(
        check_1: 'unsigned-consent', detail: 'A consent form is unsigned.',
      ));
      expect(exception.amount, isNull);
      expect(exception.check, 'unsigned-consent');
    });

    test('a charge with no description falls back to its service code', () {
      expect(
        chargeOf(wire.Charge(chargeId: 'c1', serviceCode: 'CONS-OP')).display,
        'CONS-OP',
      );
    });
  });

  group('the statement', () {
    test('derives the balance from the entries the server sent', () {
      final entries = [
        entryOf(wire.LedgerEntry(
          entryId: 'a',
          kind: wire.EntryKind.ENTRY_KIND_INVOICE,
          amount: wireMoney(10000),
          occurredAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 9)),
        )),
        entryOf(wire.LedgerEntry(
          entryId: 'b',
          kind: wire.EntryKind.ENTRY_KIND_PAYMENT,
          amount: wireMoney(-4000),
          occurredAt: Timestamp.fromDateTime(DateTime.utc(2026, 9, 16, 10)),
        )),
      ];
      final statement = buildStatement(
        entries: entries,
        reportedBalance: moneyOf(wireMoney(6000)),
        deposits: moneyOf(wireMoney(0), fallbackCurrency: 'INR'),
        currency: 'INR',
      );
      expect(statement.derivedBalance.minor, 6000);
      expect(statement.reconciles, isTrue);
    });
  });
}
