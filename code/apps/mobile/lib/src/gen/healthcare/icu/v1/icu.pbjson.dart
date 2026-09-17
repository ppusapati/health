// This is a generated file - do not edit.
//
// Generated from healthcare/icu/v1/icu.proto.

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

@$core.Deprecated('Use admissionSourceDescriptor instead')
const AdmissionSource$json = {
  '1': 'AdmissionSource',
  '2': [
    {'1': 'ADMISSION_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'ADMISSION_SOURCE_EMERGENCY', '2': 1},
    {'1': 'ADMISSION_SOURCE_WARD', '2': 2},
    {'1': 'ADMISSION_SOURCE_THEATRE', '2': 3},
    {'1': 'ADMISSION_SOURCE_OTHER_ICU', '2': 4},
    {'1': 'ADMISSION_SOURCE_EXTERNAL', '2': 5},
    {'1': 'ADMISSION_SOURCE_DIRECT', '2': 6},
  ],
};

/// Descriptor for `AdmissionSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List admissionSourceDescriptor = $convert.base64Decode(
    'Cg9BZG1pc3Npb25Tb3VyY2USIAocQURNSVNTSU9OX1NPVVJDRV9VTlNQRUNJRklFRBAAEh4KGk'
    'FETUlTU0lPTl9TT1VSQ0VfRU1FUkdFTkNZEAESGQoVQURNSVNTSU9OX1NPVVJDRV9XQVJEEAIS'
    'HAoYQURNSVNTSU9OX1NPVVJDRV9USEVBVFJFEAMSHgoaQURNSVNTSU9OX1NPVVJDRV9PVEhFUl'
    '9JQ1UQBBIdChlBRE1JU1NJT05fU09VUkNFX0VYVEVSTkFMEAUSGwoXQURNSVNTSU9OX1NPVVJD'
    'RV9ESVJFQ1QQBg==');

@$core.Deprecated('Use episodeStatusDescriptor instead')
const EpisodeStatus$json = {
  '1': 'EpisodeStatus',
  '2': [
    {'1': 'EPISODE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'EPISODE_STATUS_OPEN', '2': 1},
    {'1': 'EPISODE_STATUS_READY_FOR_TRANSFER', '2': 2},
    {'1': 'EPISODE_STATUS_CLOSED', '2': 3},
  ],
};

/// Descriptor for `EpisodeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List episodeStatusDescriptor = $convert.base64Decode(
    'Cg1FcGlzb2RlU3RhdHVzEh4KGkVQSVNPREVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTRVBJU0'
    '9ERV9TVEFUVVNfT1BFThABEiUKIUVQSVNPREVfU1RBVFVTX1JFQURZX0ZPUl9UUkFOU0ZFUhAC'
    'EhkKFUVQSVNPREVfU1RBVFVTX0NMT1NFRBAD');

@$core.Deprecated('Use episodeOutcomeDescriptor instead')
const EpisodeOutcome$json = {
  '1': 'EpisodeOutcome',
  '2': [
    {'1': 'EPISODE_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'EPISODE_OUTCOME_WARD', '2': 1},
    {'1': 'EPISODE_OUTCOME_OTHER_ICU', '2': 2},
    {'1': 'EPISODE_OUTCOME_THEATRE', '2': 3},
    {'1': 'EPISODE_OUTCOME_EXTERNAL_TRANSFER', '2': 4},
    {'1': 'EPISODE_OUTCOME_DISCHARGE', '2': 5},
    {'1': 'EPISODE_OUTCOME_DEATH', '2': 6},
  ],
};

/// Descriptor for `EpisodeOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List episodeOutcomeDescriptor = $convert.base64Decode(
    'Cg5FcGlzb2RlT3V0Y29tZRIfChtFUElTT0RFX09VVENPTUVfVU5TUEVDSUZJRUQQABIYChRFUE'
    'lTT0RFX09VVENPTUVfV0FSRBABEh0KGUVQSVNPREVfT1VUQ09NRV9PVEhFUl9JQ1UQAhIbChdF'
    'UElTT0RFX09VVENPTUVfVEhFQVRSRRADEiUKIUVQSVNPREVfT1VUQ09NRV9FWFRFUk5BTF9UUk'
    'FOU0ZFUhAEEh0KGUVQSVNPREVfT1VUQ09NRV9ESVNDSEFSR0UQBRIZChVFUElTT0RFX09VVENP'
    'TUVfREVBVEgQBg==');

@$core.Deprecated('Use observationSourceDescriptor instead')
const ObservationSource$json = {
  '1': 'ObservationSource',
  '2': [
    {'1': 'OBSERVATION_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'OBSERVATION_SOURCE_MANUAL', '2': 1},
    {'1': 'OBSERVATION_SOURCE_DEVICE', '2': 2},
    {'1': 'OBSERVATION_SOURCE_CALCULATED', '2': 3},
    {'1': 'OBSERVATION_SOURCE_UNKNOWN', '2': 4},
  ],
};

/// Descriptor for `ObservationSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List observationSourceDescriptor = $convert.base64Decode(
    'ChFPYnNlcnZhdGlvblNvdXJjZRIiCh5PQlNFUlZBVElPTl9TT1VSQ0VfVU5TUEVDSUZJRUQQAB'
    'IdChlPQlNFUlZBVElPTl9TT1VSQ0VfTUFOVUFMEAESHQoZT0JTRVJWQVRJT05fU09VUkNFX0RF'
    'VklDRRACEiEKHU9CU0VSVkFUSU9OX1NPVVJDRV9DQUxDVUxBVEVEEAMSHgoaT0JTRVJWQVRJT0'
    '5fU09VUkNFX1VOS05PV04QBA==');

@$core.Deprecated('Use validationStateDescriptor instead')
const ValidationState$json = {
  '1': 'ValidationState',
  '2': [
    {'1': 'VALIDATION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'VALIDATION_STATE_NOT_REQUIRED', '2': 1},
    {'1': 'VALIDATION_STATE_PENDING', '2': 2},
    {'1': 'VALIDATION_STATE_CONFIRMED', '2': 3},
    {'1': 'VALIDATION_STATE_REJECTED', '2': 4},
  ],
};

/// Descriptor for `ValidationState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List validationStateDescriptor = $convert.base64Decode(
    'Cg9WYWxpZGF0aW9uU3RhdGUSIAocVkFMSURBVElPTl9TVEFURV9VTlNQRUNJRklFRBAAEiEKHV'
    'ZBTElEQVRJT05fU1RBVEVfTk9UX1JFUVVJUkVEEAESHAoYVkFMSURBVElPTl9TVEFURV9QRU5E'
    'SU5HEAISHgoaVkFMSURBVElPTl9TVEFURV9DT05GSVJNRUQQAxIdChlWQUxJREFUSU9OX1NUQV'
    'RFX1JFSkVDVEVEEAQ=');

@$core.Deprecated('Use supportKindDescriptor instead')
const SupportKind$json = {
  '1': 'SupportKind',
  '2': [
    {'1': 'SUPPORT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SUPPORT_KIND_VENTILATION', '2': 1},
    {'1': 'SUPPORT_KIND_VASOPRESSOR', '2': 2},
    {'1': 'SUPPORT_KIND_RENAL_REPLACEMENT', '2': 3},
    {'1': 'SUPPORT_KIND_ECMO', '2': 4},
    {'1': 'SUPPORT_KIND_OTHER', '2': 5},
  ],
};

/// Descriptor for `SupportKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List supportKindDescriptor = $convert.base64Decode(
    'CgtTdXBwb3J0S2luZBIcChhTVVBQT1JUX0tJTkRfVU5TUEVDSUZJRUQQABIcChhTVVBQT1JUX0'
    'tJTkRfVkVOVElMQVRJT04QARIcChhTVVBQT1JUX0tJTkRfVkFTT1BSRVNTT1IQAhIiCh5TVVBQ'
    'T1JUX0tJTkRfUkVOQUxfUkVQTEFDRU1FTlQQAxIVChFTVVBQT1JUX0tJTkRfRUNNTxAEEhYKEl'
    'NVUFBPUlRfS0lORF9PVEhFUhAF');

@$core.Deprecated('Use bundleKindDescriptor instead')
const BundleKind$json = {
  '1': 'BundleKind',
  '2': [
    {'1': 'BUNDLE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'BUNDLE_KIND_SEPSIS', '2': 1},
    {'1': 'BUNDLE_KIND_VTE', '2': 2},
    {'1': 'BUNDLE_KIND_DELIRIUM', '2': 3},
    {'1': 'BUNDLE_KIND_PRESSURE_INJURY', '2': 4},
    {'1': 'BUNDLE_KIND_SEDATION', '2': 5},
    {'1': 'BUNDLE_KIND_VENTILATOR', '2': 6},
    {'1': 'BUNDLE_KIND_LOCAL', '2': 7},
  ],
};

/// Descriptor for `BundleKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bundleKindDescriptor = $convert.base64Decode(
    'CgpCdW5kbGVLaW5kEhsKF0JVTkRMRV9LSU5EX1VOU1BFQ0lGSUVEEAASFgoSQlVORExFX0tJTk'
    'RfU0VQU0lTEAESEwoPQlVORExFX0tJTkRfVlRFEAISGAoUQlVORExFX0tJTkRfREVMSVJJVU0Q'
    'AxIfChtCVU5ETEVfS0lORF9QUkVTU1VSRV9JTkpVUlkQBBIYChRCVU5ETEVfS0lORF9TRURBVE'
    'lPThAFEhoKFkJVTkRMRV9LSU5EX1ZFTlRJTEFUT1IQBhIVChFCVU5ETEVfS0lORF9MT0NBTBAH');

@$core.Deprecated('Use bundleItemStateDescriptor instead')
const BundleItemState$json = {
  '1': 'BundleItemState',
  '2': [
    {'1': 'BUNDLE_ITEM_STATE_UNSPECIFIED', '2': 0},
    {'1': 'BUNDLE_ITEM_STATE_DONE', '2': 1},
    {'1': 'BUNDLE_ITEM_STATE_EXCEPTION', '2': 2},
    {'1': 'BUNDLE_ITEM_STATE_NOT_DONE', '2': 3},
  ],
};

/// Descriptor for `BundleItemState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bundleItemStateDescriptor = $convert.base64Decode(
    'Cg9CdW5kbGVJdGVtU3RhdGUSIQodQlVORExFX0lURU1fU1RBVEVfVU5TUEVDSUZJRUQQABIaCh'
    'ZCVU5ETEVfSVRFTV9TVEFURV9ET05FEAESHwobQlVORExFX0lURU1fU1RBVEVfRVhDRVBUSU9O'
    'EAISHgoaQlVORExFX0lURU1fU1RBVEVfTk9UX0RPTkUQAw==');

@$core.Deprecated('Use careIntentDescriptor instead')
const CareIntent$json = {
  '1': 'CareIntent',
  '2': [
    {'1': 'CARE_INTENT_UNSPECIFIED', '2': 0},
    {'1': 'CARE_INTENT_FULL_ESCALATION', '2': 1},
    {'1': 'CARE_INTENT_LIMITED', '2': 2},
    {'1': 'CARE_INTENT_COMFORT', '2': 3},
  ],
};

/// Descriptor for `CareIntent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List careIntentDescriptor = $convert.base64Decode(
    'CgpDYXJlSW50ZW50EhsKF0NBUkVfSU5URU5UX1VOU1BFQ0lGSUVEEAASHwobQ0FSRV9JTlRFTl'
    'RfRlVMTF9FU0NBTEFUSU9OEAESFwoTQ0FSRV9JTlRFTlRfTElNSVRFRBACEhcKE0NBUkVfSU5U'
    'RU5UX0NPTUZPUlQQAw==');

@$core.Deprecated('Use goalStatusDescriptor instead')
const GoalStatus$json = {
  '1': 'GoalStatus',
  '2': [
    {'1': 'GOAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'GOAL_STATUS_OPEN', '2': 1},
    {'1': 'GOAL_STATUS_MET', '2': 2},
    {'1': 'GOAL_STATUS_NOT_MET', '2': 3},
    {'1': 'GOAL_STATUS_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `GoalStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List goalStatusDescriptor = $convert.base64Decode(
    'CgpHb2FsU3RhdHVzEhsKF0dPQUxfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFAoQR09BTF9TVEFUVV'
    'NfT1BFThABEhMKD0dPQUxfU1RBVFVTX01FVBACEhcKE0dPQUxfU1RBVFVTX05PVF9NRVQQAxIZ'
    'ChVHT0FMX1NUQVRVU19DQU5DRUxMRUQQBA==');

@$core.Deprecated('Use alarmSeverityDescriptor instead')
const AlarmSeverity$json = {
  '1': 'AlarmSeverity',
  '2': [
    {'1': 'ALARM_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'ALARM_SEVERITY_INFORMATION', '2': 1},
    {'1': 'ALARM_SEVERITY_WARNING', '2': 2},
    {'1': 'ALARM_SEVERITY_URGENT', '2': 3},
  ],
};

/// Descriptor for `AlarmSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alarmSeverityDescriptor = $convert.base64Decode(
    'Cg1BbGFybVNldmVyaXR5Eh4KGkFMQVJNX1NFVkVSSVRZX1VOU1BFQ0lGSUVEEAASHgoaQUxBUk'
    '1fU0VWRVJJVFlfSU5GT1JNQVRJT04QARIaChZBTEFSTV9TRVZFUklUWV9XQVJOSU5HEAISGQoV'
    'QUxBUk1fU0VWRVJJVFlfVVJHRU5UEAM=');

@$core.Deprecated('Use icuEpisodeDescriptor instead')
const IcuEpisode$json = {
  '1': 'IcuEpisode',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 5, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'bed_id', '3': 6, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'source',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.AdmissionSource',
      '10': 'source'
    },
    {'1': 'transferred_from', '3': 8, '4': 1, '5': 9, '10': 'transferredFrom'},
    {'1': 'responsible_team', '3': 9, '4': 1, '5': 9, '10': 'responsibleTeam'},
    {
      '1': 'responsible_clinician',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'responsibleClinician'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.EpisodeStatus',
      '10': 'status'
    },
    {
      '1': 'admitted_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'admittedAt'
    },
    {
      '1': 'ready_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'readyAt'
    },
    {
      '1': 'discharged_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dischargedAt'
    },
    {
      '1': 'outcome',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.EpisodeOutcome',
      '10': 'outcome'
    },
    {'1': 'outcome_note', '3': 16, '4': 1, '5': 9, '10': 'outcomeNote'},
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `IcuEpisode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List icuEpisodeDescriptor = $convert.base64Decode(
    'CgpJY3VFcGlzb2RlEh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBIhCgxlbmNvdW50ZX'
    'JfaWQYAiABKAlSC2VuY291bnRlcklkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIf'
    'CgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIXCgd1bml0X2lkGAUgASgJUgZ1bml0SW'
    'QSFQoGYmVkX2lkGAYgASgJUgViZWRJZBI6CgZzb3VyY2UYByABKA4yIi5oZWFsdGhjYXJlLmlj'
    'dS52MS5BZG1pc3Npb25Tb3VyY2VSBnNvdXJjZRIpChB0cmFuc2ZlcnJlZF9mcm9tGAggASgJUg'
    '90cmFuc2ZlcnJlZEZyb20SKQoQcmVzcG9uc2libGVfdGVhbRgJIAEoCVIPcmVzcG9uc2libGVU'
    'ZWFtEjMKFXJlc3BvbnNpYmxlX2NsaW5pY2lhbhgKIAEoCVIUcmVzcG9uc2libGVDbGluaWNpYW'
    '4SOAoGc3RhdHVzGAsgASgOMiAuaGVhbHRoY2FyZS5pY3UudjEuRXBpc29kZVN0YXR1c1IGc3Rh'
    'dHVzEjsKC2FkbWl0dGVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYW'
    'RtaXR0ZWRBdBI1CghyZWFkeV9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'B3JlYWR5QXQSPwoNZGlzY2hhcmdlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSDGRpc2NoYXJnZWRBdBI7CgdvdXRjb21lGA8gASgOMiEuaGVhbHRoY2FyZS5pY3UudjEu'
    'RXBpc29kZU91dGNvbWVSB291dGNvbWUSIQoMb3V0Y29tZV9ub3RlGBAgASgJUgtvdXRjb21lTm'
    '90ZRIYCgd2ZXJzaW9uGBEgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use deviceSourceDescriptor instead')
const DeviceSource$json = {
  '1': 'DeviceSource',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'model', '3': 2, '4': 1, '5': 9, '10': 'model'},
    {'1': 'channel_id', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    {
      '1': 'measured_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'measuredAt'
    },
    {'1': 'quality', '3': 5, '4': 1, '5': 9, '10': 'quality'},
  ],
};

/// Descriptor for `DeviceSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceSourceDescriptor = $convert.base64Decode(
    'CgxEZXZpY2VTb3VyY2USGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIUCgVtb2RlbBgCIA'
    'EoCVIFbW9kZWwSHQoKY2hhbm5lbF9pZBgDIAEoCVIJY2hhbm5lbElkEjsKC21lYXN1cmVkX2F0'
    'GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbWVhc3VyZWRBdBIYCgdxdWFsaX'
    'R5GAUgASgJUgdxdWFsaXR5');

@$core.Deprecated('Use observationDescriptor instead')
const Observation$json = {
  '1': 'Observation',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'code_system', '3': 3, '4': 1, '5': 9, '10': 'codeSystem'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 5, '4': 1, '5': 9, '10': 'display'},
    {'1': 'dimension', '3': 6, '4': 1, '5': 9, '10': 'dimension'},
    {'1': 'value', '3': 7, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 8, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'raw_value', '3': 9, '4': 1, '5': 1, '10': 'rawValue'},
    {'1': 'raw_unit', '3': 10, '4': 1, '5': 9, '10': 'rawUnit'},
    {'1': 'normalised', '3': 11, '4': 1, '5': 8, '10': 'normalised'},
    {
      '1': 'source',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.ObservationSource',
      '10': 'source'
    },
    {
      '1': 'validation',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.ValidationState',
      '10': 'validation'
    },
    {
      '1': 'device',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.DeviceSource',
      '10': 'device'
    },
    {
      '1': 'observed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {
      '1': 'recorded_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 17, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'validated_by', '3': 18, '4': 1, '5': 9, '10': 'validatedBy'},
    {
      '1': 'validated_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validatedAt'
    },
    {'1': 'validation_note', '3': 20, '4': 1, '5': 9, '10': 'validationNote'},
  ],
};

/// Descriptor for `Observation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationDescriptor = $convert.base64Decode(
    'CgtPYnNlcnZhdGlvbhIlCg5vYnNlcnZhdGlvbl9pZBgBIAEoCVINb2JzZXJ2YXRpb25JZBIdCg'
    'plcGlzb2RlX2lkGAIgASgJUgllcGlzb2RlSWQSHwoLY29kZV9zeXN0ZW0YAyABKAlSCmNvZGVT'
    'eXN0ZW0SEgoEY29kZRgEIAEoCVIEY29kZRIYCgdkaXNwbGF5GAUgASgJUgdkaXNwbGF5EhwKCW'
    'RpbWVuc2lvbhgGIAEoCVIJZGltZW5zaW9uEhQKBXZhbHVlGAcgASgBUgV2YWx1ZRISCgR1bml0'
    'GAggASgJUgR1bml0EhsKCXJhd192YWx1ZRgJIAEoAVIIcmF3VmFsdWUSGQoIcmF3X3VuaXQYCi'
    'ABKAlSB3Jhd1VuaXQSHgoKbm9ybWFsaXNlZBgLIAEoCFIKbm9ybWFsaXNlZBI8CgZzb3VyY2UY'
    'DCABKA4yJC5oZWFsdGhjYXJlLmljdS52MS5PYnNlcnZhdGlvblNvdXJjZVIGc291cmNlEkIKCn'
    'ZhbGlkYXRpb24YDSABKA4yIi5oZWFsdGhjYXJlLmljdS52MS5WYWxpZGF0aW9uU3RhdGVSCnZh'
    'bGlkYXRpb24SNwoGZGV2aWNlGA4gASgLMh8uaGVhbHRoY2FyZS5pY3UudjEuRGV2aWNlU291cm'
    'NlUgZkZXZpY2USOwoLb2JzZXJ2ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgpvYnNlcnZlZEF0EjsKC3JlY29yZGVkX2F0GBAgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIKcmVjb3JkZWRBdBIfCgtyZWNvcmRlZF9ieRgRIAEoCVIKcmVjb3JkZWRCeRIh'
    'Cgx2YWxpZGF0ZWRfYnkYEiABKAlSC3ZhbGlkYXRlZEJ5Ej0KDHZhbGlkYXRlZF9hdBgTIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3ZhbGlkYXRlZEF0EicKD3ZhbGlkYXRpb25f'
    'bm90ZRgUIAEoCVIOdmFsaWRhdGlvbk5vdGU=');

@$core.Deprecated('Use balanceDescriptor instead')
const Balance$json = {
  '1': 'Balance',
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
    {'1': 'intake_ml', '3': 3, '4': 1, '5': 1, '10': 'intakeMl'},
    {'1': 'output_ml', '3': 4, '4': 1, '5': 1, '10': 'outputMl'},
    {'1': 'net_ml', '3': 5, '4': 1, '5': 1, '10': 'netMl'},
    {'1': 'entries', '3': 6, '4': 1, '5': 5, '10': 'entries'},
    {'1': 'corrections', '3': 7, '4': 1, '5': 5, '10': 'corrections'},
  ],
};

