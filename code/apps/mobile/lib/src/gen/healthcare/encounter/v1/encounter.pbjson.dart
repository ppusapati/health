// This is a generated file - do not edit.
//
// Generated from healthcare/encounter/v1/encounter.proto.

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

@$core.Deprecated('Use encounterClassDescriptor instead')
const EncounterClass$json = {
  '1': 'EncounterClass',
  '2': [
    {'1': 'ENCOUNTER_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'ENCOUNTER_CLASS_OUTPATIENT', '2': 1},
    {'1': 'ENCOUNTER_CLASS_EMERGENCY', '2': 2},
    {'1': 'ENCOUNTER_CLASS_INPATIENT', '2': 3},
    {'1': 'ENCOUNTER_CLASS_DAY_CARE', '2': 4},
    {'1': 'ENCOUNTER_CLASS_TELEMEDICINE', '2': 5},
    {'1': 'ENCOUNTER_CLASS_HOME_CARE', '2': 6},
    {'1': 'ENCOUNTER_CLASS_DIAGNOSTIC_ONLY', '2': 7},
  ],
};

/// Descriptor for `EncounterClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List encounterClassDescriptor = $convert.base64Decode(
    'Cg5FbmNvdW50ZXJDbGFzcxIfChtFTkNPVU5URVJfQ0xBU1NfVU5TUEVDSUZJRUQQABIeChpFTk'
    'NPVU5URVJfQ0xBU1NfT1VUUEFUSUVOVBABEh0KGUVOQ09VTlRFUl9DTEFTU19FTUVSR0VOQ1kQ'
    'AhIdChlFTkNPVU5URVJfQ0xBU1NfSU5QQVRJRU5UEAMSHAoYRU5DT1VOVEVSX0NMQVNTX0RBWV'
    '9DQVJFEAQSIAocRU5DT1VOVEVSX0NMQVNTX1RFTEVNRURJQ0lORRAFEh0KGUVOQ09VTlRFUl9D'
    'TEFTU19IT01FX0NBUkUQBhIjCh9FTkNPVU5URVJfQ0xBU1NfRElBR05PU1RJQ19PTkxZEAc=');

@$core.Deprecated('Use encounterStatusDescriptor instead')
const EncounterStatus$json = {
  '1': 'EncounterStatus',
  '2': [
    {'1': 'ENCOUNTER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ENCOUNTER_STATUS_PLANNED', '2': 1},
    {'1': 'ENCOUNTER_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'ENCOUNTER_STATUS_ON_LEAVE', '2': 3},
    {'1': 'ENCOUNTER_STATUS_FINISHED', '2': 4},
    {'1': 'ENCOUNTER_STATUS_CLOSED', '2': 5},
    {'1': 'ENCOUNTER_STATUS_CANCELLED', '2': 6},
    {'1': 'ENCOUNTER_STATUS_ENTERED_IN_ERROR', '2': 7},
  ],
};

/// Descriptor for `EncounterStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List encounterStatusDescriptor = $convert.base64Decode(
    'Cg9FbmNvdW50ZXJTdGF0dXMSIAocRU5DT1VOVEVSX1NUQVRVU19VTlNQRUNJRklFRBAAEhwKGE'
    'VOQ09VTlRFUl9TVEFUVVNfUExBTk5FRBABEiAKHEVOQ09VTlRFUl9TVEFUVVNfSU5fUFJPR1JF'
    'U1MQAhIdChlFTkNPVU5URVJfU1RBVFVTX09OX0xFQVZFEAMSHQoZRU5DT1VOVEVSX1NUQVRVU1'
    '9GSU5JU0hFRBAEEhsKF0VOQ09VTlRFUl9TVEFUVVNfQ0xPU0VEEAUSHgoaRU5DT1VOVEVSX1NU'
    'QVRVU19DQU5DRUxMRUQQBhIlCiFFTkNPVU5URVJfU1RBVFVTX0VOVEVSRURfSU5fRVJST1IQBw'
    '==');

@$core.Deprecated('Use episodeTypeDescriptor instead')
const EpisodeType$json = {
  '1': 'EpisodeType',
  '2': [
    {'1': 'EPISODE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'EPISODE_TYPE_PREGNANCY', '2': 1},
    {'1': 'EPISODE_TYPE_ONCOLOGY', '2': 2},
    {'1': 'EPISODE_TYPE_DIALYSIS', '2': 3},
    {'1': 'EPISODE_TYPE_CHRONIC_DISEASE', '2': 4},
    {'1': 'EPISODE_TYPE_REHABILITATION', '2': 5},
    {'1': 'EPISODE_TYPE_SURGICAL_CARE', '2': 6},
    {'1': 'EPISODE_TYPE_OTHER', '2': 7},
  ],
};

/// Descriptor for `EpisodeType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List episodeTypeDescriptor = $convert.base64Decode(
    'CgtFcGlzb2RlVHlwZRIcChhFUElTT0RFX1RZUEVfVU5TUEVDSUZJRUQQABIaChZFUElTT0RFX1'
    'RZUEVfUFJFR05BTkNZEAESGQoVRVBJU09ERV9UWVBFX09OQ09MT0dZEAISGQoVRVBJU09ERV9U'
    'WVBFX0RJQUxZU0lTEAMSIAocRVBJU09ERV9UWVBFX0NIUk9OSUNfRElTRUFTRRAEEh8KG0VQSV'
    'NPREVfVFlQRV9SRUhBQklMSVRBVElPThAFEh4KGkVQSVNPREVfVFlQRV9TVVJHSUNBTF9DQVJF'
    'EAYSFgoSRVBJU09ERV9UWVBFX09USEVSEAc=');

@$core.Deprecated('Use episodeStatusDescriptor instead')
const EpisodeStatus$json = {
  '1': 'EpisodeStatus',
  '2': [
    {'1': 'EPISODE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'EPISODE_STATUS_ACTIVE', '2': 1},
    {'1': 'EPISODE_STATUS_ON_HOLD', '2': 2},
    {'1': 'EPISODE_STATUS_FINISHED', '2': 3},
    {'1': 'EPISODE_STATUS_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `EpisodeStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List episodeStatusDescriptor = $convert.base64Decode(
    'Cg1FcGlzb2RlU3RhdHVzEh4KGkVQSVNPREVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVRVBJU0'
    '9ERV9TVEFUVVNfQUNUSVZFEAESGgoWRVBJU09ERV9TVEFUVVNfT05fSE9MRBACEhsKF0VQSVNP'
    'REVfU1RBVFVTX0ZJTklTSEVEEAMSHAoYRVBJU09ERV9TVEFUVVNfQ0FOQ0VMTEVEEAQ=');

@$core.Deprecated('Use careTeamRoleDescriptor instead')
const CareTeamRole$json = {
  '1': 'CareTeamRole',
  '2': [
    {'1': 'CARE_TEAM_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'CARE_TEAM_ROLE_ATTENDING', '2': 1},
    {'1': 'CARE_TEAM_ROLE_CONSULTING', '2': 2},
    {'1': 'CARE_TEAM_ROLE_NURSE', '2': 3},
    {'1': 'CARE_TEAM_ROLE_RESIDENT', '2': 4},
    {'1': 'CARE_TEAM_ROLE_THERAPIST', '2': 5},
    {'1': 'CARE_TEAM_ROLE_PHARMACIST', '2': 6},
    {'1': 'CARE_TEAM_ROLE_SOCIAL_WORK', '2': 7},
    {'1': 'CARE_TEAM_ROLE_ADMITTING', '2': 8},
    {'1': 'CARE_TEAM_ROLE_DISCHARGING', '2': 9},
  ],
};

/// Descriptor for `CareTeamRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List careTeamRoleDescriptor = $convert.base64Decode(
    'CgxDYXJlVGVhbVJvbGUSHgoaQ0FSRV9URUFNX1JPTEVfVU5TUEVDSUZJRUQQABIcChhDQVJFX1'
    'RFQU1fUk9MRV9BVFRFTkRJTkcQARIdChlDQVJFX1RFQU1fUk9MRV9DT05TVUxUSU5HEAISGAoU'
    'Q0FSRV9URUFNX1JPTEVfTlVSU0UQAxIbChdDQVJFX1RFQU1fUk9MRV9SRVNJREVOVBAEEhwKGE'
    'NBUkVfVEVBTV9ST0xFX1RIRVJBUElTVBAFEh0KGUNBUkVfVEVBTV9ST0xFX1BIQVJNQUNJU1QQ'
    'BhIeChpDQVJFX1RFQU1fUk9MRV9TT0NJQUxfV09SSxAHEhwKGENBUkVfVEVBTV9ST0xFX0FETU'
    'lUVElORxAIEh4KGkNBUkVfVEVBTV9ST0xFX0RJU0NIQVJHSU5HEAk=');

@$core.Deprecated('Use diagnosisCertaintyDescriptor instead')
const DiagnosisCertainty$json = {
  '1': 'DiagnosisCertainty',
  '2': [
    {'1': 'DIAGNOSIS_CERTAINTY_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSIS_CERTAINTY_PROVISIONAL', '2': 1},
    {'1': 'DIAGNOSIS_CERTAINTY_DIFFERENTIAL', '2': 2},
    {'1': 'DIAGNOSIS_CERTAINTY_FINAL', '2': 3},
    {'1': 'DIAGNOSIS_CERTAINTY_RULED_OUT', '2': 4},
  ],
};

/// Descriptor for `DiagnosisCertainty`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosisCertaintyDescriptor = $convert.base64Decode(
    'ChJEaWFnbm9zaXNDZXJ0YWludHkSIwofRElBR05PU0lTX0NFUlRBSU5UWV9VTlNQRUNJRklFRB'
    'AAEiMKH0RJQUdOT1NJU19DRVJUQUlOVFlfUFJPVklTSU9OQUwQARIkCiBESUFHTk9TSVNfQ0VS'
    'VEFJTlRZX0RJRkZFUkVOVElBTBACEh0KGURJQUdOT1NJU19DRVJUQUlOVFlfRklOQUwQAxIhCh'
    '1ESUFHTk9TSVNfQ0VSVEFJTlRZX1JVTEVEX09VVBAE');

@$core.Deprecated('Use diagnosisRankDescriptor instead')
const DiagnosisRank$json = {
  '1': 'DiagnosisRank',
  '2': [
    {'1': 'DIAGNOSIS_RANK_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSIS_RANK_PRIMARY', '2': 1},
    {'1': 'DIAGNOSIS_RANK_SECONDARY', '2': 2},
    {'1': 'DIAGNOSIS_RANK_COMPLICATION', '2': 3},
    {'1': 'DIAGNOSIS_RANK_COMORBIDITY', '2': 4},
  ],
};

/// Descriptor for `DiagnosisRank`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosisRankDescriptor = $convert.base64Decode(
    'Cg1EaWFnbm9zaXNSYW5rEh4KGkRJQUdOT1NJU19SQU5LX1VOU1BFQ0lGSUVEEAASGgoWRElBR0'
    '5PU0lTX1JBTktfUFJJTUFSWRABEhwKGERJQUdOT1NJU19SQU5LX1NFQ09OREFSWRACEh8KG0RJ'
    'QUdOT1NJU19SQU5LX0NPTVBMSUNBVElPThADEh4KGkRJQUdOT1NJU19SQU5LX0NPTU9SQklESV'
    'RZEAQ=');

@$core.Deprecated('Use timelineEntryKindDescriptor instead')
const TimelineEntryKind$json = {
  '1': 'TimelineEntryKind',
  '2': [
    {'1': 'TIMELINE_ENTRY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TIMELINE_ENTRY_KIND_ENCOUNTER', '2': 1},
    {'1': 'TIMELINE_ENTRY_KIND_DIAGNOSIS', '2': 2},
    {'1': 'TIMELINE_ENTRY_KIND_NOTE', '2': 3},
    {'1': 'TIMELINE_ENTRY_KIND_OBSERVATION', '2': 4},
    {'1': 'TIMELINE_ENTRY_KIND_MEDICATION', '2': 5},
    {'1': 'TIMELINE_ENTRY_KIND_PROCEDURE', '2': 6},
    {'1': 'TIMELINE_ENTRY_KIND_ORDER', '2': 7},
    {'1': 'TIMELINE_ENTRY_KIND_DOCUMENT', '2': 8},
    {'1': 'TIMELINE_ENTRY_KIND_IMAGING', '2': 9},
    {'1': 'TIMELINE_ENTRY_KIND_ALLERGY', '2': 10},
  ],
};

/// Descriptor for `TimelineEntryKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List timelineEntryKindDescriptor = $convert.base64Decode(
    'ChFUaW1lbGluZUVudHJ5S2luZBIjCh9USU1FTElORV9FTlRSWV9LSU5EX1VOU1BFQ0lGSUVEEA'
    'ASIQodVElNRUxJTkVfRU5UUllfS0lORF9FTkNPVU5URVIQARIhCh1USU1FTElORV9FTlRSWV9L'
    'SU5EX0RJQUdOT1NJUxACEhwKGFRJTUVMSU5FX0VOVFJZX0tJTkRfTk9URRADEiMKH1RJTUVMSU'
    '5FX0VOVFJZX0tJTkRfT0JTRVJWQVRJT04QBBIiCh5USU1FTElORV9FTlRSWV9LSU5EX01FRElD'
    'QVRJT04QBRIhCh1USU1FTElORV9FTlRSWV9LSU5EX1BST0NFRFVSRRAGEh0KGVRJTUVMSU5FX0'
    'VOVFJZX0tJTkRfT1JERVIQBxIgChxUSU1FTElORV9FTlRSWV9LSU5EX0RPQ1VNRU5UEAgSHwob'
    'VElNRUxJTkVfRU5UUllfS0lORF9JTUFHSU5HEAkSHwobVElNRUxJTkVfRU5UUllfS0lORF9BTE'
    'xFUkdZEAo=');

