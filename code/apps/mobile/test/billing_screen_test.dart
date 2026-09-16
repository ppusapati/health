import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_mobile/src/billing/account.dart';
import 'package:health_mobile/src/billing/money.dart';
import 'package:health_mobile/src/screens/billing_screen.dart';

Money inr(int minor) => Money(minor: minor, currency: 'INR');

Statement statement({
  List<PresentedEntry> entries = const [],
  int reported = 0,
  int deposits = 0,
}) =>
    buildStatement(
      entries: entries,
      reportedBalance: inr(reported),
      deposits: inr(deposits),
      currency: 'INR',
    );

PresentedEntry entry(String id, int minor) => presentEntry(
      entryId: id,
      kind: minor > 0 ? EntryKind.invoice : EntryKind.payment,
      amount: inr(minor),
      occurredAt: DateTime.utc(2026, 9, 16, 9),
      receiptNumber: minor < 0 ? 'RCT-$id' : '',
      method: minor < 0 ? PaymentMethod.cash : PaymentMethod.unspecified,
    );

Future<void> pump(WidgetTester tester, Widget child) =>
    tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

void main() {
  group('the balance', () {
    testWidgets('is shown in words, not as a signed number', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(entries: [entry('a', 12345)], reported: 12345),
        currency: 'INR',
      )));
      expect(tester.widget<Text>(find.byKey(const Key('balance'))).data,
          'Owes INR 123.45');
    });

    testWidgets('a credit is described as credit, never as minus', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(entries: [entry('a', -5000)], reported: -5000),
        currency: 'INR',
      )));
      final text = tester.widget<Text>(find.byKey(const Key('balance'))).data!;
      expect(text, 'In credit INR 50.00');
      expect(text, isNot(contains('-')));
    });

    testWidgets('a disagreement is warned about and not resolved silently',
        (tester) async {
      // The screen shows the figure it can account for line by line, and says
      // not to take money against it.
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(entries: [entry('a', 10000)], reported: 6000),
        currency: 'INR',
      )));
      expect(tester.widget<Text>(find.byKey(const Key('balance'))).data,
          'Owes INR 100.00');
      final warning = tester.widget<Text>(
          find.byKey(const Key('reconciliation-warning'))).data!;
      expect(warning, contains('INR 60.00'));
      expect(warning, contains('Do not take payment'));
    });

    testWidgets('an agreeing balance shows no warning', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(entries: [entry('a', 10000)], reported: 10000),
        currency: 'INR',
      )));
      expect(find.byKey(const Key('reconciliation-warning')), findsNothing);
    });

    testWidgets('deposits held are shown beside the balance', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(
            entries: [entry('a', 10000)], reported: 10000, deposits: 2500),
        currency: 'INR',
      )));
      expect(find.textContaining('INR 25.00 held on deposit'), findsOneWidget);
    });
  });

  group('taking a payment', () {
    testWidgets('an unreadable amount is refused with a reason, not zeroed',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: 'abc', method: PaymentMethod.cash,
        idempotencyKey: 'k', accountId: 'a',
      )));
      expect(find.text('That is not an amount this currency can take.'),
          findsOneWidget);
      expect(find.byKey(const Key('take-payment')), findsNothing);
    });

    testWidgets('too much precision for the currency is refused', (tester) async {
      // 10.005 silently becoming 10.01 on a receipt is a discrepancy somebody
      // reconciles later.
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: '10.005', method: PaymentMethod.cash,
        idempotencyKey: 'k', accountId: 'a',
      )));
      expect(find.byKey(const Key('take-payment')), findsNothing);
    });

    testWidgets('a valid payment offers a button naming the exact amount',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: '1,234.50', method: PaymentMethod.cash,
        idempotencyKey: 'k', accountId: 'a',
      )));
      expect(find.text('Take INR 1,234.50'), findsOneWidget);
    });

    testWidgets('a zero payment is refused and points at a refund',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: '0', method: PaymentMethod.cash,
        idempotencyKey: 'k', accountId: 'a',
      )));
      expect(find.textContaining('Use a refund'), findsOneWidget);
      expect(find.byKey(const Key('take-payment')), findsNothing);
    });

    testWidgets('a payment with no method is refused', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: '100', method: PaymentMethod.unspecified,
        idempotencyKey: 'k', accountId: 'a',
      )));
      expect(find.textContaining('Choose how the money was taken'),
          findsOneWidget);
    });

    testWidgets('a missing idempotency key is refused, not generated',
        (tester) async {
      // A key minted on the click is new on every retry, so a resend produces
      // a second receipt.
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        typedAmount: '100', method: PaymentMethod.cash,
        idempotencyKey: '', accountId: 'a',
      )));
      expect(find.textContaining('no idempotency key'), findsOneWidget);
      expect(find.byKey(const Key('take-payment')), findsNothing);
    });

    testWidgets('the method list offers no unrecognised option', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
      )));
      expect(find.text(describeMethod(PaymentMethod.unrecognised)), findsNothing);
    });

    testWidgets('typing reports what was typed, unparsed', (tester) async {
      String? typed;
      await pump(tester, BillingScreen(
        view: BillingView(statement: statement(), currency: 'INR'),
        onAmountChanged: (t) => typed = t,
      ));
      await tester.enterText(find.byKey(const Key('payment-amount')), '12.34');
      expect(typed, '12.34');
    });
  });

  group('invoices and charges', () {
    testWidgets('no invoice offers an edit control at any status',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        invoices: [
          for (final status in InvoiceStatus.values)
            presentInvoice(
              invoiceId: 'i-${status.name}', number: 'INV-${status.name}',
              status: status, total: inr(10000),
            ),
        ],
      )));
      expect(find.text('Edit'), findsNothing);
      expect(find.textContaining('Edit invoice'), findsNothing);
    });

    testWidgets('an issued invoice explains how a correction is made',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        invoices: [presentInvoice(
          invoiceId: 'i1', number: 'INV-1',
          status: InvoiceStatus.issued, total: inr(10000),
        )],
      )));
      expect(find.textContaining('credit or debit note'), findsOneWidget);
    });

    testWidgets('the unbilled total counts only unbilled charges',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        charges: [
          presentCharge(chargeId: 'c1', display: 'Consultation',
              status: ChargeStatus.posted, total: inr(50000)),
          presentCharge(chargeId: 'c2', display: 'X-ray',
              status: ChargeStatus.invoiced, total: inr(30000)),
        ],
      )));
      expect(tester.widget<Text>(find.byKey(const Key('unbilled-total'))).data,
          'INR 500.00');
      expect(find.byKey(const Key('charge-c1')), findsOneWidget);
      expect(find.byKey(const Key('charge-c2')), findsNothing);
    });

    testWidgets('a held charge is shown but not counted', (tester) async {
      // Counting it inflates a figure somebody quotes; hiding it loses work
      // waiting on a coding query.
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        charges: [
          presentCharge(chargeId: 'c1', display: 'Consultation',
              status: ChargeStatus.posted, total: inr(50000)),
          presentCharge(chargeId: 'c2', display: 'Theatre',
              status: ChargeStatus.held, total: inr(90000)),
        ],
      )));
      expect(tester.widget<Text>(find.byKey(const Key('unbilled-total'))).data,
          'INR 500.00');
      expect(find.byKey(const Key('charge-c2')), findsNothing);
      expect(find.byKey(const Key('held-c2')), findsOneWidget);
      expect(find.textContaining('not counted above'), findsOneWidget);
    });
  });

  group('closing the account', () {
    testWidgets('a settled account says it can be closed', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
      )));
      expect(tester.widget<Text>(find.byKey(const Key('close-message'))).data,
          contains('can be closed'));
    });

    testWidgets('exceptions are listed with their amounts, not summarised',
        (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
        closeExceptions: [
          CloseException(
            check: 'unbilled',
            detail: 'Two charges are not on an invoice.',
            amount: inr(4500),
          ),
        ],
      )));
      expect(find.byKey(const Key('close-exception-unbilled')), findsOneWidget);
      expect(find.textContaining('INR 45.00'), findsOneWidget);
    });
  });

  group('the ledger', () {
    // The ledger sits below the fold, and a ListView builds lazily, so these
    // scroll rather than asserting against widgets that were never built.
    testWidgets('entries show their amount and receipt', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(entries: [entry('a', -5000)], reported: -5000),
        currency: 'INR',
      )));
      await tester.scrollUntilVisible(
        find.byKey(const Key('entry-a')), 200,
        // Named explicitly: the method dropdown is a scrollable too, and
        // leaving it to find one would fail on "too many elements".
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.textContaining('Payment · INR -50.00'), findsOneWidget);
      expect(find.textContaining('Receipt RCT-a · Cash'), findsOneWidget);
    });

    testWidgets('an empty ledger says so', (tester) async {
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(), currency: 'INR',
      )));
      await tester.scrollUntilVisible(
        find.byKey(const Key('ledger-empty')), 200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.byKey(const Key('ledger-empty')), findsOneWidget);
    });
  });

  group('states', () {
    testWidgets('loading with nothing yet says so', (tester) async {
      await pump(tester, const BillingScreen(view: null, loading: true));
      expect(find.textContaining('Loading the account'), findsOneWidget);
    });

    testWidgets('a failure with nothing yet offers a retry', (tester) async {
      var retried = false;
      await pump(tester, BillingScreen(
        view: null, failure: 'Cannot reach billing.',
        onRetry: () => retried = true,
      ));
      await tester.tap(find.text('Try again'));
      expect(retried, isTrue);
    });

    testWidgets('meets the platform accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, BillingScreen(view: BillingView(
        statement: statement(
            entries: [entry('a', 10000), entry('b', -4000)], reported: 6000),
        currency: 'INR',
        typedAmount: '100', method: PaymentMethod.cash,
        idempotencyKey: 'k', accountId: 'a',
        charges: [presentCharge(chargeId: 'c1', display: 'Consultation',
            status: ChargeStatus.posted, total: inr(50000))],
        invoices: [presentInvoice(invoiceId: 'i1', number: 'INV-1',
            status: InvoiceStatus.issued, total: inr(10000))],
      )));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