/// Descriptor for `Balance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceDescriptor = $convert.base64Decode(
    'CgdCYWxhbmNlEi4KBGZyb20YASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm'
    '9tEioKAnRvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8SGwoJaW50YWtl'
    'X21sGAMgASgBUghpbnRha2VNbBIbCglvdXRwdXRfbWwYBCABKAFSCG91dHB1dE1sEhUKBm5ldF'
    '9tbBgFIAEoAVIFbmV0TWwSGAoHZW50cmllcxgGIAEoBVIHZW50cmllcxIgCgtjb3JyZWN0aW9u'
    'cxgHIAEoBVILY29ycmVjdGlvbnM=');

@$core.Deprecated('Use balanceEntryDescriptor instead')
const BalanceEntry$json = {
  '1': 'BalanceEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'direction', '3': 3, '4': 1, '5': 9, '10': 'direction'},
    {'1': 'route', '3': 4, '4': 1, '5': 9, '10': 'route'},
    {'1': 'volume_ml', '3': 5, '4': 1, '5': 1, '10': 'volumeMl'},
    {
      '1': 'occurred_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'recorded_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 8, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'superseded_by', '3': 9, '4': 1, '5': 9, '10': 'supersededBy'},
    {'1': 'corrects', '3': 10, '4': 1, '5': 9, '10': 'corrects'},
    {
      '1': 'correction_reason',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'correctionReason'
    },
  ],
};

/// Descriptor for `BalanceEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List balanceEntryDescriptor = $convert.base64Decode(
    'CgxCYWxhbmNlRW50cnkSGQoIZW50cnlfaWQYASABKAlSB2VudHJ5SWQSHQoKZXBpc29kZV9pZB'
    'gCIAEoCVIJZXBpc29kZUlkEhwKCWRpcmVjdGlvbhgDIAEoCVIJZGlyZWN0aW9uEhQKBXJvdXRl'
    'GAQgASgJUgVyb3V0ZRIbCgl2b2x1bWVfbWwYBSABKAFSCHZvbHVtZU1sEjsKC29jY3VycmVkX2'
    'F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBI7CgtyZWNv'
    'cmRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSHw'
    'oLcmVjb3JkZWRfYnkYCCABKAlSCnJlY29yZGVkQnkSIwoNc3VwZXJzZWRlZF9ieRgJIAEoCVIM'
    'c3VwZXJzZWRlZEJ5EhoKCGNvcnJlY3RzGAogASgJUghjb3JyZWN0cxIrChFjb3JyZWN0aW9uX3'
    'JlYXNvbhgLIAEoCVIQY29ycmVjdGlvblJlYXNvbg==');

@$core.Deprecated('Use supportDescriptor instead')
const Support$json = {
  '1': 'Support',
  '2': [
    {'1': 'support_id', '3': 1, '4': 1, '5': 9, '10': 'supportId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.SupportKind',
      '10': 'kind'
    },
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'modality', '3': 5, '4': 1, '5': 9, '10': 'modality'},
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 7, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'stopped_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
    {'1': 'stopped_by', '3': 9, '4': 1, '5': 9, '10': 'stoppedBy'},
    {'1': 'stop_note', '3': 10, '4': 1, '5': 9, '10': 'stopNote'},
  ],
};

/// Descriptor for `Support`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List supportDescriptor = $convert.base64Decode(
    'CgdTdXBwb3J0Eh0KCnN1cHBvcnRfaWQYASABKAlSCXN1cHBvcnRJZBIdCgplcGlzb2RlX2lkGA'
    'IgASgJUgllcGlzb2RlSWQSMgoEa2luZBgDIAEoDjIeLmhlYWx0aGNhcmUuaWN1LnYxLlN1cHBv'
    'cnRLaW5kUgRraW5kEhQKBWxhYmVsGAQgASgJUgVsYWJlbBIaCghtb2RhbGl0eRgFIAEoCVIIbW'
    '9kYWxpdHkSOQoKc3RhcnRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXN0YXJ0ZWRBdBIdCgpzdGFydGVkX2J5GAcgASgJUglzdGFydGVkQnkSOQoKc3RvcHBlZF9hdB'
    'gIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0b3BwZWRBdBIdCgpzdG9wcGVk'
    'X2J5GAkgASgJUglzdG9wcGVkQnkSGwoJc3RvcF9ub3RlGAogASgJUghzdG9wTm90ZQ==');

@$core.Deprecated('Use ventSettingDescriptor instead')
const VentSetting$json = {
  '1': 'VentSetting',
  '2': [
    {'1': 'setting_id', '3': 1, '4': 1, '5': 9, '10': 'settingId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'support_id', '3': 3, '4': 1, '5': 9, '10': 'supportId'},
    {'1': 'mode', '3': 4, '4': 1, '5': 9, '10': 'mode'},
    {
      '1': 'parameters',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.VentSetting.ParametersEntry',
      '10': 'parameters'
    },
    {
      '1': 'measured',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.VentSetting.MeasuredEntry',
      '10': 'measured'
    },
    {
      '1': 'units',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.VentSetting.UnitsEntry',
      '10': 'units'
    },
    {'1': 'device_id', '3': 8, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'effective_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'recorded_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'change_reason', '3': 12, '4': 1, '5': 9, '10': 'changeReason'},
  ],
  '3': [
    VentSetting_ParametersEntry$json,
    VentSetting_MeasuredEntry$json,
    VentSetting_UnitsEntry$json
  ],
};

@$core.Deprecated('Use ventSettingDescriptor instead')
const VentSetting_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use ventSettingDescriptor instead')
const VentSetting_MeasuredEntry$json = {
  '1': 'MeasuredEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use ventSettingDescriptor instead')
const VentSetting_UnitsEntry$json = {
  '1': 'UnitsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `VentSetting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ventSettingDescriptor = $convert.base64Decode(
    'CgtWZW50U2V0dGluZxIdCgpzZXR0aW5nX2lkGAEgASgJUglzZXR0aW5nSWQSHQoKZXBpc29kZV'
    '9pZBgCIAEoCVIJZXBpc29kZUlkEh0KCnN1cHBvcnRfaWQYAyABKAlSCXN1cHBvcnRJZBISCgRt'
    'b2RlGAQgASgJUgRtb2RlEk4KCnBhcmFtZXRlcnMYBSADKAsyLi5oZWFsdGhjYXJlLmljdS52MS'
    '5WZW50U2V0dGluZy5QYXJhbWV0ZXJzRW50cnlSCnBhcmFtZXRlcnMSSAoIbWVhc3VyZWQYBiAD'
    'KAsyLC5oZWFsdGhjYXJlLmljdS52MS5WZW50U2V0dGluZy5NZWFzdXJlZEVudHJ5UghtZWFzdX'
    'JlZBI/CgV1bml0cxgHIAMoCzIpLmhlYWx0aGNhcmUuaWN1LnYxLlZlbnRTZXR0aW5nLlVuaXRz'
    'RW50cnlSBXVuaXRzEhsKCWRldmljZV9pZBgIIAEoCVIIZGV2aWNlSWQSPQoMZWZmZWN0aXZlX2'
    'F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZWZmZWN0aXZlQXQSOwoLcmVj'
    'b3JkZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh'
    '8KC3JlY29yZGVkX2J5GAsgASgJUgpyZWNvcmRlZEJ5EiMKDWNoYW5nZV9yZWFzb24YDCABKAlS'
    'DGNoYW5nZVJlYXNvbho9Cg9QYXJhbWV0ZXJzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdm'
    'FsdWUYAiABKAFSBXZhbHVlOgI4ARo7Cg1NZWFzdXJlZEVudHJ5EhAKA2tleRgBIAEoCVIDa2V5'
    'EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAEaOAoKVW5pdHNFbnRyeRIQCgNrZXkYASABKAlSA2'
    'tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use infusionDescriptor instead')
const Infusion$json = {
  '1': 'Infusion',
  '2': [
    {'1': 'infusion_id', '3': 1, '4': 1, '5': 9, '10': 'infusionId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'prescription_id', '3': 3, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'drug_code', '3': 4, '4': 1, '5': 9, '10': 'drugCode'},
    {'1': 'drug_display', '3': 5, '4': 1, '5': 9, '10': 'drugDisplay'},
    {
      '1': 'concentration_amount',
      '3': 6,
      '4': 1,
      '5': 1,
      '10': 'concentrationAmount'
    },
    {
      '1': 'concentration_unit',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'concentrationUnit'
    },
    {
      '1': 'concentration_volume',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'concentrationVolume'
    },
    {'1': 'dose_unit', '3': 9, '4': 1, '5': 9, '10': 'doseUnit'},
    {'1': 'weight_kg', '3': 10, '4': 1, '5': 1, '10': 'weightKg'},
    {
      '1': 'started_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 12, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'stopped_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
    {'1': 'stopped_by', '3': 14, '4': 1, '5': 9, '10': 'stoppedBy'},
    {
      '1': 'titrations',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Titration',
      '10': 'titrations'
    },
  ],
};

/// Descriptor for `Infusion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List infusionDescriptor = $convert.base64Decode(
    'CghJbmZ1c2lvbhIfCgtpbmZ1c2lvbl9pZBgBIAEoCVIKaW5mdXNpb25JZBIdCgplcGlzb2RlX2'
    'lkGAIgASgJUgllcGlzb2RlSWQSJwoPcHJlc2NyaXB0aW9uX2lkGAMgASgJUg5wcmVzY3JpcHRp'
    'b25JZBIbCglkcnVnX2NvZGUYBCABKAlSCGRydWdDb2RlEiEKDGRydWdfZGlzcGxheRgFIAEoCV'
    'ILZHJ1Z0Rpc3BsYXkSMQoUY29uY2VudHJhdGlvbl9hbW91bnQYBiABKAFSE2NvbmNlbnRyYXRp'
    'b25BbW91bnQSLQoSY29uY2VudHJhdGlvbl91bml0GAcgASgJUhFjb25jZW50cmF0aW9uVW5pdB'
    'IxChRjb25jZW50cmF0aW9uX3ZvbHVtZRgIIAEoAVITY29uY2VudHJhdGlvblZvbHVtZRIbCglk'
    'b3NlX3VuaXQYCSABKAlSCGRvc2VVbml0EhsKCXdlaWdodF9rZxgKIAEoAVIId2VpZ2h0S2cSOQ'
    'oKc3RhcnRlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRB'
    'dBIdCgpzdGFydGVkX2J5GAwgASgJUglzdGFydGVkQnkSOQoKc3RvcHBlZF9hdBgNIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0b3BwZWRBdBIdCgpzdG9wcGVkX2J5GA4gASgJ'
    'UglzdG9wcGVkQnkSPAoKdGl0cmF0aW9ucxgPIAMoCzIcLmhlYWx0aGNhcmUuaWN1LnYxLlRpdH'
    'JhdGlvblIKdGl0cmF0aW9ucw==');

@$core.Deprecated('Use titrationDescriptor instead')
const Titration$json = {
  '1': 'Titration',
  '2': [
    {'1': 'titration_id', '3': 1, '4': 1, '5': 9, '10': 'titrationId'},
    {'1': 'rate', '3': 2, '4': 1, '5': 1, '10': 'rate'},
    {'1': 'rate_unit', '3': 3, '4': 1, '5': 9, '10': 'rateUnit'},
    {'1': 'dose', '3': 4, '4': 1, '5': 1, '10': 'dose'},
    {
      '1': 'effective_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'recorded_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 7, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'device_id', '3': 8, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `Titration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List titrationDescriptor = $convert.base64Decode(
    'CglUaXRyYXRpb24SIQoMdGl0cmF0aW9uX2lkGAEgASgJUgt0aXRyYXRpb25JZBISCgRyYXRlGA'
    'IgASgBUgRyYXRlEhsKCXJhdGVfdW5pdBgDIAEoCVIIcmF0ZVVuaXQSEgoEZG9zZRgEIAEoAVIE'
    'ZG9zZRI9CgxlZmZlY3RpdmVfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'tlZmZlY3RpdmVBdBI7CgtyZWNvcmRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSCnJlY29yZGVkQXQSHwoLcmVjb3JkZWRfYnkYByABKAlSCnJlY29yZGVkQnkSGwoJZG'
    'V2aWNlX2lkGAggASgJUghkZXZpY2VJZBIWCgZyZWFzb24YCSABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use invasiveDeviceDescriptor instead')
const InvasiveDevice$json = {
  '1': 'InvasiveDevice',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'site', '3': 4, '4': 1, '5': 9, '10': 'site'},
    {'1': 'lumens', '3': 5, '4': 1, '5': 5, '10': 'lumens'},
    {
      '1': 'inserted_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'insertedAt'
    },
    {'1': 'inserted_by', '3': 7, '4': 1, '5': 9, '10': 'insertedBy'},
    {
      '1': 'removed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'removedAt'
    },
    {'1': 'removed_by', '3': 9, '4': 1, '5': 9, '10': 'removedBy'},
    {'1': 'removal_reason', '3': 10, '4': 1, '5': 9, '10': 'removalReason'},
    {
      '1': 'review_every_seconds',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'reviewEverySeconds'
    },
    {
      '1': 'last_reviewed_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastReviewedAt'
    },
    {'1': 'last_reviewed_by', '3': 13, '4': 1, '5': 9, '10': 'lastReviewedBy'},
    {'1': 'review_overdue', '3': 14, '4': 1, '5': 8, '10': 'reviewOverdue'},
  ],
};

/// Descriptor for `InvasiveDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List invasiveDeviceDescriptor = $convert.base64Decode(
    'Cg5JbnZhc2l2ZURldmljZRIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh0KCmVwaXNvZG'
    'VfaWQYAiABKAlSCWVwaXNvZGVJZBISCgRraW5kGAMgASgJUgRraW5kEhIKBHNpdGUYBCABKAlS'
    'BHNpdGUSFgoGbHVtZW5zGAUgASgFUgZsdW1lbnMSOwoLaW5zZXJ0ZWRfYXQYBiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgppbnNlcnRlZEF0Eh8KC2luc2VydGVkX2J5GAcgASgJ'
    'UgppbnNlcnRlZEJ5EjkKCnJlbW92ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUglyZW1vdmVkQXQSHQoKcmVtb3ZlZF9ieRgJIAEoCVIJcmVtb3ZlZEJ5EiUKDnJlbW92'
    'YWxfcmVhc29uGAogASgJUg1yZW1vdmFsUmVhc29uEjAKFHJldmlld19ldmVyeV9zZWNvbmRzGA'
    'sgASgDUhJyZXZpZXdFdmVyeVNlY29uZHMSRAoQbGFzdF9yZXZpZXdlZF9hdBgMIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmxhc3RSZXZpZXdlZEF0EigKEGxhc3RfcmV2aWV3ZW'
    'RfYnkYDSABKAlSDmxhc3RSZXZpZXdlZEJ5EiUKDnJldmlld19vdmVyZHVlGA4gASgIUg1yZXZp'
    'ZXdPdmVyZHVl');

@$core.Deprecated('Use scoreInputDescriptor instead')
const ScoreInput$json = {
  '1': 'ScoreInput',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'observation_id', '3': 2, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'value', '3': 3, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'observed_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'points', '3': 6, '4': 1, '5': 5, '10': 'points'},
  ],
};

/// Descriptor for `ScoreInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreInputDescriptor = $convert.base64Decode(
    'CgpTY29yZUlucHV0EhIKBGNvZGUYASABKAlSBGNvZGUSJQoOb2JzZXJ2YXRpb25faWQYAiABKA'
    'lSDW9ic2VydmF0aW9uSWQSFAoFdmFsdWUYAyABKAFSBXZhbHVlEhIKBHVuaXQYBCABKAlSBHVu'
    'aXQSOwoLb2JzZXJ2ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvYn'
    'NlcnZlZEF0EhYKBnBvaW50cxgGIAEoBVIGcG9pbnRz');

@$core.Deprecated('Use scoreDescriptor instead')
const Score$json = {
  '1': 'Score',
  '2': [
    {'1': 'score_id', '3': 1, '4': 1, '5': 9, '10': 'scoreId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'formula_version', '3': 4, '4': 1, '5': 9, '10': 'formulaVersion'},
    {'1': 'total', '3': 5, '4': 1, '5': 5, '10': 'total'},
    {
      '1': 'inputs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.ScoreInput',
      '10': 'inputs'
    },
    {'1': 'missing', '3': 7, '4': 3, '5': 9, '10': 'missing'},
    {'1': 'complete', '3': 8, '4': 1, '5': 8, '10': 'complete'},
    {
      '1': 'calculated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'calculatedAt'
    },
    {'1': 'calculated_by', '3': 10, '4': 1, '5': 9, '10': 'calculatedBy'},
  ],
};

/// Descriptor for `Score`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreDescriptor = $convert.base64Decode(
    'CgVTY29yZRIZCghzY29yZV9pZBgBIAEoCVIHc2NvcmVJZBIdCgplcGlzb2RlX2lkGAIgASgJUg'
    'llcGlzb2RlSWQSEgoEbmFtZRgDIAEoCVIEbmFtZRInCg9mb3JtdWxhX3ZlcnNpb24YBCABKAlS'
    'DmZvcm11bGFWZXJzaW9uEhQKBXRvdGFsGAUgASgFUgV0b3RhbBI1CgZpbnB1dHMYBiADKAsyHS'
    '5oZWFsdGhjYXJlLmljdS52MS5TY29yZUlucHV0UgZpbnB1dHMSGAoHbWlzc2luZxgHIAMoCVIH'
    'bWlzc2luZxIaCghjb21wbGV0ZRgIIAEoCFIIY29tcGxldGUSPwoNY2FsY3VsYXRlZF9hdBgJIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGNhbGN1bGF0ZWRBdBIjCg1jYWxjdWxh'
    'dGVkX2J5GAogASgJUgxjYWxjdWxhdGVkQnk=');

@$core.Deprecated('Use bundleResultDescriptor instead')
const BundleResult$json = {
  '1': 'BundleResult',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.BundleItemState',
      '10': 'state'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BundleResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundleResultDescriptor = $convert.base64Decode(
    'CgxCdW5kbGVSZXN1bHQSEgoEY29kZRgBIAEoCVIEY29kZRI4CgVzdGF0ZRgCIAEoDjIiLmhlYW'
    'x0aGNhcmUuaWN1LnYxLkJ1bmRsZUl0ZW1TdGF0ZVIFc3RhdGUSFgoGcmVhc29uGAMgASgJUgZy'
    'ZWFzb24=');

@$core.Deprecated('Use bundlePerformanceDescriptor instead')
const BundlePerformance$json = {
  '1': 'BundlePerformance',
  '2': [
    {'1': 'performance_id', '3': 1, '4': 1, '5': 9, '10': 'performanceId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.BundleKind',
      '10': 'kind'
    },
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'version', '3': 5, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'results',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.BundleResult',
      '10': 'results'
    },
    {
      '1': 'performed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'performed_by', '3': 8, '4': 1, '5': 9, '10': 'performedBy'},
    {
      '1': 'compliance',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Compliance',
      '10': 'compliance'
    },
  ],
};

/// Descriptor for `BundlePerformance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bundlePerformanceDescriptor = $convert.base64Decode(
    'ChFCdW5kbGVQZXJmb3JtYW5jZRIlCg5wZXJmb3JtYW5jZV9pZBgBIAEoCVINcGVyZm9ybWFuY2'
    'VJZBIdCgplcGlzb2RlX2lkGAIgASgJUgllcGlzb2RlSWQSMQoEa2luZBgDIAEoDjIdLmhlYWx0'
    'aGNhcmUuaWN1LnYxLkJ1bmRsZUtpbmRSBGtpbmQSFAoFbGFiZWwYBCABKAlSBWxhYmVsEhgKB3'
    'ZlcnNpb24YBSABKAlSB3ZlcnNpb24SOQoHcmVzdWx0cxgGIAMoCzIfLmhlYWx0aGNhcmUuaWN1'
    'LnYxLkJ1bmRsZVJlc3VsdFIHcmVzdWx0cxI9CgxwZXJmb3JtZWRfYXQYByABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgtwZXJmb3JtZWRBdBIhCgxwZXJmb3JtZWRfYnkYCCABKAlS'
    'C3BlcmZvcm1lZEJ5Ej0KCmNvbXBsaWFuY2UYCSABKAsyHS5oZWFsdGhjYXJlLmljdS52MS5Db2'
    '1wbGlhbmNlUgpjb21wbGlhbmNl');

@$core.Deprecated('Use complianceDescriptor instead')
const Compliance$json = {
  '1': 'Compliance',
  '2': [
    {'1': 'required', '3': 1, '4': 1, '5': 5, '10': 'required'},
    {'1': 'done', '3': 2, '4': 1, '5': 5, '10': 'done'},
    {'1': 'excepted', '3': 3, '4': 1, '5': 5, '10': 'excepted'},
    {'1': 'missed', '3': 4, '4': 1, '5': 5, '10': 'missed'},
    {'1': 'compliant', '3': 5, '4': 1, '5': 8, '10': 'compliant'},
  ],
};

/// Descriptor for `Compliance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complianceDescriptor = $convert.base64Decode(
    'CgpDb21wbGlhbmNlEhoKCHJlcXVpcmVkGAEgASgFUghyZXF1aXJlZBISCgRkb25lGAIgASgFUg'
    'Rkb25lEhoKCGV4Y2VwdGVkGAMgASgFUghleGNlcHRlZBIWCgZtaXNzZWQYBCABKAVSBm1pc3Nl'
    'ZBIcCgljb21wbGlhbnQYBSABKAhSCWNvbXBsaWFudA==');

@$core.Deprecated('Use assessmentDescriptor instead')
const Assessment$json = {
  '1': 'Assessment',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'scale', '3': 4, '4': 1, '5': 9, '10': 'scale'},
    {'1': 'score', '3': 5, '4': 1, '5': 5, '9': 0, '10': 'score', '17': true},
    {
      '1': 'findings',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Assessment.FindingsEntry',
      '10': 'findings'
    },
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'performed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'performed_by', '3': 9, '4': 1, '5': 9, '10': 'performedBy'},
    {
      '1': 'next_due_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'nextDueAt'
    },
    {'1': 'overdue', '3': 11, '4': 1, '5': 8, '10': 'overdue'},
  ],
  '3': [Assessment_FindingsEntry$json],
  '8': [
    {'1': '_score'},
  ],
};

