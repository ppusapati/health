// This is a generated file - do not edit.
//
// Generated from healthcare/clinical/v1/clinical.proto.

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

@$core.Deprecated('Use documentStatusDescriptor instead')
const DocumentStatus$json = {
  '1': 'DocumentStatus',
  '2': [
    {'1': 'DOCUMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_STATUS_DRAFT', '2': 1},
    {'1': 'DOCUMENT_STATUS_SIGNED', '2': 2},
    {'1': 'DOCUMENT_STATUS_AMENDED', '2': 3},
    {'1': 'DOCUMENT_STATUS_ADDENDUM', '2': 4},
    {'1': 'DOCUMENT_STATUS_ENTERED_IN_ERROR', '2': 5},
  ],
};

/// Descriptor for `DocumentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentStatusDescriptor = $convert.base64Decode(
    'Cg5Eb2N1bWVudFN0YXR1cxIfChtET0NVTUVOVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVET0'
    'NVTUVOVF9TVEFUVVNfRFJBRlQQARIaChZET0NVTUVOVF9TVEFUVVNfU0lHTkVEEAISGwoXRE9D'
    'VU1FTlRfU1RBVFVTX0FNRU5ERUQQAxIcChhET0NVTUVOVF9TVEFUVVNfQURERU5EVU0QBBIkCi'
    'BET0NVTUVOVF9TVEFUVVNfRU5URVJFRF9JTl9FUlJPUhAF');

@$core.Deprecated('Use documentKindDescriptor instead')
const DocumentKind$json = {
  '1': 'DocumentKind',
  '2': [
    {'1': 'DOCUMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_KIND_PROGRESS_NOTE', '2': 1},
    {'1': 'DOCUMENT_KIND_CONSULTATION_NOTE', '2': 2},
    {'1': 'DOCUMENT_KIND_DISCHARGE_SUMMARY', '2': 3},
    {'1': 'DOCUMENT_KIND_OPERATION_NOTE', '2': 4},
    {'1': 'DOCUMENT_KIND_NURSING_NOTE', '2': 5},
    {'1': 'DOCUMENT_KIND_REFERRAL_LETTER', '2': 6},
    {'1': 'DOCUMENT_KIND_PROCEDURE_REPORT', '2': 7},
  ],
};

/// Descriptor for `DocumentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentKindDescriptor = $convert.base64Decode(
    'CgxEb2N1bWVudEtpbmQSHQoZRE9DVU1FTlRfS0lORF9VTlNQRUNJRklFRBAAEh8KG0RPQ1VNRU'
    '5UX0tJTkRfUFJPR1JFU1NfTk9URRABEiMKH0RPQ1VNRU5UX0tJTkRfQ09OU1VMVEFUSU9OX05P'
    'VEUQAhIjCh9ET0NVTUVOVF9LSU5EX0RJU0NIQVJHRV9TVU1NQVJZEAMSIAocRE9DVU1FTlRfS0'
    'lORF9PUEVSQVRJT05fTk9URRAEEh4KGkRPQ1VNRU5UX0tJTkRfTlVSU0lOR19OT1RFEAUSIQod'
    'RE9DVU1FTlRfS0lORF9SRUZFUlJBTF9MRVRURVIQBhIiCh5ET0NVTUVOVF9LSU5EX1BST0NFRF'
    'VSRV9SRVBPUlQQBw==');

@$core.Deprecated('Use signatureMeaningDescriptor instead')
const SignatureMeaning$json = {
  '1': 'SignatureMeaning',
  '2': [
    {'1': 'SIGNATURE_MEANING_UNSPECIFIED', '2': 0},
    {'1': 'SIGNATURE_MEANING_AUTHOR', '2': 1},
    {'1': 'SIGNATURE_MEANING_VERIFIER', '2': 2},
    {'1': 'SIGNATURE_MEANING_COSIGNER', '2': 3},
    {'1': 'SIGNATURE_MEANING_WITNESS', '2': 4},
    {'1': 'SIGNATURE_MEANING_TRANSCRIBER', '2': 5},
  ],
};

/// Descriptor for `SignatureMeaning`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List signatureMeaningDescriptor = $convert.base64Decode(
    'ChBTaWduYXR1cmVNZWFuaW5nEiEKHVNJR05BVFVSRV9NRUFOSU5HX1VOU1BFQ0lGSUVEEAASHA'
    'oYU0lHTkFUVVJFX01FQU5JTkdfQVVUSE9SEAESHgoaU0lHTkFUVVJFX01FQU5JTkdfVkVSSUZJ'
    'RVIQAhIeChpTSUdOQVRVUkVfTUVBTklOR19DT1NJR05FUhADEh0KGVNJR05BVFVSRV9NRUFOSU'
    '5HX1dJVE5FU1MQBBIhCh1TSUdOQVRVUkVfTUVBTklOR19UUkFOU0NSSUJFUhAF');

@$core.Deprecated('Use problemStatusDescriptor instead')
const ProblemStatus$json = {
  '1': 'ProblemStatus',
  '2': [
    {'1': 'PROBLEM_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PROBLEM_STATUS_ACTIVE', '2': 1},
    {'1': 'PROBLEM_STATUS_REMISSION', '2': 2},
    {'1': 'PROBLEM_STATUS_RESOLVED', '2': 3},
    {'1': 'PROBLEM_STATUS_INACTIVE', '2': 4},
    {'1': 'PROBLEM_STATUS_ENTERED_IN_ERROR', '2': 5},
  ],
};

/// Descriptor for `ProblemStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List problemStatusDescriptor = $convert.base64Decode(
    'Cg1Qcm9ibGVtU3RhdHVzEh4KGlBST0JMRU1fU1RBVFVTX1VOU1BFQ0lGSUVEEAASGQoVUFJPQk'
    'xFTV9TVEFUVVNfQUNUSVZFEAESHAoYUFJPQkxFTV9TVEFUVVNfUkVNSVNTSU9OEAISGwoXUFJP'
    'QkxFTV9TVEFUVVNfUkVTT0xWRUQQAxIbChdQUk9CTEVNX1NUQVRVU19JTkFDVElWRRAEEiMKH1'
    'BST0JMRU1fU1RBVFVTX0VOVEVSRURfSU5fRVJST1IQBQ==');

@$core.Deprecated('Use allergyKindDescriptor instead')
const AllergyKind$json = {
  '1': 'AllergyKind',
  '2': [
    {'1': 'ALLERGY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ALLERGY_KIND_ALLERGY', '2': 1},
    {'1': 'ALLERGY_KIND_INTOLERANCE', '2': 2},
  ],
};

/// Descriptor for `AllergyKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List allergyKindDescriptor = $convert.base64Decode(
    'CgtBbGxlcmd5S2luZBIcChhBTExFUkdZX0tJTkRfVU5TUEVDSUZJRUQQABIYChRBTExFUkdZX0'
    'tJTkRfQUxMRVJHWRABEhwKGEFMTEVSR1lfS0lORF9JTlRPTEVSQU5DRRAC');

@$core.Deprecated('Use allergyCriticalityDescriptor instead')
const AllergyCriticality$json = {
  '1': 'AllergyCriticality',
  '2': [
    {'1': 'ALLERGY_CRITICALITY_UNSPECIFIED', '2': 0},
    {'1': 'ALLERGY_CRITICALITY_LOW', '2': 1},
    {'1': 'ALLERGY_CRITICALITY_HIGH', '2': 2},
    {'1': 'ALLERGY_CRITICALITY_UNABLE_TO_ASSESS', '2': 3},
  ],
};

/// Descriptor for `AllergyCriticality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List allergyCriticalityDescriptor = $convert.base64Decode(
    'ChJBbGxlcmd5Q3JpdGljYWxpdHkSIwofQUxMRVJHWV9DUklUSUNBTElUWV9VTlNQRUNJRklFRB'
    'AAEhsKF0FMTEVSR1lfQ1JJVElDQUxJVFlfTE9XEAESHAoYQUxMRVJHWV9DUklUSUNBTElUWV9I'
    'SUdIEAISKAokQUxMRVJHWV9DUklUSUNBTElUWV9VTkFCTEVfVE9fQVNTRVNTEAM=');

@$core.Deprecated('Use allergyVerificationDescriptor instead')
const AllergyVerification$json = {
  '1': 'AllergyVerification',
  '2': [
    {'1': 'ALLERGY_VERIFICATION_UNSPECIFIED', '2': 0},
    {'1': 'ALLERGY_VERIFICATION_UNCONFIRMED', '2': 1},
    {'1': 'ALLERGY_VERIFICATION_CONFIRMED', '2': 2},
    {'1': 'ALLERGY_VERIFICATION_REFUTED', '2': 3},
    {'1': 'ALLERGY_VERIFICATION_ENTERED_IN_ERROR', '2': 4},
  ],
};

/// Descriptor for `AllergyVerification`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List allergyVerificationDescriptor = $convert.base64Decode(
    'ChNBbGxlcmd5VmVyaWZpY2F0aW9uEiQKIEFMTEVSR1lfVkVSSUZJQ0FUSU9OX1VOU1BFQ0lGSU'
    'VEEAASJAogQUxMRVJHWV9WRVJJRklDQVRJT05fVU5DT05GSVJNRUQQARIiCh5BTExFUkdZX1ZF'
    'UklGSUNBVElPTl9DT05GSVJNRUQQAhIgChxBTExFUkdZX1ZFUklGSUNBVElPTl9SRUZVVEVEEA'
    'MSKQolQUxMRVJHWV9WRVJJRklDQVRJT05fRU5URVJFRF9JTl9FUlJPUhAE');

@$core.Deprecated('Use interpretationDescriptor instead')
const Interpretation$json = {
  '1': 'Interpretation',
  '2': [
    {'1': 'INTERPRETATION_UNSPECIFIED', '2': 0},
    {'1': 'INTERPRETATION_NORMAL', '2': 1},
    {'1': 'INTERPRETATION_HIGH', '2': 2},
    {'1': 'INTERPRETATION_LOW', '2': 3},
    {'1': 'INTERPRETATION_CRITICAL_HIGH', '2': 4},
    {'1': 'INTERPRETATION_CRITICAL_LOW', '2': 5},
    {'1': 'INTERPRETATION_ABNORMAL', '2': 6},
    {'1': 'INTERPRETATION_UNKNOWN', '2': 7},
  ],
};

/// Descriptor for `Interpretation`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List interpretationDescriptor = $convert.base64Decode(
    'Cg5JbnRlcnByZXRhdGlvbhIeChpJTlRFUlBSRVRBVElPTl9VTlNQRUNJRklFRBAAEhkKFUlOVE'
    'VSUFJFVEFUSU9OX05PUk1BTBABEhcKE0lOVEVSUFJFVEFUSU9OX0hJR0gQAhIWChJJTlRFUlBS'
    'RVRBVElPTl9MT1cQAxIgChxJTlRFUlBSRVRBVElPTl9DUklUSUNBTF9ISUdIEAQSHwobSU5URV'
    'JQUkVUQVRJT05fQ1JJVElDQUxfTE9XEAUSGwoXSU5URVJQUkVUQVRJT05fQUJOT1JNQUwQBhIa'
    'ChZJTlRFUlBSRVRBVElPTl9VTktOT1dOEAc=');

@$core.Deprecated('Use observationStatusDescriptor instead')
const ObservationStatus$json = {
  '1': 'ObservationStatus',
  '2': [
    {'1': 'OBSERVATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'OBSERVATION_STATUS_REGISTERED', '2': 1},
    {'1': 'OBSERVATION_STATUS_PRELIMINARY', '2': 2},
    {'1': 'OBSERVATION_STATUS_FINAL', '2': 3},
    {'1': 'OBSERVATION_STATUS_AMENDED', '2': 4},
    {'1': 'OBSERVATION_STATUS_CANCELLED', '2': 5},
    {'1': 'OBSERVATION_STATUS_ENTERED_IN_ERROR', '2': 6},
  ],
};

/// Descriptor for `ObservationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List observationStatusDescriptor = $convert.base64Decode(
    'ChFPYnNlcnZhdGlvblN0YXR1cxIiCh5PQlNFUlZBVElPTl9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IhCh1PQlNFUlZBVElPTl9TVEFUVVNfUkVHSVNURVJFRBABEiIKHk9CU0VSVkFUSU9OX1NUQVRV'
    'U19QUkVMSU1JTkFSWRACEhwKGE9CU0VSVkFUSU9OX1NUQVRVU19GSU5BTBADEh4KGk9CU0VSVk'
    'FUSU9OX1NUQVRVU19BTUVOREVEEAQSIAocT0JTRVJWQVRJT05fU1RBVFVTX0NBTkNFTExFRBAF'
    'EicKI09CU0VSVkFUSU9OX1NUQVRVU19FTlRFUkVEX0lOX0VSUk9SEAY=');

@$core.Deprecated('Use procedureStatusDescriptor instead')
const ProcedureStatus$json = {
  '1': 'ProcedureStatus',
  '2': [
    {'1': 'PROCEDURE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PROCEDURE_STATUS_PLANNED', '2': 1},
    {'1': 'PROCEDURE_STATUS_IN_PROGRESS', '2': 2},
    {'1': 'PROCEDURE_STATUS_COMPLETED', '2': 3},
    {'1': 'PROCEDURE_STATUS_STOPPED', '2': 4},
    {'1': 'PROCEDURE_STATUS_NOT_DONE', '2': 5},
    {'1': 'PROCEDURE_STATUS_ENTERED_IN_ERROR', '2': 6},
  ],
};

/// Descriptor for `ProcedureStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List procedureStatusDescriptor = $convert.base64Decode(
    'Cg9Qcm9jZWR1cmVTdGF0dXMSIAocUFJPQ0VEVVJFX1NUQVRVU19VTlNQRUNJRklFRBAAEhwKGF'
    'BST0NFRFVSRV9TVEFUVVNfUExBTk5FRBABEiAKHFBST0NFRFVSRV9TVEFUVVNfSU5fUFJPR1JF'
    'U1MQAhIeChpQUk9DRURVUkVfU1RBVFVTX0NPTVBMRVRFRBADEhwKGFBST0NFRFVSRV9TVEFUVV'
    'NfU1RPUFBFRBAEEh0KGVBST0NFRFVSRV9TVEFUVVNfTk9UX0RPTkUQBRIlCiFQUk9DRURVUkVf'
    'U1RBVFVTX0VOVEVSRURfSU5fRVJST1IQBg==');

@$core.Deprecated('Use lateralityDescriptor instead')
const Laterality$json = {
  '1': 'Laterality',
  '2': [
    {'1': 'LATERALITY_UNSPECIFIED', '2': 0},
    {'1': 'LATERALITY_NOT_APPLICABLE', '2': 1},
    {'1': 'LATERALITY_LEFT', '2': 2},
    {'1': 'LATERALITY_RIGHT', '2': 3},
    {'1': 'LATERALITY_BILATERAL', '2': 4},
    {'1': 'LATERALITY_UNRECORDED', '2': 5},
  ],
};

/// Descriptor for `Laterality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lateralityDescriptor = $convert.base64Decode(
    'CgpMYXRlcmFsaXR5EhoKFkxBVEVSQUxJVFlfVU5TUEVDSUZJRUQQABIdChlMQVRFUkFMSVRZX0'
    '5PVF9BUFBMSUNBQkxFEAESEwoPTEFURVJBTElUWV9MRUZUEAISFAoQTEFURVJBTElUWV9SSUdI'
    'VBADEhgKFExBVEVSQUxJVFlfQklMQVRFUkFMEAQSGQoVTEFURVJBTElUWV9VTlJFQ09SREVEEA'
    'U=');

@$core.Deprecated('Use carePlanStatusDescriptor instead')
const CarePlanStatus$json = {
  '1': 'CarePlanStatus',
  '2': [
    {'1': 'CARE_PLAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CARE_PLAN_STATUS_DRAFT', '2': 1},
    {'1': 'CARE_PLAN_STATUS_ACTIVE', '2': 2},
    {'1': 'CARE_PLAN_STATUS_ON_HOLD', '2': 3},
    {'1': 'CARE_PLAN_STATUS_COMPLETED', '2': 4},
    {'1': 'CARE_PLAN_STATUS_REVOKED', '2': 5},
  ],
};

/// Descriptor for `CarePlanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List carePlanStatusDescriptor = $convert.base64Decode(
    'Cg5DYXJlUGxhblN0YXR1cxIgChxDQVJFX1BMQU5fU1RBVFVTX1VOU1BFQ0lGSUVEEAASGgoWQ0'
    'FSRV9QTEFOX1NUQVRVU19EUkFGVBABEhsKF0NBUkVfUExBTl9TVEFUVVNfQUNUSVZFEAISHAoY'
    'Q0FSRV9QTEFOX1NUQVRVU19PTl9IT0xEEAMSHgoaQ0FSRV9QTEFOX1NUQVRVU19DT01QTEVURU'
    'QQBBIcChhDQVJFX1BMQU5fU1RBVFVTX1JFVk9LRUQQBQ==');

