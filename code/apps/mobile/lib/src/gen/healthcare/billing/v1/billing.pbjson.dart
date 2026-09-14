// This is a generated file - do not edit.
//
// Generated from healthcare/billing/v1/billing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'package:protobuf/well_known_types/google/protobuf/timestamp.pbjson.dart'
    as $0;

@$core.Deprecated('Use chargeOriginDescriptor instead')
const ChargeOrigin$json = {
  '1': 'ChargeOrigin',
  '2': [
    {'1': 'CHARGE_ORIGIN_UNSPECIFIED', '2': 0},
    {'1': 'CHARGE_ORIGIN_CLINICAL_EVENT', '2': 1},
    {'1': 'CHARGE_ORIGIN_MANUAL', '2': 2},
    {'1': 'CHARGE_ORIGIN_RECURRING', '2': 3},
  ],
};

/// Descriptor for `ChargeOrigin`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chargeOriginDescriptor = $convert.base64Decode(
    'CgxDaGFyZ2VPcmlnaW4SHQoZQ0hBUkdFX09SSUdJTl9VTlNQRUNJRklFRBAAEiAKHENIQVJHRV'
    '9PUklHSU5fQ0xJTklDQUxfRVZFTlQQARIYChRDSEFSR0VfT1JJR0lOX01BTlVBTBACEhsKF0NI'
    'QVJHRV9PUklHSU5fUkVDVVJSSU5HEAM=');

@$core.Deprecated('Use chargeStatusDescriptor instead')
const ChargeStatus$json = {
  '1': 'ChargeStatus',
  '2': [
    {'1': 'CHARGE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CHARGE_STATUS_POSTED', '2': 1},
    {'1': 'CHARGE_STATUS_INVOICED', '2': 2},
    {'1': 'CHARGE_STATUS_VOIDED', '2': 3},
    {'1': 'CHARGE_STATUS_HELD', '2': 4},
  ],
};

/// Descriptor for `ChargeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List chargeStatusDescriptor = $convert.base64Decode(
    'CgxDaGFyZ2VTdGF0dXMSHQoZQ0hBUkdFX1NUQVRVU19VTlNQRUNJRklFRBAAEhgKFENIQVJHRV'
    '9TVEFUVVNfUE9TVEVEEAESGgoWQ0hBUkdFX1NUQVRVU19JTlZPSUNFRBACEhgKFENIQVJHRV9T'
    'VEFUVVNfVk9JREVEEAMSFgoSQ0hBUkdFX1NUQVRVU19IRUxEEAQ=');

@$core.Deprecated('Use coverageOutcomeDescriptor instead')
const CoverageOutcome$json = {
  '1': 'CoverageOutcome',
  '2': [
    {'1': 'COVERAGE_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'COVERAGE_OUTCOME_INCLUDED', '2': 1},
    {'1': 'COVERAGE_OUTCOME_OVER_CAP', '2': 2},
    {'1': 'COVERAGE_OUTCOME_EXCLUDED', '2': 3},
    {'1': 'COVERAGE_OUTCOME_CARVE_OUT', '2': 4},
    {'1': 'COVERAGE_OUTCOME_OUTSIDE_PACKAGE', '2': 5},
  ],
};

/// Descriptor for `CoverageOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List coverageOutcomeDescriptor = $convert.base64Decode(
    'Cg9Db3ZlcmFnZU91dGNvbWUSIAocQ09WRVJBR0VfT1VUQ09NRV9VTlNQRUNJRklFRBAAEh0KGU'
    'NPVkVSQUdFX09VVENPTUVfSU5DTFVERUQQARIdChlDT1ZFUkFHRV9PVVRDT01FX09WRVJfQ0FQ'
    'EAISHQoZQ09WRVJBR0VfT1VUQ09NRV9FWENMVURFRBADEh4KGkNPVkVSQUdFX09VVENPTUVfQ0'
    'FSVkVfT1VUEAQSJAogQ09WRVJBR0VfT1VUQ09NRV9PVVRTSURFX1BBQ0tBR0UQBQ==');

@$core.Deprecated('Use documentKindDescriptor instead')
const DocumentKind$json = {
  '1': 'DocumentKind',
  '2': [
    {'1': 'DOCUMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_KIND_ESTIMATE', '2': 1},
    {'1': 'DOCUMENT_KIND_INTERIM', '2': 2},
    {'1': 'DOCUMENT_KIND_FINAL', '2': 3},
    {'1': 'DOCUMENT_KIND_CREDIT_NOTE', '2': 4},
    {'1': 'DOCUMENT_KIND_DEBIT_NOTE', '2': 5},
  ],
};

/// Descriptor for `DocumentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentKindDescriptor = $convert.base64Decode(
    'CgxEb2N1bWVudEtpbmQSHQoZRE9DVU1FTlRfS0lORF9VTlNQRUNJRklFRBAAEhoKFkRPQ1VNRU'
    '5UX0tJTkRfRVNUSU1BVEUQARIZChVET0NVTUVOVF9LSU5EX0lOVEVSSU0QAhIXChNET0NVTUVO'
    'VF9LSU5EX0ZJTkFMEAMSHQoZRE9DVU1FTlRfS0lORF9DUkVESVRfTk9URRAEEhwKGERPQ1VNRU'
    '5UX0tJTkRfREVCSVRfTk9URRAF');

@$core.Deprecated('Use invoiceStatusDescriptor instead')
const InvoiceStatus$json = {
  '1': 'InvoiceStatus',
  '2': [
    {'1': 'INVOICE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'INVOICE_STATUS_DRAFT', '2': 1},
    {'1': 'INVOICE_STATUS_ISSUED', '2': 2},
    {'1': 'INVOICE_STATUS_SUPERSEDED', '2': 3},
    {'1': 'INVOICE_STATUS_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `InvoiceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List invoiceStatusDescriptor = $convert.base64Decode(
    'Cg1JbnZvaWNlU3RhdHVzEh4KGklOVk9JQ0VfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUSU5WT0'
    'lDRV9TVEFUVVNfRFJBRlQQARIZChVJTlZPSUNFX1NUQVRVU19JU1NVRUQQAhIdChlJTlZPSUNF'
    'X1NUQVRVU19TVVBFUlNFREVEEAMSHAoYSU5WT0lDRV9TVEFUVVNfQ0FOQ0VMTEVEEAQ=');

@$core.Deprecated('Use liabilityPartyDescriptor instead')
const LiabilityParty$json = {
  '1': 'LiabilityParty',
  '2': [
    {'1': 'LIABILITY_PARTY_UNSPECIFIED', '2': 0},
    {'1': 'LIABILITY_PARTY_PATIENT', '2': 1},
    {'1': 'LIABILITY_PARTY_PAYER', '2': 2},
    {'1': 'LIABILITY_PARTY_CORPORATE', '2': 3},
    {'1': 'LIABILITY_PARTY_SCHEME', '2': 4},
  ],
};

/// Descriptor for `LiabilityParty`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List liabilityPartyDescriptor = $convert.base64Decode(
    'Cg5MaWFiaWxpdHlQYXJ0eRIfChtMSUFCSUxJVFlfUEFSVFlfVU5TUEVDSUZJRUQQABIbChdMSU'
    'FCSUxJVFlfUEFSVFlfUEFUSUVOVBABEhkKFUxJQUJJTElUWV9QQVJUWV9QQVlFUhACEh0KGUxJ'
    'QUJJTElUWV9QQVJUWV9DT1JQT1JBVEUQAxIaChZMSUFCSUxJVFlfUEFSVFlfU0NIRU1FEAQ=');

@$core.Deprecated('Use entryKindDescriptor instead')
const EntryKind$json = {
  '1': 'EntryKind',
  '2': [
    {'1': 'ENTRY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ENTRY_KIND_INVOICE', '2': 1},
    {'1': 'ENTRY_KIND_PAYMENT', '2': 2},
    {'1': 'ENTRY_KIND_REFUND', '2': 3},
    {'1': 'ENTRY_KIND_DEPOSIT', '2': 4},
    {'1': 'ENTRY_KIND_DEPOSIT_APPLIED', '2': 5},
    {'1': 'ENTRY_KIND_WRITE_OFF', '2': 6},
    {'1': 'ENTRY_KIND_ADJUSTMENT', '2': 7},
  ],
};

/// Descriptor for `EntryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entryKindDescriptor = $convert.base64Decode(
    'CglFbnRyeUtpbmQSGgoWRU5UUllfS0lORF9VTlNQRUNJRklFRBAAEhYKEkVOVFJZX0tJTkRfSU'
    '5WT0lDRRABEhYKEkVOVFJZX0tJTkRfUEFZTUVOVBACEhUKEUVOVFJZX0tJTkRfUkVGVU5EEAMS'
    'FgoSRU5UUllfS0lORF9ERVBPU0lUEAQSHgoaRU5UUllfS0lORF9ERVBPU0lUX0FQUExJRUQQBR'
    'IYChRFTlRSWV9LSU5EX1dSSVRFX09GRhAGEhkKFUVOVFJZX0tJTkRfQURKVVNUTUVOVBAH');

@$core.Deprecated('Use paymentMethodDescriptor instead')
const PaymentMethod$json = {
  '1': 'PaymentMethod',
  '2': [
    {'1': 'PAYMENT_METHOD_UNSPECIFIED', '2': 0},
    {'1': 'PAYMENT_METHOD_CASH', '2': 1},
    {'1': 'PAYMENT_METHOD_CARD', '2': 2},
    {'1': 'PAYMENT_METHOD_UPI', '2': 3},
    {'1': 'PAYMENT_METHOD_BANK_TRANSFER', '2': 4},
    {'1': 'PAYMENT_METHOD_CHEQUE', '2': 5},
    {'1': 'PAYMENT_METHOD_PAYER_SETTLEMENT', '2': 6},
  ],
};

/// Descriptor for `PaymentMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List paymentMethodDescriptor = $convert.base64Decode(
    'Cg1QYXltZW50TWV0aG9kEh4KGlBBWU1FTlRfTUVUSE9EX1VOU1BFQ0lGSUVEEAASFwoTUEFZTU'
    'VOVF9NRVRIT0RfQ0FTSBABEhcKE1BBWU1FTlRfTUVUSE9EX0NBUkQQAhIWChJQQVlNRU5UX01F'
    'VEhPRF9VUEkQAxIgChxQQVlNRU5UX01FVEhPRF9CQU5LX1RSQU5TRkVSEAQSGQoVUEFZTUVOVF'
    '9NRVRIT0RfQ0hFUVVFEAUSIwofUEFZTUVOVF9NRVRIT0RfUEFZRVJfU0VUVExFTUVOVBAG');

@$core.Deprecated('Use accountStatusDescriptor instead')
const AccountStatus$json = {
  '1': 'AccountStatus',
  '2': [
    {'1': 'ACCOUNT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACCOUNT_STATUS_OPEN', '2': 1},
    {'1': 'ACCOUNT_STATUS_CLOSED', '2': 2},
  ],
};

/// Descriptor for `AccountStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List accountStatusDescriptor = $convert.base64Decode(
    'Cg1BY2NvdW50U3RhdHVzEh4KGkFDQ09VTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTQUNDT1'
    'VOVF9TVEFUVVNfT1BFThABEhkKFUFDQ09VTlRfU1RBVFVTX0NMT1NFRBAC');

@$core.Deprecated('Use shiftStatusDescriptor instead')
const ShiftStatus$json = {
  '1': 'ShiftStatus',
  '2': [
    {'1': 'SHIFT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SHIFT_STATUS_OPEN', '2': 1},
    {'1': 'SHIFT_STATUS_RECONCILED', '2': 2},
    {'1': 'SHIFT_STATUS_PENDING_APPROVAL', '2': 3},
  ],
};

/// Descriptor for `ShiftStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List shiftStatusDescriptor = $convert.base64Decode(
    'CgtTaGlmdFN0YXR1cxIcChhTSElGVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIVChFTSElGVF9TVE'
    'FUVVNfT1BFThABEhsKF1NISUZUX1NUQVRVU19SRUNPTkNJTEVEEAISIQodU0hJRlRfU1RBVFVT'
    'X1BFTkRJTkdfQVBQUk9WQUwQAw==');

@$core.Deprecated('Use exceptionKindDescriptor instead')
const ExceptionKind$json = {
  '1': 'ExceptionKind',
  '2': [
    {'1': 'EXCEPTION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EXCEPTION_KIND_UNBILLED_SERVICE', '2': 1},
    {'1': 'EXCEPTION_KIND_UNINVOICED_CHARGE', '2': 2},
    {'1': 'EXCEPTION_KIND_HELD_CHARGE', '2': 3},
    {'1': 'EXCEPTION_KIND_NO_TARIFF', '2': 4},
    {'1': 'EXCEPTION_KIND_UNPRICED_PACKAGE', '2': 5},
  ],
};

/// Descriptor for `ExceptionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List exceptionKindDescriptor = $convert.base64Decode(
    'Cg1FeGNlcHRpb25LaW5kEh4KGkVYQ0VQVElPTl9LSU5EX1VOU1BFQ0lGSUVEEAASIwofRVhDRV'
    'BUSU9OX0tJTkRfVU5CSUxMRURfU0VSVklDRRABEiQKIEVYQ0VQVElPTl9LSU5EX1VOSU5WT0lD'
    'RURfQ0hBUkdFEAISHgoaRVhDRVBUSU9OX0tJTkRfSEVMRF9DSEFSR0UQAxIcChhFWENFUFRJT0'
    '5fS0lORF9OT19UQVJJRkYQBBIjCh9FWENFUFRJT05fS0lORF9VTlBSSUNFRF9QQUNLQUdFEAU=');

@$core.Deprecated('Use moneyDescriptor instead')
const Money$json = {
  '1': 'Money',
  '2': [
    {'1': 'minor', '3': 1, '4': 1, '5': 3, '10': 'minor'},
    {'1': 'currency', '3': 2, '4': 1, '5': 9, '10': 'currency'},
  ],
};

/// Descriptor for `Money`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moneyDescriptor = $convert.base64Decode(
    'CgVNb25leRIUCgVtaW5vchgBIAEoA1IFbWlub3ISGgoIY3VycmVuY3kYAiABKAlSCGN1cnJlbm'
    'N5');

