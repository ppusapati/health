// This is a generated file - do not edit.
//
// Generated from healthcare/biomedical/v1/biomedical.proto.

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

@$core.Deprecated('Use criticalityDescriptor instead')
const Criticality$json = {
  '1': 'Criticality',
  '2': [
    {'1': 'CRITICALITY_UNSPECIFIED', '2': 0},
    {'1': 'CRITICALITY_ROUTINE', '2': 1},
    {'1': 'CRITICALITY_IMPORTANT', '2': 2},
    {'1': 'CRITICALITY_CRITICAL', '2': 3},
    {'1': 'CRITICALITY_LIFE_SUPPORT', '2': 4},
  ],
};

/// Descriptor for `Criticality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List criticalityDescriptor = $convert.base64Decode(
    'CgtDcml0aWNhbGl0eRIbChdDUklUSUNBTElUWV9VTlNQRUNJRklFRBAAEhcKE0NSSVRJQ0FMSV'
    'RZX1JPVVRJTkUQARIZChVDUklUSUNBTElUWV9JTVBPUlRBTlQQAhIYChRDUklUSUNBTElUWV9D'
    'UklUSUNBTBADEhwKGENSSVRJQ0FMSVRZX0xJRkVfU1VQUE9SVBAE');

@$core.Deprecated('Use assetStatusDescriptor instead')
const AssetStatus$json = {
  '1': 'AssetStatus',
  '2': [
    {'1': 'ASSET_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_STATUS_IN_SERVICE', '2': 1},
    {'1': 'ASSET_STATUS_UNDER_MAINTENANCE', '2': 2},
    {'1': 'ASSET_STATUS_AWAITING_PARTS', '2': 3},
    {'1': 'ASSET_STATUS_OUT_OF_SERVICE', '2': 4},
    {'1': 'ASSET_STATUS_DECOMMISSIONED', '2': 5},
    {'1': 'ASSET_STATUS_DISPOSED', '2': 6},
  ],
};

/// Descriptor for `AssetStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetStatusDescriptor = $convert.base64Decode(
    'CgtBc3NldFN0YXR1cxIcChhBU1NFVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdBU1NFVF9TVE'
    'FUVVNfSU5fU0VSVklDRRABEiIKHkFTU0VUX1NUQVRVU19VTkRFUl9NQUlOVEVOQU5DRRACEh8K'
    'G0FTU0VUX1NUQVRVU19BV0FJVElOR19QQVJUUxADEh8KG0FTU0VUX1NUQVRVU19PVVRfT0ZfU0'
    'VSVklDRRAEEh8KG0FTU0VUX1NUQVRVU19ERUNPTU1JU1NJT05FRBAFEhkKFUFTU0VUX1NUQVRV'
    'U19ESVNQT1NFRBAG');

@$core.Deprecated('Use contractKindDescriptor instead')
const ContractKind$json = {
  '1': 'ContractKind',
  '2': [
    {'1': 'CONTRACT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'CONTRACT_KIND_WARRANTY', '2': 1},
    {'1': 'CONTRACT_KIND_AMC', '2': 2},
    {'1': 'CONTRACT_KIND_CMC', '2': 3},
  ],
};

/// Descriptor for `ContractKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contractKindDescriptor = $convert.base64Decode(
    'CgxDb250cmFjdEtpbmQSHQoZQ09OVFJBQ1RfS0lORF9VTlNQRUNJRklFRBAAEhoKFkNPTlRSQU'
    'NUX0tJTkRfV0FSUkFOVFkQARIVChFDT05UUkFDVF9LSU5EX0FNQxACEhUKEUNPTlRSQUNUX0tJ'
    'TkRfQ01DEAM=');

@$core.Deprecated('Use planBasisDescriptor instead')
const PlanBasis$json = {
  '1': 'PlanBasis',
  '2': [
    {'1': 'PLAN_BASIS_UNSPECIFIED', '2': 0},
    {'1': 'PLAN_BASIS_INTERVAL', '2': 1},
    {'1': 'PLAN_BASIS_RUNTIME', '2': 2},
    {'1': 'PLAN_BASIS_RISK', '2': 3},
  ],
};

/// Descriptor for `PlanBasis`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List planBasisDescriptor = $convert.base64Decode(
    'CglQbGFuQmFzaXMSGgoWUExBTl9CQVNJU19VTlNQRUNJRklFRBAAEhcKE1BMQU5fQkFTSVNfSU'
    '5URVJWQUwQARIWChJQTEFOX0JBU0lTX1JVTlRJTUUQAhITCg9QTEFOX0JBU0lTX1JJU0sQAw==');

@$core.Deprecated('Use dueStateDescriptor instead')
const DueState$json = {
  '1': 'DueState',
  '2': [
    {'1': 'DUE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DUE_STATE_NOT_DUE', '2': 1},
    {'1': 'DUE_STATE_DUE_SOON', '2': 2},
    {'1': 'DUE_STATE_DUE', '2': 3},
    {'1': 'DUE_STATE_OVERDUE', '2': 4},
  ],
};

/// Descriptor for `DueState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dueStateDescriptor = $convert.base64Decode(
    'CghEdWVTdGF0ZRIZChVEVUVfU1RBVEVfVU5TUEVDSUZJRUQQABIVChFEVUVfU1RBVEVfTk9UX0'
    'RVRRABEhYKEkRVRV9TVEFURV9EVUVfU09PThACEhEKDURVRV9TVEFURV9EVUUQAxIVChFEVUVf'
    'U1RBVEVfT1ZFUkRVRRAE');

@$core.Deprecated('Use ticketKindDescriptor instead')
const TicketKind$json = {
  '1': 'TicketKind',
  '2': [
    {'1': 'TICKET_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TICKET_KIND_CORRECTIVE', '2': 1},
    {'1': 'TICKET_KIND_PREVENTIVE', '2': 2},
    {'1': 'TICKET_KIND_CALIBRATION', '2': 3},
    {'1': 'TICKET_KIND_INSPECTION', '2': 4},
  ],
};

/// Descriptor for `TicketKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ticketKindDescriptor = $convert.base64Decode(
    'CgpUaWNrZXRLaW5kEhsKF1RJQ0tFVF9LSU5EX1VOU1BFQ0lGSUVEEAASGgoWVElDS0VUX0tJTk'
    'RfQ09SUkVDVElWRRABEhoKFlRJQ0tFVF9LSU5EX1BSRVZFTlRJVkUQAhIbChdUSUNLRVRfS0lO'
    'RF9DQUxJQlJBVElPThADEhoKFlRJQ0tFVF9LSU5EX0lOU1BFQ1RJT04QBA==');

@$core.Deprecated('Use priorityDescriptor instead')
const Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_LOW', '2': 1},
    {'1': 'PRIORITY_NORMAL', '2': 2},
    {'1': 'PRIORITY_HIGH', '2': 3},
    {'1': 'PRIORITY_EMERGENCY', '2': 4},
  ],
};

/// Descriptor for `Priority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityDescriptor = $convert.base64Decode(
    'CghQcmlvcml0eRIYChRQUklPUklUWV9VTlNQRUNJRklFRBAAEhAKDFBSSU9SSVRZX0xPVxABEh'
    'MKD1BSSU9SSVRZX05PUk1BTBACEhEKDVBSSU9SSVRZX0hJR0gQAxIWChJQUklPUklUWV9FTUVS'
    'R0VOQ1kQBA==');

@$core.Deprecated('Use impactDescriptor instead')
const Impact$json = {
  '1': 'Impact',
  '2': [
    {'1': 'IMPACT_UNSPECIFIED', '2': 0},
    {'1': 'IMPACT_NONE', '2': 1},
    {'1': 'IMPACT_DEGRADED', '2': 2},
    {'1': 'IMPACT_SERVICE_STOPPED', '2': 3},
    {'1': 'IMPACT_PATIENT_AFFECTED', '2': 4},
  ],
};

/// Descriptor for `Impact`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List impactDescriptor = $convert.base64Decode(
    'CgZJbXBhY3QSFgoSSU1QQUNUX1VOU1BFQ0lGSUVEEAASDwoLSU1QQUNUX05PTkUQARITCg9JTV'
    'BBQ1RfREVHUkFERUQQAhIaChZJTVBBQ1RfU0VSVklDRV9TVE9QUEVEEAMSGwoXSU1QQUNUX1BB'
    'VElFTlRfQUZGRUNURUQQBA==');

@$core.Deprecated('Use ticketStateDescriptor instead')
const TicketState$json = {
  '1': 'TicketState',
  '2': [
    {'1': 'TICKET_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TICKET_STATE_OPEN', '2': 1},
    {'1': 'TICKET_STATE_ASSIGNED', '2': 2},
    {'1': 'TICKET_STATE_IN_PROGRESS', '2': 3},
    {'1': 'TICKET_STATE_AWAITING_PARTS', '2': 4},
    {'1': 'TICKET_STATE_RESOLVED', '2': 5},
    {'1': 'TICKET_STATE_CLOSED', '2': 6},
    {'1': 'TICKET_STATE_CANCELLED', '2': 7},
  ],
};

/// Descriptor for `TicketState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List ticketStateDescriptor = $convert.base64Decode(
    'CgtUaWNrZXRTdGF0ZRIcChhUSUNLRVRfU1RBVEVfVU5TUEVDSUZJRUQQABIVChFUSUNLRVRfU1'
    'RBVEVfT1BFThABEhkKFVRJQ0tFVF9TVEFURV9BU1NJR05FRBACEhwKGFRJQ0tFVF9TVEFURV9J'
    'Tl9QUk9HUkVTUxADEh8KG1RJQ0tFVF9TVEFURV9BV0FJVElOR19QQVJUUxAEEhkKFVRJQ0tFVF'
    '9TVEFURV9SRVNPTFZFRBAFEhcKE1RJQ0tFVF9TVEFURV9DTE9TRUQQBhIaChZUSUNLRVRfU1RB'
    'VEVfQ0FOQ0VMTEVEEAc=');

@$core.Deprecated('Use noticeKindDescriptor instead')
const NoticeKind$json = {
  '1': 'NoticeKind',
  '2': [
    {'1': 'NOTICE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'NOTICE_KIND_RECALL', '2': 1},
    {'1': 'NOTICE_KIND_FIELD_SAFETY', '2': 2},
    {'1': 'NOTICE_KIND_ADVISORY', '2': 3},
  ],
};

/// Descriptor for `NoticeKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List noticeKindDescriptor = $convert.base64Decode(
    'CgpOb3RpY2VLaW5kEhsKF05PVElDRV9LSU5EX1VOU1BFQ0lGSUVEEAASFgoSTk9USUNFX0tJTk'
    'RfUkVDQUxMEAESHAoYTk9USUNFX0tJTkRfRklFTERfU0FGRVRZEAISGAoUTk9USUNFX0tJTkRf'
    'QURWSVNPUlkQAw==');

@$core.Deprecated('Use taskStateDescriptor instead')
const TaskState$json = {
  '1': 'TaskState',
  '2': [
    {'1': 'TASK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATE_OUTSTANDING', '2': 1},
    {'1': 'TASK_STATE_INSPECTED', '2': 2},
    {'1': 'TASK_STATE_CORRECTED', '2': 3},
    {'1': 'TASK_STATE_NOT_AFFECTED', '2': 4},
    {'1': 'TASK_STATE_QUARANTINED', '2': 5},
  ],
};

/// Descriptor for `TaskState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStateDescriptor = $convert.base64Decode(
    'CglUYXNrU3RhdGUSGgoWVEFTS19TVEFURV9VTlNQRUNJRklFRBAAEhoKFlRBU0tfU1RBVEVfT1'
    'VUU1RBTkRJTkcQARIYChRUQVNLX1NUQVRFX0lOU1BFQ1RFRBACEhgKFFRBU0tfU1RBVEVfQ09S'
    'UkVDVEVEEAMSGwoXVEFTS19TVEFURV9OT1RfQUZGRUNURUQQBBIaChZUQVNLX1NUQVRFX1FVQV'
    'JBTlRJTkVEEAU=');

@$core.Deprecated('Use expiryKindDescriptor instead')
const ExpiryKind$json = {
  '1': 'ExpiryKind',
  '2': [
    {'1': 'EXPIRY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EXPIRY_KIND_CONTRACT', '2': 1},
    {'1': 'EXPIRY_KIND_CALIBRATION', '2': 2},
  ],
};

