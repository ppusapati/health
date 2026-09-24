// This is a generated file - do not edit.
//
// Generated from healthcare/bloodbank/v1/bloodbank.proto.

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

@$core.Deprecated('Use aboDescriptor instead')
const Abo$json = {
  '1': 'Abo',
  '2': [
    {'1': 'ABO_UNSPECIFIED', '2': 0},
    {'1': 'ABO_A', '2': 1},
    {'1': 'ABO_B', '2': 2},
    {'1': 'ABO_AB', '2': 3},
    {'1': 'ABO_O', '2': 4},
  ],
};

/// Descriptor for `Abo`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List aboDescriptor = $convert.base64Decode(
    'CgNBYm8SEwoPQUJPX1VOU1BFQ0lGSUVEEAASCQoFQUJPX0EQARIJCgVBQk9fQhACEgoKBkFCT1'
    '9BQhADEgkKBUFCT19PEAQ=');

@$core.Deprecated('Use rhDDescriptor instead')
const RhD$json = {
  '1': 'RhD',
  '2': [
    {'1': 'RH_D_UNSPECIFIED', '2': 0},
    {'1': 'RH_D_POSITIVE', '2': 1},
    {'1': 'RH_D_NEGATIVE', '2': 2},
  ],
};

/// Descriptor for `RhD`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rhDDescriptor = $convert.base64Decode(
    'CgNSaEQSFAoQUkhfRF9VTlNQRUNJRklFRBAAEhEKDVJIX0RfUE9TSVRJVkUQARIRCg1SSF9EX0'
    '5FR0FUSVZFEAI=');

@$core.Deprecated('Use componentClassDescriptor instead')
const ComponentClass$json = {
  '1': 'ComponentClass',
  '2': [
    {'1': 'COMPONENT_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'COMPONENT_CLASS_RED_CELLS', '2': 1},
    {'1': 'COMPONENT_CLASS_PLASMA', '2': 2},
    {'1': 'COMPONENT_CLASS_PLATELETS', '2': 3},
    {'1': 'COMPONENT_CLASS_CRYOPRECIPITATE', '2': 4},
    {'1': 'COMPONENT_CLASS_WHOLE_BLOOD', '2': 5},
  ],
};

/// Descriptor for `ComponentClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List componentClassDescriptor = $convert.base64Decode(
    'Cg5Db21wb25lbnRDbGFzcxIfChtDT01QT05FTlRfQ0xBU1NfVU5TUEVDSUZJRUQQABIdChlDT0'
    '1QT05FTlRfQ0xBU1NfUkVEX0NFTExTEAESGgoWQ09NUE9ORU5UX0NMQVNTX1BMQVNNQRACEh0K'
    'GUNPTVBPTkVOVF9DTEFTU19QTEFURUxFVFMQAxIjCh9DT01QT05FTlRfQ0xBU1NfQ1JZT1BSRU'
    'NJUElUQVRFEAQSHwobQ09NUE9ORU5UX0NMQVNTX1dIT0xFX0JMT09EEAU=');

@$core.Deprecated('Use unitStatusDescriptor instead')
const UnitStatus$json = {
  '1': 'UnitStatus',
  '2': [
    {'1': 'UNIT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'UNIT_STATUS_QUARANTINED', '2': 1},
    {'1': 'UNIT_STATUS_AVAILABLE', '2': 2},
    {'1': 'UNIT_STATUS_RESERVED', '2': 3},
    {'1': 'UNIT_STATUS_ISSUED', '2': 4},
    {'1': 'UNIT_STATUS_TRANSFUSED', '2': 5},
    {'1': 'UNIT_STATUS_DISCARDED', '2': 6},
    {'1': 'UNIT_STATUS_UNSUITABLE', '2': 7},
  ],
};

/// Descriptor for `UnitStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List unitStatusDescriptor = $convert.base64Decode(
    'CgpVbml0U3RhdHVzEhsKF1VOSVRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGwoXVU5JVF9TVEFUVV'
    'NfUVVBUkFOVElORUQQARIZChVVTklUX1NUQVRVU19BVkFJTEFCTEUQAhIYChRVTklUX1NUQVRV'
    'U19SRVNFUlZFRBADEhYKElVOSVRfU1RBVFVTX0lTU1VFRBAEEhoKFlVOSVRfU1RBVFVTX1RSQU'
    '5TRlVTRUQQBRIZChVVTklUX1NUQVRVU19ESVNDQVJERUQQBhIaChZVTklUX1NUQVRVU19VTlNV'
    'SVRBQkxFEAc=');

@$core.Deprecated('Use discardReasonDescriptor instead')
const DiscardReason$json = {
  '1': 'DiscardReason',
  '2': [
    {'1': 'DISCARD_REASON_UNSPECIFIED', '2': 0},
    {'1': 'DISCARD_REASON_EXPIRED', '2': 1},
    {'1': 'DISCARD_REASON_TEST_FAILED', '2': 2},
    {'1': 'DISCARD_REASON_TEMPERATURE_BREACH', '2': 3},
    {'1': 'DISCARD_REASON_OUT_OF_TIME', '2': 4},
    {'1': 'DISCARD_REASON_DAMAGED', '2': 5},
    {'1': 'DISCARD_REASON_RECALLED', '2': 6},
    {'1': 'DISCARD_REASON_REACTION_INVESTIGATION', '2': 7},
  ],
};

/// Descriptor for `DiscardReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List discardReasonDescriptor = $convert.base64Decode(
    'Cg1EaXNjYXJkUmVhc29uEh4KGkRJU0NBUkRfUkVBU09OX1VOU1BFQ0lGSUVEEAASGgoWRElTQ0'
    'FSRF9SRUFTT05fRVhQSVJFRBABEh4KGkRJU0NBUkRfUkVBU09OX1RFU1RfRkFJTEVEEAISJQoh'
    'RElTQ0FSRF9SRUFTT05fVEVNUEVSQVRVUkVfQlJFQUNIEAMSHgoaRElTQ0FSRF9SRUFTT05fT1'
    'VUX09GX1RJTUUQBBIaChZESVNDQVJEX1JFQVNPTl9EQU1BR0VEEAUSGwoXRElTQ0FSRF9SRUFT'
    'T05fUkVDQUxMRUQQBhIpCiVESVNDQVJEX1JFQVNPTl9SRUFDVElPTl9JTlZFU1RJR0FUSU9OEA'
    'c=');

@$core.Deprecated('Use deferralKindDescriptor instead')
const DeferralKind$json = {
  '1': 'DeferralKind',
  '2': [
    {'1': 'DEFERRAL_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DEFERRAL_KIND_TEMPORARY', '2': 1},
    {'1': 'DEFERRAL_KIND_PERMANENT', '2': 2},
  ],
};

/// Descriptor for `DeferralKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deferralKindDescriptor = $convert.base64Decode(
    'CgxEZWZlcnJhbEtpbmQSHQoZREVGRVJSQUxfS0lORF9VTlNQRUNJRklFRBAAEhsKF0RFRkVSUk'
    'FMX0tJTkRfVEVNUE9SQVJZEAESGwoXREVGRVJSQUxfS0lORF9QRVJNQU5FTlQQAg==');

@$core.Deprecated('Use requestUrgencyDescriptor instead')
const RequestUrgency$json = {
  '1': 'RequestUrgency',
  '2': [
    {'1': 'REQUEST_URGENCY_UNSPECIFIED', '2': 0},
    {'1': 'REQUEST_URGENCY_ROUTINE', '2': 1},
    {'1': 'REQUEST_URGENCY_URGENT', '2': 2},
    {'1': 'REQUEST_URGENCY_EMERGENCY', '2': 3},
  ],
};

/// Descriptor for `RequestUrgency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requestUrgencyDescriptor = $convert.base64Decode(
    'Cg5SZXF1ZXN0VXJnZW5jeRIfChtSRVFVRVNUX1VSR0VOQ1lfVU5TUEVDSUZJRUQQABIbChdSRV'
    'FVRVNUX1VSR0VOQ1lfUk9VVElORRABEhoKFlJFUVVFU1RfVVJHRU5DWV9VUkdFTlQQAhIdChlS'
    'RVFVRVNUX1VSR0VOQ1lfRU1FUkdFTkNZEAM=');

@$core.Deprecated('Use requestStatusDescriptor instead')
const RequestStatus$json = {
  '1': 'RequestStatus',
  '2': [
    {'1': 'REQUEST_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REQUEST_STATUS_OPEN', '2': 1},
    {'1': 'REQUEST_STATUS_FULFILLED', '2': 2},
    {'1': 'REQUEST_STATUS_CANCELLED', '2': 3},
  ],
};

/// Descriptor for `RequestStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requestStatusDescriptor = $convert.base64Decode(
    'Cg1SZXF1ZXN0U3RhdHVzEh4KGlJFUVVFU1RfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTUkVRVU'
    'VTVF9TVEFUVVNfT1BFThABEhwKGFJFUVVFU1RfU1RBVFVTX0ZVTEZJTExFRBACEhwKGFJFUVVF'
    'U1RfU1RBVFVTX0NBTkNFTExFRBAD');

@$core.Deprecated('Use matchRefusalDescriptor instead')
const MatchRefusal$json = {
  '1': 'MatchRefusal',
  '2': [
    {'1': 'MATCH_REFUSAL_UNSPECIFIED', '2': 0},
    {'1': 'MATCH_REFUSAL_UNIT_NOT_ALLOCATABLE', '2': 1},
    {'1': 'MATCH_REFUSAL_UNIT_EXPIRED', '2': 2},
    {'1': 'MATCH_REFUSAL_NO_VALID_SAMPLE', '2': 3},
    {'1': 'MATCH_REFUSAL_GROUP_INCOMPATIBLE', '2': 4},
    {'1': 'MATCH_REFUSAL_WRONG_COMPONENT_TYPE', '2': 5},
    {'1': 'MATCH_REFUSAL_MISSING_SPECIAL_REQUIREMENT', '2': 6},
    {'1': 'MATCH_REFUSAL_CROSSMATCH_REACTIVE', '2': 7},
  ],
};

/// Descriptor for `MatchRefusal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List matchRefusalDescriptor = $convert.base64Decode(
    'CgxNYXRjaFJlZnVzYWwSHQoZTUFUQ0hfUkVGVVNBTF9VTlNQRUNJRklFRBAAEiYKIk1BVENIX1'
    'JFRlVTQUxfVU5JVF9OT1RfQUxMT0NBVEFCTEUQARIeChpNQVRDSF9SRUZVU0FMX1VOSVRfRVhQ'
    'SVJFRBACEiEKHU1BVENIX1JFRlVTQUxfTk9fVkFMSURfU0FNUExFEAMSJAogTUFUQ0hfUkVGVV'
    'NBTF9HUk9VUF9JTkNPTVBBVElCTEUQBBImCiJNQVRDSF9SRUZVU0FMX1dST05HX0NPTVBPTkVO'
    'VF9UWVBFEAUSLQopTUFUQ0hfUkVGVVNBTF9NSVNTSU5HX1NQRUNJQUxfUkVRVUlSRU1FTlQQBh'
    'IlCiFNQVRDSF9SRUZVU0FMX0NST1NTTUFUQ0hfUkVBQ1RJVkUQBw==');

@$core.Deprecated('Use bedsideRefusalDescriptor instead')
const BedsideRefusal$json = {
  '1': 'BedsideRefusal',
  '2': [
    {'1': 'BEDSIDE_REFUSAL_UNSPECIFIED', '2': 0},
    {'1': 'BEDSIDE_REFUSAL_WRONG_UNIT', '2': 1},
    {'1': 'BEDSIDE_REFUSAL_WRONG_PATIENT', '2': 2},
    {'1': 'BEDSIDE_REFUSAL_GROUP_MISMATCH', '2': 3},
    {'1': 'BEDSIDE_REFUSAL_SOLO_CHECK', '2': 4},
    {'1': 'BEDSIDE_REFUSAL_UNIT_EXPIRED', '2': 5},
    {'1': 'BEDSIDE_REFUSAL_NOT_ISSUED', '2': 6},
  ],
};

/// Descriptor for `BedsideRefusal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bedsideRefusalDescriptor = $convert.base64Decode(
    'Cg5CZWRzaWRlUmVmdXNhbBIfChtCRURTSURFX1JFRlVTQUxfVU5TUEVDSUZJRUQQABIeChpCRU'
    'RTSURFX1JFRlVTQUxfV1JPTkdfVU5JVBABEiEKHUJFRFNJREVfUkVGVVNBTF9XUk9OR19QQVRJ'
    'RU5UEAISIgoeQkVEU0lERV9SRUZVU0FMX0dST1VQX01JU01BVENIEAMSHgoaQkVEU0lERV9SRU'
    'ZVU0FMX1NPTE9fQ0hFQ0sQBBIgChxCRURTSURFX1JFRlVTQUxfVU5JVF9FWFBJUkVEEAUSHgoa'
    'QkVEU0lERV9SRUZVU0FMX05PVF9JU1NVRUQQBg==');

@$core.Deprecated('Use episodeStatusDescriptor instead')
const EpisodeStatus$json = {
  '1': 'EpisodeStatus',
  '2': [
    {'1': 'EPISODE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'EPISODE_STATUS_RUNNING', '2': 1},
    {'1': 'EPISODE_STATUS_INTERRUPTED', '2': 2},
    {'1': 'EPISODE_STATUS_COMPLETED', '2': 3},
    {'1': 'EPISODE_STATUS_STOPPED', '2': 4},
  ],
};

/// Descriptor for `EpisodeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List episodeStatusDescriptor = $convert.base64Decode(
    'Cg1FcGlzb2RlU3RhdHVzEh4KGkVQSVNPREVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGgoWRVBJU0'
    '9ERV9TVEFUVVNfUlVOTklORxABEh4KGkVQSVNPREVfU1RBVFVTX0lOVEVSUlVQVEVEEAISHAoY'
    'RVBJU09ERV9TVEFUVVNfQ09NUExFVEVEEAMSGgoWRVBJU09ERV9TVEFUVVNfU1RPUFBFRBAE');

@$core.Deprecated('Use reactionSeverityDescriptor instead')
const ReactionSeverity$json = {
  '1': 'ReactionSeverity',
  '2': [
    {'1': 'REACTION_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'REACTION_SEVERITY_MILD', '2': 1},
    {'1': 'REACTION_SEVERITY_MODERATE', '2': 2},
    {'1': 'REACTION_SEVERITY_SEVERE', '2': 3},
    {'1': 'REACTION_SEVERITY_FATAL', '2': 4},
  ],
};

/// Descriptor for `ReactionSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reactionSeverityDescriptor = $convert.base64Decode(
    'ChBSZWFjdGlvblNldmVyaXR5EiEKHVJFQUNUSU9OX1NFVkVSSVRZX1VOU1BFQ0lGSUVEEAASGg'
    'oWUkVBQ1RJT05fU0VWRVJJVFlfTUlMRBABEh4KGlJFQUNUSU9OX1NFVkVSSVRZX01PREVSQVRF'
    'EAISHAoYUkVBQ1RJT05fU0VWRVJJVFlfU0VWRVJFEAMSGwoXUkVBQ1RJT05fU0VWRVJJVFlfRk'
    'FUQUwQBA==');

@$core.Deprecated('Use investigationStateDescriptor instead')
const InvestigationState$json = {
  '1': 'InvestigationState',
  '2': [
    {'1': 'INVESTIGATION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'INVESTIGATION_STATE_OPEN', '2': 1},
    {'1': 'INVESTIGATION_STATE_CONCLUDED', '2': 2},
  ],
};

/// Descriptor for `InvestigationState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List investigationStateDescriptor = $convert.base64Decode(
    'ChJJbnZlc3RpZ2F0aW9uU3RhdGUSIwofSU5WRVNUSUdBVElPTl9TVEFURV9VTlNQRUNJRklFRB'
    'AAEhwKGElOVkVTVElHQVRJT05fU1RBVEVfT1BFThABEiEKHUlOVkVTVElHQVRJT05fU1RBVEVf'
    'Q09OQ0xVREVEEAI=');

