// This is a generated file - do not edit.
//
// Generated from healthcare/organization/v1/organization.proto.

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

import '../../common/v1/common.pbjson.dart' as $1;

@$core.Deprecated('Use tenantStatusDescriptor instead')
const TenantStatus$json = {
  '1': 'TenantStatus',
  '2': [
    {'1': 'TENANT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TENANT_STATUS_PROVISIONING', '2': 1},
    {'1': 'TENANT_STATUS_ACTIVE', '2': 2},
    {'1': 'TENANT_STATUS_SUSPENDED', '2': 3},
    {'1': 'TENANT_STATUS_OFFBOARDING', '2': 4},
    {'1': 'TENANT_STATUS_TERMINATED', '2': 5},
  ],
};

/// Descriptor for `TenantStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List tenantStatusDescriptor = $convert.base64Decode(
    'CgxUZW5hbnRTdGF0dXMSHQoZVEVOQU5UX1NUQVRVU19VTlNQRUNJRklFRBAAEh4KGlRFTkFOVF'
    '9TVEFUVVNfUFJPVklTSU9OSU5HEAESGAoUVEVOQU5UX1NUQVRVU19BQ1RJVkUQAhIbChdURU5B'
    'TlRfU1RBVFVTX1NVU1BFTkRFRBADEh0KGVRFTkFOVF9TVEFUVVNfT0ZGQk9BUkRJTkcQBBIcCh'
    'hURU5BTlRfU1RBVFVTX1RFUk1JTkFURUQQBQ==');

@$core.Deprecated('Use facilityStatusDescriptor instead')
const FacilityStatus$json = {
  '1': 'FacilityStatus',
  '2': [
    {'1': 'FACILITY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'FACILITY_STATUS_ACTIVE', '2': 1},
    {'1': 'FACILITY_STATUS_INACTIVE', '2': 2},
    {'1': 'FACILITY_STATUS_RETIRED', '2': 3},
  ],
};

/// Descriptor for `FacilityStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List facilityStatusDescriptor = $convert.base64Decode(
    'Cg5GYWNpbGl0eVN0YXR1cxIfChtGQUNJTElUWV9TVEFUVVNfVU5TUEVDSUZJRUQQABIaChZGQU'
    'NJTElUWV9TVEFUVVNfQUNUSVZFEAESHAoYRkFDSUxJVFlfU1RBVFVTX0lOQUNUSVZFEAISGwoX'
    'RkFDSUxJVFlfU1RBVFVTX1JFVElSRUQQAw==');

@$core.Deprecated('Use facilityTypeDescriptor instead')
const FacilityType$json = {
  '1': 'FacilityType',
  '2': [
    {'1': 'FACILITY_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FACILITY_TYPE_HOSPITAL', '2': 1},
    {'1': 'FACILITY_TYPE_CLINIC', '2': 2},
    {'1': 'FACILITY_TYPE_LABORATORY', '2': 3},
    {'1': 'FACILITY_TYPE_PHARMACY', '2': 4},
    {'1': 'FACILITY_TYPE_COLLECTION_CENTRE', '2': 5},
    {'1': 'FACILITY_TYPE_WAREHOUSE', '2': 6},
  ],
};

/// Descriptor for `FacilityType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List facilityTypeDescriptor = $convert.base64Decode(
    'CgxGYWNpbGl0eVR5cGUSHQoZRkFDSUxJVFlfVFlQRV9VTlNQRUNJRklFRBAAEhoKFkZBQ0lMSV'
    'RZX1RZUEVfSE9TUElUQUwQARIYChRGQUNJTElUWV9UWVBFX0NMSU5JQxACEhwKGEZBQ0lMSVRZ'
    'X1RZUEVfTEFCT1JBVE9SWRADEhoKFkZBQ0lMSVRZX1RZUEVfUEhBUk1BQ1kQBBIjCh9GQUNJTE'
    'lUWV9UWVBFX0NPTExFQ1RJT05fQ0VOVFJFEAUSGwoXRkFDSUxJVFlfVFlQRV9XQVJFSE9VU0UQ'
    'Bg==');