@$core.Deprecated('Use assessmentDescriptor instead')
const Assessment_FindingsEntry$json = {
  '1': 'FindingsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Assessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessmentDescriptor = $convert.base64Decode(
    'CgpBc3Nlc3NtZW50EiMKDWFzc2Vzc21lbnRfaWQYASABKAlSDGFzc2Vzc21lbnRJZBIdCgplcG'
    'lzb2RlX2lkGAIgASgJUgllcGlzb2RlSWQSEgoEa2luZBgDIAEoCVIEa2luZBIUCgVzY2FsZRgE'
    'IAEoCVIFc2NhbGUSGQoFc2NvcmUYBSABKAVIAFIFc2NvcmWIAQESRwoIZmluZGluZ3MYBiADKA'
    'syKy5oZWFsdGhjYXJlLmljdS52MS5Bc3Nlc3NtZW50LkZpbmRpbmdzRW50cnlSCGZpbmRpbmdz'
    'EhIKBG5vdGUYByABKAlSBG5vdGUSPQoMcGVyZm9ybWVkX2F0GAggASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFILcGVyZm9ybWVkQXQSIQoMcGVyZm9ybWVkX2J5GAkgASgJUgtwZXJm'
    'b3JtZWRCeRI6CgtuZXh0X2R1ZV9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCW5leHREdWVBdBIYCgdvdmVyZHVlGAsgASgIUgdvdmVyZHVlGjsKDUZpbmRpbmdzRW50cnkS'
    'EAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AUIICgZfc2NvcmU=');

@$core.Deprecated('Use roundDescriptor instead')
const Round$json = {
  '1': 'Round',
  '2': [
    {'1': 'round_id', '3': 1, '4': 1, '5': 9, '10': 'roundId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'attendance', '3': 3, '4': 3, '5': 9, '10': 'attendance'},
    {'1': 'summary', '3': 4, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'performed_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'performed_by', '3': 6, '4': 1, '5': 9, '10': 'performedBy'},
  ],
};

/// Descriptor for `Round`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roundDescriptor = $convert.base64Decode(
    'CgVSb3VuZBIZCghyb3VuZF9pZBgBIAEoCVIHcm91bmRJZBIdCgplcGlzb2RlX2lkGAIgASgJUg'
    'llcGlzb2RlSWQSHgoKYXR0ZW5kYW5jZRgDIAMoCVIKYXR0ZW5kYW5jZRIYCgdzdW1tYXJ5GAQg'
    'ASgJUgdzdW1tYXJ5Ej0KDHBlcmZvcm1lZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSC3BlcmZvcm1lZEF0EiEKDHBlcmZvcm1lZF9ieRgGIAEoCVILcGVyZm9ybWVkQnk=');

@$core.Deprecated('Use goalDescriptor instead')
const Goal$json = {
  '1': 'Goal',
  '2': [
    {'1': 'goal_id', '3': 1, '4': 1, '5': 9, '10': 'goalId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'round_id', '3': 3, '4': 1, '5': 9, '10': 'roundId'},
    {'1': 'domain', '3': 4, '4': 1, '5': 9, '10': 'domain'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'owner_role', '3': 6, '4': 1, '5': 9, '10': 'ownerRole'},
    {'1': 'owner_id', '3': 7, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.GoalStatus',
      '10': 'status'
    },
    {
      '1': 'target_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'targetAt'
    },
    {
      '1': 'resolved_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {'1': 'resolved_by', '3': 11, '4': 1, '5': 9, '10': 'resolvedBy'},
    {'1': 'outcome', '3': 12, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 14, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `Goal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalDescriptor = $convert.base64Decode(
    'CgRHb2FsEhcKB2dvYWxfaWQYASABKAlSBmdvYWxJZBIdCgplcGlzb2RlX2lkGAIgASgJUgllcG'
    'lzb2RlSWQSGQoIcm91bmRfaWQYAyABKAlSB3JvdW5kSWQSFgoGZG9tYWluGAQgASgJUgZkb21h'
    'aW4SEgoEdGV4dBgFIAEoCVIEdGV4dBIdCgpvd25lcl9yb2xlGAYgASgJUglvd25lclJvbGUSGQ'
    'oIb3duZXJfaWQYByABKAlSB293bmVySWQSNQoGc3RhdHVzGAggASgOMh0uaGVhbHRoY2FyZS5p'
    'Y3UudjEuR29hbFN0YXR1c1IGc3RhdHVzEjcKCXRhcmdldF9hdBgJIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSCHRhcmdldEF0EjsKC3Jlc29sdmVkX2F0GAogASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIKcmVzb2x2ZWRBdBIfCgtyZXNvbHZlZF9ieRgLIAEoCVIKcm'
    'Vzb2x2ZWRCeRIYCgdvdXRjb21lGAwgASgJUgdvdXRjb21lEjkKCmNyZWF0ZWRfYXQYDSABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgOIA'
    'EoCVIJY3JlYXRlZEJ5');

@$core.Deprecated('Use goalsOfCareDescriptor instead')
const GoalsOfCare$json = {
  '1': 'GoalsOfCare',
  '2': [
    {'1': 'goals_of_care_id', '3': 1, '4': 1, '5': 9, '10': 'goalsOfCareId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'intent',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.CareIntent',
      '10': 'intent'
    },
    {'1': 'limitations', '3': 4, '4': 3, '5': 9, '10': 'limitations'},
    {'1': 'cpr_status', '3': 5, '4': 1, '5': 9, '10': 'cprStatus'},
    {'1': 'discussed_with', '3': 6, '4': 1, '5': 9, '10': 'discussedWith'},
    {'1': 'rationale', '3': 7, '4': 1, '5': 9, '10': 'rationale'},
    {'1': 'authorised_by', '3': 8, '4': 1, '5': 9, '10': 'authorisedBy'},
    {'1': 'authorised_role', '3': 9, '4': 1, '5': 9, '10': 'authorisedRole'},
    {
      '1': 'recorded_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'superseded_by', '3': 12, '4': 1, '5': 9, '10': 'supersededBy'},
    {
      '1': 'superseded_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
    {
      '1': 'review_by',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewBy'
    },
    {'1': 'current', '3': 15, '4': 1, '5': 8, '10': 'current'},
    {'1': 'review_overdue', '3': 16, '4': 1, '5': 8, '10': 'reviewOverdue'},
  ],
};

/// Descriptor for `GoalsOfCare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalsOfCareDescriptor = $convert.base64Decode(
    'CgtHb2Fsc09mQ2FyZRInChBnb2Fsc19vZl9jYXJlX2lkGAEgASgJUg1nb2Fsc09mQ2FyZUlkEh'
    '0KCmVwaXNvZGVfaWQYAiABKAlSCWVwaXNvZGVJZBI1CgZpbnRlbnQYAyABKA4yHS5oZWFsdGhj'
    'YXJlLmljdS52MS5DYXJlSW50ZW50UgZpbnRlbnQSIAoLbGltaXRhdGlvbnMYBCADKAlSC2xpbW'
    'l0YXRpb25zEh0KCmNwcl9zdGF0dXMYBSABKAlSCWNwclN0YXR1cxIlCg5kaXNjdXNzZWRfd2l0'
    'aBgGIAEoCVINZGlzY3Vzc2VkV2l0aBIcCglyYXRpb25hbGUYByABKAlSCXJhdGlvbmFsZRIjCg'
    '1hdXRob3Jpc2VkX2J5GAggASgJUgxhdXRob3Jpc2VkQnkSJwoPYXV0aG9yaXNlZF9yb2xlGAkg'
    'ASgJUg5hdXRob3Jpc2VkUm9sZRI7CgtyZWNvcmRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSHwoLcmVjb3JkZWRfYnkYCyABKAlSCnJlY29yZGVk'
    'QnkSIwoNc3VwZXJzZWRlZF9ieRgMIAEoCVIMc3VwZXJzZWRlZEJ5Ej8KDXN1cGVyc2VkZWRfYX'
    'QYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxzdXBlcnNlZGVkQXQSNwoJcmV2'
    'aWV3X2J5GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmV2aWV3QnkSGAoHY3'
    'VycmVudBgPIAEoCFIHY3VycmVudBIlCg5yZXZpZXdfb3ZlcmR1ZRgQIAEoCFINcmV2aWV3T3Zl'
    'cmR1ZQ==');

@$core.Deprecated('Use alarmDescriptor instead')
const Alarm$json = {
  '1': 'Alarm',
  '2': [
    {'1': 'alarm_id', '3': 1, '4': 1, '5': 9, '10': 'alarmId'},
    {'1': 'episode_id', '3': 2, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {
      '1': 'severity',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.AlarmSeverity',
      '10': 'severity'
    },
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'raised_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
  ],
};

/// Descriptor for `Alarm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alarmDescriptor = $convert.base64Decode(
    'CgVBbGFybRIZCghhbGFybV9pZBgBIAEoCVIHYWxhcm1JZBIdCgplcGlzb2RlX2lkGAIgASgJUg'
    'llcGlzb2RlSWQSEgoEa2luZBgDIAEoCVIEa2luZBI8CghzZXZlcml0eRgEIAEoDjIgLmhlYWx0'
    'aGNhcmUuaWN1LnYxLkFsYXJtU2V2ZXJpdHlSCHNldmVyaXR5EhgKB3N1bW1hcnkYBSABKAlSB3'
    'N1bW1hcnkSNwoJcmFpc2VkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFII'
    'cmFpc2VkQXQ=');

@$core.Deprecated('Use dashboardValueDescriptor instead')
const DashboardValue$json = {
  '1': 'DashboardValue',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'value', '3': 3, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'observation_id', '3': 5, '4': 1, '5': 9, '10': 'observationId'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.ObservationSource',
      '10': 'source'
    },
    {
      '1': 'validation',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.ValidationState',
      '10': 'validation'
    },
    {'1': 'device_id', '3': 8, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'observed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'stale', '3': 10, '4': 1, '5': 8, '10': 'stale'},
  ],
};

/// Descriptor for `DashboardValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashboardValueDescriptor = $convert.base64Decode(
    'Cg5EYXNoYm9hcmRWYWx1ZRISCgRjb2RlGAEgASgJUgRjb2RlEhgKB2Rpc3BsYXkYAiABKAlSB2'
    'Rpc3BsYXkSFAoFdmFsdWUYAyABKAFSBXZhbHVlEhIKBHVuaXQYBCABKAlSBHVuaXQSJQoOb2Jz'
    'ZXJ2YXRpb25faWQYBSABKAlSDW9ic2VydmF0aW9uSWQSPAoGc291cmNlGAYgASgOMiQuaGVhbH'
    'RoY2FyZS5pY3UudjEuT2JzZXJ2YXRpb25Tb3VyY2VSBnNvdXJjZRJCCgp2YWxpZGF0aW9uGAcg'
    'ASgOMiIuaGVhbHRoY2FyZS5pY3UudjEuVmFsaWRhdGlvblN0YXRlUgp2YWxpZGF0aW9uEhsKCW'
    'RldmljZV9pZBgIIAEoCVIIZGV2aWNlSWQSOwoLb2JzZXJ2ZWRfYXQYCSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0EhQKBXN0YWxlGAogASgIUgVzdGFsZQ==');

@$core.Deprecated('Use dashboardRowDescriptor instead')
const DashboardRow$json = {
  '1': 'DashboardRow',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'bed_id', '3': 3, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'unit_id', '3': 4, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'display', '3': 5, '4': 1, '5': 9, '10': 'display'},
    {
      '1': 'vitals',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.DashboardValue',
      '10': 'vitals'
    },
    {
      '1': 'support',
      '3': 7,
      '4': 3,
      '5': 14,
      '6': '.healthcare.icu.v1.SupportKind',
      '10': 'support'
    },
    {'1': 'devices', '3': 8, '4': 1, '5': 5, '10': 'devices'},
    {'1': 'overdue_devices', '3': 9, '4': 1, '5': 5, '10': 'overdueDevices'},
    {'1': 'due_assessments', '3': 10, '4': 1, '5': 5, '10': 'dueAssessments'},
    {'1': 'open_goals', '3': 11, '4': 1, '5': 5, '10': 'openGoals'},
    {
      '1': 'balance',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Balance',
      '10': 'balance'
    },
    {
      '1': 'latest_score',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Score',
      '10': 'latestScore'
    },
    {
      '1': 'care_intent',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.CareIntent',
      '10': 'careIntent'
    },
    {'1': 'cpr_status', '3': 15, '4': 1, '5': 9, '10': 'cprStatus'},
    {
      '1': 'ceiling_restricted',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'ceilingRestricted'
    },
    {'1': 'stale_feeds', '3': 17, '4': 1, '5': 5, '10': 'staleFeeds'},
    {
      '1': 'admitted_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'admittedAt'
    },
    {
      '1': 'ready_for_transfer',
      '3': 19,
      '4': 1,
      '5': 8,
      '10': 'readyForTransfer'
    },
  ],
};

/// Descriptor for `DashboardRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dashboardRowDescriptor = $convert.base64Decode(
    'CgxEYXNoYm9hcmRSb3cSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEh0KCnBhdGllbn'
    'RfaWQYAiABKAlSCXBhdGllbnRJZBIVCgZiZWRfaWQYAyABKAlSBWJlZElkEhcKB3VuaXRfaWQY'
    'BCABKAlSBnVuaXRJZBIYCgdkaXNwbGF5GAUgASgJUgdkaXNwbGF5EjkKBnZpdGFscxgGIAMoCz'
    'IhLmhlYWx0aGNhcmUuaWN1LnYxLkRhc2hib2FyZFZhbHVlUgZ2aXRhbHMSOAoHc3VwcG9ydBgH'
    'IAMoDjIeLmhlYWx0aGNhcmUuaWN1LnYxLlN1cHBvcnRLaW5kUgdzdXBwb3J0EhgKB2RldmljZX'
    'MYCCABKAVSB2RldmljZXMSJwoPb3ZlcmR1ZV9kZXZpY2VzGAkgASgFUg5vdmVyZHVlRGV2aWNl'
    'cxInCg9kdWVfYXNzZXNzbWVudHMYCiABKAVSDmR1ZUFzc2Vzc21lbnRzEh0KCm9wZW5fZ29hbH'
    'MYCyABKAVSCW9wZW5Hb2FscxI0CgdiYWxhbmNlGAwgASgLMhouaGVhbHRoY2FyZS5pY3UudjEu'
    'QmFsYW5jZVIHYmFsYW5jZRI7CgxsYXRlc3Rfc2NvcmUYDSABKAsyGC5oZWFsdGhjYXJlLmljdS'
    '52MS5TY29yZVILbGF0ZXN0U2NvcmUSPgoLY2FyZV9pbnRlbnQYDiABKA4yHS5oZWFsdGhjYXJl'
    'LmljdS52MS5DYXJlSW50ZW50UgpjYXJlSW50ZW50Eh0KCmNwcl9zdGF0dXMYDyABKAlSCWNwcl'
    'N0YXR1cxItChJjZWlsaW5nX3Jlc3RyaWN0ZWQYECABKAhSEWNlaWxpbmdSZXN0cmljdGVkEh8K'
    'C3N0YWxlX2ZlZWRzGBEgASgFUgpzdGFsZUZlZWRzEjsKC2FkbWl0dGVkX2F0GBIgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYWRtaXR0ZWRBdBIsChJyZWFkeV9mb3JfdHJhbnNm'
    'ZXIYEyABKAhSEHJlYWR5Rm9yVHJhbnNmZXI=');

@$core.Deprecated('Use unitMetricsDescriptor instead')
const UnitMetrics$json = {
  '1': 'UnitMetrics',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
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
    {'1': 'admissions', '3': 4, '4': 1, '5': 5, '10': 'admissions'},
    {'1': 'discharges', '3': 5, '4': 1, '5': 5, '10': 'discharges'},
    {'1': 'deaths', '3': 6, '4': 1, '5': 5, '10': 'deaths'},
    {'1': 'bed_days', '3': 7, '4': 1, '5': 5, '10': 'bedDays'},
    {'1': 'ventilator_days', '3': 8, '4': 1, '5': 5, '10': 'ventilatorDays'},
    {
      '1': 'device_days',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.UnitMetrics.DeviceDaysEntry',
      '10': 'deviceDays'
    },
    {
      '1': 'mean_length_of_stay_hours',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'meanLengthOfStayHours'
    },
    {'1': 'closed_episodes', '3': 11, '4': 1, '5': 5, '10': 'closedEpisodes'},
    {
      '1': 'mean_discharge_delay_hours',
      '3': 12,
      '4': 1,
      '5': 1,
      '10': 'meanDischargeDelayHours'
    },
    {
      '1': 'delayed_discharges',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'delayedDischarges'
    },
  ],
  '3': [UnitMetrics_DeviceDaysEntry$json],
};