@$core.Deprecated('Use goalStatusDescriptor instead')
const GoalStatus$json = {
  '1': 'GoalStatus',
  '2': [
    {'1': 'GOAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'GOAL_STATUS_PROPOSED', '2': 1},
    {'1': 'GOAL_STATUS_ACTIVE', '2': 2},
    {'1': 'GOAL_STATUS_ACHIEVED', '2': 3},
    {'1': 'GOAL_STATUS_NOT_ACHIEVED', '2': 4},
    {'1': 'GOAL_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `GoalStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List goalStatusDescriptor = $convert.base64Decode(
    'CgpHb2FsU3RhdHVzEhsKF0dPQUxfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUR09BTF9TVEFUVV'
    'NfUFJPUE9TRUQQARIWChJHT0FMX1NUQVRVU19BQ1RJVkUQAhIYChRHT0FMX1NUQVRVU19BQ0hJ'
    'RVZFRBADEhwKGEdPQUxfU1RBVFVTX05PVF9BQ0hJRVZFRBAEEhkKFUdPQUxfU1RBVFVTX0NBTk'
    'NFTExFRBAF');

@$core.Deprecated('Use activityStatusDescriptor instead')
const ActivityStatus$json = {
  '1': 'ActivityStatus',
  '2': [
    {'1': 'ACTIVITY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACTIVITY_STATUS_NOT_STARTED', '2': 1},
    {'1': 'ACTIVITY_STATUS_SCHEDULED', '2': 2},
    {'1': 'ACTIVITY_STATUS_IN_PROGRESS', '2': 3},
    {'1': 'ACTIVITY_STATUS_COMPLETED', '2': 4},
    {'1': 'ACTIVITY_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `ActivityStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List activityStatusDescriptor = $convert.base64Decode(
    'Cg5BY3Rpdml0eVN0YXR1cxIfChtBQ1RJVklUWV9TVEFUVVNfVU5TUEVDSUZJRUQQABIfChtBQ1'
    'RJVklUWV9TVEFUVVNfTk9UX1NUQVJURUQQARIdChlBQ1RJVklUWV9TVEFUVVNfU0NIRURVTEVE'
    'EAISHwobQUNUSVZJVFlfU1RBVFVTX0lOX1BST0dSRVNTEAMSHQoZQUNUSVZJVFlfU1RBVFVTX0'
    'NPTVBMRVRFRBAEEh0KGUFDVElWSVRZX1NUQVRVU19DQU5DRUxMRUQQBQ==');

@$core.Deprecated('Use attachmentKindDescriptor instead')
const AttachmentKind$json = {
  '1': 'AttachmentKind',
  '2': [
    {'1': 'ATTACHMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ATTACHMENT_KIND_IMAGE', '2': 1},
    {'1': 'ATTACHMENT_KIND_DOCUMENT', '2': 2},
    {'1': 'ATTACHMENT_KIND_AUDIO', '2': 3},
    {'1': 'ATTACHMENT_KIND_VIDEO', '2': 4},
    {'1': 'ATTACHMENT_KIND_WAVEFORM', '2': 5},
  ],
};

/// Descriptor for `AttachmentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List attachmentKindDescriptor = $convert.base64Decode(
    'Cg5BdHRhY2htZW50S2luZBIfChtBVFRBQ0hNRU5UX0tJTkRfVU5TUEVDSUZJRUQQABIZChVBVF'
    'RBQ0hNRU5UX0tJTkRfSU1BR0UQARIcChhBVFRBQ0hNRU5UX0tJTkRfRE9DVU1FTlQQAhIZChVB'
    'VFRBQ0hNRU5UX0tJTkRfQVVESU8QAxIZChVBVFRBQ0hNRU5UX0tJTkRfVklERU8QBBIcChhBVF'
    'RBQ0hNRU5UX0tJTkRfV0FWRUZPUk0QBQ==');

@$core.Deprecated('Use consentKindDescriptor instead')
const ConsentKind$json = {
  '1': 'ConsentKind',
  '2': [
    {'1': 'CONSENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'CONSENT_KIND_PROCEDURE', '2': 1},
    {'1': 'CONSENT_KIND_ANAESTHESIA', '2': 2},
    {'1': 'CONSENT_KIND_TRANSFUSION', '2': 3},
    {'1': 'CONSENT_KIND_PHOTOGRAPHY', '2': 4},
    {'1': 'CONSENT_KIND_RESEARCH', '2': 5},
    {'1': 'CONSENT_KIND_TREATMENT', '2': 6},
  ],
};

/// Descriptor for `ConsentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consentKindDescriptor = $convert.base64Decode(
    'CgtDb25zZW50S2luZBIcChhDT05TRU5UX0tJTkRfVU5TUEVDSUZJRUQQABIaChZDT05TRU5UX0'
    'tJTkRfUFJPQ0VEVVJFEAESHAoYQ09OU0VOVF9LSU5EX0FOQUVTVEhFU0lBEAISHAoYQ09OU0VO'
    'VF9LSU5EX1RSQU5TRlVTSU9OEAMSHAoYQ09OU0VOVF9LSU5EX1BIT1RPR1JBUEhZEAQSGQoVQ0'
    '9OU0VOVF9LSU5EX1JFU0VBUkNIEAUSGgoWQ09OU0VOVF9LSU5EX1RSRUFUTUVOVBAG');

@$core.Deprecated('Use consentStatusDescriptor instead')
const ConsentStatus$json = {
  '1': 'ConsentStatus',
  '2': [
    {'1': 'CONSENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CONSENT_STATUS_GIVEN', '2': 1},
    {'1': 'CONSENT_STATUS_REFUSED', '2': 2},
    {'1': 'CONSENT_STATUS_WITHDRAWN', '2': 3},
    {'1': 'CONSENT_STATUS_EXPIRED', '2': 4},
  ],
};

/// Descriptor for `ConsentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consentStatusDescriptor = $convert.base64Decode(
    'Cg1Db25zZW50U3RhdHVzEh4KGkNPTlNFTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUQ09OU0'
    'VOVF9TVEFUVVNfR0lWRU4QARIaChZDT05TRU5UX1NUQVRVU19SRUZVU0VEEAISHAoYQ09OU0VO'
    'VF9TVEFUVVNfV0lUSERSQVdOEAMSGgoWQ09OU0VOVF9TVEFUVVNfRVhQSVJFRBAE');

@$core.Deprecated('Use consentGiverDescriptor instead')
const ConsentGiver$json = {
  '1': 'ConsentGiver',
  '2': [
    {'1': 'CONSENT_GIVER_UNSPECIFIED', '2': 0},
    {'1': 'CONSENT_GIVER_PATIENT', '2': 1},
    {'1': 'CONSENT_GIVER_PARENT', '2': 2},
    {'1': 'CONSENT_GIVER_LEGAL_GUARDIAN', '2': 3},
    {'1': 'CONSENT_GIVER_REPRESENTATIVE', '2': 4},
  ],
};

/// Descriptor for `ConsentGiver`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consentGiverDescriptor = $convert.base64Decode(
    'CgxDb25zZW50R2l2ZXISHQoZQ09OU0VOVF9HSVZFUl9VTlNQRUNJRklFRBAAEhkKFUNPTlNFTl'
    'RfR0lWRVJfUEFUSUVOVBABEhgKFENPTlNFTlRfR0lWRVJfUEFSRU5UEAISIAocQ09OU0VOVF9H'
    'SVZFUl9MRUdBTF9HVUFSRElBThADEiAKHENPTlNFTlRfR0lWRVJfUkVQUkVTRU5UQVRJVkUQBA'
    '==');

@$core.Deprecated('Use alertLevelDescriptor instead')
const AlertLevel$json = {
  '1': 'AlertLevel',
  '2': [
    {'1': 'ALERT_LEVEL_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_LEVEL_HARD', '2': 1},
    {'1': 'ALERT_LEVEL_SOFT', '2': 2},
    {'1': 'ALERT_LEVEL_INFO', '2': 3},
  ],
};

/// Descriptor for `AlertLevel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertLevelDescriptor = $convert.base64Decode(
    'CgpBbGVydExldmVsEhsKF0FMRVJUX0xFVkVMX1VOU1BFQ0lGSUVEEAASFAoQQUxFUlRfTEVWRU'
    'xfSEFSRBABEhQKEEFMRVJUX0xFVkVMX1NPRlQQAhIUChBBTEVSVF9MRVZFTF9JTkZPEAM=');

@$core.Deprecated('Use alertOutcomeDescriptor instead')
const AlertOutcome$json = {
  '1': 'AlertOutcome',
  '2': [
    {'1': 'ALERT_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'ALERT_OUTCOME_PENDING', '2': 1},
    {'1': 'ALERT_OUTCOME_ACCEPTED', '2': 2},
    {'1': 'ALERT_OUTCOME_OVERRIDDEN', '2': 3},
    {'1': 'ALERT_OUTCOME_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `AlertOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List alertOutcomeDescriptor = $convert.base64Decode(
    'CgxBbGVydE91dGNvbWUSHQoZQUxFUlRfT1VUQ09NRV9VTlNQRUNJRklFRBAAEhkKFUFMRVJUX0'
    '9VVENPTUVfUEVORElORxABEhoKFkFMRVJUX09VVENPTUVfQUNDRVBURUQQAhIcChhBTEVSVF9P'
    'VVRDT01FX09WRVJSSURERU4QAxIgChxBTEVSVF9PVVRDT01FX05PVF9BUFBMSUNBQkxFEAQ=');

@$core.Deprecated('Use consultUrgencyDescriptor instead')
const ConsultUrgency$json = {
  '1': 'ConsultUrgency',
  '2': [
    {'1': 'CONSULT_URGENCY_UNSPECIFIED', '2': 0},
    {'1': 'CONSULT_URGENCY_EMERGENCY', '2': 1},
    {'1': 'CONSULT_URGENCY_URGENT', '2': 2},
    {'1': 'CONSULT_URGENCY_ROUTINE', '2': 3},
  ],
};

/// Descriptor for `ConsultUrgency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consultUrgencyDescriptor = $convert.base64Decode(
    'Cg5Db25zdWx0VXJnZW5jeRIfChtDT05TVUxUX1VSR0VOQ1lfVU5TUEVDSUZJRUQQABIdChlDT0'
    '5TVUxUX1VSR0VOQ1lfRU1FUkdFTkNZEAESGgoWQ09OU1VMVF9VUkdFTkNZX1VSR0VOVBACEhsK'
    'F0NPTlNVTFRfVVJHRU5DWV9ST1VUSU5FEAM=');

@$core.Deprecated('Use consultStatusDescriptor instead')
const ConsultStatus$json = {
  '1': 'ConsultStatus',
  '2': [
    {'1': 'CONSULT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'CONSULT_STATUS_REQUESTED', '2': 1},
    {'1': 'CONSULT_STATUS_ACCEPTED', '2': 2},
    {'1': 'CONSULT_STATUS_ANSWERED', '2': 3},
    {'1': 'CONSULT_STATUS_DECLINED', '2': 4},
    {'1': 'CONSULT_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `ConsultStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consultStatusDescriptor = $convert.base64Decode(
    'Cg1Db25zdWx0U3RhdHVzEh4KGkNPTlNVTFRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASHAoYQ09OU1'
    'VMVF9TVEFUVVNfUkVRVUVTVEVEEAESGwoXQ09OU1VMVF9TVEFUVVNfQUNDRVBURUQQAhIbChdD'
    'T05TVUxUX1NUQVRVU19BTlNXRVJFRBADEhsKF0NPTlNVTFRfU1RBVFVTX0RFQ0xJTkVEEAQSHA'
    'oYQ09OU1VMVF9TVEFUVVNfQ0FOQ0VMTEVEEAU=');

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

@$core.Deprecated('Use patientContextDescriptor instead')
const PatientContext$json = {
  '1': 'PatientContext',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'opened_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
  ],
};

/// Descriptor for `PatientContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientContextDescriptor = $convert.base64Decode(
    'Cg5QYXRpZW50Q29udGV4dBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQoMZW5jb3'
    'VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBI3CglvcGVuZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUghvcGVuZWRBdA==');

@$core.Deprecated('Use sectionDescriptor instead')
const Section$json = {
  '1': 'Section',
  '2': [
    {'1': 'heading', '3': 1, '4': 1, '5': 9, '10': 'heading'},
    {'1': 'text', '3': 2, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `Section`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectionDescriptor = $convert.base64Decode(
    'CgdTZWN0aW9uEhgKB2hlYWRpbmcYASABKAlSB2hlYWRpbmcSEgoEdGV4dBgCIAEoCVIEdGV4dA'
    '==');

@$core.Deprecated('Use signatureDescriptor instead')
const Signature$json = {
  '1': 'Signature',
  '2': [
    {'1': 'signature_id', '3': 1, '4': 1, '5': 9, '10': 'signatureId'},
    {'1': 'subject_id', '3': 2, '4': 1, '5': 9, '10': 'subjectId'},
    {
      '1': 'meaning',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.SignatureMeaning',
      '10': 'meaning'
    },
    {
      '1': 'signed_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedAt'
    },
    {'1': 'content_hash', '3': 5, '4': 1, '5': 9, '10': 'contentHash'},
    {'1': 'template_version', '3': 6, '4': 1, '5': 9, '10': 'templateVersion'},
  ],
};

/// Descriptor for `Signature`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signatureDescriptor = $convert.base64Decode(
    'CglTaWduYXR1cmUSIQoMc2lnbmF0dXJlX2lkGAEgASgJUgtzaWduYXR1cmVJZBIdCgpzdWJqZW'
    'N0X2lkGAIgASgJUglzdWJqZWN0SWQSQgoHbWVhbmluZxgDIAEoDjIoLmhlYWx0aGNhcmUuY2xp'
    'bmljYWwudjEuU2lnbmF0dXJlTWVhbmluZ1IHbWVhbmluZxI3CglzaWduZWRfYXQYBCABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzaWduZWRBdBIhCgxjb250ZW50X2hhc2gYBSAB'
    'KAlSC2NvbnRlbnRIYXNoEikKEHRlbXBsYXRlX3ZlcnNpb24YBiABKAlSD3RlbXBsYXRlVmVyc2'
    'lvbg==');

@$core.Deprecated('Use documentDescriptor instead')
const Document$json = {
  '1': 'Document',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'template_id', '3': 5, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'template_version', '3': 6, '4': 1, '5': 9, '10': 'templateVersion'},
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'sections',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Section',
      '10': 'sections'
    },
    {
      '1': 'status',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentStatus',
      '10': 'status'
    },
    {
      '1': 'confidentiality',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {'1': 'amends_id', '3': 11, '4': 1, '5': 9, '10': 'amendsId'},
    {'1': 'adds_to_id', '3': 12, '4': 1, '5': 9, '10': 'addsToId'},
    {'1': 'change_reason', '3': 13, '4': 1, '5': 9, '10': 'changeReason'},
    {
      '1': 'retraction_reason',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'retractionReason'
    },
    {'1': 'dictated', '3': 15, '4': 1, '5': 8, '10': 'dictated'},
    {
      '1': 'signatures',
      '3': 16,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Signature',
      '10': 'signatures'
    },
    {'1': 'authored_by', '3': 17, '4': 1, '5': 9, '10': 'authoredBy'},
    {
      '1': 'created_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
    {'1': 'intact', '3': 21, '4': 1, '5': 8, '10': 'intact'},
  ],
};

/// Descriptor for `Document`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List documentDescriptor = $convert.base64Decode(
    'CghEb2N1bWVudBIfCgtkb2N1bWVudF9pZBgBIAEoCVIKZG9jdW1lbnRJZBIdCgpwYXRpZW50X2'
    'lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBI4'
    'CgRraW5kGAQgASgOMiQuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Eb2N1bWVudEtpbmRSBGtpbm'
    'QSHwoLdGVtcGxhdGVfaWQYBSABKAlSCnRlbXBsYXRlSWQSKQoQdGVtcGxhdGVfdmVyc2lvbhgG'
    'IAEoCVIPdGVtcGxhdGVWZXJzaW9uEhQKBXRpdGxlGAcgASgJUgV0aXRsZRI7CghzZWN0aW9ucx'
    'gIIAMoCzIfLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuU2VjdGlvblIIc2VjdGlvbnMSPgoGc3Rh'
    'dHVzGAkgASgOMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Eb2N1bWVudFN0YXR1c1IGc3RhdH'
    'VzElEKD2NvbmZpZGVudGlhbGl0eRgKIAEoDjInLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQ29u'
    'ZmlkZW50aWFsaXR5Ug9jb25maWRlbnRpYWxpdHkSGwoJYW1lbmRzX2lkGAsgASgJUghhbWVuZH'
    'NJZBIcCgphZGRzX3RvX2lkGAwgASgJUghhZGRzVG9JZBIjCg1jaGFuZ2VfcmVhc29uGA0gASgJ'
    'UgxjaGFuZ2VSZWFzb24SKwoRcmV0cmFjdGlvbl9yZWFzb24YDiABKAlSEHJldHJhY3Rpb25SZW'
    'Fzb24SGgoIZGljdGF0ZWQYDyABKAhSCGRpY3RhdGVkEkEKCnNpZ25hdHVyZXMYECADKAsyIS5o'
    'ZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlNpZ25hdHVyZVIKc2lnbmF0dXJlcxIfCgthdXRob3JlZF'
    '9ieRgRIAEoCVIKYXV0aG9yZWRCeRI5CgpjcmVhdGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYEyABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgUIAEoA1IHdmVyc2lvbhIW'
    'CgZpbnRhY3QYFSABKAhSBmludGFjdA==');

@$core.Deprecated('Use templateDescriptor instead')
const Template$json = {
  '1': 'Template',
  '2': [
    {'1': 'template_id', '3': 1, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'specialty', '3': 5, '4': 1, '5': 9, '10': 'specialty'},
    {'1': 'sections', '3': 6, '4': 3, '5': 9, '10': 'sections'},
    {'1': 'retired', '3': 7, '4': 1, '5': 8, '10': 'retired'},
  ],
};

/// Descriptor for `Template`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateDescriptor = $convert.base64Decode(
    'CghUZW1wbGF0ZRIfCgt0ZW1wbGF0ZV9pZBgBIAEoCVIKdGVtcGxhdGVJZBISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEhgKB3ZlcnNpb24YAyABKAlSB3ZlcnNpb24SOAoEa2luZBgEIAEoDjIkLmhlYWx0'
    'aGNhcmUuY2xpbmljYWwudjEuRG9jdW1lbnRLaW5kUgRraW5kEhwKCXNwZWNpYWx0eRgFIAEoCV'
    'IJc3BlY2lhbHR5EhoKCHNlY3Rpb25zGAYgAygJUghzZWN0aW9ucxIYCgdyZXRpcmVkGAcgASgI'
    'UgdyZXRpcmVk');

@$core.Deprecated('Use problemDescriptor instead')
const Problem$json = {
  '1': 'Problem',
  '2': [
    {'1': 'problem_id', '3': 1, '4': 1, '5': 9, '10': 'problemId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ProblemStatus',
      '10': 'status'
    },
    {
      '1': 'onset_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {
      '1': 'resolved_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {
      '1': 'confidentiality',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {'1': 'recorded_by', '3': 10, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Problem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List problemDescriptor = $convert.base64Decode(
    'CgdQcm9ibGVtEh0KCnByb2JsZW1faWQYASABKAlSCXByb2JsZW1JZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIyCgRj'
    'b2RlGAQgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2RpbmdSBGNvZGUSEgoEbm90ZR'
    'gFIAEoCVIEbm90ZRI9CgZzdGF0dXMYBiABKA4yJS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlBy'
    'b2JsZW1TdGF0dXNSBnN0YXR1cxI1CghvbnNldF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSB29uc2V0QXQSOwoLcmVzb2x2ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgpyZXNvbHZlZEF0ElEKD2NvbmZpZGVudGlhbGl0eRgJIAEoDjInLmhlYW'
    'x0aGNhcmUuY2xpbmljYWwudjEuQ29uZmlkZW50aWFsaXR5Ug9jb25maWRlbnRpYWxpdHkSHwoL'
    'cmVjb3JkZWRfYnkYCiABKAlSCnJlY29yZGVkQnkSOwoLcmVjb3JkZWRfYXQYCyABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0EhgKB3ZlcnNpb24YDCABKANSB3Zl'
    'cnNpb24=');

@$core.Deprecated('Use reactionDescriptor instead')
const Reaction$json = {
  '1': 'Reaction',
  '2': [
    {
      '1': 'manifestation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'manifestation'
    },
    {'1': 'severity', '3': 2, '4': 1, '5': 9, '10': 'severity'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Reaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactionDescriptor = $convert.base64Decode(
    'CghSZWFjdGlvbhJECg1tYW5pZmVzdGF0aW9uGAEgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC'
    '52MS5Db2RpbmdSDW1hbmlmZXN0YXRpb24SGgoIc2V2ZXJpdHkYAiABKAlSCHNldmVyaXR5EhIK'
    'BG5vdGUYAyABKAlSBG5vdGU=');

@$core.Deprecated('Use allergyDescriptor instead')
const Allergy$json = {
  '1': 'Allergy',
  '2': [
    {'1': 'allergy_id', '3': 1, '4': 1, '5': 9, '10': 'allergyId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'substance',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'substance'
    },
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyKind',
      '10': 'kind'
    },
    {
      '1': 'criticality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyCriticality',
      '10': 'criticality'
    },
    {
      '1': 'verification',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyVerification',
      '10': 'verification'
    },
    {
      '1': 'reactions',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Reaction',
      '10': 'reactions'
    },
    {
      '1': 'onset_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'note', '3': 10, '4': 1, '5': 9, '10': 'note'},
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'version', '3': 13, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Allergy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List allergyDescriptor = $convert.base64Decode(
    'CgdBbGxlcmd5Eh0KCmFsbGVyZ3lfaWQYASABKAlSCWFsbGVyZ3lJZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBI8Cglz'
    'dWJzdGFuY2UYBCABKAsyHi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvZGluZ1IJc3Vic3Rhbm'
    'NlEjcKBGtpbmQYBSABKA4yIy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkFsbGVyZ3lLaW5kUgRr'
    'aW5kEkwKC2NyaXRpY2FsaXR5GAYgASgOMiouaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BbGxlcm'
    'd5Q3JpdGljYWxpdHlSC2NyaXRpY2FsaXR5Ek8KDHZlcmlmaWNhdGlvbhgHIAEoDjIrLmhlYWx0'
    'aGNhcmUuY2xpbmljYWwudjEuQWxsZXJneVZlcmlmaWNhdGlvblIMdmVyaWZpY2F0aW9uEj4KCX'
    'JlYWN0aW9ucxgIIAMoCzIgLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuUmVhY3Rpb25SCXJlYWN0'
    'aW9ucxI1CghvbnNldF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB29uc2'
    'V0QXQSEgoEbm90ZRgKIAEoCVIEbm90ZRIfCgtyZWNvcmRlZF9ieRgLIAEoCVIKcmVjb3JkZWRC'
    'eRI7CgtyZWNvcmRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY2'
    '9yZGVkQXQSGAoHdmVyc2lvbhgNIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use quantityDescriptor instead')
const Quantity$json = {
  '1': 'Quantity',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 2, '4': 1, '5': 9, '10': 'unit'},
  ],
};

/// Descriptor for `Quantity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List quantityDescriptor = $convert.base64Decode(
    'CghRdWFudGl0eRIUCgV2YWx1ZRgBIAEoAVIFdmFsdWUSEgoEdW5pdBgCIAEoCVIEdW5pdA==');

@$core.Deprecated('Use observationDescriptor instead')
const Observation$json = {
  '1': 'Observation',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'value',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Quantity',
      '10': 'value'
    },
    {'1': 'text_value', '3': 6, '4': 1, '5': 9, '10': 'textValue'},
    {
      '1': 'coded_value',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'codedValue'
    },
    {'1': 'reference_low', '3': 8, '4': 1, '5': 1, '10': 'referenceLow'},
    {'1': 'reference_high', '3': 9, '4': 1, '5': 1, '10': 'referenceHigh'},
    {
      '1': 'has_reference_range',
      '3': 10,
      '4': 1,
      '5': 8,
      '10': 'hasReferenceRange'
    },
    {'1': 'reference_text', '3': 11, '4': 1, '5': 9, '10': 'referenceText'},
    {
      '1': 'interpretation',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Interpretation',
      '10': 'interpretation'
    },
    {
      '1': 'interpretation_source',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'interpretationSource'
    },
    {
      '1': 'status',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ObservationStatus',
      '10': 'status'
    },
    {
      '1': 'effective_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'issued_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'performer_id', '3': 17, '4': 1, '5': 9, '10': 'performerId'},
    {'1': 'device_id', '3': 18, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'source_system', '3': 19, '4': 1, '5': 9, '10': 'sourceSystem'},
    {'1': 'note', '3': 20, '4': 1, '5': 9, '10': 'note'},
    {'1': 'amends_id', '3': 21, '4': 1, '5': 9, '10': 'amendsId'},
    {'1': 'recorded_by', '3': 22, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `Observation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationDescriptor = $convert.base64Decode(
    'CgtPYnNlcnZhdGlvbhIlCg5vYnNlcnZhdGlvbl9pZBgBIAEoCVINb2JzZXJ2YXRpb25JZBIdCg'
    'pwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNv'
    'dW50ZXJJZBIyCgRjb2RlGAQgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2RpbmdSBG'
    'NvZGUSNgoFdmFsdWUYBSABKAsyIC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlF1YW50aXR5UgV2'
    'YWx1ZRIdCgp0ZXh0X3ZhbHVlGAYgASgJUgl0ZXh0VmFsdWUSPwoLY29kZWRfdmFsdWUYByABKA'
    'syHi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvZGluZ1IKY29kZWRWYWx1ZRIjCg1yZWZlcmVu'
    'Y2VfbG93GAggASgBUgxyZWZlcmVuY2VMb3cSJQoOcmVmZXJlbmNlX2hpZ2gYCSABKAFSDXJlZm'
    'VyZW5jZUhpZ2gSLgoTaGFzX3JlZmVyZW5jZV9yYW5nZRgKIAEoCFIRaGFzUmVmZXJlbmNlUmFu'
    'Z2USJQoOcmVmZXJlbmNlX3RleHQYCyABKAlSDXJlZmVyZW5jZVRleHQSTgoOaW50ZXJwcmV0YX'
    'Rpb24YDCABKA4yJi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkludGVycHJldGF0aW9uUg5pbnRl'
    'cnByZXRhdGlvbhIzChVpbnRlcnByZXRhdGlvbl9zb3VyY2UYDSABKAlSFGludGVycHJldGF0aW'
    '9uU291cmNlEkEKBnN0YXR1cxgOIAEoDjIpLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuT2JzZXJ2'
    'YXRpb25TdGF0dXNSBnN0YXR1cxI9CgxlZmZlY3RpdmVfYXQYDyABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgtlZmZlY3RpdmVBdBI3Cglpc3N1ZWRfYXQYECABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUghpc3N1ZWRBdBIhCgxwZXJmb3JtZXJfaWQYESABKAlSC3Blcm'
    'Zvcm1lcklkEhsKCWRldmljZV9pZBgSIAEoCVIIZGV2aWNlSWQSIwoNc291cmNlX3N5c3RlbRgT'
    'IAEoCVIMc291cmNlU3lzdGVtEhIKBG5vdGUYFCABKAlSBG5vdGUSGwoJYW1lbmRzX2lkGBUgAS'
    'gJUghhbWVuZHNJZBIfCgtyZWNvcmRlZF9ieRgWIAEoCVIKcmVjb3JkZWRCeRI7CgtyZWNvcmRl'
    'ZF9hdBgXIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQ=');

@$core.Deprecated('Use criticalAcknowledgementDescriptor instead')
const CriticalAcknowledgement$json = {
  '1': 'CriticalAcknowledgement',
  '2': [
    {
      '1': 'acknowledgement_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'acknowledgementId'
    },
    {'1': 'observation_id', '3': 2, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'acknowledged_by', '3': 4, '4': 1, '5': 9, '10': 'acknowledgedBy'},
    {
      '1': 'acknowledged_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
    {
      '1': 'notified_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notifiedAt'
    },
    {'1': 'delay_seconds', '3': 8, '4': 1, '5': 3, '10': 'delaySeconds'},
  ],
};

/// Descriptor for `CriticalAcknowledgement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List criticalAcknowledgementDescriptor = $convert.base64Decode(
    'ChdDcml0aWNhbEFja25vd2xlZGdlbWVudBItChJhY2tub3dsZWRnZW1lbnRfaWQYASABKAlSEW'
    'Fja25vd2xlZGdlbWVudElkEiUKDm9ic2VydmF0aW9uX2lkGAIgASgJUg1vYnNlcnZhdGlvbklk'
    'Eh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBInCg9hY2tub3dsZWRnZWRfYnkYBCABKA'
    'lSDmFja25vd2xlZGdlZEJ5EkMKD2Fja25vd2xlZGdlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSDmFja25vd2xlZGdlZEF0EhYKBmFjdGlvbhgGIAEoCVIGYWN0aW9uEj'
    'sKC25vdGlmaWVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKbm90aWZp'
    'ZWRBdBIjCg1kZWxheV9zZWNvbmRzGAggASgDUgxkZWxheVNlY29uZHM=');

@$core.Deprecated('Use performerDescriptor instead')
const Performer$json = {
  '1': 'Performer',
  '2': [
    {'1': 'subject_id', '3': 1, '4': 1, '5': 9, '10': 'subjectId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `Performer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List performerDescriptor = $convert.base64Decode(
    'CglQZXJmb3JtZXISHQoKc3ViamVjdF9pZBgBIAEoCVIJc3ViamVjdElkEhIKBHJvbGUYAiABKA'
    'lSBHJvbGU=');

@$core.Deprecated('Use procedureDescriptor instead')
const Procedure$json = {
  '1': 'Procedure',
  '2': [
    {'1': 'procedure_id', '3': 1, '4': 1, '5': 9, '10': 'procedureId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ProcedureStatus',
      '10': 'status'
    },
    {
      '1': 'indication',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'indication'
    },
    {
      '1': 'performers',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Performer',
      '10': 'performers'
    },
    {
      '1': 'body_site',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'bodySite'
    },
    {
      '1': 'laterality',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'outcome', '3': 10, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'complications',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'complications'
    },
    {'1': 'order_ids', '3': 12, '4': 3, '5': 9, '10': 'orderIds'},
    {'1': 'device_ids', '3': 13, '4': 3, '5': 9, '10': 'deviceIds'},
    {'1': 'specimen_ids', '3': 14, '4': 3, '5': 9, '10': 'specimenIds'},
    {
      '1': 'performed_start',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedStart'
    },
    {
      '1': 'performed_end',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedEnd'
    },
    {'1': 'note', '3': 17, '4': 1, '5': 9, '10': 'note'},
    {'1': 'recorded_by', '3': 18, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
  ],
};

/// Descriptor for `Procedure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List procedureDescriptor = $convert.base64Decode(
    'CglQcm9jZWR1cmUSIQoMcHJvY2VkdXJlX2lkGAEgASgJUgtwcm9jZWR1cmVJZBIdCgpwYXRpZW'
    '50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJ'
    'ZBIyCgRjb2RlGAQgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2RpbmdSBGNvZGUSPw'
    'oGc3RhdHVzGAUgASgOMicuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Qcm9jZWR1cmVTdGF0dXNS'
    'BnN0YXR1cxI+CgppbmRpY2F0aW9uGAYgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2'
    'RpbmdSCmluZGljYXRpb24SQQoKcGVyZm9ybWVycxgHIAMoCzIhLmhlYWx0aGNhcmUuY2xpbmlj'
    'YWwudjEuUGVyZm9ybWVyUgpwZXJmb3JtZXJzEjsKCWJvZHlfc2l0ZRgIIAEoCzIeLmhlYWx0aG'
    'NhcmUuY2xpbmljYWwudjEuQ29kaW5nUghib2R5U2l0ZRJCCgpsYXRlcmFsaXR5GAkgASgOMiIu'
    'aGVhbHRoY2FyZS5jbGluaWNhbC52MS5MYXRlcmFsaXR5UgpsYXRlcmFsaXR5EhgKB291dGNvbW'
    'UYCiABKAlSB291dGNvbWUSRAoNY29tcGxpY2F0aW9ucxgLIAMoCzIeLmhlYWx0aGNhcmUuY2xp'
    'bmljYWwudjEuQ29kaW5nUg1jb21wbGljYXRpb25zEhsKCW9yZGVyX2lkcxgMIAMoCVIIb3JkZX'
    'JJZHMSHQoKZGV2aWNlX2lkcxgNIAMoCVIJZGV2aWNlSWRzEiEKDHNwZWNpbWVuX2lkcxgOIAMo'
    'CVILc3BlY2ltZW5JZHMSQwoPcGVyZm9ybWVkX3N0YXJ0GA8gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIOcGVyZm9ybWVkU3RhcnQSPwoNcGVyZm9ybWVkX2VuZBgQIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHBlcmZvcm1lZEVuZBISCgRub3RlGBEgASgJUgRub3'
    'RlEh8KC3JlY29yZGVkX2J5GBIgASgJUgpyZWNvcmRlZEJ5EjsKC3JlY29yZGVkX2F0GBMgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdA==');

@$core.Deprecated('Use goalDescriptor instead')
const Goal$json = {
  '1': 'Goal',
  '2': [
    {'1': 'goal_id', '3': 1, '4': 1, '5': 9, '10': 'goalId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.GoalStatus',
      '10': 'status'
    },
    {
      '1': 'target_date',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'targetDate'
    },
    {
      '1': 'achieved_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'achievedAt'
    },
  ],
};

/// Descriptor for `Goal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List goalDescriptor = $convert.base64Decode(
    'CgRHb2FsEhcKB2dvYWxfaWQYASABKAlSBmdvYWxJZBIgCgtkZXNjcmlwdGlvbhgCIAEoCVILZG'
    'VzY3JpcHRpb24SOgoGc3RhdHVzGAMgASgOMiIuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Hb2Fs'
    'U3RhdHVzUgZzdGF0dXMSOwoLdGFyZ2V0X2RhdGUYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgp0YXJnZXREYXRlEjsKC2FjaGlldmVkX2F0GAUgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIKYWNoaWV2ZWRBdA==');

@$core.Deprecated('Use activityDescriptor instead')
const Activity$json = {
  '1': 'Activity',
  '2': [
    {'1': 'activity_id', '3': 1, '4': 1, '5': 9, '10': 'activityId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ActivityStatus',
      '10': 'status'
    },
    {
      '1': 'scheduled_for',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledFor'
    },
    {'1': 'task_id', '3': 6, '4': 1, '5': 9, '10': 'taskId'},
  ],
};

/// Descriptor for `Activity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activityDescriptor = $convert.base64Decode(
    'CghBY3Rpdml0eRIfCgthY3Rpdml0eV9pZBgBIAEoCVIKYWN0aXZpdHlJZBIgCgtkZXNjcmlwdG'
    'lvbhgCIAEoCVILZGVzY3JpcHRpb24SGQoIb3duZXJfaWQYAyABKAlSB293bmVySWQSPgoGc3Rh'
    'dHVzGAQgASgOMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BY3Rpdml0eVN0YXR1c1IGc3RhdH'
    'VzEj8KDXNjaGVkdWxlZF9mb3IYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxz'
    'Y2hlZHVsZWRGb3ISFwoHdGFza19pZBgGIAEoCVIGdGFza0lk');

@$core.Deprecated('Use carePlanDescriptor instead')
const CarePlan$json = {
  '1': 'CarePlan',
  '2': [
    {'1': 'care_plan_id', '3': 1, '4': 1, '5': 9, '10': 'carePlanId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.CarePlanStatus',
      '10': 'status'
    },
    {'1': 'problem_ids', '3': 6, '4': 3, '5': 9, '10': 'problemIds'},
    {
      '1': 'goals',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Goal',
      '10': 'goals'
    },
    {
      '1': 'activities',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Activity',
      '10': 'activities'
    },
    {'1': 'owner_id', '3': 9, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'starts_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CarePlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List carePlanDescriptor = $convert.base64Decode(
    'CghDYXJlUGxhbhIgCgxjYXJlX3BsYW5faWQYASABKAlSCmNhcmVQbGFuSWQSHQoKcGF0aWVudF'
    '9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQS'
    'FAoFdGl0bGUYBCABKAlSBXRpdGxlEj4KBnN0YXR1cxgFIAEoDjImLmhlYWx0aGNhcmUuY2xpbm'
    'ljYWwudjEuQ2FyZVBsYW5TdGF0dXNSBnN0YXR1cxIfCgtwcm9ibGVtX2lkcxgGIAMoCVIKcHJv'
    'YmxlbUlkcxIyCgVnb2FscxgHIAMoCzIcLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuR29hbFIFZ2'
    '9hbHMSQAoKYWN0aXZpdGllcxgIIAMoCzIgLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWN0aXZp'
    'dHlSCmFjdGl2aXRpZXMSGQoIb3duZXJfaWQYCSABKAlSB293bmVySWQSNwoJc3RhcnRzX2F0GA'
    'ogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSMwoHZW5kc19hdBgL'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmVuZHNBdBIYCgd2ZXJzaW9uGAwgAS'
    'gDUgd2ZXJzaW9u');

@$core.Deprecated('Use provenanceDescriptor instead')
const Provenance$json = {
  '1': 'Provenance',
  '2': [
    {'1': 'provenance_id', '3': 1, '4': 1, '5': 9, '10': 'provenanceId'},
    {'1': 'record_type', '3': 2, '4': 1, '5': 9, '10': 'recordType'},
    {'1': 'record_id', '3': 3, '4': 1, '5': 9, '10': 'recordId'},
    {
      '1': 'source_organization',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'sourceOrganization'
    },
    {'1': 'source_system', '3': 5, '4': 1, '5': 9, '10': 'sourceSystem'},
    {'1': 'source_record_id', '3': 6, '4': 1, '5': 9, '10': 'sourceRecordId'},
    {
      '1': 'ingested_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'ingestedAt'
    },
    {
      '1': 'authored_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'authoredAt'
    },
    {'1': 'authored_by', '3': 9, '4': 1, '5': 9, '10': 'authoredBy'},
    {'1': 'assertion', '3': 10, '4': 1, '5': 9, '10': 'assertion'},
  ],
};

/// Descriptor for `Provenance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provenanceDescriptor = $convert.base64Decode(
    'CgpQcm92ZW5hbmNlEiMKDXByb3ZlbmFuY2VfaWQYASABKAlSDHByb3ZlbmFuY2VJZBIfCgtyZW'
    'NvcmRfdHlwZRgCIAEoCVIKcmVjb3JkVHlwZRIbCglyZWNvcmRfaWQYAyABKAlSCHJlY29yZElk'
    'Ei8KE3NvdXJjZV9vcmdhbml6YXRpb24YBCABKAlSEnNvdXJjZU9yZ2FuaXphdGlvbhIjCg1zb3'
    'VyY2Vfc3lzdGVtGAUgASgJUgxzb3VyY2VTeXN0ZW0SKAoQc291cmNlX3JlY29yZF9pZBgGIAEo'
    'CVIOc291cmNlUmVjb3JkSWQSOwoLaW5nZXN0ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgppbmdlc3RlZEF0EjsKC2F1dGhvcmVkX2F0GAggASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIKYXV0aG9yZWRBdBIfCgthdXRob3JlZF9ieRgJIAEoCVIKYXV0aG'
    '9yZWRCeRIcCglhc3NlcnRpb24YCiABKAlSCWFzc2VydGlvbg==');

@$core.Deprecated('Use attachmentDescriptor instead')
const Attachment$json = {
  '1': 'Attachment',
  '2': [
    {'1': 'attachment_id', '3': 1, '4': 1, '5': 9, '10': 'attachmentId'},
    {'1': 'parent_type', '3': 2, '4': 1, '5': 9, '10': 'parentType'},
    {'1': 'parent_id', '3': 3, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AttachmentKind',
      '10': 'kind'
    },
    {'1': 'content_type', '3': 6, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'storage_key', '3': 7, '4': 1, '5': 9, '10': 'storageKey'},
    {'1': 'size_bytes', '3': 8, '4': 1, '5': 3, '10': 'sizeBytes'},
    {'1': 'digest', '3': 9, '4': 1, '5': 9, '10': 'digest'},
    {'1': 'description', '3': 10, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'confidentiality',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {
      '1': 'captured_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {'1': 'source_system', '3': 13, '4': 1, '5': 9, '10': 'sourceSystem'},
    {'1': 'uploaded_by', '3': 14, '4': 1, '5': 9, '10': 'uploadedBy'},
    {
      '1': 'uploaded_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'uploadedAt'
    },
  ],
};

/// Descriptor for `Attachment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachmentDescriptor = $convert.base64Decode(
    'CgpBdHRhY2htZW50EiMKDWF0dGFjaG1lbnRfaWQYASABKAlSDGF0dGFjaG1lbnRJZBIfCgtwYX'
    'JlbnRfdHlwZRgCIAEoCVIKcGFyZW50VHlwZRIbCglwYXJlbnRfaWQYAyABKAlSCHBhcmVudElk'
    'Eh0KCnBhdGllbnRfaWQYBCABKAlSCXBhdGllbnRJZBI6CgRraW5kGAUgASgOMiYuaGVhbHRoY2'
    'FyZS5jbGluaWNhbC52MS5BdHRhY2htZW50S2luZFIEa2luZBIhCgxjb250ZW50X3R5cGUYBiAB'
    'KAlSC2NvbnRlbnRUeXBlEh8KC3N0b3JhZ2Vfa2V5GAcgASgJUgpzdG9yYWdlS2V5Eh0KCnNpem'
    'VfYnl0ZXMYCCABKANSCXNpemVCeXRlcxIWCgZkaWdlc3QYCSABKAlSBmRpZ2VzdBIgCgtkZXNj'
    'cmlwdGlvbhgKIAEoCVILZGVzY3JpcHRpb24SUQoPY29uZmlkZW50aWFsaXR5GAsgASgOMicuaG'
    'VhbHRoY2FyZS5jbGluaWNhbC52MS5Db25maWRlbnRpYWxpdHlSD2NvbmZpZGVudGlhbGl0eRI7'
    'CgtjYXB0dXJlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNhcHR1cm'
    'VkQXQSIwoNc291cmNlX3N5c3RlbRgNIAEoCVIMc291cmNlU3lzdGVtEh8KC3VwbG9hZGVkX2J5'
    'GA4gASgJUgp1cGxvYWRlZEJ5EjsKC3VwbG9hZGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIKdXBsb2FkZWRBdA==');

@$core.Deprecated('Use clinicalConsentDescriptor instead')
const ClinicalConsent$json = {
  '1': 'ClinicalConsent',
  '2': [
    {'1': 'consent_id', '3': 1, '4': 1, '5': 9, '10': 'consentId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentKind',
      '10': 'kind'
    },
    {
      '1': 'procedure_code',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'procedureCode'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentStatus',
      '10': 'status'
    },
    {
      '1': 'given_by',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentGiver',
      '10': 'givenBy'
    },
    {'1': 'given_by_name', '3': 8, '4': 1, '5': 9, '10': 'givenByName'},
    {'1': 'document_id', '3': 9, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'witness_id', '3': 10, '4': 1, '5': 9, '10': 'witnessId'},
    {
      '1': 'valid_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {'1': 'note', '3': 13, '4': 1, '5': 9, '10': 'note'},
    {'1': 'recorded_by', '3': 14, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `ClinicalConsent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clinicalConsentDescriptor = $convert.base64Decode(
    'Cg9DbGluaWNhbENvbnNlbnQSHQoKY29uc2VudF9pZBgBIAEoCVIJY29uc2VudElkEh0KCnBhdG'
    'llbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYAyABKAlSC2VuY291bnRl'
    'cklkEjcKBGtpbmQYBCABKA4yIy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvbnNlbnRLaW5kUg'
    'RraW5kEkUKDnByb2NlZHVyZV9jb2RlGAUgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5D'
    'b2RpbmdSDXByb2NlZHVyZUNvZGUSPQoGc3RhdHVzGAYgASgOMiUuaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5Db25zZW50U3RhdHVzUgZzdGF0dXMSPwoIZ2l2ZW5fYnkYByABKA4yJC5oZWFsdGhj'
    'YXJlLmNsaW5pY2FsLnYxLkNvbnNlbnRHaXZlclIHZ2l2ZW5CeRIiCg1naXZlbl9ieV9uYW1lGA'
    'ggASgJUgtnaXZlbkJ5TmFtZRIfCgtkb2N1bWVudF9pZBgJIAEoCVIKZG9jdW1lbnRJZBIdCgp3'
    'aXRuZXNzX2lkGAogASgJUgl3aXRuZXNzSWQSOQoKdmFsaWRfZnJvbRgLIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCXZhbGlkRnJvbRI7Cgt2YWxpZF91bnRpbBgMIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnZhbGlkVW50aWwSEgoEbm90ZRgNIAEoCVIEbm90ZR'
    'IfCgtyZWNvcmRlZF9ieRgOIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use calculatorInputDescriptor instead')
const CalculatorInput$json = {
  '1': 'CalculatorInput',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'unit', '3': 3, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'source_id', '3': 4, '4': 1, '5': 9, '10': 'sourceId'},
  ],
};

/// Descriptor for `CalculatorInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculatorInputDescriptor = $convert.base64Decode(
    'Cg9DYWxjdWxhdG9ySW5wdXQSEgoEbmFtZRgBIAEoCVIEbmFtZRIUCgV2YWx1ZRgCIAEoCVIFdm'
    'FsdWUSEgoEdW5pdBgDIAEoCVIEdW5pdBIbCglzb3VyY2VfaWQYBCABKAlSCHNvdXJjZUlk');

@$core.Deprecated('Use calculatorResultDescriptor instead')
const CalculatorResult$json = {
  '1': 'CalculatorResult',
  '2': [
    {'1': 'result_id', '3': 1, '4': 1, '5': 9, '10': 'resultId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'calculator_id', '3': 4, '4': 1, '5': 9, '10': 'calculatorId'},
    {'1': 'formula_version', '3': 5, '4': 1, '5': 9, '10': 'formulaVersion'},
    {'1': 'name', '3': 6, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'inputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CalculatorInput',
      '10': 'inputs'
    },
    {'1': 'value', '3': 8, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 9, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'interpretation', '3': 10, '4': 1, '5': 9, '10': 'interpretation'},
    {'1': 'superseded_by_id', '3': 11, '4': 1, '5': 9, '10': 'supersededById'},
    {'1': 'calculated_by', '3': 12, '4': 1, '5': 9, '10': 'calculatedBy'},
    {
      '1': 'calculated_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'calculatedAt'
    },
  ],
};

/// Descriptor for `CalculatorResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculatorResultDescriptor = $convert.base64Decode(
    'ChBDYWxjdWxhdG9yUmVzdWx0EhsKCXJlc3VsdF9pZBgBIAEoCVIIcmVzdWx0SWQSHQoKcGF0aW'
    'VudF9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVy'
    'SWQSIwoNY2FsY3VsYXRvcl9pZBgEIAEoCVIMY2FsY3VsYXRvcklkEicKD2Zvcm11bGFfdmVyc2'
    'lvbhgFIAEoCVIOZm9ybXVsYVZlcnNpb24SEgoEbmFtZRgGIAEoCVIEbmFtZRI/CgZpbnB1dHMY'
    'ByADKAsyJy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNhbGN1bGF0b3JJbnB1dFIGaW5wdXRzEh'
    'QKBXZhbHVlGAggASgBUgV2YWx1ZRISCgR1bml0GAkgASgJUgR1bml0EiYKDmludGVycHJldGF0'
    'aW9uGAogASgJUg5pbnRlcnByZXRhdGlvbhIoChBzdXBlcnNlZGVkX2J5X2lkGAsgASgJUg5zdX'
    'BlcnNlZGVkQnlJZBIjCg1jYWxjdWxhdGVkX2J5GAwgASgJUgxjYWxjdWxhdGVkQnkSPwoNY2Fs'
    'Y3VsYXRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGNhbGN1bGF0ZW'
    'RBdA==');

@$core.Deprecated('Use cDSAlertDescriptor instead')
const CDSAlert$json = {
  '1': 'CDSAlert',
  '2': [
    {'1': 'alert_id', '3': 1, '4': 1, '5': 9, '10': 'alertId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'rule_id', '3': 4, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'rule_version', '3': 5, '4': 1, '5': 9, '10': 'ruleVersion'},
    {
      '1': 'level',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AlertLevel',
      '10': 'level'
    },
    {'1': 'message', '3': 7, '4': 1, '5': 9, '10': 'message'},
    {'1': 'context_type', '3': 8, '4': 1, '5': 9, '10': 'contextType'},
    {'1': 'context_id', '3': 9, '4': 1, '5': 9, '10': 'contextId'},
    {
      '1': 'outcome',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AlertOutcome',
      '10': 'outcome'
    },
    {'1': 'override_code', '3': 11, '4': 1, '5': 9, '10': 'overrideCode'},
    {'1': 'override_reason', '3': 12, '4': 1, '5': 9, '10': 'overrideReason'},
    {
      '1': 'fired_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'firedAt'
    },
    {'1': 'responded_by', '3': 14, '4': 1, '5': 9, '10': 'respondedBy'},
    {
      '1': 'responded_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondedAt'
    },
  ],
};

/// Descriptor for `CDSAlert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cDSAlertDescriptor = $convert.base64Decode(
    'CghDRFNBbGVydBIZCghhbGVydF9pZBgBIAEoCVIHYWxlcnRJZBIdCgpwYXRpZW50X2lkGAIgAS'
    'gJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIXCgdydWxl'
    'X2lkGAQgASgJUgZydWxlSWQSIQoMcnVsZV92ZXJzaW9uGAUgASgJUgtydWxlVmVyc2lvbhI4Cg'
    'VsZXZlbBgGIAEoDjIiLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWxlcnRMZXZlbFIFbGV2ZWwS'
    'GAoHbWVzc2FnZRgHIAEoCVIHbWVzc2FnZRIhCgxjb250ZXh0X3R5cGUYCCABKAlSC2NvbnRleH'
    'RUeXBlEh0KCmNvbnRleHRfaWQYCSABKAlSCWNvbnRleHRJZBI+CgdvdXRjb21lGAogASgOMiQu'
    'aGVhbHRoY2FyZS5jbGluaWNhbC52MS5BbGVydE91dGNvbWVSB291dGNvbWUSIwoNb3ZlcnJpZG'
    'VfY29kZRgLIAEoCVIMb3ZlcnJpZGVDb2RlEicKD292ZXJyaWRlX3JlYXNvbhgMIAEoCVIOb3Zl'
    'cnJpZGVSZWFzb24SNQoIZmlyZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgdmaXJlZEF0EiEKDHJlc3BvbmRlZF9ieRgOIAEoCVILcmVzcG9uZGVkQnkSPQoMcmVzcG9u'
    'ZGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVzcG9uZGVkQXQ=');

@$core.Deprecated('Use consultDescriptor instead')
const Consult$json = {
  '1': 'Consult',
  '2': [
    {'1': 'consult_id', '3': 1, '4': 1, '5': 9, '10': 'consultId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'specialty', '3': 4, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'urgency',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsultUrgency',
      '10': 'urgency'
    },
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'question', '3': 7, '4': 1, '5': 9, '10': 'question'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsultStatus',
      '10': 'status'
    },
    {
      '1': 'responding_subject_id',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'respondingSubjectId'
    },
    {'1': 'response', '3': 10, '4': 1, '5': 9, '10': 'response'},
    {
      '1': 'response_document_id',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'responseDocumentId'
    },
    {'1': 'decline_reason', '3': 12, '4': 1, '5': 9, '10': 'declineReason'},
    {'1': 'requested_by', '3': 13, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'requested_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {
      '1': 'responded_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'respondedAt'
    },
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Consult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List consultDescriptor = $convert.base64Decode(
    'CgdDb25zdWx0Eh0KCmNvbnN1bHRfaWQYASABKAlSCWNvbnN1bHRJZBIdCgpwYXRpZW50X2lkGA'
    'IgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIcCglz'
    'cGVjaWFsdHkYBCABKAlSCXNwZWNpYWx0eRJACgd1cmdlbmN5GAUgASgOMiYuaGVhbHRoY2FyZS'
    '5jbGluaWNhbC52MS5Db25zdWx0VXJnZW5jeVIHdXJnZW5jeRIWCgZyZWFzb24YBiABKAlSBnJl'
    'YXNvbhIaCghxdWVzdGlvbhgHIAEoCVIIcXVlc3Rpb24SPQoGc3RhdHVzGAggASgOMiUuaGVhbH'
    'RoY2FyZS5jbGluaWNhbC52MS5Db25zdWx0U3RhdHVzUgZzdGF0dXMSMgoVcmVzcG9uZGluZ19z'
    'dWJqZWN0X2lkGAkgASgJUhNyZXNwb25kaW5nU3ViamVjdElkEhoKCHJlc3BvbnNlGAogASgJUg'
    'hyZXNwb25zZRIwChRyZXNwb25zZV9kb2N1bWVudF9pZBgLIAEoCVIScmVzcG9uc2VEb2N1bWVu'
    'dElkEiUKDmRlY2xpbmVfcmVhc29uGAwgASgJUg1kZWNsaW5lUmVhc29uEiEKDHJlcXVlc3RlZF'
    '9ieRgNIAEoCVILcmVxdWVzdGVkQnkSPQoMcmVxdWVzdGVkX2F0GA4gASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILcmVxdWVzdGVkQXQSPQoMcmVzcG9uZGVkX2F0GA8gASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVzcG9uZGVkQXQSGAoHdmVyc2lvbhgQIAEoA1IH'
    'dmVyc2lvbg==');

@$core.Deprecated('Use registryMembershipDescriptor instead')
const RegistryMembership$json = {
  '1': 'RegistryMembership',
  '2': [
    {'1': 'membership_id', '3': 1, '4': 1, '5': 9, '10': 'membershipId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'registry_id', '3': 3, '4': 1, '5': 9, '10': 'registryId'},
    {'1': 'problem_id', '3': 4, '4': 1, '5': 9, '10': 'problemId'},
    {'1': 'diagnosis_id', '3': 5, '4': 1, '5': 9, '10': 'diagnosisId'},
    {
      '1': 'enrolled_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'enrolledAt'
    },
    {
      '1': 'exited_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'exitedAt'
    },
    {'1': 'exit_reason', '3': 8, '4': 1, '5': 9, '10': 'exitReason'},
    {'1': 'consented', '3': 9, '4': 1, '5': 8, '10': 'consented'},
  ],
};

/// Descriptor for `RegistryMembership`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registryMembershipDescriptor = $convert.base64Decode(
    'ChJSZWdpc3RyeU1lbWJlcnNoaXASIwoNbWVtYmVyc2hpcF9pZBgBIAEoCVIMbWVtYmVyc2hpcE'
    'lkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIfCgtyZWdpc3RyeV9pZBgDIAEoCVIK'
    'cmVnaXN0cnlJZBIdCgpwcm9ibGVtX2lkGAQgASgJUglwcm9ibGVtSWQSIQoMZGlhZ25vc2lzX2'
    'lkGAUgASgJUgtkaWFnbm9zaXNJZBI7CgtlbnJvbGxlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCmVucm9sbGVkQXQSNwoJZXhpdGVkX2F0GAcgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIIZXhpdGVkQXQSHwoLZXhpdF9yZWFzb24YCCABKAlSCmV4aXRS'
    'ZWFzb24SHAoJY29uc2VudGVkGAkgASgIUgljb25zZW50ZWQ=');

@$core.Deprecated('Use smartPhraseDescriptor instead')
const SmartPhrase$json = {
  '1': 'SmartPhrase',
  '2': [
    {'1': 'phrase_id', '3': 1, '4': 1, '5': 9, '10': 'phraseId'},
    {'1': 'owner_id', '3': 2, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'shortcut', '3': 3, '4': 1, '5': 9, '10': 'shortcut'},
    {'1': 'expansion', '3': 4, '4': 1, '5': 9, '10': 'expansion'},
  ],
};

/// Descriptor for `SmartPhrase`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List smartPhraseDescriptor = $convert.base64Decode(
    'CgtTbWFydFBocmFzZRIbCglwaHJhc2VfaWQYASABKAlSCHBocmFzZUlkEhkKCG93bmVyX2lkGA'
    'IgASgJUgdvd25lcklkEhoKCHNob3J0Y3V0GAMgASgJUghzaG9ydGN1dBIcCglleHBhbnNpb24Y'
    'BCABKAlSCWV4cGFuc2lvbg==');

@$core.Deprecated('Use bannerIdentifierDescriptor instead')
const BannerIdentifier$json = {
  '1': 'BannerIdentifier',
  '2': [
    {'1': 'system', '3': 1, '4': 1, '5': 9, '10': 'system'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
  ],
};

/// Descriptor for `BannerIdentifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bannerIdentifierDescriptor = $convert.base64Decode(
    'ChBCYW5uZXJJZGVudGlmaWVyEhYKBnN5c3RlbRgBIAEoCVIGc3lzdGVtEhQKBXZhbHVlGAIgAS'
    'gJUgV2YWx1ZRIUCgVsYWJlbBgDIAEoCVIFbGFiZWw=');

@$core.Deprecated('Use bannerAlertDescriptor instead')
const BannerAlert$json = {
  '1': 'BannerAlert',
  '2': [
    {'1': 'severity', '3': 1, '4': 1, '5': 9, '10': 'severity'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'record_id', '3': 4, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `BannerAlert`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bannerAlertDescriptor = $convert.base64Decode(
    'CgtCYW5uZXJBbGVydBIaCghzZXZlcml0eRgBIAEoCVIIc2V2ZXJpdHkSEgoEa2luZBgCIAEoCV'
    'IEa2luZBISCgR0ZXh0GAMgASgJUgR0ZXh0EhsKCXJlY29yZF9pZBgEIAEoCVIIcmVjb3JkSWQ=');

@$core.Deprecated('Use bannerDescriptor instead')
const Banner$json = {
  '1': 'Banner',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'identifiers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.BannerIdentifier',
      '10': 'identifiers'
    },
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'age_display', '3': 4, '4': 1, '5': 9, '10': 'ageDisplay'},
    {'1': 'sex', '3': 5, '4': 1, '5': 9, '10': 'sex'},
    {
      '1': 'alerts',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.BannerAlert',
      '10': 'alerts'
    },
    {
      '1': 'encounter_context',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'encounterContext'
    },
    {'1': 'deceased', '3': 8, '4': 1, '5': 8, '10': 'deceased'},
  ],
};

/// Descriptor for `Banner`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bannerDescriptor = $convert.base64Decode(
    'CgZCYW5uZXISHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEkoKC2lkZW50aWZpZXJzGA'
    'IgAygLMiguaGVhbHRoY2FyZS5jbGluaWNhbC52MS5CYW5uZXJJZGVudGlmaWVyUgtpZGVudGlm'
    'aWVycxIhCgxkaXNwbGF5X25hbWUYAyABKAlSC2Rpc3BsYXlOYW1lEh8KC2FnZV9kaXNwbGF5GA'
    'QgASgJUgphZ2VEaXNwbGF5EhAKA3NleBgFIAEoCVIDc2V4EjsKBmFsZXJ0cxgGIAMoCzIjLmhl'
    'YWx0aGNhcmUuY2xpbmljYWwudjEuQmFubmVyQWxlcnRSBmFsZXJ0cxIrChFlbmNvdW50ZXJfY2'
    '9udGV4dBgHIAEoCVIQZW5jb3VudGVyQ29udGV4dBIaCghkZWNlYXNlZBgIIAEoCFIIZGVjZWFz'
    'ZWQ=');

@$core.Deprecated('Use writeNoteRequestDescriptor instead')
const WriteNoteRequest$json = {
  '1': 'WriteNoteRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'template_id', '3': 5, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'template_version', '3': 6, '4': 1, '5': 9, '10': 'templateVersion'},
    {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'sections',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Section',
      '10': 'sections'
    },
    {
      '1': 'confidentiality',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {'1': 'dictated', '3': 10, '4': 1, '5': 8, '10': 'dictated'},
    {
      '1': 'context',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `WriteNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeNoteRequestDescriptor = $convert.base64Decode(
    'ChBXcml0ZU5vdGVSZXF1ZXN0Eh8KC2RvY3VtZW50X2lkGAEgASgJUgpkb2N1bWVudElkEh0KCn'
    'BhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYAyABKAlSC2VuY291'
    'bnRlcklkEjgKBGtpbmQYBCABKA4yJC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkRvY3VtZW50S2'
    'luZFIEa2luZBIfCgt0ZW1wbGF0ZV9pZBgFIAEoCVIKdGVtcGxhdGVJZBIpChB0ZW1wbGF0ZV92'
    'ZXJzaW9uGAYgASgJUg90ZW1wbGF0ZVZlcnNpb24SFAoFdGl0bGUYByABKAlSBXRpdGxlEjsKCH'
    'NlY3Rpb25zGAggAygLMh8uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5TZWN0aW9uUghzZWN0aW9u'
    'cxJRCg9jb25maWRlbnRpYWxpdHkYCSABKA4yJy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvbm'
    'ZpZGVudGlhbGl0eVIPY29uZmlkZW50aWFsaXR5EhoKCGRpY3RhdGVkGAogASgIUghkaWN0YXRl'
    'ZBJACgdjb250ZXh0GAsgASgLMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5QYXRpZW50Q29udG'
    'V4dFIHY29udGV4dA==');

@$core.Deprecated('Use writeNoteResponseDescriptor instead')
const WriteNoteResponse$json = {
  '1': 'WriteNoteResponse',
  '2': [
    {
      '1': 'document',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Document',
      '10': 'document'
    },
  ],
};

/// Descriptor for `WriteNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeNoteResponseDescriptor = $convert.base64Decode(
    'ChFXcml0ZU5vdGVSZXNwb25zZRI8Cghkb2N1bWVudBgBIAEoCzIgLmhlYWx0aGNhcmUuY2xpbm'
    'ljYWwudjEuRG9jdW1lbnRSCGRvY3VtZW50');

@$core.Deprecated('Use signNoteRequestDescriptor instead')
const SignNoteRequest$json = {
  '1': 'SignNoteRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {
      '1': 'meaning',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.SignatureMeaning',
      '10': 'meaning'
    },
    {
      '1': 'context',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `SignNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signNoteRequestDescriptor = $convert.base64Decode(
    'Cg9TaWduTm90ZVJlcXVlc3QSHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW50SWQSQgoHbW'
    'VhbmluZxgCIAEoDjIoLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuU2lnbmF0dXJlTWVhbmluZ1IH'
    'bWVhbmluZxJACgdjb250ZXh0GAMgASgLMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5QYXRpZW'
    '50Q29udGV4dFIHY29udGV4dA==');

@$core.Deprecated('Use signNoteResponseDescriptor instead')
const SignNoteResponse$json = {
  '1': 'SignNoteResponse',
  '2': [
    {
      '1': 'document',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Document',
      '10': 'document'
    },
  ],
};

/// Descriptor for `SignNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signNoteResponseDescriptor = $convert.base64Decode(
    'ChBTaWduTm90ZVJlc3BvbnNlEjwKCGRvY3VtZW50GAEgASgLMiAuaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5Eb2N1bWVudFIIZG9jdW1lbnQ=');

@$core.Deprecated('Use amendNoteRequestDescriptor instead')
const AmendNoteRequest$json = {
  '1': 'AmendNoteRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'sections',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Section',
      '10': 'sections'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'addendum', '3': 5, '4': 1, '5': 8, '10': 'addendum'},
    {
      '1': 'context',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `AmendNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendNoteRequestDescriptor = $convert.base64Decode(
    'ChBBbWVuZE5vdGVSZXF1ZXN0Eh8KC2RvY3VtZW50X2lkGAEgASgJUgpkb2N1bWVudElkEhQKBX'
    'RpdGxlGAIgASgJUgV0aXRsZRI7CghzZWN0aW9ucxgDIAMoCzIfLmhlYWx0aGNhcmUuY2xpbmlj'
    'YWwudjEuU2VjdGlvblIIc2VjdGlvbnMSFgoGcmVhc29uGAQgASgJUgZyZWFzb24SGgoIYWRkZW'
    '5kdW0YBSABKAhSCGFkZGVuZHVtEkAKB2NvbnRleHQYBiABKAsyJi5oZWFsdGhjYXJlLmNsaW5p'
    'Y2FsLnYxLlBhdGllbnRDb250ZXh0Ugdjb250ZXh0');

@$core.Deprecated('Use amendNoteResponseDescriptor instead')
const AmendNoteResponse$json = {
  '1': 'AmendNoteResponse',
  '2': [
    {
      '1': 'document',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Document',
      '10': 'document'
    },
  ],
};

/// Descriptor for `AmendNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List amendNoteResponseDescriptor = $convert.base64Decode(
    'ChFBbWVuZE5vdGVSZXNwb25zZRI8Cghkb2N1bWVudBgBIAEoCzIgLmhlYWx0aGNhcmUuY2xpbm'
    'ljYWwudjEuRG9jdW1lbnRSCGRvY3VtZW50');

@$core.Deprecated('Use retractNoteRequestDescriptor instead')
const RetractNoteRequest$json = {
  '1': 'RetractNoteRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RetractNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractNoteRequestDescriptor = $convert.base64Decode(
    'ChJSZXRyYWN0Tm90ZVJlcXVlc3QSHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW50SWQSFg'
    'oGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use retractNoteResponseDescriptor instead')
const RetractNoteResponse$json = {
  '1': 'RetractNoteResponse',
};

/// Descriptor for `RetractNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retractNoteResponseDescriptor =
    $convert.base64Decode('ChNSZXRyYWN0Tm90ZVJlc3BvbnNl');

@$core.Deprecated('Use getNoteRequestDescriptor instead')
const GetNoteRequest$json = {
  '1': 'GetNoteRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
  ],
};

/// Descriptor for `GetNoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNoteRequestDescriptor = $convert.base64Decode(
    'Cg5HZXROb3RlUmVxdWVzdBIfCgtkb2N1bWVudF9pZBgBIAEoCVIKZG9jdW1lbnRJZA==');

@$core.Deprecated('Use getNoteResponseDescriptor instead')
const GetNoteResponse$json = {
  '1': 'GetNoteResponse',
  '2': [
    {
      '1': 'document',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Document',
      '10': 'document'
    },
  ],
};

/// Descriptor for `GetNoteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNoteResponseDescriptor = $convert.base64Decode(
    'Cg9HZXROb3RlUmVzcG9uc2USPAoIZG9jdW1lbnQYASABKAsyIC5oZWFsdGhjYXJlLmNsaW5pY2'
    'FsLnYxLkRvY3VtZW50Ughkb2N1bWVudA==');

@$core.Deprecated('Use listNotesRequestDescriptor instead')
const ListNotesRequest$json = {
  '1': 'ListNotesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'include_drafts', '3': 4, '4': 1, '5': 8, '10': 'includeDrafts'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListNotesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Tm90ZXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCgxlbm'
    'NvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEjgKBGtpbmQYAyABKA4yJC5oZWFsdGhjYXJl'
    'LmNsaW5pY2FsLnYxLkRvY3VtZW50S2luZFIEa2luZBIlCg5pbmNsdWRlX2RyYWZ0cxgEIAEoCF'
    'INaW5jbHVkZURyYWZ0cxIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listNotesResponseDescriptor instead')
const ListNotesResponse$json = {
  '1': 'ListNotesResponse',
  '2': [
    {
      '1': 'documents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Document',
      '10': 'documents'
    },
  ],
};

/// Descriptor for `ListNotesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Tm90ZXNSZXNwb25zZRI+Cglkb2N1bWVudHMYASADKAsyIC5oZWFsdGhjYXJlLmNsaW'
    '5pY2FsLnYxLkRvY3VtZW50Uglkb2N1bWVudHM=');

@$core.Deprecated('Use defineTemplateRequestDescriptor instead')
const DefineTemplateRequest$json = {
  '1': 'DefineTemplateRequest',
  '2': [
    {
      '1': 'template',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Template',
      '10': 'template'
    },
  ],
};

/// Descriptor for `DefineTemplateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineTemplateRequestDescriptor = $convert.base64Decode(
    'ChVEZWZpbmVUZW1wbGF0ZVJlcXVlc3QSPAoIdGVtcGxhdGUYASABKAsyIC5oZWFsdGhjYXJlLm'
    'NsaW5pY2FsLnYxLlRlbXBsYXRlUgh0ZW1wbGF0ZQ==');

@$core.Deprecated('Use defineTemplateResponseDescriptor instead')
const DefineTemplateResponse$json = {
  '1': 'DefineTemplateResponse',
};

/// Descriptor for `DefineTemplateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineTemplateResponseDescriptor =
    $convert.base64Decode('ChZEZWZpbmVUZW1wbGF0ZVJlc3BvbnNl');

@$core.Deprecated('Use listTemplatesRequestDescriptor instead')
const ListTemplatesRequest$json = {
  '1': 'ListTemplatesRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'include_retired', '3': 2, '4': 1, '5': 8, '10': 'includeRetired'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTemplatesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0VGVtcGxhdGVzUmVxdWVzdBI4CgRraW5kGAEgASgOMiQuaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5Eb2N1bWVudEtpbmRSBGtpbmQSJwoPaW5jbHVkZV9yZXRpcmVkGAIgASgIUg5pbmNs'
    'dWRlUmV0aXJlZBIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listTemplatesResponseDescriptor instead')
const ListTemplatesResponse$json = {
  '1': 'ListTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Template',
      '10': 'templates'
    },
  ],
};

/// Descriptor for `ListTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTemplatesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0VGVtcGxhdGVzUmVzcG9uc2USPgoJdGVtcGxhdGVzGAEgAygLMiAuaGVhbHRoY2FyZS'
    '5jbGluaWNhbC52MS5UZW1wbGF0ZVIJdGVtcGxhdGVz');

@$core.Deprecated('Use retireTemplateRequestDescriptor instead')
const RetireTemplateRequest$json = {
  '1': 'RetireTemplateRequest',
  '2': [
    {'1': 'template_id', '3': 1, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `RetireTemplateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireTemplateRequestDescriptor = $convert.base64Decode(
    'ChVSZXRpcmVUZW1wbGF0ZVJlcXVlc3QSHwoLdGVtcGxhdGVfaWQYASABKAlSCnRlbXBsYXRlSW'
    'QSGAoHdmVyc2lvbhgCIAEoCVIHdmVyc2lvbg==');

@$core.Deprecated('Use retireTemplateResponseDescriptor instead')
const RetireTemplateResponse$json = {
  '1': 'RetireTemplateResponse',
};

/// Descriptor for `RetireTemplateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireTemplateResponseDescriptor =
    $convert.base64Decode('ChZSZXRpcmVUZW1wbGF0ZVJlc3BvbnNl');

@$core.Deprecated('Use defineSmartPhraseRequestDescriptor instead')
const DefineSmartPhraseRequest$json = {
  '1': 'DefineSmartPhraseRequest',
  '2': [
    {'1': 'shortcut', '3': 1, '4': 1, '5': 9, '10': 'shortcut'},
    {'1': 'expansion', '3': 2, '4': 1, '5': 9, '10': 'expansion'},
    {'1': 'shared', '3': 3, '4': 1, '5': 8, '10': 'shared'},
  ],
};

/// Descriptor for `DefineSmartPhraseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineSmartPhraseRequestDescriptor =
    $convert.base64Decode(
        'ChhEZWZpbmVTbWFydFBocmFzZVJlcXVlc3QSGgoIc2hvcnRjdXQYASABKAlSCHNob3J0Y3V0Eh'
        'wKCWV4cGFuc2lvbhgCIAEoCVIJZXhwYW5zaW9uEhYKBnNoYXJlZBgDIAEoCFIGc2hhcmVk');

@$core.Deprecated('Use defineSmartPhraseResponseDescriptor instead')
const DefineSmartPhraseResponse$json = {
  '1': 'DefineSmartPhraseResponse',
  '2': [
    {
      '1': 'phrase',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.SmartPhrase',
      '10': 'phrase'
    },
  ],
};

/// Descriptor for `DefineSmartPhraseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineSmartPhraseResponseDescriptor =
    $convert.base64Decode(
        'ChlEZWZpbmVTbWFydFBocmFzZVJlc3BvbnNlEjsKBnBocmFzZRgBIAEoCzIjLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuU21hcnRQaHJhc2VSBnBocmFzZQ==');

@$core.Deprecated('Use listSmartPhrasesRequestDescriptor instead')
const ListSmartPhrasesRequest$json = {
  '1': 'ListSmartPhrasesRequest',
};

/// Descriptor for `ListSmartPhrasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSmartPhrasesRequestDescriptor =
    $convert.base64Decode('ChdMaXN0U21hcnRQaHJhc2VzUmVxdWVzdA==');

@$core.Deprecated('Use listSmartPhrasesResponseDescriptor instead')
const ListSmartPhrasesResponse$json = {
  '1': 'ListSmartPhrasesResponse',
  '2': [
    {
      '1': 'phrases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.SmartPhrase',
      '10': 'phrases'
    },
  ],
};

/// Descriptor for `ListSmartPhrasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSmartPhrasesResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0U21hcnRQaHJhc2VzUmVzcG9uc2USPQoHcGhyYXNlcxgBIAMoCzIjLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuU21hcnRQaHJhc2VSB3BocmFzZXM=');

@$core.Deprecated('Use recordProblemRequestDescriptor instead')
const RecordProblemRequest$json = {
  '1': 'RecordProblemRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ProblemStatus',
      '10': 'status'
    },
    {
      '1': 'onset_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {
      '1': 'confidentiality',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {
      '1': 'context',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `RecordProblemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProblemRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRQcm9ibGVtUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQ'
    'oMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIyCgRjb2RlGAMgASgLMh4uaGVhbHRo'
    'Y2FyZS5jbGluaWNhbC52MS5Db2RpbmdSBGNvZGUSEgoEbm90ZRgEIAEoCVIEbm90ZRI9CgZzdG'
    'F0dXMYBSABKA4yJS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlByb2JsZW1TdGF0dXNSBnN0YXR1'
    'cxI1CghvbnNldF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB29uc2V0QX'
    'QSUQoPY29uZmlkZW50aWFsaXR5GAcgASgOMicuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db25m'
    'aWRlbnRpYWxpdHlSD2NvbmZpZGVudGlhbGl0eRJACgdjb250ZXh0GAggASgLMiYuaGVhbHRoY2'
    'FyZS5jbGluaWNhbC52MS5QYXRpZW50Q29udGV4dFIHY29udGV4dA==');

@$core.Deprecated('Use recordProblemResponseDescriptor instead')
const RecordProblemResponse$json = {
  '1': 'RecordProblemResponse',
  '2': [
    {
      '1': 'problem',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Problem',
      '10': 'problem'
    },
  ],
};

/// Descriptor for `RecordProblemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProblemResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRQcm9ibGVtUmVzcG9uc2USOQoHcHJvYmxlbRgBIAEoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuUHJvYmxlbVIHcHJvYmxlbQ==');

@$core.Deprecated('Use updateProblemRequestDescriptor instead')
const UpdateProblemRequest$json = {
  '1': 'UpdateProblemRequest',
  '2': [
    {'1': 'problem_id', '3': 1, '4': 1, '5': 9, '10': 'problemId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ProblemStatus',
      '10': 'status'
    },
    {
      '1': 'resolved_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
  ],
};

/// Descriptor for `UpdateProblemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProblemRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9ibGVtUmVxdWVzdBIdCgpwcm9ibGVtX2lkGAEgASgJUglwcm9ibGVtSWQSPQ'
    'oGc3RhdHVzGAIgASgOMiUuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Qcm9ibGVtU3RhdHVzUgZz'
    'dGF0dXMSOwoLcmVzb2x2ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'pyZXNvbHZlZEF0');

@$core.Deprecated('Use updateProblemResponseDescriptor instead')
const UpdateProblemResponse$json = {
  '1': 'UpdateProblemResponse',
  '2': [
    {
      '1': 'problem',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Problem',
      '10': 'problem'
    },
  ],
};

/// Descriptor for `UpdateProblemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProblemResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9ibGVtUmVzcG9uc2USOQoHcHJvYmxlbRgBIAEoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuUHJvYmxlbVIHcHJvYmxlbQ==');

@$core.Deprecated('Use listProblemsRequestDescriptor instead')
const ListProblemsRequest$json = {
  '1': 'ListProblemsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListProblemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProblemsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UHJvYmxlbXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIfCg'
    'thY3RpdmVfb25seRgCIAEoCFIKYWN0aXZlT25seRIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VT'
    'aXpl');

@$core.Deprecated('Use listProblemsResponseDescriptor instead')
const ListProblemsResponse$json = {
  '1': 'ListProblemsResponse',
  '2': [
    {
      '1': 'problems',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Problem',
      '10': 'problems'
    },
  ],
};

/// Descriptor for `ListProblemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProblemsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvYmxlbXNSZXNwb25zZRI7Cghwcm9ibGVtcxgBIAMoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuUHJvYmxlbVIIcHJvYmxlbXM=');

@$core.Deprecated('Use recordAllergyRequestDescriptor instead')
const RecordAllergyRequest$json = {
  '1': 'RecordAllergyRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'substance',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'substance'
    },
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyKind',
      '10': 'kind'
    },
    {
      '1': 'criticality',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyCriticality',
      '10': 'criticality'
    },
    {
      '1': 'verification',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyVerification',
      '10': 'verification'
    },
    {
      '1': 'reactions',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Reaction',
      '10': 'reactions'
    },
    {
      '1': 'onset_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'onsetAt'
    },
    {'1': 'note', '3': 9, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'context',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `RecordAllergyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAllergyRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRBbGxlcmd5UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQ'
    'oMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBI8CglzdWJzdGFuY2UYAyABKAsyHi5o'
    'ZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvZGluZ1IJc3Vic3RhbmNlEjcKBGtpbmQYBCABKA4yIy'
    '5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkFsbGVyZ3lLaW5kUgRraW5kEkwKC2NyaXRpY2FsaXR5'
    'GAUgASgOMiouaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BbGxlcmd5Q3JpdGljYWxpdHlSC2NyaX'
    'RpY2FsaXR5Ek8KDHZlcmlmaWNhdGlvbhgGIAEoDjIrLmhlYWx0aGNhcmUuY2xpbmljYWwudjEu'
    'QWxsZXJneVZlcmlmaWNhdGlvblIMdmVyaWZpY2F0aW9uEj4KCXJlYWN0aW9ucxgHIAMoCzIgLm'
    'hlYWx0aGNhcmUuY2xpbmljYWwudjEuUmVhY3Rpb25SCXJlYWN0aW9ucxI1CghvbnNldF9hdBgI'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB29uc2V0QXQSEgoEbm90ZRgJIAEoCV'
    'IEbm90ZRJACgdjb250ZXh0GAogASgLMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5QYXRpZW50'
    'Q29udGV4dFIHY29udGV4dA==');

@$core.Deprecated('Use recordAllergyResponseDescriptor instead')
const RecordAllergyResponse$json = {
  '1': 'RecordAllergyResponse',
  '2': [
    {
      '1': 'allergy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Allergy',
      '10': 'allergy'
    },
  ],
};

/// Descriptor for `RecordAllergyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAllergyResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRBbGxlcmd5UmVzcG9uc2USOQoHYWxsZXJneRgBIAEoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQWxsZXJneVIHYWxsZXJneQ==');

@$core.Deprecated('Use verifyAllergyRequestDescriptor instead')
const VerifyAllergyRequest$json = {
  '1': 'VerifyAllergyRequest',
  '2': [
    {'1': 'allergy_id', '3': 1, '4': 1, '5': 9, '10': 'allergyId'},
    {
      '1': 'verification',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AllergyVerification',
      '10': 'verification'
    },
  ],
};

/// Descriptor for `VerifyAllergyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyAllergyRequestDescriptor = $convert.base64Decode(
    'ChRWZXJpZnlBbGxlcmd5UmVxdWVzdBIdCgphbGxlcmd5X2lkGAEgASgJUglhbGxlcmd5SWQSTw'
    'oMdmVyaWZpY2F0aW9uGAIgASgOMisuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BbGxlcmd5VmVy'
    'aWZpY2F0aW9uUgx2ZXJpZmljYXRpb24=');

@$core.Deprecated('Use verifyAllergyResponseDescriptor instead')
const VerifyAllergyResponse$json = {
  '1': 'VerifyAllergyResponse',
  '2': [
    {
      '1': 'allergy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Allergy',
      '10': 'allergy'
    },
  ],
};

/// Descriptor for `VerifyAllergyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyAllergyResponseDescriptor = $convert.base64Decode(
    'ChVWZXJpZnlBbGxlcmd5UmVzcG9uc2USOQoHYWxsZXJneRgBIAEoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQWxsZXJneVIHYWxsZXJneQ==');

@$core.Deprecated('Use listAllergiesRequestDescriptor instead')
const ListAllergiesRequest$json = {
  '1': 'ListAllergiesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAllergiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAllergiesRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0QWxsZXJnaWVzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSHw'
    'oLYWN0aXZlX29ubHkYAiABKAhSCmFjdGl2ZU9ubHkSGwoJcGFnZV9zaXplGAMgASgFUghwYWdl'
    'U2l6ZQ==');

@$core.Deprecated('Use listAllergiesResponseDescriptor instead')
const ListAllergiesResponse$json = {
  '1': 'ListAllergiesResponse',
  '2': [
    {
      '1': 'allergies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Allergy',
      '10': 'allergies'
    },
  ],
};

/// Descriptor for `ListAllergiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAllergiesResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0QWxsZXJnaWVzUmVzcG9uc2USPQoJYWxsZXJnaWVzGAEgAygLMh8uaGVhbHRoY2FyZS'
    '5jbGluaWNhbC52MS5BbGxlcmd5UglhbGxlcmdpZXM=');

@$core.Deprecated('Use recordObservationRequestDescriptor instead')
const RecordObservationRequest$json = {
  '1': 'RecordObservationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Quantity',
      '10': 'value'
    },
    {'1': 'text_value', '3': 5, '4': 1, '5': 9, '10': 'textValue'},
    {
      '1': 'coded_value',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'codedValue'
    },
    {'1': 'reference_low', '3': 7, '4': 1, '5': 1, '10': 'referenceLow'},
    {'1': 'reference_high', '3': 8, '4': 1, '5': 1, '10': 'referenceHigh'},
    {
      '1': 'has_reference_range',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'hasReferenceRange'
    },
    {'1': 'reference_text', '3': 10, '4': 1, '5': 9, '10': 'referenceText'},
    {
      '1': 'interpretation',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Interpretation',
      '10': 'interpretation'
    },
    {
      '1': 'interpretation_source',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'interpretationSource'
    },
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ObservationStatus',
      '10': 'status'
    },
    {
      '1': 'effective_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'issued_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'performer_id', '3': 16, '4': 1, '5': 9, '10': 'performerId'},
    {'1': 'device_id', '3': 17, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'source_system', '3': 18, '4': 1, '5': 9, '10': 'sourceSystem'},
    {
      '1': 'provenance',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Provenance',
      '10': 'provenance'
    },
    {'1': 'note', '3': 20, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'context',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `RecordObservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordObservationRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRPYnNlcnZhdGlvblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudE'
    'lkEiEKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSMgoEY29kZRgDIAEoCzIeLmhl'
    'YWx0aGNhcmUuY2xpbmljYWwudjEuQ29kaW5nUgRjb2RlEjYKBXZhbHVlGAQgASgLMiAuaGVhbH'
    'RoY2FyZS5jbGluaWNhbC52MS5RdWFudGl0eVIFdmFsdWUSHQoKdGV4dF92YWx1ZRgFIAEoCVIJ'
    'dGV4dFZhbHVlEj8KC2NvZGVkX3ZhbHVlGAYgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS'
    '5Db2RpbmdSCmNvZGVkVmFsdWUSIwoNcmVmZXJlbmNlX2xvdxgHIAEoAVIMcmVmZXJlbmNlTG93'
    'EiUKDnJlZmVyZW5jZV9oaWdoGAggASgBUg1yZWZlcmVuY2VIaWdoEi4KE2hhc19yZWZlcmVuY2'
    'VfcmFuZ2UYCSABKAhSEWhhc1JlZmVyZW5jZVJhbmdlEiUKDnJlZmVyZW5jZV90ZXh0GAogASgJ'
    'Ug1yZWZlcmVuY2VUZXh0Ek4KDmludGVycHJldGF0aW9uGAsgASgOMiYuaGVhbHRoY2FyZS5jbG'
    'luaWNhbC52MS5JbnRlcnByZXRhdGlvblIOaW50ZXJwcmV0YXRpb24SMwoVaW50ZXJwcmV0YXRp'
    'b25fc291cmNlGAwgASgJUhRpbnRlcnByZXRhdGlvblNvdXJjZRJBCgZzdGF0dXMYDSABKA4yKS'
    '5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLk9ic2VydmF0aW9uU3RhdHVzUgZzdGF0dXMSPQoMZWZm'
    'ZWN0aXZlX2F0GA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZWZmZWN0aXZlQX'
    'QSNwoJaXNzdWVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIaXNzdWVk'
    'QXQSIQoMcGVyZm9ybWVyX2lkGBAgASgJUgtwZXJmb3JtZXJJZBIbCglkZXZpY2VfaWQYESABKA'
    'lSCGRldmljZUlkEiMKDXNvdXJjZV9zeXN0ZW0YEiABKAlSDHNvdXJjZVN5c3RlbRJCCgpwcm92'
    'ZW5hbmNlGBMgASgLMiIuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Qcm92ZW5hbmNlUgpwcm92ZW'
    '5hbmNlEhIKBG5vdGUYFCABKAlSBG5vdGUSQAoHY29udGV4dBgVIAEoCzImLmhlYWx0aGNhcmUu'
    'Y2xpbmljYWwudjEuUGF0aWVudENvbnRleHRSB2NvbnRleHQ=');

@$core.Deprecated('Use recordObservationResponseDescriptor instead')
const RecordObservationResponse$json = {
  '1': 'RecordObservationResponse',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Observation',
      '10': 'observation'
    },
  ],
};

/// Descriptor for `RecordObservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordObservationResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRPYnNlcnZhdGlvblJlc3BvbnNlEkUKC29ic2VydmF0aW9uGAEgASgLMiMuaGVhbH'
        'RoY2FyZS5jbGluaWNhbC52MS5PYnNlcnZhdGlvblILb2JzZXJ2YXRpb24=');

@$core.Deprecated('Use listObservationsRequestDescriptor instead')
const ListObservationsRequest$json = {
  '1': 'ListObservationsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListObservationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listObservationsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0T2JzZXJ2YXRpb25zUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBISCgRjb2RlGAMgASgJUgRjb2Rl'
    'EhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listObservationsResponseDescriptor instead')
const ListObservationsResponse$json = {
  '1': 'ListObservationsResponse',
  '2': [
    {
      '1': 'observations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Observation',
      '10': 'observations'
    },
  ],
};

/// Descriptor for `ListObservationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listObservationsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0T2JzZXJ2YXRpb25zUmVzcG9uc2USRwoMb2JzZXJ2YXRpb25zGAEgAygLMiMuaGVhbH'
        'RoY2FyZS5jbGluaWNhbC52MS5PYnNlcnZhdGlvblIMb2JzZXJ2YXRpb25z');

@$core.Deprecated('Use criticalResultDescriptor instead')
const CriticalResult$json = {
  '1': 'CriticalResult',
  '2': [
    {
      '1': 'observation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Observation',
      '10': 'observation'
    },
    {'1': 'due_escalations', '3': 2, '4': 1, '5': 5, '10': 'dueEscalations'},
  ],
};

/// Descriptor for `CriticalResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List criticalResultDescriptor = $convert.base64Decode(
    'Cg5Dcml0aWNhbFJlc3VsdBJFCgtvYnNlcnZhdGlvbhgBIAEoCzIjLmhlYWx0aGNhcmUuY2xpbm'
    'ljYWwudjEuT2JzZXJ2YXRpb25SC29ic2VydmF0aW9uEicKD2R1ZV9lc2NhbGF0aW9ucxgCIAEo'
    'BVIOZHVlRXNjYWxhdGlvbnM=');

@$core.Deprecated('Use listCriticalResultsRequestDescriptor instead')
const ListCriticalResultsRequest$json = {
  '1': 'ListCriticalResultsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCriticalResultsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCriticalResultsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Q3JpdGljYWxSZXN1bHRzUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaX'
        'pl');

@$core.Deprecated('Use listCriticalResultsResponseDescriptor instead')
const ListCriticalResultsResponse$json = {
  '1': 'ListCriticalResultsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CriticalResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `ListCriticalResultsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCriticalResultsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Q3JpdGljYWxSZXN1bHRzUmVzcG9uc2USQAoHcmVzdWx0cxgBIAMoCzImLmhlYWx0aG'
        'NhcmUuY2xpbmljYWwudjEuQ3JpdGljYWxSZXN1bHRSB3Jlc3VsdHM=');

@$core.Deprecated('Use acknowledgeCriticalResultRequestDescriptor instead')
const AcknowledgeCriticalResultRequest$json = {
  '1': 'AcknowledgeCriticalResultRequest',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {'1': 'action', '3': 2, '4': 1, '5': 9, '10': 'action'},
  ],
};

/// Descriptor for `AcknowledgeCriticalResultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeCriticalResultRequestDescriptor =
    $convert.base64Decode(
        'CiBBY2tub3dsZWRnZUNyaXRpY2FsUmVzdWx0UmVxdWVzdBIlCg5vYnNlcnZhdGlvbl9pZBgBIA'
        'EoCVINb2JzZXJ2YXRpb25JZBIWCgZhY3Rpb24YAiABKAlSBmFjdGlvbg==');

@$core.Deprecated('Use acknowledgeCriticalResultResponseDescriptor instead')
const AcknowledgeCriticalResultResponse$json = {
  '1': 'AcknowledgeCriticalResultResponse',
  '2': [
    {
      '1': 'acknowledgement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CriticalAcknowledgement',
      '10': 'acknowledgement'
    },
  ],
};

/// Descriptor for `AcknowledgeCriticalResultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeCriticalResultResponseDescriptor =
    $convert.base64Decode(
        'CiFBY2tub3dsZWRnZUNyaXRpY2FsUmVzdWx0UmVzcG9uc2USWQoPYWNrbm93bGVkZ2VtZW50GA'
        'EgASgLMi8uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Dcml0aWNhbEFja25vd2xlZGdlbWVudFIP'
        'YWNrbm93bGVkZ2VtZW50');

@$core.Deprecated('Use recordProcedureRequestDescriptor instead')
const RecordProcedureRequest$json = {
  '1': 'RecordProcedureRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ProcedureStatus',
      '10': 'status'
    },
    {
      '1': 'indication',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'indication'
    },
    {
      '1': 'performers',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Performer',
      '10': 'performers'
    },
    {
      '1': 'body_site',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'bodySite'
    },
    {
      '1': 'laterality',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'outcome', '3': 9, '4': 1, '5': 9, '10': 'outcome'},
    {
      '1': 'complications',
      '3': 10,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'complications'
    },
    {'1': 'order_ids', '3': 11, '4': 3, '5': 9, '10': 'orderIds'},
    {'1': 'device_ids', '3': 12, '4': 3, '5': 9, '10': 'deviceIds'},
    {'1': 'specimen_ids', '3': 13, '4': 3, '5': 9, '10': 'specimenIds'},
    {
      '1': 'performed_start',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedStart'
    },
    {
      '1': 'performed_end',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedEnd'
    },
    {'1': 'note', '3': 16, '4': 1, '5': 9, '10': 'note'},
    {'1': 'require_consent', '3': 17, '4': 1, '5': 8, '10': 'requireConsent'},
    {
      '1': 'context',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.PatientContext',
      '10': 'context'
    },
  ],
};

/// Descriptor for `RecordProcedureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProcedureRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvcmRQcm9jZWR1cmVSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IhCgxlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEjIKBGNvZGUYAyABKAsyHi5oZWFs'
    'dGhjYXJlLmNsaW5pY2FsLnYxLkNvZGluZ1IEY29kZRI/CgZzdGF0dXMYBCABKA4yJy5oZWFsdG'
    'hjYXJlLmNsaW5pY2FsLnYxLlByb2NlZHVyZVN0YXR1c1IGc3RhdHVzEj4KCmluZGljYXRpb24Y'
    'BSABKAsyHi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkNvZGluZ1IKaW5kaWNhdGlvbhJBCgpwZX'
    'Jmb3JtZXJzGAYgAygLMiEuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5QZXJmb3JtZXJSCnBlcmZv'
    'cm1lcnMSOwoJYm9keV9zaXRlGAcgASgLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2Rpbm'
    'dSCGJvZHlTaXRlEkIKCmxhdGVyYWxpdHkYCCABKA4yIi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYx'
    'LkxhdGVyYWxpdHlSCmxhdGVyYWxpdHkSGAoHb3V0Y29tZRgJIAEoCVIHb3V0Y29tZRJECg1jb2'
    '1wbGljYXRpb25zGAogAygLMh4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db2RpbmdSDWNvbXBs'
    'aWNhdGlvbnMSGwoJb3JkZXJfaWRzGAsgAygJUghvcmRlcklkcxIdCgpkZXZpY2VfaWRzGAwgAy'
    'gJUglkZXZpY2VJZHMSIQoMc3BlY2ltZW5faWRzGA0gAygJUgtzcGVjaW1lbklkcxJDCg9wZXJm'
    'b3JtZWRfc3RhcnQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5wZXJmb3JtZW'
    'RTdGFydBI/Cg1wZXJmb3JtZWRfZW5kGA8gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIMcGVyZm9ybWVkRW5kEhIKBG5vdGUYECABKAlSBG5vdGUSJwoPcmVxdWlyZV9jb25zZW50GB'
    'EgASgIUg5yZXF1aXJlQ29uc2VudBJACgdjb250ZXh0GBIgASgLMiYuaGVhbHRoY2FyZS5jbGlu'
    'aWNhbC52MS5QYXRpZW50Q29udGV4dFIHY29udGV4dA==');

@$core.Deprecated('Use recordProcedureResponseDescriptor instead')
const RecordProcedureResponse$json = {
  '1': 'RecordProcedureResponse',
  '2': [
    {
      '1': 'procedure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Procedure',
      '10': 'procedure'
    },
  ],
};

/// Descriptor for `RecordProcedureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProcedureResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvcmRQcm9jZWR1cmVSZXNwb25zZRI/Cglwcm9jZWR1cmUYASABKAsyIS5oZWFsdGhjYX'
        'JlLmNsaW5pY2FsLnYxLlByb2NlZHVyZVIJcHJvY2VkdXJl');

@$core.Deprecated('Use listProceduresRequestDescriptor instead')
const ListProceduresRequest$json = {
  '1': 'ListProceduresRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListProceduresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProceduresRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0UHJvY2VkdXJlc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSGwoJcGFnZV9zaXplGAMgASgFUghw'
    'YWdlU2l6ZQ==');

@$core.Deprecated('Use listProceduresResponseDescriptor instead')
const ListProceduresResponse$json = {
  '1': 'ListProceduresResponse',
  '2': [
    {
      '1': 'procedures',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Procedure',
      '10': 'procedures'
    },
  ],
};

/// Descriptor for `ListProceduresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProceduresResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UHJvY2VkdXJlc1Jlc3BvbnNlEkEKCnByb2NlZHVyZXMYASADKAsyIS5oZWFsdGhjYX'
        'JlLmNsaW5pY2FsLnYxLlByb2NlZHVyZVIKcHJvY2VkdXJlcw==');

@$core.Deprecated('Use createCarePlanRequestDescriptor instead')
const CreateCarePlanRequest$json = {
  '1': 'CreateCarePlanRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'problem_ids', '3': 4, '4': 3, '5': 9, '10': 'problemIds'},
    {
      '1': 'goals',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Goal',
      '10': 'goals'
    },
    {
      '1': 'activities',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Activity',
      '10': 'activities'
    },
    {'1': 'owner_id', '3': 7, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'starts_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
  ],
};

/// Descriptor for `CreateCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCarePlanRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVDYXJlUGxhblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSFAoFdGl0bGUYAyABKAlSBXRpdGxl'
    'Eh8KC3Byb2JsZW1faWRzGAQgAygJUgpwcm9ibGVtSWRzEjIKBWdvYWxzGAUgAygLMhwuaGVhbH'
    'RoY2FyZS5jbGluaWNhbC52MS5Hb2FsUgVnb2FscxJACgphY3Rpdml0aWVzGAYgAygLMiAuaGVh'
    'bHRoY2FyZS5jbGluaWNhbC52MS5BY3Rpdml0eVIKYWN0aXZpdGllcxIZCghvd25lcl9pZBgHIA'
    'EoCVIHb3duZXJJZBI3CglzdGFydHNfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUghzdGFydHNBdBIzCgdlbmRzX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIGZW5kc0F0');

@$core.Deprecated('Use createCarePlanResponseDescriptor instead')
const CreateCarePlanResponse$json = {
  '1': 'CreateCarePlanResponse',
  '2': [
    {
      '1': 'care_plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CarePlan',
      '10': 'carePlan'
    },
  ],
};

/// Descriptor for `CreateCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCarePlanResponseDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVDYXJlUGxhblJlc3BvbnNlEj0KCWNhcmVfcGxhbhgBIAEoCzIgLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuQ2FyZVBsYW5SCGNhcmVQbGFu');

@$core.Deprecated('Use updateCarePlanRequestDescriptor instead')
const UpdateCarePlanRequest$json = {
  '1': 'UpdateCarePlanRequest',
  '2': [
    {'1': 'care_plan_id', '3': 1, '4': 1, '5': 9, '10': 'carePlanId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.CarePlanStatus',
      '10': 'status'
    },
    {
      '1': 'goals',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Goal',
      '10': 'goals'
    },
    {
      '1': 'activities',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Activity',
      '10': 'activities'
    },
    {'1': 'problem_ids', '3': 5, '4': 3, '5': 9, '10': 'problemIds'},
  ],
};

/// Descriptor for `UpdateCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCarePlanRequestDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVDYXJlUGxhblJlcXVlc3QSIAoMY2FyZV9wbGFuX2lkGAEgASgJUgpjYXJlUGxhbk'
    'lkEj4KBnN0YXR1cxgCIAEoDjImLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQ2FyZVBsYW5TdGF0'
    'dXNSBnN0YXR1cxIyCgVnb2FscxgDIAMoCzIcLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuR29hbF'
    'IFZ29hbHMSQAoKYWN0aXZpdGllcxgEIAMoCzIgLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWN0'
    'aXZpdHlSCmFjdGl2aXRpZXMSHwoLcHJvYmxlbV9pZHMYBSADKAlSCnByb2JsZW1JZHM=');

@$core.Deprecated('Use updateCarePlanResponseDescriptor instead')
const UpdateCarePlanResponse$json = {
  '1': 'UpdateCarePlanResponse',
  '2': [
    {
      '1': 'care_plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CarePlan',
      '10': 'carePlan'
    },
  ],
};

/// Descriptor for `UpdateCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateCarePlanResponseDescriptor =
    $convert.base64Decode(
        'ChZVcGRhdGVDYXJlUGxhblJlc3BvbnNlEj0KCWNhcmVfcGxhbhgBIAEoCzIgLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuQ2FyZVBsYW5SCGNhcmVQbGFu');

@$core.Deprecated('Use listCarePlansRequestDescriptor instead')
const ListCarePlansRequest$json = {
  '1': 'ListCarePlansRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCarePlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0Q2FyZVBsYW5zUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSHw'
    'oLYWN0aXZlX29ubHkYAiABKAhSCmFjdGl2ZU9ubHkSGwoJcGFnZV9zaXplGAMgASgFUghwYWdl'
    'U2l6ZQ==');

@$core.Deprecated('Use listCarePlansResponseDescriptor instead')
const ListCarePlansResponse$json = {
  '1': 'ListCarePlansResponse',
  '2': [
    {
      '1': 'care_plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CarePlan',
      '10': 'carePlans'
    },
  ],
};

/// Descriptor for `ListCarePlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2FyZVBsYW5zUmVzcG9uc2USPwoKY2FyZV9wbGFucxgBIAMoCzIgLmhlYWx0aGNhcm'
    'UuY2xpbmljYWwudjEuQ2FyZVBsYW5SCWNhcmVQbGFucw==');

@$core.Deprecated('Use getBannerRequestDescriptor instead')
const GetBannerRequest$json = {
  '1': 'GetBannerRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'encounter_context',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'encounterContext'
    },
  ],
};

/// Descriptor for `GetBannerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBannerRequestDescriptor = $convert.base64Decode(
    'ChBHZXRCYW5uZXJSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIrChFlbm'
    'NvdW50ZXJfY29udGV4dBgCIAEoCVIQZW5jb3VudGVyQ29udGV4dA==');

