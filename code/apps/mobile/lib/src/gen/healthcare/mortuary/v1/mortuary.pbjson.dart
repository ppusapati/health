// This is a generated file - do not edit.
//
// Generated from healthcare/mortuary/v1/mortuary.proto.

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

@$core.Deprecated('Use sourceDescriptor instead')
const Source$json = {
  '1': 'Source',
  '2': [
    {'1': 'SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'SOURCE_IN_HOSPITAL', '2': 1},
    {'1': 'SOURCE_BROUGHT_IN', '2': 2},
  ],
};

/// Descriptor for `Source`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceDescriptor = $convert.base64Decode(
    'CgZTb3VyY2USFgoSU09VUkNFX1VOU1BFQ0lGSUVEEAASFgoSU09VUkNFX0lOX0hPU1BJVEFMEA'
    'ESFQoRU09VUkNFX0JST1VHSFRfSU4QAg==');

@$core.Deprecated('Use identityDescriptor instead')
const Identity$json = {
  '1': 'Identity',
  '2': [
    {'1': 'IDENTITY_UNSPECIFIED', '2': 0},
    {'1': 'IDENTITY_UNIDENTIFIED', '2': 1},
    {'1': 'IDENTITY_PRESUMED', '2': 2},
    {'1': 'IDENTITY_CONFIRMED', '2': 3},
  ],
};

/// Descriptor for `Identity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List identityDescriptor = $convert.base64Decode(
    'CghJZGVudGl0eRIYChRJREVOVElUWV9VTlNQRUNJRklFRBAAEhkKFUlERU5USVRZX1VOSURFTl'
    'RJRklFRBABEhUKEUlERU5USVRZX1BSRVNVTUVEEAISFgoSSURFTlRJVFlfQ09ORklSTUVEEAM=');

@$core.Deprecated('Use caseStateDescriptor instead')
const CaseState$json = {
  '1': 'CaseState',
  '2': [
    {'1': 'CASE_STATE_UNSPECIFIED', '2': 0},
    {'1': 'CASE_STATE_RECEIVED', '2': 1},
    {'1': 'CASE_STATE_STORED', '2': 2},
    {'1': 'CASE_STATE_RELEASED', '2': 3},
  ],
};

/// Descriptor for `CaseState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List caseStateDescriptor = $convert.base64Decode(
    'CglDYXNlU3RhdGUSGgoWQ0FTRV9TVEFURV9VTlNQRUNJRklFRBAAEhcKE0NBU0VfU1RBVEVfUk'
    'VDRUlWRUQQARIVChFDQVNFX1NUQVRFX1NUT1JFRBACEhcKE0NBU0VfU1RBVEVfUkVMRUFTRUQQ'
    'Aw==');

@$core.Deprecated('Use spaceKindDescriptor instead')
const SpaceKind$json = {
  '1': 'SpaceKind',
  '2': [
    {'1': 'SPACE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SPACE_KIND_REFRIGERATED', '2': 1},
    {'1': 'SPACE_KIND_FREEZER', '2': 2},
    {'1': 'SPACE_KIND_VIEWING', '2': 3},
    {'1': 'SPACE_KIND_POSTMORTEM', '2': 4},
  ],
};

/// Descriptor for `SpaceKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List spaceKindDescriptor = $convert.base64Decode(
    'CglTcGFjZUtpbmQSGgoWU1BBQ0VfS0lORF9VTlNQRUNJRklFRBAAEhsKF1NQQUNFX0tJTkRfUk'
    'VGUklHRVJBVEVEEAESFgoSU1BBQ0VfS0lORF9GUkVFWkVSEAISFgoSU1BBQ0VfS0lORF9WSUVX'
    'SU5HEAMSGQoVU1BBQ0VfS0lORF9QT1NUTU9SVEVNEAQ=');

@$core.Deprecated('Use placementStateDescriptor instead')
const PlacementState$json = {
  '1': 'PlacementState',
  '2': [
    {'1': 'PLACEMENT_STATE_UNSPECIFIED', '2': 0},
    {'1': 'PLACEMENT_STATE_CURRENT', '2': 1},
    {'1': 'PLACEMENT_STATE_ENDED', '2': 2},
  ],
};

/// Descriptor for `PlacementState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List placementStateDescriptor = $convert.base64Decode(
    'Cg5QbGFjZW1lbnRTdGF0ZRIfChtQTEFDRU1FTlRfU1RBVEVfVU5TUEVDSUZJRUQQABIbChdQTE'
    'FDRU1FTlRfU1RBVEVfQ1VSUkVOVBABEhkKFVBMQUNFTUVOVF9TVEFURV9FTkRFRBAC');

@$core.Deprecated('Use itemKindDescriptor instead')
const ItemKind$json = {
  '1': 'ItemKind',
  '2': [
    {'1': 'ITEM_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ITEM_KIND_VALUABLE', '2': 1},
    {'1': 'ITEM_KIND_DOCUMENT', '2': 2},
    {'1': 'ITEM_KIND_CLOTHING', '2': 3},
    {'1': 'ITEM_KIND_OTHER', '2': 4},
  ],
};

/// Descriptor for `ItemKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List itemKindDescriptor = $convert.base64Decode(
    'CghJdGVtS2luZBIZChVJVEVNX0tJTkRfVU5TUEVDSUZJRUQQABIWChJJVEVNX0tJTkRfVkFMVU'
    'FCTEUQARIWChJJVEVNX0tJTkRfRE9DVU1FTlQQAhIWChJJVEVNX0tJTkRfQ0xPVEhJTkcQAxIT'
    'Cg9JVEVNX0tJTkRfT1RIRVIQBA==');

@$core.Deprecated('Use itemStateDescriptor instead')
const ItemState$json = {
  '1': 'ItemState',
  '2': [
    {'1': 'ITEM_STATE_UNSPECIFIED', '2': 0},
    {'1': 'ITEM_STATE_HELD', '2': 1},
    {'1': 'ITEM_STATE_HANDED_OVER', '2': 2},
    {'1': 'ITEM_STATE_RETAINED', '2': 3},
  ],
};

/// Descriptor for `ItemState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List itemStateDescriptor = $convert.base64Decode(
    'CglJdGVtU3RhdGUSGgoWSVRFTV9TVEFURV9VTlNQRUNJRklFRBAAEhMKD0lURU1fU1RBVEVfSE'
    'VMRBABEhoKFklURU1fU1RBVEVfSEFOREVEX09WRVIQAhIXChNJVEVNX1NUQVRFX1JFVEFJTkVE'
    'EAM=');

@$core.Deprecated('Use postmortemKindDescriptor instead')
const PostmortemKind$json = {
  '1': 'PostmortemKind',
  '2': [
    {'1': 'POSTMORTEM_KIND_UNSPECIFIED', '2': 0},
    {'1': 'POSTMORTEM_KIND_CLINICAL', '2': 1},
    {'1': 'POSTMORTEM_KIND_MEDICO_LEGAL', '2': 2},
  ],
};

/// Descriptor for `PostmortemKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List postmortemKindDescriptor = $convert.base64Decode(
    'Cg5Qb3N0bW9ydGVtS2luZBIfChtQT1NUTU9SVEVNX0tJTkRfVU5TUEVDSUZJRUQQABIcChhQT1'
    'NUTU9SVEVNX0tJTkRfQ0xJTklDQUwQARIgChxQT1NUTU9SVEVNX0tJTkRfTUVESUNPX0xFR0FM'
    'EAI=');

@$core.Deprecated('Use postmortemStateDescriptor instead')
const PostmortemState$json = {
  '1': 'PostmortemState',
  '2': [
    {'1': 'POSTMORTEM_STATE_UNSPECIFIED', '2': 0},
    {'1': 'POSTMORTEM_STATE_REQUESTED', '2': 1},
    {'1': 'POSTMORTEM_STATE_AUTHORISED', '2': 2},
    {'1': 'POSTMORTEM_STATE_PERFORMED', '2': 3},
    {'1': 'POSTMORTEM_STATE_REPORTED', '2': 4},
    {'1': 'POSTMORTEM_STATE_DECLINED', '2': 5},
  ],
};

/// Descriptor for `PostmortemState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List postmortemStateDescriptor = $convert.base64Decode(
    'Cg9Qb3N0bW9ydGVtU3RhdGUSIAocUE9TVE1PUlRFTV9TVEFURV9VTlNQRUNJRklFRBAAEh4KGl'
    'BPU1RNT1JURU1fU1RBVEVfUkVRVUVTVEVEEAESHwobUE9TVE1PUlRFTV9TVEFURV9BVVRIT1JJ'
    'U0VEEAISHgoaUE9TVE1PUlRFTV9TVEFURV9QRVJGT1JNRUQQAxIdChlQT1NUTU9SVEVNX1NUQV'
    'RFX1JFUE9SVEVEEAQSHQoZUE9TVE1PUlRFTV9TVEFURV9ERUNMSU5FRBAF');