@$core.Deprecated('Use unitMetricsDescriptor instead')
const UnitMetrics_DeviceDaysEntry$json = {
  '1': 'DeviceDaysEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UnitMetrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unitMetricsDescriptor = $convert.base64Decode(
    'CgtVbml0TWV0cmljcxIXCgd1bml0X2lkGAEgASgJUgZ1bml0SWQSLgoEZnJvbRgCIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAyABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUgJ0bxIeCgphZG1pc3Npb25zGAQgASgFUgphZG1pc3Npb25zEh4KCm'
    'Rpc2NoYXJnZXMYBSABKAVSCmRpc2NoYXJnZXMSFgoGZGVhdGhzGAYgASgFUgZkZWF0aHMSGQoI'
    'YmVkX2RheXMYByABKAVSB2JlZERheXMSJwoPdmVudGlsYXRvcl9kYXlzGAggASgFUg52ZW50aW'
    'xhdG9yRGF5cxJPCgtkZXZpY2VfZGF5cxgJIAMoCzIuLmhlYWx0aGNhcmUuaWN1LnYxLlVuaXRN'
    'ZXRyaWNzLkRldmljZURheXNFbnRyeVIKZGV2aWNlRGF5cxI4ChltZWFuX2xlbmd0aF9vZl9zdG'
    'F5X2hvdXJzGAogASgBUhVtZWFuTGVuZ3RoT2ZTdGF5SG91cnMSJwoPY2xvc2VkX2VwaXNvZGVz'
    'GAsgASgFUg5jbG9zZWRFcGlzb2RlcxI7ChptZWFuX2Rpc2NoYXJnZV9kZWxheV9ob3VycxgMIA'
    'EoAVIXbWVhbkRpc2NoYXJnZURlbGF5SG91cnMSLQoSZGVsYXllZF9kaXNjaGFyZ2VzGA0gASgF'
    'UhFkZWxheWVkRGlzY2hhcmdlcxo9Cg9EZXZpY2VEYXlzRW50cnkSEAoDa2V5GAEgASgJUgNrZX'
    'kSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use admitRequestDescriptor instead')
const AdmitRequest$json = {
  '1': 'AdmitRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 4, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'bed_id', '3': 5, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.AdmissionSource',
      '10': 'source'
    },
    {'1': 'transferred_from', '3': 7, '4': 1, '5': 9, '10': 'transferredFrom'},
    {'1': 'responsible_team', '3': 8, '4': 1, '5': 9, '10': 'responsibleTeam'},
    {
      '1': 'responsible_clinician',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'responsibleClinician'
    },
    {
      '1': 'admitted_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'admittedAt'
    },
  ],
};

/// Descriptor for `AdmitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List admitRequestDescriptor = $convert.base64Decode(
    'CgxBZG1pdFJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZBIdCgpwYX'
    'RpZW50X2lkGAIgASgJUglwYXRpZW50SWQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5'
    'SWQSFwoHdW5pdF9pZBgEIAEoCVIGdW5pdElkEhUKBmJlZF9pZBgFIAEoCVIFYmVkSWQSOgoGc2'
    '91cmNlGAYgASgOMiIuaGVhbHRoY2FyZS5pY3UudjEuQWRtaXNzaW9uU291cmNlUgZzb3VyY2US'
    'KQoQdHJhbnNmZXJyZWRfZnJvbRgHIAEoCVIPdHJhbnNmZXJyZWRGcm9tEikKEHJlc3BvbnNpYm'
    'xlX3RlYW0YCCABKAlSD3Jlc3BvbnNpYmxlVGVhbRIzChVyZXNwb25zaWJsZV9jbGluaWNpYW4Y'
    'CSABKAlSFHJlc3BvbnNpYmxlQ2xpbmljaWFuEjsKC2FkbWl0dGVkX2F0GAogASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYWRtaXR0ZWRBdA==');

@$core.Deprecated('Use admitResponseDescriptor instead')
const AdmitResponse$json = {
  '1': 'AdmitResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.IcuEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `AdmitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List admitResponseDescriptor = $convert.base64Decode(
    'Cg1BZG1pdFJlc3BvbnNlEjcKB2VwaXNvZGUYASABKAsyHS5oZWFsdGhjYXJlLmljdS52MS5JY3'
    'VFcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use getIcuEpisodeRequestDescriptor instead')
const GetIcuEpisodeRequest$json = {
  '1': 'GetIcuEpisodeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `GetIcuEpisodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIcuEpisodeRequestDescriptor = $convert.base64Decode(
    'ChRHZXRJY3VFcGlzb2RlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQ=');

@$core.Deprecated('Use getIcuEpisodeResponseDescriptor instead')
const GetIcuEpisodeResponse$json = {
  '1': 'GetIcuEpisodeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.IcuEpisode',
      '10': 'episode'
    },
    {
      '1': 'support',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Support',
      '10': 'support'
    },
    {
      '1': 'devices',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.InvasiveDevice',
      '10': 'devices'
    },
    {
      '1': 'infusions',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Infusion',
      '10': 'infusions'
    },
    {
      '1': 'open_goals',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Goal',
      '10': 'openGoals'
    },
    {
      '1': 'ceiling',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.GoalsOfCare',
      '10': 'ceiling'
    },
    {
      '1': 'ceiling_restricted',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'ceilingRestricted'
    },
  ],
};

/// Descriptor for `GetIcuEpisodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIcuEpisodeResponseDescriptor = $convert.base64Decode(
    'ChVHZXRJY3VFcGlzb2RlUmVzcG9uc2USNwoHZXBpc29kZRgBIAEoCzIdLmhlYWx0aGNhcmUuaW'
    'N1LnYxLkljdUVwaXNvZGVSB2VwaXNvZGUSNAoHc3VwcG9ydBgCIAMoCzIaLmhlYWx0aGNhcmUu'
    'aWN1LnYxLlN1cHBvcnRSB3N1cHBvcnQSOwoHZGV2aWNlcxgDIAMoCzIhLmhlYWx0aGNhcmUuaW'
    'N1LnYxLkludmFzaXZlRGV2aWNlUgdkZXZpY2VzEjkKCWluZnVzaW9ucxgEIAMoCzIbLmhlYWx0'
    'aGNhcmUuaWN1LnYxLkluZnVzaW9uUglpbmZ1c2lvbnMSNgoKb3Blbl9nb2FscxgFIAMoCzIXLm'
    'hlYWx0aGNhcmUuaWN1LnYxLkdvYWxSCW9wZW5Hb2FscxI4CgdjZWlsaW5nGAYgASgLMh4uaGVh'
    'bHRoY2FyZS5pY3UudjEuR29hbHNPZkNhcmVSB2NlaWxpbmcSLQoSY2VpbGluZ19yZXN0cmljdG'
    'VkGAcgASgIUhFjZWlsaW5nUmVzdHJpY3RlZA==');

@$core.Deprecated('Use moveBedRequestDescriptor instead')
const MoveBedRequest$json = {
  '1': 'MoveBedRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'bed_id', '3': 2, '4': 1, '5': 9, '10': 'bedId'},
  ],
};

/// Descriptor for `MoveBedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveBedRequestDescriptor = $convert.base64Decode(
    'Cg5Nb3ZlQmVkUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSFQoGYmVkX2'
    'lkGAIgASgJUgViZWRJZA==');

@$core.Deprecated('Use moveBedResponseDescriptor instead')
const MoveBedResponse$json = {
  '1': 'MoveBedResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.IcuEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `MoveBedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveBedResponseDescriptor = $convert.base64Decode(
    'Cg9Nb3ZlQmVkUmVzcG9uc2USNwoHZXBpc29kZRgBIAEoCzIdLmhlYWx0aGNhcmUuaWN1LnYxLk'
    'ljdUVwaXNvZGVSB2VwaXNvZGU=');

@$core.Deprecated('Use declareReadyRequestDescriptor instead')
const DeclareReadyRequest$json = {
  '1': 'DeclareReadyRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `DeclareReadyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declareReadyRequestDescriptor = $convert.base64Decode(
    'ChNEZWNsYXJlUmVhZHlSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZA==');

@$core.Deprecated('Use declareReadyResponseDescriptor instead')
const DeclareReadyResponse$json = {
  '1': 'DeclareReadyResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.IcuEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `DeclareReadyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declareReadyResponseDescriptor = $convert.base64Decode(
    'ChREZWNsYXJlUmVhZHlSZXNwb25zZRI3CgdlcGlzb2RlGAEgASgLMh0uaGVhbHRoY2FyZS5pY3'
    'UudjEuSWN1RXBpc29kZVIHZXBpc29kZQ==');

@$core.Deprecated('Use dischargeRequestDescriptor instead')
const DischargeRequest$json = {
  '1': 'DischargeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.EpisodeOutcome',
      '10': 'outcome'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'medications_reconciled',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'medicationsReconciled'
    },
    {'1': 'devices_listed', '3': 5, '4': 1, '5': 8, '10': 'devicesListed'},
    {'1': 'tasks_handed_over', '3': 6, '4': 1, '5': 8, '10': 'tasksHandedOver'},
    {'1': 'summary_written', '3': 7, '4': 1, '5': 8, '10': 'summaryWritten'},
  ],
};

/// Descriptor for `DischargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeRequestDescriptor = $convert.base64Decode(
    'ChBEaXNjaGFyZ2VSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBI7CgdvdX'
    'Rjb21lGAIgASgOMiEuaGVhbHRoY2FyZS5pY3UudjEuRXBpc29kZU91dGNvbWVSB291dGNvbWUS'
    'EgoEbm90ZRgDIAEoCVIEbm90ZRI1ChZtZWRpY2F0aW9uc19yZWNvbmNpbGVkGAQgASgIUhVtZW'
    'RpY2F0aW9uc1JlY29uY2lsZWQSJQoOZGV2aWNlc19saXN0ZWQYBSABKAhSDWRldmljZXNMaXN0'
    'ZWQSKgoRdGFza3NfaGFuZGVkX292ZXIYBiABKAhSD3Rhc2tzSGFuZGVkT3ZlchInCg9zdW1tYX'
    'J5X3dyaXR0ZW4YByABKAhSDnN1bW1hcnlXcml0dGVu');

@$core.Deprecated('Use dischargeResponseDescriptor instead')
const DischargeResponse$json = {
  '1': 'DischargeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.IcuEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `DischargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeResponseDescriptor = $convert.base64Decode(
    'ChFEaXNjaGFyZ2VSZXNwb25zZRI3CgdlcGlzb2RlGAEgASgLMh0uaGVhbHRoY2FyZS5pY3Uudj'
    'EuSWN1RXBpc29kZVIHZXBpc29kZQ==');

@$core.Deprecated('Use chartValueRequestDescriptor instead')
const ChartValueRequest$json = {
  '1': 'ChartValueRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'code_system', '3': 2, '4': 1, '5': 9, '10': 'codeSystem'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 4, '4': 1, '5': 9, '10': 'display'},
    {'1': 'dimension', '3': 5, '4': 1, '5': 9, '10': 'dimension'},
    {'1': 'value', '3': 6, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 7, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.ObservationSource',
      '10': 'source'
    },
    {
      '1': 'device',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.DeviceSource',
      '10': 'device'
    },
    {
      '1': 'observed_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
};

/// Descriptor for `ChartValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartValueRequestDescriptor = $convert.base64Decode(
    'ChFDaGFydFZhbHVlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSHwoLY2'
    '9kZV9zeXN0ZW0YAiABKAlSCmNvZGVTeXN0ZW0SEgoEY29kZRgDIAEoCVIEY29kZRIYCgdkaXNw'
    'bGF5GAQgASgJUgdkaXNwbGF5EhwKCWRpbWVuc2lvbhgFIAEoCVIJZGltZW5zaW9uEhQKBXZhbH'
    'VlGAYgASgBUgV2YWx1ZRISCgR1bml0GAcgASgJUgR1bml0EjwKBnNvdXJjZRgIIAEoDjIkLmhl'
    'YWx0aGNhcmUuaWN1LnYxLk9ic2VydmF0aW9uU291cmNlUgZzb3VyY2USNwoGZGV2aWNlGAkgAS'
    'gLMh8uaGVhbHRoY2FyZS5pY3UudjEuRGV2aWNlU291cmNlUgZkZXZpY2USOwoLb2JzZXJ2ZWRf'
    'YXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0');

@$core.Deprecated('Use chartValueResponseDescriptor instead')
const ChartValueResponse$json = {
  '1': 'ChartValueResponse',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Observation',
      '10': 'observation'
    },
  ],
};

/// Descriptor for `ChartValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartValueResponseDescriptor = $convert.base64Decode(
    'ChJDaGFydFZhbHVlUmVzcG9uc2USQAoLb2JzZXJ2YXRpb24YASABKAsyHi5oZWFsdGhjYXJlLm'
    'ljdS52MS5PYnNlcnZhdGlvblILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use decideReadingRequestDescriptor instead')
const DecideReadingRequest$json = {
  '1': 'DecideReadingRequest',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'accept', '3': 2, '4': 1, '5': 8, '10': 'accept'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `DecideReadingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideReadingRequestDescriptor = $convert.base64Decode(
    'ChREZWNpZGVSZWFkaW5nUmVxdWVzdBIlCg5vYnNlcnZhdGlvbl9pZBgBIAEoCVINb2JzZXJ2YX'
    'Rpb25JZBIWCgZhY2NlcHQYAiABKAhSBmFjY2VwdBISCgRub3RlGAMgASgJUgRub3Rl');

@$core.Deprecated('Use decideReadingResponseDescriptor instead')
const DecideReadingResponse$json = {
  '1': 'DecideReadingResponse',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Observation',
      '10': 'observation'
    },
  ],
};

/// Descriptor for `DecideReadingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideReadingResponseDescriptor = $convert.base64Decode(
    'ChVEZWNpZGVSZWFkaW5nUmVzcG9uc2USQAoLb2JzZXJ2YXRpb24YASABKAsyHi5oZWFsdGhjYX'
    'JlLmljdS52MS5PYnNlcnZhdGlvblILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use listFlowsheetRequestDescriptor instead')
const ListFlowsheetRequest$json = {
  '1': 'ListFlowsheetRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'since',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'since'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListFlowsheetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFlowsheetRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0Rmxvd3NoZWV0UmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSMA'
    'oFc2luY2UYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgVzaW5jZRIbCglwYWdl'
    'X3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listFlowsheetResponseDescriptor instead')
const ListFlowsheetResponse$json = {
  '1': 'ListFlowsheetResponse',
  '2': [
    {
      '1': 'observations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Observation',
      '10': 'observations'
    },
  ],
};

/// Descriptor for `ListFlowsheetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFlowsheetResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Rmxvd3NoZWV0UmVzcG9uc2USQgoMb2JzZXJ2YXRpb25zGAEgAygLMh4uaGVhbHRoY2'
    'FyZS5pY3UudjEuT2JzZXJ2YXRpb25SDG9ic2VydmF0aW9ucw==');

