// This is a generated file - do not edit.
//
// Generated from healthcare/anaesthesia/v1/anaesthesia.proto.

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

@$core.Deprecated('Use techniqueDescriptor instead')
const Technique$json = {
  '1': 'Technique',
  '2': [
    {'1': 'TECHNIQUE_UNSPECIFIED', '2': 0},
    {'1': 'TECHNIQUE_GENERAL', '2': 1},
    {'1': 'TECHNIQUE_REGIONAL', '2': 2},
    {'1': 'TECHNIQUE_SPINAL', '2': 3},
    {'1': 'TECHNIQUE_EPIDURAL', '2': 4},
    {'1': 'TECHNIQUE_SEDATION', '2': 5},
    {'1': 'TECHNIQUE_LOCAL', '2': 6},
    {'1': 'TECHNIQUE_COMBINED', '2': 7},
  ],
};

/// Descriptor for `Technique`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List techniqueDescriptor = $convert.base64Decode(
    'CglUZWNobmlxdWUSGQoVVEVDSE5JUVVFX1VOU1BFQ0lGSUVEEAASFQoRVEVDSE5JUVVFX0dFTk'
    'VSQUwQARIWChJURUNITklRVUVfUkVHSU9OQUwQAhIUChBURUNITklRVUVfU1BJTkFMEAMSFgoS'
    'VEVDSE5JUVVFX0VQSURVUkFMEAQSFgoSVEVDSE5JUVVFX1NFREFUSU9OEAUSEwoPVEVDSE5JUV'
    'VFX0xPQ0FMEAYSFgoSVEVDSE5JUVVFX0NPTUJJTkVEEAc=');

@$core.Deprecated('Use consentStatusDescriptor instead')
const ConsentStatus$json = {
  '1': 'ConsentStatus',
  '2': [
    {'1': 'CONSENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CONSENT_STATUS_OBTAINED', '2': 1},
    {'1': 'CONSENT_STATUS_PENDING', '2': 2},
    {'1': 'CONSENT_STATUS_REFUSED', '2': 3},
    {'1': 'CONSENT_STATUS_NOT_REQUIRED', '2': 4},
  ],
};

/// Descriptor for `ConsentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consentStatusDescriptor = $convert.base64Decode(
    'Cg1Db25zZW50U3RhdHVzEh4KGkNPTlNFTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGwoXQ09OU0'
    'VOVF9TVEFUVVNfT0JUQUlORUQQARIaChZDT05TRU5UX1NUQVRVU19QRU5ESU5HEAISGgoWQ09O'
    'U0VOVF9TVEFUVVNfUkVGVVNFRBADEh8KG0NPTlNFTlRfU1RBVFVTX05PVF9SRVFVSVJFRBAE');

@$core.Deprecated('Use entrySourceDescriptor instead')
const EntrySource$json = {
  '1': 'EntrySource',
  '2': [
    {'1': 'ENTRY_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'ENTRY_SOURCE_MANUAL', '2': 1},
    {'1': 'ENTRY_SOURCE_DEVICE', '2': 2},
    {'1': 'ENTRY_SOURCE_IMPORTED', '2': 3},
  ],
};

/// Descriptor for `EntrySource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entrySourceDescriptor = $convert.base64Decode(
    'CgtFbnRyeVNvdXJjZRIcChhFTlRSWV9TT1VSQ0VfVU5TUEVDSUZJRUQQABIXChNFTlRSWV9TT1'
    'VSQ0VfTUFOVUFMEAESFwoTRU5UUllfU09VUkNFX0RFVklDRRACEhkKFUVOVFJZX1NPVVJDRV9J'
    'TVBPUlRFRBAD');

@$core.Deprecated('Use recordStatusDescriptor instead')
const RecordStatus$json = {
  '1': 'RecordStatus',
  '2': [
    {'1': 'RECORD_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RECORD_STATUS_OPEN', '2': 1},
    {'1': 'RECORD_STATUS_IN_RECOVERY', '2': 2},
    {'1': 'RECORD_STATUS_CLOSED', '2': 3},
  ],
};

/// Descriptor for `RecordStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recordStatusDescriptor = $convert.base64Decode(
    'CgxSZWNvcmRTdGF0dXMSHQoZUkVDT1JEX1NUQVRVU19VTlNQRUNJRklFRBAAEhYKElJFQ09SRF'
    '9TVEFUVVNfT1BFThABEh0KGVJFQ09SRF9TVEFUVVNfSU5fUkVDT1ZFUlkQAhIYChRSRUNPUkRf'
    'U1RBVFVTX0NMT1NFRBAD');

@$core.Deprecated('Use fluidDirectionDescriptor instead')
const FluidDirection$json = {
  '1': 'FluidDirection',
  '2': [
    {'1': 'FLUID_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'FLUID_DIRECTION_IN', '2': 1},
    {'1': 'FLUID_DIRECTION_OUT', '2': 2},
  ],
};

/// Descriptor for `FluidDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fluidDirectionDescriptor = $convert.base64Decode(
    'Cg5GbHVpZERpcmVjdGlvbhIfChtGTFVJRF9ESVJFQ1RJT05fVU5TUEVDSUZJRUQQABIWChJGTF'
    'VJRF9ESVJFQ1RJT05fSU4QARIXChNGTFVJRF9ESVJFQ1RJT05fT1VUEAI=');

@$core.Deprecated('Use dischargeRefusalDescriptor instead')
const DischargeRefusal$json = {
  '1': 'DischargeRefusal',
  '2': [
    {'1': 'DISCHARGE_REFUSAL_UNSPECIFIED', '2': 0},
    {'1': 'DISCHARGE_REFUSAL_NOT_HANDED_OVER', '2': 1},
    {'1': 'DISCHARGE_REFUSAL_NOT_ASSESSED', '2': 2},
    {'1': 'DISCHARGE_REFUSAL_INCOMPLETE_SCORE', '2': 3},
    {'1': 'DISCHARGE_REFUSAL_BELOW_THRESHOLD', '2': 4},
  ],
};

/// Descriptor for `DischargeRefusal`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dischargeRefusalDescriptor = $convert.base64Decode(
    'ChBEaXNjaGFyZ2VSZWZ1c2FsEiEKHURJU0NIQVJHRV9SRUZVU0FMX1VOU1BFQ0lGSUVEEAASJQ'
    'ohRElTQ0hBUkdFX1JFRlVTQUxfTk9UX0hBTkRFRF9PVkVSEAESIgoeRElTQ0hBUkdFX1JFRlVT'
    'QUxfTk9UX0FTU0VTU0VEEAISJgoiRElTQ0hBUkdFX1JFRlVTQUxfSU5DT01QTEVURV9TQ09SRR'
    'ADEiUKIURJU0NIQVJHRV9SRUZVU0FMX0JFTE9XX1RIUkVTSE9MRBAE');

@$core.Deprecated('Use airwayAssessmentDescriptor instead')
const AirwayAssessment$json = {
  '1': 'AirwayAssessment',
  '2': [
    {'1': 'mallampati', '3': 1, '4': 1, '5': 9, '10': 'mallampati'},
    {'1': 'mouth_opening_mm', '3': 2, '4': 1, '5': 5, '10': 'mouthOpeningMm'},
    {'1': 'thyromental_mm', '3': 3, '4': 1, '5': 5, '10': 'thyromentalMm'},
    {'1': 'neck_movement', '3': 4, '4': 1, '5': 9, '10': 'neckMovement'},
    {'1': 'dentition', '3': 5, '4': 1, '5': 9, '10': 'dentition'},
    {'1': 'notes', '3': 6, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'predicted_difficult',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'predictedDifficult'
    },
  ],
};

/// Descriptor for `AirwayAssessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List airwayAssessmentDescriptor = $convert.base64Decode(
    'ChBBaXJ3YXlBc3Nlc3NtZW50Eh4KCm1hbGxhbXBhdGkYASABKAlSCm1hbGxhbXBhdGkSKAoQbW'
    '91dGhfb3BlbmluZ19tbRgCIAEoBVIObW91dGhPcGVuaW5nTW0SJQoOdGh5cm9tZW50YWxfbW0Y'
    'AyABKAVSDXRoeXJvbWVudGFsTW0SIwoNbmVja19tb3ZlbWVudBgEIAEoCVIMbmVja01vdmVtZW'
    '50EhwKCWRlbnRpdGlvbhgFIAEoCVIJZGVudGl0aW9uEhQKBW5vdGVzGAYgASgJUgVub3RlcxIv'
    'ChNwcmVkaWN0ZWRfZGlmZmljdWx0GAcgASgIUhJwcmVkaWN0ZWREaWZmaWN1bHQ=');

@$core.Deprecated('Use assessmentDescriptor instead')
const Assessment$json = {
  '1': 'Assessment',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'version', '3': 5, '4': 1, '5': 5, '10': 'version'},
    {'1': 'supersedes', '3': 6, '4': 1, '5': 9, '10': 'supersedes'},
    {'1': 'current', '3': 7, '4': 1, '5': 8, '10': 'current'},
    {'1': 'history', '3': 8, '4': 1, '5': 9, '10': 'history'},
    {
      '1': 'airway',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.AirwayAssessment',
      '10': 'airway'
    },
    {'1': 'asa_grade', '3': 10, '4': 1, '5': 9, '10': 'asaGrade'},
    {'1': 'investigations', '3': 11, '4': 3, '5': 9, '10': 'investigations'},
    {'1': 'risks', '3': 12, '4': 3, '5': 9, '10': 'risks'},
    {'1': 'plan', '3': 13, '4': 1, '5': 9, '10': 'plan'},
    {
      '1': 'consent',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.ConsentStatus',
      '10': 'consent'
    },
    {'1': 'consent_note', '3': 15, '4': 1, '5': 9, '10': 'consentNote'},
    {'1': 'fit_to_proceed', '3': 16, '4': 1, '5': 8, '10': 'fitToProceed'},
    {'1': 'conditions', '3': 17, '4': 3, '5': 9, '10': 'conditions'},
    {'1': 'assessed_by', '3': 18, '4': 1, '5': 9, '10': 'assessedBy'},
    {
      '1': 'assessed_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {
      '1': 'superseded_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
  ],
};

/// Descriptor for `Assessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessmentDescriptor = $convert.base64Decode(
    'CgpBc3Nlc3NtZW50EiMKDWFzc2Vzc21lbnRfaWQYASABKAlSDGFzc2Vzc21lbnRJZBIXCgdjYX'
    'NlX2lkGAIgASgJUgZjYXNlSWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBId'
    'CgpwYXRpZW50X2lkGAQgASgJUglwYXRpZW50SWQSGAoHdmVyc2lvbhgFIAEoBVIHdmVyc2lvbh'
    'IeCgpzdXBlcnNlZGVzGAYgASgJUgpzdXBlcnNlZGVzEhgKB2N1cnJlbnQYByABKAhSB2N1cnJl'
    'bnQSGAoHaGlzdG9yeRgIIAEoCVIHaGlzdG9yeRJDCgZhaXJ3YXkYCSABKAsyKy5oZWFsdGhjYX'
    'JlLmFuYWVzdGhlc2lhLnYxLkFpcndheUFzc2Vzc21lbnRSBmFpcndheRIbCglhc2FfZ3JhZGUY'
    'CiABKAlSCGFzYUdyYWRlEiYKDmludmVzdGlnYXRpb25zGAsgAygJUg5pbnZlc3RpZ2F0aW9ucx'
    'IUCgVyaXNrcxgMIAMoCVIFcmlza3MSEgoEcGxhbhgNIAEoCVIEcGxhbhJCCgdjb25zZW50GA4g'
    'ASgOMiguaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5Db25zZW50U3RhdHVzUgdjb25zZW50Ei'
    'EKDGNvbnNlbnRfbm90ZRgPIAEoCVILY29uc2VudE5vdGUSJAoOZml0X3RvX3Byb2NlZWQYECAB'
    'KAhSDGZpdFRvUHJvY2VlZBIeCgpjb25kaXRpb25zGBEgAygJUgpjb25kaXRpb25zEh8KC2Fzc2'
    'Vzc2VkX2J5GBIgASgJUgphc3Nlc3NlZEJ5EjsKC2Fzc2Vzc2VkX2F0GBMgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIKYXNzZXNzZWRBdBI/Cg1zdXBlcnNlZGVkX2F0GBQgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMc3VwZXJzZWRlZEF0');

@$core.Deprecated('Use planDescriptor instead')
const Plan$json = {
  '1': 'Plan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'technique',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {'1': 'agents', '3': 4, '4': 3, '5': 9, '10': 'agents'},
    {'1': 'airway', '3': 5, '4': 1, '5': 9, '10': 'airway'},
    {'1': 'monitoring', '3': 6, '4': 3, '5': 9, '10': 'monitoring'},
    {
      '1': 'special_equipment',
      '3': 7,
      '4': 3,
      '5': 9,
      '10': 'specialEquipment'
    },
    {'1': 'post_operative', '3': 8, '4': 1, '5': 9, '10': 'postOperative'},
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'planned_by', '3': 10, '4': 1, '5': 9, '10': 'plannedBy'},
    {
      '1': 'planned_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedAt'
    },
  ],
};

/// Descriptor for `Plan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planDescriptor = $convert.base64Decode(
    'CgRQbGFuEhcKB3BsYW5faWQYASABKAlSBnBsYW5JZBIXCgdjYXNlX2lkGAIgASgJUgZjYXNlSW'
    'QSQgoJdGVjaG5pcXVlGAMgASgOMiQuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5UZWNobmlx'
    'dWVSCXRlY2huaXF1ZRIWCgZhZ2VudHMYBCADKAlSBmFnZW50cxIWCgZhaXJ3YXkYBSABKAlSBm'
    'FpcndheRIeCgptb25pdG9yaW5nGAYgAygJUgptb25pdG9yaW5nEisKEXNwZWNpYWxfZXF1aXBt'
    'ZW50GAcgAygJUhBzcGVjaWFsRXF1aXBtZW50EiUKDnBvc3Rfb3BlcmF0aXZlGAggASgJUg1wb3'
    'N0T3BlcmF0aXZlEhQKBW5vdGVzGAkgASgJUgVub3RlcxIdCgpwbGFubmVkX2J5GAogASgJUglw'
    'bGFubmVkQnkSOQoKcGxhbm5lZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCXBsYW5uZWRBdA==');

