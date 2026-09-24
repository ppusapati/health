// This is a generated file - do not edit.
//
// Generated from healthcare/hospital_ops_diet/v1/diet.proto.

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

@$core.Deprecated('Use routeDescriptor instead')
const Route$json = {
  '1': 'Route',
  '2': [
    {'1': 'ROUTE_UNSPECIFIED', '2': 0},
    {'1': 'ROUTE_ORAL', '2': 1},
    {'1': 'ROUTE_ENTERAL', '2': 2},
    {'1': 'ROUTE_PARENTERAL', '2': 3},
    {'1': 'ROUTE_NPO', '2': 4},
  ],
};

/// Descriptor for `Route`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List routeDescriptor = $convert.base64Decode(
    'CgVSb3V0ZRIVChFST1VURV9VTlNQRUNJRklFRBAAEg4KClJPVVRFX09SQUwQARIRCg1ST1VURV'
    '9FTlRFUkFMEAISFAoQUk9VVEVfUEFSRU5URVJBTBADEg0KCVJPVVRFX05QTxAE');

@$core.Deprecated('Use orderStateDescriptor instead')
const OrderState$json = {
  '1': 'OrderState',
  '2': [
    {'1': 'ORDER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ORDER_STATE_PENDING', '2': 1},
    {'1': 'ORDER_STATE_ACTIVE', '2': 2},
    {'1': 'ORDER_STATE_SUPERSEDED', '2': 3},
    {'1': 'ORDER_STATE_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `OrderState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List orderStateDescriptor = $convert.base64Decode(
    'CgpPcmRlclN0YXRlEhsKF09SREVSX1NUQVRFX1VOU1BFQ0lGSUVEEAASFwoTT1JERVJfU1RBVE'
    'VfUEVORElORxABEhYKEk9SREVSX1NUQVRFX0FDVElWRRACEhoKFk9SREVSX1NUQVRFX1NVUEVS'
    'U0VERUQQAxIZChVPUkRFUl9TVEFURV9DQU5DRUxMRUQQBA==');

@$core.Deprecated('Use assessmentStateDescriptor instead')
const AssessmentState$json = {
  '1': 'AssessmentState',
  '2': [
    {'1': 'ASSESSMENT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ASSESSMENT_STATE_DRAFT', '2': 1},
    {'1': 'ASSESSMENT_STATE_SIGNED', '2': 2},
  ],
};

/// Descriptor for `AssessmentState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List assessmentStateDescriptor = $convert.base64Decode(
    'Cg9Bc3Nlc3NtZW50U3RhdGUSIAocQVNTRVNTTUVOVF9TVEFURV9VTlNQRUNJRklFRBAAEhoKFk'
    'FTU0VTU01FTlRfU1RBVEVfRFJBRlQQARIbChdBU1NFU1NNRU5UX1NUQVRFX1NJR05FRBAC');

@$core.Deprecated('Use directionDescriptor instead')
const Direction$json = {
  '1': 'Direction',
  '2': [
    {'1': 'DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'DIRECTION_INCREASE', '2': 1},
    {'1': 'DIRECTION_DECREASE', '2': 2},
    {'1': 'DIRECTION_MAINTAIN', '2': 3},
  ],
};

/// Descriptor for `Direction`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List directionDescriptor = $convert.base64Decode(
    'CglEaXJlY3Rpb24SGQoVRElSRUNUSU9OX1VOU1BFQ0lGSUVEEAASFgoSRElSRUNUSU9OX0lOQ1'
    'JFQVNFEAESFgoSRElSRUNUSU9OX0RFQ1JFQVNFEAISFgoSRElSRUNUSU9OX01BSU5UQUlOEAM=');

@$core.Deprecated('Use planStateDescriptor instead')
const PlanState$json = {
  '1': 'PlanState',
  '2': [
    {'1': 'PLAN_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PLAN_STATE_ACTIVE', '2': 1},
    {'1': 'PLAN_STATE_CLOSED', '2': 2},
  ],
};

/// Descriptor for `PlanState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List planStateDescriptor = $convert.base64Decode(
    'CglQbGFuU3RhdGUSGgoWUExBTl9TVEFURV9VTlNQRUNJRklFRBAAEhUKEVBMQU5fU1RBVEVfQU'
    'NUSVZFEAESFQoRUExBTl9TVEFURV9DTE9TRUQQAg==');

@$core.Deprecated('Use mealCycleDescriptor instead')
const MealCycle$json = {
  '1': 'MealCycle',
  '2': [
    {'1': 'MEAL_CYCLE_UNSPECIFIED', '2': 0},
    {'1': 'MEAL_CYCLE_BREAKFAST', '2': 1},
    {'1': 'MEAL_CYCLE_LUNCH', '2': 2},
    {'1': 'MEAL_CYCLE_DINNER', '2': 3},
    {'1': 'MEAL_CYCLE_SNACK', '2': 4},
  ],
};

/// Descriptor for `MealCycle`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List mealCycleDescriptor = $convert.base64Decode(
    'CglNZWFsQ3ljbGUSGgoWTUVBTF9DWUNMRV9VTlNQRUNJRklFRBAAEhgKFE1FQUxfQ1lDTEVfQl'
    'JFQUtGQVNUEAESFAoQTUVBTF9DWUNMRV9MVU5DSBACEhUKEU1FQUxfQ1lDTEVfRElOTkVSEAMS'
    'FAoQTUVBTF9DWUNMRV9TTkFDSxAE');

@$core.Deprecated('Use censusStateDescriptor instead')
const CensusState$json = {
  '1': 'CensusState',
  '2': [
    {'1': 'CENSUS_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CENSUS_STATE_DRAFT', '2': 1},
    {'1': 'CENSUS_STATE_FROZEN', '2': 2},
    {'1': 'CENSUS_STATE_SUPERSEDED', '2': 3},
  ],
};

/// Descriptor for `CensusState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List censusStateDescriptor = $convert.base64Decode(
    'CgtDZW5zdXNTdGF0ZRIcChhDRU5TVVNfU1RBVEVfVU5TUEVDSUZJRUQQABIWChJDRU5TVVNfU1'
    'RBVEVfRFJBRlQQARIXChNDRU5TVVNfU1RBVEVfRlJPWkVOEAISGwoXQ0VOU1VTX1NUQVRFX1NV'
    'UEVSU0VERUQQAw==');

@$core.Deprecated('Use trayStateDescriptor instead')
const TrayState$json = {
  '1': 'TrayState',
  '2': [
    {'1': 'TRAY_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TRAY_STATE_PLANNED', '2': 1},
    {'1': 'TRAY_STATE_PREPARED', '2': 2},
    {'1': 'TRAY_STATE_DISPATCHED', '2': 3},
    {'1': 'TRAY_STATE_DELIVERED', '2': 4},
    {'1': 'TRAY_STATE_REFUSED', '2': 5},
    {'1': 'TRAY_STATE_MISSED', '2': 6},
    {'1': 'TRAY_STATE_WITHHELD', '2': 7},
  ],
};

/// Descriptor for `TrayState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List trayStateDescriptor = $convert.base64Decode(
    'CglUcmF5U3RhdGUSGgoWVFJBWV9TVEFURV9VTlNQRUNJRklFRBAAEhYKElRSQVlfU1RBVEVfUE'
    'xBTk5FRBABEhcKE1RSQVlfU1RBVEVfUFJFUEFSRUQQAhIZChVUUkFZX1NUQVRFX0RJU1BBVENI'
    'RUQQAxIYChRUUkFZX1NUQVRFX0RFTElWRVJFRBAEEhYKElRSQVlfU1RBVEVfUkVGVVNFRBAFEh'
    'UKEVRSQVlfU1RBVEVfTUlTU0VEEAYSFwoTVFJBWV9TVEFURV9XSVRISEVMRBAH');

@$core.Deprecated('Use supportKindDescriptor instead')
const SupportKind$json = {
  '1': 'SupportKind',
  '2': [
    {'1': 'SUPPORT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SUPPORT_KIND_ENTERAL', '2': 1},
    {'1': 'SUPPORT_KIND_PARENTERAL', '2': 2},
  ],
};

/// Descriptor for `SupportKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List supportKindDescriptor = $convert.base64Decode(
    'CgtTdXBwb3J0S2luZBIcChhTVVBQT1JUX0tJTkRfVU5TUEVDSUZJRUQQABIYChRTVVBQT1JUX0'
    'tJTkRfRU5URVJBTBABEhsKF1NVUFBPUlRfS0lORF9QQVJFTlRFUkFMEAI=');

@$core.Deprecated('Use supportStateDescriptor instead')
const SupportState$json = {
  '1': 'SupportState',
  '2': [
    {'1': 'SUPPORT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'SUPPORT_STATE_PLANNED', '2': 1},
    {'1': 'SUPPORT_STATE_ACTIVE', '2': 2},
    {'1': 'SUPPORT_STATE_STOPPED', '2': 3},
  ],
};

/// Descriptor for `SupportState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List supportStateDescriptor = $convert.base64Decode(
    'CgxTdXBwb3J0U3RhdGUSHQoZU1VQUE9SVF9TVEFURV9VTlNQRUNJRklFRBAAEhkKFVNVUFBPUl'
    'RfU1RBVEVfUExBTk5FRBABEhgKFFNVUFBPUlRfU1RBVEVfQUNUSVZFEAISGQoVU1VQUE9SVF9T'
    'VEFURV9TVE9QUEVEEAM=');

@$core.Deprecated('Use anthropometryDescriptor instead')
const Anthropometry$json = {
  '1': 'Anthropometry',
  '2': [
    {'1': 'height_mm', '3': 1, '4': 1, '5': 5, '10': 'heightMm'},
    {'1': 'weight_g', '3': 2, '4': 1, '5': 5, '10': 'weightG'},
    {'1': 'mid_upper_arm_mm', '3': 3, '4': 1, '5': 5, '10': 'midUpperArmMm'},
    {'1': 'estimated', '3': 4, '4': 1, '5': 8, '10': 'estimated'},
    {
      '1': 'measured_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'measuredAt'
    },
  ],
};

/// Descriptor for `Anthropometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anthropometryDescriptor = $convert.base64Decode(
    'Cg1BbnRocm9wb21ldHJ5EhsKCWhlaWdodF9tbRgBIAEoBVIIaGVpZ2h0TW0SGQoId2VpZ2h0X2'
    'cYAiABKAVSB3dlaWdodEcSJwoQbWlkX3VwcGVyX2FybV9tbRgDIAEoBVINbWlkVXBwZXJBcm1N'
    'bRIcCgllc3RpbWF0ZWQYBCABKAhSCWVzdGltYXRlZBI7CgttZWFzdXJlZF9hdBgFIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm1lYXN1cmVkQXQ=');

@$core.Deprecated('Use requirementDescriptor instead')
const Requirement$json = {
  '1': 'Requirement',
  '2': [
    {'1': 'energy_kcal', '3': 1, '4': 1, '5': 5, '10': 'energyKcal'},
    {'1': 'protein_g', '3': 2, '4': 1, '5': 5, '10': 'proteinG'},
    {'1': 'fluid_ml', '3': 3, '4': 1, '5': 5, '10': 'fluidMl'},
    {'1': 'basis', '3': 4, '4': 1, '5': 9, '10': 'basis'},
  ],
};

/// Descriptor for `Requirement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requirementDescriptor = $convert.base64Decode(
    'CgtSZXF1aXJlbWVudBIfCgtlbmVyZ3lfa2NhbBgBIAEoBVIKZW5lcmd5S2NhbBIbCglwcm90ZW'
    'luX2cYAiABKAVSCHByb3RlaW5HEhkKCGZsdWlkX21sGAMgASgFUgdmbHVpZE1sEhQKBWJhc2lz'
    'GAQgASgJUgViYXNpcw==');

@$core.Deprecated('Use nutritionAssessmentDescriptor instead')
const NutritionAssessment$json = {
  '1': 'NutritionAssessment',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'anthropometry',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Anthropometry',
      '10': 'anthropometry'
    },
    {
      '1': 'body_mass_index_tenths',
      '3': 6,
      '4': 1,
      '5': 5,
      '10': 'bodyMassIndexTenths'
    },
    {'1': 'intake_summary', '3': 7, '4': 1, '5': 9, '10': 'intakeSummary'},
    {'1': 'diagnosis_code', '3': 8, '4': 1, '5': 9, '10': 'diagnosisCode'},
    {'1': 'diagnosis', '3': 9, '4': 1, '5': 9, '10': 'diagnosis'},
    {'1': 'allergy_refs', '3': 10, '4': 3, '5': 9, '10': 'allergyRefs'},
    {
      '1': 'requirement',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Requirement',
      '10': 'requirement'
    },
    {'1': 'risk_tool', '3': 12, '4': 1, '5': 9, '10': 'riskTool'},
    {'1': 'risk_score', '3': 13, '4': 1, '5': 5, '10': 'riskScore'},
    {
      '1': 'state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.AssessmentState',
      '10': 'state'
    },
    {'1': 'signed_by', '3': 15, '4': 1, '5': 9, '10': 'signedBy'},
    {
      '1': 'signed_at',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'signedAt'
    },
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

/// Descriptor for `NutritionAssessment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nutritionAssessmentDescriptor = $convert.base64Decode(
    'ChNOdXRyaXRpb25Bc3Nlc3NtZW50EiMKDWFzc2Vzc21lbnRfaWQYASABKAlSDGFzc2Vzc21lbn'
    'RJZBIdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMgASgJ'
    'UgtlbmNvdW50ZXJJZBIfCgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBJUCg1hbnRocm'
    '9wb21ldHJ5GAUgASgLMi4uaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5BbnRocm9w'
    'b21ldHJ5Ug1hbnRocm9wb21ldHJ5EjMKFmJvZHlfbWFzc19pbmRleF90ZW50aHMYBiABKAVSE2'
    'JvZHlNYXNzSW5kZXhUZW50aHMSJQoOaW50YWtlX3N1bW1hcnkYByABKAlSDWludGFrZVN1bW1h'
    'cnkSJQoOZGlhZ25vc2lzX2NvZGUYCCABKAlSDWRpYWdub3Npc0NvZGUSHAoJZGlhZ25vc2lzGA'
    'kgASgJUglkaWFnbm9zaXMSIQoMYWxsZXJneV9yZWZzGAogAygJUgthbGxlcmd5UmVmcxJOCgty'
    'ZXF1aXJlbWVudBgLIAEoCzIsLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuUmVxdW'
    'lyZW1lbnRSC3JlcXVpcmVtZW50EhsKCXJpc2tfdG9vbBgMIAEoCVIIcmlza1Rvb2wSHQoKcmlz'
    'a19zY29yZRgNIAEoBVIJcmlza1Njb3JlEkYKBXN0YXRlGA4gASgOMjAuaGVhbHRoY2FyZS5ob3'
    'NwaXRhbF9vcHNfZGlldC52MS5Bc3Nlc3NtZW50U3RhdGVSBXN0YXRlEhsKCXNpZ25lZF9ieRgP'
    'IAEoCVIIc2lnbmVkQnkSNwoJc2lnbmVkX2F0GBAgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIIc2lnbmVkQXQSOQoKY3JlYXRlZF9hdBgRIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWNyZWF0ZWRBdBIdCgpjcmVhdGVkX2J5GBIgASgJUgljcmVhdGVkQnkSGAoHdm'
    'Vyc2lvbhgTIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use textureDescriptor instead')
