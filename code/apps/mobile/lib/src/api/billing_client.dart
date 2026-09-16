/// Typed client for healthcare.billing.v1.BillingService.
///
/// The cashier's desk: what is owed, what is unbilled, taking a payment, and
/// whether the account can be closed. Raising and correcting invoices stays on
/// the web — an invoice is a document somebody checks line by line before it
/// goes to a patient, and that is not a thing to do on a phone.
library;

import '../gen/healthcare/billing/v1/billing.pb.dart';
import 'connect_client.dart';

class BillingClient {
  BillingClient(this._connect);

  final ConnectClient _connect;

  static const _service = '/healthcare.billing.v1.BillingService';

  /// The ledger, the balance and the deposits held.
  Future<StatementResponse> statement({required String accountId}) {
    return _connect.unary(
      procedure: '$_service/Statement',
      request: StatementRequest(accountId: accountId),
      parse: StatementResponse.fromBuffer,
    );
  }

  /// The charges on an account.
  Future<ListChargesResponse> listCharges({
    required String accountId,
    int pageSize = 200,
  }) {
    return _connect.unary(
      procedure: '$_service/ListCharges',
      request: ListChargesRequest(accountId: accountId, pageSize: pageSize),
      parse: ListChargesResponse.fromBuffer,
    );
  }

  /// The invoices on an account.
  Future<ListInvoicesResponse> listInvoices({
    required String accountId,
    int pageSize = 100,
  }) {
    return _connect.unary(
      procedure: '$_service/ListInvoices',
      request: ListInvoicesRequest(accountId: accountId, pageSize: pageSize),
      parse: ListInvoicesResponse.fromBuffer,
    );
  }

  /// Takes a payment.
  ///
  /// [idempotencyKey] is supplied by the caller rather than minted here, and
  /// that is the whole point of it: a key generated inside this method would be
  /// new on every retry, so a resent request after a timeout would produce a
  /// second receipt for the same money (SRS-BIL-008).
  Future<ReceivePaymentResponse> receivePayment({
    required String accountId,
    required Money amount,
    required PaymentMethod method,
    required String idempotencyKey,
    String invoiceId = '',
    String providerRef = '',
    bool deposit = false,
    String reason = '',
  }) {
    return _connect.unary(
      procedure: '$_service/ReceivePayment',
      request: ReceivePaymentRequest(
        accountId: accountId,
        amount: amount,
        method: method,
        idempotencyKey: idempotencyKey,
        invoiceId: invoiceId,
        providerRef: providerRef,
        deposit: deposit,
        reason: reason,
      ),
      parse: ReceivePaymentResponse.fromBuffer,
    );
  }

  /// Asks what is outstanding before the account could be closed.
  ///
  /// A read, separate from CloseAccount, so the desk can show the list without
  /// attempting the close — "cannot close" discovered by trying is a worse
  /// experience than being told beforehand what to fix.
  Future<CloseReadinessResponse> closeReadiness({required String accountId}) {
    return _connect.unary(
      procedure: '$_service/CloseReadiness',
      request: CloseReadinessRequest(accountId: accountId),
      parse: CloseReadinessResponse.fromBuffer,
    );
  }
}
