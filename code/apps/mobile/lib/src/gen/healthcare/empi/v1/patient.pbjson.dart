// This is a generated file - do not edit.
//
// Generated from healthcare/empi/v1/patient.proto.

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

@$core.Deprecated('Use patientStatusDescriptor instead')
const PatientStatus$json = {
  '1': 'PatientStatus',
  '2': [
    {'1': 'PATIENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PATIENT_STATUS_CANDIDATE', '2': 1},
    {'1': 'PATIENT_STATUS_ACTIVE', '2': 2},
    {'1': 'PATIENT_STATUS_MERGED', '2': 3},
    {'1': 'PATIENT_STATUS_INACTIVE', '2': 4},
  ],
};

/// Descriptor for `PatientStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List patientStatusDescriptor = $convert.base64Decode(
    'Cg1QYXRpZW50U3RhdHVzEh4KGlBBVElFTlRfU1RBVFVTX1VOU1BFQ0lGSUVEEAASHAoYUEFUSU'
    'VOVF9TVEFUVVNfQ0FORElEQVRFEAESGQoVUEFUSUVOVF9TVEFUVVNfQUNUSVZFEAISGQoVUEFU'
    'SUVOVF9TVEFUVVNfTUVSR0VEEAMSGwoXUEFUSUVOVF9TVEFUVVNfSU5BQ1RJVkUQBA==');

@$core.Deprecated('Use sexDescriptor instead')
const Sex$json = {
  '1': 'Sex',
  '2': [
    {'1': 'SEX_UNSPECIFIED', '2': 0},
    {'1': 'SEX_UNKNOWN', '2': 1},
    {'1': 'SEX_FEMALE', '2': 2},
    {'1': 'SEX_MALE', '2': 3},
    {'1': 'SEX_OTHER', '2': 4},
  ],
};

/// Descriptor for `Sex`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sexDescriptor = $convert.base64Decode(
    'CgNTZXgSEwoPU0VYX1VOU1BFQ0lGSUVEEAASDwoLU0VYX1VOS05PV04QARIOCgpTRVhfRkVNQU'
    'xFEAISDAoIU0VYX01BTEUQAxINCglTRVhfT1RIRVIQBA==');

@$core.Deprecated('Use datePrecisionDescriptor instead')
const DatePrecision$json = {
  '1': 'DatePrecision',
  '2': [
    {'1': 'DATE_PRECISION_UNSPECIFIED', '2': 0},
    {'1': 'DATE_PRECISION_DAY', '2': 1},
    {'1': 'DATE_PRECISION_MONTH', '2': 2},
    {'1': 'DATE_PRECISION_YEAR', '2': 3},
    {'1': 'DATE_PRECISION_ESTIMATED', '2': 4},
  ],
};

/// Descriptor for `DatePrecision`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List datePrecisionDescriptor = $convert.base64Decode(
    'Cg1EYXRlUHJlY2lzaW9uEh4KGkRBVEVfUFJFQ0lTSU9OX1VOU1BFQ0lGSUVEEAASFgoSREFURV'
    '9QUkVDSVNJT05fREFZEAESGAoUREFURV9QUkVDSVNJT05fTU9OVEgQAhIXChNEQVRFX1BSRUNJ'
    'U0lPTl9ZRUFSEAMSHAoYREFURV9QUkVDSVNJT05fRVNUSU1BVEVEEAQ=');

@$core.Deprecated('Use identifierTypeDescriptor instead')
const IdentifierType$json = {
  '1': 'IdentifierType',
  '2': [
    {'1': 'IDENTIFIER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'IDENTIFIER_TYPE_MRN', '2': 1},
    {'1': 'IDENTIFIER_TYPE_NATIONAL_HEALTH', '2': 2},
    {'1': 'IDENTIFIER_TYPE_GOVERNMENT', '2': 3},
    {'1': 'IDENTIFIER_TYPE_INSURANCE', '2': 4},
    {'1': 'IDENTIFIER_TYPE_EXTERNAL', '2': 5},
  ],
};

/// Descriptor for `IdentifierType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List identifierTypeDescriptor = $convert.base64Decode(
    'Cg5JZGVudGlmaWVyVHlwZRIfChtJREVOVElGSUVSX1RZUEVfVU5TUEVDSUZJRUQQABIXChNJRE'
    'VOVElGSUVSX1RZUEVfTVJOEAESIwofSURFTlRJRklFUl9UWVBFX05BVElPTkFMX0hFQUxUSBAC'
    'Eh4KGklERU5USUZJRVJfVFlQRV9HT1ZFUk5NRU5UEAMSHQoZSURFTlRJRklFUl9UWVBFX0lOU1'
    'VSQU5DRRAEEhwKGElERU5USUZJRVJfVFlQRV9FWFRFUk5BTBAF');

@$core.Deprecated('Use identifierAssuranceDescriptor instead')
const IdentifierAssurance$json = {
  '1': 'IdentifierAssurance',
  '2': [
    {'1': 'IDENTIFIER_ASSURANCE_UNSPECIFIED', '2': 0},
    {'1': 'IDENTIFIER_ASSURANCE_ASSERTED', '2': 1},
    {'1': 'IDENTIFIER_ASSURANCE_VERIFIED', '2': 2},
  ],
};

/// Descriptor for `IdentifierAssurance`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List identifierAssuranceDescriptor = $convert.base64Decode(
    'ChNJZGVudGlmaWVyQXNzdXJhbmNlEiQKIElERU5USUZJRVJfQVNTVVJBTkNFX1VOU1BFQ0lGSU'
    'VEEAASIQodSURFTlRJRklFUl9BU1NVUkFOQ0VfQVNTRVJURUQQARIhCh1JREVOVElGSUVSX0FT'
    'U1VSQU5DRV9WRVJJRklFRBAC');

@$core.Deprecated('Use identifierStatusDescriptor instead')
const IdentifierStatus$json = {
  '1': 'IdentifierStatus',
  '2': [
    {'1': 'IDENTIFIER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'IDENTIFIER_STATUS_ACTIVE', '2': 1},
    {'1': 'IDENTIFIER_STATUS_SUPERSEDED', '2': 2},
    {'1': 'IDENTIFIER_STATUS_REVOKED', '2': 3},
  ],
};

/// Descriptor for `IdentifierStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List identifierStatusDescriptor = $convert.base64Decode(
    'ChBJZGVudGlmaWVyU3RhdHVzEiEKHUlERU5USUZJRVJfU1RBVFVTX1VOU1BFQ0lGSUVEEAASHA'
    'oYSURFTlRJRklFUl9TVEFUVVNfQUNUSVZFEAESIAocSURFTlRJRklFUl9TVEFUVVNfU1VQRVJT'
    'RURFRBACEh0KGUlERU5USUZJRVJfU1RBVFVTX1JFVk9LRUQQAw==');

@$core.Deprecated('Use contactSystemDescriptor instead')
const ContactSystem$json = {
  '1': 'ContactSystem',
  '2': [
    {'1': 'CONTACT_SYSTEM_UNSPECIFIED', '2': 0},
    {'1': 'CONTACT_SYSTEM_PHONE', '2': 1},
    {'1': 'CONTACT_SYSTEM_EMAIL', '2': 2},
  ],
};

/// Descriptor for `ContactSystem`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List contactSystemDescriptor = $convert.base64Decode(
    'Cg1Db250YWN0U3lzdGVtEh4KGkNPTlRBQ1RfU1lTVEVNX1VOU1BFQ0lGSUVEEAASGAoUQ09OVE'
    'FDVF9TWVNURU1fUEhPTkUQARIYChRDT05UQUNUX1NZU1RFTV9FTUFJTBAC');

@$core.Deprecated('Use proposalOriginDescriptor instead')
const ProposalOrigin$json = {
  '1': 'ProposalOrigin',
  '2': [
    {'1': 'PROPOSAL_ORIGIN_UNSPECIFIED', '2': 0},
    {'1': 'PROPOSAL_ORIGIN_EXTERNAL_SOURCE', '2': 1},
    {'1': 'PROPOSAL_ORIGIN_CORRECTION_REQUEST', '2': 2},
  ],
};

/// Descriptor for `ProposalOrigin`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List proposalOriginDescriptor = $convert.base64Decode(
    'Cg5Qcm9wb3NhbE9yaWdpbhIfChtQUk9QT1NBTF9PUklHSU5fVU5TUEVDSUZJRUQQABIjCh9QUk'
    '9QT1NBTF9PUklHSU5fRVhURVJOQUxfU09VUkNFEAESJgoiUFJPUE9TQUxfT1JJR0lOX0NPUlJF'
    'Q1RJT05fUkVRVUVTVBAC');

@$core.Deprecated('Use proposalStatusDescriptor instead')
const ProposalStatus$json = {
  '1': 'ProposalStatus',
  '2': [
    {'1': 'PROPOSAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PROPOSAL_STATUS_OPEN', '2': 1},
    {'1': 'PROPOSAL_STATUS_ACCEPTED', '2': 2},
    {'1': 'PROPOSAL_STATUS_REJECTED', '2': 3},
    {'1': 'PROPOSAL_STATUS_WITHDRAWN', '2': 4},
    {'1': 'PROPOSAL_STATUS_SUPERSEDED', '2': 5},
  ],
};

/// Descriptor for `ProposalStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List proposalStatusDescriptor = $convert.base64Decode(
    'Cg5Qcm9wb3NhbFN0YXR1cxIfChtQUk9QT1NBTF9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRQUk'
    '9QT1NBTF9TVEFUVVNfT1BFThABEhwKGFBST1BPU0FMX1NUQVRVU19BQ0NFUFRFRBACEhwKGFBS'
    'T1BPU0FMX1NUQVRVU19SRUpFQ1RFRBADEh0KGVBST1BPU0FMX1NUQVRVU19XSVRIRFJBV04QBB'
    'IeChpQUk9QT1NBTF9TVEFUVVNfU1VQRVJTRURFRBAF');

@$core.Deprecated('Use demographicFieldDescriptor instead')
const DemographicField$json = {
  '1': 'DemographicField',
  '2': [
    {'1': 'DEMOGRAPHIC_FIELD_UNSPECIFIED', '2': 0},
    {'1': 'DEMOGRAPHIC_FIELD_FAMILY_NAME', '2': 1},
    {'1': 'DEMOGRAPHIC_FIELD_GIVEN_NAME', '2': 2},
    {'1': 'DEMOGRAPHIC_FIELD_BIRTH_DATE', '2': 3},
    {'1': 'DEMOGRAPHIC_FIELD_SEX', '2': 4},
    {'1': 'DEMOGRAPHIC_FIELD_PHONE', '2': 5},
    {'1': 'DEMOGRAPHIC_FIELD_EMAIL', '2': 6},
    {'1': 'DEMOGRAPHIC_FIELD_ADDRESS', '2': 7},
  ],
};

/// Descriptor for `DemographicField`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List demographicFieldDescriptor = $convert.base64Decode(
    'ChBEZW1vZ3JhcGhpY0ZpZWxkEiEKHURFTU9HUkFQSElDX0ZJRUxEX1VOU1BFQ0lGSUVEEAASIQ'
    'odREVNT0dSQVBISUNfRklFTERfRkFNSUxZX05BTUUQARIgChxERU1PR1JBUEhJQ19GSUVMRF9H'
    'SVZFTl9OQU1FEAISIAocREVNT0dSQVBISUNfRklFTERfQklSVEhfREFURRADEhkKFURFTU9HUk'
    'FQSElDX0ZJRUxEX1NFWBAEEhsKF0RFTU9HUkFQSElDX0ZJRUxEX1BIT05FEAUSGwoXREVNT0dS'
    'QVBISUNfRklFTERfRU1BSUwQBhIdChlERU1PR1JBUEhJQ19GSUVMRF9BRERSRVNTEAc=');

@$core.Deprecated('Use matchOutcomeDescriptor instead')
const MatchOutcome$json = {
  '1': 'MatchOutcome',
  '2': [
    {'1': 'MATCH_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'MATCH_OUTCOME_DISTINCT', '2': 1},
    {'1': 'MATCH_OUTCOME_REVIEW', '2': 2},
    {'1': 'MATCH_OUTCOME_PROBABLE', '2': 3},
    {'1': 'MATCH_OUTCOME_CONFLICT', '2': 4},
  ],
};

/// Descriptor for `MatchOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List matchOutcomeDescriptor = $convert.base64Decode(
    'CgxNYXRjaE91dGNvbWUSHQoZTUFUQ0hfT1VUQ09NRV9VTlNQRUNJRklFRBAAEhoKFk1BVENIX0'
    '9VVENPTUVfRElTVElOQ1QQARIYChRNQVRDSF9PVVRDT01FX1JFVklFVxACEhoKFk1BVENIX09V'
    'VENPTUVfUFJPQkFCTEUQAxIaChZNQVRDSF9PVVRDT01FX0NPTkZMSUNUEAQ=');

@$core.Deprecated('Use reviewStatusDescriptor instead')
const ReviewStatus$json = {
  '1': 'ReviewStatus',
  '2': [
    {'1': 'REVIEW_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REVIEW_STATUS_OPEN', '2': 1},
    {'1': 'REVIEW_STATUS_MERGED', '2': 2},
    {'1': 'REVIEW_STATUS_DISMISSED', '2': 3},
  ],
};

/// Descriptor for `ReviewStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reviewStatusDescriptor = $convert.base64Decode(
    'CgxSZXZpZXdTdGF0dXMSHQoZUkVWSUVXX1NUQVRVU19VTlNQRUNJRklFRBAAEhYKElJFVklFV1'
    '9TVEFUVVNfT1BFThABEhgKFFJFVklFV19TVEFUVVNfTUVSR0VEEAISGwoXUkVWSUVXX1NUQVRV'
    'U19ESVNNSVNTRUQQAw==');

@$core.Deprecated('Use nameKindDescriptor instead')
const NameKind$json = {
  '1': 'NameKind',
  '2': [
    {'1': 'NAME_KIND_UNSPECIFIED', '2': 0},
    {'1': 'NAME_KIND_LEGAL', '2': 1},
    {'1': 'NAME_KIND_PREFERRED', '2': 2},
    {'1': 'NAME_KIND_ALIAS', '2': 3},
  ],
};

/// Descriptor for `NameKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List nameKindDescriptor = $convert.base64Decode(
    'CghOYW1lS2luZBIZChVOQU1FX0tJTkRfVU5TUEVDSUZJRUQQABITCg9OQU1FX0tJTkRfTEVHQU'
    'wQARIXChNOQU1FX0tJTkRfUFJFRkVSUkVEEAISEwoPTkFNRV9LSU5EX0FMSUFTEAM=');

@$core.Deprecated('Use communicationChannelDescriptor instead')
const CommunicationChannel$json = {
  '1': 'CommunicationChannel',
  '2': [
    {'1': 'COMMUNICATION_CHANNEL_UNSPECIFIED', '2': 0},
    {'1': 'COMMUNICATION_CHANNEL_SMS', '2': 1},
    {'1': 'COMMUNICATION_CHANNEL_EMAIL', '2': 2},
    {'1': 'COMMUNICATION_CHANNEL_PHONE', '2': 3},
    {'1': 'COMMUNICATION_CHANNEL_POST', '2': 4},
  ],
};

/// Descriptor for `CommunicationChannel`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List communicationChannelDescriptor = $convert.base64Decode(
    'ChRDb21tdW5pY2F0aW9uQ2hhbm5lbBIlCiFDT01NVU5JQ0FUSU9OX0NIQU5ORUxfVU5TUEVDSU'
    'ZJRUQQABIdChlDT01NVU5JQ0FUSU9OX0NIQU5ORUxfU01TEAESHwobQ09NTVVOSUNBVElPTl9D'
    'SEFOTkVMX0VNQUlMEAISHwobQ09NTVVOSUNBVElPTl9DSEFOTkVMX1BIT05FEAMSHgoaQ09NTV'
    'VOSUNBVElPTl9DSEFOTkVMX1BPU1QQBA==');

@$core.Deprecated('Use communicationPurposeDescriptor instead')
const CommunicationPurpose$json = {
  '1': 'CommunicationPurpose',
  '2': [
    {'1': 'COMMUNICATION_PURPOSE_UNSPECIFIED', '2': 0},
    {'1': 'COMMUNICATION_PURPOSE_APPOINTMENT_REMINDER', '2': 1},
    {'1': 'COMMUNICATION_PURPOSE_RESULTS', '2': 2},
    {'1': 'COMMUNICATION_PURPOSE_BILLING', '2': 3},
    {'1': 'COMMUNICATION_PURPOSE_HEALTH_PROMOTION', '2': 4},
  ],
};