const Texture$json = {
  '1': 'Texture',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'fluid_code', '3': 3, '4': 1, '5': 9, '10': 'fluidCode'},
  ],
};

/// Descriptor for `Texture`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textureDescriptor = $convert.base64Decode(
    'CgdUZXh0dXJlEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBWxhYmVsEh0KCm'
    'ZsdWlkX2NvZGUYAyABKAlSCWZsdWlkQ29kZQ==');

@$core.Deprecated('Use conflictDescriptor instead')
const Conflict$json = {
  '1': 'Conflict',
  '2': [
    {'1': 'allergy_ref', '3': 1, '4': 1, '5': 9, '10': 'allergyRef'},
    {'1': 'substance', '3': 2, '4': 1, '5': 9, '10': 'substance'},
    {'1': 'item', '3': 3, '4': 1, '5': 9, '10': 'item'},
    {'1': 'severity', '3': 4, '4': 1, '5': 9, '10': 'severity'},
    {'1': 'resolved_by', '3': 5, '4': 1, '5': 9, '10': 'resolvedBy'},
    {
      '1': 'resolved_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'resolvedAt'
    },
    {'1': 'resolution_note', '3': 7, '4': 1, '5': 9, '10': 'resolutionNote'},
  ],
};

/// Descriptor for `Conflict`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conflictDescriptor = $convert.base64Decode(
    'CghDb25mbGljdBIfCgthbGxlcmd5X3JlZhgBIAEoCVIKYWxsZXJneVJlZhIcCglzdWJzdGFuY2'
    'UYAiABKAlSCXN1YnN0YW5jZRISCgRpdGVtGAMgASgJUgRpdGVtEhoKCHNldmVyaXR5GAQgASgJ'
    'UghzZXZlcml0eRIfCgtyZXNvbHZlZF9ieRgFIAEoCVIKcmVzb2x2ZWRCeRI7CgtyZXNvbHZlZF'
    '9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlc29sdmVkQXQSJwoPcmVz'
    'b2x1dGlvbl9ub3RlGAcgASgJUg5yZXNvbHV0aW9uTm90ZQ==');

@$core.Deprecated('Use dietOrderDescriptor instead')
const DietOrder$json = {
  '1': 'DietOrder',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'ward_id', '3': 5, '4': 1, '5': 9, '10': 'wardId'},
    {'1': 'bed_id', '3': 6, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'route',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.Route',
      '10': 'route'
    },
    {
      '1': 'texture',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Texture',
      '10': 'texture'
    },
    {'1': 'restrictions', '3': 9, '4': 3, '5': 9, '10': 'restrictions'},
    {'1': 'supplements', '3': 10, '4': 3, '5': 9, '10': 'supplements'},
    {'1': 'instruction', '3': 11, '4': 1, '5': 9, '10': 'instruction'},
    {
      '1': 'effective_from',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_to',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
    {
      '1': 'state',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.OrderState',
      '10': 'state'
    },
    {
      '1': 'conflicts',
      '3': 15,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Conflict',
      '10': 'conflicts'
    },
    {'1': 'cancelled_reason', '3': 16, '4': 1, '5': 9, '10': 'cancelledReason'},
    {'1': 'cancelled_by', '3': 17, '4': 1, '5': 9, '10': 'cancelledBy'},
    {
      '1': 'cancelled_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cancelledAt'
    },
    {
      '1': 'placed_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'placedAt'
    },
    {'1': 'placed_by', '3': 20, '4': 1, '5': 9, '10': 'placedBy'},
    {'1': 'version', '3': 21, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `DietOrder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dietOrderDescriptor = $convert.base64Decode(
    'CglEaWV0T3JkZXISGQoIb3JkZXJfaWQYASABKAlSB29yZGVySWQSHQoKcGF0aWVudF9pZBgCIA'
    'EoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQSHwoLZmFj'
    'aWxpdHlfaWQYBCABKAlSCmZhY2lsaXR5SWQSFwoHd2FyZF9pZBgFIAEoCVIGd2FyZElkEhUKBm'
    'JlZF9pZBgGIAEoCVIFYmVkSWQSPAoFcm91dGUYByABKA4yJi5oZWFsdGhjYXJlLmhvc3BpdGFs'
    'X29wc19kaWV0LnYxLlJvdXRlUgVyb3V0ZRJCCgd0ZXh0dXJlGAggASgLMiguaGVhbHRoY2FyZS'
    '5ob3NwaXRhbF9vcHNfZGlldC52MS5UZXh0dXJlUgd0ZXh0dXJlEiIKDHJlc3RyaWN0aW9ucxgJ'
    'IAMoCVIMcmVzdHJpY3Rpb25zEiAKC3N1cHBsZW1lbnRzGAogAygJUgtzdXBwbGVtZW50cxIgCg'
    'tpbnN0cnVjdGlvbhgLIAEoCVILaW5zdHJ1Y3Rpb24SQQoOZWZmZWN0aXZlX2Zyb20YDCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEj0KDGVmZmVjdGl2ZV'
    '90bxgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZVRvEkEKBXN0'
    'YXRlGA4gASgOMisuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5PcmRlclN0YXRlUg'
    'VzdGF0ZRJHCgljb25mbGljdHMYDyADKAsyKS5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0'
    'LnYxLkNvbmZsaWN0Ugljb25mbGljdHMSKQoQY2FuY2VsbGVkX3JlYXNvbhgQIAEoCVIPY2FuY2'
    'VsbGVkUmVhc29uEiEKDGNhbmNlbGxlZF9ieRgRIAEoCVILY2FuY2VsbGVkQnkSPQoMY2FuY2Vs'
    'bGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY2FuY2VsbGVkQXQSNw'
    'oJcGxhY2VkX2F0GBMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIcGxhY2VkQXQS'
    'GwoJcGxhY2VkX2J5GBQgASgJUghwbGFjZWRCeRIYCgd2ZXJzaW9uGBUgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use nutritionGoalDescriptor instead')
const NutritionGoal$json = {
  '1': 'NutritionGoal',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'target', '3': 3, '4': 1, '5': 5, '10': 'target'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {
      '1': 'direction',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.Direction',
      '10': 'direction'
    },
    {'1': 'tolerance', '3': 6, '4': 1, '5': 5, '10': 'tolerance'},
    {
      '1': 'target_by',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'targetBy'
    },
  ],
};

/// Descriptor for `NutritionGoal`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nutritionGoalDescriptor = $convert.base64Decode(
    'Cg1OdXRyaXRpb25Hb2FsEhIKBGNvZGUYASABKAlSBGNvZGUSFAoFbGFiZWwYAiABKAlSBWxhYm'
    'VsEhYKBnRhcmdldBgDIAEoBVIGdGFyZ2V0EhIKBHVuaXQYBCABKAlSBHVuaXQSSAoJZGlyZWN0'
    'aW9uGAUgASgOMiouaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5EaXJlY3Rpb25SCW'
    'RpcmVjdGlvbhIcCgl0b2xlcmFuY2UYBiABKAVSCXRvbGVyYW5jZRI3Cgl0YXJnZXRfYnkYByAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgh0YXJnZXRCeQ==');

@$core.Deprecated('Use carePlanDescriptor instead')
const CarePlan$json = {
  '1': 'CarePlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'assessment_id', '3': 4, '4': 1, '5': 9, '10': 'assessmentId'},
    {
      '1': 'goals',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionGoal',
      '10': 'goals'
    },
    {'1': 'plan', '3': 6, '4': 1, '5': 9, '10': 'plan'},
    {
      '1': 'review_due',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewDue'
    },
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.PlanState',
      '10': 'state'
    },
    {
      '1': 'closed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'closedAt'
    },
    {'1': 'closed_by', '3': 10, '4': 1, '5': 9, '10': 'closedBy'},
    {'1': 'closure_note', '3': 11, '4': 1, '5': 9, '10': 'closureNote'},
    {
      '1': 'created_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {'1': 'created_by', '3': 13, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'version', '3': 14, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `CarePlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List carePlanDescriptor = $convert.base64Decode(
    'CghDYXJlUGxhbhIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSHQoKcGF0aWVudF9pZBgCIAEoCV'
    'IJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVySWQSIwoNYXNzZXNz'
    'bWVudF9pZBgEIAEoCVIMYXNzZXNzbWVudElkEkQKBWdvYWxzGAUgAygLMi4uaGVhbHRoY2FyZS'
    '5ob3NwaXRhbF9vcHNfZGlldC52MS5OdXRyaXRpb25Hb2FsUgVnb2FscxISCgRwbGFuGAYgASgJ'
    'UgRwbGFuEjkKCnJldmlld19kdWUYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'lyZXZpZXdEdWUSQAoFc3RhdGUYCCABKA4yKi5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0'
    'LnYxLlBsYW5TdGF0ZVIFc3RhdGUSNwoJY2xvc2VkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIIY2xvc2VkQXQSGwoJY2xvc2VkX2J5GAogASgJUghjbG9zZWRCeRIhCgxj'
    'bG9zdXJlX25vdGUYCyABKAlSC2Nsb3N1cmVOb3RlEjkKCmNyZWF0ZWRfYXQYDCABKAsyGi5nb2'
    '9nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSHQoKY3JlYXRlZF9ieRgNIAEoCVIJ'
    'Y3JlYXRlZEJ5EhgKB3ZlcnNpb24YDiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use progressDescriptor instead')
const Progress$json = {
  '1': 'Progress',
  '2': [
    {'1': 'progress_id', '3': 1, '4': 1, '5': 9, '10': 'progressId'},
    {'1': 'plan_id', '3': 2, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'goal_code', '3': 3, '4': 1, '5': 9, '10': 'goalCode'},
    {'1': 'value', '3': 4, '4': 1, '5': 5, '10': 'value'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
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

/// Descriptor for `Progress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List progressDescriptor = $convert.base64Decode(
    'CghQcm9ncmVzcxIfCgtwcm9ncmVzc19pZBgBIAEoCVIKcHJvZ3Jlc3NJZBIXCgdwbGFuX2lkGA'
    'IgASgJUgZwbGFuSWQSGwoJZ29hbF9jb2RlGAMgASgJUghnb2FsQ29kZRIUCgV2YWx1ZRgEIAEo'
    'BVIFdmFsdWUSEgoEdW5pdBgFIAEoCVIEdW5pdBISCgRub3RlGAYgASgJUgRub3RlEjsKC3JlY2'
    '9yZGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZWRBdBIf'
    'CgtyZWNvcmRlZF9ieRgIIAEoCVIKcmVjb3JkZWRCeQ==');

@$core.Deprecated('Use trendPointDescriptor instead')
const TrendPoint$json = {
  '1': 'TrendPoint',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 5, '10': 'value'},
    {
      '1': 'at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
  ],
};

/// Descriptor for `TrendPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendPointDescriptor = $convert.base64Decode(
    'CgpUcmVuZFBvaW50EhQKBXZhbHVlGAEgASgFUgV2YWx1ZRIqCgJhdBgCIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSAmF0');

@$core.Deprecated('Use trendDescriptor instead')
const Trend$json = {
  '1': 'Trend',
  '2': [
    {
      '1': 'goal',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionGoal',
      '10': 'goal'
    },
    {
      '1': 'points',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.TrendPoint',
      '10': 'points'
    },
    {'1': 'met', '3': 3, '4': 1, '5': 8, '10': 'met'},
    {'1': 'improving', '3': 4, '4': 1, '5': 8, '10': 'improving'},
    {'1': 'unanswerable', '3': 5, '4': 1, '5': 8, '10': 'unanswerable'},
  ],
};

/// Descriptor for `Trend`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trendDescriptor = $convert.base64Decode(
    'CgVUcmVuZBJCCgRnb2FsGAEgASgLMi4uaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS'
    '5OdXRyaXRpb25Hb2FsUgRnb2FsEkMKBnBvaW50cxgCIAMoCzIrLmhlYWx0aGNhcmUuaG9zcGl0'
    'YWxfb3BzX2RpZXQudjEuVHJlbmRQb2ludFIGcG9pbnRzEhAKA21ldBgDIAEoCFIDbWV0EhwKCW'
    'ltcHJvdmluZxgEIAEoCFIJaW1wcm92aW5nEiIKDHVuYW5zd2VyYWJsZRgFIAEoCFIMdW5hbnN3'
    'ZXJhYmxl');

@$core.Deprecated('Use censusLineDescriptor instead')
const CensusLine$json = {
  '1': 'CensusLine',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'ward_id', '3': 3, '4': 1, '5': 9, '10': 'wardId'},
    {'1': 'bed_id', '3': 4, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'order_id', '3': 5, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'route',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.Route',
      '10': 'route'
    },
    {'1': 'texture_code', '3': 7, '4': 1, '5': 9, '10': 'textureCode'},
    {'1': 'texture_label', '3': 8, '4': 1, '5': 9, '10': 'textureLabel'},
    {'1': 'fluid_code', '3': 9, '4': 1, '5': 9, '10': 'fluidCode'},
    {'1': 'restrictions', '3': 10, '4': 3, '5': 9, '10': 'restrictions'},
    {'1': 'supplements', '3': 11, '4': 3, '5': 9, '10': 'supplements'},
    {'1': 'instruction', '3': 12, '4': 1, '5': 9, '10': 'instruction'},
  ],
};

/// Descriptor for `CensusLine`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List censusLineDescriptor = $convert.base64Decode(
    'CgpDZW5zdXNMaW5lEh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZX'
    'JfaWQYAiABKAlSC2VuY291bnRlcklkEhcKB3dhcmRfaWQYAyABKAlSBndhcmRJZBIVCgZiZWRf'
    'aWQYBCABKAlSBWJlZElkEhkKCG9yZGVyX2lkGAUgASgJUgdvcmRlcklkEjwKBXJvdXRlGAYgAS'
    'gOMiYuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5Sb3V0ZVIFcm91dGUSIQoMdGV4'
    'dHVyZV9jb2RlGAcgASgJUgt0ZXh0dXJlQ29kZRIjCg10ZXh0dXJlX2xhYmVsGAggASgJUgx0ZX'
    'h0dXJlTGFiZWwSHQoKZmx1aWRfY29kZRgJIAEoCVIJZmx1aWRDb2RlEiIKDHJlc3RyaWN0aW9u'
    'cxgKIAMoCVIMcmVzdHJpY3Rpb25zEiAKC3N1cHBsZW1lbnRzGAsgAygJUgtzdXBwbGVtZW50cx'
    'IgCgtpbnN0cnVjdGlvbhgMIAEoCVILaW5zdHJ1Y3Rpb24=');

