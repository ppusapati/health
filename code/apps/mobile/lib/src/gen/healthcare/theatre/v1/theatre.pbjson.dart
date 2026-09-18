// This is a generated file - do not edit.
//
// Generated from healthcare/theatre/v1/theatre.proto.

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

@$core.Deprecated('Use urgencyDescriptor instead')
const Urgency$json = {
  '1': 'Urgency',
  '2': [
    {'1': 'URGENCY_UNSPECIFIED', '2': 0},
    {'1': 'URGENCY_ELECTIVE', '2': 1},
    {'1': 'URGENCY_URGENT', '2': 2},
    {'1': 'URGENCY_EMERGENCY', '2': 3},
  ],
};

/// Descriptor for `Urgency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List urgencyDescriptor = $convert.base64Decode(
    'CgdVcmdlbmN5EhcKE1VSR0VOQ1lfVU5TUEVDSUZJRUQQABIUChBVUkdFTkNZX0VMRUNUSVZFEA'
    'ESEgoOVVJHRU5DWV9VUkdFTlQQAhIVChFVUkdFTkNZX0VNRVJHRU5DWRAD');

@$core.Deprecated('Use lateralityDescriptor instead')
const Laterality$json = {
  '1': 'Laterality',
  '2': [
    {'1': 'LATERALITY_UNSPECIFIED', '2': 0},
    {'1': 'LATERALITY_NOT_APPLICABLE', '2': 1},
    {'1': 'LATERALITY_LEFT', '2': 2},
    {'1': 'LATERALITY_RIGHT', '2': 3},
    {'1': 'LATERALITY_BILATERAL', '2': 4},
  ],
};

/// Descriptor for `Laterality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lateralityDescriptor = $convert.base64Decode(
    'CgpMYXRlcmFsaXR5EhoKFkxBVEVSQUxJVFlfVU5TUEVDSUZJRUQQABIdChlMQVRFUkFMSVRZX0'
    '5PVF9BUFBMSUNBQkxFEAESEwoPTEFURVJBTElUWV9MRUZUEAISFAoQTEFURVJBTElUWV9SSUdI'
    'VBADEhgKFExBVEVSQUxJVFlfQklMQVRFUkFMEAQ=');

@$core.Deprecated('Use caseStatusDescriptor instead')
const CaseStatus$json = {
  '1': 'CaseStatus',
  '2': [
    {'1': 'CASE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CASE_STATUS_REQUESTED', '2': 1},
    {'1': 'CASE_STATUS_SCHEDULABLE', '2': 2},
    {'1': 'CASE_STATUS_SCHEDULED', '2': 3},
    {'1': 'CASE_STATUS_READY', '2': 4},
    {'1': 'CASE_STATUS_IN_THEATRE', '2': 5},
    {'1': 'CASE_STATUS_COMPLETED', '2': 6},
    {'1': 'CASE_STATUS_POSTPONED', '2': 7},
    {'1': 'CASE_STATUS_CANCELLED', '2': 8},
  ],
};

/// Descriptor for `CaseStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List caseStatusDescriptor = $convert.base64Decode(
    'CgpDYXNlU3RhdHVzEhsKF0NBU0VfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVQ0FTRV9TVEFUVV'
    'NfUkVRVUVTVEVEEAESGwoXQ0FTRV9TVEFUVVNfU0NIRURVTEFCTEUQAhIZChVDQVNFX1NUQVRV'
    'U19TQ0hFRFVMRUQQAxIVChFDQVNFX1NUQVRVU19SRUFEWRAEEhoKFkNBU0VfU1RBVFVTX0lOX1'
    'RIRUFUUkUQBRIZChVDQVNFX1NUQVRVU19DT01QTEVURUQQBhIZChVDQVNFX1NUQVRVU19QT1NU'
    'UE9ORUQQBxIZChVDQVNFX1NUQVRVU19DQU5DRUxMRUQQCA==');

@$core.Deprecated('Use caseCauseDescriptor instead')
const CaseCause$json = {
  '1': 'CaseCause',
  '2': [
    {'1': 'CASE_CAUSE_UNSPECIFIED', '2': 0},
    {'1': 'CASE_CAUSE_PATIENT', '2': 1},
    {'1': 'CASE_CAUSE_CLINICAL', '2': 2},
    {'1': 'CASE_CAUSE_RESOURCE', '2': 3},
    {'1': 'CASE_CAUSE_ADMINISTRATIVE', '2': 4},
  ],
};

/// Descriptor for `CaseCause`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List caseCauseDescriptor = $convert.base64Decode(
    'CglDYXNlQ2F1c2USGgoWQ0FTRV9DQVVTRV9VTlNQRUNJRklFRBAAEhYKEkNBU0VfQ0FVU0VfUE'
    'FUSUVOVBABEhcKE0NBU0VfQ0FVU0VfQ0xJTklDQUwQAhIXChNDQVNFX0NBVVNFX1JFU09VUkNF'
    'EAMSHQoZQ0FTRV9DQVVTRV9BRE1JTklTVFJBVElWRRAE');

@$core.Deprecated('Use blockKindDescriptor instead')
const BlockKind$json = {
  '1': 'BlockKind',
  '2': [
    {'1': 'BLOCK_KIND_UNSPECIFIED', '2': 0},
    {'1': 'BLOCK_KIND_LIST', '2': 1},
    {'1': 'BLOCK_KIND_DOWNTIME', '2': 2},
    {'1': 'BLOCK_KIND_EMERGENCY', '2': 3},
  ],
};

/// Descriptor for `BlockKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List blockKindDescriptor = $convert.base64Decode(
    'CglCbG9ja0tpbmQSGgoWQkxPQ0tfS0lORF9VTlNQRUNJRklFRBAAEhMKD0JMT0NLX0tJTkRfTE'
    'lTVBABEhcKE0JMT0NLX0tJTkRfRE9XTlRJTUUQAhIYChRCTE9DS19LSU5EX0VNRVJHRU5DWRAD');

@$core.Deprecated('Use preopStateDescriptor instead')
const PreopState$json = {
  '1': 'PreopState',
  '2': [
    {'1': 'PREOP_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PREOP_STATE_MET', '2': 1},
    {'1': 'PREOP_STATE_UNMET', '2': 2},
    {'1': 'PREOP_STATE_WAIVED', '2': 3},
    {'1': 'PREOP_STATE_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `PreopState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List preopStateDescriptor = $convert.base64Decode(
    'CgpQcmVvcFN0YXRlEhsKF1BSRU9QX1NUQVRFX1VOU1BFQ0lGSUVEEAASEwoPUFJFT1BfU1RBVE'
    'VfTUVUEAESFQoRUFJFT1BfU1RBVEVfVU5NRVQQAhIWChJQUkVPUF9TVEFURV9XQUlWRUQQAxIe'
    'ChpQUkVPUF9TVEFURV9OT1RfQVBQTElDQUJMRRAE');

@$core.Deprecated('Use safetyPhaseDescriptor instead')
const SafetyPhase$json = {
  '1': 'SafetyPhase',
  '2': [
    {'1': 'SAFETY_PHASE_UNSPECIFIED', '2': 0},
    {'1': 'SAFETY_PHASE_SIGN_IN', '2': 1},
    {'1': 'SAFETY_PHASE_TIME_OUT', '2': 2},
    {'1': 'SAFETY_PHASE_SIGN_OUT', '2': 3},
  ],
};

/// Descriptor for `SafetyPhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List safetyPhaseDescriptor = $convert.base64Decode(
    'CgtTYWZldHlQaGFzZRIcChhTQUZFVFlfUEhBU0VfVU5TUEVDSUZJRUQQABIYChRTQUZFVFlfUE'
    'hBU0VfU0lHTl9JThABEhkKFVNBRkVUWV9QSEFTRV9USU1FX09VVBACEhkKFVNBRkVUWV9QSEFT'
    'RV9TSUdOX09VVBAD');

@$core.Deprecated('Use milestoneDescriptor instead')
const Milestone$json = {
  '1': 'Milestone',
  '2': [
    {'1': 'MILESTONE_UNSPECIFIED', '2': 0},
    {'1': 'MILESTONE_PRE_OP', '2': 1},
    {'1': 'MILESTONE_THEATRE_IN', '2': 2},
    {'1': 'MILESTONE_ANAESTHESIA_START', '2': 3},
    {'1': 'MILESTONE_INCISION', '2': 4},
    {'1': 'MILESTONE_CLOSURE', '2': 5},
    {'1': 'MILESTONE_THEATRE_OUT', '2': 6},
    {'1': 'MILESTONE_PACU_IN', '2': 7},
    {'1': 'MILESTONE_PACU_OUT', '2': 8},
  ],
};

/// Descriptor for `Milestone`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List milestoneDescriptor = $convert.base64Decode(
    'CglNaWxlc3RvbmUSGQoVTUlMRVNUT05FX1VOU1BFQ0lGSUVEEAASFAoQTUlMRVNUT05FX1BSRV'
    '9PUBABEhgKFE1JTEVTVE9ORV9USEVBVFJFX0lOEAISHwobTUlMRVNUT05FX0FOQUVTVEhFU0lB'
    'X1NUQVJUEAMSFgoSTUlMRVNUT05FX0lOQ0lTSU9OEAQSFQoRTUlMRVNUT05FX0NMT1NVUkUQBR'
    'IZChVNSUxFU1RPTkVfVEhFQVRSRV9PVVQQBhIVChFNSUxFU1RPTkVfUEFDVV9JThAHEhYKEk1J'
    'TEVTVE9ORV9QQUNVX09VVBAI');

@$core.Deprecated('Use delayReasonDescriptor instead')
const DelayReason$json = {
  '1': 'DelayReason',
  '2': [
    {'1': 'DELAY_REASON_UNSPECIFIED', '2': 0},
    {'1': 'DELAY_REASON_PATIENT', '2': 1},
    {'1': 'DELAY_REASON_SURGEON', '2': 2},
    {'1': 'DELAY_REASON_ANAESTHESIA', '2': 3},
    {'1': 'DELAY_REASON_NURSING', '2': 4},
    {'1': 'DELAY_REASON_EQUIPMENT', '2': 5},
    {'1': 'DELAY_REASON_INSTRUMENTS', '2': 6},
    {'1': 'DELAY_REASON_CLEANING', '2': 7},
    {'1': 'DELAY_REASON_BED', '2': 8},
    {'1': 'DELAY_REASON_PORTERS', '2': 9},
    {'1': 'DELAY_REASON_PREVIOUS_CASE', '2': 10},
    {'1': 'DELAY_REASON_EMERGENCY_INSERTION', '2': 11},
    {'1': 'DELAY_REASON_OTHER', '2': 12},
  ],
};

/// Descriptor for `DelayReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List delayReasonDescriptor = $convert.base64Decode(
    'CgtEZWxheVJlYXNvbhIcChhERUxBWV9SRUFTT05fVU5TUEVDSUZJRUQQABIYChRERUxBWV9SRU'
    'FTT05fUEFUSUVOVBABEhgKFERFTEFZX1JFQVNPTl9TVVJHRU9OEAISHAoYREVMQVlfUkVBU09O'
    'X0FOQUVTVEhFU0lBEAMSGAoUREVMQVlfUkVBU09OX05VUlNJTkcQBBIaChZERUxBWV9SRUFTT0'
    '5fRVFVSVBNRU5UEAUSHAoYREVMQVlfUkVBU09OX0lOU1RSVU1FTlRTEAYSGQoVREVMQVlfUkVB'
    'U09OX0NMRUFOSU5HEAcSFAoQREVMQVlfUkVBU09OX0JFRBAIEhgKFERFTEFZX1JFQVNPTl9QT1'
    'JURVJTEAkSHgoaREVMQVlfUkVBU09OX1BSRVZJT1VTX0NBU0UQChIkCiBERUxBWV9SRUFTT05f'
    'RU1FUkdFTkNZX0lOU0VSVElPThALEhYKEkRFTEFZX1JFQVNPTl9PVEhFUhAM');

@$core.Deprecated('Use noteStatusDescriptor instead')
const NoteStatus$json = {
  '1': 'NoteStatus',
  '2': [
    {'1': 'NOTE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'NOTE_STATUS_DRAFT', '2': 1},
    {'1': 'NOTE_STATUS_SIGNED', '2': 2},
    {'1': 'NOTE_STATUS_AMENDED', '2': 3},
    {'1': 'NOTE_STATUS_SUPERSEDED', '2': 4},
  ],
};

/// Descriptor for `NoteStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List noteStatusDescriptor = $convert.base64Decode(
    'CgpOb3RlU3RhdHVzEhsKF05PVEVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFQoRTk9URV9TVEFUVV'
    'NfRFJBRlQQARIWChJOT1RFX1NUQVRVU19TSUdORUQQAhIXChNOT1RFX1NUQVRVU19BTUVOREVE'
    'EAMSGgoWTk9URV9TVEFUVVNfU1VQRVJTRURFRBAE');

@$core.Deprecated('Use usageKindDescriptor instead')
const UsageKind$json = {
  '1': 'UsageKind',
  '2': [
    {'1': 'USAGE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'USAGE_KIND_CONSUMABLE', '2': 1},
    {'1': 'USAGE_KIND_IMPLANT', '2': 2},
  ],
};

/// Descriptor for `UsageKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List usageKindDescriptor = $convert.base64Decode(
    'CglVc2FnZUtpbmQSGgoWVVNBR0VfS0lORF9VTlNQRUNJRklFRBAAEhkKFVVTQUdFX0tJTkRfQ0'
    '9OU1VNQUJMRRABEhYKElVTQUdFX0tJTkRfSU1QTEFOVBAC');

@$core.Deprecated('Use roomStageDescriptor instead')
const RoomStage$json = {
  '1': 'RoomStage',
  '2': [
    {'1': 'ROOM_STAGE_UNSPECIFIED', '2': 0},
    {'1': 'ROOM_STAGE_EMPTY', '2': 1},
    {'1': 'ROOM_STAGE_NEXT_CASE_READY', '2': 2},
    {'1': 'ROOM_STAGE_IN_USE', '2': 3},
    {'1': 'ROOM_STAGE_TURNOVER', '2': 4},
    {'1': 'ROOM_STAGE_CLOSED', '2': 5},
  ],
};

/// Descriptor for `RoomStage`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roomStageDescriptor = $convert.base64Decode(
    'CglSb29tU3RhZ2USGgoWUk9PTV9TVEFHRV9VTlNQRUNJRklFRBAAEhQKEFJPT01fU1RBR0VfRU'
    '1QVFkQARIeChpST09NX1NUQUdFX05FWFRfQ0FTRV9SRUFEWRACEhUKEVJPT01fU1RBR0VfSU5f'
    'VVNFEAMSFwoTUk9PTV9TVEFHRV9UVVJOT1ZFUhAEEhUKEVJPT01fU1RBR0VfQ0xPU0VEEAU=');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'specialties', '3': 5, '4': 3, '5': 9, '10': 'specialties'},
    {'1': 'equipment', '3': 6, '4': 3, '5': 9, '10': 'equipment'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIfCgtmYWNpbGl0eV9pZBgCIAEoCVIKZm'
    'FjaWxpdHlJZBISCgRjb2RlGAMgASgJUgRjb2RlEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLc3Bl'
    'Y2lhbHRpZXMYBSADKAlSC3NwZWNpYWx0aWVzEhwKCWVxdWlwbWVudBgGIAMoCVIJZXF1aXBtZW'
    '50EhYKBmFjdGl2ZRgHIAEoCFIGYWN0aXZl');

