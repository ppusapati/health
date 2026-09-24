// This is a generated file - do not edit.
//
// Generated from healthcare/nursing/v1/nursing.proto.

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

@$core.Deprecated('Use entrySourceDescriptor instead')
const EntrySource$json = {
  '1': 'EntrySource',
  '2': [
    {'1': 'ENTRY_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'ENTRY_SOURCE_MANUAL', '2': 1},
    {'1': 'ENTRY_SOURCE_DEVICE', '2': 2},
    {'1': 'ENTRY_SOURCE_PAPER', '2': 3},
    {'1': 'ENTRY_SOURCE_PATIENT', '2': 4},
  ],
};

/// Descriptor for `EntrySource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entrySourceDescriptor = $convert.base64Decode(
    'CgtFbnRyeVNvdXJjZRIcChhFTlRSWV9TT1VSQ0VfVU5TUEVDSUZJRUQQABIXChNFTlRSWV9TT1'
    'VSQ0VfTUFOVUFMEAESFwoTRU5UUllfU09VUkNFX0RFVklDRRACEhYKEkVOVFJZX1NPVVJDRV9Q'
    'QVBFUhADEhgKFEVOVFJZX1NPVVJDRV9QQVRJRU5UEAQ=');

@$core.Deprecated('Use fluidDirectionDescriptor instead')
const FluidDirection$json = {
  '1': 'FluidDirection',
  '2': [
    {'1': 'FLUID_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'FLUID_DIRECTION_INTAKE', '2': 1},
    {'1': 'FLUID_DIRECTION_OUTPUT', '2': 2},
  ],
};

/// Descriptor for `FluidDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List fluidDirectionDescriptor = $convert.base64Decode(
    'Cg5GbHVpZERpcmVjdGlvbhIfChtGTFVJRF9ESVJFQ1RJT05fVU5TUEVDSUZJRUQQABIaChZGTF'
    'VJRF9ESVJFQ1RJT05fSU5UQUtFEAESGgoWRkxVSURfRElSRUNUSU9OX09VVFBVVBAC');

@$core.Deprecated('Use assessmentKindDescriptor instead')
const AssessmentKind$json = {
  '1': 'AssessmentKind',
  '2': [
    {'1': 'ASSESSMENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ASSESSMENT_KIND_ADMISSION', '2': 1},
    {'1': 'ASSESSMENT_KIND_SHIFT', '2': 2},
    {'1': 'ASSESSMENT_KIND_FOCUSED', '2': 3},
    {'1': 'ASSESSMENT_KIND_DISCHARGE', '2': 4},
  ],
};

/// Descriptor for `AssessmentKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assessmentKindDescriptor = $convert.base64Decode(
    'Cg5Bc3Nlc3NtZW50S2luZBIfChtBU1NFU1NNRU5UX0tJTkRfVU5TUEVDSUZJRUQQABIdChlBU1'
    'NFU1NNRU5UX0tJTkRfQURNSVNTSU9OEAESGQoVQVNTRVNTTUVOVF9LSU5EX1NISUZUEAISGwoX'
    'QVNTRVNTTUVOVF9LSU5EX0ZPQ1VTRUQQAxIdChlBU1NFU1NNRU5UX0tJTkRfRElTQ0hBUkdFEA'
    'Q=');

@$core.Deprecated('Use riskDomainDescriptor instead')
const RiskDomain$json = {
  '1': 'RiskDomain',
  '2': [
    {'1': 'RISK_DOMAIN_UNSPECIFIED', '2': 0},
    {'1': 'RISK_DOMAIN_FALLS', '2': 1},
    {'1': 'RISK_DOMAIN_PRESSURE_INJURY', '2': 2},
    {'1': 'RISK_DOMAIN_PAIN', '2': 3},
    {'1': 'RISK_DOMAIN_NUTRITION', '2': 4},
    {'1': 'RISK_DOMAIN_DETERIORATION', '2': 5},
  ],
};

/// Descriptor for `RiskDomain`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List riskDomainDescriptor = $convert.base64Decode(
    'CgpSaXNrRG9tYWluEhsKF1JJU0tfRE9NQUlOX1VOU1BFQ0lGSUVEEAASFQoRUklTS19ET01BSU'
    '5fRkFMTFMQARIfChtSSVNLX0RPTUFJTl9QUkVTU1VSRV9JTkpVUlkQAhIUChBSSVNLX0RPTUFJ'
    'Tl9QQUlOEAMSGQoVUklTS19ET01BSU5fTlVUUklUSU9OEAQSHQoZUklTS19ET01BSU5fREVURV'
    'JJT1JBVElPThAF');

@$core.Deprecated('Use deviceKindDescriptor instead')
const DeviceKind$json = {
  '1': 'DeviceKind',
  '2': [
    {'1': 'DEVICE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'DEVICE_KIND_CENTRAL_LINE', '2': 1},
    {'1': 'DEVICE_KIND_PERIPHERAL_LINE', '2': 2},
    {'1': 'DEVICE_KIND_URINARY_CATHETER', '2': 3},
    {'1': 'DEVICE_KIND_DRAIN', '2': 4},
    {'1': 'DEVICE_KIND_FEEDING_TUBE', '2': 5},
    {'1': 'DEVICE_KIND_ENDOTRACHEAL_TUBE', '2': 6},
    {'1': 'DEVICE_KIND_CHEST_TUBE', '2': 7},
  ],
};

/// Descriptor for `DeviceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deviceKindDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VLaW5kEhsKF0RFVklDRV9LSU5EX1VOU1BFQ0lGSUVEEAASHAoYREVWSUNFX0tJTk'
    'RfQ0VOVFJBTF9MSU5FEAESHwobREVWSUNFX0tJTkRfUEVSSVBIRVJBTF9MSU5FEAISIAocREVW'
    'SUNFX0tJTkRfVVJJTkFSWV9DQVRIRVRFUhADEhUKEURFVklDRV9LSU5EX0RSQUlOEAQSHAoYRE'
    'VWSUNFX0tJTkRfRkVFRElOR19UVUJFEAUSIQodREVWSUNFX0tJTkRfRU5ET1RSQUNIRUFMX1RV'
    'QkUQBhIaChZERVZJQ0VfS0lORF9DSEVTVF9UVUJFEAc=');

@$core.Deprecated('Use lateralityDescriptor instead')
const Laterality$json = {
  '1': 'Laterality',
  '2': [
    {'1': 'LATERALITY_UNSPECIFIED', '2': 0},
    {'1': 'LATERALITY_LEFT', '2': 1},
    {'1': 'LATERALITY_RIGHT', '2': 2},
    {'1': 'LATERALITY_BILATERAL', '2': 3},
    {'1': 'LATERALITY_NOT_APPLICABLE', '2': 4},
  ],
};

/// Descriptor for `Laterality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List lateralityDescriptor = $convert.base64Decode(
    'CgpMYXRlcmFsaXR5EhoKFkxBVEVSQUxJVFlfVU5TUEVDSUZJRUQQABITCg9MQVRFUkFMSVRZX0'
    'xFRlQQARIUChBMQVRFUkFMSVRZX1JJR0hUEAISGAoUTEFURVJBTElUWV9CSUxBVEVSQUwQAxId'
    'ChlMQVRFUkFMSVRZX05PVF9BUFBMSUNBQkxFEAQ=');

@$core.Deprecated('Use orderStatusDescriptor instead')
const OrderStatus$json = {
  '1': 'OrderStatus',
  '2': [
    {'1': 'ORDER_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_STATUS_DRAFT', '2': 1},
    {'1': 'ORDER_STATUS_ACTIVE', '2': 2},
    {'1': 'ORDER_STATUS_HELD', '2': 3},
    {'1': 'ORDER_STATUS_COMPLETED', '2': 4},
    {'1': 'ORDER_STATUS_CANCELLED', '2': 5},
  ],
};

/// Descriptor for `OrderStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStatusDescriptor = $convert.base64Decode(
    'CgtPcmRlclN0YXR1cxIcChhPUkRFUl9TVEFUVVNfVU5TUEVDSUZJRUQQABIWChJPUkRFUl9TVE'
    'FUVVNfRFJBRlQQARIXChNPUkRFUl9TVEFUVVNfQUNUSVZFEAISFQoRT1JERVJfU1RBVFVTX0hF'
    'TEQQAxIaChZPUkRFUl9TVEFUVVNfQ09NUExFVEVEEAQSGgoWT1JERVJfU1RBVFVTX0NBTkNFTE'
    'xFRBAF');

@$core.Deprecated('Use administrationOutcomeDescriptor instead')
const AdministrationOutcome$json = {
  '1': 'AdministrationOutcome',
  '2': [
    {'1': 'ADMINISTRATION_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'ADMINISTRATION_OUTCOME_ADMINISTERED', '2': 1},
    {'1': 'ADMINISTRATION_OUTCOME_NOT_ADMINISTERED', '2': 2},
    {'1': 'ADMINISTRATION_OUTCOME_HELD', '2': 3},
    {'1': 'ADMINISTRATION_OUTCOME_REFUSED', '2': 4},
    {'1': 'ADMINISTRATION_OUTCOME_DELAYED', '2': 5},
  ],
};

/// Descriptor for `AdministrationOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List administrationOutcomeDescriptor = $convert.base64Decode(
    'ChVBZG1pbmlzdHJhdGlvbk91dGNvbWUSJgoiQURNSU5JU1RSQVRJT05fT1VUQ09NRV9VTlNQRU'
    'NJRklFRBAAEicKI0FETUlOSVNUUkFUSU9OX09VVENPTUVfQURNSU5JU1RFUkVEEAESKwonQURN'
    'SU5JU1RSQVRJT05fT1VUQ09NRV9OT1RfQURNSU5JU1RFUkVEEAISHwobQURNSU5JU1RSQVRJT0'
    '5fT1VUQ09NRV9IRUxEEAMSIgoeQURNSU5JU1RSQVRJT05fT1VUQ09NRV9SRUZVU0VEEAQSIgoe'
    'QURNSU5JU1RSQVRJT05fT1VUQ09NRV9ERUxBWUVEEAU=');

@$core.Deprecated('Use taskPriorityDescriptor instead')
const TaskPriority$json = {
  '1': 'TaskPriority',
  '2': [
    {'1': 'TASK_PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'TASK_PRIORITY_ROUTINE', '2': 1},
    {'1': 'TASK_PRIORITY_URGENT', '2': 2},
    {'1': 'TASK_PRIORITY_CRITICAL', '2': 3},
  ],
};

/// Descriptor for `TaskPriority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskPriorityDescriptor = $convert.base64Decode(
    'CgxUYXNrUHJpb3JpdHkSHQoZVEFTS19QUklPUklUWV9VTlNQRUNJRklFRBAAEhkKFVRBU0tfUF'
    'JJT1JJVFlfUk9VVElORRABEhgKFFRBU0tfUFJJT1JJVFlfVVJHRU5UEAISGgoWVEFTS19QUklP'
    'UklUWV9DUklUSUNBTBAD');

@$core.Deprecated('Use taskStatusDescriptor instead')
const TaskStatus$json = {
  '1': 'TaskStatus',
  '2': [
    {'1': 'TASK_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TASK_STATUS_PENDING', '2': 1},
    {'1': 'TASK_STATUS_DONE', '2': 2},
    {'1': 'TASK_STATUS_NOT_DONE', '2': 3},
    {'1': 'TASK_STATUS_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `TaskStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List taskStatusDescriptor = $convert.base64Decode(
    'CgpUYXNrU3RhdHVzEhsKF1RBU0tfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFwoTVEFTS19TVEFUVV'
    'NfUEVORElORxABEhQKEFRBU0tfU1RBVFVTX0RPTkUQAhIYChRUQVNLX1NUQVRVU19OT1RfRE9O'
    'RRADEhkKFVRBU0tfU1RBVFVTX0NBTkNFTExFRBAE');

@$core.Deprecated('Use planStatusDescriptor instead')
const PlanStatus$json = {
  '1': 'PlanStatus',
  '2': [
    {'1': 'PLAN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PLAN_STATUS_ACTIVE', '2': 1},
    {'1': 'PLAN_STATUS_COMPLETED', '2': 2},
    {'1': 'PLAN_STATUS_CANCELLED', '2': 3},
  ],
};

/// Descriptor for `PlanStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List planStatusDescriptor = $convert.base64Decode(
    'CgpQbGFuU3RhdHVzEhsKF1BMQU5fU1RBVFVTX1VOU1BFQ0lGSUVEEAASFgoSUExBTl9TVEFUVV'
    'NfQUNUSVZFEAESGQoVUExBTl9TVEFUVVNfQ09NUExFVEVEEAISGQoVUExBTl9TVEFUVVNfQ0FO'
    'Q0VMTEVEEAM=');

@$core.Deprecated('Use restraintKindDescriptor instead')
const RestraintKind$json = {
  '1': 'RestraintKind',
  '2': [
    {'1': 'RESTRAINT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'RESTRAINT_KIND_PHYSICAL', '2': 1},
    {'1': 'RESTRAINT_KIND_CHEMICAL', '2': 2},
    {'1': 'RESTRAINT_KIND_SECLUSION', '2': 3},
  ],
};

/// Descriptor for `RestraintKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List restraintKindDescriptor = $convert.base64Decode(
    'Cg1SZXN0cmFpbnRLaW5kEh4KGlJFU1RSQUlOVF9LSU5EX1VOU1BFQ0lGSUVEEAASGwoXUkVTVF'
    'JBSU5UX0tJTkRfUEhZU0lDQUwQARIbChdSRVNUUkFJTlRfS0lORF9DSEVNSUNBTBACEhwKGFJF'
    'U1RSQUlOVF9LSU5EX1NFQ0xVU0lPThAD');

@$core.Deprecated('Use transfusionStatusDescriptor instead')
const TransfusionStatus$json = {
  '1': 'TransfusionStatus',
  '2': [
    {'1': 'TRANSFUSION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TRANSFUSION_STATUS_IN_PROGRESS', '2': 1},
    {'1': 'TRANSFUSION_STATUS_COMPLETED', '2': 2},
    {'1': 'TRANSFUSION_STATUS_STOPPED', '2': 3},
  ],
  '3': {'3': true},
};

/// Descriptor for `TransfusionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transfusionStatusDescriptor = $convert.base64Decode(
    'ChFUcmFuc2Z1c2lvblN0YXR1cxIiCh5UUkFOU0ZVU0lPTl9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IiCh5UUkFOU0ZVU0lPTl9TVEFUVVNfSU5fUFJPR1JFU1MQARIgChxUUkFOU0ZVU0lPTl9TVEFU'
    'VVNfQ09NUExFVEVEEAISHgoaVFJBTlNGVVNJT05fU1RBVFVTX1NUT1BQRUQQAxoCGAE=');

@$core.Deprecated('Use woundKindDescriptor instead')
const WoundKind$json = {
  '1': 'WoundKind',
  '2': [
    {'1': 'WOUND_KIND_UNSPECIFIED', '2': 0},
    {'1': 'WOUND_KIND_PRESSURE_INJURY', '2': 1},
    {'1': 'WOUND_KIND_SURGICAL', '2': 2},
    {'1': 'WOUND_KIND_TRAUMA', '2': 3},
    {'1': 'WOUND_KIND_BURN', '2': 4},
    {'1': 'WOUND_KIND_ULCER', '2': 5},
    {'1': 'WOUND_KIND_OTHER', '2': 6},
  ],
};

/// Descriptor for `WoundKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List woundKindDescriptor = $convert.base64Decode(
    'CglXb3VuZEtpbmQSGgoWV09VTkRfS0lORF9VTlNQRUNJRklFRBAAEh4KGldPVU5EX0tJTkRfUF'
    'JFU1NVUkVfSU5KVVJZEAESFwoTV09VTkRfS0lORF9TVVJHSUNBTBACEhUKEVdPVU5EX0tJTkRf'
    'VFJBVU1BEAMSEwoPV09VTkRfS0lORF9CVVJOEAQSFAoQV09VTkRfS0lORF9VTENFUhAFEhQKEF'
    'dPVU5EX0tJTkRfT1RIRVIQBg==');

@$core.Deprecated('Use learnerDescriptor instead')
const Learner$json = {
  '1': 'Learner',
  '2': [
    {'1': 'LEARNER_UNSPECIFIED', '2': 0},
    {'1': 'LEARNER_PATIENT', '2': 1},
    {'1': 'LEARNER_FAMILY', '2': 2},
    {'1': 'LEARNER_CARER', '2': 3},
  ],
};

/// Descriptor for `Learner`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List learnerDescriptor = $convert.base64Decode(
    'CgdMZWFybmVyEhcKE0xFQVJORVJfVU5TUEVDSUZJRUQQABITCg9MRUFSTkVSX1BBVElFTlQQAR'
    'ISCg5MRUFSTkVSX0ZBTUlMWRACEhEKDUxFQVJORVJfQ0FSRVIQAw==');

@$core.Deprecated('Use understandingDescriptor instead')
const Understanding$json = {
  '1': 'Understanding',
  '2': [
    {'1': 'UNDERSTANDING_UNSPECIFIED', '2': 0},
    {'1': 'UNDERSTANDING_DEMONSTRATED', '2': 1},
    {'1': 'UNDERSTANDING_VERBALISED', '2': 2},
    {'1': 'UNDERSTANDING_NEEDS_REINFORCEMENT', '2': 3},
    {'1': 'UNDERSTANDING_UNABLE_TO_ASSESS', '2': 4},
  ],
};

/// Descriptor for `Understanding`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List understandingDescriptor = $convert.base64Decode(
    'Cg1VbmRlcnN0YW5kaW5nEh0KGVVOREVSU1RBTkRJTkdfVU5TUEVDSUZJRUQQABIeChpVTkRFUl'
    'NUQU5ESU5HX0RFTU9OU1RSQVRFRBABEhwKGFVOREVSU1RBTkRJTkdfVkVSQkFMSVNFRBACEiUK'
    'IVVOREVSU1RBTkRJTkdfTkVFRFNfUkVJTkZPUkNFTUVOVBADEiIKHlVOREVSU1RBTkRJTkdfVU'
    '5BQkxFX1RPX0FTU0VTUxAE');

@$core.Deprecated('Use careRelationshipDescriptor instead')
const CareRelationship$json = {
  '1': 'CareRelationship',
  '2': [
    {'1': 'CARE_RELATIONSHIP_UNSPECIFIED', '2': 0},
    {'1': 'CARE_RELATIONSHIP_PRIMARY', '2': 1},
    {'1': 'CARE_RELATIONSHIP_ASSOCIATE', '2': 2},
    {'1': 'CARE_RELATIONSHIP_COVERING', '2': 3},
    {'1': 'CARE_RELATIONSHIP_IN_CHARGE', '2': 4},
  ],
};

/// Descriptor for `CareRelationship`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List careRelationshipDescriptor = $convert.base64Decode(
    'ChBDYXJlUmVsYXRpb25zaGlwEiEKHUNBUkVfUkVMQVRJT05TSElQX1VOU1BFQ0lGSUVEEAASHQ'
    'oZQ0FSRV9SRUxBVElPTlNISVBfUFJJTUFSWRABEh8KG0NBUkVfUkVMQVRJT05TSElQX0FTU09D'
    'SUFURRACEh4KGkNBUkVfUkVMQVRJT05TSElQX0NPVkVSSU5HEAMSHwobQ0FSRV9SRUxBVElPTl'
    'NISVBfSU5fQ0hBUkdFEAQ=');

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

@$core.Deprecated('Use flowsheetEntryDescriptor instead')
const FlowsheetEntry$json = {
  '1': 'FlowsheetEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'value',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'value'
    },
    {'1': 'text_value', '3': 6, '4': 1, '5': 9, '10': 'textValue'},
    {
      '1': 'coded_value',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'codedValue'
    },
    {
      '1': 'observed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {
      '1': 'recorded_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {
      '1': 'source',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.EntrySource',
      '10': 'source'
    },
    {'1': 'device_id', '3': 11, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'recorded_by', '3': 12, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'late_entry_reason',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'lateEntryReason'
    },
    {'1': 'late', '3': 14, '4': 1, '5': 8, '10': 'late'},
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `FlowsheetEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List flowsheetEntryDescriptor = $convert.base64Decode(
    'Cg5GbG93c2hlZXRFbnRyeRIZCghlbnRyeV9pZBgBIAEoCVIHZW50cnlJZBIdCgpwYXRpZW50X2'
    'lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIx'
    'CgRjb2RlGAQgASgLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNvZGluZ1IEY29kZRI1CgV2YW'
    'x1ZRgFIAEoCzIfLmhlYWx0aGNhcmUubnVyc2luZy52MS5RdWFudGl0eVIFdmFsdWUSHQoKdGV4'
    'dF92YWx1ZRgGIAEoCVIJdGV4dFZhbHVlEj4KC2NvZGVkX3ZhbHVlGAcgASgLMh0uaGVhbHRoY2'
    'FyZS5udXJzaW5nLnYxLkNvZGluZ1IKY29kZWRWYWx1ZRI7CgtvYnNlcnZlZF9hdBgIIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9ic2VydmVkQXQSOwoLcmVjb3JkZWRfYXQYCS'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0EjoKBnNvdXJjZRgK'
    'IAEoDjIiLmhlYWx0aGNhcmUubnVyc2luZy52MS5FbnRyeVNvdXJjZVIGc291cmNlEhsKCWRldm'
    'ljZV9pZBgLIAEoCVIIZGV2aWNlSWQSHwoLcmVjb3JkZWRfYnkYDCABKAlSCnJlY29yZGVkQnkS'
    'KgoRbGF0ZV9lbnRyeV9yZWFzb24YDSABKAlSD2xhdGVFbnRyeVJlYXNvbhISCgRsYXRlGA4gAS'
    'gIUgRsYXRlEhgKB3ZlcnNpb24YDyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use chartObservationRequestDescriptor instead')
const ChartObservationRequest$json = {
  '1': 'ChartObservationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'code',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'code'
    },
    {
      '1': 'value',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'value'
    },
    {'1': 'text_value', '3': 5, '4': 1, '5': 9, '10': 'textValue'},
    {
      '1': 'coded_value',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'codedValue'
    },
    {
      '1': 'observed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {
      '1': 'source',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.EntrySource',
      '10': 'source'
    },
    {'1': 'device_id', '3': 9, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'late_entry_reason',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'lateEntryReason'
    },
  ],
};

/// Descriptor for `ChartObservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartObservationRequestDescriptor = $convert.base64Decode(
    'ChdDaGFydE9ic2VydmF0aW9uUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIxCgRjb2RlGAMgASgLMh0uaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLkNvZGluZ1IEY29kZRI1CgV2YWx1ZRgEIAEoCzIfLmhlYWx0aG'
    'NhcmUubnVyc2luZy52MS5RdWFudGl0eVIFdmFsdWUSHQoKdGV4dF92YWx1ZRgFIAEoCVIJdGV4'
    'dFZhbHVlEj4KC2NvZGVkX3ZhbHVlGAYgASgLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNvZG'
    'luZ1IKY29kZWRWYWx1ZRI7CgtvYnNlcnZlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCm9ic2VydmVkQXQSOgoGc291cmNlGAggASgOMiIuaGVhbHRoY2FyZS5udXJzaW'
    '5nLnYxLkVudHJ5U291cmNlUgZzb3VyY2USGwoJZGV2aWNlX2lkGAkgASgJUghkZXZpY2VJZBIq'
    'ChFsYXRlX2VudHJ5X3JlYXNvbhgKIAEoCVIPbGF0ZUVudHJ5UmVhc29u');

@$core.Deprecated('Use chartObservationResponseDescriptor instead')
const ChartObservationResponse$json = {
  '1': 'ChartObservationResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.FlowsheetEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `ChartObservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chartObservationResponseDescriptor =
    $convert.base64Decode(
        'ChhDaGFydE9ic2VydmF0aW9uUmVzcG9uc2USOwoFZW50cnkYASABKAsyJS5oZWFsdGhjYXJlLm'
        '51cnNpbmcudjEuRmxvd3NoZWV0RW50cnlSBWVudHJ5');

@$core.Deprecated('Use getFlowsheetRequestDescriptor instead')
const GetFlowsheetRequest$json = {
  '1': 'GetFlowsheetRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'observed_from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedFrom'
    },
    {
      '1': 'observed_to',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedTo'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetFlowsheetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFlowsheetRequestDescriptor = $convert.base64Decode(
    'ChNHZXRGbG93c2hlZXRSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySW'
    'QSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEhIKBGNvZGUYAyABKAlSBGNvZGUSPwoN'
    'b2JzZXJ2ZWRfZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDG9ic2Vydm'
    'VkRnJvbRI7CgtvYnNlcnZlZF90bxgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'Cm9ic2VydmVkVG8SGwoJcGFnZV9zaXplGAYgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getFlowsheetResponseDescriptor instead')
const GetFlowsheetResponse$json = {
  '1': 'GetFlowsheetResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.FlowsheetEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetFlowsheetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFlowsheetResponseDescriptor = $convert.base64Decode(
    'ChRHZXRGbG93c2hlZXRSZXNwb25zZRI/CgdlbnRyaWVzGAEgAygLMiUuaGVhbHRoY2FyZS5udX'
    'JzaW5nLnYxLkZsb3dzaGVldEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use fluidEntryDescriptor instead')
const FluidEntry$json = {
  '1': 'FluidEntry',
  '2': [
    {'1': 'fluid_id', '3': 1, '4': 1, '5': 9, '10': 'fluidId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'direction',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.FluidDirection',
      '10': 'direction'
    },
    {'1': 'category', '3': 5, '4': 1, '5': 9, '10': 'category'},
    {'1': 'volume_ml', '3': 6, '4': 1, '5': 1, '10': 'volumeMl'},
    {
      '1': 'observed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {
      '1': 'recorded_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'recorded_by', '3': 9, '4': 1, '5': 9, '10': 'recordedBy'},
    {'1': 'superseded_by_id', '3': 10, '4': 1, '5': 9, '10': 'supersededById'},
    {'1': 'supersedes_id', '3': 11, '4': 1, '5': 9, '10': 'supersedesId'},
    {'1': 'amendment_reason', '3': 12, '4': 1, '5': 9, '10': 'amendmentReason'},
    {'1': 'voided_reason', '3': 13, '4': 1, '5': 9, '10': 'voidedReason'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `FluidEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fluidEntryDescriptor = $convert.base64Decode(
    'CgpGbHVpZEVudHJ5EhkKCGZsdWlkX2lkGAEgASgJUgdmbHVpZElkEh0KCnBhdGllbnRfaWQYAi'
    'ABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYAyABKAlSC2VuY291bnRlcklkEkMKCWRp'
    'cmVjdGlvbhgEIAEoDjIlLmhlYWx0aGNhcmUubnVyc2luZy52MS5GbHVpZERpcmVjdGlvblIJZG'
    'lyZWN0aW9uEhoKCGNhdGVnb3J5GAUgASgJUghjYXRlZ29yeRIbCgl2b2x1bWVfbWwYBiABKAFS'
    'CHZvbHVtZU1sEjsKC29ic2VydmVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIKb2JzZXJ2ZWRBdBI7CgtyZWNvcmRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCnJlY29yZGVkQXQSHwoLcmVjb3JkZWRfYnkYCSABKAlSCnJlY29yZGVkQnkSKA'
    'oQc3VwZXJzZWRlZF9ieV9pZBgKIAEoCVIOc3VwZXJzZWRlZEJ5SWQSIwoNc3VwZXJzZWRlc19p'
    'ZBgLIAEoCVIMc3VwZXJzZWRlc0lkEikKEGFtZW5kbWVudF9yZWFzb24YDCABKAlSD2FtZW5kbW'
    'VudFJlYXNvbhIjCg12b2lkZWRfcmVhc29uGA0gASgJUgx2b2lkZWRSZWFzb24SGAoHdmVyc2lv'
    'bhgOIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use recordFluidRequestDescriptor instead')
const RecordFluidRequest$json = {
  '1': 'RecordFluidRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'direction',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.FluidDirection',
      '10': 'direction'
    },
    {'1': 'category', '3': 4, '4': 1, '5': 9, '10': 'category'},
    {'1': 'volume_ml', '3': 5, '4': 1, '5': 1, '10': 'volumeMl'},
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

/// Descriptor for `RecordFluidRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordFluidRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRGbHVpZFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEiEKDG'
    'VuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSQwoJZGlyZWN0aW9uGAMgASgOMiUuaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLkZsdWlkRGlyZWN0aW9uUglkaXJlY3Rpb24SGgoIY2F0ZWdvcn'
    'kYBCABKAlSCGNhdGVnb3J5EhsKCXZvbHVtZV9tbBgFIAEoAVIIdm9sdW1lTWwSOwoLb2JzZXJ2'
    'ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvYnNlcnZlZEF0');

@$core.Deprecated('Use recordFluidResponseDescriptor instead')
const RecordFluidResponse$json = {
  '1': 'RecordFluidResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.FluidEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `RecordFluidResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordFluidResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRGbHVpZFJlc3BvbnNlEjcKBWVudHJ5GAEgASgLMiEuaGVhbHRoY2FyZS5udXJzaW'
    '5nLnYxLkZsdWlkRW50cnlSBWVudHJ5');

@$core.Deprecated('Use correctFluidRequestDescriptor instead')
const CorrectFluidRequest$json = {
  '1': 'CorrectFluidRequest',
  '2': [
    {'1': 'fluid_id', '3': 1, '4': 1, '5': 9, '10': 'fluidId'},
    {'1': 'volume_ml', '3': 2, '4': 1, '5': 1, '10': 'volumeMl'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CorrectFluidRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctFluidRequestDescriptor = $convert.base64Decode(
    'ChNDb3JyZWN0Rmx1aWRSZXF1ZXN0EhkKCGZsdWlkX2lkGAEgASgJUgdmbHVpZElkEhsKCXZvbH'
    'VtZV9tbBgCIAEoAVIIdm9sdW1lTWwSFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use correctFluidResponseDescriptor instead')
const CorrectFluidResponse$json = {
  '1': 'CorrectFluidResponse',
  '2': [
    {
      '1': 'correction',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.FluidEntry',
      '10': 'correction'
    },
  ],
};

/// Descriptor for `CorrectFluidResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List correctFluidResponseDescriptor = $convert.base64Decode(
    'ChRDb3JyZWN0Rmx1aWRSZXNwb25zZRJBCgpjb3JyZWN0aW9uGAEgASgLMiEuaGVhbHRoY2FyZS'
    '5udXJzaW5nLnYxLkZsdWlkRW50cnlSCmNvcnJlY3Rpb24=');

@$core.Deprecated('Use fluidBalanceDescriptor instead')
const FluidBalance$json = {
  '1': 'FluidBalance',
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
    {
      '1': 'by_category',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.FluidBalance.ByCategoryEntry',
      '10': 'byCategory'
    },
    {'1': 'counted', '3': 7, '4': 1, '5': 5, '10': 'counted'},
  ],
  '3': [FluidBalance_ByCategoryEntry$json],
};

@$core.Deprecated('Use fluidBalanceDescriptor instead')
const FluidBalance_ByCategoryEntry$json = {
  '1': 'ByCategoryEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `FluidBalance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fluidBalanceDescriptor = $convert.base64Decode(
    'CgxGbHVpZEJhbGFuY2USLgoEZnJvbRgBIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSBGZyb20SKgoCdG8YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJ0bxIbCglp'
    'bnRha2VfbWwYAyABKAFSCGludGFrZU1sEhsKCW91dHB1dF9tbBgEIAEoAVIIb3V0cHV0TWwSFQ'
    'oGbmV0X21sGAUgASgBUgVuZXRNbBJUCgtieV9jYXRlZ29yeRgGIAMoCzIzLmhlYWx0aGNhcmUu'
    'bnVyc2luZy52MS5GbHVpZEJhbGFuY2UuQnlDYXRlZ29yeUVudHJ5UgpieUNhdGVnb3J5EhgKB2'
    'NvdW50ZWQYByABKAVSB2NvdW50ZWQaPQoPQnlDYXRlZ29yeUVudHJ5EhAKA2tleRgBIAEoCVID'
    'a2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use getFluidBalanceRequestDescriptor instead')
const GetFluidBalanceRequest$json = {
  '1': 'GetFluidBalanceRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
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
  ],
};

/// Descriptor for `GetFluidBalanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFluidBalanceRequestDescriptor = $convert.base64Decode(
    'ChZHZXRGbHVpZEJhbGFuY2VSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
    'VySWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEi4KBGZyb20YAyABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgRmcm9tEioKAnRvGAQgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getFluidBalanceResponseDescriptor instead')
const GetFluidBalanceResponse$json = {
  '1': 'GetFluidBalanceResponse',
  '2': [
    {
      '1': 'balance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.FluidBalance',
      '10': 'balance'
    },
  ],
};

/// Descriptor for `GetFluidBalanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFluidBalanceResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRGbHVpZEJhbGFuY2VSZXNwb25zZRI9CgdiYWxhbmNlGAEgASgLMiMuaGVhbHRoY2FyZS'
        '5udXJzaW5nLnYxLkZsdWlkQmFsYW5jZVIHYmFsYW5jZQ==');

@$core.Deprecated('Use getFluidTrailRequestDescriptor instead')
const GetFluidTrailRequest$json = {
  '1': 'GetFluidTrailRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
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
  ],
};

/// Descriptor for `GetFluidTrailRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFluidTrailRequestDescriptor = $convert.base64Decode(
    'ChRHZXRGbHVpZFRyYWlsUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bnRlck'
    'lkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIuCgRmcm9tGAMgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgFIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use getFluidTrailResponseDescriptor instead')
const GetFluidTrailResponse$json = {
  '1': 'GetFluidTrailResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.FluidEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetFluidTrailResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFluidTrailResponseDescriptor = $convert.base64Decode(
    'ChVHZXRGbHVpZFRyYWlsUmVzcG9uc2USOwoHZW50cmllcxgBIAMoCzIhLmhlYWx0aGNhcmUubn'
    'Vyc2luZy52MS5GbHVpZEVudHJ5UgdlbnRyaWVz');

@$core.Deprecated('Use templateSectionDescriptor instead')
const TemplateSection$json = {
  '1': 'TemplateSection',
  '2': [
    {'1': 'heading', '3': 1, '4': 1, '5': 9, '10': 'heading'},
    {'1': 'required', '3': 2, '4': 1, '5': 8, '10': 'required'},
    {'1': 'prompts', '3': 3, '4': 3, '5': 9, '10': 'prompts'},
  ],
};

/// Descriptor for `TemplateSection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List templateSectionDescriptor = $convert.base64Decode(
    'Cg9UZW1wbGF0ZVNlY3Rpb24SGAoHaGVhZGluZxgBIAEoCVIHaGVhZGluZxIaCghyZXF1aXJlZB'
    'gCIAEoCFIIcmVxdWlyZWQSGAoHcHJvbXB0cxgDIAMoCVIHcHJvbXB0cw==');

