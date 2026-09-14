// This is a generated file - do not edit.
//
// Generated from healthcare/scheduling/v1/appointment.proto.

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

@$core.Deprecated('Use resourceTypeDescriptor instead')
const ResourceType$json = {
  '1': 'ResourceType',
  '2': [
    {'1': 'RESOURCE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'RESOURCE_TYPE_PRACTITIONER', '2': 1},
    {'1': 'RESOURCE_TYPE_ROOM', '2': 2},
    {'1': 'RESOURCE_TYPE_EQUIPMENT', '2': 3},
  ],
};

/// Descriptor for `ResourceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceTypeDescriptor = $convert.base64Decode(
    'CgxSZXNvdXJjZVR5cGUSHQoZUkVTT1VSQ0VfVFlQRV9VTlNQRUNJRklFRBAAEh4KGlJFU09VUk'
    'NFX1RZUEVfUFJBQ1RJVElPTkVSEAESFgoSUkVTT1VSQ0VfVFlQRV9ST09NEAISGwoXUkVTT1VS'
    'Q0VfVFlQRV9FUVVJUE1FTlQQAw==');

@$core.Deprecated('Use resourceStatusDescriptor instead')
const ResourceStatus$json = {
  '1': 'ResourceStatus',
  '2': [
    {'1': 'RESOURCE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'RESOURCE_STATUS_ACTIVE', '2': 1},
    {'1': 'RESOURCE_STATUS_INACTIVE', '2': 2},
  ],
};

/// Descriptor for `ResourceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List resourceStatusDescriptor = $convert.base64Decode(
    'Cg5SZXNvdXJjZVN0YXR1cxIfChtSRVNPVVJDRV9TVEFUVVNfVU5TUEVDSUZJRUQQABIaChZSRV'
    'NPVVJDRV9TVEFUVVNfQUNUSVZFEAESHAoYUkVTT1VSQ0VfU1RBVFVTX0lOQUNUSVZFEAI=');

@$core.Deprecated('Use visitTypeDescriptor instead')
const VisitType$json = {
  '1': 'VisitType',
  '2': [
    {'1': 'VISIT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'VISIT_TYPE_NEW', '2': 1},
    {'1': 'VISIT_TYPE_FOLLOW_UP', '2': 2},
    {'1': 'VISIT_TYPE_PROCEDURE', '2': 3},
    {'1': 'VISIT_TYPE_TELECONSULT', '2': 4},
    {'1': 'VISIT_TYPE_WALK_IN', '2': 5},
  ],
};

/// Descriptor for `VisitType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visitTypeDescriptor = $convert.base64Decode(
    'CglWaXNpdFR5cGUSGgoWVklTSVRfVFlQRV9VTlNQRUNJRklFRBAAEhIKDlZJU0lUX1RZUEVfTk'
    'VXEAESGAoUVklTSVRfVFlQRV9GT0xMT1dfVVAQAhIYChRWSVNJVF9UWVBFX1BST0NFRFVSRRAD'
    'EhoKFlZJU0lUX1RZUEVfVEVMRUNPTlNVTFQQBBIWChJWSVNJVF9UWVBFX1dBTEtfSU4QBQ==');

@$core.Deprecated('Use visitModeDescriptor instead')
const VisitMode$json = {
  '1': 'VisitMode',
  '2': [
    {'1': 'VISIT_MODE_UNSPECIFIED', '2': 0},
    {'1': 'VISIT_MODE_IN_PERSON', '2': 1},
    {'1': 'VISIT_MODE_TELECONSULT', '2': 2},
  ],
};

/// Descriptor for `VisitMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visitModeDescriptor = $convert.base64Decode(
    'CglWaXNpdE1vZGUSGgoWVklTSVRfTU9ERV9VTlNQRUNJRklFRBAAEhgKFFZJU0lUX01PREVfSU'
    '5fUEVSU09OEAESGgoWVklTSVRfTU9ERV9URUxFQ09OU1VMVBAC');

@$core.Deprecated('Use arrivalModeDescriptor instead')
const ArrivalMode$json = {
  '1': 'ArrivalMode',
  '2': [
    {'1': 'ARRIVAL_MODE_UNSPECIFIED', '2': 0},
    {'1': 'ARRIVAL_MODE_WALK_IN', '2': 1},
    {'1': 'ARRIVAL_MODE_SCHEDULED', '2': 2},
    {'1': 'ARRIVAL_MODE_AMBULANCE', '2': 3},
    {'1': 'ARRIVAL_MODE_REFERRAL', '2': 4},
    {'1': 'ARRIVAL_MODE_TELEHEALTH', '2': 5},
  ],
};

/// Descriptor for `ArrivalMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List arrivalModeDescriptor = $convert.base64Decode(
    'CgtBcnJpdmFsTW9kZRIcChhBUlJJVkFMX01PREVfVU5TUEVDSUZJRUQQABIYChRBUlJJVkFMX0'
    '1PREVfV0FMS19JThABEhoKFkFSUklWQUxfTU9ERV9TQ0hFRFVMRUQQAhIaChZBUlJJVkFMX01P'
    'REVfQU1CVUxBTkNFEAMSGQoVQVJSSVZBTF9NT0RFX1JFRkVSUkFMEAQSGwoXQVJSSVZBTF9NT0'
    'RFX1RFTEVIRUFMVEgQBQ==');

@$core.Deprecated('Use priorityDescriptor instead')
const Priority$json = {
  '1': 'Priority',
  '2': [
    {'1': 'PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'PRIORITY_IMMEDIATE', '2': 1},
    {'1': 'PRIORITY_VERY_URGENT', '2': 2},
    {'1': 'PRIORITY_URGENT', '2': 3},
    {'1': 'PRIORITY_STANDARD', '2': 4},
    {'1': 'PRIORITY_NON_URGENT', '2': 5},
  ],
};

/// Descriptor for `Priority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List priorityDescriptor = $convert.base64Decode(
    'CghQcmlvcml0eRIYChRQUklPUklUWV9VTlNQRUNJRklFRBAAEhYKElBSSU9SSVRZX0lNTUVESU'
    'FURRABEhgKFFBSSU9SSVRZX1ZFUllfVVJHRU5UEAISEwoPUFJJT1JJVFlfVVJHRU5UEAMSFQoR'
    'UFJJT1JJVFlfU1RBTkRBUkQQBBIXChNQUklPUklUWV9OT05fVVJHRU5UEAU=');

@$core.Deprecated('Use notificationKindDescriptor instead')
const NotificationKind$json = {
  '1': 'NotificationKind',
  '2': [
    {'1': 'NOTIFICATION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'NOTIFICATION_KIND_BOOKED', '2': 1},
    {'1': 'NOTIFICATION_KIND_REMINDER', '2': 2},
    {'1': 'NOTIFICATION_KIND_RESCHEDULED', '2': 3},
    {'1': 'NOTIFICATION_KIND_CANCELLED', '2': 4},
    {'1': 'NOTIFICATION_KIND_WAITLIST_OFFER', '2': 5},
  ],
};

/// Descriptor for `NotificationKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List notificationKindDescriptor = $convert.base64Decode(
    'ChBOb3RpZmljYXRpb25LaW5kEiEKHU5PVElGSUNBVElPTl9LSU5EX1VOU1BFQ0lGSUVEEAASHA'
    'oYTk9USUZJQ0FUSU9OX0tJTkRfQk9PS0VEEAESHgoaTk9USUZJQ0FUSU9OX0tJTkRfUkVNSU5E'
    'RVIQAhIhCh1OT1RJRklDQVRJT05fS0lORF9SRVNDSEVEVUxFRBADEh8KG05PVElGSUNBVElPTl'
    '9LSU5EX0NBTkNFTExFRBAEEiQKIE5PVElGSUNBVElPTl9LSU5EX1dBSVRMSVNUX09GRkVSEAU=');

@$core.Deprecated('Use deliveryOutcomeDescriptor instead')
const DeliveryOutcome$json = {
  '1': 'DeliveryOutcome',
  '2': [
    {'1': 'DELIVERY_OUTCOME_UNSPECIFIED', '2': 0},
    {'1': 'DELIVERY_OUTCOME_PENDING', '2': 1},
    {'1': 'DELIVERY_OUTCOME_SENT', '2': 2},
    {'1': 'DELIVERY_OUTCOME_DELIVERED', '2': 3},
    {'1': 'DELIVERY_OUTCOME_FAILED', '2': 4},
    {'1': 'DELIVERY_OUTCOME_SUPPRESSED', '2': 5},
  ],
};

/// Descriptor for `DeliveryOutcome`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List deliveryOutcomeDescriptor = $convert.base64Decode(
    'Cg9EZWxpdmVyeU91dGNvbWUSIAocREVMSVZFUllfT1VUQ09NRV9VTlNQRUNJRklFRBAAEhwKGE'
    'RFTElWRVJZX09VVENPTUVfUEVORElORxABEhkKFURFTElWRVJZX09VVENPTUVfU0VOVBACEh4K'
    'GkRFTElWRVJZX09VVENPTUVfREVMSVZFUkVEEAMSGwoXREVMSVZFUllfT1VUQ09NRV9GQUlMRU'
    'QQBBIfChtERUxJVkVSWV9PVVRDT01FX1NVUFBSRVNTRUQQBQ==');

@$core.Deprecated('Use exceptionKindDescriptor instead')
const ExceptionKind$json = {
  '1': 'ExceptionKind',
  '2': [
    {'1': 'EXCEPTION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'EXCEPTION_KIND_LEAVE', '2': 1},
    {'1': 'EXCEPTION_KIND_BLOCK', '2': 2},
    {'1': 'EXCEPTION_KIND_MEETING', '2': 3},
    {'1': 'EXCEPTION_KIND_THEATRE', '2': 4},
    {'1': 'EXCEPTION_KIND_PROCEDURE', '2': 5},
  ],
};

/// Descriptor for `ExceptionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List exceptionKindDescriptor = $convert.base64Decode(
    'Cg1FeGNlcHRpb25LaW5kEh4KGkVYQ0VQVElPTl9LSU5EX1VOU1BFQ0lGSUVEEAASGAoURVhDRV'
    'BUSU9OX0tJTkRfTEVBVkUQARIYChRFWENFUFRJT05fS0lORF9CTE9DSxACEhoKFkVYQ0VQVElP'
    'Tl9LSU5EX01FRVRJTkcQAxIaChZFWENFUFRJT05fS0lORF9USEVBVFJFEAQSHAoYRVhDRVBUSU'
    '9OX0tJTkRfUFJPQ0VEVVJFEAU=');

@$core.Deprecated('Use appointmentStatusDescriptor instead')
const AppointmentStatus$json = {
  '1': 'AppointmentStatus',
  '2': [
    {'1': 'APPOINTMENT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'APPOINTMENT_STATUS_SCHEDULED', '2': 1},
    {'1': 'APPOINTMENT_STATUS_ARRIVED', '2': 2},
    {'1': 'APPOINTMENT_STATUS_TRIAGED', '2': 3},
    {'1': 'APPOINTMENT_STATUS_WAITING_CLINICIAN', '2': 4},
    {'1': 'APPOINTMENT_STATUS_IN_CONSULTATION', '2': 5},
    {'1': 'APPOINTMENT_STATUS_POST_CONSULTATION', '2': 6},
    {'1': 'APPOINTMENT_STATUS_COMPLETED', '2': 7},
    {'1': 'APPOINTMENT_STATUS_NO_SHOW', '2': 8},
    {'1': 'APPOINTMENT_STATUS_CANCELLED', '2': 9},
  ],
};

/// Descriptor for `AppointmentStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List appointmentStatusDescriptor = $convert.base64Decode(
    'ChFBcHBvaW50bWVudFN0YXR1cxIiCh5BUFBPSU5UTUVOVF9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IgChxBUFBPSU5UTUVOVF9TVEFUVVNfU0NIRURVTEVEEAESHgoaQVBQT0lOVE1FTlRfU1RBVFVT'
    'X0FSUklWRUQQAhIeChpBUFBPSU5UTUVOVF9TVEFUVVNfVFJJQUdFRBADEigKJEFQUE9JTlRNRU'
    '5UX1NUQVRVU19XQUlUSU5HX0NMSU5JQ0lBThAEEiYKIkFQUE9JTlRNRU5UX1NUQVRVU19JTl9D'
    'T05TVUxUQVRJT04QBRIoCiRBUFBPSU5UTUVOVF9TVEFUVVNfUE9TVF9DT05TVUxUQVRJT04QBh'
    'IgChxBUFBPSU5UTUVOVF9TVEFUVVNfQ09NUExFVEVEEAcSHgoaQVBQT0lOVE1FTlRfU1RBVFVT'
    'X05PX1NIT1cQCBIgChxBUFBPSU5UTUVOVF9TVEFUVVNfQ0FOQ0VMTEVEEAk=');

@$core.Deprecated('Use seriesScopeDescriptor instead')
const SeriesScope$json = {
  '1': 'SeriesScope',
  '2': [
    {'1': 'SERIES_SCOPE_UNSPECIFIED', '2': 0},
    {'1': 'SERIES_SCOPE_THIS_OCCURRENCE', '2': 1},
    {'1': 'SERIES_SCOPE_FUTURE_OCCURRENCES', '2': 2},
  ],
};