@$core.Deprecated('Use listPendingReadingsRequestDescriptor instead')
const ListPendingReadingsRequest$json = {
  '1': 'ListPendingReadingsRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPendingReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPendingReadingsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UGVuZGluZ1JlYWRpbmdzUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2'
        'RlSWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listPendingReadingsResponseDescriptor instead')
const ListPendingReadingsResponse$json = {
  '1': 'ListPendingReadingsResponse',
  '2': [
    {
      '1': 'observations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Observation',
      '10': 'observations'
    },
  ],
};

/// Descriptor for `ListPendingReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPendingReadingsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UGVuZGluZ1JlYWRpbmdzUmVzcG9uc2USQgoMb2JzZXJ2YXRpb25zGAEgAygLMh4uaG'
        'VhbHRoY2FyZS5pY3UudjEuT2JzZXJ2YXRpb25SDG9ic2VydmF0aW9ucw==');

@$core.Deprecated('Use recordBalanceRequestDescriptor instead')
const RecordBalanceRequest$json = {
  '1': 'RecordBalanceRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'direction', '3': 2, '4': 1, '5': 9, '10': 'direction'},
    {'1': 'route', '3': 3, '4': 1, '5': 9, '10': 'route'},
    {'1': 'volume', '3': 4, '4': 1, '5': 1, '10': 'volume'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'occurred_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'corrects', '3': 7, '4': 1, '5': 9, '10': 'corrects'},
    {
      '1': 'correction_reason',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'correctionReason'
    },
  ],
};

/// Descriptor for `RecordBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordBalanceRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRCYWxhbmNlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSHA'
    'oJZGlyZWN0aW9uGAIgASgJUglkaXJlY3Rpb24SFAoFcm91dGUYAyABKAlSBXJvdXRlEhYKBnZv'
    'bHVtZRgEIAEoAVIGdm9sdW1lEhIKBHVuaXQYBSABKAlSBHVuaXQSOwoLb2NjdXJyZWRfYXQYBi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZEF0EhoKCGNvcnJlY3Rz'
    'GAcgASgJUghjb3JyZWN0cxIrChFjb3JyZWN0aW9uX3JlYXNvbhgIIAEoCVIQY29ycmVjdGlvbl'
    'JlYXNvbg==');

@$core.Deprecated('Use recordBalanceResponseDescriptor instead')
const RecordBalanceResponse$json = {
  '1': 'RecordBalanceResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.BalanceEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `RecordBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordBalanceResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRCYWxhbmNlUmVzcG9uc2USNQoFZW50cnkYASABKAsyHy5oZWFsdGhjYXJlLmljdS'
    '52MS5CYWxhbmNlRW50cnlSBWVudHJ5');

@$core.Deprecated('Use getBalanceRequestDescriptor instead')
const GetBalanceRequest$json = {
  '1': 'GetBalanceRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
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

/// Descriptor for `GetBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceRequestDescriptor = $convert.base64Decode(
    'ChFHZXRCYWxhbmNlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSLgoEZn'
    'JvbRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAyABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bw==');

@$core.Deprecated('Use getBalanceResponseDescriptor instead')
const GetBalanceResponse$json = {
  '1': 'GetBalanceResponse',
  '2': [
    {
      '1': 'total',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Balance',
      '10': 'total'
    },
    {
      '1': 'hourly',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Balance',
      '10': 'hourly'
    },
  ],
};

/// Descriptor for `GetBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceResponseDescriptor = $convert.base64Decode(
    'ChJHZXRCYWxhbmNlUmVzcG9uc2USMAoFdG90YWwYASABKAsyGi5oZWFsdGhjYXJlLmljdS52MS'
    '5CYWxhbmNlUgV0b3RhbBIyCgZob3VybHkYAiADKAsyGi5oZWFsdGhjYXJlLmljdS52MS5CYWxh'
    'bmNlUgZob3VybHk=');

@$core.Deprecated('Use startSupportRequestDescriptor instead')
const StartSupportRequest$json = {
  '1': 'StartSupportRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.SupportKind',
      '10': 'kind'
    },
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'modality', '3': 4, '4': 1, '5': 9, '10': 'modality'},
    {
      '1': 'started_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartSupportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSupportRequestDescriptor = $convert.base64Decode(
    'ChNTdGFydFN1cHBvcnRSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBIyCg'
    'RraW5kGAIgASgOMh4uaGVhbHRoY2FyZS5pY3UudjEuU3VwcG9ydEtpbmRSBGtpbmQSFAoFbGFi'
    'ZWwYAyABKAlSBWxhYmVsEhoKCG1vZGFsaXR5GAQgASgJUghtb2RhbGl0eRI5CgpzdGFydGVkX2'
    'F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0');

@$core.Deprecated('Use startSupportResponseDescriptor instead')
const StartSupportResponse$json = {
  '1': 'StartSupportResponse',
  '2': [
    {
      '1': 'support',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Support',
      '10': 'support'
    },
  ],
};

/// Descriptor for `StartSupportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startSupportResponseDescriptor = $convert.base64Decode(
    'ChRTdGFydFN1cHBvcnRSZXNwb25zZRI0CgdzdXBwb3J0GAEgASgLMhouaGVhbHRoY2FyZS5pY3'
    'UudjEuU3VwcG9ydFIHc3VwcG9ydA==');

@$core.Deprecated('Use stopSupportRequestDescriptor instead')
const StopSupportRequest$json = {
  '1': 'StopSupportRequest',
  '2': [
    {'1': 'support_id', '3': 1, '4': 1, '5': 9, '10': 'supportId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'stopped_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
  ],
};

/// Descriptor for `StopSupportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSupportRequestDescriptor = $convert.base64Decode(
    'ChJTdG9wU3VwcG9ydFJlcXVlc3QSHQoKc3VwcG9ydF9pZBgBIAEoCVIJc3VwcG9ydElkEhIKBG'
    '5vdGUYAiABKAlSBG5vdGUSOQoKc3RvcHBlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCXN0b3BwZWRBdA==');

@$core.Deprecated('Use stopSupportResponseDescriptor instead')
const StopSupportResponse$json = {
  '1': 'StopSupportResponse',
};

/// Descriptor for `StopSupportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSupportResponseDescriptor =
    $convert.base64Decode('ChNTdG9wU3VwcG9ydFJlc3BvbnNl');

@$core.Deprecated('Use listSupportRequestDescriptor instead')
const ListSupportRequest$json = {
  '1': 'ListSupportRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListSupportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSupportRequestDescriptor =
    $convert.base64Decode(
        'ChJMaXN0U3VwcG9ydFJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlk');

@$core.Deprecated('Use listSupportResponseDescriptor instead')
const ListSupportResponse$json = {
  '1': 'ListSupportResponse',
  '2': [
    {
      '1': 'support',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Support',
      '10': 'support'
    },
  ],
};

/// Descriptor for `ListSupportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSupportResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0U3VwcG9ydFJlc3BvbnNlEjQKB3N1cHBvcnQYASADKAsyGi5oZWFsdGhjYXJlLmljdS'
    '52MS5TdXBwb3J0UgdzdXBwb3J0');

@$core.Deprecated('Use recordVentSettingRequestDescriptor instead')
const RecordVentSettingRequest$json = {
  '1': 'RecordVentSettingRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'support_id', '3': 2, '4': 1, '5': 9, '10': 'supportId'},
    {'1': 'mode', '3': 3, '4': 1, '5': 9, '10': 'mode'},
    {
      '1': 'parameters',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.RecordVentSettingRequest.ParametersEntry',
      '10': 'parameters'
    },
    {
      '1': 'measured',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.RecordVentSettingRequest.MeasuredEntry',
      '10': 'measured'
    },
    {
      '1': 'units',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.RecordVentSettingRequest.UnitsEntry',
      '10': 'units'
    },
    {'1': 'device_id', '3': 7, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'effective_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {'1': 'change_reason', '3': 9, '4': 1, '5': 9, '10': 'changeReason'},
  ],
  '3': [
    RecordVentSettingRequest_ParametersEntry$json,
    RecordVentSettingRequest_MeasuredEntry$json,
    RecordVentSettingRequest_UnitsEntry$json
  ],
};

@$core.Deprecated('Use recordVentSettingRequestDescriptor instead')
const RecordVentSettingRequest_ParametersEntry$json = {
  '1': 'ParametersEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use recordVentSettingRequestDescriptor instead')
const RecordVentSettingRequest_MeasuredEntry$json = {
  '1': 'MeasuredEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use recordVentSettingRequestDescriptor instead')
const RecordVentSettingRequest_UnitsEntry$json = {
  '1': 'UnitsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RecordVentSettingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordVentSettingRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRWZW50U2V0dGluZ1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZU'
    'lkEh0KCnN1cHBvcnRfaWQYAiABKAlSCXN1cHBvcnRJZBISCgRtb2RlGAMgASgJUgRtb2RlElsK'
    'CnBhcmFtZXRlcnMYBCADKAsyOy5oZWFsdGhjYXJlLmljdS52MS5SZWNvcmRWZW50U2V0dGluZ1'
    'JlcXVlc3QuUGFyYW1ldGVyc0VudHJ5UgpwYXJhbWV0ZXJzElUKCG1lYXN1cmVkGAUgAygLMjku'
    'aGVhbHRoY2FyZS5pY3UudjEuUmVjb3JkVmVudFNldHRpbmdSZXF1ZXN0Lk1lYXN1cmVkRW50cn'
    'lSCG1lYXN1cmVkEkwKBXVuaXRzGAYgAygLMjYuaGVhbHRoY2FyZS5pY3UudjEuUmVjb3JkVmVu'
    'dFNldHRpbmdSZXF1ZXN0LlVuaXRzRW50cnlSBXVuaXRzEhsKCWRldmljZV9pZBgHIAEoCVIIZG'
    'V2aWNlSWQSPQoMZWZmZWN0aXZlX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFILZWZmZWN0aXZlQXQSIwoNY2hhbmdlX3JlYXNvbhgJIAEoCVIMY2hhbmdlUmVhc29uGj0KD1'
    'BhcmFtZXRlcnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoAVIFdmFsdWU6'
    'AjgBGjsKDU1lYXN1cmVkRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAFSBX'
    'ZhbHVlOgI4ARo4CgpVbml0c0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJ'
    'UgV2YWx1ZToCOAE=');

@$core.Deprecated('Use recordVentSettingResponseDescriptor instead')
const RecordVentSettingResponse$json = {
  '1': 'RecordVentSettingResponse',
  '2': [
    {
      '1': 'setting',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.VentSetting',
      '10': 'setting'
    },
  ],
};

/// Descriptor for `RecordVentSettingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordVentSettingResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRWZW50U2V0dGluZ1Jlc3BvbnNlEjgKB3NldHRpbmcYASABKAsyHi5oZWFsdGhjYX'
        'JlLmljdS52MS5WZW50U2V0dGluZ1IHc2V0dGluZw==');

@$core.Deprecated('Use getVentTimelineRequestDescriptor instead')
const GetVentTimelineRequest$json = {
  '1': 'GetVentTimelineRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `GetVentTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVentTimelineRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRWZW50VGltZWxpbmVSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZA'
        '==');

@$core.Deprecated('Use getVentTimelineResponseDescriptor instead')
const GetVentTimelineResponse$json = {
  '1': 'GetVentTimelineResponse',
  '2': [
    {
      '1': 'settings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.VentSetting',
      '10': 'settings'
    },
  ],
};

/// Descriptor for `GetVentTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getVentTimelineResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRWZW50VGltZWxpbmVSZXNwb25zZRI6CghzZXR0aW5ncxgBIAMoCzIeLmhlYWx0aGNhcm'
        'UuaWN1LnYxLlZlbnRTZXR0aW5nUghzZXR0aW5ncw==');

@$core.Deprecated('Use startInfusionRequestDescriptor instead')
const StartInfusionRequest$json = {
  '1': 'StartInfusionRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'prescription_id', '3': 2, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'drug_code', '3': 3, '4': 1, '5': 9, '10': 'drugCode'},
    {'1': 'drug_display', '3': 4, '4': 1, '5': 9, '10': 'drugDisplay'},
    {
      '1': 'concentration_amount',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'concentrationAmount'
    },
    {
      '1': 'concentration_unit',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'concentrationUnit'
    },
    {
      '1': 'concentration_volume',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'concentrationVolume'
    },
    {'1': 'dose_unit', '3': 8, '4': 1, '5': 9, '10': 'doseUnit'},
    {'1': 'weight_kg', '3': 9, '4': 1, '5': 1, '10': 'weightKg'},
    {
      '1': 'started_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartInfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startInfusionRequestDescriptor = $convert.base64Decode(
    'ChRTdGFydEluZnVzaW9uUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSJw'
    'oPcHJlc2NyaXB0aW9uX2lkGAIgASgJUg5wcmVzY3JpcHRpb25JZBIbCglkcnVnX2NvZGUYAyAB'
    'KAlSCGRydWdDb2RlEiEKDGRydWdfZGlzcGxheRgEIAEoCVILZHJ1Z0Rpc3BsYXkSMQoUY29uY2'
    'VudHJhdGlvbl9hbW91bnQYBSABKAFSE2NvbmNlbnRyYXRpb25BbW91bnQSLQoSY29uY2VudHJh'
    'dGlvbl91bml0GAYgASgJUhFjb25jZW50cmF0aW9uVW5pdBIxChRjb25jZW50cmF0aW9uX3ZvbH'
    'VtZRgHIAEoAVITY29uY2VudHJhdGlvblZvbHVtZRIbCglkb3NlX3VuaXQYCCABKAlSCGRvc2VV'
    'bml0EhsKCXdlaWdodF9rZxgJIAEoAVIId2VpZ2h0S2cSOQoKc3RhcnRlZF9hdBgKIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdA==');

@$core.Deprecated('Use startInfusionResponseDescriptor instead')
const StartInfusionResponse$json = {
  '1': 'StartInfusionResponse',
  '2': [
    {
      '1': 'infusion',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Infusion',
      '10': 'infusion'
    },
  ],
};

/// Descriptor for `StartInfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startInfusionResponseDescriptor = $convert.base64Decode(
    'ChVTdGFydEluZnVzaW9uUmVzcG9uc2USNwoIaW5mdXNpb24YASABKAsyGy5oZWFsdGhjYXJlLm'
    'ljdS52MS5JbmZ1c2lvblIIaW5mdXNpb24=');

@$core.Deprecated('Use titrateRequestDescriptor instead')
const TitrateRequest$json = {
  '1': 'TitrateRequest',
  '2': [
    {'1': 'infusion_id', '3': 1, '4': 1, '5': 9, '10': 'infusionId'},
    {'1': 'rate', '3': 2, '4': 1, '5': 1, '10': 'rate'},
    {'1': 'rate_unit', '3': 3, '4': 1, '5': 9, '10': 'rateUnit'},
    {'1': 'dose', '3': 4, '4': 1, '5': 1, '10': 'dose'},
    {
      '1': 'effective_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {'1': 'device_id', '3': 6, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `TitrateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List titrateRequestDescriptor = $convert.base64Decode(
    'Cg5UaXRyYXRlUmVxdWVzdBIfCgtpbmZ1c2lvbl9pZBgBIAEoCVIKaW5mdXNpb25JZBISCgRyYX'
    'RlGAIgASgBUgRyYXRlEhsKCXJhdGVfdW5pdBgDIAEoCVIIcmF0ZVVuaXQSEgoEZG9zZRgEIAEo'
    'AVIEZG9zZRI9CgxlZmZlY3RpdmVfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgtlZmZlY3RpdmVBdBIbCglkZXZpY2VfaWQYBiABKAlSCGRldmljZUlkEhYKBnJlYXNvbhgH'
    'IAEoCVIGcmVhc29u');

@$core.Deprecated('Use titrateResponseDescriptor instead')
const TitrateResponse$json = {
  '1': 'TitrateResponse',
  '2': [
    {
      '1': 'titration',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Titration',
      '10': 'titration'
    },
  ],
};

/// Descriptor for `TitrateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List titrateResponseDescriptor = $convert.base64Decode(
    'Cg9UaXRyYXRlUmVzcG9uc2USOgoJdGl0cmF0aW9uGAEgASgLMhwuaGVhbHRoY2FyZS5pY3Uudj'
    'EuVGl0cmF0aW9uUgl0aXRyYXRpb24=');

@$core.Deprecated('Use stopInfusionRequestDescriptor instead')
const StopInfusionRequest$json = {
  '1': 'StopInfusionRequest',
  '2': [
    {'1': 'infusion_id', '3': 1, '4': 1, '5': 9, '10': 'infusionId'},
  ],
};

/// Descriptor for `StopInfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopInfusionRequestDescriptor = $convert.base64Decode(
    'ChNTdG9wSW5mdXNpb25SZXF1ZXN0Eh8KC2luZnVzaW9uX2lkGAEgASgJUgppbmZ1c2lvbklk');

@$core.Deprecated('Use stopInfusionResponseDescriptor instead')
const StopInfusionResponse$json = {
  '1': 'StopInfusionResponse',
};

/// Descriptor for `StopInfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopInfusionResponseDescriptor =
    $convert.base64Decode('ChRTdG9wSW5mdXNpb25SZXNwb25zZQ==');

@$core.Deprecated('Use listInfusionsRequestDescriptor instead')
const ListInfusionsRequest$json = {
  '1': 'ListInfusionsRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListInfusionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInfusionsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0SW5mdXNpb25zUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQ=');

@$core.Deprecated('Use listInfusionsResponseDescriptor instead')
const ListInfusionsResponse$json = {
  '1': 'ListInfusionsResponse',
  '2': [
    {
      '1': 'infusions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Infusion',
      '10': 'infusions'
    },
  ],
};

/// Descriptor for `ListInfusionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInfusionsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0SW5mdXNpb25zUmVzcG9uc2USOQoJaW5mdXNpb25zGAEgAygLMhsuaGVhbHRoY2FyZS'
    '5pY3UudjEuSW5mdXNpb25SCWluZnVzaW9ucw==');

