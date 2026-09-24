// This is a generated file - do not edit.
//
// Generated from healthcare/infection/v1/infection.proto.

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

@$core.Deprecated('Use onsetDescriptor instead')
const Onset$json = {
  '1': 'Onset',
  '2': [
    {'1': 'ONSET_UNSPECIFIED', '2': 0},
    {'1': 'ONSET_COMMUNITY_ACQUIRED', '2': 1},
    {'1': 'ONSET_HEALTHCARE_ASSOCIATED', '2': 2},
    {'1': 'ONSET_INDETERMINATE', '2': 3},
  ],
};

/// Descriptor for `Onset`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List onsetDescriptor = $convert.base64Decode(
    'CgVPbnNldBIVChFPTlNFVF9VTlNQRUNJRklFRBAAEhwKGE9OU0VUX0NPTU1VTklUWV9BQ1FVSV'
    'JFRBABEh8KG09OU0VUX0hFQUxUSENBUkVfQVNTT0NJQVRFRBACEhcKE09OU0VUX0lOREVURVJN'
    'SU5BVEUQAw==');

@$core.Deprecated('Use infectionSiteDescriptor instead')
const InfectionSite$json = {
  '1': 'InfectionSite',
  '2': [
    {'1': 'INFECTION_SITE_UNSPECIFIED', '2': 0},
    {'1': 'INFECTION_SITE_VENTILATOR_ASSOCIATED_PNEUMONIA', '2': 1},
    {'1': 'INFECTION_SITE_CENTRAL_LINE_BLOODSTREAM', '2': 2},
    {'1': 'INFECTION_SITE_CATHETER_ASSOCIATED_URINARY', '2': 3},
    {'1': 'INFECTION_SITE_SURGICAL_SITE', '2': 4},
    {'1': 'INFECTION_SITE_BLOODSTREAM', '2': 5},
    {'1': 'INFECTION_SITE_RESPIRATORY', '2': 6},
    {'1': 'INFECTION_SITE_URINARY', '2': 7},
    {'1': 'INFECTION_SITE_SKIN_SOFT_TISSUE', '2': 8},
    {'1': 'INFECTION_SITE_GASTROINTESTINAL', '2': 9},
    {'1': 'INFECTION_SITE_OTHER', '2': 10},
  ],
};

/// Descriptor for `InfectionSite`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List infectionSiteDescriptor = $convert.base64Decode(
    'Cg1JbmZlY3Rpb25TaXRlEh4KGklORkVDVElPTl9TSVRFX1VOU1BFQ0lGSUVEEAASMgouSU5GRU'
    'NUSU9OX1NJVEVfVkVOVElMQVRPUl9BU1NPQ0lBVEVEX1BORVVNT05JQRABEisKJ0lORkVDVElP'
    'Tl9TSVRFX0NFTlRSQUxfTElORV9CTE9PRFNUUkVBTRACEi4KKklORkVDVElPTl9TSVRFX0NBVE'
    'hFVEVSX0FTU09DSUFURURfVVJJTkFSWRADEiAKHElORkVDVElPTl9TSVRFX1NVUkdJQ0FMX1NJ'
    'VEUQBBIeChpJTkZFQ1RJT05fU0lURV9CTE9PRFNUUkVBTRAFEh4KGklORkVDVElPTl9TSVRFX1'
    'JFU1BJUkFUT1JZEAYSGgoWSU5GRUNUSU9OX1NJVEVfVVJJTkFSWRAHEiMKH0lORkVDVElPTl9T'
    'SVRFX1NLSU5fU09GVF9USVNTVUUQCBIjCh9JTkZFQ1RJT05fU0lURV9HQVNUUk9JTlRFU1RJTk'
    'FMEAkSGAoUSU5GRUNUSU9OX1NJVEVfT1RIRVIQCg==');

@$core.Deprecated('Use deviceKindDescriptor instead')
const DeviceKind$json = {
  '1': 'DeviceKind',
  '2': [
    {'1': 'DEVICE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DEVICE_KIND_VENTILATOR', '2': 1},
    {'1': 'DEVICE_KIND_CENTRAL_LINE', '2': 2},
    {'1': 'DEVICE_KIND_URINARY_CATHETER', '2': 3},
  ],
};

/// Descriptor for `DeviceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceKindDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VLaW5kEhsKF0RFVklDRV9LSU5EX1VOU1BFQ0lGSUVEEAASGgoWREVWSUNFX0tJTk'
    'RfVkVOVElMQVRPUhABEhwKGERFVklDRV9LSU5EX0NFTlRSQUxfTElORRACEiAKHERFVklDRV9L'
    'SU5EX1VSSU5BUllfQ0FUSEVURVIQAw==');

@$core.Deprecated('Use caseStateDescriptor instead')
const CaseState$json = {
  '1': 'CaseState',
  '2': [
    {'1': 'CASE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CASE_STATE_SUSPECTED', '2': 1},
    {'1': 'CASE_STATE_CONFIRMED', '2': 2},
    {'1': 'CASE_STATE_REFUTED', '2': 3},
    {'1': 'CASE_STATE_CLOSED', '2': 4},
  ],
};

/// Descriptor for `CaseState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List caseStateDescriptor = $convert.base64Decode(
    'CglDYXNlU3RhdGUSGgoWQ0FTRV9TVEFURV9VTlNQRUNJRklFRBAAEhgKFENBU0VfU1RBVEVfU1'
    'VTUEVDVEVEEAESGAoUQ0FTRV9TVEFURV9DT05GSVJNRUQQAhIWChJDQVNFX1NUQVRFX1JFRlVU'
    'RUQQAxIVChFDQVNFX1NUQVRFX0NMT1NFRBAE');

@$core.Deprecated('Use precautionDescriptor instead')
const Precaution$json = {
  '1': 'Precaution',
  '2': [
    {'1': 'PRECAUTION_UNSPECIFIED', '2': 0},
    {'1': 'PRECAUTION_STANDARD', '2': 1},
    {'1': 'PRECAUTION_CONTACT', '2': 2},
    {'1': 'PRECAUTION_DROPLET', '2': 3},
    {'1': 'PRECAUTION_AIRBORNE', '2': 4},
    {'1': 'PRECAUTION_PROTECTIVE', '2': 5},
  ],
};

/// Descriptor for `Precaution`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List precautionDescriptor = $convert.base64Decode(
    'CgpQcmVjYXV0aW9uEhoKFlBSRUNBVVRJT05fVU5TUEVDSUZJRUQQABIXChNQUkVDQVVUSU9OX1'
    'NUQU5EQVJEEAESFgoSUFJFQ0FVVElPTl9DT05UQUNUEAISFgoSUFJFQ0FVVElPTl9EUk9QTEVU'
    'EAMSFwoTUFJFQ0FVVElPTl9BSVJCT1JORRAEEhkKFVBSRUNBVVRJT05fUFJPVEVDVElWRRAF');

@$core.Deprecated('Use outbreakStateDescriptor instead')
const OutbreakState$json = {
  '1': 'OutbreakState',
  '2': [
    {'1': 'OUTBREAK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'OUTBREAK_STATE_SUSPECTED', '2': 1},
    {'1': 'OUTBREAK_STATE_DECLARED', '2': 2},
    {'1': 'OUTBREAK_STATE_CONTAINED', '2': 3},
    {'1': 'OUTBREAK_STATE_CLOSED', '2': 4},
    {'1': 'OUTBREAK_STATE_REFUTED', '2': 5},
  ],
};

/// Descriptor for `OutbreakState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List outbreakStateDescriptor = $convert.base64Decode(
    'Cg1PdXRicmVha1N0YXRlEh4KGk9VVEJSRUFLX1NUQVRFX1VOU1BFQ0lGSUVEEAASHAoYT1VUQl'
    'JFQUtfU1RBVEVfU1VTUEVDVEVEEAESGwoXT1VUQlJFQUtfU1RBVEVfREVDTEFSRUQQAhIcChhP'
    'VVRCUkVBS19TVEFURV9DT05UQUlORUQQAxIZChVPVVRCUkVBS19TVEFURV9DTE9TRUQQBBIaCh'
    'ZPVVRCUkVBS19TVEFURV9SRUZVVEVEEAU=');

@$core.Deprecated('Use membershipReasonDescriptor instead')
const MembershipReason$json = {
  '1': 'MembershipReason',
  '2': [
    {'1': 'MEMBERSHIP_REASON_UNSPECIFIED', '2': 0},
    {'1': 'MEMBERSHIP_REASON_MEETS_DEFINITION', '2': 1},
    {'1': 'MEMBERSHIP_REASON_EPIDEMIOLOGICAL_LINK', '2': 2},
    {'1': 'MEMBERSHIP_REASON_EXCLUDED', '2': 3},
  ],
};

/// Descriptor for `MembershipReason`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List membershipReasonDescriptor = $convert.base64Decode(
    'ChBNZW1iZXJzaGlwUmVhc29uEiEKHU1FTUJFUlNISVBfUkVBU09OX1VOU1BFQ0lGSUVEEAASJg'
    'oiTUVNQkVSU0hJUF9SRUFTT05fTUVFVFNfREVGSU5JVElPThABEioKJk1FTUJFUlNISVBfUkVB'
    'U09OX0VQSURFTUlPTE9HSUNBTF9MSU5LEAISHgoaTUVNQkVSU0hJUF9SRUFTT05fRVhDTFVERU'
    'QQAw==');

@$core.Deprecated('Use disciplineDescriptor instead')
const Discipline$json = {
  '1': 'Discipline',
  '2': [
    {'1': 'DISCIPLINE_UNSPECIFIED', '2': 0},
    {'1': 'DISCIPLINE_DOCTOR', '2': 1},
    {'1': 'DISCIPLINE_NURSE', '2': 2},
    {'1': 'DISCIPLINE_ALLIED_HEALTH', '2': 3},
    {'1': 'DISCIPLINE_SUPPORT_STAFF', '2': 4},
    {'1': 'DISCIPLINE_STUDENT', '2': 5},
    {'1': 'DISCIPLINE_VISITOR', '2': 6},
  ],
};

/// Descriptor for `Discipline`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List disciplineDescriptor = $convert.base64Decode(
    'CgpEaXNjaXBsaW5lEhoKFkRJU0NJUExJTkVfVU5TUEVDSUZJRUQQABIVChFESVNDSVBMSU5FX0'
    'RPQ1RPUhABEhQKEERJU0NJUExJTkVfTlVSU0UQAhIcChhESVNDSVBMSU5FX0FMTElFRF9IRUFM'
    'VEgQAxIcChhESVNDSVBMSU5FX1NVUFBPUlRfU1RBRkYQBBIWChJESVNDSVBMSU5FX1NUVURFTl'
    'QQBRIWChJESVNDSVBMSU5FX1ZJU0lUT1IQBg==');

@$core.Deprecated('Use momentDescriptor instead')
const Moment$json = {
  '1': 'Moment',
  '2': [
    {'1': 'MOMENT_UNSPECIFIED', '2': 0},
    {'1': 'MOMENT_BEFORE_PATIENT_CONTACT', '2': 1},
    {'1': 'MOMENT_BEFORE_ASEPTIC_PROCEDURE', '2': 2},
    {'1': 'MOMENT_AFTER_BODY_FLUID_EXPOSURE', '2': 3},
    {'1': 'MOMENT_AFTER_PATIENT_CONTACT', '2': 4},
    {'1': 'MOMENT_AFTER_PATIENT_SURROUNDINGS', '2': 5},
  ],
};

/// Descriptor for `Moment`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List momentDescriptor = $convert.base64Decode(
    'CgZNb21lbnQSFgoSTU9NRU5UX1VOU1BFQ0lGSUVEEAASIQodTU9NRU5UX0JFRk9SRV9QQVRJRU'
    '5UX0NPTlRBQ1QQARIjCh9NT01FTlRfQkVGT1JFX0FTRVBUSUNfUFJPQ0VEVVJFEAISJAogTU9N'
    'RU5UX0FGVEVSX0JPRFlfRkxVSURfRVhQT1NVUkUQAxIgChxNT01FTlRfQUZURVJfUEFUSUVOVF'
    '9DT05UQUNUEAQSJQohTU9NRU5UX0FGVEVSX1BBVElFTlRfU1VSUk9VTkRJTkdTEAU=');

@$core.Deprecated('Use hygieneActionDescriptor instead')
const HygieneAction$json = {
  '1': 'HygieneAction',
  '2': [
    {'1': 'HYGIENE_ACTION_UNSPECIFIED', '2': 0},
    {'1': 'HYGIENE_ACTION_ALCOHOL_RUB', '2': 1},
    {'1': 'HYGIENE_ACTION_SOAP_AND_WATER', '2': 2},
    {'1': 'HYGIENE_ACTION_MISSED', '2': 3},
    {'1': 'HYGIENE_ACTION_GLOVES_ONLY', '2': 4},
  ],
};

/// Descriptor for `HygieneAction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List hygieneActionDescriptor = $convert.base64Decode(
    'Cg1IeWdpZW5lQWN0aW9uEh4KGkhZR0lFTkVfQUNUSU9OX1VOU1BFQ0lGSUVEEAASHgoaSFlHSU'
    'VORV9BQ1RJT05fQUxDT0hPTF9SVUIQARIhCh1IWUdJRU5FX0FDVElPTl9TT0FQX0FORF9XQVRF'
    'UhACEhkKFUhZR0lFTkVfQUNUSU9OX01JU1NFRBADEh4KGkhZR0lFTkVfQUNUSU9OX0dMT1ZFU1'
    '9PTkxZEAQ=');

@$core.Deprecated('Use exposureKindDescriptor instead')
const ExposureKind$json = {
  '1': 'ExposureKind',
  '2': [
    {'1': 'EXPOSURE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EXPOSURE_KIND_NEEDLESTICK', '2': 1},
    {'1': 'EXPOSURE_KIND_SHARPS', '2': 2},
    {'1': 'EXPOSURE_KIND_MUCOCUTANEOUS_SPLASH', '2': 3},
    {'1': 'EXPOSURE_KIND_BITE', '2': 4},
    {'1': 'EXPOSURE_KIND_AIRBORNE_CONTACT', '2': 5},
  ],
};

/// Descriptor for `ExposureKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List exposureKindDescriptor = $convert.base64Decode(
    'CgxFeHBvc3VyZUtpbmQSHQoZRVhQT1NVUkVfS0lORF9VTlNQRUNJRklFRBAAEh0KGUVYUE9TVV'
    'JFX0tJTkRfTkVFRExFU1RJQ0sQARIYChRFWFBPU1VSRV9LSU5EX1NIQVJQUxACEiYKIkVYUE9T'
    'VVJFX0tJTkRfTVVDT0NVVEFORU9VU19TUExBU0gQAxIWChJFWFBPU1VSRV9LSU5EX0JJVEUQBB'
    'IiCh5FWFBPU1VSRV9LSU5EX0FJUkJPUk5FX0NPTlRBQ1QQBQ==');

@$core.Deprecated('Use taskStateDescriptor instead')
const TaskState$json = {
  '1': 'TaskState',
  '2': [
    {'1': 'TASK_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATE_DUE', '2': 1},
    {'1': 'TASK_STATE_DONE', '2': 2},
    {'1': 'TASK_STATE_DECLINED', '2': 3},
    {'1': 'TASK_STATE_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `TaskState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStateDescriptor = $convert.base64Decode(
    'CglUYXNrU3RhdGUSGgoWVEFTS19TVEFURV9VTlNQRUNJRklFRBAAEhIKDlRBU0tfU1RBVEVfRF'
    'VFEAESEwoPVEFTS19TVEFURV9ET05FEAISFwoTVEFTS19TVEFURV9ERUNMSU5FRBADEh0KGVRB'
    'U0tfU1RBVEVfTk9UX0FQUExJQ0FCTEUQBA==');

@$core.Deprecated('Use triggerKindDescriptor instead')
const TriggerKind$json = {
  '1': 'TriggerKind',
  '2': [
    {'1': 'TRIGGER_KIND_UNSPECIFIED', '2': 0},
    {'1': 'TRIGGER_KIND_RESTRICTED_AGENT', '2': 1},
    {'1': 'TRIGGER_KIND_DURATION', '2': 2},
    {'1': 'TRIGGER_KIND_BUG_DRUG_MISMATCH', '2': 3},
    {'1': 'TRIGGER_KIND_DE_ESCALATION', '2': 4},
    {'1': 'TRIGGER_KIND_IV_TO_ORAL', '2': 5},
    {'1': 'TRIGGER_KIND_REDUNDANT_COVER', '2': 6},
  ],
};

/// Descriptor for `TriggerKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List triggerKindDescriptor = $convert.base64Decode(
    'CgtUcmlnZ2VyS2luZBIcChhUUklHR0VSX0tJTkRfVU5TUEVDSUZJRUQQABIhCh1UUklHR0VSX0'
    'tJTkRfUkVTVFJJQ1RFRF9BR0VOVBABEhkKFVRSSUdHRVJfS0lORF9EVVJBVElPThACEiIKHlRS'
    'SUdHRVJfS0lORF9CVUdfRFJVR19NSVNNQVRDSBADEh4KGlRSSUdHRVJfS0lORF9ERV9FU0NBTE'
    'FUSU9OEAQSGwoXVFJJR0dFUl9LSU5EX0lWX1RPX09SQUwQBRIgChxUUklHR0VSX0tJTkRfUkVE'
    'VU5EQU5UX0NPVkVSEAY=');

@$core.Deprecated('Use reviewStateDescriptor instead')
const ReviewState$json = {
  '1': 'ReviewState',
  '2': [
    {'1': 'REVIEW_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATE_OPEN', '2': 1},
    {'1': 'REVIEW_STATE_ADVISED', '2': 2},
    {'1': 'REVIEW_STATE_CLOSED', '2': 3},
    {'1': 'REVIEW_STATE_WITHDRAWN', '2': 4},
  ],
};

/// Descriptor for `ReviewState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStateDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0ZRIcChhSRVZJRVdfU1RBVEVfVU5TUEVDSUZJRUQQABIVChFSRVZJRVdfU1'
    'RBVEVfT1BFThABEhgKFFJFVklFV19TVEFURV9BRFZJU0VEEAISFwoTUkVWSUVXX1NUQVRFX0NM'
    'T1NFRBADEhoKFlJFVklFV19TVEFURV9XSVRIRFJBV04QBA==');

@$core.Deprecated('Use recommendationDescriptor instead')
const Recommendation$json = {
  '1': 'Recommendation',
  '2': [
    {'1': 'RECOMMENDATION_UNSPECIFIED', '2': 0},
    {'1': 'RECOMMENDATION_CONTINUE', '2': 1},
    {'1': 'RECOMMENDATION_STOP', '2': 2},
    {'1': 'RECOMMENDATION_NARROW_SPECTRUM', '2': 3},
    {'1': 'RECOMMENDATION_SWITCH_TO_ORAL', '2': 4},
    {'1': 'RECOMMENDATION_CHANGE_DOSE', '2': 5},
    {'1': 'RECOMMENDATION_SEND_CULTURES', '2': 6},
    {'1': 'RECOMMENDATION_REFER_TO_INFECTION_SPECIALIST', '2': 7},
  ],
};

/// Descriptor for `Recommendation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recommendationDescriptor = $convert.base64Decode(
    'Cg5SZWNvbW1lbmRhdGlvbhIeChpSRUNPTU1FTkRBVElPTl9VTlNQRUNJRklFRBAAEhsKF1JFQ0'
    '9NTUVOREFUSU9OX0NPTlRJTlVFEAESFwoTUkVDT01NRU5EQVRJT05fU1RPUBACEiIKHlJFQ09N'
    'TUVOREFUSU9OX05BUlJPV19TUEVDVFJVTRADEiEKHVJFQ09NTUVOREFUSU9OX1NXSVRDSF9UT1'
    '9PUkFMEAQSHgoaUkVDT01NRU5EQVRJT05fQ0hBTkdFX0RPU0UQBRIgChxSRUNPTU1FTkRBVElP'
    'Tl9TRU5EX0NVTFRVUkVTEAYSMAosUkVDT01NRU5EQVRJT05fUkVGRVJfVE9fSU5GRUNUSU9OX1'
    'NQRUNJQUxJU1QQBw==');

@$core.Deprecated('Use responseDescriptor instead')
const Response$json = {
  '1': 'Response',
  '2': [
    {'1': 'RESPONSE_UNSPECIFIED', '2': 0},
    {'1': 'RESPONSE_ACCEPTED', '2': 1},
    {'1': 'RESPONSE_DECLINED', '2': 2},
    {'1': 'RESPONSE_MODIFIED', '2': 3},
  ],
};

/// Descriptor for `Response`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List responseDescriptor = $convert.base64Decode(
    'CghSZXNwb25zZRIYChRSRVNQT05TRV9VTlNQRUNJRklFRBAAEhUKEVJFU1BPTlNFX0FDQ0VQVE'
    'VEEAESFQoRUkVTUE9OU0VfREVDTElORUQQAhIVChFSRVNQT05TRV9NT0RJRklFRBAD');

@$core.Deprecated('Use sampleKindDescriptor instead')
const SampleKind$json = {
  '1': 'SampleKind',
  '2': [
    {'1': 'SAMPLE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SAMPLE_KIND_WATER', '2': 1},
    {'1': 'SAMPLE_KIND_DIALYSIS_WATER', '2': 2},
    {'1': 'SAMPLE_KIND_ICE', '2': 3},
    {'1': 'SAMPLE_KIND_AIR_SETTLE_PLATE', '2': 4},
    {'1': 'SAMPLE_KIND_AIR_PARTICLE_COUNT', '2': 5},
    {'1': 'SAMPLE_KIND_SURFACE_SWAB', '2': 6},
    {'1': 'SAMPLE_KIND_ENDOSCOPE_RINSE', '2': 7},
    {'1': 'SAMPLE_KIND_VENTILATION_PRESSURE', '2': 8},
  ],
};

/// Descriptor for `SampleKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sampleKindDescriptor = $convert.base64Decode(
    'CgpTYW1wbGVLaW5kEhsKF1NBTVBMRV9LSU5EX1VOU1BFQ0lGSUVEEAASFQoRU0FNUExFX0tJTk'
    'RfV0FURVIQARIeChpTQU1QTEVfS0lORF9ESUFMWVNJU19XQVRFUhACEhMKD1NBTVBMRV9LSU5E'
    'X0lDRRADEiAKHFNBTVBMRV9LSU5EX0FJUl9TRVRUTEVfUExBVEUQBBIiCh5TQU1QTEVfS0lORF'
    '9BSVJfUEFSVElDTEVfQ09VTlQQBRIcChhTQU1QTEVfS0lORF9TVVJGQUNFX1NXQUIQBhIfChtT'
    'QU1QTEVfS0lORF9FTkRPU0NPUEVfUklOU0UQBxIkCiBTQU1QTEVfS0lORF9WRU5USUxBVElPTl'
    '9QUkVTU1VSRRAI');

@$core.Deprecated('Use outcomeDescriptor instead')
const Outcome$json = {
  '1': 'Outcome',
  '2': [
    {'1': 'OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'OUTCOME_PASS', '2': 1},
    {'1': 'OUTCOME_ACTION_LEVEL', '2': 2},
    {'1': 'OUTCOME_FAIL', '2': 3},
    {'1': 'OUTCOME_UNASSESSABLE', '2': 4},
  ],
};

/// Descriptor for `Outcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List outcomeDescriptor = $convert.base64Decode(
    'CgdPdXRjb21lEhcKE09VVENPTUVfVU5TUEVDSUZJRUQQABIQCgxPVVRDT01FX1BBU1MQARIYCh'
    'RPVVRDT01FX0FDVElPTl9MRVZFTBACEhAKDE9VVENPTUVfRkFJTBADEhgKFE9VVENPTUVfVU5B'
    'U1NFU1NBQkxFEAQ=');

@$core.Deprecated('Use sampleStateDescriptor instead')
const SampleState$json = {
  '1': 'SampleState',
  '2': [
    {'1': 'SAMPLE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SAMPLE_STATE_COLLECTED', '2': 1},
    {'1': 'SAMPLE_STATE_RESULTED', '2': 2},
    {'1': 'SAMPLE_STATE_CLOSED', '2': 3},
  ],
};

/// Descriptor for `SampleState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sampleStateDescriptor = $convert.base64Decode(
    'CgtTYW1wbGVTdGF0ZRIcChhTQU1QTEVfU1RBVEVfVU5TUEVDSUZJRUQQABIaChZTQU1QTEVfU1'
    'RBVEVfQ09MTEVDVEVEEAESGQoVU0FNUExFX1NUQVRFX1JFU1VMVEVEEAISFwoTU0FNUExFX1NU'
    'QVRFX0NMT1NFRBAD');

@$core.Deprecated('Use actionStateDescriptor instead')
const ActionState$json = {
  '1': 'ActionState',
  '2': [
    {'1': 'ACTION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_STATE_OPEN', '2': 1},
    {'1': 'ACTION_STATE_DONE', '2': 2},
    {'1': 'ACTION_STATE_VERIFIED', '2': 3},
  ],
};

/// Descriptor for `ActionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionStateDescriptor = $convert.base64Decode(
    'CgtBY3Rpb25TdGF0ZRIcChhBQ1RJT05fU1RBVEVfVU5TUEVDSUZJRUQQABIVChFBQ1RJT05fU1'
    'RBVEVfT1BFThABEhUKEUFDVElPTl9TVEFURV9ET05FEAISGQoVQUNUSU9OX1NUQVRFX1ZFUklG'
    'SUVEEAM=');