@$core.Deprecated('Use reservationStatusDescriptor instead')
const ReservationStatus$json = {
  '1': 'ReservationStatus',
  '2': [
    {'1': 'RESERVATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RESERVATION_STATUS_HELD', '2': 1},
    {'1': 'RESERVATION_STATUS_ISSUED', '2': 2},
    {'1': 'RESERVATION_STATUS_RELEASED', '2': 3},
    {'1': 'RESERVATION_STATUS_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `ReservationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reservationStatusDescriptor = $convert.base64Decode(
    'ChFSZXNlcnZhdGlvblN0YXR1cxIiCh5SRVNFUlZBVElPTl9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IbChdSRVNFUlZBVElPTl9TVEFUVVNfSEVMRBABEh0KGVJFU0VSVkFUSU9OX1NUQVRVU19JU1NV'
    'RUQQAhIfChtSRVNFUlZBVElPTl9TVEFUVVNfUkVMRUFTRUQQAxIeChpSRVNFUlZBVElPTl9TVE'
    'FUVVNfRVhQSVJFRBAE');

@$core.Deprecated('Use stockAlertKindDescriptor instead')
const StockAlertKind$json = {
  '1': 'StockAlertKind',
  '2': [
    {'1': 'STOCK_ALERT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'STOCK_ALERT_KIND_LOW_STOCK', '2': 1},
    {'1': 'STOCK_ALERT_KIND_EXPIRING', '2': 2},
  ],
};

/// Descriptor for `StockAlertKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stockAlertKindDescriptor = $convert.base64Decode(
    'Cg5TdG9ja0FsZXJ0S2luZBIgChxTVE9DS19BTEVSVF9LSU5EX1VOU1BFQ0lGSUVEEAASHgoaU1'
    'RPQ0tfQUxFUlRfS0lORF9MT1dfU1RPQ0sQARIdChlTVE9DS19BTEVSVF9LSU5EX0VYUElSSU5H'
    'EAI=');

@$core.Deprecated('Use bloodGroupDescriptor instead')
const BloodGroup$json = {
  '1': 'BloodGroup',
  '2': [
    {
      '1': 'abo',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.Abo',
      '10': 'abo'
    },
    {
      '1': 'rh_d',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.RhD',
      '10': 'rhD'
    },
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
  ],
};

/// Descriptor for `BloodGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bloodGroupDescriptor = $convert.base64Decode(
    'CgpCbG9vZEdyb3VwEi4KA2FibxgBIAEoDjIcLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkFib1'
    'IDYWJvEi8KBHJoX2QYAiABKA4yHC5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5SaERSA3JoRBIY'
    'CgdkaXNwbGF5GAMgASgJUgdkaXNwbGF5');

@$core.Deprecated('Use donorDescriptor instead')
const Donor$json = {
  '1': 'Donor',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'donor_number', '3': 2, '4': 1, '5': 9, '10': 'donorNumber'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'contact_phone', '3': 5, '4': 1, '5': 9, '10': 'contactPhone'},
    {
      '1': 'group',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {
      '1': 'deferral',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DeferralKind',
      '10': 'deferral'
    },
    {'1': 'deferral_code', '3': 8, '4': 1, '5': 9, '10': 'deferralCode'},
    {'1': 'deferral_note', '3': 9, '4': 1, '5': 9, '10': 'deferralNote'},
    {
      '1': 'deferred_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deferredAt'
    },
    {'1': 'deferred_by', '3': 11, '4': 1, '5': 9, '10': 'deferredBy'},
    {
      '1': 'deferred_until',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deferredUntil'
    },
    {
      '1': 'currently_deferred',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'currentlyDeferred'
    },
    {
      '1': 'registered_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'registeredAt'
    },
    {'1': 'registered_by', '3': 15, '4': 1, '5': 9, '10': 'registeredBy'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Donor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List donorDescriptor = $convert.base64Decode(
    'CgVEb25vchIZCghkb25vcl9pZBgBIAEoCVIHZG9ub3JJZBIhCgxkb25vcl9udW1iZXIYAiABKA'
    'lSC2Rvbm9yTnVtYmVyEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIhCgxkaXNwbGF5'
    'X25hbWUYBCABKAlSC2Rpc3BsYXlOYW1lEiMKDWNvbnRhY3RfcGhvbmUYBSABKAlSDGNvbnRhY3'
    'RQaG9uZRI5CgVncm91cBgGIAEoCzIjLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkJsb29kR3Jv'
    'dXBSBWdyb3VwEkEKCGRlZmVycmFsGAcgASgOMiUuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuRG'
    'VmZXJyYWxLaW5kUghkZWZlcnJhbBIjCg1kZWZlcnJhbF9jb2RlGAggASgJUgxkZWZlcnJhbENv'
    'ZGUSIwoNZGVmZXJyYWxfbm90ZRgJIAEoCVIMZGVmZXJyYWxOb3RlEjsKC2RlZmVycmVkX2F0GA'
    'ogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKZGVmZXJyZWRBdBIfCgtkZWZlcnJl'
    'ZF9ieRgLIAEoCVIKZGVmZXJyZWRCeRJBCg5kZWZlcnJlZF91bnRpbBgMIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSDWRlZmVycmVkVW50aWwSLQoSY3VycmVudGx5X2RlZmVycmVk'
    'GA0gASgIUhFjdXJyZW50bHlEZWZlcnJlZBI/Cg1yZWdpc3RlcmVkX2F0GA4gASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIMcmVnaXN0ZXJlZEF0EiMKDXJlZ2lzdGVyZWRfYnkYDyAB'
    'KAlSDHJlZ2lzdGVyZWRCeRIYCgd2ZXJzaW9uGBAgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use screeningDescriptor instead')
const Screening$json = {
  '1': 'Screening',
  '2': [
    {'1': 'screening_id', '3': 1, '4': 1, '5': 9, '10': 'screeningId'},
    {'1': 'donor_id', '3': 2, '4': 1, '5': 9, '10': 'donorId'},
    {
      '1': 'answers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Screening.AnswersEntry',
      '10': 'answers'
    },
    {
      '1': 'measurements',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Screening.MeasurementsEntry',
      '10': 'measurements'
    },
    {'1': 'consented', '3': 5, '4': 1, '5': 8, '10': 'consented'},
    {'1': 'consent_note', '3': 6, '4': 1, '5': 9, '10': 'consentNote'},
    {'1': 'accepted', '3': 7, '4': 1, '5': 8, '10': 'accepted'},
    {
      '1': 'deferral',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DeferralKind',
      '10': 'deferral'
    },
    {'1': 'deferral_code', '3': 9, '4': 1, '5': 9, '10': 'deferralCode'},
    {
      '1': 'screened_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'screenedAt'
    },
    {'1': 'screened_by', '3': 11, '4': 1, '5': 9, '10': 'screenedBy'},
  ],
  '3': [Screening_AnswersEntry$json, Screening_MeasurementsEntry$json],
};

@$core.Deprecated('Use screeningDescriptor instead')
const Screening_AnswersEntry$json = {
  '1': 'AnswersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use screeningDescriptor instead')
const Screening_MeasurementsEntry$json = {
  '1': 'MeasurementsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Screening`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screeningDescriptor = $convert.base64Decode(
    'CglTY3JlZW5pbmcSIQoMc2NyZWVuaW5nX2lkGAEgASgJUgtzY3JlZW5pbmdJZBIZCghkb25vcl'
    '9pZBgCIAEoCVIHZG9ub3JJZBJJCgdhbnN3ZXJzGAMgAygLMi8uaGVhbHRoY2FyZS5ibG9vZGJh'
    'bmsudjEuU2NyZWVuaW5nLkFuc3dlcnNFbnRyeVIHYW5zd2VycxJYCgxtZWFzdXJlbWVudHMYBC'
    'ADKAsyNC5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5TY3JlZW5pbmcuTWVhc3VyZW1lbnRzRW50'
    'cnlSDG1lYXN1cmVtZW50cxIcCgljb25zZW50ZWQYBSABKAhSCWNvbnNlbnRlZBIhCgxjb25zZW'
    '50X25vdGUYBiABKAlSC2NvbnNlbnROb3RlEhoKCGFjY2VwdGVkGAcgASgIUghhY2NlcHRlZBJB'
    'CghkZWZlcnJhbBgIIAEoDjIlLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkRlZmVycmFsS2luZF'
    'IIZGVmZXJyYWwSIwoNZGVmZXJyYWxfY29kZRgJIAEoCVIMZGVmZXJyYWxDb2RlEjsKC3NjcmVl'
    'bmVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKc2NyZWVuZWRBdBIfCg'
    'tzY3JlZW5lZF9ieRgLIAEoCVIKc2NyZWVuZWRCeRo6CgxBbnN3ZXJzRW50cnkSEAoDa2V5GAEg'
    'ASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4ARo/ChFNZWFzdXJlbWVudHNFbnRyeR'
    'IQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use collectionDescriptor instead')
const Collection$json = {
  '1': 'Collection',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'donor_id', '3': 2, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'screening_id', '3': 3, '4': 1, '5': 9, '10': 'screeningId'},
    {'1': 'donation_number', '3': 4, '4': 1, '5': 9, '10': 'donationNumber'},
    {'1': 'kind', '3': 5, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'volume_ml', '3': 6, '4': 1, '5': 5, '10': 'volumeMl'},
    {
      '1': 'group',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {
      '1': 'collected_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'collected_by', '3': 9, '4': 1, '5': 9, '10': 'collectedBy'},
    {'1': 'adverse_event', '3': 10, '4': 1, '5': 8, '10': 'adverseEvent'},
    {'1': 'adverse_note', '3': 11, '4': 1, '5': 9, '10': 'adverseNote'},
  ],
};

/// Descriptor for `Collection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectionDescriptor = $convert.base64Decode(
    'CgpDb2xsZWN0aW9uEiMKDWNvbGxlY3Rpb25faWQYASABKAlSDGNvbGxlY3Rpb25JZBIZCghkb2'
    '5vcl9pZBgCIAEoCVIHZG9ub3JJZBIhCgxzY3JlZW5pbmdfaWQYAyABKAlSC3NjcmVlbmluZ0lk'
    'EicKD2RvbmF0aW9uX251bWJlchgEIAEoCVIOZG9uYXRpb25OdW1iZXISEgoEa2luZBgFIAEoCV'
    'IEa2luZBIbCgl2b2x1bWVfbWwYBiABKAVSCHZvbHVtZU1sEjkKBWdyb3VwGAcgASgLMiMuaGVh'
    'bHRoY2FyZS5ibG9vZGJhbmsudjEuQmxvb2RHcm91cFIFZ3JvdXASPQoMY29sbGVjdGVkX2F0GA'
    'ggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29sbGVjdGVkQXQSIQoMY29sbGVj'
    'dGVkX2J5GAkgASgJUgtjb2xsZWN0ZWRCeRIjCg1hZHZlcnNlX2V2ZW50GAogASgIUgxhZHZlcn'
    'NlRXZlbnQSIQoMYWR2ZXJzZV9ub3RlGAsgASgJUgthZHZlcnNlTm90ZQ==');

@$core.Deprecated('Use testResultDescriptor instead')
const TestResult$json = {
  '1': 'TestResult',
  '2': [
    {'1': 'test_id', '3': 1, '4': 1, '5': 9, '10': 'testId'},
    {'1': 'collection_id', '3': 2, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 4, '4': 1, '5': 9, '10': 'display'},
    {'1': 'reactive', '3': 5, '4': 1, '5': 8, '10': 'reactive'},
    {'1': 'value', '3': 6, '4': 1, '5': 9, '10': 'value'},
    {'1': 'method', '3': 7, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'tested_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'testedAt'
    },
    {'1': 'tested_by', '3': 9, '4': 1, '5': 9, '10': 'testedBy'},
  ],
};

/// Descriptor for `TestResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List testResultDescriptor = $convert.base64Decode(
    'CgpUZXN0UmVzdWx0EhcKB3Rlc3RfaWQYASABKAlSBnRlc3RJZBIjCg1jb2xsZWN0aW9uX2lkGA'
    'IgASgJUgxjb2xsZWN0aW9uSWQSEgoEY29kZRgDIAEoCVIEY29kZRIYCgdkaXNwbGF5GAQgASgJ'
    'UgdkaXNwbGF5EhoKCHJlYWN0aXZlGAUgASgIUghyZWFjdGl2ZRIUCgV2YWx1ZRgGIAEoCVIFdm'
    'FsdWUSFgoGbWV0aG9kGAcgASgJUgZtZXRob2QSNwoJdGVzdGVkX2F0GAggASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIIdGVzdGVkQXQSGwoJdGVzdGVkX2J5GAkgASgJUgh0ZXN0ZW'
    'RCeQ==');

@$core.Deprecated('Use releaseDecisionDescriptor instead')
const ReleaseDecision$json = {
  '1': 'ReleaseDecision',
  '2': [
    {'1': 'releasable', '3': 1, '4': 1, '5': 8, '10': 'releasable'},
    {'1': 'missing', '3': 2, '4': 3, '5': 9, '10': 'missing'},
    {'1': 'reactive', '3': 3, '4': 3, '5': 9, '10': 'reactive'},
  ],
};

/// Descriptor for `ReleaseDecision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseDecisionDescriptor = $convert.base64Decode(
    'Cg9SZWxlYXNlRGVjaXNpb24SHgoKcmVsZWFzYWJsZRgBIAEoCFIKcmVsZWFzYWJsZRIYCgdtaX'
    'NzaW5nGAIgAygJUgdtaXNzaW5nEhoKCHJlYWN0aXZlGAMgAygJUghyZWFjdGl2ZQ==');

@$core.Deprecated('Use componentDescriptor instead')
const Component$json = {
  '1': 'Component',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'unit_number', '3': 2, '4': 1, '5': 9, '10': 'unitNumber'},
    {'1': 'collection_id', '3': 3, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'donor_id', '3': 4, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'component_class',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {
      '1': 'group',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.UnitStatus',
      '10': 'status'
    },
    {
      '1': 'discard_reason',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DiscardReason',
      '10': 'discardReason'
    },
    {'1': 'volume_ml', '3': 10, '4': 1, '5': 5, '10': 'volumeMl'},
    {'1': 'attributes', '3': 11, '4': 3, '5': 9, '10': 'attributes'},
    {'1': 'location', '3': 12, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'collected_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {
      '1': 'expires_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'issuable', '3': 15, '4': 1, '5': 8, '10': 'issuable'},
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 17, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 18, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Component`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List componentDescriptor = $convert.base64Decode(
    'CglDb21wb25lbnQSIQoMY29tcG9uZW50X2lkGAEgASgJUgtjb21wb25lbnRJZBIfCgt1bml0X2'
    '51bWJlchgCIAEoCVIKdW5pdE51bWJlchIjCg1jb2xsZWN0aW9uX2lkGAMgASgJUgxjb2xsZWN0'
    'aW9uSWQSGQoIZG9ub3JfaWQYBCABKAlSB2Rvbm9ySWQSFgoGc291cmNlGAUgASgJUgZzb3VyY2'
    'USUAoPY29tcG9uZW50X2NsYXNzGAYgASgOMicuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuQ29t'
    'cG9uZW50Q2xhc3NSDmNvbXBvbmVudENsYXNzEjkKBWdyb3VwGAcgASgLMiMuaGVhbHRoY2FyZS'
    '5ibG9vZGJhbmsudjEuQmxvb2RHcm91cFIFZ3JvdXASOwoGc3RhdHVzGAggASgOMiMuaGVhbHRo'
    'Y2FyZS5ibG9vZGJhbmsudjEuVW5pdFN0YXR1c1IGc3RhdHVzEk0KDmRpc2NhcmRfcmVhc29uGA'
    'kgASgOMiYuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuRGlzY2FyZFJlYXNvblINZGlzY2FyZFJl'
    'YXNvbhIbCgl2b2x1bWVfbWwYCiABKAVSCHZvbHVtZU1sEh4KCmF0dHJpYnV0ZXMYCyADKAlSCm'
    'F0dHJpYnV0ZXMSGgoIbG9jYXRpb24YDCABKAlSCGxvY2F0aW9uEj0KDGNvbGxlY3RlZF9hdBgN'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbGxlY3RlZEF0EjkKCmV4cGlyZX'
    'NfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQSGgoIaXNz'
    'dWFibGUYDyABKAhSCGlzc3VhYmxlEjkKCmNyZWF0ZWRfYXQYECABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgRIAEoCVIJY3JlYXRlZEJ5'
    'EhgKB3ZlcnNpb24YEiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'component_class',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'indication', '3': 7, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'urgency',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.RequestUrgency',
      '10': 'urgency'
    },
    {'1': 'requirements', '3': 9, '4': 3, '5': 9, '10': 'requirements'},
    {
      '1': 'required_by',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requiredBy'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.RequestStatus',
      '10': 'status'
    },
    {'1': 'requested_by', '3': 12, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'requested_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIfCgtm'
    'YWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBJQCg9jb21wb25lbnRfY2xhc3MYBSABKA4yJy'
    '5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5Db21wb25lbnRDbGFzc1IOY29tcG9uZW50Q2xhc3MS'
    'GgoIcXVhbnRpdHkYBiABKAVSCHF1YW50aXR5Eh4KCmluZGljYXRpb24YByABKAlSCmluZGljYX'
    'Rpb24SQQoHdXJnZW5jeRgIIAEoDjInLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlJlcXVlc3RV'
    'cmdlbmN5Ugd1cmdlbmN5EiIKDHJlcXVpcmVtZW50cxgJIAMoCVIMcmVxdWlyZW1lbnRzEjsKC3'
    'JlcXVpcmVkX2J5GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVxdWlyZWRC'
    'eRI+CgZzdGF0dXMYCyABKA4yJi5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5SZXF1ZXN0U3RhdH'
    'VzUgZzdGF0dXMSIQoMcmVxdWVzdGVkX2J5GAwgASgJUgtyZXF1ZXN0ZWRCeRI9CgxyZXF1ZXN0'
    'ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtyZXF1ZXN0ZWRBdBIYCg'
    'd2ZXJzaW9uGA4gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use patientSampleDescriptor instead')
const PatientSample$json = {
  '1': 'PatientSample',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'sample_number', '3': 3, '4': 1, '5': 9, '10': 'sampleNumber'},
    {
      '1': 'group',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {
      '1': 'antibody_screen_positive',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'antibodyScreenPositive'
    },
    {'1': 'antibody_note', '3': 6, '4': 1, '5': 9, '10': 'antibodyNote'},
    {'1': 'second_check', '3': 7, '4': 1, '5': 8, '10': 'secondCheck'},
    {
      '1': 'collected_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'collected_by', '3': 9, '4': 1, '5': 9, '10': 'collectedBy'},
    {
      '1': 'expires_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'tested_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'testedAt'
    },
    {'1': 'tested_by', '3': 12, '4': 1, '5': 9, '10': 'testedBy'},
  ],
};

/// Descriptor for `PatientSample`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientSampleDescriptor = $convert.base64Decode(
    'Cg1QYXRpZW50U2FtcGxlEhsKCXNhbXBsZV9pZBgBIAEoCVIIc2FtcGxlSWQSHQoKcGF0aWVudF'
    '9pZBgCIAEoCVIJcGF0aWVudElkEiMKDXNhbXBsZV9udW1iZXIYAyABKAlSDHNhbXBsZU51bWJl'
    'chI5CgVncm91cBgEIAEoCzIjLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkJsb29kR3JvdXBSBW'
    'dyb3VwEjgKGGFudGlib2R5X3NjcmVlbl9wb3NpdGl2ZRgFIAEoCFIWYW50aWJvZHlTY3JlZW5Q'
    'b3NpdGl2ZRIjCg1hbnRpYm9keV9ub3RlGAYgASgJUgxhbnRpYm9keU5vdGUSIQoMc2Vjb25kX2'
    'NoZWNrGAcgASgIUgtzZWNvbmRDaGVjaxI9Cgxjb2xsZWN0ZWRfYXQYCCABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgtjb2xsZWN0ZWRBdBIhCgxjb2xsZWN0ZWRfYnkYCSABKAlSC2'
    'NvbGxlY3RlZEJ5EjkKCmV4cGlyZXNfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUglleHBpcmVzQXQSNwoJdGVzdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIIdGVzdGVkQXQSGwoJdGVzdGVkX2J5GAwgASgJUgh0ZXN0ZWRCeQ==');

@$core.Deprecated('Use matchDecisionDescriptor instead')
const MatchDecision$json = {
  '1': 'MatchDecision',
  '2': [
    {'1': 'allowed', '3': 1, '4': 1, '5': 8, '10': 'allowed'},
    {
      '1': 'refusals',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.MatchRefusal',
      '10': 'refusals'
    },
    {'1': 'explanations', '3': 3, '4': 3, '5': 9, '10': 'explanations'},
  ],
};

/// Descriptor for `MatchDecision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchDecisionDescriptor = $convert.base64Decode(
    'Cg1NYXRjaERlY2lzaW9uEhgKB2FsbG93ZWQYASABKAhSB2FsbG93ZWQSQQoIcmVmdXNhbHMYAi'
    'ADKA4yJS5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5NYXRjaFJlZnVzYWxSCHJlZnVzYWxzEiIK'
    'DGV4cGxhbmF0aW9ucxgDIAMoCVIMZXhwbGFuYXRpb25z');

@$core.Deprecated('Use candidateDescriptor instead')
const Candidate$json = {
  '1': 'Candidate',
  '2': [
    {
      '1': 'component',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Component',
      '10': 'component'
    },
    {
      '1': 'decision',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.MatchDecision',
      '10': 'decision'
    },
  ],
};

/// Descriptor for `Candidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List candidateDescriptor = $convert.base64Decode(
    'CglDYW5kaWRhdGUSQAoJY29tcG9uZW50GAEgASgLMiIuaGVhbHRoY2FyZS5ibG9vZGJhbmsudj'
    'EuQ29tcG9uZW50Ugljb21wb25lbnQSQgoIZGVjaXNpb24YAiABKAsyJi5oZWFsdGhjYXJlLmJs'
    'b29kYmFuay52MS5NYXRjaERlY2lzaW9uUghkZWNpc2lvbg==');

@$core.Deprecated('Use reservationDescriptor instead')
const Reservation$json = {
  '1': 'Reservation',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'component_id', '3': 2, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'sample_id', '3': 5, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'crossmatched', '3': 6, '4': 1, '5': 8, '10': 'crossmatched'},
    {'1': 'crossmatch_note', '3': 7, '4': 1, '5': 9, '10': 'crossmatchNote'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ReservationStatus',
      '10': 'status'
    },
    {
      '1': 'expires_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'reserved_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reservedAt'
    },
    {'1': 'reserved_by', '3': 11, '4': 1, '5': 9, '10': 'reservedBy'},
    {'1': 'released_reason', '3': 12, '4': 1, '5': 9, '10': 'releasedReason'},
  ],
};

