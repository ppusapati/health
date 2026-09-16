/// Wire types to the billing screens' models (UX-W1-06).
///
/// Same unknown-enum discipline as the other three workspaces; the reasoning is
/// in `reception/mapping.dart`.
///
/// One extra rule here, and it is the one this whole workspace exists to keep:
/// **money crosses this boundary as an integer and never as anything else.**
/// The proto carries `int64` minor units, `fixnum.Int64` arrives in Dart, and
/// `.toInt()` is exact on the 64-bit platforms this app ships to. Nothing in
/// this file divides, rounds, or touches a `double`.
library;

import 'package:protobuf/protobuf.dart' as pb;

import '../gen/healthcare/billing/v1/billing.pb.dart' as wire;
import 'account.dart';
import 'money.dart';

/// Field tags carrying the enums this module reads. Pinned by test.
const int entryKindField = 5; // billing.v1.LedgerEntry.kind
const int entryMethodField = 10; // billing.v1.LedgerEntry.method
const int invoiceStatusField = 4; // billing.v1.Invoice.status
const int chargeStatusField = 24; // billing.v1.Charge.status

/// True when [message] carried a value for [tag] this build could not read.
bool sentUnknownValueFor(pb.GeneratedMessage message, int tag) =>
    message.unknownFields.hasField(tag);

/// An amount, wire to model.
///
/// `toInt()` rather than any arithmetic: the minor units are already the exact
/// integer the ledger holds, and every operation that could lose a digit is one
/// this module declines to perform.
Money moneyOf(wire.Money amount, {String fallbackCurrency = ''}) => Money(
      minor: amount.minor.toInt(),
      // A currency-less amount is possible on the wire (a zero, usually) and a
      // blank currency renders as a bare number, which on a receipt is worse
      // than a wrong one — it cannot even be questioned.
      currency: amount.currency.isNotEmpty
          ? amount.currency.toUpperCase()
          : fallbackCurrency.toUpperCase(),
    );

EntryKind entryKindOf(wire.LedgerEntry entry) {
  if (sentUnknownValueFor(entry, entryKindField)) {
    return EntryKind.unrecognised;
  }
  return switch (entry.kind) {
    wire.EntryKind.ENTRY_KIND_INVOICE => EntryKind.invoice,
    wire.EntryKind.ENTRY_KIND_PAYMENT => EntryKind.payment,
    wire.EntryKind.ENTRY_KIND_REFUND => EntryKind.refund,
    wire.EntryKind.ENTRY_KIND_DEPOSIT => EntryKind.deposit,
    wire.EntryKind.ENTRY_KIND_DEPOSIT_APPLIED => EntryKind.depositApplied,
    wire.EntryKind.ENTRY_KIND_WRITE_OFF => EntryKind.writeOff,
    wire.EntryKind.ENTRY_KIND_ADJUSTMENT => EntryKind.adjustment,
    wire.EntryKind.ENTRY_KIND_UNSPECIFIED => EntryKind.unspecified,
    _ => EntryKind.unrecognised,
  };
}

PaymentMethod methodOf(wire.LedgerEntry entry) {
  if (sentUnknownValueFor(entry, entryMethodField)) {
    return PaymentMethod.unrecognised;
  }
  return switch (entry.method) {
    wire.PaymentMethod.PAYMENT_METHOD_CASH => PaymentMethod.cash,
    wire.PaymentMethod.PAYMENT_METHOD_CARD => PaymentMethod.card,
    wire.PaymentMethod.PAYMENT_METHOD_BANK_TRANSFER => PaymentMethod.bankTransfer,
    wire.PaymentMethod.PAYMENT_METHOD_UPI => PaymentMethod.upi,
    wire.PaymentMethod.PAYMENT_METHOD_CHEQUE => PaymentMethod.cheque,
    wire.PaymentMethod.PAYMENT_METHOD_PAYER_SETTLEMENT =>
      PaymentMethod.payerSettlement,
    wire.PaymentMethod.PAYMENT_METHOD_UNSPECIFIED => PaymentMethod.unspecified,
    _ => PaymentMethod.unrecognised,
  };
}

