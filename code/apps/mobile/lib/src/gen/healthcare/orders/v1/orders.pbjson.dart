// This is a generated file - do not edit.
//
// Generated from healthcare/orders/v1/orders.proto.

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

@$core.Deprecated('Use orderTypeDescriptor instead')
const OrderType$json = {
  '1': 'OrderType',
  '2': [
    {'1': 'ORDER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_TYPE_LABORATORY', '2': 1},
    {'1': 'ORDER_TYPE_IMAGING', '2': 2},
    {'1': 'ORDER_TYPE_MEDICATION', '2': 3},
    {'1': 'ORDER_TYPE_PROCEDURE', '2': 4},
    {'1': 'ORDER_TYPE_DIET', '2': 5},
    {'1': 'ORDER_TYPE_NURSING', '2': 6},
    {'1': 'ORDER_TYPE_BLOOD_PRODUCT', '2': 7},
    {'1': 'ORDER_TYPE_REFERRAL', '2': 8},
    {'1': 'ORDER_TYPE_ALLIED_HEALTH', '2': 9},
  ],
};

/// Descriptor for `OrderType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderTypeDescriptor = $convert.base64Decode(
    'CglPcmRlclR5cGUSGgoWT1JERVJfVFlQRV9VTlNQRUNJRklFRBAAEhkKFU9SREVSX1RZUEVfTE'
    'FCT1JBVE9SWRABEhYKEk9SREVSX1RZUEVfSU1BR0lORxACEhkKFU9SREVSX1RZUEVfTUVESUNB'
    'VElPThADEhgKFE9SREVSX1RZUEVfUFJPQ0VEVVJFEAQSEwoPT1JERVJfVFlQRV9ESUVUEAUSFg'
    'oST1JERVJfVFlQRV9OVVJTSU5HEAYSHAoYT1JERVJfVFlQRV9CTE9PRF9QUk9EVUNUEAcSFwoT'
    'T1JERVJfVFlQRV9SRUZFUlJBTBAIEhwKGE9SREVSX1RZUEVfQUxMSUVEX0hFQUxUSBAJ');

@$core.Deprecated('Use orderStatusDescriptor instead')
const OrderStatus$json = {
  '1': 'OrderStatus',
  '2': [
    {'1': 'ORDER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_STATUS_DRAFT', '2': 1},
    {'1': 'ORDER_STATUS_REQUESTED', '2': 2},
    {'1': 'ORDER_STATUS_ACCEPTED', '2': 3},
    {'1': 'ORDER_STATUS_SCHEDULED', '2': 4},
    {'1': 'ORDER_STATUS_IN_PROGRESS', '2': 5},
    {'1': 'ORDER_STATUS_COMPLETED', '2': 6},
    {'1': 'ORDER_STATUS_CANCELLED', '2': 7},
    {'1': 'ORDER_STATUS_ENTERED_IN_ERROR', '2': 8},
  ],
};

/// Descriptor for `OrderStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStatusDescriptor = $convert.base64Decode(
    'CgtPcmRlclN0YXR1cxIcChhPUkRFUl9TVEFUVVNfVU5TUEVDSUZJRUQQABIWChJPUkRFUl9TVE'
    'FUVVNfRFJBRlQQARIaChZPUkRFUl9TVEFUVVNfUkVRVUVTVEVEEAISGQoVT1JERVJfU1RBVFVT'
    'X0FDQ0VQVEVEEAMSGgoWT1JERVJfU1RBVFVTX1NDSEVEVUxFRBAEEhwKGE9SREVSX1NUQVRVU1'
    '9JTl9QUk9HUkVTUxAFEhoKFk9SREVSX1NUQVRVU19DT01QTEVURUQQBhIaChZPUkRFUl9TVEFU'
    'VVNfQ0FOQ0VMTEVEEAcSIQodT1JERVJfU1RBVFVTX0VOVEVSRURfSU5fRVJST1IQCA==');

@$core.Deprecated('Use priorityDescriptor instead')
const Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_ROUTINE', '2': 1},
    {'1': 'PRIORITY_URGENT', '2': 2},
    {'1': 'PRIORITY_STAT', '2': 3},
    {'1': 'PRIORITY_TIMING_CRITICAL', '2': 4},
  ],
};

/// Descriptor for `Priority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityDescriptor = $convert.base64Decode(
    'CghQcmlvcml0eRIYChRQUklPUklUWV9VTlNQRUNJRklFRBAAEhQKEFBSSU9SSVRZX1JPVVRJTk'
    'UQARITCg9QUklPUklUWV9VUkdFTlQQAhIRCg1QUklPUklUWV9TVEFUEAMSHAoYUFJJT1JJVFlf'
    'VElNSU5HX0NSSVRJQ0FMEAQ=');

@$core.Deprecated('Use codingDescriptor instead')
const Coding$json = {
  '1': 'Coding',
  '2': [
    {'1': 'system', '3': 1, '4': 1, '5': 9, '10': 'system'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 4, '4': 1, '5': 9, '10': 'display'},
  ],
};

/// Descriptor for `Coding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codingDescriptor = $convert.base64Decode(
    'CgZDb2RpbmcSFgoGc3lzdGVtGAEgASgJUgZzeXN0ZW0SGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2'
    'lvbhISCgRjb2RlGAMgASgJUgRjb2RlEhgKB2Rpc3BsYXkYBCABKAlSB2Rpc3BsYXk=');

@$core.Deprecated('Use timingDescriptor instead')
const Timing$json = {
  '1': 'Timing',
  '2': [
    {
      '1': 'start_at',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startAt'
    },
    {
      '1': 'end_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endAt'
    },
    {
      '1': 'frequency_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'frequencySeconds'
    },
    {'1': 'count', '3': 4, '4': 1, '5': 5, '10': 'count'},
    {'1': 'days_of_week', '3': 5, '4': 3, '5': 5, '10': 'daysOfWeek'},
    {'1': 'times_of_day', '3': 6, '4': 3, '5': 5, '10': 'timesOfDay'},
    {'1': 'prn', '3': 7, '4': 1, '5': 8, '10': 'prn'},
    {'1': 'duration_seconds', '3': 8, '4': 1, '5': 3, '10': 'durationSeconds'},
  ],
};

/// Descriptor for `Timing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timingDescriptor = $convert.base64Decode(
    'CgZUaW1pbmcSNQoIc3RhcnRfYXQYASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'dzdGFydEF0EjEKBmVuZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWVu'
    'ZEF0EisKEWZyZXF1ZW5jeV9zZWNvbmRzGAMgASgDUhBmcmVxdWVuY3lTZWNvbmRzEhQKBWNvdW'
    '50GAQgASgFUgVjb3VudBIgCgxkYXlzX29mX3dlZWsYBSADKAVSCmRheXNPZldlZWsSIAoMdGlt'
    'ZXNfb2ZfZGF5GAYgAygFUgp0aW1lc09mRGF5EhAKA3BybhgHIAEoCFIDcHJuEikKEGR1cmF0aW'
    '9uX3NlY29uZHMYCCABKANSD2R1cmF0aW9uU2Vjb25kcw==');