@$core.Deprecated('Use getBannerResponseDescriptor instead')
const GetBannerResponse$json = {
  '1': 'GetBannerResponse',
  '2': [
    {
      '1': 'banner',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Banner',
      '10': 'banner'
    },
  ],
};

/// Descriptor for `GetBannerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBannerResponseDescriptor = $convert.base64Decode(
    'ChFHZXRCYW5uZXJSZXNwb25zZRI2CgZiYW5uZXIYASABKAsyHi5oZWFsdGhjYXJlLmNsaW5pY2'
    'FsLnYxLkJhbm5lclIGYmFubmVy');

@$core.Deprecated('Use recordConsentRequestDescriptor instead')
const RecordConsentRequest$json = {
  '1': 'RecordConsentRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentKind',
      '10': 'kind'
    },
    {
      '1': 'procedure_code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Coding',
      '10': 'procedureCode'
    },
    {
      '1': 'status',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentStatus',
      '10': 'status'
    },
    {
      '1': 'given_by',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentGiver',
      '10': 'givenBy'
    },
    {'1': 'given_by_name', '3': 7, '4': 1, '5': 9, '10': 'givenByName'},
    {'1': 'document_id', '3': 8, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'witness_id', '3': 9, '4': 1, '5': 9, '10': 'witnessId'},
    {
      '1': 'valid_from',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validFrom'
    },
    {
      '1': 'valid_until',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'validUntil'
    },
    {'1': 'note', '3': 12, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordConsentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordConsentRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRDb25zZW50UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQ'
    'oMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBI3CgRraW5kGAMgASgOMiMuaGVhbHRo'
    'Y2FyZS5jbGluaWNhbC52MS5Db25zZW50S2luZFIEa2luZBJFCg5wcm9jZWR1cmVfY29kZRgEIA'
    'EoCzIeLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQ29kaW5nUg1wcm9jZWR1cmVDb2RlEj0KBnN0'
    'YXR1cxgFIAEoDjIlLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQ29uc2VudFN0YXR1c1IGc3RhdH'
    'VzEj8KCGdpdmVuX2J5GAYgASgOMiQuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db25zZW50R2l2'
    'ZXJSB2dpdmVuQnkSIgoNZ2l2ZW5fYnlfbmFtZRgHIAEoCVILZ2l2ZW5CeU5hbWUSHwoLZG9jdW'
    '1lbnRfaWQYCCABKAlSCmRvY3VtZW50SWQSHQoKd2l0bmVzc19pZBgJIAEoCVIJd2l0bmVzc0lk'
    'EjkKCnZhbGlkX2Zyb20YCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl2YWxpZE'
    'Zyb20SOwoLdmFsaWRfdW50aWwYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgp2'
    'YWxpZFVudGlsEhIKBG5vdGUYDCABKAlSBG5vdGU=');

