// This is a generated file - do not edit.
//
// Generated from healthcare/facilities/v1/facilities.proto.

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

@$core.Deprecated('Use systemDescriptor instead')
const System$json = {
  '1': 'System',
  '2': [
    {'1': 'SYSTEM_UNSPECIFIED', '2': 0},
    {'1': 'SYSTEM_ELECTRICAL', '2': 1},
    {'1': 'SYSTEM_HVAC', '2': 2},
    {'1': 'SYSTEM_PLUMBING', '2': 3},
    {'1': 'SYSTEM_FIRE', '2': 4},
    {'1': 'SYSTEM_MEDICAL_GAS', '2': 5},
    {'1': 'SYSTEM_LIFTS', '2': 6},
    {'1': 'SYSTEM_WATER', '2': 7},
    {'1': 'SYSTEM_EFFLUENT', '2': 8},
    {'1': 'SYSTEM_POWER', '2': 9},
    {'1': 'SYSTEM_OTHER', '2': 10},
  ],
};

/// Descriptor for `System`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List systemDescriptor = $convert.base64Decode(
    'CgZTeXN0ZW0SFgoSU1lTVEVNX1VOU1BFQ0lGSUVEEAASFQoRU1lTVEVNX0VMRUNUUklDQUwQAR'
    'IPCgtTWVNURU1fSFZBQxACEhMKD1NZU1RFTV9QTFVNQklORxADEg8KC1NZU1RFTV9GSVJFEAQS'
    'FgoSU1lTVEVNX01FRElDQUxfR0FTEAUSEAoMU1lTVEVNX0xJRlRTEAYSEAoMU1lTVEVNX1dBVE'
    'VSEAcSEwoPU1lTVEVNX0VGRkxVRU5UEAgSEAoMU1lTVEVNX1BPV0VSEAkSEAoMU1lTVEVNX09U'
    'SEVSEAo=');

@$core.Deprecated('Use criticalityDescriptor instead')
const Criticality$json = {
  '1': 'Criticality',
  '2': [
    {'1': 'CRITICALITY_UNSPECIFIED', '2': 0},
    {'1': 'CRITICALITY_LIFE', '2': 1},
    {'1': 'CRITICALITY_HIGH', '2': 2},
    {'1': 'CRITICALITY_NORMAL', '2': 3},
    {'1': 'CRITICALITY_LOW', '2': 4},
  ],
};

/// Descriptor for `Criticality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List criticalityDescriptor = $convert.base64Decode(
    'CgtDcml0aWNhbGl0eRIbChdDUklUSUNBTElUWV9VTlNQRUNJRklFRBAAEhQKEENSSVRJQ0FMSV'
    'RZX0xJRkUQARIUChBDUklUSUNBTElUWV9ISUdIEAISFgoSQ1JJVElDQUxJVFlfTk9STUFMEAMS'
    'EwoPQ1JJVElDQUxJVFlfTE9XEAQ=');

@$core.Deprecated('Use assetStatusDescriptor instead')
const AssetStatus$json = {
  '1': 'AssetStatus',
  '2': [
    {'1': 'ASSET_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ASSET_STATUS_IN_SERVICE', '2': 1},
    {'1': 'ASSET_STATUS_DEGRADED', '2': 2},
    {'1': 'ASSET_STATUS_DOWN', '2': 3},
    {'1': 'ASSET_STATUS_DECOMMISSIONED', '2': 4},
  ],
};

/// Descriptor for `AssetStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assetStatusDescriptor = $convert.base64Decode(
    'CgtBc3NldFN0YXR1cxIcChhBU1NFVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdBU1NFVF9TVE'
    'FUVVNfSU5fU0VSVklDRRABEhkKFUFTU0VUX1NUQVRVU19ERUdSQURFRBACEhUKEUFTU0VUX1NU'
    'QVRVU19ET1dOEAMSHwobQVNTRVRfU1RBVFVTX0RFQ09NTUlTU0lPTkVEEAQ=');

@$core.Deprecated('Use priorityDescriptor instead')
const Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_EMERGENCY', '2': 1},
    {'1': 'PRIORITY_URGENT', '2': 2},
    {'1': 'PRIORITY_ROUTINE', '2': 3},
    {'1': 'PRIORITY_PLANNED', '2': 4},
  ],
};

/// Descriptor for `Priority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityDescriptor = $convert.base64Decode(
    'CghQcmlvcml0eRIYChRQUklPUklUWV9VTlNQRUNJRklFRBAAEhYKElBSSU9SSVRZX0VNRVJHRU'
    '5DWRABEhMKD1BSSU9SSVRZX1VSR0VOVBACEhQKEFBSSU9SSVRZX1JPVVRJTkUQAxIUChBQUklP'
    'UklUWV9QTEFOTkVEEAQ=');

@$core.Deprecated('Use workStateDescriptor instead')
const WorkState$json = {
  '1': 'WorkState',
  '2': [
    {'1': 'WORK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'WORK_STATE_RAISED', '2': 1},
    {'1': 'WORK_STATE_ASSIGNED', '2': 2},
    {'1': 'WORK_STATE_IN_PROGRESS', '2': 3},
    {'1': 'WORK_STATE_ON_HOLD', '2': 4},
    {'1': 'WORK_STATE_RESOLVED', '2': 5},
    {'1': 'WORK_STATE_CLOSED', '2': 6},
    {'1': 'WORK_STATE_CANCELLED', '2': 7},
  ],
};

/// Descriptor for `WorkState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workStateDescriptor = $convert.base64Decode(
    'CglXb3JrU3RhdGUSGgoWV09SS19TVEFURV9VTlNQRUNJRklFRBAAEhUKEVdPUktfU1RBVEVfUk'
    'FJU0VEEAESFwoTV09SS19TVEFURV9BU1NJR05FRBACEhoKFldPUktfU1RBVEVfSU5fUFJPR1JF'
    'U1MQAxIWChJXT1JLX1NUQVRFX09OX0hPTEQQBBIXChNXT1JLX1NUQVRFX1JFU09MVkVEEAUSFQ'
    'oRV09SS19TVEFURV9DTE9TRUQQBhIYChRXT1JLX1NUQVRFX0NBTkNFTExFRBAH');

@$core.Deprecated('Use maintenanceKindDescriptor instead')
const MaintenanceKind$json = {
  '1': 'MaintenanceKind',
  '2': [
    {'1': 'MAINTENANCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'MAINTENANCE_KIND_PREVENTIVE', '2': 1},
    {'1': 'MAINTENANCE_KIND_STATUTORY', '2': 2},
  ],
};

/// Descriptor for `MaintenanceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List maintenanceKindDescriptor = $convert.base64Decode(
    'Cg9NYWludGVuYW5jZUtpbmQSIAocTUFJTlRFTkFOQ0VfS0lORF9VTlNQRUNJRklFRBAAEh8KG0'
    '1BSU5URU5BTkNFX0tJTkRfUFJFVkVOVElWRRABEh4KGk1BSU5URU5BTkNFX0tJTkRfU1RBVFVU'
    'T1JZEAI=');

@$core.Deprecated('Use triggerDescriptor instead')
const Trigger$json = {
  '1': 'Trigger',
  '2': [
    {'1': 'TRIGGER_UNSPECIFIED', '2': 0},
    {'1': 'TRIGGER_CALENDAR', '2': 1},
    {'1': 'TRIGGER_RUNTIME', '2': 2},
    {'1': 'TRIGGER_EITHER', '2': 3},
  ],
};

/// Descriptor for `Trigger`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List triggerDescriptor = $convert.base64Decode(
    'CgdUcmlnZ2VyEhcKE1RSSUdHRVJfVU5TUEVDSUZJRUQQABIUChBUUklHR0VSX0NBTEVOREFSEA'
    'ESEwoPVFJJR0dFUl9SVU5USU1FEAISEgoOVFJJR0dFUl9FSVRIRVIQAw==');

@$core.Deprecated('Use taskStateDescriptor instead')
const TaskState$json = {
  '1': 'TaskState',
  '2': [
    {'1': 'TASK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATE_PLANNED', '2': 1},
    {'1': 'TASK_STATE_DONE', '2': 2},
    {'1': 'TASK_STATE_MISSED', '2': 3},
    {'1': 'TASK_STATE_WAIVED', '2': 4},
  ],
};

/// Descriptor for `TaskState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStateDescriptor = $convert.base64Decode(
    'CglUYXNrU3RhdGUSGgoWVEFTS19TVEFURV9VTlNQRUNJRklFRBAAEhYKElRBU0tfU1RBVEVfUE'
    'xBTk5FRBABEhMKD1RBU0tfU1RBVEVfRE9ORRACEhUKEVRBU0tfU1RBVEVfTUlTU0VEEAMSFQoR'
    'VEFTS19TVEFURV9XQUlWRUQQBA==');

@$core.Deprecated('Use sourceDescriptor instead')
const Source$json = {
  '1': 'Source',
  '2': [
    {'1': 'SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'SOURCE_MANUAL', '2': 1},
    {'1': 'SOURCE_SCADA', '2': 2},
    {'1': 'SOURCE_BMS', '2': 3},
    {'1': 'SOURCE_AMI', '2': 4},
    {'1': 'SOURCE_VENDOR', '2': 5},
    {'1': 'SOURCE_CALCULATED', '2': 6},
  ],
};

/// Descriptor for `Source`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceDescriptor = $convert.base64Decode(
    'CgZTb3VyY2USFgoSU09VUkNFX1VOU1BFQ0lGSUVEEAASEQoNU09VUkNFX01BTlVBTBABEhAKDF'
    'NPVVJDRV9TQ0FEQRACEg4KClNPVVJDRV9CTVMQAxIOCgpTT1VSQ0VfQU1JEAQSEQoNU09VUkNF'
    'X1ZFTkRPUhAFEhUKEVNPVVJDRV9DQUxDVUxBVEVEEAY=');

@$core.Deprecated('Use utilityDescriptor instead')
const Utility$json = {
  '1': 'Utility',
  '2': [
    {'1': 'UTILITY_UNSPECIFIED', '2': 0},
    {'1': 'UTILITY_ELECTRICITY', '2': 1},
    {'1': 'UTILITY_WATER', '2': 2},
    {'1': 'UTILITY_DIESEL', '2': 3},
    {'1': 'UTILITY_OXYGEN', '2': 4},
    {'1': 'UTILITY_LPG', '2': 5},
    {'1': 'UTILITY_STEAM', '2': 6},
    {'1': 'UTILITY_EFFLUENT', '2': 7},
  ],
};

/// Descriptor for `Utility`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List utilityDescriptor = $convert.base64Decode(
    'CgdVdGlsaXR5EhcKE1VUSUxJVFlfVU5TUEVDSUZJRUQQABIXChNVVElMSVRZX0VMRUNUUklDSV'
    'RZEAESEQoNVVRJTElUWV9XQVRFUhACEhIKDlVUSUxJVFlfRElFU0VMEAMSEgoOVVRJTElUWV9P'
    'WFlHRU4QBBIPCgtVVElMSVRZX0xQRxAFEhEKDVVUSUxJVFlfU1RFQU0QBhIUChBVVElMSVRZX0'
    'VGRkxVRU5UEAc=');

@$core.Deprecated('Use outageStateDescriptor instead')
const OutageState$json = {
  '1': 'OutageState',
  '2': [
    {'1': 'OUTAGE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'OUTAGE_STATE_PLANNED', '2': 1},
    {'1': 'OUTAGE_STATE_APPROVED', '2': 2},
    {'1': 'OUTAGE_STATE_IN_EFFECT', '2': 3},
    {'1': 'OUTAGE_STATE_RESTORED', '2': 4},
    {'1': 'OUTAGE_STATE_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `OutageState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List outageStateDescriptor = $convert.base64Decode(
    'CgtPdXRhZ2VTdGF0ZRIcChhPVVRBR0VfU1RBVEVfVU5TUEVDSUZJRUQQABIYChRPVVRBR0VfU1'
    'RBVEVfUExBTk5FRBABEhkKFU9VVEFHRV9TVEFURV9BUFBST1ZFRBACEhoKFk9VVEFHRV9TVEFU'
    'RV9JTl9FRkZFQ1QQAxIZChVPVVRBR0VfU1RBVEVfUkVTVE9SRUQQBBIaChZPVVRBR0VfU1RBVE'
    'VfQ0FOQ0VMTEVEEAU=');

@$core.Deprecated('Use severityDescriptor instead')
const Severity$json = {
  '1': 'Severity',
  '2': [
    {'1': 'SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'SEVERITY_CRITICAL', '2': 1},
    {'1': 'SEVERITY_MAJOR', '2': 2},
    {'1': 'SEVERITY_MINOR', '2': 3},
    {'1': 'SEVERITY_INFO', '2': 4},
  ],
};

/// Descriptor for `Severity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List severityDescriptor = $convert.base64Decode(
    'CghTZXZlcml0eRIYChRTRVZFUklUWV9VTlNQRUNJRklFRBAAEhUKEVNFVkVSSVRZX0NSSVRJQ0'
    'FMEAESEgoOU0VWRVJJVFlfTUFKT1IQAhISCg5TRVZFUklUWV9NSU5PUhADEhEKDVNFVkVSSVRZ'
    'X0lORk8QBA==');

@$core.Deprecated('Use alarmStateDescriptor instead')
const AlarmState$json = {
  '1': 'AlarmState',
  '2': [
    {'1': 'ALARM_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ALARM_STATE_ACTIVE', '2': 1},
    {'1': 'ALARM_STATE_CLEARED', '2': 2},
  ],
};

/// Descriptor for `AlarmState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alarmStateDescriptor = $convert.base64Decode(
    'CgpBbGFybVN0YXRlEhsKF0FMQVJNX1NUQVRFX1VOU1BFQ0lGSUVEEAASFgoSQUxBUk1fU1RBVE'
    'VfQUNUSVZFEAESFwoTQUxBUk1fU1RBVEVfQ0xFQVJFRBAC');

@$core.Deprecated('Use deficiencyStateDescriptor instead')
const DeficiencyState$json = {
  '1': 'DeficiencyState',
  '2': [
    {'1': 'DEFICIENCY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DEFICIENCY_STATE_OPEN', '2': 1},
    {'1': 'DEFICIENCY_STATE_MITIGATED', '2': 2},
    {'1': 'DEFICIENCY_STATE_CLOSED', '2': 3},
  ],
};

/// Descriptor for `DeficiencyState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deficiencyStateDescriptor = $convert.base64Decode(
    'Cg9EZWZpY2llbmN5U3RhdGUSIAocREVGSUNJRU5DWV9TVEFURV9VTlNQRUNJRklFRBAAEhkKFU'
    'RFRklDSUVOQ1lfU1RBVEVfT1BFThABEh4KGkRFRklDSUVOQ1lfU1RBVEVfTUlUSUdBVEVEEAIS'
    'GwoXREVGSUNJRU5DWV9TVEFURV9DTE9TRUQQAw==');

@$core.Deprecated('Use visitStateDescriptor instead')
const VisitState$json = {
  '1': 'VisitState',
  '2': [
    {'1': 'VISIT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'VISIT_STATE_ON_SITE', '2': 1},
    {'1': 'VISIT_STATE_DEPARTED', '2': 2},
  ],
};

/// Descriptor for `VisitState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visitStateDescriptor = $convert.base64Decode(
    'CgpWaXNpdFN0YXRlEhsKF1ZJU0lUX1NUQVRFX1VOU1BFQ0lGSUVEEAASFwoTVklTSVRfU1RBVE'
    'VfT05fU0lURRABEhgKFFZJU0lUX1NUQVRFX0RFUEFSVEVEEAI=');

@$core.Deprecated('Use assetDescriptor instead')
const Asset$json = {
  '1': 'Asset',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'tag', '3': 2, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'system',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'criticality',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Criticality',
      '10': 'criticality'
    },
    {'1': 'parent_id', '3': 6, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'facility_id', '3': 7, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 8, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 9, '4': 1, '5': 9, '10': 'locationNote'},
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'status_reason', '3': 11, '4': 1, '5': 9, '10': 'statusReason'},
    {
      '1': 'status_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'statusAt'
    },
    {'1': 'manufacturer', '3': 13, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 14, '4': 1, '5': 9, '10': 'model'},
    {'1': 'serial_number', '3': 15, '4': 1, '5': 9, '10': 'serialNumber'},
    {
      '1': 'commissioned_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'commissionedAt'
    },
    {'1': 'runtime_hours', '3': 17, '4': 1, '5': 5, '10': 'runtimeHours'},
    {
      '1': 'runtime_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'runtimeAt'
    },
    {
      '1': 'created_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 20, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 21, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Asset`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetDescriptor = $convert.base64Decode(
    'CgVBc3NldBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIQCgN0YWcYAiABKAlSA3RhZxISCg'
    'RuYW1lGAMgASgJUgRuYW1lEjgKBnN5c3RlbRgEIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGll'
    'cy52MS5TeXN0ZW1SBnN5c3RlbRJHCgtjcml0aWNhbGl0eRgFIAEoDjIlLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5Dcml0aWNhbGl0eVILY3JpdGljYWxpdHkSGwoJcGFyZW50X2lkGAYgASgJ'
    'UghwYXJlbnRJZBIfCgtmYWNpbGl0eV9pZBgHIAEoCVIKZmFjaWxpdHlJZBIfCgtsb2NhdGlvbl'
    '9pZBgIIAEoCVIKbG9jYXRpb25JZBIjCg1sb2NhdGlvbl9ub3RlGAkgASgJUgxsb2NhdGlvbk5v'
    'dGUSPQoGc3RhdHVzGAogASgOMiUuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFzc2V0U3RhdH'
    'VzUgZzdGF0dXMSIwoNc3RhdHVzX3JlYXNvbhgLIAEoCVIMc3RhdHVzUmVhc29uEjcKCXN0YXR1'
    'c19hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YXR1c0F0EiIKDG1hbn'
    'VmYWN0dXJlchgNIAEoCVIMbWFudWZhY3R1cmVyEhQKBW1vZGVsGA4gASgJUgVtb2RlbBIjCg1z'
    'ZXJpYWxfbnVtYmVyGA8gASgJUgxzZXJpYWxOdW1iZXISQwoPY29tbWlzc2lvbmVkX2F0GBAgAS'
    'gLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOY29tbWlzc2lvbmVkQXQSIwoNcnVudGlt'
    'ZV9ob3VycxgRIAEoBVIMcnVudGltZUhvdXJzEjkKCnJ1bnRpbWVfYXQYEiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUglydW50aW1lQXQSOQoKY3JlYXRlZF9hdBgTIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GBQgASgJUg'
    'ljcmVhdGVkQnkSGAoHdmVyc2lvbhgVIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use registerAssetRequestDescriptor instead')
const RegisterAssetRequest$json = {
  '1': 'RegisterAssetRequest',
  '2': [
    {'1': 'tag', '3': 1, '4': 1, '5': 9, '10': 'tag'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'system',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'criticality',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Criticality',
      '10': 'criticality'
    },
    {'1': 'parent_id', '3': 5, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 7, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 8, '4': 1, '5': 9, '10': 'locationNote'},
    {'1': 'manufacturer', '3': 9, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 10, '4': 1, '5': 9, '10': 'model'},
    {'1': 'serial_number', '3': 11, '4': 1, '5': 9, '10': 'serialNumber'},
    {
      '1': 'commissioned_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'commissionedAt'
    },
  ],
};

/// Descriptor for `RegisterAssetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerAssetRequestDescriptor = $convert.base64Decode(
    'ChRSZWdpc3RlckFzc2V0UmVxdWVzdBIQCgN0YWcYASABKAlSA3RhZxISCgRuYW1lGAIgASgJUg'
    'RuYW1lEjgKBnN5c3RlbRgDIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TeXN0ZW1S'
    'BnN5c3RlbRJHCgtjcml0aWNhbGl0eRgEIAEoDjIlLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS'
    '5Dcml0aWNhbGl0eVILY3JpdGljYWxpdHkSGwoJcGFyZW50X2lkGAUgASgJUghwYXJlbnRJZBIf'
    'CgtmYWNpbGl0eV9pZBgGIAEoCVIKZmFjaWxpdHlJZBIfCgtsb2NhdGlvbl9pZBgHIAEoCVIKbG'
    '9jYXRpb25JZBIjCg1sb2NhdGlvbl9ub3RlGAggASgJUgxsb2NhdGlvbk5vdGUSIgoMbWFudWZh'
    'Y3R1cmVyGAkgASgJUgxtYW51ZmFjdHVyZXISFAoFbW9kZWwYCiABKAlSBW1vZGVsEiMKDXNlcm'
    'lhbF9udW1iZXIYCyABKAlSDHNlcmlhbE51bWJlchJDCg9jb21taXNzaW9uZWRfYXQYDCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5jb21taXNzaW9uZWRBdA==');

@$core.Deprecated('Use registerAssetResponseDescriptor instead')
const RegisterAssetResponse$json = {
  '1': 'RegisterAssetResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `RegisterAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerAssetResponseDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlckFzc2V0UmVzcG9uc2USNQoFYXNzZXQYASABKAsyHy5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuQXNzZXRSBWFzc2V0');

@$core.Deprecated('Use setAssetStatusRequestDescriptor instead')
const SetAssetStatusRequest$json = {
  '1': 'SetAssetStatusRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SetAssetStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAssetStatusRequestDescriptor = $convert.base64Decode(
    'ChVTZXRBc3NldFN0YXR1c1JlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSPQoGc3'
    'RhdHVzGAIgASgOMiUuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFzc2V0U3RhdHVzUgZzdGF0'
    'dXMSFgoGcmVhc29uGAMgASgJUgZyZWFzb24SGAoHdmVyc2lvbhgEIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use setAssetStatusResponseDescriptor instead')
