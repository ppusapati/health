// This is a generated file - do not edit.
//
// Generated from healthcare/sterile/v1/sterile.proto.

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

@$core.Deprecated('Use instrumentStatusDescriptor instead')
const InstrumentStatus$json = {
  '1': 'InstrumentStatus',
  '2': [
    {'1': 'INSTRUMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'INSTRUMENT_STATUS_IN_SERVICE', '2': 1},
    {'1': 'INSTRUMENT_STATUS_IN_REPAIR', '2': 2},
    {'1': 'INSTRUMENT_STATUS_MISSING', '2': 3},
    {'1': 'INSTRUMENT_STATUS_RETIRED', '2': 4},
  ],
};

/// Descriptor for `InstrumentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List instrumentStatusDescriptor = $convert.base64Decode(
    'ChBJbnN0cnVtZW50U3RhdHVzEiEKHUlOU1RSVU1FTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASIA'
    'ocSU5TVFJVTUVOVF9TVEFUVVNfSU5fU0VSVklDRRABEh8KG0lOU1RSVU1FTlRfU1RBVFVTX0lO'
    'X1JFUEFJUhACEh0KGUlOU1RSVU1FTlRfU1RBVFVTX01JU1NJTkcQAxIdChlJTlNUUlVNRU5UX1'
    'NUQVRVU19SRVRJUkVEEAQ=');

@$core.Deprecated('Use stageDescriptor instead')
const Stage$json = {
  '1': 'Stage',
  '2': [
    {'1': 'STAGE_UNSPECIFIED', '2': 0},
    {'1': 'STAGE_RECEIVED', '2': 1},
    {'1': 'STAGE_DECONTAMINATED', '2': 2},
    {'1': 'STAGE_WASHED', '2': 3},
    {'1': 'STAGE_INSPECTED', '2': 4},
    {'1': 'STAGE_ASSEMBLED', '2': 5},
    {'1': 'STAGE_PACKAGED', '2': 6},
    {'1': 'STAGE_STERILISED', '2': 7},
    {'1': 'STAGE_RELEASED', '2': 8},
  ],
};

/// Descriptor for `Stage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stageDescriptor = $convert.base64Decode(
    'CgVTdGFnZRIVChFTVEFHRV9VTlNQRUNJRklFRBAAEhIKDlNUQUdFX1JFQ0VJVkVEEAESGAoUU1'
    'RBR0VfREVDT05UQU1JTkFURUQQAhIQCgxTVEFHRV9XQVNIRUQQAxITCg9TVEFHRV9JTlNQRUNU'
    'RUQQBBITCg9TVEFHRV9BU1NFTUJMRUQQBRISCg5TVEFHRV9QQUNLQUdFRBAGEhQKEFNUQUdFX1'
    'NURVJJTElTRUQQBxISCg5TVEFHRV9SRUxFQVNFRBAI');

@$core.Deprecated('Use cycleResultDescriptor instead')
const CycleResult$json = {
  '1': 'CycleResult',
  '2': [
    {'1': 'CYCLE_RESULT_UNSPECIFIED', '2': 0},
    {'1': 'CYCLE_RESULT_RUNNING', '2': 1},
    {'1': 'CYCLE_RESULT_PASSED', '2': 2},
    {'1': 'CYCLE_RESULT_FAILED', '2': 3},
    {'1': 'CYCLE_RESULT_ABORTED', '2': 4},
  ],
};

/// Descriptor for `CycleResult`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cycleResultDescriptor = $convert.base64Decode(
    'CgtDeWNsZVJlc3VsdBIcChhDWUNMRV9SRVNVTFRfVU5TUEVDSUZJRUQQABIYChRDWUNMRV9SRV'
    'NVTFRfUlVOTklORxABEhcKE0NZQ0xFX1JFU1VMVF9QQVNTRUQQAhIXChNDWUNMRV9SRVNVTFRf'
    'RkFJTEVEEAMSGAoUQ1lDTEVfUkVTVUxUX0FCT1JURUQQBA==');

@$core.Deprecated('Use cycleSourceDescriptor instead')
const CycleSource$json = {
  '1': 'CycleSource',
  '2': [
    {'1': 'CYCLE_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'CYCLE_SOURCE_MANUAL', '2': 1},
    {'1': 'CYCLE_SOURCE_INGESTED', '2': 2},
  ],
};

/// Descriptor for `CycleSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cycleSourceDescriptor = $convert.base64Decode(
    'CgtDeWNsZVNvdXJjZRIcChhDWUNMRV9TT1VSQ0VfVU5TUEVDSUZJRUQQABIXChNDWUNMRV9TT1'
    'VSQ0VfTUFOVUFMEAESGQoVQ1lDTEVfU09VUkNFX0lOR0VTVEVEEAI=');

@$core.Deprecated('Use indicatorKindDescriptor instead')
const IndicatorKind$json = {
  '1': 'IndicatorKind',
  '2': [
    {'1': 'INDICATOR_KIND_UNSPECIFIED', '2': 0},
    {'1': 'INDICATOR_KIND_CHEMICAL', '2': 1},
    {'1': 'INDICATOR_KIND_BIOLOGICAL', '2': 2},
  ],
};

/// Descriptor for `IndicatorKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List indicatorKindDescriptor = $convert.base64Decode(
    'Cg1JbmRpY2F0b3JLaW5kEh4KGklORElDQVRPUl9LSU5EX1VOU1BFQ0lGSUVEEAASGwoXSU5ESU'
    'NBVE9SX0tJTkRfQ0hFTUlDQUwQARIdChlJTkRJQ0FUT1JfS0lORF9CSU9MT0dJQ0FMEAI=');

@$core.Deprecated('Use releaseRefusalDescriptor instead')
const ReleaseRefusal$json = {
  '1': 'ReleaseRefusal',
  '2': [
    {'1': 'RELEASE_REFUSAL_UNSPECIFIED', '2': 0},
    {'1': 'RELEASE_REFUSAL_CYCLE_STILL_RUNNING', '2': 1},
    {'1': 'RELEASE_REFUSAL_CYCLE_DID_NOT_PASS', '2': 2},
    {'1': 'RELEASE_REFUSAL_NO_CHEMICAL_INDICATOR', '2': 3},
    {'1': 'RELEASE_REFUSAL_INDICATOR_FAILED', '2': 4},
    {'1': 'RELEASE_REFUSAL_BIOLOGICAL_NOT_READ', '2': 5},
    {'1': 'RELEASE_REFUSAL_ALREADY_RELEASED', '2': 6},
  ],
};

/// Descriptor for `ReleaseRefusal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List releaseRefusalDescriptor = $convert.base64Decode(
    'Cg5SZWxlYXNlUmVmdXNhbBIfChtSRUxFQVNFX1JFRlVTQUxfVU5TUEVDSUZJRUQQABInCiNSRU'
    'xFQVNFX1JFRlVTQUxfQ1lDTEVfU1RJTExfUlVOTklORxABEiYKIlJFTEVBU0VfUkVGVVNBTF9D'
    'WUNMRV9ESURfTk9UX1BBU1MQAhIpCiVSRUxFQVNFX1JFRlVTQUxfTk9fQ0hFTUlDQUxfSU5ESU'
    'NBVE9SEAMSJAogUkVMRUFTRV9SRUZVU0FMX0lORElDQVRPUl9GQUlMRUQQBBInCiNSRUxFQVNF'
    'X1JFRlVTQUxfQklPTE9HSUNBTF9OT1RfUkVBRBAFEiQKIFJFTEVBU0VfUkVGVVNBTF9BTFJFQU'
    'RZX1JFTEVBU0VEEAY=');

@$core.Deprecated('Use issueStateDescriptor instead')
const IssueState$json = {
  '1': 'IssueState',
  '2': [
    {'1': 'ISSUE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ISSUE_STATE_OUT', '2': 1},
    {'1': 'ISSUE_STATE_USED', '2': 2},
    {'1': 'ISSUE_STATE_RETURNED', '2': 3},
    {'1': 'ISSUE_STATE_RECALLED', '2': 4},
  ],
};

/// Descriptor for `IssueState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List issueStateDescriptor = $convert.base64Decode(
    'CgpJc3N1ZVN0YXRlEhsKF0lTU1VFX1NUQVRFX1VOU1BFQ0lGSUVEEAASEwoPSVNTVUVfU1RBVE'
    'VfT1VUEAESFAoQSVNTVUVfU1RBVEVfVVNFRBACEhgKFElTU1VFX1NUQVRFX1JFVFVSTkVEEAMS'
    'GAoUSVNTVUVfU1RBVEVfUkVDQUxMRUQQBA==');

@$core.Deprecated('Use instrumentDescriptor instead')
const Instrument$json = {
  '1': 'Instrument',
  '2': [
    {'1': 'instrument_id', '3': 1, '4': 1, '5': 9, '10': 'instrumentId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'serial_number', '3': 4, '4': 1, '5': 9, '10': 'serialNumber'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.InstrumentStatus',
      '10': 'status'
    },
    {'1': 'location', '3': 6, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'acquired_on',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acquiredOn'
    },
    {
      '1': 'retired_on',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'retiredOn'
    },
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
    {'1': 'packable', '3': 11, '4': 1, '5': 8, '10': 'packable'},
  ],
};

/// Descriptor for `Instrument`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List instrumentDescriptor = $convert.base64Decode(
    'CgpJbnN0cnVtZW50EiMKDWluc3RydW1lbnRfaWQYASABKAlSDGluc3RydW1lbnRJZBISCgRjb2'
    'RlGAIgASgJUgRjb2RlEhgKB2Rpc3BsYXkYAyABKAlSB2Rpc3BsYXkSIwoNc2VyaWFsX251bWJl'
    'chgEIAEoCVIMc2VyaWFsTnVtYmVyEj8KBnN0YXR1cxgFIAEoDjInLmhlYWx0aGNhcmUuc3Rlcm'
    'lsZS52MS5JbnN0cnVtZW50U3RhdHVzUgZzdGF0dXMSGgoIbG9jYXRpb24YBiABKAlSCGxvY2F0'
    'aW9uEjsKC2FjcXVpcmVkX29uGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYW'
    'NxdWlyZWRPbhI5CgpyZXRpcmVkX29uGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJcmV0aXJlZE9uEhQKBW5vdGVzGAkgASgJUgVub3RlcxIYCgd2ZXJzaW9uGAogASgDUgd2ZX'
    'JzaW9uEhoKCHBhY2thYmxlGAsgASgIUghwYWNrYWJsZQ==');

@$core.Deprecated('Use instrumentEventDescriptor instead')
const InstrumentEvent$json = {
  '1': 'InstrumentEvent',
  '2': [
    {
      '1': 'instrument_event_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'instrumentEventId'
    },
    {'1': 'instrument_id', '3': 2, '4': 1, '5': 9, '10': 'instrumentId'},
    {
      '1': 'from_status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.InstrumentStatus',
      '10': 'fromStatus'
    },
    {
      '1': 'to_status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.InstrumentStatus',
      '10': 'toStatus'
    },
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
    {'1': 'location', '3': 6, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'occurred_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'recorded_by', '3': 8, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `InstrumentEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List instrumentEventDescriptor = $convert.base64Decode(
    'Cg9JbnN0cnVtZW50RXZlbnQSLgoTaW5zdHJ1bWVudF9ldmVudF9pZBgBIAEoCVIRaW5zdHJ1bW'
    'VudEV2ZW50SWQSIwoNaW5zdHJ1bWVudF9pZBgCIAEoCVIMaW5zdHJ1bWVudElkEkgKC2Zyb21f'
    'c3RhdHVzGAMgASgOMicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkluc3RydW1lbnRTdGF0dXNSCm'
    'Zyb21TdGF0dXMSRAoJdG9fc3RhdHVzGAQgASgOMicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLklu'
    'c3RydW1lbnRTdGF0dXNSCHRvU3RhdHVzEhIKBG5vdGUYBSABKAlSBG5vdGUSGgoIbG9jYXRpb2'
    '4YBiABKAlSCGxvY2F0aW9uEjsKC29jY3VycmVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIKb2NjdXJyZWRBdBIfCgtyZWNvcmRlZF9ieRgIIAEoCVIKcmVjb3JkZWRCeQ'
    '==');

@$core.Deprecated('Use packingItemDescriptor instead')
const PackingItem$json = {
  '1': 'PackingItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'critical', '3': 4, '4': 1, '5': 8, '10': 'critical'},
  ],
};

/// Descriptor for `PackingItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packingItemDescriptor = $convert.base64Decode(
    'CgtQYWNraW5nSXRlbRISCgRjb2RlGAEgASgJUgRjb2RlEhgKB2Rpc3BsYXkYAiABKAlSB2Rpc3'
    'BsYXkSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5EhoKCGNyaXRpY2FsGAQgASgIUghjcml0'
    'aWNhbA==');

@$core.Deprecated('Use traySetDescriptor instead')
const TraySet$json = {
  '1': 'TraySet',
  '2': [
    {'1': 'set_id', '3': 1, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'kind', '3': 4, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'set_version', '3': 5, '4': 1, '5': 5, '10': 'setVersion'},
    {'1': 'supersedes', '3': 6, '4': 1, '5': 9, '10': 'supersedes'},
    {'1': 'current', '3': 7, '4': 1, '5': 8, '10': 'current'},
    {
      '1': 'items',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.PackingItem',
      '10': 'items'
    },
    {
      '1': 'shelf_life_seconds',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'shelfLifeSeconds'
    },
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 11, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'superseded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
  ],
};

