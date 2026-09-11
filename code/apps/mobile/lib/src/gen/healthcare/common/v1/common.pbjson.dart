// This is a generated file - do not edit.
//
// Generated from healthcare/common/v1/common.proto.

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

@$core.Deprecated('Use errorDetailDescriptor instead')
const ErrorDetail$json = {
  '1': 'ErrorDetail',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'field_violations',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.common.v1.FieldViolation',
      '10': 'fieldViolations'
    },
    {'1': 'retryable', '3': 3, '4': 1, '5': 8, '10': 'retryable'},
    {'1': 'correlation_id', '3': 4, '4': 1, '5': 9, '10': 'correlationId'},
  ],
};

/// Descriptor for `ErrorDetail`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorDetailDescriptor = $convert.base64Decode(
    'CgtFcnJvckRldGFpbBISCgRjb2RlGAEgASgJUgRjb2RlEk8KEGZpZWxkX3Zpb2xhdGlvbnMYAi'
    'ADKAsyJC5oZWFsdGhjYXJlLmNvbW1vbi52MS5GaWVsZFZpb2xhdGlvblIPZmllbGRWaW9sYXRp'
    'b25zEhwKCXJldHJ5YWJsZRgDIAEoCFIJcmV0cnlhYmxlEiUKDmNvcnJlbGF0aW9uX2lkGAQgAS'
    'gJUg1jb3JyZWxhdGlvbklk');

@$core.Deprecated('Use fieldViolationDescriptor instead')
const FieldViolation$json = {
  '1': 'FieldViolation',
  '2': [
    {'1': 'field', '3': 1, '4': 1, '5': 9, '10': 'field'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `FieldViolation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldViolationDescriptor = $convert.base64Decode(
    'Cg5GaWVsZFZpb2xhdGlvbhIUCgVmaWVsZBgBIAEoCVIFZmllbGQSFgoGcmVhc29uGAIgASgJUg'
    'ZyZWFzb24=');

@$core.Deprecated('Use pageRequestDescriptor instead')
const PageRequest$json = {
  '1': 'PageRequest',
  '2': [
    {'1': 'page_size', '3': 1, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 2, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `PageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageRequestDescriptor = $convert.base64Decode(
    'CgtQYWdlUmVxdWVzdBIbCglwYWdlX3NpemUYASABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW'
    '4YAiABKAlSCXBhZ2VUb2tlbg==');

@$core.Deprecated('Use pageResponseDescriptor instead')
const PageResponse$json = {
  '1': 'PageResponse',
  '2': [
    {'1': 'next_page_token', '3': 1, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `PageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pageResponseDescriptor = $convert.base64Decode(
    'CgxQYWdlUmVzcG9uc2USJgoPbmV4dF9wYWdlX3Rva2VuGAEgASgJUg1uZXh0UGFnZVRva2Vu');