/// Descriptor for `SeriesScope`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List seriesScopeDescriptor = $convert.base64Decode(
    'CgtTZXJpZXNTY29wZRIcChhTRVJJRVNfU0NPUEVfVU5TUEVDSUZJRUQQABIgChxTRVJJRVNfU0'
    'NPUEVfVEhJU19PQ0NVUlJFTkNFEAESIwofU0VSSUVTX1NDT1BFX0ZVVFVSRV9PQ0NVUlJFTkNF'
    'UxAC');

@$core.Deprecated('Use waitlistStatusDescriptor instead')
const WaitlistStatus$json = {
  '1': 'WaitlistStatus',
  '2': [
    {'1': 'WAITLIST_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'WAITLIST_STATUS_WAITING', '2': 1},
    {'1': 'WAITLIST_STATUS_OFFERED', '2': 2},
    {'1': 'WAITLIST_STATUS_ACCEPTED', '2': 3},
    {'1': 'WAITLIST_STATUS_DECLINED', '2': 4},
    {'1': 'WAITLIST_STATUS_EXPIRED', '2': 5},
    {'1': 'WAITLIST_STATUS_WITHDRAWN', '2': 6},
  ],
};

/// Descriptor for `WaitlistStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List waitlistStatusDescriptor = $convert.base64Decode(
    'Cg5XYWl0bGlzdFN0YXR1cxIfChtXQUlUTElTVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIbChdXQU'
    'lUTElTVF9TVEFUVVNfV0FJVElORxABEhsKF1dBSVRMSVNUX1NUQVRVU19PRkZFUkVEEAISHAoY'
    'V0FJVExJU1RfU1RBVFVTX0FDQ0VQVEVEEAMSHAoYV0FJVExJU1RfU1RBVFVTX0RFQ0xJTkVEEA'
    'QSGwoXV0FJVExJU1RfU1RBVFVTX0VYUElSRUQQBRIdChlXQUlUTElTVF9TVEFUVVNfV0lUSERS'
    'QVdOEAY=');

@$core.Deprecated('Use resourceDescriptor instead')
const Resource$json = {
  '1': 'Resource',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 3, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ResourceType',
      '10': 'type'
    },
    {'1': 'subject_id', '3': 5, '4': 1, '5': 9, '10': 'subjectId'},
    {'1': 'display_name', '3': 6, '4': 1, '5': 9, '10': 'displayName'},
    {
      '1': 'status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ResourceStatus',
      '10': 'status'
    },
    {'1': 'time_zone', '3': 8, '4': 1, '5': 9, '10': 'timeZone'},
  ],
};

/// Descriptor for `Resource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resourceDescriptor = $convert.base64Decode(
    'CghSZXNvdXJjZRIfCgtyZXNvdXJjZV9pZBgBIAEoCVIKcmVzb3VyY2VJZBIfCgtmYWNpbGl0eV'
    '9pZBgCIAEoCVIKZmFjaWxpdHlJZBIeCgtvcmdfdW5pdF9pZBgDIAEoCVIJb3JnVW5pdElkEjoK'
    'BHR5cGUYBCABKA4yJi5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuUmVzb3VyY2VUeXBlUgR0eX'
    'BlEh0KCnN1YmplY3RfaWQYBSABKAlSCXN1YmplY3RJZBIhCgxkaXNwbGF5X25hbWUYBiABKAlS'
    'C2Rpc3BsYXlOYW1lEkAKBnN0YXR1cxgHIAEoDjIoLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS'
    '5SZXNvdXJjZVN0YXR1c1IGc3RhdHVzEhsKCXRpbWVfem9uZRgIIAEoCVIIdGltZVpvbmU=');

@$core.Deprecated('Use scheduleDescriptor instead')
const Schedule$json = {
  '1': 'Schedule',
  '2': [
    {'1': 'schedule_id', '3': 1, '4': 1, '5': 9, '10': 'scheduleId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'visit_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitMode',
      '10': 'visitMode'
    },
    {'1': 'weekday', '3': 6, '4': 1, '5': 5, '10': 'weekday'},
    {'1': 'start_minute', '3': 7, '4': 1, '5': 5, '10': 'startMinute'},
    {'1': 'end_minute', '3': 8, '4': 1, '5': 5, '10': 'endMinute'},
    {'1': 'slot_minutes', '3': 9, '4': 1, '5': 5, '10': 'slotMinutes'},
    {'1': 'capacity', '3': 10, '4': 1, '5': 5, '10': 'capacity'},
    {
      '1': 'effective_from',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `Schedule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleDescriptor = $convert.base64Decode(
    'CghTY2hlZHVsZRIfCgtzY2hlZHVsZV9pZBgBIAEoCVIKc2NoZWR1bGVJZBIfCgtyZXNvdXJjZV'
    '9pZBgCIAEoCVIKcmVzb3VyY2VJZBIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFjaWxpdHlJZBJC'
    'Cgp2aXNpdF90eXBlGAQgASgOMiMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlZpc2l0VHlwZV'
    'IJdmlzaXRUeXBlEkIKCnZpc2l0X21vZGUYBSABKA4yIy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcu'
    'djEuVmlzaXRNb2RlUgl2aXNpdE1vZGUSGAoHd2Vla2RheRgGIAEoBVIHd2Vla2RheRIhCgxzdG'
    'FydF9taW51dGUYByABKAVSC3N0YXJ0TWludXRlEh0KCmVuZF9taW51dGUYCCABKAVSCWVuZE1p'
    'bnV0ZRIhCgxzbG90X21pbnV0ZXMYCSABKAVSC3Nsb3RNaW51dGVzEhoKCGNhcGFjaXR5GAogAS'
    'gFUghjYXBhY2l0eRJBCg5lZmZlY3RpdmVfZnJvbRgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSDWVmZmVjdGl2ZUZyb20SQwoPZWZmZWN0aXZlX3VudGlsGAwgASgLMhouZ29vZ2'
    'xlLnByb3RvYnVmLlRpbWVzdGFtcFIOZWZmZWN0aXZlVW50aWw=');

@$core.Deprecated('Use scheduleExceptionDescriptor instead')
const ScheduleException$json = {
  '1': 'ScheduleException',
  '2': [
    {'1': 'exception_id', '3': 1, '4': 1, '5': 9, '10': 'exceptionId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ExceptionKind',
      '10': 'kind'
    },
    {
      '1': 'starts_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'overridable', '3': 7, '4': 1, '5': 8, '10': 'overridable'},
    {'1': 'created_by', '3': 8, '4': 1, '5': 9, '10': 'createdBy'},
  ],
};

/// Descriptor for `ScheduleException`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scheduleExceptionDescriptor = $convert.base64Decode(
    'ChFTY2hlZHVsZUV4Y2VwdGlvbhIhCgxleGNlcHRpb25faWQYASABKAlSC2V4Y2VwdGlvbklkEh'
    '8KC3Jlc291cmNlX2lkGAIgASgJUgpyZXNvdXJjZUlkEjsKBGtpbmQYAyABKA4yJy5oZWFsdGhj'
    'YXJlLnNjaGVkdWxpbmcudjEuRXhjZXB0aW9uS2luZFIEa2luZBI3CglzdGFydHNfYXQYBCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBIzCgdlbmRzX2F0GAUgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIGZW5kc0F0EhYKBnJlYXNvbhgGIAEoCVIGcm'
    'Vhc29uEiAKC292ZXJyaWRhYmxlGAcgASgIUgtvdmVycmlkYWJsZRIdCgpjcmVhdGVkX2J5GAgg'
    'ASgJUgljcmVhdGVkQnk=');

@$core.Deprecated('Use slotDescriptor instead')
const Slot$json = {
  '1': 'Slot',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 3, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'visit_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitMode',
      '10': 'visitMode'
    },
    {
      '1': 'starts_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'capacity', '3': 8, '4': 1, '5': 5, '10': 'capacity'},
    {'1': 'booked', '3': 9, '4': 1, '5': 5, '10': 'booked'},
    {'1': 'remaining', '3': 10, '4': 1, '5': 5, '10': 'remaining'},
    {'1': 'blocked', '3': 11, '4': 1, '5': 8, '10': 'blocked'},
    {'1': 'blocked_reason', '3': 12, '4': 1, '5': 9, '10': 'blockedReason'},
    {
      '1': 'blocked_kind',
      '3': 13,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ExceptionKind',
      '10': 'blockedKind'
    },
  ],
};

/// Descriptor for `Slot`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List slotDescriptor = $convert.base64Decode(
    'CgRTbG90Eh8KC3Jlc291cmNlX2lkGAEgASgJUgpyZXNvdXJjZUlkEh8KC2ZhY2lsaXR5X2lkGA'
    'IgASgJUgpmYWNpbGl0eUlkEh4KC29yZ191bml0X2lkGAMgASgJUglvcmdVbml0SWQSQgoKdmlz'
    'aXRfdHlwZRgEIAEoDjIjLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5WaXNpdFR5cGVSCXZpc2'
    'l0VHlwZRJCCgp2aXNpdF9tb2RlGAUgASgOMiMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlZp'
    'c2l0TW9kZVIJdmlzaXRNb2RlEjcKCXN0YXJ0c19hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCHN0YXJ0c0F0EjMKB2VuZHNfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgZlbmRzQXQSGgoIY2FwYWNpdHkYCCABKAVSCGNhcGFjaXR5EhYKBmJvb2tlZB'
    'gJIAEoBVIGYm9va2VkEhwKCXJlbWFpbmluZxgKIAEoBVIJcmVtYWluaW5nEhgKB2Jsb2NrZWQY'
    'CyABKAhSB2Jsb2NrZWQSJQoOYmxvY2tlZF9yZWFzb24YDCABKAlSDWJsb2NrZWRSZWFzb24SSg'
    'oMYmxvY2tlZF9raW5kGA0gASgOMicuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkV4Y2VwdGlv'
    'bktpbmRSC2Jsb2NrZWRLaW5k');

@$core.Deprecated('Use statusChangeDescriptor instead')
const StatusChange$json = {
  '1': 'StatusChange',
  '2': [
    {
      '1': 'from',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.AppointmentStatus',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.AppointmentStatus',
      '10': 'to'
    },
    {
      '1': 'at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'by', '3': 4, '4': 1, '5': 9, '10': 'by'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'corrected', '3': 6, '4': 1, '5': 8, '10': 'corrected'},
  ],
};

/// Descriptor for `StatusChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusChangeDescriptor = $convert.base64Decode(
    'CgxTdGF0dXNDaGFuZ2USPwoEZnJvbRgBIAEoDjIrLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS'
    '5BcHBvaW50bWVudFN0YXR1c1IEZnJvbRI7CgJ0bxgCIAEoDjIrLmhlYWx0aGNhcmUuc2NoZWR1'
    'bGluZy52MS5BcHBvaW50bWVudFN0YXR1c1ICdG8SKgoCYXQYAyABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wUgJhdBIOCgJieRgEIAEoCVICYnkSFgoGcmVhc29uGAUgASgJUgZyZWFz'
    'b24SHAoJY29ycmVjdGVkGAYgASgIUgljb3JyZWN0ZWQ=');

@$core.Deprecated('Use appointmentDescriptor instead')
const Appointment$json = {
  '1': 'Appointment',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'resource_id', '3': 3, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'org_unit_id', '3': 4, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'patient_id', '3': 5, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'visit_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'visit_mode',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitMode',
      '10': 'visitMode'
    },
    {
      '1': 'starts_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.AppointmentStatus',
      '10': 'status'
    },
    {'1': 'booked_by', '3': 11, '4': 1, '5': 9, '10': 'bookedBy'},
    {'1': 'reason', '3': 12, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'history',
      '3': 13,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.StatusChange',
      '10': 'history'
    },
    {
      '1': 'rescheduled_from_id',
      '3': 14,
      '4': 1,
      '5': 9,
      '10': 'rescheduledFromId'
    },
    {'1': 'version', '3': 15, '4': 1, '5': 3, '10': 'version'},
    {'1': 'series_id', '3': 16, '4': 1, '5': 9, '10': 'seriesId'},
    {'1': 'occurrence', '3': 17, '4': 1, '5': 5, '10': 'occurrence'},
    {'1': 'reschedule_count', '3': 18, '4': 1, '5': 5, '10': 'rescheduleCount'},
    {'1': 'join_url', '3': 19, '4': 1, '5': 9, '10': 'joinUrl'},
    {'1': 'token', '3': 20, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'arrival_mode',
      '3': 21,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ArrivalMode',
      '10': 'arrivalMode'
    },
    {
      '1': 'checked_in_at',
      '3': 22,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'checkedInAt'
    },
    {
      '1': 'priority',
      '3': 23,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.Priority',
      '10': 'priority'
    },
    {'1': 'priority_reason', '3': 24, '4': 1, '5': 9, '10': 'priorityReason'},
  ],
};

/// Descriptor for `Appointment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appointmentDescriptor = $convert.base64Decode(
    'CgtBcHBvaW50bWVudBIlCg5hcHBvaW50bWVudF9pZBgBIAEoCVINYXBwb2ludG1lbnRJZBIfCg'
    'tmYWNpbGl0eV9pZBgCIAEoCVIKZmFjaWxpdHlJZBIfCgtyZXNvdXJjZV9pZBgDIAEoCVIKcmVz'
    'b3VyY2VJZBIeCgtvcmdfdW5pdF9pZBgEIAEoCVIJb3JnVW5pdElkEh0KCnBhdGllbnRfaWQYBS'
    'ABKAlSCXBhdGllbnRJZBJCCgp2aXNpdF90eXBlGAYgASgOMiMuaGVhbHRoY2FyZS5zY2hlZHVs'
    'aW5nLnYxLlZpc2l0VHlwZVIJdmlzaXRUeXBlEkIKCnZpc2l0X21vZGUYByABKA4yIy5oZWFsdG'
    'hjYXJlLnNjaGVkdWxpbmcudjEuVmlzaXRNb2RlUgl2aXNpdE1vZGUSNwoJc3RhcnRzX2F0GAgg'
    'ASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSMwoHZW5kc19hdBgJIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBmVuZHNBdBJDCgZzdGF0dXMYCiABKA4y'
    'Ky5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQXBwb2ludG1lbnRTdGF0dXNSBnN0YXR1cxIbCg'
    'lib29rZWRfYnkYCyABKAlSCGJvb2tlZEJ5EhYKBnJlYXNvbhgMIAEoCVIGcmVhc29uEkAKB2hp'
    'c3RvcnkYDSADKAsyJi5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuU3RhdHVzQ2hhbmdlUgdoaX'
    'N0b3J5Ei4KE3Jlc2NoZWR1bGVkX2Zyb21faWQYDiABKAlSEXJlc2NoZWR1bGVkRnJvbUlkEhgK'
    'B3ZlcnNpb24YDyABKANSB3ZlcnNpb24SGwoJc2VyaWVzX2lkGBAgASgJUghzZXJpZXNJZBIeCg'
    'pvY2N1cnJlbmNlGBEgASgFUgpvY2N1cnJlbmNlEikKEHJlc2NoZWR1bGVfY291bnQYEiABKAVS'
    'D3Jlc2NoZWR1bGVDb3VudBIZCghqb2luX3VybBgTIAEoCVIHam9pblVybBIUCgV0b2tlbhgUIA'
    'EoCVIFdG9rZW4SSAoMYXJyaXZhbF9tb2RlGBUgASgOMiUuaGVhbHRoY2FyZS5zY2hlZHVsaW5n'
    'LnYxLkFycml2YWxNb2RlUgthcnJpdmFsTW9kZRI+Cg1jaGVja2VkX2luX2F0GBYgASgLMhouZ2'
    '9vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY2hlY2tlZEluQXQSPgoIcHJpb3JpdHkYFyABKA4y'
    'Ii5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuUHJpb3JpdHlSCHByaW9yaXR5EicKD3ByaW9yaX'
    'R5X3JlYXNvbhgYIAEoCVIOcHJpb3JpdHlSZWFzb24=');