/// Descriptor for `ExpiryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List expiryKindDescriptor = $convert.base64Decode(
    'CgpFeHBpcnlLaW5kEhsKF0VYUElSWV9LSU5EX1VOU1BFQ0lGSUVEEAASGAoURVhQSVJZX0tJTk'
    'RfQ09OVFJBQ1QQARIbChdFWFBJUllfS0lORF9DQUxJQlJBVElPThAC');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'tag', '3': 2, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'udi', '3': 3, '4': 1, '5': 9, '10': 'udi'},
    {'1': 'serial', '3': 4, '4': 1, '5': 9, '10': 'serial'},
    {'1': 'make', '3': 5, '4': 1, '5': 9, '10': 'make'},
    {'1': 'model', '3': 6, '4': 1, '5': 9, '10': 'model'},
    {'1': 'category', '3': 7, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'criticality',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Criticality',
      '10': 'criticality'
    },
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'location_id', '3': 10, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'department', '3': 11, '4': 1, '5': 9, '10': 'department'},
    {'1': 'capabilities', '3': 12, '4': 3, '5': 9, '10': 'capabilities'},
    {
      '1': 'acquired_on',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acquiredOn'
    },
    {
      '1': 'acquisition_cost_minor',
      '3': 14,
      '4': 1,
      '5': 3,
      '10': 'acquisitionCostMinor'
    },
    {
      '1': 'expected_life_years',
      '3': 15,
      '4': 1,
      '5': 5,
      '10': 'expectedLifeYears'
    },
    {
      '1': 'calibration_required',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'calibrationRequired'
    },
    {
      '1': 'calibration_due',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'calibrationDue'
    },
    {
      '1': 'calibration_certificate',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'calibrationCertificate'
    },
    {'1': 'safety_hold', '3': 19, '4': 1, '5': 8, '10': 'safetyHold'},
    {
      '1': 'safety_hold_reason',
      '3': 20,
      '4': 1,
      '5': 9,
      '10': 'safetyHoldReason'
    },
    {'1': 'notes', '3': 21, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'created_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 23, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 24, '4': 1, '5': 3, '10': 'version'},
    {'1': 'unusable_reasons', '3': 25, '4': 3, '5': 9, '10': 'unusableReasons'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIQCgN0YWcYAiABKAlSA3RhZxIQCg'
    'N1ZGkYAyABKAlSA3VkaRIWCgZzZXJpYWwYBCABKAlSBnNlcmlhbBISCgRtYWtlGAUgASgJUgRt'
    'YWtlEhQKBW1vZGVsGAYgASgJUgVtb2RlbBIaCghjYXRlZ29yeRgHIAEoCVIIY2F0ZWdvcnkSRw'
    'oLY3JpdGljYWxpdHkYCCABKA4yJS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuQ3JpdGljYWxp'
    'dHlSC2NyaXRpY2FsaXR5Ej0KBnN0YXR1cxgJIAEoDjIlLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC'
    '52MS5Bc3NldFN0YXR1c1IGc3RhdHVzEh8KC2xvY2F0aW9uX2lkGAogASgJUgpsb2NhdGlvbklk'
    'Eh4KCmRlcGFydG1lbnQYCyABKAlSCmRlcGFydG1lbnQSIgoMY2FwYWJpbGl0aWVzGAwgAygJUg'
    'xjYXBhYmlsaXRpZXMSOwoLYWNxdWlyZWRfb24YDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgphY3F1aXJlZE9uEjQKFmFjcXVpc2l0aW9uX2Nvc3RfbWlub3IYDiABKANSFGFjcX'
    'Vpc2l0aW9uQ29zdE1pbm9yEi4KE2V4cGVjdGVkX2xpZmVfeWVhcnMYDyABKAVSEWV4cGVjdGVk'
    'TGlmZVllYXJzEjEKFGNhbGlicmF0aW9uX3JlcXVpcmVkGBAgASgIUhNjYWxpYnJhdGlvblJlcX'
    'VpcmVkEkMKD2NhbGlicmF0aW9uX2R1ZRgRIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSDmNhbGlicmF0aW9uRHVlEjcKF2NhbGlicmF0aW9uX2NlcnRpZmljYXRlGBIgASgJUhZjYW'
    'xpYnJhdGlvbkNlcnRpZmljYXRlEh8KC3NhZmV0eV9ob2xkGBMgASgIUgpzYWZldHlIb2xkEiwK'
    'EnNhZmV0eV9ob2xkX3JlYXNvbhgUIAEoCVIQc2FmZXR5SG9sZFJlYXNvbhIUCgVub3RlcxgVIA'
    'EoCVIFbm90ZXMSOQoKY3JlYXRlZF9hdBgWIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GBcgASgJUgljcmVhdGVkQnkSGAoHdmVyc2lvbh'
    'gYIAEoA1IHdmVyc2lvbhIpChB1bnVzYWJsZV9yZWFzb25zGBkgAygJUg91bnVzYWJsZVJlYXNv'
    'bnM=');

@$core.Deprecated('Use registerAssetRequestDescriptor instead')
const RegisterAssetRequest$json = {
  '1': 'RegisterAssetRequest',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'udi', '3': 2, '4': 1, '5': 9, '10': 'udi'},
    {'1': 'serial', '3': 3, '4': 1, '5': 9, '10': 'serial'},
    {'1': 'make', '3': 4, '4': 1, '5': 9, '10': 'make'},
    {'1': 'model', '3': 5, '4': 1, '5': 9, '10': 'model'},
    {'1': 'category', '3': 6, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'criticality',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Criticality',
      '10': 'criticality'
    },
    {'1': 'location_id', '3': 8, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'department', '3': 9, '4': 1, '5': 9, '10': 'department'},
    {'1': 'capabilities', '3': 10, '4': 3, '5': 9, '10': 'capabilities'},
    {
      '1': 'acquired_on',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acquiredOn'
    },
    {
      '1': 'acquisition_cost_minor',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'acquisitionCostMinor'
    },
    {
      '1': 'expected_life_years',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'expectedLifeYears'
    },
    {
      '1': 'calibration_required',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'calibrationRequired'
    },
    {
      '1': 'calibration_due',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'calibrationDue'
    },
    {'1': 'notes', '3': 16, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RegisterAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerAssetRequestDescriptor = $convert.base64Decode(
    'ChRSZWdpc3RlckFzc2V0UmVxdWVzdBIQCgN0YWcYASABKAlSA3RhZxIQCgN1ZGkYAiABKAlSA3'
    'VkaRIWCgZzZXJpYWwYAyABKAlSBnNlcmlhbBISCgRtYWtlGAQgASgJUgRtYWtlEhQKBW1vZGVs'
    'GAUgASgJUgVtb2RlbBIaCghjYXRlZ29yeRgGIAEoCVIIY2F0ZWdvcnkSRwoLY3JpdGljYWxpdH'
    'kYByABKA4yJS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuQ3JpdGljYWxpdHlSC2NyaXRpY2Fs'
    'aXR5Eh8KC2xvY2F0aW9uX2lkGAggASgJUgpsb2NhdGlvbklkEh4KCmRlcGFydG1lbnQYCSABKA'
    'lSCmRlcGFydG1lbnQSIgoMY2FwYWJpbGl0aWVzGAogAygJUgxjYXBhYmlsaXRpZXMSOwoLYWNx'
    'dWlyZWRfb24YCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphY3F1aXJlZE9uEj'
    'QKFmFjcXVpc2l0aW9uX2Nvc3RfbWlub3IYDCABKANSFGFjcXVpc2l0aW9uQ29zdE1pbm9yEi4K'
    'E2V4cGVjdGVkX2xpZmVfeWVhcnMYDSABKAVSEWV4cGVjdGVkTGlmZVllYXJzEjEKFGNhbGlicm'
    'F0aW9uX3JlcXVpcmVkGA4gASgIUhNjYWxpYnJhdGlvblJlcXVpcmVkEkMKD2NhbGlicmF0aW9u'
    'X2R1ZRgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmNhbGlicmF0aW9uRHVlEh'
    'QKBW5vdGVzGBAgASgJUgVub3Rlcw==');

@$core.Deprecated('Use registerAssetResponseDescriptor instead')
const RegisterAssetResponse$json = {
  '1': 'RegisterAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `RegisterAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerAssetResponseDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlckFzc2V0UmVzcG9uc2USNQoFYXNzZXQYASABKAsyHy5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuQXNzZXRSBWFzc2V0');

@$core.Deprecated('Use getAssetRequestDescriptor instead')
const GetAssetRequest$json = {
  '1': 'GetAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `GetAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRBc3NldFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use getAssetResponseDescriptor instead')
const GetAssetResponse$json = {
  '1': 'GetAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetResponseDescriptor = $convert.base64Decode(
    'ChBHZXRBc3NldFJlc3BvbnNlEjUKBWFzc2V0GAEgASgLMh8uaGVhbHRoY2FyZS5iaW9tZWRpY2'
    'FsLnYxLkFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use getAssetByTagRequestDescriptor instead')
const GetAssetByTagRequest$json = {
  '1': 'GetAssetByTagRequest',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
  ],
};

/// Descriptor for `GetAssetByTagRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetByTagRequestDescriptor = $convert
    .base64Decode('ChRHZXRBc3NldEJ5VGFnUmVxdWVzdBIQCgN0YWcYASABKAlSA3RhZw==');

@$core.Deprecated('Use getAssetByTagResponseDescriptor instead')
const GetAssetByTagResponse$json = {
  '1': 'GetAssetByTagResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetAssetByTagResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetByTagResponseDescriptor = $convert.base64Decode(
    'ChVHZXRBc3NldEJ5VGFnUmVzcG9uc2USNQoFYXNzZXQYASABKAsyHy5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuQXNzZXRSBWFzc2V0');

@$core.Deprecated('Use listAssetsRequestDescriptor instead')
const ListAssetsRequest$json = {
  '1': 'ListAssetsRequest',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'exclude_retired', '3': 3, '4': 1, '5': 8, '10': 'excludeRetired'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QXNzZXRzUmVxdWVzdBIaCghjYXRlZ29yeRgBIAEoCVIIY2F0ZWdvcnkSPQoGc3RhdH'
    'VzGAIgASgOMiUuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkFzc2V0U3RhdHVzUgZzdGF0dXMS'
    'JwoPZXhjbHVkZV9yZXRpcmVkGAMgASgIUg5leGNsdWRlUmV0aXJlZBIbCglwYWdlX3NpemUYBC'
    'ABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listAssetsResponseDescriptor instead')
const ListAssetsResponse$json = {
  '1': 'ListAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `ListAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QXNzZXRzUmVzcG9uc2USNwoGYXNzZXRzGAEgAygLMh8uaGVhbHRoY2FyZS5iaW9tZW'
    'RpY2FsLnYxLkFzc2V0UgZhc3NldHM=');

@$core.Deprecated('Use moveAssetRequestDescriptor instead')
const MoveAssetRequest$json = {
  '1': 'MoveAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'clear_location', '3': 4, '4': 1, '5': 8, '10': 'clearLocation'},
    {'1': 'department', '3': 5, '4': 1, '5': 9, '10': 'department'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_version', '3': 7, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `MoveAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveAssetRequestDescriptor = $convert.base64Decode(
    'ChBNb3ZlQXNzZXRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEj0KBnN0YXR1cx'
    'gCIAEoDjIlLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Bc3NldFN0YXR1c1IGc3RhdHVzEh8K'
    'C2xvY2F0aW9uX2lkGAMgASgJUgpsb2NhdGlvbklkEiUKDmNsZWFyX2xvY2F0aW9uGAQgASgIUg'
    '1jbGVhckxvY2F0aW9uEh4KCmRlcGFydG1lbnQYBSABKAlSCmRlcGFydG1lbnQSEgoEbm90ZRgG'
    'IAEoCVIEbm90ZRIpChBleHBlY3RlZF92ZXJzaW9uGAcgASgDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use moveAssetResponseDescriptor instead')
const MoveAssetResponse$json = {
  '1': 'MoveAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `MoveAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveAssetResponseDescriptor = $convert.base64Decode(
    'ChFNb3ZlQXNzZXRSZXNwb25zZRI1CgVhc3NldBgBIAEoCzIfLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5Bc3NldFIFYXNzZXQ=');

@$core.Deprecated('Use recordCalibrationRequestDescriptor instead')
const RecordCalibrationRequest$json = {
  '1': 'RecordCalibrationRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'certificate', '3': 2, '4': 1, '5': 9, '10': 'certificate'},
    {
      '1': 'next_due',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'nextDue'
    },
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RecordCalibrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCalibrationRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRDYWxpYnJhdGlvblJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSIA'
    'oLY2VydGlmaWNhdGUYAiABKAlSC2NlcnRpZmljYXRlEjUKCG5leHRfZHVlGAMgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHbmV4dER1ZRIpChBleHBlY3RlZF92ZXJzaW9uGAQgAS'
    'gDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use recordCalibrationResponseDescriptor instead')
const RecordCalibrationResponse$json = {
  '1': 'RecordCalibrationResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `RecordCalibrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCalibrationResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRDYWxpYnJhdGlvblJlc3BvbnNlEjUKBWFzc2V0GAEgASgLMh8uaGVhbHRoY2FyZS'
        '5iaW9tZWRpY2FsLnYxLkFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use holdAssetRequestDescriptor instead')
const HoldAssetRequest$json = {
  '1': 'HoldAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `HoldAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdAssetRequestDescriptor = $convert.base64Decode(
    'ChBIb2xkQXNzZXRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhYKBnJlYXNvbh'
    'gCIAEoCVIGcmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YAyABKANSD2V4cGVjdGVkVmVyc2lv'
    'bg==');

@$core.Deprecated('Use holdAssetResponseDescriptor instead')
const HoldAssetResponse$json = {
  '1': 'HoldAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `HoldAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdAssetResponseDescriptor = $convert.base64Decode(
    'ChFIb2xkQXNzZXRSZXNwb25zZRI1CgVhc3NldBgBIAEoCzIfLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5Bc3NldFIFYXNzZXQ=');

@$core.Deprecated('Use releaseAssetRequestDescriptor instead')
const ReleaseAssetRequest$json = {
  '1': 'ReleaseAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ReleaseAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseAssetRequestDescriptor = $convert.base64Decode(
    'ChNSZWxlYXNlQXNzZXRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhYKBnJlYX'
    'NvbhgCIAEoCVIGcmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YAyABKANSD2V4cGVjdGVkVmVy'
    'c2lvbg==');

@$core.Deprecated('Use releaseAssetResponseDescriptor instead')
const ReleaseAssetResponse$json = {
  '1': 'ReleaseAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `ReleaseAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseAssetResponseDescriptor = $convert.base64Decode(
    'ChRSZWxlYXNlQXNzZXRSZXNwb25zZRI1CgVhc3NldBgBIAEoCzIfLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5Bc3NldFIFYXNzZXQ=');

@$core.Deprecated('Use unusableAssetDescriptor instead')
const UnusableAsset$json = {
  '1': 'UnusableAsset',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'reasons', '3': 2, '4': 3, '5': 9, '10': 'reasons'},
  ],
};

/// Descriptor for `UnusableAsset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unusableAssetDescriptor = $convert.base64Decode(
    'Cg1VbnVzYWJsZUFzc2V0EhAKA3RhZxgBIAEoCVIDdGFnEhgKB3JlYXNvbnMYAiADKAlSB3JlYX'
    'NvbnM=');

@$core.Deprecated('Use getLocationCapabilityRequestDescriptor instead')
const GetLocationCapabilityRequest$json = {
  '1': 'GetLocationCapabilityRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
  ],
};

/// Descriptor for `GetLocationCapabilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLocationCapabilityRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRMb2NhdGlvbkNhcGFiaWxpdHlSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2'
        'NhdGlvbklk');

@$core.Deprecated('Use getLocationCapabilityResponseDescriptor instead')
const GetLocationCapabilityResponse$json = {
  '1': 'GetLocationCapabilityResponse',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'available',
      '3': 2,
      '4': 3,
      '5': 11,
      '6':
          '.healthcare.biomedical.v1.GetLocationCapabilityResponse.AvailableEntry',
      '10': 'available'
    },
    {'1': 'unavailable', '3': 3, '4': 3, '5': 9, '10': 'unavailable'},
    {
      '1': 'unusable',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.UnusableAsset',
      '10': 'unusable'
    },
    {
      '1': 'observed_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
  '3': [GetLocationCapabilityResponse_AvailableEntry$json],
};

@$core.Deprecated('Use getLocationCapabilityResponseDescriptor instead')
const GetLocationCapabilityResponse_AvailableEntry$json = {
  '1': 'AvailableEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetLocationCapabilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLocationCapabilityResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRMb2NhdGlvbkNhcGFiaWxpdHlSZXNwb25zZRIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG'
    '9jYXRpb25JZBJkCglhdmFpbGFibGUYAiADKAsyRi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEu'
    'R2V0TG9jYXRpb25DYXBhYmlsaXR5UmVzcG9uc2UuQXZhaWxhYmxlRW50cnlSCWF2YWlsYWJsZR'
    'IgCgt1bmF2YWlsYWJsZRgDIAMoCVILdW5hdmFpbGFibGUSQwoIdW51c2FibGUYBCADKAsyJy5o'
    'ZWFsdGhjYXJlLmJpb21lZGljYWwudjEuVW51c2FibGVBc3NldFIIdW51c2FibGUSOwoLb2JzZX'
    'J2ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0GjwK'
    'DkF2YWlsYWJsZUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgFUgV2YWx1ZT'
    'oCOAE=');