@$core.Deprecated('Use readinessDescriptor instead')
const Readiness$json = {
  '1': 'Readiness',
  '2': [
    {'1': 'assessed', '3': 1, '4': 1, '5': 8, '10': 'assessed'},
    {'1': 'fit', '3': 2, '4': 1, '5': 8, '10': 'fit'},
    {'1': 'conditions', '3': 3, '4': 3, '5': 9, '10': 'conditions'},
    {'1': 'asa_grade', '3': 4, '4': 1, '5': 9, '10': 'asaGrade'},
    {'1': 'difficult_airway', '3': 5, '4': 1, '5': 8, '10': 'difficultAirway'},
    {
      '1': 'consent',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.ConsentStatus',
      '10': 'consent'
    },
    {'1': 'planned', '3': 7, '4': 1, '5': 8, '10': 'planned'},
    {
      '1': 'technique',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {
      '1': 'special_equipment',
      '3': 9,
      '4': 3,
      '5': 9,
      '10': 'specialEquipment'
    },
    {'1': 'post_operative', '3': 10, '4': 1, '5': 9, '10': 'postOperative'},
    {'1': 'outstanding', '3': 11, '4': 3, '5': 9, '10': 'outstanding'},
  ],
};

/// Descriptor for `Readiness`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readinessDescriptor = $convert.base64Decode(
    'CglSZWFkaW5lc3MSGgoIYXNzZXNzZWQYASABKAhSCGFzc2Vzc2VkEhAKA2ZpdBgCIAEoCFIDZm'
    'l0Eh4KCmNvbmRpdGlvbnMYAyADKAlSCmNvbmRpdGlvbnMSGwoJYXNhX2dyYWRlGAQgASgJUghh'
    'c2FHcmFkZRIpChBkaWZmaWN1bHRfYWlyd2F5GAUgASgIUg9kaWZmaWN1bHRBaXJ3YXkSQgoHY2'
    '9uc2VudBgGIAEoDjIoLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuQ29uc2VudFN0YXR1c1IH'
    'Y29uc2VudBIYCgdwbGFubmVkGAcgASgIUgdwbGFubmVkEkIKCXRlY2huaXF1ZRgIIAEoDjIkLm'
    'hlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuVGVjaG5pcXVlUgl0ZWNobmlxdWUSKwoRc3BlY2lh'
    'bF9lcXVpcG1lbnQYCSADKAlSEHNwZWNpYWxFcXVpcG1lbnQSJQoOcG9zdF9vcGVyYXRpdmUYCi'
    'ABKAlSDXBvc3RPcGVyYXRpdmUSIAoLb3V0c3RhbmRpbmcYCyADKAlSC291dHN0YW5kaW5n');

@$core.Deprecated('Use deviceLinkDescriptor instead')
const DeviceLink$json = {
  '1': 'DeviceLink',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'model', '3': 2, '4': 1, '5': 9, '10': 'model'},
    {'1': 'connected', '3': 3, '4': 1, '5': 8, '10': 'connected'},
    {
      '1': 'measured_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'measuredAt'
    },
  ],
};

/// Descriptor for `DeviceLink`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceLinkDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VMaW5rEhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSFAoFbW9kZWwYAiABKA'
    'lSBW1vZGVsEhwKCWNvbm5lY3RlZBgDIAEoCFIJY29ubmVjdGVkEjsKC21lYXN1cmVkX2F0GAQg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbWVhc3VyZWRBdA==');

@$core.Deprecated('Use recordDescriptor instead')
const Record$json = {
  '1': 'Record',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'technique',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.RecordStatus',
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
    {
      '1': 'origin',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'origin'
    },
    {'1': 'import_note', '3': 11, '4': 1, '5': 9, '10': 'importNote'},
    {
      '1': 'imported_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'importedAt'
    },
    {'1': 'imported_by', '3': 13, '4': 1, '5': 9, '10': 'importedBy'},
  ],
};

/// Descriptor for `Record`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDescriptor = $convert.base64Decode(
    'CgZSZWNvcmQSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBIXCgdjYXNlX2lkGAIgASgJUg'
    'ZjYXNlSWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIdCgpwYXRpZW50X2lk'
    'GAQgASgJUglwYXRpZW50SWQSQgoJdGVjaG5pcXVlGAUgASgOMiQuaGVhbHRoY2FyZS5hbmFlc3'
    'RoZXNpYS52MS5UZWNobmlxdWVSCXRlY2huaXF1ZRI/CgZzdGF0dXMYBiABKA4yJy5oZWFsdGhj'
    'YXJlLmFuYWVzdGhlc2lhLnYxLlJlY29yZFN0YXR1c1IGc3RhdHVzEjkKCnN0YXJ0ZWRfYXQYBy'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQSHQoKc3RhcnRlZF9i'
    'eRgIIAEoCVIJc3RhcnRlZEJ5EjUKCGVuZGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIHZW5kZWRBdBI+CgZvcmlnaW4YCiABKA4yJi5oZWFsdGhjYXJlLmFuYWVzdGhl'
    'c2lhLnYxLkVudHJ5U291cmNlUgZvcmlnaW4SHwoLaW1wb3J0X25vdGUYCyABKAlSCmltcG9ydE'
    '5vdGUSOwoLaW1wb3J0ZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpp'
    'bXBvcnRlZEF0Eh8KC2ltcG9ydGVkX2J5GA0gASgJUgppbXBvcnRlZEJ5');