@$core.Deprecated('Use surveillanceCaseDescriptor instead')
const SurveillanceCase$json = {
  '1': 'SurveillanceCase',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 6, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'organism', '3': 7, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'organism_code', '3': 8, '4': 1, '5': 9, '10': 'organismCode'},
    {
      '1': 'site',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.InfectionSite',
      '10': 'site'
    },
    {
      '1': 'multidrug_resistant',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'multidrugResistant'
    },
    {
      '1': 'onset',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Onset',
      '10': 'onset'
    },
    {
      '1': 'onset_override',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Onset',
      '10': 'onsetOverride'
    },
    {
      '1': 'onset_override_why',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'onsetOverrideWhy'
    },
    {
      '1': 'onset_overridden_by',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'onsetOverriddenBy'
    },
    {
      '1': 'admitted_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'admittedAt'
    },
    {
      '1': 'onset_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'window_hours', '3': 17, '4': 1, '5': 5, '10': 'windowHours'},
    {'1': 'criteria', '3': 18, '4': 1, '5': 9, '10': 'criteria'},
    {'1': 'reviewed_by', '3': 19, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'device_in_situ', '3': 21, '4': 1, '5': 8, '10': 'deviceInSitu'},
    {'1': 'device_days', '3': 22, '4': 1, '5': 5, '10': 'deviceDays'},
    {
      '1': 'state',
      '3': 23,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.CaseState',
      '10': 'state'
    },
    {'1': 'notes', '3': 24, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'reported_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reported_by', '3': 26, '4': 1, '5': 9, '10': 'reportedBy'},
    {
      '1': 'closed_at',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 28, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'version', '3': 29, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SurveillanceCase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List surveillanceCaseDescriptor = $convert.base64Decode(
    'ChBTdXJ2ZWlsbGFuY2VDYXNlEhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRpZW50SWQSIQoMZW5j'
    'b3VudGVyX2lkGAQgASgJUgtlbmNvdW50ZXJJZBIfCgtmYWNpbGl0eV9pZBgFIAEoCVIKZmFjaW'
    'xpdHlJZBIfCgtsb2NhdGlvbl9pZBgGIAEoCVIKbG9jYXRpb25JZBIaCghvcmdhbmlzbRgHIAEo'
    'CVIIb3JnYW5pc20SIwoNb3JnYW5pc21fY29kZRgIIAEoCVIMb3JnYW5pc21Db2RlEjoKBHNpdG'
    'UYCSABKA4yJi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5JbmZlY3Rpb25TaXRlUgRzaXRlEi8K'
    'E211bHRpZHJ1Z19yZXNpc3RhbnQYCiABKAhSEm11bHRpZHJ1Z1Jlc2lzdGFudBI0CgVvbnNldB'
    'gLIAEoDjIeLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLk9uc2V0UgVvbnNldBJFCg5vbnNldF9v'
    'dmVycmlkZRgMIAEoDjIeLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLk9uc2V0Ug1vbnNldE92ZX'
    'JyaWRlEiwKEm9uc2V0X292ZXJyaWRlX3doeRgNIAEoCVIQb25zZXRPdmVycmlkZVdoeRIuChNv'
    'bnNldF9vdmVycmlkZGVuX2J5GA4gASgJUhFvbnNldE92ZXJyaWRkZW5CeRI7CgthZG1pdHRlZF'
    '9hdBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFkbWl0dGVkQXQSNQoIb25z'
    'ZXRfYXQYECABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdvbnNldEF0EiEKDHdpbm'
    'Rvd19ob3VycxgRIAEoBVILd2luZG93SG91cnMSGgoIY3JpdGVyaWEYEiABKAlSCGNyaXRlcmlh'
    'Eh8KC3Jldmlld2VkX2J5GBMgASgJUgpyZXZpZXdlZEJ5EjsKC3Jldmlld2VkX2F0GBQgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmV2aWV3ZWRBdBIkCg5kZXZpY2VfaW5fc2l0'
    'dRgVIAEoCFIMZGV2aWNlSW5TaXR1Eh8KC2RldmljZV9kYXlzGBYgASgFUgpkZXZpY2VEYXlzEj'
    'gKBXN0YXRlGBcgASgOMiIuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQ2FzZVN0YXRlUgVzdGF0'
    'ZRIUCgVub3RlcxgYIAEoCVIFbm90ZXMSOwoLcmVwb3J0ZWRfYXQYGSABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgpyZXBvcnRlZEF0Eh8KC3JlcG9ydGVkX2J5GBogASgJUgpyZXBv'
    'cnRlZEJ5EjcKCWNsb3NlZF9hdBgbIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCG'
    'Nsb3NlZEF0EhsKCWNsb3NlZF9ieRgcIAEoCVIIY2xvc2VkQnkSGAoHdmVyc2lvbhgdIAEoA1IH'
    'dmVyc2lvbg==');

@$core.Deprecated('Use deviceDayCountDescriptor instead')
const DeviceDayCount$json = {
  '1': 'DeviceDayCount',
  '2': [
    {'1': 'count_id', '3': 1, '4': 1, '5': 9, '10': 'countId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'device',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.DeviceKind',
      '10': 'device'
    },
    {
      '1': 'counted_on',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'countedOn'
    },
    {'1': 'patient_days', '3': 6, '4': 1, '5': 5, '10': 'patientDays'},
    {'1': 'device_days', '3': 7, '4': 1, '5': 5, '10': 'deviceDays'},
    {
      '1': 'recorded_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 9, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `DeviceDayCount`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDayCountDescriptor = $convert.base64Decode(
    'Cg5EZXZpY2VEYXlDb3VudBIZCghjb3VudF9pZBgBIAEoCVIHY291bnRJZBIfCgtmYWNpbGl0eV'
    '9pZBgCIAEoCVIKZmFjaWxpdHlJZBIfCgtsb2NhdGlvbl9pZBgDIAEoCVIKbG9jYXRpb25JZBI7'
    'CgZkZXZpY2UYBCABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5EZXZpY2VLaW5kUgZkZX'
    'ZpY2USOQoKY291bnRlZF9vbhgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNv'
    'dW50ZWRPbhIhCgxwYXRpZW50X2RheXMYBiABKAVSC3BhdGllbnREYXlzEh8KC2RldmljZV9kYX'
    'lzGAcgASgFUgpkZXZpY2VEYXlzEjsKC3JlY29yZGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdBIfCgtyZWNvcmRlZF9ieRgJIAEoCVIKcmVjb3JkZW'
    'RCeQ==');

@$core.Deprecated('Use onsetSummaryDescriptor instead')
const OnsetSummary$json = {
  '1': 'OnsetSummary',
  '2': [
    {'1': 'healthcare', '3': 1, '4': 1, '5': 5, '10': 'healthcare'},
    {'1': 'community', '3': 2, '4': 1, '5': 5, '10': 'community'},
    {'1': 'indeterminate', '3': 3, '4': 1, '5': 5, '10': 'indeterminate'},
    {'1': 'overridden', '3': 4, '4': 1, '5': 5, '10': 'overridden'},
    {
      '1': 'overridden_to_community',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'overriddenToCommunity'
    },
  ],
};

/// Descriptor for `OnsetSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List onsetSummaryDescriptor = $convert.base64Decode(
    'CgxPbnNldFN1bW1hcnkSHgoKaGVhbHRoY2FyZRgBIAEoBVIKaGVhbHRoY2FyZRIcCgljb21tdW'
    '5pdHkYAiABKAVSCWNvbW11bml0eRIkCg1pbmRldGVybWluYXRlGAMgASgFUg1pbmRldGVybWlu'
    'YXRlEh4KCm92ZXJyaWRkZW4YBCABKAVSCm92ZXJyaWRkZW4SNgoXb3ZlcnJpZGRlbl90b19jb2'
    '1tdW5pdHkYBSABKAVSFW92ZXJyaWRkZW5Ub0NvbW11bml0eQ==');

@$core.Deprecated('Use rateDescriptor instead')
const Rate$json = {
  '1': 'Rate',
  '2': [
    {
      '1': 'site',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.InfectionSite',
      '10': 'site'
    },
    {
      '1': 'device',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.DeviceKind',
      '10': 'device'
    },
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
    {'1': 'infections', '3': 6, '4': 1, '5': 5, '10': 'infections'},
    {'1': 'device_days', '3': 7, '4': 1, '5': 5, '10': 'deviceDays'},
    {'1': 'patient_days', '3': 8, '4': 1, '5': 5, '10': 'patientDays'},
    {
      '1': 'per_thousand_device_days_tenths',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'perThousandDeviceDaysTenths'
    },
    {
      '1': 'utilisation_permille',
      '3': 10,
      '4': 1,
      '5': 5,
      '10': 'utilisationPermille'
    },
    {'1': 'unanswerable', '3': 11, '4': 1, '5': 8, '10': 'unanswerable'},
    {
      '1': 'onsets',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.OnsetSummary',
      '10': 'onsets'
    },
    {'1': 'indicator_code', '3': 13, '4': 1, '5': 9, '10': 'indicatorCode'},
    {
      '1': 'indicator_revision',
      '3': 14,
      '4': 1,
      '5': 5,
      '10': 'indicatorRevision'
    },
  ],
};

/// Descriptor for `Rate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rateDescriptor = $convert.base64Decode(
    'CgRSYXRlEjoKBHNpdGUYASABKA4yJi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5JbmZlY3Rpb2'
    '5TaXRlUgRzaXRlEjsKBmRldmljZRgCIAEoDjIjLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkRl'
    'dmljZUtpbmRSBmRldmljZRIfCgtsb2NhdGlvbl9pZBgDIAEoCVIKbG9jYXRpb25JZBI7CgtwZX'
    'Jpb2RfZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnBlcmlvZEZyb20S'
    'NwoJcGVyaW9kX3RvGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcGVyaW9kVG'
    '8SHgoKaW5mZWN0aW9ucxgGIAEoBVIKaW5mZWN0aW9ucxIfCgtkZXZpY2VfZGF5cxgHIAEoBVIK'
    'ZGV2aWNlRGF5cxIhCgxwYXRpZW50X2RheXMYCCABKAVSC3BhdGllbnREYXlzEkQKH3Blcl90aG'
    '91c2FuZF9kZXZpY2VfZGF5c190ZW50aHMYCSABKAVSG3BlclRob3VzYW5kRGV2aWNlRGF5c1Rl'
    'bnRocxIxChR1dGlsaXNhdGlvbl9wZXJtaWxsZRgKIAEoBVITdXRpbGlzYXRpb25QZXJtaWxsZR'
    'IiCgx1bmFuc3dlcmFibGUYCyABKAhSDHVuYW5zd2VyYWJsZRI9CgZvbnNldHMYDCABKAsyJS5o'
    'ZWFsdGhjYXJlLmluZmVjdGlvbi52MS5PbnNldFN1bW1hcnlSBm9uc2V0cxIlCg5pbmRpY2F0b3'
    'JfY29kZRgNIAEoCVINaW5kaWNhdG9yQ29kZRItChJpbmRpY2F0b3JfcmV2aXNpb24YDiABKAVS'
    'EWluZGljYXRvclJldmlzaW9u');

@$core.Deprecated('Use isolationDescriptor instead')
const Isolation$json = {
  '1': 'Isolation',
  '2': [
    {'1': 'isolation_id', '3': 1, '4': 1, '5': 9, '10': 'isolationId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'bed_id', '3': 6, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'precaution',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'reason', '3': 8, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'case_id', '3': 9, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'started_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 11, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'review_due',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewDue'
    },
    {
      '1': 'ended_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'ended_by', '3': 14, '4': 1, '5': 9, '10': 'endedBy'},
    {'1': 'end_reason', '3': 15, '4': 1, '5': 9, '10': 'endReason'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Isolation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List isolationDescriptor = $convert.base64Decode(
    'CglJc29sYXRpb24SIQoMaXNvbGF0aW9uX2lkGAEgASgJUgtpc29sYXRpb25JZBIdCgpwYXRpZW'
    '50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJ'
    'ZBIfCgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIfCgtsb2NhdGlvbl9pZBgFIAEoCV'
    'IKbG9jYXRpb25JZBIVCgZiZWRfaWQYBiABKAlSBWJlZElkEkMKCnByZWNhdXRpb24YByABKA4y'
    'Iy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5QcmVjYXV0aW9uUgpwcmVjYXV0aW9uEhYKBnJlYX'
    'NvbhgIIAEoCVIGcmVhc29uEhcKB2Nhc2VfaWQYCSABKAlSBmNhc2VJZBI5CgpzdGFydGVkX2F0'
    'GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Eh0KCnN0YXJ0ZW'
    'RfYnkYCyABKAlSCXN0YXJ0ZWRCeRI5CgpyZXZpZXdfZHVlGAwgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJcmV2aWV3RHVlEjUKCGVuZGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdBIZCghlbmRlZF9ieRgOIAEoCVIHZW5kZWRCeRIdCgpl'
    'bmRfcmVhc29uGA8gASgJUgllbmRSZWFzb24SGAoHdmVyc2lvbhgQIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use boardEntryDescriptor instead')
const BoardEntry$json = {
  '1': 'BoardEntry',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'precaution',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'ppe', '3': 5, '4': 3, '5': 9, '10': 'ppe'},
    {
      '1': 'requires_side_room',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'requiresSideRoom'
    },
    {
      '1': 'since',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'since'
    },
    {'1': 'review_overdue', '3': 8, '4': 1, '5': 8, '10': 'reviewOverdue'},
  ],
};

/// Descriptor for `BoardEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardEntryDescriptor = $convert.base64Decode(
    'CgpCb2FyZEVudHJ5EhUKBmJlZF9pZBgBIAEoCVIFYmVkSWQSHwoLbG9jYXRpb25faWQYAiABKA'
    'lSCmxvY2F0aW9uSWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEkMKCnByZWNhdXRp'
    'b24YBCABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5QcmVjYXV0aW9uUgpwcmVjYXV0aW'
    '9uEhAKA3BwZRgFIAMoCVIDcHBlEiwKEnJlcXVpcmVzX3NpZGVfcm9vbRgGIAEoCFIQcmVxdWly'
    'ZXNTaWRlUm9vbRIwCgVzaW5jZRgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBX'
    'NpbmNlEiUKDnJldmlld19vdmVyZHVlGAggASgIUg1yZXZpZXdPdmVyZHVl');

@$core.Deprecated('Use alertRuleDescriptor instead')
const AlertRule$json = {
  '1': 'AlertRule',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'organisms', '3': 5, '4': 3, '5': 9, '10': 'organisms'},
    {'1': 'lookback_days', '3': 6, '4': 1, '5': 5, '10': 'lookbackDays'},
    {
      '1': 'precaution',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'advice', '3': 8, '4': 1, '5': 9, '10': 'advice'},
    {'1': 'approved', '3': 9, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 10, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
    {
      '1': 'created_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 15, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `AlertRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertRuleDescriptor = $convert.base64Decode(
    'CglBbGVydFJ1bGUSFwoHcnVsZV9pZBgBIAEoCVIGcnVsZUlkEhIKBGNvZGUYAiABKAlSBGNvZG'
    'USEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghyZXZpc2lvbhgEIAEoBVIIcmV2aXNpb24SHAoJb3Jn'
    'YW5pc21zGAUgAygJUglvcmdhbmlzbXMSIwoNbG9va2JhY2tfZGF5cxgGIAEoBVIMbG9va2JhY2'
    'tEYXlzEkMKCnByZWNhdXRpb24YByABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5QcmVj'
    'YXV0aW9uUgpwcmVjYXV0aW9uEhYKBmFkdmljZRgIIAEoCVIGYWR2aWNlEhoKCGFwcHJvdmVkGA'
    'kgASgIUghhcHByb3ZlZBIfCgthcHByb3ZlZF9ieRgKIAEoCVIKYXBwcm92ZWRCeRI7CgthcHBy'
    'b3ZlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQSQQ'
    'oOZWZmZWN0aXZlX2Zyb20YDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZl'
    'Y3RpdmVGcm9tEj8KDXN1cGVyc2VkZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgxzdXBlcnNlZGVkQXQSOQoKY3JlYXRlZF9hdBgOIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GA8gASgJUgljcmVhdGVkQnk=');

@$core.Deprecated('Use alertDescriptor instead')
const Alert$json = {
  '1': 'Alert',
  '2': [
    {'1': 'alert_id', '3': 1, '4': 1, '5': 9, '10': 'alertId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'rule_id', '3': 5, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'rule_code', '3': 6, '4': 1, '5': 9, '10': 'ruleCode'},
    {'1': 'rule_revision', '3': 7, '4': 1, '5': 5, '10': 'ruleRevision'},
    {'1': 'organism', '3': 8, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'organism_code', '3': 9, '4': 1, '5': 9, '10': 'organismCode'},
    {
      '1': 'last_positive_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastPositiveAt'
    },
    {
      '1': 'precaution',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'advice', '3': 12, '4': 1, '5': 9, '10': 'advice'},
    {
      '1': 'raised_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
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
    {'1': 'overridden', '3': 16, '4': 1, '5': 8, '10': 'overridden'},
    {'1': 'override_why', '3': 17, '4': 1, '5': 9, '10': 'overrideWhy'},
    {'1': 'overridden_by', '3': 18, '4': 1, '5': 9, '10': 'overriddenBy'},
    {
      '1': 'overridden_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'overriddenAt'
    },
  ],
};

/// Descriptor for `Alert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List alertDescriptor = $convert.base64Decode(
    'CgVBbGVydBIZCghhbGVydF9pZBgBIAEoCVIHYWxlcnRJZBIdCgpwYXRpZW50X2lkGAIgASgJUg'
    'lwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIfCgtmYWNpbGl0'
    'eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIXCgdydWxlX2lkGAUgASgJUgZydWxlSWQSGwoJcnVsZV'
    '9jb2RlGAYgASgJUghydWxlQ29kZRIjCg1ydWxlX3JldmlzaW9uGAcgASgFUgxydWxlUmV2aXNp'
    'b24SGgoIb3JnYW5pc20YCCABKAlSCG9yZ2FuaXNtEiMKDW9yZ2FuaXNtX2NvZGUYCSABKAlSDG'
    '9yZ2FuaXNtQ29kZRJEChBsYXN0X3Bvc2l0aXZlX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIObGFzdFBvc2l0aXZlQXQSQwoKcHJlY2F1dGlvbhgLIAEoDjIjLmhlYWx0aG'
    'NhcmUuaW5mZWN0aW9uLnYxLlByZWNhdXRpb25SCnByZWNhdXRpb24SFgoGYWR2aWNlGAwgASgJ'
    'UgZhZHZpY2USNwoJcmFpc2VkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IIcmFpc2VkQXQSQwoPYWNrbm93bGVkZ2VkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIOYWNrbm93bGVkZ2VkQXQSJwoPYWNrbm93bGVkZ2VkX2J5GA8gASgJUg5hY2tub3'
    'dsZWRnZWRCeRIeCgpvdmVycmlkZGVuGBAgASgIUgpvdmVycmlkZGVuEiEKDG92ZXJyaWRlX3do'
    'eRgRIAEoCVILb3ZlcnJpZGVXaHkSIwoNb3ZlcnJpZGRlbl9ieRgSIAEoCVIMb3ZlcnJpZGRlbk'
    'J5Ej8KDW92ZXJyaWRkZW5fYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxv'
    'dmVycmlkZGVuQXQ=');

@$core.Deprecated('Use outbreakDescriptor instead')
const Outbreak$json = {
  '1': 'Outbreak',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'organism', '3': 3, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'case_definition', '3': 4, '4': 1, '5': 9, '10': 'caseDefinition'},
    {'1': 'locations', '3': 5, '4': 3, '5': 9, '10': 'locations'},
    {
      '1': 'window_from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'windowFrom'
    },
    {
      '1': 'window_to',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'windowTo'
    },
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.OutbreakState',
      '10': 'state'
    },
    {'1': 'findings', '3': 9, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'control_measures', '3': 10, '4': 3, '5': 9, '10': 'controlMeasures'},
    {'1': 'action_ids', '3': 11, '4': 3, '5': 9, '10': 'actionIds'},
    {
      '1': 'declared_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'declaredAt'
    },
    {'1': 'declared_by', '3': 13, '4': 1, '5': 9, '10': 'declaredBy'},
    {
      '1': 'closed_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 15, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closure_why', '3': 16, '4': 1, '5': 9, '10': 'closureWhy'},
    {
      '1': 'created_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 18, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 19, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Outbreak`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List outbreakDescriptor = $convert.base64Decode(
    'CghPdXRicmVhaxIfCgtvdXRicmVha19pZBgBIAEoCVIKb3V0YnJlYWtJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRIaCghvcmdhbmlzbRgDIAEoCVIIb3JnYW5pc20SJwoPY2FzZV9k'
    'ZWZpbml0aW9uGAQgASgJUg5jYXNlRGVmaW5pdGlvbhIcCglsb2NhdGlvbnMYBSADKAlSCWxvY2'
    'F0aW9ucxI7Cgt3aW5kb3dfZnJvbRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CndpbmRvd0Zyb20SNwoJd2luZG93X3RvGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIId2luZG93VG8SPAoFc3RhdGUYCCABKA4yJi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5P'
    'dXRicmVha1N0YXRlUgVzdGF0ZRIaCghmaW5kaW5ncxgJIAEoCVIIZmluZGluZ3MSKQoQY29udH'
    'JvbF9tZWFzdXJlcxgKIAMoCVIPY29udHJvbE1lYXN1cmVzEh0KCmFjdGlvbl9pZHMYCyADKAlS'
    'CWFjdGlvbklkcxI7CgtkZWNsYXJlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSCmRlY2xhcmVkQXQSHwoLZGVjbGFyZWRfYnkYDSABKAlSCmRlY2xhcmVkQnkSNwoJY2xv'
    'c2VkX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIY2xvc2VkQXQSGwoJY2'
    'xvc2VkX2J5GA8gASgJUghjbG9zZWRCeRIfCgtjbG9zdXJlX3doeRgQIAEoCVIKY2xvc3VyZVdo'
    'eRI5CgpjcmVhdGVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYX'
    'RlZEF0Eh0KCmNyZWF0ZWRfYnkYEiABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGBMgASgDUgd2'
    'ZXJzaW9u');

@$core.Deprecated('Use membershipDescriptor instead')
const Membership$json = {
  '1': 'Membership',
  '2': [
    {'1': 'membership_id', '3': 1, '4': 1, '5': 9, '10': 'membershipId'},
    {'1': 'outbreak_id', '3': 2, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'case_id', '3': 3, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'reason',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.MembershipReason',
      '10': 'reason'
    },
    {'1': 'note', '3': 6, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'decided_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'decidedAt'
    },
    {'1': 'decided_by', '3': 8, '4': 1, '5': 9, '10': 'decidedBy'},
  ],
};

/// Descriptor for `Membership`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List membershipDescriptor = $convert.base64Decode(
    'CgpNZW1iZXJzaGlwEiMKDW1lbWJlcnNoaXBfaWQYASABKAlSDG1lbWJlcnNoaXBJZBIfCgtvdX'
    'RicmVha19pZBgCIAEoCVIKb3V0YnJlYWtJZBIXCgdjYXNlX2lkGAMgASgJUgZjYXNlSWQSHQoK'
    'cGF0aWVudF9pZBgEIAEoCVIJcGF0aWVudElkEkEKBnJlYXNvbhgFIAEoDjIpLmhlYWx0aGNhcm'
    'UuaW5mZWN0aW9uLnYxLk1lbWJlcnNoaXBSZWFzb25SBnJlYXNvbhISCgRub3RlGAYgASgJUgRu'
    'b3RlEjkKCmRlY2lkZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglkZW'
    'NpZGVkQXQSHQoKZGVjaWRlZF9ieRgIIAEoCVIJZGVjaWRlZEJ5');

@$core.Deprecated('Use clusterSummaryDescriptor instead')
const ClusterSummary$json = {
  '1': 'ClusterSummary',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'included', '3': 2, '4': 1, '5': 5, '10': 'included'},
    {'1': 'excluded', '3': 3, '4': 1, '5': 5, '10': 'excluded'},
    {'1': 'by_link', '3': 4, '4': 1, '5': 5, '10': 'byLink'},
    {'1': 'locations', '3': 5, '4': 3, '5': 9, '10': 'locations'},
    {
      '1': 'first_onset',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'firstOnset'
    },
    {
      '1': 'last_onset',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastOnset'
    },
  ],
};

/// Descriptor for `ClusterSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clusterSummaryDescriptor = $convert.base64Decode(
    'Cg5DbHVzdGVyU3VtbWFyeRIfCgtvdXRicmVha19pZBgBIAEoCVIKb3V0YnJlYWtJZBIaCghpbm'
    'NsdWRlZBgCIAEoBVIIaW5jbHVkZWQSGgoIZXhjbHVkZWQYAyABKAVSCGV4Y2x1ZGVkEhcKB2J5'
    'X2xpbmsYBCABKAVSBmJ5TGluaxIcCglsb2NhdGlvbnMYBSADKAlSCWxvY2F0aW9ucxI7CgtmaX'
    'JzdF9vbnNldBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmZpcnN0T25zZXQS'
    'OQoKbGFzdF9vbnNldBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWxhc3RPbn'
    'NldA==');

