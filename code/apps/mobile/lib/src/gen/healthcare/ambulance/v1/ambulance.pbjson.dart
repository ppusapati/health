// This is a generated file - do not edit.
//
// Generated from healthcare/ambulance/v1/ambulance.proto.

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

@$core.Deprecated('Use vehicleKindDescriptor instead')
const VehicleKind$json = {
  '1': 'VehicleKind',
  '2': [
    {'1': 'VEHICLE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'VEHICLE_KIND_ALS', '2': 1},
    {'1': 'VEHICLE_KIND_BLS', '2': 2},
    {'1': 'VEHICLE_KIND_TRANSPORT', '2': 3},
    {'1': 'VEHICLE_KIND_NEONATAL', '2': 4},
  ],
};

/// Descriptor for `VehicleKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List vehicleKindDescriptor = $convert.base64Decode(
    'CgtWZWhpY2xlS2luZBIcChhWRUhJQ0xFX0tJTkRfVU5TUEVDSUZJRUQQABIUChBWRUhJQ0xFX0'
    'tJTkRfQUxTEAESFAoQVkVISUNMRV9LSU5EX0JMUxACEhoKFlZFSElDTEVfS0lORF9UUkFOU1BP'
    'UlQQAxIZChVWRUhJQ0xFX0tJTkRfTkVPTkFUQUwQBA==');

@$core.Deprecated('Use vehicleStateDescriptor instead')
const VehicleState$json = {
  '1': 'VehicleState',
  '2': [
    {'1': 'VEHICLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'VEHICLE_STATE_OUT_OF_SERVICE', '2': 1},
    {'1': 'VEHICLE_STATE_AVAILABLE', '2': 2},
    {'1': 'VEHICLE_STATE_ON_TRIP', '2': 3},
    {'1': 'VEHICLE_STATE_RETIRED', '2': 4},
  ],
};

/// Descriptor for `VehicleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List vehicleStateDescriptor = $convert.base64Decode(
    'CgxWZWhpY2xlU3RhdGUSHQoZVkVISUNMRV9TVEFURV9VTlNQRUNJRklFRBAAEiAKHFZFSElDTE'
    'VfU1RBVEVfT1VUX09GX1NFUlZJQ0UQARIbChdWRUhJQ0xFX1NUQVRFX0FWQUlMQUJMRRACEhkK'
    'FVZFSElDTEVfU1RBVEVfT05fVFJJUBADEhkKFVZFSElDTEVfU1RBVEVfUkVUSVJFRBAE');

@$core.Deprecated('Use crewRoleDescriptor instead')
const CrewRole$json = {
  '1': 'CrewRole',
  '2': [
    {'1': 'CREW_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'CREW_ROLE_DRIVER', '2': 1},
    {'1': 'CREW_ROLE_EMT', '2': 2},
    {'1': 'CREW_ROLE_PARAMEDIC', '2': 3},
    {'1': 'CREW_ROLE_NURSE', '2': 4},
    {'1': 'CREW_ROLE_DOCTOR', '2': 5},
  ],
};

/// Descriptor for `CrewRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List crewRoleDescriptor = $convert.base64Decode(
    'CghDcmV3Um9sZRIZChVDUkVXX1JPTEVfVU5TUEVDSUZJRUQQABIUChBDUkVXX1JPTEVfRFJJVk'
    'VSEAESEQoNQ1JFV19ST0xFX0VNVBACEhcKE0NSRVdfUk9MRV9QQVJBTUVESUMQAxITCg9DUkVX'
    'X1JPTEVfTlVSU0UQBBIUChBDUkVXX1JPTEVfRE9DVE9SEAU=');

@$core.Deprecated('Use shiftStateDescriptor instead')
const ShiftState$json = {
  '1': 'ShiftState',
  '2': [
    {'1': 'SHIFT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SHIFT_STATE_PLANNED', '2': 1},
    {'1': 'SHIFT_STATE_ON_DUTY', '2': 2},
    {'1': 'SHIFT_STATE_ENDED', '2': 3},
  ],
};

/// Descriptor for `ShiftState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List shiftStateDescriptor = $convert.base64Decode(
    'CgpTaGlmdFN0YXRlEhsKF1NISUZUX1NUQVRFX1VOU1BFQ0lGSUVEEAASFwoTU0hJRlRfU1RBVE'
    'VfUExBTk5FRBABEhcKE1NISUZUX1NUQVRFX09OX0RVVFkQAhIVChFTSElGVF9TVEFURV9FTkRF'
    'RBAD');

@$core.Deprecated('Use checkStateDescriptor instead')
const CheckState$json = {
  '1': 'CheckState',
  '2': [
    {'1': 'CHECK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CHECK_STATE_PASSED', '2': 1},
    {'1': 'CHECK_STATE_FAILED', '2': 2},
    {'1': 'CHECK_STATE_OVERRIDDEN', '2': 3},
  ],
};

/// Descriptor for `CheckState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List checkStateDescriptor = $convert.base64Decode(
    'CgpDaGVja1N0YXRlEhsKF0NIRUNLX1NUQVRFX1VOU1BFQ0lGSUVEEAASFgoSQ0hFQ0tfU1RBVE'
    'VfUEFTU0VEEAESFgoSQ0hFQ0tfU1RBVEVfRkFJTEVEEAISGgoWQ0hFQ0tfU1RBVEVfT1ZFUlJJ'
    'RERFThAD');

@$core.Deprecated('Use priorityDescriptor instead')
const Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_IMMEDIATE', '2': 1},
    {'1': 'PRIORITY_URGENT', '2': 2},
    {'1': 'PRIORITY_ROUTINE', '2': 3},
  ],
};

/// Descriptor for `Priority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityDescriptor = $convert.base64Decode(
    'CghQcmlvcml0eRIYChRQUklPUklUWV9VTlNQRUNJRklFRBAAEhYKElBSSU9SSVRZX0lNTUVESU'
    'FURRABEhMKD1BSSU9SSVRZX1VSR0VOVBACEhQKEFBSSU9SSVRZX1JPVVRJTkUQAw==');

@$core.Deprecated('Use requestKindDescriptor instead')
const RequestKind$json = {
  '1': 'RequestKind',
  '2': [
    {'1': 'REQUEST_KIND_UNSPECIFIED', '2': 0},
    {'1': 'REQUEST_KIND_EMERGENCY', '2': 1},
    {'1': 'REQUEST_KIND_INTERFACILITY', '2': 2},
    {'1': 'REQUEST_KIND_DISCHARGE', '2': 3},
  ],
};

/// Descriptor for `RequestKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requestKindDescriptor = $convert.base64Decode(
    'CgtSZXF1ZXN0S2luZBIcChhSRVFVRVNUX0tJTkRfVU5TUEVDSUZJRUQQABIaChZSRVFVRVNUX0'
    'tJTkRfRU1FUkdFTkNZEAESHgoaUkVRVUVTVF9LSU5EX0lOVEVSRkFDSUxJVFkQAhIaChZSRVFV'
    'RVNUX0tJTkRfRElTQ0hBUkdFEAM=');

@$core.Deprecated('Use requestStateDescriptor instead')
const RequestState$json = {
  '1': 'RequestState',
  '2': [
    {'1': 'REQUEST_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REQUEST_STATE_QUEUED', '2': 1},
    {'1': 'REQUEST_STATE_ASSIGNED', '2': 2},
    {'1': 'REQUEST_STATE_COMPLETED', '2': 3},
    {'1': 'REQUEST_STATE_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `RequestState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List requestStateDescriptor = $convert.base64Decode(
    'CgxSZXF1ZXN0U3RhdGUSHQoZUkVRVUVTVF9TVEFURV9VTlNQRUNJRklFRBAAEhgKFFJFUVVFU1'
    'RfU1RBVEVfUVVFVUVEEAESGgoWUkVRVUVTVF9TVEFURV9BU1NJR05FRBACEhsKF1JFUVVFU1Rf'
    'U1RBVEVfQ09NUExFVEVEEAMSGwoXUkVRVUVTVF9TVEFURV9DQU5DRUxMRUQQBA==');

@$core.Deprecated('Use milestoneDescriptor instead')
const Milestone$json = {
  '1': 'Milestone',
  '2': [
    {'1': 'MILESTONE_UNSPECIFIED', '2': 0},
    {'1': 'MILESTONE_DISPATCHED', '2': 1},
    {'1': 'MILESTONE_MOBILE', '2': 2},
    {'1': 'MILESTONE_AT_SCENE', '2': 3},
    {'1': 'MILESTONE_WITH_PATIENT', '2': 4},
    {'1': 'MILESTONE_LEFT_SCENE', '2': 5},
    {'1': 'MILESTONE_AT_DESTINATION', '2': 6},
    {'1': 'MILESTONE_HANDOVER', '2': 7},
    {'1': 'MILESTONE_CLEAR', '2': 8},
  ],
};

/// Descriptor for `Milestone`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List milestoneDescriptor = $convert.base64Decode(
    'CglNaWxlc3RvbmUSGQoVTUlMRVNUT05FX1VOU1BFQ0lGSUVEEAASGAoUTUlMRVNUT05FX0RJU1'
    'BBVENIRUQQARIUChBNSUxFU1RPTkVfTU9CSUxFEAISFgoSTUlMRVNUT05FX0FUX1NDRU5FEAMS'
    'GgoWTUlMRVNUT05FX1dJVEhfUEFUSUVOVBAEEhgKFE1JTEVTVE9ORV9MRUZUX1NDRU5FEAUSHA'
    'oYTUlMRVNUT05FX0FUX0RFU1RJTkFUSU9OEAYSFgoSTUlMRVNUT05FX0hBTkRPVkVSEAcSEwoP'
    'TUlMRVNUT05FX0NMRUFSEAg=');

@$core.Deprecated('Use tripStateDescriptor instead')
const TripState$json = {
  '1': 'TripState',
  '2': [
    {'1': 'TRIP_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TRIP_STATE_ACTIVE', '2': 1},
    {'1': 'TRIP_STATE_COMPLETED', '2': 2},
    {'1': 'TRIP_STATE_ABORTED', '2': 3},
  ],
};

/// Descriptor for `TripState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tripStateDescriptor = $convert.base64Decode(
    'CglUcmlwU3RhdGUSGgoWVFJJUF9TVEFURV9VTlNQRUNJRklFRBAAEhUKEVRSSVBfU1RBVEVfQU'
    'NUSVZFEAESGAoUVFJJUF9TVEFURV9DT01QTEVURUQQAhIWChJUUklQX1NUQVRFX0FCT1JURUQQ'
    'Aw==');

@$core.Deprecated('Use entryKindDescriptor instead')
const EntryKind$json = {
  '1': 'EntryKind',
  '2': [
    {'1': 'ENTRY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ENTRY_KIND_OBSERVATION', '2': 1},
    {'1': 'ENTRY_KIND_INTERVENTION', '2': 2},
    {'1': 'ENTRY_KIND_MEDICATION', '2': 3},
    {'1': 'ENTRY_KIND_NOTE', '2': 4},
  ],
};

/// Descriptor for `EntryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entryKindDescriptor = $convert.base64Decode(
    'CglFbnRyeUtpbmQSGgoWRU5UUllfS0lORF9VTlNQRUNJRklFRBAAEhoKFkVOVFJZX0tJTkRfT0'
    'JTRVJWQVRJT04QARIbChdFTlRSWV9LSU5EX0lOVEVSVkVOVElPThACEhkKFUVOVFJZX0tJTkRf'
    'TUVESUNBVElPThADEhMKD0VOVFJZX0tJTkRfTk9URRAE');

@$core.Deprecated('Use handoverStateDescriptor instead')
const HandoverState$json = {
  '1': 'HandoverState',
  '2': [
    {'1': 'HANDOVER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'HANDOVER_STATE_DRAFT', '2': 1},
    {'1': 'HANDOVER_STATE_GIVEN', '2': 2},
    {'1': 'HANDOVER_STATE_ACCEPTED', '2': 3},
  ],
};

/// Descriptor for `HandoverState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List handoverStateDescriptor = $convert.base64Decode(
    'Cg1IYW5kb3ZlclN0YXRlEh4KGkhBTkRPVkVSX1NUQVRFX1VOU1BFQ0lGSUVEEAASGAoUSEFORE'
    '9WRVJfU1RBVEVfRFJBRlQQARIYChRIQU5ET1ZFUl9TVEFURV9HSVZFThACEhsKF0hBTkRPVkVS'
    'X1NUQVRFX0FDQ0VQVEVEEAM=');

@$core.Deprecated('Use vehicleDescriptor instead')
const Vehicle$json = {
  '1': 'Vehicle',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'registration', '3': 2, '4': 1, '5': 9, '10': 'registration'},
    {'1': 'call_sign', '3': 3, '4': 1, '5': 9, '10': 'callSign'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleKind',
      '10': 'kind'
    },
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'base_id', '3': 6, '4': 1, '5': 9, '10': 'baseId'},
    {'1': 'capabilities', '3': 7, '4': 3, '5': 9, '10': 'capabilities'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleState',
      '10': 'state'
    },
    {
      '1': 'ready_until',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readyUntil'
    },
    {
      '1': 'out_of_service_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'outOfServiceReason'
    },
    {
      '1': 'created_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 12, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 13, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Vehicle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleDescriptor = $convert.base64Decode(
    'CgdWZWhpY2xlEh0KCnZlaGljbGVfaWQYASABKAlSCXZlaGljbGVJZBIiCgxyZWdpc3RyYXRpb2'
    '4YAiABKAlSDHJlZ2lzdHJhdGlvbhIbCgljYWxsX3NpZ24YAyABKAlSCGNhbGxTaWduEjgKBGtp'
    'bmQYBCABKA4yJC5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5WZWhpY2xlS2luZFIEa2luZBIfCg'
    'tmYWNpbGl0eV9pZBgFIAEoCVIKZmFjaWxpdHlJZBIXCgdiYXNlX2lkGAYgASgJUgZiYXNlSWQS'
    'IgoMY2FwYWJpbGl0aWVzGAcgAygJUgxjYXBhYmlsaXRpZXMSOwoFc3RhdGUYCCABKA4yJS5oZW'
    'FsdGhjYXJlLmFtYnVsYW5jZS52MS5WZWhpY2xlU3RhdGVSBXN0YXRlEjsKC3JlYWR5X3VudGls'
    'GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVhZHlVbnRpbBIxChVvdXRfb2'
    'Zfc2VydmljZV9yZWFzb24YCiABKAlSEm91dE9mU2VydmljZVJlYXNvbhI5CgpjcmVhdGVkX2F0'
    'GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0ZW'
    'RfYnkYDCABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGA0gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use crewMemberDescriptor instead')
const CrewMember$json = {
  '1': 'CrewMember',
  '2': [
    {'1': 'subject_id', '3': 1, '4': 1, '5': 9, '10': 'subjectId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.CrewRole',
      '10': 'role'
    },
    {
      '1': 'registration_number',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'registrationNumber'
    },
  ],
};

/// Descriptor for `CrewMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List crewMemberDescriptor = $convert.base64Decode(
    'CgpDcmV3TWVtYmVyEh0KCnN1YmplY3RfaWQYASABKAlSCXN1YmplY3RJZBIhCgxkaXNwbGF5X2'
    '5hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEjUKBHJvbGUYAyABKA4yIS5oZWFsdGhjYXJlLmFtYnVs'
    'YW5jZS52MS5DcmV3Um9sZVIEcm9sZRIvChNyZWdpc3RyYXRpb25fbnVtYmVyGAQgASgJUhJyZW'
    'dpc3RyYXRpb25OdW1iZXI=');

@$core.Deprecated('Use shiftDescriptor instead')
const Shift$json = {
  '1': 'Shift',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'crew',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.CrewMember',
      '10': 'crew'
    },
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.ShiftState',
      '10': 'state'
    },
    {
      '1': 'starts_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {
      '1': 'started_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Shift`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shiftDescriptor = $convert.base64Decode(
    'CgVTaGlmdBIZCghzaGlmdF9pZBgBIAEoCVIHc2hpZnRJZBIdCgp2ZWhpY2xlX2lkGAIgASgJUg'
    'l2ZWhpY2xlSWQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSNwoEY3JldxgEIAMo'
    'CzIjLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkNyZXdNZW1iZXJSBGNyZXcSOQoFc3RhdGUYBS'
    'ABKA4yIy5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5TaGlmdFN0YXRlUgVzdGF0ZRI3CglzdGFy'
    'dHNfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBIzCgdlbm'
    'RzX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGZW5kc0F0EjkKCnN0YXJ0'
    'ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQSNQoIZW'
    '5kZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRlZEF0EhgKB3Zl'
    'cnNpb24YCiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use checklistItemDescriptor instead')
const ChecklistItem$json = {
  '1': 'ChecklistItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'critical', '3': 3, '4': 1, '5': 8, '10': 'critical'},
  ],
};

/// Descriptor for `ChecklistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checklistItemDescriptor = $convert.base64Decode(
    'Cg1DaGVja2xpc3RJdGVtEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBWxhYm'
    'VsEhoKCGNyaXRpY2FsGAMgASgIUghjcml0aWNhbA==');