@$core.Deprecated('Use assessmentTemplateDescriptor instead')
const AssessmentTemplate$json = {
  '1': 'AssessmentTemplate',
  '2': [
    {'1': 'template_id', '3': 1, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'min_age_years', '3': 4, '4': 1, '5': 5, '10': 'minAgeYears'},
    {'1': 'max_age_years', '3': 5, '4': 1, '5': 5, '10': 'maxAgeYears'},
    {'1': 'service_code', '3': 6, '4': 1, '5': 9, '10': 'serviceCode'},
    {
      '1': 'sections',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.TemplateSection',
      '10': 'sections'
    },
    {'1': 'retired', '3': 8, '4': 1, '5': 8, '10': 'retired'},
  ],
};

/// Descriptor for `AssessmentTemplate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessmentTemplateDescriptor = $convert.base64Decode(
    'ChJBc3Nlc3NtZW50VGVtcGxhdGUSHwoLdGVtcGxhdGVfaWQYASABKAlSCnRlbXBsYXRlSWQSGA'
    'oHdmVyc2lvbhgCIAEoCVIHdmVyc2lvbhISCgRuYW1lGAMgASgJUgRuYW1lEiIKDW1pbl9hZ2Vf'
    'eWVhcnMYBCABKAVSC21pbkFnZVllYXJzEiIKDW1heF9hZ2VfeWVhcnMYBSABKAVSC21heEFnZV'
    'llYXJzEiEKDHNlcnZpY2VfY29kZRgGIAEoCVILc2VydmljZUNvZGUSQgoIc2VjdGlvbnMYByAD'
    'KAsyJi5oZWFsdGhjYXJlLm51cnNpbmcudjEuVGVtcGxhdGVTZWN0aW9uUghzZWN0aW9ucxIYCg'
    'dyZXRpcmVkGAggASgIUgdyZXRpcmVk');

@$core.Deprecated('Use defineAssessmentTemplateRequestDescriptor instead')
const DefineAssessmentTemplateRequest$json = {
  '1': 'DefineAssessmentTemplateRequest',
  '2': [
    {
      '1': 'template',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AssessmentTemplate',
      '10': 'template'
    },
  ],
};

/// Descriptor for `DefineAssessmentTemplateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineAssessmentTemplateRequestDescriptor =
    $convert.base64Decode(
        'Ch9EZWZpbmVBc3Nlc3NtZW50VGVtcGxhdGVSZXF1ZXN0EkUKCHRlbXBsYXRlGAEgASgLMikuaG'
        'VhbHRoY2FyZS5udXJzaW5nLnYxLkFzc2Vzc21lbnRUZW1wbGF0ZVIIdGVtcGxhdGU=');

@$core.Deprecated('Use defineAssessmentTemplateResponseDescriptor instead')
const DefineAssessmentTemplateResponse$json = {
  '1': 'DefineAssessmentTemplateResponse',
  '2': [
    {
      '1': 'template',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AssessmentTemplate',
      '10': 'template'
    },
  ],
};

/// Descriptor for `DefineAssessmentTemplateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineAssessmentTemplateResponseDescriptor =
    $convert.base64Decode(
        'CiBEZWZpbmVBc3Nlc3NtZW50VGVtcGxhdGVSZXNwb25zZRJFCgh0ZW1wbGF0ZRgBIAEoCzIpLm'
        'hlYWx0aGNhcmUubnVyc2luZy52MS5Bc3Nlc3NtZW50VGVtcGxhdGVSCHRlbXBsYXRl');

@$core.Deprecated('Use listAssessmentTemplatesRequestDescriptor instead')
const ListAssessmentTemplatesRequest$json = {
  '1': 'ListAssessmentTemplatesRequest',
  '2': [
    {'1': 'service_code', '3': 1, '4': 1, '5': 9, '10': 'serviceCode'},
    {'1': 'include_retired', '3': 2, '4': 1, '5': 8, '10': 'includeRetired'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAssessmentTemplatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentTemplatesRequestDescriptor =
    $convert.base64Decode(
        'Ch5MaXN0QXNzZXNzbWVudFRlbXBsYXRlc1JlcXVlc3QSIQoMc2VydmljZV9jb2RlGAEgASgJUg'
        'tzZXJ2aWNlQ29kZRInCg9pbmNsdWRlX3JldGlyZWQYAiABKAhSDmluY2x1ZGVSZXRpcmVkEhsK'
        'CXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listAssessmentTemplatesResponseDescriptor instead')
const ListAssessmentTemplatesResponse$json = {
  '1': 'ListAssessmentTemplatesResponse',
  '2': [
    {
      '1': 'templates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.AssessmentTemplate',
      '10': 'templates'
    },
  ],
};

/// Descriptor for `ListAssessmentTemplatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentTemplatesResponseDescriptor =
    $convert.base64Decode(
        'Ch9MaXN0QXNzZXNzbWVudFRlbXBsYXRlc1Jlc3BvbnNlEkcKCXRlbXBsYXRlcxgBIAMoCzIpLm'
        'hlYWx0aGNhcmUubnVyc2luZy52MS5Bc3Nlc3NtZW50VGVtcGxhdGVSCXRlbXBsYXRlcw==');

@$core.Deprecated('Use retireAssessmentTemplateRequestDescriptor instead')
const RetireAssessmentTemplateRequest$json = {
  '1': 'RetireAssessmentTemplateRequest',
  '2': [
    {'1': 'template_id', '3': 1, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
  ],
};

/// Descriptor for `RetireAssessmentTemplateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireAssessmentTemplateRequestDescriptor =
    $convert.base64Decode(
        'Ch9SZXRpcmVBc3Nlc3NtZW50VGVtcGxhdGVSZXF1ZXN0Eh8KC3RlbXBsYXRlX2lkGAEgASgJUg'
        'p0ZW1wbGF0ZUlkEhgKB3ZlcnNpb24YAiABKAlSB3ZlcnNpb24=');

@$core.Deprecated('Use retireAssessmentTemplateResponseDescriptor instead')
const RetireAssessmentTemplateResponse$json = {
  '1': 'RetireAssessmentTemplateResponse',
};

/// Descriptor for `RetireAssessmentTemplateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireAssessmentTemplateResponseDescriptor =
    $convert.base64Decode('CiBSZXRpcmVBc3Nlc3NtZW50VGVtcGxhdGVSZXNwb25zZQ==');

@$core.Deprecated('Use answerDescriptor instead')
const Answer$json = {
  '1': 'Answer',
  '2': [
    {'1': 'heading', '3': 1, '4': 1, '5': 9, '10': 'heading'},
    {'1': 'prompt', '3': 2, '4': 1, '5': 9, '10': 'prompt'},
    {'1': 'value', '3': 3, '4': 1, '5': 9, '10': 'value'},
    {
      '1': 'coded',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'coded'
    },
  ],
};

/// Descriptor for `Answer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List answerDescriptor = $convert.base64Decode(
    'CgZBbnN3ZXISGAoHaGVhZGluZxgBIAEoCVIHaGVhZGluZxIWCgZwcm9tcHQYAiABKAlSBnByb2'
    '1wdBIUCgV2YWx1ZRgDIAEoCVIFdmFsdWUSMwoFY29kZWQYBCABKAsyHS5oZWFsdGhjYXJlLm51'
    'cnNpbmcudjEuQ29kaW5nUgVjb2RlZA==');

@$core.Deprecated('Use assessmentDescriptor instead')
const Assessment$json = {
  '1': 'Assessment',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.AssessmentKind',
      '10': 'kind'
    },
    {'1': 'template_id', '3': 5, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'template_version', '3': 6, '4': 1, '5': 9, '10': 'templateVersion'},
    {
      '1': 'answers',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Answer',
      '10': 'answers'
    },
    {
      '1': 'assessed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {
      '1': 'recorded_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'assessed_by', '3': 10, '4': 1, '5': 9, '10': 'assessedBy'},
    {'1': 'version', '3': 11, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Assessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessmentDescriptor = $convert.base64Decode(
    'CgpBc3Nlc3NtZW50EiMKDWFzc2Vzc21lbnRfaWQYASABKAlSDGFzc2Vzc21lbnRJZBIdCgpwYX'
    'RpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50'
    'ZXJJZBI5CgRraW5kGAQgASgOMiUuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFzc2Vzc21lbnRLaW'
    '5kUgRraW5kEh8KC3RlbXBsYXRlX2lkGAUgASgJUgp0ZW1wbGF0ZUlkEikKEHRlbXBsYXRlX3Zl'
    'cnNpb24YBiABKAlSD3RlbXBsYXRlVmVyc2lvbhI3CgdhbnN3ZXJzGAcgAygLMh0uaGVhbHRoY2'
    'FyZS5udXJzaW5nLnYxLkFuc3dlclIHYW5zd2VycxI7Cgthc3Nlc3NlZF9hdBgIIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFzc2Vzc2VkQXQSOwoLcmVjb3JkZWRfYXQYCSABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh8KC2Fzc2Vzc2VkX2J5'
    'GAogASgJUgphc3Nlc3NlZEJ5EhgKB3ZlcnNpb24YCyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use recordAssessmentRequestDescriptor instead')
const RecordAssessmentRequest$json = {
  '1': 'RecordAssessmentRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.AssessmentKind',
      '10': 'kind'
    },
    {'1': 'template_id', '3': 4, '4': 1, '5': 9, '10': 'templateId'},
    {'1': 'template_version', '3': 5, '4': 1, '5': 9, '10': 'templateVersion'},
    {
      '1': 'answers',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Answer',
      '10': 'answers'
    },
    {
      '1': 'assessed_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
  ],
};

/// Descriptor for `RecordAssessmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmRBc3Nlc3NtZW50UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBI5CgRraW5kGAMgASgOMiUuaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLkFzc2Vzc21lbnRLaW5kUgRraW5kEh8KC3RlbXBsYXRlX2lkGA'
    'QgASgJUgp0ZW1wbGF0ZUlkEikKEHRlbXBsYXRlX3ZlcnNpb24YBSABKAlSD3RlbXBsYXRlVmVy'
    'c2lvbhI3CgdhbnN3ZXJzGAYgAygLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFuc3dlclIHYW'
    '5zd2VycxI7Cgthc3Nlc3NlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CmFzc2Vzc2VkQXQ=');

@$core.Deprecated('Use recordAssessmentResponseDescriptor instead')
const RecordAssessmentResponse$json = {
  '1': 'RecordAssessmentResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Assessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `RecordAssessmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentResponseDescriptor =
    $convert.base64Decode(
        'ChhSZWNvcmRBc3Nlc3NtZW50UmVzcG9uc2USQQoKYXNzZXNzbWVudBgBIAEoCzIhLmhlYWx0aG'
        'NhcmUubnVyc2luZy52MS5Bc3Nlc3NtZW50Ugphc3Nlc3NtZW50');

@$core.Deprecated('Use listAssessmentsRequestDescriptor instead')
const ListAssessmentsRequest$json = {
  '1': 'ListAssessmentsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.AssessmentKind',
      '10': 'kind'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QXNzZXNzbWVudHNSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudG'
    'VySWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEjkKBGtpbmQYAyABKA4yJS5oZWFs'
    'dGhjYXJlLm51cnNpbmcudjEuQXNzZXNzbWVudEtpbmRSBGtpbmQSGwoJcGFnZV9zaXplGAQgAS'
    'gFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listAssessmentsResponseDescriptor instead')
const ListAssessmentsResponse$json = {
  '1': 'ListAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Assessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QXNzZXNzbWVudHNSZXNwb25zZRJDCgthc3Nlc3NtZW50cxgBIAMoCzIhLmhlYWx0aG'
        'NhcmUubnVyc2luZy52MS5Bc3Nlc3NtZW50Ugthc3Nlc3NtZW50cw==');

@$core.Deprecated('Use riskInputDescriptor instead')
const RiskInput$json = {
  '1': 'RiskInput',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'min', '3': 3, '4': 1, '5': 5, '10': 'min'},
    {'1': 'max', '3': 4, '4': 1, '5': 5, '10': 'max'},
  ],
};

/// Descriptor for `RiskInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskInputDescriptor = $convert.base64Decode(
    'CglSaXNrSW5wdXQSEAoDa2V5GAEgASgJUgNrZXkSFAoFbGFiZWwYAiABKAlSBWxhYmVsEhAKA2'
    '1pbhgDIAEoBVIDbWluEhAKA21heBgEIAEoBVIDbWF4');

@$core.Deprecated('Use riskBandDescriptor instead')
const RiskBand$json = {
  '1': 'RiskBand',
  '2': [
    {'1': 'from', '3': 1, '4': 1, '5': 5, '10': 'from'},
    {'1': 'to', '3': 2, '4': 1, '5': 5, '10': 'to'},
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'escalate', '3': 4, '4': 1, '5': 8, '10': 'escalate'},
  ],
};

/// Descriptor for `RiskBand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskBandDescriptor = $convert.base64Decode(
    'CghSaXNrQmFuZBISCgRmcm9tGAEgASgFUgRmcm9tEg4KAnRvGAIgASgFUgJ0bxIUCgVsYWJlbB'
    'gDIAEoCVIFbGFiZWwSGgoIZXNjYWxhdGUYBCABKAhSCGVzY2FsYXRl');

@$core.Deprecated('Use riskScaleDescriptor instead')
const RiskScale$json = {
  '1': 'RiskScale',
  '2': [
    {'1': 'scale_id', '3': 1, '4': 1, '5': 9, '10': 'scaleId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'domain',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.RiskDomain',
      '10': 'domain'
    },
    {
      '1': 'inputs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskInput',
      '10': 'inputs'
    },
    {
      '1': 'bands',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskBand',
      '10': 'bands'
    },
    {
      '1': 'reassess_after_seconds',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'reassessAfterSeconds'
    },
    {'1': 'retired', '3': 8, '4': 1, '5': 8, '10': 'retired'},
  ],
};

/// Descriptor for `RiskScale`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskScaleDescriptor = $convert.base64Decode(
    'CglSaXNrU2NhbGUSGQoIc2NhbGVfaWQYASABKAlSB3NjYWxlSWQSGAoHdmVyc2lvbhgCIAEoCV'
    'IHdmVyc2lvbhISCgRuYW1lGAMgASgJUgRuYW1lEjkKBmRvbWFpbhgEIAEoDjIhLmhlYWx0aGNh'
    'cmUubnVyc2luZy52MS5SaXNrRG9tYWluUgZkb21haW4SOAoGaW5wdXRzGAUgAygLMiAuaGVhbH'
    'RoY2FyZS5udXJzaW5nLnYxLlJpc2tJbnB1dFIGaW5wdXRzEjUKBWJhbmRzGAYgAygLMh8uaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLlJpc2tCYW5kUgViYW5kcxI0ChZyZWFzc2Vzc19hZnRlcl9zZW'
    'NvbmRzGAcgASgDUhRyZWFzc2Vzc0FmdGVyU2Vjb25kcxIYCgdyZXRpcmVkGAggASgIUgdyZXRp'
    'cmVk');

@$core.Deprecated('Use defineRiskScaleRequestDescriptor instead')
const DefineRiskScaleRequest$json = {
  '1': 'DefineRiskScaleRequest',
  '2': [
    {
      '1': 'scale',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskScale',
      '10': 'scale'
    },
  ],
};

/// Descriptor for `DefineRiskScaleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineRiskScaleRequestDescriptor =
    $convert.base64Decode(
        'ChZEZWZpbmVSaXNrU2NhbGVSZXF1ZXN0EjYKBXNjYWxlGAEgASgLMiAuaGVhbHRoY2FyZS5udX'
        'JzaW5nLnYxLlJpc2tTY2FsZVIFc2NhbGU=');

@$core.Deprecated('Use defineRiskScaleResponseDescriptor instead')
const DefineRiskScaleResponse$json = {
  '1': 'DefineRiskScaleResponse',
  '2': [
    {
      '1': 'scale',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskScale',
      '10': 'scale'
    },
  ],
};

/// Descriptor for `DefineRiskScaleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineRiskScaleResponseDescriptor =
    $convert.base64Decode(
        'ChdEZWZpbmVSaXNrU2NhbGVSZXNwb25zZRI2CgVzY2FsZRgBIAEoCzIgLmhlYWx0aGNhcmUubn'
        'Vyc2luZy52MS5SaXNrU2NhbGVSBXNjYWxl');