@$core.Deprecated('Use recordConsentResponseDescriptor instead')
const RecordConsentResponse$json = {
  '1': 'RecordConsentResponse',
  '2': [
    {
      '1': 'consent',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.ClinicalConsent',
      '10': 'consent'
    },
  ],
};

/// Descriptor for `RecordConsentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordConsentResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRDb25zZW50UmVzcG9uc2USQQoHY29uc2VudBgBIAEoCzInLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQ2xpbmljYWxDb25zZW50Ugdjb25zZW50');

@$core.Deprecated('Use withdrawConsentRequestDescriptor instead')
const WithdrawConsentRequest$json = {
  '1': 'WithdrawConsentRequest',
  '2': [
    {'1': 'consent_id', '3': 1, '4': 1, '5': 9, '10': 'consentId'},
  ],
};

/// Descriptor for `WithdrawConsentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawConsentRequestDescriptor =
    $convert.base64Decode(
        'ChZXaXRoZHJhd0NvbnNlbnRSZXF1ZXN0Eh0KCmNvbnNlbnRfaWQYASABKAlSCWNvbnNlbnRJZA'
        '==');

@$core.Deprecated('Use withdrawConsentResponseDescriptor instead')
const WithdrawConsentResponse$json = {
  '1': 'WithdrawConsentResponse',
};

