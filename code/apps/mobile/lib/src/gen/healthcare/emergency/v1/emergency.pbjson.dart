// This is a generated file - do not edit.
//
// Generated from healthcare/emergency/v1/emergency.proto.

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

@$core.Deprecated('Use arrivalModeDescriptor instead')
const ArrivalMode$json = {
  '1': 'ArrivalMode',
  '2': [
    {'1': 'ARRIVAL_MODE_UNSPECIFIED', '2': 0},
    {'1': 'ARRIVAL_MODE_WALK_IN', '2': 1},
    {'1': 'ARRIVAL_MODE_AMBULANCE', '2': 2},
    {'1': 'ARRIVAL_MODE_REFERRAL', '2': 3},
    {'1': 'ARRIVAL_MODE_TRANSFER', '2': 4},
  ],
};

/// Descriptor for `ArrivalMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List arrivalModeDescriptor = $convert.base64Decode(
    'CgtBcnJpdmFsTW9kZRIcChhBUlJJVkFMX01PREVfVU5TUEVDSUZJRUQQABIYChRBUlJJVkFMX0'
    '1PREVfV0FMS19JThABEhoKFkFSUklWQUxfTU9ERV9BTUJVTEFOQ0UQAhIZChVBUlJJVkFMX01P'
    'REVfUkVGRVJSQUwQAxIZChVBUlJJVkFMX01PREVfVFJBTlNGRVIQBA==');

@$core.Deprecated('Use visitStatusDescriptor instead')
const VisitStatus$json = {
  '1': 'VisitStatus',
  '2': [
    {'1': 'VISIT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'VISIT_STATUS_ARRIVED', '2': 1},
    {'1': 'VISIT_STATUS_TRIAGED', '2': 2},
    {'1': 'VISIT_STATUS_IN_TREATMENT', '2': 3},
    {'1': 'VISIT_STATUS_OBSERVATION', '2': 4},
    {'1': 'VISIT_STATUS_DISPOSED', '2': 5},
  ],
};

/// Descriptor for `VisitStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visitStatusDescriptor = $convert.base64Decode(
    'CgtWaXNpdFN0YXR1cxIcChhWSVNJVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRWSVNJVF9TVE'
    'FUVVNfQVJSSVZFRBABEhgKFFZJU0lUX1NUQVRVU19UUklBR0VEEAISHQoZVklTSVRfU1RBVFVT'
    'X0lOX1RSRUFUTUVOVBADEhwKGFZJU0lUX1NUQVRVU19PQlNFUlZBVElPThAEEhkKFVZJU0lUX1'
    'NUQVRVU19ESVNQT1NFRBAF');

@$core.Deprecated('Use dispositionDescriptor instead')
const Disposition$json = {
  '1': 'Disposition',
  '2': [
    {'1': 'DISPOSITION_UNSPECIFIED', '2': 0},
    {'1': 'DISPOSITION_DISCHARGE', '2': 1},
    {'1': 'DISPOSITION_OBSERVATION', '2': 2},
    {'1': 'DISPOSITION_ADMISSION', '2': 3},
    {'1': 'DISPOSITION_THEATRE', '2': 4},
    {'1': 'DISPOSITION_ICU', '2': 5},
    {'1': 'DISPOSITION_TRANSFER', '2': 6},
    {'1': 'DISPOSITION_LEFT_AGAINST_ADVICE', '2': 7},
    {'1': 'DISPOSITION_ABSCONDED', '2': 8},
    {'1': 'DISPOSITION_DEATH', '2': 9},
    {'1': 'DISPOSITION_REFERRAL', '2': 10},
  ],
};

/// Descriptor for `Disposition`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dispositionDescriptor = $convert.base64Decode(
    'CgtEaXNwb3NpdGlvbhIbChdESVNQT1NJVElPTl9VTlNQRUNJRklFRBAAEhkKFURJU1BPU0lUSU'
    '9OX0RJU0NIQVJHRRABEhsKF0RJU1BPU0lUSU9OX09CU0VSVkFUSU9OEAISGQoVRElTUE9TSVRJ'
    'T05fQURNSVNTSU9OEAMSFwoTRElTUE9TSVRJT05fVEhFQVRSRRAEEhMKD0RJU1BPU0lUSU9OX0'
    'lDVRAFEhgKFERJU1BPU0lUSU9OX1RSQU5TRkVSEAYSIwofRElTUE9TSVRJT05fTEVGVF9BR0FJ'
    'TlNUX0FEVklDRRAHEhkKFURJU1BPU0lUSU9OX0FCU0NPTkRFRBAIEhUKEURJU1BPU0lUSU9OX0'
    'RFQVRIEAkSGAoURElTUE9TSVRJT05fUkVGRVJSQUwQCg==');

@$core.Deprecated('Use pathwayKindDescriptor instead')
const PathwayKind$json = {
  '1': 'PathwayKind',
  '2': [
    {'1': 'PATHWAY_KIND_UNSPECIFIED', '2': 0},
    {'1': 'PATHWAY_KIND_RESUSCITATION', '2': 1},
    {'1': 'PATHWAY_KIND_TRAUMA', '2': 2},
    {'1': 'PATHWAY_KIND_STROKE', '2': 3},
    {'1': 'PATHWAY_KIND_STEMI', '2': 4},
    {'1': 'PATHWAY_KIND_SEPSIS', '2': 5},
    {'1': 'PATHWAY_KIND_OTHER', '2': 6},
  ],
};

/// Descriptor for `PathwayKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List pathwayKindDescriptor = $convert.base64Decode(
    'CgtQYXRod2F5S2luZBIcChhQQVRIV0FZX0tJTkRfVU5TUEVDSUZJRUQQABIeChpQQVRIV0FZX0'
    'tJTkRfUkVTVVNDSVRBVElPThABEhcKE1BBVEhXQVlfS0lORF9UUkFVTUEQAhIXChNQQVRIV0FZ'
    'X0tJTkRfU1RST0tFEAMSFgoSUEFUSFdBWV9LSU5EX1NURU1JEAQSFwoTUEFUSFdBWV9LSU5EX1'
    'NFUFNJUxAFEhYKElBBVEhXQVlfS0lORF9PVEhFUhAG');

@$core.Deprecated('Use eventKindDescriptor instead')
const EventKind$json = {
  '1': 'EventKind',
  '2': [
    {'1': 'EVENT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EVENT_KIND_ARRIVAL', '2': 1},
    {'1': 'EVENT_KIND_TRIAGE', '2': 2},
    {'1': 'EVENT_KIND_CLINICIAN_SEEN', '2': 3},
    {'1': 'EVENT_KIND_PATHWAY_ACTIVATED', '2': 4},
    {'1': 'EVENT_KIND_MILESTONE', '2': 5},
    {'1': 'EVENT_KIND_AIRWAY', '2': 6},
    {'1': 'EVENT_KIND_CPR', '2': 7},
    {'1': 'EVENT_KIND_DEFIBRILLATION', '2': 8},
    {'1': 'EVENT_KIND_FLUID', '2': 9},
    {'1': 'EVENT_KIND_DRUG', '2': 10},
    {'1': 'EVENT_KIND_PROCEDURE', '2': 11},
    {'1': 'EVENT_KIND_OBSERVATION', '2': 12},
    {'1': 'EVENT_KIND_DISPOSITION', '2': 13},
  ],
};

/// Descriptor for `EventKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List eventKindDescriptor = $convert.base64Decode(
    'CglFdmVudEtpbmQSGgoWRVZFTlRfS0lORF9VTlNQRUNJRklFRBAAEhYKEkVWRU5UX0tJTkRfQV'
    'JSSVZBTBABEhUKEUVWRU5UX0tJTkRfVFJJQUdFEAISHQoZRVZFTlRfS0lORF9DTElOSUNJQU5f'
    'U0VFThADEiAKHEVWRU5UX0tJTkRfUEFUSFdBWV9BQ1RJVkFURUQQBBIYChRFVkVOVF9LSU5EX0'
    '1JTEVTVE9ORRAFEhUKEUVWRU5UX0tJTkRfQUlSV0FZEAYSEgoORVZFTlRfS0lORF9DUFIQBxId'
    'ChlFVkVOVF9LSU5EX0RFRklCUklMTEFUSU9OEAgSFAoQRVZFTlRfS0lORF9GTFVJRBAJEhMKD0'
    'VWRU5UX0tJTkRfRFJVRxAKEhgKFEVWRU5UX0tJTkRfUFJPQ0VEVVJFEAsSGgoWRVZFTlRfS0lO'
    'RF9PQlNFUlZBVElPThAMEhoKFkVWRU5UX0tJTkRfRElTUE9TSVRJT04QDQ==');

