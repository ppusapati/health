// This is a generated file - do not edit.
//
// Generated from healthcare/platform_api/v1/health.proto.

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

@$core.Deprecated('Use checkLivenessRequestDescriptor instead')
const CheckLivenessRequest$json = {
  '1': 'CheckLivenessRequest',
};

/// Descriptor for `CheckLivenessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLivenessRequestDescriptor =
    $convert.base64Decode('ChRDaGVja0xpdmVuZXNzUmVxdWVzdA==');

@$core.Deprecated('Use checkLivenessResponseDescriptor instead')
const CheckLivenessResponse$json = {
  '1': 'CheckLivenessResponse',
  '2': [
    {'1': 'alive', '3': 1, '4': 1, '5': 8, '10': 'alive'},
  ],
};

/// Descriptor for `CheckLivenessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkLivenessResponseDescriptor =
    $convert.base64Decode(
        'ChVDaGVja0xpdmVuZXNzUmVzcG9uc2USFAoFYWxpdmUYASABKAhSBWFsaXZl');

@$core.Deprecated('Use checkReadinessRequestDescriptor instead')
const CheckReadinessRequest$json = {
  '1': 'CheckReadinessRequest',
};

/// Descriptor for `CheckReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkReadinessRequestDescriptor =
    $convert.base64Decode('ChVDaGVja1JlYWRpbmVzc1JlcXVlc3Q=');

@$core.Deprecated('Use checkReadinessResponseDescriptor instead')
const CheckReadinessResponse$json = {
  '1': 'CheckReadinessResponse',
  '2': [
    {'1': 'ready', '3': 1, '4': 1, '5': 8, '10': 'ready'},
    {
      '1': 'dependencies',
      '3': 2,
      '4': 3,
      '5': 11,
      '6':
          '.healthcare.platform_api.v1.CheckReadinessResponse.DependenciesEntry',
      '10': 'dependencies'
    },
  ],
  '3': [CheckReadinessResponse_DependenciesEntry$json],
};

@$core.Deprecated('Use checkReadinessResponseDescriptor instead')
const CheckReadinessResponse_DependenciesEntry$json = {
  '1': 'DependenciesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 8, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CheckReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkReadinessResponseDescriptor = $convert.base64Decode(
    'ChZDaGVja1JlYWRpbmVzc1Jlc3BvbnNlEhQKBXJlYWR5GAEgASgIUgVyZWFkeRJoCgxkZXBlbm'
    'RlbmNpZXMYAiADKAsyRC5oZWFsdGhjYXJlLnBsYXRmb3JtX2FwaS52MS5DaGVja1JlYWRpbmVz'
    'c1Jlc3BvbnNlLkRlcGVuZGVuY2llc0VudHJ5UgxkZXBlbmRlbmNpZXMaPwoRRGVwZW5kZW5jaW'
    'VzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAhSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use getBuildInfoRequestDescriptor instead')
const GetBuildInfoRequest$json = {
  '1': 'GetBuildInfoRequest',
};

/// Descriptor for `GetBuildInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBuildInfoRequestDescriptor =
    $convert.base64Decode('ChNHZXRCdWlsZEluZm9SZXF1ZXN0');

@$core.Deprecated('Use getBuildInfoResponseDescriptor instead')
const GetBuildInfoResponse$json = {
  '1': 'GetBuildInfoResponse',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'commit', '3': 2, '4': 1, '5': 9, '10': 'commit'},
    {'1': 'built_at', '3': 3, '4': 1, '5': 9, '10': 'builtAt'},
  ],
};

/// Descriptor for `GetBuildInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBuildInfoResponseDescriptor = $convert.base64Decode(
    'ChRHZXRCdWlsZEluZm9SZXNwb25zZRIYCgd2ZXJzaW9uGAEgASgJUgd2ZXJzaW9uEhYKBmNvbW'
    '1pdBgCIAEoCVIGY29tbWl0EhkKCGJ1aWx0X2F0GAMgASgJUgdidWlsdEF0');

const $core.Map<$core.String, $core.dynamic> HealthServiceBase$json = {
  '1': 'HealthService',
  '2': [
    {
      '1': 'CheckLiveness',
      '2': '.healthcare.platform_api.v1.CheckLivenessRequest',
      '3': '.healthcare.platform_api.v1.CheckLivenessResponse',
      '4': {}
    },
    {
      '1': 'CheckReadiness',
      '2': '.healthcare.platform_api.v1.CheckReadinessRequest',
      '3': '.healthcare.platform_api.v1.CheckReadinessResponse',
      '4': {}
    },
    {
      '1': 'GetBuildInfo',
      '2': '.healthcare.platform_api.v1.GetBuildInfoRequest',
      '3': '.healthcare.platform_api.v1.GetBuildInfoResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use healthServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    HealthServiceBase$messageJson = {
  '.healthcare.platform_api.v1.CheckLivenessRequest': CheckLivenessRequest$json,
  '.healthcare.platform_api.v1.CheckLivenessResponse':
      CheckLivenessResponse$json,
  '.healthcare.platform_api.v1.CheckReadinessRequest':
      CheckReadinessRequest$json,
  '.healthcare.platform_api.v1.CheckReadinessResponse':
      CheckReadinessResponse$json,
  '.healthcare.platform_api.v1.CheckReadinessResponse.DependenciesEntry':
      CheckReadinessResponse_DependenciesEntry$json,
  '.healthcare.platform_api.v1.GetBuildInfoRequest': GetBuildInfoRequest$json,
  '.healthcare.platform_api.v1.GetBuildInfoResponse': GetBuildInfoResponse$json,
};

/// Descriptor for `HealthService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List healthServiceDescriptor = $convert.base64Decode(
    'Cg1IZWFsdGhTZXJ2aWNlEnYKDUNoZWNrTGl2ZW5lc3MSMC5oZWFsdGhjYXJlLnBsYXRmb3JtX2'
    'FwaS52MS5DaGVja0xpdmVuZXNzUmVxdWVzdBoxLmhlYWx0aGNhcmUucGxhdGZvcm1fYXBpLnYx'
    'LkNoZWNrTGl2ZW5lc3NSZXNwb25zZSIAEnkKDkNoZWNrUmVhZGluZXNzEjEuaGVhbHRoY2FyZS'
    '5wbGF0Zm9ybV9hcGkudjEuQ2hlY2tSZWFkaW5lc3NSZXF1ZXN0GjIuaGVhbHRoY2FyZS5wbGF0'
    'Zm9ybV9hcGkudjEuQ2hlY2tSZWFkaW5lc3NSZXNwb25zZSIAEnMKDEdldEJ1aWxkSW5mbxIvLm'
    'hlYWx0aGNhcmUucGxhdGZvcm1fYXBpLnYxLkdldEJ1aWxkSW5mb1JlcXVlc3QaMC5oZWFsdGhj'
    'YXJlLnBsYXRmb3JtX2FwaS52MS5HZXRCdWlsZEluZm9SZXNwb25zZSIA');