@$core.Deprecated('Use defineResourceRequestDescriptor instead')
const DefineResourceRequest$json = {
  '1': 'DefineResourceRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 2, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'type',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ResourceType',
      '10': 'type'
    },
    {'1': 'subject_id', '3': 4, '4': 1, '5': 9, '10': 'subjectId'},
    {'1': 'display_name', '3': 5, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'time_zone', '3': 6, '4': 1, '5': 9, '10': 'timeZone'},
  ],
};

/// Descriptor for `DefineResourceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineResourceRequestDescriptor = $convert.base64Decode(
    'ChVEZWZpbmVSZXNvdXJjZVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SW'
    'QSHgoLb3JnX3VuaXRfaWQYAiABKAlSCW9yZ1VuaXRJZBI6CgR0eXBlGAMgASgOMiYuaGVhbHRo'
    'Y2FyZS5zY2hlZHVsaW5nLnYxLlJlc291cmNlVHlwZVIEdHlwZRIdCgpzdWJqZWN0X2lkGAQgAS'
    'gJUglzdWJqZWN0SWQSIQoMZGlzcGxheV9uYW1lGAUgASgJUgtkaXNwbGF5TmFtZRIbCgl0aW1l'
    'X3pvbmUYBiABKAlSCHRpbWVab25l');

@$core.Deprecated('Use defineResourceResponseDescriptor instead')
const DefineResourceResponse$json = {
  '1': 'DefineResourceResponse',
  '2': [
    {
      '1': 'resource',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Resource',
      '10': 'resource'
    },
  ],
};

/// Descriptor for `DefineResourceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineResourceResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWZpbmVSZXNvdXJjZVJlc3BvbnNlEj4KCHJlc291cmNlGAEgASgLMiIuaGVhbHRoY2FyZS'
        '5zY2hlZHVsaW5nLnYxLlJlc291cmNlUghyZXNvdXJjZQ==');

@$core.Deprecated('Use setResourceStatusRequestDescriptor instead')
const SetResourceStatusRequest$json = {
  '1': 'SetResourceStatusRequest',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ResourceStatus',
      '10': 'status'
    },
  ],
};

/// Descriptor for `SetResourceStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setResourceStatusRequestDescriptor = $convert.base64Decode(
    'ChhTZXRSZXNvdXJjZVN0YXR1c1JlcXVlc3QSHwoLcmVzb3VyY2VfaWQYASABKAlSCnJlc291cm'
    'NlSWQSQAoGc3RhdHVzGAIgASgOMiguaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlJlc291cmNl'
    'U3RhdHVzUgZzdGF0dXM=');

@$core.Deprecated('Use setResourceStatusResponseDescriptor instead')
const SetResourceStatusResponse$json = {
  '1': 'SetResourceStatusResponse',
};

/// Descriptor for `SetResourceStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setResourceStatusResponseDescriptor =
    $convert.base64Decode('ChlTZXRSZXNvdXJjZVN0YXR1c1Jlc3BvbnNl');

@$core.Deprecated('Use defineScheduleRequestDescriptor instead')
const DefineScheduleRequest$json = {
  '1': 'DefineScheduleRequest',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'visit_type',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'visit_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitMode',
      '10': 'visitMode'
    },
    {'1': 'weekday', '3': 4, '4': 1, '5': 5, '10': 'weekday'},
    {'1': 'start_minute', '3': 5, '4': 1, '5': 5, '10': 'startMinute'},
    {'1': 'end_minute', '3': 6, '4': 1, '5': 5, '10': 'endMinute'},
    {'1': 'slot_minutes', '3': 7, '4': 1, '5': 5, '10': 'slotMinutes'},
    {'1': 'capacity', '3': 8, '4': 1, '5': 5, '10': 'capacity'},
    {
      '1': 'effective_from',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveFrom'
    },
    {
      '1': 'effective_until',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveUntil'
    },
  ],
};

/// Descriptor for `DefineScheduleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineScheduleRequestDescriptor = $convert.base64Decode(
    'ChVEZWZpbmVTY2hlZHVsZVJlcXVlc3QSHwoLcmVzb3VyY2VfaWQYASABKAlSCnJlc291cmNlSW'
    'QSQgoKdmlzaXRfdHlwZRgCIAEoDjIjLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5WaXNpdFR5'
    'cGVSCXZpc2l0VHlwZRJCCgp2aXNpdF9tb2RlGAMgASgOMiMuaGVhbHRoY2FyZS5zY2hlZHVsaW'
    '5nLnYxLlZpc2l0TW9kZVIJdmlzaXRNb2RlEhgKB3dlZWtkYXkYBCABKAVSB3dlZWtkYXkSIQoM'
    'c3RhcnRfbWludXRlGAUgASgFUgtzdGFydE1pbnV0ZRIdCgplbmRfbWludXRlGAYgASgFUgllbm'
    'RNaW51dGUSIQoMc2xvdF9taW51dGVzGAcgASgFUgtzbG90TWludXRlcxIaCghjYXBhY2l0eRgI'
    'IAEoBVIIY2FwYWNpdHkSQQoOZWZmZWN0aXZlX2Zyb20YCSABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUg1lZmZlY3RpdmVGcm9tEkMKD2VmZmVjdGl2ZV91bnRpbBgKIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDmVmZmVjdGl2ZVVudGls');

@$core.Deprecated('Use defineScheduleResponseDescriptor instead')
const DefineScheduleResponse$json = {
  '1': 'DefineScheduleResponse',
  '2': [
    {
      '1': 'schedule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Schedule',
      '10': 'schedule'
    },
  ],
};

/// Descriptor for `DefineScheduleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List defineScheduleResponseDescriptor =
    $convert.base64Decode(
        'ChZEZWZpbmVTY2hlZHVsZVJlc3BvbnNlEj4KCHNjaGVkdWxlGAEgASgLMiIuaGVhbHRoY2FyZS'
        '5zY2hlZHVsaW5nLnYxLlNjaGVkdWxlUghzY2hlZHVsZQ==');

@$core.Deprecated('Use blockPeriodRequestDescriptor instead')
const BlockPeriodRequest$json = {
  '1': 'BlockPeriodRequest',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ExceptionKind',
      '10': 'kind'
    },
    {
      '1': 'starts_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'overridable', '3': 6, '4': 1, '5': 8, '10': 'overridable'},
  ],
};

/// Descriptor for `BlockPeriodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockPeriodRequestDescriptor = $convert.base64Decode(
    'ChJCbG9ja1BlcmlvZFJlcXVlc3QSHwoLcmVzb3VyY2VfaWQYASABKAlSCnJlc291cmNlSWQSOw'
    'oEa2luZBgCIAEoDjInLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5FeGNlcHRpb25LaW5kUgRr'
    'aW5kEjcKCXN0YXJ0c19hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YX'
    'J0c0F0EjMKB2VuZHNfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgZlbmRz'
    'QXQSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SIAoLb3ZlcnJpZGFibGUYBiABKAhSC292ZXJyaW'
    'RhYmxl');

@$core.Deprecated('Use blockPeriodResponseDescriptor instead')
const BlockPeriodResponse$json = {
  '1': 'BlockPeriodResponse',
  '2': [
    {
      '1': 'exception',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.ScheduleException',
      '10': 'exception'
    },
  ],
};

/// Descriptor for `BlockPeriodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List blockPeriodResponseDescriptor = $convert.base64Decode(
    'ChNCbG9ja1BlcmlvZFJlc3BvbnNlEkkKCWV4Y2VwdGlvbhgBIAEoCzIrLmhlYWx0aGNhcmUuc2'
    'NoZWR1bGluZy52MS5TY2hlZHVsZUV4Y2VwdGlvblIJZXhjZXB0aW9u');

@$core.Deprecated('Use unblockPeriodRequestDescriptor instead')
const UnblockPeriodRequest$json = {
  '1': 'UnblockPeriodRequest',
  '2': [
    {'1': 'exception_id', '3': 1, '4': 1, '5': 9, '10': 'exceptionId'},
  ],
};

/// Descriptor for `UnblockPeriodRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unblockPeriodRequestDescriptor = $convert.base64Decode(
    'ChRVbmJsb2NrUGVyaW9kUmVxdWVzdBIhCgxleGNlcHRpb25faWQYASABKAlSC2V4Y2VwdGlvbk'
    'lk');

@$core.Deprecated('Use unblockPeriodResponseDescriptor instead')
const UnblockPeriodResponse$json = {
  '1': 'UnblockPeriodResponse',
};

/// Descriptor for `UnblockPeriodResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unblockPeriodResponseDescriptor =
    $convert.base64Decode('ChVVbmJsb2NrUGVyaW9kUmVzcG9uc2U=');

@$core.Deprecated('Use searchSlotsRequestDescriptor instead')
const SearchSlotsRequest$json = {
  '1': 'SearchSlotsRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 2, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'resource_id', '3': 3, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'visit_mode',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitMode',
      '10': 'visitMode'
    },
    {
      '1': 'from',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'until',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
    {'1': 'page_size', '3': 8, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `SearchSlotsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSlotsRequestDescriptor = $convert.base64Decode(
    'ChJTZWFyY2hTbG90c1JlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSHg'
    'oLb3JnX3VuaXRfaWQYAiABKAlSCW9yZ1VuaXRJZBIfCgtyZXNvdXJjZV9pZBgDIAEoCVIKcmVz'
    'b3VyY2VJZBJCCgp2aXNpdF90eXBlGAQgASgOMiMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLl'
    'Zpc2l0VHlwZVIJdmlzaXRUeXBlEkIKCnZpc2l0X21vZGUYBSABKA4yIy5oZWFsdGhjYXJlLnNj'
    'aGVkdWxpbmcudjEuVmlzaXRNb2RlUgl2aXNpdE1vZGUSLgoEZnJvbRgGIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSBGZyb20SMAoFdW50aWwYByABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgV1bnRpbBIbCglwYWdlX3NpemUYCCABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use searchSlotsResponseDescriptor instead')
const SearchSlotsResponse$json = {
  '1': 'SearchSlotsResponse',
  '2': [
    {
      '1': 'slots',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Slot',
      '10': 'slots'
    },
    {'1': 'truncated', '3': 2, '4': 1, '5': 8, '10': 'truncated'},
  ],
};

/// Descriptor for `SearchSlotsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchSlotsResponseDescriptor = $convert.base64Decode(
    'ChNTZWFyY2hTbG90c1Jlc3BvbnNlEjQKBXNsb3RzGAEgAygLMh4uaGVhbHRoY2FyZS5zY2hlZH'
    'VsaW5nLnYxLlNsb3RSBXNsb3RzEhwKCXRydW5jYXRlZBgCIAEoCFIJdHJ1bmNhdGVk');

@$core.Deprecated('Use bookAppointmentRequestDescriptor instead')
const BookAppointmentRequest$json = {
  '1': 'BookAppointmentRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'starts_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'override', '3': 6, '4': 1, '5': 8, '10': 'override'},
  ],
};