@$core.Deprecated('Use emergencyVisitDescriptor instead')
const EmergencyVisit$json = {
  '1': 'EmergencyVisit',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 3, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'arrival_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.ArrivalMode',
      '10': 'arrivalMode'
    },
    {'1': 'chief_complaint', '3': 6, '4': 1, '5': 9, '10': 'chiefComplaint'},
    {
      '1': 'arrived_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'arrivedAt'
    },
    {'1': 'unidentified', '3': 8, '4': 1, '5': 8, '10': 'unidentified'},
    {'1': 'temporary_name', '3': 9, '4': 1, '5': 9, '10': 'temporaryName'},
    {'1': 'medico_legal', '3': 10, '4': 1, '5': 8, '10': 'medicoLegal'},
    {'1': 'medico_legal_ref', '3': 11, '4': 1, '5': 9, '10': 'medicoLegalRef'},
    {
      '1': 'status',
      '3': 12,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.VisitStatus',
      '10': 'status'
    },
    {'1': 'location', '3': 13, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'disposition',
      '3': 14,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.Disposition',
      '10': 'disposition'
    },
    {
      '1': 'disposed_at',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'disposedAt'
    },
    {'1': 'disposition_note', '3': 16, '4': 1, '5': 9, '10': 'dispositionNote'},
    {
      '1': 'receiving_service',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'receivingService'
    },
    {
      '1': 'observation_started_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observationStartedAt'
    },
    {
      '1': 'observation_ends_at',
      '3': 19,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'observationEndsAt'
    },
    {'1': 'created_by', '3': 20, '4': 1, '5': 9, '10': 'createdBy'},
    {
      '1': 'created_at',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 23, '4': 1, '5': 3, '10': 'version'},
    {'1': 'restricted', '3': 24, '4': 1, '5': 8, '10': 'restricted'},
  ],
};

/// Descriptor for `EmergencyVisit`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emergencyVisitDescriptor = $convert.base64Decode(
    'Cg5FbWVyZ2VuY3lWaXNpdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBIhCgxlbmNvdW50ZX'
    'JfaWQYAiABKAlSC2VuY291bnRlcklkEh0KCnBhdGllbnRfaWQYAyABKAlSCXBhdGllbnRJZBIf'
    'CgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBJHCgxhcnJpdmFsX21vZGUYBSABKA4yJC'
    '5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5BcnJpdmFsTW9kZVILYXJyaXZhbE1vZGUSJwoPY2hp'
    'ZWZfY29tcGxhaW50GAYgASgJUg5jaGllZkNvbXBsYWludBI5CgphcnJpdmVkX2F0GAcgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJYXJyaXZlZEF0EiIKDHVuaWRlbnRpZmllZBgI'
    'IAEoCFIMdW5pZGVudGlmaWVkEiUKDnRlbXBvcmFyeV9uYW1lGAkgASgJUg10ZW1wb3JhcnlOYW'
    '1lEiEKDG1lZGljb19sZWdhbBgKIAEoCFILbWVkaWNvTGVnYWwSKAoQbWVkaWNvX2xlZ2FsX3Jl'
    'ZhgLIAEoCVIObWVkaWNvTGVnYWxSZWYSPAoGc3RhdHVzGAwgASgOMiQuaGVhbHRoY2FyZS5lbW'
    'VyZ2VuY3kudjEuVmlzaXRTdGF0dXNSBnN0YXR1cxIaCghsb2NhdGlvbhgNIAEoCVIIbG9jYXRp'
    'b24SRgoLZGlzcG9zaXRpb24YDiABKA4yJC5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5EaXNwb3'
    'NpdGlvblILZGlzcG9zaXRpb24SOwoLZGlzcG9zZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgpkaXNwb3NlZEF0EikKEGRpc3Bvc2l0aW9uX25vdGUYECABKAlSD2Rpc3'
    'Bvc2l0aW9uTm90ZRIrChFyZWNlaXZpbmdfc2VydmljZRgRIAEoCVIQcmVjZWl2aW5nU2Vydmlj'
    'ZRJQChZvYnNlcnZhdGlvbl9zdGFydGVkX2F0GBIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIUb2JzZXJ2YXRpb25TdGFydGVkQXQSSgoTb2JzZXJ2YXRpb25fZW5kc19hdBgTIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEW9ic2VydmF0aW9uRW5kc0F0Eh0KCmNyZW'
    'F0ZWRfYnkYFCABKAlSCWNyZWF0ZWRCeRI5CgpjcmVhdGVkX2F0GBUgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYFiABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSGAoHdmVyc2lvbhgXIAEoA1IHdmVyc2lv'
    'bhIeCgpyZXN0cmljdGVkGBggASgIUgpyZXN0cmljdGVk');

@$core.Deprecated('Use triageDescriptor instead')
const Triage$json = {
  '1': 'Triage',
  '2': [
    {'1': 'triage_id', '3': 1, '4': 1, '5': 9, '10': 'triageId'},
    {'1': 'visit_id', '3': 2, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'scale_name', '3': 3, '4': 1, '5': 9, '10': 'scaleName'},
    {'1': 'scale_version', '3': 4, '4': 1, '5': 9, '10': 'scaleVersion'},
    {'1': 'acuity_code', '3': 5, '4': 1, '5': 9, '10': 'acuityCode'},
    {'1': 'acuity_rank', '3': 6, '4': 1, '5': 5, '10': 'acuityRank'},
    {
      '1': 'respiratory_rate',
      '3': 7,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'respiratoryRate',
      '17': true
    },
    {
      '1': 'heart_rate',
      '3': 8,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'heartRate',
      '17': true
    },
    {
      '1': 'systolic_bp',
      '3': 9,
      '4': 1,
      '5': 5,
      '9': 2,
      '10': 'systolicBp',
      '17': true
    },
    {
      '1': 'oxygen_saturation',
      '3': 10,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'oxygenSaturation',
      '17': true
    },
    {
      '1': 'temperature',
      '3': 11,
      '4': 1,
      '5': 1,
      '9': 4,
      '10': 'temperature',
      '17': true
    },
    {
      '1': 'pain_score',
      '3': 12,
      '4': 1,
      '5': 5,
      '9': 5,
      '10': 'painScore',
      '17': true
    },
    {'1': 'consciousness', '3': 13, '4': 1, '5': 9, '10': 'consciousness'},
    {'1': 'red_flags', '3': 14, '4': 3, '5': 9, '10': 'redFlags'},
    {'1': 'missing_fields', '3': 15, '4': 3, '5': 9, '10': 'missingFields'},
    {'1': 'note', '3': 16, '4': 1, '5': 9, '10': 'note'},
    {'1': 'assessed_by', '3': 17, '4': 1, '5': 9, '10': 'assessedBy'},
    {
      '1': 'assessed_at',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'assessedAt'
    },
  ],
  '8': [
    {'1': '_respiratory_rate'},
    {'1': '_heart_rate'},
    {'1': '_systolic_bp'},
    {'1': '_oxygen_saturation'},
    {'1': '_temperature'},
    {'1': '_pain_score'},
  ],
};

/// Descriptor for `Triage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List triageDescriptor = $convert.base64Decode(
    'CgZUcmlhZ2USGwoJdHJpYWdlX2lkGAEgASgJUgh0cmlhZ2VJZBIZCgh2aXNpdF9pZBgCIAEoCV'
    'IHdmlzaXRJZBIdCgpzY2FsZV9uYW1lGAMgASgJUglzY2FsZU5hbWUSIwoNc2NhbGVfdmVyc2lv'
    'bhgEIAEoCVIMc2NhbGVWZXJzaW9uEh8KC2FjdWl0eV9jb2RlGAUgASgJUgphY3VpdHlDb2RlEh'
    '8KC2FjdWl0eV9yYW5rGAYgASgFUgphY3VpdHlSYW5rEi4KEHJlc3BpcmF0b3J5X3JhdGUYByAB'
    'KAVIAFIPcmVzcGlyYXRvcnlSYXRliAEBEiIKCmhlYXJ0X3JhdGUYCCABKAVIAVIJaGVhcnRSYX'
    'RliAEBEiQKC3N5c3RvbGljX2JwGAkgASgFSAJSCnN5c3RvbGljQnCIAQESMAoRb3h5Z2VuX3Nh'
    'dHVyYXRpb24YCiABKAVIA1IQb3h5Z2VuU2F0dXJhdGlvbogBARIlCgt0ZW1wZXJhdHVyZRgLIA'
    'EoAUgEUgt0ZW1wZXJhdHVyZYgBARIiCgpwYWluX3Njb3JlGAwgASgFSAVSCXBhaW5TY29yZYgB'
    'ARIkCg1jb25zY2lvdXNuZXNzGA0gASgJUg1jb25zY2lvdXNuZXNzEhsKCXJlZF9mbGFncxgOIA'
    'MoCVIIcmVkRmxhZ3MSJQoObWlzc2luZ19maWVsZHMYDyADKAlSDW1pc3NpbmdGaWVsZHMSEgoE'
    'bm90ZRgQIAEoCVIEbm90ZRIfCgthc3Nlc3NlZF9ieRgRIAEoCVIKYXNzZXNzZWRCeRI7Cgthc3'
    'Nlc3NlZF9hdBgSIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFzc2Vzc2VkQXRC'
    'EwoRX3Jlc3BpcmF0b3J5X3JhdGVCDQoLX2hlYXJ0X3JhdGVCDgoMX3N5c3RvbGljX2JwQhQKEl'
    '9veHlnZW5fc2F0dXJhdGlvbkIOCgxfdGVtcGVyYXR1cmVCDQoLX3BhaW5fc2NvcmU=');

