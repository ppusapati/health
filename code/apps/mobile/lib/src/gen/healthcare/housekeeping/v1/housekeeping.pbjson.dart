// This is a generated file - do not edit.
//
// Generated from healthcare/housekeeping/v1/housekeeping.proto.

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

@$core.Deprecated('Use riskClassDescriptor instead')
const RiskClass$json = {
  '1': 'RiskClass',
  '2': [
    {'1': 'RISK_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'RISK_CLASS_VERY_HIGH', '2': 1},
    {'1': 'RISK_CLASS_HIGH', '2': 2},
    {'1': 'RISK_CLASS_MODERATE', '2': 3},
    {'1': 'RISK_CLASS_LOW', '2': 4},
  ],
};

/// Descriptor for `RiskClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List riskClassDescriptor = $convert.base64Decode(
    'CglSaXNrQ2xhc3MSGgoWUklTS19DTEFTU19VTlNQRUNJRklFRBAAEhgKFFJJU0tfQ0xBU1NfVk'
    'VSWV9ISUdIEAESEwoPUklTS19DTEFTU19ISUdIEAISFwoTUklTS19DTEFTU19NT0RFUkFURRAD'
    'EhIKDlJJU0tfQ0xBU1NfTE9XEAQ=');

@$core.Deprecated('Use taskKindDescriptor instead')
const TaskKind$json = {
  '1': 'TaskKind',
  '2': [
    {'1': 'TASK_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TASK_KIND_ROUTINE', '2': 1},
    {'1': 'TASK_KIND_TERMINAL', '2': 2},
    {'1': 'TASK_KIND_SPILL', '2': 3},
    {'1': 'TASK_KIND_DEEP', '2': 4},
  ],
};

/// Descriptor for `TaskKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskKindDescriptor = $convert.base64Decode(
    'CghUYXNrS2luZBIZChVUQVNLX0tJTkRfVU5TUEVDSUZJRUQQABIVChFUQVNLX0tJTkRfUk9VVE'
    'lORRABEhYKElRBU0tfS0lORF9URVJNSU5BTBACEhMKD1RBU0tfS0lORF9TUElMTBADEhIKDlRB'
    'U0tfS0lORF9ERUVQEAQ=');

@$core.Deprecated('Use taskStateDescriptor instead')
const TaskState$json = {
  '1': 'TaskState',
  '2': [
    {'1': 'TASK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATE_OPEN', '2': 1},
    {'1': 'TASK_STATE_IN_PROGRESS', '2': 2},
    {'1': 'TASK_STATE_COMPLETED', '2': 3},
    {'1': 'TASK_STATE_VERIFIED', '2': 4},
    {'1': 'TASK_STATE_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `TaskState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStateDescriptor = $convert.base64Decode(
    'CglUYXNrU3RhdGUSGgoWVEFTS19TVEFURV9VTlNQRUNJRklFRBAAEhMKD1RBU0tfU1RBVEVfT1'
    'BFThABEhoKFlRBU0tfU1RBVEVfSU5fUFJPR1JFU1MQAhIYChRUQVNLX1NUQVRFX0NPTVBMRVRF'
    'RBADEhcKE1RBU0tfU1RBVEVfVkVSSUZJRUQQBBIYChRUQVNLX1NUQVRFX0NBTkNFTExFRBAF');

@$core.Deprecated('Use holdStateDescriptor instead')
const HoldState$json = {
  '1': 'HoldState',
  '2': [
    {'1': 'HOLD_STATE_UNSPECIFIED', '2': 0},
    {'1': 'HOLD_STATE_OPEN', '2': 1},
    {'1': 'HOLD_STATE_RELEASED', '2': 2},
    {'1': 'HOLD_STATE_OVERRIDDEN', '2': 3},
  ],
};

/// Descriptor for `HoldState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List holdStateDescriptor = $convert.base64Decode(
    'CglIb2xkU3RhdGUSGgoWSE9MRF9TVEFURV9VTlNQRUNJRklFRBAAEhMKD0hPTERfU1RBVEVfT1'
    'BFThABEhcKE0hPTERfU1RBVEVfUkVMRUFTRUQQAhIZChVIT0xEX1NUQVRFX09WRVJSSURERU4Q'
    'Aw==');

@$core.Deprecated('Use checklistItemDescriptor instead')
const ChecklistItem$json = {
  '1': 'ChecklistItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'required', '3': 3, '4': 1, '5': 8, '10': 'required'},
  ],
};

/// Descriptor for `ChecklistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checklistItemDescriptor = $convert.base64Decode(
    'Cg1DaGVja2xpc3RJdGVtEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBWxhYm'
    'VsEhoKCHJlcXVpcmVkGAMgASgIUghyZXF1aXJlZA==');

@$core.Deprecated('Use checklistAnswerDescriptor instead')
const ChecklistAnswer$json = {
  '1': 'ChecklistAnswer',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'done', '3': 2, '4': 1, '5': 8, '10': 'done'},
    {'1': 'exception', '3': 3, '4': 1, '5': 9, '10': 'exception'},
  ],
};

/// Descriptor for `ChecklistAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checklistAnswerDescriptor = $convert.base64Decode(
    'Cg9DaGVja2xpc3RBbnN3ZXISEgoEY29kZRgBIAEoCVIEY29kZRISCgRkb25lGAIgASgIUgRkb2'
    '5lEhwKCWV4Y2VwdGlvbhgDIAEoCVIJZXhjZXB0aW9u');

@$core.Deprecated('Use cleanableLocationDescriptor instead')
const CleanableLocation$json = {
  '1': 'CleanableLocation',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 6, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'bed_id', '3': 7, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'risk_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.RiskClass',
      '10': 'riskClass'
    },
    {
      '1': 'routine_every_hours',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'routineEveryHours'
    },
    {
      '1': 'routine_sla_minutes',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'routineSlaMinutes'
    },
    {
      '1': 'terminal_sla_minutes',
      '3': 11,
      '4': 1,
      '5': 5,
      '10': 'terminalSlaMinutes'
    },
    {
      '1': 'checklist',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.ChecklistItem',
      '10': 'checklist'
    },
    {'1': 'scan_code', '3': 13, '4': 1, '5': 9, '10': 'scanCode'},
    {'1': 'approved', '3': 14, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 15, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
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

/// Descriptor for `CleanableLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cleanableLocationDescriptor = $convert.base64Decode(
    'ChFDbGVhbmFibGVMb2NhdGlvbhIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG9jYXRpb25JZBISCg'
    'Rjb2RlGAIgASgJUgRjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSGgoIcmV2aXNpb24YBCABKAVS'
    'CHJldmlzaW9uEh8KC2ZhY2lsaXR5X2lkGAUgASgJUgpmYWNpbGl0eUlkEhIKBHpvbmUYBiABKA'
    'lSBHpvbmUSFQoGYmVkX2lkGAcgASgJUgViZWRJZBJECgpyaXNrX2NsYXNzGAggASgOMiUuaGVh'
    'bHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuUmlza0NsYXNzUglyaXNrQ2xhc3MSLgoTcm91dGluZV'
    '9ldmVyeV9ob3VycxgJIAEoBVIRcm91dGluZUV2ZXJ5SG91cnMSLgoTcm91dGluZV9zbGFfbWlu'
    'dXRlcxgKIAEoBVIRcm91dGluZVNsYU1pbnV0ZXMSMAoUdGVybWluYWxfc2xhX21pbnV0ZXMYCy'
    'ABKAVSEnRlcm1pbmFsU2xhTWludXRlcxJHCgljaGVja2xpc3QYDCADKAsyKS5oZWFsdGhjYXJl'
    'LmhvdXNla2VlcGluZy52MS5DaGVja2xpc3RJdGVtUgljaGVja2xpc3QSGwoJc2Nhbl9jb2RlGA'
    '0gASgJUghzY2FuQ29kZRIaCghhcHByb3ZlZBgOIAEoCFIIYXBwcm92ZWQSHwoLYXBwcm92ZWRf'
    'YnkYDyABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYXQYECABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0EkEKDmVmZmVjdGl2ZV9mcm9tGBEgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbRI/Cg1zdXBlcnNlZGVkX2F0GB'
    'IgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMc3VwZXJzZWRlZEF0EjkKCmNyZWF0'
    'ZWRfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3'
    'JlYXRlZF9ieRgUIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNpb24YFSABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use locationScanDescriptor instead')