@$core.Deprecated('Use duplicateOverrideDescriptor instead')
const DuplicateOverride$json = {
  '1': 'DuplicateOverride',
  '2': [
    {'1': 'against_order_ids', '3': 1, '4': 3, '5': 9, '10': 'againstOrderIds'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'by', '3': 3, '4': 1, '5': 9, '10': 'by'},
    {
      '1': 'at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
  ],
};

/// Descriptor for `DuplicateOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateOverrideDescriptor = $convert.base64Decode(
    'ChFEdXBsaWNhdGVPdmVycmlkZRIqChFhZ2FpbnN0X29yZGVyX2lkcxgBIAMoCVIPYWdhaW5zdE'
    '9yZGVySWRzEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29uEg4KAmJ5GAMgASgJUgJieRIqCgJhdBgE'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAmF0');

@$core.Deprecated('Use statusChangeDescriptor instead')
const StatusChange$json = {
  '1': 'StatusChange',
  '2': [
    {'1': 'change_id', '3': 1, '4': 1, '5': 9, '10': 'changeId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderStatus',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderStatus',
      '10': 'to'
    },
    {'1': 'by', '3': 4, '4': 1, '5': 9, '10': 'by'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
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

/// Descriptor for `StatusChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusChangeDescriptor = $convert.base64Decode(
    'CgxTdGF0dXNDaGFuZ2USGwoJY2hhbmdlX2lkGAEgASgJUghjaGFuZ2VJZBI1CgRmcm9tGAIgAS'
    'gOMiEuaGVhbHRoY2FyZS5vcmRlcnMudjEuT3JkZXJTdGF0dXNSBGZyb20SMQoCdG8YAyABKA4y'
    'IS5oZWFsdGhjYXJlLm9yZGVycy52MS5PcmRlclN0YXR1c1ICdG8SDgoCYnkYBCABKAlSAmJ5Eh'
    'YKBnJlYXNvbhgFIAEoCVIGcmVhc29uEjsKC29jY3VycmVkX2F0GAYgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdA==');

@$core.Deprecated('Use orderDescriptor instead')
const Order$json = {
  '1': 'Order',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'requester_id', '3': 7, '4': 1, '5': 9, '10': 'requesterId'},
    {'1': 'entered_by_id', '3': 8, '4': 1, '5': 9, '10': 'enteredById'},
    {'1': 'target_service', '3': 9, '4': 1, '5': 9, '10': 'targetService'},
    {
      '1': 'code',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'code'
    },
    {'1': 'detail', '3': 11, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 12, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'indication_code',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'indicationCode'
    },
    {
      '1': 'priority',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'timing',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Timing',
      '10': 'timing'
    },
    {
      '1': 'conditional_instruction',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'conditionalInstruction'
    },
    {
      '1': 'status',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderStatus',
      '10': 'status'
    },
    {
      '1': 'history',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.StatusChange',
      '10': 'history'
    },
    {'1': 'order_set_id', '3': 19, '4': 1, '5': 9, '10': 'orderSetId'},
    {
      '1': 'order_set_version',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'orderSetVersion'
    },
    {'1': 'favourite_id', '3': 21, '4': 1, '5': 9, '10': 'favouriteId'},
    {
      '1': 'cancellation_requested_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cancellationRequestedAt'
    },
    {
      '1': 'cancellation_requested_by',
      '3': 23,
      '4': 1,
      '5': 9,
      '10': 'cancellationRequestedBy'
    },
    {
      '1': 'cancellation_reason',
      '3': 24,
      '4': 1,
      '5': 9,
      '10': 'cancellationReason'
    },
    {
      '1': 'duplicate_override',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.DuplicateOverride',
      '10': 'duplicateOverride'
    },
    {
      '1': 'created_at',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 28, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Order`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderDescriptor = $convert.base64Decode(
    'CgVPcmRlchIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZBIWCgZudW1iZXIYAiABKAlSBm51bW'
    'JlchIzCgR0eXBlGAMgASgOMh8uaGVhbHRoY2FyZS5vcmRlcnMudjEuT3JkZXJUeXBlUgR0eXBl'
    'Eh0KCnBhdGllbnRfaWQYBCABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYBSABKAlSC2'
    'VuY291bnRlcklkEh8KC2ZhY2lsaXR5X2lkGAYgASgJUgpmYWNpbGl0eUlkEiEKDHJlcXVlc3Rl'
    'cl9pZBgHIAEoCVILcmVxdWVzdGVySWQSIgoNZW50ZXJlZF9ieV9pZBgIIAEoCVILZW50ZXJlZE'
    'J5SWQSJQoOdGFyZ2V0X3NlcnZpY2UYCSABKAlSDXRhcmdldFNlcnZpY2USMAoEY29kZRgKIAEo'
    'CzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLkNvZGluZ1IEY29kZRIWCgZkZXRhaWwYCyABKAlSBm'
    'RldGFpbBIeCgppbmRpY2F0aW9uGAwgASgJUgppbmRpY2F0aW9uEkUKD2luZGljYXRpb25fY29k'
    'ZRgNIAEoCzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLkNvZGluZ1IOaW5kaWNhdGlvbkNvZGUSOg'
    'oIcHJpb3JpdHkYDiABKA4yHi5oZWFsdGhjYXJlLm9yZGVycy52MS5Qcmlvcml0eVIIcHJpb3Jp'
    'dHkSNAoGdGltaW5nGA8gASgLMhwuaGVhbHRoY2FyZS5vcmRlcnMudjEuVGltaW5nUgZ0aW1pbm'
    'cSNwoXY29uZGl0aW9uYWxfaW5zdHJ1Y3Rpb24YECABKAlSFmNvbmRpdGlvbmFsSW5zdHJ1Y3Rp'
    'b24SOQoGc3RhdHVzGBEgASgOMiEuaGVhbHRoY2FyZS5vcmRlcnMudjEuT3JkZXJTdGF0dXNSBn'
    'N0YXR1cxI8CgdoaXN0b3J5GBIgAygLMiIuaGVhbHRoY2FyZS5vcmRlcnMudjEuU3RhdHVzQ2hh'
    'bmdlUgdoaXN0b3J5EiAKDG9yZGVyX3NldF9pZBgTIAEoCVIKb3JkZXJTZXRJZBIqChFvcmRlcl'
    '9zZXRfdmVyc2lvbhgUIAEoCVIPb3JkZXJTZXRWZXJzaW9uEiEKDGZhdm91cml0ZV9pZBgVIAEo'
    'CVILZmF2b3VyaXRlSWQSVgoZY2FuY2VsbGF0aW9uX3JlcXVlc3RlZF9hdBgWIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSF2NhbmNlbGxhdGlvblJlcXVlc3RlZEF0EjoKGWNhbmNl'
    'bGxhdGlvbl9yZXF1ZXN0ZWRfYnkYFyABKAlSF2NhbmNlbGxhdGlvblJlcXVlc3RlZEJ5Ei8KE2'
    'NhbmNlbGxhdGlvbl9yZWFzb24YGCABKAlSEmNhbmNlbGxhdGlvblJlYXNvbhJWChJkdXBsaWNh'
    'dGVfb3ZlcnJpZGUYGSABKAsyJy5oZWFsdGhjYXJlLm9yZGVycy52MS5EdXBsaWNhdGVPdmVycm'
    'lkZVIRZHVwbGljYXRlT3ZlcnJpZGUSOQoKY3JlYXRlZF9hdBgaIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBsgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhgKB3ZlcnNpb24YHCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use duplicateWarningDescriptor instead')
const DuplicateWarning$json = {
  '1': 'DuplicateWarning',
  '2': [
    {
      '1': 'existing',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'existing'
    },
    {'1': 'overridable', '3': 2, '4': 1, '5': 8, '10': 'overridable'},
    {'1': 'window_seconds', '3': 3, '4': 1, '5': 3, '10': 'windowSeconds'},
  ],
};

/// Descriptor for `DuplicateWarning`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateWarningDescriptor = $convert.base64Decode(
    'ChBEdXBsaWNhdGVXYXJuaW5nEjcKCGV4aXN0aW5nGAEgAygLMhsuaGVhbHRoY2FyZS5vcmRlcn'
    'MudjEuT3JkZXJSCGV4aXN0aW5nEiAKC292ZXJyaWRhYmxlGAIgASgIUgtvdmVycmlkYWJsZRIl'
    'Cg53aW5kb3dfc2Vjb25kcxgDIAEoA1INd2luZG93U2Vjb25kcw==');

@$core.Deprecated('Use placeOrderRequestDescriptor instead')
const PlaceOrderRequest$json = {
  '1': 'PlaceOrderRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'code'
    },
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 6, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'indication_code',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'indicationCode'
    },
    {
      '1': 'priority',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'timing',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Timing',
      '10': 'timing'
    },
    {
      '1': 'conditional_instruction',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'conditionalInstruction'
    },
    {'1': 'entered_by_id', '3': 11, '4': 1, '5': 9, '10': 'enteredById'},
    {
      '1': 'acknowledge_duplicates',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'acknowledgeDuplicates'
    },
  ],
};

/// Descriptor for `PlaceOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeOrderRequestDescriptor = $convert.base64Decode(
    'ChFQbGFjZU9yZGVyUmVxdWVzdBIzCgR0eXBlGAEgASgOMh8uaGVhbHRoY2FyZS5vcmRlcnMudj'
    'EuT3JkZXJUeXBlUgR0eXBlEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxlbmNv'
    'dW50ZXJfaWQYAyABKAlSC2VuY291bnRlcklkEjAKBGNvZGUYBCABKAsyHC5oZWFsdGhjYXJlLm'
    '9yZGVycy52MS5Db2RpbmdSBGNvZGUSFgoGZGV0YWlsGAUgASgJUgZkZXRhaWwSHgoKaW5kaWNh'
    'dGlvbhgGIAEoCVIKaW5kaWNhdGlvbhJFCg9pbmRpY2F0aW9uX2NvZGUYByABKAsyHC5oZWFsdG'
    'hjYXJlLm9yZGVycy52MS5Db2RpbmdSDmluZGljYXRpb25Db2RlEjoKCHByaW9yaXR5GAggASgO'
    'Mh4uaGVhbHRoY2FyZS5vcmRlcnMudjEuUHJpb3JpdHlSCHByaW9yaXR5EjQKBnRpbWluZxgJIA'
    'EoCzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLlRpbWluZ1IGdGltaW5nEjcKF2NvbmRpdGlvbmFs'
    'X2luc3RydWN0aW9uGAogASgJUhZjb25kaXRpb25hbEluc3RydWN0aW9uEiIKDWVudGVyZWRfYn'
    'lfaWQYCyABKAlSC2VudGVyZWRCeUlkEjUKFmFja25vd2xlZGdlX2R1cGxpY2F0ZXMYDCABKAlS'
    'FWFja25vd2xlZGdlRHVwbGljYXRlcw==');

@$core.Deprecated('Use placeOrderResponseDescriptor instead')
const PlaceOrderResponse$json = {
  '1': 'PlaceOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
    {
      '1': 'warning',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.DuplicateWarning',
      '10': 'warning'
    },
  ],
};

/// Descriptor for `PlaceOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeOrderResponseDescriptor = $convert.base64Decode(
    'ChJQbGFjZU9yZGVyUmVzcG9uc2USMQoFb3JkZXIYASABKAsyGy5oZWFsdGhjYXJlLm9yZGVycy'
    '52MS5PcmRlclIFb3JkZXISQAoHd2FybmluZxgCIAEoCzImLmhlYWx0aGNhcmUub3JkZXJzLnYx'
    'LkR1cGxpY2F0ZVdhcm5pbmdSB3dhcm5pbmc=');

@$core.Deprecated('Use getOrderRequestDescriptor instead')
const GetOrderRequest$json = {
  '1': 'GetOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `GetOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRPcmRlclJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQ=');

@$core.Deprecated('Use getOrderResponseDescriptor instead')
const GetOrderResponse$json = {
  '1': 'GetOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
  ],
};

/// Descriptor for `GetOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOrderResponseDescriptor = $convert.base64Decode(
    'ChBHZXRPcmRlclJlc3BvbnNlEjEKBW9yZGVyGAEgASgLMhsuaGVhbHRoY2FyZS5vcmRlcnMudj'
    'EuT3JkZXJSBW9yZGVy');