@$core.Deprecated('Use priorityOverrideDescriptor instead')
const PriorityOverride$json = {
  '1': 'PriorityOverride',
  '2': [
    {'1': 'acuity_rank', '3': 1, '4': 1, '5': 5, '10': 'acuityRank'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'overridden_by', '3': 3, '4': 1, '5': 9, '10': 'overriddenBy'},
    {
      '1': 'overridden_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'overriddenAt'
    },
  ],
};

/// Descriptor for `PriorityOverride`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List priorityOverrideDescriptor = $convert.base64Decode(
    'ChBQcmlvcml0eU92ZXJyaWRlEh8KC2FjdWl0eV9yYW5rGAEgASgFUgphY3VpdHlSYW5rEhYKBn'
    'JlYXNvbhgCIAEoCVIGcmVhc29uEiMKDW92ZXJyaWRkZW5fYnkYAyABKAlSDG92ZXJyaWRkZW5C'
    'eRI/Cg1vdmVycmlkZGVuX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMb3'
    'ZlcnJpZGRlbkF0');

@$core.Deprecated('Use milestoneTargetDescriptor instead')
const MilestoneTarget$json = {
  '1': 'MilestoneTarget',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'label', '3': 2, '4': 1, '5': 9, '10': 'label'},
    {'1': 'within_seconds', '3': 3, '4': 1, '5': 3, '10': 'withinSeconds'},
  ],
};

/// Descriptor for `MilestoneTarget`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List milestoneTargetDescriptor = $convert.base64Decode(
    'Cg9NaWxlc3RvbmVUYXJnZXQSEgoEY29kZRgBIAEoCVIEY29kZRIUCgVsYWJlbBgCIAEoCVIFbG'
    'FiZWwSJQoOd2l0aGluX3NlY29uZHMYAyABKANSDXdpdGhpblNlY29uZHM=');

@$core.Deprecated('Use milestoneStateDescriptor instead')
const MilestoneState$json = {
  '1': 'MilestoneState',
  '2': [
    {
      '1': 'target',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.MilestoneTarget',
      '10': 'target'
    },
    {'1': 'reached', '3': 2, '4': 1, '5': 8, '10': 'reached'},
    {
      '1': 'reached_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reachedAt'
    },
    {'1': 'elapsed_seconds', '3': 4, '4': 1, '5': 3, '10': 'elapsedSeconds'},
    {'1': 'breached', '3': 5, '4': 1, '5': 8, '10': 'breached'},
  ],
};

/// Descriptor for `MilestoneState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List milestoneStateDescriptor = $convert.base64Decode(
    'Cg5NaWxlc3RvbmVTdGF0ZRJACgZ0YXJnZXQYASABKAsyKC5oZWFsdGhjYXJlLmVtZXJnZW5jeS'
    '52MS5NaWxlc3RvbmVUYXJnZXRSBnRhcmdldBIYCgdyZWFjaGVkGAIgASgIUgdyZWFjaGVkEjkK'
    'CnJlYWNoZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglyZWFjaGVkQX'
    'QSJwoPZWxhcHNlZF9zZWNvbmRzGAQgASgDUg5lbGFwc2VkU2Vjb25kcxIaCghicmVhY2hlZBgF'
    'IAEoCFIIYnJlYWNoZWQ=');

@$core.Deprecated('Use pathwayDescriptor instead')
const Pathway$json = {
  '1': 'Pathway',
  '2': [
    {'1': 'pathway_id', '3': 1, '4': 1, '5': 9, '10': 'pathwayId'},
    {'1': 'visit_id', '3': 2, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.PathwayKind',
      '10': 'kind'
    },
    {'1': 'label', '3': 4, '4': 1, '5': 9, '10': 'label'},
    {
      '1': 'activated_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'activatedAt'
    },
    {'1': 'activated_by', '3': 6, '4': 1, '5': 9, '10': 'activatedBy'},
    {'1': 'notified_team', '3': 7, '4': 1, '5': 9, '10': 'notifiedTeam'},
    {
      '1': 'escalation_notice_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'escalationNoticeId'
    },
    {
      '1': 'targets',
      '3': 9,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.MilestoneTarget',
      '10': 'targets'
    },
    {
      '1': 'stood_down_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'stoodDownAt'
    },
    {
      '1': 'stood_down_reason',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'stoodDownReason'
    },
  ],
};

/// Descriptor for `Pathway`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathwayDescriptor = $convert.base64Decode(
    'CgdQYXRod2F5Eh0KCnBhdGh3YXlfaWQYASABKAlSCXBhdGh3YXlJZBIZCgh2aXNpdF9pZBgCIA'
    'EoCVIHdmlzaXRJZBI4CgRraW5kGAMgASgOMiQuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUGF0'
    'aHdheUtpbmRSBGtpbmQSFAoFbGFiZWwYBCABKAlSBWxhYmVsEj0KDGFjdGl2YXRlZF9hdBgFIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2FjdGl2YXRlZEF0EiEKDGFjdGl2YXRl'
    'ZF9ieRgGIAEoCVILYWN0aXZhdGVkQnkSIwoNbm90aWZpZWRfdGVhbRgHIAEoCVIMbm90aWZpZW'
    'RUZWFtEjAKFGVzY2FsYXRpb25fbm90aWNlX2lkGAggASgJUhJlc2NhbGF0aW9uTm90aWNlSWQS'
    'QgoHdGFyZ2V0cxgJIAMoCzIoLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLk1pbGVzdG9uZVRhcm'
    'dldFIHdGFyZ2V0cxI+Cg1zdG9vZF9kb3duX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFILc3Rvb2REb3duQXQSKgoRc3Rvb2RfZG93bl9yZWFzb24YCyABKAlSD3N0b29kRG'
    '93blJlYXNvbg==');

@$core.Deprecated('Use emergencyEventDescriptor instead')
const EmergencyEvent$json = {
  '1': 'EmergencyEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'visit_id', '3': 2, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.EventKind',
      '10': 'kind'
    },
    {'1': 'detail', '3': 4, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'occurred_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {
      '1': 'recorded_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'sequence', '3': 7, '4': 1, '5': 5, '10': 'sequence'},
    {'1': 'actor_id', '3': 8, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'late', '3': 9, '4': 1, '5': 8, '10': 'late'},
    {'1': 'pathway_id', '3': 10, '4': 1, '5': 9, '10': 'pathwayId'},
    {'1': 'protocol_id', '3': 11, '4': 1, '5': 9, '10': 'protocolId'},
    {
      '1': 'needs_reconciliation',
      '3': 12,
      '4': 1,
      '5': 8,
      '10': 'needsReconciliation'
    },
    {
      '1': 'reconciled_order_id',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'reconciledOrderId'
    },
  ],
};

/// Descriptor for `EmergencyEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emergencyEventDescriptor = $convert.base64Decode(
    'Cg5FbWVyZ2VuY3lFdmVudBIZCghldmVudF9pZBgBIAEoCVIHZXZlbnRJZBIZCgh2aXNpdF9pZB'
    'gCIAEoCVIHdmlzaXRJZBI2CgRraW5kGAMgASgOMiIuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEu'
    'RXZlbnRLaW5kUgRraW5kEhYKBmRldGFpbBgEIAEoCVIGZGV0YWlsEjsKC29jY3VycmVkX2F0GA'
    'UgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBI7CgtyZWNvcmRl'
    'ZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJlY29yZGVkQXQSGgoIc2'
    'VxdWVuY2UYByABKAVSCHNlcXVlbmNlEhkKCGFjdG9yX2lkGAggASgJUgdhY3RvcklkEhIKBGxh'
    'dGUYCSABKAhSBGxhdGUSHQoKcGF0aHdheV9pZBgKIAEoCVIJcGF0aHdheUlkEh8KC3Byb3RvY2'
    '9sX2lkGAsgASgJUgpwcm90b2NvbElkEjEKFG5lZWRzX3JlY29uY2lsaWF0aW9uGAwgASgIUhNu'
    'ZWVkc1JlY29uY2lsaWF0aW9uEi4KE3JlY29uY2lsZWRfb3JkZXJfaWQYDSABKAlSEXJlY29uY2'
    'lsZWRPcmRlcklk');