const LocationScan$json = {
  '1': 'LocationScan',
  '2': [
    {'1': 'scanned_code', '3': 1, '4': 1, '5': 9, '10': 'scannedCode'},
    {'1': 'matched', '3': 2, '4': 1, '5': 8, '10': 'matched'},
    {'1': 'scanned_by', '3': 3, '4': 1, '5': 9, '10': 'scannedBy'},
    {
      '1': 'scanned_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scannedAt'
    },
  ],
};

/// Descriptor for `LocationScan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationScanDescriptor = $convert.base64Decode(
    'CgxMb2NhdGlvblNjYW4SIQoMc2Nhbm5lZF9jb2RlGAEgASgJUgtzY2FubmVkQ29kZRIYCgdtYX'
    'RjaGVkGAIgASgIUgdtYXRjaGVkEh0KCnNjYW5uZWRfYnkYAyABKAlSCXNjYW5uZWRCeRI5Cgpz'
    'Y2FubmVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc2Nhbm5lZEF0');

@$core.Deprecated('Use cleaningTaskDescriptor instead')
const CleaningTask$json = {
  '1': 'CleaningTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.TaskKind',
      '10': 'kind'
    },
    {'1': 'location_code', '3': 3, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'location_name', '3': 4, '4': 1, '5': 9, '10': 'locationName'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 6, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'bed_id', '3': 7, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'risk_class',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.RiskClass',
      '10': 'riskClass'
    },
    {
      '1': 'location_revision',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'locationRevision'
    },
    {
      '1': 'checklist',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.ChecklistItem',
      '10': 'checklist'
    },
    {'1': 'scan_code', '3': 11, '4': 1, '5': 9, '10': 'scanCode'},
    {'1': 'restricted', '3': 12, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'incident_ref', '3': 13, '4': 1, '5': 9, '10': 'incidentRef'},
    {'1': 'detail', '3': 14, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'assignee_id', '3': 15, '4': 1, '5': 9, '10': 'assigneeId'},
    {
      '1': 'due_by',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'state',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.TaskState',
      '10': 'state'
    },
    {
      '1': 'answers',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.ChecklistAnswer',
      '10': 'answers'
    },
    {
      '1': 'scans',
      '3': 19,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.LocationScan',
      '10': 'scans'
    },
    {
      '1': 'started_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 21, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'completed_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'completed_by', '3': 23, '4': 1, '5': 9, '10': 'completedBy'},
    {
      '1': 'verified_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'verifiedAt'
    },
    {'1': 'verified_by', '3': 25, '4': 1, '5': 9, '10': 'verifiedBy'},
    {'1': 'verify_note', '3': 26, '4': 1, '5': 9, '10': 'verifyNote'},
    {'1': 'cancel_reason', '3': 27, '4': 1, '5': 9, '10': 'cancelReason'},
    {
      '1': 'escalated_at',
      '3': 28,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'escalatedAt'
    },
    {
      '1': 'raised_at',
      '3': 29,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 30, '4': 1, '5': 9, '10': 'raisedBy'},
    {'1': 'version', '3': 31, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CleaningTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cleaningTaskDescriptor = $convert.base64Decode(
    'CgxDbGVhbmluZ1Rhc2sSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEjgKBGtpbmQYAiABKA4yJC'
    '5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5UYXNrS2luZFIEa2luZBIjCg1sb2NhdGlvbl9j'
    'b2RlGAMgASgJUgxsb2NhdGlvbkNvZGUSIwoNbG9jYXRpb25fbmFtZRgEIAEoCVIMbG9jYXRpb2'
    '5OYW1lEh8KC2ZhY2lsaXR5X2lkGAUgASgJUgpmYWNpbGl0eUlkEhIKBHpvbmUYBiABKAlSBHpv'
    'bmUSFQoGYmVkX2lkGAcgASgJUgViZWRJZBJECgpyaXNrX2NsYXNzGAggASgOMiUuaGVhbHRoY2'
    'FyZS5ob3VzZWtlZXBpbmcudjEuUmlza0NsYXNzUglyaXNrQ2xhc3MSKwoRbG9jYXRpb25fcmV2'
    'aXNpb24YCSABKAVSEGxvY2F0aW9uUmV2aXNpb24SRwoJY2hlY2tsaXN0GAogAygLMikuaGVhbH'
    'RoY2FyZS5ob3VzZWtlZXBpbmcudjEuQ2hlY2tsaXN0SXRlbVIJY2hlY2tsaXN0EhsKCXNjYW5f'
    'Y29kZRgLIAEoCVIIc2NhbkNvZGUSHgoKcmVzdHJpY3RlZBgMIAEoCFIKcmVzdHJpY3RlZBIhCg'
    'xpbmNpZGVudF9yZWYYDSABKAlSC2luY2lkZW50UmVmEhYKBmRldGFpbBgOIAEoCVIGZGV0YWls'
    'Eh8KC2Fzc2lnbmVlX2lkGA8gASgJUgphc3NpZ25lZUlkEjEKBmR1ZV9ieRgQIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5EjsKBXN0YXRlGBEgASgOMiUuaGVhbHRoY2Fy'
    'ZS5ob3VzZWtlZXBpbmcudjEuVGFza1N0YXRlUgVzdGF0ZRJFCgdhbnN3ZXJzGBIgAygLMisuaG'
    'VhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuQ2hlY2tsaXN0QW5zd2VyUgdhbnN3ZXJzEj4KBXNj'
    'YW5zGBMgAygLMiguaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuTG9jYXRpb25TY2FuUgVzY2'
    'FucxI5CgpzdGFydGVkX2F0GBQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3Rh'
    'cnRlZEF0Eh0KCnN0YXJ0ZWRfYnkYFSABKAlSCXN0YXJ0ZWRCeRI9Cgxjb21wbGV0ZWRfYXQYFi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtjb21wbGV0ZWRBdBIhCgxjb21wbGV0'
    'ZWRfYnkYFyABKAlSC2NvbXBsZXRlZEJ5EjsKC3ZlcmlmaWVkX2F0GBggASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIKdmVyaWZpZWRBdBIfCgt2ZXJpZmllZF9ieRgZIAEoCVIKdmVy'
    'aWZpZWRCeRIfCgt2ZXJpZnlfbm90ZRgaIAEoCVIKdmVyaWZ5Tm90ZRIjCg1jYW5jZWxfcmVhc2'
    '9uGBsgASgJUgxjYW5jZWxSZWFzb24SPQoMZXNjYWxhdGVkX2F0GBwgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILZXNjYWxhdGVkQXQSNwoJcmFpc2VkX2F0GB0gASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmFpc2VkQXQSGwoJcmFpc2VkX2J5GB4gASgJUghyYWlz'
    'ZWRCeRIYCgd2ZXJzaW9uGB8gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use bedHoldDescriptor instead')
const BedHold$json = {
  '1': 'BedHold',
  '2': [
    {'1': 'hold_id', '3': 1, '4': 1, '5': 9, '10': 'holdId'},
    {'1': 'bed_id', '3': 2, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'location_code', '3': 3, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 5, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'task_id', '3': 6, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'encounter_id', '3': 7, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.HoldState',
      '10': 'state'
    },
    {
      '1': 'placed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'placedAt'
    },
    {'1': 'placed_by', '3': 10, '4': 1, '5': 9, '10': 'placedBy'},
    {
      '1': 'released_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'releasedAt'
    },
    {'1': 'released_by', '3': 12, '4': 1, '5': 9, '10': 'releasedBy'},
    {
      '1': 'overridden_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'overriddenAt'
    },
    {'1': 'overridden_by', '3': 14, '4': 1, '5': 9, '10': 'overriddenBy'},
    {'1': 'override_reason', '3': 15, '4': 1, '5': 9, '10': 'overrideReason'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `BedHold`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedHoldDescriptor = $convert.base64Decode(
    'CgdCZWRIb2xkEhcKB2hvbGRfaWQYASABKAlSBmhvbGRJZBIVCgZiZWRfaWQYAiABKAlSBWJlZE'
    'lkEiMKDWxvY2F0aW9uX2NvZGUYAyABKAlSDGxvY2F0aW9uQ29kZRIfCgtmYWNpbGl0eV9pZBgE'
    'IAEoCVIKZmFjaWxpdHlJZBISCgR6b25lGAUgASgJUgR6b25lEhcKB3Rhc2tfaWQYBiABKAlSBn'
    'Rhc2tJZBIhCgxlbmNvdW50ZXJfaWQYByABKAlSC2VuY291bnRlcklkEjsKBXN0YXRlGAggASgO'
    'MiUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuSG9sZFN0YXRlUgVzdGF0ZRI3CglwbGFjZW'
    'RfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghwbGFjZWRBdBIbCglwbGFj'
    'ZWRfYnkYCiABKAlSCHBsYWNlZEJ5EjsKC3JlbGVhc2VkX2F0GAsgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIKcmVsZWFzZWRBdBIfCgtyZWxlYXNlZF9ieRgMIAEoCVIKcmVsZWFz'
    'ZWRCeRI/Cg1vdmVycmlkZGVuX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IMb3ZlcnJpZGRlbkF0EiMKDW92ZXJyaWRkZW5fYnkYDiABKAlSDG92ZXJyaWRkZW5CeRInCg9v'
    'dmVycmlkZV9yZWFzb24YDyABKAlSDm92ZXJyaWRlUmVhc29uEhgKB3ZlcnNpb24YECABKANSB3'
    'ZlcnNpb24=');

@$core.Deprecated('Use dueRoutineCleanDescriptor instead')
const DueRoutineClean$json = {
  '1': 'DueRoutineClean',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleanableLocation',
      '10': 'location'
    },
    {
      '1': 'last_cleaned_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastCleanedAt'
    },
    {
      '1': 'due_since',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueSince'
    },
    {'1': 'never_cleaned', '3': 4, '4': 1, '5': 8, '10': 'neverCleaned'},
  ],
};

/// Descriptor for `DueRoutineClean`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueRoutineCleanDescriptor = $convert.base64Decode(
    'Cg9EdWVSb3V0aW5lQ2xlYW4SSQoIbG9jYXRpb24YASABKAsyLS5oZWFsdGhjYXJlLmhvdXNla2'
    'VlcGluZy52MS5DbGVhbmFibGVMb2NhdGlvblIIbG9jYXRpb24SQgoPbGFzdF9jbGVhbmVkX2F0'
    'GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINbGFzdENsZWFuZWRBdBI3CglkdW'
    'Vfc2luY2UYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghkdWVTaW5jZRIjCg1u'
    'ZXZlcl9jbGVhbmVkGAQgASgIUgxuZXZlckNsZWFuZWQ=');

@$core.Deprecated('Use configureLocationRequestDescriptor instead')
const ConfigureLocationRequest$json = {
  '1': 'ConfigureLocationRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 4, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'bed_id', '3': 5, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'risk_class',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.RiskClass',
      '10': 'riskClass'
    },
    {
      '1': 'routine_every_hours',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'routineEveryHours'
    },
    {
      '1': 'routine_sla_minutes',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'routineSlaMinutes'
    },
    {
      '1': 'terminal_sla_minutes',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'terminalSlaMinutes'
    },
    {
      '1': 'checklist',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.ChecklistItem',
      '10': 'checklist'
    },
    {'1': 'scan_code', '3': 11, '4': 1, '5': 9, '10': 'scanCode'},
  ],
};