@$core.Deprecated('Use hygieneSessionDescriptor instead')
const HygieneSession$json = {
  '1': 'HygieneSession',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'observer_id', '3': 4, '4': 1, '5': 9, '10': 'observerId'},
    {
      '1': 'started_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'ended_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'notes', '3': 7, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'version', '3': 8, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `HygieneSession`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hygieneSessionDescriptor = $convert.base64Decode(
    'Cg5IeWdpZW5lU2Vzc2lvbhIdCgpzZXNzaW9uX2lkGAEgASgJUglzZXNzaW9uSWQSHwoLZmFjaW'
    'xpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYAyABKAlSCmxvY2F0aW9u'
    'SWQSHwoLb2JzZXJ2ZXJfaWQYBCABKAlSCm9ic2VydmVySWQSOQoKc3RhcnRlZF9hdBgFIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI1CghlbmRlZF9hdBgGIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZGVkQXQSFAoFbm90ZXMYByABKAlSBW'
    '5vdGVzEhgKB3ZlcnNpb24YCCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use hygieneObservationDescriptor instead')
const HygieneObservation$json = {
  '1': 'HygieneObservation',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'session_id', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'discipline',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Discipline',
      '10': 'discipline'
    },
    {
      '1': 'moment',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Moment',
      '10': 'moment'
    },
    {
      '1': 'action',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.HygieneAction',
      '10': 'action'
    },
    {'1': 'gloves_worn', '3': 6, '4': 1, '5': 8, '10': 'glovesWorn'},
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

/// Descriptor for `HygieneObservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hygieneObservationDescriptor = $convert.base64Decode(
    'ChJIeWdpZW5lT2JzZXJ2YXRpb24SJQoOb2JzZXJ2YXRpb25faWQYASABKAlSDW9ic2VydmF0aW'
    '9uSWQSHQoKc2Vzc2lvbl9pZBgCIAEoCVIJc2Vzc2lvbklkEkMKCmRpc2NpcGxpbmUYAyABKA4y'
    'Iy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5EaXNjaXBsaW5lUgpkaXNjaXBsaW5lEjcKBm1vbW'
    'VudBgEIAEoDjIfLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLk1vbWVudFIGbW9tZW50Ej4KBmFj'
    'dGlvbhgFIAEoDjImLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkh5Z2llbmVBY3Rpb25SBmFjdG'
    'lvbhIfCgtnbG92ZXNfd29ybhgGIAEoCFIKZ2xvdmVzV29ybhI7CgtvYnNlcnZlZF9hdBgHIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9ic2VydmVkQXQ=');

@$core.Deprecated('Use complianceDescriptor instead')
const Compliance$json = {
  '1': 'Compliance',
  '2': [
    {'1': 'group', '3': 1, '4': 1, '5': 9, '10': 'group'},
    {'1': 'opportunities', '3': 2, '4': 1, '5': 5, '10': 'opportunities'},
    {'1': 'performed', '3': 3, '4': 1, '5': 5, '10': 'performed'},
    {'1': 'permille', '3': 4, '4': 1, '5': 5, '10': 'permille'},
    {'1': 'gloves_instead_of', '3': 5, '4': 1, '5': 5, '10': 'glovesInsteadOf'},
    {'1': 'suppressed', '3': 6, '4': 1, '5': 8, '10': 'suppressed'},
  ],
};

/// Descriptor for `Compliance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complianceDescriptor = $convert.base64Decode(
    'CgpDb21wbGlhbmNlEhQKBWdyb3VwGAEgASgJUgVncm91cBIkCg1vcHBvcnR1bml0aWVzGAIgAS'
    'gFUg1vcHBvcnR1bml0aWVzEhwKCXBlcmZvcm1lZBgDIAEoBVIJcGVyZm9ybWVkEhoKCHBlcm1p'
    'bGxlGAQgASgFUghwZXJtaWxsZRIqChFnbG92ZXNfaW5zdGVhZF9vZhgFIAEoBVIPZ2xvdmVzSW'
    '5zdGVhZE9mEh4KCnN1cHByZXNzZWQYBiABKAhSCnN1cHByZXNzZWQ=');

