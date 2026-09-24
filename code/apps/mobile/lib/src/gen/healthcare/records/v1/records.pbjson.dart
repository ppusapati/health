// This is a generated file - do not edit.
//
// Generated from healthcare/records/v1/records.proto.

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

@$core.Deprecated('Use documentRequirementDescriptor instead')
const DocumentRequirement$json = {
  '1': 'DocumentRequirement',
  '2': [
    {'1': 'DOCUMENT_REQUIREMENT_UNSPECIFIED', '2': 0},
    {'1': 'DOCUMENT_REQUIREMENT_SIGNED', '2': 1},
    {'1': 'DOCUMENT_REQUIREMENT_PRESENT', '2': 2},
    {'1': 'DOCUMENT_REQUIREMENT_CONDITIONAL', '2': 3},
  ],
};

/// Descriptor for `DocumentRequirement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List documentRequirementDescriptor = $convert.base64Decode(
    'ChNEb2N1bWVudFJlcXVpcmVtZW50EiQKIERPQ1VNRU5UX1JFUVVJUkVNRU5UX1VOU1BFQ0lGSU'
    'VEEAASHwobRE9DVU1FTlRfUkVRVUlSRU1FTlRfU0lHTkVEEAESIAocRE9DVU1FTlRfUkVRVUlS'
    'RU1FTlRfUFJFU0VOVBACEiQKIERPQ1VNRU5UX1JFUVVJUkVNRU5UX0NPTkRJVElPTkFMEAM=');

@$core.Deprecated('Use deficiencyKindDescriptor instead')
const DeficiencyKind$json = {
  '1': 'DeficiencyKind',
  '2': [
    {'1': 'DEFICIENCY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DEFICIENCY_KIND_MISSING_DOCUMENT', '2': 1},
    {'1': 'DEFICIENCY_KIND_UNSIGNED_DOCUMENT', '2': 2},
    {'1': 'DEFICIENCY_KIND_INCOMPLETE_DOCUMENT', '2': 3},
    {'1': 'DEFICIENCY_KIND_CODING_QUERY', '2': 4},
  ],
};

/// Descriptor for `DeficiencyKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deficiencyKindDescriptor = $convert.base64Decode(
    'Cg5EZWZpY2llbmN5S2luZBIfChtERUZJQ0lFTkNZX0tJTkRfVU5TUEVDSUZJRUQQABIkCiBERU'
    'ZJQ0lFTkNZX0tJTkRfTUlTU0lOR19ET0NVTUVOVBABEiUKIURFRklDSUVOQ1lfS0lORF9VTlNJ'
    'R05FRF9ET0NVTUVOVBACEicKI0RFRklDSUVOQ1lfS0lORF9JTkNPTVBMRVRFX0RPQ1VNRU5UEA'
    'MSIAocREVGSUNJRU5DWV9LSU5EX0NPRElOR19RVUVSWRAE');

@$core.Deprecated('Use deficiencyStateDescriptor instead')
const DeficiencyState$json = {
  '1': 'DeficiencyState',
  '2': [
    {'1': 'DEFICIENCY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DEFICIENCY_STATE_OPEN', '2': 1},
    {'1': 'DEFICIENCY_STATE_RESOLVED', '2': 2},
    {'1': 'DEFICIENCY_STATE_WAIVED', '2': 3},
  ],
};

/// Descriptor for `DeficiencyState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deficiencyStateDescriptor = $convert.base64Decode(
    'Cg9EZWZpY2llbmN5U3RhdGUSIAocREVGSUNJRU5DWV9TVEFURV9VTlNQRUNJRklFRBAAEhkKFU'
    'RFRklDSUVOQ1lfU1RBVEVfT1BFThABEh0KGURFRklDSUVOQ1lfU1RBVEVfUkVTT0xWRUQQAhIb'
    'ChdERUZJQ0lFTkNZX1NUQVRFX1dBSVZFRBAD');

@$core.Deprecated('Use codeRoleDescriptor instead')
const CodeRole$json = {
  '1': 'CodeRole',
  '2': [
    {'1': 'CODE_ROLE_UNSPECIFIED', '2': 0},
    {'1': 'CODE_ROLE_PRINCIPAL_DIAGNOSIS', '2': 1},
    {'1': 'CODE_ROLE_SECONDARY_DIAGNOSIS', '2': 2},
    {'1': 'CODE_ROLE_PRINCIPAL_PROCEDURE', '2': 3},
    {'1': 'CODE_ROLE_SECONDARY_PROCEDURE', '2': 4},
    {'1': 'CODE_ROLE_EXTERNAL_CAUSE', '2': 5},
    {'1': 'CODE_ROLE_MORPHOLOGY', '2': 6},
  ],
};

/// Descriptor for `CodeRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codeRoleDescriptor = $convert.base64Decode(
    'CghDb2RlUm9sZRIZChVDT0RFX1JPTEVfVU5TUEVDSUZJRUQQABIhCh1DT0RFX1JPTEVfUFJJTk'
    'NJUEFMX0RJQUdOT1NJUxABEiEKHUNPREVfUk9MRV9TRUNPTkRBUllfRElBR05PU0lTEAISIQod'
    'Q09ERV9ST0xFX1BSSU5DSVBBTF9QUk9DRURVUkUQAxIhCh1DT0RFX1JPTEVfU0VDT05EQVJZX1'
    'BST0NFRFVSRRAEEhwKGENPREVfUk9MRV9FWFRFUk5BTF9DQVVTRRAFEhgKFENPREVfUk9MRV9N'
    'T1JQSE9MT0dZEAY=');

@$core.Deprecated('Use presentOnAdmissionDescriptor instead')
const PresentOnAdmission$json = {
  '1': 'PresentOnAdmission',
  '2': [
    {'1': 'PRESENT_ON_ADMISSION_UNSPECIFIED', '2': 0},
    {'1': 'PRESENT_ON_ADMISSION_YES', '2': 1},
    {'1': 'PRESENT_ON_ADMISSION_NO', '2': 2},
    {'1': 'PRESENT_ON_ADMISSION_UNDETERMINED', '2': 3},
    {'1': 'PRESENT_ON_ADMISSION_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `PresentOnAdmission`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List presentOnAdmissionDescriptor = $convert.base64Decode(
    'ChJQcmVzZW50T25BZG1pc3Npb24SJAogUFJFU0VOVF9PTl9BRE1JU1NJT05fVU5TUEVDSUZJRU'
    'QQABIcChhQUkVTRU5UX09OX0FETUlTU0lPTl9ZRVMQARIbChdQUkVTRU5UX09OX0FETUlTU0lP'
    'Tl9OTxACEiUKIVBSRVNFTlRfT05fQURNSVNTSU9OX1VOREVURVJNSU5FRBADEicKI1BSRVNFTl'
    'RfT05fQURNSVNTSU9OX05PVF9BUFBMSUNBQkxFEAQ=');

@$core.Deprecated('Use codingStateDescriptor instead')
const CodingState$json = {
  '1': 'CodingState',
  '2': [
    {'1': 'CODING_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CODING_STATE_IN_PROGRESS', '2': 1},
    {'1': 'CODING_STATE_CODED', '2': 2},
    {'1': 'CODING_STATE_FINAL', '2': 3},
    {'1': 'CODING_STATE_QUERIED', '2': 4},
  ],
};

/// Descriptor for `CodingState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List codingStateDescriptor = $convert.base64Decode(
    'CgtDb2RpbmdTdGF0ZRIcChhDT0RJTkdfU1RBVEVfVU5TUEVDSUZJRUQQABIcChhDT0RJTkdfU1'
    'RBVEVfSU5fUFJPR1JFU1MQARIWChJDT0RJTkdfU1RBVEVfQ09ERUQQAhIWChJDT0RJTkdfU1RB'
    'VEVfRklOQUwQAxIYChRDT0RJTkdfU1RBVEVfUVVFUklFRBAE');

@$core.Deprecated('Use authorityKindDescriptor instead')
const AuthorityKind$json = {
  '1': 'AuthorityKind',
  '2': [
    {'1': 'AUTHORITY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'AUTHORITY_KIND_PATIENT_CONSENT', '2': 1},
    {'1': 'AUTHORITY_KIND_AUTHORISED_REPRESENTATIVE', '2': 2},
    {'1': 'AUTHORITY_KIND_COURT_ORDER', '2': 3},
    {'1': 'AUTHORITY_KIND_STATUTORY_REQUIREMENT', '2': 4},
    {'1': 'AUTHORITY_KIND_CONTINUITY_OF_CARE', '2': 5},
    {'1': 'AUTHORITY_KIND_INSURANCE_CLAIM', '2': 6},
  ],
};

/// Descriptor for `AuthorityKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authorityKindDescriptor = $convert.base64Decode(
    'Cg1BdXRob3JpdHlLaW5kEh4KGkFVVEhPUklUWV9LSU5EX1VOU1BFQ0lGSUVEEAASIgoeQVVUSE'
    '9SSVRZX0tJTkRfUEFUSUVOVF9DT05TRU5UEAESLAooQVVUSE9SSVRZX0tJTkRfQVVUSE9SSVNF'
    'RF9SRVBSRVNFTlRBVElWRRACEh4KGkFVVEhPUklUWV9LSU5EX0NPVVJUX09SREVSEAMSKAokQV'
    'VUSE9SSVRZX0tJTkRfU1RBVFVUT1JZX1JFUVVJUkVNRU5UEAQSJQohQVVUSE9SSVRZX0tJTkRf'
    'Q09OVElOVUlUWV9PRl9DQVJFEAUSIgoeQVVUSE9SSVRZX0tJTkRfSU5TVVJBTkNFX0NMQUlNEA'
    'Y=');

@$core.Deprecated('Use recipientKindDescriptor instead')
const RecipientKind$json = {
  '1': 'RecipientKind',
  '2': [
    {'1': 'RECIPIENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'RECIPIENT_KIND_PATIENT', '2': 1},
    {'1': 'RECIPIENT_KIND_TREATING_CLINICIAN', '2': 2},
    {'1': 'RECIPIENT_KIND_INSTITUTION', '2': 3},
    {'1': 'RECIPIENT_KIND_INSURER', '2': 4},
    {'1': 'RECIPIENT_KIND_LEGAL', '2': 5},
    {'1': 'RECIPIENT_KIND_GOVERNMENT_BODY', '2': 6},
  ],
};

/// Descriptor for `RecipientKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List recipientKindDescriptor = $convert.base64Decode(
    'Cg1SZWNpcGllbnRLaW5kEh4KGlJFQ0lQSUVOVF9LSU5EX1VOU1BFQ0lGSUVEEAASGgoWUkVDSV'
    'BJRU5UX0tJTkRfUEFUSUVOVBABEiUKIVJFQ0lQSUVOVF9LSU5EX1RSRUFUSU5HX0NMSU5JQ0lB'
    'ThACEh4KGlJFQ0lQSUVOVF9LSU5EX0lOU1RJVFVUSU9OEAMSGgoWUkVDSVBJRU5UX0tJTkRfSU'
    '5TVVJFUhAEEhgKFFJFQ0lQSUVOVF9LSU5EX0xFR0FMEAUSIgoeUkVDSVBJRU5UX0tJTkRfR09W'
    'RVJOTUVOVF9CT0RZEAY=');

@$core.Deprecated('Use releaseStateDescriptor instead')
const ReleaseState$json = {
  '1': 'ReleaseState',
  '2': [
    {'1': 'RELEASE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'RELEASE_STATE_REQUESTED', '2': 1},
    {'1': 'RELEASE_STATE_APPROVED', '2': 2},
    {'1': 'RELEASE_STATE_ASSEMBLED', '2': 3},
    {'1': 'RELEASE_STATE_RELEASED', '2': 4},
    {'1': 'RELEASE_STATE_REFUSED', '2': 5},
  ],
};

/// Descriptor for `ReleaseState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List releaseStateDescriptor = $convert.base64Decode(
    'CgxSZWxlYXNlU3RhdGUSHQoZUkVMRUFTRV9TVEFURV9VTlNQRUNJRklFRBAAEhsKF1JFTEVBU0'
    'VfU1RBVEVfUkVRVUVTVEVEEAESGgoWUkVMRUFTRV9TVEFURV9BUFBST1ZFRBACEhsKF1JFTEVB'
    'U0VfU1RBVEVfQVNTRU1CTEVEEAMSGgoWUkVMRUFTRV9TVEFURV9SRUxFQVNFRBAEEhkKFVJFTE'
    'VBU0VfU1RBVEVfUkVGVVNFRBAF');

@$core.Deprecated('Use disclosureKindDescriptor instead')
const DisclosureKind$json = {
  '1': 'DisclosureKind',
  '2': [
    {'1': 'DISCLOSURE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DISCLOSURE_KIND_RELEASE', '2': 1},
    {'1': 'DISCLOSURE_KIND_EXPORT', '2': 2},
    {'1': 'DISCLOSURE_KIND_PRINT', '2': 3},
  ],
};

/// Descriptor for `DisclosureKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List disclosureKindDescriptor = $convert.base64Decode(
    'Cg5EaXNjbG9zdXJlS2luZBIfChtESVNDTE9TVVJFX0tJTkRfVU5TUEVDSUZJRUQQABIbChdESV'
    'NDTE9TVVJFX0tJTkRfUkVMRUFTRRABEhoKFkRJU0NMT1NVUkVfS0lORF9FWFBPUlQQAhIZChVE'
    'SVNDTE9TVVJFX0tJTkRfUFJJTlQQAw==');

@$core.Deprecated('Use retentionAnchorDescriptor instead')
const RetentionAnchor$json = {
  '1': 'RetentionAnchor',
  '2': [
    {'1': 'RETENTION_ANCHOR_UNSPECIFIED', '2': 0},
    {'1': 'RETENTION_ANCHOR_DISCHARGE', '2': 1},
    {'1': 'RETENTION_ANCHOR_LAST_CONTACT', '2': 2},
    {'1': 'RETENTION_ANCHOR_DEATH', '2': 3},
    {'1': 'RETENTION_ANCHOR_MAJORITY', '2': 4},
    {'1': 'RETENTION_ANCHOR_CREATION', '2': 5},
  ],
};

/// Descriptor for `RetentionAnchor`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List retentionAnchorDescriptor = $convert.base64Decode(
    'Cg9SZXRlbnRpb25BbmNob3ISIAocUkVURU5USU9OX0FOQ0hPUl9VTlNQRUNJRklFRBAAEh4KGl'
    'JFVEVOVElPTl9BTkNIT1JfRElTQ0hBUkdFEAESIQodUkVURU5USU9OX0FOQ0hPUl9MQVNUX0NP'
    'TlRBQ1QQAhIaChZSRVRFTlRJT05fQU5DSE9SX0RFQVRIEAMSHQoZUkVURU5USU9OX0FOQ0hPUl'
    '9NQUpPUklUWRAEEh0KGVJFVEVOVElPTl9BTkNIT1JfQ1JFQVRJT04QBQ==');

@$core.Deprecated('Use dispositionKindDescriptor instead')
const DispositionKind$json = {
  '1': 'DispositionKind',
  '2': [
    {'1': 'DISPOSITION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DISPOSITION_KIND_DESTROY', '2': 1},
    {'1': 'DISPOSITION_KIND_ARCHIVE', '2': 2},
    {'1': 'DISPOSITION_KIND_PERMANENT', '2': 3},
  ],
};

/// Descriptor for `DispositionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dispositionKindDescriptor = $convert.base64Decode(
    'Cg9EaXNwb3NpdGlvbktpbmQSIAocRElTUE9TSVRJT05fS0lORF9VTlNQRUNJRklFRBAAEhwKGE'
    'RJU1BPU0lUSU9OX0tJTkRfREVTVFJPWRABEhwKGERJU1BPU0lUSU9OX0tJTkRfQVJDSElWRRAC'
    'Eh4KGkRJU1BPU0lUSU9OX0tJTkRfUEVSTUFORU5UEAM=');

@$core.Deprecated('Use dispositionStateDescriptor instead')
const DispositionState$json = {
  '1': 'DispositionState',
  '2': [
    {'1': 'DISPOSITION_STATE_UNSPECIFIED', '2': 0},
    {'1': 'DISPOSITION_STATE_DRAFT', '2': 1},
    {'1': 'DISPOSITION_STATE_APPROVED', '2': 2},
    {'1': 'DISPOSITION_STATE_EXECUTED', '2': 3},
    {'1': 'DISPOSITION_STATE_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `DispositionState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dispositionStateDescriptor = $convert.base64Decode(
    'ChBEaXNwb3NpdGlvblN0YXRlEiEKHURJU1BPU0lUSU9OX1NUQVRFX1VOU1BFQ0lGSUVEEAASGw'
    'oXRElTUE9TSVRJT05fU1RBVEVfRFJBRlQQARIeChpESVNQT1NJVElPTl9TVEFURV9BUFBST1ZF'
    'RBACEh4KGkRJU1BPU0lUSU9OX1NUQVRFX0VYRUNVVEVEEAMSHwobRElTUE9TSVRJT05fU1RBVE'
    'VfQ0FOQ0VMTEVEEAQ=');

@$core.Deprecated('Use physicalStateDescriptor instead')
const PhysicalState$json = {
  '1': 'PhysicalState',
  '2': [
    {'1': 'PHYSICAL_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PHYSICAL_STATE_FILED', '2': 1},
    {'1': 'PHYSICAL_STATE_CHECKED_OUT', '2': 2},
    {'1': 'PHYSICAL_STATE_ARCHIVED', '2': 3},
    {'1': 'PHYSICAL_STATE_MISSING', '2': 4},
    {'1': 'PHYSICAL_STATE_DESTROYED', '2': 5},
  ],
};

/// Descriptor for `PhysicalState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List physicalStateDescriptor = $convert.base64Decode(
    'Cg1QaHlzaWNhbFN0YXRlEh4KGlBIWVNJQ0FMX1NUQVRFX1VOU1BFQ0lGSUVEEAASGAoUUEhZU0'
    'lDQUxfU1RBVEVfRklMRUQQARIeChpQSFlTSUNBTF9TVEFURV9DSEVDS0VEX09VVBACEhsKF1BI'
    'WVNJQ0FMX1NUQVRFX0FSQ0hJVkVEEAMSGgoWUEhZU0lDQUxfU1RBVEVfTUlTU0lORxAEEhwKGF'
    'BIWVNJQ0FMX1NUQVRFX0RFU1RST1lFRBAF');

@$core.Deprecated('Use certificateKindDescriptor instead')
const CertificateKind$json = {
  '1': 'CertificateKind',
  '2': [
    {'1': 'CERTIFICATE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'CERTIFICATE_KIND_BIRTH', '2': 1},
    {'1': 'CERTIFICATE_KIND_DEATH', '2': 2},
    {'1': 'CERTIFICATE_KIND_STILLBIRTH', '2': 3},
    {'1': 'CERTIFICATE_KIND_MEDICAL', '2': 4},
    {'1': 'CERTIFICATE_KIND_CAUSE_OF_DEATH', '2': 5},
  ],
};

/// Descriptor for `CertificateKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List certificateKindDescriptor = $convert.base64Decode(
    'Cg9DZXJ0aWZpY2F0ZUtpbmQSIAocQ0VSVElGSUNBVEVfS0lORF9VTlNQRUNJRklFRBAAEhoKFk'
    'NFUlRJRklDQVRFX0tJTkRfQklSVEgQARIaChZDRVJUSUZJQ0FURV9LSU5EX0RFQVRIEAISHwob'
    'Q0VSVElGSUNBVEVfS0lORF9TVElMTEJJUlRIEAMSHAoYQ0VSVElGSUNBVEVfS0lORF9NRURJQ0'
    'FMEAQSIwofQ0VSVElGSUNBVEVfS0lORF9DQVVTRV9PRl9ERUFUSBAF');

@$core.Deprecated('Use certificateStateDescriptor instead')
const CertificateState$json = {
  '1': 'CertificateState',
  '2': [
    {'1': 'CERTIFICATE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CERTIFICATE_STATE_ISSUED', '2': 1},
    {'1': 'CERTIFICATE_STATE_VOIDED', '2': 2},
  ],
};

/// Descriptor for `CertificateState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List certificateStateDescriptor = $convert.base64Decode(
    'ChBDZXJ0aWZpY2F0ZVN0YXRlEiEKHUNFUlRJRklDQVRFX1NUQVRFX1VOU1BFQ0lGSUVEEAASHA'
    'oYQ0VSVElGSUNBVEVfU1RBVEVfSVNTVUVEEAESHAoYQ0VSVElGSUNBVEVfU1RBVEVfVk9JREVE'
    'EAI=');

@$core.Deprecated('Use checklistItemDescriptor instead')
const ChecklistItem$json = {
  '1': 'ChecklistItem',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'requirement',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DocumentRequirement',
      '10': 'requirement'
    },
    {
      '1': 'due_within_seconds',
      '3': 4,
      '4': 1,
      '5': 3,
      '10': 'dueWithinSeconds'
    },
    {'1': 'condition_code', '3': 5, '4': 1, '5': 9, '10': 'conditionCode'},
  ],
};

/// Descriptor for `ChecklistItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checklistItemDescriptor = $convert.base64Decode(
    'Cg1DaGVja2xpc3RJdGVtEhIKBGtpbmQYASABKAlSBGtpbmQSFAoFbGFiZWwYAiABKAlSBWxhYm'
    'VsEkwKC3JlcXVpcmVtZW50GAMgASgOMiouaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkRvY3VtZW50'
    'UmVxdWlyZW1lbnRSC3JlcXVpcmVtZW50EiwKEmR1ZV93aXRoaW5fc2Vjb25kcxgEIAEoA1IQZH'
    'VlV2l0aGluU2Vjb25kcxIlCg5jb25kaXRpb25fY29kZRgFIAEoCVINY29uZGl0aW9uQ29kZQ==');