/// Descriptor for `ConfigureLocationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureLocationRequestDescriptor = $convert.base64Decode(
    'ChhDb25maWd1cmVMb2NhdGlvblJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGA'
    'IgASgJUgRuYW1lEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpmYWNpbGl0eUlkEhIKBHpvbmUYBCAB'
    'KAlSBHpvbmUSFQoGYmVkX2lkGAUgASgJUgViZWRJZBJECgpyaXNrX2NsYXNzGAYgASgOMiUuaG'
    'VhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuUmlza0NsYXNzUglyaXNrQ2xhc3MSLgoTcm91dGlu'
    'ZV9ldmVyeV9ob3VycxgHIAEoBVIRcm91dGluZUV2ZXJ5SG91cnMSLgoTcm91dGluZV9zbGFfbW'
    'ludXRlcxgIIAEoBVIRcm91dGluZVNsYU1pbnV0ZXMSMAoUdGVybWluYWxfc2xhX21pbnV0ZXMY'
    'CSABKAVSEnRlcm1pbmFsU2xhTWludXRlcxJHCgljaGVja2xpc3QYCiADKAsyKS5oZWFsdGhjYX'
    'JlLmhvdXNla2VlcGluZy52MS5DaGVja2xpc3RJdGVtUgljaGVja2xpc3QSGwoJc2Nhbl9jb2Rl'
    'GAsgASgJUghzY2FuQ29kZQ==');

@$core.Deprecated('Use configureLocationResponseDescriptor instead')
const ConfigureLocationResponse$json = {
  '1': 'ConfigureLocationResponse',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleanableLocation',
      '10': 'location'
    },
  ],
};

/// Descriptor for `ConfigureLocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureLocationResponseDescriptor =
    $convert.base64Decode(
        'ChlDb25maWd1cmVMb2NhdGlvblJlc3BvbnNlEkkKCGxvY2F0aW9uGAEgASgLMi0uaGVhbHRoY2'
        'FyZS5ob3VzZWtlZXBpbmcudjEuQ2xlYW5hYmxlTG9jYXRpb25SCGxvY2F0aW9u');

@$core.Deprecated('Use approveLocationRequestDescriptor instead')
const ApproveLocationRequest$json = {
  '1': 'ApproveLocationRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'effective_from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `ApproveLocationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLocationRequestDescriptor = $convert.base64Decode(
    'ChZBcHByb3ZlTG9jYXRpb25SZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdGlvbk'
    'lkEkEKDmVmZmVjdGl2ZV9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIN'
    'ZWZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use approveLocationResponseDescriptor instead')
const ApproveLocationResponse$json = {
  '1': 'ApproveLocationResponse',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleanableLocation',
      '10': 'location'
    },
  ],
};

/// Descriptor for `ApproveLocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLocationResponseDescriptor =
    $convert.base64Decode(
        'ChdBcHByb3ZlTG9jYXRpb25SZXNwb25zZRJJCghsb2NhdGlvbhgBIAEoCzItLmhlYWx0aGNhcm'
        'UuaG91c2VrZWVwaW5nLnYxLkNsZWFuYWJsZUxvY2F0aW9uUghsb2NhdGlvbg==');

@$core.Deprecated('Use listLocationsRequestDescriptor instead')
const ListLocationsRequest$json = {
  '1': 'ListLocationsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 9, '10': 'zone'},
    {
      '1': 'risk_class',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.RiskClass',
      '10': 'riskClass'
    },
    {'1': 'live_only', '3': 4, '4': 1, '5': 8, '10': 'liveOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 6, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListLocationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLocationsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0TG9jYXRpb25zUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZB'
    'ISCgR6b25lGAIgASgJUgR6b25lEkQKCnJpc2tfY2xhc3MYAyABKA4yJS5oZWFsdGhjYXJlLmhv'
    'dXNla2VlcGluZy52MS5SaXNrQ2xhc3NSCXJpc2tDbGFzcxIbCglsaXZlX29ubHkYBCABKAhSCG'
    'xpdmVPbmx5EhsKCXBhZ2Vfc2l6ZRgFIAEoBVIIcGFnZVNpemUSFgoGb2Zmc2V0GAYgASgFUgZv'
    'ZmZzZXQ=');

@$core.Deprecated('Use listLocationsResponseDescriptor instead')
const ListLocationsResponse$json = {
  '1': 'ListLocationsResponse',
  '2': [
    {
      '1': 'locations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleanableLocation',
      '10': 'locations'
    },
  ],
};

/// Descriptor for `ListLocationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLocationsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TG9jYXRpb25zUmVzcG9uc2USSwoJbG9jYXRpb25zGAEgAygLMi0uaGVhbHRoY2FyZS'
    '5ob3VzZWtlZXBpbmcudjEuQ2xlYW5hYmxlTG9jYXRpb25SCWxvY2F0aW9ucw==');

@$core.Deprecated('Use getLocationInForceRequestDescriptor instead')
const GetLocationInForceRequest$json = {
  '1': 'GetLocationInForceRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `GetLocationInForceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLocationInForceRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRMb2NhdGlvbkluRm9yY2VSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGU=');

@$core.Deprecated('Use getLocationInForceResponseDescriptor instead')
const GetLocationInForceResponse$json = {
  '1': 'GetLocationInForceResponse',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleanableLocation',
      '10': 'location'
    },
  ],
};