@$core.Deprecated('Use listOrdersRequestDescriptor instead')
const ListOrdersRequest$json = {
  '1': 'ListOrdersRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {'1': 'live_only', '3': 4, '4': 1, '5': 8, '10': 'liveOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrdersRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0T3JkZXJzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIzCgR0eXBlGAMgASgOMh8uaGVhbHRoY2Fy'
    'ZS5vcmRlcnMudjEuT3JkZXJUeXBlUgR0eXBlEhsKCWxpdmVfb25seRgEIAEoCFIIbGl2ZU9ubH'
    'kSGwoJcGFnZV9zaXplGAUgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listOrdersResponseDescriptor instead')
const ListOrdersResponse$json = {
  '1': 'ListOrdersResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `ListOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrdersResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0T3JkZXJzUmVzcG9uc2USMwoGb3JkZXJzGAEgAygLMhsuaGVhbHRoY2FyZS5vcmRlcn'
    'MudjEuT3JkZXJSBm9yZGVycw==');

@$core.Deprecated('Use getWorklistRequestDescriptor instead')
const GetWorklistRequest$json = {
  '1': 'GetWorklistRequest',
  '2': [
    {'1': 'service', '3': 1, '4': 1, '5': 9, '10': 'service'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetWorklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistRequestDescriptor = $convert.base64Decode(
    'ChJHZXRXb3JrbGlzdFJlcXVlc3QSGAoHc2VydmljZRgBIAEoCVIHc2VydmljZRIfCgtmYWNpbG'
    'l0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use getWorklistResponseDescriptor instead')
const GetWorklistResponse$json = {
  '1': 'GetWorklistResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `GetWorklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistResponseDescriptor = $convert.base64Decode(
    'ChNHZXRXb3JrbGlzdFJlc3BvbnNlEjMKBm9yZGVycxgBIAMoCzIbLmhlYWx0aGNhcmUub3JkZX'
    'JzLnYxLk9yZGVyUgZvcmRlcnM=');

@$core.Deprecated('Use cancelOrderRequestDescriptor instead')
const CancelOrderRequest$json = {
  '1': 'CancelOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelOrderRequestDescriptor = $convert.base64Decode(
    'ChJDYW5jZWxPcmRlclJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSFgoGcmVhc2'
    '9uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use cancelOrderResponseDescriptor instead')
const CancelOrderResponse$json = {
  '1': 'CancelOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
    {
      '1': 'cancellation_requested',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'cancellationRequested'
    },
  ],
};

/// Descriptor for `CancelOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelOrderResponseDescriptor = $convert.base64Decode(
    'ChNDYW5jZWxPcmRlclJlc3BvbnNlEjEKBW9yZGVyGAEgASgLMhsuaGVhbHRoY2FyZS5vcmRlcn'
    'MudjEuT3JkZXJSBW9yZGVyEjUKFmNhbmNlbGxhdGlvbl9yZXF1ZXN0ZWQYAiABKAhSFWNhbmNl'
    'bGxhdGlvblJlcXVlc3RlZA==');

@$core.Deprecated('Use retractOrderRequestDescriptor instead')
const RetractOrderRequest$json = {
  '1': 'RetractOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RetractOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractOrderRequestDescriptor = $convert.base64Decode(
    'ChNSZXRyYWN0T3JkZXJSZXF1ZXN0EhkKCG9yZGVyX2lkGAEgASgJUgdvcmRlcklkEhYKBnJlYX'
    'NvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use retractOrderResponseDescriptor instead')
const RetractOrderResponse$json = {
  '1': 'RetractOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
  ],
};