@$core.Deprecated('Use chartChecklistDescriptor instead')
const ChartChecklist$json = {
  '1': 'ChartChecklist',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'encounter_class', '3': 5, '4': 1, '5': 9, '10': 'encounterClass'},
    {'1': 'specialty', '3': 6, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'items',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.ChecklistItem',
      '10': 'items'
    },
    {'1': 'approved', '3': 8, '4': 1, '5': 8, '10': 'approved'},
    {'1': 'approved_by', '3': 9, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'approved_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {
      '1': 'effective_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'superseded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'supersededAt'
    },
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

/// Descriptor for `ChartChecklist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartChecklistDescriptor = $convert.base64Decode(
    'Cg5DaGFydENoZWNrbGlzdBIhCgxjaGVja2xpc3RfaWQYASABKAlSC2NoZWNrbGlzdElkEhIKBG'
    'NvZGUYAiABKAlSBGNvZGUSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghyZXZpc2lvbhgEIAEoBVII'
    'cmV2aXNpb24SJwoPZW5jb3VudGVyX2NsYXNzGAUgASgJUg5lbmNvdW50ZXJDbGFzcxIcCglzcG'
    'VjaWFsdHkYBiABKAlSCXNwZWNpYWx0eRI6CgVpdGVtcxgHIAMoCzIkLmhlYWx0aGNhcmUucmVj'
    'b3Jkcy52MS5DaGVja2xpc3RJdGVtUgVpdGVtcxIaCghhcHByb3ZlZBgIIAEoCFIIYXBwcm92ZW'
    'QSHwoLYXBwcm92ZWRfYnkYCSABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYXQYCiABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0EkEKDmVmZmVjdGl2ZV9mcm'
    '9tGAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbRI/Cg1z'
    'dXBlcnNlZGVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMc3VwZXJzZW'
    'RlZEF0EjkKCmNyZWF0ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglj'
    'cmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgOIAEoCVIJY3JlYXRlZEJ5');

@$core.Deprecated('Use gapDescriptor instead')
const Gap$json = {
  '1': 'Gap',
  '2': [
    {'1': 'kind', '3': 1, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'missing', '3': 3, '4': 1, '5': 8, '10': 'missing'},
    {'1': 'document_id', '3': 4, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'owner_id', '3': 5, '4': 1, '5': 9, '10': 'ownerId'},
    {
      '1': 'due_by',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
  ],
};

/// Descriptor for `Gap`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gapDescriptor = $convert.base64Decode(
    'CgNHYXASEgoEa2luZBgBIAEoCVIEa2luZBIUCgVsYWJlbBgCIAEoCVIFbGFiZWwSGAoHbWlzc2'
    'luZxgDIAEoCFIHbWlzc2luZxIfCgtkb2N1bWVudF9pZBgEIAEoCVIKZG9jdW1lbnRJZBIZCghv'
    'd25lcl9pZBgFIAEoCVIHb3duZXJJZBIxCgZkdWVfYnkYBiABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgVkdWVCeQ==');

@$core.Deprecated('Use chartStatusDescriptor instead')
const ChartStatus$json = {
  '1': 'ChartStatus',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'checklist_code', '3': 3, '4': 1, '5': 9, '10': 'checklistCode'},
    {
      '1': 'checklist_revision',
      '3': 4,
      '4': 1,
      '5': 5,
      '10': 'checklistRevision'
    },
    {
      '1': 'gaps',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.Gap',
      '10': 'gaps'
    },
    {'1': 'documents', '3': 6, '4': 1, '5': 5, '10': 'documents'},
  ],
};

/// Descriptor for `ChartStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartStatusDescriptor = $convert.base64Decode(
    'CgtDaGFydFN0YXR1cxIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bnRlcklkEh0KCnBhdG'
    'llbnRfaWQYAiABKAlSCXBhdGllbnRJZBIlCg5jaGVja2xpc3RfY29kZRgDIAEoCVINY2hlY2ts'
    'aXN0Q29kZRItChJjaGVja2xpc3RfcmV2aXNpb24YBCABKAVSEWNoZWNrbGlzdFJldmlzaW9uEi'
    '4KBGdhcHMYBSADKAsyGi5oZWFsdGhjYXJlLnJlY29yZHMudjEuR2FwUgRnYXBzEhwKCWRvY3Vt'
    'ZW50cxgGIAEoBVIJZG9jdW1lbnRz');

@$core.Deprecated('Use deficiencyDescriptor instead')
const Deficiency$json = {
  '1': 'Deficiency',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DeficiencyKind',
      '10': 'kind'
    },
    {'1': 'document_kind', '3': 6, '4': 1, '5': 9, '10': 'documentKind'},
    {'1': 'label', '3': 7, '4': 1, '5': 9, '10': 'label'},
    {'1': 'document_id', '3': 8, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'detail', '3': 9, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'owner_id', '3': 10, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'checklist_code', '3': 11, '4': 1, '5': 9, '10': 'checklistCode'},
    {
      '1': 'checklist_revision',
      '3': 12,
      '4': 1,
      '5': 5,
      '10': 'checklistRevision'
    },
    {
      '1': 'state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DeficiencyState',
      '10': 'state'
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
      '1': 'raised_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'raisedAt'
    },
    {'1': 'raised_by', '3': 16, '4': 1, '5': 9, '10': 'raisedBy'},
    {
      '1': 'resolved_by_document_id',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'resolvedByDocumentId'
    },
    {
      '1': 'resolved_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {'1': 'resolved_by', '3': 19, '4': 1, '5': 9, '10': 'resolvedBy'},
    {'1': 'waived_reason', '3': 20, '4': 1, '5': 9, '10': 'waivedReason'},
    {
      '1': 'escalated_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'escalatedAt'
    },
    {'1': 'version', '3': 22, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Deficiency`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deficiencyDescriptor = $convert.base64Decode(
    'CgpEZWZpY2llbmN5EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZmljaWVuY3lJZBIdCgpwYX'
    'RpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50'
    'ZXJJZBIfCgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBI5CgRraW5kGAUgASgOMiUuaG'
    'VhbHRoY2FyZS5yZWNvcmRzLnYxLkRlZmljaWVuY3lLaW5kUgRraW5kEiMKDWRvY3VtZW50X2tp'
    'bmQYBiABKAlSDGRvY3VtZW50S2luZBIUCgVsYWJlbBgHIAEoCVIFbGFiZWwSHwoLZG9jdW1lbn'
    'RfaWQYCCABKAlSCmRvY3VtZW50SWQSFgoGZGV0YWlsGAkgASgJUgZkZXRhaWwSGQoIb3duZXJf'
    'aWQYCiABKAlSB293bmVySWQSJQoOY2hlY2tsaXN0X2NvZGUYCyABKAlSDWNoZWNrbGlzdENvZG'
    'USLQoSY2hlY2tsaXN0X3JldmlzaW9uGAwgASgFUhFjaGVja2xpc3RSZXZpc2lvbhI8CgVzdGF0'
    'ZRgNIAEoDjImLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5EZWZpY2llbmN5U3RhdGVSBXN0YXRlEj'
    'EKBmR1ZV9ieRgOIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5EjcKCXJh'
    'aXNlZF9hdBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHJhaXNlZEF0EhsKCX'
    'JhaXNlZF9ieRgQIAEoCVIIcmFpc2VkQnkSNQoXcmVzb2x2ZWRfYnlfZG9jdW1lbnRfaWQYESAB'
    'KAlSFHJlc29sdmVkQnlEb2N1bWVudElkEjsKC3Jlc29sdmVkX2F0GBIgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIKcmVzb2x2ZWRBdBIfCgtyZXNvbHZlZF9ieRgTIAEoCVIKcmVz'
    'b2x2ZWRCeRIjCg13YWl2ZWRfcmVhc29uGBQgASgJUgx3YWl2ZWRSZWFzb24SPQoMZXNjYWxhdG'
    'VkX2F0GBUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILZXNjYWxhdGVkQXQSGAoH'
    'dmVyc2lvbhgWIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use ageBucketDescriptor instead')
const AgeBucket$json = {
  '1': 'AgeBucket',
  '2': [
    {'1': 'from_days', '3': 1, '4': 1, '5': 5, '10': 'fromDays'},
    {'1': 'to_days', '3': 2, '4': 1, '5': 5, '10': 'toDays'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'count', '3': 4, '4': 1, '5': 5, '10': 'count'},
    {'1': 'overdue', '3': 5, '4': 1, '5': 5, '10': 'overdue'},
  ],
};

/// Descriptor for `AgeBucket`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ageBucketDescriptor = $convert.base64Decode(
    'CglBZ2VCdWNrZXQSGwoJZnJvbV9kYXlzGAEgASgFUghmcm9tRGF5cxIXCgd0b19kYXlzGAIgAS'
    'gFUgZ0b0RheXMSFAoFbGFiZWwYAyABKAlSBWxhYmVsEhQKBWNvdW50GAQgASgFUgVjb3VudBIY'
    'CgdvdmVyZHVlGAUgASgFUgdvdmVyZHVl');

@$core.Deprecated('Use completionSummaryDescriptor instead')
const CompletionSummary$json = {
  '1': 'CompletionSummary',
  '2': [
    {'1': 'encounters', '3': 1, '4': 1, '5': 5, '10': 'encounters'},
    {'1': 'complete', '3': 2, '4': 1, '5': 5, '10': 'complete'},
    {'1': 'incompletable', '3': 3, '4': 1, '5': 5, '10': 'incompletable'},
    {'1': 'open', '3': 4, '4': 1, '5': 5, '10': 'open'},
    {'1': 'overdue', '3': 5, '4': 1, '5': 5, '10': 'overdue'},
    {'1': 'resolved', '3': 6, '4': 1, '5': 5, '10': 'resolved'},
    {'1': 'waived', '3': 7, '4': 1, '5': 5, '10': 'waived'},
    {
      '1': 'complete_permille',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'completePermille'
    },
    {'1': 'unanswerable', '3': 9, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `CompletionSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completionSummaryDescriptor = $convert.base64Decode(
    'ChFDb21wbGV0aW9uU3VtbWFyeRIeCgplbmNvdW50ZXJzGAEgASgFUgplbmNvdW50ZXJzEhoKCG'
    'NvbXBsZXRlGAIgASgFUghjb21wbGV0ZRIkCg1pbmNvbXBsZXRhYmxlGAMgASgFUg1pbmNvbXBs'
    'ZXRhYmxlEhIKBG9wZW4YBCABKAVSBG9wZW4SGAoHb3ZlcmR1ZRgFIAEoBVIHb3ZlcmR1ZRIaCg'
    'hyZXNvbHZlZBgGIAEoBVIIcmVzb2x2ZWQSFgoGd2FpdmVkGAcgASgFUgZ3YWl2ZWQSKwoRY29t'
    'cGxldGVfcGVybWlsbGUYCCABKAVSEGNvbXBsZXRlUGVybWlsbGUSIgoMdW5hbnN3ZXJhYmxlGA'
    'kgASgIUgx1bmFuc3dlcmFibGU=');

@$core.Deprecated('Use assignedCodeDescriptor instead')
const AssignedCode$json = {
  '1': 'AssignedCode',
  '2': [
    {'1': 'system', '3': 1, '4': 1, '5': 9, '10': 'system'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display', '3': 4, '4': 1, '5': 9, '10': 'display'},
    {
      '1': 'role',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CodeRole',
      '10': 'role'
    },
    {'1': 'sequence', '3': 6, '4': 1, '5': 5, '10': 'sequence'},
    {
      '1': 'present_on_admission',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.PresentOnAdmission',
      '10': 'presentOnAdmission'
    },
    {
      '1': 'source_document_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'sourceDocumentId'
    },
  ],
};

/// Descriptor for `AssignedCode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignedCodeDescriptor = $convert.base64Decode(
    'CgxBc3NpZ25lZENvZGUSFgoGc3lzdGVtGAEgASgJUgZzeXN0ZW0SGAoHdmVyc2lvbhgCIAEoCV'
    'IHdmVyc2lvbhISCgRjb2RlGAMgASgJUgRjb2RlEhgKB2Rpc3BsYXkYBCABKAlSB2Rpc3BsYXkS'
    'MwoEcm9sZRgFIAEoDjIfLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Db2RlUm9sZVIEcm9sZRIaCg'
    'hzZXF1ZW5jZRgGIAEoBVIIc2VxdWVuY2USWwoUcHJlc2VudF9vbl9hZG1pc3Npb24YByABKA4y'
    'KS5oZWFsdGhjYXJlLnJlY29yZHMudjEuUHJlc2VudE9uQWRtaXNzaW9uUhJwcmVzZW50T25BZG'
    '1pc3Npb24SLAoSc291cmNlX2RvY3VtZW50X2lkGAggASgJUhBzb3VyY2VEb2N1bWVudElk');

@$core.Deprecated('Use codingRevisionDescriptor instead')
const CodingRevision$json = {
  '1': 'CodingRevision',
  '2': [
    {'1': 'revision', '3': 1, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'codes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.AssignedCode',
      '10': 'codes'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'coded_by', '3': 4, '4': 1, '5': 9, '10': 'codedBy'},
    {
      '1': 'coded_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'codedAt'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CodingState',
      '10': 'state'
    },
    {'1': 'reviewed_by', '3': 7, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
  ],
};

/// Descriptor for `CodingRevision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codingRevisionDescriptor = $convert.base64Decode(
    'Cg5Db2RpbmdSZXZpc2lvbhIaCghyZXZpc2lvbhgBIAEoBVIIcmV2aXNpb24SOQoFY29kZXMYAi'
    'ADKAsyIy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXNzaWduZWRDb2RlUgVjb2RlcxIWCgZyZWFz'
    'b24YAyABKAlSBnJlYXNvbhIZCghjb2RlZF9ieRgEIAEoCVIHY29kZWRCeRI1Cghjb2RlZF9hdB'
    'gFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2NvZGVkQXQSOAoFc3RhdGUYBiAB'
    'KA4yIi5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ29kaW5nU3RhdGVSBXN0YXRlEh8KC3Jldmlld2'
    'VkX2J5GAcgASgJUgpyZXZpZXdlZEJ5EjsKC3Jldmlld2VkX2F0GAggASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIKcmV2aWV3ZWRBdA==');

@$core.Deprecated('Use codedEpisodeDescriptor instead')
const CodedEpisode$json = {
  '1': 'CodedEpisode',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'revisions',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CodingRevision',
      '10': 'revisions'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CodingState',
      '10': 'state'
    },
    {
      '1': 'created_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 8, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 9, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CodedEpisode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codedEpisodeDescriptor = $convert.base64Decode(
    'CgxDb2RlZEVwaXNvZGUSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEh0KCnBhdGllbn'
    'RfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYAyABKAlSC2VuY291bnRlcklk'
    'Eh8KC2ZhY2lsaXR5X2lkGAQgASgJUgpmYWNpbGl0eUlkEkMKCXJldmlzaW9ucxgFIAMoCzIlLm'
    'hlYWx0aGNhcmUucmVjb3Jkcy52MS5Db2RpbmdSZXZpc2lvblIJcmV2aXNpb25zEjgKBXN0YXRl'
    'GAYgASgOMiIuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNvZGluZ1N0YXRlUgVzdGF0ZRI5Cgpjcm'
    'VhdGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0K'
    'CmNyZWF0ZWRfYnkYCCABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGAkgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use codingChangeDescriptor instead')
const CodingChange$json = {
  '1': 'CodingChange',
  '2': [
    {'1': 'system', '3': 1, '4': 1, '5': 9, '10': 'system'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'was',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CodeRole',
      '10': 'was'
    },
    {
      '1': 'now',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CodeRole',
      '10': 'now'
    },
  ],
};

/// Descriptor for `CodingChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List codingChangeDescriptor = $convert.base64Decode(
    'CgxDb2RpbmdDaGFuZ2USFgoGc3lzdGVtGAEgASgJUgZzeXN0ZW0SEgoEY29kZRgCIAEoCVIEY2'
    '9kZRIxCgN3YXMYAyABKA4yHy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ29kZVJvbGVSA3dhcxIx'
    'CgNub3cYBCABKA4yHy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ29kZVJvbGVSA25vdw==');

@$core.Deprecated('Use authorisationDescriptor instead')
const Authorisation$json = {
  '1': 'Authorisation',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.AuthorityKind',
      '10': 'kind'
    },
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'signed_by', '3': 3, '4': 1, '5': 9, '10': 'signedBy'},
    {
      '1': 'signed_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedAt'
    },
    {
      '1': 'expires_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `Authorisation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorisationDescriptor = $convert.base64Decode(
    'Cg1BdXRob3Jpc2F0aW9uEjgKBGtpbmQYASABKA4yJC5oZWFsdGhjYXJlLnJlY29yZHMudjEuQX'
    'V0aG9yaXR5S2luZFIEa2luZBIcCglyZWZlcmVuY2UYAiABKAlSCXJlZmVyZW5jZRIbCglzaWdu'
    'ZWRfYnkYAyABKAlSCHNpZ25lZEJ5EjcKCXNpZ25lZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSCHNpZ25lZEF0EjkKCmV4cGlyZXNfYXQYBSABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUglleHBpcmVzQXQ=');

@$core.Deprecated('Use recipientDescriptor instead')
const Recipient$json = {
  '1': 'Recipient',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.RecipientKind',
      '10': 'kind'
    },
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'reference', '3': 3, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'delivery_method', '3': 4, '4': 1, '5': 9, '10': 'deliveryMethod'},
  ],
};

/// Descriptor for `Recipient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipientDescriptor = $convert.base64Decode(
    'CglSZWNpcGllbnQSOAoEa2luZBgBIAEoDjIkLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWNpcG'
    'llbnRLaW5kUgRraW5kEhIKBG5hbWUYAiABKAlSBG5hbWUSHAoJcmVmZXJlbmNlGAMgASgJUgly'
    'ZWZlcmVuY2USJwoPZGVsaXZlcnlfbWV0aG9kGAQgASgJUg5kZWxpdmVyeU1ldGhvZA==');

@$core.Deprecated('Use releaseScopeDescriptor instead')
const ReleaseScope$json = {
  '1': 'ReleaseScope',
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
    {'1': 'record_classes', '3': 3, '4': 3, '5': 9, '10': 'recordClasses'},
    {'1': 'document_kinds', '3': 4, '4': 3, '5': 9, '10': 'documentKinds'},
    {'1': 'encounter_ids', '3': 5, '4': 3, '5': 9, '10': 'encounterIds'},
    {'1': 'whole_record', '3': 6, '4': 1, '5': 8, '10': 'wholeRecord'},
    {
      '1': 'include_restricted',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'includeRestricted'
    },
  ],
};

/// Descriptor for `ReleaseScope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseScopeDescriptor = $convert.base64Decode(
    'CgxSZWxlYXNlU2NvcGUSLgoEZnJvbRgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSBGZyb20SKgoCdG8YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bxIlCg5y'
    'ZWNvcmRfY2xhc3NlcxgDIAMoCVINcmVjb3JkQ2xhc3NlcxIlCg5kb2N1bWVudF9raW5kcxgEIA'
    'MoCVINZG9jdW1lbnRLaW5kcxIjCg1lbmNvdW50ZXJfaWRzGAUgAygJUgxlbmNvdW50ZXJJZHMS'
    'IQoMd2hvbGVfcmVjb3JkGAYgASgIUgt3aG9sZVJlY29yZBItChJpbmNsdWRlX3Jlc3RyaWN0ZW'
    'QYByABKAhSEWluY2x1ZGVSZXN0cmljdGVk');

@$core.Deprecated('Use releaseItemDescriptor instead')
const ReleaseItem$json = {
  '1': 'ReleaseItem',
  '2': [
    {'1': 'document_id', '3': 1, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'kind', '3': 3, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'record_class', '3': 4, '4': 1, '5': 9, '10': 'recordClass'},
    {
      '1': 'occurred_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'restricted', '3': 6, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'pages', '3': 7, '4': 1, '5': 5, '10': 'pages'},
  ],
};

/// Descriptor for `ReleaseItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseItemDescriptor = $convert.base64Decode(
    'CgtSZWxlYXNlSXRlbRIfCgtkb2N1bWVudF9pZBgBIAEoCVIKZG9jdW1lbnRJZBIhCgxlbmNvdW'
    '50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEhIKBGtpbmQYAyABKAlSBGtpbmQSIQoMcmVjb3Jk'
    'X2NsYXNzGAQgASgJUgtyZWNvcmRDbGFzcxI7CgtvY2N1cnJlZF9hdBgFIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQSHgoKcmVzdHJpY3RlZBgGIAEoCFIKcmVz'
    'dHJpY3RlZBIUCgVwYWdlcxgHIAEoBVIFcGFnZXM=');

@$core.Deprecated('Use releasePackageDescriptor instead')
const ReleasePackage$json = {
  '1': 'ReleasePackage',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseItem',
      '10': 'items'
    },
    {'1': 'content_hash', '3': 2, '4': 1, '5': 9, '10': 'contentHash'},
    {'1': 'pages', '3': 3, '4': 1, '5': 5, '10': 'pages'},
    {
      '1': 'assembled_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assembledAt'
    },
    {'1': 'assembled_by', '3': 5, '4': 1, '5': 9, '10': 'assembledBy'},
    {
      '1': 'released_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'releasedAt'
    },
    {'1': 'released_by', '3': 7, '4': 1, '5': 9, '10': 'releasedBy'},
  ],
};

/// Descriptor for `ReleasePackage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releasePackageDescriptor = $convert.base64Decode(
    'Cg5SZWxlYXNlUGFja2FnZRI4CgVpdGVtcxgBIAMoCzIiLmhlYWx0aGNhcmUucmVjb3Jkcy52MS'
    '5SZWxlYXNlSXRlbVIFaXRlbXMSIQoMY29udGVudF9oYXNoGAIgASgJUgtjb250ZW50SGFzaBIU'
    'CgVwYWdlcxgDIAEoBVIFcGFnZXMSPQoMYXNzZW1ibGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFILYXNzZW1ibGVkQXQSIQoMYXNzZW1ibGVkX2J5GAUgASgJUgthc3Nl'
    'bWJsZWRCeRI7CgtyZWxlYXNlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCnJlbGVhc2VkQXQSHwoLcmVsZWFzZWRfYnkYByABKAlSCnJlbGVhc2VkQnk=');