@$core.Deprecated('Use blockDescriptor instead')
const Block$json = {
  '1': 'Block',
  '2': [
    {'1': 'block_id', '3': 1, '4': 1, '5': 9, '10': 'blockId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.BlockKind',
      '10': 'kind'
    },
    {'1': 'owner_id', '3': 4, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'specialty', '3': 5, '4': 1, '5': 9, '10': 'specialty'},
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
    {'1': 'note', '3': 8, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Block`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockDescriptor = $convert.base64Decode(
    'CgVCbG9jaxIZCghibG9ja19pZBgBIAEoCVIHYmxvY2tJZBIXCgdyb29tX2lkGAIgASgJUgZyb2'
    '9tSWQSNAoEa2luZBgDIAEoDjIgLmhlYWx0aGNhcmUudGhlYXRyZS52MS5CbG9ja0tpbmRSBGtp'
    'bmQSGQoIb3duZXJfaWQYBCABKAlSB293bmVySWQSHAoJc3BlY2lhbHR5GAUgASgJUglzcGVjaW'
    'FsdHkSNwoJc3RhcnRzX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc3Rh'
    'cnRzQXQSMwoHZW5kc19hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmVuZH'
    'NBdBISCgRub3RlGAggASgJUgRub3Rl');

@$core.Deprecated('Use surgicalCaseDescriptor instead')
const SurgicalCase$json = {
  '1': 'SurgicalCase',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'procedure_code', '3': 5, '4': 1, '5': 9, '10': 'procedureCode'},
    {
      '1': 'procedure_display',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'procedureDisplay'
    },
    {'1': 'diagnosis_code', '3': 7, '4': 1, '5': 9, '10': 'diagnosisCode'},
    {
      '1': 'diagnosis_display',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'diagnosisDisplay'
    },
    {
      '1': 'laterality',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'site', '3': 10, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'urgency',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Urgency',
      '10': 'urgency'
    },
    {
      '1': 'expected_duration_seconds',
      '3': 12,
      '4': 1,
      '5': 3,
      '10': 'expectedDurationSeconds'
    },
    {'1': 'surgeon_id', '3': 13, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'team', '3': 14, '4': 3, '5': 9, '10': 'team'},
    {'1': 'requirements', '3': 15, '4': 3, '5': 9, '10': 'requirements'},
    {'1': 'anaesthesia_type', '3': 16, '4': 1, '5': 9, '10': 'anaesthesiaType'},
    {'1': 'special_notes', '3': 17, '4': 1, '5': 9, '10': 'specialNotes'},
    {
      '1': 'status',
      '3': 18,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.CaseStatus',
      '10': 'status'
    },
    {'1': 'room_id', '3': 19, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'scheduled_start',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledStart'
    },
    {
      '1': 'scheduled_end',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledEnd'
    },
    {
      '1': 'cause',
      '3': 22,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.CaseCause',
      '10': 'cause'
    },
    {'1': 'cause_reason', '3': 23, '4': 1, '5': 9, '10': 'causeReason'},
    {'1': 'cause_note', '3': 24, '4': 1, '5': 9, '10': 'causeNote'},
    {
      '1': 'closed_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'requested_by', '3': 26, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'requested_at',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {'1': 'version', '3': 28, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SurgicalCase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List surgicalCaseDescriptor = $convert.base64Decode(
    'CgxTdXJnaWNhbENhc2USFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEiEKDGVuY291bnRlcl9pZB'
    'gCIAEoCVILZW5jb3VudGVySWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEh8KC2Zh'
    'Y2lsaXR5X2lkGAQgASgJUgpmYWNpbGl0eUlkEiUKDnByb2NlZHVyZV9jb2RlGAUgASgJUg1wcm'
    '9jZWR1cmVDb2RlEisKEXByb2NlZHVyZV9kaXNwbGF5GAYgASgJUhBwcm9jZWR1cmVEaXNwbGF5'
    'EiUKDmRpYWdub3Npc19jb2RlGAcgASgJUg1kaWFnbm9zaXNDb2RlEisKEWRpYWdub3Npc19kaX'
    'NwbGF5GAggASgJUhBkaWFnbm9zaXNEaXNwbGF5EkEKCmxhdGVyYWxpdHkYCSABKA4yIS5oZWFs'
    'dGhjYXJlLnRoZWF0cmUudjEuTGF0ZXJhbGl0eVIKbGF0ZXJhbGl0eRISCgRzaXRlGAogASgJUg'
    'RzaXRlEjgKB3VyZ2VuY3kYCyABKA4yHi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuVXJnZW5jeVIH'
    'dXJnZW5jeRI6ChlleHBlY3RlZF9kdXJhdGlvbl9zZWNvbmRzGAwgASgDUhdleHBlY3RlZER1cm'
    'F0aW9uU2Vjb25kcxIdCgpzdXJnZW9uX2lkGA0gASgJUglzdXJnZW9uSWQSEgoEdGVhbRgOIAMo'
    'CVIEdGVhbRIiCgxyZXF1aXJlbWVudHMYDyADKAlSDHJlcXVpcmVtZW50cxIpChBhbmFlc3RoZX'
    'NpYV90eXBlGBAgASgJUg9hbmFlc3RoZXNpYVR5cGUSIwoNc3BlY2lhbF9ub3RlcxgRIAEoCVIM'
    'c3BlY2lhbE5vdGVzEjkKBnN0YXR1cxgSIAEoDjIhLmhlYWx0aGNhcmUudGhlYXRyZS52MS5DYX'
    'NlU3RhdHVzUgZzdGF0dXMSFwoHcm9vbV9pZBgTIAEoCVIGcm9vbUlkEkMKD3NjaGVkdWxlZF9z'
    'dGFydBgUIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnNjaGVkdWxlZFN0YXJ0Ej'
    '8KDXNjaGVkdWxlZF9lbmQYFSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxzY2hl'
    'ZHVsZWRFbmQSNgoFY2F1c2UYFiABKA4yIC5oZWFsdGhjYXJlLnRoZWF0cmUudjEuQ2FzZUNhdX'
    'NlUgVjYXVzZRIhCgxjYXVzZV9yZWFzb24YFyABKAlSC2NhdXNlUmVhc29uEh0KCmNhdXNlX25v'
    'dGUYGCABKAlSCWNhdXNlTm90ZRI3CgljbG9zZWRfYXQYGSABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUghjbG9zZWRBdBIhCgxyZXF1ZXN0ZWRfYnkYGiABKAlSC3JlcXVlc3RlZEJ5'
    'Ej0KDHJlcXVlc3RlZF9hdBgbIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3JlcX'
    'Vlc3RlZEF0EhgKB3ZlcnNpb24YHCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use scheduleConflictDescriptor instead')
const ScheduleConflict$json = {
  '1': 'ScheduleConflict',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'overridable', '3': 3, '4': 1, '5': 8, '10': 'overridable'},
  ],
};

/// Descriptor for `ScheduleConflict`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleConflictDescriptor = $convert.base64Decode(
    'ChBTY2hlZHVsZUNvbmZsaWN0EhIKBGtpbmQYASABKAlSBGtpbmQSFgoGZGV0YWlsGAIgASgJUg'
    'ZkZXRhaWwSIAoLb3ZlcnJpZGFibGUYAyABKAhSC292ZXJyaWRhYmxl');

@$core.Deprecated('Use preopEntryDescriptor instead')
const PreopEntry$json = {
  '1': 'PreopEntry',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.PreopState',
      '10': 'state'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'waived_by', '3': 4, '4': 1, '5': 9, '10': 'waivedBy'},
    {'1': 'waived_role', '3': 5, '4': 1, '5': 9, '10': 'waivedRole'},
    {'1': 'recorded_by', '3': 6, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `PreopEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preopEntryDescriptor = $convert.base64Decode(
    'CgpQcmVvcEVudHJ5EhIKBGNvZGUYASABKAlSBGNvZGUSNwoFc3RhdGUYAiABKA4yIS5oZWFsdG'
    'hjYXJlLnRoZWF0cmUudjEuUHJlb3BTdGF0ZVIFc3RhdGUSEgoEbm90ZRgDIAEoCVIEbm90ZRIb'
    'Cgl3YWl2ZWRfYnkYBCABKAlSCHdhaXZlZEJ5Eh8KC3dhaXZlZF9yb2xlGAUgASgJUgp3YWl2ZW'
    'RSb2xlEh8KC3JlY29yZGVkX2J5GAYgASgJUgpyZWNvcmRlZEJ5EjsKC3JlY29yZGVkX2F0GAcg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdA==');

@$core.Deprecated('Use blockerDescriptor instead')
const Blocker$json = {
  '1': 'Blocker',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'waivable_by', '3': 3, '4': 1, '5': 9, '10': 'waivableBy'},
  ],
};

/// Descriptor for `Blocker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockerDescriptor = $convert.base64Decode(
    'CgdCbG9ja2VyEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBWxhYmVsEh8KC3'
    'dhaXZhYmxlX2J5GAMgASgJUgp3YWl2YWJsZUJ5');

@$core.Deprecated('Use safetyAnswerDescriptor instead')
const SafetyAnswer$json = {
  '1': 'SafetyAnswer',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'confirmed', '3': 2, '4': 1, '5': 8, '10': 'confirmed'},
    {'1': 'exception', '3': 3, '4': 1, '5': 9, '10': 'exception'},
  ],
};

/// Descriptor for `SafetyAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List safetyAnswerDescriptor = $convert.base64Decode(
    'CgxTYWZldHlBbnN3ZXISEgoEY29kZRgBIAEoCVIEY29kZRIcCgljb25maXJtZWQYAiABKAhSCW'
    'NvbmZpcm1lZBIcCglleGNlcHRpb24YAyABKAlSCWV4Y2VwdGlvbg==');

@$core.Deprecated('Use safetyCheckDescriptor instead')
const SafetyCheck$json = {
  '1': 'SafetyCheck',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'phase',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.SafetyPhase',
      '10': 'phase'
    },
    {'1': 'participants', '3': 4, '4': 3, '5': 9, '10': 'participants'},
    {
      '1': 'answers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.SafetyAnswer',
      '10': 'answers'
    },
    {
      '1': 'performed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'performed_by', '3': 7, '4': 1, '5': 9, '10': 'performedBy'},
  ],
};

/// Descriptor for `SafetyCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List safetyCheckDescriptor = $convert.base64Decode(
    'CgtTYWZldHlDaGVjaxIZCghjaGVja19pZBgBIAEoCVIHY2hlY2tJZBIXCgdjYXNlX2lkGAIgAS'
    'gJUgZjYXNlSWQSOAoFcGhhc2UYAyABKA4yIi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2FmZXR5'
    'UGhhc2VSBXBoYXNlEiIKDHBhcnRpY2lwYW50cxgEIAMoCVIMcGFydGljaXBhbnRzEj0KB2Fuc3'
    'dlcnMYBSADKAsyIy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2FmZXR5QW5zd2VyUgdhbnN3ZXJz'
    'Ej0KDHBlcmZvcm1lZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3Blcm'
    'Zvcm1lZEF0EiEKDHBlcmZvcm1lZF9ieRgHIAEoCVILcGVyZm9ybWVkQnk=');