@$core.Deprecated('Use exposureDescriptor instead')
const Exposure$json = {
  '1': 'Exposure',
  '2': [
    {'1': 'exposure_id', '3': 1, '4': 1, '5': 9, '10': 'exposureId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'staff_id', '3': 3, '4': 1, '5': 9, '10': 'staffId'},
    {
      '1': 'discipline',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Discipline',
      '10': 'discipline'
    },
    {'1': 'facility_id', '3': 5, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 6, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'kind',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.ExposureKind',
      '10': 'kind'
    },
    {'1': 'device', '3': 8, '4': 1, '5': 9, '10': 'device'},
    {'1': 'circumstance', '3': 9, '4': 1, '5': 9, '10': 'circumstance'},
    {'1': 'deep_injury', '3': 10, '4': 1, '5': 8, '10': 'deepInjury'},
    {
      '1': 'source_patient_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'sourcePatientId'
    },
    {'1': 'source_known', '3': 12, '4': 1, '5': 8, '10': 'sourceKnown'},
    {'1': 'source_consented', '3': 13, '4': 1, '5': 8, '10': 'sourceConsented'},
    {
      '1': 'occurred_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'reported_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reported_by', '3': 16, '4': 1, '5': 9, '10': 'reportedBy'},
    {
      '1': 'closed_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 18, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'outcome', '3': 19, '4': 1, '5': 9, '10': 'outcome'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Exposure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exposureDescriptor = $convert.base64Decode(
    'CghFeHBvc3VyZRIfCgtleHBvc3VyZV9pZBgBIAEoCVIKZXhwb3N1cmVJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRIZCghzdGFmZl9pZBgDIAEoCVIHc3RhZmZJZBJDCgpkaXNjaXBs'
    'aW5lGAQgASgOMiMuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuRGlzY2lwbGluZVIKZGlzY2lwbG'
    'luZRIfCgtmYWNpbGl0eV9pZBgFIAEoCVIKZmFjaWxpdHlJZBIfCgtsb2NhdGlvbl9pZBgGIAEo'
    'CVIKbG9jYXRpb25JZBI5CgRraW5kGAcgASgOMiUuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuRX'
    'hwb3N1cmVLaW5kUgRraW5kEhYKBmRldmljZRgIIAEoCVIGZGV2aWNlEiIKDGNpcmN1bXN0YW5j'
    'ZRgJIAEoCVIMY2lyY3Vtc3RhbmNlEh8KC2RlZXBfaW5qdXJ5GAogASgIUgpkZWVwSW5qdXJ5Ei'
    'oKEXNvdXJjZV9wYXRpZW50X2lkGAsgASgJUg9zb3VyY2VQYXRpZW50SWQSIQoMc291cmNlX2tu'
    'b3duGAwgASgIUgtzb3VyY2VLbm93bhIpChBzb3VyY2VfY29uc2VudGVkGA0gASgIUg9zb3VyY2'
    'VDb25zZW50ZWQSOwoLb2NjdXJyZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgpvY2N1cnJlZEF0EjsKC3JlcG9ydGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIKcmVwb3J0ZWRBdBIfCgtyZXBvcnRlZF9ieRgQIAEoCVIKcmVwb3J0ZWRCeRI3'
    'CgljbG9zZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghjbG9zZWRBdB'
    'IbCgljbG9zZWRfYnkYEiABKAlSCGNsb3NlZEJ5EhgKB291dGNvbWUYEyABKAlSB291dGNvbWUS'
    'GAoHdmVyc2lvbhgUIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use exposureTaskDescriptor instead')
const ExposureTask$json = {
  '1': 'ExposureTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'exposure_id', '3': 2, '4': 1, '5': 9, '10': 'exposureId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'due_by',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.TaskState',
      '10': 'state'
    },
    {'1': 'outcome', '3': 6, '4': 1, '5': 9, '10': 'outcome'},
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

/// Descriptor for `ExposureTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exposureTaskDescriptor = $convert.base64Decode(
    'CgxFeHBvc3VyZVRhc2sSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEh8KC2V4cG9zdXJlX2lkGA'
    'IgASgJUgpleHBvc3VyZUlkEhIKBGNvZGUYAyABKAlSBGNvZGUSMQoGZHVlX2J5GAQgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlQnkSOAoFc3RhdGUYBSABKA4yIi5oZWFsdG'
    'hjYXJlLmluZmVjdGlvbi52MS5UYXNrU3RhdGVSBXN0YXRlEhgKB291dGNvbWUYBiABKAlSB291'
    'dGNvbWUSPQoMY29tcGxldGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'ILY29tcGxldGVkQXQSIQoMY29tcGxldGVkX2J5GAggASgJUgtjb21wbGV0ZWRCeQ==');

@$core.Deprecated('Use stewardshipRuleDescriptor instead')
const StewardshipRule$json = {
  '1': 'StewardshipRule',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.TriggerKind',
      '10': 'kind'
    },
    {'1': 'agents', '3': 6, '4': 3, '5': 9, '10': 'agents'},
    {'1': 'all_agents', '3': 7, '4': 1, '5': 8, '10': 'allAgents'},
    {'1': 'day_threshold', '3': 8, '4': 1, '5': 5, '10': 'dayThreshold'},
    {'1': 'prompt', '3': 9, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'approved', '3': 10, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 11, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
    {
      '1': 'created_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 16, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `StewardshipRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stewardshipRuleDescriptor = $convert.base64Decode(
    'Cg9TdGV3YXJkc2hpcFJ1bGUSFwoHcnVsZV9pZBgBIAEoCVIGcnVsZUlkEhIKBGNvZGUYAiABKA'
    'lSBGNvZGUSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghyZXZpc2lvbhgEIAEoBVIIcmV2aXNpb24S'
    'OAoEa2luZBgFIAEoDjIkLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlRyaWdnZXJLaW5kUgRraW'
    '5kEhYKBmFnZW50cxgGIAMoCVIGYWdlbnRzEh0KCmFsbF9hZ2VudHMYByABKAhSCWFsbEFnZW50'
    'cxIjCg1kYXlfdGhyZXNob2xkGAggASgFUgxkYXlUaHJlc2hvbGQSFgoGcHJvbXB0GAkgASgJUg'
    'Zwcm9tcHQSGgoIYXBwcm92ZWQYCiABKAhSCGFwcHJvdmVkEh8KC2FwcHJvdmVkX2J5GAsgASgJ'
    'UgphcHByb3ZlZEJ5EjsKC2FwcHJvdmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIKYXBwcm92ZWRBdBJBCg5lZmZlY3RpdmVfZnJvbRgNIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SPwoNc3VwZXJzZWRlZF9hdBgOIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHN1cGVyc2VkZWRBdBI5CgpjcmVhdGVkX2F0GA8g'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0ZWRfYn'
    'kYECABKAlSCWNyZWF0ZWRCeQ==');

@$core.Deprecated('Use stewardshipReviewDescriptor instead')
const StewardshipReview$json = {
  '1': 'StewardshipReview',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'rule_id', '3': 5, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'rule_code', '3': 6, '4': 1, '5': 9, '10': 'ruleCode'},
    {'1': 'rule_revision', '3': 7, '4': 1, '5': 5, '10': 'ruleRevision'},
    {
      '1': 'kind',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.TriggerKind',
      '10': 'kind'
    },
    {'1': 'agent', '3': 9, '4': 1, '5': 9, '10': 'agent'},
    {'1': 'order_id', '3': 10, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'why', '3': 11, '4': 1, '5': 9, '10': 'why'},
    {
      '1': 'state',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.ReviewState',
      '10': 'state'
    },
    {
      '1': 'raised_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {
      '1': 'due_by',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'recommendation',
      '3': 15,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Recommendation',
      '10': 'recommendation'
    },
    {'1': 'advice', '3': 16, '4': 1, '5': 9, '10': 'advice'},
    {'1': 'reviewed_by', '3': 17, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {
      '1': 'response',
      '3': 19,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Response',
      '10': 'response'
    },
    {'1': 'response_reason', '3': 20, '4': 1, '5': 9, '10': 'responseReason'},
    {'1': 'responded_by', '3': 21, '4': 1, '5': 9, '10': 'respondedBy'},
    {
      '1': 'responded_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondedAt'
    },
    {'1': 'withdrawn_reason', '3': 23, '4': 1, '5': 9, '10': 'withdrawnReason'},
    {'1': 'version', '3': 24, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `StewardshipReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stewardshipReviewDescriptor = $convert.base64Decode(
    'ChFTdGV3YXJkc2hpcFJldmlldxIbCglyZXZpZXdfaWQYASABKAlSCHJldmlld0lkEh0KCnBhdG'
    'llbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYAyABKAlSC2VuY291bnRl'
    'cklkEh8KC2xvY2F0aW9uX2lkGAQgASgJUgpsb2NhdGlvbklkEhcKB3J1bGVfaWQYBSABKAlSBn'
    'J1bGVJZBIbCglydWxlX2NvZGUYBiABKAlSCHJ1bGVDb2RlEiMKDXJ1bGVfcmV2aXNpb24YByAB'
    'KAVSDHJ1bGVSZXZpc2lvbhI4CgRraW5kGAggASgOMiQuaGVhbHRoY2FyZS5pbmZlY3Rpb24udj'
    'EuVHJpZ2dlcktpbmRSBGtpbmQSFAoFYWdlbnQYCSABKAlSBWFnZW50EhkKCG9yZGVyX2lkGAog'
    'ASgJUgdvcmRlcklkEhAKA3doeRgLIAEoCVIDd2h5EjoKBXN0YXRlGAwgASgOMiQuaGVhbHRoY2'
    'FyZS5pbmZlY3Rpb24udjEuUmV2aWV3U3RhdGVSBXN0YXRlEjcKCXJhaXNlZF9hdBgNIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHJhaXNlZEF0EjEKBmR1ZV9ieRgOIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5Ek8KDnJlY29tbWVuZGF0aW9uGA8gASgO'
    'MicuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuUmVjb21tZW5kYXRpb25SDnJlY29tbWVuZGF0aW'
    '9uEhYKBmFkdmljZRgQIAEoCVIGYWR2aWNlEh8KC3Jldmlld2VkX2J5GBEgASgJUgpyZXZpZXdl'
    'ZEJ5EjsKC3Jldmlld2VkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcm'
    'V2aWV3ZWRBdBI9CghyZXNwb25zZRgTIAEoDjIhLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlJl'
    'c3BvbnNlUghyZXNwb25zZRInCg9yZXNwb25zZV9yZWFzb24YFCABKAlSDnJlc3BvbnNlUmVhc2'
    '9uEiEKDHJlc3BvbmRlZF9ieRgVIAEoCVILcmVzcG9uZGVkQnkSPQoMcmVzcG9uZGVkX2F0GBYg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVzcG9uZGVkQXQSKQoQd2l0aGRyYX'
    'duX3JlYXNvbhgXIAEoCVIPd2l0aGRyYXduUmVhc29uEhgKB3ZlcnNpb24YGCABKANSB3ZlcnNp'
    'b24=');

@$core.Deprecated('Use therapyRateDescriptor instead')
const TherapyRate$json = {
  '1': 'TherapyRate',
  '2': [
    {'1': 'therapy_days', '3': 1, '4': 1, '5': 5, '10': 'therapyDays'},
    {'1': 'patient_days', '3': 2, '4': 1, '5': 5, '10': 'patientDays'},
    {
      '1': 'per_thousand_tenths',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'perThousandTenths'
    },
    {'1': 'unanswerable', '3': 4, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `TherapyRate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List therapyRateDescriptor = $convert.base64Decode(
    'CgtUaGVyYXB5UmF0ZRIhCgx0aGVyYXB5X2RheXMYASABKAVSC3RoZXJhcHlEYXlzEiEKDHBhdG'
    'llbnRfZGF5cxgCIAEoBVILcGF0aWVudERheXMSLgoTcGVyX3Rob3VzYW5kX3RlbnRocxgDIAEo'
    'BVIRcGVyVGhvdXNhbmRUZW50aHMSIgoMdW5hbnN3ZXJhYmxlGAQgASgIUgx1bmFuc3dlcmFibG'
    'U=');

@$core.Deprecated('Use stewardshipSummaryDescriptor instead')
const StewardshipSummary$json = {
  '1': 'StewardshipSummary',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
    {'1': 'awaiting', '3': 2, '4': 1, '5': 5, '10': 'awaiting'},
    {'1': 'advised', '3': 3, '4': 1, '5': 5, '10': 'advised'},
    {'1': 'accepted', '3': 4, '4': 1, '5': 5, '10': 'accepted'},
    {'1': 'modified', '3': 5, '4': 1, '5': 5, '10': 'modified'},
    {'1': 'declined', '3': 6, '4': 1, '5': 5, '10': 'declined'},
    {'1': 'withdrawn', '3': 7, '4': 1, '5': 5, '10': 'withdrawn'},
    {'1': 'overdue', '3': 8, '4': 1, '5': 5, '10': 'overdue'},
    {
      '1': 'acceptance_permille',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'acceptancePermille'
    },
    {'1': 'unanswerable', '3': 10, '4': 1, '5': 8, '10': 'unanswerable'},
    {
      '1': 'therapy_rate',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.TherapyRate',
      '10': 'therapyRate'
    },
    {'1': 'indicator_code', '3': 12, '4': 1, '5': 9, '10': 'indicatorCode'},
    {
      '1': 'indicator_revision',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'indicatorRevision'
    },
  ],
};

/// Descriptor for `StewardshipSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stewardshipSummaryDescriptor = $convert.base64Decode(
    'ChJTdGV3YXJkc2hpcFN1bW1hcnkSFgoGcmFpc2VkGAEgASgFUgZyYWlzZWQSGgoIYXdhaXRpbm'
    'cYAiABKAVSCGF3YWl0aW5nEhgKB2FkdmlzZWQYAyABKAVSB2FkdmlzZWQSGgoIYWNjZXB0ZWQY'
    'BCABKAVSCGFjY2VwdGVkEhoKCG1vZGlmaWVkGAUgASgFUghtb2RpZmllZBIaCghkZWNsaW5lZB'
    'gGIAEoBVIIZGVjbGluZWQSHAoJd2l0aGRyYXduGAcgASgFUgl3aXRoZHJhd24SGAoHb3ZlcmR1'
    'ZRgIIAEoBVIHb3ZlcmR1ZRIvChNhY2NlcHRhbmNlX3Blcm1pbGxlGAkgASgFUhJhY2NlcHRhbm'
    'NlUGVybWlsbGUSIgoMdW5hbnN3ZXJhYmxlGAogASgIUgx1bmFuc3dlcmFibGUSRwoMdGhlcmFw'
    'eV9yYXRlGAsgASgLMiQuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuVGhlcmFweVJhdGVSC3RoZX'
    'JhcHlSYXRlEiUKDmluZGljYXRvcl9jb2RlGAwgASgJUg1pbmRpY2F0b3JDb2RlEi0KEmluZGlj'
    'YXRvcl9yZXZpc2lvbhgNIAEoBVIRaW5kaWNhdG9yUmV2aXNpb24=');

@$core.Deprecated('Use environmentalLimitDescriptor instead')
const EnvironmentalLimit$json = {
  '1': 'EnvironmentalLimit',
  '2': [
    {'1': 'limit_id', '3': 1, '4': 1, '5': 9, '10': 'limitId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'sample_kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'unit', '3': 6, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'action_level', '3': 7, '4': 1, '5': 3, '10': 'actionLevel'},
    {'1': 'fail_level', '3': 8, '4': 1, '5': 3, '10': 'failLevel'},
    {'1': 'detection_fails', '3': 9, '4': 1, '5': 8, '10': 'detectionFails'},
    {'1': 'below_is_failure', '3': 10, '4': 1, '5': 8, '10': 'belowIsFailure'},
    {'1': 'approved', '3': 11, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 12, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 17, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `EnvironmentalLimit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List environmentalLimitDescriptor = $convert.base64Decode(
    'ChJFbnZpcm9ubWVudGFsTGltaXQSGQoIbGltaXRfaWQYASABKAlSB2xpbWl0SWQSEgoEY29kZR'
    'gCIAEoCVIEY29kZRISCgRuYW1lGAMgASgJUgRuYW1lEhoKCHJldmlzaW9uGAQgASgFUghyZXZp'
    'c2lvbhJECgtzYW1wbGVfa2luZBgFIAEoDjIjLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlNhbX'
    'BsZUtpbmRSCnNhbXBsZUtpbmQSEgoEdW5pdBgGIAEoCVIEdW5pdBIhCgxhY3Rpb25fbGV2ZWwY'
    'ByABKANSC2FjdGlvbkxldmVsEh0KCmZhaWxfbGV2ZWwYCCABKANSCWZhaWxMZXZlbBInCg9kZX'
    'RlY3Rpb25fZmFpbHMYCSABKAhSDmRldGVjdGlvbkZhaWxzEigKEGJlbG93X2lzX2ZhaWx1cmUY'
    'CiABKAhSDmJlbG93SXNGYWlsdXJlEhoKCGFwcHJvdmVkGAsgASgIUghhcHByb3ZlZBIfCgthcH'
    'Byb3ZlZF9ieRgMIAEoCVIKYXBwcm92ZWRCeRI7CgthcHByb3ZlZF9hdBgNIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQSQQoOZWZmZWN0aXZlX2Zyb20YDiABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEj8KDXN1cGVyc2Vk'
    'ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxzdXBlcnNlZGVkQXQSOQ'
    'oKY3JlYXRlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRB'
    'dBIdCgpjcmVhdGVkX2J5GBEgASgJUgljcmVhdGVkQnk=');

@$core.Deprecated('Use samplingPlanDescriptor instead')
const SamplingPlan$json = {
  '1': 'SamplingPlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'sample_kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'sample_point', '3': 6, '4': 1, '5': 9, '10': 'samplePoint'},
    {'1': 'every_days', '3': 7, '4': 1, '5': 5, '10': 'everyDays'},
    {'1': 'active', '3': 8, '4': 1, '5': 8, '10': 'active'},
    {
      '1': 'started_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'stopped_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
  ],
};

/// Descriptor for `SamplingPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List samplingPlanDescriptor = $convert.base64Decode(
    'CgxTYW1wbGluZ1BsYW4SFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEhIKBGNvZGUYAiABKAlSBG'
    'NvZGUSRAoLc2FtcGxlX2tpbmQYAyABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5TYW1w'
    'bGVLaW5kUgpzYW1wbGVLaW5kEh8KC2ZhY2lsaXR5X2lkGAQgASgJUgpmYWNpbGl0eUlkEh8KC2'
    'xvY2F0aW9uX2lkGAUgASgJUgpsb2NhdGlvbklkEiEKDHNhbXBsZV9wb2ludBgGIAEoCVILc2Ft'
    'cGxlUG9pbnQSHQoKZXZlcnlfZGF5cxgHIAEoBVIJZXZlcnlEYXlzEhYKBmFjdGl2ZRgIIAEoCF'
    'IGYWN0aXZlEjkKCnN0YXJ0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1w'
    'UglzdGFydGVkQXQSOQoKc3RvcHBlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSCXN0b3BwZWRBdA==');

@$core.Deprecated('Use environmentalSampleDescriptor instead')
const EnvironmentalSample$json = {
  '1': 'EnvironmentalSample',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'sample_kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'sample_point', '3': 6, '4': 1, '5': 9, '10': 'samplePoint'},
    {'1': 'plan_id', '3': 7, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'outbreak_id', '3': 8, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'repeat_of_id', '3': 9, '4': 1, '5': 9, '10': 'repeatOfId'},
    {
      '1': 'collected_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'collected_by', '3': 11, '4': 1, '5': 9, '10': 'collectedBy'},
    {'1': 'method', '3': 12, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleState',
      '10': 'state'
    },
    {'1': 'lab_reference', '3': 14, '4': 1, '5': 9, '10': 'labReference'},
    {'1': 'value', '3': 15, '4': 1, '5': 3, '10': 'value'},
    {'1': 'unit', '3': 16, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'organism', '3': 17, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'detected', '3': 18, '4': 1, '5': 8, '10': 'detected'},
    {
      '1': 'resulted_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resultedAt'
    },
    {'1': 'resulted_by', '3': 20, '4': 1, '5': 9, '10': 'resultedBy'},
    {
      '1': 'outcome',
      '3': 21,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Outcome',
      '10': 'outcome'
    },
    {'1': 'limit_code', '3': 22, '4': 1, '5': 9, '10': 'limitCode'},
    {'1': 'limit_revision', '3': 23, '4': 1, '5': 5, '10': 'limitRevision'},
    {
      '1': 'closed_at',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 25, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'version', '3': 26, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `EnvironmentalSample`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List environmentalSampleDescriptor = $convert.base64Decode(
    'ChNFbnZpcm9ubWVudGFsU2FtcGxlEhsKCXNhbXBsZV9pZBgBIAEoCVIIc2FtcGxlSWQSHAoJcm'
    'VmZXJlbmNlGAIgASgJUglyZWZlcmVuY2USRAoLc2FtcGxlX2tpbmQYAyABKA4yIy5oZWFsdGhj'
    'YXJlLmluZmVjdGlvbi52MS5TYW1wbGVLaW5kUgpzYW1wbGVLaW5kEh8KC2ZhY2lsaXR5X2lkGA'
    'QgASgJUgpmYWNpbGl0eUlkEh8KC2xvY2F0aW9uX2lkGAUgASgJUgpsb2NhdGlvbklkEiEKDHNh'
    'bXBsZV9wb2ludBgGIAEoCVILc2FtcGxlUG9pbnQSFwoHcGxhbl9pZBgHIAEoCVIGcGxhbklkEh'
    '8KC291dGJyZWFrX2lkGAggASgJUgpvdXRicmVha0lkEiAKDHJlcGVhdF9vZl9pZBgJIAEoCVIK'
    'cmVwZWF0T2ZJZBI9Cgxjb2xsZWN0ZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgtjb2xsZWN0ZWRBdBIhCgxjb2xsZWN0ZWRfYnkYCyABKAlSC2NvbGxlY3RlZEJ5EhYK'
    'Bm1ldGhvZBgMIAEoCVIGbWV0aG9kEjoKBXN0YXRlGA0gASgOMiQuaGVhbHRoY2FyZS5pbmZlY3'
    'Rpb24udjEuU2FtcGxlU3RhdGVSBXN0YXRlEiMKDWxhYl9yZWZlcmVuY2UYDiABKAlSDGxhYlJl'
    'ZmVyZW5jZRIUCgV2YWx1ZRgPIAEoA1IFdmFsdWUSEgoEdW5pdBgQIAEoCVIEdW5pdBIaCghvcm'
    'dhbmlzbRgRIAEoCVIIb3JnYW5pc20SGgoIZGV0ZWN0ZWQYEiABKAhSCGRldGVjdGVkEjsKC3Jl'
    'c3VsdGVkX2F0GBMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVzdWx0ZWRBdB'
    'IfCgtyZXN1bHRlZF9ieRgUIAEoCVIKcmVzdWx0ZWRCeRI6CgdvdXRjb21lGBUgASgOMiAuaGVh'
    'bHRoY2FyZS5pbmZlY3Rpb24udjEuT3V0Y29tZVIHb3V0Y29tZRIdCgpsaW1pdF9jb2RlGBYgAS'
    'gJUglsaW1pdENvZGUSJQoObGltaXRfcmV2aXNpb24YFyABKAVSDWxpbWl0UmV2aXNpb24SNwoJ'
    'Y2xvc2VkX2F0GBggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIY2xvc2VkQXQSGw'
    'oJY2xvc2VkX2J5GBkgASgJUghjbG9zZWRCeRIYCgd2ZXJzaW9uGBogASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use correctiveActionDescriptor instead')
const CorrectiveAction$json = {
  '1': 'CorrectiveAction',
  '2': [
    {'1': 'action_id', '3': 1, '4': 1, '5': 9, '10': 'actionId'},
    {'1': 'sample_id', '3': 2, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'action', '3': 4, '4': 1, '5': 9, '10': 'action'},
    {'1': 'owner', '3': 5, '4': 1, '5': 9, '10': 'owner'},
    {
      '1': 'due_by',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {
      '1': 'state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.ActionState',
      '10': 'state'
    },
    {
      '1': 'done_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'doneAt'
    },
    {'1': 'done_by', '3': 9, '4': 1, '5': 9, '10': 'doneBy'},
    {'1': 'done_note', '3': 10, '4': 1, '5': 9, '10': 'doneNote'},
    {'1': 'repeat_sample_id', '3': 11, '4': 1, '5': 9, '10': 'repeatSampleId'},
    {
      '1': 'verified_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'verifiedAt'
    },
    {'1': 'verified_by', '3': 13, '4': 1, '5': 9, '10': 'verifiedBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CorrectiveAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctiveActionDescriptor = $convert.base64Decode(
    'ChBDb3JyZWN0aXZlQWN0aW9uEhsKCWFjdGlvbl9pZBgBIAEoCVIIYWN0aW9uSWQSGwoJc2FtcG'
    'xlX2lkGAIgASgJUghzYW1wbGVJZBIfCgtsb2NhdGlvbl9pZBgDIAEoCVIKbG9jYXRpb25JZBIW'
    'CgZhY3Rpb24YBCABKAlSBmFjdGlvbhIUCgVvd25lchgFIAEoCVIFb3duZXISMQoGZHVlX2J5GA'
    'YgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlQnkSOgoFc3RhdGUYByABKA4y'
    'JC5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5BY3Rpb25TdGF0ZVIFc3RhdGUSMwoHZG9uZV9hdB'
    'gIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmRvbmVBdBIXCgdkb25lX2J5GAkg'
    'ASgJUgZkb25lQnkSGwoJZG9uZV9ub3RlGAogASgJUghkb25lTm90ZRIoChByZXBlYXRfc2FtcG'
    'xlX2lkGAsgASgJUg5yZXBlYXRTYW1wbGVJZBI7Cgt2ZXJpZmllZF9hdBgMIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnZlcmlmaWVkQXQSHwoLdmVyaWZpZWRfYnkYDSABKAlSCn'
    'ZlcmlmaWVkQnkSGAoHdmVyc2lvbhgOIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use duePointDescriptor instead')
const DuePoint$json = {
  '1': 'DuePoint',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {
      '1': 'sample_kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'sample_point', '3': 4, '4': 1, '5': 9, '10': 'samplePoint'},
    {
      '1': 'last_taken_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastTakenAt'
    },
    {
      '1': 'due_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'overdue_days', '3': 7, '4': 1, '5': 5, '10': 'overdueDays'},
    {'1': 'never_sampled', '3': 8, '4': 1, '5': 8, '10': 'neverSampled'},
  ],
};

/// Descriptor for `DuePoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duePointDescriptor = $convert.base64Decode(
    'CghEdWVQb2ludBIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSRAoLc2FtcGxlX2tpbmQYAiABKA'
    '4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5TYW1wbGVLaW5kUgpzYW1wbGVLaW5kEh8KC2xv'
    'Y2F0aW9uX2lkGAMgASgJUgpsb2NhdGlvbklkEiEKDHNhbXBsZV9wb2ludBgEIAEoCVILc2FtcG'
    'xlUG9pbnQSPgoNbGFzdF90YWtlbl9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSC2xhc3RUYWtlbkF0EjEKBmR1ZV9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSBWR1ZUF0EiEKDG92ZXJkdWVfZGF5cxgHIAEoBVILb3ZlcmR1ZURheXMSIwoNbmV2ZXJf'
    'c2FtcGxlZBgIIAEoCFIMbmV2ZXJTYW1wbGVk');

@$core.Deprecated('Use environmentSummaryDescriptor instead')
const EnvironmentSummary$json = {
  '1': 'EnvironmentSummary',
  '2': [
    {'1': 'samples', '3': 1, '4': 1, '5': 5, '10': 'samples'},
    {'1': 'passed', '3': 2, '4': 1, '5': 5, '10': 'passed'},
    {'1': 'action_level', '3': 3, '4': 1, '5': 5, '10': 'actionLevel'},
    {'1': 'failed', '3': 4, '4': 1, '5': 5, '10': 'failed'},
    {'1': 'unassessable', '3': 5, '4': 1, '5': 5, '10': 'unassessable'},
    {'1': 'actions_open', '3': 6, '4': 1, '5': 5, '10': 'actionsOpen'},
    {'1': 'actions_done', '3': 7, '4': 1, '5': 5, '10': 'actionsDone'},
    {'1': 'actions_verified', '3': 8, '4': 1, '5': 5, '10': 'actionsVerified'},
    {'1': 'pass_permille', '3': 9, '4': 1, '5': 5, '10': 'passPermille'},
    {'1': 'unanswerable', '3': 10, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `EnvironmentSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List environmentSummaryDescriptor = $convert.base64Decode(
    'ChJFbnZpcm9ubWVudFN1bW1hcnkSGAoHc2FtcGxlcxgBIAEoBVIHc2FtcGxlcxIWCgZwYXNzZW'
    'QYAiABKAVSBnBhc3NlZBIhCgxhY3Rpb25fbGV2ZWwYAyABKAVSC2FjdGlvbkxldmVsEhYKBmZh'
    'aWxlZBgEIAEoBVIGZmFpbGVkEiIKDHVuYXNzZXNzYWJsZRgFIAEoBVIMdW5hc3Nlc3NhYmxlEi'
    'EKDGFjdGlvbnNfb3BlbhgGIAEoBVILYWN0aW9uc09wZW4SIQoMYWN0aW9uc19kb25lGAcgASgF'
    'UgthY3Rpb25zRG9uZRIpChBhY3Rpb25zX3ZlcmlmaWVkGAggASgFUg9hY3Rpb25zVmVyaWZpZW'
    'QSIwoNcGFzc19wZXJtaWxsZRgJIAEoBVIMcGFzc1Blcm1pbGxlEiIKDHVuYW5zd2VyYWJsZRgK'
    'IAEoCFIMdW5hbnN3ZXJhYmxl');

@$core.Deprecated('Use openCaseRequestDescriptor instead')
const OpenCaseRequest$json = {
  '1': 'OpenCaseRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'organism', '3': 6, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'organism_code', '3': 7, '4': 1, '5': 9, '10': 'organismCode'},
    {
      '1': 'site',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.InfectionSite',
      '10': 'site'
    },
    {
      '1': 'admitted_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'admittedAt'
    },
    {
      '1': 'onset_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'device_in_situ', '3': 11, '4': 1, '5': 8, '10': 'deviceInSitu'},
    {'1': 'device_days', '3': 12, '4': 1, '5': 5, '10': 'deviceDays'},
    {'1': 'criteria', '3': 13, '4': 1, '5': 9, '10': 'criteria'},
    {'1': 'notes', '3': 14, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `OpenCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCaseRequestDescriptor = $convert.base64Decode(
    'Cg9PcGVuQ2FzZVJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USHQoKcGF0aW'
    'VudF9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVy'
    'SWQSHwoLZmFjaWxpdHlfaWQYBCABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYBSABKA'
    'lSCmxvY2F0aW9uSWQSGgoIb3JnYW5pc20YBiABKAlSCG9yZ2FuaXNtEiMKDW9yZ2FuaXNtX2Nv'
    'ZGUYByABKAlSDG9yZ2FuaXNtQ29kZRI6CgRzaXRlGAggASgOMiYuaGVhbHRoY2FyZS5pbmZlY3'
    'Rpb24udjEuSW5mZWN0aW9uU2l0ZVIEc2l0ZRI7CgthZG1pdHRlZF9hdBgJIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFkbWl0dGVkQXQSNQoIb25zZXRfYXQYCiABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgdvbnNldEF0EiQKDmRldmljZV9pbl9zaXR1GAsgASgI'
    'UgxkZXZpY2VJblNpdHUSHwoLZGV2aWNlX2RheXMYDCABKAVSCmRldmljZURheXMSGgoIY3JpdG'
    'VyaWEYDSABKAlSCGNyaXRlcmlhEhQKBW5vdGVzGA4gASgJUgVub3Rlcw==');

@$core.Deprecated('Use openCaseResponseDescriptor instead')
const OpenCaseResponse$json = {
  '1': 'OpenCaseResponse',
  '2': [
    {
      '1': 'surveillance_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.SurveillanceCase',
      '10': 'surveillanceCase'
    },
  ],
};

/// Descriptor for `OpenCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCaseResponseDescriptor = $convert.base64Decode(
    'ChBPcGVuQ2FzZVJlc3BvbnNlElYKEXN1cnZlaWxsYW5jZV9jYXNlGAEgASgLMikuaGVhbHRoY2'
    'FyZS5pbmZlY3Rpb24udjEuU3VydmVpbGxhbmNlQ2FzZVIQc3VydmVpbGxhbmNlQ2FzZQ==');

@$core.Deprecated('Use reviewCaseRequestDescriptor instead')
const ReviewCaseRequest$json = {
  '1': 'ReviewCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.CaseState',
      '10': 'state'
    },
    {'1': 'criteria', '3': 3, '4': 1, '5': 9, '10': 'criteria'},
  ],
};

/// Descriptor for `ReviewCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCaseRequestDescriptor = $convert.base64Decode(
    'ChFSZXZpZXdDYXNlUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSOAoFc3RhdGUYAi'
    'ABKA4yIi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5DYXNlU3RhdGVSBXN0YXRlEhoKCGNyaXRl'
    'cmlhGAMgASgJUghjcml0ZXJpYQ==');

@$core.Deprecated('Use reviewCaseResponseDescriptor instead')
const ReviewCaseResponse$json = {
  '1': 'ReviewCaseResponse',
  '2': [
    {
      '1': 'surveillance_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.SurveillanceCase',
      '10': 'surveillanceCase'
    },
  ],
};

/// Descriptor for `ReviewCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCaseResponseDescriptor = $convert.base64Decode(
    'ChJSZXZpZXdDYXNlUmVzcG9uc2USVgoRc3VydmVpbGxhbmNlX2Nhc2UYASABKAsyKS5oZWFsdG'
    'hjYXJlLmluZmVjdGlvbi52MS5TdXJ2ZWlsbGFuY2VDYXNlUhBzdXJ2ZWlsbGFuY2VDYXNl');

@$core.Deprecated('Use overrideOnsetRequestDescriptor instead')
const OverrideOnsetRequest$json = {
  '1': 'OverrideOnsetRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'onset',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Onset',
      '10': 'onset'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OverrideOnsetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideOnsetRequestDescriptor = $convert.base64Decode(
    'ChRPdmVycmlkZU9uc2V0UmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSNAoFb25zZX'
    'QYAiABKA4yHi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5PbnNldFIFb25zZXQSFgoGcmVhc29u'
    'GAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use overrideOnsetResponseDescriptor instead')
const OverrideOnsetResponse$json = {
  '1': 'OverrideOnsetResponse',
  '2': [
    {
      '1': 'surveillance_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.SurveillanceCase',
      '10': 'surveillanceCase'
    },
  ],
};

/// Descriptor for `OverrideOnsetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideOnsetResponseDescriptor = $convert.base64Decode(
    'ChVPdmVycmlkZU9uc2V0UmVzcG9uc2USVgoRc3VydmVpbGxhbmNlX2Nhc2UYASABKAsyKS5oZW'
    'FsdGhjYXJlLmluZmVjdGlvbi52MS5TdXJ2ZWlsbGFuY2VDYXNlUhBzdXJ2ZWlsbGFuY2VDYXNl');

@$core.Deprecated('Use listCasesRequestDescriptor instead')
const ListCasesRequest$json = {
  '1': 'ListCasesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.CaseState',
      '10': 'state'
    },
    {
      '1': 'site',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.InfectionSite',
      '10': 'site'
    },
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'onset_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetFrom'
    },
    {
      '1': 'onset_to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetTo'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 8, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListCasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Q2FzZXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBI4CgVzdG'
    'F0ZRgCIAEoDjIiLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkNhc2VTdGF0ZVIFc3RhdGUSOgoE'
    'c2l0ZRgDIAEoDjImLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkluZmVjdGlvblNpdGVSBHNpdG'
    'USHwoLbG9jYXRpb25faWQYBCABKAlSCmxvY2F0aW9uSWQSOQoKb25zZXRfZnJvbRgFIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCW9uc2V0RnJvbRI1CghvbnNldF90bxgGIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB29uc2V0VG8SGwoJcGFnZV9zaXplGAcgASgF'
    'UghwYWdlU2l6ZRIfCgtwYWdlX29mZnNldBgIIAEoBVIKcGFnZU9mZnNldA==');

@$core.Deprecated('Use listCasesResponseDescriptor instead')
const ListCasesResponse$json = {
  '1': 'ListCasesResponse',
  '2': [
    {
      '1': 'cases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.SurveillanceCase',
      '10': 'cases'
    },
  ],
};

/// Descriptor for `ListCasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Q2FzZXNSZXNwb25zZRI/CgVjYXNlcxgBIAMoCzIpLmhlYWx0aGNhcmUuaW5mZWN0aW'
    '9uLnYxLlN1cnZlaWxsYW5jZUNhc2VSBWNhc2Vz');

@$core.Deprecated('Use recordDeviceDaysRequestDescriptor instead')
const RecordDeviceDaysRequest$json = {
  '1': 'RecordDeviceDaysRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'device',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.DeviceKind',
      '10': 'device'
    },
    {
      '1': 'counted_on',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'countedOn'
    },
    {'1': 'patient_days', '3': 5, '4': 1, '5': 5, '10': 'patientDays'},
    {'1': 'device_days', '3': 6, '4': 1, '5': 5, '10': 'deviceDays'},
  ],
};

/// Descriptor for `RecordDeviceDaysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeviceDaysRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmREZXZpY2VEYXlzUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
    'lJZBIfCgtsb2NhdGlvbl9pZBgCIAEoCVIKbG9jYXRpb25JZBI7CgZkZXZpY2UYAyABKA4yIy5o'
    'ZWFsdGhjYXJlLmluZmVjdGlvbi52MS5EZXZpY2VLaW5kUgZkZXZpY2USOQoKY291bnRlZF9vbh'
    'gEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNvdW50ZWRPbhIhCgxwYXRpZW50'
    'X2RheXMYBSABKAVSC3BhdGllbnREYXlzEh8KC2RldmljZV9kYXlzGAYgASgFUgpkZXZpY2VEYX'
    'lz');

@$core.Deprecated('Use recordDeviceDaysResponseDescriptor instead')
const RecordDeviceDaysResponse$json = {
  '1': 'RecordDeviceDaysResponse',
  '2': [
    {
      '1': 'count',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.DeviceDayCount',
      '10': 'count'
    },
  ],
};

/// Descriptor for `RecordDeviceDaysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeviceDaysResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmREZXZpY2VEYXlzUmVzcG9uc2USPQoFY291bnQYASABKAsyJy5oZWFsdGhjYXJlLm'
        'luZmVjdGlvbi52MS5EZXZpY2VEYXlDb3VudFIFY291bnQ=');

@$core.Deprecated('Use getRateRequestDescriptor instead')
const GetRateRequest$json = {
  '1': 'GetRateRequest',
  '2': [
    {
      '1': 'site',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.InfectionSite',
      '10': 'site'
    },
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
  ],
};

/// Descriptor for `GetRateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRateRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRSYXRlUmVxdWVzdBI6CgRzaXRlGAEgASgOMiYuaGVhbHRoY2FyZS5pbmZlY3Rpb24udj'
    'EuSW5mZWN0aW9uU2l0ZVIEc2l0ZRIfCgtsb2NhdGlvbl9pZBgCIAEoCVIKbG9jYXRpb25JZBI7'
    'CgtwZXJpb2RfZnJvbRgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnBlcmlvZE'
    'Zyb20SNwoJcGVyaW9kX3RvGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcGVy'
    'aW9kVG8=');

@$core.Deprecated('Use getRateResponseDescriptor instead')
const GetRateResponse$json = {
  '1': 'GetRateResponse',
  '2': [
    {
      '1': 'rate',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Rate',
      '10': 'rate'
    },
  ],
};

/// Descriptor for `GetRateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRateResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRSYXRlUmVzcG9uc2USMQoEcmF0ZRgBIAEoCzIdLmhlYWx0aGNhcmUuaW5mZWN0aW9uLn'
    'YxLlJhdGVSBHJhdGU=');

@$core.Deprecated('Use startIsolationRequestDescriptor instead')
const StartIsolationRequest$json = {
  '1': 'StartIsolationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'bed_id', '3': 5, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'precaution',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'case_id', '3': 8, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'started_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartIsolationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startIsolationRequestDescriptor = $convert.base64Decode(
    'ChVTdGFydElzb2xhdGlvblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSHwoLZmFjaWxpdHlfaWQYAyABKAlS'
    'CmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYBCABKAlSCmxvY2F0aW9uSWQSFQoGYmVkX2lkGA'
    'UgASgJUgViZWRJZBJDCgpwcmVjYXV0aW9uGAYgASgOMiMuaGVhbHRoY2FyZS5pbmZlY3Rpb24u'
    'djEuUHJlY2F1dGlvblIKcHJlY2F1dGlvbhIWCgZyZWFzb24YByABKAlSBnJlYXNvbhIXCgdjYX'
    'NlX2lkGAggASgJUgZjYXNlSWQSOQoKc3RhcnRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdA==');

@$core.Deprecated('Use startIsolationResponseDescriptor instead')
const StartIsolationResponse$json = {
  '1': 'StartIsolationResponse',
  '2': [
    {
      '1': 'isolation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Isolation',
      '10': 'isolation'
    },
  ],
};

/// Descriptor for `StartIsolationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startIsolationResponseDescriptor =
    $convert.base64Decode(
        'ChZTdGFydElzb2xhdGlvblJlc3BvbnNlEkAKCWlzb2xhdGlvbhgBIAEoCzIiLmhlYWx0aGNhcm'
        'UuaW5mZWN0aW9uLnYxLklzb2xhdGlvblIJaXNvbGF0aW9u');

@$core.Deprecated('Use extendIsolationRequestDescriptor instead')
const ExtendIsolationRequest$json = {
  '1': 'ExtendIsolationRequest',
  '2': [
    {'1': 'isolation_id', '3': 1, '4': 1, '5': 9, '10': 'isolationId'},
  ],
};

/// Descriptor for `ExtendIsolationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extendIsolationRequestDescriptor =
    $convert.base64Decode(
        'ChZFeHRlbmRJc29sYXRpb25SZXF1ZXN0EiEKDGlzb2xhdGlvbl9pZBgBIAEoCVILaXNvbGF0aW'
        '9uSWQ=');

@$core.Deprecated('Use extendIsolationResponseDescriptor instead')
const ExtendIsolationResponse$json = {
  '1': 'ExtendIsolationResponse',
  '2': [
    {
      '1': 'isolation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Isolation',
      '10': 'isolation'
    },
  ],
};

/// Descriptor for `ExtendIsolationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List extendIsolationResponseDescriptor =
    $convert.base64Decode(
        'ChdFeHRlbmRJc29sYXRpb25SZXNwb25zZRJACglpc29sYXRpb24YASABKAsyIi5oZWFsdGhjYX'
        'JlLmluZmVjdGlvbi52MS5Jc29sYXRpb25SCWlzb2xhdGlvbg==');

@$core.Deprecated('Use endIsolationRequestDescriptor instead')
const EndIsolationRequest$json = {
  '1': 'EndIsolationRequest',
  '2': [
    {'1': 'isolation_id', '3': 1, '4': 1, '5': 9, '10': 'isolationId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `EndIsolationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endIsolationRequestDescriptor = $convert.base64Decode(
    'ChNFbmRJc29sYXRpb25SZXF1ZXN0EiEKDGlzb2xhdGlvbl9pZBgBIAEoCVILaXNvbGF0aW9uSW'
    'QSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use endIsolationResponseDescriptor instead')
const EndIsolationResponse$json = {
  '1': 'EndIsolationResponse',
  '2': [
    {
      '1': 'isolation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Isolation',
      '10': 'isolation'
    },
  ],
};

/// Descriptor for `EndIsolationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endIsolationResponseDescriptor = $convert.base64Decode(
    'ChRFbmRJc29sYXRpb25SZXNwb25zZRJACglpc29sYXRpb24YASABKAsyIi5oZWFsdGhjYXJlLm'
    'luZmVjdGlvbi52MS5Jc29sYXRpb25SCWlzb2xhdGlvbg==');

@$core.Deprecated('Use getBoardRequestDescriptor instead')
const GetBoardRequest$json = {
  '1': 'GetBoardRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
  ],
};

/// Descriptor for `GetBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCb2FyZFJlcXVlc3QSHwoLbG9jYXRpb25faWQYASABKAlSCmxvY2F0aW9uSWQ=');

@$core.Deprecated('Use getBoardResponseDescriptor instead')
const GetBoardResponse$json = {
  '1': 'GetBoardResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.BoardEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCb2FyZFJlc3BvbnNlEj0KB2VudHJpZXMYASADKAsyIy5oZWFsdGhjYXJlLmluZmVjdG'
    'lvbi52MS5Cb2FyZEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use draftAlertRuleRequestDescriptor instead')
const DraftAlertRuleRequest$json = {
  '1': 'DraftAlertRuleRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'organisms', '3': 4, '4': 3, '5': 9, '10': 'organisms'},
    {'1': 'lookback_days', '3': 5, '4': 1, '5': 5, '10': 'lookbackDays'},
    {
      '1': 'precaution',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Precaution',
      '10': 'precaution'
    },
    {'1': 'advice', '3': 7, '4': 1, '5': 9, '10': 'advice'},
  ],
};

/// Descriptor for `DraftAlertRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftAlertRuleRequestDescriptor = $convert.base64Decode(
    'ChVEcmFmdEFsZXJ0UnVsZVJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEhoKCHJldmlzaW9uGAMgASgFUghyZXZpc2lvbhIcCglvcmdhbmlzbXMYBCADKAlS'
    'CW9yZ2FuaXNtcxIjCg1sb29rYmFja19kYXlzGAUgASgFUgxsb29rYmFja0RheXMSQwoKcHJlY2'
    'F1dGlvbhgGIAEoDjIjLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlByZWNhdXRpb25SCnByZWNh'
    'dXRpb24SFgoGYWR2aWNlGAcgASgJUgZhZHZpY2U=');

@$core.Deprecated('Use draftAlertRuleResponseDescriptor instead')
const DraftAlertRuleResponse$json = {
  '1': 'DraftAlertRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.AlertRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `DraftAlertRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftAlertRuleResponseDescriptor =
    $convert.base64Decode(
        'ChZEcmFmdEFsZXJ0UnVsZVJlc3BvbnNlEjYKBHJ1bGUYASABKAsyIi5oZWFsdGhjYXJlLmluZm'
        'VjdGlvbi52MS5BbGVydFJ1bGVSBHJ1bGU=');

@$core.Deprecated('Use approveAlertRuleRequestDescriptor instead')
const ApproveAlertRuleRequest$json = {
  '1': 'ApproveAlertRuleRequest',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
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

/// Descriptor for `ApproveAlertRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveAlertRuleRequestDescriptor = $convert.base64Decode(
    'ChdBcHByb3ZlQWxlcnRSdWxlUmVxdWVzdBIXCgdydWxlX2lkGAEgASgJUgZydWxlSWQSQQoOZW'
    'ZmZWN0aXZlX2Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3Rp'
    'dmVGcm9t');

@$core.Deprecated('Use approveAlertRuleResponseDescriptor instead')
const ApproveAlertRuleResponse$json = {
  '1': 'ApproveAlertRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.AlertRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `ApproveAlertRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveAlertRuleResponseDescriptor =
    $convert.base64Decode(
        'ChhBcHByb3ZlQWxlcnRSdWxlUmVzcG9uc2USNgoEcnVsZRgBIAEoCzIiLmhlYWx0aGNhcmUuaW'
        '5mZWN0aW9uLnYxLkFsZXJ0UnVsZVIEcnVsZQ==');

@$core.Deprecated('Use screenEncounterRequestDescriptor instead')
const ScreenEncounterRequest$json = {
  '1': 'ScreenEncounterRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'organism', '3': 4, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'organism_code', '3': 5, '4': 1, '5': 9, '10': 'organismCode'},
    {
      '1': 'last_positive_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastPositiveAt'
    },
  ],
};

/// Descriptor for `ScreenEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenEncounterRequestDescriptor = $convert.base64Decode(
    'ChZTY3JlZW5FbmNvdW50ZXJSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IhCgxlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEh8KC2ZhY2lsaXR5X2lkGAMgASgJ'
    'UgpmYWNpbGl0eUlkEhoKCG9yZ2FuaXNtGAQgASgJUghvcmdhbmlzbRIjCg1vcmdhbmlzbV9jb2'
    'RlGAUgASgJUgxvcmdhbmlzbUNvZGUSRAoQbGFzdF9wb3NpdGl2ZV9hdBgGIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmxhc3RQb3NpdGl2ZUF0');

@$core.Deprecated('Use screenEncounterResponseDescriptor instead')
const ScreenEncounterResponse$json = {
  '1': 'ScreenEncounterResponse',
  '2': [
    {
      '1': 'alerts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.Alert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `ScreenEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List screenEncounterResponseDescriptor =
    $convert.base64Decode(
        'ChdTY3JlZW5FbmNvdW50ZXJSZXNwb25zZRI2CgZhbGVydHMYASADKAsyHi5oZWFsdGhjYXJlLm'
        'luZmVjdGlvbi52MS5BbGVydFIGYWxlcnRz');

@$core.Deprecated('Use acknowledgeAlertRequestDescriptor instead')
const AcknowledgeAlertRequest$json = {
  '1': 'AcknowledgeAlertRequest',
  '2': [
    {'1': 'alert_id', '3': 1, '4': 1, '5': 9, '10': 'alertId'},
  ],
};

/// Descriptor for `AcknowledgeAlertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeAlertRequestDescriptor =
    $convert.base64Decode(
        'ChdBY2tub3dsZWRnZUFsZXJ0UmVxdWVzdBIZCghhbGVydF9pZBgBIAEoCVIHYWxlcnRJZA==');

@$core.Deprecated('Use acknowledgeAlertResponseDescriptor instead')
const AcknowledgeAlertResponse$json = {
  '1': 'AcknowledgeAlertResponse',
  '2': [
    {
      '1': 'alert',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Alert',
      '10': 'alert'
    },
  ],
};

/// Descriptor for `AcknowledgeAlertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeAlertResponseDescriptor =
    $convert.base64Decode(
        'ChhBY2tub3dsZWRnZUFsZXJ0UmVzcG9uc2USNAoFYWxlcnQYASABKAsyHi5oZWFsdGhjYXJlLm'
        'luZmVjdGlvbi52MS5BbGVydFIFYWxlcnQ=');

@$core.Deprecated('Use overrideAlertRequestDescriptor instead')
const OverrideAlertRequest$json = {
  '1': 'OverrideAlertRequest',
  '2': [
    {'1': 'alert_id', '3': 1, '4': 1, '5': 9, '10': 'alertId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OverrideAlertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideAlertRequestDescriptor = $convert.base64Decode(
    'ChRPdmVycmlkZUFsZXJ0UmVxdWVzdBIZCghhbGVydF9pZBgBIAEoCVIHYWxlcnRJZBIWCgZyZW'
    'Fzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use overrideAlertResponseDescriptor instead')
const OverrideAlertResponse$json = {
  '1': 'OverrideAlertResponse',
  '2': [
    {
      '1': 'alert',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Alert',
      '10': 'alert'
    },
  ],
};

/// Descriptor for `OverrideAlertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideAlertResponseDescriptor = $convert.base64Decode(
    'ChVPdmVycmlkZUFsZXJ0UmVzcG9uc2USNAoFYWxlcnQYASABKAsyHi5oZWFsdGhjYXJlLmluZm'
    'VjdGlvbi52MS5BbGVydFIFYWxlcnQ=');

@$core.Deprecated('Use listAlertsRequestDescriptor instead')
const ListAlertsRequest$json = {
  '1': 'ListAlertsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'outstanding_only', '3': 3, '4': 1, '5': 8, '10': 'outstandingOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWxlcnRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIpChBvdXRzdGFuZGluZ19vbmx5GAMgASgI'
    'Ug9vdXRzdGFuZGluZ09ubHkSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listAlertsResponseDescriptor instead')
const ListAlertsResponse$json = {
  '1': 'ListAlertsResponse',
  '2': [
    {
      '1': 'alerts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.Alert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `ListAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWxlcnRzUmVzcG9uc2USNgoGYWxlcnRzGAEgAygLMh4uaGVhbHRoY2FyZS5pbmZlY3'
    'Rpb24udjEuQWxlcnRSBmFsZXJ0cw==');

@$core.Deprecated('Use openOutbreakRequestDescriptor instead')
const OpenOutbreakRequest$json = {
  '1': 'OpenOutbreakRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'organism', '3': 2, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'case_definition', '3': 3, '4': 1, '5': 9, '10': 'caseDefinition'},
    {'1': 'locations', '3': 4, '4': 3, '5': 9, '10': 'locations'},
    {
      '1': 'window_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'windowFrom'
    },
    {
      '1': 'window_to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'windowTo'
    },
  ],
};

/// Descriptor for `OpenOutbreakRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openOutbreakRequestDescriptor = $convert.base64Decode(
    'ChNPcGVuT3V0YnJlYWtSZXF1ZXN0EhwKCXJlZmVyZW5jZRgBIAEoCVIJcmVmZXJlbmNlEhoKCG'
    '9yZ2FuaXNtGAIgASgJUghvcmdhbmlzbRInCg9jYXNlX2RlZmluaXRpb24YAyABKAlSDmNhc2VE'
    'ZWZpbml0aW9uEhwKCWxvY2F0aW9ucxgEIAMoCVIJbG9jYXRpb25zEjsKC3dpbmRvd19mcm9tGA'
    'UgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKd2luZG93RnJvbRI3Cgl3aW5kb3df'
    'dG8YBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgh3aW5kb3dUbw==');

@$core.Deprecated('Use openOutbreakResponseDescriptor instead')
const OpenOutbreakResponse$json = {
  '1': 'OpenOutbreakResponse',
  '2': [
    {
      '1': 'outbreak',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Outbreak',
      '10': 'outbreak'
    },
  ],
};

/// Descriptor for `OpenOutbreakResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openOutbreakResponseDescriptor = $convert.base64Decode(
    'ChRPcGVuT3V0YnJlYWtSZXNwb25zZRI9CghvdXRicmVhaxgBIAEoCzIhLmhlYWx0aGNhcmUuaW'
    '5mZWN0aW9uLnYxLk91dGJyZWFrUghvdXRicmVhaw==');

@$core.Deprecated('Use advanceOutbreakRequestDescriptor instead')
const AdvanceOutbreakRequest$json = {
  '1': 'AdvanceOutbreakRequest',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.OutbreakState',
      '10': 'state'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AdvanceOutbreakRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceOutbreakRequestDescriptor = $convert.base64Decode(
    'ChZBZHZhbmNlT3V0YnJlYWtSZXF1ZXN0Eh8KC291dGJyZWFrX2lkGAEgASgJUgpvdXRicmVha0'
    'lkEjwKBXN0YXRlGAIgASgOMiYuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuT3V0YnJlYWtTdGF0'
    'ZVIFc3RhdGUSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use advanceOutbreakResponseDescriptor instead')
const AdvanceOutbreakResponse$json = {
  '1': 'AdvanceOutbreakResponse',
  '2': [
    {
      '1': 'outbreak',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Outbreak',
      '10': 'outbreak'
    },
  ],
};

/// Descriptor for `AdvanceOutbreakResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceOutbreakResponseDescriptor =
    $convert.base64Decode(
        'ChdBZHZhbmNlT3V0YnJlYWtSZXNwb25zZRI9CghvdXRicmVhaxgBIAEoCzIhLmhlYWx0aGNhcm'
        'UuaW5mZWN0aW9uLnYxLk91dGJyZWFrUghvdXRicmVhaw==');

@$core.Deprecated('Use closeOutbreakRequestDescriptor instead')
const CloseOutbreakRequest$json = {
  '1': 'CloseOutbreakRequest',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'findings', '3': 2, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'control_measures', '3': 4, '4': 3, '5': 9, '10': 'controlMeasures'},
    {'1': 'action_ids', '3': 5, '4': 3, '5': 9, '10': 'actionIds'},
  ],
};

/// Descriptor for `CloseOutbreakRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeOutbreakRequestDescriptor = $convert.base64Decode(
    'ChRDbG9zZU91dGJyZWFrUmVxdWVzdBIfCgtvdXRicmVha19pZBgBIAEoCVIKb3V0YnJlYWtJZB'
    'IaCghmaW5kaW5ncxgCIAEoCVIIZmluZGluZ3MSFgoGcmVhc29uGAMgASgJUgZyZWFzb24SKQoQ'
    'Y29udHJvbF9tZWFzdXJlcxgEIAMoCVIPY29udHJvbE1lYXN1cmVzEh0KCmFjdGlvbl9pZHMYBS'
    'ADKAlSCWFjdGlvbklkcw==');

@$core.Deprecated('Use closeOutbreakResponseDescriptor instead')
const CloseOutbreakResponse$json = {
  '1': 'CloseOutbreakResponse',
  '2': [
    {
      '1': 'outbreak',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Outbreak',
      '10': 'outbreak'
    },
  ],
};

/// Descriptor for `CloseOutbreakResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeOutbreakResponseDescriptor = $convert.base64Decode(
    'ChVDbG9zZU91dGJyZWFrUmVzcG9uc2USPQoIb3V0YnJlYWsYASABKAsyIS5oZWFsdGhjYXJlLm'
    'luZmVjdGlvbi52MS5PdXRicmVha1IIb3V0YnJlYWs=');

@$core.Deprecated('Use addOutbreakMemberRequestDescriptor instead')
const AddOutbreakMemberRequest$json = {
  '1': 'AddOutbreakMemberRequest',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'reason',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.MembershipReason',
      '10': 'reason'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `AddOutbreakMemberRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addOutbreakMemberRequestDescriptor = $convert.base64Decode(
    'ChhBZGRPdXRicmVha01lbWJlclJlcXVlc3QSHwoLb3V0YnJlYWtfaWQYASABKAlSCm91dGJyZW'
    'FrSWQSFwoHY2FzZV9pZBgCIAEoCVIGY2FzZUlkEkEKBnJlYXNvbhgDIAEoDjIpLmhlYWx0aGNh'
    'cmUuaW5mZWN0aW9uLnYxLk1lbWJlcnNoaXBSZWFzb25SBnJlYXNvbhISCgRub3RlGAQgASgJUg'
    'Rub3Rl');

@$core.Deprecated('Use addOutbreakMemberResponseDescriptor instead')
const AddOutbreakMemberResponse$json = {
  '1': 'AddOutbreakMemberResponse',
  '2': [
    {
      '1': 'membership',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Membership',
      '10': 'membership'
    },
  ],
};

/// Descriptor for `AddOutbreakMemberResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addOutbreakMemberResponseDescriptor =
    $convert.base64Decode(
        'ChlBZGRPdXRicmVha01lbWJlclJlc3BvbnNlEkMKCm1lbWJlcnNoaXAYASABKAsyIy5oZWFsdG'
        'hjYXJlLmluZmVjdGlvbi52MS5NZW1iZXJzaGlwUgptZW1iZXJzaGlw');

@$core.Deprecated('Use getClusterRequestDescriptor instead')
const GetClusterRequest$json = {
  '1': 'GetClusterRequest',
  '2': [
    {'1': 'outbreak_id', '3': 1, '4': 1, '5': 9, '10': 'outbreakId'},
  ],
};

/// Descriptor for `GetClusterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClusterRequestDescriptor = $convert.base64Decode(
    'ChFHZXRDbHVzdGVyUmVxdWVzdBIfCgtvdXRicmVha19pZBgBIAEoCVIKb3V0YnJlYWtJZA==');

@$core.Deprecated('Use getClusterResponseDescriptor instead')
const GetClusterResponse$json = {
  '1': 'GetClusterResponse',
  '2': [
    {
      '1': 'cluster',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.ClusterSummary',
      '10': 'cluster'
    },
  ],
};

/// Descriptor for `GetClusterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getClusterResponseDescriptor = $convert.base64Decode(
    'ChJHZXRDbHVzdGVyUmVzcG9uc2USQQoHY2x1c3RlchgBIAEoCzInLmhlYWx0aGNhcmUuaW5mZW'
    'N0aW9uLnYxLkNsdXN0ZXJTdW1tYXJ5UgdjbHVzdGVy');

@$core.Deprecated('Use listOutbreaksRequestDescriptor instead')
const ListOutbreaksRequest$json = {
  '1': 'ListOutbreaksRequest',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.OutbreakState',
      '10': 'state'
    },
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListOutbreaksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutbreaksRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0T3V0YnJlYWtzUmVxdWVzdBI8CgVzdGF0ZRgBIAEoDjImLmhlYWx0aGNhcmUuaW5mZW'
    'N0aW9uLnYxLk91dGJyZWFrU3RhdGVSBXN0YXRlEhsKCW9wZW5fb25seRgCIAEoCFIIb3Blbk9u'
    'bHkSGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listOutbreaksResponseDescriptor instead')
const ListOutbreaksResponse$json = {
  '1': 'ListOutbreaksResponse',
  '2': [
    {
      '1': 'outbreaks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.Outbreak',
      '10': 'outbreaks'
    },
  ],
};

/// Descriptor for `ListOutbreaksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutbreaksResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0T3V0YnJlYWtzUmVzcG9uc2USPwoJb3V0YnJlYWtzGAEgAygLMiEuaGVhbHRoY2FyZS'
    '5pbmZlY3Rpb24udjEuT3V0YnJlYWtSCW91dGJyZWFrcw==');