@$core.Deprecated('Use serviceContractDescriptor instead')
const ServiceContract$json = {
  '1': 'ServiceContract',
  '2': [
    {'1': 'contract_id', '3': 1, '4': 1, '5': 9, '10': 'contractId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.ContractKind',
      '10': 'kind'
    },
    {'1': 'reference', '3': 4, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'vendor_name', '3': 5, '4': 1, '5': 9, '10': 'vendorName'},
    {'1': 'vendor_contact', '3': 6, '4': 1, '5': 9, '10': 'vendorContact'},
    {'1': 'vendor_phone', '3': 7, '4': 1, '5': 9, '10': 'vendorPhone'},
    {'1': 'vendor_email', '3': 8, '4': 1, '5': 9, '10': 'vendorEmail'},
    {
      '1': 'starts_on',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsOn'
    },
    {
      '1': 'ends_on',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsOn'
    },
    {'1': 'value_minor', '3': 11, '4': 1, '5': 3, '10': 'valueMinor'},
    {'1': 'response_hours', '3': 12, '4': 1, '5': 5, '10': 'responseHours'},
    {'1': 'resolution_hours', '3': 13, '4': 1, '5': 5, '10': 'resolutionHours'},
    {'1': 'notes', '3': 14, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'created_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 16, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ServiceContract`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceContractDescriptor = $convert.base64Decode(
    'Cg9TZXJ2aWNlQ29udHJhY3QSHwoLY29udHJhY3RfaWQYASABKAlSCmNvbnRyYWN0SWQSGQoIYX'
    'NzZXRfaWQYAiABKAlSB2Fzc2V0SWQSOgoEa2luZBgDIAEoDjImLmhlYWx0aGNhcmUuYmlvbWVk'
    'aWNhbC52MS5Db250cmFjdEtpbmRSBGtpbmQSHAoJcmVmZXJlbmNlGAQgASgJUglyZWZlcmVuY2'
    'USHwoLdmVuZG9yX25hbWUYBSABKAlSCnZlbmRvck5hbWUSJQoOdmVuZG9yX2NvbnRhY3QYBiAB'
    'KAlSDXZlbmRvckNvbnRhY3QSIQoMdmVuZG9yX3Bob25lGAcgASgJUgt2ZW5kb3JQaG9uZRIhCg'
    'x2ZW5kb3JfZW1haWwYCCABKAlSC3ZlbmRvckVtYWlsEjcKCXN0YXJ0c19vbhgJIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YXJ0c09uEjMKB2VuZHNfb24YCiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgZlbmRzT24SHwoLdmFsdWVfbWlub3IYCyABKANSCnZh'
    'bHVlTWlub3ISJQoOcmVzcG9uc2VfaG91cnMYDCABKAVSDXJlc3BvbnNlSG91cnMSKQoQcmVzb2'
    'x1dGlvbl9ob3VycxgNIAEoBVIPcmVzb2x1dGlvbkhvdXJzEhQKBW5vdGVzGA4gASgJUgVub3Rl'
    'cxI5CgpjcmVhdGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYX'
    'RlZEF0Eh0KCmNyZWF0ZWRfYnkYECABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGBEgASgDUgd2'
    'ZXJzaW9u');

@$core.Deprecated('Use recordContractRequestDescriptor instead')
const RecordContractRequest$json = {
  '1': 'RecordContractRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.ContractKind',
      '10': 'kind'
    },
    {'1': 'reference', '3': 3, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'vendor_name', '3': 4, '4': 1, '5': 9, '10': 'vendorName'},
    {'1': 'vendor_contact', '3': 5, '4': 1, '5': 9, '10': 'vendorContact'},
    {'1': 'vendor_phone', '3': 6, '4': 1, '5': 9, '10': 'vendorPhone'},
    {'1': 'vendor_email', '3': 7, '4': 1, '5': 9, '10': 'vendorEmail'},
    {
      '1': 'starts_on',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsOn'
    },
    {
      '1': 'ends_on',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsOn'
    },
    {'1': 'value_minor', '3': 10, '4': 1, '5': 3, '10': 'valueMinor'},
    {'1': 'response_hours', '3': 11, '4': 1, '5': 5, '10': 'responseHours'},
    {'1': 'resolution_hours', '3': 12, '4': 1, '5': 5, '10': 'resolutionHours'},
    {'1': 'notes', '3': 13, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RecordContractRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordContractRequestDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRDb250cmFjdFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSOgoEa2'
    'luZBgCIAEoDjImLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Db250cmFjdEtpbmRSBGtpbmQS'
    'HAoJcmVmZXJlbmNlGAMgASgJUglyZWZlcmVuY2USHwoLdmVuZG9yX25hbWUYBCABKAlSCnZlbm'
    'Rvck5hbWUSJQoOdmVuZG9yX2NvbnRhY3QYBSABKAlSDXZlbmRvckNvbnRhY3QSIQoMdmVuZG9y'
    'X3Bob25lGAYgASgJUgt2ZW5kb3JQaG9uZRIhCgx2ZW5kb3JfZW1haWwYByABKAlSC3ZlbmRvck'
    'VtYWlsEjcKCXN0YXJ0c19vbhgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0'
    'YXJ0c09uEjMKB2VuZHNfb24YCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZlbm'
    'RzT24SHwoLdmFsdWVfbWlub3IYCiABKANSCnZhbHVlTWlub3ISJQoOcmVzcG9uc2VfaG91cnMY'
    'CyABKAVSDXJlc3BvbnNlSG91cnMSKQoQcmVzb2x1dGlvbl9ob3VycxgMIAEoBVIPcmVzb2x1dG'
    'lvbkhvdXJzEhQKBW5vdGVzGA0gASgJUgVub3Rlcw==');

@$core.Deprecated('Use recordContractResponseDescriptor instead')
const RecordContractResponse$json = {
  '1': 'RecordContractResponse',
  '2': [
    {
      '1': 'contract',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.ServiceContract',
      '10': 'contract'
    },
  ],
};

/// Descriptor for `RecordContractResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordContractResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWNvcmRDb250cmFjdFJlc3BvbnNlEkUKCGNvbnRyYWN0GAEgASgLMikuaGVhbHRoY2FyZS'
        '5iaW9tZWRpY2FsLnYxLlNlcnZpY2VDb250cmFjdFIIY29udHJhY3Q=');

@$core.Deprecated('Use getContractRequestDescriptor instead')
const GetContractRequest$json = {
  '1': 'GetContractRequest',
  '2': [
    {'1': 'contract_id', '3': 1, '4': 1, '5': 9, '10': 'contractId'},
  ],
};

/// Descriptor for `GetContractRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getContractRequestDescriptor = $convert.base64Decode(
    'ChJHZXRDb250cmFjdFJlcXVlc3QSHwoLY29udHJhY3RfaWQYASABKAlSCmNvbnRyYWN0SWQ=');

@$core.Deprecated('Use getContractResponseDescriptor instead')
const GetContractResponse$json = {
  '1': 'GetContractResponse',
  '2': [
    {
      '1': 'contract',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.ServiceContract',
      '10': 'contract'
    },
  ],
};

/// Descriptor for `GetContractResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getContractResponseDescriptor = $convert.base64Decode(
    'ChNHZXRDb250cmFjdFJlc3BvbnNlEkUKCGNvbnRyYWN0GAEgASgLMikuaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLlNlcnZpY2VDb250cmFjdFIIY29udHJhY3Q=');

@$core.Deprecated('Use listContractsForAssetRequestDescriptor instead')
const ListContractsForAssetRequest$json = {
  '1': 'ListContractsForAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `ListContractsForAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContractsForAssetRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q29udHJhY3RzRm9yQXNzZXRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldE'
        'lk');

@$core.Deprecated('Use listContractsForAssetResponseDescriptor instead')
const ListContractsForAssetResponse$json = {
  '1': 'ListContractsForAssetResponse',
  '2': [
    {
      '1': 'contracts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.ServiceContract',
      '10': 'contracts'
    },
  ],
};

/// Descriptor for `ListContractsForAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listContractsForAssetResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29udHJhY3RzRm9yQXNzZXRSZXNwb25zZRJHCgljb250cmFjdHMYASADKAsyKS5oZW'
        'FsdGhjYXJlLmJpb21lZGljYWwudjEuU2VydmljZUNvbnRyYWN0Ugljb250cmFjdHM=');

@$core.Deprecated('Use getCoverForAssetRequestDescriptor instead')
const GetCoverForAssetRequest$json = {
  '1': 'GetCoverForAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `GetCoverForAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCoverForAssetRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDb3ZlckZvckFzc2V0UmVxdWVzdBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZA==');

@$core.Deprecated('Use getCoverForAssetResponseDescriptor instead')
const GetCoverForAssetResponse$json = {
  '1': 'GetCoverForAssetResponse',
  '2': [
    {
      '1': 'contract',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.ServiceContract',
      '10': 'contract'
    },
    {'1': 'covered', '3': 2, '4': 1, '5': 8, '10': 'covered'},
  ],
};

/// Descriptor for `GetCoverForAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCoverForAssetResponseDescriptor = $convert.base64Decode(
    'ChhHZXRDb3ZlckZvckFzc2V0UmVzcG9uc2USRQoIY29udHJhY3QYASABKAsyKS5oZWFsdGhjYX'
    'JlLmJpb21lZGljYWwudjEuU2VydmljZUNvbnRyYWN0Ughjb250cmFjdBIYCgdjb3ZlcmVkGAIg'
    'ASgIUgdjb3ZlcmVk');

@$core.Deprecated('Use expiryDescriptor instead')
const Expiry$json = {
  '1': 'Expiry',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.ExpiryKind',
      '10': 'kind'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 3, '4': 1, '5': 9, '10': 'assetTag'},
    {'1': 'reference', '3': 4, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'vendor_name', '3': 5, '4': 1, '5': 9, '10': 'vendorName'},
    {
      '1': 'expires_on',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresOn'
    },
    {'1': 'days_remaining', '3': 7, '4': 1, '5': 5, '10': 'daysRemaining'},
    {'1': 'detail', '3': 8, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `Expiry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expiryDescriptor = $convert.base64Decode(
    'CgZFeHBpcnkSOAoEa2luZBgBIAEoDjIkLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5FeHBpcn'
    'lLaW5kUgRraW5kEhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldElkEhsKCWFzc2V0X3RhZxgDIAEo'
    'CVIIYXNzZXRUYWcSHAoJcmVmZXJlbmNlGAQgASgJUglyZWZlcmVuY2USHwoLdmVuZG9yX25hbW'
    'UYBSABKAlSCnZlbmRvck5hbWUSOQoKZXhwaXJlc19vbhgGIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWV4cGlyZXNPbhIlCg5kYXlzX3JlbWFpbmluZxgHIAEoBVINZGF5c1JlbW'
    'FpbmluZxIWCgZkZXRhaWwYCCABKAlSBmRldGFpbA==');

@$core.Deprecated('Use listExpiryRemindersRequestDescriptor instead')
const ListExpiryRemindersRequest$json = {
  '1': 'ListExpiryRemindersRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListExpiryRemindersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExpiryRemindersRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RXhwaXJ5UmVtaW5kZXJzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaX'
        'pl');

@$core.Deprecated('Use listExpiryRemindersResponseDescriptor instead')
const ListExpiryRemindersResponse$json = {
  '1': 'ListExpiryRemindersResponse',
  '2': [
    {
      '1': 'expiries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Expiry',
      '10': 'expiries'
    },
  ],
};

/// Descriptor for `ListExpiryRemindersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExpiryRemindersResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RXhwaXJ5UmVtaW5kZXJzUmVzcG9uc2USPAoIZXhwaXJpZXMYASADKAsyIC5oZWFsdG'
        'hjYXJlLmJpb21lZGljYWwudjEuRXhwaXJ5UghleHBpcmllcw==');

@$core.Deprecated('Use pMPlanDescriptor instead')
const PMPlan$json = {
  '1': 'PMPlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'basis',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.PlanBasis',
      '10': 'basis'
    },
    {'1': 'interval_days', '3': 4, '4': 1, '5': 5, '10': 'intervalDays'},
    {'1': 'runtime_hours', '3': 5, '4': 1, '5': 5, '10': 'runtimeHours'},
    {'1': 'procedure', '3': 6, '4': 1, '5': 9, '10': 'procedure'},
    {
      '1': 'estimated_minutes',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'estimatedMinutes'
    },
    {
      '1': 'last_performed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastPerformedAt'
    },
    {
      '1': 'last_runtime_hours',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'lastRuntimeHours'
    },
    {'1': 'active', '3': 10, '4': 1, '5': 8, '10': 'active'},
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

/// Descriptor for `PMPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pMPlanDescriptor = $convert.base64Decode(
    'CgZQTVBsYW4SFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEhkKCGFzc2V0X2lkGAIgASgJUgdhc3'
    'NldElkEjkKBWJhc2lzGAMgASgOMiMuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlBsYW5CYXNp'
    'c1IFYmFzaXMSIwoNaW50ZXJ2YWxfZGF5cxgEIAEoBVIMaW50ZXJ2YWxEYXlzEiMKDXJ1bnRpbW'
    'VfaG91cnMYBSABKAVSDHJ1bnRpbWVIb3VycxIcCglwcm9jZWR1cmUYBiABKAlSCXByb2NlZHVy'
    'ZRIrChFlc3RpbWF0ZWRfbWludXRlcxgHIAEoBVIQZXN0aW1hdGVkTWludXRlcxJGChFsYXN0X3'
    'BlcmZvcm1lZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSD2xhc3RQZXJm'
    'b3JtZWRBdBIsChJsYXN0X3J1bnRpbWVfaG91cnMYCSABKAVSEGxhc3RSdW50aW1lSG91cnMSFg'
    'oGYWN0aXZlGAogASgIUgZhY3RpdmUSOQoKY3JlYXRlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GAwgASgJUgljcmVhdGVkQn'
    'kSGAoHdmVyc2lvbhgNIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use schedulePlanRequestDescriptor instead')
const SchedulePlanRequest$json = {
  '1': 'SchedulePlanRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'basis',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.PlanBasis',
      '10': 'basis'
    },
    {'1': 'interval_days', '3': 3, '4': 1, '5': 5, '10': 'intervalDays'},
    {'1': 'runtime_hours', '3': 4, '4': 1, '5': 5, '10': 'runtimeHours'},
    {'1': 'procedure', '3': 5, '4': 1, '5': 9, '10': 'procedure'},
    {
      '1': 'estimated_minutes',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'estimatedMinutes'
    },
    {
      '1': 'last_performed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastPerformedAt'
    },
    {
      '1': 'last_runtime_hours',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'lastRuntimeHours'
    },
  ],
};

/// Descriptor for `SchedulePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schedulePlanRequestDescriptor = $convert.base64Decode(
    'ChNTY2hlZHVsZVBsYW5SZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEjkKBWJhc2'
    'lzGAIgASgOMiMuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlBsYW5CYXNpc1IFYmFzaXMSIwoN'
    'aW50ZXJ2YWxfZGF5cxgDIAEoBVIMaW50ZXJ2YWxEYXlzEiMKDXJ1bnRpbWVfaG91cnMYBCABKA'
    'VSDHJ1bnRpbWVIb3VycxIcCglwcm9jZWR1cmUYBSABKAlSCXByb2NlZHVyZRIrChFlc3RpbWF0'
    'ZWRfbWludXRlcxgGIAEoBVIQZXN0aW1hdGVkTWludXRlcxJGChFsYXN0X3BlcmZvcm1lZF9hdB'
    'gHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSD2xhc3RQZXJmb3JtZWRBdBIsChJs'
    'YXN0X3J1bnRpbWVfaG91cnMYCCABKAVSEGxhc3RSdW50aW1lSG91cnM=');

@$core.Deprecated('Use schedulePlanResponseDescriptor instead')
const SchedulePlanResponse$json = {
  '1': 'SchedulePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.PMPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `SchedulePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schedulePlanResponseDescriptor = $convert.base64Decode(
    'ChRTY2hlZHVsZVBsYW5SZXNwb25zZRI0CgRwbGFuGAEgASgLMiAuaGVhbHRoY2FyZS5iaW9tZW'
    'RpY2FsLnYxLlBNUGxhblIEcGxhbg==');

@$core.Deprecated('Use retirePlanRequestDescriptor instead')
const RetirePlanRequest$json = {
  '1': 'RetirePlanRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RetirePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retirePlanRequestDescriptor = $convert.base64Decode(
    'ChFSZXRpcmVQbGFuUmVxdWVzdBIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSKQoQZXhwZWN0ZW'
    'RfdmVyc2lvbhgCIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use retirePlanResponseDescriptor instead')
const RetirePlanResponse$json = {
  '1': 'RetirePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.PMPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `RetirePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retirePlanResponseDescriptor = $convert.base64Decode(
    'ChJSZXRpcmVQbGFuUmVzcG9uc2USNAoEcGxhbhgBIAEoCzIgLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5QTVBsYW5SBHBsYW4=');

@$core.Deprecated('Use listPlansRequestDescriptor instead')
const ListPlansRequest$json = {
  '1': 'ListPlansRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlansRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UGxhbnNSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEh8KC2FjdGl2ZV'
    '9vbmx5GAIgASgIUgphY3RpdmVPbmx5EhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listPlansResponseDescriptor instead')
const ListPlansResponse$json = {
  '1': 'ListPlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.PMPlan',
      '10': 'plans'
    },
  ],
};

/// Descriptor for `ListPlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPlansResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UGxhbnNSZXNwb25zZRI2CgVwbGFucxgBIAMoCzIgLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5QTVBsYW5SBXBsYW5z');

@$core.Deprecated('Use dueDescriptor instead')
const Due$json = {
  '1': 'Due',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 3, '4': 1, '5': 9, '10': 'assetTag'},
    {
      '1': 'basis',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.PlanBasis',
      '10': 'basis'
    },
    {'1': 'procedure', '3': 5, '4': 1, '5': 9, '10': 'procedure'},
    {
      '1': 'criticality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Criticality',
      '10': 'criticality'
    },
    {
      '1': 'state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.DueState',
      '10': 'state'
    },
    {
      '1': 'due_on',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueOn'
    },
    {'1': 'days_overdue', '3': 9, '4': 1, '5': 5, '10': 'daysOverdue'},
    {'1': 'hours_remaining', '3': 10, '4': 1, '5': 5, '10': 'hoursRemaining'},
    {'1': 'unanswerable', '3': 11, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `Due`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueDescriptor = $convert.base64Decode(
    'CgNEdWUSFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldE'
    'lkEhsKCWFzc2V0X3RhZxgDIAEoCVIIYXNzZXRUYWcSOQoFYmFzaXMYBCABKA4yIy5oZWFsdGhj'
    'YXJlLmJpb21lZGljYWwudjEuUGxhbkJhc2lzUgViYXNpcxIcCglwcm9jZWR1cmUYBSABKAlSCX'
    'Byb2NlZHVyZRJHCgtjcml0aWNhbGl0eRgGIAEoDjIlLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52'
    'MS5Dcml0aWNhbGl0eVILY3JpdGljYWxpdHkSOAoFc3RhdGUYByABKA4yIi5oZWFsdGhjYXJlLm'
    'Jpb21lZGljYWwudjEuRHVlU3RhdGVSBXN0YXRlEjEKBmR1ZV9vbhgIIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSBWR1ZU9uEiEKDGRheXNfb3ZlcmR1ZRgJIAEoBVILZGF5c092ZX'
    'JkdWUSJwoPaG91cnNfcmVtYWluaW5nGAogASgFUg5ob3Vyc1JlbWFpbmluZxIiCgx1bmFuc3dl'
    'cmFibGUYCyABKAhSDHVuYW5zd2VyYWJsZQ==');

@$core.Deprecated('Use listDueMaintenanceRequestDescriptor instead')
const ListDueMaintenanceRequest$json = {
  '1': 'ListDueMaintenanceRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDueMaintenanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueMaintenanceRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RHVlTWFpbnRlbmFuY2VSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpem'
        'U=');

@$core.Deprecated('Use listDueMaintenanceResponseDescriptor instead')
const ListDueMaintenanceResponse$json = {
  '1': 'ListDueMaintenanceResponse',
  '2': [
    {
      '1': 'due',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Due',
      '10': 'due'
    },
  ],
};

/// Descriptor for `ListDueMaintenanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueMaintenanceResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RHVlTWFpbnRlbmFuY2VSZXNwb25zZRIvCgNkdWUYASADKAsyHS5oZWFsdGhjYXJlLm'
        'Jpb21lZGljYWwudjEuRHVlUgNkdWU=');