@$core.Deprecated('Use milestoneRecordDescriptor instead')
const MilestoneRecord$json = {
  '1': 'MilestoneRecord',
  '2': [
    {'1': 'milestone_id', '3': 1, '4': 1, '5': 9, '10': 'milestoneId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'milestone',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Milestone',
      '10': 'milestone'
    },
    {
      '1': 'occurred_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'recorded_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 6, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `MilestoneRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List milestoneRecordDescriptor = $convert.base64Decode(
    'Cg9NaWxlc3RvbmVSZWNvcmQSIQoMbWlsZXN0b25lX2lkGAEgASgJUgttaWxlc3RvbmVJZBIXCg'
    'djYXNlX2lkGAIgASgJUgZjYXNlSWQSPgoJbWlsZXN0b25lGAMgASgOMiAuaGVhbHRoY2FyZS50'
    'aGVhdHJlLnYxLk1pbGVzdG9uZVIJbWlsZXN0b25lEjsKC29jY3VycmVkX2F0GAQgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBI7CgtyZWNvcmRlZF9hdBgFIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSHwoLcmVjb3JkZWRfYn'
    'kYBiABKAlSCnJlY29yZGVkQnkSEgoEbm90ZRgHIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use caseIntervalsDescriptor instead')
const CaseIntervals$json = {
  '1': 'CaseIntervals',
  '2': [
    {
      '1': 'anaesthesia_to_incision_seconds',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'anaesthesiaToIncisionSeconds',
      '17': true
    },
    {
      '1': 'incision_to_closure_seconds',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'incisionToClosureSeconds',
      '17': true
    },
    {
      '1': 'theatre_occupancy_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'theatreOccupancySeconds',
      '17': true
    },
    {
      '1': 'pacu_stay_seconds',
      '3': 4,
      '4': 1,
      '5': 3,
      '9': 3,
      '10': 'pacuStaySeconds',
      '17': true
    },
    {
      '1': 'start_delay_seconds',
      '3': 5,
      '4': 1,
      '5': 3,
      '9': 4,
      '10': 'startDelaySeconds',
      '17': true
    },
  ],
  '8': [
    {'1': '_anaesthesia_to_incision_seconds'},
    {'1': '_incision_to_closure_seconds'},
    {'1': '_theatre_occupancy_seconds'},
    {'1': '_pacu_stay_seconds'},
    {'1': '_start_delay_seconds'},
  ],
};

/// Descriptor for `CaseIntervals`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List caseIntervalsDescriptor = $convert.base64Decode(
    'Cg1DYXNlSW50ZXJ2YWxzEkoKH2FuYWVzdGhlc2lhX3RvX2luY2lzaW9uX3NlY29uZHMYASABKA'
    'NIAFIcYW5hZXN0aGVzaWFUb0luY2lzaW9uU2Vjb25kc4gBARJCChtpbmNpc2lvbl90b19jbG9z'
    'dXJlX3NlY29uZHMYAiABKANIAVIYaW5jaXNpb25Ub0Nsb3N1cmVTZWNvbmRziAEBEj8KGXRoZW'
    'F0cmVfb2NjdXBhbmN5X3NlY29uZHMYAyABKANIAlIXdGhlYXRyZU9jY3VwYW5jeVNlY29uZHOI'
    'AQESLwoRcGFjdV9zdGF5X3NlY29uZHMYBCABKANIA1IPcGFjdVN0YXlTZWNvbmRziAEBEjMKE3'
    'N0YXJ0X2RlbGF5X3NlY29uZHMYBSABKANIBFIRc3RhcnREZWxheVNlY29uZHOIAQFCIgogX2Fu'
    'YWVzdGhlc2lhX3RvX2luY2lzaW9uX3NlY29uZHNCHgocX2luY2lzaW9uX3RvX2Nsb3N1cmVfc2'
    'Vjb25kc0IcChpfdGhlYXRyZV9vY2N1cGFuY3lfc2Vjb25kc0IUChJfcGFjdV9zdGF5X3NlY29u'
    'ZHNCFgoUX3N0YXJ0X2RlbGF5X3NlY29uZHM=');

@$core.Deprecated('Use delayDescriptor instead')
const Delay$json = {
  '1': 'Delay',
  '2': [
    {'1': 'delay_id', '3': 1, '4': 1, '5': 9, '10': 'delayId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'reason',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.DelayReason',
      '10': 'reason'
    },
    {'1': 'dependency', '3': 4, '4': 1, '5': 9, '10': 'dependency'},
    {'1': 'minutes', '3': 5, '4': 1, '5': 5, '10': 'minutes'},
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'recorded_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 8, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `Delay`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delayDescriptor = $convert.base64Decode(
    'CgVEZWxheRIZCghkZWxheV9pZBgBIAEoCVIHZGVsYXlJZBIXCgdjYXNlX2lkGAIgASgJUgZjYX'
    'NlSWQSOgoGcmVhc29uGAMgASgOMiIuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkRlbGF5UmVhc29u'
    'UgZyZWFzb24SHgoKZGVwZW5kZW5jeRgEIAEoCVIKZGVwZW5kZW5jeRIYCgdtaW51dGVzGAUgAS'
    'gFUgdtaW51dGVzEhIKBG5vdGUYBiABKAlSBG5vdGUSOwoLcmVjb3JkZWRfYXQYByABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh8KC3JlY29yZGVkX2J5GAggAS'
    'gJUgpyZWNvcmRlZEJ5');

@$core.Deprecated('Use operativeNoteDescriptor instead')
const OperativeNote$json = {
  '1': 'OperativeNote',
  '2': [
    {'1': 'note_id', '3': 1, '4': 1, '5': 9, '10': 'noteId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'version', '3': 3, '4': 1, '5': 5, '10': 'version'},
    {'1': 'supersedes', '3': 4, '4': 1, '5': 9, '10': 'supersedes'},
    {
      '1': 'procedure_performed',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'procedurePerformed'
    },
    {'1': 'findings', '3': 6, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'specimen_ids', '3': 7, '4': 3, '5': 9, '10': 'specimenIds'},
    {'1': 'implant_ids', '3': 8, '4': 3, '5': 9, '10': 'implantIds'},
    {'1': 'complications', '3': 9, '4': 3, '5': 9, '10': 'complications'},
    {
      '1': 'estimated_blood_loss_ml',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'estimatedBloodLossMl'
    },
    {
      '1': 'post_operative_orders',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'postOperativeOrders'
    },
    {'1': 'narrative', '3': 12, '4': 1, '5': 9, '10': 'narrative'},
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.NoteStatus',
      '10': 'status'
    },
    {'1': 'amendment_reason', '3': 14, '4': 1, '5': 9, '10': 'amendmentReason'},
    {'1': 'authored_by', '3': 15, '4': 1, '5': 9, '10': 'authoredBy'},
    {
      '1': 'authored_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'authoredAt'
    },
    {'1': 'signed_by', '3': 17, '4': 1, '5': 9, '10': 'signedBy'},
    {
      '1': 'signed_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedAt'
    },
  ],
};

/// Descriptor for `OperativeNote`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operativeNoteDescriptor = $convert.base64Decode(
    'Cg1PcGVyYXRpdmVOb3RlEhcKB25vdGVfaWQYASABKAlSBm5vdGVJZBIXCgdjYXNlX2lkGAIgAS'
    'gJUgZjYXNlSWQSGAoHdmVyc2lvbhgDIAEoBVIHdmVyc2lvbhIeCgpzdXBlcnNlZGVzGAQgASgJ'
    'UgpzdXBlcnNlZGVzEi8KE3Byb2NlZHVyZV9wZXJmb3JtZWQYBSABKAlSEnByb2NlZHVyZVBlcm'
    'Zvcm1lZBIaCghmaW5kaW5ncxgGIAEoCVIIZmluZGluZ3MSIQoMc3BlY2ltZW5faWRzGAcgAygJ'
    'UgtzcGVjaW1lbklkcxIfCgtpbXBsYW50X2lkcxgIIAMoCVIKaW1wbGFudElkcxIkCg1jb21wbG'
    'ljYXRpb25zGAkgAygJUg1jb21wbGljYXRpb25zEjUKF2VzdGltYXRlZF9ibG9vZF9sb3NzX21s'
    'GAogASgFUhRlc3RpbWF0ZWRCbG9vZExvc3NNbBIyChVwb3N0X29wZXJhdGl2ZV9vcmRlcnMYCy'
    'ABKAlSE3Bvc3RPcGVyYXRpdmVPcmRlcnMSHAoJbmFycmF0aXZlGAwgASgJUgluYXJyYXRpdmUS'
    'OQoGc3RhdHVzGA0gASgOMiEuaGVhbHRoY2FyZS50aGVhdHJlLnYxLk5vdGVTdGF0dXNSBnN0YX'
    'R1cxIpChBhbWVuZG1lbnRfcmVhc29uGA4gASgJUg9hbWVuZG1lbnRSZWFzb24SHwoLYXV0aG9y'
    'ZWRfYnkYDyABKAlSCmF1dGhvcmVkQnkSOwoLYXV0aG9yZWRfYXQYECABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgphdXRob3JlZEF0EhsKCXNpZ25lZF9ieRgRIAEoCVIIc2lnbmVk'
    'QnkSNwoJc2lnbmVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc2lnbm'
    'VkQXQ=');

@$core.Deprecated('Use usageDescriptor instead')
const Usage$json = {
  '1': 'Usage',
  '2': [
    {'1': 'usage_id', '3': 1, '4': 1, '5': 9, '10': 'usageId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.UsageKind',
      '10': 'kind'
    },
    {'1': 'item_code', '3': 4, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 5, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'lot_number', '3': 6, '4': 1, '5': 9, '10': 'lotNumber'},
    {'1': 'serial_number', '3': 7, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'quantity', '3': 8, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'expiry_date',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiryDate'
    },
    {'1': 'scanned', '3': 10, '4': 1, '5': 8, '10': 'scanned'},
    {'1': 'scan_data', '3': 11, '4': 1, '5': 9, '10': 'scanData'},
    {
      '1': 'recorded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 13, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'expired', '3': 14, '4': 1, '5': 8, '10': 'expired'},
  ],
};

/// Descriptor for `Usage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List usageDescriptor = $convert.base64Decode(
    'CgVVc2FnZRIZCgh1c2FnZV9pZBgBIAEoCVIHdXNhZ2VJZBIXCgdjYXNlX2lkGAIgASgJUgZjYX'
    'NlSWQSNAoEa2luZBgDIAEoDjIgLmhlYWx0aGNhcmUudGhlYXRyZS52MS5Vc2FnZUtpbmRSBGtp'
    'bmQSGwoJaXRlbV9jb2RlGAQgASgJUghpdGVtQ29kZRIbCglpdGVtX25hbWUYBSABKAlSCGl0ZW'
    '1OYW1lEh0KCmxvdF9udW1iZXIYBiABKAlSCWxvdE51bWJlchIjCg1zZXJpYWxfbnVtYmVyGAcg'
    'ASgJUgxzZXJpYWxOdW1iZXISGgoIcXVhbnRpdHkYCCABKAVSCHF1YW50aXR5EjsKC2V4cGlyeV'
    '9kYXRlGAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKZXhwaXJ5RGF0ZRIYCgdz'
    'Y2FubmVkGAogASgIUgdzY2FubmVkEhsKCXNjYW5fZGF0YRgLIAEoCVIIc2NhbkRhdGESOwoLcm'
    'Vjb3JkZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0'
    'Eh8KC3JlY29yZGVkX2J5GA0gASgJUgpyZWNvcmRlZEJ5EhgKB2V4cGlyZWQYDiABKAhSB2V4cG'
    'lyZWQ=');

@$core.Deprecated('Use specimenDescriptor instead')
const Specimen$json = {
  '1': 'Specimen',
  '2': [
    {'1': 'specimen_id', '3': 1, '4': 1, '5': 9, '10': 'specimenId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'site', '3': 5, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'laterality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'container', '3': 7, '4': 1, '5': 9, '10': 'container'},
    {'1': 'fixative', '3': 8, '4': 1, '5': 9, '10': 'fixative'},
    {'1': 'order_id', '3': 9, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'taken_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'takenAt'
    },
    {'1': 'taken_by', '3': 11, '4': 1, '5': 9, '10': 'takenBy'},
  ],
};

/// Descriptor for `Specimen`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List specimenDescriptor = $convert.base64Decode(
    'CghTcGVjaW1lbhIfCgtzcGVjaW1lbl9pZBgBIAEoCVIKc3BlY2ltZW5JZBIXCgdjYXNlX2lkGA'
    'IgASgJUgZjYXNlSWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEhQKBWxhYmVsGAQg'
    'ASgJUgVsYWJlbBISCgRzaXRlGAUgASgJUgRzaXRlEkEKCmxhdGVyYWxpdHkYBiABKA4yIS5oZW'
    'FsdGhjYXJlLnRoZWF0cmUudjEuTGF0ZXJhbGl0eVIKbGF0ZXJhbGl0eRIcCgljb250YWluZXIY'
    'ByABKAlSCWNvbnRhaW5lchIaCghmaXhhdGl2ZRgIIAEoCVIIZml4YXRpdmUSGQoIb3JkZXJfaW'
    'QYCSABKAlSB29yZGVySWQSNQoIdGFrZW5fYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgd0YWtlbkF0EhkKCHRha2VuX2J5GAsgASgJUgd0YWtlbkJ5');

@$core.Deprecated('Use trayUseDescriptor instead')
const TrayUse$json = {
  '1': 'TrayUse',
  '2': [
    {'1': 'tray_use_id', '3': 1, '4': 1, '5': 9, '10': 'trayUseId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'tray_id', '3': 3, '4': 1, '5': 9, '10': 'trayId'},
    {'1': 'tray_name', '3': 4, '4': 1, '5': 9, '10': 'trayName'},
    {'1': 'cycle_id', '3': 5, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'indicator_passed', '3': 6, '4': 1, '5': 8, '10': 'indicatorPassed'},
    {'1': 'indicator_note', '3': 7, '4': 1, '5': 9, '10': 'indicatorNote'},
    {
      '1': 'opened_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
    {'1': 'opened_by', '3': 9, '4': 1, '5': 9, '10': 'openedBy'},
  ],
};

/// Descriptor for `TrayUse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trayUseDescriptor = $convert.base64Decode(
    'CgdUcmF5VXNlEh4KC3RyYXlfdXNlX2lkGAEgASgJUgl0cmF5VXNlSWQSFwoHY2FzZV9pZBgCIA'
    'EoCVIGY2FzZUlkEhcKB3RyYXlfaWQYAyABKAlSBnRyYXlJZBIbCgl0cmF5X25hbWUYBCABKAlS'
    'CHRyYXlOYW1lEhkKCGN5Y2xlX2lkGAUgASgJUgdjeWNsZUlkEikKEGluZGljYXRvcl9wYXNzZW'
    'QYBiABKAhSD2luZGljYXRvclBhc3NlZBIlCg5pbmRpY2F0b3Jfbm90ZRgHIAEoCVINaW5kaWNh'
    'dG9yTm90ZRI3CglvcGVuZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'hvcGVuZWRBdBIbCglvcGVuZWRfYnkYCSABKAlSCG9wZW5lZEJ5');

@$core.Deprecated('Use recipientDescriptor instead')
const Recipient$json = {
  '1': 'Recipient',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'case_id', '3': 3, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 4, '4': 1, '5': 9, '10': 'reference'},
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
    'CglSZWNpcGllbnQSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl'
    '9pZBgCIAEoCVILZW5jb3VudGVySWQSFwoHY2FzZV9pZBgDIAEoCVIGY2FzZUlkEhwKCXJlZmVy'
    'ZW5jZRgEIAEoCVIJcmVmZXJlbmNlEioKAmF0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFICYXQ=');

@$core.Deprecated('Use cardItemDescriptor instead')
const CardItem$json = {
  '1': 'CardItem',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 2, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
  ],
};

/// Descriptor for `CardItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cardItemDescriptor = $convert.base64Decode(
    'CghDYXJkSXRlbRIbCglpdGVtX2NvZGUYASABKAlSCGl0ZW1Db2RlEhsKCWl0ZW1fbmFtZRgCIA'
    'EoCVIIaXRlbU5hbWUSGgoIcXVhbnRpdHkYAyABKAVSCHF1YW50aXR5');

@$core.Deprecated('Use preferenceCardDescriptor instead')
const PreferenceCard$json = {
  '1': 'PreferenceCard',
  '2': [
    {'1': 'card_id', '3': 1, '4': 1, '5': 9, '10': 'cardId'},
    {'1': 'surgeon_id', '3': 2, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'procedure_code', '3': 3, '4': 1, '5': 9, '10': 'procedureCode'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'equipment', '3': 5, '4': 3, '5': 9, '10': 'equipment'},
    {
      '1': 'consumables',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.CardItem',
      '10': 'consumables'
    },
    {'1': 'trays', '3': 7, '4': 3, '5': 9, '10': 'trays'},
    {'1': 'notes', '3': 8, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'version', '3': 9, '4': 1, '5': 5, '10': 'version'},
    {
      '1': 'updated_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'updated_by', '3': 11, '4': 1, '5': 9, '10': 'updatedBy'},
  ],
};

/// Descriptor for `PreferenceCard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List preferenceCardDescriptor = $convert.base64Decode(
    'Cg5QcmVmZXJlbmNlQ2FyZBIXCgdjYXJkX2lkGAEgASgJUgZjYXJkSWQSHQoKc3VyZ2Vvbl9pZB'
    'gCIAEoCVIJc3VyZ2VvbklkEiUKDnByb2NlZHVyZV9jb2RlGAMgASgJUg1wcm9jZWR1cmVDb2Rl'
    'EhIKBG5hbWUYBCABKAlSBG5hbWUSHAoJZXF1aXBtZW50GAUgAygJUgllcXVpcG1lbnQSQQoLY2'
    '9uc3VtYWJsZXMYBiADKAsyHy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuQ2FyZEl0ZW1SC2NvbnN1'
    'bWFibGVzEhQKBXRyYXlzGAcgAygJUgV0cmF5cxIUCgVub3RlcxgIIAEoCVIFbm90ZXMSGAoHdm'
    'Vyc2lvbhgJIAEoBVIHdmVyc2lvbhI5Cgp1cGRhdGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0Eh0KCnVwZGF0ZWRfYnkYCyABKAlSCXVwZGF0ZWRCeQ'
    '==');

@$core.Deprecated('Use boardRowDescriptor instead')
const BoardRow$json = {
  '1': 'BoardRow',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'room_code', '3': 2, '4': 1, '5': 9, '10': 'roomCode'},
    {
      '1': 'stage',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.RoomStage',
      '10': 'stage'
    },
    {'1': 'current_case_id', '3': 4, '4': 1, '5': 9, '10': 'currentCaseId'},
    {
      '1': 'current_procedure',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'currentProcedure'
    },
    {'1': 'current_surgeon', '3': 6, '4': 1, '5': 9, '10': 'currentSurgeon'},
    {
      '1': 'current_milestone',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Milestone',
      '10': 'currentMilestone'
    },
    {'1': 'elapsed_seconds', '3': 8, '4': 1, '5': 3, '10': 'elapsedSeconds'},
    {'1': 'over_running', '3': 9, '4': 1, '5': 8, '10': 'overRunning'},
    {'1': 'next_case_id', '3': 10, '4': 1, '5': 9, '10': 'nextCaseId'},
    {'1': 'next_procedure', '3': 11, '4': 1, '5': 9, '10': 'nextProcedure'},
    {
      '1': 'next_start',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'nextStart'
    },
    {'1': 'next_ready', '3': 13, '4': 1, '5': 8, '10': 'nextReady'},
    {'1': 'next_blockers', '3': 14, '4': 3, '5': 9, '10': 'nextBlockers'},
    {
      '1': 'turnover_so_far_seconds',
      '3': 15,
      '4': 1,
      '5': 3,
      '10': 'turnoverSoFarSeconds'
    },
    {'1': 'delay_minutes', '3': 16, '4': 1, '5': 5, '10': 'delayMinutes'},
  ],
};

/// Descriptor for `BoardRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardRowDescriptor = $convert.base64Decode(
    'CghCb2FyZFJvdxIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSGwoJcm9vbV9jb2RlGAIgASgJUg'
    'hyb29tQ29kZRI2CgVzdGFnZRgDIAEoDjIgLmhlYWx0aGNhcmUudGhlYXRyZS52MS5Sb29tU3Rh'
    'Z2VSBXN0YWdlEiYKD2N1cnJlbnRfY2FzZV9pZBgEIAEoCVINY3VycmVudENhc2VJZBIrChFjdX'
    'JyZW50X3Byb2NlZHVyZRgFIAEoCVIQY3VycmVudFByb2NlZHVyZRInCg9jdXJyZW50X3N1cmdl'
    'b24YBiABKAlSDmN1cnJlbnRTdXJnZW9uEk0KEWN1cnJlbnRfbWlsZXN0b25lGAcgASgOMiAuaG'
    'VhbHRoY2FyZS50aGVhdHJlLnYxLk1pbGVzdG9uZVIQY3VycmVudE1pbGVzdG9uZRInCg9lbGFw'
    'c2VkX3NlY29uZHMYCCABKANSDmVsYXBzZWRTZWNvbmRzEiEKDG92ZXJfcnVubmluZxgJIAEoCF'
    'ILb3ZlclJ1bm5pbmcSIAoMbmV4dF9jYXNlX2lkGAogASgJUgpuZXh0Q2FzZUlkEiUKDm5leHRf'
    'cHJvY2VkdXJlGAsgASgJUg1uZXh0UHJvY2VkdXJlEjkKCm5leHRfc3RhcnQYDCABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgluZXh0U3RhcnQSHQoKbmV4dF9yZWFkeRgNIAEoCFIJ'
    'bmV4dFJlYWR5EiMKDW5leHRfYmxvY2tlcnMYDiADKAlSDG5leHRCbG9ja2VycxI1Chd0dXJub3'
    'Zlcl9zb19mYXJfc2Vjb25kcxgPIAEoA1IUdHVybm92ZXJTb0ZhclNlY29uZHMSIwoNZGVsYXlf'
    'bWludXRlcxgQIAEoBVIMZGVsYXlNaW51dGVz');

@$core.Deprecated('Use causeCountDescriptor instead')
const CauseCount$json = {
  '1': 'CauseCount',
  '2': [
    {
      '1': 'cause',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.CaseCause',
      '10': 'cause'
    },
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
  ],
};

/// Descriptor for `CauseCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List causeCountDescriptor = $convert.base64Decode(
    'CgpDYXVzZUNvdW50EjYKBWNhdXNlGAEgASgOMiAuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkNhc2'
    'VDYXVzZVIFY2F1c2USFAoFY291bnQYAiABKAVSBWNvdW50');