@$core.Deprecated('Use releaseRequestDescriptor instead')
const ReleaseRequest$json = {
  '1': 'ReleaseRequest',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'purpose', '3': 4, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'authorisation',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Authorisation',
      '10': 'authorisation'
    },
    {
      '1': 'recipient',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Recipient',
      '10': 'recipient'
    },
    {
      '1': 'scope',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseScope',
      '10': 'scope'
    },
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.ReleaseState',
      '10': 'state'
    },
    {'1': 'refusal_reason', '3': 9, '4': 1, '5': 9, '10': 'refusalReason'},
    {
      '1': 'requested_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {'1': 'requested_by', '3': 11, '4': 1, '5': 9, '10': 'requestedBy'},
    {
      '1': 'approved_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'approved_by', '3': 13, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'package',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleasePackage',
      '10': 'package'
    },
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseRequestDescriptor = $convert.base64Decode(
    'Cg5SZWxlYXNlUmVxdWVzdBIdCgpyZWxlYXNlX2lkGAEgASgJUglyZWxlYXNlSWQSHAoJcmVmZX'
    'JlbmNlGAIgASgJUglyZWZlcmVuY2USHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEhgK'
    'B3B1cnBvc2UYBCABKAlSB3B1cnBvc2USSgoNYXV0aG9yaXNhdGlvbhgFIAEoCzIkLmhlYWx0aG'
    'NhcmUucmVjb3Jkcy52MS5BdXRob3Jpc2F0aW9uUg1hdXRob3Jpc2F0aW9uEj4KCXJlY2lwaWVu'
    'dBgGIAEoCzIgLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWNpcGllbnRSCXJlY2lwaWVudBI5Cg'
    'VzY29wZRgHIAEoCzIjLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWxlYXNlU2NvcGVSBXNjb3Bl'
    'EjkKBXN0YXRlGAggASgOMiMuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLlJlbGVhc2VTdGF0ZVIFc3'
    'RhdGUSJQoOcmVmdXNhbF9yZWFzb24YCSABKAlSDXJlZnVzYWxSZWFzb24SPQoMcmVxdWVzdGVk'
    'X2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcmVxdWVzdGVkQXQSIQoMcm'
    'VxdWVzdGVkX2J5GAsgASgJUgtyZXF1ZXN0ZWRCeRI7CgthcHByb3ZlZF9hdBgMIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQSHwoLYXBwcm92ZWRfYnkYDSABKA'
    'lSCmFwcHJvdmVkQnkSPwoHcGFja2FnZRgOIAEoCzIlLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5S'
    'ZWxlYXNlUGFja2FnZVIHcGFja2FnZRIYCgd2ZXJzaW9uGA8gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use disclosureDescriptor instead')
const Disclosure$json = {
  '1': 'Disclosure',
  '2': [
    {'1': 'disclosure_id', '3': 1, '4': 1, '5': 9, '10': 'disclosureId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DisclosureKind',
      '10': 'kind'
    },
    {'1': 'release_id', '3': 4, '4': 1, '5': 9, '10': 'releaseId'},
    {'1': 'actor_id', '3': 5, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'purpose', '3': 6, '4': 1, '5': 9, '10': 'purpose'},
    {'1': 'scope_summary', '3': 7, '4': 1, '5': 9, '10': 'scopeSummary'},
    {
      '1': 'recipient_reference',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'recipientReference'
    },
    {'1': 'recipient_name', '3': 9, '4': 1, '5': 9, '10': 'recipientName'},
    {'1': 'items', '3': 10, '4': 1, '5': 5, '10': 'items'},
    {'1': 'pages', '3': 11, '4': 1, '5': 5, '10': 'pages'},
    {
      '1': 'occurred_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
  ],
};

/// Descriptor for `Disclosure`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disclosureDescriptor = $convert.base64Decode(
    'CgpEaXNjbG9zdXJlEiMKDWRpc2Nsb3N1cmVfaWQYASABKAlSDGRpc2Nsb3N1cmVJZBIdCgpwYX'
    'RpZW50X2lkGAIgASgJUglwYXRpZW50SWQSOQoEa2luZBgDIAEoDjIlLmhlYWx0aGNhcmUucmVj'
    'b3Jkcy52MS5EaXNjbG9zdXJlS2luZFIEa2luZBIdCgpyZWxlYXNlX2lkGAQgASgJUglyZWxlYX'
    'NlSWQSGQoIYWN0b3JfaWQYBSABKAlSB2FjdG9ySWQSGAoHcHVycG9zZRgGIAEoCVIHcHVycG9z'
    'ZRIjCg1zY29wZV9zdW1tYXJ5GAcgASgJUgxzY29wZVN1bW1hcnkSLwoTcmVjaXBpZW50X3JlZm'
    'VyZW5jZRgIIAEoCVIScmVjaXBpZW50UmVmZXJlbmNlEiUKDnJlY2lwaWVudF9uYW1lGAkgASgJ'
    'Ug1yZWNpcGllbnROYW1lEhQKBWl0ZW1zGAogASgFUgVpdGVtcxIUCgVwYWdlcxgLIAEoBVIFcG'
    'FnZXMSOwoLb2NjdXJyZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpv'
    'Y2N1cnJlZEF0');

@$core.Deprecated('Use retentionRuleDescriptor instead')
const RetentionRule$json = {
  '1': 'RetentionRule',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'record_class', '3': 5, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'jurisdiction', '3': 6, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'anchor',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.RetentionAnchor',
      '10': 'anchor'
    },
    {'1': 'retain_years', '3': 8, '4': 1, '5': 5, '10': 'retainYears'},
    {
      '1': 'disposition',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionKind',
      '10': 'disposition'
    },
    {'1': 'authority', '3': 10, '4': 1, '5': 9, '10': 'authority'},
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

/// Descriptor for `RetentionRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retentionRuleDescriptor = $convert.base64Decode(
    'Cg1SZXRlbnRpb25SdWxlEhcKB3J1bGVfaWQYASABKAlSBnJ1bGVJZBISCgRjb2RlGAIgASgJUg'
    'Rjb2RlEhIKBG5hbWUYAyABKAlSBG5hbWUSGgoIcmV2aXNpb24YBCABKAVSCHJldmlzaW9uEiEK'
    'DHJlY29yZF9jbGFzcxgFIAEoCVILcmVjb3JkQ2xhc3MSIgoManVyaXNkaWN0aW9uGAYgASgJUg'
    'xqdXJpc2RpY3Rpb24SPgoGYW5jaG9yGAcgASgOMiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLlJl'
    'dGVudGlvbkFuY2hvclIGYW5jaG9yEiEKDHJldGFpbl95ZWFycxgIIAEoBVILcmV0YWluWWVhcn'
    'MSSAoLZGlzcG9zaXRpb24YCSABKA4yJi5oZWFsdGhjYXJlLnJlY29yZHMudjEuRGlzcG9zaXRp'
    'b25LaW5kUgtkaXNwb3NpdGlvbhIcCglhdXRob3JpdHkYCiABKAlSCWF1dGhvcml0eRIaCghhcH'
    'Byb3ZlZBgLIAEoCFIIYXBwcm92ZWQSHwoLYXBwcm92ZWRfYnkYDCABKAlSCmFwcHJvdmVkQnkS'
    'OwoLYXBwcm92ZWRfYXQYDSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3'
    'ZlZEF0EkEKDmVmZmVjdGl2ZV9mcm9tGA4gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFINZWZmZWN0aXZlRnJvbRI/Cg1zdXBlcnNlZGVkX2F0GA8gASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIMc3VwZXJzZWRlZEF0EjkKCmNyZWF0ZWRfYXQYECABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgRIAEoCVIJY3JlYX'
    'RlZEJ5');

@$core.Deprecated('Use dispositionCandidateDescriptor instead')
const DispositionCandidate$json = {
  '1': 'DispositionCandidate',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'record_class', '3': 3, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'rule_code', '3': 5, '4': 1, '5': 9, '10': 'ruleCode'},
    {'1': 'rule_revision', '3': 6, '4': 1, '5': 5, '10': 'ruleRevision'},
    {'1': 'authority', '3': 7, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'disposition',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionKind',
      '10': 'disposition'
    },
    {
      '1': 'anchor_date',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'anchorDate'
    },
    {
      '1': 'eligible_from',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'eligibleFrom'
    },
  ],
};

/// Descriptor for `DispositionCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispositionCandidateDescriptor = $convert.base64Decode(
    'ChREaXNwb3NpdGlvbkNhbmRpZGF0ZRIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEh0KCn'
    'BhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIhCgxyZWNvcmRfY2xhc3MYAyABKAlSC3JlY29y'
    'ZENsYXNzEiAKC2Rlc2NyaXB0aW9uGAQgASgJUgtkZXNjcmlwdGlvbhIbCglydWxlX2NvZGUYBS'
    'ABKAlSCHJ1bGVDb2RlEiMKDXJ1bGVfcmV2aXNpb24YBiABKAVSDHJ1bGVSZXZpc2lvbhIcCglh'
    'dXRob3JpdHkYByABKAlSCWF1dGhvcml0eRJICgtkaXNwb3NpdGlvbhgIIAEoDjImLmhlYWx0aG'
    'NhcmUucmVjb3Jkcy52MS5EaXNwb3NpdGlvbktpbmRSC2Rpc3Bvc2l0aW9uEjsKC2FuY2hvcl9k'
    'YXRlGAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYW5jaG9yRGF0ZRI/Cg1lbG'
    'lnaWJsZV9mcm9tGAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMZWxpZ2libGVG'
    'cm9t');

@$core.Deprecated('Use ineligibleDescriptor instead')
const Ineligible$json = {
  '1': 'Ineligible',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `Ineligible`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ineligibleDescriptor = $convert.base64Decode(
    'CgpJbmVsaWdpYmxlEhsKCXJlY29yZF9pZBgBIAEoCVIIcmVjb3JkSWQSFgoGcmVhc29uGAIgAS'
    'gJUgZyZWFzb24=');

@$core.Deprecated('Use dispositionListDescriptor instead')
const DispositionList$json = {
  '1': 'DispositionList',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'jurisdiction', '3': 3, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'disposition',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionKind',
      '10': 'disposition'
    },
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionCandidate',
      '10': 'items'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionState',
      '10': 'state'
    },
    {
      '1': 'prepared_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'preparedAt'
    },
    {'1': 'prepared_by', '3': 8, '4': 1, '5': 9, '10': 'preparedBy'},
    {
      '1': 'approved_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'approvedAt'
    },
    {'1': 'approved_by', '3': 10, '4': 1, '5': 9, '10': 'approvedBy'},
    {
      '1': 'executed_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'executedAt'
    },
    {'1': 'executed_by', '3': 12, '4': 1, '5': 9, '10': 'executedBy'},
    {'1': 'certificate', '3': 13, '4': 1, '5': 9, '10': 'certificate'},
    {'1': 'cancelled_reason', '3': 14, '4': 1, '5': 9, '10': 'cancelledReason'},
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `DispositionList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispositionListDescriptor = $convert.base64Decode(
    'Cg9EaXNwb3NpdGlvbkxpc3QSFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEhwKCXJlZmVyZW5jZR'
    'gCIAEoCVIJcmVmZXJlbmNlEiIKDGp1cmlzZGljdGlvbhgDIAEoCVIManVyaXNkaWN0aW9uEkgK'
    'C2Rpc3Bvc2l0aW9uGAQgASgOMiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uS2'
    'luZFILZGlzcG9zaXRpb24SQQoFaXRlbXMYBSADKAsyKy5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'RGlzcG9zaXRpb25DYW5kaWRhdGVSBWl0ZW1zEj0KBXN0YXRlGAYgASgOMicuaGVhbHRoY2FyZS'
    '5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uU3RhdGVSBXN0YXRlEjsKC3ByZXBhcmVkX2F0GAcgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcHJlcGFyZWRBdBIfCgtwcmVwYXJlZF9ieR'
    'gIIAEoCVIKcHJlcGFyZWRCeRI7CgthcHByb3ZlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQSHwoLYXBwcm92ZWRfYnkYCiABKAlSCmFwcHJvdmVkQn'
    'kSOwoLZXhlY3V0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpleGVj'
    'dXRlZEF0Eh8KC2V4ZWN1dGVkX2J5GAwgASgJUgpleGVjdXRlZEJ5EiAKC2NlcnRpZmljYXRlGA'
    '0gASgJUgtjZXJ0aWZpY2F0ZRIpChBjYW5jZWxsZWRfcmVhc29uGA4gASgJUg9jYW5jZWxsZWRS'
    'ZWFzb24SGAoHdmVyc2lvbhgPIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use physicalRecordDescriptor instead')
const PhysicalRecord$json = {
  '1': 'PhysicalRecord',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'volume', '3': 4, '4': 1, '5': 5, '10': 'volume'},
    {'1': 'record_class', '3': 5, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'jurisdiction', '3': 6, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.PhysicalState',
      '10': 'state'
    },
    {'1': 'home_location', '3': 9, '4': 1, '5': 9, '10': 'homeLocation'},
    {'1': 'current_location', '3': 10, '4': 1, '5': 9, '10': 'currentLocation'},
    {'1': 'custodian', '3': 11, '4': 1, '5': 9, '10': 'custodian'},
    {
      '1': 'checked_out_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedOutAt'
    },
    {'1': 'checked_out_by', '3': 13, '4': 1, '5': 9, '10': 'checkedOutBy'},
    {
      '1': 'due_back_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBackAt'
    },
    {'1': 'purpose', '3': 15, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'created_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 17, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 18, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `PhysicalRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List physicalRecordDescriptor = $convert.base64Decode(
    'Cg5QaHlzaWNhbFJlY29yZBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhwKCXJlZmVyZW'
    '5jZRgCIAEoCVIJcmVmZXJlbmNlEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIWCgZ2'
    'b2x1bWUYBCABKAVSBnZvbHVtZRIhCgxyZWNvcmRfY2xhc3MYBSABKAlSC3JlY29yZENsYXNzEi'
    'IKDGp1cmlzZGljdGlvbhgGIAEoCVIManVyaXNkaWN0aW9uEiAKC2Rlc2NyaXB0aW9uGAcgASgJ'
    'UgtkZXNjcmlwdGlvbhI6CgVzdGF0ZRgIIAEoDjIkLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5QaH'
    'lzaWNhbFN0YXRlUgVzdGF0ZRIjCg1ob21lX2xvY2F0aW9uGAkgASgJUgxob21lTG9jYXRpb24S'
    'KQoQY3VycmVudF9sb2NhdGlvbhgKIAEoCVIPY3VycmVudExvY2F0aW9uEhwKCWN1c3RvZGlhbh'
    'gLIAEoCVIJY3VzdG9kaWFuEkAKDmNoZWNrZWRfb3V0X2F0GAwgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIMY2hlY2tlZE91dEF0EiQKDmNoZWNrZWRfb3V0X2J5GA0gASgJUgxjaG'
    'Vja2VkT3V0QnkSOgoLZHVlX2JhY2tfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUglkdWVCYWNrQXQSGAoHcHVycG9zZRgPIAEoCVIHcHVycG9zZRI5CgpjcmVhdGVkX2F0GB'
    'AgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0Eh0KCmNyZWF0ZWRf'
    'YnkYESABKAlSCWNyZWF0ZWRCeRIYCgd2ZXJzaW9uGBIgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use certificateFieldDescriptor instead')
const CertificateField$json = {
  '1': 'CertificateField',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'required', '3': 3, '4': 1, '5': 8, '10': 'required'},
    {'1': 'source_path', '3': 4, '4': 1, '5': 9, '10': 'sourcePath'},
  ],
};

/// Descriptor for `CertificateField`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List certificateFieldDescriptor = $convert.base64Decode(
    'ChBDZXJ0aWZpY2F0ZUZpZWxkEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBW'
    'xhYmVsEhoKCHJlcXVpcmVkGAMgASgIUghyZXF1aXJlZBIfCgtzb3VyY2VfcGF0aBgEIAEoCVIK'
    'c291cmNlUGF0aA==');

@$core.Deprecated('Use certificateFormDescriptor instead')
const CertificateForm$json = {
  '1': 'CertificateForm',
  '2': [
    {'1': 'form_id', '3': 1, '4': 1, '5': 9, '10': 'formId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 4, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {'1': 'jurisdiction', '3': 6, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'fields',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateField',
      '10': 'fields'
    },
    {'1': 'issuer_role', '3': 8, '4': 1, '5': 9, '10': 'issuerRole'},
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

/// Descriptor for `CertificateForm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List certificateFormDescriptor = $convert.base64Decode(
    'Cg9DZXJ0aWZpY2F0ZUZvcm0SFwoHZm9ybV9pZBgBIAEoCVIGZm9ybUlkEhIKBGNvZGUYAiABKA'
    'lSBGNvZGUSEgoEbmFtZRgDIAEoCVIEbmFtZRIaCghyZXZpc2lvbhgEIAEoBVIIcmV2aXNpb24S'
    'OgoEa2luZBgFIAEoDjImLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5DZXJ0aWZpY2F0ZUtpbmRSBG'
    'tpbmQSIgoManVyaXNkaWN0aW9uGAYgASgJUgxqdXJpc2RpY3Rpb24SPwoGZmllbGRzGAcgAygL'
    'MicuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNlcnRpZmljYXRlRmllbGRSBmZpZWxkcxIfCgtpc3'
    'N1ZXJfcm9sZRgIIAEoCVIKaXNzdWVyUm9sZRIaCghhcHByb3ZlZBgJIAEoCFIIYXBwcm92ZWQS'
    'HwoLYXBwcm92ZWRfYnkYCiABKAlSCmFwcHJvdmVkQnkSOwoLYXBwcm92ZWRfYXQYCyABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphcHByb3ZlZEF0EkEKDmVmZmVjdGl2ZV9mcm9t'
    'GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbRI/Cg1zdX'
    'BlcnNlZGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMc3VwZXJzZWRl'
    'ZEF0EjkKCmNyZWF0ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcm'
    'VhdGVkQXQSHQoKY3JlYXRlZF9ieRgPIAEoCVIJY3JlYXRlZEJ5');

@$core.Deprecated('Use certificateVersionDescriptor instead')
const CertificateVersion$json = {
  '1': 'CertificateVersion',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 5, '10': 'version'},
    {
      '1': 'values',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateVersion.ValuesEntry',
      '10': 'values'
    },
    {
      '1': 'source_refs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateVersion.SourceRefsEntry',
      '10': 'sourceRefs'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'issuer_id', '3': 5, '4': 1, '5': 9, '10': 'issuerId'},
    {'1': 'issuer_name', '3': 6, '4': 1, '5': 9, '10': 'issuerName'},
    {'1': 'issuer_role', '3': 7, '4': 1, '5': 9, '10': 'issuerRole'},
    {
      '1': 'issued_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'issuedAt'
    },
    {'1': 'serial_number', '3': 9, '4': 1, '5': 9, '10': 'serialNumber'},
  ],
  '3': [
    CertificateVersion_ValuesEntry$json,
    CertificateVersion_SourceRefsEntry$json
  ],
};

@$core.Deprecated('Use certificateVersionDescriptor instead')
const CertificateVersion_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use certificateVersionDescriptor instead')
const CertificateVersion_SourceRefsEntry$json = {
  '1': 'SourceRefsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CertificateVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List certificateVersionDescriptor = $convert.base64Decode(
    'ChJDZXJ0aWZpY2F0ZVZlcnNpb24SGAoHdmVyc2lvbhgBIAEoBVIHdmVyc2lvbhJNCgZ2YWx1ZX'
    'MYAiADKAsyNS5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ2VydGlmaWNhdGVWZXJzaW9uLlZhbHVl'
    'c0VudHJ5UgZ2YWx1ZXMSWgoLc291cmNlX3JlZnMYAyADKAsyOS5oZWFsdGhjYXJlLnJlY29yZH'
    'MudjEuQ2VydGlmaWNhdGVWZXJzaW9uLlNvdXJjZVJlZnNFbnRyeVIKc291cmNlUmVmcxIWCgZy'
    'ZWFzb24YBCABKAlSBnJlYXNvbhIbCglpc3N1ZXJfaWQYBSABKAlSCGlzc3VlcklkEh8KC2lzc3'
    'Vlcl9uYW1lGAYgASgJUgppc3N1ZXJOYW1lEh8KC2lzc3Vlcl9yb2xlGAcgASgJUgppc3N1ZXJS'
    'b2xlEjcKCWlzc3VlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGlzc3'
    'VlZEF0EiMKDXNlcmlhbF9udW1iZXIYCSABKAlSDHNlcmlhbE51bWJlcho5CgtWYWx1ZXNFbnRy'
    'eRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgBGj0KD1NvdXJjZV'
    'JlZnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use statutoryCertificateDescriptor instead')