@$core.Deprecated('Use mealCensusDescriptor instead')
const MealCensus$json = {
  '1': 'MealCensus',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'ward_id', '3': 3, '4': 1, '5': 9, '10': 'wardId'},
    {
      '1': 'cycle',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
    {
      '1': 'service_date',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'serviceDate'
    },
    {
      '1': 'cutoff_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cutoffAt'
    },
    {
      '1': 'lines',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.CensusLine',
      '10': 'lines'
    },
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.CensusState',
      '10': 'state'
    },
    {'1': 'census_version', '3': 9, '4': 1, '5': 5, '10': 'censusVersion'},
    {'1': 'supersedes_id', '3': 10, '4': 1, '5': 9, '10': 'supersedesId'},
    {
      '1': 'frozen_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'frozenAt'
    },
    {'1': 'frozen_by', '3': 12, '4': 1, '5': 9, '10': 'frozenBy'},
    {
      '1': 'built_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'builtAt'
    },
    {'1': 'built_by', '3': 14, '4': 1, '5': 9, '10': 'builtBy'},
  ],
};

/// Descriptor for `MealCensus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mealCensusDescriptor = $convert.base64Decode(
    'CgpNZWFsQ2Vuc3VzEhsKCWNlbnN1c19pZBgBIAEoCVIIY2Vuc3VzSWQSHwoLZmFjaWxpdHlfaW'
    'QYAiABKAlSCmZhY2lsaXR5SWQSFwoHd2FyZF9pZBgDIAEoCVIGd2FyZElkEkAKBWN5Y2xlGAQg'
    'ASgOMiouaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5NZWFsQ3ljbGVSBWN5Y2xlEj'
    '0KDHNlcnZpY2VfZGF0ZRgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3NlcnZp'
    'Y2VEYXRlEjcKCWN1dG9mZl9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCG'
    'N1dG9mZkF0EkEKBWxpbmVzGAcgAygLMisuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52'
    'MS5DZW5zdXNMaW5lUgVsaW5lcxJCCgVzdGF0ZRgIIAEoDjIsLmhlYWx0aGNhcmUuaG9zcGl0YW'
    'xfb3BzX2RpZXQudjEuQ2Vuc3VzU3RhdGVSBXN0YXRlEiUKDmNlbnN1c192ZXJzaW9uGAkgASgF'
    'Ug1jZW5zdXNWZXJzaW9uEiMKDXN1cGVyc2VkZXNfaWQYCiABKAlSDHN1cGVyc2VkZXNJZBI3Cg'
    'lmcm96ZW5fYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghmcm96ZW5BdBIb'
    'Cglmcm96ZW5fYnkYDCABKAlSCGZyb3plbkJ5EjUKCGJ1aWx0X2F0GA0gASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIHYnVpbHRBdBIZCghidWlsdF9ieRgOIAEoCVIHYnVpbHRCeQ==');

@$core.Deprecated('Use trayDescriptor instead')
const Tray$json = {
  '1': 'Tray',
  '2': [
    {'1': 'tray_id', '3': 1, '4': 1, '5': 9, '10': 'trayId'},
    {'1': 'census_id', '3': 2, '4': 1, '5': 9, '10': 'censusId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'ward_id', '3': 4, '4': 1, '5': 9, '10': 'wardId'},
    {'1': 'bed_id', '3': 5, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'cycle',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
    {'1': 'order_id', '3': 7, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'state',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.TrayState',
      '10': 'state'
    },
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'prepared_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'preparedAt'
    },
    {'1': 'prepared_by', '3': 11, '4': 1, '5': 9, '10': 'preparedBy'},
    {
      '1': 'dispatched_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dispatchedAt'
    },
    {'1': 'dispatched_by', '3': 13, '4': 1, '5': 9, '10': 'dispatchedBy'},
    {
      '1': 'delivered_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'deliveredAt'
    },
    {'1': 'delivered_by', '3': 15, '4': 1, '5': 9, '10': 'deliveredBy'},
    {
      '1': 'due_by',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dueBy'
    },
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Tray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trayDescriptor = $convert.base64Decode(
    'CgRUcmF5EhcKB3RyYXlfaWQYASABKAlSBnRyYXlJZBIbCgljZW5zdXNfaWQYAiABKAlSCGNlbn'
    'N1c0lkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIXCgd3YXJkX2lkGAQgASgJUgZ3'
    'YXJkSWQSFQoGYmVkX2lkGAUgASgJUgViZWRJZBJACgVjeWNsZRgGIAEoDjIqLmhlYWx0aGNhcm'
    'UuaG9zcGl0YWxfb3BzX2RpZXQudjEuTWVhbEN5Y2xlUgVjeWNsZRIZCghvcmRlcl9pZBgHIAEo'
    'CVIHb3JkZXJJZBJACgVzdGF0ZRgIIAEoDjIqLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZX'
    'QudjEuVHJheVN0YXRlUgVzdGF0ZRIWCgZyZWFzb24YCSABKAlSBnJlYXNvbhI7CgtwcmVwYXJl'
    'ZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnByZXBhcmVkQXQSHwoLcH'
    'JlcGFyZWRfYnkYCyABKAlSCnByZXBhcmVkQnkSPwoNZGlzcGF0Y2hlZF9hdBgMIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGRpc3BhdGNoZWRBdBIjCg1kaXNwYXRjaGVkX2J5GA'
    '0gASgJUgxkaXNwYXRjaGVkQnkSPQoMZGVsaXZlcmVkX2F0GA4gASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFILZGVsaXZlcmVkQXQSIQoMZGVsaXZlcmVkX2J5GA8gASgJUgtkZWxpdm'
    'VyZWRCeRIxCgZkdWVfYnkYECABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgVkdWVC'
    'eRIYCgd2ZXJzaW9uGBEgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use mealOutcomeDescriptor instead')
const MealOutcome$json = {
  '1': 'MealOutcome',
  '2': [
    {'1': 'planned', '3': 1, '4': 1, '5': 5, '10': 'planned'},
    {'1': 'delivered', '3': 2, '4': 1, '5': 5, '10': 'delivered'},
    {'1': 'refused', '3': 3, '4': 1, '5': 5, '10': 'refused'},
    {'1': 'missed', '3': 4, '4': 1, '5': 5, '10': 'missed'},
    {'1': 'withheld', '3': 5, '4': 1, '5': 5, '10': 'withheld'},
    {'1': 'late', '3': 6, '4': 1, '5': 5, '10': 'late'},
    {'1': 'outstanding', '3': 7, '4': 1, '5': 5, '10': 'outstanding'},
  ],
};

/// Descriptor for `MealOutcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mealOutcomeDescriptor = $convert.base64Decode(
    'CgtNZWFsT3V0Y29tZRIYCgdwbGFubmVkGAEgASgFUgdwbGFubmVkEhwKCWRlbGl2ZXJlZBgCIA'
    'EoBVIJZGVsaXZlcmVkEhgKB3JlZnVzZWQYAyABKAVSB3JlZnVzZWQSFgoGbWlzc2VkGAQgASgF'
    'UgZtaXNzZWQSGgoId2l0aGhlbGQYBSABKAVSCHdpdGhoZWxkEhIKBGxhdGUYBiABKAVSBGxhdG'
    'USIAoLb3V0c3RhbmRpbmcYByABKAVSC291dHN0YW5kaW5n');

@$core.Deprecated('Use nutritionSupportPlanDescriptor instead')
const NutritionSupportPlan$json = {
  '1': 'NutritionSupportPlan',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.SupportKind',
      '10': 'kind'
    },
    {'1': 'formula_code', '3': 5, '4': 1, '5': 9, '10': 'formulaCode'},
    {'1': 'formula_name', '3': 6, '4': 1, '5': 9, '10': 'formulaName'},
    {'1': 'target_volume_ml', '3': 7, '4': 1, '5': 5, '10': 'targetVolumeMl'},
    {
      '1': 'target_energy_kcal',
      '3': 8,
      '4': 1,
      '5': 5,
      '10': 'targetEnergyKcal'
    },
    {'1': 'target_protein_g', '3': 9, '4': 1, '5': 5, '10': 'targetProteinG'},
    {'1': 'ramp_plan', '3': 10, '4': 1, '5': 9, '10': 'rampPlan'},
    {'1': 'order_ref', '3': 11, '4': 1, '5': 9, '10': 'orderRef'},
    {'1': 'order_context', '3': 12, '4': 1, '5': 9, '10': 'orderContext'},
    {
      '1': 'state',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.SupportState',
      '10': 'state'
    },
    {
      '1': 'stopped_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoppedAt'
    },
    {'1': 'stopped_by', '3': 15, '4': 1, '5': 9, '10': 'stoppedBy'},
    {'1': 'stop_reason', '3': 16, '4': 1, '5': 9, '10': 'stopReason'},
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

/// Descriptor for `NutritionSupportPlan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nutritionSupportPlanDescriptor = $convert.base64Decode(
    'ChROdXRyaXRpb25TdXBwb3J0UGxhbhIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSHQoKcGF0aW'
    'VudF9pZBgCIAEoCVIJcGF0aWVudElkEiEKDGVuY291bnRlcl9pZBgDIAEoCVILZW5jb3VudGVy'
    'SWQSQAoEa2luZBgEIAEoDjIsLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuU3VwcG'
    '9ydEtpbmRSBGtpbmQSIQoMZm9ybXVsYV9jb2RlGAUgASgJUgtmb3JtdWxhQ29kZRIhCgxmb3Jt'
    'dWxhX25hbWUYBiABKAlSC2Zvcm11bGFOYW1lEigKEHRhcmdldF92b2x1bWVfbWwYByABKAVSDn'
    'RhcmdldFZvbHVtZU1sEiwKEnRhcmdldF9lbmVyZ3lfa2NhbBgIIAEoBVIQdGFyZ2V0RW5lcmd5'
    'S2NhbBIoChB0YXJnZXRfcHJvdGVpbl9nGAkgASgFUg50YXJnZXRQcm90ZWluRxIbCglyYW1wX3'
    'BsYW4YCiABKAlSCHJhbXBQbGFuEhsKCW9yZGVyX3JlZhgLIAEoCVIIb3JkZXJSZWYSIwoNb3Jk'
    'ZXJfY29udGV4dBgMIAEoCVIMb3JkZXJDb250ZXh0EkMKBXN0YXRlGA0gASgOMi0uaGVhbHRoY2'
    'FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5TdXBwb3J0U3RhdGVSBXN0YXRlEjkKCnN0b3BwZWRf'
    'YXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdG9wcGVkQXQSHQoKc3RvcH'
    'BlZF9ieRgPIAEoCVIJc3RvcHBlZEJ5Eh8KC3N0b3BfcmVhc29uGBAgASgJUgpzdG9wUmVhc29u'
    'EjkKCmNyZWF0ZWRfYXQYESABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdG'
    'VkQXQSHQoKY3JlYXRlZF9ieRgSIAEoCVIJY3JlYXRlZEJ5EhgKB3ZlcnNpb24YEyABKANSB3Zl'
    'cnNpb24=');

@$core.Deprecated('Use dietItemDescriptor instead')
const DietItem$json = {
  '1': 'DietItem',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'allergen_codes', '3': 3, '4': 3, '5': 9, '10': 'allergenCodes'},
  ],
};

/// Descriptor for `DietItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dietItemDescriptor = $convert.base64Decode(
    'CghEaWV0SXRlbRISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAiABKAlSBG5hbWUSJQoOYW'
    'xsZXJnZW5fY29kZXMYAyADKAlSDWFsbGVyZ2VuQ29kZXM=');

@$core.Deprecated('Use ingredientQuantityDescriptor instead')
const IngredientQuantity$json = {
  '1': 'IngredientQuantity',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'grams', '3': 3, '4': 1, '5': 5, '10': 'grams'},
  ],
};

/// Descriptor for `IngredientQuantity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingredientQuantityDescriptor = $convert.base64Decode(
    'ChJJbmdyZWRpZW50UXVhbnRpdHkSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgASgJUg'
    'RuYW1lEhQKBWdyYW1zGAMgASgFUgVncmFtcw==');

@$core.Deprecated('Use recipeDescriptor instead')
const Recipe$json = {
  '1': 'Recipe',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {
      '1': 'ingredients',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.IngredientQuantity',
      '10': 'ingredients'
    },
  ],
};

/// Descriptor for `Recipe`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recipeDescriptor = $convert.base64Decode(
    'CgZSZWNpcGUSEgoEY29kZRgBIAEoCVIEY29kZRISCgRuYW1lGAIgASgJUgRuYW1lElUKC2luZ3'
    'JlZGllbnRzGAMgAygLMjMuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5JbmdyZWRp'
    'ZW50UXVhbnRpdHlSC2luZ3JlZGllbnRz');

@$core.Deprecated('Use menuItemDescriptor instead')
const MenuItem$json = {
  '1': 'MenuItem',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
    {'1': 'texture_code', '3': 2, '4': 1, '5': 9, '10': 'textureCode'},
    {
      '1': 'recipe',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Recipe',
      '10': 'recipe'
    },
    {'1': 'portions', '3': 4, '4': 1, '5': 5, '10': 'portions'},
  ],
};

/// Descriptor for `MenuItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List menuItemDescriptor = $convert.base64Decode(
    'CghNZW51SXRlbRJACgVjeWNsZRgBIAEoDjIqLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZX'
    'QudjEuTWVhbEN5Y2xlUgVjeWNsZRIhCgx0ZXh0dXJlX2NvZGUYAiABKAlSC3RleHR1cmVDb2Rl'
    'Ej8KBnJlY2lwZRgDIAEoCzInLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuUmVjaX'
    'BlUgZyZWNpcGUSGgoIcG9ydGlvbnMYBCABKAVSCHBvcnRpb25z');

@$core.Deprecated('Use ingredientDemandDescriptor instead')
const IngredientDemand$json = {
  '1': 'IngredientDemand',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'forecast_g', '3': 3, '4': 1, '5': 5, '10': 'forecastG'},
    {'1': 'actual_g', '3': 4, '4': 1, '5': 5, '10': 'actualG'},
    {'1': 'actual_recorded', '3': 5, '4': 1, '5': 8, '10': 'actualRecorded'},
    {'1': 'wastage_g', '3': 6, '4': 1, '5': 5, '10': 'wastageG'},
    {'1': 'wastage_known', '3': 7, '4': 1, '5': 8, '10': 'wastageKnown'},
  ],
};

/// Descriptor for `IngredientDemand`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingredientDemandDescriptor = $convert.base64Decode(
    'ChBJbmdyZWRpZW50RGVtYW5kEhIKBGNvZGUYASABKAlSBGNvZGUSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRIdCgpmb3JlY2FzdF9nGAMgASgFUglmb3JlY2FzdEcSGQoIYWN0dWFsX2cYBCABKAVSB2Fj'
    'dHVhbEcSJwoPYWN0dWFsX3JlY29yZGVkGAUgASgIUg5hY3R1YWxSZWNvcmRlZBIbCgl3YXN0YW'
    'dlX2cYBiABKAVSCHdhc3RhZ2VHEiMKDXdhc3RhZ2Vfa25vd24YByABKAhSDHdhc3RhZ2VLbm93'
    'bg==');