/// Descriptor for `WithdrawConsentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawConsentResponseDescriptor =
    $convert.base64Decode('ChdXaXRoZHJhd0NvbnNlbnRSZXNwb25zZQ==');

@$core.Deprecated('Use listConsentsRequestDescriptor instead')
const ListConsentsRequest$json = {
  '1': 'ListConsentsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsentKind',
      '10': 'kind'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListConsentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConsentsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q29uc2VudHNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBI3Cg'
    'RraW5kGAIgASgOMiMuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Db25zZW50S2luZFIEa2luZBIb'
    'CglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listConsentsResponseDescriptor instead')
const ListConsentsResponse$json = {
  '1': 'ListConsentsResponse',
  '2': [
    {
      '1': 'consents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.ClinicalConsent',
      '10': 'consents'
    },
  ],
};

/// Descriptor for `ListConsentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConsentsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0Q29uc2VudHNSZXNwb25zZRJDCghjb25zZW50cxgBIAMoCzInLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQ2xpbmljYWxDb25zZW50Ughjb25zZW50cw==');

@$core.Deprecated('Use attachFileRequestDescriptor instead')
const AttachFileRequest$json = {
  '1': 'AttachFileRequest',
  '2': [
    {'1': 'parent_type', '3': 1, '4': 1, '5': 9, '10': 'parentType'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AttachmentKind',
      '10': 'kind'
    },
    {'1': 'content_type', '3': 5, '4': 1, '5': 9, '10': 'contentType'},
    {
      '1': 'storage_key',
      '3': 6,
      '4': 1,
      '5': 9,
      '8': {'3': true},
      '10': 'storageKey',
    },
    {
      '1': 'size_bytes',
      '3': 7,
      '4': 1,
      '5': 3,
      '8': {'3': true},
      '10': 'sizeBytes',
    },
    {
      '1': 'digest',
      '3': 8,
      '4': 1,
      '5': 9,
      '8': {'3': true},
      '10': 'digest',
    },
    {'1': 'description', '3': 9, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'confidentiality',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.Confidentiality',
      '10': 'confidentiality'
    },
    {
      '1': 'captured_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {'1': 'source_system', '3': 12, '4': 1, '5': 9, '10': 'sourceSystem'},
    {
      '1': 'provenance',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Provenance',
      '10': 'provenance'
    },
    {'1': 'content', '3': 14, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `AttachFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachFileRequestDescriptor = $convert.base64Decode(
    'ChFBdHRhY2hGaWxlUmVxdWVzdBIfCgtwYXJlbnRfdHlwZRgBIAEoCVIKcGFyZW50VHlwZRIbCg'
    'lwYXJlbnRfaWQYAiABKAlSCHBhcmVudElkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJ'
    'ZBI6CgRraW5kGAQgASgOMiYuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BdHRhY2htZW50S2luZF'
    'IEa2luZBIhCgxjb250ZW50X3R5cGUYBSABKAlSC2NvbnRlbnRUeXBlEiMKC3N0b3JhZ2Vfa2V5'
    'GAYgASgJQgIYAVIKc3RvcmFnZUtleRIhCgpzaXplX2J5dGVzGAcgASgDQgIYAVIJc2l6ZUJ5dG'
    'VzEhoKBmRpZ2VzdBgIIAEoCUICGAFSBmRpZ2VzdBIgCgtkZXNjcmlwdGlvbhgJIAEoCVILZGVz'
    'Y3JpcHRpb24SUQoPY29uZmlkZW50aWFsaXR5GAogASgOMicuaGVhbHRoY2FyZS5jbGluaWNhbC'
    '52MS5Db25maWRlbnRpYWxpdHlSD2NvbmZpZGVudGlhbGl0eRI7CgtjYXB0dXJlZF9hdBgLIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNhcHR1cmVkQXQSIwoNc291cmNlX3N5c3'
    'RlbRgMIAEoCVIMc291cmNlU3lzdGVtEkIKCnByb3ZlbmFuY2UYDSABKAsyIi5oZWFsdGhjYXJl'
    'LmNsaW5pY2FsLnYxLlByb3ZlbmFuY2VSCnByb3ZlbmFuY2USGAoHY29udGVudBgOIAEoDFIHY2'
    '9udGVudA==');

@$core.Deprecated('Use attachFileResponseDescriptor instead')
const AttachFileResponse$json = {
  '1': 'AttachFileResponse',
  '2': [
    {
      '1': 'attachment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Attachment',
      '10': 'attachment'
    },
  ],
};

/// Descriptor for `AttachFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachFileResponseDescriptor = $convert.base64Decode(
    'ChJBdHRhY2hGaWxlUmVzcG9uc2USQgoKYXR0YWNobWVudBgBIAEoCzIiLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQXR0YWNobWVudFIKYXR0YWNobWVudA==');

@$core.Deprecated('Use listAttachmentsRequestDescriptor instead')
const ListAttachmentsRequest$json = {
  '1': 'ListAttachmentsRequest',
  '2': [
    {'1': 'parent_type', '3': 1, '4': 1, '5': 9, '10': 'parentType'},
    {'1': 'parent_id', '3': 2, '4': 1, '5': 9, '10': 'parentId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAttachmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAttachmentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QXR0YWNobWVudHNSZXF1ZXN0Eh8KC3BhcmVudF90eXBlGAEgASgJUgpwYXJlbnRUeX'
    'BlEhsKCXBhcmVudF9pZBgCIAEoCVIIcGFyZW50SWQSGwoJcGFnZV9zaXplGAMgASgFUghwYWdl'
    'U2l6ZQ==');

@$core.Deprecated('Use listAttachmentsResponseDescriptor instead')
const ListAttachmentsResponse$json = {
  '1': 'ListAttachmentsResponse',
  '2': [
    {
      '1': 'attachments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Attachment',
      '10': 'attachments'
    },
  ],
};

/// Descriptor for `ListAttachmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAttachmentsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QXR0YWNobWVudHNSZXNwb25zZRJECgthdHRhY2htZW50cxgBIAMoCzIiLmhlYWx0aG'
        'NhcmUuY2xpbmljYWwudjEuQXR0YWNobWVudFILYXR0YWNobWVudHM=');

@$core.Deprecated('Use getProvenanceRequestDescriptor instead')
const GetProvenanceRequest$json = {
  '1': 'GetProvenanceRequest',
  '2': [
    {'1': 'record_type', '3': 1, '4': 1, '5': 9, '10': 'recordType'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
  ],
};

/// Descriptor for `GetProvenanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProvenanceRequestDescriptor = $convert.base64Decode(
    'ChRHZXRQcm92ZW5hbmNlUmVxdWVzdBIfCgtyZWNvcmRfdHlwZRgBIAEoCVIKcmVjb3JkVHlwZR'
    'IbCglyZWNvcmRfaWQYAiABKAlSCHJlY29yZElk');

@$core.Deprecated('Use getProvenanceResponseDescriptor instead')
const GetProvenanceResponse$json = {
  '1': 'GetProvenanceResponse',
  '2': [
    {
      '1': 'provenance',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Provenance',
      '10': 'provenance'
    },
  ],
};

/// Descriptor for `GetProvenanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProvenanceResponseDescriptor = $convert.base64Decode(
    'ChVHZXRQcm92ZW5hbmNlUmVzcG9uc2USQgoKcHJvdmVuYW5jZRgBIAMoCzIiLmhlYWx0aGNhcm'
    'UuY2xpbmljYWwudjEuUHJvdmVuYW5jZVIKcHJvdmVuYW5jZQ==');

@$core.Deprecated('Use storeCalculationRequestDescriptor instead')
const StoreCalculationRequest$json = {
  '1': 'StoreCalculationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'calculator_id', '3': 3, '4': 1, '5': 9, '10': 'calculatorId'},
    {'1': 'formula_version', '3': 4, '4': 1, '5': 9, '10': 'formulaVersion'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'inputs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CalculatorInput',
      '10': 'inputs'
    },
    {'1': 'value', '3': 7, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 8, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'interpretation', '3': 9, '4': 1, '5': 9, '10': 'interpretation'},
    {'1': 'supersedes_id', '3': 10, '4': 1, '5': 9, '10': 'supersedesId'},
  ],
};

/// Descriptor for `StoreCalculationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeCalculationRequestDescriptor = $convert.base64Decode(
    'ChdTdG9yZUNhbGN1bGF0aW9uUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIjCg1jYWxjdWxhdG9yX2lkGAMg'
    'ASgJUgxjYWxjdWxhdG9ySWQSJwoPZm9ybXVsYV92ZXJzaW9uGAQgASgJUg5mb3JtdWxhVmVyc2'
    'lvbhISCgRuYW1lGAUgASgJUgRuYW1lEj8KBmlucHV0cxgGIAMoCzInLmhlYWx0aGNhcmUuY2xp'
    'bmljYWwudjEuQ2FsY3VsYXRvcklucHV0UgZpbnB1dHMSFAoFdmFsdWUYByABKAFSBXZhbHVlEh'
    'IKBHVuaXQYCCABKAlSBHVuaXQSJgoOaW50ZXJwcmV0YXRpb24YCSABKAlSDmludGVycHJldGF0'
    'aW9uEiMKDXN1cGVyc2VkZXNfaWQYCiABKAlSDHN1cGVyc2VkZXNJZA==');

@$core.Deprecated('Use storeCalculationResponseDescriptor instead')
const StoreCalculationResponse$json = {
  '1': 'StoreCalculationResponse',
  '2': [
    {
      '1': 'result',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CalculatorResult',
      '10': 'result'
    },
  ],
};

/// Descriptor for `StoreCalculationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storeCalculationResponseDescriptor =
    $convert.base64Decode(
        'ChhTdG9yZUNhbGN1bGF0aW9uUmVzcG9uc2USQAoGcmVzdWx0GAEgASgLMiguaGVhbHRoY2FyZS'
        '5jbGluaWNhbC52MS5DYWxjdWxhdG9yUmVzdWx0UgZyZXN1bHQ=');

@$core.Deprecated('Use listCalculationsRequestDescriptor instead')
const ListCalculationsRequest$json = {
  '1': 'ListCalculationsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'calculator_id', '3': 2, '4': 1, '5': 9, '10': 'calculatorId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCalculationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCalculationsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Q2FsY3VsYXRpb25zUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIwoNY2FsY3VsYXRvcl9pZBgCIAEoCVIMY2FsY3VsYXRvcklkEhsKCXBhZ2Vfc2l6ZRgDIAEo'
    'BVIIcGFnZVNpemU=');

@$core.Deprecated('Use listCalculationsResponseDescriptor instead')
const ListCalculationsResponse$json = {
  '1': 'ListCalculationsResponse',
  '2': [
    {
      '1': 'results',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CalculatorResult',
      '10': 'results'
    },
  ],
};

/// Descriptor for `ListCalculationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCalculationsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0Q2FsY3VsYXRpb25zUmVzcG9uc2USQgoHcmVzdWx0cxgBIAMoCzIoLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuQ2FsY3VsYXRvclJlc3VsdFIHcmVzdWx0cw==');

@$core.Deprecated('Use raiseAlertRequestDescriptor instead')
const RaiseAlertRequest$json = {
  '1': 'RaiseAlertRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'rule_id', '3': 3, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'rule_version', '3': 4, '4': 1, '5': 9, '10': 'ruleVersion'},
    {
      '1': 'level',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AlertLevel',
      '10': 'level'
    },
    {'1': 'message', '3': 6, '4': 1, '5': 9, '10': 'message'},
    {'1': 'context_type', '3': 7, '4': 1, '5': 9, '10': 'contextType'},
    {'1': 'context_id', '3': 8, '4': 1, '5': 9, '10': 'contextId'},
  ],
};

/// Descriptor for `RaiseAlertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseAlertRequestDescriptor = $convert.base64Decode(
    'ChFSYWlzZUFsZXJ0UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIXCgdydWxlX2lkGAMgASgJUgZydWxlSWQS'
    'IQoMcnVsZV92ZXJzaW9uGAQgASgJUgtydWxlVmVyc2lvbhI4CgVsZXZlbBgFIAEoDjIiLmhlYW'
    'x0aGNhcmUuY2xpbmljYWwudjEuQWxlcnRMZXZlbFIFbGV2ZWwSGAoHbWVzc2FnZRgGIAEoCVIH'
    'bWVzc2FnZRIhCgxjb250ZXh0X3R5cGUYByABKAlSC2NvbnRleHRUeXBlEh0KCmNvbnRleHRfaW'
    'QYCCABKAlSCWNvbnRleHRJZA==');