@$core.Deprecated('Use delayCountDescriptor instead')
const DelayCount$json = {
  '1': 'DelayCount',
  '2': [
    {
      '1': 'reason',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.DelayReason',
      '10': 'reason'
    },
    {'1': 'minutes', '3': 2, '4': 1, '5': 5, '10': 'minutes'},
  ],
};

/// Descriptor for `DelayCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List delayCountDescriptor = $convert.base64Decode(
    'CgpEZWxheUNvdW50EjoKBnJlYXNvbhgBIAEoDjIiLmhlYWx0aGNhcmUudGhlYXRyZS52MS5EZW'
    'xheVJlYXNvblIGcmVhc29uEhgKB21pbnV0ZXMYAiABKAVSB21pbnV0ZXM=');

@$core.Deprecated('Use utilisationDescriptor instead')
const Utilisation$json = {
  '1': 'Utilisation',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
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
    {
      '1': 'scheduled_minutes',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'scheduledMinutes'
    },
    {
      '1': 'operating_minutes',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'operatingMinutes'
    },
    {'1': 'block_minutes', '3': 6, '4': 1, '5': 5, '10': 'blockMinutes'},
    {'1': 'cases', '3': 7, '4': 1, '5': 5, '10': 'cases'},
    {'1': 'completed', '3': 8, '4': 1, '5': 5, '10': 'completed'},
    {'1': 'cancelled', '3': 9, '4': 1, '5': 5, '10': 'cancelled'},
    {'1': 'postponed', '3': 10, '4': 1, '5': 5, '10': 'postponed'},
    {
      '1': 'cancellations_by_cause',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.CauseCount',
      '10': 'cancellationsByCause'
    },
    {'1': 'on_time_starts', '3': 12, '4': 1, '5': 5, '10': 'onTimeStarts'},
    {'1': 'first_cases', '3': 13, '4': 1, '5': 5, '10': 'firstCases'},
    {
      '1': 'on_time_first_cases',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'onTimeFirstCases'
    },
    {'1': 'turnover_count', '3': 15, '4': 1, '5': 5, '10': 'turnoverCount'},
    {'1': 'turnover_minutes', '3': 16, '4': 1, '5': 5, '10': 'turnoverMinutes'},
    {'1': 'delay_minutes', '3': 17, '4': 1, '5': 5, '10': 'delayMinutes'},
    {
      '1': 'delays_by_reason',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.DelayCount',
      '10': 'delaysByReason'
    },
  ],
};

/// Descriptor for `Utilisation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List utilisationDescriptor = $convert.base64Decode(
    'CgtVdGlsaXNhdGlvbhIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSLgoEZnJvbRgCIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAyABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUgJ0bxIrChFzY2hlZHVsZWRfbWludXRlcxgEIAEoBVIQc2NoZWR1bG'
    'VkTWludXRlcxIrChFvcGVyYXRpbmdfbWludXRlcxgFIAEoBVIQb3BlcmF0aW5nTWludXRlcxIj'
    'Cg1ibG9ja19taW51dGVzGAYgASgFUgxibG9ja01pbnV0ZXMSFAoFY2FzZXMYByABKAVSBWNhc2'
    'VzEhwKCWNvbXBsZXRlZBgIIAEoBVIJY29tcGxldGVkEhwKCWNhbmNlbGxlZBgJIAEoBVIJY2Fu'
    'Y2VsbGVkEhwKCXBvc3Rwb25lZBgKIAEoBVIJcG9zdHBvbmVkElcKFmNhbmNlbGxhdGlvbnNfYn'
    'lfY2F1c2UYCyADKAsyIS5oZWFsdGhjYXJlLnRoZWF0cmUudjEuQ2F1c2VDb3VudFIUY2FuY2Vs'
    'bGF0aW9uc0J5Q2F1c2USJAoOb25fdGltZV9zdGFydHMYDCABKAVSDG9uVGltZVN0YXJ0cxIfCg'
    'tmaXJzdF9jYXNlcxgNIAEoBVIKZmlyc3RDYXNlcxItChNvbl90aW1lX2ZpcnN0X2Nhc2VzGA4g'
    'ASgFUhBvblRpbWVGaXJzdENhc2VzEiUKDnR1cm5vdmVyX2NvdW50GA8gASgFUg10dXJub3Zlck'
    'NvdW50EikKEHR1cm5vdmVyX21pbnV0ZXMYECABKAVSD3R1cm5vdmVyTWludXRlcxIjCg1kZWxh'
    'eV9taW51dGVzGBEgASgFUgxkZWxheU1pbnV0ZXMSSwoQZGVsYXlzX2J5X3JlYXNvbhgSIAMoCz'
    'IhLmhlYWx0aGNhcmUudGhlYXRyZS52MS5EZWxheUNvdW50Ug5kZWxheXNCeVJlYXNvbg==');

@$core.Deprecated('Use saveRoomRequestDescriptor instead')
const SaveRoomRequest$json = {
  '1': 'SaveRoomRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'specialties', '3': 5, '4': 3, '5': 9, '10': 'specialties'},
    {'1': 'equipment', '3': 6, '4': 3, '5': 9, '10': 'equipment'},
    {'1': 'active', '3': 7, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `SaveRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveRoomRequestDescriptor = $convert.base64Decode(
    'Cg9TYXZlUm9vbVJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEh8KC2ZhY2lsaXR5X2'
    'lkGAIgASgJUgpmYWNpbGl0eUlkEhIKBGNvZGUYAyABKAlSBGNvZGUSEgoEbmFtZRgEIAEoCVIE'
    'bmFtZRIgCgtzcGVjaWFsdGllcxgFIAMoCVILc3BlY2lhbHRpZXMSHAoJZXF1aXBtZW50GAYgAy'
    'gJUgllcXVpcG1lbnQSFgoGYWN0aXZlGAcgASgIUgZhY3RpdmU=');

@$core.Deprecated('Use saveRoomResponseDescriptor instead')
const SaveRoomResponse$json = {
  '1': 'SaveRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `SaveRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveRoomResponseDescriptor = $convert.base64Decode(
    'ChBTYXZlUm9vbVJlc3BvbnNlEi8KBHJvb20YASABKAsyGy5oZWFsdGhjYXJlLnRoZWF0cmUudj'
    'EuUm9vbVIEcm9vbQ==');

@$core.Deprecated('Use listRoomsRequestDescriptor instead')
const ListRoomsRequest$json = {
  '1': 'ListRoomsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `ListRoomsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Um9vbXNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUgpmYWNpbGl0eUlk');

@$core.Deprecated('Use listRoomsResponseDescriptor instead')
const ListRoomsResponse$json = {
  '1': 'ListRoomsResponse',
  '2': [
    {
      '1': 'rooms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Room',
      '10': 'rooms'
    },
  ],
};

/// Descriptor for `ListRoomsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoomsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Um9vbXNSZXNwb25zZRIxCgVyb29tcxgBIAMoCzIbLmhlYWx0aGNhcmUudGhlYXRyZS'
    '52MS5Sb29tUgVyb29tcw==');

@$core.Deprecated('Use saveBlockRequestDescriptor instead')
const SaveBlockRequest$json = {
  '1': 'SaveBlockRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.BlockKind',
      '10': 'kind'
    },
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'specialty', '3': 4, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'starts_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `SaveBlockRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveBlockRequestDescriptor = $convert.base64Decode(
    'ChBTYXZlQmxvY2tSZXF1ZXN0EhcKB3Jvb21faWQYASABKAlSBnJvb21JZBI0CgRraW5kGAIgAS'
    'gOMiAuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkJsb2NrS2luZFIEa2luZBIZCghvd25lcl9pZBgD'
    'IAEoCVIHb3duZXJJZBIcCglzcGVjaWFsdHkYBCABKAlSCXNwZWNpYWx0eRI3CglzdGFydHNfYX'
    'QYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBIzCgdlbmRzX2F0'
    'GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGZW5kc0F0EhIKBG5vdGUYByABKA'
    'lSBG5vdGU=');

@$core.Deprecated('Use saveBlockResponseDescriptor instead')
const SaveBlockResponse$json = {
  '1': 'SaveBlockResponse',
  '2': [
    {
      '1': 'block',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Block',
      '10': 'block'
    },
  ],
};

/// Descriptor for `SaveBlockResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveBlockResponseDescriptor = $convert.base64Decode(
    'ChFTYXZlQmxvY2tSZXNwb25zZRIyCgVibG9jaxgBIAEoCzIcLmhlYWx0aGNhcmUudGhlYXRyZS'
    '52MS5CbG9ja1IFYmxvY2s=');

@$core.Deprecated('Use requestSurgeryRequestDescriptor instead')
const RequestSurgeryRequest$json = {
  '1': 'RequestSurgeryRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'procedure_code', '3': 4, '4': 1, '5': 9, '10': 'procedureCode'},
    {
      '1': 'procedure_display',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'procedureDisplay'
    },
    {'1': 'diagnosis_code', '3': 6, '4': 1, '5': 9, '10': 'diagnosisCode'},
    {
      '1': 'diagnosis_display',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'diagnosisDisplay'
    },
    {
      '1': 'laterality',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'site', '3': 9, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'urgency',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Urgency',
      '10': 'urgency'
    },
    {
      '1': 'expected_duration_seconds',
      '3': 11,
      '4': 1,
      '5': 3,
      '10': 'expectedDurationSeconds'
    },
    {'1': 'surgeon_id', '3': 12, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'team', '3': 13, '4': 3, '5': 9, '10': 'team'},
    {'1': 'requirements', '3': 14, '4': 3, '5': 9, '10': 'requirements'},
    {'1': 'anaesthesia_type', '3': 15, '4': 1, '5': 9, '10': 'anaesthesiaType'},
    {'1': 'special_notes', '3': 16, '4': 1, '5': 9, '10': 'specialNotes'},
    {'1': 'seed_from_card', '3': 17, '4': 1, '5': 8, '10': 'seedFromCard'},
  ],
};

/// Descriptor for `RequestSurgeryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSurgeryRequestDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0U3VyZ2VyeVJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZX'
    'JJZBIdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSHwoLZmFjaWxpdHlfaWQYAyABKAlS'
    'CmZhY2lsaXR5SWQSJQoOcHJvY2VkdXJlX2NvZGUYBCABKAlSDXByb2NlZHVyZUNvZGUSKwoRcH'
    'JvY2VkdXJlX2Rpc3BsYXkYBSABKAlSEHByb2NlZHVyZURpc3BsYXkSJQoOZGlhZ25vc2lzX2Nv'
    'ZGUYBiABKAlSDWRpYWdub3Npc0NvZGUSKwoRZGlhZ25vc2lzX2Rpc3BsYXkYByABKAlSEGRpYW'
    'dub3Npc0Rpc3BsYXkSQQoKbGF0ZXJhbGl0eRgIIAEoDjIhLmhlYWx0aGNhcmUudGhlYXRyZS52'
    'MS5MYXRlcmFsaXR5UgpsYXRlcmFsaXR5EhIKBHNpdGUYCSABKAlSBHNpdGUSOAoHdXJnZW5jeR'
    'gKIAEoDjIeLmhlYWx0aGNhcmUudGhlYXRyZS52MS5VcmdlbmN5Ugd1cmdlbmN5EjoKGWV4cGVj'
    'dGVkX2R1cmF0aW9uX3NlY29uZHMYCyABKANSF2V4cGVjdGVkRHVyYXRpb25TZWNvbmRzEh0KCn'
    'N1cmdlb25faWQYDCABKAlSCXN1cmdlb25JZBISCgR0ZWFtGA0gAygJUgR0ZWFtEiIKDHJlcXVp'
    'cmVtZW50cxgOIAMoCVIMcmVxdWlyZW1lbnRzEikKEGFuYWVzdGhlc2lhX3R5cGUYDyABKAlSD2'
    'FuYWVzdGhlc2lhVHlwZRIjCg1zcGVjaWFsX25vdGVzGBAgASgJUgxzcGVjaWFsTm90ZXMSJAoO'
    'c2VlZF9mcm9tX2NhcmQYESABKAhSDHNlZWRGcm9tQ2FyZA==');

@$core.Deprecated('Use requestSurgeryResponseDescriptor instead')
const RequestSurgeryResponse$json = {
  '1': 'RequestSurgeryResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
    {'1': 'outstanding', '3': 2, '4': 3, '5': 9, '10': 'outstanding'},
  ],
};

/// Descriptor for `RequestSurgeryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestSurgeryResponseDescriptor = $convert.base64Decode(
    'ChZSZXF1ZXN0U3VyZ2VyeVJlc3BvbnNlEkgKDXN1cmdpY2FsX2Nhc2UYASABKAsyIy5oZWFsdG'
    'hjYXJlLnRoZWF0cmUudjEuU3VyZ2ljYWxDYXNlUgxzdXJnaWNhbENhc2USIAoLb3V0c3RhbmRp'
    'bmcYAiADKAlSC291dHN0YW5kaW5n');

@$core.Deprecated('Use completeRequestRequestDescriptor instead')
const CompleteRequestRequest$json = {
  '1': 'CompleteRequestRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'diagnosis_code', '3': 2, '4': 1, '5': 9, '10': 'diagnosisCode'},
    {
      '1': 'diagnosis_display',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'diagnosisDisplay'
    },
    {
      '1': 'laterality',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'site', '3': 5, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'expected_duration_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'expectedDurationSeconds'
    },
    {'1': 'surgeon_id', '3': 7, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'team', '3': 8, '4': 3, '5': 9, '10': 'team'},
    {'1': 'requirements', '3': 9, '4': 3, '5': 9, '10': 'requirements'},
  ],
};

/// Descriptor for `CompleteRequestRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRequestRequestDescriptor = $convert.base64Decode(
    'ChZDb21wbGV0ZVJlcXVlc3RSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIlCg5kaW'
    'Fnbm9zaXNfY29kZRgCIAEoCVINZGlhZ25vc2lzQ29kZRIrChFkaWFnbm9zaXNfZGlzcGxheRgD'
    'IAEoCVIQZGlhZ25vc2lzRGlzcGxheRJBCgpsYXRlcmFsaXR5GAQgASgOMiEuaGVhbHRoY2FyZS'
    '50aGVhdHJlLnYxLkxhdGVyYWxpdHlSCmxhdGVyYWxpdHkSEgoEc2l0ZRgFIAEoCVIEc2l0ZRI6'
    'ChlleHBlY3RlZF9kdXJhdGlvbl9zZWNvbmRzGAYgASgDUhdleHBlY3RlZER1cmF0aW9uU2Vjb2'
    '5kcxIdCgpzdXJnZW9uX2lkGAcgASgJUglzdXJnZW9uSWQSEgoEdGVhbRgIIAMoCVIEdGVhbRIi'
    'CgxyZXF1aXJlbWVudHMYCSADKAlSDHJlcXVpcmVtZW50cw==');

@$core.Deprecated('Use completeRequestResponseDescriptor instead')
const CompleteRequestResponse$json = {
  '1': 'CompleteRequestResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
    {'1': 'outstanding', '3': 2, '4': 3, '5': 9, '10': 'outstanding'},
  ],
};

/// Descriptor for `CompleteRequestResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRequestResponseDescriptor = $convert.base64Decode(
    'ChdDb21wbGV0ZVJlcXVlc3RSZXNwb25zZRJICg1zdXJnaWNhbF9jYXNlGAEgASgLMiMuaGVhbH'
    'RoY2FyZS50aGVhdHJlLnYxLlN1cmdpY2FsQ2FzZVIMc3VyZ2ljYWxDYXNlEiAKC291dHN0YW5k'
    'aW5nGAIgAygJUgtvdXRzdGFuZGluZw==');

@$core.Deprecated('Use getSurgicalCaseRequestDescriptor instead')
const GetSurgicalCaseRequest$json = {
  '1': 'GetSurgicalCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetSurgicalCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSurgicalCaseRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRTdXJnaWNhbENhc2VSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZA==');

@$core.Deprecated('Use getSurgicalCaseResponseDescriptor instead')
const GetSurgicalCaseResponse$json = {
  '1': 'GetSurgicalCaseResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
    {
      '1': 'preop',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.PreopEntry',
      '10': 'preop'
    },
    {
      '1': 'blockers',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Blocker',
      '10': 'blockers'
    },
    {
      '1': 'safety_checks',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.SafetyCheck',
      '10': 'safetyChecks'
    },
    {
      '1': 'milestones',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.MilestoneRecord',
      '10': 'milestones'
    },
    {
      '1': 'intervals',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.CaseIntervals',
      '10': 'intervals'
    },
    {
      '1': 'delays',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Delay',
      '10': 'delays'
    },
    {
      '1': 'notes',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.OperativeNote',
      '10': 'notes'
    },
    {
      '1': 'usage',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Usage',
      '10': 'usage'
    },
    {
      '1': 'specimens',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Specimen',
      '10': 'specimens'
    },
    {
      '1': 'trays',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.TrayUse',
      '10': 'trays'
    },
  ],
};