@$core.Deprecated('Use forecastDescriptor instead')
const Forecast$json = {
  '1': 'Forecast',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
    {'1': 'census_version', '3': 2, '4': 1, '5': 5, '10': 'censusVersion'},
    {
      '1': 'cycle',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
    {
      '1': 'service_date',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'serviceDate'
    },
    {'1': 'trays', '3': 5, '4': 1, '5': 5, '10': 'trays'},
    {
      '1': 'demand',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.IngredientDemand',
      '10': 'demand'
    },
    {'1': 'uncovered', '3': 7, '4': 1, '5': 5, '10': 'uncovered'},
  ],
};

/// Descriptor for `Forecast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List forecastDescriptor = $convert.base64Decode(
    'CghGb3JlY2FzdBIbCgljZW5zdXNfaWQYASABKAlSCGNlbnN1c0lkEiUKDmNlbnN1c192ZXJzaW'
    '9uGAIgASgFUg1jZW5zdXNWZXJzaW9uEkAKBWN5Y2xlGAMgASgOMiouaGVhbHRoY2FyZS5ob3Nw'
    'aXRhbF9vcHNfZGlldC52MS5NZWFsQ3ljbGVSBWN5Y2xlEj0KDHNlcnZpY2VfZGF0ZRgEIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3NlcnZpY2VEYXRlEhQKBXRyYXlzGAUgASgF'
    'UgV0cmF5cxJJCgZkZW1hbmQYBiADKAsyMS5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0Ln'
    'YxLkluZ3JlZGllbnREZW1hbmRSBmRlbWFuZBIcCgl1bmNvdmVyZWQYByABKAVSCXVuY292ZXJl'
    'ZA==');

@$core.Deprecated('Use recordAssessmentRequestDescriptor instead')
const RecordAssessmentRequest$json = {
  '1': 'RecordAssessmentRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'anthropometry',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Anthropometry',
      '10': 'anthropometry'
    },
    {'1': 'intake_summary', '3': 5, '4': 1, '5': 9, '10': 'intakeSummary'},
    {'1': 'diagnosis_code', '3': 6, '4': 1, '5': 9, '10': 'diagnosisCode'},
    {'1': 'diagnosis', '3': 7, '4': 1, '5': 9, '10': 'diagnosis'},
    {
      '1': 'requirement',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Requirement',
      '10': 'requirement'
    },
    {'1': 'risk_tool', '3': 9, '4': 1, '5': 9, '10': 'riskTool'},
    {'1': 'risk_score', '3': 10, '4': 1, '5': 5, '10': 'riskScore'},
  ],
};

/// Descriptor for `RecordAssessmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentRequestDescriptor = $convert.base64Decode(
    'ChdSZWNvcmRBc3Nlc3NtZW50UmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBIfCgtmYWNpbGl0eV9pZBgDIAEo'
    'CVIKZmFjaWxpdHlJZBJUCg1hbnRocm9wb21ldHJ5GAQgASgLMi4uaGVhbHRoY2FyZS5ob3NwaX'
    'RhbF9vcHNfZGlldC52MS5BbnRocm9wb21ldHJ5Ug1hbnRocm9wb21ldHJ5EiUKDmludGFrZV9z'
    'dW1tYXJ5GAUgASgJUg1pbnRha2VTdW1tYXJ5EiUKDmRpYWdub3Npc19jb2RlGAYgASgJUg1kaW'
    'Fnbm9zaXNDb2RlEhwKCWRpYWdub3NpcxgHIAEoCVIJZGlhZ25vc2lzEk4KC3JlcXVpcmVtZW50'
    'GAggASgLMiwuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5SZXF1aXJlbWVudFILcm'
    'VxdWlyZW1lbnQSGwoJcmlza190b29sGAkgASgJUghyaXNrVG9vbBIdCgpyaXNrX3Njb3JlGAog'
    'ASgFUglyaXNrU2NvcmU=');

@$core.Deprecated('Use recordAssessmentResponseDescriptor instead')
const RecordAssessmentResponse$json = {
  '1': 'RecordAssessmentResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `RecordAssessmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAssessmentResponseDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRBc3Nlc3NtZW50UmVzcG9uc2USVAoKYXNzZXNzbWVudBgBIAEoCzI0LmhlYWx0aG'
    'NhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuTnV0cml0aW9uQXNzZXNzbWVudFIKYXNzZXNzbWVu'
    'dA==');

@$core.Deprecated('Use signAssessmentRequestDescriptor instead')
const SignAssessmentRequest$json = {
  '1': 'SignAssessmentRequest',
  '2': [
    {'1': 'assessment_id', '3': 1, '4': 1, '5': 9, '10': 'assessmentId'},
  ],
};

/// Descriptor for `SignAssessmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signAssessmentRequestDescriptor = $convert.base64Decode(
    'ChVTaWduQXNzZXNzbWVudFJlcXVlc3QSIwoNYXNzZXNzbWVudF9pZBgBIAEoCVIMYXNzZXNzbW'
    'VudElk');

@$core.Deprecated('Use signAssessmentResponseDescriptor instead')
const SignAssessmentResponse$json = {
  '1': 'SignAssessmentResponse',
  '2': [
    {
      '1': 'assessment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionAssessment',
      '10': 'assessment'
    },
  ],
};

/// Descriptor for `SignAssessmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List signAssessmentResponseDescriptor = $convert.base64Decode(
    'ChZTaWduQXNzZXNzbWVudFJlc3BvbnNlElQKCmFzc2Vzc21lbnQYASABKAsyNC5oZWFsdGhjYX'
    'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLk51dHJpdGlvbkFzc2Vzc21lbnRSCmFzc2Vzc21lbnQ=');

@$core.Deprecated('Use listAssessmentsRequestDescriptor instead')
const ListAssessmentsRequest$json = {
  '1': 'ListAssessmentsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'signed_only', '3': 3, '4': 1, '5': 8, '10': 'signedOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 5, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListAssessmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0QXNzZXNzbWVudHNSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IhCgxlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEh8KC3NpZ25lZF9vbmx5GAMgASgI'
    'UgpzaWduZWRPbmx5EhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpemUSHwoLcGFnZV9vZmZzZX'
    'QYBSABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listAssessmentsResponseDescriptor instead')
const ListAssessmentsResponse$json = {
  '1': 'ListAssessmentsResponse',
  '2': [
    {
      '1': 'assessments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionAssessment',
      '10': 'assessments'
    },
  ],
};

/// Descriptor for `ListAssessmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssessmentsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0QXNzZXNzbWVudHNSZXNwb25zZRJWCgthc3Nlc3NtZW50cxgBIAMoCzI0LmhlYWx0aG'
    'NhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuTnV0cml0aW9uQXNzZXNzbWVudFILYXNzZXNzbWVu'
    'dHM=');

@$core.Deprecated('Use openCarePlanRequestDescriptor instead')
const OpenCarePlanRequest$json = {
  '1': 'OpenCarePlanRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'assessment_id', '3': 3, '4': 1, '5': 9, '10': 'assessmentId'},
    {
      '1': 'goals',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionGoal',
      '10': 'goals'
    },
    {'1': 'plan', '3': 5, '4': 1, '5': 9, '10': 'plan'},
    {
      '1': 'review_due',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewDue'
    },
  ],
};

/// Descriptor for `OpenCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCarePlanRequestDescriptor = $convert.base64Decode(
    'ChNPcGVuQ2FyZVBsYW5SZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCg'
    'xlbmNvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEiMKDWFzc2Vzc21lbnRfaWQYAyABKAlS'
    'DGFzc2Vzc21lbnRJZBJECgVnb2FscxgEIAMoCzIuLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2'
    'RpZXQudjEuTnV0cml0aW9uR29hbFIFZ29hbHMSEgoEcGxhbhgFIAEoCVIEcGxhbhI5CgpyZXZp'
    'ZXdfZHVlGAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJcmV2aWV3RHVl');

@$core.Deprecated('Use openCarePlanResponseDescriptor instead')
const OpenCarePlanResponse$json = {
  '1': 'OpenCarePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.CarePlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `OpenCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCarePlanResponseDescriptor = $convert.base64Decode(
    'ChRPcGVuQ2FyZVBsYW5SZXNwb25zZRI9CgRwbGFuGAEgASgLMikuaGVhbHRoY2FyZS5ob3NwaX'
    'RhbF9vcHNfZGlldC52MS5DYXJlUGxhblIEcGxhbg==');

@$core.Deprecated('Use recordProgressRequestDescriptor instead')
const RecordProgressRequest$json = {
  '1': 'RecordProgressRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'goal_code', '3': 2, '4': 1, '5': 9, '10': 'goalCode'},
    {'1': 'value', '3': 3, '4': 1, '5': 5, '10': 'value'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'measured_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'measuredAt'
    },
  ],
};

/// Descriptor for `RecordProgressRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProgressRequestDescriptor = $convert.base64Decode(
    'ChVSZWNvcmRQcm9ncmVzc1JlcXVlc3QSFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEhsKCWdvYW'
    'xfY29kZRgCIAEoCVIIZ29hbENvZGUSFAoFdmFsdWUYAyABKAVSBXZhbHVlEhIKBG5vdGUYBCAB'
    'KAlSBG5vdGUSOwoLbWVhc3VyZWRfYXQYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW'
    '1wUgptZWFzdXJlZEF0');

@$core.Deprecated('Use recordProgressResponseDescriptor instead')
const RecordProgressResponse$json = {
  '1': 'RecordProgressResponse',
  '2': [
    {
      '1': 'progress',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Progress',
      '10': 'progress'
    },
  ],
};

/// Descriptor for `RecordProgressResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordProgressResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWNvcmRQcm9ncmVzc1Jlc3BvbnNlEkUKCHByb2dyZXNzGAEgASgLMikuaGVhbHRoY2FyZS'
        '5ob3NwaXRhbF9vcHNfZGlldC52MS5Qcm9ncmVzc1IIcHJvZ3Jlc3M=');

@$core.Deprecated('Use closeCarePlanRequestDescriptor instead')
const CloseCarePlanRequest$json = {
  '1': 'CloseCarePlanRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CloseCarePlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeCarePlanRequestDescriptor = $convert.base64Decode(
    'ChRDbG9zZUNhcmVQbGFuUmVxdWVzdBIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSEgoEbm90ZR'
    'gCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use closeCarePlanResponseDescriptor instead')
const CloseCarePlanResponse$json = {
  '1': 'CloseCarePlanResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.CarePlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `CloseCarePlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeCarePlanResponseDescriptor = $convert.base64Decode(
    'ChVDbG9zZUNhcmVQbGFuUmVzcG9uc2USPQoEcGxhbhgBIAEoCzIpLmhlYWx0aGNhcmUuaG9zcG'
    'l0YWxfb3BzX2RpZXQudjEuQ2FyZVBsYW5SBHBsYW4=');

@$core.Deprecated('Use listCarePlansRequestDescriptor instead')
const ListCarePlansRequest$json = {
  '1': 'ListCarePlansRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'open_only', '3': 2, '4': 1, '5': 8, '10': 'openOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 4, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListCarePlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0Q2FyZVBsYW5zUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSGw'
    'oJb3Blbl9vbmx5GAIgASgIUghvcGVuT25seRIbCglwYWdlX3NpemUYAyABKAVSCHBhZ2VTaXpl'
    'Eh8KC3BhZ2Vfb2Zmc2V0GAQgASgFUgpwYWdlT2Zmc2V0');

@$core.Deprecated('Use listCarePlansResponseDescriptor instead')
const ListCarePlansResponse$json = {
  '1': 'ListCarePlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.CarePlan',
      '10': 'plans'
    },
  ],
};

/// Descriptor for `ListCarePlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCarePlansResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0Q2FyZVBsYW5zUmVzcG9uc2USPwoFcGxhbnMYASADKAsyKS5oZWFsdGhjYXJlLmhvc3'
    'BpdGFsX29wc19kaWV0LnYxLkNhcmVQbGFuUgVwbGFucw==');

@$core.Deprecated('Use getGoalTrendRequestDescriptor instead')
const GetGoalTrendRequest$json = {
  '1': 'GetGoalTrendRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'goal_code', '3': 2, '4': 1, '5': 9, '10': 'goalCode'},
  ],
};

/// Descriptor for `GetGoalTrendRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalTrendRequestDescriptor = $convert.base64Decode(
    'ChNHZXRHb2FsVHJlbmRSZXF1ZXN0EhcKB3BsYW5faWQYASABKAlSBnBsYW5JZBIbCglnb2FsX2'
    'NvZGUYAiABKAlSCGdvYWxDb2Rl');

@$core.Deprecated('Use getGoalTrendResponseDescriptor instead')
const GetGoalTrendResponse$json = {
  '1': 'GetGoalTrendResponse',
  '2': [
    {
      '1': 'trend',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Trend',
      '10': 'trend'
    },
  ],
};

/// Descriptor for `GetGoalTrendResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getGoalTrendResponseDescriptor = $convert.base64Decode(
    'ChRHZXRHb2FsVHJlbmRSZXNwb25zZRI8CgV0cmVuZBgBIAEoCzImLmhlYWx0aGNhcmUuaG9zcG'
    'l0YWxfb3BzX2RpZXQudjEuVHJlbmRSBXRyZW5k');

@$core.Deprecated('Use placeDietOrderRequestDescriptor instead')
const PlaceDietOrderRequest$json = {
  '1': 'PlaceDietOrderRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'ward_id', '3': 4, '4': 1, '5': 9, '10': 'wardId'},
    {'1': 'bed_id', '3': 5, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'route',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.Route',
      '10': 'route'
    },
    {
      '1': 'texture',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Texture',
      '10': 'texture'
    },
    {'1': 'restrictions', '3': 8, '4': 3, '5': 9, '10': 'restrictions'},
    {'1': 'supplements', '3': 9, '4': 3, '5': 9, '10': 'supplements'},
    {'1': 'instruction', '3': 10, '4': 1, '5': 9, '10': 'instruction'},
    {
      '1': 'effective_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_to',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveTo'
    },
  ],
};

/// Descriptor for `PlaceDietOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeDietOrderRequestDescriptor = $convert.base64Decode(
    'ChVQbGFjZURpZXRPcmRlclJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEi'
    'EKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSHwoLZmFjaWxpdHlfaWQYAyABKAlS'
    'CmZhY2lsaXR5SWQSFwoHd2FyZF9pZBgEIAEoCVIGd2FyZElkEhUKBmJlZF9pZBgFIAEoCVIFYm'
    'VkSWQSPAoFcm91dGUYBiABKA4yJi5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLlJv'
    'dXRlUgVyb3V0ZRJCCgd0ZXh0dXJlGAcgASgLMiguaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZG'
    'lldC52MS5UZXh0dXJlUgd0ZXh0dXJlEiIKDHJlc3RyaWN0aW9ucxgIIAMoCVIMcmVzdHJpY3Rp'
    'b25zEiAKC3N1cHBsZW1lbnRzGAkgAygJUgtzdXBwbGVtZW50cxIgCgtpbnN0cnVjdGlvbhgKIA'
    'EoCVILaW5zdHJ1Y3Rpb24SQQoOZWZmZWN0aXZlX2Zyb20YCyABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEj0KDGVmZmVjdGl2ZV90bxgMIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZVRv');