@$core.Deprecated('Use vitalEntryDescriptor instead')
const VitalEntry$json = {
  '1': 'VitalEntry',
  '2': [
    {'1': 'vital_id', '3': 1, '4': 1, '5': 9, '10': 'vitalId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 4, '4': 1, '5': 9, '10': 'display'},
    {'1': 'value', '3': 5, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 6, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'source',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'source'
    },
    {
      '1': 'device',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DeviceLink',
      '10': 'device'
    },
    {
      '1': 'observed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
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
    {'1': 'trustworthy', '3': 12, '4': 1, '5': 8, '10': 'trustworthy'},
  ],
};

/// Descriptor for `VitalEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vitalEntryDescriptor = $convert.base64Decode(
    'CgpWaXRhbEVudHJ5EhkKCHZpdGFsX2lkGAEgASgJUgd2aXRhbElkEhsKCXJlY29yZF9pZBgCIA'
    'EoCVIIcmVjb3JkSWQSEgoEY29kZRgDIAEoCVIEY29kZRIYCgdkaXNwbGF5GAQgASgJUgdkaXNw'
    'bGF5EhQKBXZhbHVlGAUgASgBUgV2YWx1ZRISCgR1bml0GAYgASgJUgR1bml0Ej4KBnNvdXJjZR'
    'gHIAEoDjImLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuRW50cnlTb3VyY2VSBnNvdXJjZRI9'
    'CgZkZXZpY2UYCCABKAsyJS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkRldmljZUxpbmtSBm'
    'RldmljZRI7CgtvYnNlcnZlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'Cm9ic2VydmVkQXQSOwoLcmVjb3JkZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgpyZWNvcmRlZEF0Eh8KC3JlY29yZGVkX2J5GAsgASgJUgpyZWNvcmRlZEJ5EiAKC3Ry'
    'dXN0d29ydGh5GAwgASgIUgt0cnVzdHdvcnRoeQ==');

@$core.Deprecated('Use drugEntryDescriptor instead')
const DrugEntry$json = {
  '1': 'DrugEntry',
  '2': [
    {'1': 'drug_id', '3': 1, '4': 1, '5': 9, '10': 'drugId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'drug_code', '3': 3, '4': 1, '5': 9, '10': 'drugCode'},
    {'1': 'drug_display', '3': 4, '4': 1, '5': 9, '10': 'drugDisplay'},
    {'1': 'route', '3': 5, '4': 1, '5': 9, '10': 'route'},
    {'1': 'dose', '3': 6, '4': 1, '5': 1, '10': 'dose'},
    {'1': 'dose_unit', '3': 7, '4': 1, '5': 9, '10': 'doseUnit'},
    {
      '1': 'concentration_amount',
      '3': 8,
      '4': 1,
      '5': 1,
      '10': 'concentrationAmount'
    },
    {
      '1': 'concentration_unit',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'concentrationUnit'
    },
    {
      '1': 'concentration_volume',
      '3': 10,
      '4': 1,
      '5': 1,
      '10': 'concentrationVolume'
    },
    {'1': 'rate_ml_per_hour', '3': 11, '4': 1, '5': 1, '10': 'rateMlPerHour'},
    {'1': 'infusion', '3': 12, '4': 1, '5': 8, '10': 'infusion'},
    {
      '1': 'stopped_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
    {
      '1': 'source',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'source'
    },
    {
      '1': 'device',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DeviceLink',
      '10': 'device'
    },
    {
      '1': 'given_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {
      '1': 'recorded_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 18, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'note', '3': 19, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `DrugEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List drugEntryDescriptor = $convert.base64Decode(
    'CglEcnVnRW50cnkSFwoHZHJ1Z19pZBgBIAEoCVIGZHJ1Z0lkEhsKCXJlY29yZF9pZBgCIAEoCV'
    'IIcmVjb3JkSWQSGwoJZHJ1Z19jb2RlGAMgASgJUghkcnVnQ29kZRIhCgxkcnVnX2Rpc3BsYXkY'
    'BCABKAlSC2RydWdEaXNwbGF5EhQKBXJvdXRlGAUgASgJUgVyb3V0ZRISCgRkb3NlGAYgASgBUg'
    'Rkb3NlEhsKCWRvc2VfdW5pdBgHIAEoCVIIZG9zZVVuaXQSMQoUY29uY2VudHJhdGlvbl9hbW91'
    'bnQYCCABKAFSE2NvbmNlbnRyYXRpb25BbW91bnQSLQoSY29uY2VudHJhdGlvbl91bml0GAkgAS'
    'gJUhFjb25jZW50cmF0aW9uVW5pdBIxChRjb25jZW50cmF0aW9uX3ZvbHVtZRgKIAEoAVITY29u'
    'Y2VudHJhdGlvblZvbHVtZRInChByYXRlX21sX3Blcl9ob3VyGAsgASgBUg1yYXRlTWxQZXJIb3'
    'VyEhoKCGluZnVzaW9uGAwgASgIUghpbmZ1c2lvbhI5CgpzdG9wcGVkX2F0GA0gASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RvcHBlZEF0Ej4KBnNvdXJjZRgOIAEoDjImLmhlYW'
    'x0aGNhcmUuYW5hZXN0aGVzaWEudjEuRW50cnlTb3VyY2VSBnNvdXJjZRI9CgZkZXZpY2UYDyAB'
    'KAsyJS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkRldmljZUxpbmtSBmRldmljZRI1CghnaX'
    'Zlbl9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2dpdmVuQXQSOwoLcmVj'
    'b3JkZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh'
    '8KC3JlY29yZGVkX2J5GBIgASgJUgpyZWNvcmRlZEJ5EhIKBG5vdGUYEyABKAlSBG5vdGU=');

@$core.Deprecated('Use airwayEventDescriptor instead')
const AirwayEvent$json = {
  '1': 'AirwayEvent',
  '2': [
    {'1': 'airway_id', '3': 1, '4': 1, '5': 9, '10': 'airwayId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'device', '3': 3, '4': 1, '5': 9, '10': 'device'},
    {'1': 'attempt', '3': 4, '4': 1, '5': 5, '10': 'attempt'},
    {'1': 'grade', '3': 5, '4': 1, '5': 9, '10': 'grade'},
    {'1': 'successful', '3': 6, '4': 1, '5': 8, '10': 'successful'},
    {'1': 'difficulty', '3': 7, '4': 1, '5': 9, '10': 'difficulty'},
    {'1': 'complications', '3': 8, '4': 3, '5': 9, '10': 'complications'},
    {'1': 'adjuncts', '3': 9, '4': 3, '5': 9, '10': 'adjuncts'},
    {
      '1': 'occurred_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `AirwayEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List airwayEventDescriptor = $convert.base64Decode(
    'CgtBaXJ3YXlFdmVudBIbCglhaXJ3YXlfaWQYASABKAlSCGFpcndheUlkEhsKCXJlY29yZF9pZB'
    'gCIAEoCVIIcmVjb3JkSWQSFgoGZGV2aWNlGAMgASgJUgZkZXZpY2USGAoHYXR0ZW1wdBgEIAEo'
    'BVIHYXR0ZW1wdBIUCgVncmFkZRgFIAEoCVIFZ3JhZGUSHgoKc3VjY2Vzc2Z1bBgGIAEoCFIKc3'
    'VjY2Vzc2Z1bBIeCgpkaWZmaWN1bHR5GAcgASgJUgpkaWZmaWN1bHR5EiQKDWNvbXBsaWNhdGlv'
    'bnMYCCADKAlSDWNvbXBsaWNhdGlvbnMSGgoIYWRqdW5jdHMYCSADKAlSCGFkanVuY3RzEjsKC2'
    '9jY3VycmVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRB'
    'dBIfCgtyZWNvcmRlZF9ieRgLIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use difficultAirwayDescriptor instead')
const DifficultAirway$json = {
  '1': 'DifficultAirway',
  '2': [
    {'1': 'attempts', '3': 1, '4': 1, '5': 5, '10': 'attempts'},
    {'1': 'difficult', '3': 2, '4': 1, '5': 8, '10': 'difficult'},
    {'1': 'reasons', '3': 3, '4': 3, '5': 9, '10': 'reasons'},
    {'1': 'final_device', '3': 4, '4': 1, '5': 9, '10': 'finalDevice'},
    {'1': 'complications', '3': 5, '4': 3, '5': 9, '10': 'complications'},
  ],
};

/// Descriptor for `DifficultAirway`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List difficultAirwayDescriptor = $convert.base64Decode(
    'Cg9EaWZmaWN1bHRBaXJ3YXkSGgoIYXR0ZW1wdHMYASABKAVSCGF0dGVtcHRzEhwKCWRpZmZpY3'
    'VsdBgCIAEoCFIJZGlmZmljdWx0EhgKB3JlYXNvbnMYAyADKAlSB3JlYXNvbnMSIQoMZmluYWxf'
    'ZGV2aWNlGAQgASgJUgtmaW5hbERldmljZRIkCg1jb21wbGljYXRpb25zGAUgAygJUg1jb21wbG'
    'ljYXRpb25z');

@$core.Deprecated('Use fluidEntryDescriptor instead')
const FluidEntry$json = {
  '1': 'FluidEntry',
  '2': [
    {'1': 'fluid_id', '3': 1, '4': 1, '5': 9, '10': 'fluidId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'direction',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.FluidDirection',
      '10': 'direction'
    },
    {'1': 'kind', '3': 4, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'label', '3': 5, '4': 1, '5': 9, '10': 'label'},
    {'1': 'volume_ml', '3': 6, '4': 1, '5': 1, '10': 'volumeMl'},
    {'1': 'product_id', '3': 7, '4': 1, '5': 9, '10': 'productId'},
    {
      '1': 'occurred_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
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

/// Descriptor for `FluidEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fluidEntryDescriptor = $convert.base64Decode(
    'CgpGbHVpZEVudHJ5EhkKCGZsdWlkX2lkGAEgASgJUgdmbHVpZElkEhsKCXJlY29yZF9pZBgCIA'
    'EoCVIIcmVjb3JkSWQSRwoJZGlyZWN0aW9uGAMgASgOMikuaGVhbHRoY2FyZS5hbmFlc3RoZXNp'
    'YS52MS5GbHVpZERpcmVjdGlvblIJZGlyZWN0aW9uEhIKBGtpbmQYBCABKAlSBGtpbmQSFAoFbG'
    'FiZWwYBSABKAlSBWxhYmVsEhsKCXZvbHVtZV9tbBgGIAEoAVIIdm9sdW1lTWwSHQoKcHJvZHVj'
    'dF9pZBgHIAEoCVIJcHJvZHVjdElkEjsKC29jY3VycmVkX2F0GAggASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBI7CgtyZWNvcmRlZF9hdBgJIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSHwoLcmVjb3JkZWRfYnkYCiABKAlSCn'
    'JlY29yZGVkQnk=');

@$core.Deprecated('Use fluidBalanceDescriptor instead')
const FluidBalance$json = {
  '1': 'FluidBalance',
  '2': [
    {'1': 'in_ml', '3': 1, '4': 1, '5': 1, '10': 'inMl'},
    {'1': 'out_ml', '3': 2, '4': 1, '5': 1, '10': 'outMl'},
    {'1': 'net_ml', '3': 3, '4': 1, '5': 1, '10': 'netMl'},
    {'1': 'blood_loss_ml', '3': 4, '4': 1, '5': 1, '10': 'bloodLossMl'},
    {'1': 'transfused_ml', '3': 5, '4': 1, '5': 1, '10': 'transfusedMl'},
    {'1': 'urine_ml', '3': 6, '4': 1, '5': 1, '10': 'urineMl'},
    {'1': 'entries', '3': 7, '4': 1, '5': 5, '10': 'entries'},
  ],
};

/// Descriptor for `FluidBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fluidBalanceDescriptor = $convert.base64Decode(
    'CgxGbHVpZEJhbGFuY2USEwoFaW5fbWwYASABKAFSBGluTWwSFQoGb3V0X21sGAIgASgBUgVvdX'
    'RNbBIVCgZuZXRfbWwYAyABKAFSBW5ldE1sEiIKDWJsb29kX2xvc3NfbWwYBCABKAFSC2Jsb29k'
    'TG9zc01sEiMKDXRyYW5zZnVzZWRfbWwYBSABKAFSDHRyYW5zZnVzZWRNbBIZCgh1cmluZV9tbB'
    'gGIAEoAVIHdXJpbmVNbBIYCgdlbnRyaWVzGAcgASgFUgdlbnRyaWVz');

@$core.Deprecated('Use handoverDescriptor instead')
const Handover$json = {
  '1': 'Handover',
  '2': [
    {'1': 'handover_id', '3': 1, '4': 1, '5': 9, '10': 'handoverId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'from_clinician', '3': 3, '4': 1, '5': 9, '10': 'fromClinician'},
    {'1': 'to_clinician', '3': 4, '4': 1, '5': 9, '10': 'toClinician'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'concerns', '3': 6, '4': 3, '5': 9, '10': 'concerns'},
    {'1': 'instructions', '3': 7, '4': 3, '5': 9, '10': 'instructions'},
    {'1': 'analgesia_given', '3': 8, '4': 3, '5': 9, '10': 'analgesiaGiven'},
    {'1': 'antiemetic_given', '3': 9, '4': 3, '5': 9, '10': 'antiemeticGiven'},
    {
      '1': 'handed_over_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'handedOverAt'
    },
  ],
};

/// Descriptor for `Handover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverDescriptor = $convert.base64Decode(
    'CghIYW5kb3ZlchIfCgtoYW5kb3Zlcl9pZBgBIAEoCVIKaGFuZG92ZXJJZBIbCglyZWNvcmRfaW'
    'QYAiABKAlSCHJlY29yZElkEiUKDmZyb21fY2xpbmljaWFuGAMgASgJUg1mcm9tQ2xpbmljaWFu'
    'EiEKDHRvX2NsaW5pY2lhbhgEIAEoCVILdG9DbGluaWNpYW4SGAoHc3VtbWFyeRgFIAEoCVIHc3'
    'VtbWFyeRIaCghjb25jZXJucxgGIAMoCVIIY29uY2VybnMSIgoMaW5zdHJ1Y3Rpb25zGAcgAygJ'
    'UgxpbnN0cnVjdGlvbnMSJwoPYW5hbGdlc2lhX2dpdmVuGAggAygJUg5hbmFsZ2VzaWFHaXZlbh'
    'IpChBhbnRpZW1ldGljX2dpdmVuGAkgAygJUg9hbnRpZW1ldGljR2l2ZW4SQAoOaGFuZGVkX292'
    'ZXJfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxoYW5kZWRPdmVyQXQ=');

@$core.Deprecated('Use scoreComponentDescriptor instead')
const ScoreComponent$json = {
  '1': 'ScoreComponent',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'max', '3': 3, '4': 1, '5': 5, '10': 'max'},
  ],
};

/// Descriptor for `ScoreComponent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreComponentDescriptor = $convert.base64Decode(
    'Cg5TY29yZUNvbXBvbmVudBISCgRjb2RlGAEgASgJUgRjb2RlEhQKBWxhYmVsGAIgASgJUgVsYW'
    'JlbBIQCgNtYXgYAyABKAVSA21heA==');

@$core.Deprecated('Use recoveryScaleDescriptor instead')
const RecoveryScale$json = {
  '1': 'RecoveryScale',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'components',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.ScoreComponent',
      '10': 'components'
    },
    {'1': 'discharge_at', '3': 4, '4': 1, '5': 5, '10': 'dischargeAt'},
  ],
};

/// Descriptor for `RecoveryScale`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoveryScaleDescriptor = $convert.base64Decode(
    'Cg1SZWNvdmVyeVNjYWxlEhIKBG5hbWUYASABKAlSBG5hbWUSGAoHdmVyc2lvbhgCIAEoCVIHdm'
    'Vyc2lvbhJJCgpjb21wb25lbnRzGAMgAygLMikuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5T'
    'Y29yZUNvbXBvbmVudFIKY29tcG9uZW50cxIhCgxkaXNjaGFyZ2VfYXQYBCABKAVSC2Rpc2NoYX'
    'JnZUF0');

@$core.Deprecated('Use recoveryAssessmentDescriptor instead')
const RecoveryAssessment$json = {
  '1': 'RecoveryAssessment',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'scale_name', '3': 3, '4': 1, '5': 9, '10': 'scaleName'},
    {'1': 'scale_version', '3': 4, '4': 1, '5': 9, '10': 'scaleVersion'},
    {
      '1': 'scores',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryAssessment.ScoresEntry',
      '10': 'scores'
    },
    {'1': 'total', '3': 6, '4': 1, '5': 5, '10': 'total'},
    {
      '1': 'discharge_threshold',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'dischargeThreshold'
    },
    {'1': 'missing', '3': 8, '4': 3, '5': 9, '10': 'missing'},
    {
      '1': 'assessed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {'1': 'assessed_by', '3': 10, '4': 1, '5': 9, '10': 'assessedBy'},
    {'1': 'complete', '3': 11, '4': 1, '5': 8, '10': 'complete'},
    {'1': 'meets_threshold', '3': 12, '4': 1, '5': 8, '10': 'meetsThreshold'},
  ],
  '3': [RecoveryAssessment_ScoresEntry$json],
};

@$core.Deprecated('Use recoveryAssessmentDescriptor instead')
const RecoveryAssessment_ScoresEntry$json = {
  '1': 'ScoresEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RecoveryAssessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recoveryAssessmentDescriptor = $convert.base64Decode(
    'ChJSZWNvdmVyeUFzc2Vzc21lbnQSIwoNYXNzZXNzbWVudF9pZBgBIAEoCVIMYXNzZXNzbWVudE'
    'lkEhsKCXJlY29yZF9pZBgCIAEoCVIIcmVjb3JkSWQSHQoKc2NhbGVfbmFtZRgDIAEoCVIJc2Nh'
    'bGVOYW1lEiMKDXNjYWxlX3ZlcnNpb24YBCABKAlSDHNjYWxlVmVyc2lvbhJRCgZzY29yZXMYBS'
    'ADKAsyOS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLlJlY292ZXJ5QXNzZXNzbWVudC5TY29y'
    'ZXNFbnRyeVIGc2NvcmVzEhQKBXRvdGFsGAYgASgFUgV0b3RhbBIvChNkaXNjaGFyZ2VfdGhyZX'
    'Nob2xkGAcgASgFUhJkaXNjaGFyZ2VUaHJlc2hvbGQSGAoHbWlzc2luZxgIIAMoCVIHbWlzc2lu'
    'ZxI7Cgthc3Nlc3NlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFzc2'
    'Vzc2VkQXQSHwoLYXNzZXNzZWRfYnkYCiABKAlSCmFzc2Vzc2VkQnkSGgoIY29tcGxldGUYCyAB'
    'KAhSCGNvbXBsZXRlEicKD21lZXRzX3RocmVzaG9sZBgMIAEoCFIObWVldHNUaHJlc2hvbGQaOQ'
    'oLU2NvcmVzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAVSBXZhbHVlOgI4'
    'AQ==');

@$core.Deprecated('Use dischargeDecisionDescriptor instead')
const DischargeDecision$json = {
  '1': 'DischargeDecision',
  '2': [
    {'1': 'allowed', '3': 1, '4': 1, '5': 8, '10': 'allowed'},
    {
      '1': 'refusals',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.DischargeRefusal',
      '10': 'refusals'
    },
    {'1': 'explanations', '3': 3, '4': 3, '5': 9, '10': 'explanations'},
    {
      '1': 'score',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryAssessment',
      '10': 'score'
    },
  ],
};

/// Descriptor for `DischargeDecision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeDecisionDescriptor = $convert.base64Decode(
    'ChFEaXNjaGFyZ2VEZWNpc2lvbhIYCgdhbGxvd2VkGAEgASgIUgdhbGxvd2VkEkcKCHJlZnVzYW'
    'xzGAIgAygOMisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5EaXNjaGFyZ2VSZWZ1c2FsUghy'
    'ZWZ1c2FscxIiCgxleHBsYW5hdGlvbnMYAyADKAlSDGV4cGxhbmF0aW9ucxJDCgVzY29yZRgEIA'
    'EoCzItLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuUmVjb3ZlcnlBc3Nlc3NtZW50UgVzY29y'
    'ZQ==');

@$core.Deprecated('Use dischargeDescriptor instead')
const Discharge$json = {
  '1': 'Discharge',
  '2': [
    {'1': 'discharge_id', '3': 1, '4': 1, '5': 9, '10': 'dischargeId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'destination', '3': 3, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'overridden', '3': 4, '4': 1, '5': 8, '10': 'overridden'},
    {'1': 'override_reason', '3': 5, '4': 1, '5': 9, '10': 'overrideReason'},
    {'1': 'score_id', '3': 6, '4': 1, '5': 9, '10': 'scoreId'},
    {
      '1': 'discharged_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dischargedAt'
    },
    {'1': 'discharged_by', '3': 8, '4': 1, '5': 9, '10': 'dischargedBy'},
  ],
};

/// Descriptor for `Discharge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeDescriptor = $convert.base64Decode(
    'CglEaXNjaGFyZ2USIQoMZGlzY2hhcmdlX2lkGAEgASgJUgtkaXNjaGFyZ2VJZBIbCglyZWNvcm'
    'RfaWQYAiABKAlSCHJlY29yZElkEiAKC2Rlc3RpbmF0aW9uGAMgASgJUgtkZXN0aW5hdGlvbhIe'
    'CgpvdmVycmlkZGVuGAQgASgIUgpvdmVycmlkZGVuEicKD292ZXJyaWRlX3JlYXNvbhgFIAEoCV'
    'IOb3ZlcnJpZGVSZWFzb24SGQoIc2NvcmVfaWQYBiABKAlSB3Njb3JlSWQSPwoNZGlzY2hhcmdl'
    'ZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGRpc2NoYXJnZWRBdBIjCg'
    '1kaXNjaGFyZ2VkX2J5GAggASgJUgxkaXNjaGFyZ2VkQnk=');

@$core.Deprecated('Use painOrderDescriptor instead')
const PainOrder$json = {
  '1': 'PainOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'modality', '3': 5, '4': 1, '5': 9, '10': 'modality'},
    {'1': 'prescription_ids', '3': 6, '4': 3, '5': 9, '10': 'prescriptionIds'},
    {'1': 'target_score', '3': 7, '4': 1, '5': 9, '10': 'targetScore'},
    {'1': 'monitoring', '3': 8, '4': 3, '5': 9, '10': 'monitoring'},
    {'1': 'escalation', '3': 9, '4': 1, '5': 9, '10': 'escalation'},
    {
      '1': 'review_by',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewBy'
    },
    {'1': 'ordered_by', '3': 11, '4': 1, '5': 9, '10': 'orderedBy'},
    {
      '1': 'ordered_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'orderedAt'
    },
    {
      '1': 'stopped_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
    {'1': 'stopped_by', '3': 14, '4': 1, '5': 9, '10': 'stoppedBy'},
    {'1': 'review_overdue', '3': 15, '4': 1, '5': 8, '10': 'reviewOverdue'},
  ],
};