/// Descriptor for `GetSurgicalCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSurgicalCaseResponseDescriptor = $convert.base64Decode(
    'ChdHZXRTdXJnaWNhbENhc2VSZXNwb25zZRJICg1zdXJnaWNhbF9jYXNlGAEgASgLMiMuaGVhbH'
    'RoY2FyZS50aGVhdHJlLnYxLlN1cmdpY2FsQ2FzZVIMc3VyZ2ljYWxDYXNlEjcKBXByZW9wGAIg'
    'AygLMiEuaGVhbHRoY2FyZS50aGVhdHJlLnYxLlByZW9wRW50cnlSBXByZW9wEjoKCGJsb2NrZX'
    'JzGAMgAygLMh4uaGVhbHRoY2FyZS50aGVhdHJlLnYxLkJsb2NrZXJSCGJsb2NrZXJzEkcKDXNh'
    'ZmV0eV9jaGVja3MYBCADKAsyIi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2FmZXR5Q2hlY2tSDH'
    'NhZmV0eUNoZWNrcxJGCgptaWxlc3RvbmVzGAUgAygLMiYuaGVhbHRoY2FyZS50aGVhdHJlLnYx'
    'Lk1pbGVzdG9uZVJlY29yZFIKbWlsZXN0b25lcxJCCglpbnRlcnZhbHMYBiABKAsyJC5oZWFsdG'
    'hjYXJlLnRoZWF0cmUudjEuQ2FzZUludGVydmFsc1IJaW50ZXJ2YWxzEjQKBmRlbGF5cxgHIAMo'
    'CzIcLmhlYWx0aGNhcmUudGhlYXRyZS52MS5EZWxheVIGZGVsYXlzEjoKBW5vdGVzGAggAygLMi'
    'QuaGVhbHRoY2FyZS50aGVhdHJlLnYxLk9wZXJhdGl2ZU5vdGVSBW5vdGVzEjIKBXVzYWdlGAkg'
    'AygLMhwuaGVhbHRoY2FyZS50aGVhdHJlLnYxLlVzYWdlUgV1c2FnZRI9CglzcGVjaW1lbnMYCi'
    'ADKAsyHy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU3BlY2ltZW5SCXNwZWNpbWVucxI0CgV0cmF5'
    'cxgLIAMoCzIeLmhlYWx0aGNhcmUudGhlYXRyZS52MS5UcmF5VXNlUgV0cmF5cw==');

@$core.Deprecated('Use reprioritiseRequestDescriptor instead')
const ReprioritiseRequest$json = {
  '1': 'ReprioritiseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'urgency',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Urgency',
      '10': 'urgency'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReprioritiseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprioritiseRequestDescriptor = $convert.base64Decode(
    'ChNSZXByaW9yaXRpc2VSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBI4Cgd1cmdlbm'
    'N5GAIgASgOMh4uaGVhbHRoY2FyZS50aGVhdHJlLnYxLlVyZ2VuY3lSB3VyZ2VuY3kSFgoGcmVh'
    'c29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use reprioritiseResponseDescriptor instead')
const ReprioritiseResponse$json = {
  '1': 'ReprioritiseResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
  ],
};

/// Descriptor for `ReprioritiseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprioritiseResponseDescriptor = $convert.base64Decode(
    'ChRSZXByaW9yaXRpc2VSZXNwb25zZRJICg1zdXJnaWNhbF9jYXNlGAEgASgLMiMuaGVhbHRoY2'
    'FyZS50aGVhdHJlLnYxLlN1cmdpY2FsQ2FzZVIMc3VyZ2ljYWxDYXNl');

@$core.Deprecated('Use checkSlotRequestDescriptor instead')
const CheckSlotRequest$json = {
  '1': 'CheckSlotRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'start',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'start'
    },
    {
      '1': 'end',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'end'
    },
  ],
};

/// Descriptor for `CheckSlotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkSlotRequestDescriptor = $convert.base64Decode(
    'ChBDaGVja1Nsb3RSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIXCgdyb29tX2lkGA'
    'IgASgJUgZyb29tSWQSMAoFc3RhcnQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UgVzdGFydBIsCgNlbmQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgNlbmQ=');

@$core.Deprecated('Use checkSlotResponseDescriptor instead')
const CheckSlotResponse$json = {
  '1': 'CheckSlotResponse',
  '2': [
    {
      '1': 'conflicts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.ScheduleConflict',
      '10': 'conflicts'
    },
  ],
};

/// Descriptor for `CheckSlotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkSlotResponseDescriptor = $convert.base64Decode(
    'ChFDaGVja1Nsb3RSZXNwb25zZRJFCgljb25mbGljdHMYASADKAsyJy5oZWFsdGhjYXJlLnRoZW'
    'F0cmUudjEuU2NoZWR1bGVDb25mbGljdFIJY29uZmxpY3Rz');

@$core.Deprecated('Use scheduleCaseRequestDescriptor instead')
const ScheduleCaseRequest$json = {
  '1': 'ScheduleCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {
      '1': 'start',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'start'
    },
    {
      '1': 'end',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'end'
    },
    {'1': 'override', '3': 5, '4': 1, '5': 8, '10': 'override'},
    {'1': 'override_reason', '3': 6, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `ScheduleCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleCaseRequestDescriptor = $convert.base64Decode(
    'ChNTY2hlZHVsZUNhc2VSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIXCgdyb29tX2'
    'lkGAIgASgJUgZyb29tSWQSMAoFc3RhcnQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgVzdGFydBIsCgNlbmQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgNlbm'
    'QSGgoIb3ZlcnJpZGUYBSABKAhSCG92ZXJyaWRlEicKD292ZXJyaWRlX3JlYXNvbhgGIAEoCVIO'
    'b3ZlcnJpZGVSZWFzb24=');

@$core.Deprecated('Use scheduleCaseResponseDescriptor instead')
const ScheduleCaseResponse$json = {
  '1': 'ScheduleCaseResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
    {
      '1': 'conflicts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.ScheduleConflict',
      '10': 'conflicts'
    },
    {'1': 'booked', '3': 3, '4': 1, '5': 8, '10': 'booked'},
  ],
};

/// Descriptor for `ScheduleCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleCaseResponseDescriptor = $convert.base64Decode(
    'ChRTY2hlZHVsZUNhc2VSZXNwb25zZRJICg1zdXJnaWNhbF9jYXNlGAEgASgLMiMuaGVhbHRoY2'
    'FyZS50aGVhdHJlLnYxLlN1cmdpY2FsQ2FzZVIMc3VyZ2ljYWxDYXNlEkUKCWNvbmZsaWN0cxgC'
    'IAMoCzInLmhlYWx0aGNhcmUudGhlYXRyZS52MS5TY2hlZHVsZUNvbmZsaWN0Ugljb25mbGljdH'
    'MSFgoGYm9va2VkGAMgASgIUgZib29rZWQ=');

@$core.Deprecated('Use closeCaseRequestDescriptor instead')
const CloseCaseRequest$json = {
  '1': 'CloseCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'postpone', '3': 2, '4': 1, '5': 8, '10': 'postpone'},
    {
      '1': 'cause',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.CaseCause',
      '10': 'cause'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CloseCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeCaseRequestDescriptor = $convert.base64Decode(
    'ChBDbG9zZUNhc2VSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIaCghwb3N0cG9uZR'
    'gCIAEoCFIIcG9zdHBvbmUSNgoFY2F1c2UYAyABKA4yIC5oZWFsdGhjYXJlLnRoZWF0cmUudjEu'
    'Q2FzZUNhdXNlUgVjYXVzZRIWCgZyZWFzb24YBCABKAlSBnJlYXNvbhISCgRub3RlGAUgASgJUg'
    'Rub3Rl');

@$core.Deprecated('Use closeCaseResponseDescriptor instead')
const CloseCaseResponse$json = {
  '1': 'CloseCaseResponse',
  '2': [
    {
      '1': 'surgical_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'surgicalCase'
    },
  ],
};

/// Descriptor for `CloseCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeCaseResponseDescriptor = $convert.base64Decode(
    'ChFDbG9zZUNhc2VSZXNwb25zZRJICg1zdXJnaWNhbF9jYXNlGAEgASgLMiMuaGVhbHRoY2FyZS'
    '50aGVhdHJlLnYxLlN1cmdpY2FsQ2FzZVIMc3VyZ2ljYWxDYXNl');

@$core.Deprecated('Use listWaitingRequestDescriptor instead')
const ListWaitingRequest$json = {
  '1': 'ListWaitingRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListWaitingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaitingRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0V2FpdGluZ1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSGw'
    'oJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listWaitingResponseDescriptor instead')
const ListWaitingResponse$json = {
  '1': 'ListWaitingResponse',
  '2': [
    {
      '1': 'cases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.SurgicalCase',
      '10': 'cases'
    },
  ],
};

/// Descriptor for `ListWaitingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaitingResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0V2FpdGluZ1Jlc3BvbnNlEjkKBWNhc2VzGAEgAygLMiMuaGVhbHRoY2FyZS50aGVhdH'
    'JlLnYxLlN1cmdpY2FsQ2FzZVIFY2FzZXM=');

@$core.Deprecated('Use recordPreopRequestDescriptor instead')
const RecordPreopRequest$json = {
  '1': 'RecordPreopRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.PreopState',
      '10': 'state'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {'1': 'waived_role', '3': 5, '4': 1, '5': 9, '10': 'waivedRole'},
  ],
};

/// Descriptor for `RecordPreopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPreopRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRQcmVvcFJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEhIKBGNvZGUYAi'
    'ABKAlSBGNvZGUSNwoFc3RhdGUYAyABKA4yIS5oZWFsdGhjYXJlLnRoZWF0cmUudjEuUHJlb3BT'
    'dGF0ZVIFc3RhdGUSEgoEbm90ZRgEIAEoCVIEbm90ZRIfCgt3YWl2ZWRfcm9sZRgFIAEoCVIKd2'
    'FpdmVkUm9sZQ==');

@$core.Deprecated('Use recordPreopResponseDescriptor instead')
const RecordPreopResponse$json = {
  '1': 'RecordPreopResponse',
  '2': [
    {
      '1': 'blockers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Blocker',
      '10': 'blockers'
    },
  ],
};

/// Descriptor for `RecordPreopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPreopResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRQcmVvcFJlc3BvbnNlEjoKCGJsb2NrZXJzGAEgAygLMh4uaGVhbHRoY2FyZS50aG'
    'VhdHJlLnYxLkJsb2NrZXJSCGJsb2NrZXJz');

@$core.Deprecated('Use listBlockersRequestDescriptor instead')
const ListBlockersRequest$json = {
  '1': 'ListBlockersRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `ListBlockersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockersRequestDescriptor =
    $convert.base64Decode(
        'ChNMaXN0QmxvY2tlcnNSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZA==');

@$core.Deprecated('Use listBlockersResponseDescriptor instead')
const ListBlockersResponse$json = {
  '1': 'ListBlockersResponse',
  '2': [
    {
      '1': 'blockers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Blocker',
      '10': 'blockers'
    },
  ],
};

/// Descriptor for `ListBlockersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBlockersResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0QmxvY2tlcnNSZXNwb25zZRI6CghibG9ja2VycxgBIAMoCzIeLmhlYWx0aGNhcmUudG'
    'hlYXRyZS52MS5CbG9ja2VyUghibG9ja2Vycw==');

@$core.Deprecated('Use performSafetyCheckRequestDescriptor instead')
const PerformSafetyCheckRequest$json = {
  '1': 'PerformSafetyCheckRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'phase',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.SafetyPhase',
      '10': 'phase'
    },
    {'1': 'participants', '3': 3, '4': 3, '5': 9, '10': 'participants'},
    {
      '1': 'answers',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.SafetyAnswer',
      '10': 'answers'
    },
  ],
};

/// Descriptor for `PerformSafetyCheckRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performSafetyCheckRequestDescriptor = $convert.base64Decode(
    'ChlQZXJmb3JtU2FmZXR5Q2hlY2tSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBI4Cg'
    'VwaGFzZRgCIAEoDjIiLmhlYWx0aGNhcmUudGhlYXRyZS52MS5TYWZldHlQaGFzZVIFcGhhc2US'
    'IgoMcGFydGljaXBhbnRzGAMgAygJUgxwYXJ0aWNpcGFudHMSPQoHYW5zd2VycxgEIAMoCzIjLm'
    'hlYWx0aGNhcmUudGhlYXRyZS52MS5TYWZldHlBbnN3ZXJSB2Fuc3dlcnM=');

@$core.Deprecated('Use performSafetyCheckResponseDescriptor instead')
const PerformSafetyCheckResponse$json = {
  '1': 'PerformSafetyCheckResponse',
  '2': [
    {
      '1': 'check',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.SafetyCheck',
      '10': 'check'
    },
  ],
};

/// Descriptor for `PerformSafetyCheckResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performSafetyCheckResponseDescriptor =
    $convert.base64Decode(
        'ChpQZXJmb3JtU2FmZXR5Q2hlY2tSZXNwb25zZRI4CgVjaGVjaxgBIAEoCzIiLmhlYWx0aGNhcm'
        'UudGhlYXRyZS52MS5TYWZldHlDaGVja1IFY2hlY2s=');

@$core.Deprecated('Use recordMilestoneRequestDescriptor instead')
const RecordMilestoneRequest$json = {
  '1': 'RecordMilestoneRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'milestone',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.Milestone',
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
  ],
};

/// Descriptor for `RecordMilestoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMilestoneRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvcmRNaWxlc3RvbmVSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBI+CgltaW'
    'xlc3RvbmUYAiABKA4yIC5oZWFsdGhjYXJlLnRoZWF0cmUudjEuTWlsZXN0b25lUgltaWxlc3Rv'
    'bmUSOwoLb2NjdXJyZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2'
    'N1cnJlZEF0EhIKBG5vdGUYBCABKAlSBG5vdGU=');

@$core.Deprecated('Use recordMilestoneResponseDescriptor instead')
const RecordMilestoneResponse$json = {
  '1': 'RecordMilestoneResponse',
  '2': [
    {
      '1': 'milestone',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.MilestoneRecord',
      '10': 'milestone'
    },
  ],
};

/// Descriptor for `RecordMilestoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMilestoneResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvcmRNaWxlc3RvbmVSZXNwb25zZRJECgltaWxlc3RvbmUYASABKAsyJi5oZWFsdGhjYX'
        'JlLnRoZWF0cmUudjEuTWlsZXN0b25lUmVjb3JkUgltaWxlc3RvbmU=');

@$core.Deprecated('Use getTimelineRequestDescriptor instead')
const GetTimelineRequest$json = {
  '1': 'GetTimelineRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXRUaW1lbGluZVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlk');

@$core.Deprecated('Use getTimelineResponseDescriptor instead')
const GetTimelineResponse$json = {
  '1': 'GetTimelineResponse',
  '2': [
    {
      '1': 'milestones',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.MilestoneRecord',
      '10': 'milestones'
    },
    {
      '1': 'intervals',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.CaseIntervals',
      '10': 'intervals'
    },
    {'1': 'out_of_sequence', '3': 3, '4': 3, '5': 9, '10': 'outOfSequence'},
  ],
};

/// Descriptor for `GetTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUaW1lbGluZVJlc3BvbnNlEkYKCm1pbGVzdG9uZXMYASADKAsyJi5oZWFsdGhjYXJlLn'
    'RoZWF0cmUudjEuTWlsZXN0b25lUmVjb3JkUgptaWxlc3RvbmVzEkIKCWludGVydmFscxgCIAEo'
    'CzIkLmhlYWx0aGNhcmUudGhlYXRyZS52MS5DYXNlSW50ZXJ2YWxzUglpbnRlcnZhbHMSJgoPb3'
    'V0X29mX3NlcXVlbmNlGAMgAygJUg1vdXRPZlNlcXVlbmNl');