/// Descriptor for `Reservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reservationDescriptor = $convert.base64Decode(
    'CgtSZXNlcnZhdGlvbhIlCg5yZXNlcnZhdGlvbl9pZBgBIAEoCVINcmVzZXJ2YXRpb25JZBIhCg'
    'xjb21wb25lbnRfaWQYAiABKAlSC2NvbXBvbmVudElkEh0KCnJlcXVlc3RfaWQYAyABKAlSCXJl'
    'cXVlc3RJZBIdCgpwYXRpZW50X2lkGAQgASgJUglwYXRpZW50SWQSGwoJc2FtcGxlX2lkGAUgAS'
    'gJUghzYW1wbGVJZBIiCgxjcm9zc21hdGNoZWQYBiABKAhSDGNyb3NzbWF0Y2hlZBInCg9jcm9z'
    'c21hdGNoX25vdGUYByABKAlSDmNyb3NzbWF0Y2hOb3RlEkIKBnN0YXR1cxgIIAEoDjIqLmhlYW'
    'x0aGNhcmUuYmxvb2RiYW5rLnYxLlJlc2VydmF0aW9uU3RhdHVzUgZzdGF0dXMSOQoKZXhwaXJl'
    'c19hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWV4cGlyZXNBdBI7CgtyZX'
    'NlcnZlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlc2VydmVkQXQS'
    'HwoLcmVzZXJ2ZWRfYnkYCyABKAlSCnJlc2VydmVkQnkSJwoPcmVsZWFzZWRfcmVhc29uGAwgAS'
    'gJUg5yZWxlYXNlZFJlYXNvbg==');

@$core.Deprecated('Use issueDescriptor instead')
const Issue$json = {
  '1': 'Issue',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'component_id', '3': 2, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'reservation_id', '3': 3, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'request_id', '3': 5, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'destination', '3': 6, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'emergency', '3': 7, '4': 1, '5': 8, '10': 'emergency'},
    {
      '1': 'emergency_authoriser',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'emergencyAuthoriser'
    },
    {'1': 'emergency_reason', '3': 9, '4': 1, '5': 9, '10': 'emergencyReason'},
    {'1': 'reconciled', '3': 10, '4': 1, '5': 8, '10': 'reconciled'},
    {
      '1': 'reconciled_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reconciledAt'
    },
    {'1': 'reconciled_by', '3': 12, '4': 1, '5': 9, '10': 'reconciledBy'},
    {'1': 'reconcile_note', '3': 13, '4': 1, '5': 9, '10': 'reconcileNote'},
    {
      '1': 'issued_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'issued_by', '3': 15, '4': 1, '5': 9, '10': 'issuedBy'},
    {'1': 'issued_to', '3': 16, '4': 1, '5': 9, '10': 'issuedTo'},
    {'1': 'checked_by', '3': 17, '4': 1, '5': 9, '10': 'checkedBy'},
  ],
};

/// Descriptor for `Issue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueDescriptor = $convert.base64Decode(
    'CgVJc3N1ZRIZCghpc3N1ZV9pZBgBIAEoCVIHaXNzdWVJZBIhCgxjb21wb25lbnRfaWQYAiABKA'
    'lSC2NvbXBvbmVudElkEiUKDnJlc2VydmF0aW9uX2lkGAMgASgJUg1yZXNlcnZhdGlvbklkEh0K'
    'CnBhdGllbnRfaWQYBCABKAlSCXBhdGllbnRJZBIdCgpyZXF1ZXN0X2lkGAUgASgJUglyZXF1ZX'
    'N0SWQSIAoLZGVzdGluYXRpb24YBiABKAlSC2Rlc3RpbmF0aW9uEhwKCWVtZXJnZW5jeRgHIAEo'
    'CFIJZW1lcmdlbmN5EjEKFGVtZXJnZW5jeV9hdXRob3Jpc2VyGAggASgJUhNlbWVyZ2VuY3lBdX'
    'Rob3Jpc2VyEikKEGVtZXJnZW5jeV9yZWFzb24YCSABKAlSD2VtZXJnZW5jeVJlYXNvbhIeCgpy'
    'ZWNvbmNpbGVkGAogASgIUgpyZWNvbmNpbGVkEj8KDXJlY29uY2lsZWRfYXQYCyABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgxyZWNvbmNpbGVkQXQSIwoNcmVjb25jaWxlZF9ieRgM'
    'IAEoCVIMcmVjb25jaWxlZEJ5EiUKDnJlY29uY2lsZV9ub3RlGA0gASgJUg1yZWNvbmNpbGVOb3'
    'RlEjcKCWlzc3VlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGlzc3Vl'
    'ZEF0EhsKCWlzc3VlZF9ieRgPIAEoCVIIaXNzdWVkQnkSGwoJaXNzdWVkX3RvGBAgASgJUghpc3'
    'N1ZWRUbxIdCgpjaGVja2VkX2J5GBEgASgJUgljaGVja2VkQnk=');

@$core.Deprecated('Use observationDescriptor instead')
const Observation$json = {
  '1': 'Observation',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'timing', '3': 3, '4': 1, '5': 9, '10': 'timing'},
    {
      '1': 'values',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Observation.ValuesEntry',
      '10': 'values'
    },
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'observed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'observed_by', '3': 7, '4': 1, '5': 9, '10': 'observedBy'},
  ],
  '3': [Observation_ValuesEntry$json],
};

@$core.Deprecated('Use observationDescriptor instead')
const Observation_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Observation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationDescriptor = $convert.base64Decode(
    'CgtPYnNlcnZhdGlvbhIlCg5vYnNlcnZhdGlvbl9pZBgBIAEoCVINb2JzZXJ2YXRpb25JZBIdCg'
    'plcGlzb2RlX2lkGAIgASgJUgllcGlzb2RlSWQSFgoGdGltaW5nGAMgASgJUgZ0aW1pbmcSSAoG'
    'dmFsdWVzGAQgAygLMjAuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuT2JzZXJ2YXRpb24uVmFsdW'
    'VzRW50cnlSBnZhbHVlcxISCgRub3RlGAUgASgJUgRub3RlEjsKC29ic2VydmVkX2F0GAYgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2JzZXJ2ZWRBdBIfCgtvYnNlcnZlZF9ieR'
    'gHIAEoCVIKb2JzZXJ2ZWRCeRo5CgtWYWx1ZXNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2'
    'YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use episodeDescriptor instead')
const Episode$json = {
  '1': 'Episode',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'component_id', '3': 2, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'issue_id', '3': 3, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.EpisodeStatus',
      '10': 'status'
    },
    {
      '1': 'started_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 8, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'ended_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'volume_given_ml', '3': 10, '4': 1, '5': 5, '10': 'volumeGivenMl'},
    {'1': 'stop_reason', '3': 11, '4': 1, '5': 9, '10': 'stopReason'},
    {
      '1': 'observations',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Observation',
      '10': 'observations'
    },
  ],
};

/// Descriptor for `Episode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List episodeDescriptor = $convert.base64Decode(
    'CgdFcGlzb2RlEh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBIhCgxjb21wb25lbnRfaW'
    'QYAiABKAlSC2NvbXBvbmVudElkEhkKCGlzc3VlX2lkGAMgASgJUgdpc3N1ZUlkEh0KCnBhdGll'
    'bnRfaWQYBCABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYBSABKAlSC2VuY291bnRlck'
    'lkEj4KBnN0YXR1cxgGIAEoDjImLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkVwaXNvZGVTdGF0'
    'dXNSBnN0YXR1cxI5CgpzdGFydGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJc3RhcnRlZEF0Eh0KCnN0YXJ0ZWRfYnkYCCABKAlSCXN0YXJ0ZWRCeRI1CghlbmRlZF9h'
    'dBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZGVkQXQSJgoPdm9sdW1lX2'
    'dpdmVuX21sGAogASgFUg12b2x1bWVHaXZlbk1sEh8KC3N0b3BfcmVhc29uGAsgASgJUgpzdG9w'
    'UmVhc29uEkgKDG9ic2VydmF0aW9ucxgMIAMoCzIkLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLk'
    '9ic2VydmF0aW9uUgxvYnNlcnZhdGlvbnM=');

@$core.Deprecated('Use reactionDescriptor instead')
const Reaction$json = {
  '1': 'Reaction',
  '2': [
    {'1': 'reaction_id', '3': 1, '4': 1, '5': 9, '10': 'reactionId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'component_id', '3': 3, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'severity',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ReactionSeverity',
      '10': 'severity'
    },
    {'1': 'features', '3': 6, '4': 3, '5': 9, '10': 'features'},
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'reported_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reported_by', '3': 9, '4': 1, '5': 9, '10': 'reportedBy'},
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.InvestigationState',
      '10': 'state'
    },
    {'1': 'classification', '3': 11, '4': 1, '5': 9, '10': 'classification'},
    {'1': 'conclusion', '3': 12, '4': 1, '5': 9, '10': 'conclusion'},
    {
      '1': 'concluded_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'concludedAt'
    },
    {'1': 'concluded_by', '3': 14, '4': 1, '5': 9, '10': 'concludedBy'},
    {'1': 'unit_returned', '3': 15, '4': 1, '5': 8, '10': 'unitReturned'},
    {'1': 'action_taken', '3': 16, '4': 1, '5': 9, '10': 'actionTaken'},
  ],
};

/// Descriptor for `Reaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactionDescriptor = $convert.base64Decode(
    'CghSZWFjdGlvbhIfCgtyZWFjdGlvbl9pZBgBIAEoCVIKcmVhY3Rpb25JZBIdCgplcGlzb2RlX2'
    'lkGAIgASgJUgllcGlzb2RlSWQSIQoMY29tcG9uZW50X2lkGAMgASgJUgtjb21wb25lbnRJZBId'
    'CgpwYXRpZW50X2lkGAQgASgJUglwYXRpZW50SWQSRQoIc2V2ZXJpdHkYBSABKA4yKS5oZWFsdG'
    'hjYXJlLmJsb29kYmFuay52MS5SZWFjdGlvblNldmVyaXR5UghzZXZlcml0eRIaCghmZWF0dXJl'
    'cxgGIAMoCVIIZmVhdHVyZXMSEgoEbm90ZRgHIAEoCVIEbm90ZRI7CgtyZXBvcnRlZF9hdBgIIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlcG9ydGVkQXQSHwoLcmVwb3J0ZWRf'
    'YnkYCSABKAlSCnJlcG9ydGVkQnkSQQoFc3RhdGUYCiABKA4yKy5oZWFsdGhjYXJlLmJsb29kYm'
    'Fuay52MS5JbnZlc3RpZ2F0aW9uU3RhdGVSBXN0YXRlEiYKDmNsYXNzaWZpY2F0aW9uGAsgASgJ'
    'Ug5jbGFzc2lmaWNhdGlvbhIeCgpjb25jbHVzaW9uGAwgASgJUgpjb25jbHVzaW9uEj0KDGNvbm'
    'NsdWRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbmNsdWRlZEF0'
    'EiEKDGNvbmNsdWRlZF9ieRgOIAEoCVILY29uY2x1ZGVkQnkSIwoNdW5pdF9yZXR1cm5lZBgPIA'
    'EoCFIMdW5pdFJldHVybmVkEiEKDGFjdGlvbl90YWtlbhgQIAEoCVILYWN0aW9uVGFrZW4=');

@$core.Deprecated('Use chainLinkDescriptor instead')
const ChainLink$json = {
  '1': 'ChainLink',
  '2': [
    {'1': 'stage', '3': 1, '4': 1, '5': 9, '10': 'stage'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'by', '3': 5, '4': 1, '5': 9, '10': 'by'},
  ],
};

/// Descriptor for `ChainLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainLinkDescriptor = $convert.base64Decode(
    'CglDaGFpbkxpbmsSFAoFc3RhZ2UYASABKAlSBXN0YWdlEg4KAmlkGAIgASgJUgJpZBIUCgVsYW'
    'JlbBgDIAEoCVIFbGFiZWwSKgoCYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgJhdBIOCgJieRgFIAEoCVICYnk=');

@$core.Deprecated('Use chainDescriptor instead')
const Chain$json = {
  '1': 'Chain',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'unit_number', '3': 2, '4': 1, '5': 9, '10': 'unitNumber'},
    {
      '1': 'links',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.ChainLink',
      '10': 'links'
    },
    {'1': 'gaps', '3': 4, '4': 3, '5': 9, '10': 'gaps'},
  ],
};

/// Descriptor for `Chain`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chainDescriptor = $convert.base64Decode(
    'CgVDaGFpbhIhCgxjb21wb25lbnRfaWQYASABKAlSC2NvbXBvbmVudElkEh8KC3VuaXRfbnVtYm'
    'VyGAIgASgJUgp1bml0TnVtYmVyEjgKBWxpbmtzGAMgAygLMiIuaGVhbHRoY2FyZS5ibG9vZGJh'
    'bmsudjEuQ2hhaW5MaW5rUgVsaW5rcxISCgRnYXBzGAQgAygJUgRnYXBz');

@$core.Deprecated('Use recipientDescriptor instead')
const Recipient$json = {
  '1': 'Recipient',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'component_id', '3': 3, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'unit_number', '3': 4, '4': 1, '5': 9, '10': 'unitNumber'},
    {
      '1': 'at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
  ],
};

/// Descriptor for `Recipient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipientDescriptor = $convert.base64Decode(
    'CglSZWNpcGllbnQSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEh0KCmVwaXNvZGVfaW'
    'QYAiABKAlSCWVwaXNvZGVJZBIhCgxjb21wb25lbnRfaWQYAyABKAlSC2NvbXBvbmVudElkEh8K'
    'C3VuaXRfbnVtYmVyGAQgASgJUgp1bml0TnVtYmVyEioKAmF0GAUgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFICYXQ=');