const StatutoryCertificate$json = {
  '1': 'StatutoryCertificate',
  '2': [
    {'1': 'certificate_id', '3': 1, '4': 1, '5': 9, '10': 'certificateId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {'1': 'form_code', '3': 3, '4': 1, '5': 9, '10': 'formCode'},
    {'1': 'form_revision', '3': 4, '4': 1, '5': 5, '10': 'formRevision'},
    {'1': 'jurisdiction', '3': 5, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'patient_id', '3': 6, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 7, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'versions',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateVersion',
      '10': 'versions'
    },
    {
      '1': 'state',
      '3': 9,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateState',
      '10': 'state'
    },
    {'1': 'void_reason', '3': 10, '4': 1, '5': 9, '10': 'voidReason'},
    {'1': 'voided_by', '3': 11, '4': 1, '5': 9, '10': 'voidedBy'},
    {
      '1': 'voided_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'voidedAt'
    },
    {
      '1': 'created_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `StatutoryCertificate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statutoryCertificateDescriptor = $convert.base64Decode(
    'ChRTdGF0dXRvcnlDZXJ0aWZpY2F0ZRIlCg5jZXJ0aWZpY2F0ZV9pZBgBIAEoCVINY2VydGlmaW'
    'NhdGVJZBI6CgRraW5kGAIgASgOMiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNlcnRpZmljYXRl'
    'S2luZFIEa2luZBIbCglmb3JtX2NvZGUYAyABKAlSCGZvcm1Db2RlEiMKDWZvcm1fcmV2aXNpb2'
    '4YBCABKAVSDGZvcm1SZXZpc2lvbhIiCgxqdXJpc2RpY3Rpb24YBSABKAlSDGp1cmlzZGljdGlv'
    'bhIdCgpwYXRpZW50X2lkGAYgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAcgASgJUg'
    'tlbmNvdW50ZXJJZBJFCgh2ZXJzaW9ucxgIIAMoCzIpLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5D'
    'ZXJ0aWZpY2F0ZVZlcnNpb25SCHZlcnNpb25zEj0KBXN0YXRlGAkgASgOMicuaGVhbHRoY2FyZS'
    '5yZWNvcmRzLnYxLkNlcnRpZmljYXRlU3RhdGVSBXN0YXRlEh8KC3ZvaWRfcmVhc29uGAogASgJ'
    'Ugp2b2lkUmVhc29uEhsKCXZvaWRlZF9ieRgLIAEoCVIIdm9pZGVkQnkSNwoJdm9pZGVkX2F0GA'
    'wgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIdm9pZGVkQXQSOQoKY3JlYXRlZF9h'
    'dBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIYCgd2ZXJzaW'
    '9uGA4gASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use draftChecklistRequestDescriptor instead')
const DraftChecklistRequest$json = {
  '1': 'DraftChecklistRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'encounter_class', '3': 4, '4': 1, '5': 9, '10': 'encounterClass'},
    {'1': 'specialty', '3': 5, '4': 1, '5': 9, '10': 'specialty'},
    {
      '1': 'items',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.ChecklistItem',
      '10': 'items'
    },
    {
      '1': 'effective_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `DraftChecklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftChecklistRequestDescriptor = $convert.base64Decode(
    'ChVEcmFmdENoZWNrbGlzdFJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgAS'
    'gJUgRuYW1lEhoKCHJldmlzaW9uGAMgASgFUghyZXZpc2lvbhInCg9lbmNvdW50ZXJfY2xhc3MY'
    'BCABKAlSDmVuY291bnRlckNsYXNzEhwKCXNwZWNpYWx0eRgFIAEoCVIJc3BlY2lhbHR5EjoKBW'
    'l0ZW1zGAYgAygLMiQuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNoZWNrbGlzdEl0ZW1SBWl0ZW1z'
    'EkEKDmVmZmVjdGl2ZV9mcm9tGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZW'
    'ZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use draftChecklistResponseDescriptor instead')
const DraftChecklistResponse$json = {
  '1': 'DraftChecklistResponse',
  '2': [
    {
      '1': 'checklist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ChartChecklist',
      '10': 'checklist'
    },
  ],
};

/// Descriptor for `DraftChecklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftChecklistResponseDescriptor =
    $convert.base64Decode(
        'ChZEcmFmdENoZWNrbGlzdFJlc3BvbnNlEkMKCWNoZWNrbGlzdBgBIAEoCzIlLmhlYWx0aGNhcm'
        'UucmVjb3Jkcy52MS5DaGFydENoZWNrbGlzdFIJY2hlY2tsaXN0');

@$core.Deprecated('Use approveChecklistRequestDescriptor instead')
const ApproveChecklistRequest$json = {
  '1': 'ApproveChecklistRequest',
  '2': [
    {'1': 'checklist_id', '3': 1, '4': 1, '5': 9, '10': 'checklistId'},
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

/// Descriptor for `ApproveChecklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveChecklistRequestDescriptor = $convert.base64Decode(
    'ChdBcHByb3ZlQ2hlY2tsaXN0UmVxdWVzdBIhCgxjaGVja2xpc3RfaWQYASABKAlSC2NoZWNrbG'
    'lzdElkEkEKDmVmZmVjdGl2ZV9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFINZWZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use approveChecklistResponseDescriptor instead')
const ApproveChecklistResponse$json = {
  '1': 'ApproveChecklistResponse',
  '2': [
    {
      '1': 'checklist',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ChartChecklist',
      '10': 'checklist'
    },
  ],
};

/// Descriptor for `ApproveChecklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveChecklistResponseDescriptor =
    $convert.base64Decode(
        'ChhBcHByb3ZlQ2hlY2tsaXN0UmVzcG9uc2USQwoJY2hlY2tsaXN0GAEgASgLMiUuaGVhbHRoY2'
        'FyZS5yZWNvcmRzLnYxLkNoYXJ0Q2hlY2tsaXN0UgljaGVja2xpc3Q=');

@$core.Deprecated('Use listChecklistsRequestDescriptor instead')
const ListChecklistsRequest$json = {
  '1': 'ListChecklistsRequest',
  '2': [
    {'1': 'encounter_class', '3': 1, '4': 1, '5': 9, '10': 'encounterClass'},
    {'1': 'live_only', '3': 2, '4': 1, '5': 8, '10': 'liveOnly'},
  ],
};

/// Descriptor for `ListChecklistsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChecklistsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2hlY2tsaXN0c1JlcXVlc3QSJwoPZW5jb3VudGVyX2NsYXNzGAEgASgJUg5lbmNvdW'
    '50ZXJDbGFzcxIbCglsaXZlX29ubHkYAiABKAhSCGxpdmVPbmx5');

@$core.Deprecated('Use listChecklistsResponseDescriptor instead')
const ListChecklistsResponse$json = {
  '1': 'ListChecklistsResponse',
  '2': [
    {
      '1': 'checklists',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.ChartChecklist',
      '10': 'checklists'
    },
  ],
};

/// Descriptor for `ListChecklistsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listChecklistsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0Q2hlY2tsaXN0c1Jlc3BvbnNlEkUKCmNoZWNrbGlzdHMYASADKAsyJS5oZWFsdGhjYX'
        'JlLnJlY29yZHMudjEuQ2hhcnRDaGVja2xpc3RSCmNoZWNrbGlzdHM=');

@$core.Deprecated('Use getChartGapsRequestDescriptor instead')
const GetChartGapsRequest$json = {
  '1': 'GetChartGapsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `GetChartGapsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChartGapsRequestDescriptor = $convert.base64Decode(
    'ChNHZXRDaGFydEdhcHNSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'Q=');

@$core.Deprecated('Use getChartGapsResponseDescriptor instead')
const GetChartGapsResponse$json = {
  '1': 'GetChartGapsResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ChartStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `GetChartGapsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChartGapsResponseDescriptor = $convert.base64Decode(
    'ChRHZXRDaGFydEdhcHNSZXNwb25zZRI6CgZzdGF0dXMYASABKAsyIi5oZWFsdGhjYXJlLnJlY2'
    '9yZHMudjEuQ2hhcnRTdGF0dXNSBnN0YXR1cw==');

@$core.Deprecated('Use raiseDeficienciesRequestDescriptor instead')
const RaiseDeficienciesRequest$json = {
  '1': 'RaiseDeficienciesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
  ],
};

/// Descriptor for `RaiseDeficienciesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseDeficienciesRequestDescriptor =
    $convert.base64Decode(
        'ChhSYWlzZURlZmljaWVuY2llc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW'
        '50ZXJJZA==');

@$core.Deprecated('Use raiseDeficienciesResponseDescriptor instead')
const RaiseDeficienciesResponse$json = {
  '1': 'RaiseDeficienciesResponse',
  '2': [
    {
      '1': 'raised',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'raised'
    },
  ],
};

/// Descriptor for `RaiseDeficienciesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseDeficienciesResponseDescriptor =
    $convert.base64Decode(
        'ChlSYWlzZURlZmljaWVuY2llc1Jlc3BvbnNlEjkKBnJhaXNlZBgBIAMoCzIhLmhlYWx0aGNhcm'
        'UucmVjb3Jkcy52MS5EZWZpY2llbmN5UgZyYWlzZWQ=');

@$core.Deprecated('Use raiseCodingQueryRequestDescriptor instead')
const RaiseCodingQueryRequest$json = {
  '1': 'RaiseCodingQueryRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'document_id', '3': 2, '4': 1, '5': 9, '10': 'documentId'},
    {'1': 'owner_id', '3': 3, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'due_by',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
  ],
};

/// Descriptor for `RaiseCodingQueryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCodingQueryRequestDescriptor = $convert.base64Decode(
    'ChdSYWlzZUNvZGluZ1F1ZXJ5UmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bn'
    'RlcklkEh8KC2RvY3VtZW50X2lkGAIgASgJUgpkb2N1bWVudElkEhkKCG93bmVyX2lkGAMgASgJ'
    'Ugdvd25lcklkEhYKBmRldGFpbBgEIAEoCVIGZGV0YWlsEjEKBmR1ZV9ieRgFIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBWR1ZUJ5');

@$core.Deprecated('Use raiseCodingQueryResponseDescriptor instead')
const RaiseCodingQueryResponse$json = {
  '1': 'RaiseCodingQueryResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `RaiseCodingQueryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List raiseCodingQueryResponseDescriptor =
    $convert.base64Decode(
        'ChhSYWlzZUNvZGluZ1F1ZXJ5UmVzcG9uc2USQQoKZGVmaWNpZW5jeRgBIAEoCzIhLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5EZWZpY2llbmN5UgpkZWZpY2llbmN5');

@$core.Deprecated('Use resolveDeficiencyRequestDescriptor instead')
const ResolveDeficiencyRequest$json = {
  '1': 'ResolveDeficiencyRequest',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'document_id', '3': 2, '4': 1, '5': 9, '10': 'documentId'},
  ],
};

/// Descriptor for `ResolveDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveDeficiencyRequestDescriptor =
    $convert.base64Decode(
        'ChhSZXNvbHZlRGVmaWNpZW5jeVJlcXVlc3QSIwoNZGVmaWNpZW5jeV9pZBgBIAEoCVIMZGVmaW'
        'NpZW5jeUlkEh8KC2RvY3VtZW50X2lkGAIgASgJUgpkb2N1bWVudElk');

@$core.Deprecated('Use resolveDeficiencyResponseDescriptor instead')
const ResolveDeficiencyResponse$json = {
  '1': 'ResolveDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `ResolveDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveDeficiencyResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXNvbHZlRGVmaWNpZW5jeVJlc3BvbnNlEkEKCmRlZmljaWVuY3kYASABKAsyIS5oZWFsdG'
        'hjYXJlLnJlY29yZHMudjEuRGVmaWNpZW5jeVIKZGVmaWNpZW5jeQ==');

@$core.Deprecated('Use waiveDeficiencyRequestDescriptor instead')
const WaiveDeficiencyRequest$json = {
  '1': 'WaiveDeficiencyRequest',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WaiveDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveDeficiencyRequestDescriptor =
    $convert.base64Decode(
        'ChZXYWl2ZURlZmljaWVuY3lSZXF1ZXN0EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZmljaW'
        'VuY3lJZBIWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use waiveDeficiencyResponseDescriptor instead')
const WaiveDeficiencyResponse$json = {
  '1': 'WaiveDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `WaiveDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waiveDeficiencyResponseDescriptor =
    $convert.base64Decode(
        'ChdXYWl2ZURlZmljaWVuY3lSZXNwb25zZRJBCgpkZWZpY2llbmN5GAEgASgLMiEuaGVhbHRoY2'
        'FyZS5yZWNvcmRzLnYxLkRlZmljaWVuY3lSCmRlZmljaWVuY3k=');

@$core.Deprecated('Use reassignDeficiencyRequestDescriptor instead')
const ReassignDeficiencyRequest$json = {
  '1': 'ReassignDeficiencyRequest',
  '2': [
    {'1': 'deficiency_id', '3': 1, '4': 1, '5': 9, '10': 'deficiencyId'},
    {'1': 'owner_id', '3': 2, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReassignDeficiencyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reassignDeficiencyRequestDescriptor = $convert.base64Decode(
    'ChlSZWFzc2lnbkRlZmljaWVuY3lSZXF1ZXN0EiMKDWRlZmljaWVuY3lfaWQYASABKAlSDGRlZm'
    'ljaWVuY3lJZBIZCghvd25lcl9pZBgCIAEoCVIHb3duZXJJZBIWCgZyZWFzb24YAyABKAlSBnJl'
    'YXNvbg==');

@$core.Deprecated('Use reassignDeficiencyResponseDescriptor instead')
const ReassignDeficiencyResponse$json = {
  '1': 'ReassignDeficiencyResponse',
  '2': [
    {
      '1': 'deficiency',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'deficiency'
    },
  ],
};

/// Descriptor for `ReassignDeficiencyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reassignDeficiencyResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWFzc2lnbkRlZmljaWVuY3lSZXNwb25zZRJBCgpkZWZpY2llbmN5GAEgASgLMiEuaGVhbH'
        'RoY2FyZS5yZWNvcmRzLnYxLkRlZmljaWVuY3lSCmRlZmljaWVuY3k=');

@$core.Deprecated('Use listDeficienciesRequestDescriptor instead')
const ListDeficienciesRequest$json = {
  '1': 'ListDeficienciesRequest',
  '2': [
    {'1': 'owner_id', '3': 1, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'state',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DeficiencyState',
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
    {'1': 'page_offset', '3': 9, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListDeficienciesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeficienciesRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0RGVmaWNpZW5jaWVzUmVxdWVzdBIZCghvd25lcl9pZBgBIAEoCVIHb3duZXJJZBIhCg'
    'xlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpm'
    'YWNpbGl0eUlkEjwKBXN0YXRlGAQgASgOMiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkRlZmljaW'
    'VuY3lTdGF0ZVIFc3RhdGUSGwoJb3Blbl9vbmx5GAUgASgIUghvcGVuT25seRIuCgRmcm9tGAYg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgHIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgIIAEoBVIIcGFnZVNpemUS'
    'HwoLcGFnZV9vZmZzZXQYCSABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listDeficienciesResponseDescriptor instead')
const ListDeficienciesResponse$json = {
  '1': 'ListDeficienciesResponse',
  '2': [
    {
      '1': 'deficiencies',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.Deficiency',
      '10': 'deficiencies'
    },
  ],
};

/// Descriptor for `ListDeficienciesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDeficienciesResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0RGVmaWNpZW5jaWVzUmVzcG9uc2USRQoMZGVmaWNpZW5jaWVzGAEgAygLMiEuaGVhbH'
        'RoY2FyZS5yZWNvcmRzLnYxLkRlZmljaWVuY3lSDGRlZmljaWVuY2llcw==');

@$core.Deprecated('Use getAgingReportRequestDescriptor instead')
const GetAgingReportRequest$json = {
  '1': 'GetAgingReportRequest',
  '2': [
    {'1': 'owner_id', '3': 1, '4': 1, '5': 9, '10': 'ownerId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetAgingReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAgingReportRequestDescriptor = $convert.base64Decode(
    'ChVHZXRBZ2luZ1JlcG9ydFJlcXVlc3QSGQoIb3duZXJfaWQYASABKAlSB293bmVySWQSHwoLZm'
    'FjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getAgingReportResponseDescriptor instead')
const GetAgingReportResponse$json = {
  '1': 'GetAgingReportResponse',
  '2': [
    {
      '1': 'buckets',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.AgeBucket',
      '10': 'buckets'
    },
  ],
};

/// Descriptor for `GetAgingReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAgingReportResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRBZ2luZ1JlcG9ydFJlc3BvbnNlEjoKB2J1Y2tldHMYASADKAsyIC5oZWFsdGhjYXJlLn'
        'JlY29yZHMudjEuQWdlQnVja2V0UgdidWNrZXRz');

@$core.Deprecated('Use getCompletionSummaryRequestDescriptor instead')
const GetCompletionSummaryRequest$json = {
  '1': 'GetCompletionSummaryRequest',
  '2': [
    {'1': 'encounter_ids', '3': 1, '4': 3, '5': 9, '10': 'encounterIds'},
  ],
};

/// Descriptor for `GetCompletionSummaryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCompletionSummaryRequestDescriptor =
    $convert.base64Decode(
        'ChtHZXRDb21wbGV0aW9uU3VtbWFyeVJlcXVlc3QSIwoNZW5jb3VudGVyX2lkcxgBIAMoCVIMZW'
        '5jb3VudGVySWRz');

@$core.Deprecated('Use getCompletionSummaryResponseDescriptor instead')
const GetCompletionSummaryResponse$json = {
  '1': 'GetCompletionSummaryResponse',
  '2': [
    {
      '1': 'summary',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CompletionSummary',
      '10': 'summary'
    },
  ],
};

/// Descriptor for `GetCompletionSummaryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCompletionSummaryResponseDescriptor =
    $convert.base64Decode(
        'ChxHZXRDb21wbGV0aW9uU3VtbWFyeVJlc3BvbnNlEkIKB3N1bW1hcnkYASABKAsyKC5oZWFsdG'
        'hjYXJlLnJlY29yZHMudjEuQ29tcGxldGlvblN1bW1hcnlSB3N1bW1hcnk=');

@$core.Deprecated('Use escalateOverdueDeficienciesRequestDescriptor instead')
const EscalateOverdueDeficienciesRequest$json = {
  '1': 'EscalateOverdueDeficienciesRequest',
};

/// Descriptor for `EscalateOverdueDeficienciesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueDeficienciesRequestDescriptor =
    $convert.base64Decode('CiJFc2NhbGF0ZU92ZXJkdWVEZWZpY2llbmNpZXNSZXF1ZXN0');

@$core.Deprecated('Use escalateOverdueDeficienciesResponseDescriptor instead')
const EscalateOverdueDeficienciesResponse$json = {
  '1': 'EscalateOverdueDeficienciesResponse',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
  ],
};

/// Descriptor for `EscalateOverdueDeficienciesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueDeficienciesResponseDescriptor =
    $convert.base64Decode(
        'CiNFc2NhbGF0ZU92ZXJkdWVEZWZpY2llbmNpZXNSZXNwb25zZRIWCgZyYWlzZWQYASABKAVSBn'
        'JhaXNlZA==');

@$core.Deprecated('Use assignCodesRequestDescriptor instead')
const AssignCodesRequest$json = {
  '1': 'AssignCodesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'codes',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.AssignedCode',
      '10': 'codes'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AssignCodesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCodesRequestDescriptor = $convert.base64Decode(
    'ChJBc3NpZ25Db2Rlc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZB'
    'I5CgVjb2RlcxgCIAMoCzIjLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Bc3NpZ25lZENvZGVSBWNv'
    'ZGVzEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use assignCodesResponseDescriptor instead')
const AssignCodesResponse$json = {
  '1': 'AssignCodesResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CodedEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `AssignCodesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignCodesResponseDescriptor = $convert.base64Decode(
    'ChNBc3NpZ25Db2Rlc1Jlc3BvbnNlEj0KB2VwaXNvZGUYASABKAsyIy5oZWFsdGhjYXJlLnJlY2'
    '9yZHMudjEuQ29kZWRFcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use finaliseCodingRequestDescriptor instead')
const FinaliseCodingRequest$json = {
  '1': 'FinaliseCodingRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `FinaliseCodingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finaliseCodingRequestDescriptor = $convert.base64Decode(
    'ChVGaW5hbGlzZUNvZGluZ1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlk');

@$core.Deprecated('Use finaliseCodingResponseDescriptor instead')
const FinaliseCodingResponse$json = {
  '1': 'FinaliseCodingResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CodedEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `FinaliseCodingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List finaliseCodingResponseDescriptor =
    $convert.base64Decode(
        'ChZGaW5hbGlzZUNvZGluZ1Jlc3BvbnNlEj0KB2VwaXNvZGUYASABKAsyIy5oZWFsdGhjYXJlLn'
        'JlY29yZHMudjEuQ29kZWRFcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use queryCodingRequestDescriptor instead')
const QueryCodingRequest$json = {
  '1': 'QueryCodingRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `QueryCodingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCodingRequestDescriptor =
    $convert.base64Decode(
        'ChJRdWVyeUNvZGluZ1JlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlk');

@$core.Deprecated('Use queryCodingResponseDescriptor instead')
const QueryCodingResponse$json = {
  '1': 'QueryCodingResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CodedEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `QueryCodingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryCodingResponseDescriptor = $convert.base64Decode(
    'ChNRdWVyeUNvZGluZ1Jlc3BvbnNlEj0KB2VwaXNvZGUYASABKAsyIy5oZWFsdGhjYXJlLnJlY2'
    '9yZHMudjEuQ29kZWRFcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use getCodedEpisodeRequestDescriptor instead')
const GetCodedEpisodeRequest$json = {
  '1': 'GetCodedEpisodeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `GetCodedEpisodeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCodedEpisodeRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRDb2RlZEVwaXNvZGVSZXF1ZXN0Eh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZGVJZA'
        '==');

@$core.Deprecated('Use getCodedEpisodeResponseDescriptor instead')
const GetCodedEpisodeResponse$json = {
  '1': 'GetCodedEpisodeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CodedEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `GetCodedEpisodeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCodedEpisodeResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRDb2RlZEVwaXNvZGVSZXNwb25zZRI9CgdlcGlzb2RlGAEgASgLMiMuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLkNvZGVkRXBpc29kZVIHZXBpc29kZQ==');

@$core.Deprecated('Use getCodingDiffRequestDescriptor instead')
const GetCodingDiffRequest$json = {
  '1': 'GetCodingDiffRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'before_revision', '3': 2, '4': 1, '5': 5, '10': 'beforeRevision'},
    {'1': 'after_revision', '3': 3, '4': 1, '5': 5, '10': 'afterRevision'},
  ],
};

/// Descriptor for `GetCodingDiffRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCodingDiffRequestDescriptor = $convert.base64Decode(
    'ChRHZXRDb2RpbmdEaWZmUmVxdWVzdBIdCgplcGlzb2RlX2lkGAEgASgJUgllcGlzb2RlSWQSJw'
    'oPYmVmb3JlX3JldmlzaW9uGAIgASgFUg5iZWZvcmVSZXZpc2lvbhIlCg5hZnRlcl9yZXZpc2lv'
    'bhgDIAEoBVINYWZ0ZXJSZXZpc2lvbg==');

@$core.Deprecated('Use getCodingDiffResponseDescriptor instead')
const GetCodingDiffResponse$json = {
  '1': 'GetCodingDiffResponse',
  '2': [
    {
      '1': 'changes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CodingChange',
      '10': 'changes'
    },
  ],
};

/// Descriptor for `GetCodingDiffResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCodingDiffResponseDescriptor = $convert.base64Decode(
    'ChVHZXRDb2RpbmdEaWZmUmVzcG9uc2USPQoHY2hhbmdlcxgBIAMoCzIjLmhlYWx0aGNhcmUucm'
    'Vjb3Jkcy52MS5Db2RpbmdDaGFuZ2VSB2NoYW5nZXM=');

@$core.Deprecated('Use requestReleaseRequestDescriptor instead')
const RequestReleaseRequest$json = {
  '1': 'RequestReleaseRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'purpose', '3': 3, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'authorisation',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Authorisation',
      '10': 'authorisation'
    },
    {
      '1': 'recipient',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Recipient',
      '10': 'recipient'
    },
    {
      '1': 'scope',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseScope',
      '10': 'scope'
    },
  ],
};

/// Descriptor for `RequestReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestReleaseRequestDescriptor = $convert.base64Decode(
    'ChVSZXF1ZXN0UmVsZWFzZVJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USHQ'
    'oKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEhgKB3B1cnBvc2UYAyABKAlSB3B1cnBvc2US'
    'SgoNYXV0aG9yaXNhdGlvbhgEIAEoCzIkLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5BdXRob3Jpc2'
    'F0aW9uUg1hdXRob3Jpc2F0aW9uEj4KCXJlY2lwaWVudBgFIAEoCzIgLmhlYWx0aGNhcmUucmVj'
    'b3Jkcy52MS5SZWNpcGllbnRSCXJlY2lwaWVudBI5CgVzY29wZRgGIAEoCzIjLmhlYWx0aGNhcm'
    'UucmVjb3Jkcy52MS5SZWxlYXNlU2NvcGVSBXNjb3Bl');

@$core.Deprecated('Use requestReleaseResponseDescriptor instead')
const RequestReleaseResponse$json = {
  '1': 'RequestReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'release'
    },
  ],
};

/// Descriptor for `RequestReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestReleaseResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXF1ZXN0UmVsZWFzZVJlc3BvbnNlEj8KB3JlbGVhc2UYASABKAsyJS5oZWFsdGhjYXJlLn'
        'JlY29yZHMudjEuUmVsZWFzZVJlcXVlc3RSB3JlbGVhc2U=');

@$core.Deprecated('Use approveReleaseRequestDescriptor instead')
const ApproveReleaseRequest$json = {
  '1': 'ApproveReleaseRequest',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
  ],
};