@$core.Deprecated('Use riskAssessmentDescriptor instead')
const RiskAssessment$json = {
  '1': 'RiskAssessment',
  '2': [
    {'1': 'risk_id', '3': 1, '4': 1, '5': 9, '10': 'riskId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'scale_id', '3': 4, '4': 1, '5': 9, '10': 'scaleId'},
    {'1': 'scale_version', '3': 5, '4': 1, '5': 9, '10': 'scaleVersion'},
    {
      '1': 'domain',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.RiskDomain',
      '10': 'domain'
    },
    {
      '1': 'inputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskAssessment.InputsEntry',
      '10': 'inputs'
    },
    {'1': 'total', '3': 8, '4': 1, '5': 5, '10': 'total'},
    {'1': 'band', '3': 9, '4': 1, '5': 9, '10': 'band'},
    {'1': 'escalate', '3': 10, '4': 1, '5': 8, '10': 'escalate'},
    {
      '1': 'assessed_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {
      '1': 'recorded_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'assessed_by', '3': 13, '4': 1, '5': 9, '10': 'assessedBy'},
    {
      '1': 'due_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'superseded_by_id', '3': 15, '4': 1, '5': 9, '10': 'supersededById'},
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
  '3': [RiskAssessment_InputsEntry$json],
};

@$core.Deprecated('Use riskAssessmentDescriptor instead')
const RiskAssessment_InputsEntry$json = {
  '1': 'InputsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RiskAssessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskAssessmentDescriptor = $convert.base64Decode(
    'Cg5SaXNrQXNzZXNzbWVudBIXCgdyaXNrX2lkGAEgASgJUgZyaXNrSWQSHQoKcGF0aWVudF9pZB'
    'gCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQSGQoI'
    'c2NhbGVfaWQYBCABKAlSB3NjYWxlSWQSIwoNc2NhbGVfdmVyc2lvbhgFIAEoCVIMc2NhbGVWZX'
    'JzaW9uEjkKBmRvbWFpbhgGIAEoDjIhLmhlYWx0aGNhcmUubnVyc2luZy52MS5SaXNrRG9tYWlu'
    'UgZkb21haW4SSQoGaW5wdXRzGAcgAygLMjEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJpc2tBc3'
    'Nlc3NtZW50LklucHV0c0VudHJ5UgZpbnB1dHMSFAoFdG90YWwYCCABKAVSBXRvdGFsEhIKBGJh'
    'bmQYCSABKAlSBGJhbmQSGgoIZXNjYWxhdGUYCiABKAhSCGVzY2FsYXRlEjsKC2Fzc2Vzc2VkX2'
    'F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYXNzZXNzZWRBdBI7CgtyZWNv'
    'cmRlZF9hdBgMIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSHw'
    'oLYXNzZXNzZWRfYnkYDSABKAlSCmFzc2Vzc2VkQnkSMQoGZHVlX2F0GA4gASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlQXQSKAoQc3VwZXJzZWRlZF9ieV9pZBgPIAEoCVIOc3'
    'VwZXJzZWRlZEJ5SWQSGAoHdmVyc2lvbhgQIAEoA1IHdmVyc2lvbho5CgtJbnB1dHNFbnRyeRIQ'
    'CgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoBVIFdmFsdWU6AjgB');

@$core.Deprecated('Use scoreRiskRequestDescriptor instead')
const ScoreRiskRequest$json = {
  '1': 'ScoreRiskRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'scale_id', '3': 3, '4': 1, '5': 9, '10': 'scaleId'},
    {'1': 'scale_version', '3': 4, '4': 1, '5': 9, '10': 'scaleVersion'},
    {
      '1': 'inputs',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.ScoreRiskRequest.InputsEntry',
      '10': 'inputs'
    },
    {
      '1': 'assessed_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
  ],
  '3': [ScoreRiskRequest_InputsEntry$json],
};

@$core.Deprecated('Use scoreRiskRequestDescriptor instead')
const ScoreRiskRequest_InputsEntry$json = {
  '1': 'InputsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ScoreRiskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreRiskRequestDescriptor = $convert.base64Decode(
    'ChBTY29yZVJpc2tSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCgxlbm'
    'NvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEhkKCHNjYWxlX2lkGAMgASgJUgdzY2FsZUlk'
    'EiMKDXNjYWxlX3ZlcnNpb24YBCABKAlSDHNjYWxlVmVyc2lvbhJLCgZpbnB1dHMYBSADKAsyMy'
    '5oZWFsdGhjYXJlLm51cnNpbmcudjEuU2NvcmVSaXNrUmVxdWVzdC5JbnB1dHNFbnRyeVIGaW5w'
    'dXRzEjsKC2Fzc2Vzc2VkX2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYX'
    'NzZXNzZWRBdBo5CgtJbnB1dHNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEo'
    'BVIFdmFsdWU6AjgB');

@$core.Deprecated('Use scoreRiskResponseDescriptor instead')
const ScoreRiskResponse$json = {
  '1': 'ScoreRiskResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `ScoreRiskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scoreRiskResponseDescriptor = $convert.base64Decode(
    'ChFTY29yZVJpc2tSZXNwb25zZRJFCgphc3Nlc3NtZW50GAEgASgLMiUuaGVhbHRoY2FyZS5udX'
    'JzaW5nLnYxLlJpc2tBc3Nlc3NtZW50Ugphc3Nlc3NtZW50');

@$core.Deprecated('Use listRiskAssessmentsRequestDescriptor instead')
const ListRiskAssessmentsRequest$json = {
  '1': 'ListRiskAssessmentsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'domain',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.RiskDomain',
      '10': 'domain'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListRiskAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRiskAssessmentsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0Umlza0Fzc2Vzc21lbnRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW'
        '50SWQSOQoGZG9tYWluGAIgASgOMiEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJpc2tEb21haW5S'
        'BmRvbWFpbhIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listRiskAssessmentsResponseDescriptor instead')
const ListRiskAssessmentsResponse$json = {
  '1': 'ListRiskAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskAssessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListRiskAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRiskAssessmentsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0Umlza0Fzc2Vzc21lbnRzUmVzcG9uc2USRwoLYXNzZXNzbWVudHMYASADKAsyJS5oZW'
        'FsdGhjYXJlLm51cnNpbmcudjEuUmlza0Fzc2Vzc21lbnRSC2Fzc2Vzc21lbnRz');

@$core.Deprecated('Use listDueReassessmentsRequestDescriptor instead')
const ListDueReassessmentsRequest$json = {
  '1': 'ListDueReassessmentsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDueReassessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueReassessmentsRequestDescriptor =
    $convert.base64Decode(
        'ChtMaXN0RHVlUmVhc3Nlc3NtZW50c1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbm'
        'NvdW50ZXJJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listDueReassessmentsResponseDescriptor instead')
const ListDueReassessmentsResponse$json = {
  '1': 'ListDueReassessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RiskAssessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListDueReassessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDueReassessmentsResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0RHVlUmVhc3Nlc3NtZW50c1Jlc3BvbnNlEkcKC2Fzc2Vzc21lbnRzGAEgAygLMiUuaG'
        'VhbHRoY2FyZS5udXJzaW5nLnYxLlJpc2tBc3Nlc3NtZW50Ugthc3Nlc3NtZW50cw==');

@$core.Deprecated('Use deviceCareDescriptor instead')
const DeviceCare$json = {
  '1': 'DeviceCare',
  '2': [
    {'1': 'care_id', '3': 1, '4': 1, '5': 9, '10': 'careId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'finding', '3': 3, '4': 1, '5': 9, '10': 'finding'},
    {'1': 'output_ml', '3': 4, '4': 1, '5': 1, '10': 'outputMl'},
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

/// Descriptor for `DeviceCare`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceCareDescriptor = $convert.base64Decode(
    'CgpEZXZpY2VDYXJlEhcKB2NhcmVfaWQYASABKAlSBmNhcmVJZBISCgRraW5kGAIgASgJUgRraW'
    '5kEhgKB2ZpbmRpbmcYAyABKAlSB2ZpbmRpbmcSGwoJb3V0cHV0X21sGAQgASgBUghvdXRwdXRN'
    'bBI9CgxwZXJmb3JtZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtwZX'
    'Jmb3JtZWRBdBIhCgxwZXJmb3JtZWRfYnkYBiABKAlSC3BlcmZvcm1lZEJ5');

@$core.Deprecated('Use deviceDescriptor instead')
const Device$json = {
  '1': 'Device',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.DeviceKind',
      '10': 'kind'
    },
    {'1': 'site', '3': 5, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'laterality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'size', '3': 7, '4': 1, '5': 9, '10': 'size'},
    {'1': 'lot', '3': 8, '4': 1, '5': 9, '10': 'lot'},
    {
      '1': 'inserted_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'insertedAt'
    },
    {'1': 'inserted_by', '3': 10, '4': 1, '5': 9, '10': 'insertedBy'},
    {
      '1': 'removed_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'removedAt'
    },
    {'1': 'removed_by', '3': 12, '4': 1, '5': 9, '10': 'removedBy'},
    {'1': 'removal_reason', '3': 13, '4': 1, '5': 9, '10': 'removalReason'},
    {
      '1': 'care',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.DeviceCare',
      '10': 'care'
    },
    {'1': 'device_days', '3': 15, '4': 1, '5': 5, '10': 'deviceDays'},
    {'1': 'dwell_seconds', '3': 16, '4': 1, '5': 3, '10': 'dwellSeconds'},
    {
      '1': 'surveillance_device',
      '3': 17,
      '4': 1,
      '5': 8,
      '10': 'surveillanceDevice'
    },
    {'1': 'version', '3': 18, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Device`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deviceDescriptor = $convert.base64Decode(
    'CgZEZXZpY2USGwoJZGV2aWNlX2lkGAEgASgJUghkZXZpY2VJZBIdCgpwYXRpZW50X2lkGAIgAS'
    'gJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBI1CgRraW5k'
    'GAQgASgOMiEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkRldmljZUtpbmRSBGtpbmQSEgoEc2l0ZR'
    'gFIAEoCVIEc2l0ZRJBCgpsYXRlcmFsaXR5GAYgASgOMiEuaGVhbHRoY2FyZS5udXJzaW5nLnYx'
    'LkxhdGVyYWxpdHlSCmxhdGVyYWxpdHkSEgoEc2l6ZRgHIAEoCVIEc2l6ZRIQCgNsb3QYCCABKA'
    'lSA2xvdBI7CgtpbnNlcnRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'Cmluc2VydGVkQXQSHwoLaW5zZXJ0ZWRfYnkYCiABKAlSCmluc2VydGVkQnkSOQoKcmVtb3ZlZF'
    '9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXJlbW92ZWRBdBIdCgpyZW1v'
    'dmVkX2J5GAwgASgJUglyZW1vdmVkQnkSJQoOcmVtb3ZhbF9yZWFzb24YDSABKAlSDXJlbW92YW'
    'xSZWFzb24SNQoEY2FyZRgOIAMoCzIhLmhlYWx0aGNhcmUubnVyc2luZy52MS5EZXZpY2VDYXJl'
    'UgRjYXJlEh8KC2RldmljZV9kYXlzGA8gASgFUgpkZXZpY2VEYXlzEiMKDWR3ZWxsX3NlY29uZH'
    'MYECABKANSDGR3ZWxsU2Vjb25kcxIvChNzdXJ2ZWlsbGFuY2VfZGV2aWNlGBEgASgIUhJzdXJ2'
    'ZWlsbGFuY2VEZXZpY2USGAoHdmVyc2lvbhgSIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use insertDeviceRequestDescriptor instead')
const InsertDeviceRequest$json = {
  '1': 'InsertDeviceRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.DeviceKind',
      '10': 'kind'
    },
    {'1': 'site', '3': 4, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'laterality',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Laterality',
      '10': 'laterality'
    },
    {'1': 'size', '3': 6, '4': 1, '5': 9, '10': 'size'},
    {'1': 'lot', '3': 7, '4': 1, '5': 9, '10': 'lot'},
    {
      '1': 'inserted_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'insertedAt'
    },
  ],
};

/// Descriptor for `InsertDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertDeviceRequestDescriptor = $convert.base64Decode(
    'ChNJbnNlcnREZXZpY2VSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCg'
    'xlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEjUKBGtpbmQYAyABKA4yIS5oZWFsdGhj'
    'YXJlLm51cnNpbmcudjEuRGV2aWNlS2luZFIEa2luZBISCgRzaXRlGAQgASgJUgRzaXRlEkEKCm'
    'xhdGVyYWxpdHkYBSABKA4yIS5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGF0ZXJhbGl0eVIKbGF0'
    'ZXJhbGl0eRISCgRzaXplGAYgASgJUgRzaXplEhAKA2xvdBgHIAEoCVIDbG90EjsKC2luc2VydG'
    'VkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKaW5zZXJ0ZWRBdA==');

@$core.Deprecated('Use insertDeviceResponseDescriptor instead')
const InsertDeviceResponse$json = {
  '1': 'InsertDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `InsertDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List insertDeviceResponseDescriptor = $convert.base64Decode(
    'ChRJbnNlcnREZXZpY2VSZXNwb25zZRI1CgZkZXZpY2UYASABKAsyHS5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuRGV2aWNlUgZkZXZpY2U=');

@$core.Deprecated('Use removeDeviceRequestDescriptor instead')
const RemoveDeviceRequest$json = {
  '1': 'RemoveDeviceRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'removed_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'removedAt'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RemoveDeviceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceRequestDescriptor = $convert.base64Decode(
    'ChNSZW1vdmVEZXZpY2VSZXF1ZXN0EhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSOQoKcm'
    'Vtb3ZlZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXJlbW92ZWRBdBIW'
    'CgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use removeDeviceResponseDescriptor instead')
const RemoveDeviceResponse$json = {
  '1': 'RemoveDeviceResponse',
  '2': [
    {
      '1': 'device',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Device',
      '10': 'device'
    },
  ],
};

/// Descriptor for `RemoveDeviceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeDeviceResponseDescriptor = $convert.base64Decode(
    'ChRSZW1vdmVEZXZpY2VSZXNwb25zZRI1CgZkZXZpY2UYASABKAsyHS5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuRGV2aWNlUgZkZXZpY2U=');

@$core.Deprecated('Use recordDeviceCareRequestDescriptor instead')
const RecordDeviceCareRequest$json = {
  '1': 'RecordDeviceCareRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
    {'1': 'finding', '3': 3, '4': 1, '5': 9, '10': 'finding'},
    {'1': 'output_ml', '3': 4, '4': 1, '5': 1, '10': 'outputMl'},
    {
      '1': 'performed_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
  ],
};

/// Descriptor for `RecordDeviceCareRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeviceCareRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmREZXZpY2VDYXJlUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh'
    'IKBGtpbmQYAiABKAlSBGtpbmQSGAoHZmluZGluZxgDIAEoCVIHZmluZGluZxIbCglvdXRwdXRf'
    'bWwYBCABKAFSCG91dHB1dE1sEj0KDHBlcmZvcm1lZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSC3BlcmZvcm1lZEF0');

@$core.Deprecated('Use recordDeviceCareResponseDescriptor instead')
const RecordDeviceCareResponse$json = {
  '1': 'RecordDeviceCareResponse',
};

/// Descriptor for `RecordDeviceCareResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeviceCareResponseDescriptor =
    $convert.base64Decode('ChhSZWNvcmREZXZpY2VDYXJlUmVzcG9uc2U=');

@$core.Deprecated('Use listDevicesRequestDescriptor instead')
const ListDevicesRequest$json = {
  '1': 'ListDevicesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'in_place_only', '3': 3, '4': 1, '5': 8, '10': 'inPlaceOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDevicesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0RGV2aWNlc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZB'
    'IdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIgoNaW5fcGxhY2Vfb25seRgDIAEoCFIL'
    'aW5QbGFjZU9ubHkSGwoJcGFnZV9zaXplGAQgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listDevicesResponseDescriptor instead')
const ListDevicesResponse$json = {
  '1': 'ListDevicesResponse',
  '2': [
    {
      '1': 'devices',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Device',
      '10': 'devices'
    },
  ],
};

/// Descriptor for `ListDevicesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDevicesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0RGV2aWNlc1Jlc3BvbnNlEjcKB2RldmljZXMYASADKAsyHS5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuRGV2aWNlUgdkZXZpY2Vz');

@$core.Deprecated('Use medicationOrderDescriptor instead')
const MedicationOrder$json = {
  '1': 'MedicationOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'medication',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'medication'
    },
    {
      '1': 'dose',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'dose'
    },
    {'1': 'route', '3': 6, '4': 1, '5': 9, '10': 'route'},
    {'1': 'frequency', '3': 7, '4': 1, '5': 9, '10': 'frequency'},
    {
      '1': 'status',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.OrderStatus',
      '10': 'status'
    },
    {'1': 'verified', '3': 9, '4': 1, '5': 8, '10': 'verified'},
    {'1': 'verified_by', '3': 10, '4': 1, '5': 9, '10': 'verifiedBy'},
    {
      '1': 'verified_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'verifiedAt'
    },
    {'1': 'prn', '3': 12, '4': 1, '5': 8, '10': 'prn'},
    {
      '1': 'starts_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
  ],
};

/// Descriptor for `MedicationOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medicationOrderDescriptor = $convert.base64Decode(
    'Cg9NZWRpY2F0aW9uT3JkZXISGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSHQoKcGF0aWVudF'
    '9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQS'
    'PQoKbWVkaWNhdGlvbhgEIAEoCzIdLmhlYWx0aGNhcmUubnVyc2luZy52MS5Db2RpbmdSCm1lZG'
    'ljYXRpb24SMwoEZG9zZRgFIAEoCzIfLmhlYWx0aGNhcmUubnVyc2luZy52MS5RdWFudGl0eVIE'
    'ZG9zZRIUCgVyb3V0ZRgGIAEoCVIFcm91dGUSHAoJZnJlcXVlbmN5GAcgASgJUglmcmVxdWVuY3'
    'kSOgoGc3RhdHVzGAggASgOMiIuaGVhbHRoY2FyZS5udXJzaW5nLnYxLk9yZGVyU3RhdHVzUgZz'
    'dGF0dXMSGgoIdmVyaWZpZWQYCSABKAhSCHZlcmlmaWVkEh8KC3ZlcmlmaWVkX2J5GAogASgJUg'
    'p2ZXJpZmllZEJ5EjsKC3ZlcmlmaWVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIKdmVyaWZpZWRBdBIQCgNwcm4YDCABKAhSA3BybhI3CglzdGFydHNfYXQYDSABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBIzCgdlbmRzX2F0GA4gASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGZW5kc0F0');

@$core.Deprecated('Use verificationDescriptor instead')
const Verification$json = {
  '1': 'Verification',
  '2': [
    {'1': 'patient_scanned', '3': 1, '4': 1, '5': 9, '10': 'patientScanned'},
    {
      '1': 'medication_scanned',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'medicationScanned'
    },
    {'1': 'performed', '3': 3, '4': 1, '5': 8, '10': 'performed'},
    {
      '1': 'scanned_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scannedAt'
    },
  ],
};

/// Descriptor for `Verification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationDescriptor = $convert.base64Decode(
    'CgxWZXJpZmljYXRpb24SJwoPcGF0aWVudF9zY2FubmVkGAEgASgJUg5wYXRpZW50U2Nhbm5lZB'
    'ItChJtZWRpY2F0aW9uX3NjYW5uZWQYAiABKAlSEW1lZGljYXRpb25TY2FubmVkEhwKCXBlcmZv'
    'cm1lZBgDIAEoCFIJcGVyZm9ybWVkEjkKCnNjYW5uZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUglzY2FubmVkQXQ=');

@$core.Deprecated('Use overrideDescriptor instead')
const Override$json = {
  '1': 'Override',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'by', '3': 2, '4': 1, '5': 9, '10': 'by'},
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'patient_mismatch', '3': 4, '4': 1, '5': 8, '10': 'patientMismatch'},
    {
      '1': 'medication_mismatch',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'medicationMismatch'
    },
    {'1': 'not_scanned', '3': 6, '4': 1, '5': 8, '10': 'notScanned'},
  ],
};

/// Descriptor for `Override`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideDescriptor = $convert.base64Decode(
    'CghPdmVycmlkZRIWCgZyZWFzb24YASABKAlSBnJlYXNvbhIOCgJieRgCIAEoCVICYnkSKgoCYX'
    'QYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgJhdBIpChBwYXRpZW50X21pc21h'
    'dGNoGAQgASgIUg9wYXRpZW50TWlzbWF0Y2gSLwoTbWVkaWNhdGlvbl9taXNtYXRjaBgFIAEoCF'
    'ISbWVkaWNhdGlvbk1pc21hdGNoEh8KC25vdF9zY2FubmVkGAYgASgIUgpub3RTY2FubmVk');

@$core.Deprecated('Use administrationDescriptor instead')
const Administration$json = {
  '1': 'Administration',
  '2': [
    {
      '1': 'administration_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'administrationId'
    },
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'order_id', '3': 4, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'medication',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'medication'
    },
    {
      '1': 'scheduled_dose',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'scheduledDose'
    },
    {
      '1': 'scheduled_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'given_dose',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'givenDose'
    },
    {
      '1': 'given_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {'1': 'route', '3': 10, '4': 1, '5': 9, '10': 'route'},
    {'1': 'site', '3': 11, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'outcome',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.AdministrationOutcome',
      '10': 'outcome'
    },
    {'1': 'reason', '3': 13, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'verification',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Verification',
      '10': 'verification'
    },
    {
      '1': 'override',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Override',
      '10': 'override'
    },
    {'1': 'idempotency_key', '3': 16, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'recorded_offline', '3': 17, '4': 1, '5': 8, '10': 'recordedOffline'},
    {'1': 'administered_by', '3': 18, '4': 1, '5': 9, '10': 'administeredBy'},
    {'1': 'witnessed_by', '3': 19, '4': 1, '5': 9, '10': 'witnessedBy'},
    {
      '1': 'recorded_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'late', '3': 21, '4': 1, '5': 8, '10': 'late'},
    {'1': 'version', '3': 22, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Administration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List administrationDescriptor = $convert.base64Decode(
    'Cg5BZG1pbmlzdHJhdGlvbhIrChFhZG1pbmlzdHJhdGlvbl9pZBgBIAEoCVIQYWRtaW5pc3RyYX'
    'Rpb25JZBIdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMg'
    'ASgJUgtlbmNvdW50ZXJJZBIZCghvcmRlcl9pZBgEIAEoCVIHb3JkZXJJZBI9CgptZWRpY2F0aW'
    '9uGAUgASgLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNvZGluZ1IKbWVkaWNhdGlvbhJGCg5z'
    'Y2hlZHVsZWRfZG9zZRgGIAEoCzIfLmhlYWx0aGNhcmUubnVyc2luZy52MS5RdWFudGl0eVINc2'
    'NoZWR1bGVkRG9zZRI9CgxzY2hlZHVsZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgtzY2hlZHVsZWRBdBI+CgpnaXZlbl9kb3NlGAggASgLMh8uaGVhbHRoY2FyZS5udX'
    'JzaW5nLnYxLlF1YW50aXR5UglnaXZlbkRvc2USNQoIZ2l2ZW5fYXQYCSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgdnaXZlbkF0EhQKBXJvdXRlGAogASgJUgVyb3V0ZRISCgRzaX'
    'RlGAsgASgJUgRzaXRlEkYKB291dGNvbWUYDCABKA4yLC5oZWFsdGhjYXJlLm51cnNpbmcudjEu'
    'QWRtaW5pc3RyYXRpb25PdXRjb21lUgdvdXRjb21lEhYKBnJlYXNvbhgNIAEoCVIGcmVhc29uEk'
    'cKDHZlcmlmaWNhdGlvbhgOIAEoCzIjLmhlYWx0aGNhcmUubnVyc2luZy52MS5WZXJpZmljYXRp'
    'b25SDHZlcmlmaWNhdGlvbhI7CghvdmVycmlkZRgPIAEoCzIfLmhlYWx0aGNhcmUubnVyc2luZy'
    '52MS5PdmVycmlkZVIIb3ZlcnJpZGUSJwoPaWRlbXBvdGVuY3lfa2V5GBAgASgJUg5pZGVtcG90'
    'ZW5jeUtleRIpChByZWNvcmRlZF9vZmZsaW5lGBEgASgIUg9yZWNvcmRlZE9mZmxpbmUSJwoPYW'
    'RtaW5pc3RlcmVkX2J5GBIgASgJUg5hZG1pbmlzdGVyZWRCeRIhCgx3aXRuZXNzZWRfYnkYEyAB'
    'KAlSC3dpdG5lc3NlZEJ5EjsKC3JlY29yZGVkX2F0GBQgASgLMhouZ29vZ2xlLnByb3RvYnVmLl'
    'RpbWVzdGFtcFIKcmVjb3JkZWRBdBISCgRsYXRlGBUgASgIUgRsYXRlEhgKB3ZlcnNpb24YFiAB'
    'KANSB3ZlcnNpb24=');

@$core.Deprecated('Use administrationPolicyDescriptor instead')
const AdministrationPolicy$json = {
  '1': 'AdministrationPolicy',
  '2': [
    {'1': 'barcode_required', '3': 1, '4': 1, '5': 8, '10': 'barcodeRequired'},
    {'1': 'override_allowed', '3': 2, '4': 1, '5': 8, '10': 'overrideAllowed'},
    {
      '1': 'late_after_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'lateAfterSeconds'
    },
  ],
};

/// Descriptor for `AdministrationPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List administrationPolicyDescriptor = $convert.base64Decode(
    'ChRBZG1pbmlzdHJhdGlvblBvbGljeRIpChBiYXJjb2RlX3JlcXVpcmVkGAEgASgIUg9iYXJjb2'
    'RlUmVxdWlyZWQSKQoQb3ZlcnJpZGVfYWxsb3dlZBgCIAEoCFIPb3ZlcnJpZGVBbGxvd2VkEiwK'
    'EmxhdGVfYWZ0ZXJfc2Vjb25kcxgDIAEoA1IQbGF0ZUFmdGVyU2Vjb25kcw==');

@$core.Deprecated('Use dueDoseDescriptor instead')
const DueDose$json = {
  '1': 'DueDose',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.MedicationOrder',
      '10': 'order'
    },
    {
      '1': 'scheduled_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'given',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Administration',
      '10': 'given'
    },
    {'1': 'outstanding', '3': 4, '4': 1, '5': 8, '10': 'outstanding'},
    {'1': 'overdue', '3': 5, '4': 1, '5': 8, '10': 'overdue'},
  ],
};

/// Descriptor for `DueDose`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueDoseDescriptor = $convert.base64Decode(
    'CgdEdWVEb3NlEjwKBW9yZGVyGAEgASgLMiYuaGVhbHRoY2FyZS5udXJzaW5nLnYxLk1lZGljYX'
    'Rpb25PcmRlclIFb3JkZXISPQoMc2NoZWR1bGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFILc2NoZWR1bGVkQXQSOwoFZ2l2ZW4YAyABKAsyJS5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuQWRtaW5pc3RyYXRpb25SBWdpdmVuEiAKC291dHN0YW5kaW5nGAQgASgIUgtvdXRz'
    'dGFuZGluZxIYCgdvdmVyZHVlGAUgASgIUgdvdmVyZHVl');

@$core.Deprecated('Use getMedicationRoundRequestDescriptor instead')
const GetMedicationRoundRequest$json = {
  '1': 'GetMedicationRoundRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
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
  ],
};

/// Descriptor for `GetMedicationRoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMedicationRoundRequestDescriptor = $convert.base64Decode(
    'ChlHZXRNZWRpY2F0aW9uUm91bmRSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3'
    'VudGVySWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEh8KC2ZhY2lsaXR5X2lkGAMg'
    'ASgJUgpmYWNpbGl0eUlkEi4KBGZyb20YBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgRmcm9tEioKAnRvGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFICdG8=');

@$core.Deprecated('Use getMedicationRoundResponseDescriptor instead')
const GetMedicationRoundResponse$json = {
  '1': 'GetMedicationRoundResponse',
  '2': [
    {
      '1': 'doses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.DueDose',
      '10': 'doses'
    },
    {
      '1': 'policy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AdministrationPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `GetMedicationRoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMedicationRoundResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRNZWRpY2F0aW9uUm91bmRSZXNwb25zZRI0CgVkb3NlcxgBIAMoCzIeLmhlYWx0aGNhcm'
        'UubnVyc2luZy52MS5EdWVEb3NlUgVkb3NlcxJDCgZwb2xpY3kYAiABKAsyKy5oZWFsdGhjYXJl'
        'Lm51cnNpbmcudjEuQWRtaW5pc3RyYXRpb25Qb2xpY3lSBnBvbGljeQ==');

@$core.Deprecated('Use administerRequestDescriptor instead')
const AdministerRequest$json = {
  '1': 'AdministerRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'scheduled_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'given_dose',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Quantity',
      '10': 'givenDose'
    },
    {
      '1': 'given_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'givenAt'
    },
    {'1': 'route', '3': 6, '4': 1, '5': 9, '10': 'route'},
    {'1': 'site', '3': 7, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'outcome',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.AdministrationOutcome',
      '10': 'outcome'
    },
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'verification',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Verification',
      '10': 'verification'
    },
    {'1': 'override_reason', '3': 11, '4': 1, '5': 9, '10': 'overrideReason'},
    {'1': 'witnessed_by', '3': 12, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'idempotency_key', '3': 13, '4': 1, '5': 9, '10': 'idempotencyKey'},
    {'1': 'offline', '3': 14, '4': 1, '5': 8, '10': 'offline'},
  ],
};

/// Descriptor for `AdministerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List administerRequestDescriptor = $convert.base64Decode(
    'ChFBZG1pbmlzdGVyUmVxdWVzdBIZCghvcmRlcl9pZBgBIAEoCVIHb3JkZXJJZBIfCgtmYWNpbG'
    'l0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBI9CgxzY2hlZHVsZWRfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgtzY2hlZHVsZWRBdBI+CgpnaXZlbl9kb3NlGAQgASgLMh8uaG'
    'VhbHRoY2FyZS5udXJzaW5nLnYxLlF1YW50aXR5UglnaXZlbkRvc2USNQoIZ2l2ZW5fYXQYBSAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdnaXZlbkF0EhQKBXJvdXRlGAYgASgJUg'
    'Vyb3V0ZRISCgRzaXRlGAcgASgJUgRzaXRlEkYKB291dGNvbWUYCCABKA4yLC5oZWFsdGhjYXJl'
    'Lm51cnNpbmcudjEuQWRtaW5pc3RyYXRpb25PdXRjb21lUgdvdXRjb21lEhYKBnJlYXNvbhgJIA'
    'EoCVIGcmVhc29uEkcKDHZlcmlmaWNhdGlvbhgKIAEoCzIjLmhlYWx0aGNhcmUubnVyc2luZy52'
    'MS5WZXJpZmljYXRpb25SDHZlcmlmaWNhdGlvbhInCg9vdmVycmlkZV9yZWFzb24YCyABKAlSDm'
    '92ZXJyaWRlUmVhc29uEiEKDHdpdG5lc3NlZF9ieRgMIAEoCVILd2l0bmVzc2VkQnkSJwoPaWRl'
    'bXBvdGVuY3lfa2V5GA0gASgJUg5pZGVtcG90ZW5jeUtleRIYCgdvZmZsaW5lGA4gASgIUgdvZm'
    'ZsaW5l');

@$core.Deprecated('Use administerResponseDescriptor instead')
const AdministerResponse$json = {
  '1': 'AdministerResponse',
  '2': [
    {
      '1': 'administration',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Administration',
      '10': 'administration'
    },
  ],
};

/// Descriptor for `AdministerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List administerResponseDescriptor = $convert.base64Decode(
    'ChJBZG1pbmlzdGVyUmVzcG9uc2USTQoOYWRtaW5pc3RyYXRpb24YASABKAsyJS5oZWFsdGhjYX'
    'JlLm51cnNpbmcudjEuQWRtaW5pc3RyYXRpb25SDmFkbWluaXN0cmF0aW9u');

@$core.Deprecated('Use listAdministrationsRequestDescriptor instead')
const ListAdministrationsRequest$json = {
  '1': 'ListAdministrationsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAdministrationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdministrationsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0QWRtaW5pc3RyYXRpb25zUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY2'
        '91bnRlcklkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIZCghvcmRlcl9pZBgDIAEo'
        'CVIHb3JkZXJJZBIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listAdministrationsResponseDescriptor instead')
const ListAdministrationsResponse$json = {
  '1': 'ListAdministrationsResponse',
  '2': [
    {
      '1': 'administrations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Administration',
      '10': 'administrations'
    },
  ],
};

/// Descriptor for `ListAdministrationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAdministrationsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0QWRtaW5pc3RyYXRpb25zUmVzcG9uc2USTwoPYWRtaW5pc3RyYXRpb25zGAEgAygLMi'
        'UuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFkbWluaXN0cmF0aW9uUg9hZG1pbmlzdHJhdGlvbnM=');

@$core.Deprecated('Use getOverrideReportRequestDescriptor instead')
const GetOverrideReportRequest$json = {
  '1': 'GetOverrideReportRequest',
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
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetOverrideReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverrideReportRequestDescriptor = $convert.base64Decode(
    'ChhHZXRPdmVycmlkZVJlcG9ydFJlcXVlc3QSLgoEZnJvbRgBIAEoCzIaLmdvb2dsZS5wcm90b2'
    'J1Zi5UaW1lc3RhbXBSBGZyb20SKgoCdG8YAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgJ0bxIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use getOverrideReportResponseDescriptor instead')
const GetOverrideReportResponse$json = {
  '1': 'GetOverrideReportResponse',
  '2': [
    {
      '1': 'administrations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Administration',
      '10': 'administrations'
    },
  ],
};

/// Descriptor for `GetOverrideReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getOverrideReportResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRPdmVycmlkZVJlcG9ydFJlc3BvbnNlEk8KD2FkbWluaXN0cmF0aW9ucxgBIAMoCzIlLm'
        'hlYWx0aGNhcmUubnVyc2luZy52MS5BZG1pbmlzdHJhdGlvblIPYWRtaW5pc3RyYXRpb25z');

@$core.Deprecated('Use setAdministrationPolicyRequestDescriptor instead')
const SetAdministrationPolicyRequest$json = {
  '1': 'SetAdministrationPolicyRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'policy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AdministrationPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `SetAdministrationPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAdministrationPolicyRequestDescriptor =
    $convert.base64Decode(
        'Ch5TZXRBZG1pbmlzdHJhdGlvblBvbGljeVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCm'
        'ZhY2lsaXR5SWQSQwoGcG9saWN5GAIgASgLMisuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFkbWlu'
        'aXN0cmF0aW9uUG9saWN5UgZwb2xpY3k=');

@$core.Deprecated('Use setAdministrationPolicyResponseDescriptor instead')
const SetAdministrationPolicyResponse$json = {
  '1': 'SetAdministrationPolicyResponse',
};

/// Descriptor for `SetAdministrationPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAdministrationPolicyResponseDescriptor =
    $convert.base64Decode('Ch9TZXRBZG1pbmlzdHJhdGlvblBvbGljeVJlc3BvbnNl');

@$core.Deprecated('Use nursingTaskDescriptor instead')
const NursingTask$json = {
  '1': 'NursingTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'priority',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TaskPriority',
      '10': 'priority'
    },
    {
      '1': 'due_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'source_kind', '3': 7, '4': 1, '5': 9, '10': 'sourceKind'},
    {'1': 'source_id', '3': 8, '4': 1, '5': 9, '10': 'sourceId'},
    {
      '1': 'recur_every_seconds',
      '3': 9,
      '4': 1,
      '5': 3,
      '10': 'recurEverySeconds'
    },
    {
      '1': 'recur_until',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recurUntil'
    },
    {
      '1': 'status',
      '3': 11,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TaskStatus',
      '10': 'status'
    },
    {'1': 'evidence', '3': 12, '4': 1, '5': 9, '10': 'evidence'},
    {
      '1': 'completed_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'completed_by', '3': 14, '4': 1, '5': 9, '10': 'completedBy'},
    {'1': 'not_done_reason', '3': 15, '4': 1, '5': 9, '10': 'notDoneReason'},
    {'1': 'assigned_to', '3': 16, '4': 1, '5': 9, '10': 'assignedTo'},
    {
      '1': 'escalated_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'escalatedAt'
    },
    {'1': 'escalated_to', '3': 18, '4': 1, '5': 9, '10': 'escalatedTo'},
    {'1': 'overdue', '3': 19, '4': 1, '5': 8, '10': 'overdue'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `NursingTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nursingTaskDescriptor = $convert.base64Decode(
    'CgtOdXJzaW5nVGFzaxIXCgd0YXNrX2lkGAEgASgJUgZ0YXNrSWQSHQoKcGF0aWVudF9pZBgCIA'
    'EoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQSIAoLZGVz'
    'Y3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEj8KCHByaW9yaXR5GAUgASgOMiMuaGVhbHRoY2'
    'FyZS5udXJzaW5nLnYxLlRhc2tQcmlvcml0eVIIcHJpb3JpdHkSMQoGZHVlX2F0GAYgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIFZHVlQXQSHwoLc291cmNlX2tpbmQYByABKAlSCn'
    'NvdXJjZUtpbmQSGwoJc291cmNlX2lkGAggASgJUghzb3VyY2VJZBIuChNyZWN1cl9ldmVyeV9z'
    'ZWNvbmRzGAkgASgDUhFyZWN1ckV2ZXJ5U2Vjb25kcxI7CgtyZWN1cl91bnRpbBgKIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY3VyVW50aWwSOQoGc3RhdHVzGAsgASgOMiEu'
    'aGVhbHRoY2FyZS5udXJzaW5nLnYxLlRhc2tTdGF0dXNSBnN0YXR1cxIaCghldmlkZW5jZRgMIA'
    'EoCVIIZXZpZGVuY2USPQoMY29tcGxldGVkX2F0GA0gASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFILY29tcGxldGVkQXQSIQoMY29tcGxldGVkX2J5GA4gASgJUgtjb21wbGV0ZWRCeR'
    'ImCg9ub3RfZG9uZV9yZWFzb24YDyABKAlSDW5vdERvbmVSZWFzb24SHwoLYXNzaWduZWRfdG8Y'
    'ECABKAlSCmFzc2lnbmVkVG8SPQoMZXNjYWxhdGVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFILZXNjYWxhdGVkQXQSIQoMZXNjYWxhdGVkX3RvGBIgASgJUgtlc2NhbGF0'
    'ZWRUbxIYCgdvdmVyZHVlGBMgASgIUgdvdmVyZHVlEhgKB3ZlcnNpb24YFCABKANSB3ZlcnNpb2'
    '4=');

@$core.Deprecated('Use createTaskRequestDescriptor instead')
const CreateTaskRequest$json = {
  '1': 'CreateTaskRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TaskPriority',
      '10': 'priority'
    },
    {
      '1': 'due_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {
      '1': 'recur_every_seconds',
      '3': 6,
      '4': 1,
      '5': 3,
      '10': 'recurEverySeconds'
    },
    {
      '1': 'recur_until',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recurUntil'
    },
    {'1': 'assigned_to', '3': 8, '4': 1, '5': 9, '10': 'assignedTo'},
  ],
};

/// Descriptor for `CreateTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVUYXNrUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSIQoMZW'
    '5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVz'
    'Y3JpcHRpb24SPwoIcHJpb3JpdHkYBCABKA4yIy5oZWFsdGhjYXJlLm51cnNpbmcudjEuVGFza1'
    'ByaW9yaXR5Ughwcmlvcml0eRIxCgZkdWVfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgVkdWVBdBIuChNyZWN1cl9ldmVyeV9zZWNvbmRzGAYgASgDUhFyZWN1ckV2ZXJ5U2'
    'Vjb25kcxI7CgtyZWN1cl91bnRpbBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CnJlY3VyVW50aWwSHwoLYXNzaWduZWRfdG8YCCABKAlSCmFzc2lnbmVkVG8=');

@$core.Deprecated('Use createTaskResponseDescriptor instead')
const CreateTaskResponse$json = {
  '1': 'CreateTaskResponse',
  '2': [
    {
      '1': 'task',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.NursingTask',
      '10': 'task'
    },
  ],
};

/// Descriptor for `CreateTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTaskResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVUYXNrUmVzcG9uc2USNgoEdGFzaxgBIAEoCzIiLmhlYWx0aGNhcmUubnVyc2luZy'
    '52MS5OdXJzaW5nVGFza1IEdGFzaw==');

@$core.Deprecated('Use completeTaskRequestDescriptor instead')
const CompleteTaskRequest$json = {
  '1': 'CompleteTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'evidence', '3': 2, '4': 1, '5': 9, '10': 'evidence'},
  ],
};

/// Descriptor for `CompleteTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTaskRequestDescriptor = $convert.base64Decode(
    'ChNDb21wbGV0ZVRhc2tSZXF1ZXN0EhcKB3Rhc2tfaWQYASABKAlSBnRhc2tJZBIaCghldmlkZW'
    '5jZRgCIAEoCVIIZXZpZGVuY2U=');

