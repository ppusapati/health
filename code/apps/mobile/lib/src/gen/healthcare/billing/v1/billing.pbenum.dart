// This is a generated file - do not edit.
//
// Generated from healthcare/billing/v1/billing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Where a charge came from (SRS-BIL-003).
class ChargeOrigin extends $pb.ProtobufEnum {
  static const ChargeOrigin CHARGE_ORIGIN_UNSPECIFIED =
      ChargeOrigin._(0, _omitEnumNames ? '' : 'CHARGE_ORIGIN_UNSPECIFIED');
  static const ChargeOrigin CHARGE_ORIGIN_CLINICAL_EVENT =
      ChargeOrigin._(1, _omitEnumNames ? '' : 'CHARGE_ORIGIN_CLINICAL_EVENT');

  /// A biller keying one in. Allowed, and audited harder: a manual charge is the
  /// path round every automated control.
  static const ChargeOrigin CHARGE_ORIGIN_MANUAL =
      ChargeOrigin._(2, _omitEnumNames ? '' : 'CHARGE_ORIGIN_MANUAL');
  static const ChargeOrigin CHARGE_ORIGIN_RECURRING =
      ChargeOrigin._(3, _omitEnumNames ? '' : 'CHARGE_ORIGIN_RECURRING');

  static const $core.List<ChargeOrigin> values = <ChargeOrigin>[
    CHARGE_ORIGIN_UNSPECIFIED,
    CHARGE_ORIGIN_CLINICAL_EVENT,
    CHARGE_ORIGIN_MANUAL,
    CHARGE_ORIGIN_RECURRING,
  ];

  static final $core.List<ChargeOrigin?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ChargeOrigin? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChargeOrigin._(super.value, super.name);
}

class ChargeStatus extends $pb.ProtobufEnum {
  static const ChargeStatus CHARGE_STATUS_UNSPECIFIED =
      ChargeStatus._(0, _omitEnumNames ? '' : 'CHARGE_STATUS_UNSPECIFIED');
  static const ChargeStatus CHARGE_STATUS_POSTED =
      ChargeStatus._(1, _omitEnumNames ? '' : 'CHARGE_STATUS_POSTED');
  static const ChargeStatus CHARGE_STATUS_INVOICED =
      ChargeStatus._(2, _omitEnumNames ? '' : 'CHARGE_STATUS_INVOICED');

  /// Raised in error. The record stays: a charge that vanished would leave an
  /// invoice total nobody can rebuild.
  static const ChargeStatus CHARGE_STATUS_VOIDED =
      ChargeStatus._(3, _omitEnumNames ? '' : 'CHARGE_STATUS_VOIDED');

  /// Waiting on a coding query or an authorisation.
  static const ChargeStatus CHARGE_STATUS_HELD =
      ChargeStatus._(4, _omitEnumNames ? '' : 'CHARGE_STATUS_HELD');

  static const $core.List<ChargeStatus> values = <ChargeStatus>[
    CHARGE_STATUS_UNSPECIFIED,
    CHARGE_STATUS_POSTED,
    CHARGE_STATUS_INVOICED,
    CHARGE_STATUS_VOIDED,
    CHARGE_STATUS_HELD,
  ];

  static final $core.List<ChargeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ChargeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ChargeStatus._(super.value, super.name);
}