@$core.Deprecated('Use tenantDescriptor instead')
const Tenant$json = {
  '1': 'Tenant',
  '2': [
    {'1': 'tenant_id', '3': 1, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'legal_jurisdiction',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'legalJurisdiction'
    },
    {'1': 'default_locale', '3': 4, '4': 1, '5': 9, '10': 'defaultLocale'},
    {'1': 'time_zone', '3': 5, '4': 1, '5': 9, '10': 'timeZone'},
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.TenantStatus',
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
    {
      '1': 'updated_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 9, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Tenant`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tenantDescriptor = $convert.base64Decode(
    'CgZUZW5hbnQSGwoJdGVuYW50X2lkGAEgASgJUgh0ZW5hbnRJZBIhCgxkaXNwbGF5X25hbWUYAi'
    'ABKAlSC2Rpc3BsYXlOYW1lEi0KEmxlZ2FsX2p1cmlzZGljdGlvbhgDIAEoCVIRbGVnYWxKdXJp'
    'c2RpY3Rpb24SJQoOZGVmYXVsdF9sb2NhbGUYBCABKAlSDWRlZmF1bHRMb2NhbGUSGwoJdGltZV'
    '96b25lGAUgASgJUgh0aW1lWm9uZRJACgZzdGF0dXMYBiABKA4yKC5oZWFsdGhjYXJlLm9yZ2Fu'
    'aXphdGlvbi52MS5UZW5hbnRTdGF0dXNSBnN0YXR1cxI5CgpjcmVhdGVkX2F0GAcgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgJIAEoA1'
    'IHdmVyc2lvbg==');

@$core.Deprecated('Use facilityDescriptor instead')
const Facility$json = {
  '1': 'Facility',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'tenant_id', '3': 2, '4': 1, '5': 9, '10': 'tenantId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.FacilityType',
      '10': 'type'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.FacilityStatus',
      '10': 'status'
    },
    {'1': 'time_zone', '3': 7, '4': 1, '5': 9, '10': 'timeZone'},
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
  ],
};

/// Descriptor for `Facility`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List facilityDescriptor = $convert.base64Decode(
    'CghGYWNpbGl0eRIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZBIbCgl0ZW5hbnRfaW'
    'QYAiABKAlSCHRlbmFudElkEhIKBGNvZGUYAyABKAlSBGNvZGUSIQoMZGlzcGxheV9uYW1lGAQg'
    'ASgJUgtkaXNwbGF5TmFtZRI8CgR0eXBlGAUgASgOMiguaGVhbHRoY2FyZS5vcmdhbml6YXRpb2'
    '4udjEuRmFjaWxpdHlUeXBlUgR0eXBlEkIKBnN0YXR1cxgGIAEoDjIqLmhlYWx0aGNhcmUub3Jn'
    'YW5pemF0aW9uLnYxLkZhY2lsaXR5U3RhdHVzUgZzdGF0dXMSGwoJdGltZV96b25lGAcgASgJUg'
    'h0aW1lWm9uZRI5CgpjcmVhdGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgKIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use createTenantRequestDescriptor instead')
const CreateTenantRequest$json = {
  '1': 'CreateTenantRequest',
  '2': [
    {'1': 'display_name', '3': 1, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'legal_jurisdiction',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'legalJurisdiction'
    },
    {'1': 'default_locale', '3': 3, '4': 1, '5': 9, '10': 'defaultLocale'},
    {'1': 'time_zone', '3': 4, '4': 1, '5': 9, '10': 'timeZone'},
  ],
};

/// Descriptor for `CreateTenantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTenantRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVUZW5hbnRSZXF1ZXN0EiEKDGRpc3BsYXlfbmFtZRgBIAEoCVILZGlzcGxheU5hbW'
    'USLQoSbGVnYWxfanVyaXNkaWN0aW9uGAIgASgJUhFsZWdhbEp1cmlzZGljdGlvbhIlCg5kZWZh'
    'dWx0X2xvY2FsZRgDIAEoCVINZGVmYXVsdExvY2FsZRIbCgl0aW1lX3pvbmUYBCABKAlSCHRpbW'
    'Vab25l');

@$core.Deprecated('Use createTenantResponseDescriptor instead')
const CreateTenantResponse$json = {
  '1': 'CreateTenantResponse',
  '2': [
    {
      '1': 'tenant',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Tenant',
      '10': 'tenant'
    },
  ],
};

/// Descriptor for `CreateTenantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createTenantResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVUZW5hbnRSZXNwb25zZRI6CgZ0ZW5hbnQYASABKAsyIi5oZWFsdGhjYXJlLm9yZ2'
    'FuaXphdGlvbi52MS5UZW5hbnRSBnRlbmFudA==');

@$core.Deprecated('Use getTenantRequestDescriptor instead')
const GetTenantRequest$json = {
  '1': 'GetTenantRequest',
  '2': [
    {'1': 'tenant_id', '3': 1, '4': 1, '5': 9, '10': 'tenantId'},
  ],
};

/// Descriptor for `GetTenantRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTenantRequestDescriptor = $convert.base64Decode(
    'ChBHZXRUZW5hbnRSZXF1ZXN0EhsKCXRlbmFudF9pZBgBIAEoCVIIdGVuYW50SWQ=');

