/// The cashier's desk (UX-W1-06).
///
/// The balance, the ledger behind it, what is unbilled, and taking a payment.
///
/// The one thing this screen must never do is show a figure it cannot account
/// for. When the derived balance and the server's disagree, it says so and
/// shows the one it can explain line by line, rather than picking whichever
/// arrived last — a cashier taking money against a number nobody can reconcile
/// is how a dispute starts.
///
/// The reasoning is in `billing/money.dart` and `billing/account.dart`; this
/// renders it.
library;

import 'package:flutter/material.dart';

import '../billing/account.dart';
import '../billing/money.dart';
import '../ui/states.dart';

/// Everything the billing screen renders.
class BillingView {
  const BillingView({
    required this.statement,
    required this.currency,
    this.invoices = const [],
    this.charges = const [],
    this.closeExceptions = const [],
    this.typedAmount = '',
    this.method = PaymentMethod.unspecified,
    this.idempotencyKey = '',
    this.accountId = '',
    this.grouping = MoneyGrouping.thousands,
  });

  final Statement statement;
  final String currency;
  final List<PresentedInvoice> invoices;
  final List<PresentedCharge> charges;
  final List<CloseException> closeExceptions;

  /// What the cashier has typed, unparsed. Held as text so the field can show
  /// exactly what was entered while the parse decides whether it means
  /// anything.
  final String typedAmount;

  final PaymentMethod method;
  final String idempotencyKey;
  final String accountId;
  final MoneyGrouping grouping;

  /// The typed amount as money, or null when it cannot be read.
  Money? get amount => parseMoney(typedAmount, currency);

  PaymentValidity get payment => validatePayment(
        amount: amount,
        method: method,
        idempotencyKey: idempotencyKey,
        accountId: accountId,
      );

  CloseReadiness get closing => closeReadiness(closeExceptions);

  Money get unbilled => unbilledTotal(charges, currency);
}

class BillingScreen extends StatefulWidget {
  const BillingScreen({
    super.key,
    required this.view,
    this.loading = false,
    this.failure,
    this.onRetry,
    this.onAmountChanged,
    this.onMethodChanged,
    this.onTakePayment,
  });

  final BillingView? view;
  final bool loading;
  final String? failure;
  final VoidCallback? onRetry;

  final void Function(String typed)? onAmountChanged;
  final void Function(PaymentMethod method)? onMethodChanged;
  final VoidCallback? onTakePayment;

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final _amount = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = widget.view;