@$core.Deprecated('Use itemOutcomeDescriptor instead')
const ItemOutcome$json = {
  '1': 'ItemOutcome',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'present', '3': 2, '4': 1, '5': 8, '10': 'present'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ItemOutcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemOutcomeDescriptor = $convert.base64Decode(
    'CgtJdGVtT3V0Y29tZRISCgRjb2RlGAEgASgJUgRjb2RlEhgKB3ByZXNlbnQYAiABKAhSB3ByZX'
    'NlbnQSEgoEbm90ZRgDIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use readinessCheckDescriptor instead')
const ReadinessCheck$json = {
  '1': 'ReadinessCheck',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'shift_id', '3': 3, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ChecklistItem',
      '10': 'items'
    },
    {
      '1': 'outcomes',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ItemOutcome',
      '10': 'outcomes'
    },
    {'1': 'oxygen_bar', '3': 7, '4': 1, '5': 5, '10': 'oxygenBar'},
    {
      '1': 'oxygen_minimum_bar',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'oxygenMinimumBar'
    },
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.CheckState',
      '10': 'state'
    },
    {'1': 'missing', '3': 10, '4': 3, '5': 9, '10': 'missing'},
    {'1': 'override_by', '3': 11, '4': 1, '5': 9, '10': 'overrideBy'},
    {'1': 'override_reason', '3': 12, '4': 1, '5': 9, '10': 'overrideReason'},
    {
      '1': 'override_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'overrideAt'
    },
    {
      '1': 'valid_until',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {
      '1': 'checked_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedAt'
    },
    {'1': 'checked_by', '3': 16, '4': 1, '5': 9, '10': 'checkedBy'},
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ReadinessCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readinessCheckDescriptor = $convert.base64Decode(
    'Cg5SZWFkaW5lc3NDaGVjaxIZCghjaGVja19pZBgBIAEoCVIHY2hlY2tJZBIdCgp2ZWhpY2xlX2'
    'lkGAIgASgJUgl2ZWhpY2xlSWQSGQoIc2hpZnRfaWQYAyABKAlSB3NoaWZ0SWQSHwoLZmFjaWxp'
    'dHlfaWQYBCABKAlSCmZhY2lsaXR5SWQSPAoFaXRlbXMYBSADKAsyJi5oZWFsdGhjYXJlLmFtYn'
    'VsYW5jZS52MS5DaGVja2xpc3RJdGVtUgVpdGVtcxJACghvdXRjb21lcxgGIAMoCzIkLmhlYWx0'
    'aGNhcmUuYW1idWxhbmNlLnYxLkl0ZW1PdXRjb21lUghvdXRjb21lcxIdCgpveHlnZW5fYmFyGA'
    'cgASgFUglveHlnZW5CYXISLAoSb3h5Z2VuX21pbmltdW1fYmFyGAggASgFUhBveHlnZW5NaW5p'
    'bXVtQmFyEjkKBXN0YXRlGAkgASgOMiMuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQ2hlY2tTdG'
    'F0ZVIFc3RhdGUSGAoHbWlzc2luZxgKIAMoCVIHbWlzc2luZxIfCgtvdmVycmlkZV9ieRgLIAEo'
    'CVIKb3ZlcnJpZGVCeRInCg9vdmVycmlkZV9yZWFzb24YDCABKAlSDm92ZXJyaWRlUmVhc29uEj'
    'sKC292ZXJyaWRlX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb3ZlcnJp'
    'ZGVBdBI7Cgt2YWxpZF91bnRpbBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCn'
    'ZhbGlkVW50aWwSOQoKY2hlY2tlZF9hdBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSCWNoZWNrZWRBdBIdCgpjaGVja2VkX2J5GBAgASgJUgljaGVja2VkQnkSGAoHdmVyc2lvbh'
    'gRIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use requestDescriptor instead')
const Request$json = {
  '1': 'Request',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.RequestKind',
      '10': 'kind'
    },
    {
      '1': 'priority',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Priority',
      '10': 'priority'
    },
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'origin_name', '3': 6, '4': 1, '5': 9, '10': 'originName'},
    {'1': 'origin_address', '3': 7, '4': 1, '5': 9, '10': 'originAddress'},
    {
      '1': 'origin_facility_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'originFacilityId'
    },
    {'1': 'destination_name', '3': 9, '4': 1, '5': 9, '10': 'destinationName'},
    {
      '1': 'destination_address',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'destinationAddress'
    },
    {
      '1': 'destination_facility_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'destinationFacilityId'
    },
    {'1': 'clinical_need', '3': 12, '4': 1, '5': 9, '10': 'clinicalNeed'},
    {
      '1': 'required_capabilities',
      '3': 13,
      '4': 3,
      '5': 9,
      '10': 'requiredCapabilities'
    },
    {
      '1': 'state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.RequestState',
      '10': 'state'
    },
    {'1': 'trip_id', '3': 15, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'cancel_reason', '3': 16, '4': 1, '5': 9, '10': 'cancelReason'},
    {'1': 'cancelled_by', '3': 17, '4': 1, '5': 9, '10': 'cancelledBy'},
    {
      '1': 'cancelled_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cancelledAt'
    },
    {
      '1': 'requested_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {'1': 'requested_by', '3': 20, '4': 1, '5': 9, '10': 'requestedBy'},
    {'1': 'version', '3': 21, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Request`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestDescriptor = $convert.base64Decode(
    'CgdSZXF1ZXN0Eh0KCnJlcXVlc3RfaWQYASABKAlSCXJlcXVlc3RJZBI4CgRraW5kGAIgASgOMi'
    'QuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuUmVxdWVzdEtpbmRSBGtpbmQSPQoIcHJpb3JpdHkY'
    'AyABKA4yIS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5Qcmlvcml0eVIIcHJpb3JpdHkSHQoKcG'
    'F0aWVudF9pZBgEIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgFIAEoCVILZW5jb3Vu'
    'dGVySWQSHwoLb3JpZ2luX25hbWUYBiABKAlSCm9yaWdpbk5hbWUSJQoOb3JpZ2luX2FkZHJlc3'
    'MYByABKAlSDW9yaWdpbkFkZHJlc3MSLAoSb3JpZ2luX2ZhY2lsaXR5X2lkGAggASgJUhBvcmln'
    'aW5GYWNpbGl0eUlkEikKEGRlc3RpbmF0aW9uX25hbWUYCSABKAlSD2Rlc3RpbmF0aW9uTmFtZR'
    'IvChNkZXN0aW5hdGlvbl9hZGRyZXNzGAogASgJUhJkZXN0aW5hdGlvbkFkZHJlc3MSNgoXZGVz'
    'dGluYXRpb25fZmFjaWxpdHlfaWQYCyABKAlSFWRlc3RpbmF0aW9uRmFjaWxpdHlJZBIjCg1jbG'
    'luaWNhbF9uZWVkGAwgASgJUgxjbGluaWNhbE5lZWQSMwoVcmVxdWlyZWRfY2FwYWJpbGl0aWVz'
    'GA0gAygJUhRyZXF1aXJlZENhcGFiaWxpdGllcxI7CgVzdGF0ZRgOIAEoDjIlLmhlYWx0aGNhcm'
    'UuYW1idWxhbmNlLnYxLlJlcXVlc3RTdGF0ZVIFc3RhdGUSFwoHdHJpcF9pZBgPIAEoCVIGdHJp'
    'cElkEiMKDWNhbmNlbF9yZWFzb24YECABKAlSDGNhbmNlbFJlYXNvbhIhCgxjYW5jZWxsZWRfYn'
    'kYESABKAlSC2NhbmNlbGxlZEJ5Ej0KDGNhbmNlbGxlZF9hdBgSIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSC2NhbmNlbGxlZEF0Ej0KDHJlcXVlc3RlZF9hdBgTIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3JlcXVlc3RlZEF0EiEKDHJlcXVlc3RlZF9ieRgUIAEo'
    'CVILcmVxdWVzdGVkQnkSGAoHdmVyc2lvbhgVIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use milestoneRecordDescriptor instead')
const MilestoneRecord$json = {
  '1': 'MilestoneRecord',
  '2': [
    {
      '1': 'milestone',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Milestone',
      '10': 'milestone'
    },
    {
      '1': 'occurred_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'recorded_by', '3': 3, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'amends_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'amendsAt'
    },
    {'1': 'amend_reason', '3': 6, '4': 1, '5': 9, '10': 'amendReason'},
    {
      '1': 'amended_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'amendedAt'
    },
  ],
};

/// Descriptor for `MilestoneRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List milestoneRecordDescriptor = $convert.base64Decode(
    'Cg9NaWxlc3RvbmVSZWNvcmQSQAoJbWlsZXN0b25lGAEgASgOMiIuaGVhbHRoY2FyZS5hbWJ1bG'
    'FuY2UudjEuTWlsZXN0b25lUgltaWxlc3RvbmUSOwoLb2NjdXJyZWRfYXQYAiABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZEF0Eh8KC3JlY29yZGVkX2J5GAMgASgJUg'
    'pyZWNvcmRlZEJ5EhIKBG5vdGUYBCABKAlSBG5vdGUSNwoJYW1lbmRzX2F0GAUgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIYW1lbmRzQXQSIQoMYW1lbmRfcmVhc29uGAYgASgJUg'
    'thbWVuZFJlYXNvbhI5CgphbWVuZGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIJYW1lbmRlZEF0');

@$core.Deprecated('Use tripDescriptor instead')
const Trip$json = {
  '1': 'Trip',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'request_id', '3': 2, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'vehicle_id', '3': 3, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'shift_id', '3': 4, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'crew_subjects', '3': 6, '4': 3, '5': 9, '10': 'crewSubjects'},
    {'1': 'override_by', '3': 7, '4': 1, '5': 9, '10': 'overrideBy'},
    {'1': 'override_reason', '3': 8, '4': 1, '5': 9, '10': 'overrideReason'},
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.TripState',
      '10': 'state'
    },
    {
      '1': 'milestones',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.MilestoneRecord',
      '10': 'milestones'
    },
    {'1': 'abort_reason', '3': 11, '4': 1, '5': 9, '10': 'abortReason'},
    {
      '1': 'started_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 13, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'ended_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Trip`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripDescriptor = $convert.base64Decode(
    'CgRUcmlwEhcKB3RyaXBfaWQYASABKAlSBnRyaXBJZBIdCgpyZXF1ZXN0X2lkGAIgASgJUglyZX'
    'F1ZXN0SWQSHQoKdmVoaWNsZV9pZBgDIAEoCVIJdmVoaWNsZUlkEhkKCHNoaWZ0X2lkGAQgASgJ'
    'UgdzaGlmdElkEh8KC2ZhY2lsaXR5X2lkGAUgASgJUgpmYWNpbGl0eUlkEiMKDWNyZXdfc3Viam'
    'VjdHMYBiADKAlSDGNyZXdTdWJqZWN0cxIfCgtvdmVycmlkZV9ieRgHIAEoCVIKb3ZlcnJpZGVC'
    'eRInCg9vdmVycmlkZV9yZWFzb24YCCABKAlSDm92ZXJyaWRlUmVhc29uEjgKBXN0YXRlGAkgAS'
    'gOMiIuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuVHJpcFN0YXRlUgVzdGF0ZRJICgptaWxlc3Rv'
    'bmVzGAogAygLMiguaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTWlsZXN0b25lUmVjb3JkUgptaW'
    'xlc3RvbmVzEiEKDGFib3J0X3JlYXNvbhgLIAEoCVILYWJvcnRSZWFzb24SOQoKc3RhcnRlZF9h'
    'dBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBIdCgpzdGFydG'
    'VkX2J5GA0gASgJUglzdGFydGVkQnkSNQoIZW5kZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgdlbmRlZEF0EhgKB3ZlcnNpb24YDyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use entryDescriptor instead')
const Entry$json = {
  '1': 'Entry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.EntryKind',
      '10': 'kind'
    },
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
    {'1': 'unit', '3': 6, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'dose_amount', '3': 7, '4': 1, '5': 5, '10': 'doseAmount'},
    {'1': 'dose_unit', '3': 8, '4': 1, '5': 9, '10': 'doseUnit'},
    {'1': 'route', '3': 9, '4': 1, '5': 9, '10': 'route'},
    {'1': 'narrative', '3': 10, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_role',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.CrewRole',
      '10': 'recordedRole'
    },
    {
      '1': 'recorded_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {
      '1': 'entered_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'enteredAt'
    },
  ],
};

/// Descriptor for `Entry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List entryDescriptor = $convert.base64Decode(
    'CgVFbnRyeRIZCghlbnRyeV9pZBgBIAEoCVIHZW50cnlJZBI2CgRraW5kGAIgASgOMiIuaGVhbH'
    'RoY2FyZS5hbWJ1bGFuY2UudjEuRW50cnlLaW5kUgRraW5kEhIKBGNvZGUYAyABKAlSBGNvZGUS'
    'FAoFbGFiZWwYBCABKAlSBWxhYmVsEhQKBXZhbHVlGAUgASgJUgV2YWx1ZRISCgR1bml0GAYgAS'
    'gJUgR1bml0Eh8KC2Rvc2VfYW1vdW50GAcgASgFUgpkb3NlQW1vdW50EhsKCWRvc2VfdW5pdBgI'
    'IAEoCVIIZG9zZVVuaXQSFAoFcm91dGUYCSABKAlSBXJvdXRlEhwKCW5hcnJhdGl2ZRgKIAEoCV'
    'IJbmFycmF0aXZlEh8KC3JlY29yZGVkX2J5GAsgASgJUgpyZWNvcmRlZEJ5EkYKDXJlY29yZGVk'
    'X3JvbGUYDCABKA4yIS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5DcmV3Um9sZVIMcmVjb3JkZW'
    'RSb2xlEjsKC3JlY29yZGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIK'
    'cmVjb3JkZWRBdBI5CgplbnRlcmVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIJZW50ZXJlZEF0');

@$core.Deprecated('Use prehospitalRecordDescriptor instead')
const PrehospitalRecord$json = {
  '1': 'PrehospitalRecord',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'request_id', '3': 3, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'presenting_complaint',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'presentingComplaint'
    },
    {'1': 'impression', '3': 8, '4': 1, '5': 9, '10': 'impression'},
    {
      '1': 'entries',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Entry',
      '10': 'entries'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.HandoverState',
      '10': 'state'
    },
    {'1': 'sending_summary', '3': 11, '4': 1, '5': 9, '10': 'sendingSummary'},
    {'1': 'given_by', '3': 12, '4': 1, '5': 9, '10': 'givenBy'},
    {
      '1': 'given_role',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.CrewRole',
      '10': 'givenRole'
    },
    {
      '1': 'given_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {'1': 'accepted_by', '3': 15, '4': 1, '5': 9, '10': 'acceptedBy'},
    {
      '1': 'accepted_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acceptedAt'
    },
    {'1': 'accepted_note', '3': 17, '4': 1, '5': 9, '10': 'acceptedNote'},
    {'1': 'document_refs', '3': 18, '4': 3, '5': 9, '10': 'documentRefs'},
    {'1': 'version', '3': 19, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `PrehospitalRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prehospitalRecordDescriptor = $convert.base64Decode(
    'ChFQcmVob3NwaXRhbFJlY29yZBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhcKB3RyaX'
    'BfaWQYAiABKAlSBnRyaXBJZBIdCgpyZXF1ZXN0X2lkGAMgASgJUglyZXF1ZXN0SWQSHQoKcGF0'
    'aWVudF9pZBgEIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgFIAEoCVILZW5jb3VudG'
    'VySWQSHwoLZmFjaWxpdHlfaWQYBiABKAlSCmZhY2lsaXR5SWQSMQoUcHJlc2VudGluZ19jb21w'
    'bGFpbnQYByABKAlSE3ByZXNlbnRpbmdDb21wbGFpbnQSHgoKaW1wcmVzc2lvbhgIIAEoCVIKaW'
    '1wcmVzc2lvbhI4CgdlbnRyaWVzGAkgAygLMh4uaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuRW50'
    'cnlSB2VudHJpZXMSPAoFc3RhdGUYCiABKA4yJi5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5IYW'
    '5kb3ZlclN0YXRlUgVzdGF0ZRInCg9zZW5kaW5nX3N1bW1hcnkYCyABKAlSDnNlbmRpbmdTdW1t'
    'YXJ5EhkKCGdpdmVuX2J5GAwgASgJUgdnaXZlbkJ5EkAKCmdpdmVuX3JvbGUYDSABKA4yIS5oZW'
    'FsdGhjYXJlLmFtYnVsYW5jZS52MS5DcmV3Um9sZVIJZ2l2ZW5Sb2xlEjUKCGdpdmVuX2F0GA4g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZ2l2ZW5BdBIfCgthY2NlcHRlZF9ieR'
    'gPIAEoCVIKYWNjZXB0ZWRCeRI7CgthY2NlcHRlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCmFjY2VwdGVkQXQSIwoNYWNjZXB0ZWRfbm90ZRgRIAEoCVIMYWNjZXB0ZW'
    'ROb3RlEiMKDWRvY3VtZW50X3JlZnMYEiADKAlSDGRvY3VtZW50UmVmcxIYCgd2ZXJzaW9uGBMg'
    'ASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use pingDescriptor instead')
const Ping$json = {
  '1': 'Ping',
  '2': [
    {'1': 'ping_id', '3': 1, '4': 1, '5': 9, '10': 'pingId'},
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 3, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'latitude_micro', '3': 4, '4': 1, '5': 5, '10': 'latitudeMicro'},
    {'1': 'longitude_micro', '3': 5, '4': 1, '5': 5, '10': 'longitudeMicro'},
    {'1': 'speed_kph', '3': 6, '4': 1, '5': 5, '10': 'speedKph'},
    {'1': 'heading_degrees', '3': 7, '4': 1, '5': 5, '10': 'headingDegrees'},
    {'1': 'accuracy_metres', '3': 8, '4': 1, '5': 5, '10': 'accuracyMetres'},
    {'1': 'source', '3': 9, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'occurred_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'retain_until',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'retainUntil'
    },
  ],
};

/// Descriptor for `Ping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingDescriptor = $convert.base64Decode(
    'CgRQaW5nEhcKB3BpbmdfaWQYASABKAlSBnBpbmdJZBIdCgp2ZWhpY2xlX2lkGAIgASgJUgl2ZW'
    'hpY2xlSWQSFwoHdHJpcF9pZBgDIAEoCVIGdHJpcElkEiUKDmxhdGl0dWRlX21pY3JvGAQgASgF'
    'Ug1sYXRpdHVkZU1pY3JvEicKD2xvbmdpdHVkZV9taWNybxgFIAEoBVIObG9uZ2l0dWRlTWljcm'
    '8SGwoJc3BlZWRfa3BoGAYgASgFUghzcGVlZEtwaBInCg9oZWFkaW5nX2RlZ3JlZXMYByABKAVS'
    'DmhlYWRpbmdEZWdyZWVzEicKD2FjY3VyYWN5X21ldHJlcxgIIAEoBVIOYWNjdXJhY3lNZXRyZX'
    'MSFgoGc291cmNlGAkgASgJUgZzb3VyY2USOwoLb2NjdXJyZWRfYXQYCiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZEF0Ej0KDHJldGFpbl91bnRpbBgLIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3JldGFpblVudGls');

@$core.Deprecated('Use positionDescriptor instead')
const Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'latitude_micro', '3': 2, '4': 1, '5': 5, '10': 'latitudeMicro'},
    {'1': 'longitude_micro', '3': 3, '4': 1, '5': 5, '10': 'longitudeMicro'},
    {'1': 'speed_kph', '3': 4, '4': 1, '5': 5, '10': 'speedKph'},
    {'1': 'accuracy_metres', '3': 5, '4': 1, '5': 5, '10': 'accuracyMetres'},
    {'1': 'source', '3': 6, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'occurred_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'stale', '3': 8, '4': 1, '5': 8, '10': 'stale'},
    {'1': 'known', '3': 9, '4': 1, '5': 8, '10': 'known'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode(
    'CghQb3NpdGlvbhIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2xlSWQSJQoObGF0aXR1ZGVfbW'
    'ljcm8YAiABKAVSDWxhdGl0dWRlTWljcm8SJwoPbG9uZ2l0dWRlX21pY3JvGAMgASgFUg5sb25n'
    'aXR1ZGVNaWNybxIbCglzcGVlZF9rcGgYBCABKAVSCHNwZWVkS3BoEicKD2FjY3VyYWN5X21ldH'
    'JlcxgFIAEoBVIOYWNjdXJhY3lNZXRyZXMSFgoGc291cmNlGAYgASgJUgZzb3VyY2USOwoLb2Nj'
    'dXJyZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZEF0Eh'
    'QKBXN0YWxlGAggASgIUgVzdGFsZRIUCgVrbm93bhgJIAEoCFIFa25vd24=');

@$core.Deprecated('Use eTADescriptor instead')
const ETA$json = {
  '1': 'ETA',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'seconds', '3': 3, '4': 1, '5': 5, '10': 'seconds'},
    {'1': 'distance_metres', '3': 4, '4': 1, '5': 5, '10': 'distanceMetres'},
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'occurred_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'known', '3': 7, '4': 1, '5': 8, '10': 'known'},
  ],
};

/// Descriptor for `ETA`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eTADescriptor = $convert.base64Decode(
    'CgNFVEESHQoKdmVoaWNsZV9pZBgBIAEoCVIJdmVoaWNsZUlkEhcKB3RyaXBfaWQYAiABKAlSBn'
    'RyaXBJZBIYCgdzZWNvbmRzGAMgASgFUgdzZWNvbmRzEicKD2Rpc3RhbmNlX21ldHJlcxgEIAEo'
    'BVIOZGlzdGFuY2VNZXRyZXMSFgoGc291cmNlGAUgASgJUgZzb3VyY2USOwoLb2NjdXJyZWRfYX'
    'QYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZEF0EhQKBWtub3du'
    'GAcgASgIUgVrbm93bg==');

@$core.Deprecated('Use tripMetricsDescriptor instead')
const TripMetrics$json = {
  '1': 'TripMetrics',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'response_seconds', '3': 2, '4': 1, '5': 5, '10': 'responseSeconds'},
    {'1': 'response_known', '3': 3, '4': 1, '5': 8, '10': 'responseKnown'},
    {'1': 'on_scene_seconds', '3': 4, '4': 1, '5': 5, '10': 'onSceneSeconds'},
    {'1': 'on_scene_known', '3': 5, '4': 1, '5': 8, '10': 'onSceneKnown'},
    {
      '1': 'transport_seconds',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'transportSeconds'
    },
    {'1': 'transport_known', '3': 7, '4': 1, '5': 8, '10': 'transportKnown'},
    {'1': 'handover_seconds', '3': 8, '4': 1, '5': 5, '10': 'handoverSeconds'},
    {'1': 'handover_known', '3': 9, '4': 1, '5': 8, '10': 'handoverKnown'},
    {
      '1': 'turnaround_seconds',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'turnaroundSeconds'
    },
    {'1': 'turnaround_known', '3': 11, '4': 1, '5': 8, '10': 'turnaroundKnown'},
    {'1': 'total_seconds', '3': 12, '4': 1, '5': 5, '10': 'totalSeconds'},
    {'1': 'total_known', '3': 13, '4': 1, '5': 8, '10': 'totalKnown'},
    {
      '1': 'gaps',
      '3': 14,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Milestone',
      '10': 'gaps'
    },
  ],
};