const SetAssetStatusResponse$json = {
  '1': 'SetAssetStatusResponse',
  '2': [
    {
      '1': 'asset',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `SetAssetStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAssetStatusResponseDescriptor =
    $convert.base64Decode(
        'ChZTZXRBc3NldFN0YXR1c1Jlc3BvbnNlEjUKBWFzc2V0GAEgASgLMh8uaGVhbHRoY2FyZS5mYW'
        'NpbGl0aWVzLnYxLkFzc2V0UgVhc3NldA==');

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
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'asset'
    },
  ],
};

/// Descriptor for `GetAssetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetResponseDescriptor = $convert.base64Decode(
    'ChBHZXRBc3NldFJlc3BvbnNlEjUKBWFzc2V0GAEgASgLMh8uaGVhbHRoY2FyZS5mYWNpbGl0aW'
    'VzLnYxLkFzc2V0UgVhc3NldA==');

@$core.Deprecated('Use listAssetsRequestDescriptor instead')
const ListAssetsRequest$json = {
  '1': 'ListAssetsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.AssetStatus',
      '10': 'status'
    },
    {'1': 'parent_id', '3': 4, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QXNzZXRzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZBI4Cg'
    'ZzeXN0ZW0YAiABKA4yIC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3lzdGVtUgZzeXN0ZW0S'
    'PQoGc3RhdHVzGAMgASgOMiUuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFzc2V0U3RhdHVzUg'
    'ZzdGF0dXMSGwoJcGFyZW50X2lkGAQgASgJUghwYXJlbnRJZBIbCglwYWdlX3NpemUYBSABKAVS'
    'CHBhZ2VTaXpl');

@$core.Deprecated('Use listAssetsResponseDescriptor instead')
const ListAssetsResponse$json = {
  '1': 'ListAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `ListAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QXNzZXRzUmVzcG9uc2USNwoGYXNzZXRzGAEgAygLMh8uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLkFzc2V0UgZhc3NldHM=');

@$core.Deprecated('Use getAssetTreeRequestDescriptor instead')
const GetAssetTreeRequest$json = {
  '1': 'GetAssetTreeRequest',
  '2': [
    {'1': 'root_id', '3': 1, '4': 1, '5': 9, '10': 'rootId'},
  ],
};

/// Descriptor for `GetAssetTreeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetTreeRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRBc3NldFRyZWVSZXF1ZXN0EhcKB3Jvb3RfaWQYASABKAlSBnJvb3RJZA==');

@$core.Deprecated('Use getAssetTreeResponseDescriptor instead')
const GetAssetTreeResponse$json = {
  '1': 'GetAssetTreeResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `GetAssetTreeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetTreeResponseDescriptor = $convert.base64Decode(
    'ChRHZXRBc3NldFRyZWVSZXNwb25zZRI3CgZhc3NldHMYASADKAsyHy5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuQXNzZXRSBmFzc2V0cw==');

@$core.Deprecated('Use listDownAssetsRequestDescriptor instead')
const ListDownAssetsRequest$json = {
  '1': 'ListDownAssetsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListDownAssetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDownAssetsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RG93bkFzc2V0c1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SW'
    'Q=');

@$core.Deprecated('Use listDownAssetsResponseDescriptor instead')
const ListDownAssetsResponse$json = {
  '1': 'ListDownAssetsResponse',
  '2': [
    {
      '1': 'assets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Asset',
      '10': 'assets'
    },
  ],
};

/// Descriptor for `ListDownAssetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDownAssetsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RG93bkFzc2V0c1Jlc3BvbnNlEjcKBmFzc2V0cxgBIAMoCzIfLmhlYWx0aGNhcmUuZm'
        'FjaWxpdGllcy52MS5Bc3NldFIGYXNzZXRz');

@$core.Deprecated('Use workClassDescriptor instead')
const WorkClass$json = {
  '1': 'WorkClass',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'requires_permit', '3': 3, '4': 1, '5': 8, '10': 'requiresPermit'},
    {'1': 'requires_loto', '3': 4, '4': 1, '5': 8, '10': 'requiresLoto'},
    {'1': 'active', '3': 5, '4': 1, '5': 8, '10': 'active'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `WorkClass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workClassDescriptor = $convert.base64Decode(
    'CglXb3JrQ2xhc3MSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgASgJUgRuYW1lEicKD3'
    'JlcXVpcmVzX3Blcm1pdBgDIAEoCFIOcmVxdWlyZXNQZXJtaXQSIwoNcmVxdWlyZXNfbG90bxgE'
    'IAEoCFIMcmVxdWlyZXNMb3RvEhYKBmFjdGl2ZRgFIAEoCFIGYWN0aXZlEhIKBG5vdGUYBiABKA'
    'lSBG5vdGU=');

@$core.Deprecated('Use setWorkClassRequestDescriptor instead')
const SetWorkClassRequest$json = {
  '1': 'SetWorkClassRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'requires_permit', '3': 3, '4': 1, '5': 8, '10': 'requiresPermit'},
    {'1': 'requires_loto', '3': 4, '4': 1, '5': 8, '10': 'requiresLoto'},
    {'1': 'active', '3': 5, '4': 1, '5': 8, '10': 'active'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `SetWorkClassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setWorkClassRequestDescriptor = $convert.base64Decode(
    'ChNTZXRXb3JrQ2xhc3NSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZRgCIAEoCV'
    'IEbmFtZRInCg9yZXF1aXJlc19wZXJtaXQYAyABKAhSDnJlcXVpcmVzUGVybWl0EiMKDXJlcXVp'
    'cmVzX2xvdG8YBCABKAhSDHJlcXVpcmVzTG90bxIWCgZhY3RpdmUYBSABKAhSBmFjdGl2ZRISCg'
    'Rub3RlGAYgASgJUgRub3Rl');

@$core.Deprecated('Use setWorkClassResponseDescriptor instead')
const SetWorkClassResponse$json = {
  '1': 'SetWorkClassResponse',
  '2': [
    {
      '1': 'work_class',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkClass',
      '10': 'workClass'
    },
  ],
};

/// Descriptor for `SetWorkClassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setWorkClassResponseDescriptor = $convert.base64Decode(
    'ChRTZXRXb3JrQ2xhc3NSZXNwb25zZRJCCgp3b3JrX2NsYXNzGAEgASgLMiMuaGVhbHRoY2FyZS'
    '5mYWNpbGl0aWVzLnYxLldvcmtDbGFzc1IJd29ya0NsYXNz');

@$core.Deprecated('Use listWorkClassesRequestDescriptor instead')
const ListWorkClassesRequest$json = {
  '1': 'ListWorkClassesRequest',
};

/// Descriptor for `ListWorkClassesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkClassesRequestDescriptor =
    $convert.base64Decode('ChZMaXN0V29ya0NsYXNzZXNSZXF1ZXN0');

@$core.Deprecated('Use listWorkClassesResponseDescriptor instead')
const ListWorkClassesResponse$json = {
  '1': 'ListWorkClassesResponse',
  '2': [
    {
      '1': 'work_classes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkClass',
      '10': 'workClasses'
    },
  ],
};

/// Descriptor for `ListWorkClassesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkClassesResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0V29ya0NsYXNzZXNSZXNwb25zZRJGCgx3b3JrX2NsYXNzZXMYASADKAsyIy5oZWFsdG'
        'hjYXJlLmZhY2lsaXRpZXMudjEuV29ya0NsYXNzUgt3b3JrQ2xhc3Nlcw==');

@$core.Deprecated('Use workOrderDescriptor instead')
const WorkOrder$json = {
  '1': 'WorkOrder',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'asset_id', '3': 4, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'system',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'location_id', '3': 6, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 7, '4': 1, '5': 9, '10': 'locationNote'},
    {'1': 'fault', '3': 8, '4': 1, '5': 9, '10': 'fault'},
    {'1': 'impact', '3': 9, '4': 1, '5': 9, '10': 'impact'},
    {
      '1': 'priority',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Priority',
      '10': 'priority'
    },
    {'1': 'class_code', '3': 11, '4': 1, '5': 9, '10': 'classCode'},
    {
      '1': 'class_requires_permit',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'classRequiresPermit'
    },
    {
      '1': 'class_requires_loto',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'classRequiresLoto'
    },
    {'1': 'owner_team', '3': 14, '4': 1, '5': 9, '10': 'ownerTeam'},
    {'1': 'owner_user_id', '3': 15, '4': 1, '5': 9, '10': 'ownerUserId'},
    {
      '1': 'state',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.WorkState',
      '10': 'state'
    },
    {
      '1': 'raised_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 18, '4': 1, '5': 9, '10': 'raisedBy'},
    {
      '1': 'respond_by',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondBy'
    },
    {
      '1': 'resolve_by',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolveBy'
    },
    {
      '1': 'responded_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondedAt'
    },
    {
      '1': 'started_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
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
    {'1': 'permit_ref', '3': 26, '4': 1, '5': 9, '10': 'permitRef'},
    {'1': 'permit_issued_by', '3': 27, '4': 1, '5': 9, '10': 'permitIssuedBy'},
    {'1': 'loto_ref', '3': 28, '4': 1, '5': 9, '10': 'lotoRef'},
    {'1': 'loto_applied_by', '3': 29, '4': 1, '5': 9, '10': 'lotoAppliedBy'},
    {'1': 'completion_note', '3': 30, '4': 1, '5': 9, '10': 'completionNote'},
    {'1': 'root_cause', '3': 31, '4': 1, '5': 9, '10': 'rootCause'},
    {'1': 'downtime_minutes', '3': 32, '4': 1, '5': 5, '10': 'downtimeMinutes'},
    {'1': 'hold_reason', '3': 33, '4': 1, '5': 9, '10': 'holdReason'},
    {'1': 'cancel_reason', '3': 34, '4': 1, '5': 9, '10': 'cancelReason'},
    {'1': 'version', '3': 35, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `WorkOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workOrderDescriptor = $convert.base64Decode(
    'CglXb3JrT3JkZXISIgoNd29ya19vcmRlcl9pZBgBIAEoCVILd29ya09yZGVySWQSFgoGbnVtYm'
    'VyGAIgASgJUgZudW1iZXISHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSGQoIYXNz'
    'ZXRfaWQYBCABKAlSB2Fzc2V0SWQSOAoGc3lzdGVtGAUgASgOMiAuaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLlN5c3RlbVIGc3lzdGVtEh8KC2xvY2F0aW9uX2lkGAYgASgJUgpsb2NhdGlvbklk'
    'EiMKDWxvY2F0aW9uX25vdGUYByABKAlSDGxvY2F0aW9uTm90ZRIUCgVmYXVsdBgIIAEoCVIFZm'
    'F1bHQSFgoGaW1wYWN0GAkgASgJUgZpbXBhY3QSPgoIcHJpb3JpdHkYCiABKA4yIi5oZWFsdGhj'
    'YXJlLmZhY2lsaXRpZXMudjEuUHJpb3JpdHlSCHByaW9yaXR5Eh0KCmNsYXNzX2NvZGUYCyABKA'
    'lSCWNsYXNzQ29kZRIyChVjbGFzc19yZXF1aXJlc19wZXJtaXQYDCABKAhSE2NsYXNzUmVxdWly'
    'ZXNQZXJtaXQSLgoTY2xhc3NfcmVxdWlyZXNfbG90bxgNIAEoCFIRY2xhc3NSZXF1aXJlc0xvdG'
    '8SHQoKb3duZXJfdGVhbRgOIAEoCVIJb3duZXJUZWFtEiIKDW93bmVyX3VzZXJfaWQYDyABKAlS'
    'C293bmVyVXNlcklkEjkKBXN0YXRlGBAgASgOMiMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLl'
    'dvcmtTdGF0ZVIFc3RhdGUSNwoJcmFpc2VkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIIcmFpc2VkQXQSGwoJcmFpc2VkX2J5GBIgASgJUghyYWlzZWRCeRI5CgpyZXNwb2'
    '5kX2J5GBMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJcmVzcG9uZEJ5EjkKCnJl'
    'c29sdmVfYnkYFCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglyZXNvbHZlQnkSPQ'
    'oMcmVzcG9uZGVkX2F0GBUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVzcG9u'
    'ZGVkQXQSOQoKc3RhcnRlZF9hdBgWIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCX'
    'N0YXJ0ZWRBdBI7CgtyZXNvbHZlZF9hdBgXIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSCnJlc29sdmVkQXQSNwoJY2xvc2VkX2F0GBggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIIY2xvc2VkQXQSGwoJY2xvc2VkX2J5GBkgASgJUghjbG9zZWRCeRIdCgpwZXJtaXRf'
    'cmVmGBogASgJUglwZXJtaXRSZWYSKAoQcGVybWl0X2lzc3VlZF9ieRgbIAEoCVIOcGVybWl0SX'
    'NzdWVkQnkSGQoIbG90b19yZWYYHCABKAlSB2xvdG9SZWYSJgoPbG90b19hcHBsaWVkX2J5GB0g'
    'ASgJUg1sb3RvQXBwbGllZEJ5EicKD2NvbXBsZXRpb25fbm90ZRgeIAEoCVIOY29tcGxldGlvbk'
    '5vdGUSHQoKcm9vdF9jYXVzZRgfIAEoCVIJcm9vdENhdXNlEikKEGRvd250aW1lX21pbnV0ZXMY'
    'ICABKAVSD2Rvd250aW1lTWludXRlcxIfCgtob2xkX3JlYXNvbhghIAEoCVIKaG9sZFJlYXNvbh'
    'IjCg1jYW5jZWxfcmVhc29uGCIgASgJUgxjYW5jZWxSZWFzb24SGAoHdmVyc2lvbhgjIAEoA1IH'
    'dmVyc2lvbg==');

@$core.Deprecated('Use breachDescriptor instead')
const Breach$json = {
  '1': 'Breach',
  '2': [
    {'1': 'response', '3': 1, '4': 1, '5': 8, '10': 'response'},
    {'1': 'resolution', '3': 2, '4': 1, '5': 8, '10': 'resolution'},
    {
      '1': 'response_late_minutes',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'responseLateMinutes'
    },
    {
      '1': 'resolution_late_minutes',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'resolutionLateMinutes'
    },
  ],
};

/// Descriptor for `Breach`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List breachDescriptor = $convert.base64Decode(
    'CgZCcmVhY2gSGgoIcmVzcG9uc2UYASABKAhSCHJlc3BvbnNlEh4KCnJlc29sdXRpb24YAiABKA'
    'hSCnJlc29sdXRpb24SMgoVcmVzcG9uc2VfbGF0ZV9taW51dGVzGAMgASgFUhNyZXNwb25zZUxh'
    'dGVNaW51dGVzEjYKF3Jlc29sdXRpb25fbGF0ZV9taW51dGVzGAQgASgFUhVyZXNvbHV0aW9uTG'
    'F0ZU1pbnV0ZXM=');

@$core.Deprecated('Use raiseWorkRequestDescriptor instead')
const RaiseWorkRequest$json = {
  '1': 'RaiseWorkRequest',
  '2': [
    {'1': 'number', '3': 1, '4': 1, '5': 9, '10': 'number'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'system',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 6, '4': 1, '5': 9, '10': 'locationNote'},
    {'1': 'fault', '3': 7, '4': 1, '5': 9, '10': 'fault'},
    {'1': 'impact', '3': 8, '4': 1, '5': 9, '10': 'impact'},
    {
      '1': 'priority',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Priority',
      '10': 'priority'
    },
    {'1': 'class_code', '3': 10, '4': 1, '5': 9, '10': 'classCode'},
  ],
};

/// Descriptor for `RaiseWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseWorkRequestDescriptor = $convert.base64Decode(
    'ChBSYWlzZVdvcmtSZXF1ZXN0EhYKBm51bWJlchgBIAEoCVIGbnVtYmVyEh8KC2ZhY2lsaXR5X2'
    'lkGAIgASgJUgpmYWNpbGl0eUlkEhkKCGFzc2V0X2lkGAMgASgJUgdhc3NldElkEjgKBnN5c3Rl'
    'bRgEIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TeXN0ZW1SBnN5c3RlbRIfCgtsb2'
    'NhdGlvbl9pZBgFIAEoCVIKbG9jYXRpb25JZBIjCg1sb2NhdGlvbl9ub3RlGAYgASgJUgxsb2Nh'
    'dGlvbk5vdGUSFAoFZmF1bHQYByABKAlSBWZhdWx0EhYKBmltcGFjdBgIIAEoCVIGaW1wYWN0Ej'
    '4KCHByaW9yaXR5GAkgASgOMiIuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlByaW9yaXR5Ughw'
    'cmlvcml0eRIdCgpjbGFzc19jb2RlGAogASgJUgljbGFzc0NvZGU=');

@$core.Deprecated('Use raiseWorkResponseDescriptor instead')
const RaiseWorkResponse$json = {
  '1': 'RaiseWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `RaiseWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseWorkResponseDescriptor = $convert.base64Decode(
    'ChFSYWlzZVdvcmtSZXNwb25zZRJCCgp3b3JrX29yZGVyGAEgASgLMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtPcmRlclIJd29ya09yZGVy');

@$core.Deprecated('Use assignWorkRequestDescriptor instead')
const AssignWorkRequest$json = {
  '1': 'AssignWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'user_id', '3': 2, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'team', '3': 3, '4': 1, '5': 9, '10': 'team'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AssignWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignWorkRequestDescriptor = $convert.base64Decode(
    'ChFBc3NpZ25Xb3JrUmVxdWVzdBIiCg13b3JrX29yZGVyX2lkGAEgASgJUgt3b3JrT3JkZXJJZB'
    'IXCgd1c2VyX2lkGAIgASgJUgZ1c2VySWQSEgoEdGVhbRgDIAEoCVIEdGVhbRIYCgd2ZXJzaW9u'
    'GAQgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use assignWorkResponseDescriptor instead')
const AssignWorkResponse$json = {
  '1': 'AssignWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `AssignWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignWorkResponseDescriptor = $convert.base64Decode(
    'ChJBc3NpZ25Xb3JrUmVzcG9uc2USQgoKd29ya19vcmRlchgBIAEoCzIjLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5Xb3JrT3JkZXJSCXdvcmtPcmRlcg==');

@$core.Deprecated('Use startWorkRequestDescriptor instead')
const StartWorkRequest$json = {
  '1': 'StartWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'permit_ref', '3': 2, '4': 1, '5': 9, '10': 'permitRef'},
    {'1': 'permit_issued_by', '3': 3, '4': 1, '5': 9, '10': 'permitIssuedBy'},
    {'1': 'loto_ref', '3': 4, '4': 1, '5': 9, '10': 'lotoRef'},
    {'1': 'loto_applied_by', '3': 5, '4': 1, '5': 9, '10': 'lotoAppliedBy'},
    {'1': 'version', '3': 6, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `StartWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWorkRequestDescriptor = $convert.base64Decode(
    'ChBTdGFydFdvcmtSZXF1ZXN0EiIKDXdvcmtfb3JkZXJfaWQYASABKAlSC3dvcmtPcmRlcklkEh'
    '0KCnBlcm1pdF9yZWYYAiABKAlSCXBlcm1pdFJlZhIoChBwZXJtaXRfaXNzdWVkX2J5GAMgASgJ'
    'Ug5wZXJtaXRJc3N1ZWRCeRIZCghsb3RvX3JlZhgEIAEoCVIHbG90b1JlZhImCg9sb3RvX2FwcG'
    'xpZWRfYnkYBSABKAlSDWxvdG9BcHBsaWVkQnkSGAoHdmVyc2lvbhgGIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use startWorkResponseDescriptor instead')
const StartWorkResponse$json = {
  '1': 'StartWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `StartWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startWorkResponseDescriptor = $convert.base64Decode(
    'ChFTdGFydFdvcmtSZXNwb25zZRJCCgp3b3JrX29yZGVyGAEgASgLMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtPcmRlclIJd29ya09yZGVy');

@$core.Deprecated('Use holdWorkRequestDescriptor instead')
const HoldWorkRequest$json = {
  '1': 'HoldWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `HoldWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdWorkRequestDescriptor = $convert.base64Decode(
    'Cg9Ib2xkV29ya1JlcXVlc3QSIgoNd29ya19vcmRlcl9pZBgBIAEoCVILd29ya09yZGVySWQSFg'
    'oGcmVhc29uGAIgASgJUgZyZWFzb24SGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use holdWorkResponseDescriptor instead')
const HoldWorkResponse$json = {
  '1': 'HoldWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `HoldWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdWorkResponseDescriptor = $convert.base64Decode(
    'ChBIb2xkV29ya1Jlc3BvbnNlEkIKCndvcmtfb3JkZXIYASABKAsyIy5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuV29ya09yZGVyUgl3b3JrT3JkZXI=');

@$core.Deprecated('Use resolveWorkRequestDescriptor instead')
const ResolveWorkRequest$json = {
  '1': 'ResolveWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'root_cause', '3': 3, '4': 1, '5': 9, '10': 'rootCause'},
    {'1': 'downtime_minutes', '3': 4, '4': 1, '5': 5, '10': 'downtimeMinutes'},
    {'1': 'version', '3': 5, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ResolveWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveWorkRequestDescriptor = $convert.base64Decode(
    'ChJSZXNvbHZlV29ya1JlcXVlc3QSIgoNd29ya19vcmRlcl9pZBgBIAEoCVILd29ya09yZGVySW'
    'QSEgoEbm90ZRgCIAEoCVIEbm90ZRIdCgpyb290X2NhdXNlGAMgASgJUglyb290Q2F1c2USKQoQ'
    'ZG93bnRpbWVfbWludXRlcxgEIAEoBVIPZG93bnRpbWVNaW51dGVzEhgKB3ZlcnNpb24YBSABKA'
    'NSB3ZlcnNpb24=');

@$core.Deprecated('Use resolveWorkResponseDescriptor instead')
const ResolveWorkResponse$json = {
  '1': 'ResolveWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `ResolveWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveWorkResponseDescriptor = $convert.base64Decode(
    'ChNSZXNvbHZlV29ya1Jlc3BvbnNlEkIKCndvcmtfb3JkZXIYASABKAsyIy5oZWFsdGhjYXJlLm'
    'ZhY2lsaXRpZXMudjEuV29ya09yZGVyUgl3b3JrT3JkZXI=');

@$core.Deprecated('Use closeWorkRequestDescriptor instead')
const CloseWorkRequest$json = {
  '1': 'CloseWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CloseWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeWorkRequestDescriptor = $convert.base64Decode(
    'ChBDbG9zZVdvcmtSZXF1ZXN0EiIKDXdvcmtfb3JkZXJfaWQYASABKAlSC3dvcmtPcmRlcklkEh'
    'gKB3ZlcnNpb24YAiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use closeWorkResponseDescriptor instead')
const CloseWorkResponse$json = {
  '1': 'CloseWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `CloseWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeWorkResponseDescriptor = $convert.base64Decode(
    'ChFDbG9zZVdvcmtSZXNwb25zZRJCCgp3b3JrX29yZGVyGAEgASgLMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtPcmRlclIJd29ya09yZGVy');

@$core.Deprecated('Use cancelWorkRequestDescriptor instead')
const CancelWorkRequest$json = {
  '1': 'CancelWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CancelWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelWorkRequestDescriptor = $convert.base64Decode(
    'ChFDYW5jZWxXb3JrUmVxdWVzdBIiCg13b3JrX29yZGVyX2lkGAEgASgJUgt3b3JrT3JkZXJJZB'
    'IWCgZyZWFzb24YAiABKAlSBnJlYXNvbhIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use cancelWorkResponseDescriptor instead')
const CancelWorkResponse$json = {
  '1': 'CancelWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
  ],
};

/// Descriptor for `CancelWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelWorkResponseDescriptor = $convert.base64Decode(
    'ChJDYW5jZWxXb3JrUmVzcG9uc2USQgoKd29ya19vcmRlchgBIAEoCzIjLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5Xb3JrT3JkZXJSCXdvcmtPcmRlcg==');

@$core.Deprecated('Use getWorkRequestDescriptor instead')
const GetWorkRequest$json = {
  '1': 'GetWorkRequest',
  '2': [
    {'1': 'work_order_id', '3': 1, '4': 1, '5': 9, '10': 'workOrderId'},
  ],
};

/// Descriptor for `GetWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorkRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRXb3JrUmVxdWVzdBIiCg13b3JrX29yZGVyX2lkGAEgASgJUgt3b3JrT3JkZXJJZA==');

@$core.Deprecated('Use getWorkResponseDescriptor instead')
const GetWorkResponse$json = {
  '1': 'GetWorkResponse',
  '2': [
    {
      '1': 'work_order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
    {
      '1': 'breach',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Breach',
      '10': 'breach'
    },
  ],
};

/// Descriptor for `GetWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorkResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRXb3JrUmVzcG9uc2USQgoKd29ya19vcmRlchgBIAEoCzIjLmhlYWx0aGNhcmUuZmFjaW'
    'xpdGllcy52MS5Xb3JrT3JkZXJSCXdvcmtPcmRlchI4CgZicmVhY2gYAiABKAsyIC5oZWFsdGhj'
    'YXJlLmZhY2lsaXRpZXMudjEuQnJlYWNoUgZicmVhY2g=');

@$core.Deprecated('Use listWorkRequestDescriptor instead')
const ListWorkRequest$json = {
  '1': 'ListWorkRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'system',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.WorkState',
      '10': 'state'
    },
    {'1': 'open_only', '3': 5, '4': 1, '5': 8, '10': 'openOnly'},
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
  ],
};

/// Descriptor for `ListWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0V29ya1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSGQoIYX'
    'NzZXRfaWQYAiABKAlSB2Fzc2V0SWQSOAoGc3lzdGVtGAMgASgOMiAuaGVhbHRoY2FyZS5mYWNp'
    'bGl0aWVzLnYxLlN5c3RlbVIGc3lzdGVtEjkKBXN0YXRlGAQgASgOMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtTdGF0ZVIFc3RhdGUSGwoJb3Blbl9vbmx5GAUgASgIUghvcGVuT25s'
    'eRIuCgRmcm9tGAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bx'
    'gHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgIIAEo'
    'BVIIcGFnZVNpemU=');

@$core.Deprecated('Use listWorkResponseDescriptor instead')
const ListWorkResponse$json = {
  '1': 'ListWorkResponse',
  '2': [
    {
      '1': 'work_orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrders'
    },
  ],
};

/// Descriptor for `ListWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWorkResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0V29ya1Jlc3BvbnNlEkQKC3dvcmtfb3JkZXJzGAEgAygLMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtPcmRlclIKd29ya09yZGVycw==');

@$core.Deprecated('Use getWorklistRequestDescriptor instead')
const GetWorklistRequest$json = {
  '1': 'GetWorklistRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetWorklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistRequestDescriptor = $convert.base64Decode(
    'ChJHZXRXb3JrbGlzdFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getWorklistResponseDescriptor instead')
const GetWorklistResponse$json = {
  '1': 'GetWorklistResponse',
  '2': [
    {
      '1': 'work_orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrders'
    },
  ],
};

/// Descriptor for `GetWorklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistResponseDescriptor = $convert.base64Decode(
    'ChNHZXRXb3JrbGlzdFJlc3BvbnNlEkQKC3dvcmtfb3JkZXJzGAEgAygLMiMuaGVhbHRoY2FyZS'
    '5mYWNpbGl0aWVzLnYxLldvcmtPcmRlclIKd29ya09yZGVycw==');

@$core.Deprecated('Use scheduleDescriptor instead')
const Schedule$json = {
  '1': 'Schedule',
  '2': [
    {'1': 'schedule_id', '3': 1, '4': 1, '5': 9, '10': 'scheduleId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.MaintenanceKind',
      '10': 'kind'
    },
    {
      '1': 'trigger',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Trigger',
      '10': 'trigger'
    },
    {'1': 'interval_days', '3': 7, '4': 1, '5': 5, '10': 'intervalDays'},
    {
      '1': 'interval_runtime_hours',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'intervalRuntimeHours'
    },
    {'1': 'authority', '3': 9, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'requires_evidence',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'requiresEvidence'
    },
    {'1': 'work_class_code', '3': 11, '4': 1, '5': 9, '10': 'workClassCode'},
    {'1': 'grace_days', '3': 12, '4': 1, '5': 5, '10': 'graceDays'},
    {'1': 'active', '3': 13, '4': 1, '5': 8, '10': 'active'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Schedule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleDescriptor = $convert.base64Decode(
    'CghTY2hlZHVsZRIfCgtzY2hlZHVsZV9pZBgBIAEoCVIKc2NoZWR1bGVJZBIZCghhc3NldF9pZB'
    'gCIAEoCVIHYXNzZXRJZBIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBIUCgV0aXRs'
    'ZRgEIAEoCVIFdGl0bGUSPQoEa2luZBgFIAEoDjIpLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS'
    '5NYWludGVuYW5jZUtpbmRSBGtpbmQSOwoHdHJpZ2dlchgGIAEoDjIhLmhlYWx0aGNhcmUuZmFj'
    'aWxpdGllcy52MS5UcmlnZ2VyUgd0cmlnZ2VyEiMKDWludGVydmFsX2RheXMYByABKAVSDGludG'
    'VydmFsRGF5cxI0ChZpbnRlcnZhbF9ydW50aW1lX2hvdXJzGAggASgFUhRpbnRlcnZhbFJ1bnRp'
    'bWVIb3VycxIcCglhdXRob3JpdHkYCSABKAlSCWF1dGhvcml0eRIrChFyZXF1aXJlc19ldmlkZW'
    '5jZRgKIAEoCFIQcmVxdWlyZXNFdmlkZW5jZRImCg93b3JrX2NsYXNzX2NvZGUYCyABKAlSDXdv'
    'cmtDbGFzc0NvZGUSHQoKZ3JhY2VfZGF5cxgMIAEoBVIJZ3JhY2VEYXlzEhYKBmFjdGl2ZRgNIA'
    'EoCFIGYWN0aXZlEhgKB3ZlcnNpb24YDiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'schedule_id', '3': 2, '4': 1, '5': 9, '10': 'scheduleId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'schedule_kind',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.MaintenanceKind',
      '10': 'scheduleKind'
    },
    {
      '1': 'schedule_requires_evidence',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'scheduleRequiresEvidence'
    },
    {
      '1': 'due_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'due_runtime_hours', '3': 9, '4': 1, '5': 5, '10': 'dueRuntimeHours'},
    {
      '1': 'triggered_by',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Trigger',
      '10': 'triggeredBy'
    },
    {
      '1': 'state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.TaskState',
      '10': 'state'
    },
    {
      '1': 'done_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'doneAt'
    },
    {'1': 'done_by', '3': 13, '4': 1, '5': 9, '10': 'doneBy'},
    {'1': 'findings', '3': 14, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'evidence_ref', '3': 15, '4': 1, '5': 9, '10': 'evidenceRef'},
    {'1': 'certificate_ref', '3': 16, '4': 1, '5': 9, '10': 'certificateRef'},
    {
      '1': 'certificate_expires_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'certificateExpiresAt'
    },
    {'1': 'waived_reason', '3': 18, '4': 1, '5': 9, '10': 'waivedReason'},
    {'1': 'work_order_id', '3': 19, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIfCgtzY2hlZHVsZV9pZBgCIAEoCVIKc2'
    'NoZWR1bGVJZBIZCghhc3NldF9pZBgDIAEoCVIHYXNzZXRJZBIfCgtmYWNpbGl0eV9pZBgEIAEo'
    'CVIKZmFjaWxpdHlJZBIUCgV0aXRsZRgFIAEoCVIFdGl0bGUSTgoNc2NoZWR1bGVfa2luZBgGIA'
    'EoDjIpLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5NYWludGVuYW5jZUtpbmRSDHNjaGVkdWxl'
    'S2luZBI8ChpzY2hlZHVsZV9yZXF1aXJlc19ldmlkZW5jZRgHIAEoCFIYc2NoZWR1bGVSZXF1aX'
    'Jlc0V2aWRlbmNlEjEKBmR1ZV9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'BWR1ZUF0EioKEWR1ZV9ydW50aW1lX2hvdXJzGAkgASgFUg9kdWVSdW50aW1lSG91cnMSRAoMdH'
    'JpZ2dlcmVkX2J5GAogASgOMiEuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlRyaWdnZXJSC3Ry'
    'aWdnZXJlZEJ5EjkKBXN0YXRlGAsgASgOMiMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlRhc2'
    'tTdGF0ZVIFc3RhdGUSMwoHZG9uZV9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSBmRvbmVBdBIXCgdkb25lX2J5GA0gASgJUgZkb25lQnkSGgoIZmluZGluZ3MYDiABKAlSCG'
    'ZpbmRpbmdzEiEKDGV2aWRlbmNlX3JlZhgPIAEoCVILZXZpZGVuY2VSZWYSJwoPY2VydGlmaWNh'
    'dGVfcmVmGBAgASgJUg5jZXJ0aWZpY2F0ZVJlZhJQChZjZXJ0aWZpY2F0ZV9leHBpcmVzX2F0GB'
    'EgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIUY2VydGlmaWNhdGVFeHBpcmVzQXQS'
    'IwoNd2FpdmVkX3JlYXNvbhgSIAEoCVIMd2FpdmVkUmVhc29uEiIKDXdvcmtfb3JkZXJfaWQYEy'
    'ABKAlSC3dvcmtPcmRlcklkEhgKB3ZlcnNpb24YFCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use addScheduleRequestDescriptor instead')
const AddScheduleRequest$json = {
  '1': 'AddScheduleRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.MaintenanceKind',
      '10': 'kind'
    },
    {
      '1': 'trigger',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Trigger',
      '10': 'trigger'
    },
    {'1': 'interval_days', '3': 6, '4': 1, '5': 5, '10': 'intervalDays'},
    {
      '1': 'interval_runtime_hours',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'intervalRuntimeHours'
    },
    {'1': 'authority', '3': 8, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'requires_evidence',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'requiresEvidence'
    },
    {'1': 'work_class_code', '3': 10, '4': 1, '5': 9, '10': 'workClassCode'},
    {'1': 'grace_days', '3': 11, '4': 1, '5': 5, '10': 'graceDays'},
  ],
};

/// Descriptor for `AddScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addScheduleRequestDescriptor = $convert.base64Decode(
    'ChJBZGRTY2hlZHVsZVJlcXVlc3QSGQoIYXNzZXRfaWQYASABKAlSB2Fzc2V0SWQSHwoLZmFjaW'
    'xpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSFAoFdGl0bGUYAyABKAlSBXRpdGxlEj0KBGtpbmQY'
    'BCABKA4yKS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTWFpbnRlbmFuY2VLaW5kUgRraW5kEj'
    'sKB3RyaWdnZXIYBSABKA4yIS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuVHJpZ2dlclIHdHJp'
    'Z2dlchIjCg1pbnRlcnZhbF9kYXlzGAYgASgFUgxpbnRlcnZhbERheXMSNAoWaW50ZXJ2YWxfcn'
    'VudGltZV9ob3VycxgHIAEoBVIUaW50ZXJ2YWxSdW50aW1lSG91cnMSHAoJYXV0aG9yaXR5GAgg'
    'ASgJUglhdXRob3JpdHkSKwoRcmVxdWlyZXNfZXZpZGVuY2UYCSABKAhSEHJlcXVpcmVzRXZpZG'
    'VuY2USJgoPd29ya19jbGFzc19jb2RlGAogASgJUg13b3JrQ2xhc3NDb2RlEh0KCmdyYWNlX2Rh'
    'eXMYCyABKAVSCWdyYWNlRGF5cw==');

@$core.Deprecated('Use addScheduleResponseDescriptor instead')
const AddScheduleResponse$json = {
  '1': 'AddScheduleResponse',
  '2': [
    {
      '1': 'schedule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Schedule',
      '10': 'schedule'
    },
  ],
};

/// Descriptor for `AddScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addScheduleResponseDescriptor = $convert.base64Decode(
    'ChNBZGRTY2hlZHVsZVJlc3BvbnNlEj4KCHNjaGVkdWxlGAEgASgLMiIuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLlNjaGVkdWxlUghzY2hlZHVsZQ==');

@$core.Deprecated('Use listSchedulesRequestDescriptor instead')
const ListSchedulesRequest$json = {
  '1': 'ListSchedulesRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListSchedulesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSchedulesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0U2NoZWR1bGVzUmVxdWVzdBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIfCgtmYW'
    'NpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listSchedulesResponseDescriptor instead')
const ListSchedulesResponse$json = {
  '1': 'ListSchedulesResponse',
  '2': [
    {
      '1': 'schedules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Schedule',
      '10': 'schedules'
    },
  ],
};

/// Descriptor for `ListSchedulesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSchedulesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0U2NoZWR1bGVzUmVzcG9uc2USQAoJc2NoZWR1bGVzGAEgAygLMiIuaGVhbHRoY2FyZS'
    '5mYWNpbGl0aWVzLnYxLlNjaGVkdWxlUglzY2hlZHVsZXM=');

@$core.Deprecated('Use planDueRequestDescriptor instead')
const PlanDueRequest$json = {
  '1': 'PlanDueRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `PlanDueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planDueRequestDescriptor = $convert.base64Decode(
    'Cg5QbGFuRHVlUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZA==');

@$core.Deprecated('Use planDueResponseDescriptor instead')
const PlanDueResponse$json = {
  '1': 'PlanDueResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Task',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `PlanDueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planDueResponseDescriptor = $convert.base64Decode(
    'Cg9QbGFuRHVlUmVzcG9uc2USNAoFdGFza3MYASADKAsyHi5oZWFsdGhjYXJlLmZhY2lsaXRpZX'
    'MudjEuVGFza1IFdGFza3M=');

@$core.Deprecated('Use completeTaskRequestDescriptor instead')
const CompleteTaskRequest$json = {
  '1': 'CompleteTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'findings', '3': 2, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'evidence_ref', '3': 3, '4': 1, '5': 9, '10': 'evidenceRef'},
    {'1': 'certificate_ref', '3': 4, '4': 1, '5': 9, '10': 'certificateRef'},
    {
      '1': 'certificate_expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'certificateExpiresAt'
    },
    {'1': 'work_order_id', '3': 6, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'runtime_hours', '3': 7, '4': 1, '5': 5, '10': 'runtimeHours'},
    {'1': 'version', '3': 8, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CompleteTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTaskRequestDescriptor = $convert.base64Decode(
    'ChNDb21wbGV0ZVRhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIaCghmaW5kaW'
    '5ncxgCIAEoCVIIZmluZGluZ3MSIQoMZXZpZGVuY2VfcmVmGAMgASgJUgtldmlkZW5jZVJlZhIn'
    'Cg9jZXJ0aWZpY2F0ZV9yZWYYBCABKAlSDmNlcnRpZmljYXRlUmVmElAKFmNlcnRpZmljYXRlX2'
    'V4cGlyZXNfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhRjZXJ0aWZpY2F0'
    'ZUV4cGlyZXNBdBIiCg13b3JrX29yZGVyX2lkGAYgASgJUgt3b3JrT3JkZXJJZBIjCg1ydW50aW'
    '1lX2hvdXJzGAcgASgFUgxydW50aW1lSG91cnMSGAoHdmVyc2lvbhgIIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use completeTaskResponseDescriptor instead')
const CompleteTaskResponse$json = {
  '1': 'CompleteTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CompleteTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTaskResponseDescriptor = $convert.base64Decode(
    'ChRDb21wbGV0ZVRhc2tSZXNwb25zZRIyCgR0YXNrGAEgASgLMh4uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLlRhc2tSBHRhc2s=');

@$core.Deprecated('Use waiveTaskRequestDescriptor instead')
const WaiveTaskRequest$json = {
  '1': 'WaiveTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `WaiveTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveTaskRequestDescriptor = $convert.base64Decode(
    'ChBXYWl2ZVRhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIWCgZyZWFzb24YAi'
    'ABKAlSBnJlYXNvbhIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use waiveTaskResponseDescriptor instead')
const WaiveTaskResponse$json = {
  '1': 'WaiveTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Task',
      '10': 'task'
    },
  ],
};