/// Descriptor for `ApproveReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveReleaseRequestDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlUmVsZWFzZVJlcXVlc3QSHQoKcmVsZWFzZV9pZBgBIAEoCVIJcmVsZWFzZUlk');

@$core.Deprecated('Use approveReleaseResponseDescriptor instead')
const ApproveReleaseResponse$json = {
  '1': 'ApproveReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'release'
    },
  ],
};

/// Descriptor for `ApproveReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveReleaseResponseDescriptor =
    $convert.base64Decode(
        'ChZBcHByb3ZlUmVsZWFzZVJlc3BvbnNlEj8KB3JlbGVhc2UYASABKAsyJS5oZWFsdGhjYXJlLn'
        'JlY29yZHMudjEuUmVsZWFzZVJlcXVlc3RSB3JlbGVhc2U=');

@$core.Deprecated('Use refuseReleaseRequestDescriptor instead')
const RefuseReleaseRequest$json = {
  '1': 'RefuseReleaseRequest',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RefuseReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refuseReleaseRequestDescriptor = $convert.base64Decode(
    'ChRSZWZ1c2VSZWxlYXNlUmVxdWVzdBIdCgpyZWxlYXNlX2lkGAEgASgJUglyZWxlYXNlSWQSFg'
    'oGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use refuseReleaseResponseDescriptor instead')
const RefuseReleaseResponse$json = {
  '1': 'RefuseReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'release'
    },
  ],
};

/// Descriptor for `RefuseReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List refuseReleaseResponseDescriptor = $convert.base64Decode(
    'ChVSZWZ1c2VSZWxlYXNlUmVzcG9uc2USPwoHcmVsZWFzZRgBIAEoCzIlLmhlYWx0aGNhcmUucm'
    'Vjb3Jkcy52MS5SZWxlYXNlUmVxdWVzdFIHcmVsZWFzZQ==');

@$core.Deprecated('Use assembleReleaseRequestDescriptor instead')
const AssembleReleaseRequest$json = {
  '1': 'AssembleReleaseRequest',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
  ],
};

/// Descriptor for `AssembleReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assembleReleaseRequestDescriptor =
    $convert.base64Decode(
        'ChZBc3NlbWJsZVJlbGVhc2VSZXF1ZXN0Eh0KCnJlbGVhc2VfaWQYASABKAlSCXJlbGVhc2VJZA'
        '==');

@$core.Deprecated('Use assembleReleaseResponseDescriptor instead')
const AssembleReleaseResponse$json = {
  '1': 'AssembleReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'release'
    },
  ],
};

/// Descriptor for `AssembleReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assembleReleaseResponseDescriptor =
    $convert.base64Decode(
        'ChdBc3NlbWJsZVJlbGVhc2VSZXNwb25zZRI/CgdyZWxlYXNlGAEgASgLMiUuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLlJlbGVhc2VSZXF1ZXN0UgdyZWxlYXNl');

@$core.Deprecated('Use sendReleaseRequestDescriptor instead')
const SendReleaseRequest$json = {
  '1': 'SendReleaseRequest',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
  ],
};

/// Descriptor for `SendReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendReleaseRequestDescriptor =
    $convert.base64Decode(
        'ChJTZW5kUmVsZWFzZVJlcXVlc3QSHQoKcmVsZWFzZV9pZBgBIAEoCVIJcmVsZWFzZUlk');

@$core.Deprecated('Use sendReleaseResponseDescriptor instead')
const SendReleaseResponse$json = {
  '1': 'SendReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'release'
    },
    {
      '1': 'disclosure',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Disclosure',
      '10': 'disclosure'
    },
  ],
};

/// Descriptor for `SendReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sendReleaseResponseDescriptor = $convert.base64Decode(
    'ChNTZW5kUmVsZWFzZVJlc3BvbnNlEj8KB3JlbGVhc2UYASABKAsyJS5oZWFsdGhjYXJlLnJlY2'
    '9yZHMudjEuUmVsZWFzZVJlcXVlc3RSB3JlbGVhc2USQQoKZGlzY2xvc3VyZRgCIAEoCzIhLmhl'
    'YWx0aGNhcmUucmVjb3Jkcy52MS5EaXNjbG9zdXJlUgpkaXNjbG9zdXJl');

@$core.Deprecated('Use listReleasesRequestDescriptor instead')
const ListReleasesRequest$json = {
  '1': 'ListReleasesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.ReleaseState',
      '10': 'state'
    },
    {'1': 'open_only', '3': 3, '4': 1, '5': 8, '10': 'openOnly'},
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
    {'1': 'page_offset', '3': 7, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListReleasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReleasesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVsZWFzZXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBI5Cg'
    'VzdGF0ZRgCIAEoDjIjLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWxlYXNlU3RhdGVSBXN0YXRl'
    'EhsKCW9wZW5fb25seRgDIAEoCFIIb3Blbk9ubHkSLgoEZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgJ0bxIbCglwYWdlX3NpemUYBiABKAVSCHBhZ2VTaXplEh8KC3BhZ2Vfb2Zmc2V0GA'
    'cgASgFUgpwYWdlT2Zmc2V0');

@$core.Deprecated('Use listReleasesResponseDescriptor instead')
const ListReleasesResponse$json = {
  '1': 'ListReleasesResponse',
  '2': [
    {
      '1': 'releases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.ReleaseRequest',
      '10': 'releases'
    },
  ],
};

/// Descriptor for `ListReleasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReleasesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVsZWFzZXNSZXNwb25zZRJBCghyZWxlYXNlcxgBIAMoCzIlLmhlYWx0aGNhcmUucm'
    'Vjb3Jkcy52MS5SZWxlYXNlUmVxdWVzdFIIcmVsZWFzZXM=');

@$core.Deprecated('Use recordDisclosureRequestDescriptor instead')
const RecordDisclosureRequest$json = {
  '1': 'RecordDisclosureRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DisclosureKind',
      '10': 'kind'
    },
    {'1': 'purpose', '3': 3, '4': 1, '5': 9, '10': 'purpose'},
    {'1': 'scope_summary', '3': 4, '4': 1, '5': 9, '10': 'scopeSummary'},
    {
      '1': 'recipient',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Recipient',
      '10': 'recipient'
    },
    {'1': 'items', '3': 6, '4': 1, '5': 5, '10': 'items'},
    {'1': 'pages', '3': 7, '4': 1, '5': 5, '10': 'pages'},
  ],
};

/// Descriptor for `RecordDisclosureRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDisclosureRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmREaXNjbG9zdXJlUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSOQoEa2luZBgCIAEoDjIlLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5EaXNjbG9zdXJlS2luZFIE'
    'a2luZBIYCgdwdXJwb3NlGAMgASgJUgdwdXJwb3NlEiMKDXNjb3BlX3N1bW1hcnkYBCABKAlSDH'
    'Njb3BlU3VtbWFyeRI+CglyZWNpcGllbnQYBSABKAsyIC5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'UmVjaXBpZW50UglyZWNpcGllbnQSFAoFaXRlbXMYBiABKAVSBWl0ZW1zEhQKBXBhZ2VzGAcgAS'
    'gFUgVwYWdlcw==');

@$core.Deprecated('Use recordDisclosureResponseDescriptor instead')
const RecordDisclosureResponse$json = {
  '1': 'RecordDisclosureResponse',
  '2': [
    {
      '1': 'disclosure',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.Disclosure',
      '10': 'disclosure'
    },
  ],
};

/// Descriptor for `RecordDisclosureResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDisclosureResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmREaXNjbG9zdXJlUmVzcG9uc2USQQoKZGlzY2xvc3VyZRgBIAEoCzIhLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5EaXNjbG9zdXJlUgpkaXNjbG9zdXJl');

@$core.Deprecated('Use listDisclosuresRequestDescriptor instead')
const ListDisclosuresRequest$json = {
  '1': 'ListDisclosuresRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'actor_id', '3': 2, '4': 1, '5': 9, '10': 'actorId'},
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
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 6, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListDisclosuresRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDisclosuresRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0RGlzY2xvc3VyZXNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IZCghhY3Rvcl9pZBgCIAEoCVIHYWN0b3JJZBIuCgRmcm9tGAMgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgFIAEoBVIIcGFnZVNpemUSHwoLcGFnZV9vZmZzZXQYBiAB'
    'KAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listDisclosuresResponseDescriptor instead')
const ListDisclosuresResponse$json = {
  '1': 'ListDisclosuresResponse',
  '2': [
    {
      '1': 'disclosures',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.Disclosure',
      '10': 'disclosures'
    },
  ],
};

/// Descriptor for `ListDisclosuresResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDisclosuresResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0RGlzY2xvc3VyZXNSZXNwb25zZRJDCgtkaXNjbG9zdXJlcxgBIAMoCzIhLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5EaXNjbG9zdXJlUgtkaXNjbG9zdXJlcw==');

@$core.Deprecated('Use draftRetentionRuleRequestDescriptor instead')
const DraftRetentionRuleRequest$json = {
  '1': 'DraftRetentionRuleRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {'1': 'record_class', '3': 4, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'jurisdiction', '3': 5, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'anchor',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.RetentionAnchor',
      '10': 'anchor'
    },
    {'1': 'retain_years', '3': 7, '4': 1, '5': 5, '10': 'retainYears'},
    {
      '1': 'disposition',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionKind',
      '10': 'disposition'
    },
    {'1': 'authority', '3': 9, '4': 1, '5': 9, '10': 'authority'},
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

/// Descriptor for `DraftRetentionRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftRetentionRuleRequestDescriptor = $convert.base64Decode(
    'ChlEcmFmdFJldGVudGlvblJ1bGVSZXF1ZXN0EhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZR'
    'gCIAEoCVIEbmFtZRIaCghyZXZpc2lvbhgDIAEoBVIIcmV2aXNpb24SIQoMcmVjb3JkX2NsYXNz'
    'GAQgASgJUgtyZWNvcmRDbGFzcxIiCgxqdXJpc2RpY3Rpb24YBSABKAlSDGp1cmlzZGljdGlvbh'
    'I+CgZhbmNob3IYBiABKA4yJi5oZWFsdGhjYXJlLnJlY29yZHMudjEuUmV0ZW50aW9uQW5jaG9y'
    'UgZhbmNob3ISIQoMcmV0YWluX3llYXJzGAcgASgFUgtyZXRhaW5ZZWFycxJICgtkaXNwb3NpdG'
    'lvbhgIIAEoDjImLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5EaXNwb3NpdGlvbktpbmRSC2Rpc3Bv'
    'c2l0aW9uEhwKCWF1dGhvcml0eRgJIAEoCVIJYXV0aG9yaXR5EkEKDmVmZmVjdGl2ZV9mcm9tGA'
    'ogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use draftRetentionRuleResponseDescriptor instead')
const DraftRetentionRuleResponse$json = {
  '1': 'DraftRetentionRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.RetentionRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `DraftRetentionRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftRetentionRuleResponseDescriptor =
    $convert.base64Decode(
        'ChpEcmFmdFJldGVudGlvblJ1bGVSZXNwb25zZRI4CgRydWxlGAEgASgLMiQuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLlJldGVudGlvblJ1bGVSBHJ1bGU=');

@$core.Deprecated('Use approveRetentionRuleRequestDescriptor instead')
const ApproveRetentionRuleRequest$json = {
  '1': 'ApproveRetentionRuleRequest',
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

/// Descriptor for `ApproveRetentionRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRetentionRuleRequestDescriptor =
    $convert.base64Decode(
        'ChtBcHByb3ZlUmV0ZW50aW9uUnVsZVJlcXVlc3QSFwoHcnVsZV9pZBgBIAEoCVIGcnVsZUlkEk'
        'EKDmVmZmVjdGl2ZV9mcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINZWZm'
        'ZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use approveRetentionRuleResponseDescriptor instead')
const ApproveRetentionRuleResponse$json = {
  '1': 'ApproveRetentionRuleResponse',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.RetentionRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `ApproveRetentionRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveRetentionRuleResponseDescriptor =
    $convert.base64Decode(
        'ChxBcHByb3ZlUmV0ZW50aW9uUnVsZVJlc3BvbnNlEjgKBHJ1bGUYASABKAsyJC5oZWFsdGhjYX'
        'JlLnJlY29yZHMudjEuUmV0ZW50aW9uUnVsZVIEcnVsZQ==');

@$core.Deprecated('Use listRetentionRulesRequestDescriptor instead')
const ListRetentionRulesRequest$json = {
  '1': 'ListRetentionRulesRequest',
  '2': [
    {'1': 'jurisdiction', '3': 1, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'record_class', '3': 2, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'live_only', '3': 3, '4': 1, '5': 8, '10': 'liveOnly'},
  ],
};

/// Descriptor for `ListRetentionRulesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRetentionRulesRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0UmV0ZW50aW9uUnVsZXNSZXF1ZXN0EiIKDGp1cmlzZGljdGlvbhgBIAEoCVIManVyaX'
    'NkaWN0aW9uEiEKDHJlY29yZF9jbGFzcxgCIAEoCVILcmVjb3JkQ2xhc3MSGwoJbGl2ZV9vbmx5'
    'GAMgASgIUghsaXZlT25seQ==');

@$core.Deprecated('Use listRetentionRulesResponseDescriptor instead')
const ListRetentionRulesResponse$json = {
  '1': 'ListRetentionRulesResponse',
  '2': [
    {
      '1': 'rules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.RetentionRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `ListRetentionRulesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRetentionRulesResponseDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UmV0ZW50aW9uUnVsZXNSZXNwb25zZRI6CgVydWxlcxgBIAMoCzIkLmhlYWx0aGNhcm'
        'UucmVjb3Jkcy52MS5SZXRlbnRpb25SdWxlUgVydWxlcw==');

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
  ],
};

/// Descriptor for `ReleaseHoldRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseHoldRequestDescriptor = $convert.base64Decode(
    'ChJSZWxlYXNlSG9sZFJlcXVlc3QSIQoMcmVjb3JkX2NsYXNzGAEgASgJUgtyZWNvcmRDbGFzcx'
    'IbCglyZWNvcmRfaWQYAiABKAlSCHJlY29yZElk');

@$core.Deprecated('Use releaseHoldResponseDescriptor instead')
const ReleaseHoldResponse$json = {
  '1': 'ReleaseHoldResponse',
};

/// Descriptor for `ReleaseHoldResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseHoldResponseDescriptor =
    $convert.base64Decode('ChNSZWxlYXNlSG9sZFJlc3BvbnNl');

@$core.Deprecated('Use sweepForDispositionRequestDescriptor instead')
const SweepForDispositionRequest$json = {
  '1': 'SweepForDispositionRequest',
  '2': [
    {'1': 'jurisdiction', '3': 1, '4': 1, '5': 9, '10': 'jurisdiction'},
  ],
};

/// Descriptor for `SweepForDispositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepForDispositionRequestDescriptor =
    $convert.base64Decode(
        'ChpTd2VlcEZvckRpc3Bvc2l0aW9uUmVxdWVzdBIiCgxqdXJpc2RpY3Rpb24YASABKAlSDGp1cm'
        'lzZGljdGlvbg==');

@$core.Deprecated('Use sweepForDispositionResponseDescriptor instead')
const SweepForDispositionResponse$json = {
  '1': 'SweepForDispositionResponse',
  '2': [
    {'1': 'jurisdiction', '3': 1, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'eligible',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionCandidate',
      '10': 'eligible'
    },
    {
      '1': 'ineligible',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.Ineligible',
      '10': 'ineligible'
    },
    {'1': 'swept', '3': 4, '4': 1, '5': 5, '10': 'swept'},
  ],
};

/// Descriptor for `SweepForDispositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepForDispositionResponseDescriptor = $convert.base64Decode(
    'ChtTd2VlcEZvckRpc3Bvc2l0aW9uUmVzcG9uc2USIgoManVyaXNkaWN0aW9uGAEgASgJUgxqdX'
    'Jpc2RpY3Rpb24SRwoIZWxpZ2libGUYAiADKAsyKy5oZWFsdGhjYXJlLnJlY29yZHMudjEuRGlz'
    'cG9zaXRpb25DYW5kaWRhdGVSCGVsaWdpYmxlEkEKCmluZWxpZ2libGUYAyADKAsyIS5oZWFsdG'
    'hjYXJlLnJlY29yZHMudjEuSW5lbGlnaWJsZVIKaW5lbGlnaWJsZRIUCgVzd2VwdBgEIAEoBVIF'
    'c3dlcHQ=');

@$core.Deprecated('Use prepareDispositionRequestDescriptor instead')
const PrepareDispositionRequest$json = {
  '1': 'PrepareDispositionRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'jurisdiction', '3': 2, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'disposition',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionKind',
      '10': 'disposition'
    },
    {'1': 'record_ids', '3': 4, '4': 3, '5': 9, '10': 'recordIds'},
  ],
};

/// Descriptor for `PrepareDispositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prepareDispositionRequestDescriptor = $convert.base64Decode(
    'ChlQcmVwYXJlRGlzcG9zaXRpb25SZXF1ZXN0EhwKCXJlZmVyZW5jZRgBIAEoCVIJcmVmZXJlbm'
    'NlEiIKDGp1cmlzZGljdGlvbhgCIAEoCVIManVyaXNkaWN0aW9uEkgKC2Rpc3Bvc2l0aW9uGAMg'
    'ASgOMiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uS2luZFILZGlzcG9zaXRpb2'
    '4SHQoKcmVjb3JkX2lkcxgEIAMoCVIJcmVjb3JkSWRz');

@$core.Deprecated('Use prepareDispositionResponseDescriptor instead')
const PrepareDispositionResponse$json = {
  '1': 'PrepareDispositionResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionList',
      '10': 'list'
    },
  ],
};

/// Descriptor for `PrepareDispositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prepareDispositionResponseDescriptor =
    $convert.base64Decode(
        'ChpQcmVwYXJlRGlzcG9zaXRpb25SZXNwb25zZRI6CgRsaXN0GAEgASgLMiYuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uTGlzdFIEbGlzdA==');

@$core.Deprecated('Use approveDispositionRequestDescriptor instead')
const ApproveDispositionRequest$json = {
  '1': 'ApproveDispositionRequest',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
  ],
};

/// Descriptor for `ApproveDispositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveDispositionRequestDescriptor =
    $convert.base64Decode(
        'ChlBcHByb3ZlRGlzcG9zaXRpb25SZXF1ZXN0EhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZA==');

@$core.Deprecated('Use approveDispositionResponseDescriptor instead')
const ApproveDispositionResponse$json = {
  '1': 'ApproveDispositionResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionList',
      '10': 'list'
    },
  ],
};

/// Descriptor for `ApproveDispositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveDispositionResponseDescriptor =
    $convert.base64Decode(
        'ChpBcHByb3ZlRGlzcG9zaXRpb25SZXNwb25zZRI6CgRsaXN0GAEgASgLMiYuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uTGlzdFIEbGlzdA==');

@$core.Deprecated('Use executeDispositionRequestDescriptor instead')
const ExecuteDispositionRequest$json = {
  '1': 'ExecuteDispositionRequest',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'certificate', '3': 2, '4': 1, '5': 9, '10': 'certificate'},
  ],
};