/// Descriptor for `CommunicationPurpose`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List communicationPurposeDescriptor = $convert.base64Decode(
    'ChRDb21tdW5pY2F0aW9uUHVycG9zZRIlCiFDT01NVU5JQ0FUSU9OX1BVUlBPU0VfVU5TUEVDSU'
    'ZJRUQQABIuCipDT01NVU5JQ0FUSU9OX1BVUlBPU0VfQVBQT0lOVE1FTlRfUkVNSU5ERVIQARIh'
    'Ch1DT01NVU5JQ0FUSU9OX1BVUlBPU0VfUkVTVUxUUxACEiEKHUNPTU1VTklDQVRJT05fUFVSUE'
    '9TRV9CSUxMSU5HEAMSKgomQ09NTVVOSUNBVElPTl9QVVJQT1NFX0hFQUxUSF9QUk9NT1RJT04Q'
    'BA==');

@$core.Deprecated('Use relationshipTypeDescriptor instead')
const RelationshipType$json = {
  '1': 'RelationshipType',
  '2': [
    {'1': 'RELATIONSHIP_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'RELATIONSHIP_TYPE_PARENT', '2': 1},
    {'1': 'RELATIONSHIP_TYPE_GUARDIAN', '2': 2},
    {'1': 'RELATIONSHIP_TYPE_SPOUSE', '2': 3},
    {'1': 'RELATIONSHIP_TYPE_CHILD', '2': 4},
    {'1': 'RELATIONSHIP_TYPE_SIBLING', '2': 5},
    {'1': 'RELATIONSHIP_TYPE_CAREGIVER', '2': 6},
    {'1': 'RELATIONSHIP_TYPE_EMERGENCY_CONTACT', '2': 7},
  ],
};

/// Descriptor for `RelationshipType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List relationshipTypeDescriptor = $convert.base64Decode(
    'ChBSZWxhdGlvbnNoaXBUeXBlEiEKHVJFTEFUSU9OU0hJUF9UWVBFX1VOU1BFQ0lGSUVEEAASHA'
    'oYUkVMQVRJT05TSElQX1RZUEVfUEFSRU5UEAESHgoaUkVMQVRJT05TSElQX1RZUEVfR1VBUkRJ'
    'QU4QAhIcChhSRUxBVElPTlNISVBfVFlQRV9TUE9VU0UQAxIbChdSRUxBVElPTlNISVBfVFlQRV'
    '9DSElMRBAEEh0KGVJFTEFUSU9OU0hJUF9UWVBFX1NJQkxJTkcQBRIfChtSRUxBVElPTlNISVBf'
    'VFlQRV9DQVJFR0lWRVIQBhInCiNSRUxBVElPTlNISVBfVFlQRV9FTUVSR0VOQ1lfQ09OVEFDVB'
    'AH');

@$core.Deprecated('Use authorityDescriptor instead')
const Authority$json = {
  '1': 'Authority',
  '2': [
    {'1': 'AUTHORITY_UNSPECIFIED', '2': 0},
    {'1': 'AUTHORITY_VIEW_DEMOGRAPHICS', '2': 1},
    {'1': 'AUTHORITY_BOOK_APPOINTMENTS', '2': 2},
    {'1': 'AUTHORITY_VIEW_CLINICAL', '2': 3},
    {'1': 'AUTHORITY_RECEIVE_RESULTS', '2': 4},
    {'1': 'AUTHORITY_CONSENT', '2': 5},
  ],
};

/// Descriptor for `Authority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List authorityDescriptor = $convert.base64Decode(
    'CglBdXRob3JpdHkSGQoVQVVUSE9SSVRZX1VOU1BFQ0lGSUVEEAASHwobQVVUSE9SSVRZX1ZJRV'
    'dfREVNT0dSQVBISUNTEAESHwobQVVUSE9SSVRZX0JPT0tfQVBQT0lOVE1FTlRTEAISGwoXQVVU'
    'SE9SSVRZX1ZJRVdfQ0xJTklDQUwQAxIdChlBVVRIT1JJVFlfUkVDRUlWRV9SRVNVTFRTEAQSFQ'
    'oRQVVUSE9SSVRZX0NPTlNFTlQQBQ==');

@$core.Deprecated('Use partialDateDescriptor instead')
const PartialDate$json = {
  '1': 'PartialDate',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'date'
    },
    {
      '1': 'precision',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.DatePrecision',
      '10': 'precision'
    },
  ],
};

/// Descriptor for `PartialDate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List partialDateDescriptor = $convert.base64Decode(
    'CgtQYXJ0aWFsRGF0ZRIuCgRkYXRlGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IEZGF0ZRI/CglwcmVjaXNpb24YAiABKA4yIS5oZWFsdGhjYXJlLmVtcGkudjEuRGF0ZVByZWNp'
    'c2lvblIJcHJlY2lzaW9u');

@$core.Deprecated('Use humanNameDescriptor instead')
const HumanName$json = {
  '1': 'HumanName',
  '2': [
    {'1': 'family', '3': 1, '4': 1, '5': 9, '10': 'family'},
    {'1': 'given', '3': 2, '4': 3, '5': 9, '10': 'given'},
    {'1': 'prefix', '3': 3, '4': 1, '5': 9, '10': 'prefix'},
    {'1': 'suffix', '3': 4, '4': 1, '5': 9, '10': 'suffix'},
  ],
};

/// Descriptor for `HumanName`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List humanNameDescriptor = $convert.base64Decode(
    'CglIdW1hbk5hbWUSFgoGZmFtaWx5GAEgASgJUgZmYW1pbHkSFAoFZ2l2ZW4YAiADKAlSBWdpdm'
    'VuEhYKBnByZWZpeBgDIAEoCVIGcHJlZml4EhYKBnN1ZmZpeBgEIAEoCVIGc3VmZml4');

@$core.Deprecated('Use contactPointDescriptor instead')
const ContactPoint$json = {
  '1': 'ContactPoint',
  '2': [
    {
      '1': 'system',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.ContactSystem',
      '10': 'system'
    },
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
    {'1': 'use', '3': 3, '4': 1, '5': 9, '10': 'use'},
  ],
};

/// Descriptor for `ContactPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactPointDescriptor = $convert.base64Decode(
    'CgxDb250YWN0UG9pbnQSOQoGc3lzdGVtGAEgASgOMiEuaGVhbHRoY2FyZS5lbXBpLnYxLkNvbn'
    'RhY3RTeXN0ZW1SBnN5c3RlbRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWUSEAoDdXNlGAMgASgJUgN1'
    'c2U=');

@$core.Deprecated('Use addressDescriptor instead')
const Address$json = {
  '1': 'Address',
  '2': [
    {'1': 'lines', '3': 1, '4': 3, '5': 9, '10': 'lines'},
    {'1': 'city', '3': 2, '4': 1, '5': 9, '10': 'city'},
    {'1': 'district', '3': 3, '4': 1, '5': 9, '10': 'district'},
    {'1': 'state', '3': 4, '4': 1, '5': 9, '10': 'state'},
    {'1': 'postal_code', '3': 5, '4': 1, '5': 9, '10': 'postalCode'},
    {'1': 'country', '3': 6, '4': 1, '5': 9, '10': 'country'},
  ],
};

/// Descriptor for `Address`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addressDescriptor = $convert.base64Decode(
    'CgdBZGRyZXNzEhQKBWxpbmVzGAEgAygJUgVsaW5lcxISCgRjaXR5GAIgASgJUgRjaXR5EhoKCG'
    'Rpc3RyaWN0GAMgASgJUghkaXN0cmljdBIUCgVzdGF0ZRgEIAEoCVIFc3RhdGUSHwoLcG9zdGFs'
    'X2NvZGUYBSABKAlSCnBvc3RhbENvZGUSGAoHY291bnRyeRgGIAEoCVIHY291bnRyeQ==');

@$core.Deprecated('Use demographicsDescriptor instead')
const Demographics$json = {
  '1': 'Demographics',
  '2': [
    {
      '1': 'name',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.HumanName',
      '10': 'name'
    },
    {
      '1': 'birth_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PartialDate',
      '10': 'birthDate'
    },
    {
      '1': 'sex',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.Sex',
      '10': 'sex'
    },
    {
      '1': 'phones',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.ContactPoint',
      '10': 'phones'
    },
    {
      '1': 'emails',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.ContactPoint',
      '10': 'emails'
    },
    {
      '1': 'addresses',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.Address',
      '10': 'addresses'
    },
  ],
};

/// Descriptor for `Demographics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List demographicsDescriptor = $convert.base64Decode(
    'CgxEZW1vZ3JhcGhpY3MSMQoEbmFtZRgBIAEoCzIdLmhlYWx0aGNhcmUuZW1waS52MS5IdW1hbk'
    '5hbWVSBG5hbWUSPgoKYmlydGhfZGF0ZRgCIAEoCzIfLmhlYWx0aGNhcmUuZW1waS52MS5QYXJ0'
    'aWFsRGF0ZVIJYmlydGhEYXRlEikKA3NleBgDIAEoDjIXLmhlYWx0aGNhcmUuZW1waS52MS5TZX'
    'hSA3NleBI4CgZwaG9uZXMYBCADKAsyIC5oZWFsdGhjYXJlLmVtcGkudjEuQ29udGFjdFBvaW50'
    'UgZwaG9uZXMSOAoGZW1haWxzGAUgAygLMiAuaGVhbHRoY2FyZS5lbXBpLnYxLkNvbnRhY3RQb2'
    'ludFIGZW1haWxzEjkKCWFkZHJlc3NlcxgGIAMoCzIbLmhlYWx0aGNhcmUuZW1waS52MS5BZGRy'
    'ZXNzUglhZGRyZXNzZXM=');

@$core.Deprecated('Use patientIdentifierDescriptor instead')
const PatientIdentifier$json = {
  '1': 'PatientIdentifier',
  '2': [
    {'1': 'identifier_id', '3': 1, '4': 1, '5': 9, '10': 'identifierId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.IdentifierType',
      '10': 'type'
    },
    {'1': 'system', '3': 3, '4': 1, '5': 9, '10': 'system'},
    {'1': 'value', '3': 4, '4': 1, '5': 9, '10': 'value'},
    {
      '1': 'assigning_authority',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'assigningAuthority'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.IdentifierStatus',
      '10': 'status'
    },
    {'1': 'source', '3': 7, '4': 1, '5': 9, '10': 'source'},
    {'1': 'primary', '3': 8, '4': 1, '5': 8, '10': 'primary'},
    {
      '1': 'linked_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'linkedAt'
    },
    {
      '1': 'unlinked_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'unlinkedAt'
    },
    {'1': 'reason', '3': 11, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'assurance',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.IdentifierAssurance',
      '10': 'assurance'
    },
    {
      '1': 'verified_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'verifiedAt'
    },
  ],
};

/// Descriptor for `PatientIdentifier`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientIdentifierDescriptor = $convert.base64Decode(
    'ChFQYXRpZW50SWRlbnRpZmllchIjCg1pZGVudGlmaWVyX2lkGAEgASgJUgxpZGVudGlmaWVySW'
    'QSNgoEdHlwZRgCIAEoDjIiLmhlYWx0aGNhcmUuZW1waS52MS5JZGVudGlmaWVyVHlwZVIEdHlw'
    'ZRIWCgZzeXN0ZW0YAyABKAlSBnN5c3RlbRIUCgV2YWx1ZRgEIAEoCVIFdmFsdWUSLwoTYXNzaW'
    'duaW5nX2F1dGhvcml0eRgFIAEoCVISYXNzaWduaW5nQXV0aG9yaXR5EjwKBnN0YXR1cxgGIAEo'
    'DjIkLmhlYWx0aGNhcmUuZW1waS52MS5JZGVudGlmaWVyU3RhdHVzUgZzdGF0dXMSFgoGc291cm'
    'NlGAcgASgJUgZzb3VyY2USGAoHcHJpbWFyeRgIIAEoCFIHcHJpbWFyeRI3CglsaW5rZWRfYXQY'
    'CSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghsaW5rZWRBdBI7Cgt1bmxpbmtlZF'
    '9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnVubGlua2VkQXQSFgoGcmVh'
    'c29uGAsgASgJUgZyZWFzb24SRQoJYXNzdXJhbmNlGAwgASgOMicuaGVhbHRoY2FyZS5lbXBpLn'
    'YxLklkZW50aWZpZXJBc3N1cmFuY2VSCWFzc3VyYW5jZRI7Cgt2ZXJpZmllZF9hdBgNIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnZlcmlmaWVkQXQ=');

@$core.Deprecated('Use proposedFieldChangeDescriptor instead')
const ProposedFieldChange$json = {
  '1': 'ProposedFieldChange',
  '2': [
    {
      '1': 'field',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.DemographicField',
      '10': 'field'
    },
    {'1': 'current_value', '3': 2, '4': 1, '5': 9, '10': 'currentValue'},
    {'1': 'proposed_value', '3': 3, '4': 1, '5': 9, '10': 'proposedValue'},
    {
      '1': 'accepted',
      '3': 4,
      '4': 1,
      '5': 8,
      '9': 0,
      '10': 'accepted',
      '17': true
    },
  ],
  '8': [
    {'1': '_accepted'},
  ],
};

/// Descriptor for `ProposedFieldChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposedFieldChangeDescriptor = $convert.base64Decode(
    'ChNQcm9wb3NlZEZpZWxkQ2hhbmdlEjoKBWZpZWxkGAEgASgOMiQuaGVhbHRoY2FyZS5lbXBpLn'
    'YxLkRlbW9ncmFwaGljRmllbGRSBWZpZWxkEiMKDWN1cnJlbnRfdmFsdWUYAiABKAlSDGN1cnJl'
    'bnRWYWx1ZRIlCg5wcm9wb3NlZF92YWx1ZRgDIAEoCVINcHJvcG9zZWRWYWx1ZRIfCghhY2NlcH'
    'RlZBgEIAEoCEgAUghhY2NlcHRlZIgBAUILCglfYWNjZXB0ZWQ=');

@$core.Deprecated('Use demographicProposalDescriptor instead')
const DemographicProposal$json = {
  '1': 'DemographicProposal',
  '2': [
    {'1': 'proposal_id', '3': 1, '4': 1, '5': 9, '10': 'proposalId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'origin',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.ProposalOrigin',
      '10': 'origin'
    },
    {'1': 'source', '3': 4, '4': 1, '5': 9, '10': 'source'},
    {'1': 'proposed_by', '3': 5, '4': 1, '5': 9, '10': 'proposedBy'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.ProposalStatus',
      '10': 'status'
    },
    {
      '1': 'fields',
      '3': 8,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.ProposedFieldChange',
      '10': 'fields'
    },
    {'1': 'patient_version', '3': 9, '4': 1, '5': 3, '10': 'patientVersion'},
    {
      '1': 'proposed_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'proposedAt'
    },
    {
      '1': 'resolved_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {'1': 'resolved_by', '3': 12, '4': 1, '5': 9, '10': 'resolvedBy'},
    {'1': 'resolution_note', '3': 13, '4': 1, '5': 9, '10': 'resolutionNote'},
  ],
};

/// Descriptor for `DemographicProposal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List demographicProposalDescriptor = $convert.base64Decode(
    'ChNEZW1vZ3JhcGhpY1Byb3Bvc2FsEh8KC3Byb3Bvc2FsX2lkGAEgASgJUgpwcm9wb3NhbElkEh'
    '0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBI6CgZvcmlnaW4YAyABKA4yIi5oZWFsdGhj'
    'YXJlLmVtcGkudjEuUHJvcG9zYWxPcmlnaW5SBm9yaWdpbhIWCgZzb3VyY2UYBCABKAlSBnNvdX'
    'JjZRIfCgtwcm9wb3NlZF9ieRgFIAEoCVIKcHJvcG9zZWRCeRIWCgZyZWFzb24YBiABKAlSBnJl'
    'YXNvbhI6CgZzdGF0dXMYByABKA4yIi5oZWFsdGhjYXJlLmVtcGkudjEuUHJvcG9zYWxTdGF0dX'
    'NSBnN0YXR1cxI/CgZmaWVsZHMYCCADKAsyJy5oZWFsdGhjYXJlLmVtcGkudjEuUHJvcG9zZWRG'
    'aWVsZENoYW5nZVIGZmllbGRzEicKD3BhdGllbnRfdmVyc2lvbhgJIAEoA1IOcGF0aWVudFZlcn'
    'Npb24SOwoLcHJvcG9zZWRfYXQYCiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpw'
    'cm9wb3NlZEF0EjsKC3Jlc29sdmVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIKcmVzb2x2ZWRBdBIfCgtyZXNvbHZlZF9ieRgMIAEoCVIKcmVzb2x2ZWRCeRInCg9yZXNv'
    'bHV0aW9uX25vdGUYDSABKAlSDnJlc29sdXRpb25Ob3Rl');

@$core.Deprecated('Use submitExternalDemographicsRequestDescriptor instead')
const SubmitExternalDemographicsRequest$json = {
  '1': 'SubmitExternalDemographicsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'demographics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
    {'1': 'fill_blanks', '3': 4, '4': 1, '5': 8, '10': 'fillBlanks'},
  ],
};