@$core.Deprecated('Use startHygieneSessionRequestDescriptor instead')
const StartHygieneSessionRequest$json = {
  '1': 'StartHygieneSessionRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'notes', '3': 3, '4': 1, '5': 9, '10': 'notes'},
    {
      '1': 'started_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `StartHygieneSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startHygieneSessionRequestDescriptor = $convert.base64Decode(
    'ChpTdGFydEh5Z2llbmVTZXNzaW9uUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaW'
    'xpdHlJZBIfCgtsb2NhdGlvbl9pZBgCIAEoCVIKbG9jYXRpb25JZBIUCgVub3RlcxgDIAEoCVIF'
    'bm90ZXMSOQoKc3RhcnRlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCX'
    'N0YXJ0ZWRBdA==');

@$core.Deprecated('Use startHygieneSessionResponseDescriptor instead')
const StartHygieneSessionResponse$json = {
  '1': 'StartHygieneSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.HygieneSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `StartHygieneSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startHygieneSessionResponseDescriptor =
    $convert.base64Decode(
        'ChtTdGFydEh5Z2llbmVTZXNzaW9uUmVzcG9uc2USQQoHc2Vzc2lvbhgBIAEoCzInLmhlYWx0aG'
        'NhcmUuaW5mZWN0aW9uLnYxLkh5Z2llbmVTZXNzaW9uUgdzZXNzaW9u');

@$core.Deprecated('Use recordObservationRequestDescriptor instead')
const RecordObservationRequest$json = {
  '1': 'RecordObservationRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {
      '1': 'discipline',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Discipline',
      '10': 'discipline'
    },
    {
      '1': 'moment',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Moment',
      '10': 'moment'
    },
    {
      '1': 'action',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.HygieneAction',
      '10': 'action'
    },
    {'1': 'gloves_worn', '3': 5, '4': 1, '5': 8, '10': 'glovesWorn'},
    {
      '1': 'observed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
  ],
};

/// Descriptor for `RecordObservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordObservationRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRPYnNlcnZhdGlvblJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbk'
    'lkEkMKCmRpc2NpcGxpbmUYAiABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5EaXNjaXBs'
    'aW5lUgpkaXNjaXBsaW5lEjcKBm1vbWVudBgDIAEoDjIfLmhlYWx0aGNhcmUuaW5mZWN0aW9uLn'
    'YxLk1vbWVudFIGbW9tZW50Ej4KBmFjdGlvbhgEIAEoDjImLmhlYWx0aGNhcmUuaW5mZWN0aW9u'
    'LnYxLkh5Z2llbmVBY3Rpb25SBmFjdGlvbhIfCgtnbG92ZXNfd29ybhgFIAEoCFIKZ2xvdmVzV2'
    '9ybhI7CgtvYnNlcnZlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9i'
    'c2VydmVkQXQ=');

@$core.Deprecated('Use recordObservationResponseDescriptor instead')
const RecordObservationResponse$json = {
  '1': 'RecordObservationResponse',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.HygieneObservation',
      '10': 'observation'
    },
  ],
};

/// Descriptor for `RecordObservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordObservationResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRPYnNlcnZhdGlvblJlc3BvbnNlEk0KC29ic2VydmF0aW9uGAEgASgLMisuaGVhbH'
        'RoY2FyZS5pbmZlY3Rpb24udjEuSHlnaWVuZU9ic2VydmF0aW9uUgtvYnNlcnZhdGlvbg==');