@$core.Deprecated('Use recordDelayRequestDescriptor instead')
const RecordDelayRequest$json = {
  '1': 'RecordDelayRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'reason',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.DelayReason',
      '10': 'reason'
    },
    {'1': 'dependency', '3': 3, '4': 1, '5': 9, '10': 'dependency'},
    {'1': 'minutes', '3': 4, '4': 1, '5': 5, '10': 'minutes'},
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordDelayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDelayRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmREZWxheVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjoKBnJlYXNvbh'
    'gCIAEoDjIiLmhlYWx0aGNhcmUudGhlYXRyZS52MS5EZWxheVJlYXNvblIGcmVhc29uEh4KCmRl'
    'cGVuZGVuY3kYAyABKAlSCmRlcGVuZGVuY3kSGAoHbWludXRlcxgEIAEoBVIHbWludXRlcxISCg'
    'Rub3RlGAUgASgJUgRub3Rl');

@$core.Deprecated('Use recordDelayResponseDescriptor instead')
const RecordDelayResponse$json = {
  '1': 'RecordDelayResponse',
  '2': [
    {
      '1': 'delay',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Delay',
      '10': 'delay'
    },
  ],
};

/// Descriptor for `RecordDelayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDelayResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmREZWxheVJlc3BvbnNlEjIKBWRlbGF5GAEgASgLMhwuaGVhbHRoY2FyZS50aGVhdH'
    'JlLnYxLkRlbGF5UgVkZWxheQ==');

@$core.Deprecated('Use writeOperativeNoteRequestDescriptor instead')
const WriteOperativeNoteRequest$json = {
  '1': 'WriteOperativeNoteRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'procedure_performed',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'procedurePerformed'
    },
    {'1': 'findings', '3': 3, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'specimen_ids', '3': 4, '4': 3, '5': 9, '10': 'specimenIds'},
    {'1': 'implant_ids', '3': 5, '4': 3, '5': 9, '10': 'implantIds'},
    {'1': 'complications', '3': 6, '4': 3, '5': 9, '10': 'complications'},
    {
      '1': 'estimated_blood_loss_ml',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'estimatedBloodLossMl'
    },
    {
      '1': 'post_operative_orders',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'postOperativeOrders'
    },
    {'1': 'narrative', '3': 9, '4': 1, '5': 9, '10': 'narrative'},
  ],
};

/// Descriptor for `WriteOperativeNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeOperativeNoteRequestDescriptor = $convert.base64Decode(
    'ChlXcml0ZU9wZXJhdGl2ZU5vdGVSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIvCh'
    'Nwcm9jZWR1cmVfcGVyZm9ybWVkGAIgASgJUhJwcm9jZWR1cmVQZXJmb3JtZWQSGgoIZmluZGlu'
    'Z3MYAyABKAlSCGZpbmRpbmdzEiEKDHNwZWNpbWVuX2lkcxgEIAMoCVILc3BlY2ltZW5JZHMSHw'
    'oLaW1wbGFudF9pZHMYBSADKAlSCmltcGxhbnRJZHMSJAoNY29tcGxpY2F0aW9ucxgGIAMoCVIN'
    'Y29tcGxpY2F0aW9ucxI1Chdlc3RpbWF0ZWRfYmxvb2RfbG9zc19tbBgHIAEoBVIUZXN0aW1hdG'
    'VkQmxvb2RMb3NzTWwSMgoVcG9zdF9vcGVyYXRpdmVfb3JkZXJzGAggASgJUhNwb3N0T3BlcmF0'
    'aXZlT3JkZXJzEhwKCW5hcnJhdGl2ZRgJIAEoCVIJbmFycmF0aXZl');

@$core.Deprecated('Use writeOperativeNoteResponseDescriptor instead')
const WriteOperativeNoteResponse$json = {
  '1': 'WriteOperativeNoteResponse',
  '2': [
    {
      '1': 'note',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.OperativeNote',
      '10': 'note'
    },
  ],
};

/// Descriptor for `WriteOperativeNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeOperativeNoteResponseDescriptor =
    $convert.base64Decode(
        'ChpXcml0ZU9wZXJhdGl2ZU5vdGVSZXNwb25zZRI4CgRub3RlGAEgASgLMiQuaGVhbHRoY2FyZS'
        '50aGVhdHJlLnYxLk9wZXJhdGl2ZU5vdGVSBG5vdGU=');

@$core.Deprecated('Use signOperativeNoteRequestDescriptor instead')
const SignOperativeNoteRequest$json = {
  '1': 'SignOperativeNoteRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'note_id', '3': 2, '4': 1, '5': 9, '10': 'noteId'},
  ],
};

/// Descriptor for `SignOperativeNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOperativeNoteRequestDescriptor =
    $convert.base64Decode(
        'ChhTaWduT3BlcmF0aXZlTm90ZVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEhcKB2'
        '5vdGVfaWQYAiABKAlSBm5vdGVJZA==');

@$core.Deprecated('Use signOperativeNoteResponseDescriptor instead')
const SignOperativeNoteResponse$json = {
  '1': 'SignOperativeNoteResponse',
};

/// Descriptor for `SignOperativeNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signOperativeNoteResponseDescriptor =
    $convert.base64Decode('ChlTaWduT3BlcmF0aXZlTm90ZVJlc3BvbnNl');

@$core.Deprecated('Use amendOperativeNoteRequestDescriptor instead')
const AmendOperativeNoteRequest$json = {
  '1': 'AmendOperativeNoteRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'note_id', '3': 2, '4': 1, '5': 9, '10': 'noteId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'procedure_performed',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'procedurePerformed'
    },
    {'1': 'findings', '3': 5, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'specimen_ids', '3': 6, '4': 3, '5': 9, '10': 'specimenIds'},
    {'1': 'implant_ids', '3': 7, '4': 3, '5': 9, '10': 'implantIds'},
    {'1': 'complications', '3': 8, '4': 3, '5': 9, '10': 'complications'},
    {
      '1': 'estimated_blood_loss_ml',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'estimatedBloodLossMl'
    },
    {
      '1': 'post_operative_orders',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'postOperativeOrders'
    },
    {'1': 'narrative', '3': 11, '4': 1, '5': 9, '10': 'narrative'},
  ],
};

/// Descriptor for `AmendOperativeNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendOperativeNoteRequestDescriptor = $convert.base64Decode(
    'ChlBbWVuZE9wZXJhdGl2ZU5vdGVSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIXCg'
    'dub3RlX2lkGAIgASgJUgZub3RlSWQSFgoGcmVhc29uGAMgASgJUgZyZWFzb24SLwoTcHJvY2Vk'
    'dXJlX3BlcmZvcm1lZBgEIAEoCVIScHJvY2VkdXJlUGVyZm9ybWVkEhoKCGZpbmRpbmdzGAUgAS'
    'gJUghmaW5kaW5ncxIhCgxzcGVjaW1lbl9pZHMYBiADKAlSC3NwZWNpbWVuSWRzEh8KC2ltcGxh'
    'bnRfaWRzGAcgAygJUgppbXBsYW50SWRzEiQKDWNvbXBsaWNhdGlvbnMYCCADKAlSDWNvbXBsaW'
    'NhdGlvbnMSNQoXZXN0aW1hdGVkX2Jsb29kX2xvc3NfbWwYCSABKAVSFGVzdGltYXRlZEJsb29k'
    'TG9zc01sEjIKFXBvc3Rfb3BlcmF0aXZlX29yZGVycxgKIAEoCVITcG9zdE9wZXJhdGl2ZU9yZG'
    'VycxIcCgluYXJyYXRpdmUYCyABKAlSCW5hcnJhdGl2ZQ==');

@$core.Deprecated('Use amendOperativeNoteResponseDescriptor instead')
const AmendOperativeNoteResponse$json = {
  '1': 'AmendOperativeNoteResponse',
  '2': [
    {
      '1': 'note',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.OperativeNote',
      '10': 'note'
    },
  ],
};

/// Descriptor for `AmendOperativeNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendOperativeNoteResponseDescriptor =
    $convert.base64Decode(
        'ChpBbWVuZE9wZXJhdGl2ZU5vdGVSZXNwb25zZRI4CgRub3RlGAEgASgLMiQuaGVhbHRoY2FyZS'
        '50aGVhdHJlLnYxLk9wZXJhdGl2ZU5vdGVSBG5vdGU=');

@$core.Deprecated('Use recordUsageRequestDescriptor instead')
const RecordUsageRequest$json = {
  '1': 'RecordUsageRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.theatre.v1.UsageKind',
      '10': 'kind'
    },
    {'1': 'item_code', '3': 3, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'item_name', '3': 4, '4': 1, '5': 9, '10': 'itemName'},
    {'1': 'lot_number', '3': 5, '4': 1, '5': 9, '10': 'lotNumber'},
    {'1': 'serial_number', '3': 6, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'quantity', '3': 7, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'expiry_date',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiryDate'
    },
    {'1': 'scanned', '3': 9, '4': 1, '5': 8, '10': 'scanned'},
    {'1': 'scan_data', '3': 10, '4': 1, '5': 9, '10': 'scanData'},
  ],
};

/// Descriptor for `RecordUsageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordUsageRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRVc2FnZVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjQKBGtpbmQYAi'
    'ABKA4yIC5oZWFsdGhjYXJlLnRoZWF0cmUudjEuVXNhZ2VLaW5kUgRraW5kEhsKCWl0ZW1fY29k'
    'ZRgDIAEoCVIIaXRlbUNvZGUSGwoJaXRlbV9uYW1lGAQgASgJUghpdGVtTmFtZRIdCgpsb3Rfbn'
    'VtYmVyGAUgASgJUglsb3ROdW1iZXISIwoNc2VyaWFsX251bWJlchgGIAEoCVIMc2VyaWFsTnVt'
    'YmVyEhoKCHF1YW50aXR5GAcgASgFUghxdWFudGl0eRI7CgtleHBpcnlfZGF0ZRgIIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmV4cGlyeURhdGUSGAoHc2Nhbm5lZBgJIAEoCFIH'
    'c2Nhbm5lZBIbCglzY2FuX2RhdGEYCiABKAlSCHNjYW5EYXRh');

@$core.Deprecated('Use recordUsageResponseDescriptor instead')
const RecordUsageResponse$json = {
  '1': 'RecordUsageResponse',
  '2': [
    {
      '1': 'usage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Usage',
      '10': 'usage'
    },
  ],
};

/// Descriptor for `RecordUsageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordUsageResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRVc2FnZVJlc3BvbnNlEjIKBXVzYWdlGAEgASgLMhwuaGVhbHRoY2FyZS50aGVhdH'
    'JlLnYxLlVzYWdlUgV1c2FnZQ==');

@$core.Deprecated('Use recallImplantRequestDescriptor instead')
const RecallImplantRequest$json = {
  '1': 'RecallImplantRequest',
  '2': [
    {'1': 'item_code', '3': 1, '4': 1, '5': 9, '10': 'itemCode'},
    {'1': 'lot_number', '3': 2, '4': 1, '5': 9, '10': 'lotNumber'},
  ],
};

/// Descriptor for `RecallImplantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recallImplantRequestDescriptor = $convert.base64Decode(
    'ChRSZWNhbGxJbXBsYW50UmVxdWVzdBIbCglpdGVtX2NvZGUYASABKAlSCGl0ZW1Db2RlEh0KCm'
    'xvdF9udW1iZXIYAiABKAlSCWxvdE51bWJlcg==');

@$core.Deprecated('Use recallImplantResponseDescriptor instead')
const RecallImplantResponse$json = {
  '1': 'RecallImplantResponse',
  '2': [
    {
      '1': 'recipients',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Recipient',
      '10': 'recipients'
    },
  ],
};

/// Descriptor for `RecallImplantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recallImplantResponseDescriptor = $convert.base64Decode(
    'ChVSZWNhbGxJbXBsYW50UmVzcG9uc2USQAoKcmVjaXBpZW50cxgBIAMoCzIgLmhlYWx0aGNhcm'
    'UudGhlYXRyZS52MS5SZWNpcGllbnRSCnJlY2lwaWVudHM=');

@$core.Deprecated('Use takeSpecimenRequestDescriptor instead')
const TakeSpecimenRequest$json = {
  '1': 'TakeSpecimenRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'site', '3': 3, '4': 1, '5': 9, '10': 'site'},
    {'1': 'container', '3': 4, '4': 1, '5': 9, '10': 'container'},
    {'1': 'fixative', '3': 5, '4': 1, '5': 9, '10': 'fixative'},
    {
      '1': 'taken_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'takenAt'
    },
  ],
};

/// Descriptor for `TakeSpecimenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List takeSpecimenRequestDescriptor = $convert.base64Decode(
    'ChNUYWtlU3BlY2ltZW5SZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIUCgVsYWJlbB'
    'gCIAEoCVIFbGFiZWwSEgoEc2l0ZRgDIAEoCVIEc2l0ZRIcCgljb250YWluZXIYBCABKAlSCWNv'
    'bnRhaW5lchIaCghmaXhhdGl2ZRgFIAEoCVIIZml4YXRpdmUSNQoIdGFrZW5fYXQYBiABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgd0YWtlbkF0');

@$core.Deprecated('Use takeSpecimenResponseDescriptor instead')
const TakeSpecimenResponse$json = {
  '1': 'TakeSpecimenResponse',
  '2': [
    {
      '1': 'specimen',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Specimen',
      '10': 'specimen'
    },
  ],
};

/// Descriptor for `TakeSpecimenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List takeSpecimenResponseDescriptor = $convert.base64Decode(
    'ChRUYWtlU3BlY2ltZW5SZXNwb25zZRI7CghzcGVjaW1lbhgBIAEoCzIfLmhlYWx0aGNhcmUudG'
    'hlYXRyZS52MS5TcGVjaW1lblIIc3BlY2ltZW4=');

@$core.Deprecated('Use accessionSpecimenRequestDescriptor instead')
const AccessionSpecimenRequest$json = {
  '1': 'AccessionSpecimenRequest',
  '2': [
    {'1': 'specimen_id', '3': 1, '4': 1, '5': 9, '10': 'specimenId'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `AccessionSpecimenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessionSpecimenRequestDescriptor =
    $convert.base64Decode(
        'ChhBY2Nlc3Npb25TcGVjaW1lblJlcXVlc3QSHwoLc3BlY2ltZW5faWQYASABKAlSCnNwZWNpbW'
        'VuSWQSGQoIb3JkZXJfaWQYAiABKAlSB29yZGVySWQ=');

@$core.Deprecated('Use accessionSpecimenResponseDescriptor instead')
const AccessionSpecimenResponse$json = {
  '1': 'AccessionSpecimenResponse',
};

/// Descriptor for `AccessionSpecimenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List accessionSpecimenResponseDescriptor =
    $convert.base64Decode('ChlBY2Nlc3Npb25TcGVjaW1lblJlc3BvbnNl');

@$core.Deprecated('Use listOutstandingSpecimensRequestDescriptor instead')
const ListOutstandingSpecimensRequest$json = {
  '1': 'ListOutstandingSpecimensRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOutstandingSpecimensRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingSpecimensRequestDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0T3V0c3RhbmRpbmdTcGVjaW1lbnNSZXF1ZXN0Eh8KC2ZhY2lsaXR5X2lkGAEgASgJUg'
        'pmYWNpbGl0eUlkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listOutstandingSpecimensResponseDescriptor instead')
const ListOutstandingSpecimensResponse$json = {
  '1': 'ListOutstandingSpecimensResponse',
  '2': [
    {
      '1': 'specimens',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Specimen',
      '10': 'specimens'
    },
  ],
};

/// Descriptor for `ListOutstandingSpecimensResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingSpecimensResponseDescriptor =
    $convert.base64Decode(
        'CiBMaXN0T3V0c3RhbmRpbmdTcGVjaW1lbnNSZXNwb25zZRI9CglzcGVjaW1lbnMYASADKAsyHy'
        '5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU3BlY2ltZW5SCXNwZWNpbWVucw==');

@$core.Deprecated('Use openTrayRequestDescriptor instead')
const OpenTrayRequest$json = {
  '1': 'OpenTrayRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'tray_id', '3': 2, '4': 1, '5': 9, '10': 'trayId'},
    {'1': 'tray_name', '3': 3, '4': 1, '5': 9, '10': 'trayName'},
    {'1': 'cycle_id', '3': 4, '4': 1, '5': 9, '10': 'cycleId'},
    {'1': 'indicator_passed', '3': 5, '4': 1, '5': 8, '10': 'indicatorPassed'},
    {'1': 'indicator_note', '3': 6, '4': 1, '5': 9, '10': 'indicatorNote'},
  ],
};

/// Descriptor for `OpenTrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openTrayRequestDescriptor = $convert.base64Decode(
    'Cg9PcGVuVHJheVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEhcKB3RyYXlfaWQYAi'
    'ABKAlSBnRyYXlJZBIbCgl0cmF5X25hbWUYAyABKAlSCHRyYXlOYW1lEhkKCGN5Y2xlX2lkGAQg'
    'ASgJUgdjeWNsZUlkEikKEGluZGljYXRvcl9wYXNzZWQYBSABKAhSD2luZGljYXRvclBhc3NlZB'
    'IlCg5pbmRpY2F0b3Jfbm90ZRgGIAEoCVINaW5kaWNhdG9yTm90ZQ==');

@$core.Deprecated('Use openTrayResponseDescriptor instead')
const OpenTrayResponse$json = {
  '1': 'OpenTrayResponse',
  '2': [
    {
      '1': 'tray_use',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.TrayUse',
      '10': 'trayUse'
    },
  ],
};

/// Descriptor for `OpenTrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openTrayResponseDescriptor = $convert.base64Decode(
    'ChBPcGVuVHJheVJlc3BvbnNlEjkKCHRyYXlfdXNlGAEgASgLMh4uaGVhbHRoY2FyZS50aGVhdH'
    'JlLnYxLlRyYXlVc2VSB3RyYXlVc2U=');