/// Descriptor for `TripMetrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tripMetricsDescriptor = $convert.base64Decode(
    'CgtUcmlwTWV0cmljcxIXCgd0cmlwX2lkGAEgASgJUgZ0cmlwSWQSKQoQcmVzcG9uc2Vfc2Vjb2'
    '5kcxgCIAEoBVIPcmVzcG9uc2VTZWNvbmRzEiUKDnJlc3BvbnNlX2tub3duGAMgASgIUg1yZXNw'
    'b25zZUtub3duEigKEG9uX3NjZW5lX3NlY29uZHMYBCABKAVSDm9uU2NlbmVTZWNvbmRzEiQKDm'
    '9uX3NjZW5lX2tub3duGAUgASgIUgxvblNjZW5lS25vd24SKwoRdHJhbnNwb3J0X3NlY29uZHMY'
    'BiABKAVSEHRyYW5zcG9ydFNlY29uZHMSJwoPdHJhbnNwb3J0X2tub3duGAcgASgIUg50cmFuc3'
    'BvcnRLbm93bhIpChBoYW5kb3Zlcl9zZWNvbmRzGAggASgFUg9oYW5kb3ZlclNlY29uZHMSJQoO'
    'aGFuZG92ZXJfa25vd24YCSABKAhSDWhhbmRvdmVyS25vd24SLQoSdHVybmFyb3VuZF9zZWNvbm'
    'RzGAogASgFUhF0dXJuYXJvdW5kU2Vjb25kcxIpChB0dXJuYXJvdW5kX2tub3duGAsgASgIUg90'
    'dXJuYXJvdW5kS25vd24SIwoNdG90YWxfc2Vjb25kcxgMIAEoBVIMdG90YWxTZWNvbmRzEh8KC3'
    'RvdGFsX2tub3duGA0gASgIUgp0b3RhbEtub3duEjYKBGdhcHMYDiADKA4yIi5oZWFsdGhjYXJl'
    'LmFtYnVsYW5jZS52MS5NaWxlc3RvbmVSBGdhcHM=');

@$core.Deprecated('Use intervalDescriptor instead')
const Interval$json = {
  '1': 'Interval',
  '2': [
    {'1': 'measured', '3': 1, '4': 1, '5': 5, '10': 'measured'},
    {'1': 'mean_seconds', '3': 2, '4': 1, '5': 5, '10': 'meanSeconds'},
    {'1': 'median_seconds', '3': 3, '4': 1, '5': 5, '10': 'medianSeconds'},
    {'1': 'p90_seconds', '3': 4, '4': 1, '5': 5, '10': 'p90Seconds'},
    {'1': 'longest_seconds', '3': 5, '4': 1, '5': 5, '10': 'longestSeconds'},
    {'1': 'unanswerable', '3': 6, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `Interval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intervalDescriptor = $convert.base64Decode(
    'CghJbnRlcnZhbBIaCghtZWFzdXJlZBgBIAEoBVIIbWVhc3VyZWQSIQoMbWVhbl9zZWNvbmRzGA'
    'IgASgFUgttZWFuU2Vjb25kcxIlCg5tZWRpYW5fc2Vjb25kcxgDIAEoBVINbWVkaWFuU2Vjb25k'
    'cxIfCgtwOTBfc2Vjb25kcxgEIAEoBVIKcDkwU2Vjb25kcxInCg9sb25nZXN0X3NlY29uZHMYBS'
    'ABKAVSDmxvbmdlc3RTZWNvbmRzEiIKDHVuYW5zd2VyYWJsZRgGIAEoCFIMdW5hbnN3ZXJhYmxl');

@$core.Deprecated('Use serviceSummaryDescriptor instead')
const ServiceSummary$json = {
  '1': 'ServiceSummary',
  '2': [
    {'1': 'requests', '3': 1, '4': 1, '5': 5, '10': 'requests'},
    {'1': 'dispatched', '3': 2, '4': 1, '5': 5, '10': 'dispatched'},
    {'1': 'completed', '3': 3, '4': 1, '5': 5, '10': 'completed'},
    {'1': 'aborted', '3': 4, '4': 1, '5': 5, '10': 'aborted'},
    {'1': 'cancelled', '3': 5, '4': 1, '5': 5, '10': 'cancelled'},
    {
      '1': 'cancelled_after_dispatch',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'cancelledAfterDispatch'
    },
    {'1': 'overridden', '3': 7, '4': 1, '5': 5, '10': 'overridden'},
    {
      '1': 'incomplete_timelines',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'incompleteTimelines'
    },
    {'1': 'vehicles_seen', '3': 9, '4': 1, '5': 5, '10': 'vehiclesSeen'},
    {
      '1': 'utilisation_seconds',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'utilisationSeconds'
    },
    {
      '1': 'response',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Interval',
      '10': 'response'
    },
    {
      '1': 'on_scene',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Interval',
      '10': 'onScene'
    },
    {
      '1': 'handover',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Interval',
      '10': 'handover'
    },
    {
      '1': 'turnaround',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Interval',
      '10': 'turnaround'
    },
  ],
};

/// Descriptor for `ServiceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceSummaryDescriptor = $convert.base64Decode(
    'Cg5TZXJ2aWNlU3VtbWFyeRIaCghyZXF1ZXN0cxgBIAEoBVIIcmVxdWVzdHMSHgoKZGlzcGF0Y2'
    'hlZBgCIAEoBVIKZGlzcGF0Y2hlZBIcCgljb21wbGV0ZWQYAyABKAVSCWNvbXBsZXRlZBIYCgdh'
    'Ym9ydGVkGAQgASgFUgdhYm9ydGVkEhwKCWNhbmNlbGxlZBgFIAEoBVIJY2FuY2VsbGVkEjgKGG'
    'NhbmNlbGxlZF9hZnRlcl9kaXNwYXRjaBgGIAEoBVIWY2FuY2VsbGVkQWZ0ZXJEaXNwYXRjaBIe'
    'CgpvdmVycmlkZGVuGAcgASgFUgpvdmVycmlkZGVuEjEKFGluY29tcGxldGVfdGltZWxpbmVzGA'
    'ggASgFUhNpbmNvbXBsZXRlVGltZWxpbmVzEiMKDXZlaGljbGVzX3NlZW4YCSABKAVSDHZlaGlj'
    'bGVzU2VlbhIvChN1dGlsaXNhdGlvbl9zZWNvbmRzGAogASgDUhJ1dGlsaXNhdGlvblNlY29uZH'
    'MSPQoIcmVzcG9uc2UYCyABKAsyIS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5JbnRlcnZhbFII'
    'cmVzcG9uc2USPAoIb25fc2NlbmUYDCABKAsyIS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5Jbn'
    'RlcnZhbFIHb25TY2VuZRI9CghoYW5kb3ZlchgNIAEoCzIhLmhlYWx0aGNhcmUuYW1idWxhbmNl'
    'LnYxLkludGVydmFsUghoYW5kb3ZlchJBCgp0dXJuYXJvdW5kGA4gASgLMiEuaGVhbHRoY2FyZS'
    '5hbWJ1bGFuY2UudjEuSW50ZXJ2YWxSCnR1cm5hcm91bmQ=');

@$core.Deprecated('Use readinessSummaryDescriptor instead')
const ReadinessSummary$json = {
  '1': 'ReadinessSummary',
  '2': [
    {'1': 'checked', '3': 1, '4': 1, '5': 5, '10': 'checked'},
    {'1': 'passed', '3': 2, '4': 1, '5': 5, '10': 'passed'},
    {'1': 'failed', '3': 3, '4': 1, '5': 5, '10': 'failed'},
    {'1': 'overridden', '3': 4, '4': 1, '5': 5, '10': 'overridden'},
    {
      '1': 'missing_by_item',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessSummary.MissingByItemEntry',
      '10': 'missingByItem'
    },
    {'1': 'unanswerable', '3': 6, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
  '3': [ReadinessSummary_MissingByItemEntry$json],
};

@$core.Deprecated('Use readinessSummaryDescriptor instead')
const ReadinessSummary_MissingByItemEntry$json = {
  '1': 'MissingByItemEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ReadinessSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readinessSummaryDescriptor = $convert.base64Decode(
    'ChBSZWFkaW5lc3NTdW1tYXJ5EhgKB2NoZWNrZWQYASABKAVSB2NoZWNrZWQSFgoGcGFzc2VkGA'
    'IgASgFUgZwYXNzZWQSFgoGZmFpbGVkGAMgASgFUgZmYWlsZWQSHgoKb3ZlcnJpZGRlbhgEIAEo'
    'BVIKb3ZlcnJpZGRlbhJkCg9taXNzaW5nX2J5X2l0ZW0YBSADKAsyPC5oZWFsdGhjYXJlLmFtYn'
    'VsYW5jZS52MS5SZWFkaW5lc3NTdW1tYXJ5Lk1pc3NpbmdCeUl0ZW1FbnRyeVINbWlzc2luZ0J5'
    'SXRlbRIiCgx1bmFuc3dlcmFibGUYBiABKAhSDHVuYW5zd2VyYWJsZRpAChJNaXNzaW5nQnlJdG'
    'VtRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use registerVehicleRequestDescriptor instead')
const RegisterVehicleRequest$json = {
  '1': 'RegisterVehicleRequest',
  '2': [
    {'1': 'registration', '3': 1, '4': 1, '5': 9, '10': 'registration'},
    {'1': 'call_sign', '3': 2, '4': 1, '5': 9, '10': 'callSign'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleKind',
      '10': 'kind'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'base_id', '3': 5, '4': 1, '5': 9, '10': 'baseId'},
    {'1': 'capabilities', '3': 6, '4': 3, '5': 9, '10': 'capabilities'},
  ],
};

/// Descriptor for `RegisterVehicleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerVehicleRequestDescriptor = $convert.base64Decode(
    'ChZSZWdpc3RlclZlaGljbGVSZXF1ZXN0EiIKDHJlZ2lzdHJhdGlvbhgBIAEoCVIMcmVnaXN0cm'
    'F0aW9uEhsKCWNhbGxfc2lnbhgCIAEoCVIIY2FsbFNpZ24SOAoEa2luZBgDIAEoDjIkLmhlYWx0'
    'aGNhcmUuYW1idWxhbmNlLnYxLlZlaGljbGVLaW5kUgRraW5kEh8KC2ZhY2lsaXR5X2lkGAQgAS'
    'gJUgpmYWNpbGl0eUlkEhcKB2Jhc2VfaWQYBSABKAlSBmJhc2VJZBIiCgxjYXBhYmlsaXRpZXMY'
    'BiADKAlSDGNhcGFiaWxpdGllcw==');

@$core.Deprecated('Use registerVehicleResponseDescriptor instead')
const RegisterVehicleResponse$json = {
  '1': 'RegisterVehicleResponse',
  '2': [
    {
      '1': 'vehicle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Vehicle',
      '10': 'vehicle'
    },
  ],
};

/// Descriptor for `RegisterVehicleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerVehicleResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWdpc3RlclZlaGljbGVSZXNwb25zZRI6Cgd2ZWhpY2xlGAEgASgLMiAuaGVhbHRoY2FyZS'
        '5hbWJ1bGFuY2UudjEuVmVoaWNsZVIHdmVoaWNsZQ==');

@$core.Deprecated('Use setVehicleStateRequestDescriptor instead')
const SetVehicleStateRequest$json = {
  '1': 'SetVehicleStateRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleState',
      '10': 'state'
    },
    {'1': 'check_id', '3': 3, '4': 1, '5': 9, '10': 'checkId'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 5, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SetVehicleStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setVehicleStateRequestDescriptor = $convert.base64Decode(
    'ChZTZXRWZWhpY2xlU3RhdGVSZXF1ZXN0Eh0KCnZlaGljbGVfaWQYASABKAlSCXZlaGljbGVJZB'
    'I7CgVzdGF0ZRgCIAEoDjIlLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlZlaGljbGVTdGF0ZVIF'
    'c3RhdGUSGQoIY2hlY2tfaWQYAyABKAlSB2NoZWNrSWQSFgoGcmVhc29uGAQgASgJUgZyZWFzb2'
    '4SGAoHdmVyc2lvbhgFIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use setVehicleStateResponseDescriptor instead')
const SetVehicleStateResponse$json = {
  '1': 'SetVehicleStateResponse',
  '2': [
    {
      '1': 'vehicle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Vehicle',
      '10': 'vehicle'
    },
  ],
};

/// Descriptor for `SetVehicleStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setVehicleStateResponseDescriptor =
    $convert.base64Decode(
        'ChdTZXRWZWhpY2xlU3RhdGVSZXNwb25zZRI6Cgd2ZWhpY2xlGAEgASgLMiAuaGVhbHRoY2FyZS'
        '5hbWJ1bGFuY2UudjEuVmVoaWNsZVIHdmVoaWNsZQ==');

@$core.Deprecated('Use getVehicleRequestDescriptor instead')
const GetVehicleRequest$json = {
  '1': 'GetVehicleRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
  ],
};

/// Descriptor for `GetVehicleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVehicleRequestDescriptor = $convert.base64Decode(
    'ChFHZXRWZWhpY2xlUmVxdWVzdBIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2xlSWQ=');

@$core.Deprecated('Use getVehicleResponseDescriptor instead')
const GetVehicleResponse$json = {
  '1': 'GetVehicleResponse',
  '2': [
    {
      '1': 'vehicle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Vehicle',
      '10': 'vehicle'
    },
  ],
};

/// Descriptor for `GetVehicleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVehicleResponseDescriptor = $convert.base64Decode(
    'ChJHZXRWZWhpY2xlUmVzcG9uc2USOgoHdmVoaWNsZRgBIAEoCzIgLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlZlaGljbGVSB3ZlaGljbGU=');

@$core.Deprecated('Use listVehiclesRequestDescriptor instead')
const ListVehiclesRequest$json = {
  '1': 'ListVehiclesRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleState',
      '10': 'states'
    },
    {
      '1': 'kinds',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.VehicleKind',
      '10': 'kinds'
    },
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListVehiclesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVehiclesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0VmVoaWNsZXNSZXF1ZXN0Ej0KBnN0YXRlcxgBIAMoDjIlLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlZlaGljbGVTdGF0ZVIGc3RhdGVzEjoKBWtpbmRzGAIgAygOMiQuaGVhbHRoY2Fy'
    'ZS5hbWJ1bGFuY2UudjEuVmVoaWNsZUtpbmRSBWtpbmRzEh8KC2ZhY2lsaXR5X2lkGAMgASgJUg'
    'pmYWNpbGl0eUlkEhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpemUSFgoGb2Zmc2V0GAUgASgF'
    'UgZvZmZzZXQ=');