/// Descriptor for `GetLocationInForceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLocationInForceResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRMb2NhdGlvbkluRm9yY2VSZXNwb25zZRJJCghsb2NhdGlvbhgBIAEoCzItLmhlYWx0aG'
        'NhcmUuaG91c2VrZWVwaW5nLnYxLkNsZWFuYWJsZUxvY2F0aW9uUghsb2NhdGlvbg==');

@$core.Deprecated('Use listDueRoutineCleansRequestDescriptor instead')
const ListDueRoutineCleansRequest$json = {
  '1': 'ListDueRoutineCleansRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListDueRoutineCleansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueRoutineCleansRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RHVlUm91dGluZUNsZWFuc1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2'
        'lsaXR5SWQ=');

@$core.Deprecated('Use listDueRoutineCleansResponseDescriptor instead')
const ListDueRoutineCleansResponse$json = {
  '1': 'ListDueRoutineCleansResponse',
  '2': [
    {
      '1': 'due',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.DueRoutineClean',
      '10': 'due'
    },
  ],
};

/// Descriptor for `ListDueRoutineCleansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueRoutineCleansResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0RHVlUm91dGluZUNsZWFuc1Jlc3BvbnNlEj0KA2R1ZRgBIAMoCzIrLmhlYWx0aGNhcm'
        'UuaG91c2VrZWVwaW5nLnYxLkR1ZVJvdXRpbmVDbGVhblIDZHVl');

@$core.Deprecated('Use raiseCleaningTaskRequestDescriptor instead')
const RaiseCleaningTaskRequest$json = {
  '1': 'RaiseCleaningTaskRequest',
  '2': [
    {'1': 'location_code', '3': 1, '4': 1, '5': 9, '10': 'locationCode'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.TaskKind',
      '10': 'kind'
    },
    {'1': 'incident_ref', '3': 3, '4': 1, '5': 9, '10': 'incidentRef'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'assignee_id', '3': 5, '4': 1, '5': 9, '10': 'assigneeId'},
  ],
};

/// Descriptor for `RaiseCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCleaningTaskRequestDescriptor = $convert.base64Decode(
    'ChhSYWlzZUNsZWFuaW5nVGFza1JlcXVlc3QSIwoNbG9jYXRpb25fY29kZRgBIAEoCVIMbG9jYX'
    'Rpb25Db2RlEjgKBGtpbmQYAiABKA4yJC5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5UYXNr'
    'S2luZFIEa2luZBIhCgxpbmNpZGVudF9yZWYYAyABKAlSC2luY2lkZW50UmVmEhYKBmRldGFpbB'
    'gEIAEoCVIGZGV0YWlsEh8KC2Fzc2lnbmVlX2lkGAUgASgJUgphc3NpZ25lZUlk');

@$core.Deprecated('Use raiseCleaningTaskResponseDescriptor instead')
const RaiseCleaningTaskResponse$json = {
  '1': 'RaiseCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `RaiseCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChlSYWlzZUNsZWFuaW5nVGFza1Jlc3BvbnNlEjwKBHRhc2sYASABKAsyKC5oZWFsdGhjYXJlLm'
        'hvdXNla2VlcGluZy52MS5DbGVhbmluZ1Rhc2tSBHRhc2s=');

@$core.Deprecated('Use assignCleaningTaskRequestDescriptor instead')
const AssignCleaningTaskRequest$json = {
  '1': 'AssignCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'assignee_id', '3': 2, '4': 1, '5': 9, '10': 'assigneeId'},
  ],
};

/// Descriptor for `AssignCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChlBc3NpZ25DbGVhbmluZ1Rhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIfCg'
        'thc3NpZ25lZV9pZBgCIAEoCVIKYXNzaWduZWVJZA==');

@$core.Deprecated('Use assignCleaningTaskResponseDescriptor instead')
const AssignCleaningTaskResponse$json = {
  '1': 'AssignCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `AssignCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChpBc3NpZ25DbGVhbmluZ1Rhc2tSZXNwb25zZRI8CgR0YXNrGAEgASgLMiguaGVhbHRoY2FyZS'
        '5ob3VzZWtlZXBpbmcudjEuQ2xlYW5pbmdUYXNrUgR0YXNr');

@$core.Deprecated('Use startCleaningTaskRequestDescriptor instead')
const StartCleaningTaskRequest$json = {
  '1': 'StartCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
  ],
};

/// Descriptor for `StartCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChhTdGFydENsZWFuaW5nVGFza1JlcXVlc3QSFwoHdGFza19pZBgBIAEoCVIGdGFza0lk');

@$core.Deprecated('Use startCleaningTaskResponseDescriptor instead')
const StartCleaningTaskResponse$json = {
  '1': 'StartCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `StartCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChlTdGFydENsZWFuaW5nVGFza1Jlc3BvbnNlEjwKBHRhc2sYASABKAsyKC5oZWFsdGhjYXJlLm'
        'hvdXNla2VlcGluZy52MS5DbGVhbmluZ1Rhc2tSBHRhc2s=');

@$core.Deprecated('Use completeCleaningTaskRequestDescriptor instead')
const CompleteCleaningTaskRequest$json = {
  '1': 'CompleteCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'answers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.ChecklistAnswer',
      '10': 'answers'
    },
  ],
};

/// Descriptor for `CompleteCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChtDb21wbGV0ZUNsZWFuaW5nVGFza1JlcXVlc3QSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEk'
        'UKB2Fuc3dlcnMYAiADKAsyKy5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5DaGVja2xpc3RB'
        'bnN3ZXJSB2Fuc3dlcnM=');

@$core.Deprecated('Use completeCleaningTaskResponseDescriptor instead')
const CompleteCleaningTaskResponse$json = {
  '1': 'CompleteCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CompleteCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChxDb21wbGV0ZUNsZWFuaW5nVGFza1Jlc3BvbnNlEjwKBHRhc2sYASABKAsyKC5oZWFsdGhjYX'
        'JlLmhvdXNla2VlcGluZy52MS5DbGVhbmluZ1Rhc2tSBHRhc2s=');

@$core.Deprecated('Use verifyCleaningTaskRequestDescriptor instead')
const VerifyCleaningTaskRequest$json = {
  '1': 'VerifyCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `VerifyCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChlWZXJpZnlDbGVhbmluZ1Rhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBISCg'
        'Rub3RlGAIgASgJUgRub3Rl');

@$core.Deprecated('Use verifyCleaningTaskResponseDescriptor instead')
const VerifyCleaningTaskResponse$json = {
  '1': 'VerifyCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `VerifyCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChpWZXJpZnlDbGVhbmluZ1Rhc2tSZXNwb25zZRI8CgR0YXNrGAEgASgLMiguaGVhbHRoY2FyZS'
        '5ob3VzZWtlZXBpbmcudjEuQ2xlYW5pbmdUYXNrUgR0YXNr');

@$core.Deprecated('Use cancelCleaningTaskRequestDescriptor instead')
const CancelCleaningTaskRequest$json = {
  '1': 'CancelCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChlDYW5jZWxDbGVhbmluZ1Rhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIWCg'
        'ZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use cancelCleaningTaskResponseDescriptor instead')
const CancelCleaningTaskResponse$json = {
  '1': 'CancelCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CancelCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChpDYW5jZWxDbGVhbmluZ1Rhc2tSZXNwb25zZRI8CgR0YXNrGAEgASgLMiguaGVhbHRoY2FyZS'
        '5ob3VzZWtlZXBpbmcudjEuQ2xlYW5pbmdUYXNrUgR0YXNr');

@$core.Deprecated('Use getCleaningTaskRequestDescriptor instead')
const GetCleaningTaskRequest$json = {
  '1': 'GetCleaningTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
  ],
};

/// Descriptor for `GetCleaningTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCleaningTaskRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDbGVhbmluZ1Rhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZA==');

@$core.Deprecated('Use getCleaningTaskResponseDescriptor instead')
const GetCleaningTaskResponse$json = {
  '1': 'GetCleaningTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `GetCleaningTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCleaningTaskResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRDbGVhbmluZ1Rhc2tSZXNwb25zZRI8CgR0YXNrGAEgASgLMiguaGVhbHRoY2FyZS5ob3'
        'VzZWtlZXBpbmcudjEuQ2xlYW5pbmdUYXNrUgR0YXNr');