/// Descriptor for `PainOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List painOrderDescriptor = $convert.base64Decode(
    'CglQYWluT3JkZXISGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSGwoJcmVjb3JkX2lkGAIgAS'
    'gJUghyZWNvcmRJZBIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVy'
    'X2lkGAQgASgJUgtlbmNvdW50ZXJJZBIaCghtb2RhbGl0eRgFIAEoCVIIbW9kYWxpdHkSKQoQcH'
    'Jlc2NyaXB0aW9uX2lkcxgGIAMoCVIPcHJlc2NyaXB0aW9uSWRzEiEKDHRhcmdldF9zY29yZRgH'
    'IAEoCVILdGFyZ2V0U2NvcmUSHgoKbW9uaXRvcmluZxgIIAMoCVIKbW9uaXRvcmluZxIeCgplc2'
    'NhbGF0aW9uGAkgASgJUgplc2NhbGF0aW9uEjcKCXJldmlld19ieRgKIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCHJldmlld0J5Eh0KCm9yZGVyZWRfYnkYCyABKAlSCW9yZGVyZW'
    'RCeRI5CgpvcmRlcmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJb3Jk'
    'ZXJlZEF0EjkKCnN0b3BwZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'lzdG9wcGVkQXQSHQoKc3RvcHBlZF9ieRgOIAEoCVIJc3RvcHBlZEJ5EiUKDnJldmlld19vdmVy'
    'ZHVlGA8gASgIUg1yZXZpZXdPdmVyZHVl');

@$core.Deprecated('Use summaryDescriptor instead')
const Summary$json = {
  '1': 'Summary',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'technique',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {'1': 'asa_grade', '3': 5, '4': 1, '5': 9, '10': 'asaGrade'},
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {
      '1': 'airway',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DifficultAirway',
      '10': 'airway'
    },
    {
      '1': 'key_drugs',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DrugEntry',
      '10': 'keyDrugs'
    },
    {
      '1': 'fluids',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.FluidBalance',
      '10': 'fluids'
    },
    {'1': 'events', '3': 11, '4': 3, '5': 9, '10': 'events'},
    {
      '1': 'recovery',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryAssessment',
      '10': 'recovery'
    },
    {'1': 'disposal', '3': 13, '4': 1, '5': 9, '10': 'disposal'},
    {
      '1': 'discharge_overridden',
      '3': 14,
      '4': 1,
      '5': 8,
      '10': 'dischargeOverridden'
    },
    {'1': 'override_reason', '3': 15, '4': 1, '5': 9, '10': 'overrideReason'},
    {'1': 'incomplete', '3': 16, '4': 3, '5': 9, '10': 'incomplete'},
  ],
};

/// Descriptor for `Summary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List summaryDescriptor = $convert.base64Decode(
    'CgdTdW1tYXJ5EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSFwoHY2FzZV9pZBgCIAEoCV'
    'IGY2FzZUlkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBJCCgl0ZWNobmlxdWUYBCAB'
    'KA4yJC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLlRlY2huaXF1ZVIJdGVjaG5pcXVlEhsKCW'
    'FzYV9ncmFkZRgFIAEoCVIIYXNhR3JhZGUSOQoKc3RhcnRlZF9hdBgGIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI1CghlbmRlZF9hdBgHIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZGVkQXQSQgoGYWlyd2F5GAggASgLMiouaGVhbHRoY2Fy'
    'ZS5hbmFlc3RoZXNpYS52MS5EaWZmaWN1bHRBaXJ3YXlSBmFpcndheRJBCglrZXlfZHJ1Z3MYCS'
    'ADKAsyJC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkRydWdFbnRyeVIIa2V5RHJ1Z3MSPwoG'
    'Zmx1aWRzGAogASgLMicuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5GbHVpZEJhbGFuY2VSBm'
    'ZsdWlkcxIWCgZldmVudHMYCyADKAlSBmV2ZW50cxJJCghyZWNvdmVyeRgMIAEoCzItLmhlYWx0'
    'aGNhcmUuYW5hZXN0aGVzaWEudjEuUmVjb3ZlcnlBc3Nlc3NtZW50UghyZWNvdmVyeRIaCghkaX'
    'Nwb3NhbBgNIAEoCVIIZGlzcG9zYWwSMQoUZGlzY2hhcmdlX292ZXJyaWRkZW4YDiABKAhSE2Rp'
    'c2NoYXJnZU92ZXJyaWRkZW4SJwoPb3ZlcnJpZGVfcmVhc29uGA8gASgJUg5vdmVycmlkZVJlYX'
    'NvbhIeCgppbmNvbXBsZXRlGBAgAygJUgppbmNvbXBsZXRl');

@$core.Deprecated('Use recordAssessmentRequestDescriptor instead')
const RecordAssessmentRequest$json = {
  '1': 'RecordAssessmentRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'history', '3': 4, '4': 1, '5': 9, '10': 'history'},
    {
      '1': 'airway',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.AirwayAssessment',
      '10': 'airway'
    },
    {'1': 'asa_grade', '3': 6, '4': 1, '5': 9, '10': 'asaGrade'},
    {'1': 'investigations', '3': 7, '4': 3, '5': 9, '10': 'investigations'},
    {'1': 'risks', '3': 8, '4': 3, '5': 9, '10': 'risks'},
    {'1': 'plan', '3': 9, '4': 1, '5': 9, '10': 'plan'},
    {
      '1': 'consent',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.ConsentStatus',
      '10': 'consent'
    },
    {'1': 'consent_note', '3': 11, '4': 1, '5': 9, '10': 'consentNote'},
    {'1': 'fit_to_proceed', '3': 12, '4': 1, '5': 8, '10': 'fitToProceed'},
    {'1': 'conditions', '3': 13, '4': 3, '5': 9, '10': 'conditions'},
  ],
};

/// Descriptor for `RecordAssessmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmRBc3Nlc3NtZW50UmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRp'
    'ZW50SWQSGAoHaGlzdG9yeRgEIAEoCVIHaGlzdG9yeRJDCgZhaXJ3YXkYBSABKAsyKy5oZWFsdG'
    'hjYXJlLmFuYWVzdGhlc2lhLnYxLkFpcndheUFzc2Vzc21lbnRSBmFpcndheRIbCglhc2FfZ3Jh'
    'ZGUYBiABKAlSCGFzYUdyYWRlEiYKDmludmVzdGlnYXRpb25zGAcgAygJUg5pbnZlc3RpZ2F0aW'
    '9ucxIUCgVyaXNrcxgIIAMoCVIFcmlza3MSEgoEcGxhbhgJIAEoCVIEcGxhbhJCCgdjb25zZW50'
    'GAogASgOMiguaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5Db25zZW50U3RhdHVzUgdjb25zZW'
    '50EiEKDGNvbnNlbnRfbm90ZRgLIAEoCVILY29uc2VudE5vdGUSJAoOZml0X3RvX3Byb2NlZWQY'
    'DCABKAhSDGZpdFRvUHJvY2VlZBIeCgpjb25kaXRpb25zGA0gAygJUgpjb25kaXRpb25z');

@$core.Deprecated('Use recordAssessmentResponseDescriptor instead')
const RecordAssessmentResponse$json = {
  '1': 'RecordAssessmentResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Assessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `RecordAssessmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmRBc3Nlc3NtZW50UmVzcG9uc2USRQoKYXNzZXNzbWVudBgBIAEoCzIlLmhlYWx0aG'
        'NhcmUuYW5hZXN0aGVzaWEudjEuQXNzZXNzbWVudFIKYXNzZXNzbWVudA==');

@$core.Deprecated('Use listAssessmentsRequestDescriptor instead')
const ListAssessmentsRequest$json = {
  '1': 'ListAssessmentsRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `ListAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QXNzZXNzbWVudHNSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZA==');

@$core.Deprecated('Use listAssessmentsResponseDescriptor instead')
const ListAssessmentsResponse$json = {
  '1': 'ListAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Assessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QXNzZXNzbWVudHNSZXNwb25zZRJHCgthc3Nlc3NtZW50cxgBIAMoCzIlLmhlYWx0aG'
        'NhcmUuYW5hZXN0aGVzaWEudjEuQXNzZXNzbWVudFILYXNzZXNzbWVudHM=');

@$core.Deprecated('Use listPatientAssessmentsRequestDescriptor instead')
const ListPatientAssessmentsRequest$json = {
  '1': 'ListPatientAssessmentsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPatientAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientAssessmentsRequestDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0UGF0aWVudEFzc2Vzc21lbnRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYX'
        'RpZW50SWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listPatientAssessmentsResponseDescriptor instead')
const ListPatientAssessmentsResponse$json = {
  '1': 'ListPatientAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Assessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListPatientAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPatientAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0UGF0aWVudEFzc2Vzc21lbnRzUmVzcG9uc2USRwoLYXNzZXNzbWVudHMYASADKAsyJS'
        '5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkFzc2Vzc21lbnRSC2Fzc2Vzc21lbnRz');

@$core.Deprecated('Use recordPlanRequestDescriptor instead')
const RecordPlanRequest$json = {
  '1': 'RecordPlanRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'technique',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {'1': 'agents', '3': 3, '4': 3, '5': 9, '10': 'agents'},
    {'1': 'airway', '3': 4, '4': 1, '5': 9, '10': 'airway'},
    {'1': 'monitoring', '3': 5, '4': 3, '5': 9, '10': 'monitoring'},
    {
      '1': 'special_equipment',
      '3': 6,
      '4': 3,
      '5': 9,
      '10': 'specialEquipment'
    },
    {'1': 'post_operative', '3': 7, '4': 1, '5': 9, '10': 'postOperative'},
    {'1': 'notes', '3': 8, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `RecordPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPlanRequestDescriptor = $convert.base64Decode(
    'ChFSZWNvcmRQbGFuUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSQgoJdGVjaG5pcX'
    'VlGAIgASgOMiQuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5UZWNobmlxdWVSCXRlY2huaXF1'
    'ZRIWCgZhZ2VudHMYAyADKAlSBmFnZW50cxIWCgZhaXJ3YXkYBCABKAlSBmFpcndheRIeCgptb2'
    '5pdG9yaW5nGAUgAygJUgptb25pdG9yaW5nEisKEXNwZWNpYWxfZXF1aXBtZW50GAYgAygJUhBz'
    'cGVjaWFsRXF1aXBtZW50EiUKDnBvc3Rfb3BlcmF0aXZlGAcgASgJUg1wb3N0T3BlcmF0aXZlEh'
    'QKBW5vdGVzGAggASgJUgVub3Rlcw==');

@$core.Deprecated('Use recordPlanResponseDescriptor instead')
const RecordPlanResponse$json = {
  '1': 'RecordPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Plan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `RecordPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordPlanResponseDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRQbGFuUmVzcG9uc2USMwoEcGxhbhgBIAEoCzIfLmhlYWx0aGNhcmUuYW5hZXN0aG'
    'VzaWEudjEuUGxhblIEcGxhbg==');

@$core.Deprecated('Use getPlanRequestDescriptor instead')
const GetPlanRequest$json = {
  '1': 'GetPlanRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlanRequestDescriptor = $convert
    .base64Decode('Cg5HZXRQbGFuUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getPlanResponseDescriptor instead')
const GetPlanResponse$json = {
  '1': 'GetPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Plan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `GetPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlanResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRQbGFuUmVzcG9uc2USMwoEcGxhbhgBIAEoCzIfLmhlYWx0aGNhcmUuYW5hZXN0aGVzaW'
    'EudjEuUGxhblIEcGxhbg==');

@$core.Deprecated('Use getReadinessRequestDescriptor instead')
const GetReadinessRequest$json = {
  '1': 'GetReadinessRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRSZWFkaW5lc3NSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZA==');

@$core.Deprecated('Use getReadinessResponseDescriptor instead')
const GetReadinessResponse$json = {
  '1': 'GetReadinessResponse',
  '2': [
    {
      '1': 'readiness',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Readiness',
      '10': 'readiness'
    },
  ],
};

/// Descriptor for `GetReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessResponseDescriptor = $convert.base64Decode(
    'ChRHZXRSZWFkaW5lc3NSZXNwb25zZRJCCglyZWFkaW5lc3MYASABKAsyJC5oZWFsdGhjYXJlLm'
    'FuYWVzdGhlc2lhLnYxLlJlYWRpbmVzc1IJcmVhZGluZXNz');

@$core.Deprecated('Use openRecordRequestDescriptor instead')
const OpenRecordRequest$json = {
  '1': 'OpenRecordRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'technique',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.Technique',
      '10': 'technique'
    },
    {
      '1': 'started_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'origin',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'origin'
    },
    {'1': 'import_note', '3': 7, '4': 1, '5': 9, '10': 'importNote'},
  ],
};

/// Descriptor for `OpenRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openRecordRequestDescriptor = $convert.base64Decode(
    'ChFPcGVuUmVjb3JkUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSIQoMZW5jb3VudG'
    'VyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRpZW50SWQS'
    'QgoJdGVjaG5pcXVlGAQgASgOMiQuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5UZWNobmlxdW'
    'VSCXRlY2huaXF1ZRI5CgpzdGFydGVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIJc3RhcnRlZEF0Ej4KBm9yaWdpbhgGIAEoDjImLmhlYWx0aGNhcmUuYW5hZXN0aGVzaW'
    'EudjEuRW50cnlTb3VyY2VSBm9yaWdpbhIfCgtpbXBvcnRfbm90ZRgHIAEoCVIKaW1wb3J0Tm90'
    'ZQ==');

@$core.Deprecated('Use openRecordResponseDescriptor instead')
const OpenRecordResponse$json = {
  '1': 'OpenRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Record',
      '10': 'record'
    },
  ],
};

/// Descriptor for `OpenRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openRecordResponseDescriptor = $convert.base64Decode(
    'ChJPcGVuUmVjb3JkUmVzcG9uc2USOQoGcmVjb3JkGAEgASgLMiEuaGVhbHRoY2FyZS5hbmFlc3'
    'RoZXNpYS52MS5SZWNvcmRSBnJlY29yZA==');