@$core.Deprecated('Use completeTaskResponseDescriptor instead')
const CompleteTaskResponse$json = {
  '1': 'CompleteTaskResponse',
  '2': [
    {
      '1': 'next',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.NursingTask',
      '10': 'next'
    },
  ],
};

/// Descriptor for `CompleteTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTaskResponseDescriptor = $convert.base64Decode(
    'ChRDb21wbGV0ZVRhc2tSZXNwb25zZRI2CgRuZXh0GAEgASgLMiIuaGVhbHRoY2FyZS5udXJzaW'
    '5nLnYxLk51cnNpbmdUYXNrUgRuZXh0');

@$core.Deprecated('Use skipTaskRequestDescriptor instead')
const SkipTaskRequest$json = {
  '1': 'SkipTaskRequest',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `SkipTaskRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skipTaskRequestDescriptor = $convert.base64Decode(
    'Cg9Ta2lwVGFza1JlcXVlc3QSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEhYKBnJlYXNvbhgCIA'
    'EoCVIGcmVhc29u');

@$core.Deprecated('Use skipTaskResponseDescriptor instead')
const SkipTaskResponse$json = {
  '1': 'SkipTaskResponse',
};

/// Descriptor for `SkipTaskResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List skipTaskResponseDescriptor =
    $convert.base64Decode('ChBTa2lwVGFza1Jlc3BvbnNl');

@$core.Deprecated('Use getWorklistRequestDescriptor instead')
const GetWorklistRequest$json = {
  '1': 'GetWorklistRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'assigned_to', '3': 2, '4': 1, '5': 9, '10': 'assignedTo'},
    {'1': 'pending_only', '3': 3, '4': 1, '5': 8, '10': 'pendingOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetWorklistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistRequestDescriptor = $convert.base64Decode(
    'ChJHZXRXb3JrbGlzdFJlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZB'
    'IfCgthc3NpZ25lZF90bxgCIAEoCVIKYXNzaWduZWRUbxIhCgxwZW5kaW5nX29ubHkYAyABKAhS'
    'C3BlbmRpbmdPbmx5EhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use getWorklistResponseDescriptor instead')
const GetWorklistResponse$json = {
  '1': 'GetWorklistResponse',
  '2': [
    {
      '1': 'tasks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.NursingTask',
      '10': 'tasks'
    },
  ],
};

/// Descriptor for `GetWorklistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWorklistResponseDescriptor = $convert.base64Decode(
    'ChNHZXRXb3JrbGlzdFJlc3BvbnNlEjgKBXRhc2tzGAEgAygLMiIuaGVhbHRoY2FyZS5udXJzaW'
    '5nLnYxLk51cnNpbmdUYXNrUgV0YXNrcw==');

@$core.Deprecated('Use escalateOverdueWorkRequestDescriptor instead')
const EscalateOverdueWorkRequest$json = {
  '1': 'EscalateOverdueWorkRequest',
  '2': [
    {'1': 'escalate_to', '3': 1, '4': 1, '5': 9, '10': 'escalateTo'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `EscalateOverdueWorkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueWorkRequestDescriptor =
    $convert.base64Decode(
        'ChpFc2NhbGF0ZU92ZXJkdWVXb3JrUmVxdWVzdBIfCgtlc2NhbGF0ZV90bxgBIAEoCVIKZXNjYW'
        'xhdGVUbxIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use escalateOverdueWorkResponseDescriptor instead')
const EscalateOverdueWorkResponse$json = {
  '1': 'EscalateOverdueWorkResponse',
  '2': [
    {
      '1': 'escalated',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.NursingTask',
      '10': 'escalated'
    },
  ],
};

/// Descriptor for `EscalateOverdueWorkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List escalateOverdueWorkResponseDescriptor =
    $convert.base64Decode(
        'ChtFc2NhbGF0ZU92ZXJkdWVXb3JrUmVzcG9uc2USQAoJZXNjYWxhdGVkGAEgAygLMiIuaGVhbH'
        'RoY2FyZS5udXJzaW5nLnYxLk51cnNpbmdUYXNrUgllc2NhbGF0ZWQ=');

@$core.Deprecated('Use planGoalDescriptor instead')
const PlanGoal$json = {
  '1': 'PlanGoal',
  '2': [
    {'1': 'goal_id', '3': 1, '4': 1, '5': 9, '10': 'goalId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'target_date',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'targetDate'
    },
    {'1': 'met', '3': 4, '4': 1, '5': 8, '10': 'met'},
    {'1': 'evaluation', '3': 5, '4': 1, '5': 9, '10': 'evaluation'},
  ],
};

/// Descriptor for `PlanGoal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planGoalDescriptor = $convert.base64Decode(
    'CghQbGFuR29hbBIXCgdnb2FsX2lkGAEgASgJUgZnb2FsSWQSIAoLZGVzY3JpcHRpb24YAiABKA'
    'lSC2Rlc2NyaXB0aW9uEjsKC3RhcmdldF9kYXRlGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIKdGFyZ2V0RGF0ZRIQCgNtZXQYBCABKAhSA21ldBIeCgpldmFsdWF0aW9uGAUgAS'
    'gJUgpldmFsdWF0aW9u');

@$core.Deprecated('Use interventionDescriptor instead')
const Intervention$json = {
  '1': 'Intervention',
  '2': [
    {'1': 'intervention_id', '3': 1, '4': 1, '5': 9, '10': 'interventionId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'every_seconds', '3': 3, '4': 1, '5': 3, '10': 'everySeconds'},
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TaskPriority',
      '10': 'priority'
    },
    {'1': 'owner', '3': 5, '4': 1, '5': 9, '10': 'owner'},
  ],
};

/// Descriptor for `Intervention`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interventionDescriptor = $convert.base64Decode(
    'CgxJbnRlcnZlbnRpb24SJwoPaW50ZXJ2ZW50aW9uX2lkGAEgASgJUg5pbnRlcnZlbnRpb25JZB'
    'IgCgtkZXNjcmlwdGlvbhgCIAEoCVILZGVzY3JpcHRpb24SIwoNZXZlcnlfc2Vjb25kcxgDIAEo'
    'A1IMZXZlcnlTZWNvbmRzEj8KCHByaW9yaXR5GAQgASgOMiMuaGVhbHRoY2FyZS5udXJzaW5nLn'
    'YxLlRhc2tQcmlvcml0eVIIcHJpb3JpdHkSFAoFb3duZXIYBSABKAlSBW93bmVy');

@$core.Deprecated('Use planProblemDescriptor instead')
const PlanProblem$json = {
  '1': 'PlanProblem',
  '2': [
    {'1': 'problem_id', '3': 1, '4': 1, '5': 9, '10': 'problemId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'coded',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'coded'
    },
    {
      '1': 'goals',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.PlanGoal',
      '10': 'goals'
    },
    {
      '1': 'interventions',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Intervention',
      '10': 'interventions'
    },
    {'1': 'resolved', '3': 6, '4': 1, '5': 8, '10': 'resolved'},
  ],
};

/// Descriptor for `PlanProblem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planProblemDescriptor = $convert.base64Decode(
    'CgtQbGFuUHJvYmxlbRIdCgpwcm9ibGVtX2lkGAEgASgJUglwcm9ibGVtSWQSIAoLZGVzY3JpcH'
    'Rpb24YAiABKAlSC2Rlc2NyaXB0aW9uEjMKBWNvZGVkGAMgASgLMh0uaGVhbHRoY2FyZS5udXJz'
    'aW5nLnYxLkNvZGluZ1IFY29kZWQSNQoFZ29hbHMYBCADKAsyHy5oZWFsdGhjYXJlLm51cnNpbm'
    'cudjEuUGxhbkdvYWxSBWdvYWxzEkkKDWludGVydmVudGlvbnMYBSADKAsyIy5oZWFsdGhjYXJl'
    'Lm51cnNpbmcudjEuSW50ZXJ2ZW50aW9uUg1pbnRlcnZlbnRpb25zEhoKCHJlc29sdmVkGAYgAS'
    'gIUghyZXNvbHZlZA==');

@$core.Deprecated('Use carePlanDescriptor instead')
const CarePlan$json = {
  '1': 'CarePlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'title', '3': 4, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'problems',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.PlanProblem',
      '10': 'problems'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.PlanStatus',
      '10': 'status'
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
    {
      '1': 'reviewed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewedAt'
    },
    {'1': 'reviewed_by', '3': 10, '4': 1, '5': 9, '10': 'reviewedBy'},
    {'1': 'evaluation', '3': 11, '4': 1, '5': 9, '10': 'evaluation'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CarePlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List carePlanDescriptor = $convert.base64Decode(
    'CghDYXJlUGxhbhIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSHQoKcGF0aWVudF9pZBgCIAEoCV'
    'IJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQSFAoFdGl0bGUY'
    'BCABKAlSBXRpdGxlEj4KCHByb2JsZW1zGAUgAygLMiIuaGVhbHRoY2FyZS5udXJzaW5nLnYxLl'
    'BsYW5Qcm9ibGVtUghwcm9ibGVtcxI5CgZzdGF0dXMYBiABKA4yIS5oZWFsdGhjYXJlLm51cnNp'
    'bmcudjEuUGxhblN0YXR1c1IGc3RhdHVzEjkKCmNyZWF0ZWRfYXQYByABKAsyGi5nb29nbGUucH'
    'JvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgIIAEoCVIJY3JlYXRl'
    'ZEJ5EjsKC3Jldmlld2VkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcm'
    'V2aWV3ZWRBdBIfCgtyZXZpZXdlZF9ieRgKIAEoCVIKcmV2aWV3ZWRCeRIeCgpldmFsdWF0aW9u'
    'GAsgASgJUgpldmFsdWF0aW9uEhgKB3ZlcnNpb24YDCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use createCarePlanRequestDescriptor instead')
const CreateCarePlanRequest$json = {
  '1': 'CreateCarePlanRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {
      '1': 'problems',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.PlanProblem',
      '10': 'problems'
    },
    {
      '1': 'schedule_until',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduleUntil'
    },
  ],
};

/// Descriptor for `CreateCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCarePlanRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVDYXJlUGxhblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSFAoFdGl0bGUYAyABKAlSBXRpdGxl'
    'Ej4KCHByb2JsZW1zGAQgAygLMiIuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlBsYW5Qcm9ibGVtUg'
    'hwcm9ibGVtcxJBCg5zY2hlZHVsZV91bnRpbBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSDXNjaGVkdWxlVW50aWw=');

@$core.Deprecated('Use createCarePlanResponseDescriptor instead')
const CreateCarePlanResponse$json = {
  '1': 'CreateCarePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.CarePlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `CreateCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCarePlanResponseDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVDYXJlUGxhblJlc3BvbnNlEjMKBHBsYW4YASABKAsyHy5oZWFsdGhjYXJlLm51cn'
        'NpbmcudjEuQ2FyZVBsYW5SBHBsYW4=');

@$core.Deprecated('Use reviewCarePlanRequestDescriptor instead')
const ReviewCarePlanRequest$json = {
  '1': 'ReviewCarePlanRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'evaluation', '3': 2, '4': 1, '5': 9, '10': 'evaluation'},
  ],
};

/// Descriptor for `ReviewCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCarePlanRequestDescriptor = $convert.base64Decode(
    'ChVSZXZpZXdDYXJlUGxhblJlcXVlc3QSFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEh4KCmV2YW'
    'x1YXRpb24YAiABKAlSCmV2YWx1YXRpb24=');

@$core.Deprecated('Use reviewCarePlanResponseDescriptor instead')
const ReviewCarePlanResponse$json = {
  '1': 'ReviewCarePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.CarePlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `ReviewCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewCarePlanResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXZpZXdDYXJlUGxhblJlc3BvbnNlEjMKBHBsYW4YASABKAsyHy5oZWFsdGhjYXJlLm51cn'
        'NpbmcudjEuQ2FyZVBsYW5SBHBsYW4=');

@$core.Deprecated('Use listCarePlansRequestDescriptor instead')
const ListCarePlansRequest$json = {
  '1': 'ListCarePlansRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'active_only', '3': 3, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListCarePlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0Q2FyZVBsYW5zUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bnRlck'
    'lkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZBIfCgthY3RpdmVfb25seRgDIAEoCFIK'
    'YWN0aXZlT25seRIbCglwYWdlX3NpemUYBCABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listCarePlansResponseDescriptor instead')
const ListCarePlansResponse$json = {
  '1': 'ListCarePlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.CarePlan',
      '10': 'plans'
    },
  ],
};

/// Descriptor for `ListCarePlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2FyZVBsYW5zUmVzcG9uc2USNQoFcGxhbnMYASADKAsyHy5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuQ2FyZVBsYW5SBXBsYW5z');

@$core.Deprecated('Use shiftDescriptor instead')
const Shift$json = {
  '1': 'Shift',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'starts_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
  ],
};

/// Descriptor for `Shift`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shiftDescriptor = $convert.base64Decode(
    'CgVTaGlmdBISCgRjb2RlGAEgASgJUgRjb2RlEjcKCXN0YXJ0c19hdBgCIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YXJ0c0F0EjMKB2VuZHNfYXQYAyABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUgZlbmRzQXQ=');

@$core.Deprecated('Use handoverDeviceDescriptor instead')
const HandoverDevice$json = {
  '1': 'HandoverDevice',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.DeviceKind',
      '10': 'kind'
    },
    {'1': 'site', '3': 3, '4': 1, '5': 9, '10': 'site'},
    {
      '1': 'inserted_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'insertedAt'
    },
    {'1': 'device_days', '3': 5, '4': 1, '5': 5, '10': 'deviceDays'},
  ],
};

/// Descriptor for `HandoverDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverDeviceDescriptor = $convert.base64Decode(
    'Cg5IYW5kb3ZlckRldmljZRIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEjUKBGtpbmQYAi'
    'ABKA4yIS5oZWFsdGhjYXJlLm51cnNpbmcudjEuRGV2aWNlS2luZFIEa2luZBISCgRzaXRlGAMg'
    'ASgJUgRzaXRlEjsKC2luc2VydGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdG'
    'FtcFIKaW5zZXJ0ZWRBdBIfCgtkZXZpY2VfZGF5cxgFIAEoBVIKZGV2aWNlRGF5cw==');

@$core.Deprecated('Use handoverTaskDescriptor instead')
const HandoverTask$json = {
  '1': 'HandoverTask',
  '2': [
    {'1': 'task_id', '3': 1, '4': 1, '5': 9, '10': 'taskId'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'priority',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TaskPriority',
      '10': 'priority'
    },
    {
      '1': 'due_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueAt'
    },
    {'1': 'overdue', '3': 5, '4': 1, '5': 8, '10': 'overdue'},
  ],
};

/// Descriptor for `HandoverTask`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverTaskDescriptor = $convert.base64Decode(
    'CgxIYW5kb3ZlclRhc2sSFwoHdGFza19pZBgBIAEoCVIGdGFza0lkEiAKC2Rlc2NyaXB0aW9uGA'
    'IgASgJUgtkZXNjcmlwdGlvbhI/Cghwcmlvcml0eRgDIAEoDjIjLmhlYWx0aGNhcmUubnVyc2lu'
    'Zy52MS5UYXNrUHJpb3JpdHlSCHByaW9yaXR5EjEKBmR1ZV9hdBgEIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSBWR1ZUF0EhgKB292ZXJkdWUYBSABKAhSB292ZXJkdWU=');

@$core.Deprecated('Use handoverDescriptor instead')
const Handover$json = {
  '1': 'Handover',
  '2': [
    {'1': 'handover_id', '3': 1, '4': 1, '5': 9, '10': 'handoverId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'unit_id', '3': 4, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'from_shift',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Shift',
      '10': 'fromShift'
    },
    {
      '1': 'to_shift',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Shift',
      '10': 'toShift'
    },
    {'1': 'situation', '3': 7, '4': 1, '5': 9, '10': 'situation'},
    {'1': 'background', '3': 8, '4': 1, '5': 9, '10': 'background'},
    {'1': 'assessment', '3': 9, '4': 1, '5': 9, '10': 'assessment'},
    {'1': 'recommendation', '3': 10, '4': 1, '5': 9, '10': 'recommendation'},
    {'1': 'critical_risks', '3': 11, '4': 3, '5': 9, '10': 'criticalRisks'},
    {'1': 'outstanding', '3': 12, '4': 3, '5': 9, '10': 'outstanding'},
    {
      '1': 'devices',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.HandoverDevice',
      '10': 'devices'
    },
    {
      '1': 'pending_tasks',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.HandoverTask',
      '10': 'pendingTasks'
    },
    {
      '1': 'composed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'composedAt'
    },
    {'1': 'composed_by', '3': 16, '4': 1, '5': 9, '10': 'composedBy'},
    {
      '1': 'acknowledged_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'acknowledgedAt'
    },
    {'1': 'acknowledged_by', '3': 18, '4': 1, '5': 9, '10': 'acknowledgedBy'},
    {'1': 'questions', '3': 19, '4': 1, '5': 9, '10': 'questions'},
    {'1': 'version', '3': 20, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Handover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverDescriptor = $convert.base64Decode(
    'CghIYW5kb3ZlchIfCgtoYW5kb3Zlcl9pZBgBIAEoCVIKaGFuZG92ZXJJZBIdCgpwYXRpZW50X2'
    'lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJZBIX'
    'Cgd1bml0X2lkGAQgASgJUgZ1bml0SWQSOwoKZnJvbV9zaGlmdBgFIAEoCzIcLmhlYWx0aGNhcm'
    'UubnVyc2luZy52MS5TaGlmdFIJZnJvbVNoaWZ0EjcKCHRvX3NoaWZ0GAYgASgLMhwuaGVhbHRo'
    'Y2FyZS5udXJzaW5nLnYxLlNoaWZ0Ugd0b1NoaWZ0EhwKCXNpdHVhdGlvbhgHIAEoCVIJc2l0dW'
    'F0aW9uEh4KCmJhY2tncm91bmQYCCABKAlSCmJhY2tncm91bmQSHgoKYXNzZXNzbWVudBgJIAEo'
    'CVIKYXNzZXNzbWVudBImCg5yZWNvbW1lbmRhdGlvbhgKIAEoCVIOcmVjb21tZW5kYXRpb24SJQ'
    'oOY3JpdGljYWxfcmlza3MYCyADKAlSDWNyaXRpY2FsUmlza3MSIAoLb3V0c3RhbmRpbmcYDCAD'
    'KAlSC291dHN0YW5kaW5nEj8KB2RldmljZXMYDSADKAsyJS5oZWFsdGhjYXJlLm51cnNpbmcudj'
    'EuSGFuZG92ZXJEZXZpY2VSB2RldmljZXMSSAoNcGVuZGluZ190YXNrcxgOIAMoCzIjLmhlYWx0'
    'aGNhcmUubnVyc2luZy52MS5IYW5kb3ZlclRhc2tSDHBlbmRpbmdUYXNrcxI7Cgtjb21wb3NlZF'
    '9hdBgPIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmNvbXBvc2VkQXQSHwoLY29t'
    'cG9zZWRfYnkYECABKAlSCmNvbXBvc2VkQnkSQwoPYWNrbm93bGVkZ2VkX2F0GBEgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOYWNrbm93bGVkZ2VkQXQSJwoPYWNrbm93bGVkZ2Vk'
    'X2J5GBIgASgJUg5hY2tub3dsZWRnZWRCeRIcCglxdWVzdGlvbnMYEyABKAlSCXF1ZXN0aW9ucx'
    'IYCgd2ZXJzaW9uGBQgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use composeHandoverRequestDescriptor instead')
const ComposeHandoverRequest$json = {
  '1': 'ComposeHandoverRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'unit_id', '3': 3, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'from_shift',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Shift',
      '10': 'fromShift'
    },
    {
      '1': 'to_shift',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Shift',
      '10': 'toShift'
    },
    {'1': 'situation', '3': 6, '4': 1, '5': 9, '10': 'situation'},
    {'1': 'background', '3': 7, '4': 1, '5': 9, '10': 'background'},
    {'1': 'assessment', '3': 8, '4': 1, '5': 9, '10': 'assessment'},
    {'1': 'recommendation', '3': 9, '4': 1, '5': 9, '10': 'recommendation'},
    {'1': 'critical_risks', '3': 10, '4': 3, '5': 9, '10': 'criticalRisks'},
    {'1': 'outstanding', '3': 11, '4': 3, '5': 9, '10': 'outstanding'},
  ],
};

/// Descriptor for `ComposeHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List composeHandoverRequestDescriptor = $convert.base64Decode(
    'ChZDb21wb3NlSGFuZG92ZXJSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IhCgxlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEhcKB3VuaXRfaWQYAyABKAlSBnVu'
    'aXRJZBI7Cgpmcm9tX3NoaWZ0GAQgASgLMhwuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlNoaWZ0Ug'
    'lmcm9tU2hpZnQSNwoIdG9fc2hpZnQYBSABKAsyHC5oZWFsdGhjYXJlLm51cnNpbmcudjEuU2hp'
    'ZnRSB3RvU2hpZnQSHAoJc2l0dWF0aW9uGAYgASgJUglzaXR1YXRpb24SHgoKYmFja2dyb3VuZB'
    'gHIAEoCVIKYmFja2dyb3VuZBIeCgphc3Nlc3NtZW50GAggASgJUgphc3Nlc3NtZW50EiYKDnJl'
    'Y29tbWVuZGF0aW9uGAkgASgJUg5yZWNvbW1lbmRhdGlvbhIlCg5jcml0aWNhbF9yaXNrcxgKIA'
    'MoCVINY3JpdGljYWxSaXNrcxIgCgtvdXRzdGFuZGluZxgLIAMoCVILb3V0c3RhbmRpbmc=');

@$core.Deprecated('Use composeHandoverResponseDescriptor instead')
const ComposeHandoverResponse$json = {
  '1': 'ComposeHandoverResponse',
  '2': [
    {
      '1': 'handover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Handover',
      '10': 'handover'
    },
  ],
};

/// Descriptor for `ComposeHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List composeHandoverResponseDescriptor =
    $convert.base64Decode(
        'ChdDb21wb3NlSGFuZG92ZXJSZXNwb25zZRI7CghoYW5kb3ZlchgBIAEoCzIfLmhlYWx0aGNhcm'
        'UubnVyc2luZy52MS5IYW5kb3ZlclIIaGFuZG92ZXI=');

@$core.Deprecated('Use acknowledgeHandoverRequestDescriptor instead')
const AcknowledgeHandoverRequest$json = {
  '1': 'AcknowledgeHandoverRequest',
  '2': [
    {'1': 'handover_id', '3': 1, '4': 1, '5': 9, '10': 'handoverId'},
    {'1': 'questions', '3': 2, '4': 1, '5': 9, '10': 'questions'},
  ],
};

/// Descriptor for `AcknowledgeHandoverRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeHandoverRequestDescriptor =
    $convert.base64Decode(
        'ChpBY2tub3dsZWRnZUhhbmRvdmVyUmVxdWVzdBIfCgtoYW5kb3Zlcl9pZBgBIAEoCVIKaGFuZG'
        '92ZXJJZBIcCglxdWVzdGlvbnMYAiABKAlSCXF1ZXN0aW9ucw==');

@$core.Deprecated('Use acknowledgeHandoverResponseDescriptor instead')
const AcknowledgeHandoverResponse$json = {
  '1': 'AcknowledgeHandoverResponse',
  '2': [
    {
      '1': 'handover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Handover',
      '10': 'handover'
    },
  ],
};

/// Descriptor for `AcknowledgeHandoverResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeHandoverResponseDescriptor =
    $convert.base64Decode(
        'ChtBY2tub3dsZWRnZUhhbmRvdmVyUmVzcG9uc2USOwoIaGFuZG92ZXIYASABKAsyHy5oZWFsdG'
        'hjYXJlLm51cnNpbmcudjEuSGFuZG92ZXJSCGhhbmRvdmVy');

@$core.Deprecated('Use listHandoversRequestDescriptor instead')
const ListHandoversRequest$json = {
  '1': 'ListHandoversRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'unacknowledged_only',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'unacknowledgedOnly'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListHandoversRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHandoversRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0SGFuZG92ZXJzUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY291bnRlck'
    'lkEi8KE3VuYWNrbm93bGVkZ2VkX29ubHkYAiABKAhSEnVuYWNrbm93bGVkZ2VkT25seRIbCglw'
    'YWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listHandoversResponseDescriptor instead')
const ListHandoversResponse$json = {
  '1': 'ListHandoversResponse',
  '2': [
    {
      '1': 'handovers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Handover',
      '10': 'handovers'
    },
  ],
};

/// Descriptor for `ListHandoversResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listHandoversResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0SGFuZG92ZXJzUmVzcG9uc2USPQoJaGFuZG92ZXJzGAEgAygLMh8uaGVhbHRoY2FyZS'
    '5udXJzaW5nLnYxLkhhbmRvdmVyUgloYW5kb3ZlcnM=');

@$core.Deprecated('Use restraintAuthorizationDescriptor instead')
const RestraintAuthorization$json = {
  '1': 'RestraintAuthorization',
  '2': [
    {'1': 'authorized_by', '3': 1, '4': 1, '5': 9, '10': 'authorizedBy'},
    {
      '1': 'authorized_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'authorizedAt'
    },
    {
      '1': 'expires_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
    {'1': 'indication', '3': 4, '4': 1, '5': 9, '10': 'indication'},
  ],
};

/// Descriptor for `RestraintAuthorization`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restraintAuthorizationDescriptor = $convert.base64Decode(
    'ChZSZXN0cmFpbnRBdXRob3JpemF0aW9uEiMKDWF1dGhvcml6ZWRfYnkYASABKAlSDGF1dGhvcm'
    'l6ZWRCeRI/Cg1hdXRob3JpemVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIMYXV0aG9yaXplZEF0EjkKCmV4cGlyZXNfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUglleHBpcmVzQXQSHgoKaW5kaWNhdGlvbhgEIAEoCVIKaW5kaWNhdGlvbg==');

@$core.Deprecated('Use restraintCheckDescriptor instead')
const RestraintCheck$json = {
  '1': 'RestraintCheck',
  '2': [
    {'1': 'check_id', '3': 1, '4': 1, '5': 9, '10': 'checkId'},
    {
      '1': 'observed_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'observed_by', '3': 3, '4': 1, '5': 9, '10': 'observedBy'},
    {'1': 'findings', '3': 4, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'continued_reason', '3': 5, '4': 1, '5': 9, '10': 'continuedReason'},
  ],
};

/// Descriptor for `RestraintCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restraintCheckDescriptor = $convert.base64Decode(
    'Cg5SZXN0cmFpbnRDaGVjaxIZCghjaGVja19pZBgBIAEoCVIHY2hlY2tJZBI7CgtvYnNlcnZlZF'
    '9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9ic2VydmVkQXQSHwoLb2Jz'
    'ZXJ2ZWRfYnkYAyABKAlSCm9ic2VydmVkQnkSGgoIZmluZGluZ3MYBCABKAlSCGZpbmRpbmdzEi'
    'kKEGNvbnRpbnVlZF9yZWFzb24YBSABKAlSD2NvbnRpbnVlZFJlYXNvbg==');