/// Descriptor for `SubmitExternalDemographicsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitExternalDemographicsRequestDescriptor =
    $convert.base64Decode(
        'CiFTdWJtaXRFeHRlcm5hbERlbW9ncmFwaGljc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCV'
        'IJcGF0aWVudElkEkQKDGRlbW9ncmFwaGljcxgCIAEoCzIgLmhlYWx0aGNhcmUuZW1waS52MS5E'
        'ZW1vZ3JhcGhpY3NSDGRlbW9ncmFwaGljcxIWCgZzb3VyY2UYAyABKAlSBnNvdXJjZRIfCgtmaW'
        'xsX2JsYW5rcxgEIAEoCFIKZmlsbEJsYW5rcw==');

@$core.Deprecated('Use submitExternalDemographicsResponseDescriptor instead')
const SubmitExternalDemographicsResponse$json = {
  '1': 'SubmitExternalDemographicsResponse',
  '2': [
    {
      '1': 'proposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.DemographicProposal',
      '10': 'proposal'
    },
    {'1': 'conflicted', '3': 2, '4': 1, '5': 8, '10': 'conflicted'},
    {'1': 'refreshed', '3': 3, '4': 1, '5': 8, '10': 'refreshed'},
  ],
};

/// Descriptor for `SubmitExternalDemographicsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitExternalDemographicsResponseDescriptor =
    $convert.base64Decode(
        'CiJTdWJtaXRFeHRlcm5hbERlbW9ncmFwaGljc1Jlc3BvbnNlEkMKCHByb3Bvc2FsGAEgASgLMi'
        'cuaGVhbHRoY2FyZS5lbXBpLnYxLkRlbW9ncmFwaGljUHJvcG9zYWxSCHByb3Bvc2FsEh4KCmNv'
        'bmZsaWN0ZWQYAiABKAhSCmNvbmZsaWN0ZWQSHAoJcmVmcmVzaGVkGAMgASgIUglyZWZyZXNoZW'
        'Q=');

@$core.Deprecated('Use requestCorrectionRequestDescriptor instead')
const RequestCorrectionRequest$json = {
  '1': 'RequestCorrectionRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'demographics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RequestCorrectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestCorrectionRequestDescriptor = $convert.base64Decode(
    'ChhSZXF1ZXN0Q29ycmVjdGlvblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudE'
    'lkEkQKDGRlbW9ncmFwaGljcxgCIAEoCzIgLmhlYWx0aGNhcmUuZW1waS52MS5EZW1vZ3JhcGhp'
    'Y3NSDGRlbW9ncmFwaGljcxIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use requestCorrectionResponseDescriptor instead')
const RequestCorrectionResponse$json = {
  '1': 'RequestCorrectionResponse',
  '2': [
    {
      '1': 'proposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.DemographicProposal',
      '10': 'proposal'
    },
  ],
};

/// Descriptor for `RequestCorrectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestCorrectionResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0Q29ycmVjdGlvblJlc3BvbnNlEkMKCHByb3Bvc2FsGAEgASgLMicuaGVhbHRoY2'
        'FyZS5lbXBpLnYxLkRlbW9ncmFwaGljUHJvcG9zYWxSCHByb3Bvc2Fs');

@$core.Deprecated('Use listDemographicProposalsRequestDescriptor instead')
const ListDemographicProposalsRequest$json = {
  '1': 'ListDemographicProposalsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDemographicProposalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDemographicProposalsRequestDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0RGVtb2dyYXBoaWNQcm9wb3NhbHNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCX'
        'BhdGllbnRJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listDemographicProposalsResponseDescriptor instead')
const ListDemographicProposalsResponse$json = {
  '1': 'ListDemographicProposalsResponse',
  '2': [
    {
      '1': 'proposals',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.DemographicProposal',
      '10': 'proposals'
    },
  ],
};

/// Descriptor for `ListDemographicProposalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDemographicProposalsResponseDescriptor =
    $convert.base64Decode(
        'CiBMaXN0RGVtb2dyYXBoaWNQcm9wb3NhbHNSZXNwb25zZRJFCglwcm9wb3NhbHMYASADKAsyJy'
        '5oZWFsdGhjYXJlLmVtcGkudjEuRGVtb2dyYXBoaWNQcm9wb3NhbFIJcHJvcG9zYWxz');

@$core.Deprecated('Use resolveDemographicProposalRequestDescriptor instead')
const ResolveDemographicProposalRequest$json = {
  '1': 'ResolveDemographicProposalRequest',
  '2': [
    {'1': 'proposal_id', '3': 1, '4': 1, '5': 9, '10': 'proposalId'},
    {
      '1': 'accept',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.empi.v1.DemographicField',
      '10': 'accept'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ResolveDemographicProposalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveDemographicProposalRequestDescriptor =
    $convert.base64Decode(
        'CiFSZXNvbHZlRGVtb2dyYXBoaWNQcm9wb3NhbFJlcXVlc3QSHwoLcHJvcG9zYWxfaWQYASABKA'
        'lSCnByb3Bvc2FsSWQSPAoGYWNjZXB0GAIgAygOMiQuaGVhbHRoY2FyZS5lbXBpLnYxLkRlbW9n'
        'cmFwaGljRmllbGRSBmFjY2VwdBISCgRub3RlGAMgASgJUgRub3Rl');

@$core.Deprecated('Use resolveDemographicProposalResponseDescriptor instead')
const ResolveDemographicProposalResponse$json = {
  '1': 'ResolveDemographicProposalResponse',
  '2': [
    {
      '1': 'proposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.DemographicProposal',
      '10': 'proposal'
    },
    {
      '1': 'patient',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `ResolveDemographicProposalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveDemographicProposalResponseDescriptor =
    $convert.base64Decode(
        'CiJSZXNvbHZlRGVtb2dyYXBoaWNQcm9wb3NhbFJlc3BvbnNlEkMKCHByb3Bvc2FsGAEgASgLMi'
        'cuaGVhbHRoY2FyZS5lbXBpLnYxLkRlbW9ncmFwaGljUHJvcG9zYWxSCHByb3Bvc2FsEjUKB3Bh'
        'dGllbnQYAiABKAsyGy5oZWFsdGhjYXJlLmVtcGkudjEuUGF0aWVudFIHcGF0aWVudA==');

@$core.Deprecated('Use withdrawDemographicProposalRequestDescriptor instead')
const WithdrawDemographicProposalRequest$json = {
  '1': 'WithdrawDemographicProposalRequest',
  '2': [
    {'1': 'proposal_id', '3': 1, '4': 1, '5': 9, '10': 'proposalId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `WithdrawDemographicProposalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawDemographicProposalRequestDescriptor =
    $convert.base64Decode(
        'CiJXaXRoZHJhd0RlbW9ncmFwaGljUHJvcG9zYWxSZXF1ZXN0Eh8KC3Byb3Bvc2FsX2lkGAEgAS'
        'gJUgpwcm9wb3NhbElkEhIKBG5vdGUYAiABKAlSBG5vdGU=');

@$core.Deprecated('Use withdrawDemographicProposalResponseDescriptor instead')
const WithdrawDemographicProposalResponse$json = {
  '1': 'WithdrawDemographicProposalResponse',
  '2': [
    {
      '1': 'proposal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.DemographicProposal',
      '10': 'proposal'
    },
  ],
};

/// Descriptor for `WithdrawDemographicProposalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawDemographicProposalResponseDescriptor =
    $convert.base64Decode(
        'CiNXaXRoZHJhd0RlbW9ncmFwaGljUHJvcG9zYWxSZXNwb25zZRJDCghwcm9wb3NhbBgBIAEoCz'
        'InLmhlYWx0aGNhcmUuZW1waS52MS5EZW1vZ3JhcGhpY1Byb3Bvc2FsUghwcm9wb3NhbA==');

@$core.Deprecated('Use temporaryDesignationDescriptor instead')
const TemporaryDesignation$json = {
  '1': 'TemporaryDesignation',
  '2': [
    {'1': 'label', '3': 1, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'apparent_sex',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.Sex',
      '10': 'apparentSex'
    },
    {'1': 'apparent_age', '3': 3, '4': 1, '5': 5, '10': 'apparentAge'},
    {'1': 'circumstance', '3': 4, '4': 1, '5': 9, '10': 'circumstance'},
  ],
};

/// Descriptor for `TemporaryDesignation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List temporaryDesignationDescriptor = $convert.base64Decode(
    'ChRUZW1wb3JhcnlEZXNpZ25hdGlvbhIUCgVsYWJlbBgBIAEoCVIFbGFiZWwSOgoMYXBwYXJlbn'
    'Rfc2V4GAIgASgOMhcuaGVhbHRoY2FyZS5lbXBpLnYxLlNleFILYXBwYXJlbnRTZXgSIQoMYXBw'
    'YXJlbnRfYWdlGAMgASgFUgthcHBhcmVudEFnZRIiCgxjaXJjdW1zdGFuY2UYBCABKAlSDGNpcm'
    'N1bXN0YW5jZQ==');

@$core.Deprecated('Use registerUnidentifiedRequestDescriptor instead')
const RegisterUnidentifiedRequest$json = {
  '1': 'RegisterUnidentifiedRequest',
  '2': [
    {
      '1': 'designation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.TemporaryDesignation',
      '10': 'designation'
    },
  ],
};

/// Descriptor for `RegisterUnidentifiedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUnidentifiedRequestDescriptor =
    $convert.base64Decode(
        'ChtSZWdpc3RlclVuaWRlbnRpZmllZFJlcXVlc3QSSgoLZGVzaWduYXRpb24YASABKAsyKC5oZW'
        'FsdGhjYXJlLmVtcGkudjEuVGVtcG9yYXJ5RGVzaWduYXRpb25SC2Rlc2lnbmF0aW9u');

@$core.Deprecated('Use registerUnidentifiedResponseDescriptor instead')
const RegisterUnidentifiedResponse$json = {
  '1': 'RegisterUnidentifiedResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `RegisterUnidentifiedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerUnidentifiedResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWdpc3RlclVuaWRlbnRpZmllZFJlc3BvbnNlEjUKB3BhdGllbnQYASABKAsyGy5oZWFsdG'
        'hjYXJlLmVtcGkudjEuUGF0aWVudFIHcGF0aWVudA==');

@$core.Deprecated('Use identifyPatientRequestDescriptor instead')
const IdentifyPatientRequest$json = {
  '1': 'IdentifyPatientRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'demographics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
    {
      '1': 'acknowledged_duplicate_patient_ids',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'acknowledgedDuplicatePatientIds'
    },
  ],
};

/// Descriptor for `IdentifyPatientRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyPatientRequestDescriptor = $convert.base64Decode(
    'ChZJZGVudGlmeVBhdGllbnRSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'JECgxkZW1vZ3JhcGhpY3MYAiABKAsyIC5oZWFsdGhjYXJlLmVtcGkudjEuRGVtb2dyYXBoaWNz'
    'UgxkZW1vZ3JhcGhpY3MSKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0ZWRWZXJzaW'
    '9uEksKImFja25vd2xlZGdlZF9kdXBsaWNhdGVfcGF0aWVudF9pZHMYBCADKAlSH2Fja25vd2xl'
    'ZGdlZER1cGxpY2F0ZVBhdGllbnRJZHM=');

@$core.Deprecated('Use identifyPatientResponseDescriptor instead')
const IdentifyPatientResponse$json = {
  '1': 'IdentifyPatientResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
    {
      '1': 'potential_duplicates',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientMatch',
      '10': 'potentialDuplicates'
    },
  ],
};

/// Descriptor for `IdentifyPatientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyPatientResponseDescriptor = $convert.base64Decode(
    'ChdJZGVudGlmeVBhdGllbnRSZXNwb25zZRI1CgdwYXRpZW50GAEgASgLMhsuaGVhbHRoY2FyZS'
    '5lbXBpLnYxLlBhdGllbnRSB3BhdGllbnQSUwoUcG90ZW50aWFsX2R1cGxpY2F0ZXMYAiADKAsy'
    'IC5oZWFsdGhjYXJlLmVtcGkudjEuUGF0aWVudE1hdGNoUhNwb3RlbnRpYWxEdXBsaWNhdGVz');

@$core.Deprecated('Use listUnidentifiedRequestDescriptor instead')
const ListUnidentifiedRequest$json = {
  '1': 'ListUnidentifiedRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListUnidentifiedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUnidentifiedRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0VW5pZGVudGlmaWVkUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listUnidentifiedResponseDescriptor instead')
const ListUnidentifiedResponse$json = {
  '1': 'ListUnidentifiedResponse',
  '2': [
    {
      '1': 'patients',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patients'
    },
  ],
};

/// Descriptor for `ListUnidentifiedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUnidentifiedResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0VW5pZGVudGlmaWVkUmVzcG9uc2USNwoIcGF0aWVudHMYASADKAsyGy5oZWFsdGhjYX'
        'JlLmVtcGkudjEuUGF0aWVudFIIcGF0aWVudHM=');

@$core.Deprecated('Use photoConsentDescriptor instead')
const PhotoConsent$json = {
  '1': 'PhotoConsent',
  '2': [
    {'1': 'given_by', '3': 1, '4': 1, '5': 9, '10': 'givenBy'},
    {'1': 'on_behalf', '3': 2, '4': 1, '5': 9, '10': 'onBehalf'},
    {'1': 'purpose', '3': 3, '4': 1, '5': 9, '10': 'purpose'},
    {
      '1': 'given_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {'1': 'recorded_by', '3': 5, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `PhotoConsent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List photoConsentDescriptor = $convert.base64Decode(
    'CgxQaG90b0NvbnNlbnQSGQoIZ2l2ZW5fYnkYASABKAlSB2dpdmVuQnkSGwoJb25fYmVoYWxmGA'
    'IgASgJUghvbkJlaGFsZhIYCgdwdXJwb3NlGAMgASgJUgdwdXJwb3NlEjUKCGdpdmVuX2F0GAQg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZ2l2ZW5BdBIfCgtyZWNvcmRlZF9ieR'
    'gFIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use patientPhotoDescriptor instead')
const PatientPhoto$json = {
  '1': 'PatientPhoto',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'content_type', '3': 3, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'byte_size', '3': 4, '4': 1, '5': 3, '10': 'byteSize'},
    {'1': 'digest', '3': 5, '4': 1, '5': 9, '10': 'digest'},
    {
      '1': 'consent',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PhotoConsent',
      '10': 'consent'
    },
    {
      '1': 'captured_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {'1': 'captured_by', '3': 8, '4': 1, '5': 9, '10': 'capturedBy'},
    {
      '1': 'withdrawn_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'withdrawnAt'
    },
    {'1': 'withdrawn_reason', '3': 10, '4': 1, '5': 9, '10': 'withdrawnReason'},
  ],
};

/// Descriptor for `PatientPhoto`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientPhotoDescriptor = $convert.base64Decode(
    'CgxQYXRpZW50UGhvdG8SGQoIcGhvdG9faWQYASABKAlSB3Bob3RvSWQSHQoKcGF0aWVudF9pZB'
    'gCIAEoCVIJcGF0aWVudElkEiEKDGNvbnRlbnRfdHlwZRgDIAEoCVILY29udGVudFR5cGUSGwoJ'
    'Ynl0ZV9zaXplGAQgASgDUghieXRlU2l6ZRIWCgZkaWdlc3QYBSABKAlSBmRpZ2VzdBI6Cgdjb2'
    '5zZW50GAYgASgLMiAuaGVhbHRoY2FyZS5lbXBpLnYxLlBob3RvQ29uc2VudFIHY29uc2VudBI7'
    'CgtjYXB0dXJlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNhcHR1cm'
    'VkQXQSHwoLY2FwdHVyZWRfYnkYCCABKAlSCmNhcHR1cmVkQnkSPQoMd2l0aGRyYXduX2F0GAkg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILd2l0aGRyYXduQXQSKQoQd2l0aGRyYX'
    'duX3JlYXNvbhgKIAEoCVIPd2l0aGRyYXduUmVhc29u');

@$core.Deprecated('Use capturePhotoRequestDescriptor instead')
const CapturePhotoRequest$json = {
  '1': 'CapturePhotoRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'content_type', '3': 2, '4': 1, '5': 9, '10': 'contentType'},
    {'1': 'content', '3': 3, '4': 1, '5': 12, '10': 'content'},
    {
      '1': 'consent',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PhotoConsent',
      '10': 'consent'
    },
  ],
};

/// Descriptor for `CapturePhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capturePhotoRequestDescriptor = $convert.base64Decode(
    'ChNDYXB0dXJlUGhvdG9SZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCg'
    'xjb250ZW50X3R5cGUYAiABKAlSC2NvbnRlbnRUeXBlEhgKB2NvbnRlbnQYAyABKAxSB2NvbnRl'
    'bnQSOgoHY29uc2VudBgEIAEoCzIgLmhlYWx0aGNhcmUuZW1waS52MS5QaG90b0NvbnNlbnRSB2'
    'NvbnNlbnQ=');

@$core.Deprecated('Use capturePhotoResponseDescriptor instead')
const CapturePhotoResponse$json = {
  '1': 'CapturePhotoResponse',
  '2': [
    {
      '1': 'photo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientPhoto',
      '10': 'photo'
    },
  ],
};