/// Descriptor for `BookAppointmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bookAppointmentRequestDescriptor = $convert.base64Decode(
    'ChZCb29rQXBwb2ludG1lbnRSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZB'
    'IfCgtyZXNvdXJjZV9pZBgCIAEoCVIKcmVzb3VyY2VJZBI3CglzdGFydHNfYXQYAyABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBJCCgp2aXNpdF90eXBlGAQgASgOMi'
    'MuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlZpc2l0VHlwZVIJdmlzaXRUeXBlEhYKBnJlYXNv'
    'bhgFIAEoCVIGcmVhc29uEhoKCG92ZXJyaWRlGAYgASgIUghvdmVycmlkZQ==');

@$core.Deprecated('Use bookAppointmentResponseDescriptor instead')
const BookAppointmentResponse$json = {
  '1': 'BookAppointmentResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `BookAppointmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bookAppointmentResponseDescriptor =
    $convert.base64Decode(
        'ChdCb29rQXBwb2ludG1lbnRSZXNwb25zZRJHCgthcHBvaW50bWVudBgBIAEoCzIlLmhlYWx0aG'
        'NhcmUuc2NoZWR1bGluZy52MS5BcHBvaW50bWVudFILYXBwb2ludG1lbnQ=');

@$core.Deprecated('Use getAppointmentRequestDescriptor instead')
const GetAppointmentRequest$json = {
  '1': 'GetAppointmentRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
  ],
};

/// Descriptor for `GetAppointmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAppointmentRequestDescriptor = $convert.base64Decode(
    'ChVHZXRBcHBvaW50bWVudFJlcXVlc3QSJQoOYXBwb2ludG1lbnRfaWQYASABKAlSDWFwcG9pbn'
    'RtZW50SWQ=');

@$core.Deprecated('Use getAppointmentResponseDescriptor instead')
const GetAppointmentResponse$json = {
  '1': 'GetAppointmentResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `GetAppointmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAppointmentResponseDescriptor =
    $convert.base64Decode(
        'ChZHZXRBcHBvaW50bWVudFJlc3BvbnNlEkcKC2FwcG9pbnRtZW50GAEgASgLMiUuaGVhbHRoY2'
        'FyZS5zY2hlZHVsaW5nLnYxLkFwcG9pbnRtZW50UgthcHBvaW50bWVudA==');

@$core.Deprecated('Use listAppointmentsRequestDescriptor instead')
const ListAppointmentsRequest$json = {
  '1': 'ListAppointmentsRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'facility_id', '3': 2, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'resource_id', '3': 3, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'from',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'until',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
    {'1': 'page_size', '3': 6, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListAppointmentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAppointmentsRequestDescriptor = $convert.base64Decode(
    'ChdMaXN0QXBwb2ludG1lbnRzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SW'
    'QSHwoLZmFjaWxpdHlfaWQYAiABKAlSCmZhY2lsaXR5SWQSHwoLcmVzb3VyY2VfaWQYAyABKAlS'
    'CnJlc291cmNlSWQSLgoEZnJvbRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSBG'
    'Zyb20SMAoFdW50aWwYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgV1bnRpbBIb'
    'CglwYWdlX3NpemUYBiABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use listAppointmentsResponseDescriptor instead')
const ListAppointmentsResponse$json = {
  '1': 'ListAppointmentsResponse',
  '2': [
    {
      '1': 'appointments',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointments'
    },
  ],
};

/// Descriptor for `ListAppointmentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAppointmentsResponseDescriptor =
    $convert.base64Decode(
        'ChhMaXN0QXBwb2ludG1lbnRzUmVzcG9uc2USSQoMYXBwb2ludG1lbnRzGAEgAygLMiUuaGVhbH'
        'RoY2FyZS5zY2hlZHVsaW5nLnYxLkFwcG9pbnRtZW50UgxhcHBvaW50bWVudHM=');

@$core.Deprecated('Use policyOutcomeDescriptor instead')
const PolicyOutcome$json = {
  '1': 'PolicyOutcome',
  '2': [
    {'1': 'timely', '3': 1, '4': 1, '5': 8, '10': 'timely'},
    {
      '1': 'notice_given_minutes',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'noticeGivenMinutes'
    },
    {
      '1': 'notice_required_minutes',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'noticeRequiredMinutes'
    },
    {'1': 'chargeable', '3': 4, '4': 1, '5': 8, '10': 'chargeable'},
  ],
};

/// Descriptor for `PolicyOutcome`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List policyOutcomeDescriptor = $convert.base64Decode(
    'Cg1Qb2xpY3lPdXRjb21lEhYKBnRpbWVseRgBIAEoCFIGdGltZWx5EjAKFG5vdGljZV9naXZlbl'
    '9taW51dGVzGAIgASgFUhJub3RpY2VHaXZlbk1pbnV0ZXMSNgoXbm90aWNlX3JlcXVpcmVkX21p'
    'bnV0ZXMYAyABKAVSFW5vdGljZVJlcXVpcmVkTWludXRlcxIeCgpjaGFyZ2VhYmxlGAQgASgIUg'
    'pjaGFyZ2VhYmxl');

@$core.Deprecated('Use cancelAppointmentRequestDescriptor instead')
const CancelAppointmentRequest$json = {
  '1': 'CancelAppointmentRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelAppointmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelAppointmentRequestDescriptor =
    $convert.base64Decode(
        'ChhDYW5jZWxBcHBvaW50bWVudFJlcXVlc3QSJQoOYXBwb2ludG1lbnRfaWQYASABKAlSDWFwcG'
        '9pbnRtZW50SWQSFgoGcmVhc29uGAIgASgJUgZyZWFzb24=');

@$core.Deprecated('Use cancelAppointmentResponseDescriptor instead')
const CancelAppointmentResponse$json = {
  '1': 'CancelAppointmentResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.PolicyOutcome',
      '10': 'outcome'
    },
  ],
};

/// Descriptor for `CancelAppointmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelAppointmentResponseDescriptor = $convert.base64Decode(
    'ChlDYW5jZWxBcHBvaW50bWVudFJlc3BvbnNlEkcKC2FwcG9pbnRtZW50GAEgASgLMiUuaGVhbH'
    'RoY2FyZS5zY2hlZHVsaW5nLnYxLkFwcG9pbnRtZW50UgthcHBvaW50bWVudBJBCgdvdXRjb21l'
    'GAIgASgLMicuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlBvbGljeU91dGNvbWVSB291dGNvbW'
    'U=');

@$core.Deprecated('Use rescheduleAppointmentRequestDescriptor instead')
const RescheduleAppointmentRequest$json = {
  '1': 'RescheduleAppointmentRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'starts_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'override', '3': 6, '4': 1, '5': 8, '10': 'override'},
  ],
};

/// Descriptor for `RescheduleAppointmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescheduleAppointmentRequestDescriptor = $convert.base64Decode(
    'ChxSZXNjaGVkdWxlQXBwb2ludG1lbnRSZXF1ZXN0EiUKDmFwcG9pbnRtZW50X2lkGAEgASgJUg'
    '1hcHBvaW50bWVudElkEh8KC3Jlc291cmNlX2lkGAIgASgJUgpyZXNvdXJjZUlkEjcKCXN0YXJ0'
    'c19hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0YXJ0c0F0EkIKCnZpc2'
    'l0X3R5cGUYBCABKA4yIy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuVmlzaXRUeXBlUgl2aXNp'
    'dFR5cGUSFgoGcmVhc29uGAUgASgJUgZyZWFzb24SGgoIb3ZlcnJpZGUYBiABKAhSCG92ZXJyaW'
    'Rl');

@$core.Deprecated('Use rescheduleAppointmentResponseDescriptor instead')
const RescheduleAppointmentResponse$json = {
  '1': 'RescheduleAppointmentResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
    {
      '1': 'previous_appointment_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'previousAppointmentId'
    },
    {
      '1': 'outcome',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.PolicyOutcome',
      '10': 'outcome'
    },
  ],
};

/// Descriptor for `RescheduleAppointmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rescheduleAppointmentResponseDescriptor = $convert.base64Decode(
    'Ch1SZXNjaGVkdWxlQXBwb2ludG1lbnRSZXNwb25zZRJHCgthcHBvaW50bWVudBgBIAEoCzIlLm'
    'hlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5BcHBvaW50bWVudFILYXBwb2ludG1lbnQSNgoXcHJl'
    'dmlvdXNfYXBwb2ludG1lbnRfaWQYAiABKAlSFXByZXZpb3VzQXBwb2ludG1lbnRJZBJBCgdvdX'
    'Rjb21lGAMgASgLMicuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlBvbGljeU91dGNvbWVSB291'
    'dGNvbWU=');

@$core.Deprecated('Use schedulingPolicyDescriptor instead')
const SchedulingPolicy$json = {
  '1': 'SchedulingPolicy',
  '2': [
    {'1': 'notice_hours', '3': 1, '4': 1, '5': 5, '10': 'noticeHours'},
    {
      '1': 'reschedule_notice_hours',
      '3': 2,
      '4': 1,
      '5': 5,
      '10': 'rescheduleNoticeHours'
    },
    {'1': 'max_reschedules', '3': 3, '4': 1, '5': 5, '10': 'maxReschedules'},
    {
      '1': 'chargeable_when_late',
      '3': 4,
      '4': 1,
      '5': 8,
      '10': 'chargeableWhenLate'
    },
    {
      '1': 'teleconsult_enabled',
      '3': 5,
      '4': 1,
      '5': 8,
      '10': 'teleconsultEnabled'
    },
    {
      '1': 'teleconsult_visit_types',
      '3': 6,
      '4': 3,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'teleconsultVisitTypes'
    },
    {
      '1': 'teleconsult_requires_confirmed_identity',
      '3': 7,
      '4': 1,
      '5': 8,
      '10': 'teleconsultRequiresConfirmedIdentity'
    },
    {
      '1': 'notification_kinds',
      '3': 8,
      '4': 3,
      '5': 14,
      '6': '.healthcare.scheduling.v1.NotificationKind',
      '10': 'notificationKinds'
    },
    {
      '1': 'reminder_hours_before',
      '3': 9,
      '4': 1,
      '5': 5,
      '10': 'reminderHoursBefore'
    },
  ],
};

/// Descriptor for `SchedulingPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schedulingPolicyDescriptor = $convert.base64Decode(
    'ChBTY2hlZHVsaW5nUG9saWN5EiEKDG5vdGljZV9ob3VycxgBIAEoBVILbm90aWNlSG91cnMSNg'
    'oXcmVzY2hlZHVsZV9ub3RpY2VfaG91cnMYAiABKAVSFXJlc2NoZWR1bGVOb3RpY2VIb3VycxIn'
    'Cg9tYXhfcmVzY2hlZHVsZXMYAyABKAVSDm1heFJlc2NoZWR1bGVzEjAKFGNoYXJnZWFibGVfd2'
    'hlbl9sYXRlGAQgASgIUhJjaGFyZ2VhYmxlV2hlbkxhdGUSLwoTdGVsZWNvbnN1bHRfZW5hYmxl'
    'ZBgFIAEoCFISdGVsZWNvbnN1bHRFbmFibGVkElsKF3RlbGVjb25zdWx0X3Zpc2l0X3R5cGVzGA'
    'YgAygOMiMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlZpc2l0VHlwZVIVdGVsZWNvbnN1bHRW'
    'aXNpdFR5cGVzElUKJ3RlbGVjb25zdWx0X3JlcXVpcmVzX2NvbmZpcm1lZF9pZGVudGl0eRgHIA'
    'EoCFIkdGVsZWNvbnN1bHRSZXF1aXJlc0NvbmZpcm1lZElkZW50aXR5ElkKEm5vdGlmaWNhdGlv'
    'bl9raW5kcxgIIAMoDjIqLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5Ob3RpZmljYXRpb25LaW'
    '5kUhFub3RpZmljYXRpb25LaW5kcxIyChVyZW1pbmRlcl9ob3Vyc19iZWZvcmUYCSABKAVSE3Jl'
    'bWluZGVySG91cnNCZWZvcmU=');