@$core.Deprecated('Use intervalsDescriptor instead')
const Intervals$json = {
  '1': 'Intervals',
  '2': [
    {
      '1': 'door_to_triage_seconds',
      '3': 1,
      '4': 1,
      '5': 3,
      '9': 0,
      '10': 'doorToTriageSeconds',
      '17': true
    },
    {
      '1': 'door_to_clinician_seconds',
      '3': 2,
      '4': 1,
      '5': 3,
      '9': 1,
      '10': 'doorToClinicianSeconds',
      '17': true
    },
    {
      '1': 'door_to_disposition_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '9': 2,
      '10': 'doorToDispositionSeconds',
      '17': true
    },
  ],
  '8': [
    {'1': '_door_to_triage_seconds'},
    {'1': '_door_to_clinician_seconds'},
    {'1': '_door_to_disposition_seconds'},
  ],
};

/// Descriptor for `Intervals`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List intervalsDescriptor = $convert.base64Decode(
    'CglJbnRlcnZhbHMSOAoWZG9vcl90b190cmlhZ2Vfc2Vjb25kcxgBIAEoA0gAUhNkb29yVG9Ucm'
    'lhZ2VTZWNvbmRziAEBEj4KGWRvb3JfdG9fY2xpbmljaWFuX3NlY29uZHMYAiABKANIAVIWZG9v'
    'clRvQ2xpbmljaWFuU2Vjb25kc4gBARJCChtkb29yX3RvX2Rpc3Bvc2l0aW9uX3NlY29uZHMYAy'
    'ABKANIAlIYZG9vclRvRGlzcG9zaXRpb25TZWNvbmRziAEBQhkKF19kb29yX3RvX3RyaWFnZV9z'
    'ZWNvbmRzQhwKGl9kb29yX3RvX2NsaW5pY2lhbl9zZWNvbmRzQh4KHF9kb29yX3RvX2Rpc3Bvc2'
    'l0aW9uX3NlY29uZHM=');

@$core.Deprecated('Use boardRowDescriptor instead')
const BoardRow$json = {
  '1': 'BoardRow',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'display', '3': 2, '4': 1, '5': 9, '10': 'display'},
    {'1': 'acuity_rank', '3': 3, '4': 1, '5': 5, '10': 'acuityRank'},
    {'1': 'scale_name', '3': 4, '4': 1, '5': 9, '10': 'scaleName'},
    {'1': 'triaged', '3': 5, '4': 1, '5': 8, '10': 'triaged'},
    {
      '1': 'arrived_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'arrivedAt'
    },
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.VisitStatus',
      '10': 'status'
    },
    {'1': 'location', '3': 8, '4': 1, '5': 9, '10': 'location'},
    {
      '1': 'override',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.PriorityOverride',
      '10': 'override'
    },
    {'1': 'pending_orders', '3': 10, '4': 1, '5': 5, '10': 'pendingOrders'},
    {
      '1': 'disposition_barrier',
      '3': 11,
      '4': 1,
      '5': 9,
      '10': 'dispositionBarrier'
    },
    {
      '1': 'pathways',
      '3': 12,
      '4': 3,
      '5': 14,
      '6': '.healthcare.emergency.v1.PathwayKind',
      '10': 'pathways'
    },
    {'1': 'waiting_seconds', '3': 13, '4': 1, '5': 3, '10': 'waitingSeconds'},
    {'1': 'breaching', '3': 14, '4': 1, '5': 8, '10': 'breaching'},
    {
      '1': 'observation_overdue',
      '3': 15,
      '4': 1,
      '5': 8,
      '10': 'observationOverdue'
    },
    {'1': 'restricted', '3': 16, '4': 1, '5': 8, '10': 'restricted'},
  ],
};

/// Descriptor for `BoardRow`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boardRowDescriptor = $convert.base64Decode(
    'CghCb2FyZFJvdxIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBIYCgdkaXNwbGF5GAIgASgJUg'
    'dkaXNwbGF5Eh8KC2FjdWl0eV9yYW5rGAMgASgFUgphY3VpdHlSYW5rEh0KCnNjYWxlX25hbWUY'
    'BCABKAlSCXNjYWxlTmFtZRIYCgd0cmlhZ2VkGAUgASgIUgd0cmlhZ2VkEjkKCmFycml2ZWRfYX'
    'QYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglhcnJpdmVkQXQSPAoGc3RhdHVz'
    'GAcgASgOMiQuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuVmlzaXRTdGF0dXNSBnN0YXR1cxIaCg'
    'hsb2NhdGlvbhgIIAEoCVIIbG9jYXRpb24SRQoIb3ZlcnJpZGUYCSABKAsyKS5oZWFsdGhjYXJl'
    'LmVtZXJnZW5jeS52MS5Qcmlvcml0eU92ZXJyaWRlUghvdmVycmlkZRIlCg5wZW5kaW5nX29yZG'
    'VycxgKIAEoBVINcGVuZGluZ09yZGVycxIvChNkaXNwb3NpdGlvbl9iYXJyaWVyGAsgASgJUhJk'
    'aXNwb3NpdGlvbkJhcnJpZXISQAoIcGF0aHdheXMYDCADKA4yJC5oZWFsdGhjYXJlLmVtZXJnZW'
    '5jeS52MS5QYXRod2F5S2luZFIIcGF0aHdheXMSJwoPd2FpdGluZ19zZWNvbmRzGA0gASgDUg53'
    'YWl0aW5nU2Vjb25kcxIcCglicmVhY2hpbmcYDiABKAhSCWJyZWFjaGluZxIvChNvYnNlcnZhdG'
    'lvbl9vdmVyZHVlGA8gASgIUhJvYnNlcnZhdGlvbk92ZXJkdWUSHgoKcmVzdHJpY3RlZBgQIAEo'
    'CFIKcmVzdHJpY3RlZA==');

@$core.Deprecated('Use arriveRequestDescriptor instead')
const ArriveRequest$json = {
  '1': 'ArriveRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'arrival_mode',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.ArrivalMode',
      '10': 'arrivalMode'
    },
    {'1': 'chief_complaint', '3': 5, '4': 1, '5': 9, '10': 'chiefComplaint'},
    {
      '1': 'arrived_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'arrivedAt'
    },
    {'1': 'unidentified', '3': 7, '4': 1, '5': 8, '10': 'unidentified'},
    {'1': 'temporary_name', '3': 8, '4': 1, '5': 9, '10': 'temporaryName'},
    {'1': 'medico_legal', '3': 9, '4': 1, '5': 8, '10': 'medicoLegal'},
    {'1': 'medico_legal_ref', '3': 10, '4': 1, '5': 9, '10': 'medicoLegalRef'},
    {'1': 'location', '3': 11, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `ArriveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arriveRequestDescriptor = $convert.base64Decode(
    'Cg1BcnJpdmVSZXF1ZXN0EiEKDGVuY291bnRlcl9pZBgBIAEoCVILZW5jb3VudGVySWQSHQoKcG'
    'F0aWVudF9pZBgCIAEoCVIJcGF0aWVudElkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpmYWNpbGl0'
    'eUlkEkcKDGFycml2YWxfbW9kZRgEIAEoDjIkLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkFycm'
    'l2YWxNb2RlUgthcnJpdmFsTW9kZRInCg9jaGllZl9jb21wbGFpbnQYBSABKAlSDmNoaWVmQ29t'
    'cGxhaW50EjkKCmFycml2ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    'lhcnJpdmVkQXQSIgoMdW5pZGVudGlmaWVkGAcgASgIUgx1bmlkZW50aWZpZWQSJQoOdGVtcG9y'
    'YXJ5X25hbWUYCCABKAlSDXRlbXBvcmFyeU5hbWUSIQoMbWVkaWNvX2xlZ2FsGAkgASgIUgttZW'
    'RpY29MZWdhbBIoChBtZWRpY29fbGVnYWxfcmVmGAogASgJUg5tZWRpY29MZWdhbFJlZhIaCghs'
    'b2NhdGlvbhgLIAEoCVIIbG9jYXRpb24=');

@$core.Deprecated('Use arriveResponseDescriptor instead')
const ArriveResponse$json = {
  '1': 'ArriveResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyVisit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `ArriveResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arriveResponseDescriptor = $convert.base64Decode(
    'Cg5BcnJpdmVSZXNwb25zZRI9CgV2aXNpdBgBIAEoCzInLmhlYWx0aGNhcmUuZW1lcmdlbmN5Ln'
    'YxLkVtZXJnZW5jeVZpc2l0UgV2aXNpdA==');

@$core.Deprecated('Use getEmergencyVisitRequestDescriptor instead')
const GetEmergencyVisitRequest$json = {
  '1': 'GetEmergencyVisitRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
  ],
};