/// Descriptor for `CapturePhotoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capturePhotoResponseDescriptor = $convert.base64Decode(
    'ChRDYXB0dXJlUGhvdG9SZXNwb25zZRI2CgVwaG90bxgBIAEoCzIgLmhlYWx0aGNhcmUuZW1waS'
    '52MS5QYXRpZW50UGhvdG9SBXBob3Rv');

@$core.Deprecated('Use getPhotoRequestDescriptor instead')
const GetPhotoRequest$json = {
  '1': 'GetPhotoRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `GetPhotoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhotoRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRQaG90b1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElk');

@$core.Deprecated('Use getPhotoResponseDescriptor instead')
const GetPhotoResponse$json = {
  '1': 'GetPhotoResponse',
  '2': [
    {
      '1': 'photo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientPhoto',
      '10': 'photo'
    },
    {'1': 'content', '3': 2, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `GetPhotoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhotoResponseDescriptor = $convert.base64Decode(
    'ChBHZXRQaG90b1Jlc3BvbnNlEjYKBXBob3RvGAEgASgLMiAuaGVhbHRoY2FyZS5lbXBpLnYxLl'
    'BhdGllbnRQaG90b1IFcGhvdG8SGAoHY29udGVudBgCIAEoDFIHY29udGVudA==');

@$core.Deprecated('Use withdrawPhotoConsentRequestDescriptor instead')
const WithdrawPhotoConsentRequest$json = {
  '1': 'WithdrawPhotoConsentRequest',
  '2': [
    {'1': 'photo_id', '3': 1, '4': 1, '5': 9, '10': 'photoId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `WithdrawPhotoConsentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawPhotoConsentRequestDescriptor =
    $convert.base64Decode(
        'ChtXaXRoZHJhd1Bob3RvQ29uc2VudFJlcXVlc3QSGQoIcGhvdG9faWQYASABKAlSB3Bob3RvSW'
        'QSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use withdrawPhotoConsentResponseDescriptor instead')
const WithdrawPhotoConsentResponse$json = {
  '1': 'WithdrawPhotoConsentResponse',
  '2': [
    {
      '1': 'photo',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientPhoto',
      '10': 'photo'
    },
  ],
};

/// Descriptor for `WithdrawPhotoConsentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List withdrawPhotoConsentResponseDescriptor =
    $convert.base64Decode(
        'ChxXaXRoZHJhd1Bob3RvQ29uc2VudFJlc3BvbnNlEjYKBXBob3RvGAEgASgLMiAuaGVhbHRoY2'
        'FyZS5lbXBpLnYxLlBhdGllbnRQaG90b1IFcGhvdG8=');

@$core.Deprecated('Use configureFieldAccessRequestDescriptor instead')
const ConfigureFieldAccessRequest$json = {
  '1': 'ConfigureFieldAccessRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'field',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.DemographicField',
      '10': 'field'
    },
    {
      '1': 'required_permission',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'requiredPermission'
    },
  ],
};

/// Descriptor for `ConfigureFieldAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureFieldAccessRequestDescriptor = $convert.base64Decode(
    'ChtDb25maWd1cmVGaWVsZEFjY2Vzc1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2'
    'lsaXR5SWQSOgoFZmllbGQYAiABKA4yJC5oZWFsdGhjYXJlLmVtcGkudjEuRGVtb2dyYXBoaWNG'
    'aWVsZFIFZmllbGQSLwoTcmVxdWlyZWRfcGVybWlzc2lvbhgDIAEoCVIScmVxdWlyZWRQZXJtaX'
    'NzaW9u');

@$core.Deprecated('Use configureFieldAccessResponseDescriptor instead')
const ConfigureFieldAccessResponse$json = {
  '1': 'ConfigureFieldAccessResponse',
};

/// Descriptor for `ConfigureFieldAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureFieldAccessResponseDescriptor =
    $convert.base64Decode('ChxDb25maWd1cmVGaWVsZEFjY2Vzc1Jlc3BvbnNl');

@$core.Deprecated('Use linkIdentifierRequestDescriptor instead')
const LinkIdentifierRequest$json = {
  '1': 'LinkIdentifierRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.IdentifierType',
      '10': 'type'
    },
    {'1': 'system', '3': 3, '4': 1, '5': 9, '10': 'system'},
    {'1': 'value', '3': 4, '4': 1, '5': 9, '10': 'value'},
    {
      '1': 'assigning_authority',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'assigningAuthority'
    },
    {'1': 'source', '3': 6, '4': 1, '5': 9, '10': 'source'},
    {'1': 'verify', '3': 7, '4': 1, '5': 8, '10': 'verify'},
    {
      '1': 'require_verification',
      '3': 8,
      '4': 1,
      '5': 8,
      '10': 'requireVerification'
    },
  ],
};

/// Descriptor for `LinkIdentifierRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkIdentifierRequestDescriptor = $convert.base64Decode(
    'ChVMaW5rSWRlbnRpZmllclJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEj'
    'YKBHR5cGUYAiABKA4yIi5oZWFsdGhjYXJlLmVtcGkudjEuSWRlbnRpZmllclR5cGVSBHR5cGUS'
    'FgoGc3lzdGVtGAMgASgJUgZzeXN0ZW0SFAoFdmFsdWUYBCABKAlSBXZhbHVlEi8KE2Fzc2lnbm'
    'luZ19hdXRob3JpdHkYBSABKAlSEmFzc2lnbmluZ0F1dGhvcml0eRIWCgZzb3VyY2UYBiABKAlS'
    'BnNvdXJjZRIWCgZ2ZXJpZnkYByABKAhSBnZlcmlmeRIxChRyZXF1aXJlX3ZlcmlmaWNhdGlvbh'
    'gIIAEoCFITcmVxdWlyZVZlcmlmaWNhdGlvbg==');

@$core.Deprecated('Use linkIdentifierResponseDescriptor instead')
const LinkIdentifierResponse$json = {
  '1': 'LinkIdentifierResponse',
  '2': [
    {
      '1': 'identifier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientIdentifier',
      '10': 'identifier'
    },
    {
      '1': 'verification_attempted',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'verificationAttempted'
    },
    {
      '1': 'registry_unavailable',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'registryUnavailable'
    },
    {
      '1': 'verification_reason',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'verificationReason'
    },
    {
      '1': 'authority_demographics',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'authorityDemographics'
    },
    {
      '1': 'has_authority_demographics',
      '3': 6,
      '4': 1,
      '5': 8,
      '10': 'hasAuthorityDemographics'
    },
    {
      '1': 'conflict_proposal_id',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'conflictProposalId'
    },
  ],
};

/// Descriptor for `LinkIdentifierResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkIdentifierResponseDescriptor = $convert.base64Decode(
    'ChZMaW5rSWRlbnRpZmllclJlc3BvbnNlEkUKCmlkZW50aWZpZXIYASABKAsyJS5oZWFsdGhjYX'
    'JlLmVtcGkudjEuUGF0aWVudElkZW50aWZpZXJSCmlkZW50aWZpZXISNQoWdmVyaWZpY2F0aW9u'
    'X2F0dGVtcHRlZBgCIAEoCFIVdmVyaWZpY2F0aW9uQXR0ZW1wdGVkEjEKFHJlZ2lzdHJ5X3VuYX'
    'ZhaWxhYmxlGAMgASgIUhNyZWdpc3RyeVVuYXZhaWxhYmxlEi8KE3ZlcmlmaWNhdGlvbl9yZWFz'
    'b24YBCABKAlSEnZlcmlmaWNhdGlvblJlYXNvbhJXChZhdXRob3JpdHlfZGVtb2dyYXBoaWNzGA'
    'UgASgLMiAuaGVhbHRoY2FyZS5lbXBpLnYxLkRlbW9ncmFwaGljc1IVYXV0aG9yaXR5RGVtb2dy'
    'YXBoaWNzEjwKGmhhc19hdXRob3JpdHlfZGVtb2dyYXBoaWNzGAYgASgIUhhoYXNBdXRob3JpdH'
    'lEZW1vZ3JhcGhpY3MSMAoUY29uZmxpY3RfcHJvcG9zYWxfaWQYByABKAlSEmNvbmZsaWN0UHJv'
    'cG9zYWxJZA==');

@$core.Deprecated('Use unlinkIdentifierRequestDescriptor instead')
const UnlinkIdentifierRequest$json = {
  '1': 'UnlinkIdentifierRequest',
  '2': [
    {'1': 'identifier_id', '3': 1, '4': 1, '5': 9, '10': 'identifierId'},
    {'1': 'revoke', '3': 2, '4': 1, '5': 8, '10': 'revoke'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `UnlinkIdentifierRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkIdentifierRequestDescriptor = $convert.base64Decode(
    'ChdVbmxpbmtJZGVudGlmaWVyUmVxdWVzdBIjCg1pZGVudGlmaWVyX2lkGAEgASgJUgxpZGVudG'
    'lmaWVySWQSFgoGcmV2b2tlGAIgASgIUgZyZXZva2USFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use unlinkIdentifierResponseDescriptor instead')
const UnlinkIdentifierResponse$json = {
  '1': 'UnlinkIdentifierResponse',
  '2': [
    {
      '1': 'identifier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientIdentifier',
      '10': 'identifier'
    },
  ],
};

/// Descriptor for `UnlinkIdentifierResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkIdentifierResponseDescriptor =
    $convert.base64Decode(
        'ChhVbmxpbmtJZGVudGlmaWVyUmVzcG9uc2USRQoKaWRlbnRpZmllchgBIAEoCzIlLmhlYWx0aG'
        'NhcmUuZW1waS52MS5QYXRpZW50SWRlbnRpZmllclIKaWRlbnRpZmllcg==');

@$core.Deprecated('Use verifyIdentifierRequestDescriptor instead')
const VerifyIdentifierRequest$json = {
  '1': 'VerifyIdentifierRequest',
  '2': [
    {'1': 'identifier_id', '3': 1, '4': 1, '5': 9, '10': 'identifierId'},
  ],
};

/// Descriptor for `VerifyIdentifierRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyIdentifierRequestDescriptor =
    $convert.base64Decode(
        'ChdWZXJpZnlJZGVudGlmaWVyUmVxdWVzdBIjCg1pZGVudGlmaWVyX2lkGAEgASgJUgxpZGVudG'
        'lmaWVySWQ=');

@$core.Deprecated('Use verifyIdentifierResponseDescriptor instead')
const VerifyIdentifierResponse$json = {
  '1': 'VerifyIdentifierResponse',
  '2': [
    {
      '1': 'identifier',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientIdentifier',
      '10': 'identifier'
    },
    {
      '1': 'authority_demographics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'authorityDemographics'
    },
    {
      '1': 'has_authority_demographics',
      '3': 3,
      '4': 1,
      '5': 8,
      '10': 'hasAuthorityDemographics'
    },
  ],
};

/// Descriptor for `VerifyIdentifierResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyIdentifierResponseDescriptor = $convert.base64Decode(
    'ChhWZXJpZnlJZGVudGlmaWVyUmVzcG9uc2USRQoKaWRlbnRpZmllchgBIAEoCzIlLmhlYWx0aG'
    'NhcmUuZW1waS52MS5QYXRpZW50SWRlbnRpZmllclIKaWRlbnRpZmllchJXChZhdXRob3JpdHlf'
    'ZGVtb2dyYXBoaWNzGAIgASgLMiAuaGVhbHRoY2FyZS5lbXBpLnYxLkRlbW9ncmFwaGljc1IVYX'
    'V0aG9yaXR5RGVtb2dyYXBoaWNzEjwKGmhhc19hdXRob3JpdHlfZGVtb2dyYXBoaWNzGAMgASgI'
    'UhhoYXNBdXRob3JpdHlEZW1vZ3JhcGhpY3M=');

@$core.Deprecated('Use deceasedRecordDescriptor instead')
const DeceasedRecord$json = {
  '1': 'DeceasedRecord',
  '2': [
    {
      '1': 'date',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PartialDate',
      '10': 'date'
    },
    {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    {
      '1': 'recorded_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 4, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `DeceasedRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deceasedRecordDescriptor = $convert.base64Decode(
    'Cg5EZWNlYXNlZFJlY29yZBIzCgRkYXRlGAEgASgLMh8uaGVhbHRoY2FyZS5lbXBpLnYxLlBhcn'
    'RpYWxEYXRlUgRkYXRlEhYKBnNvdXJjZRgCIAEoCVIGc291cmNlEjsKC3JlY29yZGVkX2F0GAMg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdBIfCgtyZWNvcmRlZF'
    '9ieRgEIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use patientDescriptor instead')
const Patient$json = {
  '1': 'Patient',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'registered_facility_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'registeredFacilityId'
    },
    {
      '1': 'status',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.PatientStatus',
      '10': 'status'
    },
    {
      '1': 'demographics',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {
      '1': 'identifiers',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientIdentifier',
      '10': 'identifiers'
    },
    {
      '1': 'merged_into_patient_id',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'mergedIntoPatientId'
    },
    {
      '1': 'deceased',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.DeceasedRecord',
      '10': 'deceased'
    },
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
    {
      '1': 'accepts_routine_scheduling',
      '3': 11,
      '4': 1,
      '5': 8,
      '10': 'acceptsRoutineScheduling'
    },
    {
      '1': 'designation',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.TemporaryDesignation',
      '10': 'designation'
    },
    {
      '1': 'identified_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'identifiedAt'
    },
  ],
};

/// Descriptor for `Patient`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientDescriptor = $convert.base64Decode(
    'CgdQYXRpZW50Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBI0ChZyZWdpc3RlcmVkX2'
    'ZhY2lsaXR5X2lkGAIgASgJUhRyZWdpc3RlcmVkRmFjaWxpdHlJZBI5CgZzdGF0dXMYAyABKA4y'
    'IS5oZWFsdGhjYXJlLmVtcGkudjEuUGF0aWVudFN0YXR1c1IGc3RhdHVzEkQKDGRlbW9ncmFwaG'
    'ljcxgEIAEoCzIgLmhlYWx0aGNhcmUuZW1waS52MS5EZW1vZ3JhcGhpY3NSDGRlbW9ncmFwaGlj'
    'cxJHCgtpZGVudGlmaWVycxgFIAMoCzIlLmhlYWx0aGNhcmUuZW1waS52MS5QYXRpZW50SWRlbn'
    'RpZmllclILaWRlbnRpZmllcnMSMwoWbWVyZ2VkX2ludG9fcGF0aWVudF9pZBgGIAEoCVITbWVy'
    'Z2VkSW50b1BhdGllbnRJZBI+CghkZWNlYXNlZBgHIAEoCzIiLmhlYWx0aGNhcmUuZW1waS52MS'
    '5EZWNlYXNlZFJlY29yZFIIZGVjZWFzZWQSOQoKY3JlYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAkgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhgKB3ZlcnNpb24YCiABKANSB3ZlcnNp'
    'b24SPAoaYWNjZXB0c19yb3V0aW5lX3NjaGVkdWxpbmcYCyABKAhSGGFjY2VwdHNSb3V0aW5lU2'
    'NoZWR1bGluZxJKCgtkZXNpZ25hdGlvbhgMIAEoCzIoLmhlYWx0aGNhcmUuZW1waS52MS5UZW1w'
    'b3JhcnlEZXNpZ25hdGlvblILZGVzaWduYXRpb24SPwoNaWRlbnRpZmllZF9hdBgNIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGlkZW50aWZpZWRBdA==');

@$core.Deprecated('Use matchFieldScoreDescriptor instead')
const MatchFieldScore$json = {
  '1': 'MatchFieldScore',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {'1': 'similarity', '3': 2, '4': 1, '5': 1, '10': 'similarity'},
    {'1': 'weight', '3': 3, '4': 1, '5': 1, '10': 'weight'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `MatchFieldScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List matchFieldScoreDescriptor = $convert.base64Decode(
    'Cg9NYXRjaEZpZWxkU2NvcmUSFAoFZmllbGQYASABKAlSBWZpZWxkEh4KCnNpbWlsYXJpdHkYAi'
    'ABKAFSCnNpbWlsYXJpdHkSFgoGd2VpZ2h0GAMgASgBUgZ3ZWlnaHQSEgoEbm90ZRgEIAEoCVIE'
    'bm90ZQ==');

@$core.Deprecated('Use patientMatchDescriptor instead')
const PatientMatch$json = {
  '1': 'PatientMatch',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
    {'1': 'confidence', '3': 2, '4': 1, '5': 1, '10': 'confidence'},
    {
      '1': 'outcome',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.MatchOutcome',
      '10': 'outcome'
    },
    {
      '1': 'fields',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.MatchFieldScore',
      '10': 'fields'
    },
    {'1': 'masked', '3': 5, '4': 1, '5': 8, '10': 'masked'},
    {
      '1': 'matched_former_name',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientName',
      '10': 'matchedFormerName'
    },
  ],
};

/// Descriptor for `PatientMatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientMatchDescriptor = $convert.base64Decode(
    'CgxQYXRpZW50TWF0Y2gSNQoHcGF0aWVudBgBIAEoCzIbLmhlYWx0aGNhcmUuZW1waS52MS5QYX'
    'RpZW50UgdwYXRpZW50Eh4KCmNvbmZpZGVuY2UYAiABKAFSCmNvbmZpZGVuY2USOgoHb3V0Y29t'
    'ZRgDIAEoDjIgLmhlYWx0aGNhcmUuZW1waS52MS5NYXRjaE91dGNvbWVSB291dGNvbWUSOwoGZm'
    'llbGRzGAQgAygLMiMuaGVhbHRoY2FyZS5lbXBpLnYxLk1hdGNoRmllbGRTY29yZVIGZmllbGRz'
    'EhYKBm1hc2tlZBgFIAEoCFIGbWFza2VkEk8KE21hdGNoZWRfZm9ybWVyX25hbWUYBiABKAsyHy'
    '5oZWFsdGhjYXJlLmVtcGkudjEuUGF0aWVudE5hbWVSEW1hdGNoZWRGb3JtZXJOYW1l');

@$core.Deprecated('Use registerPatientRequestDescriptor instead')
const RegisterPatientRequest$json = {
  '1': 'RegisterPatientRequest',
  '2': [
    {
      '1': 'demographics',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {
      '1': 'identifiers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientIdentifier',
      '10': 'identifiers'
    },
    {
      '1': 'acknowledged_duplicate_patient_ids',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'acknowledgedDuplicatePatientIds'
    },
  ],
};

/// Descriptor for `RegisterPatientRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPatientRequestDescriptor = $convert.base64Decode(
    'ChZSZWdpc3RlclBhdGllbnRSZXF1ZXN0EkQKDGRlbW9ncmFwaGljcxgBIAEoCzIgLmhlYWx0aG'
    'NhcmUuZW1waS52MS5EZW1vZ3JhcGhpY3NSDGRlbW9ncmFwaGljcxJHCgtpZGVudGlmaWVycxgC'
    'IAMoCzIlLmhlYWx0aGNhcmUuZW1waS52MS5QYXRpZW50SWRlbnRpZmllclILaWRlbnRpZmllcn'
    'MSSwoiYWNrbm93bGVkZ2VkX2R1cGxpY2F0ZV9wYXRpZW50X2lkcxgDIAMoCVIfYWNrbm93bGVk'
    'Z2VkRHVwbGljYXRlUGF0aWVudElkcw==');

@$core.Deprecated('Use registerPatientResponseDescriptor instead')
const RegisterPatientResponse$json = {
  '1': 'RegisterPatientResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
    {
      '1': 'potential_duplicates',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientMatch',
      '10': 'potentialDuplicates'
    },
  ],
};

/// Descriptor for `RegisterPatientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerPatientResponseDescriptor = $convert.base64Decode(
    'ChdSZWdpc3RlclBhdGllbnRSZXNwb25zZRI1CgdwYXRpZW50GAEgASgLMhsuaGVhbHRoY2FyZS'
    '5lbXBpLnYxLlBhdGllbnRSB3BhdGllbnQSUwoUcG90ZW50aWFsX2R1cGxpY2F0ZXMYAiADKAsy'
    'IC5oZWFsdGhjYXJlLmVtcGkudjEuUGF0aWVudE1hdGNoUhNwb3RlbnRpYWxEdXBsaWNhdGVz');

@$core.Deprecated('Use searchPatientsRequestDescriptor instead')
const SearchPatientsRequest$json = {
  '1': 'SearchPatientsRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'birth_date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PartialDate',
      '10': 'birthDate'
    },
    {'1': 'phone', '3': 3, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'identifier_value', '3': 4, '4': 1, '5': 9, '10': 'identifierValue'},
    {
      '1': 'identifier_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.IdentifierType',
      '10': 'identifierType'
    },
    {
      '1': 'identifier_system',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'identifierSystem'
    },
    {'1': 'page_size', '3': 7, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 8, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `SearchPatientsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchPatientsRequestDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hQYXRpZW50c1JlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRI+CgpiaXJ0aF9kYX'
    'RlGAIgASgLMh8uaGVhbHRoY2FyZS5lbXBpLnYxLlBhcnRpYWxEYXRlUgliaXJ0aERhdGUSFAoF'
    'cGhvbmUYAyABKAlSBXBob25lEikKEGlkZW50aWZpZXJfdmFsdWUYBCABKAlSD2lkZW50aWZpZX'
    'JWYWx1ZRJLCg9pZGVudGlmaWVyX3R5cGUYBSABKA4yIi5oZWFsdGhjYXJlLmVtcGkudjEuSWRl'
    'bnRpZmllclR5cGVSDmlkZW50aWZpZXJUeXBlEisKEWlkZW50aWZpZXJfc3lzdGVtGAYgASgJUh'
    'BpZGVudGlmaWVyU3lzdGVtEhsKCXBhZ2Vfc2l6ZRgHIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90'
    'b2tlbhgIIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use searchPatientsResponseDescriptor instead')
const SearchPatientsResponse$json = {
  '1': 'SearchPatientsResponse',
  '2': [
    {
      '1': 'matches',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientMatch',
      '10': 'matches'
    },
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `SearchPatientsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchPatientsResponseDescriptor = $convert.base64Decode(
    'ChZTZWFyY2hQYXRpZW50c1Jlc3BvbnNlEjoKB21hdGNoZXMYASADKAsyIC5oZWFsdGhjYXJlLm'
    'VtcGkudjEuUGF0aWVudE1hdGNoUgdtYXRjaGVzEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVIN'
    'bmV4dFBhZ2VUb2tlbg==');

@$core.Deprecated('Use getPatientRequestDescriptor instead')
const GetPatientRequest$json = {
  '1': 'GetPatientRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resolve_merged', '3': 2, '4': 1, '5': 8, '10': 'resolveMerged'},
  ],
};

/// Descriptor for `GetPatientRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQYXRpZW50UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSJQoOcm'
    'Vzb2x2ZV9tZXJnZWQYAiABKAhSDXJlc29sdmVNZXJnZWQ=');

@$core.Deprecated('Use getPatientResponseDescriptor instead')
const GetPatientResponse$json = {
  '1': 'GetPatientResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
    {
      '1': 'resolved_from_patient_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'resolvedFromPatientId'
    },
    {'1': 'masked', '3': 3, '4': 1, '5': 8, '10': 'masked'},
  ],
};

