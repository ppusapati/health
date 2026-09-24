// This is a generated file - do not edit.
//
// Generated from healthcare/quality/v1/quality.proto.

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

@$core.Deprecated('Use reachDescriptor instead')
const Reach$json = {
  '1': 'Reach',
  '2': [
    {'1': 'REACH_UNSPECIFIED', '2': 0},
    {'1': 'REACH_NEAR_MISS', '2': 1},
    {'1': 'REACH_NO_HARM', '2': 2},
    {'1': 'REACH_HARM', '2': 3},
    {'1': 'REACH_NOT_PATIENT', '2': 4},
  ],
};

/// Descriptor for `Reach`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reachDescriptor = $convert.base64Decode(
    'CgVSZWFjaBIVChFSRUFDSF9VTlNQRUNJRklFRBAAEhMKD1JFQUNIX05FQVJfTUlTUxABEhEKDV'
    'JFQUNIX05PX0hBUk0QAhIOCgpSRUFDSF9IQVJNEAMSFQoRUkVBQ0hfTk9UX1BBVElFTlQQBA==');

@$core.Deprecated('Use harmDescriptor instead')
const Harm$json = {
  '1': 'Harm',
  '2': [
    {'1': 'HARM_UNSPECIFIED', '2': 0},
    {'1': 'HARM_NONE', '2': 1},
    {'1': 'HARM_MILD', '2': 2},
    {'1': 'HARM_MODERATE', '2': 3},
    {'1': 'HARM_SEVERE', '2': 4},
    {'1': 'HARM_DEATH', '2': 5},
  ],
};

/// Descriptor for `Harm`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List harmDescriptor = $convert.base64Decode(
    'CgRIYXJtEhQKEEhBUk1fVU5TUEVDSUZJRUQQABINCglIQVJNX05PTkUQARINCglIQVJNX01JTE'
    'QQAhIRCg1IQVJNX01PREVSQVRFEAMSDwoLSEFSTV9TRVZFUkUQBBIOCgpIQVJNX0RFQVRIEAU=');

@$core.Deprecated('Use consequenceDescriptor instead')
const Consequence$json = {
  '1': 'Consequence',
  '2': [
    {'1': 'CONSEQUENCE_UNSPECIFIED', '2': 0},
    {'1': 'CONSEQUENCE_NEGLIGIBLE', '2': 1},
    {'1': 'CONSEQUENCE_MINOR', '2': 2},
    {'1': 'CONSEQUENCE_MODERATE', '2': 3},
    {'1': 'CONSEQUENCE_MAJOR', '2': 4},
    {'1': 'CONSEQUENCE_CATASTROPHIC', '2': 5},
  ],
};

/// Descriptor for `Consequence`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List consequenceDescriptor = $convert.base64Decode(
    'CgtDb25zZXF1ZW5jZRIbChdDT05TRVFVRU5DRV9VTlNQRUNJRklFRBAAEhoKFkNPTlNFUVVFTk'
    'NFX05FR0xJR0lCTEUQARIVChFDT05TRVFVRU5DRV9NSU5PUhACEhgKFENPTlNFUVVFTkNFX01P'
    'REVSQVRFEAMSFQoRQ09OU0VRVUVOQ0VfTUFKT1IQBBIcChhDT05TRVFVRU5DRV9DQVRBU1RST1'
    'BISUMQBQ==');

@$core.Deprecated('Use likelihoodDescriptor instead')
const Likelihood$json = {
  '1': 'Likelihood',
  '2': [
    {'1': 'LIKELIHOOD_UNSPECIFIED', '2': 0},
    {'1': 'LIKELIHOOD_RARE', '2': 1},
    {'1': 'LIKELIHOOD_UNLIKELY', '2': 2},
    {'1': 'LIKELIHOOD_POSSIBLE', '2': 3},
    {'1': 'LIKELIHOOD_LIKELY', '2': 4},
    {'1': 'LIKELIHOOD_ALMOST_CERTAIN', '2': 5},
  ],
};

/// Descriptor for `Likelihood`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List likelihoodDescriptor = $convert.base64Decode(
    'CgpMaWtlbGlob29kEhoKFkxJS0VMSUhPT0RfVU5TUEVDSUZJRUQQABITCg9MSUtFTElIT09EX1'
    'JBUkUQARIXChNMSUtFTElIT09EX1VOTElLRUxZEAISFwoTTElLRUxJSE9PRF9QT1NTSUJMRRAD'
    'EhUKEUxJS0VMSUhPT0RfTElLRUxZEAQSHQoZTElLRUxJSE9PRF9BTE1PU1RfQ0VSVEFJThAF');

@$core.Deprecated('Use riskBandDescriptor instead')
const RiskBand$json = {
  '1': 'RiskBand',
  '2': [
    {'1': 'RISK_BAND_UNSPECIFIED', '2': 0},
    {'1': 'RISK_BAND_LOW', '2': 1},
    {'1': 'RISK_BAND_MODERATE', '2': 2},
    {'1': 'RISK_BAND_HIGH', '2': 3},
    {'1': 'RISK_BAND_EXTREME', '2': 4},
  ],
};

/// Descriptor for `RiskBand`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List riskBandDescriptor = $convert.base64Decode(
    'CghSaXNrQmFuZBIZChVSSVNLX0JBTkRfVU5TUEVDSUZJRUQQABIRCg1SSVNLX0JBTkRfTE9XEA'
    'ESFgoSUklTS19CQU5EX01PREVSQVRFEAISEgoOUklTS19CQU5EX0hJR0gQAxIVChFSSVNLX0JB'
    'TkRfRVhUUkVNRRAE');

@$core.Deprecated('Use incidentStateDescriptor instead')
const IncidentState$json = {
  '1': 'IncidentState',
  '2': [
    {'1': 'INCIDENT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'INCIDENT_STATE_REPORTED', '2': 1},
    {'1': 'INCIDENT_STATE_UNDER_REVIEW', '2': 2},
    {'1': 'INCIDENT_STATE_INVESTIGATED', '2': 3},
    {'1': 'INCIDENT_STATE_CLOSED', '2': 4},
    {'1': 'INCIDENT_STATE_REJECTED', '2': 5},
  ],
};

/// Descriptor for `IncidentState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List incidentStateDescriptor = $convert.base64Decode(
    'Cg1JbmNpZGVudFN0YXRlEh4KGklOQ0lERU5UX1NUQVRFX1VOU1BFQ0lGSUVEEAASGwoXSU5DSU'
    'RFTlRfU1RBVEVfUkVQT1JURUQQARIfChtJTkNJREVOVF9TVEFURV9VTkRFUl9SRVZJRVcQAhIf'
    'ChtJTkNJREVOVF9TVEFURV9JTlZFU1RJR0FURUQQAxIZChVJTkNJREVOVF9TVEFURV9DTE9TRU'
    'QQBBIbChdJTkNJREVOVF9TVEFURV9SRUpFQ1RFRBAF');

@$core.Deprecated('Use factorCategoryDescriptor instead')
const FactorCategory$json = {
  '1': 'FactorCategory',
  '2': [
    {'1': 'FACTOR_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'FACTOR_CATEGORY_PATIENT', '2': 1},
    {'1': 'FACTOR_CATEGORY_TASK', '2': 2},
    {'1': 'FACTOR_CATEGORY_INDIVIDUAL', '2': 3},
    {'1': 'FACTOR_CATEGORY_TEAM', '2': 4},
    {'1': 'FACTOR_CATEGORY_ENVIRONMENT', '2': 5},
    {'1': 'FACTOR_CATEGORY_EQUIPMENT', '2': 6},
    {'1': 'FACTOR_CATEGORY_ORGANISATIONAL', '2': 7},
  ],
};

/// Descriptor for `FactorCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List factorCategoryDescriptor = $convert.base64Decode(
    'Cg5GYWN0b3JDYXRlZ29yeRIfChtGQUNUT1JfQ0FURUdPUllfVU5TUEVDSUZJRUQQABIbChdGQU'
    'NUT1JfQ0FURUdPUllfUEFUSUVOVBABEhgKFEZBQ1RPUl9DQVRFR09SWV9UQVNLEAISHgoaRkFD'
    'VE9SX0NBVEVHT1JZX0lORElWSURVQUwQAxIYChRGQUNUT1JfQ0FURUdPUllfVEVBTRAEEh8KG0'
    'ZBQ1RPUl9DQVRFR09SWV9FTlZJUk9OTUVOVBAFEh0KGUZBQ1RPUl9DQVRFR09SWV9FUVVJUE1F'
    'TlQQBhIiCh5GQUNUT1JfQ0FURUdPUllfT1JHQU5JU0FUSU9OQUwQBw==');

@$core.Deprecated('Use reviewStateDescriptor instead')
const ReviewState$json = {
  '1': 'ReviewState',
  '2': [
    {'1': 'REVIEW_STATE_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATE_OPEN', '2': 1},
    {'1': 'REVIEW_STATE_COMPLETE', '2': 2},
  ],
};

/// Descriptor for `ReviewState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStateDescriptor = $convert.base64Decode(
    'CgtSZXZpZXdTdGF0ZRIcChhSRVZJRVdfU1RBVEVfVU5TUEVDSUZJRUQQABIVChFSRVZJRVdfU1'
    'RBVEVfT1BFThABEhkKFVJFVklFV19TVEFURV9DT01QTEVURRAC');

@$core.Deprecated('Use actionKindDescriptor instead')
const ActionKind$json = {
  '1': 'ActionKind',
  '2': [
    {'1': 'ACTION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_KIND_CORRECTIVE', '2': 1},
    {'1': 'ACTION_KIND_PREVENTIVE', '2': 2},
  ],
};

/// Descriptor for `ActionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionKindDescriptor = $convert.base64Decode(
    'CgpBY3Rpb25LaW5kEhsKF0FDVElPTl9LSU5EX1VOU1BFQ0lGSUVEEAASGgoWQUNUSU9OX0tJTk'
    'RfQ09SUkVDVElWRRABEhoKFkFDVElPTl9LSU5EX1BSRVZFTlRJVkUQAg==');

@$core.Deprecated('Use actionSourceDescriptor instead')
const ActionSource$json = {
  '1': 'ActionSource',
  '2': [
    {'1': 'ACTION_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_SOURCE_INCIDENT', '2': 1},
    {'1': 'ACTION_SOURCE_RCA', '2': 2},
    {'1': 'ACTION_SOURCE_AUDIT_FINDING', '2': 3},
    {'1': 'ACTION_SOURCE_COMPLAINT', '2': 4},
    {'1': 'ACTION_SOURCE_COMMITTEE', '2': 5},
    {'1': 'ACTION_SOURCE_INSPECTION', '2': 6},
  ],
};

/// Descriptor for `ActionSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionSourceDescriptor = $convert.base64Decode(
    'CgxBY3Rpb25Tb3VyY2USHQoZQUNUSU9OX1NPVVJDRV9VTlNQRUNJRklFRBAAEhoKFkFDVElPTl'
    '9TT1VSQ0VfSU5DSURFTlQQARIVChFBQ1RJT05fU09VUkNFX1JDQRACEh8KG0FDVElPTl9TT1VS'
    'Q0VfQVVESVRfRklORElORxADEhsKF0FDVElPTl9TT1VSQ0VfQ09NUExBSU5UEAQSGwoXQUNUSU'
    '9OX1NPVVJDRV9DT01NSVRURUUQBRIcChhBQ1RJT05fU09VUkNFX0lOU1BFQ1RJT04QBg==');

@$core.Deprecated('Use actionStateDescriptor instead')
const ActionState$json = {
  '1': 'ActionState',
  '2': [
    {'1': 'ACTION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_STATE_DRAFT', '2': 1},
    {'1': 'ACTION_STATE_APPROVED', '2': 2},
    {'1': 'ACTION_STATE_OPEN', '2': 3},
    {'1': 'ACTION_STATE_IN_PROGRESS', '2': 4},
    {'1': 'ACTION_STATE_EFFECTIVENESS_REVIEW', '2': 5},
    {'1': 'ACTION_STATE_CLOSED', '2': 6},
    {'1': 'ACTION_STATE_CANCELLED', '2': 7},
  ],
};

/// Descriptor for `ActionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionStateDescriptor = $convert.base64Decode(
    'CgtBY3Rpb25TdGF0ZRIcChhBQ1RJT05fU1RBVEVfVU5TUEVDSUZJRUQQABIWChJBQ1RJT05fU1'
    'RBVEVfRFJBRlQQARIZChVBQ1RJT05fU1RBVEVfQVBQUk9WRUQQAhIVChFBQ1RJT05fU1RBVEVf'
    'T1BFThADEhwKGEFDVElPTl9TVEFURV9JTl9QUk9HUkVTUxAEEiUKIUFDVElPTl9TVEFURV9FRk'
    'ZFQ1RJVkVORVNTX1JFVklFVxAFEhcKE0FDVElPTl9TVEFURV9DTE9TRUQQBhIaChZBQ1RJT05f'
    'U1RBVEVfQ0FOQ0VMTEVEEAc=');

@$core.Deprecated('Use documentKindDescriptor instead')
const DocumentKind$json = {
  '1': 'DocumentKind',
  '2': [
    {'1': 'DOCUMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_KIND_POLICY', '2': 1},
    {'1': 'DOCUMENT_KIND_SOP', '2': 2},
    {'1': 'DOCUMENT_KIND_PROTOCOL', '2': 3},
    {'1': 'DOCUMENT_KIND_GUIDELINE', '2': 4},
    {'1': 'DOCUMENT_KIND_FORM', '2': 5},
    {'1': 'DOCUMENT_KIND_MANUAL', '2': 6},
  ],
};

/// Descriptor for `DocumentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentKindDescriptor = $convert.base64Decode(
    'CgxEb2N1bWVudEtpbmQSHQoZRE9DVU1FTlRfS0lORF9VTlNQRUNJRklFRBAAEhgKFERPQ1VNRU'
    '5UX0tJTkRfUE9MSUNZEAESFQoRRE9DVU1FTlRfS0lORF9TT1AQAhIaChZET0NVTUVOVF9LSU5E'
    'X1BST1RPQ09MEAMSGwoXRE9DVU1FTlRfS0lORF9HVUlERUxJTkUQBBIWChJET0NVTUVOVF9LSU'
    '5EX0ZPUk0QBRIYChRET0NVTUVOVF9LSU5EX01BTlVBTBAG');

@$core.Deprecated('Use versionStateDescriptor instead')
const VersionState$json = {
  '1': 'VersionState',
  '2': [
    {'1': 'VERSION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'VERSION_STATE_DRAFT', '2': 1},
    {'1': 'VERSION_STATE_APPROVED', '2': 2},
    {'1': 'VERSION_STATE_EFFECTIVE', '2': 3},
    {'1': 'VERSION_STATE_OBSOLETE', '2': 4},
  ],
};

/// Descriptor for `VersionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List versionStateDescriptor = $convert.base64Decode(
    'CgxWZXJzaW9uU3RhdGUSHQoZVkVSU0lPTl9TVEFURV9VTlNQRUNJRklFRBAAEhcKE1ZFUlNJT0'
    '5fU1RBVEVfRFJBRlQQARIaChZWRVJTSU9OX1NUQVRFX0FQUFJPVkVEEAISGwoXVkVSU0lPTl9T'
    'VEFURV9FRkZFQ1RJVkUQAxIaChZWRVJTSU9OX1NUQVRFX09CU09MRVRFEAQ=');

@$core.Deprecated('Use findingSeverityDescriptor instead')
const FindingSeverity$json = {
  '1': 'FindingSeverity',
  '2': [
    {'1': 'FINDING_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'FINDING_SEVERITY_OBSERVATION', '2': 1},
    {'1': 'FINDING_SEVERITY_MINOR_NC', '2': 2},
    {'1': 'FINDING_SEVERITY_MAJOR_NC', '2': 3},
  ],
};

/// Descriptor for `FindingSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List findingSeverityDescriptor = $convert.base64Decode(
    'Cg9GaW5kaW5nU2V2ZXJpdHkSIAocRklORElOR19TRVZFUklUWV9VTlNQRUNJRklFRBAAEiAKHE'
    'ZJTkRJTkdfU0VWRVJJVFlfT0JTRVJWQVRJT04QARIdChlGSU5ESU5HX1NFVkVSSVRZX01JTk9S'
    'X05DEAISHQoZRklORElOR19TRVZFUklUWV9NQUpPUl9OQxAD');

@$core.Deprecated('Use auditStateDescriptor instead')
const AuditState$json = {
  '1': 'AuditState',
  '2': [
    {'1': 'AUDIT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'AUDIT_STATE_PLANNED', '2': 1},
    {'1': 'AUDIT_STATE_IN_PROGRESS', '2': 2},
    {'1': 'AUDIT_STATE_REPORTED', '2': 3},
    {'1': 'AUDIT_STATE_CLOSED', '2': 4},
    {'1': 'AUDIT_STATE_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `AuditState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List auditStateDescriptor = $convert.base64Decode(
    'CgpBdWRpdFN0YXRlEhsKF0FVRElUX1NUQVRFX1VOU1BFQ0lGSUVEEAASFwoTQVVESVRfU1RBVE'
    'VfUExBTk5FRBABEhsKF0FVRElUX1NUQVRFX0lOX1BST0dSRVNTEAISGAoUQVVESVRfU1RBVEVf'
    'UkVQT1JURUQQAxIWChJBVURJVF9TVEFURV9DTE9TRUQQBBIZChVBVURJVF9TVEFURV9DQU5DRU'
    'xMRUQQBQ==');

@$core.Deprecated('Use meetingStateDescriptor instead')
const MeetingState$json = {
  '1': 'MeetingState',
  '2': [
    {'1': 'MEETING_STATE_UNSPECIFIED', '2': 0},
    {'1': 'MEETING_STATE_SCHEDULED', '2': 1},
    {'1': 'MEETING_STATE_HELD', '2': 2},
    {'1': 'MEETING_STATE_MINUTES_APPROVED', '2': 3},
    {'1': 'MEETING_STATE_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `MeetingState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List meetingStateDescriptor = $convert.base64Decode(
    'CgxNZWV0aW5nU3RhdGUSHQoZTUVFVElOR19TVEFURV9VTlNQRUNJRklFRBAAEhsKF01FRVRJTk'
    'dfU1RBVEVfU0NIRURVTEVEEAESFgoSTUVFVElOR19TVEFURV9IRUxEEAISIgoeTUVFVElOR19T'
    'VEFURV9NSU5VVEVTX0FQUFJPVkVEEAMSGwoXTUVFVElOR19TVEFURV9DQU5DRUxMRUQQBA==');

@$core.Deprecated('Use evidenceKindDescriptor instead')
const EvidenceKind$json = {
  '1': 'EvidenceKind',
  '2': [
    {'1': 'EVIDENCE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EVIDENCE_KIND_DOCUMENT_VERSION', '2': 1},
    {'1': 'EVIDENCE_KIND_AUDIT', '2': 2},
    {'1': 'EVIDENCE_KIND_AUDIT_FINDING', '2': 3},
    {'1': 'EVIDENCE_KIND_CAPA', '2': 4},
    {'1': 'EVIDENCE_KIND_KPI', '2': 5},
    {'1': 'EVIDENCE_KIND_COMMITTEE_MEETING', '2': 6},
    {'1': 'EVIDENCE_KIND_COMPETENCY', '2': 7},
    {'1': 'EVIDENCE_KIND_EXTERNAL', '2': 8},
  ],
};

/// Descriptor for `EvidenceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List evidenceKindDescriptor = $convert.base64Decode(
    'CgxFdmlkZW5jZUtpbmQSHQoZRVZJREVOQ0VfS0lORF9VTlNQRUNJRklFRBAAEiIKHkVWSURFTk'
    'NFX0tJTkRfRE9DVU1FTlRfVkVSU0lPThABEhcKE0VWSURFTkNFX0tJTkRfQVVESVQQAhIfChtF'
    'VklERU5DRV9LSU5EX0FVRElUX0ZJTkRJTkcQAxIWChJFVklERU5DRV9LSU5EX0NBUEEQBBIVCh'
    'FFVklERU5DRV9LSU5EX0tQSRAFEiMKH0VWSURFTkNFX0tJTkRfQ09NTUlUVEVFX01FRVRJTkcQ'
    'BhIcChhFVklERU5DRV9LSU5EX0NPTVBFVEVOQ1kQBxIaChZFVklERU5DRV9LSU5EX0VYVEVSTk'
    'FMEAg=');

@$core.Deprecated('Use verdictDescriptor instead')
const Verdict$json = {
  '1': 'Verdict',
  '2': [
    {'1': 'VERDICT_UNSPECIFIED', '2': 0},
    {'1': 'VERDICT_UNREVIEWED', '2': 1},
    {'1': 'VERDICT_MET', '2': 2},
    {'1': 'VERDICT_PARTIALLY_MET', '2': 3},
    {'1': 'VERDICT_NOT_MET', '2': 4},
    {'1': 'VERDICT_NOT_APPLICABLE', '2': 5},
  ],
};

/// Descriptor for `Verdict`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List verdictDescriptor = $convert.base64Decode(
    'CgdWZXJkaWN0EhcKE1ZFUkRJQ1RfVU5TUEVDSUZJRUQQABIWChJWRVJESUNUX1VOUkVWSUVXRU'
    'QQARIPCgtWRVJESUNUX01FVBACEhkKFVZFUkRJQ1RfUEFSVElBTExZX01FVBADEhMKD1ZFUkRJ'
    'Q1RfTk9UX01FVBAEEhoKFlZFUkRJQ1RfTk9UX0FQUExJQ0FCTEUQBQ==');

@$core.Deprecated('Use directionDescriptor instead')
const Direction$json = {
  '1': 'Direction',
  '2': [
    {'1': 'DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'DIRECTION_HIGHER_IS_BETTER', '2': 1},
    {'1': 'DIRECTION_LOWER_IS_BETTER', '2': 2},
  ],
};

/// Descriptor for `Direction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List directionDescriptor = $convert.base64Decode(
    'CglEaXJlY3Rpb24SGQoVRElSRUNUSU9OX1VOU1BFQ0lGSUVEEAASHgoaRElSRUNUSU9OX0hJR0'
    'hFUl9JU19CRVRURVIQARIdChlESVJFQ1RJT05fTE9XRVJfSVNfQkVUVEVSEAI=');

@$core.Deprecated('Use frequencyDescriptor instead')
const Frequency$json = {
  '1': 'Frequency',
  '2': [
    {'1': 'FREQUENCY_UNSPECIFIED', '2': 0},
    {'1': 'FREQUENCY_DAILY', '2': 1},
    {'1': 'FREQUENCY_WEEKLY', '2': 2},
    {'1': 'FREQUENCY_MONTHLY', '2': 3},
    {'1': 'FREQUENCY_QUARTERLY', '2': 4},
    {'1': 'FREQUENCY_ANNUAL', '2': 5},
  ],
};

/// Descriptor for `Frequency`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List frequencyDescriptor = $convert.base64Decode(
    'CglGcmVxdWVuY3kSGQoVRlJFUVVFTkNZX1VOU1BFQ0lGSUVEEAASEwoPRlJFUVVFTkNZX0RBSU'
    'xZEAESFAoQRlJFUVVFTkNZX1dFRUtMWRACEhUKEUZSRVFVRU5DWV9NT05USExZEAMSFwoTRlJF'
    'UVVFTkNZX1FVQVJURVJMWRAEEhQKEEZSRVFVRU5DWV9BTk5VQUwQBQ==');

@$core.Deprecated('Use complainantKindDescriptor instead')
const ComplainantKind$json = {
  '1': 'ComplainantKind',
  '2': [
    {'1': 'COMPLAINANT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'COMPLAINANT_KIND_PATIENT', '2': 1},
    {'1': 'COMPLAINANT_KIND_RELATIVE', '2': 2},
    {'1': 'COMPLAINANT_KIND_VISITOR', '2': 3},
    {'1': 'COMPLAINANT_KIND_STAFF', '2': 4},
    {'1': 'COMPLAINANT_KIND_EXTERNAL', '2': 5},
  ],
};

/// Descriptor for `ComplainantKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List complainantKindDescriptor = $convert.base64Decode(
    'Cg9Db21wbGFpbmFudEtpbmQSIAocQ09NUExBSU5BTlRfS0lORF9VTlNQRUNJRklFRBAAEhwKGE'
    'NPTVBMQUlOQU5UX0tJTkRfUEFUSUVOVBABEh0KGUNPTVBMQUlOQU5UX0tJTkRfUkVMQVRJVkUQ'
    'AhIcChhDT01QTEFJTkFOVF9LSU5EX1ZJU0lUT1IQAxIaChZDT01QTEFJTkFOVF9LSU5EX1NUQU'
    'ZGEAQSHQoZQ09NUExBSU5BTlRfS0lORF9FWFRFUk5BTBAF');

@$core.Deprecated('Use complaintOutcomeDescriptor instead')
const ComplaintOutcome$json = {
  '1': 'ComplaintOutcome',
  '2': [
    {'1': 'COMPLAINT_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'COMPLAINT_OUTCOME_UPHELD', '2': 1},
    {'1': 'COMPLAINT_OUTCOME_PARTIALLY_UPHELD', '2': 2},
    {'1': 'COMPLAINT_OUTCOME_NOT_UPHELD', '2': 3},
    {'1': 'COMPLAINT_OUTCOME_WITHDRAWN', '2': 4},
  ],
};

/// Descriptor for `ComplaintOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List complaintOutcomeDescriptor = $convert.base64Decode(
    'ChBDb21wbGFpbnRPdXRjb21lEiEKHUNPTVBMQUlOVF9PVVRDT01FX1VOU1BFQ0lGSUVEEAASHA'
    'oYQ09NUExBSU5UX09VVENPTUVfVVBIRUxEEAESJgoiQ09NUExBSU5UX09VVENPTUVfUEFSVElB'
    'TExZX1VQSEVMRBACEiAKHENPTVBMQUlOVF9PVVRDT01FX05PVF9VUEhFTEQQAxIfChtDT01QTE'
    'FJTlRfT1VUQ09NRV9XSVRIRFJBV04QBA==');

@$core.Deprecated('Use complaintStateDescriptor instead')
const ComplaintState$json = {
  '1': 'ComplaintState',
  '2': [
    {'1': 'COMPLAINT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'COMPLAINT_STATE_RECEIVED', '2': 1},
    {'1': 'COMPLAINT_STATE_ACKNOWLEDGED', '2': 2},
    {'1': 'COMPLAINT_STATE_INVESTIGATING', '2': 3},
    {'1': 'COMPLAINT_STATE_RESOLVED', '2': 4},
    {'1': 'COMPLAINT_STATE_CLOSED', '2': 5},
  ],
};

/// Descriptor for `ComplaintState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List complaintStateDescriptor = $convert.base64Decode(
    'Cg5Db21wbGFpbnRTdGF0ZRIfChtDT01QTEFJTlRfU1RBVEVfVU5TUEVDSUZJRUQQABIcChhDT0'
    '1QTEFJTlRfU1RBVEVfUkVDRUlWRUQQARIgChxDT01QTEFJTlRfU1RBVEVfQUNLTk9XTEVER0VE'
    'EAISIQodQ09NUExBSU5UX1NUQVRFX0lOVkVTVElHQVRJTkcQAxIcChhDT01QTEFJTlRfU1RBVE'
    'VfUkVTT0xWRUQQBBIaChZDT01QTEFJTlRfU1RBVEVfQ0xPU0VEEAU=');

@$core.Deprecated('Use deathClassificationDescriptor instead')
const DeathClassification$json = {
  '1': 'DeathClassification',
  '2': [
    {'1': 'DEATH_CLASSIFICATION_UNSPECIFIED', '2': 0},
    {'1': 'DEATH_CLASSIFICATION_EXPECTED', '2': 1},
    {'1': 'DEATH_CLASSIFICATION_UNEXPECTED', '2': 2},
    {'1': 'DEATH_CLASSIFICATION_POTENTIALLY_PREVENTABLE', '2': 3},
    {'1': 'DEATH_CLASSIFICATION_PREVENTABLE', '2': 4},
  ],
};

/// Descriptor for `DeathClassification`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deathClassificationDescriptor = $convert.base64Decode(
    'ChNEZWF0aENsYXNzaWZpY2F0aW9uEiQKIERFQVRIX0NMQVNTSUZJQ0FUSU9OX1VOU1BFQ0lGSU'
    'VEEAASIQodREVBVEhfQ0xBU1NJRklDQVRJT05fRVhQRUNURUQQARIjCh9ERUFUSF9DTEFTU0lG'
    'SUNBVElPTl9VTkVYUEVDVEVEEAISMAosREVBVEhfQ0xBU1NJRklDQVRJT05fUE9URU5USUFMTF'
    'lfUFJFVkVOVEFCTEUQAxIkCiBERUFUSF9DTEFTU0lGSUNBVElPTl9QUkVWRU5UQUJMRRAE');

@$core.Deprecated('Use riskDescriptor instead')
const Risk$json = {
  '1': 'Risk',
  '2': [
    {
      '1': 'consequence',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Consequence',
      '10': 'consequence'
    },
    {
      '1': 'likelihood',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Likelihood',
      '10': 'likelihood'
    },
    {'1': 'score', '3': 3, '4': 1, '5': 5, '10': 'score'},
    {
      '1': 'band',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.RiskBand',
      '10': 'band'
    },
  ],
};

/// Descriptor for `Risk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskDescriptor = $convert.base64Decode(
    'CgRSaXNrEkQKC2NvbnNlcXVlbmNlGAEgASgOMiIuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNvbn'
    'NlcXVlbmNlUgtjb25zZXF1ZW5jZRJBCgpsaWtlbGlob29kGAIgASgOMiEuaGVhbHRoY2FyZS5x'
    'dWFsaXR5LnYxLkxpa2VsaWhvb2RSCmxpa2VsaWhvb2QSFAoFc2NvcmUYAyABKAVSBXNjb3JlEj'
    'MKBGJhbmQYBCABKA4yHy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmlza0JhbmRSBGJhbmQ=');