@$core.Deprecated('Use traceCycleRequestDescriptor instead')
const TraceCycleRequest$json = {
  '1': 'TraceCycleRequest',
  '2': [
    {'1': 'cycle_id', '3': 1, '4': 1, '5': 9, '10': 'cycleId'},
  ],
};

/// Descriptor for `TraceCycleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceCycleRequestDescriptor = $convert.base64Decode(
    'ChFUcmFjZUN5Y2xlUmVxdWVzdBIZCghjeWNsZV9pZBgBIAEoCVIHY3ljbGVJZA==');

@$core.Deprecated('Use traceCycleResponseDescriptor instead')
const TraceCycleResponse$json = {
  '1': 'TraceCycleResponse',
  '2': [
    {
      '1': 'recipients',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.Recipient',
      '10': 'recipients'
    },
  ],
};

/// Descriptor for `TraceCycleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceCycleResponseDescriptor = $convert.base64Decode(
    'ChJUcmFjZUN5Y2xlUmVzcG9uc2USQAoKcmVjaXBpZW50cxgBIAMoCzIgLmhlYWx0aGNhcmUudG'
    'hlYXRyZS52MS5SZWNpcGllbnRSCnJlY2lwaWVudHM=');

@$core.Deprecated('Use savePreferenceCardRequestDescriptor instead')
const SavePreferenceCardRequest$json = {
  '1': 'SavePreferenceCardRequest',
  '2': [
    {'1': 'surgeon_id', '3': 1, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'procedure_code', '3': 2, '4': 1, '5': 9, '10': 'procedureCode'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'equipment', '3': 4, '4': 3, '5': 9, '10': 'equipment'},
    {
      '1': 'consumables',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.CardItem',
      '10': 'consumables'
    },
    {'1': 'trays', '3': 6, '4': 3, '5': 9, '10': 'trays'},
    {'1': 'notes', '3': 7, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `SavePreferenceCardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savePreferenceCardRequestDescriptor = $convert.base64Decode(
    'ChlTYXZlUHJlZmVyZW5jZUNhcmRSZXF1ZXN0Eh0KCnN1cmdlb25faWQYASABKAlSCXN1cmdlb2'
    '5JZBIlCg5wcm9jZWR1cmVfY29kZRgCIAEoCVINcHJvY2VkdXJlQ29kZRISCgRuYW1lGAMgASgJ'
    'UgRuYW1lEhwKCWVxdWlwbWVudBgEIAMoCVIJZXF1aXBtZW50EkEKC2NvbnN1bWFibGVzGAUgAy'
    'gLMh8uaGVhbHRoY2FyZS50aGVhdHJlLnYxLkNhcmRJdGVtUgtjb25zdW1hYmxlcxIUCgV0cmF5'
    'cxgGIAMoCVIFdHJheXMSFAoFbm90ZXMYByABKAlSBW5vdGVz');

@$core.Deprecated('Use savePreferenceCardResponseDescriptor instead')
const SavePreferenceCardResponse$json = {
  '1': 'SavePreferenceCardResponse',
  '2': [
    {
      '1': 'card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.PreferenceCard',
      '10': 'card'
    },
  ],
};

/// Descriptor for `SavePreferenceCardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List savePreferenceCardResponseDescriptor =
    $convert.base64Decode(
        'ChpTYXZlUHJlZmVyZW5jZUNhcmRSZXNwb25zZRI5CgRjYXJkGAEgASgLMiUuaGVhbHRoY2FyZS'
        '50aGVhdHJlLnYxLlByZWZlcmVuY2VDYXJkUgRjYXJk');

@$core.Deprecated('Use getPreferenceCardRequestDescriptor instead')
const GetPreferenceCardRequest$json = {
  '1': 'GetPreferenceCardRequest',
  '2': [
    {'1': 'surgeon_id', '3': 1, '4': 1, '5': 9, '10': 'surgeonId'},
    {'1': 'procedure_code', '3': 2, '4': 1, '5': 9, '10': 'procedureCode'},
  ],
};

/// Descriptor for `GetPreferenceCardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPreferenceCardRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRQcmVmZXJlbmNlQ2FyZFJlcXVlc3QSHQoKc3VyZ2Vvbl9pZBgBIAEoCVIJc3VyZ2Vvbk'
        'lkEiUKDnByb2NlZHVyZV9jb2RlGAIgASgJUg1wcm9jZWR1cmVDb2Rl');

@$core.Deprecated('Use getPreferenceCardResponseDescriptor instead')
const GetPreferenceCardResponse$json = {
  '1': 'GetPreferenceCardResponse',
  '2': [
    {
      '1': 'card',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.PreferenceCard',
      '10': 'card'
    },
    {'1': 'found', '3': 2, '4': 1, '5': 8, '10': 'found'},
  ],
};

/// Descriptor for `GetPreferenceCardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPreferenceCardResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRQcmVmZXJlbmNlQ2FyZFJlc3BvbnNlEjkKBGNhcmQYASABKAsyJS5oZWFsdGhjYXJlLn'
        'RoZWF0cmUudjEuUHJlZmVyZW5jZUNhcmRSBGNhcmQSFAoFZm91bmQYAiABKAhSBWZvdW5k');

@$core.Deprecated('Use getBoardRequestDescriptor instead')
const GetBoardRequest$json = {
  '1': 'GetBoardRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCb2FyZFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getBoardResponseDescriptor instead')
const GetBoardResponse$json = {
  '1': 'GetBoardResponse',
  '2': [
    {
      '1': 'rows',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.theatre.v1.BoardRow',
      '10': 'rows'
    },
  ],
};

/// Descriptor for `GetBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCb2FyZFJlc3BvbnNlEjMKBHJvd3MYASADKAsyHy5oZWFsdGhjYXJlLnRoZWF0cmUudj'
    'EuQm9hcmRSb3dSBHJvd3M=');

@$core.Deprecated('Use getUtilisationRequestDescriptor instead')
const GetUtilisationRequest$json = {
  '1': 'GetUtilisationRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
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

/// Descriptor for `GetUtilisationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUtilisationRequestDescriptor = $convert.base64Decode(
    'ChVHZXRVdGlsaXNhdGlvblJlcXVlc3QSFwoHcm9vbV9pZBgBIAEoCVIGcm9vbUlkEi4KBGZyb2'
    '0YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAMgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getUtilisationResponseDescriptor instead')
const GetUtilisationResponse$json = {
  '1': 'GetUtilisationResponse',
  '2': [
    {
      '1': 'utilisation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.theatre.v1.Utilisation',
      '10': 'utilisation'
    },
  ],
};

/// Descriptor for `GetUtilisationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUtilisationResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRVdGlsaXNhdGlvblJlc3BvbnNlEkQKC3V0aWxpc2F0aW9uGAEgASgLMiIuaGVhbHRoY2'
        'FyZS50aGVhdHJlLnYxLlV0aWxpc2F0aW9uUgt1dGlsaXNhdGlvbg==');

const $core.Map<$core.String, $core.dynamic> TheatreServiceBase$json = {
  '1': 'TheatreService',
  '2': [
    {
      '1': 'SaveRoom',
      '2': '.healthcare.theatre.v1.SaveRoomRequest',
      '3': '.healthcare.theatre.v1.SaveRoomResponse'
    },
    {
      '1': 'ListRooms',
      '2': '.healthcare.theatre.v1.ListRoomsRequest',
      '3': '.healthcare.theatre.v1.ListRoomsResponse'
    },
    {
      '1': 'SaveBlock',
      '2': '.healthcare.theatre.v1.SaveBlockRequest',
      '3': '.healthcare.theatre.v1.SaveBlockResponse'
    },
    {
      '1': 'RequestSurgery',
      '2': '.healthcare.theatre.v1.RequestSurgeryRequest',
      '3': '.healthcare.theatre.v1.RequestSurgeryResponse'
    },
    {
      '1': 'CompleteRequest',
      '2': '.healthcare.theatre.v1.CompleteRequestRequest',
      '3': '.healthcare.theatre.v1.CompleteRequestResponse'
    },
    {
      '1': 'GetSurgicalCase',
      '2': '.healthcare.theatre.v1.GetSurgicalCaseRequest',
      '3': '.healthcare.theatre.v1.GetSurgicalCaseResponse'
    },
    {
      '1': 'Reprioritise',
      '2': '.healthcare.theatre.v1.ReprioritiseRequest',
      '3': '.healthcare.theatre.v1.ReprioritiseResponse'
    },
    {
      '1': 'CheckSlot',
      '2': '.healthcare.theatre.v1.CheckSlotRequest',
      '3': '.healthcare.theatre.v1.CheckSlotResponse'
    },
    {
      '1': 'ScheduleCase',
      '2': '.healthcare.theatre.v1.ScheduleCaseRequest',
      '3': '.healthcare.theatre.v1.ScheduleCaseResponse'
    },
    {
      '1': 'CloseCase',
      '2': '.healthcare.theatre.v1.CloseCaseRequest',
      '3': '.healthcare.theatre.v1.CloseCaseResponse'
    },
    {
      '1': 'ListWaiting',
      '2': '.healthcare.theatre.v1.ListWaitingRequest',
      '3': '.healthcare.theatre.v1.ListWaitingResponse'
    },
    {
      '1': 'RecordPreop',
      '2': '.healthcare.theatre.v1.RecordPreopRequest',
      '3': '.healthcare.theatre.v1.RecordPreopResponse'
    },
    {
      '1': 'ListBlockers',
      '2': '.healthcare.theatre.v1.ListBlockersRequest',
      '3': '.healthcare.theatre.v1.ListBlockersResponse'
    },
    {
      '1': 'PerformSafetyCheck',
      '2': '.healthcare.theatre.v1.PerformSafetyCheckRequest',
      '3': '.healthcare.theatre.v1.PerformSafetyCheckResponse'
    },
    {
      '1': 'RecordMilestone',
      '2': '.healthcare.theatre.v1.RecordMilestoneRequest',
      '3': '.healthcare.theatre.v1.RecordMilestoneResponse'
    },
    {
      '1': 'GetTimeline',
      '2': '.healthcare.theatre.v1.GetTimelineRequest',
      '3': '.healthcare.theatre.v1.GetTimelineResponse'
    },
    {
      '1': 'RecordDelay',
      '2': '.healthcare.theatre.v1.RecordDelayRequest',
      '3': '.healthcare.theatre.v1.RecordDelayResponse'
    },
    {
      '1': 'WriteOperativeNote',
      '2': '.healthcare.theatre.v1.WriteOperativeNoteRequest',
      '3': '.healthcare.theatre.v1.WriteOperativeNoteResponse'
    },
    {
      '1': 'SignOperativeNote',
      '2': '.healthcare.theatre.v1.SignOperativeNoteRequest',
      '3': '.healthcare.theatre.v1.SignOperativeNoteResponse'
    },
    {
      '1': 'AmendOperativeNote',
      '2': '.healthcare.theatre.v1.AmendOperativeNoteRequest',
      '3': '.healthcare.theatre.v1.AmendOperativeNoteResponse'
    },
    {
      '1': 'RecordUsage',
      '2': '.healthcare.theatre.v1.RecordUsageRequest',
      '3': '.healthcare.theatre.v1.RecordUsageResponse'
    },
    {
      '1': 'RecallImplant',
      '2': '.healthcare.theatre.v1.RecallImplantRequest',
      '3': '.healthcare.theatre.v1.RecallImplantResponse'
    },
    {
      '1': 'TakeSpecimen',
      '2': '.healthcare.theatre.v1.TakeSpecimenRequest',
      '3': '.healthcare.theatre.v1.TakeSpecimenResponse'
    },
    {
      '1': 'AccessionSpecimen',
      '2': '.healthcare.theatre.v1.AccessionSpecimenRequest',
      '3': '.healthcare.theatre.v1.AccessionSpecimenResponse'
    },
    {
      '1': 'ListOutstandingSpecimens',
      '2': '.healthcare.theatre.v1.ListOutstandingSpecimensRequest',
      '3': '.healthcare.theatre.v1.ListOutstandingSpecimensResponse'
    },
    {
      '1': 'OpenTray',
      '2': '.healthcare.theatre.v1.OpenTrayRequest',
      '3': '.healthcare.theatre.v1.OpenTrayResponse'
    },
    {
      '1': 'TraceCycle',
      '2': '.healthcare.theatre.v1.TraceCycleRequest',
      '3': '.healthcare.theatre.v1.TraceCycleResponse'
    },
    {
      '1': 'SavePreferenceCard',
      '2': '.healthcare.theatre.v1.SavePreferenceCardRequest',
      '3': '.healthcare.theatre.v1.SavePreferenceCardResponse'
    },
    {
      '1': 'GetPreferenceCard',
      '2': '.healthcare.theatre.v1.GetPreferenceCardRequest',
      '3': '.healthcare.theatre.v1.GetPreferenceCardResponse'
    },
    {
      '1': 'GetBoard',
      '2': '.healthcare.theatre.v1.GetBoardRequest',
      '3': '.healthcare.theatre.v1.GetBoardResponse'
    },
    {
      '1': 'GetUtilisation',
      '2': '.healthcare.theatre.v1.GetUtilisationRequest',
      '3': '.healthcare.theatre.v1.GetUtilisationResponse'
    },
  ],
};