/// Descriptor for `RetractOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractOrderResponseDescriptor = $convert.base64Decode(
    'ChRSZXRyYWN0T3JkZXJSZXNwb25zZRIxCgVvcmRlchgBIAEoCzIbLmhlYWx0aGNhcmUub3JkZX'
    'JzLnYxLk9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use acknowledgeOrderRequestDescriptor instead')
const AcknowledgeOrderRequest$json = {
  '1': 'AcknowledgeOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'service', '3': 2, '4': 1, '5': 9, '10': 'service'},
    {'1': 'delivery_id', '3': 3, '4': 1, '5': 9, '10': 'deliveryId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderStatus',
      '10': 'status'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'performer_id', '3': 6, '4': 1, '5': 9, '10': 'performerId'},
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

/// Descriptor for `AcknowledgeOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeOrderRequestDescriptor = $convert.base64Decode(
    'ChdBY2tub3dsZWRnZU9yZGVyUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZBIYCg'
    'dzZXJ2aWNlGAIgASgJUgdzZXJ2aWNlEh8KC2RlbGl2ZXJ5X2lkGAMgASgJUgpkZWxpdmVyeUlk'
    'EjkKBnN0YXR1cxgEIAEoDjIhLmhlYWx0aGNhcmUub3JkZXJzLnYxLk9yZGVyU3RhdHVzUgZzdG'
    'F0dXMSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SIQoMcGVyZm9ybWVyX2lkGAYgASgJUgtwZXJm'
    'b3JtZXJJZBI7CgtvY2N1cnJlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCm9jY3VycmVkQXQ=');

@$core.Deprecated('Use acknowledgeOrderResponseDescriptor instead')
const AcknowledgeOrderResponse$json = {
  '1': 'AcknowledgeOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
  ],
};

/// Descriptor for `AcknowledgeOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeOrderResponseDescriptor =
    $convert.base64Decode(
        'ChhBY2tub3dsZWRnZU9yZGVyUmVzcG9uc2USMQoFb3JkZXIYASABKAsyGy5oZWFsdGhjYXJlLm'
        '9yZGVycy52MS5PcmRlclIFb3JkZXI=');

@$core.Deprecated('Use componentDescriptor instead')
const Component$json = {
  '1': 'Component',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {
      '1': 'code',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'code'
    },
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 5, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'priority',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'timing',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Timing',
      '10': 'timing'
    },
    {
      '1': 'selected_by_default',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'selectedByDefault'
    },
    {'1': 'mandatory', '3': 9, '4': 1, '5': 8, '10': 'mandatory'},
  ],
};

/// Descriptor for `Component`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List componentDescriptor = $convert.base64Decode(
    'CglDb21wb25lbnQSIQoMY29tcG9uZW50X2lkGAEgASgJUgtjb21wb25lbnRJZBIzCgR0eXBlGA'
    'IgASgOMh8uaGVhbHRoY2FyZS5vcmRlcnMudjEuT3JkZXJUeXBlUgR0eXBlEjAKBGNvZGUYAyAB'
    'KAsyHC5oZWFsdGhjYXJlLm9yZGVycy52MS5Db2RpbmdSBGNvZGUSFgoGZGV0YWlsGAQgASgJUg'
    'ZkZXRhaWwSHgoKaW5kaWNhdGlvbhgFIAEoCVIKaW5kaWNhdGlvbhI6Cghwcmlvcml0eRgGIAEo'
    'DjIeLmhlYWx0aGNhcmUub3JkZXJzLnYxLlByaW9yaXR5Ughwcmlvcml0eRI0CgZ0aW1pbmcYBy'
    'ABKAsyHC5oZWFsdGhjYXJlLm9yZGVycy52MS5UaW1pbmdSBnRpbWluZxIuChNzZWxlY3RlZF9i'
    'eV9kZWZhdWx0GAggASgIUhFzZWxlY3RlZEJ5RGVmYXVsdBIcCgltYW5kYXRvcnkYCSABKAhSCW'
    '1hbmRhdG9yeQ==');

@$core.Deprecated('Use orderSetDescriptor instead')
const OrderSet$json = {
  '1': 'OrderSet',
  '2': [
    {'1': 'set_id', '3': 1, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'specialty', '3': 4, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'components',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Component',
      '10': 'components'
    },
    {'1': 'retired', '3': 6, '4': 1, '5': 8, '10': 'retired'},
    {'1': 'created_by', '3': 7, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
  ],
};

/// Descriptor for `OrderSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderSetDescriptor = $convert.base64Decode(
    'CghPcmRlclNldBIVCgZzZXRfaWQYASABKAlSBXNldElkEhgKB3ZlcnNpb24YAiABKAlSB3Zlcn'
    'Npb24SEgoEbmFtZRgDIAEoCVIEbmFtZRIcCglzcGVjaWFsdHkYBCABKAlSCXNwZWNpYWx0eRI/'
    'Cgpjb21wb25lbnRzGAUgAygLMh8uaGVhbHRoY2FyZS5vcmRlcnMudjEuQ29tcG9uZW50Ugpjb2'
    '1wb25lbnRzEhgKB3JldGlyZWQYBiABKAhSB3JldGlyZWQSHQoKY3JlYXRlZF9ieRgHIAEoCVIJ'
    'Y3JlYXRlZEJ5EjkKCmNyZWF0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use defineOrderSetRequestDescriptor instead')
const DefineOrderSetRequest$json = {
  '1': 'DefineOrderSetRequest',
  '2': [
    {
      '1': 'set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.OrderSet',
      '10': 'set'
    },
  ],
};

/// Descriptor for `DefineOrderSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineOrderSetRequestDescriptor = $convert.base64Decode(
    'ChVEZWZpbmVPcmRlclNldFJlcXVlc3QSMAoDc2V0GAEgASgLMh4uaGVhbHRoY2FyZS5vcmRlcn'
    'MudjEuT3JkZXJTZXRSA3NldA==');

@$core.Deprecated('Use defineOrderSetResponseDescriptor instead')
const DefineOrderSetResponse$json = {
  '1': 'DefineOrderSetResponse',
  '2': [
    {
      '1': 'set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.OrderSet',
      '10': 'set'
    },
  ],
};

/// Descriptor for `DefineOrderSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineOrderSetResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWZpbmVPcmRlclNldFJlc3BvbnNlEjAKA3NldBgBIAEoCzIeLmhlYWx0aGNhcmUub3JkZX'
        'JzLnYxLk9yZGVyU2V0UgNzZXQ=');