@$core.Deprecated('Use insertDeviceRequestDescriptor instead')
const InsertDeviceRequest$json = {
  '1': 'InsertDeviceRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'site', '3': 3, '4': 1, '5': 9, '10': 'site'},
    {'1': 'lumens', '3': 4, '4': 1, '5': 5, '10': 'lumens'},
    {
      '1': 'inserted_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'insertedAt'
    },
    {
      '1': 'review_every_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'reviewEverySeconds'
    },
  ],
};

/// Descriptor for `InsertDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertDeviceRequestDescriptor = $convert.base64Decode(
    'ChNJbnNlcnREZXZpY2VSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBISCg'
    'RraW5kGAIgASgJUgRraW5kEhIKBHNpdGUYAyABKAlSBHNpdGUSFgoGbHVtZW5zGAQgASgFUgZs'
    'dW1lbnMSOwoLaW5zZXJ0ZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'ppbnNlcnRlZEF0EjAKFHJldmlld19ldmVyeV9zZWNvbmRzGAYgASgDUhJyZXZpZXdFdmVyeVNl'
    'Y29uZHM=');

@$core.Deprecated('Use insertDeviceResponseDescriptor instead')
const InsertDeviceResponse$json = {
  '1': 'InsertDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.InvasiveDevice',
      '10': 'device'
    },
  ],
};

/// Descriptor for `InsertDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertDeviceResponseDescriptor = $convert.base64Decode(
    'ChRJbnNlcnREZXZpY2VSZXNwb25zZRI5CgZkZXZpY2UYASABKAsyIS5oZWFsdGhjYXJlLmljdS'
    '52MS5JbnZhc2l2ZURldmljZVIGZGV2aWNl');

@$core.Deprecated('Use removeDeviceRequestDescriptor instead')
const RemoveDeviceRequest$json = {
  '1': 'RemoveDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'removed_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'removedAt'
    },
  ],
};

/// Descriptor for `RemoveDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceRequestDescriptor = $convert.base64Decode(
    'ChNSZW1vdmVEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSFgoGcm'
    'Vhc29uGAIgASgJUgZyZWFzb24SOQoKcmVtb3ZlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCXJlbW92ZWRBdA==');

@$core.Deprecated('Use removeDeviceResponseDescriptor instead')
const RemoveDeviceResponse$json = {
  '1': 'RemoveDeviceResponse',
};

/// Descriptor for `RemoveDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceResponseDescriptor =
    $convert.base64Decode('ChRSZW1vdmVEZXZpY2VSZXNwb25zZQ==');

@$core.Deprecated('Use reviewDeviceRequestDescriptor instead')
const ReviewDeviceRequest$json = {
  '1': 'ReviewDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ReviewDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewDeviceRequestDescriptor =
    $convert.base64Decode(
        'ChNSZXZpZXdEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQ=');

@$core.Deprecated('Use reviewDeviceResponseDescriptor instead')
const ReviewDeviceResponse$json = {
  '1': 'ReviewDeviceResponse',
};

/// Descriptor for `ReviewDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewDeviceResponseDescriptor =
    $convert.base64Decode('ChRSZXZpZXdEZXZpY2VSZXNwb25zZQ==');

@$core.Deprecated('Use listDevicesRequestDescriptor instead')
const ListDevicesRequest$json = {
  '1': 'ListDevicesRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesRequestDescriptor =
    $convert.base64Decode(
        'ChJMaXN0RGV2aWNlc1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlk');

@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = {
  '1': 'ListDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.InvasiveDevice',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEjsKB2RldmljZXMYASADKAsyIS5oZWFsdGhjYXJlLmljdS'
    '52MS5JbnZhc2l2ZURldmljZVIHZGV2aWNlcw==');

@$core.Deprecated('Use calculateScoreRequestDescriptor instead')
const CalculateScoreRequest$json = {
  '1': 'CalculateScoreRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'formula_name', '3': 2, '4': 1, '5': 9, '10': 'formulaName'},
  ],
};

/// Descriptor for `CalculateScoreRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateScoreRequestDescriptor = $convert.base64Decode(
    'ChVDYWxjdWxhdGVTY29yZVJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEi'
    'EKDGZvcm11bGFfbmFtZRgCIAEoCVILZm9ybXVsYU5hbWU=');

@$core.Deprecated('Use calculateScoreResponseDescriptor instead')
const CalculateScoreResponse$json = {
  '1': 'CalculateScoreResponse',
  '2': [
    {
      '1': 'score',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Score',
      '10': 'score'
    },
  ],
};

/// Descriptor for `CalculateScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateScoreResponseDescriptor =
    $convert.base64Decode(
        'ChZDYWxjdWxhdGVTY29yZVJlc3BvbnNlEi4KBXNjb3JlGAEgASgLMhguaGVhbHRoY2FyZS5pY3'
        'UudjEuU2NvcmVSBXNjb3Jl');

@$core.Deprecated('Use listScoresRequestDescriptor instead')
const ListScoresRequest$json = {
  '1': 'ListScoresRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListScoresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScoresRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0U2NvcmVzUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSGwoJcG'
    'FnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listScoresResponseDescriptor instead')
const ListScoresResponse$json = {
  '1': 'ListScoresResponse',
  '2': [
    {
      '1': 'scores',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Score',
      '10': 'scores'
    },
  ],
};

/// Descriptor for `ListScoresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listScoresResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0U2NvcmVzUmVzcG9uc2USMAoGc2NvcmVzGAEgAygLMhguaGVhbHRoY2FyZS5pY3Uudj'
    'EuU2NvcmVSBnNjb3Jlcw==');

@$core.Deprecated('Use reproduceScoreRequestDescriptor instead')
const ReproduceScoreRequest$json = {
  '1': 'ReproduceScoreRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'score_id', '3': 2, '4': 1, '5': 9, '10': 'scoreId'},
  ],
};

/// Descriptor for `ReproduceScoreRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reproduceScoreRequestDescriptor = $convert.base64Decode(
    'ChVSZXByb2R1Y2VTY29yZVJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEh'
    'kKCHNjb3JlX2lkGAIgASgJUgdzY29yZUlk');

@$core.Deprecated('Use reproduceScoreResponseDescriptor instead')
const ReproduceScoreResponse$json = {
  '1': 'ReproduceScoreResponse',
  '2': [
    {'1': 'stored_total', '3': 1, '4': 1, '5': 5, '10': 'storedTotal'},
    {'1': 'reproduced_total', '3': 2, '4': 1, '5': 5, '10': 'reproducedTotal'},
    {'1': 'reproduced', '3': 3, '4': 1, '5': 8, '10': 'reproduced'},
  ],
};

/// Descriptor for `ReproduceScoreResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reproduceScoreResponseDescriptor = $convert.base64Decode(
    'ChZSZXByb2R1Y2VTY29yZVJlc3BvbnNlEiEKDHN0b3JlZF90b3RhbBgBIAEoBVILc3RvcmVkVG'
    '90YWwSKQoQcmVwcm9kdWNlZF90b3RhbBgCIAEoBVIPcmVwcm9kdWNlZFRvdGFsEh4KCnJlcHJv'
    'ZHVjZWQYAyABKAhSCnJlcHJvZHVjZWQ=');

@$core.Deprecated('Use performBundleRequestDescriptor instead')
const PerformBundleRequest$json = {
  '1': 'PerformBundleRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.BundleKind',
      '10': 'kind'
    },
    {
      '1': 'results',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.BundleResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `PerformBundleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performBundleRequestDescriptor = $convert.base64Decode(
    'ChRQZXJmb3JtQnVuZGxlUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSMQ'
    'oEa2luZBgCIAEoDjIdLmhlYWx0aGNhcmUuaWN1LnYxLkJ1bmRsZUtpbmRSBGtpbmQSOQoHcmVz'
    'dWx0cxgDIAMoCzIfLmhlYWx0aGNhcmUuaWN1LnYxLkJ1bmRsZVJlc3VsdFIHcmVzdWx0cw==');

@$core.Deprecated('Use performBundleResponseDescriptor instead')
const PerformBundleResponse$json = {
  '1': 'PerformBundleResponse',
  '2': [
    {
      '1': 'performance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.BundlePerformance',
      '10': 'performance'
    },
  ],
};

/// Descriptor for `PerformBundleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performBundleResponseDescriptor = $convert.base64Decode(
    'ChVQZXJmb3JtQnVuZGxlUmVzcG9uc2USRgoLcGVyZm9ybWFuY2UYASABKAsyJC5oZWFsdGhjYX'
    'JlLmljdS52MS5CdW5kbGVQZXJmb3JtYW5jZVILcGVyZm9ybWFuY2U=');

@$core.Deprecated('Use listBundlesRequestDescriptor instead')
const ListBundlesRequest$json = {
  '1': 'ListBundlesRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListBundlesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBundlesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0QnVuZGxlc1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEhsKCX'
    'BhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listBundlesResponseDescriptor instead')
const ListBundlesResponse$json = {
  '1': 'ListBundlesResponse',
  '2': [
    {
      '1': 'performances',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.BundlePerformance',
      '10': 'performances'
    },
  ],
};

/// Descriptor for `ListBundlesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBundlesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0QnVuZGxlc1Jlc3BvbnNlEkgKDHBlcmZvcm1hbmNlcxgBIAMoCzIkLmhlYWx0aGNhcm'
    'UuaWN1LnYxLkJ1bmRsZVBlcmZvcm1hbmNlUgxwZXJmb3JtYW5jZXM=');

@$core.Deprecated('Use recordAssessmentRequestDescriptor instead')
const RecordAssessmentRequest$json = {
  '1': 'RecordAssessmentRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'scale', '3': 3, '4': 1, '5': 9, '10': 'scale'},
    {'1': 'score', '3': 4, '4': 1, '5': 5, '9': 0, '10': 'score', '17': true},
    {
      '1': 'findings',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.RecordAssessmentRequest.FindingsEntry',
      '10': 'findings'
    },
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'performed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'every_seconds', '3': 8, '4': 1, '5': 3, '10': 'everySeconds'},
  ],
  '3': [RecordAssessmentRequest_FindingsEntry$json],
  '8': [
    {'1': '_score'},
  ],
};

@$core.Deprecated('Use recordAssessmentRequestDescriptor instead')
const RecordAssessmentRequest_FindingsEntry$json = {
  '1': 'FindingsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RecordAssessmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmRBc3Nlc3NtZW50UmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSW'
    'QSEgoEa2luZBgCIAEoCVIEa2luZBIUCgVzY2FsZRgDIAEoCVIFc2NhbGUSGQoFc2NvcmUYBCAB'
    'KAVIAFIFc2NvcmWIAQESVAoIZmluZGluZ3MYBSADKAsyOC5oZWFsdGhjYXJlLmljdS52MS5SZW'
    'NvcmRBc3Nlc3NtZW50UmVxdWVzdC5GaW5kaW5nc0VudHJ5UghmaW5kaW5ncxISCgRub3RlGAYg'
    'ASgJUgRub3RlEj0KDHBlcmZvcm1lZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSC3BlcmZvcm1lZEF0EiMKDWV2ZXJ5X3NlY29uZHMYCCABKANSDGV2ZXJ5U2Vjb25kcxo7'
    'Cg1GaW5kaW5nc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZT'
    'oCOAFCCAoGX3Njb3Jl');

@$core.Deprecated('Use recordAssessmentResponseDescriptor instead')
const RecordAssessmentResponse$json = {
  '1': 'RecordAssessmentResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Assessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `RecordAssessmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmRBc3Nlc3NtZW50UmVzcG9uc2USPQoKYXNzZXNzbWVudBgBIAEoCzIdLmhlYWx0aG'
        'NhcmUuaWN1LnYxLkFzc2Vzc21lbnRSCmFzc2Vzc21lbnQ=');

@$core.Deprecated('Use listDueAssessmentsRequestDescriptor instead')
const ListDueAssessmentsRequest$json = {
  '1': 'ListDueAssessmentsRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListDueAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueAssessmentsRequestDescriptor =
    $convert.base64Decode(
        'ChlMaXN0RHVlQXNzZXNzbWVudHNSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZG'
        'VJZA==');

@$core.Deprecated('Use listDueAssessmentsResponseDescriptor instead')
const ListDueAssessmentsResponse$json = {
  '1': 'ListDueAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Assessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListDueAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0RHVlQXNzZXNzbWVudHNSZXNwb25zZRI/Cgthc3Nlc3NtZW50cxgBIAMoCzIdLmhlYW'
        'x0aGNhcmUuaWN1LnYxLkFzc2Vzc21lbnRSC2Fzc2Vzc21lbnRz');

@$core.Deprecated('Use goalRequestDescriptor instead')
const GoalRequest$json = {
  '1': 'GoalRequest',
  '2': [
    {'1': 'domain', '3': 1, '4': 1, '5': 9, '10': 'domain'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
    {'1': 'owner_role', '3': 3, '4': 1, '5': 9, '10': 'ownerRole'},
    {'1': 'owner_id', '3': 4, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'target_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'targetAt'
    },
  ],
};

/// Descriptor for `GoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalRequestDescriptor = $convert.base64Decode(
    'CgtHb2FsUmVxdWVzdBIWCgZkb21haW4YASABKAlSBmRvbWFpbhISCgR0ZXh0GAIgASgJUgR0ZX'
    'h0Eh0KCm93bmVyX3JvbGUYAyABKAlSCW93bmVyUm9sZRIZCghvd25lcl9pZBgEIAEoCVIHb3du'
    'ZXJJZBI3Cgl0YXJnZXRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgh0YX'
    'JnZXRBdA==');

@$core.Deprecated('Use recordRoundRequestDescriptor instead')
const RecordRoundRequest$json = {
  '1': 'RecordRoundRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'attendance', '3': 2, '4': 3, '5': 9, '10': 'attendance'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'goals',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.GoalRequest',
      '10': 'goals'
    },
  ],
};

/// Descriptor for `RecordRoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordRoundRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRSb3VuZFJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEh4KCm'
    'F0dGVuZGFuY2UYAiADKAlSCmF0dGVuZGFuY2USGAoHc3VtbWFyeRgDIAEoCVIHc3VtbWFyeRI0'
    'CgVnb2FscxgEIAMoCzIeLmhlYWx0aGNhcmUuaWN1LnYxLkdvYWxSZXF1ZXN0UgVnb2Fscw==');

@$core.Deprecated('Use recordRoundResponseDescriptor instead')
const RecordRoundResponse$json = {
  '1': 'RecordRoundResponse',
  '2': [
    {
      '1': 'round',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.Round',
      '10': 'round'
    },
    {
      '1': 'goals',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Goal',
      '10': 'goals'
    },
  ],
};

/// Descriptor for `RecordRoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordRoundResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRSb3VuZFJlc3BvbnNlEi4KBXJvdW5kGAEgASgLMhguaGVhbHRoY2FyZS5pY3Uudj'
    'EuUm91bmRSBXJvdW5kEi0KBWdvYWxzGAIgAygLMhcuaGVhbHRoY2FyZS5pY3UudjEuR29hbFIF'
    'Z29hbHM=');

@$core.Deprecated('Use resolveGoalRequestDescriptor instead')
const ResolveGoalRequest$json = {
  '1': 'ResolveGoalRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'goal_id', '3': 2, '4': 1, '5': 9, '10': 'goalId'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.GoalStatus',
      '10': 'status'
    },
    {'1': 'outcome', '3': 4, '4': 1, '5': 9, '10': 'outcome'},
  ],
};

/// Descriptor for `ResolveGoalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveGoalRequestDescriptor = $convert.base64Decode(
    'ChJSZXNvbHZlR29hbFJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEhcKB2'
    'dvYWxfaWQYAiABKAlSBmdvYWxJZBI1CgZzdGF0dXMYAyABKA4yHS5oZWFsdGhjYXJlLmljdS52'
    'MS5Hb2FsU3RhdHVzUgZzdGF0dXMSGAoHb3V0Y29tZRgEIAEoCVIHb3V0Y29tZQ==');

@$core.Deprecated('Use resolveGoalResponseDescriptor instead')
const ResolveGoalResponse$json = {
  '1': 'ResolveGoalResponse',
};

/// Descriptor for `ResolveGoalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveGoalResponseDescriptor =
    $convert.base64Decode('ChNSZXNvbHZlR29hbFJlc3BvbnNl');

@$core.Deprecated('Use listOpenGoalsRequestDescriptor instead')
const ListOpenGoalsRequest$json = {
  '1': 'ListOpenGoalsRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListOpenGoalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenGoalsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0T3BlbkdvYWxzUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQ=');

@$core.Deprecated('Use listOpenGoalsResponseDescriptor instead')
const ListOpenGoalsResponse$json = {
  '1': 'ListOpenGoalsResponse',
  '2': [
    {
      '1': 'goals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Goal',
      '10': 'goals'
    },
  ],
};

/// Descriptor for `ListOpenGoalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOpenGoalsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0T3BlbkdvYWxzUmVzcG9uc2USLQoFZ29hbHMYASADKAsyFy5oZWFsdGhjYXJlLmljdS'
    '52MS5Hb2FsUgVnb2Fscw==');

@$core.Deprecated('Use setCeilingRequestDescriptor instead')
const SetCeilingRequest$json = {
  '1': 'SetCeilingRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'intent',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.icu.v1.CareIntent',
      '10': 'intent'
    },
    {'1': 'limitations', '3': 3, '4': 3, '5': 9, '10': 'limitations'},
    {'1': 'cpr_status', '3': 4, '4': 1, '5': 9, '10': 'cprStatus'},
    {'1': 'discussed_with', '3': 5, '4': 1, '5': 9, '10': 'discussedWith'},
    {'1': 'rationale', '3': 6, '4': 1, '5': 9, '10': 'rationale'},
    {'1': 'authorised_by', '3': 7, '4': 1, '5': 9, '10': 'authorisedBy'},
    {'1': 'authorised_role', '3': 8, '4': 1, '5': 9, '10': 'authorisedRole'},
    {
      '1': 'review_by',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewBy'
    },
  ],
};

/// Descriptor for `SetCeilingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCeilingRequestDescriptor = $convert.base64Decode(
    'ChFTZXRDZWlsaW5nUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSNQoGaW'
    '50ZW50GAIgASgOMh0uaGVhbHRoY2FyZS5pY3UudjEuQ2FyZUludGVudFIGaW50ZW50EiAKC2xp'
    'bWl0YXRpb25zGAMgAygJUgtsaW1pdGF0aW9ucxIdCgpjcHJfc3RhdHVzGAQgASgJUgljcHJTdG'
    'F0dXMSJQoOZGlzY3Vzc2VkX3dpdGgYBSABKAlSDWRpc2N1c3NlZFdpdGgSHAoJcmF0aW9uYWxl'
    'GAYgASgJUglyYXRpb25hbGUSIwoNYXV0aG9yaXNlZF9ieRgHIAEoCVIMYXV0aG9yaXNlZEJ5Ei'
    'cKD2F1dGhvcmlzZWRfcm9sZRgIIAEoCVIOYXV0aG9yaXNlZFJvbGUSNwoJcmV2aWV3X2J5GAkg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmV2aWV3Qnk=');