@$core.Deprecated('Use restraintDescriptor instead')
const Restraint$json = {
  '1': 'Restraint',
  '2': [
    {'1': 'restraint_id', '3': 1, '4': 1, '5': 9, '10': 'restraintId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.RestraintKind',
      '10': 'kind'
    },
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'authorization',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RestraintAuthorization',
      '10': 'authorization'
    },
    {
      '1': 'renewals',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RestraintAuthorization',
      '10': 'renewals'
    },
    {
      '1': 'started_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 9, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'monitor_every_seconds',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'monitorEverySeconds'
    },
    {
      '1': 'monitoring',
      '3': 11,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.RestraintCheck',
      '10': 'monitoring'
    },
    {
      '1': 'discontinued_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'discontinuedAt'
    },
    {'1': 'discontinued_by', '3': 13, '4': 1, '5': 9, '10': 'discontinuedBy'},
    {
      '1': 'discontinued_reason',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'discontinuedReason'
    },
    {
      '1': 'authorization_expired',
      '3': 15,
      '4': 1,
      '5': 8,
      '10': 'authorizationExpired'
    },
    {
      '1': 'monitoring_overdue',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'monitoringOverdue'
    },
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Restraint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restraintDescriptor = $convert.base64Decode(
    'CglSZXN0cmFpbnQSIQoMcmVzdHJhaW50X2lkGAEgASgJUgtyZXN0cmFpbnRJZBIdCgpwYXRpZW'
    '50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNvdW50ZXJJ'
    'ZBI4CgRraW5kGAQgASgOMiQuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlc3RyYWludEtpbmRSBG'
    'tpbmQSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2NyaXB0aW9uElMKDWF1dGhvcml6YXRpb24Y'
    'BiABKAsyLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuUmVzdHJhaW50QXV0aG9yaXphdGlvblINYX'
    'V0aG9yaXphdGlvbhJJCghyZW5ld2FscxgHIAMoCzItLmhlYWx0aGNhcmUubnVyc2luZy52MS5S'
    'ZXN0cmFpbnRBdXRob3JpemF0aW9uUghyZW5ld2FscxI5CgpzdGFydGVkX2F0GAggASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Eh0KCnN0YXJ0ZWRfYnkYCSABKAlS'
    'CXN0YXJ0ZWRCeRIyChVtb25pdG9yX2V2ZXJ5X3NlY29uZHMYCiABKANSE21vbml0b3JFdmVyeV'
    'NlY29uZHMSRQoKbW9uaXRvcmluZxgLIAMoCzIlLmhlYWx0aGNhcmUubnVyc2luZy52MS5SZXN0'
    'cmFpbnRDaGVja1IKbW9uaXRvcmluZxJDCg9kaXNjb250aW51ZWRfYXQYDCABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUg5kaXNjb250aW51ZWRBdBInCg9kaXNjb250aW51ZWRfYnkY'
    'DSABKAlSDmRpc2NvbnRpbnVlZEJ5Ei8KE2Rpc2NvbnRpbnVlZF9yZWFzb24YDiABKAlSEmRpc2'
    'NvbnRpbnVlZFJlYXNvbhIzChVhdXRob3JpemF0aW9uX2V4cGlyZWQYDyABKAhSFGF1dGhvcml6'
    'YXRpb25FeHBpcmVkEi0KEm1vbml0b3Jpbmdfb3ZlcmR1ZRgQIAEoCFIRbW9uaXRvcmluZ092ZX'
    'JkdWUSGAoHdmVyc2lvbhgRIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use applyRestraintRequestDescriptor instead')
const ApplyRestraintRequest$json = {
  '1': 'ApplyRestraintRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.RestraintKind',
      '10': 'kind'
    },
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'authorization',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RestraintAuthorization',
      '10': 'authorization'
    },
    {
      '1': 'started_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {
      '1': 'monitor_every_seconds',
      '3': 7,
      '4': 1,
      '5': 3,
      '10': 'monitorEverySeconds'
    },
  ],
};

/// Descriptor for `ApplyRestraintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyRestraintRequestDescriptor = $convert.base64Decode(
    'ChVBcHBseVJlc3RyYWludFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSOAoEa2luZBgDIAEoDjIkLmhlYWx0'
    'aGNhcmUubnVyc2luZy52MS5SZXN0cmFpbnRLaW5kUgRraW5kEiAKC2Rlc2NyaXB0aW9uGAQgAS'
    'gJUgtkZXNjcmlwdGlvbhJTCg1hdXRob3JpemF0aW9uGAUgASgLMi0uaGVhbHRoY2FyZS5udXJz'
    'aW5nLnYxLlJlc3RyYWludEF1dGhvcml6YXRpb25SDWF1dGhvcml6YXRpb24SOQoKc3RhcnRlZF'
    '9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBIyChVtb25p'
    'dG9yX2V2ZXJ5X3NlY29uZHMYByABKANSE21vbml0b3JFdmVyeVNlY29uZHM=');

@$core.Deprecated('Use applyRestraintResponseDescriptor instead')
const ApplyRestraintResponse$json = {
  '1': 'ApplyRestraintResponse',
  '2': [
    {
      '1': 'restraint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Restraint',
      '10': 'restraint'
    },
  ],
};

/// Descriptor for `ApplyRestraintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applyRestraintResponseDescriptor =
    $convert.base64Decode(
        'ChZBcHBseVJlc3RyYWludFJlc3BvbnNlEj4KCXJlc3RyYWludBgBIAEoCzIgLmhlYWx0aGNhcm'
        'UubnVyc2luZy52MS5SZXN0cmFpbnRSCXJlc3RyYWludA==');

@$core.Deprecated('Use renewRestraintRequestDescriptor instead')
const RenewRestraintRequest$json = {
  '1': 'RenewRestraintRequest',
  '2': [
    {'1': 'restraint_id', '3': 1, '4': 1, '5': 9, '10': 'restraintId'},
    {
      '1': 'authorization',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.RestraintAuthorization',
      '10': 'authorization'
    },
  ],
};

/// Descriptor for `RenewRestraintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renewRestraintRequestDescriptor = $convert.base64Decode(
    'ChVSZW5ld1Jlc3RyYWludFJlcXVlc3QSIQoMcmVzdHJhaW50X2lkGAEgASgJUgtyZXN0cmFpbn'
    'RJZBJTCg1hdXRob3JpemF0aW9uGAIgASgLMi0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlc3Ry'
    'YWludEF1dGhvcml6YXRpb25SDWF1dGhvcml6YXRpb24=');

@$core.Deprecated('Use renewRestraintResponseDescriptor instead')
const RenewRestraintResponse$json = {
  '1': 'RenewRestraintResponse',
  '2': [
    {
      '1': 'restraint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Restraint',
      '10': 'restraint'
    },
  ],
};

/// Descriptor for `RenewRestraintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List renewRestraintResponseDescriptor =
    $convert.base64Decode(
        'ChZSZW5ld1Jlc3RyYWludFJlc3BvbnNlEj4KCXJlc3RyYWludBgBIAEoCzIgLmhlYWx0aGNhcm'
        'UubnVyc2luZy52MS5SZXN0cmFpbnRSCXJlc3RyYWludA==');

@$core.Deprecated('Use checkRestraintRequestDescriptor instead')
const CheckRestraintRequest$json = {
  '1': 'CheckRestraintRequest',
  '2': [
    {'1': 'restraint_id', '3': 1, '4': 1, '5': 9, '10': 'restraintId'},
    {
      '1': 'observed_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'findings', '3': 3, '4': 1, '5': 9, '10': 'findings'},
    {'1': 'continued_reason', '3': 4, '4': 1, '5': 9, '10': 'continuedReason'},
  ],
};

/// Descriptor for `CheckRestraintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRestraintRequestDescriptor = $convert.base64Decode(
    'ChVDaGVja1Jlc3RyYWludFJlcXVlc3QSIQoMcmVzdHJhaW50X2lkGAEgASgJUgtyZXN0cmFpbn'
    'RJZBI7CgtvYnNlcnZlZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9i'
    'c2VydmVkQXQSGgoIZmluZGluZ3MYAyABKAlSCGZpbmRpbmdzEikKEGNvbnRpbnVlZF9yZWFzb2'
    '4YBCABKAlSD2NvbnRpbnVlZFJlYXNvbg==');

@$core.Deprecated('Use checkRestraintResponseDescriptor instead')
const CheckRestraintResponse$json = {
  '1': 'CheckRestraintResponse',
};

/// Descriptor for `CheckRestraintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkRestraintResponseDescriptor =
    $convert.base64Decode('ChZDaGVja1Jlc3RyYWludFJlc3BvbnNl');

@$core.Deprecated('Use discontinueRestraintRequestDescriptor instead')
const DiscontinueRestraintRequest$json = {
  '1': 'DiscontinueRestraintRequest',
  '2': [
    {'1': 'restraint_id', '3': 1, '4': 1, '5': 9, '10': 'restraintId'},
    {
      '1': 'discontinued_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'discontinuedAt'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DiscontinueRestraintRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discontinueRestraintRequestDescriptor =
    $convert.base64Decode(
        'ChtEaXNjb250aW51ZVJlc3RyYWludFJlcXVlc3QSIQoMcmVzdHJhaW50X2lkGAEgASgJUgtyZX'
        'N0cmFpbnRJZBJDCg9kaXNjb250aW51ZWRfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
        'ZXN0YW1wUg5kaXNjb250aW51ZWRBdBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use discontinueRestraintResponseDescriptor instead')
const DiscontinueRestraintResponse$json = {
  '1': 'DiscontinueRestraintResponse',
  '2': [
    {
      '1': 'restraint',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Restraint',
      '10': 'restraint'
    },
  ],
};

/// Descriptor for `DiscontinueRestraintResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discontinueRestraintResponseDescriptor =
    $convert.base64Decode(
        'ChxEaXNjb250aW51ZVJlc3RyYWludFJlc3BvbnNlEj4KCXJlc3RyYWludBgBIAEoCzIgLmhlYW'
        'x0aGNhcmUubnVyc2luZy52MS5SZXN0cmFpbnRSCXJlc3RyYWludA==');

@$core.Deprecated('Use listRestraintsRequestDescriptor instead')
const ListRestraintsRequest$json = {
  '1': 'ListRestraintsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListRestraintsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRestraintsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0UmVzdHJhaW50c1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZX'
    'JJZBIfCgthY3RpdmVfb25seRgCIAEoCFIKYWN0aXZlT25seRIbCglwYWdlX3NpemUYAyABKAVS'
    'CHBhZ2VTaXpl');

@$core.Deprecated('Use listRestraintsResponseDescriptor instead')
const ListRestraintsResponse$json = {
  '1': 'ListRestraintsResponse',
  '2': [
    {
      '1': 'restraints',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Restraint',
      '10': 'restraints'
    },
  ],
};

/// Descriptor for `ListRestraintsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRestraintsResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0UmVzdHJhaW50c1Jlc3BvbnNlEkAKCnJlc3RyYWludHMYASADKAsyIC5oZWFsdGhjYX'
        'JlLm51cnNpbmcudjEuUmVzdHJhaW50UgpyZXN0cmFpbnRz');

@$core.Deprecated('Use getRestraintAlertsRequestDescriptor instead')
const GetRestraintAlertsRequest$json = {
  '1': 'GetRestraintAlertsRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetRestraintAlertsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRestraintAlertsRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRSZXN0cmFpbnRBbGVydHNSZXF1ZXN0EhsKCXBhZ2Vfc2l6ZRgBIAEoBVIIcGFnZVNpem'
        'U=');

@$core.Deprecated('Use getRestraintAlertsResponseDescriptor instead')
const GetRestraintAlertsResponse$json = {
  '1': 'GetRestraintAlertsResponse',
  '2': [
    {
      '1': 'restraints',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.Restraint',
      '10': 'restraints'
    },
  ],
};

/// Descriptor for `GetRestraintAlertsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRestraintAlertsResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRSZXN0cmFpbnRBbGVydHNSZXNwb25zZRJACgpyZXN0cmFpbnRzGAEgAygLMiAuaGVhbH'
        'RoY2FyZS5udXJzaW5nLnYxLlJlc3RyYWludFIKcmVzdHJhaW50cw==');

@$core.Deprecated('Use transfusionObservationDescriptor instead')
const TransfusionObservation$json = {
  '1': 'TransfusionObservation',
  '2': [
    {'1': 'observation_id', '3': 1, '4': 1, '5': 9, '10': 'observationId'},
    {
      '1': 'observed_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observedAt'
    },
    {'1': 'observed_by', '3': 3, '4': 1, '5': 9, '10': 'observedBy'},
    {'1': 'temperature_c', '3': 4, '4': 1, '5': 1, '10': 'temperatureC'},
    {'1': 'pulse', '3': 5, '4': 1, '5': 5, '10': 'pulse'},
    {'1': 'systolic_bp', '3': 6, '4': 1, '5': 5, '10': 'systolicBp'},
    {'1': 'respiratory_rate', '3': 7, '4': 1, '5': 5, '10': 'respiratoryRate'},
    {'1': 'baseline', '3': 8, '4': 1, '5': 8, '10': 'baseline'},
    {'1': 'notes', '3': 9, '4': 1, '5': 9, '10': 'notes'},
  ],
  '7': {'3': true},
};

/// Descriptor for `TransfusionObservation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transfusionObservationDescriptor = $convert.base64Decode(
    'ChZUcmFuc2Z1c2lvbk9ic2VydmF0aW9uEiUKDm9ic2VydmF0aW9uX2lkGAEgASgJUg1vYnNlcn'
    'ZhdGlvbklkEjsKC29ic2VydmVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIKb2JzZXJ2ZWRBdBIfCgtvYnNlcnZlZF9ieRgDIAEoCVIKb2JzZXJ2ZWRCeRIjCg10ZW1wZX'
    'JhdHVyZV9jGAQgASgBUgx0ZW1wZXJhdHVyZUMSFAoFcHVsc2UYBSABKAVSBXB1bHNlEh8KC3N5'
    'c3RvbGljX2JwGAYgASgFUgpzeXN0b2xpY0JwEikKEHJlc3BpcmF0b3J5X3JhdGUYByABKAVSD3'
    'Jlc3BpcmF0b3J5UmF0ZRIaCghiYXNlbGluZRgIIAEoCFIIYmFzZWxpbmUSFAoFbm90ZXMYCSAB'
    'KAlSBW5vdGVzOgIYAQ==');

@$core.Deprecated('Use transfusionReactionDescriptor instead')
const TransfusionReaction$json = {
  '1': 'TransfusionReaction',
  '2': [
    {
      '1': 'reported_at',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'reported_by', '3': 2, '4': 1, '5': 9, '10': 'reportedBy'},
    {'1': 'features', '3': 3, '4': 1, '5': 9, '10': 'features'},
    {'1': 'action_taken', '3': 4, '4': 1, '5': 9, '10': 'actionTaken'},
    {'1': 'unit_returned', '3': 5, '4': 1, '5': 8, '10': 'unitReturned'},
  ],
  '7': {'3': true},
};

/// Descriptor for `TransfusionReaction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transfusionReactionDescriptor = $convert.base64Decode(
    'ChNUcmFuc2Z1c2lvblJlYWN0aW9uEjsKC3JlcG9ydGVkX2F0GAEgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIKcmVwb3J0ZWRBdBIfCgtyZXBvcnRlZF9ieRgCIAEoCVIKcmVwb3J0'
    'ZWRCeRIaCghmZWF0dXJlcxgDIAEoCVIIZmVhdHVyZXMSIQoMYWN0aW9uX3Rha2VuGAQgASgJUg'
    'thY3Rpb25UYWtlbhIjCg11bml0X3JldHVybmVkGAUgASgIUgx1bml0UmV0dXJuZWQ6AhgB');