/// Descriptor for `WaiveTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveTaskResponseDescriptor = $convert.base64Decode(
    'ChFXYWl2ZVRhc2tSZXNwb25zZRIyCgR0YXNrGAEgASgLMh4uaGVhbHRoY2FyZS5mYWNpbGl0aW'
    'VzLnYxLlRhc2tSBHRhc2s=');

@$core.Deprecated('Use listTasksRequestDescriptor instead')
const ListTasksRequest$json = {
  '1': 'ListTasksRequest',
  '2': [
    {'1': 'schedule_id', '3': 1, '4': 1, '5': 9, '10': 'scheduleId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.TaskState',
      '10': 'state'
    },
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.MaintenanceKind',
      '10': 'kind'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VGFza3NSZXF1ZXN0Eh8KC3NjaGVkdWxlX2lkGAEgASgJUgpzY2hlZHVsZUlkEhkKCG'
    'Fzc2V0X2lkGAIgASgJUgdhc3NldElkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpmYWNpbGl0eUlk'
    'EjkKBXN0YXRlGAQgASgOMiMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlRhc2tTdGF0ZVIFc3'
    'RhdGUSPQoEa2luZBgFIAEoDjIpLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5NYWludGVuYW5j'
    'ZUtpbmRSBGtpbmQSGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listTasksResponseDescriptor instead')
const ListTasksResponse$json = {
  '1': 'ListTasksResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Task',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `ListTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTasksResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VGFza3NSZXNwb25zZRI0CgV0YXNrcxgBIAMoCzIeLmhlYWx0aGNhcmUuZmFjaWxpdG'
    'llcy52MS5UYXNrUgV0YXNrcw==');

@$core.Deprecated('Use maintenanceReportDescriptor instead')
const MaintenanceReport$json = {
  '1': 'MaintenanceReport',
  '2': [
    {'1': 'planned', '3': 1, '4': 1, '5': 5, '10': 'planned'},
    {'1': 'overdue', '3': 2, '4': 1, '5': 5, '10': 'overdue'},
    {'1': 'done', '3': 3, '4': 1, '5': 5, '10': 'done'},
    {'1': 'missed', '3': 4, '4': 1, '5': 5, '10': 'missed'},
    {'1': 'waived', '3': 5, '4': 1, '5': 5, '10': 'waived'},
    {
      '1': 'statutory_overdue',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'statutoryOverdue'
    },
    {'1': 'evidence_missing', '3': 7, '4': 1, '5': 5, '10': 'evidenceMissing'},
    {
      '1': 'overdue_tasks',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Task',
      '10': 'overdueTasks'
    },
  ],
};

/// Descriptor for `MaintenanceReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List maintenanceReportDescriptor = $convert.base64Decode(
    'ChFNYWludGVuYW5jZVJlcG9ydBIYCgdwbGFubmVkGAEgASgFUgdwbGFubmVkEhgKB292ZXJkdW'
    'UYAiABKAVSB292ZXJkdWUSEgoEZG9uZRgDIAEoBVIEZG9uZRIWCgZtaXNzZWQYBCABKAVSBm1p'
    'c3NlZBIWCgZ3YWl2ZWQYBSABKAVSBndhaXZlZBIrChFzdGF0dXRvcnlfb3ZlcmR1ZRgGIAEoBV'
    'IQc3RhdHV0b3J5T3ZlcmR1ZRIpChBldmlkZW5jZV9taXNzaW5nGAcgASgFUg9ldmlkZW5jZU1p'
    'c3NpbmcSQwoNb3ZlcmR1ZV90YXNrcxgIIAMoCzIeLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS'
    '5UYXNrUgxvdmVyZHVlVGFza3M=');

@$core.Deprecated('Use getMaintenanceReportRequestDescriptor instead')
const GetMaintenanceReportRequest$json = {
  '1': 'GetMaintenanceReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetMaintenanceReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMaintenanceReportRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRNYWludGVuYW5jZVJlcG9ydFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2'
        'lsaXR5SWQ=');

@$core.Deprecated('Use getMaintenanceReportResponseDescriptor instead')
const GetMaintenanceReportResponse$json = {
  '1': 'GetMaintenanceReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.MaintenanceReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetMaintenanceReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMaintenanceReportResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRNYWludGVuYW5jZVJlcG9ydFJlc3BvbnNlEkMKBnJlcG9ydBgBIAEoCzIrLmhlYWx0aG'
        'NhcmUuZmFjaWxpdGllcy52MS5NYWludGVuYW5jZVJlcG9ydFIGcmVwb3J0');

@$core.Deprecated('Use runtimeReadingDescriptor instead')
const RuntimeReading$json = {
  '1': 'RuntimeReading',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'hours', '3': 3, '4': 1, '5': 5, '10': 'hours'},
    {
      '1': 'read_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 6, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'recorded_by', '3': 7, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'counter_replaced', '3': 8, '4': 1, '5': 8, '10': 'counterReplaced'},
    {'1': 'note', '3': 9, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RuntimeReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runtimeReadingDescriptor = $convert.base64Decode(
    'Cg5SdW50aW1lUmVhZGluZxIdCgpyZWFkaW5nX2lkGAEgASgJUglyZWFkaW5nSWQSGQoIYXNzZX'
    'RfaWQYAiABKAlSB2Fzc2V0SWQSFAoFaG91cnMYAyABKAVSBWhvdXJzEjMKB3JlYWRfYXQYBCAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZyZWFkQXQSOAoGc291cmNlGAUgASgOMi'
    'AuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlNvdXJjZVIGc291cmNlEh0KCnNvdXJjZV9yZWYY'
    'BiABKAlSCXNvdXJjZVJlZhIfCgtyZWNvcmRlZF9ieRgHIAEoCVIKcmVjb3JkZWRCeRIpChBjb3'
    'VudGVyX3JlcGxhY2VkGAggASgIUg9jb3VudGVyUmVwbGFjZWQSEgoEbm90ZRgJIAEoCVIEbm90'
    'ZQ==');

@$core.Deprecated('Use recordRuntimeRequestDescriptor instead')
const RecordRuntimeRequest$json = {
  '1': 'RecordRuntimeRequest',
  '2': [
    {'1': 'asset_id', '3': 1, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'hours', '3': 2, '4': 1, '5': 5, '10': 'hours'},
    {
      '1': 'read_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 5, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'counter_replaced', '3': 6, '4': 1, '5': 8, '10': 'counterReplaced'},
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordRuntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordRuntimeRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRSdW50aW1lUmVxdWVzdBIZCghhc3NldF9pZBgBIAEoCVIHYXNzZXRJZBIUCgVob3'
    'VycxgCIAEoBVIFaG91cnMSMwoHcmVhZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSBnJlYWRBdBI4CgZzb3VyY2UYBCABKA4yIC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudj'
    'EuU291cmNlUgZzb3VyY2USHQoKc291cmNlX3JlZhgFIAEoCVIJc291cmNlUmVmEikKEGNvdW50'
    'ZXJfcmVwbGFjZWQYBiABKAhSD2NvdW50ZXJSZXBsYWNlZBISCgRub3RlGAcgASgJUgRub3Rl');

@$core.Deprecated('Use recordRuntimeResponseDescriptor instead')
const RecordRuntimeResponse$json = {
  '1': 'RecordRuntimeResponse',
  '2': [
    {
      '1': 'reading',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.RuntimeReading',
      '10': 'reading'
    },
  ],
};

/// Descriptor for `RecordRuntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordRuntimeResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRSdW50aW1lUmVzcG9uc2USQgoHcmVhZGluZxgBIAEoCzIoLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5SdW50aW1lUmVhZGluZ1IHcmVhZGluZw==');

@$core.Deprecated('Use outageDescriptor instead')
const Outage$json = {
  '1': 'Outage',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'planned_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedFrom'
    },
    {
      '1': 'planned_to',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedTo'
    },
    {
      '1': 'actual_from',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'actualFrom'
    },
    {
      '1': 'actual_to',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'actualTo'
    },
    {
      '1': 'state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.OutageState',
      '10': 'state'
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
    {'1': 'approved_by', '3': 14, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'permit_ref', '3': 16, '4': 1, '5': 9, '10': 'permitRef'},
    {'1': 'contingency', '3': 17, '4': 1, '5': 9, '10': 'contingency'},
    {'1': 'restored_by', '3': 18, '4': 1, '5': 9, '10': 'restoredBy'},
    {'1': 'cancel_reason', '3': 19, '4': 1, '5': 9, '10': 'cancelReason'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Outage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outageDescriptor = $convert.base64Decode(
    'CgZPdXRhZ2USGwoJb3V0YWdlX2lkGAEgASgJUghvdXRhZ2VJZBIcCglyZWZlcmVuY2UYAiABKA'
    'lSCXJlZmVyZW5jZRIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBI4CgZzeXN0ZW0Y'
    'BCABKA4yIC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3lzdGVtUgZzeXN0ZW0SFAoFdGl0bG'
    'UYBSABKAlSBXRpdGxlEhYKBnJlYXNvbhgGIAEoCVIGcmVhc29uEj0KDHBsYW5uZWRfZnJvbRgH'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3BsYW5uZWRGcm9tEjkKCnBsYW5uZW'
    'RfdG8YCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglwbGFubmVkVG8SOwoLYWN0'
    'dWFsX2Zyb20YCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphY3R1YWxGcm9tEj'
    'cKCWFjdHVhbF90bxgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGFjdHVhbFRv'
    'EjsKBXN0YXRlGAsgASgOMiUuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLk91dGFnZVN0YXRlUg'
    'VzdGF0ZRIhCgxyZXF1ZXN0ZWRfYnkYDCABKAlSC3JlcXVlc3RlZEJ5Ej0KDHJlcXVlc3RlZF9h'
    'dBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3JlcXVlc3RlZEF0Eh8KC2FwcH'
    'JvdmVkX2J5GA4gASgJUgphcHByb3ZlZEJ5EjsKC2FwcHJvdmVkX2F0GA8gASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIKYXBwcm92ZWRBdBIdCgpwZXJtaXRfcmVmGBAgASgJUglwZX'
    'JtaXRSZWYSIAoLY29udGluZ2VuY3kYESABKAlSC2NvbnRpbmdlbmN5Eh8KC3Jlc3RvcmVkX2J5'
    'GBIgASgJUgpyZXN0b3JlZEJ5EiMKDWNhbmNlbF9yZWFzb24YEyABKAlSDGNhbmNlbFJlYXNvbh'
    'IYCgd2ZXJzaW9uGBQgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use outageAreaDescriptor instead')
const OutageArea$json = {
  '1': 'OutageArea',
  '2': [
    {'1': 'area_id', '3': 1, '4': 1, '5': 9, '10': 'areaId'},
    {'1': 'outage_id', '3': 2, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'org_unit_id', '3': 3, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'critical', '3': 5, '4': 1, '5': 8, '10': 'critical'},
    {
      '1': 'notified_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notifiedAt'
    },
    {
      '1': 'acknowledged_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
    {'1': 'acknowledged_by', '3': 8, '4': 1, '5': 9, '10': 'acknowledgedBy'},
    {'1': 'objection', '3': 9, '4': 1, '5': 9, '10': 'objection'},
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `OutageArea`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outageAreaDescriptor = $convert.base64Decode(
    'CgpPdXRhZ2VBcmVhEhcKB2FyZWFfaWQYASABKAlSBmFyZWFJZBIbCglvdXRhZ2VfaWQYAiABKA'
    'lSCG91dGFnZUlkEh4KC29yZ191bml0X2lkGAMgASgJUglvcmdVbml0SWQSEgoEbmFtZRgEIAEo'
    'CVIEbmFtZRIaCghjcml0aWNhbBgFIAEoCFIIY3JpdGljYWwSOwoLbm90aWZpZWRfYXQYBiABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpub3RpZmllZEF0EkMKD2Fja25vd2xlZGdl'
    'ZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmFja25vd2xlZGdlZEF0Ei'
    'cKD2Fja25vd2xlZGdlZF9ieRgIIAEoCVIOYWNrbm93bGVkZ2VkQnkSHAoJb2JqZWN0aW9uGAkg'
    'ASgJUglvYmplY3Rpb24SGAoHdmVyc2lvbhgKIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use areaInputDescriptor instead')
const AreaInput$json = {
  '1': 'AreaInput',
  '2': [
    {'1': 'org_unit_id', '3': 1, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'critical', '3': 3, '4': 1, '5': 8, '10': 'critical'},
  ],
};

/// Descriptor for `AreaInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List areaInputDescriptor = $convert.base64Decode(
    'CglBcmVhSW5wdXQSHgoLb3JnX3VuaXRfaWQYASABKAlSCW9yZ1VuaXRJZBISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEhoKCGNyaXRpY2FsGAMgASgIUghjcml0aWNhbA==');

@$core.Deprecated('Use planOutageRequestDescriptor instead')
const PlanOutageRequest$json = {
  '1': 'PlanOutageRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'planned_from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedFrom'
    },
    {
      '1': 'planned_to',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedTo'
    },
    {'1': 'contingency', '3': 8, '4': 1, '5': 9, '10': 'contingency'},
    {
      '1': 'areas',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.AreaInput',
      '10': 'areas'
    },
  ],
};

/// Descriptor for `PlanOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planOutageRequestDescriptor = $convert.base64Decode(
    'ChFQbGFuT3V0YWdlUmVxdWVzdBIcCglyZWZlcmVuY2UYASABKAlSCXJlZmVyZW5jZRIfCgtmYW'
    'NpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBI4CgZzeXN0ZW0YAyABKA4yIC5oZWFsdGhjYXJl'
    'LmZhY2lsaXRpZXMudjEuU3lzdGVtUgZzeXN0ZW0SFAoFdGl0bGUYBCABKAlSBXRpdGxlEhYKBn'
    'JlYXNvbhgFIAEoCVIGcmVhc29uEj0KDHBsYW5uZWRfZnJvbRgGIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSC3BsYW5uZWRGcm9tEjkKCnBsYW5uZWRfdG8YByABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUglwbGFubmVkVG8SIAoLY29udGluZ2VuY3kYCCABKAlSC2Nv'
    'bnRpbmdlbmN5EjkKBWFyZWFzGAkgAygLMiMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFyZW'
    'FJbnB1dFIFYXJlYXM=');

@$core.Deprecated('Use planOutageResponseDescriptor instead')
const PlanOutageResponse$json = {
  '1': 'PlanOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
    {
      '1': 'areas',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.OutageArea',
      '10': 'areas'
    },
    {
      '1': 'overlapping',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'overlapping'
    },
  ],
};

/// Descriptor for `PlanOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planOutageResponseDescriptor = $convert.base64Decode(
    'ChJQbGFuT3V0YWdlUmVzcG9uc2USOAoGb3V0YWdlGAEgASgLMiAuaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLk91dGFnZVIGb3V0YWdlEjoKBWFyZWFzGAIgAygLMiQuaGVhbHRoY2FyZS5mYWNp'
    'bGl0aWVzLnYxLk91dGFnZUFyZWFSBWFyZWFzEkIKC292ZXJsYXBwaW5nGAMgAygLMiAuaGVhbH'
    'RoY2FyZS5mYWNpbGl0aWVzLnYxLk91dGFnZVILb3ZlcmxhcHBpbmc=');

@$core.Deprecated('Use approveOutageRequestDescriptor instead')
const ApproveOutageRequest$json = {
  '1': 'ApproveOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'permit_ref', '3': 2, '4': 1, '5': 9, '10': 'permitRef'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ApproveOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveOutageRequestDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlT3V0YWdlUmVxdWVzdBIbCglvdXRhZ2VfaWQYASABKAlSCG91dGFnZUlkEh0KCn'
    'Blcm1pdF9yZWYYAiABKAlSCXBlcm1pdFJlZhIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use approveOutageResponseDescriptor instead')
const ApproveOutageResponse$json = {
  '1': 'ApproveOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
    {
      '1': 'areas',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.OutageArea',
      '10': 'areas'
    },
  ],
};

/// Descriptor for `ApproveOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveOutageResponseDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlT3V0YWdlUmVzcG9uc2USOAoGb3V0YWdlGAEgASgLMiAuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLk91dGFnZVIGb3V0YWdlEjoKBWFyZWFzGAIgAygLMiQuaGVhbHRoY2FyZS5m'
    'YWNpbGl0aWVzLnYxLk91dGFnZUFyZWFSBWFyZWFz');

@$core.Deprecated('Use acknowledgeOutageRequestDescriptor instead')
const AcknowledgeOutageRequest$json = {
  '1': 'AcknowledgeOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'area_id', '3': 2, '4': 1, '5': 9, '10': 'areaId'},
    {'1': 'objection', '3': 3, '4': 1, '5': 9, '10': 'objection'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AcknowledgeOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeOutageRequestDescriptor = $convert.base64Decode(
    'ChhBY2tub3dsZWRnZU91dGFnZVJlcXVlc3QSGwoJb3V0YWdlX2lkGAEgASgJUghvdXRhZ2VJZB'
    'IXCgdhcmVhX2lkGAIgASgJUgZhcmVhSWQSHAoJb2JqZWN0aW9uGAMgASgJUglvYmplY3Rpb24S'
    'GAoHdmVyc2lvbhgEIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use acknowledgeOutageResponseDescriptor instead')
const AcknowledgeOutageResponse$json = {
  '1': 'AcknowledgeOutageResponse',
  '2': [
    {
      '1': 'area',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.OutageArea',
      '10': 'area'
    },
  ],
};

/// Descriptor for `AcknowledgeOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeOutageResponseDescriptor =
    $convert.base64Decode(
        'ChlBY2tub3dsZWRnZU91dGFnZVJlc3BvbnNlEjgKBGFyZWEYASABKAsyJC5oZWFsdGhjYXJlLm'
        'ZhY2lsaXRpZXMudjEuT3V0YWdlQXJlYVIEYXJlYQ==');

@$core.Deprecated('Use startOutageRequestDescriptor instead')
const StartOutageRequest$json = {
  '1': 'StartOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `StartOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOutageRequestDescriptor = $convert.base64Decode(
    'ChJTdGFydE91dGFnZVJlcXVlc3QSGwoJb3V0YWdlX2lkGAEgASgJUghvdXRhZ2VJZBIYCgd2ZX'
    'JzaW9uGAIgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use startOutageResponseDescriptor instead')
const StartOutageResponse$json = {
  '1': 'StartOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
  ],
};

/// Descriptor for `StartOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startOutageResponseDescriptor = $convert.base64Decode(
    'ChNTdGFydE91dGFnZVJlc3BvbnNlEjgKBm91dGFnZRgBIAEoCzIgLmhlYWx0aGNhcmUuZmFjaW'
    'xpdGllcy52MS5PdXRhZ2VSBm91dGFnZQ==');

@$core.Deprecated('Use restoreOutageRequestDescriptor instead')
const RestoreOutageRequest$json = {
  '1': 'RestoreOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RestoreOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreOutageRequestDescriptor = $convert.base64Decode(
    'ChRSZXN0b3JlT3V0YWdlUmVxdWVzdBIbCglvdXRhZ2VfaWQYASABKAlSCG91dGFnZUlkEhgKB3'
    'ZlcnNpb24YAiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use restoreOutageResponseDescriptor instead')
const RestoreOutageResponse$json = {
  '1': 'RestoreOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
  ],
};

/// Descriptor for `RestoreOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreOutageResponseDescriptor = $convert.base64Decode(
    'ChVSZXN0b3JlT3V0YWdlUmVzcG9uc2USOAoGb3V0YWdlGAEgASgLMiAuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLk91dGFnZVIGb3V0YWdl');

@$core.Deprecated('Use cancelOutageRequestDescriptor instead')
const CancelOutageRequest$json = {
  '1': 'CancelOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CancelOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelOutageRequestDescriptor = $convert.base64Decode(
    'ChNDYW5jZWxPdXRhZ2VSZXF1ZXN0EhsKCW91dGFnZV9pZBgBIAEoCVIIb3V0YWdlSWQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24SGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use cancelOutageResponseDescriptor instead')
const CancelOutageResponse$json = {
  '1': 'CancelOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
  ],
};