/// What a package did with a charge (SRS-BIL-004).
class CoverageOutcome extends $pb.ProtobufEnum {
  static const CoverageOutcome COVERAGE_OUTCOME_UNSPECIFIED = CoverageOutcome._(
      0, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_UNSPECIFIED');
  static const CoverageOutcome COVERAGE_OUTCOME_INCLUDED =
      CoverageOutcome._(1, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_INCLUDED');

  /// The inclusion's quantity was already used, so this one is billed — the
  /// excess rather than the whole line, which is what a cap means.
  static const CoverageOutcome COVERAGE_OUTCOME_OVER_CAP =
      CoverageOutcome._(2, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_OVER_CAP');
  static const CoverageOutcome COVERAGE_OUTCOME_EXCLUDED =
      CoverageOutcome._(3, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_EXCLUDED');
  static const CoverageOutcome COVERAGE_OUTCOME_CARVE_OUT =
      CoverageOutcome._(4, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_CARVE_OUT');

  /// The package says nothing about it, so the standard tariff applies.
  /// Recorded rather than left silent.
  static const CoverageOutcome COVERAGE_OUTCOME_OUTSIDE_PACKAGE =
      CoverageOutcome._(
          5, _omitEnumNames ? '' : 'COVERAGE_OUTCOME_OUTSIDE_PACKAGE');

  static const $core.List<CoverageOutcome> values = <CoverageOutcome>[
    COVERAGE_OUTCOME_UNSPECIFIED,
    COVERAGE_OUTCOME_INCLUDED,
    COVERAGE_OUTCOME_OVER_CAP,
    COVERAGE_OUTCOME_EXCLUDED,
    COVERAGE_OUTCOME_CARVE_OUT,
    COVERAGE_OUTCOME_OUTSIDE_PACKAGE,
  ];

  static final $core.List<CoverageOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CoverageOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CoverageOutcome._(super.value, super.name);
}

class DocumentKind extends $pb.ProtobufEnum {
  static const DocumentKind DOCUMENT_KIND_UNSPECIFIED =
      DocumentKind._(0, _omitEnumNames ? '' : 'DOCUMENT_KIND_UNSPECIFIED');

  /// A quote. Never a demand for payment, and never posts to the ledger.
  static const DocumentKind DOCUMENT_KIND_ESTIMATE =
      DocumentKind._(1, _omitEnumNames ? '' : 'DOCUMENT_KIND_ESTIMATE');

  /// A running bill on an open account, supersedable.
  static const DocumentKind DOCUMENT_KIND_INTERIM =
      DocumentKind._(2, _omitEnumNames ? '' : 'DOCUMENT_KIND_INTERIM');
  static const DocumentKind DOCUMENT_KIND_FINAL =
      DocumentKind._(3, _omitEnumNames ? '' : 'DOCUMENT_KIND_FINAL');

  /// Reduces what is owed. The correction workflow for a finalised document.
  static const DocumentKind DOCUMENT_KIND_CREDIT_NOTE =
      DocumentKind._(4, _omitEnumNames ? '' : 'DOCUMENT_KIND_CREDIT_NOTE');
  static const DocumentKind DOCUMENT_KIND_DEBIT_NOTE =
      DocumentKind._(5, _omitEnumNames ? '' : 'DOCUMENT_KIND_DEBIT_NOTE');

  static const $core.List<DocumentKind> values = <DocumentKind>[
    DOCUMENT_KIND_UNSPECIFIED,
    DOCUMENT_KIND_ESTIMATE,
    DOCUMENT_KIND_INTERIM,
    DOCUMENT_KIND_FINAL,
    DOCUMENT_KIND_CREDIT_NOTE,
    DOCUMENT_KIND_DEBIT_NOTE,
  ];

  static final $core.List<DocumentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static DocumentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DocumentKind._(super.value, super.name);
}

class InvoiceStatus extends $pb.ProtobufEnum {
  static const InvoiceStatus INVOICE_STATUS_UNSPECIFIED =
      InvoiceStatus._(0, _omitEnumNames ? '' : 'INVOICE_STATUS_UNSPECIFIED');
  static const InvoiceStatus INVOICE_STATUS_DRAFT =
      InvoiceStatus._(1, _omitEnumNames ? '' : 'INVOICE_STATUS_DRAFT');

  /// Final and out. Nothing about it changes again.
  static const InvoiceStatus INVOICE_STATUS_ISSUED =
      InvoiceStatus._(2, _omitEnumNames ? '' : 'INVOICE_STATUS_ISSUED');
  static const InvoiceStatus INVOICE_STATUS_SUPERSEDED =
      InvoiceStatus._(3, _omitEnumNames ? '' : 'INVOICE_STATUS_SUPERSEDED');
  static const InvoiceStatus INVOICE_STATUS_CANCELLED =
      InvoiceStatus._(4, _omitEnumNames ? '' : 'INVOICE_STATUS_CANCELLED');

  static const $core.List<InvoiceStatus> values = <InvoiceStatus>[
    INVOICE_STATUS_UNSPECIFIED,
    INVOICE_STATUS_DRAFT,
    INVOICE_STATUS_ISSUED,
    INVOICE_STATUS_SUPERSEDED,
    INVOICE_STATUS_CANCELLED,
  ];

  static final $core.List<InvoiceStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static InvoiceStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InvoiceStatus._(super.value, super.name);
}

/// Who owes a share (SRS-BIL-014).
class LiabilityParty extends $pb.ProtobufEnum {
  static const LiabilityParty LIABILITY_PARTY_UNSPECIFIED =
      LiabilityParty._(0, _omitEnumNames ? '' : 'LIABILITY_PARTY_UNSPECIFIED');
  static const LiabilityParty LIABILITY_PARTY_PATIENT =
      LiabilityParty._(1, _omitEnumNames ? '' : 'LIABILITY_PARTY_PATIENT');
  static const LiabilityParty LIABILITY_PARTY_PAYER =
      LiabilityParty._(2, _omitEnumNames ? '' : 'LIABILITY_PARTY_PAYER');
  static const LiabilityParty LIABILITY_PARTY_CORPORATE =
      LiabilityParty._(3, _omitEnumNames ? '' : 'LIABILITY_PARTY_CORPORATE');
  static const LiabilityParty LIABILITY_PARTY_SCHEME =
      LiabilityParty._(4, _omitEnumNames ? '' : 'LIABILITY_PARTY_SCHEME');

  static const $core.List<LiabilityParty> values = <LiabilityParty>[
    LIABILITY_PARTY_UNSPECIFIED,
    LIABILITY_PARTY_PATIENT,
    LIABILITY_PARTY_PAYER,
    LIABILITY_PARTY_CORPORATE,
    LIABILITY_PARTY_SCHEME,
  ];

  static final $core.List<LiabilityParty?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static LiabilityParty? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const LiabilityParty._(super.value, super.name);
}

/// What a ledger entry records (SRS-BIL-012).
class EntryKind extends $pb.ProtobufEnum {
  static const EntryKind ENTRY_KIND_UNSPECIFIED =
      EntryKind._(0, _omitEnumNames ? '' : 'ENTRY_KIND_UNSPECIFIED');
  static const EntryKind ENTRY_KIND_INVOICE =
      EntryKind._(1, _omitEnumNames ? '' : 'ENTRY_KIND_INVOICE');
  static const EntryKind ENTRY_KIND_PAYMENT =
      EntryKind._(2, _omitEnumNames ? '' : 'ENTRY_KIND_PAYMENT');

  /// A separate entry rather than an edit to the payment: "we never took this"
  /// and "we took it and gave it back" are different statements.
  static const EntryKind ENTRY_KIND_REFUND =
      EntryKind._(3, _omitEnumNames ? '' : 'ENTRY_KIND_REFUND');
  static const EntryKind ENTRY_KIND_DEPOSIT =
      EntryKind._(4, _omitEnumNames ? '' : 'ENTRY_KIND_DEPOSIT');
  static const EntryKind ENTRY_KIND_DEPOSIT_APPLIED =
      EntryKind._(5, _omitEnumNames ? '' : 'ENTRY_KIND_DEPOSIT_APPLIED');
  static const EntryKind ENTRY_KIND_WRITE_OFF =
      EntryKind._(6, _omitEnumNames ? '' : 'ENTRY_KIND_WRITE_OFF');
  static const EntryKind ENTRY_KIND_ADJUSTMENT =
      EntryKind._(7, _omitEnumNames ? '' : 'ENTRY_KIND_ADJUSTMENT');

  static const $core.List<EntryKind> values = <EntryKind>[
    ENTRY_KIND_UNSPECIFIED,
    ENTRY_KIND_INVOICE,
    ENTRY_KIND_PAYMENT,
    ENTRY_KIND_REFUND,
    ENTRY_KIND_DEPOSIT,
    ENTRY_KIND_DEPOSIT_APPLIED,
    ENTRY_KIND_WRITE_OFF,
    ENTRY_KIND_ADJUSTMENT,
  ];

  static final $core.List<EntryKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static EntryKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntryKind._(super.value, super.name);
}

class PaymentMethod extends $pb.ProtobufEnum {
  static const PaymentMethod PAYMENT_METHOD_UNSPECIFIED =
      PaymentMethod._(0, _omitEnumNames ? '' : 'PAYMENT_METHOD_UNSPECIFIED');
  static const PaymentMethod PAYMENT_METHOD_CASH =
      PaymentMethod._(1, _omitEnumNames ? '' : 'PAYMENT_METHOD_CASH');
  static const PaymentMethod PAYMENT_METHOD_CARD =
      PaymentMethod._(2, _omitEnumNames ? '' : 'PAYMENT_METHOD_CARD');
  static const PaymentMethod PAYMENT_METHOD_UPI =
      PaymentMethod._(3, _omitEnumNames ? '' : 'PAYMENT_METHOD_UPI');
  static const PaymentMethod PAYMENT_METHOD_BANK_TRANSFER =
      PaymentMethod._(4, _omitEnumNames ? '' : 'PAYMENT_METHOD_BANK_TRANSFER');
  static const PaymentMethod PAYMENT_METHOD_CHEQUE =
      PaymentMethod._(5, _omitEnumNames ? '' : 'PAYMENT_METHOD_CHEQUE');

  /// A settlement from an insurer rather than from the patient.
  static const PaymentMethod PAYMENT_METHOD_PAYER_SETTLEMENT = PaymentMethod._(
      6, _omitEnumNames ? '' : 'PAYMENT_METHOD_PAYER_SETTLEMENT');

  static const $core.List<PaymentMethod> values = <PaymentMethod>[
    PAYMENT_METHOD_UNSPECIFIED,
    PAYMENT_METHOD_CASH,
    PAYMENT_METHOD_CARD,
    PAYMENT_METHOD_UPI,
    PAYMENT_METHOD_BANK_TRANSFER,
    PAYMENT_METHOD_CHEQUE,
    PAYMENT_METHOD_PAYER_SETTLEMENT,
  ];

  static final $core.List<PaymentMethod?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static PaymentMethod? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PaymentMethod._(super.value, super.name);
}

class AccountStatus extends $pb.ProtobufEnum {
  static const AccountStatus ACCOUNT_STATUS_UNSPECIFIED =
      AccountStatus._(0, _omitEnumNames ? '' : 'ACCOUNT_STATUS_UNSPECIFIED');
  static const AccountStatus ACCOUNT_STATUS_OPEN =
      AccountStatus._(1, _omitEnumNames ? '' : 'ACCOUNT_STATUS_OPEN');
  static const AccountStatus ACCOUNT_STATUS_CLOSED =
      AccountStatus._(2, _omitEnumNames ? '' : 'ACCOUNT_STATUS_CLOSED');

  static const $core.List<AccountStatus> values = <AccountStatus>[
    ACCOUNT_STATUS_UNSPECIFIED,
    ACCOUNT_STATUS_OPEN,
    ACCOUNT_STATUS_CLOSED,
  ];

  static final $core.List<AccountStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AccountStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AccountStatus._(super.value, super.name);
}

class ShiftStatus extends $pb.ProtobufEnum {
  static const ShiftStatus SHIFT_STATUS_UNSPECIFIED =
      ShiftStatus._(0, _omitEnumNames ? '' : 'SHIFT_STATUS_UNSPECIFIED');
  static const ShiftStatus SHIFT_STATUS_OPEN =
      ShiftStatus._(1, _omitEnumNames ? '' : 'SHIFT_STATUS_OPEN');
  static const ShiftStatus SHIFT_STATUS_RECONCILED =
      ShiftStatus._(2, _omitEnumNames ? '' : 'SHIFT_STATUS_RECONCILED');
  static const ShiftStatus SHIFT_STATUS_PENDING_APPROVAL =
      ShiftStatus._(3, _omitEnumNames ? '' : 'SHIFT_STATUS_PENDING_APPROVAL');

  static const $core.List<ShiftStatus> values = <ShiftStatus>[
    SHIFT_STATUS_UNSPECIFIED,
    SHIFT_STATUS_OPEN,
    SHIFT_STATUS_RECONCILED,
    SHIFT_STATUS_PENDING_APPROVAL,
  ];

  static final $core.List<ShiftStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ShiftStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShiftStatus._(super.value, super.name);
}

/// Why something is on the revenue-integrity worklist (SRS-BIL-011).
class ExceptionKind extends $pb.ProtobufEnum {
  static const ExceptionKind EXCEPTION_KIND_UNSPECIFIED =
      ExceptionKind._(0, _omitEnumNames ? '' : 'EXCEPTION_KIND_UNSPECIFIED');

  /// A completed service with no charge. The commonest revenue leak in any
  /// hospital, and almost never theft — a procedure nobody coded.
  static const ExceptionKind EXCEPTION_KIND_UNBILLED_SERVICE = ExceptionKind._(
      1, _omitEnumNames ? '' : 'EXCEPTION_KIND_UNBILLED_SERVICE');
  static const ExceptionKind EXCEPTION_KIND_UNINVOICED_CHARGE = ExceptionKind._(
      2, _omitEnumNames ? '' : 'EXCEPTION_KIND_UNINVOICED_CHARGE');
  static const ExceptionKind EXCEPTION_KIND_HELD_CHARGE =
      ExceptionKind._(3, _omitEnumNames ? '' : 'EXCEPTION_KIND_HELD_CHARGE');
  static const ExceptionKind EXCEPTION_KIND_NO_TARIFF =
      ExceptionKind._(4, _omitEnumNames ? '' : 'EXCEPTION_KIND_NO_TARIFF');
  static const ExceptionKind EXCEPTION_KIND_UNPRICED_PACKAGE = ExceptionKind._(
      5, _omitEnumNames ? '' : 'EXCEPTION_KIND_UNPRICED_PACKAGE');

  static const $core.List<ExceptionKind> values = <ExceptionKind>[
    EXCEPTION_KIND_UNSPECIFIED,
    EXCEPTION_KIND_UNBILLED_SERVICE,
    EXCEPTION_KIND_UNINVOICED_CHARGE,
    EXCEPTION_KIND_HELD_CHARGE,
    EXCEPTION_KIND_NO_TARIFF,
    EXCEPTION_KIND_UNPRICED_PACKAGE,
  ];

  static final $core.List<ExceptionKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ExceptionKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExceptionKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