@$core.Deprecated('Use listOrderSetsRequestDescriptor instead')
const ListOrderSetsRequest$json = {
  '1': 'ListOrderSetsRequest',
  '2': [
    {'1': 'specialty', '3': 1, '4': 1, '5': 9, '10': 'specialty'},
    {'1': 'include_retired', '3': 2, '4': 1, '5': 8, '10': 'includeRetired'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOrderSetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrderSetsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0T3JkZXJTZXRzUmVxdWVzdBIcCglzcGVjaWFsdHkYASABKAlSCXNwZWNpYWx0eRInCg'
    '9pbmNsdWRlX3JldGlyZWQYAiABKAhSDmluY2x1ZGVSZXRpcmVkEhsKCXBhZ2Vfc2l6ZRgDIAEo'
    'BVIIcGFnZVNpemU=');

@$core.Deprecated('Use listOrderSetsResponseDescriptor instead')
const ListOrderSetsResponse$json = {
  '1': 'ListOrderSetsResponse',
  '2': [
    {
      '1': 'sets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.OrderSet',
      '10': 'sets'
    },
  ],
};

/// Descriptor for `ListOrderSetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOrderSetsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0T3JkZXJTZXRzUmVzcG9uc2USMgoEc2V0cxgBIAMoCzIeLmhlYWx0aGNhcmUub3JkZX'
    'JzLnYxLk9yZGVyU2V0UgRzZXRz');

@$core.Deprecated('Use retireOrderSetRequestDescriptor instead')
const RetireOrderSetRequest$json = {
  '1': 'RetireOrderSetRequest',
  '2': [
    {'1': 'set_id', '3': 1, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `RetireOrderSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireOrderSetRequestDescriptor = $convert.base64Decode(
    'ChVSZXRpcmVPcmRlclNldFJlcXVlc3QSFQoGc2V0X2lkGAEgASgJUgVzZXRJZBIYCgd2ZXJzaW'
    '9uGAIgASgJUgd2ZXJzaW9u');

@$core.Deprecated('Use retireOrderSetResponseDescriptor instead')
const RetireOrderSetResponse$json = {
  '1': 'RetireOrderSetResponse',
};

/// Descriptor for `RetireOrderSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireOrderSetResponseDescriptor =
    $convert.base64Decode('ChZSZXRpcmVPcmRlclNldFJlc3BvbnNl');

@$core.Deprecated('Use selectionDescriptor instead')
const Selection$json = {
  '1': 'Selection',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 3, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'timing',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Timing',
      '10': 'timing'
    },
  ],
};

/// Descriptor for `Selection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectionDescriptor = $convert.base64Decode(
    'CglTZWxlY3Rpb24SIQoMY29tcG9uZW50X2lkGAEgASgJUgtjb21wb25lbnRJZBIWCgZkZXRhaW'
    'wYAiABKAlSBmRldGFpbBIeCgppbmRpY2F0aW9uGAMgASgJUgppbmRpY2F0aW9uEjoKCHByaW9y'
    'aXR5GAQgASgOMh4uaGVhbHRoY2FyZS5vcmRlcnMudjEuUHJpb3JpdHlSCHByaW9yaXR5EjQKBn'
    'RpbWluZxgFIAEoCzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLlRpbWluZ1IGdGltaW5n');

@$core.Deprecated('Use placeFromOrderSetRequestDescriptor instead')
const PlaceFromOrderSetRequest$json = {
  '1': 'PlaceFromOrderSetRequest',
  '2': [
    {'1': 'set_id', '3': 1, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'set_version', '3': 2, '4': 1, '5': 9, '10': 'setVersion'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'selections',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Selection',
      '10': 'selections'
    },
    {
      '1': 'acknowledge_duplicates',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'acknowledgeDuplicates'
    },
    {'1': 'entered_by_id', '3': 7, '4': 1, '5': 9, '10': 'enteredById'},
  ],
};

/// Descriptor for `PlaceFromOrderSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeFromOrderSetRequestDescriptor = $convert.base64Decode(
    'ChhQbGFjZUZyb21PcmRlclNldFJlcXVlc3QSFQoGc2V0X2lkGAEgASgJUgVzZXRJZBIfCgtzZX'
    'RfdmVyc2lvbhgCIAEoCVIKc2V0VmVyc2lvbhIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRpZW50'
    'SWQSIQoMZW5jb3VudGVyX2lkGAQgASgJUgtlbmNvdW50ZXJJZBI/CgpzZWxlY3Rpb25zGAUgAy'
    'gLMh8uaGVhbHRoY2FyZS5vcmRlcnMudjEuU2VsZWN0aW9uUgpzZWxlY3Rpb25zEjUKFmFja25v'
    'd2xlZGdlX2R1cGxpY2F0ZXMYBiABKAlSFWFja25vd2xlZGdlRHVwbGljYXRlcxIiCg1lbnRlcm'
    'VkX2J5X2lkGAcgASgJUgtlbnRlcmVkQnlJZA==');

@$core.Deprecated('Use placeFromOrderSetResponseDescriptor instead')
const PlaceFromOrderSetResponse$json = {
  '1': 'PlaceFromOrderSetResponse',
  '2': [
    {
      '1': 'placed',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'placed'
    },
    {
      '1': 'warnings',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.PlaceFromOrderSetResponse.WarningsEntry',
      '10': 'warnings'
    },
  ],
  '3': [PlaceFromOrderSetResponse_WarningsEntry$json],
};

@$core.Deprecated('Use placeFromOrderSetResponseDescriptor instead')
const PlaceFromOrderSetResponse_WarningsEntry$json = {
  '1': 'WarningsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.DuplicateWarning',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `PlaceFromOrderSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeFromOrderSetResponseDescriptor = $convert.base64Decode(
    'ChlQbGFjZUZyb21PcmRlclNldFJlc3BvbnNlEjMKBnBsYWNlZBgBIAMoCzIbLmhlYWx0aGNhcm'
    'Uub3JkZXJzLnYxLk9yZGVyUgZwbGFjZWQSWQoId2FybmluZ3MYAiADKAsyPS5oZWFsdGhjYXJl'
    'Lm9yZGVycy52MS5QbGFjZUZyb21PcmRlclNldFJlc3BvbnNlLldhcm5pbmdzRW50cnlSCHdhcm'
    '5pbmdzGmMKDVdhcm5pbmdzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSPAoFdmFsdWUYAiABKAsy'
    'Ji5oZWFsdGhjYXJlLm9yZGVycy52MS5EdXBsaWNhdGVXYXJuaW5nUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use favouriteDescriptor instead')
const Favourite$json = {
  '1': 'Favourite',
  '2': [
    {'1': 'favourite_id', '3': 1, '4': 1, '5': 9, '10': 'favouriteId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Coding',
      '10': 'code'
    },
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 6, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'priority',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'timing',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Timing',
      '10': 'timing'
    },
    {
      '1': 'created_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Favourite`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouriteDescriptor = $convert.base64Decode(
    'CglGYXZvdXJpdGUSIQoMZmF2b3VyaXRlX2lkGAEgASgJUgtmYXZvdXJpdGVJZBISCgRuYW1lGA'
    'IgASgJUgRuYW1lEjMKBHR5cGUYAyABKA4yHy5oZWFsdGhjYXJlLm9yZGVycy52MS5PcmRlclR5'
    'cGVSBHR5cGUSMAoEY29kZRgEIAEoCzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLkNvZGluZ1IEY2'
    '9kZRIWCgZkZXRhaWwYBSABKAlSBmRldGFpbBIeCgppbmRpY2F0aW9uGAYgASgJUgppbmRpY2F0'
    'aW9uEjoKCHByaW9yaXR5GAcgASgOMh4uaGVhbHRoY2FyZS5vcmRlcnMudjEuUHJpb3JpdHlSCH'
    'ByaW9yaXR5EjQKBnRpbWluZxgIIAEoCzIcLmhlYWx0aGNhcmUub3JkZXJzLnYxLlRpbWluZ1IG'
    'dGltaW5nEjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'ljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use saveFavouriteRequestDescriptor instead')
const SaveFavouriteRequest$json = {
  '1': 'SaveFavouriteRequest',
  '2': [
    {
      '1': 'favourite',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Favourite',
      '10': 'favourite'
    },
  ],
};

/// Descriptor for `SaveFavouriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveFavouriteRequestDescriptor = $convert.base64Decode(
    'ChRTYXZlRmF2b3VyaXRlUmVxdWVzdBI9CglmYXZvdXJpdGUYASABKAsyHy5oZWFsdGhjYXJlLm'
    '9yZGVycy52MS5GYXZvdXJpdGVSCWZhdm91cml0ZQ==');

@$core.Deprecated('Use saveFavouriteResponseDescriptor instead')
const SaveFavouriteResponse$json = {
  '1': 'SaveFavouriteResponse',
  '2': [
    {
      '1': 'favourite',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Favourite',
      '10': 'favourite'
    },
  ],
};

/// Descriptor for `SaveFavouriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveFavouriteResponseDescriptor = $convert.base64Decode(
    'ChVTYXZlRmF2b3VyaXRlUmVzcG9uc2USPQoJZmF2b3VyaXRlGAEgASgLMh8uaGVhbHRoY2FyZS'
    '5vcmRlcnMudjEuRmF2b3VyaXRlUglmYXZvdXJpdGU=');