@$core.Deprecated('Use stockLevelDescriptor instead')
const StockLevel$json = {
  '1': 'StockLevel',
  '2': [
    {
      '1': 'component_class',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {
      '1': 'group',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {'1': 'available', '3': 3, '4': 1, '5': 5, '10': 'available'},
    {'1': 'expiring_soon', '3': 4, '4': 1, '5': 5, '10': 'expiringSoon'},
    {'1': 'quarantined', '3': 5, '4': 1, '5': 5, '10': 'quarantined'},
    {'1': 'reserved', '3': 6, '4': 1, '5': 5, '10': 'reserved'},
  ],
};

/// Descriptor for `StockLevel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockLevelDescriptor = $convert.base64Decode(
    'CgpTdG9ja0xldmVsElAKD2NvbXBvbmVudF9jbGFzcxgBIAEoDjInLmhlYWx0aGNhcmUuYmxvb2'
    'RiYW5rLnYxLkNvbXBvbmVudENsYXNzUg5jb21wb25lbnRDbGFzcxI5CgVncm91cBgCIAEoCzIj'
    'LmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkJsb29kR3JvdXBSBWdyb3VwEhwKCWF2YWlsYWJsZR'
    'gDIAEoBVIJYXZhaWxhYmxlEiMKDWV4cGlyaW5nX3Nvb24YBCABKAVSDGV4cGlyaW5nU29vbhIg'
    'CgtxdWFyYW50aW5lZBgFIAEoBVILcXVhcmFudGluZWQSGgoIcmVzZXJ2ZWQYBiABKAVSCHJlc2'
    'VydmVk');

@$core.Deprecated('Use stockAlertDescriptor instead')
const StockAlert$json = {
  '1': 'StockAlert',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.StockAlertKind',
      '10': 'kind'
    },
    {
      '1': 'component_class',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {
      '1': 'group',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {'1': 'available', '3': 4, '4': 1, '5': 5, '10': 'available'},
    {'1': 'minimum', '3': 5, '4': 1, '5': 5, '10': 'minimum'},
    {'1': 'count', '3': 6, '4': 1, '5': 5, '10': 'count'},
    {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `StockAlert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockAlertDescriptor = $convert.base64Decode(
    'CgpTdG9ja0FsZXJ0EjsKBGtpbmQYASABKA4yJy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5TdG'
    '9ja0FsZXJ0S2luZFIEa2luZBJQCg9jb21wb25lbnRfY2xhc3MYAiABKA4yJy5oZWFsdGhjYXJl'
    'LmJsb29kYmFuay52MS5Db21wb25lbnRDbGFzc1IOY29tcG9uZW50Q2xhc3MSOQoFZ3JvdXAYAy'
    'ABKAsyIy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5CbG9vZEdyb3VwUgVncm91cBIcCglhdmFp'
    'bGFibGUYBCABKAVSCWF2YWlsYWJsZRIYCgdtaW5pbXVtGAUgASgFUgdtaW5pbXVtEhQKBWNvdW'
    '50GAYgASgFUgVjb3VudBIYCgdtZXNzYWdlGAcgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use stockThresholdDescriptor instead')
const StockThreshold$json = {
  '1': 'StockThreshold',
  '2': [
    {
      '1': 'component_class',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {
      '1': 'group',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {'1': 'minimum', '3': 3, '4': 1, '5': 5, '10': 'minimum'},
  ],
};

/// Descriptor for `StockThreshold`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stockThresholdDescriptor = $convert.base64Decode(
    'Cg5TdG9ja1RocmVzaG9sZBJQCg9jb21wb25lbnRfY2xhc3MYASABKA4yJy5oZWFsdGhjYXJlLm'
    'Jsb29kYmFuay52MS5Db21wb25lbnRDbGFzc1IOY29tcG9uZW50Q2xhc3MSOQoFZ3JvdXAYAiAB'
    'KAsyIy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5CbG9vZEdyb3VwUgVncm91cBIYCgdtaW5pbX'
    'VtGAMgASgFUgdtaW5pbXVt');

@$core.Deprecated('Use utilisationDescriptor instead')
const Utilisation$json = {
  '1': 'Utilisation',
  '2': [
    {'1': 'issued', '3': 1, '4': 1, '5': 5, '10': 'issued'},
    {'1': 'transfused', '3': 2, '4': 1, '5': 5, '10': 'transfused'},
    {'1': 'returned', '3': 3, '4': 1, '5': 5, '10': 'returned'},
    {'1': 'discarded', '3': 4, '4': 1, '5': 5, '10': 'discarded'},
    {'1': 'reactions', '3': 5, '4': 1, '5': 5, '10': 'reactions'},
    {
      '1': 'emergency_releases',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'emergencyReleases'
    },
    {
      '1': 'unreconciled_releases',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'unreconciledReleases'
    },
    {'1': 'reservations', '3': 8, '4': 1, '5': 5, '10': 'reservations'},
    {
      '1': 'crossmatch_to_transfusion',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'crossmatchToTransfusion'
    },
    {
      '1': 'by_indication',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Utilisation.ByIndicationEntry',
      '10': 'byIndication'
    },
  ],
  '3': [Utilisation_ByIndicationEntry$json],
};

@$core.Deprecated('Use utilisationDescriptor instead')
const Utilisation_ByIndicationEntry$json = {
  '1': 'ByIndicationEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Utilisation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List utilisationDescriptor = $convert.base64Decode(
    'CgtVdGlsaXNhdGlvbhIWCgZpc3N1ZWQYASABKAVSBmlzc3VlZBIeCgp0cmFuc2Z1c2VkGAIgAS'
    'gFUgp0cmFuc2Z1c2VkEhoKCHJldHVybmVkGAMgASgFUghyZXR1cm5lZBIcCglkaXNjYXJkZWQY'
    'BCABKAVSCWRpc2NhcmRlZBIcCglyZWFjdGlvbnMYBSABKAVSCXJlYWN0aW9ucxItChJlbWVyZ2'
    'VuY3lfcmVsZWFzZXMYBiABKAVSEWVtZXJnZW5jeVJlbGVhc2VzEjMKFXVucmVjb25jaWxlZF9y'
    'ZWxlYXNlcxgHIAEoBVIUdW5yZWNvbmNpbGVkUmVsZWFzZXMSIgoMcmVzZXJ2YXRpb25zGAggAS'
    'gFUgxyZXNlcnZhdGlvbnMSOgoZY3Jvc3NtYXRjaF90b190cmFuc2Z1c2lvbhgJIAEoAVIXY3Jv'
    'c3NtYXRjaFRvVHJhbnNmdXNpb24SWwoNYnlfaW5kaWNhdGlvbhgKIAMoCzI2LmhlYWx0aGNhcm'
    'UuYmxvb2RiYW5rLnYxLlV0aWxpc2F0aW9uLkJ5SW5kaWNhdGlvbkVudHJ5UgxieUluZGljYXRp'
    'b24aPwoRQnlJbmRpY2F0aW9uRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKA'
    'VSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use registerDonorRequestDescriptor instead')
const RegisterDonorRequest$json = {
  '1': 'RegisterDonorRequest',
  '2': [
    {'1': 'donor_number', '3': 1, '4': 1, '5': 9, '10': 'donorNumber'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'contact_phone', '3': 4, '4': 1, '5': 9, '10': 'contactPhone'},
    {
      '1': 'group',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
  ],
};

/// Descriptor for `RegisterDonorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDonorRequestDescriptor = $convert.base64Decode(
    'ChRSZWdpc3RlckRvbm9yUmVxdWVzdBIhCgxkb25vcl9udW1iZXIYASABKAlSC2Rvbm9yTnVtYm'
    'VyEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxkaXNwbGF5X25hbWUYAyABKAlS'
    'C2Rpc3BsYXlOYW1lEiMKDWNvbnRhY3RfcGhvbmUYBCABKAlSDGNvbnRhY3RQaG9uZRI5CgVncm'
    '91cBgFIAEoCzIjLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkJsb29kR3JvdXBSBWdyb3Vw');

@$core.Deprecated('Use registerDonorResponseDescriptor instead')
const RegisterDonorResponse$json = {
  '1': 'RegisterDonorResponse',
  '2': [
    {
      '1': 'donor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Donor',
      '10': 'donor'
    },
  ],
};

/// Descriptor for `RegisterDonorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDonorResponseDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlckRvbm9yUmVzcG9uc2USNAoFZG9ub3IYASABKAsyHi5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5Eb25vclIFZG9ub3I=');

@$core.Deprecated('Use getDonorRequestDescriptor instead')
const GetDonorRequest$json = {
  '1': 'GetDonorRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
  ],
};

/// Descriptor for `GetDonorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDonorRequestDescriptor = $convert.base64Decode(
    'Cg9HZXREb25vclJlcXVlc3QSGQoIZG9ub3JfaWQYASABKAlSB2Rvbm9ySWQ=');

@$core.Deprecated('Use getDonorResponseDescriptor instead')
const GetDonorResponse$json = {
  '1': 'GetDonorResponse',
  '2': [
    {
      '1': 'donor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Donor',
      '10': 'donor'
    },
  ],
};

/// Descriptor for `GetDonorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDonorResponseDescriptor = $convert.base64Decode(
    'ChBHZXREb25vclJlc3BvbnNlEjQKBWRvbm9yGAEgASgLMh4uaGVhbHRoY2FyZS5ibG9vZGJhbm'
    'sudjEuRG9ub3JSBWRvbm9y');

@$core.Deprecated('Use deferDonorRequestDescriptor instead')
const DeferDonorRequest$json = {
  '1': 'DeferDonorRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DeferralKind',
      '10': 'kind'
    },
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'until',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
  ],
};

/// Descriptor for `DeferDonorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deferDonorRequestDescriptor = $convert.base64Decode(
    'ChFEZWZlckRvbm9yUmVxdWVzdBIZCghkb25vcl9pZBgBIAEoCVIHZG9ub3JJZBI5CgRraW5kGA'
    'IgASgOMiUuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuRGVmZXJyYWxLaW5kUgRraW5kEhIKBGNv'
    'ZGUYAyABKAlSBGNvZGUSEgoEbm90ZRgEIAEoCVIEbm90ZRIwCgV1bnRpbBgFIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBXVudGls');

@$core.Deprecated('Use deferDonorResponseDescriptor instead')
const DeferDonorResponse$json = {
  '1': 'DeferDonorResponse',
  '2': [
    {
      '1': 'donor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Donor',
      '10': 'donor'
    },
  ],
};

/// Descriptor for `DeferDonorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deferDonorResponseDescriptor = $convert.base64Decode(
    'ChJEZWZlckRvbm9yUmVzcG9uc2USNAoFZG9ub3IYASABKAsyHi5oZWFsdGhjYXJlLmJsb29kYm'
    'Fuay52MS5Eb25vclIFZG9ub3I=');

@$core.Deprecated('Use reinstateDonorRequestDescriptor instead')
const ReinstateDonorRequest$json = {
  '1': 'ReinstateDonorRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReinstateDonorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reinstateDonorRequestDescriptor = $convert.base64Decode(
    'ChVSZWluc3RhdGVEb25vclJlcXVlc3QSGQoIZG9ub3JfaWQYASABKAlSB2Rvbm9ySWQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use reinstateDonorResponseDescriptor instead')
const ReinstateDonorResponse$json = {
  '1': 'ReinstateDonorResponse',
  '2': [
    {
      '1': 'donor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Donor',
      '10': 'donor'
    },
  ],
};

/// Descriptor for `ReinstateDonorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reinstateDonorResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWluc3RhdGVEb25vclJlc3BvbnNlEjQKBWRvbm9yGAEgASgLMh4uaGVhbHRoY2FyZS5ibG'
        '9vZGJhbmsudjEuRG9ub3JSBWRvbm9y');

@$core.Deprecated('Use listDeferredDonorsRequestDescriptor instead')
const ListDeferredDonorsRequest$json = {
  '1': 'ListDeferredDonorsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDeferredDonorsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeferredDonorsRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RGVmZXJyZWREb25vcnNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpem'
        'U=');

@$core.Deprecated('Use listDeferredDonorsResponseDescriptor instead')
const ListDeferredDonorsResponse$json = {
  '1': 'ListDeferredDonorsResponse',
  '2': [
    {
      '1': 'donors',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Donor',
      '10': 'donors'
    },
  ],
};

/// Descriptor for `ListDeferredDonorsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeferredDonorsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RGVmZXJyZWREb25vcnNSZXNwb25zZRI2CgZkb25vcnMYASADKAsyHi5oZWFsdGhjYX'
        'JlLmJsb29kYmFuay52MS5Eb25vclIGZG9ub3Jz');

@$core.Deprecated('Use screenDonorRequestDescriptor instead')
const ScreenDonorRequest$json = {
  '1': 'ScreenDonorRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {
      '1': 'answers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.ScreenDonorRequest.AnswersEntry',
      '10': 'answers'
    },
    {
      '1': 'measurements',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.ScreenDonorRequest.MeasurementsEntry',
      '10': 'measurements'
    },
    {'1': 'consented', '3': 4, '4': 1, '5': 8, '10': 'consented'},
    {'1': 'consent_note', '3': 5, '4': 1, '5': 9, '10': 'consentNote'},
    {'1': 'accepted', '3': 6, '4': 1, '5': 8, '10': 'accepted'},
    {
      '1': 'deferral',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DeferralKind',
      '10': 'deferral'
    },
    {'1': 'deferral_code', '3': 8, '4': 1, '5': 9, '10': 'deferralCode'},
  ],
  '3': [
    ScreenDonorRequest_AnswersEntry$json,
    ScreenDonorRequest_MeasurementsEntry$json
  ],
};

@$core.Deprecated('Use screenDonorRequestDescriptor instead')
const ScreenDonorRequest_AnswersEntry$json = {
  '1': 'AnswersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use screenDonorRequestDescriptor instead')
const ScreenDonorRequest_MeasurementsEntry$json = {
  '1': 'MeasurementsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ScreenDonorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenDonorRequestDescriptor = $convert.base64Decode(
    'ChJTY3JlZW5Eb25vclJlcXVlc3QSGQoIZG9ub3JfaWQYASABKAlSB2Rvbm9ySWQSUgoHYW5zd2'
    'VycxgCIAMoCzI4LmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlNjcmVlbkRvbm9yUmVxdWVzdC5B'
    'bnN3ZXJzRW50cnlSB2Fuc3dlcnMSYQoMbWVhc3VyZW1lbnRzGAMgAygLMj0uaGVhbHRoY2FyZS'
    '5ibG9vZGJhbmsudjEuU2NyZWVuRG9ub3JSZXF1ZXN0Lk1lYXN1cmVtZW50c0VudHJ5UgxtZWFz'
    'dXJlbWVudHMSHAoJY29uc2VudGVkGAQgASgIUgljb25zZW50ZWQSIQoMY29uc2VudF9ub3RlGA'
    'UgASgJUgtjb25zZW50Tm90ZRIaCghhY2NlcHRlZBgGIAEoCFIIYWNjZXB0ZWQSQQoIZGVmZXJy'
    'YWwYByABKA4yJS5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5EZWZlcnJhbEtpbmRSCGRlZmVycm'
    'FsEiMKDWRlZmVycmFsX2NvZGUYCCABKAlSDGRlZmVycmFsQ29kZRo6CgxBbnN3ZXJzRW50cnkS'
    'EAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4ARo/ChFNZWFzdXJlbW'
    'VudHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use screenDonorResponseDescriptor instead')
const ScreenDonorResponse$json = {
  '1': 'ScreenDonorResponse',
  '2': [
    {
      '1': 'screening',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Screening',
      '10': 'screening'
    },
  ],
};

/// Descriptor for `ScreenDonorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenDonorResponseDescriptor = $convert.base64Decode(
    'ChNTY3JlZW5Eb25vclJlc3BvbnNlEkAKCXNjcmVlbmluZxgBIAEoCzIiLmhlYWx0aGNhcmUuYm'
    'xvb2RiYW5rLnYxLlNjcmVlbmluZ1IJc2NyZWVuaW5n');

@$core.Deprecated('Use collectRequestDescriptor instead')
const CollectRequest$json = {
  '1': 'CollectRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'screening_id', '3': 2, '4': 1, '5': 9, '10': 'screeningId'},
    {'1': 'donation_number', '3': 3, '4': 1, '5': 9, '10': 'donationNumber'},
    {'1': 'kind', '3': 4, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'volume_ml', '3': 5, '4': 1, '5': 5, '10': 'volumeMl'},
    {
      '1': 'group',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {'1': 'adverse_event', '3': 7, '4': 1, '5': 8, '10': 'adverseEvent'},
    {'1': 'adverse_note', '3': 8, '4': 1, '5': 9, '10': 'adverseNote'},
  ],
};

/// Descriptor for `CollectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectRequestDescriptor = $convert.base64Decode(
    'Cg5Db2xsZWN0UmVxdWVzdBIZCghkb25vcl9pZBgBIAEoCVIHZG9ub3JJZBIhCgxzY3JlZW5pbm'
    'dfaWQYAiABKAlSC3NjcmVlbmluZ0lkEicKD2RvbmF0aW9uX251bWJlchgDIAEoCVIOZG9uYXRp'
    'b25OdW1iZXISEgoEa2luZBgEIAEoCVIEa2luZBIbCgl2b2x1bWVfbWwYBSABKAVSCHZvbHVtZU'
    '1sEjkKBWdyb3VwGAYgASgLMiMuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuQmxvb2RHcm91cFIF'
    'Z3JvdXASIwoNYWR2ZXJzZV9ldmVudBgHIAEoCFIMYWR2ZXJzZUV2ZW50EiEKDGFkdmVyc2Vfbm'
    '90ZRgIIAEoCVILYWR2ZXJzZU5vdGU=');

@$core.Deprecated('Use collectResponseDescriptor instead')
const CollectResponse$json = {
  '1': 'CollectResponse',
  '2': [
    {
      '1': 'collection',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Collection',
      '10': 'collection'
    },
  ],
};

/// Descriptor for `CollectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectResponseDescriptor = $convert.base64Decode(
    'Cg9Db2xsZWN0UmVzcG9uc2USQwoKY29sbGVjdGlvbhgBIAEoCzIjLmhlYWx0aGNhcmUuYmxvb2'
    'RiYW5rLnYxLkNvbGxlY3Rpb25SCmNvbGxlY3Rpb24=');

@$core.Deprecated('Use recordTestRequestDescriptor instead')
const RecordTestRequest$json = {
  '1': 'RecordTestRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'reactive', '3': 4, '4': 1, '5': 8, '10': 'reactive'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
    {'1': 'method', '3': 6, '4': 1, '5': 9, '10': 'method'},
  ],
};

/// Descriptor for `RecordTestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTestRequestDescriptor = $convert.base64Decode(
    'ChFSZWNvcmRUZXN0UmVxdWVzdBIjCg1jb2xsZWN0aW9uX2lkGAEgASgJUgxjb2xsZWN0aW9uSW'
    'QSEgoEY29kZRgCIAEoCVIEY29kZRIYCgdkaXNwbGF5GAMgASgJUgdkaXNwbGF5EhoKCHJlYWN0'
    'aXZlGAQgASgIUghyZWFjdGl2ZRIUCgV2YWx1ZRgFIAEoCVIFdmFsdWUSFgoGbWV0aG9kGAYgAS'
    'gJUgZtZXRob2Q=');

@$core.Deprecated('Use recordTestResponseDescriptor instead')
const RecordTestResponse$json = {
  '1': 'RecordTestResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.TestResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `RecordTestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTestResponseDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRUZXN0UmVzcG9uc2USOwoGcmVzdWx0GAEgASgLMiMuaGVhbHRoY2FyZS5ibG9vZG'
    'JhbmsudjEuVGVzdFJlc3VsdFIGcmVzdWx0');

@$core.Deprecated('Use getReleaseDecisionRequestDescriptor instead')
const GetReleaseDecisionRequest$json = {
  '1': 'GetReleaseDecisionRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
  ],
};