@$core.Deprecated('Use raiseAlertResponseDescriptor instead')
const RaiseAlertResponse$json = {
  '1': 'RaiseAlertResponse',
  '2': [
    {
      '1': 'alert',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CDSAlert',
      '10': 'alert'
    },
  ],
};

/// Descriptor for `RaiseAlertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseAlertResponseDescriptor = $convert.base64Decode(
    'ChJSYWlzZUFsZXJ0UmVzcG9uc2USNgoFYWxlcnQYASABKAsyIC5oZWFsdGhjYXJlLmNsaW5pY2'
    'FsLnYxLkNEU0FsZXJ0UgVhbGVydA==');

@$core.Deprecated('Use respondToAlertRequestDescriptor instead')
const RespondToAlertRequest$json = {
  '1': 'RespondToAlertRequest',
  '2': [
    {'1': 'alert_id', '3': 1, '4': 1, '5': 9, '10': 'alertId'},
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AlertOutcome',
      '10': 'outcome'
    },
    {'1': 'override_code', '3': 3, '4': 1, '5': 9, '10': 'overrideCode'},
    {'1': 'override_reason', '3': 4, '4': 1, '5': 9, '10': 'overrideReason'},
  ],
};

/// Descriptor for `RespondToAlertRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToAlertRequestDescriptor = $convert.base64Decode(
    'ChVSZXNwb25kVG9BbGVydFJlcXVlc3QSGQoIYWxlcnRfaWQYASABKAlSB2FsZXJ0SWQSPgoHb3'
    'V0Y29tZRgCIAEoDjIkLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWxlcnRPdXRjb21lUgdvdXRj'
    'b21lEiMKDW92ZXJyaWRlX2NvZGUYAyABKAlSDG92ZXJyaWRlQ29kZRInCg9vdmVycmlkZV9yZW'
    'Fzb24YBCABKAlSDm92ZXJyaWRlUmVhc29u');