@$core.Deprecated('Use serviceItemDescriptor instead')
const ServiceItem$json = {
  '1': 'ServiceItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'department', '3': 3, '4': 1, '5': 9, '10': 'department'},
    {'1': 'revenue_account', '3': 4, '4': 1, '5': 9, '10': 'revenueAccount'},
    {'1': 'tax_code', '3': 5, '4': 1, '5': 9, '10': 'taxCode'},
    {'1': 'tax_rate_bp', '3': 6, '4': 1, '5': 5, '10': 'taxRateBp'},
    {'1': 'tax_inclusive', '3': 7, '4': 1, '5': 8, '10': 'taxInclusive'},
    {
      '1': 'effective_from',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_to',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
  ],
};

/// Descriptor for `ServiceItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceItemDescriptor = $convert.base64Decode(
    'CgtTZXJ2aWNlSXRlbRISCgRjb2RlGAEgASgJUgRjb2RlEiAKC2Rlc2NyaXB0aW9uGAIgASgJUg'
    'tkZXNjcmlwdGlvbhIeCgpkZXBhcnRtZW50GAMgASgJUgpkZXBhcnRtZW50EicKD3JldmVudWVf'
    'YWNjb3VudBgEIAEoCVIOcmV2ZW51ZUFjY291bnQSGQoIdGF4X2NvZGUYBSABKAlSB3RheENvZG'
    'USHgoLdGF4X3JhdGVfYnAYBiABKAVSCXRheFJhdGVCcBIjCg10YXhfaW5jbHVzaXZlGAcgASgI'
    'Ugx0YXhJbmNsdXNpdmUSQQoOZWZmZWN0aXZlX2Zyb20YCCABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEj0KDGVmZmVjdGl2ZV90bxgJIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZVRv');

@$core.Deprecated('Use tariffScopeDescriptor instead')
const TariffScope$json = {
  '1': 'TariffScope',
  '2': [
    {'1': 'payer_id', '3': 1, '4': 1, '5': 9, '10': 'payerId'},
    {'1': 'customer_id', '3': 2, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'room_class', '3': 4, '4': 1, '5': 9, '10': 'roomClass'},
    {'1': 'service_code', '3': 5, '4': 1, '5': 9, '10': 'serviceCode'},
  ],
};

/// Descriptor for `TariffScope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tariffScopeDescriptor = $convert.base64Decode(
    'CgtUYXJpZmZTY29wZRIZCghwYXllcl9pZBgBIAEoCVIHcGF5ZXJJZBIfCgtjdXN0b21lcl9pZB'
    'gCIAEoCVIKY3VzdG9tZXJJZBIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBIdCgpy'
    'b29tX2NsYXNzGAQgASgJUglyb29tQ2xhc3MSIQoMc2VydmljZV9jb2RlGAUgASgJUgtzZXJ2aW'
    'NlQ29kZQ==');

@$core.Deprecated('Use tariffLineDescriptor instead')
const TariffLine$json = {
  '1': 'TariffLine',
  '2': [
    {'1': 'tariff_line_id', '3': 1, '4': 1, '5': 9, '10': 'tariffLineId'},
    {'1': 'contract_id', '3': 2, '4': 1, '5': 9, '10': 'contractId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'scope',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.TariffScope',
      '10': 'scope'
    },
    {
      '1': 'price',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'price'
    },
    {'1': 'priority', '3': 6, '4': 1, '5': 5, '10': 'priority'},
    {
      '1': 'effective_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_to',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
  ],
};

/// Descriptor for `TariffLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tariffLineDescriptor = $convert.base64Decode(
    'CgpUYXJpZmZMaW5lEiQKDnRhcmlmZl9saW5lX2lkGAEgASgJUgx0YXJpZmZMaW5lSWQSHwoLY2'
    '9udHJhY3RfaWQYAiABKAlSCmNvbnRyYWN0SWQSEgoEbmFtZRgDIAEoCVIEbmFtZRI4CgVzY29w'
    'ZRgEIAEoCzIiLmhlYWx0aGNhcmUuYmlsbGluZy52MS5UYXJpZmZTY29wZVIFc2NvcGUSMgoFcH'
    'JpY2UYBSABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTW9uZXlSBXByaWNlEhoKCHByaW9y'
    'aXR5GAYgASgFUghwcmlvcml0eRJBCg5lZmZlY3RpdmVfZnJvbRgHIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SPQoMZWZmZWN0aXZlX3RvGAggASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZWZmZWN0aXZlVG8=');

@$core.Deprecated('Use pricingResultDescriptor instead')
const PricingResult$json = {
  '1': 'PricingResult',
  '2': [
    {
      '1': 'price',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'price'
    },
    {'1': 'contract_id', '3': 2, '4': 1, '5': 9, '10': 'contractId'},
    {'1': 'contract', '3': 3, '4': 1, '5': 9, '10': 'contract'},
    {
      '1': 'scope',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.TariffScope',
      '10': 'scope'
    },
  ],
};

/// Descriptor for `PricingResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pricingResultDescriptor = $convert.base64Decode(
    'Cg1QcmljaW5nUmVzdWx0EjIKBXByaWNlGAEgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk'
    '1vbmV5UgVwcmljZRIfCgtjb250cmFjdF9pZBgCIAEoCVIKY29udHJhY3RJZBIaCghjb250cmFj'
    'dBgDIAEoCVIIY29udHJhY3QSOAoFc2NvcGUYBCABKAsyIi5oZWFsdGhjYXJlLmJpbGxpbmcudj'
    'EuVGFyaWZmU2NvcGVSBXNjb3Bl');

@$core.Deprecated('Use packageInclusionDescriptor instead')
const PackageInclusion$json = {
  '1': 'PackageInclusion',
  '2': [
    {'1': 'service_code', '3': 1, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'quantity', '3': 2, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `PackageInclusion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageInclusionDescriptor = $convert.base64Decode(
    'ChBQYWNrYWdlSW5jbHVzaW9uEiEKDHNlcnZpY2VfY29kZRgBIAEoCVILc2VydmljZUNvZGUSGg'
    'oIcXVhbnRpdHkYAiABKAVSCHF1YW50aXR5');

@$core.Deprecated('Use packageCarveOutDescriptor instead')
const PackageCarveOut$json = {
  '1': 'PackageCarveOut',
  '2': [
    {'1': 'service_code', '3': 1, '4': 1, '5': 9, '10': 'serviceCode'},
    {
      '1': 'price',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'price'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `PackageCarveOut`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageCarveOutDescriptor = $convert.base64Decode(
    'Cg9QYWNrYWdlQ2FydmVPdXQSIQoMc2VydmljZV9jb2RlGAEgASgJUgtzZXJ2aWNlQ29kZRIyCg'
    'VwcmljZRgCIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIFcHJpY2USEgoEbm90'
    'ZRgDIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use packageDescriptor instead')
const Package$json = {
  '1': 'Package',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'price',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'price'
    },
    {
      '1': 'inclusions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.PackageInclusion',
      '10': 'inclusions'
    },
    {'1': 'exclusions', '3': 5, '4': 3, '5': 9, '10': 'exclusions'},
    {
      '1': 'carve_outs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.PackageCarveOut',
      '10': 'carveOuts'
    },
    {'1': 'room_class', '3': 7, '4': 1, '5': 9, '10': 'roomClass'},
    {
      '1': 'effective_from',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_to',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
  ],
};

/// Descriptor for `Package`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageDescriptor = $convert.base64Decode(
    'CgdQYWNrYWdlEhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZRgCIAEoCVIEbmFtZRIyCgVwcm'
    'ljZRgDIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIFcHJpY2USRwoKaW5jbHVz'
    'aW9ucxgEIAMoCzInLmhlYWx0aGNhcmUuYmlsbGluZy52MS5QYWNrYWdlSW5jbHVzaW9uUgppbm'
    'NsdXNpb25zEh4KCmV4Y2x1c2lvbnMYBSADKAlSCmV4Y2x1c2lvbnMSRQoKY2FydmVfb3V0cxgG'
    'IAMoCzImLmhlYWx0aGNhcmUuYmlsbGluZy52MS5QYWNrYWdlQ2FydmVPdXRSCWNhcnZlT3V0cx'
    'IdCgpyb29tX2NsYXNzGAcgASgJUglyb29tQ2xhc3MSQQoOZWZmZWN0aXZlX2Zyb20YCCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEj0KDGVmZmVjdGl2ZV'
    '90bxgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZVRv');

@$core.Deprecated('Use sourceReferenceDescriptor instead')
const SourceReference$json = {
  '1': 'SourceReference',
  '2': [
    {'1': 'system', '3': 1, '4': 1, '5': 9, '10': 'system'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `SourceReference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sourceReferenceDescriptor = $convert.base64Decode(
    'Cg9Tb3VyY2VSZWZlcmVuY2USFgoGc3lzdGVtGAEgASgJUgZzeXN0ZW0SDgoCaWQYAiABKAlSAm'
    'lkEhYKBmRldGFpbBgDIAEoCVIGZGV0YWls');

@$core.Deprecated('Use chargeDescriptor instead')
const Charge$json = {
  '1': 'Charge',
  '2': [
    {'1': 'charge_id', '3': 1, '4': 1, '5': 9, '10': 'chargeId'},
    {'1': 'account_id', '3': 2, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'service_code', '3': 6, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
    {'1': 'department', '3': 8, '4': 1, '5': 9, '10': 'department'},
    {'1': 'quantity', '3': 9, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'unit_price',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'unitPrice'
    },
    {
      '1': 'pricing',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.PricingResult',
      '10': 'pricing'
    },
    {'1': 'tax_code', '3': 12, '4': 1, '5': 9, '10': 'taxCode'},
    {'1': 'tax_rate_bp', '3': 13, '4': 1, '5': 5, '10': 'taxRateBp'},
    {'1': 'tax_inclusive', '3': 14, '4': 1, '5': 8, '10': 'taxInclusive'},
    {
      '1': 'net',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'net'
    },
    {
      '1': 'tax',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'tax'
    },
    {
      '1': 'total',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'total'
    },
    {
      '1': 'origin',
      '3': 18,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.ChargeOrigin',
      '10': 'origin'
    },
    {
      '1': 'source',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.SourceReference',
      '10': 'source'
    },
    {'1': 'entered_by', '3': 20, '4': 1, '5': 9, '10': 'enteredBy'},
    {'1': 'reason', '3': 21, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'occurred_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'posted_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'postedAt'
    },
    {
      '1': 'status',
      '3': 24,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.ChargeStatus',
      '10': 'status'
    },
    {'1': 'package_code', '3': 25, '4': 1, '5': 9, '10': 'packageCode'},
    {'1': 'covered', '3': 26, '4': 1, '5': 8, '10': 'covered'},
    {'1': 'coverage_note', '3': 27, '4': 1, '5': 9, '10': 'coverageNote'},
    {'1': 'invoice_id', '3': 28, '4': 1, '5': 9, '10': 'invoiceId'},
  ],
};

/// Descriptor for `Charge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chargeDescriptor = $convert.base64Decode(
    'CgZDaGFyZ2USGwoJY2hhcmdlX2lkGAEgASgJUghjaGFyZ2VJZBIdCgphY2NvdW50X2lkGAIgAS'
    'gJUglhY2NvdW50SWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRl'
    'cl9pZBgEIAEoCVILZW5jb3VudGVySWQSHwoLZmFjaWxpdHlfaWQYBSABKAlSCmZhY2lsaXR5SW'
    'QSIQoMc2VydmljZV9jb2RlGAYgASgJUgtzZXJ2aWNlQ29kZRIgCgtkZXNjcmlwdGlvbhgHIAEo'
    'CVILZGVzY3JpcHRpb24SHgoKZGVwYXJ0bWVudBgIIAEoCVIKZGVwYXJ0bWVudBIaCghxdWFudG'
    'l0eRgJIAEoBVIIcXVhbnRpdHkSOwoKdW5pdF9wcmljZRgKIAEoCzIcLmhlYWx0aGNhcmUuYmls'
    'bGluZy52MS5Nb25leVIJdW5pdFByaWNlEj4KB3ByaWNpbmcYCyABKAsyJC5oZWFsdGhjYXJlLm'
    'JpbGxpbmcudjEuUHJpY2luZ1Jlc3VsdFIHcHJpY2luZxIZCgh0YXhfY29kZRgMIAEoCVIHdGF4'
    'Q29kZRIeCgt0YXhfcmF0ZV9icBgNIAEoBVIJdGF4UmF0ZUJwEiMKDXRheF9pbmNsdXNpdmUYDi'
    'ABKAhSDHRheEluY2x1c2l2ZRIuCgNuZXQYDyABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbmcudjEu'
    'TW9uZXlSA25ldBIuCgN0YXgYECABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTW9uZXlSA3'
    'RheBIyCgV0b3RhbBgRIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIFdG90YWwS'
    'OwoGb3JpZ2luGBIgASgOMiMuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkNoYXJnZU9yaWdpblIGb3'
    'JpZ2luEj4KBnNvdXJjZRgTIAEoCzImLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Tb3VyY2VSZWZl'
    'cmVuY2VSBnNvdXJjZRIdCgplbnRlcmVkX2J5GBQgASgJUgllbnRlcmVkQnkSFgoGcmVhc29uGB'
    'UgASgJUgZyZWFzb24SOwoLb2NjdXJyZWRfYXQYFiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgpvY2N1cnJlZEF0EjcKCXBvc3RlZF9hdBgXIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCHBvc3RlZEF0EjsKBnN0YXR1cxgYIAEoDjIjLmhlYWx0aGNhcmUuYmlsbGlu'
    'Zy52MS5DaGFyZ2VTdGF0dXNSBnN0YXR1cxIhCgxwYWNrYWdlX2NvZGUYGSABKAlSC3BhY2thZ2'
    'VDb2RlEhgKB2NvdmVyZWQYGiABKAhSB2NvdmVyZWQSIwoNY292ZXJhZ2Vfbm90ZRgbIAEoCVIM'
    'Y292ZXJhZ2VOb3RlEh0KCmludm9pY2VfaWQYHCABKAlSCWludm9pY2VJZA==');

@$core.Deprecated('Use consumptionDescriptor instead')
const Consumption$json = {
  '1': 'Consumption',
  '2': [
    {'1': 'package_code', '3': 1, '4': 1, '5': 9, '10': 'packageCode'},
    {'1': 'charge_id', '3': 2, '4': 1, '5': 9, '10': 'chargeId'},
    {'1': 'service_code', '3': 3, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'outcome',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.CoverageOutcome',
      '10': 'outcome'
    },
    {'1': 'explanation', '3': 6, '4': 1, '5': 9, '10': 'explanation'},
    {
      '1': 'price',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'price'
    },
    {
      '1': 'recorded_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `Consumption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consumptionDescriptor = $convert.base64Decode(
    'CgtDb25zdW1wdGlvbhIhCgxwYWNrYWdlX2NvZGUYASABKAlSC3BhY2thZ2VDb2RlEhsKCWNoYX'
    'JnZV9pZBgCIAEoCVIIY2hhcmdlSWQSIQoMc2VydmljZV9jb2RlGAMgASgJUgtzZXJ2aWNlQ29k'
    'ZRIaCghxdWFudGl0eRgEIAEoBVIIcXVhbnRpdHkSQAoHb3V0Y29tZRgFIAEoDjImLmhlYWx0aG'
    'NhcmUuYmlsbGluZy52MS5Db3ZlcmFnZU91dGNvbWVSB291dGNvbWUSIAoLZXhwbGFuYXRpb24Y'
    'BiABKAlSC2V4cGxhbmF0aW9uEjIKBXByaWNlGAcgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLn'
    'YxLk1vbmV5UgVwcmljZRI7CgtyZWNvcmRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCnJlY29yZGVkQXQ=');

@$core.Deprecated('Use liabilityShareDescriptor instead')
const LiabilityShare$json = {
  '1': 'LiabilityShare',
  '2': [
    {
      '1': 'party',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.LiabilityParty',
      '10': 'party'
    },
    {'1': 'party_id', '3': 2, '4': 1, '5': 9, '10': 'partyId'},
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'basis', '3': 4, '4': 1, '5': 9, '10': 'basis'},
    {'1': 'adjudication_ref', '3': 5, '4': 1, '5': 9, '10': 'adjudicationRef'},
  ],
};

/// Descriptor for `LiabilityShare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liabilityShareDescriptor = $convert.base64Decode(
    'Cg5MaWFiaWxpdHlTaGFyZRI7CgVwYXJ0eRgBIAEoDjIlLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5MaWFiaWxpdHlQYXJ0eVIFcGFydHkSGQoIcGFydHlfaWQYAiABKAlSB3BhcnR5SWQSNAoGYW1v'
    'dW50GAMgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgZhbW91bnQSFAoFYmFzaX'
    'MYBCABKAlSBWJhc2lzEikKEGFkanVkaWNhdGlvbl9yZWYYBSABKAlSD2FkanVkaWNhdGlvblJl'
    'Zg==');

@$core.Deprecated('Use discountDescriptor instead')
const Discount$json = {
  '1': 'Discount',
  '2': [
    {'1': 'rate_bp', '3': 1, '4': 1, '5': 5, '10': 'rateBp'},
    {
      '1': 'amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'applied_by', '3': 4, '4': 1, '5': 9, '10': 'appliedBy'},
    {'1': 'approved_by', '3': 5, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'applied_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'appliedAt'
    },
    {'1': 'approval_ref', '3': 7, '4': 1, '5': 9, '10': 'approvalRef'},
  ],
};

/// Descriptor for `Discount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discountDescriptor = $convert.base64Decode(
    'CghEaXNjb3VudBIXCgdyYXRlX2JwGAEgASgFUgZyYXRlQnASNAoGYW1vdW50GAIgASgLMhwuaG'
    'VhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgZhbW91bnQSFgoGcmVhc29uGAMgASgJUgZyZWFz'
    'b24SHQoKYXBwbGllZF9ieRgEIAEoCVIJYXBwbGllZEJ5Eh8KC2FwcHJvdmVkX2J5GAUgASgJUg'
    'phcHByb3ZlZEJ5EjkKCmFwcGxpZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUglhcHBsaWVkQXQSIQoMYXBwcm92YWxfcmVmGAcgASgJUgthcHByb3ZhbFJlZg==');

@$core.Deprecated('Use invoiceLineDescriptor instead')
const InvoiceLine$json = {
  '1': 'InvoiceLine',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 5, '10': 'sequence'},
    {'1': 'charge_id', '3': 2, '4': 1, '5': 9, '10': 'chargeId'},
    {'1': 'service_code', '3': 3, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'department', '3': 5, '4': 1, '5': 9, '10': 'department'},
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'unit_price',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'unitPrice'
    },
    {
      '1': 'net',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'net'
    },
    {'1': 'tax_code', '3': 9, '4': 1, '5': 9, '10': 'taxCode'},
    {'1': 'tax_rate_bp', '3': 10, '4': 1, '5': 5, '10': 'taxRateBp'},
    {
      '1': 'tax',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'tax'
    },
    {
      '1': 'discount',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'discount'
    },
    {
      '1': 'total',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'total'
    },
    {'1': 'package_code', '3': 14, '4': 1, '5': 9, '10': 'packageCode'},
    {'1': 'coverage_note', '3': 15, '4': 1, '5': 9, '10': 'coverageNote'},
  ],
};