/// Descriptor for `TraySet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traySetDescriptor = $convert.base64Decode(
    'CgdUcmF5U2V0EhUKBnNldF9pZBgBIAEoCVIFc2V0SWQSEgoEY29kZRgCIAEoCVIEY29kZRIYCg'
    'dkaXNwbGF5GAMgASgJUgdkaXNwbGF5EhIKBGtpbmQYBCABKAlSBGtpbmQSHwoLc2V0X3ZlcnNp'
    'b24YBSABKAVSCnNldFZlcnNpb24SHgoKc3VwZXJzZWRlcxgGIAEoCVIKc3VwZXJzZWRlcxIYCg'
    'djdXJyZW50GAcgASgIUgdjdXJyZW50EjgKBWl0ZW1zGAggAygLMiIuaGVhbHRoY2FyZS5zdGVy'
    'aWxlLnYxLlBhY2tpbmdJdGVtUgVpdGVtcxIsChJzaGVsZl9saWZlX3NlY29uZHMYCSABKANSEH'
    'NoZWxmTGlmZVNlY29uZHMSOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GAsgASgJUgljcmVhdGVkQnkSPwoNc3'
    'VwZXJzZWRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHN1cGVyc2Vk'
    'ZWRBdA==');

@$core.Deprecated('Use stageRecordDescriptor instead')
const StageRecord$json = {
  '1': 'StageRecord',
  '2': [
    {'1': 'stage_record_id', '3': 1, '4': 1, '5': 9, '10': 'stageRecordId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'stage',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.Stage',
      '10': 'stage'
    },
    {'1': 'equipment', '3': 4, '4': 1, '5': 9, '10': 'equipment'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'skipped', '3': 6, '4': 1, '5': 8, '10': 'skipped'},
    {
      '1': 'skip_authorised_by',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'skipAuthorisedBy'
    },
    {'1': 'skip_reason', '3': 8, '4': 1, '5': 9, '10': 'skipReason'},
    {
      '1': 'performed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'performed_by', '3': 10, '4': 1, '5': 9, '10': 'performedBy'},
  ],
};

/// Descriptor for `StageRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stageRecordDescriptor = $convert.base64Decode(
    'CgtTdGFnZVJlY29yZBImCg9zdGFnZV9yZWNvcmRfaWQYASABKAlSDXN0YWdlUmVjb3JkSWQSFQ'
    'oGcnVuX2lkGAIgASgJUgVydW5JZBIyCgVzdGFnZRgDIAEoDjIcLmhlYWx0aGNhcmUuc3Rlcmls'
    'ZS52MS5TdGFnZVIFc3RhZ2USHAoJZXF1aXBtZW50GAQgASgJUgllcXVpcG1lbnQSFAoFbm90ZX'
    'MYBSABKAlSBW5vdGVzEhgKB3NraXBwZWQYBiABKAhSB3NraXBwZWQSLAoSc2tpcF9hdXRob3Jp'
    'c2VkX2J5GAcgASgJUhBza2lwQXV0aG9yaXNlZEJ5Eh8KC3NraXBfcmVhc29uGAggASgJUgpza2'
    'lwUmVhc29uEj0KDHBlcmZvcm1lZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSC3BlcmZvcm1lZEF0EiEKDHBlcmZvcm1lZF9ieRgKIAEoCVILcGVyZm9ybWVkQnk=');

@$core.Deprecated('Use runDescriptor instead')
const Run$json = {
  '1': 'Run',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'set_id', '3': 2, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'set_version', '3': 3, '4': 1, '5': 5, '10': 'setVersion'},
    {'1': 'set_code', '3': 4, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'source_unit', '3': 5, '4': 1, '5': 9, '10': 'sourceUnit'},
    {'1': 'source_case_id', '3': 6, '4': 1, '5': 9, '10': 'sourceCaseId'},
    {
      '1': 'stage',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.Stage',
      '10': 'stage'
    },
    {
      '1': 'stages',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.StageRecord',
      '10': 'stages'
    },
    {
      '1': 'received_count',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run.ReceivedCountEntry',
      '10': 'receivedCount'
    },
    {
      '1': 'packed_count',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run.PackedCountEntry',
      '10': 'packedCount'
    },
    {'1': 'missing', '3': 11, '4': 3, '5': 9, '10': 'missing'},
    {'1': 'replaced', '3': 12, '4': 3, '5': 9, '10': 'replaced'},
    {'1': 'cycle_id', '3': 13, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'packaging_method', '3': 14, '4': 1, '5': 9, '10': 'packagingMethod'},
    {'1': 'indicator_type', '3': 15, '4': 1, '5': 9, '10': 'indicatorType'},
    {
      '1': 'sterilised_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sterilisedAt'
    },
    {
      '1': 'expires_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {
      '1': 'started_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 19, '4': 1, '5': 9, '10': 'startedBy'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
    {'1': 'issuable', '3': 21, '4': 1, '5': 8, '10': 'issuable'},
    {'1': 'skipped_stages', '3': 22, '4': 3, '5': 9, '10': 'skippedStages'},
  ],
  '3': [Run_ReceivedCountEntry$json, Run_PackedCountEntry$json],
};

@$core.Deprecated('Use runDescriptor instead')
const Run_ReceivedCountEntry$json = {
  '1': 'ReceivedCountEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use runDescriptor instead')
const Run_PackedCountEntry$json = {
  '1': 'PackedCountEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Run`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runDescriptor = $convert.base64Decode(
    'CgNSdW4SFQoGcnVuX2lkGAEgASgJUgVydW5JZBIVCgZzZXRfaWQYAiABKAlSBXNldElkEh8KC3'
    'NldF92ZXJzaW9uGAMgASgFUgpzZXRWZXJzaW9uEhkKCHNldF9jb2RlGAQgASgJUgdzZXRDb2Rl'
    'Eh8KC3NvdXJjZV91bml0GAUgASgJUgpzb3VyY2VVbml0EiQKDnNvdXJjZV9jYXNlX2lkGAYgAS'
    'gJUgxzb3VyY2VDYXNlSWQSMgoFc3RhZ2UYByABKA4yHC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEu'
    'U3RhZ2VSBXN0YWdlEjoKBnN0YWdlcxgIIAMoCzIiLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5TdG'
    'FnZVJlY29yZFIGc3RhZ2VzElQKDnJlY2VpdmVkX2NvdW50GAkgAygLMi0uaGVhbHRoY2FyZS5z'
    'dGVyaWxlLnYxLlJ1bi5SZWNlaXZlZENvdW50RW50cnlSDXJlY2VpdmVkQ291bnQSTgoMcGFja2'
    'VkX2NvdW50GAogAygLMisuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLlJ1bi5QYWNrZWRDb3VudEVu'
    'dHJ5UgtwYWNrZWRDb3VudBIYCgdtaXNzaW5nGAsgAygJUgdtaXNzaW5nEhoKCHJlcGxhY2VkGA'
    'wgAygJUghyZXBsYWNlZBIZCghjeWNsZV9pZBgNIAEoCVIHY3ljbGVJZBIpChBwYWNrYWdpbmdf'
    'bWV0aG9kGA4gASgJUg9wYWNrYWdpbmdNZXRob2QSJQoOaW5kaWNhdG9yX3R5cGUYDyABKAlSDW'
    'luZGljYXRvclR5cGUSPwoNc3RlcmlsaXNlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSDHN0ZXJpbGlzZWRBdBI5CgpleHBpcmVzX2F0GBEgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0EjkKCnN0YXJ0ZWRfYXQYEiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQSHQoKc3RhcnRlZF9ieRgTIAEoCVIJc3Rhcn'
    'RlZEJ5EhgKB3ZlcnNpb24YFCABKANSB3ZlcnNpb24SGgoIaXNzdWFibGUYFSABKAhSCGlzc3Vh'
    'YmxlEiUKDnNraXBwZWRfc3RhZ2VzGBYgAygJUg1za2lwcGVkU3RhZ2VzGkAKElJlY2VpdmVkQ2'
    '91bnRFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgBGj4K'
    'EFBhY2tlZENvdW50RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbH'
    'VlOgI4AQ==');

@$core.Deprecated('Use indicatorResultDescriptor instead')
const IndicatorResult$json = {
  '1': 'IndicatorResult',
  '2': [
    {'1': 'indicator_id', '3': 1, '4': 1, '5': 9, '10': 'indicatorId'},
    {'1': 'cycle_id', '3': 2, '4': 1, '5': 9, '10': 'cycleId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.IndicatorKind',
      '10': 'kind'
    },
    {'1': 'lot', '3': 4, '4': 1, '5': 9, '10': 'lot'},
    {'1': 'passed', '3': 5, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'read_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readAt'
    },
    {'1': 'read_by', '3': 8, '4': 1, '5': 9, '10': 'readBy'},
  ],
};

/// Descriptor for `IndicatorResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indicatorResultDescriptor = $convert.base64Decode(
    'Cg9JbmRpY2F0b3JSZXN1bHQSIQoMaW5kaWNhdG9yX2lkGAEgASgJUgtpbmRpY2F0b3JJZBIZCg'
    'hjeWNsZV9pZBgCIAEoCVIHY3ljbGVJZBI4CgRraW5kGAMgASgOMiQuaGVhbHRoY2FyZS5zdGVy'
    'aWxlLnYxLkluZGljYXRvcktpbmRSBGtpbmQSEAoDbG90GAQgASgJUgNsb3QSFgoGcGFzc2VkGA'
    'UgASgIUgZwYXNzZWQSFAoFbm90ZXMYBiABKAlSBW5vdGVzEjMKB3JlYWRfYXQYByABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZyZWFkQXQSFwoHcmVhZF9ieRgIIAEoCVIGcmVhZE'
    'J5');

@$core.Deprecated('Use cycleDescriptor instead')
const Cycle$json = {
  '1': 'Cycle',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'machine', '3': 2, '4': 1, '5': 9, '10': 'machine'},
    {'1': 'load_number', '3': 3, '4': 1, '5': 9, '10': 'loadNumber'},
    {'1': 'program', '3': 4, '4': 1, '5': 9, '10': 'program'},
    {
      '1': 'parameters',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle.ParametersEntry',
      '10': 'parameters'
    },
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.CycleSource',
      '10': 'source'
    },
    {
      '1': 'result',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.CycleResult',
      '10': 'result'
    },
    {'1': 'released', '3': 8, '4': 1, '5': 8, '10': 'released'},
    {'1': 'released_by', '3': 9, '4': 1, '5': 9, '10': 'releasedBy'},
    {
      '1': 'released_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'releasedAt'
    },
    {'1': 'release_note', '3': 11, '4': 1, '5': 9, '10': 'releaseNote'},
    {
      '1': 'indicators',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.IndicatorResult',
      '10': 'indicators'
    },
    {
      '1': 'started_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'started_by', '3': 15, '4': 1, '5': 9, '10': 'startedBy'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
  '3': [Cycle_ParametersEntry$json],
};

@$core.Deprecated('Use cycleDescriptor instead')
const Cycle_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Cycle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cycleDescriptor = $convert.base64Decode(
    'CgVDeWNsZRIZCghjeWNsZV9pZBgBIAEoCVIHY3ljbGVJZBIYCgdtYWNoaW5lGAIgASgJUgdtYW'
    'NoaW5lEh8KC2xvYWRfbnVtYmVyGAMgASgJUgpsb2FkTnVtYmVyEhgKB3Byb2dyYW0YBCABKAlS'
    'B3Byb2dyYW0STAoKcGFyYW1ldGVycxgFIAMoCzIsLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5DeW'
    'NsZS5QYXJhbWV0ZXJzRW50cnlSCnBhcmFtZXRlcnMSOgoGc291cmNlGAYgASgOMiIuaGVhbHRo'
    'Y2FyZS5zdGVyaWxlLnYxLkN5Y2xlU291cmNlUgZzb3VyY2USOgoGcmVzdWx0GAcgASgOMiIuaG'
    'VhbHRoY2FyZS5zdGVyaWxlLnYxLkN5Y2xlUmVzdWx0UgZyZXN1bHQSGgoIcmVsZWFzZWQYCCAB'
    'KAhSCHJlbGVhc2VkEh8KC3JlbGVhc2VkX2J5GAkgASgJUgpyZWxlYXNlZEJ5EjsKC3JlbGVhc2'
    'VkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVsZWFzZWRBdBIhCgxy'
    'ZWxlYXNlX25vdGUYCyABKAlSC3JlbGVhc2VOb3RlEkYKCmluZGljYXRvcnMYDCADKAsyJi5oZW'
    'FsdGhjYXJlLnN0ZXJpbGUudjEuSW5kaWNhdG9yUmVzdWx0UgppbmRpY2F0b3JzEjkKCnN0YXJ0'
    'ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQSNQoIZW'
    '5kZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRlZEF0Eh0KCnN0'
    'YXJ0ZWRfYnkYDyABKAlSCXN0YXJ0ZWRCeRIYCgd2ZXJzaW9uGBAgASgDUgd2ZXJzaW9uGj0KD1'
    'BhcmFtZXRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6'
    'AjgB');

@$core.Deprecated('Use releaseDecisionDescriptor instead')
const ReleaseDecision$json = {
  '1': 'ReleaseDecision',
  '2': [
    {'1': 'allowed', '3': 1, '4': 1, '5': 8, '10': 'allowed'},
    {
      '1': 'refusals',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.sterile.v1.ReleaseRefusal',
      '10': 'refusals'
    },
    {'1': 'explanations', '3': 3, '4': 3, '5': 9, '10': 'explanations'},
  ],
};

/// Descriptor for `ReleaseDecision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseDecisionDescriptor = $convert.base64Decode(
    'Cg9SZWxlYXNlRGVjaXNpb24SGAoHYWxsb3dlZBgBIAEoCFIHYWxsb3dlZBJBCghyZWZ1c2Fscx'
    'gCIAMoDjIlLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5SZWxlYXNlUmVmdXNhbFIIcmVmdXNhbHMS'
    'IgoMZXhwbGFuYXRpb25zGAMgAygJUgxleHBsYW5hdGlvbnM=');