@$core.Deprecated('Use confidentialityDescriptor instead')
const Confidentiality$json = {
  '1': 'Confidentiality',
  '2': [
    {'1': 'CONFIDENTIALITY_UNSPECIFIED', '2': 0},
    {'1': 'CONFIDENTIALITY_NORMAL', '2': 1},
    {'1': 'CONFIDENTIALITY_RESTRICTED', '2': 2},
    {'1': 'CONFIDENTIALITY_VERY_RESTRICTED', '2': 3},
  ],
};

/// Descriptor for `Confidentiality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List confidentialityDescriptor = $convert.base64Decode(
    'Cg9Db25maWRlbnRpYWxpdHkSHwobQ09ORklERU5USUFMSVRZX1VOU1BFQ0lGSUVEEAASGgoWQ0'
    '9ORklERU5USUFMSVRZX05PUk1BTBABEh4KGkNPTkZJREVOVElBTElUWV9SRVNUUklDVEVEEAIS'
    'IwofQ09ORklERU5USUFMSVRZX1ZFUllfUkVTVFJJQ1RFRBAD');

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

@$core.Deprecated('Use encounterStatusChangeDescriptor instead')
const EncounterStatusChange$json = {
  '1': 'EncounterStatusChange',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterStatus',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterStatus',
      '10': 'to'
    },
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'by', '3': 4, '4': 1, '5': 9, '10': 'by'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `EncounterStatusChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encounterStatusChangeDescriptor = $convert.base64Decode(
    'ChVFbmNvdW50ZXJTdGF0dXNDaGFuZ2USPAoEZnJvbRgBIAEoDjIoLmhlYWx0aGNhcmUuZW5jb3'
    'VudGVyLnYxLkVuY291bnRlclN0YXR1c1IEZnJvbRI4CgJ0bxgCIAEoDjIoLmhlYWx0aGNhcmUu'
    'ZW5jb3VudGVyLnYxLkVuY291bnRlclN0YXR1c1ICdG8SKgoCYXQYAyABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgJhdBIOCgJieRgEIAEoCVICYnkSFgoGcmVhc29uGAUgASgJUgZy'
    'ZWFzb24=');

@$core.Deprecated('Use encounterDescriptor instead')
const Encounter$json = {
  '1': 'Encounter',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 3, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'class',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterClass',
      '10': 'class'
    },
    {'1': 'visit_type', '3': 6, '4': 1, '5': 9, '10': 'visitType'},
    {
      '1': 'attending_provider_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'attendingProviderId'
    },
    {'1': 'appointment_id', '3': 8, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'episode_id', '3': 9, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'referral_id', '3': 10, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'reason', '3': 11, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterStatus',
      '10': 'status'
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
    {
      '1': 'closed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {
      '1': 'history',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.EncounterStatusChange',
      '10': 'history'
    },
    {'1': 'created_by', '3': 17, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'version', '3': 19, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Encounter`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List encounterDescriptor = $convert.base64Decode(
    'CglFbmNvdW50ZXISIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZBIfCgtmYWNpbG'
    'l0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIeCgtvcmdfdW5pdF9pZBgDIAEoCVIJb3JnVW5pdElk'
    'Eh0KCnBhdGllbnRfaWQYBCABKAlSCXBhdGllbnRJZBI9CgVjbGFzcxgFIAEoDjInLmhlYWx0aG'
    'NhcmUuZW5jb3VudGVyLnYxLkVuY291bnRlckNsYXNzUgVjbGFzcxIdCgp2aXNpdF90eXBlGAYg'
    'ASgJUgl2aXNpdFR5cGUSMgoVYXR0ZW5kaW5nX3Byb3ZpZGVyX2lkGAcgASgJUhNhdHRlbmRpbm'
    'dQcm92aWRlcklkEiUKDmFwcG9pbnRtZW50X2lkGAggASgJUg1hcHBvaW50bWVudElkEh0KCmVw'
    'aXNvZGVfaWQYCSABKAlSCWVwaXNvZGVJZBIfCgtyZWZlcnJhbF9pZBgKIAEoCVIKcmVmZXJyYW'
    'xJZBIWCgZyZWFzb24YCyABKAlSBnJlYXNvbhJACgZzdGF0dXMYDCABKA4yKC5oZWFsdGhjYXJl'
    'LmVuY291bnRlci52MS5FbmNvdW50ZXJTdGF0dXNSBnN0YXR1cxI5CgpzdGFydGVkX2F0GA0gAS'
    'gLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0EjUKCGVuZGVkX2F0GA4g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBI3CgljbG9zZWRfYXQYDy'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghjbG9zZWRBdBJICgdoaXN0b3J5GBAg'
    'AygLMi4uaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuRW5jb3VudGVyU3RhdHVzQ2hhbmdlUgdoaX'
    'N0b3J5Eh0KCmNyZWF0ZWRfYnkYESABKAlSCWNyZWF0ZWRCeRI5CgpjcmVhdGVkX2F0GBIgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EhgKB3ZlcnNpb24YEyABKA'
    'NSB3ZlcnNpb24=');

@$core.Deprecated('Use episodeDescriptor instead')
const Episode$json = {
  '1': 'Episode',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EpisodeType',
      '10': 'type'
    },
    {'1': 'label', '3': 5, '4': 1, '5': 9, '10': 'label'},
    {'1': 'care_manager_id', '3': 6, '4': 1, '5': 9, '10': 'careManagerId'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EpisodeStatus',
      '10': 'status'
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

/// Descriptor for `Episode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List episodeDescriptor = $convert.base64Decode(
    'CgdFcGlzb2RlEh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSOAoEdHlw'
    'ZRgEIAEoDjIkLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkVwaXNvZGVUeXBlUgR0eXBlEhQKBW'
    'xhYmVsGAUgASgJUgVsYWJlbBImCg9jYXJlX21hbmFnZXJfaWQYBiABKAlSDWNhcmVNYW5hZ2Vy'
    'SWQSPgoGc3RhdHVzGAcgASgOMiYuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuRXBpc29kZVN0YX'
    'R1c1IGc3RhdHVzEjkKCnN0YXJ0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUglzdGFydGVkQXQSNQoIZW5kZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgdlbmRlZEF0EhgKB3ZlcnNpb24YCiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use careTeamMemberDescriptor instead')