/// Descriptor for `GetEmergencyVisitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmergencyVisitRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRFbWVyZ2VuY3lWaXNpdFJlcXVlc3QSGQoIdmlzaXRfaWQYASABKAlSB3Zpc2l0SWQ=');

@$core.Deprecated('Use getEmergencyVisitResponseDescriptor instead')
const GetEmergencyVisitResponse$json = {
  '1': 'GetEmergencyVisitResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyVisit',
      '10': 'visit'
    },
    {
      '1': 'triage',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.Triage',
      '10': 'triage'
    },
    {
      '1': 'pathways',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.Pathway',
      '10': 'pathways'
    },
    {
      '1': 'progress',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.GetEmergencyVisitResponse.ProgressEntry',
      '10': 'progress'
    },
    {
      '1': 'timeline',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyEvent',
      '10': 'timeline'
    },
    {
      '1': 'intervals',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.Intervals',
      '10': 'intervals'
    },
  ],
  '3': [GetEmergencyVisitResponse_ProgressEntry$json],
};

@$core.Deprecated('Use getEmergencyVisitResponseDescriptor instead')
const GetEmergencyVisitResponse_ProgressEntry$json = {
  '1': 'ProgressEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {
      '1': 'value',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.MilestoneProgress',
      '10': 'value'
    },
  ],
  '7': {'7': true},
};

/// Descriptor for `GetEmergencyVisitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEmergencyVisitResponseDescriptor = $convert.base64Decode(
    'ChlHZXRFbWVyZ2VuY3lWaXNpdFJlc3BvbnNlEj0KBXZpc2l0GAEgASgLMicuaGVhbHRoY2FyZS'
    '5lbWVyZ2VuY3kudjEuRW1lcmdlbmN5VmlzaXRSBXZpc2l0EjcKBnRyaWFnZRgCIAMoCzIfLmhl'
    'YWx0aGNhcmUuZW1lcmdlbmN5LnYxLlRyaWFnZVIGdHJpYWdlEjwKCHBhdGh3YXlzGAMgAygLMi'
    'AuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUGF0aHdheVIIcGF0aHdheXMSXAoIcHJvZ3Jlc3MY'
    'BCADKAsyQC5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5HZXRFbWVyZ2VuY3lWaXNpdFJlc3Bvbn'
    'NlLlByb2dyZXNzRW50cnlSCHByb2dyZXNzEkMKCHRpbWVsaW5lGAUgAygLMicuaGVhbHRoY2Fy'
    'ZS5lbWVyZ2VuY3kudjEuRW1lcmdlbmN5RXZlbnRSCHRpbWVsaW5lEkAKCWludGVydmFscxgGIA'
    'EoCzIiLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkludGVydmFsc1IJaW50ZXJ2YWxzGmcKDVBy'
    'b2dyZXNzRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSQAoFdmFsdWUYAiABKAsyKi5oZWFsdGhjYX'
    'JlLmVtZXJnZW5jeS52MS5NaWxlc3RvbmVQcm9ncmVzc1IFdmFsdWU6AjgB');

@$core.Deprecated('Use milestoneProgressDescriptor instead')
const MilestoneProgress$json = {
  '1': 'MilestoneProgress',
  '2': [
    {
      '1': 'states',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.MilestoneState',
      '10': 'states'
    },
  ],
};

/// Descriptor for `MilestoneProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List milestoneProgressDescriptor = $convert.base64Decode(
    'ChFNaWxlc3RvbmVQcm9ncmVzcxI/CgZzdGF0ZXMYASADKAsyJy5oZWFsdGhjYXJlLmVtZXJnZW'
    '5jeS52MS5NaWxlc3RvbmVTdGF0ZVIGc3RhdGVz');

@$core.Deprecated('Use identifyPatientRequestDescriptor instead')
const IdentifyPatientRequest$json = {
  '1': 'IdentifyPatientRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
  ],
};

/// Descriptor for `IdentifyPatientRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyPatientRequestDescriptor =
    $convert.base64Decode(
        'ChZJZGVudGlmeVBhdGllbnRSZXF1ZXN0EhkKCHZpc2l0X2lkGAEgASgJUgd2aXNpdElkEh0KCn'
        'BhdGllbnRfaWQYAiABKAlSCXBhdGllbnRJZA==');

@$core.Deprecated('Use identifyPatientResponseDescriptor instead')
const IdentifyPatientResponse$json = {
  '1': 'IdentifyPatientResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyVisit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `IdentifyPatientResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List identifyPatientResponseDescriptor =
    $convert.base64Decode(
        'ChdJZGVudGlmeVBhdGllbnRSZXNwb25zZRI9CgV2aXNpdBgBIAEoCzInLmhlYWx0aGNhcmUuZW'
        '1lcmdlbmN5LnYxLkVtZXJnZW5jeVZpc2l0UgV2aXNpdA==');

@$core.Deprecated('Use assignTriageRequestDescriptor instead')
const AssignTriageRequest$json = {
  '1': 'AssignTriageRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'acuity_code', '3': 2, '4': 1, '5': 9, '10': 'acuityCode'},
    {
      '1': 'respiratory_rate',
      '3': 3,
      '4': 1,
      '5': 5,
      '9': 0,
      '10': 'respiratoryRate',
      '17': true
    },
    {
      '1': 'heart_rate',
      '3': 4,
      '4': 1,
      '5': 5,
      '9': 1,
      '10': 'heartRate',
      '17': true
    },
    {
      '1': 'systolic_bp',
      '3': 5,
      '4': 1,
      '5': 5,
      '9': 2,
      '10': 'systolicBp',
      '17': true
    },
    {
      '1': 'oxygen_saturation',
      '3': 6,
      '4': 1,
      '5': 5,
      '9': 3,
      '10': 'oxygenSaturation',
      '17': true
    },
    {
      '1': 'temperature',
      '3': 7,
      '4': 1,
      '5': 1,
      '9': 4,
      '10': 'temperature',
      '17': true
    },
    {
      '1': 'pain_score',
      '3': 8,
      '4': 1,
      '5': 5,
      '9': 5,
      '10': 'painScore',
      '17': true
    },
    {'1': 'consciousness', '3': 9, '4': 1, '5': 9, '10': 'consciousness'},
    {'1': 'red_flags', '3': 10, '4': 3, '5': 9, '10': 'redFlags'},
    {'1': 'note', '3': 11, '4': 1, '5': 9, '10': 'note'},
  ],
  '8': [
    {'1': '_respiratory_rate'},
    {'1': '_heart_rate'},
    {'1': '_systolic_bp'},
    {'1': '_oxygen_saturation'},
    {'1': '_temperature'},
    {'1': '_pain_score'},
  ],
};

/// Descriptor for `AssignTriageRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignTriageRequestDescriptor = $convert.base64Decode(
    'ChNBc3NpZ25UcmlhZ2VSZXF1ZXN0EhkKCHZpc2l0X2lkGAEgASgJUgd2aXNpdElkEh8KC2FjdW'
    'l0eV9jb2RlGAIgASgJUgphY3VpdHlDb2RlEi4KEHJlc3BpcmF0b3J5X3JhdGUYAyABKAVIAFIP'
    'cmVzcGlyYXRvcnlSYXRliAEBEiIKCmhlYXJ0X3JhdGUYBCABKAVIAVIJaGVhcnRSYXRliAEBEi'
    'QKC3N5c3RvbGljX2JwGAUgASgFSAJSCnN5c3RvbGljQnCIAQESMAoRb3h5Z2VuX3NhdHVyYXRp'
    'b24YBiABKAVIA1IQb3h5Z2VuU2F0dXJhdGlvbogBARIlCgt0ZW1wZXJhdHVyZRgHIAEoAUgEUg'
    't0ZW1wZXJhdHVyZYgBARIiCgpwYWluX3Njb3JlGAggASgFSAVSCXBhaW5TY29yZYgBARIkCg1j'
    'b25zY2lvdXNuZXNzGAkgASgJUg1jb25zY2lvdXNuZXNzEhsKCXJlZF9mbGFncxgKIAMoCVIIcm'
    'VkRmxhZ3MSEgoEbm90ZRgLIAEoCVIEbm90ZUITChFfcmVzcGlyYXRvcnlfcmF0ZUINCgtfaGVh'
    'cnRfcmF0ZUIOCgxfc3lzdG9saWNfYnBCFAoSX294eWdlbl9zYXR1cmF0aW9uQg4KDF90ZW1wZX'
    'JhdHVyZUINCgtfcGFpbl9zY29yZQ==');