/// Descriptor for `InvoiceLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceLineDescriptor = $convert.base64Decode(
    'CgtJbnZvaWNlTGluZRIaCghzZXF1ZW5jZRgBIAEoBVIIc2VxdWVuY2USGwoJY2hhcmdlX2lkGA'
    'IgASgJUghjaGFyZ2VJZBIhCgxzZXJ2aWNlX2NvZGUYAyABKAlSC3NlcnZpY2VDb2RlEiAKC2Rl'
    'c2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIeCgpkZXBhcnRtZW50GAUgASgJUgpkZXBhcn'
    'RtZW50EhoKCHF1YW50aXR5GAYgASgFUghxdWFudGl0eRI7Cgp1bml0X3ByaWNlGAcgASgLMhwu'
    'aGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5Ugl1bml0UHJpY2USLgoDbmV0GAggASgLMhwuaG'
    'VhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgNuZXQSGQoIdGF4X2NvZGUYCSABKAlSB3RheENv'
    'ZGUSHgoLdGF4X3JhdGVfYnAYCiABKAVSCXRheFJhdGVCcBIuCgN0YXgYCyABKAsyHC5oZWFsdG'
    'hjYXJlLmJpbGxpbmcudjEuTW9uZXlSA3RheBI4CghkaXNjb3VudBgMIAEoCzIcLmhlYWx0aGNh'
    'cmUuYmlsbGluZy52MS5Nb25leVIIZGlzY291bnQSMgoFdG90YWwYDSABKAsyHC5oZWFsdGhjYX'
    'JlLmJpbGxpbmcudjEuTW9uZXlSBXRvdGFsEiEKDHBhY2thZ2VfY29kZRgOIAEoCVILcGFja2Fn'
    'ZUNvZGUSIwoNY292ZXJhZ2Vfbm90ZRgPIAEoCVIMY292ZXJhZ2VOb3Rl');

@$core.Deprecated('Use invoiceDescriptor instead')
const Invoice$json = {
  '1': 'Invoice',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.DocumentKind',
      '10': 'kind'
    },
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.InvoiceStatus',
      '10': 'status'
    },
    {'1': 'account_id', '3': 5, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'patient_id', '3': 6, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 7, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 8, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'document_version', '3': 9, '4': 1, '5': 5, '10': 'documentVersion'},
    {'1': 'superseded_by', '3': 10, '4': 1, '5': 9, '10': 'supersededBy'},
    {
      '1': 'corrects_invoice_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'correctsInvoiceId'
    },
    {
      '1': 'lines',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.InvoiceLine',
      '10': 'lines'
    },
    {
      '1': 'subtotal',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'subtotal'
    },
    {
      '1': 'discount',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'discount'
    },
    {
      '1': 'tax',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'tax'
    },
    {
      '1': 'total',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'total'
    },
    {
      '1': 'discounts',
      '3': 17,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Discount',
      '10': 'discounts'
    },
    {
      '1': 'liability',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.LiabilityShare',
      '10': 'liability'
    },
    {'1': 'payer_id', '3': 19, '4': 1, '5': 9, '10': 'payerId'},
    {'1': 'customer_id', '3': 20, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'notes', '3': 21, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'issued_by', '3': 22, '4': 1, '5': 9, '10': 'issuedBy'},
    {
      '1': 'issued_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'created_by', '3': 24, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `Invoice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invoiceDescriptor = $convert.base64Decode(
    'CgdJbnZvaWNlEh0KCmludm9pY2VfaWQYASABKAlSCWludm9pY2VJZBIWCgZudW1iZXIYAiABKA'
    'lSBm51bWJlchI3CgRraW5kGAMgASgOMiMuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkRvY3VtZW50'
    'S2luZFIEa2luZBI8CgZzdGF0dXMYBCABKA4yJC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuSW52b2'
    'ljZVN0YXR1c1IGc3RhdHVzEh0KCmFjY291bnRfaWQYBSABKAlSCWFjY291bnRJZBIdCgpwYXRp'
    'ZW50X2lkGAYgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAcgASgJUgtlbmNvdW50ZX'
    'JJZBIfCgtmYWNpbGl0eV9pZBgIIAEoCVIKZmFjaWxpdHlJZBIpChBkb2N1bWVudF92ZXJzaW9u'
    'GAkgASgFUg9kb2N1bWVudFZlcnNpb24SIwoNc3VwZXJzZWRlZF9ieRgKIAEoCVIMc3VwZXJzZW'
    'RlZEJ5Ei4KE2NvcnJlY3RzX2ludm9pY2VfaWQYCyABKAlSEWNvcnJlY3RzSW52b2ljZUlkEjgK'
    'BWxpbmVzGAwgAygLMiIuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkludm9pY2VMaW5lUgVsaW5lcx'
    'I4CghzdWJ0b3RhbBgNIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIIc3VidG90'
    'YWwSOAoIZGlzY291bnQYDiABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTW9uZXlSCGRpc2'
    'NvdW50Ei4KA3RheBgPIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIDdGF4EjIK'
    'BXRvdGFsGBAgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgV0b3RhbBI9CglkaX'
    'Njb3VudHMYESADKAsyHy5oZWFsdGhjYXJlLmJpbGxpbmcudjEuRGlzY291bnRSCWRpc2NvdW50'
    'cxJDCglsaWFiaWxpdHkYEiADKAsyJS5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTGlhYmlsaXR5U2'
    'hhcmVSCWxpYWJpbGl0eRIZCghwYXllcl9pZBgTIAEoCVIHcGF5ZXJJZBIfCgtjdXN0b21lcl9p'
    'ZBgUIAEoCVIKY3VzdG9tZXJJZBIUCgVub3RlcxgVIAEoCVIFbm90ZXMSGwoJaXNzdWVkX2J5GB'
    'YgASgJUghpc3N1ZWRCeRI3Cglpc3N1ZWRfYXQYFyABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUghpc3N1ZWRBdBIdCgpjcmVhdGVkX2J5GBggASgJUgljcmVhdGVkQnkSOQoKY3JlYX'
    'RlZF9hdBgZIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use ledgerEntryDescriptor instead')
const LedgerEntry$json = {
  '1': 'LedgerEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'account_id', '3': 2, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.EntryKind',
      '10': 'kind'
    },
    {
      '1': 'amount',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'invoice_id', '3': 7, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'payment_id', '3': 8, '4': 1, '5': 9, '10': 'paymentId'},
    {
      '1': 'refund_of_payment_id',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'refundOfPaymentId'
    },
    {
      '1': 'method',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.PaymentMethod',
      '10': 'method'
    },
    {'1': 'provider_ref', '3': 11, '4': 1, '5': 9, '10': 'providerRef'},
    {'1': 'receipt_number', '3': 12, '4': 1, '5': 9, '10': 'receiptNumber'},
    {'1': 'shift_id', '3': 13, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'reason', '3': 14, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'recorded_by', '3': 15, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'approved_by', '3': 16, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'occurred_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `LedgerEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ledgerEntryDescriptor = $convert.base64Decode(
    'CgtMZWRnZXJFbnRyeRIZCghlbnRyeV9pZBgBIAEoCVIHZW50cnlJZBIdCgphY2NvdW50X2lkGA'
    'IgASgJUglhY2NvdW50SWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEiEKDGVuY291'
    'bnRlcl9pZBgEIAEoCVILZW5jb3VudGVySWQSNAoEa2luZBgFIAEoDjIgLmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5FbnRyeUtpbmRSBGtpbmQSNAoGYW1vdW50GAYgASgLMhwuaGVhbHRoY2FyZS5i'
    'aWxsaW5nLnYxLk1vbmV5UgZhbW91bnQSHQoKaW52b2ljZV9pZBgHIAEoCVIJaW52b2ljZUlkEh'
    '0KCnBheW1lbnRfaWQYCCABKAlSCXBheW1lbnRJZBIvChRyZWZ1bmRfb2ZfcGF5bWVudF9pZBgJ'
    'IAEoCVIRcmVmdW5kT2ZQYXltZW50SWQSPAoGbWV0aG9kGAogASgOMiQuaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLlBheW1lbnRNZXRob2RSBm1ldGhvZBIhCgxwcm92aWRlcl9yZWYYCyABKAlSC3By'
    'b3ZpZGVyUmVmEiUKDnJlY2VpcHRfbnVtYmVyGAwgASgJUg1yZWNlaXB0TnVtYmVyEhkKCHNoaW'
    'Z0X2lkGA0gASgJUgdzaGlmdElkEhYKBnJlYXNvbhgOIAEoCVIGcmVhc29uEh8KC3JlY29yZGVk'
    'X2J5GA8gASgJUgpyZWNvcmRlZEJ5Eh8KC2FwcHJvdmVkX2J5GBAgASgJUgphcHByb3ZlZEJ5Ej'
    'sKC29jY3VycmVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJy'
    'ZWRBdA==');