const CareTeamMember$json = {
  '1': 'CareTeamMember',
  '2': [
    {'1': 'care_team_id', '3': 1, '4': 1, '5': 9, '10': 'careTeamId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'subject_id', '3': 3, '4': 1, '5': 9, '10': 'subjectId'},
    {
      '1': 'role',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.CareTeamRole',
      '10': 'role'
    },
    {
      '1': 'effective_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
    {'1': 'assigned_by', '3': 7, '4': 1, '5': 9, '10': 'assignedBy'},
  ],
};

/// Descriptor for `CareTeamMember`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List careTeamMemberDescriptor = $convert.base64Decode(
    'Cg5DYXJlVGVhbU1lbWJlchIgCgxjYXJlX3RlYW1faWQYASABKAlSCmNhcmVUZWFtSWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIdCgpzdWJqZWN0X2lkGAMgASgJUglzdWJq'
    'ZWN0SWQSOQoEcm9sZRgEIAEoDjIlLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNhcmVUZWFtUm'
    '9sZVIEcm9sZRJBCg5lZmZlY3RpdmVfZnJvbRgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSDWVmZmVjdGl2ZUZyb20SQwoPZWZmZWN0aXZlX3VudGlsGAYgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIOZWZmZWN0aXZlVW50aWwSHwoLYXNzaWduZWRfYnkYByABKAlS'
    'CmFzc2lnbmVkQnk=');

@$core.Deprecated('Use diagnosisDescriptor instead')
const Diagnosis$json = {
  '1': 'Diagnosis',
  '2': [
    {'1': 'diagnosis_id', '3': 1, '4': 1, '5': 9, '10': 'diagnosisId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'certainty',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.DiagnosisCertainty',
      '10': 'certainty'
    },
    {
      '1': 'rank',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.DiagnosisRank',
      '10': 'rank'
    },
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'onset_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'superseded_by_id', '3': 9, '4': 1, '5': 9, '10': 'supersededById'},
    {'1': 'retracted_reason', '3': 10, '4': 1, '5': 9, '10': 'retractedReason'},
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `Diagnosis`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diagnosisDescriptor = $convert.base64Decode(
    'CglEaWFnbm9zaXMSIQoMZGlhZ25vc2lzX2lkGAEgASgJUgtkaWFnbm9zaXNJZBIhCgxlbmNvdW'
    '50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJ'
    'ZBIzCgRjb2RlGAQgASgLMh8uaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuQ29kaW5nUgRjb2RlEk'
    'kKCWNlcnRhaW50eRgFIAEoDjIrLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkRpYWdub3Npc0Nl'
    'cnRhaW50eVIJY2VydGFpbnR5EjoKBHJhbmsYBiABKA4yJi5oZWFsdGhjYXJlLmVuY291bnRlci'
    '52MS5EaWFnbm9zaXNSYW5rUgRyYW5rEhIKBG5vdGUYByABKAlSBG5vdGUSNQoIb25zZXRfYXQY'
    'CCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdvbnNldEF0EigKEHN1cGVyc2VkZW'
    'RfYnlfaWQYCSABKAlSDnN1cGVyc2VkZWRCeUlkEikKEHJldHJhY3RlZF9yZWFzb24YCiABKAlS'
    'D3JldHJhY3RlZFJlYXNvbhIfCgtyZWNvcmRlZF9ieRgLIAEoCVIKcmVjb3JkZWRCeRI7CgtyZW'
    'NvcmRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQ=');

@$core.Deprecated('Use visitSummaryDescriptor instead')
const VisitSummary$json = {
  '1': 'VisitSummary',
  '2': [
    {'1': 'summary_id', '3': 1, '4': 1, '5': 9, '10': 'summaryId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'version', '3': 4, '4': 1, '5': 5, '10': 'version'},
    {'1': 'supersedes_id', '3': 5, '4': 1, '5': 9, '10': 'supersedesId'},
    {'1': 'amendment_reason', '3': 6, '4': 1, '5': 9, '10': 'amendmentReason'},
    {
      '1': 'class',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterClass',
      '10': 'class'
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
    {
      '1': 'diagnoses',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.Coding',
      '10': 'diagnoses'
    },
    {'1': 'care_team', '3': 11, '4': 3, '5': 9, '10': 'careTeam'},
    {'1': 'narrative', '3': 12, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'generated_by', '3': 13, '4': 1, '5': 9, '10': 'generatedBy'},
    {
      '1': 'generated_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'generatedAt'
    },
  ],
};

/// Descriptor for `VisitSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List visitSummaryDescriptor = $convert.base64Decode(
    'CgxWaXNpdFN1bW1hcnkSHQoKc3VtbWFyeV9pZBgBIAEoCVIJc3VtbWFyeUlkEiEKDGVuY291bn'
    'Rlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElk'
    'EhgKB3ZlcnNpb24YBCABKAVSB3ZlcnNpb24SIwoNc3VwZXJzZWRlc19pZBgFIAEoCVIMc3VwZX'
    'JzZWRlc0lkEikKEGFtZW5kbWVudF9yZWFzb24YBiABKAlSD2FtZW5kbWVudFJlYXNvbhI9CgVj'
    'bGFzcxgHIAEoDjInLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkVuY291bnRlckNsYXNzUgVjbG'
    'FzcxI5CgpzdGFydGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3Rh'
    'cnRlZEF0EjUKCGVuZGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW'
    '5kZWRBdBI9CglkaWFnbm9zZXMYCiADKAsyHy5oZWFsdGhjYXJlLmVuY291bnRlci52MS5Db2Rp'
    'bmdSCWRpYWdub3NlcxIbCgljYXJlX3RlYW0YCyADKAlSCGNhcmVUZWFtEhwKCW5hcnJhdGl2ZR'
    'gMIAEoCVIJbmFycmF0aXZlEiEKDGdlbmVyYXRlZF9ieRgNIAEoCVILZ2VuZXJhdGVkQnkSPQoM'
    'Z2VuZXJhdGVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZ2VuZXJhdG'
    'VkQXQ=');

@$core.Deprecated('Use timelineEntryDescriptor instead')
const TimelineEntry$json = {
  '1': 'TimelineEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.TimelineEntryKind',
      '10': 'kind'
    },
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'confidentiality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {'1': 'masked', '3': 7, '4': 1, '5': 8, '10': 'masked'},
  ],
};

/// Descriptor for `TimelineEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timelineEntryDescriptor = $convert.base64Decode(
    'Cg1UaW1lbGluZUVudHJ5EhkKCGVudHJ5X2lkGAEgASgJUgdlbnRyeUlkEj4KBGtpbmQYAiABKA'
    '4yKi5oZWFsdGhjYXJlLmVuY291bnRlci52MS5UaW1lbGluZUVudHJ5S2luZFIEa2luZBIqCgJh'
    'dBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAmF0EiEKDGVuY291bnRlcl9pZB'
    'gEIAEoCVILZW5jb3VudGVySWQSFAoFdGl0bGUYBSABKAlSBXRpdGxlElIKD2NvbmZpZGVudGlh'
    'bGl0eRgGIAEoDjIoLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNvbmZpZGVudGlhbGl0eVIPY2'
    '9uZmlkZW50aWFsaXR5EhYKBm1hc2tlZBgHIAEoCFIGbWFza2Vk');

@$core.Deprecated('Use closurePolicyForClassDescriptor instead')
const ClosurePolicyForClass$json = {
  '1': 'ClosurePolicyForClass',
  '2': [
    {
      '1': 'class',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterClass',
      '10': 'class'
    },
    {'1': 'required_items', '3': 2, '4': 3, '5': 9, '10': 'requiredItems'},
    {'1': 'allow_override', '3': 3, '4': 1, '5': 8, '10': 'allowOverride'},
  ],
};

/// Descriptor for `ClosurePolicyForClass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closurePolicyForClassDescriptor = $convert.base64Decode(
    'ChVDbG9zdXJlUG9saWN5Rm9yQ2xhc3MSPQoFY2xhc3MYASABKA4yJy5oZWFsdGhjYXJlLmVuY2'
    '91bnRlci52MS5FbmNvdW50ZXJDbGFzc1IFY2xhc3MSJQoOcmVxdWlyZWRfaXRlbXMYAiADKAlS'
    'DXJlcXVpcmVkSXRlbXMSJQoOYWxsb3dfb3ZlcnJpZGUYAyABKAhSDWFsbG93T3ZlcnJpZGU=');

@$core.Deprecated('Use closureOverrideDescriptor instead')
const ClosureOverride$json = {
  '1': 'ClosureOverride',
  '2': [
    {'1': 'override_id', '3': 1, '4': 1, '5': 9, '10': 'overrideId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'missing_items', '3': 3, '4': 3, '5': 9, '10': 'missingItems'},
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'overridden_by', '3': 5, '4': 1, '5': 9, '10': 'overriddenBy'},
    {
      '1': 'overridden_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'overriddenAt'
    },
  ],
};