@$core.Deprecated('Use getRecordRequestDescriptor instead')
const GetRecordRequest$json = {
  '1': 'GetRecordRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordRequestDescriptor = $convert.base64Decode(
    'ChBHZXRSZWNvcmRSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQ=');

@$core.Deprecated('Use getRecordResponseDescriptor instead')
const GetRecordResponse$json = {
  '1': 'GetRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Record',
      '10': 'record'
    },
  ],
};

/// Descriptor for `GetRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordResponseDescriptor = $convert.base64Decode(
    'ChFHZXRSZWNvcmRSZXNwb25zZRI5CgZyZWNvcmQYASABKAsyIS5oZWFsdGhjYXJlLmFuYWVzdG'
    'hlc2lhLnYxLlJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use getRecordForCaseRequestDescriptor instead')
const GetRecordForCaseRequest$json = {
  '1': 'GetRecordForCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetRecordForCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordForCaseRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRSZWNvcmRGb3JDYXNlUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getRecordForCaseResponseDescriptor instead')
const GetRecordForCaseResponse$json = {
  '1': 'GetRecordForCaseResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Record',
      '10': 'record'
    },
  ],
};

/// Descriptor for `GetRecordForCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecordForCaseResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRSZWNvcmRGb3JDYXNlUmVzcG9uc2USOQoGcmVjb3JkGAEgASgLMiEuaGVhbHRoY2FyZS'
        '5hbmFlc3RoZXNpYS52MS5SZWNvcmRSBnJlY29yZA==');

@$core.Deprecated('Use chartVitalRequestDescriptor instead')
const ChartVitalRequest$json = {
  '1': 'ChartVitalRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 3, '4': 1, '5': 9, '10': 'display'},
    {'1': 'value', '3': 4, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'source',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'source'
    },
    {
      '1': 'device',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DeviceLink',
      '10': 'device'
    },
    {
      '1': 'observed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
};

/// Descriptor for `ChartVitalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartVitalRequestDescriptor = $convert.base64Decode(
    'ChFDaGFydFZpdGFsUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhIKBGNvZG'
    'UYAiABKAlSBGNvZGUSGAoHZGlzcGxheRgDIAEoCVIHZGlzcGxheRIUCgV2YWx1ZRgEIAEoAVIF'
    'dmFsdWUSEgoEdW5pdBgFIAEoCVIEdW5pdBI+CgZzb3VyY2UYBiABKA4yJi5oZWFsdGhjYXJlLm'
    'FuYWVzdGhlc2lhLnYxLkVudHJ5U291cmNlUgZzb3VyY2USPQoGZGV2aWNlGAcgASgLMiUuaGVh'
    'bHRoY2FyZS5hbmFlc3RoZXNpYS52MS5EZXZpY2VMaW5rUgZkZXZpY2USOwoLb2JzZXJ2ZWRfYX'
    'QYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0');

@$core.Deprecated('Use chartVitalResponseDescriptor instead')
const ChartVitalResponse$json = {
  '1': 'ChartVitalResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.VitalEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `ChartVitalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartVitalResponseDescriptor = $convert.base64Decode(
    'ChJDaGFydFZpdGFsUmVzcG9uc2USOwoFZW50cnkYASABKAsyJS5oZWFsdGhjYXJlLmFuYWVzdG'
    'hlc2lhLnYxLlZpdGFsRW50cnlSBWVudHJ5');

@$core.Deprecated('Use listVitalsRequestDescriptor instead')
const ListVitalsRequest$json = {
  '1': 'ListVitalsRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
  ],
};

/// Descriptor for `ListVitalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVitalsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0Vml0YWxzUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhIKBGNvZG'
    'UYAiABKAlSBGNvZGU=');

@$core.Deprecated('Use listVitalsResponseDescriptor instead')
const ListVitalsResponse$json = {
  '1': 'ListVitalsResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.VitalEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ListVitalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVitalsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0Vml0YWxzUmVzcG9uc2USPwoHZW50cmllcxgBIAMoCzIlLmhlYWx0aGNhcmUuYW5hZX'
    'N0aGVzaWEudjEuVml0YWxFbnRyeVIHZW50cmllcw==');

@$core.Deprecated('Use chartDrugRequestDescriptor instead')
const ChartDrugRequest$json = {
  '1': 'ChartDrugRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'drug_code', '3': 2, '4': 1, '5': 9, '10': 'drugCode'},
    {'1': 'drug_display', '3': 3, '4': 1, '5': 9, '10': 'drugDisplay'},
    {'1': 'route', '3': 4, '4': 1, '5': 9, '10': 'route'},
    {'1': 'dose', '3': 5, '4': 1, '5': 1, '10': 'dose'},
    {'1': 'dose_unit', '3': 6, '4': 1, '5': 9, '10': 'doseUnit'},
    {
      '1': 'concentration_amount',
      '3': 7,
      '4': 1,
      '5': 1,
      '10': 'concentrationAmount'
    },
    {
      '1': 'concentration_unit',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'concentrationUnit'
    },
    {
      '1': 'concentration_volume',
      '3': 9,
      '4': 1,
      '5': 1,
      '10': 'concentrationVolume'
    },
    {'1': 'rate_ml_per_hour', '3': 10, '4': 1, '5': 1, '10': 'rateMlPerHour'},
    {'1': 'infusion', '3': 11, '4': 1, '5': 8, '10': 'infusion'},
    {
      '1': 'source',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.EntrySource',
      '10': 'source'
    },
    {
      '1': 'device',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DeviceLink',
      '10': 'device'
    },
    {
      '1': 'given_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {'1': 'note', '3': 15, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_unit', '3': 16, '4': 1, '5': 9, '10': 'expectedUnit'},
    {
      '1': 'acknowledged_mismatch',
      '3': 17,
      '4': 1,
      '5': 8,
      '10': 'acknowledgedMismatch'
    },
  ],
};

/// Descriptor for `ChartDrugRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartDrugRequestDescriptor = $convert.base64Decode(
    'ChBDaGFydERydWdSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSGwoJZHJ1Z1'
    '9jb2RlGAIgASgJUghkcnVnQ29kZRIhCgxkcnVnX2Rpc3BsYXkYAyABKAlSC2RydWdEaXNwbGF5'
    'EhQKBXJvdXRlGAQgASgJUgVyb3V0ZRISCgRkb3NlGAUgASgBUgRkb3NlEhsKCWRvc2VfdW5pdB'
    'gGIAEoCVIIZG9zZVVuaXQSMQoUY29uY2VudHJhdGlvbl9hbW91bnQYByABKAFSE2NvbmNlbnRy'
    'YXRpb25BbW91bnQSLQoSY29uY2VudHJhdGlvbl91bml0GAggASgJUhFjb25jZW50cmF0aW9uVW'
    '5pdBIxChRjb25jZW50cmF0aW9uX3ZvbHVtZRgJIAEoAVITY29uY2VudHJhdGlvblZvbHVtZRIn'
    'ChByYXRlX21sX3Blcl9ob3VyGAogASgBUg1yYXRlTWxQZXJIb3VyEhoKCGluZnVzaW9uGAsgAS'
    'gIUghpbmZ1c2lvbhI+CgZzb3VyY2UYDCABKA4yJi5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYx'
    'LkVudHJ5U291cmNlUgZzb3VyY2USPQoGZGV2aWNlGA0gASgLMiUuaGVhbHRoY2FyZS5hbmFlc3'
    'RoZXNpYS52MS5EZXZpY2VMaW5rUgZkZXZpY2USNQoIZ2l2ZW5fYXQYDiABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgdnaXZlbkF0EhIKBG5vdGUYDyABKAlSBG5vdGUSIwoNZXhwZW'
    'N0ZWRfdW5pdBgQIAEoCVIMZXhwZWN0ZWRVbml0EjMKFWFja25vd2xlZGdlZF9taXNtYXRjaBgR'
    'IAEoCFIUYWNrbm93bGVkZ2VkTWlzbWF0Y2g=');

@$core.Deprecated('Use chartDrugResponseDescriptor instead')
const ChartDrugResponse$json = {
  '1': 'ChartDrugResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DrugEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `ChartDrugResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartDrugResponseDescriptor = $convert.base64Decode(
    'ChFDaGFydERydWdSZXNwb25zZRI6CgVlbnRyeRgBIAEoCzIkLmhlYWx0aGNhcmUuYW5hZXN0aG'
    'VzaWEudjEuRHJ1Z0VudHJ5UgVlbnRyeQ==');

@$core.Deprecated('Use listDrugsRequestDescriptor instead')
const ListDrugsRequest$json = {
  '1': 'ListDrugsRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `ListDrugsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrugsRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0RHJ1Z3NSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQ=');

@$core.Deprecated('Use listDrugsResponseDescriptor instead')
const ListDrugsResponse$json = {
  '1': 'ListDrugsResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DrugEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ListDrugsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDrugsResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0RHJ1Z3NSZXNwb25zZRI+CgdlbnRyaWVzGAEgAygLMiQuaGVhbHRoY2FyZS5hbmFlc3'
    'RoZXNpYS52MS5EcnVnRW50cnlSB2VudHJpZXM=');

@$core.Deprecated('Use stopInfusionRequestDescriptor instead')
const StopInfusionRequest$json = {
  '1': 'StopInfusionRequest',
  '2': [
    {'1': 'drug_id', '3': 1, '4': 1, '5': 9, '10': 'drugId'},
    {
      '1': 'stopped_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
  ],
};

/// Descriptor for `StopInfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopInfusionRequestDescriptor = $convert.base64Decode(
    'ChNTdG9wSW5mdXNpb25SZXF1ZXN0EhcKB2RydWdfaWQYASABKAlSBmRydWdJZBI5CgpzdG9wcG'
    'VkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RvcHBlZEF0');

@$core.Deprecated('Use stopInfusionResponseDescriptor instead')
const StopInfusionResponse$json = {
  '1': 'StopInfusionResponse',
};

/// Descriptor for `StopInfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopInfusionResponseDescriptor =
    $convert.base64Decode('ChRTdG9wSW5mdXNpb25SZXNwb25zZQ==');

@$core.Deprecated('Use recordAirwayRequestDescriptor instead')
const RecordAirwayRequest$json = {
  '1': 'RecordAirwayRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'device', '3': 2, '4': 1, '5': 9, '10': 'device'},
    {'1': 'attempt', '3': 3, '4': 1, '5': 5, '10': 'attempt'},
    {'1': 'grade', '3': 4, '4': 1, '5': 9, '10': 'grade'},
    {'1': 'successful', '3': 5, '4': 1, '5': 8, '10': 'successful'},
    {'1': 'difficulty', '3': 6, '4': 1, '5': 9, '10': 'difficulty'},
    {'1': 'complications', '3': 7, '4': 3, '5': 9, '10': 'complications'},
    {'1': 'adjuncts', '3': 8, '4': 3, '5': 9, '10': 'adjuncts'},
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

/// Descriptor for `RecordAirwayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAirwayRequestDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRBaXJ3YXlSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSFgoGZG'
    'V2aWNlGAIgASgJUgZkZXZpY2USGAoHYXR0ZW1wdBgDIAEoBVIHYXR0ZW1wdBIUCgVncmFkZRgE'
    'IAEoCVIFZ3JhZGUSHgoKc3VjY2Vzc2Z1bBgFIAEoCFIKc3VjY2Vzc2Z1bBIeCgpkaWZmaWN1bH'
    'R5GAYgASgJUgpkaWZmaWN1bHR5EiQKDWNvbXBsaWNhdGlvbnMYByADKAlSDWNvbXBsaWNhdGlv'
    'bnMSGgoIYWRqdW5jdHMYCCADKAlSCGFkanVuY3RzEjsKC29jY3VycmVkX2F0GAkgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdA==');

@$core.Deprecated('Use recordAirwayResponseDescriptor instead')
const RecordAirwayResponse$json = {
  '1': 'RecordAirwayResponse',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.AirwayEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `RecordAirwayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAirwayResponseDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRBaXJ3YXlSZXNwb25zZRI8CgVldmVudBgBIAEoCzImLmhlYWx0aGNhcmUuYW5hZX'
    'N0aGVzaWEudjEuQWlyd2F5RXZlbnRSBWV2ZW50');

@$core.Deprecated('Use getAirwayRequestDescriptor instead')
const GetAirwayRequest$json = {
  '1': 'GetAirwayRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetAirwayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAirwayRequestDescriptor = $convert.base64Decode(
    'ChBHZXRBaXJ3YXlSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQ=');

@$core.Deprecated('Use getAirwayResponseDescriptor instead')
const GetAirwayResponse$json = {
  '1': 'GetAirwayResponse',
  '2': [
    {
      '1': 'airway',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DifficultAirway',
      '10': 'airway'
    },
    {
      '1': 'events',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.AirwayEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `GetAirwayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAirwayResponseDescriptor = $convert.base64Decode(
    'ChFHZXRBaXJ3YXlSZXNwb25zZRJCCgZhaXJ3YXkYASABKAsyKi5oZWFsdGhjYXJlLmFuYWVzdG'
    'hlc2lhLnYxLkRpZmZpY3VsdEFpcndheVIGYWlyd2F5Ej4KBmV2ZW50cxgCIAMoCzImLmhlYWx0'
    'aGNhcmUuYW5hZXN0aGVzaWEudjEuQWlyd2F5RXZlbnRSBmV2ZW50cw==');

@$core.Deprecated('Use getPatientAirwayRequestDescriptor instead')
const GetPatientAirwayRequest$json = {
  '1': 'GetPatientAirwayRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetPatientAirwayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientAirwayRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRQYXRpZW50QWlyd2F5UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
        'QSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getPatientAirwayResponseDescriptor instead')
const GetPatientAirwayResponse$json = {
  '1': 'GetPatientAirwayResponse',
  '2': [
    {
      '1': 'airway',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DifficultAirway',
      '10': 'airway'
    },
  ],
};

/// Descriptor for `GetPatientAirwayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientAirwayResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRQYXRpZW50QWlyd2F5UmVzcG9uc2USQgoGYWlyd2F5GAEgASgLMiouaGVhbHRoY2FyZS'
        '5hbmFlc3RoZXNpYS52MS5EaWZmaWN1bHRBaXJ3YXlSBmFpcndheQ==');