@$core.Deprecated('Use labelDescriptor instead')
const Label$json = {
  '1': 'Label',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'set_code', '3': 2, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'set_version', '3': 3, '4': 1, '5': 5, '10': 'setVersion'},
    {'1': 'cycle_id', '3': 4, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'load_number', '3': 5, '4': 1, '5': 9, '10': 'loadNumber'},
    {'1': 'machine', '3': 6, '4': 1, '5': 9, '10': 'machine'},
    {
      '1': 'sterilised_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sterilisedAt'
    },
    {
      '1': 'expires_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'incomplete', '3': 9, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `Label`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labelDescriptor = $convert.base64Decode(
    'CgVMYWJlbBIVCgZydW5faWQYASABKAlSBXJ1bklkEhkKCHNldF9jb2RlGAIgASgJUgdzZXRDb2'
    'RlEh8KC3NldF92ZXJzaW9uGAMgASgFUgpzZXRWZXJzaW9uEhkKCGN5Y2xlX2lkGAQgASgJUgdj'
    'eWNsZUlkEh8KC2xvYWRfbnVtYmVyGAUgASgJUgpsb2FkTnVtYmVyEhgKB21hY2hpbmUYBiABKA'
    'lSB21hY2hpbmUSPwoNc3RlcmlsaXNlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSDHN0ZXJpbGlzZWRBdBI5CgpleHBpcmVzX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJZXhwaXJlc0F0Eh4KCmluY29tcGxldGUYCSADKAlSCmluY29tcGxldGU=');

@$core.Deprecated('Use issueDescriptor instead')
const Issue$json = {
  '1': 'Issue',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'run_id', '3': 2, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'set_code', '3': 3, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'cycle_id', '3': 4, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'destination', '3': 5, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'issued_to', '3': 6, '4': 1, '5': 9, '10': 'issuedTo'},
    {
      '1': 'state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.IssueState',
      '10': 'state'
    },
    {'1': 'used_case_id', '3': 8, '4': 1, '5': 9, '10': 'usedCaseId'},
    {
      '1': 'return_count',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Issue.ReturnCountEntry',
      '10': 'returnCount'
    },
    {'1': 'return_note', '3': 10, '4': 1, '5': 9, '10': 'returnNote'},
    {
      '1': 'issued_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'issued_by', '3': 12, '4': 1, '5': 9, '10': 'issuedBy'},
    {
      '1': 'closed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 14, '4': 1, '5': 9, '10': 'closedBy'},
  ],
  '3': [Issue_ReturnCountEntry$json],
};

@$core.Deprecated('Use issueDescriptor instead')
const Issue_ReturnCountEntry$json = {
  '1': 'ReturnCountEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Issue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueDescriptor = $convert.base64Decode(
    'CgVJc3N1ZRIZCghpc3N1ZV9pZBgBIAEoCVIHaXNzdWVJZBIVCgZydW5faWQYAiABKAlSBXJ1bk'
    'lkEhkKCHNldF9jb2RlGAMgASgJUgdzZXRDb2RlEhkKCGN5Y2xlX2lkGAQgASgJUgdjeWNsZUlk'
    'EiAKC2Rlc3RpbmF0aW9uGAUgASgJUgtkZXN0aW5hdGlvbhIbCglpc3N1ZWRfdG8YBiABKAlSCG'
    'lzc3VlZFRvEjcKBXN0YXRlGAcgASgOMiEuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLklzc3VlU3Rh'
    'dGVSBXN0YXRlEiAKDHVzZWRfY2FzZV9pZBgIIAEoCVIKdXNlZENhc2VJZBJQCgxyZXR1cm5fY2'
    '91bnQYCSADKAsyLS5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuSXNzdWUuUmV0dXJuQ291bnRFbnRy'
    'eVILcmV0dXJuQ291bnQSHwoLcmV0dXJuX25vdGUYCiABKAlSCnJldHVybk5vdGUSNwoJaXNzdW'
    'VkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIaXNzdWVkQXQSGwoJaXNz'
    'dWVkX2J5GAwgASgJUghpc3N1ZWRCeRI3CgljbG9zZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUghjbG9zZWRBdBIbCgljbG9zZWRfYnkYDiABKAlSCGNsb3NlZEJ5Gj4K'
    'EFJldHVybkNvdW50RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbH'
    'VlOgI4AQ==');

@$core.Deprecated('Use tracedSetDescriptor instead')
const TracedSet$json = {
  '1': 'TracedSet',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'set_code', '3': 2, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'set_version', '3': 3, '4': 1, '5': 5, '10': 'setVersion'},
    {'1': 'cycle_id', '3': 4, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'load_number', '3': 5, '4': 1, '5': 9, '10': 'loadNumber'},
    {'1': 'machine', '3': 6, '4': 1, '5': 9, '10': 'machine'},
    {'1': 'skipped_stages', '3': 7, '4': 3, '5': 9, '10': 'skippedStages'},
    {
      '1': 'sterilised_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sterilisedAt'
    },
    {
      '1': 'used_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'usedAt'
    },
  ],
};

/// Descriptor for `TracedSet`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tracedSetDescriptor = $convert.base64Decode(
    'CglUcmFjZWRTZXQSFQoGcnVuX2lkGAEgASgJUgVydW5JZBIZCghzZXRfY29kZRgCIAEoCVIHc2'
    'V0Q29kZRIfCgtzZXRfdmVyc2lvbhgDIAEoBVIKc2V0VmVyc2lvbhIZCghjeWNsZV9pZBgEIAEo'
    'CVIHY3ljbGVJZBIfCgtsb2FkX251bWJlchgFIAEoCVIKbG9hZE51bWJlchIYCgdtYWNoaW5lGA'
    'YgASgJUgdtYWNoaW5lEiUKDnNraXBwZWRfc3RhZ2VzGAcgAygJUg1za2lwcGVkU3RhZ2VzEj8K'
    'DXN0ZXJpbGlzZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxzdGVyaW'
    'xpc2VkQXQSMwoHdXNlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBnVz'
    'ZWRBdA==');

@$core.Deprecated('Use caseTraceDescriptor instead')
const CaseTrace$json = {
  '1': 'CaseTrace',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'sets',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.TracedSet',
      '10': 'sets'
    },
    {'1': 'incomplete', '3': 3, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `CaseTrace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List caseTraceDescriptor = $convert.base64Decode(
    'CglDYXNlVHJhY2USFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjQKBHNldHMYAiADKAsyIC5oZW'
    'FsdGhjYXJlLnN0ZXJpbGUudjEuVHJhY2VkU2V0UgRzZXRzEh4KCmluY29tcGxldGUYAyADKAlS'
    'CmluY29tcGxldGU=');

@$core.Deprecated('Use recalledPackDescriptor instead')
const RecalledPack$json = {
  '1': 'RecalledPack',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'set_code', '3': 2, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'state', '3': 3, '4': 1, '5': 9, '10': 'state'},
    {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
    {'1': 'used_case_id', '3': 5, '4': 1, '5': 9, '10': 'usedCaseId'},
  ],
};

/// Descriptor for `RecalledPack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recalledPackDescriptor = $convert.base64Decode(
    'CgxSZWNhbGxlZFBhY2sSFQoGcnVuX2lkGAEgASgJUgVydW5JZBIZCghzZXRfY29kZRgCIAEoCV'
    'IHc2V0Q29kZRIUCgVzdGF0ZRgDIAEoCVIFc3RhdGUSGgoIbG9jYXRpb24YBCABKAlSCGxvY2F0'
    'aW9uEiAKDHVzZWRfY2FzZV9pZBgFIAEoCVIKdXNlZENhc2VJZA==');

@$core.Deprecated('Use recallScopeDescriptor instead')
const RecallScope$json = {
  '1': 'RecallScope',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'load_number', '3': 2, '4': 1, '5': 9, '10': 'loadNumber'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'packs',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.RecalledPack',
      '10': 'packs'
    },
    {'1': 'cases', '3': 5, '4': 3, '5': 9, '10': 'cases'},
    {'1': 'locations', '3': 6, '4': 3, '5': 9, '10': 'locations'},
  ],
};

/// Descriptor for `RecallScope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recallScopeDescriptor = $convert.base64Decode(
    'CgtSZWNhbGxTY29wZRIZCghjeWNsZV9pZBgBIAEoCVIHY3ljbGVJZBIfCgtsb2FkX251bWJlch'
    'gCIAEoCVIKbG9hZE51bWJlchIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhI5CgVwYWNrcxgEIAMo'
    'CzIjLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5SZWNhbGxlZFBhY2tSBXBhY2tzEhQKBWNhc2VzGA'
    'UgAygJUgVjYXNlcxIcCglsb2NhdGlvbnMYBiADKAlSCWxvY2F0aW9ucw==');

@$core.Deprecated('Use recallDescriptor instead')
const Recall$json = {
  '1': 'Recall',
  '2': [
    {'1': 'recall_id', '3': 1, '4': 1, '5': 9, '10': 'recallId'},
    {'1': 'cycle_id', '3': 2, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'packs_affected', '3': 4, '4': 1, '5': 5, '10': 'packsAffected'},
    {'1': 'cases_affected', '3': 5, '4': 1, '5': 5, '10': 'casesAffected'},
    {
      '1': 'raised_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 7, '4': 1, '5': 9, '10': 'raisedBy'},
    {
      '1': 'closed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 9, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closing_note', '3': 10, '4': 1, '5': 9, '10': 'closingNote'},
  ],
};

/// Descriptor for `Recall`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recallDescriptor = $convert.base64Decode(
    'CgZSZWNhbGwSGwoJcmVjYWxsX2lkGAEgASgJUghyZWNhbGxJZBIZCghjeWNsZV9pZBgCIAEoCV'
    'IHY3ljbGVJZBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhIlCg5wYWNrc19hZmZlY3RlZBgEIAEo'
    'BVINcGFja3NBZmZlY3RlZBIlCg5jYXNlc19hZmZlY3RlZBgFIAEoBVINY2FzZXNBZmZlY3RlZB'
    'I3CglyYWlzZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghyYWlzZWRB'
    'dBIbCglyYWlzZWRfYnkYByABKAlSCHJhaXNlZEJ5EjcKCWNsb3NlZF9hdBgIIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGNsb3NlZEF0EhsKCWNsb3NlZF9ieRgJIAEoCVIIY2xv'
    'c2VkQnkSIQoMY2xvc2luZ19ub3RlGAogASgJUgtjbG9zaW5nTm90ZQ==');

@$core.Deprecated('Use registerInstrumentRequestDescriptor instead')
const RegisterInstrumentRequest$json = {
  '1': 'RegisterInstrumentRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'serial_number', '3': 3, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'acquired_on',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acquiredOn'
    },
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RegisterInstrumentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerInstrumentRequestDescriptor = $convert.base64Decode(
    'ChlSZWdpc3Rlckluc3RydW1lbnRSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSGAoHZGlzcG'
    'xheRgCIAEoCVIHZGlzcGxheRIjCg1zZXJpYWxfbnVtYmVyGAMgASgJUgxzZXJpYWxOdW1iZXIS'
    'GgoIbG9jYXRpb24YBCABKAlSCGxvY2F0aW9uEjsKC2FjcXVpcmVkX29uGAUgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYWNxdWlyZWRPbhIUCgVub3RlcxgGIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use registerInstrumentResponseDescriptor instead')
const RegisterInstrumentResponse$json = {
  '1': 'RegisterInstrumentResponse',
  '2': [
    {
      '1': 'instrument',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Instrument',
      '10': 'instrument'
    },
  ],
};

/// Descriptor for `RegisterInstrumentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerInstrumentResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWdpc3Rlckluc3RydW1lbnRSZXNwb25zZRJBCgppbnN0cnVtZW50GAEgASgLMiEuaGVhbH'
        'RoY2FyZS5zdGVyaWxlLnYxLkluc3RydW1lbnRSCmluc3RydW1lbnQ=');