@$core.Deprecated('Use accountDescriptor instead')
const Account$json = {
  '1': 'Account',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'payer_id', '3': 6, '4': 1, '5': 9, '10': 'payerId'},
    {'1': 'customer_id', '3': 7, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'room_class', '3': 8, '4': 1, '5': 9, '10': 'roomClass'},
    {'1': 'package_code', '3': 9, '4': 1, '5': 9, '10': 'packageCode'},
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.AccountStatus',
      '10': 'status'
    },
    {'1': 'closed_by', '3': 11, '4': 1, '5': 9, '10': 'closedBy'},
    {
      '1': 'closed_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
  ],
};

/// Descriptor for `Account`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accountDescriptor = $convert.base64Decode(
    'CgdBY2NvdW50Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIfCgtm'
    'YWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIaCghjdXJyZW5jeRgFIAEoCVIIY3VycmVuY3'
    'kSGQoIcGF5ZXJfaWQYBiABKAlSB3BheWVySWQSHwoLY3VzdG9tZXJfaWQYByABKAlSCmN1c3Rv'
    'bWVySWQSHQoKcm9vbV9jbGFzcxgIIAEoCVIJcm9vbUNsYXNzEiEKDHBhY2thZ2VfY29kZRgJIA'
    'EoCVILcGFja2FnZUNvZGUSPAoGc3RhdHVzGAogASgOMiQuaGVhbHRoY2FyZS5iaWxsaW5nLnYx'
    'LkFjY291bnRTdGF0dXNSBnN0YXR1cxIbCgljbG9zZWRfYnkYCyABKAlSCGNsb3NlZEJ5EjcKCW'
    'Nsb3NlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGNsb3NlZEF0');

@$core.Deprecated('Use closeExceptionDescriptor instead')
const CloseException$json = {
  '1': 'CloseException',
  '2': [
    {'1': 'check', '3': 1, '4': 1, '5': 9, '10': 'check'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'references', '3': 4, '4': 3, '5': 9, '10': 'references'},
  ],
};

/// Descriptor for `CloseException`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeExceptionDescriptor = $convert.base64Decode(
    'Cg5DbG9zZUV4Y2VwdGlvbhIUCgVjaGVjaxgBIAEoCVIFY2hlY2sSFgoGZGV0YWlsGAIgASgJUg'
    'ZkZXRhaWwSNAoGYW1vdW50GAMgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgZh'
    'bW91bnQSHgoKcmVmZXJlbmNlcxgEIAMoCVIKcmVmZXJlbmNlcw==');

@$core.Deprecated('Use shiftDescriptor instead')
const Shift$json = {
  '1': 'Shift',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'counter_id', '3': 3, '4': 1, '5': 9, '10': 'counterId'},
    {'1': 'cashier_id', '3': 4, '4': 1, '5': 9, '10': 'cashierId'},
    {
      '1': 'opening_float',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'openingFloat'
    },
    {
      '1': 'opened_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
    {
      '1': 'counted_cash',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'countedCash'
    },
    {
      '1': 'expected_cash',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'expectedCash'
    },
    {
      '1': 'variance',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'variance'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.ShiftStatus',
      '10': 'status'
    },
    {'1': 'variance_reason', '3': 11, '4': 1, '5': 9, '10': 'varianceReason'},
    {'1': 'approved_by', '3': 12, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'closed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
  ],
};

/// Descriptor for `Shift`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shiftDescriptor = $convert.base64Decode(
    'CgVTaGlmdBIZCghzaGlmdF9pZBgBIAEoCVIHc2hpZnRJZBIfCgtmYWNpbGl0eV9pZBgCIAEoCV'
    'IKZmFjaWxpdHlJZBIdCgpjb3VudGVyX2lkGAMgASgJUgljb3VudGVySWQSHQoKY2FzaGllcl9p'
    'ZBgEIAEoCVIJY2FzaGllcklkEkEKDW9wZW5pbmdfZmxvYXQYBSABKAsyHC5oZWFsdGhjYXJlLm'
    'JpbGxpbmcudjEuTW9uZXlSDG9wZW5pbmdGbG9hdBI3CglvcGVuZWRfYXQYBiABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUghvcGVuZWRBdBI/Cgxjb3VudGVkX2Nhc2gYByABKAsyHC'
    '5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTW9uZXlSC2NvdW50ZWRDYXNoEkEKDWV4cGVjdGVkX2Nh'
    'c2gYCCABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTW9uZXlSDGV4cGVjdGVkQ2FzaBI4Cg'
    'h2YXJpYW5jZRgJIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIIdmFyaWFuY2US'
    'OgoGc3RhdHVzGAogASgOMiIuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlNoaWZ0U3RhdHVzUgZzdG'
    'F0dXMSJwoPdmFyaWFuY2VfcmVhc29uGAsgASgJUg52YXJpYW5jZVJlYXNvbhIfCgthcHByb3Zl'
    'ZF9ieRgMIAEoCVIKYXBwcm92ZWRCeRI3CgljbG9zZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUghjbG9zZWRBdA==');

@$core.Deprecated('Use revenueExceptionDescriptor instead')
const RevenueException$json = {
  '1': 'RevenueException',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.ExceptionKind',
      '10': 'kind'
    },
    {'1': 'account_id', '3': 2, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'charge_id', '3': 5, '4': 1, '5': 9, '10': 'chargeId'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.SourceReference',
      '10': 'source'
    },
    {'1': 'detail', '3': 7, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'amount',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'age_seconds', '3': 9, '4': 1, '5': 3, '10': 'ageSeconds'},
  ],
};

/// Descriptor for `RevenueException`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revenueExceptionDescriptor = $convert.base64Decode(
    'ChBSZXZlbnVlRXhjZXB0aW9uEjgKBGtpbmQYASABKA4yJC5oZWFsdGhjYXJlLmJpbGxpbmcudj'
    'EuRXhjZXB0aW9uS2luZFIEa2luZBIdCgphY2NvdW50X2lkGAIgASgJUglhY2NvdW50SWQSHQoK'
    'cGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgEIAEoCVILZW5jb3'
    'VudGVySWQSGwoJY2hhcmdlX2lkGAUgASgJUghjaGFyZ2VJZBI+CgZzb3VyY2UYBiABKAsyJi5o'
    'ZWFsdGhjYXJlLmJpbGxpbmcudjEuU291cmNlUmVmZXJlbmNlUgZzb3VyY2USFgoGZGV0YWlsGA'
    'cgASgJUgZkZXRhaWwSNAoGYW1vdW50GAggASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1v'
    'bmV5UgZhbW91bnQSHwoLYWdlX3NlY29uZHMYCSABKANSCmFnZVNlY29uZHM=');

@$core.Deprecated('Use billableEventDescriptor instead')
const BillableEvent$json = {
  '1': 'BillableEvent',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.SourceReference',
      '10': 'source'
    },
    {'1': 'service_code', '3': 2, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'account_id', '3': 5, '4': 1, '5': 9, '10': 'accountId'},
    {
      '1': 'occurred_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `BillableEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List billableEventDescriptor = $convert.base64Decode(
    'Cg1CaWxsYWJsZUV2ZW50Ej4KBnNvdXJjZRgBIAEoCzImLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5Tb3VyY2VSZWZlcmVuY2VSBnNvdXJjZRIhCgxzZXJ2aWNlX2NvZGUYAiABKAlSC3NlcnZpY2VD'
    'b2RlEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYBCABKA'
    'lSC2VuY291bnRlcklkEh0KCmFjY291bnRfaWQYBSABKAlSCWFjY291bnRJZBI7CgtvY2N1cnJl'
    'ZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQ=');

@$core.Deprecated('Use discountLimitDescriptor instead')
const DiscountLimit$json = {
  '1': 'DiscountLimit',
  '2': [
    {'1': 'max_rate_bp', '3': 1, '4': 1, '5': 5, '10': 'maxRateBp'},
    {
      '1': 'max_amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'maxAmount'
    },
  ],
};

/// Descriptor for `DiscountLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discountLimitDescriptor = $convert.base64Decode(
    'Cg1EaXNjb3VudExpbWl0Eh4KC21heF9yYXRlX2JwGAEgASgFUgltYXhSYXRlQnASOwoKbWF4X2'
    'Ftb3VudBgCIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIJbWF4QW1vdW50');

@$core.Deprecated('Use billingPolicyDescriptor instead')
const BillingPolicy$json = {
  '1': 'BillingPolicy',
  '2': [
    {
      '1': 'discount_limits',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.BillingPolicy.DiscountLimitsEntry',
      '10': 'discountLimits'
    },
    {'1': 'close_checks', '3': 2, '4': 3, '5': 9, '10': 'closeChecks'},
    {
      '1': 'allow_payer_balance',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'allowPayerBalance'
    },
    {
      '1': 'variance_threshold_minor',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'varianceThresholdMinor'
    },
    {'1': 'currency', '3': 5, '4': 1, '5': 9, '10': 'currency'},
  ],
  '3': [BillingPolicy_DiscountLimitsEntry$json],
};

@$core.Deprecated('Use billingPolicyDescriptor instead')
const BillingPolicy_DiscountLimitsEntry$json = {
  '1': 'DiscountLimitsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.DiscountLimit',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `BillingPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List billingPolicyDescriptor = $convert.base64Decode(
    'Cg1CaWxsaW5nUG9saWN5EmEKD2Rpc2NvdW50X2xpbWl0cxgBIAMoCzI4LmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5CaWxsaW5nUG9saWN5LkRpc2NvdW50TGltaXRzRW50cnlSDmRpc2NvdW50TGlt'
    'aXRzEiEKDGNsb3NlX2NoZWNrcxgCIAMoCVILY2xvc2VDaGVja3MSLgoTYWxsb3dfcGF5ZXJfYm'
    'FsYW5jZRgDIAEoCFIRYWxsb3dQYXllckJhbGFuY2USOAoYdmFyaWFuY2VfdGhyZXNob2xkX21p'
    'bm9yGAQgASgDUhZ2YXJpYW5jZVRocmVzaG9sZE1pbm9yEhoKCGN1cnJlbmN5GAUgASgJUghjdX'
    'JyZW5jeRpnChNEaXNjb3VudExpbWl0c0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EjoKBXZhbHVl'
    'GAIgASgLMiQuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkRpc2NvdW50TGltaXRSBXZhbHVlOgI4AQ'
    '==');

@$core.Deprecated('Use openAccountRequestDescriptor instead')
const OpenAccountRequest$json = {
  '1': 'OpenAccountRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'currency', '3': 3, '4': 1, '5': 9, '10': 'currency'},
    {'1': 'payer_id', '3': 4, '4': 1, '5': 9, '10': 'payerId'},
    {'1': 'customer_id', '3': 5, '4': 1, '5': 9, '10': 'customerId'},
    {'1': 'room_class', '3': 6, '4': 1, '5': 9, '10': 'roomClass'},
    {'1': 'package_code', '3': 7, '4': 1, '5': 9, '10': 'packageCode'},
  ],
};

/// Descriptor for `OpenAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openAccountRequestDescriptor = $convert.base64Decode(
    'ChJPcGVuQWNjb3VudFJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZB'
    'IdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSGgoIY3VycmVuY3kYAyABKAlSCGN1cnJl'
    'bmN5EhkKCHBheWVyX2lkGAQgASgJUgdwYXllcklkEh8KC2N1c3RvbWVyX2lkGAUgASgJUgpjdX'
    'N0b21lcklkEh0KCnJvb21fY2xhc3MYBiABKAlSCXJvb21DbGFzcxIhCgxwYWNrYWdlX2NvZGUY'
    'ByABKAlSC3BhY2thZ2VDb2Rl');

@$core.Deprecated('Use openAccountResponseDescriptor instead')
const OpenAccountResponse$json = {
  '1': 'OpenAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Account',
      '10': 'account'
    },
  ],
};

/// Descriptor for `OpenAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openAccountResponseDescriptor = $convert.base64Decode(
    'ChNPcGVuQWNjb3VudFJlc3BvbnNlEjgKB2FjY291bnQYASABKAsyHi5oZWFsdGhjYXJlLmJpbG'
    'xpbmcudjEuQWNjb3VudFIHYWNjb3VudA==');

@$core.Deprecated('Use getAccountRequestDescriptor instead')
const GetAccountRequest$json = {
  '1': 'GetAccountRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `GetAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountRequestDescriptor = $convert.base64Decode(
    'ChFHZXRBY2NvdW50UmVxdWVzdBIdCgphY2NvdW50X2lkGAEgASgJUglhY2NvdW50SWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZA==');

@$core.Deprecated('Use getAccountResponseDescriptor instead')
const GetAccountResponse$json = {
  '1': 'GetAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Account',
      '10': 'account'
    },
  ],
};

/// Descriptor for `GetAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAccountResponseDescriptor = $convert.base64Decode(
    'ChJHZXRBY2NvdW50UmVzcG9uc2USOAoHYWNjb3VudBgBIAEoCzIeLmhlYWx0aGNhcmUuYmlsbG'
    'luZy52MS5BY2NvdW50UgdhY2NvdW50');

@$core.Deprecated('Use postChargeRequestDescriptor instead')
const PostChargeRequest$json = {
  '1': 'PostChargeRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'service_code', '3': 2, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'origin',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.ChargeOrigin',
      '10': 'origin'
    },
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.SourceReference',
      '10': 'source'
    },
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'occurred_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `PostChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postChargeRequestDescriptor = $convert.base64Decode(
    'ChFQb3N0Q2hhcmdlUmVxdWVzdBIdCgphY2NvdW50X2lkGAEgASgJUglhY2NvdW50SWQSIQoMc2'
    'VydmljZV9jb2RlGAIgASgJUgtzZXJ2aWNlQ29kZRIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRp'
    'dHkSOwoGb3JpZ2luGAQgASgOMiMuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkNoYXJnZU9yaWdpbl'
    'IGb3JpZ2luEj4KBnNvdXJjZRgFIAEoCzImLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Tb3VyY2VS'
    'ZWZlcmVuY2VSBnNvdXJjZRIWCgZyZWFzb24YBiABKAlSBnJlYXNvbhI7CgtvY2N1cnJlZF9hdB'
    'gHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQ=');