@$core.Deprecated('Use placeDietOrderResponseDescriptor instead')
const PlaceDietOrderResponse$json = {
  '1': 'PlaceDietOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `PlaceDietOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeDietOrderResponseDescriptor =
    $convert.base64Decode(
        'ChZQbGFjZURpZXRPcmRlclJlc3BvbnNlEkAKBW9yZGVyGAEgASgLMiouaGVhbHRoY2FyZS5ob3'
        'NwaXRhbF9vcHNfZGlldC52MS5EaWV0T3JkZXJSBW9yZGVy');

@$core.Deprecated('Use resolveConflictRequestDescriptor instead')
const ResolveConflictRequest$json = {
  '1': 'ResolveConflictRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'allergy_ref', '3': 2, '4': 1, '5': 9, '10': 'allergyRef'},
    {'1': 'item', '3': 3, '4': 1, '5': 9, '10': 'item'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `ResolveConflictRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveConflictRequestDescriptor = $convert.base64Decode(
    'ChZSZXNvbHZlQ29uZmxpY3RSZXF1ZXN0EhkKCG9yZGVyX2lkGAEgASgJUgdvcmRlcklkEh8KC2'
    'FsbGVyZ3lfcmVmGAIgASgJUgphbGxlcmd5UmVmEhIKBGl0ZW0YAyABKAlSBGl0ZW0SEgoEbm90'
    'ZRgEIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use resolveConflictResponseDescriptor instead')
const ResolveConflictResponse$json = {
  '1': 'ResolveConflictResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `ResolveConflictResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveConflictResponseDescriptor =
    $convert.base64Decode(
        'ChdSZXNvbHZlQ29uZmxpY3RSZXNwb25zZRJACgVvcmRlchgBIAEoCzIqLmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuRGlldE9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use cancelDietOrderRequestDescriptor instead')
const CancelDietOrderRequest$json = {
  '1': 'CancelDietOrderRequest',
  '2': [
    {'1': 'order_id', '3': 1, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelDietOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelDietOrderRequestDescriptor =
    $convert.base64Decode(
        'ChZDYW5jZWxEaWV0T3JkZXJSZXF1ZXN0EhkKCG9yZGVyX2lkGAEgASgJUgdvcmRlcklkEhYKBn'
        'JlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use cancelDietOrderResponseDescriptor instead')
const CancelDietOrderResponse$json = {
  '1': 'CancelDietOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietOrder',
      '10': 'order'
    },
  ],
};

/// Descriptor for `CancelDietOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelDietOrderResponseDescriptor =
    $convert.base64Decode(
        'ChdDYW5jZWxEaWV0T3JkZXJSZXNwb25zZRJACgVvcmRlchgBIAEoCzIqLmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuRGlldE9yZGVyUgVvcmRlcg==');

@$core.Deprecated('Use getCurrentDietOrderRequestDescriptor instead')
const GetCurrentDietOrderRequest$json = {
  '1': 'GetCurrentDietOrderRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `GetCurrentDietOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentDietOrderRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRDdXJyZW50RGlldE9yZGVyUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW'
        '50SWQ=');

@$core.Deprecated('Use getCurrentDietOrderResponseDescriptor instead')
const GetCurrentDietOrderResponse$json = {
  '1': 'GetCurrentDietOrderResponse',
  '2': [
    {
      '1': 'order',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietOrder',
      '10': 'order'
    },
    {'1': 'found', '3': 2, '4': 1, '5': 8, '10': 'found'},
  ],
};

/// Descriptor for `GetCurrentDietOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCurrentDietOrderResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRDdXJyZW50RGlldE9yZGVyUmVzcG9uc2USQAoFb3JkZXIYASABKAsyKi5oZWFsdGhjYX'
        'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLkRpZXRPcmRlclIFb3JkZXISFAoFZm91bmQYAiABKAhS'
        'BWZvdW5k');

@$core.Deprecated('Use listDietOrdersRequestDescriptor instead')
const ListDietOrdersRequest$json = {
  '1': 'ListDietOrdersRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `ListDietOrdersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDietOrdersRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RGlldE9yZGVyc1JlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElk');

@$core.Deprecated('Use listDietOrdersResponseDescriptor instead')
const ListDietOrdersResponse$json = {
  '1': 'ListDietOrdersResponse',
  '2': [
    {
      '1': 'orders',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietOrder',
      '10': 'orders'
    },
  ],
};

/// Descriptor for `ListDietOrdersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listDietOrdersResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0RGlldE9yZGVyc1Jlc3BvbnNlEkIKBm9yZGVycxgBIAMoCzIqLmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuRGlldE9yZGVyUgZvcmRlcnM=');

@$core.Deprecated('Use planNutritionSupportRequestDescriptor instead')
const PlanNutritionSupportRequest$json = {
  '1': 'PlanNutritionSupportRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.SupportKind',
      '10': 'kind'
    },
    {'1': 'formula_code', '3': 4, '4': 1, '5': 9, '10': 'formulaCode'},
    {'1': 'formula_name', '3': 5, '4': 1, '5': 9, '10': 'formulaName'},
    {'1': 'target_volume_ml', '3': 6, '4': 1, '5': 5, '10': 'targetVolumeMl'},
    {
      '1': 'target_energy_kcal',
      '3': 7,
      '4': 1,
      '5': 5,
      '10': 'targetEnergyKcal'
    },
    {'1': 'target_protein_g', '3': 8, '4': 1, '5': 5, '10': 'targetProteinG'},
    {'1': 'ramp_plan', '3': 9, '4': 1, '5': 9, '10': 'rampPlan'},
  ],
};

/// Descriptor for `PlanNutritionSupportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planNutritionSupportRequestDescriptor = $convert.base64Decode(
    'ChtQbGFuTnV0cml0aW9uU3VwcG9ydFJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aW'
    'VudElkEiEKDGVuY291bnRlcl9pZBgCIAEoCVILZW5jb3VudGVySWQSQAoEa2luZBgDIAEoDjIs'
    'LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuU3VwcG9ydEtpbmRSBGtpbmQSIQoMZm'
    '9ybXVsYV9jb2RlGAQgASgJUgtmb3JtdWxhQ29kZRIhCgxmb3JtdWxhX25hbWUYBSABKAlSC2Zv'
    'cm11bGFOYW1lEigKEHRhcmdldF92b2x1bWVfbWwYBiABKAVSDnRhcmdldFZvbHVtZU1sEiwKEn'
    'RhcmdldF9lbmVyZ3lfa2NhbBgHIAEoBVIQdGFyZ2V0RW5lcmd5S2NhbBIoChB0YXJnZXRfcHJv'
    'dGVpbl9nGAggASgFUg50YXJnZXRQcm90ZWluRxIbCglyYW1wX3BsYW4YCSABKAlSCHJhbXBQbG'
    'Fu');

@$core.Deprecated('Use planNutritionSupportResponseDescriptor instead')
const PlanNutritionSupportResponse$json = {
  '1': 'PlanNutritionSupportResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionSupportPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `PlanNutritionSupportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planNutritionSupportResponseDescriptor =
    $convert.base64Decode(
        'ChxQbGFuTnV0cml0aW9uU3VwcG9ydFJlc3BvbnNlEkkKBHBsYW4YASABKAsyNS5oZWFsdGhjYX'
        'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLk51dHJpdGlvblN1cHBvcnRQbGFuUgRwbGFu');

@$core.Deprecated('Use linkSupportOrderRequestDescriptor instead')
const LinkSupportOrderRequest$json = {
  '1': 'LinkSupportOrderRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'order_ref', '3': 2, '4': 1, '5': 9, '10': 'orderRef'},
    {'1': 'order_context', '3': 3, '4': 1, '5': 9, '10': 'orderContext'},
  ],
};

/// Descriptor for `LinkSupportOrderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkSupportOrderRequestDescriptor = $convert.base64Decode(
    'ChdMaW5rU3VwcG9ydE9yZGVyUmVxdWVzdBIXCgdwbGFuX2lkGAEgASgJUgZwbGFuSWQSGwoJb3'
    'JkZXJfcmVmGAIgASgJUghvcmRlclJlZhIjCg1vcmRlcl9jb250ZXh0GAMgASgJUgxvcmRlckNv'
    'bnRleHQ=');

@$core.Deprecated('Use linkSupportOrderResponseDescriptor instead')
const LinkSupportOrderResponse$json = {
  '1': 'LinkSupportOrderResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionSupportPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `LinkSupportOrderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkSupportOrderResponseDescriptor =
    $convert.base64Decode(
        'ChhMaW5rU3VwcG9ydE9yZGVyUmVzcG9uc2USSQoEcGxhbhgBIAEoCzI1LmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuTnV0cml0aW9uU3VwcG9ydFBsYW5SBHBsYW4=');

@$core.Deprecated('Use stopSupportRequestDescriptor instead')
const StopSupportRequest$json = {
  '1': 'StopSupportRequest',
  '2': [
    {'1': 'plan_id', '3': 1, '4': 1, '5': 9, '10': 'planId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `StopSupportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSupportRequestDescriptor = $convert.base64Decode(
    'ChJTdG9wU3VwcG9ydFJlcXVlc3QSFwoHcGxhbl9pZBgBIAEoCVIGcGxhbklkEhYKBnJlYXNvbh'
    'gCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use stopSupportResponseDescriptor instead')
const StopSupportResponse$json = {
  '1': 'StopSupportResponse',
  '2': [
    {
      '1': 'plan',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionSupportPlan',
      '10': 'plan'
    },
  ],
};

/// Descriptor for `StopSupportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopSupportResponseDescriptor = $convert.base64Decode(
    'ChNTdG9wU3VwcG9ydFJlc3BvbnNlEkkKBHBsYW4YASABKAsyNS5oZWFsdGhjYXJlLmhvc3BpdG'
    'FsX29wc19kaWV0LnYxLk51dHJpdGlvblN1cHBvcnRQbGFuUgRwbGFu');

@$core.Deprecated('Use listSupportPlansRequestDescriptor instead')
const ListSupportPlansRequest$json = {
  '1': 'ListSupportPlansRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'active_only', '3': 2, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 4, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListSupportPlansRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSupportPlansRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0U3VwcG9ydFBsYW5zUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSHwoLYWN0aXZlX29ubHkYAiABKAhSCmFjdGl2ZU9ubHkSGwoJcGFnZV9zaXplGAMgASgFUghw'
    'YWdlU2l6ZRIfCgtwYWdlX29mZnNldBgEIAEoBVIKcGFnZU9mZnNldA==');

@$core.Deprecated('Use listSupportPlansResponseDescriptor instead')
const ListSupportPlansResponse$json = {
  '1': 'ListSupportPlansResponse',
  '2': [
    {
      '1': 'plans',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.NutritionSupportPlan',
      '10': 'plans'
    },
  ],
};

/// Descriptor for `ListSupportPlansResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSupportPlansResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0U3VwcG9ydFBsYW5zUmVzcG9uc2USSwoFcGxhbnMYASADKAsyNS5oZWFsdGhjYXJlLm'
        'hvc3BpdGFsX29wc19kaWV0LnYxLk51dHJpdGlvblN1cHBvcnRQbGFuUgVwbGFucw==');

@$core.Deprecated('Use buildCensusRequestDescriptor instead')
const BuildCensusRequest$json = {
  '1': 'BuildCensusRequest',
  '2': [
    {'1': 'ward_id', '3': 1, '4': 1, '5': 9, '10': 'wardId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'cycle',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
    {
      '1': 'service_date',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'serviceDate'
    },
    {
      '1': 'cutoff_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'cutoffAt'
    },
  ],
};

/// Descriptor for `BuildCensusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buildCensusRequestDescriptor = $convert.base64Decode(
    'ChJCdWlsZENlbnN1c1JlcXVlc3QSFwoHd2FyZF9pZBgBIAEoCVIGd2FyZElkEh8KC2ZhY2lsaX'
    'R5X2lkGAIgASgJUgpmYWNpbGl0eUlkEkAKBWN5Y2xlGAMgASgOMiouaGVhbHRoY2FyZS5ob3Nw'
    'aXRhbF9vcHNfZGlldC52MS5NZWFsQ3ljbGVSBWN5Y2xlEj0KDHNlcnZpY2VfZGF0ZRgEIAEoCz'
    'IaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3NlcnZpY2VEYXRlEjcKCWN1dG9mZl9hdBgF'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCGN1dG9mZkF0');

@$core.Deprecated('Use buildCensusResponseDescriptor instead')
const BuildCensusResponse$json = {
  '1': 'BuildCensusResponse',
  '2': [
    {
      '1': 'census',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MealCensus',
      '10': 'census'
    },
  ],
};

/// Descriptor for `BuildCensusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List buildCensusResponseDescriptor = $convert.base64Decode(
    'ChNCdWlsZENlbnN1c1Jlc3BvbnNlEkMKBmNlbnN1cxgBIAEoCzIrLmhlYWx0aGNhcmUuaG9zcG'
    'l0YWxfb3BzX2RpZXQudjEuTWVhbENlbnN1c1IGY2Vuc3Vz');

@$core.Deprecated('Use freezeCensusRequestDescriptor instead')
const FreezeCensusRequest$json = {
  '1': 'FreezeCensusRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
  ],
};

/// Descriptor for `FreezeCensusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezeCensusRequestDescriptor =
    $convert.base64Decode(
        'ChNGcmVlemVDZW5zdXNSZXF1ZXN0EhsKCWNlbnN1c19pZBgBIAEoCVIIY2Vuc3VzSWQ=');

@$core.Deprecated('Use freezeCensusResponseDescriptor instead')
const FreezeCensusResponse$json = {
  '1': 'FreezeCensusResponse',
  '2': [
    {
      '1': 'census',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MealCensus',
      '10': 'census'
    },
  ],
};

/// Descriptor for `FreezeCensusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List freezeCensusResponseDescriptor = $convert.base64Decode(
    'ChRGcmVlemVDZW5zdXNSZXNwb25zZRJDCgZjZW5zdXMYASABKAsyKy5oZWFsdGhjYXJlLmhvc3'
    'BpdGFsX29wc19kaWV0LnYxLk1lYWxDZW5zdXNSBmNlbnN1cw==');

@$core.Deprecated('Use reissueCensusRequestDescriptor instead')
const ReissueCensusRequest$json = {
  '1': 'ReissueCensusRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
  ],
};

/// Descriptor for `ReissueCensusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reissueCensusRequestDescriptor =
    $convert.base64Decode(
        'ChRSZWlzc3VlQ2Vuc3VzUmVxdWVzdBIbCgljZW5zdXNfaWQYASABKAlSCGNlbnN1c0lk');