@$core.Deprecated('Use setSchedulingPolicyRequestDescriptor instead')
const SetSchedulingPolicyRequest$json = {
  '1': 'SetSchedulingPolicyRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {
      '1': 'policy',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.SchedulingPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `SetSchedulingPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSchedulingPolicyRequestDescriptor =
    $convert.base64Decode(
        'ChpTZXRTY2hlZHVsaW5nUG9saWN5UmVxdWVzdBIfCgtmYWNpbGl0eV9pZBgBIAEoCVIKZmFjaW'
        'xpdHlJZBJCCgZwb2xpY3kYAiABKAsyKi5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuU2NoZWR1'
        'bGluZ1BvbGljeVIGcG9saWN5');

@$core.Deprecated('Use setSchedulingPolicyResponseDescriptor instead')
const SetSchedulingPolicyResponse$json = {
  '1': 'SetSchedulingPolicyResponse',
};

/// Descriptor for `SetSchedulingPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setSchedulingPolicyResponseDescriptor =
    $convert.base64Decode('ChtTZXRTY2hlZHVsaW5nUG9saWN5UmVzcG9uc2U=');

@$core.Deprecated('Use bookSeriesRequestDescriptor instead')
const BookSeriesRequest$json = {
  '1': 'BookSeriesRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'starts_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {'1': 'interval_days', '3': 5, '4': 1, '5': 5, '10': 'intervalDays'},
    {'1': 'occurrences', '3': 6, '4': 1, '5': 5, '10': 'occurrences'},
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `BookSeriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bookSeriesRequestDescriptor = $convert.base64Decode(
    'ChFCb29rU2VyaWVzUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW50SWQSHwoLcm'
    'Vzb3VyY2VfaWQYAiABKAlSCnJlc291cmNlSWQSNwoJc3RhcnRzX2F0GAMgASgLMhouZ29vZ2xl'
    'LnByb3RvYnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSQgoKdmlzaXRfdHlwZRgEIAEoDjIjLmhlYW'
    'x0aGNhcmUuc2NoZWR1bGluZy52MS5WaXNpdFR5cGVSCXZpc2l0VHlwZRIjCg1pbnRlcnZhbF9k'
    'YXlzGAUgASgFUgxpbnRlcnZhbERheXMSIAoLb2NjdXJyZW5jZXMYBiABKAVSC29jY3VycmVuY2'
    'VzEhYKBnJlYXNvbhgHIAEoCVIGcmVhc29u');

@$core.Deprecated('Use bookSeriesResponseDescriptor instead')
const BookSeriesResponse$json = {
  '1': 'BookSeriesResponse',
  '2': [
    {'1': 'series_id', '3': 1, '4': 1, '5': 9, '10': 'seriesId'},
    {
      '1': 'appointments',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointments'
    },
    {
      '1': 'unavailable',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'unavailable'
    },
  ],
};

/// Descriptor for `BookSeriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bookSeriesResponseDescriptor = $convert.base64Decode(
    'ChJCb29rU2VyaWVzUmVzcG9uc2USGwoJc2VyaWVzX2lkGAEgASgJUghzZXJpZXNJZBJJCgxhcH'
    'BvaW50bWVudHMYAiADKAsyJS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQXBwb2ludG1lbnRS'
    'DGFwcG9pbnRtZW50cxI8Cgt1bmF2YWlsYWJsZRgDIAMoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSC3VuYXZhaWxhYmxl');

@$core.Deprecated('Use cancelSeriesRequestDescriptor instead')
const CancelSeriesRequest$json = {
  '1': 'CancelSeriesRequest',
  '2': [
    {'1': 'series_id', '3': 1, '4': 1, '5': 9, '10': 'seriesId'},
    {
      '1': 'from_appointment_id',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'fromAppointmentId'
    },
    {
      '1': 'scope',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.SeriesScope',
      '10': 'scope'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `CancelSeriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSeriesRequestDescriptor = $convert.base64Decode(
    'ChNDYW5jZWxTZXJpZXNSZXF1ZXN0EhsKCXNlcmllc19pZBgBIAEoCVIIc2VyaWVzSWQSLgoTZn'
    'JvbV9hcHBvaW50bWVudF9pZBgCIAEoCVIRZnJvbUFwcG9pbnRtZW50SWQSOwoFc2NvcGUYAyAB'
    'KA4yJS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuU2VyaWVzU2NvcGVSBXNjb3BlEhYKBnJlYX'
    'NvbhgEIAEoCVIGcmVhc29u');

@$core.Deprecated('Use cancelSeriesResponseDescriptor instead')
const CancelSeriesResponse$json = {
  '1': 'CancelSeriesResponse',
  '2': [
    {
      '1': 'cancelled_appointment_ids',
      '3': 1,
      '4': 3,
      '5': 9,
      '10': 'cancelledAppointmentIds'
    },
  ],
};

/// Descriptor for `CancelSeriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelSeriesResponseDescriptor = $convert.base64Decode(
    'ChRDYW5jZWxTZXJpZXNSZXNwb25zZRI6ChljYW5jZWxsZWRfYXBwb2ludG1lbnRfaWRzGAEgAy'
    'gJUhdjYW5jZWxsZWRBcHBvaW50bWVudElkcw==');

@$core.Deprecated('Use waitlistEntryDescriptor instead')
const WaitlistEntry$json = {
  '1': 'WaitlistEntry',
  '2': [
    {'1': 'waitlist_id', '3': 1, '4': 1, '5': 9, '10': 'waitlistId'},
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resource_id', '3': 3, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 4, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 5, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'visit_type',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'not_before',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notBefore'
    },
    {
      '1': 'not_after',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notAfter'
    },
    {'1': 'appointment_id', '3': 9, '4': 1, '5': 9, '10': 'appointmentId'},
    {
      '1': 'status',
      '3': 10,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.WaitlistStatus',
      '10': 'status'
    },
    {
      '1': 'offered_slot_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'offeredSlotAt'
    },
    {
      '1': 'offer_expires_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'offerExpiresAt'
    },
  ],
};

/// Descriptor for `WaitlistEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waitlistEntryDescriptor = $convert.base64Decode(
    'Cg1XYWl0bGlzdEVudHJ5Eh8KC3dhaXRsaXN0X2lkGAEgASgJUgp3YWl0bGlzdElkEh0KCnBhdG'
    'llbnRfaWQYAiABKAlSCXBhdGllbnRJZBIfCgtyZXNvdXJjZV9pZBgDIAEoCVIKcmVzb3VyY2VJ'
    'ZBIfCgtmYWNpbGl0eV9pZBgEIAEoCVIKZmFjaWxpdHlJZBIeCgtvcmdfdW5pdF9pZBgFIAEoCV'
    'IJb3JnVW5pdElkEkIKCnZpc2l0X3R5cGUYBiABKA4yIy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcu'
    'djEuVmlzaXRUeXBlUgl2aXNpdFR5cGUSOQoKbm90X2JlZm9yZRgHIAEoCzIaLmdvb2dsZS5wcm'
    '90b2J1Zi5UaW1lc3RhbXBSCW5vdEJlZm9yZRI3Cglub3RfYWZ0ZXIYCCABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUghub3RBZnRlchIlCg5hcHBvaW50bWVudF9pZBgJIAEoCVINYX'
    'Bwb2ludG1lbnRJZBJACgZzdGF0dXMYCiABKA4yKC5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEu'
    'V2FpdGxpc3RTdGF0dXNSBnN0YXR1cxJCCg9vZmZlcmVkX3Nsb3RfYXQYCyABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUg1vZmZlcmVkU2xvdEF0EkQKEG9mZmVyX2V4cGlyZXNfYXQY'
    'DCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5vZmZlckV4cGlyZXNBdA==');

@$core.Deprecated('Use joinWaitlistRequestDescriptor instead')
const JoinWaitlistRequest$json = {
  '1': 'JoinWaitlistRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 4, '4': 1, '5': 9, '10': 'orgUnitId'},
    {
      '1': 'visit_type',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {
      '1': 'not_before',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notBefore'
    },
    {
      '1': 'not_after',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'notAfter'
    },
    {'1': 'appointment_id', '3': 8, '4': 1, '5': 9, '10': 'appointmentId'},
  ],
};

/// Descriptor for `JoinWaitlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinWaitlistRequestDescriptor = $convert.base64Decode(
    'ChNKb2luV2FpdGxpc3RSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIfCg'
    'tyZXNvdXJjZV9pZBgCIAEoCVIKcmVzb3VyY2VJZBIfCgtmYWNpbGl0eV9pZBgDIAEoCVIKZmFj'
    'aWxpdHlJZBIeCgtvcmdfdW5pdF9pZBgEIAEoCVIJb3JnVW5pdElkEkIKCnZpc2l0X3R5cGUYBS'
    'ABKA4yIy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuVmlzaXRUeXBlUgl2aXNpdFR5cGUSOQoK'
    'bm90X2JlZm9yZRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCW5vdEJlZm9yZR'
    'I3Cglub3RfYWZ0ZXIYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghub3RBZnRl'
    'chIlCg5hcHBvaW50bWVudF9pZBgIIAEoCVINYXBwb2ludG1lbnRJZA==');

@$core.Deprecated('Use joinWaitlistResponseDescriptor instead')
const JoinWaitlistResponse$json = {
  '1': 'JoinWaitlistResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.WaitlistEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `JoinWaitlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List joinWaitlistResponseDescriptor = $convert.base64Decode(
    'ChRKb2luV2FpdGxpc3RSZXNwb25zZRI9CgVlbnRyeRgBIAEoCzInLmhlYWx0aGNhcmUuc2NoZW'
    'R1bGluZy52MS5XYWl0bGlzdEVudHJ5UgVlbnRyeQ==');

@$core.Deprecated('Use offerWaitlistSlotRequestDescriptor instead')
const OfferWaitlistSlotRequest$json = {
  '1': 'OfferWaitlistSlotRequest',
  '2': [
    {'1': 'waitlist_id', '3': 1, '4': 1, '5': 9, '10': 'waitlistId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'starts_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'visit_type',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.VisitType',
      '10': 'visitType'
    },
    {'1': 'valid_for_minutes', '3': 5, '4': 1, '5': 5, '10': 'validForMinutes'},
  ],
};

/// Descriptor for `OfferWaitlistSlotRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerWaitlistSlotRequestDescriptor = $convert.base64Decode(
    'ChhPZmZlcldhaXRsaXN0U2xvdFJlcXVlc3QSHwoLd2FpdGxpc3RfaWQYASABKAlSCndhaXRsaX'
    'N0SWQSHwoLcmVzb3VyY2VfaWQYAiABKAlSCnJlc291cmNlSWQSNwoJc3RhcnRzX2F0GAMgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSQgoKdmlzaXRfdHlwZRgEIA'
    'EoDjIjLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5WaXNpdFR5cGVSCXZpc2l0VHlwZRIqChF2'
    'YWxpZF9mb3JfbWludXRlcxgFIAEoBVIPdmFsaWRGb3JNaW51dGVz');

@$core.Deprecated('Use offerWaitlistSlotResponseDescriptor instead')
const OfferWaitlistSlotResponse$json = {
  '1': 'OfferWaitlistSlotResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.WaitlistEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `OfferWaitlistSlotResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List offerWaitlistSlotResponseDescriptor =
    $convert.base64Decode(
        'ChlPZmZlcldhaXRsaXN0U2xvdFJlc3BvbnNlEj0KBWVudHJ5GAEgASgLMicuaGVhbHRoY2FyZS'
        '5zY2hlZHVsaW5nLnYxLldhaXRsaXN0RW50cnlSBWVudHJ5');

@$core.Deprecated('Use acceptWaitlistOfferRequestDescriptor instead')
const AcceptWaitlistOfferRequest$json = {
  '1': 'AcceptWaitlistOfferRequest',
  '2': [
    {'1': 'waitlist_id', '3': 1, '4': 1, '5': 9, '10': 'waitlistId'},
  ],
};

/// Descriptor for `AcceptWaitlistOfferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptWaitlistOfferRequestDescriptor =
    $convert.base64Decode(
        'ChpBY2NlcHRXYWl0bGlzdE9mZmVyUmVxdWVzdBIfCgt3YWl0bGlzdF9pZBgBIAEoCVIKd2FpdG'
        'xpc3RJZA==');

@$core.Deprecated('Use acceptWaitlistOfferResponseDescriptor instead')
const AcceptWaitlistOfferResponse$json = {
  '1': 'AcceptWaitlistOfferResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.WaitlistEntry',
      '10': 'entry'
    },
    {
      '1': 'appointment',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
    {
      '1': 'replaced_appointment_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'replacedAppointmentId'
    },
  ],
};

/// Descriptor for `AcceptWaitlistOfferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptWaitlistOfferResponseDescriptor = $convert.base64Decode(
    'ChtBY2NlcHRXYWl0bGlzdE9mZmVyUmVzcG9uc2USPQoFZW50cnkYASABKAsyJy5oZWFsdGhjYX'
    'JlLnNjaGVkdWxpbmcudjEuV2FpdGxpc3RFbnRyeVIFZW50cnkSRwoLYXBwb2ludG1lbnQYAiAB'
    'KAsyJS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQXBwb2ludG1lbnRSC2FwcG9pbnRtZW50Ej'
    'YKF3JlcGxhY2VkX2FwcG9pbnRtZW50X2lkGAMgASgJUhVyZXBsYWNlZEFwcG9pbnRtZW50SWQ=');

@$core.Deprecated('Use declineWaitlistOfferRequestDescriptor instead')
const DeclineWaitlistOfferRequest$json = {
  '1': 'DeclineWaitlistOfferRequest',
  '2': [
    {'1': 'waitlist_id', '3': 1, '4': 1, '5': 9, '10': 'waitlistId'},
  ],
};

/// Descriptor for `DeclineWaitlistOfferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declineWaitlistOfferRequestDescriptor =
    $convert.base64Decode(
        'ChtEZWNsaW5lV2FpdGxpc3RPZmZlclJlcXVlc3QSHwoLd2FpdGxpc3RfaWQYASABKAlSCndhaX'
        'RsaXN0SWQ=');