/// Descriptor for `ClosureOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closureOverrideDescriptor = $convert.base64Decode(
    'Cg9DbG9zdXJlT3ZlcnJpZGUSHwoLb3ZlcnJpZGVfaWQYASABKAlSCm92ZXJyaWRlSWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIjCg1taXNzaW5nX2l0ZW1zGAMgAygJUgxt'
    'aXNzaW5nSXRlbXMSFgoGcmVhc29uGAQgASgJUgZyZWFzb24SIwoNb3ZlcnJpZGRlbl9ieRgFIA'
    'EoCVIMb3ZlcnJpZGRlbkJ5Ej8KDW92ZXJyaWRkZW5fYXQYBiABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgxvdmVycmlkZGVuQXQ=');

@$core.Deprecated('Use openEncounterRequestDescriptor instead')
const OpenEncounterRequest$json = {
  '1': 'OpenEncounterRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 3, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterClass',
      '10': 'class'
    },
    {'1': 'visit_type', '3': 5, '4': 1, '5': 9, '10': 'visitType'},
    {
      '1': 'attending_provider_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'attendingProviderId'
    },
    {'1': 'appointment_id', '3': 7, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'episode_id', '3': 8, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'referral_id', '3': 9, '4': 1, '5': 9, '10': 'referralId'},
    {'1': 'reason', '3': 10, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'start_immediately',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'startImmediately'
    },
    {
      '1': 'started_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `OpenEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openEncounterRequestDescriptor = $convert.base64Decode(
    'ChRPcGVuRW5jb3VudGVyUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSHw'
    'oLZmFjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSHgoLb3JnX3VuaXRfaWQYAyABKAlSCW9y'
    'Z1VuaXRJZBI9CgVjbGFzcxgEIAEoDjInLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkVuY291bn'
    'RlckNsYXNzUgVjbGFzcxIdCgp2aXNpdF90eXBlGAUgASgJUgl2aXNpdFR5cGUSMgoVYXR0ZW5k'
    'aW5nX3Byb3ZpZGVyX2lkGAYgASgJUhNhdHRlbmRpbmdQcm92aWRlcklkEiUKDmFwcG9pbnRtZW'
    '50X2lkGAcgASgJUg1hcHBvaW50bWVudElkEh0KCmVwaXNvZGVfaWQYCCABKAlSCWVwaXNvZGVJ'
    'ZBIfCgtyZWZlcnJhbF9pZBgJIAEoCVIKcmVmZXJyYWxJZBIWCgZyZWFzb24YCiABKAlSBnJlYX'
    'NvbhIrChFzdGFydF9pbW1lZGlhdGVseRgLIAEoCFIQc3RhcnRJbW1lZGlhdGVseRI5CgpzdGFy'
    'dGVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0');

@$core.Deprecated('Use openEncounterResponseDescriptor instead')
const OpenEncounterResponse$json = {
  '1': 'OpenEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `OpenEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openEncounterResponseDescriptor = $convert.base64Decode(
    'ChVPcGVuRW5jb3VudGVyUmVzcG9uc2USQAoJZW5jb3VudGVyGAEgASgLMiIuaGVhbHRoY2FyZS'
    '5lbmNvdW50ZXIudjEuRW5jb3VudGVyUgllbmNvdW50ZXI=');

@$core.Deprecated('Use startEncounterRequestDescriptor instead')
const StartEncounterRequest$json = {
  '1': 'StartEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'started_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEncounterRequestDescriptor = $convert.base64Decode(
    'ChVTdGFydEVuY291bnRlclJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZX'
    'JJZBI5CgpzdGFydGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3Rh'
    'cnRlZEF0');

@$core.Deprecated('Use startEncounterResponseDescriptor instead')
const StartEncounterResponse$json = {
  '1': 'StartEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `StartEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startEncounterResponseDescriptor =
    $convert.base64Decode(
        'ChZTdGFydEVuY291bnRlclJlc3BvbnNlEkAKCWVuY291bnRlchgBIAEoCzIiLmhlYWx0aGNhcm'
        'UuZW5jb3VudGVyLnYxLkVuY291bnRlclIJZW5jb3VudGVy');

@$core.Deprecated('Use endEncounterRequestDescriptor instead')
const EndEncounterRequest$json = {
  '1': 'EndEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'ended_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `EndEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endEncounterRequestDescriptor = $convert.base64Decode(
    'ChNFbmRFbmNvdW50ZXJSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'QSNQoIZW5kZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRlZEF0');

@$core.Deprecated('Use endEncounterResponseDescriptor instead')
const EndEncounterResponse$json = {
  '1': 'EndEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `EndEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endEncounterResponseDescriptor = $convert.base64Decode(
    'ChRFbmRFbmNvdW50ZXJSZXNwb25zZRJACgllbmNvdW50ZXIYASABKAsyIi5oZWFsdGhjYXJlLm'
    'VuY291bnRlci52MS5FbmNvdW50ZXJSCWVuY291bnRlcg==');

@$core.Deprecated('Use cancelEncounterRequestDescriptor instead')
const CancelEncounterRequest$json = {
  '1': 'CancelEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'entered_in_error', '3': 3, '4': 1, '5': 8, '10': 'enteredInError'},
  ],
};

/// Descriptor for `CancelEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelEncounterRequestDescriptor = $convert.base64Decode(
    'ChZDYW5jZWxFbmNvdW50ZXJSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
    'VySWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24SKAoQZW50ZXJlZF9pbl9lcnJvchgDIAEoCFIO'
    'ZW50ZXJlZEluRXJyb3I=');

@$core.Deprecated('Use cancelEncounterResponseDescriptor instead')
const CancelEncounterResponse$json = {
  '1': 'CancelEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `CancelEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelEncounterResponseDescriptor =
    $convert.base64Decode(
        'ChdDYW5jZWxFbmNvdW50ZXJSZXNwb25zZRJACgllbmNvdW50ZXIYASABKAsyIi5oZWFsdGhjYX'
        'JlLmVuY291bnRlci52MS5FbmNvdW50ZXJSCWVuY291bnRlcg==');

@$core.Deprecated('Use reopenEncounterRequestDescriptor instead')
const ReopenEncounterRequest$json = {
  '1': 'ReopenEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReopenEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reopenEncounterRequestDescriptor =
    $convert.base64Decode(
        'ChZSZW9wZW5FbmNvdW50ZXJSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
        'VySWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use reopenEncounterResponseDescriptor instead')
const ReopenEncounterResponse$json = {
  '1': 'ReopenEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `ReopenEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reopenEncounterResponseDescriptor =
    $convert.base64Decode(
        'ChdSZW9wZW5FbmNvdW50ZXJSZXNwb25zZRJACgllbmNvdW50ZXIYASABKAsyIi5oZWFsdGhjYX'
        'JlLmVuY291bnRlci52MS5FbmNvdW50ZXJSCWVuY291bnRlcg==');

@$core.Deprecated('Use setEncounterLeaveRequestDescriptor instead')
const SetEncounterLeaveRequest$json = {
  '1': 'SetEncounterLeaveRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'returning', '3': 3, '4': 1, '5': 8, '10': 'returning'},
  ],
};

/// Descriptor for `SetEncounterLeaveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setEncounterLeaveRequestDescriptor = $convert.base64Decode(
    'ChhTZXRFbmNvdW50ZXJMZWF2ZVJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW'
    '50ZXJJZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbhIcCglyZXR1cm5pbmcYAyABKAhSCXJldHVy'
    'bmluZw==');

@$core.Deprecated('Use setEncounterLeaveResponseDescriptor instead')
const SetEncounterLeaveResponse$json = {
  '1': 'SetEncounterLeaveResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `SetEncounterLeaveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setEncounterLeaveResponseDescriptor =
    $convert.base64Decode(
        'ChlTZXRFbmNvdW50ZXJMZWF2ZVJlc3BvbnNlEkAKCWVuY291bnRlchgBIAEoCzIiLmhlYWx0aG'
        'NhcmUuZW5jb3VudGVyLnYxLkVuY291bnRlclIJZW5jb3VudGVy');

@$core.Deprecated('Use getEncounterRequestDescriptor instead')
const GetEncounterRequest$json = {
  '1': 'GetEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `GetEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEncounterRequestDescriptor = $convert.base64Decode(
    'ChNHZXRFbmNvdW50ZXJSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'Q=');

@$core.Deprecated('Use getEncounterResponseDescriptor instead')
const GetEncounterResponse$json = {
  '1': 'GetEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
  ],
};

/// Descriptor for `GetEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEncounterResponseDescriptor = $convert.base64Decode(
    'ChRHZXRFbmNvdW50ZXJSZXNwb25zZRJACgllbmNvdW50ZXIYASABKAsyIi5oZWFsdGhjYXJlLm'
    'VuY291bnRlci52MS5FbmNvdW50ZXJSCWVuY291bnRlcg==');

@$core.Deprecated('Use listEncountersRequestDescriptor instead')
const ListEncountersRequest$json = {
  '1': 'ListEncountersRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'episode_id', '3': 3, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'class',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EncounterClass',
      '10': 'class'
    },
    {
      '1': 'include_retracted',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'includeRetracted'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListEncountersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEncountersRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RW5jb3VudGVyc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEh'
    '8KC2ZhY2lsaXR5X2lkGAIgASgJUgpmYWNpbGl0eUlkEh0KCmVwaXNvZGVfaWQYAyABKAlSCWVw'
    'aXNvZGVJZBI9CgVjbGFzcxgEIAEoDjInLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkVuY291bn'
    'RlckNsYXNzUgVjbGFzcxIrChFpbmNsdWRlX3JldHJhY3RlZBgFIAEoCFIQaW5jbHVkZVJldHJh'
    'Y3RlZBIbCglwYWdlX3NpemUYBiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listEncountersResponseDescriptor instead')
const ListEncountersResponse$json = {
  '1': 'ListEncountersResponse',
  '2': [
    {
      '1': 'encounters',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounters'
    },
  ],
};

/// Descriptor for `ListEncountersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEncountersResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RW5jb3VudGVyc1Jlc3BvbnNlEkIKCmVuY291bnRlcnMYASADKAsyIi5oZWFsdGhjYX'
        'JlLmVuY291bnRlci52MS5FbmNvdW50ZXJSCmVuY291bnRlcnM=');

@$core.Deprecated('Use openEpisodeRequestDescriptor instead')
const OpenEpisodeRequest$json = {
  '1': 'OpenEpisodeRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EpisodeType',
      '10': 'type'
    },
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'care_manager_id', '3': 5, '4': 1, '5': 9, '10': 'careManagerId'},
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `OpenEpisodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openEpisodeRequestDescriptor = $convert.base64Decode(
    'ChJPcGVuRXBpc29kZVJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEh8KC2'
    'ZhY2lsaXR5X2lkGAIgASgJUgpmYWNpbGl0eUlkEjgKBHR5cGUYAyABKA4yJC5oZWFsdGhjYXJl'
    'LmVuY291bnRlci52MS5FcGlzb2RlVHlwZVIEdHlwZRIUCgVsYWJlbBgEIAEoCVIFbGFiZWwSJg'
    'oPY2FyZV9tYW5hZ2VyX2lkGAUgASgJUg1jYXJlTWFuYWdlcklkEjkKCnN0YXJ0ZWRfYXQYBiAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQ=');

@$core.Deprecated('Use openEpisodeResponseDescriptor instead')
const OpenEpisodeResponse$json = {
  '1': 'OpenEpisodeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Episode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `OpenEpisodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openEpisodeResponseDescriptor = $convert.base64Decode(
    'ChNPcGVuRXBpc29kZVJlc3BvbnNlEjoKB2VwaXNvZGUYASABKAsyIC5oZWFsdGhjYXJlLmVuY2'
    '91bnRlci52MS5FcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use setEpisodeStatusRequestDescriptor instead')