@$core.Deprecated('Use incidentDescriptor instead')
const Incident$json = {
  '1': 'Incident',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'category', '3': 3, '4': 1, '5': 9, '10': 'category'},
    {'1': 'subcategory', '3': 4, '4': 1, '5': 9, '10': 'subcategory'},
    {
      '1': 'reach',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Reach',
      '10': 'reach'
    },
    {
      '1': 'harm',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Harm',
      '10': 'harm'
    },
    {
      '1': 'risk',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Risk',
      '10': 'risk'
    },
    {'1': 'patient_id', '3': 8, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 9, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'asset_id', '3': 10, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'location_id', '3': 11, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'facility_id', '3': 12, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'department', '3': 13, '4': 1, '5': 9, '10': 'department'},
    {'1': 'narrative', '3': 14, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'immediate_action', '3': 15, '4': 1, '5': 9, '10': 'immediateAction'},
    {'1': 'sentinel', '3': 16, '4': 1, '5': 8, '10': 'sentinel'},
    {'1': 'restricted', '3': 17, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'redacted', '3': 18, '4': 1, '5': 8, '10': 'redacted'},
    {
      '1': 'state',
      '3': 19,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.IncidentState',
      '10': 'state'
    },
    {'1': 'anonymous', '3': 20, '4': 1, '5': 8, '10': 'anonymous'},
    {'1': 'reported_by', '3': 21, '4': 1, '5': 9, '10': 'reportedBy'},
    {
      '1': 'occurred_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'reported_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reviewed_by', '3': 24, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 25,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'closed_by', '3': 26, '4': 1, '5': 9, '10': 'closedBy'},
    {
      '1': 'closed_at',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closure_reason', '3': 28, '4': 1, '5': 9, '10': 'closureReason'},
    {'1': 'version', '3': 29, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Incident`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List incidentDescriptor = $convert.base64Decode(
    'CghJbmNpZGVudBIfCgtpbmNpZGVudF9pZBgBIAEoCVIKaW5jaWRlbnRJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRIaCghjYXRlZ29yeRgDIAEoCVIIY2F0ZWdvcnkSIAoLc3ViY2F0'
    'ZWdvcnkYBCABKAlSC3N1YmNhdGVnb3J5EjIKBXJlYWNoGAUgASgOMhwuaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLlJlYWNoUgVyZWFjaBIvCgRoYXJtGAYgASgOMhsuaGVhbHRoY2FyZS5xdWFsaXR5'
    'LnYxLkhhcm1SBGhhcm0SLwoEcmlzaxgHIAEoCzIbLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SaX'
    'NrUgRyaXNrEh0KCnBhdGllbnRfaWQYCCABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQY'
    'CSABKAlSC2VuY291bnRlcklkEhkKCGFzc2V0X2lkGAogASgJUgdhc3NldElkEh8KC2xvY2F0aW'
    '9uX2lkGAsgASgJUgpsb2NhdGlvbklkEh8KC2ZhY2lsaXR5X2lkGAwgASgJUgpmYWNpbGl0eUlk'
    'Eh4KCmRlcGFydG1lbnQYDSABKAlSCmRlcGFydG1lbnQSHAoJbmFycmF0aXZlGA4gASgJUgluYX'
    'JyYXRpdmUSKQoQaW1tZWRpYXRlX2FjdGlvbhgPIAEoCVIPaW1tZWRpYXRlQWN0aW9uEhoKCHNl'
    'bnRpbmVsGBAgASgIUghzZW50aW5lbBIeCgpyZXN0cmljdGVkGBEgASgIUgpyZXN0cmljdGVkEh'
    'oKCHJlZGFjdGVkGBIgASgIUghyZWRhY3RlZBI6CgVzdGF0ZRgTIAEoDjIkLmhlYWx0aGNhcmUu'
    'cXVhbGl0eS52MS5JbmNpZGVudFN0YXRlUgVzdGF0ZRIcCglhbm9ueW1vdXMYFCABKAhSCWFub2'
    '55bW91cxIfCgtyZXBvcnRlZF9ieRgVIAEoCVIKcmVwb3J0ZWRCeRI7CgtvY2N1cnJlZF9hdBgW'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQSOwoLcmVwb3J0ZW'
    'RfYXQYFyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZXBvcnRlZEF0Eh8KC3Jl'
    'dmlld2VkX2J5GBggASgJUgpyZXZpZXdlZEJ5EjsKC3Jldmlld2VkX2F0GBkgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmV2aWV3ZWRBdBIbCgljbG9zZWRfYnkYGiABKAlSCGNs'
    'b3NlZEJ5EjcKCWNsb3NlZF9hdBgbIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCG'
    'Nsb3NlZEF0EiUKDmNsb3N1cmVfcmVhc29uGBwgASgJUg1jbG9zdXJlUmVhc29uEhgKB3ZlcnNp'
    'b24YHSABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use reportIncidentRequestDescriptor instead')
const ReportIncidentRequest$json = {
  '1': 'ReportIncidentRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'category', '3': 2, '4': 1, '5': 9, '10': 'category'},
    {'1': 'subcategory', '3': 3, '4': 1, '5': 9, '10': 'subcategory'},
    {
      '1': 'reach',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Reach',
      '10': 'reach'
    },
    {
      '1': 'harm',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Harm',
      '10': 'harm'
    },
    {
      '1': 'consequence',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Consequence',
      '10': 'consequence'
    },
    {
      '1': 'likelihood',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Likelihood',
      '10': 'likelihood'
    },
    {'1': 'patient_id', '3': 8, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 9, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'asset_id', '3': 10, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'location_id', '3': 11, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'facility_id', '3': 12, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'department', '3': 13, '4': 1, '5': 9, '10': 'department'},
    {'1': 'narrative', '3': 14, '4': 1, '5': 9, '10': 'narrative'},
    {'1': 'immediate_action', '3': 15, '4': 1, '5': 9, '10': 'immediateAction'},
    {'1': 'sentinel', '3': 16, '4': 1, '5': 8, '10': 'sentinel'},
    {'1': 'anonymous', '3': 17, '4': 1, '5': 8, '10': 'anonymous'},
    {
      '1': 'occurred_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `ReportIncidentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIncidentRequestDescriptor = $convert.base64Decode(
    'ChVSZXBvcnRJbmNpZGVudFJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USGg'
    'oIY2F0ZWdvcnkYAiABKAlSCGNhdGVnb3J5EiAKC3N1YmNhdGVnb3J5GAMgASgJUgtzdWJjYXRl'
    'Z29yeRIyCgVyZWFjaBgEIAEoDjIcLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZWFjaFIFcmVhY2'
    'gSLwoEaGFybRgFIAEoDjIbLmhlYWx0aGNhcmUucXVhbGl0eS52MS5IYXJtUgRoYXJtEkQKC2Nv'
    'bnNlcXVlbmNlGAYgASgOMiIuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNvbnNlcXVlbmNlUgtjb2'
    '5zZXF1ZW5jZRJBCgpsaWtlbGlob29kGAcgASgOMiEuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxp'
    'a2VsaWhvb2RSCmxpa2VsaWhvb2QSHQoKcGF0aWVudF9pZBgIIAEoCVIJcGF0aWVudElkEiEKDG'
    'VuY291bnRlcl9pZBgJIAEoCVILZW5jb3VudGVySWQSGQoIYXNzZXRfaWQYCiABKAlSB2Fzc2V0'
    'SWQSHwoLbG9jYXRpb25faWQYCyABKAlSCmxvY2F0aW9uSWQSHwoLZmFjaWxpdHlfaWQYDCABKA'
    'lSCmZhY2lsaXR5SWQSHgoKZGVwYXJ0bWVudBgNIAEoCVIKZGVwYXJ0bWVudBIcCgluYXJyYXRp'
    'dmUYDiABKAlSCW5hcnJhdGl2ZRIpChBpbW1lZGlhdGVfYWN0aW9uGA8gASgJUg9pbW1lZGlhdG'
    'VBY3Rpb24SGgoIc2VudGluZWwYECABKAhSCHNlbnRpbmVsEhwKCWFub255bW91cxgRIAEoCFIJ'
    'YW5vbnltb3VzEjsKC29jY3VycmVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIKb2NjdXJyZWRBdA==');

@$core.Deprecated('Use reportIncidentResponseDescriptor instead')
const ReportIncidentResponse$json = {
  '1': 'ReportIncidentResponse',
  '2': [
    {
      '1': 'incident',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incident'
    },
  ],
};

/// Descriptor for `ReportIncidentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportIncidentResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXBvcnRJbmNpZGVudFJlc3BvbnNlEjsKCGluY2lkZW50GAEgASgLMh8uaGVhbHRoY2FyZS'
        '5xdWFsaXR5LnYxLkluY2lkZW50UghpbmNpZGVudA==');

@$core.Deprecated('Use getIncidentRequestDescriptor instead')
const GetIncidentRequest$json = {
  '1': 'GetIncidentRequest',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
  ],
};

/// Descriptor for `GetIncidentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIncidentRequestDescriptor = $convert.base64Decode(
    'ChJHZXRJbmNpZGVudFJlcXVlc3QSHwoLaW5jaWRlbnRfaWQYASABKAlSCmluY2lkZW50SWQ=');

@$core.Deprecated('Use getIncidentResponseDescriptor instead')
const GetIncidentResponse$json = {
  '1': 'GetIncidentResponse',
  '2': [
    {
      '1': 'incident',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incident'
    },
  ],
};

/// Descriptor for `GetIncidentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIncidentResponseDescriptor = $convert.base64Decode(
    'ChNHZXRJbmNpZGVudFJlc3BvbnNlEjsKCGluY2lkZW50GAEgASgLMh8uaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLkluY2lkZW50UghpbmNpZGVudA==');

@$core.Deprecated('Use listIncidentsRequestDescriptor instead')
const ListIncidentsRequest$json = {
  '1': 'ListIncidentsRequest',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.IncidentState',
      '10': 'state'
    },
    {'1': 'open_only', '3': 3, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'sentinel_only', '3': 4, '4': 1, '5': 8, '10': 'sentinelOnly'},
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

/// Descriptor for `ListIncidentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIncidentsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0SW5jaWRlbnRzUmVxdWVzdBIaCghjYXRlZ29yeRgBIAEoCVIIY2F0ZWdvcnkSOgoFc3'
    'RhdGUYAiABKA4yJC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuSW5jaWRlbnRTdGF0ZVIFc3RhdGUS'
    'GwoJb3Blbl9vbmx5GAMgASgIUghvcGVuT25seRIjCg1zZW50aW5lbF9vbmx5GAQgASgIUgxzZW'
    '50aW5lbE9ubHkSLgoEZnJvbRgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGZy'
    'b20SKgoCdG8YBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bxIbCglwYWdlX3'
    'NpemUYByABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listIncidentsResponseDescriptor instead')
const ListIncidentsResponse$json = {
  '1': 'ListIncidentsResponse',
  '2': [
    {
      '1': 'incidents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incidents'
    },
  ],
};

/// Descriptor for `ListIncidentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIncidentsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0SW5jaWRlbnRzUmVzcG9uc2USPQoJaW5jaWRlbnRzGAEgAygLMh8uaGVhbHRoY2FyZS'
    '5xdWFsaXR5LnYxLkluY2lkZW50UglpbmNpZGVudHM=');

@$core.Deprecated('Use rescoreIncidentRequestDescriptor instead')
const RescoreIncidentRequest$json = {
  '1': 'RescoreIncidentRequest',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
    {
      '1': 'consequence',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Consequence',
      '10': 'consequence'
    },
    {
      '1': 'likelihood',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Likelihood',
      '10': 'likelihood'
    },
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RescoreIncidentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescoreIncidentRequestDescriptor = $convert.base64Decode(
    'ChZSZXNjb3JlSW5jaWRlbnRSZXF1ZXN0Eh8KC2luY2lkZW50X2lkGAEgASgJUgppbmNpZGVudE'
    'lkEkQKC2NvbnNlcXVlbmNlGAIgASgOMiIuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNvbnNlcXVl'
    'bmNlUgtjb25zZXF1ZW5jZRJBCgpsaWtlbGlob29kGAMgASgOMiEuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkxpa2VsaWhvb2RSCmxpa2VsaWhvb2QSKQoQZXhwZWN0ZWRfdmVyc2lvbhgEIAEoA1IP'
    'ZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use rescoreIncidentResponseDescriptor instead')
const RescoreIncidentResponse$json = {
  '1': 'RescoreIncidentResponse',
  '2': [
    {
      '1': 'incident',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incident'
    },
  ],
};

/// Descriptor for `RescoreIncidentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescoreIncidentResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXNjb3JlSW5jaWRlbnRSZXNwb25zZRI7CghpbmNpZGVudBgBIAEoCzIfLmhlYWx0aGNhcm'
        'UucXVhbGl0eS52MS5JbmNpZGVudFIIaW5jaWRlbnQ=');

@$core.Deprecated('Use advanceIncidentRequestDescriptor instead')
const AdvanceIncidentRequest$json = {
  '1': 'AdvanceIncidentRequest',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.IncidentState',
      '10': 'state'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `AdvanceIncidentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceIncidentRequestDescriptor = $convert.base64Decode(
    'ChZBZHZhbmNlSW5jaWRlbnRSZXF1ZXN0Eh8KC2luY2lkZW50X2lkGAEgASgJUgppbmNpZGVudE'
    'lkEjoKBXN0YXRlGAIgASgOMiQuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkluY2lkZW50U3RhdGVS'
    'BXN0YXRlEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YBCABKA'
    'NSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use advanceIncidentResponseDescriptor instead')
const AdvanceIncidentResponse$json = {
  '1': 'AdvanceIncidentResponse',
  '2': [
    {
      '1': 'incident',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incident'
    },
    {'1': 'concerns', '3': 2, '4': 3, '5': 9, '10': 'concerns'},
  ],
};

/// Descriptor for `AdvanceIncidentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceIncidentResponseDescriptor = $convert.base64Decode(
    'ChdBZHZhbmNlSW5jaWRlbnRSZXNwb25zZRI7CghpbmNpZGVudBgBIAEoCzIfLmhlYWx0aGNhcm'
    'UucXVhbGl0eS52MS5JbmNpZGVudFIIaW5jaWRlbnQSGgoIY29uY2VybnMYAiADKAlSCGNvbmNl'
    'cm5z');

@$core.Deprecated('Use setIncidentRestrictionRequestDescriptor instead')
const SetIncidentRestrictionRequest$json = {
  '1': 'SetIncidentRestrictionRequest',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
    {'1': 'restricted', '3': 2, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `SetIncidentRestrictionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setIncidentRestrictionRequestDescriptor = $convert.base64Decode(
    'Ch1TZXRJbmNpZGVudFJlc3RyaWN0aW9uUmVxdWVzdBIfCgtpbmNpZGVudF9pZBgBIAEoCVIKaW'
    '5jaWRlbnRJZBIeCgpyZXN0cmljdGVkGAIgASgIUgpyZXN0cmljdGVkEhYKBnJlYXNvbhgDIAEo'
    'CVIGcmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YBCABKANSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use setIncidentRestrictionResponseDescriptor instead')
const SetIncidentRestrictionResponse$json = {
  '1': 'SetIncidentRestrictionResponse',
  '2': [
    {
      '1': 'incident',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Incident',
      '10': 'incident'
    },
  ],
};

/// Descriptor for `SetIncidentRestrictionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setIncidentRestrictionResponseDescriptor =
    $convert.base64Decode(
        'Ch5TZXRJbmNpZGVudFJlc3RyaWN0aW9uUmVzcG9uc2USOwoIaW5jaWRlbnQYASABKAsyHy5oZW'
        'FsdGhjYXJlLnF1YWxpdHkudjEuSW5jaWRlbnRSCGluY2lkZW50');

@$core.Deprecated('Use trendDescriptor instead')
const Trend$json = {
  '1': 'Trend',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'count', '3': 2, '4': 1, '5': 5, '10': 'count'},
    {'1': 'near_misses', '3': 3, '4': 1, '5': 5, '10': 'nearMisses'},
    {'1': 'harmful', '3': 4, '4': 1, '5': 5, '10': 'harmful'},
    {
      '1': 'worst_harm',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Harm',
      '10': 'worstHarm'
    },
    {'1': 'extreme', '3': 6, '4': 1, '5': 5, '10': 'extreme'},
  ],
};

/// Descriptor for `Trend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendDescriptor = $convert.base64Decode(
    'CgVUcmVuZBIaCghjYXRlZ29yeRgBIAEoCVIIY2F0ZWdvcnkSFAoFY291bnQYAiABKAVSBWNvdW'
    '50Eh8KC25lYXJfbWlzc2VzGAMgASgFUgpuZWFyTWlzc2VzEhgKB2hhcm1mdWwYBCABKAVSB2hh'
    'cm1mdWwSOgoKd29yc3RfaGFybRgFIAEoDjIbLmhlYWx0aGNhcmUucXVhbGl0eS52MS5IYXJtUg'
    'l3b3JzdEhhcm0SGAoHZXh0cmVtZRgGIAEoBVIHZXh0cmVtZQ==');

@$core.Deprecated('Use getTrendsRequestDescriptor instead')
const GetTrendsRequest$json = {
  '1': 'GetTrendsRequest',
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
  ],
};

/// Descriptor for `GetTrendsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrendsRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUcmVuZHNSZXF1ZXN0Ei4KBGZyb20YASABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgRmcm9tEioKAnRvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getTrendsResponseDescriptor instead')
const GetTrendsResponse$json = {
  '1': 'GetTrendsResponse',
  '2': [
    {
      '1': 'trends',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Trend',
      '10': 'trends'
    },
  ],
};

/// Descriptor for `GetTrendsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrendsResponseDescriptor = $convert.base64Decode(
    'ChFHZXRUcmVuZHNSZXNwb25zZRI0CgZ0cmVuZHMYASADKAsyHC5oZWFsdGhjYXJlLnF1YWxpdH'
    'kudjEuVHJlbmRSBnRyZW5kcw==');

@$core.Deprecated('Use contributingFactorDescriptor instead')
const ContributingFactor$json = {
  '1': 'ContributingFactor',
  '2': [
    {
      '1': 'category',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.FactorCategory',
      '10': 'category'
    },
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'root', '3': 3, '4': 1, '5': 8, '10': 'root'},
  ],
};

/// Descriptor for `ContributingFactor`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contributingFactorDescriptor = $convert.base64Decode(
    'ChJDb250cmlidXRpbmdGYWN0b3ISQQoIY2F0ZWdvcnkYASABKA4yJS5oZWFsdGhjYXJlLnF1YW'
    'xpdHkudjEuRmFjdG9yQ2F0ZWdvcnlSCGNhdGVnb3J5EhYKBmRldGFpbBgCIAEoCVIGZGV0YWls'
    'EhIKBHJvb3QYAyABKAhSBHJvb3Q=');

@$core.Deprecated('Use rootCauseAnalysisDescriptor instead')
const RootCauseAnalysis$json = {
  '1': 'RootCauseAnalysis',
  '2': [
    {'1': 'rca_id', '3': 1, '4': 1, '5': 9, '10': 'rcaId'},
    {'1': 'incident_id', '3': 2, '4': 1, '5': 9, '10': 'incidentId'},
    {'1': 'method', '3': 3, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'accountable_owner',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'accountableOwner'
    },
    {
      '1': 'factors',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ContributingFactor',
      '10': 'factors'
    },
    {'1': 'findings', '3': 6, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'no_action_reason', '3': 7, '4': 1, '5': 9, '10': 'noActionReason'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ReviewState',
      '10': 'state'
    },
    {'1': 'restricted', '3': 9, '4': 1, '5': 8, '10': 'restricted'},
    {
      '1': 'opened_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
    {'1': 'opened_by', '3': 11, '4': 1, '5': 9, '10': 'openedBy'},
    {
      '1': 'closed_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 13, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RootCauseAnalysis`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rootCauseAnalysisDescriptor = $convert.base64Decode(
    'ChFSb290Q2F1c2VBbmFseXNpcxIVCgZyY2FfaWQYASABKAlSBXJjYUlkEh8KC2luY2lkZW50X2'
    'lkGAIgASgJUgppbmNpZGVudElkEhYKBm1ldGhvZBgDIAEoCVIGbWV0aG9kEisKEWFjY291bnRh'
    'YmxlX293bmVyGAQgASgJUhBhY2NvdW50YWJsZU93bmVyEkMKB2ZhY3RvcnMYBSADKAsyKS5oZW'
    'FsdGhjYXJlLnF1YWxpdHkudjEuQ29udHJpYnV0aW5nRmFjdG9yUgdmYWN0b3JzEhoKCGZpbmRp'
    'bmdzGAYgASgJUghmaW5kaW5ncxIoChBub19hY3Rpb25fcmVhc29uGAcgASgJUg5ub0FjdGlvbl'
    'JlYXNvbhI4CgVzdGF0ZRgIIAEoDjIiLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZXZpZXdTdGF0'
    'ZVIFc3RhdGUSHgoKcmVzdHJpY3RlZBgJIAEoCFIKcmVzdHJpY3RlZBI3CglvcGVuZWRfYXQYCi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghvcGVuZWRBdBIbCglvcGVuZWRfYnkY'
    'CyABKAlSCG9wZW5lZEJ5EjcKCWNsb3NlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCGNsb3NlZEF0EhsKCWNsb3NlZF9ieRgNIAEoCVIIY2xvc2VkQnkSGAoHdmVyc2lv'
    'bhgOIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use startRcaRequestDescriptor instead')
const StartRcaRequest$json = {
  '1': 'StartRcaRequest',
  '2': [
    {'1': 'incident_id', '3': 1, '4': 1, '5': 9, '10': 'incidentId'},
    {'1': 'method', '3': 2, '4': 1, '5': 9, '10': 'method'},
  ],
};

/// Descriptor for `StartRcaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRcaRequestDescriptor = $convert.base64Decode(
    'Cg9TdGFydFJjYVJlcXVlc3QSHwoLaW5jaWRlbnRfaWQYASABKAlSCmluY2lkZW50SWQSFgoGbW'
    'V0aG9kGAIgASgJUgZtZXRob2Q=');

@$core.Deprecated('Use startRcaResponseDescriptor instead')
const StartRcaResponse$json = {
  '1': 'StartRcaResponse',
  '2': [
    {
      '1': 'rca',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.RootCauseAnalysis',
      '10': 'rca'
    },
  ],
};

/// Descriptor for `StartRcaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startRcaResponseDescriptor = $convert.base64Decode(
    'ChBTdGFydFJjYVJlc3BvbnNlEjoKA3JjYRgBIAEoCzIoLmhlYWx0aGNhcmUucXVhbGl0eS52MS'
    '5Sb290Q2F1c2VBbmFseXNpc1IDcmNh');

@$core.Deprecated('Use addFactorRequestDescriptor instead')
const AddFactorRequest$json = {
  '1': 'AddFactorRequest',
  '2': [
    {'1': 'rca_id', '3': 1, '4': 1, '5': 9, '10': 'rcaId'},
    {
      '1': 'factor',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.ContributingFactor',
      '10': 'factor'
    },
  ],
};

/// Descriptor for `AddFactorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFactorRequestDescriptor = $convert.base64Decode(
    'ChBBZGRGYWN0b3JSZXF1ZXN0EhUKBnJjYV9pZBgBIAEoCVIFcmNhSWQSQQoGZmFjdG9yGAIgAS'
    'gLMikuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNvbnRyaWJ1dGluZ0ZhY3RvclIGZmFjdG9y');

@$core.Deprecated('Use addFactorResponseDescriptor instead')
const AddFactorResponse$json = {
  '1': 'AddFactorResponse',
  '2': [
    {
      '1': 'rca',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.RootCauseAnalysis',
      '10': 'rca'
    },
  ],
};

/// Descriptor for `AddFactorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFactorResponseDescriptor = $convert.base64Decode(
    'ChFBZGRGYWN0b3JSZXNwb25zZRI6CgNyY2EYASABKAsyKC5oZWFsdGhjYXJlLnF1YWxpdHkudj'
    'EuUm9vdENhdXNlQW5hbHlzaXNSA3JjYQ==');

@$core.Deprecated('Use completeRcaRequestDescriptor instead')
const CompleteRcaRequest$json = {
  '1': 'CompleteRcaRequest',
  '2': [
    {'1': 'rca_id', '3': 1, '4': 1, '5': 9, '10': 'rcaId'},
    {
      '1': 'accountable_owner',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'accountableOwner'
    },
    {'1': 'findings', '3': 3, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'no_action_reason', '3': 4, '4': 1, '5': 9, '10': 'noActionReason'},
    {'1': 'expected_version', '3': 5, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CompleteRcaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRcaRequestDescriptor = $convert.base64Decode(
    'ChJDb21wbGV0ZVJjYVJlcXVlc3QSFQoGcmNhX2lkGAEgASgJUgVyY2FJZBIrChFhY2NvdW50YW'
    'JsZV9vd25lchgCIAEoCVIQYWNjb3VudGFibGVPd25lchIaCghmaW5kaW5ncxgDIAEoCVIIZmlu'
    'ZGluZ3MSKAoQbm9fYWN0aW9uX3JlYXNvbhgEIAEoCVIObm9BY3Rpb25SZWFzb24SKQoQZXhwZW'
    'N0ZWRfdmVyc2lvbhgFIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use completeRcaResponseDescriptor instead')
const CompleteRcaResponse$json = {
  '1': 'CompleteRcaResponse',
  '2': [
    {
      '1': 'rca',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.RootCauseAnalysis',
      '10': 'rca'
    },
  ],
};

/// Descriptor for `CompleteRcaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeRcaResponseDescriptor = $convert.base64Decode(
    'ChNDb21wbGV0ZVJjYVJlc3BvbnNlEjoKA3JjYRgBIAEoCzIoLmhlYWx0aGNhcmUucXVhbGl0eS'
    '52MS5Sb290Q2F1c2VBbmFseXNpc1IDcmNh');

@$core.Deprecated('Use getRcaRequestDescriptor instead')
const GetRcaRequest$json = {
  '1': 'GetRcaRequest',
  '2': [
    {'1': 'rca_id', '3': 1, '4': 1, '5': 9, '10': 'rcaId'},
  ],
};

/// Descriptor for `GetRcaRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRcaRequestDescriptor = $convert
    .base64Decode('Cg1HZXRSY2FSZXF1ZXN0EhUKBnJjYV9pZBgBIAEoCVIFcmNhSWQ=');

@$core.Deprecated('Use getRcaResponseDescriptor instead')
const GetRcaResponse$json = {
  '1': 'GetRcaResponse',
  '2': [
    {
      '1': 'rca',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.RootCauseAnalysis',
      '10': 'rca'
    },
  ],
};

/// Descriptor for `GetRcaResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRcaResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRSY2FSZXNwb25zZRI6CgNyY2EYASABKAsyKC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUm'
    '9vdENhdXNlQW5hbHlzaXNSA3JjYQ==');

@$core.Deprecated('Use effectivenessCheckDescriptor instead')
const EffectivenessCheck$json = {
  '1': 'EffectivenessCheck',
  '2': [
    {
      '1': 'checked_at',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedAt'
    },
    {'1': 'checked_by', '3': 2, '4': 1, '5': 9, '10': 'checkedBy'},
    {'1': 'effective', '3': 3, '4': 1, '5': 8, '10': 'effective'},
    {'1': 'evidence', '3': 4, '4': 1, '5': 9, '10': 'evidence'},
  ],
};

/// Descriptor for `EffectivenessCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List effectivenessCheckDescriptor = $convert.base64Decode(
    'ChJFZmZlY3RpdmVuZXNzQ2hlY2sSOQoKY2hlY2tlZF9hdBgBIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCWNoZWNrZWRBdBIdCgpjaGVja2VkX2J5GAIgASgJUgljaGVja2VkQnkS'
    'HAoJZWZmZWN0aXZlGAMgASgIUgllZmZlY3RpdmUSGgoIZXZpZGVuY2UYBCABKAlSCGV2aWRlbm'
    'Nl');

