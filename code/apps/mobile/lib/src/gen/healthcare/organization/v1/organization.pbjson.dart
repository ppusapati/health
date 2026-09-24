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

@$core.Deprecated('Use genderPolicyDescriptor instead')
const GenderPolicy$json = {
  '1': 'GenderPolicy',
  '2': [
    {'1': 'GENDER_POLICY_UNSPECIFIED', '2': 0},
    {'1': 'GENDER_POLICY_ANY', '2': 1},
    {'1': 'GENDER_POLICY_MALE_ONLY', '2': 2},
    {'1': 'GENDER_POLICY_FEMALE_ONLY', '2': 3},
  ],
};

/// Descriptor for `GenderPolicy`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List genderPolicyDescriptor = $convert.base64Decode(
    'CgxHZW5kZXJQb2xpY3kSHQoZR0VOREVSX1BPTElDWV9VTlNQRUNJRklFRBAAEhUKEUdFTkRFUl'
    '9QT0xJQ1lfQU5ZEAESGwoXR0VOREVSX1BPTElDWV9NQUxFX09OTFkQAhIdChlHRU5ERVJfUE9M'
    'SUNZX0ZFTUFMRV9PTkxZEAM=');

@$core.Deprecated('Use isolationCapabilityDescriptor instead')
const IsolationCapability$json = {
  '1': 'IsolationCapability',
  '2': [
    {'1': 'ISOLATION_CAPABILITY_UNSPECIFIED', '2': 0},
    {'1': 'ISOLATION_CAPABILITY_NONE', '2': 1},
    {'1': 'ISOLATION_CAPABILITY_CONTACT', '2': 2},
    {'1': 'ISOLATION_CAPABILITY_DROPLET', '2': 3},
    {'1': 'ISOLATION_CAPABILITY_AIRBORNE', '2': 4},
  ],
};

/// Descriptor for `IsolationCapability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List isolationCapabilityDescriptor = $convert.base64Decode(
    'ChNJc29sYXRpb25DYXBhYmlsaXR5EiQKIElTT0xBVElPTl9DQVBBQklMSVRZX1VOU1BFQ0lGSU'
    'VEEAASHQoZSVNPTEFUSU9OX0NBUEFCSUxJVFlfTk9ORRABEiAKHElTT0xBVElPTl9DQVBBQklM'
    'SVRZX0NPTlRBQ1QQAhIgChxJU09MQVRJT05fQ0FQQUJJTElUWV9EUk9QTEVUEAMSIQodSVNPTE'
    'FUSU9OX0NBUEFCSUxJVFlfQUlSQk9STkUQBA==');

@$core.Deprecated('Use bedAvailabilityDescriptor instead')
const BedAvailability$json = {
  '1': 'BedAvailability',
  '2': [
    {'1': 'BED_AVAILABILITY_UNSPECIFIED', '2': 0},
    {'1': 'BED_AVAILABILITY_AVAILABLE', '2': 1},
    {'1': 'BED_AVAILABILITY_OCCUPIED', '2': 2},
    {'1': 'BED_AVAILABILITY_CLEANING', '2': 3},
    {'1': 'BED_AVAILABILITY_BLOCKED', '2': 4},
    {'1': 'BED_AVAILABILITY_OUT_OF_SERVICE', '2': 5},
  ],
};

/// Descriptor for `BedAvailability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List bedAvailabilityDescriptor = $convert.base64Decode(
    'Cg9CZWRBdmFpbGFiaWxpdHkSIAocQkVEX0FWQUlMQUJJTElUWV9VTlNQRUNJRklFRBAAEh4KGk'
    'JFRF9BVkFJTEFCSUxJVFlfQVZBSUxBQkxFEAESHQoZQkVEX0FWQUlMQUJJTElUWV9PQ0NVUElF'
    'RBACEh0KGUJFRF9BVkFJTEFCSUxJVFlfQ0xFQU5JTkcQAxIcChhCRURfQVZBSUxBQklMSVRZX0'
    'JMT0NLRUQQBBIjCh9CRURfQVZBSUxBQklMSVRZX09VVF9PRl9TRVJWSUNFEAU=');

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