/// Descriptor for `CancelOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelOutageResponseDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxPdXRhZ2VSZXNwb25zZRI4CgZvdXRhZ2UYASABKAsyIC5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuT3V0YWdlUgZvdXRhZ2U=');

@$core.Deprecated('Use getOutageRequestDescriptor instead')
const GetOutageRequest$json = {
  '1': 'GetOutageRequest',
  '2': [
    {'1': 'outage_id', '3': 1, '4': 1, '5': 9, '10': 'outageId'},
  ],
};

/// Descriptor for `GetOutageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOutageRequestDescriptor = $convert.base64Decode(
    'ChBHZXRPdXRhZ2VSZXF1ZXN0EhsKCW91dGFnZV9pZBgBIAEoCVIIb3V0YWdlSWQ=');

@$core.Deprecated('Use getOutageResponseDescriptor instead')
const GetOutageResponse$json = {
  '1': 'GetOutageResponse',
  '2': [
    {
      '1': 'outage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outage'
    },
    {
      '1': 'areas',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.OutageArea',
      '10': 'areas'
    },
  ],
};

/// Descriptor for `GetOutageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOutageResponseDescriptor = $convert.base64Decode(
    'ChFHZXRPdXRhZ2VSZXNwb25zZRI4CgZvdXRhZ2UYASABKAsyIC5oZWFsdGhjYXJlLmZhY2lsaX'
    'RpZXMudjEuT3V0YWdlUgZvdXRhZ2USOgoFYXJlYXMYAiADKAsyJC5oZWFsdGhjYXJlLmZhY2ls'
    'aXRpZXMudjEuT3V0YWdlQXJlYVIFYXJlYXM=');

@$core.Deprecated('Use listOutagesRequestDescriptor instead')
const ListOutagesRequest$json = {
  '1': 'ListOutagesRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'live_only', '3': 3, '4': 1, '5': 8, '10': 'liveOnly'},
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
  ],
};

/// Descriptor for `ListOutagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutagesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0T3V0YWdlc1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSOA'
    'oGc3lzdGVtGAIgASgOMiAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlN5c3RlbVIGc3lzdGVt'
    'EhsKCWxpdmVfb25seRgDIAEoCFIIbGl2ZU9ubHkSLgoEZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgJ0bxIbCglwYWdlX3NpemUYBiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listOutagesResponseDescriptor instead')
const ListOutagesResponse$json = {
  '1': 'ListOutagesResponse',
  '2': [
    {
      '1': 'outages',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Outage',
      '10': 'outages'
    },
  ],
};

/// Descriptor for `ListOutagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutagesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0T3V0YWdlc1Jlc3BvbnNlEjoKB291dGFnZXMYASADKAsyIC5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuT3V0YWdlUgdvdXRhZ2Vz');