@$core.Deprecated('Use correctiveActionDescriptor instead')
const CorrectiveAction$json = {
  '1': 'CorrectiveAction',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionKind',
      '10': 'kind'
    },
    {
      '1': 'source_kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionSource',
      '10': 'sourceKind'
    },
    {'1': 'source_id', '3': 5, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
    {'1': 'owner_id', '3': 7, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'due_on',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueOn'
    },
    {
      '1': 'effectiveness_due_on',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectivenessDueOn'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionState',
      '10': 'state'
    },
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
      '1': 'checks',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.EffectivenessCheck',
      '10': 'checks'
    },
    {'1': 'closed_by', '3': 14, '4': 1, '5': 9, '10': 'closedBy'},
    {
      '1': 'closed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closure_note', '3': 16, '4': 1, '5': 9, '10': 'closureNote'},
    {'1': 'cancelled_reason', '3': 17, '4': 1, '5': 9, '10': 'cancelledReason'},
    {'1': 'restricted', '3': 18, '4': 1, '5': 8, '10': 'restricted'},
    {
      '1': 'raised_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 20, '4': 1, '5': 9, '10': 'raisedBy'},
    {'1': 'version', '3': 21, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CorrectiveAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctiveActionDescriptor = $convert.base64Decode(
    'ChBDb3JyZWN0aXZlQWN0aW9uEhcKB2NhcGFfaWQYASABKAlSBmNhcGFJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRI1CgRraW5kGAMgASgOMiEuaGVhbHRoY2FyZS5xdWFsaXR5LnYx'
    'LkFjdGlvbktpbmRSBGtpbmQSRAoLc291cmNlX2tpbmQYBCABKA4yIy5oZWFsdGhjYXJlLnF1YW'
    'xpdHkudjEuQWN0aW9uU291cmNlUgpzb3VyY2VLaW5kEhsKCXNvdXJjZV9pZBgFIAEoCVIIc291'
    'cmNlSWQSFgoGYWN0aW9uGAYgASgJUgZhY3Rpb24SGQoIb3duZXJfaWQYByABKAlSB293bmVySW'
    'QSMQoGZHVlX29uGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlT24STAoU'
    'ZWZmZWN0aXZlbmVzc19kdWVfb24YCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUh'
    'JlZmZlY3RpdmVuZXNzRHVlT24SOAoFc3RhdGUYCiABKA4yIi5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuQWN0aW9uU3RhdGVSBXN0YXRlEh8KC2FwcHJvdmVkX2J5GAsgASgJUgphcHByb3ZlZEJ5Ej'
    'sKC2FwcHJvdmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYXBwcm92'
    'ZWRBdBJBCgZjaGVja3MYDSADKAsyKS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuRWZmZWN0aXZlbm'
    'Vzc0NoZWNrUgZjaGVja3MSGwoJY2xvc2VkX2J5GA4gASgJUghjbG9zZWRCeRI3CgljbG9zZWRf'
    'YXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghjbG9zZWRBdBIhCgxjbG9zdX'
    'JlX25vdGUYECABKAlSC2Nsb3N1cmVOb3RlEikKEGNhbmNlbGxlZF9yZWFzb24YESABKAlSD2Nh'
    'bmNlbGxlZFJlYXNvbhIeCgpyZXN0cmljdGVkGBIgASgIUgpyZXN0cmljdGVkEjcKCXJhaXNlZF'
    '9hdBgTIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHJhaXNlZEF0EhsKCXJhaXNl'
    'ZF9ieRgUIAEoCVIIcmFpc2VkQnkSGAoHdmVyc2lvbhgVIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use raiseActionRequestDescriptor instead')
const RaiseActionRequest$json = {
  '1': 'RaiseActionRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionKind',
      '10': 'kind'
    },
    {
      '1': 'source_kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionSource',
      '10': 'sourceKind'
    },
    {'1': 'source_id', '3': 4, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'action', '3': 5, '4': 1, '5': 9, '10': 'action'},
    {'1': 'owner_id', '3': 6, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'due_on',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueOn'
    },
    {
      '1': 'effectiveness_due_on',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectivenessDueOn'
    },
    {'1': 'restricted', '3': 9, '4': 1, '5': 8, '10': 'restricted'},
  ],
};

/// Descriptor for `RaiseActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseActionRequestDescriptor = $convert.base64Decode(
    'ChJSYWlzZUFjdGlvblJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USNQoEa2'
    'luZBgCIAEoDjIhLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BY3Rpb25LaW5kUgRraW5kEkQKC3Nv'
    'dXJjZV9raW5kGAMgASgOMiMuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkFjdGlvblNvdXJjZVIKc2'
    '91cmNlS2luZBIbCglzb3VyY2VfaWQYBCABKAlSCHNvdXJjZUlkEhYKBmFjdGlvbhgFIAEoCVIG'
    'YWN0aW9uEhkKCG93bmVyX2lkGAYgASgJUgdvd25lcklkEjEKBmR1ZV9vbhgHIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZU9uEkwKFGVmZmVjdGl2ZW5lc3NfZHVlX29uGAgg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFISZWZmZWN0aXZlbmVzc0R1ZU9uEh4KCn'
    'Jlc3RyaWN0ZWQYCSABKAhSCnJlc3RyaWN0ZWQ=');

@$core.Deprecated('Use raiseActionResponseDescriptor instead')
const RaiseActionResponse$json = {
  '1': 'RaiseActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `RaiseActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseActionResponseDescriptor = $convert.base64Decode(
    'ChNSYWlzZUFjdGlvblJlc3BvbnNlEj8KBmFjdGlvbhgBIAEoCzInLmhlYWx0aGNhcmUucXVhbG'
    'l0eS52MS5Db3JyZWN0aXZlQWN0aW9uUgZhY3Rpb24=');

@$core.Deprecated('Use approveActionRequestDescriptor instead')
const ApproveActionRequest$json = {
  '1': 'ApproveActionRequest',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ApproveActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveActionRequestDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlQWN0aW9uUmVxdWVzdBIXCgdjYXBhX2lkGAEgASgJUgZjYXBhSWQSKQoQZXhwZW'
    'N0ZWRfdmVyc2lvbhgCIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use approveActionResponseDescriptor instead')
const ApproveActionResponse$json = {
  '1': 'ApproveActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `ApproveActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveActionResponseDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlQWN0aW9uUmVzcG9uc2USPwoGYWN0aW9uGAEgASgLMicuaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLkNvcnJlY3RpdmVBY3Rpb25SBmFjdGlvbg==');

@$core.Deprecated('Use advanceActionRequestDescriptor instead')
const AdvanceActionRequest$json = {
  '1': 'AdvanceActionRequest',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionState',
      '10': 'state'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `AdvanceActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceActionRequestDescriptor = $convert.base64Decode(
    'ChRBZHZhbmNlQWN0aW9uUmVxdWVzdBIXCgdjYXBhX2lkGAEgASgJUgZjYXBhSWQSOAoFc3RhdG'
    'UYAiABKA4yIi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQWN0aW9uU3RhdGVSBXN0YXRlEhYKBnJl'
    'YXNvbhgDIAEoCVIGcmVhc29uEikKEGV4cGVjdGVkX3ZlcnNpb24YBCABKANSD2V4cGVjdGVkVm'
    'Vyc2lvbg==');

@$core.Deprecated('Use advanceActionResponseDescriptor instead')
const AdvanceActionResponse$json = {
  '1': 'AdvanceActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `AdvanceActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceActionResponseDescriptor = $convert.base64Decode(
    'ChVBZHZhbmNlQWN0aW9uUmVzcG9uc2USPwoGYWN0aW9uGAEgASgLMicuaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLkNvcnJlY3RpdmVBY3Rpb25SBmFjdGlvbg==');

@$core.Deprecated('Use recordEffectivenessRequestDescriptor instead')
const RecordEffectivenessRequest$json = {
  '1': 'RecordEffectivenessRequest',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
    {'1': 'effective', '3': 2, '4': 1, '5': 8, '10': 'effective'},
    {'1': 'evidence', '3': 3, '4': 1, '5': 9, '10': 'evidence'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RecordEffectivenessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEffectivenessRequestDescriptor =
    $convert.base64Decode(
        'ChpSZWNvcmRFZmZlY3RpdmVuZXNzUmVxdWVzdBIXCgdjYXBhX2lkGAEgASgJUgZjYXBhSWQSHA'
        'oJZWZmZWN0aXZlGAIgASgIUgllZmZlY3RpdmUSGgoIZXZpZGVuY2UYAyABKAlSCGV2aWRlbmNl'
        'EikKEGV4cGVjdGVkX3ZlcnNpb24YBCABKANSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use recordEffectivenessResponseDescriptor instead')
const RecordEffectivenessResponse$json = {
  '1': 'RecordEffectivenessResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `RecordEffectivenessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEffectivenessResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWNvcmRFZmZlY3RpdmVuZXNzUmVzcG9uc2USPwoGYWN0aW9uGAEgASgLMicuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkNvcnJlY3RpdmVBY3Rpb25SBmFjdGlvbg==');

@$core.Deprecated('Use closeActionRequestDescriptor instead')
const CloseActionRequest$json = {
  '1': 'CloseActionRequest',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CloseActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeActionRequestDescriptor = $convert.base64Decode(
    'ChJDbG9zZUFjdGlvblJlcXVlc3QSFwoHY2FwYV9pZBgBIAEoCVIGY2FwYUlkEhIKBG5vdGUYAi'
    'ABKAlSBG5vdGUSKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use closeActionResponseDescriptor instead')
const CloseActionResponse$json = {
  '1': 'CloseActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `CloseActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeActionResponseDescriptor = $convert.base64Decode(
    'ChNDbG9zZUFjdGlvblJlc3BvbnNlEj8KBmFjdGlvbhgBIAEoCzInLmhlYWx0aGNhcmUucXVhbG'
    'l0eS52MS5Db3JyZWN0aXZlQWN0aW9uUgZhY3Rpb24=');

@$core.Deprecated('Use getActionRequestDescriptor instead')
const GetActionRequest$json = {
  '1': 'GetActionRequest',
  '2': [
    {'1': 'capa_id', '3': 1, '4': 1, '5': 9, '10': 'capaId'},
  ],
};

/// Descriptor for `GetActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActionRequestDescriptor = $convert.base64Decode(
    'ChBHZXRBY3Rpb25SZXF1ZXN0EhcKB2NhcGFfaWQYASABKAlSBmNhcGFJZA==');

@$core.Deprecated('Use getActionResponseDescriptor instead')
const GetActionResponse$json = {
  '1': 'GetActionResponse',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
  ],
};

/// Descriptor for `GetActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActionResponseDescriptor = $convert.base64Decode(
    'ChFHZXRBY3Rpb25SZXNwb25zZRI/CgZhY3Rpb24YASABKAsyJy5oZWFsdGhjYXJlLnF1YWxpdH'
    'kudjEuQ29ycmVjdGl2ZUFjdGlvblIGYWN0aW9u');

@$core.Deprecated('Use listActionsRequestDescriptor instead')
const ListActionsRequest$json = {
  '1': 'ListActionsRequest',
  '2': [
    {
      '1': 'source_kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ActionSource',
      '10': 'sourceKind'
    },
    {'1': 'source_id', '3': 2, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'live_only', '3': 4, '4': 1, '5': 8, '10': 'liveOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listActionsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0QWN0aW9uc1JlcXVlc3QSRAoLc291cmNlX2tpbmQYASABKA4yIy5oZWFsdGhjYXJlLn'
    'F1YWxpdHkudjEuQWN0aW9uU291cmNlUgpzb3VyY2VLaW5kEhsKCXNvdXJjZV9pZBgCIAEoCVII'
    'c291cmNlSWQSGQoIb3duZXJfaWQYAyABKAlSB293bmVySWQSGwoJbGl2ZV9vbmx5GAQgASgIUg'
    'hsaXZlT25seRIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listActionsResponseDescriptor instead')
const ListActionsResponse$json = {
  '1': 'ListActionsResponse',
  '2': [
    {
      '1': 'actions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'actions'
    },
  ],
};

/// Descriptor for `ListActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listActionsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0QWN0aW9uc1Jlc3BvbnNlEkEKB2FjdGlvbnMYASADKAsyJy5oZWFsdGhjYXJlLnF1YW'
    'xpdHkudjEuQ29ycmVjdGl2ZUFjdGlvblIHYWN0aW9ucw==');

@$core.Deprecated('Use overdueActionDescriptor instead')
const OverdueAction$json = {
  '1': 'OverdueAction',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.CorrectiveAction',
      '10': 'action'
    },
    {
      '1': 'action_overdue_days',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'actionOverdueDays'
    },
    {
      '1': 'check_overdue_days',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'checkOverdueDays'
    },
  ],
};

/// Descriptor for `OverdueAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overdueActionDescriptor = $convert.base64Decode(
    'Cg1PdmVyZHVlQWN0aW9uEj8KBmFjdGlvbhgBIAEoCzInLmhlYWx0aGNhcmUucXVhbGl0eS52MS'
    '5Db3JyZWN0aXZlQWN0aW9uUgZhY3Rpb24SLgoTYWN0aW9uX292ZXJkdWVfZGF5cxgCIAEoBVIR'
    'YWN0aW9uT3ZlcmR1ZURheXMSLAoSY2hlY2tfb3ZlcmR1ZV9kYXlzGAMgASgFUhBjaGVja092ZX'
    'JkdWVEYXlz');

@$core.Deprecated('Use listOverdueActionsRequestDescriptor instead')
const ListOverdueActionsRequest$json = {
  '1': 'ListOverdueActionsRequest',
};

/// Descriptor for `ListOverdueActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOverdueActionsRequestDescriptor =
    $convert.base64Decode('ChlMaXN0T3ZlcmR1ZUFjdGlvbnNSZXF1ZXN0');

@$core.Deprecated('Use listOverdueActionsResponseDescriptor instead')
const ListOverdueActionsResponse$json = {
  '1': 'ListOverdueActionsResponse',
  '2': [
    {
      '1': 'overdue',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.OverdueAction',
      '10': 'overdue'
    },
  ],
};

/// Descriptor for `ListOverdueActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOverdueActionsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0T3ZlcmR1ZUFjdGlvbnNSZXNwb25zZRI+CgdvdmVyZHVlGAEgAygLMiQuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLk92ZXJkdWVBY3Rpb25SB292ZXJkdWU=');

@$core.Deprecated('Use escalateOverdueActionsRequestDescriptor instead')
const EscalateOverdueActionsRequest$json = {
  '1': 'EscalateOverdueActionsRequest',
};

/// Descriptor for `EscalateOverdueActionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueActionsRequestDescriptor =
    $convert.base64Decode('Ch1Fc2NhbGF0ZU92ZXJkdWVBY3Rpb25zUmVxdWVzdA==');

@$core.Deprecated('Use escalateOverdueActionsResponseDescriptor instead')
const EscalateOverdueActionsResponse$json = {
  '1': 'EscalateOverdueActionsResponse',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
  ],
};

/// Descriptor for `EscalateOverdueActionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueActionsResponseDescriptor =
    $convert.base64Decode(
        'Ch5Fc2NhbGF0ZU92ZXJkdWVBY3Rpb25zUmVzcG9uc2USFgoGcmFpc2VkGAEgASgFUgZyYWlzZW'
        'Q=');

@$core.Deprecated('Use controlledDocumentDescriptor instead')
const ControlledDocument$json = {
  '1': 'ControlledDocument',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'owner_id', '3': 5, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'review_months', '3': 6, '4': 1, '5': 5, '10': 'reviewMonths'},
    {'1': 'department', '3': 7, '4': 1, '5': 9, '10': 'department'},
    {'1': 'withdrawn', '3': 8, '4': 1, '5': 8, '10': 'withdrawn'},
    {
      '1': 'withdrawn_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'withdrawnAt'
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
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ControlledDocument`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List controlledDocumentDescriptor = $convert.base64Decode(
    'ChJDb250cm9sbGVkRG9jdW1lbnQSHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW50SWQSEg'
    'oEY29kZRgCIAEoCVIEY29kZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSNwoEa2luZBgEIAEoDjIj'
    'LmhlYWx0aGNhcmUucXVhbGl0eS52MS5Eb2N1bWVudEtpbmRSBGtpbmQSGQoIb3duZXJfaWQYBS'
    'ABKAlSB293bmVySWQSIwoNcmV2aWV3X21vbnRocxgGIAEoBVIMcmV2aWV3TW9udGhzEh4KCmRl'
    'cGFydG1lbnQYByABKAlSCmRlcGFydG1lbnQSHAoJd2l0aGRyYXduGAggASgIUgl3aXRoZHJhd2'
    '4SPQoMd2l0aGRyYXduX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILd2l0'
    'aGRyYXduQXQSOQoKY3JlYXRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GAsgASgJUgljcmVhdGVkQnkSGAoHdmVyc2lvbhgM'
    'IAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use documentVersionDescriptor instead')
const DocumentVersion$json = {
  '1': 'DocumentVersion',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'document_id', '3': 2, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'ordinal', '3': 4, '4': 1, '5': 5, '10': 'ordinal'},
    {'1': 'content_ref', '3': 5, '4': 1, '5': 9, '10': 'contentRef'},
    {'1': 'change_summary', '3': 6, '4': 1, '5': 9, '10': 'changeSummary'},
    {
      '1': 'state',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.VersionState',
      '10': 'state'
    },
    {'1': 'approved_by', '3': 8, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'obsolete_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'obsoleteFrom'
    },
    {
      '1': 'requires_acknowledgement',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'requiresAcknowledgement'
    },
    {
      '1': 'requires_retraining',
      '3': 13,
      '4': 1,
      '5': 8,
      '10': 'requiresRetraining'
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
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `DocumentVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List documentVersionDescriptor = $convert.base64Decode(
    'Cg9Eb2N1bWVudFZlcnNpb24SHQoKdmVyc2lvbl9pZBgBIAEoCVIJdmVyc2lvbklkEh8KC2RvY3'
    'VtZW50X2lkGAIgASgJUgpkb2N1bWVudElkEhQKBWxhYmVsGAMgASgJUgVsYWJlbBIYCgdvcmRp'
    'bmFsGAQgASgFUgdvcmRpbmFsEh8KC2NvbnRlbnRfcmVmGAUgASgJUgpjb250ZW50UmVmEiUKDm'
    'NoYW5nZV9zdW1tYXJ5GAYgASgJUg1jaGFuZ2VTdW1tYXJ5EjkKBXN0YXRlGAcgASgOMiMuaGVh'
    'bHRoY2FyZS5xdWFsaXR5LnYxLlZlcnNpb25TdGF0ZVIFc3RhdGUSHwoLYXBwcm92ZWRfYnkYCC'
    'ABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgphcHByb3ZlZEF0EkEKDmVmZmVjdGl2ZV9mcm9tGAogASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbRI/Cg1vYnNvbGV0ZV9mcm9tGAsgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMb2Jzb2xldGVGcm9tEjkKGHJlcXVpcmVzX2'
    'Fja25vd2xlZGdlbWVudBgMIAEoCFIXcmVxdWlyZXNBY2tub3dsZWRnZW1lbnQSLwoTcmVxdWly'
    'ZXNfcmV0cmFpbmluZxgNIAEoCFIScmVxdWlyZXNSZXRyYWluaW5nEjkKCmNyZWF0ZWRfYXQYDi'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9i'
    'eRgPIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNpb24YECABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use registerDocumentRequestDescriptor instead')
const RegisterDocumentRequest$json = {
  '1': 'RegisterDocumentRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'owner_id', '3': 4, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'review_months', '3': 5, '4': 1, '5': 5, '10': 'reviewMonths'},
    {'1': 'department', '3': 6, '4': 1, '5': 9, '10': 'department'},
  ],
};

/// Descriptor for `RegisterDocumentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDocumentRequestDescriptor = $convert.base64Decode(
    'ChdSZWdpc3RlckRvY3VtZW50UmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhQKBXRpdGxlGA'
    'IgASgJUgV0aXRsZRI3CgRraW5kGAMgASgOMiMuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkRvY3Vt'
    'ZW50S2luZFIEa2luZBIZCghvd25lcl9pZBgEIAEoCVIHb3duZXJJZBIjCg1yZXZpZXdfbW9udG'
    'hzGAUgASgFUgxyZXZpZXdNb250aHMSHgoKZGVwYXJ0bWVudBgGIAEoCVIKZGVwYXJ0bWVudA==');

@$core.Deprecated('Use registerDocumentResponseDescriptor instead')
const RegisterDocumentResponse$json = {
  '1': 'RegisterDocumentResponse',
  '2': [
    {
      '1': 'document',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.ControlledDocument',
      '10': 'document'
    },
  ],
};

/// Descriptor for `RegisterDocumentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerDocumentResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWdpc3RlckRvY3VtZW50UmVzcG9uc2USRQoIZG9jdW1lbnQYASABKAsyKS5oZWFsdGhjYX'
        'JlLnF1YWxpdHkudjEuQ29udHJvbGxlZERvY3VtZW50Ughkb2N1bWVudA==');

@$core.Deprecated('Use draftVersionRequestDescriptor instead')
const DraftVersionRequest$json = {
  '1': 'DraftVersionRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'content_ref', '3': 3, '4': 1, '5': 9, '10': 'contentRef'},
    {'1': 'change_summary', '3': 4, '4': 1, '5': 9, '10': 'changeSummary'},
    {
      '1': 'requires_acknowledgement',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'requiresAcknowledgement'
    },
    {
      '1': 'requires_retraining',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'requiresRetraining'
    },
  ],
};

/// Descriptor for `DraftVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftVersionRequestDescriptor = $convert.base64Decode(
    'ChNEcmFmdFZlcnNpb25SZXF1ZXN0Eh8KC2RvY3VtZW50X2lkGAEgASgJUgpkb2N1bWVudElkEh'
    'QKBWxhYmVsGAIgASgJUgVsYWJlbBIfCgtjb250ZW50X3JlZhgDIAEoCVIKY29udGVudFJlZhIl'
    'Cg5jaGFuZ2Vfc3VtbWFyeRgEIAEoCVINY2hhbmdlU3VtbWFyeRI5ChhyZXF1aXJlc19hY2tub3'
    'dsZWRnZW1lbnQYBSABKAhSF3JlcXVpcmVzQWNrbm93bGVkZ2VtZW50Ei8KE3JlcXVpcmVzX3Jl'
    'dHJhaW5pbmcYBiABKAhSEnJlcXVpcmVzUmV0cmFpbmluZw==');

@$core.Deprecated('Use draftVersionResponseDescriptor instead')
const DraftVersionResponse$json = {
  '1': 'DraftVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.DocumentVersion',
      '10': 'version'
    },
  ],
};

/// Descriptor for `DraftVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftVersionResponseDescriptor = $convert.base64Decode(
    'ChREcmFmdFZlcnNpb25SZXNwb25zZRJACgd2ZXJzaW9uGAEgASgLMiYuaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLkRvY3VtZW50VmVyc2lvblIHdmVyc2lvbg==');

@$core.Deprecated('Use approveVersionRequestDescriptor instead')
const ApproveVersionRequest$json = {
  '1': 'ApproveVersionRequest',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {
      '1': 'effective_from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ApproveVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveVersionRequestDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlVmVyc2lvblJlcXVlc3QSHQoKdmVyc2lvbl9pZBgBIAEoCVIJdmVyc2lvbklkEk'
    'EKDmVmZmVjdGl2ZV9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZm'
    'ZWN0aXZlRnJvbRIpChBleHBlY3RlZF92ZXJzaW9uGAMgASgDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use approveVersionResponseDescriptor instead')
const ApproveVersionResponse$json = {
  '1': 'ApproveVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.DocumentVersion',
      '10': 'version'
    },
  ],
};

/// Descriptor for `ApproveVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveVersionResponseDescriptor =
    $convert.base64Decode(
        'ChZBcHByb3ZlVmVyc2lvblJlc3BvbnNlEkAKB3ZlcnNpb24YASABKAsyJi5oZWFsdGhjYXJlLn'
        'F1YWxpdHkudjEuRG9jdW1lbnRWZXJzaW9uUgd2ZXJzaW9u');

@$core.Deprecated('Use getCurrentVersionRequestDescriptor instead')
const GetCurrentVersionRequest$json = {
  '1': 'GetCurrentVersionRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
  ],
};

/// Descriptor for `GetCurrentVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentVersionRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRDdXJyZW50VmVyc2lvblJlcXVlc3QSHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW'
        '50SWQ=');

@$core.Deprecated('Use getCurrentVersionResponseDescriptor instead')
const GetCurrentVersionResponse$json = {
  '1': 'GetCurrentVersionResponse',
  '2': [
    {
      '1': 'version',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.DocumentVersion',
      '10': 'version'
    },
    {'1': 'found', '3': 2, '4': 1, '5': 8, '10': 'found'},
  ],
};

/// Descriptor for `GetCurrentVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentVersionResponseDescriptor = $convert.base64Decode(
    'ChlHZXRDdXJyZW50VmVyc2lvblJlc3BvbnNlEkAKB3ZlcnNpb24YASABKAsyJi5oZWFsdGhjYX'
    'JlLnF1YWxpdHkudjEuRG9jdW1lbnRWZXJzaW9uUgd2ZXJzaW9uEhQKBWZvdW5kGAIgASgIUgVm'
    'b3VuZA==');

@$core.Deprecated('Use listVersionsRequestDescriptor instead')
const ListVersionsRequest$json = {
  '1': 'ListVersionsRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
  ],
};

/// Descriptor for `ListVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVersionsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0VmVyc2lvbnNSZXF1ZXN0Eh8KC2RvY3VtZW50X2lkGAEgASgJUgpkb2N1bWVudElk');

@$core.Deprecated('Use listVersionsResponseDescriptor instead')
const ListVersionsResponse$json = {
  '1': 'ListVersionsResponse',
  '2': [
    {
      '1': 'versions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.DocumentVersion',
      '10': 'versions'
    },
  ],
};

/// Descriptor for `ListVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listVersionsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0VmVyc2lvbnNSZXNwb25zZRJCCgh2ZXJzaW9ucxgBIAMoCzImLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5Eb2N1bWVudFZlcnNpb25SCHZlcnNpb25z');

@$core.Deprecated('Use listDocumentsRequestDescriptor instead')
const ListDocumentsRequest$json = {
  '1': 'ListDocumentsRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.DocumentKind',
      '10': 'kind'
    },
    {'1': 'department', '3': 2, '4': 1, '5': 9, '10': 'department'},
    {
      '1': 'exclude_withdrawn',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'excludeWithdrawn'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDocumentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDocumentsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0RG9jdW1lbnRzUmVxdWVzdBI3CgRraW5kGAEgASgOMiMuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkRvY3VtZW50S2luZFIEa2luZBIeCgpkZXBhcnRtZW50GAIgASgJUgpkZXBhcnRtZW50'
    'EisKEWV4Y2x1ZGVfd2l0aGRyYXduGAMgASgIUhBleGNsdWRlV2l0aGRyYXduEhsKCXBhZ2Vfc2'
    'l6ZRgEIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listDocumentsResponseDescriptor instead')
const ListDocumentsResponse$json = {
  '1': 'ListDocumentsResponse',
  '2': [
    {
      '1': 'documents',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ControlledDocument',
      '10': 'documents'
    },
  ],
};

/// Descriptor for `ListDocumentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDocumentsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0RG9jdW1lbnRzUmVzcG9uc2USRwoJZG9jdW1lbnRzGAEgAygLMikuaGVhbHRoY2FyZS'
    '5xdWFsaXR5LnYxLkNvbnRyb2xsZWREb2N1bWVudFIJZG9jdW1lbnRz');

@$core.Deprecated('Use acknowledgeDocumentRequestDescriptor instead')
const AcknowledgeDocumentRequest$json = {
  '1': 'AcknowledgeDocumentRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `AcknowledgeDocumentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeDocumentRequestDescriptor =
    $convert.base64Decode(
        'ChpBY2tub3dsZWRnZURvY3VtZW50UmVxdWVzdBIfCgtkb2N1bWVudF9pZBgBIAEoCVIKZG9jdW'
        '1lbnRJZBISCgRyb2xlGAIgASgJUgRyb2xl');

@$core.Deprecated('Use acknowledgeDocumentResponseDescriptor instead')
const AcknowledgeDocumentResponse$json = {
  '1': 'AcknowledgeDocumentResponse',
  '2': [
    {
      '1': 'acknowledgement_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'acknowledgementId'
    },
    {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
    {
      '1': 'acknowledged_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
  ],
};

/// Descriptor for `AcknowledgeDocumentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeDocumentResponseDescriptor = $convert.base64Decode(
    'ChtBY2tub3dsZWRnZURvY3VtZW50UmVzcG9uc2USLQoSYWNrbm93bGVkZ2VtZW50X2lkGAEgAS'
    'gJUhFhY2tub3dsZWRnZW1lbnRJZBIdCgp2ZXJzaW9uX2lkGAIgASgJUgl2ZXJzaW9uSWQSQwoP'
    'YWNrbm93bGVkZ2VkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOYWNrbm'
    '93bGVkZ2VkQXQ=');

@$core.Deprecated('Use acknowledgementGapDescriptor instead')
const AcknowledgementGap$json = {
  '1': 'AcknowledgementGap',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'person_id', '3': 4, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'role', '3': 5, '4': 1, '5': 9, '10': 'role'},
  ],
};

/// Descriptor for `AcknowledgementGap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgementGapDescriptor = $convert.base64Decode(
    'ChJBY2tub3dsZWRnZW1lbnRHYXASHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW50SWQSHQ'
    'oKdmVyc2lvbl9pZBgCIAEoCVIJdmVyc2lvbklkEhIKBGNvZGUYAyABKAlSBGNvZGUSGwoJcGVy'
    'c29uX2lkGAQgASgJUghwZXJzb25JZBISCgRyb2xlGAUgASgJUgRyb2xl');

@$core
    .Deprecated('Use listOutstandingAcknowledgementsRequestDescriptor instead')
const ListOutstandingAcknowledgementsRequest$json = {
  '1': 'ListOutstandingAcknowledgementsRequest',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
  ],
};

/// Descriptor for `ListOutstandingAcknowledgementsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingAcknowledgementsRequestDescriptor =
    $convert.base64Decode(
        'CiZMaXN0T3V0c3RhbmRpbmdBY2tub3dsZWRnZW1lbnRzUmVxdWVzdBIfCgtkb2N1bWVudF9pZB'
        'gBIAEoCVIKZG9jdW1lbnRJZA==');

@$core
    .Deprecated('Use listOutstandingAcknowledgementsResponseDescriptor instead')
const ListOutstandingAcknowledgementsResponse$json = {
  '1': 'ListOutstandingAcknowledgementsResponse',
  '2': [
    {
      '1': 'gaps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.AcknowledgementGap',
      '10': 'gaps'
    },
  ],
};

/// Descriptor for `ListOutstandingAcknowledgementsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listOutstandingAcknowledgementsResponseDescriptor =
    $convert.base64Decode(
        'CidMaXN0T3V0c3RhbmRpbmdBY2tub3dsZWRnZW1lbnRzUmVzcG9uc2USPQoEZ2FwcxgBIAMoCz'
        'IpLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BY2tub3dsZWRnZW1lbnRHYXBSBGdhcHM=');