const SetEpisodeStatusRequest$json = {
  '1': 'SetEpisodeStatusRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.EpisodeStatus',
      '10': 'status'
    },
    {
      '1': 'ended_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
};

/// Descriptor for `SetEpisodeStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setEpisodeStatusRequestDescriptor = $convert.base64Decode(
    'ChdTZXRFcGlzb2RlU3RhdHVzUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSW'
    'QSPgoGc3RhdHVzGAIgASgOMiYuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuRXBpc29kZVN0YXR1'
    'c1IGc3RhdHVzEjUKCGVuZGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IHZW5kZWRBdA==');

@$core.Deprecated('Use setEpisodeStatusResponseDescriptor instead')
const SetEpisodeStatusResponse$json = {
  '1': 'SetEpisodeStatusResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Episode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `SetEpisodeStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setEpisodeStatusResponseDescriptor =
    $convert.base64Decode(
        'ChhTZXRFcGlzb2RlU3RhdHVzUmVzcG9uc2USOgoHZXBpc29kZRgBIAEoCzIgLmhlYWx0aGNhcm'
        'UuZW5jb3VudGVyLnYxLkVwaXNvZGVSB2VwaXNvZGU=');

@$core.Deprecated('Use listEpisodesRequestDescriptor instead')
const ListEpisodesRequest$json = {
  '1': 'ListEpisodesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListEpisodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEpisodesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RXBpc29kZXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIbCg'
    'lvcGVuX29ubHkYAiABKAhSCG9wZW5Pbmx5EhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listEpisodesResponseDescriptor instead')
const ListEpisodesResponse$json = {
  '1': 'ListEpisodesResponse',
  '2': [
    {
      '1': 'episodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.Episode',
      '10': 'episodes'
    },
  ],
};

/// Descriptor for `ListEpisodesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listEpisodesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0RXBpc29kZXNSZXNwb25zZRI8CghlcGlzb2RlcxgBIAMoCzIgLmhlYWx0aGNhcmUuZW'
    '5jb3VudGVyLnYxLkVwaXNvZGVSCGVwaXNvZGVz');

@$core.Deprecated('Use assignCareTeamMemberRequestDescriptor instead')
const AssignCareTeamMemberRequest$json = {
  '1': 'AssignCareTeamMemberRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'subject_id', '3': 2, '4': 1, '5': 9, '10': 'subjectId'},
    {
      '1': 'role',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.CareTeamRole',
      '10': 'role'
    },
    {
      '1': 'effective_from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `AssignCareTeamMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCareTeamMemberRequestDescriptor = $convert.base64Decode(
    'ChtBc3NpZ25DYXJlVGVhbU1lbWJlclJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbm'
    'NvdW50ZXJJZBIdCgpzdWJqZWN0X2lkGAIgASgJUglzdWJqZWN0SWQSOQoEcm9sZRgDIAEoDjIl'
    'LmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNhcmVUZWFtUm9sZVIEcm9sZRJBCg5lZmZlY3Rpdm'
    'VfZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20S'
    'QwoPZWZmZWN0aXZlX3VudGlsGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOZW'
    'ZmZWN0aXZlVW50aWw=');

@$core.Deprecated('Use assignCareTeamMemberResponseDescriptor instead')
const AssignCareTeamMemberResponse$json = {
  '1': 'AssignCareTeamMemberResponse',
  '2': [
    {
      '1': 'member',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.CareTeamMember',
      '10': 'member'
    },
  ],
};

/// Descriptor for `AssignCareTeamMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCareTeamMemberResponseDescriptor =
    $convert.base64Decode(
        'ChxBc3NpZ25DYXJlVGVhbU1lbWJlclJlc3BvbnNlEj8KBm1lbWJlchgBIAEoCzInLmhlYWx0aG'
        'NhcmUuZW5jb3VudGVyLnYxLkNhcmVUZWFtTWVtYmVyUgZtZW1iZXI=');

@$core.Deprecated('Use endCareTeamAssignmentRequestDescriptor instead')
const EndCareTeamAssignmentRequest$json = {
  '1': 'EndCareTeamAssignmentRequest',
  '2': [
    {'1': 'care_team_id', '3': 1, '4': 1, '5': 9, '10': 'careTeamId'},
    {
      '1': 'effective_until',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `EndCareTeamAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCareTeamAssignmentRequestDescriptor =
    $convert.base64Decode(
        'ChxFbmRDYXJlVGVhbUFzc2lnbm1lbnRSZXF1ZXN0EiAKDGNhcmVfdGVhbV9pZBgBIAEoCVIKY2'
        'FyZVRlYW1JZBJDCg9lZmZlY3RpdmVfdW50aWwYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
        'ZXN0YW1wUg5lZmZlY3RpdmVVbnRpbA==');

@$core.Deprecated('Use endCareTeamAssignmentResponseDescriptor instead')
const EndCareTeamAssignmentResponse$json = {
  '1': 'EndCareTeamAssignmentResponse',
};

/// Descriptor for `EndCareTeamAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endCareTeamAssignmentResponseDescriptor =
    $convert.base64Decode('Ch1FbmRDYXJlVGVhbUFzc2lnbm1lbnRSZXNwb25zZQ==');

@$core.Deprecated('Use getCareTeamRequestDescriptor instead')
const GetCareTeamRequest$json = {
  '1': 'GetCareTeamRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `GetCareTeamRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCareTeamRequestDescriptor = $convert.base64Decode(
    'ChJHZXRDYXJlVGVhbVJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZA'
    '==');

@$core.Deprecated('Use getCareTeamResponseDescriptor instead')
const GetCareTeamResponse$json = {
  '1': 'GetCareTeamResponse',
  '2': [
    {
      '1': 'members',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.CareTeamMember',
      '10': 'members'
    },
  ],
};

/// Descriptor for `GetCareTeamResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCareTeamResponseDescriptor = $convert.base64Decode(
    'ChNHZXRDYXJlVGVhbVJlc3BvbnNlEkEKB21lbWJlcnMYASADKAsyJy5oZWFsdGhjYXJlLmVuY2'
    '91bnRlci52MS5DYXJlVGVhbU1lbWJlclIHbWVtYmVycw==');

@$core.Deprecated('Use recordDiagnosisRequestDescriptor instead')
const RecordDiagnosisRequest$json = {
  '1': 'RecordDiagnosisRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'certainty',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.DiagnosisCertainty',
      '10': 'certainty'
    },
    {
      '1': 'rank',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.encounter.v1.DiagnosisRank',
      '10': 'rank'
    },
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'onset_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'supersedes_id', '3': 7, '4': 1, '5': 9, '10': 'supersedesId'},
  ],
};

/// Descriptor for `RecordDiagnosisRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDiagnosisRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvcmREaWFnbm9zaXNSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
    'VySWQSMwoEY29kZRgCIAEoCzIfLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNvZGluZ1IEY29k'
    'ZRJJCgljZXJ0YWludHkYAyABKA4yKy5oZWFsdGhjYXJlLmVuY291bnRlci52MS5EaWFnbm9zaX'
    'NDZXJ0YWludHlSCWNlcnRhaW50eRI6CgRyYW5rGAQgASgOMiYuaGVhbHRoY2FyZS5lbmNvdW50'
    'ZXIudjEuRGlhZ25vc2lzUmFua1IEcmFuaxISCgRub3RlGAUgASgJUgRub3RlEjUKCG9uc2V0X2'
    'F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHb25zZXRBdBIjCg1zdXBlcnNl'
    'ZGVzX2lkGAcgASgJUgxzdXBlcnNlZGVzSWQ=');

@$core.Deprecated('Use recordDiagnosisResponseDescriptor instead')
const RecordDiagnosisResponse$json = {
  '1': 'RecordDiagnosisResponse',
  '2': [
    {
      '1': 'diagnosis',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Diagnosis',
      '10': 'diagnosis'
    },
  ],
};