@$core.Deprecated('Use partUsedDescriptor instead')
const PartUsed$json = {
  '1': 'PartUsed',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'materials_item_id', '3': 3, '4': 1, '5': 9, '10': 'materialsItemId'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'cost_minor', '3': 5, '4': 1, '5': 3, '10': 'costMinor'},
    {
      '1': 'covered_by_contract',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'coveredByContract'
    },
  ],
};

/// Descriptor for `PartUsed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List partUsedDescriptor = $convert.base64Decode(
    'CghQYXJ0VXNlZBISCgRjb2RlGAEgASgJUgRjb2RlEiAKC2Rlc2NyaXB0aW9uGAIgASgJUgtkZX'
    'NjcmlwdGlvbhIqChFtYXRlcmlhbHNfaXRlbV9pZBgDIAEoCVIPbWF0ZXJpYWxzSXRlbUlkEhoK'
    'CHF1YW50aXR5GAQgASgFUghxdWFudGl0eRIdCgpjb3N0X21pbm9yGAUgASgDUgljb3N0TWlub3'
    'ISLgoTY292ZXJlZF9ieV9jb250cmFjdBgGIAEoCFIRY292ZXJlZEJ5Q29udHJhY3Q=');

@$core.Deprecated('Use ticketDescriptor instead')
const Ticket$json = {
  '1': 'Ticket',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TicketKind',
      '10': 'kind'
    },
    {'1': 'asset_id', '3': 4, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'plan_id', '3': 5, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'asset_tag', '3': 6, '4': 1, '5': 9, '10': 'assetTag'},
    {'1': 'location_id', '3': 7, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'symptom', '3': 8, '4': 1, '5': 9, '10': 'symptom'},
    {
      '1': 'priority',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'impact',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Impact',
      '10': 'impact'
    },
    {
      '1': 'state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TicketState',
      '10': 'state'
    },
    {'1': 'owner_id', '3': 12, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'respond_by',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondBy'
    },
    {
      '1': 'resolve_by',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolveBy'
    },
    {'1': 'contract_id', '3': 15, '4': 1, '5': 9, '10': 'contractId'},
    {'1': 'diagnosis', '3': 16, '4': 1, '5': 9, '10': 'diagnosis'},
    {'1': 'work_performed', '3': 17, '4': 1, '5': 9, '10': 'workPerformed'},
    {
      '1': 'parts',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.PartUsed',
      '10': 'parts'
    },
    {
      '1': 'down_from',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'downFrom'
    },
    {
      '1': 'down_until',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'downUntil'
    },
    {
      '1': 'awaiting_parts_minutes',
      '3': 21,
      '4': 1,
      '5': 5,
      '10': 'awaitingPartsMinutes'
    },
    {
      '1': 'responded_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondedAt'
    },
    {
      '1': 'resolved_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {
      '1': 'closed_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 25, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closure_note', '3': 26, '4': 1, '5': 9, '10': 'closureNote'},
    {'1': 'cancelled_reason', '3': 27, '4': 1, '5': 9, '10': 'cancelledReason'},
    {
      '1': 'raised_at',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 29, '4': 1, '5': 9, '10': 'raisedBy'},
    {'1': 'version', '3': 30, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Ticket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ticketDescriptor = $convert.base64Decode(
    'CgZUaWNrZXQSGwoJdGlja2V0X2lkGAEgASgJUgh0aWNrZXRJZBIWCgZudW1iZXIYAiABKAlSBm'
    '51bWJlchI4CgRraW5kGAMgASgOMiQuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlRpY2tldEtp'
    'bmRSBGtpbmQSGQoIYXNzZXRfaWQYBCABKAlSB2Fzc2V0SWQSFwoHcGxhbl9pZBgFIAEoCVIGcG'
    'xhbklkEhsKCWFzc2V0X3RhZxgGIAEoCVIIYXNzZXRUYWcSHwoLbG9jYXRpb25faWQYByABKAlS'
    'CmxvY2F0aW9uSWQSGAoHc3ltcHRvbRgIIAEoCVIHc3ltcHRvbRI+Cghwcmlvcml0eRgJIAEoDj'
    'IiLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Qcmlvcml0eVIIcHJpb3JpdHkSOAoGaW1wYWN0'
    'GAogASgOMiAuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkltcGFjdFIGaW1wYWN0EjsKBXN0YX'
    'RlGAsgASgOMiUuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlRpY2tldFN0YXRlUgVzdGF0ZRIZ'
    'Cghvd25lcl9pZBgMIAEoCVIHb3duZXJJZBI5CgpyZXNwb25kX2J5GA0gASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIJcmVzcG9uZEJ5EjkKCnJlc29sdmVfYnkYDiABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUglyZXNvbHZlQnkSHwoLY29udHJhY3RfaWQYDyABKAlSCm'
    'NvbnRyYWN0SWQSHAoJZGlhZ25vc2lzGBAgASgJUglkaWFnbm9zaXMSJQoOd29ya19wZXJmb3Jt'
    'ZWQYESABKAlSDXdvcmtQZXJmb3JtZWQSOAoFcGFydHMYEiADKAsyIi5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuUGFydFVzZWRSBXBhcnRzEjcKCWRvd25fZnJvbRgTIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCGRvd25Gcm9tEjkKCmRvd25fdW50aWwYFCABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUglkb3duVW50aWwSNAoWYXdhaXRpbmdfcGFydHNfbWludXRl'
    'cxgVIAEoBVIUYXdhaXRpbmdQYXJ0c01pbnV0ZXMSPQoMcmVzcG9uZGVkX2F0GBYgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVzcG9uZGVkQXQSOwoLcmVzb2x2ZWRfYXQYFyAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZXNvbHZlZEF0EjcKCWNsb3NlZF9hdB'
    'gYIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGNsb3NlZEF0EhsKCWNsb3NlZF9i'
    'eRgZIAEoCVIIY2xvc2VkQnkSIQoMY2xvc3VyZV9ub3RlGBogASgJUgtjbG9zdXJlTm90ZRIpCh'
    'BjYW5jZWxsZWRfcmVhc29uGBsgASgJUg9jYW5jZWxsZWRSZWFzb24SNwoJcmFpc2VkX2F0GBwg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmFpc2VkQXQSGwoJcmFpc2VkX2J5GB'
    '0gASgJUghyYWlzZWRCeRIYCgd2ZXJzaW9uGB4gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use raiseTicketRequestDescriptor instead')
const RaiseTicketRequest$json = {
  '1': 'RaiseTicketRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TicketKind',
      '10': 'kind'
    },
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'plan_id', '3': 3, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'symptom', '3': 4, '4': 1, '5': 9, '10': 'symptom'},
    {
      '1': 'priority',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Priority',
      '10': 'priority'
    },
    {
      '1': 'impact',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Impact',
      '10': 'impact'
    },
    {
      '1': 'down_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'downFrom'
    },
    {'1': 'number', '3': 8, '4': 1, '5': 9, '10': 'number'},
  ],
};

/// Descriptor for `RaiseTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseTicketRequestDescriptor = $convert.base64Decode(
    'ChJSYWlzZVRpY2tldFJlcXVlc3QSOAoEa2luZBgBIAEoDjIkLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5UaWNrZXRLaW5kUgRraW5kEhkKCGFzc2V0X2lkGAIgASgJUgdhc3NldElkEhcKB3Bs'
    'YW5faWQYAyABKAlSBnBsYW5JZBIYCgdzeW1wdG9tGAQgASgJUgdzeW1wdG9tEj4KCHByaW9yaX'
    'R5GAUgASgOMiIuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlByaW9yaXR5Ughwcmlvcml0eRI4'
    'CgZpbXBhY3QYBiABKA4yIC5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuSW1wYWN0UgZpbXBhY3'
    'QSNwoJZG93bl9mcm9tGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIZG93bkZy'
    'b20SFgoGbnVtYmVyGAggASgJUgZudW1iZXI=');

@$core.Deprecated('Use raiseTicketResponseDescriptor instead')
const RaiseTicketResponse$json = {
  '1': 'RaiseTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `RaiseTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseTicketResponseDescriptor = $convert.base64Decode(
    'ChNSYWlzZVRpY2tldFJlc3BvbnNlEjgKBnRpY2tldBgBIAEoCzIgLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5UaWNrZXRSBnRpY2tldA==');

@$core.Deprecated('Use getTicketRequestDescriptor instead')
const GetTicketRequest$json = {
  '1': 'GetTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
  ],
};

/// Descriptor for `GetTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTicketRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUaWNrZXRSZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQ=');

@$core.Deprecated('Use getTicketResponseDescriptor instead')
const GetTicketResponse$json = {
  '1': 'GetTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `GetTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTicketResponseDescriptor = $convert.base64Decode(
    'ChFHZXRUaWNrZXRSZXNwb25zZRI4CgZ0aWNrZXQYASABKAsyIC5oZWFsdGhjYXJlLmJpb21lZG'
    'ljYWwudjEuVGlja2V0UgZ0aWNrZXQ=');

@$core.Deprecated('Use listTicketsRequestDescriptor instead')
const ListTicketsRequest$json = {
  '1': 'ListTicketsRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TicketState',
      '10': 'state'
    },
    {'1': 'open_only', '3': 3, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListTicketsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTicketsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0VGlja2V0c1JlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSOwoFc3RhdG'
    'UYAiABKA4yJS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuVGlja2V0U3RhdGVSBXN0YXRlEhsK'
    'CW9wZW5fb25seRgDIAEoCFIIb3Blbk9ubHkSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ'
    '==');

@$core.Deprecated('Use listTicketsResponseDescriptor instead')
const ListTicketsResponse$json = {
  '1': 'ListTicketsResponse',
  '2': [
    {
      '1': 'tickets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'tickets'
    },
  ],
};

/// Descriptor for `ListTicketsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTicketsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0VGlja2V0c1Jlc3BvbnNlEjoKB3RpY2tldHMYASADKAsyIC5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuVGlja2V0Ugd0aWNrZXRz');

@$core.Deprecated('Use assignTicketRequestDescriptor instead')
const AssignTicketRequest$json = {
  '1': 'AssignTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'owner_id', '3': 2, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `AssignTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignTicketRequestDescriptor = $convert.base64Decode(
    'ChNBc3NpZ25UaWNrZXRSZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQSGQoIb3'
    'duZXJfaWQYAiABKAlSB293bmVySWQSKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0'
    'ZWRWZXJzaW9u');

@$core.Deprecated('Use assignTicketResponseDescriptor instead')
const AssignTicketResponse$json = {
  '1': 'AssignTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `AssignTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignTicketResponseDescriptor = $convert.base64Decode(
    'ChRBc3NpZ25UaWNrZXRSZXNwb25zZRI4CgZ0aWNrZXQYASABKAsyIC5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuVGlja2V0UgZ0aWNrZXQ=');

@$core.Deprecated('Use startTicketRequestDescriptor instead')
const StartTicketRequest$json = {
  '1': 'StartTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `StartTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTicketRequestDescriptor = $convert.base64Decode(
    'ChJTdGFydFRpY2tldFJlcXVlc3QSGwoJdGlja2V0X2lkGAEgASgJUgh0aWNrZXRJZBIpChBleH'
    'BlY3RlZF92ZXJzaW9uGAIgASgDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use startTicketResponseDescriptor instead')
const StartTicketResponse$json = {
  '1': 'StartTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `StartTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTicketResponseDescriptor = $convert.base64Decode(
    'ChNTdGFydFRpY2tldFJlc3BvbnNlEjgKBnRpY2tldBgBIAEoCzIgLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5UaWNrZXRSBnRpY2tldA==');

@$core.Deprecated('Use awaitPartsRequestDescriptor instead')
const AwaitPartsRequest$json = {
  '1': 'AwaitPartsRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `AwaitPartsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List awaitPartsRequestDescriptor = $convert.base64Decode(
    'ChFBd2FpdFBhcnRzUmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEhIKBG5vdG'
    'UYAiABKAlSBG5vdGUSKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use awaitPartsResponseDescriptor instead')
const AwaitPartsResponse$json = {
  '1': 'AwaitPartsResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `AwaitPartsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List awaitPartsResponseDescriptor = $convert.base64Decode(
    'ChJBd2FpdFBhcnRzUmVzcG9uc2USOAoGdGlja2V0GAEgASgLMiAuaGVhbHRoY2FyZS5iaW9tZW'
    'RpY2FsLnYxLlRpY2tldFIGdGlja2V0');

@$core.Deprecated('Use cancelTicketRequestDescriptor instead')
const CancelTicketRequest$json = {
  '1': 'CancelTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CancelTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTicketRequestDescriptor = $convert.base64Decode(
    'ChNDYW5jZWxUaWNrZXRSZXF1ZXN0EhsKCXRpY2tldF9pZBgBIAEoCVIIdGlja2V0SWQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24SKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0ZWRW'
    'ZXJzaW9u');

@$core.Deprecated('Use cancelTicketResponseDescriptor instead')
const CancelTicketResponse$json = {
  '1': 'CancelTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `CancelTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTicketResponseDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxUaWNrZXRSZXNwb25zZRI4CgZ0aWNrZXQYASABKAsyIC5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuVGlja2V0UgZ0aWNrZXQ=');

