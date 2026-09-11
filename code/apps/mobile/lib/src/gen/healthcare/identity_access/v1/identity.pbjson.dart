// This is a generated file - do not edit.
//
// Generated from healthcare/identity_access/v1/identity.proto.

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

@$core.Deprecated('Use purposeOfUseDescriptor instead')
const PurposeOfUse$json = {
  '1': 'PurposeOfUse',
  '2': [
    {'1': 'PURPOSE_OF_USE_UNSPECIFIED', '2': 0},
    {'1': 'PURPOSE_OF_USE_TREATMENT', '2': 1},
    {'1': 'PURPOSE_OF_USE_PAYMENT', '2': 2},
    {'1': 'PURPOSE_OF_USE_OPERATIONS', '2': 3},
    {'1': 'PURPOSE_OF_USE_SUPPORT', '2': 4},
    {'1': 'PURPOSE_OF_USE_RESEARCH', '2': 5},
  ],
};

/// Descriptor for `PurposeOfUse`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List purposeOfUseDescriptor = $convert.base64Decode(
    'CgxQdXJwb3NlT2ZVc2USHgoaUFVSUE9TRV9PRl9VU0VfVU5TUEVDSUZJRUQQABIcChhQVVJQT1'
    'NFX09GX1VTRV9UUkVBVE1FTlQQARIaChZQVVJQT1NFX09GX1VTRV9QQVlNRU5UEAISHQoZUFVS'
    'UE9TRV9PRl9VU0VfT1BFUkFUSU9OUxADEhoKFlBVUlBPU0VfT0ZfVVNFX1NVUFBPUlQQBBIbCh'
    'dQVVJQT1NFX09GX1VTRV9SRVNFQVJDSBAF');

@$core.Deprecated('Use sessionContextDescriptor instead')
const SessionContext$json = {
  '1': 'SessionContext',
  '2': [
    {'1': 'subject_id', '3': 1, '4': 1, '5': 9, '10': 'subjectId'},
    {'1': 'tenant_id', '3': 2, '4': 1, '5': 9, '10': 'tenantId'},
    {
      '1': 'active_facility_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'activeFacilityId'
    },
    {'1': 'roles', '3': 4, '4': 3, '5': 9, '10': 'roles'},
    {'1': 'permissions', '3': 5, '4': 3, '5': 9, '10': 'permissions'},
    {
      '1': 'purpose_of_use',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.identity_access.v1.PurposeOfUse',
      '10': 'purposeOfUse'
    },
    {
      '1': 'break_glass_active',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'breakGlassActive'
    },
    {
      '1': 'expires_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'expiresAt'
    },
  ],
};

/// Descriptor for `SessionContext`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sessionContextDescriptor = $convert.base64Decode(
    'Cg5TZXNzaW9uQ29udGV4dBIdCgpzdWJqZWN0X2lkGAEgASgJUglzdWJqZWN0SWQSGwoJdGVuYW'
    '50X2lkGAIgASgJUgh0ZW5hbnRJZBIsChJhY3RpdmVfZmFjaWxpdHlfaWQYAyABKAlSEGFjdGl2'
    'ZUZhY2lsaXR5SWQSFAoFcm9sZXMYBCADKAlSBXJvbGVzEiAKC3Blcm1pc3Npb25zGAUgAygJUg'
    'twZXJtaXNzaW9ucxJRCg5wdXJwb3NlX29mX3VzZRgGIAEoDjIrLmhlYWx0aGNhcmUuaWRlbnRp'
    'dHlfYWNjZXNzLnYxLlB1cnBvc2VPZlVzZVIMcHVycG9zZU9mVXNlEiwKEmJyZWFrX2dsYXNzX2'
    'FjdGl2ZRgHIAEoCFIQYnJlYWtHbGFzc0FjdGl2ZRI5CgpleHBpcmVzX2F0GAggASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0');

@$core.Deprecated('Use getSessionContextRequestDescriptor instead')
const GetSessionContextRequest$json = {
  '1': 'GetSessionContextRequest',
};

/// Descriptor for `GetSessionContextRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSessionContextRequestDescriptor =
    $convert.base64Decode('ChhHZXRTZXNzaW9uQ29udGV4dFJlcXVlc3Q=');