@$core.Deprecated('Use listVehiclesResponseDescriptor instead')
const ListVehiclesResponse$json = {
  '1': 'ListVehiclesResponse',
  '2': [
    {
      '1': 'vehicles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Vehicle',
      '10': 'vehicles'
    },
  ],
};

/// Descriptor for `ListVehiclesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVehiclesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0VmVoaWNsZXNSZXNwb25zZRI8Cgh2ZWhpY2xlcxgBIAMoCzIgLmhlYWx0aGNhcmUuYW'
    '1idWxhbmNlLnYxLlZlaGljbGVSCHZlaGljbGVz');

@$core.Deprecated('Use rosterShiftRequestDescriptor instead')
const RosterShiftRequest$json = {
  '1': 'RosterShiftRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'crew',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.CrewMember',
      '10': 'crew'
    },
    {
      '1': 'starts_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
  ],
};

/// Descriptor for `RosterShiftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rosterShiftRequestDescriptor = $convert.base64Decode(
    'ChJSb3N0ZXJTaGlmdFJlcXVlc3QSHQoKdmVoaWNsZV9pZBgBIAEoCVIJdmVoaWNsZUlkEh8KC2'
    'ZhY2lsaXR5X2lkGAIgASgJUgpmYWNpbGl0eUlkEjcKBGNyZXcYAyADKAsyIy5oZWFsdGhjYXJl'
    'LmFtYnVsYW5jZS52MS5DcmV3TWVtYmVyUgRjcmV3EjcKCXN0YXJ0c19hdBgEIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YXJ0c0F0EjMKB2VuZHNfYXQYBSABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgZlbmRzQXQ=');

@$core.Deprecated('Use rosterShiftResponseDescriptor instead')
const RosterShiftResponse$json = {
  '1': 'RosterShiftResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `RosterShiftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rosterShiftResponseDescriptor = $convert.base64Decode(
    'ChNSb3N0ZXJTaGlmdFJlc3BvbnNlEjQKBXNoaWZ0GAEgASgLMh4uaGVhbHRoY2FyZS5hbWJ1bG'
    'FuY2UudjEuU2hpZnRSBXNoaWZ0');

@$core.Deprecated('Use setShiftStateRequestDescriptor instead')
const SetShiftStateRequest$json = {
  '1': 'SetShiftStateRequest',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.ShiftState',
      '10': 'state'
    },
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SetShiftStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setShiftStateRequestDescriptor = $convert.base64Decode(
    'ChRTZXRTaGlmdFN0YXRlUmVxdWVzdBIZCghzaGlmdF9pZBgBIAEoCVIHc2hpZnRJZBI5CgVzdG'
    'F0ZRgCIAEoDjIjLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlNoaWZ0U3RhdGVSBXN0YXRlEhgK'
    'B3ZlcnNpb24YAyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use setShiftStateResponseDescriptor instead')
const SetShiftStateResponse$json = {
  '1': 'SetShiftStateResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `SetShiftStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setShiftStateResponseDescriptor = $convert.base64Decode(
    'ChVTZXRTaGlmdFN0YXRlUmVzcG9uc2USNAoFc2hpZnQYASABKAsyHi5oZWFsdGhjYXJlLmFtYn'
    'VsYW5jZS52MS5TaGlmdFIFc2hpZnQ=');

@$core.Deprecated('Use getShiftRequestDescriptor instead')
const GetShiftRequest$json = {
  '1': 'GetShiftRequest',
  '2': [
    {'1': 'shift_id', '3': 1, '4': 1, '5': 9, '10': 'shiftId'},
  ],
};

/// Descriptor for `GetShiftRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShiftRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTaGlmdFJlcXVlc3QSGQoIc2hpZnRfaWQYASABKAlSB3NoaWZ0SWQ=');

@$core.Deprecated('Use getShiftResponseDescriptor instead')
const GetShiftResponse$json = {
  '1': 'GetShiftResponse',
  '2': [
    {
      '1': 'shift',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Shift',
      '10': 'shift'
    },
  ],
};

/// Descriptor for `GetShiftResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShiftResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTaGlmdFJlc3BvbnNlEjQKBXNoaWZ0GAEgASgLMh4uaGVhbHRoY2FyZS5hbWJ1bGFuY2'
    'UudjEuU2hpZnRSBXNoaWZ0');

@$core.Deprecated('Use listShiftsRequestDescriptor instead')
const ListShiftsRequest$json = {
  '1': 'ListShiftsRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'states',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.ShiftState',
      '10': 'states'
    },
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 7, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListShiftsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listShiftsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0U2hpZnRzUmVxdWVzdBIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2xlSWQSHwoLZm'
    'FjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSOwoGc3RhdGVzGAMgAygOMiMuaGVhbHRoY2Fy'
    'ZS5hbWJ1bGFuY2UudjEuU2hpZnRTdGF0ZVIGc3RhdGVzEi4KBGZyb20YBCABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAUgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFICdG8SGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2l6ZRIWCgZvZmZzZXQYBy'
    'ABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listShiftsResponseDescriptor instead')
const ListShiftsResponse$json = {
  '1': 'ListShiftsResponse',
  '2': [
    {
      '1': 'shifts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Shift',
      '10': 'shifts'
    },
  ],
};

/// Descriptor for `ListShiftsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listShiftsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U2hpZnRzUmVzcG9uc2USNgoGc2hpZnRzGAEgAygLMh4uaGVhbHRoY2FyZS5hbWJ1bG'
    'FuY2UudjEuU2hpZnRSBnNoaWZ0cw==');

@$core.Deprecated('Use recordReadinessCheckRequestDescriptor instead')
const RecordReadinessCheckRequest$json = {
  '1': 'RecordReadinessCheckRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'shift_id', '3': 2, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ChecklistItem',
      '10': 'items'
    },
    {
      '1': 'outcomes',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ItemOutcome',
      '10': 'outcomes'
    },
    {'1': 'oxygen_bar', '3': 6, '4': 1, '5': 5, '10': 'oxygenBar'},
    {
      '1': 'oxygen_minimum_bar',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'oxygenMinimumBar'
    },
    {'1': 'valid_for_seconds', '3': 8, '4': 1, '5': 5, '10': 'validForSeconds'},
  ],
};

/// Descriptor for `RecordReadinessCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordReadinessCheckRequestDescriptor = $convert.base64Decode(
    'ChtSZWNvcmRSZWFkaW5lc3NDaGVja1JlcXVlc3QSHQoKdmVoaWNsZV9pZBgBIAEoCVIJdmVoaW'
    'NsZUlkEhkKCHNoaWZ0X2lkGAIgASgJUgdzaGlmdElkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpm'
    'YWNpbGl0eUlkEjwKBWl0ZW1zGAQgAygLMiYuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQ2hlY2'
    'tsaXN0SXRlbVIFaXRlbXMSQAoIb3V0Y29tZXMYBSADKAsyJC5oZWFsdGhjYXJlLmFtYnVsYW5j'
    'ZS52MS5JdGVtT3V0Y29tZVIIb3V0Y29tZXMSHQoKb3h5Z2VuX2JhchgGIAEoBVIJb3h5Z2VuQm'
    'FyEiwKEm94eWdlbl9taW5pbXVtX2JhchgHIAEoBVIQb3h5Z2VuTWluaW11bUJhchIqChF2YWxp'
    'ZF9mb3Jfc2Vjb25kcxgIIAEoBVIPdmFsaWRGb3JTZWNvbmRz');

@$core.Deprecated('Use recordReadinessCheckResponseDescriptor instead')
const RecordReadinessCheckResponse$json = {
  '1': 'RecordReadinessCheckResponse',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `RecordReadinessCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordReadinessCheckResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWNvcmRSZWFkaW5lc3NDaGVja1Jlc3BvbnNlEj0KBWNoZWNrGAEgASgLMicuaGVhbHRoY2'
        'FyZS5hbWJ1bGFuY2UudjEuUmVhZGluZXNzQ2hlY2tSBWNoZWNr');

@$core.Deprecated('Use overrideReadinessCheckRequestDescriptor instead')
const OverrideReadinessCheckRequest$json = {
  '1': 'OverrideReadinessCheckRequest',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `OverrideReadinessCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideReadinessCheckRequestDescriptor =
    $convert.base64Decode(
        'Ch1PdmVycmlkZVJlYWRpbmVzc0NoZWNrUmVxdWVzdBIZCghjaGVja19pZBgBIAEoCVIHY2hlY2'
        'tJZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbhIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use overrideReadinessCheckResponseDescriptor instead')
const OverrideReadinessCheckResponse$json = {
  '1': 'OverrideReadinessCheckResponse',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `OverrideReadinessCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideReadinessCheckResponseDescriptor =
    $convert.base64Decode(
        'Ch5PdmVycmlkZVJlYWRpbmVzc0NoZWNrUmVzcG9uc2USPQoFY2hlY2sYASABKAsyJy5oZWFsdG'
        'hjYXJlLmFtYnVsYW5jZS52MS5SZWFkaW5lc3NDaGVja1IFY2hlY2s=');

@$core.Deprecated('Use getReadinessCheckRequestDescriptor instead')
const GetReadinessCheckRequest$json = {
  '1': 'GetReadinessCheckRequest',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
  ],
};

/// Descriptor for `GetReadinessCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessCheckRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRSZWFkaW5lc3NDaGVja1JlcXVlc3QSGQoIY2hlY2tfaWQYASABKAlSB2NoZWNrSWQ=');

@$core.Deprecated('Use getReadinessCheckResponseDescriptor instead')
const GetReadinessCheckResponse$json = {
  '1': 'GetReadinessCheckResponse',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `GetReadinessCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessCheckResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZWFkaW5lc3NDaGVja1Jlc3BvbnNlEj0KBWNoZWNrGAEgASgLMicuaGVhbHRoY2FyZS'
        '5hbWJ1bGFuY2UudjEuUmVhZGluZXNzQ2hlY2tSBWNoZWNr');

@$core.Deprecated('Use listReadinessChecksRequestDescriptor instead')
const ListReadinessChecksRequest$json = {
  '1': 'ListReadinessChecksRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'states',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.CheckState',
      '10': 'states'
    },
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 7, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListReadinessChecksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadinessChecksRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0UmVhZGluZXNzQ2hlY2tzUmVxdWVzdBIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2'
    'xlSWQSHwoLZmFjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSOwoGc3RhdGVzGAMgAygOMiMu'
    'aGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQ2hlY2tTdGF0ZVIGc3RhdGVzEi4KBGZyb20YBCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAUgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2l6ZRIWCg'
    'ZvZmZzZXQYByABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listReadinessChecksResponseDescriptor instead')
const ListReadinessChecksResponse$json = {
  '1': 'ListReadinessChecksResponse',
  '2': [
    {
      '1': 'checks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessCheck',
      '10': 'checks'
    },
  ],
};

/// Descriptor for `ListReadinessChecksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadinessChecksResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UmVhZGluZXNzQ2hlY2tzUmVzcG9uc2USPwoGY2hlY2tzGAEgAygLMicuaGVhbHRoY2'
        'FyZS5hbWJ1bGFuY2UudjEuUmVhZGluZXNzQ2hlY2tSBmNoZWNrcw==');

@$core.Deprecated('Use getReadinessSummaryRequestDescriptor instead')
const GetReadinessSummaryRequest$json = {
  '1': 'GetReadinessSummaryRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `GetReadinessSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessSummaryRequestDescriptor = $convert.base64Decode(
    'ChpHZXRSZWFkaW5lc3NTdW1tYXJ5UmVxdWVzdBIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2'
    'xlSWQSHwoLZmFjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSLgoEZnJvbRgDIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YBCABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgJ0bw==');

@$core.Deprecated('Use getReadinessSummaryResponseDescriptor instead')
const GetReadinessSummaryResponse$json = {
  '1': 'GetReadinessSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ReadinessSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `GetReadinessSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessSummaryResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRSZWFkaW5lc3NTdW1tYXJ5UmVzcG9uc2USQwoHc3VtbWFyeRgBIAEoCzIpLmhlYWx0aG'
        'NhcmUuYW1idWxhbmNlLnYxLlJlYWRpbmVzc1N1bW1hcnlSB3N1bW1hcnk=');

@$core.Deprecated('Use raiseRequestRequestDescriptor instead')
const RaiseRequestRequest$json = {
  '1': 'RaiseRequestRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.RequestKind',
      '10': 'kind'
    },
    {
      '1': 'priority',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Priority',
      '10': 'priority'
    },
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'origin_name', '3': 5, '4': 1, '5': 9, '10': 'originName'},
    {'1': 'origin_address', '3': 6, '4': 1, '5': 9, '10': 'originAddress'},
    {
      '1': 'origin_facility_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'originFacilityId'
    },
    {'1': 'destination_name', '3': 8, '4': 1, '5': 9, '10': 'destinationName'},
    {
      '1': 'destination_address',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'destinationAddress'
    },
    {
      '1': 'destination_facility_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'destinationFacilityId'
    },
    {'1': 'clinical_need', '3': 11, '4': 1, '5': 9, '10': 'clinicalNeed'},
    {
      '1': 'required_capabilities',
      '3': 12,
      '4': 3,
      '5': 9,
      '10': 'requiredCapabilities'
    },
  ],
};