/// Wire method for a model one, for taking a payment.
///
/// Returns null for anything that is not a real method, which
/// `validatePayment` has already refused — the second reading is here because
/// this is where it would otherwise reach the wire.
wire.PaymentMethod? wireMethodOf(PaymentMethod method) => switch (method) {
      PaymentMethod.cash => wire.PaymentMethod.PAYMENT_METHOD_CASH,
      PaymentMethod.card => wire.PaymentMethod.PAYMENT_METHOD_CARD,
      PaymentMethod.bankTransfer =>
        wire.PaymentMethod.PAYMENT_METHOD_BANK_TRANSFER,
      PaymentMethod.upi => wire.PaymentMethod.PAYMENT_METHOD_UPI,
      PaymentMethod.cheque => wire.PaymentMethod.PAYMENT_METHOD_CHEQUE,
      PaymentMethod.payerSettlement =>
        wire.PaymentMethod.PAYMENT_METHOD_PAYER_SETTLEMENT,
      PaymentMethod.unspecified || PaymentMethod.unrecognised => null,
    };

InvoiceStatus invoiceStatusOf(wire.Invoice invoice) {
  if (sentUnknownValueFor(invoice, invoiceStatusField)) {
    // Not "draft". A status this build cannot read must never make an invoice
    // editable — the patient may be holding a copy of it.
    return InvoiceStatus.unrecognised;
  }
  return switch (invoice.status) {
    wire.InvoiceStatus.INVOICE_STATUS_DRAFT => InvoiceStatus.draft,
    wire.InvoiceStatus.INVOICE_STATUS_ISSUED => InvoiceStatus.issued,
    wire.InvoiceStatus.INVOICE_STATUS_SUPERSEDED => InvoiceStatus.superseded,
    wire.InvoiceStatus.INVOICE_STATUS_CANCELLED => InvoiceStatus.cancelled,
    wire.InvoiceStatus.INVOICE_STATUS_UNSPECIFIED => InvoiceStatus.unspecified,
    _ => InvoiceStatus.unrecognised,
  };
}

ChargeStatus chargeStatusOf(wire.Charge charge) {
  if (sentUnknownValueFor(charge, chargeStatusField)) {
    // Not "posted". Counting an unreadable charge as unbilled would add it to
    // a total somebody bills from.
    return ChargeStatus.unrecognised;
  }
  return switch (charge.status) {
    wire.ChargeStatus.CHARGE_STATUS_POSTED => ChargeStatus.posted,
    wire.ChargeStatus.CHARGE_STATUS_INVOICED => ChargeStatus.invoiced,
    wire.ChargeStatus.CHARGE_STATUS_VOIDED => ChargeStatus.voided,
    wire.ChargeStatus.CHARGE_STATUS_HELD => ChargeStatus.held,
    wire.ChargeStatus.CHARGE_STATUS_UNSPECIFIED => ChargeStatus.unspecified,
    _ => ChargeStatus.unrecognised,
  };
}

PresentedEntry entryOf(wire.LedgerEntry entry, {String currency = ''}) =>
    presentEntry(
      entryId: entry.entryId,
      kind: entryKindOf(entry),
      amount: moneyOf(entry.amount, fallbackCurrency: currency),
      occurredAt: entry.occurredAt.toDateTime().toUtc(),
      receiptNumber: entry.receiptNumber,
      method: methodOf(entry),
      reason: entry.reason,
      recordedBy: entry.recordedBy,
    );

PresentedInvoice invoiceOf(wire.Invoice invoice, {String currency = ''}) =>
    presentInvoice(
      invoiceId: invoice.invoiceId,
      number: invoice.number,
      status: invoiceStatusOf(invoice),
      total: moneyOf(invoice.total, fallbackCurrency: currency),
      // hasIssuedAt rather than a zero check: a draft has no issue date, and
      // the epoch shown as one reads as an invoice issued in 1970.
      issuedAt:
          invoice.hasIssuedAt() ? invoice.issuedAt.toDateTime().toUtc() : null,
      supersededBy: invoice.supersededBy,
      correctsInvoiceId: invoice.correctsInvoiceId,
      lineCount: invoice.lines.length,
    );

PresentedCharge chargeOf(wire.Charge charge, {String currency = ''}) =>
    presentCharge(
      chargeId: charge.chargeId,
      display: charge.description.isNotEmpty
          ? charge.description
          : charge.serviceCode,
      status: chargeStatusOf(charge),
      total: moneyOf(charge.total, fallbackCurrency: currency),
      occurredAt: charge.hasOccurredAt()
          ? charge.occurredAt.toDateTime().toUtc()
          : null,
    );

CloseException closeExceptionOf(wire.CloseException exception,
        {String currency = ''}) =>
    CloseException(
      check: exception.check_1,
      detail: exception.detail,
      amount: exception.hasAmount()
          ? moneyOf(exception.amount, fallbackCurrency: currency)
          : null,
      references: List.of(exception.references),
    );