@$core.Deprecated('Use reissueCensusResponseDescriptor instead')
const ReissueCensusResponse$json = {
  '1': 'ReissueCensusResponse',
  '2': [
    {
      '1': 'census',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MealCensus',
      '10': 'census'
    },
  ],
};

/// Descriptor for `ReissueCensusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reissueCensusResponseDescriptor = $convert.base64Decode(
    'ChVSZWlzc3VlQ2Vuc3VzUmVzcG9uc2USQwoGY2Vuc3VzGAEgASgLMisuaGVhbHRoY2FyZS5ob3'
    'NwaXRhbF9vcHNfZGlldC52MS5NZWFsQ2Vuc3VzUgZjZW5zdXM=');

@$core.Deprecated('Use listCensusesRequestDescriptor instead')
const ListCensusesRequest$json = {
  '1': 'ListCensusesRequest',
  '2': [
    {'1': 'ward_id', '3': 1, '4': 1, '5': 9, '10': 'wardId'},
    {
      '1': 'cycle',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
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

/// Descriptor for `ListCensusesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCensusesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0Q2Vuc3VzZXNSZXF1ZXN0EhcKB3dhcmRfaWQYASABKAlSBndhcmRJZBJACgVjeWNsZR'
    'gCIAEoDjIqLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuTWVhbEN5Y2xlUgVjeWNs'
    'ZRIuCgRmcm9tGAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bx'
    'gEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgFIAEo'
    'BVIIcGFnZVNpemUSHwoLcGFnZV9vZmZzZXQYBiABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listCensusesResponseDescriptor instead')
const ListCensusesResponse$json = {
  '1': 'ListCensusesResponse',
  '2': [
    {
      '1': 'censuses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MealCensus',
      '10': 'censuses'
    },
  ],
};

/// Descriptor for `ListCensusesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCensusesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0Q2Vuc3VzZXNSZXNwb25zZRJHCghjZW5zdXNlcxgBIAMoCzIrLmhlYWx0aGNhcmUuaG'
    '9zcGl0YWxfb3BzX2RpZXQudjEuTWVhbENlbnN1c1IIY2Vuc3VzZXM=');

@$core.Deprecated('Use plateTraysRequestDescriptor instead')
const PlateTraysRequest$json = {
  '1': 'PlateTraysRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
  ],
};

/// Descriptor for `PlateTraysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List plateTraysRequestDescriptor = $convert.base64Decode(
    'ChFQbGF0ZVRyYXlzUmVxdWVzdBIbCgljZW5zdXNfaWQYASABKAlSCGNlbnN1c0lk');

@$core.Deprecated('Use plateTraysResponseDescriptor instead')
const PlateTraysResponse$json = {
  '1': 'PlateTraysResponse',
  '2': [
    {
      '1': 'trays',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'trays'
    },
  ],
};

/// Descriptor for `PlateTraysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List plateTraysResponseDescriptor = $convert.base64Decode(
    'ChJQbGF0ZVRyYXlzUmVzcG9uc2USOwoFdHJheXMYASADKAsyJS5oZWFsdGhjYXJlLmhvc3BpdG'
    'FsX29wc19kaWV0LnYxLlRyYXlSBXRyYXlz');

@$core.Deprecated('Use prepareTrayRequestDescriptor instead')
const PrepareTrayRequest$json = {
  '1': 'PrepareTrayRequest',
  '2': [
    {'1': 'tray_id', '3': 1, '4': 1, '5': 9, '10': 'trayId'},
  ],
};

/// Descriptor for `PrepareTrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prepareTrayRequestDescriptor =
    $convert.base64Decode(
        'ChJQcmVwYXJlVHJheVJlcXVlc3QSFwoHdHJheV9pZBgBIAEoCVIGdHJheUlk');

@$core.Deprecated('Use prepareTrayResponseDescriptor instead')
const PrepareTrayResponse$json = {
  '1': 'PrepareTrayResponse',
  '2': [
    {
      '1': 'tray',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'tray'
    },
  ],
};

/// Descriptor for `PrepareTrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prepareTrayResponseDescriptor = $convert.base64Decode(
    'ChNQcmVwYXJlVHJheVJlc3BvbnNlEjkKBHRyYXkYASABKAsyJS5oZWFsdGhjYXJlLmhvc3BpdG'
    'FsX29wc19kaWV0LnYxLlRyYXlSBHRyYXk=');

@$core.Deprecated('Use dispatchTrayRequestDescriptor instead')
const DispatchTrayRequest$json = {
  '1': 'DispatchTrayRequest',
  '2': [
    {'1': 'tray_id', '3': 1, '4': 1, '5': 9, '10': 'trayId'},
  ],
};

/// Descriptor for `DispatchTrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchTrayRequestDescriptor =
    $convert.base64Decode(
        'ChNEaXNwYXRjaFRyYXlSZXF1ZXN0EhcKB3RyYXlfaWQYASABKAlSBnRyYXlJZA==');

@$core.Deprecated('Use dispatchTrayResponseDescriptor instead')
const DispatchTrayResponse$json = {
  '1': 'DispatchTrayResponse',
  '2': [
    {
      '1': 'tray',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'tray'
    },
  ],
};

/// Descriptor for `DispatchTrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispatchTrayResponseDescriptor = $convert.base64Decode(
    'ChREaXNwYXRjaFRyYXlSZXNwb25zZRI5CgR0cmF5GAEgASgLMiUuaGVhbHRoY2FyZS5ob3NwaX'
    'RhbF9vcHNfZGlldC52MS5UcmF5UgR0cmF5');

@$core.Deprecated('Use deliverTrayRequestDescriptor instead')
const DeliverTrayRequest$json = {
  '1': 'DeliverTrayRequest',
  '2': [
    {'1': 'tray_id', '3': 1, '4': 1, '5': 9, '10': 'trayId'},
  ],
};

/// Descriptor for `DeliverTrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deliverTrayRequestDescriptor =
    $convert.base64Decode(
        'ChJEZWxpdmVyVHJheVJlcXVlc3QSFwoHdHJheV9pZBgBIAEoCVIGdHJheUlk');

@$core.Deprecated('Use deliverTrayResponseDescriptor instead')
const DeliverTrayResponse$json = {
  '1': 'DeliverTrayResponse',
  '2': [
    {
      '1': 'tray',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'tray'
    },
  ],
};

/// Descriptor for `DeliverTrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deliverTrayResponseDescriptor = $convert.base64Decode(
    'ChNEZWxpdmVyVHJheVJlc3BvbnNlEjkKBHRyYXkYASABKAsyJS5oZWFsdGhjYXJlLmhvc3BpdG'
    'FsX29wc19kaWV0LnYxLlRyYXlSBHRyYXk=');

@$core.Deprecated('Use closeTrayRequestDescriptor instead')
const CloseTrayRequest$json = {
  '1': 'CloseTrayRequest',
  '2': [
    {'1': 'tray_id', '3': 1, '4': 1, '5': 9, '10': 'trayId'},
    {
      '1': 'state',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.TrayState',
      '10': 'state'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CloseTrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeTrayRequestDescriptor = $convert.base64Decode(
    'ChBDbG9zZVRyYXlSZXF1ZXN0EhcKB3RyYXlfaWQYASABKAlSBnRyYXlJZBJACgVzdGF0ZRgCIA'
    'EoDjIqLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuVHJheVN0YXRlUgVzdGF0ZRIW'
    'CgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use closeTrayResponseDescriptor instead')
const CloseTrayResponse$json = {
  '1': 'CloseTrayResponse',
  '2': [
    {
      '1': 'tray',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'tray'
    },
  ],
};

/// Descriptor for `CloseTrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List closeTrayResponseDescriptor = $convert.base64Decode(
    'ChFDbG9zZVRyYXlSZXNwb25zZRI5CgR0cmF5GAEgASgLMiUuaGVhbHRoY2FyZS5ob3NwaXRhbF'
    '9vcHNfZGlldC52MS5UcmF5UgR0cmF5');

@$core.Deprecated('Use listTraysRequestDescriptor instead')
const ListTraysRequest$json = {
  '1': 'ListTraysRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
    {'1': 'ward_id', '3': 2, '4': 1, '5': 9, '10': 'wardId'},
    {
      '1': 'state',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.TrayState',
      '10': 'state'
    },
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_offset', '3': 5, '4': 1, '5': 5, '10': 'pageOffset'},
  ],
};

/// Descriptor for `ListTraysRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTraysRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0VHJheXNSZXF1ZXN0EhsKCWNlbnN1c19pZBgBIAEoCVIIY2Vuc3VzSWQSFwoHd2FyZF'
    '9pZBgCIAEoCVIGd2FyZElkEkAKBXN0YXRlGAMgASgOMiouaGVhbHRoY2FyZS5ob3NwaXRhbF9v'
    'cHNfZGlldC52MS5UcmF5U3RhdGVSBXN0YXRlEhsKCXBhZ2Vfc2l6ZRgEIAEoBVIIcGFnZVNpem'
    'USHwoLcGFnZV9vZmZzZXQYBSABKAVSCnBhZ2VPZmZzZXQ=');

@$core.Deprecated('Use listTraysResponseDescriptor instead')
const ListTraysResponse$json = {
  '1': 'ListTraysResponse',
  '2': [
    {
      '1': 'trays',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Tray',
      '10': 'trays'
    },
  ],
};

/// Descriptor for `ListTraysResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTraysResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0VHJheXNSZXNwb25zZRI7CgV0cmF5cxgBIAMoCzIlLmhlYWx0aGNhcmUuaG9zcGl0YW'
    'xfb3BzX2RpZXQudjEuVHJheVIFdHJheXM=');

@$core.Deprecated('Use getMealOutcomeRequestDescriptor instead')
const GetMealOutcomeRequest$json = {
  '1': 'GetMealOutcomeRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
  ],
};

/// Descriptor for `GetMealOutcomeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMealOutcomeRequestDescriptor = $convert.base64Decode(
    'ChVHZXRNZWFsT3V0Y29tZVJlcXVlc3QSGwoJY2Vuc3VzX2lkGAEgASgJUghjZW5zdXNJZA==');

@$core.Deprecated('Use getMealOutcomeResponseDescriptor instead')
const GetMealOutcomeResponse$json = {
  '1': 'GetMealOutcomeResponse',
  '2': [
    {
      '1': 'outcome',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MealOutcome',
      '10': 'outcome'
    },
  ],
};

/// Descriptor for `GetMealOutcomeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMealOutcomeResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRNZWFsT3V0Y29tZVJlc3BvbnNlEkYKB291dGNvbWUYASABKAsyLC5oZWFsdGhjYXJlLm'
        'hvc3BpdGFsX29wc19kaWV0LnYxLk1lYWxPdXRjb21lUgdvdXRjb21l');

@$core.Deprecated('Use configureItemRequestDescriptor instead')
const ConfigureItemRequest$json = {
  '1': 'ConfigureItemRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.DietItem',
      '10': 'item'
    },
    {'1': 'kind', '3': 2, '4': 1, '5': 9, '10': 'kind'},
  ],
};

/// Descriptor for `ConfigureItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureItemRequestDescriptor = $convert.base64Decode(
    'ChRDb25maWd1cmVJdGVtUmVxdWVzdBI9CgRpdGVtGAEgASgLMikuaGVhbHRoY2FyZS5ob3NwaX'
    'RhbF9vcHNfZGlldC52MS5EaWV0SXRlbVIEaXRlbRISCgRraW5kGAIgASgJUgRraW5k');

@$core.Deprecated('Use configureItemResponseDescriptor instead')
const ConfigureItemResponse$json = {
  '1': 'ConfigureItemResponse',
};

/// Descriptor for `ConfigureItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureItemResponseDescriptor =
    $convert.base64Decode('ChVDb25maWd1cmVJdGVtUmVzcG9uc2U=');

@$core.Deprecated('Use configureRecipeRequestDescriptor instead')
const ConfigureRecipeRequest$json = {
  '1': 'ConfigureRecipeRequest',
  '2': [
    {
      '1': 'recipe',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Recipe',
      '10': 'recipe'
    },
  ],
};

/// Descriptor for `ConfigureRecipeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureRecipeRequestDescriptor =
    $convert.base64Decode(
        'ChZDb25maWd1cmVSZWNpcGVSZXF1ZXN0Ej8KBnJlY2lwZRgBIAEoCzInLmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuUmVjaXBlUgZyZWNpcGU=');

@$core.Deprecated('Use configureRecipeResponseDescriptor instead')
const ConfigureRecipeResponse$json = {
  '1': 'ConfigureRecipeResponse',
};

/// Descriptor for `ConfigureRecipeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureRecipeResponseDescriptor =
    $convert.base64Decode('ChdDb25maWd1cmVSZWNpcGVSZXNwb25zZQ==');

@$core.Deprecated('Use configureMenuItemRequestDescriptor instead')
const ConfigureMenuItemRequest$json = {
  '1': 'ConfigureMenuItemRequest',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MenuItem',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ConfigureMenuItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureMenuItemRequestDescriptor =
    $convert.base64Decode(
        'ChhDb25maWd1cmVNZW51SXRlbVJlcXVlc3QSPQoEaXRlbRgBIAEoCzIpLmhlYWx0aGNhcmUuaG'
        '9zcGl0YWxfb3BzX2RpZXQudjEuTWVudUl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use configureMenuItemResponseDescriptor instead')
const ConfigureMenuItemResponse$json = {
  '1': 'ConfigureMenuItemResponse',
};

/// Descriptor for `ConfigureMenuItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List configureMenuItemResponseDescriptor =
    $convert.base64Decode('ChlDb25maWd1cmVNZW51SXRlbVJlc3BvbnNl');

@$core.Deprecated('Use listMenuRequestDescriptor instead')
const ListMenuRequest$json = {
  '1': 'ListMenuRequest',
  '2': [
    {
      '1': 'cycle',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.hospital_ops_diet.v1.MealCycle',
      '10': 'cycle'
    },
  ],
};

/// Descriptor for `ListMenuRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMenuRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0TWVudVJlcXVlc3QSQAoFY3ljbGUYASABKA4yKi5oZWFsdGhjYXJlLmhvc3BpdGFsX2'
    '9wc19kaWV0LnYxLk1lYWxDeWNsZVIFY3ljbGU=');

@$core.Deprecated('Use listMenuResponseDescriptor instead')
const ListMenuResponse$json = {
  '1': 'ListMenuResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.MenuItem',
      '10': 'items'
    },
  ],
};

/// Descriptor for `ListMenuResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listMenuResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0TWVudVJlc3BvbnNlEj8KBWl0ZW1zGAEgAygLMikuaGVhbHRoY2FyZS5ob3NwaXRhbF'
    '9vcHNfZGlldC52MS5NZW51SXRlbVIFaXRlbXM=');