@$core.Deprecated('Use assignTriageResponseDescriptor instead')
const AssignTriageResponse$json = {
  '1': 'AssignTriageResponse',
  '2': [
    {
      '1': 'triage',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.Triage',
      '10': 'triage'
    },
  ],
};

/// Descriptor for `AssignTriageResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignTriageResponseDescriptor = $convert.base64Decode(
    'ChRBc3NpZ25UcmlhZ2VSZXNwb25zZRI3CgZ0cmlhZ2UYASABKAsyHy5oZWFsdGhjYXJlLmVtZX'
    'JnZW5jeS52MS5UcmlhZ2VSBnRyaWFnZQ==');

@$core.Deprecated('Use overridePriorityRequestDescriptor instead')
const OverridePriorityRequest$json = {
  '1': 'OverridePriorityRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {'1': 'acuity_rank', '3': 2, '4': 1, '5': 5, '10': 'acuityRank'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OverridePriorityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overridePriorityRequestDescriptor = $convert.base64Decode(
    'ChdPdmVycmlkZVByaW9yaXR5UmVxdWVzdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBIfCg'
    'thY3VpdHlfcmFuaxgCIAEoBVIKYWN1aXR5UmFuaxIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use overridePriorityResponseDescriptor instead')
const OverridePriorityResponse$json = {
  '1': 'OverridePriorityResponse',
};

/// Descriptor for `OverridePriorityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overridePriorityResponseDescriptor =
    $convert.base64Decode('ChhPdmVycmlkZVByaW9yaXR5UmVzcG9uc2U=');

@$core.Deprecated('Use activatePathwayRequestDescriptor instead')
const ActivatePathwayRequest$json = {
  '1': 'ActivatePathwayRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.PathwayKind',
      '10': 'kind'
    },
    {'1': 'label', '3': 3, '4': 1, '5': 9, '10': 'label'},
    {'1': 'notified_team', '3': 4, '4': 1, '5': 9, '10': 'notifiedTeam'},
  ],
};

/// Descriptor for `ActivatePathwayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activatePathwayRequestDescriptor = $convert.base64Decode(
    'ChZBY3RpdmF0ZVBhdGh3YXlSZXF1ZXN0EhkKCHZpc2l0X2lkGAEgASgJUgd2aXNpdElkEjgKBG'
    'tpbmQYAiABKA4yJC5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5QYXRod2F5S2luZFIEa2luZBIU'
    'CgVsYWJlbBgDIAEoCVIFbGFiZWwSIwoNbm90aWZpZWRfdGVhbRgEIAEoCVIMbm90aWZpZWRUZW'
    'Ft');

@$core.Deprecated('Use activatePathwayResponseDescriptor instead')
const ActivatePathwayResponse$json = {
  '1': 'ActivatePathwayResponse',
  '2': [
    {
      '1': 'pathway',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.Pathway',
      '10': 'pathway'
    },
  ],
};

/// Descriptor for `ActivatePathwayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List activatePathwayResponseDescriptor =
    $convert.base64Decode(
        'ChdBY3RpdmF0ZVBhdGh3YXlSZXNwb25zZRI6CgdwYXRod2F5GAEgASgLMiAuaGVhbHRoY2FyZS'
        '5lbWVyZ2VuY3kudjEuUGF0aHdheVIHcGF0aHdheQ==');

@$core.Deprecated('Use standDownPathwayRequestDescriptor instead')
const StandDownPathwayRequest$json = {
  '1': 'StandDownPathwayRequest',
  '2': [
    {'1': 'pathway_id', '3': 1, '4': 1, '5': 9, '10': 'pathwayId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `StandDownPathwayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List standDownPathwayRequestDescriptor =
    $convert.base64Decode(
        'ChdTdGFuZERvd25QYXRod2F5UmVxdWVzdBIdCgpwYXRod2F5X2lkGAEgASgJUglwYXRod2F5SW'
        'QSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use standDownPathwayResponseDescriptor instead')
const StandDownPathwayResponse$json = {
  '1': 'StandDownPathwayResponse',
};

/// Descriptor for `StandDownPathwayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List standDownPathwayResponseDescriptor =
    $convert.base64Decode('ChhTdGFuZERvd25QYXRod2F5UmVzcG9uc2U=');

@$core.Deprecated('Use recordEmergencyEventRequestDescriptor instead')
const RecordEmergencyEventRequest$json = {
  '1': 'RecordEmergencyEventRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.EventKind',
      '10': 'kind'
    },
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'occurred_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'occurredAt'
    },
    {'1': 'sequence', '3': 5, '4': 1, '5': 5, '10': 'sequence'},
    {'1': 'pathway_id', '3': 6, '4': 1, '5': 9, '10': 'pathwayId'},
    {'1': 'protocol_id', '3': 7, '4': 1, '5': 9, '10': 'protocolId'},
    {'1': 'pre_order', '3': 8, '4': 1, '5': 8, '10': 'preOrder'},
  ],
};

/// Descriptor for `RecordEmergencyEventRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEmergencyEventRequestDescriptor = $convert.base64Decode(
    'ChtSZWNvcmRFbWVyZ2VuY3lFdmVudFJlcXVlc3QSGQoIdmlzaXRfaWQYASABKAlSB3Zpc2l0SW'
    'QSNgoEa2luZBgCIAEoDjIiLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkV2ZW50S2luZFIEa2lu'
    'ZBIWCgZkZXRhaWwYAyABKAlSBmRldGFpbBI7CgtvY2N1cnJlZF9hdBgEIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQSGgoIc2VxdWVuY2UYBSABKAVSCHNlcXVl'
    'bmNlEh0KCnBhdGh3YXlfaWQYBiABKAlSCXBhdGh3YXlJZBIfCgtwcm90b2NvbF9pZBgHIAEoCV'
    'IKcHJvdG9jb2xJZBIbCglwcmVfb3JkZXIYCCABKAhSCHByZU9yZGVy');

@$core.Deprecated('Use recordEmergencyEventResponseDescriptor instead')
const RecordEmergencyEventResponse$json = {
  '1': 'RecordEmergencyEventResponse',
  '2': [
    {
      '1': 'event',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyEvent',
      '10': 'event'
    },
  ],
};

/// Descriptor for `RecordEmergencyEventResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordEmergencyEventResponseDescriptor =
    $convert.base64Decode(
        'ChxSZWNvcmRFbWVyZ2VuY3lFdmVudFJlc3BvbnNlEj0KBWV2ZW50GAEgASgLMicuaGVhbHRoY2'
        'FyZS5lbWVyZ2VuY3kudjEuRW1lcmdlbmN5RXZlbnRSBWV2ZW50');

@$core.Deprecated('Use getTimelineRequestDescriptor instead')
const GetTimelineRequest$json = {
  '1': 'GetTimelineRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
  ],
};

/// Descriptor for `GetTimelineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXRUaW1lbGluZVJlcXVlc3QSGQoIdmlzaXRfaWQYASABKAlSB3Zpc2l0SWQ=');

@$core.Deprecated('Use getTimelineResponseDescriptor instead')
const GetTimelineResponse$json = {
  '1': 'GetTimelineResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyEvent',
      '10': 'events'
    },
    {
      '1': 'intervals',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.Intervals',
      '10': 'intervals'
    },
  ],
};

/// Descriptor for `GetTimelineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTimelineResponseDescriptor = $convert.base64Decode(
    'ChNHZXRUaW1lbGluZVJlc3BvbnNlEj8KBmV2ZW50cxgBIAMoCzInLmhlYWx0aGNhcmUuZW1lcm'
    'dlbmN5LnYxLkVtZXJnZW5jeUV2ZW50UgZldmVudHMSQAoJaW50ZXJ2YWxzGAIgASgLMiIuaGVh'
    'bHRoY2FyZS5lbWVyZ2VuY3kudjEuSW50ZXJ2YWxzUglpbnRlcnZhbHM=');

@$core.Deprecated('Use reconcileAdministrationRequestDescriptor instead')
const ReconcileAdministrationRequest$json = {
  '1': 'ReconcileAdministrationRequest',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
  ],
};

/// Descriptor for `ReconcileAdministrationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileAdministrationRequestDescriptor =
    $convert.base64Decode(
        'Ch5SZWNvbmNpbGVBZG1pbmlzdHJhdGlvblJlcXVlc3QSGQoIZXZlbnRfaWQYASABKAlSB2V2ZW'
        '50SWQSGQoIb3JkZXJfaWQYAiABKAlSB29yZGVySWQ=');