@$core.Deprecated('Use listFavouritesRequestDescriptor instead')
const ListFavouritesRequest$json = {
  '1': 'ListFavouritesRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListFavouritesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFavouritesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RmF2b3VyaXRlc1JlcXVlc3QSMwoEdHlwZRgBIAEoDjIfLmhlYWx0aGNhcmUub3JkZX'
    'JzLnYxLk9yZGVyVHlwZVIEdHlwZRIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listFavouritesResponseDescriptor instead')
const ListFavouritesResponse$json = {
  '1': 'ListFavouritesResponse',
  '2': [
    {
      '1': 'favourites',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.orders.v1.Favourite',
      '10': 'favourites'
    },
  ],
};

/// Descriptor for `ListFavouritesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFavouritesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RmF2b3VyaXRlc1Jlc3BvbnNlEj8KCmZhdm91cml0ZXMYASADKAsyHy5oZWFsdGhjYX'
        'JlLm9yZGVycy52MS5GYXZvdXJpdGVSCmZhdm91cml0ZXM=');

@$core.Deprecated('Use deleteFavouriteRequestDescriptor instead')
const DeleteFavouriteRequest$json = {
  '1': 'DeleteFavouriteRequest',
  '2': [
    {'1': 'favourite_id', '3': 1, '4': 1, '5': 9, '10': 'favouriteId'},
  ],
};

/// Descriptor for `DeleteFavouriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFavouriteRequestDescriptor =
    $convert.base64Decode(
        'ChZEZWxldGVGYXZvdXJpdGVSZXF1ZXN0EiEKDGZhdm91cml0ZV9pZBgBIAEoCVILZmF2b3VyaX'
        'RlSWQ=');

@$core.Deprecated('Use deleteFavouriteResponseDescriptor instead')
const DeleteFavouriteResponse$json = {
  '1': 'DeleteFavouriteResponse',
};

/// Descriptor for `DeleteFavouriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFavouriteResponseDescriptor =
    $convert.base64Decode('ChdEZWxldGVGYXZvdXJpdGVSZXNwb25zZQ==');

@$core.Deprecated('Use placeFromFavouriteRequestDescriptor instead')
const PlaceFromFavouriteRequest$json = {
  '1': 'PlaceFromFavouriteRequest',
  '2': [
    {'1': 'favourite_id', '3': 1, '4': 1, '5': 9, '10': 'favouriteId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'indication', '3': 5, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'priority',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'acknowledge_duplicates',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'acknowledgeDuplicates'
    },
    {'1': 'entered_by_id', '3': 8, '4': 1, '5': 9, '10': 'enteredById'},
  ],
};

/// Descriptor for `PlaceFromFavouriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeFromFavouriteRequestDescriptor = $convert.base64Decode(
    'ChlQbGFjZUZyb21GYXZvdXJpdGVSZXF1ZXN0EiEKDGZhdm91cml0ZV9pZBgBIAEoCVILZmF2b3'
    'VyaXRlSWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgD'
    'IAEoCVILZW5jb3VudGVySWQSFgoGZGV0YWlsGAQgASgJUgZkZXRhaWwSHgoKaW5kaWNhdGlvbh'
    'gFIAEoCVIKaW5kaWNhdGlvbhI6Cghwcmlvcml0eRgGIAEoDjIeLmhlYWx0aGNhcmUub3JkZXJz'
    'LnYxLlByaW9yaXR5Ughwcmlvcml0eRI1ChZhY2tub3dsZWRnZV9kdXBsaWNhdGVzGAcgASgJUh'
    'VhY2tub3dsZWRnZUR1cGxpY2F0ZXMSIgoNZW50ZXJlZF9ieV9pZBgIIAEoCVILZW50ZXJlZEJ5'
    'SWQ=');

@$core.Deprecated('Use placeFromFavouriteResponseDescriptor instead')
const PlaceFromFavouriteResponse$json = {
  '1': 'PlaceFromFavouriteResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.Order',
      '10': 'order'
    },
    {
      '1': 'warning',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.orders.v1.DuplicateWarning',
      '10': 'warning'
    },
  ],
};

/// Descriptor for `PlaceFromFavouriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeFromFavouriteResponseDescriptor =
    $convert.base64Decode(
        'ChpQbGFjZUZyb21GYXZvdXJpdGVSZXNwb25zZRIxCgVvcmRlchgBIAEoCzIbLmhlYWx0aGNhcm'
        'Uub3JkZXJzLnYxLk9yZGVyUgVvcmRlchJACgd3YXJuaW5nGAIgASgLMiYuaGVhbHRoY2FyZS5v'
        'cmRlcnMudjEuRHVwbGljYXRlV2FybmluZ1IHd2FybmluZw==');

@$core.Deprecated('Use setOrderPolicyRequestDescriptor instead')
const SetOrderPolicyRequest$json = {
  '1': 'SetOrderPolicyRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {
      '1': 'indication_required',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'indicationRequired'
    },
    {
      '1': 'structured_timing_required',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'structuredTimingRequired'
    },
    {
      '1': 'required_privilege',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'requiredPrivilege'
    },
  ],
};

/// Descriptor for `SetOrderPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setOrderPolicyRequestDescriptor = $convert.base64Decode(
    'ChVTZXRPcmRlclBvbGljeVJlcXVlc3QSMwoEdHlwZRgBIAEoDjIfLmhlYWx0aGNhcmUub3JkZX'
    'JzLnYxLk9yZGVyVHlwZVIEdHlwZRIvChNpbmRpY2F0aW9uX3JlcXVpcmVkGAIgASgIUhJpbmRp'
    'Y2F0aW9uUmVxdWlyZWQSPAoac3RydWN0dXJlZF90aW1pbmdfcmVxdWlyZWQYAyABKAhSGHN0cn'
    'VjdHVyZWRUaW1pbmdSZXF1aXJlZBItChJyZXF1aXJlZF9wcml2aWxlZ2UYBCABKAlSEXJlcXVp'
    'cmVkUHJpdmlsZWdl');

@$core.Deprecated('Use setOrderPolicyResponseDescriptor instead')
const SetOrderPolicyResponse$json = {
  '1': 'SetOrderPolicyResponse',
};

/// Descriptor for `SetOrderPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setOrderPolicyResponseDescriptor =
    $convert.base64Decode('ChZTZXRPcmRlclBvbGljeVJlc3BvbnNl');

@$core.Deprecated('Use setDuplicateRuleRequestDescriptor instead')
const SetDuplicateRuleRequest$json = {
  '1': 'SetDuplicateRuleRequest',
  '2': [
    {
      '1': 'type',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.orders.v1.OrderType',
      '10': 'type'
    },
    {'1': 'within_seconds', '3': 2, '4': 1, '5': 3, '10': 'withinSeconds'},
    {'1': 'same_code_only', '3': 3, '4': 1, '5': 8, '10': 'sameCodeOnly'},
    {'1': 'overridable', '3': 4, '4': 1, '5': 8, '10': 'overridable'},
  ],
};