@$core.Deprecated('Use endHygieneSessionRequestDescriptor instead')
const EndHygieneSessionRequest$json = {
  '1': 'EndHygieneSessionRequest',
  '2': [
    {'1': 'session_id', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    {'1': 'notes', '3': 2, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `EndHygieneSessionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endHygieneSessionRequestDescriptor =
    $convert.base64Decode(
        'ChhFbmRIeWdpZW5lU2Vzc2lvblJlcXVlc3QSHQoKc2Vzc2lvbl9pZBgBIAEoCVIJc2Vzc2lvbk'
        'lkEhQKBW5vdGVzGAIgASgJUgVub3Rlcw==');

@$core.Deprecated('Use endHygieneSessionResponseDescriptor instead')
const EndHygieneSessionResponse$json = {
  '1': 'EndHygieneSessionResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.HygieneSession',
      '10': 'session'
    },
  ],
};

/// Descriptor for `EndHygieneSessionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endHygieneSessionResponseDescriptor =
    $convert.base64Decode(
        'ChlFbmRIeWdpZW5lU2Vzc2lvblJlc3BvbnNlEkEKB3Nlc3Npb24YASABKAsyJy5oZWFsdGhjYX'
        'JlLmluZmVjdGlvbi52MS5IeWdpZW5lU2Vzc2lvblIHc2Vzc2lvbg==');

@$core.Deprecated('Use getHygieneComplianceRequestDescriptor instead')
const GetHygieneComplianceRequest$json = {
  '1': 'GetHygieneComplianceRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'group_by', '3': 2, '4': 1, '5': 9, '10': 'groupBy'},
    {
      '1': 'period_from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
  ],
};

/// Descriptor for `GetHygieneComplianceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHygieneComplianceRequestDescriptor = $convert.base64Decode(
    'ChtHZXRIeWdpZW5lQ29tcGxpYW5jZVJlcXVlc3QSHwoLbG9jYXRpb25faWQYASABKAlSCmxvY2'
    'F0aW9uSWQSGQoIZ3JvdXBfYnkYAiABKAlSB2dyb3VwQnkSOwoLcGVyaW9kX2Zyb20YAyABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpwZXJpb2RGcm9tEjcKCXBlcmlvZF90bxgEIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHBlcmlvZFRv');

@$core.Deprecated('Use getHygieneComplianceResponseDescriptor instead')
const GetHygieneComplianceResponse$json = {
  '1': 'GetHygieneComplianceResponse',
  '2': [
    {
      '1': 'groups',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.Compliance',
      '10': 'groups'
    },
    {'1': 'observations', '3': 2, '4': 1, '5': 5, '10': 'observations'},
    {
      '1': 'suppression_threshold',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'suppressionThreshold'
    },
    {'1': 'indicator_code', '3': 4, '4': 1, '5': 9, '10': 'indicatorCode'},
    {
      '1': 'indicator_revision',
      '3': 5,
      '4': 1,
      '5': 5,
      '10': 'indicatorRevision'
    },
  ],
};

/// Descriptor for `GetHygieneComplianceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHygieneComplianceResponseDescriptor = $convert.base64Decode(
    'ChxHZXRIeWdpZW5lQ29tcGxpYW5jZVJlc3BvbnNlEjsKBmdyb3VwcxgBIAMoCzIjLmhlYWx0aG'
    'NhcmUuaW5mZWN0aW9uLnYxLkNvbXBsaWFuY2VSBmdyb3VwcxIiCgxvYnNlcnZhdGlvbnMYAiAB'
    'KAVSDG9ic2VydmF0aW9ucxIzChVzdXBwcmVzc2lvbl90aHJlc2hvbGQYAyABKAVSFHN1cHByZX'
    'NzaW9uVGhyZXNob2xkEiUKDmluZGljYXRvcl9jb2RlGAQgASgJUg1pbmRpY2F0b3JDb2RlEi0K'
    'EmluZGljYXRvcl9yZXZpc2lvbhgFIAEoBVIRaW5kaWNhdG9yUmV2aXNpb24=');

@$core.Deprecated('Use reportExposureRequestDescriptor instead')
const ReportExposureRequest$json = {
  '1': 'ReportExposureRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'staff_id', '3': 2, '4': 1, '5': 9, '10': 'staffId'},
    {
      '1': 'discipline',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Discipline',
      '10': 'discipline'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 5, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'kind',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.ExposureKind',
      '10': 'kind'
    },
    {'1': 'device', '3': 7, '4': 1, '5': 9, '10': 'device'},
    {'1': 'circumstance', '3': 8, '4': 1, '5': 9, '10': 'circumstance'},
    {'1': 'deep_injury', '3': 9, '4': 1, '5': 8, '10': 'deepInjury'},
    {
      '1': 'source_patient_id',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'sourcePatientId'
    },
    {'1': 'source_known', '3': 11, '4': 1, '5': 8, '10': 'sourceKnown'},
    {'1': 'source_consented', '3': 12, '4': 1, '5': 8, '10': 'sourceConsented'},
    {
      '1': 'occurred_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `ReportExposureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportExposureRequestDescriptor = $convert.base64Decode(
    'ChVSZXBvcnRFeHBvc3VyZVJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USGQ'
    'oIc3RhZmZfaWQYAiABKAlSB3N0YWZmSWQSQwoKZGlzY2lwbGluZRgDIAEoDjIjLmhlYWx0aGNh'
    'cmUuaW5mZWN0aW9uLnYxLkRpc2NpcGxpbmVSCmRpc2NpcGxpbmUSHwoLZmFjaWxpdHlfaWQYBC'
    'ABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb25faWQYBSABKAlSCmxvY2F0aW9uSWQSOQoEa2lu'
    'ZBgGIAEoDjIlLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkV4cG9zdXJlS2luZFIEa2luZBIWCg'
    'ZkZXZpY2UYByABKAlSBmRldmljZRIiCgxjaXJjdW1zdGFuY2UYCCABKAlSDGNpcmN1bXN0YW5j'
    'ZRIfCgtkZWVwX2luanVyeRgJIAEoCFIKZGVlcEluanVyeRIqChFzb3VyY2VfcGF0aWVudF9pZB'
    'gKIAEoCVIPc291cmNlUGF0aWVudElkEiEKDHNvdXJjZV9rbm93bhgLIAEoCFILc291cmNlS25v'
    'd24SKQoQc291cmNlX2NvbnNlbnRlZBgMIAEoCFIPc291cmNlQ29uc2VudGVkEjsKC29jY3Vycm'
    'VkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdA==');

@$core.Deprecated('Use reportExposureResponseDescriptor instead')
const ReportExposureResponse$json = {
  '1': 'ReportExposureResponse',
  '2': [
    {
      '1': 'exposure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Exposure',
      '10': 'exposure'
    },
    {
      '1': 'tasks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.ExposureTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `ReportExposureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportExposureResponseDescriptor = $convert.base64Decode(
    'ChZSZXBvcnRFeHBvc3VyZVJlc3BvbnNlEj0KCGV4cG9zdXJlGAEgASgLMiEuaGVhbHRoY2FyZS'
    '5pbmZlY3Rpb24udjEuRXhwb3N1cmVSCGV4cG9zdXJlEjsKBXRhc2tzGAIgAygLMiUuaGVhbHRo'
    'Y2FyZS5pbmZlY3Rpb24udjEuRXhwb3N1cmVUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use getExposureRequestDescriptor instead')
const GetExposureRequest$json = {
  '1': 'GetExposureRequest',
  '2': [
    {'1': 'exposure_id', '3': 1, '4': 1, '5': 9, '10': 'exposureId'},
  ],
};

/// Descriptor for `GetExposureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExposureRequestDescriptor = $convert.base64Decode(
    'ChJHZXRFeHBvc3VyZVJlcXVlc3QSHwoLZXhwb3N1cmVfaWQYASABKAlSCmV4cG9zdXJlSWQ=');

@$core.Deprecated('Use getExposureResponseDescriptor instead')
const GetExposureResponse$json = {
  '1': 'GetExposureResponse',
  '2': [
    {
      '1': 'exposure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Exposure',
      '10': 'exposure'
    },
    {
      '1': 'tasks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.ExposureTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `GetExposureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getExposureResponseDescriptor = $convert.base64Decode(
    'ChNHZXRFeHBvc3VyZVJlc3BvbnNlEj0KCGV4cG9zdXJlGAEgASgLMiEuaGVhbHRoY2FyZS5pbm'
    'ZlY3Rpb24udjEuRXhwb3N1cmVSCGV4cG9zdXJlEjsKBXRhc2tzGAIgAygLMiUuaGVhbHRoY2Fy'
    'ZS5pbmZlY3Rpb24udjEuRXhwb3N1cmVUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use completeExposureTaskRequestDescriptor instead')
const CompleteExposureTaskRequest$json = {
  '1': 'CompleteExposureTaskRequest',
  '2': [
    {'1': 'exposure_id', '3': 1, '4': 1, '5': 9, '10': 'exposureId'},
    {'1': 'task_id', '3': 2, '4': 1, '5': 9, '10': 'taskId'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.TaskState',
      '10': 'state'
    },
    {'1': 'outcome', '3': 4, '4': 1, '5': 9, '10': 'outcome'},
  ],
};

/// Descriptor for `CompleteExposureTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeExposureTaskRequestDescriptor = $convert.base64Decode(
    'ChtDb21wbGV0ZUV4cG9zdXJlVGFza1JlcXVlc3QSHwoLZXhwb3N1cmVfaWQYASABKAlSCmV4cG'
    '9zdXJlSWQSFwoHdGFza19pZBgCIAEoCVIGdGFza0lkEjgKBXN0YXRlGAMgASgOMiIuaGVhbHRo'
    'Y2FyZS5pbmZlY3Rpb24udjEuVGFza1N0YXRlUgVzdGF0ZRIYCgdvdXRjb21lGAQgASgJUgdvdX'
    'Rjb21l');

@$core.Deprecated('Use completeExposureTaskResponseDescriptor instead')
const CompleteExposureTaskResponse$json = {
  '1': 'CompleteExposureTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.ExposureTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CompleteExposureTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeExposureTaskResponseDescriptor =
    $convert.base64Decode(
        'ChxDb21wbGV0ZUV4cG9zdXJlVGFza1Jlc3BvbnNlEjkKBHRhc2sYASABKAsyJS5oZWFsdGhjYX'
        'JlLmluZmVjdGlvbi52MS5FeHBvc3VyZVRhc2tSBHRhc2s=');

@$core.Deprecated('Use closeExposureRequestDescriptor instead')
const CloseExposureRequest$json = {
  '1': 'CloseExposureRequest',
  '2': [
    {'1': 'exposure_id', '3': 1, '4': 1, '5': 9, '10': 'exposureId'},
    {'1': 'outcome', '3': 2, '4': 1, '5': 9, '10': 'outcome'},
  ],
};

/// Descriptor for `CloseExposureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeExposureRequestDescriptor = $convert.base64Decode(
    'ChRDbG9zZUV4cG9zdXJlUmVxdWVzdBIfCgtleHBvc3VyZV9pZBgBIAEoCVIKZXhwb3N1cmVJZB'
    'IYCgdvdXRjb21lGAIgASgJUgdvdXRjb21l');

@$core.Deprecated('Use closeExposureResponseDescriptor instead')
const CloseExposureResponse$json = {
  '1': 'CloseExposureResponse',
  '2': [
    {
      '1': 'exposure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.Exposure',
      '10': 'exposure'
    },
  ],
};

/// Descriptor for `CloseExposureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeExposureResponseDescriptor = $convert.base64Decode(
    'ChVDbG9zZUV4cG9zdXJlUmVzcG9uc2USPQoIZXhwb3N1cmUYASABKAsyIS5oZWFsdGhjYXJlLm'
    'luZmVjdGlvbi52MS5FeHBvc3VyZVIIZXhwb3N1cmU=');

@$core.Deprecated('Use listExposuresRequestDescriptor instead')
const ListExposuresRequest$json = {
  '1': 'ListExposuresRequest',
  '2': [
    {'1': 'staff_id', '3': 1, '4': 1, '5': 9, '10': 'staffId'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
    {
      '1': 'occurred_from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredFrom'
    },
    {
      '1': 'occurred_to',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredTo'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 6, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListExposuresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExposuresRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RXhwb3N1cmVzUmVxdWVzdBIZCghzdGFmZl9pZBgBIAEoCVIHc3RhZmZJZBIbCglvcG'
    'VuX29ubHkYAiABKAhSCG9wZW5Pbmx5Ej8KDW9jY3VycmVkX2Zyb20YAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgxvY2N1cnJlZEZyb20SOwoLb2NjdXJyZWRfdG8YBCABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZFRvEhsKCXBhZ2Vfc2l6ZRgFIAEo'
    'BVIIcGFnZVNpemUSHwoLcGFnZV9vZmZzZXQYBiABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listExposuresResponseDescriptor instead')
const ListExposuresResponse$json = {
  '1': 'ListExposuresResponse',
  '2': [
    {
      '1': 'exposures',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.Exposure',
      '10': 'exposures'
    },
  ],
};

/// Descriptor for `ListExposuresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listExposuresResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RXhwb3N1cmVzUmVzcG9uc2USPwoJZXhwb3N1cmVzGAEgAygLMiEuaGVhbHRoY2FyZS'
    '5pbmZlY3Rpb24udjEuRXhwb3N1cmVSCWV4cG9zdXJlcw==');

@$core.Deprecated('Use sweepExposureTasksRequestDescriptor instead')
const SweepExposureTasksRequest$json = {
  '1': 'SweepExposureTasksRequest',
};

/// Descriptor for `SweepExposureTasksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepExposureTasksRequestDescriptor =
    $convert.base64Decode('ChlTd2VlcEV4cG9zdXJlVGFza3NSZXF1ZXN0');

@$core.Deprecated('Use sweepExposureTasksResponseDescriptor instead')
const SweepExposureTasksResponse$json = {
  '1': 'SweepExposureTasksResponse',
  '2': [
    {'1': 'escalated', '3': 1, '4': 1, '5': 5, '10': 'escalated'},
  ],
};

/// Descriptor for `SweepExposureTasksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepExposureTasksResponseDescriptor =
    $convert.base64Decode(
        'ChpTd2VlcEV4cG9zdXJlVGFza3NSZXNwb25zZRIcCgllc2NhbGF0ZWQYASABKAVSCWVzY2FsYX'
        'RlZA==');

@$core.Deprecated('Use draftStewardshipRuleRequestDescriptor instead')
const DraftStewardshipRuleRequest$json = {
  '1': 'DraftStewardshipRuleRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.TriggerKind',
      '10': 'kind'
    },
    {'1': 'agents', '3': 5, '4': 3, '5': 9, '10': 'agents'},
    {'1': 'all_agents', '3': 6, '4': 1, '5': 8, '10': 'allAgents'},
    {'1': 'day_threshold', '3': 7, '4': 1, '5': 5, '10': 'dayThreshold'},
    {'1': 'prompt', '3': 8, '4': 1, '5': 9, '10': 'prompt'},
  ],
};

/// Descriptor for `DraftStewardshipRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftStewardshipRuleRequestDescriptor = $convert.base64Decode(
    'ChtEcmFmdFN0ZXdhcmRzaGlwUnVsZVJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW'
    '1lGAIgASgJUgRuYW1lEhoKCHJldmlzaW9uGAMgASgFUghyZXZpc2lvbhI4CgRraW5kGAQgASgO'
    'MiQuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuVHJpZ2dlcktpbmRSBGtpbmQSFgoGYWdlbnRzGA'
    'UgAygJUgZhZ2VudHMSHQoKYWxsX2FnZW50cxgGIAEoCFIJYWxsQWdlbnRzEiMKDWRheV90aHJl'
    'c2hvbGQYByABKAVSDGRheVRocmVzaG9sZBIWCgZwcm9tcHQYCCABKAlSBnByb21wdA==');

@$core.Deprecated('Use draftStewardshipRuleResponseDescriptor instead')
const DraftStewardshipRuleResponse$json = {
  '1': 'DraftStewardshipRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `DraftStewardshipRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftStewardshipRuleResponseDescriptor =
    $convert.base64Decode(
        'ChxEcmFmdFN0ZXdhcmRzaGlwUnVsZVJlc3BvbnNlEjwKBHJ1bGUYASABKAsyKC5oZWFsdGhjYX'
        'JlLmluZmVjdGlvbi52MS5TdGV3YXJkc2hpcFJ1bGVSBHJ1bGU=');

@$core.Deprecated('Use approveStewardshipRuleRequestDescriptor instead')
const ApproveStewardshipRuleRequest$json = {
  '1': 'ApproveStewardshipRuleRequest',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
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

/// Descriptor for `ApproveStewardshipRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveStewardshipRuleRequestDescriptor =
    $convert.base64Decode(
        'Ch1BcHByb3ZlU3Rld2FyZHNoaXBSdWxlUmVxdWVzdBIXCgdydWxlX2lkGAEgASgJUgZydWxlSW'
        'QSQQoOZWZmZWN0aXZlX2Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1l'
        'ZmZlY3RpdmVGcm9t');

@$core.Deprecated('Use approveStewardshipRuleResponseDescriptor instead')
const ApproveStewardshipRuleResponse$json = {
  '1': 'ApproveStewardshipRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `ApproveStewardshipRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveStewardshipRuleResponseDescriptor =
    $convert.base64Decode(
        'Ch5BcHByb3ZlU3Rld2FyZHNoaXBSdWxlUmVzcG9uc2USPAoEcnVsZRgBIAEoCzIoLmhlYWx0aG'
        'NhcmUuaW5mZWN0aW9uLnYxLlN0ZXdhcmRzaGlwUnVsZVIEcnVsZQ==');

@$core.Deprecated('Use reviewEncounterRequestDescriptor instead')
const ReviewEncounterRequest$json = {
  '1': 'ReviewEncounterRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `ReviewEncounterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewEncounterRequestDescriptor =
    $convert.base64Decode(
        'ChZSZXZpZXdFbmNvdW50ZXJSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
        'VySWQ=');

@$core.Deprecated('Use reviewEncounterResponseDescriptor instead')
const ReviewEncounterResponse$json = {
  '1': 'ReviewEncounterResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipReview',
      '10': 'reviews'
    },
  ],
};

/// Descriptor for `ReviewEncounterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewEncounterResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXZpZXdFbmNvdW50ZXJSZXNwb25zZRJECgdyZXZpZXdzGAEgAygLMiouaGVhbHRoY2FyZS'
        '5pbmZlY3Rpb24udjEuU3Rld2FyZHNoaXBSZXZpZXdSB3Jldmlld3M=');

@$core.Deprecated('Use adviseReviewRequestDescriptor instead')
const AdviseReviewRequest$json = {
  '1': 'AdviseReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {
      '1': 'recommendation',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Recommendation',
      '10': 'recommendation'
    },
    {'1': 'advice', '3': 3, '4': 1, '5': 9, '10': 'advice'},
  ],
};

/// Descriptor for `AdviseReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adviseReviewRequestDescriptor = $convert.base64Decode(
    'ChNBZHZpc2VSZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SWQSTwoOcm'
    'Vjb21tZW5kYXRpb24YAiABKA4yJy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5SZWNvbW1lbmRh'
    'dGlvblIOcmVjb21tZW5kYXRpb24SFgoGYWR2aWNlGAMgASgJUgZhZHZpY2U=');

@$core.Deprecated('Use adviseReviewResponseDescriptor instead')
const AdviseReviewResponse$json = {
  '1': 'AdviseReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `AdviseReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adviseReviewResponseDescriptor = $convert.base64Decode(
    'ChRBZHZpc2VSZXZpZXdSZXNwb25zZRJCCgZyZXZpZXcYASABKAsyKi5oZWFsdGhjYXJlLmluZm'
    'VjdGlvbi52MS5TdGV3YXJkc2hpcFJldmlld1IGcmV2aWV3');

@$core.Deprecated('Use respondToReviewRequestDescriptor instead')
const RespondToReviewRequest$json = {
  '1': 'RespondToReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {
      '1': 'response',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.Response',
      '10': 'response'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RespondToReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToReviewRequestDescriptor = $convert.base64Decode(
    'ChZSZXNwb25kVG9SZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SWQSPQ'
    'oIcmVzcG9uc2UYAiABKA4yIS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5SZXNwb25zZVIIcmVz'
    'cG9uc2USFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use respondToReviewResponseDescriptor instead')
const RespondToReviewResponse$json = {
  '1': 'RespondToReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `RespondToReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToReviewResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXNwb25kVG9SZXZpZXdSZXNwb25zZRJCCgZyZXZpZXcYASABKAsyKi5oZWFsdGhjYXJlLm'
        'luZmVjdGlvbi52MS5TdGV3YXJkc2hpcFJldmlld1IGcmV2aWV3');

@$core.Deprecated('Use withdrawReviewRequestDescriptor instead')
const WithdrawReviewRequest$json = {
  '1': 'WithdrawReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WithdrawReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawReviewRequestDescriptor = $convert.base64Decode(
    'ChVXaXRoZHJhd1Jldmlld1JlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZBIWCg'
    'ZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use withdrawReviewResponseDescriptor instead')
const WithdrawReviewResponse$json = {
  '1': 'WithdrawReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `WithdrawReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawReviewResponseDescriptor =
    $convert.base64Decode(
        'ChZXaXRoZHJhd1Jldmlld1Jlc3BvbnNlEkIKBnJldmlldxgBIAEoCzIqLmhlYWx0aGNhcmUuaW'
        '5mZWN0aW9uLnYxLlN0ZXdhcmRzaGlwUmV2aWV3UgZyZXZpZXc=');

@$core.Deprecated('Use listReviewsRequestDescriptor instead')
const ListReviewsRequest$json = {
  '1': 'ListReviewsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.ReviewState',
      '10': 'state'
    },
    {'1': 'worklist_only', '3': 4, '4': 1, '5': 8, '10': 'worklistOnly'},
    {
      '1': 'raised_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedFrom'
    },
    {
      '1': 'raised_to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedTo'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 8, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReviewsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0UmV2aWV3c1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEiEKDG'
    'VuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSOgoFc3RhdGUYAyABKA4yJC5oZWFsdGhj'
    'YXJlLmluZmVjdGlvbi52MS5SZXZpZXdTdGF0ZVIFc3RhdGUSIwoNd29ya2xpc3Rfb25seRgEIA'
    'EoCFIMd29ya2xpc3RPbmx5EjsKC3JhaXNlZF9mcm9tGAUgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIKcmFpc2VkRnJvbRI3CglyYWlzZWRfdG8YBiABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUghyYWlzZWRUbxIbCglwYWdlX3NpemUYByABKAVSCHBhZ2VTaXplEh8K'
    'C3BhZ2Vfb2Zmc2V0GAggASgFUgpwYWdlT2Zmc2V0');

@$core.Deprecated('Use listReviewsResponseDescriptor instead')
const ListReviewsResponse$json = {
  '1': 'ListReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipReview',
      '10': 'reviews'
    },
  ],
};

/// Descriptor for `ListReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReviewsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0UmV2aWV3c1Jlc3BvbnNlEkQKB3Jldmlld3MYASADKAsyKi5oZWFsdGhjYXJlLmluZm'
    'VjdGlvbi52MS5TdGV3YXJkc2hpcFJldmlld1IHcmV2aWV3cw==');

@$core.Deprecated('Use getStewardshipIndicatorsRequestDescriptor instead')
const GetStewardshipIndicatorsRequest$json = {
  '1': 'GetStewardshipIndicatorsRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
  ],
};

/// Descriptor for `GetStewardshipIndicatorsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStewardshipIndicatorsRequestDescriptor =
    $convert.base64Decode(
        'Ch9HZXRTdGV3YXJkc2hpcEluZGljYXRvcnNSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUg'
        'psb2NhdGlvbklkEjsKC3BlcmlvZF9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
        'dGFtcFIKcGVyaW9kRnJvbRI3CglwZXJpb2RfdG8YAyABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
        'ltZXN0YW1wUghwZXJpb2RUbw==');

@$core.Deprecated('Use getStewardshipIndicatorsResponseDescriptor instead')
const GetStewardshipIndicatorsResponse$json = {
  '1': 'GetStewardshipIndicatorsResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.StewardshipSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `GetStewardshipIndicatorsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStewardshipIndicatorsResponseDescriptor =
    $convert.base64Decode(
        'CiBHZXRTdGV3YXJkc2hpcEluZGljYXRvcnNSZXNwb25zZRJFCgdzdW1tYXJ5GAEgASgLMisuaG'
        'VhbHRoY2FyZS5pbmZlY3Rpb24udjEuU3Rld2FyZHNoaXBTdW1tYXJ5UgdzdW1tYXJ5');

@$core.Deprecated('Use draftLimitRequestDescriptor instead')
const DraftLimitRequest$json = {
  '1': 'DraftLimitRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'sample_kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'action_level', '3': 6, '4': 1, '5': 3, '10': 'actionLevel'},
    {'1': 'fail_level', '3': 7, '4': 1, '5': 3, '10': 'failLevel'},
    {'1': 'detection_fails', '3': 8, '4': 1, '5': 8, '10': 'detectionFails'},
    {'1': 'below_is_failure', '3': 9, '4': 1, '5': 8, '10': 'belowIsFailure'},
  ],
};

/// Descriptor for `DraftLimitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftLimitRequestDescriptor = $convert.base64Decode(
    'ChFEcmFmdExpbWl0UmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAiABKAlSBG'
    '5hbWUSGgoIcmV2aXNpb24YAyABKAVSCHJldmlzaW9uEkQKC3NhbXBsZV9raW5kGAQgASgOMiMu'
    'aGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuU2FtcGxlS2luZFIKc2FtcGxlS2luZBISCgR1bml0GA'
    'UgASgJUgR1bml0EiEKDGFjdGlvbl9sZXZlbBgGIAEoA1ILYWN0aW9uTGV2ZWwSHQoKZmFpbF9s'
    'ZXZlbBgHIAEoA1IJZmFpbExldmVsEicKD2RldGVjdGlvbl9mYWlscxgIIAEoCFIOZGV0ZWN0aW'
    '9uRmFpbHMSKAoQYmVsb3dfaXNfZmFpbHVyZRgJIAEoCFIOYmVsb3dJc0ZhaWx1cmU=');

@$core.Deprecated('Use draftLimitResponseDescriptor instead')
const DraftLimitResponse$json = {
  '1': 'DraftLimitResponse',
  '2': [
    {
      '1': 'limit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalLimit',
      '10': 'limit'
    },
  ],
};

/// Descriptor for `DraftLimitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftLimitResponseDescriptor = $convert.base64Decode(
    'ChJEcmFmdExpbWl0UmVzcG9uc2USQQoFbGltaXQYASABKAsyKy5oZWFsdGhjYXJlLmluZmVjdG'
    'lvbi52MS5FbnZpcm9ubWVudGFsTGltaXRSBWxpbWl0');

@$core.Deprecated('Use approveLimitRequestDescriptor instead')
const ApproveLimitRequest$json = {
  '1': 'ApproveLimitRequest',
  '2': [
    {'1': 'limit_id', '3': 1, '4': 1, '5': 9, '10': 'limitId'},
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

/// Descriptor for `ApproveLimitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLimitRequestDescriptor = $convert.base64Decode(
    'ChNBcHByb3ZlTGltaXRSZXF1ZXN0EhkKCGxpbWl0X2lkGAEgASgJUgdsaW1pdElkEkEKDmVmZm'
    'VjdGl2ZV9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZl'
    'RnJvbQ==');

@$core.Deprecated('Use approveLimitResponseDescriptor instead')
const ApproveLimitResponse$json = {
  '1': 'ApproveLimitResponse',
  '2': [
    {
      '1': 'limit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalLimit',
      '10': 'limit'
    },
  ],
};

/// Descriptor for `ApproveLimitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLimitResponseDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlTGltaXRSZXNwb25zZRJBCgVsaW1pdBgBIAEoCzIrLmhlYWx0aGNhcmUuaW5mZW'
    'N0aW9uLnYxLkVudmlyb25tZW50YWxMaW1pdFIFbGltaXQ=');

@$core.Deprecated('Use addSamplingPlanRequestDescriptor instead')
const AddSamplingPlanRequest$json = {
  '1': 'AddSamplingPlanRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'sample_kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'sample_point', '3': 5, '4': 1, '5': 9, '10': 'samplePoint'},
    {'1': 'every_days', '3': 6, '4': 1, '5': 5, '10': 'everyDays'},
    {
      '1': 'started_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `AddSamplingPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addSamplingPlanRequestDescriptor = $convert.base64Decode(
    'ChZBZGRTYW1wbGluZ1BsYW5SZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSRAoLc2FtcGxlX2'
    'tpbmQYAiABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5TYW1wbGVLaW5kUgpzYW1wbGVL'
    'aW5kEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpmYWNpbGl0eUlkEh8KC2xvY2F0aW9uX2lkGAQgAS'
    'gJUgpsb2NhdGlvbklkEiEKDHNhbXBsZV9wb2ludBgFIAEoCVILc2FtcGxlUG9pbnQSHQoKZXZl'
    'cnlfZGF5cxgGIAEoBVIJZXZlcnlEYXlzEjkKCnN0YXJ0ZWRfYXQYByABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUglzdGFydGVkQXQ=');

@$core.Deprecated('Use addSamplingPlanResponseDescriptor instead')
const AddSamplingPlanResponse$json = {
  '1': 'AddSamplingPlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.SamplingPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `AddSamplingPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addSamplingPlanResponseDescriptor =
    $convert.base64Decode(
        'ChdBZGRTYW1wbGluZ1BsYW5SZXNwb25zZRI5CgRwbGFuGAEgASgLMiUuaGVhbHRoY2FyZS5pbm'
        'ZlY3Rpb24udjEuU2FtcGxpbmdQbGFuUgRwbGFu');

@$core.Deprecated('Use collectSampleRequestDescriptor instead')
const CollectSampleRequest$json = {
  '1': 'CollectSampleRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'sample_kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'location_id', '3': 4, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'sample_point', '3': 5, '4': 1, '5': 9, '10': 'samplePoint'},
    {'1': 'plan_id', '3': 6, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'outbreak_id', '3': 7, '4': 1, '5': 9, '10': 'outbreakId'},
    {'1': 'repeat_of_id', '3': 8, '4': 1, '5': 9, '10': 'repeatOfId'},
    {
      '1': 'collected_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedAt'
    },
    {'1': 'method', '3': 10, '4': 1, '5': 9, '10': 'method'},
  ],
};

/// Descriptor for `CollectSampleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectSampleRequestDescriptor = $convert.base64Decode(
    'ChRDb2xsZWN0U2FtcGxlUmVxdWVzdBIcCglyZWZlcmVuY2UYASABKAlSCXJlZmVyZW5jZRJECg'
    'tzYW1wbGVfa2luZBgCIAEoDjIjLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlNhbXBsZUtpbmRS'
    'CnNhbXBsZUtpbmQSHwoLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSHwoLbG9jYXRpb2'
    '5faWQYBCABKAlSCmxvY2F0aW9uSWQSIQoMc2FtcGxlX3BvaW50GAUgASgJUgtzYW1wbGVQb2lu'
    'dBIXCgdwbGFuX2lkGAYgASgJUgZwbGFuSWQSHwoLb3V0YnJlYWtfaWQYByABKAlSCm91dGJyZW'
    'FrSWQSIAoMcmVwZWF0X29mX2lkGAggASgJUgpyZXBlYXRPZklkEj0KDGNvbGxlY3RlZF9hdBgJ'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2NvbGxlY3RlZEF0EhYKBm1ldGhvZB'
    'gKIAEoCVIGbWV0aG9k');

@$core.Deprecated('Use collectSampleResponseDescriptor instead')
const CollectSampleResponse$json = {
  '1': 'CollectSampleResponse',
  '2': [
    {
      '1': 'sample',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalSample',
      '10': 'sample'
    },
  ],
};

/// Descriptor for `CollectSampleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List collectSampleResponseDescriptor = $convert.base64Decode(
    'ChVDb2xsZWN0U2FtcGxlUmVzcG9uc2USRAoGc2FtcGxlGAEgASgLMiwuaGVhbHRoY2FyZS5pbm'
    'ZlY3Rpb24udjEuRW52aXJvbm1lbnRhbFNhbXBsZVIGc2FtcGxl');

@$core.Deprecated('Use recordSampleResultRequestDescriptor instead')
const RecordSampleResultRequest$json = {
  '1': 'RecordSampleResultRequest',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'lab_reference', '3': 2, '4': 1, '5': 9, '10': 'labReference'},
    {'1': 'value', '3': 3, '4': 1, '5': 3, '10': 'value'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'organism', '3': 5, '4': 1, '5': 9, '10': 'organism'},
    {'1': 'detected', '3': 6, '4': 1, '5': 8, '10': 'detected'},
    {
      '1': 'resulted_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resultedAt'
    },
  ],
};

/// Descriptor for `RecordSampleResultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordSampleResultRequestDescriptor = $convert.base64Decode(
    'ChlSZWNvcmRTYW1wbGVSZXN1bHRSZXF1ZXN0EhsKCXNhbXBsZV9pZBgBIAEoCVIIc2FtcGxlSW'
    'QSIwoNbGFiX3JlZmVyZW5jZRgCIAEoCVIMbGFiUmVmZXJlbmNlEhQKBXZhbHVlGAMgASgDUgV2'
    'YWx1ZRISCgR1bml0GAQgASgJUgR1bml0EhoKCG9yZ2FuaXNtGAUgASgJUghvcmdhbmlzbRIaCg'
    'hkZXRlY3RlZBgGIAEoCFIIZGV0ZWN0ZWQSOwoLcmVzdWx0ZWRfYXQYByABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgpyZXN1bHRlZEF0');