@$core.Deprecated('Use resolveTicketRequestDescriptor instead')
const ResolveTicketRequest$json = {
  '1': 'ResolveTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'diagnosis', '3': 2, '4': 1, '5': 9, '10': 'diagnosis'},
    {'1': 'work_performed', '3': 3, '4': 1, '5': 9, '10': 'workPerformed'},
    {
      '1': 'parts',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.PartUsed',
      '10': 'parts'
    },
    {
      '1': 'back_in_service_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'backInServiceAt'
    },
    {'1': 'expected_version', '3': 6, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ResolveTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveTicketRequestDescriptor = $convert.base64Decode(
    'ChRSZXNvbHZlVGlja2V0UmVxdWVzdBIbCgl0aWNrZXRfaWQYASABKAlSCHRpY2tldElkEhwKCW'
    'RpYWdub3NpcxgCIAEoCVIJZGlhZ25vc2lzEiUKDndvcmtfcGVyZm9ybWVkGAMgASgJUg13b3Jr'
    'UGVyZm9ybWVkEjgKBXBhcnRzGAQgAygLMiIuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlBhcn'
    'RVc2VkUgVwYXJ0cxJHChJiYWNrX2luX3NlcnZpY2VfYXQYBSABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUg9iYWNrSW5TZXJ2aWNlQXQSKQoQZXhwZWN0ZWRfdmVyc2lvbhgGIAEoA1'
    'IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use resolveTicketResponseDescriptor instead')
const ResolveTicketResponse$json = {
  '1': 'ResolveTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `ResolveTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveTicketResponseDescriptor = $convert.base64Decode(
    'ChVSZXNvbHZlVGlja2V0UmVzcG9uc2USOAoGdGlja2V0GAEgASgLMiAuaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLlRpY2tldFIGdGlja2V0');

@$core.Deprecated('Use closeTicketRequestDescriptor instead')
const CloseTicketRequest$json = {
  '1': 'CloseTicketRequest',
  '2': [
    {'1': 'ticket_id', '3': 1, '4': 1, '5': 9, '10': 'ticketId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CloseTicketRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeTicketRequestDescriptor = $convert.base64Decode(
    'ChJDbG9zZVRpY2tldFJlcXVlc3QSGwoJdGlja2V0X2lkGAEgASgJUgh0aWNrZXRJZBISCgRub3'
    'RlGAIgASgJUgRub3RlEikKEGV4cGVjdGVkX3ZlcnNpb24YAyABKANSD2V4cGVjdGVkVmVyc2lv'
    'bg==');

@$core.Deprecated('Use closeTicketResponseDescriptor instead')
const CloseTicketResponse$json = {
  '1': 'CloseTicketResponse',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
  ],
};

/// Descriptor for `CloseTicketResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeTicketResponseDescriptor = $convert.base64Decode(
    'ChNDbG9zZVRpY2tldFJlc3BvbnNlEjgKBnRpY2tldBgBIAEoCzIgLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5UaWNrZXRSBnRpY2tldA==');

@$core.Deprecated('Use breachDescriptor instead')
const Breach$json = {
  '1': 'Breach',
  '2': [
    {
      '1': 'ticket',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Ticket',
      '10': 'ticket'
    },
    {
      '1': 'response_breached',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'responseBreached'
    },
    {
      '1': 'resolution_breached',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'resolutionBreached'
    },
  ],
};

/// Descriptor for `Breach`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List breachDescriptor = $convert.base64Decode(
    'CgZCcmVhY2gSOAoGdGlja2V0GAEgASgLMiAuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlRpY2'
    'tldFIGdGlja2V0EisKEXJlc3BvbnNlX2JyZWFjaGVkGAIgASgIUhByZXNwb25zZUJyZWFjaGVk'
    'Ei8KE3Jlc29sdXRpb25fYnJlYWNoZWQYAyABKAhSEnJlc29sdXRpb25CcmVhY2hlZA==');

@$core.Deprecated('Use listBreachesRequestDescriptor instead')
const ListBreachesRequest$json = {
  '1': 'ListBreachesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListBreachesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBreachesRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0QnJlYWNoZXNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listBreachesResponseDescriptor instead')
const ListBreachesResponse$json = {
  '1': 'ListBreachesResponse',
  '2': [
    {
      '1': 'breaches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Breach',
      '10': 'breaches'
    },
  ],
};

/// Descriptor for `ListBreachesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBreachesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QnJlYWNoZXNSZXNwb25zZRI8CghicmVhY2hlcxgBIAMoCzIgLmhlYWx0aGNhcmUuYm'
    'lvbWVkaWNhbC52MS5CcmVhY2hSCGJyZWFjaGVz');

@$core.Deprecated('Use safetyNoticeDescriptor instead')
const SafetyNotice$json = {
  '1': 'SafetyNotice',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.NoticeKind',
      '10': 'kind'
    },
    {'1': 'issuer', '3': 4, '4': 1, '5': 9, '10': 'issuer'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'make', '3': 6, '4': 1, '5': 9, '10': 'make'},
    {'1': 'model', '3': 7, '4': 1, '5': 9, '10': 'model'},
    {'1': 'serial_from', '3': 8, '4': 1, '5': 9, '10': 'serialFrom'},
    {'1': 'serial_to', '3': 9, '4': 1, '5': 9, '10': 'serialTo'},
    {'1': 'affected_udi', '3': 10, '4': 1, '5': 9, '10': 'affectedUdi'},
    {'1': 'hold_affected', '3': 11, '4': 1, '5': 8, '10': 'holdAffected'},
    {'1': 'required_action', '3': 12, '4': 1, '5': 9, '10': 'requiredAction'},
    {
      '1': 'due_by',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'issued_on',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedOn'
    },
    {
      '1': 'raised_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 16, '4': 1, '5': 9, '10': 'raisedBy'},
    {
      '1': 'closed_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 18, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closure_note', '3': 19, '4': 1, '5': 9, '10': 'closureNote'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SafetyNotice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List safetyNoticeDescriptor = $convert.base64Decode(
    'CgxTYWZldHlOb3RpY2USGwoJbm90aWNlX2lkGAEgASgJUghub3RpY2VJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRI4CgRraW5kGAMgASgOMiQuaGVhbHRoY2FyZS5iaW9tZWRpY2Fs'
    'LnYxLk5vdGljZUtpbmRSBGtpbmQSFgoGaXNzdWVyGAQgASgJUgZpc3N1ZXISGAoHc3VtbWFyeR'
    'gFIAEoCVIHc3VtbWFyeRISCgRtYWtlGAYgASgJUgRtYWtlEhQKBW1vZGVsGAcgASgJUgVtb2Rl'
    'bBIfCgtzZXJpYWxfZnJvbRgIIAEoCVIKc2VyaWFsRnJvbRIbCglzZXJpYWxfdG8YCSABKAlSCH'
    'NlcmlhbFRvEiEKDGFmZmVjdGVkX3VkaRgKIAEoCVILYWZmZWN0ZWRVZGkSIwoNaG9sZF9hZmZl'
    'Y3RlZBgLIAEoCFIMaG9sZEFmZmVjdGVkEicKD3JlcXVpcmVkX2FjdGlvbhgMIAEoCVIOcmVxdW'
    'lyZWRBY3Rpb24SMQoGZHVlX2J5GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIF'
    'ZHVlQnkSNwoJaXNzdWVkX29uGA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIaX'
    'NzdWVkT24SNwoJcmFpc2VkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFII'
    'cmFpc2VkQXQSGwoJcmFpc2VkX2J5GBAgASgJUghyYWlzZWRCeRI3CgljbG9zZWRfYXQYESABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghjbG9zZWRBdBIbCgljbG9zZWRfYnkYEiAB'
    'KAlSCGNsb3NlZEJ5EiEKDGNsb3N1cmVfbm90ZRgTIAEoCVILY2xvc3VyZU5vdGUSGAoHdmVyc2'
    'lvbhgUIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use noticeTaskDescriptor instead')
const NoticeTask$json = {
  '1': 'NoticeTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'notice_id', '3': 2, '4': 1, '5': 9, '10': 'noticeId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 4, '4': 1, '5': 9, '10': 'assetTag'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TaskState',
      '10': 'state'
    },
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'completed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'completed_by', '3': 8, '4': 1, '5': 9, '10': 'completedBy'},
  ],
};

/// Descriptor for `NoticeTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List noticeTaskDescriptor = $convert.base64Decode(
    'CgpOb3RpY2VUYXNrEhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIbCglub3RpY2VfaWQYAiABKA'
    'lSCG5vdGljZUlkEhkKCGFzc2V0X2lkGAMgASgJUgdhc3NldElkEhsKCWFzc2V0X3RhZxgEIAEo'
    'CVIIYXNzZXRUYWcSOQoFc3RhdGUYBSABKA4yIy5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuVG'
    'Fza1N0YXRlUgVzdGF0ZRISCgRub3RlGAYgASgJUgRub3RlEj0KDGNvbXBsZXRlZF9hdBgHIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbXBsZXRlZEF0EiEKDGNvbXBsZXRlZF'
    '9ieRgIIAEoCVILY29tcGxldGVkQnk=');

@$core.Deprecated('Use raiseNoticeRequestDescriptor instead')
const RaiseNoticeRequest$json = {
  '1': 'RaiseNoticeRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.NoticeKind',
      '10': 'kind'
    },
    {'1': 'issuer', '3': 3, '4': 1, '5': 9, '10': 'issuer'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'make', '3': 5, '4': 1, '5': 9, '10': 'make'},
    {'1': 'model', '3': 6, '4': 1, '5': 9, '10': 'model'},
    {'1': 'serial_from', '3': 7, '4': 1, '5': 9, '10': 'serialFrom'},
    {'1': 'serial_to', '3': 8, '4': 1, '5': 9, '10': 'serialTo'},
    {'1': 'affected_udi', '3': 9, '4': 1, '5': 9, '10': 'affectedUdi'},
    {'1': 'hold_affected', '3': 10, '4': 1, '5': 8, '10': 'holdAffected'},
    {'1': 'required_action', '3': 11, '4': 1, '5': 9, '10': 'requiredAction'},
    {
      '1': 'due_by',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'issued_on',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedOn'
    },
  ],
};

/// Descriptor for `RaiseNoticeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseNoticeRequestDescriptor = $convert.base64Decode(
    'ChJSYWlzZU5vdGljZVJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USOAoEa2'
    'luZBgCIAEoDjIkLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Ob3RpY2VLaW5kUgRraW5kEhYK'
    'Bmlzc3VlchgDIAEoCVIGaXNzdWVyEhgKB3N1bW1hcnkYBCABKAlSB3N1bW1hcnkSEgoEbWFrZR'
    'gFIAEoCVIEbWFrZRIUCgVtb2RlbBgGIAEoCVIFbW9kZWwSHwoLc2VyaWFsX2Zyb20YByABKAlS'
    'CnNlcmlhbEZyb20SGwoJc2VyaWFsX3RvGAggASgJUghzZXJpYWxUbxIhCgxhZmZlY3RlZF91ZG'
    'kYCSABKAlSC2FmZmVjdGVkVWRpEiMKDWhvbGRfYWZmZWN0ZWQYCiABKAhSDGhvbGRBZmZlY3Rl'
    'ZBInCg9yZXF1aXJlZF9hY3Rpb24YCyABKAlSDnJlcXVpcmVkQWN0aW9uEjEKBmR1ZV9ieRgMIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5EjcKCWlzc3VlZF9vbhgNIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGlzc3VlZE9u');

@$core.Deprecated('Use raiseNoticeResponseDescriptor instead')
const RaiseNoticeResponse$json = {
  '1': 'RaiseNoticeResponse',
  '2': [
    {
      '1': 'notice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.SafetyNotice',
      '10': 'notice'
    },
    {
      '1': 'tasks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.NoticeTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `RaiseNoticeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseNoticeResponseDescriptor = $convert.base64Decode(
    'ChNSYWlzZU5vdGljZVJlc3BvbnNlEj4KBm5vdGljZRgBIAEoCzImLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5TYWZldHlOb3RpY2VSBm5vdGljZRI6CgV0YXNrcxgCIAMoCzIkLmhlYWx0aGNh'
    'cmUuYmlvbWVkaWNhbC52MS5Ob3RpY2VUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use getNoticeRequestDescriptor instead')
const GetNoticeRequest$json = {
  '1': 'GetNoticeRequest',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
  ],
};

/// Descriptor for `GetNoticeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNoticeRequestDescriptor = $convert.base64Decode(
    'ChBHZXROb3RpY2VSZXF1ZXN0EhsKCW5vdGljZV9pZBgBIAEoCVIIbm90aWNlSWQ=');

@$core.Deprecated('Use getNoticeResponseDescriptor instead')
const GetNoticeResponse$json = {
  '1': 'GetNoticeResponse',
  '2': [
    {
      '1': 'notice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.SafetyNotice',
      '10': 'notice'
    },
  ],
};

/// Descriptor for `GetNoticeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNoticeResponseDescriptor = $convert.base64Decode(
    'ChFHZXROb3RpY2VSZXNwb25zZRI+CgZub3RpY2UYASABKAsyJi5oZWFsdGhjYXJlLmJpb21lZG'
    'ljYWwudjEuU2FmZXR5Tm90aWNlUgZub3RpY2U=');

@$core.Deprecated('Use listNoticesRequestDescriptor instead')
const ListNoticesRequest$json = {
  '1': 'ListNoticesRequest',
  '2': [
    {'1': 'open_only', '3': 1, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListNoticesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNoticesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0Tm90aWNlc1JlcXVlc3QSGwoJb3Blbl9vbmx5GAEgASgIUghvcGVuT25seRIbCglwYW'
    'dlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listNoticesResponseDescriptor instead')
const ListNoticesResponse$json = {
  '1': 'ListNoticesResponse',
  '2': [
    {
      '1': 'notices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.SafetyNotice',
      '10': 'notices'
    },
  ],
};

/// Descriptor for `ListNoticesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNoticesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Tm90aWNlc1Jlc3BvbnNlEkAKB25vdGljZXMYASADKAsyJi5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuU2FmZXR5Tm90aWNlUgdub3RpY2Vz');

@$core.Deprecated('Use listNoticeTasksRequestDescriptor instead')
const ListNoticeTasksRequest$json = {
  '1': 'ListNoticeTasksRequest',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
  ],
};

/// Descriptor for `ListNoticeTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNoticeTasksRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Tm90aWNlVGFza3NSZXF1ZXN0EhsKCW5vdGljZV9pZBgBIAEoCVIIbm90aWNlSWQ=');

@$core.Deprecated('Use listNoticeTasksResponseDescriptor instead')
const ListNoticeTasksResponse$json = {
  '1': 'ListNoticeTasksResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.NoticeTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `ListNoticeTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNoticeTasksResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0Tm90aWNlVGFza3NSZXNwb25zZRI6CgV0YXNrcxgBIAMoCzIkLmhlYWx0aGNhcmUuYm'
        'lvbWVkaWNhbC52MS5Ob3RpY2VUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use advanceTaskRequestDescriptor instead')
const AdvanceTaskRequest$json = {
  '1': 'AdvanceTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.TaskState',
      '10': 'state'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'release_hold', '3': 4, '4': 1, '5': 8, '10': 'releaseHold'},
  ],
};

/// Descriptor for `AdvanceTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceTaskRequestDescriptor = $convert.base64Decode(
    'ChJBZHZhbmNlVGFza1JlcXVlc3QSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEjkKBXN0YXRlGA'
    'IgASgOMiMuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlRhc2tTdGF0ZVIFc3RhdGUSEgoEbm90'
    'ZRgDIAEoCVIEbm90ZRIhCgxyZWxlYXNlX2hvbGQYBCABKAhSC3JlbGVhc2VIb2xk');

@$core.Deprecated('Use advanceTaskResponseDescriptor instead')
const AdvanceTaskResponse$json = {
  '1': 'AdvanceTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.NoticeTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `AdvanceTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceTaskResponseDescriptor = $convert.base64Decode(
    'ChNBZHZhbmNlVGFza1Jlc3BvbnNlEjgKBHRhc2sYASABKAsyJC5oZWFsdGhjYXJlLmJpb21lZG'
    'ljYWwudjEuTm90aWNlVGFza1IEdGFzaw==');

@$core.Deprecated('Use trackNoticeRequestDescriptor instead')
const TrackNoticeRequest$json = {
  '1': 'TrackNoticeRequest',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
  ],
};

/// Descriptor for `TrackNoticeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackNoticeRequestDescriptor =
    $convert.base64Decode(
        'ChJUcmFja05vdGljZVJlcXVlc3QSGwoJbm90aWNlX2lkGAEgASgJUghub3RpY2VJZA==');

@$core.Deprecated('Use trackNoticeResponseDescriptor instead')
const TrackNoticeResponse$json = {
  '1': 'TrackNoticeResponse',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {'1': 'outstanding', '3': 3, '4': 1, '5': 5, '10': 'outstanding'},
    {'1': 'inspected', '3': 4, '4': 1, '5': 5, '10': 'inspected'},
    {'1': 'complete', '3': 5, '4': 1, '5': 5, '10': 'complete'},
    {'1': 'overdue', '3': 6, '4': 1, '5': 8, '10': 'overdue'},
  ],
};

/// Descriptor for `TrackNoticeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trackNoticeResponseDescriptor = $convert.base64Decode(
    'ChNUcmFja05vdGljZVJlc3BvbnNlEhsKCW5vdGljZV9pZBgBIAEoCVIIbm90aWNlSWQSFAoFdG'
    '90YWwYAiABKAVSBXRvdGFsEiAKC291dHN0YW5kaW5nGAMgASgFUgtvdXRzdGFuZGluZxIcCglp'
    'bnNwZWN0ZWQYBCABKAVSCWluc3BlY3RlZBIaCghjb21wbGV0ZRgFIAEoBVIIY29tcGxldGUSGA'
    'oHb3ZlcmR1ZRgGIAEoCFIHb3ZlcmR1ZQ==');