/// Descriptor for `GetReleaseDecisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseDecisionRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZWxlYXNlRGVjaXNpb25SZXF1ZXN0EiMKDWNvbGxlY3Rpb25faWQYASABKAlSDGNvbG'
        'xlY3Rpb25JZA==');

@$core.Deprecated('Use getReleaseDecisionResponseDescriptor instead')
const GetReleaseDecisionResponse$json = {
  '1': 'GetReleaseDecisionResponse',
  '2': [
    {
      '1': 'decision',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.ReleaseDecision',
      '10': 'decision'
    },
  ],
};

/// Descriptor for `GetReleaseDecisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseDecisionResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRSZWxlYXNlRGVjaXNpb25SZXNwb25zZRJECghkZWNpc2lvbhgBIAEoCzIoLmhlYWx0aG'
        'NhcmUuYmxvb2RiYW5rLnYxLlJlbGVhc2VEZWNpc2lvblIIZGVjaXNpb24=');

@$core.Deprecated('Use releaseComponentsRequestDescriptor instead')
const ReleaseComponentsRequest$json = {
  '1': 'ReleaseComponentsRequest',
  '2': [
    {'1': 'collection_id', '3': 1, '4': 1, '5': 9, '10': 'collectionId'},
  ],
};

/// Descriptor for `ReleaseComponentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseComponentsRequestDescriptor =
    $convert.base64Decode(
        'ChhSZWxlYXNlQ29tcG9uZW50c1JlcXVlc3QSIwoNY29sbGVjdGlvbl9pZBgBIAEoCVIMY29sbG'
        'VjdGlvbklk');

@$core.Deprecated('Use releaseComponentsResponseDescriptor instead')
const ReleaseComponentsResponse$json = {
  '1': 'ReleaseComponentsResponse',
  '2': [
    {
      '1': 'components',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Component',
      '10': 'components'
    },
  ],
};

/// Descriptor for `ReleaseComponentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseComponentsResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWxlYXNlQ29tcG9uZW50c1Jlc3BvbnNlEkIKCmNvbXBvbmVudHMYASADKAsyIi5oZWFsdG'
        'hjYXJlLmJsb29kYmFuay52MS5Db21wb25lbnRSCmNvbXBvbmVudHM=');

@$core.Deprecated('Use addComponentRequestDescriptor instead')
const AddComponentRequest$json = {
  '1': 'AddComponentRequest',
  '2': [
    {'1': 'unit_number', '3': 1, '4': 1, '5': 9, '10': 'unitNumber'},
    {'1': 'collection_id', '3': 2, '4': 1, '5': 9, '10': 'collectionId'},
    {'1': 'donor_id', '3': 3, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'component_class',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {
      '1': 'group',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {'1': 'volume_ml', '3': 7, '4': 1, '5': 5, '10': 'volumeMl'},
    {'1': 'attributes', '3': 8, '4': 3, '5': 9, '10': 'attributes'},
    {'1': 'location', '3': 9, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'collected_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {
      '1': 'expires_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'released', '3': 12, '4': 1, '5': 8, '10': 'released'},
  ],
};

/// Descriptor for `AddComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addComponentRequestDescriptor = $convert.base64Decode(
    'ChNBZGRDb21wb25lbnRSZXF1ZXN0Eh8KC3VuaXRfbnVtYmVyGAEgASgJUgp1bml0TnVtYmVyEi'
    'MKDWNvbGxlY3Rpb25faWQYAiABKAlSDGNvbGxlY3Rpb25JZBIZCghkb25vcl9pZBgDIAEoCVIH'
    'ZG9ub3JJZBIWCgZzb3VyY2UYBCABKAlSBnNvdXJjZRJQCg9jb21wb25lbnRfY2xhc3MYBSABKA'
    '4yJy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5Db21wb25lbnRDbGFzc1IOY29tcG9uZW50Q2xh'
    'c3MSOQoFZ3JvdXAYBiABKAsyIy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5CbG9vZEdyb3VwUg'
    'Vncm91cBIbCgl2b2x1bWVfbWwYByABKAVSCHZvbHVtZU1sEh4KCmF0dHJpYnV0ZXMYCCADKAlS'
    'CmF0dHJpYnV0ZXMSGgoIbG9jYXRpb24YCSABKAlSCGxvY2F0aW9uEj0KDGNvbGxlY3RlZF9hdB'
    'gKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbGxlY3RlZEF0EjkKCmV4cGly'
    'ZXNfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQSGgoIcm'
    'VsZWFzZWQYDCABKAhSCHJlbGVhc2Vk');

@$core.Deprecated('Use addComponentResponseDescriptor instead')
const AddComponentResponse$json = {
  '1': 'AddComponentResponse',
  '2': [
    {
      '1': 'component',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Component',
      '10': 'component'
    },
  ],
};

/// Descriptor for `AddComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addComponentResponseDescriptor = $convert.base64Decode(
    'ChRBZGRDb21wb25lbnRSZXNwb25zZRJACgljb21wb25lbnQYASABKAsyIi5oZWFsdGhjYXJlLm'
    'Jsb29kYmFuay52MS5Db21wb25lbnRSCWNvbXBvbmVudA==');

@$core.Deprecated('Use getComponentRequestDescriptor instead')
const GetComponentRequest$json = {
  '1': 'GetComponentRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'unit_number', '3': 2, '4': 1, '5': 9, '10': 'unitNumber'},
  ],
};

/// Descriptor for `GetComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getComponentRequestDescriptor = $convert.base64Decode(
    'ChNHZXRDb21wb25lbnRSZXF1ZXN0EiEKDGNvbXBvbmVudF9pZBgBIAEoCVILY29tcG9uZW50SW'
    'QSHwoLdW5pdF9udW1iZXIYAiABKAlSCnVuaXROdW1iZXI=');

@$core.Deprecated('Use getComponentResponseDescriptor instead')
const GetComponentResponse$json = {
  '1': 'GetComponentResponse',
  '2': [
    {
      '1': 'component',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Component',
      '10': 'component'
    },
  ],
};

/// Descriptor for `GetComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getComponentResponseDescriptor = $convert.base64Decode(
    'ChRHZXRDb21wb25lbnRSZXNwb25zZRJACgljb21wb25lbnQYASABKAsyIi5oZWFsdGhjYXJlLm'
    'Jsb29kYmFuay52MS5Db21wb25lbnRSCWNvbXBvbmVudA==');

@$core.Deprecated('Use discardComponentRequestDescriptor instead')
const DiscardComponentRequest$json = {
  '1': 'DiscardComponentRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {
      '1': 'reason',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.DiscardReason',
      '10': 'reason'
    },
  ],
};

/// Descriptor for `DiscardComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discardComponentRequestDescriptor = $convert.base64Decode(
    'ChdEaXNjYXJkQ29tcG9uZW50UmVxdWVzdBIhCgxjb21wb25lbnRfaWQYASABKAlSC2NvbXBvbm'
    'VudElkEj4KBnJlYXNvbhgCIAEoDjImLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkRpc2NhcmRS'
    'ZWFzb25SBnJlYXNvbg==');

@$core.Deprecated('Use discardComponentResponseDescriptor instead')
const DiscardComponentResponse$json = {
  '1': 'DiscardComponentResponse',
  '2': [
    {
      '1': 'component',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Component',
      '10': 'component'
    },
  ],
};

/// Descriptor for `DiscardComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discardComponentResponseDescriptor =
    $convert.base64Decode(
        'ChhEaXNjYXJkQ29tcG9uZW50UmVzcG9uc2USQAoJY29tcG9uZW50GAEgASgLMiIuaGVhbHRoY2'
        'FyZS5ibG9vZGJhbmsudjEuQ29tcG9uZW50Ugljb21wb25lbnQ=');

@$core.Deprecated('Use placeRequestRequestDescriptor instead')
const PlaceRequestRequest$json = {
  '1': 'PlaceRequestRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'component_class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ComponentClass',
      '10': 'componentClass'
    },
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'indication', '3': 6, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'urgency',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.RequestUrgency',
      '10': 'urgency'
    },
    {'1': 'requirements', '3': 8, '4': 3, '5': 9, '10': 'requirements'},
    {
      '1': 'required_by',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requiredBy'
    },
  ],
};

/// Descriptor for `PlaceRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeRequestRequestDescriptor = $convert.base64Decode(
    'ChNQbGFjZVJlcXVlc3RSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCg'
    'xlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpm'
    'YWNpbGl0eUlkElAKD2NvbXBvbmVudF9jbGFzcxgEIAEoDjInLmhlYWx0aGNhcmUuYmxvb2RiYW'
    '5rLnYxLkNvbXBvbmVudENsYXNzUg5jb21wb25lbnRDbGFzcxIaCghxdWFudGl0eRgFIAEoBVII'
    'cXVhbnRpdHkSHgoKaW5kaWNhdGlvbhgGIAEoCVIKaW5kaWNhdGlvbhJBCgd1cmdlbmN5GAcgAS'
    'gOMicuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVxdWVzdFVyZ2VuY3lSB3VyZ2VuY3kSIgoM'
    'cmVxdWlyZW1lbnRzGAggAygJUgxyZXF1aXJlbWVudHMSOwoLcmVxdWlyZWRfYnkYCSABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZXF1aXJlZEJ5');

@$core.Deprecated('Use placeRequestResponseDescriptor instead')
const PlaceRequestResponse$json = {
  '1': 'PlaceRequestResponse',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Request',
      '10': 'request'
    },
  ],
};

/// Descriptor for `PlaceRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeRequestResponseDescriptor = $convert.base64Decode(
    'ChRQbGFjZVJlcXVlc3RSZXNwb25zZRI6CgdyZXF1ZXN0GAEgASgLMiAuaGVhbHRoY2FyZS5ibG'
    '9vZGJhbmsudjEuUmVxdWVzdFIHcmVxdWVzdA==');

@$core.Deprecated('Use getWorklistRequestDescriptor instead')
const GetWorklistRequest$json = {
  '1': 'GetWorklistRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetWorklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistRequestDescriptor = $convert.base64Decode(
    'ChJHZXRXb3JrbGlzdFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSGw'
    'oJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getWorklistResponseDescriptor instead')
const GetWorklistResponse$json = {
  '1': 'GetWorklistResponse',
  '2': [
    {
      '1': 'requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Request',
      '10': 'requests'
    },
  ],
};

/// Descriptor for `GetWorklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistResponseDescriptor = $convert.base64Decode(
    'ChNHZXRXb3JrbGlzdFJlc3BvbnNlEjwKCHJlcXVlc3RzGAEgAygLMiAuaGVhbHRoY2FyZS5ibG'
    '9vZGJhbmsudjEuUmVxdWVzdFIIcmVxdWVzdHM=');

@$core.Deprecated('Use listPatientRequestsRequestDescriptor instead')
const ListPatientRequestsRequest$json = {
  '1': 'ListPatientRequestsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPatientRequestsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientRequestsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UGF0aWVudFJlcXVlc3RzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW'
        '50SWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listPatientRequestsResponseDescriptor instead')
const ListPatientRequestsResponse$json = {
  '1': 'ListPatientRequestsResponse',
  '2': [
    {
      '1': 'requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Request',
      '10': 'requests'
    },
  ],
};

/// Descriptor for `ListPatientRequestsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientRequestsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UGF0aWVudFJlcXVlc3RzUmVzcG9uc2USPAoIcmVxdWVzdHMYASADKAsyIC5oZWFsdG'
        'hjYXJlLmJsb29kYmFuay52MS5SZXF1ZXN0UghyZXF1ZXN0cw==');

@$core.Deprecated('Use groupPatientRequestDescriptor instead')
const GroupPatientRequest$json = {
  '1': 'GroupPatientRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'sample_number', '3': 2, '4': 1, '5': 9, '10': 'sampleNumber'},
    {
      '1': 'group',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'group'
    },
    {
      '1': 'antibody_screen_positive',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'antibodyScreenPositive'
    },
    {'1': 'antibody_note', '3': 5, '4': 1, '5': 9, '10': 'antibodyNote'},
    {'1': 'second_check', '3': 6, '4': 1, '5': 8, '10': 'secondCheck'},
    {
      '1': 'collected_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'collected_by', '3': 8, '4': 1, '5': 9, '10': 'collectedBy'},
  ],
};

/// Descriptor for `GroupPatientRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupPatientRequestDescriptor = $convert.base64Decode(
    'ChNHcm91cFBhdGllbnRSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIjCg'
    '1zYW1wbGVfbnVtYmVyGAIgASgJUgxzYW1wbGVOdW1iZXISOQoFZ3JvdXAYAyABKAsyIy5oZWFs'
    'dGhjYXJlLmJsb29kYmFuay52MS5CbG9vZEdyb3VwUgVncm91cBI4ChhhbnRpYm9keV9zY3JlZW'
    '5fcG9zaXRpdmUYBCABKAhSFmFudGlib2R5U2NyZWVuUG9zaXRpdmUSIwoNYW50aWJvZHlfbm90'
    'ZRgFIAEoCVIMYW50aWJvZHlOb3RlEiEKDHNlY29uZF9jaGVjaxgGIAEoCFILc2Vjb25kQ2hlY2'
    'sSPQoMY29sbGVjdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29s'
    'bGVjdGVkQXQSIQoMY29sbGVjdGVkX2J5GAggASgJUgtjb2xsZWN0ZWRCeQ==');

@$core.Deprecated('Use groupPatientResponseDescriptor instead')
const GroupPatientResponse$json = {
  '1': 'GroupPatientResponse',
  '2': [
    {
      '1': 'sample',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.PatientSample',
      '10': 'sample'
    },
  ],
};

/// Descriptor for `GroupPatientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List groupPatientResponseDescriptor = $convert.base64Decode(
    'ChRHcm91cFBhdGllbnRSZXNwb25zZRI+CgZzYW1wbGUYASABKAsyJi5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5QYXRpZW50U2FtcGxlUgZzYW1wbGU=');

@$core.Deprecated('Use findCompatibleRequestDescriptor instead')
const FindCompatibleRequest$json = {
  '1': 'FindCompatibleRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `FindCompatibleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findCompatibleRequestDescriptor = $convert.base64Decode(
    'ChVGaW5kQ29tcGF0aWJsZVJlcXVlc3QSHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEh'
    'sKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use findCompatibleResponseDescriptor instead')
const FindCompatibleResponse$json = {
  '1': 'FindCompatibleResponse',
  '2': [
    {
      '1': 'candidates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Candidate',
      '10': 'candidates'
    },
  ],
};

/// Descriptor for `FindCompatibleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findCompatibleResponseDescriptor =
    $convert.base64Decode(
        'ChZGaW5kQ29tcGF0aWJsZVJlc3BvbnNlEkIKCmNhbmRpZGF0ZXMYASADKAsyIi5oZWFsdGhjYX'
        'JlLmJsb29kYmFuay52MS5DYW5kaWRhdGVSCmNhbmRpZGF0ZXM=');

@$core.Deprecated('Use reserveRequestDescriptor instead')
const ReserveRequest$json = {
  '1': 'ReserveRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'component_id', '3': 2, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'crossmatched', '3': 3, '4': 1, '5': 8, '10': 'crossmatched'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ReserveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reserveRequestDescriptor = $convert.base64Decode(
    'Cg5SZXNlcnZlUmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQSIQoMY29tcG'
    '9uZW50X2lkGAIgASgJUgtjb21wb25lbnRJZBIiCgxjcm9zc21hdGNoZWQYAyABKAhSDGNyb3Nz'
    'bWF0Y2hlZBISCgRub3RlGAQgASgJUgRub3Rl');

@$core.Deprecated('Use reserveResponseDescriptor instead')
const ReserveResponse$json = {
  '1': 'ReserveResponse',
  '2': [
    {
      '1': 'reservation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Reservation',
      '10': 'reservation'
    },
  ],
};

/// Descriptor for `ReserveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reserveResponseDescriptor = $convert.base64Decode(
    'Cg9SZXNlcnZlUmVzcG9uc2USRgoLcmVzZXJ2YXRpb24YASABKAsyJC5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5SZXNlcnZhdGlvblILcmVzZXJ2YXRpb24=');