/// Descriptor for `RecordDiagnosisResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDiagnosisResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvcmREaWFnbm9zaXNSZXNwb25zZRJACglkaWFnbm9zaXMYASABKAsyIi5oZWFsdGhjYX'
        'JlLmVuY291bnRlci52MS5EaWFnbm9zaXNSCWRpYWdub3Npcw==');

@$core.Deprecated('Use retractDiagnosisRequestDescriptor instead')
const RetractDiagnosisRequest$json = {
  '1': 'RetractDiagnosisRequest',
  '2': [
    {'1': 'diagnosis_id', '3': 1, '4': 1, '5': 9, '10': 'diagnosisId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RetractDiagnosisRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractDiagnosisRequestDescriptor =
    $convert.base64Decode(
        'ChdSZXRyYWN0RGlhZ25vc2lzUmVxdWVzdBIhCgxkaWFnbm9zaXNfaWQYASABKAlSC2RpYWdub3'
        'Npc0lkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use retractDiagnosisResponseDescriptor instead')
const RetractDiagnosisResponse$json = {
  '1': 'RetractDiagnosisResponse',
};

/// Descriptor for `RetractDiagnosisResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractDiagnosisResponseDescriptor =
    $convert.base64Decode('ChhSZXRyYWN0RGlhZ25vc2lzUmVzcG9uc2U=');

@$core.Deprecated('Use listDiagnosesRequestDescriptor instead')
const ListDiagnosesRequest$json = {
  '1': 'ListDiagnosesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDiagnosesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDiagnosesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RGlhZ25vc2VzUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bnRlck'
    'lkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIbCglwYWdlX3NpemUYAyABKAVSCHBh'
    'Z2VTaXpl');

@$core.Deprecated('Use listDiagnosesResponseDescriptor instead')
const ListDiagnosesResponse$json = {
  '1': 'ListDiagnosesResponse',
  '2': [
    {
      '1': 'diagnoses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.Diagnosis',
      '10': 'diagnoses'
    },
  ],
};

/// Descriptor for `ListDiagnosesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDiagnosesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RGlhZ25vc2VzUmVzcG9uc2USQAoJZGlhZ25vc2VzGAEgAygLMiIuaGVhbHRoY2FyZS'
    '5lbmNvdW50ZXIudjEuRGlhZ25vc2lzUglkaWFnbm9zZXM=');

@$core.Deprecated('Use closeEncounterRequestDescriptor instead')
const CloseEncounterRequest$json = {
  '1': 'CloseEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'narrative', '3': 2, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'override_reason', '3': 3, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `CloseEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeEncounterRequestDescriptor = $convert.base64Decode(
    'ChVDbG9zZUVuY291bnRlclJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZX'
    'JJZBIcCgluYXJyYXRpdmUYAiABKAlSCW5hcnJhdGl2ZRInCg9vdmVycmlkZV9yZWFzb24YAyAB'
    'KAlSDm92ZXJyaWRlUmVhc29u');

@$core.Deprecated('Use closeEncounterResponseDescriptor instead')
const CloseEncounterResponse$json = {
  '1': 'CloseEncounterResponse',
  '2': [
    {
      '1': 'encounter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.Encounter',
      '10': 'encounter'
    },
    {
      '1': 'summary',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.VisitSummary',
      '10': 'summary'
    },
    {'1': 'overridden', '3': 3, '4': 1, '5': 8, '10': 'overridden'},
    {'1': 'missing_items', '3': 4, '4': 3, '5': 9, '10': 'missingItems'},
  ],
};

/// Descriptor for `CloseEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeEncounterResponseDescriptor = $convert.base64Decode(
    'ChZDbG9zZUVuY291bnRlclJlc3BvbnNlEkAKCWVuY291bnRlchgBIAEoCzIiLmhlYWx0aGNhcm'
    'UuZW5jb3VudGVyLnYxLkVuY291bnRlclIJZW5jb3VudGVyEj8KB3N1bW1hcnkYAiABKAsyJS5o'
    'ZWFsdGhjYXJlLmVuY291bnRlci52MS5WaXNpdFN1bW1hcnlSB3N1bW1hcnkSHgoKb3ZlcnJpZG'
    'RlbhgDIAEoCFIKb3ZlcnJpZGRlbhIjCg1taXNzaW5nX2l0ZW1zGAQgAygJUgxtaXNzaW5nSXRl'
    'bXM=');

@$core.Deprecated('Use amendSummaryRequestDescriptor instead')
const AmendSummaryRequest$json = {
  '1': 'AmendSummaryRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'narrative', '3': 2, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AmendSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendSummaryRequestDescriptor = $convert.base64Decode(
    'ChNBbWVuZFN1bW1hcnlSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'QSHAoJbmFycmF0aXZlGAIgASgJUgluYXJyYXRpdmUSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use amendSummaryResponseDescriptor instead')
const AmendSummaryResponse$json = {
  '1': 'AmendSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.encounter.v1.VisitSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `AmendSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendSummaryResponseDescriptor = $convert.base64Decode(
    'ChRBbWVuZFN1bW1hcnlSZXNwb25zZRI/CgdzdW1tYXJ5GAEgASgLMiUuaGVhbHRoY2FyZS5lbm'
    'NvdW50ZXIudjEuVmlzaXRTdW1tYXJ5UgdzdW1tYXJ5');

@$core.Deprecated('Use getSummariesRequestDescriptor instead')
const GetSummariesRequest$json = {
  '1': 'GetSummariesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `GetSummariesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSummariesRequestDescriptor = $convert.base64Decode(
    'ChNHZXRTdW1tYXJpZXNSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'Q=');

@$core.Deprecated('Use getSummariesResponseDescriptor instead')
const GetSummariesResponse$json = {
  '1': 'GetSummariesResponse',
  '2': [
    {
      '1': 'summaries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.VisitSummary',
      '10': 'summaries'
    },
  ],
};

/// Descriptor for `GetSummariesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSummariesResponseDescriptor = $convert.base64Decode(
    'ChRHZXRTdW1tYXJpZXNSZXNwb25zZRJDCglzdW1tYXJpZXMYASADKAsyJS5oZWFsdGhjYXJlLm'
    'VuY291bnRlci52MS5WaXNpdFN1bW1hcnlSCXN1bW1hcmllcw==');

@$core.Deprecated('Use setClosurePolicyRequestDescriptor instead')
const SetClosurePolicyRequest$json = {
  '1': 'SetClosurePolicyRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'classes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.ClosurePolicyForClass',
      '10': 'classes'
    },
  ],
};

/// Descriptor for `SetClosurePolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setClosurePolicyRequestDescriptor = $convert.base64Decode(
    'ChdTZXRDbG9zdXJlUG9saWN5UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBJICgdjbGFzc2VzGAIgAygLMi4uaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuQ2xvc3VyZVBv'
    'bGljeUZvckNsYXNzUgdjbGFzc2Vz');

@$core.Deprecated('Use setClosurePolicyResponseDescriptor instead')
const SetClosurePolicyResponse$json = {
  '1': 'SetClosurePolicyResponse',
};

/// Descriptor for `SetClosurePolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setClosurePolicyResponseDescriptor =
    $convert.base64Decode('ChhTZXRDbG9zdXJlUG9saWN5UmVzcG9uc2U=');

@$core.Deprecated('Use getClosurePolicyRequestDescriptor instead')
const GetClosurePolicyRequest$json = {
  '1': 'GetClosurePolicyRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetClosurePolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClosurePolicyRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRDbG9zdXJlUG9saWN5UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
        'lJZA==');

@$core.Deprecated('Use getClosurePolicyResponseDescriptor instead')
const GetClosurePolicyResponse$json = {
  '1': 'GetClosurePolicyResponse',
  '2': [
    {
      '1': 'classes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.ClosurePolicyForClass',
      '10': 'classes'
    },
  ],
};

/// Descriptor for `GetClosurePolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClosurePolicyResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRDbG9zdXJlUG9saWN5UmVzcG9uc2USSAoHY2xhc3NlcxgBIAMoCzIuLmhlYWx0aGNhcm'
        'UuZW5jb3VudGVyLnYxLkNsb3N1cmVQb2xpY3lGb3JDbGFzc1IHY2xhc3Nlcw==');

@$core.Deprecated('Use listClosureOverridesRequestDescriptor instead')
const ListClosureOverridesRequest$json = {
  '1': 'ListClosureOverridesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListClosureOverridesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listClosureOverridesRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Q2xvc3VyZU92ZXJyaWRlc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbm'
        'NvdW50ZXJJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listClosureOverridesResponseDescriptor instead')
const ListClosureOverridesResponse$json = {
  '1': 'ListClosureOverridesResponse',
  '2': [
    {
      '1': 'overrides',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.ClosureOverride',
      '10': 'overrides'
    },
  ],
};

/// Descriptor for `ListClosureOverridesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listClosureOverridesResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q2xvc3VyZU92ZXJyaWRlc1Jlc3BvbnNlEkYKCW92ZXJyaWRlcxgBIAMoCzIoLmhlYW'
        'x0aGNhcmUuZW5jb3VudGVyLnYxLkNsb3N1cmVPdmVycmlkZVIJb3ZlcnJpZGVz');