@$core.Deprecated('Use postChargeResponseDescriptor instead')
const PostChargeResponse$json = {
  '1': 'PostChargeResponse',
  '2': [
    {
      '1': 'charge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charge'
    },
    {'1': 'already_posted', '3': 2, '4': 1, '5': 8, '10': 'alreadyPosted'},
    {
      '1': 'consumption',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Consumption',
      '10': 'consumption'
    },
  ],
};

/// Descriptor for `PostChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postChargeResponseDescriptor = $convert.base64Decode(
    'ChJQb3N0Q2hhcmdlUmVzcG9uc2USNQoGY2hhcmdlGAEgASgLMh0uaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLkNoYXJnZVIGY2hhcmdlEiUKDmFscmVhZHlfcG9zdGVkGAIgASgIUg1hbHJlYWR5UG9z'
    'dGVkEkQKC2NvbnN1bXB0aW9uGAMgASgLMiIuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkNvbnN1bX'
    'B0aW9uUgtjb25zdW1wdGlvbg==');

@$core.Deprecated('Use changeChargeRequestDescriptor instead')
const ChangeChargeRequest$json = {
  '1': 'ChangeChargeRequest',
  '2': [
    {'1': 'charge_id', '3': 1, '4': 1, '5': 9, '10': 'chargeId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ChangeChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeChargeRequestDescriptor = $convert.base64Decode(
    'ChNDaGFuZ2VDaGFyZ2VSZXF1ZXN0EhsKCWNoYXJnZV9pZBgBIAEoCVIIY2hhcmdlSWQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use changeChargeResponseDescriptor instead')
const ChangeChargeResponse$json = {
  '1': 'ChangeChargeResponse',
  '2': [
    {
      '1': 'charge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charge'
    },
  ],
};

/// Descriptor for `ChangeChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeChargeResponseDescriptor = $convert.base64Decode(
    'ChRDaGFuZ2VDaGFyZ2VSZXNwb25zZRI1CgZjaGFyZ2UYASABKAsyHS5oZWFsdGhjYXJlLmJpbG'
    'xpbmcudjEuQ2hhcmdlUgZjaGFyZ2U=');

@$core.Deprecated('Use voidChargeRequestDescriptor instead')
const VoidChargeRequest$json = {
  '1': 'VoidChargeRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.ChangeChargeRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `VoidChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidChargeRequestDescriptor = $convert.base64Decode(
    'ChFWb2lkQ2hhcmdlUmVxdWVzdBJCCgZjaGFuZ2UYASABKAsyKi5oZWFsdGhjYXJlLmJpbGxpbm'
    'cudjEuQ2hhbmdlQ2hhcmdlUmVxdWVzdFIGY2hhbmdl');

@$core.Deprecated('Use voidChargeResponseDescriptor instead')
const VoidChargeResponse$json = {
  '1': 'VoidChargeResponse',
  '2': [
    {
      '1': 'charge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charge'
    },
  ],
};

/// Descriptor for `VoidChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidChargeResponseDescriptor = $convert.base64Decode(
    'ChJWb2lkQ2hhcmdlUmVzcG9uc2USNQoGY2hhcmdlGAEgASgLMh0uaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLkNoYXJnZVIGY2hhcmdl');

@$core.Deprecated('Use holdChargeRequestDescriptor instead')
const HoldChargeRequest$json = {
  '1': 'HoldChargeRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.ChangeChargeRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `HoldChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdChargeRequestDescriptor = $convert.base64Decode(
    'ChFIb2xkQ2hhcmdlUmVxdWVzdBJCCgZjaGFuZ2UYASABKAsyKi5oZWFsdGhjYXJlLmJpbGxpbm'
    'cudjEuQ2hhbmdlQ2hhcmdlUmVxdWVzdFIGY2hhbmdl');

@$core.Deprecated('Use holdChargeResponseDescriptor instead')
const HoldChargeResponse$json = {
  '1': 'HoldChargeResponse',
  '2': [
    {
      '1': 'charge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charge'
    },
  ],
};

/// Descriptor for `HoldChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdChargeResponseDescriptor = $convert.base64Decode(
    'ChJIb2xkQ2hhcmdlUmVzcG9uc2USNQoGY2hhcmdlGAEgASgLMh0uaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLkNoYXJnZVIGY2hhcmdl');

@$core.Deprecated('Use releaseChargeRequestDescriptor instead')
const ReleaseChargeRequest$json = {
  '1': 'ReleaseChargeRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.ChangeChargeRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `ReleaseChargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseChargeRequestDescriptor = $convert.base64Decode(
    'ChRSZWxlYXNlQ2hhcmdlUmVxdWVzdBJCCgZjaGFuZ2UYASABKAsyKi5oZWFsdGhjYXJlLmJpbG'
    'xpbmcudjEuQ2hhbmdlQ2hhcmdlUmVxdWVzdFIGY2hhbmdl');

@$core.Deprecated('Use releaseChargeResponseDescriptor instead')
const ReleaseChargeResponse$json = {
  '1': 'ReleaseChargeResponse',
  '2': [
    {
      '1': 'charge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charge'
    },
  ],
};

/// Descriptor for `ReleaseChargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseChargeResponseDescriptor = $convert.base64Decode(
    'ChVSZWxlYXNlQ2hhcmdlUmVzcG9uc2USNQoGY2hhcmdlGAEgASgLMh0uaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLkNoYXJnZVIGY2hhcmdl');

@$core.Deprecated('Use listChargesRequestDescriptor instead')
const ListChargesRequest$json = {
  '1': 'ListChargesRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'billable_only', '3': 2, '4': 1, '5': 8, '10': 'billableOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListChargesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChargesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0Q2hhcmdlc1JlcXVlc3QSHQoKYWNjb3VudF9pZBgBIAEoCVIJYWNjb3VudElkEiMKDW'
    'JpbGxhYmxlX29ubHkYAiABKAhSDGJpbGxhYmxlT25seRIbCglwYWdlX3NpemUYAyABKAVSCHBh'
    'Z2VTaXpl');

@$core.Deprecated('Use listChargesResponseDescriptor instead')
const ListChargesResponse$json = {
  '1': 'ListChargesResponse',
  '2': [
    {
      '1': 'charges',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Charge',
      '10': 'charges'
    },
  ],
};

/// Descriptor for `ListChargesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChargesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2hhcmdlc1Jlc3BvbnNlEjcKB2NoYXJnZXMYASADKAsyHS5oZWFsdGhjYXJlLmJpbG'
    'xpbmcudjEuQ2hhcmdlUgdjaGFyZ2Vz');

@$core.Deprecated('Use packageLedgerRequestDescriptor instead')
const PackageLedgerRequest$json = {
  '1': 'PackageLedgerRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `PackageLedgerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageLedgerRequestDescriptor = $convert.base64Decode(
    'ChRQYWNrYWdlTGVkZ2VyUmVxdWVzdBIdCgphY2NvdW50X2lkGAEgASgJUglhY2NvdW50SWQ=');

@$core.Deprecated('Use packageLedgerResponseDescriptor instead')
const PackageLedgerResponse$json = {
  '1': 'PackageLedgerResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Consumption',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `PackageLedgerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageLedgerResponseDescriptor = $convert.base64Decode(
    'ChVQYWNrYWdlTGVkZ2VyUmVzcG9uc2USPAoHZW50cmllcxgBIAMoCzIiLmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5Db25zdW1wdGlvblIHZW50cmllcw==');

@$core.Deprecated('Use raiseInvoiceRequestDescriptor instead')
const RaiseInvoiceRequest$json = {
  '1': 'RaiseInvoiceRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.DocumentKind',
      '10': 'kind'
    },
    {
      '1': 'discount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Discount',
      '10': 'discount'
    },
    {
      '1': 'liability',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.LiabilityShare',
      '10': 'liability'
    },
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'issue', '3': 6, '4': 1, '5': 8, '10': 'issue'},
  ],
};

/// Descriptor for `RaiseInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseInvoiceRequestDescriptor = $convert.base64Decode(
    'ChNSYWlzZUludm9pY2VSZXF1ZXN0Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZBI3Cg'
    'RraW5kGAIgASgOMiMuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkRvY3VtZW50S2luZFIEa2luZBI7'
    'CghkaXNjb3VudBgDIAEoCzIfLmhlYWx0aGNhcmUuYmlsbGluZy52MS5EaXNjb3VudFIIZGlzY2'
    '91bnQSQwoJbGlhYmlsaXR5GAQgAygLMiUuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkxpYWJpbGl0'
    'eVNoYXJlUglsaWFiaWxpdHkSFAoFbm90ZXMYBSABKAlSBW5vdGVzEhQKBWlzc3VlGAYgASgIUg'
    'Vpc3N1ZQ==');

@$core.Deprecated('Use raiseInvoiceResponseDescriptor instead')
const RaiseInvoiceResponse$json = {
  '1': 'RaiseInvoiceResponse',
  '2': [
    {
      '1': 'invoice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Invoice',
      '10': 'invoice'
    },
  ],
};

/// Descriptor for `RaiseInvoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseInvoiceResponseDescriptor = $convert.base64Decode(
    'ChRSYWlzZUludm9pY2VSZXNwb25zZRI4CgdpbnZvaWNlGAEgASgLMh4uaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLkludm9pY2VSB2ludm9pY2U=');

@$core.Deprecated('Use correctInvoiceRequestDescriptor instead')
const CorrectInvoiceRequest$json = {
  '1': 'CorrectInvoiceRequest',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.DocumentKind',
      '10': 'kind'
    },
    {
      '1': 'lines',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.InvoiceLine',
      '10': 'lines'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CorrectInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctInvoiceRequestDescriptor = $convert.base64Decode(
    'ChVDb3JyZWN0SW52b2ljZVJlcXVlc3QSHQoKaW52b2ljZV9pZBgBIAEoCVIJaW52b2ljZUlkEj'
    'cKBGtpbmQYAiABKA4yIy5oZWFsdGhjYXJlLmJpbGxpbmcudjEuRG9jdW1lbnRLaW5kUgRraW5k'
    'EjgKBWxpbmVzGAMgAygLMiIuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkludm9pY2VMaW5lUgVsaW'
    '5lcxIWCgZyZWFzb24YBCABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use correctInvoiceResponseDescriptor instead')
const CorrectInvoiceResponse$json = {
  '1': 'CorrectInvoiceResponse',
  '2': [
    {
      '1': 'note',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Invoice',
      '10': 'note'
    },
  ],
};

/// Descriptor for `CorrectInvoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctInvoiceResponseDescriptor =
    $convert.base64Decode(
        'ChZDb3JyZWN0SW52b2ljZVJlc3BvbnNlEjIKBG5vdGUYASABKAsyHi5oZWFsdGhjYXJlLmJpbG'
        'xpbmcudjEuSW52b2ljZVIEbm90ZQ==');

@$core.Deprecated('Use getInvoiceRequestDescriptor instead')
const GetInvoiceRequest$json = {
  '1': 'GetInvoiceRequest',
  '2': [
    {'1': 'invoice_id', '3': 1, '4': 1, '5': 9, '10': 'invoiceId'},
  ],
};

/// Descriptor for `GetInvoiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInvoiceRequestDescriptor = $convert.base64Decode(
    'ChFHZXRJbnZvaWNlUmVxdWVzdBIdCgppbnZvaWNlX2lkGAEgASgJUglpbnZvaWNlSWQ=');

@$core.Deprecated('Use getInvoiceResponseDescriptor instead')
const GetInvoiceResponse$json = {
  '1': 'GetInvoiceResponse',
  '2': [
    {
      '1': 'invoice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Invoice',
      '10': 'invoice'
    },
  ],
};

/// Descriptor for `GetInvoiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInvoiceResponseDescriptor = $convert.base64Decode(
    'ChJHZXRJbnZvaWNlUmVzcG9uc2USOAoHaW52b2ljZRgBIAEoCzIeLmhlYWx0aGNhcmUuYmlsbG'
    'luZy52MS5JbnZvaWNlUgdpbnZvaWNl');

@$core.Deprecated('Use listInvoicesRequestDescriptor instead')
const ListInvoicesRequest$json = {
  '1': 'ListInvoicesRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListInvoicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0SW52b2ljZXNSZXF1ZXN0Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZBIbCg'
    'lwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listInvoicesResponseDescriptor instead')
const ListInvoicesResponse$json = {
  '1': 'ListInvoicesResponse',
  '2': [
    {
      '1': 'invoices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Invoice',
      '10': 'invoices'
    },
  ],
};

/// Descriptor for `ListInvoicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInvoicesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0SW52b2ljZXNSZXNwb25zZRI6CghpbnZvaWNlcxgBIAMoCzIeLmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5JbnZvaWNlUghpbnZvaWNlcw==');