@$core.Deprecated('Use releaseReservationRequestDescriptor instead')
const ReleaseReservationRequest$json = {
  '1': 'ReleaseReservationRequest',
  '2': [
    {'1': 'reservation_id', '3': 1, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReleaseReservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseReservationRequestDescriptor =
    $convert.base64Decode(
        'ChlSZWxlYXNlUmVzZXJ2YXRpb25SZXF1ZXN0EiUKDnJlc2VydmF0aW9uX2lkGAEgASgJUg1yZX'
        'NlcnZhdGlvbklkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use releaseReservationResponseDescriptor instead')
const ReleaseReservationResponse$json = {
  '1': 'ReleaseReservationResponse',
};

/// Descriptor for `ReleaseReservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseReservationResponseDescriptor =
    $convert.base64Decode('ChpSZWxlYXNlUmVzZXJ2YXRpb25SZXNwb25zZQ==');

@$core.Deprecated('Use sweepLapsedReservationsRequestDescriptor instead')
const SweepLapsedReservationsRequest$json = {
  '1': 'SweepLapsedReservationsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `SweepLapsedReservationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepLapsedReservationsRequestDescriptor =
    $convert.base64Decode(
        'Ch5Td2VlcExhcHNlZFJlc2VydmF0aW9uc1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYW'
        'dlU2l6ZQ==');

@$core.Deprecated('Use sweepLapsedReservationsResponseDescriptor instead')
const SweepLapsedReservationsResponse$json = {
  '1': 'SweepLapsedReservationsResponse',
  '2': [
    {'1': 'swept', '3': 1, '4': 1, '5': 5, '10': 'swept'},
  ],
};

/// Descriptor for `SweepLapsedReservationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepLapsedReservationsResponseDescriptor =
    $convert.base64Decode(
        'Ch9Td2VlcExhcHNlZFJlc2VydmF0aW9uc1Jlc3BvbnNlEhQKBXN3ZXB0GAEgASgFUgVzd2VwdA'
        '==');

@$core.Deprecated('Use issueUnitRequestDescriptor instead')
const IssueUnitRequest$json = {
  '1': 'IssueUnitRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'reservation_id', '3': 2, '4': 1, '5': 9, '10': 'reservationId'},
    {'1': 'destination', '3': 3, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'issued_to', '3': 4, '4': 1, '5': 9, '10': 'issuedTo'},
    {'1': 'check_unit_number', '3': 5, '4': 1, '5': 9, '10': 'checkUnitNumber'},
    {'1': 'check_patient_id', '3': 6, '4': 1, '5': 9, '10': 'checkPatientId'},
    {'1': 'emergency', '3': 7, '4': 1, '5': 8, '10': 'emergency'},
    {
      '1': 'emergency_authoriser',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'emergencyAuthoriser'
    },
    {'1': 'emergency_reason', '3': 9, '4': 1, '5': 9, '10': 'emergencyReason'},
  ],
};

/// Descriptor for `IssueUnitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueUnitRequestDescriptor = $convert.base64Decode(
    'ChBJc3N1ZVVuaXRSZXF1ZXN0EiEKDGNvbXBvbmVudF9pZBgBIAEoCVILY29tcG9uZW50SWQSJQ'
    'oOcmVzZXJ2YXRpb25faWQYAiABKAlSDXJlc2VydmF0aW9uSWQSIAoLZGVzdGluYXRpb24YAyAB'
    'KAlSC2Rlc3RpbmF0aW9uEhsKCWlzc3VlZF90bxgEIAEoCVIIaXNzdWVkVG8SKgoRY2hlY2tfdW'
    '5pdF9udW1iZXIYBSABKAlSD2NoZWNrVW5pdE51bWJlchIoChBjaGVja19wYXRpZW50X2lkGAYg'
    'ASgJUg5jaGVja1BhdGllbnRJZBIcCgllbWVyZ2VuY3kYByABKAhSCWVtZXJnZW5jeRIxChRlbW'
    'VyZ2VuY3lfYXV0aG9yaXNlchgIIAEoCVITZW1lcmdlbmN5QXV0aG9yaXNlchIpChBlbWVyZ2Vu'
    'Y3lfcmVhc29uGAkgASgJUg9lbWVyZ2VuY3lSZWFzb24=');

@$core.Deprecated('Use issueUnitResponseDescriptor instead')
const IssueUnitResponse$json = {
  '1': 'IssueUnitResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Issue',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `IssueUnitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueUnitResponseDescriptor = $convert.base64Decode(
    'ChFJc3N1ZVVuaXRSZXNwb25zZRI0CgVpc3N1ZRgBIAEoCzIeLmhlYWx0aGNhcmUuYmxvb2RiYW'
    '5rLnYxLklzc3VlUgVpc3N1ZQ==');

@$core.Deprecated('Use reconcileReleaseRequestDescriptor instead')
const ReconcileReleaseRequest$json = {
  '1': 'ReconcileReleaseRequest',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ReconcileReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileReleaseRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWNvbmNpbGVSZWxlYXNlUmVxdWVzdBIZCghpc3N1ZV9pZBgBIAEoCVIHaXNzdWVJZBISCg'
        'Rub3RlGAIgASgJUgRub3Rl');

@$core.Deprecated('Use reconcileReleaseResponseDescriptor instead')
const ReconcileReleaseResponse$json = {
  '1': 'ReconcileReleaseResponse',
};

/// Descriptor for `ReconcileReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileReleaseResponseDescriptor =
    $convert.base64Decode('ChhSZWNvbmNpbGVSZWxlYXNlUmVzcG9uc2U=');

@$core.Deprecated('Use listOutstandingReleasesRequestDescriptor instead')
const ListOutstandingReleasesRequest$json = {
  '1': 'ListOutstandingReleasesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOutstandingReleasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingReleasesRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0T3V0c3RhbmRpbmdSZWxlYXNlc1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYW'
        'dlU2l6ZQ==');

@$core.Deprecated('Use listOutstandingReleasesResponseDescriptor instead')
const ListOutstandingReleasesResponse$json = {
  '1': 'ListOutstandingReleasesResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Issue',
      '10': 'issues'
    },
  ],
};

/// Descriptor for `ListOutstandingReleasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingReleasesResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0T3V0c3RhbmRpbmdSZWxlYXNlc1Jlc3BvbnNlEjYKBmlzc3VlcxgBIAMoCzIeLmhlYW'
        'x0aGNhcmUuYmxvb2RiYW5rLnYxLklzc3VlUgZpc3N1ZXM=');

@$core.Deprecated('Use bedsideCheckDescriptor instead')
const BedsideCheck$json = {
  '1': 'BedsideCheck',
  '2': [
    {'1': 'unit_number', '3': 1, '4': 1, '5': 9, '10': 'unitNumber'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'patient_group',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'patientGroup'
    },
    {
      '1': 'unit_group',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BloodGroup',
      '10': 'unitGroup'
    },
    {'1': 'checked_with', '3': 5, '4': 1, '5': 9, '10': 'checkedWith'},
    {'1': 'encounter_id', '3': 6, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'baseline',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BedsideCheck.BaselineEntry',
      '10': 'baseline'
    },
  ],
  '3': [BedsideCheck_BaselineEntry$json],
};

@$core.Deprecated('Use bedsideCheckDescriptor instead')
const BedsideCheck_BaselineEntry$json = {
  '1': 'BaselineEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BedsideCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedsideCheckDescriptor = $convert.base64Decode(
    'CgxCZWRzaWRlQ2hlY2sSHwoLdW5pdF9udW1iZXIYASABKAlSCnVuaXROdW1iZXISHQoKcGF0aW'
    'VudF9pZBgCIAEoCVIJcGF0aWVudElkEkgKDXBhdGllbnRfZ3JvdXAYAyABKAsyIy5oZWFsdGhj'
    'YXJlLmJsb29kYmFuay52MS5CbG9vZEdyb3VwUgxwYXRpZW50R3JvdXASQgoKdW5pdF9ncm91cB'
    'gEIAEoCzIjLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkJsb29kR3JvdXBSCXVuaXRHcm91cBIh'
    'CgxjaGVja2VkX3dpdGgYBSABKAlSC2NoZWNrZWRXaXRoEiEKDGVuY291bnRlcl9pZBgGIAEoCV'
    'ILZW5jb3VudGVySWQSTwoIYmFzZWxpbmUYByADKAsyMy5oZWFsdGhjYXJlLmJsb29kYmFuay52'
    'MS5CZWRzaWRlQ2hlY2suQmFzZWxpbmVFbnRyeVIIYmFzZWxpbmUaOwoNQmFzZWxpbmVFbnRyeR'
    'IQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6AjgB');

@$core.Deprecated('Use verifyBedsideRequestDescriptor instead')
const VerifyBedsideRequest$json = {
  '1': 'VerifyBedsideRequest',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BedsideCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `VerifyBedsideRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyBedsideRequestDescriptor = $convert.base64Decode(
    'ChRWZXJpZnlCZWRzaWRlUmVxdWVzdBI7CgVjaGVjaxgBIAEoCzIlLmhlYWx0aGNhcmUuYmxvb2'
    'RiYW5rLnYxLkJlZHNpZGVDaGVja1IFY2hlY2s=');

@$core.Deprecated('Use verifyBedsideResponseDescriptor instead')
const VerifyBedsideResponse$json = {
  '1': 'VerifyBedsideResponse',
  '2': [
    {'1': 'passed', '3': 1, '4': 1, '5': 8, '10': 'passed'},
    {
      '1': 'refusals',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.BedsideRefusal',
      '10': 'refusals'
    },
    {'1': 'explanations', '3': 3, '4': 3, '5': 9, '10': 'explanations'},
  ],
};

/// Descriptor for `VerifyBedsideResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyBedsideResponseDescriptor = $convert.base64Decode(
    'ChVWZXJpZnlCZWRzaWRlUmVzcG9uc2USFgoGcGFzc2VkGAEgASgIUgZwYXNzZWQSQwoIcmVmdX'
    'NhbHMYAiADKA4yJy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5CZWRzaWRlUmVmdXNhbFIIcmVm'
    'dXNhbHMSIgoMZXhwbGFuYXRpb25zGAMgAygJUgxleHBsYW5hdGlvbnM=');

@$core.Deprecated('Use startTransfusionRequestDescriptor instead')
const StartTransfusionRequest$json = {
  '1': 'StartTransfusionRequest',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.BedsideCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `StartTransfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTransfusionRequestDescriptor =
    $convert.base64Decode(
        'ChdTdGFydFRyYW5zZnVzaW9uUmVxdWVzdBI7CgVjaGVjaxgBIAEoCzIlLmhlYWx0aGNhcmUuYm'
        'xvb2RiYW5rLnYxLkJlZHNpZGVDaGVja1IFY2hlY2s=');

@$core.Deprecated('Use startTransfusionResponseDescriptor instead')
const StartTransfusionResponse$json = {
  '1': 'StartTransfusionResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Episode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `StartTransfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTransfusionResponseDescriptor =
    $convert.base64Decode(
        'ChhTdGFydFRyYW5zZnVzaW9uUmVzcG9uc2USOgoHZXBpc29kZRgBIAEoCzIgLmhlYWx0aGNhcm'
        'UuYmxvb2RiYW5rLnYxLkVwaXNvZGVSB2VwaXNvZGU=');

@$core.Deprecated('Use observeRequestDescriptor instead')
const ObserveRequest$json = {
  '1': 'ObserveRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'timing', '3': 2, '4': 1, '5': 9, '10': 'timing'},
    {
      '1': 'values',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.ObserveRequest.ValuesEntry',
      '10': 'values'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
  '3': [ObserveRequest_ValuesEntry$json],
};

@$core.Deprecated('Use observeRequestDescriptor instead')
const ObserveRequest_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ObserveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeRequestDescriptor = $convert.base64Decode(
    'Cg5PYnNlcnZlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSFgoGdGltaW'
    '5nGAIgASgJUgZ0aW1pbmcSSwoGdmFsdWVzGAMgAygLMjMuaGVhbHRoY2FyZS5ibG9vZGJhbmsu'
    'djEuT2JzZXJ2ZVJlcXVlc3QuVmFsdWVzRW50cnlSBnZhbHVlcxISCgRub3RlGAQgASgJUgRub3'
    'RlGjkKC1ZhbHVlc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1'
    'ZToCOAE=');

@$core.Deprecated('Use observeResponseDescriptor instead')
const ObserveResponse$json = {
  '1': 'ObserveResponse',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Observation',
      '10': 'observation'
    },
  ],
};

/// Descriptor for `ObserveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeResponseDescriptor = $convert.base64Decode(
    'Cg9PYnNlcnZlUmVzcG9uc2USRgoLb2JzZXJ2YXRpb24YASABKAsyJC5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5PYnNlcnZhdGlvblILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use endTransfusionRequestDescriptor instead')
const EndTransfusionRequest$json = {
  '1': 'EndTransfusionRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'volume_given_ml', '3': 2, '4': 1, '5': 5, '10': 'volumeGivenMl'},
    {'1': 'stop_reason', '3': 3, '4': 1, '5': 9, '10': 'stopReason'},
  ],
};

/// Descriptor for `EndTransfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endTransfusionRequestDescriptor = $convert.base64Decode(
    'ChVFbmRUcmFuc2Z1c2lvblJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEi'
    'YKD3ZvbHVtZV9naXZlbl9tbBgCIAEoBVINdm9sdW1lR2l2ZW5NbBIfCgtzdG9wX3JlYXNvbhgD'
    'IAEoCVIKc3RvcFJlYXNvbg==');

@$core.Deprecated('Use endTransfusionResponseDescriptor instead')
const EndTransfusionResponse$json = {
  '1': 'EndTransfusionResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Episode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `EndTransfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endTransfusionResponseDescriptor =
    $convert.base64Decode(
        'ChZFbmRUcmFuc2Z1c2lvblJlc3BvbnNlEjoKB2VwaXNvZGUYASABKAsyIC5oZWFsdGhjYXJlLm'
        'Jsb29kYmFuay52MS5FcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use getEpisodeRequestDescriptor instead')
const GetEpisodeRequest$json = {
  '1': 'GetEpisodeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `GetEpisodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEpisodeRequestDescriptor = $convert.base64Decode(
    'ChFHZXRFcGlzb2RlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQ=');

@$core.Deprecated('Use getEpisodeResponseDescriptor instead')
const GetEpisodeResponse$json = {
  '1': 'GetEpisodeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Episode',
      '10': 'episode'
    },
    {
      '1': 'missing_observations',
      '3': 2,
      '4': 3,
      '5': 9,
      '10': 'missingObservations'
    },
  ],
};

/// Descriptor for `GetEpisodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEpisodeResponseDescriptor = $convert.base64Decode(
    'ChJHZXRFcGlzb2RlUmVzcG9uc2USOgoHZXBpc29kZRgBIAEoCzIgLmhlYWx0aGNhcmUuYmxvb2'
    'RiYW5rLnYxLkVwaXNvZGVSB2VwaXNvZGUSMQoUbWlzc2luZ19vYnNlcnZhdGlvbnMYAiADKAlS'
    'E21pc3NpbmdPYnNlcnZhdGlvbnM=');

@$core.Deprecated('Use listPatientTransfusionsRequestDescriptor instead')
const ListPatientTransfusionsRequest$json = {
  '1': 'ListPatientTransfusionsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPatientTransfusionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientTransfusionsRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0UGF0aWVudFRyYW5zZnVzaW9uc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcG'
        'F0aWVudElkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listPatientTransfusionsResponseDescriptor instead')
const ListPatientTransfusionsResponse$json = {
  '1': 'ListPatientTransfusionsResponse',
  '2': [
    {
      '1': 'episodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Episode',
      '10': 'episodes'
    },
  ],
};

/// Descriptor for `ListPatientTransfusionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientTransfusionsResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0UGF0aWVudFRyYW5zZnVzaW9uc1Jlc3BvbnNlEjwKCGVwaXNvZGVzGAEgAygLMiAuaG'
        'VhbHRoY2FyZS5ibG9vZGJhbmsudjEuRXBpc29kZVIIZXBpc29kZXM=');

@$core.Deprecated('Use reportReactionRequestDescriptor instead')
const ReportReactionRequest$json = {
  '1': 'ReportReactionRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'component_id', '3': 2, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'severity',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.bloodbank.v1.ReactionSeverity',
      '10': 'severity'
    },
    {'1': 'features', '3': 5, '4': 3, '5': 9, '10': 'features'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {'1': 'action_taken', '3': 7, '4': 1, '5': 9, '10': 'actionTaken'},
    {'1': 'volume_given_ml', '3': 8, '4': 1, '5': 5, '10': 'volumeGivenMl'},
  ],
};

/// Descriptor for `ReportReactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportReactionRequestDescriptor = $convert.base64Decode(
    'ChVSZXBvcnRSZWFjdGlvblJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEi'
    'EKDGNvbXBvbmVudF9pZBgCIAEoCVILY29tcG9uZW50SWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJ'
    'cGF0aWVudElkEkUKCHNldmVyaXR5GAQgASgOMikuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUm'
    'VhY3Rpb25TZXZlcml0eVIIc2V2ZXJpdHkSGgoIZmVhdHVyZXMYBSADKAlSCGZlYXR1cmVzEhIK'
    'BG5vdGUYBiABKAlSBG5vdGUSIQoMYWN0aW9uX3Rha2VuGAcgASgJUgthY3Rpb25UYWtlbhImCg'
    '92b2x1bWVfZ2l2ZW5fbWwYCCABKAVSDXZvbHVtZUdpdmVuTWw=');

@$core.Deprecated('Use reportReactionResponseDescriptor instead')
const ReportReactionResponse$json = {
  '1': 'ReportReactionResponse',
  '2': [
    {
      '1': 'reaction',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Reaction',
      '10': 'reaction'
    },
  ],
};

/// Descriptor for `ReportReactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportReactionResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXBvcnRSZWFjdGlvblJlc3BvbnNlEj0KCHJlYWN0aW9uGAEgASgLMiEuaGVhbHRoY2FyZS'
        '5ibG9vZGJhbmsudjEuUmVhY3Rpb25SCHJlYWN0aW9u');

@$core.Deprecated('Use concludeInvestigationRequestDescriptor instead')
const ConcludeInvestigationRequest$json = {
  '1': 'ConcludeInvestigationRequest',
  '2': [
    {'1': 'reaction_id', '3': 1, '4': 1, '5': 9, '10': 'reactionId'},
    {'1': 'classification', '3': 2, '4': 1, '5': 9, '10': 'classification'},
    {'1': 'conclusion', '3': 3, '4': 1, '5': 9, '10': 'conclusion'},
    {'1': 'unit_returned', '3': 4, '4': 1, '5': 8, '10': 'unitReturned'},
  ],
};

/// Descriptor for `ConcludeInvestigationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List concludeInvestigationRequestDescriptor = $convert.base64Decode(
    'ChxDb25jbHVkZUludmVzdGlnYXRpb25SZXF1ZXN0Eh8KC3JlYWN0aW9uX2lkGAEgASgJUgpyZW'
    'FjdGlvbklkEiYKDmNsYXNzaWZpY2F0aW9uGAIgASgJUg5jbGFzc2lmaWNhdGlvbhIeCgpjb25j'
    'bHVzaW9uGAMgASgJUgpjb25jbHVzaW9uEiMKDXVuaXRfcmV0dXJuZWQYBCABKAhSDHVuaXRSZX'
    'R1cm5lZA==');

@$core.Deprecated('Use concludeInvestigationResponseDescriptor instead')
const ConcludeInvestigationResponse$json = {
  '1': 'ConcludeInvestigationResponse',
  '2': [
    {
      '1': 'reaction',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Reaction',
      '10': 'reaction'
    },
  ],
};

/// Descriptor for `ConcludeInvestigationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List concludeInvestigationResponseDescriptor =
    $convert.base64Decode(
        'Ch1Db25jbHVkZUludmVzdGlnYXRpb25SZXNwb25zZRI9CghyZWFjdGlvbhgBIAEoCzIhLmhlYW'
        'x0aGNhcmUuYmxvb2RiYW5rLnYxLlJlYWN0aW9uUghyZWFjdGlvbg==');