/// Descriptor for `GetPatientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQYXRpZW50UmVzcG9uc2USNQoHcGF0aWVudBgBIAEoCzIbLmhlYWx0aGNhcmUuZW1waS'
    '52MS5QYXRpZW50UgdwYXRpZW50EjcKGHJlc29sdmVkX2Zyb21fcGF0aWVudF9pZBgCIAEoCVIV'
    'cmVzb2x2ZWRGcm9tUGF0aWVudElkEhYKBm1hc2tlZBgDIAEoCFIGbWFza2Vk');

@$core.Deprecated('Use updateDemographicsRequestDescriptor instead')
const UpdateDemographicsRequest$json = {
  '1': 'UpdateDemographicsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'demographics',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Demographics',
      '10': 'demographics'
    },
    {'1': 'expected_version', '3': 3, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `UpdateDemographicsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDemographicsRequestDescriptor = $convert.base64Decode(
    'ChlVcGRhdGVEZW1vZ3JhcGhpY3NSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbn'
    'RJZBJECgxkZW1vZ3JhcGhpY3MYAiABKAsyIC5oZWFsdGhjYXJlLmVtcGkudjEuRGVtb2dyYXBo'
    'aWNzUgxkZW1vZ3JhcGhpY3MSKQoQZXhwZWN0ZWRfdmVyc2lvbhgDIAEoA1IPZXhwZWN0ZWRWZX'
    'JzaW9u');

@$core.Deprecated('Use updateDemographicsResponseDescriptor instead')
const UpdateDemographicsResponse$json = {
  '1': 'UpdateDemographicsResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `UpdateDemographicsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateDemographicsResponseDescriptor =
    $convert.base64Decode(
        'ChpVcGRhdGVEZW1vZ3JhcGhpY3NSZXNwb25zZRI1CgdwYXRpZW50GAEgASgLMhsuaGVhbHRoY2'
        'FyZS5lbXBpLnYxLlBhdGllbnRSB3BhdGllbnQ=');

@$core.Deprecated('Use identityEvidenceDescriptor instead')
const IdentityEvidence$json = {
  '1': 'IdentityEvidence',
  '2': [
    {'1': 'identifier_ids', '3': 1, '4': 3, '5': 9, '10': 'identifierIds'},
    {'1': 'photo_matched', '3': 2, '4': 1, '5': 8, '10': 'photoMatched'},
    {'1': 'vouched_for_by', '3': 3, '4': 1, '5': 9, '10': 'vouchedForBy'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `IdentityEvidence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identityEvidenceDescriptor = $convert.base64Decode(
    'ChBJZGVudGl0eUV2aWRlbmNlEiUKDmlkZW50aWZpZXJfaWRzGAEgAygJUg1pZGVudGlmaWVySW'
    'RzEiMKDXBob3RvX21hdGNoZWQYAiABKAhSDHBob3RvTWF0Y2hlZBIkCg52b3VjaGVkX2Zvcl9i'
    'eRgDIAEoCVIMdm91Y2hlZEZvckJ5EhIKBG5vdGUYBCABKAlSBG5vdGU=');

@$core.Deprecated('Use confirmIdentityRequestDescriptor instead')
const ConfirmIdentityRequest$json = {
  '1': 'ConfirmIdentityRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
    {
      '1': 'evidence',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.IdentityEvidence',
      '10': 'evidence'
    },
  ],
};

/// Descriptor for `ConfirmIdentityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmIdentityRequestDescriptor = $convert.base64Decode(
    'ChZDb25maXJtSWRlbnRpdHlSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IpChBleHBlY3RlZF92ZXJzaW9uGAIgASgDUg9leHBlY3RlZFZlcnNpb24SQAoIZXZpZGVuY2UY'
    'AyABKAsyJC5oZWFsdGhjYXJlLmVtcGkudjEuSWRlbnRpdHlFdmlkZW5jZVIIZXZpZGVuY2U=');

@$core.Deprecated('Use confirmIdentityResponseDescriptor instead')
const ConfirmIdentityResponse$json = {
  '1': 'ConfirmIdentityResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `ConfirmIdentityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List confirmIdentityResponseDescriptor =
    $convert.base64Decode(
        'ChdDb25maXJtSWRlbnRpdHlSZXNwb25zZRI1CgdwYXRpZW50GAEgASgLMhsuaGVhbHRoY2FyZS'
        '5lbXBpLnYxLlBhdGllbnRSB3BhdGllbnQ=');

@$core.Deprecated('Use duplicateCandidateDescriptor instead')
const DuplicateCandidate$json = {
  '1': 'DuplicateCandidate',
  '2': [
    {'1': 'candidate_id', '3': 1, '4': 1, '5': 9, '10': 'candidateId'},
    {'1': 'patient_a_id', '3': 2, '4': 1, '5': 9, '10': 'patientAId'},
    {'1': 'patient_b_id', '3': 3, '4': 1, '5': 9, '10': 'patientBId'},
    {'1': 'score', '3': 4, '4': 1, '5': 1, '10': 'score'},
    {
      '1': 'outcome',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.MatchOutcome',
      '10': 'outcome'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.ReviewStatus',
      '10': 'status'
    },
    {'1': 'detected_by', '3': 7, '4': 1, '5': 9, '10': 'detectedBy'},
    {
      '1': 'detected_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'detectedAt'
    },
    {'1': 'reviewed_by', '3': 9, '4': 1, '5': 9, '10': 'reviewedBy'},
    {
      '1': 'reviewed_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'resolution', '3': 11, '4': 1, '5': 9, '10': 'resolution'},
  ],
};

/// Descriptor for `DuplicateCandidate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List duplicateCandidateDescriptor = $convert.base64Decode(
    'ChJEdXBsaWNhdGVDYW5kaWRhdGUSIQoMY2FuZGlkYXRlX2lkGAEgASgJUgtjYW5kaWRhdGVJZB'
    'IgCgxwYXRpZW50X2FfaWQYAiABKAlSCnBhdGllbnRBSWQSIAoMcGF0aWVudF9iX2lkGAMgASgJ'
    'UgpwYXRpZW50QklkEhQKBXNjb3JlGAQgASgBUgVzY29yZRI6CgdvdXRjb21lGAUgASgOMiAuaG'
    'VhbHRoY2FyZS5lbXBpLnYxLk1hdGNoT3V0Y29tZVIHb3V0Y29tZRI4CgZzdGF0dXMYBiABKA4y'
    'IC5oZWFsdGhjYXJlLmVtcGkudjEuUmV2aWV3U3RhdHVzUgZzdGF0dXMSHwoLZGV0ZWN0ZWRfYn'
    'kYByABKAlSCmRldGVjdGVkQnkSOwoLZGV0ZWN0ZWRfYXQYCCABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgpkZXRlY3RlZEF0Eh8KC3Jldmlld2VkX2J5GAkgASgJUgpyZXZpZXdlZE'
    'J5EjsKC3Jldmlld2VkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmV2'
    'aWV3ZWRBdBIeCgpyZXNvbHV0aW9uGAsgASgJUgpyZXNvbHV0aW9u');

@$core.Deprecated('Use mergePatientsRequestDescriptor instead')
const MergePatientsRequest$json = {
  '1': 'MergePatientsRequest',
  '2': [
    {
      '1': 'survivor_patient_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'survivorPatientId'
    },
    {'1': 'merged_patient_id', '3': 2, '4': 1, '5': 9, '10': 'mergedPatientId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'candidate_id', '3': 4, '4': 1, '5': 9, '10': 'candidateId'},
  ],
};

/// Descriptor for `MergePatientsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mergePatientsRequestDescriptor = $convert.base64Decode(
    'ChRNZXJnZVBhdGllbnRzUmVxdWVzdBIuChNzdXJ2aXZvcl9wYXRpZW50X2lkGAEgASgJUhFzdX'
    'J2aXZvclBhdGllbnRJZBIqChFtZXJnZWRfcGF0aWVudF9pZBgCIAEoCVIPbWVyZ2VkUGF0aWVu'
    'dElkEhYKBnJlYXNvbhgDIAEoCVIGcmVhc29uEiEKDGNhbmRpZGF0ZV9pZBgEIAEoCVILY2FuZG'
    'lkYXRlSWQ=');

@$core.Deprecated('Use mergePatientsResponseDescriptor instead')
const MergePatientsResponse$json = {
  '1': 'MergePatientsResponse',
  '2': [
    {
      '1': 'survivor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'survivor'
    },
    {'1': 'merged_patient_id', '3': 2, '4': 1, '5': 9, '10': 'mergedPatientId'},
    {'1': 'merge_id', '3': 3, '4': 1, '5': 9, '10': 'mergeId'},
  ],
};

/// Descriptor for `MergePatientsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mergePatientsResponseDescriptor = $convert.base64Decode(
    'ChVNZXJnZVBhdGllbnRzUmVzcG9uc2USNwoIc3Vydml2b3IYASABKAsyGy5oZWFsdGhjYXJlLm'
    'VtcGkudjEuUGF0aWVudFIIc3Vydml2b3ISKgoRbWVyZ2VkX3BhdGllbnRfaWQYAiABKAlSD21l'
    'cmdlZFBhdGllbnRJZBIZCghtZXJnZV9pZBgDIAEoCVIHbWVyZ2VJZA==');

@$core.Deprecated('Use unmergePatientsRequestDescriptor instead')
const UnmergePatientsRequest$json = {
  '1': 'UnmergePatientsRequest',
  '2': [
    {'1': 'merge_id', '3': 1, '4': 1, '5': 9, '10': 'mergeId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `UnmergePatientsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unmergePatientsRequestDescriptor =
    $convert.base64Decode(
        'ChZVbm1lcmdlUGF0aWVudHNSZXF1ZXN0EhkKCG1lcmdlX2lkGAEgASgJUgdtZXJnZUlkEhYKBn'
        'JlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use unmergePatientsResponseDescriptor instead')
const UnmergePatientsResponse$json = {
  '1': 'UnmergePatientsResponse',
  '2': [
    {
      '1': 'survivor',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'survivor'
    },
    {
      '1': 'restored',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'restored'
    },
  ],
};

/// Descriptor for `UnmergePatientsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unmergePatientsResponseDescriptor = $convert.base64Decode(
    'ChdVbm1lcmdlUGF0aWVudHNSZXNwb25zZRI3CghzdXJ2aXZvchgBIAEoCzIbLmhlYWx0aGNhcm'
    'UuZW1waS52MS5QYXRpZW50UghzdXJ2aXZvchI3CghyZXN0b3JlZBgCIAEoCzIbLmhlYWx0aGNh'
    'cmUuZW1waS52MS5QYXRpZW50UghyZXN0b3JlZA==');

@$core.Deprecated('Use listDuplicateCandidatesRequestDescriptor instead')
const ListDuplicateCandidatesRequest$json = {
  '1': 'ListDuplicateCandidatesRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDuplicateCandidatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDuplicateCandidatesRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0RHVwbGljYXRlQ2FuZGlkYXRlc1JlcXVlc3QSGwoJcGFnZV9zaXplGAEgASgFUghwYW'
        'dlU2l6ZQ==');

@$core.Deprecated('Use listDuplicateCandidatesResponseDescriptor instead')
const ListDuplicateCandidatesResponse$json = {
  '1': 'ListDuplicateCandidatesResponse',
  '2': [
    {
      '1': 'candidates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.DuplicateCandidate',
      '10': 'candidates'
    },
  ],
};

/// Descriptor for `ListDuplicateCandidatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDuplicateCandidatesResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0RHVwbGljYXRlQ2FuZGlkYXRlc1Jlc3BvbnNlEkYKCmNhbmRpZGF0ZXMYASADKAsyJi'
        '5oZWFsdGhjYXJlLmVtcGkudjEuRHVwbGljYXRlQ2FuZGlkYXRlUgpjYW5kaWRhdGVz');

@$core.Deprecated('Use dismissDuplicateCandidateRequestDescriptor instead')
const DismissDuplicateCandidateRequest$json = {
  '1': 'DismissDuplicateCandidateRequest',
  '2': [
    {'1': 'candidate_id', '3': 1, '4': 1, '5': 9, '10': 'candidateId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DismissDuplicateCandidateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissDuplicateCandidateRequestDescriptor =
    $convert.base64Decode(
        'CiBEaXNtaXNzRHVwbGljYXRlQ2FuZGlkYXRlUmVxdWVzdBIhCgxjYW5kaWRhdGVfaWQYASABKA'
        'lSC2NhbmRpZGF0ZUlkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use dismissDuplicateCandidateResponseDescriptor instead')
const DismissDuplicateCandidateResponse$json = {
  '1': 'DismissDuplicateCandidateResponse',
};

/// Descriptor for `DismissDuplicateCandidateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dismissDuplicateCandidateResponseDescriptor =
    $convert.base64Decode('CiFEaXNtaXNzRHVwbGljYXRlQ2FuZGlkYXRlUmVzcG9uc2U=');

@$core.Deprecated('Use effectiveWindowDescriptor instead')
const EffectiveWindow$json = {
  '1': 'EffectiveWindow',
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
      '1': 'until',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
  ],
};

/// Descriptor for `EffectiveWindow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List effectiveWindowDescriptor = $convert.base64Decode(
    'Cg9FZmZlY3RpdmVXaW5kb3cSLgoEZnJvbRgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSBGZyb20SMAoFdW50aWwYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgV1'
    'bnRpbA==');

@$core.Deprecated('Use patientNameDescriptor instead')
const PatientName$json = {
  '1': 'PatientName',
  '2': [
    {'1': 'name_id', '3': 1, '4': 1, '5': 9, '10': 'nameId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.NameKind',
      '10': 'kind'
    },
    {
      '1': 'name',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.HumanName',
      '10': 'name'
    },
    {
      '1': 'window',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.EffectiveWindow',
      '10': 'window'
    },
    {'1': 'recorded_by', '3': 5, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'source', '3': 7, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `PatientName`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientNameDescriptor = $convert.base64Decode(
    'CgtQYXRpZW50TmFtZRIXCgduYW1lX2lkGAEgASgJUgZuYW1lSWQSMAoEa2luZBgCIAEoDjIcLm'
    'hlYWx0aGNhcmUuZW1waS52MS5OYW1lS2luZFIEa2luZBIxCgRuYW1lGAMgASgLMh0uaGVhbHRo'
    'Y2FyZS5lbXBpLnYxLkh1bWFuTmFtZVIEbmFtZRI7CgZ3aW5kb3cYBCABKAsyIy5oZWFsdGhjYX'
    'JlLmVtcGkudjEuRWZmZWN0aXZlV2luZG93UgZ3aW5kb3cSHwoLcmVjb3JkZWRfYnkYBSABKAlS'
    'CnJlY29yZGVkQnkSOwoLcmVjb3JkZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgpyZWNvcmRlZEF0EhYKBnNvdXJjZRgHIAEoCVIGc291cmNl');

@$core.Deprecated('Use communicationPreferenceDescriptor instead')
const CommunicationPreference$json = {
  '1': 'CommunicationPreference',
  '2': [
    {'1': 'preference_id', '3': 1, '4': 1, '5': 9, '10': 'preferenceId'},
    {
      '1': 'channel',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.CommunicationChannel',
      '10': 'channel'
    },
    {
      '1': 'purpose',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.CommunicationPurpose',
      '10': 'purpose'
    },
    {'1': 'allowed', '3': 4, '4': 1, '5': 8, '10': 'allowed'},
    {
      '1': 'window',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.EffectiveWindow',
      '10': 'window'
    },
    {'1': 'recorded_by', '3': 6, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `CommunicationPreference`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List communicationPreferenceDescriptor = $convert.base64Decode(
    'ChdDb21tdW5pY2F0aW9uUHJlZmVyZW5jZRIjCg1wcmVmZXJlbmNlX2lkGAEgASgJUgxwcmVmZX'
    'JlbmNlSWQSQgoHY2hhbm5lbBgCIAEoDjIoLmhlYWx0aGNhcmUuZW1waS52MS5Db21tdW5pY2F0'
    'aW9uQ2hhbm5lbFIHY2hhbm5lbBJCCgdwdXJwb3NlGAMgASgOMiguaGVhbHRoY2FyZS5lbXBpLn'
    'YxLkNvbW11bmljYXRpb25QdXJwb3NlUgdwdXJwb3NlEhgKB2FsbG93ZWQYBCABKAhSB2FsbG93'
    'ZWQSOwoGd2luZG93GAUgASgLMiMuaGVhbHRoY2FyZS5lbXBpLnYxLkVmZmVjdGl2ZVdpbmRvd1'
    'IGd2luZG93Eh8KC3JlY29yZGVkX2J5GAYgASgJUgpyZWNvcmRlZEJ5');

@$core.Deprecated('Use relatedPersonDescriptor instead')
const RelatedPerson$json = {
  '1': 'RelatedPerson',
  '2': [
    {'1': 'relationship_id', '3': 1, '4': 1, '5': 9, '10': 'relationshipId'},
    {
      '1': 'related_patient_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'relatedPatientId'
    },
    {
      '1': 'name',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.HumanName',
      '10': 'name'
    },
    {
      '1': 'contact',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.ContactPoint',
      '10': 'contact'
    },
    {
      '1': 'relationship',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.RelationshipType',
      '10': 'relationship'
    },
    {
      '1': 'authorities',
      '3': 6,
      '4': 3,
      '5': 14,
      '6': '.healthcare.empi.v1.Authority',
      '10': 'authorities'
    },
    {
      '1': 'window',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.EffectiveWindow',
      '10': 'window'
    },
    {'1': 'verified_by', '3': 8, '4': 1, '5': 9, '10': 'verifiedBy'},
    {
      '1': 'verified_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'verifiedAt'
    },
    {
      '1': 'verification_note',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'verificationNote'
    },
    {'1': 'recorded_by', '3': 11, '4': 1, '5': 9, '10': 'recordedBy'},
  ],
};

/// Descriptor for `RelatedPerson`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relatedPersonDescriptor = $convert.base64Decode(
    'Cg1SZWxhdGVkUGVyc29uEicKD3JlbGF0aW9uc2hpcF9pZBgBIAEoCVIOcmVsYXRpb25zaGlwSW'
    'QSLAoScmVsYXRlZF9wYXRpZW50X2lkGAIgASgJUhByZWxhdGVkUGF0aWVudElkEjEKBG5hbWUY'
    'AyABKAsyHS5oZWFsdGhjYXJlLmVtcGkudjEuSHVtYW5OYW1lUgRuYW1lEjoKB2NvbnRhY3QYBC'
    'ADKAsyIC5oZWFsdGhjYXJlLmVtcGkudjEuQ29udGFjdFBvaW50Ugdjb250YWN0EkgKDHJlbGF0'
    'aW9uc2hpcBgFIAEoDjIkLmhlYWx0aGNhcmUuZW1waS52MS5SZWxhdGlvbnNoaXBUeXBlUgxyZW'
    'xhdGlvbnNoaXASPwoLYXV0aG9yaXRpZXMYBiADKA4yHS5oZWFsdGhjYXJlLmVtcGkudjEuQXV0'
    'aG9yaXR5UgthdXRob3JpdGllcxI7CgZ3aW5kb3cYByABKAsyIy5oZWFsdGhjYXJlLmVtcGkudj'
    'EuRWZmZWN0aXZlV2luZG93UgZ3aW5kb3cSHwoLdmVyaWZpZWRfYnkYCCABKAlSCnZlcmlmaWVk'
    'QnkSOwoLdmVyaWZpZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgp2ZX'
    'JpZmllZEF0EisKEXZlcmlmaWNhdGlvbl9ub3RlGAogASgJUhB2ZXJpZmljYXRpb25Ob3RlEh8K'
    'C3JlY29yZGVkX2J5GAsgASgJUgpyZWNvcmRlZEJ5');

@$core.Deprecated('Use recordNameRequestDescriptor instead')
const RecordNameRequest$json = {
  '1': 'RecordNameRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.NameKind',
      '10': 'kind'
    },
    {
      '1': 'name',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.HumanName',
      '10': 'name'
    },
    {
      '1': 'effective_from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {'1': 'source', '3': 5, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `RecordNameRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordNameRequestDescriptor = $convert.base64Decode(
    'ChFSZWNvcmROYW1lUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSMAoEa2'
    'luZBgCIAEoDjIcLmhlYWx0aGNhcmUuZW1waS52MS5OYW1lS2luZFIEa2luZBIxCgRuYW1lGAMg'
    'ASgLMh0uaGVhbHRoY2FyZS5lbXBpLnYxLkh1bWFuTmFtZVIEbmFtZRJBCg5lZmZlY3RpdmVfZn'
    'JvbRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SFgoG'
    'c291cmNlGAUgASgJUgZzb3VyY2U=');

@$core.Deprecated('Use recordNameResponseDescriptor instead')
const RecordNameResponse$json = {
  '1': 'RecordNameResponse',
};

/// Descriptor for `RecordNameResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordNameResponseDescriptor =
    $convert.base64Decode('ChJSZWNvcmROYW1lUmVzcG9uc2U=');

@$core.Deprecated('Use getPatientHistoryRequestDescriptor instead')
const GetPatientHistoryRequest$json = {
  '1': 'GetPatientHistoryRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `GetPatientHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRQYXRpZW50SGlzdG9yeVJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudE'
        'lk');

@$core.Deprecated('Use getPatientHistoryResponseDescriptor instead')
const GetPatientHistoryResponse$json = {
  '1': 'GetPatientHistoryResponse',
  '2': [
    {
      '1': 'names',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.PatientName',
      '10': 'names'
    },
    {
      '1': 'preferences',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.CommunicationPreference',
      '10': 'preferences'
    },
    {
      '1': 'related',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.RelatedPerson',
      '10': 'related'
    },
  ],
};

/// Descriptor for `GetPatientHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPatientHistoryResponseDescriptor = $convert.base64Decode(
    'ChlHZXRQYXRpZW50SGlzdG9yeVJlc3BvbnNlEjUKBW5hbWVzGAEgAygLMh8uaGVhbHRoY2FyZS'
    '5lbXBpLnYxLlBhdGllbnROYW1lUgVuYW1lcxJNCgtwcmVmZXJlbmNlcxgCIAMoCzIrLmhlYWx0'
    'aGNhcmUuZW1waS52MS5Db21tdW5pY2F0aW9uUHJlZmVyZW5jZVILcHJlZmVyZW5jZXMSOwoHcm'
    'VsYXRlZBgDIAMoCzIhLmhlYWx0aGNhcmUuZW1waS52MS5SZWxhdGVkUGVyc29uUgdyZWxhdGVk');

@$core.Deprecated('Use recordCommunicationPreferenceRequestDescriptor instead')
const RecordCommunicationPreferenceRequest$json = {
  '1': 'RecordCommunicationPreferenceRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'channel',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.CommunicationChannel',
      '10': 'channel'
    },
    {
      '1': 'purpose',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.CommunicationPurpose',
      '10': 'purpose'
    },
    {'1': 'allowed', '3': 4, '4': 1, '5': 8, '10': 'allowed'},
    {
      '1': 'effective_from',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `RecordCommunicationPreferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCommunicationPreferenceRequestDescriptor = $convert.base64Decode(
    'CiRSZWNvcmRDb21tdW5pY2F0aW9uUHJlZmVyZW5jZVJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIA'
    'EoCVIJcGF0aWVudElkEkIKB2NoYW5uZWwYAiABKA4yKC5oZWFsdGhjYXJlLmVtcGkudjEuQ29t'
    'bXVuaWNhdGlvbkNoYW5uZWxSB2NoYW5uZWwSQgoHcHVycG9zZRgDIAEoDjIoLmhlYWx0aGNhcm'
    'UuZW1waS52MS5Db21tdW5pY2F0aW9uUHVycG9zZVIHcHVycG9zZRIYCgdhbGxvd2VkGAQgASgI'
    'UgdhbGxvd2VkEkEKDmVmZmVjdGl2ZV9mcm9tGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFINZWZmZWN0aXZlRnJvbQ==');

@$core.Deprecated('Use recordCommunicationPreferenceResponseDescriptor instead')
const RecordCommunicationPreferenceResponse$json = {
  '1': 'RecordCommunicationPreferenceResponse',
};

/// Descriptor for `RecordCommunicationPreferenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCommunicationPreferenceResponseDescriptor =
    $convert
        .base64Decode('CiVSZWNvcmRDb21tdW5pY2F0aW9uUHJlZmVyZW5jZVJlc3BvbnNl');

@$core.Deprecated('Use recordDeceasedRequestDescriptor instead')
const RecordDeceasedRequest$json = {
  '1': 'RecordDeceasedRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'date',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.PartialDate',
      '10': 'date'
    },
    {'1': 'source', '3': 3, '4': 1, '5': 9, '10': 'source'},
  ],
};

/// Descriptor for `RecordDeceasedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeceasedRequestDescriptor = $convert.base64Decode(
    'ChVSZWNvcmREZWNlYXNlZFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEj'
    'MKBGRhdGUYAiABKAsyHy5oZWFsdGhjYXJlLmVtcGkudjEuUGFydGlhbERhdGVSBGRhdGUSFgoG'
    'c291cmNlGAMgASgJUgZzb3VyY2U=');

@$core.Deprecated('Use recordDeceasedResponseDescriptor instead')
const RecordDeceasedResponse$json = {
  '1': 'RecordDeceasedResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `RecordDeceasedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeceasedResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWNvcmREZWNlYXNlZFJlc3BvbnNlEjUKB3BhdGllbnQYASABKAsyGy5oZWFsdGhjYXJlLm'
        'VtcGkudjEuUGF0aWVudFIHcGF0aWVudA==');

@$core.Deprecated('Use reverseDeceasedRequestDescriptor instead')
const ReverseDeceasedRequest$json = {
  '1': 'ReverseDeceasedRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReverseDeceasedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseDeceasedRequestDescriptor =
    $convert.base64Decode(
        'ChZSZXZlcnNlRGVjZWFzZWRSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
        'IWCgZyZWFzb24YAiABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use reverseDeceasedResponseDescriptor instead')
const ReverseDeceasedResponse$json = {
  '1': 'ReverseDeceasedResponse',
  '2': [
    {
      '1': 'patient',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.Patient',
      '10': 'patient'
    },
  ],
};

/// Descriptor for `ReverseDeceasedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reverseDeceasedResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXZlcnNlRGVjZWFzZWRSZXNwb25zZRI1CgdwYXRpZW50GAEgASgLMhsuaGVhbHRoY2FyZS'
        '5lbXBpLnYxLlBhdGllbnRSB3BhdGllbnQ=');

@$core.Deprecated('Use addRelatedPersonRequestDescriptor instead')
const AddRelatedPersonRequest$json = {
  '1': 'AddRelatedPersonRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'related_patient_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'relatedPatientId'
    },
    {
      '1': 'name',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.HumanName',
      '10': 'name'
    },
    {
      '1': 'contact',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.empi.v1.ContactPoint',
      '10': 'contact'
    },
    {
      '1': 'relationship',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.empi.v1.RelationshipType',
      '10': 'relationship'
    },
    {
      '1': 'authorities',
      '3': 6,
      '4': 3,
      '5': 14,
      '6': '.healthcare.empi.v1.Authority',
      '10': 'authorities'
    },
    {
      '1': 'effective_from',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `AddRelatedPersonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addRelatedPersonRequestDescriptor = $convert.base64Decode(
    'ChdBZGRSZWxhdGVkUGVyc29uUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSLAoScmVsYXRlZF9wYXRpZW50X2lkGAIgASgJUhByZWxhdGVkUGF0aWVudElkEjEKBG5hbWUY'
    'AyABKAsyHS5oZWFsdGhjYXJlLmVtcGkudjEuSHVtYW5OYW1lUgRuYW1lEjoKB2NvbnRhY3QYBC'
    'ADKAsyIC5oZWFsdGhjYXJlLmVtcGkudjEuQ29udGFjdFBvaW50Ugdjb250YWN0EkgKDHJlbGF0'
    'aW9uc2hpcBgFIAEoDjIkLmhlYWx0aGNhcmUuZW1waS52MS5SZWxhdGlvbnNoaXBUeXBlUgxyZW'
    'xhdGlvbnNoaXASPwoLYXV0aG9yaXRpZXMYBiADKA4yHS5oZWFsdGhjYXJlLmVtcGkudjEuQXV0'
    'aG9yaXR5UgthdXRob3JpdGllcxJBCg5lZmZlY3RpdmVfZnJvbRgHIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SQwoPZWZmZWN0aXZlX3VudGlsGAggASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOZWZmZWN0aXZlVW50aWw=');

@$core.Deprecated('Use addRelatedPersonResponseDescriptor instead')
const AddRelatedPersonResponse$json = {
  '1': 'AddRelatedPersonResponse',
  '2': [
    {
      '1': 'related',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.empi.v1.RelatedPerson',
      '10': 'related'
    },
  ],
};

/// Descriptor for `AddRelatedPersonResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addRelatedPersonResponseDescriptor =
    $convert.base64Decode(
        'ChhBZGRSZWxhdGVkUGVyc29uUmVzcG9uc2USOwoHcmVsYXRlZBgBIAEoCzIhLmhlYWx0aGNhcm'
        'UuZW1waS52MS5SZWxhdGVkUGVyc29uUgdyZWxhdGVk');

@$core.Deprecated('Use verifyRelatedPersonRequestDescriptor instead')
const VerifyRelatedPersonRequest$json = {
  '1': 'VerifyRelatedPersonRequest',
  '2': [
    {'1': 'relationship_id', '3': 1, '4': 1, '5': 9, '10': 'relationshipId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `VerifyRelatedPersonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyRelatedPersonRequestDescriptor =
    $convert.base64Decode(
        'ChpWZXJpZnlSZWxhdGVkUGVyc29uUmVxdWVzdBInCg9yZWxhdGlvbnNoaXBfaWQYASABKAlSDn'
        'JlbGF0aW9uc2hpcElkEhIKBG5vdGUYAiABKAlSBG5vdGU=');

@$core.Deprecated('Use verifyRelatedPersonResponseDescriptor instead')
const VerifyRelatedPersonResponse$json = {
  '1': 'VerifyRelatedPersonResponse',
};

/// Descriptor for `VerifyRelatedPersonResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyRelatedPersonResponseDescriptor =
    $convert.base64Decode('ChtWZXJpZnlSZWxhdGVkUGVyc29uUmVzcG9uc2U=');

@$core.Deprecated('Use endRelatedPersonRequestDescriptor instead')
const EndRelatedPersonRequest$json = {
  '1': 'EndRelatedPersonRequest',
  '2': [
    {'1': 'relationship_id', '3': 1, '4': 1, '5': 9, '10': 'relationshipId'},
  ],
};

/// Descriptor for `EndRelatedPersonRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endRelatedPersonRequestDescriptor =
    $convert.base64Decode(
        'ChdFbmRSZWxhdGVkUGVyc29uUmVxdWVzdBInCg9yZWxhdGlvbnNoaXBfaWQYASABKAlSDnJlbG'
        'F0aW9uc2hpcElk');

@$core.Deprecated('Use endRelatedPersonResponseDescriptor instead')
const EndRelatedPersonResponse$json = {
  '1': 'EndRelatedPersonResponse',
};

/// Descriptor for `EndRelatedPersonResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endRelatedPersonResponseDescriptor =
    $convert.base64Decode('ChhFbmRSZWxhdGVkUGVyc29uUmVzcG9uc2U=');

@$core.Deprecated('Use getCaregiverAuthorityRequestDescriptor instead')
const GetCaregiverAuthorityRequest$json = {
  '1': 'GetCaregiverAuthorityRequest',
  '2': [
    {'1': 'holder_patient_id', '3': 1, '4': 1, '5': 9, '10': 'holderPatientId'},
    {
      '1': 'subject_patient_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'subjectPatientId'
    },
  ],
};

/// Descriptor for `GetCaregiverAuthorityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaregiverAuthorityRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRDYXJlZ2l2ZXJBdXRob3JpdHlSZXF1ZXN0EioKEWhvbGRlcl9wYXRpZW50X2lkGAEgAS'
        'gJUg9ob2xkZXJQYXRpZW50SWQSLAoSc3ViamVjdF9wYXRpZW50X2lkGAIgASgJUhBzdWJqZWN0'
        'UGF0aWVudElk');

@$core.Deprecated('Use getCaregiverAuthorityResponseDescriptor instead')
const GetCaregiverAuthorityResponse$json = {
  '1': 'GetCaregiverAuthorityResponse',
  '2': [
    {
      '1': 'authorities',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.empi.v1.Authority',
      '10': 'authorities'
    },
  ],
};

/// Descriptor for `GetCaregiverAuthorityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaregiverAuthorityResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRDYXJlZ2l2ZXJBdXRob3JpdHlSZXNwb25zZRI/CgthdXRob3JpdGllcxgBIAMoDjIdLm'
        'hlYWx0aGNhcmUuZW1waS52MS5BdXRob3JpdHlSC2F1dGhvcml0aWVz');

const $core.Map<$core.String, $core.dynamic> PatientServiceBase$json = {
  '1': 'PatientService',
  '2': [
    {
      '1': 'RegisterPatient',
      '2': '.healthcare.empi.v1.RegisterPatientRequest',
      '3': '.healthcare.empi.v1.RegisterPatientResponse'
    },
    {
      '1': 'SearchPatients',
      '2': '.healthcare.empi.v1.SearchPatientsRequest',
      '3': '.healthcare.empi.v1.SearchPatientsResponse'
    },
    {
      '1': 'GetPatient',
      '2': '.healthcare.empi.v1.GetPatientRequest',
      '3': '.healthcare.empi.v1.GetPatientResponse'
    },
    {
      '1': 'UpdateDemographics',
      '2': '.healthcare.empi.v1.UpdateDemographicsRequest',
      '3': '.healthcare.empi.v1.UpdateDemographicsResponse'
    },
    {
      '1': 'ConfirmIdentity',
      '2': '.healthcare.empi.v1.ConfirmIdentityRequest',
      '3': '.healthcare.empi.v1.ConfirmIdentityResponse'
    },
    {
      '1': 'MergePatients',
      '2': '.healthcare.empi.v1.MergePatientsRequest',
      '3': '.healthcare.empi.v1.MergePatientsResponse'
    },
    {
      '1': 'UnmergePatients',
      '2': '.healthcare.empi.v1.UnmergePatientsRequest',
      '3': '.healthcare.empi.v1.UnmergePatientsResponse'
    },
    {
      '1': 'ListDuplicateCandidates',
      '2': '.healthcare.empi.v1.ListDuplicateCandidatesRequest',
      '3': '.healthcare.empi.v1.ListDuplicateCandidatesResponse'
    },
    {
      '1': 'DismissDuplicateCandidate',
      '2': '.healthcare.empi.v1.DismissDuplicateCandidateRequest',
      '3': '.healthcare.empi.v1.DismissDuplicateCandidateResponse'
    },
    {
      '1': 'RegisterUnidentified',
      '2': '.healthcare.empi.v1.RegisterUnidentifiedRequest',
      '3': '.healthcare.empi.v1.RegisterUnidentifiedResponse'
    },
    {
      '1': 'IdentifyPatient',
      '2': '.healthcare.empi.v1.IdentifyPatientRequest',
      '3': '.healthcare.empi.v1.IdentifyPatientResponse'
    },
    {
      '1': 'ListUnidentified',
      '2': '.healthcare.empi.v1.ListUnidentifiedRequest',
      '3': '.healthcare.empi.v1.ListUnidentifiedResponse'
    },
    {
      '1': 'CapturePhoto',
      '2': '.healthcare.empi.v1.CapturePhotoRequest',
      '3': '.healthcare.empi.v1.CapturePhotoResponse'
    },
    {
      '1': 'GetPhoto',
      '2': '.healthcare.empi.v1.GetPhotoRequest',
      '3': '.healthcare.empi.v1.GetPhotoResponse'
    },
    {
      '1': 'WithdrawPhotoConsent',
      '2': '.healthcare.empi.v1.WithdrawPhotoConsentRequest',
      '3': '.healthcare.empi.v1.WithdrawPhotoConsentResponse'
    },
    {
      '1': 'ConfigureFieldAccess',
      '2': '.healthcare.empi.v1.ConfigureFieldAccessRequest',
      '3': '.healthcare.empi.v1.ConfigureFieldAccessResponse'
    },
    {
      '1': 'LinkIdentifier',
      '2': '.healthcare.empi.v1.LinkIdentifierRequest',
      '3': '.healthcare.empi.v1.LinkIdentifierResponse'
    },
    {
      '1': 'UnlinkIdentifier',
      '2': '.healthcare.empi.v1.UnlinkIdentifierRequest',
      '3': '.healthcare.empi.v1.UnlinkIdentifierResponse'
    },
    {
      '1': 'VerifyIdentifier',
      '2': '.healthcare.empi.v1.VerifyIdentifierRequest',
      '3': '.healthcare.empi.v1.VerifyIdentifierResponse'
    },
    {
      '1': 'SubmitExternalDemographics',
      '2': '.healthcare.empi.v1.SubmitExternalDemographicsRequest',
      '3': '.healthcare.empi.v1.SubmitExternalDemographicsResponse'
    },
    {
      '1': 'RequestCorrection',
      '2': '.healthcare.empi.v1.RequestCorrectionRequest',
      '3': '.healthcare.empi.v1.RequestCorrectionResponse'
    },
    {
      '1': 'ListDemographicProposals',
      '2': '.healthcare.empi.v1.ListDemographicProposalsRequest',
      '3': '.healthcare.empi.v1.ListDemographicProposalsResponse'
    },
    {
      '1': 'ResolveDemographicProposal',
      '2': '.healthcare.empi.v1.ResolveDemographicProposalRequest',
      '3': '.healthcare.empi.v1.ResolveDemographicProposalResponse'
    },
    {
      '1': 'WithdrawDemographicProposal',
      '2': '.healthcare.empi.v1.WithdrawDemographicProposalRequest',
      '3': '.healthcare.empi.v1.WithdrawDemographicProposalResponse'
    },
    {
      '1': 'RecordName',
      '2': '.healthcare.empi.v1.RecordNameRequest',
      '3': '.healthcare.empi.v1.RecordNameResponse'
    },
    {
      '1': 'GetPatientHistory',
      '2': '.healthcare.empi.v1.GetPatientHistoryRequest',
      '3': '.healthcare.empi.v1.GetPatientHistoryResponse'
    },
    {
      '1': 'RecordCommunicationPreference',
      '2': '.healthcare.empi.v1.RecordCommunicationPreferenceRequest',
      '3': '.healthcare.empi.v1.RecordCommunicationPreferenceResponse'
    },
    {
      '1': 'RecordDeceased',
      '2': '.healthcare.empi.v1.RecordDeceasedRequest',
      '3': '.healthcare.empi.v1.RecordDeceasedResponse'
    },
    {
      '1': 'ReverseDeceased',
      '2': '.healthcare.empi.v1.ReverseDeceasedRequest',
      '3': '.healthcare.empi.v1.ReverseDeceasedResponse'
    },
    {
      '1': 'AddRelatedPerson',
      '2': '.healthcare.empi.v1.AddRelatedPersonRequest',
      '3': '.healthcare.empi.v1.AddRelatedPersonResponse'
    },
    {
      '1': 'VerifyRelatedPerson',
      '2': '.healthcare.empi.v1.VerifyRelatedPersonRequest',
      '3': '.healthcare.empi.v1.VerifyRelatedPersonResponse'
    },
    {
      '1': 'EndRelatedPerson',
      '2': '.healthcare.empi.v1.EndRelatedPersonRequest',
      '3': '.healthcare.empi.v1.EndRelatedPersonResponse'
    },
    {
      '1': 'GetCaregiverAuthority',
      '2': '.healthcare.empi.v1.GetCaregiverAuthorityRequest',
      '3': '.healthcare.empi.v1.GetCaregiverAuthorityResponse'
    },
  ],
};

@$core.Deprecated('Use patientServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    PatientServiceBase$messageJson = {
  '.healthcare.empi.v1.RegisterPatientRequest': RegisterPatientRequest$json,
  '.healthcare.empi.v1.Demographics': Demographics$json,
  '.healthcare.empi.v1.HumanName': HumanName$json,
  '.healthcare.empi.v1.PartialDate': PartialDate$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.empi.v1.ContactPoint': ContactPoint$json,
  '.healthcare.empi.v1.Address': Address$json,
  '.healthcare.empi.v1.PatientIdentifier': PatientIdentifier$json,
  '.healthcare.empi.v1.RegisterPatientResponse': RegisterPatientResponse$json,
  '.healthcare.empi.v1.Patient': Patient$json,
  '.healthcare.empi.v1.DeceasedRecord': DeceasedRecord$json,
  '.healthcare.empi.v1.TemporaryDesignation': TemporaryDesignation$json,
  '.healthcare.empi.v1.PatientMatch': PatientMatch$json,
  '.healthcare.empi.v1.MatchFieldScore': MatchFieldScore$json,
  '.healthcare.empi.v1.PatientName': PatientName$json,
  '.healthcare.empi.v1.EffectiveWindow': EffectiveWindow$json,
  '.healthcare.empi.v1.SearchPatientsRequest': SearchPatientsRequest$json,
  '.healthcare.empi.v1.SearchPatientsResponse': SearchPatientsResponse$json,
  '.healthcare.empi.v1.GetPatientRequest': GetPatientRequest$json,
  '.healthcare.empi.v1.GetPatientResponse': GetPatientResponse$json,
  '.healthcare.empi.v1.UpdateDemographicsRequest':
      UpdateDemographicsRequest$json,
  '.healthcare.empi.v1.UpdateDemographicsResponse':
      UpdateDemographicsResponse$json,
  '.healthcare.empi.v1.ConfirmIdentityRequest': ConfirmIdentityRequest$json,
  '.healthcare.empi.v1.IdentityEvidence': IdentityEvidence$json,
  '.healthcare.empi.v1.ConfirmIdentityResponse': ConfirmIdentityResponse$json,
  '.healthcare.empi.v1.MergePatientsRequest': MergePatientsRequest$json,
  '.healthcare.empi.v1.MergePatientsResponse': MergePatientsResponse$json,
  '.healthcare.empi.v1.UnmergePatientsRequest': UnmergePatientsRequest$json,
  '.healthcare.empi.v1.UnmergePatientsResponse': UnmergePatientsResponse$json,
  '.healthcare.empi.v1.ListDuplicateCandidatesRequest':
      ListDuplicateCandidatesRequest$json,
  '.healthcare.empi.v1.ListDuplicateCandidatesResponse':
      ListDuplicateCandidatesResponse$json,
  '.healthcare.empi.v1.DuplicateCandidate': DuplicateCandidate$json,
  '.healthcare.empi.v1.DismissDuplicateCandidateRequest':
      DismissDuplicateCandidateRequest$json,
  '.healthcare.empi.v1.DismissDuplicateCandidateResponse':
      DismissDuplicateCandidateResponse$json,
  '.healthcare.empi.v1.RegisterUnidentifiedRequest':
      RegisterUnidentifiedRequest$json,
  '.healthcare.empi.v1.RegisterUnidentifiedResponse':
      RegisterUnidentifiedResponse$json,
  '.healthcare.empi.v1.IdentifyPatientRequest': IdentifyPatientRequest$json,
  '.healthcare.empi.v1.IdentifyPatientResponse': IdentifyPatientResponse$json,
  '.healthcare.empi.v1.ListUnidentifiedRequest': ListUnidentifiedRequest$json,
  '.healthcare.empi.v1.ListUnidentifiedResponse': ListUnidentifiedResponse$json,
  '.healthcare.empi.v1.CapturePhotoRequest': CapturePhotoRequest$json,
  '.healthcare.empi.v1.PhotoConsent': PhotoConsent$json,
  '.healthcare.empi.v1.CapturePhotoResponse': CapturePhotoResponse$json,
  '.healthcare.empi.v1.PatientPhoto': PatientPhoto$json,
  '.healthcare.empi.v1.GetPhotoRequest': GetPhotoRequest$json,
  '.healthcare.empi.v1.GetPhotoResponse': GetPhotoResponse$json,
  '.healthcare.empi.v1.WithdrawPhotoConsentRequest':
      WithdrawPhotoConsentRequest$json,
  '.healthcare.empi.v1.WithdrawPhotoConsentResponse':
      WithdrawPhotoConsentResponse$json,
  '.healthcare.empi.v1.ConfigureFieldAccessRequest':
      ConfigureFieldAccessRequest$json,
  '.healthcare.empi.v1.ConfigureFieldAccessResponse':
      ConfigureFieldAccessResponse$json,
  '.healthcare.empi.v1.LinkIdentifierRequest': LinkIdentifierRequest$json,
  '.healthcare.empi.v1.LinkIdentifierResponse': LinkIdentifierResponse$json,
  '.healthcare.empi.v1.UnlinkIdentifierRequest': UnlinkIdentifierRequest$json,
  '.healthcare.empi.v1.UnlinkIdentifierResponse': UnlinkIdentifierResponse$json,
  '.healthcare.empi.v1.VerifyIdentifierRequest': VerifyIdentifierRequest$json,
  '.healthcare.empi.v1.VerifyIdentifierResponse': VerifyIdentifierResponse$json,
  '.healthcare.empi.v1.SubmitExternalDemographicsRequest':
      SubmitExternalDemographicsRequest$json,
  '.healthcare.empi.v1.SubmitExternalDemographicsResponse':
      SubmitExternalDemographicsResponse$json,
  '.healthcare.empi.v1.DemographicProposal': DemographicProposal$json,
  '.healthcare.empi.v1.ProposedFieldChange': ProposedFieldChange$json,
  '.healthcare.empi.v1.RequestCorrectionRequest': RequestCorrectionRequest$json,
  '.healthcare.empi.v1.RequestCorrectionResponse':
      RequestCorrectionResponse$json,
  '.healthcare.empi.v1.ListDemographicProposalsRequest':
      ListDemographicProposalsRequest$json,
  '.healthcare.empi.v1.ListDemographicProposalsResponse':
      ListDemographicProposalsResponse$json,
  '.healthcare.empi.v1.ResolveDemographicProposalRequest':
      ResolveDemographicProposalRequest$json,
  '.healthcare.empi.v1.ResolveDemographicProposalResponse':
      ResolveDemographicProposalResponse$json,
  '.healthcare.empi.v1.WithdrawDemographicProposalRequest':
      WithdrawDemographicProposalRequest$json,
  '.healthcare.empi.v1.WithdrawDemographicProposalResponse':
      WithdrawDemographicProposalResponse$json,
  '.healthcare.empi.v1.RecordNameRequest': RecordNameRequest$json,
  '.healthcare.empi.v1.RecordNameResponse': RecordNameResponse$json,
  '.healthcare.empi.v1.GetPatientHistoryRequest': GetPatientHistoryRequest$json,
  '.healthcare.empi.v1.GetPatientHistoryResponse':
      GetPatientHistoryResponse$json,
  '.healthcare.empi.v1.CommunicationPreference': CommunicationPreference$json,
  '.healthcare.empi.v1.RelatedPerson': RelatedPerson$json,
  '.healthcare.empi.v1.RecordCommunicationPreferenceRequest':
      RecordCommunicationPreferenceRequest$json,
  '.healthcare.empi.v1.RecordCommunicationPreferenceResponse':
      RecordCommunicationPreferenceResponse$json,
  '.healthcare.empi.v1.RecordDeceasedRequest': RecordDeceasedRequest$json,
  '.healthcare.empi.v1.RecordDeceasedResponse': RecordDeceasedResponse$json,
  '.healthcare.empi.v1.ReverseDeceasedRequest': ReverseDeceasedRequest$json,
  '.healthcare.empi.v1.ReverseDeceasedResponse': ReverseDeceasedResponse$json,
  '.healthcare.empi.v1.AddRelatedPersonRequest': AddRelatedPersonRequest$json,
  '.healthcare.empi.v1.AddRelatedPersonResponse': AddRelatedPersonResponse$json,
  '.healthcare.empi.v1.VerifyRelatedPersonRequest':
      VerifyRelatedPersonRequest$json,
  '.healthcare.empi.v1.VerifyRelatedPersonResponse':
      VerifyRelatedPersonResponse$json,
  '.healthcare.empi.v1.EndRelatedPersonRequest': EndRelatedPersonRequest$json,
  '.healthcare.empi.v1.EndRelatedPersonResponse': EndRelatedPersonResponse$json,
  '.healthcare.empi.v1.GetCaregiverAuthorityRequest':
      GetCaregiverAuthorityRequest$json,
  '.healthcare.empi.v1.GetCaregiverAuthorityResponse':
      GetCaregiverAuthorityResponse$json,
};

/// Descriptor for `PatientService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List patientServiceDescriptor = $convert.base64Decode(
    'Cg5QYXRpZW50U2VydmljZRJqCg9SZWdpc3RlclBhdGllbnQSKi5oZWFsdGhjYXJlLmVtcGkudj'
    'EuUmVnaXN0ZXJQYXRpZW50UmVxdWVzdBorLmhlYWx0aGNhcmUuZW1waS52MS5SZWdpc3RlclBh'
    'dGllbnRSZXNwb25zZRJnCg5TZWFyY2hQYXRpZW50cxIpLmhlYWx0aGNhcmUuZW1waS52MS5TZW'
    'FyY2hQYXRpZW50c1JlcXVlc3QaKi5oZWFsdGhjYXJlLmVtcGkudjEuU2VhcmNoUGF0aWVudHNS'
    'ZXNwb25zZRJbCgpHZXRQYXRpZW50EiUuaGVhbHRoY2FyZS5lbXBpLnYxLkdldFBhdGllbnRSZX'
    'F1ZXN0GiYuaGVhbHRoY2FyZS5lbXBpLnYxLkdldFBhdGllbnRSZXNwb25zZRJzChJVcGRhdGVE'
    'ZW1vZ3JhcGhpY3MSLS5oZWFsdGhjYXJlLmVtcGkudjEuVXBkYXRlRGVtb2dyYXBoaWNzUmVxdW'
    'VzdBouLmhlYWx0aGNhcmUuZW1waS52MS5VcGRhdGVEZW1vZ3JhcGhpY3NSZXNwb25zZRJqCg9D'
    'b25maXJtSWRlbnRpdHkSKi5oZWFsdGhjYXJlLmVtcGkudjEuQ29uZmlybUlkZW50aXR5UmVxdW'
    'VzdBorLmhlYWx0aGNhcmUuZW1waS52MS5Db25maXJtSWRlbnRpdHlSZXNwb25zZRJkCg1NZXJn'
    'ZVBhdGllbnRzEiguaGVhbHRoY2FyZS5lbXBpLnYxLk1lcmdlUGF0aWVudHNSZXF1ZXN0GikuaG'
    'VhbHRoY2FyZS5lbXBpLnYxLk1lcmdlUGF0aWVudHNSZXNwb25zZRJqCg9Vbm1lcmdlUGF0aWVu'
    'dHMSKi5oZWFsdGhjYXJlLmVtcGkudjEuVW5tZXJnZVBhdGllbnRzUmVxdWVzdBorLmhlYWx0aG'
    'NhcmUuZW1waS52MS5Vbm1lcmdlUGF0aWVudHNSZXNwb25zZRKCAQoXTGlzdER1cGxpY2F0ZUNh'
    'bmRpZGF0ZXMSMi5oZWFsdGhjYXJlLmVtcGkudjEuTGlzdER1cGxpY2F0ZUNhbmRpZGF0ZXNSZX'
    'F1ZXN0GjMuaGVhbHRoY2FyZS5lbXBpLnYxLkxpc3REdXBsaWNhdGVDYW5kaWRhdGVzUmVzcG9u'
    'c2USiAEKGURpc21pc3NEdXBsaWNhdGVDYW5kaWRhdGUSNC5oZWFsdGhjYXJlLmVtcGkudjEuRG'
    'lzbWlzc0R1cGxpY2F0ZUNhbmRpZGF0ZVJlcXVlc3QaNS5oZWFsdGhjYXJlLmVtcGkudjEuRGlz'
    'bWlzc0R1cGxpY2F0ZUNhbmRpZGF0ZVJlc3BvbnNlEnkKFFJlZ2lzdGVyVW5pZGVudGlmaWVkEi'
    '8uaGVhbHRoY2FyZS5lbXBpLnYxLlJlZ2lzdGVyVW5pZGVudGlmaWVkUmVxdWVzdBowLmhlYWx0'
    'aGNhcmUuZW1waS52MS5SZWdpc3RlclVuaWRlbnRpZmllZFJlc3BvbnNlEmoKD0lkZW50aWZ5UG'
    'F0aWVudBIqLmhlYWx0aGNhcmUuZW1waS52MS5JZGVudGlmeVBhdGllbnRSZXF1ZXN0GisuaGVh'
    'bHRoY2FyZS5lbXBpLnYxLklkZW50aWZ5UGF0aWVudFJlc3BvbnNlEm0KEExpc3RVbmlkZW50aW'
    'ZpZWQSKy5oZWFsdGhjYXJlLmVtcGkudjEuTGlzdFVuaWRlbnRpZmllZFJlcXVlc3QaLC5oZWFs'
    'dGhjYXJlLmVtcGkudjEuTGlzdFVuaWRlbnRpZmllZFJlc3BvbnNlEmEKDENhcHR1cmVQaG90bx'
    'InLmhlYWx0aGNhcmUuZW1waS52MS5DYXB0dXJlUGhvdG9SZXF1ZXN0GiguaGVhbHRoY2FyZS5l'
    'bXBpLnYxLkNhcHR1cmVQaG90b1Jlc3BvbnNlElUKCEdldFBob3RvEiMuaGVhbHRoY2FyZS5lbX'
    'BpLnYxLkdldFBob3RvUmVxdWVzdBokLmhlYWx0aGNhcmUuZW1waS52MS5HZXRQaG90b1Jlc3Bv'
    'bnNlEnkKFFdpdGhkcmF3UGhvdG9Db25zZW50Ei8uaGVhbHRoY2FyZS5lbXBpLnYxLldpdGhkcm'
    'F3UGhvdG9Db25zZW50UmVxdWVzdBowLmhlYWx0aGNhcmUuZW1waS52MS5XaXRoZHJhd1Bob3Rv'
    'Q29uc2VudFJlc3BvbnNlEnkKFENvbmZpZ3VyZUZpZWxkQWNjZXNzEi8uaGVhbHRoY2FyZS5lbX'
    'BpLnYxLkNvbmZpZ3VyZUZpZWxkQWNjZXNzUmVxdWVzdBowLmhlYWx0aGNhcmUuZW1waS52MS5D'
    'b25maWd1cmVGaWVsZEFjY2Vzc1Jlc3BvbnNlEmcKDkxpbmtJZGVudGlmaWVyEikuaGVhbHRoY2'
    'FyZS5lbXBpLnYxLkxpbmtJZGVudGlmaWVyUmVxdWVzdBoqLmhlYWx0aGNhcmUuZW1waS52MS5M'
    'aW5rSWRlbnRpZmllclJlc3BvbnNlEm0KEFVubGlua0lkZW50aWZpZXISKy5oZWFsdGhjYXJlLm'
    'VtcGkudjEuVW5saW5rSWRlbnRpZmllclJlcXVlc3QaLC5oZWFsdGhjYXJlLmVtcGkudjEuVW5s'
    'aW5rSWRlbnRpZmllclJlc3BvbnNlEm0KEFZlcmlmeUlkZW50aWZpZXISKy5oZWFsdGhjYXJlLm'
    'VtcGkudjEuVmVyaWZ5SWRlbnRpZmllclJlcXVlc3QaLC5oZWFsdGhjYXJlLmVtcGkudjEuVmVy'
    'aWZ5SWRlbnRpZmllclJlc3BvbnNlEosBChpTdWJtaXRFeHRlcm5hbERlbW9ncmFwaGljcxI1Lm'
    'hlYWx0aGNhcmUuZW1waS52MS5TdWJtaXRFeHRlcm5hbERlbW9ncmFwaGljc1JlcXVlc3QaNi5o'
    'ZWFsdGhjYXJlLmVtcGkudjEuU3VibWl0RXh0ZXJuYWxEZW1vZ3JhcGhpY3NSZXNwb25zZRJwCh'
    'FSZXF1ZXN0Q29ycmVjdGlvbhIsLmhlYWx0aGNhcmUuZW1waS52MS5SZXF1ZXN0Q29ycmVjdGlv'
    'blJlcXVlc3QaLS5oZWFsdGhjYXJlLmVtcGkudjEuUmVxdWVzdENvcnJlY3Rpb25SZXNwb25zZR'
    'KFAQoYTGlzdERlbW9ncmFwaGljUHJvcG9zYWxzEjMuaGVhbHRoY2FyZS5lbXBpLnYxLkxpc3RE'
    'ZW1vZ3JhcGhpY1Byb3Bvc2Fsc1JlcXVlc3QaNC5oZWFsdGhjYXJlLmVtcGkudjEuTGlzdERlbW'
    '9ncmFwaGljUHJvcG9zYWxzUmVzcG9uc2USiwEKGlJlc29sdmVEZW1vZ3JhcGhpY1Byb3Bvc2Fs'
    'EjUuaGVhbHRoY2FyZS5lbXBpLnYxLlJlc29sdmVEZW1vZ3JhcGhpY1Byb3Bvc2FsUmVxdWVzdB'
    'o2LmhlYWx0aGNhcmUuZW1waS52MS5SZXNvbHZlRGVtb2dyYXBoaWNQcm9wb3NhbFJlc3BvbnNl'
    'Eo4BChtXaXRoZHJhd0RlbW9ncmFwaGljUHJvcG9zYWwSNi5oZWFsdGhjYXJlLmVtcGkudjEuV2'
    'l0aGRyYXdEZW1vZ3JhcGhpY1Byb3Bvc2FsUmVxdWVzdBo3LmhlYWx0aGNhcmUuZW1waS52MS5X'
    'aXRoZHJhd0RlbW9ncmFwaGljUHJvcG9zYWxSZXNwb25zZRJbCgpSZWNvcmROYW1lEiUuaGVhbH'
    'RoY2FyZS5lbXBpLnYxLlJlY29yZE5hbWVSZXF1ZXN0GiYuaGVhbHRoY2FyZS5lbXBpLnYxLlJl'
    'Y29yZE5hbWVSZXNwb25zZRJwChFHZXRQYXRpZW50SGlzdG9yeRIsLmhlYWx0aGNhcmUuZW1waS'
    '52MS5HZXRQYXRpZW50SGlzdG9yeVJlcXVlc3QaLS5oZWFsdGhjYXJlLmVtcGkudjEuR2V0UGF0'
    'aWVudEhpc3RvcnlSZXNwb25zZRKUAQodUmVjb3JkQ29tbXVuaWNhdGlvblByZWZlcmVuY2USOC'
    '5oZWFsdGhjYXJlLmVtcGkudjEuUmVjb3JkQ29tbXVuaWNhdGlvblByZWZlcmVuY2VSZXF1ZXN0'
    'GjkuaGVhbHRoY2FyZS5lbXBpLnYxLlJlY29yZENvbW11bmljYXRpb25QcmVmZXJlbmNlUmVzcG'
    '9uc2USZwoOUmVjb3JkRGVjZWFzZWQSKS5oZWFsdGhjYXJlLmVtcGkudjEuUmVjb3JkRGVjZWFz'
    'ZWRSZXF1ZXN0GiouaGVhbHRoY2FyZS5lbXBpLnYxLlJlY29yZERlY2Vhc2VkUmVzcG9uc2USag'
    'oPUmV2ZXJzZURlY2Vhc2VkEiouaGVhbHRoY2FyZS5lbXBpLnYxLlJldmVyc2VEZWNlYXNlZFJl'
    'cXVlc3QaKy5oZWFsdGhjYXJlLmVtcGkudjEuUmV2ZXJzZURlY2Vhc2VkUmVzcG9uc2USbQoQQW'
    'RkUmVsYXRlZFBlcnNvbhIrLmhlYWx0aGNhcmUuZW1waS52MS5BZGRSZWxhdGVkUGVyc29uUmVx'
    'dWVzdBosLmhlYWx0aGNhcmUuZW1waS52MS5BZGRSZWxhdGVkUGVyc29uUmVzcG9uc2USdgoTVm'
    'VyaWZ5UmVsYXRlZFBlcnNvbhIuLmhlYWx0aGNhcmUuZW1waS52MS5WZXJpZnlSZWxhdGVkUGVy'
    'c29uUmVxdWVzdBovLmhlYWx0aGNhcmUuZW1waS52MS5WZXJpZnlSZWxhdGVkUGVyc29uUmVzcG'
    '9uc2USbQoQRW5kUmVsYXRlZFBlcnNvbhIrLmhlYWx0aGNhcmUuZW1waS52MS5FbmRSZWxhdGVk'
    'UGVyc29uUmVxdWVzdBosLmhlYWx0aGNhcmUuZW1waS52MS5FbmRSZWxhdGVkUGVyc29uUmVzcG'
    '9uc2USfAoVR2V0Q2FyZWdpdmVyQXV0aG9yaXR5EjAuaGVhbHRoY2FyZS5lbXBpLnYxLkdldENh'
    'cmVnaXZlckF1dGhvcml0eVJlcXVlc3QaMS5oZWFsdGhjYXJlLmVtcGkudjEuR2V0Q2FyZWdpdm'
    'VyQXV0aG9yaXR5UmVzcG9uc2U=');