@$core.Deprecated('Use recordSampleResultResponseDescriptor instead')
const RecordSampleResultResponse$json = {
  '1': 'RecordSampleResultResponse',
  '2': [
    {
      '1': 'sample',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalSample',
      '10': 'sample'
    },
  ],
};

/// Descriptor for `RecordSampleResultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordSampleResultResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWNvcmRTYW1wbGVSZXN1bHRSZXNwb25zZRJECgZzYW1wbGUYASABKAsyLC5oZWFsdGhjYX'
        'JlLmluZmVjdGlvbi52MS5FbnZpcm9ubWVudGFsU2FtcGxlUgZzYW1wbGU=');

@$core.Deprecated('Use raiseCorrectiveActionRequestDescriptor instead')
const RaiseCorrectiveActionRequest$json = {
  '1': 'RaiseCorrectiveActionRequest',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
    {'1': 'owner', '3': 3, '4': 1, '5': 9, '10': 'owner'},
    {
      '1': 'due_by',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
  ],
};

/// Descriptor for `RaiseCorrectiveActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCorrectiveActionRequestDescriptor =
    $convert.base64Decode(
        'ChxSYWlzZUNvcnJlY3RpdmVBY3Rpb25SZXF1ZXN0EhsKCXNhbXBsZV9pZBgBIAEoCVIIc2FtcG'
        'xlSWQSFgoGYWN0aW9uGAIgASgJUgZhY3Rpb24SFAoFb3duZXIYAyABKAlSBW93bmVyEjEKBmR1'
        'ZV9ieRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5');

@$core.Deprecated('Use raiseCorrectiveActionResponseDescriptor instead')
const RaiseCorrectiveActionResponse$json = {
  '1': 'RaiseCorrectiveActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `RaiseCorrectiveActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCorrectiveActionResponseDescriptor =
    $convert.base64Decode(
        'Ch1SYWlzZUNvcnJlY3RpdmVBY3Rpb25SZXNwb25zZRJBCgZhY3Rpb24YASABKAsyKS5oZWFsdG'
        'hjYXJlLmluZmVjdGlvbi52MS5Db3JyZWN0aXZlQWN0aW9uUgZhY3Rpb24=');

@$core.Deprecated('Use completeCorrectiveActionRequestDescriptor instead')
const CompleteCorrectiveActionRequest$json = {
  '1': 'CompleteCorrectiveActionRequest',
  '2': [
    {'1': 'action_id', '3': 1, '4': 1, '5': 9, '10': 'actionId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CompleteCorrectiveActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeCorrectiveActionRequestDescriptor =
    $convert.base64Decode(
        'Ch9Db21wbGV0ZUNvcnJlY3RpdmVBY3Rpb25SZXF1ZXN0EhsKCWFjdGlvbl9pZBgBIAEoCVIIYW'
        'N0aW9uSWQSEgoEbm90ZRgCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use completeCorrectiveActionResponseDescriptor instead')
const CompleteCorrectiveActionResponse$json = {
  '1': 'CompleteCorrectiveActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `CompleteCorrectiveActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeCorrectiveActionResponseDescriptor =
    $convert.base64Decode(
        'CiBDb21wbGV0ZUNvcnJlY3RpdmVBY3Rpb25SZXNwb25zZRJBCgZhY3Rpb24YASABKAsyKS5oZW'
        'FsdGhjYXJlLmluZmVjdGlvbi52MS5Db3JyZWN0aXZlQWN0aW9uUgZhY3Rpb24=');

@$core.Deprecated('Use verifyCorrectiveActionRequestDescriptor instead')
const VerifyCorrectiveActionRequest$json = {
  '1': 'VerifyCorrectiveActionRequest',
  '2': [
    {'1': 'action_id', '3': 1, '4': 1, '5': 9, '10': 'actionId'},
    {'1': 'repeat_sample_id', '3': 2, '4': 1, '5': 9, '10': 'repeatSampleId'},
  ],
};

/// Descriptor for `VerifyCorrectiveActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCorrectiveActionRequestDescriptor =
    $convert.base64Decode(
        'Ch1WZXJpZnlDb3JyZWN0aXZlQWN0aW9uUmVxdWVzdBIbCglhY3Rpb25faWQYASABKAlSCGFjdG'
        'lvbklkEigKEHJlcGVhdF9zYW1wbGVfaWQYAiABKAlSDnJlcGVhdFNhbXBsZUlk');

@$core.Deprecated('Use verifyCorrectiveActionResponseDescriptor instead')
const VerifyCorrectiveActionResponse$json = {
  '1': 'VerifyCorrectiveActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `VerifyCorrectiveActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyCorrectiveActionResponseDescriptor =
    $convert.base64Decode(
        'Ch5WZXJpZnlDb3JyZWN0aXZlQWN0aW9uUmVzcG9uc2USQQoGYWN0aW9uGAEgASgLMikuaGVhbH'
        'RoY2FyZS5pbmZlY3Rpb24udjEuQ29ycmVjdGl2ZUFjdGlvblIGYWN0aW9u');

@$core.Deprecated('Use closeSampleRequestDescriptor instead')
const CloseSampleRequest$json = {
  '1': 'CloseSampleRequest',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
  ],
};

/// Descriptor for `CloseSampleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeSampleRequestDescriptor =
    $convert.base64Decode(
        'ChJDbG9zZVNhbXBsZVJlcXVlc3QSGwoJc2FtcGxlX2lkGAEgASgJUghzYW1wbGVJZA==');

@$core.Deprecated('Use closeSampleResponseDescriptor instead')
const CloseSampleResponse$json = {
  '1': 'CloseSampleResponse',
  '2': [
    {
      '1': 'sample',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalSample',
      '10': 'sample'
    },
  ],
};

/// Descriptor for `CloseSampleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeSampleResponseDescriptor = $convert.base64Decode(
    'ChNDbG9zZVNhbXBsZVJlc3BvbnNlEkQKBnNhbXBsZRgBIAEoCzIsLmhlYWx0aGNhcmUuaW5mZW'
    'N0aW9uLnYxLkVudmlyb25tZW50YWxTYW1wbGVSBnNhbXBsZQ==');

@$core.Deprecated('Use listDueSamplingRequestDescriptor instead')
const ListDueSamplingRequest$json = {
  '1': 'ListDueSamplingRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
  ],
};

/// Descriptor for `ListDueSamplingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueSamplingRequestDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RHVlU2FtcGxpbmdSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdGlvbk'
        'lk');

@$core.Deprecated('Use listDueSamplingResponseDescriptor instead')
const ListDueSamplingResponse$json = {
  '1': 'ListDueSamplingResponse',
  '2': [
    {
      '1': 'points',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.DuePoint',
      '10': 'points'
    },
  ],
};

/// Descriptor for `ListDueSamplingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueSamplingResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0RHVlU2FtcGxpbmdSZXNwb25zZRI5CgZwb2ludHMYASADKAsyIS5oZWFsdGhjYXJlLm'
        'luZmVjdGlvbi52MS5EdWVQb2ludFIGcG9pbnRz');

@$core.Deprecated('Use listSamplesRequestDescriptor instead')
const ListSamplesRequest$json = {
  '1': 'ListSamplesRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'sample_kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.infection.v1.SampleKind',
      '10': 'sampleKind'
    },
    {'1': 'failing_only', '3': 3, '4': 1, '5': 8, '10': 'failingOnly'},
    {
      '1': 'collected_from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedFrom'
    },
    {
      '1': 'collected_to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'collectedTo'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 7, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListSamplesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSamplesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0U2FtcGxlc1JlcXVlc3QSHwoLbG9jYXRpb25faWQYASABKAlSCmxvY2F0aW9uSWQSRA'
    'oLc2FtcGxlX2tpbmQYAiABKA4yIy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5TYW1wbGVLaW5k'
    'UgpzYW1wbGVLaW5kEiEKDGZhaWxpbmdfb25seRgDIAEoCFILZmFpbGluZ09ubHkSQQoOY29sbG'
    'VjdGVkX2Zyb20YBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1jb2xsZWN0ZWRG'
    'cm9tEj0KDGNvbGxlY3RlZF90bxgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2'
    'NvbGxlY3RlZFRvEhsKCXBhZ2Vfc2l6ZRgGIAEoBVIIcGFnZVNpemUSHwoLcGFnZV9vZmZzZXQY'
    'ByABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listSamplesResponseDescriptor instead')
const ListSamplesResponse$json = {
  '1': 'ListSamplesResponse',
  '2': [
    {
      '1': 'samples',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentalSample',
      '10': 'samples'
    },
  ],
};

/// Descriptor for `ListSamplesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSamplesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0U2FtcGxlc1Jlc3BvbnNlEkYKB3NhbXBsZXMYASADKAsyLC5oZWFsdGhjYXJlLmluZm'
    'VjdGlvbi52MS5FbnZpcm9ubWVudGFsU2FtcGxlUgdzYW1wbGVz');

@$core.Deprecated('Use listCorrectiveActionsRequestDescriptor instead')
const ListCorrectiveActionsRequest$json = {
  '1': 'ListCorrectiveActionsRequest',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
  ],
};

/// Descriptor for `ListCorrectiveActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCorrectiveActionsRequestDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q29ycmVjdGl2ZUFjdGlvbnNSZXF1ZXN0EhsKCXNhbXBsZV9pZBgBIAEoCVIIc2FtcG'
        'xlSWQSGwoJb3Blbl9vbmx5GAIgASgIUghvcGVuT25seQ==');

@$core.Deprecated('Use listCorrectiveActionsResponseDescriptor instead')
const ListCorrectiveActionsResponse$json = {
  '1': 'ListCorrectiveActionsResponse',
  '2': [
    {
      '1': 'actions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.infection.v1.CorrectiveAction',
      '10': 'actions'
    },
  ],
};

/// Descriptor for `ListCorrectiveActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCorrectiveActionsResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29ycmVjdGl2ZUFjdGlvbnNSZXNwb25zZRJDCgdhY3Rpb25zGAEgAygLMikuaGVhbH'
        'RoY2FyZS5pbmZlY3Rpb24udjEuQ29ycmVjdGl2ZUFjdGlvblIHYWN0aW9ucw==');

@$core.Deprecated('Use getEnvironmentSummaryRequestDescriptor instead')
const GetEnvironmentSummaryRequest$json = {
  '1': 'GetEnvironmentSummaryRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {
      '1': 'period_from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
  ],
};

/// Descriptor for `GetEnvironmentSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEnvironmentSummaryRequestDescriptor = $convert.base64Decode(
    'ChxHZXRFbnZpcm9ubWVudFN1bW1hcnlSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2'
    'NhdGlvbklkEjsKC3BlcmlvZF9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIKcGVyaW9kRnJvbRI3CglwZXJpb2RfdG8YAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUghwZXJpb2RUbw==');

@$core.Deprecated('Use getEnvironmentSummaryResponseDescriptor instead')
const GetEnvironmentSummaryResponse$json = {
  '1': 'GetEnvironmentSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.infection.v1.EnvironmentSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `GetEnvironmentSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEnvironmentSummaryResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRFbnZpcm9ubWVudFN1bW1hcnlSZXNwb25zZRJFCgdzdW1tYXJ5GAEgASgLMisuaGVhbH'
        'RoY2FyZS5pbmZlY3Rpb24udjEuRW52aXJvbm1lbnRTdW1tYXJ5UgdzdW1tYXJ5');

const $core.Map<$core.String, $core.dynamic> InfectionServiceBase$json = {
  '1': 'InfectionService',
  '2': [
    {
      '1': 'OpenCase',
      '2': '.healthcare.infection.v1.OpenCaseRequest',
      '3': '.healthcare.infection.v1.OpenCaseResponse'
    },
    {
      '1': 'ReviewCase',
      '2': '.healthcare.infection.v1.ReviewCaseRequest',
      '3': '.healthcare.infection.v1.ReviewCaseResponse'
    },
    {
      '1': 'OverrideOnset',
      '2': '.healthcare.infection.v1.OverrideOnsetRequest',
      '3': '.healthcare.infection.v1.OverrideOnsetResponse'
    },
    {
      '1': 'ListCases',
      '2': '.healthcare.infection.v1.ListCasesRequest',
      '3': '.healthcare.infection.v1.ListCasesResponse'
    },
    {
      '1': 'RecordDeviceDays',
      '2': '.healthcare.infection.v1.RecordDeviceDaysRequest',
      '3': '.healthcare.infection.v1.RecordDeviceDaysResponse'
    },
    {
      '1': 'GetRate',
      '2': '.healthcare.infection.v1.GetRateRequest',
      '3': '.healthcare.infection.v1.GetRateResponse'
    },
    {
      '1': 'StartIsolation',
      '2': '.healthcare.infection.v1.StartIsolationRequest',
      '3': '.healthcare.infection.v1.StartIsolationResponse'
    },
    {
      '1': 'ExtendIsolation',
      '2': '.healthcare.infection.v1.ExtendIsolationRequest',
      '3': '.healthcare.infection.v1.ExtendIsolationResponse'
    },
    {
      '1': 'EndIsolation',
      '2': '.healthcare.infection.v1.EndIsolationRequest',
      '3': '.healthcare.infection.v1.EndIsolationResponse'
    },
    {
      '1': 'GetBoard',
      '2': '.healthcare.infection.v1.GetBoardRequest',
      '3': '.healthcare.infection.v1.GetBoardResponse'
    },
    {
      '1': 'DraftAlertRule',
      '2': '.healthcare.infection.v1.DraftAlertRuleRequest',
      '3': '.healthcare.infection.v1.DraftAlertRuleResponse'
    },
    {
      '1': 'ApproveAlertRule',
      '2': '.healthcare.infection.v1.ApproveAlertRuleRequest',
      '3': '.healthcare.infection.v1.ApproveAlertRuleResponse'
    },
    {
      '1': 'ScreenEncounter',
      '2': '.healthcare.infection.v1.ScreenEncounterRequest',
      '3': '.healthcare.infection.v1.ScreenEncounterResponse'
    },
    {
      '1': 'AcknowledgeAlert',
      '2': '.healthcare.infection.v1.AcknowledgeAlertRequest',
      '3': '.healthcare.infection.v1.AcknowledgeAlertResponse'
    },
    {
      '1': 'OverrideAlert',
      '2': '.healthcare.infection.v1.OverrideAlertRequest',
      '3': '.healthcare.infection.v1.OverrideAlertResponse'
    },
    {
      '1': 'ListAlerts',
      '2': '.healthcare.infection.v1.ListAlertsRequest',
      '3': '.healthcare.infection.v1.ListAlertsResponse'
    },
    {
      '1': 'OpenOutbreak',
      '2': '.healthcare.infection.v1.OpenOutbreakRequest',
      '3': '.healthcare.infection.v1.OpenOutbreakResponse'
    },
    {
      '1': 'AdvanceOutbreak',
      '2': '.healthcare.infection.v1.AdvanceOutbreakRequest',
      '3': '.healthcare.infection.v1.AdvanceOutbreakResponse'
    },
    {
      '1': 'CloseOutbreak',
      '2': '.healthcare.infection.v1.CloseOutbreakRequest',
      '3': '.healthcare.infection.v1.CloseOutbreakResponse'
    },
    {
      '1': 'AddOutbreakMember',
      '2': '.healthcare.infection.v1.AddOutbreakMemberRequest',
      '3': '.healthcare.infection.v1.AddOutbreakMemberResponse'
    },
    {
      '1': 'GetCluster',
      '2': '.healthcare.infection.v1.GetClusterRequest',
      '3': '.healthcare.infection.v1.GetClusterResponse'
    },
    {
      '1': 'ListOutbreaks',
      '2': '.healthcare.infection.v1.ListOutbreaksRequest',
      '3': '.healthcare.infection.v1.ListOutbreaksResponse'
    },
    {
      '1': 'StartHygieneSession',
      '2': '.healthcare.infection.v1.StartHygieneSessionRequest',
      '3': '.healthcare.infection.v1.StartHygieneSessionResponse'
    },
    {
      '1': 'RecordObservation',
      '2': '.healthcare.infection.v1.RecordObservationRequest',
      '3': '.healthcare.infection.v1.RecordObservationResponse'
    },
    {
      '1': 'EndHygieneSession',
      '2': '.healthcare.infection.v1.EndHygieneSessionRequest',
      '3': '.healthcare.infection.v1.EndHygieneSessionResponse'
    },
    {
      '1': 'GetHygieneCompliance',
      '2': '.healthcare.infection.v1.GetHygieneComplianceRequest',
      '3': '.healthcare.infection.v1.GetHygieneComplianceResponse'
    },
    {
      '1': 'ReportExposure',
      '2': '.healthcare.infection.v1.ReportExposureRequest',
      '3': '.healthcare.infection.v1.ReportExposureResponse'
    },
    {
      '1': 'GetExposure',
      '2': '.healthcare.infection.v1.GetExposureRequest',
      '3': '.healthcare.infection.v1.GetExposureResponse'
    },
    {
      '1': 'CompleteExposureTask',
      '2': '.healthcare.infection.v1.CompleteExposureTaskRequest',
      '3': '.healthcare.infection.v1.CompleteExposureTaskResponse'
    },
    {
      '1': 'CloseExposure',
      '2': '.healthcare.infection.v1.CloseExposureRequest',
      '3': '.healthcare.infection.v1.CloseExposureResponse'
    },
    {
      '1': 'ListExposures',
      '2': '.healthcare.infection.v1.ListExposuresRequest',
      '3': '.healthcare.infection.v1.ListExposuresResponse'
    },
    {
      '1': 'SweepExposureTasks',
      '2': '.healthcare.infection.v1.SweepExposureTasksRequest',
      '3': '.healthcare.infection.v1.SweepExposureTasksResponse'
    },
    {
      '1': 'DraftStewardshipRule',
      '2': '.healthcare.infection.v1.DraftStewardshipRuleRequest',
      '3': '.healthcare.infection.v1.DraftStewardshipRuleResponse'
    },
    {
      '1': 'ApproveStewardshipRule',
      '2': '.healthcare.infection.v1.ApproveStewardshipRuleRequest',
      '3': '.healthcare.infection.v1.ApproveStewardshipRuleResponse'
    },
    {
      '1': 'ReviewEncounter',
      '2': '.healthcare.infection.v1.ReviewEncounterRequest',
      '3': '.healthcare.infection.v1.ReviewEncounterResponse'
    },
    {
      '1': 'AdviseReview',
      '2': '.healthcare.infection.v1.AdviseReviewRequest',
      '3': '.healthcare.infection.v1.AdviseReviewResponse'
    },
    {
      '1': 'RespondToReview',
      '2': '.healthcare.infection.v1.RespondToReviewRequest',
      '3': '.healthcare.infection.v1.RespondToReviewResponse'
    },
    {
      '1': 'WithdrawReview',
      '2': '.healthcare.infection.v1.WithdrawReviewRequest',
      '3': '.healthcare.infection.v1.WithdrawReviewResponse'
    },
    {
      '1': 'ListReviews',
      '2': '.healthcare.infection.v1.ListReviewsRequest',
      '3': '.healthcare.infection.v1.ListReviewsResponse'
    },
    {
      '1': 'GetStewardshipIndicators',
      '2': '.healthcare.infection.v1.GetStewardshipIndicatorsRequest',
      '3': '.healthcare.infection.v1.GetStewardshipIndicatorsResponse'
    },
    {
      '1': 'DraftLimit',
      '2': '.healthcare.infection.v1.DraftLimitRequest',
      '3': '.healthcare.infection.v1.DraftLimitResponse'
    },
    {
      '1': 'ApproveLimit',
      '2': '.healthcare.infection.v1.ApproveLimitRequest',
      '3': '.healthcare.infection.v1.ApproveLimitResponse'
    },
    {
      '1': 'AddSamplingPlan',
      '2': '.healthcare.infection.v1.AddSamplingPlanRequest',
      '3': '.healthcare.infection.v1.AddSamplingPlanResponse'
    },
    {
      '1': 'CollectSample',
      '2': '.healthcare.infection.v1.CollectSampleRequest',
      '3': '.healthcare.infection.v1.CollectSampleResponse'
    },
    {
      '1': 'RecordSampleResult',
      '2': '.healthcare.infection.v1.RecordSampleResultRequest',
      '3': '.healthcare.infection.v1.RecordSampleResultResponse'
    },
    {
      '1': 'RaiseCorrectiveAction',
      '2': '.healthcare.infection.v1.RaiseCorrectiveActionRequest',
      '3': '.healthcare.infection.v1.RaiseCorrectiveActionResponse'
    },
    {
      '1': 'CompleteCorrectiveAction',
      '2': '.healthcare.infection.v1.CompleteCorrectiveActionRequest',
      '3': '.healthcare.infection.v1.CompleteCorrectiveActionResponse'
    },
    {
      '1': 'VerifyCorrectiveAction',
      '2': '.healthcare.infection.v1.VerifyCorrectiveActionRequest',
      '3': '.healthcare.infection.v1.VerifyCorrectiveActionResponse'
    },
    {
      '1': 'CloseSample',
      '2': '.healthcare.infection.v1.CloseSampleRequest',
      '3': '.healthcare.infection.v1.CloseSampleResponse'
    },
    {
      '1': 'ListDueSampling',
      '2': '.healthcare.infection.v1.ListDueSamplingRequest',
      '3': '.healthcare.infection.v1.ListDueSamplingResponse'
    },
    {
      '1': 'ListSamples',
      '2': '.healthcare.infection.v1.ListSamplesRequest',
      '3': '.healthcare.infection.v1.ListSamplesResponse'
    },
    {
      '1': 'ListCorrectiveActions',
      '2': '.healthcare.infection.v1.ListCorrectiveActionsRequest',
      '3': '.healthcare.infection.v1.ListCorrectiveActionsResponse'
    },
    {
      '1': 'GetEnvironmentSummary',
      '2': '.healthcare.infection.v1.GetEnvironmentSummaryRequest',
      '3': '.healthcare.infection.v1.GetEnvironmentSummaryResponse'
    },
  ],
};