/// Descriptor for `SetDuplicateRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDuplicateRuleRequestDescriptor = $convert.base64Decode(
    'ChdTZXREdXBsaWNhdGVSdWxlUmVxdWVzdBIzCgR0eXBlGAEgASgOMh8uaGVhbHRoY2FyZS5vcm'
    'RlcnMudjEuT3JkZXJUeXBlUgR0eXBlEiUKDndpdGhpbl9zZWNvbmRzGAIgASgDUg13aXRoaW5T'
    'ZWNvbmRzEiQKDnNhbWVfY29kZV9vbmx5GAMgASgIUgxzYW1lQ29kZU9ubHkSIAoLb3ZlcnJpZG'
    'FibGUYBCABKAhSC292ZXJyaWRhYmxl');

@$core.Deprecated('Use setDuplicateRuleResponseDescriptor instead')
const SetDuplicateRuleResponse$json = {
  '1': 'SetDuplicateRuleResponse',
};

/// Descriptor for `SetDuplicateRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDuplicateRuleResponseDescriptor =
    $convert.base64Decode('ChhTZXREdXBsaWNhdGVSdWxlUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> OrderServiceBase$json = {
  '1': 'OrderService',
  '2': [
    {
      '1': 'PlaceOrder',
      '2': '.healthcare.orders.v1.PlaceOrderRequest',
      '3': '.healthcare.orders.v1.PlaceOrderResponse'
    },
    {
      '1': 'GetOrder',
      '2': '.healthcare.orders.v1.GetOrderRequest',
      '3': '.healthcare.orders.v1.GetOrderResponse'
    },
    {
      '1': 'ListOrders',
      '2': '.healthcare.orders.v1.ListOrdersRequest',
      '3': '.healthcare.orders.v1.ListOrdersResponse'
    },
    {
      '1': 'GetWorklist',
      '2': '.healthcare.orders.v1.GetWorklistRequest',
      '3': '.healthcare.orders.v1.GetWorklistResponse'
    },
    {
      '1': 'CancelOrder',
      '2': '.healthcare.orders.v1.CancelOrderRequest',
      '3': '.healthcare.orders.v1.CancelOrderResponse'
    },
    {
      '1': 'RetractOrder',
      '2': '.healthcare.orders.v1.RetractOrderRequest',
      '3': '.healthcare.orders.v1.RetractOrderResponse'
    },
    {
      '1': 'AcknowledgeOrder',
      '2': '.healthcare.orders.v1.AcknowledgeOrderRequest',
      '3': '.healthcare.orders.v1.AcknowledgeOrderResponse'
    },
    {
      '1': 'DefineOrderSet',
      '2': '.healthcare.orders.v1.DefineOrderSetRequest',
      '3': '.healthcare.orders.v1.DefineOrderSetResponse'
    },
    {
      '1': 'ListOrderSets',
      '2': '.healthcare.orders.v1.ListOrderSetsRequest',
      '3': '.healthcare.orders.v1.ListOrderSetsResponse'
    },
    {
      '1': 'RetireOrderSet',
      '2': '.healthcare.orders.v1.RetireOrderSetRequest',
      '3': '.healthcare.orders.v1.RetireOrderSetResponse'
    },
    {
      '1': 'PlaceFromOrderSet',
      '2': '.healthcare.orders.v1.PlaceFromOrderSetRequest',
      '3': '.healthcare.orders.v1.PlaceFromOrderSetResponse'
    },
    {
      '1': 'SaveFavourite',
      '2': '.healthcare.orders.v1.SaveFavouriteRequest',
      '3': '.healthcare.orders.v1.SaveFavouriteResponse'
    },
    {
      '1': 'ListFavourites',
      '2': '.healthcare.orders.v1.ListFavouritesRequest',
      '3': '.healthcare.orders.v1.ListFavouritesResponse'
    },
    {
      '1': 'DeleteFavourite',
      '2': '.healthcare.orders.v1.DeleteFavouriteRequest',
      '3': '.healthcare.orders.v1.DeleteFavouriteResponse'
    },
    {
      '1': 'PlaceFromFavourite',
      '2': '.healthcare.orders.v1.PlaceFromFavouriteRequest',
      '3': '.healthcare.orders.v1.PlaceFromFavouriteResponse'
    },
    {
      '1': 'SetOrderPolicy',
      '2': '.healthcare.orders.v1.SetOrderPolicyRequest',
      '3': '.healthcare.orders.v1.SetOrderPolicyResponse'
    },
    {
      '1': 'SetDuplicateRule',
      '2': '.healthcare.orders.v1.SetDuplicateRuleRequest',
      '3': '.healthcare.orders.v1.SetDuplicateRuleResponse'
    },
  ],
};

@$core.Deprecated('Use orderServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OrderServiceBase$messageJson = {
  '.healthcare.orders.v1.PlaceOrderRequest': PlaceOrderRequest$json,
  '.healthcare.orders.v1.Coding': Coding$json,
  '.healthcare.orders.v1.Timing': Timing$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.orders.v1.PlaceOrderResponse': PlaceOrderResponse$json,
  '.healthcare.orders.v1.Order': Order$json,
  '.healthcare.orders.v1.StatusChange': StatusChange$json,
  '.healthcare.orders.v1.DuplicateOverride': DuplicateOverride$json,
  '.healthcare.orders.v1.DuplicateWarning': DuplicateWarning$json,
  '.healthcare.orders.v1.GetOrderRequest': GetOrderRequest$json,
  '.healthcare.orders.v1.GetOrderResponse': GetOrderResponse$json,
  '.healthcare.orders.v1.ListOrdersRequest': ListOrdersRequest$json,
  '.healthcare.orders.v1.ListOrdersResponse': ListOrdersResponse$json,
  '.healthcare.orders.v1.GetWorklistRequest': GetWorklistRequest$json,
  '.healthcare.orders.v1.GetWorklistResponse': GetWorklistResponse$json,
  '.healthcare.orders.v1.CancelOrderRequest': CancelOrderRequest$json,
  '.healthcare.orders.v1.CancelOrderResponse': CancelOrderResponse$json,
  '.healthcare.orders.v1.RetractOrderRequest': RetractOrderRequest$json,
  '.healthcare.orders.v1.RetractOrderResponse': RetractOrderResponse$json,
  '.healthcare.orders.v1.AcknowledgeOrderRequest': AcknowledgeOrderRequest$json,
  '.healthcare.orders.v1.AcknowledgeOrderResponse':
      AcknowledgeOrderResponse$json,
  '.healthcare.orders.v1.DefineOrderSetRequest': DefineOrderSetRequest$json,
  '.healthcare.orders.v1.OrderSet': OrderSet$json,
  '.healthcare.orders.v1.Component': Component$json,
  '.healthcare.orders.v1.DefineOrderSetResponse': DefineOrderSetResponse$json,
  '.healthcare.orders.v1.ListOrderSetsRequest': ListOrderSetsRequest$json,
  '.healthcare.orders.v1.ListOrderSetsResponse': ListOrderSetsResponse$json,
  '.healthcare.orders.v1.RetireOrderSetRequest': RetireOrderSetRequest$json,
  '.healthcare.orders.v1.RetireOrderSetResponse': RetireOrderSetResponse$json,
  '.healthcare.orders.v1.PlaceFromOrderSetRequest':
      PlaceFromOrderSetRequest$json,
  '.healthcare.orders.v1.Selection': Selection$json,
  '.healthcare.orders.v1.PlaceFromOrderSetResponse':
      PlaceFromOrderSetResponse$json,
  '.healthcare.orders.v1.PlaceFromOrderSetResponse.WarningsEntry':
      PlaceFromOrderSetResponse_WarningsEntry$json,
  '.healthcare.orders.v1.SaveFavouriteRequest': SaveFavouriteRequest$json,
  '.healthcare.orders.v1.Favourite': Favourite$json,
  '.healthcare.orders.v1.SaveFavouriteResponse': SaveFavouriteResponse$json,
  '.healthcare.orders.v1.ListFavouritesRequest': ListFavouritesRequest$json,
  '.healthcare.orders.v1.ListFavouritesResponse': ListFavouritesResponse$json,
  '.healthcare.orders.v1.DeleteFavouriteRequest': DeleteFavouriteRequest$json,
  '.healthcare.orders.v1.DeleteFavouriteResponse': DeleteFavouriteResponse$json,
  '.healthcare.orders.v1.PlaceFromFavouriteRequest':
      PlaceFromFavouriteRequest$json,
  '.healthcare.orders.v1.PlaceFromFavouriteResponse':
      PlaceFromFavouriteResponse$json,
  '.healthcare.orders.v1.SetOrderPolicyRequest': SetOrderPolicyRequest$json,
  '.healthcare.orders.v1.SetOrderPolicyResponse': SetOrderPolicyResponse$json,
  '.healthcare.orders.v1.SetDuplicateRuleRequest': SetDuplicateRuleRequest$json,
  '.healthcare.orders.v1.SetDuplicateRuleResponse':
      SetDuplicateRuleResponse$json,
};