@$core.Deprecated('Use receivePaymentRequestDescriptor instead')
const ReceivePaymentRequest$json = {
  '1': 'ReceivePaymentRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {
      '1': 'amount',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {
      '1': 'method',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.billing.v1.PaymentMethod',
      '10': 'method'
    },
    {'1': 'provider_ref', '3': 4, '4': 1, '5': 9, '10': 'providerRef'},
    {'1': 'invoice_id', '3': 5, '4': 1, '5': 9, '10': 'invoiceId'},
    {'1': 'shift_id', '3': 6, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'idempotency_key', '3': 7, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'deposit', '3': 8, '4': 1, '5': 8, '10': 'deposit'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReceivePaymentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receivePaymentRequestDescriptor = $convert.base64Decode(
    'ChVSZWNlaXZlUGF5bWVudFJlcXVlc3QSHQoKYWNjb3VudF9pZBgBIAEoCVIJYWNjb3VudElkEj'
    'QKBmFtb3VudBgCIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Nb25leVIGYW1vdW50EjwK'
    'Bm1ldGhvZBgDIAEoDjIkLmhlYWx0aGNhcmUuYmlsbGluZy52MS5QYXltZW50TWV0aG9kUgZtZX'
    'Rob2QSIQoMcHJvdmlkZXJfcmVmGAQgASgJUgtwcm92aWRlclJlZhIdCgppbnZvaWNlX2lkGAUg'
    'ASgJUglpbnZvaWNlSWQSGQoIc2hpZnRfaWQYBiABKAlSB3NoaWZ0SWQSJwoPaWRlbXBvdGVuY3'
    'lfa2V5GAcgASgJUg5pZGVtcG90ZW5jeUtleRIYCgdkZXBvc2l0GAggASgIUgdkZXBvc2l0EhYK'
    'BnJlYXNvbhgJIAEoCVIGcmVhc29u');

@$core.Deprecated('Use receivePaymentResponseDescriptor instead')
const ReceivePaymentResponse$json = {
  '1': 'ReceivePaymentResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.LedgerEntry',
      '10': 'entry'
    },
    {'1': 'already_received', '3': 2, '4': 1, '5': 8, '10': 'alreadyReceived'},
    {
      '1': 'balance',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `ReceivePaymentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receivePaymentResponseDescriptor = $convert.base64Decode(
    'ChZSZWNlaXZlUGF5bWVudFJlc3BvbnNlEjgKBWVudHJ5GAEgASgLMiIuaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLkxlZGdlckVudHJ5UgVlbnRyeRIpChBhbHJlYWR5X3JlY2VpdmVkGAIgASgIUg9h'
    'bHJlYWR5UmVjZWl2ZWQSNgoHYmFsYW5jZRgDIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5Nb25leVIHYmFsYW5jZQ==');

@$core.Deprecated('Use refundRequestDescriptor instead')
const RefundRequest$json = {
  '1': 'RefundRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'payment_id', '3': 2, '4': 1, '5': 9, '10': 'paymentId'},
    {
      '1': 'amount',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'amount'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'shift_id', '3': 5, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'approved_by', '3': 6, '4': 1, '5': 9, '10': 'approvedBy'},
  ],
};

/// Descriptor for `RefundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundRequestDescriptor = $convert.base64Decode(
    'Cg1SZWZ1bmRSZXF1ZXN0Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZBIdCgpwYXltZW'
    '50X2lkGAIgASgJUglwYXltZW50SWQSNAoGYW1vdW50GAMgASgLMhwuaGVhbHRoY2FyZS5iaWxs'
    'aW5nLnYxLk1vbmV5UgZhbW91bnQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24SGQoIc2hpZnRfaW'
    'QYBSABKAlSB3NoaWZ0SWQSHwoLYXBwcm92ZWRfYnkYBiABKAlSCmFwcHJvdmVkQnk=');

@$core.Deprecated('Use refundResponseDescriptor instead')
const RefundResponse$json = {
  '1': 'RefundResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.LedgerEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `RefundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refundResponseDescriptor = $convert.base64Decode(
    'Cg5SZWZ1bmRSZXNwb25zZRI4CgVlbnRyeRgBIAEoCzIiLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5MZWRnZXJFbnRyeVIFZW50cnk=');

@$core.Deprecated('Use statementRequestDescriptor instead')
const StatementRequest$json = {
  '1': 'StatementRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `StatementRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementRequestDescriptor = $convert.base64Decode(
    'ChBTdGF0ZW1lbnRSZXF1ZXN0Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZA==');

@$core.Deprecated('Use statementResponseDescriptor instead')
const StatementResponse$json = {
  '1': 'StatementResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Account',
      '10': 'account'
    },
    {
      '1': 'entries',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.LedgerEntry',
      '10': 'entries'
    },
    {
      '1': 'balance',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'balance'
    },
    {
      '1': 'deposits',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'deposits'
    },
  ],
};

/// Descriptor for `StatementResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statementResponseDescriptor = $convert.base64Decode(
    'ChFTdGF0ZW1lbnRSZXNwb25zZRI4CgdhY2NvdW50GAEgASgLMh4uaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLkFjY291bnRSB2FjY291bnQSPAoHZW50cmllcxgCIAMoCzIiLmhlYWx0aGNhcmUuYmls'
    'bGluZy52MS5MZWRnZXJFbnRyeVIHZW50cmllcxI2CgdiYWxhbmNlGAMgASgLMhwuaGVhbHRoY2'
    'FyZS5iaWxsaW5nLnYxLk1vbmV5UgdiYWxhbmNlEjgKCGRlcG9zaXRzGAQgASgLMhwuaGVhbHRo'
    'Y2FyZS5iaWxsaW5nLnYxLk1vbmV5UghkZXBvc2l0cw==');

@$core.Deprecated('Use closeAccountRequestDescriptor instead')
const CloseAccountRequest$json = {
  '1': 'CloseAccountRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `CloseAccountRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAccountRequestDescriptor = $convert.base64Decode(
    'ChNDbG9zZUFjY291bnRSZXF1ZXN0Eh0KCmFjY291bnRfaWQYASABKAlSCWFjY291bnRJZA==');

@$core.Deprecated('Use closeAccountResponseDescriptor instead')
const CloseAccountResponse$json = {
  '1': 'CloseAccountResponse',
  '2': [
    {
      '1': 'account',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Account',
      '10': 'account'
    },
    {
      '1': 'exceptions',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.CloseException',
      '10': 'exceptions'
    },
  ],
};

/// Descriptor for `CloseAccountResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAccountResponseDescriptor = $convert.base64Decode(
    'ChRDbG9zZUFjY291bnRSZXNwb25zZRI4CgdhY2NvdW50GAEgASgLMh4uaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLkFjY291bnRSB2FjY291bnQSRQoKZXhjZXB0aW9ucxgCIAMoCzIlLmhlYWx0aGNh'
    'cmUuYmlsbGluZy52MS5DbG9zZUV4Y2VwdGlvblIKZXhjZXB0aW9ucw==');

@$core.Deprecated('Use closeReadinessRequestDescriptor instead')
const CloseReadinessRequest$json = {
  '1': 'CloseReadinessRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
  ],
};

/// Descriptor for `CloseReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeReadinessRequestDescriptor = $convert.base64Decode(
    'ChVDbG9zZVJlYWRpbmVzc1JlcXVlc3QSHQoKYWNjb3VudF9pZBgBIAEoCVIJYWNjb3VudElk');

@$core.Deprecated('Use closeReadinessResponseDescriptor instead')
const CloseReadinessResponse$json = {
  '1': 'CloseReadinessResponse',
  '2': [
    {
      '1': 'exceptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.CloseException',
      '10': 'exceptions'
    },
  ],
};

/// Descriptor for `CloseReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeReadinessResponseDescriptor =
    $convert.base64Decode(
        'ChZDbG9zZVJlYWRpbmVzc1Jlc3BvbnNlEkUKCmV4Y2VwdGlvbnMYASADKAsyJS5oZWFsdGhjYX'
        'JlLmJpbGxpbmcudjEuQ2xvc2VFeGNlcHRpb25SCmV4Y2VwdGlvbnM=');

@$core.Deprecated('Use revenueIntegrityRequestDescriptor instead')
const RevenueIntegrityRequest$json = {
  '1': 'RevenueIntegrityRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.BillableEvent',
      '10': 'events'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `RevenueIntegrityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revenueIntegrityRequestDescriptor = $convert.base64Decode(
    'ChdSZXZlbnVlSW50ZWdyaXR5UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBI8CgZldmVudHMYAiADKAsyJC5oZWFsdGhjYXJlLmJpbGxpbmcudjEuQmlsbGFibGVFdmVu'
    'dFIGZXZlbnRzEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use revenueIntegrityResponseDescriptor instead')
const RevenueIntegrityResponse$json = {
  '1': 'RevenueIntegrityResponse',
  '2': [
    {
      '1': 'exceptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.RevenueException',
      '10': 'exceptions'
    },
  ],
};

/// Descriptor for `RevenueIntegrityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List revenueIntegrityResponseDescriptor =
    $convert.base64Decode(
        'ChhSZXZlbnVlSW50ZWdyaXR5UmVzcG9uc2USRwoKZXhjZXB0aW9ucxgBIAMoCzInLmhlYWx0aG'
        'NhcmUuYmlsbGluZy52MS5SZXZlbnVlRXhjZXB0aW9uUgpleGNlcHRpb25z');

@$core.Deprecated('Use openShiftRequestDescriptor instead')
const OpenShiftRequest$json = {
  '1': 'OpenShiftRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'counter_id', '3': 2, '4': 1, '5': 9, '10': 'counterId'},
    {
      '1': 'opening_float',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'openingFloat'
    },
  ],
};

/// Descriptor for `OpenShiftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openShiftRequestDescriptor = $convert.base64Decode(
    'ChBPcGVuU2hpZnRSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eUlkEh0KCm'
    'NvdW50ZXJfaWQYAiABKAlSCWNvdW50ZXJJZBJBCg1vcGVuaW5nX2Zsb2F0GAMgASgLMhwuaGVh'
    'bHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5UgxvcGVuaW5nRmxvYXQ=');

@$core.Deprecated('Use openShiftResponseDescriptor instead')
const OpenShiftResponse$json = {
  '1': 'OpenShiftResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `OpenShiftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openShiftResponseDescriptor = $convert.base64Decode(
    'ChFPcGVuU2hpZnRSZXNwb25zZRIyCgVzaGlmdBgBIAEoCzIcLmhlYWx0aGNhcmUuYmlsbGluZy'
    '52MS5TaGlmdFIFc2hpZnQ=');

@$core.Deprecated('Use closeShiftRequestDescriptor instead')
const CloseShiftRequest$json = {
  '1': 'CloseShiftRequest',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
    {
      '1': 'counted',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Money',
      '10': 'counted'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CloseShiftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeShiftRequestDescriptor = $convert.base64Decode(
    'ChFDbG9zZVNoaWZ0UmVxdWVzdBIZCghzaGlmdF9pZBgBIAEoCVIHc2hpZnRJZBI2Cgdjb3VudG'
    'VkGAIgASgLMhwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLk1vbmV5Ugdjb3VudGVkEhYKBnJlYXNv'
    'bhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use closeShiftResponseDescriptor instead')
const CloseShiftResponse$json = {
  '1': 'CloseShiftResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `CloseShiftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeShiftResponseDescriptor = $convert.base64Decode(
    'ChJDbG9zZVNoaWZ0UmVzcG9uc2USMgoFc2hpZnQYASABKAsyHC5oZWFsdGhjYXJlLmJpbGxpbm'
    'cudjEuU2hpZnRSBXNoaWZ0');

@$core.Deprecated('Use approveShiftRequestDescriptor instead')
const ApproveShiftRequest$json = {
  '1': 'ApproveShiftRequest',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
  ],
};

/// Descriptor for `ApproveShiftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveShiftRequestDescriptor =
    $convert.base64Decode(
        'ChNBcHByb3ZlU2hpZnRSZXF1ZXN0EhkKCHNoaWZ0X2lkGAEgASgJUgdzaGlmdElk');

@$core.Deprecated('Use approveShiftResponseDescriptor instead')
const ApproveShiftResponse$json = {
  '1': 'ApproveShiftResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `ApproveShiftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveShiftResponseDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlU2hpZnRSZXNwb25zZRIyCgVzaGlmdBgBIAEoCzIcLmhlYWx0aGNhcmUuYmlsbG'
    'luZy52MS5TaGlmdFIFc2hpZnQ=');

@$core.Deprecated('Use listShiftsRequestDescriptor instead')
const ListShiftsRequest$json = {
  '1': 'ListShiftsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListShiftsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listShiftsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0U2hpZnRzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZBIbCg'
    'lwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listShiftsResponseDescriptor instead')
const ListShiftsResponse$json = {
  '1': 'ListShiftsResponse',
  '2': [
    {
      '1': 'shifts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Shift',
      '10': 'shifts'
    },
  ],
};

/// Descriptor for `ListShiftsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listShiftsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U2hpZnRzUmVzcG9uc2USNAoGc2hpZnRzGAEgAygLMhwuaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLlNoaWZ0UgZzaGlmdHM=');

@$core.Deprecated('Use publishServiceRequestDescriptor instead')
const PublishServiceRequest$json = {
  '1': 'PublishServiceRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.ServiceItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `PublishServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishServiceRequestDescriptor = $convert.base64Decode(
    'ChVQdWJsaXNoU2VydmljZVJlcXVlc3QSNgoEaXRlbRgBIAEoCzIiLmhlYWx0aGNhcmUuYmlsbG'
    'luZy52MS5TZXJ2aWNlSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use publishServiceResponseDescriptor instead')
const PublishServiceResponse$json = {
  '1': 'PublishServiceResponse',
};

/// Descriptor for `PublishServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishServiceResponseDescriptor =
    $convert.base64Decode('ChZQdWJsaXNoU2VydmljZVJlc3BvbnNl');

@$core.Deprecated('Use listServicesRequestDescriptor instead')
const ListServicesRequest$json = {
  '1': 'ListServicesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListServicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listServicesRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0U2VydmljZXNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listServicesResponseDescriptor instead')
const ListServicesResponse$json = {
  '1': 'ListServicesResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.ServiceItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListServicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listServicesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0U2VydmljZXNSZXNwb25zZRI4CgVpdGVtcxgBIAMoCzIiLmhlYWx0aGNhcmUuYmlsbG'
    'luZy52MS5TZXJ2aWNlSXRlbVIFaXRlbXM=');

@$core.Deprecated('Use publishTariffRequestDescriptor instead')
const PublishTariffRequest$json = {
  '1': 'PublishTariffRequest',
  '2': [
    {
      '1': 'line',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.TariffLine',
      '10': 'line'
    },
  ],
};

/// Descriptor for `PublishTariffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishTariffRequestDescriptor = $convert.base64Decode(
    'ChRQdWJsaXNoVGFyaWZmUmVxdWVzdBI1CgRsaW5lGAEgASgLMiEuaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLlRhcmlmZkxpbmVSBGxpbmU=');

@$core.Deprecated('Use publishTariffResponseDescriptor instead')
const PublishTariffResponse$json = {
  '1': 'PublishTariffResponse',
};

/// Descriptor for `PublishTariffResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishTariffResponseDescriptor =
    $convert.base64Decode('ChVQdWJsaXNoVGFyaWZmUmVzcG9uc2U=');