@$core.Deprecated('Use reviewDueDescriptor instead')
const ReviewDue$json = {
  '1': 'ReviewDue',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'owner_id', '3': 4, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'last_effective',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastEffective'
    },
    {
      '1': 'due_on',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueOn'
    },
    {'1': 'days_overdue', '3': 7, '4': 1, '5': 5, '10': 'daysOverdue'},
    {
      '1': 'no_effective_version',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'noEffectiveVersion'
    },
    {
      '1': 'no_review_interval',
      '3': 9,
      '4': 1,
      '5': 8,
      '10': 'noReviewInterval'
    },
  ],
};

/// Descriptor for `ReviewDue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewDueDescriptor = $convert.base64Decode(
    'CglSZXZpZXdEdWUSHwoLZG9jdW1lbnRfaWQYASABKAlSCmRvY3VtZW50SWQSEgoEY29kZRgCIA'
    'EoCVIEY29kZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSGQoIb3duZXJfaWQYBCABKAlSB293bmVy'
    'SWQSQQoObGFzdF9lZmZlY3RpdmUYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    '1sYXN0RWZmZWN0aXZlEjEKBmR1ZV9vbhgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
    'bXBSBWR1ZU9uEiEKDGRheXNfb3ZlcmR1ZRgHIAEoBVILZGF5c092ZXJkdWUSMAoUbm9fZWZmZW'
    'N0aXZlX3ZlcnNpb24YCCABKAhSEm5vRWZmZWN0aXZlVmVyc2lvbhIsChJub19yZXZpZXdfaW50'
    'ZXJ2YWwYCSABKAhSEG5vUmV2aWV3SW50ZXJ2YWw=');

@$core.Deprecated('Use listReviewsDueRequestDescriptor instead')
const ListReviewsDueRequest$json = {
  '1': 'ListReviewsDueRequest',
};

/// Descriptor for `ListReviewsDueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReviewsDueRequestDescriptor =
    $convert.base64Decode('ChVMaXN0UmV2aWV3c0R1ZVJlcXVlc3Q=');

@$core.Deprecated('Use listReviewsDueResponseDescriptor instead')
const ListReviewsDueResponse$json = {
  '1': 'ListReviewsDueResponse',
  '2': [
    {
      '1': 'due',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ReviewDue',
      '10': 'due'
    },
  ],
};

/// Descriptor for `ListReviewsDueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReviewsDueResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UmV2aWV3c0R1ZVJlc3BvbnNlEjIKA2R1ZRgBIAMoCzIgLmhlYWx0aGNhcmUucXVhbG'
        'l0eS52MS5SZXZpZXdEdWVSA2R1ZQ==');

@$core.Deprecated('Use competencyDescriptor instead')
const Competency$json = {
  '1': 'Competency',
  '2': [
    {'1': 'competency_id', '3': 1, '4': 1, '5': 9, '10': 'competencyId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'document_id', '3': 4, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'valid_months', '3': 5, '4': 1, '5': 5, '10': 'validMonths'},
    {'1': 'active', '3': 6, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `Competency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competencyDescriptor = $convert.base64Decode(
    'CgpDb21wZXRlbmN5EiMKDWNvbXBldGVuY3lfaWQYASABKAlSDGNvbXBldGVuY3lJZBISCgRjb2'
    'RlGAIgASgJUgRjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSHwoLZG9jdW1lbnRfaWQYBCABKAlS'
    'CmRvY3VtZW50SWQSIQoMdmFsaWRfbW9udGhzGAUgASgFUgt2YWxpZE1vbnRocxIWCgZhY3Rpdm'
    'UYBiABKAhSBmFjdGl2ZQ==');

@$core.Deprecated('Use defineCompetencyRequestDescriptor instead')
const DefineCompetencyRequest$json = {
  '1': 'DefineCompetencyRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'document_id', '3': 3, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'valid_months', '3': 4, '4': 1, '5': 5, '10': 'validMonths'},
  ],
};

/// Descriptor for `DefineCompetencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineCompetencyRequestDescriptor = $convert.base64Decode(
    'ChdEZWZpbmVDb21wZXRlbmN5UmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAi'
    'ABKAlSBG5hbWUSHwoLZG9jdW1lbnRfaWQYAyABKAlSCmRvY3VtZW50SWQSIQoMdmFsaWRfbW9u'
    'dGhzGAQgASgFUgt2YWxpZE1vbnRocw==');

@$core.Deprecated('Use defineCompetencyResponseDescriptor instead')
const DefineCompetencyResponse$json = {
  '1': 'DefineCompetencyResponse',
  '2': [
    {
      '1': 'competency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Competency',
      '10': 'competency'
    },
  ],
};

/// Descriptor for `DefineCompetencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineCompetencyResponseDescriptor =
    $convert.base64Decode(
        'ChhEZWZpbmVDb21wZXRlbmN5UmVzcG9uc2USQQoKY29tcGV0ZW5jeRgBIAEoCzIhLmhlYWx0aG'
        'NhcmUucXVhbGl0eS52MS5Db21wZXRlbmN5Ugpjb21wZXRlbmN5');

@$core.Deprecated('Use requireCompetencyRequestDescriptor instead')
const RequireCompetencyRequest$json = {
  '1': 'RequireCompetencyRequest',
  '2': [
    {'1': 'role', '3': 1, '4': 1, '5': 9, '10': 'role'},
    {'1': 'competency_id', '3': 2, '4': 1, '5': 9, '10': 'competencyId'},
  ],
};

/// Descriptor for `RequireCompetencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requireCompetencyRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXF1aXJlQ29tcGV0ZW5jeVJlcXVlc3QSEgoEcm9sZRgBIAEoCVIEcm9sZRIjCg1jb21wZX'
        'RlbmN5X2lkGAIgASgJUgxjb21wZXRlbmN5SWQ=');

@$core.Deprecated('Use requireCompetencyResponseDescriptor instead')
const RequireCompetencyResponse$json = {
  '1': 'RequireCompetencyResponse',
};

/// Descriptor for `RequireCompetencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requireCompetencyResponseDescriptor =
    $convert.base64Decode('ChlSZXF1aXJlQ29tcGV0ZW5jeVJlc3BvbnNl');

@$core.Deprecated('Use awardCompetencyRequestDescriptor instead')
const AwardCompetencyRequest$json = {
  '1': 'AwardCompetencyRequest',
  '2': [
    {'1': 'competency_id', '3': 1, '4': 1, '5': 9, '10': 'competencyId'},
    {'1': 'person_id', '3': 2, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'version_id', '3': 3, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'evidence', '3': 4, '4': 1, '5': 9, '10': 'evidence'},
    {
      '1': 'awarded_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'awardedAt'
    },
  ],
};

/// Descriptor for `AwardCompetencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List awardCompetencyRequestDescriptor = $convert.base64Decode(
    'ChZBd2FyZENvbXBldGVuY3lSZXF1ZXN0EiMKDWNvbXBldGVuY3lfaWQYASABKAlSDGNvbXBldG'
    'VuY3lJZBIbCglwZXJzb25faWQYAiABKAlSCHBlcnNvbklkEh0KCnZlcnNpb25faWQYAyABKAlS'
    'CXZlcnNpb25JZBIaCghldmlkZW5jZRgEIAEoCVIIZXZpZGVuY2USOQoKYXdhcmRlZF9hdBgFIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWF3YXJkZWRBdA==');

@$core.Deprecated('Use awardCompetencyResponseDescriptor instead')
const AwardCompetencyResponse$json = {
  '1': 'AwardCompetencyResponse',
  '2': [
    {'1': 'award_id', '3': 1, '4': 1, '5': 9, '10': 'awardId'},
    {
      '1': 'expires_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `AwardCompetencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List awardCompetencyResponseDescriptor = $convert.base64Decode(
    'ChdBd2FyZENvbXBldGVuY3lSZXNwb25zZRIZCghhd2FyZF9pZBgBIAEoCVIHYXdhcmRJZBI5Cg'
    'pleHBpcmVzX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0');

@$core.Deprecated('Use competencyGapDescriptor instead')
const CompetencyGap$json = {
  '1': 'CompetencyGap',
  '2': [
    {'1': 'person_id', '3': 1, '4': 1, '5': 9, '10': 'personId'},
    {'1': 'role', '3': 2, '4': 1, '5': 9, '10': 'role'},
    {'1': 'competency_id', '3': 3, '4': 1, '5': 9, '10': 'competencyId'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CompetencyGap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List competencyGapDescriptor = $convert.base64Decode(
    'Cg1Db21wZXRlbmN5R2FwEhsKCXBlcnNvbl9pZBgBIAEoCVIIcGVyc29uSWQSEgoEcm9sZRgCIA'
    'EoCVIEcm9sZRIjCg1jb21wZXRlbmN5X2lkGAMgASgJUgxjb21wZXRlbmN5SWQSEgoEY29kZRgE'
    'IAEoCVIEY29kZRIWCgZyZWFzb24YBSABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use listCompetencyGapsRequestDescriptor instead')
const ListCompetencyGapsRequest$json = {
  '1': 'ListCompetencyGapsRequest',
};

/// Descriptor for `ListCompetencyGapsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCompetencyGapsRequestDescriptor =
    $convert.base64Decode('ChlMaXN0Q29tcGV0ZW5jeUdhcHNSZXF1ZXN0');

@$core.Deprecated('Use listCompetencyGapsResponseDescriptor instead')
const ListCompetencyGapsResponse$json = {
  '1': 'ListCompetencyGapsResponse',
  '2': [
    {
      '1': 'gaps',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.CompetencyGap',
      '10': 'gaps'
    },
  ],
};

/// Descriptor for `ListCompetencyGapsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCompetencyGapsResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Q29tcGV0ZW5jeUdhcHNSZXNwb25zZRI4CgRnYXBzGAEgAygLMiQuaGVhbHRoY2FyZS'
        '5xdWFsaXR5LnYxLkNvbXBldGVuY3lHYXBSBGdhcHM=');

@$core.Deprecated('Use auditDescriptor instead')
const Audit$json = {
  '1': 'Audit',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'scope', '3': 4, '4': 1, '5': 9, '10': 'scope'},
    {'1': 'standard_id', '3': 5, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'auditor_id', '3': 6, '4': 1, '5': 9, '10': 'auditorId'},
    {
      '1': 'auditee_department',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'auditeeDepartment'
    },
    {
      '1': 'planned_from',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedFrom'
    },
    {
      '1': 'planned_to',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'plannedTo'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.AuditState',
      '10': 'state'
    },
    {'1': 'summary', '3': 11, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 13, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'closed_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 15, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Audit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List auditDescriptor = $convert.base64Decode(
    'CgVBdWRpdBIZCghhdWRpdF9pZBgBIAEoCVIHYXVkaXRJZBIcCglyZWZlcmVuY2UYAiABKAlSCX'
    'JlZmVyZW5jZRIUCgV0aXRsZRgDIAEoCVIFdGl0bGUSFAoFc2NvcGUYBCABKAlSBXNjb3BlEh8K'
    'C3N0YW5kYXJkX2lkGAUgASgJUgpzdGFuZGFyZElkEh0KCmF1ZGl0b3JfaWQYBiABKAlSCWF1ZG'
    'l0b3JJZBItChJhdWRpdGVlX2RlcGFydG1lbnQYByABKAlSEWF1ZGl0ZWVEZXBhcnRtZW50Ej0K'
    'DHBsYW5uZWRfZnJvbRgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3BsYW5uZW'
    'RGcm9tEjkKCnBsYW5uZWRfdG8YCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglw'
    'bGFubmVkVG8SNwoFc3RhdGUYCiABKA4yIS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQXVkaXRTdG'
    'F0ZVIFc3RhdGUSGAoHc3VtbWFyeRgLIAEoCVIHc3VtbWFyeRI5CgpjcmVhdGVkX2F0GAwgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0ZWRfYnkYDS'
    'ABKAlSCWNyZWF0ZWRCeRI3CgljbG9zZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUghjbG9zZWRBdBIbCgljbG9zZWRfYnkYDyABKAlSCGNsb3NlZEJ5EhgKB3ZlcnNpb2'
    '4YECABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use findingDescriptor instead')
const Finding$json = {
  '1': 'Finding',
  '2': [
    {'1': 'finding_id', '3': 1, '4': 1, '5': 9, '10': 'findingId'},
    {'1': 'audit_id', '3': 2, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'clause_id', '3': 3, '4': 1, '5': 9, '10': 'clauseId'},
    {
      '1': 'severity',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.FindingSeverity',
      '10': 'severity'
    },
    {'1': 'detail', '3': 5, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'evidence', '3': 6, '4': 1, '5': 9, '10': 'evidence'},
    {'1': 'capa_id', '3': 7, '4': 1, '5': 9, '10': 'capaId'},
    {
      '1': 'closed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 9, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closure_note', '3': 10, '4': 1, '5': 9, '10': 'closureNote'},
    {
      '1': 'raised_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 12, '4': 1, '5': 9, '10': 'raisedBy'},
  ],
};

/// Descriptor for `Finding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findingDescriptor = $convert.base64Decode(
    'CgdGaW5kaW5nEh0KCmZpbmRpbmdfaWQYASABKAlSCWZpbmRpbmdJZBIZCghhdWRpdF9pZBgCIA'
    'EoCVIHYXVkaXRJZBIbCgljbGF1c2VfaWQYAyABKAlSCGNsYXVzZUlkEkIKCHNldmVyaXR5GAQg'
    'ASgOMiYuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkZpbmRpbmdTZXZlcml0eVIIc2V2ZXJpdHkSFg'
    'oGZGV0YWlsGAUgASgJUgZkZXRhaWwSGgoIZXZpZGVuY2UYBiABKAlSCGV2aWRlbmNlEhcKB2Nh'
    'cGFfaWQYByABKAlSBmNhcGFJZBI3CgljbG9zZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUghjbG9zZWRBdBIbCgljbG9zZWRfYnkYCSABKAlSCGNsb3NlZEJ5EiEKDGNs'
    'b3N1cmVfbm90ZRgKIAEoCVILY2xvc3VyZU5vdGUSNwoJcmFpc2VkX2F0GAsgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcmFpc2VkQXQSGwoJcmFpc2VkX2J5GAwgASgJUghyYWlz'
    'ZWRCeQ==');

@$core.Deprecated('Use planAuditRequestDescriptor instead')
const PlanAuditRequest$json = {
  '1': 'PlanAuditRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'scope', '3': 3, '4': 1, '5': 9, '10': 'scope'},
    {'1': 'standard_id', '3': 4, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'auditor_id', '3': 5, '4': 1, '5': 9, '10': 'auditorId'},
    {
      '1': 'auditee_department',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'auditeeDepartment'
    },
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
  ],
};

/// Descriptor for `PlanAuditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planAuditRequestDescriptor = $convert.base64Decode(
    'ChBQbGFuQXVkaXRSZXF1ZXN0EhwKCXJlZmVyZW5jZRgBIAEoCVIJcmVmZXJlbmNlEhQKBXRpdG'
    'xlGAIgASgJUgV0aXRsZRIUCgVzY29wZRgDIAEoCVIFc2NvcGUSHwoLc3RhbmRhcmRfaWQYBCAB'
    'KAlSCnN0YW5kYXJkSWQSHQoKYXVkaXRvcl9pZBgFIAEoCVIJYXVkaXRvcklkEi0KEmF1ZGl0ZW'
    'VfZGVwYXJ0bWVudBgGIAEoCVIRYXVkaXRlZURlcGFydG1lbnQSPQoMcGxhbm5lZF9mcm9tGAcg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcGxhbm5lZEZyb20SOQoKcGxhbm5lZF'
    '90bxgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXBsYW5uZWRUbw==');

@$core.Deprecated('Use planAuditResponseDescriptor instead')
const PlanAuditResponse$json = {
  '1': 'PlanAuditResponse',
  '2': [
    {
      '1': 'audit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Audit',
      '10': 'audit'
    },
  ],
};

/// Descriptor for `PlanAuditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planAuditResponseDescriptor = $convert.base64Decode(
    'ChFQbGFuQXVkaXRSZXNwb25zZRIyCgVhdWRpdBgBIAEoCzIcLmhlYWx0aGNhcmUucXVhbGl0eS'
    '52MS5BdWRpdFIFYXVkaXQ=');

@$core.Deprecated('Use recordFindingRequestDescriptor instead')
const RecordFindingRequest$json = {
  '1': 'RecordFindingRequest',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'clause_id', '3': 2, '4': 1, '5': 9, '10': 'clauseId'},
    {
      '1': 'severity',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.FindingSeverity',
      '10': 'severity'
    },
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'evidence', '3': 5, '4': 1, '5': 9, '10': 'evidence'},
  ],
};

/// Descriptor for `RecordFindingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordFindingRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRGaW5kaW5nUmVxdWVzdBIZCghhdWRpdF9pZBgBIAEoCVIHYXVkaXRJZBIbCgljbG'
    'F1c2VfaWQYAiABKAlSCGNsYXVzZUlkEkIKCHNldmVyaXR5GAMgASgOMiYuaGVhbHRoY2FyZS5x'
    'dWFsaXR5LnYxLkZpbmRpbmdTZXZlcml0eVIIc2V2ZXJpdHkSFgoGZGV0YWlsGAQgASgJUgZkZX'
    'RhaWwSGgoIZXZpZGVuY2UYBSABKAlSCGV2aWRlbmNl');

@$core.Deprecated('Use recordFindingResponseDescriptor instead')
const RecordFindingResponse$json = {
  '1': 'RecordFindingResponse',
  '2': [
    {
      '1': 'finding',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Finding',
      '10': 'finding'
    },
  ],
};

/// Descriptor for `RecordFindingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordFindingResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRGaW5kaW5nUmVzcG9uc2USOAoHZmluZGluZxgBIAEoCzIeLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5GaW5kaW5nUgdmaW5kaW5n');

@$core.Deprecated('Use linkFindingActionRequestDescriptor instead')
const LinkFindingActionRequest$json = {
  '1': 'LinkFindingActionRequest',
  '2': [
    {'1': 'finding_id', '3': 1, '4': 1, '5': 9, '10': 'findingId'},
    {'1': 'capa_id', '3': 2, '4': 1, '5': 9, '10': 'capaId'},
  ],
};

/// Descriptor for `LinkFindingActionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkFindingActionRequestDescriptor =
    $convert.base64Decode(
        'ChhMaW5rRmluZGluZ0FjdGlvblJlcXVlc3QSHQoKZmluZGluZ19pZBgBIAEoCVIJZmluZGluZ0'
        'lkEhcKB2NhcGFfaWQYAiABKAlSBmNhcGFJZA==');

@$core.Deprecated('Use linkFindingActionResponseDescriptor instead')
const LinkFindingActionResponse$json = {
  '1': 'LinkFindingActionResponse',
  '2': [
    {
      '1': 'finding',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Finding',
      '10': 'finding'
    },
  ],
};

/// Descriptor for `LinkFindingActionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkFindingActionResponseDescriptor =
    $convert.base64Decode(
        'ChlMaW5rRmluZGluZ0FjdGlvblJlc3BvbnNlEjgKB2ZpbmRpbmcYASABKAsyHi5oZWFsdGhjYX'
        'JlLnF1YWxpdHkudjEuRmluZGluZ1IHZmluZGluZw==');

@$core.Deprecated('Use closeFindingRequestDescriptor instead')
const CloseFindingRequest$json = {
  '1': 'CloseFindingRequest',
  '2': [
    {'1': 'finding_id', '3': 1, '4': 1, '5': 9, '10': 'findingId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CloseFindingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeFindingRequestDescriptor = $convert.base64Decode(
    'ChNDbG9zZUZpbmRpbmdSZXF1ZXN0Eh0KCmZpbmRpbmdfaWQYASABKAlSCWZpbmRpbmdJZBISCg'
    'Rub3RlGAIgASgJUgRub3Rl');

@$core.Deprecated('Use closeFindingResponseDescriptor instead')
const CloseFindingResponse$json = {
  '1': 'CloseFindingResponse',
  '2': [
    {
      '1': 'finding',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Finding',
      '10': 'finding'
    },
  ],
};

/// Descriptor for `CloseFindingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeFindingResponseDescriptor = $convert.base64Decode(
    'ChRDbG9zZUZpbmRpbmdSZXNwb25zZRI4CgdmaW5kaW5nGAEgASgLMh4uaGVhbHRoY2FyZS5xdW'
    'FsaXR5LnYxLkZpbmRpbmdSB2ZpbmRpbmc=');

@$core.Deprecated('Use reportAuditRequestDescriptor instead')
const ReportAuditRequest$json = {
  '1': 'ReportAuditRequest',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'summary', '3': 2, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ReportAuditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportAuditRequestDescriptor = $convert.base64Decode(
    'ChJSZXBvcnRBdWRpdFJlcXVlc3QSGQoIYXVkaXRfaWQYASABKAlSB2F1ZGl0SWQSGAoHc3VtbW'
    'FyeRgCIAEoCVIHc3VtbWFyeRIpChBleHBlY3RlZF92ZXJzaW9uGAMgASgDUg9leHBlY3RlZFZl'
    'cnNpb24=');

@$core.Deprecated('Use reportAuditResponseDescriptor instead')
const ReportAuditResponse$json = {
  '1': 'ReportAuditResponse',
  '2': [
    {
      '1': 'audit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Audit',
      '10': 'audit'
    },
  ],
};

/// Descriptor for `ReportAuditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportAuditResponseDescriptor = $convert.base64Decode(
    'ChNSZXBvcnRBdWRpdFJlc3BvbnNlEjIKBWF1ZGl0GAEgASgLMhwuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkF1ZGl0UgVhdWRpdA==');

@$core.Deprecated('Use closeAuditRequestDescriptor instead')
const CloseAuditRequest$json = {
  '1': 'CloseAuditRequest',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CloseAuditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAuditRequestDescriptor = $convert.base64Decode(
    'ChFDbG9zZUF1ZGl0UmVxdWVzdBIZCghhdWRpdF9pZBgBIAEoCVIHYXVkaXRJZBIpChBleHBlY3'
    'RlZF92ZXJzaW9uGAIgASgDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use closeAuditResponseDescriptor instead')
const CloseAuditResponse$json = {
  '1': 'CloseAuditResponse',
  '2': [
    {
      '1': 'audit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Audit',
      '10': 'audit'
    },
  ],
};

/// Descriptor for `CloseAuditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeAuditResponseDescriptor = $convert.base64Decode(
    'ChJDbG9zZUF1ZGl0UmVzcG9uc2USMgoFYXVkaXQYASABKAsyHC5oZWFsdGhjYXJlLnF1YWxpdH'
    'kudjEuQXVkaXRSBWF1ZGl0');

@$core.Deprecated('Use getAuditRequestDescriptor instead')
const GetAuditRequest$json = {
  '1': 'GetAuditRequest',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
  ],
};

/// Descriptor for `GetAuditRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuditRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRBdWRpdFJlcXVlc3QSGQoIYXVkaXRfaWQYASABKAlSB2F1ZGl0SWQ=');

@$core.Deprecated('Use getAuditResponseDescriptor instead')
const GetAuditResponse$json = {
  '1': 'GetAuditResponse',
  '2': [
    {
      '1': 'audit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Audit',
      '10': 'audit'
    },
  ],
};

/// Descriptor for `GetAuditResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAuditResponseDescriptor = $convert.base64Decode(
    'ChBHZXRBdWRpdFJlc3BvbnNlEjIKBWF1ZGl0GAEgASgLMhwuaGVhbHRoY2FyZS5xdWFsaXR5Ln'
    'YxLkF1ZGl0UgVhdWRpdA==');

@$core.Deprecated('Use listAuditsRequestDescriptor instead')
const ListAuditsRequest$json = {
  '1': 'ListAuditsRequest',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.AuditState',
      '10': 'state'
    },
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAuditsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0QXVkaXRzUmVxdWVzdBI3CgVzdGF0ZRgBIAEoDjIhLmhlYWx0aGNhcmUucXVhbGl0eS'
    '52MS5BdWRpdFN0YXRlUgVzdGF0ZRIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listAuditsResponseDescriptor instead')
const ListAuditsResponse$json = {
  '1': 'ListAuditsResponse',
  '2': [
    {
      '1': 'audits',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Audit',
      '10': 'audits'
    },
  ],
};

/// Descriptor for `ListAuditsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAuditsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0QXVkaXRzUmVzcG9uc2USNAoGYXVkaXRzGAEgAygLMhwuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkF1ZGl0UgZhdWRpdHM=');

@$core.Deprecated('Use listFindingsRequestDescriptor instead')
const ListFindingsRequest$json = {
  '1': 'ListFindingsRequest',
  '2': [
    {'1': 'audit_id', '3': 1, '4': 1, '5': 9, '10': 'auditId'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
  ],
};

/// Descriptor for `ListFindingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFindingsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RmluZGluZ3NSZXF1ZXN0EhkKCGF1ZGl0X2lkGAEgASgJUgdhdWRpdElkEhsKCW9wZW'
    '5fb25seRgCIAEoCFIIb3Blbk9ubHk=');

@$core.Deprecated('Use listFindingsResponseDescriptor instead')
const ListFindingsResponse$json = {
  '1': 'ListFindingsResponse',
  '2': [
    {
      '1': 'findings',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Finding',
      '10': 'findings'
    },
  ],
};

/// Descriptor for `ListFindingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFindingsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0RmluZGluZ3NSZXNwb25zZRI6CghmaW5kaW5ncxgBIAMoCzIeLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5GaW5kaW5nUghmaW5kaW5ncw==');