@$core.Deprecated('Use chartFluidRequestDescriptor instead')
const ChartFluidRequest$json = {
  '1': 'ChartFluidRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'direction',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.anaesthesia.v1.FluidDirection',
      '10': 'direction'
    },
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {'1': 'volume_ml', '3': 5, '4': 1, '5': 1, '10': 'volumeMl'},
    {'1': 'product_id', '3': 6, '4': 1, '5': 9, '10': 'productId'},
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

/// Descriptor for `ChartFluidRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartFluidRequestDescriptor = $convert.base64Decode(
    'ChFDaGFydEZsdWlkUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEkcKCWRpcm'
    'VjdGlvbhgCIAEoDjIpLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuRmx1aWREaXJlY3Rpb25S'
    'CWRpcmVjdGlvbhISCgRraW5kGAMgASgJUgRraW5kEhQKBWxhYmVsGAQgASgJUgVsYWJlbBIbCg'
    'l2b2x1bWVfbWwYBSABKAFSCHZvbHVtZU1sEh0KCnByb2R1Y3RfaWQYBiABKAlSCXByb2R1Y3RJ'
    'ZBI7CgtvY2N1cnJlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3'
    'VycmVkQXQ=');

@$core.Deprecated('Use chartFluidResponseDescriptor instead')
const ChartFluidResponse$json = {
  '1': 'ChartFluidResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.FluidEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `ChartFluidResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartFluidResponseDescriptor = $convert.base64Decode(
    'ChJDaGFydEZsdWlkUmVzcG9uc2USOwoFZW50cnkYASABKAsyJS5oZWFsdGhjYXJlLmFuYWVzdG'
    'hlc2lhLnYxLkZsdWlkRW50cnlSBWVudHJ5');

@$core.Deprecated('Use getBalanceRequestDescriptor instead')
const GetBalanceRequest$json = {
  '1': 'GetBalanceRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceRequestDescriptor = $convert.base64Decode(
    'ChFHZXRCYWxhbmNlUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElk');

@$core.Deprecated('Use getBalanceResponseDescriptor instead')
const GetBalanceResponse$json = {
  '1': 'GetBalanceResponse',
  '2': [
    {
      '1': 'balance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.FluidBalance',
      '10': 'balance'
    },
    {
      '1': 'entries',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.FluidEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBalanceResponseDescriptor = $convert.base64Decode(
    'ChJHZXRCYWxhbmNlUmVzcG9uc2USQQoHYmFsYW5jZRgBIAEoCzInLmhlYWx0aGNhcmUuYW5hZX'
    'N0aGVzaWEudjEuRmx1aWRCYWxhbmNlUgdiYWxhbmNlEj8KB2VudHJpZXMYAiADKAsyJS5oZWFs'
    'dGhjYXJlLmFuYWVzdGhlc2lhLnYxLkZsdWlkRW50cnlSB2VudHJpZXM=');

@$core.Deprecated('Use endAnaesthesiaRequestDescriptor instead')
const EndAnaesthesiaRequest$json = {
  '1': 'EndAnaesthesiaRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
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

/// Descriptor for `EndAnaesthesiaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endAnaesthesiaRequestDescriptor = $convert.base64Decode(
    'ChVFbmRBbmFlc3RoZXNpYVJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBI1Cg'
    'hlbmRlZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZGVkQXQ=');

@$core.Deprecated('Use endAnaesthesiaResponseDescriptor instead')
const EndAnaesthesiaResponse$json = {
  '1': 'EndAnaesthesiaResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Record',
      '10': 'record'
    },
  ],
};

/// Descriptor for `EndAnaesthesiaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endAnaesthesiaResponseDescriptor =
    $convert.base64Decode(
        'ChZFbmRBbmFlc3RoZXNpYVJlc3BvbnNlEjkKBnJlY29yZBgBIAEoCzIhLmhlYWx0aGNhcmUuYW'
        '5hZXN0aGVzaWEudjEuUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use handOverRequestDescriptor instead')
const HandOverRequest$json = {
  '1': 'HandOverRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'to_clinician', '3': 2, '4': 1, '5': 9, '10': 'toClinician'},
    {'1': 'summary', '3': 3, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'concerns', '3': 4, '4': 3, '5': 9, '10': 'concerns'},
    {'1': 'instructions', '3': 5, '4': 3, '5': 9, '10': 'instructions'},
    {'1': 'analgesia_given', '3': 6, '4': 3, '5': 9, '10': 'analgesiaGiven'},
    {'1': 'antiemetic_given', '3': 7, '4': 3, '5': 9, '10': 'antiemeticGiven'},
  ],
};

/// Descriptor for `HandOverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handOverRequestDescriptor = $convert.base64Decode(
    'Cg9IYW5kT3ZlclJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBIhCgx0b19jbG'
    'luaWNpYW4YAiABKAlSC3RvQ2xpbmljaWFuEhgKB3N1bW1hcnkYAyABKAlSB3N1bW1hcnkSGgoI'
    'Y29uY2VybnMYBCADKAlSCGNvbmNlcm5zEiIKDGluc3RydWN0aW9ucxgFIAMoCVIMaW5zdHJ1Y3'
    'Rpb25zEicKD2FuYWxnZXNpYV9naXZlbhgGIAMoCVIOYW5hbGdlc2lhR2l2ZW4SKQoQYW50aWVt'
    'ZXRpY19naXZlbhgHIAMoCVIPYW50aWVtZXRpY0dpdmVu');

@$core.Deprecated('Use handOverResponseDescriptor instead')
const HandOverResponse$json = {
  '1': 'HandOverResponse',
  '2': [
    {
      '1': 'handover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Handover',
      '10': 'handover'
    },
  ],
};

/// Descriptor for `HandOverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handOverResponseDescriptor = $convert.base64Decode(
    'ChBIYW5kT3ZlclJlc3BvbnNlEj8KCGhhbmRvdmVyGAEgASgLMiMuaGVhbHRoY2FyZS5hbmFlc3'
    'RoZXNpYS52MS5IYW5kb3ZlclIIaGFuZG92ZXI=');

@$core.Deprecated('Use listHandoversRequestDescriptor instead')
const ListHandoversRequest$json = {
  '1': 'ListHandoversRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `ListHandoversRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHandoversRequestDescriptor =
    $convert.base64Decode(
        'ChRMaXN0SGFuZG92ZXJzUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElk');

@$core.Deprecated('Use listHandoversResponseDescriptor instead')
const ListHandoversResponse$json = {
  '1': 'ListHandoversResponse',
  '2': [
    {
      '1': 'handovers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Handover',
      '10': 'handovers'
    },
  ],
};

/// Descriptor for `ListHandoversResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHandoversResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0SGFuZG92ZXJzUmVzcG9uc2USQQoJaGFuZG92ZXJzGAEgAygLMiMuaGVhbHRoY2FyZS'
    '5hbmFlc3RoZXNpYS52MS5IYW5kb3ZlclIJaGFuZG92ZXJz');

@$core.Deprecated('Use getRecoveryScaleRequestDescriptor instead')
const GetRecoveryScaleRequest$json = {
  '1': 'GetRecoveryScaleRequest',
};

/// Descriptor for `GetRecoveryScaleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecoveryScaleRequestDescriptor =
    $convert.base64Decode('ChdHZXRSZWNvdmVyeVNjYWxlUmVxdWVzdA==');

@$core.Deprecated('Use getRecoveryScaleResponseDescriptor instead')
const GetRecoveryScaleResponse$json = {
  '1': 'GetRecoveryScaleResponse',
  '2': [
    {
      '1': 'scale',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryScale',
      '10': 'scale'
    },
  ],
};

/// Descriptor for `GetRecoveryScaleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRecoveryScaleResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRSZWNvdmVyeVNjYWxlUmVzcG9uc2USPgoFc2NhbGUYASABKAsyKC5oZWFsdGhjYXJlLm'
        'FuYWVzdGhlc2lhLnYxLlJlY292ZXJ5U2NhbGVSBXNjYWxl');

@$core.Deprecated('Use assessRecoveryRequestDescriptor instead')
const AssessRecoveryRequest$json = {
  '1': 'AssessRecoveryRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'scores',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.AssessRecoveryRequest.ScoresEntry',
      '10': 'scores'
    },
  ],
  '3': [AssessRecoveryRequest_ScoresEntry$json],
};

@$core.Deprecated('Use assessRecoveryRequestDescriptor instead')
const AssessRecoveryRequest_ScoresEntry$json = {
  '1': 'ScoresEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `AssessRecoveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessRecoveryRequestDescriptor = $convert.base64Decode(
    'ChVBc3Nlc3NSZWNvdmVyeVJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBJUCg'
    'ZzY29yZXMYAiADKAsyPC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkFzc2Vzc1JlY292ZXJ5'
    'UmVxdWVzdC5TY29yZXNFbnRyeVIGc2NvcmVzGjkKC1Njb3Jlc0VudHJ5EhAKA2tleRgBIAEoCV'
    'IDa2V5EhQKBXZhbHVlGAIgASgFUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use assessRecoveryResponseDescriptor instead')
const AssessRecoveryResponse$json = {
  '1': 'AssessRecoveryResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `AssessRecoveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessRecoveryResponseDescriptor =
    $convert.base64Decode(
        'ChZBc3Nlc3NSZWNvdmVyeVJlc3BvbnNlEk0KCmFzc2Vzc21lbnQYASABKAsyLS5oZWFsdGhjYX'
        'JlLmFuYWVzdGhlc2lhLnYxLlJlY292ZXJ5QXNzZXNzbWVudFIKYXNzZXNzbWVudA==');

@$core.Deprecated('Use listRecoveryAssessmentsRequestDescriptor instead')
const ListRecoveryAssessmentsRequest$json = {
  '1': 'ListRecoveryAssessmentsRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `ListRecoveryAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecoveryAssessmentsRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0UmVjb3ZlcnlBc3Nlc3NtZW50c1JlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZW'
        'NvcmRJZA==');

@$core.Deprecated('Use listRecoveryAssessmentsResponseDescriptor instead')
const ListRecoveryAssessmentsResponse$json = {
  '1': 'ListRecoveryAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.RecoveryAssessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListRecoveryAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRecoveryAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0UmVjb3ZlcnlBc3Nlc3NtZW50c1Jlc3BvbnNlEk8KC2Fzc2Vzc21lbnRzGAEgAygLMi'
        '0uaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5SZWNvdmVyeUFzc2Vzc21lbnRSC2Fzc2Vzc21l'
        'bnRz');

@$core.Deprecated('Use evaluateDischargeRequestDescriptor instead')
const EvaluateDischargeRequest$json = {
  '1': 'EvaluateDischargeRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `EvaluateDischargeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateDischargeRequestDescriptor =
    $convert.base64Decode(
        'ChhFdmFsdWF0ZURpc2NoYXJnZVJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZA'
        '==');

@$core.Deprecated('Use evaluateDischargeResponseDescriptor instead')
const EvaluateDischargeResponse$json = {
  '1': 'EvaluateDischargeResponse',
  '2': [
    {
      '1': 'decision',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.DischargeDecision',
      '10': 'decision'
    },
  ],
};

/// Descriptor for `EvaluateDischargeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateDischargeResponseDescriptor =
    $convert.base64Decode(
        'ChlFdmFsdWF0ZURpc2NoYXJnZVJlc3BvbnNlEkgKCGRlY2lzaW9uGAEgASgLMiwuaGVhbHRoY2'
        'FyZS5hbmFlc3RoZXNpYS52MS5EaXNjaGFyZ2VEZWNpc2lvblIIZGVjaXNpb24=');

@$core.Deprecated('Use dischargeFromRecoveryRequestDescriptor instead')
const DischargeFromRecoveryRequest$json = {
  '1': 'DischargeFromRecoveryRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'destination', '3': 2, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'override_reason', '3': 3, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `DischargeFromRecoveryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeFromRecoveryRequestDescriptor =
    $convert.base64Decode(
        'ChxEaXNjaGFyZ2VGcm9tUmVjb3ZlcnlSZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3'
        'JkSWQSIAoLZGVzdGluYXRpb24YAiABKAlSC2Rlc3RpbmF0aW9uEicKD292ZXJyaWRlX3JlYXNv'
        'bhgDIAEoCVIOb3ZlcnJpZGVSZWFzb24=');

@$core.Deprecated('Use dischargeFromRecoveryResponseDescriptor instead')
const DischargeFromRecoveryResponse$json = {
  '1': 'DischargeFromRecoveryResponse',
  '2': [
    {
      '1': 'discharge',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Discharge',
      '10': 'discharge'
    },
  ],
};

/// Descriptor for `DischargeFromRecoveryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeFromRecoveryResponseDescriptor =
    $convert.base64Decode(
        'Ch1EaXNjaGFyZ2VGcm9tUmVjb3ZlcnlSZXNwb25zZRJCCglkaXNjaGFyZ2UYASABKAsyJC5oZW'
        'FsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkRpc2NoYXJnZVIJZGlzY2hhcmdl');

@$core.Deprecated('Use orderPainRequestDescriptor instead')
const OrderPainRequest$json = {
  '1': 'OrderPainRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'modality', '3': 2, '4': 1, '5': 9, '10': 'modality'},
    {'1': 'prescription_ids', '3': 3, '4': 3, '5': 9, '10': 'prescriptionIds'},
    {'1': 'target_score', '3': 4, '4': 1, '5': 9, '10': 'targetScore'},
    {'1': 'monitoring', '3': 5, '4': 3, '5': 9, '10': 'monitoring'},
    {'1': 'escalation', '3': 6, '4': 1, '5': 9, '10': 'escalation'},
    {
      '1': 'review_by',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewBy'
    },
  ],
};

/// Descriptor for `OrderPainRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderPainRequestDescriptor = $convert.base64Decode(
    'ChBPcmRlclBhaW5SZXF1ZXN0EhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSGgoIbW9kYW'
    'xpdHkYAiABKAlSCG1vZGFsaXR5EikKEHByZXNjcmlwdGlvbl9pZHMYAyADKAlSD3ByZXNjcmlw'
    'dGlvbklkcxIhCgx0YXJnZXRfc2NvcmUYBCABKAlSC3RhcmdldFNjb3JlEh4KCm1vbml0b3Jpbm'
    'cYBSADKAlSCm1vbml0b3JpbmcSHgoKZXNjYWxhdGlvbhgGIAEoCVIKZXNjYWxhdGlvbhI3Cgly'
    'ZXZpZXdfYnkYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghyZXZpZXdCeQ==');

@$core.Deprecated('Use orderPainResponseDescriptor instead')
const OrderPainResponse$json = {
  '1': 'OrderPainResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.PainOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `OrderPainResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List orderPainResponseDescriptor = $convert.base64Decode(
    'ChFPcmRlclBhaW5SZXNwb25zZRI6CgVvcmRlchgBIAEoCzIkLmhlYWx0aGNhcmUuYW5hZXN0aG'
    'VzaWEudjEuUGFpbk9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use listPainOrdersRequestDescriptor instead')
const ListPainOrdersRequest$json = {
  '1': 'ListPainOrdersRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `ListPainOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPainOrdersRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0UGFpbk9yZGVyc1JlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZA==');

@$core.Deprecated('Use listPainOrdersResponseDescriptor instead')
const ListPainOrdersResponse$json = {
  '1': 'ListPainOrdersResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.PainOrder',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `ListPainOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPainOrdersResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UGFpbk9yZGVyc1Jlc3BvbnNlEjwKBm9yZGVycxgBIAMoCzIkLmhlYWx0aGNhcmUuYW'
        '5hZXN0aGVzaWEudjEuUGFpbk9yZGVyUgZvcmRlcnM=');

@$core.Deprecated('Use getPainRoundRequestDescriptor instead')
const GetPainRoundRequest$json = {
  '1': 'GetPainRoundRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetPainRoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPainRoundRequestDescriptor =
    $convert.base64Decode(
        'ChNHZXRQYWluUm91bmRSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use getPainRoundResponseDescriptor instead')
const GetPainRoundResponse$json = {
  '1': 'GetPainRoundResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.PainOrder',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `GetPainRoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPainRoundResponseDescriptor = $convert.base64Decode(
    'ChRHZXRQYWluUm91bmRSZXNwb25zZRI8CgZvcmRlcnMYASADKAsyJC5oZWFsdGhjYXJlLmFuYW'
    'VzdGhlc2lhLnYxLlBhaW5PcmRlclIGb3JkZXJz');

@$core.Deprecated('Use stopPainRequestDescriptor instead')
const StopPainRequest$json = {
  '1': 'StopPainRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'stopped_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
  ],
};

/// Descriptor for `StopPainRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopPainRequestDescriptor = $convert.base64Decode(
    'Cg9TdG9wUGFpblJlcXVlc3QSGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSOQoKc3RvcHBlZF'
    '9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0b3BwZWRBdA==');