@$core.Deprecated('Use closeNoticeRequestDescriptor instead')
const CloseNoticeRequest$json = {
  '1': 'CloseNoticeRequest',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CloseNoticeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeNoticeRequestDescriptor = $convert.base64Decode(
    'ChJDbG9zZU5vdGljZVJlcXVlc3QSGwoJbm90aWNlX2lkGAEgASgJUghub3RpY2VJZBISCgRub3'
    'RlGAIgASgJUgRub3RlEikKEGV4cGVjdGVkX3ZlcnNpb24YAyABKANSD2V4cGVjdGVkVmVyc2lv'
    'bg==');

@$core.Deprecated('Use closeNoticeResponseDescriptor instead')
const CloseNoticeResponse$json = {
  '1': 'CloseNoticeResponse',
  '2': [
    {
      '1': 'notice',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.SafetyNotice',
      '10': 'notice'
    },
  ],
};

/// Descriptor for `CloseNoticeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeNoticeResponseDescriptor = $convert.base64Decode(
    'ChNDbG9zZU5vdGljZVJlc3BvbnNlEj4KBm5vdGljZRgBIAEoCzImLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5TYWZldHlOb3RpY2VSBm5vdGljZQ==');

@$core.Deprecated('Use readingDescriptor instead')
const Reading$json = {
  '1': 'Reading',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'metric', '3': 3, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'value', '3': 4, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'source', '3': 6, '4': 1, '5': 9, '10': 'source'},
    {'1': 'ingested', '3': 7, '4': 1, '5': 8, '10': 'ingested'},
    {
      '1': 'observed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {
      '1': 'recorded_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 10, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Reading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readingDescriptor = $convert.base64Decode(
    'CgdSZWFkaW5nEh0KCnJlYWRpbmdfaWQYASABKAlSCXJlYWRpbmdJZBIZCghhc3NldF9pZBgCIA'
    'EoCVIHYXNzZXRJZBIWCgZtZXRyaWMYAyABKAlSBm1ldHJpYxIUCgV2YWx1ZRgEIAEoAVIFdmFs'
    'dWUSEgoEdW5pdBgFIAEoCVIEdW5pdBIWCgZzb3VyY2UYBiABKAlSBnNvdXJjZRIaCghpbmdlc3'
    'RlZBgHIAEoCFIIaW5nZXN0ZWQSOwoLb2JzZXJ2ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0EjsKC3JlY29yZGVkX2F0GAkgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdBIfCgtyZWNvcmRlZF9ieRgKIAEoCVIKcmVj'
    'b3JkZWRCeQ==');

@$core.Deprecated('Use newReadingDescriptor instead')
const NewReading$json = {
  '1': 'NewReading',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'metric', '3': 2, '4': 1, '5': 9, '10': 'metric'},
    {'1': 'value', '3': 3, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
    {'1': 'ingested', '3': 6, '4': 1, '5': 8, '10': 'ingested'},
    {
      '1': 'observed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
};

/// Descriptor for `NewReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List newReadingDescriptor = $convert.base64Decode(
    'CgpOZXdSZWFkaW5nEhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhYKBm1ldHJpYxgCIAEoCV'
    'IGbWV0cmljEhQKBXZhbHVlGAMgASgBUgV2YWx1ZRISCgR1bml0GAQgASgJUgR1bml0EhYKBnNv'
    'dXJjZRgFIAEoCVIGc291cmNlEhoKCGluZ2VzdGVkGAYgASgIUghpbmdlc3RlZBI7CgtvYnNlcn'
    'ZlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9ic2VydmVkQXQ=');

@$core.Deprecated('Use appendReadingsRequestDescriptor instead')
const AppendReadingsRequest$json = {
  '1': 'AppendReadingsRequest',
  '2': [
    {
      '1': 'readings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.NewReading',
      '10': 'readings'
    },
  ],
};

/// Descriptor for `AppendReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appendReadingsRequestDescriptor = $convert.base64Decode(
    'ChVBcHBlbmRSZWFkaW5nc1JlcXVlc3QSQAoIcmVhZGluZ3MYASADKAsyJC5oZWFsdGhjYXJlLm'
    'Jpb21lZGljYWwudjEuTmV3UmVhZGluZ1IIcmVhZGluZ3M=');

@$core.Deprecated('Use appendReadingsResponseDescriptor instead')
const AppendReadingsResponse$json = {
  '1': 'AppendReadingsResponse',
  '2': [
    {
      '1': 'readings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Reading',
      '10': 'readings'
    },
  ],
};

/// Descriptor for `AppendReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appendReadingsResponseDescriptor =
    $convert.base64Decode(
        'ChZBcHBlbmRSZWFkaW5nc1Jlc3BvbnNlEj0KCHJlYWRpbmdzGAEgAygLMiEuaGVhbHRoY2FyZS'
        '5iaW9tZWRpY2FsLnYxLlJlYWRpbmdSCHJlYWRpbmdz');

@$core.Deprecated('Use listReadingsRequestDescriptor instead')
const ListReadingsRequest$json = {
  '1': 'ListReadingsRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'metric', '3': 2, '4': 1, '5': 9, '10': 'metric'},
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

/// Descriptor for `ListReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadingsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVhZGluZ3NSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhYKBm1ldH'
    'JpYxgCIAEoCVIGbWV0cmljEi4KBGZyb20YAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgRmcm9tEioKAnRvGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGw'
    'oJcGFnZV9zaXplGAUgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listReadingsResponseDescriptor instead')
const ListReadingsResponse$json = {
  '1': 'ListReadingsResponse',
  '2': [
    {
      '1': 'readings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Reading',
      '10': 'readings'
    },
  ],
};

/// Descriptor for `ListReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadingsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVhZGluZ3NSZXNwb25zZRI9CghyZWFkaW5ncxgBIAMoCzIhLmhlYWx0aGNhcmUuYm'
    'lvbWVkaWNhbC52MS5SZWFkaW5nUghyZWFkaW5ncw==');

@$core.Deprecated('Use metricsDescriptor instead')
const Metrics$json = {
  '1': 'Metrics',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 2, '4': 1, '5': 9, '10': 'assetTag'},
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
    {'1': 'period_minutes', '3': 5, '4': 1, '5': 5, '10': 'periodMinutes'},
    {'1': 'downtime_minutes', '3': 6, '4': 1, '5': 5, '10': 'downtimeMinutes'},
    {'1': 'uptime_minutes', '3': 7, '4': 1, '5': 5, '10': 'uptimeMinutes'},
    {'1': 'uptime_percent', '3': 8, '4': 1, '5': 1, '10': 'uptimePercent'},
    {'1': 'failures', '3': 9, '4': 1, '5': 5, '10': 'failures'},
    {
      '1': 'planned_downtime_minutes',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'plannedDowntimeMinutes'
    },
    {'1': 'mtbf_hours', '3': 11, '4': 1, '5': 1, '10': 'mtbfHours'},
    {'1': 'mttr_hours', '3': 12, '4': 1, '5': 1, '10': 'mttrHours'},
    {'1': 'pm_due', '3': 13, '4': 1, '5': 5, '10': 'pmDue'},
    {'1': 'pm_done', '3': 14, '4': 1, '5': 5, '10': 'pmDone'},
    {'1': 'pm_compliance', '3': 15, '4': 1, '5': 1, '10': 'pmCompliance'},
    {'1': 'incomplete', '3': 16, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `Metrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List metricsDescriptor = $convert.base64Decode(
    'CgdNZXRyaWNzEhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhsKCWFzc2V0X3RhZxgCIAEoCV'
    'IIYXNzZXRUYWcSLgoEZnJvbRgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZy'
    'b20SKgoCdG8YBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bxIlCg5wZXJpb2'
    'RfbWludXRlcxgFIAEoBVINcGVyaW9kTWludXRlcxIpChBkb3dudGltZV9taW51dGVzGAYgASgF'
    'Ug9kb3dudGltZU1pbnV0ZXMSJQoOdXB0aW1lX21pbnV0ZXMYByABKAVSDXVwdGltZU1pbnV0ZX'
    'MSJQoOdXB0aW1lX3BlcmNlbnQYCCABKAFSDXVwdGltZVBlcmNlbnQSGgoIZmFpbHVyZXMYCSAB'
    'KAVSCGZhaWx1cmVzEjgKGHBsYW5uZWRfZG93bnRpbWVfbWludXRlcxgKIAEoBVIWcGxhbm5lZE'
    'Rvd250aW1lTWludXRlcxIdCgptdGJmX2hvdXJzGAsgASgBUgltdGJmSG91cnMSHQoKbXR0cl9o'
    'b3VycxgMIAEoAVIJbXR0ckhvdXJzEhUKBnBtX2R1ZRgNIAEoBVIFcG1EdWUSFwoHcG1fZG9uZR'
    'gOIAEoBVIGcG1Eb25lEiMKDXBtX2NvbXBsaWFuY2UYDyABKAFSDHBtQ29tcGxpYW5jZRIeCgpp'
    'bmNvbXBsZXRlGBAgAygJUgppbmNvbXBsZXRl');

@$core.Deprecated('Use getAssetMetricsRequestDescriptor instead')
const GetAssetMetricsRequest$json = {
  '1': 'GetAssetMetricsRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `GetAssetMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetMetricsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRBc3NldE1ldHJpY3NSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEi4KBG'
    'Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAMgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getAssetMetricsResponseDescriptor instead')
const GetAssetMetricsResponse$json = {
  '1': 'GetAssetMetricsResponse',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Metrics',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `GetAssetMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetMetricsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRBc3NldE1ldHJpY3NSZXNwb25zZRI7CgdtZXRyaWNzGAEgASgLMiEuaGVhbHRoY2FyZS'
        '5iaW9tZWRpY2FsLnYxLk1ldHJpY3NSB21ldHJpY3M=');

@$core.Deprecated('Use fleetLineDescriptor instead')
const FleetLine$json = {
  '1': 'FleetLine',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 2, '4': 1, '5': 9, '10': 'assetTag'},
    {
      '1': 'criticality',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.biomedical.v1.Criticality',
      '10': 'criticality'
    },
    {
      '1': 'metrics',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Metrics',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `FleetLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fleetLineDescriptor = $convert.base64Decode(
    'CglGbGVldExpbmUSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSGwoJYXNzZXRfdGFnGAIgAS'
    'gJUghhc3NldFRhZxJHCgtjcml0aWNhbGl0eRgDIAEoDjIlLmhlYWx0aGNhcmUuYmlvbWVkaWNh'
    'bC52MS5Dcml0aWNhbGl0eVILY3JpdGljYWxpdHkSOwoHbWV0cmljcxgEIAEoCzIhLmhlYWx0aG'
    'NhcmUuYmlvbWVkaWNhbC52MS5NZXRyaWNzUgdtZXRyaWNz');

@$core.Deprecated('Use getFleetMetricsRequestDescriptor instead')
const GetFleetMetricsRequest$json = {
  '1': 'GetFleetMetricsRequest',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetFleetMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFleetMetricsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRGbGVldE1ldHJpY3NSZXF1ZXN0EhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRIuCg'
    'Rmcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgDIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcG'
    'FnZVNpemU=');

@$core.Deprecated('Use getFleetMetricsResponseDescriptor instead')
const GetFleetMetricsResponse$json = {
  '1': 'GetFleetMetricsResponse',
  '2': [
    {
      '1': 'lines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.FleetLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `GetFleetMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFleetMetricsResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRGbGVldE1ldHJpY3NSZXNwb25zZRI5CgVsaW5lcxgBIAMoCzIjLmhlYWx0aGNhcmUuYm'
        'lvbWVkaWNhbC52MS5GbGVldExpbmVSBWxpbmVz');

@$core.Deprecated('Use disposalDescriptor instead')
const Disposal$json = {
  '1': 'Disposal',
  '2': [
    {'1': 'disposal_id', '3': 1, '4': 1, '5': 9, '10': 'disposalId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'asset_tag', '3': 3, '4': 1, '5': 9, '10': 'assetTag'},
    {'1': 'method', '3': 4, '4': 1, '5': 9, '10': 'method'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'requested_by', '3': 6, '4': 1, '5': 9, '10': 'requestedBy'},
    {'1': 'approved_by', '3': 7, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'sanitisation_required',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'sanitisationRequired'
    },
    {
      '1': 'sanitisation_method',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'sanitisationMethod'
    },
    {
      '1': 'sanitisation_certificate',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'sanitisationCertificate'
    },
    {'1': 'sanitised_by', '3': 12, '4': 1, '5': 9, '10': 'sanitisedBy'},
    {'1': 'recipient', '3': 13, '4': 1, '5': 9, '10': 'recipient'},
    {'1': 'proceeds_minor', '3': 14, '4': 1, '5': 3, '10': 'proceedsMinor'},
    {
      '1': 'disposed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'disposedAt'
    },
    {'1': 'recorded_by', '3': 16, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Disposal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disposalDescriptor = $convert.base64Decode(
    'CghEaXNwb3NhbBIfCgtkaXNwb3NhbF9pZBgBIAEoCVIKZGlzcG9zYWxJZBIZCghhc3NldF9pZB'
    'gCIAEoCVIHYXNzZXRJZBIbCglhc3NldF90YWcYAyABKAlSCGFzc2V0VGFnEhYKBm1ldGhvZBgE'
    'IAEoCVIGbWV0aG9kEhYKBnJlYXNvbhgFIAEoCVIGcmVhc29uEiEKDHJlcXVlc3RlZF9ieRgGIA'
    'EoCVILcmVxdWVzdGVkQnkSHwoLYXBwcm92ZWRfYnkYByABKAlSCmFwcHJvdmVkQnkSOwoLYXBw'
    'cm92ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0Ej'
    'MKFXNhbml0aXNhdGlvbl9yZXF1aXJlZBgJIAEoCFIUc2FuaXRpc2F0aW9uUmVxdWlyZWQSLwoT'
    'c2FuaXRpc2F0aW9uX21ldGhvZBgKIAEoCVISc2FuaXRpc2F0aW9uTWV0aG9kEjkKGHNhbml0aX'
    'NhdGlvbl9jZXJ0aWZpY2F0ZRgLIAEoCVIXc2FuaXRpc2F0aW9uQ2VydGlmaWNhdGUSIQoMc2Fu'
    'aXRpc2VkX2J5GAwgASgJUgtzYW5pdGlzZWRCeRIcCglyZWNpcGllbnQYDSABKAlSCXJlY2lwaW'
    'VudBIlCg5wcm9jZWVkc19taW5vchgOIAEoA1INcHJvY2VlZHNNaW5vchI7CgtkaXNwb3NlZF9h'
    'dBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmRpc3Bvc2VkQXQSHwoLcmVjb3'
    'JkZWRfYnkYECABKAlSCnJlY29yZGVkQnk=');

@$core.Deprecated('Use disposeAssetRequestDescriptor instead')
const DisposeAssetRequest$json = {
  '1': 'DisposeAssetRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'requested_by', '3': 4, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'sanitisation_required',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'sanitisationRequired'
    },
    {
      '1': 'sanitisation_method',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'sanitisationMethod'
    },
    {
      '1': 'sanitisation_certificate',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'sanitisationCertificate'
    },
    {'1': 'sanitised_by', '3': 8, '4': 1, '5': 9, '10': 'sanitisedBy'},
    {'1': 'recipient', '3': 9, '4': 1, '5': 9, '10': 'recipient'},
    {'1': 'proceeds_minor', '3': 10, '4': 1, '5': 3, '10': 'proceedsMinor'},
  ],
};

/// Descriptor for `DisposeAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disposeAssetRequestDescriptor = $convert.base64Decode(
    'ChNEaXNwb3NlQXNzZXRSZXF1ZXN0EhkKCGFzc2V0X2lkGAEgASgJUgdhc3NldElkEhYKBm1ldG'
    'hvZBgCIAEoCVIGbWV0aG9kEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29uEiEKDHJlcXVlc3RlZF9i'
    'eRgEIAEoCVILcmVxdWVzdGVkQnkSMwoVc2FuaXRpc2F0aW9uX3JlcXVpcmVkGAUgASgIUhRzYW'
    '5pdGlzYXRpb25SZXF1aXJlZBIvChNzYW5pdGlzYXRpb25fbWV0aG9kGAYgASgJUhJzYW5pdGlz'
    'YXRpb25NZXRob2QSOQoYc2FuaXRpc2F0aW9uX2NlcnRpZmljYXRlGAcgASgJUhdzYW5pdGlzYX'
    'Rpb25DZXJ0aWZpY2F0ZRIhCgxzYW5pdGlzZWRfYnkYCCABKAlSC3Nhbml0aXNlZEJ5EhwKCXJl'
    'Y2lwaWVudBgJIAEoCVIJcmVjaXBpZW50EiUKDnByb2NlZWRzX21pbm9yGAogASgDUg1wcm9jZW'
    'Vkc01pbm9y');

@$core.Deprecated('Use disposeAssetResponseDescriptor instead')
const DisposeAssetResponse$json = {
  '1': 'DisposeAssetResponse',
  '2': [
    {
      '1': 'disposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Disposal',
      '10': 'disposal'
    },
  ],
};

/// Descriptor for `DisposeAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disposeAssetResponseDescriptor = $convert.base64Decode(
    'ChREaXNwb3NlQXNzZXRSZXNwb25zZRI+CghkaXNwb3NhbBgBIAEoCzIiLmhlYWx0aGNhcmUuYm'
    'lvbWVkaWNhbC52MS5EaXNwb3NhbFIIZGlzcG9zYWw=');

@$core.Deprecated('Use getDisposalRequestDescriptor instead')
const GetDisposalRequest$json = {
  '1': 'GetDisposalRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
  ],
};

/// Descriptor for `GetDisposalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDisposalRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXREaXNwb3NhbFJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQ=');

@$core.Deprecated('Use getDisposalResponseDescriptor instead')
const GetDisposalResponse$json = {
  '1': 'GetDisposalResponse',
  '2': [
    {
      '1': 'disposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Disposal',
      '10': 'disposal'
    },
  ],
};

/// Descriptor for `GetDisposalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDisposalResponseDescriptor = $convert.base64Decode(
    'ChNHZXREaXNwb3NhbFJlc3BvbnNlEj4KCGRpc3Bvc2FsGAEgASgLMiIuaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLkRpc3Bvc2FsUghkaXNwb3NhbA==');

