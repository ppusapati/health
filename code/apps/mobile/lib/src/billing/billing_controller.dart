/// Loading the account, and taking a payment.
library;

import 'package:fixnum/fixnum.dart';

import '../api/api_error.dart';
import '../api/billing_client.dart';
import '../api/idempotency.dart';
import '../gen/healthcare/billing/v1/billing.pb.dart' as wire;
import '../screens/billing_screen.dart';
import 'account.dart';
import 'mapping.dart';
import 'money.dart';

class BillingController {
  /// Positional because a named parameter cannot be a private initializing
  /// formal. The key factory is injected so a test can mint predictable keys,
  /// and because where the key comes from is the whole of SRS-BIL-008.
  BillingController(this._billing, this._newIdempotencyKey);

  final BillingClient _billing;
  final String Function() _newIdempotencyKey;

  String _accountId = '';
  String _currency = '';
  Statement? _statement;
  List<PresentedInvoice> _invoices = const [];
  List<PresentedCharge> _charges = const [];
  List<CloseException> _closeExceptions = const [];
  String _typedAmount = '';
  PaymentMethod _method = PaymentMethod.unspecified;

  /// Minted once when the amount is first entered, not on the button press.
  ///
  /// This is the point of the whole mechanism: a key generated on the click is
  /// new on every retry, so a resent request after a timeout takes the money
  /// twice. Minting it when the payment starts being composed means the retry
  /// carries the same key the first attempt did (SRS-BIL-008).
  String _idempotencyKey = '';

  String? _failure;
  bool _loading = false;

  BillingView? _view;

  BillingView? get view => _view;
  String? get failure => _failure;
  bool get loading => _loading;

  void _rebuild() {
    final statement = _statement;
    if (statement == null) {
      return;
    }
    _view = BillingView(
      statement: statement,
      currency: _currency,
      invoices: _invoices,
      charges: _charges,
      closeExceptions: _closeExceptions,
      typedAmount: _typedAmount,
      method: _method,
      idempotencyKey: _idempotencyKey,
      accountId: _accountId,
    );
  }

  /// Loads the statement, the charges, the invoices and what blocks closing.
  Future<void> load({required String accountId}) async {
    _accountId = accountId;
    _loading = true;
    try {
      // Issued together: four responses arriving seconds apart would describe
      // four different moments, and the balance would be reconciled against a
      // ledger from one of the others.
      final statementRequest = _billing.statement(accountId: accountId);
      final chargesRequest = _billing.listCharges(accountId: accountId);
      final invoicesRequest = _billing.listInvoices(accountId: accountId);
      final closingRequest = _billing.closeReadiness(accountId: accountId);

      final statement = await statementRequest;
      final charges = await chargesRequest;
      final invoices = await invoicesRequest;
      final closing = await closingRequest;

      // The account's own currency, which every amount without one falls back
      // to. Taken from the balance rather than assumed.
      _currency = statement.balance.currency.isNotEmpty
          ? statement.balance.currency.toUpperCase()
          : statement.account.currency.toUpperCase();

      _statement = buildStatement(
        entries: [
          for (final entry in statement.entries)
            entryOf(entry, currency: _currency),
        ],
        reportedBalance: moneyOf(statement.balance, fallbackCurrency: _currency),
        deposits: moneyOf(statement.deposits, fallbackCurrency: _currency),
        currency: _currency,
      );
      _charges = [
        for (final charge in charges.charges) chargeOf(charge, currency: _currency),
      ];
      _invoices = [
        for (final invoice in invoices.invoices)
          invoiceOf(invoice, currency: _currency),
      ];
      _closeExceptions = [
        for (final exception in closing.exceptions)
          closeExceptionOf(exception, currency: _currency),
      ];
      _failure = null;
    } on ApiError catch (error) {
      _failure = error.message;
    } finally {
      _loading = false;
      _rebuild();
    }
  }

  /// Records what the cashier typed, minting the idempotency key once.
  void setAmount(String typed) {
    _typedAmount = typed;
    if (_idempotencyKey.isEmpty && typed.trim().isNotEmpty) {
      _idempotencyKey = _newIdempotencyKey();
    }
    _rebuild();
  }

  void setMethod(PaymentMethod method) {
    _method = method;
    _rebuild();
  }

  /// Takes the payment.
  ///
  /// Returns the ledger entry, or null when it was refused. On success the
  /// composed payment is cleared — including the idempotency key, because the
  /// next payment is a different payment and reusing the key would make the
  /// server treat it as a repeat of this one and return this receipt again.
  Future<wire.LedgerEntry?> takePayment() async {
    final amount = parseMoney(_typedAmount, _currency);
    final validity = validatePayment(
      amount: amount,
      method: _method,
      idempotencyKey: _idempotencyKey,
      accountId: _accountId,
    );
    if (!validity.ready) {
      _failure = validity.problems.first;
      _rebuild();
      return null;
    }

    final method = wireMethodOf(_method);
    if (method == null) {
      _failure = 'Choose how the money was taken.';
      _rebuild();
      return null;
    }

    try {
      final response = await _billing.receivePayment(
        accountId: _accountId,
        amount: wire.Money(
          minor: Int64(amount!.minor),
          currency: amount.currency,
        ),
        method: method,
        idempotencyKey: _idempotencyKey,
      );
      _typedAmount = '';
      _method = PaymentMethod.unspecified;
      _idempotencyKey = '';
      _failure = null;
      await load(accountId: _accountId);
      return response.entry;
    } on ApiError catch (error) {
      // The key is deliberately kept: this payment may well be retried, and
      // the retry has to carry the same key or the server cannot tell it is
      // the same money.
      _failure = error.message;
      _rebuild();
      return null;
    }
  }
}

/// The idempotency key factory the shell uses.
String defaultIdempotencyKey() => newIdempotencyKey();