@$core.Deprecated('Use listCleaningTasksRequestDescriptor instead')
const ListCleaningTasksRequest$json = {
  '1': 'ListCleaningTasksRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'location_code', '3': 3, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'bed_id', '3': 4, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.TaskKind',
      '10': 'kind'
    },
    {
      '1': 'states',
      '3': 6,
      '4': 3,
      '5': 14,
      '6': '.healthcare.housekeeping.v1.TaskState',
      '10': 'states'
    },
    {'1': 'assignee_id', '3': 7, '4': 1, '5': 9, '10': 'assigneeId'},
    {'1': 'open_only', '3': 8, '4': 1, '5': 8, '10': 'openOnly'},
    {
      '1': 'from',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
    {'1': 'page_size', '3': 11, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 12, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListCleaningTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCleaningTasksRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0Q2xlYW5pbmdUYXNrc1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaX'
    'R5SWQSEgoEem9uZRgCIAEoCVIEem9uZRIjCg1sb2NhdGlvbl9jb2RlGAMgASgJUgxsb2NhdGlv'
    'bkNvZGUSFQoGYmVkX2lkGAQgASgJUgViZWRJZBI4CgRraW5kGAUgASgOMiQuaGVhbHRoY2FyZS'
    '5ob3VzZWtlZXBpbmcudjEuVGFza0tpbmRSBGtpbmQSPQoGc3RhdGVzGAYgAygOMiUuaGVhbHRo'
    'Y2FyZS5ob3VzZWtlZXBpbmcudjEuVGFza1N0YXRlUgZzdGF0ZXMSHwoLYXNzaWduZWVfaWQYBy'
    'ABKAlSCmFzc2lnbmVlSWQSGwoJb3Blbl9vbmx5GAggASgIUghvcGVuT25seRIuCgRmcm9tGAkg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgKIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgLIAEoBVIIcGFnZVNpemUS'
    'FgoGb2Zmc2V0GAwgASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listCleaningTasksResponseDescriptor instead')
const ListCleaningTasksResponse$json = {
  '1': 'ListCleaningTasksResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `ListCleaningTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCleaningTasksResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0Q2xlYW5pbmdUYXNrc1Jlc3BvbnNlEj4KBXRhc2tzGAEgAygLMiguaGVhbHRoY2FyZS'
        '5ob3VzZWtlZXBpbmcudjEuQ2xlYW5pbmdUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use escalateOverdueCleansRequestDescriptor instead')
const EscalateOverdueCleansRequest$json = {
  '1': 'EscalateOverdueCleansRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `EscalateOverdueCleansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueCleansRequestDescriptor =
    $convert.base64Decode(
        'ChxFc2NhbGF0ZU92ZXJkdWVDbGVhbnNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYW'
        'NpbGl0eUlk');

@$core.Deprecated('Use escalateOverdueCleansResponseDescriptor instead')
const EscalateOverdueCleansResponse$json = {
  '1': 'EscalateOverdueCleansResponse',
  '2': [
    {
      '1': 'escalated',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'escalated'
    },
  ],
};

/// Descriptor for `EscalateOverdueCleansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueCleansResponseDescriptor =
    $convert.base64Decode(
        'Ch1Fc2NhbGF0ZU92ZXJkdWVDbGVhbnNSZXNwb25zZRJGCgllc2NhbGF0ZWQYASADKAsyKC5oZW'
        'FsdGhjYXJlLmhvdXNla2VlcGluZy52MS5DbGVhbmluZ1Rhc2tSCWVzY2FsYXRlZA==');

@$core.Deprecated('Use recordLocationScanRequestDescriptor instead')
const RecordLocationScanRequest$json = {
  '1': 'RecordLocationScanRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'scanned_code', '3': 2, '4': 1, '5': 9, '10': 'scannedCode'},
  ],
};

/// Descriptor for `RecordLocationScanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordLocationScanRequestDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRMb2NhdGlvblNjYW5SZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIhCg'
        'xzY2FubmVkX2NvZGUYAiABKAlSC3NjYW5uZWRDb2Rl');

@$core.Deprecated('Use recordLocationScanResponseDescriptor instead')
const RecordLocationScanResponse$json = {
  '1': 'RecordLocationScanResponse',
  '2': [
    {
      '1': 'scan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.LocationScan',
      '10': 'scan'
    },
  ],
};

/// Descriptor for `RecordLocationScanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordLocationScanResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWNvcmRMb2NhdGlvblNjYW5SZXNwb25zZRI8CgRzY2FuGAEgASgLMiguaGVhbHRoY2FyZS'
        '5ob3VzZWtlZXBpbmcudjEuTG9jYXRpb25TY2FuUgRzY2Fu');