/// Descriptor for `RaiseRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRequestRequestDescriptor = $convert.base64Decode(
    'ChNSYWlzZVJlcXVlc3RSZXF1ZXN0EjgKBGtpbmQYASABKA4yJC5oZWFsdGhjYXJlLmFtYnVsYW'
    '5jZS52MS5SZXF1ZXN0S2luZFIEa2luZBI9Cghwcmlvcml0eRgCIAEoDjIhLmhlYWx0aGNhcmUu'
    'YW1idWxhbmNlLnYxLlByaW9yaXR5Ughwcmlvcml0eRIdCgpwYXRpZW50X2lkGAMgASgJUglwYX'
    'RpZW50SWQSIQoMZW5jb3VudGVyX2lkGAQgASgJUgtlbmNvdW50ZXJJZBIfCgtvcmlnaW5fbmFt'
    'ZRgFIAEoCVIKb3JpZ2luTmFtZRIlCg5vcmlnaW5fYWRkcmVzcxgGIAEoCVINb3JpZ2luQWRkcm'
    'VzcxIsChJvcmlnaW5fZmFjaWxpdHlfaWQYByABKAlSEG9yaWdpbkZhY2lsaXR5SWQSKQoQZGVz'
    'dGluYXRpb25fbmFtZRgIIAEoCVIPZGVzdGluYXRpb25OYW1lEi8KE2Rlc3RpbmF0aW9uX2FkZH'
    'Jlc3MYCSABKAlSEmRlc3RpbmF0aW9uQWRkcmVzcxI2ChdkZXN0aW5hdGlvbl9mYWNpbGl0eV9p'
    'ZBgKIAEoCVIVZGVzdGluYXRpb25GYWNpbGl0eUlkEiMKDWNsaW5pY2FsX25lZWQYCyABKAlSDG'
    'NsaW5pY2FsTmVlZBIzChVyZXF1aXJlZF9jYXBhYmlsaXRpZXMYDCADKAlSFHJlcXVpcmVkQ2Fw'
    'YWJpbGl0aWVz');

@$core.Deprecated('Use raiseRequestResponseDescriptor instead')
const RaiseRequestResponse$json = {
  '1': 'RaiseRequestResponse',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Request',
      '10': 'request'
    },
  ],
};

/// Descriptor for `RaiseRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRequestResponseDescriptor = $convert.base64Decode(
    'ChRSYWlzZVJlcXVlc3RSZXNwb25zZRI6CgdyZXF1ZXN0GAEgASgLMiAuaGVhbHRoY2FyZS5hbW'
    'J1bGFuY2UudjEuUmVxdWVzdFIHcmVxdWVzdA==');

@$core.Deprecated('Use cancelRequestRequestDescriptor instead')
const CancelRequestRequest$json = {
  '1': 'CancelRequestRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CancelRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestRequestDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxSZXF1ZXN0UmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQSFg'
    'oGcmVhc29uGAIgASgJUgZyZWFzb24SGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use cancelRequestResponseDescriptor instead')
const CancelRequestResponse$json = {
  '1': 'CancelRequestResponse',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Request',
      '10': 'request'
    },
  ],
};

/// Descriptor for `CancelRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelRequestResponseDescriptor = $convert.base64Decode(
    'ChVDYW5jZWxSZXF1ZXN0UmVzcG9uc2USOgoHcmVxdWVzdBgBIAEoCzIgLmhlYWx0aGNhcmUuYW'
    '1idWxhbmNlLnYxLlJlcXVlc3RSB3JlcXVlc3Q=');

@$core.Deprecated('Use getRequestRequestDescriptor instead')
const GetRequestRequest$json = {
  '1': 'GetRequestRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
  ],
};

/// Descriptor for `GetRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequestRequestDescriptor = $convert.base64Decode(
    'ChFHZXRSZXF1ZXN0UmVxdWVzdBIdCgpyZXF1ZXN0X2lkGAEgASgJUglyZXF1ZXN0SWQ=');

@$core.Deprecated('Use getRequestResponseDescriptor instead')
const GetRequestResponse$json = {
  '1': 'GetRequestResponse',
  '2': [
    {
      '1': 'request',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Request',
      '10': 'request'
    },
  ],
};

/// Descriptor for `GetRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRequestResponseDescriptor = $convert.base64Decode(
    'ChJHZXRSZXF1ZXN0UmVzcG9uc2USOgoHcmVxdWVzdBgBIAEoCzIgLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlJlcXVlc3RSB3JlcXVlc3Q=');

@$core.Deprecated('Use listRequestsRequestDescriptor instead')
const ListRequestsRequest$json = {
  '1': 'ListRequestsRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.RequestState',
      '10': 'states'
    },
    {
      '1': 'priorities',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Priority',
      '10': 'priorities'
    },
    {
      '1': 'kinds',
      '3': 3,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.RequestKind',
      '10': 'kinds'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'patient_id', '3': 5, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 8, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 9, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListRequestsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVxdWVzdHNSZXF1ZXN0Ej0KBnN0YXRlcxgBIAMoDjIlLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlJlcXVlc3RTdGF0ZVIGc3RhdGVzEkEKCnByaW9yaXRpZXMYAiADKA4yIS5oZWFs'
    'dGhjYXJlLmFtYnVsYW5jZS52MS5Qcmlvcml0eVIKcHJpb3JpdGllcxI6CgVraW5kcxgDIAMoDj'
    'IkLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlJlcXVlc3RLaW5kUgVraW5kcxIfCgtmYWNpbGl0'
    'eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIdCgpwYXRpZW50X2lkGAUgASgJUglwYXRpZW50SWQSLg'
    'oEZnJvbRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YByAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bxIbCglwYWdlX3NpemUYCCABKAVSCH'
    'BhZ2VTaXplEhYKBm9mZnNldBgJIAEoBVIGb2Zmc2V0');

@$core.Deprecated('Use listRequestsResponseDescriptor instead')
const ListRequestsResponse$json = {
  '1': 'ListRequestsResponse',
  '2': [
    {
      '1': 'requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Request',
      '10': 'requests'
    },
  ],
};

/// Descriptor for `ListRequestsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRequestsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVxdWVzdHNSZXNwb25zZRI8CghyZXF1ZXN0cxgBIAMoCzIgLmhlYWx0aGNhcmUuYW'
    '1idWxhbmNlLnYxLlJlcXVlc3RSCHJlcXVlc3Rz');

@$core.Deprecated('Use getDispatchQueueRequestDescriptor instead')
const GetDispatchQueueRequest$json = {
  '1': 'GetDispatchQueueRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetDispatchQueueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDispatchQueueRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXREaXNwYXRjaFF1ZXVlUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
        'lJZA==');

@$core.Deprecated('Use getDispatchQueueResponseDescriptor instead')
const GetDispatchQueueResponse$json = {
  '1': 'GetDispatchQueueResponse',
  '2': [
    {
      '1': 'requests',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Request',
      '10': 'requests'
    },
  ],
};

/// Descriptor for `GetDispatchQueueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDispatchQueueResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXREaXNwYXRjaFF1ZXVlUmVzcG9uc2USPAoIcmVxdWVzdHMYASADKAsyIC5oZWFsdGhjYX'
        'JlLmFtYnVsYW5jZS52MS5SZXF1ZXN0UghyZXF1ZXN0cw==');

@$core.Deprecated('Use dispatchRequestDescriptor instead')
const DispatchRequest$json = {
  '1': 'DispatchRequest',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 9, '10': 'requestId'},
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'shift_id', '3': 3, '4': 1, '5': 9, '10': 'shiftId'},
    {'1': 'override_reason', '3': 4, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `DispatchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchRequestDescriptor = $convert.base64Decode(
    'Cg9EaXNwYXRjaFJlcXVlc3QSHQoKcmVxdWVzdF9pZBgBIAEoCVIJcmVxdWVzdElkEh0KCnZlaG'
    'ljbGVfaWQYAiABKAlSCXZlaGljbGVJZBIZCghzaGlmdF9pZBgDIAEoCVIHc2hpZnRJZBInCg9v'
    'dmVycmlkZV9yZWFzb24YBCABKAlSDm92ZXJyaWRlUmVhc29u');

@$core.Deprecated('Use dispatchResponseDescriptor instead')
const DispatchResponse$json = {
  '1': 'DispatchResponse',
  '2': [
    {
      '1': 'trip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trip'
    },
  ],
};

/// Descriptor for `DispatchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchResponseDescriptor = $convert.base64Decode(
    'ChBEaXNwYXRjaFJlc3BvbnNlEjEKBHRyaXAYASABKAsyHS5oZWFsdGhjYXJlLmFtYnVsYW5jZS'
    '52MS5UcmlwUgR0cmlw');

@$core.Deprecated('Use recordTripMilestoneRequestDescriptor instead')
const RecordTripMilestoneRequest$json = {
  '1': 'RecordTripMilestoneRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {
      '1': 'milestone',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Milestone',
      '10': 'milestone'
    },
    {
      '1': 'occurred_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {'1': 'version', '3': 5, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RecordTripMilestoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTripMilestoneRequestDescriptor = $convert.base64Decode(
    'ChpSZWNvcmRUcmlwTWlsZXN0b25lUmVxdWVzdBIXCgd0cmlwX2lkGAEgASgJUgZ0cmlwSWQSQA'
    'oJbWlsZXN0b25lGAIgASgOMiIuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTWlsZXN0b25lUglt'
    'aWxlc3RvbmUSOwoLb2NjdXJyZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgpvY2N1cnJlZEF0EhIKBG5vdGUYBCABKAlSBG5vdGUSGAoHdmVyc2lvbhgFIAEoA1IHdmVy'
    'c2lvbg==');

@$core.Deprecated('Use recordTripMilestoneResponseDescriptor instead')
const RecordTripMilestoneResponse$json = {
  '1': 'RecordTripMilestoneResponse',
  '2': [
    {
      '1': 'trip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trip'
    },
  ],
};

/// Descriptor for `RecordTripMilestoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordTripMilestoneResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWNvcmRUcmlwTWlsZXN0b25lUmVzcG9uc2USMQoEdHJpcBgBIAEoCzIdLmhlYWx0aGNhcm'
        'UuYW1idWxhbmNlLnYxLlRyaXBSBHRyaXA=');

@$core.Deprecated('Use amendTripMilestoneRequestDescriptor instead')
const AmendTripMilestoneRequest$json = {
  '1': 'AmendTripMilestoneRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {
      '1': 'milestone',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Milestone',
      '10': 'milestone'
    },
    {
      '1': 'occurred_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AmendTripMilestoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendTripMilestoneRequestDescriptor = $convert.base64Decode(
    'ChlBbWVuZFRyaXBNaWxlc3RvbmVSZXF1ZXN0EhcKB3RyaXBfaWQYASABKAlSBnRyaXBJZBJACg'
    'ltaWxlc3RvbmUYAiABKA4yIi5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5NaWxlc3RvbmVSCW1p'
    'bGVzdG9uZRI7CgtvY2N1cnJlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCm9jY3VycmVkQXQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24=');

@$core.Deprecated('Use amendTripMilestoneResponseDescriptor instead')
const AmendTripMilestoneResponse$json = {
  '1': 'AmendTripMilestoneResponse',
  '2': [
    {
      '1': 'trip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trip'
    },
  ],
};

/// Descriptor for `AmendTripMilestoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendTripMilestoneResponseDescriptor =
    $convert.base64Decode(
        'ChpBbWVuZFRyaXBNaWxlc3RvbmVSZXNwb25zZRIxCgR0cmlwGAEgASgLMh0uaGVhbHRoY2FyZS'
        '5hbWJ1bGFuY2UudjEuVHJpcFIEdHJpcA==');

@$core.Deprecated('Use abortTripRequestDescriptor instead')
const AbortTripRequest$json = {
  '1': 'AbortTripRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AbortTripRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List abortTripRequestDescriptor = $convert.base64Decode(
    'ChBBYm9ydFRyaXBSZXF1ZXN0EhcKB3RyaXBfaWQYASABKAlSBnRyaXBJZBIWCgZyZWFzb24YAi'
    'ABKAlSBnJlYXNvbhIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use abortTripResponseDescriptor instead')
const AbortTripResponse$json = {
  '1': 'AbortTripResponse',
  '2': [
    {
      '1': 'trip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trip'
    },
  ],
};

/// Descriptor for `AbortTripResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List abortTripResponseDescriptor = $convert.base64Decode(
    'ChFBYm9ydFRyaXBSZXNwb25zZRIxCgR0cmlwGAEgASgLMh0uaGVhbHRoY2FyZS5hbWJ1bGFuY2'
    'UudjEuVHJpcFIEdHJpcA==');

@$core.Deprecated('Use getTripRequestDescriptor instead')
const GetTripRequest$json = {
  '1': 'GetTripRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
  ],
};

/// Descriptor for `GetTripRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTripRequestDescriptor = $convert
    .base64Decode('Cg5HZXRUcmlwUmVxdWVzdBIXCgd0cmlwX2lkGAEgASgJUgZ0cmlwSWQ=');

@$core.Deprecated('Use getTripResponseDescriptor instead')
const GetTripResponse$json = {
  '1': 'GetTripResponse',
  '2': [
    {
      '1': 'trip',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trip'
    },
  ],
};

/// Descriptor for `GetTripResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTripResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRUcmlwUmVzcG9uc2USMQoEdHJpcBgBIAEoCzIdLmhlYWx0aGNhcmUuYW1idWxhbmNlLn'
    'YxLlRyaXBSBHRyaXA=');

@$core.Deprecated('Use listTripsRequestDescriptor instead')
const ListTripsRequest$json = {
  '1': 'ListTripsRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.TripState',
      '10': 'states'
    },
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 7, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListTripsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTripsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VHJpcHNSZXF1ZXN0EjoKBnN0YXRlcxgBIAMoDjIiLmhlYWx0aGNhcmUuYW1idWxhbm'
    'NlLnYxLlRyaXBTdGF0ZVIGc3RhdGVzEh0KCnZlaGljbGVfaWQYAiABKAlSCXZlaGljbGVJZBIf'
    'CgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBIuCgRmcm9tGAQgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgGIAEoBVIIcGFnZVNpemUSFgoGb2Zmc2V0GAcgAS'
    'gFUgZvZmZzZXQ=');

@$core.Deprecated('Use listTripsResponseDescriptor instead')
const ListTripsResponse$json = {
  '1': 'ListTripsResponse',
  '2': [
    {
      '1': 'trips',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Trip',
      '10': 'trips'
    },
  ],
};

/// Descriptor for `ListTripsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTripsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VHJpcHNSZXNwb25zZRIzCgV0cmlwcxgBIAMoCzIdLmhlYWx0aGNhcmUuYW1idWxhbm'
    'NlLnYxLlRyaXBSBXRyaXBz');

@$core.Deprecated('Use getTimelineGapsRequestDescriptor instead')
const GetTimelineGapsRequest$json = {
  '1': 'GetTimelineGapsRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
  ],
};

/// Descriptor for `GetTimelineGapsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineGapsRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRUaW1lbGluZUdhcHNSZXF1ZXN0EhcKB3RyaXBfaWQYASABKAlSBnRyaXBJZA==');

@$core.Deprecated('Use getTimelineGapsResponseDescriptor instead')
const GetTimelineGapsResponse$json = {
  '1': 'GetTimelineGapsResponse',
  '2': [
    {
      '1': 'gaps',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.Milestone',
      '10': 'gaps'
    },
  ],
};

/// Descriptor for `GetTimelineGapsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineGapsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRUaW1lbGluZUdhcHNSZXNwb25zZRI2CgRnYXBzGAEgAygOMiIuaGVhbHRoY2FyZS5hbW'
        'J1bGFuY2UudjEuTWlsZXN0b25lUgRnYXBz');

@$core.Deprecated('Use openPrehospitalRecordRequestDescriptor instead')
const OpenPrehospitalRecordRequest$json = {
  '1': 'OpenPrehospitalRecordRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'presenting_complaint',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'presentingComplaint'
    },
    {'1': 'document_refs', '3': 5, '4': 3, '5': 9, '10': 'documentRefs'},
  ],
};

/// Descriptor for `OpenPrehospitalRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPrehospitalRecordRequestDescriptor = $convert.base64Decode(
    'ChxPcGVuUHJlaG9zcGl0YWxSZWNvcmRSZXF1ZXN0EhcKB3RyaXBfaWQYASABKAlSBnRyaXBJZB'
    'IdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZh'
    'Y2lsaXR5SWQSMQoUcHJlc2VudGluZ19jb21wbGFpbnQYBCABKAlSE3ByZXNlbnRpbmdDb21wbG'
    'FpbnQSIwoNZG9jdW1lbnRfcmVmcxgFIAMoCVIMZG9jdW1lbnRSZWZz');