/// Descriptor for `OrderService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List orderServiceDescriptor = $convert.base64Decode(
    'CgxPcmRlclNlcnZpY2USXwoKUGxhY2VPcmRlchInLmhlYWx0aGNhcmUub3JkZXJzLnYxLlBsYW'
    'NlT3JkZXJSZXF1ZXN0GiguaGVhbHRoY2FyZS5vcmRlcnMudjEuUGxhY2VPcmRlclJlc3BvbnNl'
    'ElkKCEdldE9yZGVyEiUuaGVhbHRoY2FyZS5vcmRlcnMudjEuR2V0T3JkZXJSZXF1ZXN0GiYuaG'
    'VhbHRoY2FyZS5vcmRlcnMudjEuR2V0T3JkZXJSZXNwb25zZRJfCgpMaXN0T3JkZXJzEicuaGVh'
    'bHRoY2FyZS5vcmRlcnMudjEuTGlzdE9yZGVyc1JlcXVlc3QaKC5oZWFsdGhjYXJlLm9yZGVycy'
    '52MS5MaXN0T3JkZXJzUmVzcG9uc2USYgoLR2V0V29ya2xpc3QSKC5oZWFsdGhjYXJlLm9yZGVy'
    'cy52MS5HZXRXb3JrbGlzdFJlcXVlc3QaKS5oZWFsdGhjYXJlLm9yZGVycy52MS5HZXRXb3JrbG'
    'lzdFJlc3BvbnNlEmIKC0NhbmNlbE9yZGVyEiguaGVhbHRoY2FyZS5vcmRlcnMudjEuQ2FuY2Vs'
    'T3JkZXJSZXF1ZXN0GikuaGVhbHRoY2FyZS5vcmRlcnMudjEuQ2FuY2VsT3JkZXJSZXNwb25zZR'
    'JlCgxSZXRyYWN0T3JkZXISKS5oZWFsdGhjYXJlLm9yZGVycy52MS5SZXRyYWN0T3JkZXJSZXF1'
    'ZXN0GiouaGVhbHRoY2FyZS5vcmRlcnMudjEuUmV0cmFjdE9yZGVyUmVzcG9uc2UScQoQQWNrbm'
    '93bGVkZ2VPcmRlchItLmhlYWx0aGNhcmUub3JkZXJzLnYxLkFja25vd2xlZGdlT3JkZXJSZXF1'
    'ZXN0Gi4uaGVhbHRoY2FyZS5vcmRlcnMudjEuQWNrbm93bGVkZ2VPcmRlclJlc3BvbnNlEmsKDk'
    'RlZmluZU9yZGVyU2V0EisuaGVhbHRoY2FyZS5vcmRlcnMudjEuRGVmaW5lT3JkZXJTZXRSZXF1'
    'ZXN0GiwuaGVhbHRoY2FyZS5vcmRlcnMudjEuRGVmaW5lT3JkZXJTZXRSZXNwb25zZRJoCg1MaX'
    'N0T3JkZXJTZXRzEiouaGVhbHRoY2FyZS5vcmRlcnMudjEuTGlzdE9yZGVyU2V0c1JlcXVlc3Qa'
    'Ky5oZWFsdGhjYXJlLm9yZGVycy52MS5MaXN0T3JkZXJTZXRzUmVzcG9uc2USawoOUmV0aXJlT3'
    'JkZXJTZXQSKy5oZWFsdGhjYXJlLm9yZGVycy52MS5SZXRpcmVPcmRlclNldFJlcXVlc3QaLC5o'
    'ZWFsdGhjYXJlLm9yZGVycy52MS5SZXRpcmVPcmRlclNldFJlc3BvbnNlEnQKEVBsYWNlRnJvbU'
    '9yZGVyU2V0Ei4uaGVhbHRoY2FyZS5vcmRlcnMudjEuUGxhY2VGcm9tT3JkZXJTZXRSZXF1ZXN0'
    'Gi8uaGVhbHRoY2FyZS5vcmRlcnMudjEuUGxhY2VGcm9tT3JkZXJTZXRSZXNwb25zZRJoCg1TYX'
    'ZlRmF2b3VyaXRlEiouaGVhbHRoY2FyZS5vcmRlcnMudjEuU2F2ZUZhdm91cml0ZVJlcXVlc3Qa'
    'Ky5oZWFsdGhjYXJlLm9yZGVycy52MS5TYXZlRmF2b3VyaXRlUmVzcG9uc2USawoOTGlzdEZhdm'
    '91cml0ZXMSKy5oZWFsdGhjYXJlLm9yZGVycy52MS5MaXN0RmF2b3VyaXRlc1JlcXVlc3QaLC5o'
    'ZWFsdGhjYXJlLm9yZGVycy52MS5MaXN0RmF2b3VyaXRlc1Jlc3BvbnNlEm4KD0RlbGV0ZUZhdm'
    '91cml0ZRIsLmhlYWx0aGNhcmUub3JkZXJzLnYxLkRlbGV0ZUZhdm91cml0ZVJlcXVlc3QaLS5o'
    'ZWFsdGhjYXJlLm9yZGVycy52MS5EZWxldGVGYXZvdXJpdGVSZXNwb25zZRJ3ChJQbGFjZUZyb2'
    '1GYXZvdXJpdGUSLy5oZWFsdGhjYXJlLm9yZGVycy52MS5QbGFjZUZyb21GYXZvdXJpdGVSZXF1'
    'ZXN0GjAuaGVhbHRoY2FyZS5vcmRlcnMudjEuUGxhY2VGcm9tRmF2b3VyaXRlUmVzcG9uc2USaw'
    'oOU2V0T3JkZXJQb2xpY3kSKy5oZWFsdGhjYXJlLm9yZGVycy52MS5TZXRPcmRlclBvbGljeVJl'
    'cXVlc3QaLC5oZWFsdGhjYXJlLm9yZGVycy52MS5TZXRPcmRlclBvbGljeVJlc3BvbnNlEnEKEF'
    'NldER1cGxpY2F0ZVJ1bGUSLS5oZWFsdGhjYXJlLm9yZGVycy52MS5TZXREdXBsaWNhdGVSdWxl'
    'UmVxdWVzdBouLmhlYWx0aGNhcmUub3JkZXJzLnYxLlNldER1cGxpY2F0ZVJ1bGVSZXNwb25zZQ'
    '==');