@$core.Deprecated('Use theatreServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TheatreServiceBase$messageJson = {
  '.healthcare.theatre.v1.SaveRoomRequest': SaveRoomRequest$json,
  '.healthcare.theatre.v1.SaveRoomResponse': SaveRoomResponse$json,
  '.healthcare.theatre.v1.Room': Room$json,
  '.healthcare.theatre.v1.ListRoomsRequest': ListRoomsRequest$json,
  '.healthcare.theatre.v1.ListRoomsResponse': ListRoomsResponse$json,
  '.healthcare.theatre.v1.SaveBlockRequest': SaveBlockRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.theatre.v1.SaveBlockResponse': SaveBlockResponse$json,
  '.healthcare.theatre.v1.Block': Block$json,
  '.healthcare.theatre.v1.RequestSurgeryRequest': RequestSurgeryRequest$json,
  '.healthcare.theatre.v1.RequestSurgeryResponse': RequestSurgeryResponse$json,
  '.healthcare.theatre.v1.SurgicalCase': SurgicalCase$json,
  '.healthcare.theatre.v1.CompleteRequestRequest': CompleteRequestRequest$json,
  '.healthcare.theatre.v1.CompleteRequestResponse':
      CompleteRequestResponse$json,
  '.healthcare.theatre.v1.GetSurgicalCaseRequest': GetSurgicalCaseRequest$json,
  '.healthcare.theatre.v1.GetSurgicalCaseResponse':
      GetSurgicalCaseResponse$json,
  '.healthcare.theatre.v1.PreopEntry': PreopEntry$json,
  '.healthcare.theatre.v1.Blocker': Blocker$json,
  '.healthcare.theatre.v1.SafetyCheck': SafetyCheck$json,
  '.healthcare.theatre.v1.SafetyAnswer': SafetyAnswer$json,
  '.healthcare.theatre.v1.MilestoneRecord': MilestoneRecord$json,
  '.healthcare.theatre.v1.CaseIntervals': CaseIntervals$json,
  '.healthcare.theatre.v1.Delay': Delay$json,
  '.healthcare.theatre.v1.OperativeNote': OperativeNote$json,
  '.healthcare.theatre.v1.Usage': Usage$json,
  '.healthcare.theatre.v1.Specimen': Specimen$json,
  '.healthcare.theatre.v1.TrayUse': TrayUse$json,
  '.healthcare.theatre.v1.ReprioritiseRequest': ReprioritiseRequest$json,
  '.healthcare.theatre.v1.ReprioritiseResponse': ReprioritiseResponse$json,
  '.healthcare.theatre.v1.CheckSlotRequest': CheckSlotRequest$json,
  '.healthcare.theatre.v1.CheckSlotResponse': CheckSlotResponse$json,
  '.healthcare.theatre.v1.ScheduleConflict': ScheduleConflict$json,
  '.healthcare.theatre.v1.ScheduleCaseRequest': ScheduleCaseRequest$json,
  '.healthcare.theatre.v1.ScheduleCaseResponse': ScheduleCaseResponse$json,
  '.healthcare.theatre.v1.CloseCaseRequest': CloseCaseRequest$json,
  '.healthcare.theatre.v1.CloseCaseResponse': CloseCaseResponse$json,
  '.healthcare.theatre.v1.ListWaitingRequest': ListWaitingRequest$json,
  '.healthcare.theatre.v1.ListWaitingResponse': ListWaitingResponse$json,
  '.healthcare.theatre.v1.RecordPreopRequest': RecordPreopRequest$json,
  '.healthcare.theatre.v1.RecordPreopResponse': RecordPreopResponse$json,
  '.healthcare.theatre.v1.ListBlockersRequest': ListBlockersRequest$json,
  '.healthcare.theatre.v1.ListBlockersResponse': ListBlockersResponse$json,
  '.healthcare.theatre.v1.PerformSafetyCheckRequest':
      PerformSafetyCheckRequest$json,
  '.healthcare.theatre.v1.PerformSafetyCheckResponse':
      PerformSafetyCheckResponse$json,
  '.healthcare.theatre.v1.RecordMilestoneRequest': RecordMilestoneRequest$json,
  '.healthcare.theatre.v1.RecordMilestoneResponse':
      RecordMilestoneResponse$json,
  '.healthcare.theatre.v1.GetTimelineRequest': GetTimelineRequest$json,
  '.healthcare.theatre.v1.GetTimelineResponse': GetTimelineResponse$json,
  '.healthcare.theatre.v1.RecordDelayRequest': RecordDelayRequest$json,
  '.healthcare.theatre.v1.RecordDelayResponse': RecordDelayResponse$json,
  '.healthcare.theatre.v1.WriteOperativeNoteRequest':
      WriteOperativeNoteRequest$json,
  '.healthcare.theatre.v1.WriteOperativeNoteResponse':
      WriteOperativeNoteResponse$json,
  '.healthcare.theatre.v1.SignOperativeNoteRequest':
      SignOperativeNoteRequest$json,
  '.healthcare.theatre.v1.SignOperativeNoteResponse':
      SignOperativeNoteResponse$json,
  '.healthcare.theatre.v1.AmendOperativeNoteRequest':
      AmendOperativeNoteRequest$json,
  '.healthcare.theatre.v1.AmendOperativeNoteResponse':
      AmendOperativeNoteResponse$json,
  '.healthcare.theatre.v1.RecordUsageRequest': RecordUsageRequest$json,
  '.healthcare.theatre.v1.RecordUsageResponse': RecordUsageResponse$json,
  '.healthcare.theatre.v1.RecallImplantRequest': RecallImplantRequest$json,
  '.healthcare.theatre.v1.RecallImplantResponse': RecallImplantResponse$json,
  '.healthcare.theatre.v1.Recipient': Recipient$json,
  '.healthcare.theatre.v1.TakeSpecimenRequest': TakeSpecimenRequest$json,
  '.healthcare.theatre.v1.TakeSpecimenResponse': TakeSpecimenResponse$json,
  '.healthcare.theatre.v1.AccessionSpecimenRequest':
      AccessionSpecimenRequest$json,
  '.healthcare.theatre.v1.AccessionSpecimenResponse':
      AccessionSpecimenResponse$json,
  '.healthcare.theatre.v1.ListOutstandingSpecimensRequest':
      ListOutstandingSpecimensRequest$json,
  '.healthcare.theatre.v1.ListOutstandingSpecimensResponse':
      ListOutstandingSpecimensResponse$json,
  '.healthcare.theatre.v1.OpenTrayRequest': OpenTrayRequest$json,
  '.healthcare.theatre.v1.OpenTrayResponse': OpenTrayResponse$json,
  '.healthcare.theatre.v1.TraceCycleRequest': TraceCycleRequest$json,
  '.healthcare.theatre.v1.TraceCycleResponse': TraceCycleResponse$json,
  '.healthcare.theatre.v1.SavePreferenceCardRequest':
      SavePreferenceCardRequest$json,
  '.healthcare.theatre.v1.CardItem': CardItem$json,
  '.healthcare.theatre.v1.SavePreferenceCardResponse':
      SavePreferenceCardResponse$json,
  '.healthcare.theatre.v1.PreferenceCard': PreferenceCard$json,
  '.healthcare.theatre.v1.GetPreferenceCardRequest':
      GetPreferenceCardRequest$json,
  '.healthcare.theatre.v1.GetPreferenceCardResponse':
      GetPreferenceCardResponse$json,
  '.healthcare.theatre.v1.GetBoardRequest': GetBoardRequest$json,
  '.healthcare.theatre.v1.GetBoardResponse': GetBoardResponse$json,
  '.healthcare.theatre.v1.BoardRow': BoardRow$json,
  '.healthcare.theatre.v1.GetUtilisationRequest': GetUtilisationRequest$json,
  '.healthcare.theatre.v1.GetUtilisationResponse': GetUtilisationResponse$json,
  '.healthcare.theatre.v1.Utilisation': Utilisation$json,
  '.healthcare.theatre.v1.CauseCount': CauseCount$json,
  '.healthcare.theatre.v1.DelayCount': DelayCount$json,
};

/// Descriptor for `TheatreService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List theatreServiceDescriptor = $convert.base64Decode(
    'Cg5UaGVhdHJlU2VydmljZRJbCghTYXZlUm9vbRImLmhlYWx0aGNhcmUudGhlYXRyZS52MS5TYX'
    'ZlUm9vbVJlcXVlc3QaJy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2F2ZVJvb21SZXNwb25zZRJe'
    'CglMaXN0Um9vbXMSJy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuTGlzdFJvb21zUmVxdWVzdBooLm'
    'hlYWx0aGNhcmUudGhlYXRyZS52MS5MaXN0Um9vbXNSZXNwb25zZRJeCglTYXZlQmxvY2sSJy5o'
    'ZWFsdGhjYXJlLnRoZWF0cmUudjEuU2F2ZUJsb2NrUmVxdWVzdBooLmhlYWx0aGNhcmUudGhlYX'
    'RyZS52MS5TYXZlQmxvY2tSZXNwb25zZRJtCg5SZXF1ZXN0U3VyZ2VyeRIsLmhlYWx0aGNhcmUu'
    'dGhlYXRyZS52MS5SZXF1ZXN0U3VyZ2VyeVJlcXVlc3QaLS5oZWFsdGhjYXJlLnRoZWF0cmUudj'
    'EuUmVxdWVzdFN1cmdlcnlSZXNwb25zZRJwCg9Db21wbGV0ZVJlcXVlc3QSLS5oZWFsdGhjYXJl'
    'LnRoZWF0cmUudjEuQ29tcGxldGVSZXF1ZXN0UmVxdWVzdBouLmhlYWx0aGNhcmUudGhlYXRyZS'
    '52MS5Db21wbGV0ZVJlcXVlc3RSZXNwb25zZRJwCg9HZXRTdXJnaWNhbENhc2USLS5oZWFsdGhj'
    'YXJlLnRoZWF0cmUudjEuR2V0U3VyZ2ljYWxDYXNlUmVxdWVzdBouLmhlYWx0aGNhcmUudGhlYX'
    'RyZS52MS5HZXRTdXJnaWNhbENhc2VSZXNwb25zZRJnCgxSZXByaW9yaXRpc2USKi5oZWFsdGhj'
    'YXJlLnRoZWF0cmUudjEuUmVwcmlvcml0aXNlUmVxdWVzdBorLmhlYWx0aGNhcmUudGhlYXRyZS'
    '52MS5SZXByaW9yaXRpc2VSZXNwb25zZRJeCglDaGVja1Nsb3QSJy5oZWFsdGhjYXJlLnRoZWF0'
    'cmUudjEuQ2hlY2tTbG90UmVxdWVzdBooLmhlYWx0aGNhcmUudGhlYXRyZS52MS5DaGVja1Nsb3'
    'RSZXNwb25zZRJnCgxTY2hlZHVsZUNhc2USKi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2NoZWR1'
    'bGVDYXNlUmVxdWVzdBorLmhlYWx0aGNhcmUudGhlYXRyZS52MS5TY2hlZHVsZUNhc2VSZXNwb2'
    '5zZRJeCglDbG9zZUNhc2USJy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuQ2xvc2VDYXNlUmVxdWVz'
    'dBooLmhlYWx0aGNhcmUudGhlYXRyZS52MS5DbG9zZUNhc2VSZXNwb25zZRJkCgtMaXN0V2FpdG'
    'luZxIpLmhlYWx0aGNhcmUudGhlYXRyZS52MS5MaXN0V2FpdGluZ1JlcXVlc3QaKi5oZWFsdGhj'
    'YXJlLnRoZWF0cmUudjEuTGlzdFdhaXRpbmdSZXNwb25zZRJkCgtSZWNvcmRQcmVvcBIpLmhlYW'
    'x0aGNhcmUudGhlYXRyZS52MS5SZWNvcmRQcmVvcFJlcXVlc3QaKi5oZWFsdGhjYXJlLnRoZWF0'
    'cmUudjEuUmVjb3JkUHJlb3BSZXNwb25zZRJnCgxMaXN0QmxvY2tlcnMSKi5oZWFsdGhjYXJlLn'
    'RoZWF0cmUudjEuTGlzdEJsb2NrZXJzUmVxdWVzdBorLmhlYWx0aGNhcmUudGhlYXRyZS52MS5M'
    'aXN0QmxvY2tlcnNSZXNwb25zZRJ5ChJQZXJmb3JtU2FmZXR5Q2hlY2sSMC5oZWFsdGhjYXJlLn'
    'RoZWF0cmUudjEuUGVyZm9ybVNhZmV0eUNoZWNrUmVxdWVzdBoxLmhlYWx0aGNhcmUudGhlYXRy'
    'ZS52MS5QZXJmb3JtU2FmZXR5Q2hlY2tSZXNwb25zZRJwCg9SZWNvcmRNaWxlc3RvbmUSLS5oZW'
    'FsdGhjYXJlLnRoZWF0cmUudjEuUmVjb3JkTWlsZXN0b25lUmVxdWVzdBouLmhlYWx0aGNhcmUu'
    'dGhlYXRyZS52MS5SZWNvcmRNaWxlc3RvbmVSZXNwb25zZRJkCgtHZXRUaW1lbGluZRIpLmhlYW'
    'x0aGNhcmUudGhlYXRyZS52MS5HZXRUaW1lbGluZVJlcXVlc3QaKi5oZWFsdGhjYXJlLnRoZWF0'
    'cmUudjEuR2V0VGltZWxpbmVSZXNwb25zZRJkCgtSZWNvcmREZWxheRIpLmhlYWx0aGNhcmUudG'
    'hlYXRyZS52MS5SZWNvcmREZWxheVJlcXVlc3QaKi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuUmVj'
    'b3JkRGVsYXlSZXNwb25zZRJ5ChJXcml0ZU9wZXJhdGl2ZU5vdGUSMC5oZWFsdGhjYXJlLnRoZW'
    'F0cmUudjEuV3JpdGVPcGVyYXRpdmVOb3RlUmVxdWVzdBoxLmhlYWx0aGNhcmUudGhlYXRyZS52'
    'MS5Xcml0ZU9wZXJhdGl2ZU5vdGVSZXNwb25zZRJ2ChFTaWduT3BlcmF0aXZlTm90ZRIvLmhlYW'
    'x0aGNhcmUudGhlYXRyZS52MS5TaWduT3BlcmF0aXZlTm90ZVJlcXVlc3QaMC5oZWFsdGhjYXJl'
    'LnRoZWF0cmUudjEuU2lnbk9wZXJhdGl2ZU5vdGVSZXNwb25zZRJ5ChJBbWVuZE9wZXJhdGl2ZU'
    '5vdGUSMC5oZWFsdGhjYXJlLnRoZWF0cmUudjEuQW1lbmRPcGVyYXRpdmVOb3RlUmVxdWVzdBox'
    'LmhlYWx0aGNhcmUudGhlYXRyZS52MS5BbWVuZE9wZXJhdGl2ZU5vdGVSZXNwb25zZRJkCgtSZW'
    'NvcmRVc2FnZRIpLmhlYWx0aGNhcmUudGhlYXRyZS52MS5SZWNvcmRVc2FnZVJlcXVlc3QaKi5o'
    'ZWFsdGhjYXJlLnRoZWF0cmUudjEuUmVjb3JkVXNhZ2VSZXNwb25zZRJqCg1SZWNhbGxJbXBsYW'
    '50EisuaGVhbHRoY2FyZS50aGVhdHJlLnYxLlJlY2FsbEltcGxhbnRSZXF1ZXN0GiwuaGVhbHRo'
    'Y2FyZS50aGVhdHJlLnYxLlJlY2FsbEltcGxhbnRSZXNwb25zZRJnCgxUYWtlU3BlY2ltZW4SKi'
    '5oZWFsdGhjYXJlLnRoZWF0cmUudjEuVGFrZVNwZWNpbWVuUmVxdWVzdBorLmhlYWx0aGNhcmUu'
    'dGhlYXRyZS52MS5UYWtlU3BlY2ltZW5SZXNwb25zZRJ2ChFBY2Nlc3Npb25TcGVjaW1lbhIvLm'
    'hlYWx0aGNhcmUudGhlYXRyZS52MS5BY2Nlc3Npb25TcGVjaW1lblJlcXVlc3QaMC5oZWFsdGhj'
    'YXJlLnRoZWF0cmUudjEuQWNjZXNzaW9uU3BlY2ltZW5SZXNwb25zZRKLAQoYTGlzdE91dHN0YW'
    '5kaW5nU3BlY2ltZW5zEjYuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkxpc3RPdXRzdGFuZGluZ1Nw'
    'ZWNpbWVuc1JlcXVlc3QaNy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuTGlzdE91dHN0YW5kaW5nU3'
    'BlY2ltZW5zUmVzcG9uc2USWwoIT3BlblRyYXkSJi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuT3Bl'
    'blRyYXlSZXF1ZXN0GicuaGVhbHRoY2FyZS50aGVhdHJlLnYxLk9wZW5UcmF5UmVzcG9uc2USYQ'
    'oKVHJhY2VDeWNsZRIoLmhlYWx0aGNhcmUudGhlYXRyZS52MS5UcmFjZUN5Y2xlUmVxdWVzdBop'
    'LmhlYWx0aGNhcmUudGhlYXRyZS52MS5UcmFjZUN5Y2xlUmVzcG9uc2USeQoSU2F2ZVByZWZlcm'
    'VuY2VDYXJkEjAuaGVhbHRoY2FyZS50aGVhdHJlLnYxLlNhdmVQcmVmZXJlbmNlQ2FyZFJlcXVl'
    'c3QaMS5oZWFsdGhjYXJlLnRoZWF0cmUudjEuU2F2ZVByZWZlcmVuY2VDYXJkUmVzcG9uc2USdg'
    'oRR2V0UHJlZmVyZW5jZUNhcmQSLy5oZWFsdGhjYXJlLnRoZWF0cmUudjEuR2V0UHJlZmVyZW5j'
    'ZUNhcmRSZXF1ZXN0GjAuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkdldFByZWZlcmVuY2VDYXJkUm'
    'VzcG9uc2USWwoIR2V0Qm9hcmQSJi5oZWFsdGhjYXJlLnRoZWF0cmUudjEuR2V0Qm9hcmRSZXF1'
    'ZXN0GicuaGVhbHRoY2FyZS50aGVhdHJlLnYxLkdldEJvYXJkUmVzcG9uc2USbQoOR2V0VXRpbG'
    'lzYXRpb24SLC5oZWFsdGhjYXJlLnRoZWF0cmUudjEuR2V0VXRpbGlzYXRpb25SZXF1ZXN0Gi0u'
    'aGVhbHRoY2FyZS50aGVhdHJlLnYxLkdldFV0aWxpc2F0aW9uUmVzcG9uc2U=');