@$core.Deprecated('Use triggerTerminalCleanRequestDescriptor instead')
const TriggerTerminalCleanRequest$json = {
  '1': 'TriggerTerminalCleanRequest',
  '2': [
    {'1': 'location_code', '3': 1, '4': 1, '5': 9, '10': 'locationCode'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'assignee_id', '3': 3, '4': 1, '5': 9, '10': 'assigneeId'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `TriggerTerminalCleanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerTerminalCleanRequestDescriptor =
    $convert.base64Decode(
        'ChtUcmlnZ2VyVGVybWluYWxDbGVhblJlcXVlc3QSIwoNbG9jYXRpb25fY29kZRgBIAEoCVIMbG'
        '9jYXRpb25Db2RlEiEKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSHwoLYXNzaWdu'
        'ZWVfaWQYAyABKAlSCmFzc2lnbmVlSWQSFgoGZGV0YWlsGAQgASgJUgZkZXRhaWw=');

@$core.Deprecated('Use triggerTerminalCleanResponseDescriptor instead')
const TriggerTerminalCleanResponse$json = {
  '1': 'TriggerTerminalCleanResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningTask',
      '10': 'task'
    },
    {
      '1': 'hold',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.BedHold',
      '10': 'hold'
    },
  ],
};

/// Descriptor for `TriggerTerminalCleanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triggerTerminalCleanResponseDescriptor =
    $convert.base64Decode(
        'ChxUcmlnZ2VyVGVybWluYWxDbGVhblJlc3BvbnNlEjwKBHRhc2sYASABKAsyKC5oZWFsdGhjYX'
        'JlLmhvdXNla2VlcGluZy52MS5DbGVhbmluZ1Rhc2tSBHRhc2sSNwoEaG9sZBgCIAEoCzIjLmhl'
        'YWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkJlZEhvbGRSBGhvbGQ=');

@$core.Deprecated('Use overrideBedHoldRequestDescriptor instead')
const OverrideBedHoldRequest$json = {
  '1': 'OverrideBedHoldRequest',
  '2': [
    {'1': 'hold_id', '3': 1, '4': 1, '5': 9, '10': 'holdId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OverrideBedHoldRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideBedHoldRequestDescriptor =
    $convert.base64Decode(
        'ChZPdmVycmlkZUJlZEhvbGRSZXF1ZXN0EhcKB2hvbGRfaWQYASABKAlSBmhvbGRJZBIWCgZyZW'
        'Fzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use overrideBedHoldResponseDescriptor instead')
const OverrideBedHoldResponse$json = {
  '1': 'OverrideBedHoldResponse',
  '2': [
    {
      '1': 'hold',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.BedHold',
      '10': 'hold'
    },
  ],
};

/// Descriptor for `OverrideBedHoldResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideBedHoldResponseDescriptor =
    $convert.base64Decode(
        'ChdPdmVycmlkZUJlZEhvbGRSZXNwb25zZRI3CgRob2xkGAEgASgLMiMuaGVhbHRoY2FyZS5ob3'
        'VzZWtlZXBpbmcudjEuQmVkSG9sZFIEaG9sZA==');

@$core.Deprecated('Use getBedStatusRequestDescriptor instead')
const GetBedStatusRequest$json = {
  '1': 'GetBedStatusRequest',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
  ],
};

/// Descriptor for `GetBedStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBedStatusRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRCZWRTdGF0dXNSZXF1ZXN0EhUKBmJlZF9pZBgBIAEoCVIFYmVkSWQ=');

@$core.Deprecated('Use getBedStatusResponseDescriptor instead')
const GetBedStatusResponse$json = {
  '1': 'GetBedStatusResponse',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'clear', '3': 2, '4': 1, '5': 8, '10': 'clear'},
    {
      '1': 'hold',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.BedHold',
      '10': 'hold'
    },
  ],
};

/// Descriptor for `GetBedStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBedStatusResponseDescriptor = $convert.base64Decode(
    'ChRHZXRCZWRTdGF0dXNSZXNwb25zZRIVCgZiZWRfaWQYASABKAlSBWJlZElkEhQKBWNsZWFyGA'
    'IgASgIUgVjbGVhchI3CgRob2xkGAMgASgLMiMuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEu'
    'QmVkSG9sZFIEaG9sZA==');

@$core.Deprecated('Use listHeldBedsRequestDescriptor instead')
const ListHeldBedsRequest$json = {
  '1': 'ListHeldBedsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListHeldBedsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHeldBedsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0SGVsZEJlZHNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eUlkEh'
    'IKBHpvbmUYAiABKAlSBHpvbmUSGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZRIWCgZvZmZz'
    'ZXQYBCABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listHeldBedsResponseDescriptor instead')
const ListHeldBedsResponse$json = {
  '1': 'ListHeldBedsResponse',
  '2': [
    {
      '1': 'holds',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.BedHold',
      '10': 'holds'
    },
  ],
};

/// Descriptor for `ListHeldBedsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHeldBedsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0SGVsZEJlZHNSZXNwb25zZRI5CgVob2xkcxgBIAMoCzIjLmhlYWx0aGNhcmUuaG91c2'
    'VrZWVwaW5nLnYxLkJlZEhvbGRSBWhvbGRz');

@$core.Deprecated('Use cleaningSummaryDescriptor instead')
const CleaningSummary$json = {
  '1': 'CleaningSummary',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
    {'1': 'completed', '3': 2, '4': 1, '5': 5, '10': 'completed'},
    {'1': 'cancelled', '3': 3, '4': 1, '5': 5, '10': 'cancelled'},
    {'1': 'outstanding', '3': 4, '4': 1, '5': 5, '10': 'outstanding'},
    {'1': 'overdue_now', '3': 5, '4': 1, '5': 5, '10': 'overdueNow'},
    {'1': 'completed_late', '3': 6, '4': 1, '5': 5, '10': 'completedLate'},
    {'1': 'within_sla', '3': 7, '4': 1, '5': 5, '10': 'withinSla'},
    {
      '1': 'mean_turnaround_minutes',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'meanTurnaroundMinutes'
    },
    {
      '1': 'longest_turnaround_minutes',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'longestTurnaroundMinutes'
    },
    {'1': 'verified', '3': 10, '4': 1, '5': 5, '10': 'verified'},
    {'1': 'scan_verified', '3': 11, '4': 1, '5': 5, '10': 'scanVerified'},
    {'1': 'unanswerable', '3': 12, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `CleaningSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cleaningSummaryDescriptor = $convert.base64Decode(
    'Cg9DbGVhbmluZ1N1bW1hcnkSFgoGcmFpc2VkGAEgASgFUgZyYWlzZWQSHAoJY29tcGxldGVkGA'
    'IgASgFUgljb21wbGV0ZWQSHAoJY2FuY2VsbGVkGAMgASgFUgljYW5jZWxsZWQSIAoLb3V0c3Rh'
    'bmRpbmcYBCABKAVSC291dHN0YW5kaW5nEh8KC292ZXJkdWVfbm93GAUgASgFUgpvdmVyZHVlTm'
    '93EiUKDmNvbXBsZXRlZF9sYXRlGAYgASgFUg1jb21wbGV0ZWRMYXRlEh0KCndpdGhpbl9zbGEY'
    'ByABKAVSCXdpdGhpblNsYRI2ChdtZWFuX3R1cm5hcm91bmRfbWludXRlcxgIIAEoBVIVbWVhbl'
    'R1cm5hcm91bmRNaW51dGVzEjwKGmxvbmdlc3RfdHVybmFyb3VuZF9taW51dGVzGAkgASgFUhhs'
    'b25nZXN0VHVybmFyb3VuZE1pbnV0ZXMSGgoIdmVyaWZpZWQYCiABKAVSCHZlcmlmaWVkEiMKDX'
    'NjYW5fdmVyaWZpZWQYCyABKAVSDHNjYW5WZXJpZmllZBIiCgx1bmFuc3dlcmFibGUYDCABKAhS'
    'DHVuYW5zd2VyYWJsZQ==');

@$core.Deprecated('Use turnaroundSummaryDescriptor instead')
const TurnaroundSummary$json = {
  '1': 'TurnaroundSummary',
  '2': [
    {'1': 'held', '3': 1, '4': 1, '5': 5, '10': 'held'},
    {'1': 'released', '3': 2, '4': 1, '5': 5, '10': 'released'},
    {'1': 'still_held', '3': 3, '4': 1, '5': 5, '10': 'stillHeld'},
    {'1': 'overridden', '3': 4, '4': 1, '5': 5, '10': 'overridden'},
    {'1': 'mean_minutes', '3': 5, '4': 1, '5': 5, '10': 'meanMinutes'},
    {'1': 'longest_minutes', '3': 6, '4': 1, '5': 5, '10': 'longestMinutes'},
    {'1': 'unanswerable', '3': 7, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `TurnaroundSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List turnaroundSummaryDescriptor = $convert.base64Decode(
    'ChFUdXJuYXJvdW5kU3VtbWFyeRISCgRoZWxkGAEgASgFUgRoZWxkEhoKCHJlbGVhc2VkGAIgAS'
    'gFUghyZWxlYXNlZBIdCgpzdGlsbF9oZWxkGAMgASgFUglzdGlsbEhlbGQSHgoKb3ZlcnJpZGRl'
    'bhgEIAEoBVIKb3ZlcnJpZGRlbhIhCgxtZWFuX21pbnV0ZXMYBSABKAVSC21lYW5NaW51dGVzEi'
    'cKD2xvbmdlc3RfbWludXRlcxgGIAEoBVIObG9uZ2VzdE1pbnV0ZXMSIgoMdW5hbnN3ZXJhYmxl'
    'GAcgASgIUgx1bmFuc3dlcmFibGU=');

@$core.Deprecated('Use getCleaningReportRequestDescriptor instead')
const GetCleaningReportRequest$json = {
  '1': 'GetCleaningReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 9, '10': 'zone'},
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

/// Descriptor for `GetCleaningReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCleaningReportRequestDescriptor = $convert.base64Decode(
    'ChhHZXRDbGVhbmluZ1JlcG9ydFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaX'
    'R5SWQSEgoEem9uZRgCIAEoCVIEem9uZRIuCgRmcm9tGAMgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSAnRv');

@$core.Deprecated('Use getCleaningReportResponseDescriptor instead')
const GetCleaningReportResponse$json = {
  '1': 'GetCleaningReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.CleaningSummary',
      '10': 'summary'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetCleaningReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCleaningReportResponseDescriptor = $convert.base64Decode(
    'ChlHZXRDbGVhbmluZ1JlcG9ydFJlc3BvbnNlEkUKB3N1bW1hcnkYASABKAsyKy5oZWFsdGhjYX'
    'JlLmhvdXNla2VlcGluZy52MS5DbGVhbmluZ1N1bW1hcnlSB3N1bW1hcnkSHAoJdHJ1bmNhdGVk'
    'GAIgASgIUgl0cnVuY2F0ZWQ=');

@$core.Deprecated('Use getTurnaroundReportRequestDescriptor instead')
const GetTurnaroundReportRequest$json = {
  '1': 'GetTurnaroundReportRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 9, '10': 'zone'},
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

/// Descriptor for `GetTurnaroundReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTurnaroundReportRequestDescriptor = $convert.base64Decode(
    'ChpHZXRUdXJuYXJvdW5kUmVwb3J0UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaW'
    'xpdHlJZBISCgR6b25lGAIgASgJUgR6b25lEi4KBGZyb20YAyABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFICdG8=');

@$core.Deprecated('Use getTurnaroundReportResponseDescriptor instead')
const GetTurnaroundReportResponse$json = {
  '1': 'GetTurnaroundReportResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.housekeeping.v1.TurnaroundSummary',
      '10': 'summary'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetTurnaroundReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTurnaroundReportResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRUdXJuYXJvdW5kUmVwb3J0UmVzcG9uc2USRwoHc3VtbWFyeRgBIAEoCzItLmhlYWx0aG'
        'NhcmUuaG91c2VrZWVwaW5nLnYxLlR1cm5hcm91bmRTdW1tYXJ5UgdzdW1tYXJ5EhwKCXRydW5j'
        'YXRlZBgCIAEoCFIJdHJ1bmNhdGVk');

const $core.Map<$core.String, $core.dynamic> HousekeepingServiceBase$json = {
  '1': 'HousekeepingService',
  '2': [
    {
      '1': 'ConfigureLocation',
      '2': '.healthcare.housekeeping.v1.ConfigureLocationRequest',
      '3': '.healthcare.housekeeping.v1.ConfigureLocationResponse'
    },
    {
      '1': 'ApproveLocation',
      '2': '.healthcare.housekeeping.v1.ApproveLocationRequest',
      '3': '.healthcare.housekeeping.v1.ApproveLocationResponse'
    },
    {
      '1': 'ListLocations',
      '2': '.healthcare.housekeeping.v1.ListLocationsRequest',
      '3': '.healthcare.housekeeping.v1.ListLocationsResponse'
    },
    {
      '1': 'GetLocationInForce',
      '2': '.healthcare.housekeeping.v1.GetLocationInForceRequest',
      '3': '.healthcare.housekeeping.v1.GetLocationInForceResponse'
    },
    {
      '1': 'ListDueRoutineCleans',
      '2': '.healthcare.housekeeping.v1.ListDueRoutineCleansRequest',
      '3': '.healthcare.housekeeping.v1.ListDueRoutineCleansResponse'
    },
    {
      '1': 'RaiseCleaningTask',
      '2': '.healthcare.housekeeping.v1.RaiseCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.RaiseCleaningTaskResponse'
    },
    {
      '1': 'AssignCleaningTask',
      '2': '.healthcare.housekeeping.v1.AssignCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.AssignCleaningTaskResponse'
    },
    {
      '1': 'StartCleaningTask',
      '2': '.healthcare.housekeeping.v1.StartCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.StartCleaningTaskResponse'
    },
    {
      '1': 'CompleteCleaningTask',
      '2': '.healthcare.housekeeping.v1.CompleteCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.CompleteCleaningTaskResponse'
    },
    {
      '1': 'VerifyCleaningTask',
      '2': '.healthcare.housekeeping.v1.VerifyCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.VerifyCleaningTaskResponse'
    },
    {
      '1': 'CancelCleaningTask',
      '2': '.healthcare.housekeeping.v1.CancelCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.CancelCleaningTaskResponse'
    },
    {
      '1': 'GetCleaningTask',
      '2': '.healthcare.housekeeping.v1.GetCleaningTaskRequest',
      '3': '.healthcare.housekeeping.v1.GetCleaningTaskResponse'
    },
    {
      '1': 'ListCleaningTasks',
      '2': '.healthcare.housekeeping.v1.ListCleaningTasksRequest',
      '3': '.healthcare.housekeeping.v1.ListCleaningTasksResponse'
    },
    {
      '1': 'EscalateOverdueCleans',
      '2': '.healthcare.housekeeping.v1.EscalateOverdueCleansRequest',
      '3': '.healthcare.housekeeping.v1.EscalateOverdueCleansResponse'
    },
    {
      '1': 'RecordLocationScan',
      '2': '.healthcare.housekeeping.v1.RecordLocationScanRequest',
      '3': '.healthcare.housekeeping.v1.RecordLocationScanResponse'
    },
    {
      '1': 'TriggerTerminalClean',
      '2': '.healthcare.housekeeping.v1.TriggerTerminalCleanRequest',
      '3': '.healthcare.housekeeping.v1.TriggerTerminalCleanResponse'
    },
    {
      '1': 'OverrideBedHold',
      '2': '.healthcare.housekeeping.v1.OverrideBedHoldRequest',
      '3': '.healthcare.housekeeping.v1.OverrideBedHoldResponse'
    },
    {
      '1': 'GetBedStatus',
      '2': '.healthcare.housekeeping.v1.GetBedStatusRequest',
      '3': '.healthcare.housekeeping.v1.GetBedStatusResponse'
    },
    {
      '1': 'ListHeldBeds',
      '2': '.healthcare.housekeeping.v1.ListHeldBedsRequest',
      '3': '.healthcare.housekeeping.v1.ListHeldBedsResponse'
    },
    {
      '1': 'GetCleaningReport',
      '2': '.healthcare.housekeeping.v1.GetCleaningReportRequest',
      '3': '.healthcare.housekeeping.v1.GetCleaningReportResponse'
    },
    {
      '1': 'GetTurnaroundReport',
      '2': '.healthcare.housekeeping.v1.GetTurnaroundReportRequest',
      '3': '.healthcare.housekeeping.v1.GetTurnaroundReportResponse'
    },
  ],
};

@$core.Deprecated('Use housekeepingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    HousekeepingServiceBase$messageJson = {
  '.healthcare.housekeeping.v1.ConfigureLocationRequest':
      ConfigureLocationRequest$json,
  '.healthcare.housekeeping.v1.ChecklistItem': ChecklistItem$json,
  '.healthcare.housekeeping.v1.ConfigureLocationResponse':
      ConfigureLocationResponse$json,
  '.healthcare.housekeeping.v1.CleanableLocation': CleanableLocation$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.housekeeping.v1.ApproveLocationRequest':
      ApproveLocationRequest$json,
  '.healthcare.housekeeping.v1.ApproveLocationResponse':
      ApproveLocationResponse$json,
  '.healthcare.housekeeping.v1.ListLocationsRequest': ListLocationsRequest$json,
  '.healthcare.housekeeping.v1.ListLocationsResponse':
      ListLocationsResponse$json,
  '.healthcare.housekeeping.v1.GetLocationInForceRequest':
      GetLocationInForceRequest$json,
  '.healthcare.housekeeping.v1.GetLocationInForceResponse':
      GetLocationInForceResponse$json,
  '.healthcare.housekeeping.v1.ListDueRoutineCleansRequest':
      ListDueRoutineCleansRequest$json,
  '.healthcare.housekeeping.v1.ListDueRoutineCleansResponse':
      ListDueRoutineCleansResponse$json,
  '.healthcare.housekeeping.v1.DueRoutineClean': DueRoutineClean$json,
  '.healthcare.housekeeping.v1.RaiseCleaningTaskRequest':
      RaiseCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.RaiseCleaningTaskResponse':
      RaiseCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.CleaningTask': CleaningTask$json,
  '.healthcare.housekeeping.v1.ChecklistAnswer': ChecklistAnswer$json,
  '.healthcare.housekeeping.v1.LocationScan': LocationScan$json,
  '.healthcare.housekeeping.v1.AssignCleaningTaskRequest':
      AssignCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.AssignCleaningTaskResponse':
      AssignCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.StartCleaningTaskRequest':
      StartCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.StartCleaningTaskResponse':
      StartCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.CompleteCleaningTaskRequest':
      CompleteCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.CompleteCleaningTaskResponse':
      CompleteCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.VerifyCleaningTaskRequest':
      VerifyCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.VerifyCleaningTaskResponse':
      VerifyCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.CancelCleaningTaskRequest':
      CancelCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.CancelCleaningTaskResponse':
      CancelCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.GetCleaningTaskRequest':
      GetCleaningTaskRequest$json,
  '.healthcare.housekeeping.v1.GetCleaningTaskResponse':
      GetCleaningTaskResponse$json,
  '.healthcare.housekeeping.v1.ListCleaningTasksRequest':
      ListCleaningTasksRequest$json,
  '.healthcare.housekeeping.v1.ListCleaningTasksResponse':
      ListCleaningTasksResponse$json,
  '.healthcare.housekeeping.v1.EscalateOverdueCleansRequest':
      EscalateOverdueCleansRequest$json,
  '.healthcare.housekeeping.v1.EscalateOverdueCleansResponse':
      EscalateOverdueCleansResponse$json,
  '.healthcare.housekeeping.v1.RecordLocationScanRequest':
      RecordLocationScanRequest$json,
  '.healthcare.housekeeping.v1.RecordLocationScanResponse':
      RecordLocationScanResponse$json,
  '.healthcare.housekeeping.v1.TriggerTerminalCleanRequest':
      TriggerTerminalCleanRequest$json,
  '.healthcare.housekeeping.v1.TriggerTerminalCleanResponse':
      TriggerTerminalCleanResponse$json,
  '.healthcare.housekeeping.v1.BedHold': BedHold$json,
  '.healthcare.housekeeping.v1.OverrideBedHoldRequest':
      OverrideBedHoldRequest$json,
  '.healthcare.housekeeping.v1.OverrideBedHoldResponse':
      OverrideBedHoldResponse$json,
  '.healthcare.housekeeping.v1.GetBedStatusRequest': GetBedStatusRequest$json,
  '.healthcare.housekeeping.v1.GetBedStatusResponse': GetBedStatusResponse$json,
  '.healthcare.housekeeping.v1.ListHeldBedsRequest': ListHeldBedsRequest$json,
  '.healthcare.housekeeping.v1.ListHeldBedsResponse': ListHeldBedsResponse$json,
  '.healthcare.housekeeping.v1.GetCleaningReportRequest':
      GetCleaningReportRequest$json,
  '.healthcare.housekeeping.v1.GetCleaningReportResponse':
      GetCleaningReportResponse$json,
  '.healthcare.housekeeping.v1.CleaningSummary': CleaningSummary$json,
  '.healthcare.housekeeping.v1.GetTurnaroundReportRequest':
      GetTurnaroundReportRequest$json,
  '.healthcare.housekeeping.v1.GetTurnaroundReportResponse':
      GetTurnaroundReportResponse$json,
  '.healthcare.housekeeping.v1.TurnaroundSummary': TurnaroundSummary$json,
};

/// Descriptor for `HousekeepingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List housekeepingServiceDescriptor = $convert.base64Decode(
    'ChNIb3VzZWtlZXBpbmdTZXJ2aWNlEoABChFDb25maWd1cmVMb2NhdGlvbhI0LmhlYWx0aGNhcm'
    'UuaG91c2VrZWVwaW5nLnYxLkNvbmZpZ3VyZUxvY2F0aW9uUmVxdWVzdBo1LmhlYWx0aGNhcmUu'
    'aG91c2VrZWVwaW5nLnYxLkNvbmZpZ3VyZUxvY2F0aW9uUmVzcG9uc2USegoPQXBwcm92ZUxvY2'
    'F0aW9uEjIuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuQXBwcm92ZUxvY2F0aW9uUmVxdWVz'
    'dBozLmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkFwcHJvdmVMb2NhdGlvblJlc3BvbnNlEn'
    'QKDUxpc3RMb2NhdGlvbnMSMC5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5MaXN0TG9jYXRp'
    'b25zUmVxdWVzdBoxLmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkxpc3RMb2NhdGlvbnNSZX'
    'Nwb25zZRKDAQoSR2V0TG9jYXRpb25JbkZvcmNlEjUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcu'
    'djEuR2V0TG9jYXRpb25JbkZvcmNlUmVxdWVzdBo2LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLn'
    'YxLkdldExvY2F0aW9uSW5Gb3JjZVJlc3BvbnNlEokBChRMaXN0RHVlUm91dGluZUNsZWFucxI3'
    'LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkxpc3REdWVSb3V0aW5lQ2xlYW5zUmVxdWVzdB'
    'o4LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkxpc3REdWVSb3V0aW5lQ2xlYW5zUmVzcG9u'
    'c2USgAEKEVJhaXNlQ2xlYW5pbmdUYXNrEjQuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuUm'
    'Fpc2VDbGVhbmluZ1Rhc2tSZXF1ZXN0GjUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuUmFp'
    'c2VDbGVhbmluZ1Rhc2tSZXNwb25zZRKDAQoSQXNzaWduQ2xlYW5pbmdUYXNrEjUuaGVhbHRoY2'
    'FyZS5ob3VzZWtlZXBpbmcudjEuQXNzaWduQ2xlYW5pbmdUYXNrUmVxdWVzdBo2LmhlYWx0aGNh'
    'cmUuaG91c2VrZWVwaW5nLnYxLkFzc2lnbkNsZWFuaW5nVGFza1Jlc3BvbnNlEoABChFTdGFydE'
    'NsZWFuaW5nVGFzaxI0LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLlN0YXJ0Q2xlYW5pbmdU'
    'YXNrUmVxdWVzdBo1LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLlN0YXJ0Q2xlYW5pbmdUYX'
    'NrUmVzcG9uc2USiQEKFENvbXBsZXRlQ2xlYW5pbmdUYXNrEjcuaGVhbHRoY2FyZS5ob3VzZWtl'
    'ZXBpbmcudjEuQ29tcGxldGVDbGVhbmluZ1Rhc2tSZXF1ZXN0GjguaGVhbHRoY2FyZS5ob3VzZW'
    'tlZXBpbmcudjEuQ29tcGxldGVDbGVhbmluZ1Rhc2tSZXNwb25zZRKDAQoSVmVyaWZ5Q2xlYW5p'
    'bmdUYXNrEjUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuVmVyaWZ5Q2xlYW5pbmdUYXNrUm'
    'VxdWVzdBo2LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLlZlcmlmeUNsZWFuaW5nVGFza1Jl'
    'c3BvbnNlEoMBChJDYW5jZWxDbGVhbmluZ1Rhc2sSNS5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy'
    '52MS5DYW5jZWxDbGVhbmluZ1Rhc2tSZXF1ZXN0GjYuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcu'
    'djEuQ2FuY2VsQ2xlYW5pbmdUYXNrUmVzcG9uc2USegoPR2V0Q2xlYW5pbmdUYXNrEjIuaGVhbH'
    'RoY2FyZS5ob3VzZWtlZXBpbmcudjEuR2V0Q2xlYW5pbmdUYXNrUmVxdWVzdBozLmhlYWx0aGNh'
    'cmUuaG91c2VrZWVwaW5nLnYxLkdldENsZWFuaW5nVGFza1Jlc3BvbnNlEoABChFMaXN0Q2xlYW'
    '5pbmdUYXNrcxI0LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkxpc3RDbGVhbmluZ1Rhc2tz'
    'UmVxdWVzdBo1LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkxpc3RDbGVhbmluZ1Rhc2tzUm'
    'VzcG9uc2USjAEKFUVzY2FsYXRlT3ZlcmR1ZUNsZWFucxI4LmhlYWx0aGNhcmUuaG91c2VrZWVw'
    'aW5nLnYxLkVzY2FsYXRlT3ZlcmR1ZUNsZWFuc1JlcXVlc3QaOS5oZWFsdGhjYXJlLmhvdXNla2'
    'VlcGluZy52MS5Fc2NhbGF0ZU92ZXJkdWVDbGVhbnNSZXNwb25zZRKDAQoSUmVjb3JkTG9jYXRp'
    'b25TY2FuEjUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuUmVjb3JkTG9jYXRpb25TY2FuUm'
    'VxdWVzdBo2LmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLlJlY29yZExvY2F0aW9uU2NhblJl'
    'c3BvbnNlEokBChRUcmlnZ2VyVGVybWluYWxDbGVhbhI3LmhlYWx0aGNhcmUuaG91c2VrZWVwaW'
    '5nLnYxLlRyaWdnZXJUZXJtaW5hbENsZWFuUmVxdWVzdBo4LmhlYWx0aGNhcmUuaG91c2VrZWVw'
    'aW5nLnYxLlRyaWdnZXJUZXJtaW5hbENsZWFuUmVzcG9uc2USegoPT3ZlcnJpZGVCZWRIb2xkEj'
    'IuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuT3ZlcnJpZGVCZWRIb2xkUmVxdWVzdBozLmhl'
    'YWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLk92ZXJyaWRlQmVkSG9sZFJlc3BvbnNlEnEKDEdldE'
    'JlZFN0YXR1cxIvLmhlYWx0aGNhcmUuaG91c2VrZWVwaW5nLnYxLkdldEJlZFN0YXR1c1JlcXVl'
    'c3QaMC5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5HZXRCZWRTdGF0dXNSZXNwb25zZRJxCg'
    'xMaXN0SGVsZEJlZHMSLy5oZWFsdGhjYXJlLmhvdXNla2VlcGluZy52MS5MaXN0SGVsZEJlZHNS'
    'ZXF1ZXN0GjAuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuTGlzdEhlbGRCZWRzUmVzcG9uc2'
    'USgAEKEUdldENsZWFuaW5nUmVwb3J0EjQuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuR2V0'
    'Q2xlYW5pbmdSZXBvcnRSZXF1ZXN0GjUuaGVhbHRoY2FyZS5ob3VzZWtlZXBpbmcudjEuR2V0Q2'
    'xlYW5pbmdSZXBvcnRSZXNwb25zZRKGAQoTR2V0VHVybmFyb3VuZFJlcG9ydBI2LmhlYWx0aGNh'
    'cmUuaG91c2VrZWVwaW5nLnYxLkdldFR1cm5hcm91bmRSZXBvcnRSZXF1ZXN0GjcuaGVhbHRoY2'
    'FyZS5ob3VzZWtlZXBpbmcudjEuR2V0VHVybmFyb3VuZFJlcG9ydFJlc3BvbnNl');
