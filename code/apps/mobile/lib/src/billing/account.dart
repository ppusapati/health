/// The patient account as the cashier's desk reads it
/// (UX-W1-06, SRS-BIL-006, SRS-BIL-008, SRS-BIL-010, SRS-BIL-012, SRS-BIL-013).
///
/// Two rules carry this screen.
///
/// The balance derives from the ledger. SRS-BIL-012 says so, and the reason is
/// that a balance column kept in step by every writer drifts the first time one
/// of them fails between its two writes — with nothing to reconcile against,
/// because the ledger was never the truth. So the screen recomputes the balance
/// from the entries it was given and says so when that disagrees with the
/// server's figure, rather than displaying whichever arrived last.
///
/// A finalised invoice is never edited. There is no edit control anywhere near
/// one (SRS-BIL-010). The patient is holding a copy, and a system that can
/// quietly change what a document said is a system whose documents prove
/// nothing. A correction is a credit or debit note referencing the original,
/// which is what every finance department already does and every auditor
/// expects to find.
library;

import 'package:meta/meta.dart';

import 'money.dart';

/// Mirrors billing.v1.EntryKind.
enum EntryKind {
  invoice,
  payment,
  refund,
  deposit,
  depositApplied,
  writeOff,
  adjustment,
  unspecified,
  unrecognised,
}

/// Mirrors billing.v1.InvoiceStatus.
enum InvoiceStatus {
  draft,
  issued,
  superseded,
  cancelled,
  unspecified,
  unrecognised,
}

/// Mirrors billing.v1.ChargeStatus.
enum ChargeStatus { posted, invoiced, voided, held, unspecified, unrecognised }

/// Mirrors billing.v1.PaymentMethod.
enum PaymentMethod {
  cash,
  card,
  upi,
  bankTransfer,
  cheque,
  payerSettlement,
  unspecified,
  unrecognised,
}

String describeEntryKind(EntryKind kind) => switch (kind) {
      EntryKind.invoice => 'Invoice',
      EntryKind.payment => 'Payment',
      EntryKind.refund => 'Refund',
      EntryKind.deposit => 'Deposit',
      EntryKind.depositApplied => 'Deposit applied',
      EntryKind.writeOff => 'Written off',
      EntryKind.adjustment => 'Adjustment',
      EntryKind.unspecified => 'Entry',
      EntryKind.unrecognised => 'Entry not recognised by this app',
    };

String describeMethod(PaymentMethod method) => switch (method) {
      PaymentMethod.cash => 'Cash',
      PaymentMethod.card => 'Card',
      PaymentMethod.bankTransfer => 'Bank transfer',
      PaymentMethod.upi => 'UPI',
      PaymentMethod.cheque => 'Cheque',
      // Not "insurance": the money came from a payer settling a claim, which
      // is a different event from a patient paying with an insurance card.
      PaymentMethod.payerSettlement => 'Payer settlement',
      PaymentMethod.unspecified => 'Not recorded',
      PaymentMethod.unrecognised => 'Method not recognised by this app',
    };

String describeInvoiceStatus(InvoiceStatus status) => switch (status) {
      InvoiceStatus.draft => 'Draft',
      InvoiceStatus.issued => 'Issued',
      InvoiceStatus.superseded => 'Superseded',
      InvoiceStatus.cancelled => 'Cancelled',
      InvoiceStatus.unspecified => 'Unknown',
      InvoiceStatus.unrecognised => 'Status not recognised by this app',
    };

String describeChargeStatus(ChargeStatus status) => switch (status) {
      ChargeStatus.posted => 'Posted',
      ChargeStatus.invoiced => 'Invoiced',
      ChargeStatus.voided => 'Voided',
      ChargeStatus.held => 'Held',
      ChargeStatus.unspecified => 'Unknown',
      ChargeStatus.unrecognised => 'Status not recognised by this app',
    };

/// One ledger entry as the statement shows it.
@immutable
class PresentedEntry {
  const PresentedEntry({
    required this.entryId,
    required this.kind,
    required this.amount,
    required this.occurredAt,
    required this.increasesDebt,
    this.receiptNumber = '',
    this.method = PaymentMethod.unspecified,
    this.reason = '',
    this.recordedBy = '',
  });

  final String entryId;
  final EntryKind kind;
  final Money amount;
  final DateTime occurredAt;

  /// Taken from the sign, not from the kind. The ledger is signed — positive
  /// increases what the patient owes — and a screen that decided direction
  /// from the kind would disagree with the ledger the first time an adjustment
  /// went the other way.
  final bool increasesDebt;