@$core.Deprecated('Use getSessionContextResponseDescriptor instead')
const GetSessionContextResponse$json = {
  '1': 'GetSessionContextResponse',
  '2': [
    {
      '1': 'session',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.identity_access.v1.SessionContext',
      '10': 'session'
    },
  ],
};

/// Descriptor for `GetSessionContextResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSessionContextResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRTZXNzaW9uQ29udGV4dFJlc3BvbnNlEkcKB3Nlc3Npb24YASABKAsyLS5oZWFsdGhjYX'
        'JlLmlkZW50aXR5X2FjY2Vzcy52MS5TZXNzaW9uQ29udGV4dFIHc2Vzc2lvbg==');

@$core.Deprecated('Use evaluateAccessRequestDescriptor instead')
const EvaluateAccessRequest$json = {
  '1': 'EvaluateAccessRequest',
  '2': [
    {'1': 'permission', '3': 1, '4': 1, '5': 9, '10': 'permission'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `EvaluateAccessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateAccessRequestDescriptor = $convert.base64Decode(
    'ChVFdmFsdWF0ZUFjY2Vzc1JlcXVlc3QSHgoKcGVybWlzc2lvbhgBIAEoCVIKcGVybWlzc2lvbh'
    'IfCgtmYWNpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZA==');

@$core.Deprecated('Use evaluateAccessResponseDescriptor instead')
const EvaluateAccessResponse$json = {
  '1': 'EvaluateAccessResponse',
  '2': [
    {'1': 'allowed', '3': 1, '4': 1, '5': 8, '10': 'allowed'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `EvaluateAccessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateAccessResponseDescriptor =
    $convert.base64Decode(
        'ChZFdmFsdWF0ZUFjY2Vzc1Jlc3BvbnNlEhgKB2FsbG93ZWQYASABKAhSB2FsbG93ZWQSFgoGcm'
        'Vhc29uGAIgASgJUgZyZWFzb24=');

const $core.Map<$core.String, $core.dynamic> IdentityServiceBase$json = {
  '1': 'IdentityService',
  '2': [
    {
      '1': 'GetSessionContext',
      '2': '.healthcare.identity_access.v1.GetSessionContextRequest',
      '3': '.healthcare.identity_access.v1.GetSessionContextResponse',
      '4': {}
    },
    {
      '1': 'EvaluateAccess',
      '2': '.healthcare.identity_access.v1.EvaluateAccessRequest',
      '3': '.healthcare.identity_access.v1.EvaluateAccessResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use identityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    IdentityServiceBase$messageJson = {
  '.healthcare.identity_access.v1.GetSessionContextRequest':
      GetSessionContextRequest$json,
  '.healthcare.identity_access.v1.GetSessionContextResponse':
      GetSessionContextResponse$json,
  '.healthcare.identity_access.v1.SessionContext': SessionContext$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.identity_access.v1.EvaluateAccessRequest':
      EvaluateAccessRequest$json,
  '.healthcare.identity_access.v1.EvaluateAccessResponse':
      EvaluateAccessResponse$json,
};

/// Descriptor for `IdentityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List identityServiceDescriptor = $convert.base64Decode(
    'Cg9JZGVudGl0eVNlcnZpY2USiAEKEUdldFNlc3Npb25Db250ZXh0EjcuaGVhbHRoY2FyZS5pZG'
    'VudGl0eV9hY2Nlc3MudjEuR2V0U2Vzc2lvbkNvbnRleHRSZXF1ZXN0GjguaGVhbHRoY2FyZS5p'
    'ZGVudGl0eV9hY2Nlc3MudjEuR2V0U2Vzc2lvbkNvbnRleHRSZXNwb25zZSIAEn8KDkV2YWx1YX'
    'RlQWNjZXNzEjQuaGVhbHRoY2FyZS5pZGVudGl0eV9hY2Nlc3MudjEuRXZhbHVhdGVBY2Nlc3NS'
    'ZXF1ZXN0GjUuaGVhbHRoY2FyZS5pZGVudGl0eV9hY2Nlc3MudjEuRXZhbHVhdGVBY2Nlc3NSZX'
    'Nwb25zZSIA');