@$core.Deprecated('Use declineWaitlistOfferResponseDescriptor instead')
const DeclineWaitlistOfferResponse$json = {
  '1': 'DeclineWaitlistOfferResponse',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.WaitlistEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `DeclineWaitlistOfferResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List declineWaitlistOfferResponseDescriptor =
    $convert.base64Decode(
        'ChxEZWNsaW5lV2FpdGxpc3RPZmZlclJlc3BvbnNlEj0KBWVudHJ5GAEgASgLMicuaGVhbHRoY2'
        'FyZS5zY2hlZHVsaW5nLnYxLldhaXRsaXN0RW50cnlSBWVudHJ5');

@$core.Deprecated('Use listWaitlistRequestDescriptor instead')
const ListWaitlistRequest$json = {
  '1': 'ListWaitlistRequest',
  '2': [
    {'1': 'resource_id', '3': 1, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListWaitlistRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaitlistRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0V2FpdGxpc3RSZXF1ZXN0Eh8KC3Jlc291cmNlX2lkGAEgASgJUgpyZXNvdXJjZUlkEh'
    'sKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listWaitlistResponseDescriptor instead')
const ListWaitlistResponse$json = {
  '1': 'ListWaitlistResponse',
  '2': [
    {
      '1': 'entries',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.WaitlistEntry',
      '10': 'entries'
    },
  ],
};

/// Descriptor for `ListWaitlistResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listWaitlistResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0V2FpdGxpc3RSZXNwb25zZRJBCgdlbnRyaWVzGAEgAygLMicuaGVhbHRoY2FyZS5zY2'
    'hlZHVsaW5nLnYxLldhaXRsaXN0RW50cnlSB2VudHJpZXM=');

@$core.Deprecated('Use expireWaitlistOffersRequestDescriptor instead')
const ExpireWaitlistOffersRequest$json = {
  '1': 'ExpireWaitlistOffersRequest',
};

/// Descriptor for `ExpireWaitlistOffersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expireWaitlistOffersRequestDescriptor =
    $convert.base64Decode('ChtFeHBpcmVXYWl0bGlzdE9mZmVyc1JlcXVlc3Q=');

@$core.Deprecated('Use expireWaitlistOffersResponseDescriptor instead')
const ExpireWaitlistOffersResponse$json = {
  '1': 'ExpireWaitlistOffersResponse',
  '2': [
    {'1': 'expired', '3': 1, '4': 1, '5': 3, '10': 'expired'},
  ],
};

/// Descriptor for `ExpireWaitlistOffersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List expireWaitlistOffersResponseDescriptor =
    $convert.base64Decode(
        'ChxFeHBpcmVXYWl0bGlzdE9mZmVyc1Jlc3BvbnNlEhgKB2V4cGlyZWQYASABKANSB2V4cGlyZW'
        'Q=');

@$core.Deprecated('Use checkInRequestDescriptor instead')
const CheckInRequest$json = {
  '1': 'CheckInRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'arrival_mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ArrivalMode',
      '10': 'arrivalMode'
    },
    {
      '1': 'priority',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.Priority',
      '10': 'priority'
    },
    {'1': 'priority_reason', '3': 5, '4': 1, '5': 9, '10': 'priorityReason'},
  ],
};

/// Descriptor for `CheckInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInRequestDescriptor = $convert.base64Decode(
    'Cg5DaGVja0luUmVxdWVzdBIlCg5hcHBvaW50bWVudF9pZBgBIAEoCVINYXBwb2ludG1lbnRJZB'
    'IUCgV0b2tlbhgCIAEoCVIFdG9rZW4SSAoMYXJyaXZhbF9tb2RlGAMgASgOMiUuaGVhbHRoY2Fy'
    'ZS5zY2hlZHVsaW5nLnYxLkFycml2YWxNb2RlUgthcnJpdmFsTW9kZRI+Cghwcmlvcml0eRgEIA'
    'EoDjIiLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5Qcmlvcml0eVIIcHJpb3JpdHkSJwoPcHJp'
    'b3JpdHlfcmVhc29uGAUgASgJUg5wcmlvcml0eVJlYXNvbg==');

@$core.Deprecated('Use checkInResponseDescriptor instead')
const CheckInResponse$json = {
  '1': 'CheckInResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `CheckInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkInResponseDescriptor = $convert.base64Decode(
    'Cg9DaGVja0luUmVzcG9uc2USRwoLYXBwb2ludG1lbnQYASABKAsyJS5oZWFsdGhjYXJlLnNjaG'
    'VkdWxpbmcudjEuQXBwb2ludG1lbnRSC2FwcG9pbnRtZW50');

@$core.Deprecated('Use advanceAppointmentRequestDescriptor instead')
const AdvanceAppointmentRequest$json = {
  '1': 'AdvanceAppointmentRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {
      '1': 'to',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.AppointmentStatus',
      '10': 'to'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'correction', '3': 4, '4': 1, '5': 8, '10': 'correction'},
  ],
};

/// Descriptor for `AdvanceAppointmentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceAppointmentRequestDescriptor = $convert.base64Decode(
    'ChlBZHZhbmNlQXBwb2ludG1lbnRSZXF1ZXN0EiUKDmFwcG9pbnRtZW50X2lkGAEgASgJUg1hcH'
    'BvaW50bWVudElkEjsKAnRvGAIgASgOMisuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkFwcG9p'
    'bnRtZW50U3RhdHVzUgJ0bxIWCgZyZWFzb24YAyABKAlSBnJlYXNvbhIeCgpjb3JyZWN0aW9uGA'
    'QgASgIUgpjb3JyZWN0aW9u');

@$core.Deprecated('Use advanceAppointmentResponseDescriptor instead')
const AdvanceAppointmentResponse$json = {
  '1': 'AdvanceAppointmentResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `AdvanceAppointmentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceAppointmentResponseDescriptor =
    $convert.base64Decode(
        'ChpBZHZhbmNlQXBwb2ludG1lbnRSZXNwb25zZRJHCgthcHBvaW50bWVudBgBIAEoCzIlLmhlYW'
        'x0aGNhcmUuc2NoZWR1bGluZy52MS5BcHBvaW50bWVudFILYXBwb2ludG1lbnQ=');

@$core.Deprecated('Use reprioritiseRequestDescriptor instead')
const ReprioritiseRequest$json = {
  '1': 'ReprioritiseRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {
      '1': 'priority',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.Priority',
      '10': 'priority'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ReprioritiseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprioritiseRequestDescriptor = $convert.base64Decode(
    'ChNSZXByaW9yaXRpc2VSZXF1ZXN0EiUKDmFwcG9pbnRtZW50X2lkGAEgASgJUg1hcHBvaW50bW'
    'VudElkEj4KCHByaW9yaXR5GAIgASgOMiIuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlByaW9y'
    'aXR5Ughwcmlvcml0eRIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use reprioritiseResponseDescriptor instead')
const ReprioritiseResponse$json = {
  '1': 'ReprioritiseResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `ReprioritiseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reprioritiseResponseDescriptor = $convert.base64Decode(
    'ChRSZXByaW9yaXRpc2VSZXNwb25zZRJHCgthcHBvaW50bWVudBgBIAEoCzIlLmhlYWx0aGNhcm'
    'Uuc2NoZWR1bGluZy52MS5BcHBvaW50bWVudFILYXBwb2ludG1lbnQ=');

@$core.Deprecated('Use queuePositionDescriptor instead')
const QueuePosition$json = {
  '1': 'QueuePosition',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
    {'1': 'position', '3': 2, '4': 1, '5': 5, '10': 'position'},
    {
      '1': 'estimated_wait_seconds',
      '3': 3,
      '4': 1,
      '5': 3,
      '10': 'estimatedWaitSeconds'
    },
  ],
};

/// Descriptor for `QueuePosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queuePositionDescriptor = $convert.base64Decode(
    'Cg1RdWV1ZVBvc2l0aW9uEkcKC2FwcG9pbnRtZW50GAEgASgLMiUuaGVhbHRoY2FyZS5zY2hlZH'
    'VsaW5nLnYxLkFwcG9pbnRtZW50UgthcHBvaW50bWVudBIaCghwb3NpdGlvbhgCIAEoBVIIcG9z'
    'aXRpb24SNAoWZXN0aW1hdGVkX3dhaXRfc2Vjb25kcxgDIAEoA1IUZXN0aW1hdGVkV2FpdFNlY2'
    '9uZHM=');

@$core.Deprecated('Use queueEstimateDescriptor instead')
const QueueEstimate$json = {
  '1': 'QueueEstimate',
  '2': [
    {'1': 'service_minutes', '3': 1, '4': 1, '5': 1, '10': 'serviceMinutes'},
    {'1': 'observed', '3': 2, '4': 1, '5': 8, '10': 'observed'},
    {
      '1': 'active_clinicians',
      '3': 3,
      '4': 1,
      '5': 5,
      '10': 'activeClinicians'
    },
  ],
};

/// Descriptor for `QueueEstimate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queueEstimateDescriptor = $convert.base64Decode(
    'Cg1RdWV1ZUVzdGltYXRlEicKD3NlcnZpY2VfbWludXRlcxgBIAEoAVIOc2VydmljZU1pbnV0ZX'
    'MSGgoIb2JzZXJ2ZWQYAiABKAhSCG9ic2VydmVkEisKEWFjdGl2ZV9jbGluaWNpYW5zGAMgASgF'
    'UhBhY3RpdmVDbGluaWNpYW5z');

@$core.Deprecated('Use getQueueRequestDescriptor instead')
const GetQueueRequest$json = {
  '1': 'GetQueueRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {
      '1': 'from',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'until',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'until'
    },
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `GetQueueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQueueRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRRdWV1ZVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaXR5SWQSHwoLcm'
    'Vzb3VyY2VfaWQYAiABKAlSCnJlc291cmNlSWQSLgoEZnJvbRgDIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSBGZyb20SMAoFdW50aWwYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgV1bnRpbBIbCglwYWdlX3NpemUYBSABKAVSCHBhZ2VTaXpl');

@$core.Deprecated('Use getQueueResponseDescriptor instead')
const GetQueueResponse$json = {
  '1': 'GetQueueResponse',
  '2': [
    {
      '1': 'positions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.QueuePosition',
      '10': 'positions'
    },
    {
      '1': 'estimate',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.QueueEstimate',
      '10': 'estimate'
    },
  ],
};

/// Descriptor for `GetQueueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getQueueResponseDescriptor = $convert.base64Decode(
    'ChBHZXRRdWV1ZVJlc3BvbnNlEkUKCXBvc2l0aW9ucxgBIAMoCzInLmhlYWx0aGNhcmUuc2NoZW'
    'R1bGluZy52MS5RdWV1ZVBvc2l0aW9uUglwb3NpdGlvbnMSQwoIZXN0aW1hdGUYAiABKAsyJy5o'
    'ZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuUXVldWVFc3RpbWF0ZVIIZXN0aW1hdGU=');