@$core.Deprecated('Use reconcileAdministrationResponseDescriptor instead')
const ReconcileAdministrationResponse$json = {
  '1': 'ReconcileAdministrationResponse',
};

/// Descriptor for `ReconcileAdministrationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconcileAdministrationResponseDescriptor =
    $convert.base64Decode('Ch9SZWNvbmNpbGVBZG1pbmlzdHJhdGlvblJlc3BvbnNl');

@$core.Deprecated('Use listUnreconciledRequestDescriptor instead')
const ListUnreconciledRequest$json = {
  '1': 'ListUnreconciledRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListUnreconciledRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUnreconciledRequestDescriptor =
    $convert.base64Decode(
        'ChdMaXN0VW5yZWNvbmNpbGVkUmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaWxpdH'
        'lJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listUnreconciledResponseDescriptor instead')
const ListUnreconciledResponse$json = {
  '1': 'ListUnreconciledResponse',
  '2': [
    {
      '1': 'events',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyEvent',
      '10': 'events'
    },
  ],
};

/// Descriptor for `ListUnreconciledResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listUnreconciledResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0VW5yZWNvbmNpbGVkUmVzcG9uc2USPwoGZXZlbnRzGAEgAygLMicuaGVhbHRoY2FyZS'
        '5lbWVyZ2VuY3kudjEuRW1lcmdlbmN5RXZlbnRSBmV2ZW50cw==');

@$core.Deprecated('Use startObservationRequestDescriptor instead')
const StartObservationRequest$json = {
  '1': 'StartObservationRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'review_at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'reviewAt'
    },
    {'1': 'location', '3': 3, '4': 1, '5': 9, '10': 'location'},
  ],
};

/// Descriptor for `StartObservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startObservationRequestDescriptor = $convert.base64Decode(
    'ChdTdGFydE9ic2VydmF0aW9uUmVxdWVzdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBI3Cg'
    'lyZXZpZXdfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghyZXZpZXdBdBIa'
    'Cghsb2NhdGlvbhgDIAEoCVIIbG9jYXRpb24=');

@$core.Deprecated('Use startObservationResponseDescriptor instead')
const StartObservationResponse$json = {
  '1': 'StartObservationResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyVisit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `StartObservationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startObservationResponseDescriptor =
    $convert.base64Decode(
        'ChhTdGFydE9ic2VydmF0aW9uUmVzcG9uc2USPQoFdmlzaXQYASABKAsyJy5oZWFsdGhjYXJlLm'
        'VtZXJnZW5jeS52MS5FbWVyZ2VuY3lWaXNpdFIFdmlzaXQ=');

@$core.Deprecated('Use disposeRequestDescriptor instead')
const DisposeRequest$json = {
  '1': 'DisposeRequest',
  '2': [
    {'1': 'visit_id', '3': 1, '4': 1, '5': 9, '10': 'visitId'},
    {
      '1': 'disposition',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.emergency.v1.Disposition',
      '10': 'disposition'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {
      '1': 'receiving_service',
      '3': 4,
      '4': 1,
      '5': 9,
      '10': 'receivingService'
    },
    {'1': 'summary_signed', '3': 5, '4': 1, '5': 8, '10': 'summarySigned'},
  ],
};

/// Descriptor for `DisposeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disposeRequestDescriptor = $convert.base64Decode(
    'Cg5EaXNwb3NlUmVxdWVzdBIZCgh2aXNpdF9pZBgBIAEoCVIHdmlzaXRJZBJGCgtkaXNwb3NpdG'
    'lvbhgCIAEoDjIkLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkRpc3Bvc2l0aW9uUgtkaXNwb3Np'
    'dGlvbhISCgRub3RlGAMgASgJUgRub3RlEisKEXJlY2VpdmluZ19zZXJ2aWNlGAQgASgJUhByZW'
    'NlaXZpbmdTZXJ2aWNlEiUKDnN1bW1hcnlfc2lnbmVkGAUgASgIUg1zdW1tYXJ5U2lnbmVk');

@$core.Deprecated('Use disposeResponseDescriptor instead')
const DisposeResponse$json = {
  '1': 'DisposeResponse',
  '2': [
    {
      '1': 'visit',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.emergency.v1.EmergencyVisit',
      '10': 'visit'
    },
  ],
};

/// Descriptor for `DisposeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disposeResponseDescriptor = $convert.base64Decode(
    'Cg9EaXNwb3NlUmVzcG9uc2USPQoFdmlzaXQYASABKAsyJy5oZWFsdGhjYXJlLmVtZXJnZW5jeS'
    '52MS5FbWVyZ2VuY3lWaXNpdFIFdmlzaXQ=');

@$core.Deprecated('Use getBoardRequestDescriptor instead')
const GetBoardRequest$json = {
  '1': 'GetBoardRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetBoardRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRCb2FyZFJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSGwoJcG'
    'FnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use getBoardResponseDescriptor instead')
const GetBoardResponse$json = {
  '1': 'GetBoardResponse',
  '2': [
    {
      '1': 'rows',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.emergency.v1.BoardRow',
      '10': 'rows'
    },
    {'1': 'restricted', '3': 2, '4': 1, '5': 5, '10': 'restricted'},
  ],
};

/// Descriptor for `GetBoardResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBoardResponseDescriptor = $convert.base64Decode(
    'ChBHZXRCb2FyZFJlc3BvbnNlEjUKBHJvd3MYASADKAsyIS5oZWFsdGhjYXJlLmVtZXJnZW5jeS'
    '52MS5Cb2FyZFJvd1IEcm93cxIeCgpyZXN0cmljdGVkGAIgASgFUgpyZXN0cmljdGVk');

const $core.Map<$core.String, $core.dynamic> EmergencyServiceBase$json = {
  '1': 'EmergencyService',
  '2': [
    {
      '1': 'Arrive',
      '2': '.healthcare.emergency.v1.ArriveRequest',
      '3': '.healthcare.emergency.v1.ArriveResponse'
    },
    {
      '1': 'GetEmergencyVisit',
      '2': '.healthcare.emergency.v1.GetEmergencyVisitRequest',
      '3': '.healthcare.emergency.v1.GetEmergencyVisitResponse'
    },
    {
      '1': 'IdentifyPatient',
      '2': '.healthcare.emergency.v1.IdentifyPatientRequest',
      '3': '.healthcare.emergency.v1.IdentifyPatientResponse'
    },
    {
      '1': 'AssignTriage',
      '2': '.healthcare.emergency.v1.AssignTriageRequest',
      '3': '.healthcare.emergency.v1.AssignTriageResponse'
    },
    {
      '1': 'OverridePriority',
      '2': '.healthcare.emergency.v1.OverridePriorityRequest',
      '3': '.healthcare.emergency.v1.OverridePriorityResponse'
    },
    {
      '1': 'GetBoard',
      '2': '.healthcare.emergency.v1.GetBoardRequest',
      '3': '.healthcare.emergency.v1.GetBoardResponse'
    },
    {
      '1': 'ActivatePathway',
      '2': '.healthcare.emergency.v1.ActivatePathwayRequest',
      '3': '.healthcare.emergency.v1.ActivatePathwayResponse'
    },
    {
      '1': 'StandDownPathway',
      '2': '.healthcare.emergency.v1.StandDownPathwayRequest',
      '3': '.healthcare.emergency.v1.StandDownPathwayResponse'
    },
    {
      '1': 'RecordEmergencyEvent',
      '2': '.healthcare.emergency.v1.RecordEmergencyEventRequest',
      '3': '.healthcare.emergency.v1.RecordEmergencyEventResponse'
    },
    {
      '1': 'GetTimeline',
      '2': '.healthcare.emergency.v1.GetTimelineRequest',
      '3': '.healthcare.emergency.v1.GetTimelineResponse'
    },
    {
      '1': 'ReconcileAdministration',
      '2': '.healthcare.emergency.v1.ReconcileAdministrationRequest',
      '3': '.healthcare.emergency.v1.ReconcileAdministrationResponse'
    },
    {
      '1': 'ListUnreconciled',
      '2': '.healthcare.emergency.v1.ListUnreconciledRequest',
      '3': '.healthcare.emergency.v1.ListUnreconciledResponse'
    },
    {
      '1': 'StartObservation',
      '2': '.healthcare.emergency.v1.StartObservationRequest',
      '3': '.healthcare.emergency.v1.StartObservationResponse'
    },
    {
      '1': 'Dispose',
      '2': '.healthcare.emergency.v1.DisposeRequest',
      '3': '.healthcare.emergency.v1.DisposeResponse'
    },
  ],
};