@$core.Deprecated('Use transfusionDescriptor instead')
const Transfusion$json = {
  '1': 'Transfusion',
  '2': [
    {'1': 'transfusion_id', '3': 1, '4': 1, '5': 9, '10': 'transfusionId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'unit_number', '3': 4, '4': 1, '5': 9, '10': 'unitNumber'},
    {
      '1': 'product',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'product'
    },
    {'1': 'abo_group', '3': 6, '4': 1, '5': 9, '10': 'aboGroup'},
    {'1': 'rhd', '3': 7, '4': 1, '5': 9, '10': 'rhd'},
    {'1': 'volume_ml', '3': 8, '4': 1, '5': 1, '10': 'volumeMl'},
    {
      '1': 'started_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 10, '4': 1, '5': 9, '10': 'startedBy'},
    {'1': 'checked_by', '3': 11, '4': 1, '5': 9, '10': 'checkedBy'},
    {
      '1': 'observations',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.TransfusionObservation',
      '10': 'observations'
    },
    {
      '1': 'status',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.TransfusionStatus',
      '10': 'status'
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
      '1': 'reaction',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.TransfusionReaction',
      '10': 'reaction'
    },
    {'1': 'version', '3': 16, '4': 1, '5': 3, '10': 'version'},
  ],
  '7': {'3': true},
};

/// Descriptor for `Transfusion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transfusionDescriptor = $convert.base64Decode(
    'CgtUcmFuc2Z1c2lvbhIlCg50cmFuc2Z1c2lvbl9pZBgBIAEoCVINdHJhbnNmdXNpb25JZBIdCg'
    'pwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNv'
    'dW50ZXJJZBIfCgt1bml0X251bWJlchgEIAEoCVIKdW5pdE51bWJlchI3Cgdwcm9kdWN0GAUgAS'
    'gLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNvZGluZ1IHcHJvZHVjdBIbCglhYm9fZ3JvdXAY'
    'BiABKAlSCGFib0dyb3VwEhAKA3JoZBgHIAEoCVIDcmhkEhsKCXZvbHVtZV9tbBgIIAEoAVIIdm'
    '9sdW1lTWwSOQoKc3RhcnRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXN0YXJ0ZWRBdBIdCgpzdGFydGVkX2J5GAogASgJUglzdGFydGVkQnkSHQoKY2hlY2tlZF9ieR'
    'gLIAEoCVIJY2hlY2tlZEJ5ElEKDG9ic2VydmF0aW9ucxgMIAMoCzItLmhlYWx0aGNhcmUubnVy'
    'c2luZy52MS5UcmFuc2Z1c2lvbk9ic2VydmF0aW9uUgxvYnNlcnZhdGlvbnMSQAoGc3RhdHVzGA'
    '0gASgOMiguaGVhbHRoY2FyZS5udXJzaW5nLnYxLlRyYW5zZnVzaW9uU3RhdHVzUgZzdGF0dXMS'
    'NQoIZW5kZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRlZEF0Ek'
    'YKCHJlYWN0aW9uGA8gASgLMiouaGVhbHRoY2FyZS5udXJzaW5nLnYxLlRyYW5zZnVzaW9uUmVh'
    'Y3Rpb25SCHJlYWN0aW9uEhgKB3ZlcnNpb24YECABKANSB3ZlcnNpb246AhgB');

@$core.Deprecated('Use startTransfusionRequestDescriptor instead')
const StartTransfusionRequest$json = {
  '1': 'StartTransfusionRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'unit_number', '3': 3, '4': 1, '5': 9, '10': 'unitNumber'},
    {
      '1': 'product',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'product'
    },
    {'1': 'abo_group', '3': 5, '4': 1, '5': 9, '10': 'aboGroup'},
    {'1': 'rhd', '3': 6, '4': 1, '5': 9, '10': 'rhd'},
    {'1': 'volume_ml', '3': 7, '4': 1, '5': 1, '10': 'volumeMl'},
    {
      '1': 'started_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'checked_by', '3': 9, '4': 1, '5': 9, '10': 'checkedBy'},
    {
      '1': 'baseline',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.TransfusionObservation',
      '10': 'baseline'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `StartTransfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTransfusionRequestDescriptor = $convert.base64Decode(
    'ChdTdGFydFRyYW5zZnVzaW9uUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIfCgt1bml0X251bWJlchgDIAEo'
    'CVIKdW5pdE51bWJlchI3Cgdwcm9kdWN0GAQgASgLMh0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLk'
    'NvZGluZ1IHcHJvZHVjdBIbCglhYm9fZ3JvdXAYBSABKAlSCGFib0dyb3VwEhAKA3JoZBgGIAEo'
    'CVIDcmhkEhsKCXZvbHVtZV9tbBgHIAEoAVIIdm9sdW1lTWwSOQoKc3RhcnRlZF9hdBgIIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBIdCgpjaGVja2VkX2J5GAkg'
    'ASgJUgljaGVja2VkQnkSSQoIYmFzZWxpbmUYCiABKAsyLS5oZWFsdGhjYXJlLm51cnNpbmcudj'
    'EuVHJhbnNmdXNpb25PYnNlcnZhdGlvblIIYmFzZWxpbmU6AhgB');

@$core.Deprecated('Use startTransfusionResponseDescriptor instead')
const StartTransfusionResponse$json = {
  '1': 'StartTransfusionResponse',
  '2': [
    {
      '1': 'transfusion',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Transfusion',
      '10': 'transfusion'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `StartTransfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTransfusionResponseDescriptor =
    $convert.base64Decode(
        'ChhTdGFydFRyYW5zZnVzaW9uUmVzcG9uc2USRAoLdHJhbnNmdXNpb24YASABKAsyIi5oZWFsdG'
        'hjYXJlLm51cnNpbmcudjEuVHJhbnNmdXNpb25SC3RyYW5zZnVzaW9uOgIYAQ==');

@$core.Deprecated('Use observeTransfusionRequestDescriptor instead')
const ObserveTransfusionRequest$json = {
  '1': 'ObserveTransfusionRequest',
  '2': [
    {'1': 'transfusion_id', '3': 1, '4': 1, '5': 9, '10': 'transfusionId'},
    {
      '1': 'observation',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.TransfusionObservation',
      '10': 'observation'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `ObserveTransfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeTransfusionRequestDescriptor = $convert.base64Decode(
    'ChlPYnNlcnZlVHJhbnNmdXNpb25SZXF1ZXN0EiUKDnRyYW5zZnVzaW9uX2lkGAEgASgJUg10cm'
    'Fuc2Z1c2lvbklkEk8KC29ic2VydmF0aW9uGAIgASgLMi0uaGVhbHRoY2FyZS5udXJzaW5nLnYx'
    'LlRyYW5zZnVzaW9uT2JzZXJ2YXRpb25SC29ic2VydmF0aW9uOgIYAQ==');

@$core.Deprecated('Use observeTransfusionResponseDescriptor instead')
const ObserveTransfusionResponse$json = {
  '1': 'ObserveTransfusionResponse',
  '2': [
    {
      '1': 'transfusion',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Transfusion',
      '10': 'transfusion'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `ObserveTransfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observeTransfusionResponseDescriptor =
    $convert.base64Decode(
        'ChpPYnNlcnZlVHJhbnNmdXNpb25SZXNwb25zZRJECgt0cmFuc2Z1c2lvbhgBIAEoCzIiLmhlYW'
        'x0aGNhcmUubnVyc2luZy52MS5UcmFuc2Z1c2lvblILdHJhbnNmdXNpb246AhgB');

@$core.Deprecated('Use reportTransfusionReactionRequestDescriptor instead')
const ReportTransfusionReactionRequest$json = {
  '1': 'ReportTransfusionReactionRequest',
  '2': [
    {'1': 'transfusion_id', '3': 1, '4': 1, '5': 9, '10': 'transfusionId'},
    {'1': 'features', '3': 2, '4': 1, '5': 9, '10': 'features'},
    {'1': 'action_taken', '3': 3, '4': 1, '5': 9, '10': 'actionTaken'},
    {'1': 'unit_returned', '3': 4, '4': 1, '5': 8, '10': 'unitReturned'},
  ],
  '7': {'3': true},
};

/// Descriptor for `ReportTransfusionReactionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportTransfusionReactionRequestDescriptor =
    $convert.base64Decode(
        'CiBSZXBvcnRUcmFuc2Z1c2lvblJlYWN0aW9uUmVxdWVzdBIlCg50cmFuc2Z1c2lvbl9pZBgBIA'
        'EoCVINdHJhbnNmdXNpb25JZBIaCghmZWF0dXJlcxgCIAEoCVIIZmVhdHVyZXMSIQoMYWN0aW9u'
        'X3Rha2VuGAMgASgJUgthY3Rpb25UYWtlbhIjCg11bml0X3JldHVybmVkGAQgASgIUgx1bml0Um'
        'V0dXJuZWQ6AhgB');

@$core.Deprecated('Use reportTransfusionReactionResponseDescriptor instead')
const ReportTransfusionReactionResponse$json = {
  '1': 'ReportTransfusionReactionResponse',
  '2': [
    {
      '1': 'transfusion',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Transfusion',
      '10': 'transfusion'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `ReportTransfusionReactionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportTransfusionReactionResponseDescriptor =
    $convert.base64Decode(
        'CiFSZXBvcnRUcmFuc2Z1c2lvblJlYWN0aW9uUmVzcG9uc2USRAoLdHJhbnNmdXNpb24YASABKA'
        'syIi5oZWFsdGhjYXJlLm51cnNpbmcudjEuVHJhbnNmdXNpb25SC3RyYW5zZnVzaW9uOgIYAQ==');

@$core.Deprecated('Use completeTransfusionRequestDescriptor instead')
const CompleteTransfusionRequest$json = {
  '1': 'CompleteTransfusionRequest',
  '2': [
    {'1': 'transfusion_id', '3': 1, '4': 1, '5': 9, '10': 'transfusionId'},
    {
      '1': 'ended_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `CompleteTransfusionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTransfusionRequestDescriptor =
    $convert.base64Decode(
        'ChpDb21wbGV0ZVRyYW5zZnVzaW9uUmVxdWVzdBIlCg50cmFuc2Z1c2lvbl9pZBgBIAEoCVINdH'
        'JhbnNmdXNpb25JZBI1CghlbmRlZF9hdBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3Rh'
        'bXBSB2VuZGVkQXQ6AhgB');

@$core.Deprecated('Use completeTransfusionResponseDescriptor instead')
const CompleteTransfusionResponse$json = {
  '1': 'CompleteTransfusionResponse',
  '2': [
    {
      '1': 'transfusion',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Transfusion',
      '10': 'transfusion'
    },
  ],
  '7': {'3': true},
};

/// Descriptor for `CompleteTransfusionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeTransfusionResponseDescriptor =
    $convert.base64Decode(
        'ChtDb21wbGV0ZVRyYW5zZnVzaW9uUmVzcG9uc2USRAoLdHJhbnNmdXNpb24YASABKAsyIi5oZW'
        'FsdGhjYXJlLm51cnNpbmcudjEuVHJhbnNmdXNpb25SC3RyYW5zZnVzaW9uOgIYAQ==');

@$core.Deprecated('Use woundImageDescriptor instead')
const WoundImage$json = {
  '1': 'WoundImage',
  '2': [
    {'1': 'image_id', '3': 1, '4': 1, '5': 9, '10': 'imageId'},
    {'1': 'consent_id', '3': 2, '4': 1, '5': 9, '10': 'consentId'},
    {'1': 'storage_key', '3': 3, '4': 1, '5': 9, '10': 'storageKey'},
    {'1': 'content_type', '3': 4, '4': 1, '5': 9, '10': 'contentType'},
    {
      '1': 'captured_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {'1': 'captured_by', '3': 6, '4': 1, '5': 9, '10': 'capturedBy'},
    {'1': 'sequence', '3': 7, '4': 1, '5': 5, '10': 'sequence'},
  ],
};

/// Descriptor for `WoundImage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List woundImageDescriptor = $convert.base64Decode(
    'CgpXb3VuZEltYWdlEhkKCGltYWdlX2lkGAEgASgJUgdpbWFnZUlkEh0KCmNvbnNlbnRfaWQYAi'
    'ABKAlSCWNvbnNlbnRJZBIfCgtzdG9yYWdlX2tleRgDIAEoCVIKc3RvcmFnZUtleRIhCgxjb250'
    'ZW50X3R5cGUYBCABKAlSC2NvbnRlbnRUeXBlEjsKC2NhcHR1cmVkX2F0GAUgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIKY2FwdHVyZWRBdBIfCgtjYXB0dXJlZF9ieRgGIAEoCVIK'
    'Y2FwdHVyZWRCeRIaCghzZXF1ZW5jZRgHIAEoBVIIc2VxdWVuY2U=');

@$core.Deprecated('Use woundAssessmentDescriptor instead')
const WoundAssessment$json = {
  '1': 'WoundAssessment',
  '2': [
    {
      '1': 'wound_assessment_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'woundAssessmentId'
    },
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'wound_id', '3': 4, '4': 1, '5': 9, '10': 'woundId'},
    {'1': 'location', '3': 5, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'body_map_code',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'bodyMapCode'
    },
    {
      '1': 'laterality',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Laterality',
      '10': 'laterality'
    },
    {
      '1': 'kind',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.WoundKind',
      '10': 'kind'
    },
    {'1': 'stage', '3': 9, '4': 1, '5': 9, '10': 'stage'},
    {'1': 'length_mm', '3': 10, '4': 1, '5': 1, '10': 'lengthMm'},
    {'1': 'width_mm', '3': 11, '4': 1, '5': 1, '10': 'widthMm'},
    {'1': 'depth_mm', '3': 12, '4': 1, '5': 1, '10': 'depthMm'},
    {'1': 'appearance', '3': 13, '4': 1, '5': 9, '10': 'appearance'},
    {'1': 'exudate', '3': 14, '4': 1, '5': 9, '10': 'exudate'},
    {'1': 'surrounding_skin', '3': 15, '4': 1, '5': 9, '10': 'surroundingSkin'},
    {'1': 'pain_score', '3': 16, '4': 1, '5': 5, '10': 'painScore'},
    {
      '1': 'pain_score_recorded',
      '3': 17,
      '4': 1,
      '5': 8,
      '10': 'painScoreRecorded'
    },
    {
      '1': 'images',
      '3': 18,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.WoundImage',
      '10': 'images'
    },
    {'1': 'area_mm2', '3': 19, '4': 1, '5': 1, '10': 'areaMm2'},
    {
      '1': 'assessed_at',
      '3': 20,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {
      '1': 'recorded_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'assessed_by', '3': 22, '4': 1, '5': 9, '10': 'assessedBy'},
    {'1': 'version', '3': 23, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `WoundAssessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List woundAssessmentDescriptor = $convert.base64Decode(
    'Cg9Xb3VuZEFzc2Vzc21lbnQSLgoTd291bmRfYXNzZXNzbWVudF9pZBgBIAEoCVIRd291bmRBc3'
    'Nlc3NtZW50SWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9p'
    'ZBgDIAEoCVILZW5jb3VudGVySWQSGQoId291bmRfaWQYBCABKAlSB3dvdW5kSWQSGgoIbG9jYX'
    'Rpb24YBSABKAlSCGxvY2F0aW9uEkEKDWJvZHlfbWFwX2NvZGUYBiABKAsyHS5oZWFsdGhjYXJl'
    'Lm51cnNpbmcudjEuQ29kaW5nUgtib2R5TWFwQ29kZRJBCgpsYXRlcmFsaXR5GAcgASgOMiEuaG'
    'VhbHRoY2FyZS5udXJzaW5nLnYxLkxhdGVyYWxpdHlSCmxhdGVyYWxpdHkSNAoEa2luZBgIIAEo'
    'DjIgLmhlYWx0aGNhcmUubnVyc2luZy52MS5Xb3VuZEtpbmRSBGtpbmQSFAoFc3RhZ2UYCSABKA'
    'lSBXN0YWdlEhsKCWxlbmd0aF9tbRgKIAEoAVIIbGVuZ3RoTW0SGQoId2lkdGhfbW0YCyABKAFS'
    'B3dpZHRoTW0SGQoIZGVwdGhfbW0YDCABKAFSB2RlcHRoTW0SHgoKYXBwZWFyYW5jZRgNIAEoCV'
    'IKYXBwZWFyYW5jZRIYCgdleHVkYXRlGA4gASgJUgdleHVkYXRlEikKEHN1cnJvdW5kaW5nX3Nr'
    'aW4YDyABKAlSD3N1cnJvdW5kaW5nU2tpbhIdCgpwYWluX3Njb3JlGBAgASgFUglwYWluU2Nvcm'
    'USLgoTcGFpbl9zY29yZV9yZWNvcmRlZBgRIAEoCFIRcGFpblNjb3JlUmVjb3JkZWQSOQoGaW1h'
    'Z2VzGBIgAygLMiEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLldvdW5kSW1hZ2VSBmltYWdlcxIZCg'
    'hhcmVhX21tMhgTIAEoAVIHYXJlYU1tMhI7Cgthc3Nlc3NlZF9hdBgUIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCmFzc2Vzc2VkQXQSOwoLcmVjb3JkZWRfYXQYFSABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNvcmRlZEF0Eh8KC2Fzc2Vzc2VkX2J5GBYgASgJ'
    'Ugphc3Nlc3NlZEJ5EhgKB3ZlcnNpb24YFyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use assessWoundRequestDescriptor instead')
const AssessWoundRequest$json = {
  '1': 'AssessWoundRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'wound_id', '3': 3, '4': 1, '5': 9, '10': 'woundId'},
    {'1': 'location', '3': 4, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'body_map_code',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'bodyMapCode'
    },
    {
      '1': 'laterality',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Laterality',
      '10': 'laterality'
    },
    {
      '1': 'kind',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.WoundKind',
      '10': 'kind'
    },
    {'1': 'stage', '3': 8, '4': 1, '5': 9, '10': 'stage'},
    {'1': 'length_mm', '3': 9, '4': 1, '5': 1, '10': 'lengthMm'},
    {'1': 'width_mm', '3': 10, '4': 1, '5': 1, '10': 'widthMm'},
    {'1': 'depth_mm', '3': 11, '4': 1, '5': 1, '10': 'depthMm'},
    {'1': 'appearance', '3': 12, '4': 1, '5': 9, '10': 'appearance'},
    {'1': 'exudate', '3': 13, '4': 1, '5': 9, '10': 'exudate'},
    {'1': 'surrounding_skin', '3': 14, '4': 1, '5': 9, '10': 'surroundingSkin'},
    {'1': 'pain_score', '3': 15, '4': 1, '5': 5, '10': 'painScore'},
    {
      '1': 'pain_score_recorded',
      '3': 16,
      '4': 1,
      '5': 8,
      '10': 'painScoreRecorded'
    },
    {
      '1': 'assessed_at',
      '3': 17,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
  ],
};

/// Descriptor for `AssessWoundRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessWoundRequestDescriptor = $convert.base64Decode(
    'ChJBc3Nlc3NXb3VuZFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEiEKDG'
    'VuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSGQoId291bmRfaWQYAyABKAlSB3dvdW5k'
    'SWQSGgoIbG9jYXRpb24YBCABKAlSCGxvY2F0aW9uEkEKDWJvZHlfbWFwX2NvZGUYBSABKAsyHS'
    '5oZWFsdGhjYXJlLm51cnNpbmcudjEuQ29kaW5nUgtib2R5TWFwQ29kZRJBCgpsYXRlcmFsaXR5'
    'GAYgASgOMiEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxhdGVyYWxpdHlSCmxhdGVyYWxpdHkSNA'
    'oEa2luZBgHIAEoDjIgLmhlYWx0aGNhcmUubnVyc2luZy52MS5Xb3VuZEtpbmRSBGtpbmQSFAoF'
    'c3RhZ2UYCCABKAlSBXN0YWdlEhsKCWxlbmd0aF9tbRgJIAEoAVIIbGVuZ3RoTW0SGQoId2lkdG'
    'hfbW0YCiABKAFSB3dpZHRoTW0SGQoIZGVwdGhfbW0YCyABKAFSB2RlcHRoTW0SHgoKYXBwZWFy'
    'YW5jZRgMIAEoCVIKYXBwZWFyYW5jZRIYCgdleHVkYXRlGA0gASgJUgdleHVkYXRlEikKEHN1cn'
    'JvdW5kaW5nX3NraW4YDiABKAlSD3N1cnJvdW5kaW5nU2tpbhIdCgpwYWluX3Njb3JlGA8gASgF'
    'UglwYWluU2NvcmUSLgoTcGFpbl9zY29yZV9yZWNvcmRlZBgQIAEoCFIRcGFpblNjb3JlUmVjb3'
    'JkZWQSOwoLYXNzZXNzZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgph'
    'c3Nlc3NlZEF0');

@$core.Deprecated('Use assessWoundResponseDescriptor instead')
const AssessWoundResponse$json = {
  '1': 'AssessWoundResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.WoundAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `AssessWoundResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assessWoundResponseDescriptor = $convert.base64Decode(
    'ChNBc3Nlc3NXb3VuZFJlc3BvbnNlEkYKCmFzc2Vzc21lbnQYASABKAsyJi5oZWFsdGhjYXJlLm'
    '51cnNpbmcudjEuV291bmRBc3Nlc3NtZW50Ugphc3Nlc3NtZW50');

@$core.Deprecated('Use attachWoundImageRequestDescriptor instead')
const AttachWoundImageRequest$json = {
  '1': 'AttachWoundImageRequest',
  '2': [
    {
      '1': 'wound_assessment_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'woundAssessmentId'
    },
    {'1': 'consent_id', '3': 2, '4': 1, '5': 9, '10': 'consentId'},
    {
      '1': 'storage_key',
      '3': 3,
      '4': 1,
      '5': 9,
      '8': {'3': true},
      '10': 'storageKey',
    },
    {'1': 'content_type', '3': 4, '4': 1, '5': 9, '10': 'contentType'},
    {
      '1': 'captured_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'capturedAt'
    },
    {'1': 'content', '3': 6, '4': 1, '5': 12, '10': 'content'},
  ],
};

/// Descriptor for `AttachWoundImageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachWoundImageRequestDescriptor = $convert.base64Decode(
    'ChdBdHRhY2hXb3VuZEltYWdlUmVxdWVzdBIuChN3b3VuZF9hc3Nlc3NtZW50X2lkGAEgASgJUh'
    'F3b3VuZEFzc2Vzc21lbnRJZBIdCgpjb25zZW50X2lkGAIgASgJUgljb25zZW50SWQSIwoLc3Rv'
    'cmFnZV9rZXkYAyABKAlCAhgBUgpzdG9yYWdlS2V5EiEKDGNvbnRlbnRfdHlwZRgEIAEoCVILY2'
    '9udGVudFR5cGUSOwoLY2FwdHVyZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgpjYXB0dXJlZEF0EhgKB2NvbnRlbnQYBiABKAxSB2NvbnRlbnQ=');

@$core.Deprecated('Use attachWoundImageResponseDescriptor instead')
const AttachWoundImageResponse$json = {
  '1': 'AttachWoundImageResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.WoundAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `AttachWoundImageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List attachWoundImageResponseDescriptor =
    $convert.base64Decode(
        'ChhBdHRhY2hXb3VuZEltYWdlUmVzcG9uc2USRgoKYXNzZXNzbWVudBgBIAEoCzImLmhlYWx0aG'
        'NhcmUubnVyc2luZy52MS5Xb3VuZEFzc2Vzc21lbnRSCmFzc2Vzc21lbnQ=');

@$core.Deprecated('Use getWoundHistoryRequestDescriptor instead')
const GetWoundHistoryRequest$json = {
  '1': 'GetWoundHistoryRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'wound_id', '3': 2, '4': 1, '5': 9, '10': 'woundId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetWoundHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWoundHistoryRequestDescriptor = $convert.base64Decode(
    'ChZHZXRXb3VuZEhpc3RvcnlSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IZCgh3b3VuZF9pZBgCIAEoCVIHd291bmRJZBIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use getWoundHistoryResponseDescriptor instead')
const GetWoundHistoryResponse$json = {
  '1': 'GetWoundHistoryResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.WoundAssessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `GetWoundHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getWoundHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRXb3VuZEhpc3RvcnlSZXNwb25zZRJICgthc3Nlc3NtZW50cxgBIAMoCzImLmhlYWx0aG'
        'NhcmUubnVyc2luZy52MS5Xb3VuZEFzc2Vzc21lbnRSC2Fzc2Vzc21lbnRz');

@$core.Deprecated('Use educationRecordDescriptor instead')
const EducationRecord$json = {
  '1': 'EducationRecord',
  '2': [
    {'1': 'education_id', '3': 1, '4': 1, '5': 9, '10': 'educationId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'topic',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'topic'
    },
    {
      '1': 'learner',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Learner',
      '10': 'learner'
    },
    {'1': 'learner_name', '3': 6, '4': 1, '5': 9, '10': 'learnerName'},
    {'1': 'method', '3': 7, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'understanding',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Understanding',
      '10': 'understanding'
    },
    {'1': 'barriers', '3': 9, '4': 1, '5': 9, '10': 'barriers'},
    {
      '1': 'taught_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'taughtAt'
    },
    {'1': 'taught_by', '3': 11, '4': 1, '5': 9, '10': 'taughtBy'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `EducationRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List educationRecordDescriptor = $convert.base64Decode(
    'Cg9FZHVjYXRpb25SZWNvcmQSIQoMZWR1Y2F0aW9uX2lkGAEgASgJUgtlZHVjYXRpb25JZBIdCg'
    'pwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJUgtlbmNv'
    'dW50ZXJJZBIzCgV0b3BpYxgEIAEoCzIdLmhlYWx0aGNhcmUubnVyc2luZy52MS5Db2RpbmdSBX'
    'RvcGljEjgKB2xlYXJuZXIYBSABKA4yHi5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGVhcm5lclIH'
    'bGVhcm5lchIhCgxsZWFybmVyX25hbWUYBiABKAlSC2xlYXJuZXJOYW1lEhYKBm1ldGhvZBgHIA'
    'EoCVIGbWV0aG9kEkoKDXVuZGVyc3RhbmRpbmcYCCABKA4yJC5oZWFsdGhjYXJlLm51cnNpbmcu'
    'djEuVW5kZXJzdGFuZGluZ1INdW5kZXJzdGFuZGluZxIaCghiYXJyaWVycxgJIAEoCVIIYmFycm'
    'llcnMSNwoJdGF1Z2h0X2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIdGF1'
    'Z2h0QXQSGwoJdGF1Z2h0X2J5GAsgASgJUgh0YXVnaHRCeRIYCgd2ZXJzaW9uGAwgASgDUgd2ZX'
    'JzaW9u');

@$core.Deprecated('Use recordEducationRequestDescriptor instead')
const RecordEducationRequest$json = {
  '1': 'RecordEducationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'topic',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.Coding',
      '10': 'topic'
    },
    {
      '1': 'learner',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Learner',
      '10': 'learner'
    },
    {'1': 'learner_name', '3': 5, '4': 1, '5': 9, '10': 'learnerName'},
    {'1': 'method', '3': 6, '4': 1, '5': 9, '10': 'method'},
    {
      '1': 'understanding',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.Understanding',
      '10': 'understanding'
    },
    {'1': 'barriers', '3': 8, '4': 1, '5': 9, '10': 'barriers'},
    {
      '1': 'taught_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'taughtAt'
    },
  ],
};

/// Descriptor for `RecordEducationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEducationRequestDescriptor = $convert.base64Decode(
    'ChZSZWNvcmRFZHVjYXRpb25SZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IhCgxlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEjMKBXRvcGljGAMgASgLMh0uaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLkNvZGluZ1IFdG9waWMSOAoHbGVhcm5lchgEIAEoDjIeLmhlYW'
    'x0aGNhcmUubnVyc2luZy52MS5MZWFybmVyUgdsZWFybmVyEiEKDGxlYXJuZXJfbmFtZRgFIAEo'
    'CVILbGVhcm5lck5hbWUSFgoGbWV0aG9kGAYgASgJUgZtZXRob2QSSgoNdW5kZXJzdGFuZGluZx'
    'gHIAEoDjIkLmhlYWx0aGNhcmUubnVyc2luZy52MS5VbmRlcnN0YW5kaW5nUg11bmRlcnN0YW5k'
    'aW5nEhoKCGJhcnJpZXJzGAggASgJUghiYXJyaWVycxI3Cgl0YXVnaHRfYXQYCSABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgh0YXVnaHRBdA==');

@$core.Deprecated('Use recordEducationResponseDescriptor instead')
const RecordEducationResponse$json = {
  '1': 'RecordEducationResponse',
  '2': [
    {
      '1': 'record',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.EducationRecord',
      '10': 'record'
    },
  ],
};

/// Descriptor for `RecordEducationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEducationResponseDescriptor =
    $convert.base64Decode(
        'ChdSZWNvcmRFZHVjYXRpb25SZXNwb25zZRI+CgZyZWNvcmQYASABKAsyJi5oZWFsdGhjYXJlLm'
        '51cnNpbmcudjEuRWR1Y2F0aW9uUmVjb3JkUgZyZWNvcmQ=');

@$core.Deprecated('Use readinessCriterionDescriptor instead')
const ReadinessCriterion$json = {
  '1': 'ReadinessCriterion',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'met', '3': 3, '4': 1, '5': 8, '10': 'met'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ReadinessCriterion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readinessCriterionDescriptor = $convert.base64Decode(
    'ChJSZWFkaW5lc3NDcml0ZXJpb24SEAoDa2V5GAEgASgJUgNrZXkSFAoFbGFiZWwYAiABKAlSBW'
    'xhYmVsEhAKA21ldBgDIAEoCFIDbWV0EhIKBG5vdGUYBCABKAlSBG5vdGU=');

@$core.Deprecated('Use dischargeReadinessDescriptor instead')
const DischargeReadiness$json = {
  '1': 'DischargeReadiness',
  '2': [
    {
      '1': 'criteria',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.ReadinessCriterion',
      '10': 'criteria'
    },
    {'1': 'ready', '3': 2, '4': 1, '5': 8, '10': 'ready'},
    {
      '1': 'assessed_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
    {'1': 'assessed_by', '3': 4, '4': 1, '5': 9, '10': 'assessedBy'},
  ],
};

/// Descriptor for `DischargeReadiness`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dischargeReadinessDescriptor = $convert.base64Decode(
    'ChJEaXNjaGFyZ2VSZWFkaW5lc3MSRQoIY3JpdGVyaWEYASADKAsyKS5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuUmVhZGluZXNzQ3JpdGVyaW9uUghjcml0ZXJpYRIUCgVyZWFkeRgCIAEoCFIFcmVh'
    'ZHkSOwoLYXNzZXNzZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgphc3'
    'Nlc3NlZEF0Eh8KC2Fzc2Vzc2VkX2J5GAQgASgJUgphc3Nlc3NlZEJ5');

@$core.Deprecated('Use getDischargeReadinessRequestDescriptor instead')
const GetDischargeReadinessRequest$json = {
  '1': 'GetDischargeReadinessRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `GetDischargeReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDischargeReadinessRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXREaXNjaGFyZ2VSZWFkaW5lc3NSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW'
        '5jb3VudGVySWQSHQoKcGF0aWVudF9pZBgCIAEoCVIJcGF0aWVudElk');

@$core.Deprecated('Use getDischargeReadinessResponseDescriptor instead')
const GetDischargeReadinessResponse$json = {
  '1': 'GetDischargeReadinessResponse',
  '2': [
    {
      '1': 'readiness',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.DischargeReadiness',
      '10': 'readiness'
    },
  ],
};

/// Descriptor for `GetDischargeReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDischargeReadinessResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXREaXNjaGFyZ2VSZWFkaW5lc3NSZXNwb25zZRJHCglyZWFkaW5lc3MYASABKAsyKS5oZW'
        'FsdGhjYXJlLm51cnNpbmcudjEuRGlzY2hhcmdlUmVhZGluZXNzUglyZWFkaW5lc3M=');

@$core.Deprecated('Use nurseAssignmentDescriptor instead')
const NurseAssignment$json = {
  '1': 'NurseAssignment',
  '2': [
    {'1': 'assignment_id', '3': 1, '4': 1, '5': 9, '10': 'assignmentId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'bed_id', '3': 3, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'nurse_id', '3': 5, '4': 1, '5': 9, '10': 'nurseId'},
    {
      '1': 'relationship',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.CareRelationship',
      '10': 'relationship'
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
      '1': 'effective_to',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
    {'1': 'assigned_by', '3': 9, '4': 1, '5': 9, '10': 'assignedBy'},
    {'1': 'ended_reason', '3': 10, '4': 1, '5': 9, '10': 'endedReason'},
    {'1': 'version', '3': 11, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `NurseAssignment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nurseAssignmentDescriptor = $convert.base64Decode(
    'Cg9OdXJzZUFzc2lnbm1lbnQSIwoNYXNzaWdubWVudF9pZBgBIAEoCVIMYXNzaWdubWVudElkEh'
    'cKB3VuaXRfaWQYAiABKAlSBnVuaXRJZBIVCgZiZWRfaWQYAyABKAlSBWJlZElkEh0KCnBhdGll'
    'bnRfaWQYBCABKAlSCXBhdGllbnRJZBIZCghudXJzZV9pZBgFIAEoCVIHbnVyc2VJZBJLCgxyZW'
    'xhdGlvbnNoaXAYBiABKA4yJy5oZWFsdGhjYXJlLm51cnNpbmcudjEuQ2FyZVJlbGF0aW9uc2hp'
    'cFIMcmVsYXRpb25zaGlwEkEKDmVmZmVjdGl2ZV9mcm9tGAcgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFINZWZmZWN0aXZlRnJvbRI9CgxlZmZlY3RpdmVfdG8YCCABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgtlZmZlY3RpdmVUbxIfCgthc3NpZ25lZF9ieRgJIAEoCV'
    'IKYXNzaWduZWRCeRIhCgxlbmRlZF9yZWFzb24YCiABKAlSC2VuZGVkUmVhc29uEhgKB3ZlcnNp'
    'b24YCyABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use assignNurseRequestDescriptor instead')
const AssignNurseRequest$json = {
  '1': 'AssignNurseRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'bed_id', '3': 2, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'nurse_id', '3': 4, '4': 1, '5': 9, '10': 'nurseId'},
    {
      '1': 'relationship',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.nursing.v1.CareRelationship',
      '10': 'relationship'
    },
    {
      '1': 'effective_from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
  ],
};

/// Descriptor for `AssignNurseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignNurseRequestDescriptor = $convert.base64Decode(
    'ChJBc3NpZ25OdXJzZVJlcXVlc3QSFwoHdW5pdF9pZBgBIAEoCVIGdW5pdElkEhUKBmJlZF9pZB'
    'gCIAEoCVIFYmVkSWQSHQoKcGF0aWVudF9pZBgDIAEoCVIJcGF0aWVudElkEhkKCG51cnNlX2lk'
    'GAQgASgJUgdudXJzZUlkEksKDHJlbGF0aW9uc2hpcBgFIAEoDjInLmhlYWx0aGNhcmUubnVyc2'
    'luZy52MS5DYXJlUmVsYXRpb25zaGlwUgxyZWxhdGlvbnNoaXASQQoOZWZmZWN0aXZlX2Zyb20Y'
    'BiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9t');

@$core.Deprecated('Use assignNurseResponseDescriptor instead')
const AssignNurseResponse$json = {
  '1': 'AssignNurseResponse',
  '2': [
    {
      '1': 'assignment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.NurseAssignment',
      '10': 'assignment'
    },
  ],
};

/// Descriptor for `AssignNurseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignNurseResponseDescriptor = $convert.base64Decode(
    'ChNBc3NpZ25OdXJzZVJlc3BvbnNlEkYKCmFzc2lnbm1lbnQYASABKAsyJi5oZWFsdGhjYXJlLm'
    '51cnNpbmcudjEuTnVyc2VBc3NpZ25tZW50Ugphc3NpZ25tZW50');

@$core.Deprecated('Use endAssignmentRequestDescriptor instead')
const EndAssignmentRequest$json = {
  '1': 'EndAssignmentRequest',
  '2': [
    {'1': 'assignment_id', '3': 1, '4': 1, '5': 9, '10': 'assignmentId'},
    {
      '1': 'effective_to',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `EndAssignmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endAssignmentRequestDescriptor = $convert.base64Decode(
    'ChRFbmRBc3NpZ25tZW50UmVxdWVzdBIjCg1hc3NpZ25tZW50X2lkGAEgASgJUgxhc3NpZ25tZW'
    '50SWQSPQoMZWZmZWN0aXZlX3RvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIL'
    'ZWZmZWN0aXZlVG8SFgoGcmVhc29uGAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use endAssignmentResponseDescriptor instead')
const EndAssignmentResponse$json = {
  '1': 'EndAssignmentResponse',
};

/// Descriptor for `EndAssignmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endAssignmentResponseDescriptor =
    $convert.base64Decode('ChVFbmRBc3NpZ25tZW50UmVzcG9uc2U=');

@$core.Deprecated('Use listAssignmentsRequestDescriptor instead')
const ListAssignmentsRequest$json = {
  '1': 'ListAssignmentsRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'nurse_id', '3': 3, '4': 1, '5': 9, '10': 'nurseId'},
    {
      '1': 'as_of',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'asOf'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAssignmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssignmentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QXNzaWdubWVudHNSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIdCgpwYX'
    'RpZW50X2lkGAIgASgJUglwYXRpZW50SWQSGQoIbnVyc2VfaWQYAyABKAlSB251cnNlSWQSLwoF'
    'YXNfb2YYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgRhc09mEhsKCXBhZ2Vfc2'
    'l6ZRgFIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listAssignmentsResponseDescriptor instead')
const ListAssignmentsResponse$json = {
  '1': 'ListAssignmentsResponse',
  '2': [
    {
      '1': 'assignments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.NurseAssignment',
      '10': 'assignments'
    },
  ],
};

/// Descriptor for `ListAssignmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssignmentsResponseDescriptor =
    $convert.base64Decode(
        'ChdMaXN0QXNzaWdubWVudHNSZXNwb25zZRJICgthc3NpZ25tZW50cxgBIAMoCzImLmhlYWx0aG'
        'NhcmUubnVyc2luZy52MS5OdXJzZUFzc2lnbm1lbnRSC2Fzc2lnbm1lbnRz');

@$core.Deprecated('Use acuityInputsDescriptor instead')
const AcuityInputs$json = {
  '1': 'AcuityInputs',
  '2': [
    {'1': 'dependency_score', '3': 1, '4': 1, '5': 5, '10': 'dependencyScore'},
    {'1': 'open_tasks', '3': 2, '4': 1, '5': 5, '10': 'openTasks'},
    {'1': 'overdue_tasks', '3': 3, '4': 1, '5': 5, '10': 'overdueTasks'},
    {'1': 'devices', '3': 4, '4': 1, '5': 5, '10': 'devices'},
    {'1': 'high_risk', '3': 5, '4': 1, '5': 5, '10': 'highRisk'},
    {'1': 'isolation', '3': 6, '4': 1, '5': 8, '10': 'isolation'},
  ],
};

/// Descriptor for `AcuityInputs`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acuityInputsDescriptor = $convert.base64Decode(
    'CgxBY3VpdHlJbnB1dHMSKQoQZGVwZW5kZW5jeV9zY29yZRgBIAEoBVIPZGVwZW5kZW5jeVNjb3'
    'JlEh0KCm9wZW5fdGFza3MYAiABKAVSCW9wZW5UYXNrcxIjCg1vdmVyZHVlX3Rhc2tzGAMgASgF'
    'UgxvdmVyZHVlVGFza3MSGAoHZGV2aWNlcxgEIAEoBVIHZGV2aWNlcxIbCgloaWdoX3Jpc2sYBS'
    'ABKAVSCGhpZ2hSaXNrEhwKCWlzb2xhdGlvbhgGIAEoCFIJaXNvbGF0aW9u');

@$core.Deprecated('Use acuityWeightsDescriptor instead')
const AcuityWeights$json = {
  '1': 'AcuityWeights',
  '2': [
    {'1': 'dependency', '3': 1, '4': 1, '5': 5, '10': 'dependency'},
    {'1': 'open_task', '3': 2, '4': 1, '5': 5, '10': 'openTask'},
    {'1': 'overdue_task', '3': 3, '4': 1, '5': 5, '10': 'overdueTask'},
    {'1': 'device', '3': 4, '4': 1, '5': 5, '10': 'device'},
    {'1': 'high_risk', '3': 5, '4': 1, '5': 5, '10': 'highRisk'},
    {'1': 'isolation', '3': 6, '4': 1, '5': 5, '10': 'isolation'},
  ],
};

/// Descriptor for `AcuityWeights`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acuityWeightsDescriptor = $convert.base64Decode(
    'Cg1BY3VpdHlXZWlnaHRzEh4KCmRlcGVuZGVuY3kYASABKAVSCmRlcGVuZGVuY3kSGwoJb3Blbl'
    '90YXNrGAIgASgFUghvcGVuVGFzaxIhCgxvdmVyZHVlX3Rhc2sYAyABKAVSC292ZXJkdWVUYXNr'
    'EhYKBmRldmljZRgEIAEoBVIGZGV2aWNlEhsKCWhpZ2hfcmlzaxgFIAEoBVIIaGlnaFJpc2sSHA'
    'oJaXNvbGF0aW9uGAYgASgFUglpc29sYXRpb24=');

@$core.Deprecated('Use patientAcuityDescriptor instead')
const PatientAcuity$json = {
  '1': 'PatientAcuity',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'inputs',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AcuityInputs',
      '10': 'inputs'
    },
    {'1': 'score', '3': 3, '4': 1, '5': 5, '10': 'score'},
    {
      '1': 'weights',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AcuityWeights',
      '10': 'weights'
    },
  ],
};

/// Descriptor for `PatientAcuity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List patientAcuityDescriptor = $convert.base64Decode(
    'Cg1QYXRpZW50QWN1aXR5Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBI7CgZpbnB1dH'
    'MYAiABKAsyIy5oZWFsdGhjYXJlLm51cnNpbmcudjEuQWN1aXR5SW5wdXRzUgZpbnB1dHMSFAoF'
    'c2NvcmUYAyABKAVSBXNjb3JlEj4KB3dlaWdodHMYBCABKAsyJC5oZWFsdGhjYXJlLm51cnNpbm'
    'cudjEuQWN1aXR5V2VpZ2h0c1IHd2VpZ2h0cw==');

@$core.Deprecated('Use unitAcuityDescriptor instead')
const UnitAcuity$json = {
  '1': 'UnitAcuity',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'as_of',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'asOf'
    },
    {
      '1': 'patients',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.PatientAcuity',
      '10': 'patients'
    },
    {'1': 'nurses_on_duty', '3': 4, '4': 1, '5': 5, '10': 'nursesOnDuty'},
    {'1': 'total', '3': 5, '4': 1, '5': 5, '10': 'total'},
    {'1': 'per_nurse', '3': 6, '4': 1, '5': 1, '10': 'perNurse'},
    {
      '1': 'per_nurse_available',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'perNurseAvailable'
    },
  ],
};

/// Descriptor for `UnitAcuity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unitAcuityDescriptor = $convert.base64Decode(
    'CgpVbml0QWN1aXR5EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIvCgVhc19vZhgCIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBGFzT2YSQAoIcGF0aWVudHMYAyADKAsyJC5oZWFs'
    'dGhjYXJlLm51cnNpbmcudjEuUGF0aWVudEFjdWl0eVIIcGF0aWVudHMSJAoObnVyc2VzX29uX2'
    'R1dHkYBCABKAVSDG51cnNlc09uRHV0eRIUCgV0b3RhbBgFIAEoBVIFdG90YWwSGwoJcGVyX251'
    'cnNlGAYgASgBUghwZXJOdXJzZRIuChNwZXJfbnVyc2VfYXZhaWxhYmxlGAcgASgIUhFwZXJOdX'
    'JzZUF2YWlsYWJsZQ==');

@$core.Deprecated('Use acuityPatientInputDescriptor instead')
const AcuityPatientInput$json = {
  '1': 'AcuityPatientInput',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'dependency_score', '3': 3, '4': 1, '5': 5, '10': 'dependencyScore'},
    {'1': 'isolation', '3': 4, '4': 1, '5': 8, '10': 'isolation'},
  ],
};

/// Descriptor for `AcuityPatientInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acuityPatientInputDescriptor = $convert.base64Decode(
    'ChJBY3VpdHlQYXRpZW50SW5wdXQSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEiEKDG'
    'VuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSKQoQZGVwZW5kZW5jeV9zY29yZRgDIAEo'
    'BVIPZGVwZW5kZW5jeVNjb3JlEhwKCWlzb2xhdGlvbhgEIAEoCFIJaXNvbGF0aW9u');

@$core.Deprecated('Use getUnitAcuityRequestDescriptor instead')
const GetUnitAcuityRequest$json = {
  '1': 'GetUnitAcuityRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'patients',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.AcuityPatientInput',
      '10': 'patients'
    },
  ],
};

/// Descriptor for `GetUnitAcuityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitAcuityRequestDescriptor = $convert.base64Decode(
    'ChRHZXRVbml0QWN1aXR5UmVxdWVzdBIXCgd1bml0X2lkGAEgASgJUgZ1bml0SWQSRQoIcGF0aW'
    'VudHMYAiADKAsyKS5oZWFsdGhjYXJlLm51cnNpbmcudjEuQWN1aXR5UGF0aWVudElucHV0Ughw'
    'YXRpZW50cw==');

@$core.Deprecated('Use getUnitAcuityResponseDescriptor instead')
const GetUnitAcuityResponse$json = {
  '1': 'GetUnitAcuityResponse',
  '2': [
    {
      '1': 'acuity',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.UnitAcuity',
      '10': 'acuity'
    },
  ],
};

/// Descriptor for `GetUnitAcuityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUnitAcuityResponseDescriptor = $convert.base64Decode(
    'ChVHZXRVbml0QWN1aXR5UmVzcG9uc2USOQoGYWN1aXR5GAEgASgLMiEuaGVhbHRoY2FyZS5udX'
    'JzaW5nLnYxLlVuaXRBY3VpdHlSBmFjdWl0eQ==');

@$core.Deprecated('Use setAcuityWeightsRequestDescriptor instead')
const SetAcuityWeightsRequest$json = {
  '1': 'SetAcuityWeightsRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'weights',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.AcuityWeights',
      '10': 'weights'
    },
  ],
};

/// Descriptor for `SetAcuityWeightsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAcuityWeightsRequestDescriptor = $convert.base64Decode(
    'ChdTZXRBY3VpdHlXZWlnaHRzUmVxdWVzdBIXCgd1bml0X2lkGAEgASgJUgZ1bml0SWQSPgoHd2'
    'VpZ2h0cxgCIAEoCzIkLmhlYWx0aGNhcmUubnVyc2luZy52MS5BY3VpdHlXZWlnaHRzUgd3ZWln'
    'aHRz');

@$core.Deprecated('Use setAcuityWeightsResponseDescriptor instead')
const SetAcuityWeightsResponse$json = {
  '1': 'SetAcuityWeightsResponse',
};

/// Descriptor for `SetAcuityWeightsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setAcuityWeightsResponseDescriptor =
    $convert.base64Decode('ChhTZXRBY3VpdHlXZWlnaHRzUmVzcG9uc2U=');

@$core.Deprecated('Use downtimeEpisodeDescriptor instead')
const DowntimeEpisode$json = {
  '1': 'DowntimeEpisode',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'started_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'started_by', '3': 5, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'ended_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'ended_by', '3': 7, '4': 1, '5': 9, '10': 'endedBy'},
    {
      '1': 'reconciled_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reconciledAt'
    },
    {'1': 'reconciled_by', '3': 9, '4': 1, '5': 9, '10': 'reconciledBy'},
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `DowntimeEpisode`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downtimeEpisodeDescriptor = $convert.base64Decode(
    'Cg9Eb3dudGltZUVwaXNvZGUSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEhcKB3VuaX'
    'RfaWQYAiABKAlSBnVuaXRJZBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhI5CgpzdGFydGVkX2F0'
    'GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJc3RhcnRlZEF0Eh0KCnN0YXJ0ZW'
    'RfYnkYBSABKAlSCXN0YXJ0ZWRCeRI1CghlbmRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSB2VuZGVkQXQSGQoIZW5kZWRfYnkYByABKAlSB2VuZGVkQnkSPwoNcmVjb2'
    '5jaWxlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDHJlY29uY2lsZWRB'
    'dBIjCg1yZWNvbmNpbGVkX2J5GAkgASgJUgxyZWNvbmNpbGVkQnkSGAoHdmVyc2lvbhgKIAEoA1'
    'IHdmVyc2lvbg==');

@$core.Deprecated('Use declareDowntimeRequestDescriptor instead')
const DeclareDowntimeRequest$json = {
  '1': 'DeclareDowntimeRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'started_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
  ],
};

/// Descriptor for `DeclareDowntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declareDowntimeRequestDescriptor = $convert.base64Decode(
    'ChZEZWNsYXJlRG93bnRpbWVSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIWCgZyZW'
    'Fzb24YAiABKAlSBnJlYXNvbhI5CgpzdGFydGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIJc3RhcnRlZEF0');

@$core.Deprecated('Use declareDowntimeResponseDescriptor instead')
const DeclareDowntimeResponse$json = {
  '1': 'DeclareDowntimeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.DowntimeEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `DeclareDowntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declareDowntimeResponseDescriptor =
    $convert.base64Decode(
        'ChdEZWNsYXJlRG93bnRpbWVSZXNwb25zZRJACgdlcGlzb2RlGAEgASgLMiYuaGVhbHRoY2FyZS'
        '5udXJzaW5nLnYxLkRvd250aW1lRXBpc29kZVIHZXBpc29kZQ==');

@$core.Deprecated('Use endDowntimeRequestDescriptor instead')
const EndDowntimeRequest$json = {
  '1': 'EndDowntimeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
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

/// Descriptor for `EndDowntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endDowntimeRequestDescriptor = $convert.base64Decode(
    'ChJFbmREb3dudGltZVJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZUlkEjUKCG'
    'VuZGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHZW5kZWRBdA==');

@$core.Deprecated('Use endDowntimeResponseDescriptor instead')
const EndDowntimeResponse$json = {
  '1': 'EndDowntimeResponse',
  '2': [
    {
      '1': 'episode',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.nursing.v1.DowntimeEpisode',
      '10': 'episode'
    },
  ],
};

/// Descriptor for `EndDowntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List endDowntimeResponseDescriptor = $convert.base64Decode(
    'ChNFbmREb3dudGltZVJlc3BvbnNlEkAKB2VwaXNvZGUYASABKAsyJi5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuRG93bnRpbWVFcGlzb2RlUgdlcGlzb2Rl');

@$core.Deprecated('Use reconcileDowntimeRequestDescriptor instead')
const ReconcileDowntimeRequest$json = {
  '1': 'ReconcileDowntimeRequest',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
  ],
};

/// Descriptor for `ReconcileDowntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileDowntimeRequestDescriptor =
    $convert.base64Decode(
        'ChhSZWNvbmNpbGVEb3dudGltZVJlcXVlc3QSHQoKZXBpc29kZV9pZBgBIAEoCVIJZXBpc29kZU'
        'lk');

@$core.Deprecated('Use reconcileDowntimeResponseDescriptor instead')
const ReconcileDowntimeResponse$json = {
  '1': 'ReconcileDowntimeResponse',
  '2': [
    {'1': 'episode_id', '3': 1, '4': 1, '5': 9, '10': 'episodeId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'run_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'runAt'
    },
  ],
};

/// Descriptor for `ReconcileDowntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileDowntimeResponseDescriptor = $convert.base64Decode(
    'ChlSZWNvbmNpbGVEb3dudGltZVJlc3BvbnNlEh0KCmVwaXNvZGVfaWQYASABKAlSCWVwaXNvZG'
    'VJZBIXCgd1bml0X2lkGAIgASgJUgZ1bml0SWQSMQoGcnVuX2F0GAMgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIFcnVuQXQ=');

@$core.Deprecated('Use listDowntimeRequestDescriptor instead')
const ListDowntimeRequest$json = {
  '1': 'ListDowntimeRequest',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {
      '1': 'unreconciled_only',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'unreconciledOnly'
    },
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListDowntimeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDowntimeRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0RG93bnRpbWVSZXF1ZXN0EhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBIrChF1bnJlY2'
    '9uY2lsZWRfb25seRgCIAEoCFIQdW5yZWNvbmNpbGVkT25seRIbCglwYWdlX3NpemUYAyABKAVS'
    'CHBhZ2VTaXpl');

@$core.Deprecated('Use listDowntimeResponseDescriptor instead')
const ListDowntimeResponse$json = {
  '1': 'ListDowntimeResponse',
  '2': [
    {
      '1': 'episodes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.DowntimeEpisode',
      '10': 'episodes'
    },
  ],
};

/// Descriptor for `ListDowntimeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDowntimeResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0RG93bnRpbWVSZXNwb25zZRJCCghlcGlzb2RlcxgBIAMoCzImLmhlYWx0aGNhcmUubn'
    'Vyc2luZy52MS5Eb3dudGltZUVwaXNvZGVSCGVwaXNvZGVz');

@$core.Deprecated('Use suspectedDuplicateDescriptor instead')
const SuspectedDuplicate$json = {
  '1': 'SuspectedDuplicate',
  '2': [
    {'1': 'first_id', '3': 1, '4': 1, '5': 9, '10': 'firstId'},
    {'1': 'second_id', '3': 2, '4': 1, '5': 9, '10': 'secondId'},
    {'1': 'order_id', '3': 3, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'apart_seconds', '3': 4, '4': 1, '5': 3, '10': 'apartSeconds'},
  ],
};

/// Descriptor for `SuspectedDuplicate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List suspectedDuplicateDescriptor = $convert.base64Decode(
    'ChJTdXNwZWN0ZWREdXBsaWNhdGUSGQoIZmlyc3RfaWQYASABKAlSB2ZpcnN0SWQSGwoJc2Vjb2'
    '5kX2lkGAIgASgJUghzZWNvbmRJZBIZCghvcmRlcl9pZBgDIAEoCVIHb3JkZXJJZBIjCg1hcGFy'
    'dF9zZWNvbmRzGAQgASgDUgxhcGFydFNlY29uZHM=');

@$core.Deprecated('Use getSuspectedDuplicatesRequestDescriptor instead')
const GetSuspectedDuplicatesRequest$json = {
  '1': 'GetSuspectedDuplicatesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `GetSuspectedDuplicatesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSuspectedDuplicatesRequestDescriptor =
    $convert.base64Decode(
        'Ch1HZXRTdXNwZWN0ZWREdXBsaWNhdGVzUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2'
        'VuY291bnRlcklkEh0KCnBhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZA==');

@$core.Deprecated('Use getSuspectedDuplicatesResponseDescriptor instead')
const GetSuspectedDuplicatesResponse$json = {
  '1': 'GetSuspectedDuplicatesResponse',
  '2': [
    {
      '1': 'duplicates',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.nursing.v1.SuspectedDuplicate',
      '10': 'duplicates'
    },
  ],
};

/// Descriptor for `GetSuspectedDuplicatesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSuspectedDuplicatesResponseDescriptor =
    $convert.base64Decode(
        'Ch5HZXRTdXNwZWN0ZWREdXBsaWNhdGVzUmVzcG9uc2USSQoKZHVwbGljYXRlcxgBIAMoCzIpLm'
        'hlYWx0aGNhcmUubnVyc2luZy52MS5TdXNwZWN0ZWREdXBsaWNhdGVSCmR1cGxpY2F0ZXM=');

const $core.Map<$core.String, $core.dynamic> NursingServiceBase$json = {
  '1': 'NursingService',
  '2': [
    {
      '1': 'ChartObservation',
      '2': '.healthcare.nursing.v1.ChartObservationRequest',
      '3': '.healthcare.nursing.v1.ChartObservationResponse'
    },
    {
      '1': 'GetFlowsheet',
      '2': '.healthcare.nursing.v1.GetFlowsheetRequest',
      '3': '.healthcare.nursing.v1.GetFlowsheetResponse'
    },
    {
      '1': 'RecordFluid',
      '2': '.healthcare.nursing.v1.RecordFluidRequest',
      '3': '.healthcare.nursing.v1.RecordFluidResponse'
    },
    {
      '1': 'CorrectFluid',
      '2': '.healthcare.nursing.v1.CorrectFluidRequest',
      '3': '.healthcare.nursing.v1.CorrectFluidResponse'
    },
    {
      '1': 'GetFluidBalance',
      '2': '.healthcare.nursing.v1.GetFluidBalanceRequest',
      '3': '.healthcare.nursing.v1.GetFluidBalanceResponse'
    },
    {
      '1': 'GetFluidTrail',
      '2': '.healthcare.nursing.v1.GetFluidTrailRequest',
      '3': '.healthcare.nursing.v1.GetFluidTrailResponse'
    },
    {
      '1': 'DefineAssessmentTemplate',
      '2': '.healthcare.nursing.v1.DefineAssessmentTemplateRequest',
      '3': '.healthcare.nursing.v1.DefineAssessmentTemplateResponse'
    },
    {
      '1': 'ListAssessmentTemplates',
      '2': '.healthcare.nursing.v1.ListAssessmentTemplatesRequest',
      '3': '.healthcare.nursing.v1.ListAssessmentTemplatesResponse'
    },
    {
      '1': 'RetireAssessmentTemplate',
      '2': '.healthcare.nursing.v1.RetireAssessmentTemplateRequest',
      '3': '.healthcare.nursing.v1.RetireAssessmentTemplateResponse'
    },
    {
      '1': 'RecordAssessment',
      '2': '.healthcare.nursing.v1.RecordAssessmentRequest',
      '3': '.healthcare.nursing.v1.RecordAssessmentResponse'
    },
    {
      '1': 'ListAssessments',
      '2': '.healthcare.nursing.v1.ListAssessmentsRequest',
      '3': '.healthcare.nursing.v1.ListAssessmentsResponse'
    },
    {
      '1': 'DefineRiskScale',
      '2': '.healthcare.nursing.v1.DefineRiskScaleRequest',
      '3': '.healthcare.nursing.v1.DefineRiskScaleResponse'
    },
    {
      '1': 'ScoreRisk',
      '2': '.healthcare.nursing.v1.ScoreRiskRequest',
      '3': '.healthcare.nursing.v1.ScoreRiskResponse'
    },
    {
      '1': 'ListRiskAssessments',
      '2': '.healthcare.nursing.v1.ListRiskAssessmentsRequest',
      '3': '.healthcare.nursing.v1.ListRiskAssessmentsResponse'
    },
    {
      '1': 'ListDueReassessments',
      '2': '.healthcare.nursing.v1.ListDueReassessmentsRequest',
      '3': '.healthcare.nursing.v1.ListDueReassessmentsResponse'
    },
    {
      '1': 'InsertDevice',
      '2': '.healthcare.nursing.v1.InsertDeviceRequest',
      '3': '.healthcare.nursing.v1.InsertDeviceResponse'
    },
    {
      '1': 'RemoveDevice',
      '2': '.healthcare.nursing.v1.RemoveDeviceRequest',
      '3': '.healthcare.nursing.v1.RemoveDeviceResponse'
    },
    {
      '1': 'RecordDeviceCare',
      '2': '.healthcare.nursing.v1.RecordDeviceCareRequest',
      '3': '.healthcare.nursing.v1.RecordDeviceCareResponse'
    },
    {
      '1': 'ListDevices',
      '2': '.healthcare.nursing.v1.ListDevicesRequest',
      '3': '.healthcare.nursing.v1.ListDevicesResponse'
    },
    {
      '1': 'GetMedicationRound',
      '2': '.healthcare.nursing.v1.GetMedicationRoundRequest',
      '3': '.healthcare.nursing.v1.GetMedicationRoundResponse'
    },
    {
      '1': 'Administer',
      '2': '.healthcare.nursing.v1.AdministerRequest',
      '3': '.healthcare.nursing.v1.AdministerResponse'
    },
    {
      '1': 'ListAdministrations',
      '2': '.healthcare.nursing.v1.ListAdministrationsRequest',
      '3': '.healthcare.nursing.v1.ListAdministrationsResponse'
    },
    {
      '1': 'GetOverrideReport',
      '2': '.healthcare.nursing.v1.GetOverrideReportRequest',
      '3': '.healthcare.nursing.v1.GetOverrideReportResponse'
    },
    {
      '1': 'SetAdministrationPolicy',
      '2': '.healthcare.nursing.v1.SetAdministrationPolicyRequest',
      '3': '.healthcare.nursing.v1.SetAdministrationPolicyResponse'
    },
    {
      '1': 'CreateCarePlan',
      '2': '.healthcare.nursing.v1.CreateCarePlanRequest',
      '3': '.healthcare.nursing.v1.CreateCarePlanResponse'
    },
    {
      '1': 'ReviewCarePlan',
      '2': '.healthcare.nursing.v1.ReviewCarePlanRequest',
      '3': '.healthcare.nursing.v1.ReviewCarePlanResponse'
    },
    {
      '1': 'ListCarePlans',
      '2': '.healthcare.nursing.v1.ListCarePlansRequest',
      '3': '.healthcare.nursing.v1.ListCarePlansResponse'
    },
    {
      '1': 'CreateTask',
      '2': '.healthcare.nursing.v1.CreateTaskRequest',
      '3': '.healthcare.nursing.v1.CreateTaskResponse'
    },
    {
      '1': 'CompleteTask',
      '2': '.healthcare.nursing.v1.CompleteTaskRequest',
      '3': '.healthcare.nursing.v1.CompleteTaskResponse'
    },
    {
      '1': 'SkipTask',
      '2': '.healthcare.nursing.v1.SkipTaskRequest',
      '3': '.healthcare.nursing.v1.SkipTaskResponse'
    },
    {
      '1': 'GetWorklist',
      '2': '.healthcare.nursing.v1.GetWorklistRequest',
      '3': '.healthcare.nursing.v1.GetWorklistResponse'
    },
    {
      '1': 'EscalateOverdueWork',
      '2': '.healthcare.nursing.v1.EscalateOverdueWorkRequest',
      '3': '.healthcare.nursing.v1.EscalateOverdueWorkResponse'
    },
    {
      '1': 'ComposeHandover',
      '2': '.healthcare.nursing.v1.ComposeHandoverRequest',
      '3': '.healthcare.nursing.v1.ComposeHandoverResponse'
    },
    {
      '1': 'AcknowledgeHandover',
      '2': '.healthcare.nursing.v1.AcknowledgeHandoverRequest',
      '3': '.healthcare.nursing.v1.AcknowledgeHandoverResponse'
    },
    {
      '1': 'ListHandovers',
      '2': '.healthcare.nursing.v1.ListHandoversRequest',
      '3': '.healthcare.nursing.v1.ListHandoversResponse'
    },
    {
      '1': 'ApplyRestraint',
      '2': '.healthcare.nursing.v1.ApplyRestraintRequest',
      '3': '.healthcare.nursing.v1.ApplyRestraintResponse'
    },
    {
      '1': 'RenewRestraint',
      '2': '.healthcare.nursing.v1.RenewRestraintRequest',
      '3': '.healthcare.nursing.v1.RenewRestraintResponse'
    },
    {
      '1': 'CheckRestraint',
      '2': '.healthcare.nursing.v1.CheckRestraintRequest',
      '3': '.healthcare.nursing.v1.CheckRestraintResponse'
    },
    {
      '1': 'DiscontinueRestraint',
      '2': '.healthcare.nursing.v1.DiscontinueRestraintRequest',
      '3': '.healthcare.nursing.v1.DiscontinueRestraintResponse'
    },
    {
      '1': 'ListRestraints',
      '2': '.healthcare.nursing.v1.ListRestraintsRequest',
      '3': '.healthcare.nursing.v1.ListRestraintsResponse'
    },
    {
      '1': 'GetRestraintAlerts',
      '2': '.healthcare.nursing.v1.GetRestraintAlertsRequest',
      '3': '.healthcare.nursing.v1.GetRestraintAlertsResponse'
    },
    {
      '1': 'StartTransfusion',
      '2': '.healthcare.nursing.v1.StartTransfusionRequest',
      '3': '.healthcare.nursing.v1.StartTransfusionResponse',
      '4': {'33': true},
    },
    {
      '1': 'ObserveTransfusion',
      '2': '.healthcare.nursing.v1.ObserveTransfusionRequest',
      '3': '.healthcare.nursing.v1.ObserveTransfusionResponse',
      '4': {'33': true},
    },
    {
      '1': 'ReportTransfusionReaction',
      '2': '.healthcare.nursing.v1.ReportTransfusionReactionRequest',
      '3': '.healthcare.nursing.v1.ReportTransfusionReactionResponse',
      '4': {'33': true},
    },
    {
      '1': 'CompleteTransfusion',
      '2': '.healthcare.nursing.v1.CompleteTransfusionRequest',
      '3': '.healthcare.nursing.v1.CompleteTransfusionResponse',
      '4': {'33': true},
    },
    {
      '1': 'AssessWound',
      '2': '.healthcare.nursing.v1.AssessWoundRequest',
      '3': '.healthcare.nursing.v1.AssessWoundResponse'
    },
    {
      '1': 'AttachWoundImage',
      '2': '.healthcare.nursing.v1.AttachWoundImageRequest',
      '3': '.healthcare.nursing.v1.AttachWoundImageResponse'
    },
    {
      '1': 'GetWoundHistory',
      '2': '.healthcare.nursing.v1.GetWoundHistoryRequest',
      '3': '.healthcare.nursing.v1.GetWoundHistoryResponse'
    },
    {
      '1': 'RecordEducation',
      '2': '.healthcare.nursing.v1.RecordEducationRequest',
      '3': '.healthcare.nursing.v1.RecordEducationResponse'
    },
    {
      '1': 'GetDischargeReadiness',
      '2': '.healthcare.nursing.v1.GetDischargeReadinessRequest',
      '3': '.healthcare.nursing.v1.GetDischargeReadinessResponse'
    },
    {
      '1': 'AssignNurse',
      '2': '.healthcare.nursing.v1.AssignNurseRequest',
      '3': '.healthcare.nursing.v1.AssignNurseResponse'
    },
    {
      '1': 'EndAssignment',
      '2': '.healthcare.nursing.v1.EndAssignmentRequest',
      '3': '.healthcare.nursing.v1.EndAssignmentResponse'
    },
    {
      '1': 'ListAssignments',
      '2': '.healthcare.nursing.v1.ListAssignmentsRequest',
      '3': '.healthcare.nursing.v1.ListAssignmentsResponse'
    },
    {
      '1': 'GetUnitAcuity',
      '2': '.healthcare.nursing.v1.GetUnitAcuityRequest',
      '3': '.healthcare.nursing.v1.GetUnitAcuityResponse'
    },
    {
      '1': 'SetAcuityWeights',
      '2': '.healthcare.nursing.v1.SetAcuityWeightsRequest',
      '3': '.healthcare.nursing.v1.SetAcuityWeightsResponse'
    },
    {
      '1': 'DeclareDowntime',
      '2': '.healthcare.nursing.v1.DeclareDowntimeRequest',
      '3': '.healthcare.nursing.v1.DeclareDowntimeResponse'
    },
    {
      '1': 'EndDowntime',
      '2': '.healthcare.nursing.v1.EndDowntimeRequest',
      '3': '.healthcare.nursing.v1.EndDowntimeResponse'
    },
    {
      '1': 'ReconcileDowntime',
      '2': '.healthcare.nursing.v1.ReconcileDowntimeRequest',
      '3': '.healthcare.nursing.v1.ReconcileDowntimeResponse'
    },
    {
      '1': 'ListDowntime',
      '2': '.healthcare.nursing.v1.ListDowntimeRequest',
      '3': '.healthcare.nursing.v1.ListDowntimeResponse'
    },
    {
      '1': 'GetSuspectedDuplicates',
      '2': '.healthcare.nursing.v1.GetSuspectedDuplicatesRequest',
      '3': '.healthcare.nursing.v1.GetSuspectedDuplicatesResponse'
    },
  ],
};

@$core.Deprecated('Use nursingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    NursingServiceBase$messageJson = {
  '.healthcare.nursing.v1.ChartObservationRequest':
      ChartObservationRequest$json,
  '.healthcare.nursing.v1.Coding': Coding$json,
  '.healthcare.nursing.v1.Quantity': Quantity$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.nursing.v1.ChartObservationResponse':
      ChartObservationResponse$json,
  '.healthcare.nursing.v1.FlowsheetEntry': FlowsheetEntry$json,
  '.healthcare.nursing.v1.GetFlowsheetRequest': GetFlowsheetRequest$json,
  '.healthcare.nursing.v1.GetFlowsheetResponse': GetFlowsheetResponse$json,
  '.healthcare.nursing.v1.RecordFluidRequest': RecordFluidRequest$json,
  '.healthcare.nursing.v1.RecordFluidResponse': RecordFluidResponse$json,
  '.healthcare.nursing.v1.FluidEntry': FluidEntry$json,
  '.healthcare.nursing.v1.CorrectFluidRequest': CorrectFluidRequest$json,
  '.healthcare.nursing.v1.CorrectFluidResponse': CorrectFluidResponse$json,
  '.healthcare.nursing.v1.GetFluidBalanceRequest': GetFluidBalanceRequest$json,
  '.healthcare.nursing.v1.GetFluidBalanceResponse':
      GetFluidBalanceResponse$json,
  '.healthcare.nursing.v1.FluidBalance': FluidBalance$json,
  '.healthcare.nursing.v1.FluidBalance.ByCategoryEntry':
      FluidBalance_ByCategoryEntry$json,
  '.healthcare.nursing.v1.GetFluidTrailRequest': GetFluidTrailRequest$json,
  '.healthcare.nursing.v1.GetFluidTrailResponse': GetFluidTrailResponse$json,
  '.healthcare.nursing.v1.DefineAssessmentTemplateRequest':
      DefineAssessmentTemplateRequest$json,
  '.healthcare.nursing.v1.AssessmentTemplate': AssessmentTemplate$json,
  '.healthcare.nursing.v1.TemplateSection': TemplateSection$json,
  '.healthcare.nursing.v1.DefineAssessmentTemplateResponse':
      DefineAssessmentTemplateResponse$json,
  '.healthcare.nursing.v1.ListAssessmentTemplatesRequest':
      ListAssessmentTemplatesRequest$json,
  '.healthcare.nursing.v1.ListAssessmentTemplatesResponse':
      ListAssessmentTemplatesResponse$json,
  '.healthcare.nursing.v1.RetireAssessmentTemplateRequest':
      RetireAssessmentTemplateRequest$json,
  '.healthcare.nursing.v1.RetireAssessmentTemplateResponse':
      RetireAssessmentTemplateResponse$json,
  '.healthcare.nursing.v1.RecordAssessmentRequest':
      RecordAssessmentRequest$json,
  '.healthcare.nursing.v1.Answer': Answer$json,
  '.healthcare.nursing.v1.RecordAssessmentResponse':
      RecordAssessmentResponse$json,
  '.healthcare.nursing.v1.Assessment': Assessment$json,
  '.healthcare.nursing.v1.ListAssessmentsRequest': ListAssessmentsRequest$json,
  '.healthcare.nursing.v1.ListAssessmentsResponse':
      ListAssessmentsResponse$json,
  '.healthcare.nursing.v1.DefineRiskScaleRequest': DefineRiskScaleRequest$json,
  '.healthcare.nursing.v1.RiskScale': RiskScale$json,
  '.healthcare.nursing.v1.RiskInput': RiskInput$json,
  '.healthcare.nursing.v1.RiskBand': RiskBand$json,
  '.healthcare.nursing.v1.DefineRiskScaleResponse':
      DefineRiskScaleResponse$json,
  '.healthcare.nursing.v1.ScoreRiskRequest': ScoreRiskRequest$json,
  '.healthcare.nursing.v1.ScoreRiskRequest.InputsEntry':
      ScoreRiskRequest_InputsEntry$json,
  '.healthcare.nursing.v1.ScoreRiskResponse': ScoreRiskResponse$json,
  '.healthcare.nursing.v1.RiskAssessment': RiskAssessment$json,
  '.healthcare.nursing.v1.RiskAssessment.InputsEntry':
      RiskAssessment_InputsEntry$json,
  '.healthcare.nursing.v1.ListRiskAssessmentsRequest':
      ListRiskAssessmentsRequest$json,
  '.healthcare.nursing.v1.ListRiskAssessmentsResponse':
      ListRiskAssessmentsResponse$json,
  '.healthcare.nursing.v1.ListDueReassessmentsRequest':
      ListDueReassessmentsRequest$json,
  '.healthcare.nursing.v1.ListDueReassessmentsResponse':
      ListDueReassessmentsResponse$json,
  '.healthcare.nursing.v1.InsertDeviceRequest': InsertDeviceRequest$json,
  '.healthcare.nursing.v1.InsertDeviceResponse': InsertDeviceResponse$json,
  '.healthcare.nursing.v1.Device': Device$json,
  '.healthcare.nursing.v1.DeviceCare': DeviceCare$json,
  '.healthcare.nursing.v1.RemoveDeviceRequest': RemoveDeviceRequest$json,
  '.healthcare.nursing.v1.RemoveDeviceResponse': RemoveDeviceResponse$json,
  '.healthcare.nursing.v1.RecordDeviceCareRequest':
      RecordDeviceCareRequest$json,
  '.healthcare.nursing.v1.RecordDeviceCareResponse':
      RecordDeviceCareResponse$json,
  '.healthcare.nursing.v1.ListDevicesRequest': ListDevicesRequest$json,
  '.healthcare.nursing.v1.ListDevicesResponse': ListDevicesResponse$json,
  '.healthcare.nursing.v1.GetMedicationRoundRequest':
      GetMedicationRoundRequest$json,
  '.healthcare.nursing.v1.GetMedicationRoundResponse':
      GetMedicationRoundResponse$json,
  '.healthcare.nursing.v1.DueDose': DueDose$json,
  '.healthcare.nursing.v1.MedicationOrder': MedicationOrder$json,
  '.healthcare.nursing.v1.Administration': Administration$json,
  '.healthcare.nursing.v1.Verification': Verification$json,
  '.healthcare.nursing.v1.Override': Override$json,
  '.healthcare.nursing.v1.AdministrationPolicy': AdministrationPolicy$json,
  '.healthcare.nursing.v1.AdministerRequest': AdministerRequest$json,
  '.healthcare.nursing.v1.AdministerResponse': AdministerResponse$json,
  '.healthcare.nursing.v1.ListAdministrationsRequest':
      ListAdministrationsRequest$json,
  '.healthcare.nursing.v1.ListAdministrationsResponse':
      ListAdministrationsResponse$json,
  '.healthcare.nursing.v1.GetOverrideReportRequest':
      GetOverrideReportRequest$json,
  '.healthcare.nursing.v1.GetOverrideReportResponse':
      GetOverrideReportResponse$json,
  '.healthcare.nursing.v1.SetAdministrationPolicyRequest':
      SetAdministrationPolicyRequest$json,
  '.healthcare.nursing.v1.SetAdministrationPolicyResponse':
      SetAdministrationPolicyResponse$json,
  '.healthcare.nursing.v1.CreateCarePlanRequest': CreateCarePlanRequest$json,
  '.healthcare.nursing.v1.PlanProblem': PlanProblem$json,
  '.healthcare.nursing.v1.PlanGoal': PlanGoal$json,
  '.healthcare.nursing.v1.Intervention': Intervention$json,
  '.healthcare.nursing.v1.CreateCarePlanResponse': CreateCarePlanResponse$json,
  '.healthcare.nursing.v1.CarePlan': CarePlan$json,
  '.healthcare.nursing.v1.ReviewCarePlanRequest': ReviewCarePlanRequest$json,
  '.healthcare.nursing.v1.ReviewCarePlanResponse': ReviewCarePlanResponse$json,
  '.healthcare.nursing.v1.ListCarePlansRequest': ListCarePlansRequest$json,
  '.healthcare.nursing.v1.ListCarePlansResponse': ListCarePlansResponse$json,
  '.healthcare.nursing.v1.CreateTaskRequest': CreateTaskRequest$json,
  '.healthcare.nursing.v1.CreateTaskResponse': CreateTaskResponse$json,
  '.healthcare.nursing.v1.NursingTask': NursingTask$json,
  '.healthcare.nursing.v1.CompleteTaskRequest': CompleteTaskRequest$json,
  '.healthcare.nursing.v1.CompleteTaskResponse': CompleteTaskResponse$json,
  '.healthcare.nursing.v1.SkipTaskRequest': SkipTaskRequest$json,
  '.healthcare.nursing.v1.SkipTaskResponse': SkipTaskResponse$json,
  '.healthcare.nursing.v1.GetWorklistRequest': GetWorklistRequest$json,
  '.healthcare.nursing.v1.GetWorklistResponse': GetWorklistResponse$json,
  '.healthcare.nursing.v1.EscalateOverdueWorkRequest':
      EscalateOverdueWorkRequest$json,
  '.healthcare.nursing.v1.EscalateOverdueWorkResponse':
      EscalateOverdueWorkResponse$json,
  '.healthcare.nursing.v1.ComposeHandoverRequest': ComposeHandoverRequest$json,
  '.healthcare.nursing.v1.Shift': Shift$json,
  '.healthcare.nursing.v1.ComposeHandoverResponse':
      ComposeHandoverResponse$json,
  '.healthcare.nursing.v1.Handover': Handover$json,
  '.healthcare.nursing.v1.HandoverDevice': HandoverDevice$json,
  '.healthcare.nursing.v1.HandoverTask': HandoverTask$json,
  '.healthcare.nursing.v1.AcknowledgeHandoverRequest':
      AcknowledgeHandoverRequest$json,
  '.healthcare.nursing.v1.AcknowledgeHandoverResponse':
      AcknowledgeHandoverResponse$json,
  '.healthcare.nursing.v1.ListHandoversRequest': ListHandoversRequest$json,
  '.healthcare.nursing.v1.ListHandoversResponse': ListHandoversResponse$json,
  '.healthcare.nursing.v1.ApplyRestraintRequest': ApplyRestraintRequest$json,
  '.healthcare.nursing.v1.RestraintAuthorization': RestraintAuthorization$json,
  '.healthcare.nursing.v1.ApplyRestraintResponse': ApplyRestraintResponse$json,
  '.healthcare.nursing.v1.Restraint': Restraint$json,
  '.healthcare.nursing.v1.RestraintCheck': RestraintCheck$json,
  '.healthcare.nursing.v1.RenewRestraintRequest': RenewRestraintRequest$json,
  '.healthcare.nursing.v1.RenewRestraintResponse': RenewRestraintResponse$json,
  '.healthcare.nursing.v1.CheckRestraintRequest': CheckRestraintRequest$json,
  '.healthcare.nursing.v1.CheckRestraintResponse': CheckRestraintResponse$json,
  '.healthcare.nursing.v1.DiscontinueRestraintRequest':
      DiscontinueRestraintRequest$json,
  '.healthcare.nursing.v1.DiscontinueRestraintResponse':
      DiscontinueRestraintResponse$json,
  '.healthcare.nursing.v1.ListRestraintsRequest': ListRestraintsRequest$json,
  '.healthcare.nursing.v1.ListRestraintsResponse': ListRestraintsResponse$json,
  '.healthcare.nursing.v1.GetRestraintAlertsRequest':
      GetRestraintAlertsRequest$json,
  '.healthcare.nursing.v1.GetRestraintAlertsResponse':
      GetRestraintAlertsResponse$json,
  '.healthcare.nursing.v1.StartTransfusionRequest':
      StartTransfusionRequest$json,
  '.healthcare.nursing.v1.TransfusionObservation': TransfusionObservation$json,
  '.healthcare.nursing.v1.StartTransfusionResponse':
      StartTransfusionResponse$json,
  '.healthcare.nursing.v1.Transfusion': Transfusion$json,
  '.healthcare.nursing.v1.TransfusionReaction': TransfusionReaction$json,
  '.healthcare.nursing.v1.ObserveTransfusionRequest':
      ObserveTransfusionRequest$json,
  '.healthcare.nursing.v1.ObserveTransfusionResponse':
      ObserveTransfusionResponse$json,
  '.healthcare.nursing.v1.ReportTransfusionReactionRequest':
      ReportTransfusionReactionRequest$json,
  '.healthcare.nursing.v1.ReportTransfusionReactionResponse':
      ReportTransfusionReactionResponse$json,
  '.healthcare.nursing.v1.CompleteTransfusionRequest':
      CompleteTransfusionRequest$json,
  '.healthcare.nursing.v1.CompleteTransfusionResponse':
      CompleteTransfusionResponse$json,
  '.healthcare.nursing.v1.AssessWoundRequest': AssessWoundRequest$json,
  '.healthcare.nursing.v1.AssessWoundResponse': AssessWoundResponse$json,
  '.healthcare.nursing.v1.WoundAssessment': WoundAssessment$json,
  '.healthcare.nursing.v1.WoundImage': WoundImage$json,
  '.healthcare.nursing.v1.AttachWoundImageRequest':
      AttachWoundImageRequest$json,
  '.healthcare.nursing.v1.AttachWoundImageResponse':
      AttachWoundImageResponse$json,
  '.healthcare.nursing.v1.GetWoundHistoryRequest': GetWoundHistoryRequest$json,
  '.healthcare.nursing.v1.GetWoundHistoryResponse':
      GetWoundHistoryResponse$json,
  '.healthcare.nursing.v1.RecordEducationRequest': RecordEducationRequest$json,
  '.healthcare.nursing.v1.RecordEducationResponse':
      RecordEducationResponse$json,
  '.healthcare.nursing.v1.EducationRecord': EducationRecord$json,
  '.healthcare.nursing.v1.GetDischargeReadinessRequest':
      GetDischargeReadinessRequest$json,
  '.healthcare.nursing.v1.GetDischargeReadinessResponse':
      GetDischargeReadinessResponse$json,
  '.healthcare.nursing.v1.DischargeReadiness': DischargeReadiness$json,
  '.healthcare.nursing.v1.ReadinessCriterion': ReadinessCriterion$json,
  '.healthcare.nursing.v1.AssignNurseRequest': AssignNurseRequest$json,
  '.healthcare.nursing.v1.AssignNurseResponse': AssignNurseResponse$json,
  '.healthcare.nursing.v1.NurseAssignment': NurseAssignment$json,
  '.healthcare.nursing.v1.EndAssignmentRequest': EndAssignmentRequest$json,
  '.healthcare.nursing.v1.EndAssignmentResponse': EndAssignmentResponse$json,
  '.healthcare.nursing.v1.ListAssignmentsRequest': ListAssignmentsRequest$json,
  '.healthcare.nursing.v1.ListAssignmentsResponse':
      ListAssignmentsResponse$json,
  '.healthcare.nursing.v1.GetUnitAcuityRequest': GetUnitAcuityRequest$json,
  '.healthcare.nursing.v1.AcuityPatientInput': AcuityPatientInput$json,
  '.healthcare.nursing.v1.GetUnitAcuityResponse': GetUnitAcuityResponse$json,
  '.healthcare.nursing.v1.UnitAcuity': UnitAcuity$json,
  '.healthcare.nursing.v1.PatientAcuity': PatientAcuity$json,
  '.healthcare.nursing.v1.AcuityInputs': AcuityInputs$json,
  '.healthcare.nursing.v1.AcuityWeights': AcuityWeights$json,
  '.healthcare.nursing.v1.SetAcuityWeightsRequest':
      SetAcuityWeightsRequest$json,
  '.healthcare.nursing.v1.SetAcuityWeightsResponse':
      SetAcuityWeightsResponse$json,
  '.healthcare.nursing.v1.DeclareDowntimeRequest': DeclareDowntimeRequest$json,
  '.healthcare.nursing.v1.DeclareDowntimeResponse':
      DeclareDowntimeResponse$json,
  '.healthcare.nursing.v1.DowntimeEpisode': DowntimeEpisode$json,
  '.healthcare.nursing.v1.EndDowntimeRequest': EndDowntimeRequest$json,
  '.healthcare.nursing.v1.EndDowntimeResponse': EndDowntimeResponse$json,
  '.healthcare.nursing.v1.ReconcileDowntimeRequest':
      ReconcileDowntimeRequest$json,
  '.healthcare.nursing.v1.ReconcileDowntimeResponse':
      ReconcileDowntimeResponse$json,
  '.healthcare.nursing.v1.ListDowntimeRequest': ListDowntimeRequest$json,
  '.healthcare.nursing.v1.ListDowntimeResponse': ListDowntimeResponse$json,
  '.healthcare.nursing.v1.GetSuspectedDuplicatesRequest':
      GetSuspectedDuplicatesRequest$json,
  '.healthcare.nursing.v1.GetSuspectedDuplicatesResponse':
      GetSuspectedDuplicatesResponse$json,
  '.healthcare.nursing.v1.SuspectedDuplicate': SuspectedDuplicate$json,
};

/// Descriptor for `NursingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List nursingServiceDescriptor = $convert.base64Decode(
    'Cg5OdXJzaW5nU2VydmljZRJzChBDaGFydE9ic2VydmF0aW9uEi4uaGVhbHRoY2FyZS5udXJzaW'
    '5nLnYxLkNoYXJ0T2JzZXJ2YXRpb25SZXF1ZXN0Gi8uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNo'
    'YXJ0T2JzZXJ2YXRpb25SZXNwb25zZRJnCgxHZXRGbG93c2hlZXQSKi5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuR2V0Rmxvd3NoZWV0UmVxdWVzdBorLmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXRG'
    'bG93c2hlZXRSZXNwb25zZRJkCgtSZWNvcmRGbHVpZBIpLmhlYWx0aGNhcmUubnVyc2luZy52MS'
    '5SZWNvcmRGbHVpZFJlcXVlc3QaKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuUmVjb3JkRmx1aWRS'
    'ZXNwb25zZRJnCgxDb3JyZWN0Rmx1aWQSKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuQ29ycmVjdE'
    'ZsdWlkUmVxdWVzdBorLmhlYWx0aGNhcmUubnVyc2luZy52MS5Db3JyZWN0Rmx1aWRSZXNwb25z'
    'ZRJwCg9HZXRGbHVpZEJhbGFuY2USLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0Rmx1aWRCYW'
    'xhbmNlUmVxdWVzdBouLmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXRGbHVpZEJhbGFuY2VSZXNw'
    'b25zZRJqCg1HZXRGbHVpZFRyYWlsEisuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldEZsdWlkVH'
    'JhaWxSZXF1ZXN0GiwuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldEZsdWlkVHJhaWxSZXNwb25z'
    'ZRKLAQoYRGVmaW5lQXNzZXNzbWVudFRlbXBsYXRlEjYuaGVhbHRoY2FyZS5udXJzaW5nLnYxLk'
    'RlZmluZUFzc2Vzc21lbnRUZW1wbGF0ZVJlcXVlc3QaNy5oZWFsdGhjYXJlLm51cnNpbmcudjEu'
    'RGVmaW5lQXNzZXNzbWVudFRlbXBsYXRlUmVzcG9uc2USiAEKF0xpc3RBc3Nlc3NtZW50VGVtcG'
    'xhdGVzEjUuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RBc3Nlc3NtZW50VGVtcGxhdGVzUmVx'
    'dWVzdBo2LmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0QXNzZXNzbWVudFRlbXBsYXRlc1Jlc3'
    'BvbnNlEosBChhSZXRpcmVBc3Nlc3NtZW50VGVtcGxhdGUSNi5oZWFsdGhjYXJlLm51cnNpbmcu'
    'djEuUmV0aXJlQXNzZXNzbWVudFRlbXBsYXRlUmVxdWVzdBo3LmhlYWx0aGNhcmUubnVyc2luZy'
    '52MS5SZXRpcmVBc3Nlc3NtZW50VGVtcGxhdGVSZXNwb25zZRJzChBSZWNvcmRBc3Nlc3NtZW50'
    'Ei4uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlY29yZEFzc2Vzc21lbnRSZXF1ZXN0Gi8uaGVhbH'
    'RoY2FyZS5udXJzaW5nLnYxLlJlY29yZEFzc2Vzc21lbnRSZXNwb25zZRJwCg9MaXN0QXNzZXNz'
    'bWVudHMSLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdEFzc2Vzc21lbnRzUmVxdWVzdBouLm'
    'hlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0QXNzZXNzbWVudHNSZXNwb25zZRJwCg9EZWZpbmVS'
    'aXNrU2NhbGUSLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuRGVmaW5lUmlza1NjYWxlUmVxdWVzdB'
    'ouLmhlYWx0aGNhcmUubnVyc2luZy52MS5EZWZpbmVSaXNrU2NhbGVSZXNwb25zZRJeCglTY29y'
    'ZVJpc2sSJy5oZWFsdGhjYXJlLm51cnNpbmcudjEuU2NvcmVSaXNrUmVxdWVzdBooLmhlYWx0aG'
    'NhcmUubnVyc2luZy52MS5TY29yZVJpc2tSZXNwb25zZRJ8ChNMaXN0Umlza0Fzc2Vzc21lbnRz'
    'EjEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RSaXNrQXNzZXNzbWVudHNSZXF1ZXN0GjIuaG'
    'VhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RSaXNrQXNzZXNzbWVudHNSZXNwb25zZRJ/ChRMaXN0'
    'RHVlUmVhc3Nlc3NtZW50cxIyLmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0RHVlUmVhc3Nlc3'
    'NtZW50c1JlcXVlc3QaMy5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdER1ZVJlYXNzZXNzbWVu'
    'dHNSZXNwb25zZRJnCgxJbnNlcnREZXZpY2USKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuSW5zZX'
    'J0RGV2aWNlUmVxdWVzdBorLmhlYWx0aGNhcmUubnVyc2luZy52MS5JbnNlcnREZXZpY2VSZXNw'
    'b25zZRJnCgxSZW1vdmVEZXZpY2USKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuUmVtb3ZlRGV2aW'
    'NlUmVxdWVzdBorLmhlYWx0aGNhcmUubnVyc2luZy52MS5SZW1vdmVEZXZpY2VSZXNwb25zZRJz'
    'ChBSZWNvcmREZXZpY2VDYXJlEi4uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlY29yZERldmljZU'
    'NhcmVSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlY29yZERldmljZUNhcmVSZXNw'
    'b25zZRJkCgtMaXN0RGV2aWNlcxIpLmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0RGV2aWNlc1'
    'JlcXVlc3QaKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdERldmljZXNSZXNwb25zZRJ5ChJH'
    'ZXRNZWRpY2F0aW9uUm91bmQSMC5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0TWVkaWNhdGlvbl'
    'JvdW5kUmVxdWVzdBoxLmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXRNZWRpY2F0aW9uUm91bmRS'
    'ZXNwb25zZRJhCgpBZG1pbmlzdGVyEiguaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFkbWluaXN0ZX'
    'JSZXF1ZXN0GikuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkFkbWluaXN0ZXJSZXNwb25zZRJ8ChNM'
    'aXN0QWRtaW5pc3RyYXRpb25zEjEuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RBZG1pbmlzdH'
    'JhdGlvbnNSZXF1ZXN0GjIuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RBZG1pbmlzdHJhdGlv'
    'bnNSZXNwb25zZRJ2ChFHZXRPdmVycmlkZVJlcG9ydBIvLmhlYWx0aGNhcmUubnVyc2luZy52MS'
    '5HZXRPdmVycmlkZVJlcG9ydFJlcXVlc3QaMC5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0T3Zl'
    'cnJpZGVSZXBvcnRSZXNwb25zZRKIAQoXU2V0QWRtaW5pc3RyYXRpb25Qb2xpY3kSNS5oZWFsdG'
    'hjYXJlLm51cnNpbmcudjEuU2V0QWRtaW5pc3RyYXRpb25Qb2xpY3lSZXF1ZXN0GjYuaGVhbHRo'
    'Y2FyZS5udXJzaW5nLnYxLlNldEFkbWluaXN0cmF0aW9uUG9saWN5UmVzcG9uc2USbQoOQ3JlYX'
    'RlQ2FyZVBsYW4SLC5oZWFsdGhjYXJlLm51cnNpbmcudjEuQ3JlYXRlQ2FyZVBsYW5SZXF1ZXN0'
    'Gi0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkNyZWF0ZUNhcmVQbGFuUmVzcG9uc2USbQoOUmV2aW'
    'V3Q2FyZVBsYW4SLC5oZWFsdGhjYXJlLm51cnNpbmcudjEuUmV2aWV3Q2FyZVBsYW5SZXF1ZXN0'
    'Gi0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJldmlld0NhcmVQbGFuUmVzcG9uc2USagoNTGlzdE'
    'NhcmVQbGFucxIrLmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0Q2FyZVBsYW5zUmVxdWVzdBos'
    'LmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0Q2FyZVBsYW5zUmVzcG9uc2USYQoKQ3JlYXRlVG'
    'FzaxIoLmhlYWx0aGNhcmUubnVyc2luZy52MS5DcmVhdGVUYXNrUmVxdWVzdBopLmhlYWx0aGNh'
    'cmUubnVyc2luZy52MS5DcmVhdGVUYXNrUmVzcG9uc2USZwoMQ29tcGxldGVUYXNrEiouaGVhbH'
    'RoY2FyZS5udXJzaW5nLnYxLkNvbXBsZXRlVGFza1JlcXVlc3QaKy5oZWFsdGhjYXJlLm51cnNp'
    'bmcudjEuQ29tcGxldGVUYXNrUmVzcG9uc2USWwoIU2tpcFRhc2sSJi5oZWFsdGhjYXJlLm51cn'
    'NpbmcudjEuU2tpcFRhc2tSZXF1ZXN0GicuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlNraXBUYXNr'
    'UmVzcG9uc2USZAoLR2V0V29ya2xpc3QSKS5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0V29ya2'
    'xpc3RSZXF1ZXN0GiouaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldFdvcmtsaXN0UmVzcG9uc2US'
    'fAoTRXNjYWxhdGVPdmVyZHVlV29yaxIxLmhlYWx0aGNhcmUubnVyc2luZy52MS5Fc2NhbGF0ZU'
    '92ZXJkdWVXb3JrUmVxdWVzdBoyLmhlYWx0aGNhcmUubnVyc2luZy52MS5Fc2NhbGF0ZU92ZXJk'
    'dWVXb3JrUmVzcG9uc2UScAoPQ29tcG9zZUhhbmRvdmVyEi0uaGVhbHRoY2FyZS5udXJzaW5nLn'
    'YxLkNvbXBvc2VIYW5kb3ZlclJlcXVlc3QaLi5oZWFsdGhjYXJlLm51cnNpbmcudjEuQ29tcG9z'
    'ZUhhbmRvdmVyUmVzcG9uc2USfAoTQWNrbm93bGVkZ2VIYW5kb3ZlchIxLmhlYWx0aGNhcmUubn'
    'Vyc2luZy52MS5BY2tub3dsZWRnZUhhbmRvdmVyUmVxdWVzdBoyLmhlYWx0aGNhcmUubnVyc2lu'
    'Zy52MS5BY2tub3dsZWRnZUhhbmRvdmVyUmVzcG9uc2USagoNTGlzdEhhbmRvdmVycxIrLmhlYW'
    'x0aGNhcmUubnVyc2luZy52MS5MaXN0SGFuZG92ZXJzUmVxdWVzdBosLmhlYWx0aGNhcmUubnVy'
    'c2luZy52MS5MaXN0SGFuZG92ZXJzUmVzcG9uc2USbQoOQXBwbHlSZXN0cmFpbnQSLC5oZWFsdG'
    'hjYXJlLm51cnNpbmcudjEuQXBwbHlSZXN0cmFpbnRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5udXJz'
    'aW5nLnYxLkFwcGx5UmVzdHJhaW50UmVzcG9uc2USbQoOUmVuZXdSZXN0cmFpbnQSLC5oZWFsdG'
    'hjYXJlLm51cnNpbmcudjEuUmVuZXdSZXN0cmFpbnRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5udXJz'
    'aW5nLnYxLlJlbmV3UmVzdHJhaW50UmVzcG9uc2USbQoOQ2hlY2tSZXN0cmFpbnQSLC5oZWFsdG'
    'hjYXJlLm51cnNpbmcudjEuQ2hlY2tSZXN0cmFpbnRSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5udXJz'
    'aW5nLnYxLkNoZWNrUmVzdHJhaW50UmVzcG9uc2USfwoURGlzY29udGludWVSZXN0cmFpbnQSMi'
    '5oZWFsdGhjYXJlLm51cnNpbmcudjEuRGlzY29udGludWVSZXN0cmFpbnRSZXF1ZXN0GjMuaGVh'
    'bHRoY2FyZS5udXJzaW5nLnYxLkRpc2NvbnRpbnVlUmVzdHJhaW50UmVzcG9uc2USbQoOTGlzdF'
    'Jlc3RyYWludHMSLC5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdFJlc3RyYWludHNSZXF1ZXN0'
    'Gi0uaGVhbHRoY2FyZS5udXJzaW5nLnYxLkxpc3RSZXN0cmFpbnRzUmVzcG9uc2USeQoSR2V0Um'
    'VzdHJhaW50QWxlcnRzEjAuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldFJlc3RyYWludEFsZXJ0'
    'c1JlcXVlc3QaMS5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0UmVzdHJhaW50QWxlcnRzUmVzcG'
    '9uc2USeAoQU3RhcnRUcmFuc2Z1c2lvbhIuLmhlYWx0aGNhcmUubnVyc2luZy52MS5TdGFydFRy'
    'YW5zZnVzaW9uUmVxdWVzdBovLmhlYWx0aGNhcmUubnVyc2luZy52MS5TdGFydFRyYW5zZnVzaW'
    '9uUmVzcG9uc2UiA4gCARJ+ChJPYnNlcnZlVHJhbnNmdXNpb24SMC5oZWFsdGhjYXJlLm51cnNp'
    'bmcudjEuT2JzZXJ2ZVRyYW5zZnVzaW9uUmVxdWVzdBoxLmhlYWx0aGNhcmUubnVyc2luZy52MS'
    '5PYnNlcnZlVHJhbnNmdXNpb25SZXNwb25zZSIDiAIBEpMBChlSZXBvcnRUcmFuc2Z1c2lvblJl'
    'YWN0aW9uEjcuaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlcG9ydFRyYW5zZnVzaW9uUmVhY3Rpb2'
    '5SZXF1ZXN0GjguaGVhbHRoY2FyZS5udXJzaW5nLnYxLlJlcG9ydFRyYW5zZnVzaW9uUmVhY3Rp'
    'b25SZXNwb25zZSIDiAIBEoEBChNDb21wbGV0ZVRyYW5zZnVzaW9uEjEuaGVhbHRoY2FyZS5udX'
    'JzaW5nLnYxLkNvbXBsZXRlVHJhbnNmdXNpb25SZXF1ZXN0GjIuaGVhbHRoY2FyZS5udXJzaW5n'
    'LnYxLkNvbXBsZXRlVHJhbnNmdXNpb25SZXNwb25zZSIDiAIBEmQKC0Fzc2Vzc1dvdW5kEikuaG'
    'VhbHRoY2FyZS5udXJzaW5nLnYxLkFzc2Vzc1dvdW5kUmVxdWVzdBoqLmhlYWx0aGNhcmUubnVy'
    'c2luZy52MS5Bc3Nlc3NXb3VuZFJlc3BvbnNlEnMKEEF0dGFjaFdvdW5kSW1hZ2USLi5oZWFsdG'
    'hjYXJlLm51cnNpbmcudjEuQXR0YWNoV291bmRJbWFnZVJlcXVlc3QaLy5oZWFsdGhjYXJlLm51'
    'cnNpbmcudjEuQXR0YWNoV291bmRJbWFnZVJlc3BvbnNlEnAKD0dldFdvdW5kSGlzdG9yeRItLm'
    'hlYWx0aGNhcmUubnVyc2luZy52MS5HZXRXb3VuZEhpc3RvcnlSZXF1ZXN0Gi4uaGVhbHRoY2Fy'
    'ZS5udXJzaW5nLnYxLkdldFdvdW5kSGlzdG9yeVJlc3BvbnNlEnAKD1JlY29yZEVkdWNhdGlvbh'
    'ItLmhlYWx0aGNhcmUubnVyc2luZy52MS5SZWNvcmRFZHVjYXRpb25SZXF1ZXN0Gi4uaGVhbHRo'
    'Y2FyZS5udXJzaW5nLnYxLlJlY29yZEVkdWNhdGlvblJlc3BvbnNlEoIBChVHZXREaXNjaGFyZ2'
    'VSZWFkaW5lc3MSMy5oZWFsdGhjYXJlLm51cnNpbmcudjEuR2V0RGlzY2hhcmdlUmVhZGluZXNz'
    'UmVxdWVzdBo0LmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXREaXNjaGFyZ2VSZWFkaW5lc3NSZX'
    'Nwb25zZRJkCgtBc3NpZ25OdXJzZRIpLmhlYWx0aGNhcmUubnVyc2luZy52MS5Bc3NpZ25OdXJz'
    'ZVJlcXVlc3QaKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuQXNzaWduTnVyc2VSZXNwb25zZRJqCg'
    '1FbmRBc3NpZ25tZW50EisuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkVuZEFzc2lnbm1lbnRSZXF1'
    'ZXN0GiwuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkVuZEFzc2lnbm1lbnRSZXNwb25zZRJwCg9MaX'
    'N0QXNzaWdubWVudHMSLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdEFzc2lnbm1lbnRzUmVx'
    'dWVzdBouLmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0QXNzaWdubWVudHNSZXNwb25zZRJqCg'
    '1HZXRVbml0QWN1aXR5EisuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldFVuaXRBY3VpdHlSZXF1'
    'ZXN0GiwuaGVhbHRoY2FyZS5udXJzaW5nLnYxLkdldFVuaXRBY3VpdHlSZXNwb25zZRJzChBTZX'
    'RBY3VpdHlXZWlnaHRzEi4uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlNldEFjdWl0eVdlaWdodHNS'
    'ZXF1ZXN0Gi8uaGVhbHRoY2FyZS5udXJzaW5nLnYxLlNldEFjdWl0eVdlaWdodHNSZXNwb25zZR'
    'JwCg9EZWNsYXJlRG93bnRpbWUSLS5oZWFsdGhjYXJlLm51cnNpbmcudjEuRGVjbGFyZURvd250'
    'aW1lUmVxdWVzdBouLmhlYWx0aGNhcmUubnVyc2luZy52MS5EZWNsYXJlRG93bnRpbWVSZXNwb2'
    '5zZRJkCgtFbmREb3dudGltZRIpLmhlYWx0aGNhcmUubnVyc2luZy52MS5FbmREb3dudGltZVJl'
    'cXVlc3QaKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuRW5kRG93bnRpbWVSZXNwb25zZRJ2ChFSZW'
    'NvbmNpbGVEb3dudGltZRIvLmhlYWx0aGNhcmUubnVyc2luZy52MS5SZWNvbmNpbGVEb3dudGlt'
    'ZVJlcXVlc3QaMC5oZWFsdGhjYXJlLm51cnNpbmcudjEuUmVjb25jaWxlRG93bnRpbWVSZXNwb2'
    '5zZRJnCgxMaXN0RG93bnRpbWUSKi5oZWFsdGhjYXJlLm51cnNpbmcudjEuTGlzdERvd250aW1l'
    'UmVxdWVzdBorLmhlYWx0aGNhcmUubnVyc2luZy52MS5MaXN0RG93bnRpbWVSZXNwb25zZRKFAQ'
    'oWR2V0U3VzcGVjdGVkRHVwbGljYXRlcxI0LmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXRTdXNw'
    'ZWN0ZWREdXBsaWNhdGVzUmVxdWVzdBo1LmhlYWx0aGNhcmUubnVyc2luZy52MS5HZXRTdXNwZW'
    'N0ZWREdXBsaWNhdGVzUmVzcG9uc2U=');