@$core.Deprecated('Use moveInstrumentRequestDescriptor instead')
const MoveInstrumentRequest$json = {
  '1': 'MoveInstrumentRequest',
  '2': [
    {'1': 'instrument_id', '3': 1, '4': 1, '5': 9, '10': 'instrumentId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.InstrumentStatus',
      '10': 'status'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `MoveInstrumentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveInstrumentRequestDescriptor = $convert.base64Decode(
    'ChVNb3ZlSW5zdHJ1bWVudFJlcXVlc3QSIwoNaW5zdHJ1bWVudF9pZBgBIAEoCVIMaW5zdHJ1bW'
    'VudElkEj8KBnN0YXR1cxgCIAEoDjInLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5JbnN0cnVtZW50'
    'U3RhdHVzUgZzdGF0dXMSEgoEbm90ZRgDIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use moveInstrumentResponseDescriptor instead')
const MoveInstrumentResponse$json = {
  '1': 'MoveInstrumentResponse',
  '2': [
    {
      '1': 'instrument',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Instrument',
      '10': 'instrument'
    },
  ],
};

/// Descriptor for `MoveInstrumentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveInstrumentResponseDescriptor =
    $convert.base64Decode(
        'ChZNb3ZlSW5zdHJ1bWVudFJlc3BvbnNlEkEKCmluc3RydW1lbnQYASABKAsyIS5oZWFsdGhjYX'
        'JlLnN0ZXJpbGUudjEuSW5zdHJ1bWVudFIKaW5zdHJ1bWVudA==');

@$core.Deprecated('Use listInstrumentsRequestDescriptor instead')
const ListInstrumentsRequest$json = {
  '1': 'ListInstrumentsRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'out_of_service_only',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'outOfServiceOnly'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListInstrumentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInstrumentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0SW5zdHJ1bWVudHNSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSLQoTb3V0X29mX3'
    'NlcnZpY2Vfb25seRgCIAEoCFIQb3V0T2ZTZXJ2aWNlT25seRIbCglwYWdlX3NpemUYAyABKAVS'
    'CHBhZ2VTaXpl');

@$core.Deprecated('Use listInstrumentsResponseDescriptor instead')
const ListInstrumentsResponse$json = {
  '1': 'ListInstrumentsResponse',
  '2': [
    {
      '1': 'instruments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Instrument',
      '10': 'instruments'
    },
  ],
};

/// Descriptor for `ListInstrumentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInstrumentsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0SW5zdHJ1bWVudHNSZXNwb25zZRJDCgtpbnN0cnVtZW50cxgBIAMoCzIhLmhlYWx0aG'
        'NhcmUuc3RlcmlsZS52MS5JbnN0cnVtZW50UgtpbnN0cnVtZW50cw==');

@$core.Deprecated('Use getInstrumentHistoryRequestDescriptor instead')
const GetInstrumentHistoryRequest$json = {
  '1': 'GetInstrumentHistoryRequest',
  '2': [
    {'1': 'instrument_id', '3': 1, '4': 1, '5': 9, '10': 'instrumentId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetInstrumentHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInstrumentHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRJbnN0cnVtZW50SGlzdG9yeVJlcXVlc3QSIwoNaW5zdHJ1bWVudF9pZBgBIAEoCVIMaW'
        '5zdHJ1bWVudElkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use getInstrumentHistoryResponseDescriptor instead')
const GetInstrumentHistoryResponse$json = {
  '1': 'GetInstrumentHistoryResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.InstrumentEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `GetInstrumentHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getInstrumentHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRJbnN0cnVtZW50SGlzdG9yeVJlc3BvbnNlEj4KBmV2ZW50cxgBIAMoCzImLmhlYWx0aG'
        'NhcmUuc3RlcmlsZS52MS5JbnN0cnVtZW50RXZlbnRSBmV2ZW50cw==');

@$core.Deprecated('Use listInstrumentMovesRequestDescriptor instead')
const ListInstrumentMovesRequest$json = {
  '1': 'ListInstrumentMovesRequest',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.InstrumentStatus',
      '10': 'status'
    },
    {
      '1': 'period_start',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodStart'
    },
    {
      '1': 'period_end',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodEnd'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListInstrumentMovesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInstrumentMovesRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0SW5zdHJ1bWVudE1vdmVzUmVxdWVzdBI/CgZzdGF0dXMYASABKA4yJy5oZWFsdGhjYX'
    'JlLnN0ZXJpbGUudjEuSW5zdHJ1bWVudFN0YXR1c1IGc3RhdHVzEj0KDHBlcmlvZF9zdGFydBgC'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3BlcmlvZFN0YXJ0EjkKCnBlcmlvZF'
    '9lbmQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglwZXJpb2RFbmQSGwoJcGFn'
    'ZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listInstrumentMovesResponseDescriptor instead')
const ListInstrumentMovesResponse$json = {
  '1': 'ListInstrumentMovesResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.InstrumentEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `ListInstrumentMovesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInstrumentMovesResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0SW5zdHJ1bWVudE1vdmVzUmVzcG9uc2USPgoGZXZlbnRzGAEgAygLMiYuaGVhbHRoY2'
        'FyZS5zdGVyaWxlLnYxLkluc3RydW1lbnRFdmVudFIGZXZlbnRz');

@$core.Deprecated('Use defineSetRequestDescriptor instead')
const DefineSetRequest$json = {
  '1': 'DefineSetRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {
      '1': 'items',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.PackingItem',
      '10': 'items'
    },
    {
      '1': 'shelf_life_seconds',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'shelfLifeSeconds'
    },
  ],
};

/// Descriptor for `DefineSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineSetRequestDescriptor = $convert.base64Decode(
    'ChBEZWZpbmVTZXRSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSGAoHZGlzcGxheRgCIAEoCV'
    'IHZGlzcGxheRISCgRraW5kGAMgASgJUgRraW5kEjgKBWl0ZW1zGAQgAygLMiIuaGVhbHRoY2Fy'
    'ZS5zdGVyaWxlLnYxLlBhY2tpbmdJdGVtUgVpdGVtcxIsChJzaGVsZl9saWZlX3NlY29uZHMYBS'
    'ABKANSEHNoZWxmTGlmZVNlY29uZHM=');

@$core.Deprecated('Use defineSetResponseDescriptor instead')
const DefineSetResponse$json = {
  '1': 'DefineSetResponse',
  '2': [
    {
      '1': 'set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.TraySet',
      '10': 'set'
    },
  ],
};

/// Descriptor for `DefineSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineSetResponseDescriptor = $convert.base64Decode(
    'ChFEZWZpbmVTZXRSZXNwb25zZRIwCgNzZXQYASABKAsyHi5oZWFsdGhjYXJlLnN0ZXJpbGUudj'
    'EuVHJheVNldFIDc2V0');

@$core.Deprecated('Use getSetRequestDescriptor instead')
const GetSetRequest$json = {
  '1': 'GetSetRequest',
  '2': [
    {'1': 'set_id', '3': 1, '4': 1, '5': 9, '10': 'setId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `GetSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSetRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRTZXRSZXF1ZXN0EhUKBnNldF9pZBgBIAEoCVIFc2V0SWQSEgoEY29kZRgCIAEoCVIEY2'
    '9kZQ==');

@$core.Deprecated('Use getSetResponseDescriptor instead')
const GetSetResponse$json = {
  '1': 'GetSetResponse',
  '2': [
    {
      '1': 'set',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.TraySet',
      '10': 'set'
    },
  ],
};

/// Descriptor for `GetSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSetResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRTZXRSZXNwb25zZRIwCgNzZXQYASABKAsyHi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuVH'
    'JheVNldFIDc2V0');

@$core.Deprecated('Use listSetVersionsRequestDescriptor instead')
const ListSetVersionsRequest$json = {
  '1': 'ListSetVersionsRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `ListSetVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSetVersionsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0U2V0VmVyc2lvbnNSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGU=');

@$core.Deprecated('Use listSetVersionsResponseDescriptor instead')
const ListSetVersionsResponse$json = {
  '1': 'ListSetVersionsResponse',
  '2': [
    {
      '1': 'versions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.TraySet',
      '10': 'versions'
    },
  ],
};

/// Descriptor for `ListSetVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSetVersionsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0U2V0VmVyc2lvbnNSZXNwb25zZRI6Cgh2ZXJzaW9ucxgBIAMoCzIeLmhlYWx0aGNhcm'
        'Uuc3RlcmlsZS52MS5UcmF5U2V0Ugh2ZXJzaW9ucw==');

@$core.Deprecated('Use listSetsRequestDescriptor instead')
const ListSetsRequest$json = {
  '1': 'ListSetsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListSetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSetsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0U2V0c1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listSetsResponseDescriptor instead')
const ListSetsResponse$json = {
  '1': 'ListSetsResponse',
  '2': [
    {
      '1': 'sets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.TraySet',
      '10': 'sets'
    },
  ],
};

/// Descriptor for `ListSetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSetsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0U2V0c1Jlc3BvbnNlEjIKBHNldHMYASADKAsyHi5oZWFsdGhjYXJlLnN0ZXJpbGUudj'
    'EuVHJheVNldFIEc2V0cw==');

@$core.Deprecated('Use receiveRequestDescriptor instead')
const ReceiveRequest$json = {
  '1': 'ReceiveRequest',
  '2': [
    {'1': 'set_code', '3': 1, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'source_unit', '3': 2, '4': 1, '5': 9, '10': 'sourceUnit'},
    {'1': 'source_case_id', '3': 3, '4': 1, '5': 9, '10': 'sourceCaseId'},
    {
      '1': 'counted',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.ReceiveRequest.CountedEntry',
      '10': 'counted'
    },
  ],
  '3': [ReceiveRequest_CountedEntry$json],
};

@$core.Deprecated('Use receiveRequestDescriptor instead')
const ReceiveRequest_CountedEntry$json = {
  '1': 'CountedEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ReceiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveRequestDescriptor = $convert.base64Decode(
    'Cg5SZWNlaXZlUmVxdWVzdBIZCghzZXRfY29kZRgBIAEoCVIHc2V0Q29kZRIfCgtzb3VyY2VfdW'
    '5pdBgCIAEoCVIKc291cmNlVW5pdBIkCg5zb3VyY2VfY2FzZV9pZBgDIAEoCVIMc291cmNlQ2Fz'
    'ZUlkEkwKB2NvdW50ZWQYBCADKAsyMi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUmVjZWl2ZVJlcX'
    'Vlc3QuQ291bnRlZEVudHJ5Ugdjb3VudGVkGjoKDENvdW50ZWRFbnRyeRIQCgNrZXkYASABKAlS'
    'A2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgB');

@$core.Deprecated('Use receiveResponseDescriptor instead')
const ReceiveResponse$json = {
  '1': 'ReceiveResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'run'
    },
    {'1': 'short', '3': 2, '4': 3, '5': 9, '10': 'short'},
  ],
};

/// Descriptor for `ReceiveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveResponseDescriptor = $convert.base64Decode(
    'Cg9SZWNlaXZlUmVzcG9uc2USLAoDcnVuGAEgASgLMhouaGVhbHRoY2FyZS5zdGVyaWxlLnYxLl'
    'J1blIDcnVuEhQKBXNob3J0GAIgAygJUgVzaG9ydA==');

@$core.Deprecated('Use advanceRequestDescriptor instead')
const AdvanceRequest$json = {
  '1': 'AdvanceRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'stage',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.Stage',
      '10': 'stage'
    },
    {'1': 'equipment', '3': 3, '4': 1, '5': 9, '10': 'equipment'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'skipped', '3': 5, '4': 1, '5': 8, '10': 'skipped'},
    {'1': 'skip_reason', '3': 6, '4': 1, '5': 9, '10': 'skipReason'},
  ],
};

/// Descriptor for `AdvanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceRequestDescriptor = $convert.base64Decode(
    'Cg5BZHZhbmNlUmVxdWVzdBIVCgZydW5faWQYASABKAlSBXJ1bklkEjIKBXN0YWdlGAIgASgOMh'
    'wuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLlN0YWdlUgVzdGFnZRIcCgllcXVpcG1lbnQYAyABKAlS'
    'CWVxdWlwbWVudBIUCgVub3RlcxgEIAEoCVIFbm90ZXMSGAoHc2tpcHBlZBgFIAEoCFIHc2tpcH'
    'BlZBIfCgtza2lwX3JlYXNvbhgGIAEoCVIKc2tpcFJlYXNvbg==');

@$core.Deprecated('Use advanceResponseDescriptor instead')
const AdvanceResponse$json = {
  '1': 'AdvanceResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.StageRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `AdvanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceResponseDescriptor = $convert.base64Decode(
    'Cg9BZHZhbmNlUmVzcG9uc2USOgoGcmVjb3JkGAEgASgLMiIuaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLlN0YWdlUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use assembleRequestDescriptor instead')
const AssembleRequest$json = {
  '1': 'AssembleRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {
      '1': 'packed',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.AssembleRequest.PackedEntry',
      '10': 'packed'
    },
    {'1': 'replaced', '3': 3, '4': 3, '5': 9, '10': 'replaced'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
  '3': [AssembleRequest_PackedEntry$json],
};

@$core.Deprecated('Use assembleRequestDescriptor instead')
const AssembleRequest_PackedEntry$json = {
  '1': 'PackedEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AssembleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assembleRequestDescriptor = $convert.base64Decode(
    'Cg9Bc3NlbWJsZVJlcXVlc3QSFQoGcnVuX2lkGAEgASgJUgVydW5JZBJKCgZwYWNrZWQYAiADKA'
    'syMi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuQXNzZW1ibGVSZXF1ZXN0LlBhY2tlZEVudHJ5UgZw'
    'YWNrZWQSGgoIcmVwbGFjZWQYAyADKAlSCHJlcGxhY2VkEhQKBW5vdGVzGAQgASgJUgVub3Rlcx'
    'o5CgtQYWNrZWRFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6'
    'AjgB');

@$core.Deprecated('Use assembleResponseDescriptor instead')
const AssembleResponse$json = {
  '1': 'AssembleResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.StageRecord',
      '10': 'record'
    },
    {'1': 'missing', '3': 2, '4': 3, '5': 9, '10': 'missing'},
  ],
};

/// Descriptor for `AssembleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assembleResponseDescriptor = $convert.base64Decode(
    'ChBBc3NlbWJsZVJlc3BvbnNlEjoKBnJlY29yZBgBIAEoCzIiLmhlYWx0aGNhcmUuc3RlcmlsZS'
    '52MS5TdGFnZVJlY29yZFIGcmVjb3JkEhgKB21pc3NpbmcYAiADKAlSB21pc3Npbmc=');