@$core.Deprecated('Use infectionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    InfectionServiceBase$messageJson = {
  '.healthcare.infection.v1.OpenCaseRequest': OpenCaseRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.infection.v1.OpenCaseResponse': OpenCaseResponse$json,
  '.healthcare.infection.v1.SurveillanceCase': SurveillanceCase$json,
  '.healthcare.infection.v1.ReviewCaseRequest': ReviewCaseRequest$json,
  '.healthcare.infection.v1.ReviewCaseResponse': ReviewCaseResponse$json,
  '.healthcare.infection.v1.OverrideOnsetRequest': OverrideOnsetRequest$json,
  '.healthcare.infection.v1.OverrideOnsetResponse': OverrideOnsetResponse$json,
  '.healthcare.infection.v1.ListCasesRequest': ListCasesRequest$json,
  '.healthcare.infection.v1.ListCasesResponse': ListCasesResponse$json,
  '.healthcare.infection.v1.RecordDeviceDaysRequest':
      RecordDeviceDaysRequest$json,
  '.healthcare.infection.v1.RecordDeviceDaysResponse':
      RecordDeviceDaysResponse$json,
  '.healthcare.infection.v1.DeviceDayCount': DeviceDayCount$json,
  '.healthcare.infection.v1.GetRateRequest': GetRateRequest$json,
  '.healthcare.infection.v1.GetRateResponse': GetRateResponse$json,
  '.healthcare.infection.v1.Rate': Rate$json,
  '.healthcare.infection.v1.OnsetSummary': OnsetSummary$json,
  '.healthcare.infection.v1.StartIsolationRequest': StartIsolationRequest$json,
  '.healthcare.infection.v1.StartIsolationResponse':
      StartIsolationResponse$json,
  '.healthcare.infection.v1.Isolation': Isolation$json,
  '.healthcare.infection.v1.ExtendIsolationRequest':
      ExtendIsolationRequest$json,
  '.healthcare.infection.v1.ExtendIsolationResponse':
      ExtendIsolationResponse$json,
  '.healthcare.infection.v1.EndIsolationRequest': EndIsolationRequest$json,
  '.healthcare.infection.v1.EndIsolationResponse': EndIsolationResponse$json,
  '.healthcare.infection.v1.GetBoardRequest': GetBoardRequest$json,
  '.healthcare.infection.v1.GetBoardResponse': GetBoardResponse$json,
  '.healthcare.infection.v1.BoardEntry': BoardEntry$json,
  '.healthcare.infection.v1.DraftAlertRuleRequest': DraftAlertRuleRequest$json,
  '.healthcare.infection.v1.DraftAlertRuleResponse':
      DraftAlertRuleResponse$json,
  '.healthcare.infection.v1.AlertRule': AlertRule$json,
  '.healthcare.infection.v1.ApproveAlertRuleRequest':
      ApproveAlertRuleRequest$json,
  '.healthcare.infection.v1.ApproveAlertRuleResponse':
      ApproveAlertRuleResponse$json,
  '.healthcare.infection.v1.ScreenEncounterRequest':
      ScreenEncounterRequest$json,
  '.healthcare.infection.v1.ScreenEncounterResponse':
      ScreenEncounterResponse$json,
  '.healthcare.infection.v1.Alert': Alert$json,
  '.healthcare.infection.v1.AcknowledgeAlertRequest':
      AcknowledgeAlertRequest$json,
  '.healthcare.infection.v1.AcknowledgeAlertResponse':
      AcknowledgeAlertResponse$json,
  '.healthcare.infection.v1.OverrideAlertRequest': OverrideAlertRequest$json,
  '.healthcare.infection.v1.OverrideAlertResponse': OverrideAlertResponse$json,
  '.healthcare.infection.v1.ListAlertsRequest': ListAlertsRequest$json,
  '.healthcare.infection.v1.ListAlertsResponse': ListAlertsResponse$json,
  '.healthcare.infection.v1.OpenOutbreakRequest': OpenOutbreakRequest$json,
  '.healthcare.infection.v1.OpenOutbreakResponse': OpenOutbreakResponse$json,
  '.healthcare.infection.v1.Outbreak': Outbreak$json,
  '.healthcare.infection.v1.AdvanceOutbreakRequest':
      AdvanceOutbreakRequest$json,
  '.healthcare.infection.v1.AdvanceOutbreakResponse':
      AdvanceOutbreakResponse$json,
  '.healthcare.infection.v1.CloseOutbreakRequest': CloseOutbreakRequest$json,
  '.healthcare.infection.v1.CloseOutbreakResponse': CloseOutbreakResponse$json,
  '.healthcare.infection.v1.AddOutbreakMemberRequest':
      AddOutbreakMemberRequest$json,
  '.healthcare.infection.v1.AddOutbreakMemberResponse':
      AddOutbreakMemberResponse$json,
  '.healthcare.infection.v1.Membership': Membership$json,
  '.healthcare.infection.v1.GetClusterRequest': GetClusterRequest$json,
  '.healthcare.infection.v1.GetClusterResponse': GetClusterResponse$json,
  '.healthcare.infection.v1.ClusterSummary': ClusterSummary$json,
  '.healthcare.infection.v1.ListOutbreaksRequest': ListOutbreaksRequest$json,
  '.healthcare.infection.v1.ListOutbreaksResponse': ListOutbreaksResponse$json,
  '.healthcare.infection.v1.StartHygieneSessionRequest':
      StartHygieneSessionRequest$json,
  '.healthcare.infection.v1.StartHygieneSessionResponse':
      StartHygieneSessionResponse$json,
  '.healthcare.infection.v1.HygieneSession': HygieneSession$json,
  '.healthcare.infection.v1.RecordObservationRequest':
      RecordObservationRequest$json,
  '.healthcare.infection.v1.RecordObservationResponse':
      RecordObservationResponse$json,
  '.healthcare.infection.v1.HygieneObservation': HygieneObservation$json,
  '.healthcare.infection.v1.EndHygieneSessionRequest':
      EndHygieneSessionRequest$json,
  '.healthcare.infection.v1.EndHygieneSessionResponse':
      EndHygieneSessionResponse$json,
  '.healthcare.infection.v1.GetHygieneComplianceRequest':
      GetHygieneComplianceRequest$json,
  '.healthcare.infection.v1.GetHygieneComplianceResponse':
      GetHygieneComplianceResponse$json,
  '.healthcare.infection.v1.Compliance': Compliance$json,
  '.healthcare.infection.v1.ReportExposureRequest': ReportExposureRequest$json,
  '.healthcare.infection.v1.ReportExposureResponse':
      ReportExposureResponse$json,
  '.healthcare.infection.v1.Exposure': Exposure$json,
  '.healthcare.infection.v1.ExposureTask': ExposureTask$json,
  '.healthcare.infection.v1.GetExposureRequest': GetExposureRequest$json,
  '.healthcare.infection.v1.GetExposureResponse': GetExposureResponse$json,
  '.healthcare.infection.v1.CompleteExposureTaskRequest':
      CompleteExposureTaskRequest$json,
  '.healthcare.infection.v1.CompleteExposureTaskResponse':
      CompleteExposureTaskResponse$json,
  '.healthcare.infection.v1.CloseExposureRequest': CloseExposureRequest$json,
  '.healthcare.infection.v1.CloseExposureResponse': CloseExposureResponse$json,
  '.healthcare.infection.v1.ListExposuresRequest': ListExposuresRequest$json,
  '.healthcare.infection.v1.ListExposuresResponse': ListExposuresResponse$json,
  '.healthcare.infection.v1.SweepExposureTasksRequest':
      SweepExposureTasksRequest$json,
  '.healthcare.infection.v1.SweepExposureTasksResponse':
      SweepExposureTasksResponse$json,
  '.healthcare.infection.v1.DraftStewardshipRuleRequest':
      DraftStewardshipRuleRequest$json,
  '.healthcare.infection.v1.DraftStewardshipRuleResponse':
      DraftStewardshipRuleResponse$json,
  '.healthcare.infection.v1.StewardshipRule': StewardshipRule$json,
  '.healthcare.infection.v1.ApproveStewardshipRuleRequest':
      ApproveStewardshipRuleRequest$json,
  '.healthcare.infection.v1.ApproveStewardshipRuleResponse':
      ApproveStewardshipRuleResponse$json,
  '.healthcare.infection.v1.ReviewEncounterRequest':
      ReviewEncounterRequest$json,
  '.healthcare.infection.v1.ReviewEncounterResponse':
      ReviewEncounterResponse$json,
  '.healthcare.infection.v1.StewardshipReview': StewardshipReview$json,
  '.healthcare.infection.v1.AdviseReviewRequest': AdviseReviewRequest$json,
  '.healthcare.infection.v1.AdviseReviewResponse': AdviseReviewResponse$json,
  '.healthcare.infection.v1.RespondToReviewRequest':
      RespondToReviewRequest$json,
  '.healthcare.infection.v1.RespondToReviewResponse':
      RespondToReviewResponse$json,
  '.healthcare.infection.v1.WithdrawReviewRequest': WithdrawReviewRequest$json,
  '.healthcare.infection.v1.WithdrawReviewResponse':
      WithdrawReviewResponse$json,
  '.healthcare.infection.v1.ListReviewsRequest': ListReviewsRequest$json,
  '.healthcare.infection.v1.ListReviewsResponse': ListReviewsResponse$json,
  '.healthcare.infection.v1.GetStewardshipIndicatorsRequest':
      GetStewardshipIndicatorsRequest$json,
  '.healthcare.infection.v1.GetStewardshipIndicatorsResponse':
      GetStewardshipIndicatorsResponse$json,
  '.healthcare.infection.v1.StewardshipSummary': StewardshipSummary$json,
  '.healthcare.infection.v1.TherapyRate': TherapyRate$json,
  '.healthcare.infection.v1.DraftLimitRequest': DraftLimitRequest$json,
  '.healthcare.infection.v1.DraftLimitResponse': DraftLimitResponse$json,
  '.healthcare.infection.v1.EnvironmentalLimit': EnvironmentalLimit$json,
  '.healthcare.infection.v1.ApproveLimitRequest': ApproveLimitRequest$json,
  '.healthcare.infection.v1.ApproveLimitResponse': ApproveLimitResponse$json,
  '.healthcare.infection.v1.AddSamplingPlanRequest':
      AddSamplingPlanRequest$json,
  '.healthcare.infection.v1.AddSamplingPlanResponse':
      AddSamplingPlanResponse$json,
  '.healthcare.infection.v1.SamplingPlan': SamplingPlan$json,
  '.healthcare.infection.v1.CollectSampleRequest': CollectSampleRequest$json,
  '.healthcare.infection.v1.CollectSampleResponse': CollectSampleResponse$json,
  '.healthcare.infection.v1.EnvironmentalSample': EnvironmentalSample$json,
  '.healthcare.infection.v1.RecordSampleResultRequest':
      RecordSampleResultRequest$json,
  '.healthcare.infection.v1.RecordSampleResultResponse':
      RecordSampleResultResponse$json,
  '.healthcare.infection.v1.RaiseCorrectiveActionRequest':
      RaiseCorrectiveActionRequest$json,
  '.healthcare.infection.v1.RaiseCorrectiveActionResponse':
      RaiseCorrectiveActionResponse$json,
  '.healthcare.infection.v1.CorrectiveAction': CorrectiveAction$json,
  '.healthcare.infection.v1.CompleteCorrectiveActionRequest':
      CompleteCorrectiveActionRequest$json,
  '.healthcare.infection.v1.CompleteCorrectiveActionResponse':
      CompleteCorrectiveActionResponse$json,
  '.healthcare.infection.v1.VerifyCorrectiveActionRequest':
      VerifyCorrectiveActionRequest$json,
  '.healthcare.infection.v1.VerifyCorrectiveActionResponse':
      VerifyCorrectiveActionResponse$json,
  '.healthcare.infection.v1.CloseSampleRequest': CloseSampleRequest$json,
  '.healthcare.infection.v1.CloseSampleResponse': CloseSampleResponse$json,
  '.healthcare.infection.v1.ListDueSamplingRequest':
      ListDueSamplingRequest$json,
  '.healthcare.infection.v1.ListDueSamplingResponse':
      ListDueSamplingResponse$json,
  '.healthcare.infection.v1.DuePoint': DuePoint$json,
  '.healthcare.infection.v1.ListSamplesRequest': ListSamplesRequest$json,
  '.healthcare.infection.v1.ListSamplesResponse': ListSamplesResponse$json,
  '.healthcare.infection.v1.ListCorrectiveActionsRequest':
      ListCorrectiveActionsRequest$json,
  '.healthcare.infection.v1.ListCorrectiveActionsResponse':
      ListCorrectiveActionsResponse$json,
  '.healthcare.infection.v1.GetEnvironmentSummaryRequest':
      GetEnvironmentSummaryRequest$json,
  '.healthcare.infection.v1.GetEnvironmentSummaryResponse':
      GetEnvironmentSummaryResponse$json,
  '.healthcare.infection.v1.EnvironmentSummary': EnvironmentSummary$json,
};

/// Descriptor for `InfectionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List infectionServiceDescriptor = $convert.base64Decode(
    'ChBJbmZlY3Rpb25TZXJ2aWNlEl8KCE9wZW5DYXNlEiguaGVhbHRoY2FyZS5pbmZlY3Rpb24udj'
    'EuT3BlbkNhc2VSZXF1ZXN0GikuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuT3BlbkNhc2VSZXNw'
    'b25zZRJlCgpSZXZpZXdDYXNlEiouaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuUmV2aWV3Q2FzZV'
    'JlcXVlc3QaKy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5SZXZpZXdDYXNlUmVzcG9uc2USbgoN'
    'T3ZlcnJpZGVPbnNldBItLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLk92ZXJyaWRlT25zZXRSZX'
    'F1ZXN0Gi4uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuT3ZlcnJpZGVPbnNldFJlc3BvbnNlEmIK'
    'CUxpc3RDYXNlcxIpLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkxpc3RDYXNlc1JlcXVlc3QaKi'
    '5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0Q2FzZXNSZXNwb25zZRJ3ChBSZWNvcmREZXZp'
    'Y2VEYXlzEjAuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuUmVjb3JkRGV2aWNlRGF5c1JlcXVlc3'
    'QaMS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5SZWNvcmREZXZpY2VEYXlzUmVzcG9uc2USXAoH'
    'R2V0UmF0ZRInLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkdldFJhdGVSZXF1ZXN0GiguaGVhbH'
    'RoY2FyZS5pbmZlY3Rpb24udjEuR2V0UmF0ZVJlc3BvbnNlEnEKDlN0YXJ0SXNvbGF0aW9uEi4u'
    'aGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuU3RhcnRJc29sYXRpb25SZXF1ZXN0Gi8uaGVhbHRoY2'
    'FyZS5pbmZlY3Rpb24udjEuU3RhcnRJc29sYXRpb25SZXNwb25zZRJ0Cg9FeHRlbmRJc29sYXRp'
    'b24SLy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5FeHRlbmRJc29sYXRpb25SZXF1ZXN0GjAuaG'
    'VhbHRoY2FyZS5pbmZlY3Rpb24udjEuRXh0ZW5kSXNvbGF0aW9uUmVzcG9uc2USawoMRW5kSXNv'
    'bGF0aW9uEiwuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuRW5kSXNvbGF0aW9uUmVxdWVzdBotLm'
    'hlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkVuZElzb2xhdGlvblJlc3BvbnNlEl8KCEdldEJvYXJk'
    'EiguaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuR2V0Qm9hcmRSZXF1ZXN0GikuaGVhbHRoY2FyZS'
    '5pbmZlY3Rpb24udjEuR2V0Qm9hcmRSZXNwb25zZRJxCg5EcmFmdEFsZXJ0UnVsZRIuLmhlYWx0'
    'aGNhcmUuaW5mZWN0aW9uLnYxLkRyYWZ0QWxlcnRSdWxlUmVxdWVzdBovLmhlYWx0aGNhcmUuaW'
    '5mZWN0aW9uLnYxLkRyYWZ0QWxlcnRSdWxlUmVzcG9uc2USdwoQQXBwcm92ZUFsZXJ0UnVsZRIw'
    'LmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFwcHJvdmVBbGVydFJ1bGVSZXF1ZXN0GjEuaGVhbH'
    'RoY2FyZS5pbmZlY3Rpb24udjEuQXBwcm92ZUFsZXJ0UnVsZVJlc3BvbnNlEnQKD1NjcmVlbkVu'
    'Y291bnRlchIvLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlNjcmVlbkVuY291bnRlclJlcXVlc3'
    'QaMC5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5TY3JlZW5FbmNvdW50ZXJSZXNwb25zZRJ3ChBB'
    'Y2tub3dsZWRnZUFsZXJ0EjAuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQWNrbm93bGVkZ2VBbG'
    'VydFJlcXVlc3QaMS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5BY2tub3dsZWRnZUFsZXJ0UmVz'
    'cG9uc2USbgoNT3ZlcnJpZGVBbGVydBItLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLk92ZXJyaW'
    'RlQWxlcnRSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuT3ZlcnJpZGVBbGVydFJl'
    'c3BvbnNlEmUKCkxpc3RBbGVydHMSKi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0QWxlcn'
    'RzUmVxdWVzdBorLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkxpc3RBbGVydHNSZXNwb25zZRJr'
    'CgxPcGVuT3V0YnJlYWsSLC5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5PcGVuT3V0YnJlYWtSZX'
    'F1ZXN0Gi0uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuT3Blbk91dGJyZWFrUmVzcG9uc2USdAoP'
    'QWR2YW5jZU91dGJyZWFrEi8uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQWR2YW5jZU91dGJyZW'
    'FrUmVxdWVzdBowLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFkdmFuY2VPdXRicmVha1Jlc3Bv'
    'bnNlEm4KDUNsb3NlT3V0YnJlYWsSLS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5DbG9zZU91dG'
    'JyZWFrUmVxdWVzdBouLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkNsb3NlT3V0YnJlYWtSZXNw'
    'b25zZRJ6ChFBZGRPdXRicmVha01lbWJlchIxLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFkZE'
    '91dGJyZWFrTWVtYmVyUmVxdWVzdBoyLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFkZE91dGJy'
    'ZWFrTWVtYmVyUmVzcG9uc2USZQoKR2V0Q2x1c3RlchIqLmhlYWx0aGNhcmUuaW5mZWN0aW9uLn'
    'YxLkdldENsdXN0ZXJSZXF1ZXN0GisuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuR2V0Q2x1c3Rl'
    'clJlc3BvbnNlEm4KDUxpc3RPdXRicmVha3MSLS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaX'
    'N0T3V0YnJlYWtzUmVxdWVzdBouLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkxpc3RPdXRicmVh'
    'a3NSZXNwb25zZRKAAQoTU3RhcnRIeWdpZW5lU2Vzc2lvbhIzLmhlYWx0aGNhcmUuaW5mZWN0aW'
    '9uLnYxLlN0YXJ0SHlnaWVuZVNlc3Npb25SZXF1ZXN0GjQuaGVhbHRoY2FyZS5pbmZlY3Rpb24u'
    'djEuU3RhcnRIeWdpZW5lU2Vzc2lvblJlc3BvbnNlEnoKEVJlY29yZE9ic2VydmF0aW9uEjEuaG'
    'VhbHRoY2FyZS5pbmZlY3Rpb24udjEuUmVjb3JkT2JzZXJ2YXRpb25SZXF1ZXN0GjIuaGVhbHRo'
    'Y2FyZS5pbmZlY3Rpb24udjEuUmVjb3JkT2JzZXJ2YXRpb25SZXNwb25zZRJ6ChFFbmRIeWdpZW'
    '5lU2Vzc2lvbhIxLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkVuZEh5Z2llbmVTZXNzaW9uUmVx'
    'dWVzdBoyLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkVuZEh5Z2llbmVTZXNzaW9uUmVzcG9uc2'
    'USgwEKFEdldEh5Z2llbmVDb21wbGlhbmNlEjQuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuR2V0'
    'SHlnaWVuZUNvbXBsaWFuY2VSZXF1ZXN0GjUuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuR2V0SH'
    'lnaWVuZUNvbXBsaWFuY2VSZXNwb25zZRJxCg5SZXBvcnRFeHBvc3VyZRIuLmhlYWx0aGNhcmUu'
    'aW5mZWN0aW9uLnYxLlJlcG9ydEV4cG9zdXJlUmVxdWVzdBovLmhlYWx0aGNhcmUuaW5mZWN0aW'
    '9uLnYxLlJlcG9ydEV4cG9zdXJlUmVzcG9uc2USaAoLR2V0RXhwb3N1cmUSKy5oZWFsdGhjYXJl'
    'LmluZmVjdGlvbi52MS5HZXRFeHBvc3VyZVJlcXVlc3QaLC5oZWFsdGhjYXJlLmluZmVjdGlvbi'
    '52MS5HZXRFeHBvc3VyZVJlc3BvbnNlEoMBChRDb21wbGV0ZUV4cG9zdXJlVGFzaxI0LmhlYWx0'
    'aGNhcmUuaW5mZWN0aW9uLnYxLkNvbXBsZXRlRXhwb3N1cmVUYXNrUmVxdWVzdBo1LmhlYWx0aG'
    'NhcmUuaW5mZWN0aW9uLnYxLkNvbXBsZXRlRXhwb3N1cmVUYXNrUmVzcG9uc2USbgoNQ2xvc2VF'
    'eHBvc3VyZRItLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkNsb3NlRXhwb3N1cmVSZXF1ZXN0Gi'
    '4uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQ2xvc2VFeHBvc3VyZVJlc3BvbnNlEm4KDUxpc3RF'
    'eHBvc3VyZXMSLS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0RXhwb3N1cmVzUmVxdWVzdB'
    'ouLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkxpc3RFeHBvc3VyZXNSZXNwb25zZRJ9ChJTd2Vl'
    'cEV4cG9zdXJlVGFza3MSMi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5Td2VlcEV4cG9zdXJlVG'
    'Fza3NSZXF1ZXN0GjMuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuU3dlZXBFeHBvc3VyZVRhc2tz'
    'UmVzcG9uc2USgwEKFERyYWZ0U3Rld2FyZHNoaXBSdWxlEjQuaGVhbHRoY2FyZS5pbmZlY3Rpb2'
    '4udjEuRHJhZnRTdGV3YXJkc2hpcFJ1bGVSZXF1ZXN0GjUuaGVhbHRoY2FyZS5pbmZlY3Rpb24u'
    'djEuRHJhZnRTdGV3YXJkc2hpcFJ1bGVSZXNwb25zZRKJAQoWQXBwcm92ZVN0ZXdhcmRzaGlwUn'
    'VsZRI2LmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFwcHJvdmVTdGV3YXJkc2hpcFJ1bGVSZXF1'
    'ZXN0GjcuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQXBwcm92ZVN0ZXdhcmRzaGlwUnVsZVJlc3'
    'BvbnNlEnQKD1Jldmlld0VuY291bnRlchIvLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlJldmll'
    'd0VuY291bnRlclJlcXVlc3QaMC5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5SZXZpZXdFbmNvdW'
    '50ZXJSZXNwb25zZRJrCgxBZHZpc2VSZXZpZXcSLC5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5B'
    'ZHZpc2VSZXZpZXdSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQWR2aXNlUmV2aW'
    'V3UmVzcG9uc2USdAoPUmVzcG9uZFRvUmV2aWV3Ei8uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEu'
    'UmVzcG9uZFRvUmV2aWV3UmVxdWVzdBowLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlJlc3Bvbm'
    'RUb1Jldmlld1Jlc3BvbnNlEnEKDldpdGhkcmF3UmV2aWV3Ei4uaGVhbHRoY2FyZS5pbmZlY3Rp'
    'b24udjEuV2l0aGRyYXdSZXZpZXdSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuV2'
    'l0aGRyYXdSZXZpZXdSZXNwb25zZRJoCgtMaXN0UmV2aWV3cxIrLmhlYWx0aGNhcmUuaW5mZWN0'
    'aW9uLnYxLkxpc3RSZXZpZXdzUmVxdWVzdBosLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkxpc3'
    'RSZXZpZXdzUmVzcG9uc2USjwEKGEdldFN0ZXdhcmRzaGlwSW5kaWNhdG9ycxI4LmhlYWx0aGNh'
    'cmUuaW5mZWN0aW9uLnYxLkdldFN0ZXdhcmRzaGlwSW5kaWNhdG9yc1JlcXVlc3QaOS5oZWFsdG'
    'hjYXJlLmluZmVjdGlvbi52MS5HZXRTdGV3YXJkc2hpcEluZGljYXRvcnNSZXNwb25zZRJlCgpE'
    'cmFmdExpbWl0EiouaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuRHJhZnRMaW1pdFJlcXVlc3QaKy'
    '5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5EcmFmdExpbWl0UmVzcG9uc2USawoMQXBwcm92ZUxp'
    'bWl0EiwuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQXBwcm92ZUxpbWl0UmVxdWVzdBotLmhlYW'
    'x0aGNhcmUuaW5mZWN0aW9uLnYxLkFwcHJvdmVMaW1pdFJlc3BvbnNlEnQKD0FkZFNhbXBsaW5n'
    'UGxhbhIvLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkFkZFNhbXBsaW5nUGxhblJlcXVlc3QaMC'
    '5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5BZGRTYW1wbGluZ1BsYW5SZXNwb25zZRJuCg1Db2xs'
    'ZWN0U2FtcGxlEi0uaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQ29sbGVjdFNhbXBsZVJlcXVlc3'
    'QaLi5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5Db2xsZWN0U2FtcGxlUmVzcG9uc2USfQoSUmVj'
    'b3JkU2FtcGxlUmVzdWx0EjIuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuUmVjb3JkU2FtcGxlUm'
    'VzdWx0UmVxdWVzdBozLmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLlJlY29yZFNhbXBsZVJlc3Vs'
    'dFJlc3BvbnNlEoYBChVSYWlzZUNvcnJlY3RpdmVBY3Rpb24SNS5oZWFsdGhjYXJlLmluZmVjdG'
    'lvbi52MS5SYWlzZUNvcnJlY3RpdmVBY3Rpb25SZXF1ZXN0GjYuaGVhbHRoY2FyZS5pbmZlY3Rp'
    'b24udjEuUmFpc2VDb3JyZWN0aXZlQWN0aW9uUmVzcG9uc2USjwEKGENvbXBsZXRlQ29ycmVjdG'
    'l2ZUFjdGlvbhI4LmhlYWx0aGNhcmUuaW5mZWN0aW9uLnYxLkNvbXBsZXRlQ29ycmVjdGl2ZUFj'
    'dGlvblJlcXVlc3QaOS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5Db21wbGV0ZUNvcnJlY3Rpdm'
    'VBY3Rpb25SZXNwb25zZRKJAQoWVmVyaWZ5Q29ycmVjdGl2ZUFjdGlvbhI2LmhlYWx0aGNhcmUu'
    'aW5mZWN0aW9uLnYxLlZlcmlmeUNvcnJlY3RpdmVBY3Rpb25SZXF1ZXN0GjcuaGVhbHRoY2FyZS'
    '5pbmZlY3Rpb24udjEuVmVyaWZ5Q29ycmVjdGl2ZUFjdGlvblJlc3BvbnNlEmgKC0Nsb3NlU2Ft'
    'cGxlEisuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuQ2xvc2VTYW1wbGVSZXF1ZXN0GiwuaGVhbH'
    'RoY2FyZS5pbmZlY3Rpb24udjEuQ2xvc2VTYW1wbGVSZXNwb25zZRJ0Cg9MaXN0RHVlU2FtcGxp'
    'bmcSLy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0RHVlU2FtcGxpbmdSZXF1ZXN0GjAuaG'
    'VhbHRoY2FyZS5pbmZlY3Rpb24udjEuTGlzdER1ZVNhbXBsaW5nUmVzcG9uc2USaAoLTGlzdFNh'
    'bXBsZXMSKy5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0U2FtcGxlc1JlcXVlc3QaLC5oZW'
    'FsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0U2FtcGxlc1Jlc3BvbnNlEoYBChVMaXN0Q29ycmVj'
    'dGl2ZUFjdGlvbnMSNS5oZWFsdGhjYXJlLmluZmVjdGlvbi52MS5MaXN0Q29ycmVjdGl2ZUFjdG'
    'lvbnNSZXF1ZXN0GjYuaGVhbHRoY2FyZS5pbmZlY3Rpb24udjEuTGlzdENvcnJlY3RpdmVBY3Rp'
    'b25zUmVzcG9uc2UShgEKFUdldEVudmlyb25tZW50U3VtbWFyeRI1LmhlYWx0aGNhcmUuaW5mZW'
    'N0aW9uLnYxLkdldEVudmlyb25tZW50U3VtbWFyeVJlcXVlc3QaNi5oZWFsdGhjYXJlLmluZmVj'
    'dGlvbi52MS5HZXRFbnZpcm9ubWVudFN1bW1hcnlSZXNwb25zZQ==');