  final String receiptNumber;
  final PaymentMethod method;
  final String reason;
  final String recordedBy;

  String get kindLabel => describeEntryKind(kind);
  String get methodLabel => describeMethod(method);
}

/// Presents one ledger entry.
PresentedEntry presentEntry({
  required String entryId,
  required EntryKind kind,
  required Money amount,
  required DateTime occurredAt,
  String receiptNumber = '',
  PaymentMethod method = PaymentMethod.unspecified,
  String reason = '',
  String recordedBy = '',
}) =>
    PresentedEntry(
      entryId: entryId,
      kind: kind,
      amount: amount,
      occurredAt: occurredAt,
      increasesDebt: amount.minor > 0,
      receiptNumber: receiptNumber,
      method: method,
      reason: reason,
      recordedBy: recordedBy,
    );

/// What the statement header shows.
@immutable
class Statement {
  const Statement({
    required this.entries,
    required this.derivedBalance,
    required this.reportedBalance,
    required this.reconciles,
    required this.deposits,
  });

  final List<PresentedEntry> entries;

  /// The balance this screen computed from the entries above.
  final Money derivedBalance;

  /// The balance the server reported.
  final Money reportedBalance;

  /// True when the two agree.
  ///
  /// A disagreement is surfaced rather than resolved. It means either the entry
  /// list is incomplete — a page boundary, most likely — or something is
  /// genuinely wrong; both are things a cashier should see before taking money
  /// against the figure.
  final bool reconciles;

  final Money deposits;
}

/// Builds the statement, deriving the balance rather than trusting one column.
///
/// SRS-BIL-012's acceptance is "balance derives from ledger and reconciles",
/// and the second half is the interesting one: the derivation is only worth
/// anything if a disagreement is visible.
Statement buildStatement({
  required List<PresentedEntry> entries,
  required Money reportedBalance,
  required Money deposits,
  required String currency,
}) {
  final derived = sumMoney(
    [for (final entry in entries) entry.amount],
    currency,
  );
  return Statement(
    entries: [...entries]..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)),
    derivedBalance: derived,
    reportedBalance: reportedBalance,
    reconciles: derived.minor == reportedBalance.minor,
    deposits: deposits,
  );
}

/// An invoice as the list shows it.
@immutable
class PresentedInvoice {
  const PresentedInvoice({
    required this.invoiceId,
    required this.number,
    required this.status,
    required this.total,
    required this.editable,
    required this.correctable,
    this.issuedAt,
    this.supersededBy = '',
    this.correctsInvoiceId = '',
    this.lineCount = 0,
  });

  final String invoiceId;
  final String number;
  final InvoiceStatus status;
  final Money total;
  final DateTime? issuedAt;
  final String supersededBy;
  final String correctsInvoiceId;

  /// Only ever true for a draft (SRS-BIL-010).
  final bool editable;

  /// True when a credit or debit note may reference this one.
  final bool correctable;

  final int lineCount;

  String get statusLabel => describeInvoiceStatus(status);
}

/// Presents one invoice.
PresentedInvoice presentInvoice({
  required String invoiceId,
  required String number,
  required InvoiceStatus status,
  required Money total,
  DateTime? issuedAt,
  String supersededBy = '',
  String correctsInvoiceId = '',
  int lineCount = 0,
}) =>
    PresentedInvoice(
      invoiceId: invoiceId,
      number: number,
      status: status,
      total: total,
      issuedAt: issuedAt,
      supersededBy: supersededBy,
      correctsInvoiceId: correctsInvoiceId,
      // Draft and only draft. An issued invoice is in the patient's hand.
      editable: status == InvoiceStatus.draft,
      // A superseded or cancelled document is not corrected again; the
      // correction goes against whatever replaced it.
      correctable: status == InvoiceStatus.issued,
      lineCount: lineCount,
    );

/// A charge as the worklist shows it.
@immutable
class PresentedCharge {
  const PresentedCharge({
    required this.chargeId,
    required this.display,
    required this.status,
    required this.total,
    required this.unbilled,
    this.occurredAt,
  });

  final String chargeId;
  final String display;
  final ChargeStatus status;
  final Money total;

  /// True when this charge will appear on the next invoice.
  ///
  /// Not "is not yet on an invoice", which is a wider set and the mistake this
  /// field invites: a held charge is also not on an invoice, and it is held
  /// precisely so that it does not reach one until a coding query or an
  /// authorisation is resolved. Counting it inflates a figure somebody bills
  /// from and quotes to a patient.
  final bool unbilled;