@$core.Deprecated('Use listDisposalsRequestDescriptor instead')
const ListDisposalsRequest$json = {
  '1': 'ListDisposalsRequest',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDisposalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDisposalsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RGlzcG9zYWxzUmVxdWVzdBIuCgRmcm9tGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIEZnJvbRIqCgJ0bxgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'AnRvEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listDisposalsResponseDescriptor instead')
const ListDisposalsResponse$json = {
  '1': 'ListDisposalsResponse',
  '2': [
    {
      '1': 'disposals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.biomedical.v1.Disposal',
      '10': 'disposals'
    },
  ],
};

/// Descriptor for `ListDisposalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDisposalsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RGlzcG9zYWxzUmVzcG9uc2USQAoJZGlzcG9zYWxzGAEgAygLMiIuaGVhbHRoY2FyZS'
    '5iaW9tZWRpY2FsLnYxLkRpc3Bvc2FsUglkaXNwb3NhbHM=');

const $core.Map<$core.String, $core.dynamic> BiomedicalServiceBase$json = {
  '1': 'BiomedicalService',
  '2': [
    {
      '1': 'RegisterAsset',
      '2': '.healthcare.biomedical.v1.RegisterAssetRequest',
      '3': '.healthcare.biomedical.v1.RegisterAssetResponse'
    },
    {
      '1': 'GetAsset',
      '2': '.healthcare.biomedical.v1.GetAssetRequest',
      '3': '.healthcare.biomedical.v1.GetAssetResponse'
    },
    {
      '1': 'GetAssetByTag',
      '2': '.healthcare.biomedical.v1.GetAssetByTagRequest',
      '3': '.healthcare.biomedical.v1.GetAssetByTagResponse'
    },
    {
      '1': 'ListAssets',
      '2': '.healthcare.biomedical.v1.ListAssetsRequest',
      '3': '.healthcare.biomedical.v1.ListAssetsResponse'
    },
    {
      '1': 'MoveAsset',
      '2': '.healthcare.biomedical.v1.MoveAssetRequest',
      '3': '.healthcare.biomedical.v1.MoveAssetResponse'
    },
    {
      '1': 'RecordCalibration',
      '2': '.healthcare.biomedical.v1.RecordCalibrationRequest',
      '3': '.healthcare.biomedical.v1.RecordCalibrationResponse'
    },
    {
      '1': 'GetLocationCapability',
      '2': '.healthcare.biomedical.v1.GetLocationCapabilityRequest',
      '3': '.healthcare.biomedical.v1.GetLocationCapabilityResponse'
    },
    {
      '1': 'RecordContract',
      '2': '.healthcare.biomedical.v1.RecordContractRequest',
      '3': '.healthcare.biomedical.v1.RecordContractResponse'
    },
    {
      '1': 'GetContract',
      '2': '.healthcare.biomedical.v1.GetContractRequest',
      '3': '.healthcare.biomedical.v1.GetContractResponse'
    },
    {
      '1': 'ListContractsForAsset',
      '2': '.healthcare.biomedical.v1.ListContractsForAssetRequest',
      '3': '.healthcare.biomedical.v1.ListContractsForAssetResponse'
    },
    {
      '1': 'GetCoverForAsset',
      '2': '.healthcare.biomedical.v1.GetCoverForAssetRequest',
      '3': '.healthcare.biomedical.v1.GetCoverForAssetResponse'
    },
    {
      '1': 'ListExpiryReminders',
      '2': '.healthcare.biomedical.v1.ListExpiryRemindersRequest',
      '3': '.healthcare.biomedical.v1.ListExpiryRemindersResponse'
    },
    {
      '1': 'SchedulePlan',
      '2': '.healthcare.biomedical.v1.SchedulePlanRequest',
      '3': '.healthcare.biomedical.v1.SchedulePlanResponse'
    },
    {
      '1': 'RetirePlan',
      '2': '.healthcare.biomedical.v1.RetirePlanRequest',
      '3': '.healthcare.biomedical.v1.RetirePlanResponse'
    },
    {
      '1': 'ListPlans',
      '2': '.healthcare.biomedical.v1.ListPlansRequest',
      '3': '.healthcare.biomedical.v1.ListPlansResponse'
    },
    {
      '1': 'ListDueMaintenance',
      '2': '.healthcare.biomedical.v1.ListDueMaintenanceRequest',
      '3': '.healthcare.biomedical.v1.ListDueMaintenanceResponse'
    },
    {
      '1': 'RaiseTicket',
      '2': '.healthcare.biomedical.v1.RaiseTicketRequest',
      '3': '.healthcare.biomedical.v1.RaiseTicketResponse'
    },
    {
      '1': 'GetTicket',
      '2': '.healthcare.biomedical.v1.GetTicketRequest',
      '3': '.healthcare.biomedical.v1.GetTicketResponse'
    },
    {
      '1': 'ListTickets',
      '2': '.healthcare.biomedical.v1.ListTicketsRequest',
      '3': '.healthcare.biomedical.v1.ListTicketsResponse'
    },
    {
      '1': 'AssignTicket',
      '2': '.healthcare.biomedical.v1.AssignTicketRequest',
      '3': '.healthcare.biomedical.v1.AssignTicketResponse'
    },
    {
      '1': 'StartTicket',
      '2': '.healthcare.biomedical.v1.StartTicketRequest',
      '3': '.healthcare.biomedical.v1.StartTicketResponse'
    },
    {
      '1': 'AwaitParts',
      '2': '.healthcare.biomedical.v1.AwaitPartsRequest',
      '3': '.healthcare.biomedical.v1.AwaitPartsResponse'
    },
    {
      '1': 'CancelTicket',
      '2': '.healthcare.biomedical.v1.CancelTicketRequest',
      '3': '.healthcare.biomedical.v1.CancelTicketResponse'
    },
    {
      '1': 'ResolveTicket',
      '2': '.healthcare.biomedical.v1.ResolveTicketRequest',
      '3': '.healthcare.biomedical.v1.ResolveTicketResponse'
    },
    {
      '1': 'CloseTicket',
      '2': '.healthcare.biomedical.v1.CloseTicketRequest',
      '3': '.healthcare.biomedical.v1.CloseTicketResponse'
    },
    {
      '1': 'ListBreaches',
      '2': '.healthcare.biomedical.v1.ListBreachesRequest',
      '3': '.healthcare.biomedical.v1.ListBreachesResponse'
    },
    {
      '1': 'RaiseNotice',
      '2': '.healthcare.biomedical.v1.RaiseNoticeRequest',
      '3': '.healthcare.biomedical.v1.RaiseNoticeResponse'
    },
    {
      '1': 'GetNotice',
      '2': '.healthcare.biomedical.v1.GetNoticeRequest',
      '3': '.healthcare.biomedical.v1.GetNoticeResponse'
    },
    {
      '1': 'ListNotices',
      '2': '.healthcare.biomedical.v1.ListNoticesRequest',
      '3': '.healthcare.biomedical.v1.ListNoticesResponse'
    },
    {
      '1': 'ListNoticeTasks',
      '2': '.healthcare.biomedical.v1.ListNoticeTasksRequest',
      '3': '.healthcare.biomedical.v1.ListNoticeTasksResponse'
    },
    {
      '1': 'AdvanceTask',
      '2': '.healthcare.biomedical.v1.AdvanceTaskRequest',
      '3': '.healthcare.biomedical.v1.AdvanceTaskResponse'
    },
    {
      '1': 'TrackNotice',
      '2': '.healthcare.biomedical.v1.TrackNoticeRequest',
      '3': '.healthcare.biomedical.v1.TrackNoticeResponse'
    },
    {
      '1': 'CloseNotice',
      '2': '.healthcare.biomedical.v1.CloseNoticeRequest',
      '3': '.healthcare.biomedical.v1.CloseNoticeResponse'
    },
    {
      '1': 'HoldAsset',
      '2': '.healthcare.biomedical.v1.HoldAssetRequest',
      '3': '.healthcare.biomedical.v1.HoldAssetResponse'
    },
    {
      '1': 'ReleaseAsset',
      '2': '.healthcare.biomedical.v1.ReleaseAssetRequest',
      '3': '.healthcare.biomedical.v1.ReleaseAssetResponse'
    },
    {
      '1': 'AppendReadings',
      '2': '.healthcare.biomedical.v1.AppendReadingsRequest',
      '3': '.healthcare.biomedical.v1.AppendReadingsResponse'
    },
    {
      '1': 'ListReadings',
      '2': '.healthcare.biomedical.v1.ListReadingsRequest',
      '3': '.healthcare.biomedical.v1.ListReadingsResponse'
    },
    {
      '1': 'GetAssetMetrics',
      '2': '.healthcare.biomedical.v1.GetAssetMetricsRequest',
      '3': '.healthcare.biomedical.v1.GetAssetMetricsResponse'
    },
    {
      '1': 'GetFleetMetrics',
      '2': '.healthcare.biomedical.v1.GetFleetMetricsRequest',
      '3': '.healthcare.biomedical.v1.GetFleetMetricsResponse'
    },
    {
      '1': 'DisposeAsset',
      '2': '.healthcare.biomedical.v1.DisposeAssetRequest',
      '3': '.healthcare.biomedical.v1.DisposeAssetResponse'
    },
    {
      '1': 'GetDisposal',
      '2': '.healthcare.biomedical.v1.GetDisposalRequest',
      '3': '.healthcare.biomedical.v1.GetDisposalResponse'
    },
    {
      '1': 'ListDisposals',
      '2': '.healthcare.biomedical.v1.ListDisposalsRequest',
      '3': '.healthcare.biomedical.v1.ListDisposalsResponse'
    },
  ],
};

@$core.Deprecated('Use biomedicalServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    BiomedicalServiceBase$messageJson = {
  '.healthcare.biomedical.v1.RegisterAssetRequest': RegisterAssetRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.biomedical.v1.RegisterAssetResponse': RegisterAssetResponse$json,
  '.healthcare.biomedical.v1.Asset': Asset$json,
  '.healthcare.biomedical.v1.GetAssetRequest': GetAssetRequest$json,
  '.healthcare.biomedical.v1.GetAssetResponse': GetAssetResponse$json,
  '.healthcare.biomedical.v1.GetAssetByTagRequest': GetAssetByTagRequest$json,
  '.healthcare.biomedical.v1.GetAssetByTagResponse': GetAssetByTagResponse$json,
  '.healthcare.biomedical.v1.ListAssetsRequest': ListAssetsRequest$json,
  '.healthcare.biomedical.v1.ListAssetsResponse': ListAssetsResponse$json,
  '.healthcare.biomedical.v1.MoveAssetRequest': MoveAssetRequest$json,
  '.healthcare.biomedical.v1.MoveAssetResponse': MoveAssetResponse$json,
  '.healthcare.biomedical.v1.RecordCalibrationRequest':
      RecordCalibrationRequest$json,
  '.healthcare.biomedical.v1.RecordCalibrationResponse':
      RecordCalibrationResponse$json,
  '.healthcare.biomedical.v1.GetLocationCapabilityRequest':
      GetLocationCapabilityRequest$json,
  '.healthcare.biomedical.v1.GetLocationCapabilityResponse':
      GetLocationCapabilityResponse$json,
  '.healthcare.biomedical.v1.GetLocationCapabilityResponse.AvailableEntry':
      GetLocationCapabilityResponse_AvailableEntry$json,
  '.healthcare.biomedical.v1.UnusableAsset': UnusableAsset$json,
  '.healthcare.biomedical.v1.RecordContractRequest': RecordContractRequest$json,
  '.healthcare.biomedical.v1.RecordContractResponse':
      RecordContractResponse$json,
  '.healthcare.biomedical.v1.ServiceContract': ServiceContract$json,
  '.healthcare.biomedical.v1.GetContractRequest': GetContractRequest$json,
  '.healthcare.biomedical.v1.GetContractResponse': GetContractResponse$json,
  '.healthcare.biomedical.v1.ListContractsForAssetRequest':
      ListContractsForAssetRequest$json,
  '.healthcare.biomedical.v1.ListContractsForAssetResponse':
      ListContractsForAssetResponse$json,
  '.healthcare.biomedical.v1.GetCoverForAssetRequest':
      GetCoverForAssetRequest$json,
  '.healthcare.biomedical.v1.GetCoverForAssetResponse':
      GetCoverForAssetResponse$json,
  '.healthcare.biomedical.v1.ListExpiryRemindersRequest':
      ListExpiryRemindersRequest$json,
  '.healthcare.biomedical.v1.ListExpiryRemindersResponse':
      ListExpiryRemindersResponse$json,
  '.healthcare.biomedical.v1.Expiry': Expiry$json,
  '.healthcare.biomedical.v1.SchedulePlanRequest': SchedulePlanRequest$json,
  '.healthcare.biomedical.v1.SchedulePlanResponse': SchedulePlanResponse$json,
  '.healthcare.biomedical.v1.PMPlan': PMPlan$json,
  '.healthcare.biomedical.v1.RetirePlanRequest': RetirePlanRequest$json,
  '.healthcare.biomedical.v1.RetirePlanResponse': RetirePlanResponse$json,
  '.healthcare.biomedical.v1.ListPlansRequest': ListPlansRequest$json,
  '.healthcare.biomedical.v1.ListPlansResponse': ListPlansResponse$json,
  '.healthcare.biomedical.v1.ListDueMaintenanceRequest':
      ListDueMaintenanceRequest$json,
  '.healthcare.biomedical.v1.ListDueMaintenanceResponse':
      ListDueMaintenanceResponse$json,
  '.healthcare.biomedical.v1.Due': Due$json,
  '.healthcare.biomedical.v1.RaiseTicketRequest': RaiseTicketRequest$json,
  '.healthcare.biomedical.v1.RaiseTicketResponse': RaiseTicketResponse$json,
  '.healthcare.biomedical.v1.Ticket': Ticket$json,
  '.healthcare.biomedical.v1.PartUsed': PartUsed$json,
  '.healthcare.biomedical.v1.GetTicketRequest': GetTicketRequest$json,
  '.healthcare.biomedical.v1.GetTicketResponse': GetTicketResponse$json,
  '.healthcare.biomedical.v1.ListTicketsRequest': ListTicketsRequest$json,
  '.healthcare.biomedical.v1.ListTicketsResponse': ListTicketsResponse$json,
  '.healthcare.biomedical.v1.AssignTicketRequest': AssignTicketRequest$json,
  '.healthcare.biomedical.v1.AssignTicketResponse': AssignTicketResponse$json,
  '.healthcare.biomedical.v1.StartTicketRequest': StartTicketRequest$json,
  '.healthcare.biomedical.v1.StartTicketResponse': StartTicketResponse$json,
  '.healthcare.biomedical.v1.AwaitPartsRequest': AwaitPartsRequest$json,
  '.healthcare.biomedical.v1.AwaitPartsResponse': AwaitPartsResponse$json,
  '.healthcare.biomedical.v1.CancelTicketRequest': CancelTicketRequest$json,
  '.healthcare.biomedical.v1.CancelTicketResponse': CancelTicketResponse$json,
  '.healthcare.biomedical.v1.ResolveTicketRequest': ResolveTicketRequest$json,
  '.healthcare.biomedical.v1.ResolveTicketResponse': ResolveTicketResponse$json,
  '.healthcare.biomedical.v1.CloseTicketRequest': CloseTicketRequest$json,
  '.healthcare.biomedical.v1.CloseTicketResponse': CloseTicketResponse$json,
  '.healthcare.biomedical.v1.ListBreachesRequest': ListBreachesRequest$json,
  '.healthcare.biomedical.v1.ListBreachesResponse': ListBreachesResponse$json,
  '.healthcare.biomedical.v1.Breach': Breach$json,
  '.healthcare.biomedical.v1.RaiseNoticeRequest': RaiseNoticeRequest$json,
  '.healthcare.biomedical.v1.RaiseNoticeResponse': RaiseNoticeResponse$json,
  '.healthcare.biomedical.v1.SafetyNotice': SafetyNotice$json,
  '.healthcare.biomedical.v1.NoticeTask': NoticeTask$json,
  '.healthcare.biomedical.v1.GetNoticeRequest': GetNoticeRequest$json,
  '.healthcare.biomedical.v1.GetNoticeResponse': GetNoticeResponse$json,
  '.healthcare.biomedical.v1.ListNoticesRequest': ListNoticesRequest$json,
  '.healthcare.biomedical.v1.ListNoticesResponse': ListNoticesResponse$json,
  '.healthcare.biomedical.v1.ListNoticeTasksRequest':
      ListNoticeTasksRequest$json,
  '.healthcare.biomedical.v1.ListNoticeTasksResponse':
      ListNoticeTasksResponse$json,
  '.healthcare.biomedical.v1.AdvanceTaskRequest': AdvanceTaskRequest$json,
  '.healthcare.biomedical.v1.AdvanceTaskResponse': AdvanceTaskResponse$json,
  '.healthcare.biomedical.v1.TrackNoticeRequest': TrackNoticeRequest$json,
  '.healthcare.biomedical.v1.TrackNoticeResponse': TrackNoticeResponse$json,
  '.healthcare.biomedical.v1.CloseNoticeRequest': CloseNoticeRequest$json,
  '.healthcare.biomedical.v1.CloseNoticeResponse': CloseNoticeResponse$json,
  '.healthcare.biomedical.v1.HoldAssetRequest': HoldAssetRequest$json,
  '.healthcare.biomedical.v1.HoldAssetResponse': HoldAssetResponse$json,
  '.healthcare.biomedical.v1.ReleaseAssetRequest': ReleaseAssetRequest$json,
  '.healthcare.biomedical.v1.ReleaseAssetResponse': ReleaseAssetResponse$json,
  '.healthcare.biomedical.v1.AppendReadingsRequest': AppendReadingsRequest$json,
  '.healthcare.biomedical.v1.NewReading': NewReading$json,
  '.healthcare.biomedical.v1.AppendReadingsResponse':
      AppendReadingsResponse$json,
  '.healthcare.biomedical.v1.Reading': Reading$json,
  '.healthcare.biomedical.v1.ListReadingsRequest': ListReadingsRequest$json,
  '.healthcare.biomedical.v1.ListReadingsResponse': ListReadingsResponse$json,
  '.healthcare.biomedical.v1.GetAssetMetricsRequest':
      GetAssetMetricsRequest$json,
  '.healthcare.biomedical.v1.GetAssetMetricsResponse':
      GetAssetMetricsResponse$json,
  '.healthcare.biomedical.v1.Metrics': Metrics$json,
  '.healthcare.biomedical.v1.GetFleetMetricsRequest':
      GetFleetMetricsRequest$json,
  '.healthcare.biomedical.v1.GetFleetMetricsResponse':
      GetFleetMetricsResponse$json,
  '.healthcare.biomedical.v1.FleetLine': FleetLine$json,
  '.healthcare.biomedical.v1.DisposeAssetRequest': DisposeAssetRequest$json,
  '.healthcare.biomedical.v1.DisposeAssetResponse': DisposeAssetResponse$json,
  '.healthcare.biomedical.v1.Disposal': Disposal$json,
  '.healthcare.biomedical.v1.GetDisposalRequest': GetDisposalRequest$json,
  '.healthcare.biomedical.v1.GetDisposalResponse': GetDisposalResponse$json,
  '.healthcare.biomedical.v1.ListDisposalsRequest': ListDisposalsRequest$json,
  '.healthcare.biomedical.v1.ListDisposalsResponse': ListDisposalsResponse$json,
};