@$core.Deprecated('Use respondToAlertResponseDescriptor instead')
const RespondToAlertResponse$json = {
  '1': 'RespondToAlertResponse',
  '2': [
    {
      '1': 'alert',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.CDSAlert',
      '10': 'alert'
    },
  ],
};

/// Descriptor for `RespondToAlertResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToAlertResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXNwb25kVG9BbGVydFJlc3BvbnNlEjYKBWFsZXJ0GAEgASgLMiAuaGVhbHRoY2FyZS5jbG'
        'luaWNhbC52MS5DRFNBbGVydFIFYWxlcnQ=');

@$core.Deprecated('Use listAlertsRequestDescriptor instead')
const ListAlertsRequest$json = {
  '1': 'ListAlertsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.AlertOutcome',
      '10': 'outcome'
    },
    {'1': 'rule_id', '3': 3, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QWxlcnRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSPgoHb3'
    'V0Y29tZRgCIAEoDjIkLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWxlcnRPdXRjb21lUgdvdXRj'
    'b21lEhcKB3J1bGVfaWQYAyABKAlSBnJ1bGVJZBIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaX'
    'pl');

@$core.Deprecated('Use listAlertsResponseDescriptor instead')
const ListAlertsResponse$json = {
  '1': 'ListAlertsResponse',
  '2': [
    {
      '1': 'alerts',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.CDSAlert',
      '10': 'alerts'
    },
  ],
};

/// Descriptor for `ListAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAlertsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QWxlcnRzUmVzcG9uc2USOAoGYWxlcnRzGAEgAygLMiAuaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5DRFNBbGVydFIGYWxlcnRz');

@$core.Deprecated('Use requestConsultRequestDescriptor instead')
const RequestConsultRequest$json = {
  '1': 'RequestConsultRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'specialty', '3': 3, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'urgency',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.clinical.v1.ConsultUrgency',
      '10': 'urgency'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'question', '3': 6, '4': 1, '5': 9, '10': 'question'},
  ],
};

/// Descriptor for `RequestConsultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConsultRequestDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0Q29uc3VsdFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSHAoJc3BlY2lhbHR5GAMgASgJUglz'
    'cGVjaWFsdHkSQAoHdXJnZW5jeRgEIAEoDjImLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQ29uc3'
    'VsdFVyZ2VuY3lSB3VyZ2VuY3kSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SGgoIcXVlc3Rpb24Y'
    'BiABKAlSCHF1ZXN0aW9u');

@$core.Deprecated('Use requestConsultResponseDescriptor instead')
const RequestConsultResponse$json = {
  '1': 'RequestConsultResponse',
  '2': [
    {
      '1': 'consult',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Consult',
      '10': 'consult'
    },
  ],
};

/// Descriptor for `RequestConsultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestConsultResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0Q29uc3VsdFJlc3BvbnNlEjkKB2NvbnN1bHQYASABKAsyHy5oZWFsdGhjYXJlLm'
        'NsaW5pY2FsLnYxLkNvbnN1bHRSB2NvbnN1bHQ=');

@$core.Deprecated('Use respondToConsultRequestDescriptor instead')
const RespondToConsultRequest$json = {
  '1': 'RespondToConsultRequest',
  '2': [
    {'1': 'consult_id', '3': 1, '4': 1, '5': 9, '10': 'consultId'},
    {'1': 'accept', '3': 2, '4': 1, '5': 8, '10': 'accept'},
    {'1': 'response', '3': 3, '4': 1, '5': 9, '10': 'response'},
    {
      '1': 'response_document_id',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'responseDocumentId'
    },
    {'1': 'decline_reason', '3': 5, '4': 1, '5': 9, '10': 'declineReason'},
  ],
};

/// Descriptor for `RespondToConsultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToConsultRequestDescriptor = $convert.base64Decode(
    'ChdSZXNwb25kVG9Db25zdWx0UmVxdWVzdBIdCgpjb25zdWx0X2lkGAEgASgJUgljb25zdWx0SW'
    'QSFgoGYWNjZXB0GAIgASgIUgZhY2NlcHQSGgoIcmVzcG9uc2UYAyABKAlSCHJlc3BvbnNlEjAK'
    'FHJlc3BvbnNlX2RvY3VtZW50X2lkGAQgASgJUhJyZXNwb25zZURvY3VtZW50SWQSJQoOZGVjbG'
    'luZV9yZWFzb24YBSABKAlSDWRlY2xpbmVSZWFzb24=');

@$core.Deprecated('Use respondToConsultResponseDescriptor instead')
const RespondToConsultResponse$json = {
  '1': 'RespondToConsultResponse',
  '2': [
    {
      '1': 'consult',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.Consult',
      '10': 'consult'
    },
  ],
};

/// Descriptor for `RespondToConsultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List respondToConsultResponseDescriptor =
    $convert.base64Decode(
        'ChhSZXNwb25kVG9Db25zdWx0UmVzcG9uc2USOQoHY29uc3VsdBgBIAEoCzIfLmhlYWx0aGNhcm'
        'UuY2xpbmljYWwudjEuQ29uc3VsdFIHY29uc3VsdA==');

@$core.Deprecated('Use listConsultsRequestDescriptor instead')
const ListConsultsRequest$json = {
  '1': 'ListConsultsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'specialty', '3': 2, '4': 1, '5': 9, '10': 'specialty'},
    {'1': 'open_only', '3': 3, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListConsultsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConsultsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q29uc3VsdHNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIcCg'
    'lzcGVjaWFsdHkYAiABKAlSCXNwZWNpYWx0eRIbCglvcGVuX29ubHkYAyABKAhSCG9wZW5Pbmx5'
    'EhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listConsultsResponseDescriptor instead')
const ListConsultsResponse$json = {
  '1': 'ListConsultsResponse',
  '2': [
    {
      '1': 'consults',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.Consult',
      '10': 'consults'
    },
  ],
};

/// Descriptor for `ListConsultsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listConsultsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0Q29uc3VsdHNSZXNwb25zZRI7Cghjb25zdWx0cxgBIAMoCzIfLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuQ29uc3VsdFIIY29uc3VsdHM=');

@$core.Deprecated('Use enrolInRegistryRequestDescriptor instead')
const EnrolInRegistryRequest$json = {
  '1': 'EnrolInRegistryRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'registry_id', '3': 2, '4': 1, '5': 9, '10': 'registryId'},
    {'1': 'problem_id', '3': 3, '4': 1, '5': 9, '10': 'problemId'},
    {'1': 'diagnosis_id', '3': 4, '4': 1, '5': 9, '10': 'diagnosisId'},
    {
      '1': 'enrolled_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'enrolledAt'
    },
    {'1': 'consented', '3': 6, '4': 1, '5': 8, '10': 'consented'},
  ],
};

/// Descriptor for `EnrolInRegistryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enrolInRegistryRequestDescriptor = $convert.base64Decode(
    'ChZFbnJvbEluUmVnaXN0cnlSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IfCgtyZWdpc3RyeV9pZBgCIAEoCVIKcmVnaXN0cnlJZBIdCgpwcm9ibGVtX2lkGAMgASgJUglw'
    'cm9ibGVtSWQSIQoMZGlhZ25vc2lzX2lkGAQgASgJUgtkaWFnbm9zaXNJZBI7CgtlbnJvbGxlZF'
    '9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmVucm9sbGVkQXQSHAoJY29u'
    'c2VudGVkGAYgASgIUgljb25zZW50ZWQ=');

@$core.Deprecated('Use enrolInRegistryResponseDescriptor instead')
const EnrolInRegistryResponse$json = {
  '1': 'EnrolInRegistryResponse',
  '2': [
    {
      '1': 'membership',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.clinical.v1.RegistryMembership',
      '10': 'membership'
    },
  ],
};

/// Descriptor for `EnrolInRegistryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List enrolInRegistryResponseDescriptor =
    $convert.base64Decode(
        'ChdFbnJvbEluUmVnaXN0cnlSZXNwb25zZRJKCgptZW1iZXJzaGlwGAEgASgLMiouaGVhbHRoY2'
        'FyZS5jbGluaWNhbC52MS5SZWdpc3RyeU1lbWJlcnNoaXBSCm1lbWJlcnNoaXA=');