@$core.Deprecated('Use emergencyServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    EmergencyServiceBase$messageJson = {
  '.healthcare.emergency.v1.ArriveRequest': ArriveRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.emergency.v1.ArriveResponse': ArriveResponse$json,
  '.healthcare.emergency.v1.EmergencyVisit': EmergencyVisit$json,
  '.healthcare.emergency.v1.GetEmergencyVisitRequest':
      GetEmergencyVisitRequest$json,
  '.healthcare.emergency.v1.GetEmergencyVisitResponse':
      GetEmergencyVisitResponse$json,
  '.healthcare.emergency.v1.Triage': Triage$json,
  '.healthcare.emergency.v1.Pathway': Pathway$json,
  '.healthcare.emergency.v1.MilestoneTarget': MilestoneTarget$json,
  '.healthcare.emergency.v1.GetEmergencyVisitResponse.ProgressEntry':
      GetEmergencyVisitResponse_ProgressEntry$json,
  '.healthcare.emergency.v1.MilestoneProgress': MilestoneProgress$json,
  '.healthcare.emergency.v1.MilestoneState': MilestoneState$json,
  '.healthcare.emergency.v1.EmergencyEvent': EmergencyEvent$json,
  '.healthcare.emergency.v1.Intervals': Intervals$json,
  '.healthcare.emergency.v1.IdentifyPatientRequest':
      IdentifyPatientRequest$json,
  '.healthcare.emergency.v1.IdentifyPatientResponse':
      IdentifyPatientResponse$json,
  '.healthcare.emergency.v1.AssignTriageRequest': AssignTriageRequest$json,
  '.healthcare.emergency.v1.AssignTriageResponse': AssignTriageResponse$json,
  '.healthcare.emergency.v1.OverridePriorityRequest':
      OverridePriorityRequest$json,
  '.healthcare.emergency.v1.OverridePriorityResponse':
      OverridePriorityResponse$json,
  '.healthcare.emergency.v1.GetBoardRequest': GetBoardRequest$json,
  '.healthcare.emergency.v1.GetBoardResponse': GetBoardResponse$json,
  '.healthcare.emergency.v1.BoardRow': BoardRow$json,
  '.healthcare.emergency.v1.PriorityOverride': PriorityOverride$json,
  '.healthcare.emergency.v1.ActivatePathwayRequest':
      ActivatePathwayRequest$json,
  '.healthcare.emergency.v1.ActivatePathwayResponse':
      ActivatePathwayResponse$json,
  '.healthcare.emergency.v1.StandDownPathwayRequest':
      StandDownPathwayRequest$json,
  '.healthcare.emergency.v1.StandDownPathwayResponse':
      StandDownPathwayResponse$json,
  '.healthcare.emergency.v1.RecordEmergencyEventRequest':
      RecordEmergencyEventRequest$json,
  '.healthcare.emergency.v1.RecordEmergencyEventResponse':
      RecordEmergencyEventResponse$json,
  '.healthcare.emergency.v1.GetTimelineRequest': GetTimelineRequest$json,
  '.healthcare.emergency.v1.GetTimelineResponse': GetTimelineResponse$json,
  '.healthcare.emergency.v1.ReconcileAdministrationRequest':
      ReconcileAdministrationRequest$json,
  '.healthcare.emergency.v1.ReconcileAdministrationResponse':
      ReconcileAdministrationResponse$json,
  '.healthcare.emergency.v1.ListUnreconciledRequest':
      ListUnreconciledRequest$json,
  '.healthcare.emergency.v1.ListUnreconciledResponse':
      ListUnreconciledResponse$json,
  '.healthcare.emergency.v1.StartObservationRequest':
      StartObservationRequest$json,
  '.healthcare.emergency.v1.StartObservationResponse':
      StartObservationResponse$json,
  '.healthcare.emergency.v1.DisposeRequest': DisposeRequest$json,
  '.healthcare.emergency.v1.DisposeResponse': DisposeResponse$json,
};

/// Descriptor for `EmergencyService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List emergencyServiceDescriptor = $convert.base64Decode(
    'ChBFbWVyZ2VuY3lTZXJ2aWNlElkKBkFycml2ZRImLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLk'
    'Fycml2ZVJlcXVlc3QaJy5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5BcnJpdmVSZXNwb25zZRJ6'
    'ChFHZXRFbWVyZ2VuY3lWaXNpdBIxLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkdldEVtZXJnZW'
    '5jeVZpc2l0UmVxdWVzdBoyLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkdldEVtZXJnZW5jeVZp'
    'c2l0UmVzcG9uc2USdAoPSWRlbnRpZnlQYXRpZW50Ei8uaGVhbHRoY2FyZS5lbWVyZ2VuY3kudj'
    'EuSWRlbnRpZnlQYXRpZW50UmVxdWVzdBowLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLklkZW50'
    'aWZ5UGF0aWVudFJlc3BvbnNlEmsKDEFzc2lnblRyaWFnZRIsLmhlYWx0aGNhcmUuZW1lcmdlbm'
    'N5LnYxLkFzc2lnblRyaWFnZVJlcXVlc3QaLS5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5Bc3Np'
    'Z25UcmlhZ2VSZXNwb25zZRJ3ChBPdmVycmlkZVByaW9yaXR5EjAuaGVhbHRoY2FyZS5lbWVyZ2'
    'VuY3kudjEuT3ZlcnJpZGVQcmlvcml0eVJlcXVlc3QaMS5oZWFsdGhjYXJlLmVtZXJnZW5jeS52'
    'MS5PdmVycmlkZVByaW9yaXR5UmVzcG9uc2USXwoIR2V0Qm9hcmQSKC5oZWFsdGhjYXJlLmVtZX'
    'JnZW5jeS52MS5HZXRCb2FyZFJlcXVlc3QaKS5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5HZXRC'
    'b2FyZFJlc3BvbnNlEnQKD0FjdGl2YXRlUGF0aHdheRIvLmhlYWx0aGNhcmUuZW1lcmdlbmN5Ln'
    'YxLkFjdGl2YXRlUGF0aHdheVJlcXVlc3QaMC5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5BY3Rp'
    'dmF0ZVBhdGh3YXlSZXNwb25zZRJ3ChBTdGFuZERvd25QYXRod2F5EjAuaGVhbHRoY2FyZS5lbW'
    'VyZ2VuY3kudjEuU3RhbmREb3duUGF0aHdheVJlcXVlc3QaMS5oZWFsdGhjYXJlLmVtZXJnZW5j'
    'eS52MS5TdGFuZERvd25QYXRod2F5UmVzcG9uc2USgwEKFFJlY29yZEVtZXJnZW5jeUV2ZW50Ej'
    'QuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUmVjb3JkRW1lcmdlbmN5RXZlbnRSZXF1ZXN0GjUu'
    'aGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUmVjb3JkRW1lcmdlbmN5RXZlbnRSZXNwb25zZRJoCg'
    'tHZXRUaW1lbGluZRIrLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkdldFRpbWVsaW5lUmVxdWVz'
    'dBosLmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLkdldFRpbWVsaW5lUmVzcG9uc2USjAEKF1JlY2'
    '9uY2lsZUFkbWluaXN0cmF0aW9uEjcuaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUmVjb25jaWxl'
    'QWRtaW5pc3RyYXRpb25SZXF1ZXN0GjguaGVhbHRoY2FyZS5lbWVyZ2VuY3kudjEuUmVjb25jaW'
    'xlQWRtaW5pc3RyYXRpb25SZXNwb25zZRJ3ChBMaXN0VW5yZWNvbmNpbGVkEjAuaGVhbHRoY2Fy'
    'ZS5lbWVyZ2VuY3kudjEuTGlzdFVucmVjb25jaWxlZFJlcXVlc3QaMS5oZWFsdGhjYXJlLmVtZX'
    'JnZW5jeS52MS5MaXN0VW5yZWNvbmNpbGVkUmVzcG9uc2USdwoQU3RhcnRPYnNlcnZhdGlvbhIw'
    'LmhlYWx0aGNhcmUuZW1lcmdlbmN5LnYxLlN0YXJ0T2JzZXJ2YXRpb25SZXF1ZXN0GjEuaGVhbH'
    'RoY2FyZS5lbWVyZ2VuY3kudjEuU3RhcnRPYnNlcnZhdGlvblJlc3BvbnNlElwKB0Rpc3Bvc2US'
    'Jy5oZWFsdGhjYXJlLmVtZXJnZW5jeS52MS5EaXNwb3NlUmVxdWVzdBooLmhlYWx0aGNhcmUuZW'
    '1lcmdlbmN5LnYxLkRpc3Bvc2VSZXNwb25zZQ==');