@$core.Deprecated('Use registerWalkInRequestDescriptor instead')
const RegisterWalkInRequest$json = {
  '1': 'RegisterWalkInRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'resource_id', '3': 2, '4': 1, '5': 9, '10': 'resourceId'},
    {'1': 'facility_id', '3': 3, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'org_unit_id', '3': 4, '4': 1, '5': 9, '10': 'orgUnitId'},
    {'1': 'token', '3': 5, '4': 1, '5': 9, '10': 'token'},
    {
      '1': 'arrival_mode',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.ArrivalMode',
      '10': 'arrivalMode'
    },
    {
      '1': 'priority',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.Priority',
      '10': 'priority'
    },
    {'1': 'priority_reason', '3': 8, '4': 1, '5': 9, '10': 'priorityReason'},
    {'1': 'reason', '3': 9, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RegisterWalkInRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerWalkInRequestDescriptor = $convert.base64Decode(
    'ChVSZWdpc3RlcldhbGtJblJlcXVlc3QSHQoKcGF0aWVudF9pZBgBIAEoCVIJcGF0aWVudElkEh'
    '8KC3Jlc291cmNlX2lkGAIgASgJUgpyZXNvdXJjZUlkEh8KC2ZhY2lsaXR5X2lkGAMgASgJUgpm'
    'YWNpbGl0eUlkEh4KC29yZ191bml0X2lkGAQgASgJUglvcmdVbml0SWQSFAoFdG9rZW4YBSABKA'
    'lSBXRva2VuEkgKDGFycml2YWxfbW9kZRgGIAEoDjIlLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52'
    'MS5BcnJpdmFsTW9kZVILYXJyaXZhbE1vZGUSPgoIcHJpb3JpdHkYByABKA4yIi5oZWFsdGhjYX'
    'JlLnNjaGVkdWxpbmcudjEuUHJpb3JpdHlSCHByaW9yaXR5EicKD3ByaW9yaXR5X3JlYXNvbhgI'
    'IAEoCVIOcHJpb3JpdHlSZWFzb24SFgoGcmVhc29uGAkgASgJUgZyZWFzb24=');

@$core.Deprecated('Use registerWalkInResponseDescriptor instead')
const RegisterWalkInResponse$json = {
  '1': 'RegisterWalkInResponse',
  '2': [
    {
      '1': 'appointment',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Appointment',
      '10': 'appointment'
    },
  ],
};

/// Descriptor for `RegisterWalkInResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerWalkInResponseDescriptor =
    $convert.base64Decode(
        'ChZSZWdpc3RlcldhbGtJblJlc3BvbnNlEkcKC2FwcG9pbnRtZW50GAEgASgLMiUuaGVhbHRoY2'
        'FyZS5zY2hlZHVsaW5nLnYxLkFwcG9pbnRtZW50UgthcHBvaW50bWVudA==');

@$core.Deprecated('Use notificationDescriptor instead')
const Notification$json = {
  '1': 'Notification',
  '2': [
    {'1': 'notification_id', '3': 1, '4': 1, '5': 9, '10': 'notificationId'},
    {'1': 'appointment_id', '3': 2, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'waitlist_id', '3': 3, '4': 1, '5': 9, '10': 'waitlistId'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.NotificationKind',
      '10': 'kind'
    },
    {'1': 'channel', '3': 6, '4': 1, '5': 9, '10': 'channel'},
    {
      '1': 'outcome',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.DeliveryOutcome',
      '10': 'outcome'
    },
    {'1': 'detail', '3': 8, '4': 1, '5': 9, '10': 'detail'},
    {
      '1': 'send_after',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'sendAfter'
    },
    {
      '1': 'created_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
  ],
};

/// Descriptor for `Notification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List notificationDescriptor = $convert.base64Decode(
    'CgxOb3RpZmljYXRpb24SJwoPbm90aWZpY2F0aW9uX2lkGAEgASgJUg5ub3RpZmljYXRpb25JZB'
    'IlCg5hcHBvaW50bWVudF9pZBgCIAEoCVINYXBwb2ludG1lbnRJZBIfCgt3YWl0bGlzdF9pZBgD'
    'IAEoCVIKd2FpdGxpc3RJZBIdCgpwYXRpZW50X2lkGAQgASgJUglwYXRpZW50SWQSPgoEa2luZB'
    'gFIAEoDjIqLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5Ob3RpZmljYXRpb25LaW5kUgRraW5k'
    'EhgKB2NoYW5uZWwYBiABKAlSB2NoYW5uZWwSQwoHb3V0Y29tZRgHIAEoDjIpLmhlYWx0aGNhcm'
    'Uuc2NoZWR1bGluZy52MS5EZWxpdmVyeU91dGNvbWVSB291dGNvbWUSFgoGZGV0YWlsGAggASgJ'
    'UgZkZXRhaWwSOQoKc2VuZF9hZnRlchgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCXNlbmRBZnRlchI5CgpjcmVhdGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgl1cGRhdGVkQXQ=');

@$core.Deprecated('Use recordDeliveryOutcomeRequestDescriptor instead')
const RecordDeliveryOutcomeRequest$json = {
  '1': 'RecordDeliveryOutcomeRequest',
  '2': [
    {'1': 'notification_id', '3': 1, '4': 1, '5': 9, '10': 'notificationId'},
    {
      '1': 'outcome',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.scheduling.v1.DeliveryOutcome',
      '10': 'outcome'
    },
    {'1': 'detail', '3': 3, '4': 1, '5': 9, '10': 'detail'},
  ],
};

/// Descriptor for `RecordDeliveryOutcomeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeliveryOutcomeRequestDescriptor = $convert.base64Decode(
    'ChxSZWNvcmREZWxpdmVyeU91dGNvbWVSZXF1ZXN0EicKD25vdGlmaWNhdGlvbl9pZBgBIAEoCV'
    'IObm90aWZpY2F0aW9uSWQSQwoHb3V0Y29tZRgCIAEoDjIpLmhlYWx0aGNhcmUuc2NoZWR1bGlu'
    'Zy52MS5EZWxpdmVyeU91dGNvbWVSB291dGNvbWUSFgoGZGV0YWlsGAMgASgJUgZkZXRhaWw=');

@$core.Deprecated('Use recordDeliveryOutcomeResponseDescriptor instead')
const RecordDeliveryOutcomeResponse$json = {
  '1': 'RecordDeliveryOutcomeResponse',
  '2': [
    {
      '1': 'notification',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Notification',
      '10': 'notification'
    },
  ],
};

/// Descriptor for `RecordDeliveryOutcomeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordDeliveryOutcomeResponseDescriptor =
    $convert.base64Decode(
        'Ch1SZWNvcmREZWxpdmVyeU91dGNvbWVSZXNwb25zZRJKCgxub3RpZmljYXRpb24YASABKAsyJi'
        '5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuTm90aWZpY2F0aW9uUgxub3RpZmljYXRpb24=');

@$core.Deprecated('Use listNotificationsRequestDescriptor instead')
const ListNotificationsRequest$json = {
  '1': 'ListNotificationsRequest',
  '2': [
    {'1': 'appointment_id', '3': 1, '4': 1, '5': 9, '10': 'appointmentId'},
    {'1': 'waitlist_id', '3': 2, '4': 1, '5': 9, '10': 'waitlistId'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListNotificationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotificationsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0Tm90aWZpY2F0aW9uc1JlcXVlc3QSJQoOYXBwb2ludG1lbnRfaWQYASABKAlSDWFwcG'
    '9pbnRtZW50SWQSHwoLd2FpdGxpc3RfaWQYAiABKAlSCndhaXRsaXN0SWQSGwoJcGFnZV9zaXpl'
    'GAMgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use listNotificationsResponseDescriptor instead')
const ListNotificationsResponse$json = {
  '1': 'ListNotificationsResponse',
  '2': [
    {
      '1': 'notifications',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.scheduling.v1.Notification',
      '10': 'notifications'
    },
  ],
};

/// Descriptor for `ListNotificationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNotificationsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0Tm90aWZpY2F0aW9uc1Jlc3BvbnNlEkwKDW5vdGlmaWNhdGlvbnMYASADKAsyJi5oZW'
        'FsdGhjYXJlLnNjaGVkdWxpbmcudjEuTm90aWZpY2F0aW9uUg1ub3RpZmljYXRpb25z');

const $core.Map<$core.String, $core.dynamic> AppointmentServiceBase$json = {
  '1': 'AppointmentService',
  '2': [
    {
      '1': 'DefineResource',
      '2': '.healthcare.scheduling.v1.DefineResourceRequest',
      '3': '.healthcare.scheduling.v1.DefineResourceResponse'
    },
    {
      '1': 'SetResourceStatus',
      '2': '.healthcare.scheduling.v1.SetResourceStatusRequest',
      '3': '.healthcare.scheduling.v1.SetResourceStatusResponse'
    },
    {
      '1': 'DefineSchedule',
      '2': '.healthcare.scheduling.v1.DefineScheduleRequest',
      '3': '.healthcare.scheduling.v1.DefineScheduleResponse'
    },
    {
      '1': 'BlockPeriod',
      '2': '.healthcare.scheduling.v1.BlockPeriodRequest',
      '3': '.healthcare.scheduling.v1.BlockPeriodResponse'
    },
    {
      '1': 'UnblockPeriod',
      '2': '.healthcare.scheduling.v1.UnblockPeriodRequest',
      '3': '.healthcare.scheduling.v1.UnblockPeriodResponse'
    },
    {
      '1': 'SearchSlots',
      '2': '.healthcare.scheduling.v1.SearchSlotsRequest',
      '3': '.healthcare.scheduling.v1.SearchSlotsResponse'
    },
    {
      '1': 'BookAppointment',
      '2': '.healthcare.scheduling.v1.BookAppointmentRequest',
      '3': '.healthcare.scheduling.v1.BookAppointmentResponse'
    },
    {
      '1': 'CancelAppointment',
      '2': '.healthcare.scheduling.v1.CancelAppointmentRequest',
      '3': '.healthcare.scheduling.v1.CancelAppointmentResponse'
    },
    {
      '1': 'RescheduleAppointment',
      '2': '.healthcare.scheduling.v1.RescheduleAppointmentRequest',
      '3': '.healthcare.scheduling.v1.RescheduleAppointmentResponse'
    },
    {
      '1': 'SetSchedulingPolicy',
      '2': '.healthcare.scheduling.v1.SetSchedulingPolicyRequest',
      '3': '.healthcare.scheduling.v1.SetSchedulingPolicyResponse'
    },
    {
      '1': 'BookSeries',
      '2': '.healthcare.scheduling.v1.BookSeriesRequest',
      '3': '.healthcare.scheduling.v1.BookSeriesResponse'
    },
    {
      '1': 'CancelSeries',
      '2': '.healthcare.scheduling.v1.CancelSeriesRequest',
      '3': '.healthcare.scheduling.v1.CancelSeriesResponse'
    },
    {
      '1': 'JoinWaitlist',
      '2': '.healthcare.scheduling.v1.JoinWaitlistRequest',
      '3': '.healthcare.scheduling.v1.JoinWaitlistResponse'
    },
    {
      '1': 'OfferWaitlistSlot',
      '2': '.healthcare.scheduling.v1.OfferWaitlistSlotRequest',
      '3': '.healthcare.scheduling.v1.OfferWaitlistSlotResponse'
    },
    {
      '1': 'AcceptWaitlistOffer',
      '2': '.healthcare.scheduling.v1.AcceptWaitlistOfferRequest',
      '3': '.healthcare.scheduling.v1.AcceptWaitlistOfferResponse'
    },
    {
      '1': 'DeclineWaitlistOffer',
      '2': '.healthcare.scheduling.v1.DeclineWaitlistOfferRequest',
      '3': '.healthcare.scheduling.v1.DeclineWaitlistOfferResponse'
    },
    {
      '1': 'ListWaitlist',
      '2': '.healthcare.scheduling.v1.ListWaitlistRequest',
      '3': '.healthcare.scheduling.v1.ListWaitlistResponse'
    },
    {
      '1': 'ExpireWaitlistOffers',
      '2': '.healthcare.scheduling.v1.ExpireWaitlistOffersRequest',
      '3': '.healthcare.scheduling.v1.ExpireWaitlistOffersResponse'
    },
    {
      '1': 'CheckIn',
      '2': '.healthcare.scheduling.v1.CheckInRequest',
      '3': '.healthcare.scheduling.v1.CheckInResponse'
    },
    {
      '1': 'AdvanceAppointment',
      '2': '.healthcare.scheduling.v1.AdvanceAppointmentRequest',
      '3': '.healthcare.scheduling.v1.AdvanceAppointmentResponse'
    },
    {
      '1': 'GetQueue',
      '2': '.healthcare.scheduling.v1.GetQueueRequest',
      '3': '.healthcare.scheduling.v1.GetQueueResponse'
    },
    {
      '1': 'RegisterWalkIn',
      '2': '.healthcare.scheduling.v1.RegisterWalkInRequest',
      '3': '.healthcare.scheduling.v1.RegisterWalkInResponse'
    },
    {
      '1': 'Reprioritise',
      '2': '.healthcare.scheduling.v1.ReprioritiseRequest',
      '3': '.healthcare.scheduling.v1.ReprioritiseResponse'
    },
    {
      '1': 'RecordDeliveryOutcome',
      '2': '.healthcare.scheduling.v1.RecordDeliveryOutcomeRequest',
      '3': '.healthcare.scheduling.v1.RecordDeliveryOutcomeResponse'
    },
    {
      '1': 'ListNotifications',
      '2': '.healthcare.scheduling.v1.ListNotificationsRequest',
      '3': '.healthcare.scheduling.v1.ListNotificationsResponse'
    },
    {
      '1': 'GetAppointment',
      '2': '.healthcare.scheduling.v1.GetAppointmentRequest',
      '3': '.healthcare.scheduling.v1.GetAppointmentResponse'
    },
    {
      '1': 'ListAppointments',
      '2': '.healthcare.scheduling.v1.ListAppointmentsRequest',
      '3': '.healthcare.scheduling.v1.ListAppointmentsResponse'
    },
  ],
};

@$core.Deprecated('Use appointmentServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    AppointmentServiceBase$messageJson = {
  '.healthcare.scheduling.v1.DefineResourceRequest': DefineResourceRequest$json,
  '.healthcare.scheduling.v1.DefineResourceResponse':
      DefineResourceResponse$json,
  '.healthcare.scheduling.v1.Resource': Resource$json,
  '.healthcare.scheduling.v1.SetResourceStatusRequest':
      SetResourceStatusRequest$json,
  '.healthcare.scheduling.v1.SetResourceStatusResponse':
      SetResourceStatusResponse$json,
  '.healthcare.scheduling.v1.DefineScheduleRequest': DefineScheduleRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.scheduling.v1.DefineScheduleResponse':
      DefineScheduleResponse$json,
  '.healthcare.scheduling.v1.Schedule': Schedule$json,
  '.healthcare.scheduling.v1.BlockPeriodRequest': BlockPeriodRequest$json,
  '.healthcare.scheduling.v1.BlockPeriodResponse': BlockPeriodResponse$json,
  '.healthcare.scheduling.v1.ScheduleException': ScheduleException$json,
  '.healthcare.scheduling.v1.UnblockPeriodRequest': UnblockPeriodRequest$json,
  '.healthcare.scheduling.v1.UnblockPeriodResponse': UnblockPeriodResponse$json,
  '.healthcare.scheduling.v1.SearchSlotsRequest': SearchSlotsRequest$json,
  '.healthcare.scheduling.v1.SearchSlotsResponse': SearchSlotsResponse$json,
  '.healthcare.scheduling.v1.Slot': Slot$json,
  '.healthcare.scheduling.v1.BookAppointmentRequest':
      BookAppointmentRequest$json,
  '.healthcare.scheduling.v1.BookAppointmentResponse':
      BookAppointmentResponse$json,
  '.healthcare.scheduling.v1.Appointment': Appointment$json,
  '.healthcare.scheduling.v1.StatusChange': StatusChange$json,
  '.healthcare.scheduling.v1.CancelAppointmentRequest':
      CancelAppointmentRequest$json,
  '.healthcare.scheduling.v1.CancelAppointmentResponse':
      CancelAppointmentResponse$json,
  '.healthcare.scheduling.v1.PolicyOutcome': PolicyOutcome$json,
  '.healthcare.scheduling.v1.RescheduleAppointmentRequest':
      RescheduleAppointmentRequest$json,
  '.healthcare.scheduling.v1.RescheduleAppointmentResponse':
      RescheduleAppointmentResponse$json,
  '.healthcare.scheduling.v1.SetSchedulingPolicyRequest':
      SetSchedulingPolicyRequest$json,
  '.healthcare.scheduling.v1.SchedulingPolicy': SchedulingPolicy$json,
  '.healthcare.scheduling.v1.SetSchedulingPolicyResponse':
      SetSchedulingPolicyResponse$json,
  '.healthcare.scheduling.v1.BookSeriesRequest': BookSeriesRequest$json,
  '.healthcare.scheduling.v1.BookSeriesResponse': BookSeriesResponse$json,
  '.healthcare.scheduling.v1.CancelSeriesRequest': CancelSeriesRequest$json,
  '.healthcare.scheduling.v1.CancelSeriesResponse': CancelSeriesResponse$json,
  '.healthcare.scheduling.v1.JoinWaitlistRequest': JoinWaitlistRequest$json,
  '.healthcare.scheduling.v1.JoinWaitlistResponse': JoinWaitlistResponse$json,
  '.healthcare.scheduling.v1.WaitlistEntry': WaitlistEntry$json,
  '.healthcare.scheduling.v1.OfferWaitlistSlotRequest':
      OfferWaitlistSlotRequest$json,
  '.healthcare.scheduling.v1.OfferWaitlistSlotResponse':
      OfferWaitlistSlotResponse$json,
  '.healthcare.scheduling.v1.AcceptWaitlistOfferRequest':
      AcceptWaitlistOfferRequest$json,
  '.healthcare.scheduling.v1.AcceptWaitlistOfferResponse':
      AcceptWaitlistOfferResponse$json,
  '.healthcare.scheduling.v1.DeclineWaitlistOfferRequest':
      DeclineWaitlistOfferRequest$json,
  '.healthcare.scheduling.v1.DeclineWaitlistOfferResponse':
      DeclineWaitlistOfferResponse$json,
  '.healthcare.scheduling.v1.ListWaitlistRequest': ListWaitlistRequest$json,
  '.healthcare.scheduling.v1.ListWaitlistResponse': ListWaitlistResponse$json,
  '.healthcare.scheduling.v1.ExpireWaitlistOffersRequest':
      ExpireWaitlistOffersRequest$json,
  '.healthcare.scheduling.v1.ExpireWaitlistOffersResponse':
      ExpireWaitlistOffersResponse$json,
  '.healthcare.scheduling.v1.CheckInRequest': CheckInRequest$json,
  '.healthcare.scheduling.v1.CheckInResponse': CheckInResponse$json,
  '.healthcare.scheduling.v1.AdvanceAppointmentRequest':
      AdvanceAppointmentRequest$json,
  '.healthcare.scheduling.v1.AdvanceAppointmentResponse':
      AdvanceAppointmentResponse$json,
  '.healthcare.scheduling.v1.GetQueueRequest': GetQueueRequest$json,
  '.healthcare.scheduling.v1.GetQueueResponse': GetQueueResponse$json,
  '.healthcare.scheduling.v1.QueuePosition': QueuePosition$json,
  '.healthcare.scheduling.v1.QueueEstimate': QueueEstimate$json,
  '.healthcare.scheduling.v1.RegisterWalkInRequest': RegisterWalkInRequest$json,
  '.healthcare.scheduling.v1.RegisterWalkInResponse':
      RegisterWalkInResponse$json,
  '.healthcare.scheduling.v1.ReprioritiseRequest': ReprioritiseRequest$json,
  '.healthcare.scheduling.v1.ReprioritiseResponse': ReprioritiseResponse$json,
  '.healthcare.scheduling.v1.RecordDeliveryOutcomeRequest':
      RecordDeliveryOutcomeRequest$json,
  '.healthcare.scheduling.v1.RecordDeliveryOutcomeResponse':
      RecordDeliveryOutcomeResponse$json,
  '.healthcare.scheduling.v1.Notification': Notification$json,
  '.healthcare.scheduling.v1.ListNotificationsRequest':
      ListNotificationsRequest$json,
  '.healthcare.scheduling.v1.ListNotificationsResponse':
      ListNotificationsResponse$json,
  '.healthcare.scheduling.v1.GetAppointmentRequest': GetAppointmentRequest$json,
  '.healthcare.scheduling.v1.GetAppointmentResponse':
      GetAppointmentResponse$json,
  '.healthcare.scheduling.v1.ListAppointmentsRequest':
      ListAppointmentsRequest$json,
  '.healthcare.scheduling.v1.ListAppointmentsResponse':
      ListAppointmentsResponse$json,
};

/// Descriptor for `AppointmentService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List appointmentServiceDescriptor = $convert.base64Decode(
    'ChJBcHBvaW50bWVudFNlcnZpY2UScwoORGVmaW5lUmVzb3VyY2USLy5oZWFsdGhjYXJlLnNjaG'
    'VkdWxpbmcudjEuRGVmaW5lUmVzb3VyY2VSZXF1ZXN0GjAuaGVhbHRoY2FyZS5zY2hlZHVsaW5n'
    'LnYxLkRlZmluZVJlc291cmNlUmVzcG9uc2USfAoRU2V0UmVzb3VyY2VTdGF0dXMSMi5oZWFsdG'
    'hjYXJlLnNjaGVkdWxpbmcudjEuU2V0UmVzb3VyY2VTdGF0dXNSZXF1ZXN0GjMuaGVhbHRoY2Fy'
    'ZS5zY2hlZHVsaW5nLnYxLlNldFJlc291cmNlU3RhdHVzUmVzcG9uc2UScwoORGVmaW5lU2NoZW'
    'R1bGUSLy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuRGVmaW5lU2NoZWR1bGVSZXF1ZXN0GjAu'
    'aGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkRlZmluZVNjaGVkdWxlUmVzcG9uc2USagoLQmxvY2'
    'tQZXJpb2QSLC5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQmxvY2tQZXJpb2RSZXF1ZXN0Gi0u'
    'aGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkJsb2NrUGVyaW9kUmVzcG9uc2UScAoNVW5ibG9ja1'
    'BlcmlvZBIuLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5VbmJsb2NrUGVyaW9kUmVxdWVzdBov'
    'LmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5VbmJsb2NrUGVyaW9kUmVzcG9uc2USagoLU2Vhcm'
    'NoU2xvdHMSLC5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuU2VhcmNoU2xvdHNSZXF1ZXN0Gi0u'
    'aGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlNlYXJjaFNsb3RzUmVzcG9uc2USdgoPQm9va0FwcG'
    '9pbnRtZW50EjAuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkJvb2tBcHBvaW50bWVudFJlcXVl'
    'c3QaMS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQm9va0FwcG9pbnRtZW50UmVzcG9uc2USfA'
    'oRQ2FuY2VsQXBwb2ludG1lbnQSMi5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQ2FuY2VsQXBw'
    'b2ludG1lbnRSZXF1ZXN0GjMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkNhbmNlbEFwcG9pbn'
    'RtZW50UmVzcG9uc2USiAEKFVJlc2NoZWR1bGVBcHBvaW50bWVudBI2LmhlYWx0aGNhcmUuc2No'
    'ZWR1bGluZy52MS5SZXNjaGVkdWxlQXBwb2ludG1lbnRSZXF1ZXN0GjcuaGVhbHRoY2FyZS5zY2'
    'hlZHVsaW5nLnYxLlJlc2NoZWR1bGVBcHBvaW50bWVudFJlc3BvbnNlEoIBChNTZXRTY2hlZHVs'
    'aW5nUG9saWN5EjQuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlNldFNjaGVkdWxpbmdQb2xpY3'
    'lSZXF1ZXN0GjUuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlNldFNjaGVkdWxpbmdQb2xpY3lS'
    'ZXNwb25zZRJnCgpCb29rU2VyaWVzEisuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkJvb2tTZX'
    'JpZXNSZXF1ZXN0GiwuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkJvb2tTZXJpZXNSZXNwb25z'
    'ZRJtCgxDYW5jZWxTZXJpZXMSLS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuQ2FuY2VsU2VyaW'
    'VzUmVxdWVzdBouLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5DYW5jZWxTZXJpZXNSZXNwb25z'
    'ZRJtCgxKb2luV2FpdGxpc3QSLS5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuSm9pbldhaXRsaX'
    'N0UmVxdWVzdBouLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5Kb2luV2FpdGxpc3RSZXNwb25z'
    'ZRJ8ChFPZmZlcldhaXRsaXN0U2xvdBIyLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5PZmZlcl'
    'dhaXRsaXN0U2xvdFJlcXVlc3QaMy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuT2ZmZXJXYWl0'
    'bGlzdFNsb3RSZXNwb25zZRKCAQoTQWNjZXB0V2FpdGxpc3RPZmZlchI0LmhlYWx0aGNhcmUuc2'
    'NoZWR1bGluZy52MS5BY2NlcHRXYWl0bGlzdE9mZmVyUmVxdWVzdBo1LmhlYWx0aGNhcmUuc2No'
    'ZWR1bGluZy52MS5BY2NlcHRXYWl0bGlzdE9mZmVyUmVzcG9uc2UShQEKFERlY2xpbmVXYWl0bG'
    'lzdE9mZmVyEjUuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkRlY2xpbmVXYWl0bGlzdE9mZmVy'
    'UmVxdWVzdBo2LmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5EZWNsaW5lV2FpdGxpc3RPZmZlcl'
    'Jlc3BvbnNlEm0KDExpc3RXYWl0bGlzdBItLmhlYWx0aGNhcmUuc2NoZWR1bGluZy52MS5MaXN0'
    'V2FpdGxpc3RSZXF1ZXN0Gi4uaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkxpc3RXYWl0bGlzdF'
    'Jlc3BvbnNlEoUBChRFeHBpcmVXYWl0bGlzdE9mZmVycxI1LmhlYWx0aGNhcmUuc2NoZWR1bGlu'
    'Zy52MS5FeHBpcmVXYWl0bGlzdE9mZmVyc1JlcXVlc3QaNi5oZWFsdGhjYXJlLnNjaGVkdWxpbm'
    'cudjEuRXhwaXJlV2FpdGxpc3RPZmZlcnNSZXNwb25zZRJeCgdDaGVja0luEiguaGVhbHRoY2Fy'
    'ZS5zY2hlZHVsaW5nLnYxLkNoZWNrSW5SZXF1ZXN0GikuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLn'
    'YxLkNoZWNrSW5SZXNwb25zZRJ/ChJBZHZhbmNlQXBwb2ludG1lbnQSMy5oZWFsdGhjYXJlLnNj'
    'aGVkdWxpbmcudjEuQWR2YW5jZUFwcG9pbnRtZW50UmVxdWVzdBo0LmhlYWx0aGNhcmUuc2NoZW'
    'R1bGluZy52MS5BZHZhbmNlQXBwb2ludG1lbnRSZXNwb25zZRJhCghHZXRRdWV1ZRIpLmhlYWx0'
    'aGNhcmUuc2NoZWR1bGluZy52MS5HZXRRdWV1ZVJlcXVlc3QaKi5oZWFsdGhjYXJlLnNjaGVkdW'
    'xpbmcudjEuR2V0UXVldWVSZXNwb25zZRJzCg5SZWdpc3RlcldhbGtJbhIvLmhlYWx0aGNhcmUu'
    'c2NoZWR1bGluZy52MS5SZWdpc3RlcldhbGtJblJlcXVlc3QaMC5oZWFsdGhjYXJlLnNjaGVkdW'
    'xpbmcudjEuUmVnaXN0ZXJXYWxrSW5SZXNwb25zZRJtCgxSZXByaW9yaXRpc2USLS5oZWFsdGhj'
    'YXJlLnNjaGVkdWxpbmcudjEuUmVwcmlvcml0aXNlUmVxdWVzdBouLmhlYWx0aGNhcmUuc2NoZW'
    'R1bGluZy52MS5SZXByaW9yaXRpc2VSZXNwb25zZRKIAQoVUmVjb3JkRGVsaXZlcnlPdXRjb21l'
    'EjYuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLlJlY29yZERlbGl2ZXJ5T3V0Y29tZVJlcXVlc3'
    'QaNy5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuUmVjb3JkRGVsaXZlcnlPdXRjb21lUmVzcG9u'
    'c2USfAoRTGlzdE5vdGlmaWNhdGlvbnMSMi5oZWFsdGhjYXJlLnNjaGVkdWxpbmcudjEuTGlzdE'
    '5vdGlmaWNhdGlvbnNSZXF1ZXN0GjMuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYxLkxpc3ROb3Rp'
    'ZmljYXRpb25zUmVzcG9uc2UScwoOR2V0QXBwb2ludG1lbnQSLy5oZWFsdGhjYXJlLnNjaGVkdW'
    'xpbmcudjEuR2V0QXBwb2ludG1lbnRSZXF1ZXN0GjAuaGVhbHRoY2FyZS5zY2hlZHVsaW5nLnYx'
    'LkdldEFwcG9pbnRtZW50UmVzcG9uc2USeQoQTGlzdEFwcG9pbnRtZW50cxIxLmhlYWx0aGNhcm'
    'Uuc2NoZWR1bGluZy52MS5MaXN0QXBwb2ludG1lbnRzUmVxdWVzdBoyLmhlYWx0aGNhcmUuc2No'
    'ZWR1bGluZy52MS5MaXN0QXBwb2ludG1lbnRzUmVzcG9uc2U=');