@$core.Deprecated('Use recordConsumptionRequestDescriptor instead')
const RecordConsumptionRequest$json = {
  '1': 'RecordConsumptionRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
    {'1': 'ingredient_code', '3': 2, '4': 1, '5': 9, '10': 'ingredientCode'},
    {'1': 'actual_g', '3': 3, '4': 1, '5': 5, '10': 'actualG'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordConsumptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordConsumptionRequestDescriptor = $convert.base64Decode(
    'ChhSZWNvcmRDb25zdW1wdGlvblJlcXVlc3QSGwoJY2Vuc3VzX2lkGAEgASgJUghjZW5zdXNJZB'
    'InCg9pbmdyZWRpZW50X2NvZGUYAiABKAlSDmluZ3JlZGllbnRDb2RlEhkKCGFjdHVhbF9nGAMg'
    'ASgFUgdhY3R1YWxHEhIKBG5vdGUYBCABKAlSBG5vdGU=');

@$core.Deprecated('Use recordConsumptionResponseDescriptor instead')
const RecordConsumptionResponse$json = {
  '1': 'RecordConsumptionResponse',
  '2': [
    {
      '1': 'counted',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.IngredientQuantity',
      '10': 'counted'
    },
  ],
};

/// Descriptor for `RecordConsumptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordConsumptionResponseDescriptor =
    $convert.base64Decode(
        'ChlSZWNvcmRDb25zdW1wdGlvblJlc3BvbnNlEk0KB2NvdW50ZWQYASABKAsyMy5oZWFsdGhjYX'
        'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLkluZ3JlZGllbnRRdWFudGl0eVIHY291bnRlZA==');

@$core.Deprecated('Use getIngredientForecastRequestDescriptor instead')
const GetIngredientForecastRequest$json = {
  '1': 'GetIngredientForecastRequest',
  '2': [
    {'1': 'census_id', '3': 1, '4': 1, '5': 9, '10': 'censusId'},
  ],
};

/// Descriptor for `GetIngredientForecastRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIngredientForecastRequestDescriptor =
    $convert.base64Decode(
        'ChxHZXRJbmdyZWRpZW50Rm9yZWNhc3RSZXF1ZXN0EhsKCWNlbnN1c19pZBgBIAEoCVIIY2Vuc3'
        'VzSWQ=');

@$core.Deprecated('Use getIngredientForecastResponseDescriptor instead')
const GetIngredientForecastResponse$json = {
  '1': 'GetIngredientForecastResponse',
  '2': [
    {
      '1': 'forecast',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.hospital_ops_diet.v1.Forecast',
      '10': 'forecast'
    },
  ],
};

/// Descriptor for `GetIngredientForecastResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIngredientForecastResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRJbmdyZWRpZW50Rm9yZWNhc3RSZXNwb25zZRJFCghmb3JlY2FzdBgBIAEoCzIpLmhlYW'
        'x0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuRm9yZWNhc3RSCGZvcmVjYXN0');

const $core.Map<$core.String, $core.dynamic> DietServiceBase$json = {
  '1': 'DietService',
  '2': [
    {
      '1': 'RecordAssessment',
      '2': '.healthcare.hospital_ops_diet.v1.RecordAssessmentRequest',
      '3': '.healthcare.hospital_ops_diet.v1.RecordAssessmentResponse'
    },
    {
      '1': 'SignAssessment',
      '2': '.healthcare.hospital_ops_diet.v1.SignAssessmentRequest',
      '3': '.healthcare.hospital_ops_diet.v1.SignAssessmentResponse'
    },
    {
      '1': 'ListAssessments',
      '2': '.healthcare.hospital_ops_diet.v1.ListAssessmentsRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListAssessmentsResponse'
    },
    {
      '1': 'OpenCarePlan',
      '2': '.healthcare.hospital_ops_diet.v1.OpenCarePlanRequest',
      '3': '.healthcare.hospital_ops_diet.v1.OpenCarePlanResponse'
    },
    {
      '1': 'RecordProgress',
      '2': '.healthcare.hospital_ops_diet.v1.RecordProgressRequest',
      '3': '.healthcare.hospital_ops_diet.v1.RecordProgressResponse'
    },
    {
      '1': 'CloseCarePlan',
      '2': '.healthcare.hospital_ops_diet.v1.CloseCarePlanRequest',
      '3': '.healthcare.hospital_ops_diet.v1.CloseCarePlanResponse'
    },
    {
      '1': 'ListCarePlans',
      '2': '.healthcare.hospital_ops_diet.v1.ListCarePlansRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListCarePlansResponse'
    },
    {
      '1': 'GetGoalTrend',
      '2': '.healthcare.hospital_ops_diet.v1.GetGoalTrendRequest',
      '3': '.healthcare.hospital_ops_diet.v1.GetGoalTrendResponse'
    },
    {
      '1': 'PlaceDietOrder',
      '2': '.healthcare.hospital_ops_diet.v1.PlaceDietOrderRequest',
      '3': '.healthcare.hospital_ops_diet.v1.PlaceDietOrderResponse'
    },
    {
      '1': 'ResolveConflict',
      '2': '.healthcare.hospital_ops_diet.v1.ResolveConflictRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ResolveConflictResponse'
    },
    {
      '1': 'CancelDietOrder',
      '2': '.healthcare.hospital_ops_diet.v1.CancelDietOrderRequest',
      '3': '.healthcare.hospital_ops_diet.v1.CancelDietOrderResponse'
    },
    {
      '1': 'GetCurrentDietOrder',
      '2': '.healthcare.hospital_ops_diet.v1.GetCurrentDietOrderRequest',
      '3': '.healthcare.hospital_ops_diet.v1.GetCurrentDietOrderResponse'
    },
    {
      '1': 'ListDietOrders',
      '2': '.healthcare.hospital_ops_diet.v1.ListDietOrdersRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListDietOrdersResponse'
    },
    {
      '1': 'PlanNutritionSupport',
      '2': '.healthcare.hospital_ops_diet.v1.PlanNutritionSupportRequest',
      '3': '.healthcare.hospital_ops_diet.v1.PlanNutritionSupportResponse'
    },
    {
      '1': 'LinkSupportOrder',
      '2': '.healthcare.hospital_ops_diet.v1.LinkSupportOrderRequest',
      '3': '.healthcare.hospital_ops_diet.v1.LinkSupportOrderResponse'
    },
    {
      '1': 'StopSupport',
      '2': '.healthcare.hospital_ops_diet.v1.StopSupportRequest',
      '3': '.healthcare.hospital_ops_diet.v1.StopSupportResponse'
    },
    {
      '1': 'ListSupportPlans',
      '2': '.healthcare.hospital_ops_diet.v1.ListSupportPlansRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListSupportPlansResponse'
    },
    {
      '1': 'BuildCensus',
      '2': '.healthcare.hospital_ops_diet.v1.BuildCensusRequest',
      '3': '.healthcare.hospital_ops_diet.v1.BuildCensusResponse'
    },
    {
      '1': 'FreezeCensus',
      '2': '.healthcare.hospital_ops_diet.v1.FreezeCensusRequest',
      '3': '.healthcare.hospital_ops_diet.v1.FreezeCensusResponse'
    },
    {
      '1': 'ReissueCensus',
      '2': '.healthcare.hospital_ops_diet.v1.ReissueCensusRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ReissueCensusResponse'
    },
    {
      '1': 'ListCensuses',
      '2': '.healthcare.hospital_ops_diet.v1.ListCensusesRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListCensusesResponse'
    },
    {
      '1': 'PlateTrays',
      '2': '.healthcare.hospital_ops_diet.v1.PlateTraysRequest',
      '3': '.healthcare.hospital_ops_diet.v1.PlateTraysResponse'
    },
    {
      '1': 'PrepareTray',
      '2': '.healthcare.hospital_ops_diet.v1.PrepareTrayRequest',
      '3': '.healthcare.hospital_ops_diet.v1.PrepareTrayResponse'
    },
    {
      '1': 'DispatchTray',
      '2': '.healthcare.hospital_ops_diet.v1.DispatchTrayRequest',
      '3': '.healthcare.hospital_ops_diet.v1.DispatchTrayResponse'
    },
    {
      '1': 'DeliverTray',
      '2': '.healthcare.hospital_ops_diet.v1.DeliverTrayRequest',
      '3': '.healthcare.hospital_ops_diet.v1.DeliverTrayResponse'
    },
    {
      '1': 'CloseTray',
      '2': '.healthcare.hospital_ops_diet.v1.CloseTrayRequest',
      '3': '.healthcare.hospital_ops_diet.v1.CloseTrayResponse'
    },
    {
      '1': 'ListTrays',
      '2': '.healthcare.hospital_ops_diet.v1.ListTraysRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListTraysResponse'
    },
    {
      '1': 'GetMealOutcome',
      '2': '.healthcare.hospital_ops_diet.v1.GetMealOutcomeRequest',
      '3': '.healthcare.hospital_ops_diet.v1.GetMealOutcomeResponse'
    },
    {
      '1': 'ConfigureItem',
      '2': '.healthcare.hospital_ops_diet.v1.ConfigureItemRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ConfigureItemResponse'
    },
    {
      '1': 'ConfigureRecipe',
      '2': '.healthcare.hospital_ops_diet.v1.ConfigureRecipeRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ConfigureRecipeResponse'
    },
    {
      '1': 'ConfigureMenuItem',
      '2': '.healthcare.hospital_ops_diet.v1.ConfigureMenuItemRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ConfigureMenuItemResponse'
    },
    {
      '1': 'ListMenu',
      '2': '.healthcare.hospital_ops_diet.v1.ListMenuRequest',
      '3': '.healthcare.hospital_ops_diet.v1.ListMenuResponse'
    },
    {
      '1': 'RecordConsumption',
      '2': '.healthcare.hospital_ops_diet.v1.RecordConsumptionRequest',
      '3': '.healthcare.hospital_ops_diet.v1.RecordConsumptionResponse'
    },
    {
      '1': 'GetIngredientForecast',
      '2': '.healthcare.hospital_ops_diet.v1.GetIngredientForecastRequest',
      '3': '.healthcare.hospital_ops_diet.v1.GetIngredientForecastResponse'
    },
  ],
};

@$core.Deprecated('Use dietServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    DietServiceBase$messageJson = {
  '.healthcare.hospital_ops_diet.v1.RecordAssessmentRequest':
      RecordAssessmentRequest$json,
  '.healthcare.hospital_ops_diet.v1.Anthropometry': Anthropometry$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.hospital_ops_diet.v1.Requirement': Requirement$json,
  '.healthcare.hospital_ops_diet.v1.RecordAssessmentResponse':
      RecordAssessmentResponse$json,
  '.healthcare.hospital_ops_diet.v1.NutritionAssessment':
      NutritionAssessment$json,
  '.healthcare.hospital_ops_diet.v1.SignAssessmentRequest':
      SignAssessmentRequest$json,
  '.healthcare.hospital_ops_diet.v1.SignAssessmentResponse':
      SignAssessmentResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListAssessmentsRequest':
      ListAssessmentsRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListAssessmentsResponse':
      ListAssessmentsResponse$json,
  '.healthcare.hospital_ops_diet.v1.OpenCarePlanRequest':
      OpenCarePlanRequest$json,
  '.healthcare.hospital_ops_diet.v1.NutritionGoal': NutritionGoal$json,
  '.healthcare.hospital_ops_diet.v1.OpenCarePlanResponse':
      OpenCarePlanResponse$json,
  '.healthcare.hospital_ops_diet.v1.CarePlan': CarePlan$json,
  '.healthcare.hospital_ops_diet.v1.RecordProgressRequest':
      RecordProgressRequest$json,
  '.healthcare.hospital_ops_diet.v1.RecordProgressResponse':
      RecordProgressResponse$json,
  '.healthcare.hospital_ops_diet.v1.Progress': Progress$json,
  '.healthcare.hospital_ops_diet.v1.CloseCarePlanRequest':
      CloseCarePlanRequest$json,
  '.healthcare.hospital_ops_diet.v1.CloseCarePlanResponse':
      CloseCarePlanResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListCarePlansRequest':
      ListCarePlansRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListCarePlansResponse':
      ListCarePlansResponse$json,
  '.healthcare.hospital_ops_diet.v1.GetGoalTrendRequest':
      GetGoalTrendRequest$json,
  '.healthcare.hospital_ops_diet.v1.GetGoalTrendResponse':
      GetGoalTrendResponse$json,
  '.healthcare.hospital_ops_diet.v1.Trend': Trend$json,
  '.healthcare.hospital_ops_diet.v1.TrendPoint': TrendPoint$json,
  '.healthcare.hospital_ops_diet.v1.PlaceDietOrderRequest':
      PlaceDietOrderRequest$json,
  '.healthcare.hospital_ops_diet.v1.Texture': Texture$json,
  '.healthcare.hospital_ops_diet.v1.PlaceDietOrderResponse':
      PlaceDietOrderResponse$json,
  '.healthcare.hospital_ops_diet.v1.DietOrder': DietOrder$json,
  '.healthcare.hospital_ops_diet.v1.Conflict': Conflict$json,
  '.healthcare.hospital_ops_diet.v1.ResolveConflictRequest':
      ResolveConflictRequest$json,
  '.healthcare.hospital_ops_diet.v1.ResolveConflictResponse':
      ResolveConflictResponse$json,
  '.healthcare.hospital_ops_diet.v1.CancelDietOrderRequest':
      CancelDietOrderRequest$json,
  '.healthcare.hospital_ops_diet.v1.CancelDietOrderResponse':
      CancelDietOrderResponse$json,
  '.healthcare.hospital_ops_diet.v1.GetCurrentDietOrderRequest':
      GetCurrentDietOrderRequest$json,
  '.healthcare.hospital_ops_diet.v1.GetCurrentDietOrderResponse':
      GetCurrentDietOrderResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListDietOrdersRequest':
      ListDietOrdersRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListDietOrdersResponse':
      ListDietOrdersResponse$json,
  '.healthcare.hospital_ops_diet.v1.PlanNutritionSupportRequest':
      PlanNutritionSupportRequest$json,
  '.healthcare.hospital_ops_diet.v1.PlanNutritionSupportResponse':
      PlanNutritionSupportResponse$json,
  '.healthcare.hospital_ops_diet.v1.NutritionSupportPlan':
      NutritionSupportPlan$json,
  '.healthcare.hospital_ops_diet.v1.LinkSupportOrderRequest':
      LinkSupportOrderRequest$json,
  '.healthcare.hospital_ops_diet.v1.LinkSupportOrderResponse':
      LinkSupportOrderResponse$json,
  '.healthcare.hospital_ops_diet.v1.StopSupportRequest':
      StopSupportRequest$json,
  '.healthcare.hospital_ops_diet.v1.StopSupportResponse':
      StopSupportResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListSupportPlansRequest':
      ListSupportPlansRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListSupportPlansResponse':
      ListSupportPlansResponse$json,
  '.healthcare.hospital_ops_diet.v1.BuildCensusRequest':
      BuildCensusRequest$json,
  '.healthcare.hospital_ops_diet.v1.BuildCensusResponse':
      BuildCensusResponse$json,
  '.healthcare.hospital_ops_diet.v1.MealCensus': MealCensus$json,
  '.healthcare.hospital_ops_diet.v1.CensusLine': CensusLine$json,
  '.healthcare.hospital_ops_diet.v1.FreezeCensusRequest':
      FreezeCensusRequest$json,
  '.healthcare.hospital_ops_diet.v1.FreezeCensusResponse':
      FreezeCensusResponse$json,
  '.healthcare.hospital_ops_diet.v1.ReissueCensusRequest':
      ReissueCensusRequest$json,
  '.healthcare.hospital_ops_diet.v1.ReissueCensusResponse':
      ReissueCensusResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListCensusesRequest':
      ListCensusesRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListCensusesResponse':
      ListCensusesResponse$json,
  '.healthcare.hospital_ops_diet.v1.PlateTraysRequest': PlateTraysRequest$json,
  '.healthcare.hospital_ops_diet.v1.PlateTraysResponse':
      PlateTraysResponse$json,
  '.healthcare.hospital_ops_diet.v1.Tray': Tray$json,
  '.healthcare.hospital_ops_diet.v1.PrepareTrayRequest':
      PrepareTrayRequest$json,
  '.healthcare.hospital_ops_diet.v1.PrepareTrayResponse':
      PrepareTrayResponse$json,
  '.healthcare.hospital_ops_diet.v1.DispatchTrayRequest':
      DispatchTrayRequest$json,
  '.healthcare.hospital_ops_diet.v1.DispatchTrayResponse':
      DispatchTrayResponse$json,
  '.healthcare.hospital_ops_diet.v1.DeliverTrayRequest':
      DeliverTrayRequest$json,
  '.healthcare.hospital_ops_diet.v1.DeliverTrayResponse':
      DeliverTrayResponse$json,
  '.healthcare.hospital_ops_diet.v1.CloseTrayRequest': CloseTrayRequest$json,
  '.healthcare.hospital_ops_diet.v1.CloseTrayResponse': CloseTrayResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListTraysRequest': ListTraysRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListTraysResponse': ListTraysResponse$json,
  '.healthcare.hospital_ops_diet.v1.GetMealOutcomeRequest':
      GetMealOutcomeRequest$json,
  '.healthcare.hospital_ops_diet.v1.GetMealOutcomeResponse':
      GetMealOutcomeResponse$json,
  '.healthcare.hospital_ops_diet.v1.MealOutcome': MealOutcome$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureItemRequest':
      ConfigureItemRequest$json,
  '.healthcare.hospital_ops_diet.v1.DietItem': DietItem$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureItemResponse':
      ConfigureItemResponse$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureRecipeRequest':
      ConfigureRecipeRequest$json,
  '.healthcare.hospital_ops_diet.v1.Recipe': Recipe$json,
  '.healthcare.hospital_ops_diet.v1.IngredientQuantity':
      IngredientQuantity$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureRecipeResponse':
      ConfigureRecipeResponse$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureMenuItemRequest':
      ConfigureMenuItemRequest$json,
  '.healthcare.hospital_ops_diet.v1.MenuItem': MenuItem$json,
  '.healthcare.hospital_ops_diet.v1.ConfigureMenuItemResponse':
      ConfigureMenuItemResponse$json,
  '.healthcare.hospital_ops_diet.v1.ListMenuRequest': ListMenuRequest$json,
  '.healthcare.hospital_ops_diet.v1.ListMenuResponse': ListMenuResponse$json,
  '.healthcare.hospital_ops_diet.v1.RecordConsumptionRequest':
      RecordConsumptionRequest$json,
  '.healthcare.hospital_ops_diet.v1.RecordConsumptionResponse':
      RecordConsumptionResponse$json,
  '.healthcare.hospital_ops_diet.v1.GetIngredientForecastRequest':
      GetIngredientForecastRequest$json,
  '.healthcare.hospital_ops_diet.v1.GetIngredientForecastResponse':
      GetIngredientForecastResponse$json,
  '.healthcare.hospital_ops_diet.v1.Forecast': Forecast$json,
  '.healthcare.hospital_ops_diet.v1.IngredientDemand': IngredientDemand$json,
};

/// Descriptor for `DietService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List dietServiceDescriptor = $convert.base64Decode(
    'CgtEaWV0U2VydmljZRKHAQoQUmVjb3JkQXNzZXNzbWVudBI4LmhlYWx0aGNhcmUuaG9zcGl0YW'
    'xfb3BzX2RpZXQudjEuUmVjb3JkQXNzZXNzbWVudFJlcXVlc3QaOS5oZWFsdGhjYXJlLmhvc3Bp'
    'dGFsX29wc19kaWV0LnYxLlJlY29yZEFzc2Vzc21lbnRSZXNwb25zZRKBAQoOU2lnbkFzc2Vzc2'
    '1lbnQSNi5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLlNpZ25Bc3Nlc3NtZW50UmVx'
    'dWVzdBo3LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuU2lnbkFzc2Vzc21lbnRSZX'
    'Nwb25zZRKEAQoPTGlzdEFzc2Vzc21lbnRzEjcuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGll'
    'dC52MS5MaXN0QXNzZXNzbWVudHNSZXF1ZXN0GjguaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZG'
    'lldC52MS5MaXN0QXNzZXNzbWVudHNSZXNwb25zZRJ7CgxPcGVuQ2FyZVBsYW4SNC5oZWFsdGhj'
    'YXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLk9wZW5DYXJlUGxhblJlcXVlc3QaNS5oZWFsdGhjYX'
    'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLk9wZW5DYXJlUGxhblJlc3BvbnNlEoEBCg5SZWNvcmRQ'
    'cm9ncmVzcxI2LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuUmVjb3JkUHJvZ3Jlc3'
    'NSZXF1ZXN0GjcuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5SZWNvcmRQcm9ncmVz'
    'c1Jlc3BvbnNlEn4KDUNsb3NlQ2FyZVBsYW4SNS5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaW'
    'V0LnYxLkNsb3NlQ2FyZVBsYW5SZXF1ZXN0GjYuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGll'
    'dC52MS5DbG9zZUNhcmVQbGFuUmVzcG9uc2USfgoNTGlzdENhcmVQbGFucxI1LmhlYWx0aGNhcm'
    'UuaG9zcGl0YWxfb3BzX2RpZXQudjEuTGlzdENhcmVQbGFuc1JlcXVlc3QaNi5oZWFsdGhjYXJl'
    'Lmhvc3BpdGFsX29wc19kaWV0LnYxLkxpc3RDYXJlUGxhbnNSZXNwb25zZRJ7CgxHZXRHb2FsVH'
    'JlbmQSNC5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkdldEdvYWxUcmVuZFJlcXVl'
    'c3QaNS5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkdldEdvYWxUcmVuZFJlc3Bvbn'
    'NlEoEBCg5QbGFjZURpZXRPcmRlchI2LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEu'
    'UGxhY2VEaWV0T3JkZXJSZXF1ZXN0GjcuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS'
    '5QbGFjZURpZXRPcmRlclJlc3BvbnNlEoQBCg9SZXNvbHZlQ29uZmxpY3QSNy5oZWFsdGhjYXJl'
    'Lmhvc3BpdGFsX29wc19kaWV0LnYxLlJlc29sdmVDb25mbGljdFJlcXVlc3QaOC5oZWFsdGhjYX'
    'JlLmhvc3BpdGFsX29wc19kaWV0LnYxLlJlc29sdmVDb25mbGljdFJlc3BvbnNlEoQBCg9DYW5j'
    'ZWxEaWV0T3JkZXISNy5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkNhbmNlbERpZX'
    'RPcmRlclJlcXVlc3QaOC5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkNhbmNlbERp'
    'ZXRPcmRlclJlc3BvbnNlEpABChNHZXRDdXJyZW50RGlldE9yZGVyEjsuaGVhbHRoY2FyZS5ob3'
    'NwaXRhbF9vcHNfZGlldC52MS5HZXRDdXJyZW50RGlldE9yZGVyUmVxdWVzdBo8LmhlYWx0aGNh'
    'cmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuR2V0Q3VycmVudERpZXRPcmRlclJlc3BvbnNlEoEBCg'
    '5MaXN0RGlldE9yZGVycxI2LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuTGlzdERp'
    'ZXRPcmRlcnNSZXF1ZXN0GjcuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0RG'
    'lldE9yZGVyc1Jlc3BvbnNlEpMBChRQbGFuTnV0cml0aW9uU3VwcG9ydBI8LmhlYWx0aGNhcmUu'
    'aG9zcGl0YWxfb3BzX2RpZXQudjEuUGxhbk51dHJpdGlvblN1cHBvcnRSZXF1ZXN0Gj0uaGVhbH'
    'RoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5QbGFuTnV0cml0aW9uU3VwcG9ydFJlc3BvbnNl'
    'EocBChBMaW5rU3VwcG9ydE9yZGVyEjguaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS'
    '5MaW5rU3VwcG9ydE9yZGVyUmVxdWVzdBo5LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQu'
    'djEuTGlua1N1cHBvcnRPcmRlclJlc3BvbnNlEngKC1N0b3BTdXBwb3J0EjMuaGVhbHRoY2FyZS'
    '5ob3NwaXRhbF9vcHNfZGlldC52MS5TdG9wU3VwcG9ydFJlcXVlc3QaNC5oZWFsdGhjYXJlLmhv'
    'c3BpdGFsX29wc19kaWV0LnYxLlN0b3BTdXBwb3J0UmVzcG9uc2UShwEKEExpc3RTdXBwb3J0UG'
    'xhbnMSOC5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkxpc3RTdXBwb3J0UGxhbnNS'
    'ZXF1ZXN0GjkuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0U3VwcG9ydFBsYW'
    '5zUmVzcG9uc2USeAoLQnVpbGRDZW5zdXMSMy5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0'
    'LnYxLkJ1aWxkQ2Vuc3VzUmVxdWVzdBo0LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudj'
    'EuQnVpbGRDZW5zdXNSZXNwb25zZRJ7CgxGcmVlemVDZW5zdXMSNC5oZWFsdGhjYXJlLmhvc3Bp'
    'dGFsX29wc19kaWV0LnYxLkZyZWV6ZUNlbnN1c1JlcXVlc3QaNS5oZWFsdGhjYXJlLmhvc3BpdG'
    'FsX29wc19kaWV0LnYxLkZyZWV6ZUNlbnN1c1Jlc3BvbnNlEn4KDVJlaXNzdWVDZW5zdXMSNS5o'
    'ZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLlJlaXNzdWVDZW5zdXNSZXF1ZXN0GjYuaG'
    'VhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5SZWlzc3VlQ2Vuc3VzUmVzcG9uc2USewoM'
    'TGlzdENlbnN1c2VzEjQuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0Q2Vuc3'
    'VzZXNSZXF1ZXN0GjUuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0Q2Vuc3Vz'
    'ZXNSZXNwb25zZRJ1CgpQbGF0ZVRyYXlzEjIuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC'
    '52MS5QbGF0ZVRyYXlzUmVxdWVzdBozLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEu'
    'UGxhdGVUcmF5c1Jlc3BvbnNlEngKC1ByZXBhcmVUcmF5EjMuaGVhbHRoY2FyZS5ob3NwaXRhbF'
    '9vcHNfZGlldC52MS5QcmVwYXJlVHJheVJlcXVlc3QaNC5oZWFsdGhjYXJlLmhvc3BpdGFsX29w'
    'c19kaWV0LnYxLlByZXBhcmVUcmF5UmVzcG9uc2USewoMRGlzcGF0Y2hUcmF5EjQuaGVhbHRoY2'
    'FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5EaXNwYXRjaFRyYXlSZXF1ZXN0GjUuaGVhbHRoY2Fy'
    'ZS5ob3NwaXRhbF9vcHNfZGlldC52MS5EaXNwYXRjaFRyYXlSZXNwb25zZRJ4CgtEZWxpdmVyVH'
    'JheRIzLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuRGVsaXZlclRyYXlSZXF1ZXN0'
    'GjQuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5EZWxpdmVyVHJheVJlc3BvbnNlEn'
    'IKCUNsb3NlVHJheRIxLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuQ2xvc2VUcmF5'
    'UmVxdWVzdBoyLmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuQ2xvc2VUcmF5UmVzcG'
    '9uc2UScgoJTGlzdFRyYXlzEjEuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0'
    'VHJheXNSZXF1ZXN0GjIuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0VHJheX'
    'NSZXNwb25zZRKBAQoOR2V0TWVhbE91dGNvbWUSNi5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19k'
    'aWV0LnYxLkdldE1lYWxPdXRjb21lUmVxdWVzdBo3LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2'
    'RpZXQudjEuR2V0TWVhbE91dGNvbWVSZXNwb25zZRJ+Cg1Db25maWd1cmVJdGVtEjUuaGVhbHRo'
    'Y2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5Db25maWd1cmVJdGVtUmVxdWVzdBo2LmhlYWx0aG'
    'NhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuQ29uZmlndXJlSXRlbVJlc3BvbnNlEoQBCg9Db25m'
    'aWd1cmVSZWNpcGUSNy5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkNvbmZpZ3VyZV'
    'JlY2lwZVJlcXVlc3QaOC5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkNvbmZpZ3Vy'
    'ZVJlY2lwZVJlc3BvbnNlEooBChFDb25maWd1cmVNZW51SXRlbRI5LmhlYWx0aGNhcmUuaG9zcG'
    'l0YWxfb3BzX2RpZXQudjEuQ29uZmlndXJlTWVudUl0ZW1SZXF1ZXN0GjouaGVhbHRoY2FyZS5o'
    'b3NwaXRhbF9vcHNfZGlldC52MS5Db25maWd1cmVNZW51SXRlbVJlc3BvbnNlEm8KCExpc3RNZW'
    '51EjAuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5MaXN0TWVudVJlcXVlc3QaMS5o'
    'ZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLkxpc3RNZW51UmVzcG9uc2USigEKEVJlY2'
    '9yZENvbnN1bXB0aW9uEjkuaGVhbHRoY2FyZS5ob3NwaXRhbF9vcHNfZGlldC52MS5SZWNvcmRD'
    'b25zdW1wdGlvblJlcXVlc3QaOi5oZWFsdGhjYXJlLmhvc3BpdGFsX29wc19kaWV0LnYxLlJlY2'
    '9yZENvbnN1bXB0aW9uUmVzcG9uc2USlgEKFUdldEluZ3JlZGllbnRGb3JlY2FzdBI9LmhlYWx0'
    'aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuR2V0SW5ncmVkaWVudEZvcmVjYXN0UmVxdWVzdB'
    'o+LmhlYWx0aGNhcmUuaG9zcGl0YWxfb3BzX2RpZXQudjEuR2V0SW5ncmVkaWVudEZvcmVjYXN0'
    'UmVzcG9uc2U=');