/// Descriptor for `ExecuteDispositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeDispositionRequestDescriptor =
    $convert.base64Decode(
        'ChlFeGVjdXRlRGlzcG9zaXRpb25SZXF1ZXN0EhcKB2xpc3RfaWQYASABKAlSBmxpc3RJZBIgCg'
        'tjZXJ0aWZpY2F0ZRgCIAEoCVILY2VydGlmaWNhdGU=');

@$core.Deprecated('Use executeDispositionResponseDescriptor instead')
const ExecuteDispositionResponse$json = {
  '1': 'ExecuteDispositionResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionList',
      '10': 'list'
    },
  ],
};

/// Descriptor for `ExecuteDispositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List executeDispositionResponseDescriptor =
    $convert.base64Decode(
        'ChpFeGVjdXRlRGlzcG9zaXRpb25SZXNwb25zZRI6CgRsaXN0GAEgASgLMiYuaGVhbHRoY2FyZS'
        '5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uTGlzdFIEbGlzdA==');

@$core.Deprecated('Use cancelDispositionRequestDescriptor instead')
const CancelDispositionRequest$json = {
  '1': 'CancelDispositionRequest',
  '2': [
    {'1': 'list_id', '3': 1, '4': 1, '5': 9, '10': 'listId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelDispositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelDispositionRequestDescriptor =
    $convert.base64Decode(
        'ChhDYW5jZWxEaXNwb3NpdGlvblJlcXVlc3QSFwoHbGlzdF9pZBgBIAEoCVIGbGlzdElkEhYKBn'
        'JlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use cancelDispositionResponseDescriptor instead')
const CancelDispositionResponse$json = {
  '1': 'CancelDispositionResponse',
  '2': [
    {
      '1': 'list',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionList',
      '10': 'list'
    },
  ],
};

/// Descriptor for `CancelDispositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelDispositionResponseDescriptor =
    $convert.base64Decode(
        'ChlDYW5jZWxEaXNwb3NpdGlvblJlc3BvbnNlEjoKBGxpc3QYASABKAsyJi5oZWFsdGhjYXJlLn'
        'JlY29yZHMudjEuRGlzcG9zaXRpb25MaXN0UgRsaXN0');

@$core.Deprecated('Use listDispositionListsRequestDescriptor instead')
const ListDispositionListsRequest$json = {
  '1': 'ListDispositionListsRequest',
  '2': [
    {
      '1': 'state',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.DispositionState',
      '10': 'state'
    },
    {'1': 'jurisdiction', '3': 2, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 4, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListDispositionListsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDispositionListsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0RGlzcG9zaXRpb25MaXN0c1JlcXVlc3QSPQoFc3RhdGUYASABKA4yJy5oZWFsdGhjYX'
    'JlLnJlY29yZHMudjEuRGlzcG9zaXRpb25TdGF0ZVIFc3RhdGUSIgoManVyaXNkaWN0aW9uGAIg'
    'ASgJUgxqdXJpc2RpY3Rpb24SGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZRIfCgtwYWdlX2'
    '9mZnNldBgEIAEoBVIKcGFnZU9mZnNldA==');

@$core.Deprecated('Use listDispositionListsResponseDescriptor instead')
const ListDispositionListsResponse$json = {
  '1': 'ListDispositionListsResponse',
  '2': [
    {
      '1': 'lists',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.DispositionList',
      '10': 'lists'
    },
  ],
};

/// Descriptor for `ListDispositionListsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDispositionListsResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0RGlzcG9zaXRpb25MaXN0c1Jlc3BvbnNlEjwKBWxpc3RzGAEgAygLMiYuaGVhbHRoY2'
        'FyZS5yZWNvcmRzLnYxLkRpc3Bvc2l0aW9uTGlzdFIFbGlzdHM=');

@$core.Deprecated('Use registerPhysicalRecordRequestDescriptor instead')
const RegisterPhysicalRecordRequest$json = {
  '1': 'RegisterPhysicalRecordRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'volume', '3': 3, '4': 1, '5': 5, '10': 'volume'},
    {'1': 'record_class', '3': 4, '4': 1, '5': 9, '10': 'recordClass'},
    {'1': 'jurisdiction', '3': 5, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '10': 'description'},
    {'1': 'home_location', '3': 7, '4': 1, '5': 9, '10': 'homeLocation'},
  ],
};

/// Descriptor for `RegisterPhysicalRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPhysicalRecordRequestDescriptor = $convert.base64Decode(
    'Ch1SZWdpc3RlclBoeXNpY2FsUmVjb3JkUmVxdWVzdBIcCglyZWZlcmVuY2UYASABKAlSCXJlZm'
    'VyZW5jZRIdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSFgoGdm9sdW1lGAMgASgFUgZ2'
    'b2x1bWUSIQoMcmVjb3JkX2NsYXNzGAQgASgJUgtyZWNvcmRDbGFzcxIiCgxqdXJpc2RpY3Rpb2'
    '4YBSABKAlSDGp1cmlzZGljdGlvbhIgCgtkZXNjcmlwdGlvbhgGIAEoCVILZGVzY3JpcHRpb24S'
    'IwoNaG9tZV9sb2NhdGlvbhgHIAEoCVIMaG9tZUxvY2F0aW9u');

@$core.Deprecated('Use registerPhysicalRecordResponseDescriptor instead')
const RegisterPhysicalRecordResponse$json = {
  '1': 'RegisterPhysicalRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `RegisterPhysicalRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPhysicalRecordResponseDescriptor =
    $convert.base64Decode(
        'Ch5SZWdpc3RlclBoeXNpY2FsUmVjb3JkUmVzcG9uc2USPQoGcmVjb3JkGAEgASgLMiUuaGVhbH'
        'RoY2FyZS5yZWNvcmRzLnYxLlBoeXNpY2FsUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use checkOutRecordRequestDescriptor instead')
const CheckOutRecordRequest$json = {
  '1': 'CheckOutRecordRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'custodian', '3': 2, '4': 1, '5': 9, '10': 'custodian'},
    {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
    {'1': 'purpose', '3': 4, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'due_back',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBack'
    },
  ],
};

/// Descriptor for `CheckOutRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkOutRecordRequestDescriptor = $convert.base64Decode(
    'ChVDaGVja091dFJlY29yZFJlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZBIcCg'
    'ljdXN0b2RpYW4YAiABKAlSCWN1c3RvZGlhbhIaCghsb2NhdGlvbhgDIAEoCVIIbG9jYXRpb24S'
    'GAoHcHVycG9zZRgEIAEoCVIHcHVycG9zZRI1CghkdWVfYmFjaxgFIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSB2R1ZUJhY2s=');

@$core.Deprecated('Use checkOutRecordResponseDescriptor instead')
const CheckOutRecordResponse$json = {
  '1': 'CheckOutRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `CheckOutRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkOutRecordResponseDescriptor =
    $convert.base64Decode(
        'ChZDaGVja091dFJlY29yZFJlc3BvbnNlEj0KBnJlY29yZBgBIAEoCzIlLmhlYWx0aGNhcmUucm'
        'Vjb3Jkcy52MS5QaHlzaWNhbFJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use checkInRecordRequestDescriptor instead')
const CheckInRecordRequest$json = {
  '1': 'CheckInRecordRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'location', '3': 2, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `CheckInRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInRecordRequestDescriptor = $convert.base64Decode(
    'ChRDaGVja0luUmVjb3JkUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhoKCG'
    'xvY2F0aW9uGAIgASgJUghsb2NhdGlvbg==');

@$core.Deprecated('Use checkInRecordResponseDescriptor instead')
const CheckInRecordResponse$json = {
  '1': 'CheckInRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `CheckInRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInRecordResponseDescriptor = $convert.base64Decode(
    'ChVDaGVja0luUmVjb3JkUmVzcG9uc2USPQoGcmVjb3JkGAEgASgLMiUuaGVhbHRoY2FyZS5yZW'
    'NvcmRzLnYxLlBoeXNpY2FsUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use markRecordMissingRequestDescriptor instead')
const MarkRecordMissingRequest$json = {
  '1': 'MarkRecordMissingRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `MarkRecordMissingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markRecordMissingRequestDescriptor =
    $convert.base64Decode(
        'ChhNYXJrUmVjb3JkTWlzc2luZ1JlcXVlc3QSGwoJcmVjb3JkX2lkGAEgASgJUghyZWNvcmRJZB'
        'IWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use markRecordMissingResponseDescriptor instead')
const MarkRecordMissingResponse$json = {
  '1': 'MarkRecordMissingResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `MarkRecordMissingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markRecordMissingResponseDescriptor =
    $convert.base64Decode(
        'ChlNYXJrUmVjb3JkTWlzc2luZ1Jlc3BvbnNlEj0KBnJlY29yZBgBIAEoCzIlLmhlYWx0aGNhcm'
        'UucmVjb3Jkcy52MS5QaHlzaWNhbFJlY29yZFIGcmVjb3Jk');

@$core.Deprecated('Use archiveRecordRequestDescriptor instead')
const ArchiveRecordRequest$json = {
  '1': 'ArchiveRecordRequest',
  '2': [
    {'1': 'record_id', '3': 1, '4': 1, '5': 9, '10': 'recordId'},
    {'1': 'location', '3': 2, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `ArchiveRecordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveRecordRequestDescriptor = $convert.base64Decode(
    'ChRBcmNoaXZlUmVjb3JkUmVxdWVzdBIbCglyZWNvcmRfaWQYASABKAlSCHJlY29yZElkEhoKCG'
    'xvY2F0aW9uGAIgASgJUghsb2NhdGlvbg==');

@$core.Deprecated('Use archiveRecordResponseDescriptor instead')
const ArchiveRecordResponse$json = {
  '1': 'ArchiveRecordResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `ArchiveRecordResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List archiveRecordResponseDescriptor = $convert.base64Decode(
    'ChVBcmNoaXZlUmVjb3JkUmVzcG9uc2USPQoGcmVjb3JkGAEgASgLMiUuaGVhbHRoY2FyZS5yZW'
    'NvcmRzLnYxLlBoeXNpY2FsUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use listPhysicalRecordsRequestDescriptor instead')
const ListPhysicalRecordsRequest$json = {
  '1': 'ListPhysicalRecordsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.PhysicalState',
      '10': 'state'
    },
    {'1': 'out_only', '3': 3, '4': 1, '5': 8, '10': 'outOnly'},
    {'1': 'overdue_only', '3': 4, '4': 1, '5': 8, '10': 'overdueOnly'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 6, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListPhysicalRecordsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhysicalRecordsRequestDescriptor = $convert.base64Decode(
    'ChpMaXN0UGh5c2ljYWxSZWNvcmRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW'
    '50SWQSOgoFc3RhdGUYAiABKA4yJC5oZWFsdGhjYXJlLnJlY29yZHMudjEuUGh5c2ljYWxTdGF0'
    'ZVIFc3RhdGUSGQoIb3V0X29ubHkYAyABKAhSB291dE9ubHkSIQoMb3ZlcmR1ZV9vbmx5GAQgAS'
    'gIUgtvdmVyZHVlT25seRIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXplEh8KC3BhZ2Vfb2Zm'
    'c2V0GAYgASgFUgpwYWdlT2Zmc2V0');

@$core.Deprecated('Use listPhysicalRecordsResponseDescriptor instead')
const ListPhysicalRecordsResponse$json = {
  '1': 'ListPhysicalRecordsResponse',
  '2': [
    {
      '1': 'records',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.PhysicalRecord',
      '10': 'records'
    },
  ],
};

/// Descriptor for `ListPhysicalRecordsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhysicalRecordsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UGh5c2ljYWxSZWNvcmRzUmVzcG9uc2USPwoHcmVjb3JkcxgBIAMoCzIlLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5QaHlzaWNhbFJlY29yZFIHcmVjb3Jkcw==');

@$core.Deprecated('Use draftCertificateFormRequestDescriptor instead')
const DraftCertificateFormRequest$json = {
  '1': 'DraftCertificateFormRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'revision', '3': 3, '4': 1, '5': 5, '10': 'revision'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {'1': 'jurisdiction', '3': 5, '4': 1, '5': 9, '10': 'jurisdiction'},
    {
      '1': 'fields',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateField',
      '10': 'fields'
    },
    {'1': 'issuer_role', '3': 7, '4': 1, '5': 9, '10': 'issuerRole'},
    {
      '1': 'effective_from',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `DraftCertificateFormRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftCertificateFormRequestDescriptor = $convert.base64Decode(
    'ChtEcmFmdENlcnRpZmljYXRlRm9ybVJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW'
    '1lGAIgASgJUgRuYW1lEhoKCHJldmlzaW9uGAMgASgFUghyZXZpc2lvbhI6CgRraW5kGAQgASgO'
    'MiYuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNlcnRpZmljYXRlS2luZFIEa2luZBIiCgxqdXJpc2'
    'RpY3Rpb24YBSABKAlSDGp1cmlzZGljdGlvbhI/CgZmaWVsZHMYBiADKAsyJy5oZWFsdGhjYXJl'
    'LnJlY29yZHMudjEuQ2VydGlmaWNhdGVGaWVsZFIGZmllbGRzEh8KC2lzc3Vlcl9yb2xlGAcgAS'
    'gJUgppc3N1ZXJSb2xlEkEKDmVmZmVjdGl2ZV9mcm9tGAggASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use draftCertificateFormResponseDescriptor instead')
const DraftCertificateFormResponse$json = {
  '1': 'DraftCertificateFormResponse',
  '2': [
    {
      '1': 'form',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateForm',
      '10': 'form'
    },
  ],
};

/// Descriptor for `DraftCertificateFormResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List draftCertificateFormResponseDescriptor =
    $convert.base64Decode(
        'ChxEcmFmdENlcnRpZmljYXRlRm9ybVJlc3BvbnNlEjoKBGZvcm0YASABKAsyJi5oZWFsdGhjYX'
        'JlLnJlY29yZHMudjEuQ2VydGlmaWNhdGVGb3JtUgRmb3Jt');

@$core.Deprecated('Use approveCertificateFormRequestDescriptor instead')
const ApproveCertificateFormRequest$json = {
  '1': 'ApproveCertificateFormRequest',
  '2': [
    {'1': 'form_id', '3': 1, '4': 1, '5': 9, '10': 'formId'},
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

/// Descriptor for `ApproveCertificateFormRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCertificateFormRequestDescriptor =
    $convert.base64Decode(
        'Ch1BcHByb3ZlQ2VydGlmaWNhdGVGb3JtUmVxdWVzdBIXCgdmb3JtX2lkGAEgASgJUgZmb3JtSW'
        'QSQQoOZWZmZWN0aXZlX2Zyb20YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1l'
        'ZmZlY3RpdmVGcm9t');

@$core.Deprecated('Use approveCertificateFormResponseDescriptor instead')
const ApproveCertificateFormResponse$json = {
  '1': 'ApproveCertificateFormResponse',
  '2': [
    {
      '1': 'form',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateForm',
      '10': 'form'
    },
  ],
};

/// Descriptor for `ApproveCertificateFormResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveCertificateFormResponseDescriptor =
    $convert.base64Decode(
        'Ch5BcHByb3ZlQ2VydGlmaWNhdGVGb3JtUmVzcG9uc2USOgoEZm9ybRgBIAEoCzImLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5DZXJ0aWZpY2F0ZUZvcm1SBGZvcm0=');

@$core.Deprecated('Use listCertificateFormsRequestDescriptor instead')
const ListCertificateFormsRequest$json = {
  '1': 'ListCertificateFormsRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {'1': 'jurisdiction', '3': 2, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'live_only', '3': 3, '4': 1, '5': 8, '10': 'liveOnly'},
  ],
};

/// Descriptor for `ListCertificateFormsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCertificateFormsRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Q2VydGlmaWNhdGVGb3Jtc1JlcXVlc3QSOgoEa2luZBgBIAEoDjImLmhlYWx0aGNhcm'
        'UucmVjb3Jkcy52MS5DZXJ0aWZpY2F0ZUtpbmRSBGtpbmQSIgoManVyaXNkaWN0aW9uGAIgASgJ'
        'UgxqdXJpc2RpY3Rpb24SGwoJbGl2ZV9vbmx5GAMgASgIUghsaXZlT25seQ==');

@$core.Deprecated('Use listCertificateFormsResponseDescriptor instead')
const ListCertificateFormsResponse$json = {
  '1': 'ListCertificateFormsResponse',
  '2': [
    {
      '1': 'forms',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CertificateForm',
      '10': 'forms'
    },
  ],
};

/// Descriptor for `ListCertificateFormsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCertificateFormsResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0Q2VydGlmaWNhdGVGb3Jtc1Jlc3BvbnNlEjwKBWZvcm1zGAEgAygLMiYuaGVhbHRoY2'
        'FyZS5yZWNvcmRzLnYxLkNlcnRpZmljYXRlRm9ybVIFZm9ybXM=');

@$core.Deprecated('Use issueCertificateRequestDescriptor instead')
const IssueCertificateRequest$json = {
  '1': 'IssueCertificateRequest',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {'1': 'jurisdiction', '3': 2, '4': 1, '5': 9, '10': 'jurisdiction'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'values',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.IssueCertificateRequest.ValuesEntry',
      '10': 'values'
    },
    {
      '1': 'source_refs',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.IssueCertificateRequest.SourceRefsEntry',
      '10': 'sourceRefs'
    },
    {'1': 'issuer_role', '3': 7, '4': 1, '5': 9, '10': 'issuerRole'},
    {'1': 'issuer_name', '3': 8, '4': 1, '5': 9, '10': 'issuerName'},
    {'1': 'serial_number', '3': 9, '4': 1, '5': 9, '10': 'serialNumber'},
  ],
  '3': [
    IssueCertificateRequest_ValuesEntry$json,
    IssueCertificateRequest_SourceRefsEntry$json
  ],
};

@$core.Deprecated('Use issueCertificateRequestDescriptor instead')
const IssueCertificateRequest_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use issueCertificateRequestDescriptor instead')
const IssueCertificateRequest_SourceRefsEntry$json = {
  '1': 'SourceRefsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `IssueCertificateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueCertificateRequestDescriptor = $convert.base64Decode(
    'ChdJc3N1ZUNlcnRpZmljYXRlUmVxdWVzdBI6CgRraW5kGAEgASgOMiYuaGVhbHRoY2FyZS5yZW'
    'NvcmRzLnYxLkNlcnRpZmljYXRlS2luZFIEa2luZBIiCgxqdXJpc2RpY3Rpb24YAiABKAlSDGp1'
    'cmlzZGljdGlvbhIdCgpwYXRpZW50X2lkGAMgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2'
    'lkGAQgASgJUgtlbmNvdW50ZXJJZBJSCgZ2YWx1ZXMYBSADKAsyOi5oZWFsdGhjYXJlLnJlY29y'
    'ZHMudjEuSXNzdWVDZXJ0aWZpY2F0ZVJlcXVlc3QuVmFsdWVzRW50cnlSBnZhbHVlcxJfCgtzb3'
    'VyY2VfcmVmcxgGIAMoCzI+LmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Jc3N1ZUNlcnRpZmljYXRl'
    'UmVxdWVzdC5Tb3VyY2VSZWZzRW50cnlSCnNvdXJjZVJlZnMSHwoLaXNzdWVyX3JvbGUYByABKA'
    'lSCmlzc3VlclJvbGUSHwoLaXNzdWVyX25hbWUYCCABKAlSCmlzc3Vlck5hbWUSIwoNc2VyaWFs'
    'X251bWJlchgJIAEoCVIMc2VyaWFsTnVtYmVyGjkKC1ZhbHVlc0VudHJ5EhAKA2tleRgBIAEoCV'
    'IDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAEaPQoPU291cmNlUmVmc0VudHJ5EhAKA2tl'
    'eRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use issueCertificateResponseDescriptor instead')
const IssueCertificateResponse$json = {
  '1': 'IssueCertificateResponse',
  '2': [
    {
      '1': 'certificate',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.StatutoryCertificate',
      '10': 'certificate'
    },
  ],
};

/// Descriptor for `IssueCertificateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List issueCertificateResponseDescriptor =
    $convert.base64Decode(
        'ChhJc3N1ZUNlcnRpZmljYXRlUmVzcG9uc2USTQoLY2VydGlmaWNhdGUYASABKAsyKy5oZWFsdG'
        'hjYXJlLnJlY29yZHMudjEuU3RhdHV0b3J5Q2VydGlmaWNhdGVSC2NlcnRpZmljYXRl');

@$core.Deprecated('Use correctCertificateRequestDescriptor instead')
const CorrectCertificateRequest$json = {
  '1': 'CorrectCertificateRequest',
  '2': [
    {'1': 'certificate_id', '3': 1, '4': 1, '5': 9, '10': 'certificateId'},
    {
      '1': 'values',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CorrectCertificateRequest.ValuesEntry',
      '10': 'values'
    },
    {
      '1': 'source_refs',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.CorrectCertificateRequest.SourceRefsEntry',
      '10': 'sourceRefs'
    },
    {'1': 'issuer_role', '3': 4, '4': 1, '5': 9, '10': 'issuerRole'},
    {'1': 'issuer_name', '3': 5, '4': 1, '5': 9, '10': 'issuerName'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'serial_number', '3': 7, '4': 1, '5': 9, '10': 'serialNumber'},
  ],
  '3': [
    CorrectCertificateRequest_ValuesEntry$json,
    CorrectCertificateRequest_SourceRefsEntry$json
  ],
};

@$core.Deprecated('Use correctCertificateRequestDescriptor instead')
const CorrectCertificateRequest_ValuesEntry$json = {
  '1': 'ValuesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

@$core.Deprecated('Use correctCertificateRequestDescriptor instead')
const CorrectCertificateRequest_SourceRefsEntry$json = {
  '1': 'SourceRefsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CorrectCertificateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctCertificateRequestDescriptor = $convert.base64Decode(
    'ChlDb3JyZWN0Q2VydGlmaWNhdGVSZXF1ZXN0EiUKDmNlcnRpZmljYXRlX2lkGAEgASgJUg1jZX'
    'J0aWZpY2F0ZUlkElQKBnZhbHVlcxgCIAMoCzI8LmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Db3Jy'
    'ZWN0Q2VydGlmaWNhdGVSZXF1ZXN0LlZhbHVlc0VudHJ5UgZ2YWx1ZXMSYQoLc291cmNlX3JlZn'
    'MYAyADKAsyQC5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ29ycmVjdENlcnRpZmljYXRlUmVxdWVz'
    'dC5Tb3VyY2VSZWZzRW50cnlSCnNvdXJjZVJlZnMSHwoLaXNzdWVyX3JvbGUYBCABKAlSCmlzc3'
    'VlclJvbGUSHwoLaXNzdWVyX25hbWUYBSABKAlSCmlzc3Vlck5hbWUSFgoGcmVhc29uGAYgASgJ'
    'UgZyZWFzb24SIwoNc2VyaWFsX251bWJlchgHIAEoCVIMc2VyaWFsTnVtYmVyGjkKC1ZhbHVlc0'
    'VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAEaPQoPU291'
    'cmNlUmVmc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOA'
    'E=');

@$core.Deprecated('Use correctCertificateResponseDescriptor instead')
const CorrectCertificateResponse$json = {
  '1': 'CorrectCertificateResponse',
  '2': [
    {
      '1': 'certificate',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.StatutoryCertificate',
      '10': 'certificate'
    },
  ],
};

/// Descriptor for `CorrectCertificateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctCertificateResponseDescriptor =
    $convert.base64Decode(
        'ChpDb3JyZWN0Q2VydGlmaWNhdGVSZXNwb25zZRJNCgtjZXJ0aWZpY2F0ZRgBIAEoCzIrLmhlYW'
        'x0aGNhcmUucmVjb3Jkcy52MS5TdGF0dXRvcnlDZXJ0aWZpY2F0ZVILY2VydGlmaWNhdGU=');

@$core.Deprecated('Use voidCertificateRequestDescriptor instead')
const VoidCertificateRequest$json = {
  '1': 'VoidCertificateRequest',
  '2': [
    {'1': 'certificate_id', '3': 1, '4': 1, '5': 9, '10': 'certificateId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `VoidCertificateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidCertificateRequestDescriptor =
    $convert.base64Decode(
        'ChZWb2lkQ2VydGlmaWNhdGVSZXF1ZXN0EiUKDmNlcnRpZmljYXRlX2lkGAEgASgJUg1jZXJ0aW'
        'ZpY2F0ZUlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use voidCertificateResponseDescriptor instead')
const VoidCertificateResponse$json = {
  '1': 'VoidCertificateResponse',
  '2': [
    {
      '1': 'certificate',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.records.v1.StatutoryCertificate',
      '10': 'certificate'
    },
  ],
};

/// Descriptor for `VoidCertificateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List voidCertificateResponseDescriptor =
    $convert.base64Decode(
        'ChdWb2lkQ2VydGlmaWNhdGVSZXNwb25zZRJNCgtjZXJ0aWZpY2F0ZRgBIAEoCzIrLmhlYWx0aG'
        'NhcmUucmVjb3Jkcy52MS5TdGF0dXRvcnlDZXJ0aWZpY2F0ZVILY2VydGlmaWNhdGU=');

@$core.Deprecated('Use listCertificatesRequestDescriptor instead')
const ListCertificatesRequest$json = {
  '1': 'ListCertificatesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateKind',
      '10': 'kind'
    },
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.records.v1.CertificateState',
      '10': 'state'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 5, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListCertificatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCertificatesRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0Q2VydGlmaWNhdGVzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSOgoEa2luZBgCIAEoDjImLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5DZXJ0aWZpY2F0ZUtpbmRS'
    'BGtpbmQSPQoFc3RhdGUYAyABKA4yJy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ2VydGlmaWNhdG'
    'VTdGF0ZVIFc3RhdGUSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZRIfCgtwYWdlX29mZnNl'
    'dBgFIAEoBVIKcGFnZU9mZnNldA==');

@$core.Deprecated('Use listCertificatesResponseDescriptor instead')
const ListCertificatesResponse$json = {
  '1': 'ListCertificatesResponse',
  '2': [
    {
      '1': 'certificates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.records.v1.StatutoryCertificate',
      '10': 'certificates'
    },
  ],
};

/// Descriptor for `ListCertificatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCertificatesResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0Q2VydGlmaWNhdGVzUmVzcG9uc2USTwoMY2VydGlmaWNhdGVzGAEgAygLMisuaGVhbH'
        'RoY2FyZS5yZWNvcmRzLnYxLlN0YXR1dG9yeUNlcnRpZmljYXRlUgxjZXJ0aWZpY2F0ZXM=');

const $core.Map<$core.String, $core.dynamic> RecordsServiceBase$json = {
  '1': 'RecordsService',
  '2': [
    {
      '1': 'DraftChecklist',
      '2': '.healthcare.records.v1.DraftChecklistRequest',
      '3': '.healthcare.records.v1.DraftChecklistResponse'
    },
    {
      '1': 'ApproveChecklist',
      '2': '.healthcare.records.v1.ApproveChecklistRequest',
      '3': '.healthcare.records.v1.ApproveChecklistResponse'
    },
    {
      '1': 'ListChecklists',
      '2': '.healthcare.records.v1.ListChecklistsRequest',
      '3': '.healthcare.records.v1.ListChecklistsResponse'
    },
    {
      '1': 'GetChartGaps',
      '2': '.healthcare.records.v1.GetChartGapsRequest',
      '3': '.healthcare.records.v1.GetChartGapsResponse'
    },
    {
      '1': 'RaiseDeficiencies',
      '2': '.healthcare.records.v1.RaiseDeficienciesRequest',
      '3': '.healthcare.records.v1.RaiseDeficienciesResponse'
    },
    {
      '1': 'RaiseCodingQuery',
      '2': '.healthcare.records.v1.RaiseCodingQueryRequest',
      '3': '.healthcare.records.v1.RaiseCodingQueryResponse'
    },
    {
      '1': 'ResolveDeficiency',
      '2': '.healthcare.records.v1.ResolveDeficiencyRequest',
      '3': '.healthcare.records.v1.ResolveDeficiencyResponse'
    },
    {
      '1': 'WaiveDeficiency',
      '2': '.healthcare.records.v1.WaiveDeficiencyRequest',
      '3': '.healthcare.records.v1.WaiveDeficiencyResponse'
    },
    {
      '1': 'ReassignDeficiency',
      '2': '.healthcare.records.v1.ReassignDeficiencyRequest',
      '3': '.healthcare.records.v1.ReassignDeficiencyResponse'
    },
    {
      '1': 'ListDeficiencies',
      '2': '.healthcare.records.v1.ListDeficienciesRequest',
      '3': '.healthcare.records.v1.ListDeficienciesResponse'
    },
    {
      '1': 'GetAgingReport',
      '2': '.healthcare.records.v1.GetAgingReportRequest',
      '3': '.healthcare.records.v1.GetAgingReportResponse'
    },
    {
      '1': 'GetCompletionSummary',
      '2': '.healthcare.records.v1.GetCompletionSummaryRequest',
      '3': '.healthcare.records.v1.GetCompletionSummaryResponse'
    },
    {
      '1': 'EscalateOverdueDeficiencies',
      '2': '.healthcare.records.v1.EscalateOverdueDeficienciesRequest',
      '3': '.healthcare.records.v1.EscalateOverdueDeficienciesResponse'
    },
    {
      '1': 'AssignCodes',
      '2': '.healthcare.records.v1.AssignCodesRequest',
      '3': '.healthcare.records.v1.AssignCodesResponse'
    },
    {
      '1': 'FinaliseCoding',
      '2': '.healthcare.records.v1.FinaliseCodingRequest',
      '3': '.healthcare.records.v1.FinaliseCodingResponse'
    },
    {
      '1': 'QueryCoding',
      '2': '.healthcare.records.v1.QueryCodingRequest',
      '3': '.healthcare.records.v1.QueryCodingResponse'
    },
    {
      '1': 'GetCodedEpisode',
      '2': '.healthcare.records.v1.GetCodedEpisodeRequest',
      '3': '.healthcare.records.v1.GetCodedEpisodeResponse'
    },
    {
      '1': 'GetCodingDiff',
      '2': '.healthcare.records.v1.GetCodingDiffRequest',
      '3': '.healthcare.records.v1.GetCodingDiffResponse'
    },
    {
      '1': 'RequestRelease',
      '2': '.healthcare.records.v1.RequestReleaseRequest',
      '3': '.healthcare.records.v1.RequestReleaseResponse'
    },
    {
      '1': 'ApproveRelease',
      '2': '.healthcare.records.v1.ApproveReleaseRequest',
      '3': '.healthcare.records.v1.ApproveReleaseResponse'
    },
    {
      '1': 'RefuseRelease',
      '2': '.healthcare.records.v1.RefuseReleaseRequest',
      '3': '.healthcare.records.v1.RefuseReleaseResponse'
    },
    {
      '1': 'AssembleRelease',
      '2': '.healthcare.records.v1.AssembleReleaseRequest',
      '3': '.healthcare.records.v1.AssembleReleaseResponse'
    },
    {
      '1': 'SendRelease',
      '2': '.healthcare.records.v1.SendReleaseRequest',
      '3': '.healthcare.records.v1.SendReleaseResponse'
    },
    {
      '1': 'ListReleases',
      '2': '.healthcare.records.v1.ListReleasesRequest',
      '3': '.healthcare.records.v1.ListReleasesResponse'
    },
    {
      '1': 'RecordDisclosure',
      '2': '.healthcare.records.v1.RecordDisclosureRequest',
      '3': '.healthcare.records.v1.RecordDisclosureResponse'
    },
    {
      '1': 'ListDisclosures',
      '2': '.healthcare.records.v1.ListDisclosuresRequest',
      '3': '.healthcare.records.v1.ListDisclosuresResponse'
    },
    {
      '1': 'DraftRetentionRule',
      '2': '.healthcare.records.v1.DraftRetentionRuleRequest',
      '3': '.healthcare.records.v1.DraftRetentionRuleResponse'
    },
    {
      '1': 'ApproveRetentionRule',
      '2': '.healthcare.records.v1.ApproveRetentionRuleRequest',
      '3': '.healthcare.records.v1.ApproveRetentionRuleResponse'
    },
    {
      '1': 'ListRetentionRules',
      '2': '.healthcare.records.v1.ListRetentionRulesRequest',
      '3': '.healthcare.records.v1.ListRetentionRulesResponse'
    },
    {
      '1': 'PlaceHold',
      '2': '.healthcare.records.v1.PlaceHoldRequest',
      '3': '.healthcare.records.v1.PlaceHoldResponse'
    },
    {
      '1': 'ReleaseHold',
      '2': '.healthcare.records.v1.ReleaseHoldRequest',
      '3': '.healthcare.records.v1.ReleaseHoldResponse'
    },
    {
      '1': 'SweepForDisposition',
      '2': '.healthcare.records.v1.SweepForDispositionRequest',
      '3': '.healthcare.records.v1.SweepForDispositionResponse'
    },
    {
      '1': 'PrepareDisposition',
      '2': '.healthcare.records.v1.PrepareDispositionRequest',
      '3': '.healthcare.records.v1.PrepareDispositionResponse'
    },
    {
      '1': 'ApproveDisposition',
      '2': '.healthcare.records.v1.ApproveDispositionRequest',
      '3': '.healthcare.records.v1.ApproveDispositionResponse'
    },
    {
      '1': 'ExecuteDisposition',
      '2': '.healthcare.records.v1.ExecuteDispositionRequest',
      '3': '.healthcare.records.v1.ExecuteDispositionResponse'
    },
    {
      '1': 'CancelDisposition',
      '2': '.healthcare.records.v1.CancelDispositionRequest',
      '3': '.healthcare.records.v1.CancelDispositionResponse'
    },
    {
      '1': 'ListDispositionLists',
      '2': '.healthcare.records.v1.ListDispositionListsRequest',
      '3': '.healthcare.records.v1.ListDispositionListsResponse'
    },
    {
      '1': 'RegisterPhysicalRecord',
      '2': '.healthcare.records.v1.RegisterPhysicalRecordRequest',
      '3': '.healthcare.records.v1.RegisterPhysicalRecordResponse'
    },
    {
      '1': 'CheckOutRecord',
      '2': '.healthcare.records.v1.CheckOutRecordRequest',
      '3': '.healthcare.records.v1.CheckOutRecordResponse'
    },
    {
      '1': 'CheckInRecord',
      '2': '.healthcare.records.v1.CheckInRecordRequest',
      '3': '.healthcare.records.v1.CheckInRecordResponse'
    },
    {
      '1': 'MarkRecordMissing',
      '2': '.healthcare.records.v1.MarkRecordMissingRequest',
      '3': '.healthcare.records.v1.MarkRecordMissingResponse'
    },
    {
      '1': 'ArchiveRecord',
      '2': '.healthcare.records.v1.ArchiveRecordRequest',
      '3': '.healthcare.records.v1.ArchiveRecordResponse'
    },
    {
      '1': 'ListPhysicalRecords',
      '2': '.healthcare.records.v1.ListPhysicalRecordsRequest',
      '3': '.healthcare.records.v1.ListPhysicalRecordsResponse'
    },
    {
      '1': 'DraftCertificateForm',
      '2': '.healthcare.records.v1.DraftCertificateFormRequest',
      '3': '.healthcare.records.v1.DraftCertificateFormResponse'
    },
    {
      '1': 'ApproveCertificateForm',
      '2': '.healthcare.records.v1.ApproveCertificateFormRequest',
      '3': '.healthcare.records.v1.ApproveCertificateFormResponse'
    },
    {
      '1': 'ListCertificateForms',
      '2': '.healthcare.records.v1.ListCertificateFormsRequest',
      '3': '.healthcare.records.v1.ListCertificateFormsResponse'
    },
    {
      '1': 'IssueCertificate',
      '2': '.healthcare.records.v1.IssueCertificateRequest',
      '3': '.healthcare.records.v1.IssueCertificateResponse'
    },
    {
      '1': 'CorrectCertificate',
      '2': '.healthcare.records.v1.CorrectCertificateRequest',
      '3': '.healthcare.records.v1.CorrectCertificateResponse'
    },
    {
      '1': 'VoidCertificate',
      '2': '.healthcare.records.v1.VoidCertificateRequest',
      '3': '.healthcare.records.v1.VoidCertificateResponse'
    },
    {
      '1': 'ListCertificates',
      '2': '.healthcare.records.v1.ListCertificatesRequest',
      '3': '.healthcare.records.v1.ListCertificatesResponse'
    },
  ],
};

@$core.Deprecated('Use recordsServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    RecordsServiceBase$messageJson = {
  '.healthcare.records.v1.DraftChecklistRequest': DraftChecklistRequest$json,
  '.healthcare.records.v1.ChecklistItem': ChecklistItem$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.records.v1.DraftChecklistResponse': DraftChecklistResponse$json,
  '.healthcare.records.v1.ChartChecklist': ChartChecklist$json,
  '.healthcare.records.v1.ApproveChecklistRequest':
      ApproveChecklistRequest$json,
  '.healthcare.records.v1.ApproveChecklistResponse':
      ApproveChecklistResponse$json,
  '.healthcare.records.v1.ListChecklistsRequest': ListChecklistsRequest$json,
  '.healthcare.records.v1.ListChecklistsResponse': ListChecklistsResponse$json,
  '.healthcare.records.v1.GetChartGapsRequest': GetChartGapsRequest$json,
  '.healthcare.records.v1.GetChartGapsResponse': GetChartGapsResponse$json,
  '.healthcare.records.v1.ChartStatus': ChartStatus$json,
  '.healthcare.records.v1.Gap': Gap$json,
  '.healthcare.records.v1.RaiseDeficienciesRequest':
      RaiseDeficienciesRequest$json,
  '.healthcare.records.v1.RaiseDeficienciesResponse':
      RaiseDeficienciesResponse$json,
  '.healthcare.records.v1.Deficiency': Deficiency$json,
  '.healthcare.records.v1.RaiseCodingQueryRequest':
      RaiseCodingQueryRequest$json,
  '.healthcare.records.v1.RaiseCodingQueryResponse':
      RaiseCodingQueryResponse$json,
  '.healthcare.records.v1.ResolveDeficiencyRequest':
      ResolveDeficiencyRequest$json,
  '.healthcare.records.v1.ResolveDeficiencyResponse':
      ResolveDeficiencyResponse$json,
  '.healthcare.records.v1.WaiveDeficiencyRequest': WaiveDeficiencyRequest$json,
  '.healthcare.records.v1.WaiveDeficiencyResponse':
      WaiveDeficiencyResponse$json,
  '.healthcare.records.v1.ReassignDeficiencyRequest':
      ReassignDeficiencyRequest$json,
  '.healthcare.records.v1.ReassignDeficiencyResponse':
      ReassignDeficiencyResponse$json,
  '.healthcare.records.v1.ListDeficienciesRequest':
      ListDeficienciesRequest$json,
  '.healthcare.records.v1.ListDeficienciesResponse':
      ListDeficienciesResponse$json,
  '.healthcare.records.v1.GetAgingReportRequest': GetAgingReportRequest$json,
  '.healthcare.records.v1.GetAgingReportResponse': GetAgingReportResponse$json,
  '.healthcare.records.v1.AgeBucket': AgeBucket$json,
  '.healthcare.records.v1.GetCompletionSummaryRequest':
      GetCompletionSummaryRequest$json,
  '.healthcare.records.v1.GetCompletionSummaryResponse':
      GetCompletionSummaryResponse$json,
  '.healthcare.records.v1.CompletionSummary': CompletionSummary$json,
  '.healthcare.records.v1.EscalateOverdueDeficienciesRequest':
      EscalateOverdueDeficienciesRequest$json,
  '.healthcare.records.v1.EscalateOverdueDeficienciesResponse':
      EscalateOverdueDeficienciesResponse$json,
  '.healthcare.records.v1.AssignCodesRequest': AssignCodesRequest$json,
  '.healthcare.records.v1.AssignedCode': AssignedCode$json,
  '.healthcare.records.v1.AssignCodesResponse': AssignCodesResponse$json,
  '.healthcare.records.v1.CodedEpisode': CodedEpisode$json,
  '.healthcare.records.v1.CodingRevision': CodingRevision$json,
  '.healthcare.records.v1.FinaliseCodingRequest': FinaliseCodingRequest$json,
  '.healthcare.records.v1.FinaliseCodingResponse': FinaliseCodingResponse$json,
  '.healthcare.records.v1.QueryCodingRequest': QueryCodingRequest$json,
  '.healthcare.records.v1.QueryCodingResponse': QueryCodingResponse$json,
  '.healthcare.records.v1.GetCodedEpisodeRequest': GetCodedEpisodeRequest$json,
  '.healthcare.records.v1.GetCodedEpisodeResponse':
      GetCodedEpisodeResponse$json,
  '.healthcare.records.v1.GetCodingDiffRequest': GetCodingDiffRequest$json,
  '.healthcare.records.v1.GetCodingDiffResponse': GetCodingDiffResponse$json,
  '.healthcare.records.v1.CodingChange': CodingChange$json,
  '.healthcare.records.v1.RequestReleaseRequest': RequestReleaseRequest$json,
  '.healthcare.records.v1.Authorisation': Authorisation$json,
  '.healthcare.records.v1.Recipient': Recipient$json,
  '.healthcare.records.v1.ReleaseScope': ReleaseScope$json,
  '.healthcare.records.v1.RequestReleaseResponse': RequestReleaseResponse$json,
  '.healthcare.records.v1.ReleaseRequest': ReleaseRequest$json,
  '.healthcare.records.v1.ReleasePackage': ReleasePackage$json,
  '.healthcare.records.v1.ReleaseItem': ReleaseItem$json,
  '.healthcare.records.v1.ApproveReleaseRequest': ApproveReleaseRequest$json,
  '.healthcare.records.v1.ApproveReleaseResponse': ApproveReleaseResponse$json,
  '.healthcare.records.v1.RefuseReleaseRequest': RefuseReleaseRequest$json,
  '.healthcare.records.v1.RefuseReleaseResponse': RefuseReleaseResponse$json,
  '.healthcare.records.v1.AssembleReleaseRequest': AssembleReleaseRequest$json,
  '.healthcare.records.v1.AssembleReleaseResponse':
      AssembleReleaseResponse$json,
  '.healthcare.records.v1.SendReleaseRequest': SendReleaseRequest$json,
  '.healthcare.records.v1.SendReleaseResponse': SendReleaseResponse$json,
  '.healthcare.records.v1.Disclosure': Disclosure$json,
  '.healthcare.records.v1.ListReleasesRequest': ListReleasesRequest$json,
  '.healthcare.records.v1.ListReleasesResponse': ListReleasesResponse$json,
  '.healthcare.records.v1.RecordDisclosureRequest':
      RecordDisclosureRequest$json,
  '.healthcare.records.v1.RecordDisclosureResponse':
      RecordDisclosureResponse$json,
  '.healthcare.records.v1.ListDisclosuresRequest': ListDisclosuresRequest$json,
  '.healthcare.records.v1.ListDisclosuresResponse':
      ListDisclosuresResponse$json,
  '.healthcare.records.v1.DraftRetentionRuleRequest':
      DraftRetentionRuleRequest$json,
  '.healthcare.records.v1.DraftRetentionRuleResponse':
      DraftRetentionRuleResponse$json,
  '.healthcare.records.v1.RetentionRule': RetentionRule$json,
  '.healthcare.records.v1.ApproveRetentionRuleRequest':
      ApproveRetentionRuleRequest$json,
  '.healthcare.records.v1.ApproveRetentionRuleResponse':
      ApproveRetentionRuleResponse$json,
  '.healthcare.records.v1.ListRetentionRulesRequest':
      ListRetentionRulesRequest$json,
  '.healthcare.records.v1.ListRetentionRulesResponse':
      ListRetentionRulesResponse$json,
  '.healthcare.records.v1.PlaceHoldRequest': PlaceHoldRequest$json,
  '.healthcare.records.v1.PlaceHoldResponse': PlaceHoldResponse$json,
  '.healthcare.records.v1.ReleaseHoldRequest': ReleaseHoldRequest$json,
  '.healthcare.records.v1.ReleaseHoldResponse': ReleaseHoldResponse$json,
  '.healthcare.records.v1.SweepForDispositionRequest':
      SweepForDispositionRequest$json,
  '.healthcare.records.v1.SweepForDispositionResponse':
      SweepForDispositionResponse$json,
  '.healthcare.records.v1.DispositionCandidate': DispositionCandidate$json,
  '.healthcare.records.v1.Ineligible': Ineligible$json,
  '.healthcare.records.v1.PrepareDispositionRequest':
      PrepareDispositionRequest$json,
  '.healthcare.records.v1.PrepareDispositionResponse':
      PrepareDispositionResponse$json,
  '.healthcare.records.v1.DispositionList': DispositionList$json,
  '.healthcare.records.v1.ApproveDispositionRequest':
      ApproveDispositionRequest$json,
  '.healthcare.records.v1.ApproveDispositionResponse':
      ApproveDispositionResponse$json,
  '.healthcare.records.v1.ExecuteDispositionRequest':
      ExecuteDispositionRequest$json,
  '.healthcare.records.v1.ExecuteDispositionResponse':
      ExecuteDispositionResponse$json,
  '.healthcare.records.v1.CancelDispositionRequest':
      CancelDispositionRequest$json,
  '.healthcare.records.v1.CancelDispositionResponse':
      CancelDispositionResponse$json,
  '.healthcare.records.v1.ListDispositionListsRequest':
      ListDispositionListsRequest$json,
  '.healthcare.records.v1.ListDispositionListsResponse':
      ListDispositionListsResponse$json,
  '.healthcare.records.v1.RegisterPhysicalRecordRequest':
      RegisterPhysicalRecordRequest$json,
  '.healthcare.records.v1.RegisterPhysicalRecordResponse':
      RegisterPhysicalRecordResponse$json,
  '.healthcare.records.v1.PhysicalRecord': PhysicalRecord$json,
  '.healthcare.records.v1.CheckOutRecordRequest': CheckOutRecordRequest$json,
  '.healthcare.records.v1.CheckOutRecordResponse': CheckOutRecordResponse$json,
  '.healthcare.records.v1.CheckInRecordRequest': CheckInRecordRequest$json,
  '.healthcare.records.v1.CheckInRecordResponse': CheckInRecordResponse$json,
  '.healthcare.records.v1.MarkRecordMissingRequest':
      MarkRecordMissingRequest$json,
  '.healthcare.records.v1.MarkRecordMissingResponse':
      MarkRecordMissingResponse$json,
  '.healthcare.records.v1.ArchiveRecordRequest': ArchiveRecordRequest$json,
  '.healthcare.records.v1.ArchiveRecordResponse': ArchiveRecordResponse$json,
  '.healthcare.records.v1.ListPhysicalRecordsRequest':
      ListPhysicalRecordsRequest$json,
  '.healthcare.records.v1.ListPhysicalRecordsResponse':
      ListPhysicalRecordsResponse$json,
  '.healthcare.records.v1.DraftCertificateFormRequest':
      DraftCertificateFormRequest$json,
  '.healthcare.records.v1.CertificateField': CertificateField$json,
  '.healthcare.records.v1.DraftCertificateFormResponse':
      DraftCertificateFormResponse$json,
  '.healthcare.records.v1.CertificateForm': CertificateForm$json,
  '.healthcare.records.v1.ApproveCertificateFormRequest':
      ApproveCertificateFormRequest$json,
  '.healthcare.records.v1.ApproveCertificateFormResponse':
      ApproveCertificateFormResponse$json,
  '.healthcare.records.v1.ListCertificateFormsRequest':
      ListCertificateFormsRequest$json,
  '.healthcare.records.v1.ListCertificateFormsResponse':
      ListCertificateFormsResponse$json,
  '.healthcare.records.v1.IssueCertificateRequest':
      IssueCertificateRequest$json,
  '.healthcare.records.v1.IssueCertificateRequest.ValuesEntry':
      IssueCertificateRequest_ValuesEntry$json,
  '.healthcare.records.v1.IssueCertificateRequest.SourceRefsEntry':
      IssueCertificateRequest_SourceRefsEntry$json,
  '.healthcare.records.v1.IssueCertificateResponse':
      IssueCertificateResponse$json,
  '.healthcare.records.v1.StatutoryCertificate': StatutoryCertificate$json,
  '.healthcare.records.v1.CertificateVersion': CertificateVersion$json,
  '.healthcare.records.v1.CertificateVersion.ValuesEntry':
      CertificateVersion_ValuesEntry$json,
  '.healthcare.records.v1.CertificateVersion.SourceRefsEntry':
      CertificateVersion_SourceRefsEntry$json,
  '.healthcare.records.v1.CorrectCertificateRequest':
      CorrectCertificateRequest$json,
  '.healthcare.records.v1.CorrectCertificateRequest.ValuesEntry':
      CorrectCertificateRequest_ValuesEntry$json,
  '.healthcare.records.v1.CorrectCertificateRequest.SourceRefsEntry':
      CorrectCertificateRequest_SourceRefsEntry$json,
  '.healthcare.records.v1.CorrectCertificateResponse':
      CorrectCertificateResponse$json,
  '.healthcare.records.v1.VoidCertificateRequest': VoidCertificateRequest$json,
  '.healthcare.records.v1.VoidCertificateResponse':
      VoidCertificateResponse$json,
  '.healthcare.records.v1.ListCertificatesRequest':
      ListCertificatesRequest$json,
  '.healthcare.records.v1.ListCertificatesResponse':
      ListCertificatesResponse$json,
};

/// Descriptor for `RecordsService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List recordsServiceDescriptor = $convert.base64Decode(
    'Cg5SZWNvcmRzU2VydmljZRJtCg5EcmFmdENoZWNrbGlzdBIsLmhlYWx0aGNhcmUucmVjb3Jkcy'
    '52MS5EcmFmdENoZWNrbGlzdFJlcXVlc3QaLS5oZWFsdGhjYXJlLnJlY29yZHMudjEuRHJhZnRD'
    'aGVja2xpc3RSZXNwb25zZRJzChBBcHByb3ZlQ2hlY2tsaXN0Ei4uaGVhbHRoY2FyZS5yZWNvcm'
    'RzLnYxLkFwcHJvdmVDaGVja2xpc3RSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFw'
    'cHJvdmVDaGVja2xpc3RSZXNwb25zZRJtCg5MaXN0Q2hlY2tsaXN0cxIsLmhlYWx0aGNhcmUucm'
    'Vjb3Jkcy52MS5MaXN0Q2hlY2tsaXN0c1JlcXVlc3QaLS5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'TGlzdENoZWNrbGlzdHNSZXNwb25zZRJnCgxHZXRDaGFydEdhcHMSKi5oZWFsdGhjYXJlLnJlY2'
    '9yZHMudjEuR2V0Q2hhcnRHYXBzUmVxdWVzdBorLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5HZXRD'
    'aGFydEdhcHNSZXNwb25zZRJ2ChFSYWlzZURlZmljaWVuY2llcxIvLmhlYWx0aGNhcmUucmVjb3'
    'Jkcy52MS5SYWlzZURlZmljaWVuY2llc1JlcXVlc3QaMC5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'UmFpc2VEZWZpY2llbmNpZXNSZXNwb25zZRJzChBSYWlzZUNvZGluZ1F1ZXJ5Ei4uaGVhbHRoY2'
    'FyZS5yZWNvcmRzLnYxLlJhaXNlQ29kaW5nUXVlcnlSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5yZWNv'
    'cmRzLnYxLlJhaXNlQ29kaW5nUXVlcnlSZXNwb25zZRJ2ChFSZXNvbHZlRGVmaWNpZW5jeRIvLm'
    'hlYWx0aGNhcmUucmVjb3Jkcy52MS5SZXNvbHZlRGVmaWNpZW5jeVJlcXVlc3QaMC5oZWFsdGhj'
    'YXJlLnJlY29yZHMudjEuUmVzb2x2ZURlZmljaWVuY3lSZXNwb25zZRJwCg9XYWl2ZURlZmljaW'
    'VuY3kSLS5oZWFsdGhjYXJlLnJlY29yZHMudjEuV2FpdmVEZWZpY2llbmN5UmVxdWVzdBouLmhl'
    'YWx0aGNhcmUucmVjb3Jkcy52MS5XYWl2ZURlZmljaWVuY3lSZXNwb25zZRJ5ChJSZWFzc2lnbk'
    'RlZmljaWVuY3kSMC5oZWFsdGhjYXJlLnJlY29yZHMudjEuUmVhc3NpZ25EZWZpY2llbmN5UmVx'
    'dWVzdBoxLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWFzc2lnbkRlZmljaWVuY3lSZXNwb25zZR'
    'JzChBMaXN0RGVmaWNpZW5jaWVzEi4uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3REZWZpY2ll'
    'bmNpZXNSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3REZWZpY2llbmNpZXNSZX'
    'Nwb25zZRJtCg5HZXRBZ2luZ1JlcG9ydBIsLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5HZXRBZ2lu'
    'Z1JlcG9ydFJlcXVlc3QaLS5oZWFsdGhjYXJlLnJlY29yZHMudjEuR2V0QWdpbmdSZXBvcnRSZX'
    'Nwb25zZRJ/ChRHZXRDb21wbGV0aW9uU3VtbWFyeRIyLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5H'
    'ZXRDb21wbGV0aW9uU3VtbWFyeVJlcXVlc3QaMy5oZWFsdGhjYXJlLnJlY29yZHMudjEuR2V0Q2'
    '9tcGxldGlvblN1bW1hcnlSZXNwb25zZRKUAQobRXNjYWxhdGVPdmVyZHVlRGVmaWNpZW5jaWVz'
    'EjkuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkVzY2FsYXRlT3ZlcmR1ZURlZmljaWVuY2llc1JlcX'
    'Vlc3QaOi5oZWFsdGhjYXJlLnJlY29yZHMudjEuRXNjYWxhdGVPdmVyZHVlRGVmaWNpZW5jaWVz'
    'UmVzcG9uc2USZAoLQXNzaWduQ29kZXMSKS5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXNzaWduQ2'
    '9kZXNSZXF1ZXN0GiouaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFzc2lnbkNvZGVzUmVzcG9uc2US'
    'bQoORmluYWxpc2VDb2RpbmcSLC5oZWFsdGhjYXJlLnJlY29yZHMudjEuRmluYWxpc2VDb2Rpbm'
    'dSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkZpbmFsaXNlQ29kaW5nUmVzcG9uc2US'
    'ZAoLUXVlcnlDb2RpbmcSKS5oZWFsdGhjYXJlLnJlY29yZHMudjEuUXVlcnlDb2RpbmdSZXF1ZX'
    'N0GiouaGVhbHRoY2FyZS5yZWNvcmRzLnYxLlF1ZXJ5Q29kaW5nUmVzcG9uc2UScAoPR2V0Q29k'
    'ZWRFcGlzb2RlEi0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkdldENvZGVkRXBpc29kZVJlcXVlc3'
    'QaLi5oZWFsdGhjYXJlLnJlY29yZHMudjEuR2V0Q29kZWRFcGlzb2RlUmVzcG9uc2USagoNR2V0'
    'Q29kaW5nRGlmZhIrLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5HZXRDb2RpbmdEaWZmUmVxdWVzdB'
    'osLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5HZXRDb2RpbmdEaWZmUmVzcG9uc2USbQoOUmVxdWVz'
    'dFJlbGVhc2USLC5oZWFsdGhjYXJlLnJlY29yZHMudjEuUmVxdWVzdFJlbGVhc2VSZXF1ZXN0Gi'
    '0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLlJlcXVlc3RSZWxlYXNlUmVzcG9uc2USbQoOQXBwcm92'
    'ZVJlbGVhc2USLC5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXBwcm92ZVJlbGVhc2VSZXF1ZXN0Gi'
    '0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFwcHJvdmVSZWxlYXNlUmVzcG9uc2USagoNUmVmdXNl'
    'UmVsZWFzZRIrLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWZ1c2VSZWxlYXNlUmVxdWVzdBosLm'
    'hlYWx0aGNhcmUucmVjb3Jkcy52MS5SZWZ1c2VSZWxlYXNlUmVzcG9uc2UScAoPQXNzZW1ibGVS'
    'ZWxlYXNlEi0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFzc2VtYmxlUmVsZWFzZVJlcXVlc3QaLi'
    '5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXNzZW1ibGVSZWxlYXNlUmVzcG9uc2USZAoLU2VuZFJl'
    'bGVhc2USKS5oZWFsdGhjYXJlLnJlY29yZHMudjEuU2VuZFJlbGVhc2VSZXF1ZXN0GiouaGVhbH'
    'RoY2FyZS5yZWNvcmRzLnYxLlNlbmRSZWxlYXNlUmVzcG9uc2USZwoMTGlzdFJlbGVhc2VzEiou'
    'aGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3RSZWxlYXNlc1JlcXVlc3QaKy5oZWFsdGhjYXJlLn'
    'JlY29yZHMudjEuTGlzdFJlbGVhc2VzUmVzcG9uc2UScwoQUmVjb3JkRGlzY2xvc3VyZRIuLmhl'
    'YWx0aGNhcmUucmVjb3Jkcy52MS5SZWNvcmREaXNjbG9zdXJlUmVxdWVzdBovLmhlYWx0aGNhcm'
    'UucmVjb3Jkcy52MS5SZWNvcmREaXNjbG9zdXJlUmVzcG9uc2UScAoPTGlzdERpc2Nsb3N1cmVz'
    'Ei0uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3REaXNjbG9zdXJlc1JlcXVlc3QaLi5oZWFsdG'
    'hjYXJlLnJlY29yZHMudjEuTGlzdERpc2Nsb3N1cmVzUmVzcG9uc2USeQoSRHJhZnRSZXRlbnRp'
    'b25SdWxlEjAuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkRyYWZ0UmV0ZW50aW9uUnVsZVJlcXVlc3'
    'QaMS5oZWFsdGhjYXJlLnJlY29yZHMudjEuRHJhZnRSZXRlbnRpb25SdWxlUmVzcG9uc2USfwoU'
    'QXBwcm92ZVJldGVudGlvblJ1bGUSMi5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXBwcm92ZVJldG'
    'VudGlvblJ1bGVSZXF1ZXN0GjMuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFwcHJvdmVSZXRlbnRp'
    'b25SdWxlUmVzcG9uc2USeQoSTGlzdFJldGVudGlvblJ1bGVzEjAuaGVhbHRoY2FyZS5yZWNvcm'
    'RzLnYxLkxpc3RSZXRlbnRpb25SdWxlc1JlcXVlc3QaMS5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'TGlzdFJldGVudGlvblJ1bGVzUmVzcG9uc2USXgoJUGxhY2VIb2xkEicuaGVhbHRoY2FyZS5yZW'
    'NvcmRzLnYxLlBsYWNlSG9sZFJlcXVlc3QaKC5oZWFsdGhjYXJlLnJlY29yZHMudjEuUGxhY2VI'
    'b2xkUmVzcG9uc2USZAoLUmVsZWFzZUhvbGQSKS5oZWFsdGhjYXJlLnJlY29yZHMudjEuUmVsZW'
    'FzZUhvbGRSZXF1ZXN0GiouaGVhbHRoY2FyZS5yZWNvcmRzLnYxLlJlbGVhc2VIb2xkUmVzcG9u'
    'c2USfAoTU3dlZXBGb3JEaXNwb3NpdGlvbhIxLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Td2VlcE'
    'ZvckRpc3Bvc2l0aW9uUmVxdWVzdBoyLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5Td2VlcEZvckRp'
    'c3Bvc2l0aW9uUmVzcG9uc2USeQoSUHJlcGFyZURpc3Bvc2l0aW9uEjAuaGVhbHRoY2FyZS5yZW'
    'NvcmRzLnYxLlByZXBhcmVEaXNwb3NpdGlvblJlcXVlc3QaMS5oZWFsdGhjYXJlLnJlY29yZHMu'
    'djEuUHJlcGFyZURpc3Bvc2l0aW9uUmVzcG9uc2USeQoSQXBwcm92ZURpc3Bvc2l0aW9uEjAuaG'
    'VhbHRoY2FyZS5yZWNvcmRzLnYxLkFwcHJvdmVEaXNwb3NpdGlvblJlcXVlc3QaMS5oZWFsdGhj'
    'YXJlLnJlY29yZHMudjEuQXBwcm92ZURpc3Bvc2l0aW9uUmVzcG9uc2USeQoSRXhlY3V0ZURpc3'
    'Bvc2l0aW9uEjAuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkV4ZWN1dGVEaXNwb3NpdGlvblJlcXVl'
    'c3QaMS5oZWFsdGhjYXJlLnJlY29yZHMudjEuRXhlY3V0ZURpc3Bvc2l0aW9uUmVzcG9uc2USdg'
    'oRQ2FuY2VsRGlzcG9zaXRpb24SLy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ2FuY2VsRGlzcG9z'
    'aXRpb25SZXF1ZXN0GjAuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNhbmNlbERpc3Bvc2l0aW9uUm'
    'VzcG9uc2USfwoUTGlzdERpc3Bvc2l0aW9uTGlzdHMSMi5oZWFsdGhjYXJlLnJlY29yZHMudjEu'
    'TGlzdERpc3Bvc2l0aW9uTGlzdHNSZXF1ZXN0GjMuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3'
    'REaXNwb3NpdGlvbkxpc3RzUmVzcG9uc2UShQEKFlJlZ2lzdGVyUGh5c2ljYWxSZWNvcmQSNC5o'
    'ZWFsdGhjYXJlLnJlY29yZHMudjEuUmVnaXN0ZXJQaHlzaWNhbFJlY29yZFJlcXVlc3QaNS5oZW'
    'FsdGhjYXJlLnJlY29yZHMudjEuUmVnaXN0ZXJQaHlzaWNhbFJlY29yZFJlc3BvbnNlEm0KDkNo'
    'ZWNrT3V0UmVjb3JkEiwuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkNoZWNrT3V0UmVjb3JkUmVxdW'
    'VzdBotLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5DaGVja091dFJlY29yZFJlc3BvbnNlEmoKDUNo'
    'ZWNrSW5SZWNvcmQSKy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ2hlY2tJblJlY29yZFJlcXVlc3'
    'QaLC5oZWFsdGhjYXJlLnJlY29yZHMudjEuQ2hlY2tJblJlY29yZFJlc3BvbnNlEnYKEU1hcmtS'
    'ZWNvcmRNaXNzaW5nEi8uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLk1hcmtSZWNvcmRNaXNzaW5nUm'
    'VxdWVzdBowLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5NYXJrUmVjb3JkTWlzc2luZ1Jlc3BvbnNl'
    'EmoKDUFyY2hpdmVSZWNvcmQSKy5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXJjaGl2ZVJlY29yZF'
    'JlcXVlc3QaLC5oZWFsdGhjYXJlLnJlY29yZHMudjEuQXJjaGl2ZVJlY29yZFJlc3BvbnNlEnwK'
    'E0xpc3RQaHlzaWNhbFJlY29yZHMSMS5oZWFsdGhjYXJlLnJlY29yZHMudjEuTGlzdFBoeXNpY2'
    'FsUmVjb3Jkc1JlcXVlc3QaMi5oZWFsdGhjYXJlLnJlY29yZHMudjEuTGlzdFBoeXNpY2FsUmVj'
    'b3Jkc1Jlc3BvbnNlEn8KFERyYWZ0Q2VydGlmaWNhdGVGb3JtEjIuaGVhbHRoY2FyZS5yZWNvcm'
    'RzLnYxLkRyYWZ0Q2VydGlmaWNhdGVGb3JtUmVxdWVzdBozLmhlYWx0aGNhcmUucmVjb3Jkcy52'
    'MS5EcmFmdENlcnRpZmljYXRlRm9ybVJlc3BvbnNlEoUBChZBcHByb3ZlQ2VydGlmaWNhdGVGb3'
    'JtEjQuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFwcHJvdmVDZXJ0aWZpY2F0ZUZvcm1SZXF1ZXN0'
    'GjUuaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkFwcHJvdmVDZXJ0aWZpY2F0ZUZvcm1SZXNwb25zZR'
    'J/ChRMaXN0Q2VydGlmaWNhdGVGb3JtcxIyLmhlYWx0aGNhcmUucmVjb3Jkcy52MS5MaXN0Q2Vy'
    'dGlmaWNhdGVGb3Jtc1JlcXVlc3QaMy5oZWFsdGhjYXJlLnJlY29yZHMudjEuTGlzdENlcnRpZm'
    'ljYXRlRm9ybXNSZXNwb25zZRJzChBJc3N1ZUNlcnRpZmljYXRlEi4uaGVhbHRoY2FyZS5yZWNv'
    'cmRzLnYxLklzc3VlQ2VydGlmaWNhdGVSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLk'
    'lzc3VlQ2VydGlmaWNhdGVSZXNwb25zZRJ5ChJDb3JyZWN0Q2VydGlmaWNhdGUSMC5oZWFsdGhj'
    'YXJlLnJlY29yZHMudjEuQ29ycmVjdENlcnRpZmljYXRlUmVxdWVzdBoxLmhlYWx0aGNhcmUucm'
    'Vjb3Jkcy52MS5Db3JyZWN0Q2VydGlmaWNhdGVSZXNwb25zZRJwCg9Wb2lkQ2VydGlmaWNhdGUS'
    'LS5oZWFsdGhjYXJlLnJlY29yZHMudjEuVm9pZENlcnRpZmljYXRlUmVxdWVzdBouLmhlYWx0aG'
    'NhcmUucmVjb3Jkcy52MS5Wb2lkQ2VydGlmaWNhdGVSZXNwb25zZRJzChBMaXN0Q2VydGlmaWNh'
    'dGVzEi4uaGVhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3RDZXJ0aWZpY2F0ZXNSZXF1ZXN0Gi8uaG'
    'VhbHRoY2FyZS5yZWNvcmRzLnYxLkxpc3RDZXJ0aWZpY2F0ZXNSZXNwb25zZQ==');