@$core.Deprecated('Use openPrehospitalRecordResponseDescriptor instead')
const OpenPrehospitalRecordResponse$json = {
  '1': 'OpenPrehospitalRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `OpenPrehospitalRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openPrehospitalRecordResponseDescriptor =
    $convert.base64Decode(
        'Ch1PcGVuUHJlaG9zcGl0YWxSZWNvcmRSZXNwb25zZRJCCgZyZWNvcmQYASABKAsyKi5oZWFsdG'
        'hjYXJlLmFtYnVsYW5jZS52MS5QcmVob3NwaXRhbFJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use recordPrehospitalEntryRequestDescriptor instead')
const RecordPrehospitalEntryRequest$json = {
  '1': 'RecordPrehospitalEntryRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.ambulance.v1.EntryKind',
      '10': 'kind'
    },
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'value', '3': 5, '4': 1, '5': 9, '10': 'value'},
    {'1': 'unit', '3': 6, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'dose_amount', '3': 7, '4': 1, '5': 5, '10': 'doseAmount'},
    {'1': 'dose_unit', '3': 8, '4': 1, '5': 9, '10': 'doseUnit'},
    {'1': 'route', '3': 9, '4': 1, '5': 9, '10': 'route'},
    {'1': 'narrative', '3': 10, '4': 1, '5': 9, '10': 'narrative'},
    {
      '1': 'recorded_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `RecordPrehospitalEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPrehospitalEntryRequestDescriptor = $convert.base64Decode(
    'Ch1SZWNvcmRQcmVob3NwaXRhbEVudHJ5UmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY2'
    '9yZElkEjYKBGtpbmQYAiABKA4yIi5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5FbnRyeUtpbmRS'
    'BGtpbmQSEgoEY29kZRgDIAEoCVIEY29kZRIUCgVsYWJlbBgEIAEoCVIFbGFiZWwSFAoFdmFsdW'
    'UYBSABKAlSBXZhbHVlEhIKBHVuaXQYBiABKAlSBHVuaXQSHwoLZG9zZV9hbW91bnQYByABKAVS'
    'CmRvc2VBbW91bnQSGwoJZG9zZV91bml0GAggASgJUghkb3NlVW5pdBIUCgVyb3V0ZRgJIAEoCV'
    'IFcm91dGUSHAoJbmFycmF0aXZlGAogASgJUgluYXJyYXRpdmUSOwoLcmVjb3JkZWRfYXQYCyAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0');

@$core.Deprecated('Use recordPrehospitalEntryResponseDescriptor instead')
const RecordPrehospitalEntryResponse$json = {
  '1': 'RecordPrehospitalEntryResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `RecordPrehospitalEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPrehospitalEntryResponseDescriptor =
    $convert.base64Decode(
        'Ch5SZWNvcmRQcmVob3NwaXRhbEVudHJ5UmVzcG9uc2USQgoGcmVjb3JkGAEgASgLMiouaGVhbH'
        'RoY2FyZS5hbWJ1bGFuY2UudjEuUHJlaG9zcGl0YWxSZWNvcmRSBnJlY29yZA==');

@$core.Deprecated('Use attachTransferDocumentRequestDescriptor instead')
const AttachTransferDocumentRequest$json = {
  '1': 'AttachTransferDocumentRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'document_ref', '3': 2, '4': 1, '5': 9, '10': 'documentRef'},
  ],
};

/// Descriptor for `AttachTransferDocumentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachTransferDocumentRequestDescriptor =
    $convert.base64Decode(
        'Ch1BdHRhY2hUcmFuc2ZlckRvY3VtZW50UmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY2'
        '9yZElkEiEKDGRvY3VtZW50X3JlZhgCIAEoCVILZG9jdW1lbnRSZWY=');

@$core.Deprecated('Use attachTransferDocumentResponseDescriptor instead')
const AttachTransferDocumentResponse$json = {
  '1': 'AttachTransferDocumentResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `AttachTransferDocumentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachTransferDocumentResponseDescriptor =
    $convert.base64Decode(
        'Ch5BdHRhY2hUcmFuc2ZlckRvY3VtZW50UmVzcG9uc2USQgoGcmVjb3JkGAEgASgLMiouaGVhbH'
        'RoY2FyZS5hbWJ1bGFuY2UudjEuUHJlaG9zcGl0YWxSZWNvcmRSBnJlY29yZA==');

@$core.Deprecated('Use giveHandoverRequestDescriptor instead')
const GiveHandoverRequest$json = {
  '1': 'GiveHandoverRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'summary', '3': 2, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'impression', '3': 3, '4': 1, '5': 9, '10': 'impression'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `GiveHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List giveHandoverRequestDescriptor = $convert.base64Decode(
    'ChNHaXZlSGFuZG92ZXJSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSGAoHc3'
    'VtbWFyeRgCIAEoCVIHc3VtbWFyeRIeCgppbXByZXNzaW9uGAMgASgJUgppbXByZXNzaW9uEhgK'
    'B3ZlcnNpb24YBCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use giveHandoverResponseDescriptor instead')
const GiveHandoverResponse$json = {
  '1': 'GiveHandoverResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `GiveHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List giveHandoverResponseDescriptor = $convert.base64Decode(
    'ChRHaXZlSGFuZG92ZXJSZXNwb25zZRJCCgZyZWNvcmQYASABKAsyKi5oZWFsdGhjYXJlLmFtYn'
    'VsYW5jZS52MS5QcmVob3NwaXRhbFJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use acceptHandoverRequestDescriptor instead')
const AcceptHandoverRequest$json = {
  '1': 'AcceptHandoverRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AcceptHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptHandoverRequestDescriptor = $convert.base64Decode(
    'ChVBY2NlcHRIYW5kb3ZlclJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBIhCg'
    'xlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEhIKBG5vdGUYAyABKAlSBG5vdGUSGAoH'
    'dmVyc2lvbhgEIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use acceptHandoverResponseDescriptor instead')
const AcceptHandoverResponse$json = {
  '1': 'AcceptHandoverResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `AcceptHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptHandoverResponseDescriptor =
    $convert.base64Decode(
        'ChZBY2NlcHRIYW5kb3ZlclJlc3BvbnNlEkIKBnJlY29yZBgBIAEoCzIqLmhlYWx0aGNhcmUuYW'
        '1idWxhbmNlLnYxLlByZWhvc3BpdGFsUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use getPrehospitalRecordRequestDescriptor instead')
const GetPrehospitalRecordRequest$json = {
  '1': 'GetPrehospitalRecordRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetPrehospitalRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPrehospitalRecordRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRQcmVob3NwaXRhbFJlY29yZFJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcm'
        'RJZA==');

@$core.Deprecated('Use getPrehospitalRecordResponseDescriptor instead')
const GetPrehospitalRecordResponse$json = {
  '1': 'GetPrehospitalRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `GetPrehospitalRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPrehospitalRecordResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRQcmVob3NwaXRhbFJlY29yZFJlc3BvbnNlEkIKBnJlY29yZBgBIAEoCzIqLmhlYWx0aG'
        'NhcmUuYW1idWxhbmNlLnYxLlByZWhvc3BpdGFsUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use listPrehospitalRecordsRequestDescriptor instead')
const ListPrehospitalRecordsRequest$json = {
  '1': 'ListPrehospitalRecordsRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.HandoverState',
      '10': 'states'
    },
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 7, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListPrehospitalRecordsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrehospitalRecordsRequestDescriptor = $convert.base64Decode(
    'Ch1MaXN0UHJlaG9zcGl0YWxSZWNvcmRzUmVxdWVzdBI+CgZzdGF0ZXMYASADKA4yJi5oZWFsdG'
    'hjYXJlLmFtYnVsYW5jZS52MS5IYW5kb3ZlclN0YXRlUgZzdGF0ZXMSHwoLZmFjaWxpdHlfaWQY'
    'AiABKAlSCmZhY2lsaXR5SWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEi4KBGZyb2'
    '0YBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAUgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2'
    'l6ZRIWCgZvZmZzZXQYByABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listPrehospitalRecordsResponseDescriptor instead')
const ListPrehospitalRecordsResponse$json = {
  '1': 'ListPrehospitalRecordsResponse',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.PrehospitalRecord',
      '10': 'records'
    },
  ],
};

/// Descriptor for `ListPrehospitalRecordsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrehospitalRecordsResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0UHJlaG9zcGl0YWxSZWNvcmRzUmVzcG9uc2USRAoHcmVjb3JkcxgBIAMoCzIqLmhlYW'
        'x0aGNhcmUuYW1idWxhbmNlLnYxLlByZWhvc3BpdGFsUmVjb3JkUgdyZWNvcmRz');

@$core.Deprecated('Use recordPingRequestDescriptor instead')
const RecordPingRequest$json = {
  '1': 'RecordPingRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'latitude_micro', '3': 3, '4': 1, '5': 5, '10': 'latitudeMicro'},
    {'1': 'longitude_micro', '3': 4, '4': 1, '5': 5, '10': 'longitudeMicro'},
    {'1': 'speed_kph', '3': 5, '4': 1, '5': 5, '10': 'speedKph'},
    {'1': 'heading_degrees', '3': 6, '4': 1, '5': 5, '10': 'headingDegrees'},
    {'1': 'accuracy_metres', '3': 7, '4': 1, '5': 5, '10': 'accuracyMetres'},
    {'1': 'source', '3': 8, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'occurred_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `RecordPingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPingRequestDescriptor = $convert.base64Decode(
    'ChFSZWNvcmRQaW5nUmVxdWVzdBIdCgp2ZWhpY2xlX2lkGAEgASgJUgl2ZWhpY2xlSWQSFwoHdH'
    'JpcF9pZBgCIAEoCVIGdHJpcElkEiUKDmxhdGl0dWRlX21pY3JvGAMgASgFUg1sYXRpdHVkZU1p'
    'Y3JvEicKD2xvbmdpdHVkZV9taWNybxgEIAEoBVIObG9uZ2l0dWRlTWljcm8SGwoJc3BlZWRfa3'
    'BoGAUgASgFUghzcGVlZEtwaBInCg9oZWFkaW5nX2RlZ3JlZXMYBiABKAVSDmhlYWRpbmdEZWdy'
    'ZWVzEicKD2FjY3VyYWN5X21ldHJlcxgHIAEoBVIOYWNjdXJhY3lNZXRyZXMSFgoGc291cmNlGA'
    'ggASgJUgZzb3VyY2USOwoLb2NjdXJyZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgpvY2N1cnJlZEF0');

@$core.Deprecated('Use recordPingResponseDescriptor instead')
const RecordPingResponse$json = {
  '1': 'RecordPingResponse',
  '2': [
    {
      '1': 'ping',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Ping',
      '10': 'ping'
    },
  ],
};

/// Descriptor for `RecordPingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPingResponseDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRQaW5nUmVzcG9uc2USMQoEcGluZxgBIAEoCzIdLmhlYWx0aGNhcmUuYW1idWxhbm'
    'NlLnYxLlBpbmdSBHBpbmc=');

@$core.Deprecated('Use recordETARequestDescriptor instead')
const RecordETARequest$json = {
  '1': 'RecordETARequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
    {'1': 'seconds', '3': 3, '4': 1, '5': 5, '10': 'seconds'},
    {'1': 'distance_metres', '3': 4, '4': 1, '5': 5, '10': 'distanceMetres'},
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `RecordETARequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordETARequestDescriptor = $convert.base64Decode(
    'ChBSZWNvcmRFVEFSZXF1ZXN0Eh0KCnZlaGljbGVfaWQYASABKAlSCXZlaGljbGVJZBIXCgd0cm'
    'lwX2lkGAIgASgJUgZ0cmlwSWQSGAoHc2Vjb25kcxgDIAEoBVIHc2Vjb25kcxInCg9kaXN0YW5j'
    'ZV9tZXRyZXMYBCABKAVSDmRpc3RhbmNlTWV0cmVzEhYKBnNvdXJjZRgFIAEoCVIGc291cmNl');

@$core.Deprecated('Use recordETAResponseDescriptor instead')
const RecordETAResponse$json = {
  '1': 'RecordETAResponse',
  '2': [
    {
      '1': 'eta',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ETA',
      '10': 'eta'
    },
  ],
};

/// Descriptor for `RecordETAResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordETAResponseDescriptor = $convert.base64Decode(
    'ChFSZWNvcmRFVEFSZXNwb25zZRIuCgNldGEYASABKAsyHC5oZWFsdGhjYXJlLmFtYnVsYW5jZS'
    '52MS5FVEFSA2V0YQ==');

@$core.Deprecated('Use getVehiclePositionRequestDescriptor instead')
const GetVehiclePositionRequest$json = {
  '1': 'GetVehiclePositionRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
  ],
};

/// Descriptor for `GetVehiclePositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVehiclePositionRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRWZWhpY2xlUG9zaXRpb25SZXF1ZXN0Eh0KCnZlaGljbGVfaWQYASABKAlSCXZlaGljbG'
        'VJZBIXCgd0cmlwX2lkGAIgASgJUgZ0cmlwSWQ=');

@$core.Deprecated('Use getVehiclePositionResponseDescriptor instead')
const GetVehiclePositionResponse$json = {
  '1': 'GetVehiclePositionResponse',
  '2': [
    {
      '1': 'position',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Position',
      '10': 'position'
    },
    {
      '1': 'eta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ETA',
      '10': 'eta'
    },
  ],
};

/// Descriptor for `GetVehiclePositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVehiclePositionResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRWZWhpY2xlUG9zaXRpb25SZXNwb25zZRI9Cghwb3NpdGlvbhgBIAEoCzIhLmhlYWx0aG'
        'NhcmUuYW1idWxhbmNlLnYxLlBvc2l0aW9uUghwb3NpdGlvbhIuCgNldGEYAiABKAsyHC5oZWFs'
        'dGhjYXJlLmFtYnVsYW5jZS52MS5FVEFSA2V0YQ==');

@$core.Deprecated('Use listPingsRequestDescriptor instead')
const ListPingsRequest$json = {
  '1': 'ListPingsRequest',
  '2': [
    {'1': 'vehicle_id', '3': 1, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'trip_id', '3': 2, '4': 1, '5': 9, '10': 'tripId'},
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPingsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UGluZ3NSZXF1ZXN0Eh0KCnZlaGljbGVfaWQYASABKAlSCXZlaGljbGVJZBIXCgd0cm'
    'lwX2lkGAIgASgJUgZ0cmlwSWQSLgoEZnJvbRgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSBGZyb20SKgoCdG8YBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bx'
    'IbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listPingsResponseDescriptor instead')
const ListPingsResponse$json = {
  '1': 'ListPingsResponse',
  '2': [
    {
      '1': 'pings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.ambulance.v1.Ping',
      '10': 'pings'
    },
  ],
};

/// Descriptor for `ListPingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPingsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UGluZ3NSZXNwb25zZRIzCgVwaW5ncxgBIAMoCzIdLmhlYWx0aGNhcmUuYW1idWxhbm'
    'NlLnYxLlBpbmdSBXBpbmdz');

@$core.Deprecated('Use purgeExpiredPingsRequestDescriptor instead')
const PurgeExpiredPingsRequest$json = {
  '1': 'PurgeExpiredPingsRequest',
};

/// Descriptor for `PurgeExpiredPingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purgeExpiredPingsRequestDescriptor =
    $convert.base64Decode('ChhQdXJnZUV4cGlyZWRQaW5nc1JlcXVlc3Q=');

@$core.Deprecated('Use purgeExpiredPingsResponseDescriptor instead')
const PurgeExpiredPingsResponse$json = {
  '1': 'PurgeExpiredPingsResponse',
  '2': [
    {'1': 'removed', '3': 1, '4': 1, '5': 3, '10': 'removed'},
  ],
};

/// Descriptor for `PurgeExpiredPingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List purgeExpiredPingsResponseDescriptor =
    $convert.base64Decode(
        'ChlQdXJnZUV4cGlyZWRQaW5nc1Jlc3BvbnNlEhgKB3JlbW92ZWQYASABKANSB3JlbW92ZWQ=');

@$core.Deprecated('Use getTripMetricsRequestDescriptor instead')
const GetTripMetricsRequest$json = {
  '1': 'GetTripMetricsRequest',
  '2': [
    {'1': 'trip_id', '3': 1, '4': 1, '5': 9, '10': 'tripId'},
  ],
};

/// Descriptor for `GetTripMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTripMetricsRequestDescriptor =
    $convert.base64Decode(
        'ChVHZXRUcmlwTWV0cmljc1JlcXVlc3QSFwoHdHJpcF9pZBgBIAEoCVIGdHJpcElk');

@$core.Deprecated('Use getTripMetricsResponseDescriptor instead')
const GetTripMetricsResponse$json = {
  '1': 'GetTripMetricsResponse',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.TripMetrics',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `GetTripMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTripMetricsResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRUcmlwTWV0cmljc1Jlc3BvbnNlEj4KB21ldHJpY3MYASABKAsyJC5oZWFsdGhjYXJlLm'
        'FtYnVsYW5jZS52MS5UcmlwTWV0cmljc1IHbWV0cmljcw==');