  /// True when the charge is waiting on a coding query or an authorisation.
  ///
  /// Its own flag so the desk can show it — a held charge is actionable, and
  /// dropping it off the screen entirely hides work somebody has to chase.
  bool get held => status == ChargeStatus.held;

  final DateTime? occurredAt;

  String get statusLabel => describeChargeStatus(status);
}

/// Presents one charge.
PresentedCharge presentCharge({
  required String chargeId,
  required String display,
  required ChargeStatus status,
  required Money total,
  DateTime? occurredAt,
}) =>
    PresentedCharge(
      chargeId: chargeId,
      display: display,
      status: status,
      total: total,
      // Posted only. Invoiced is already on a document, voided is not a charge
      // any more, and held is waiting on a query — see the field's own comment
      // for why that last one is the trap.
      unbilled: status == ChargeStatus.posted,
      occurredAt: occurredAt,
    );

/// Sums the charges not yet on an invoice.
Money unbilledTotal(List<PresentedCharge> charges, String currency) => sumMoney(
      [for (final c in charges) if (c.unbilled) c.total],
      currency,
    );

/// One reason an account cannot be closed.
@immutable
class CloseException {
  const CloseException({
    required this.check,
    required this.detail,
    this.amount,
    this.references = const [],
  });

  final String check;
  final String detail;
  final Money? amount;
  final List<String> references;
}

/// Whether the account may be closed, and why not.
@immutable
class CloseReadiness {
  const CloseReadiness({
    required this.ready,
    required this.exceptions,
    required this.message,
  });

  final bool ready;
  final List<CloseException> exceptions;
  final String message;
}

/// Reports whether the account may be closed (SRS-BIL-013).
///
/// The exceptions come from the server and are listed, not summarised. "Cannot
/// close" with no list is a dead end for whoever is at the desk; the list is
/// what turns it into a task.
CloseReadiness closeReadiness(List<CloseException> exceptions) {
  if (exceptions.isEmpty) {
    return const CloseReadiness(
      ready: true,
      exceptions: [],
      message: 'Everything is settled. The account can be closed.',
    );
  }
  return CloseReadiness(
    ready: false,
    exceptions: exceptions,
    message: exceptions.length == 1
        ? 'One thing is outstanding before this account can be closed.'
        : '${exceptions.length} things are outstanding before this account '
            'can be closed.',
  );
}

/// Why a payment cannot be taken.
@immutable
class PaymentValidity {
  const PaymentValidity({required this.ready, required this.problems});
  final bool ready;
  final List<String> problems;
}

/// Checks a payment before taking it.
///
/// The idempotency key is required rather than generated at submit time. A key
/// minted on the click changes on every retry, so a double submission produces
/// two receipts — the whole point of the key is that it is stable across the
/// retry (SRS-BIL-008).
PaymentValidity validatePayment({
  required Money? amount,
  required PaymentMethod method,
  required String idempotencyKey,
  required String accountId,
}) {
  final problems = <String>[
    if (accountId.trim().isEmpty) 'No account is open.',
    // A null amount means parseMoney refused what was typed. Refusing is the
    // only safe answer: a lenient parser turns a typing slip into zero.
    if (amount == null)
      'Enter an amount.'
    else if (amount.minor <= 0)
      // A refund is its own operation against the original payment
      // (SRS-BIL-009), not a negative payment.
      'A payment must be more than zero. Use a refund to return money.',
    if (method == PaymentMethod.unspecified ||
        method == PaymentMethod.unrecognised)
      'Choose how the money was taken.',
    if (idempotencyKey.trim().isEmpty)
      'This payment has no idempotency key.',
  ];

  return PaymentValidity(ready: problems.isEmpty, problems: problems);
}

/// A one-line summary of what the desk owes or holds.
String describeAccountHeader(
  Statement statement, {
  MoneyGrouping grouping = MoneyGrouping.thousands,
}) {
  final parts = <String>[
    if (!isZero(statement.deposits))
      '${formatMoney(statement.deposits, grouping: grouping)} on deposit',
  ];

  // When the two disagree, the derived figure is shown, because it is the one
  // this screen can account for line by line.
  final balance =
      statement.reconciles ? statement.reportedBalance : statement.derivedBalance;

  parts.add(
    balance.minor > 0
        ? '${formatMoney(balance, grouping: grouping)} outstanding'
        : balance.minor < 0
            ? '${formatMoney(Money(minor: -balance.minor, currency: balance.currency), grouping: grouping)} in credit'
            : 'settled',
  );
  return parts.join(', ');
}

/// Adds a single entry to a running balance, for an optimistic update.
Money applyEntry(Money balance, PresentedEntry entry) =>
    addMoney(balance, entry.amount);