@$core.Deprecated('Use exitRegistryRequestDescriptor instead')
const ExitRegistryRequest$json = {
  '1': 'ExitRegistryRequest',
  '2': [
    {'1': 'membership_id', '3': 1, '4': 1, '5': 9, '10': 'membershipId'},
    {
      '1': 'exited_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'exitedAt'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ExitRegistryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exitRegistryRequestDescriptor = $convert.base64Decode(
    'ChNFeGl0UmVnaXN0cnlSZXF1ZXN0EiMKDW1lbWJlcnNoaXBfaWQYASABKAlSDG1lbWJlcnNoaX'
    'BJZBI3CglleGl0ZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghleGl0'
    'ZWRBdBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use exitRegistryResponseDescriptor instead')
const ExitRegistryResponse$json = {
  '1': 'ExitRegistryResponse',
};

/// Descriptor for `ExitRegistryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exitRegistryResponseDescriptor =
    $convert.base64Decode('ChRFeGl0UmVnaXN0cnlSZXNwb25zZQ==');

@$core.Deprecated('Use listRegistryMembershipsRequestDescriptor instead')
const ListRegistryMembershipsRequest$json = {
  '1': 'ListRegistryMembershipsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'registry_id', '3': 2, '4': 1, '5': 9, '10': 'registryId'},
    {'1': 'current_only', '3': 3, '4': 1, '5': 8, '10': 'currentOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListRegistryMembershipsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRegistryMembershipsRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0UmVnaXN0cnlNZW1iZXJzaGlwc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcG'
        'F0aWVudElkEh8KC3JlZ2lzdHJ5X2lkGAIgASgJUgpyZWdpc3RyeUlkEiEKDGN1cnJlbnRfb25s'
        'eRgDIAEoCFILY3VycmVudE9ubHkSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listRegistryMembershipsResponseDescriptor instead')
const ListRegistryMembershipsResponse$json = {
  '1': 'ListRegistryMembershipsResponse',
  '2': [
    {
      '1': 'memberships',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.clinical.v1.RegistryMembership',
      '10': 'memberships'
    },
  ],
};

/// Descriptor for `ListRegistryMembershipsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRegistryMembershipsResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0UmVnaXN0cnlNZW1iZXJzaGlwc1Jlc3BvbnNlEkwKC21lbWJlcnNoaXBzGAEgAygLMi'
        'ouaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZWdpc3RyeU1lbWJlcnNoaXBSC21lbWJlcnNoaXBz');

const $core.Map<$core.String, $core.dynamic> ClinicalServiceBase$json = {
  '1': 'ClinicalService',
  '2': [
    {
      '1': 'WriteNote',
      '2': '.healthcare.clinical.v1.WriteNoteRequest',
      '3': '.healthcare.clinical.v1.WriteNoteResponse'
    },
    {
      '1': 'SignNote',
      '2': '.healthcare.clinical.v1.SignNoteRequest',
      '3': '.healthcare.clinical.v1.SignNoteResponse'
    },
    {
      '1': 'AmendNote',
      '2': '.healthcare.clinical.v1.AmendNoteRequest',
      '3': '.healthcare.clinical.v1.AmendNoteResponse'
    },
    {
      '1': 'RetractNote',
      '2': '.healthcare.clinical.v1.RetractNoteRequest',
      '3': '.healthcare.clinical.v1.RetractNoteResponse'
    },
    {
      '1': 'GetNote',
      '2': '.healthcare.clinical.v1.GetNoteRequest',
      '3': '.healthcare.clinical.v1.GetNoteResponse'
    },
    {
      '1': 'ListNotes',
      '2': '.healthcare.clinical.v1.ListNotesRequest',
      '3': '.healthcare.clinical.v1.ListNotesResponse'
    },
    {
      '1': 'DefineTemplate',
      '2': '.healthcare.clinical.v1.DefineTemplateRequest',
      '3': '.healthcare.clinical.v1.DefineTemplateResponse'
    },
    {
      '1': 'ListTemplates',
      '2': '.healthcare.clinical.v1.ListTemplatesRequest',
      '3': '.healthcare.clinical.v1.ListTemplatesResponse'
    },
    {
      '1': 'RetireTemplate',
      '2': '.healthcare.clinical.v1.RetireTemplateRequest',
      '3': '.healthcare.clinical.v1.RetireTemplateResponse'
    },
    {
      '1': 'DefineSmartPhrase',
      '2': '.healthcare.clinical.v1.DefineSmartPhraseRequest',
      '3': '.healthcare.clinical.v1.DefineSmartPhraseResponse'
    },
    {
      '1': 'ListSmartPhrases',
      '2': '.healthcare.clinical.v1.ListSmartPhrasesRequest',
      '3': '.healthcare.clinical.v1.ListSmartPhrasesResponse'
    },
    {
      '1': 'RecordProblem',
      '2': '.healthcare.clinical.v1.RecordProblemRequest',
      '3': '.healthcare.clinical.v1.RecordProblemResponse'
    },
    {
      '1': 'UpdateProblem',
      '2': '.healthcare.clinical.v1.UpdateProblemRequest',
      '3': '.healthcare.clinical.v1.UpdateProblemResponse'
    },
    {
      '1': 'ListProblems',
      '2': '.healthcare.clinical.v1.ListProblemsRequest',
      '3': '.healthcare.clinical.v1.ListProblemsResponse'
    },
    {
      '1': 'RecordAllergy',
      '2': '.healthcare.clinical.v1.RecordAllergyRequest',
      '3': '.healthcare.clinical.v1.RecordAllergyResponse'
    },
    {
      '1': 'VerifyAllergy',
      '2': '.healthcare.clinical.v1.VerifyAllergyRequest',
      '3': '.healthcare.clinical.v1.VerifyAllergyResponse'
    },
    {
      '1': 'ListAllergies',
      '2': '.healthcare.clinical.v1.ListAllergiesRequest',
      '3': '.healthcare.clinical.v1.ListAllergiesResponse'
    },
    {
      '1': 'RecordObservation',
      '2': '.healthcare.clinical.v1.RecordObservationRequest',
      '3': '.healthcare.clinical.v1.RecordObservationResponse'
    },
    {
      '1': 'ListObservations',
      '2': '.healthcare.clinical.v1.ListObservationsRequest',
      '3': '.healthcare.clinical.v1.ListObservationsResponse'
    },
    {
      '1': 'ListCriticalResults',
      '2': '.healthcare.clinical.v1.ListCriticalResultsRequest',
      '3': '.healthcare.clinical.v1.ListCriticalResultsResponse'
    },
    {
      '1': 'AcknowledgeCriticalResult',
      '2': '.healthcare.clinical.v1.AcknowledgeCriticalResultRequest',
      '3': '.healthcare.clinical.v1.AcknowledgeCriticalResultResponse'
    },
    {
      '1': 'RecordProcedure',
      '2': '.healthcare.clinical.v1.RecordProcedureRequest',
      '3': '.healthcare.clinical.v1.RecordProcedureResponse'
    },
    {
      '1': 'ListProcedures',
      '2': '.healthcare.clinical.v1.ListProceduresRequest',
      '3': '.healthcare.clinical.v1.ListProceduresResponse'
    },
    {
      '1': 'CreateCarePlan',
      '2': '.healthcare.clinical.v1.CreateCarePlanRequest',
      '3': '.healthcare.clinical.v1.CreateCarePlanResponse'
    },
    {
      '1': 'UpdateCarePlan',
      '2': '.healthcare.clinical.v1.UpdateCarePlanRequest',
      '3': '.healthcare.clinical.v1.UpdateCarePlanResponse'
    },
    {
      '1': 'ListCarePlans',
      '2': '.healthcare.clinical.v1.ListCarePlansRequest',
      '3': '.healthcare.clinical.v1.ListCarePlansResponse'
    },
    {
      '1': 'GetBanner',
      '2': '.healthcare.clinical.v1.GetBannerRequest',
      '3': '.healthcare.clinical.v1.GetBannerResponse'
    },
    {
      '1': 'RecordConsent',
      '2': '.healthcare.clinical.v1.RecordConsentRequest',
      '3': '.healthcare.clinical.v1.RecordConsentResponse'
    },
    {
      '1': 'WithdrawConsent',
      '2': '.healthcare.clinical.v1.WithdrawConsentRequest',
      '3': '.healthcare.clinical.v1.WithdrawConsentResponse'
    },
    {
      '1': 'ListConsents',
      '2': '.healthcare.clinical.v1.ListConsentsRequest',
      '3': '.healthcare.clinical.v1.ListConsentsResponse'
    },
    {
      '1': 'AttachFile',
      '2': '.healthcare.clinical.v1.AttachFileRequest',
      '3': '.healthcare.clinical.v1.AttachFileResponse'
    },
    {
      '1': 'ListAttachments',
      '2': '.healthcare.clinical.v1.ListAttachmentsRequest',
      '3': '.healthcare.clinical.v1.ListAttachmentsResponse'
    },
    {
      '1': 'GetProvenance',
      '2': '.healthcare.clinical.v1.GetProvenanceRequest',
      '3': '.healthcare.clinical.v1.GetProvenanceResponse'
    },
    {
      '1': 'StoreCalculation',
      '2': '.healthcare.clinical.v1.StoreCalculationRequest',
      '3': '.healthcare.clinical.v1.StoreCalculationResponse'
    },
    {
      '1': 'ListCalculations',
      '2': '.healthcare.clinical.v1.ListCalculationsRequest',
      '3': '.healthcare.clinical.v1.ListCalculationsResponse'
    },
    {
      '1': 'RaiseAlert',
      '2': '.healthcare.clinical.v1.RaiseAlertRequest',
      '3': '.healthcare.clinical.v1.RaiseAlertResponse'
    },
    {
      '1': 'RespondToAlert',
      '2': '.healthcare.clinical.v1.RespondToAlertRequest',
      '3': '.healthcare.clinical.v1.RespondToAlertResponse'
    },
    {
      '1': 'ListAlerts',
      '2': '.healthcare.clinical.v1.ListAlertsRequest',
      '3': '.healthcare.clinical.v1.ListAlertsResponse'
    },
    {
      '1': 'RequestConsult',
      '2': '.healthcare.clinical.v1.RequestConsultRequest',
      '3': '.healthcare.clinical.v1.RequestConsultResponse'
    },
    {
      '1': 'RespondToConsult',
      '2': '.healthcare.clinical.v1.RespondToConsultRequest',
      '3': '.healthcare.clinical.v1.RespondToConsultResponse'
    },
    {
      '1': 'ListConsults',
      '2': '.healthcare.clinical.v1.ListConsultsRequest',
      '3': '.healthcare.clinical.v1.ListConsultsResponse'
    },
    {
      '1': 'EnrolInRegistry',
      '2': '.healthcare.clinical.v1.EnrolInRegistryRequest',
      '3': '.healthcare.clinical.v1.EnrolInRegistryResponse'
    },
    {
      '1': 'ExitRegistry',
      '2': '.healthcare.clinical.v1.ExitRegistryRequest',
      '3': '.healthcare.clinical.v1.ExitRegistryResponse'
    },
    {
      '1': 'ListRegistryMemberships',
      '2': '.healthcare.clinical.v1.ListRegistryMembershipsRequest',
      '3': '.healthcare.clinical.v1.ListRegistryMembershipsResponse'
    },
  ],
};

@$core.Deprecated('Use clinicalServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    ClinicalServiceBase$messageJson = {
  '.healthcare.clinical.v1.WriteNoteRequest': WriteNoteRequest$json,
  '.healthcare.clinical.v1.Section': Section$json,
  '.healthcare.clinical.v1.PatientContext': PatientContext$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.clinical.v1.WriteNoteResponse': WriteNoteResponse$json,
  '.healthcare.clinical.v1.Document': Document$json,
  '.healthcare.clinical.v1.Signature': Signature$json,
  '.healthcare.clinical.v1.SignNoteRequest': SignNoteRequest$json,
  '.healthcare.clinical.v1.SignNoteResponse': SignNoteResponse$json,
  '.healthcare.clinical.v1.AmendNoteRequest': AmendNoteRequest$json,
  '.healthcare.clinical.v1.AmendNoteResponse': AmendNoteResponse$json,
  '.healthcare.clinical.v1.RetractNoteRequest': RetractNoteRequest$json,
  '.healthcare.clinical.v1.RetractNoteResponse': RetractNoteResponse$json,
  '.healthcare.clinical.v1.GetNoteRequest': GetNoteRequest$json,
  '.healthcare.clinical.v1.GetNoteResponse': GetNoteResponse$json,
  '.healthcare.clinical.v1.ListNotesRequest': ListNotesRequest$json,
  '.healthcare.clinical.v1.ListNotesResponse': ListNotesResponse$json,
  '.healthcare.clinical.v1.DefineTemplateRequest': DefineTemplateRequest$json,
  '.healthcare.clinical.v1.Template': Template$json,
  '.healthcare.clinical.v1.DefineTemplateResponse': DefineTemplateResponse$json,
  '.healthcare.clinical.v1.ListTemplatesRequest': ListTemplatesRequest$json,
  '.healthcare.clinical.v1.ListTemplatesResponse': ListTemplatesResponse$json,
  '.healthcare.clinical.v1.RetireTemplateRequest': RetireTemplateRequest$json,
  '.healthcare.clinical.v1.RetireTemplateResponse': RetireTemplateResponse$json,
  '.healthcare.clinical.v1.DefineSmartPhraseRequest':
      DefineSmartPhraseRequest$json,
  '.healthcare.clinical.v1.DefineSmartPhraseResponse':
      DefineSmartPhraseResponse$json,
  '.healthcare.clinical.v1.SmartPhrase': SmartPhrase$json,
  '.healthcare.clinical.v1.ListSmartPhrasesRequest':
      ListSmartPhrasesRequest$json,
  '.healthcare.clinical.v1.ListSmartPhrasesResponse':
      ListSmartPhrasesResponse$json,
  '.healthcare.clinical.v1.RecordProblemRequest': RecordProblemRequest$json,
  '.healthcare.clinical.v1.Coding': Coding$json,
  '.healthcare.clinical.v1.RecordProblemResponse': RecordProblemResponse$json,
  '.healthcare.clinical.v1.Problem': Problem$json,
  '.healthcare.clinical.v1.UpdateProblemRequest': UpdateProblemRequest$json,
  '.healthcare.clinical.v1.UpdateProblemResponse': UpdateProblemResponse$json,
  '.healthcare.clinical.v1.ListProblemsRequest': ListProblemsRequest$json,
  '.healthcare.clinical.v1.ListProblemsResponse': ListProblemsResponse$json,
  '.healthcare.clinical.v1.RecordAllergyRequest': RecordAllergyRequest$json,
  '.healthcare.clinical.v1.Reaction': Reaction$json,
  '.healthcare.clinical.v1.RecordAllergyResponse': RecordAllergyResponse$json,
  '.healthcare.clinical.v1.Allergy': Allergy$json,
  '.healthcare.clinical.v1.VerifyAllergyRequest': VerifyAllergyRequest$json,
  '.healthcare.clinical.v1.VerifyAllergyResponse': VerifyAllergyResponse$json,
  '.healthcare.clinical.v1.ListAllergiesRequest': ListAllergiesRequest$json,
  '.healthcare.clinical.v1.ListAllergiesResponse': ListAllergiesResponse$json,
  '.healthcare.clinical.v1.RecordObservationRequest':
      RecordObservationRequest$json,
  '.healthcare.clinical.v1.Quantity': Quantity$json,
  '.healthcare.clinical.v1.Provenance': Provenance$json,
  '.healthcare.clinical.v1.RecordObservationResponse':
      RecordObservationResponse$json,
  '.healthcare.clinical.v1.Observation': Observation$json,
  '.healthcare.clinical.v1.ListObservationsRequest':
      ListObservationsRequest$json,
  '.healthcare.clinical.v1.ListObservationsResponse':
      ListObservationsResponse$json,
  '.healthcare.clinical.v1.ListCriticalResultsRequest':
      ListCriticalResultsRequest$json,
  '.healthcare.clinical.v1.ListCriticalResultsResponse':
      ListCriticalResultsResponse$json,
  '.healthcare.clinical.v1.CriticalResult': CriticalResult$json,
  '.healthcare.clinical.v1.AcknowledgeCriticalResultRequest':
      AcknowledgeCriticalResultRequest$json,
  '.healthcare.clinical.v1.AcknowledgeCriticalResultResponse':
      AcknowledgeCriticalResultResponse$json,
  '.healthcare.clinical.v1.CriticalAcknowledgement':
      CriticalAcknowledgement$json,
  '.healthcare.clinical.v1.RecordProcedureRequest': RecordProcedureRequest$json,
  '.healthcare.clinical.v1.Performer': Performer$json,
  '.healthcare.clinical.v1.RecordProcedureResponse':
      RecordProcedureResponse$json,
  '.healthcare.clinical.v1.Procedure': Procedure$json,
  '.healthcare.clinical.v1.ListProceduresRequest': ListProceduresRequest$json,
  '.healthcare.clinical.v1.ListProceduresResponse': ListProceduresResponse$json,
  '.healthcare.clinical.v1.CreateCarePlanRequest': CreateCarePlanRequest$json,
  '.healthcare.clinical.v1.Goal': Goal$json,
  '.healthcare.clinical.v1.Activity': Activity$json,
  '.healthcare.clinical.v1.CreateCarePlanResponse': CreateCarePlanResponse$json,
  '.healthcare.clinical.v1.CarePlan': CarePlan$json,
  '.healthcare.clinical.v1.UpdateCarePlanRequest': UpdateCarePlanRequest$json,
  '.healthcare.clinical.v1.UpdateCarePlanResponse': UpdateCarePlanResponse$json,
  '.healthcare.clinical.v1.ListCarePlansRequest': ListCarePlansRequest$json,
  '.healthcare.clinical.v1.ListCarePlansResponse': ListCarePlansResponse$json,
  '.healthcare.clinical.v1.GetBannerRequest': GetBannerRequest$json,
  '.healthcare.clinical.v1.GetBannerResponse': GetBannerResponse$json,
  '.healthcare.clinical.v1.Banner': Banner$json,
  '.healthcare.clinical.v1.BannerIdentifier': BannerIdentifier$json,
  '.healthcare.clinical.v1.BannerAlert': BannerAlert$json,
  '.healthcare.clinical.v1.RecordConsentRequest': RecordConsentRequest$json,
  '.healthcare.clinical.v1.RecordConsentResponse': RecordConsentResponse$json,
  '.healthcare.clinical.v1.ClinicalConsent': ClinicalConsent$json,
  '.healthcare.clinical.v1.WithdrawConsentRequest': WithdrawConsentRequest$json,
  '.healthcare.clinical.v1.WithdrawConsentResponse':
      WithdrawConsentResponse$json,
  '.healthcare.clinical.v1.ListConsentsRequest': ListConsentsRequest$json,
  '.healthcare.clinical.v1.ListConsentsResponse': ListConsentsResponse$json,
  '.healthcare.clinical.v1.AttachFileRequest': AttachFileRequest$json,
  '.healthcare.clinical.v1.AttachFileResponse': AttachFileResponse$json,
  '.healthcare.clinical.v1.Attachment': Attachment$json,
  '.healthcare.clinical.v1.ListAttachmentsRequest': ListAttachmentsRequest$json,
  '.healthcare.clinical.v1.ListAttachmentsResponse':
      ListAttachmentsResponse$json,
  '.healthcare.clinical.v1.GetProvenanceRequest': GetProvenanceRequest$json,
  '.healthcare.clinical.v1.GetProvenanceResponse': GetProvenanceResponse$json,
  '.healthcare.clinical.v1.StoreCalculationRequest':
      StoreCalculationRequest$json,
  '.healthcare.clinical.v1.CalculatorInput': CalculatorInput$json,
  '.healthcare.clinical.v1.StoreCalculationResponse':
      StoreCalculationResponse$json,
  '.healthcare.clinical.v1.CalculatorResult': CalculatorResult$json,
  '.healthcare.clinical.v1.ListCalculationsRequest':
      ListCalculationsRequest$json,
  '.healthcare.clinical.v1.ListCalculationsResponse':
      ListCalculationsResponse$json,
  '.healthcare.clinical.v1.RaiseAlertRequest': RaiseAlertRequest$json,
  '.healthcare.clinical.v1.RaiseAlertResponse': RaiseAlertResponse$json,
  '.healthcare.clinical.v1.CDSAlert': CDSAlert$json,
  '.healthcare.clinical.v1.RespondToAlertRequest': RespondToAlertRequest$json,
  '.healthcare.clinical.v1.RespondToAlertResponse': RespondToAlertResponse$json,
  '.healthcare.clinical.v1.ListAlertsRequest': ListAlertsRequest$json,
  '.healthcare.clinical.v1.ListAlertsResponse': ListAlertsResponse$json,
  '.healthcare.clinical.v1.RequestConsultRequest': RequestConsultRequest$json,
  '.healthcare.clinical.v1.RequestConsultResponse': RequestConsultResponse$json,
  '.healthcare.clinical.v1.Consult': Consult$json,
  '.healthcare.clinical.v1.RespondToConsultRequest':
      RespondToConsultRequest$json,
  '.healthcare.clinical.v1.RespondToConsultResponse':
      RespondToConsultResponse$json,
  '.healthcare.clinical.v1.ListConsultsRequest': ListConsultsRequest$json,
  '.healthcare.clinical.v1.ListConsultsResponse': ListConsultsResponse$json,
  '.healthcare.clinical.v1.EnrolInRegistryRequest': EnrolInRegistryRequest$json,
  '.healthcare.clinical.v1.EnrolInRegistryResponse':
      EnrolInRegistryResponse$json,
  '.healthcare.clinical.v1.RegistryMembership': RegistryMembership$json,
  '.healthcare.clinical.v1.ExitRegistryRequest': ExitRegistryRequest$json,
  '.healthcare.clinical.v1.ExitRegistryResponse': ExitRegistryResponse$json,
  '.healthcare.clinical.v1.ListRegistryMembershipsRequest':
      ListRegistryMembershipsRequest$json,
  '.healthcare.clinical.v1.ListRegistryMembershipsResponse':
      ListRegistryMembershipsResponse$json,
};

/// Descriptor for `ClinicalService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List clinicalServiceDescriptor = $convert.base64Decode(
    'Cg9DbGluaWNhbFNlcnZpY2USYAoJV3JpdGVOb3RlEiguaGVhbHRoY2FyZS5jbGluaWNhbC52MS'
    '5Xcml0ZU5vdGVSZXF1ZXN0GikuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5Xcml0ZU5vdGVSZXNw'
    'b25zZRJdCghTaWduTm90ZRInLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuU2lnbk5vdGVSZXF1ZX'
    'N0GiguaGVhbHRoY2FyZS5jbGluaWNhbC52MS5TaWduTm90ZVJlc3BvbnNlEmAKCUFtZW5kTm90'
    'ZRIoLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQW1lbmROb3RlUmVxdWVzdBopLmhlYWx0aGNhcm'
    'UuY2xpbmljYWwudjEuQW1lbmROb3RlUmVzcG9uc2USZgoLUmV0cmFjdE5vdGUSKi5oZWFsdGhj'
    'YXJlLmNsaW5pY2FsLnYxLlJldHJhY3ROb3RlUmVxdWVzdBorLmhlYWx0aGNhcmUuY2xpbmljYW'
    'wudjEuUmV0cmFjdE5vdGVSZXNwb25zZRJaCgdHZXROb3RlEiYuaGVhbHRoY2FyZS5jbGluaWNh'
    'bC52MS5HZXROb3RlUmVxdWVzdBonLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuR2V0Tm90ZVJlc3'
    'BvbnNlEmAKCUxpc3ROb3RlcxIoLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuTGlzdE5vdGVzUmVx'
    'dWVzdBopLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuTGlzdE5vdGVzUmVzcG9uc2USbwoORGVmaW'
    '5lVGVtcGxhdGUSLS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkRlZmluZVRlbXBsYXRlUmVxdWVz'
    'dBouLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuRGVmaW5lVGVtcGxhdGVSZXNwb25zZRJsCg1MaX'
    'N0VGVtcGxhdGVzEiwuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaXN0VGVtcGxhdGVzUmVxdWVz'
    'dBotLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuTGlzdFRlbXBsYXRlc1Jlc3BvbnNlEm8KDlJldG'
    'lyZVRlbXBsYXRlEi0uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZXRpcmVUZW1wbGF0ZVJlcXVl'
    'c3QaLi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlJldGlyZVRlbXBsYXRlUmVzcG9uc2USeAoRRG'
    'VmaW5lU21hcnRQaHJhc2USMC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkRlZmluZVNtYXJ0UGhy'
    'YXNlUmVxdWVzdBoxLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuRGVmaW5lU21hcnRQaHJhc2VSZX'
    'Nwb25zZRJ1ChBMaXN0U21hcnRQaHJhc2VzEi8uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaXN0'
    'U21hcnRQaHJhc2VzUmVxdWVzdBowLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuTGlzdFNtYXJ0UG'
    'hyYXNlc1Jlc3BvbnNlEmwKDVJlY29yZFByb2JsZW0SLC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYx'
    'LlJlY29yZFByb2JsZW1SZXF1ZXN0Gi0uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZWNvcmRQcm'
    '9ibGVtUmVzcG9uc2USbAoNVXBkYXRlUHJvYmxlbRIsLmhlYWx0aGNhcmUuY2xpbmljYWwudjEu'
    'VXBkYXRlUHJvYmxlbVJlcXVlc3QaLS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlVwZGF0ZVByb2'
    'JsZW1SZXNwb25zZRJpCgxMaXN0UHJvYmxlbXMSKy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkxp'
    'c3RQcm9ibGVtc1JlcXVlc3QaLC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkxpc3RQcm9ibGVtc1'
    'Jlc3BvbnNlEmwKDVJlY29yZEFsbGVyZ3kSLC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlJlY29y'
    'ZEFsbGVyZ3lSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZWNvcmRBbGxlcmd5Um'
    'VzcG9uc2USbAoNVmVyaWZ5QWxsZXJneRIsLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuVmVyaWZ5'
    'QWxsZXJneVJlcXVlc3QaLS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlZlcmlmeUFsbGVyZ3lSZX'
    'Nwb25zZRJsCg1MaXN0QWxsZXJnaWVzEiwuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaXN0QWxs'
    'ZXJnaWVzUmVxdWVzdBotLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuTGlzdEFsbGVyZ2llc1Jlc3'
    'BvbnNlEngKEVJlY29yZE9ic2VydmF0aW9uEjAuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZWNv'
    'cmRPYnNlcnZhdGlvblJlcXVlc3QaMS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlJlY29yZE9ic2'
    'VydmF0aW9uUmVzcG9uc2USdQoQTGlzdE9ic2VydmF0aW9ucxIvLmhlYWx0aGNhcmUuY2xpbmlj'
    'YWwudjEuTGlzdE9ic2VydmF0aW9uc1JlcXVlc3QaMC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLk'
    'xpc3RPYnNlcnZhdGlvbnNSZXNwb25zZRJ+ChNMaXN0Q3JpdGljYWxSZXN1bHRzEjIuaGVhbHRo'
    'Y2FyZS5jbGluaWNhbC52MS5MaXN0Q3JpdGljYWxSZXN1bHRzUmVxdWVzdBozLmhlYWx0aGNhcm'
    'UuY2xpbmljYWwudjEuTGlzdENyaXRpY2FsUmVzdWx0c1Jlc3BvbnNlEpABChlBY2tub3dsZWRn'
    'ZUNyaXRpY2FsUmVzdWx0EjguaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BY2tub3dsZWRnZUNyaX'
    'RpY2FsUmVzdWx0UmVxdWVzdBo5LmhlYWx0aGNhcmUuY2xpbmljYWwudjEuQWNrbm93bGVkZ2VD'
    'cml0aWNhbFJlc3VsdFJlc3BvbnNlEnIKD1JlY29yZFByb2NlZHVyZRIuLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuUmVjb3JkUHJvY2VkdXJlUmVxdWVzdBovLmhlYWx0aGNhcmUuY2xpbmljYWwu'
    'djEuUmVjb3JkUHJvY2VkdXJlUmVzcG9uc2USbwoOTGlzdFByb2NlZHVyZXMSLS5oZWFsdGhjYX'
    'JlLmNsaW5pY2FsLnYxLkxpc3RQcm9jZWR1cmVzUmVxdWVzdBouLmhlYWx0aGNhcmUuY2xpbmlj'
    'YWwudjEuTGlzdFByb2NlZHVyZXNSZXNwb25zZRJvCg5DcmVhdGVDYXJlUGxhbhItLmhlYWx0aG'
    'NhcmUuY2xpbmljYWwudjEuQ3JlYXRlQ2FyZVBsYW5SZXF1ZXN0Gi4uaGVhbHRoY2FyZS5jbGlu'
    'aWNhbC52MS5DcmVhdGVDYXJlUGxhblJlc3BvbnNlEm8KDlVwZGF0ZUNhcmVQbGFuEi0uaGVhbH'
    'RoY2FyZS5jbGluaWNhbC52MS5VcGRhdGVDYXJlUGxhblJlcXVlc3QaLi5oZWFsdGhjYXJlLmNs'
    'aW5pY2FsLnYxLlVwZGF0ZUNhcmVQbGFuUmVzcG9uc2USbAoNTGlzdENhcmVQbGFucxIsLmhlYW'
    'x0aGNhcmUuY2xpbmljYWwudjEuTGlzdENhcmVQbGFuc1JlcXVlc3QaLS5oZWFsdGhjYXJlLmNs'
    'aW5pY2FsLnYxLkxpc3RDYXJlUGxhbnNSZXNwb25zZRJgCglHZXRCYW5uZXISKC5oZWFsdGhjYX'
    'JlLmNsaW5pY2FsLnYxLkdldEJhbm5lclJlcXVlc3QaKS5oZWFsdGhjYXJlLmNsaW5pY2FsLnYx'
    'LkdldEJhbm5lclJlc3BvbnNlEmwKDVJlY29yZENvbnNlbnQSLC5oZWFsdGhjYXJlLmNsaW5pY2'
    'FsLnYxLlJlY29yZENvbnNlbnRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZWNv'
    'cmRDb25zZW50UmVzcG9uc2UScgoPV2l0aGRyYXdDb25zZW50Ei4uaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5XaXRoZHJhd0NvbnNlbnRSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5X'
    'aXRoZHJhd0NvbnNlbnRSZXNwb25zZRJpCgxMaXN0Q29uc2VudHMSKy5oZWFsdGhjYXJlLmNsaW'
    '5pY2FsLnYxLkxpc3RDb25zZW50c1JlcXVlc3QaLC5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkxp'
    'c3RDb25zZW50c1Jlc3BvbnNlEmMKCkF0dGFjaEZpbGUSKS5oZWFsdGhjYXJlLmNsaW5pY2FsLn'
    'YxLkF0dGFjaEZpbGVSZXF1ZXN0GiouaGVhbHRoY2FyZS5jbGluaWNhbC52MS5BdHRhY2hGaWxl'
    'UmVzcG9uc2UScgoPTGlzdEF0dGFjaG1lbnRzEi4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaX'
    'N0QXR0YWNobWVudHNSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaXN0QXR0YWNo'
    'bWVudHNSZXNwb25zZRJsCg1HZXRQcm92ZW5hbmNlEiwuaGVhbHRoY2FyZS5jbGluaWNhbC52MS'
    '5HZXRQcm92ZW5hbmNlUmVxdWVzdBotLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuR2V0UHJvdmVu'
    'YW5jZVJlc3BvbnNlEnUKEFN0b3JlQ2FsY3VsYXRpb24SLy5oZWFsdGhjYXJlLmNsaW5pY2FsLn'
    'YxLlN0b3JlQ2FsY3VsYXRpb25SZXF1ZXN0GjAuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5TdG9y'
    'ZUNhbGN1bGF0aW9uUmVzcG9uc2USdQoQTGlzdENhbGN1bGF0aW9ucxIvLmhlYWx0aGNhcmUuY2'
    'xpbmljYWwudjEuTGlzdENhbGN1bGF0aW9uc1JlcXVlc3QaMC5oZWFsdGhjYXJlLmNsaW5pY2Fs'
    'LnYxLkxpc3RDYWxjdWxhdGlvbnNSZXNwb25zZRJjCgpSYWlzZUFsZXJ0EikuaGVhbHRoY2FyZS'
    '5jbGluaWNhbC52MS5SYWlzZUFsZXJ0UmVxdWVzdBoqLmhlYWx0aGNhcmUuY2xpbmljYWwudjEu'
    'UmFpc2VBbGVydFJlc3BvbnNlEm8KDlJlc3BvbmRUb0FsZXJ0Ei0uaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5SZXNwb25kVG9BbGVydFJlcXVlc3QaLi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLlJl'
    'c3BvbmRUb0FsZXJ0UmVzcG9uc2USYwoKTGlzdEFsZXJ0cxIpLmhlYWx0aGNhcmUuY2xpbmljYW'
    'wudjEuTGlzdEFsZXJ0c1JlcXVlc3QaKi5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkxpc3RBbGVy'
    'dHNSZXNwb25zZRJvCg5SZXF1ZXN0Q29uc3VsdBItLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuUm'
    'VxdWVzdENvbnN1bHRSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZXF1ZXN0Q29u'
    'c3VsdFJlc3BvbnNlEnUKEFJlc3BvbmRUb0NvbnN1bHQSLy5oZWFsdGhjYXJlLmNsaW5pY2FsLn'
    'YxLlJlc3BvbmRUb0NvbnN1bHRSZXF1ZXN0GjAuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5SZXNw'
    'b25kVG9Db25zdWx0UmVzcG9uc2USaQoMTGlzdENvbnN1bHRzEisuaGVhbHRoY2FyZS5jbGluaW'
    'NhbC52MS5MaXN0Q29uc3VsdHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5jbGluaWNhbC52MS5MaXN0'
    'Q29uc3VsdHNSZXNwb25zZRJyCg9FbnJvbEluUmVnaXN0cnkSLi5oZWFsdGhjYXJlLmNsaW5pY2'
    'FsLnYxLkVucm9sSW5SZWdpc3RyeVJlcXVlc3QaLy5oZWFsdGhjYXJlLmNsaW5pY2FsLnYxLkVu'
    'cm9sSW5SZWdpc3RyeVJlc3BvbnNlEmkKDEV4aXRSZWdpc3RyeRIrLmhlYWx0aGNhcmUuY2xpbm'
    'ljYWwudjEuRXhpdFJlZ2lzdHJ5UmVxdWVzdBosLmhlYWx0aGNhcmUuY2xpbmljYWwudjEuRXhp'
    'dFJlZ2lzdHJ5UmVzcG9uc2USigEKF0xpc3RSZWdpc3RyeU1lbWJlcnNoaXBzEjYuaGVhbHRoY2'
    'FyZS5jbGluaWNhbC52MS5MaXN0UmVnaXN0cnlNZW1iZXJzaGlwc1JlcXVlc3QaNy5oZWFsdGhj'
    'YXJlLmNsaW5pY2FsLnYxLkxpc3RSZWdpc3RyeU1lbWJlcnNoaXBzUmVzcG9uc2U=');