@$core.Deprecated('Use caseDescriptor instead')
const Case$json = {
  '1': 'Case',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'source',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Source',
      '10': 'source'
    },
    {'1': 'encounter_id', '3': 4, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 5, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'external_source', '3': 6, '4': 1, '5': 9, '10': 'externalSource'},
    {
      '1': 'identity',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Identity',
      '10': 'identity'
    },
    {'1': 'identified_by', '3': 8, '4': 1, '5': 9, '10': 'identifiedBy'},
    {
      '1': 'identified_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'identifiedAt'
    },
    {'1': 'identified_note', '3': 10, '4': 1, '5': 9, '10': 'identifiedNote'},
    {'1': 'display_name', '3': 11, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'medico_legal', '3': 12, '4': 1, '5': 8, '10': 'medicoLegal'},
    {'1': 'mlc_reference', '3': 13, '4': 1, '5': 9, '10': 'mlcReference'},
    {'1': 'restricted', '3': 14, '4': 1, '5': 8, '10': 'restricted'},
    {'1': 'cause_summary', '3': 15, '4': 1, '5': 9, '10': 'causeSummary'},
    {
      '1': 'death_certificate_ref',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'deathCertificateRef'
    },
    {
      '1': 'certificate_recorded_by',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'certificateRecordedBy'
    },
    {
      '1': 'certificate_recorded_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'certificateRecordedAt'
    },
    {
      '1': 'state',
      '3': 19,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.CaseState',
      '10': 'state'
    },
    {'1': 'location_id', '3': 20, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'storage_tag', '3': 21, '4': 1, '5': 9, '10': 'storageTag'},
    {
      '1': 'died_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'diedAt'
    },
    {
      '1': 'received_at',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'received_by', '3': 24, '4': 1, '5': 9, '10': 'receivedBy'},
    {'1': 'facility_id', '3': 25, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'version', '3': 26, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Case`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List caseDescriptor = $convert.base64Decode(
    'CgRDYXNlEhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIcCglyZWZlcmVuY2UYAiABKAlSCXJlZm'
    'VyZW5jZRI2CgZzb3VyY2UYAyABKA4yHi5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlNvdXJjZVIG'
    'c291cmNlEiEKDGVuY291bnRlcl9pZBgEIAEoCVILZW5jb3VudGVySWQSHQoKcGF0aWVudF9pZB'
    'gFIAEoCVIJcGF0aWVudElkEicKD2V4dGVybmFsX3NvdXJjZRgGIAEoCVIOZXh0ZXJuYWxTb3Vy'
    'Y2USPAoIaWRlbnRpdHkYByABKA4yIC5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLklkZW50aXR5Ug'
    'hpZGVudGl0eRIjCg1pZGVudGlmaWVkX2J5GAggASgJUgxpZGVudGlmaWVkQnkSPwoNaWRlbnRp'
    'ZmllZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGlkZW50aWZpZWRBdB'
    'InCg9pZGVudGlmaWVkX25vdGUYCiABKAlSDmlkZW50aWZpZWROb3RlEiEKDGRpc3BsYXlfbmFt'
    'ZRgLIAEoCVILZGlzcGxheU5hbWUSIQoMbWVkaWNvX2xlZ2FsGAwgASgIUgttZWRpY29MZWdhbB'
    'IjCg1tbGNfcmVmZXJlbmNlGA0gASgJUgxtbGNSZWZlcmVuY2USHgoKcmVzdHJpY3RlZBgOIAEo'
    'CFIKcmVzdHJpY3RlZBIjCg1jYXVzZV9zdW1tYXJ5GA8gASgJUgxjYXVzZVN1bW1hcnkSMgoVZG'
    'VhdGhfY2VydGlmaWNhdGVfcmVmGBAgASgJUhNkZWF0aENlcnRpZmljYXRlUmVmEjYKF2NlcnRp'
    'ZmljYXRlX3JlY29yZGVkX2J5GBEgASgJUhVjZXJ0aWZpY2F0ZVJlY29yZGVkQnkSUgoXY2VydG'
    'lmaWNhdGVfcmVjb3JkZWRfYXQYEiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhVj'
    'ZXJ0aWZpY2F0ZVJlY29yZGVkQXQSNwoFc3RhdGUYEyABKA4yIS5oZWFsdGhjYXJlLm1vcnR1YX'
    'J5LnYxLkNhc2VTdGF0ZVIFc3RhdGUSHwoLbG9jYXRpb25faWQYFCABKAlSCmxvY2F0aW9uSWQS'
    'HwoLc3RvcmFnZV90YWcYFSABKAlSCnN0b3JhZ2VUYWcSMwoHZGllZF9hdBgWIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmRpZWRBdBI7CgtyZWNlaXZlZF9hdBgXIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY2VpdmVkQXQSHwoLcmVjZWl2ZWRfYnkYGCABKA'
    'lSCnJlY2VpdmVkQnkSHwoLZmFjaWxpdHlfaWQYGSABKAlSCmZhY2lsaXR5SWQSGAoHdmVyc2lv'
    'bhgaIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use locationDescriptor instead')
const Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.SpaceKind',
      '10': 'kind'
    },
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 5, '4': 1, '5': 9, '10': 'zone'},
    {'1': 'out_of_service', '3': 6, '4': 1, '5': 8, '10': 'outOfService'},
    {
      '1': 'out_of_service_reason',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'outOfServiceReason'
    },
    {'1': 'version', '3': 8, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Location`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List locationDescriptor = $convert.base64Decode(
    'CghMb2NhdGlvbhIfCgtsb2NhdGlvbl9pZBgBIAEoCVIKbG9jYXRpb25JZBISCgRjb2RlGAIgAS'
    'gJUgRjb2RlEjUKBGtpbmQYAyABKA4yIS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlNwYWNlS2lu'
    'ZFIEa2luZBIfCgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBISCgR6b25lGAUgASgJUg'
    'R6b25lEiQKDm91dF9vZl9zZXJ2aWNlGAYgASgIUgxvdXRPZlNlcnZpY2USMQoVb3V0X29mX3Nl'
    'cnZpY2VfcmVhc29uGAcgASgJUhJvdXRPZlNlcnZpY2VSZWFzb24SGAoHdmVyc2lvbhgIIAEoA1'
    'IHdmVyc2lvbg==');

@$core.Deprecated('Use placementDescriptor instead')
const Placement$json = {
  '1': 'Placement',
  '2': [
    {'1': 'placement_id', '3': 1, '4': 1, '5': 9, '10': 'placementId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'storage_tag', '3': 4, '4': 1, '5': 9, '10': 'storageTag'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.PlacementState',
      '10': 'state'
    },
    {
      '1': 'identity_checked_by',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'identityCheckedBy'
    },
    {
      '1': 'identity_checked_note',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'identityCheckedNote'
    },
    {
      '1': 'placed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'placedAt'
    },
    {'1': 'placed_by', '3': 9, '4': 1, '5': 9, '10': 'placedBy'},
    {
      '1': 'ended_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endedAt'
    },
    {'1': 'ended_by', '3': 11, '4': 1, '5': 9, '10': 'endedBy'},
    {'1': 'ended_reason', '3': 12, '4': 1, '5': 9, '10': 'endedReason'},
  ],
};

/// Descriptor for `Placement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placementDescriptor = $convert.base64Decode(
    'CglQbGFjZW1lbnQSIQoMcGxhY2VtZW50X2lkGAEgASgJUgtwbGFjZW1lbnRJZBIXCgdjYXNlX2'
    'lkGAIgASgJUgZjYXNlSWQSHwoLbG9jYXRpb25faWQYAyABKAlSCmxvY2F0aW9uSWQSHwoLc3Rv'
    'cmFnZV90YWcYBCABKAlSCnN0b3JhZ2VUYWcSPAoFc3RhdGUYBSABKA4yJi5oZWFsdGhjYXJlLm'
    '1vcnR1YXJ5LnYxLlBsYWNlbWVudFN0YXRlUgVzdGF0ZRIuChNpZGVudGl0eV9jaGVja2VkX2J5'
    'GAYgASgJUhFpZGVudGl0eUNoZWNrZWRCeRIyChVpZGVudGl0eV9jaGVja2VkX25vdGUYByABKA'
    'lSE2lkZW50aXR5Q2hlY2tlZE5vdGUSNwoJcGxhY2VkX2F0GAggASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIIcGxhY2VkQXQSGwoJcGxhY2VkX2J5GAkgASgJUghwbGFjZWRCeRI1Cg'
    'hlbmRlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSB2VuZGVkQXQSGQoI'
    'ZW5kZWRfYnkYCyABKAlSB2VuZGVkQnkSIQoMZW5kZWRfcmVhc29uGAwgASgJUgtlbmRlZFJlYX'
    'Nvbg==');

@$core.Deprecated('Use itemDescriptor instead')
const Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.ItemKind',
      '10': 'kind'
    },
    {'1': 'description', '3': 4, '4': 1, '5': 9, '10': 'description'},
    {'1': 'quantity', '3': 5, '4': 1, '5': 5, '10': 'quantity'},
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.ItemState',
      '10': 'state'
    },
    {'1': 'seal_number', '3': 7, '4': 1, '5': 9, '10': 'sealNumber'},
    {
      '1': 'listed_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'listedAt'
    },
    {'1': 'listed_by', '3': 9, '4': 1, '5': 9, '10': 'listedBy'},
    {'1': 'witnessed_by', '3': 10, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'handover_id', '3': 11, '4': 1, '5': 9, '10': 'handoverId'},
  ],
};

/// Descriptor for `Item`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List itemDescriptor = $convert.base64Decode(
    'CgRJdGVtEhcKB2l0ZW1faWQYASABKAlSBml0ZW1JZBIXCgdjYXNlX2lkGAIgASgJUgZjYXNlSW'
    'QSNAoEa2luZBgDIAEoDjIgLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuSXRlbUtpbmRSBGtpbmQS'
    'IAoLZGVzY3JpcHRpb24YBCABKAlSC2Rlc2NyaXB0aW9uEhoKCHF1YW50aXR5GAUgASgFUghxdW'
    'FudGl0eRI3CgVzdGF0ZRgGIAEoDjIhLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuSXRlbVN0YXRl'
    'UgVzdGF0ZRIfCgtzZWFsX251bWJlchgHIAEoCVIKc2VhbE51bWJlchI3CglsaXN0ZWRfYXQYCC'
    'ABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghsaXN0ZWRBdBIbCglsaXN0ZWRfYnkY'
    'CSABKAlSCGxpc3RlZEJ5EiEKDHdpdG5lc3NlZF9ieRgKIAEoCVILd2l0bmVzc2VkQnkSHwoLaG'
    'FuZG92ZXJfaWQYCyABKAlSCmhhbmRvdmVySWQ=');