@$core.Deprecated('Use getServiceSummaryRequestDescriptor instead')
const GetServiceSummaryRequest$json = {
  '1': 'GetServiceSummaryRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.ambulance.v1.TripState',
      '10': 'states'
    },
    {'1': 'vehicle_id', '3': 2, '4': 1, '5': 9, '10': 'vehicleId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `GetServiceSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceSummaryRequestDescriptor = $convert.base64Decode(
    'ChhHZXRTZXJ2aWNlU3VtbWFyeVJlcXVlc3QSOgoGc3RhdGVzGAEgAygOMiIuaGVhbHRoY2FyZS'
    '5hbWJ1bGFuY2UudjEuVHJpcFN0YXRlUgZzdGF0ZXMSHQoKdmVoaWNsZV9pZBgCIAEoCVIJdmVo'
    'aWNsZUlkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpmYWNpbGl0eUlkEi4KBGZyb20YBCABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAUgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getServiceSummaryResponseDescriptor instead')
const GetServiceSummaryResponse$json = {
  '1': 'GetServiceSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.ambulance.v1.ServiceSummary',
      '10': 'summary'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetServiceSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceSummaryResponseDescriptor = $convert.base64Decode(
    'ChlHZXRTZXJ2aWNlU3VtbWFyeVJlc3BvbnNlEkEKB3N1bW1hcnkYASABKAsyJy5oZWFsdGhjYX'
    'JlLmFtYnVsYW5jZS52MS5TZXJ2aWNlU3VtbWFyeVIHc3VtbWFyeRIcCgl0cnVuY2F0ZWQYAiAB'
    'KAhSCXRydW5jYXRlZA==');

@$core.Deprecated('Use sweepWaitingHandoversRequestDescriptor instead')
const SweepWaitingHandoversRequest$json = {
  '1': 'SweepWaitingHandoversRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `SweepWaitingHandoversRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepWaitingHandoversRequestDescriptor =
    $convert.base64Decode(
        'ChxTd2VlcFdhaXRpbmdIYW5kb3ZlcnNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYW'
        'NpbGl0eUlk');

@$core.Deprecated('Use sweepWaitingHandoversResponseDescriptor instead')
const SweepWaitingHandoversResponse$json = {
  '1': 'SweepWaitingHandoversResponse',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
  ],
};

/// Descriptor for `SweepWaitingHandoversResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepWaitingHandoversResponseDescriptor =
    $convert.base64Decode(
        'Ch1Td2VlcFdhaXRpbmdIYW5kb3ZlcnNSZXNwb25zZRIWCgZyYWlzZWQYASABKAVSBnJhaXNlZA'
        '==');

const $core.Map<$core.String, $core.dynamic> AmbulanceServiceBase$json = {
  '1': 'AmbulanceService',
  '2': [
    {
      '1': 'RegisterVehicle',
      '2': '.healthcare.ambulance.v1.RegisterVehicleRequest',
      '3': '.healthcare.ambulance.v1.RegisterVehicleResponse'
    },
    {
      '1': 'SetVehicleState',
      '2': '.healthcare.ambulance.v1.SetVehicleStateRequest',
      '3': '.healthcare.ambulance.v1.SetVehicleStateResponse'
    },
    {
      '1': 'GetVehicle',
      '2': '.healthcare.ambulance.v1.GetVehicleRequest',
      '3': '.healthcare.ambulance.v1.GetVehicleResponse'
    },
    {
      '1': 'ListVehicles',
      '2': '.healthcare.ambulance.v1.ListVehiclesRequest',
      '3': '.healthcare.ambulance.v1.ListVehiclesResponse'
    },
    {
      '1': 'RosterShift',
      '2': '.healthcare.ambulance.v1.RosterShiftRequest',
      '3': '.healthcare.ambulance.v1.RosterShiftResponse'
    },
    {
      '1': 'SetShiftState',
      '2': '.healthcare.ambulance.v1.SetShiftStateRequest',
      '3': '.healthcare.ambulance.v1.SetShiftStateResponse'
    },
    {
      '1': 'GetShift',
      '2': '.healthcare.ambulance.v1.GetShiftRequest',
      '3': '.healthcare.ambulance.v1.GetShiftResponse'
    },
    {
      '1': 'ListShifts',
      '2': '.healthcare.ambulance.v1.ListShiftsRequest',
      '3': '.healthcare.ambulance.v1.ListShiftsResponse'
    },
    {
      '1': 'RecordReadinessCheck',
      '2': '.healthcare.ambulance.v1.RecordReadinessCheckRequest',
      '3': '.healthcare.ambulance.v1.RecordReadinessCheckResponse'
    },
    {
      '1': 'OverrideReadinessCheck',
      '2': '.healthcare.ambulance.v1.OverrideReadinessCheckRequest',
      '3': '.healthcare.ambulance.v1.OverrideReadinessCheckResponse'
    },
    {
      '1': 'GetReadinessCheck',
      '2': '.healthcare.ambulance.v1.GetReadinessCheckRequest',
      '3': '.healthcare.ambulance.v1.GetReadinessCheckResponse'
    },
    {
      '1': 'ListReadinessChecks',
      '2': '.healthcare.ambulance.v1.ListReadinessChecksRequest',
      '3': '.healthcare.ambulance.v1.ListReadinessChecksResponse'
    },
    {
      '1': 'GetReadinessSummary',
      '2': '.healthcare.ambulance.v1.GetReadinessSummaryRequest',
      '3': '.healthcare.ambulance.v1.GetReadinessSummaryResponse'
    },
    {
      '1': 'RaiseRequest',
      '2': '.healthcare.ambulance.v1.RaiseRequestRequest',
      '3': '.healthcare.ambulance.v1.RaiseRequestResponse'
    },
    {
      '1': 'CancelRequest',
      '2': '.healthcare.ambulance.v1.CancelRequestRequest',
      '3': '.healthcare.ambulance.v1.CancelRequestResponse'
    },
    {
      '1': 'GetRequest',
      '2': '.healthcare.ambulance.v1.GetRequestRequest',
      '3': '.healthcare.ambulance.v1.GetRequestResponse'
    },
    {
      '1': 'ListRequests',
      '2': '.healthcare.ambulance.v1.ListRequestsRequest',
      '3': '.healthcare.ambulance.v1.ListRequestsResponse'
    },
    {
      '1': 'GetDispatchQueue',
      '2': '.healthcare.ambulance.v1.GetDispatchQueueRequest',
      '3': '.healthcare.ambulance.v1.GetDispatchQueueResponse'
    },
    {
      '1': 'Dispatch',
      '2': '.healthcare.ambulance.v1.DispatchRequest',
      '3': '.healthcare.ambulance.v1.DispatchResponse'
    },
    {
      '1': 'RecordTripMilestone',
      '2': '.healthcare.ambulance.v1.RecordTripMilestoneRequest',
      '3': '.healthcare.ambulance.v1.RecordTripMilestoneResponse'
    },
    {
      '1': 'AmendTripMilestone',
      '2': '.healthcare.ambulance.v1.AmendTripMilestoneRequest',
      '3': '.healthcare.ambulance.v1.AmendTripMilestoneResponse'
    },
    {
      '1': 'AbortTrip',
      '2': '.healthcare.ambulance.v1.AbortTripRequest',
      '3': '.healthcare.ambulance.v1.AbortTripResponse'
    },
    {
      '1': 'GetTrip',
      '2': '.healthcare.ambulance.v1.GetTripRequest',
      '3': '.healthcare.ambulance.v1.GetTripResponse'
    },
    {
      '1': 'ListTrips',
      '2': '.healthcare.ambulance.v1.ListTripsRequest',
      '3': '.healthcare.ambulance.v1.ListTripsResponse'
    },
    {
      '1': 'GetTimelineGaps',
      '2': '.healthcare.ambulance.v1.GetTimelineGapsRequest',
      '3': '.healthcare.ambulance.v1.GetTimelineGapsResponse'
    },
    {
      '1': 'OpenPrehospitalRecord',
      '2': '.healthcare.ambulance.v1.OpenPrehospitalRecordRequest',
      '3': '.healthcare.ambulance.v1.OpenPrehospitalRecordResponse'
    },
    {
      '1': 'RecordPrehospitalEntry',
      '2': '.healthcare.ambulance.v1.RecordPrehospitalEntryRequest',
      '3': '.healthcare.ambulance.v1.RecordPrehospitalEntryResponse'
    },
    {
      '1': 'AttachTransferDocument',
      '2': '.healthcare.ambulance.v1.AttachTransferDocumentRequest',
      '3': '.healthcare.ambulance.v1.AttachTransferDocumentResponse'
    },
    {
      '1': 'GiveHandover',
      '2': '.healthcare.ambulance.v1.GiveHandoverRequest',
      '3': '.healthcare.ambulance.v1.GiveHandoverResponse'
    },
    {
      '1': 'AcceptHandover',
      '2': '.healthcare.ambulance.v1.AcceptHandoverRequest',
      '3': '.healthcare.ambulance.v1.AcceptHandoverResponse'
    },
    {
      '1': 'GetPrehospitalRecord',
      '2': '.healthcare.ambulance.v1.GetPrehospitalRecordRequest',
      '3': '.healthcare.ambulance.v1.GetPrehospitalRecordResponse'
    },
    {
      '1': 'ListPrehospitalRecords',
      '2': '.healthcare.ambulance.v1.ListPrehospitalRecordsRequest',
      '3': '.healthcare.ambulance.v1.ListPrehospitalRecordsResponse'
    },
    {
      '1': 'SweepWaitingHandovers',
      '2': '.healthcare.ambulance.v1.SweepWaitingHandoversRequest',
      '3': '.healthcare.ambulance.v1.SweepWaitingHandoversResponse'
    },
    {
      '1': 'RecordPing',
      '2': '.healthcare.ambulance.v1.RecordPingRequest',
      '3': '.healthcare.ambulance.v1.RecordPingResponse'
    },
    {
      '1': 'RecordETA',
      '2': '.healthcare.ambulance.v1.RecordETARequest',
      '3': '.healthcare.ambulance.v1.RecordETAResponse'
    },
    {
      '1': 'GetVehiclePosition',
      '2': '.healthcare.ambulance.v1.GetVehiclePositionRequest',
      '3': '.healthcare.ambulance.v1.GetVehiclePositionResponse'
    },
    {
      '1': 'ListPings',
      '2': '.healthcare.ambulance.v1.ListPingsRequest',
      '3': '.healthcare.ambulance.v1.ListPingsResponse'
    },
    {
      '1': 'PurgeExpiredPings',
      '2': '.healthcare.ambulance.v1.PurgeExpiredPingsRequest',
      '3': '.healthcare.ambulance.v1.PurgeExpiredPingsResponse'
    },
    {
      '1': 'GetTripMetrics',
      '2': '.healthcare.ambulance.v1.GetTripMetricsRequest',
      '3': '.healthcare.ambulance.v1.GetTripMetricsResponse'
    },
    {
      '1': 'GetServiceSummary',
      '2': '.healthcare.ambulance.v1.GetServiceSummaryRequest',
      '3': '.healthcare.ambulance.v1.GetServiceSummaryResponse'
    },
  ],
};

@$core.Deprecated('Use ambulanceServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AmbulanceServiceBase$messageJson = {
  '.healthcare.ambulance.v1.RegisterVehicleRequest':
      RegisterVehicleRequest$json,
  '.healthcare.ambulance.v1.RegisterVehicleResponse':
      RegisterVehicleResponse$json,
  '.healthcare.ambulance.v1.Vehicle': Vehicle$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.ambulance.v1.SetVehicleStateRequest':
      SetVehicleStateRequest$json,
  '.healthcare.ambulance.v1.SetVehicleStateResponse':
      SetVehicleStateResponse$json,
  '.healthcare.ambulance.v1.GetVehicleRequest': GetVehicleRequest$json,
  '.healthcare.ambulance.v1.GetVehicleResponse': GetVehicleResponse$json,
  '.healthcare.ambulance.v1.ListVehiclesRequest': ListVehiclesRequest$json,
  '.healthcare.ambulance.v1.ListVehiclesResponse': ListVehiclesResponse$json,
  '.healthcare.ambulance.v1.RosterShiftRequest': RosterShiftRequest$json,
  '.healthcare.ambulance.v1.CrewMember': CrewMember$json,
  '.healthcare.ambulance.v1.RosterShiftResponse': RosterShiftResponse$json,
  '.healthcare.ambulance.v1.Shift': Shift$json,
  '.healthcare.ambulance.v1.SetShiftStateRequest': SetShiftStateRequest$json,
  '.healthcare.ambulance.v1.SetShiftStateResponse': SetShiftStateResponse$json,
  '.healthcare.ambulance.v1.GetShiftRequest': GetShiftRequest$json,
  '.healthcare.ambulance.v1.GetShiftResponse': GetShiftResponse$json,
  '.healthcare.ambulance.v1.ListShiftsRequest': ListShiftsRequest$json,
  '.healthcare.ambulance.v1.ListShiftsResponse': ListShiftsResponse$json,
  '.healthcare.ambulance.v1.RecordReadinessCheckRequest':
      RecordReadinessCheckRequest$json,
  '.healthcare.ambulance.v1.ChecklistItem': ChecklistItem$json,
  '.healthcare.ambulance.v1.ItemOutcome': ItemOutcome$json,
  '.healthcare.ambulance.v1.RecordReadinessCheckResponse':
      RecordReadinessCheckResponse$json,
  '.healthcare.ambulance.v1.ReadinessCheck': ReadinessCheck$json,
  '.healthcare.ambulance.v1.OverrideReadinessCheckRequest':
      OverrideReadinessCheckRequest$json,
  '.healthcare.ambulance.v1.OverrideReadinessCheckResponse':
      OverrideReadinessCheckResponse$json,
  '.healthcare.ambulance.v1.GetReadinessCheckRequest':
      GetReadinessCheckRequest$json,
  '.healthcare.ambulance.v1.GetReadinessCheckResponse':
      GetReadinessCheckResponse$json,
  '.healthcare.ambulance.v1.ListReadinessChecksRequest':
      ListReadinessChecksRequest$json,
  '.healthcare.ambulance.v1.ListReadinessChecksResponse':
      ListReadinessChecksResponse$json,
  '.healthcare.ambulance.v1.GetReadinessSummaryRequest':
      GetReadinessSummaryRequest$json,
  '.healthcare.ambulance.v1.GetReadinessSummaryResponse':
      GetReadinessSummaryResponse$json,
  '.healthcare.ambulance.v1.ReadinessSummary': ReadinessSummary$json,
  '.healthcare.ambulance.v1.ReadinessSummary.MissingByItemEntry':
      ReadinessSummary_MissingByItemEntry$json,
  '.healthcare.ambulance.v1.RaiseRequestRequest': RaiseRequestRequest$json,
  '.healthcare.ambulance.v1.RaiseRequestResponse': RaiseRequestResponse$json,
  '.healthcare.ambulance.v1.Request': Request$json,
  '.healthcare.ambulance.v1.CancelRequestRequest': CancelRequestRequest$json,
  '.healthcare.ambulance.v1.CancelRequestResponse': CancelRequestResponse$json,
  '.healthcare.ambulance.v1.GetRequestRequest': GetRequestRequest$json,
  '.healthcare.ambulance.v1.GetRequestResponse': GetRequestResponse$json,
  '.healthcare.ambulance.v1.ListRequestsRequest': ListRequestsRequest$json,
  '.healthcare.ambulance.v1.ListRequestsResponse': ListRequestsResponse$json,
  '.healthcare.ambulance.v1.GetDispatchQueueRequest':
      GetDispatchQueueRequest$json,
  '.healthcare.ambulance.v1.GetDispatchQueueResponse':
      GetDispatchQueueResponse$json,
  '.healthcare.ambulance.v1.DispatchRequest': DispatchRequest$json,
  '.healthcare.ambulance.v1.DispatchResponse': DispatchResponse$json,
  '.healthcare.ambulance.v1.Trip': Trip$json,
  '.healthcare.ambulance.v1.MilestoneRecord': MilestoneRecord$json,
  '.healthcare.ambulance.v1.RecordTripMilestoneRequest':
      RecordTripMilestoneRequest$json,
  '.healthcare.ambulance.v1.RecordTripMilestoneResponse':
      RecordTripMilestoneResponse$json,
  '.healthcare.ambulance.v1.AmendTripMilestoneRequest':
      AmendTripMilestoneRequest$json,
  '.healthcare.ambulance.v1.AmendTripMilestoneResponse':
      AmendTripMilestoneResponse$json,
  '.healthcare.ambulance.v1.AbortTripRequest': AbortTripRequest$json,
  '.healthcare.ambulance.v1.AbortTripResponse': AbortTripResponse$json,
  '.healthcare.ambulance.v1.GetTripRequest': GetTripRequest$json,
  '.healthcare.ambulance.v1.GetTripResponse': GetTripResponse$json,
  '.healthcare.ambulance.v1.ListTripsRequest': ListTripsRequest$json,
  '.healthcare.ambulance.v1.ListTripsResponse': ListTripsResponse$json,
  '.healthcare.ambulance.v1.GetTimelineGapsRequest':
      GetTimelineGapsRequest$json,
  '.healthcare.ambulance.v1.GetTimelineGapsResponse':
      GetTimelineGapsResponse$json,
  '.healthcare.ambulance.v1.OpenPrehospitalRecordRequest':
      OpenPrehospitalRecordRequest$json,
  '.healthcare.ambulance.v1.OpenPrehospitalRecordResponse':
      OpenPrehospitalRecordResponse$json,
  '.healthcare.ambulance.v1.PrehospitalRecord': PrehospitalRecord$json,
  '.healthcare.ambulance.v1.Entry': Entry$json,
  '.healthcare.ambulance.v1.RecordPrehospitalEntryRequest':
      RecordPrehospitalEntryRequest$json,
  '.healthcare.ambulance.v1.RecordPrehospitalEntryResponse':
      RecordPrehospitalEntryResponse$json,
  '.healthcare.ambulance.v1.AttachTransferDocumentRequest':
      AttachTransferDocumentRequest$json,
  '.healthcare.ambulance.v1.AttachTransferDocumentResponse':
      AttachTransferDocumentResponse$json,
  '.healthcare.ambulance.v1.GiveHandoverRequest': GiveHandoverRequest$json,
  '.healthcare.ambulance.v1.GiveHandoverResponse': GiveHandoverResponse$json,
  '.healthcare.ambulance.v1.AcceptHandoverRequest': AcceptHandoverRequest$json,
  '.healthcare.ambulance.v1.AcceptHandoverResponse':
      AcceptHandoverResponse$json,
  '.healthcare.ambulance.v1.GetPrehospitalRecordRequest':
      GetPrehospitalRecordRequest$json,
  '.healthcare.ambulance.v1.GetPrehospitalRecordResponse':
      GetPrehospitalRecordResponse$json,
  '.healthcare.ambulance.v1.ListPrehospitalRecordsRequest':
      ListPrehospitalRecordsRequest$json,
  '.healthcare.ambulance.v1.ListPrehospitalRecordsResponse':
      ListPrehospitalRecordsResponse$json,
  '.healthcare.ambulance.v1.SweepWaitingHandoversRequest':
      SweepWaitingHandoversRequest$json,
  '.healthcare.ambulance.v1.SweepWaitingHandoversResponse':
      SweepWaitingHandoversResponse$json,
  '.healthcare.ambulance.v1.RecordPingRequest': RecordPingRequest$json,
  '.healthcare.ambulance.v1.RecordPingResponse': RecordPingResponse$json,
  '.healthcare.ambulance.v1.Ping': Ping$json,
  '.healthcare.ambulance.v1.RecordETARequest': RecordETARequest$json,
  '.healthcare.ambulance.v1.RecordETAResponse': RecordETAResponse$json,
  '.healthcare.ambulance.v1.ETA': ETA$json,
  '.healthcare.ambulance.v1.GetVehiclePositionRequest':
      GetVehiclePositionRequest$json,
  '.healthcare.ambulance.v1.GetVehiclePositionResponse':
      GetVehiclePositionResponse$json,
  '.healthcare.ambulance.v1.Position': Position$json,
  '.healthcare.ambulance.v1.ListPingsRequest': ListPingsRequest$json,
  '.healthcare.ambulance.v1.ListPingsResponse': ListPingsResponse$json,
  '.healthcare.ambulance.v1.PurgeExpiredPingsRequest':
      PurgeExpiredPingsRequest$json,
  '.healthcare.ambulance.v1.PurgeExpiredPingsResponse':
      PurgeExpiredPingsResponse$json,
  '.healthcare.ambulance.v1.GetTripMetricsRequest': GetTripMetricsRequest$json,
  '.healthcare.ambulance.v1.GetTripMetricsResponse':
      GetTripMetricsResponse$json,
  '.healthcare.ambulance.v1.TripMetrics': TripMetrics$json,
  '.healthcare.ambulance.v1.GetServiceSummaryRequest':
      GetServiceSummaryRequest$json,
  '.healthcare.ambulance.v1.GetServiceSummaryResponse':
      GetServiceSummaryResponse$json,
  '.healthcare.ambulance.v1.ServiceSummary': ServiceSummary$json,
  '.healthcare.ambulance.v1.Interval': Interval$json,
};

/// Descriptor for `AmbulanceService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List ambulanceServiceDescriptor = $convert.base64Decode(
    'ChBBbWJ1bGFuY2VTZXJ2aWNlEnQKD1JlZ2lzdGVyVmVoaWNsZRIvLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlJlZ2lzdGVyVmVoaWNsZVJlcXVlc3QaMC5oZWFsdGhjYXJlLmFtYnVsYW5jZS52'
    'MS5SZWdpc3RlclZlaGljbGVSZXNwb25zZRJ0Cg9TZXRWZWhpY2xlU3RhdGUSLy5oZWFsdGhjYX'
    'JlLmFtYnVsYW5jZS52MS5TZXRWZWhpY2xlU3RhdGVSZXF1ZXN0GjAuaGVhbHRoY2FyZS5hbWJ1'
    'bGFuY2UudjEuU2V0VmVoaWNsZVN0YXRlUmVzcG9uc2USZQoKR2V0VmVoaWNsZRIqLmhlYWx0aG'
    'NhcmUuYW1idWxhbmNlLnYxLkdldFZlaGljbGVSZXF1ZXN0GisuaGVhbHRoY2FyZS5hbWJ1bGFu'
    'Y2UudjEuR2V0VmVoaWNsZVJlc3BvbnNlEmsKDExpc3RWZWhpY2xlcxIsLmhlYWx0aGNhcmUuYW'
    '1idWxhbmNlLnYxLkxpc3RWZWhpY2xlc1JlcXVlc3QaLS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52'
    'MS5MaXN0VmVoaWNsZXNSZXNwb25zZRJoCgtSb3N0ZXJTaGlmdBIrLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlJvc3RlclNoaWZ0UmVxdWVzdBosLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlJv'
    'c3RlclNoaWZ0UmVzcG9uc2USbgoNU2V0U2hpZnRTdGF0ZRItLmhlYWx0aGNhcmUuYW1idWxhbm'
    'NlLnYxLlNldFNoaWZ0U3RhdGVSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuU2V0'
    'U2hpZnRTdGF0ZVJlc3BvbnNlEl8KCEdldFNoaWZ0EiguaGVhbHRoY2FyZS5hbWJ1bGFuY2Uudj'
    'EuR2V0U2hpZnRSZXF1ZXN0GikuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuR2V0U2hpZnRSZXNw'
    'b25zZRJlCgpMaXN0U2hpZnRzEiouaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTGlzdFNoaWZ0c1'
    'JlcXVlc3QaKy5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5MaXN0U2hpZnRzUmVzcG9uc2USgwEK'
    'FFJlY29yZFJlYWRpbmVzc0NoZWNrEjQuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuUmVjb3JkUm'
    'VhZGluZXNzQ2hlY2tSZXF1ZXN0GjUuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuUmVjb3JkUmVh'
    'ZGluZXNzQ2hlY2tSZXNwb25zZRKJAQoWT3ZlcnJpZGVSZWFkaW5lc3NDaGVjaxI2LmhlYWx0aG'
    'NhcmUuYW1idWxhbmNlLnYxLk92ZXJyaWRlUmVhZGluZXNzQ2hlY2tSZXF1ZXN0GjcuaGVhbHRo'
    'Y2FyZS5hbWJ1bGFuY2UudjEuT3ZlcnJpZGVSZWFkaW5lc3NDaGVja1Jlc3BvbnNlEnoKEUdldF'
    'JlYWRpbmVzc0NoZWNrEjEuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuR2V0UmVhZGluZXNzQ2hl'
    'Y2tSZXF1ZXN0GjIuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuR2V0UmVhZGluZXNzQ2hlY2tSZX'
    'Nwb25zZRKAAQoTTGlzdFJlYWRpbmVzc0NoZWNrcxIzLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYx'
    'Lkxpc3RSZWFkaW5lc3NDaGVja3NSZXF1ZXN0GjQuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTG'
    'lzdFJlYWRpbmVzc0NoZWNrc1Jlc3BvbnNlEoABChNHZXRSZWFkaW5lc3NTdW1tYXJ5EjMuaGVh'
    'bHRoY2FyZS5hbWJ1bGFuY2UudjEuR2V0UmVhZGluZXNzU3VtbWFyeVJlcXVlc3QaNC5oZWFsdG'
    'hjYXJlLmFtYnVsYW5jZS52MS5HZXRSZWFkaW5lc3NTdW1tYXJ5UmVzcG9uc2USawoMUmFpc2VS'
    'ZXF1ZXN0EiwuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuUmFpc2VSZXF1ZXN0UmVxdWVzdBotLm'
    'hlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlJhaXNlUmVxdWVzdFJlc3BvbnNlEm4KDUNhbmNlbFJl'
    'cXVlc3QSLS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5DYW5jZWxSZXF1ZXN0UmVxdWVzdBouLm'
    'hlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkNhbmNlbFJlcXVlc3RSZXNwb25zZRJlCgpHZXRSZXF1'
    'ZXN0EiouaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuR2V0UmVxdWVzdFJlcXVlc3QaKy5oZWFsdG'
    'hjYXJlLmFtYnVsYW5jZS52MS5HZXRSZXF1ZXN0UmVzcG9uc2USawoMTGlzdFJlcXVlc3RzEiwu'
    'aGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTGlzdFJlcXVlc3RzUmVxdWVzdBotLmhlYWx0aGNhcm'
    'UuYW1idWxhbmNlLnYxLkxpc3RSZXF1ZXN0c1Jlc3BvbnNlEncKEEdldERpc3BhdGNoUXVldWUS'
    'MC5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5HZXREaXNwYXRjaFF1ZXVlUmVxdWVzdBoxLmhlYW'
    'x0aGNhcmUuYW1idWxhbmNlLnYxLkdldERpc3BhdGNoUXVldWVSZXNwb25zZRJfCghEaXNwYXRj'
    'aBIoLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkRpc3BhdGNoUmVxdWVzdBopLmhlYWx0aGNhcm'
    'UuYW1idWxhbmNlLnYxLkRpc3BhdGNoUmVzcG9uc2USgAEKE1JlY29yZFRyaXBNaWxlc3RvbmUS'
    'My5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5SZWNvcmRUcmlwTWlsZXN0b25lUmVxdWVzdBo0Lm'
    'hlYWx0aGNhcmUuYW1idWxhbmNlLnYxLlJlY29yZFRyaXBNaWxlc3RvbmVSZXNwb25zZRJ9ChJB'
    'bWVuZFRyaXBNaWxlc3RvbmUSMi5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5BbWVuZFRyaXBNaW'
    'xlc3RvbmVSZXF1ZXN0GjMuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQW1lbmRUcmlwTWlsZXN0'
    'b25lUmVzcG9uc2USYgoJQWJvcnRUcmlwEikuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQWJvcn'
    'RUcmlwUmVxdWVzdBoqLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkFib3J0VHJpcFJlc3BvbnNl'
    'ElwKB0dldFRyaXASJy5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5HZXRUcmlwUmVxdWVzdBooLm'
    'hlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkdldFRyaXBSZXNwb25zZRJiCglMaXN0VHJpcHMSKS5o'
    'ZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5MaXN0VHJpcHNSZXF1ZXN0GiouaGVhbHRoY2FyZS5hbW'
    'J1bGFuY2UudjEuTGlzdFRyaXBzUmVzcG9uc2USdAoPR2V0VGltZWxpbmVHYXBzEi8uaGVhbHRo'
    'Y2FyZS5hbWJ1bGFuY2UudjEuR2V0VGltZWxpbmVHYXBzUmVxdWVzdBowLmhlYWx0aGNhcmUuYW'
    '1idWxhbmNlLnYxLkdldFRpbWVsaW5lR2Fwc1Jlc3BvbnNlEoYBChVPcGVuUHJlaG9zcGl0YWxS'
    'ZWNvcmQSNS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5PcGVuUHJlaG9zcGl0YWxSZWNvcmRSZX'
    'F1ZXN0GjYuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuT3BlblByZWhvc3BpdGFsUmVjb3JkUmVz'
    'cG9uc2USiQEKFlJlY29yZFByZWhvc3BpdGFsRW50cnkSNi5oZWFsdGhjYXJlLmFtYnVsYW5jZS'
    '52MS5SZWNvcmRQcmVob3NwaXRhbEVudHJ5UmVxdWVzdBo3LmhlYWx0aGNhcmUuYW1idWxhbmNl'
    'LnYxLlJlY29yZFByZWhvc3BpdGFsRW50cnlSZXNwb25zZRKJAQoWQXR0YWNoVHJhbnNmZXJEb2'
    'N1bWVudBI2LmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkF0dGFjaFRyYW5zZmVyRG9jdW1lbnRS'
    'ZXF1ZXN0GjcuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuQXR0YWNoVHJhbnNmZXJEb2N1bWVudF'
    'Jlc3BvbnNlEmsKDEdpdmVIYW5kb3ZlchIsLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkdpdmVI'
    'YW5kb3ZlclJlcXVlc3QaLS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5HaXZlSGFuZG92ZXJSZX'
    'Nwb25zZRJxCg5BY2NlcHRIYW5kb3ZlchIuLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkFjY2Vw'
    'dEhhbmRvdmVyUmVxdWVzdBovLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkFjY2VwdEhhbmRvdm'
    'VyUmVzcG9uc2USgwEKFEdldFByZWhvc3BpdGFsUmVjb3JkEjQuaGVhbHRoY2FyZS5hbWJ1bGFu'
    'Y2UudjEuR2V0UHJlaG9zcGl0YWxSZWNvcmRSZXF1ZXN0GjUuaGVhbHRoY2FyZS5hbWJ1bGFuY2'
    'UudjEuR2V0UHJlaG9zcGl0YWxSZWNvcmRSZXNwb25zZRKJAQoWTGlzdFByZWhvc3BpdGFsUmVj'
    'b3JkcxI2LmhlYWx0aGNhcmUuYW1idWxhbmNlLnYxLkxpc3RQcmVob3NwaXRhbFJlY29yZHNSZX'
    'F1ZXN0GjcuaGVhbHRoY2FyZS5hbWJ1bGFuY2UudjEuTGlzdFByZWhvc3BpdGFsUmVjb3Jkc1Jl'
    'c3BvbnNlEoYBChVTd2VlcFdhaXRpbmdIYW5kb3ZlcnMSNS5oZWFsdGhjYXJlLmFtYnVsYW5jZS'
    '52MS5Td2VlcFdhaXRpbmdIYW5kb3ZlcnNSZXF1ZXN0GjYuaGVhbHRoY2FyZS5hbWJ1bGFuY2Uu'
    'djEuU3dlZXBXYWl0aW5nSGFuZG92ZXJzUmVzcG9uc2USZQoKUmVjb3JkUGluZxIqLmhlYWx0aG'
    'NhcmUuYW1idWxhbmNlLnYxLlJlY29yZFBpbmdSZXF1ZXN0GisuaGVhbHRoY2FyZS5hbWJ1bGFu'
    'Y2UudjEuUmVjb3JkUGluZ1Jlc3BvbnNlEmIKCVJlY29yZEVUQRIpLmhlYWx0aGNhcmUuYW1idW'
    'xhbmNlLnYxLlJlY29yZEVUQVJlcXVlc3QaKi5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5SZWNv'
    'cmRFVEFSZXNwb25zZRJ9ChJHZXRWZWhpY2xlUG9zaXRpb24SMi5oZWFsdGhjYXJlLmFtYnVsYW'
    '5jZS52MS5HZXRWZWhpY2xlUG9zaXRpb25SZXF1ZXN0GjMuaGVhbHRoY2FyZS5hbWJ1bGFuY2Uu'
    'djEuR2V0VmVoaWNsZVBvc2l0aW9uUmVzcG9uc2USYgoJTGlzdFBpbmdzEikuaGVhbHRoY2FyZS'
    '5hbWJ1bGFuY2UudjEuTGlzdFBpbmdzUmVxdWVzdBoqLmhlYWx0aGNhcmUuYW1idWxhbmNlLnYx'
    'Lkxpc3RQaW5nc1Jlc3BvbnNlEnoKEVB1cmdlRXhwaXJlZFBpbmdzEjEuaGVhbHRoY2FyZS5hbW'
    'J1bGFuY2UudjEuUHVyZ2VFeHBpcmVkUGluZ3NSZXF1ZXN0GjIuaGVhbHRoY2FyZS5hbWJ1bGFu'
    'Y2UudjEuUHVyZ2VFeHBpcmVkUGluZ3NSZXNwb25zZRJxCg5HZXRUcmlwTWV0cmljcxIuLmhlYW'
    'x0aGNhcmUuYW1idWxhbmNlLnYxLkdldFRyaXBNZXRyaWNzUmVxdWVzdBovLmhlYWx0aGNhcmUu'
    'YW1idWxhbmNlLnYxLkdldFRyaXBNZXRyaWNzUmVzcG9uc2USegoRR2V0U2VydmljZVN1bW1hcn'
    'kSMS5oZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5HZXRTZXJ2aWNlU3VtbWFyeVJlcXVlc3QaMi5o'
    'ZWFsdGhjYXJlLmFtYnVsYW5jZS52MS5HZXRTZXJ2aWNlU3VtbWFyeVJlc3BvbnNl');