@$core.Deprecated('Use getTimelineRequestDescriptor instead')
const GetTimelineRequest$json = {
  '1': 'GetTimelineRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'until',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
    {
      '1': 'kinds',
      '3': 4,
      '4': 3,
      '5': 14,
      '6': '.healthcare.encounter.v1.TimelineEntryKind',
      '10': 'kinds'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineRequestDescriptor = $convert.base64Decode(
    'ChJHZXRUaW1lbGluZVJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi4KBG'
    'Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEjAKBXVudGlsGAMg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFdW50aWwSQAoFa2luZHMYBCADKA4yKi'
    '5oZWFsdGhjYXJlLmVuY291bnRlci52MS5UaW1lbGluZUVudHJ5S2luZFIFa2luZHMSGwoJcGFn'
    'ZV9zaXplGAUgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getTimelineResponseDescriptor instead')
const GetTimelineResponse$json = {
  '1': 'GetTimelineResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.encounter.v1.TimelineEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUaW1lbGluZVJlc3BvbnNlEkAKB2VudHJpZXMYASADKAsyJi5oZWFsdGhjYXJlLmVuY2'
    '91bnRlci52MS5UaW1lbGluZUVudHJ5UgdlbnRyaWVz');

const $core.Map<$core.String, $core.dynamic> EncounterServiceBase$json = {
  '1': 'EncounterService',
  '2': [
    {
      '1': 'OpenEncounter',
      '2': '.healthcare.encounter.v1.OpenEncounterRequest',
      '3': '.healthcare.encounter.v1.OpenEncounterResponse'
    },
    {
      '1': 'StartEncounter',
      '2': '.healthcare.encounter.v1.StartEncounterRequest',
      '3': '.healthcare.encounter.v1.StartEncounterResponse'
    },
    {
      '1': 'EndEncounter',
      '2': '.healthcare.encounter.v1.EndEncounterRequest',
      '3': '.healthcare.encounter.v1.EndEncounterResponse'
    },
    {
      '1': 'CancelEncounter',
      '2': '.healthcare.encounter.v1.CancelEncounterRequest',
      '3': '.healthcare.encounter.v1.CancelEncounterResponse'
    },
    {
      '1': 'ReopenEncounter',
      '2': '.healthcare.encounter.v1.ReopenEncounterRequest',
      '3': '.healthcare.encounter.v1.ReopenEncounterResponse'
    },
    {
      '1': 'SetEncounterLeave',
      '2': '.healthcare.encounter.v1.SetEncounterLeaveRequest',
      '3': '.healthcare.encounter.v1.SetEncounterLeaveResponse'
    },
    {
      '1': 'GetEncounter',
      '2': '.healthcare.encounter.v1.GetEncounterRequest',
      '3': '.healthcare.encounter.v1.GetEncounterResponse'
    },
    {
      '1': 'ListEncounters',
      '2': '.healthcare.encounter.v1.ListEncountersRequest',
      '3': '.healthcare.encounter.v1.ListEncountersResponse'
    },
    {
      '1': 'OpenEpisode',
      '2': '.healthcare.encounter.v1.OpenEpisodeRequest',
      '3': '.healthcare.encounter.v1.OpenEpisodeResponse'
    },
    {
      '1': 'SetEpisodeStatus',
      '2': '.healthcare.encounter.v1.SetEpisodeStatusRequest',
      '3': '.healthcare.encounter.v1.SetEpisodeStatusResponse'
    },
    {
      '1': 'ListEpisodes',
      '2': '.healthcare.encounter.v1.ListEpisodesRequest',
      '3': '.healthcare.encounter.v1.ListEpisodesResponse'
    },
    {
      '1': 'AssignCareTeamMember',
      '2': '.healthcare.encounter.v1.AssignCareTeamMemberRequest',
      '3': '.healthcare.encounter.v1.AssignCareTeamMemberResponse'
    },
    {
      '1': 'EndCareTeamAssignment',
      '2': '.healthcare.encounter.v1.EndCareTeamAssignmentRequest',
      '3': '.healthcare.encounter.v1.EndCareTeamAssignmentResponse'
    },
    {
      '1': 'GetCareTeam',
      '2': '.healthcare.encounter.v1.GetCareTeamRequest',
      '3': '.healthcare.encounter.v1.GetCareTeamResponse'
    },
    {
      '1': 'RecordDiagnosis',
      '2': '.healthcare.encounter.v1.RecordDiagnosisRequest',
      '3': '.healthcare.encounter.v1.RecordDiagnosisResponse'
    },
    {
      '1': 'RetractDiagnosis',
      '2': '.healthcare.encounter.v1.RetractDiagnosisRequest',
      '3': '.healthcare.encounter.v1.RetractDiagnosisResponse'
    },
    {
      '1': 'ListDiagnoses',
      '2': '.healthcare.encounter.v1.ListDiagnosesRequest',
      '3': '.healthcare.encounter.v1.ListDiagnosesResponse'
    },
    {
      '1': 'CloseEncounter',
      '2': '.healthcare.encounter.v1.CloseEncounterRequest',
      '3': '.healthcare.encounter.v1.CloseEncounterResponse'
    },
    {
      '1': 'AmendSummary',
      '2': '.healthcare.encounter.v1.AmendSummaryRequest',
      '3': '.healthcare.encounter.v1.AmendSummaryResponse'
    },
    {
      '1': 'GetSummaries',
      '2': '.healthcare.encounter.v1.GetSummariesRequest',
      '3': '.healthcare.encounter.v1.GetSummariesResponse'
    },
    {
      '1': 'SetClosurePolicy',
      '2': '.healthcare.encounter.v1.SetClosurePolicyRequest',
      '3': '.healthcare.encounter.v1.SetClosurePolicyResponse'
    },
    {
      '1': 'GetClosurePolicy',
      '2': '.healthcare.encounter.v1.GetClosurePolicyRequest',
      '3': '.healthcare.encounter.v1.GetClosurePolicyResponse'
    },
    {
      '1': 'ListClosureOverrides',
      '2': '.healthcare.encounter.v1.ListClosureOverridesRequest',
      '3': '.healthcare.encounter.v1.ListClosureOverridesResponse'
    },
    {
      '1': 'GetTimeline',
      '2': '.healthcare.encounter.v1.GetTimelineRequest',
      '3': '.healthcare.encounter.v1.GetTimelineResponse'
    },
  ],
};

@$core.Deprecated('Use encounterServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    EncounterServiceBase$messageJson = {
  '.healthcare.encounter.v1.OpenEncounterRequest': OpenEncounterRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.encounter.v1.OpenEncounterResponse': OpenEncounterResponse$json,
  '.healthcare.encounter.v1.Encounter': Encounter$json,
  '.healthcare.encounter.v1.EncounterStatusChange': EncounterStatusChange$json,
  '.healthcare.encounter.v1.StartEncounterRequest': StartEncounterRequest$json,
  '.healthcare.encounter.v1.StartEncounterResponse':
      StartEncounterResponse$json,
  '.healthcare.encounter.v1.EndEncounterRequest': EndEncounterRequest$json,
  '.healthcare.encounter.v1.EndEncounterResponse': EndEncounterResponse$json,
  '.healthcare.encounter.v1.CancelEncounterRequest':
      CancelEncounterRequest$json,
  '.healthcare.encounter.v1.CancelEncounterResponse':
      CancelEncounterResponse$json,
  '.healthcare.encounter.v1.ReopenEncounterRequest':
      ReopenEncounterRequest$json,
  '.healthcare.encounter.v1.ReopenEncounterResponse':
      ReopenEncounterResponse$json,
  '.healthcare.encounter.v1.SetEncounterLeaveRequest':
      SetEncounterLeaveRequest$json,
  '.healthcare.encounter.v1.SetEncounterLeaveResponse':
      SetEncounterLeaveResponse$json,
  '.healthcare.encounter.v1.GetEncounterRequest': GetEncounterRequest$json,
  '.healthcare.encounter.v1.GetEncounterResponse': GetEncounterResponse$json,
  '.healthcare.encounter.v1.ListEncountersRequest': ListEncountersRequest$json,
  '.healthcare.encounter.v1.ListEncountersResponse':
      ListEncountersResponse$json,
  '.healthcare.encounter.v1.OpenEpisodeRequest': OpenEpisodeRequest$json,
  '.healthcare.encounter.v1.OpenEpisodeResponse': OpenEpisodeResponse$json,
  '.healthcare.encounter.v1.Episode': Episode$json,
  '.healthcare.encounter.v1.SetEpisodeStatusRequest':
      SetEpisodeStatusRequest$json,
  '.healthcare.encounter.v1.SetEpisodeStatusResponse':
      SetEpisodeStatusResponse$json,
  '.healthcare.encounter.v1.ListEpisodesRequest': ListEpisodesRequest$json,
  '.healthcare.encounter.v1.ListEpisodesResponse': ListEpisodesResponse$json,
  '.healthcare.encounter.v1.AssignCareTeamMemberRequest':
      AssignCareTeamMemberRequest$json,
  '.healthcare.encounter.v1.AssignCareTeamMemberResponse':
      AssignCareTeamMemberResponse$json,
  '.healthcare.encounter.v1.CareTeamMember': CareTeamMember$json,
  '.healthcare.encounter.v1.EndCareTeamAssignmentRequest':
      EndCareTeamAssignmentRequest$json,
  '.healthcare.encounter.v1.EndCareTeamAssignmentResponse':
      EndCareTeamAssignmentResponse$json,
  '.healthcare.encounter.v1.GetCareTeamRequest': GetCareTeamRequest$json,
  '.healthcare.encounter.v1.GetCareTeamResponse': GetCareTeamResponse$json,
  '.healthcare.encounter.v1.RecordDiagnosisRequest':
      RecordDiagnosisRequest$json,
  '.healthcare.encounter.v1.Coding': Coding$json,
  '.healthcare.encounter.v1.RecordDiagnosisResponse':
      RecordDiagnosisResponse$json,
  '.healthcare.encounter.v1.Diagnosis': Diagnosis$json,
  '.healthcare.encounter.v1.RetractDiagnosisRequest':
      RetractDiagnosisRequest$json,
  '.healthcare.encounter.v1.RetractDiagnosisResponse':
      RetractDiagnosisResponse$json,
  '.healthcare.encounter.v1.ListDiagnosesRequest': ListDiagnosesRequest$json,
  '.healthcare.encounter.v1.ListDiagnosesResponse': ListDiagnosesResponse$json,
  '.healthcare.encounter.v1.CloseEncounterRequest': CloseEncounterRequest$json,
  '.healthcare.encounter.v1.CloseEncounterResponse':
      CloseEncounterResponse$json,
  '.healthcare.encounter.v1.VisitSummary': VisitSummary$json,
  '.healthcare.encounter.v1.AmendSummaryRequest': AmendSummaryRequest$json,
  '.healthcare.encounter.v1.AmendSummaryResponse': AmendSummaryResponse$json,
  '.healthcare.encounter.v1.GetSummariesRequest': GetSummariesRequest$json,
  '.healthcare.encounter.v1.GetSummariesResponse': GetSummariesResponse$json,
  '.healthcare.encounter.v1.SetClosurePolicyRequest':
      SetClosurePolicyRequest$json,
  '.healthcare.encounter.v1.ClosurePolicyForClass': ClosurePolicyForClass$json,
  '.healthcare.encounter.v1.SetClosurePolicyResponse':
      SetClosurePolicyResponse$json,
  '.healthcare.encounter.v1.GetClosurePolicyRequest':
      GetClosurePolicyRequest$json,
  '.healthcare.encounter.v1.GetClosurePolicyResponse':
      GetClosurePolicyResponse$json,
  '.healthcare.encounter.v1.ListClosureOverridesRequest':
      ListClosureOverridesRequest$json,
  '.healthcare.encounter.v1.ListClosureOverridesResponse':
      ListClosureOverridesResponse$json,
  '.healthcare.encounter.v1.ClosureOverride': ClosureOverride$json,
  '.healthcare.encounter.v1.GetTimelineRequest': GetTimelineRequest$json,
  '.healthcare.encounter.v1.GetTimelineResponse': GetTimelineResponse$json,
  '.healthcare.encounter.v1.TimelineEntry': TimelineEntry$json,
};

/// Descriptor for `EncounterService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List encounterServiceDescriptor = $convert.base64Decode(
    'ChBFbmNvdW50ZXJTZXJ2aWNlEm4KDU9wZW5FbmNvdW50ZXISLS5oZWFsdGhjYXJlLmVuY291bn'
    'Rlci52MS5PcGVuRW5jb3VudGVyUmVxdWVzdBouLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLk9w'
    'ZW5FbmNvdW50ZXJSZXNwb25zZRJxCg5TdGFydEVuY291bnRlchIuLmhlYWx0aGNhcmUuZW5jb3'
    'VudGVyLnYxLlN0YXJ0RW5jb3VudGVyUmVxdWVzdBovLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYx'
    'LlN0YXJ0RW5jb3VudGVyUmVzcG9uc2USawoMRW5kRW5jb3VudGVyEiwuaGVhbHRoY2FyZS5lbm'
    'NvdW50ZXIudjEuRW5kRW5jb3VudGVyUmVxdWVzdBotLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYx'
    'LkVuZEVuY291bnRlclJlc3BvbnNlEnQKD0NhbmNlbEVuY291bnRlchIvLmhlYWx0aGNhcmUuZW'
    '5jb3VudGVyLnYxLkNhbmNlbEVuY291bnRlclJlcXVlc3QaMC5oZWFsdGhjYXJlLmVuY291bnRl'
    'ci52MS5DYW5jZWxFbmNvdW50ZXJSZXNwb25zZRJ0Cg9SZW9wZW5FbmNvdW50ZXISLy5oZWFsdG'
    'hjYXJlLmVuY291bnRlci52MS5SZW9wZW5FbmNvdW50ZXJSZXF1ZXN0GjAuaGVhbHRoY2FyZS5l'
    'bmNvdW50ZXIudjEuUmVvcGVuRW5jb3VudGVyUmVzcG9uc2USegoRU2V0RW5jb3VudGVyTGVhdm'
    'USMS5oZWFsdGhjYXJlLmVuY291bnRlci52MS5TZXRFbmNvdW50ZXJMZWF2ZVJlcXVlc3QaMi5o'
    'ZWFsdGhjYXJlLmVuY291bnRlci52MS5TZXRFbmNvdW50ZXJMZWF2ZVJlc3BvbnNlEmsKDEdldE'
    'VuY291bnRlchIsLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkdldEVuY291bnRlclJlcXVlc3Qa'
    'LS5oZWFsdGhjYXJlLmVuY291bnRlci52MS5HZXRFbmNvdW50ZXJSZXNwb25zZRJxCg5MaXN0RW'
    '5jb3VudGVycxIuLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkxpc3RFbmNvdW50ZXJzUmVxdWVz'
    'dBovLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkxpc3RFbmNvdW50ZXJzUmVzcG9uc2USaAoLT3'
    'BlbkVwaXNvZGUSKy5oZWFsdGhjYXJlLmVuY291bnRlci52MS5PcGVuRXBpc29kZVJlcXVlc3Qa'
    'LC5oZWFsdGhjYXJlLmVuY291bnRlci52MS5PcGVuRXBpc29kZVJlc3BvbnNlEncKEFNldEVwaX'
    'NvZGVTdGF0dXMSMC5oZWFsdGhjYXJlLmVuY291bnRlci52MS5TZXRFcGlzb2RlU3RhdHVzUmVx'
    'dWVzdBoxLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLlNldEVwaXNvZGVTdGF0dXNSZXNwb25zZR'
    'JrCgxMaXN0RXBpc29kZXMSLC5oZWFsdGhjYXJlLmVuY291bnRlci52MS5MaXN0RXBpc29kZXNS'
    'ZXF1ZXN0Gi0uaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuTGlzdEVwaXNvZGVzUmVzcG9uc2USgw'
    'EKFEFzc2lnbkNhcmVUZWFtTWVtYmVyEjQuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuQXNzaWdu'
    'Q2FyZVRlYW1NZW1iZXJSZXF1ZXN0GjUuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuQXNzaWduQ2'
    'FyZVRlYW1NZW1iZXJSZXNwb25zZRKGAQoVRW5kQ2FyZVRlYW1Bc3NpZ25tZW50EjUuaGVhbHRo'
    'Y2FyZS5lbmNvdW50ZXIudjEuRW5kQ2FyZVRlYW1Bc3NpZ25tZW50UmVxdWVzdBo2LmhlYWx0aG'
    'NhcmUuZW5jb3VudGVyLnYxLkVuZENhcmVUZWFtQXNzaWdubWVudFJlc3BvbnNlEmgKC0dldENh'
    'cmVUZWFtEisuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuR2V0Q2FyZVRlYW1SZXF1ZXN0GiwuaG'
    'VhbHRoY2FyZS5lbmNvdW50ZXIudjEuR2V0Q2FyZVRlYW1SZXNwb25zZRJ0Cg9SZWNvcmREaWFn'
    'bm9zaXMSLy5oZWFsdGhjYXJlLmVuY291bnRlci52MS5SZWNvcmREaWFnbm9zaXNSZXF1ZXN0Gj'
    'AuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuUmVjb3JkRGlhZ25vc2lzUmVzcG9uc2USdwoQUmV0'
    'cmFjdERpYWdub3NpcxIwLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLlJldHJhY3REaWFnbm9zaX'
    'NSZXF1ZXN0GjEuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuUmV0cmFjdERpYWdub3Npc1Jlc3Bv'
    'bnNlEm4KDUxpc3REaWFnbm9zZXMSLS5oZWFsdGhjYXJlLmVuY291bnRlci52MS5MaXN0RGlhZ2'
    '5vc2VzUmVxdWVzdBouLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkxpc3REaWFnbm9zZXNSZXNw'
    'b25zZRJxCg5DbG9zZUVuY291bnRlchIuLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNsb3NlRW'
    '5jb3VudGVyUmVxdWVzdBovLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkNsb3NlRW5jb3VudGVy'
    'UmVzcG9uc2USawoMQW1lbmRTdW1tYXJ5EiwuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuQW1lbm'
    'RTdW1tYXJ5UmVxdWVzdBotLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkFtZW5kU3VtbWFyeVJl'
    'c3BvbnNlEmsKDEdldFN1bW1hcmllcxIsLmhlYWx0aGNhcmUuZW5jb3VudGVyLnYxLkdldFN1bW'
    '1hcmllc1JlcXVlc3QaLS5oZWFsdGhjYXJlLmVuY291bnRlci52MS5HZXRTdW1tYXJpZXNSZXNw'
    'b25zZRJ3ChBTZXRDbG9zdXJlUG9saWN5EjAuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEuU2V0Q2'
    'xvc3VyZVBvbGljeVJlcXVlc3QaMS5oZWFsdGhjYXJlLmVuY291bnRlci52MS5TZXRDbG9zdXJl'
    'UG9saWN5UmVzcG9uc2USdwoQR2V0Q2xvc3VyZVBvbGljeRIwLmhlYWx0aGNhcmUuZW5jb3VudG'
    'VyLnYxLkdldENsb3N1cmVQb2xpY3lSZXF1ZXN0GjEuaGVhbHRoY2FyZS5lbmNvdW50ZXIudjEu'
    'R2V0Q2xvc3VyZVBvbGljeVJlc3BvbnNlEoMBChRMaXN0Q2xvc3VyZU92ZXJyaWRlcxI0LmhlYW'
    'x0aGNhcmUuZW5jb3VudGVyLnYxLkxpc3RDbG9zdXJlT3ZlcnJpZGVzUmVxdWVzdBo1LmhlYWx0'
    'aGNhcmUuZW5jb3VudGVyLnYxLkxpc3RDbG9zdXJlT3ZlcnJpZGVzUmVzcG9uc2USaAoLR2V0VG'
    'ltZWxpbmUSKy5oZWFsdGhjYXJlLmVuY291bnRlci52MS5HZXRUaW1lbGluZVJlcXVlc3QaLC5o'
    'ZWFsdGhjYXJlLmVuY291bnRlci52MS5HZXRUaW1lbGluZVJlc3BvbnNl');