@$core.Deprecated('Use getTenantResponseDescriptor instead')
const GetTenantResponse$json = {
  '1': 'GetTenantResponse',
  '2': [
    {
      '1': 'tenant',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Tenant',
      '10': 'tenant'
    },
  ],
};

/// Descriptor for `GetTenantResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTenantResponseDescriptor = $convert.base64Decode(
    'ChFHZXRUZW5hbnRSZXNwb25zZRI6CgZ0ZW5hbnQYASABKAsyIi5oZWFsdGhjYXJlLm9yZ2FuaX'
    'phdGlvbi52MS5UZW5hbnRSBnRlbmFudA==');

@$core.Deprecated('Use createFacilityRequestDescriptor instead')
const CreateFacilityRequest$json = {
  '1': 'CreateFacilityRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.FacilityType',
      '10': 'type'
    },
    {'1': 'time_zone', '3': 4, '4': 1, '5': 9, '10': 'timeZone'},
  ],
};

/// Descriptor for `CreateFacilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFacilityRequestDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVGYWNpbGl0eVJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRIhCgxkaXNwbGF5X2'
    '5hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEjwKBHR5cGUYAyABKA4yKC5oZWFsdGhjYXJlLm9yZ2Fu'
    'aXphdGlvbi52MS5GYWNpbGl0eVR5cGVSBHR5cGUSGwoJdGltZV96b25lGAQgASgJUgh0aW1lWm'
    '9uZQ==');

@$core.Deprecated('Use createFacilityResponseDescriptor instead')
const CreateFacilityResponse$json = {
  '1': 'CreateFacilityResponse',
  '2': [
    {
      '1': 'facility',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Facility',
      '10': 'facility'
    },
  ],
};

/// Descriptor for `CreateFacilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFacilityResponseDescriptor =
    $convert.base64Decode(
        'ChZDcmVhdGVGYWNpbGl0eVJlc3BvbnNlEkAKCGZhY2lsaXR5GAEgASgLMiQuaGVhbHRoY2FyZS'
        '5vcmdhbml6YXRpb24udjEuRmFjaWxpdHlSCGZhY2lsaXR5');

@$core.Deprecated('Use getFacilityRequestDescriptor instead')
const GetFacilityRequest$json = {
  '1': 'GetFacilityRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetFacilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFacilityRequestDescriptor = $convert.base64Decode(
    'ChJHZXRGYWNpbGl0eVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getFacilityResponseDescriptor instead')
const GetFacilityResponse$json = {
  '1': 'GetFacilityResponse',
  '2': [
    {
      '1': 'facility',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Facility',
      '10': 'facility'
    },
  ],
};

/// Descriptor for `GetFacilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFacilityResponseDescriptor = $convert.base64Decode(
    'ChNHZXRGYWNpbGl0eVJlc3BvbnNlEkAKCGZhY2lsaXR5GAEgASgLMiQuaGVhbHRoY2FyZS5vcm'
    'dhbml6YXRpb24udjEuRmFjaWxpdHlSCGZhY2lsaXR5');