@$core.Deprecated('Use alarmDescriptor instead')
const Alarm$json = {
  '1': 'Alarm',
  '2': [
    {'1': 'alarm_id', '3': 1, '4': 1, '5': 9, '10': 'alarmId'},
    {'1': 'gateway_id', '3': 2, '4': 1, '5': 9, '10': 'gatewayId'},
    {'1': 'point_ref', '3': 3, '4': 1, '5': 9, '10': 'pointRef'},
    {'1': 'external_id', '3': 4, '4': 1, '5': 9, '10': 'externalId'},
    {'1': 'asset_id', '3': 5, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'severity',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'severity'
    },
    {'1': 'message', '3': 9, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'source',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {
      '1': 'raised_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {
      '1': 'cleared_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'clearedAt'
    },
    {
      '1': 'state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.AlarmState',
      '10': 'state'
    },
    {
      '1': 'acknowledged_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
    {'1': 'acknowledged_by', '3': 15, '4': 1, '5': 9, '10': 'acknowledgedBy'},
    {'1': 'work_order_id', '3': 16, '4': 1, '5': 9, '10': 'workOrderId'},
    {
      '1': 'linked_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'linkedAt'
    },
    {'1': 'linked_by', '3': 18, '4': 1, '5': 9, '10': 'linkedBy'},
    {'1': 'version', '3': 19, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Alarm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmDescriptor = $convert.base64Decode(
    'CgVBbGFybRIZCghhbGFybV9pZBgBIAEoCVIHYWxhcm1JZBIdCgpnYXRld2F5X2lkGAIgASgJUg'
    'lnYXRld2F5SWQSGwoJcG9pbnRfcmVmGAMgASgJUghwb2ludFJlZhIfCgtleHRlcm5hbF9pZBgE'
    'IAEoCVIKZXh0ZXJuYWxJZBIZCghhc3NldF9pZBgFIAEoCVIHYXNzZXRJZBIfCgtmYWNpbGl0eV'
    '9pZBgGIAEoCVIKZmFjaWxpdHlJZBI4CgZzeXN0ZW0YByABKA4yIC5oZWFsdGhjYXJlLmZhY2ls'
    'aXRpZXMudjEuU3lzdGVtUgZzeXN0ZW0SPgoIc2V2ZXJpdHkYCCABKA4yIi5oZWFsdGhjYXJlLm'
    'ZhY2lsaXRpZXMudjEuU2V2ZXJpdHlSCHNldmVyaXR5EhgKB21lc3NhZ2UYCSABKAlSB21lc3Nh'
    'Z2USOAoGc291cmNlGAogASgOMiAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlNvdXJjZVIGc2'
    '91cmNlEjcKCXJhaXNlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHJh'
    'aXNlZEF0EjkKCmNsZWFyZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'ljbGVhcmVkQXQSOgoFc3RhdGUYDSABKA4yJC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQWxh'
    'cm1TdGF0ZVIFc3RhdGUSQwoPYWNrbm93bGVkZ2VkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIOYWNrbm93bGVkZ2VkQXQSJwoPYWNrbm93bGVkZ2VkX2J5GA8gASgJUg5h'
    'Y2tub3dsZWRnZWRCeRIiCg13b3JrX29yZGVyX2lkGBAgASgJUgt3b3JrT3JkZXJJZBI3CglsaW'
    '5rZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghsaW5rZWRBdBIbCgls'
    'aW5rZWRfYnkYEiABKAlSCGxpbmtlZEJ5EhgKB3ZlcnNpb24YEyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use alarmRuleDescriptor instead')
const AlarmRule$json = {
  '1': 'AlarmRule',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'min_severity',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'minSeverity'
    },
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Priority',
      '10': 'priority'
    },
    {'1': 'class_code', '3': 5, '4': 1, '5': 9, '10': 'classCode'},
    {'1': 'owner_team', '3': 6, '4': 1, '5': 9, '10': 'ownerTeam'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `AlarmRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmRuleDescriptor = $convert.base64Decode(
    'CglBbGFybVJ1bGUSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSOAoGc3lzdGVtGA'
    'IgASgOMiAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlN5c3RlbVIGc3lzdGVtEkUKDG1pbl9z'
    'ZXZlcml0eRgDIAEoDjIiLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TZXZlcml0eVILbWluU2'
    'V2ZXJpdHkSPgoIcHJpb3JpdHkYBCABKA4yIi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuUHJp'
    'b3JpdHlSCHByaW9yaXR5Eh0KCmNsYXNzX2NvZGUYBSABKAlSCWNsYXNzQ29kZRIdCgpvd25lcl'
    '90ZWFtGAYgASgJUglvd25lclRlYW0SFgoGYWN0aXZlGAcgASgIUgZhY3RpdmU=');

@$core.Deprecated('Use ingestAlarmRequestDescriptor instead')
const IngestAlarmRequest$json = {
  '1': 'IngestAlarmRequest',
  '2': [
    {'1': 'gateway_id', '3': 1, '4': 1, '5': 9, '10': 'gatewayId'},
    {'1': 'point_ref', '3': 2, '4': 1, '5': 9, '10': 'pointRef'},
    {'1': 'external_id', '3': 3, '4': 1, '5': 9, '10': 'externalId'},
    {'1': 'asset_id', '3': 4, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'severity',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'severity'
    },
    {'1': 'message', '3': 8, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'source',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {
      '1': 'raised_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
  ],
};

/// Descriptor for `IngestAlarmRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestAlarmRequestDescriptor = $convert.base64Decode(
    'ChJJbmdlc3RBbGFybVJlcXVlc3QSHQoKZ2F0ZXdheV9pZBgBIAEoCVIJZ2F0ZXdheUlkEhsKCX'
    'BvaW50X3JlZhgCIAEoCVIIcG9pbnRSZWYSHwoLZXh0ZXJuYWxfaWQYAyABKAlSCmV4dGVybmFs'
    'SWQSGQoIYXNzZXRfaWQYBCABKAlSB2Fzc2V0SWQSHwoLZmFjaWxpdHlfaWQYBSABKAlSCmZhY2'
    'lsaXR5SWQSOAoGc3lzdGVtGAYgASgOMiAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlN5c3Rl'
    'bVIGc3lzdGVtEj4KCHNldmVyaXR5GAcgASgOMiIuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLl'
    'NldmVyaXR5UghzZXZlcml0eRIYCgdtZXNzYWdlGAggASgJUgdtZXNzYWdlEjgKBnNvdXJjZRgJ'
    'IAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5Tb3VyY2VSBnNvdXJjZRI3CglyYWlzZW'
    'RfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghyYWlzZWRBdA==');

@$core.Deprecated('Use ingestAlarmResponseDescriptor instead')
const IngestAlarmResponse$json = {
  '1': 'IngestAlarmResponse',
  '2': [
    {
      '1': 'alarm',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Alarm',
      '10': 'alarm'
    },
    {
      '1': 'work_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
    {'1': 'raised_work', '3': 3, '4': 1, '5': 8, '10': 'raisedWork'},
    {'1': 'duplicate', '3': 4, '4': 1, '5': 8, '10': 'duplicate'},
  ],
};

/// Descriptor for `IngestAlarmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestAlarmResponseDescriptor = $convert.base64Decode(
    'ChNJbmdlc3RBbGFybVJlc3BvbnNlEjUKBWFsYXJtGAEgASgLMh8uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLkFsYXJtUgVhbGFybRJCCgp3b3JrX29yZGVyGAIgASgLMiMuaGVhbHRoY2FyZS5m'
    'YWNpbGl0aWVzLnYxLldvcmtPcmRlclIJd29ya09yZGVyEh8KC3JhaXNlZF93b3JrGAMgASgIUg'
    'pyYWlzZWRXb3JrEhwKCWR1cGxpY2F0ZRgEIAEoCFIJZHVwbGljYXRl');

@$core.Deprecated('Use clearAlarmRequestDescriptor instead')
const ClearAlarmRequest$json = {
  '1': 'ClearAlarmRequest',
  '2': [
    {'1': 'alarm_id', '3': 1, '4': 1, '5': 9, '10': 'alarmId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ClearAlarmRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearAlarmRequestDescriptor = $convert.base64Decode(
    'ChFDbGVhckFsYXJtUmVxdWVzdBIZCghhbGFybV9pZBgBIAEoCVIHYWxhcm1JZBIYCgd2ZXJzaW'
    '9uGAIgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use clearAlarmResponseDescriptor instead')
const ClearAlarmResponse$json = {
  '1': 'ClearAlarmResponse',
  '2': [
    {
      '1': 'alarm',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Alarm',
      '10': 'alarm'
    },
  ],
};

/// Descriptor for `ClearAlarmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearAlarmResponseDescriptor = $convert.base64Decode(
    'ChJDbGVhckFsYXJtUmVzcG9uc2USNQoFYWxhcm0YASABKAsyHy5oZWFsdGhjYXJlLmZhY2lsaX'
    'RpZXMudjEuQWxhcm1SBWFsYXJt');

@$core.Deprecated('Use acknowledgeAlarmRequestDescriptor instead')
const AcknowledgeAlarmRequest$json = {
  '1': 'AcknowledgeAlarmRequest',
  '2': [
    {'1': 'alarm_id', '3': 1, '4': 1, '5': 9, '10': 'alarmId'},
    {'1': 'version', '3': 2, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AcknowledgeAlarmRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeAlarmRequestDescriptor =
    $convert.base64Decode(
        'ChdBY2tub3dsZWRnZUFsYXJtUmVxdWVzdBIZCghhbGFybV9pZBgBIAEoCVIHYWxhcm1JZBIYCg'
        'd2ZXJzaW9uGAIgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use acknowledgeAlarmResponseDescriptor instead')
const AcknowledgeAlarmResponse$json = {
  '1': 'AcknowledgeAlarmResponse',
  '2': [
    {
      '1': 'alarm',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Alarm',
      '10': 'alarm'
    },
  ],
};

/// Descriptor for `AcknowledgeAlarmResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeAlarmResponseDescriptor =
    $convert.base64Decode(
        'ChhBY2tub3dsZWRnZUFsYXJtUmVzcG9uc2USNQoFYWxhcm0YASABKAsyHy5oZWFsdGhjYXJlLm'
        'ZhY2lsaXRpZXMudjEuQWxhcm1SBWFsYXJt');

@$core.Deprecated('Use linkAlarmWorkRequestDescriptor instead')
const LinkAlarmWorkRequest$json = {
  '1': 'LinkAlarmWorkRequest',
  '2': [
    {'1': 'alarm_id', '3': 1, '4': 1, '5': 9, '10': 'alarmId'},
    {'1': 'work_order_id', '3': 2, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `LinkAlarmWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkAlarmWorkRequestDescriptor = $convert.base64Decode(
    'ChRMaW5rQWxhcm1Xb3JrUmVxdWVzdBIZCghhbGFybV9pZBgBIAEoCVIHYWxhcm1JZBIiCg13b3'
    'JrX29yZGVyX2lkGAIgASgJUgt3b3JrT3JkZXJJZBIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use linkAlarmWorkResponseDescriptor instead')
const LinkAlarmWorkResponse$json = {
  '1': 'LinkAlarmWorkResponse',
  '2': [
    {
      '1': 'alarm',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Alarm',
      '10': 'alarm'
    },
  ],
};

/// Descriptor for `LinkAlarmWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkAlarmWorkResponseDescriptor = $convert.base64Decode(
    'ChVMaW5rQWxhcm1Xb3JrUmVzcG9uc2USNQoFYWxhcm0YASABKAsyHy5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuQWxhcm1SBWFsYXJt');

@$core.Deprecated('Use setAlarmRuleRequestDescriptor instead')
const SetAlarmRuleRequest$json = {
  '1': 'SetAlarmRuleRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'min_severity',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'minSeverity'
    },
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Priority',
      '10': 'priority'
    },
    {'1': 'class_code', '3': 5, '4': 1, '5': 9, '10': 'classCode'},
    {'1': 'owner_team', '3': 6, '4': 1, '5': 9, '10': 'ownerTeam'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `SetAlarmRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlarmRuleRequestDescriptor = $convert.base64Decode(
    'ChNTZXRBbGFybVJ1bGVSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eUlkEj'
    'gKBnN5c3RlbRgCIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TeXN0ZW1SBnN5c3Rl'
    'bRJFCgxtaW5fc2V2ZXJpdHkYAyABKA4yIi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU2V2ZX'
    'JpdHlSC21pblNldmVyaXR5Ej4KCHByaW9yaXR5GAQgASgOMiIuaGVhbHRoY2FyZS5mYWNpbGl0'
    'aWVzLnYxLlByaW9yaXR5Ughwcmlvcml0eRIdCgpjbGFzc19jb2RlGAUgASgJUgljbGFzc0NvZG'
    'USHQoKb3duZXJfdGVhbRgGIAEoCVIJb3duZXJUZWFtEhYKBmFjdGl2ZRgHIAEoCFIGYWN0aXZl');

@$core.Deprecated('Use setAlarmRuleResponseDescriptor instead')
const SetAlarmRuleResponse$json = {
  '1': 'SetAlarmRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.AlarmRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `SetAlarmRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAlarmRuleResponseDescriptor = $convert.base64Decode(
    'ChRTZXRBbGFybVJ1bGVSZXNwb25zZRI3CgRydWxlGAEgASgLMiMuaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLkFsYXJtUnVsZVIEcnVsZQ==');

@$core.Deprecated('Use listAlarmsRequestDescriptor instead')
const ListAlarmsRequest$json = {
  '1': 'ListAlarmsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'system',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.AlarmState',
      '10': 'state'
    },
    {'1': 'unanswered_only', '3': 4, '4': 1, '5': 8, '10': 'unansweredOnly'},
    {
      '1': 'from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAlarmsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlarmsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWxhcm1zUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZBI4Cg'
    'ZzeXN0ZW0YAiABKA4yIC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3lzdGVtUgZzeXN0ZW0S'
    'OgoFc3RhdGUYAyABKA4yJC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQWxhcm1TdGF0ZVIFc3'
    'RhdGUSJwoPdW5hbnN3ZXJlZF9vbmx5GAQgASgIUg51bmFuc3dlcmVkT25seRIuCgRmcm9tGAUg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgGIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgHIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listAlarmsResponseDescriptor instead')
const ListAlarmsResponse$json = {
  '1': 'ListAlarmsResponse',
  '2': [
    {
      '1': 'alarms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Alarm',
      '10': 'alarms'
    },
  ],
};

/// Descriptor for `ListAlarmsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlarmsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWxhcm1zUmVzcG9uc2USNwoGYWxhcm1zGAEgAygLMh8uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLkFsYXJtUgZhbGFybXM=');

@$core.Deprecated('Use deficiencyDescriptor instead')
const Deficiency$json = {
  '1': 'Deficiency',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 6, '4': 1, '5': 9, '10': 'locationNote'},
    {
      '1': 'system',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'severity',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'severity'
    },
    {'1': 'finding', '3': 9, '4': 1, '5': 9, '10': 'finding'},
    {'1': 'standard', '3': 10, '4': 1, '5': 9, '10': 'standard'},
    {
      '1': 'state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.DeficiencyState',
      '10': 'state'
    },
    {
      '1': 'raised_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 13, '4': 1, '5': 9, '10': 'raisedBy'},
    {
      '1': 'due_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'work_order_id', '3': 15, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'mitigation_note', '3': 16, '4': 1, '5': 9, '10': 'mitigationNote'},
    {
      '1': 'mitigated_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'mitigatedAt'
    },
    {'1': 'mitigated_by', '3': 18, '4': 1, '5': 9, '10': 'mitigatedBy'},
    {
      '1': 'closed_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 20, '4': 1, '5': 9, '10': 'closedBy'},
    {
      '1': 'closure_evidence_ref',
      '3': 21,
      '4': 1,
      '5': 9,
      '10': 'closureEvidenceRef'
    },
    {'1': 'version', '3': 22, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Deficiency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deficiencyDescriptor = $convert.base64Decode(
    'CgpEZWZpY2llbmN5EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZmljaWVuY3lJZBIXCgd0YX'
    'NrX2lkGAIgASgJUgZ0YXNrSWQSGQoIYXNzZXRfaWQYAyABKAlSB2Fzc2V0SWQSHwoLZmFjaWxp'
    'dHlfaWQYBCABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYBSABKAlSCmxvY2F0aW9uSW'
    'QSIwoNbG9jYXRpb25fbm90ZRgGIAEoCVIMbG9jYXRpb25Ob3RlEjgKBnN5c3RlbRgHIAEoDjIg'
    'LmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TeXN0ZW1SBnN5c3RlbRI+CghzZXZlcml0eRgIIA'
    'EoDjIiLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TZXZlcml0eVIIc2V2ZXJpdHkSGAoHZmlu'
    'ZGluZxgJIAEoCVIHZmluZGluZxIaCghzdGFuZGFyZBgKIAEoCVIIc3RhbmRhcmQSPwoFc3RhdG'
    'UYCyABKA4yKS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuRGVmaWNpZW5jeVN0YXRlUgVzdGF0'
    'ZRI3CglyYWlzZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghyYWlzZW'
    'RBdBIbCglyYWlzZWRfYnkYDSABKAlSCHJhaXNlZEJ5EjEKBmR1ZV9hdBgOIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUF0EiIKDXdvcmtfb3JkZXJfaWQYDyABKAlSC3dvcm'
    'tPcmRlcklkEicKD21pdGlnYXRpb25fbm90ZRgQIAEoCVIObWl0aWdhdGlvbk5vdGUSPQoMbWl0'
    'aWdhdGVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILbWl0aWdhdGVkQX'
    'QSIQoMbWl0aWdhdGVkX2J5GBIgASgJUgttaXRpZ2F0ZWRCeRI3CgljbG9zZWRfYXQYEyABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghjbG9zZWRBdBIbCgljbG9zZWRfYnkYFCABKA'
    'lSCGNsb3NlZEJ5EjAKFGNsb3N1cmVfZXZpZGVuY2VfcmVmGBUgASgJUhJjbG9zdXJlRXZpZGVu'
    'Y2VSZWYSGAoHdmVyc2lvbhgWIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use raiseDeficiencyRequestDescriptor instead')
const RaiseDeficiencyRequest$json = {
  '1': 'RaiseDeficiencyRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'location_note', '3': 5, '4': 1, '5': 9, '10': 'locationNote'},
    {
      '1': 'system',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {
      '1': 'severity',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'severity'
    },
    {'1': 'finding', '3': 8, '4': 1, '5': 9, '10': 'finding'},
    {'1': 'standard', '3': 9, '4': 1, '5': 9, '10': 'standard'},
    {
      '1': 'due_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'work_order_id', '3': 11, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'class_code', '3': 12, '4': 1, '5': 9, '10': 'classCode'},
    {
      '1': 'priority',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Priority',
      '10': 'priority'
    },
  ],
};

/// Descriptor for `RaiseDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseDeficiencyRequestDescriptor = $convert.base64Decode(
    'ChZSYWlzZURlZmljaWVuY3lSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIZCghhc3'
    'NldF9pZBgCIAEoCVIHYXNzZXRJZBIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBIf'
    'Cgtsb2NhdGlvbl9pZBgEIAEoCVIKbG9jYXRpb25JZBIjCg1sb2NhdGlvbl9ub3RlGAUgASgJUg'
    'xsb2NhdGlvbk5vdGUSOAoGc3lzdGVtGAYgASgOMiAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYx'
    'LlN5c3RlbVIGc3lzdGVtEj4KCHNldmVyaXR5GAcgASgOMiIuaGVhbHRoY2FyZS5mYWNpbGl0aW'
    'VzLnYxLlNldmVyaXR5UghzZXZlcml0eRIYCgdmaW5kaW5nGAggASgJUgdmaW5kaW5nEhoKCHN0'
    'YW5kYXJkGAkgASgJUghzdGFuZGFyZBIxCgZkdWVfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgVkdWVBdBIiCg13b3JrX29yZGVyX2lkGAsgASgJUgt3b3JrT3JkZXJJZBId'
    'CgpjbGFzc19jb2RlGAwgASgJUgljbGFzc0NvZGUSPgoIcHJpb3JpdHkYDSABKA4yIi5oZWFsdG'
    'hjYXJlLmZhY2lsaXRpZXMudjEuUHJpb3JpdHlSCHByaW9yaXR5');

@$core.Deprecated('Use raiseDeficiencyResponseDescriptor instead')
const RaiseDeficiencyResponse$json = {
  '1': 'RaiseDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiency'
    },
    {
      '1': 'work_order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'workOrder'
    },
    {'1': 'raised_work', '3': 3, '4': 1, '5': 8, '10': 'raisedWork'},
  ],
};

/// Descriptor for `RaiseDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseDeficiencyResponseDescriptor = $convert.base64Decode(
    'ChdSYWlzZURlZmljaWVuY3lSZXNwb25zZRJECgpkZWZpY2llbmN5GAEgASgLMiQuaGVhbHRoY2'
    'FyZS5mYWNpbGl0aWVzLnYxLkRlZmljaWVuY3lSCmRlZmljaWVuY3kSQgoKd29ya19vcmRlchgC'
    'IAEoCzIjLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5Xb3JrT3JkZXJSCXdvcmtPcmRlchIfCg'
    'tyYWlzZWRfd29yaxgDIAEoCFIKcmFpc2VkV29yaw==');

@$core.Deprecated('Use mitigateDeficiencyRequestDescriptor instead')
const MitigateDeficiencyRequest$json = {
  '1': 'MitigateDeficiencyRequest',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `MitigateDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mitigateDeficiencyRequestDescriptor = $convert.base64Decode(
    'ChlNaXRpZ2F0ZURlZmljaWVuY3lSZXF1ZXN0EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZm'
    'ljaWVuY3lJZBISCgRub3RlGAIgASgJUgRub3RlEhgKB3ZlcnNpb24YAyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use mitigateDeficiencyResponseDescriptor instead')
const MitigateDeficiencyResponse$json = {
  '1': 'MitigateDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `MitigateDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mitigateDeficiencyResponseDescriptor =
    $convert.base64Decode(
        'ChpNaXRpZ2F0ZURlZmljaWVuY3lSZXNwb25zZRJECgpkZWZpY2llbmN5GAEgASgLMiQuaGVhbH'
        'RoY2FyZS5mYWNpbGl0aWVzLnYxLkRlZmljaWVuY3lSCmRlZmljaWVuY3k=');

@$core.Deprecated('Use closeDeficiencyRequestDescriptor instead')
const CloseDeficiencyRequest$json = {
  '1': 'CloseDeficiencyRequest',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'evidence_ref', '3': 2, '4': 1, '5': 9, '10': 'evidenceRef'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CloseDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeDeficiencyRequestDescriptor = $convert.base64Decode(
    'ChZDbG9zZURlZmljaWVuY3lSZXF1ZXN0EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZmljaW'
    'VuY3lJZBIhCgxldmlkZW5jZV9yZWYYAiABKAlSC2V2aWRlbmNlUmVmEhgKB3ZlcnNpb24YAyAB'
    'KANSB3ZlcnNpb24=');

@$core.Deprecated('Use closeDeficiencyResponseDescriptor instead')
const CloseDeficiencyResponse$json = {
  '1': 'CloseDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `CloseDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeDeficiencyResponseDescriptor =
    $convert.base64Decode(
        'ChdDbG9zZURlZmljaWVuY3lSZXNwb25zZRJECgpkZWZpY2llbmN5GAEgASgLMiQuaGVhbHRoY2'
        'FyZS5mYWNpbGl0aWVzLnYxLkRlZmljaWVuY3lSCmRlZmljaWVuY3k=');

@$core.Deprecated('Use listDeficienciesRequestDescriptor instead')
const ListDeficienciesRequest$json = {
  '1': 'ListDeficienciesRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'severity',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Severity',
      '10': 'severity'
    },
    {'1': 'open_only', '3': 4, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDeficienciesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeficienciesRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0RGVmaWNpZW5jaWVzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBIXCgd0YXNrX2lkGAIgASgJUgZ0YXNrSWQSPgoIc2V2ZXJpdHkYAyABKA4yIi5oZWFsdGhj'
    'YXJlLmZhY2lsaXRpZXMudjEuU2V2ZXJpdHlSCHNldmVyaXR5EhsKCW9wZW5fb25seRgEIAEoCF'
    'IIb3Blbk9ubHkSGwoJcGFnZV9zaXplGAUgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listDeficienciesResponseDescriptor instead')
const ListDeficienciesResponse$json = {
  '1': 'ListDeficienciesResponse',
  '2': [
    {
      '1': 'deficiencies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiencies'
    },
  ],
};

/// Descriptor for `ListDeficienciesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeficienciesResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0RGVmaWNpZW5jaWVzUmVzcG9uc2USSAoMZGVmaWNpZW5jaWVzGAEgAygLMiQuaGVhbH'
        'RoY2FyZS5mYWNpbGl0aWVzLnYxLkRlZmljaWVuY3lSDGRlZmljaWVuY2llcw==');

@$core.Deprecated('Use listOpenCriticalRequestDescriptor instead')
const ListOpenCriticalRequest$json = {
  '1': 'ListOpenCriticalRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListOpenCriticalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenCriticalRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0T3BlbkNyaXRpY2FsUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
        'lJZA==');

@$core.Deprecated('Use listOpenCriticalResponseDescriptor instead')
const ListOpenCriticalResponse$json = {
  '1': 'ListOpenCriticalResponse',
  '2': [
    {
      '1': 'deficiencies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiencies'
    },
  ],
};

/// Descriptor for `ListOpenCriticalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenCriticalResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0T3BlbkNyaXRpY2FsUmVzcG9uc2USSAoMZGVmaWNpZW5jaWVzGAEgAygLMiQuaGVhbH'
        'RoY2FyZS5mYWNpbGl0aWVzLnYxLkRlZmljaWVuY3lSDGRlZmljaWVuY2llcw==');

@$core.Deprecated('Use listBlockingRequestDescriptor instead')
const ListBlockingRequest$json = {
  '1': 'ListBlockingRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
  ],
};

/// Descriptor for `ListBlockingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockingRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0QmxvY2tpbmdSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZA==');

@$core.Deprecated('Use listBlockingResponseDescriptor instead')
const ListBlockingResponse$json = {
  '1': 'ListBlockingResponse',
  '2': [
    {
      '1': 'deficiencies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'deficiencies'
    },
  ],
};

/// Descriptor for `ListBlockingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockingResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QmxvY2tpbmdSZXNwb25zZRJICgxkZWZpY2llbmNpZXMYASADKAsyJC5oZWFsdGhjYX'
    'JlLmZhY2lsaXRpZXMudjEuRGVmaWNpZW5jeVIMZGVmaWNpZW5jaWVz');

@$core.Deprecated('Use safetyReportDescriptor instead')
const SafetyReport$json = {
  '1': 'SafetyReport',
  '2': [
    {'1': 'open_critical', '3': 1, '4': 1, '5': 5, '10': 'openCritical'},
    {'1': 'mitigated', '3': 2, '4': 1, '5': 5, '10': 'mitigated'},
    {'1': 'overdue', '3': 3, '4': 1, '5': 5, '10': 'overdue'},
    {'1': 'closed_in_window', '3': 4, '4': 1, '5': 5, '10': 'closedInWindow'},
    {'1': 'oldest_open_days', '3': 5, '4': 1, '5': 5, '10': 'oldestOpenDays'},
    {
      '1': 'findings',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Deficiency',
      '10': 'findings'
    },
  ],
};

/// Descriptor for `SafetyReport`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List safetyReportDescriptor = $convert.base64Decode(
    'CgxTYWZldHlSZXBvcnQSIwoNb3Blbl9jcml0aWNhbBgBIAEoBVIMb3BlbkNyaXRpY2FsEhwKCW'
    '1pdGlnYXRlZBgCIAEoBVIJbWl0aWdhdGVkEhgKB292ZXJkdWUYAyABKAVSB292ZXJkdWUSKAoQ'
    'Y2xvc2VkX2luX3dpbmRvdxgEIAEoBVIOY2xvc2VkSW5XaW5kb3cSKAoQb2xkZXN0X29wZW5fZG'
    'F5cxgFIAEoBVIOb2xkZXN0T3BlbkRheXMSQAoIZmluZGluZ3MYBiADKAsyJC5oZWFsdGhjYXJl'
    'LmZhY2lsaXRpZXMudjEuRGVmaWNpZW5jeVIIZmluZGluZ3M=');

@$core.Deprecated('Use getSafetyReportRequestDescriptor instead')
const GetSafetyReportRequest$json = {
  '1': 'GetSafetyReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
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

/// Descriptor for `GetSafetyReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSafetyReportRequestDescriptor = $convert.base64Decode(
    'ChZHZXRTYWZldHlSZXBvcnRSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eU'
    'lkEi4KBGZyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRv'
    'GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getSafetyReportResponseDescriptor instead')
const GetSafetyReportResponse$json = {
  '1': 'GetSafetyReportResponse',
  '2': [
    {
      '1': 'report',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.SafetyReport',
      '10': 'report'
    },
  ],
};

/// Descriptor for `GetSafetyReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSafetyReportResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRTYWZldHlSZXBvcnRSZXNwb25zZRI+CgZyZXBvcnQYASABKAsyJi5oZWFsdGhjYXJlLm'
        'ZhY2lsaXRpZXMudjEuU2FmZXR5UmVwb3J0UgZyZXBvcnQ=');

@$core.Deprecated('Use meterDescriptor instead')
const Meter$json = {
  '1': 'Meter',
  '2': [
    {'1': 'meter_id', '3': 1, '4': 1, '5': 9, '10': 'meterId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'utility',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Utility',
      '10': 'utility'
    },
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 7, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'asset_id', '3': 8, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'source',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 10, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'cumulative', '3': 11, '4': 1, '5': 8, '10': 'cumulative'},
    {'1': 'register_max', '3': 12, '4': 1, '5': 5, '10': 'registerMax'},
    {'1': 'active', '3': 13, '4': 1, '5': 8, '10': 'active'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Meter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List meterDescriptor = $convert.base64Decode(
    'CgVNZXRlchIZCghtZXRlcl9pZBgBIAEoCVIHbWV0ZXJJZBISCgRjb2RlGAIgASgJUgRjb2RlEh'
    'IKBG5hbWUYAyABKAlSBG5hbWUSOwoHdXRpbGl0eRgEIAEoDjIhLmhlYWx0aGNhcmUuZmFjaWxp'
    'dGllcy52MS5VdGlsaXR5Ugd1dGlsaXR5EhIKBHVuaXQYBSABKAlSBHVuaXQSHwoLZmFjaWxpdH'
    'lfaWQYBiABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYByABKAlSCmxvY2F0aW9uSWQS'
    'GQoIYXNzZXRfaWQYCCABKAlSB2Fzc2V0SWQSOAoGc291cmNlGAkgASgOMiAuaGVhbHRoY2FyZS'
    '5mYWNpbGl0aWVzLnYxLlNvdXJjZVIGc291cmNlEh0KCnNvdXJjZV9yZWYYCiABKAlSCXNvdXJj'
    'ZVJlZhIeCgpjdW11bGF0aXZlGAsgASgIUgpjdW11bGF0aXZlEiEKDHJlZ2lzdGVyX21heBgMIA'
    'EoBVILcmVnaXN0ZXJNYXgSFgoGYWN0aXZlGA0gASgIUgZhY3RpdmUSGAoHdmVyc2lvbhgOIAEo'
    'A1IHdmVyc2lvbg==');

@$core.Deprecated('Use readingDescriptor instead')
const Reading$json = {
  '1': 'Reading',
  '2': [
    {'1': 'reading_id', '3': 1, '4': 1, '5': 9, '10': 'readingId'},
    {'1': 'meter_id', '3': 2, '4': 1, '5': 9, '10': 'meterId'},
    {'1': 'value', '3': 3, '4': 1, '5': 5, '10': 'value'},
    {
      '1': 'read_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 6, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'recorded_by', '3': 7, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'rolled_over', '3': 8, '4': 1, '5': 8, '10': 'rolledOver'},
    {'1': 'note', '3': 9, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Reading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readingDescriptor = $convert.base64Decode(
    'CgdSZWFkaW5nEh0KCnJlYWRpbmdfaWQYASABKAlSCXJlYWRpbmdJZBIZCghtZXRlcl9pZBgCIA'
    'EoCVIHbWV0ZXJJZBIUCgV2YWx1ZRgDIAEoBVIFdmFsdWUSMwoHcmVhZF9hdBgEIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBnJlYWRBdBI4CgZzb3VyY2UYBSABKA4yIC5oZWFsdG'
    'hjYXJlLmZhY2lsaXRpZXMudjEuU291cmNlUgZzb3VyY2USHQoKc291cmNlX3JlZhgGIAEoCVIJ'
    'c291cmNlUmVmEh8KC3JlY29yZGVkX2J5GAcgASgJUgpyZWNvcmRlZEJ5Eh8KC3JvbGxlZF9vdm'
    'VyGAggASgIUgpyb2xsZWRPdmVyEhIKBG5vdGUYCSABKAlSBG5vdGU=');

@$core.Deprecated('Use addMeterRequestDescriptor instead')
const AddMeterRequest$json = {
  '1': 'AddMeterRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'utility',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Utility',
      '10': 'utility'
    },
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 6, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'asset_id', '3': 7, '4': 1, '5': 9, '10': 'assetId'},
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 9, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'cumulative', '3': 10, '4': 1, '5': 8, '10': 'cumulative'},
    {'1': 'register_max', '3': 11, '4': 1, '5': 5, '10': 'registerMax'},
  ],
};

/// Descriptor for `AddMeterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMeterRequestDescriptor = $convert.base64Decode(
    'Cg9BZGRNZXRlclJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgASgJUgRuYW'
    '1lEjsKB3V0aWxpdHkYAyABKA4yIS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuVXRpbGl0eVIH'
    'dXRpbGl0eRISCgR1bml0GAQgASgJUgR1bml0Eh8KC2ZhY2lsaXR5X2lkGAUgASgJUgpmYWNpbG'
    'l0eUlkEh8KC2xvY2F0aW9uX2lkGAYgASgJUgpsb2NhdGlvbklkEhkKCGFzc2V0X2lkGAcgASgJ'
    'Ugdhc3NldElkEjgKBnNvdXJjZRgIIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5Tb3'
    'VyY2VSBnNvdXJjZRIdCgpzb3VyY2VfcmVmGAkgASgJUglzb3VyY2VSZWYSHgoKY3VtdWxhdGl2'
    'ZRgKIAEoCFIKY3VtdWxhdGl2ZRIhCgxyZWdpc3Rlcl9tYXgYCyABKAVSC3JlZ2lzdGVyTWF4');

@$core.Deprecated('Use addMeterResponseDescriptor instead')
const AddMeterResponse$json = {
  '1': 'AddMeterResponse',
  '2': [
    {
      '1': 'meter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Meter',
      '10': 'meter'
    },
  ],
};

/// Descriptor for `AddMeterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addMeterResponseDescriptor = $convert.base64Decode(
    'ChBBZGRNZXRlclJlc3BvbnNlEjUKBW1ldGVyGAEgASgLMh8uaGVhbHRoY2FyZS5mYWNpbGl0aW'
    'VzLnYxLk1ldGVyUgVtZXRlcg==');

@$core.Deprecated('Use recordMeterReadingRequestDescriptor instead')
const RecordMeterReadingRequest$json = {
  '1': 'RecordMeterReadingRequest',
  '2': [
    {'1': 'meter_id', '3': 1, '4': 1, '5': 9, '10': 'meterId'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
    {
      '1': 'read_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
    {
      '1': 'source',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'source'
    },
    {'1': 'source_ref', '3': 5, '4': 1, '5': 9, '10': 'sourceRef'},
    {'1': 'rolled_over', '3': 6, '4': 1, '5': 8, '10': 'rolledOver'},
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordMeterReadingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMeterReadingRequestDescriptor = $convert.base64Decode(
    'ChlSZWNvcmRNZXRlclJlYWRpbmdSZXF1ZXN0EhkKCG1ldGVyX2lkGAEgASgJUgdtZXRlcklkEh'
    'QKBXZhbHVlGAIgASgFUgV2YWx1ZRIzCgdyZWFkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIGcmVhZEF0EjgKBnNvdXJjZRgEIAEoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdG'
    'llcy52MS5Tb3VyY2VSBnNvdXJjZRIdCgpzb3VyY2VfcmVmGAUgASgJUglzb3VyY2VSZWYSHwoL'
    'cm9sbGVkX292ZXIYBiABKAhSCnJvbGxlZE92ZXISEgoEbm90ZRgHIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use recordMeterReadingResponseDescriptor instead')
const RecordMeterReadingResponse$json = {
  '1': 'RecordMeterReadingResponse',
  '2': [
    {
      '1': 'reading',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Reading',
      '10': 'reading'
    },
  ],
};

/// Descriptor for `RecordMeterReadingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMeterReadingResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWNvcmRNZXRlclJlYWRpbmdSZXNwb25zZRI7CgdyZWFkaW5nGAEgASgLMiEuaGVhbHRoY2'
        'FyZS5mYWNpbGl0aWVzLnYxLlJlYWRpbmdSB3JlYWRpbmc=');

@$core.Deprecated('Use listMetersRequestDescriptor instead')
const ListMetersRequest$json = {
  '1': 'ListMetersRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'utility',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Utility',
      '10': 'utility'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListMetersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMetersRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0TWV0ZXJzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZBI7Cg'
    'd1dGlsaXR5GAIgASgOMiEuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlV0aWxpdHlSB3V0aWxp'
    'dHkSGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listMetersResponseDescriptor instead')
const ListMetersResponse$json = {
  '1': 'ListMetersResponse',
  '2': [
    {
      '1': 'meters',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Meter',
      '10': 'meters'
    },
  ],
};

/// Descriptor for `ListMetersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMetersResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0TWV0ZXJzUmVzcG9uc2USNwoGbWV0ZXJzGAEgAygLMh8uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLk1ldGVyUgZtZXRlcnM=');

@$core.Deprecated('Use consumptionDescriptor instead')
const Consumption$json = {
  '1': 'Consumption',
  '2': [
    {'1': 'meter_id', '3': 1, '4': 1, '5': 9, '10': 'meterId'},
    {
      '1': 'utility',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.Utility',
      '10': 'utility'
    },
    {'1': 'unit', '3': 3, '4': 1, '5': 9, '10': 'unit'},
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
    {'1': 'quantity', '3': 6, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'readings', '3': 7, '4': 1, '5': 5, '10': 'readings'},
    {
      '1': 'sources',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.healthcare.facilities.v1.Source',
      '10': 'sources'
    },
    {'1': 'estimated', '3': 9, '4': 1, '5': 8, '10': 'estimated'},
    {'1': 'rollovers', '3': 10, '4': 1, '5': 5, '10': 'rollovers'},
  ],
};

/// Descriptor for `Consumption`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consumptionDescriptor = $convert.base64Decode(
    'CgtDb25zdW1wdGlvbhIZCghtZXRlcl9pZBgBIAEoCVIHbWV0ZXJJZBI7Cgd1dGlsaXR5GAIgAS'
    'gOMiEuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlV0aWxpdHlSB3V0aWxpdHkSEgoEdW5pdBgD'
    'IAEoCVIEdW5pdBIuCgRmcm9tGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZn'
    'JvbRIqCgJ0bxgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhoKCHF1YW50'
    'aXR5GAYgASgFUghxdWFudGl0eRIaCghyZWFkaW5ncxgHIAEoBVIIcmVhZGluZ3MSOgoHc291cm'
    'NlcxgIIAMoDjIgLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5Tb3VyY2VSB3NvdXJjZXMSHAoJ'
    'ZXN0aW1hdGVkGAkgASgIUgllc3RpbWF0ZWQSHAoJcm9sbG92ZXJzGAogASgFUglyb2xsb3Zlcn'
    'M=');

@$core.Deprecated('Use getConsumptionRequestDescriptor instead')
const GetConsumptionRequest$json = {
  '1': 'GetConsumptionRequest',
  '2': [
    {'1': 'meter_id', '3': 1, '4': 1, '5': 9, '10': 'meterId'},
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

/// Descriptor for `GetConsumptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConsumptionRequestDescriptor = $convert.base64Decode(
    'ChVHZXRDb25zdW1wdGlvblJlcXVlc3QSGQoIbWV0ZXJfaWQYASABKAlSB21ldGVySWQSLgoEZn'
    'JvbRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAyABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bw==');

@$core.Deprecated('Use getConsumptionResponseDescriptor instead')
const GetConsumptionResponse$json = {
  '1': 'GetConsumptionResponse',
  '2': [
    {
      '1': 'consumption',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Consumption',
      '10': 'consumption'
    },
    {'1': 'available', '3': 2, '4': 1, '5': 8, '10': 'available'},
  ],
};

/// Descriptor for `GetConsumptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getConsumptionResponseDescriptor = $convert.base64Decode(
    'ChZHZXRDb25zdW1wdGlvblJlc3BvbnNlEkcKC2NvbnN1bXB0aW9uGAEgASgLMiUuaGVhbHRoY2'
    'FyZS5mYWNpbGl0aWVzLnYxLkNvbnN1bXB0aW9uUgtjb25zdW1wdGlvbhIcCglhdmFpbGFibGUY'
    'AiABKAhSCWF2YWlsYWJsZQ==');

@$core.Deprecated('Use downtimeDescriptor instead')
const Downtime$json = {
  '1': 'Downtime',
  '2': [
    {
      '1': 'system',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.System',
      '10': 'system'
    },
    {'1': 'minutes', '3': 2, '4': 1, '5': 5, '10': 'minutes'},
    {'1': 'incidents', '3': 3, '4': 1, '5': 5, '10': 'incidents'},
    {'1': 'work_order_ids', '3': 4, '4': 3, '5': 9, '10': 'workOrderIds'},
    {'1': 'unmeasured', '3': 5, '4': 1, '5': 5, '10': 'unmeasured'},
  ],
};

/// Descriptor for `Downtime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downtimeDescriptor = $convert.base64Decode(
    'CghEb3dudGltZRI4CgZzeXN0ZW0YASABKA4yIC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3'
    'lzdGVtUgZzeXN0ZW0SGAoHbWludXRlcxgCIAEoBVIHbWludXRlcxIcCglpbmNpZGVudHMYAyAB'
    'KAVSCWluY2lkZW50cxIkCg53b3JrX29yZGVyX2lkcxgEIAMoCVIMd29ya09yZGVySWRzEh4KCn'
    'VubWVhc3VyZWQYBSABKAVSCnVubWVhc3VyZWQ=');

@$core.Deprecated('Use getDowntimeRequestDescriptor instead')
const GetDowntimeRequest$json = {
  '1': 'GetDowntimeRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
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

/// Descriptor for `GetDowntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDowntimeRequestDescriptor = $convert.base64Decode(
    'ChJHZXREb3dudGltZVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSLg'
    'oEZnJvbRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAyAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bw==');

@$core.Deprecated('Use getDowntimeResponseDescriptor instead')
const GetDowntimeResponse$json = {
  '1': 'GetDowntimeResponse',
  '2': [
    {
      '1': 'downtime',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Downtime',
      '10': 'downtime'
    },
  ],
};

/// Descriptor for `GetDowntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDowntimeResponseDescriptor = $convert.base64Decode(
    'ChNHZXREb3dudGltZVJlc3BvbnNlEj4KCGRvd250aW1lGAEgAygLMiIuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLkRvd250aW1lUghkb3dudGltZQ==');

@$core.Deprecated('Use sLAPerformanceDescriptor instead')
const SLAPerformance$json = {
  '1': 'SLAPerformance',
  '2': [
    {'1': 'open', '3': 1, '4': 1, '5': 5, '10': 'open'},
    {
      '1': 'response_breaches',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'responseBreaches'
    },
    {
      '1': 'resolution_breaches',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'resolutionBreaches'
    },
    {
      '1': 'worst_open',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.WorkOrder',
      '10': 'worstOpen'
    },
  ],
};

/// Descriptor for `SLAPerformance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sLAPerformanceDescriptor = $convert.base64Decode(
    'Cg5TTEFQZXJmb3JtYW5jZRISCgRvcGVuGAEgASgFUgRvcGVuEisKEXJlc3BvbnNlX2JyZWFjaG'
    'VzGAIgASgFUhByZXNwb25zZUJyZWFjaGVzEi8KE3Jlc29sdXRpb25fYnJlYWNoZXMYAyABKAVS'
    'EnJlc29sdXRpb25CcmVhY2hlcxJCCgp3b3JzdF9vcGVuGAQgAygLMiMuaGVhbHRoY2FyZS5mYW'
    'NpbGl0aWVzLnYxLldvcmtPcmRlclIJd29yc3RPcGVu');

@$core.Deprecated('Use getPerformanceRequestDescriptor instead')
const GetPerformanceRequest$json = {
  '1': 'GetPerformanceRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetPerformanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPerformanceRequestDescriptor = $convert.base64Decode(
    'ChVHZXRQZXJmb3JtYW5jZVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SW'
    'Q=');

@$core.Deprecated('Use getPerformanceResponseDescriptor instead')
const GetPerformanceResponse$json = {
  '1': 'GetPerformanceResponse',
  '2': [
    {
      '1': 'performance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.SLAPerformance',
      '10': 'performance'
    },
  ],
};

/// Descriptor for `GetPerformanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPerformanceResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRQZXJmb3JtYW5jZVJlc3BvbnNlEkoKC3BlcmZvcm1hbmNlGAEgASgLMiguaGVhbHRoY2'
        'FyZS5mYWNpbGl0aWVzLnYxLlNMQVBlcmZvcm1hbmNlUgtwZXJmb3JtYW5jZQ==');

@$core.Deprecated('Use visitDescriptor instead')
const Visit$json = {
  '1': 'Visit',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'vendor_name', '3': 2, '4': 1, '5': 9, '10': 'vendorName'},
    {'1': 'vendor_ref', '3': 3, '4': 1, '5': 9, '10': 'vendorRef'},
    {'1': 'contact_name', '3': 4, '4': 1, '5': 9, '10': 'contactName'},
    {'1': 'technicians', '3': 5, '4': 3, '5': 9, '10': 'technicians'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'work_order_id', '3': 7, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'asset_id', '3': 8, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'task_id', '3': 9, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'work_requires_permit',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'workRequiresPermit'
    },
    {'1': 'induction_ref', '3': 11, '4': 1, '5': 9, '10': 'inductionRef'},
    {'1': 'purpose', '3': 12, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.facilities.v1.VisitState',
      '10': 'state'
    },
    {
      '1': 'signed_in_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedInAt'
    },
    {'1': 'signed_in_by', '3': 15, '4': 1, '5': 9, '10': 'signedInBy'},
    {
      '1': 'signed_out_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedOutAt'
    },
    {'1': 'signed_out_by', '3': 17, '4': 1, '5': 9, '10': 'signedOutBy'},
    {
      '1': 'service_report_ref',
      '3': 18,
      '4': 1,
      '5': 9,
      '10': 'serviceReportRef'
    },
    {'1': 'report_summary', '3': 19, '4': 1, '5': 9, '10': 'reportSummary'},
    {'1': 'parts_used', '3': 20, '4': 3, '5': 9, '10': 'partsUsed'},
    {'1': 'follow_up', '3': 21, '4': 1, '5': 9, '10': 'followUp'},
    {'1': 'version', '3': 22, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Visit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List visitDescriptor = $convert.base64Decode(
    'CgVWaXNpdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBIfCgt2ZW5kb3JfbmFtZRgCIAEoCV'
    'IKdmVuZG9yTmFtZRIdCgp2ZW5kb3JfcmVmGAMgASgJUgl2ZW5kb3JSZWYSIQoMY29udGFjdF9u'
    'YW1lGAQgASgJUgtjb250YWN0TmFtZRIgCgt0ZWNobmljaWFucxgFIAMoCVILdGVjaG5pY2lhbn'
    'MSHwoLZmFjaWxpdHlfaWQYBiABKAlSCmZhY2lsaXR5SWQSIgoNd29ya19vcmRlcl9pZBgHIAEo'
    'CVILd29ya09yZGVySWQSGQoIYXNzZXRfaWQYCCABKAlSB2Fzc2V0SWQSFwoHdGFza19pZBgJIA'
    'EoCVIGdGFza0lkEjAKFHdvcmtfcmVxdWlyZXNfcGVybWl0GAogASgIUhJ3b3JrUmVxdWlyZXNQ'
    'ZXJtaXQSIwoNaW5kdWN0aW9uX3JlZhgLIAEoCVIMaW5kdWN0aW9uUmVmEhgKB3B1cnBvc2UYDC'
    'ABKAlSB3B1cnBvc2USOgoFc3RhdGUYDSABKA4yJC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEu'
    'VmlzaXRTdGF0ZVIFc3RhdGUSPAoMc2lnbmVkX2luX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIKc2lnbmVkSW5BdBIgCgxzaWduZWRfaW5fYnkYDyABKAlSCnNpZ25lZElu'
    'QnkSPgoNc2lnbmVkX291dF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3'
    'NpZ25lZE91dEF0EiIKDXNpZ25lZF9vdXRfYnkYESABKAlSC3NpZ25lZE91dEJ5EiwKEnNlcnZp'
    'Y2VfcmVwb3J0X3JlZhgSIAEoCVIQc2VydmljZVJlcG9ydFJlZhIlCg5yZXBvcnRfc3VtbWFyeR'
    'gTIAEoCVINcmVwb3J0U3VtbWFyeRIdCgpwYXJ0c191c2VkGBQgAygJUglwYXJ0c1VzZWQSGwoJ'
    'Zm9sbG93X3VwGBUgASgJUghmb2xsb3dVcBIYCgd2ZXJzaW9uGBYgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use signInVendorRequestDescriptor instead')
const SignInVendorRequest$json = {
  '1': 'SignInVendorRequest',
  '2': [
    {'1': 'vendor_name', '3': 1, '4': 1, '5': 9, '10': 'vendorName'},
    {'1': 'vendor_ref', '3': 2, '4': 1, '5': 9, '10': 'vendorRef'},
    {'1': 'contact_name', '3': 3, '4': 1, '5': 9, '10': 'contactName'},
    {'1': 'technicians', '3': 4, '4': 3, '5': 9, '10': 'technicians'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'work_order_id', '3': 6, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'asset_id', '3': 7, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'task_id', '3': 8, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'induction_ref', '3': 9, '4': 1, '5': 9, '10': 'inductionRef'},
    {'1': 'purpose', '3': 10, '4': 1, '5': 9, '10': 'purpose'},
  ],
};

/// Descriptor for `SignInVendorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInVendorRequestDescriptor = $convert.base64Decode(
    'ChNTaWduSW5WZW5kb3JSZXF1ZXN0Eh8KC3ZlbmRvcl9uYW1lGAEgASgJUgp2ZW5kb3JOYW1lEh'
    '0KCnZlbmRvcl9yZWYYAiABKAlSCXZlbmRvclJlZhIhCgxjb250YWN0X25hbWUYAyABKAlSC2Nv'
    'bnRhY3ROYW1lEiAKC3RlY2huaWNpYW5zGAQgAygJUgt0ZWNobmljaWFucxIfCgtmYWNpbGl0eV'
    '9pZBgFIAEoCVIKZmFjaWxpdHlJZBIiCg13b3JrX29yZGVyX2lkGAYgASgJUgt3b3JrT3JkZXJJ'
    'ZBIZCghhc3NldF9pZBgHIAEoCVIHYXNzZXRJZBIXCgd0YXNrX2lkGAggASgJUgZ0YXNrSWQSIw'
    'oNaW5kdWN0aW9uX3JlZhgJIAEoCVIMaW5kdWN0aW9uUmVmEhgKB3B1cnBvc2UYCiABKAlSB3B1'
    'cnBvc2U=');

@$core.Deprecated('Use signInVendorResponseDescriptor instead')
const SignInVendorResponse$json = {
  '1': 'SignInVendorResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Visit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `SignInVendorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signInVendorResponseDescriptor = $convert.base64Decode(
    'ChRTaWduSW5WZW5kb3JSZXNwb25zZRI1CgV2aXNpdBgBIAEoCzIfLmhlYWx0aGNhcmUuZmFjaW'
    'xpdGllcy52MS5WaXNpdFIFdmlzaXQ=');

@$core.Deprecated('Use signOutVendorRequestDescriptor instead')
const SignOutVendorRequest$json = {
  '1': 'SignOutVendorRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'service_report_ref',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'serviceReportRef'
    },
    {'1': 'report_summary', '3': 3, '4': 1, '5': 9, '10': 'reportSummary'},
    {'1': 'parts_used', '3': 4, '4': 3, '5': 9, '10': 'partsUsed'},
    {'1': 'follow_up', '3': 5, '4': 1, '5': 9, '10': 'followUp'},
    {'1': 'version', '3': 6, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SignOutVendorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOutVendorRequestDescriptor = $convert.base64Decode(
    'ChRTaWduT3V0VmVuZG9yUmVxdWVzdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBIsChJzZX'
    'J2aWNlX3JlcG9ydF9yZWYYAiABKAlSEHNlcnZpY2VSZXBvcnRSZWYSJQoOcmVwb3J0X3N1bW1h'
    'cnkYAyABKAlSDXJlcG9ydFN1bW1hcnkSHQoKcGFydHNfdXNlZBgEIAMoCVIJcGFydHNVc2VkEh'
    'sKCWZvbGxvd191cBgFIAEoCVIIZm9sbG93VXASGAoHdmVyc2lvbhgGIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use signOutVendorResponseDescriptor instead')
const SignOutVendorResponse$json = {
  '1': 'SignOutVendorResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.facilities.v1.Visit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `SignOutVendorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOutVendorResponseDescriptor = $convert.base64Decode(
    'ChVTaWduT3V0VmVuZG9yUmVzcG9uc2USNQoFdmlzaXQYASABKAsyHy5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuVmlzaXRSBXZpc2l0');

@$core.Deprecated('Use listVendorVisitsRequestDescriptor instead')
const ListVendorVisitsRequest$json = {
  '1': 'ListVendorVisitsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'work_order_id', '3': 2, '4': 1, '5': 9, '10': 'workOrderId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'on_site_only', '3': 4, '4': 1, '5': 8, '10': 'onSiteOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListVendorVisitsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVendorVisitsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0VmVuZG9yVmlzaXRzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBIiCg13b3JrX29yZGVyX2lkGAIgASgJUgt3b3JrT3JkZXJJZBIZCghhc3NldF9pZBgDIAEo'
    'CVIHYXNzZXRJZBIgCgxvbl9zaXRlX29ubHkYBCABKAhSCm9uU2l0ZU9ubHkSGwoJcGFnZV9zaX'
    'plGAUgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listVendorVisitsResponseDescriptor instead')
const ListVendorVisitsResponse$json = {
  '1': 'ListVendorVisitsResponse',
  '2': [
    {
      '1': 'visits',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.facilities.v1.Visit',
      '10': 'visits'
    },
  ],
};

/// Descriptor for `ListVendorVisitsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVendorVisitsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0VmVuZG9yVmlzaXRzUmVzcG9uc2USNwoGdmlzaXRzGAEgAygLMh8uaGVhbHRoY2FyZS'
        '5mYWNpbGl0aWVzLnYxLlZpc2l0UgZ2aXNpdHM=');

const $core.Map<$core.String, $core.dynamic> FacilitiesServiceBase$json = {
  '1': 'FacilitiesService',
  '2': [
    {
      '1': 'RegisterAsset',
      '2': '.healthcare.facilities.v1.RegisterAssetRequest',
      '3': '.healthcare.facilities.v1.RegisterAssetResponse'
    },
    {
      '1': 'SetAssetStatus',
      '2': '.healthcare.facilities.v1.SetAssetStatusRequest',
      '3': '.healthcare.facilities.v1.SetAssetStatusResponse'
    },
    {
      '1': 'GetAsset',
      '2': '.healthcare.facilities.v1.GetAssetRequest',
      '3': '.healthcare.facilities.v1.GetAssetResponse'
    },
    {
      '1': 'ListAssets',
      '2': '.healthcare.facilities.v1.ListAssetsRequest',
      '3': '.healthcare.facilities.v1.ListAssetsResponse'
    },
    {
      '1': 'GetAssetTree',
      '2': '.healthcare.facilities.v1.GetAssetTreeRequest',
      '3': '.healthcare.facilities.v1.GetAssetTreeResponse'
    },
    {
      '1': 'ListDownAssets',
      '2': '.healthcare.facilities.v1.ListDownAssetsRequest',
      '3': '.healthcare.facilities.v1.ListDownAssetsResponse'
    },
    {
      '1': 'SetWorkClass',
      '2': '.healthcare.facilities.v1.SetWorkClassRequest',
      '3': '.healthcare.facilities.v1.SetWorkClassResponse'
    },
    {
      '1': 'ListWorkClasses',
      '2': '.healthcare.facilities.v1.ListWorkClassesRequest',
      '3': '.healthcare.facilities.v1.ListWorkClassesResponse'
    },
    {
      '1': 'RaiseWork',
      '2': '.healthcare.facilities.v1.RaiseWorkRequest',
      '3': '.healthcare.facilities.v1.RaiseWorkResponse'
    },
    {
      '1': 'AssignWork',
      '2': '.healthcare.facilities.v1.AssignWorkRequest',
      '3': '.healthcare.facilities.v1.AssignWorkResponse'
    },
    {
      '1': 'StartWork',
      '2': '.healthcare.facilities.v1.StartWorkRequest',
      '3': '.healthcare.facilities.v1.StartWorkResponse'
    },
    {
      '1': 'HoldWork',
      '2': '.healthcare.facilities.v1.HoldWorkRequest',
      '3': '.healthcare.facilities.v1.HoldWorkResponse'
    },
    {
      '1': 'ResolveWork',
      '2': '.healthcare.facilities.v1.ResolveWorkRequest',
      '3': '.healthcare.facilities.v1.ResolveWorkResponse'
    },
    {
      '1': 'CloseWork',
      '2': '.healthcare.facilities.v1.CloseWorkRequest',
      '3': '.healthcare.facilities.v1.CloseWorkResponse'
    },
    {
      '1': 'CancelWork',
      '2': '.healthcare.facilities.v1.CancelWorkRequest',
      '3': '.healthcare.facilities.v1.CancelWorkResponse'
    },
    {
      '1': 'GetWork',
      '2': '.healthcare.facilities.v1.GetWorkRequest',
      '3': '.healthcare.facilities.v1.GetWorkResponse'
    },
    {
      '1': 'ListWork',
      '2': '.healthcare.facilities.v1.ListWorkRequest',
      '3': '.healthcare.facilities.v1.ListWorkResponse'
    },
    {
      '1': 'GetWorklist',
      '2': '.healthcare.facilities.v1.GetWorklistRequest',
      '3': '.healthcare.facilities.v1.GetWorklistResponse'
    },
    {
      '1': 'AddSchedule',
      '2': '.healthcare.facilities.v1.AddScheduleRequest',
      '3': '.healthcare.facilities.v1.AddScheduleResponse'
    },
    {
      '1': 'ListSchedules',
      '2': '.healthcare.facilities.v1.ListSchedulesRequest',
      '3': '.healthcare.facilities.v1.ListSchedulesResponse'
    },
    {
      '1': 'PlanDue',
      '2': '.healthcare.facilities.v1.PlanDueRequest',
      '3': '.healthcare.facilities.v1.PlanDueResponse'
    },
    {
      '1': 'CompleteTask',
      '2': '.healthcare.facilities.v1.CompleteTaskRequest',
      '3': '.healthcare.facilities.v1.CompleteTaskResponse'
    },
    {
      '1': 'WaiveTask',
      '2': '.healthcare.facilities.v1.WaiveTaskRequest',
      '3': '.healthcare.facilities.v1.WaiveTaskResponse'
    },
    {
      '1': 'ListTasks',
      '2': '.healthcare.facilities.v1.ListTasksRequest',
      '3': '.healthcare.facilities.v1.ListTasksResponse'
    },
    {
      '1': 'GetMaintenanceReport',
      '2': '.healthcare.facilities.v1.GetMaintenanceReportRequest',
      '3': '.healthcare.facilities.v1.GetMaintenanceReportResponse'
    },
    {
      '1': 'RecordRuntime',
      '2': '.healthcare.facilities.v1.RecordRuntimeRequest',
      '3': '.healthcare.facilities.v1.RecordRuntimeResponse'
    },
    {
      '1': 'PlanOutage',
      '2': '.healthcare.facilities.v1.PlanOutageRequest',
      '3': '.healthcare.facilities.v1.PlanOutageResponse'
    },
    {
      '1': 'ApproveOutage',
      '2': '.healthcare.facilities.v1.ApproveOutageRequest',
      '3': '.healthcare.facilities.v1.ApproveOutageResponse'
    },
    {
      '1': 'AcknowledgeOutage',
      '2': '.healthcare.facilities.v1.AcknowledgeOutageRequest',
      '3': '.healthcare.facilities.v1.AcknowledgeOutageResponse'
    },
    {
      '1': 'StartOutage',
      '2': '.healthcare.facilities.v1.StartOutageRequest',
      '3': '.healthcare.facilities.v1.StartOutageResponse'
    },
    {
      '1': 'RestoreOutage',
      '2': '.healthcare.facilities.v1.RestoreOutageRequest',
      '3': '.healthcare.facilities.v1.RestoreOutageResponse'
    },
    {
      '1': 'CancelOutage',
      '2': '.healthcare.facilities.v1.CancelOutageRequest',
      '3': '.healthcare.facilities.v1.CancelOutageResponse'
    },
    {
      '1': 'GetOutage',
      '2': '.healthcare.facilities.v1.GetOutageRequest',
      '3': '.healthcare.facilities.v1.GetOutageResponse'
    },
    {
      '1': 'ListOutages',
      '2': '.healthcare.facilities.v1.ListOutagesRequest',
      '3': '.healthcare.facilities.v1.ListOutagesResponse'
    },
    {
      '1': 'IngestAlarm',
      '2': '.healthcare.facilities.v1.IngestAlarmRequest',
      '3': '.healthcare.facilities.v1.IngestAlarmResponse'
    },
    {
      '1': 'ClearAlarm',
      '2': '.healthcare.facilities.v1.ClearAlarmRequest',
      '3': '.healthcare.facilities.v1.ClearAlarmResponse'
    },
    {
      '1': 'AcknowledgeAlarm',
      '2': '.healthcare.facilities.v1.AcknowledgeAlarmRequest',
      '3': '.healthcare.facilities.v1.AcknowledgeAlarmResponse'
    },
    {
      '1': 'LinkAlarmWork',
      '2': '.healthcare.facilities.v1.LinkAlarmWorkRequest',
      '3': '.healthcare.facilities.v1.LinkAlarmWorkResponse'
    },
    {
      '1': 'SetAlarmRule',
      '2': '.healthcare.facilities.v1.SetAlarmRuleRequest',
      '3': '.healthcare.facilities.v1.SetAlarmRuleResponse'
    },
    {
      '1': 'ListAlarms',
      '2': '.healthcare.facilities.v1.ListAlarmsRequest',
      '3': '.healthcare.facilities.v1.ListAlarmsResponse'
    },
    {
      '1': 'RaiseDeficiency',
      '2': '.healthcare.facilities.v1.RaiseDeficiencyRequest',
      '3': '.healthcare.facilities.v1.RaiseDeficiencyResponse'
    },
    {
      '1': 'MitigateDeficiency',
      '2': '.healthcare.facilities.v1.MitigateDeficiencyRequest',
      '3': '.healthcare.facilities.v1.MitigateDeficiencyResponse'
    },
    {
      '1': 'CloseDeficiency',
      '2': '.healthcare.facilities.v1.CloseDeficiencyRequest',
      '3': '.healthcare.facilities.v1.CloseDeficiencyResponse'
    },
    {
      '1': 'ListDeficiencies',
      '2': '.healthcare.facilities.v1.ListDeficienciesRequest',
      '3': '.healthcare.facilities.v1.ListDeficienciesResponse'
    },
    {
      '1': 'ListOpenCritical',
      '2': '.healthcare.facilities.v1.ListOpenCriticalRequest',
      '3': '.healthcare.facilities.v1.ListOpenCriticalResponse'
    },
    {
      '1': 'ListBlocking',
      '2': '.healthcare.facilities.v1.ListBlockingRequest',
      '3': '.healthcare.facilities.v1.ListBlockingResponse'
    },
    {
      '1': 'GetSafetyReport',
      '2': '.healthcare.facilities.v1.GetSafetyReportRequest',
      '3': '.healthcare.facilities.v1.GetSafetyReportResponse'
    },
    {
      '1': 'AddMeter',
      '2': '.healthcare.facilities.v1.AddMeterRequest',
      '3': '.healthcare.facilities.v1.AddMeterResponse'
    },
    {
      '1': 'RecordMeterReading',
      '2': '.healthcare.facilities.v1.RecordMeterReadingRequest',
      '3': '.healthcare.facilities.v1.RecordMeterReadingResponse'
    },
    {
      '1': 'ListMeters',
      '2': '.healthcare.facilities.v1.ListMetersRequest',
      '3': '.healthcare.facilities.v1.ListMetersResponse'
    },
    {
      '1': 'GetConsumption',
      '2': '.healthcare.facilities.v1.GetConsumptionRequest',
      '3': '.healthcare.facilities.v1.GetConsumptionResponse'
    },
    {
      '1': 'GetDowntime',
      '2': '.healthcare.facilities.v1.GetDowntimeRequest',
      '3': '.healthcare.facilities.v1.GetDowntimeResponse'
    },
    {
      '1': 'GetPerformance',
      '2': '.healthcare.facilities.v1.GetPerformanceRequest',
      '3': '.healthcare.facilities.v1.GetPerformanceResponse'
    },
    {
      '1': 'SignInVendor',
      '2': '.healthcare.facilities.v1.SignInVendorRequest',
      '3': '.healthcare.facilities.v1.SignInVendorResponse'
    },
    {
      '1': 'SignOutVendor',
      '2': '.healthcare.facilities.v1.SignOutVendorRequest',
      '3': '.healthcare.facilities.v1.SignOutVendorResponse'
    },
    {
      '1': 'ListVendorVisits',
      '2': '.healthcare.facilities.v1.ListVendorVisitsRequest',
      '3': '.healthcare.facilities.v1.ListVendorVisitsResponse'
    },
  ],
};

@$core.Deprecated('Use facilitiesServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    FacilitiesServiceBase$messageJson = {
  '.healthcare.facilities.v1.RegisterAssetRequest': RegisterAssetRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.facilities.v1.RegisterAssetResponse': RegisterAssetResponse$json,
  '.healthcare.facilities.v1.Asset': Asset$json,
  '.healthcare.facilities.v1.SetAssetStatusRequest': SetAssetStatusRequest$json,
  '.healthcare.facilities.v1.SetAssetStatusResponse':
      SetAssetStatusResponse$json,
  '.healthcare.facilities.v1.GetAssetRequest': GetAssetRequest$json,
  '.healthcare.facilities.v1.GetAssetResponse': GetAssetResponse$json,
  '.healthcare.facilities.v1.ListAssetsRequest': ListAssetsRequest$json,
  '.healthcare.facilities.v1.ListAssetsResponse': ListAssetsResponse$json,
  '.healthcare.facilities.v1.GetAssetTreeRequest': GetAssetTreeRequest$json,
  '.healthcare.facilities.v1.GetAssetTreeResponse': GetAssetTreeResponse$json,
  '.healthcare.facilities.v1.ListDownAssetsRequest': ListDownAssetsRequest$json,
  '.healthcare.facilities.v1.ListDownAssetsResponse':
      ListDownAssetsResponse$json,
  '.healthcare.facilities.v1.SetWorkClassRequest': SetWorkClassRequest$json,
  '.healthcare.facilities.v1.SetWorkClassResponse': SetWorkClassResponse$json,
  '.healthcare.facilities.v1.WorkClass': WorkClass$json,
  '.healthcare.facilities.v1.ListWorkClassesRequest':
      ListWorkClassesRequest$json,
  '.healthcare.facilities.v1.ListWorkClassesResponse':
      ListWorkClassesResponse$json,
  '.healthcare.facilities.v1.RaiseWorkRequest': RaiseWorkRequest$json,
  '.healthcare.facilities.v1.RaiseWorkResponse': RaiseWorkResponse$json,
  '.healthcare.facilities.v1.WorkOrder': WorkOrder$json,
  '.healthcare.facilities.v1.AssignWorkRequest': AssignWorkRequest$json,
  '.healthcare.facilities.v1.AssignWorkResponse': AssignWorkResponse$json,
  '.healthcare.facilities.v1.StartWorkRequest': StartWorkRequest$json,
  '.healthcare.facilities.v1.StartWorkResponse': StartWorkResponse$json,
  '.healthcare.facilities.v1.HoldWorkRequest': HoldWorkRequest$json,
  '.healthcare.facilities.v1.HoldWorkResponse': HoldWorkResponse$json,
  '.healthcare.facilities.v1.ResolveWorkRequest': ResolveWorkRequest$json,
  '.healthcare.facilities.v1.ResolveWorkResponse': ResolveWorkResponse$json,
  '.healthcare.facilities.v1.CloseWorkRequest': CloseWorkRequest$json,
  '.healthcare.facilities.v1.CloseWorkResponse': CloseWorkResponse$json,
  '.healthcare.facilities.v1.CancelWorkRequest': CancelWorkRequest$json,
  '.healthcare.facilities.v1.CancelWorkResponse': CancelWorkResponse$json,
  '.healthcare.facilities.v1.GetWorkRequest': GetWorkRequest$json,
  '.healthcare.facilities.v1.GetWorkResponse': GetWorkResponse$json,
  '.healthcare.facilities.v1.Breach': Breach$json,
  '.healthcare.facilities.v1.ListWorkRequest': ListWorkRequest$json,
  '.healthcare.facilities.v1.ListWorkResponse': ListWorkResponse$json,
  '.healthcare.facilities.v1.GetWorklistRequest': GetWorklistRequest$json,
  '.healthcare.facilities.v1.GetWorklistResponse': GetWorklistResponse$json,
  '.healthcare.facilities.v1.AddScheduleRequest': AddScheduleRequest$json,
  '.healthcare.facilities.v1.AddScheduleResponse': AddScheduleResponse$json,
  '.healthcare.facilities.v1.Schedule': Schedule$json,
  '.healthcare.facilities.v1.ListSchedulesRequest': ListSchedulesRequest$json,
  '.healthcare.facilities.v1.ListSchedulesResponse': ListSchedulesResponse$json,
  '.healthcare.facilities.v1.PlanDueRequest': PlanDueRequest$json,
  '.healthcare.facilities.v1.PlanDueResponse': PlanDueResponse$json,
  '.healthcare.facilities.v1.Task': Task$json,
  '.healthcare.facilities.v1.CompleteTaskRequest': CompleteTaskRequest$json,
  '.healthcare.facilities.v1.CompleteTaskResponse': CompleteTaskResponse$json,
  '.healthcare.facilities.v1.WaiveTaskRequest': WaiveTaskRequest$json,
  '.healthcare.facilities.v1.WaiveTaskResponse': WaiveTaskResponse$json,
  '.healthcare.facilities.v1.ListTasksRequest': ListTasksRequest$json,
  '.healthcare.facilities.v1.ListTasksResponse': ListTasksResponse$json,
  '.healthcare.facilities.v1.GetMaintenanceReportRequest':
      GetMaintenanceReportRequest$json,
  '.healthcare.facilities.v1.GetMaintenanceReportResponse':
      GetMaintenanceReportResponse$json,
  '.healthcare.facilities.v1.MaintenanceReport': MaintenanceReport$json,
  '.healthcare.facilities.v1.RecordRuntimeRequest': RecordRuntimeRequest$json,
  '.healthcare.facilities.v1.RecordRuntimeResponse': RecordRuntimeResponse$json,
  '.healthcare.facilities.v1.RuntimeReading': RuntimeReading$json,
  '.healthcare.facilities.v1.PlanOutageRequest': PlanOutageRequest$json,
  '.healthcare.facilities.v1.AreaInput': AreaInput$json,
  '.healthcare.facilities.v1.PlanOutageResponse': PlanOutageResponse$json,
  '.healthcare.facilities.v1.Outage': Outage$json,
  '.healthcare.facilities.v1.OutageArea': OutageArea$json,
  '.healthcare.facilities.v1.ApproveOutageRequest': ApproveOutageRequest$json,
  '.healthcare.facilities.v1.ApproveOutageResponse': ApproveOutageResponse$json,
  '.healthcare.facilities.v1.AcknowledgeOutageRequest':
      AcknowledgeOutageRequest$json,
  '.healthcare.facilities.v1.AcknowledgeOutageResponse':
      AcknowledgeOutageResponse$json,
  '.healthcare.facilities.v1.StartOutageRequest': StartOutageRequest$json,
  '.healthcare.facilities.v1.StartOutageResponse': StartOutageResponse$json,
  '.healthcare.facilities.v1.RestoreOutageRequest': RestoreOutageRequest$json,
  '.healthcare.facilities.v1.RestoreOutageResponse': RestoreOutageResponse$json,
  '.healthcare.facilities.v1.CancelOutageRequest': CancelOutageRequest$json,
  '.healthcare.facilities.v1.CancelOutageResponse': CancelOutageResponse$json,
  '.healthcare.facilities.v1.GetOutageRequest': GetOutageRequest$json,
  '.healthcare.facilities.v1.GetOutageResponse': GetOutageResponse$json,
  '.healthcare.facilities.v1.ListOutagesRequest': ListOutagesRequest$json,
  '.healthcare.facilities.v1.ListOutagesResponse': ListOutagesResponse$json,
  '.healthcare.facilities.v1.IngestAlarmRequest': IngestAlarmRequest$json,
  '.healthcare.facilities.v1.IngestAlarmResponse': IngestAlarmResponse$json,
  '.healthcare.facilities.v1.Alarm': Alarm$json,
  '.healthcare.facilities.v1.ClearAlarmRequest': ClearAlarmRequest$json,
  '.healthcare.facilities.v1.ClearAlarmResponse': ClearAlarmResponse$json,
  '.healthcare.facilities.v1.AcknowledgeAlarmRequest':
      AcknowledgeAlarmRequest$json,
  '.healthcare.facilities.v1.AcknowledgeAlarmResponse':
      AcknowledgeAlarmResponse$json,
  '.healthcare.facilities.v1.LinkAlarmWorkRequest': LinkAlarmWorkRequest$json,
  '.healthcare.facilities.v1.LinkAlarmWorkResponse': LinkAlarmWorkResponse$json,
  '.healthcare.facilities.v1.SetAlarmRuleRequest': SetAlarmRuleRequest$json,
  '.healthcare.facilities.v1.SetAlarmRuleResponse': SetAlarmRuleResponse$json,
  '.healthcare.facilities.v1.AlarmRule': AlarmRule$json,
  '.healthcare.facilities.v1.ListAlarmsRequest': ListAlarmsRequest$json,
  '.healthcare.facilities.v1.ListAlarmsResponse': ListAlarmsResponse$json,
  '.healthcare.facilities.v1.RaiseDeficiencyRequest':
      RaiseDeficiencyRequest$json,
  '.healthcare.facilities.v1.RaiseDeficiencyResponse':
      RaiseDeficiencyResponse$json,
  '.healthcare.facilities.v1.Deficiency': Deficiency$json,
  '.healthcare.facilities.v1.MitigateDeficiencyRequest':
      MitigateDeficiencyRequest$json,
  '.healthcare.facilities.v1.MitigateDeficiencyResponse':
      MitigateDeficiencyResponse$json,
  '.healthcare.facilities.v1.CloseDeficiencyRequest':
      CloseDeficiencyRequest$json,
  '.healthcare.facilities.v1.CloseDeficiencyResponse':
      CloseDeficiencyResponse$json,
  '.healthcare.facilities.v1.ListDeficienciesRequest':
      ListDeficienciesRequest$json,
  '.healthcare.facilities.v1.ListDeficienciesResponse':
      ListDeficienciesResponse$json,
  '.healthcare.facilities.v1.ListOpenCriticalRequest':
      ListOpenCriticalRequest$json,
  '.healthcare.facilities.v1.ListOpenCriticalResponse':
      ListOpenCriticalResponse$json,
  '.healthcare.facilities.v1.ListBlockingRequest': ListBlockingRequest$json,
  '.healthcare.facilities.v1.ListBlockingResponse': ListBlockingResponse$json,
  '.healthcare.facilities.v1.GetSafetyReportRequest':
      GetSafetyReportRequest$json,
  '.healthcare.facilities.v1.GetSafetyReportResponse':
      GetSafetyReportResponse$json,
  '.healthcare.facilities.v1.SafetyReport': SafetyReport$json,
  '.healthcare.facilities.v1.AddMeterRequest': AddMeterRequest$json,
  '.healthcare.facilities.v1.AddMeterResponse': AddMeterResponse$json,
  '.healthcare.facilities.v1.Meter': Meter$json,
  '.healthcare.facilities.v1.RecordMeterReadingRequest':
      RecordMeterReadingRequest$json,
  '.healthcare.facilities.v1.RecordMeterReadingResponse':
      RecordMeterReadingResponse$json,
  '.healthcare.facilities.v1.Reading': Reading$json,
  '.healthcare.facilities.v1.ListMetersRequest': ListMetersRequest$json,
  '.healthcare.facilities.v1.ListMetersResponse': ListMetersResponse$json,
  '.healthcare.facilities.v1.GetConsumptionRequest': GetConsumptionRequest$json,
  '.healthcare.facilities.v1.GetConsumptionResponse':
      GetConsumptionResponse$json,
  '.healthcare.facilities.v1.Consumption': Consumption$json,
  '.healthcare.facilities.v1.GetDowntimeRequest': GetDowntimeRequest$json,
  '.healthcare.facilities.v1.GetDowntimeResponse': GetDowntimeResponse$json,
  '.healthcare.facilities.v1.Downtime': Downtime$json,
  '.healthcare.facilities.v1.GetPerformanceRequest': GetPerformanceRequest$json,
  '.healthcare.facilities.v1.GetPerformanceResponse':
      GetPerformanceResponse$json,
  '.healthcare.facilities.v1.SLAPerformance': SLAPerformance$json,
  '.healthcare.facilities.v1.SignInVendorRequest': SignInVendorRequest$json,
  '.healthcare.facilities.v1.SignInVendorResponse': SignInVendorResponse$json,
  '.healthcare.facilities.v1.Visit': Visit$json,
  '.healthcare.facilities.v1.SignOutVendorRequest': SignOutVendorRequest$json,
  '.healthcare.facilities.v1.SignOutVendorResponse': SignOutVendorResponse$json,
  '.healthcare.facilities.v1.ListVendorVisitsRequest':
      ListVendorVisitsRequest$json,
  '.healthcare.facilities.v1.ListVendorVisitsResponse':
      ListVendorVisitsResponse$json,
};

/// Descriptor for `FacilitiesService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List facilitiesServiceDescriptor = $convert.base64Decode(
    'ChFGYWNpbGl0aWVzU2VydmljZRJwCg1SZWdpc3RlckFzc2V0Ei4uaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLlJlZ2lzdGVyQXNzZXRSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYx'
    'LlJlZ2lzdGVyQXNzZXRSZXNwb25zZRJzCg5TZXRBc3NldFN0YXR1cxIvLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5TZXRBc3NldFN0YXR1c1JlcXVlc3QaMC5oZWFsdGhjYXJlLmZhY2lsaXRp'
    'ZXMudjEuU2V0QXNzZXRTdGF0dXNSZXNwb25zZRJhCghHZXRBc3NldBIpLmhlYWx0aGNhcmUuZm'
    'FjaWxpdGllcy52MS5HZXRBc3NldFJlcXVlc3QaKi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEu'
    'R2V0QXNzZXRSZXNwb25zZRJnCgpMaXN0QXNzZXRzEisuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLn'
    'YxLkxpc3RBc3NldHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkxpc3RBc3Nl'
    'dHNSZXNwb25zZRJtCgxHZXRBc3NldFRyZWUSLS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2'
    'V0QXNzZXRUcmVlUmVxdWVzdBouLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5HZXRBc3NldFRy'
    'ZWVSZXNwb25zZRJzCg5MaXN0RG93bkFzc2V0cxIvLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS'
    '5MaXN0RG93bkFzc2V0c1JlcXVlc3QaMC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTGlzdERv'
    'd25Bc3NldHNSZXNwb25zZRJtCgxTZXRXb3JrQ2xhc3MSLS5oZWFsdGhjYXJlLmZhY2lsaXRpZX'
    'MudjEuU2V0V29ya0NsYXNzUmVxdWVzdBouLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TZXRX'
    'b3JrQ2xhc3NSZXNwb25zZRJ2Cg9MaXN0V29ya0NsYXNzZXMSMC5oZWFsdGhjYXJlLmZhY2lsaX'
    'RpZXMudjEuTGlzdFdvcmtDbGFzc2VzUmVxdWVzdBoxLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52'
    'MS5MaXN0V29ya0NsYXNzZXNSZXNwb25zZRJkCglSYWlzZVdvcmsSKi5oZWFsdGhjYXJlLmZhY2'
    'lsaXRpZXMudjEuUmFpc2VXb3JrUmVxdWVzdBorLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5S'
    'YWlzZVdvcmtSZXNwb25zZRJnCgpBc3NpZ25Xb3JrEisuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLn'
    'YxLkFzc2lnbldvcmtSZXF1ZXN0GiwuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFzc2lnbldv'
    'cmtSZXNwb25zZRJkCglTdGFydFdvcmsSKi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3Rhcn'
    'RXb3JrUmVxdWVzdBorLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TdGFydFdvcmtSZXNwb25z'
    'ZRJhCghIb2xkV29yaxIpLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5Ib2xkV29ya1JlcXVlc3'
    'QaKi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuSG9sZFdvcmtSZXNwb25zZRJqCgtSZXNvbHZl'
    'V29yaxIsLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5SZXNvbHZlV29ya1JlcXVlc3QaLS5oZW'
    'FsdGhjYXJlLmZhY2lsaXRpZXMudjEuUmVzb2x2ZVdvcmtSZXNwb25zZRJkCglDbG9zZVdvcmsS'
    'Ki5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQ2xvc2VXb3JrUmVxdWVzdBorLmhlYWx0aGNhcm'
    'UuZmFjaWxpdGllcy52MS5DbG9zZVdvcmtSZXNwb25zZRJnCgpDYW5jZWxXb3JrEisuaGVhbHRo'
    'Y2FyZS5mYWNpbGl0aWVzLnYxLkNhbmNlbFdvcmtSZXF1ZXN0GiwuaGVhbHRoY2FyZS5mYWNpbG'
    'l0aWVzLnYxLkNhbmNlbFdvcmtSZXNwb25zZRJeCgdHZXRXb3JrEiguaGVhbHRoY2FyZS5mYWNp'
    'bGl0aWVzLnYxLkdldFdvcmtSZXF1ZXN0GikuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldF'
    'dvcmtSZXNwb25zZRJhCghMaXN0V29yaxIpLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0'
    'V29ya1JlcXVlc3QaKi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTGlzdFdvcmtSZXNwb25zZR'
    'JqCgtHZXRXb3JrbGlzdBIsLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5HZXRXb3JrbGlzdFJl'
    'cXVlc3QaLS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2V0V29ya2xpc3RSZXNwb25zZRJqCg'
    'tBZGRTY2hlZHVsZRIsLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5BZGRTY2hlZHVsZVJlcXVl'
    'c3QaLS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQWRkU2NoZWR1bGVSZXNwb25zZRJwCg1MaX'
    'N0U2NoZWR1bGVzEi4uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkxpc3RTY2hlZHVsZXNSZXF1'
    'ZXN0Gi8uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkxpc3RTY2hlZHVsZXNSZXNwb25zZRJeCg'
    'dQbGFuRHVlEiguaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlBsYW5EdWVSZXF1ZXN0GikuaGVh'
    'bHRoY2FyZS5mYWNpbGl0aWVzLnYxLlBsYW5EdWVSZXNwb25zZRJtCgxDb21wbGV0ZVRhc2sSLS'
    '5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQ29tcGxldGVUYXNrUmVxdWVzdBouLmhlYWx0aGNh'
    'cmUuZmFjaWxpdGllcy52MS5Db21wbGV0ZVRhc2tSZXNwb25zZRJkCglXYWl2ZVRhc2sSKi5oZW'
    'FsdGhjYXJlLmZhY2lsaXRpZXMudjEuV2FpdmVUYXNrUmVxdWVzdBorLmhlYWx0aGNhcmUuZmFj'
    'aWxpdGllcy52MS5XYWl2ZVRhc2tSZXNwb25zZRJkCglMaXN0VGFza3MSKi5oZWFsdGhjYXJlLm'
    'ZhY2lsaXRpZXMudjEuTGlzdFRhc2tzUmVxdWVzdBorLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52'
    'MS5MaXN0VGFza3NSZXNwb25zZRKFAQoUR2V0TWFpbnRlbmFuY2VSZXBvcnQSNS5oZWFsdGhjYX'
    'JlLmZhY2lsaXRpZXMudjEuR2V0TWFpbnRlbmFuY2VSZXBvcnRSZXF1ZXN0GjYuaGVhbHRoY2Fy'
    'ZS5mYWNpbGl0aWVzLnYxLkdldE1haW50ZW5hbmNlUmVwb3J0UmVzcG9uc2UScAoNUmVjb3JkUn'
    'VudGltZRIuLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5SZWNvcmRSdW50aW1lUmVxdWVzdBov'
    'LmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5SZWNvcmRSdW50aW1lUmVzcG9uc2USZwoKUGxhbk'
    '91dGFnZRIrLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5QbGFuT3V0YWdlUmVxdWVzdBosLmhl'
    'YWx0aGNhcmUuZmFjaWxpdGllcy52MS5QbGFuT3V0YWdlUmVzcG9uc2UScAoNQXBwcm92ZU91dG'
    'FnZRIuLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5BcHByb3ZlT3V0YWdlUmVxdWVzdBovLmhl'
    'YWx0aGNhcmUuZmFjaWxpdGllcy52MS5BcHByb3ZlT3V0YWdlUmVzcG9uc2USfAoRQWNrbm93bG'
    'VkZ2VPdXRhZ2USMi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQWNrbm93bGVkZ2VPdXRhZ2VS'
    'ZXF1ZXN0GjMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFja25vd2xlZGdlT3V0YWdlUmVzcG'
    '9uc2USagoLU3RhcnRPdXRhZ2USLC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU3RhcnRPdXRh'
    'Z2VSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlN0YXJ0T3V0YWdlUmVzcG9uc2'
    'UScAoNUmVzdG9yZU91dGFnZRIuLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5SZXN0b3JlT3V0'
    'YWdlUmVxdWVzdBovLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5SZXN0b3JlT3V0YWdlUmVzcG'
    '9uc2USbQoMQ2FuY2VsT3V0YWdlEi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkNhbmNlbE91'
    'dGFnZVJlcXVlc3QaLi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQ2FuY2VsT3V0YWdlUmVzcG'
    '9uc2USZAoJR2V0T3V0YWdlEiouaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldE91dGFnZVJl'
    'cXVlc3QaKy5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2V0T3V0YWdlUmVzcG9uc2USagoLTG'
    'lzdE91dGFnZXMSLC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTGlzdE91dGFnZXNSZXF1ZXN0'
    'Gi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkxpc3RPdXRhZ2VzUmVzcG9uc2USagoLSW5nZX'
    'N0QWxhcm0SLC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuSW5nZXN0QWxhcm1SZXF1ZXN0Gi0u'
    'aGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkluZ2VzdEFsYXJtUmVzcG9uc2USZwoKQ2xlYXJBbG'
    'FybRIrLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5DbGVhckFsYXJtUmVxdWVzdBosLmhlYWx0'
    'aGNhcmUuZmFjaWxpdGllcy52MS5DbGVhckFsYXJtUmVzcG9uc2USeQoQQWNrbm93bGVkZ2VBbG'
    'FybRIxLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5BY2tub3dsZWRnZUFsYXJtUmVxdWVzdBoy'
    'LmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5BY2tub3dsZWRnZUFsYXJtUmVzcG9uc2UScAoNTG'
    'lua0FsYXJtV29yaxIuLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaW5rQWxhcm1Xb3JrUmVx'
    'dWVzdBovLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaW5rQWxhcm1Xb3JrUmVzcG9uc2USbQ'
    'oMU2V0QWxhcm1SdWxlEi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlNldEFsYXJtUnVsZVJl'
    'cXVlc3QaLi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU2V0QWxhcm1SdWxlUmVzcG9uc2USZw'
    'oKTGlzdEFsYXJtcxIrLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0QWxhcm1zUmVxdWVz'
    'dBosLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0QWxhcm1zUmVzcG9uc2USdgoPUmFpc2'
    'VEZWZpY2llbmN5EjAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlJhaXNlRGVmaWNpZW5jeVJl'
    'cXVlc3QaMS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuUmFpc2VEZWZpY2llbmN5UmVzcG9uc2'
    'USfwoSTWl0aWdhdGVEZWZpY2llbmN5EjMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLk1pdGln'
    'YXRlRGVmaWNpZW5jeVJlcXVlc3QaNC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTWl0aWdhdG'
    'VEZWZpY2llbmN5UmVzcG9uc2USdgoPQ2xvc2VEZWZpY2llbmN5EjAuaGVhbHRoY2FyZS5mYWNp'
    'bGl0aWVzLnYxLkNsb3NlRGVmaWNpZW5jeVJlcXVlc3QaMS5oZWFsdGhjYXJlLmZhY2lsaXRpZX'
    'MudjEuQ2xvc2VEZWZpY2llbmN5UmVzcG9uc2USeQoQTGlzdERlZmljaWVuY2llcxIxLmhlYWx0'
    'aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0RGVmaWNpZW5jaWVzUmVxdWVzdBoyLmhlYWx0aGNhcm'
    'UuZmFjaWxpdGllcy52MS5MaXN0RGVmaWNpZW5jaWVzUmVzcG9uc2USeQoQTGlzdE9wZW5Dcml0'
    'aWNhbBIxLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0T3BlbkNyaXRpY2FsUmVxdWVzdB'
    'oyLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0T3BlbkNyaXRpY2FsUmVzcG9uc2USbQoM'
    'TGlzdEJsb2NraW5nEi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkxpc3RCbG9ja2luZ1JlcX'
    'Vlc3QaLi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuTGlzdEJsb2NraW5nUmVzcG9uc2USdgoP'
    'R2V0U2FmZXR5UmVwb3J0EjAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldFNhZmV0eVJlcG'
    '9ydFJlcXVlc3QaMS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2V0U2FmZXR5UmVwb3J0UmVz'
    'cG9uc2USYQoIQWRkTWV0ZXISKS5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuQWRkTWV0ZXJSZX'
    'F1ZXN0GiouaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkFkZE1ldGVyUmVzcG9uc2USfwoSUmVj'
    'b3JkTWV0ZXJSZWFkaW5nEjMuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLlJlY29yZE1ldGVyUm'
    'VhZGluZ1JlcXVlc3QaNC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuUmVjb3JkTWV0ZXJSZWFk'
    'aW5nUmVzcG9uc2USZwoKTGlzdE1ldGVycxIrLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaX'
    'N0TWV0ZXJzUmVxdWVzdBosLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5MaXN0TWV0ZXJzUmVz'
    'cG9uc2UScwoOR2V0Q29uc3VtcHRpb24SLy5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2V0Q2'
    '9uc3VtcHRpb25SZXF1ZXN0GjAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldENvbnN1bXB0'
    'aW9uUmVzcG9uc2USagoLR2V0RG93bnRpbWUSLC5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2'
    'V0RG93bnRpbWVSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldERvd250aW1l'
    'UmVzcG9uc2UScwoOR2V0UGVyZm9ybWFuY2USLy5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuR2'
    'V0UGVyZm9ybWFuY2VSZXF1ZXN0GjAuaGVhbHRoY2FyZS5mYWNpbGl0aWVzLnYxLkdldFBlcmZv'
    'cm1hbmNlUmVzcG9uc2USbQoMU2lnbkluVmVuZG9yEi0uaGVhbHRoY2FyZS5mYWNpbGl0aWVzLn'
    'YxLlNpZ25JblZlbmRvclJlcXVlc3QaLi5oZWFsdGhjYXJlLmZhY2lsaXRpZXMudjEuU2lnbklu'
    'VmVuZG9yUmVzcG9uc2UScAoNU2lnbk91dFZlbmRvchIuLmhlYWx0aGNhcmUuZmFjaWxpdGllcy'
    '52MS5TaWduT3V0VmVuZG9yUmVxdWVzdBovLmhlYWx0aGNhcmUuZmFjaWxpdGllcy52MS5TaWdu'
    'T3V0VmVuZG9yUmVzcG9uc2USeQoQTGlzdFZlbmRvclZpc2l0cxIxLmhlYWx0aGNhcmUuZmFjaW'
    'xpdGllcy52MS5MaXN0VmVuZG9yVmlzaXRzUmVxdWVzdBoyLmhlYWx0aGNhcmUuZmFjaWxpdGll'
    'cy52MS5MaXN0VmVuZG9yVmlzaXRzUmVzcG9uc2U=');