@$core.Deprecated('Use committeeDescriptor instead')
const Committee$json = {
  '1': 'Committee',
  '2': [
    {'1': 'committee_id', '3': 1, '4': 1, '5': 9, '10': 'committeeId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'terms', '3': 4, '4': 1, '5': 9, '10': 'terms'},
    {'1': 'quorum_size', '3': 5, '4': 1, '5': 5, '10': 'quorumSize'},
    {'1': 'restricted', '3': 6, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'members', '3': 7, '4': 3, '5': 9, '10': 'members'},
    {'1': 'active', '3': 8, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `Committee`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List committeeDescriptor = $convert.base64Decode(
    'CglDb21taXR0ZWUSIQoMY29tbWl0dGVlX2lkGAEgASgJUgtjb21taXR0ZWVJZBISCgRjb2RlGA'
    'IgASgJUgRjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSFAoFdGVybXMYBCABKAlSBXRlcm1zEh8K'
    'C3F1b3J1bV9zaXplGAUgASgFUgpxdW9ydW1TaXplEh4KCnJlc3RyaWN0ZWQYBiABKAhSCnJlc3'
    'RyaWN0ZWQSGAoHbWVtYmVycxgHIAMoCVIHbWVtYmVycxIWCgZhY3RpdmUYCCABKAhSBmFjdGl2'
    'ZQ==');

@$core.Deprecated('Use decisionDescriptor instead')
const Decision$json = {
  '1': 'Decision',
  '2': [
    {'1': 'text', '3': 1, '4': 1, '5': 9, '10': 'text'},
    {'1': 'action_ids', '3': 2, '4': 3, '5': 9, '10': 'actionIds'},
  ],
};

/// Descriptor for `Decision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decisionDescriptor = $convert.base64Decode(
    'CghEZWNpc2lvbhISCgR0ZXh0GAEgASgJUgR0ZXh0Eh0KCmFjdGlvbl9pZHMYAiADKAlSCWFjdG'
    'lvbklkcw==');

@$core.Deprecated('Use meetingDescriptor instead')
const Meeting$json = {
  '1': 'Meeting',
  '2': [
    {'1': 'meeting_id', '3': 1, '4': 1, '5': 9, '10': 'meetingId'},
    {'1': 'committee_id', '3': 2, '4': 1, '5': 9, '10': 'committeeId'},
    {
      '1': 'scheduled_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'held_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'heldAt'
    },
    {'1': 'agenda', '3': 5, '4': 3, '5': 9, '10': 'agenda'},
    {'1': 'attendees', '3': 6, '4': 3, '5': 9, '10': 'attendees'},
    {'1': 'apologies', '3': 7, '4': 3, '5': 9, '10': 'apologies'},
    {'1': 'minutes', '3': 8, '4': 1, '5': 9, '10': 'minutes'},
    {
      '1': 'decisions',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Decision',
      '10': 'decisions'
    },
    {
      '1': 'state',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.MeetingState',
      '10': 'state'
    },
    {'1': 'approved_by', '3': 11, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'restricted', '3': 13, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Meeting`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List meetingDescriptor = $convert.base64Decode(
    'CgdNZWV0aW5nEh0KCm1lZXRpbmdfaWQYASABKAlSCW1lZXRpbmdJZBIhCgxjb21taXR0ZWVfaW'
    'QYAiABKAlSC2NvbW1pdHRlZUlkEj0KDHNjaGVkdWxlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSC3NjaGVkdWxlZEF0EjMKB2hlbGRfYXQYBCABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgZoZWxkQXQSFgoGYWdlbmRhGAUgAygJUgZhZ2VuZGESHAoJYXR0'
    'ZW5kZWVzGAYgAygJUglhdHRlbmRlZXMSHAoJYXBvbG9naWVzGAcgAygJUglhcG9sb2dpZXMSGA'
    'oHbWludXRlcxgIIAEoCVIHbWludXRlcxI9CglkZWNpc2lvbnMYCSADKAsyHy5oZWFsdGhjYXJl'
    'LnF1YWxpdHkudjEuRGVjaXNpb25SCWRlY2lzaW9ucxI5CgVzdGF0ZRgKIAEoDjIjLmhlYWx0aG'
    'NhcmUucXVhbGl0eS52MS5NZWV0aW5nU3RhdGVSBXN0YXRlEh8KC2FwcHJvdmVkX2J5GAsgASgJ'
    'UgphcHByb3ZlZEJ5EjsKC2FwcHJvdmVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIKYXBwcm92ZWRBdBIeCgpyZXN0cmljdGVkGA0gASgIUgpyZXN0cmljdGVkEhgKB3Zl'
    'cnNpb24YDiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use formCommitteeRequestDescriptor instead')
const FormCommitteeRequest$json = {
  '1': 'FormCommitteeRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'terms', '3': 3, '4': 1, '5': 9, '10': 'terms'},
    {'1': 'quorum_size', '3': 4, '4': 1, '5': 5, '10': 'quorumSize'},
    {'1': 'restricted', '3': 5, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'members', '3': 6, '4': 3, '5': 9, '10': 'members'},
  ],
};

/// Descriptor for `FormCommitteeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formCommitteeRequestDescriptor = $convert.base64Decode(
    'ChRGb3JtQ29tbWl0dGVlUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAiABKA'
    'lSBG5hbWUSFAoFdGVybXMYAyABKAlSBXRlcm1zEh8KC3F1b3J1bV9zaXplGAQgASgFUgpxdW9y'
    'dW1TaXplEh4KCnJlc3RyaWN0ZWQYBSABKAhSCnJlc3RyaWN0ZWQSGAoHbWVtYmVycxgGIAMoCV'
    'IHbWVtYmVycw==');

@$core.Deprecated('Use formCommitteeResponseDescriptor instead')
const FormCommitteeResponse$json = {
  '1': 'FormCommitteeResponse',
  '2': [
    {
      '1': 'committee',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Committee',
      '10': 'committee'
    },
  ],
};

/// Descriptor for `FormCommitteeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formCommitteeResponseDescriptor = $convert.base64Decode(
    'ChVGb3JtQ29tbWl0dGVlUmVzcG9uc2USPgoJY29tbWl0dGVlGAEgASgLMiAuaGVhbHRoY2FyZS'
    '5xdWFsaXR5LnYxLkNvbW1pdHRlZVIJY29tbWl0dGVl');

@$core.Deprecated('Use scheduleMeetingRequestDescriptor instead')
const ScheduleMeetingRequest$json = {
  '1': 'ScheduleMeetingRequest',
  '2': [
    {'1': 'committee_id', '3': 1, '4': 1, '5': 9, '10': 'committeeId'},
    {
      '1': 'scheduled_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {'1': 'agenda', '3': 3, '4': 3, '5': 9, '10': 'agenda'},
  ],
};

/// Descriptor for `ScheduleMeetingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleMeetingRequestDescriptor = $convert.base64Decode(
    'ChZTY2hlZHVsZU1lZXRpbmdSZXF1ZXN0EiEKDGNvbW1pdHRlZV9pZBgBIAEoCVILY29tbWl0dG'
    'VlSWQSPQoMc2NoZWR1bGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIL'
    'c2NoZWR1bGVkQXQSFgoGYWdlbmRhGAMgAygJUgZhZ2VuZGE=');

@$core.Deprecated('Use scheduleMeetingResponseDescriptor instead')
const ScheduleMeetingResponse$json = {
  '1': 'ScheduleMeetingResponse',
  '2': [
    {
      '1': 'meeting',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Meeting',
      '10': 'meeting'
    },
  ],
};

/// Descriptor for `ScheduleMeetingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleMeetingResponseDescriptor =
    $convert.base64Decode(
        'ChdTY2hlZHVsZU1lZXRpbmdSZXNwb25zZRI4CgdtZWV0aW5nGAEgASgLMh4uaGVhbHRoY2FyZS'
        '5xdWFsaXR5LnYxLk1lZXRpbmdSB21lZXRpbmc=');

@$core.Deprecated('Use recordMinutesRequestDescriptor instead')
const RecordMinutesRequest$json = {
  '1': 'RecordMinutesRequest',
  '2': [
    {'1': 'meeting_id', '3': 1, '4': 1, '5': 9, '10': 'meetingId'},
    {
      '1': 'held_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'heldAt'
    },
    {'1': 'attendees', '3': 3, '4': 3, '5': 9, '10': 'attendees'},
    {'1': 'apologies', '3': 4, '4': 3, '5': 9, '10': 'apologies'},
    {'1': 'minutes', '3': 5, '4': 1, '5': 9, '10': 'minutes'},
    {
      '1': 'decisions',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Decision',
      '10': 'decisions'
    },
    {'1': 'approve', '3': 7, '4': 1, '5': 8, '10': 'approve'},
    {'1': 'expected_version', '3': 8, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RecordMinutesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMinutesRequestDescriptor = $convert.base64Decode(
    'ChRSZWNvcmRNaW51dGVzUmVxdWVzdBIdCgptZWV0aW5nX2lkGAEgASgJUgltZWV0aW5nSWQSMw'
    'oHaGVsZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmhlbGRBdBIcCglh'
    'dHRlbmRlZXMYAyADKAlSCWF0dGVuZGVlcxIcCglhcG9sb2dpZXMYBCADKAlSCWFwb2xvZ2llcx'
    'IYCgdtaW51dGVzGAUgASgJUgdtaW51dGVzEj0KCWRlY2lzaW9ucxgGIAMoCzIfLmhlYWx0aGNh'
    'cmUucXVhbGl0eS52MS5EZWNpc2lvblIJZGVjaXNpb25zEhgKB2FwcHJvdmUYByABKAhSB2FwcH'
    'JvdmUSKQoQZXhwZWN0ZWRfdmVyc2lvbhgIIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use recordMinutesResponseDescriptor instead')
const RecordMinutesResponse$json = {
  '1': 'RecordMinutesResponse',
  '2': [
    {
      '1': 'meeting',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Meeting',
      '10': 'meeting'
    },
  ],
};

/// Descriptor for `RecordMinutesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordMinutesResponseDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRNaW51dGVzUmVzcG9uc2USOAoHbWVldGluZxgBIAEoCzIeLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5NZWV0aW5nUgdtZWV0aW5n');

@$core.Deprecated('Use getMeetingRequestDescriptor instead')
const GetMeetingRequest$json = {
  '1': 'GetMeetingRequest',
  '2': [
    {'1': 'meeting_id', '3': 1, '4': 1, '5': 9, '10': 'meetingId'},
  ],
};

/// Descriptor for `GetMeetingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeetingRequestDescriptor = $convert.base64Decode(
    'ChFHZXRNZWV0aW5nUmVxdWVzdBIdCgptZWV0aW5nX2lkGAEgASgJUgltZWV0aW5nSWQ=');

@$core.Deprecated('Use getMeetingResponseDescriptor instead')
const GetMeetingResponse$json = {
  '1': 'GetMeetingResponse',
  '2': [
    {
      '1': 'meeting',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Meeting',
      '10': 'meeting'
    },
  ],
};

/// Descriptor for `GetMeetingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMeetingResponseDescriptor = $convert.base64Decode(
    'ChJHZXRNZWV0aW5nUmVzcG9uc2USOAoHbWVldGluZxgBIAEoCzIeLmhlYWx0aGNhcmUucXVhbG'
    'l0eS52MS5NZWV0aW5nUgdtZWV0aW5n');

@$core.Deprecated('Use listCommitteesRequestDescriptor instead')
const ListCommitteesRequest$json = {
  '1': 'ListCommitteesRequest',
  '2': [
    {'1': 'active_only', '3': 1, '4': 1, '5': 8, '10': 'activeOnly'},
  ],
};

/// Descriptor for `ListCommitteesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommitteesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q29tbWl0dGVlc1JlcXVlc3QSHwoLYWN0aXZlX29ubHkYASABKAhSCmFjdGl2ZU9ubH'
    'k=');

@$core.Deprecated('Use listCommitteesResponseDescriptor instead')
const ListCommitteesResponse$json = {
  '1': 'ListCommitteesResponse',
  '2': [
    {
      '1': 'committees',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Committee',
      '10': 'committees'
    },
  ],
};

/// Descriptor for `ListCommitteesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCommitteesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Q29tbWl0dGVlc1Jlc3BvbnNlEkAKCmNvbW1pdHRlZXMYASADKAsyIC5oZWFsdGhjYX'
        'JlLnF1YWxpdHkudjEuQ29tbWl0dGVlUgpjb21taXR0ZWVz');

@$core.Deprecated('Use standardDescriptor instead')
const Standard$json = {
  '1': 'Standard',
  '2': [
    {'1': 'standard_id', '3': 1, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'edition', '3': 4, '4': 1, '5': 9, '10': 'edition'},
    {'1': 'active', '3': 5, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `Standard`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List standardDescriptor = $convert.base64Decode(
    'CghTdGFuZGFyZBIfCgtzdGFuZGFyZF9pZBgBIAEoCVIKc3RhbmRhcmRJZBISCgRjb2RlGAIgAS'
    'gJUgRjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSGAoHZWRpdGlvbhgEIAEoCVIHZWRpdGlvbhIW'
    'CgZhY3RpdmUYBSABKAhSBmFjdGl2ZQ==');

@$core.Deprecated('Use clauseDescriptor instead')
const Clause$json = {
  '1': 'Clause',
  '2': [
    {'1': 'clause_id', '3': 1, '4': 1, '5': 9, '10': 'clauseId'},
    {'1': 'standard_id', '3': 2, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'reference', '3': 3, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'chapter', '3': 4, '4': 1, '5': 9, '10': 'chapter'},
    {'1': 'text', '3': 5, '4': 1, '5': 9, '10': 'text'},
    {'1': 'critical', '3': 6, '4': 1, '5': 8, '10': 'critical'},
  ],
};

/// Descriptor for `Clause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clauseDescriptor = $convert.base64Decode(
    'CgZDbGF1c2USGwoJY2xhdXNlX2lkGAEgASgJUghjbGF1c2VJZBIfCgtzdGFuZGFyZF9pZBgCIA'
    'EoCVIKc3RhbmRhcmRJZBIcCglyZWZlcmVuY2UYAyABKAlSCXJlZmVyZW5jZRIYCgdjaGFwdGVy'
    'GAQgASgJUgdjaGFwdGVyEhIKBHRleHQYBSABKAlSBHRleHQSGgoIY3JpdGljYWwYBiABKAhSCG'
    'NyaXRpY2Fs');

@$core.Deprecated('Use clauseInputDescriptor instead')
const ClauseInput$json = {
  '1': 'ClauseInput',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'chapter', '3': 2, '4': 1, '5': 9, '10': 'chapter'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '10': 'text'},
    {'1': 'critical', '3': 4, '4': 1, '5': 8, '10': 'critical'},
  ],
};

/// Descriptor for `ClauseInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clauseInputDescriptor = $convert.base64Decode(
    'CgtDbGF1c2VJbnB1dBIcCglyZWZlcmVuY2UYASABKAlSCXJlZmVyZW5jZRIYCgdjaGFwdGVyGA'
    'IgASgJUgdjaGFwdGVyEhIKBHRleHQYAyABKAlSBHRleHQSGgoIY3JpdGljYWwYBCABKAhSCGNy'
    'aXRpY2Fs');

@$core.Deprecated('Use loadStandardRequestDescriptor instead')
const LoadStandardRequest$json = {
  '1': 'LoadStandardRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'edition', '3': 3, '4': 1, '5': 9, '10': 'edition'},
    {
      '1': 'clauses',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ClauseInput',
      '10': 'clauses'
    },
  ],
};

/// Descriptor for `LoadStandardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadStandardRequestDescriptor = $convert.base64Decode(
    'ChNMb2FkU3RhbmRhcmRSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZRgCIAEoCV'
    'IEbmFtZRIYCgdlZGl0aW9uGAMgASgJUgdlZGl0aW9uEjwKB2NsYXVzZXMYBCADKAsyIi5oZWFs'
    'dGhjYXJlLnF1YWxpdHkudjEuQ2xhdXNlSW5wdXRSB2NsYXVzZXM=');

@$core.Deprecated('Use loadStandardResponseDescriptor instead')
const LoadStandardResponse$json = {
  '1': 'LoadStandardResponse',
  '2': [
    {
      '1': 'standard',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Standard',
      '10': 'standard'
    },
    {'1': 'clauses_loaded', '3': 2, '4': 1, '5': 5, '10': 'clausesLoaded'},
  ],
};

/// Descriptor for `LoadStandardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loadStandardResponseDescriptor = $convert.base64Decode(
    'ChRMb2FkU3RhbmRhcmRSZXNwb25zZRI7CghzdGFuZGFyZBgBIAEoCzIfLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5TdGFuZGFyZFIIc3RhbmRhcmQSJQoOY2xhdXNlc19sb2FkZWQYAiABKAVSDWNs'
    'YXVzZXNMb2FkZWQ=');

@$core.Deprecated('Use evidenceDescriptor instead')
const Evidence$json = {
  '1': 'Evidence',
  '2': [
    {'1': 'evidence_id', '3': 1, '4': 1, '5': 9, '10': 'evidenceId'},
    {'1': 'clause_id', '3': 2, '4': 1, '5': 9, '10': 'clauseId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.EvidenceKind',
      '10': 'kind'
    },
    {'1': 'ref_id', '3': 4, '4': 1, '5': 9, '10': 'refId'},
    {'1': 'external_ref', '3': 5, '4': 1, '5': 9, '10': 'externalRef'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'added_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'addedAt'
    },
    {'1': 'added_by', '3': 8, '4': 1, '5': 9, '10': 'addedBy'},
    {
      '1': 'removed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'removedAt'
    },
    {'1': 'removed_by', '3': 10, '4': 1, '5': 9, '10': 'removedBy'},
    {'1': 'removed_why', '3': 11, '4': 1, '5': 9, '10': 'removedWhy'},
  ],
};

/// Descriptor for `Evidence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evidenceDescriptor = $convert.base64Decode(
    'CghFdmlkZW5jZRIfCgtldmlkZW5jZV9pZBgBIAEoCVIKZXZpZGVuY2VJZBIbCgljbGF1c2VfaW'
    'QYAiABKAlSCGNsYXVzZUlkEjcKBGtpbmQYAyABKA4yIy5oZWFsdGhjYXJlLnF1YWxpdHkudjEu'
    'RXZpZGVuY2VLaW5kUgRraW5kEhUKBnJlZl9pZBgEIAEoCVIFcmVmSWQSIQoMZXh0ZXJuYWxfcm'
    'VmGAUgASgJUgtleHRlcm5hbFJlZhIgCgtkZXNjcmlwdGlvbhgGIAEoCVILZGVzY3JpcHRpb24S'
    'NQoIYWRkZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdhZGRlZEF0Eh'
    'kKCGFkZGVkX2J5GAggASgJUgdhZGRlZEJ5EjkKCnJlbW92ZWRfYXQYCSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUglyZW1vdmVkQXQSHQoKcmVtb3ZlZF9ieRgKIAEoCVIJcmVtb3'
    'ZlZEJ5Eh8KC3JlbW92ZWRfd2h5GAsgASgJUgpyZW1vdmVkV2h5');

@$core.Deprecated('Use fileEvidenceRequestDescriptor instead')
const FileEvidenceRequest$json = {
  '1': 'FileEvidenceRequest',
  '2': [
    {'1': 'clause_id', '3': 1, '4': 1, '5': 9, '10': 'clauseId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.EvidenceKind',
      '10': 'kind'
    },
    {'1': 'ref_id', '3': 3, '4': 1, '5': 9, '10': 'refId'},
    {'1': 'external_ref', '3': 4, '4': 1, '5': 9, '10': 'externalRef'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `FileEvidenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileEvidenceRequestDescriptor = $convert.base64Decode(
    'ChNGaWxlRXZpZGVuY2VSZXF1ZXN0EhsKCWNsYXVzZV9pZBgBIAEoCVIIY2xhdXNlSWQSNwoEa2'
    'luZBgCIAEoDjIjLmhlYWx0aGNhcmUucXVhbGl0eS52MS5FdmlkZW5jZUtpbmRSBGtpbmQSFQoG'
    'cmVmX2lkGAMgASgJUgVyZWZJZBIhCgxleHRlcm5hbF9yZWYYBCABKAlSC2V4dGVybmFsUmVmEi'
    'AKC2Rlc2NyaXB0aW9uGAUgASgJUgtkZXNjcmlwdGlvbg==');

@$core.Deprecated('Use fileEvidenceResponseDescriptor instead')
const FileEvidenceResponse$json = {
  '1': 'FileEvidenceResponse',
  '2': [
    {
      '1': 'evidence',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Evidence',
      '10': 'evidence'
    },
  ],
};

/// Descriptor for `FileEvidenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileEvidenceResponseDescriptor = $convert.base64Decode(
    'ChRGaWxlRXZpZGVuY2VSZXNwb25zZRI7CghldmlkZW5jZRgBIAEoCzIfLmhlYWx0aGNhcmUucX'
    'VhbGl0eS52MS5FdmlkZW5jZVIIZXZpZGVuY2U=');

@$core.Deprecated('Use withdrawEvidenceRequestDescriptor instead')
const WithdrawEvidenceRequest$json = {
  '1': 'WithdrawEvidenceRequest',
  '2': [
    {'1': 'evidence_id', '3': 1, '4': 1, '5': 9, '10': 'evidenceId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WithdrawEvidenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawEvidenceRequestDescriptor =
    $convert.base64Decode(
        'ChdXaXRoZHJhd0V2aWRlbmNlUmVxdWVzdBIfCgtldmlkZW5jZV9pZBgBIAEoCVIKZXZpZGVuY2'
        'VJZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use withdrawEvidenceResponseDescriptor instead')
const WithdrawEvidenceResponse$json = {
  '1': 'WithdrawEvidenceResponse',
};

/// Descriptor for `WithdrawEvidenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawEvidenceResponseDescriptor =
    $convert.base64Decode('ChhXaXRoZHJhd0V2aWRlbmNlUmVzcG9uc2U=');

@$core.Deprecated('Use reviewClauseRequestDescriptor instead')
const ReviewClauseRequest$json = {
  '1': 'ReviewClauseRequest',
  '2': [
    {'1': 'standard_id', '3': 1, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'clause_id', '3': 2, '4': 1, '5': 9, '10': 'clauseId'},
    {
      '1': 'verdict',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Verdict',
      '10': 'verdict'
    },
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {'1': 'capa_id', '3': 5, '4': 1, '5': 9, '10': 'capaId'},
  ],
};

/// Descriptor for `ReviewClauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewClauseRequestDescriptor = $convert.base64Decode(
    'ChNSZXZpZXdDbGF1c2VSZXF1ZXN0Eh8KC3N0YW5kYXJkX2lkGAEgASgJUgpzdGFuZGFyZElkEh'
    'sKCWNsYXVzZV9pZBgCIAEoCVIIY2xhdXNlSWQSOAoHdmVyZGljdBgDIAEoDjIeLmhlYWx0aGNh'
    'cmUucXVhbGl0eS52MS5WZXJkaWN0Ugd2ZXJkaWN0EhIKBG5vdGUYBCABKAlSBG5vdGUSFwoHY2'
    'FwYV9pZBgFIAEoCVIGY2FwYUlk');

@$core.Deprecated('Use reviewClauseResponseDescriptor instead')
const ReviewClauseResponse$json = {
  '1': 'ReviewClauseResponse',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {
      '1': 'verdict',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Verdict',
      '10': 'verdict'
    },
    {
      '1': 'reviewed_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
  ],
};

/// Descriptor for `ReviewClauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewClauseResponseDescriptor = $convert.base64Decode(
    'ChRSZXZpZXdDbGF1c2VSZXNwb25zZRIbCglyZXZpZXdfaWQYASABKAlSCHJldmlld0lkEjgKB3'
    'ZlcmRpY3QYAiABKA4yHi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuVmVyZGljdFIHdmVyZGljdBI7'
    'CgtyZXZpZXdlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJldmlld2'
    'VkQXQ=');

@$core.Deprecated('Use clauseStatusDescriptor instead')
const ClauseStatus$json = {
  '1': 'ClauseStatus',
  '2': [
    {'1': 'clause_id', '3': 1, '4': 1, '5': 9, '10': 'clauseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'chapter', '3': 3, '4': 1, '5': 9, '10': 'chapter'},
    {'1': 'critical', '3': 4, '4': 1, '5': 8, '10': 'critical'},
    {
      '1': 'verdict',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Verdict',
      '10': 'verdict'
    },
    {'1': 'evidence_count', '3': 6, '4': 1, '5': 5, '10': 'evidenceCount'},
    {
      '1': 'reviewed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'reviewed_by', '3': 8, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'stale', '3': 9, '4': 1, '5': 8, '10': 'stale'},
    {'1': 'capa_id', '3': 10, '4': 1, '5': 9, '10': 'capaId'},
  ],
};

/// Descriptor for `ClauseStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clauseStatusDescriptor = $convert.base64Decode(
    'CgxDbGF1c2VTdGF0dXMSGwoJY2xhdXNlX2lkGAEgASgJUghjbGF1c2VJZBIcCglyZWZlcmVuY2'
    'UYAiABKAlSCXJlZmVyZW5jZRIYCgdjaGFwdGVyGAMgASgJUgdjaGFwdGVyEhoKCGNyaXRpY2Fs'
    'GAQgASgIUghjcml0aWNhbBI4Cgd2ZXJkaWN0GAUgASgOMh4uaGVhbHRoY2FyZS5xdWFsaXR5Ln'
    'YxLlZlcmRpY3RSB3ZlcmRpY3QSJQoOZXZpZGVuY2VfY291bnQYBiABKAVSDWV2aWRlbmNlQ291'
    'bnQSOwoLcmV2aWV3ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZX'
    'ZpZXdlZEF0Eh8KC3Jldmlld2VkX2J5GAggASgJUgpyZXZpZXdlZEJ5EhQKBXN0YWxlGAkgASgI'
    'UgVzdGFsZRIXCgdjYXBhX2lkGAogASgJUgZjYXBhSWQ=');

@$core.Deprecated('Use getReadinessRequestDescriptor instead')
const GetReadinessRequest$json = {
  '1': 'GetReadinessRequest',
  '2': [
    {'1': 'standard_id', '3': 1, '4': 1, '5': 9, '10': 'standardId'},
  ],
};

/// Descriptor for `GetReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessRequestDescriptor = $convert.base64Decode(
    'ChNHZXRSZWFkaW5lc3NSZXF1ZXN0Eh8KC3N0YW5kYXJkX2lkGAEgASgJUgpzdGFuZGFyZElk');

@$core.Deprecated('Use getReadinessResponseDescriptor instead')
const GetReadinessResponse$json = {
  '1': 'GetReadinessResponse',
  '2': [
    {'1': 'standard_id', '3': 1, '4': 1, '5': 9, '10': 'standardId'},
    {'1': 'total', '3': 2, '4': 1, '5': 5, '10': 'total'},
    {'1': 'met', '3': 3, '4': 1, '5': 5, '10': 'met'},
    {'1': 'partially_met', '3': 4, '4': 1, '5': 5, '10': 'partiallyMet'},
    {'1': 'not_met', '3': 5, '4': 1, '5': 5, '10': 'notMet'},
    {'1': 'not_applicable', '3': 6, '4': 1, '5': 5, '10': 'notApplicable'},
    {'1': 'unreviewed', '3': 7, '4': 1, '5': 5, '10': 'unreviewed'},
    {'1': 'critical_gaps', '3': 8, '4': 1, '5': 5, '10': 'criticalGaps'},
    {'1': 'stale_reviews', '3': 9, '4': 1, '5': 5, '10': 'staleReviews'},
    {'1': 'evidence_gaps', '3': 10, '4': 1, '5': 5, '10': 'evidenceGaps'},
    {'1': 'overdue_actions', '3': 11, '4': 1, '5': 5, '10': 'overdueActions'},
    {
      '1': 'clauses',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ClauseStatus',
      '10': 'clauses'
    },
  ],
};

/// Descriptor for `GetReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReadinessResponseDescriptor = $convert.base64Decode(
    'ChRHZXRSZWFkaW5lc3NSZXNwb25zZRIfCgtzdGFuZGFyZF9pZBgBIAEoCVIKc3RhbmRhcmRJZB'
    'IUCgV0b3RhbBgCIAEoBVIFdG90YWwSEAoDbWV0GAMgASgFUgNtZXQSIwoNcGFydGlhbGx5X21l'
    'dBgEIAEoBVIMcGFydGlhbGx5TWV0EhcKB25vdF9tZXQYBSABKAVSBm5vdE1ldBIlCg5ub3RfYX'
    'BwbGljYWJsZRgGIAEoBVINbm90QXBwbGljYWJsZRIeCgp1bnJldmlld2VkGAcgASgFUgp1bnJl'
    'dmlld2VkEiMKDWNyaXRpY2FsX2dhcHMYCCABKAVSDGNyaXRpY2FsR2FwcxIjCg1zdGFsZV9yZX'
    'ZpZXdzGAkgASgFUgxzdGFsZVJldmlld3MSIwoNZXZpZGVuY2VfZ2FwcxgKIAEoBVIMZXZpZGVu'
    'Y2VHYXBzEicKD292ZXJkdWVfYWN0aW9ucxgLIAEoBVIOb3ZlcmR1ZUFjdGlvbnMSPQoHY2xhdX'
    'NlcxgMIAMoCzIjLmhlYWx0aGNhcmUucXVhbGl0eS52MS5DbGF1c2VTdGF0dXNSB2NsYXVzZXM=');

@$core.Deprecated('Use listStandardsRequestDescriptor instead')
const ListStandardsRequest$json = {
  '1': 'ListStandardsRequest',
  '2': [
    {'1': 'active_only', '3': 1, '4': 1, '5': 8, '10': 'activeOnly'},
  ],
};

/// Descriptor for `ListStandardsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStandardsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0U3RhbmRhcmRzUmVxdWVzdBIfCgthY3RpdmVfb25seRgBIAEoCFIKYWN0aXZlT25seQ'
    '==');

@$core.Deprecated('Use listStandardsResponseDescriptor instead')
const ListStandardsResponse$json = {
  '1': 'ListStandardsResponse',
  '2': [
    {
      '1': 'standards',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Standard',
      '10': 'standards'
    },
  ],
};

/// Descriptor for `ListStandardsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStandardsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0U3RhbmRhcmRzUmVzcG9uc2USPQoJc3RhbmRhcmRzGAEgAygLMh8uaGVhbHRoY2FyZS'
    '5xdWFsaXR5LnYxLlN0YW5kYXJkUglzdGFuZGFyZHM=');

@$core.Deprecated('Use listClausesRequestDescriptor instead')
const ListClausesRequest$json = {
  '1': 'ListClausesRequest',
  '2': [
    {'1': 'standard_id', '3': 1, '4': 1, '5': 9, '10': 'standardId'},
  ],
};

/// Descriptor for `ListClausesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listClausesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0Q2xhdXNlc1JlcXVlc3QSHwoLc3RhbmRhcmRfaWQYASABKAlSCnN0YW5kYXJkSWQ=');

@$core.Deprecated('Use listClausesResponseDescriptor instead')
const ListClausesResponse$json = {
  '1': 'ListClausesResponse',
  '2': [
    {
      '1': 'clauses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Clause',
      '10': 'clauses'
    },
  ],
};

/// Descriptor for `ListClausesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listClausesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2xhdXNlc1Jlc3BvbnNlEjcKB2NsYXVzZXMYASADKAsyHS5oZWFsdGhjYXJlLnF1YW'
    'xpdHkudjEuQ2xhdXNlUgdjbGF1c2Vz');

@$core.Deprecated('Use indicatorDefinitionDescriptor instead')
const IndicatorDefinition$json = {
  '1': 'IndicatorDefinition',
  '2': [
    {'1': 'definition_id', '3': 1, '4': 1, '5': 9, '10': 'definitionId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'numerator', '3': 5, '4': 1, '5': 9, '10': 'numerator'},
    {'1': 'denominator', '3': 6, '4': 1, '5': 9, '10': 'denominator'},
    {'1': 'unit', '3': 7, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'target_permille', '3': 8, '4': 1, '5': 5, '10': 'targetPermille'},
    {
      '1': 'direction',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Direction',
      '10': 'direction'
    },
    {
      '1': 'frequency',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Frequency',
      '10': 'frequency'
    },
    {'1': 'owner_id', '3': 11, '4': 1, '5': 9, '10': 'ownerId'},
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
  ],
};

/// Descriptor for `IndicatorDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indicatorDefinitionDescriptor = $convert.base64Decode(
    'ChNJbmRpY2F0b3JEZWZpbml0aW9uEiMKDWRlZmluaXRpb25faWQYASABKAlSDGRlZmluaXRpb2'
    '5JZBISCgRjb2RlGAIgASgJUgRjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSGgoIcmV2aXNpb24Y'
    'BCABKAVSCHJldmlzaW9uEhwKCW51bWVyYXRvchgFIAEoCVIJbnVtZXJhdG9yEiAKC2Rlbm9taW'
    '5hdG9yGAYgASgJUgtkZW5vbWluYXRvchISCgR1bml0GAcgASgJUgR1bml0EicKD3RhcmdldF9w'
    'ZXJtaWxsZRgIIAEoBVIOdGFyZ2V0UGVybWlsbGUSPgoJZGlyZWN0aW9uGAkgASgOMiAuaGVhbH'
    'RoY2FyZS5xdWFsaXR5LnYxLkRpcmVjdGlvblIJZGlyZWN0aW9uEj4KCWZyZXF1ZW5jeRgKIAEo'
    'DjIgLmhlYWx0aGNhcmUucXVhbGl0eS52MS5GcmVxdWVuY3lSCWZyZXF1ZW5jeRIZCghvd25lcl'
    '9pZBgLIAEoCVIHb3duZXJJZBJBCg5lZmZlY3RpdmVfZnJvbRgMIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SPwoNc3VwZXJzZWRlZF9hdBgNIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHN1cGVyc2VkZWRBdA==');