/// Descriptor for `BiomedicalService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List biomedicalServiceDescriptor = $convert.base64Decode(
    'ChFCaW9tZWRpY2FsU2VydmljZRJwCg1SZWdpc3RlckFzc2V0Ei4uaGVhbHRoY2FyZS5iaW9tZW'
    'RpY2FsLnYxLlJlZ2lzdGVyQXNzZXRSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYx'
    'LlJlZ2lzdGVyQXNzZXRSZXNwb25zZRJhCghHZXRBc3NldBIpLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5HZXRBc3NldFJlcXVlc3QaKi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuR2V0QXNz'
    'ZXRSZXNwb25zZRJwCg1HZXRBc3NldEJ5VGFnEi4uaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLk'
    'dldEFzc2V0QnlUYWdSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkdldEFzc2V0'
    'QnlUYWdSZXNwb25zZRJnCgpMaXN0QXNzZXRzEisuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLk'
    'xpc3RBc3NldHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkxpc3RBc3NldHNS'
    'ZXNwb25zZRJkCglNb3ZlQXNzZXQSKi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuTW92ZUFzc2'
    'V0UmVxdWVzdBorLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Nb3ZlQXNzZXRSZXNwb25zZRJ8'
    'ChFSZWNvcmRDYWxpYnJhdGlvbhIyLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5SZWNvcmRDYW'
    'xpYnJhdGlvblJlcXVlc3QaMy5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuUmVjb3JkQ2FsaWJy'
    'YXRpb25SZXNwb25zZRKIAQoVR2V0TG9jYXRpb25DYXBhYmlsaXR5EjYuaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLkdldExvY2F0aW9uQ2FwYWJpbGl0eVJlcXVlc3QaNy5oZWFsdGhjYXJlLmJp'
    'b21lZGljYWwudjEuR2V0TG9jYXRpb25DYXBhYmlsaXR5UmVzcG9uc2UScwoOUmVjb3JkQ29udH'
    'JhY3QSLy5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuUmVjb3JkQ29udHJhY3RSZXF1ZXN0GjAu'
    'aGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlJlY29yZENvbnRyYWN0UmVzcG9uc2USagoLR2V0Q2'
    '9udHJhY3QSLC5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuR2V0Q29udHJhY3RSZXF1ZXN0Gi0u'
    'aGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkdldENvbnRyYWN0UmVzcG9uc2USiAEKFUxpc3RDb2'
    '50cmFjdHNGb3JBc3NldBI2LmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5MaXN0Q29udHJhY3Rz'
    'Rm9yQXNzZXRSZXF1ZXN0GjcuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkxpc3RDb250cmFjdH'
    'NGb3JBc3NldFJlc3BvbnNlEnkKEEdldENvdmVyRm9yQXNzZXQSMS5oZWFsdGhjYXJlLmJpb21l'
    'ZGljYWwudjEuR2V0Q292ZXJGb3JBc3NldFJlcXVlc3QaMi5oZWFsdGhjYXJlLmJpb21lZGljYW'
    'wudjEuR2V0Q292ZXJGb3JBc3NldFJlc3BvbnNlEoIBChNMaXN0RXhwaXJ5UmVtaW5kZXJzEjQu'
    'aGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkxpc3RFeHBpcnlSZW1pbmRlcnNSZXF1ZXN0GjUuaG'
    'VhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLkxpc3RFeHBpcnlSZW1pbmRlcnNSZXNwb25zZRJtCgxT'
    'Y2hlZHVsZVBsYW4SLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuU2NoZWR1bGVQbGFuUmVxdW'
    'VzdBouLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5TY2hlZHVsZVBsYW5SZXNwb25zZRJnCgpS'
    'ZXRpcmVQbGFuEisuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlJldGlyZVBsYW5SZXF1ZXN0Gi'
    'wuaGVhbHRoY2FyZS5iaW9tZWRpY2FsLnYxLlJldGlyZVBsYW5SZXNwb25zZRJkCglMaXN0UGxh'
    'bnMSKi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuTGlzdFBsYW5zUmVxdWVzdBorLmhlYWx0aG'
    'NhcmUuYmlvbWVkaWNhbC52MS5MaXN0UGxhbnNSZXNwb25zZRJ/ChJMaXN0RHVlTWFpbnRlbmFu'
    'Y2USMy5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuTGlzdER1ZU1haW50ZW5hbmNlUmVxdWVzdB'
    'o0LmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5MaXN0RHVlTWFpbnRlbmFuY2VSZXNwb25zZRJq'
    'CgtSYWlzZVRpY2tldBIsLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5SYWlzZVRpY2tldFJlcX'
    'Vlc3QaLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuUmFpc2VUaWNrZXRSZXNwb25zZRJkCglH'
    'ZXRUaWNrZXQSKi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuR2V0VGlja2V0UmVxdWVzdBorLm'
    'hlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5HZXRUaWNrZXRSZXNwb25zZRJqCgtMaXN0VGlja2V0'
    'cxIsLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5MaXN0VGlja2V0c1JlcXVlc3QaLS5oZWFsdG'
    'hjYXJlLmJpb21lZGljYWwudjEuTGlzdFRpY2tldHNSZXNwb25zZRJtCgxBc3NpZ25UaWNrZXQS'
    'LS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuQXNzaWduVGlja2V0UmVxdWVzdBouLmhlYWx0aG'
    'NhcmUuYmlvbWVkaWNhbC52MS5Bc3NpZ25UaWNrZXRSZXNwb25zZRJqCgtTdGFydFRpY2tldBIs'
    'LmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5TdGFydFRpY2tldFJlcXVlc3QaLS5oZWFsdGhjYX'
    'JlLmJpb21lZGljYWwudjEuU3RhcnRUaWNrZXRSZXNwb25zZRJnCgpBd2FpdFBhcnRzEisuaGVh'
    'bHRoY2FyZS5iaW9tZWRpY2FsLnYxLkF3YWl0UGFydHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLkF3YWl0UGFydHNSZXNwb25zZRJtCgxDYW5jZWxUaWNrZXQSLS5oZWFsdGhj'
    'YXJlLmJpb21lZGljYWwudjEuQ2FuY2VsVGlja2V0UmVxdWVzdBouLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5DYW5jZWxUaWNrZXRSZXNwb25zZRJwCg1SZXNvbHZlVGlja2V0Ei4uaGVhbHRo'
    'Y2FyZS5iaW9tZWRpY2FsLnYxLlJlc29sdmVUaWNrZXRSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaW'
    '9tZWRpY2FsLnYxLlJlc29sdmVUaWNrZXRSZXNwb25zZRJqCgtDbG9zZVRpY2tldBIsLmhlYWx0'
    'aGNhcmUuYmlvbWVkaWNhbC52MS5DbG9zZVRpY2tldFJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb2'
    '1lZGljYWwudjEuQ2xvc2VUaWNrZXRSZXNwb25zZRJtCgxMaXN0QnJlYWNoZXMSLS5oZWFsdGhj'
    'YXJlLmJpb21lZGljYWwudjEuTGlzdEJyZWFjaGVzUmVxdWVzdBouLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5MaXN0QnJlYWNoZXNSZXNwb25zZRJqCgtSYWlzZU5vdGljZRIsLmhlYWx0aGNh'
    'cmUuYmlvbWVkaWNhbC52MS5SYWlzZU5vdGljZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZG'
    'ljYWwudjEuUmFpc2VOb3RpY2VSZXNwb25zZRJkCglHZXROb3RpY2USKi5oZWFsdGhjYXJlLmJp'
    'b21lZGljYWwudjEuR2V0Tm90aWNlUmVxdWVzdBorLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS'
    '5HZXROb3RpY2VSZXNwb25zZRJqCgtMaXN0Tm90aWNlcxIsLmhlYWx0aGNhcmUuYmlvbWVkaWNh'
    'bC52MS5MaXN0Tm90aWNlc1JlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuTGlzdE'
    '5vdGljZXNSZXNwb25zZRJ2Cg9MaXN0Tm90aWNlVGFza3MSMC5oZWFsdGhjYXJlLmJpb21lZGlj'
    'YWwudjEuTGlzdE5vdGljZVRhc2tzUmVxdWVzdBoxLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS'
    '5MaXN0Tm90aWNlVGFza3NSZXNwb25zZRJqCgtBZHZhbmNlVGFzaxIsLmhlYWx0aGNhcmUuYmlv'
    'bWVkaWNhbC52MS5BZHZhbmNlVGFza1JlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudj'
    'EuQWR2YW5jZVRhc2tSZXNwb25zZRJqCgtUcmFja05vdGljZRIsLmhlYWx0aGNhcmUuYmlvbWVk'
    'aWNhbC52MS5UcmFja05vdGljZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuVH'
    'JhY2tOb3RpY2VSZXNwb25zZRJqCgtDbG9zZU5vdGljZRIsLmhlYWx0aGNhcmUuYmlvbWVkaWNh'
    'bC52MS5DbG9zZU5vdGljZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuQ2xvc2'
    'VOb3RpY2VSZXNwb25zZRJkCglIb2xkQXNzZXQSKi5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEu'
    'SG9sZEFzc2V0UmVxdWVzdBorLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5Ib2xkQXNzZXRSZX'
    'Nwb25zZRJtCgxSZWxlYXNlQXNzZXQSLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuUmVsZWFz'
    'ZUFzc2V0UmVxdWVzdBouLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5SZWxlYXNlQXNzZXRSZX'
    'Nwb25zZRJzCg5BcHBlbmRSZWFkaW5ncxIvLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5BcHBl'
    'bmRSZWFkaW5nc1JlcXVlc3QaMC5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEuQXBwZW5kUmVhZG'
    'luZ3NSZXNwb25zZRJtCgxMaXN0UmVhZGluZ3MSLS5oZWFsdGhjYXJlLmJpb21lZGljYWwudjEu'
    'TGlzdFJlYWRpbmdzUmVxdWVzdBouLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5MaXN0UmVhZG'
    'luZ3NSZXNwb25zZRJ2Cg9HZXRBc3NldE1ldHJpY3MSMC5oZWFsdGhjYXJlLmJpb21lZGljYWwu'
    'djEuR2V0QXNzZXRNZXRyaWNzUmVxdWVzdBoxLmhlYWx0aGNhcmUuYmlvbWVkaWNhbC52MS5HZX'
    'RBc3NldE1ldHJpY3NSZXNwb25zZRJ2Cg9HZXRGbGVldE1ldHJpY3MSMC5oZWFsdGhjYXJlLmJp'
    'b21lZGljYWwudjEuR2V0RmxlZXRNZXRyaWNzUmVxdWVzdBoxLmhlYWx0aGNhcmUuYmlvbWVkaW'
    'NhbC52MS5HZXRGbGVldE1ldHJpY3NSZXNwb25zZRJtCgxEaXNwb3NlQXNzZXQSLS5oZWFsdGhj'
    'YXJlLmJpb21lZGljYWwudjEuRGlzcG9zZUFzc2V0UmVxdWVzdBouLmhlYWx0aGNhcmUuYmlvbW'
    'VkaWNhbC52MS5EaXNwb3NlQXNzZXRSZXNwb25zZRJqCgtHZXREaXNwb3NhbBIsLmhlYWx0aGNh'
    'cmUuYmlvbWVkaWNhbC52MS5HZXREaXNwb3NhbFJlcXVlc3QaLS5oZWFsdGhjYXJlLmJpb21lZG'
    'ljYWwudjEuR2V0RGlzcG9zYWxSZXNwb25zZRJwCg1MaXN0RGlzcG9zYWxzEi4uaGVhbHRoY2Fy'
    'ZS5iaW9tZWRpY2FsLnYxLkxpc3REaXNwb3NhbHNSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5iaW9tZW'
    'RpY2FsLnYxLkxpc3REaXNwb3NhbHNSZXNwb25zZQ==');