@$core.Deprecated('Use stopPainResponseDescriptor instead')
const StopPainResponse$json = {
  '1': 'StopPainResponse',
};

/// Descriptor for `StopPainResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopPainResponseDescriptor =
    $convert.base64Decode('ChBTdG9wUGFpblJlc3BvbnNl');

@$core.Deprecated('Use getSummaryRequestDescriptor instead')
const GetSummaryRequest$json = {
  '1': 'GetSummaryRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSummaryRequestDescriptor = $convert.base64Decode(
    'ChFHZXRTdW1tYXJ5UmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElk');

@$core.Deprecated('Use getSummaryResponseDescriptor instead')
const GetSummaryResponse$json = {
  '1': 'GetSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.anaesthesia.v1.Summary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `GetSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSummaryResponseDescriptor = $convert.base64Decode(
    'ChJHZXRTdW1tYXJ5UmVzcG9uc2USPAoHc3VtbWFyeRgBIAEoCzIiLmhlYWx0aGNhcmUuYW5hZX'
    'N0aGVzaWEudjEuU3VtbWFyeVIHc3VtbWFyeQ==');

const $core.Map<$core.String, $core.dynamic> AnaesthesiaServiceBase$json = {
  '1': 'AnaesthesiaService',
  '2': [
    {
      '1': 'RecordAssessment',
      '2': '.healthcare.anaesthesia.v1.RecordAssessmentRequest',
      '3': '.healthcare.anaesthesia.v1.RecordAssessmentResponse'
    },
    {
      '1': 'ListAssessments',
      '2': '.healthcare.anaesthesia.v1.ListAssessmentsRequest',
      '3': '.healthcare.anaesthesia.v1.ListAssessmentsResponse'
    },
    {
      '1': 'ListPatientAssessments',
      '2': '.healthcare.anaesthesia.v1.ListPatientAssessmentsRequest',
      '3': '.healthcare.anaesthesia.v1.ListPatientAssessmentsResponse'
    },
    {
      '1': 'RecordPlan',
      '2': '.healthcare.anaesthesia.v1.RecordPlanRequest',
      '3': '.healthcare.anaesthesia.v1.RecordPlanResponse'
    },
    {
      '1': 'GetPlan',
      '2': '.healthcare.anaesthesia.v1.GetPlanRequest',
      '3': '.healthcare.anaesthesia.v1.GetPlanResponse'
    },
    {
      '1': 'GetReadiness',
      '2': '.healthcare.anaesthesia.v1.GetReadinessRequest',
      '3': '.healthcare.anaesthesia.v1.GetReadinessResponse'
    },
    {
      '1': 'OpenRecord',
      '2': '.healthcare.anaesthesia.v1.OpenRecordRequest',
      '3': '.healthcare.anaesthesia.v1.OpenRecordResponse'
    },
    {
      '1': 'GetRecord',
      '2': '.healthcare.anaesthesia.v1.GetRecordRequest',
      '3': '.healthcare.anaesthesia.v1.GetRecordResponse'
    },
    {
      '1': 'GetRecordForCase',
      '2': '.healthcare.anaesthesia.v1.GetRecordForCaseRequest',
      '3': '.healthcare.anaesthesia.v1.GetRecordForCaseResponse'
    },
    {
      '1': 'EndAnaesthesia',
      '2': '.healthcare.anaesthesia.v1.EndAnaesthesiaRequest',
      '3': '.healthcare.anaesthesia.v1.EndAnaesthesiaResponse'
    },
    {
      '1': 'ChartVital',
      '2': '.healthcare.anaesthesia.v1.ChartVitalRequest',
      '3': '.healthcare.anaesthesia.v1.ChartVitalResponse'
    },
    {
      '1': 'ListVitals',
      '2': '.healthcare.anaesthesia.v1.ListVitalsRequest',
      '3': '.healthcare.anaesthesia.v1.ListVitalsResponse'
    },
    {
      '1': 'ChartDrug',
      '2': '.healthcare.anaesthesia.v1.ChartDrugRequest',
      '3': '.healthcare.anaesthesia.v1.ChartDrugResponse'
    },
    {
      '1': 'ListDrugs',
      '2': '.healthcare.anaesthesia.v1.ListDrugsRequest',
      '3': '.healthcare.anaesthesia.v1.ListDrugsResponse'
    },
    {
      '1': 'StopInfusion',
      '2': '.healthcare.anaesthesia.v1.StopInfusionRequest',
      '3': '.healthcare.anaesthesia.v1.StopInfusionResponse'
    },
    {
      '1': 'RecordAirway',
      '2': '.healthcare.anaesthesia.v1.RecordAirwayRequest',
      '3': '.healthcare.anaesthesia.v1.RecordAirwayResponse'
    },
    {
      '1': 'GetAirway',
      '2': '.healthcare.anaesthesia.v1.GetAirwayRequest',
      '3': '.healthcare.anaesthesia.v1.GetAirwayResponse'
    },
    {
      '1': 'GetPatientAirway',
      '2': '.healthcare.anaesthesia.v1.GetPatientAirwayRequest',
      '3': '.healthcare.anaesthesia.v1.GetPatientAirwayResponse'
    },
    {
      '1': 'ChartFluid',
      '2': '.healthcare.anaesthesia.v1.ChartFluidRequest',
      '3': '.healthcare.anaesthesia.v1.ChartFluidResponse'
    },
    {
      '1': 'GetBalance',
      '2': '.healthcare.anaesthesia.v1.GetBalanceRequest',
      '3': '.healthcare.anaesthesia.v1.GetBalanceResponse'
    },
    {
      '1': 'HandOver',
      '2': '.healthcare.anaesthesia.v1.HandOverRequest',
      '3': '.healthcare.anaesthesia.v1.HandOverResponse'
    },
    {
      '1': 'ListHandovers',
      '2': '.healthcare.anaesthesia.v1.ListHandoversRequest',
      '3': '.healthcare.anaesthesia.v1.ListHandoversResponse'
    },
    {
      '1': 'GetRecoveryScale',
      '2': '.healthcare.anaesthesia.v1.GetRecoveryScaleRequest',
      '3': '.healthcare.anaesthesia.v1.GetRecoveryScaleResponse'
    },
    {
      '1': 'AssessRecovery',
      '2': '.healthcare.anaesthesia.v1.AssessRecoveryRequest',
      '3': '.healthcare.anaesthesia.v1.AssessRecoveryResponse'
    },
    {
      '1': 'ListRecoveryAssessments',
      '2': '.healthcare.anaesthesia.v1.ListRecoveryAssessmentsRequest',
      '3': '.healthcare.anaesthesia.v1.ListRecoveryAssessmentsResponse'
    },
    {
      '1': 'EvaluateDischarge',
      '2': '.healthcare.anaesthesia.v1.EvaluateDischargeRequest',
      '3': '.healthcare.anaesthesia.v1.EvaluateDischargeResponse'
    },
    {
      '1': 'DischargeFromRecovery',
      '2': '.healthcare.anaesthesia.v1.DischargeFromRecoveryRequest',
      '3': '.healthcare.anaesthesia.v1.DischargeFromRecoveryResponse'
    },
    {
      '1': 'OrderPain',
      '2': '.healthcare.anaesthesia.v1.OrderPainRequest',
      '3': '.healthcare.anaesthesia.v1.OrderPainResponse'
    },
    {
      '1': 'ListPainOrders',
      '2': '.healthcare.anaesthesia.v1.ListPainOrdersRequest',
      '3': '.healthcare.anaesthesia.v1.ListPainOrdersResponse'
    },
    {
      '1': 'GetPainRound',
      '2': '.healthcare.anaesthesia.v1.GetPainRoundRequest',
      '3': '.healthcare.anaesthesia.v1.GetPainRoundResponse'
    },
    {
      '1': 'StopPain',
      '2': '.healthcare.anaesthesia.v1.StopPainRequest',
      '3': '.healthcare.anaesthesia.v1.StopPainResponse'
    },
    {
      '1': 'GetSummary',
      '2': '.healthcare.anaesthesia.v1.GetSummaryRequest',
      '3': '.healthcare.anaesthesia.v1.GetSummaryResponse'
    },
  ],
};