@$core.Deprecated('Use listTariffsRequestDescriptor instead')
const ListTariffsRequest$json = {
  '1': 'ListTariffsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListTariffsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTariffsRequestDescriptor =
    $convert.base64Decode(
        'ChJMaXN0VGFyaWZmc1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listTariffsResponseDescriptor instead')
const ListTariffsResponse$json = {
  '1': 'ListTariffsResponse',
  '2': [
    {
      '1': 'lines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.TariffLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `ListTariffsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTariffsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0VGFyaWZmc1Jlc3BvbnNlEjcKBWxpbmVzGAEgAygLMiEuaGVhbHRoY2FyZS5iaWxsaW'
    '5nLnYxLlRhcmlmZkxpbmVSBWxpbmVz');

@$core.Deprecated('Use quoteRequestDescriptor instead')
const QuoteRequest$json = {
  '1': 'QuoteRequest',
  '2': [
    {'1': 'account_id', '3': 1, '4': 1, '5': 9, '10': 'accountId'},
    {'1': 'service_code', '3': 2, '4': 1, '5': 9, '10': 'serviceCode'},
  ],
};

/// Descriptor for `QuoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quoteRequestDescriptor = $convert.base64Decode(
    'CgxRdW90ZVJlcXVlc3QSHQoKYWNjb3VudF9pZBgBIAEoCVIJYWNjb3VudElkEiEKDHNlcnZpY2'
    'VfY29kZRgCIAEoCVILc2VydmljZUNvZGU=');

@$core.Deprecated('Use quoteResponseDescriptor instead')
const QuoteResponse$json = {
  '1': 'QuoteResponse',
  '2': [
    {
      '1': 'pricing',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.PricingResult',
      '10': 'pricing'
    },
  ],
};

/// Descriptor for `QuoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quoteResponseDescriptor = $convert.base64Decode(
    'Cg1RdW90ZVJlc3BvbnNlEj4KB3ByaWNpbmcYASABKAsyJC5oZWFsdGhjYXJlLmJpbGxpbmcudj'
    'EuUHJpY2luZ1Jlc3VsdFIHcHJpY2luZw==');

@$core.Deprecated('Use publishPackageRequestDescriptor instead')
const PublishPackageRequest$json = {
  '1': 'PublishPackageRequest',
  '2': [
    {
      '1': 'package',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.Package',
      '10': 'package'
    },
  ],
};

/// Descriptor for `PublishPackageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishPackageRequestDescriptor = $convert.base64Decode(
    'ChVQdWJsaXNoUGFja2FnZVJlcXVlc3QSOAoHcGFja2FnZRgBIAEoCzIeLmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5QYWNrYWdlUgdwYWNrYWdl');

@$core.Deprecated('Use publishPackageResponseDescriptor instead')
const PublishPackageResponse$json = {
  '1': 'PublishPackageResponse',
};

/// Descriptor for `PublishPackageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List publishPackageResponseDescriptor =
    $convert.base64Decode('ChZQdWJsaXNoUGFja2FnZVJlc3BvbnNl');

@$core.Deprecated('Use listPackagesRequestDescriptor instead')
const ListPackagesRequest$json = {
  '1': 'ListPackagesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPackagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPackagesRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0UGFja2FnZXNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listPackagesResponseDescriptor instead')
const ListPackagesResponse$json = {
  '1': 'ListPackagesResponse',
  '2': [
    {
      '1': 'packages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.billing.v1.Package',
      '10': 'packages'
    },
  ],
};

/// Descriptor for `ListPackagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPackagesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UGFja2FnZXNSZXNwb25zZRI6CghwYWNrYWdlcxgBIAMoCzIeLmhlYWx0aGNhcmUuYm'
    'lsbGluZy52MS5QYWNrYWdlUghwYWNrYWdlcw==');