    if (widget.loading && view == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.loading,
          title: 'Loading the account…',
        ),
      );
    }
    if (widget.failure != null && view == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: ScreenState(
          kind: ScreenStateKind.failure,
          title: widget.failure!,
          onRetry: widget.onRetry,
        ),
      );
    }
    if (view == null) {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (widget.failure != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ScreenState(
              kind: ScreenStateKind.failure,
              title: widget.failure!,
              onRetry: widget.onRetry,
            ),
          ),
        _balance(view),
        const SizedBox(height: 12),
        _payment(view),
        const SizedBox(height: 12),
        _unbilled(view),
        const SizedBox(height: 12),
        _invoices(view),
        const SizedBox(height: 12),
        _closing(view),
        const SizedBox(height: 12),
        _ledger(view),
      ],
    );
  }

  Widget _card(String title, List<Widget> children) => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ...children,
            ],
          ),
        ),
      );

  Widget _balance(BillingView view) {
    final statement = view.statement;
    final shown = statement.reconciles
        ? statement.reportedBalance
        : statement.derivedBalance;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Card(
        color: statement.reconciles ? null : const Color(0xFFFFF4E5),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Words, not a signed number. A negative balance reads as an
              // error to most people, and which way round it is is the one
              // thing a patient at a desk needs.
              Text(
                describeBalance(shown, grouping: view.grouping),
                key: const Key('balance'),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (!isZero(statement.deposits))
                Text('${formatMoney(statement.deposits, grouping: view.grouping)}'
                    ' held on deposit'),
              if (!statement.reconciles)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'This balance does not match the one the server reported '
                    '(${formatMoney(statement.reportedBalance, grouping: view.grouping)}). '
                    'The figure above is the one the entries below add up to. '
                    'Do not take payment against it until this is checked.',
                    key: const Key('reconciliation-warning'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _payment(BillingView view) {
    final validity = view.payment;

    return _card('Take a payment', [
      TextField(
        key: const Key('payment-amount'),
        controller: _amount,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: widget.onAmountChanged,
        decoration: InputDecoration(
          labelText: 'Amount in ${view.currency}',
          border: const OutlineInputBorder(),
          // The parse refuses rather than guessing, and says so here instead
          // of letting a typing slip become a payment of zero.
          errorText: view.typedAmount.trim().isNotEmpty && view.amount == null
              ? 'That is not an amount this currency can take.'
              : null,
        ),
      ),
      const SizedBox(height: 8),
      DropdownButtonFormField<PaymentMethod>(
        key: const Key('payment-method'),
        initialValue: view.method,
        decoration: const InputDecoration(
          labelText: 'How it was taken',
          border: OutlineInputBorder(),
        ),
        items: [
          for (final method in PaymentMethod.values)
            if (method != PaymentMethod.unrecognised)
              DropdownMenuItem(
                value: method,
                child: Text(describeMethod(method)),
              ),
        ],
        onChanged: (method) {
          if (method != null) widget.onMethodChanged?.call(method);
        },
      ),
      const SizedBox(height: 8),
      for (final problem in validity.problems)
        Text('• $problem', key: Key('payment-problem-$problem')),
      const SizedBox(height: 8),
      // Absent until the payment is takeable. A disabled button beside an
      // unreadable amount reads as a permission problem.
      if (validity.ready)
        FilledButton(
          key: const Key('take-payment'),
          onPressed: widget.onTakePayment,
          child: Text('Take ${formatMoney(view.amount!, grouping: view.grouping)}'),
        ),
    ]);
  }

  Widget _unbilled(BillingView view) => _card('Not yet invoiced', [
        Text(
          formatMoney(view.unbilled, grouping: view.grouping),
          key: const Key('unbilled-total'),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        for (final charge in view.charges)
          if (charge.unbilled)
            Padding(
              key: Key('charge-${charge.chargeId}'),
              padding: const EdgeInsets.only(top: 4),
              child: Text('${charge.display} — '
                  '${formatMoney(charge.total, grouping: view.grouping)} '
                  '(${charge.statusLabel})'),
            ),
        // Held charges are listed below the total rather than inside it. They
        // are not going on the next invoice, so counting them would inflate a
        // figure somebody quotes — but they are work waiting on a coding query
        // or an authorisation, and dropping them off the screen hides it.
        for (final charge in view.charges)
          if (charge.held)
            Padding(
              key: Key('held-${charge.chargeId}'),
              padding: const EdgeInsets.only(top: 4),
              child: Text('Held: ${charge.display} — '
                  '${formatMoney(charge.total, grouping: view.grouping)} '
                  '(not counted above)'),
            ),
      ]);

  Widget _invoices(BillingView view) => _card('Invoices', [
        if (view.invoices.isEmpty)
          const Text('None yet.', key: Key('invoices-empty')),
        for (final invoice in view.invoices)
          Padding(
            key: Key('invoice-${invoice.invoiceId}'),
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${invoice.number} · '
                    '${formatMoney(invoice.total, grouping: view.grouping)} · '
                    '${invoice.statusLabel}'),
                // No edit control at any status but draft, and none rendered
                // even then on this device: the patient may be holding a copy,
                // and a system that can quietly change what a document said is
                // a system whose documents prove nothing. A correction is a
                // credit or debit note, raised at a desk.
                if (invoice.correctable)
                  const Text('Corrections are raised as a credit or debit note.'),
                if (invoice.supersededBy.isNotEmpty)
                  Text('Superseded by ${invoice.supersededBy}'),
              ],
            ),
          ),
      ]);

  Widget _closing(BillingView view) {
    final closing = view.closing;
    return _card('Closing the account', [
      Text(closing.message, key: const Key('close-message')),
      // Listed, not summarised: "cannot close" with no list is a dead end for
      // whoever is at the desk.
      for (final exception in closing.exceptions)
        Padding(
          key: Key('close-exception-${exception.check}'),
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            exception.amount != null
                ? '${exception.detail} '
                    '(${formatMoney(exception.amount!, grouping: view.grouping)})'
                : exception.detail,
          ),
        ),
    ]);
  }

  Widget _ledger(BillingView view) => _card('Ledger', [
        if (view.statement.entries.isEmpty)
          const Text('Nothing recorded.', key: Key('ledger-empty')),
        for (final entry in view.statement.entries)
          Padding(
            key: Key('entry-${entry.entryId}'),
            padding: const EdgeInsets.only(bottom: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${entry.kindLabel} · '
                    '${formatMoney(entry.amount, grouping: view.grouping)}'),
                if (entry.receiptNumber.isNotEmpty)
                  Text('Receipt ${entry.receiptNumber} · ${entry.methodLabel}'),
              ],
            ),
          ),
      ]);
}