@$core.Deprecated('Use packageRequestDescriptor instead')
const PackageRequest$json = {
  '1': 'PackageRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
    {'1': 'indicator_type', '3': 3, '4': 1, '5': 9, '10': 'indicatorType'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `PackageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageRequestDescriptor = $convert.base64Decode(
    'Cg5QYWNrYWdlUmVxdWVzdBIVCgZydW5faWQYASABKAlSBXJ1bklkEhYKBm1ldGhvZBgCIAEoCV'
    'IGbWV0aG9kEiUKDmluZGljYXRvcl90eXBlGAMgASgJUg1pbmRpY2F0b3JUeXBlEhQKBW5vdGVz'
    'GAQgASgJUgVub3Rlcw==');

@$core.Deprecated('Use packageResponseDescriptor instead')
const PackageResponse$json = {
  '1': 'PackageResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.StageRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `PackageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List packageResponseDescriptor = $convert.base64Decode(
    'Cg9QYWNrYWdlUmVzcG9uc2USOgoGcmVjb3JkGAEgASgLMiIuaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLlN0YWdlUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use startCycleRequestDescriptor instead')
const StartCycleRequest$json = {
  '1': 'StartCycleRequest',
  '2': [
    {'1': 'machine', '3': 1, '4': 1, '5': 9, '10': 'machine'},
    {'1': 'load_number', '3': 2, '4': 1, '5': 9, '10': 'loadNumber'},
    {'1': 'program', '3': 3, '4': 1, '5': 9, '10': 'program'},
    {
      '1': 'parameters',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.StartCycleRequest.ParametersEntry',
      '10': 'parameters'
    },
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.CycleSource',
      '10': 'source'
    },
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
  '3': [StartCycleRequest_ParametersEntry$json],
};

@$core.Deprecated('Use startCycleRequestDescriptor instead')
const StartCycleRequest_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `StartCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCycleRequestDescriptor = $convert.base64Decode(
    'ChFTdGFydEN5Y2xlUmVxdWVzdBIYCgdtYWNoaW5lGAEgASgJUgdtYWNoaW5lEh8KC2xvYWRfbn'
    'VtYmVyGAIgASgJUgpsb2FkTnVtYmVyEhgKB3Byb2dyYW0YAyABKAlSB3Byb2dyYW0SWAoKcGFy'
    'YW1ldGVycxgEIAMoCzI4LmhlYWx0aGNhcmUuc3RlcmlsZS52MS5TdGFydEN5Y2xlUmVxdWVzdC'
    '5QYXJhbWV0ZXJzRW50cnlSCnBhcmFtZXRlcnMSOgoGc291cmNlGAUgASgOMiIuaGVhbHRoY2Fy'
    'ZS5zdGVyaWxlLnYxLkN5Y2xlU291cmNlUgZzb3VyY2USOQoKc3RhcnRlZF9hdBgGIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBo9Cg9QYXJhbWV0ZXJzRW50cnkS'
    'EAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use startCycleResponseDescriptor instead')
const StartCycleResponse$json = {
  '1': 'StartCycleResponse',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycle'
    },
  ],
};

/// Descriptor for `StartCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startCycleResponseDescriptor = $convert.base64Decode(
    'ChJTdGFydEN5Y2xlUmVzcG9uc2USMgoFY3ljbGUYASABKAsyHC5oZWFsdGhjYXJlLnN0ZXJpbG'
    'UudjEuQ3ljbGVSBWN5Y2xl');

@$core.Deprecated('Use loadCycleRequestDescriptor instead')
const LoadCycleRequest$json = {
  '1': 'LoadCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'run_ids', '3': 2, '4': 3, '5': 9, '10': 'runIds'},
  ],
};

/// Descriptor for `LoadCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadCycleRequestDescriptor = $convert.base64Decode(
    'ChBMb2FkQ3ljbGVSZXF1ZXN0EhkKCGN5Y2xlX2lkGAEgASgJUgdjeWNsZUlkEhcKB3J1bl9pZH'
    'MYAiADKAlSBnJ1bklkcw==');

@$core.Deprecated('Use loadCycleResponseDescriptor instead')
const LoadCycleResponse$json = {
  '1': 'LoadCycleResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `LoadCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadCycleResponseDescriptor = $convert.base64Decode(
    'ChFMb2FkQ3ljbGVSZXNwb25zZRIuCgRydW5zGAEgAygLMhouaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLlJ1blIEcnVucw==');

@$core.Deprecated('Use finishCycleRequestDescriptor instead')
const FinishCycleRequest$json = {
  '1': 'FinishCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {
      '1': 'result',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.CycleResult',
      '10': 'result'
    },
    {
      '1': 'parameters',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.FinishCycleRequest.ParametersEntry',
      '10': 'parameters'
    },
    {
      '1': 'ended_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
  '3': [FinishCycleRequest_ParametersEntry$json],
};

@$core.Deprecated('Use finishCycleRequestDescriptor instead')
const FinishCycleRequest_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `FinishCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishCycleRequestDescriptor = $convert.base64Decode(
    'ChJGaW5pc2hDeWNsZVJlcXVlc3QSGQoIY3ljbGVfaWQYASABKAlSB2N5Y2xlSWQSOgoGcmVzdW'
    'x0GAIgASgOMiIuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkN5Y2xlUmVzdWx0UgZyZXN1bHQSWQoK'
    'cGFyYW1ldGVycxgDIAMoCzI5LmhlYWx0aGNhcmUuc3RlcmlsZS52MS5GaW5pc2hDeWNsZVJlcX'
    'Vlc3QuUGFyYW1ldGVyc0VudHJ5UgpwYXJhbWV0ZXJzEjUKCGVuZGVkX2F0GAQgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBo9Cg9QYXJhbWV0ZXJzRW50cnkSEAoDa2'
    'V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use finishCycleResponseDescriptor instead')
const FinishCycleResponse$json = {
  '1': 'FinishCycleResponse',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycle'
    },
  ],
};

/// Descriptor for `FinishCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finishCycleResponseDescriptor = $convert.base64Decode(
    'ChNGaW5pc2hDeWNsZVJlc3BvbnNlEjIKBWN5Y2xlGAEgASgLMhwuaGVhbHRoY2FyZS5zdGVyaW'
    'xlLnYxLkN5Y2xlUgVjeWNsZQ==');

@$core.Deprecated('Use recordIndicatorRequestDescriptor instead')
const RecordIndicatorRequest$json = {
  '1': 'RecordIndicatorRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.sterile.v1.IndicatorKind',
      '10': 'kind'
    },
    {'1': 'lot', '3': 3, '4': 1, '5': 9, '10': 'lot'},
    {'1': 'passed', '3': 4, '4': 1, '5': 8, '10': 'passed'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RecordIndicatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordIndicatorRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvcmRJbmRpY2F0b3JSZXF1ZXN0EhkKCGN5Y2xlX2lkGAEgASgJUgdjeWNsZUlkEjgKBG'
    'tpbmQYAiABKA4yJC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuSW5kaWNhdG9yS2luZFIEa2luZBIQ'
    'CgNsb3QYAyABKAlSA2xvdBIWCgZwYXNzZWQYBCABKAhSBnBhc3NlZBIUCgVub3RlcxgFIAEoCV'
    'IFbm90ZXM=');

@$core.Deprecated('Use recordIndicatorResponseDescriptor instead')
const RecordIndicatorResponse$json = {
  '1': 'RecordIndicatorResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.IndicatorResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `RecordIndicatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordIndicatorResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvcmRJbmRpY2F0b3JSZXNwb25zZRI+CgZyZXN1bHQYASABKAsyJi5oZWFsdGhjYXJlLn'
        'N0ZXJpbGUudjEuSW5kaWNhdG9yUmVzdWx0UgZyZXN1bHQ=');

@$core.Deprecated('Use getReleaseDecisionRequestDescriptor instead')
const GetReleaseDecisionRequest$json = {
  '1': 'GetReleaseDecisionRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
  ],
};

/// Descriptor for `GetReleaseDecisionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseDecisionRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZWxlYXNlRGVjaXNpb25SZXF1ZXN0EhkKCGN5Y2xlX2lkGAEgASgJUgdjeWNsZUlk');

@$core.Deprecated('Use getReleaseDecisionResponseDescriptor instead')
const GetReleaseDecisionResponse$json = {
  '1': 'GetReleaseDecisionResponse',
  '2': [
    {
      '1': 'decision',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.ReleaseDecision',
      '10': 'decision'
    },
  ],
};

/// Descriptor for `GetReleaseDecisionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseDecisionResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRSZWxlYXNlRGVjaXNpb25SZXNwb25zZRJCCghkZWNpc2lvbhgBIAEoCzImLmhlYWx0aG'
        'NhcmUuc3RlcmlsZS52MS5SZWxlYXNlRGVjaXNpb25SCGRlY2lzaW9u');

@$core.Deprecated('Use releaseLoadRequestDescriptor instead')
const ReleaseLoadRequest$json = {
  '1': 'ReleaseLoadRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ReleaseLoadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseLoadRequestDescriptor = $convert.base64Decode(
    'ChJSZWxlYXNlTG9hZFJlcXVlc3QSGQoIY3ljbGVfaWQYASABKAlSB2N5Y2xlSWQSEgoEbm90ZR'
    'gCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use releaseLoadResponseDescriptor instead')
const ReleaseLoadResponse$json = {
  '1': 'ReleaseLoadResponse',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycle'
    },
    {
      '1': 'runs',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `ReleaseLoadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseLoadResponseDescriptor = $convert.base64Decode(
    'ChNSZWxlYXNlTG9hZFJlc3BvbnNlEjIKBWN5Y2xlGAEgASgLMhwuaGVhbHRoY2FyZS5zdGVyaW'
    'xlLnYxLkN5Y2xlUgVjeWNsZRIuCgRydW5zGAIgAygLMhouaGVhbHRoY2FyZS5zdGVyaWxlLnYx'
    'LlJ1blIEcnVucw==');

@$core.Deprecated('Use getCycleRequestDescriptor instead')
const GetCycleRequest$json = {
  '1': 'GetCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'machine', '3': 2, '4': 1, '5': 9, '10': 'machine'},
    {'1': 'load_number', '3': 3, '4': 1, '5': 9, '10': 'loadNumber'},
  ],
};

/// Descriptor for `GetCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCycleRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRDeWNsZVJlcXVlc3QSGQoIY3ljbGVfaWQYASABKAlSB2N5Y2xlSWQSGAoHbWFjaGluZR'
    'gCIAEoCVIHbWFjaGluZRIfCgtsb2FkX251bWJlchgDIAEoCVIKbG9hZE51bWJlcg==');

@$core.Deprecated('Use getCycleResponseDescriptor instead')
const GetCycleResponse$json = {
  '1': 'GetCycleResponse',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycle'
    },
  ],
};

/// Descriptor for `GetCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCycleResponseDescriptor = $convert.base64Decode(
    'ChBHZXRDeWNsZVJlc3BvbnNlEjIKBWN5Y2xlGAEgASgLMhwuaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLkN5Y2xlUgVjeWNsZQ==');

@$core.Deprecated('Use listCyclesAwaitingReleaseRequestDescriptor instead')
const ListCyclesAwaitingReleaseRequest$json = {
  '1': 'ListCyclesAwaitingReleaseRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCyclesAwaitingReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCyclesAwaitingReleaseRequestDescriptor =
    $convert.base64Decode(
        'CiBMaXN0Q3ljbGVzQXdhaXRpbmdSZWxlYXNlUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCH'
        'BhZ2VTaXpl');

@$core.Deprecated('Use listCyclesAwaitingReleaseResponseDescriptor instead')
const ListCyclesAwaitingReleaseResponse$json = {
  '1': 'ListCyclesAwaitingReleaseResponse',
  '2': [
    {
      '1': 'cycles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycles'
    },
  ],
};

/// Descriptor for `ListCyclesAwaitingReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCyclesAwaitingReleaseResponseDescriptor =
    $convert.base64Decode(
        'CiFMaXN0Q3ljbGVzQXdhaXRpbmdSZWxlYXNlUmVzcG9uc2USNAoGY3ljbGVzGAEgAygLMhwuaG'
        'VhbHRoY2FyZS5zdGVyaWxlLnYxLkN5Y2xlUgZjeWNsZXM=');

@$core.Deprecated('Use listLoadsClearedByLotRequestDescriptor instead')
const ListLoadsClearedByLotRequest$json = {
  '1': 'ListLoadsClearedByLotRequest',
  '2': [
    {'1': 'lot', '3': 1, '4': 1, '5': 9, '10': 'lot'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListLoadsClearedByLotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLoadsClearedByLotRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0TG9hZHNDbGVhcmVkQnlMb3RSZXF1ZXN0EhAKA2xvdBgBIAEoCVIDbG90EhsKCXBhZ2'
        'Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listLoadsClearedByLotResponseDescriptor instead')
const ListLoadsClearedByLotResponse$json = {
  '1': 'ListLoadsClearedByLotResponse',
  '2': [
    {
      '1': 'cycles',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Cycle',
      '10': 'cycles'
    },
  ],
};

/// Descriptor for `ListLoadsClearedByLotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLoadsClearedByLotResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0TG9hZHNDbGVhcmVkQnlMb3RSZXNwb25zZRI0CgZjeWNsZXMYASADKAsyHC5oZWFsdG'
        'hjYXJlLnN0ZXJpbGUudjEuQ3ljbGVSBmN5Y2xlcw==');

@$core.Deprecated('Use getRunRequestDescriptor instead')
const GetRunRequest$json = {
  '1': 'GetRunRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `GetRunRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunRequestDescriptor = $convert
    .base64Decode('Cg1HZXRSdW5SZXF1ZXN0EhUKBnJ1bl9pZBgBIAEoCVIFcnVuSWQ=');

@$core.Deprecated('Use getRunResponseDescriptor instead')
const GetRunResponse$json = {
  '1': 'GetRunResponse',
  '2': [
    {
      '1': 'run',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'run'
    },
  ],
};

/// Descriptor for `GetRunResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRunResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRSdW5SZXNwb25zZRIsCgNydW4YASABKAsyGi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUn'
    'VuUgNydW4=');

@$core.Deprecated('Use getBoardRequestDescriptor instead')
const GetBoardRequest$json = {
  '1': 'GetBoardRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCb2FyZFJlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getBoardResponseDescriptor instead')
const GetBoardResponse$json = {
  '1': 'GetBoardResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `GetBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCb2FyZFJlc3BvbnNlEi4KBHJ1bnMYASADKAsyGi5oZWFsdGhjYXJlLnN0ZXJpbGUudj'
    'EuUnVuUgRydW5z');

@$core.Deprecated('Use getShelfRequestDescriptor instead')
const GetShelfRequest$json = {
  '1': 'GetShelfRequest',
  '2': [
    {'1': 'set_code', '3': 1, '4': 1, '5': 9, '10': 'setCode'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetShelfRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShelfRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTaGVsZlJlcXVlc3QSGQoIc2V0X2NvZGUYASABKAlSB3NldENvZGUSGwoJcGFnZV9zaX'
    'plGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getShelfResponseDescriptor instead')
const GetShelfResponse$json = {
  '1': 'GetShelfResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `GetShelfResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShelfResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTaGVsZlJlc3BvbnNlEi4KBHJ1bnMYASADKAsyGi5oZWFsdGhjYXJlLnN0ZXJpbGUudj'
    'EuUnVuUgRydW5z');

@$core.Deprecated('Use listExpiredPacksRequestDescriptor instead')
const ListExpiredPacksRequest$json = {
  '1': 'ListExpiredPacksRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListExpiredPacksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExpiredPacksRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0RXhwaXJlZFBhY2tzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listExpiredPacksResponseDescriptor instead')
const ListExpiredPacksResponse$json = {
  '1': 'ListExpiredPacksResponse',
  '2': [
    {
      '1': 'runs',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Run',
      '10': 'runs'
    },
  ],
};

/// Descriptor for `ListExpiredPacksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExpiredPacksResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0RXhwaXJlZFBhY2tzUmVzcG9uc2USLgoEcnVucxgBIAMoCzIaLmhlYWx0aGNhcmUuc3'
        'RlcmlsZS52MS5SdW5SBHJ1bnM=');

@$core.Deprecated('Use listExceptionsRequestDescriptor instead')
const ListExceptionsRequest$json = {
  '1': 'ListExceptionsRequest',
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
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListExceptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExceptionsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RXhjZXB0aW9uc1JlcXVlc3QSPQoMcGVyaW9kX3N0YXJ0GAEgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFILcGVyaW9kU3RhcnQSOQoKcGVyaW9kX2VuZBgCIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXBlcmlvZEVuZBIbCglwYWdlX3NpemUYAyABKAVSCH'
    'BhZ2VTaXpl');

@$core.Deprecated('Use listExceptionsResponseDescriptor instead')
const ListExceptionsResponse$json = {
  '1': 'ListExceptionsResponse',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.StageRecord',
      '10': 'records'
    },
  ],
};

/// Descriptor for `ListExceptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExceptionsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RXhjZXB0aW9uc1Jlc3BvbnNlEjwKB3JlY29yZHMYASADKAsyIi5oZWFsdGhjYXJlLn'
        'N0ZXJpbGUudjEuU3RhZ2VSZWNvcmRSB3JlY29yZHM=');