@$core.Deprecated('Use handoverDescriptor instead')
const Handover$json = {
  '1': 'Handover',
  '2': [
    {'1': 'handover_id', '3': 1, '4': 1, '5': 9, '10': 'handoverId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'recipient_name', '3': 3, '4': 1, '5': 9, '10': 'recipientName'},
    {
      '1': 'recipient_relation',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'recipientRelation'
    },
    {'1': 'recipient_id_type', '3': 5, '4': 1, '5': 9, '10': 'recipientIdType'},
    {'1': 'recipient_id_ref', '3': 6, '4': 1, '5': 9, '10': 'recipientIdRef'},
    {'1': 'signature_ref', '3': 7, '4': 1, '5': 9, '10': 'signatureRef'},
    {'1': 'item_ids', '3': 8, '4': 3, '5': 9, '10': 'itemIds'},
    {
      '1': 'handed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'handedAt'
    },
    {'1': 'handed_by', '3': 10, '4': 1, '5': 9, '10': 'handedBy'},
    {'1': 'witnessed_by', '3': 11, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'note', '3': 12, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Handover`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handoverDescriptor = $convert.base64Decode(
    'CghIYW5kb3ZlchIfCgtoYW5kb3Zlcl9pZBgBIAEoCVIKaGFuZG92ZXJJZBIXCgdjYXNlX2lkGA'
    'IgASgJUgZjYXNlSWQSJQoOcmVjaXBpZW50X25hbWUYAyABKAlSDXJlY2lwaWVudE5hbWUSLQoS'
    'cmVjaXBpZW50X3JlbGF0aW9uGAQgASgJUhFyZWNpcGllbnRSZWxhdGlvbhIqChFyZWNpcGllbn'
    'RfaWRfdHlwZRgFIAEoCVIPcmVjaXBpZW50SWRUeXBlEigKEHJlY2lwaWVudF9pZF9yZWYYBiAB'
    'KAlSDnJlY2lwaWVudElkUmVmEiMKDXNpZ25hdHVyZV9yZWYYByABKAlSDHNpZ25hdHVyZVJlZh'
    'IZCghpdGVtX2lkcxgIIAMoCVIHaXRlbUlkcxI3CgloYW5kZWRfYXQYCSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUghoYW5kZWRBdBIbCgloYW5kZWRfYnkYCiABKAlSCGhhbmRlZE'
    'J5EiEKDHdpdG5lc3NlZF9ieRgLIAEoCVILd2l0bmVzc2VkQnkSEgoEbm90ZRgMIAEoCVIEbm90'
    'ZQ==');

@$core.Deprecated('Use custodyEntryDescriptor instead')
const CustodyEntry$json = {
  '1': 'CustodyEntry',
  '2': [
    {'1': 'entry_id', '3': 1, '4': 1, '5': 9, '10': 'entryId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'event', '3': 3, '4': 1, '5': 9, '10': 'event'},
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'from_party', '3': 5, '4': 1, '5': 9, '10': 'fromParty'},
    {'1': 'to_party', '3': 6, '4': 1, '5': 9, '10': 'toParty'},
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

/// Descriptor for `CustodyEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List custodyEntryDescriptor = $convert.base64Decode(
    'CgxDdXN0b2R5RW50cnkSGQoIZW50cnlfaWQYASABKAlSB2VudHJ5SWQSFwoHY2FzZV9pZBgCIA'
    'EoCVIGY2FzZUlkEhQKBWV2ZW50GAMgASgJUgVldmVudBIWCgZkZXRhaWwYBCABKAlSBmRldGFp'
    'bBIdCgpmcm9tX3BhcnR5GAUgASgJUglmcm9tUGFydHkSGQoIdG9fcGFydHkYBiABKAlSB3RvUG'
    'FydHkSOwoLcmVjb3JkZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpy'
    'ZWNvcmRlZEF0Eh8KC3JlY29yZGVkX2J5GAggASgJUgpyZWNvcmRlZEJ5');

@$core.Deprecated('Use postmortemDescriptor instead')
const Postmortem$json = {
  '1': 'Postmortem',
  '2': [
    {'1': 'postmortem_id', '3': 1, '4': 1, '5': 9, '10': 'postmortemId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.PostmortemKind',
      '10': 'kind'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.PostmortemState',
      '10': 'state'
    },
    {'1': 'authority', '3': 6, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'authority_reference',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'authorityReference'
    },
    {'1': 'authorised_by', '3': 8, '4': 1, '5': 9, '10': 'authorisedBy'},
    {
      '1': 'authorised_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'authorisedAt'
    },
    {'1': 'performed_by', '3': 10, '4': 1, '5': 9, '10': 'performedBy'},
    {
      '1': 'performed_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'performedAt'
    },
    {'1': 'report_ref', '3': 12, '4': 1, '5': 9, '10': 'reportRef'},
    {
      '1': 'reported_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reportedAt'
    },
    {'1': 'decline_reason', '3': 14, '4': 1, '5': 9, '10': 'declineReason'},
    {
      '1': 'requested_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'requestedAt'
    },
    {'1': 'requested_by', '3': 16, '4': 1, '5': 9, '10': 'requestedBy'},
    {'1': 'version', '3': 17, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Postmortem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List postmortemDescriptor = $convert.base64Decode(
    'CgpQb3N0bW9ydGVtEiMKDXBvc3Rtb3J0ZW1faWQYASABKAlSDHBvc3Rtb3J0ZW1JZBIXCgdjYX'
    'NlX2lkGAIgASgJUgZjYXNlSWQSOgoEa2luZBgDIAEoDjImLmhlYWx0aGNhcmUubW9ydHVhcnku'
    'djEuUG9zdG1vcnRlbUtpbmRSBGtpbmQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24SPQoFc3RhdG'
    'UYBSABKA4yJy5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlBvc3Rtb3J0ZW1TdGF0ZVIFc3RhdGUS'
    'HAoJYXV0aG9yaXR5GAYgASgJUglhdXRob3JpdHkSLwoTYXV0aG9yaXR5X3JlZmVyZW5jZRgHIA'
    'EoCVISYXV0aG9yaXR5UmVmZXJlbmNlEiMKDWF1dGhvcmlzZWRfYnkYCCABKAlSDGF1dGhvcmlz'
    'ZWRCeRI/Cg1hdXRob3Jpc2VkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IMYXV0aG9yaXNlZEF0EiEKDHBlcmZvcm1lZF9ieRgKIAEoCVILcGVyZm9ybWVkQnkSPQoMcGVy'
    'Zm9ybWVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILcGVyZm9ybWVkQX'
    'QSHQoKcmVwb3J0X3JlZhgMIAEoCVIJcmVwb3J0UmVmEjsKC3JlcG9ydGVkX2F0GA0gASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVwb3J0ZWRBdBIlCg5kZWNsaW5lX3JlYXNvbh'
    'gOIAEoCVINZGVjbGluZVJlYXNvbhI9CgxyZXF1ZXN0ZWRfYXQYDyABKAsyGi5nb29nbGUucHJv'
    'dG9idWYuVGltZXN0YW1wUgtyZXF1ZXN0ZWRBdBIhCgxyZXF1ZXN0ZWRfYnkYECABKAlSC3JlcX'
    'Vlc3RlZEJ5EhgKB3ZlcnNpb24YESABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use authorisationDescriptor instead')
const Authorisation$json = {
  '1': 'Authorisation',
  '2': [
    {'1': 'authority', '3': 1, '4': 1, '5': 9, '10': 'authority'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'recorded_by', '3': 3, '4': 1, '5': 9, '10': 'recordedBy'},
    {
      '1': 'recorded_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'note', '3': 5, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Authorisation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorisationDescriptor = $convert.base64Decode(
    'Cg1BdXRob3Jpc2F0aW9uEhwKCWF1dGhvcml0eRgBIAEoCVIJYXV0aG9yaXR5EhwKCXJlZmVyZW'
    '5jZRgCIAEoCVIJcmVmZXJlbmNlEh8KC3JlY29yZGVkX2J5GAMgASgJUgpyZWNvcmRlZEJ5EjsK'
    'C3JlY29yZGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3JkZW'
    'RBdBISCgRub3RlGAUgASgJUgRub3Rl');

@$core.Deprecated('Use releaseCheckDescriptor instead')
const ReleaseCheck$json = {
  '1': 'ReleaseCheck',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'detail', '3': 2, '4': 1, '5': 9, '10': 'detail'},
    {'1': 'mandatory', '3': 3, '4': 1, '5': 8, '10': 'mandatory'},
  ],
};

/// Descriptor for `ReleaseCheck`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseCheckDescriptor = $convert.base64Decode(
    'CgxSZWxlYXNlQ2hlY2sSEgoEY29kZRgBIAEoCVIEY29kZRIWCgZkZXRhaWwYAiABKAlSBmRldG'
    'FpbBIcCgltYW5kYXRvcnkYAyABKAhSCW1hbmRhdG9yeQ==');

@$core.Deprecated('Use releaseDescriptor instead')
const Release$json = {
  '1': 'Release',
  '2': [
    {'1': 'release_id', '3': 1, '4': 1, '5': 9, '10': 'releaseId'},
    {'1': 'case_id', '3': 2, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'recipient_name', '3': 3, '4': 1, '5': 9, '10': 'recipientName'},
    {
      '1': 'recipient_relation',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'recipientRelation'
    },
    {'1': 'recipient_id_type', '3': 5, '4': 1, '5': 9, '10': 'recipientIdType'},
    {'1': 'recipient_id_ref', '3': 6, '4': 1, '5': 9, '10': 'recipientIdRef'},
    {
      '1': 'verification_note',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'verificationNote'
    },
    {'1': 'signature_ref', '3': 8, '4': 1, '5': 9, '10': 'signatureRef'},
    {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    {
      '1': 'death_certificate_ref',
      '3': 10,
      '4': 1,
      '5': 9,
      '10': 'deathCertificateRef'
    },
    {'1': 'medico_legal', '3': 11, '4': 1, '5': 8, '10': 'medicoLegal'},
    {'1': 'authority', '3': 12, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'authority_reference',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'authorityReference'
    },
    {
      '1': 'released_at',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'releasedAt'
    },
    {'1': 'released_by', '3': 15, '4': 1, '5': 9, '10': 'releasedBy'},
    {'1': 'witnessed_by', '3': 16, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'note', '3': 17, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Release`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseDescriptor = $convert.base64Decode(
    'CgdSZWxlYXNlEh0KCnJlbGVhc2VfaWQYASABKAlSCXJlbGVhc2VJZBIXCgdjYXNlX2lkGAIgAS'
    'gJUgZjYXNlSWQSJQoOcmVjaXBpZW50X25hbWUYAyABKAlSDXJlY2lwaWVudE5hbWUSLQoScmVj'
    'aXBpZW50X3JlbGF0aW9uGAQgASgJUhFyZWNpcGllbnRSZWxhdGlvbhIqChFyZWNpcGllbnRfaW'
    'RfdHlwZRgFIAEoCVIPcmVjaXBpZW50SWRUeXBlEigKEHJlY2lwaWVudF9pZF9yZWYYBiABKAlS'
    'DnJlY2lwaWVudElkUmVmEisKEXZlcmlmaWNhdGlvbl9ub3RlGAcgASgJUhB2ZXJpZmljYXRpb2'
    '5Ob3RlEiMKDXNpZ25hdHVyZV9yZWYYCCABKAlSDHNpZ25hdHVyZVJlZhIgCgtkZXN0aW5hdGlv'
    'bhgJIAEoCVILZGVzdGluYXRpb24SMgoVZGVhdGhfY2VydGlmaWNhdGVfcmVmGAogASgJUhNkZW'
    'F0aENlcnRpZmljYXRlUmVmEiEKDG1lZGljb19sZWdhbBgLIAEoCFILbWVkaWNvTGVnYWwSHAoJ'
    'YXV0aG9yaXR5GAwgASgJUglhdXRob3JpdHkSLwoTYXV0aG9yaXR5X3JlZmVyZW5jZRgNIAEoCV'
    'ISYXV0aG9yaXR5UmVmZXJlbmNlEjsKC3JlbGVhc2VkX2F0GA4gASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIKcmVsZWFzZWRBdBIfCgtyZWxlYXNlZF9ieRgPIAEoCVIKcmVsZWFzZW'
    'RCeRIhCgx3aXRuZXNzZWRfYnkYECABKAlSC3dpdG5lc3NlZEJ5EhIKBG5vdGUYESABKAlSBG5v'
    'dGU=');

@$core.Deprecated('Use boardRowDescriptor instead')
const BoardRow$json = {
  '1': 'BoardRow',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'location_id', '3': 3, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'storage_tag', '3': 4, '4': 1, '5': 9, '10': 'storageTag'},
    {
      '1': 'state',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.CaseState',
      '10': 'state'
    },
    {'1': 'display_name', '3': 6, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'medico_legal', '3': 7, '4': 1, '5': 8, '10': 'medicoLegal'},
    {
      '1': 'identity',
      '3': 8,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Identity',
      '10': 'identity'
    },
    {
      '1': 'received_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'receivedAt'
    },
    {'1': 'held_hours', '3': 10, '4': 1, '5': 5, '10': 'heldHours'},
    {'1': 'pending_release', '3': 11, '4': 1, '5': 8, '10': 'pendingRelease'},
  ],
};

/// Descriptor for `BoardRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardRowDescriptor = $convert.base64Decode(
    'CghCb2FyZFJvdxIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSHAoJcmVmZXJlbmNlGAIgASgJUg'
    'lyZWZlcmVuY2USHwoLbG9jYXRpb25faWQYAyABKAlSCmxvY2F0aW9uSWQSHwoLc3RvcmFnZV90'
    'YWcYBCABKAlSCnN0b3JhZ2VUYWcSNwoFc3RhdGUYBSABKA4yIS5oZWFsdGhjYXJlLm1vcnR1YX'
    'J5LnYxLkNhc2VTdGF0ZVIFc3RhdGUSIQoMZGlzcGxheV9uYW1lGAYgASgJUgtkaXNwbGF5TmFt'
    'ZRIhCgxtZWRpY29fbGVnYWwYByABKAhSC21lZGljb0xlZ2FsEjwKCGlkZW50aXR5GAggASgOMi'
    'AuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5JZGVudGl0eVIIaWRlbnRpdHkSOwoLcmVjZWl2ZWRf'
    'YXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpyZWNlaXZlZEF0Eh0KCmhlbG'
    'RfaG91cnMYCiABKAVSCWhlbGRIb3VycxInCg9wZW5kaW5nX3JlbGVhc2UYCyABKAhSDnBlbmRp'
    'bmdSZWxlYXNl');

@$core.Deprecated('Use occupancyDescriptor instead')
const Occupancy$json = {
  '1': 'Occupancy',
  '2': [
    {'1': 'total', '3': 1, '4': 1, '5': 5, '10': 'total'},
    {'1': 'in_service', '3': 2, '4': 1, '5': 5, '10': 'inService'},
    {'1': 'occupied', '3': 3, '4': 1, '5': 5, '10': 'occupied'},
    {'1': 'free', '3': 4, '4': 1, '5': 5, '10': 'free'},
    {
      '1': 'free_by_kind',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Occupancy.FreeByKindEntry',
      '10': 'freeByKind'
    },
    {'1': 'out_of_service', '3': 6, '4': 1, '5': 5, '10': 'outOfService'},
  ],
  '3': [Occupancy_FreeByKindEntry$json],
};

@$core.Deprecated('Use occupancyDescriptor instead')
const Occupancy_FreeByKindEntry$json = {
  '1': 'FreeByKindEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 5, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Occupancy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List occupancyDescriptor = $convert.base64Decode(
    'CglPY2N1cGFuY3kSFAoFdG90YWwYASABKAVSBXRvdGFsEh0KCmluX3NlcnZpY2UYAiABKAVSCW'
    'luU2VydmljZRIaCghvY2N1cGllZBgDIAEoBVIIb2NjdXBpZWQSEgoEZnJlZRgEIAEoBVIEZnJl'
    'ZRJTCgxmcmVlX2J5X2tpbmQYBSADKAsyMS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLk9jY3VwYW'
    '5jeS5GcmVlQnlLaW5kRW50cnlSCmZyZWVCeUtpbmQSJAoOb3V0X29mX3NlcnZpY2UYBiABKAVS'
    'DG91dE9mU2VydmljZRo9Cg9GcmVlQnlLaW5kRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdm'
    'FsdWUYAiABKAVSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use openCaseRequestDescriptor instead')
const OpenCaseRequest$json = {
  '1': 'OpenCaseRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
    {
      '1': 'source',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Source',
      '10': 'source'
    },
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'external_source', '3': 5, '4': 1, '5': 9, '10': 'externalSource'},
    {
      '1': 'identity',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Identity',
      '10': 'identity'
    },
    {
      '1': 'identification_note',
      '3': 7,
      '4': 1,
      '5': 9,
      '10': 'identificationNote'
    },
    {'1': 'display_name', '3': 8, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'medico_legal', '3': 9, '4': 1, '5': 8, '10': 'medicoLegal'},
    {'1': 'mlc_reference', '3': 10, '4': 1, '5': 9, '10': 'mlcReference'},
    {'1': 'restricted', '3': 11, '4': 1, '5': 8, '10': 'restricted'},
    {
      '1': 'died_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'diedAt'
    },
    {'1': 'facility_id', '3': 13, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'received_from', '3': 14, '4': 1, '5': 9, '10': 'receivedFrom'},
  ],
};

/// Descriptor for `OpenCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCaseRequestDescriptor = $convert.base64Decode(
    'Cg9PcGVuQ2FzZVJlcXVlc3QSHAoJcmVmZXJlbmNlGAEgASgJUglyZWZlcmVuY2USNgoGc291cm'
    'NlGAIgASgOMh4uaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5Tb3VyY2VSBnNvdXJjZRIhCgxlbmNv'
    'dW50ZXJfaWQYAyABKAlSC2VuY291bnRlcklkEh0KCnBhdGllbnRfaWQYBCABKAlSCXBhdGllbn'
    'RJZBInCg9leHRlcm5hbF9zb3VyY2UYBSABKAlSDmV4dGVybmFsU291cmNlEjwKCGlkZW50aXR5'
    'GAYgASgOMiAuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5JZGVudGl0eVIIaWRlbnRpdHkSLwoTaW'
    'RlbnRpZmljYXRpb25fbm90ZRgHIAEoCVISaWRlbnRpZmljYXRpb25Ob3RlEiEKDGRpc3BsYXlf'
    'bmFtZRgIIAEoCVILZGlzcGxheU5hbWUSIQoMbWVkaWNvX2xlZ2FsGAkgASgIUgttZWRpY29MZW'
    'dhbBIjCg1tbGNfcmVmZXJlbmNlGAogASgJUgxtbGNSZWZlcmVuY2USHgoKcmVzdHJpY3RlZBgL'
    'IAEoCFIKcmVzdHJpY3RlZBIzCgdkaWVkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIGZGllZEF0Eh8KC2ZhY2lsaXR5X2lkGA0gASgJUgpmYWNpbGl0eUlkEiMKDXJlY2Vp'
    'dmVkX2Zyb20YDiABKAlSDHJlY2VpdmVkRnJvbQ==');

@$core.Deprecated('Use openCaseResponseDescriptor instead')
const OpenCaseResponse$json = {
  '1': 'OpenCaseResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `OpenCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List openCaseResponseDescriptor = $convert.base64Decode(
    'ChBPcGVuQ2FzZVJlc3BvbnNlEkEKDW1vcnR1YXJ5X2Nhc2UYASABKAsyHC5oZWFsdGhjYXJlLm'
    '1vcnR1YXJ5LnYxLkNhc2VSDG1vcnR1YXJ5Q2FzZQ==');

@$core.Deprecated('Use identifyRequestDescriptor instead')
const IdentifyRequest$json = {
  '1': 'IdentifyRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'identity',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Identity',
      '10': 'identity'
    },
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
    {'1': 'version', '3': 5, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `IdentifyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyRequestDescriptor = $convert.base64Decode(
    'Cg9JZGVudGlmeVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjwKCGlkZW50aXR5GA'
    'IgASgOMiAuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5JZGVudGl0eVIIaWRlbnRpdHkSEgoEbmFt'
    'ZRgDIAEoCVIEbmFtZRISCgRub3RlGAQgASgJUgRub3RlEhgKB3ZlcnNpb24YBSABKANSB3Zlcn'
    'Npb24=');

@$core.Deprecated('Use identifyResponseDescriptor instead')
const IdentifyResponse$json = {
  '1': 'IdentifyResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `IdentifyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyResponseDescriptor = $convert.base64Decode(
    'ChBJZGVudGlmeVJlc3BvbnNlEkEKDW1vcnR1YXJ5X2Nhc2UYASABKAsyHC5oZWFsdGhjYXJlLm'
    '1vcnR1YXJ5LnYxLkNhc2VSDG1vcnR1YXJ5Q2FzZQ==');

@$core.Deprecated('Use recordCauseRequestDescriptor instead')
const RecordCauseRequest$json = {
  '1': 'RecordCauseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'summary', '3': 2, '4': 1, '5': 9, '10': 'summary'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RecordCauseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCauseRequestDescriptor = $convert.base64Decode(
    'ChJSZWNvcmRDYXVzZVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEhgKB3N1bW1hcn'
    'kYAiABKAlSB3N1bW1hcnkSGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use recordCauseResponseDescriptor instead')
const RecordCauseResponse$json = {
  '1': 'RecordCauseResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `RecordCauseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordCauseResponseDescriptor = $convert.base64Decode(
    'ChNSZWNvcmRDYXVzZVJlc3BvbnNlEkEKDW1vcnR1YXJ5X2Nhc2UYASABKAsyHC5oZWFsdGhjYX'
    'JlLm1vcnR1YXJ5LnYxLkNhc2VSDG1vcnR1YXJ5Q2FzZQ==');

@$core.Deprecated('Use recordDeathCertificateRequestDescriptor instead')
const RecordDeathCertificateRequest$json = {
  '1': 'RecordDeathCertificateRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `RecordDeathCertificateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeathCertificateRequestDescriptor =
    $convert.base64Decode(
        'Ch1SZWNvcmREZWF0aENlcnRpZmljYXRlUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSW'
        'QSHAoJcmVmZXJlbmNlGAIgASgJUglyZWZlcmVuY2USGAoHdmVyc2lvbhgDIAEoA1IHdmVyc2lv'
        'bg==');

@$core.Deprecated('Use recordDeathCertificateResponseDescriptor instead')
const RecordDeathCertificateResponse$json = {
  '1': 'RecordDeathCertificateResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `RecordDeathCertificateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeathCertificateResponseDescriptor =
    $convert.base64Decode(
        'Ch5SZWNvcmREZWF0aENlcnRpZmljYXRlUmVzcG9uc2USQQoNbW9ydHVhcnlfY2FzZRgBIAEoCz'
        'IcLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuQ2FzZVIMbW9ydHVhcnlDYXNl');

@$core.Deprecated('Use markMedicoLegalRequestDescriptor instead')
const MarkMedicoLegalRequest$json = {
  '1': 'MarkMedicoLegalRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'reference', '3': 2, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'version', '3': 3, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `MarkMedicoLegalRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markMedicoLegalRequestDescriptor =
    $convert.base64Decode(
        'ChZNYXJrTWVkaWNvTGVnYWxSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIcCglyZW'
        'ZlcmVuY2UYAiABKAlSCXJlZmVyZW5jZRIYCgd2ZXJzaW9uGAMgASgDUgd2ZXJzaW9u');

@$core.Deprecated('Use markMedicoLegalResponseDescriptor instead')
const MarkMedicoLegalResponse$json = {
  '1': 'MarkMedicoLegalResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `MarkMedicoLegalResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List markMedicoLegalResponseDescriptor =
    $convert.base64Decode(
        'ChdNYXJrTWVkaWNvTGVnYWxSZXNwb25zZRJBCg1tb3J0dWFyeV9jYXNlGAEgASgLMhwuaGVhbH'
        'RoY2FyZS5tb3J0dWFyeS52MS5DYXNlUgxtb3J0dWFyeUNhc2U=');

@$core.Deprecated('Use getCaseRequestDescriptor instead')
const GetCaseRequest$json = {
  '1': 'GetCaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetCaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaseRequestDescriptor = $convert
    .base64Decode('Cg5HZXRDYXNlUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getCaseResponseDescriptor instead')
const GetCaseResponse$json = {
  '1': 'GetCaseResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `GetCaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaseResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRDYXNlUmVzcG9uc2USQQoNbW9ydHVhcnlfY2FzZRgBIAEoCzIcLmhlYWx0aGNhcmUubW'
    '9ydHVhcnkudjEuQ2FzZVIMbW9ydHVhcnlDYXNl');

@$core.Deprecated('Use getCaseByReferenceRequestDescriptor instead')
const GetCaseByReferenceRequest$json = {
  '1': 'GetCaseByReferenceRequest',
  '2': [
    {'1': 'reference', '3': 1, '4': 1, '5': 9, '10': 'reference'},
  ],
};

/// Descriptor for `GetCaseByReferenceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaseByReferenceRequestDescriptor =
    $convert.base64Decode(
        'ChlHZXRDYXNlQnlSZWZlcmVuY2VSZXF1ZXN0EhwKCXJlZmVyZW5jZRgBIAEoCVIJcmVmZXJlbm'
        'Nl');

@$core.Deprecated('Use getCaseByReferenceResponseDescriptor instead')
const GetCaseByReferenceResponse$json = {
  '1': 'GetCaseByReferenceResponse',
  '2': [
    {
      '1': 'mortuary_case',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'mortuaryCase'
    },
  ],
};

/// Descriptor for `GetCaseByReferenceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getCaseByReferenceResponseDescriptor =
    $convert.base64Decode(
        'ChpHZXRDYXNlQnlSZWZlcmVuY2VSZXNwb25zZRJBCg1tb3J0dWFyeV9jYXNlGAEgASgLMhwuaG'
        'VhbHRoY2FyZS5tb3J0dWFyeS52MS5DYXNlUgxtb3J0dWFyeUNhc2U=');

@$core.Deprecated('Use listCasesRequestDescriptor instead')
const ListCasesRequest$json = {
  '1': 'ListCasesRequest',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 14,
      '6': '.healthcare.mortuary.v1.CaseState',
      '10': 'states'
    },
    {
      '1': 'identities',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.mortuary.v1.Identity',
      '10': 'identities'
    },
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'medico_legal_only', '3': 4, '4': 1, '5': 8, '10': 'medicoLegalOnly'},
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
    {'1': 'offset', '3': 8, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListCasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Q2FzZXNSZXF1ZXN0EjkKBnN0YXRlcxgBIAMoDjIhLmhlYWx0aGNhcmUubW9ydHVhcn'
    'kudjEuQ2FzZVN0YXRlUgZzdGF0ZXMSQAoKaWRlbnRpdGllcxgCIAMoDjIgLmhlYWx0aGNhcmUu'
    'bW9ydHVhcnkudjEuSWRlbnRpdHlSCmlkZW50aXRpZXMSHwoLZmFjaWxpdHlfaWQYAyABKAlSCm'
    'ZhY2lsaXR5SWQSKgoRbWVkaWNvX2xlZ2FsX29ubHkYBCABKAhSD21lZGljb0xlZ2FsT25seRIu'
    'CgRmcm9tGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgGIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRvEhsKCXBhZ2Vfc2l6ZRgHIAEoBVII'
    'cGFnZVNpemUSFgoGb2Zmc2V0GAggASgFUgZvZmZzZXQ=');

@$core.Deprecated('Use listCasesResponseDescriptor instead')
const ListCasesResponse$json = {
  '1': 'ListCasesResponse',
  '2': [
    {
      '1': 'cases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Case',
      '10': 'cases'
    },
  ],
};

/// Descriptor for `ListCasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listCasesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Q2FzZXNSZXNwb25zZRIyCgVjYXNlcxgBIAMoCzIcLmhlYWx0aGNhcmUubW9ydHVhcn'
    'kudjEuQ2FzZVIFY2FzZXM=');

@$core.Deprecated('Use addLocationRequestDescriptor instead')
const AddLocationRequest$json = {
  '1': 'AddLocationRequest',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.SpaceKind',
      '10': 'kind'
    },
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'zone', '3': 4, '4': 1, '5': 9, '10': 'zone'},
  ],
};

/// Descriptor for `AddLocationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addLocationRequestDescriptor = $convert.base64Decode(
    'ChJBZGRMb2NhdGlvblJlcXVlc3QSEgoEY29kZRgBIAEoCVIEY29kZRI1CgRraW5kGAIgASgOMi'
    'EuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5TcGFjZUtpbmRSBGtpbmQSHwoLZmFjaWxpdHlfaWQY'
    'AyABKAlSCmZhY2lsaXR5SWQSEgoEem9uZRgEIAEoCVIEem9uZQ==');

@$core.Deprecated('Use addLocationResponseDescriptor instead')
const AddLocationResponse$json = {
  '1': 'AddLocationResponse',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Location',
      '10': 'location'
    },
  ],
};

/// Descriptor for `AddLocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addLocationResponseDescriptor = $convert.base64Decode(
    'ChNBZGRMb2NhdGlvblJlc3BvbnNlEjwKCGxvY2F0aW9uGAEgASgLMiAuaGVhbHRoY2FyZS5tb3'
    'J0dWFyeS52MS5Mb2NhdGlvblIIbG9jYXRpb24=');

@$core.Deprecated('Use setLocationServiceRequestDescriptor instead')
const SetLocationServiceRequest$json = {
  '1': 'SetLocationServiceRequest',
  '2': [
    {'1': 'location_id', '3': 1, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'out_of_service', '3': 2, '4': 1, '5': 8, '10': 'outOfService'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 4, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `SetLocationServiceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setLocationServiceRequestDescriptor = $convert.base64Decode(
    'ChlTZXRMb2NhdGlvblNlcnZpY2VSZXF1ZXN0Eh8KC2xvY2F0aW9uX2lkGAEgASgJUgpsb2NhdG'
    'lvbklkEiQKDm91dF9vZl9zZXJ2aWNlGAIgASgIUgxvdXRPZlNlcnZpY2USFgoGcmVhc29uGAMg'
    'ASgJUgZyZWFzb24SGAoHdmVyc2lvbhgEIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use setLocationServiceResponseDescriptor instead')
const SetLocationServiceResponse$json = {
  '1': 'SetLocationServiceResponse',
  '2': [
    {
      '1': 'location',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Location',
      '10': 'location'
    },
  ],
};

/// Descriptor for `SetLocationServiceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setLocationServiceResponseDescriptor =
    $convert.base64Decode(
        'ChpTZXRMb2NhdGlvblNlcnZpY2VSZXNwb25zZRI8Cghsb2NhdGlvbhgBIAEoCzIgLmhlYWx0aG'
        'NhcmUubW9ydHVhcnkudjEuTG9jYXRpb25SCGxvY2F0aW9u');

@$core.Deprecated('Use listLocationsRequestDescriptor instead')
const ListLocationsRequest$json = {
  '1': 'ListLocationsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'kinds',
      '3': 2,
      '4': 3,
      '5': 14,
      '6': '.healthcare.mortuary.v1.SpaceKind',
      '10': 'kinds'
    },
    {'1': 'in_service_only', '3': 3, '4': 1, '5': 8, '10': 'inServiceOnly'},
    {'1': 'page_size', '3': 4, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'offset', '3': 5, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListLocationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLocationsRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0TG9jYXRpb25zUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZB'
    'I3CgVraW5kcxgCIAMoDjIhLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuU3BhY2VLaW5kUgVraW5k'
    'cxImCg9pbl9zZXJ2aWNlX29ubHkYAyABKAhSDWluU2VydmljZU9ubHkSGwoJcGFnZV9zaXplGA'
    'QgASgFUghwYWdlU2l6ZRIWCgZvZmZzZXQYBSABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listLocationsResponseDescriptor instead')
const ListLocationsResponse$json = {
  '1': 'ListLocationsResponse',
  '2': [
    {
      '1': 'locations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Location',
      '10': 'locations'
    },
  ],
};

/// Descriptor for `ListLocationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLocationsResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0TG9jYXRpb25zUmVzcG9uc2USPgoJbG9jYXRpb25zGAEgAygLMiAuaGVhbHRoY2FyZS'
    '5tb3J0dWFyeS52MS5Mb2NhdGlvblIJbG9jYXRpb25z');

@$core.Deprecated('Use placeBodyRequestDescriptor instead')
const PlaceBodyRequest$json = {
  '1': 'PlaceBodyRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'location_id', '3': 2, '4': 1, '5': 9, '10': 'locationId'},
    {'1': 'storage_tag', '3': 3, '4': 1, '5': 9, '10': 'storageTag'},
    {'1': 'checked_note', '3': 4, '4': 1, '5': 9, '10': 'checkedNote'},
    {'1': 'move_reason', '3': 5, '4': 1, '5': 9, '10': 'moveReason'},
    {'1': 'version', '3': 6, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `PlaceBodyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeBodyRequestDescriptor = $convert.base64Decode(
    'ChBQbGFjZUJvZHlSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIfCgtsb2NhdGlvbl'
    '9pZBgCIAEoCVIKbG9jYXRpb25JZBIfCgtzdG9yYWdlX3RhZxgDIAEoCVIKc3RvcmFnZVRhZxIh'
    'CgxjaGVja2VkX25vdGUYBCABKAlSC2NoZWNrZWROb3RlEh8KC21vdmVfcmVhc29uGAUgASgJUg'
    'ptb3ZlUmVhc29uEhgKB3ZlcnNpb24YBiABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use placeBodyResponseDescriptor instead')
const PlaceBodyResponse$json = {
  '1': 'PlaceBodyResponse',
  '2': [
    {
      '1': 'placement',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Placement',
      '10': 'placement'
    },
  ],
};

/// Descriptor for `PlaceBodyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeBodyResponseDescriptor = $convert.base64Decode(
    'ChFQbGFjZUJvZHlSZXNwb25zZRI/CglwbGFjZW1lbnQYASABKAsyIS5oZWFsdGhjYXJlLm1vcn'
    'R1YXJ5LnYxLlBsYWNlbWVudFIJcGxhY2VtZW50');

@$core.Deprecated('Use getPlacementHistoryRequestDescriptor instead')
const GetPlacementHistoryRequest$json = {
  '1': 'GetPlacementHistoryRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetPlacementHistoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlacementHistoryRequestDescriptor =
    $convert.base64Decode(
        'ChpHZXRQbGFjZW1lbnRIaXN0b3J5UmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getPlacementHistoryResponseDescriptor instead')
const GetPlacementHistoryResponse$json = {
  '1': 'GetPlacementHistoryResponse',
  '2': [
    {
      '1': 'placements',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Placement',
      '10': 'placements'
    },
  ],
};

/// Descriptor for `GetPlacementHistoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPlacementHistoryResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRQbGFjZW1lbnRIaXN0b3J5UmVzcG9uc2USQQoKcGxhY2VtZW50cxgBIAMoCzIhLmhlYW'
        'x0aGNhcmUubW9ydHVhcnkudjEuUGxhY2VtZW50UgpwbGFjZW1lbnRz');

@$core.Deprecated('Use listItemRequestDescriptor instead')
const ListItemRequest$json = {
  '1': 'ListItemRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.ItemKind',
      '10': 'kind'
    },
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'seal_number', '3': 5, '4': 1, '5': 9, '10': 'sealNumber'},
    {'1': 'witnessed_by', '3': 6, '4': 1, '5': 9, '10': 'witnessedBy'},
  ],
};

/// Descriptor for `ListItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0SXRlbVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjQKBGtpbmQYAiABKA'
    '4yIC5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkl0ZW1LaW5kUgRraW5kEiAKC2Rlc2NyaXB0aW9u'
    'GAMgASgJUgtkZXNjcmlwdGlvbhIaCghxdWFudGl0eRgEIAEoBVIIcXVhbnRpdHkSHwoLc2VhbF'
    '9udW1iZXIYBSABKAlSCnNlYWxOdW1iZXISIQoMd2l0bmVzc2VkX2J5GAYgASgJUgt3aXRuZXNz'
    'ZWRCeQ==');

@$core.Deprecated('Use listItemResponseDescriptor instead')
const ListItemResponse$json = {
  '1': 'ListItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `ListItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listItemResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0SXRlbVJlc3BvbnNlEjAKBGl0ZW0YASABKAsyHC5oZWFsdGhjYXJlLm1vcnR1YXJ5Ln'
    'YxLkl0ZW1SBGl0ZW0=');

@$core.Deprecated('Use retainItemRequestDescriptor instead')
const RetainItemRequest$json = {
  '1': 'RetainItemRequest',
  '2': [
    {'1': 'item_id', '3': 1, '4': 1, '5': 9, '10': 'itemId'},
    {'1': 'authority', '3': 2, '4': 1, '5': 9, '10': 'authority'},
    {'1': 'reference', '3': 3, '4': 1, '5': 9, '10': 'reference'},
  ],
};

/// Descriptor for `RetainItemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retainItemRequestDescriptor = $convert.base64Decode(
    'ChFSZXRhaW5JdGVtUmVxdWVzdBIXCgdpdGVtX2lkGAEgASgJUgZpdGVtSWQSHAoJYXV0aG9yaX'
    'R5GAIgASgJUglhdXRob3JpdHkSHAoJcmVmZXJlbmNlGAMgASgJUglyZWZlcmVuY2U=');

@$core.Deprecated('Use retainItemResponseDescriptor instead')
const RetainItemResponse$json = {
  '1': 'RetainItemResponse',
  '2': [
    {
      '1': 'item',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Item',
      '10': 'item'
    },
  ],
};

/// Descriptor for `RetainItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retainItemResponseDescriptor = $convert.base64Decode(
    'ChJSZXRhaW5JdGVtUmVzcG9uc2USMAoEaXRlbRgBIAEoCzIcLmhlYWx0aGNhcmUubW9ydHVhcn'
    'kudjEuSXRlbVIEaXRlbQ==');

@$core.Deprecated('Use handOverBelongingsRequestDescriptor instead')
const HandOverBelongingsRequest$json = {
  '1': 'HandOverBelongingsRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'item_ids', '3': 2, '4': 3, '5': 9, '10': 'itemIds'},
    {'1': 'recipient_name', '3': 3, '4': 1, '5': 9, '10': 'recipientName'},
    {
      '1': 'recipient_relation',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'recipientRelation'
    },
    {'1': 'recipient_id_type', '3': 5, '4': 1, '5': 9, '10': 'recipientIdType'},
    {'1': 'recipient_id_ref', '3': 6, '4': 1, '5': 9, '10': 'recipientIdRef'},
    {'1': 'signature_ref', '3': 7, '4': 1, '5': 9, '10': 'signatureRef'},
    {'1': 'witnessed_by', '3': 8, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'note', '3': 9, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `HandOverBelongingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handOverBelongingsRequestDescriptor = $convert.base64Decode(
    'ChlIYW5kT3ZlckJlbG9uZ2luZ3NSZXF1ZXN0EhcKB2Nhc2VfaWQYASABKAlSBmNhc2VJZBIZCg'
    'hpdGVtX2lkcxgCIAMoCVIHaXRlbUlkcxIlCg5yZWNpcGllbnRfbmFtZRgDIAEoCVINcmVjaXBp'
    'ZW50TmFtZRItChJyZWNpcGllbnRfcmVsYXRpb24YBCABKAlSEXJlY2lwaWVudFJlbGF0aW9uEi'
    'oKEXJlY2lwaWVudF9pZF90eXBlGAUgASgJUg9yZWNpcGllbnRJZFR5cGUSKAoQcmVjaXBpZW50'
    'X2lkX3JlZhgGIAEoCVIOcmVjaXBpZW50SWRSZWYSIwoNc2lnbmF0dXJlX3JlZhgHIAEoCVIMc2'
    'lnbmF0dXJlUmVmEiEKDHdpdG5lc3NlZF9ieRgIIAEoCVILd2l0bmVzc2VkQnkSEgoEbm90ZRgJ'
    'IAEoCVIEbm90ZQ==');

@$core.Deprecated('Use handOverBelongingsResponseDescriptor instead')
const HandOverBelongingsResponse$json = {
  '1': 'HandOverBelongingsResponse',
  '2': [
    {
      '1': 'handover',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Handover',
      '10': 'handover'
    },
  ],
};

/// Descriptor for `HandOverBelongingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List handOverBelongingsResponseDescriptor =
    $convert.base64Decode(
        'ChpIYW5kT3ZlckJlbG9uZ2luZ3NSZXNwb25zZRI8CghoYW5kb3ZlchgBIAEoCzIgLmhlYWx0aG'
        'NhcmUubW9ydHVhcnkudjEuSGFuZG92ZXJSCGhhbmRvdmVy');

@$core.Deprecated('Use getBelongingsRequestDescriptor instead')
const GetBelongingsRequest$json = {
  '1': 'GetBelongingsRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetBelongingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBelongingsRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRCZWxvbmdpbmdzUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getBelongingsResponseDescriptor instead')
const GetBelongingsResponse$json = {
  '1': 'GetBelongingsResponse',
  '2': [
    {
      '1': 'items',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Item',
      '10': 'items'
    },
    {
      '1': 'handovers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Handover',
      '10': 'handovers'
    },
  ],
};

/// Descriptor for `GetBelongingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBelongingsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRCZWxvbmdpbmdzUmVzcG9uc2USMgoFaXRlbXMYASADKAsyHC5oZWFsdGhjYXJlLm1vcn'
    'R1YXJ5LnYxLkl0ZW1SBWl0ZW1zEj4KCWhhbmRvdmVycxgCIAMoCzIgLmhlYWx0aGNhcmUubW9y'
    'dHVhcnkudjEuSGFuZG92ZXJSCWhhbmRvdmVycw==');

@$core.Deprecated('Use getChainOfCustodyRequestDescriptor instead')
const GetChainOfCustodyRequest$json = {
  '1': 'GetChainOfCustodyRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetChainOfCustodyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChainOfCustodyRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRDaGFpbk9mQ3VzdG9keVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlk');

@$core.Deprecated('Use getChainOfCustodyResponseDescriptor instead')
const GetChainOfCustodyResponse$json = {
  '1': 'GetChainOfCustodyResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.CustodyEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `GetChainOfCustodyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getChainOfCustodyResponseDescriptor =
    $convert.base64Decode(
        'ChlHZXRDaGFpbk9mQ3VzdG9keVJlc3BvbnNlEj4KB2VudHJpZXMYASADKAsyJC5oZWFsdGhjYX'
        'JlLm1vcnR1YXJ5LnYxLkN1c3RvZHlFbnRyeVIHZW50cmllcw==');

@$core.Deprecated('Use requestPostmortemRequestDescriptor instead')
const RequestPostmortemRequest$json = {
  '1': 'RequestPostmortemRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.PostmortemKind',
      '10': 'kind'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RequestPostmortemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPostmortemRequestDescriptor = $convert.base64Decode(
    'ChhSZXF1ZXN0UG9zdG1vcnRlbVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEjoKBG'
    'tpbmQYAiABKA4yJi5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlBvc3Rtb3J0ZW1LaW5kUgRraW5k'
    'EhYKBnJlYXNvbhgDIAEoCVIGcmVhc29u');

@$core.Deprecated('Use requestPostmortemResponseDescriptor instead')
const RequestPostmortemResponse$json = {
  '1': 'RequestPostmortemResponse',
  '2': [
    {
      '1': 'postmortem',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Postmortem',
      '10': 'postmortem'
    },
  ],
};

/// Descriptor for `RequestPostmortemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestPostmortemResponseDescriptor =
    $convert.base64Decode(
        'ChlSZXF1ZXN0UG9zdG1vcnRlbVJlc3BvbnNlEkIKCnBvc3Rtb3J0ZW0YASABKAsyIi5oZWFsdG'
        'hjYXJlLm1vcnR1YXJ5LnYxLlBvc3Rtb3J0ZW1SCnBvc3Rtb3J0ZW0=');

@$core.Deprecated('Use advancePostmortemRequestDescriptor instead')
const AdvancePostmortemRequest$json = {
  '1': 'AdvancePostmortemRequest',
  '2': [
    {'1': 'postmortem_id', '3': 1, '4': 1, '5': 9, '10': 'postmortemId'},
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.mortuary.v1.PostmortemState',
      '10': 'to'
    },
    {'1': 'authority', '3': 3, '4': 1, '5': 9, '10': 'authority'},
    {
      '1': 'authority_reference',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'authorityReference'
    },
    {'1': 'pathologist', '3': 5, '4': 1, '5': 9, '10': 'pathologist'},
    {'1': 'report_ref', '3': 6, '4': 1, '5': 9, '10': 'reportRef'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'version', '3': 8, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `AdvancePostmortemRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advancePostmortemRequestDescriptor = $convert.base64Decode(
    'ChhBZHZhbmNlUG9zdG1vcnRlbVJlcXVlc3QSIwoNcG9zdG1vcnRlbV9pZBgBIAEoCVIMcG9zdG'
    '1vcnRlbUlkEjcKAnRvGAIgASgOMicuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5Qb3N0bW9ydGVt'
    'U3RhdGVSAnRvEhwKCWF1dGhvcml0eRgDIAEoCVIJYXV0aG9yaXR5Ei8KE2F1dGhvcml0eV9yZW'
    'ZlcmVuY2UYBCABKAlSEmF1dGhvcml0eVJlZmVyZW5jZRIgCgtwYXRob2xvZ2lzdBgFIAEoCVIL'
    'cGF0aG9sb2dpc3QSHQoKcmVwb3J0X3JlZhgGIAEoCVIJcmVwb3J0UmVmEhYKBnJlYXNvbhgHIA'
    'EoCVIGcmVhc29uEhgKB3ZlcnNpb24YCCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use advancePostmortemResponseDescriptor instead')
const AdvancePostmortemResponse$json = {
  '1': 'AdvancePostmortemResponse',
  '2': [
    {
      '1': 'postmortem',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Postmortem',
      '10': 'postmortem'
    },
  ],
};

/// Descriptor for `AdvancePostmortemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advancePostmortemResponseDescriptor =
    $convert.base64Decode(
        'ChlBZHZhbmNlUG9zdG1vcnRlbVJlc3BvbnNlEkIKCnBvc3Rtb3J0ZW0YASABKAsyIi5oZWFsdG'
        'hjYXJlLm1vcnR1YXJ5LnYxLlBvc3Rtb3J0ZW1SCnBvc3Rtb3J0ZW0=');

@$core.Deprecated('Use getPostmortemsRequestDescriptor instead')
const GetPostmortemsRequest$json = {
  '1': 'GetPostmortemsRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetPostmortemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPostmortemsRequestDescriptor =
    $convert.base64Decode(
        'ChVHZXRQb3N0bW9ydGVtc1JlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlk');

@$core.Deprecated('Use getPostmortemsResponseDescriptor instead')
const GetPostmortemsResponse$json = {
  '1': 'GetPostmortemsResponse',
  '2': [
    {
      '1': 'postmortems',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Postmortem',
      '10': 'postmortems'
    },
  ],
};

/// Descriptor for `GetPostmortemsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPostmortemsResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRQb3N0bW9ydGVtc1Jlc3BvbnNlEkQKC3Bvc3Rtb3J0ZW1zGAEgAygLMiIuaGVhbHRoY2'
        'FyZS5tb3J0dWFyeS52MS5Qb3N0bW9ydGVtUgtwb3N0bW9ydGVtcw==');

@$core.Deprecated('Use recordAuthorisationRequestDescriptor instead')
const RecordAuthorisationRequest$json = {
  '1': 'RecordAuthorisationRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'authority', '3': 2, '4': 1, '5': 9, '10': 'authority'},
    {'1': 'reference', '3': 3, '4': 1, '5': 9, '10': 'reference'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `RecordAuthorisationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAuthorisationRequestDescriptor =
    $convert.base64Decode(
        'ChpSZWNvcmRBdXRob3Jpc2F0aW9uUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQSHA'
        'oJYXV0aG9yaXR5GAIgASgJUglhdXRob3JpdHkSHAoJcmVmZXJlbmNlGAMgASgJUglyZWZlcmVu'
        'Y2USEgoEbm90ZRgEIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use recordAuthorisationResponseDescriptor instead')
const RecordAuthorisationResponse$json = {
  '1': 'RecordAuthorisationResponse',
  '2': [
    {
      '1': 'authorisation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Authorisation',
      '10': 'authorisation'
    },
  ],
};

/// Descriptor for `RecordAuthorisationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordAuthorisationResponseDescriptor =
    $convert.base64Decode(
        'ChtSZWNvcmRBdXRob3Jpc2F0aW9uUmVzcG9uc2USSwoNYXV0aG9yaXNhdGlvbhgBIAEoCzIlLm'
        'hlYWx0aGNhcmUubW9ydHVhcnkudjEuQXV0aG9yaXNhdGlvblINYXV0aG9yaXNhdGlvbg==');

@$core.Deprecated('Use getReleaseChecksRequestDescriptor instead')
const GetReleaseChecksRequest$json = {
  '1': 'GetReleaseChecksRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetReleaseChecksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseChecksRequestDescriptor =
    $convert.base64Decode(
        'ChdHZXRSZWxlYXNlQ2hlY2tzUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getReleaseChecksResponseDescriptor instead')
const GetReleaseChecksResponse$json = {
  '1': 'GetReleaseChecksResponse',
  '2': [
    {
      '1': 'checks',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.ReleaseCheck',
      '10': 'checks'
    },
  ],
};

/// Descriptor for `GetReleaseChecksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseChecksResponseDescriptor =
    $convert.base64Decode(
        'ChhHZXRSZWxlYXNlQ2hlY2tzUmVzcG9uc2USPAoGY2hlY2tzGAEgAygLMiQuaGVhbHRoY2FyZS'
        '5tb3J0dWFyeS52MS5SZWxlYXNlQ2hlY2tSBmNoZWNrcw==');

@$core.Deprecated('Use releaseBodyRequestDescriptor instead')
const ReleaseBodyRequest$json = {
  '1': 'ReleaseBodyRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
    {'1': 'recipient_name', '3': 2, '4': 1, '5': 9, '10': 'recipientName'},
    {
      '1': 'recipient_relation',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'recipientRelation'
    },
    {'1': 'recipient_id_type', '3': 4, '4': 1, '5': 9, '10': 'recipientIdType'},
    {'1': 'recipient_id_ref', '3': 5, '4': 1, '5': 9, '10': 'recipientIdRef'},
    {
      '1': 'verification_note',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'verificationNote'
    },
    {'1': 'signature_ref', '3': 7, '4': 1, '5': 9, '10': 'signatureRef'},
    {
      '1': 'death_certificate_ref',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'deathCertificateRef'
    },
    {'1': 'destination', '3': 9, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'witnessed_by', '3': 10, '4': 1, '5': 9, '10': 'witnessedBy'},
    {'1': 'note', '3': 11, '4': 1, '5': 9, '10': 'note'},
    {'1': 'version', '3': 12, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `ReleaseBodyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseBodyRequestDescriptor = $convert.base64Decode(
    'ChJSZWxlYXNlQm9keVJlcXVlc3QSFwoHY2FzZV9pZBgBIAEoCVIGY2FzZUlkEiUKDnJlY2lwaW'
    'VudF9uYW1lGAIgASgJUg1yZWNpcGllbnROYW1lEi0KEnJlY2lwaWVudF9yZWxhdGlvbhgDIAEo'
    'CVIRcmVjaXBpZW50UmVsYXRpb24SKgoRcmVjaXBpZW50X2lkX3R5cGUYBCABKAlSD3JlY2lwaW'
    'VudElkVHlwZRIoChByZWNpcGllbnRfaWRfcmVmGAUgASgJUg5yZWNpcGllbnRJZFJlZhIrChF2'
    'ZXJpZmljYXRpb25fbm90ZRgGIAEoCVIQdmVyaWZpY2F0aW9uTm90ZRIjCg1zaWduYXR1cmVfcm'
    'VmGAcgASgJUgxzaWduYXR1cmVSZWYSMgoVZGVhdGhfY2VydGlmaWNhdGVfcmVmGAggASgJUhNk'
    'ZWF0aENlcnRpZmljYXRlUmVmEiAKC2Rlc3RpbmF0aW9uGAkgASgJUgtkZXN0aW5hdGlvbhIhCg'
    'x3aXRuZXNzZWRfYnkYCiABKAlSC3dpdG5lc3NlZEJ5EhIKBG5vdGUYCyABKAlSBG5vdGUSGAoH'
    'dmVyc2lvbhgMIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use releaseBodyResponseDescriptor instead')
const ReleaseBodyResponse$json = {
  '1': 'ReleaseBodyResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Release',
      '10': 'release'
    },
  ],
};

/// Descriptor for `ReleaseBodyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List releaseBodyResponseDescriptor = $convert.base64Decode(
    'ChNSZWxlYXNlQm9keVJlc3BvbnNlEjkKB3JlbGVhc2UYASABKAsyHy5oZWFsdGhjYXJlLm1vcn'
    'R1YXJ5LnYxLlJlbGVhc2VSB3JlbGVhc2U=');

@$core.Deprecated('Use getReleaseRequestDescriptor instead')
const GetReleaseRequest$json = {
  '1': 'GetReleaseRequest',
  '2': [
    {'1': 'case_id', '3': 1, '4': 1, '5': 9, '10': 'caseId'},
  ],
};

/// Descriptor for `GetReleaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseRequestDescriptor = $convert.base64Decode(
    'ChFHZXRSZWxlYXNlUmVxdWVzdBIXCgdjYXNlX2lkGAEgASgJUgZjYXNlSWQ=');

@$core.Deprecated('Use getReleaseResponseDescriptor instead')
const GetReleaseResponse$json = {
  '1': 'GetReleaseResponse',
  '2': [
    {
      '1': 'release',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Release',
      '10': 'release'
    },
  ],
};

/// Descriptor for `GetReleaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReleaseResponseDescriptor = $convert.base64Decode(
    'ChJHZXRSZWxlYXNlUmVzcG9uc2USOQoHcmVsZWFzZRgBIAEoCzIfLmhlYWx0aGNhcmUubW9ydH'
    'VhcnkudjEuUmVsZWFzZVIHcmVsZWFzZQ==');

@$core.Deprecated('Use listReleasesRequestDescriptor instead')
const ListReleasesRequest$json = {
  '1': 'ListReleasesRequest',
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
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListReleasesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReleasesRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVsZWFzZXNSZXF1ZXN0Ei4KBGZyb20YASABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgRmcm9tEioKAnRvGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIC'
    'dG8SGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZRIWCgZvZmZzZXQYBCABKAVSBm9mZnNldA'
    '==');

@$core.Deprecated('Use listReleasesResponseDescriptor instead')
const ListReleasesResponse$json = {
  '1': 'ListReleasesResponse',
  '2': [
    {
      '1': 'releases',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Release',
      '10': 'releases'
    },
  ],
};

/// Descriptor for `ListReleasesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReleasesResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVsZWFzZXNSZXNwb25zZRI7CghyZWxlYXNlcxgBIAMoCzIfLmhlYWx0aGNhcmUubW'
    '9ydHVhcnkudjEuUmVsZWFzZVIIcmVsZWFzZXM=');

@$core.Deprecated('Use getBoardRequestDescriptor instead')
const GetBoardRequest$json = {
  '1': 'GetBoardRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `GetBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCb2FyZFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQ=');

@$core.Deprecated('Use getBoardResponseDescriptor instead')
const GetBoardResponse$json = {
  '1': 'GetBoardResponse',
  '2': [
    {
      '1': 'rows',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.mortuary.v1.BoardRow',
      '10': 'rows'
    },
    {
      '1': 'occupancy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.mortuary.v1.Occupancy',
      '10': 'occupancy'
    },
    {'1': 'truncated', '3': 3, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `GetBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCb2FyZFJlc3BvbnNlEjQKBHJvd3MYASADKAsyIC5oZWFsdGhjYXJlLm1vcnR1YXJ5Ln'
    'YxLkJvYXJkUm93UgRyb3dzEj8KCW9jY3VwYW5jeRgCIAEoCzIhLmhlYWx0aGNhcmUubW9ydHVh'
    'cnkudjEuT2NjdXBhbmN5UglvY2N1cGFuY3kSHAoJdHJ1bmNhdGVkGAMgASgIUgl0cnVuY2F0ZW'
    'Q=');

@$core.Deprecated('Use sweepLongStayRequestDescriptor instead')
const SweepLongStayRequest$json = {
  '1': 'SweepLongStayRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
  ],
};

/// Descriptor for `SweepLongStayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepLongStayRequestDescriptor = $convert.base64Decode(
    'ChRTd2VlcExvbmdTdGF5UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdHlJZA'
    '==');

@$core.Deprecated('Use sweepLongStayResponseDescriptor instead')
const SweepLongStayResponse$json = {
  '1': 'SweepLongStayResponse',
  '2': [
    {'1': 'raised', '3': 1, '4': 1, '5': 5, '10': 'raised'},
  ],
};

/// Descriptor for `SweepLongStayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sweepLongStayResponseDescriptor =
    $convert.base64Decode(
        'ChVTd2VlcExvbmdTdGF5UmVzcG9uc2USFgoGcmFpc2VkGAEgASgFUgZyYWlzZWQ=');

const $core.Map<$core.String, $core.dynamic> MortuaryServiceBase$json = {
  '1': 'MortuaryService',
  '2': [
    {
      '1': 'OpenCase',
      '2': '.healthcare.mortuary.v1.OpenCaseRequest',
      '3': '.healthcare.mortuary.v1.OpenCaseResponse'
    },
    {
      '1': 'Identify',
      '2': '.healthcare.mortuary.v1.IdentifyRequest',
      '3': '.healthcare.mortuary.v1.IdentifyResponse'
    },
    {
      '1': 'RecordCause',
      '2': '.healthcare.mortuary.v1.RecordCauseRequest',
      '3': '.healthcare.mortuary.v1.RecordCauseResponse'
    },
    {
      '1': 'RecordDeathCertificate',
      '2': '.healthcare.mortuary.v1.RecordDeathCertificateRequest',
      '3': '.healthcare.mortuary.v1.RecordDeathCertificateResponse'
    },
    {
      '1': 'MarkMedicoLegal',
      '2': '.healthcare.mortuary.v1.MarkMedicoLegalRequest',
      '3': '.healthcare.mortuary.v1.MarkMedicoLegalResponse'
    },
    {
      '1': 'GetCase',
      '2': '.healthcare.mortuary.v1.GetCaseRequest',
      '3': '.healthcare.mortuary.v1.GetCaseResponse'
    },
    {
      '1': 'GetCaseByReference',
      '2': '.healthcare.mortuary.v1.GetCaseByReferenceRequest',
      '3': '.healthcare.mortuary.v1.GetCaseByReferenceResponse'
    },
    {
      '1': 'ListCases',
      '2': '.healthcare.mortuary.v1.ListCasesRequest',
      '3': '.healthcare.mortuary.v1.ListCasesResponse'
    },
    {
      '1': 'AddLocation',
      '2': '.healthcare.mortuary.v1.AddLocationRequest',
      '3': '.healthcare.mortuary.v1.AddLocationResponse'
    },
    {
      '1': 'SetLocationService',
      '2': '.healthcare.mortuary.v1.SetLocationServiceRequest',
      '3': '.healthcare.mortuary.v1.SetLocationServiceResponse'
    },
    {
      '1': 'ListLocations',
      '2': '.healthcare.mortuary.v1.ListLocationsRequest',
      '3': '.healthcare.mortuary.v1.ListLocationsResponse'
    },
    {
      '1': 'PlaceBody',
      '2': '.healthcare.mortuary.v1.PlaceBodyRequest',
      '3': '.healthcare.mortuary.v1.PlaceBodyResponse'
    },
    {
      '1': 'GetPlacementHistory',
      '2': '.healthcare.mortuary.v1.GetPlacementHistoryRequest',
      '3': '.healthcare.mortuary.v1.GetPlacementHistoryResponse'
    },
    {
      '1': 'ListItem',
      '2': '.healthcare.mortuary.v1.ListItemRequest',
      '3': '.healthcare.mortuary.v1.ListItemResponse'
    },
    {
      '1': 'RetainItem',
      '2': '.healthcare.mortuary.v1.RetainItemRequest',
      '3': '.healthcare.mortuary.v1.RetainItemResponse'
    },
    {
      '1': 'HandOverBelongings',
      '2': '.healthcare.mortuary.v1.HandOverBelongingsRequest',
      '3': '.healthcare.mortuary.v1.HandOverBelongingsResponse'
    },
    {
      '1': 'GetBelongings',
      '2': '.healthcare.mortuary.v1.GetBelongingsRequest',
      '3': '.healthcare.mortuary.v1.GetBelongingsResponse'
    },
    {
      '1': 'GetChainOfCustody',
      '2': '.healthcare.mortuary.v1.GetChainOfCustodyRequest',
      '3': '.healthcare.mortuary.v1.GetChainOfCustodyResponse'
    },
    {
      '1': 'RequestPostmortem',
      '2': '.healthcare.mortuary.v1.RequestPostmortemRequest',
      '3': '.healthcare.mortuary.v1.RequestPostmortemResponse'
    },
    {
      '1': 'AdvancePostmortem',
      '2': '.healthcare.mortuary.v1.AdvancePostmortemRequest',
      '3': '.healthcare.mortuary.v1.AdvancePostmortemResponse'
    },
    {
      '1': 'GetPostmortems',
      '2': '.healthcare.mortuary.v1.GetPostmortemsRequest',
      '3': '.healthcare.mortuary.v1.GetPostmortemsResponse'
    },
    {
      '1': 'RecordAuthorisation',
      '2': '.healthcare.mortuary.v1.RecordAuthorisationRequest',
      '3': '.healthcare.mortuary.v1.RecordAuthorisationResponse'
    },
    {
      '1': 'GetReleaseChecks',
      '2': '.healthcare.mortuary.v1.GetReleaseChecksRequest',
      '3': '.healthcare.mortuary.v1.GetReleaseChecksResponse'
    },
    {
      '1': 'ReleaseBody',
      '2': '.healthcare.mortuary.v1.ReleaseBodyRequest',
      '3': '.healthcare.mortuary.v1.ReleaseBodyResponse'
    },
    {
      '1': 'GetRelease',
      '2': '.healthcare.mortuary.v1.GetReleaseRequest',
      '3': '.healthcare.mortuary.v1.GetReleaseResponse'
    },
    {
      '1': 'ListReleases',
      '2': '.healthcare.mortuary.v1.ListReleasesRequest',
      '3': '.healthcare.mortuary.v1.ListReleasesResponse'
    },
    {
      '1': 'GetBoard',
      '2': '.healthcare.mortuary.v1.GetBoardRequest',
      '3': '.healthcare.mortuary.v1.GetBoardResponse'
    },
    {
      '1': 'SweepLongStay',
      '2': '.healthcare.mortuary.v1.SweepLongStayRequest',
      '3': '.healthcare.mortuary.v1.SweepLongStayResponse'
    },
  ],
};

@$core.Deprecated('Use mortuaryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MortuaryServiceBase$messageJson = {
  '.healthcare.mortuary.v1.OpenCaseRequest': OpenCaseRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.mortuary.v1.OpenCaseResponse': OpenCaseResponse$json,
  '.healthcare.mortuary.v1.Case': Case$json,
  '.healthcare.mortuary.v1.IdentifyRequest': IdentifyRequest$json,
  '.healthcare.mortuary.v1.IdentifyResponse': IdentifyResponse$json,
  '.healthcare.mortuary.v1.RecordCauseRequest': RecordCauseRequest$json,
  '.healthcare.mortuary.v1.RecordCauseResponse': RecordCauseResponse$json,
  '.healthcare.mortuary.v1.RecordDeathCertificateRequest':
      RecordDeathCertificateRequest$json,
  '.healthcare.mortuary.v1.RecordDeathCertificateResponse':
      RecordDeathCertificateResponse$json,
  '.healthcare.mortuary.v1.MarkMedicoLegalRequest': MarkMedicoLegalRequest$json,
  '.healthcare.mortuary.v1.MarkMedicoLegalResponse':
      MarkMedicoLegalResponse$json,
  '.healthcare.mortuary.v1.GetCaseRequest': GetCaseRequest$json,
  '.healthcare.mortuary.v1.GetCaseResponse': GetCaseResponse$json,
  '.healthcare.mortuary.v1.GetCaseByReferenceRequest':
      GetCaseByReferenceRequest$json,
  '.healthcare.mortuary.v1.GetCaseByReferenceResponse':
      GetCaseByReferenceResponse$json,
  '.healthcare.mortuary.v1.ListCasesRequest': ListCasesRequest$json,
  '.healthcare.mortuary.v1.ListCasesResponse': ListCasesResponse$json,
  '.healthcare.mortuary.v1.AddLocationRequest': AddLocationRequest$json,
  '.healthcare.mortuary.v1.AddLocationResponse': AddLocationResponse$json,
  '.healthcare.mortuary.v1.Location': Location$json,
  '.healthcare.mortuary.v1.SetLocationServiceRequest':
      SetLocationServiceRequest$json,
  '.healthcare.mortuary.v1.SetLocationServiceResponse':
      SetLocationServiceResponse$json,
  '.healthcare.mortuary.v1.ListLocationsRequest': ListLocationsRequest$json,
  '.healthcare.mortuary.v1.ListLocationsResponse': ListLocationsResponse$json,
  '.healthcare.mortuary.v1.PlaceBodyRequest': PlaceBodyRequest$json,
  '.healthcare.mortuary.v1.PlaceBodyResponse': PlaceBodyResponse$json,
  '.healthcare.mortuary.v1.Placement': Placement$json,
  '.healthcare.mortuary.v1.GetPlacementHistoryRequest':
      GetPlacementHistoryRequest$json,
  '.healthcare.mortuary.v1.GetPlacementHistoryResponse':
      GetPlacementHistoryResponse$json,
  '.healthcare.mortuary.v1.ListItemRequest': ListItemRequest$json,
  '.healthcare.mortuary.v1.ListItemResponse': ListItemResponse$json,
  '.healthcare.mortuary.v1.Item': Item$json,
  '.healthcare.mortuary.v1.RetainItemRequest': RetainItemRequest$json,
  '.healthcare.mortuary.v1.RetainItemResponse': RetainItemResponse$json,
  '.healthcare.mortuary.v1.HandOverBelongingsRequest':
      HandOverBelongingsRequest$json,
  '.healthcare.mortuary.v1.HandOverBelongingsResponse':
      HandOverBelongingsResponse$json,
  '.healthcare.mortuary.v1.Handover': Handover$json,
  '.healthcare.mortuary.v1.GetBelongingsRequest': GetBelongingsRequest$json,
  '.healthcare.mortuary.v1.GetBelongingsResponse': GetBelongingsResponse$json,
  '.healthcare.mortuary.v1.GetChainOfCustodyRequest':
      GetChainOfCustodyRequest$json,
  '.healthcare.mortuary.v1.GetChainOfCustodyResponse':
      GetChainOfCustodyResponse$json,
  '.healthcare.mortuary.v1.CustodyEntry': CustodyEntry$json,
  '.healthcare.mortuary.v1.RequestPostmortemRequest':
      RequestPostmortemRequest$json,
  '.healthcare.mortuary.v1.RequestPostmortemResponse':
      RequestPostmortemResponse$json,
  '.healthcare.mortuary.v1.Postmortem': Postmortem$json,
  '.healthcare.mortuary.v1.AdvancePostmortemRequest':
      AdvancePostmortemRequest$json,
  '.healthcare.mortuary.v1.AdvancePostmortemResponse':
      AdvancePostmortemResponse$json,
  '.healthcare.mortuary.v1.GetPostmortemsRequest': GetPostmortemsRequest$json,
  '.healthcare.mortuary.v1.GetPostmortemsResponse': GetPostmortemsResponse$json,
  '.healthcare.mortuary.v1.RecordAuthorisationRequest':
      RecordAuthorisationRequest$json,
  '.healthcare.mortuary.v1.RecordAuthorisationResponse':
      RecordAuthorisationResponse$json,
  '.healthcare.mortuary.v1.Authorisation': Authorisation$json,
  '.healthcare.mortuary.v1.GetReleaseChecksRequest':
      GetReleaseChecksRequest$json,
  '.healthcare.mortuary.v1.GetReleaseChecksResponse':
      GetReleaseChecksResponse$json,
  '.healthcare.mortuary.v1.ReleaseCheck': ReleaseCheck$json,
  '.healthcare.mortuary.v1.ReleaseBodyRequest': ReleaseBodyRequest$json,
  '.healthcare.mortuary.v1.ReleaseBodyResponse': ReleaseBodyResponse$json,
  '.healthcare.mortuary.v1.Release': Release$json,
  '.healthcare.mortuary.v1.GetReleaseRequest': GetReleaseRequest$json,
  '.healthcare.mortuary.v1.GetReleaseResponse': GetReleaseResponse$json,
  '.healthcare.mortuary.v1.ListReleasesRequest': ListReleasesRequest$json,
  '.healthcare.mortuary.v1.ListReleasesResponse': ListReleasesResponse$json,
  '.healthcare.mortuary.v1.GetBoardRequest': GetBoardRequest$json,
  '.healthcare.mortuary.v1.GetBoardResponse': GetBoardResponse$json,
  '.healthcare.mortuary.v1.BoardRow': BoardRow$json,
  '.healthcare.mortuary.v1.Occupancy': Occupancy$json,
  '.healthcare.mortuary.v1.Occupancy.FreeByKindEntry':
      Occupancy_FreeByKindEntry$json,
  '.healthcare.mortuary.v1.SweepLongStayRequest': SweepLongStayRequest$json,
  '.healthcare.mortuary.v1.SweepLongStayResponse': SweepLongStayResponse$json,
};

/// Descriptor for `MortuaryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mortuaryServiceDescriptor = $convert.base64Decode(
    'Cg9Nb3J0dWFyeVNlcnZpY2USXQoIT3BlbkNhc2USJy5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLk'
    '9wZW5DYXNlUmVxdWVzdBooLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuT3BlbkNhc2VSZXNwb25z'
    'ZRJdCghJZGVudGlmeRInLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuSWRlbnRpZnlSZXF1ZXN0Gi'
    'guaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5JZGVudGlmeVJlc3BvbnNlEmYKC1JlY29yZENhdXNl'
    'EiouaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5SZWNvcmRDYXVzZVJlcXVlc3QaKy5oZWFsdGhjYX'
    'JlLm1vcnR1YXJ5LnYxLlJlY29yZENhdXNlUmVzcG9uc2UShwEKFlJlY29yZERlYXRoQ2VydGlm'
    'aWNhdGUSNS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlJlY29yZERlYXRoQ2VydGlmaWNhdGVSZX'
    'F1ZXN0GjYuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5SZWNvcmREZWF0aENlcnRpZmljYXRlUmVz'
    'cG9uc2UScgoPTWFya01lZGljb0xlZ2FsEi4uaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5NYXJrTW'
    'VkaWNvTGVnYWxSZXF1ZXN0Gi8uaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5NYXJrTWVkaWNvTGVn'
    'YWxSZXNwb25zZRJaCgdHZXRDYXNlEiYuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5HZXRDYXNlUm'
    'VxdWVzdBonLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0Q2FzZVJlc3BvbnNlEnsKEkdldENh'
    'c2VCeVJlZmVyZW5jZRIxLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0Q2FzZUJ5UmVmZXJlbm'
    'NlUmVxdWVzdBoyLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0Q2FzZUJ5UmVmZXJlbmNlUmVz'
    'cG9uc2USYAoJTGlzdENhc2VzEiguaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5MaXN0Q2FzZXNSZX'
    'F1ZXN0GikuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5MaXN0Q2FzZXNSZXNwb25zZRJmCgtBZGRM'
    'b2NhdGlvbhIqLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuQWRkTG9jYXRpb25SZXF1ZXN0GisuaG'
    'VhbHRoY2FyZS5tb3J0dWFyeS52MS5BZGRMb2NhdGlvblJlc3BvbnNlEnsKElNldExvY2F0aW9u'
    'U2VydmljZRIxLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuU2V0TG9jYXRpb25TZXJ2aWNlUmVxdW'
    'VzdBoyLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuU2V0TG9jYXRpb25TZXJ2aWNlUmVzcG9uc2US'
    'bAoNTGlzdExvY2F0aW9ucxIsLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuTGlzdExvY2F0aW9uc1'
    'JlcXVlc3QaLS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkxpc3RMb2NhdGlvbnNSZXNwb25zZRJg'
    'CglQbGFjZUJvZHkSKC5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlBsYWNlQm9keVJlcXVlc3QaKS'
    '5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlBsYWNlQm9keVJlc3BvbnNlEn4KE0dldFBsYWNlbWVu'
    'dEhpc3RvcnkSMi5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkdldFBsYWNlbWVudEhpc3RvcnlSZX'
    'F1ZXN0GjMuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5HZXRQbGFjZW1lbnRIaXN0b3J5UmVzcG9u'
    'c2USXQoITGlzdEl0ZW0SJy5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkxpc3RJdGVtUmVxdWVzdB'
    'ooLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuTGlzdEl0ZW1SZXNwb25zZRJjCgpSZXRhaW5JdGVt'
    'EikuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5SZXRhaW5JdGVtUmVxdWVzdBoqLmhlYWx0aGNhcm'
    'UubW9ydHVhcnkudjEuUmV0YWluSXRlbVJlc3BvbnNlEnsKEkhhbmRPdmVyQmVsb25naW5ncxIx'
    'LmhlYWx0aGNhcmUubW9ydHVhcnkudjEuSGFuZE92ZXJCZWxvbmdpbmdzUmVxdWVzdBoyLmhlYW'
    'x0aGNhcmUubW9ydHVhcnkudjEuSGFuZE92ZXJCZWxvbmdpbmdzUmVzcG9uc2USbAoNR2V0QmVs'
    'b25naW5ncxIsLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0QmVsb25naW5nc1JlcXVlc3QaLS'
    '5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkdldEJlbG9uZ2luZ3NSZXNwb25zZRJ4ChFHZXRDaGFp'
    'bk9mQ3VzdG9keRIwLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0Q2hhaW5PZkN1c3RvZHlSZX'
    'F1ZXN0GjEuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5HZXRDaGFpbk9mQ3VzdG9keVJlc3BvbnNl'
    'EngKEVJlcXVlc3RQb3N0bW9ydGVtEjAuaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5SZXF1ZXN0UG'
    '9zdG1vcnRlbVJlcXVlc3QaMS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLlJlcXVlc3RQb3N0bW9y'
    'dGVtUmVzcG9uc2USeAoRQWR2YW5jZVBvc3Rtb3J0ZW0SMC5oZWFsdGhjYXJlLm1vcnR1YXJ5Ln'
    'YxLkFkdmFuY2VQb3N0bW9ydGVtUmVxdWVzdBoxLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuQWR2'
    'YW5jZVBvc3Rtb3J0ZW1SZXNwb25zZRJvCg5HZXRQb3N0bW9ydGVtcxItLmhlYWx0aGNhcmUubW'
    '9ydHVhcnkudjEuR2V0UG9zdG1vcnRlbXNSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5tb3J0dWFyeS52'
    'MS5HZXRQb3N0bW9ydGVtc1Jlc3BvbnNlEn4KE1JlY29yZEF1dGhvcmlzYXRpb24SMi5oZWFsdG'
    'hjYXJlLm1vcnR1YXJ5LnYxLlJlY29yZEF1dGhvcmlzYXRpb25SZXF1ZXN0GjMuaGVhbHRoY2Fy'
    'ZS5tb3J0dWFyeS52MS5SZWNvcmRBdXRob3Jpc2F0aW9uUmVzcG9uc2USdQoQR2V0UmVsZWFzZU'
    'NoZWNrcxIvLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuR2V0UmVsZWFzZUNoZWNrc1JlcXVlc3Qa'
    'MC5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkdldFJlbGVhc2VDaGVja3NSZXNwb25zZRJmCgtSZW'
    'xlYXNlQm9keRIqLmhlYWx0aGNhcmUubW9ydHVhcnkudjEuUmVsZWFzZUJvZHlSZXF1ZXN0Gisu'
    'aGVhbHRoY2FyZS5tb3J0dWFyeS52MS5SZWxlYXNlQm9keVJlc3BvbnNlEmMKCkdldFJlbGVhc2'
    'USKS5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLkdldFJlbGVhc2VSZXF1ZXN0GiouaGVhbHRoY2Fy'
    'ZS5tb3J0dWFyeS52MS5HZXRSZWxlYXNlUmVzcG9uc2USaQoMTGlzdFJlbGVhc2VzEisuaGVhbH'
    'RoY2FyZS5tb3J0dWFyeS52MS5MaXN0UmVsZWFzZXNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5tb3J0'
    'dWFyeS52MS5MaXN0UmVsZWFzZXNSZXNwb25zZRJdCghHZXRCb2FyZBInLmhlYWx0aGNhcmUubW'
    '9ydHVhcnkudjEuR2V0Qm9hcmRSZXF1ZXN0GiguaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5HZXRC'
    'b2FyZFJlc3BvbnNlEmwKDVN3ZWVwTG9uZ1N0YXkSLC5oZWFsdGhjYXJlLm1vcnR1YXJ5LnYxLl'
    'N3ZWVwTG9uZ1N0YXlSZXF1ZXN0Gi0uaGVhbHRoY2FyZS5tb3J0dWFyeS52MS5Td2VlcExvbmdT'
    'dGF5UmVzcG9uc2U=');