@$core.Deprecated('Use setCeilingResponseDescriptor instead')
const SetCeilingResponse$json = {
  '1': 'SetCeilingResponse',
  '2': [
    {
      '1': 'ceiling',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.GoalsOfCare',
      '10': 'ceiling'
    },
  ],
};

/// Descriptor for `SetCeilingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setCeilingResponseDescriptor = $convert.base64Decode(
    'ChJTZXRDZWlsaW5nUmVzcG9uc2USOAoHY2VpbGluZxgBIAEoCzIeLmhlYWx0aGNhcmUuaWN1Ln'
    'YxLkdvYWxzT2ZDYXJlUgdjZWlsaW5n');

@$core.Deprecated('Use getCeilingRequestDescriptor instead')
const GetCeilingRequest$json = {
  '1': 'GetCeilingRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `GetCeilingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCeilingRequestDescriptor = $convert.base64Decode(
    'ChFHZXRDZWlsaW5nUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQ=');

@$core.Deprecated('Use getCeilingResponseDescriptor instead')
const GetCeilingResponse$json = {
  '1': 'GetCeilingResponse',
  '2': [
    {
      '1': 'current',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.GoalsOfCare',
      '10': 'current'
    },
    {
      '1': 'history',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.GoalsOfCare',
      '10': 'history'
    },
  ],
};

/// Descriptor for `GetCeilingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCeilingResponseDescriptor = $convert.base64Decode(
    'ChJHZXRDZWlsaW5nUmVzcG9uc2USOAoHY3VycmVudBgBIAEoCzIeLmhlYWx0aGNhcmUuaWN1Ln'
    'YxLkdvYWxzT2ZDYXJlUgdjdXJyZW50EjgKB2hpc3RvcnkYAiADKAsyHi5oZWFsdGhjYXJlLmlj'
    'dS52MS5Hb2Fsc09mQ2FyZVIHaGlzdG9yeQ==');

@$core.Deprecated('Use getDashboardRequestDescriptor instead')
const GetDashboardRequest$json = {
  '1': 'GetDashboardRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {
      '1': 'balance_window_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'balanceWindowSeconds'
    },
  ],
};

/// Descriptor for `GetDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardRequestDescriptor = $convert.base64Decode(
    'ChNHZXREYXNoYm9hcmRSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIbCglwYWdlX3'
    'NpemUYAiABKAVSCHBhZ2VTaXplEjQKFmJhbGFuY2Vfd2luZG93X3NlY29uZHMYAyABKANSFGJh'
    'bGFuY2VXaW5kb3dTZWNvbmRz');

@$core.Deprecated('Use getDashboardResponseDescriptor instead')
const GetDashboardResponse$json = {
  '1': 'GetDashboardResponse',
  '2': [
    {
      '1': 'rows',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.DashboardRow',
      '10': 'rows'
    },
  ],
};

/// Descriptor for `GetDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardResponseDescriptor = $convert.base64Decode(
    'ChRHZXREYXNoYm9hcmRSZXNwb25zZRIzCgRyb3dzGAEgAygLMh8uaGVhbHRoY2FyZS5pY3Uudj'
    'EuRGFzaGJvYXJkUm93UgRyb3dz');

@$core.Deprecated('Use listAdvisoriesRequestDescriptor instead')
const ListAdvisoriesRequest$json = {
  '1': 'ListAdvisoriesRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ListAdvisoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdvisoriesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0QWR2aXNvcmllc1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlk');

@$core.Deprecated('Use listAdvisoriesResponseDescriptor instead')
const ListAdvisoriesResponse$json = {
  '1': 'ListAdvisoriesResponse',
  '2': [
    {
      '1': 'alarms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.icu.v1.Alarm',
      '10': 'alarms'
    },
  ],
};

/// Descriptor for `ListAdvisoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdvisoriesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QWR2aXNvcmllc1Jlc3BvbnNlEjAKBmFsYXJtcxgBIAMoCzIYLmhlYWx0aGNhcmUuaW'
        'N1LnYxLkFsYXJtUgZhbGFybXM=');

@$core.Deprecated('Use escalateAdvisoryRequestDescriptor instead')
const EscalateAdvisoryRequest$json = {
  '1': 'EscalateAdvisoryRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
  ],
};

/// Descriptor for `EscalateAdvisoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateAdvisoryRequestDescriptor =
    $convert.base64Decode(
        'ChdFc2NhbGF0ZUFkdmlzb3J5UmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSW'
        'QSEgoEa2luZBgCIAEoCVIEa2luZBIYCgdzdW1tYXJ5GAMgASgJUgdzdW1tYXJ5');

@$core.Deprecated('Use escalateAdvisoryResponseDescriptor instead')
const EscalateAdvisoryResponse$json = {
  '1': 'EscalateAdvisoryResponse',
  '2': [
    {'1': 'notice_id', '3': 1, '4': 1, '5': 9, '10': 'noticeId'},
  ],
};

/// Descriptor for `EscalateAdvisoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateAdvisoryResponseDescriptor =
    $convert.base64Decode(
        'ChhFc2NhbGF0ZUFkdmlzb3J5UmVzcG9uc2USGwoJbm90aWNlX2lkGAEgASgJUghub3RpY2VJZA'
        '==');

@$core.Deprecated('Use getUnitMetricsRequestDescriptor instead')
const GetUnitMetricsRequest$json = {
  '1': 'GetUnitMetricsRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
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

/// Descriptor for `GetUnitMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitMetricsRequestDescriptor = $convert.base64Decode(
    'ChVHZXRVbml0TWV0cmljc1JlcXVlc3QSFwoHdW5pdF9pZBgBIAEoCVIGdW5pdElkEi4KBGZyb2'
    '0YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAMgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getUnitMetricsResponseDescriptor instead')
const GetUnitMetricsResponse$json = {
  '1': 'GetUnitMetricsResponse',
  '2': [
    {
      '1': 'metrics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.icu.v1.UnitMetrics',
      '10': 'metrics'
    },
  ],
};

/// Descriptor for `GetUnitMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitMetricsResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRVbml0TWV0cmljc1Jlc3BvbnNlEjgKB21ldHJpY3MYASABKAsyHi5oZWFsdGhjYXJlLm'
        'ljdS52MS5Vbml0TWV0cmljc1IHbWV0cmljcw==');

const $core.Map<$core.String, $core.dynamic> IcuServiceBase$json = {
  '1': 'IcuService',
  '2': [
    {
      '1': 'Admit',
      '2': '.healthcare.icu.v1.AdmitRequest',
      '3': '.healthcare.icu.v1.AdmitResponse'
    },
    {
      '1': 'GetIcuEpisode',
      '2': '.healthcare.icu.v1.GetIcuEpisodeRequest',
      '3': '.healthcare.icu.v1.GetIcuEpisodeResponse'
    },
    {
      '1': 'MoveBed',
      '2': '.healthcare.icu.v1.MoveBedRequest',
      '3': '.healthcare.icu.v1.MoveBedResponse'
    },
    {
      '1': 'DeclareReady',
      '2': '.healthcare.icu.v1.DeclareReadyRequest',
      '3': '.healthcare.icu.v1.DeclareReadyResponse'
    },
    {
      '1': 'Discharge',
      '2': '.healthcare.icu.v1.DischargeRequest',
      '3': '.healthcare.icu.v1.DischargeResponse'
    },
    {
      '1': 'ChartValue',
      '2': '.healthcare.icu.v1.ChartValueRequest',
      '3': '.healthcare.icu.v1.ChartValueResponse'
    },
    {
      '1': 'DecideReading',
      '2': '.healthcare.icu.v1.DecideReadingRequest',
      '3': '.healthcare.icu.v1.DecideReadingResponse'
    },
    {
      '1': 'ListFlowsheet',
      '2': '.healthcare.icu.v1.ListFlowsheetRequest',
      '3': '.healthcare.icu.v1.ListFlowsheetResponse'
    },
    {
      '1': 'ListPendingReadings',
      '2': '.healthcare.icu.v1.ListPendingReadingsRequest',
      '3': '.healthcare.icu.v1.ListPendingReadingsResponse'
    },
    {
      '1': 'RecordBalance',
      '2': '.healthcare.icu.v1.RecordBalanceRequest',
      '3': '.healthcare.icu.v1.RecordBalanceResponse'
    },
    {
      '1': 'GetBalance',
      '2': '.healthcare.icu.v1.GetBalanceRequest',
      '3': '.healthcare.icu.v1.GetBalanceResponse'
    },
    {
      '1': 'StartSupport',
      '2': '.healthcare.icu.v1.StartSupportRequest',
      '3': '.healthcare.icu.v1.StartSupportResponse'
    },
    {
      '1': 'StopSupport',
      '2': '.healthcare.icu.v1.StopSupportRequest',
      '3': '.healthcare.icu.v1.StopSupportResponse'
    },
    {
      '1': 'ListSupport',
      '2': '.healthcare.icu.v1.ListSupportRequest',
      '3': '.healthcare.icu.v1.ListSupportResponse'
    },
    {
      '1': 'RecordVentSetting',
      '2': '.healthcare.icu.v1.RecordVentSettingRequest',
      '3': '.healthcare.icu.v1.RecordVentSettingResponse'
    },
    {
      '1': 'GetVentTimeline',
      '2': '.healthcare.icu.v1.GetVentTimelineRequest',
      '3': '.healthcare.icu.v1.GetVentTimelineResponse'
    },
    {
      '1': 'StartInfusion',
      '2': '.healthcare.icu.v1.StartInfusionRequest',
      '3': '.healthcare.icu.v1.StartInfusionResponse'
    },
    {
      '1': 'Titrate',
      '2': '.healthcare.icu.v1.TitrateRequest',
      '3': '.healthcare.icu.v1.TitrateResponse'
    },
    {
      '1': 'StopInfusion',
      '2': '.healthcare.icu.v1.StopInfusionRequest',
      '3': '.healthcare.icu.v1.StopInfusionResponse'
    },
    {
      '1': 'ListInfusions',
      '2': '.healthcare.icu.v1.ListInfusionsRequest',
      '3': '.healthcare.icu.v1.ListInfusionsResponse'
    },
    {
      '1': 'InsertDevice',
      '2': '.healthcare.icu.v1.InsertDeviceRequest',
      '3': '.healthcare.icu.v1.InsertDeviceResponse'
    },
    {
      '1': 'RemoveDevice',
      '2': '.healthcare.icu.v1.RemoveDeviceRequest',
      '3': '.healthcare.icu.v1.RemoveDeviceResponse'
    },
    {
      '1': 'ReviewDevice',
      '2': '.healthcare.icu.v1.ReviewDeviceRequest',
      '3': '.healthcare.icu.v1.ReviewDeviceResponse'
    },
    {
      '1': 'ListDevices',
      '2': '.healthcare.icu.v1.ListDevicesRequest',
      '3': '.healthcare.icu.v1.ListDevicesResponse'
    },
    {
      '1': 'CalculateScore',
      '2': '.healthcare.icu.v1.CalculateScoreRequest',
      '3': '.healthcare.icu.v1.CalculateScoreResponse'
    },
    {
      '1': 'ListScores',
      '2': '.healthcare.icu.v1.ListScoresRequest',
      '3': '.healthcare.icu.v1.ListScoresResponse'
    },
    {
      '1': 'ReproduceScore',
      '2': '.healthcare.icu.v1.ReproduceScoreRequest',
      '3': '.healthcare.icu.v1.ReproduceScoreResponse'
    },
    {
      '1': 'PerformBundle',
      '2': '.healthcare.icu.v1.PerformBundleRequest',
      '3': '.healthcare.icu.v1.PerformBundleResponse'
    },
    {
      '1': 'ListBundles',
      '2': '.healthcare.icu.v1.ListBundlesRequest',
      '3': '.healthcare.icu.v1.ListBundlesResponse'
    },
    {
      '1': 'RecordAssessment',
      '2': '.healthcare.icu.v1.RecordAssessmentRequest',
      '3': '.healthcare.icu.v1.RecordAssessmentResponse'
    },
    {
      '1': 'ListDueAssessments',
      '2': '.healthcare.icu.v1.ListDueAssessmentsRequest',
      '3': '.healthcare.icu.v1.ListDueAssessmentsResponse'
    },
    {
      '1': 'RecordRound',
      '2': '.healthcare.icu.v1.RecordRoundRequest',
      '3': '.healthcare.icu.v1.RecordRoundResponse'
    },
    {
      '1': 'ResolveGoal',
      '2': '.healthcare.icu.v1.ResolveGoalRequest',
      '3': '.healthcare.icu.v1.ResolveGoalResponse'
    },
    {
      '1': 'ListOpenGoals',
      '2': '.healthcare.icu.v1.ListOpenGoalsRequest',
      '3': '.healthcare.icu.v1.ListOpenGoalsResponse'
    },
    {
      '1': 'SetCeiling',
      '2': '.healthcare.icu.v1.SetCeilingRequest',
      '3': '.healthcare.icu.v1.SetCeilingResponse'
    },
    {
      '1': 'GetCeiling',
      '2': '.healthcare.icu.v1.GetCeilingRequest',
      '3': '.healthcare.icu.v1.GetCeilingResponse'
    },
    {
      '1': 'GetDashboard',
      '2': '.healthcare.icu.v1.GetDashboardRequest',
      '3': '.healthcare.icu.v1.GetDashboardResponse'
    },
    {
      '1': 'ListAdvisories',
      '2': '.healthcare.icu.v1.ListAdvisoriesRequest',
      '3': '.healthcare.icu.v1.ListAdvisoriesResponse'
    },
    {
      '1': 'EscalateAdvisory',
      '2': '.healthcare.icu.v1.EscalateAdvisoryRequest',
      '3': '.healthcare.icu.v1.EscalateAdvisoryResponse'
    },
    {
      '1': 'GetUnitMetrics',
      '2': '.healthcare.icu.v1.GetUnitMetricsRequest',
      '3': '.healthcare.icu.v1.GetUnitMetricsResponse'
    },
  ],
};