@$core.Deprecated('Use getLabelRequestDescriptor instead')
const GetLabelRequest$json = {
  '1': 'GetLabelRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
  ],
};

/// Descriptor for `GetLabelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLabelRequestDescriptor = $convert
    .base64Decode('Cg9HZXRMYWJlbFJlcXVlc3QSFQoGcnVuX2lkGAEgASgJUgVydW5JZA==');

@$core.Deprecated('Use getLabelResponseDescriptor instead')
const GetLabelResponse$json = {
  '1': 'GetLabelResponse',
  '2': [
    {
      '1': 'label',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Label',
      '10': 'label'
    },
  ],
};

/// Descriptor for `GetLabelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLabelResponseDescriptor = $convert.base64Decode(
    'ChBHZXRMYWJlbFJlc3BvbnNlEjIKBWxhYmVsGAEgASgLMhwuaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLkxhYmVsUgVsYWJlbA==');

@$core.Deprecated('Use issuePackRequestDescriptor instead')
const IssuePackRequest$json = {
  '1': 'IssuePackRequest',
  '2': [
    {'1': 'run_id', '3': 1, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'destination', '3': 2, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'issued_to', '3': 3, '4': 1, '5': 9, '10': 'issuedTo'},
  ],
};

/// Descriptor for `IssuePackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issuePackRequestDescriptor = $convert.base64Decode(
    'ChBJc3N1ZVBhY2tSZXF1ZXN0EhUKBnJ1bl9pZBgBIAEoCVIFcnVuSWQSIAoLZGVzdGluYXRpb2'
    '4YAiABKAlSC2Rlc3RpbmF0aW9uEhsKCWlzc3VlZF90bxgDIAEoCVIIaXNzdWVkVG8=');

@$core.Deprecated('Use issuePackResponseDescriptor instead')
const IssuePackResponse$json = {
  '1': 'IssuePackResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Issue',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `IssuePackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issuePackResponseDescriptor = $convert.base64Decode(
    'ChFJc3N1ZVBhY2tSZXNwb25zZRIyCgVpc3N1ZRgBIAEoCzIcLmhlYWx0aGNhcmUuc3RlcmlsZS'
    '52MS5Jc3N1ZVIFaXNzdWU=');

@$core.Deprecated('Use markUsedRequestDescriptor instead')
const MarkUsedRequest$json = {
  '1': 'MarkUsedRequest',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `MarkUsedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markUsedRequestDescriptor = $convert.base64Decode(
    'Cg9NYXJrVXNlZFJlcXVlc3QSGQoIaXNzdWVfaWQYASABKAlSB2lzc3VlSWQSFwoHY2FzZV9pZB'
    'gCIAEoCVIGY2FzZUlk');

@$core.Deprecated('Use markUsedResponseDescriptor instead')
const MarkUsedResponse$json = {
  '1': 'MarkUsedResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Issue',
      '10': 'issue'
    },
  ],
};

/// Descriptor for `MarkUsedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markUsedResponseDescriptor = $convert.base64Decode(
    'ChBNYXJrVXNlZFJlc3BvbnNlEjIKBWlzc3VlGAEgASgLMhwuaGVhbHRoY2FyZS5zdGVyaWxlLn'
    'YxLklzc3VlUgVpc3N1ZQ==');

@$core.Deprecated('Use returnPackRequestDescriptor instead')
const ReturnPackRequest$json = {
  '1': 'ReturnPackRequest',
  '2': [
    {'1': 'issue_id', '3': 1, '4': 1, '5': 9, '10': 'issueId'},
    {
      '1': 'counted',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.ReturnPackRequest.CountedEntry',
      '10': 'counted'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
  '3': [ReturnPackRequest_CountedEntry$json],
};

@$core.Deprecated('Use returnPackRequestDescriptor instead')
const ReturnPackRequest_CountedEntry$json = {
  '1': 'CountedEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ReturnPackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnPackRequestDescriptor = $convert.base64Decode(
    'ChFSZXR1cm5QYWNrUmVxdWVzdBIZCghpc3N1ZV9pZBgBIAEoCVIHaXNzdWVJZBJPCgdjb3VudG'
    'VkGAIgAygLMjUuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLlJldHVyblBhY2tSZXF1ZXN0LkNvdW50'
    'ZWRFbnRyeVIHY291bnRlZBISCgRub3RlGAMgASgJUgRub3RlGjoKDENvdW50ZWRFbnRyeRIQCg'
    'NrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgB');

@$core.Deprecated('Use returnPackResponseDescriptor instead')
const ReturnPackResponse$json = {
  '1': 'ReturnPackResponse',
  '2': [
    {
      '1': 'issue',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Issue',
      '10': 'issue'
    },
    {'1': 'short', '3': 2, '4': 3, '5': 9, '10': 'short'},
  ],
};

/// Descriptor for `ReturnPackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List returnPackResponseDescriptor = $convert.base64Decode(
    'ChJSZXR1cm5QYWNrUmVzcG9uc2USMgoFaXNzdWUYASABKAsyHC5oZWFsdGhjYXJlLnN0ZXJpbG'
    'UudjEuSXNzdWVSBWlzc3VlEhQKBXNob3J0GAIgAygJUgVzaG9ydA==');

@$core.Deprecated('Use listOutstandingRequestDescriptor instead')
const ListOutstandingRequest$json = {
  '1': 'ListOutstandingRequest',
  '2': [
    {'1': 'destination', '3': 1, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOutstandingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0T3V0c3RhbmRpbmdSZXF1ZXN0EiAKC2Rlc3RpbmF0aW9uGAEgASgJUgtkZXN0aW5hdG'
        'lvbhIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listOutstandingResponseDescriptor instead')
const ListOutstandingResponse$json = {
  '1': 'ListOutstandingResponse',
  '2': [
    {
      '1': 'issues',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Issue',
      '10': 'issues'
    },
  ],
};

/// Descriptor for `ListOutstandingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0T3V0c3RhbmRpbmdSZXNwb25zZRI0CgZpc3N1ZXMYASADKAsyHC5oZWFsdGhjYXJlLn'
        'N0ZXJpbGUudjEuSXNzdWVSBmlzc3Vlcw==');

@$core.Deprecated('Use traceCaseRequestDescriptor instead')
const TraceCaseRequest$json = {
  '1': 'TraceCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `TraceCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceCaseRequestDescriptor = $convert.base64Decode(
    'ChBUcmFjZUNhc2VSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZA==');

@$core.Deprecated('Use traceCaseResponseDescriptor instead')
const TraceCaseResponse$json = {
  '1': 'TraceCaseResponse',
  '2': [
    {
      '1': 'trace',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.CaseTrace',
      '10': 'trace'
    },
  ],
};

/// Descriptor for `TraceCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceCaseResponseDescriptor = $convert.base64Decode(
    'ChFUcmFjZUNhc2VSZXNwb25zZRI2CgV0cmFjZRgBIAEoCzIgLmhlYWx0aGNhcmUuc3RlcmlsZS'
    '52MS5DYXNlVHJhY2VSBXRyYWNl');

@$core.Deprecated('Use getRecallScopeRequestDescriptor instead')
const GetRecallScopeRequest$json = {
  '1': 'GetRecallScopeRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
  ],
};

/// Descriptor for `GetRecallScopeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecallScopeRequestDescriptor =
    $convert.base64Decode(
        'ChVHZXRSZWNhbGxTY29wZVJlcXVlc3QSGQoIY3ljbGVfaWQYASABKAlSB2N5Y2xlSWQ=');

@$core.Deprecated('Use getRecallScopeResponseDescriptor instead')
const GetRecallScopeResponse$json = {
  '1': 'GetRecallScopeResponse',
  '2': [
    {
      '1': 'scope',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.RecallScope',
      '10': 'scope'
    },
  ],
};

/// Descriptor for `GetRecallScopeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecallScopeResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRSZWNhbGxTY29wZVJlc3BvbnNlEjgKBXNjb3BlGAEgASgLMiIuaGVhbHRoY2FyZS5zdG'
        'VyaWxlLnYxLlJlY2FsbFNjb3BlUgVzY29wZQ==');

@$core.Deprecated('Use raiseRecallRequestDescriptor instead')
const RaiseRecallRequest$json = {
  '1': 'RaiseRecallRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RaiseRecallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRecallRequestDescriptor = $convert.base64Decode(
    'ChJSYWlzZVJlY2FsbFJlcXVlc3QSGQoIY3ljbGVfaWQYASABKAlSB2N5Y2xlSWQSFgoGcmVhc2'
    '9uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use raiseRecallResponseDescriptor instead')
const RaiseRecallResponse$json = {
  '1': 'RaiseRecallResponse',
  '2': [
    {
      '1': 'recall',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.Recall',
      '10': 'recall'
    },
    {
      '1': 'scope',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.sterile.v1.RecallScope',
      '10': 'scope'
    },
  ],
};

/// Descriptor for `RaiseRecallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseRecallResponseDescriptor = $convert.base64Decode(
    'ChNSYWlzZVJlY2FsbFJlc3BvbnNlEjUKBnJlY2FsbBgBIAEoCzIdLmhlYWx0aGNhcmUuc3Rlcm'
    'lsZS52MS5SZWNhbGxSBnJlY2FsbBI4CgVzY29wZRgCIAEoCzIiLmhlYWx0aGNhcmUuc3Rlcmls'
    'ZS52MS5SZWNhbGxTY29wZVIFc2NvcGU=');