@$core.Deprecated('Use anaesthesiaServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AnaesthesiaServiceBase$messageJson = {
  '.healthcare.anaesthesia.v1.RecordAssessmentRequest':
      RecordAssessmentRequest$json,
  '.healthcare.anaesthesia.v1.AirwayAssessment': AirwayAssessment$json,
  '.healthcare.anaesthesia.v1.RecordAssessmentResponse':
      RecordAssessmentResponse$json,
  '.healthcare.anaesthesia.v1.Assessment': Assessment$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.anaesthesia.v1.ListAssessmentsRequest':
      ListAssessmentsRequest$json,
  '.healthcare.anaesthesia.v1.ListAssessmentsResponse':
      ListAssessmentsResponse$json,
  '.healthcare.anaesthesia.v1.ListPatientAssessmentsRequest':
      ListPatientAssessmentsRequest$json,
  '.healthcare.anaesthesia.v1.ListPatientAssessmentsResponse':
      ListPatientAssessmentsResponse$json,
  '.healthcare.anaesthesia.v1.RecordPlanRequest': RecordPlanRequest$json,
  '.healthcare.anaesthesia.v1.RecordPlanResponse': RecordPlanResponse$json,
  '.healthcare.anaesthesia.v1.Plan': Plan$json,
  '.healthcare.anaesthesia.v1.GetPlanRequest': GetPlanRequest$json,
  '.healthcare.anaesthesia.v1.GetPlanResponse': GetPlanResponse$json,
  '.healthcare.anaesthesia.v1.GetReadinessRequest': GetReadinessRequest$json,
  '.healthcare.anaesthesia.v1.GetReadinessResponse': GetReadinessResponse$json,
  '.healthcare.anaesthesia.v1.Readiness': Readiness$json,
  '.healthcare.anaesthesia.v1.OpenRecordRequest': OpenRecordRequest$json,
  '.healthcare.anaesthesia.v1.OpenRecordResponse': OpenRecordResponse$json,
  '.healthcare.anaesthesia.v1.Record': Record$json,
  '.healthcare.anaesthesia.v1.GetRecordRequest': GetRecordRequest$json,
  '.healthcare.anaesthesia.v1.GetRecordResponse': GetRecordResponse$json,
  '.healthcare.anaesthesia.v1.GetRecordForCaseRequest':
      GetRecordForCaseRequest$json,
  '.healthcare.anaesthesia.v1.GetRecordForCaseResponse':
      GetRecordForCaseResponse$json,
  '.healthcare.anaesthesia.v1.EndAnaesthesiaRequest':
      EndAnaesthesiaRequest$json,
  '.healthcare.anaesthesia.v1.EndAnaesthesiaResponse':
      EndAnaesthesiaResponse$json,
  '.healthcare.anaesthesia.v1.ChartVitalRequest': ChartVitalRequest$json,
  '.healthcare.anaesthesia.v1.DeviceLink': DeviceLink$json,
  '.healthcare.anaesthesia.v1.ChartVitalResponse': ChartVitalResponse$json,
  '.healthcare.anaesthesia.v1.VitalEntry': VitalEntry$json,
  '.healthcare.anaesthesia.v1.ListVitalsRequest': ListVitalsRequest$json,
  '.healthcare.anaesthesia.v1.ListVitalsResponse': ListVitalsResponse$json,
  '.healthcare.anaesthesia.v1.ChartDrugRequest': ChartDrugRequest$json,
  '.healthcare.anaesthesia.v1.ChartDrugResponse': ChartDrugResponse$json,
  '.healthcare.anaesthesia.v1.DrugEntry': DrugEntry$json,
  '.healthcare.anaesthesia.v1.ListDrugsRequest': ListDrugsRequest$json,
  '.healthcare.anaesthesia.v1.ListDrugsResponse': ListDrugsResponse$json,
  '.healthcare.anaesthesia.v1.StopInfusionRequest': StopInfusionRequest$json,
  '.healthcare.anaesthesia.v1.StopInfusionResponse': StopInfusionResponse$json,
  '.healthcare.anaesthesia.v1.RecordAirwayRequest': RecordAirwayRequest$json,
  '.healthcare.anaesthesia.v1.RecordAirwayResponse': RecordAirwayResponse$json,
  '.healthcare.anaesthesia.v1.AirwayEvent': AirwayEvent$json,
  '.healthcare.anaesthesia.v1.GetAirwayRequest': GetAirwayRequest$json,
  '.healthcare.anaesthesia.v1.GetAirwayResponse': GetAirwayResponse$json,
  '.healthcare.anaesthesia.v1.DifficultAirway': DifficultAirway$json,
  '.healthcare.anaesthesia.v1.GetPatientAirwayRequest':
      GetPatientAirwayRequest$json,
  '.healthcare.anaesthesia.v1.GetPatientAirwayResponse':
      GetPatientAirwayResponse$json,
  '.healthcare.anaesthesia.v1.ChartFluidRequest': ChartFluidRequest$json,
  '.healthcare.anaesthesia.v1.ChartFluidResponse': ChartFluidResponse$json,
  '.healthcare.anaesthesia.v1.FluidEntry': FluidEntry$json,
  '.healthcare.anaesthesia.v1.GetBalanceRequest': GetBalanceRequest$json,
  '.healthcare.anaesthesia.v1.GetBalanceResponse': GetBalanceResponse$json,
  '.healthcare.anaesthesia.v1.FluidBalance': FluidBalance$json,
  '.healthcare.anaesthesia.v1.HandOverRequest': HandOverRequest$json,
  '.healthcare.anaesthesia.v1.HandOverResponse': HandOverResponse$json,
  '.healthcare.anaesthesia.v1.Handover': Handover$json,
  '.healthcare.anaesthesia.v1.ListHandoversRequest': ListHandoversRequest$json,
  '.healthcare.anaesthesia.v1.ListHandoversResponse':
      ListHandoversResponse$json,
  '.healthcare.anaesthesia.v1.GetRecoveryScaleRequest':
      GetRecoveryScaleRequest$json,
  '.healthcare.anaesthesia.v1.GetRecoveryScaleResponse':
      GetRecoveryScaleResponse$json,
  '.healthcare.anaesthesia.v1.RecoveryScale': RecoveryScale$json,
  '.healthcare.anaesthesia.v1.ScoreComponent': ScoreComponent$json,
  '.healthcare.anaesthesia.v1.AssessRecoveryRequest':
      AssessRecoveryRequest$json,
  '.healthcare.anaesthesia.v1.AssessRecoveryRequest.ScoresEntry':
      AssessRecoveryRequest_ScoresEntry$json,
  '.healthcare.anaesthesia.v1.AssessRecoveryResponse':
      AssessRecoveryResponse$json,
  '.healthcare.anaesthesia.v1.RecoveryAssessment': RecoveryAssessment$json,
  '.healthcare.anaesthesia.v1.RecoveryAssessment.ScoresEntry':
      RecoveryAssessment_ScoresEntry$json,
  '.healthcare.anaesthesia.v1.ListRecoveryAssessmentsRequest':
      ListRecoveryAssessmentsRequest$json,
  '.healthcare.anaesthesia.v1.ListRecoveryAssessmentsResponse':
      ListRecoveryAssessmentsResponse$json,
  '.healthcare.anaesthesia.v1.EvaluateDischargeRequest':
      EvaluateDischargeRequest$json,
  '.healthcare.anaesthesia.v1.EvaluateDischargeResponse':
      EvaluateDischargeResponse$json,
  '.healthcare.anaesthesia.v1.DischargeDecision': DischargeDecision$json,
  '.healthcare.anaesthesia.v1.DischargeFromRecoveryRequest':
      DischargeFromRecoveryRequest$json,
  '.healthcare.anaesthesia.v1.DischargeFromRecoveryResponse':
      DischargeFromRecoveryResponse$json,
  '.healthcare.anaesthesia.v1.Discharge': Discharge$json,
  '.healthcare.anaesthesia.v1.OrderPainRequest': OrderPainRequest$json,
  '.healthcare.anaesthesia.v1.OrderPainResponse': OrderPainResponse$json,
  '.healthcare.anaesthesia.v1.PainOrder': PainOrder$json,
  '.healthcare.anaesthesia.v1.ListPainOrdersRequest':
      ListPainOrdersRequest$json,
  '.healthcare.anaesthesia.v1.ListPainOrdersResponse':
      ListPainOrdersResponse$json,
  '.healthcare.anaesthesia.v1.GetPainRoundRequest': GetPainRoundRequest$json,
  '.healthcare.anaesthesia.v1.GetPainRoundResponse': GetPainRoundResponse$json,
  '.healthcare.anaesthesia.v1.StopPainRequest': StopPainRequest$json,
  '.healthcare.anaesthesia.v1.StopPainResponse': StopPainResponse$json,
  '.healthcare.anaesthesia.v1.GetSummaryRequest': GetSummaryRequest$json,
  '.healthcare.anaesthesia.v1.GetSummaryResponse': GetSummaryResponse$json,
  '.healthcare.anaesthesia.v1.Summary': Summary$json,
};

/// Descriptor for `AnaesthesiaService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List anaesthesiaServiceDescriptor = $convert.base64Decode(
    'ChJBbmFlc3RoZXNpYVNlcnZpY2USewoQUmVjb3JkQXNzZXNzbWVudBIyLmhlYWx0aGNhcmUuYW'
    '5hZXN0aGVzaWEudjEuUmVjb3JkQXNzZXNzbWVudFJlcXVlc3QaMy5oZWFsdGhjYXJlLmFuYWVz'
    'dGhlc2lhLnYxLlJlY29yZEFzc2Vzc21lbnRSZXNwb25zZRJ4Cg9MaXN0QXNzZXNzbWVudHMSMS'
    '5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkxpc3RBc3Nlc3NtZW50c1JlcXVlc3QaMi5oZWFs'
    'dGhjYXJlLmFuYWVzdGhlc2lhLnYxLkxpc3RBc3Nlc3NtZW50c1Jlc3BvbnNlEo0BChZMaXN0UG'
    'F0aWVudEFzc2Vzc21lbnRzEjguaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0UGF0aWVu'
    'dEFzc2Vzc21lbnRzUmVxdWVzdBo5LmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuTGlzdFBhdG'
    'llbnRBc3Nlc3NtZW50c1Jlc3BvbnNlEmkKClJlY29yZFBsYW4SLC5oZWFsdGhjYXJlLmFuYWVz'
    'dGhlc2lhLnYxLlJlY29yZFBsYW5SZXF1ZXN0Gi0uaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS'
    '5SZWNvcmRQbGFuUmVzcG9uc2USYAoHR2V0UGxhbhIpLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEu'
    'djEuR2V0UGxhblJlcXVlc3QaKi5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkdldFBsYW5SZX'
    'Nwb25zZRJvCgxHZXRSZWFkaW5lc3MSLi5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkdldFJl'
    'YWRpbmVzc1JlcXVlc3QaLy5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkdldFJlYWRpbmVzc1'
    'Jlc3BvbnNlEmkKCk9wZW5SZWNvcmQSLC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLk9wZW5S'
    'ZWNvcmRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5PcGVuUmVjb3JkUmVzcG'
    '9uc2USZgoJR2V0UmVjb3JkEisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRSZWNvcmRS'
    'ZXF1ZXN0GiwuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRSZWNvcmRSZXNwb25zZRJ7Ch'
    'BHZXRSZWNvcmRGb3JDYXNlEjIuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRSZWNvcmRG'
    'b3JDYXNlUmVxdWVzdBozLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0UmVjb3JkRm9yQ2'
    'FzZVJlc3BvbnNlEnUKDkVuZEFuYWVzdGhlc2lhEjAuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52'
    'MS5FbmRBbmFlc3RoZXNpYVJlcXVlc3QaMS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkVuZE'
    'FuYWVzdGhlc2lhUmVzcG9uc2USaQoKQ2hhcnRWaXRhbBIsLmhlYWx0aGNhcmUuYW5hZXN0aGVz'
    'aWEudjEuQ2hhcnRWaXRhbFJlcXVlc3QaLS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkNoYX'
    'J0Vml0YWxSZXNwb25zZRJpCgpMaXN0Vml0YWxzEiwuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52'
    'MS5MaXN0Vml0YWxzUmVxdWVzdBotLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuTGlzdFZpdG'
    'Fsc1Jlc3BvbnNlEmYKCUNoYXJ0RHJ1ZxIrLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuQ2hh'
    'cnREcnVnUmVxdWVzdBosLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuQ2hhcnREcnVnUmVzcG'
    '9uc2USZgoJTGlzdERydWdzEisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0RHJ1Z3NS'
    'ZXF1ZXN0GiwuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0RHJ1Z3NSZXNwb25zZRJvCg'
    'xTdG9wSW5mdXNpb24SLi5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLlN0b3BJbmZ1c2lvblJl'
    'cXVlc3QaLy5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLlN0b3BJbmZ1c2lvblJlc3BvbnNlEm'
    '8KDFJlY29yZEFpcndheRIuLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuUmVjb3JkQWlyd2F5'
    'UmVxdWVzdBovLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuUmVjb3JkQWlyd2F5UmVzcG9uc2'
    'USZgoJR2V0QWlyd2F5EisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRBaXJ3YXlSZXF1'
    'ZXN0GiwuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRBaXJ3YXlSZXNwb25zZRJ7ChBHZX'
    'RQYXRpZW50QWlyd2F5EjIuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRQYXRpZW50QWly'
    'd2F5UmVxdWVzdBozLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0UGF0aWVudEFpcndheV'
    'Jlc3BvbnNlEmkKCkNoYXJ0Rmx1aWQSLC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkNoYXJ0'
    'Rmx1aWRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5DaGFydEZsdWlkUmVzcG'
    '9uc2USaQoKR2V0QmFsYW5jZRIsLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0QmFsYW5j'
    'ZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkdldEJhbGFuY2VSZXNwb25zZR'
    'JjCghIYW5kT3ZlchIqLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuSGFuZE92ZXJSZXF1ZXN0'
    'GisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5IYW5kT3ZlclJlc3BvbnNlEnIKDUxpc3RIYW'
    '5kb3ZlcnMSLy5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkxpc3RIYW5kb3ZlcnNSZXF1ZXN0'
    'GjAuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0SGFuZG92ZXJzUmVzcG9uc2USewoQR2'
    'V0UmVjb3ZlcnlTY2FsZRIyLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0UmVjb3ZlcnlT'
    'Y2FsZVJlcXVlc3QaMy5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkdldFJlY292ZXJ5U2NhbG'
    'VSZXNwb25zZRJ1Cg5Bc3Nlc3NSZWNvdmVyeRIwLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEu'
    'QXNzZXNzUmVjb3ZlcnlSZXF1ZXN0GjEuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5Bc3Nlc3'
    'NSZWNvdmVyeVJlc3BvbnNlEpABChdMaXN0UmVjb3ZlcnlBc3Nlc3NtZW50cxI5LmhlYWx0aGNh'
    'cmUuYW5hZXN0aGVzaWEudjEuTGlzdFJlY292ZXJ5QXNzZXNzbWVudHNSZXF1ZXN0GjouaGVhbH'
    'RoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0UmVjb3ZlcnlBc3Nlc3NtZW50c1Jlc3BvbnNlEn4K'
    'EUV2YWx1YXRlRGlzY2hhcmdlEjMuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5FdmFsdWF0ZU'
    'Rpc2NoYXJnZVJlcXVlc3QaNC5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLkV2YWx1YXRlRGlz'
    'Y2hhcmdlUmVzcG9uc2USigEKFURpc2NoYXJnZUZyb21SZWNvdmVyeRI3LmhlYWx0aGNhcmUuYW'
    '5hZXN0aGVzaWEudjEuRGlzY2hhcmdlRnJvbVJlY292ZXJ5UmVxdWVzdBo4LmhlYWx0aGNhcmUu'
    'YW5hZXN0aGVzaWEudjEuRGlzY2hhcmdlRnJvbVJlY292ZXJ5UmVzcG9uc2USZgoJT3JkZXJQYW'
    'luEisuaGVhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5PcmRlclBhaW5SZXF1ZXN0GiwuaGVhbHRo'
    'Y2FyZS5hbmFlc3RoZXNpYS52MS5PcmRlclBhaW5SZXNwb25zZRJ1Cg5MaXN0UGFpbk9yZGVycx'
    'IwLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuTGlzdFBhaW5PcmRlcnNSZXF1ZXN0GjEuaGVh'
    'bHRoY2FyZS5hbmFlc3RoZXNpYS52MS5MaXN0UGFpbk9yZGVyc1Jlc3BvbnNlEm8KDEdldFBhaW'
    '5Sb3VuZBIuLmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0UGFpblJvdW5kUmVxdWVzdBov'
    'LmhlYWx0aGNhcmUuYW5hZXN0aGVzaWEudjEuR2V0UGFpblJvdW5kUmVzcG9uc2USYwoIU3RvcF'
    'BhaW4SKi5oZWFsdGhjYXJlLmFuYWVzdGhlc2lhLnYxLlN0b3BQYWluUmVxdWVzdBorLmhlYWx0'
    'aGNhcmUuYW5hZXN0aGVzaWEudjEuU3RvcFBhaW5SZXNwb25zZRJpCgpHZXRTdW1tYXJ5EiwuaG'
    'VhbHRoY2FyZS5hbmFlc3RoZXNpYS52MS5HZXRTdW1tYXJ5UmVxdWVzdBotLmhlYWx0aGNhcmUu'
    'YW5hZXN0aGVzaWEudjEuR2V0U3VtbWFyeVJlc3BvbnNl');