@$core.Deprecated('Use indicatorValueDescriptor instead')
const IndicatorValue$json = {
  '1': 'IndicatorValue',
  '2': [
    {'1': 'value_id', '3': 1, '4': 1, '5': 9, '10': 'valueId'},
    {'1': 'definition_id', '3': 2, '4': 1, '5': 9, '10': 'definitionId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'period_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodFrom'
    },
    {
      '1': 'period_to',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'periodTo'
    },
    {'1': 'numerator', '3': 7, '4': 1, '5': 3, '10': 'numerator'},
    {'1': 'denominator', '3': 8, '4': 1, '5': 3, '10': 'denominator'},
    {'1': 'permille', '3': 9, '4': 1, '5': 5, '10': 'permille'},
    {'1': 'unanswerable', '3': 10, '4': 1, '5': 8, '10': 'unanswerable'},
    {'1': 'source_note', '3': 11, '4': 1, '5': 9, '10': 'sourceNote'},
    {
      '1': 'recorded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 13, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `IndicatorValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indicatorValueDescriptor = $convert.base64Decode(
    'Cg5JbmRpY2F0b3JWYWx1ZRIZCgh2YWx1ZV9pZBgBIAEoCVIHdmFsdWVJZBIjCg1kZWZpbml0aW'
    '9uX2lkGAIgASgJUgxkZWZpbml0aW9uSWQSEgoEY29kZRgDIAEoCVIEY29kZRIaCghyZXZpc2lv'
    'bhgEIAEoBVIIcmV2aXNpb24SOwoLcGVyaW9kX2Zyb20YBSABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgpwZXJpb2RGcm9tEjcKCXBlcmlvZF90bxgGIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCHBlcmlvZFRvEhwKCW51bWVyYXRvchgHIAEoA1IJbnVtZXJhdG9yEi'
    'AKC2Rlbm9taW5hdG9yGAggASgDUgtkZW5vbWluYXRvchIaCghwZXJtaWxsZRgJIAEoBVIIcGVy'
    'bWlsbGUSIgoMdW5hbnN3ZXJhYmxlGAogASgIUgx1bmFuc3dlcmFibGUSHwoLc291cmNlX25vdG'
    'UYCyABKAlSCnNvdXJjZU5vdGUSOwoLcmVjb3JkZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh8KC3JlY29yZGVkX2J5GA0gASgJUgpyZWNvcmRlZE'
    'J5');

@$core.Deprecated('Use defineIndicatorRequestDescriptor instead')
const DefineIndicatorRequest$json = {
  '1': 'DefineIndicatorRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'numerator', '3': 3, '4': 1, '5': 9, '10': 'numerator'},
    {'1': 'denominator', '3': 4, '4': 1, '5': 9, '10': 'denominator'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'target_permille', '3': 6, '4': 1, '5': 5, '10': 'targetPermille'},
    {
      '1': 'direction',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Direction',
      '10': 'direction'
    },
    {
      '1': 'frequency',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.Frequency',
      '10': 'frequency'
    },
    {'1': 'owner_id', '3': 9, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'effective_from',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `DefineIndicatorRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineIndicatorRequestDescriptor = $convert.base64Decode(
    'ChZEZWZpbmVJbmRpY2F0b3JSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZRIcCgludW1lcmF0b3IYAyABKAlSCW51bWVyYXRvchIgCgtkZW5vbWluYXRvchgE'
    'IAEoCVILZGVub21pbmF0b3ISEgoEdW5pdBgFIAEoCVIEdW5pdBInCg90YXJnZXRfcGVybWlsbG'
    'UYBiABKAVSDnRhcmdldFBlcm1pbGxlEj4KCWRpcmVjdGlvbhgHIAEoDjIgLmhlYWx0aGNhcmUu'
    'cXVhbGl0eS52MS5EaXJlY3Rpb25SCWRpcmVjdGlvbhI+CglmcmVxdWVuY3kYCCABKA4yIC5oZW'
    'FsdGhjYXJlLnF1YWxpdHkudjEuRnJlcXVlbmN5UglmcmVxdWVuY3kSGQoIb3duZXJfaWQYCSAB'
    'KAlSB293bmVySWQSQQoOZWZmZWN0aXZlX2Zyb20YCiABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUg1lZmZlY3RpdmVGcm9t');

@$core.Deprecated('Use defineIndicatorResponseDescriptor instead')
const DefineIndicatorResponse$json = {
  '1': 'DefineIndicatorResponse',
  '2': [
    {
      '1': 'definition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorDefinition',
      '10': 'definition'
    },
  ],
};

/// Descriptor for `DefineIndicatorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineIndicatorResponseDescriptor =
    $convert.base64Decode(
        'ChdEZWZpbmVJbmRpY2F0b3JSZXNwb25zZRJKCgpkZWZpbml0aW9uGAEgASgLMiouaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkluZGljYXRvckRlZmluaXRpb25SCmRlZmluaXRpb24=');

@$core.Deprecated('Use recordIndicatorValueRequestDescriptor instead')
const RecordIndicatorValueRequest$json = {
  '1': 'RecordIndicatorValueRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
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
    {'1': 'numerator', '3': 4, '4': 1, '5': 3, '10': 'numerator'},
    {'1': 'denominator', '3': 5, '4': 1, '5': 3, '10': 'denominator'},
    {'1': 'source_note', '3': 6, '4': 1, '5': 9, '10': 'sourceNote'},
  ],
};

/// Descriptor for `RecordIndicatorValueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordIndicatorValueRequestDescriptor = $convert.base64Decode(
    'ChtSZWNvcmRJbmRpY2F0b3JWYWx1ZVJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRI7CgtwZX'
    'Jpb2RfZnJvbRgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnBlcmlvZEZyb20S'
    'NwoJcGVyaW9kX3RvGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcGVyaW9kVG'
    '8SHAoJbnVtZXJhdG9yGAQgASgDUgludW1lcmF0b3ISIAoLZGVub21pbmF0b3IYBSABKANSC2Rl'
    'bm9taW5hdG9yEh8KC3NvdXJjZV9ub3RlGAYgASgJUgpzb3VyY2VOb3Rl');

@$core.Deprecated('Use recordIndicatorValueResponseDescriptor instead')
const RecordIndicatorValueResponse$json = {
  '1': 'RecordIndicatorValueResponse',
  '2': [
    {
      '1': 'value',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorValue',
      '10': 'value'
    },
  ],
};

/// Descriptor for `RecordIndicatorValueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordIndicatorValueResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWNvcmRJbmRpY2F0b3JWYWx1ZVJlc3BvbnNlEjsKBXZhbHVlGAEgASgLMiUuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkluZGljYXRvclZhbHVlUgV2YWx1ZQ==');

@$core.Deprecated('Use indicatorLineDescriptor instead')
const IndicatorLine$json = {
  '1': 'IndicatorLine',
  '2': [
    {
      '1': 'definition',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorDefinition',
      '10': 'definition'
    },
    {
      '1': 'latest',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorValue',
      '10': 'latest'
    },
    {'1': 'recorded', '3': 3, '4': 1, '5': 8, '10': 'recorded'},
    {'1': 'met_target', '3': 4, '4': 1, '5': 8, '10': 'metTarget'},
    {'1': 'comparable', '3': 5, '4': 1, '5': 8, '10': 'comparable'},
  ],
};

/// Descriptor for `IndicatorLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List indicatorLineDescriptor = $convert.base64Decode(
    'Cg1JbmRpY2F0b3JMaW5lEkoKCmRlZmluaXRpb24YASABKAsyKi5oZWFsdGhjYXJlLnF1YWxpdH'
    'kudjEuSW5kaWNhdG9yRGVmaW5pdGlvblIKZGVmaW5pdGlvbhI9CgZsYXRlc3QYAiABKAsyJS5o'
    'ZWFsdGhjYXJlLnF1YWxpdHkudjEuSW5kaWNhdG9yVmFsdWVSBmxhdGVzdBIaCghyZWNvcmRlZB'
    'gDIAEoCFIIcmVjb3JkZWQSHQoKbWV0X3RhcmdldBgEIAEoCFIJbWV0VGFyZ2V0Eh4KCmNvbXBh'
    'cmFibGUYBSABKAhSCmNvbXBhcmFibGU=');

@$core.Deprecated('Use getDashboardRequestDescriptor instead')
const GetDashboardRequest$json = {
  '1': 'GetDashboardRequest',
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
  ],
};

/// Descriptor for `GetDashboardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardRequestDescriptor = $convert.base64Decode(
    'ChNHZXREYXNoYm9hcmRSZXF1ZXN0Ei4KBGZyb20YASABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgRmcm9tEioKAnRvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIC'
    'dG8=');

@$core.Deprecated('Use getDashboardResponseDescriptor instead')
const GetDashboardResponse$json = {
  '1': 'GetDashboardResponse',
  '2': [
    {
      '1': 'lines',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorLine',
      '10': 'lines'
    },
  ],
};

/// Descriptor for `GetDashboardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDashboardResponseDescriptor = $convert.base64Decode(
    'ChRHZXREYXNoYm9hcmRSZXNwb25zZRI6CgVsaW5lcxgBIAMoCzIkLmhlYWx0aGNhcmUucXVhbG'
    'l0eS52MS5JbmRpY2F0b3JMaW5lUgVsaW5lcw==');

@$core.Deprecated('Use listIndicatorValuesRequestDescriptor instead')
const ListIndicatorValuesRequest$json = {
  '1': 'ListIndicatorValuesRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
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

/// Descriptor for `ListIndicatorValuesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIndicatorValuesRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0SW5kaWNhdG9yVmFsdWVzUmVxdWVzdBISCgRjb2RlGAEgASgJUgRjb2RlEi4KBGZyb2'
        '0YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAMgASgLMhou'
        'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use listIndicatorValuesResponseDescriptor instead')
const ListIndicatorValuesResponse$json = {
  '1': 'ListIndicatorValuesResponse',
  '2': [
    {
      '1': 'values',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.IndicatorValue',
      '10': 'values'
    },
  ],
};

/// Descriptor for `ListIndicatorValuesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listIndicatorValuesResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0SW5kaWNhdG9yVmFsdWVzUmVzcG9uc2USPQoGdmFsdWVzGAEgAygLMiUuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkluZGljYXRvclZhbHVlUgZ2YWx1ZXM=');

@$core.Deprecated('Use complaintDescriptor instead')
const Complaint$json = {
  '1': 'Complaint',
  '2': [
    {'1': 'complaint_id', '3': 1, '4': 1, '5': 9, '10': 'complaintId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ComplainantKind',
      '10': 'kind'
    },
    {'1': 'complainant_ref', '3': 4, '4': 1, '5': 9, '10': 'complainantRef'},
    {'1': 'patient_id', '3': 5, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 6, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'category', '3': 7, '4': 1, '5': 9, '10': 'category'},
    {'1': 'department', '3': 8, '4': 1, '5': 9, '10': 'department'},
    {'1': 'facility_id', '3': 9, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'channel', '3': 10, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'detail', '3': 11, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'acknowledge_by',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgeBy'
    },
    {
      '1': 'acknowledged_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
    {'1': 'acknowledged_by', '3': 14, '4': 1, '5': 9, '10': 'acknowledgedBy'},
    {
      '1': 'resolve_by',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolveBy'
    },
    {
      '1': 'state',
      '3': 16,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ComplaintState',
      '10': 'state'
    },
    {
      '1': 'outcome',
      '3': 17,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ComplaintOutcome',
      '10': 'outcome'
    },
    {'1': 'resolution', '3': 18, '4': 1, '5': 9, '10': 'resolution'},
    {'1': 'closure_reason', '3': 19, '4': 1, '5': 9, '10': 'closureReason'},
    {'1': 'escalated', '3': 20, '4': 1, '5': 8, '10': 'escalated'},
    {
      '1': 'escalated_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'escalatedAt'
    },
    {
      '1': 'received_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'received_by', '3': 23, '4': 1, '5': 9, '10': 'receivedBy'},
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

/// Descriptor for `Complaint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complaintDescriptor = $convert.base64Decode(
    'CglDb21wbGFpbnQSIQoMY29tcGxhaW50X2lkGAEgASgJUgtjb21wbGFpbnRJZBIcCglyZWZlcm'
    'VuY2UYAiABKAlSCXJlZmVyZW5jZRI6CgRraW5kGAMgASgOMiYuaGVhbHRoY2FyZS5xdWFsaXR5'
    'LnYxLkNvbXBsYWluYW50S2luZFIEa2luZBInCg9jb21wbGFpbmFudF9yZWYYBCABKAlSDmNvbX'
    'BsYWluYW50UmVmEh0KCnBhdGllbnRfaWQYBSABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJf'
    'aWQYBiABKAlSC2VuY291bnRlcklkEhoKCGNhdGVnb3J5GAcgASgJUghjYXRlZ29yeRIeCgpkZX'
    'BhcnRtZW50GAggASgJUgpkZXBhcnRtZW50Eh8KC2ZhY2lsaXR5X2lkGAkgASgJUgpmYWNpbGl0'
    'eUlkEhgKB2NoYW5uZWwYCiABKAlSB2NoYW5uZWwSFgoGZGV0YWlsGAsgASgJUgZkZXRhaWwSQQ'
    'oOYWNrbm93bGVkZ2VfYnkYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1hY2tu'
    'b3dsZWRnZUJ5EkMKD2Fja25vd2xlZGdlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSDmFja25vd2xlZGdlZEF0EicKD2Fja25vd2xlZGdlZF9ieRgOIAEoCVIOYWNrbm93'
    'bGVkZ2VkQnkSOQoKcmVzb2x2ZV9ieRgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCXJlc29sdmVCeRI7CgVzdGF0ZRgQIAEoDjIlLmhlYWx0aGNhcmUucXVhbGl0eS52MS5Db21w'
    'bGFpbnRTdGF0ZVIFc3RhdGUSQQoHb3V0Y29tZRgRIAEoDjInLmhlYWx0aGNhcmUucXVhbGl0eS'
    '52MS5Db21wbGFpbnRPdXRjb21lUgdvdXRjb21lEh4KCnJlc29sdXRpb24YEiABKAlSCnJlc29s'
    'dXRpb24SJQoOY2xvc3VyZV9yZWFzb24YEyABKAlSDWNsb3N1cmVSZWFzb24SHAoJZXNjYWxhdG'
    'VkGBQgASgIUgllc2NhbGF0ZWQSPQoMZXNjYWxhdGVkX2F0GBUgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFILZXNjYWxhdGVkQXQSOwoLcmVjZWl2ZWRfYXQYFiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgpyZWNlaXZlZEF0Eh8KC3JlY2VpdmVkX2J5GBcgASgJUgpy'
    'ZWNlaXZlZEJ5EjcKCWNsb3NlZF9hdBgYIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCGNsb3NlZEF0EhsKCWNsb3NlZF9ieRgZIAEoCVIIY2xvc2VkQnkSGAoHdmVyc2lvbhgaIAEo'
    'A1IHdmVyc2lvbg==');

@$core.Deprecated('Use receiveComplaintRequestDescriptor instead')
const ReceiveComplaintRequest$json = {
  '1': 'ReceiveComplaintRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ComplainantKind',
      '10': 'kind'
    },
    {'1': 'complainant_ref', '3': 3, '4': 1, '5': 9, '10': 'complainantRef'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'category', '3': 6, '4': 1, '5': 9, '10': 'category'},
    {'1': 'department', '3': 7, '4': 1, '5': 9, '10': 'department'},
    {'1': 'facility_id', '3': 8, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'channel', '3': 9, '4': 1, '5': 9, '10': 'channel'},
    {'1': 'detail', '3': 10, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'received_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
  ],
};

/// Descriptor for `ReceiveComplaintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveComplaintRequestDescriptor = $convert.base64Decode(
    'ChdSZWNlaXZlQ29tcGxhaW50UmVxdWVzdBIcCglyZWZlcmVuY2UYASABKAlSCXJlZmVyZW5jZR'
    'I6CgRraW5kGAIgASgOMiYuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNvbXBsYWluYW50S2luZFIE'
    'a2luZBInCg9jb21wbGFpbmFudF9yZWYYAyABKAlSDmNvbXBsYWluYW50UmVmEh0KCnBhdGllbn'
    'RfaWQYBCABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYBSABKAlSC2VuY291bnRlcklk'
    'EhoKCGNhdGVnb3J5GAYgASgJUghjYXRlZ29yeRIeCgpkZXBhcnRtZW50GAcgASgJUgpkZXBhcn'
    'RtZW50Eh8KC2ZhY2lsaXR5X2lkGAggASgJUgpmYWNpbGl0eUlkEhgKB2NoYW5uZWwYCSABKAlS'
    'B2NoYW5uZWwSFgoGZGV0YWlsGAogASgJUgZkZXRhaWwSOwoLcmVjZWl2ZWRfYXQYCyABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNlaXZlZEF0');

@$core.Deprecated('Use receiveComplaintResponseDescriptor instead')
const ReceiveComplaintResponse$json = {
  '1': 'ReceiveComplaintResponse',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
  ],
};

/// Descriptor for `ReceiveComplaintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List receiveComplaintResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNlaXZlQ29tcGxhaW50UmVzcG9uc2USPgoJY29tcGxhaW50GAEgASgLMiAuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkNvbXBsYWludFIJY29tcGxhaW50');

@$core.Deprecated('Use acknowledgeComplaintRequestDescriptor instead')
const AcknowledgeComplaintRequest$json = {
  '1': 'AcknowledgeComplaintRequest',
  '2': [
    {'1': 'complaint_id', '3': 1, '4': 1, '5': 9, '10': 'complaintId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `AcknowledgeComplaintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeComplaintRequestDescriptor =
    $convert.base64Decode(
        'ChtBY2tub3dsZWRnZUNvbXBsYWludFJlcXVlc3QSIQoMY29tcGxhaW50X2lkGAEgASgJUgtjb2'
        '1wbGFpbnRJZBIpChBleHBlY3RlZF92ZXJzaW9uGAIgASgDUg9leHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use acknowledgeComplaintResponseDescriptor instead')
const AcknowledgeComplaintResponse$json = {
  '1': 'AcknowledgeComplaintResponse',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
  ],
};

/// Descriptor for `AcknowledgeComplaintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeComplaintResponseDescriptor =
    $convert.base64Decode(
        'ChxBY2tub3dsZWRnZUNvbXBsYWludFJlc3BvbnNlEj4KCWNvbXBsYWludBgBIAEoCzIgLmhlYW'
        'x0aGNhcmUucXVhbGl0eS52MS5Db21wbGFpbnRSCWNvbXBsYWludA==');

@$core.Deprecated('Use resolveComplaintRequestDescriptor instead')
const ResolveComplaintRequest$json = {
  '1': 'ResolveComplaintRequest',
  '2': [
    {'1': 'complaint_id', '3': 1, '4': 1, '5': 9, '10': 'complaintId'},
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ComplaintOutcome',
      '10': 'outcome'
    },
    {'1': 'resolution', '3': 3, '4': 1, '5': 9, '10': 'resolution'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `ResolveComplaintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveComplaintRequestDescriptor = $convert.base64Decode(
    'ChdSZXNvbHZlQ29tcGxhaW50UmVxdWVzdBIhCgxjb21wbGFpbnRfaWQYASABKAlSC2NvbXBsYW'
    'ludElkEkEKB291dGNvbWUYAiABKA4yJy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQ29tcGxhaW50'
    'T3V0Y29tZVIHb3V0Y29tZRIeCgpyZXNvbHV0aW9uGAMgASgJUgpyZXNvbHV0aW9uEikKEGV4cG'
    'VjdGVkX3ZlcnNpb24YBCABKANSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use resolveComplaintResponseDescriptor instead')
const ResolveComplaintResponse$json = {
  '1': 'ResolveComplaintResponse',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
  ],
};

/// Descriptor for `ResolveComplaintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveComplaintResponseDescriptor =
    $convert.base64Decode(
        'ChhSZXNvbHZlQ29tcGxhaW50UmVzcG9uc2USPgoJY29tcGxhaW50GAEgASgLMiAuaGVhbHRoY2'
        'FyZS5xdWFsaXR5LnYxLkNvbXBsYWludFIJY29tcGxhaW50');

@$core.Deprecated('Use closeComplaintRequestDescriptor instead')
const CloseComplaintRequest$json = {
  '1': 'CloseComplaintRequest',
  '2': [
    {'1': 'complaint_id', '3': 1, '4': 1, '5': 9, '10': 'complaintId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CloseComplaintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeComplaintRequestDescriptor = $convert.base64Decode(
    'ChVDbG9zZUNvbXBsYWludFJlcXVlc3QSIQoMY29tcGxhaW50X2lkGAEgASgJUgtjb21wbGFpbn'
    'RJZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbhIpChBleHBlY3RlZF92ZXJzaW9uGAMgASgDUg9l'
    'eHBlY3RlZFZlcnNpb24=');

@$core.Deprecated('Use closeComplaintResponseDescriptor instead')
const CloseComplaintResponse$json = {
  '1': 'CloseComplaintResponse',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
  ],
};

/// Descriptor for `CloseComplaintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeComplaintResponseDescriptor =
    $convert.base64Decode(
        'ChZDbG9zZUNvbXBsYWludFJlc3BvbnNlEj4KCWNvbXBsYWludBgBIAEoCzIgLmhlYWx0aGNhcm'
        'UucXVhbGl0eS52MS5Db21wbGFpbnRSCWNvbXBsYWludA==');

@$core.Deprecated('Use getComplaintRequestDescriptor instead')
const GetComplaintRequest$json = {
  '1': 'GetComplaintRequest',
  '2': [
    {'1': 'complaint_id', '3': 1, '4': 1, '5': 9, '10': 'complaintId'},
  ],
};

/// Descriptor for `GetComplaintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getComplaintRequestDescriptor = $convert.base64Decode(
    'ChNHZXRDb21wbGFpbnRSZXF1ZXN0EiEKDGNvbXBsYWludF9pZBgBIAEoCVILY29tcGxhaW50SW'
    'Q=');

@$core.Deprecated('Use getComplaintResponseDescriptor instead')
const GetComplaintResponse$json = {
  '1': 'GetComplaintResponse',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
  ],
};

/// Descriptor for `GetComplaintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getComplaintResponseDescriptor = $convert.base64Decode(
    'ChRHZXRDb21wbGFpbnRSZXNwb25zZRI+Cgljb21wbGFpbnQYASABKAsyIC5oZWFsdGhjYXJlLn'
    'F1YWxpdHkudjEuQ29tcGxhaW50Ugljb21wbGFpbnQ=');

@$core.Deprecated('Use listComplaintsRequestDescriptor instead')
const ListComplaintsRequest$json = {
  '1': 'ListComplaintsRequest',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListComplaintsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComplaintsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q29tcGxhaW50c1JlcXVlc3QSGgoIY2F0ZWdvcnkYASABKAlSCGNhdGVnb3J5EhsKCW'
    '9wZW5fb25seRgCIAEoCFIIb3Blbk9ubHkSGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listComplaintsResponseDescriptor instead')
const ListComplaintsResponse$json = {
  '1': 'ListComplaintsResponse',
  '2': [
    {
      '1': 'complaints',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaints'
    },
  ],
};

/// Descriptor for `ListComplaintsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComplaintsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Q29tcGxhaW50c1Jlc3BvbnNlEkAKCmNvbXBsYWludHMYASADKAsyIC5oZWFsdGhjYX'
        'JlLnF1YWxpdHkudjEuQ29tcGxhaW50Ugpjb21wbGFpbnRz');

@$core.Deprecated('Use complaintBreachDescriptor instead')
const ComplaintBreach$json = {
  '1': 'ComplaintBreach',
  '2': [
    {
      '1': 'complaint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.Complaint',
      '10': 'complaint'
    },
    {
      '1': 'acknowledgement_breached',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'acknowledgementBreached'
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

/// Descriptor for `ComplaintBreach`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List complaintBreachDescriptor = $convert.base64Decode(
    'Cg9Db21wbGFpbnRCcmVhY2gSPgoJY29tcGxhaW50GAEgASgLMiAuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkNvbXBsYWludFIJY29tcGxhaW50EjkKGGFja25vd2xlZGdlbWVudF9icmVhY2hlZBgC'
    'IAEoCFIXYWNrbm93bGVkZ2VtZW50QnJlYWNoZWQSLwoTcmVzb2x1dGlvbl9icmVhY2hlZBgDIA'
    'EoCFIScmVzb2x1dGlvbkJyZWFjaGVk');

@$core.Deprecated('Use listComplaintBreachesRequestDescriptor instead')
const ListComplaintBreachesRequest$json = {
  '1': 'ListComplaintBreachesRequest',
};

/// Descriptor for `ListComplaintBreachesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComplaintBreachesRequestDescriptor =
    $convert.base64Decode('ChxMaXN0Q29tcGxhaW50QnJlYWNoZXNSZXF1ZXN0');

@$core.Deprecated('Use listComplaintBreachesResponseDescriptor instead')
const ListComplaintBreachesResponse$json = {
  '1': 'ListComplaintBreachesResponse',
  '2': [
    {
      '1': 'breaches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.ComplaintBreach',
      '10': 'breaches'
    },
  ],
};

/// Descriptor for `ListComplaintBreachesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComplaintBreachesResponseDescriptor =
    $convert.base64Decode(
        'Ch1MaXN0Q29tcGxhaW50QnJlYWNoZXNSZXNwb25zZRJCCghicmVhY2hlcxgBIAMoCzImLmhlYW'
        'x0aGNhcmUucXVhbGl0eS52MS5Db21wbGFpbnRCcmVhY2hSCGJyZWFjaGVz');

@$core.Deprecated('Use escalateComplaintBreachesRequestDescriptor instead')
const EscalateComplaintBreachesRequest$json = {
  '1': 'EscalateComplaintBreachesRequest',
};

/// Descriptor for `EscalateComplaintBreachesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateComplaintBreachesRequestDescriptor =
    $convert.base64Decode('CiBFc2NhbGF0ZUNvbXBsYWludEJyZWFjaGVzUmVxdWVzdA==');

@$core.Deprecated('Use escalateComplaintBreachesResponseDescriptor instead')
const EscalateComplaintBreachesResponse$json = {
  '1': 'EscalateComplaintBreachesResponse',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
  ],
};

/// Descriptor for `EscalateComplaintBreachesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateComplaintBreachesResponseDescriptor =
    $convert.base64Decode(
        'CiFFc2NhbGF0ZUNvbXBsYWludEJyZWFjaGVzUmVzcG9uc2USFgoGcmFpc2VkGAEgASgFUgZyYW'
        'lzZWQ=');

@$core.Deprecated('Use mortalityReviewDescriptor instead')
const MortalityReview$json = {
  '1': 'MortalityReview',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'died_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'diedAt'
    },
    {'1': 'committee_id', '3': 5, '4': 1, '5': 9, '10': 'committeeId'},
    {'1': 'meeting_id', '3': 6, '4': 1, '5': 9, '10': 'meetingId'},
    {
      '1': 'classification',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.DeathClassification',
      '10': 'classification'
    },
    {'1': 'findings', '3': 8, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'learning_points', '3': 9, '4': 1, '5': 9, '10': 'learningPoints'},
    {'1': 'action_ids', '3': 10, '4': 3, '5': 9, '10': 'actionIds'},
    {
      '1': 'state',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.ReviewState',
      '10': 'state'
    },
    {
      '1': 'opened_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'openedAt'
    },
    {'1': 'opened_by', '3': 13, '4': 1, '5': 9, '10': 'openedBy'},
    {
      '1': 'completed_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'completed_by', '3': 15, '4': 1, '5': 9, '10': 'completedBy'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `MortalityReview`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mortalityReviewDescriptor = $convert.base64Decode(
    'Cg9Nb3J0YWxpdHlSZXZpZXcSGwoJcmV2aWV3X2lkGAEgASgJUghyZXZpZXdJZBIdCgpwYXRpZW'
    '50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJ'
    'ZBIzCgdkaWVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGZGllZEF0Ei'
    'EKDGNvbW1pdHRlZV9pZBgFIAEoCVILY29tbWl0dGVlSWQSHQoKbWVldGluZ19pZBgGIAEoCVIJ'
    'bWVldGluZ0lkElIKDmNsYXNzaWZpY2F0aW9uGAcgASgOMiouaGVhbHRoY2FyZS5xdWFsaXR5Ln'
    'YxLkRlYXRoQ2xhc3NpZmljYXRpb25SDmNsYXNzaWZpY2F0aW9uEhoKCGZpbmRpbmdzGAggASgJ'
    'UghmaW5kaW5ncxInCg9sZWFybmluZ19wb2ludHMYCSABKAlSDmxlYXJuaW5nUG9pbnRzEh0KCm'
    'FjdGlvbl9pZHMYCiADKAlSCWFjdGlvbklkcxI4CgVzdGF0ZRgLIAEoDjIiLmhlYWx0aGNhcmUu'
    'cXVhbGl0eS52MS5SZXZpZXdTdGF0ZVIFc3RhdGUSNwoJb3BlbmVkX2F0GAwgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIIb3BlbmVkQXQSGwoJb3BlbmVkX2J5GA0gASgJUghvcGVu'
    'ZWRCeRI9Cgxjb21wbGV0ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'tjb21wbGV0ZWRBdBIhCgxjb21wbGV0ZWRfYnkYDyABKAlSC2NvbXBsZXRlZEJ5EhgKB3ZlcnNp'
    'b24YECABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use startMortalityReviewRequestDescriptor instead')
const StartMortalityReviewRequest$json = {
  '1': 'StartMortalityReviewRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'committee_id', '3': 3, '4': 1, '5': 9, '10': 'committeeId'},
    {
      '1': 'died_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'diedAt'
    },
  ],
};

/// Descriptor for `StartMortalityReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startMortalityReviewRequestDescriptor = $convert.base64Decode(
    'ChtTdGFydE1vcnRhbGl0eVJldmlld1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aW'
    'VudElkEiEKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSIQoMY29tbWl0dGVlX2lk'
    'GAMgASgJUgtjb21taXR0ZWVJZBIzCgdkaWVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIGZGllZEF0');