@$core.Deprecated('Use icuServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    IcuServiceBase$messageJson = {
  '.healthcare.icu.v1.AdmitRequest': AdmitRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.icu.v1.AdmitResponse': AdmitResponse$json,
  '.healthcare.icu.v1.IcuEpisode': IcuEpisode$json,
  '.healthcare.icu.v1.GetIcuEpisodeRequest': GetIcuEpisodeRequest$json,
  '.healthcare.icu.v1.GetIcuEpisodeResponse': GetIcuEpisodeResponse$json,
  '.healthcare.icu.v1.Support': Support$json,
  '.healthcare.icu.v1.InvasiveDevice': InvasiveDevice$json,
  '.healthcare.icu.v1.Infusion': Infusion$json,
  '.healthcare.icu.v1.Titration': Titration$json,
  '.healthcare.icu.v1.Goal': Goal$json,
  '.healthcare.icu.v1.GoalsOfCare': GoalsOfCare$json,
  '.healthcare.icu.v1.MoveBedRequest': MoveBedRequest$json,
  '.healthcare.icu.v1.MoveBedResponse': MoveBedResponse$json,
  '.healthcare.icu.v1.DeclareReadyRequest': DeclareReadyRequest$json,
  '.healthcare.icu.v1.DeclareReadyResponse': DeclareReadyResponse$json,
  '.healthcare.icu.v1.DischargeRequest': DischargeRequest$json,
  '.healthcare.icu.v1.DischargeResponse': DischargeResponse$json,
  '.healthcare.icu.v1.ChartValueRequest': ChartValueRequest$json,
  '.healthcare.icu.v1.DeviceSource': DeviceSource$json,
  '.healthcare.icu.v1.ChartValueResponse': ChartValueResponse$json,
  '.healthcare.icu.v1.Observation': Observation$json,
  '.healthcare.icu.v1.DecideReadingRequest': DecideReadingRequest$json,
  '.healthcare.icu.v1.DecideReadingResponse': DecideReadingResponse$json,
  '.healthcare.icu.v1.ListFlowsheetRequest': ListFlowsheetRequest$json,
  '.healthcare.icu.v1.ListFlowsheetResponse': ListFlowsheetResponse$json,
  '.healthcare.icu.v1.ListPendingReadingsRequest':
      ListPendingReadingsRequest$json,
  '.healthcare.icu.v1.ListPendingReadingsResponse':
      ListPendingReadingsResponse$json,
  '.healthcare.icu.v1.RecordBalanceRequest': RecordBalanceRequest$json,
  '.healthcare.icu.v1.RecordBalanceResponse': RecordBalanceResponse$json,
  '.healthcare.icu.v1.BalanceEntry': BalanceEntry$json,
  '.healthcare.icu.v1.GetBalanceRequest': GetBalanceRequest$json,
  '.healthcare.icu.v1.GetBalanceResponse': GetBalanceResponse$json,
  '.healthcare.icu.v1.Balance': Balance$json,
  '.healthcare.icu.v1.StartSupportRequest': StartSupportRequest$json,
  '.healthcare.icu.v1.StartSupportResponse': StartSupportResponse$json,
  '.healthcare.icu.v1.StopSupportRequest': StopSupportRequest$json,
  '.healthcare.icu.v1.StopSupportResponse': StopSupportResponse$json,
  '.healthcare.icu.v1.ListSupportRequest': ListSupportRequest$json,
  '.healthcare.icu.v1.ListSupportResponse': ListSupportResponse$json,
  '.healthcare.icu.v1.RecordVentSettingRequest': RecordVentSettingRequest$json,
  '.healthcare.icu.v1.RecordVentSettingRequest.ParametersEntry':
      RecordVentSettingRequest_ParametersEntry$json,
  '.healthcare.icu.v1.RecordVentSettingRequest.MeasuredEntry':
      RecordVentSettingRequest_MeasuredEntry$json,
  '.healthcare.icu.v1.RecordVentSettingRequest.UnitsEntry':
      RecordVentSettingRequest_UnitsEntry$json,
  '.healthcare.icu.v1.RecordVentSettingResponse':
      RecordVentSettingResponse$json,
  '.healthcare.icu.v1.VentSetting': VentSetting$json,
  '.healthcare.icu.v1.VentSetting.ParametersEntry':
      VentSetting_ParametersEntry$json,
  '.healthcare.icu.v1.VentSetting.MeasuredEntry':
      VentSetting_MeasuredEntry$json,
  '.healthcare.icu.v1.VentSetting.UnitsEntry': VentSetting_UnitsEntry$json,
  '.healthcare.icu.v1.GetVentTimelineRequest': GetVentTimelineRequest$json,
  '.healthcare.icu.v1.GetVentTimelineResponse': GetVentTimelineResponse$json,
  '.healthcare.icu.v1.StartInfusionRequest': StartInfusionRequest$json,
  '.healthcare.icu.v1.StartInfusionResponse': StartInfusionResponse$json,
  '.healthcare.icu.v1.TitrateRequest': TitrateRequest$json,
  '.healthcare.icu.v1.TitrateResponse': TitrateResponse$json,
  '.healthcare.icu.v1.StopInfusionRequest': StopInfusionRequest$json,
  '.healthcare.icu.v1.StopInfusionResponse': StopInfusionResponse$json,
  '.healthcare.icu.v1.ListInfusionsRequest': ListInfusionsRequest$json,
  '.healthcare.icu.v1.ListInfusionsResponse': ListInfusionsResponse$json,
  '.healthcare.icu.v1.InsertDeviceRequest': InsertDeviceRequest$json,
  '.healthcare.icu.v1.InsertDeviceResponse': InsertDeviceResponse$json,
  '.healthcare.icu.v1.RemoveDeviceRequest': RemoveDeviceRequest$json,
  '.healthcare.icu.v1.RemoveDeviceResponse': RemoveDeviceResponse$json,
  '.healthcare.icu.v1.ReviewDeviceRequest': ReviewDeviceRequest$json,
  '.healthcare.icu.v1.ReviewDeviceResponse': ReviewDeviceResponse$json,
  '.healthcare.icu.v1.ListDevicesRequest': ListDevicesRequest$json,
  '.healthcare.icu.v1.ListDevicesResponse': ListDevicesResponse$json,
  '.healthcare.icu.v1.CalculateScoreRequest': CalculateScoreRequest$json,
  '.healthcare.icu.v1.CalculateScoreResponse': CalculateScoreResponse$json,
  '.healthcare.icu.v1.Score': Score$json,
  '.healthcare.icu.v1.ScoreInput': ScoreInput$json,
  '.healthcare.icu.v1.ListScoresRequest': ListScoresRequest$json,
  '.healthcare.icu.v1.ListScoresResponse': ListScoresResponse$json,
  '.healthcare.icu.v1.ReproduceScoreRequest': ReproduceScoreRequest$json,
  '.healthcare.icu.v1.ReproduceScoreResponse': ReproduceScoreResponse$json,
  '.healthcare.icu.v1.PerformBundleRequest': PerformBundleRequest$json,
  '.healthcare.icu.v1.BundleResult': BundleResult$json,
  '.healthcare.icu.v1.PerformBundleResponse': PerformBundleResponse$json,
  '.healthcare.icu.v1.BundlePerformance': BundlePerformance$json,
  '.healthcare.icu.v1.Compliance': Compliance$json,
  '.healthcare.icu.v1.ListBundlesRequest': ListBundlesRequest$json,
  '.healthcare.icu.v1.ListBundlesResponse': ListBundlesResponse$json,
  '.healthcare.icu.v1.RecordAssessmentRequest': RecordAssessmentRequest$json,
  '.healthcare.icu.v1.RecordAssessmentRequest.FindingsEntry':
      RecordAssessmentRequest_FindingsEntry$json,
  '.healthcare.icu.v1.RecordAssessmentResponse': RecordAssessmentResponse$json,
  '.healthcare.icu.v1.Assessment': Assessment$json,
  '.healthcare.icu.v1.Assessment.FindingsEntry': Assessment_FindingsEntry$json,
  '.healthcare.icu.v1.ListDueAssessmentsRequest':
      ListDueAssessmentsRequest$json,
  '.healthcare.icu.v1.ListDueAssessmentsResponse':
      ListDueAssessmentsResponse$json,
  '.healthcare.icu.v1.RecordRoundRequest': RecordRoundRequest$json,
  '.healthcare.icu.v1.GoalRequest': GoalRequest$json,
  '.healthcare.icu.v1.RecordRoundResponse': RecordRoundResponse$json,
  '.healthcare.icu.v1.Round': Round$json,
  '.healthcare.icu.v1.ResolveGoalRequest': ResolveGoalRequest$json,
  '.healthcare.icu.v1.ResolveGoalResponse': ResolveGoalResponse$json,
  '.healthcare.icu.v1.ListOpenGoalsRequest': ListOpenGoalsRequest$json,
  '.healthcare.icu.v1.ListOpenGoalsResponse': ListOpenGoalsResponse$json,
  '.healthcare.icu.v1.SetCeilingRequest': SetCeilingRequest$json,
  '.healthcare.icu.v1.SetCeilingResponse': SetCeilingResponse$json,
  '.healthcare.icu.v1.GetCeilingRequest': GetCeilingRequest$json,
  '.healthcare.icu.v1.GetCeilingResponse': GetCeilingResponse$json,
  '.healthcare.icu.v1.GetDashboardRequest': GetDashboardRequest$json,
  '.healthcare.icu.v1.GetDashboardResponse': GetDashboardResponse$json,
  '.healthcare.icu.v1.DashboardRow': DashboardRow$json,
  '.healthcare.icu.v1.DashboardValue': DashboardValue$json,
  '.healthcare.icu.v1.ListAdvisoriesRequest': ListAdvisoriesRequest$json,
  '.healthcare.icu.v1.ListAdvisoriesResponse': ListAdvisoriesResponse$json,
  '.healthcare.icu.v1.Alarm': Alarm$json,
  '.healthcare.icu.v1.EscalateAdvisoryRequest': EscalateAdvisoryRequest$json,
  '.healthcare.icu.v1.EscalateAdvisoryResponse': EscalateAdvisoryResponse$json,
  '.healthcare.icu.v1.GetUnitMetricsRequest': GetUnitMetricsRequest$json,
  '.healthcare.icu.v1.GetUnitMetricsResponse': GetUnitMetricsResponse$json,
  '.healthcare.icu.v1.UnitMetrics': UnitMetrics$json,
  '.healthcare.icu.v1.UnitMetrics.DeviceDaysEntry':
      UnitMetrics_DeviceDaysEntry$json,
};

/// Descriptor for `IcuService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List icuServiceDescriptor = $convert.base64Decode(
    'CgpJY3VTZXJ2aWNlEkoKBUFkbWl0Eh8uaGVhbHRoY2FyZS5pY3UudjEuQWRtaXRSZXF1ZXN0Gi'
    'AuaGVhbHRoY2FyZS5pY3UudjEuQWRtaXRSZXNwb25zZRJiCg1HZXRJY3VFcGlzb2RlEicuaGVh'
    'bHRoY2FyZS5pY3UudjEuR2V0SWN1RXBpc29kZVJlcXVlc3QaKC5oZWFsdGhjYXJlLmljdS52MS'
    '5HZXRJY3VFcGlzb2RlUmVzcG9uc2USUAoHTW92ZUJlZBIhLmhlYWx0aGNhcmUuaWN1LnYxLk1v'
    'dmVCZWRSZXF1ZXN0GiIuaGVhbHRoY2FyZS5pY3UudjEuTW92ZUJlZFJlc3BvbnNlEl8KDERlY2'
    'xhcmVSZWFkeRImLmhlYWx0aGNhcmUuaWN1LnYxLkRlY2xhcmVSZWFkeVJlcXVlc3QaJy5oZWFs'
    'dGhjYXJlLmljdS52MS5EZWNsYXJlUmVhZHlSZXNwb25zZRJWCglEaXNjaGFyZ2USIy5oZWFsdG'
    'hjYXJlLmljdS52MS5EaXNjaGFyZ2VSZXF1ZXN0GiQuaGVhbHRoY2FyZS5pY3UudjEuRGlzY2hh'
    'cmdlUmVzcG9uc2USWQoKQ2hhcnRWYWx1ZRIkLmhlYWx0aGNhcmUuaWN1LnYxLkNoYXJ0VmFsdW'
    'VSZXF1ZXN0GiUuaGVhbHRoY2FyZS5pY3UudjEuQ2hhcnRWYWx1ZVJlc3BvbnNlEmIKDURlY2lk'
    'ZVJlYWRpbmcSJy5oZWFsdGhjYXJlLmljdS52MS5EZWNpZGVSZWFkaW5nUmVxdWVzdBooLmhlYW'
    'x0aGNhcmUuaWN1LnYxLkRlY2lkZVJlYWRpbmdSZXNwb25zZRJiCg1MaXN0Rmxvd3NoZWV0Eicu'
    'aGVhbHRoY2FyZS5pY3UudjEuTGlzdEZsb3dzaGVldFJlcXVlc3QaKC5oZWFsdGhjYXJlLmljdS'
    '52MS5MaXN0Rmxvd3NoZWV0UmVzcG9uc2USdAoTTGlzdFBlbmRpbmdSZWFkaW5ncxItLmhlYWx0'
    'aGNhcmUuaWN1LnYxLkxpc3RQZW5kaW5nUmVhZGluZ3NSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5pY3'
    'UudjEuTGlzdFBlbmRpbmdSZWFkaW5nc1Jlc3BvbnNlEmIKDVJlY29yZEJhbGFuY2USJy5oZWFs'
    'dGhjYXJlLmljdS52MS5SZWNvcmRCYWxhbmNlUmVxdWVzdBooLmhlYWx0aGNhcmUuaWN1LnYxLl'
    'JlY29yZEJhbGFuY2VSZXNwb25zZRJZCgpHZXRCYWxhbmNlEiQuaGVhbHRoY2FyZS5pY3UudjEu'
    'R2V0QmFsYW5jZVJlcXVlc3QaJS5oZWFsdGhjYXJlLmljdS52MS5HZXRCYWxhbmNlUmVzcG9uc2'
    'USXwoMU3RhcnRTdXBwb3J0EiYuaGVhbHRoY2FyZS5pY3UudjEuU3RhcnRTdXBwb3J0UmVxdWVz'
    'dBonLmhlYWx0aGNhcmUuaWN1LnYxLlN0YXJ0U3VwcG9ydFJlc3BvbnNlElwKC1N0b3BTdXBwb3'
    'J0EiUuaGVhbHRoY2FyZS5pY3UudjEuU3RvcFN1cHBvcnRSZXF1ZXN0GiYuaGVhbHRoY2FyZS5p'
    'Y3UudjEuU3RvcFN1cHBvcnRSZXNwb25zZRJcCgtMaXN0U3VwcG9ydBIlLmhlYWx0aGNhcmUuaW'
    'N1LnYxLkxpc3RTdXBwb3J0UmVxdWVzdBomLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RTdXBwb3J0'
    'UmVzcG9uc2USbgoRUmVjb3JkVmVudFNldHRpbmcSKy5oZWFsdGhjYXJlLmljdS52MS5SZWNvcm'
    'RWZW50U2V0dGluZ1JlcXVlc3QaLC5oZWFsdGhjYXJlLmljdS52MS5SZWNvcmRWZW50U2V0dGlu'
    'Z1Jlc3BvbnNlEmgKD0dldFZlbnRUaW1lbGluZRIpLmhlYWx0aGNhcmUuaWN1LnYxLkdldFZlbn'
    'RUaW1lbGluZVJlcXVlc3QaKi5oZWFsdGhjYXJlLmljdS52MS5HZXRWZW50VGltZWxpbmVSZXNw'
    'b25zZRJiCg1TdGFydEluZnVzaW9uEicuaGVhbHRoY2FyZS5pY3UudjEuU3RhcnRJbmZ1c2lvbl'
    'JlcXVlc3QaKC5oZWFsdGhjYXJlLmljdS52MS5TdGFydEluZnVzaW9uUmVzcG9uc2USUAoHVGl0'
    'cmF0ZRIhLmhlYWx0aGNhcmUuaWN1LnYxLlRpdHJhdGVSZXF1ZXN0GiIuaGVhbHRoY2FyZS5pY3'
    'UudjEuVGl0cmF0ZVJlc3BvbnNlEl8KDFN0b3BJbmZ1c2lvbhImLmhlYWx0aGNhcmUuaWN1LnYx'
    'LlN0b3BJbmZ1c2lvblJlcXVlc3QaJy5oZWFsdGhjYXJlLmljdS52MS5TdG9wSW5mdXNpb25SZX'
    'Nwb25zZRJiCg1MaXN0SW5mdXNpb25zEicuaGVhbHRoY2FyZS5pY3UudjEuTGlzdEluZnVzaW9u'
    'c1JlcXVlc3QaKC5oZWFsdGhjYXJlLmljdS52MS5MaXN0SW5mdXNpb25zUmVzcG9uc2USXwoMSW'
    '5zZXJ0RGV2aWNlEiYuaGVhbHRoY2FyZS5pY3UudjEuSW5zZXJ0RGV2aWNlUmVxdWVzdBonLmhl'
    'YWx0aGNhcmUuaWN1LnYxLkluc2VydERldmljZVJlc3BvbnNlEl8KDFJlbW92ZURldmljZRImLm'
    'hlYWx0aGNhcmUuaWN1LnYxLlJlbW92ZURldmljZVJlcXVlc3QaJy5oZWFsdGhjYXJlLmljdS52'
    'MS5SZW1vdmVEZXZpY2VSZXNwb25zZRJfCgxSZXZpZXdEZXZpY2USJi5oZWFsdGhjYXJlLmljdS'
    '52MS5SZXZpZXdEZXZpY2VSZXF1ZXN0GicuaGVhbHRoY2FyZS5pY3UudjEuUmV2aWV3RGV2aWNl'
    'UmVzcG9uc2USXAoLTGlzdERldmljZXMSJS5oZWFsdGhjYXJlLmljdS52MS5MaXN0RGV2aWNlc1'
    'JlcXVlc3QaJi5oZWFsdGhjYXJlLmljdS52MS5MaXN0RGV2aWNlc1Jlc3BvbnNlEmUKDkNhbGN1'
    'bGF0ZVNjb3JlEiguaGVhbHRoY2FyZS5pY3UudjEuQ2FsY3VsYXRlU2NvcmVSZXF1ZXN0GikuaG'
    'VhbHRoY2FyZS5pY3UudjEuQ2FsY3VsYXRlU2NvcmVSZXNwb25zZRJZCgpMaXN0U2NvcmVzEiQu'
    'aGVhbHRoY2FyZS5pY3UudjEuTGlzdFNjb3Jlc1JlcXVlc3QaJS5oZWFsdGhjYXJlLmljdS52MS'
    '5MaXN0U2NvcmVzUmVzcG9uc2USZQoOUmVwcm9kdWNlU2NvcmUSKC5oZWFsdGhjYXJlLmljdS52'
    'MS5SZXByb2R1Y2VTY29yZVJlcXVlc3QaKS5oZWFsdGhjYXJlLmljdS52MS5SZXByb2R1Y2VTY2'
    '9yZVJlc3BvbnNlEmIKDVBlcmZvcm1CdW5kbGUSJy5oZWFsdGhjYXJlLmljdS52MS5QZXJmb3Jt'
    'QnVuZGxlUmVxdWVzdBooLmhlYWx0aGNhcmUuaWN1LnYxLlBlcmZvcm1CdW5kbGVSZXNwb25zZR'
    'JcCgtMaXN0QnVuZGxlcxIlLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RCdW5kbGVzUmVxdWVzdBom'
    'LmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RCdW5kbGVzUmVzcG9uc2USawoQUmVjb3JkQXNzZXNzbW'
    'VudBIqLmhlYWx0aGNhcmUuaWN1LnYxLlJlY29yZEFzc2Vzc21lbnRSZXF1ZXN0GisuaGVhbHRo'
    'Y2FyZS5pY3UudjEuUmVjb3JkQXNzZXNzbWVudFJlc3BvbnNlEnEKEkxpc3REdWVBc3Nlc3NtZW'
    '50cxIsLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3REdWVBc3Nlc3NtZW50c1JlcXVlc3QaLS5oZWFs'
    'dGhjYXJlLmljdS52MS5MaXN0RHVlQXNzZXNzbWVudHNSZXNwb25zZRJcCgtSZWNvcmRSb3VuZB'
    'IlLmhlYWx0aGNhcmUuaWN1LnYxLlJlY29yZFJvdW5kUmVxdWVzdBomLmhlYWx0aGNhcmUuaWN1'
    'LnYxLlJlY29yZFJvdW5kUmVzcG9uc2USXAoLUmVzb2x2ZUdvYWwSJS5oZWFsdGhjYXJlLmljdS'
    '52MS5SZXNvbHZlR29hbFJlcXVlc3QaJi5oZWFsdGhjYXJlLmljdS52MS5SZXNvbHZlR29hbFJl'
    'c3BvbnNlEmIKDUxpc3RPcGVuR29hbHMSJy5oZWFsdGhjYXJlLmljdS52MS5MaXN0T3BlbkdvYW'
    'xzUmVxdWVzdBooLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RPcGVuR29hbHNSZXNwb25zZRJZCgpT'
    'ZXRDZWlsaW5nEiQuaGVhbHRoY2FyZS5pY3UudjEuU2V0Q2VpbGluZ1JlcXVlc3QaJS5oZWFsdG'
    'hjYXJlLmljdS52MS5TZXRDZWlsaW5nUmVzcG9uc2USWQoKR2V0Q2VpbGluZxIkLmhlYWx0aGNh'
    'cmUuaWN1LnYxLkdldENlaWxpbmdSZXF1ZXN0GiUuaGVhbHRoY2FyZS5pY3UudjEuR2V0Q2VpbG'
    'luZ1Jlc3BvbnNlEl8KDEdldERhc2hib2FyZBImLmhlYWx0aGNhcmUuaWN1LnYxLkdldERhc2hi'
    'b2FyZFJlcXVlc3QaJy5oZWFsdGhjYXJlLmljdS52MS5HZXREYXNoYm9hcmRSZXNwb25zZRJlCg'
    '5MaXN0QWR2aXNvcmllcxIoLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RBZHZpc29yaWVzUmVxdWVz'
    'dBopLmhlYWx0aGNhcmUuaWN1LnYxLkxpc3RBZHZpc29yaWVzUmVzcG9uc2USawoQRXNjYWxhdG'
    'VBZHZpc29yeRIqLmhlYWx0aGNhcmUuaWN1LnYxLkVzY2FsYXRlQWR2aXNvcnlSZXF1ZXN0Gisu'
    'aGVhbHRoY2FyZS5pY3UudjEuRXNjYWxhdGVBZHZpc29yeVJlc3BvbnNlEmUKDkdldFVuaXRNZX'
    'RyaWNzEiguaGVhbHRoY2FyZS5pY3UudjEuR2V0VW5pdE1ldHJpY3NSZXF1ZXN0GikuaGVhbHRo'
    'Y2FyZS5pY3UudjEuR2V0VW5pdE1ldHJpY3NSZXNwb25zZQ==');