@$core.Deprecated('Use setBillingPolicyRequestDescriptor instead')
const SetBillingPolicyRequest$json = {
  '1': 'SetBillingPolicyRequest',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.BillingPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `SetBillingPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBillingPolicyRequestDescriptor =
    $convert.base64Decode(
        'ChdTZXRCaWxsaW5nUG9saWN5UmVxdWVzdBI8CgZwb2xpY3kYASABKAsyJC5oZWFsdGhjYXJlLm'
        'JpbGxpbmcudjEuQmlsbGluZ1BvbGljeVIGcG9saWN5');

@$core.Deprecated('Use setBillingPolicyResponseDescriptor instead')
const SetBillingPolicyResponse$json = {
  '1': 'SetBillingPolicyResponse',
};

/// Descriptor for `SetBillingPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBillingPolicyResponseDescriptor =
    $convert.base64Decode('ChhTZXRCaWxsaW5nUG9saWN5UmVzcG9uc2U=');

@$core.Deprecated('Use getBillingPolicyRequestDescriptor instead')
const GetBillingPolicyRequest$json = {
  '1': 'GetBillingPolicyRequest',
};

/// Descriptor for `GetBillingPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBillingPolicyRequestDescriptor =
    $convert.base64Decode('ChdHZXRCaWxsaW5nUG9saWN5UmVxdWVzdA==');

@$core.Deprecated('Use getBillingPolicyResponseDescriptor instead')
const GetBillingPolicyResponse$json = {
  '1': 'GetBillingPolicyResponse',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.billing.v1.BillingPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `GetBillingPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBillingPolicyResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRCaWxsaW5nUG9saWN5UmVzcG9uc2USPAoGcG9saWN5GAEgASgLMiQuaGVhbHRoY2FyZS'
        '5iaWxsaW5nLnYxLkJpbGxpbmdQb2xpY3lSBnBvbGljeQ==');

const $core.Map<$core.String, $core.dynamic> BillingServiceBase$json = {
  '1': 'BillingService',
  '2': [
    {
      '1': 'OpenAccount',
      '2': '.healthcare.billing.v1.OpenAccountRequest',
      '3': '.healthcare.billing.v1.OpenAccountResponse'
    },
    {
      '1': 'GetAccount',
      '2': '.healthcare.billing.v1.GetAccountRequest',
      '3': '.healthcare.billing.v1.GetAccountResponse'
    },
    {
      '1': 'PostCharge',
      '2': '.healthcare.billing.v1.PostChargeRequest',
      '3': '.healthcare.billing.v1.PostChargeResponse'
    },
    {
      '1': 'VoidCharge',
      '2': '.healthcare.billing.v1.VoidChargeRequest',
      '3': '.healthcare.billing.v1.VoidChargeResponse'
    },
    {
      '1': 'HoldCharge',
      '2': '.healthcare.billing.v1.HoldChargeRequest',
      '3': '.healthcare.billing.v1.HoldChargeResponse'
    },
    {
      '1': 'ReleaseCharge',
      '2': '.healthcare.billing.v1.ReleaseChargeRequest',
      '3': '.healthcare.billing.v1.ReleaseChargeResponse'
    },
    {
      '1': 'ListCharges',
      '2': '.healthcare.billing.v1.ListChargesRequest',
      '3': '.healthcare.billing.v1.ListChargesResponse'
    },
    {
      '1': 'PackageLedger',
      '2': '.healthcare.billing.v1.PackageLedgerRequest',
      '3': '.healthcare.billing.v1.PackageLedgerResponse'
    },
    {
      '1': 'RaiseInvoice',
      '2': '.healthcare.billing.v1.RaiseInvoiceRequest',
      '3': '.healthcare.billing.v1.RaiseInvoiceResponse'
    },
    {
      '1': 'CorrectInvoice',
      '2': '.healthcare.billing.v1.CorrectInvoiceRequest',
      '3': '.healthcare.billing.v1.CorrectInvoiceResponse'
    },
    {
      '1': 'GetInvoice',
      '2': '.healthcare.billing.v1.GetInvoiceRequest',
      '3': '.healthcare.billing.v1.GetInvoiceResponse'
    },
    {
      '1': 'ListInvoices',
      '2': '.healthcare.billing.v1.ListInvoicesRequest',
      '3': '.healthcare.billing.v1.ListInvoicesResponse'
    },
    {
      '1': 'ReceivePayment',
      '2': '.healthcare.billing.v1.ReceivePaymentRequest',
      '3': '.healthcare.billing.v1.ReceivePaymentResponse'
    },
    {
      '1': 'Refund',
      '2': '.healthcare.billing.v1.RefundRequest',
      '3': '.healthcare.billing.v1.RefundResponse'
    },
    {
      '1': 'Statement',
      '2': '.healthcare.billing.v1.StatementRequest',
      '3': '.healthcare.billing.v1.StatementResponse'
    },
    {
      '1': 'CloseAccount',
      '2': '.healthcare.billing.v1.CloseAccountRequest',
      '3': '.healthcare.billing.v1.CloseAccountResponse'
    },
    {
      '1': 'CloseReadiness',
      '2': '.healthcare.billing.v1.CloseReadinessRequest',
      '3': '.healthcare.billing.v1.CloseReadinessResponse'
    },
    {
      '1': 'RevenueIntegrity',
      '2': '.healthcare.billing.v1.RevenueIntegrityRequest',
      '3': '.healthcare.billing.v1.RevenueIntegrityResponse'
    },
    {
      '1': 'OpenShift',
      '2': '.healthcare.billing.v1.OpenShiftRequest',
      '3': '.healthcare.billing.v1.OpenShiftResponse'
    },
    {
      '1': 'CloseShift',
      '2': '.healthcare.billing.v1.CloseShiftRequest',
      '3': '.healthcare.billing.v1.CloseShiftResponse'
    },
    {
      '1': 'ApproveShift',
      '2': '.healthcare.billing.v1.ApproveShiftRequest',
      '3': '.healthcare.billing.v1.ApproveShiftResponse'
    },
    {
      '1': 'ListShifts',
      '2': '.healthcare.billing.v1.ListShiftsRequest',
      '3': '.healthcare.billing.v1.ListShiftsResponse'
    },
    {
      '1': 'PublishService',
      '2': '.healthcare.billing.v1.PublishServiceRequest',
      '3': '.healthcare.billing.v1.PublishServiceResponse'
    },
    {
      '1': 'ListServices',
      '2': '.healthcare.billing.v1.ListServicesRequest',
      '3': '.healthcare.billing.v1.ListServicesResponse'
    },
    {
      '1': 'PublishTariff',
      '2': '.healthcare.billing.v1.PublishTariffRequest',
      '3': '.healthcare.billing.v1.PublishTariffResponse'
    },
    {
      '1': 'ListTariffs',
      '2': '.healthcare.billing.v1.ListTariffsRequest',
      '3': '.healthcare.billing.v1.ListTariffsResponse'
    },
    {
      '1': 'Quote',
      '2': '.healthcare.billing.v1.QuoteRequest',
      '3': '.healthcare.billing.v1.QuoteResponse'
    },
    {
      '1': 'PublishPackage',
      '2': '.healthcare.billing.v1.PublishPackageRequest',
      '3': '.healthcare.billing.v1.PublishPackageResponse'
    },
    {
      '1': 'ListPackages',
      '2': '.healthcare.billing.v1.ListPackagesRequest',
      '3': '.healthcare.billing.v1.ListPackagesResponse'
    },
    {
      '1': 'SetBillingPolicy',
      '2': '.healthcare.billing.v1.SetBillingPolicyRequest',
      '3': '.healthcare.billing.v1.SetBillingPolicyResponse'
    },
    {
      '1': 'GetBillingPolicy',
      '2': '.healthcare.billing.v1.GetBillingPolicyRequest',
      '3': '.healthcare.billing.v1.GetBillingPolicyResponse'
    },
  ],
};

@$core.Deprecated('Use billingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BillingServiceBase$messageJson = {
  '.healthcare.billing.v1.OpenAccountRequest': OpenAccountRequest$json,
  '.healthcare.billing.v1.OpenAccountResponse': OpenAccountResponse$json,
  '.healthcare.billing.v1.Account': Account$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.billing.v1.GetAccountRequest': GetAccountRequest$json,
  '.healthcare.billing.v1.GetAccountResponse': GetAccountResponse$json,
  '.healthcare.billing.v1.PostChargeRequest': PostChargeRequest$json,
  '.healthcare.billing.v1.SourceReference': SourceReference$json,
  '.healthcare.billing.v1.PostChargeResponse': PostChargeResponse$json,
  '.healthcare.billing.v1.Charge': Charge$json,
  '.healthcare.billing.v1.Money': Money$json,
  '.healthcare.billing.v1.PricingResult': PricingResult$json,
  '.healthcare.billing.v1.TariffScope': TariffScope$json,
  '.healthcare.billing.v1.Consumption': Consumption$json,
  '.healthcare.billing.v1.VoidChargeRequest': VoidChargeRequest$json,
  '.healthcare.billing.v1.ChangeChargeRequest': ChangeChargeRequest$json,
  '.healthcare.billing.v1.VoidChargeResponse': VoidChargeResponse$json,
  '.healthcare.billing.v1.HoldChargeRequest': HoldChargeRequest$json,
  '.healthcare.billing.v1.HoldChargeResponse': HoldChargeResponse$json,
  '.healthcare.billing.v1.ReleaseChargeRequest': ReleaseChargeRequest$json,
  '.healthcare.billing.v1.ReleaseChargeResponse': ReleaseChargeResponse$json,
  '.healthcare.billing.v1.ListChargesRequest': ListChargesRequest$json,
  '.healthcare.billing.v1.ListChargesResponse': ListChargesResponse$json,
  '.healthcare.billing.v1.PackageLedgerRequest': PackageLedgerRequest$json,
  '.healthcare.billing.v1.PackageLedgerResponse': PackageLedgerResponse$json,
  '.healthcare.billing.v1.RaiseInvoiceRequest': RaiseInvoiceRequest$json,
  '.healthcare.billing.v1.Discount': Discount$json,
  '.healthcare.billing.v1.LiabilityShare': LiabilityShare$json,
  '.healthcare.billing.v1.RaiseInvoiceResponse': RaiseInvoiceResponse$json,
  '.healthcare.billing.v1.Invoice': Invoice$json,
  '.healthcare.billing.v1.InvoiceLine': InvoiceLine$json,
  '.healthcare.billing.v1.CorrectInvoiceRequest': CorrectInvoiceRequest$json,
  '.healthcare.billing.v1.CorrectInvoiceResponse': CorrectInvoiceResponse$json,
  '.healthcare.billing.v1.GetInvoiceRequest': GetInvoiceRequest$json,
  '.healthcare.billing.v1.GetInvoiceResponse': GetInvoiceResponse$json,
  '.healthcare.billing.v1.ListInvoicesRequest': ListInvoicesRequest$json,
  '.healthcare.billing.v1.ListInvoicesResponse': ListInvoicesResponse$json,
  '.healthcare.billing.v1.ReceivePaymentRequest': ReceivePaymentRequest$json,
  '.healthcare.billing.v1.ReceivePaymentResponse': ReceivePaymentResponse$json,
  '.healthcare.billing.v1.LedgerEntry': LedgerEntry$json,
  '.healthcare.billing.v1.RefundRequest': RefundRequest$json,
  '.healthcare.billing.v1.RefundResponse': RefundResponse$json,
  '.healthcare.billing.v1.StatementRequest': StatementRequest$json,
  '.healthcare.billing.v1.StatementResponse': StatementResponse$json,
  '.healthcare.billing.v1.CloseAccountRequest': CloseAccountRequest$json,
  '.healthcare.billing.v1.CloseAccountResponse': CloseAccountResponse$json,
  '.healthcare.billing.v1.CloseException': CloseException$json,
  '.healthcare.billing.v1.CloseReadinessRequest': CloseReadinessRequest$json,
  '.healthcare.billing.v1.CloseReadinessResponse': CloseReadinessResponse$json,
  '.healthcare.billing.v1.RevenueIntegrityRequest':
      RevenueIntegrityRequest$json,
  '.healthcare.billing.v1.BillableEvent': BillableEvent$json,
  '.healthcare.billing.v1.RevenueIntegrityResponse':
      RevenueIntegrityResponse$json,
  '.healthcare.billing.v1.RevenueException': RevenueException$json,
  '.healthcare.billing.v1.OpenShiftRequest': OpenShiftRequest$json,
  '.healthcare.billing.v1.OpenShiftResponse': OpenShiftResponse$json,
  '.healthcare.billing.v1.Shift': Shift$json,
  '.healthcare.billing.v1.CloseShiftRequest': CloseShiftRequest$json,
  '.healthcare.billing.v1.CloseShiftResponse': CloseShiftResponse$json,
  '.healthcare.billing.v1.ApproveShiftRequest': ApproveShiftRequest$json,
  '.healthcare.billing.v1.ApproveShiftResponse': ApproveShiftResponse$json,
  '.healthcare.billing.v1.ListShiftsRequest': ListShiftsRequest$json,
  '.healthcare.billing.v1.ListShiftsResponse': ListShiftsResponse$json,
  '.healthcare.billing.v1.PublishServiceRequest': PublishServiceRequest$json,
  '.healthcare.billing.v1.ServiceItem': ServiceItem$json,
  '.healthcare.billing.v1.PublishServiceResponse': PublishServiceResponse$json,
  '.healthcare.billing.v1.ListServicesRequest': ListServicesRequest$json,
  '.healthcare.billing.v1.ListServicesResponse': ListServicesResponse$json,
  '.healthcare.billing.v1.PublishTariffRequest': PublishTariffRequest$json,
  '.healthcare.billing.v1.TariffLine': TariffLine$json,
  '.healthcare.billing.v1.PublishTariffResponse': PublishTariffResponse$json,
  '.healthcare.billing.v1.ListTariffsRequest': ListTariffsRequest$json,
  '.healthcare.billing.v1.ListTariffsResponse': ListTariffsResponse$json,
  '.healthcare.billing.v1.QuoteRequest': QuoteRequest$json,
  '.healthcare.billing.v1.QuoteResponse': QuoteResponse$json,
  '.healthcare.billing.v1.PublishPackageRequest': PublishPackageRequest$json,
  '.healthcare.billing.v1.Package': Package$json,
  '.healthcare.billing.v1.PackageInclusion': PackageInclusion$json,
  '.healthcare.billing.v1.PackageCarveOut': PackageCarveOut$json,
  '.healthcare.billing.v1.PublishPackageResponse': PublishPackageResponse$json,
  '.healthcare.billing.v1.ListPackagesRequest': ListPackagesRequest$json,
  '.healthcare.billing.v1.ListPackagesResponse': ListPackagesResponse$json,
  '.healthcare.billing.v1.SetBillingPolicyRequest':
      SetBillingPolicyRequest$json,
  '.healthcare.billing.v1.BillingPolicy': BillingPolicy$json,
  '.healthcare.billing.v1.BillingPolicy.DiscountLimitsEntry':
      BillingPolicy_DiscountLimitsEntry$json,
  '.healthcare.billing.v1.DiscountLimit': DiscountLimit$json,
  '.healthcare.billing.v1.SetBillingPolicyResponse':
      SetBillingPolicyResponse$json,
  '.healthcare.billing.v1.GetBillingPolicyRequest':
      GetBillingPolicyRequest$json,
  '.healthcare.billing.v1.GetBillingPolicyResponse':
      GetBillingPolicyResponse$json,
};

/// Descriptor for `BillingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List billingServiceDescriptor = $convert.base64Decode(
    'Cg5CaWxsaW5nU2VydmljZRJkCgtPcGVuQWNjb3VudBIpLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5PcGVuQWNjb3VudFJlcXVlc3QaKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuT3BlbkFjY291bnRS'
    'ZXNwb25zZRJhCgpHZXRBY2NvdW50EiguaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkdldEFjY291bn'
    'RSZXF1ZXN0GikuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkdldEFjY291bnRSZXNwb25zZRJhCgpQ'
    'b3N0Q2hhcmdlEiguaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlBvc3RDaGFyZ2VSZXF1ZXN0GikuaG'
    'VhbHRoY2FyZS5iaWxsaW5nLnYxLlBvc3RDaGFyZ2VSZXNwb25zZRJhCgpWb2lkQ2hhcmdlEigu'
    'aGVhbHRoY2FyZS5iaWxsaW5nLnYxLlZvaWRDaGFyZ2VSZXF1ZXN0GikuaGVhbHRoY2FyZS5iaW'
    'xsaW5nLnYxLlZvaWRDaGFyZ2VSZXNwb25zZRJhCgpIb2xkQ2hhcmdlEiguaGVhbHRoY2FyZS5i'
    'aWxsaW5nLnYxLkhvbGRDaGFyZ2VSZXF1ZXN0GikuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkhvbG'
    'RDaGFyZ2VSZXNwb25zZRJqCg1SZWxlYXNlQ2hhcmdlEisuaGVhbHRoY2FyZS5iaWxsaW5nLnYx'
    'LlJlbGVhc2VDaGFyZ2VSZXF1ZXN0GiwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlJlbGVhc2VDaG'
    'FyZ2VSZXNwb25zZRJkCgtMaXN0Q2hhcmdlcxIpLmhlYWx0aGNhcmUuYmlsbGluZy52MS5MaXN0'
    'Q2hhcmdlc1JlcXVlc3QaKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTGlzdENoYXJnZXNSZXNwb2'
    '5zZRJqCg1QYWNrYWdlTGVkZ2VyEisuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlBhY2thZ2VMZWRn'
    'ZXJSZXF1ZXN0GiwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlBhY2thZ2VMZWRnZXJSZXNwb25zZR'
    'JnCgxSYWlzZUludm9pY2USKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuUmFpc2VJbnZvaWNlUmVx'
    'dWVzdBorLmhlYWx0aGNhcmUuYmlsbGluZy52MS5SYWlzZUludm9pY2VSZXNwb25zZRJtCg5Db3'
    'JyZWN0SW52b2ljZRIsLmhlYWx0aGNhcmUuYmlsbGluZy52MS5Db3JyZWN0SW52b2ljZVJlcXVl'
    'c3QaLS5oZWFsdGhjYXJlLmJpbGxpbmcudjEuQ29ycmVjdEludm9pY2VSZXNwb25zZRJhCgpHZX'
    'RJbnZvaWNlEiguaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkdldEludm9pY2VSZXF1ZXN0GikuaGVh'
    'bHRoY2FyZS5iaWxsaW5nLnYxLkdldEludm9pY2VSZXNwb25zZRJnCgxMaXN0SW52b2ljZXMSKi'
    '5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTGlzdEludm9pY2VzUmVxdWVzdBorLmhlYWx0aGNhcmUu'
    'YmlsbGluZy52MS5MaXN0SW52b2ljZXNSZXNwb25zZRJtCg5SZWNlaXZlUGF5bWVudBIsLmhlYW'
    'x0aGNhcmUuYmlsbGluZy52MS5SZWNlaXZlUGF5bWVudFJlcXVlc3QaLS5oZWFsdGhjYXJlLmJp'
    'bGxpbmcudjEuUmVjZWl2ZVBheW1lbnRSZXNwb25zZRJVCgZSZWZ1bmQSJC5oZWFsdGhjYXJlLm'
    'JpbGxpbmcudjEuUmVmdW5kUmVxdWVzdBolLmhlYWx0aGNhcmUuYmlsbGluZy52MS5SZWZ1bmRS'
    'ZXNwb25zZRJeCglTdGF0ZW1lbnQSJy5oZWFsdGhjYXJlLmJpbGxpbmcudjEuU3RhdGVtZW50Um'
    'VxdWVzdBooLmhlYWx0aGNhcmUuYmlsbGluZy52MS5TdGF0ZW1lbnRSZXNwb25zZRJnCgxDbG9z'
    'ZUFjY291bnQSKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuQ2xvc2VBY2NvdW50UmVxdWVzdBorLm'
    'hlYWx0aGNhcmUuYmlsbGluZy52MS5DbG9zZUFjY291bnRSZXNwb25zZRJtCg5DbG9zZVJlYWRp'
    'bmVzcxIsLmhlYWx0aGNhcmUuYmlsbGluZy52MS5DbG9zZVJlYWRpbmVzc1JlcXVlc3QaLS5oZW'
    'FsdGhjYXJlLmJpbGxpbmcudjEuQ2xvc2VSZWFkaW5lc3NSZXNwb25zZRJzChBSZXZlbnVlSW50'
    'ZWdyaXR5Ei4uaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlJldmVudWVJbnRlZ3JpdHlSZXF1ZXN0Gi'
    '8uaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlJldmVudWVJbnRlZ3JpdHlSZXNwb25zZRJeCglPcGVu'
    'U2hpZnQSJy5oZWFsdGhjYXJlLmJpbGxpbmcudjEuT3BlblNoaWZ0UmVxdWVzdBooLmhlYWx0aG'
    'NhcmUuYmlsbGluZy52MS5PcGVuU2hpZnRSZXNwb25zZRJhCgpDbG9zZVNoaWZ0EiguaGVhbHRo'
    'Y2FyZS5iaWxsaW5nLnYxLkNsb3NlU2hpZnRSZXF1ZXN0GikuaGVhbHRoY2FyZS5iaWxsaW5nLn'
    'YxLkNsb3NlU2hpZnRSZXNwb25zZRJnCgxBcHByb3ZlU2hpZnQSKi5oZWFsdGhjYXJlLmJpbGxp'
    'bmcudjEuQXBwcm92ZVNoaWZ0UmVxdWVzdBorLmhlYWx0aGNhcmUuYmlsbGluZy52MS5BcHByb3'
    'ZlU2hpZnRSZXNwb25zZRJhCgpMaXN0U2hpZnRzEiguaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkxp'
    'c3RTaGlmdHNSZXF1ZXN0GikuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkxpc3RTaGlmdHNSZXNwb2'
    '5zZRJtCg5QdWJsaXNoU2VydmljZRIsLmhlYWx0aGNhcmUuYmlsbGluZy52MS5QdWJsaXNoU2Vy'
    'dmljZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpbGxpbmcudjEuUHVibGlzaFNlcnZpY2VSZXNwb2'
    '5zZRJnCgxMaXN0U2VydmljZXMSKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTGlzdFNlcnZpY2Vz'
    'UmVxdWVzdBorLmhlYWx0aGNhcmUuYmlsbGluZy52MS5MaXN0U2VydmljZXNSZXNwb25zZRJqCg'
    '1QdWJsaXNoVGFyaWZmEisuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlB1Ymxpc2hUYXJpZmZSZXF1'
    'ZXN0GiwuaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlB1Ymxpc2hUYXJpZmZSZXNwb25zZRJkCgtMaX'
    'N0VGFyaWZmcxIpLmhlYWx0aGNhcmUuYmlsbGluZy52MS5MaXN0VGFyaWZmc1JlcXVlc3QaKi5o'
    'ZWFsdGhjYXJlLmJpbGxpbmcudjEuTGlzdFRhcmlmZnNSZXNwb25zZRJSCgVRdW90ZRIjLmhlYW'
    'x0aGNhcmUuYmlsbGluZy52MS5RdW90ZVJlcXVlc3QaJC5oZWFsdGhjYXJlLmJpbGxpbmcudjEu'
    'UXVvdGVSZXNwb25zZRJtCg5QdWJsaXNoUGFja2FnZRIsLmhlYWx0aGNhcmUuYmlsbGluZy52MS'
    '5QdWJsaXNoUGFja2FnZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpbGxpbmcudjEuUHVibGlzaFBh'
    'Y2thZ2VSZXNwb25zZRJnCgxMaXN0UGFja2FnZXMSKi5oZWFsdGhjYXJlLmJpbGxpbmcudjEuTG'
    'lzdFBhY2thZ2VzUmVxdWVzdBorLmhlYWx0aGNhcmUuYmlsbGluZy52MS5MaXN0UGFja2FnZXNS'
    'ZXNwb25zZRJzChBTZXRCaWxsaW5nUG9saWN5Ei4uaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlNldE'
    'JpbGxpbmdQb2xpY3lSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaWxsaW5nLnYxLlNldEJpbGxpbmdQ'
    'b2xpY3lSZXNwb25zZRJzChBHZXRCaWxsaW5nUG9saWN5Ei4uaGVhbHRoY2FyZS5iaWxsaW5nLn'
    'YxLkdldEJpbGxpbmdQb2xpY3lSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaWxsaW5nLnYxLkdldEJp'
    'bGxpbmdQb2xpY3lSZXNwb25zZQ==');