@$core.Deprecated('Use listOpenInvestigationsRequestDescriptor instead')
const ListOpenInvestigationsRequest$json = {
  '1': 'ListOpenInvestigationsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOpenInvestigationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenInvestigationsRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0T3BlbkludmVzdGlnYXRpb25zUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2'
        'VTaXpl');

@$core.Deprecated('Use listOpenInvestigationsResponseDescriptor instead')
const ListOpenInvestigationsResponse$json = {
  '1': 'ListOpenInvestigationsResponse',
  '2': [
    {
      '1': 'reactions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Reaction',
      '10': 'reactions'
    },
  ],
};

/// Descriptor for `ListOpenInvestigationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenInvestigationsResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0T3BlbkludmVzdGlnYXRpb25zUmVzcG9uc2USPwoJcmVhY3Rpb25zGAEgAygLMiEuaG'
        'VhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVhY3Rpb25SCXJlYWN0aW9ucw==');

@$core.Deprecated('Use traceUnitRequestDescriptor instead')
const TraceUnitRequest$json = {
  '1': 'TraceUnitRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
  ],
};

/// Descriptor for `TraceUnitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceUnitRequestDescriptor = $convert.base64Decode(
    'ChBUcmFjZVVuaXRSZXF1ZXN0EiEKDGNvbXBvbmVudF9pZBgBIAEoCVILY29tcG9uZW50SWQ=');

@$core.Deprecated('Use traceUnitResponseDescriptor instead')
const TraceUnitResponse$json = {
  '1': 'TraceUnitResponse',
  '2': [
    {
      '1': 'chain',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Chain',
      '10': 'chain'
    },
  ],
};

/// Descriptor for `TraceUnitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceUnitResponseDescriptor = $convert.base64Decode(
    'ChFUcmFjZVVuaXRSZXNwb25zZRI0CgVjaGFpbhgBIAEoCzIeLmhlYWx0aGNhcmUuYmxvb2RiYW'
    '5rLnYxLkNoYWluUgVjaGFpbg==');

@$core.Deprecated('Use lookBackRequestDescriptor instead')
const LookBackRequest$json = {
  '1': 'LookBackRequest',
  '2': [
    {'1': 'donor_id', '3': 1, '4': 1, '5': 9, '10': 'donorId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `LookBackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lookBackRequestDescriptor = $convert.base64Decode(
    'Cg9Mb29rQmFja1JlcXVlc3QSGQoIZG9ub3JfaWQYASABKAlSB2Rvbm9ySWQSGwoJcGFnZV9zaX'
    'plGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use lookBackResponseDescriptor instead')
const LookBackResponse$json = {
  '1': 'LookBackResponse',
  '2': [
    {
      '1': 'recipients',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Recipient',
      '10': 'recipients'
    },
  ],
};

/// Descriptor for `LookBackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lookBackResponseDescriptor = $convert.base64Decode(
    'ChBMb29rQmFja1Jlc3BvbnNlEkIKCnJlY2lwaWVudHMYASADKAsyIi5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5SZWNpcGllbnRSCnJlY2lwaWVudHM=');

@$core.Deprecated('Use setThresholdRequestDescriptor instead')
const SetThresholdRequest$json = {
  '1': 'SetThresholdRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'threshold',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.StockThreshold',
      '10': 'threshold'
    },
  ],
};

/// Descriptor for `SetThresholdRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setThresholdRequestDescriptor = $convert.base64Decode(
    'ChNTZXRUaHJlc2hvbGRSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eUlkEk'
    'UKCXRocmVzaG9sZBgCIAEoCzInLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlN0b2NrVGhyZXNo'
    'b2xkUgl0aHJlc2hvbGQ=');

@$core.Deprecated('Use setThresholdResponseDescriptor instead')
const SetThresholdResponse$json = {
  '1': 'SetThresholdResponse',
};

/// Descriptor for `SetThresholdResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setThresholdResponseDescriptor =
    $convert.base64Decode('ChRTZXRUaHJlc2hvbGRSZXNwb25zZQ==');

@$core.Deprecated('Use getStockRequestDescriptor instead')
const GetStockRequest$json = {
  '1': 'GetStockRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetStockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStockRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTdG9ja1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getStockResponseDescriptor instead')