@$core.Deprecated('Use closeRecallRequestDescriptor instead')
const CloseRecallRequest$json = {
  '1': 'CloseRecallRequest',
  '2': [
    {'1': 'recall_id', '3': 1, '4': 1, '5': 9, '10': 'recallId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CloseRecallRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeRecallRequestDescriptor = $convert.base64Decode(
    'ChJDbG9zZVJlY2FsbFJlcXVlc3QSGwoJcmVjYWxsX2lkGAEgASgJUghyZWNhbGxJZBISCgRub3'
    'RlGAIgASgJUgRub3Rl');

@$core.Deprecated('Use closeRecallResponseDescriptor instead')
const CloseRecallResponse$json = {
  '1': 'CloseRecallResponse',
};

/// Descriptor for `CloseRecallResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeRecallResponseDescriptor =
    $convert.base64Decode('ChNDbG9zZVJlY2FsbFJlc3BvbnNl');

@$core.Deprecated('Use listOpenRecallsRequestDescriptor instead')
const ListOpenRecallsRequest$json = {
  '1': 'ListOpenRecallsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOpenRecallsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenRecallsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0T3BlblJlY2FsbHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listOpenRecallsResponseDescriptor instead')
const ListOpenRecallsResponse$json = {
  '1': 'ListOpenRecallsResponse',
  '2': [
    {
      '1': 'recalls',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.sterile.v1.Recall',
      '10': 'recalls'
    },
  ],
};

/// Descriptor for `ListOpenRecallsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenRecallsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0T3BlblJlY2FsbHNSZXNwb25zZRI3CgdyZWNhbGxzGAEgAygLMh0uaGVhbHRoY2FyZS'
        '5zdGVyaWxlLnYxLlJlY2FsbFIHcmVjYWxscw==');

const $core.Map<$core.String, $core.dynamic> SterileServicesServiceBase$json = {
  '1': 'SterileServicesService',
  '2': [
    {
      '1': 'RegisterInstrument',
      '2': '.healthcare.sterile.v1.RegisterInstrumentRequest',
      '3': '.healthcare.sterile.v1.RegisterInstrumentResponse'
    },
    {
      '1': 'MoveInstrument',
      '2': '.healthcare.sterile.v1.MoveInstrumentRequest',
      '3': '.healthcare.sterile.v1.MoveInstrumentResponse'
    },
    {
      '1': 'ListInstruments',
      '2': '.healthcare.sterile.v1.ListInstrumentsRequest',
      '3': '.healthcare.sterile.v1.ListInstrumentsResponse'
    },
    {
      '1': 'GetInstrumentHistory',
      '2': '.healthcare.sterile.v1.GetInstrumentHistoryRequest',
      '3': '.healthcare.sterile.v1.GetInstrumentHistoryResponse'
    },
    {
      '1': 'ListInstrumentMoves',
      '2': '.healthcare.sterile.v1.ListInstrumentMovesRequest',
      '3': '.healthcare.sterile.v1.ListInstrumentMovesResponse'
    },
    {
      '1': 'DefineSet',
      '2': '.healthcare.sterile.v1.DefineSetRequest',
      '3': '.healthcare.sterile.v1.DefineSetResponse'
    },
    {
      '1': 'GetSet',
      '2': '.healthcare.sterile.v1.GetSetRequest',
      '3': '.healthcare.sterile.v1.GetSetResponse'
    },
    {
      '1': 'ListSetVersions',
      '2': '.healthcare.sterile.v1.ListSetVersionsRequest',
      '3': '.healthcare.sterile.v1.ListSetVersionsResponse'
    },
    {
      '1': 'ListSets',
      '2': '.healthcare.sterile.v1.ListSetsRequest',
      '3': '.healthcare.sterile.v1.ListSetsResponse'
    },
    {
      '1': 'Receive',
      '2': '.healthcare.sterile.v1.ReceiveRequest',
      '3': '.healthcare.sterile.v1.ReceiveResponse'
    },
    {
      '1': 'Advance',
      '2': '.healthcare.sterile.v1.AdvanceRequest',
      '3': '.healthcare.sterile.v1.AdvanceResponse'
    },
    {
      '1': 'Assemble',
      '2': '.healthcare.sterile.v1.AssembleRequest',
      '3': '.healthcare.sterile.v1.AssembleResponse'
    },
    {
      '1': 'Package',
      '2': '.healthcare.sterile.v1.PackageRequest',
      '3': '.healthcare.sterile.v1.PackageResponse'
    },
    {
      '1': 'StartCycle',
      '2': '.healthcare.sterile.v1.StartCycleRequest',
      '3': '.healthcare.sterile.v1.StartCycleResponse'
    },
    {
      '1': 'LoadCycle',
      '2': '.healthcare.sterile.v1.LoadCycleRequest',
      '3': '.healthcare.sterile.v1.LoadCycleResponse'
    },
    {
      '1': 'FinishCycle',
      '2': '.healthcare.sterile.v1.FinishCycleRequest',
      '3': '.healthcare.sterile.v1.FinishCycleResponse'
    },
    {
      '1': 'RecordIndicator',
      '2': '.healthcare.sterile.v1.RecordIndicatorRequest',
      '3': '.healthcare.sterile.v1.RecordIndicatorResponse'
    },
    {
      '1': 'GetReleaseDecision',
      '2': '.healthcare.sterile.v1.GetReleaseDecisionRequest',
      '3': '.healthcare.sterile.v1.GetReleaseDecisionResponse'
    },
    {
      '1': 'ReleaseLoad',
      '2': '.healthcare.sterile.v1.ReleaseLoadRequest',
      '3': '.healthcare.sterile.v1.ReleaseLoadResponse'
    },
    {
      '1': 'GetCycle',
      '2': '.healthcare.sterile.v1.GetCycleRequest',
      '3': '.healthcare.sterile.v1.GetCycleResponse'
    },
    {
      '1': 'ListCyclesAwaitingRelease',
      '2': '.healthcare.sterile.v1.ListCyclesAwaitingReleaseRequest',
      '3': '.healthcare.sterile.v1.ListCyclesAwaitingReleaseResponse'
    },
    {
      '1': 'ListLoadsClearedByLot',
      '2': '.healthcare.sterile.v1.ListLoadsClearedByLotRequest',
      '3': '.healthcare.sterile.v1.ListLoadsClearedByLotResponse'
    },
    {
      '1': 'GetRun',
      '2': '.healthcare.sterile.v1.GetRunRequest',
      '3': '.healthcare.sterile.v1.GetRunResponse'
    },
    {
      '1': 'GetBoard',
      '2': '.healthcare.sterile.v1.GetBoardRequest',
      '3': '.healthcare.sterile.v1.GetBoardResponse'
    },
    {
      '1': 'GetShelf',
      '2': '.healthcare.sterile.v1.GetShelfRequest',
      '3': '.healthcare.sterile.v1.GetShelfResponse'
    },
    {
      '1': 'ListExpiredPacks',
      '2': '.healthcare.sterile.v1.ListExpiredPacksRequest',
      '3': '.healthcare.sterile.v1.ListExpiredPacksResponse'
    },
    {
      '1': 'ListExceptions',
      '2': '.healthcare.sterile.v1.ListExceptionsRequest',
      '3': '.healthcare.sterile.v1.ListExceptionsResponse'
    },
    {
      '1': 'GetLabel',
      '2': '.healthcare.sterile.v1.GetLabelRequest',
      '3': '.healthcare.sterile.v1.GetLabelResponse'
    },
    {
      '1': 'IssuePack',
      '2': '.healthcare.sterile.v1.IssuePackRequest',
      '3': '.healthcare.sterile.v1.IssuePackResponse'
    },
    {
      '1': 'MarkUsed',
      '2': '.healthcare.sterile.v1.MarkUsedRequest',
      '3': '.healthcare.sterile.v1.MarkUsedResponse'
    },
    {
      '1': 'ReturnPack',
      '2': '.healthcare.sterile.v1.ReturnPackRequest',
      '3': '.healthcare.sterile.v1.ReturnPackResponse'
    },
    {
      '1': 'ListOutstanding',
      '2': '.healthcare.sterile.v1.ListOutstandingRequest',
      '3': '.healthcare.sterile.v1.ListOutstandingResponse'
    },
    {
      '1': 'TraceCase',
      '2': '.healthcare.sterile.v1.TraceCaseRequest',
      '3': '.healthcare.sterile.v1.TraceCaseResponse'
    },
    {
      '1': 'GetRecallScope',
      '2': '.healthcare.sterile.v1.GetRecallScopeRequest',
      '3': '.healthcare.sterile.v1.GetRecallScopeResponse'
    },
    {
      '1': 'RaiseRecall',
      '2': '.healthcare.sterile.v1.RaiseRecallRequest',
      '3': '.healthcare.sterile.v1.RaiseRecallResponse'
    },
    {
      '1': 'CloseRecall',
      '2': '.healthcare.sterile.v1.CloseRecallRequest',
      '3': '.healthcare.sterile.v1.CloseRecallResponse'
    },
    {
      '1': 'ListOpenRecalls',
      '2': '.healthcare.sterile.v1.ListOpenRecallsRequest',
      '3': '.healthcare.sterile.v1.ListOpenRecallsResponse'
    },
  ],
};

@$core.Deprecated('Use sterileServicesServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SterileServicesServiceBase$messageJson = {
  '.healthcare.sterile.v1.RegisterInstrumentRequest':
      RegisterInstrumentRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.sterile.v1.RegisterInstrumentResponse':
      RegisterInstrumentResponse$json,
  '.healthcare.sterile.v1.Instrument': Instrument$json,
  '.healthcare.sterile.v1.MoveInstrumentRequest': MoveInstrumentRequest$json,
  '.healthcare.sterile.v1.MoveInstrumentResponse': MoveInstrumentResponse$json,
  '.healthcare.sterile.v1.ListInstrumentsRequest': ListInstrumentsRequest$json,
  '.healthcare.sterile.v1.ListInstrumentsResponse':
      ListInstrumentsResponse$json,
  '.healthcare.sterile.v1.GetInstrumentHistoryRequest':
      GetInstrumentHistoryRequest$json,
  '.healthcare.sterile.v1.GetInstrumentHistoryResponse':
      GetInstrumentHistoryResponse$json,
  '.healthcare.sterile.v1.InstrumentEvent': InstrumentEvent$json,
  '.healthcare.sterile.v1.ListInstrumentMovesRequest':
      ListInstrumentMovesRequest$json,
  '.healthcare.sterile.v1.ListInstrumentMovesResponse':
      ListInstrumentMovesResponse$json,
  '.healthcare.sterile.v1.DefineSetRequest': DefineSetRequest$json,
  '.healthcare.sterile.v1.PackingItem': PackingItem$json,
  '.healthcare.sterile.v1.DefineSetResponse': DefineSetResponse$json,
  '.healthcare.sterile.v1.TraySet': TraySet$json,
  '.healthcare.sterile.v1.GetSetRequest': GetSetRequest$json,
  '.healthcare.sterile.v1.GetSetResponse': GetSetResponse$json,
  '.healthcare.sterile.v1.ListSetVersionsRequest': ListSetVersionsRequest$json,
  '.healthcare.sterile.v1.ListSetVersionsResponse':
      ListSetVersionsResponse$json,
  '.healthcare.sterile.v1.ListSetsRequest': ListSetsRequest$json,
  '.healthcare.sterile.v1.ListSetsResponse': ListSetsResponse$json,
  '.healthcare.sterile.v1.ReceiveRequest': ReceiveRequest$json,
  '.healthcare.sterile.v1.ReceiveRequest.CountedEntry':
      ReceiveRequest_CountedEntry$json,
  '.healthcare.sterile.v1.ReceiveResponse': ReceiveResponse$json,
  '.healthcare.sterile.v1.Run': Run$json,
  '.healthcare.sterile.v1.StageRecord': StageRecord$json,
  '.healthcare.sterile.v1.Run.ReceivedCountEntry': Run_ReceivedCountEntry$json,
  '.healthcare.sterile.v1.Run.PackedCountEntry': Run_PackedCountEntry$json,
  '.healthcare.sterile.v1.AdvanceRequest': AdvanceRequest$json,
  '.healthcare.sterile.v1.AdvanceResponse': AdvanceResponse$json,
  '.healthcare.sterile.v1.AssembleRequest': AssembleRequest$json,
  '.healthcare.sterile.v1.AssembleRequest.PackedEntry':
      AssembleRequest_PackedEntry$json,
  '.healthcare.sterile.v1.AssembleResponse': AssembleResponse$json,
  '.healthcare.sterile.v1.PackageRequest': PackageRequest$json,
  '.healthcare.sterile.v1.PackageResponse': PackageResponse$json,
  '.healthcare.sterile.v1.StartCycleRequest': StartCycleRequest$json,
  '.healthcare.sterile.v1.StartCycleRequest.ParametersEntry':
      StartCycleRequest_ParametersEntry$json,
  '.healthcare.sterile.v1.StartCycleResponse': StartCycleResponse$json,
  '.healthcare.sterile.v1.Cycle': Cycle$json,
  '.healthcare.sterile.v1.Cycle.ParametersEntry': Cycle_ParametersEntry$json,
  '.healthcare.sterile.v1.IndicatorResult': IndicatorResult$json,
  '.healthcare.sterile.v1.LoadCycleRequest': LoadCycleRequest$json,
  '.healthcare.sterile.v1.LoadCycleResponse': LoadCycleResponse$json,
  '.healthcare.sterile.v1.FinishCycleRequest': FinishCycleRequest$json,
  '.healthcare.sterile.v1.FinishCycleRequest.ParametersEntry':
      FinishCycleRequest_ParametersEntry$json,
  '.healthcare.sterile.v1.FinishCycleResponse': FinishCycleResponse$json,
  '.healthcare.sterile.v1.RecordIndicatorRequest': RecordIndicatorRequest$json,
  '.healthcare.sterile.v1.RecordIndicatorResponse':
      RecordIndicatorResponse$json,
  '.healthcare.sterile.v1.GetReleaseDecisionRequest':
      GetReleaseDecisionRequest$json,
  '.healthcare.sterile.v1.GetReleaseDecisionResponse':
      GetReleaseDecisionResponse$json,
  '.healthcare.sterile.v1.ReleaseDecision': ReleaseDecision$json,
  '.healthcare.sterile.v1.ReleaseLoadRequest': ReleaseLoadRequest$json,
  '.healthcare.sterile.v1.ReleaseLoadResponse': ReleaseLoadResponse$json,
  '.healthcare.sterile.v1.GetCycleRequest': GetCycleRequest$json,
  '.healthcare.sterile.v1.GetCycleResponse': GetCycleResponse$json,
  '.healthcare.sterile.v1.ListCyclesAwaitingReleaseRequest':
      ListCyclesAwaitingReleaseRequest$json,
  '.healthcare.sterile.v1.ListCyclesAwaitingReleaseResponse':
      ListCyclesAwaitingReleaseResponse$json,
  '.healthcare.sterile.v1.ListLoadsClearedByLotRequest':
      ListLoadsClearedByLotRequest$json,
  '.healthcare.sterile.v1.ListLoadsClearedByLotResponse':
      ListLoadsClearedByLotResponse$json,
  '.healthcare.sterile.v1.GetRunRequest': GetRunRequest$json,
  '.healthcare.sterile.v1.GetRunResponse': GetRunResponse$json,
  '.healthcare.sterile.v1.GetBoardRequest': GetBoardRequest$json,
  '.healthcare.sterile.v1.GetBoardResponse': GetBoardResponse$json,
  '.healthcare.sterile.v1.GetShelfRequest': GetShelfRequest$json,
  '.healthcare.sterile.v1.GetShelfResponse': GetShelfResponse$json,
  '.healthcare.sterile.v1.ListExpiredPacksRequest':
      ListExpiredPacksRequest$json,
  '.healthcare.sterile.v1.ListExpiredPacksResponse':
      ListExpiredPacksResponse$json,
  '.healthcare.sterile.v1.ListExceptionsRequest': ListExceptionsRequest$json,
  '.healthcare.sterile.v1.ListExceptionsResponse': ListExceptionsResponse$json,
  '.healthcare.sterile.v1.GetLabelRequest': GetLabelRequest$json,
  '.healthcare.sterile.v1.GetLabelResponse': GetLabelResponse$json,
  '.healthcare.sterile.v1.Label': Label$json,
  '.healthcare.sterile.v1.IssuePackRequest': IssuePackRequest$json,
  '.healthcare.sterile.v1.IssuePackResponse': IssuePackResponse$json,
  '.healthcare.sterile.v1.Issue': Issue$json,
  '.healthcare.sterile.v1.Issue.ReturnCountEntry': Issue_ReturnCountEntry$json,
  '.healthcare.sterile.v1.MarkUsedRequest': MarkUsedRequest$json,
  '.healthcare.sterile.v1.MarkUsedResponse': MarkUsedResponse$json,
  '.healthcare.sterile.v1.ReturnPackRequest': ReturnPackRequest$json,
  '.healthcare.sterile.v1.ReturnPackRequest.CountedEntry':
      ReturnPackRequest_CountedEntry$json,
  '.healthcare.sterile.v1.ReturnPackResponse': ReturnPackResponse$json,
  '.healthcare.sterile.v1.ListOutstandingRequest': ListOutstandingRequest$json,
  '.healthcare.sterile.v1.ListOutstandingResponse':
      ListOutstandingResponse$json,
  '.healthcare.sterile.v1.TraceCaseRequest': TraceCaseRequest$json,
  '.healthcare.sterile.v1.TraceCaseResponse': TraceCaseResponse$json,
  '.healthcare.sterile.v1.CaseTrace': CaseTrace$json,
  '.healthcare.sterile.v1.TracedSet': TracedSet$json,
  '.healthcare.sterile.v1.GetRecallScopeRequest': GetRecallScopeRequest$json,
  '.healthcare.sterile.v1.GetRecallScopeResponse': GetRecallScopeResponse$json,
  '.healthcare.sterile.v1.RecallScope': RecallScope$json,
  '.healthcare.sterile.v1.RecalledPack': RecalledPack$json,
  '.healthcare.sterile.v1.RaiseRecallRequest': RaiseRecallRequest$json,
  '.healthcare.sterile.v1.RaiseRecallResponse': RaiseRecallResponse$json,
  '.healthcare.sterile.v1.Recall': Recall$json,
  '.healthcare.sterile.v1.CloseRecallRequest': CloseRecallRequest$json,
  '.healthcare.sterile.v1.CloseRecallResponse': CloseRecallResponse$json,
  '.healthcare.sterile.v1.ListOpenRecallsRequest': ListOpenRecallsRequest$json,
  '.healthcare.sterile.v1.ListOpenRecallsResponse':
      ListOpenRecallsResponse$json,
};

/// Descriptor for `SterileServicesService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List sterileServicesServiceDescriptor = $convert.base64Decode(
    'ChZTdGVyaWxlU2VydmljZXNTZXJ2aWNlEnkKElJlZ2lzdGVySW5zdHJ1bWVudBIwLmhlYWx0aG'
    'NhcmUuc3RlcmlsZS52MS5SZWdpc3Rlckluc3RydW1lbnRSZXF1ZXN0GjEuaGVhbHRoY2FyZS5z'
    'dGVyaWxlLnYxLlJlZ2lzdGVySW5zdHJ1bWVudFJlc3BvbnNlEm0KDk1vdmVJbnN0cnVtZW50Ei'
    'wuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLk1vdmVJbnN0cnVtZW50UmVxdWVzdBotLmhlYWx0aGNh'
    'cmUuc3RlcmlsZS52MS5Nb3ZlSW5zdHJ1bWVudFJlc3BvbnNlEnAKD0xpc3RJbnN0cnVtZW50cx'
    'ItLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5MaXN0SW5zdHJ1bWVudHNSZXF1ZXN0Gi4uaGVhbHRo'
    'Y2FyZS5zdGVyaWxlLnYxLkxpc3RJbnN0cnVtZW50c1Jlc3BvbnNlEn8KFEdldEluc3RydW1lbn'
    'RIaXN0b3J5EjIuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkdldEluc3RydW1lbnRIaXN0b3J5UmVx'
    'dWVzdBozLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5HZXRJbnN0cnVtZW50SGlzdG9yeVJlc3Bvbn'
    'NlEnwKE0xpc3RJbnN0cnVtZW50TW92ZXMSMS5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuTGlzdElu'
    'c3RydW1lbnRNb3Zlc1JlcXVlc3QaMi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuTGlzdEluc3RydW'
    '1lbnRNb3Zlc1Jlc3BvbnNlEl4KCURlZmluZVNldBInLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5E'
    'ZWZpbmVTZXRSZXF1ZXN0GiguaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkRlZmluZVNldFJlc3Bvbn'
    'NlElUKBkdldFNldBIkLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5HZXRTZXRSZXF1ZXN0GiUuaGVh'
    'bHRoY2FyZS5zdGVyaWxlLnYxLkdldFNldFJlc3BvbnNlEnAKD0xpc3RTZXRWZXJzaW9ucxItLm'
    'hlYWx0aGNhcmUuc3RlcmlsZS52MS5MaXN0U2V0VmVyc2lvbnNSZXF1ZXN0Gi4uaGVhbHRoY2Fy'
    'ZS5zdGVyaWxlLnYxLkxpc3RTZXRWZXJzaW9uc1Jlc3BvbnNlElsKCExpc3RTZXRzEiYuaGVhbH'
    'RoY2FyZS5zdGVyaWxlLnYxLkxpc3RTZXRzUmVxdWVzdBonLmhlYWx0aGNhcmUuc3RlcmlsZS52'
    'MS5MaXN0U2V0c1Jlc3BvbnNlElgKB1JlY2VpdmUSJS5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUm'
    'VjZWl2ZVJlcXVlc3QaJi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUmVjZWl2ZVJlc3BvbnNlElgK'
    'B0FkdmFuY2USJS5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuQWR2YW5jZVJlcXVlc3QaJi5oZWFsdG'
    'hjYXJlLnN0ZXJpbGUudjEuQWR2YW5jZVJlc3BvbnNlElsKCEFzc2VtYmxlEiYuaGVhbHRoY2Fy'
    'ZS5zdGVyaWxlLnYxLkFzc2VtYmxlUmVxdWVzdBonLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5Bc3'
    'NlbWJsZVJlc3BvbnNlElgKB1BhY2thZ2USJS5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUGFja2Fn'
    'ZVJlcXVlc3QaJi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUGFja2FnZVJlc3BvbnNlEmEKClN0YX'
    'J0Q3ljbGUSKC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuU3RhcnRDeWNsZVJlcXVlc3QaKS5oZWFs'
    'dGhjYXJlLnN0ZXJpbGUudjEuU3RhcnRDeWNsZVJlc3BvbnNlEl4KCUxvYWRDeWNsZRInLmhlYW'
    'x0aGNhcmUuc3RlcmlsZS52MS5Mb2FkQ3ljbGVSZXF1ZXN0GiguaGVhbHRoY2FyZS5zdGVyaWxl'
    'LnYxLkxvYWRDeWNsZVJlc3BvbnNlEmQKC0ZpbmlzaEN5Y2xlEikuaGVhbHRoY2FyZS5zdGVyaW'
    'xlLnYxLkZpbmlzaEN5Y2xlUmVxdWVzdBoqLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5GaW5pc2hD'
    'eWNsZVJlc3BvbnNlEnAKD1JlY29yZEluZGljYXRvchItLmhlYWx0aGNhcmUuc3RlcmlsZS52MS'
    '5SZWNvcmRJbmRpY2F0b3JSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5zdGVyaWxlLnYxLlJlY29yZElu'
    'ZGljYXRvclJlc3BvbnNlEnkKEkdldFJlbGVhc2VEZWNpc2lvbhIwLmhlYWx0aGNhcmUuc3Rlcm'
    'lsZS52MS5HZXRSZWxlYXNlRGVjaXNpb25SZXF1ZXN0GjEuaGVhbHRoY2FyZS5zdGVyaWxlLnYx'
    'LkdldFJlbGVhc2VEZWNpc2lvblJlc3BvbnNlEmQKC1JlbGVhc2VMb2FkEikuaGVhbHRoY2FyZS'
    '5zdGVyaWxlLnYxLlJlbGVhc2VMb2FkUmVxdWVzdBoqLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5S'
    'ZWxlYXNlTG9hZFJlc3BvbnNlElsKCEdldEN5Y2xlEiYuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLk'
    'dldEN5Y2xlUmVxdWVzdBonLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5HZXRDeWNsZVJlc3BvbnNl'
    'Eo4BChlMaXN0Q3ljbGVzQXdhaXRpbmdSZWxlYXNlEjcuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLk'
    'xpc3RDeWNsZXNBd2FpdGluZ1JlbGVhc2VSZXF1ZXN0GjguaGVhbHRoY2FyZS5zdGVyaWxlLnYx'
    'Lkxpc3RDeWNsZXNBd2FpdGluZ1JlbGVhc2VSZXNwb25zZRKCAQoVTGlzdExvYWRzQ2xlYXJlZE'
    'J5TG90EjMuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkxpc3RMb2Fkc0NsZWFyZWRCeUxvdFJlcXVl'
    'c3QaNC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuTGlzdExvYWRzQ2xlYXJlZEJ5TG90UmVzcG9uc2'
    'USVQoGR2V0UnVuEiQuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkdldFJ1blJlcXVlc3QaJS5oZWFs'
    'dGhjYXJlLnN0ZXJpbGUudjEuR2V0UnVuUmVzcG9uc2USWwoIR2V0Qm9hcmQSJi5oZWFsdGhjYX'
    'JlLnN0ZXJpbGUudjEuR2V0Qm9hcmRSZXF1ZXN0GicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkdl'
    'dEJvYXJkUmVzcG9uc2USWwoIR2V0U2hlbGYSJi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuR2V0U2'
    'hlbGZSZXF1ZXN0GicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkdldFNoZWxmUmVzcG9uc2UScwoQ'
    'TGlzdEV4cGlyZWRQYWNrcxIuLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5MaXN0RXhwaXJlZFBhY2'
    'tzUmVxdWVzdBovLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5MaXN0RXhwaXJlZFBhY2tzUmVzcG9u'
    'c2USbQoOTGlzdEV4Y2VwdGlvbnMSLC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuTGlzdEV4Y2VwdG'
    'lvbnNSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkxpc3RFeGNlcHRpb25zUmVzcG9u'
    'c2USWwoIR2V0TGFiZWwSJi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuR2V0TGFiZWxSZXF1ZXN0Gi'
    'cuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkdldExhYmVsUmVzcG9uc2USXgoJSXNzdWVQYWNrEicu'
    'aGVhbHRoY2FyZS5zdGVyaWxlLnYxLklzc3VlUGFja1JlcXVlc3QaKC5oZWFsdGhjYXJlLnN0ZX'
    'JpbGUudjEuSXNzdWVQYWNrUmVzcG9uc2USWwoITWFya1VzZWQSJi5oZWFsdGhjYXJlLnN0ZXJp'
    'bGUudjEuTWFya1VzZWRSZXF1ZXN0GicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLk1hcmtVc2VkUm'
    'VzcG9uc2USYQoKUmV0dXJuUGFjaxIoLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5SZXR1cm5QYWNr'
    'UmVxdWVzdBopLmhlYWx0aGNhcmUuc3RlcmlsZS52MS5SZXR1cm5QYWNrUmVzcG9uc2UScAoPTG'
    'lzdE91dHN0YW5kaW5nEi0uaGVhbHRoY2FyZS5zdGVyaWxlLnYxLkxpc3RPdXRzdGFuZGluZ1Jl'
    'cXVlc3QaLi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuTGlzdE91dHN0YW5kaW5nUmVzcG9uc2USXg'
    'oJVHJhY2VDYXNlEicuaGVhbHRoY2FyZS5zdGVyaWxlLnYxLlRyYWNlQ2FzZVJlcXVlc3QaKC5o'
    'ZWFsdGhjYXJlLnN0ZXJpbGUudjEuVHJhY2VDYXNlUmVzcG9uc2USbQoOR2V0UmVjYWxsU2NvcG'
    'USLC5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuR2V0UmVjYWxsU2NvcGVSZXF1ZXN0Gi0uaGVhbHRo'
    'Y2FyZS5zdGVyaWxlLnYxLkdldFJlY2FsbFNjb3BlUmVzcG9uc2USZAoLUmFpc2VSZWNhbGwSKS'
    '5oZWFsdGhjYXJlLnN0ZXJpbGUudjEuUmFpc2VSZWNhbGxSZXF1ZXN0GiouaGVhbHRoY2FyZS5z'
    'dGVyaWxlLnYxLlJhaXNlUmVjYWxsUmVzcG9uc2USZAoLQ2xvc2VSZWNhbGwSKS5oZWFsdGhjYX'
    'JlLnN0ZXJpbGUudjEuQ2xvc2VSZWNhbGxSZXF1ZXN0GiouaGVhbHRoY2FyZS5zdGVyaWxlLnYx'
    'LkNsb3NlUmVjYWxsUmVzcG9uc2UScAoPTGlzdE9wZW5SZWNhbGxzEi0uaGVhbHRoY2FyZS5zdG'
    'VyaWxlLnYxLkxpc3RPcGVuUmVjYWxsc1JlcXVlc3QaLi5oZWFsdGhjYXJlLnN0ZXJpbGUudjEu'
    'TGlzdE9wZW5SZWNhbGxzUmVzcG9uc2U=');