@$core.Deprecated('Use startMortalityReviewResponseDescriptor instead')
const StartMortalityReviewResponse$json = {
  '1': 'StartMortalityReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.MortalityReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `StartMortalityReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startMortalityReviewResponseDescriptor =
    $convert.base64Decode(
        'ChxTdGFydE1vcnRhbGl0eVJldmlld1Jlc3BvbnNlEj4KBnJldmlldxgBIAEoCzImLmhlYWx0aG'
        'NhcmUucXVhbGl0eS52MS5Nb3J0YWxpdHlSZXZpZXdSBnJldmlldw==');

@$core.Deprecated('Use completeMortalityReviewRequestDescriptor instead')
const CompleteMortalityReviewRequest$json = {
  '1': 'CompleteMortalityReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
    {'1': 'meeting_id', '3': 2, '4': 1, '5': 9, '10': 'meetingId'},
    {
      '1': 'classification',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.quality.v1.DeathClassification',
      '10': 'classification'
    },
    {'1': 'findings', '3': 4, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'learning_points', '3': 5, '4': 1, '5': 9, '10': 'learningPoints'},
    {'1': 'action_ids', '3': 6, '4': 3, '5': 9, '10': 'actionIds'},
    {'1': 'expected_version', '3': 7, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `CompleteMortalityReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeMortalityReviewRequestDescriptor = $convert.base64Decode(
    'Ch5Db21wbGV0ZU1vcnRhbGl0eVJldmlld1JlcXVlc3QSGwoJcmV2aWV3X2lkGAEgASgJUghyZX'
    'ZpZXdJZBIdCgptZWV0aW5nX2lkGAIgASgJUgltZWV0aW5nSWQSUgoOY2xhc3NpZmljYXRpb24Y'
    'AyABKA4yKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuRGVhdGhDbGFzc2lmaWNhdGlvblIOY2xhc3'
    'NpZmljYXRpb24SGgoIZmluZGluZ3MYBCABKAlSCGZpbmRpbmdzEicKD2xlYXJuaW5nX3BvaW50'
    'cxgFIAEoCVIObGVhcm5pbmdQb2ludHMSHQoKYWN0aW9uX2lkcxgGIAMoCVIJYWN0aW9uSWRzEi'
    'kKEGV4cGVjdGVkX3ZlcnNpb24YByABKANSD2V4cGVjdGVkVmVyc2lvbg==');

@$core.Deprecated('Use completeMortalityReviewResponseDescriptor instead')
const CompleteMortalityReviewResponse$json = {
  '1': 'CompleteMortalityReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.MortalityReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `CompleteMortalityReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeMortalityReviewResponseDescriptor =
    $convert.base64Decode(
        'Ch9Db21wbGV0ZU1vcnRhbGl0eVJldmlld1Jlc3BvbnNlEj4KBnJldmlldxgBIAEoCzImLmhlYW'
        'x0aGNhcmUucXVhbGl0eS52MS5Nb3J0YWxpdHlSZXZpZXdSBnJldmlldw==');

@$core.Deprecated('Use getMortalityReviewRequestDescriptor instead')
const GetMortalityReviewRequest$json = {
  '1': 'GetMortalityReviewRequest',
  '2': [
    {'1': 'review_id', '3': 1, '4': 1, '5': 9, '10': 'reviewId'},
  ],
};

/// Descriptor for `GetMortalityReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMortalityReviewRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRNb3J0YWxpdHlSZXZpZXdSZXF1ZXN0EhsKCXJldmlld19pZBgBIAEoCVIIcmV2aWV3SW'
        'Q=');

@$core.Deprecated('Use getMortalityReviewResponseDescriptor instead')
const GetMortalityReviewResponse$json = {
  '1': 'GetMortalityReviewResponse',
  '2': [
    {
      '1': 'review',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.quality.v1.MortalityReview',
      '10': 'review'
    },
  ],
};

/// Descriptor for `GetMortalityReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMortalityReviewResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRNb3J0YWxpdHlSZXZpZXdSZXNwb25zZRI+CgZyZXZpZXcYASABKAsyJi5oZWFsdGhjYX'
        'JlLnF1YWxpdHkudjEuTW9ydGFsaXR5UmV2aWV3UgZyZXZpZXc=');

@$core.Deprecated('Use listMortalityReviewsRequestDescriptor instead')
const ListMortalityReviewsRequest$json = {
  '1': 'ListMortalityReviewsRequest',
  '2': [
    {'1': 'open_only', '3': 1, '4': 1, '5': 8, '10': 'openOnly'},
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

/// Descriptor for `ListMortalityReviewsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMortalityReviewsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0TW9ydGFsaXR5UmV2aWV3c1JlcXVlc3QSGwoJb3Blbl9vbmx5GAEgASgIUghvcGVuT2'
    '5seRIuCgRmcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0'
    'bxgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgEIA'
    'EoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listMortalityReviewsResponseDescriptor instead')
const ListMortalityReviewsResponse$json = {
  '1': 'ListMortalityReviewsResponse',
  '2': [
    {
      '1': 'reviews',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.quality.v1.MortalityReview',
      '10': 'reviews'
    },
  ],
};

/// Descriptor for `ListMortalityReviewsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMortalityReviewsResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0TW9ydGFsaXR5UmV2aWV3c1Jlc3BvbnNlEkAKB3Jldmlld3MYASADKAsyJi5oZWFsdG'
        'hjYXJlLnF1YWxpdHkudjEuTW9ydGFsaXR5UmV2aWV3UgdyZXZpZXdz');

@$core.Deprecated('Use placeHoldRequestDescriptor instead')
const PlaceHoldRequest$json = {
  '1': 'PlaceHoldRequest',
  '2': [
    {'1': 'record_class', '3': 1, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `PlaceHoldRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeHoldRequestDescriptor = $convert.base64Decode(
    'ChBQbGFjZUhvbGRSZXF1ZXN0EiEKDHJlY29yZF9jbGFzcxgBIAEoCVILcmVjb3JkQ2xhc3MSGw'
    'oJcmVjb3JkX2lkGAIgASgJUghyZWNvcmRJZBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use placeHoldResponseDescriptor instead')
const PlaceHoldResponse$json = {
  '1': 'PlaceHoldResponse',
};

/// Descriptor for `PlaceHoldResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeHoldResponseDescriptor =
    $convert.base64Decode('ChFQbGFjZUhvbGRSZXNwb25zZQ==');

@$core.Deprecated('Use releaseHoldRequestDescriptor instead')
const ReleaseHoldRequest$json = {
  '1': 'ReleaseHoldRequest',
  '2': [
    {'1': 'record_class', '3': 1, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'record_id', '3': 2, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReleaseHoldRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseHoldRequestDescriptor = $convert.base64Decode(
    'ChJSZWxlYXNlSG9sZFJlcXVlc3QSIQoMcmVjb3JkX2NsYXNzGAEgASgJUgtyZWNvcmRDbGFzcx'
    'IbCglyZWNvcmRfaWQYAiABKAlSCHJlY29yZElkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use releaseHoldResponseDescriptor instead')
const ReleaseHoldResponse$json = {
  '1': 'ReleaseHoldResponse',
};

/// Descriptor for `ReleaseHoldResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseHoldResponseDescriptor =
    $convert.base64Decode('ChNSZWxlYXNlSG9sZFJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> QualityServiceBase$json = {
  '1': 'QualityService',
  '2': [
    {
      '1': 'ReportIncident',
      '2': '.healthcare.quality.v1.ReportIncidentRequest',
      '3': '.healthcare.quality.v1.ReportIncidentResponse'
    },
    {
      '1': 'GetIncident',
      '2': '.healthcare.quality.v1.GetIncidentRequest',
      '3': '.healthcare.quality.v1.GetIncidentResponse'
    },
    {
      '1': 'ListIncidents',
      '2': '.healthcare.quality.v1.ListIncidentsRequest',
      '3': '.healthcare.quality.v1.ListIncidentsResponse'
    },
    {
      '1': 'RescoreIncident',
      '2': '.healthcare.quality.v1.RescoreIncidentRequest',
      '3': '.healthcare.quality.v1.RescoreIncidentResponse'
    },
    {
      '1': 'AdvanceIncident',
      '2': '.healthcare.quality.v1.AdvanceIncidentRequest',
      '3': '.healthcare.quality.v1.AdvanceIncidentResponse'
    },
    {
      '1': 'SetIncidentRestriction',
      '2': '.healthcare.quality.v1.SetIncidentRestrictionRequest',
      '3': '.healthcare.quality.v1.SetIncidentRestrictionResponse'
    },
    {
      '1': 'GetTrends',
      '2': '.healthcare.quality.v1.GetTrendsRequest',
      '3': '.healthcare.quality.v1.GetTrendsResponse'
    },
    {
      '1': 'StartRca',
      '2': '.healthcare.quality.v1.StartRcaRequest',
      '3': '.healthcare.quality.v1.StartRcaResponse'
    },
    {
      '1': 'AddFactor',
      '2': '.healthcare.quality.v1.AddFactorRequest',
      '3': '.healthcare.quality.v1.AddFactorResponse'
    },
    {
      '1': 'CompleteRca',
      '2': '.healthcare.quality.v1.CompleteRcaRequest',
      '3': '.healthcare.quality.v1.CompleteRcaResponse'
    },
    {
      '1': 'GetRca',
      '2': '.healthcare.quality.v1.GetRcaRequest',
      '3': '.healthcare.quality.v1.GetRcaResponse'
    },
    {
      '1': 'RaiseAction',
      '2': '.healthcare.quality.v1.RaiseActionRequest',
      '3': '.healthcare.quality.v1.RaiseActionResponse'
    },
    {
      '1': 'ApproveAction',
      '2': '.healthcare.quality.v1.ApproveActionRequest',
      '3': '.healthcare.quality.v1.ApproveActionResponse'
    },
    {
      '1': 'AdvanceAction',
      '2': '.healthcare.quality.v1.AdvanceActionRequest',
      '3': '.healthcare.quality.v1.AdvanceActionResponse'
    },
    {
      '1': 'RecordEffectiveness',
      '2': '.healthcare.quality.v1.RecordEffectivenessRequest',
      '3': '.healthcare.quality.v1.RecordEffectivenessResponse'
    },
    {
      '1': 'CloseAction',
      '2': '.healthcare.quality.v1.CloseActionRequest',
      '3': '.healthcare.quality.v1.CloseActionResponse'
    },
    {
      '1': 'GetAction',
      '2': '.healthcare.quality.v1.GetActionRequest',
      '3': '.healthcare.quality.v1.GetActionResponse'
    },
    {
      '1': 'ListActions',
      '2': '.healthcare.quality.v1.ListActionsRequest',
      '3': '.healthcare.quality.v1.ListActionsResponse'
    },
    {
      '1': 'ListOverdueActions',
      '2': '.healthcare.quality.v1.ListOverdueActionsRequest',
      '3': '.healthcare.quality.v1.ListOverdueActionsResponse'
    },
    {
      '1': 'EscalateOverdueActions',
      '2': '.healthcare.quality.v1.EscalateOverdueActionsRequest',
      '3': '.healthcare.quality.v1.EscalateOverdueActionsResponse'
    },
    {
      '1': 'RegisterDocument',
      '2': '.healthcare.quality.v1.RegisterDocumentRequest',
      '3': '.healthcare.quality.v1.RegisterDocumentResponse'
    },
    {
      '1': 'DraftVersion',
      '2': '.healthcare.quality.v1.DraftVersionRequest',
      '3': '.healthcare.quality.v1.DraftVersionResponse'
    },
    {
      '1': 'ApproveVersion',
      '2': '.healthcare.quality.v1.ApproveVersionRequest',
      '3': '.healthcare.quality.v1.ApproveVersionResponse'
    },
    {
      '1': 'GetCurrentVersion',
      '2': '.healthcare.quality.v1.GetCurrentVersionRequest',
      '3': '.healthcare.quality.v1.GetCurrentVersionResponse'
    },
    {
      '1': 'ListVersions',
      '2': '.healthcare.quality.v1.ListVersionsRequest',
      '3': '.healthcare.quality.v1.ListVersionsResponse'
    },
    {
      '1': 'ListDocuments',
      '2': '.healthcare.quality.v1.ListDocumentsRequest',
      '3': '.healthcare.quality.v1.ListDocumentsResponse'
    },
    {
      '1': 'AcknowledgeDocument',
      '2': '.healthcare.quality.v1.AcknowledgeDocumentRequest',
      '3': '.healthcare.quality.v1.AcknowledgeDocumentResponse'
    },
    {
      '1': 'ListOutstandingAcknowledgements',
      '2': '.healthcare.quality.v1.ListOutstandingAcknowledgementsRequest',
      '3': '.healthcare.quality.v1.ListOutstandingAcknowledgementsResponse'
    },
    {
      '1': 'ListReviewsDue',
      '2': '.healthcare.quality.v1.ListReviewsDueRequest',
      '3': '.healthcare.quality.v1.ListReviewsDueResponse'
    },
    {
      '1': 'DefineCompetency',
      '2': '.healthcare.quality.v1.DefineCompetencyRequest',
      '3': '.healthcare.quality.v1.DefineCompetencyResponse'
    },
    {
      '1': 'RequireCompetency',
      '2': '.healthcare.quality.v1.RequireCompetencyRequest',
      '3': '.healthcare.quality.v1.RequireCompetencyResponse'
    },
    {
      '1': 'AwardCompetency',
      '2': '.healthcare.quality.v1.AwardCompetencyRequest',
      '3': '.healthcare.quality.v1.AwardCompetencyResponse'
    },
    {
      '1': 'ListCompetencyGaps',
      '2': '.healthcare.quality.v1.ListCompetencyGapsRequest',
      '3': '.healthcare.quality.v1.ListCompetencyGapsResponse'
    },
    {
      '1': 'PlanAudit',
      '2': '.healthcare.quality.v1.PlanAuditRequest',
      '3': '.healthcare.quality.v1.PlanAuditResponse'
    },
    {
      '1': 'RecordFinding',
      '2': '.healthcare.quality.v1.RecordFindingRequest',
      '3': '.healthcare.quality.v1.RecordFindingResponse'
    },
    {
      '1': 'LinkFindingAction',
      '2': '.healthcare.quality.v1.LinkFindingActionRequest',
      '3': '.healthcare.quality.v1.LinkFindingActionResponse'
    },
    {
      '1': 'CloseFinding',
      '2': '.healthcare.quality.v1.CloseFindingRequest',
      '3': '.healthcare.quality.v1.CloseFindingResponse'
    },
    {
      '1': 'ReportAudit',
      '2': '.healthcare.quality.v1.ReportAuditRequest',
      '3': '.healthcare.quality.v1.ReportAuditResponse'
    },
    {
      '1': 'CloseAudit',
      '2': '.healthcare.quality.v1.CloseAuditRequest',
      '3': '.healthcare.quality.v1.CloseAuditResponse'
    },
    {
      '1': 'GetAudit',
      '2': '.healthcare.quality.v1.GetAuditRequest',
      '3': '.healthcare.quality.v1.GetAuditResponse'
    },
    {
      '1': 'ListAudits',
      '2': '.healthcare.quality.v1.ListAuditsRequest',
      '3': '.healthcare.quality.v1.ListAuditsResponse'
    },
    {
      '1': 'ListFindings',
      '2': '.healthcare.quality.v1.ListFindingsRequest',
      '3': '.healthcare.quality.v1.ListFindingsResponse'
    },
    {
      '1': 'FormCommittee',
      '2': '.healthcare.quality.v1.FormCommitteeRequest',
      '3': '.healthcare.quality.v1.FormCommitteeResponse'
    },
    {
      '1': 'ScheduleMeeting',
      '2': '.healthcare.quality.v1.ScheduleMeetingRequest',
      '3': '.healthcare.quality.v1.ScheduleMeetingResponse'
    },
    {
      '1': 'RecordMinutes',
      '2': '.healthcare.quality.v1.RecordMinutesRequest',
      '3': '.healthcare.quality.v1.RecordMinutesResponse'
    },
    {
      '1': 'GetMeeting',
      '2': '.healthcare.quality.v1.GetMeetingRequest',
      '3': '.healthcare.quality.v1.GetMeetingResponse'
    },
    {
      '1': 'ListCommittees',
      '2': '.healthcare.quality.v1.ListCommitteesRequest',
      '3': '.healthcare.quality.v1.ListCommitteesResponse'
    },
    {
      '1': 'LoadStandard',
      '2': '.healthcare.quality.v1.LoadStandardRequest',
      '3': '.healthcare.quality.v1.LoadStandardResponse'
    },
    {
      '1': 'FileEvidence',
      '2': '.healthcare.quality.v1.FileEvidenceRequest',
      '3': '.healthcare.quality.v1.FileEvidenceResponse'
    },
    {
      '1': 'WithdrawEvidence',
      '2': '.healthcare.quality.v1.WithdrawEvidenceRequest',
      '3': '.healthcare.quality.v1.WithdrawEvidenceResponse'
    },
    {
      '1': 'ReviewClause',
      '2': '.healthcare.quality.v1.ReviewClauseRequest',
      '3': '.healthcare.quality.v1.ReviewClauseResponse'
    },
    {
      '1': 'GetReadiness',
      '2': '.healthcare.quality.v1.GetReadinessRequest',
      '3': '.healthcare.quality.v1.GetReadinessResponse'
    },
    {
      '1': 'ListStandards',
      '2': '.healthcare.quality.v1.ListStandardsRequest',
      '3': '.healthcare.quality.v1.ListStandardsResponse'
    },
    {
      '1': 'ListClauses',
      '2': '.healthcare.quality.v1.ListClausesRequest',
      '3': '.healthcare.quality.v1.ListClausesResponse'
    },
    {
      '1': 'DefineIndicator',
      '2': '.healthcare.quality.v1.DefineIndicatorRequest',
      '3': '.healthcare.quality.v1.DefineIndicatorResponse'
    },
    {
      '1': 'RecordIndicatorValue',
      '2': '.healthcare.quality.v1.RecordIndicatorValueRequest',
      '3': '.healthcare.quality.v1.RecordIndicatorValueResponse'
    },
    {
      '1': 'GetDashboard',
      '2': '.healthcare.quality.v1.GetDashboardRequest',
      '3': '.healthcare.quality.v1.GetDashboardResponse'
    },
    {
      '1': 'ListIndicatorValues',
      '2': '.healthcare.quality.v1.ListIndicatorValuesRequest',
      '3': '.healthcare.quality.v1.ListIndicatorValuesResponse'
    },
    {
      '1': 'ReceiveComplaint',
      '2': '.healthcare.quality.v1.ReceiveComplaintRequest',
      '3': '.healthcare.quality.v1.ReceiveComplaintResponse'
    },
    {
      '1': 'AcknowledgeComplaint',
      '2': '.healthcare.quality.v1.AcknowledgeComplaintRequest',
      '3': '.healthcare.quality.v1.AcknowledgeComplaintResponse'
    },
    {
      '1': 'ResolveComplaint',
      '2': '.healthcare.quality.v1.ResolveComplaintRequest',
      '3': '.healthcare.quality.v1.ResolveComplaintResponse'
    },
    {
      '1': 'CloseComplaint',
      '2': '.healthcare.quality.v1.CloseComplaintRequest',
      '3': '.healthcare.quality.v1.CloseComplaintResponse'
    },
    {
      '1': 'GetComplaint',
      '2': '.healthcare.quality.v1.GetComplaintRequest',
      '3': '.healthcare.quality.v1.GetComplaintResponse'
    },
    {
      '1': 'ListComplaints',
      '2': '.healthcare.quality.v1.ListComplaintsRequest',
      '3': '.healthcare.quality.v1.ListComplaintsResponse'
    },
    {
      '1': 'ListComplaintBreaches',
      '2': '.healthcare.quality.v1.ListComplaintBreachesRequest',
      '3': '.healthcare.quality.v1.ListComplaintBreachesResponse'
    },
    {
      '1': 'EscalateComplaintBreaches',
      '2': '.healthcare.quality.v1.EscalateComplaintBreachesRequest',
      '3': '.healthcare.quality.v1.EscalateComplaintBreachesResponse'
    },
    {
      '1': 'StartMortalityReview',
      '2': '.healthcare.quality.v1.StartMortalityReviewRequest',
      '3': '.healthcare.quality.v1.StartMortalityReviewResponse'
    },
    {
      '1': 'CompleteMortalityReview',
      '2': '.healthcare.quality.v1.CompleteMortalityReviewRequest',
      '3': '.healthcare.quality.v1.CompleteMortalityReviewResponse'
    },
    {
      '1': 'GetMortalityReview',
      '2': '.healthcare.quality.v1.GetMortalityReviewRequest',
      '3': '.healthcare.quality.v1.GetMortalityReviewResponse'
    },
    {
      '1': 'ListMortalityReviews',
      '2': '.healthcare.quality.v1.ListMortalityReviewsRequest',
      '3': '.healthcare.quality.v1.ListMortalityReviewsResponse'
    },
    {
      '1': 'PlaceHold',
      '2': '.healthcare.quality.v1.PlaceHoldRequest',
      '3': '.healthcare.quality.v1.PlaceHoldResponse'
    },
    {
      '1': 'ReleaseHold',
      '2': '.healthcare.quality.v1.ReleaseHoldRequest',
      '3': '.healthcare.quality.v1.ReleaseHoldResponse'
    },
  ],
};

@$core.Deprecated('Use qualityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    QualityServiceBase$messageJson = {
  '.healthcare.quality.v1.ReportIncidentRequest': ReportIncidentRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.quality.v1.ReportIncidentResponse': ReportIncidentResponse$json,
  '.healthcare.quality.v1.Incident': Incident$json,
  '.healthcare.quality.v1.Risk': Risk$json,
  '.healthcare.quality.v1.GetIncidentRequest': GetIncidentRequest$json,
  '.healthcare.quality.v1.GetIncidentResponse': GetIncidentResponse$json,
  '.healthcare.quality.v1.ListIncidentsRequest': ListIncidentsRequest$json,
  '.healthcare.quality.v1.ListIncidentsResponse': ListIncidentsResponse$json,
  '.healthcare.quality.v1.RescoreIncidentRequest': RescoreIncidentRequest$json,
  '.healthcare.quality.v1.RescoreIncidentResponse':
      RescoreIncidentResponse$json,
  '.healthcare.quality.v1.AdvanceIncidentRequest': AdvanceIncidentRequest$json,
  '.healthcare.quality.v1.AdvanceIncidentResponse':
      AdvanceIncidentResponse$json,
  '.healthcare.quality.v1.SetIncidentRestrictionRequest':
      SetIncidentRestrictionRequest$json,
  '.healthcare.quality.v1.SetIncidentRestrictionResponse':
      SetIncidentRestrictionResponse$json,
  '.healthcare.quality.v1.GetTrendsRequest': GetTrendsRequest$json,
  '.healthcare.quality.v1.GetTrendsResponse': GetTrendsResponse$json,
  '.healthcare.quality.v1.Trend': Trend$json,
  '.healthcare.quality.v1.StartRcaRequest': StartRcaRequest$json,
  '.healthcare.quality.v1.StartRcaResponse': StartRcaResponse$json,
  '.healthcare.quality.v1.RootCauseAnalysis': RootCauseAnalysis$json,
  '.healthcare.quality.v1.ContributingFactor': ContributingFactor$json,
  '.healthcare.quality.v1.AddFactorRequest': AddFactorRequest$json,
  '.healthcare.quality.v1.AddFactorResponse': AddFactorResponse$json,
  '.healthcare.quality.v1.CompleteRcaRequest': CompleteRcaRequest$json,
  '.healthcare.quality.v1.CompleteRcaResponse': CompleteRcaResponse$json,
  '.healthcare.quality.v1.GetRcaRequest': GetRcaRequest$json,
  '.healthcare.quality.v1.GetRcaResponse': GetRcaResponse$json,
  '.healthcare.quality.v1.RaiseActionRequest': RaiseActionRequest$json,
  '.healthcare.quality.v1.RaiseActionResponse': RaiseActionResponse$json,
  '.healthcare.quality.v1.CorrectiveAction': CorrectiveAction$json,
  '.healthcare.quality.v1.EffectivenessCheck': EffectivenessCheck$json,
  '.healthcare.quality.v1.ApproveActionRequest': ApproveActionRequest$json,
  '.healthcare.quality.v1.ApproveActionResponse': ApproveActionResponse$json,
  '.healthcare.quality.v1.AdvanceActionRequest': AdvanceActionRequest$json,
  '.healthcare.quality.v1.AdvanceActionResponse': AdvanceActionResponse$json,
  '.healthcare.quality.v1.RecordEffectivenessRequest':
      RecordEffectivenessRequest$json,
  '.healthcare.quality.v1.RecordEffectivenessResponse':
      RecordEffectivenessResponse$json,
  '.healthcare.quality.v1.CloseActionRequest': CloseActionRequest$json,
  '.healthcare.quality.v1.CloseActionResponse': CloseActionResponse$json,
  '.healthcare.quality.v1.GetActionRequest': GetActionRequest$json,
  '.healthcare.quality.v1.GetActionResponse': GetActionResponse$json,
  '.healthcare.quality.v1.ListActionsRequest': ListActionsRequest$json,
  '.healthcare.quality.v1.ListActionsResponse': ListActionsResponse$json,
  '.healthcare.quality.v1.ListOverdueActionsRequest':
      ListOverdueActionsRequest$json,
  '.healthcare.quality.v1.ListOverdueActionsResponse':
      ListOverdueActionsResponse$json,
  '.healthcare.quality.v1.OverdueAction': OverdueAction$json,
  '.healthcare.quality.v1.EscalateOverdueActionsRequest':
      EscalateOverdueActionsRequest$json,
  '.healthcare.quality.v1.EscalateOverdueActionsResponse':
      EscalateOverdueActionsResponse$json,
  '.healthcare.quality.v1.RegisterDocumentRequest':
      RegisterDocumentRequest$json,
  '.healthcare.quality.v1.RegisterDocumentResponse':
      RegisterDocumentResponse$json,
  '.healthcare.quality.v1.ControlledDocument': ControlledDocument$json,
  '.healthcare.quality.v1.DraftVersionRequest': DraftVersionRequest$json,
  '.healthcare.quality.v1.DraftVersionResponse': DraftVersionResponse$json,
  '.healthcare.quality.v1.DocumentVersion': DocumentVersion$json,
  '.healthcare.quality.v1.ApproveVersionRequest': ApproveVersionRequest$json,
  '.healthcare.quality.v1.ApproveVersionResponse': ApproveVersionResponse$json,
  '.healthcare.quality.v1.GetCurrentVersionRequest':
      GetCurrentVersionRequest$json,
  '.healthcare.quality.v1.GetCurrentVersionResponse':
      GetCurrentVersionResponse$json,
  '.healthcare.quality.v1.ListVersionsRequest': ListVersionsRequest$json,
  '.healthcare.quality.v1.ListVersionsResponse': ListVersionsResponse$json,
  '.healthcare.quality.v1.ListDocumentsRequest': ListDocumentsRequest$json,
  '.healthcare.quality.v1.ListDocumentsResponse': ListDocumentsResponse$json,
  '.healthcare.quality.v1.AcknowledgeDocumentRequest':
      AcknowledgeDocumentRequest$json,
  '.healthcare.quality.v1.AcknowledgeDocumentResponse':
      AcknowledgeDocumentResponse$json,
  '.healthcare.quality.v1.ListOutstandingAcknowledgementsRequest':
      ListOutstandingAcknowledgementsRequest$json,
  '.healthcare.quality.v1.ListOutstandingAcknowledgementsResponse':
      ListOutstandingAcknowledgementsResponse$json,
  '.healthcare.quality.v1.AcknowledgementGap': AcknowledgementGap$json,
  '.healthcare.quality.v1.ListReviewsDueRequest': ListReviewsDueRequest$json,
  '.healthcare.quality.v1.ListReviewsDueResponse': ListReviewsDueResponse$json,
  '.healthcare.quality.v1.ReviewDue': ReviewDue$json,
  '.healthcare.quality.v1.DefineCompetencyRequest':
      DefineCompetencyRequest$json,
  '.healthcare.quality.v1.DefineCompetencyResponse':
      DefineCompetencyResponse$json,
  '.healthcare.quality.v1.Competency': Competency$json,
  '.healthcare.quality.v1.RequireCompetencyRequest':
      RequireCompetencyRequest$json,
  '.healthcare.quality.v1.RequireCompetencyResponse':
      RequireCompetencyResponse$json,
  '.healthcare.quality.v1.AwardCompetencyRequest': AwardCompetencyRequest$json,
  '.healthcare.quality.v1.AwardCompetencyResponse':
      AwardCompetencyResponse$json,
  '.healthcare.quality.v1.ListCompetencyGapsRequest':
      ListCompetencyGapsRequest$json,
  '.healthcare.quality.v1.ListCompetencyGapsResponse':
      ListCompetencyGapsResponse$json,
  '.healthcare.quality.v1.CompetencyGap': CompetencyGap$json,
  '.healthcare.quality.v1.PlanAuditRequest': PlanAuditRequest$json,
  '.healthcare.quality.v1.PlanAuditResponse': PlanAuditResponse$json,
  '.healthcare.quality.v1.Audit': Audit$json,
  '.healthcare.quality.v1.RecordFindingRequest': RecordFindingRequest$json,
  '.healthcare.quality.v1.RecordFindingResponse': RecordFindingResponse$json,
  '.healthcare.quality.v1.Finding': Finding$json,
  '.healthcare.quality.v1.LinkFindingActionRequest':
      LinkFindingActionRequest$json,
  '.healthcare.quality.v1.LinkFindingActionResponse':
      LinkFindingActionResponse$json,
  '.healthcare.quality.v1.CloseFindingRequest': CloseFindingRequest$json,
  '.healthcare.quality.v1.CloseFindingResponse': CloseFindingResponse$json,
  '.healthcare.quality.v1.ReportAuditRequest': ReportAuditRequest$json,
  '.healthcare.quality.v1.ReportAuditResponse': ReportAuditResponse$json,
  '.healthcare.quality.v1.CloseAuditRequest': CloseAuditRequest$json,
  '.healthcare.quality.v1.CloseAuditResponse': CloseAuditResponse$json,
  '.healthcare.quality.v1.GetAuditRequest': GetAuditRequest$json,
  '.healthcare.quality.v1.GetAuditResponse': GetAuditResponse$json,
  '.healthcare.quality.v1.ListAuditsRequest': ListAuditsRequest$json,
  '.healthcare.quality.v1.ListAuditsResponse': ListAuditsResponse$json,
  '.healthcare.quality.v1.ListFindingsRequest': ListFindingsRequest$json,
  '.healthcare.quality.v1.ListFindingsResponse': ListFindingsResponse$json,
  '.healthcare.quality.v1.FormCommitteeRequest': FormCommitteeRequest$json,
  '.healthcare.quality.v1.FormCommitteeResponse': FormCommitteeResponse$json,
  '.healthcare.quality.v1.Committee': Committee$json,
  '.healthcare.quality.v1.ScheduleMeetingRequest': ScheduleMeetingRequest$json,
  '.healthcare.quality.v1.ScheduleMeetingResponse':
      ScheduleMeetingResponse$json,
  '.healthcare.quality.v1.Meeting': Meeting$json,
  '.healthcare.quality.v1.Decision': Decision$json,
  '.healthcare.quality.v1.RecordMinutesRequest': RecordMinutesRequest$json,
  '.healthcare.quality.v1.RecordMinutesResponse': RecordMinutesResponse$json,
  '.healthcare.quality.v1.GetMeetingRequest': GetMeetingRequest$json,
  '.healthcare.quality.v1.GetMeetingResponse': GetMeetingResponse$json,
  '.healthcare.quality.v1.ListCommitteesRequest': ListCommitteesRequest$json,
  '.healthcare.quality.v1.ListCommitteesResponse': ListCommitteesResponse$json,
  '.healthcare.quality.v1.LoadStandardRequest': LoadStandardRequest$json,
  '.healthcare.quality.v1.ClauseInput': ClauseInput$json,
  '.healthcare.quality.v1.LoadStandardResponse': LoadStandardResponse$json,
  '.healthcare.quality.v1.Standard': Standard$json,
  '.healthcare.quality.v1.FileEvidenceRequest': FileEvidenceRequest$json,
  '.healthcare.quality.v1.FileEvidenceResponse': FileEvidenceResponse$json,
  '.healthcare.quality.v1.Evidence': Evidence$json,
  '.healthcare.quality.v1.WithdrawEvidenceRequest':
      WithdrawEvidenceRequest$json,
  '.healthcare.quality.v1.WithdrawEvidenceResponse':
      WithdrawEvidenceResponse$json,
  '.healthcare.quality.v1.ReviewClauseRequest': ReviewClauseRequest$json,
  '.healthcare.quality.v1.ReviewClauseResponse': ReviewClauseResponse$json,
  '.healthcare.quality.v1.GetReadinessRequest': GetReadinessRequest$json,
  '.healthcare.quality.v1.GetReadinessResponse': GetReadinessResponse$json,
  '.healthcare.quality.v1.ClauseStatus': ClauseStatus$json,
  '.healthcare.quality.v1.ListStandardsRequest': ListStandardsRequest$json,
  '.healthcare.quality.v1.ListStandardsResponse': ListStandardsResponse$json,
  '.healthcare.quality.v1.ListClausesRequest': ListClausesRequest$json,
  '.healthcare.quality.v1.ListClausesResponse': ListClausesResponse$json,
  '.healthcare.quality.v1.Clause': Clause$json,
  '.healthcare.quality.v1.DefineIndicatorRequest': DefineIndicatorRequest$json,
  '.healthcare.quality.v1.DefineIndicatorResponse':
      DefineIndicatorResponse$json,
  '.healthcare.quality.v1.IndicatorDefinition': IndicatorDefinition$json,
  '.healthcare.quality.v1.RecordIndicatorValueRequest':
      RecordIndicatorValueRequest$json,
  '.healthcare.quality.v1.RecordIndicatorValueResponse':
      RecordIndicatorValueResponse$json,
  '.healthcare.quality.v1.IndicatorValue': IndicatorValue$json,
  '.healthcare.quality.v1.GetDashboardRequest': GetDashboardRequest$json,
  '.healthcare.quality.v1.GetDashboardResponse': GetDashboardResponse$json,
  '.healthcare.quality.v1.IndicatorLine': IndicatorLine$json,
  '.healthcare.quality.v1.ListIndicatorValuesRequest':
      ListIndicatorValuesRequest$json,
  '.healthcare.quality.v1.ListIndicatorValuesResponse':
      ListIndicatorValuesResponse$json,
  '.healthcare.quality.v1.ReceiveComplaintRequest':
      ReceiveComplaintRequest$json,
  '.healthcare.quality.v1.ReceiveComplaintResponse':
      ReceiveComplaintResponse$json,
  '.healthcare.quality.v1.Complaint': Complaint$json,
  '.healthcare.quality.v1.AcknowledgeComplaintRequest':
      AcknowledgeComplaintRequest$json,
  '.healthcare.quality.v1.AcknowledgeComplaintResponse':
      AcknowledgeComplaintResponse$json,
  '.healthcare.quality.v1.ResolveComplaintRequest':
      ResolveComplaintRequest$json,
  '.healthcare.quality.v1.ResolveComplaintResponse':
      ResolveComplaintResponse$json,
  '.healthcare.quality.v1.CloseComplaintRequest': CloseComplaintRequest$json,
  '.healthcare.quality.v1.CloseComplaintResponse': CloseComplaintResponse$json,
  '.healthcare.quality.v1.GetComplaintRequest': GetComplaintRequest$json,
  '.healthcare.quality.v1.GetComplaintResponse': GetComplaintResponse$json,
  '.healthcare.quality.v1.ListComplaintsRequest': ListComplaintsRequest$json,
  '.healthcare.quality.v1.ListComplaintsResponse': ListComplaintsResponse$json,
  '.healthcare.quality.v1.ListComplaintBreachesRequest':
      ListComplaintBreachesRequest$json,
  '.healthcare.quality.v1.ListComplaintBreachesResponse':
      ListComplaintBreachesResponse$json,
  '.healthcare.quality.v1.ComplaintBreach': ComplaintBreach$json,
  '.healthcare.quality.v1.EscalateComplaintBreachesRequest':
      EscalateComplaintBreachesRequest$json,
  '.healthcare.quality.v1.EscalateComplaintBreachesResponse':
      EscalateComplaintBreachesResponse$json,
  '.healthcare.quality.v1.StartMortalityReviewRequest':
      StartMortalityReviewRequest$json,
  '.healthcare.quality.v1.StartMortalityReviewResponse':
      StartMortalityReviewResponse$json,
  '.healthcare.quality.v1.MortalityReview': MortalityReview$json,
  '.healthcare.quality.v1.CompleteMortalityReviewRequest':
      CompleteMortalityReviewRequest$json,
  '.healthcare.quality.v1.CompleteMortalityReviewResponse':
      CompleteMortalityReviewResponse$json,
  '.healthcare.quality.v1.GetMortalityReviewRequest':
      GetMortalityReviewRequest$json,
  '.healthcare.quality.v1.GetMortalityReviewResponse':
      GetMortalityReviewResponse$json,
  '.healthcare.quality.v1.ListMortalityReviewsRequest':
      ListMortalityReviewsRequest$json,
  '.healthcare.quality.v1.ListMortalityReviewsResponse':
      ListMortalityReviewsResponse$json,
  '.healthcare.quality.v1.PlaceHoldRequest': PlaceHoldRequest$json,
  '.healthcare.quality.v1.PlaceHoldResponse': PlaceHoldResponse$json,
  '.healthcare.quality.v1.ReleaseHoldRequest': ReleaseHoldRequest$json,
  '.healthcare.quality.v1.ReleaseHoldResponse': ReleaseHoldResponse$json,
};

/// Descriptor for `QualityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List qualityServiceDescriptor = $convert.base64Decode(
    'Cg5RdWFsaXR5U2VydmljZRJtCg5SZXBvcnRJbmNpZGVudBIsLmhlYWx0aGNhcmUucXVhbGl0eS'
    '52MS5SZXBvcnRJbmNpZGVudFJlcXVlc3QaLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmVwb3J0'
    'SW5jaWRlbnRSZXNwb25zZRJkCgtHZXRJbmNpZGVudBIpLmhlYWx0aGNhcmUucXVhbGl0eS52MS'
    '5HZXRJbmNpZGVudFJlcXVlc3QaKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0SW5jaWRlbnRS'
    'ZXNwb25zZRJqCg1MaXN0SW5jaWRlbnRzEisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RJbm'
    'NpZGVudHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RJbmNpZGVudHNSZXNw'
    'b25zZRJwCg9SZXNjb3JlSW5jaWRlbnQSLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmVzY29yZU'
    'luY2lkZW50UmVxdWVzdBouLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZXNjb3JlSW5jaWRlbnRS'
    'ZXNwb25zZRJwCg9BZHZhbmNlSW5jaWRlbnQSLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQWR2YW'
    '5jZUluY2lkZW50UmVxdWVzdBouLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BZHZhbmNlSW5jaWRl'
    'bnRSZXNwb25zZRKFAQoWU2V0SW5jaWRlbnRSZXN0cmljdGlvbhI0LmhlYWx0aGNhcmUucXVhbG'
    'l0eS52MS5TZXRJbmNpZGVudFJlc3RyaWN0aW9uUmVxdWVzdBo1LmhlYWx0aGNhcmUucXVhbGl0'
    'eS52MS5TZXRJbmNpZGVudFJlc3RyaWN0aW9uUmVzcG9uc2USXgoJR2V0VHJlbmRzEicuaGVhbH'
    'RoY2FyZS5xdWFsaXR5LnYxLkdldFRyZW5kc1JlcXVlc3QaKC5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuR2V0VHJlbmRzUmVzcG9uc2USWwoIU3RhcnRSY2ESJi5oZWFsdGhjYXJlLnF1YWxpdHkudj'
    'EuU3RhcnRSY2FSZXF1ZXN0GicuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlN0YXJ0UmNhUmVzcG9u'
    'c2USXgoJQWRkRmFjdG9yEicuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkFkZEZhY3RvclJlcXVlc3'
    'QaKC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQWRkRmFjdG9yUmVzcG9uc2USZAoLQ29tcGxldGVS'
    'Y2ESKS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQ29tcGxldGVSY2FSZXF1ZXN0GiouaGVhbHRoY2'
    'FyZS5xdWFsaXR5LnYxLkNvbXBsZXRlUmNhUmVzcG9uc2USVQoGR2V0UmNhEiQuaGVhbHRoY2Fy'
    'ZS5xdWFsaXR5LnYxLkdldFJjYVJlcXVlc3QaJS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0Um'
    'NhUmVzcG9uc2USZAoLUmFpc2VBY3Rpb24SKS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmFpc2VB'
    'Y3Rpb25SZXF1ZXN0GiouaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlJhaXNlQWN0aW9uUmVzcG9uc2'
    'USagoNQXBwcm92ZUFjdGlvbhIrLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BcHByb3ZlQWN0aW9u'
    'UmVxdWVzdBosLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BcHByb3ZlQWN0aW9uUmVzcG9uc2USag'
    'oNQWR2YW5jZUFjdGlvbhIrLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BZHZhbmNlQWN0aW9uUmVx'
    'dWVzdBosLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BZHZhbmNlQWN0aW9uUmVzcG9uc2USfAoTUm'
    'Vjb3JkRWZmZWN0aXZlbmVzcxIxLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZWNvcmRFZmZlY3Rp'
    'dmVuZXNzUmVxdWVzdBoyLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZWNvcmRFZmZlY3RpdmVuZX'
    'NzUmVzcG9uc2USZAoLQ2xvc2VBY3Rpb24SKS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQ2xvc2VB'
    'Y3Rpb25SZXF1ZXN0GiouaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkNsb3NlQWN0aW9uUmVzcG9uc2'
    'USXgoJR2V0QWN0aW9uEicuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkdldEFjdGlvblJlcXVlc3Qa'
    'KC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0QWN0aW9uUmVzcG9uc2USZAoLTGlzdEFjdGlvbn'
    'MSKS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdEFjdGlvbnNSZXF1ZXN0GiouaGVhbHRoY2Fy'
    'ZS5xdWFsaXR5LnYxLkxpc3RBY3Rpb25zUmVzcG9uc2USeQoSTGlzdE92ZXJkdWVBY3Rpb25zEj'
    'AuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RPdmVyZHVlQWN0aW9uc1JlcXVlc3QaMS5oZWFs'
    'dGhjYXJlLnF1YWxpdHkudjEuTGlzdE92ZXJkdWVBY3Rpb25zUmVzcG9uc2UShQEKFkVzY2FsYX'
    'RlT3ZlcmR1ZUFjdGlvbnMSNC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuRXNjYWxhdGVPdmVyZHVl'
    'QWN0aW9uc1JlcXVlc3QaNS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuRXNjYWxhdGVPdmVyZHVlQW'
    'N0aW9uc1Jlc3BvbnNlEnMKEFJlZ2lzdGVyRG9jdW1lbnQSLi5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuUmVnaXN0ZXJEb2N1bWVudFJlcXVlc3QaLy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmVnaX'
    'N0ZXJEb2N1bWVudFJlc3BvbnNlEmcKDERyYWZ0VmVyc2lvbhIqLmhlYWx0aGNhcmUucXVhbGl0'
    'eS52MS5EcmFmdFZlcnNpb25SZXF1ZXN0GisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkRyYWZ0Vm'
    'Vyc2lvblJlc3BvbnNlEm0KDkFwcHJvdmVWZXJzaW9uEiwuaGVhbHRoY2FyZS5xdWFsaXR5LnYx'
    'LkFwcHJvdmVWZXJzaW9uUmVxdWVzdBotLmhlYWx0aGNhcmUucXVhbGl0eS52MS5BcHByb3ZlVm'
    'Vyc2lvblJlc3BvbnNlEnYKEUdldEN1cnJlbnRWZXJzaW9uEi8uaGVhbHRoY2FyZS5xdWFsaXR5'
    'LnYxLkdldEN1cnJlbnRWZXJzaW9uUmVxdWVzdBowLmhlYWx0aGNhcmUucXVhbGl0eS52MS5HZX'
    'RDdXJyZW50VmVyc2lvblJlc3BvbnNlEmcKDExpc3RWZXJzaW9ucxIqLmhlYWx0aGNhcmUucXVh'
    'bGl0eS52MS5MaXN0VmVyc2lvbnNSZXF1ZXN0GisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3'
    'RWZXJzaW9uc1Jlc3BvbnNlEmoKDUxpc3REb2N1bWVudHMSKy5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuTGlzdERvY3VtZW50c1JlcXVlc3QaLC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdERvY3'
    'VtZW50c1Jlc3BvbnNlEnwKE0Fja25vd2xlZGdlRG9jdW1lbnQSMS5oZWFsdGhjYXJlLnF1YWxp'
    'dHkudjEuQWNrbm93bGVkZ2VEb2N1bWVudFJlcXVlc3QaMi5oZWFsdGhjYXJlLnF1YWxpdHkudj'
    'EuQWNrbm93bGVkZ2VEb2N1bWVudFJlc3BvbnNlEqABCh9MaXN0T3V0c3RhbmRpbmdBY2tub3ds'
    'ZWRnZW1lbnRzEj0uaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RPdXRzdGFuZGluZ0Fja25vd2'
    'xlZGdlbWVudHNSZXF1ZXN0Gj4uaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RPdXRzdGFuZGlu'
    'Z0Fja25vd2xlZGdlbWVudHNSZXNwb25zZRJtCg5MaXN0UmV2aWV3c0R1ZRIsLmhlYWx0aGNhcm'
    'UucXVhbGl0eS52MS5MaXN0UmV2aWV3c0R1ZVJlcXVlc3QaLS5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuTGlzdFJldmlld3NEdWVSZXNwb25zZRJzChBEZWZpbmVDb21wZXRlbmN5Ei4uaGVhbHRoY2'
    'FyZS5xdWFsaXR5LnYxLkRlZmluZUNvbXBldGVuY3lSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5xdWFs'
    'aXR5LnYxLkRlZmluZUNvbXBldGVuY3lSZXNwb25zZRJ2ChFSZXF1aXJlQ29tcGV0ZW5jeRIvLm'
    'hlYWx0aGNhcmUucXVhbGl0eS52MS5SZXF1aXJlQ29tcGV0ZW5jeVJlcXVlc3QaMC5oZWFsdGhj'
    'YXJlLnF1YWxpdHkudjEuUmVxdWlyZUNvbXBldGVuY3lSZXNwb25zZRJwCg9Bd2FyZENvbXBldG'
    'VuY3kSLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQXdhcmRDb21wZXRlbmN5UmVxdWVzdBouLmhl'
    'YWx0aGNhcmUucXVhbGl0eS52MS5Bd2FyZENvbXBldGVuY3lSZXNwb25zZRJ5ChJMaXN0Q29tcG'
    'V0ZW5jeUdhcHMSMC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdENvbXBldGVuY3lHYXBzUmVx'
    'dWVzdBoxLmhlYWx0aGNhcmUucXVhbGl0eS52MS5MaXN0Q29tcGV0ZW5jeUdhcHNSZXNwb25zZR'
    'JeCglQbGFuQXVkaXQSJy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUGxhbkF1ZGl0UmVxdWVzdBoo'
    'LmhlYWx0aGNhcmUucXVhbGl0eS52MS5QbGFuQXVkaXRSZXNwb25zZRJqCg1SZWNvcmRGaW5kaW'
    '5nEisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlJlY29yZEZpbmRpbmdSZXF1ZXN0GiwuaGVhbHRo'
    'Y2FyZS5xdWFsaXR5LnYxLlJlY29yZEZpbmRpbmdSZXNwb25zZRJ2ChFMaW5rRmluZGluZ0FjdG'
    'lvbhIvLmhlYWx0aGNhcmUucXVhbGl0eS52MS5MaW5rRmluZGluZ0FjdGlvblJlcXVlc3QaMC5o'
    'ZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlua0ZpbmRpbmdBY3Rpb25SZXNwb25zZRJnCgxDbG9zZU'
    'ZpbmRpbmcSKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQ2xvc2VGaW5kaW5nUmVxdWVzdBorLmhl'
    'YWx0aGNhcmUucXVhbGl0eS52MS5DbG9zZUZpbmRpbmdSZXNwb25zZRJkCgtSZXBvcnRBdWRpdB'
    'IpLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZXBvcnRBdWRpdFJlcXVlc3QaKi5oZWFsdGhjYXJl'
    'LnF1YWxpdHkudjEuUmVwb3J0QXVkaXRSZXNwb25zZRJhCgpDbG9zZUF1ZGl0EiguaGVhbHRoY2'
    'FyZS5xdWFsaXR5LnYxLkNsb3NlQXVkaXRSZXF1ZXN0GikuaGVhbHRoY2FyZS5xdWFsaXR5LnYx'
    'LkNsb3NlQXVkaXRSZXNwb25zZRJbCghHZXRBdWRpdBImLmhlYWx0aGNhcmUucXVhbGl0eS52MS'
    '5HZXRBdWRpdFJlcXVlc3QaJy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0QXVkaXRSZXNwb25z'
    'ZRJhCgpMaXN0QXVkaXRzEiguaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RBdWRpdHNSZXF1ZX'
    'N0GikuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RBdWRpdHNSZXNwb25zZRJnCgxMaXN0Rmlu'
    'ZGluZ3MSKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdEZpbmRpbmdzUmVxdWVzdBorLmhlYW'
    'x0aGNhcmUucXVhbGl0eS52MS5MaXN0RmluZGluZ3NSZXNwb25zZRJqCg1Gb3JtQ29tbWl0dGVl'
    'EisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkZvcm1Db21taXR0ZWVSZXF1ZXN0GiwuaGVhbHRoY2'
    'FyZS5xdWFsaXR5LnYxLkZvcm1Db21taXR0ZWVSZXNwb25zZRJwCg9TY2hlZHVsZU1lZXRpbmcS'
    'LS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuU2NoZWR1bGVNZWV0aW5nUmVxdWVzdBouLmhlYWx0aG'
    'NhcmUucXVhbGl0eS52MS5TY2hlZHVsZU1lZXRpbmdSZXNwb25zZRJqCg1SZWNvcmRNaW51dGVz'
    'EisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlJlY29yZE1pbnV0ZXNSZXF1ZXN0GiwuaGVhbHRoY2'
    'FyZS5xdWFsaXR5LnYxLlJlY29yZE1pbnV0ZXNSZXNwb25zZRJhCgpHZXRNZWV0aW5nEiguaGVh'
    'bHRoY2FyZS5xdWFsaXR5LnYxLkdldE1lZXRpbmdSZXF1ZXN0GikuaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLkdldE1lZXRpbmdSZXNwb25zZRJtCg5MaXN0Q29tbWl0dGVlcxIsLmhlYWx0aGNhcmUu'
    'cXVhbGl0eS52MS5MaXN0Q29tbWl0dGVlc1JlcXVlc3QaLS5oZWFsdGhjYXJlLnF1YWxpdHkudj'
    'EuTGlzdENvbW1pdHRlZXNSZXNwb25zZRJnCgxMb2FkU3RhbmRhcmQSKi5oZWFsdGhjYXJlLnF1'
    'YWxpdHkudjEuTG9hZFN0YW5kYXJkUmVxdWVzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5Mb2'
    'FkU3RhbmRhcmRSZXNwb25zZRJnCgxGaWxlRXZpZGVuY2USKi5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuRmlsZUV2aWRlbmNlUmVxdWVzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5GaWxlRXZpZG'
    'VuY2VSZXNwb25zZRJzChBXaXRoZHJhd0V2aWRlbmNlEi4uaGVhbHRoY2FyZS5xdWFsaXR5LnYx'
    'LldpdGhkcmF3RXZpZGVuY2VSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5xdWFsaXR5LnYxLldpdGhkcm'
    'F3RXZpZGVuY2VSZXNwb25zZRJnCgxSZXZpZXdDbGF1c2USKi5oZWFsdGhjYXJlLnF1YWxpdHku'
    'djEuUmV2aWV3Q2xhdXNlUmVxdWVzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZXZpZXdDbG'
    'F1c2VSZXNwb25zZRJnCgxHZXRSZWFkaW5lc3MSKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0'
    'UmVhZGluZXNzUmVxdWVzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5HZXRSZWFkaW5lc3NSZX'
    'Nwb25zZRJqCg1MaXN0U3RhbmRhcmRzEisuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RTdGFu'
    'ZGFyZHNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RTdGFuZGFyZHNSZXNwb2'
    '5zZRJkCgtMaXN0Q2xhdXNlcxIpLmhlYWx0aGNhcmUucXVhbGl0eS52MS5MaXN0Q2xhdXNlc1Jl'
    'cXVlc3QaKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdENsYXVzZXNSZXNwb25zZRJwCg9EZW'
    'ZpbmVJbmRpY2F0b3ISLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuRGVmaW5lSW5kaWNhdG9yUmVx'
    'dWVzdBouLmhlYWx0aGNhcmUucXVhbGl0eS52MS5EZWZpbmVJbmRpY2F0b3JSZXNwb25zZRJ/Ch'
    'RSZWNvcmRJbmRpY2F0b3JWYWx1ZRIyLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZWNvcmRJbmRp'
    'Y2F0b3JWYWx1ZVJlcXVlc3QaMy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmVjb3JkSW5kaWNhdG'
    '9yVmFsdWVSZXNwb25zZRJnCgxHZXREYXNoYm9hcmQSKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEu'
    'R2V0RGFzaGJvYXJkUmVxdWVzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5HZXREYXNoYm9hcm'
    'RSZXNwb25zZRJ8ChNMaXN0SW5kaWNhdG9yVmFsdWVzEjEuaGVhbHRoY2FyZS5xdWFsaXR5LnYx'
    'Lkxpc3RJbmRpY2F0b3JWYWx1ZXNSZXF1ZXN0GjIuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3'
    'RJbmRpY2F0b3JWYWx1ZXNSZXNwb25zZRJzChBSZWNlaXZlQ29tcGxhaW50Ei4uaGVhbHRoY2Fy'
    'ZS5xdWFsaXR5LnYxLlJlY2VpdmVDb21wbGFpbnRSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5xdWFsaX'
    'R5LnYxLlJlY2VpdmVDb21wbGFpbnRSZXNwb25zZRJ/ChRBY2tub3dsZWRnZUNvbXBsYWludBIy'
    'LmhlYWx0aGNhcmUucXVhbGl0eS52MS5BY2tub3dsZWRnZUNvbXBsYWludFJlcXVlc3QaMy5oZW'
    'FsdGhjYXJlLnF1YWxpdHkudjEuQWNrbm93bGVkZ2VDb21wbGFpbnRSZXNwb25zZRJzChBSZXNv'
    'bHZlQ29tcGxhaW50Ei4uaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlJlc29sdmVDb21wbGFpbnRSZX'
    'F1ZXN0Gi8uaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlJlc29sdmVDb21wbGFpbnRSZXNwb25zZRJt'
    'Cg5DbG9zZUNvbXBsYWludBIsLmhlYWx0aGNhcmUucXVhbGl0eS52MS5DbG9zZUNvbXBsYWludF'
    'JlcXVlc3QaLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuQ2xvc2VDb21wbGFpbnRSZXNwb25zZRJn'
    'CgxHZXRDb21wbGFpbnQSKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0Q29tcGxhaW50UmVxdW'
    'VzdBorLmhlYWx0aGNhcmUucXVhbGl0eS52MS5HZXRDb21wbGFpbnRSZXNwb25zZRJtCg5MaXN0'
    'Q29tcGxhaW50cxIsLmhlYWx0aGNhcmUucXVhbGl0eS52MS5MaXN0Q29tcGxhaW50c1JlcXVlc3'
    'QaLS5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdENvbXBsYWludHNSZXNwb25zZRKCAQoVTGlz'
    'dENvbXBsYWludEJyZWFjaGVzEjMuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLkxpc3RDb21wbGFpbn'
    'RCcmVhY2hlc1JlcXVlc3QaNC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdENvbXBsYWludEJy'
    'ZWFjaGVzUmVzcG9uc2USjgEKGUVzY2FsYXRlQ29tcGxhaW50QnJlYWNoZXMSNy5oZWFsdGhjYX'
    'JlLnF1YWxpdHkudjEuRXNjYWxhdGVDb21wbGFpbnRCcmVhY2hlc1JlcXVlc3QaOC5oZWFsdGhj'
    'YXJlLnF1YWxpdHkudjEuRXNjYWxhdGVDb21wbGFpbnRCcmVhY2hlc1Jlc3BvbnNlEn8KFFN0YX'
    'J0TW9ydGFsaXR5UmV2aWV3EjIuaGVhbHRoY2FyZS5xdWFsaXR5LnYxLlN0YXJ0TW9ydGFsaXR5'
    'UmV2aWV3UmVxdWVzdBozLmhlYWx0aGNhcmUucXVhbGl0eS52MS5TdGFydE1vcnRhbGl0eVJldm'
    'lld1Jlc3BvbnNlEogBChdDb21wbGV0ZU1vcnRhbGl0eVJldmlldxI1LmhlYWx0aGNhcmUucXVh'
    'bGl0eS52MS5Db21wbGV0ZU1vcnRhbGl0eVJldmlld1JlcXVlc3QaNi5oZWFsdGhjYXJlLnF1YW'
    'xpdHkudjEuQ29tcGxldGVNb3J0YWxpdHlSZXZpZXdSZXNwb25zZRJ5ChJHZXRNb3J0YWxpdHlS'
    'ZXZpZXcSMC5oZWFsdGhjYXJlLnF1YWxpdHkudjEuR2V0TW9ydGFsaXR5UmV2aWV3UmVxdWVzdB'
    'oxLmhlYWx0aGNhcmUucXVhbGl0eS52MS5HZXRNb3J0YWxpdHlSZXZpZXdSZXNwb25zZRJ/ChRM'
    'aXN0TW9ydGFsaXR5UmV2aWV3cxIyLmhlYWx0aGNhcmUucXVhbGl0eS52MS5MaXN0TW9ydGFsaX'
    'R5UmV2aWV3c1JlcXVlc3QaMy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuTGlzdE1vcnRhbGl0eVJl'
    'dmlld3NSZXNwb25zZRJeCglQbGFjZUhvbGQSJy5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUGxhY2'
    'VIb2xkUmVxdWVzdBooLmhlYWx0aGNhcmUucXVhbGl0eS52MS5QbGFjZUhvbGRSZXNwb25zZRJk'
    'CgtSZWxlYXNlSG9sZBIpLmhlYWx0aGNhcmUucXVhbGl0eS52MS5SZWxlYXNlSG9sZFJlcXVlc3'
    'QaKi5oZWFsdGhjYXJlLnF1YWxpdHkudjEuUmVsZWFzZUhvbGRSZXNwb25zZQ==');