@$core.Deprecated('Use listFacilitiesRequestDescriptor instead')
const ListFacilitiesRequest$json = {
  '1': 'ListFacilitiesRequest',
  '2': [
    {
      '1': 'page',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.common.v1.PageRequest',
      '10': 'page'
    },
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.FacilityStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `ListFacilitiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFacilitiesRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0RmFjaWxpdGllc1JlcXVlc3QSNQoEcGFnZRgBIAEoCzIhLmhlYWx0aGNhcmUuY29tbW'
    '9uLnYxLlBhZ2VSZXF1ZXN0UgRwYWdlEkIKBnN0YXR1cxgCIAEoDjIqLmhlYWx0aGNhcmUub3Jn'
    'YW5pemF0aW9uLnYxLkZhY2lsaXR5U3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use listFacilitiesResponseDescriptor instead')
const ListFacilitiesResponse$json = {
  '1': 'ListFacilitiesResponse',
  '2': [
    {
      '1': 'facilities',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.organization.v1.Facility',
      '10': 'facilities'
    },
    {
      '1': 'page',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.common.v1.PageResponse',
      '10': 'page'
    },
  ],
};

/// Descriptor for `ListFacilitiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFacilitiesResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0RmFjaWxpdGllc1Jlc3BvbnNlEkQKCmZhY2lsaXRpZXMYASADKAsyJC5oZWFsdGhjYX'
    'JlLm9yZ2FuaXphdGlvbi52MS5GYWNpbGl0eVIKZmFjaWxpdGllcxI2CgRwYWdlGAIgASgLMiIu'
    'aGVhbHRoY2FyZS5jb21tb24udjEuUGFnZVJlc3BvbnNlUgRwYWdl');

const $core.Map<$core.String, $core.dynamic> OrganizationServiceBase$json = {
  '1': 'OrganizationService',
  '2': [
    {
      '1': 'CreateTenant',
      '2': '.healthcare.organization.v1.CreateTenantRequest',
      '3': '.healthcare.organization.v1.CreateTenantResponse',
      '4': {}
    },
    {
      '1': 'GetTenant',
      '2': '.healthcare.organization.v1.GetTenantRequest',
      '3': '.healthcare.organization.v1.GetTenantResponse',
      '4': {}
    },
    {
      '1': 'CreateFacility',
      '2': '.healthcare.organization.v1.CreateFacilityRequest',
      '3': '.healthcare.organization.v1.CreateFacilityResponse',
      '4': {}
    },
    {
      '1': 'GetFacility',
      '2': '.healthcare.organization.v1.GetFacilityRequest',
      '3': '.healthcare.organization.v1.GetFacilityResponse',
      '4': {}
    },
    {
      '1': 'ListFacilities',
      '2': '.healthcare.organization.v1.ListFacilitiesRequest',
      '3': '.healthcare.organization.v1.ListFacilitiesResponse',
      '4': {}
    },
  ],
};

@$core.Deprecated('Use organizationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    OrganizationServiceBase$messageJson = {
  '.healthcare.organization.v1.CreateTenantRequest': CreateTenantRequest$json,
  '.healthcare.organization.v1.CreateTenantResponse': CreateTenantResponse$json,
  '.healthcare.organization.v1.Tenant': Tenant$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.organization.v1.GetTenantRequest': GetTenantRequest$json,
  '.healthcare.organization.v1.GetTenantResponse': GetTenantResponse$json,
  '.healthcare.organization.v1.CreateFacilityRequest':
      CreateFacilityRequest$json,
  '.healthcare.organization.v1.CreateFacilityResponse':
      CreateFacilityResponse$json,
  '.healthcare.organization.v1.Facility': Facility$json,
  '.healthcare.organization.v1.GetFacilityRequest': GetFacilityRequest$json,
  '.healthcare.organization.v1.GetFacilityResponse': GetFacilityResponse$json,
  '.healthcare.organization.v1.ListFacilitiesRequest':
      ListFacilitiesRequest$json,
  '.healthcare.common.v1.PageRequest': $1.PageRequest$json,
  '.healthcare.organization.v1.ListFacilitiesResponse':
      ListFacilitiesResponse$json,
  '.healthcare.common.v1.PageResponse': $1.PageResponse$json,
};

/// Descriptor for `OrganizationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List organizationServiceDescriptor = $convert.base64Decode(
    'ChNPcmdhbml6YXRpb25TZXJ2aWNlEnMKDENyZWF0ZVRlbmFudBIvLmhlYWx0aGNhcmUub3JnYW'
    '5pemF0aW9uLnYxLkNyZWF0ZVRlbmFudFJlcXVlc3QaMC5oZWFsdGhjYXJlLm9yZ2FuaXphdGlv'
    'bi52MS5DcmVhdGVUZW5hbnRSZXNwb25zZSIAEmoKCUdldFRlbmFudBIsLmhlYWx0aGNhcmUub3'
    'JnYW5pemF0aW9uLnYxLkdldFRlbmFudFJlcXVlc3QaLS5oZWFsdGhjYXJlLm9yZ2FuaXphdGlv'
    'bi52MS5HZXRUZW5hbnRSZXNwb25zZSIAEnkKDkNyZWF0ZUZhY2lsaXR5EjEuaGVhbHRoY2FyZS'
    '5vcmdhbml6YXRpb24udjEuQ3JlYXRlRmFjaWxpdHlSZXF1ZXN0GjIuaGVhbHRoY2FyZS5vcmdh'
    'bml6YXRpb24udjEuQ3JlYXRlRmFjaWxpdHlSZXNwb25zZSIAEnAKC0dldEZhY2lsaXR5Ei4uaG'
    'VhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuR2V0RmFjaWxpdHlSZXF1ZXN0Gi8uaGVhbHRoY2Fy'
    'ZS5vcmdhbml6YXRpb24udjEuR2V0RmFjaWxpdHlSZXNwb25zZSIAEnkKDkxpc3RGYWNpbGl0aW'
    'VzEjEuaGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuTGlzdEZhY2lsaXRpZXNSZXF1ZXN0GjIu'
    'aGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuTGlzdEZhY2lsaXRpZXNSZXNwb25zZSIA');