const GetStockResponse$json = {
  '1': 'GetStockResponse',
  '2': [
    {
      '1': 'levels',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.StockLevel',
      '10': 'levels'
    },
    {
      '1': 'alerts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.StockAlert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `GetStockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStockResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdG9ja1Jlc3BvbnNlEjsKBmxldmVscxgBIAMoCzIjLmhlYWx0aGNhcmUuYmxvb2RiYW'
    '5rLnYxLlN0b2NrTGV2ZWxSBmxldmVscxI7CgZhbGVydHMYAiADKAsyIy5oZWFsdGhjYXJlLmJs'
    'b29kYmFuay52MS5TdG9ja0FsZXJ0UgZhbGVydHM=');

@$core.Deprecated('Use getUtilisationRequestDescriptor instead')
const GetUtilisationRequest$json = {
  '1': 'GetUtilisationRequest',
  '2': [
    {
      '1': 'period_start',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
  ],
};

/// Descriptor for `GetUtilisationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUtilisationRequestDescriptor = $convert.base64Decode(
    'ChVHZXRVdGlsaXNhdGlvblJlcXVlc3QSPQoMcGVyaW9kX3N0YXJ0GAEgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFILcGVyaW9kU3RhcnQSOQoKcGVyaW9kX2VuZBgCIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXBlcmlvZEVuZA==');

@$core.Deprecated('Use getUtilisationResponseDescriptor instead')
const GetUtilisationResponse$json = {
  '1': 'GetUtilisationResponse',
  '2': [
    {
      '1': 'utilisation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.bloodbank.v1.Utilisation',
      '10': 'utilisation'
    },
  ],
};

/// Descriptor for `GetUtilisationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUtilisationResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRVdGlsaXNhdGlvblJlc3BvbnNlEkYKC3V0aWxpc2F0aW9uGAEgASgLMiQuaGVhbHRoY2'
        'FyZS5ibG9vZGJhbmsudjEuVXRpbGlzYXRpb25SC3V0aWxpc2F0aW9u');

const $core.Map<$core.String, $core.dynamic> BloodBankServiceBase$json = {
  '1': 'BloodBankService',
  '2': [
    {
      '1': 'RegisterDonor',
      '2': '.healthcare.bloodbank.v1.RegisterDonorRequest',
      '3': '.healthcare.bloodbank.v1.RegisterDonorResponse'
    },
    {
      '1': 'GetDonor',
      '2': '.healthcare.bloodbank.v1.GetDonorRequest',
      '3': '.healthcare.bloodbank.v1.GetDonorResponse'
    },
    {
      '1': 'DeferDonor',
      '2': '.healthcare.bloodbank.v1.DeferDonorRequest',
      '3': '.healthcare.bloodbank.v1.DeferDonorResponse'
    },
    {
      '1': 'ReinstateDonor',
      '2': '.healthcare.bloodbank.v1.ReinstateDonorRequest',
      '3': '.healthcare.bloodbank.v1.ReinstateDonorResponse'
    },
    {
      '1': 'ListDeferredDonors',
      '2': '.healthcare.bloodbank.v1.ListDeferredDonorsRequest',
      '3': '.healthcare.bloodbank.v1.ListDeferredDonorsResponse'
    },
    {
      '1': 'ScreenDonor',
      '2': '.healthcare.bloodbank.v1.ScreenDonorRequest',
      '3': '.healthcare.bloodbank.v1.ScreenDonorResponse'
    },
    {
      '1': 'Collect',
      '2': '.healthcare.bloodbank.v1.CollectRequest',
      '3': '.healthcare.bloodbank.v1.CollectResponse'
    },
    {
      '1': 'RecordTest',
      '2': '.healthcare.bloodbank.v1.RecordTestRequest',
      '3': '.healthcare.bloodbank.v1.RecordTestResponse'
    },
    {
      '1': 'GetReleaseDecision',
      '2': '.healthcare.bloodbank.v1.GetReleaseDecisionRequest',
      '3': '.healthcare.bloodbank.v1.GetReleaseDecisionResponse'
    },
    {
      '1': 'ReleaseComponents',
      '2': '.healthcare.bloodbank.v1.ReleaseComponentsRequest',
      '3': '.healthcare.bloodbank.v1.ReleaseComponentsResponse'
    },
    {
      '1': 'AddComponent',
      '2': '.healthcare.bloodbank.v1.AddComponentRequest',
      '3': '.healthcare.bloodbank.v1.AddComponentResponse'
    },
    {
      '1': 'GetComponent',
      '2': '.healthcare.bloodbank.v1.GetComponentRequest',
      '3': '.healthcare.bloodbank.v1.GetComponentResponse'
    },
    {
      '1': 'DiscardComponent',
      '2': '.healthcare.bloodbank.v1.DiscardComponentRequest',
      '3': '.healthcare.bloodbank.v1.DiscardComponentResponse'
    },
    {
      '1': 'PlaceRequest',
      '2': '.healthcare.bloodbank.v1.PlaceRequestRequest',
      '3': '.healthcare.bloodbank.v1.PlaceRequestResponse'
    },
    {
      '1': 'GetWorklist',
      '2': '.healthcare.bloodbank.v1.GetWorklistRequest',
      '3': '.healthcare.bloodbank.v1.GetWorklistResponse'
    },
    {
      '1': 'ListPatientRequests',
      '2': '.healthcare.bloodbank.v1.ListPatientRequestsRequest',
      '3': '.healthcare.bloodbank.v1.ListPatientRequestsResponse'
    },
    {
      '1': 'GroupPatient',
      '2': '.healthcare.bloodbank.v1.GroupPatientRequest',
      '3': '.healthcare.bloodbank.v1.GroupPatientResponse'
    },
    {
      '1': 'FindCompatible',
      '2': '.healthcare.bloodbank.v1.FindCompatibleRequest',
      '3': '.healthcare.bloodbank.v1.FindCompatibleResponse'
    },
    {
      '1': 'Reserve',
      '2': '.healthcare.bloodbank.v1.ReserveRequest',
      '3': '.healthcare.bloodbank.v1.ReserveResponse'
    },
    {
      '1': 'ReleaseReservation',
      '2': '.healthcare.bloodbank.v1.ReleaseReservationRequest',
      '3': '.healthcare.bloodbank.v1.ReleaseReservationResponse'
    },
    {
      '1': 'SweepLapsedReservations',
      '2': '.healthcare.bloodbank.v1.SweepLapsedReservationsRequest',
      '3': '.healthcare.bloodbank.v1.SweepLapsedReservationsResponse'
    },
    {
      '1': 'IssueUnit',
      '2': '.healthcare.bloodbank.v1.IssueUnitRequest',
      '3': '.healthcare.bloodbank.v1.IssueUnitResponse'
    },
    {
      '1': 'ReconcileRelease',
      '2': '.healthcare.bloodbank.v1.ReconcileReleaseRequest',
      '3': '.healthcare.bloodbank.v1.ReconcileReleaseResponse'
    },
    {
      '1': 'ListOutstandingReleases',
      '2': '.healthcare.bloodbank.v1.ListOutstandingReleasesRequest',
      '3': '.healthcare.bloodbank.v1.ListOutstandingReleasesResponse'
    },
    {
      '1': 'VerifyBedside',
      '2': '.healthcare.bloodbank.v1.VerifyBedsideRequest',
      '3': '.healthcare.bloodbank.v1.VerifyBedsideResponse'
    },
    {
      '1': 'StartTransfusion',
      '2': '.healthcare.bloodbank.v1.StartTransfusionRequest',
      '3': '.healthcare.bloodbank.v1.StartTransfusionResponse'
    },
    {
      '1': 'Observe',
      '2': '.healthcare.bloodbank.v1.ObserveRequest',
      '3': '.healthcare.bloodbank.v1.ObserveResponse'
    },
    {
      '1': 'EndTransfusion',
      '2': '.healthcare.bloodbank.v1.EndTransfusionRequest',
      '3': '.healthcare.bloodbank.v1.EndTransfusionResponse'
    },
    {
      '1': 'GetEpisode',
      '2': '.healthcare.bloodbank.v1.GetEpisodeRequest',
      '3': '.healthcare.bloodbank.v1.GetEpisodeResponse'
    },
    {
      '1': 'ListPatientTransfusions',
      '2': '.healthcare.bloodbank.v1.ListPatientTransfusionsRequest',
      '3': '.healthcare.bloodbank.v1.ListPatientTransfusionsResponse'
    },
    {
      '1': 'ReportReaction',
      '2': '.healthcare.bloodbank.v1.ReportReactionRequest',
      '3': '.healthcare.bloodbank.v1.ReportReactionResponse'
    },
    {
      '1': 'ConcludeInvestigation',
      '2': '.healthcare.bloodbank.v1.ConcludeInvestigationRequest',
      '3': '.healthcare.bloodbank.v1.ConcludeInvestigationResponse'
    },
    {
      '1': 'ListOpenInvestigations',
      '2': '.healthcare.bloodbank.v1.ListOpenInvestigationsRequest',
      '3': '.healthcare.bloodbank.v1.ListOpenInvestigationsResponse'
    },
    {
      '1': 'TraceUnit',
      '2': '.healthcare.bloodbank.v1.TraceUnitRequest',
      '3': '.healthcare.bloodbank.v1.TraceUnitResponse'
    },
    {
      '1': 'LookBack',
      '2': '.healthcare.bloodbank.v1.LookBackRequest',
      '3': '.healthcare.bloodbank.v1.LookBackResponse'
    },
    {
      '1': 'SetThreshold',
      '2': '.healthcare.bloodbank.v1.SetThresholdRequest',
      '3': '.healthcare.bloodbank.v1.SetThresholdResponse'
    },
    {
      '1': 'GetStock',
      '2': '.healthcare.bloodbank.v1.GetStockRequest',
      '3': '.healthcare.bloodbank.v1.GetStockResponse'
    },
    {
      '1': 'GetUtilisation',
      '2': '.healthcare.bloodbank.v1.GetUtilisationRequest',
      '3': '.healthcare.bloodbank.v1.GetUtilisationResponse'
    },
  ],
};

@$core.Deprecated('Use bloodBankServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BloodBankServiceBase$messageJson = {
  '.healthcare.bloodbank.v1.RegisterDonorRequest': RegisterDonorRequest$json,
  '.healthcare.bloodbank.v1.BloodGroup': BloodGroup$json,
  '.healthcare.bloodbank.v1.RegisterDonorResponse': RegisterDonorResponse$json,
  '.healthcare.bloodbank.v1.Donor': Donor$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.bloodbank.v1.GetDonorRequest': GetDonorRequest$json,
  '.healthcare.bloodbank.v1.GetDonorResponse': GetDonorResponse$json,
  '.healthcare.bloodbank.v1.DeferDonorRequest': DeferDonorRequest$json,
  '.healthcare.bloodbank.v1.DeferDonorResponse': DeferDonorResponse$json,
  '.healthcare.bloodbank.v1.ReinstateDonorRequest': ReinstateDonorRequest$json,
  '.healthcare.bloodbank.v1.ReinstateDonorResponse':
      ReinstateDonorResponse$json,
  '.healthcare.bloodbank.v1.ListDeferredDonorsRequest':
      ListDeferredDonorsRequest$json,
  '.healthcare.bloodbank.v1.ListDeferredDonorsResponse':
      ListDeferredDonorsResponse$json,
  '.healthcare.bloodbank.v1.ScreenDonorRequest': ScreenDonorRequest$json,
  '.healthcare.bloodbank.v1.ScreenDonorRequest.AnswersEntry':
      ScreenDonorRequest_AnswersEntry$json,
  '.healthcare.bloodbank.v1.ScreenDonorRequest.MeasurementsEntry':
      ScreenDonorRequest_MeasurementsEntry$json,
  '.healthcare.bloodbank.v1.ScreenDonorResponse': ScreenDonorResponse$json,
  '.healthcare.bloodbank.v1.Screening': Screening$json,
  '.healthcare.bloodbank.v1.Screening.AnswersEntry':
      Screening_AnswersEntry$json,
  '.healthcare.bloodbank.v1.Screening.MeasurementsEntry':
      Screening_MeasurementsEntry$json,
  '.healthcare.bloodbank.v1.CollectRequest': CollectRequest$json,
  '.healthcare.bloodbank.v1.CollectResponse': CollectResponse$json,
  '.healthcare.bloodbank.v1.Collection': Collection$json,
  '.healthcare.bloodbank.v1.RecordTestRequest': RecordTestRequest$json,
  '.healthcare.bloodbank.v1.RecordTestResponse': RecordTestResponse$json,
  '.healthcare.bloodbank.v1.TestResult': TestResult$json,
  '.healthcare.bloodbank.v1.GetReleaseDecisionRequest':
      GetReleaseDecisionRequest$json,
  '.healthcare.bloodbank.v1.GetReleaseDecisionResponse':
      GetReleaseDecisionResponse$json,
  '.healthcare.bloodbank.v1.ReleaseDecision': ReleaseDecision$json,
  '.healthcare.bloodbank.v1.ReleaseComponentsRequest':
      ReleaseComponentsRequest$json,
  '.healthcare.bloodbank.v1.ReleaseComponentsResponse':
      ReleaseComponentsResponse$json,
  '.healthcare.bloodbank.v1.Component': Component$json,
  '.healthcare.bloodbank.v1.AddComponentRequest': AddComponentRequest$json,
  '.healthcare.bloodbank.v1.AddComponentResponse': AddComponentResponse$json,
  '.healthcare.bloodbank.v1.GetComponentRequest': GetComponentRequest$json,
  '.healthcare.bloodbank.v1.GetComponentResponse': GetComponentResponse$json,
  '.healthcare.bloodbank.v1.DiscardComponentRequest':
      DiscardComponentRequest$json,
  '.healthcare.bloodbank.v1.DiscardComponentResponse':
      DiscardComponentResponse$json,
  '.healthcare.bloodbank.v1.PlaceRequestRequest': PlaceRequestRequest$json,
  '.healthcare.bloodbank.v1.PlaceRequestResponse': PlaceRequestResponse$json,
  '.healthcare.bloodbank.v1.Request': Request$json,
  '.healthcare.bloodbank.v1.GetWorklistRequest': GetWorklistRequest$json,
  '.healthcare.bloodbank.v1.GetWorklistResponse': GetWorklistResponse$json,
  '.healthcare.bloodbank.v1.ListPatientRequestsRequest':
      ListPatientRequestsRequest$json,
  '.healthcare.bloodbank.v1.ListPatientRequestsResponse':
      ListPatientRequestsResponse$json,
  '.healthcare.bloodbank.v1.GroupPatientRequest': GroupPatientRequest$json,
  '.healthcare.bloodbank.v1.GroupPatientResponse': GroupPatientResponse$json,
  '.healthcare.bloodbank.v1.PatientSample': PatientSample$json,
  '.healthcare.bloodbank.v1.FindCompatibleRequest': FindCompatibleRequest$json,
  '.healthcare.bloodbank.v1.FindCompatibleResponse':
      FindCompatibleResponse$json,
  '.healthcare.bloodbank.v1.Candidate': Candidate$json,
  '.healthcare.bloodbank.v1.MatchDecision': MatchDecision$json,
  '.healthcare.bloodbank.v1.ReserveRequest': ReserveRequest$json,
  '.healthcare.bloodbank.v1.ReserveResponse': ReserveResponse$json,
  '.healthcare.bloodbank.v1.Reservation': Reservation$json,
  '.healthcare.bloodbank.v1.ReleaseReservationRequest':
      ReleaseReservationRequest$json,
  '.healthcare.bloodbank.v1.ReleaseReservationResponse':
      ReleaseReservationResponse$json,
  '.healthcare.bloodbank.v1.SweepLapsedReservationsRequest':
      SweepLapsedReservationsRequest$json,
  '.healthcare.bloodbank.v1.SweepLapsedReservationsResponse':
      SweepLapsedReservationsResponse$json,
  '.healthcare.bloodbank.v1.IssueUnitRequest': IssueUnitRequest$json,
  '.healthcare.bloodbank.v1.IssueUnitResponse': IssueUnitResponse$json,
  '.healthcare.bloodbank.v1.Issue': Issue$json,
  '.healthcare.bloodbank.v1.ReconcileReleaseRequest':
      ReconcileReleaseRequest$json,
  '.healthcare.bloodbank.v1.ReconcileReleaseResponse':
      ReconcileReleaseResponse$json,
  '.healthcare.bloodbank.v1.ListOutstandingReleasesRequest':
      ListOutstandingReleasesRequest$json,
  '.healthcare.bloodbank.v1.ListOutstandingReleasesResponse':
      ListOutstandingReleasesResponse$json,
  '.healthcare.bloodbank.v1.VerifyBedsideRequest': VerifyBedsideRequest$json,
  '.healthcare.bloodbank.v1.BedsideCheck': BedsideCheck$json,
  '.healthcare.bloodbank.v1.BedsideCheck.BaselineEntry':
      BedsideCheck_BaselineEntry$json,
  '.healthcare.bloodbank.v1.VerifyBedsideResponse': VerifyBedsideResponse$json,
  '.healthcare.bloodbank.v1.StartTransfusionRequest':
      StartTransfusionRequest$json,
  '.healthcare.bloodbank.v1.StartTransfusionResponse':
      StartTransfusionResponse$json,
  '.healthcare.bloodbank.v1.Episode': Episode$json,
  '.healthcare.bloodbank.v1.Observation': Observation$json,
  '.healthcare.bloodbank.v1.Observation.ValuesEntry':
      Observation_ValuesEntry$json,
  '.healthcare.bloodbank.v1.ObserveRequest': ObserveRequest$json,
  '.healthcare.bloodbank.v1.ObserveRequest.ValuesEntry':
      ObserveRequest_ValuesEntry$json,
  '.healthcare.bloodbank.v1.ObserveResponse': ObserveResponse$json,
  '.healthcare.bloodbank.v1.EndTransfusionRequest': EndTransfusionRequest$json,
  '.healthcare.bloodbank.v1.EndTransfusionResponse':
      EndTransfusionResponse$json,
  '.healthcare.bloodbank.v1.GetEpisodeRequest': GetEpisodeRequest$json,
  '.healthcare.bloodbank.v1.GetEpisodeResponse': GetEpisodeResponse$json,
  '.healthcare.bloodbank.v1.ListPatientTransfusionsRequest':
      ListPatientTransfusionsRequest$json,
  '.healthcare.bloodbank.v1.ListPatientTransfusionsResponse':
      ListPatientTransfusionsResponse$json,
  '.healthcare.bloodbank.v1.ReportReactionRequest': ReportReactionRequest$json,
  '.healthcare.bloodbank.v1.ReportReactionResponse':
      ReportReactionResponse$json,
  '.healthcare.bloodbank.v1.Reaction': Reaction$json,
  '.healthcare.bloodbank.v1.ConcludeInvestigationRequest':
      ConcludeInvestigationRequest$json,
  '.healthcare.bloodbank.v1.ConcludeInvestigationResponse':
      ConcludeInvestigationResponse$json,
  '.healthcare.bloodbank.v1.ListOpenInvestigationsRequest':
      ListOpenInvestigationsRequest$json,
  '.healthcare.bloodbank.v1.ListOpenInvestigationsResponse':
      ListOpenInvestigationsResponse$json,
  '.healthcare.bloodbank.v1.TraceUnitRequest': TraceUnitRequest$json,
  '.healthcare.bloodbank.v1.TraceUnitResponse': TraceUnitResponse$json,
  '.healthcare.bloodbank.v1.Chain': Chain$json,
  '.healthcare.bloodbank.v1.ChainLink': ChainLink$json,
  '.healthcare.bloodbank.v1.LookBackRequest': LookBackRequest$json,
  '.healthcare.bloodbank.v1.LookBackResponse': LookBackResponse$json,
  '.healthcare.bloodbank.v1.Recipient': Recipient$json,
  '.healthcare.bloodbank.v1.SetThresholdRequest': SetThresholdRequest$json,
  '.healthcare.bloodbank.v1.StockThreshold': StockThreshold$json,
  '.healthcare.bloodbank.v1.SetThresholdResponse': SetThresholdResponse$json,
  '.healthcare.bloodbank.v1.GetStockRequest': GetStockRequest$json,
  '.healthcare.bloodbank.v1.GetStockResponse': GetStockResponse$json,
  '.healthcare.bloodbank.v1.StockLevel': StockLevel$json,
  '.healthcare.bloodbank.v1.StockAlert': StockAlert$json,
  '.healthcare.bloodbank.v1.GetUtilisationRequest': GetUtilisationRequest$json,
  '.healthcare.bloodbank.v1.GetUtilisationResponse':
      GetUtilisationResponse$json,
  '.healthcare.bloodbank.v1.Utilisation': Utilisation$json,
  '.healthcare.bloodbank.v1.Utilisation.ByIndicationEntry':
      Utilisation_ByIndicationEntry$json,
};

/// Descriptor for `BloodBankService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List bloodBankServiceDescriptor = $convert.base64Decode(
    'ChBCbG9vZEJhbmtTZXJ2aWNlEm4KDVJlZ2lzdGVyRG9ub3ISLS5oZWFsdGhjYXJlLmJsb29kYm'
    'Fuay52MS5SZWdpc3RlckRvbm9yUmVxdWVzdBouLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlJl'
    'Z2lzdGVyRG9ub3JSZXNwb25zZRJfCghHZXREb25vchIoLmhlYWx0aGNhcmUuYmxvb2RiYW5rLn'
    'YxLkdldERvbm9yUmVxdWVzdBopLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkdldERvbm9yUmVz'
    'cG9uc2USZQoKRGVmZXJEb25vchIqLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkRlZmVyRG9ub3'
    'JSZXF1ZXN0GisuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuRGVmZXJEb25vclJlc3BvbnNlEnEK'
    'DlJlaW5zdGF0ZURvbm9yEi4uaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVpbnN0YXRlRG9ub3'
    'JSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVpbnN0YXRlRG9ub3JSZXNwb25z'
    'ZRJ9ChJMaXN0RGVmZXJyZWREb25vcnMSMi5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5MaXN0RG'
    'VmZXJyZWREb25vcnNSZXF1ZXN0GjMuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuTGlzdERlZmVy'
    'cmVkRG9ub3JzUmVzcG9uc2USaAoLU2NyZWVuRG9ub3ISKy5oZWFsdGhjYXJlLmJsb29kYmFuay'
    '52MS5TY3JlZW5Eb25vclJlcXVlc3QaLC5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5TY3JlZW5E'
    'b25vclJlc3BvbnNlElwKB0NvbGxlY3QSJy5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5Db2xsZW'
    'N0UmVxdWVzdBooLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkNvbGxlY3RSZXNwb25zZRJlCgpS'
    'ZWNvcmRUZXN0EiouaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVjb3JkVGVzdFJlcXVlc3QaKy'
    '5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5SZWNvcmRUZXN0UmVzcG9uc2USfQoSR2V0UmVsZWFz'
    'ZURlY2lzaW9uEjIuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuR2V0UmVsZWFzZURlY2lzaW9uUm'
    'VxdWVzdBozLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkdldFJlbGVhc2VEZWNpc2lvblJlc3Bv'
    'bnNlEnoKEVJlbGVhc2VDb21wb25lbnRzEjEuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVsZW'
    'FzZUNvbXBvbmVudHNSZXF1ZXN0GjIuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuUmVsZWFzZUNv'
    'bXBvbmVudHNSZXNwb25zZRJrCgxBZGRDb21wb25lbnQSLC5oZWFsdGhjYXJlLmJsb29kYmFuay'
    '52MS5BZGRDb21wb25lbnRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuQWRkQ29t'
    'cG9uZW50UmVzcG9uc2USawoMR2V0Q29tcG9uZW50EiwuaGVhbHRoY2FyZS5ibG9vZGJhbmsudj'
    'EuR2V0Q29tcG9uZW50UmVxdWVzdBotLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkdldENvbXBv'
    'bmVudFJlc3BvbnNlEncKEERpc2NhcmRDb21wb25lbnQSMC5oZWFsdGhjYXJlLmJsb29kYmFuay'
    '52MS5EaXNjYXJkQ29tcG9uZW50UmVxdWVzdBoxLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkRp'
    'c2NhcmRDb21wb25lbnRSZXNwb25zZRJrCgxQbGFjZVJlcXVlc3QSLC5oZWFsdGhjYXJlLmJsb2'
    '9kYmFuay52MS5QbGFjZVJlcXVlc3RSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEu'
    'UGxhY2VSZXF1ZXN0UmVzcG9uc2USaAoLR2V0V29ya2xpc3QSKy5oZWFsdGhjYXJlLmJsb29kYm'
    'Fuay52MS5HZXRXb3JrbGlzdFJlcXVlc3QaLC5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5HZXRX'
    'b3JrbGlzdFJlc3BvbnNlEoABChNMaXN0UGF0aWVudFJlcXVlc3RzEjMuaGVhbHRoY2FyZS5ibG'
    '9vZGJhbmsudjEuTGlzdFBhdGllbnRSZXF1ZXN0c1JlcXVlc3QaNC5oZWFsdGhjYXJlLmJsb29k'
    'YmFuay52MS5MaXN0UGF0aWVudFJlcXVlc3RzUmVzcG9uc2USawoMR3JvdXBQYXRpZW50EiwuaG'
    'VhbHRoY2FyZS5ibG9vZGJhbmsudjEuR3JvdXBQYXRpZW50UmVxdWVzdBotLmhlYWx0aGNhcmUu'
    'Ymxvb2RiYW5rLnYxLkdyb3VwUGF0aWVudFJlc3BvbnNlEnEKDkZpbmRDb21wYXRpYmxlEi4uaG'
    'VhbHRoY2FyZS5ibG9vZGJhbmsudjEuRmluZENvbXBhdGlibGVSZXF1ZXN0Gi8uaGVhbHRoY2Fy'
    'ZS5ibG9vZGJhbmsudjEuRmluZENvbXBhdGlibGVSZXNwb25zZRJcCgdSZXNlcnZlEicuaGVhbH'
    'RoY2FyZS5ibG9vZGJhbmsudjEuUmVzZXJ2ZVJlcXVlc3QaKC5oZWFsdGhjYXJlLmJsb29kYmFu'
    'ay52MS5SZXNlcnZlUmVzcG9uc2USfQoSUmVsZWFzZVJlc2VydmF0aW9uEjIuaGVhbHRoY2FyZS'
    '5ibG9vZGJhbmsudjEuUmVsZWFzZVJlc2VydmF0aW9uUmVxdWVzdBozLmhlYWx0aGNhcmUuYmxv'
    'b2RiYW5rLnYxLlJlbGVhc2VSZXNlcnZhdGlvblJlc3BvbnNlEowBChdTd2VlcExhcHNlZFJlc2'
    'VydmF0aW9ucxI3LmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlN3ZWVwTGFwc2VkUmVzZXJ2YXRp'
    'b25zUmVxdWVzdBo4LmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlN3ZWVwTGFwc2VkUmVzZXJ2YX'
    'Rpb25zUmVzcG9uc2USYgoJSXNzdWVVbml0EikuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuSXNz'
    'dWVVbml0UmVxdWVzdBoqLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLklzc3VlVW5pdFJlc3Bvbn'
    'NlEncKEFJlY29uY2lsZVJlbGVhc2USMC5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5SZWNvbmNp'
    'bGVSZWxlYXNlUmVxdWVzdBoxLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlJlY29uY2lsZVJlbG'
    'Vhc2VSZXNwb25zZRKMAQoXTGlzdE91dHN0YW5kaW5nUmVsZWFzZXMSNy5oZWFsdGhjYXJlLmJs'
    'b29kYmFuay52MS5MaXN0T3V0c3RhbmRpbmdSZWxlYXNlc1JlcXVlc3QaOC5oZWFsdGhjYXJlLm'
    'Jsb29kYmFuay52MS5MaXN0T3V0c3RhbmRpbmdSZWxlYXNlc1Jlc3BvbnNlEm4KDVZlcmlmeUJl'
    'ZHNpZGUSLS5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5WZXJpZnlCZWRzaWRlUmVxdWVzdBouLm'
    'hlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlZlcmlmeUJlZHNpZGVSZXNwb25zZRJ3ChBTdGFydFRy'
    'YW5zZnVzaW9uEjAuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuU3RhcnRUcmFuc2Z1c2lvblJlcX'
    'Vlc3QaMS5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5TdGFydFRyYW5zZnVzaW9uUmVzcG9uc2US'
    'XAoHT2JzZXJ2ZRInLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLk9ic2VydmVSZXF1ZXN0GiguaG'
    'VhbHRoY2FyZS5ibG9vZGJhbmsudjEuT2JzZXJ2ZVJlc3BvbnNlEnEKDkVuZFRyYW5zZnVzaW9u'
    'Ei4uaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuRW5kVHJhbnNmdXNpb25SZXF1ZXN0Gi8uaGVhbH'
    'RoY2FyZS5ibG9vZGJhbmsudjEuRW5kVHJhbnNmdXNpb25SZXNwb25zZRJlCgpHZXRFcGlzb2Rl'
    'EiouaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuR2V0RXBpc29kZVJlcXVlc3QaKy5oZWFsdGhjYX'
    'JlLmJsb29kYmFuay52MS5HZXRFcGlzb2RlUmVzcG9uc2USjAEKF0xpc3RQYXRpZW50VHJhbnNm'
    'dXNpb25zEjcuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuTGlzdFBhdGllbnRUcmFuc2Z1c2lvbn'
    'NSZXF1ZXN0GjguaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuTGlzdFBhdGllbnRUcmFuc2Z1c2lv'
    'bnNSZXNwb25zZRJxCg5SZXBvcnRSZWFjdGlvbhIuLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLl'
    'JlcG9ydFJlYWN0aW9uUmVxdWVzdBovLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlJlcG9ydFJl'
    'YWN0aW9uUmVzcG9uc2UShgEKFUNvbmNsdWRlSW52ZXN0aWdhdGlvbhI1LmhlYWx0aGNhcmUuYm'
    'xvb2RiYW5rLnYxLkNvbmNsdWRlSW52ZXN0aWdhdGlvblJlcXVlc3QaNi5oZWFsdGhjYXJlLmJs'
    'b29kYmFuay52MS5Db25jbHVkZUludmVzdGlnYXRpb25SZXNwb25zZRKJAQoWTGlzdE9wZW5Jbn'
    'Zlc3RpZ2F0aW9ucxI2LmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkxpc3RPcGVuSW52ZXN0aWdh'
    'dGlvbnNSZXF1ZXN0GjcuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuTGlzdE9wZW5JbnZlc3RpZ2'
    'F0aW9uc1Jlc3BvbnNlEmIKCVRyYWNlVW5pdBIpLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLlRy'
    'YWNlVW5pdFJlcXVlc3QaKi5oZWFsdGhjYXJlLmJsb29kYmFuay52MS5UcmFjZVVuaXRSZXNwb2'
    '5zZRJfCghMb29rQmFjaxIoLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkxvb2tCYWNrUmVxdWVz'
    'dBopLmhlYWx0aGNhcmUuYmxvb2RiYW5rLnYxLkxvb2tCYWNrUmVzcG9uc2USawoMU2V0VGhyZX'
    'Nob2xkEiwuaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuU2V0VGhyZXNob2xkUmVxdWVzdBotLmhl'
    'YWx0aGNhcmUuYmxvb2RiYW5rLnYxLlNldFRocmVzaG9sZFJlc3BvbnNlEl8KCEdldFN0b2NrEi'
    'guaGVhbHRoY2FyZS5ibG9vZGJhbmsudjEuR2V0U3RvY2tSZXF1ZXN0GikuaGVhbHRoY2FyZS5i'
    'bG9vZGJhbmsudjEuR2V0U3RvY2tSZXNwb25zZRJxCg5HZXRVdGlsaXNhdGlvbhIuLmhlYWx0aG'
    'NhcmUuYmxvb2RiYW5rLnYxLkdldFV0aWxpc2F0aW9uUmVxdWVzdBovLmhlYWx0aGNhcmUuYmxv'
    'b2RiYW5rLnYxLkdldFV0aWxpc2F0aW9uUmVzcG9uc2U=');