@$core.Deprecated('Use bedClassDescriptor instead')
const BedClass$json = {
  '1': 'BedClass',
  '2': [
    {'1': 'class_id', '3': 1, '4': 1, '5': 9, '10': 'classId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'charge_code', '3': 4, '4': 1, '5': 9, '10': 'chargeCode'},
    {'1': 'status', '3': 5, '4': 1, '5': 9, '10': 'status'},
    {'1': 'version', '3': 6, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `BedClass`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedClassDescriptor = $convert.base64Decode(
    'CghCZWRDbGFzcxIZCghjbGFzc19pZBgBIAEoCVIHY2xhc3NJZBISCgRjb2RlGAIgASgJUgRjb2'
    'RlEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWUSHwoLY2hhcmdlX2NvZGUYBCAB'
    'KAlSCmNoYXJnZUNvZGUSFgoGc3RhdHVzGAUgASgJUgZzdGF0dXMSGAoHdmVyc2lvbhgGIAEoA1'
    'IHdmVyc2lvbg==');

@$core.Deprecated('Use roomDescriptor instead')
const Room$json = {
  '1': 'Room',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 3, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 5, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'class_code', '3': 6, '4': 1, '5': 9, '10': 'classCode'},
    {
      '1': 'gender_policy',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.GenderPolicy',
      '10': 'genderPolicy'
    },
    {
      '1': 'isolation',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.IsolationCapability',
      '10': 'isolation'
    },
    {'1': 'status', '3': 9, '4': 1, '5': 9, '10': 'status'},
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Room`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomDescriptor = $convert.base64Decode(
    'CgRSb29tEhcKB3Jvb21faWQYASABKAlSBnJvb21JZBIfCgtmYWNpbGl0eV9pZBgCIAEoCVIKZm'
    'FjaWxpdHlJZBIXCgd1bml0X2lkGAMgASgJUgZ1bml0SWQSEgoEY29kZRgEIAEoCVIEY29kZRIh'
    'CgxkaXNwbGF5X25hbWUYBSABKAlSC2Rpc3BsYXlOYW1lEh0KCmNsYXNzX2NvZGUYBiABKAlSCW'
    'NsYXNzQ29kZRJNCg1nZW5kZXJfcG9saWN5GAcgASgOMiguaGVhbHRoY2FyZS5vcmdhbml6YXRp'
    'b24udjEuR2VuZGVyUG9saWN5UgxnZW5kZXJQb2xpY3kSTQoJaXNvbGF0aW9uGAggASgOMi8uaG'
    'VhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuSXNvbGF0aW9uQ2FwYWJpbGl0eVIJaXNvbGF0aW9u'
    'EhYKBnN0YXR1cxgJIAEoCVIGc3RhdHVzEhgKB3ZlcnNpb24YCiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use bedDescriptor instead')
const Bed$json = {
  '1': 'Bed',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'room_id', '3': 2, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'code', '3': 4, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 5, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'status', '3': 6, '4': 1, '5': 9, '10': 'status'},
    {
      '1': 'availability',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.BedAvailability',
      '10': 'availability'
    },
    {
      '1': 'unavailable_reason',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'unavailableReason'
    },
    {'1': 'version', '3': 9, '4': 1, '5': 3, '10': 'version'},
    {'1': 'usable', '3': 10, '4': 1, '5': 8, '10': 'usable'},
  ],
};

/// Descriptor for `Bed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedDescriptor = $convert.base64Decode(
    'CgNCZWQSFQoGYmVkX2lkGAEgASgJUgViZWRJZBIXCgdyb29tX2lkGAIgASgJUgZyb29tSWQSHw'
    'oLZmFjaWxpdHlfaWQYAyABKAlSCmZhY2lsaXR5SWQSEgoEY29kZRgEIAEoCVIEY29kZRIhCgxk'
    'aXNwbGF5X25hbWUYBSABKAlSC2Rpc3BsYXlOYW1lEhYKBnN0YXR1cxgGIAEoCVIGc3RhdHVzEk'
    '8KDGF2YWlsYWJpbGl0eRgHIAEoDjIrLmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkJlZEF2'
    'YWlsYWJpbGl0eVIMYXZhaWxhYmlsaXR5Ei0KEnVuYXZhaWxhYmxlX3JlYXNvbhgIIAEoCVIRdW'
    '5hdmFpbGFibGVSZWFzb24SGAoHdmVyc2lvbhgJIAEoA1IHdmVyc2lvbhIWCgZ1c2FibGUYCiAB'
    'KAhSBnVzYWJsZQ==');

@$core.Deprecated('Use bedPlaceDescriptor instead')
const BedPlace$json = {
  '1': 'BedPlace',
  '2': [
    {
      '1': 'bed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Bed',
      '10': 'bed'
    },
    {
      '1': 'room',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Room',
      '10': 'room'
    },
    {
      '1': 'class',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.BedClass',
      '10': 'class'
    },
  ],
};

/// Descriptor for `BedPlace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedPlaceDescriptor = $convert.base64Decode(
    'CghCZWRQbGFjZRIxCgNiZWQYASABKAsyHy5oZWFsdGhjYXJlLm9yZ2FuaXphdGlvbi52MS5CZW'
    'RSA2JlZBI0CgRyb29tGAIgASgLMiAuaGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuUm9vbVIE'
    'cm9vbRI6CgVjbGFzcxgDIAEoCzIkLmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkJlZENsYX'
    'NzUgVjbGFzcw==');

@$core.Deprecated('Use commissionOrgUnitRequestDescriptor instead')
const CommissionOrgUnitRequest$json = {
  '1': 'CommissionOrgUnitRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_type', '3': 2, '4': 1, '5': 9, '10': 'unitType'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'parent_unit_id', '3': 5, '4': 1, '5': 9, '10': 'parentUnitId'},
    {
      '1': 'effective_from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `CommissionOrgUnitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionOrgUnitRequestDescriptor = $convert.base64Decode(
    'ChhDb21taXNzaW9uT3JnVW5pdFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaX'
    'R5SWQSGwoJdW5pdF90eXBlGAIgASgJUgh1bml0VHlwZRISCgRjb2RlGAMgASgJUgRjb2RlEiEK'
    'DGRpc3BsYXlfbmFtZRgEIAEoCVILZGlzcGxheU5hbWUSJAoOcGFyZW50X3VuaXRfaWQYBSABKA'
    'lSDHBhcmVudFVuaXRJZBJBCg5lZmZlY3RpdmVfZnJvbRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SQwoPZWZmZWN0aXZlX3VudGlsGAcgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOZWZmZWN0aXZlVW50aWw=');

@$core.Deprecated('Use commissionOrgUnitResponseDescriptor instead')
const CommissionOrgUnitResponse$json = {
  '1': 'CommissionOrgUnitResponse',
  '2': [
    {'1': 'unit_id', '3': 1, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `CommissionOrgUnitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionOrgUnitResponseDescriptor =
    $convert.base64Decode(
        'ChlDb21taXNzaW9uT3JnVW5pdFJlc3BvbnNlEhcKB3VuaXRfaWQYASABKAlSBnVuaXRJZBISCg'
        'Rjb2RlGAIgASgJUgRjb2RlEiEKDGRpc3BsYXlfbmFtZRgDIAEoCVILZGlzcGxheU5hbWU=');

@$core.Deprecated('Use defineBedClassRequestDescriptor instead')
const DefineBedClassRequest$json = {
  '1': 'DefineBedClassRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'charge_code', '3': 3, '4': 1, '5': 9, '10': 'chargeCode'},
  ],
};

/// Descriptor for `DefineBedClassRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineBedClassRequestDescriptor = $convert.base64Decode(
    'ChVEZWZpbmVCZWRDbGFzc1JlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRIhCgxkaXNwbGF5X2'
    '5hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEh8KC2NoYXJnZV9jb2RlGAMgASgJUgpjaGFyZ2VDb2Rl');

@$core.Deprecated('Use defineBedClassResponseDescriptor instead')
const DefineBedClassResponse$json = {
  '1': 'DefineBedClassResponse',
  '2': [
    {
      '1': 'class',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.BedClass',
      '10': 'class'
    },
  ],
};

/// Descriptor for `DefineBedClassResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineBedClassResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWZpbmVCZWRDbGFzc1Jlc3BvbnNlEjoKBWNsYXNzGAEgASgLMiQuaGVhbHRoY2FyZS5vcm'
        'dhbml6YXRpb24udjEuQmVkQ2xhc3NSBWNsYXNz');

@$core.Deprecated('Use listBedClassesRequestDescriptor instead')
const ListBedClassesRequest$json = {
  '1': 'ListBedClassesRequest',
};

/// Descriptor for `ListBedClassesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBedClassesRequestDescriptor =
    $convert.base64Decode('ChVMaXN0QmVkQ2xhc3Nlc1JlcXVlc3Q=');

@$core.Deprecated('Use listBedClassesResponseDescriptor instead')
const ListBedClassesResponse$json = {
  '1': 'ListBedClassesResponse',
  '2': [
    {
      '1': 'classes',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.organization.v1.BedClass',
      '10': 'classes'
    },
  ],
};

/// Descriptor for `ListBedClassesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listBedClassesResponseDescriptor =
    $convert.base64Decode(
        'ChZMaXN0QmVkQ2xhc3Nlc1Jlc3BvbnNlEj4KB2NsYXNzZXMYASADKAsyJC5oZWFsdGhjYXJlLm'
        '9yZ2FuaXphdGlvbi52MS5CZWRDbGFzc1IHY2xhc3Nlcw==');

@$core.Deprecated('Use commissionRoomRequestDescriptor instead')
const CommissionRoomRequest$json = {
  '1': 'CommissionRoomRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'code', '3': 3, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 4, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'class_code', '3': 5, '4': 1, '5': 9, '10': 'classCode'},
    {
      '1': 'gender_policy',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.GenderPolicy',
      '10': 'genderPolicy'
    },
    {
      '1': 'isolation',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.IsolationCapability',
      '10': 'isolation'
    },
  ],
};

/// Descriptor for `CommissionRoomRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionRoomRequestDescriptor = $convert.base64Decode(
    'ChVDb21taXNzaW9uUm9vbVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SW'
    'QSFwoHdW5pdF9pZBgCIAEoCVIGdW5pdElkEhIKBGNvZGUYAyABKAlSBGNvZGUSIQoMZGlzcGxh'
    'eV9uYW1lGAQgASgJUgtkaXNwbGF5TmFtZRIdCgpjbGFzc19jb2RlGAUgASgJUgljbGFzc0NvZG'
    'USTQoNZ2VuZGVyX3BvbGljeRgGIAEoDjIoLmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkdl'
    'bmRlclBvbGljeVIMZ2VuZGVyUG9saWN5Ek0KCWlzb2xhdGlvbhgHIAEoDjIvLmhlYWx0aGNhcm'
    'Uub3JnYW5pemF0aW9uLnYxLklzb2xhdGlvbkNhcGFiaWxpdHlSCWlzb2xhdGlvbg==');

@$core.Deprecated('Use commissionRoomResponseDescriptor instead')
const CommissionRoomResponse$json = {
  '1': 'CommissionRoomResponse',
  '2': [
    {
      '1': 'room',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Room',
      '10': 'room'
    },
  ],
};

/// Descriptor for `CommissionRoomResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionRoomResponseDescriptor =
    $convert.base64Decode(
        'ChZDb21taXNzaW9uUm9vbVJlc3BvbnNlEjQKBHJvb20YASABKAsyIC5oZWFsdGhjYXJlLm9yZ2'
        'FuaXphdGlvbi52MS5Sb29tUgRyb29t');

@$core.Deprecated('Use commissionBedRequestDescriptor instead')
const CommissionBedRequest$json = {
  '1': 'CommissionBedRequest',
  '2': [
    {'1': 'room_id', '3': 1, '4': 1, '5': 9, '10': 'roomId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'display_name', '3': 3, '4': 1, '5': 9, '10': 'displayName'},
  ],
};

/// Descriptor for `CommissionBedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionBedRequestDescriptor = $convert.base64Decode(
    'ChRDb21taXNzaW9uQmVkUmVxdWVzdBIXCgdyb29tX2lkGAEgASgJUgZyb29tSWQSEgoEY29kZR'
    'gCIAEoCVIEY29kZRIhCgxkaXNwbGF5X25hbWUYAyABKAlSC2Rpc3BsYXlOYW1l');

@$core.Deprecated('Use commissionBedResponseDescriptor instead')
const CommissionBedResponse$json = {
  '1': 'CommissionBedResponse',
  '2': [
    {
      '1': 'bed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Bed',
      '10': 'bed'
    },
  ],
};

/// Descriptor for `CommissionBedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissionBedResponseDescriptor = $convert.base64Decode(
    'ChVDb21taXNzaW9uQmVkUmVzcG9uc2USMQoDYmVkGAEgASgLMh8uaGVhbHRoY2FyZS5vcmdhbm'
    'l6YXRpb24udjEuQmVkUgNiZWQ=');

@$core.Deprecated('Use setBedAvailabilityRequestDescriptor instead')
const SetBedAvailabilityRequest$json = {
  '1': 'SetBedAvailabilityRequest',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
    {
      '1': 'availability',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.organization.v1.BedAvailability',
      '10': 'availability'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'expected_version', '3': 4, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `SetBedAvailabilityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBedAvailabilityRequestDescriptor = $convert.base64Decode(
    'ChlTZXRCZWRBdmFpbGFiaWxpdHlSZXF1ZXN0EhUKBmJlZF9pZBgBIAEoCVIFYmVkSWQSTwoMYX'
    'ZhaWxhYmlsaXR5GAIgASgOMisuaGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuQmVkQXZhaWxh'
    'YmlsaXR5UgxhdmFpbGFiaWxpdHkSFgoGcmVhc29uGAMgASgJUgZyZWFzb24SKQoQZXhwZWN0ZW'
    'RfdmVyc2lvbhgEIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use setBedAvailabilityResponseDescriptor instead')
const SetBedAvailabilityResponse$json = {
  '1': 'SetBedAvailabilityResponse',
  '2': [
    {
      '1': 'bed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Bed',
      '10': 'bed'
    },
  ],
};

/// Descriptor for `SetBedAvailabilityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setBedAvailabilityResponseDescriptor =
    $convert.base64Decode(
        'ChpTZXRCZWRBdmFpbGFiaWxpdHlSZXNwb25zZRIxCgNiZWQYASABKAsyHy5oZWFsdGhjYXJlLm'
        '9yZ2FuaXphdGlvbi52MS5CZWRSA2JlZA==');

@$core.Deprecated('Use retireBedRequestDescriptor instead')
const RetireBedRequest$json = {
  '1': 'RetireBedRequest',
  '2': [
    {'1': 'bed_id', '3': 1, '4': 1, '5': 9, '10': 'bedId'},
    {'1': 'expected_version', '3': 2, '4': 1, '5': 3, '10': 'expectedVersion'},
  ],
};

/// Descriptor for `RetireBedRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireBedRequestDescriptor = $convert.base64Decode(
    'ChBSZXRpcmVCZWRSZXF1ZXN0EhUKBmJlZF9pZBgBIAEoCVIFYmVkSWQSKQoQZXhwZWN0ZWRfdm'
    'Vyc2lvbhgCIAEoA1IPZXhwZWN0ZWRWZXJzaW9u');

@$core.Deprecated('Use retireBedResponseDescriptor instead')
const RetireBedResponse$json = {
  '1': 'RetireBedResponse',
  '2': [
    {
      '1': 'bed',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.organization.v1.Bed',
      '10': 'bed'
    },
  ],
};

/// Descriptor for `RetireBedResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retireBedResponseDescriptor = $convert.base64Decode(
    'ChFSZXRpcmVCZWRSZXNwb25zZRIxCgNiZWQYASABKAsyHy5oZWFsdGhjYXJlLm9yZ2FuaXphdG'
    'lvbi52MS5CZWRSA2JlZA==');

@$core.Deprecated('Use bedBoardRequestDescriptor instead')
const BedBoardRequest$json = {
  '1': 'BedBoardRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'unit_id', '3': 2, '4': 1, '5': 9, '10': 'unitId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `BedBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedBoardRequestDescriptor = $convert.base64Decode(
    'Cg9CZWRCb2FyZFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSFwoHdW'
    '5pdF9pZBgCIAEoCVIGdW5pdElkEhsKCXBhZ2Vfc2l6ZRgDIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use bedBoardResponseDescriptor instead')
const BedBoardResponse$json = {
  '1': 'BedBoardResponse',
  '2': [
    {
      '1': 'places',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.organization.v1.BedPlace',
      '10': 'places'
    },
  ],
};

/// Descriptor for `BedBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bedBoardResponseDescriptor = $convert.base64Decode(
    'ChBCZWRCb2FyZFJlc3BvbnNlEjwKBnBsYWNlcxgBIAMoCzIkLmhlYWx0aGNhcmUub3JnYW5pem'
    'F0aW9uLnYxLkJlZFBsYWNlUgZwbGFjZXM=');

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
    {
      '1': 'CommissionOrgUnit',
      '2': '.healthcare.organization.v1.CommissionOrgUnitRequest',
      '3': '.healthcare.organization.v1.CommissionOrgUnitResponse',
      '4': {}
    },
    {
      '1': 'DefineBedClass',
      '2': '.healthcare.organization.v1.DefineBedClassRequest',
      '3': '.healthcare.organization.v1.DefineBedClassResponse',
      '4': {}
    },
    {
      '1': 'ListBedClasses',
      '2': '.healthcare.organization.v1.ListBedClassesRequest',
      '3': '.healthcare.organization.v1.ListBedClassesResponse',
      '4': {}
    },
    {
      '1': 'CommissionRoom',
      '2': '.healthcare.organization.v1.CommissionRoomRequest',
      '3': '.healthcare.organization.v1.CommissionRoomResponse',
      '4': {}
    },
    {
      '1': 'CommissionBed',
      '2': '.healthcare.organization.v1.CommissionBedRequest',
      '3': '.healthcare.organization.v1.CommissionBedResponse',
      '4': {}
    },
    {
      '1': 'SetBedAvailability',
      '2': '.healthcare.organization.v1.SetBedAvailabilityRequest',
      '3': '.healthcare.organization.v1.SetBedAvailabilityResponse',
      '4': {}
    },
    {
      '1': 'RetireBed',
      '2': '.healthcare.organization.v1.RetireBedRequest',
      '3': '.healthcare.organization.v1.RetireBedResponse',
      '4': {}
    },
    {
      '1': 'BedBoard',
      '2': '.healthcare.organization.v1.BedBoardRequest',
      '3': '.healthcare.organization.v1.BedBoardResponse',
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
  '.healthcare.organization.v1.CommissionOrgUnitRequest':
      CommissionOrgUnitRequest$json,
  '.healthcare.organization.v1.CommissionOrgUnitResponse':
      CommissionOrgUnitResponse$json,
  '.healthcare.organization.v1.DefineBedClassRequest':
      DefineBedClassRequest$json,
  '.healthcare.organization.v1.DefineBedClassResponse':
      DefineBedClassResponse$json,
  '.healthcare.organization.v1.BedClass': BedClass$json,
  '.healthcare.organization.v1.ListBedClassesRequest':
      ListBedClassesRequest$json,
  '.healthcare.organization.v1.ListBedClassesResponse':
      ListBedClassesResponse$json,
  '.healthcare.organization.v1.CommissionRoomRequest':
      CommissionRoomRequest$json,
  '.healthcare.organization.v1.CommissionRoomResponse':
      CommissionRoomResponse$json,
  '.healthcare.organization.v1.Room': Room$json,
  '.healthcare.organization.v1.CommissionBedRequest': CommissionBedRequest$json,
  '.healthcare.organization.v1.CommissionBedResponse':
      CommissionBedResponse$json,
  '.healthcare.organization.v1.Bed': Bed$json,
  '.healthcare.organization.v1.SetBedAvailabilityRequest':
      SetBedAvailabilityRequest$json,
  '.healthcare.organization.v1.SetBedAvailabilityResponse':
      SetBedAvailabilityResponse$json,
  '.healthcare.organization.v1.RetireBedRequest': RetireBedRequest$json,
  '.healthcare.organization.v1.RetireBedResponse': RetireBedResponse$json,
  '.healthcare.organization.v1.BedBoardRequest': BedBoardRequest$json,
  '.healthcare.organization.v1.BedBoardResponse': BedBoardResponse$json,
  '.healthcare.organization.v1.BedPlace': BedPlace$json,
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
    'aGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuTGlzdEZhY2lsaXRpZXNSZXNwb25zZSIAEoIBCh'
    'FDb21taXNzaW9uT3JnVW5pdBI0LmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkNvbW1pc3Np'
    'b25PcmdVbml0UmVxdWVzdBo1LmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkNvbW1pc3Npb2'
    '5PcmdVbml0UmVzcG9uc2UiABJ5Cg5EZWZpbmVCZWRDbGFzcxIxLmhlYWx0aGNhcmUub3JnYW5p'
    'emF0aW9uLnYxLkRlZmluZUJlZENsYXNzUmVxdWVzdBoyLmhlYWx0aGNhcmUub3JnYW5pemF0aW'
    '9uLnYxLkRlZmluZUJlZENsYXNzUmVzcG9uc2UiABJ5Cg5MaXN0QmVkQ2xhc3NlcxIxLmhlYWx0'
    'aGNhcmUub3JnYW5pemF0aW9uLnYxLkxpc3RCZWRDbGFzc2VzUmVxdWVzdBoyLmhlYWx0aGNhcm'
    'Uub3JnYW5pemF0aW9uLnYxLkxpc3RCZWRDbGFzc2VzUmVzcG9uc2UiABJ5Cg5Db21taXNzaW9u'
    'Um9vbRIxLmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkNvbW1pc3Npb25Sb29tUmVxdWVzdB'
    'oyLmhlYWx0aGNhcmUub3JnYW5pemF0aW9uLnYxLkNvbW1pc3Npb25Sb29tUmVzcG9uc2UiABJ2'
    'Cg1Db21taXNzaW9uQmVkEjAuaGVhbHRoY2FyZS5vcmdhbml6YXRpb24udjEuQ29tbWlzc2lvbk'
    'JlZFJlcXVlc3QaMS5oZWFsdGhjYXJlLm9yZ2FuaXphdGlvbi52MS5Db21taXNzaW9uQmVkUmVz'
    'cG9uc2UiABKFAQoSU2V0QmVkQXZhaWxhYmlsaXR5EjUuaGVhbHRoY2FyZS5vcmdhbml6YXRpb2'
    '4udjEuU2V0QmVkQXZhaWxhYmlsaXR5UmVxdWVzdBo2LmhlYWx0aGNhcmUub3JnYW5pemF0aW9u'
    'LnYxLlNldEJlZEF2YWlsYWJpbGl0eVJlc3BvbnNlIgASagoJUmV0aXJlQmVkEiwuaGVhbHRoY2'
    'FyZS5vcmdhbml6YXRpb24udjEuUmV0aXJlQmVkUmVxdWVzdBotLmhlYWx0aGNhcmUub3JnYW5p'
    'emF0aW9uLnYxLlJldGlyZUJlZFJlc3BvbnNlIgASZwoIQmVkQm9hcmQSKy5oZWFsdGhjYXJlLm'
    '9yZ2FuaXphdGlvbi52MS5CZWRCb2FyZFJlcXVlc3QaLC5oZWFsdGhjYXJlLm9yZ2FuaXphdGlv'
    'bi52MS5CZWRCb2FyZFJlc3BvbnNlIgA=');
