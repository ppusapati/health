// This is a generated file - do not edit.
//
// Generated from healthcare/medication/v1/medication.proto.

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

@$core.Deprecated('Use therapyStatusDescriptor instead')
const TherapyStatus$json = {
  '1': 'TherapyStatus',
  '2': [
    {'1': 'THERAPY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'THERAPY_STATUS_DRAFT', '2': 1},
    {'1': 'THERAPY_STATUS_ACTIVE', '2': 2},
    {'1': 'THERAPY_STATUS_HELD', '2': 3},
    {'1': 'THERAPY_STATUS_DISCONTINUED', '2': 4},
    {'1': 'THERAPY_STATUS_COMPLETED', '2': 5},
  ],
};

/// Descriptor for `TherapyStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List therapyStatusDescriptor = $convert.base64Decode(
    'Cg1UaGVyYXB5U3RhdHVzEh4KGlRIRVJBUFlfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUVEhFUk'
    'FQWV9TVEFUVVNfRFJBRlQQARIZChVUSEVSQVBZX1NUQVRVU19BQ1RJVkUQAhIXChNUSEVSQVBZ'
    'X1NUQVRVU19IRUxEEAMSHwobVEhFUkFQWV9TVEFUVVNfRElTQ09OVElOVUVEEAQSHAoYVEhFUk'
    'FQWV9TVEFUVVNfQ09NUExFVEVEEAU=');

@$core.Deprecated('Use stopConditionKindDescriptor instead')
const StopConditionKind$json = {
  '1': 'StopConditionKind',
  '2': [
    {'1': 'STOP_CONDITION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'STOP_CONDITION_KIND_AT_TIME', '2': 1},
    {'1': 'STOP_CONDITION_KIND_AFTER_DOSES', '2': 2},
    {'1': 'STOP_CONDITION_KIND_ON_CONDITION', '2': 3},
    {'1': 'STOP_CONDITION_KIND_NONE', '2': 4},
  ],
};

/// Descriptor for `StopConditionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stopConditionKindDescriptor = $convert.base64Decode(
    'ChFTdG9wQ29uZGl0aW9uS2luZBIjCh9TVE9QX0NPTkRJVElPTl9LSU5EX1VOU1BFQ0lGSUVEEA'
    'ASHwobU1RPUF9DT05ESVRJT05fS0lORF9BVF9USU1FEAESIwofU1RPUF9DT05ESVRJT05fS0lO'
    'RF9BRlRFUl9ET1NFUxACEiQKIFNUT1BfQ09ORElUSU9OX0tJTkRfT05fQ09ORElUSU9OEAMSHA'
    'oYU1RPUF9DT05ESVRJT05fS0lORF9OT05FEAQ=');

@$core.Deprecated('Use findingKindDescriptor instead')
const FindingKind$json = {
  '1': 'FindingKind',
  '2': [
    {'1': 'FINDING_KIND_UNSPECIFIED', '2': 0},
    {'1': 'FINDING_KIND_ALLERGY', '2': 1},
    {'1': 'FINDING_KIND_INTERACTION', '2': 2},
    {'1': 'FINDING_KIND_DUPLICATE_THERAPY', '2': 3},
    {'1': 'FINDING_KIND_DOSE_SUPPORT', '2': 4},
  ],
};

/// Descriptor for `FindingKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List findingKindDescriptor = $convert.base64Decode(
    'CgtGaW5kaW5nS2luZBIcChhGSU5ESU5HX0tJTkRfVU5TUEVDSUZJRUQQABIYChRGSU5ESU5HX0'
    'tJTkRfQUxMRVJHWRABEhwKGEZJTkRJTkdfS0lORF9JTlRFUkFDVElPThACEiIKHkZJTkRJTkdf'
    'S0lORF9EVVBMSUNBVEVfVEhFUkFQWRADEh0KGUZJTkRJTkdfS0lORF9ET1NFX1NVUFBPUlQQBA'
    '==');

@$core.Deprecated('Use severityDescriptor instead')
const Severity$json = {
  '1': 'Severity',
  '2': [
    {'1': 'SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'SEVERITY_CONTRAINDICATED', '2': 1},
    {'1': 'SEVERITY_SEVERE', '2': 2},
    {'1': 'SEVERITY_MODERATE', '2': 3},
    {'1': 'SEVERITY_MILD', '2': 4},
    {'1': 'SEVERITY_INFORMATIONAL', '2': 5},
  ],
};

/// Descriptor for `Severity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List severityDescriptor = $convert.base64Decode(
    'CghTZXZlcml0eRIYChRTRVZFUklUWV9VTlNQRUNJRklFRBAAEhwKGFNFVkVSSVRZX0NPTlRSQU'
    'lORElDQVRFRBABEhMKD1NFVkVSSVRZX1NFVkVSRRACEhUKEVNFVkVSSVRZX01PREVSQVRFEAMS'
    'EQoNU0VWRVJJVFlfTUlMRBAEEhoKFlNFVkVSSVRZX0lORk9STUFUSU9OQUwQBQ==');

@$core.Deprecated('Use formularyStatusDescriptor instead')
const FormularyStatus$json = {
  '1': 'FormularyStatus',
  '2': [
    {'1': 'FORMULARY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'FORMULARY_STATUS_FORMULARY', '2': 1},
    {'1': 'FORMULARY_STATUS_RESTRICTED', '2': 2},
    {'1': 'FORMULARY_STATUS_NON_FORMULARY', '2': 3},
    {'1': 'FORMULARY_STATUS_UNKNOWN', '2': 4},
  ],
};

/// Descriptor for `FormularyStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List formularyStatusDescriptor = $convert.base64Decode(
    'Cg9Gb3JtdWxhcnlTdGF0dXMSIAocRk9STVVMQVJZX1NUQVRVU19VTlNQRUNJRklFRBAAEh4KGk'
    'ZPUk1VTEFSWV9TVEFUVVNfRk9STVVMQVJZEAESHwobRk9STVVMQVJZX1NUQVRVU19SRVNUUklD'
    'VEVEEAISIgoeRk9STVVMQVJZX1NUQVRVU19OT05fRk9STVVMQVJZEAMSHAoYRk9STVVMQVJZX1'
    'NUQVRVU19VTktOT1dOEAQ=');

@$core.Deprecated('Use homeMedicationSourceDescriptor instead')
const HomeMedicationSource$json = {
  '1': 'HomeMedicationSource',
  '2': [
    {'1': 'HOME_MEDICATION_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'HOME_MEDICATION_SOURCE_PATIENT', '2': 1},
    {'1': 'HOME_MEDICATION_SOURCE_CARER', '2': 2},
    {'1': 'HOME_MEDICATION_SOURCE_GP_RECORD', '2': 3},
    {'1': 'HOME_MEDICATION_SOURCE_PHARMACY', '2': 4},
    {'1': 'HOME_MEDICATION_SOURCE_PREVIOUS_STAY', '2': 5},
    {'1': 'HOME_MEDICATION_SOURCE_MEDICATION_BAG', '2': 6},
  ],
};

/// Descriptor for `HomeMedicationSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List homeMedicationSourceDescriptor = $convert.base64Decode(
    'ChRIb21lTWVkaWNhdGlvblNvdXJjZRImCiJIT01FX01FRElDQVRJT05fU09VUkNFX1VOU1BFQ0'
    'lGSUVEEAASIgoeSE9NRV9NRURJQ0FUSU9OX1NPVVJDRV9QQVRJRU5UEAESIAocSE9NRV9NRURJ'
    'Q0FUSU9OX1NPVVJDRV9DQVJFUhACEiQKIEhPTUVfTUVESUNBVElPTl9TT1VSQ0VfR1BfUkVDT1'
    'JEEAMSIwofSE9NRV9NRURJQ0FUSU9OX1NPVVJDRV9QSEFSTUFDWRAEEigKJEhPTUVfTUVESUNB'
    'VElPTl9TT1VSQ0VfUFJFVklPVVNfU1RBWRAFEikKJUhPTUVfTUVESUNBVElPTl9TT1VSQ0VfTU'
    'VESUNBVElPTl9CQUcQBg==');

@$core.Deprecated('Use dispositionDescriptor instead')
const Disposition$json = {
  '1': 'Disposition',
  '2': [
    {'1': 'DISPOSITION_UNSPECIFIED', '2': 0},
    {'1': 'DISPOSITION_PENDING', '2': 1},
    {'1': 'DISPOSITION_CONTINUE', '2': 2},
    {'1': 'DISPOSITION_STOP', '2': 3},
    {'1': 'DISPOSITION_CHANGE', '2': 4},
    {'1': 'DISPOSITION_UNKNOWN', '2': 5},
  ],
};

/// Descriptor for `Disposition`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List dispositionDescriptor = $convert.base64Decode(
    'CgtEaXNwb3NpdGlvbhIbChdESVNQT1NJVElPTl9VTlNQRUNJRklFRBAAEhcKE0RJU1BPU0lUSU'
    '9OX1BFTkRJTkcQARIYChRESVNQT1NJVElPTl9DT05USU5VRRACEhQKEERJU1BPU0lUSU9OX1NU'
    'T1AQAxIWChJESVNQT1NJVElPTl9DSEFOR0UQBBIXChNESVNQT1NJVElPTl9VTktOT1dOEAU=');

@$core.Deprecated('Use reconciliationEventDescriptor instead')
const ReconciliationEvent$json = {
  '1': 'ReconciliationEvent',
  '2': [
    {'1': 'RECONCILIATION_EVENT_UNSPECIFIED', '2': 0},
    {'1': 'RECONCILIATION_EVENT_ADMISSION', '2': 1},
    {'1': 'RECONCILIATION_EVENT_TRANSFER', '2': 2},
    {'1': 'RECONCILIATION_EVENT_DISCHARGE', '2': 3},
  ],
};

/// Descriptor for `ReconciliationEvent`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reconciliationEventDescriptor = $convert.base64Decode(
    'ChNSZWNvbmNpbGlhdGlvbkV2ZW50EiQKIFJFQ09OQ0lMSUFUSU9OX0VWRU5UX1VOU1BFQ0lGSU'
    'VEEAASIgoeUkVDT05DSUxJQVRJT05fRVZFTlRfQURNSVNTSU9OEAESIQodUkVDT05DSUxJQVRJ'
    'T05fRVZFTlRfVFJBTlNGRVIQAhIiCh5SRUNPTkNJTElBVElPTl9FVkVOVF9ESVNDSEFSR0UQAw'
    '==');

@$core.Deprecated('Use substitutionKindDescriptor instead')
const SubstitutionKind$json = {
  '1': 'SubstitutionKind',
  '2': [
    {'1': 'SUBSTITUTION_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SUBSTITUTION_KIND_GENERIC', '2': 1},
    {'1': 'SUBSTITUTION_KIND_THERAPEUTIC', '2': 2},
    {'1': 'SUBSTITUTION_KIND_FORMULARY', '2': 3},
    {'1': 'SUBSTITUTION_KIND_STOCK', '2': 4},
  ],
};

/// Descriptor for `SubstitutionKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List substitutionKindDescriptor = $convert.base64Decode(
    'ChBTdWJzdGl0dXRpb25LaW5kEiEKHVNVQlNUSVRVVElPTl9LSU5EX1VOU1BFQ0lGSUVEEAASHQ'
    'oZU1VCU1RJVFVUSU9OX0tJTkRfR0VORVJJQxABEiEKHVNVQlNUSVRVVElPTl9LSU5EX1RIRVJB'
    'UEVVVElDEAISHwobU1VCU1RJVFVUSU9OX0tJTkRfRk9STVVMQVJZEAMSGwoXU1VCU1RJVFVUSU'
    '9OX0tJTkRfU1RPQ0sQBA==');

@$core.Deprecated('Use substitutionStatusDescriptor instead')
const SubstitutionStatus$json = {
  '1': 'SubstitutionStatus',
  '2': [
    {'1': 'SUBSTITUTION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SUBSTITUTION_STATUS_PROPOSED', '2': 1},
    {'1': 'SUBSTITUTION_STATUS_ACCEPTED', '2': 2},
    {'1': 'SUBSTITUTION_STATUS_REJECTED', '2': 3},
    {'1': 'SUBSTITUTION_STATUS_DISPENSED', '2': 4},
  ],
};

/// Descriptor for `SubstitutionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List substitutionStatusDescriptor = $convert.base64Decode(
    'ChJTdWJzdGl0dXRpb25TdGF0dXMSIwofU1VCU1RJVFVUSU9OX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEiAKHFNVQlNUSVRVVElPTl9TVEFUVVNfUFJPUE9TRUQQARIgChxTVUJTVElUVVRJT05fU1RB'
    'VFVTX0FDQ0VQVEVEEAISIAocU1VCU1RJVFVUSU9OX1NUQVRVU19SRUpFQ1RFRBADEiEKHVNVQl'
    'NUSVRVVElPTl9TVEFUVVNfRElTUEVOU0VEEAQ=');

@$core.Deprecated('Use doseRuleScopeDescriptor instead')
const DoseRuleScope$json = {
  '1': 'DoseRuleScope',
  '2': [
    {'1': 'DOSE_RULE_SCOPE_UNSPECIFIED', '2': 0},
    {'1': 'DOSE_RULE_SCOPE_RENAL', '2': 1},
    {'1': 'DOSE_RULE_SCOPE_HEPATIC', '2': 2},
    {'1': 'DOSE_RULE_SCOPE_PAEDIATRIC', '2': 3},
  ],
};

/// Descriptor for `DoseRuleScope`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List doseRuleScopeDescriptor = $convert.base64Decode(
    'Cg1Eb3NlUnVsZVNjb3BlEh8KG0RPU0VfUlVMRV9TQ09QRV9VTlNQRUNJRklFRBAAEhkKFURPU0'
    'VfUlVMRV9TQ09QRV9SRU5BTBABEhsKF0RPU0VfUlVMRV9TQ09QRV9IRVBBVElDEAISHgoaRE9T'
    'RV9SVUxFX1NDT1BFX1BBRURJQVRSSUMQAw==');

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

@$core.Deprecated('Use stopConditionDescriptor instead')
const StopCondition$json = {
  '1': 'StopCondition',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.StopConditionKind',
      '10': 'kind'
    },
    {
      '1': 'at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'doses', '3': 3, '4': 1, '5': 5, '10': 'doses'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '10': 'text'},
  ],
};

/// Descriptor for `StopCondition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopConditionDescriptor = $convert.base64Decode(
    'Cg1TdG9wQ29uZGl0aW9uEj8KBGtpbmQYASABKA4yKy5oZWFsdGhjYXJlLm1lZGljYXRpb24udj'
    'EuU3RvcENvbmRpdGlvbktpbmRSBGtpbmQSKgoCYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgJhdBIUCgVkb3NlcxgDIAEoBVIFZG9zZXMSEgoEdGV4dBgEIAEoCVIEdGV4dA'
    '==');

@$core.Deprecated('Use timingDescriptor instead')
const Timing$json = {
  '1': 'Timing',
  '2': [
    {'1': 'frequency_text', '3': 1, '4': 1, '5': 9, '10': 'frequencyText'},
    {'1': 'interval_seconds', '3': 2, '4': 1, '5': 3, '10': 'intervalSeconds'},
    {'1': 'times_of_day', '3': 3, '4': 3, '5': 5, '10': 'timesOfDay'},
    {'1': 'days_of_week', '3': 4, '4': 3, '5': 5, '10': 'daysOfWeek'},
    {'1': 'prn', '3': 5, '4': 1, '5': 8, '10': 'prn'},
    {'1': 'duration_seconds', '3': 6, '4': 1, '5': 3, '10': 'durationSeconds'},
  ],
};

/// Descriptor for `Timing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timingDescriptor = $convert.base64Decode(
    'CgZUaW1pbmcSJQoOZnJlcXVlbmN5X3RleHQYASABKAlSDWZyZXF1ZW5jeVRleHQSKQoQaW50ZX'
    'J2YWxfc2Vjb25kcxgCIAEoA1IPaW50ZXJ2YWxTZWNvbmRzEiAKDHRpbWVzX29mX2RheRgDIAMo'
    'BVIKdGltZXNPZkRheRIgCgxkYXlzX29mX3dlZWsYBCADKAVSCmRheXNPZldlZWsSEAoDcHJuGA'
    'UgASgIUgNwcm4SKQoQZHVyYXRpb25fc2Vjb25kcxgGIAEoA1IPZHVyYXRpb25TZWNvbmRz');

@$core.Deprecated('Use doseSegmentDescriptor instead')
const DoseSegment$json = {
  '1': 'DoseSegment',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 5, '10': 'sequence'},
    {
      '1': 'dose',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Quantity',
      '10': 'dose'
    },
    {'1': 'free_text_dose', '3': 3, '4': 1, '5': 9, '10': 'freeTextDose'},
    {
      '1': 'timing',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Timing',
      '10': 'timing'
    },
    {
      '1': 'starts_at',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'ends_at',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endsAt'
    },
    {'1': 'note', '3': 7, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `DoseSegment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doseSegmentDescriptor = $convert.base64Decode(
    'CgtEb3NlU2VnbWVudBIaCghzZXF1ZW5jZRgBIAEoBVIIc2VxdWVuY2USNgoEZG9zZRgCIAEoCz'
    'IiLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5RdWFudGl0eVIEZG9zZRIkCg5mcmVlX3RleHRf'
    'ZG9zZRgDIAEoCVIMZnJlZVRleHREb3NlEjgKBnRpbWluZxgEIAEoCzIgLmhlYWx0aGNhcmUubW'
    'VkaWNhdGlvbi52MS5UaW1pbmdSBnRpbWluZxI3CglzdGFydHNfYXQYBSABKAsyGi5nb29nbGUu'
    'cHJvdG9idWYuVGltZXN0YW1wUghzdGFydHNBdBIzCgdlbmRzX2F0GAYgASgLMhouZ29vZ2xlLn'
    'Byb3RvYnVmLlRpbWVzdGFtcFIGZW5kc0F0EhIKBG5vdGUYByABKAlSBG5vdGU=');

@$core.Deprecated('Use prnConstraintDescriptor instead')
const PrnConstraint$json = {
  '1': 'PrnConstraint',
  '2': [
    {'1': 'indication', '3': 1, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'min_interval_seconds',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'minIntervalSeconds'
    },
    {'1': 'max_doses', '3': 3, '4': 1, '5': 5, '10': 'maxDoses'},
    {
      '1': 'max_dose_total',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Quantity',
      '10': 'maxDoseTotal'
    },
    {'1': 'period_seconds', '3': 5, '4': 1, '5': 3, '10': 'periodSeconds'},
  ],
};

/// Descriptor for `PrnConstraint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prnConstraintDescriptor = $convert.base64Decode(
    'Cg1Qcm5Db25zdHJhaW50Eh4KCmluZGljYXRpb24YASABKAlSCmluZGljYXRpb24SMAoUbWluX2'
    'ludGVydmFsX3NlY29uZHMYAiABKANSEm1pbkludGVydmFsU2Vjb25kcxIbCgltYXhfZG9zZXMY'
    'AyABKAVSCG1heERvc2VzEkgKDm1heF9kb3NlX3RvdGFsGAQgASgLMiIuaGVhbHRoY2FyZS5tZW'
    'RpY2F0aW9uLnYxLlF1YW50aXR5UgxtYXhEb3NlVG90YWwSJQoOcGVyaW9kX3NlY29uZHMYBSAB'
    'KANSDXBlcmlvZFNlY29uZHM=');

@$core.Deprecated('Use safetyFindingDescriptor instead')
const SafetyFinding$json = {
  '1': 'SafetyFinding',
  '2': [
    {
      '1': 'kind',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.FindingKind',
      '10': 'kind'
    },
    {
      '1': 'severity',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.Severity',
      '10': 'severity'
    },
    {'1': 'rule_id', '3': 3, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'rule_version', '3': 4, '4': 1, '5': 9, '10': 'ruleVersion'},
    {'1': 'summary', '3': 5, '4': 1, '5': 9, '10': 'summary'},
    {
      '1': 'subjects',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'subjects'
    },
    {
      '1': 'inputs',
      '3': 7,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.SafetyFinding.InputsEntry',
      '10': 'inputs'
    },
    {
      '1': 'override',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Override',
      '10': 'override'
    },
  ],
  '3': [SafetyFinding_InputsEntry$json],
};

@$core.Deprecated('Use safetyFindingDescriptor instead')
const SafetyFinding_InputsEntry$json = {
  '1': 'InputsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SafetyFinding`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List safetyFindingDescriptor = $convert.base64Decode(
    'Cg1TYWZldHlGaW5kaW5nEjkKBGtpbmQYASABKA4yJS5oZWFsdGhjYXJlLm1lZGljYXRpb24udj'
    'EuRmluZGluZ0tpbmRSBGtpbmQSPgoIc2V2ZXJpdHkYAiABKA4yIi5oZWFsdGhjYXJlLm1lZGlj'
    'YXRpb24udjEuU2V2ZXJpdHlSCHNldmVyaXR5EhcKB3J1bGVfaWQYAyABKAlSBnJ1bGVJZBIhCg'
    'xydWxlX3ZlcnNpb24YBCABKAlSC3J1bGVWZXJzaW9uEhgKB3N1bW1hcnkYBSABKAlSB3N1bW1h'
    'cnkSPAoIc3ViamVjdHMYBiADKAsyIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUg'
    'hzdWJqZWN0cxJLCgZpbnB1dHMYByADKAsyMy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuU2Fm'
    'ZXR5RmluZGluZy5JbnB1dHNFbnRyeVIGaW5wdXRzEj4KCG92ZXJyaWRlGAggASgLMiIuaGVhbH'
    'RoY2FyZS5tZWRpY2F0aW9uLnYxLk92ZXJyaWRlUghvdmVycmlkZRo5CgtJbnB1dHNFbnRyeRIQ'
    'CgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use overrideDescriptor instead')
const Override$json = {
  '1': 'Override',
  '2': [
    {'1': 'by', '3': 1, '4': 1, '5': 9, '10': 'by'},
    {
      '1': 'at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `Override`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideDescriptor = $convert.base64Decode(
    'CghPdmVycmlkZRIOCgJieRgBIAEoCVICYnkSKgoCYXQYAiABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgJhdBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use formularyDecisionDescriptor instead')
const FormularyDecision$json = {
  '1': 'FormularyDecision',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.FormularyStatus',
      '10': 'status'
    },
    {'1': 'scope', '3': 2, '4': 1, '5': 9, '10': 'scope'},
    {'1': 'scope_id', '3': 3, '4': 1, '5': 9, '10': 'scopeId'},
    {'1': 'restriction', '3': 4, '4': 1, '5': 9, '10': 'restriction'},
    {'1': 'approval_path', '3': 5, '4': 1, '5': 9, '10': 'approvalPath'},
  ],
};

/// Descriptor for `FormularyDecision`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formularyDecisionDescriptor = $convert.base64Decode(
    'ChFGb3JtdWxhcnlEZWNpc2lvbhJBCgZzdGF0dXMYASABKA4yKS5oZWFsdGhjYXJlLm1lZGljYX'
    'Rpb24udjEuRm9ybXVsYXJ5U3RhdHVzUgZzdGF0dXMSFAoFc2NvcGUYAiABKAlSBXNjb3BlEhkK'
    'CHNjb3BlX2lkGAMgASgJUgdzY29wZUlkEiAKC3Jlc3RyaWN0aW9uGAQgASgJUgtyZXN0cmljdG'
    'lvbhIjCg1hcHByb3ZhbF9wYXRoGAUgASgJUgxhcHByb3ZhbFBhdGg=');

@$core.Deprecated('Use verificationDescriptor instead')
const Verification$json = {
  '1': 'Verification',
  '2': [
    {'1': 'by', '3': 1, '4': 1, '5': 9, '10': 'by'},
    {
      '1': 'at',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'at'
    },
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `Verification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationDescriptor = $convert.base64Decode(
    'CgxWZXJpZmljYXRpb24SDgoCYnkYASABKAlSAmJ5EioKAmF0GAIgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFICYXQSEgoEbm90ZRgDIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use therapyChangeDescriptor instead')
const TherapyChange$json = {
  '1': 'TherapyChange',
  '2': [
    {
      '1': 'from_status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.TherapyStatus',
      '10': 'fromStatus'
    },
    {
      '1': 'to_status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.TherapyStatus',
      '10': 'toStatus'
    },
    {
      '1': 'effective_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
    {
      '1': 'recorded_at',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'recordedAt'
    },
    {'1': 'changed_by', '3': 5, '4': 1, '5': 9, '10': 'changedBy'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `TherapyChange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List therapyChangeDescriptor = $convert.base64Decode(
    'Cg1UaGVyYXB5Q2hhbmdlEkgKC2Zyb21fc3RhdHVzGAEgASgOMicuaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLlRoZXJhcHlTdGF0dXNSCmZyb21TdGF0dXMSRAoJdG9fc3RhdHVzGAIgASgOMicu'
    'aGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlRoZXJhcHlTdGF0dXNSCHRvU3RhdHVzEj0KDGVmZm'
    'VjdGl2ZV9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZUF0'
    'EjsKC3JlY29yZGVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcmVjb3'
    'JkZWRBdBIdCgpjaGFuZ2VkX2J5GAUgASgJUgljaGFuZ2VkQnkSFgoGcmVhc29uGAYgASgJUgZy'
    'ZWFzb24=');

@$core.Deprecated('Use prescriptionDescriptor instead')
const Prescription$json = {
  '1': 'Prescription',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {'1': 'order_number', '3': 3, '4': 1, '5': 9, '10': 'orderNumber'},
    {'1': 'patient_id', '3': 4, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 5, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'facility_id', '3': 6, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'prescriber_id', '3': 7, '4': 1, '5': 9, '10': 'prescriberId'},
    {'1': 'entered_by_id', '3': 8, '4': 1, '5': 9, '10': 'enteredById'},
    {
      '1': 'ingredient',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'ingredient'
    },
    {
      '1': 'product',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'product'
    },
    {'1': 'route', '3': 11, '4': 1, '5': 9, '10': 'route'},
    {
      '1': 'segments',
      '3': 12,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.DoseSegment',
      '10': 'segments'
    },
    {
      '1': 'starts_at',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'stop',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.StopCondition',
      '10': 'stop'
    },
    {'1': 'indication', '3': 15, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'indication_code',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'indicationCode'
    },
    {'1': 'instructions', '3': 17, '4': 1, '5': 9, '10': 'instructions'},
    {
      '1': 'prn',
      '3': 18,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.PrnConstraint',
      '10': 'prn'
    },
    {
      '1': 'therapy_status',
      '3': 19,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.TherapyStatus',
      '10': 'therapyStatus'
    },
    {
      '1': 'changes',
      '3': 20,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.TherapyChange',
      '10': 'changes'
    },
    {
      '1': 'effective_stop',
      '3': 21,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveStop'
    },
    {
      '1': 'findings',
      '3': 22,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.SafetyFinding',
      '10': 'findings'
    },
    {
      '1': 'formulary',
      '3': 23,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.FormularyDecision',
      '10': 'formulary'
    },
    {
      '1': 'verification',
      '3': 24,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Verification',
      '10': 'verification'
    },
    {'1': 'description', '3': 25, '4': 1, '5': 9, '10': 'description'},
    {
      '1': 'created_at',
      '3': 26,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 27,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'version', '3': 28, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Prescription`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prescriptionDescriptor = $convert.base64Decode(
    'CgxQcmVzY3JpcHRpb24SJwoPcHJlc2NyaXB0aW9uX2lkGAEgASgJUg5wcmVzY3JpcHRpb25JZB'
    'IZCghvcmRlcl9pZBgCIAEoCVIHb3JkZXJJZBIhCgxvcmRlcl9udW1iZXIYAyABKAlSC29yZGVy'
    'TnVtYmVyEh0KCnBhdGllbnRfaWQYBCABKAlSCXBhdGllbnRJZBIhCgxlbmNvdW50ZXJfaWQYBS'
    'ABKAlSC2VuY291bnRlcklkEh8KC2ZhY2lsaXR5X2lkGAYgASgJUgpmYWNpbGl0eUlkEiMKDXBy'
    'ZXNjcmliZXJfaWQYByABKAlSDHByZXNjcmliZXJJZBIiCg1lbnRlcmVkX2J5X2lkGAggASgJUg'
    'tlbnRlcmVkQnlJZBJACgppbmdyZWRpZW50GAkgASgLMiAuaGVhbHRoY2FyZS5tZWRpY2F0aW9u'
    'LnYxLkNvZGluZ1IKaW5ncmVkaWVudBI6Cgdwcm9kdWN0GAogASgLMiAuaGVhbHRoY2FyZS5tZW'
    'RpY2F0aW9uLnYxLkNvZGluZ1IHcHJvZHVjdBIUCgVyb3V0ZRgLIAEoCVIFcm91dGUSQQoIc2Vn'
    'bWVudHMYDCADKAsyJS5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuRG9zZVNlZ21lbnRSCHNlZ2'
    '1lbnRzEjcKCXN0YXJ0c19hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCHN0'
    'YXJ0c0F0EjsKBHN0b3AYDiABKAsyJy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuU3RvcENvbm'
    'RpdGlvblIEc3RvcBIeCgppbmRpY2F0aW9uGA8gASgJUgppbmRpY2F0aW9uEkkKD2luZGljYXRp'
    'b25fY29kZRgQIAEoCzIgLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Db2RpbmdSDmluZGljYX'
    'Rpb25Db2RlEiIKDGluc3RydWN0aW9ucxgRIAEoCVIMaW5zdHJ1Y3Rpb25zEjkKA3BybhgSIAEo'
    'CzInLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Qcm5Db25zdHJhaW50UgNwcm4STgoOdGhlcm'
    'FweV9zdGF0dXMYEyABKA4yJy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuVGhlcmFweVN0YXR1'
    'c1INdGhlcmFweVN0YXR1cxJBCgdjaGFuZ2VzGBQgAygLMicuaGVhbHRoY2FyZS5tZWRpY2F0aW'
    '9uLnYxLlRoZXJhcHlDaGFuZ2VSB2NoYW5nZXMSQQoOZWZmZWN0aXZlX3N0b3AYFSABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1lZmZlY3RpdmVTdG9wEkMKCGZpbmRpbmdzGBYgAy'
    'gLMicuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlNhZmV0eUZpbmRpbmdSCGZpbmRpbmdzEkkK'
    'CWZvcm11bGFyeRgXIAEoCzIrLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Gb3JtdWxhcnlEZW'
    'Npc2lvblIJZm9ybXVsYXJ5EkoKDHZlcmlmaWNhdGlvbhgYIAEoCzImLmhlYWx0aGNhcmUubWVk'
    'aWNhdGlvbi52MS5WZXJpZmljYXRpb25SDHZlcmlmaWNhdGlvbhIgCgtkZXNjcmlwdGlvbhgZIA'
    'EoCVILZGVzY3JpcHRpb24SOQoKY3JlYXRlZF9hdBgaIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5U'
    'aW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GBsgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhgKB3ZlcnNpb24YHCABKANSB3ZlcnNpb24=');

@$core.Deprecated('Use overrideAnswerDescriptor instead')
const OverrideAnswer$json = {
  '1': 'OverrideAnswer',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {
      '1': 'subject',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'subject'
    },
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `OverrideAnswer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List overrideAnswerDescriptor = $convert.base64Decode(
    'Cg5PdmVycmlkZUFuc3dlchIXCgdydWxlX2lkGAEgASgJUgZydWxlSWQSOgoHc3ViamVjdBgCIA'
    'EoCzIgLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Db2RpbmdSB3N1YmplY3QSFgoGcmVhc29u'
    'GAMgASgJUgZyZWFzb24=');

@$core.Deprecated('Use prescribeRequestDescriptor instead')
const PrescribeRequest$json = {
  '1': 'PrescribeRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'ingredient',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'ingredient'
    },
    {
      '1': 'product',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'product'
    },
    {'1': 'route', '3': 5, '4': 1, '5': 9, '10': 'route'},
    {
      '1': 'segments',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.DoseSegment',
      '10': 'segments'
    },
    {
      '1': 'starts_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startsAt'
    },
    {
      '1': 'stop',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.StopCondition',
      '10': 'stop'
    },
    {'1': 'indication', '3': 9, '4': 1, '5': 9, '10': 'indication'},
    {
      '1': 'indication_code',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'indicationCode'
    },
    {'1': 'instructions', '3': 11, '4': 1, '5': 9, '10': 'instructions'},
    {
      '1': 'prn',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.PrnConstraint',
      '10': 'prn'
    },
    {'1': 'entered_by_id', '3': 13, '4': 1, '5': 9, '10': 'enteredById'},
    {
      '1': 'overrides',
      '3': 14,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.OverrideAnswer',
      '10': 'overrides'
    },
  ],
};

/// Descriptor for `PrescribeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prescribeRequestDescriptor = $convert.base64Decode(
    'ChBQcmVzY3JpYmVSZXF1ZXN0Eh0KCnBhdGllbnRfaWQYASABKAlSCXBhdGllbnRJZBIhCgxlbm'
    'NvdW50ZXJfaWQYAiABKAlSC2VuY291bnRlcklkEkAKCmluZ3JlZGllbnQYAyABKAsyIC5oZWFs'
    'dGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUgppbmdyZWRpZW50EjoKB3Byb2R1Y3QYBCABKA'
    'syIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUgdwcm9kdWN0EhQKBXJvdXRlGAUg'
    'ASgJUgVyb3V0ZRJBCghzZWdtZW50cxgGIAMoCzIlLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS'
    '5Eb3NlU2VnbWVudFIIc2VnbWVudHMSNwoJc3RhcnRzX2F0GAcgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIIc3RhcnRzQXQSOwoEc3RvcBgIIAEoCzInLmhlYWx0aGNhcmUubWVkaW'
    'NhdGlvbi52MS5TdG9wQ29uZGl0aW9uUgRzdG9wEh4KCmluZGljYXRpb24YCSABKAlSCmluZGlj'
    'YXRpb24SSQoPaW5kaWNhdGlvbl9jb2RlGAogASgLMiAuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLn'
    'YxLkNvZGluZ1IOaW5kaWNhdGlvbkNvZGUSIgoMaW5zdHJ1Y3Rpb25zGAsgASgJUgxpbnN0cnVj'
    'dGlvbnMSOQoDcHJuGAwgASgLMicuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlBybkNvbnN0cm'
    'FpbnRSA3BybhIiCg1lbnRlcmVkX2J5X2lkGA0gASgJUgtlbnRlcmVkQnlJZBJGCglvdmVycmlk'
    'ZXMYDiADKAsyKC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuT3ZlcnJpZGVBbnN3ZXJSCW92ZX'
    'JyaWRlcw==');

@$core.Deprecated('Use prescribeResponseDescriptor instead')
const PrescribeResponse$json = {
  '1': 'PrescribeResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `PrescribeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List prescribeResponseDescriptor = $convert.base64Decode(
    'ChFQcmVzY3JpYmVSZXNwb25zZRJKCgxwcmVzY3JpcHRpb24YASABKAsyJi5oZWFsdGhjYXJlLm'
    '1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUgxwcmVzY3JpcHRpb24=');

@$core.Deprecated('Use getPrescriptionRequestDescriptor instead')
const GetPrescriptionRequest$json = {
  '1': 'GetPrescriptionRequest',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
  ],
};

/// Descriptor for `GetPrescriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPrescriptionRequestDescriptor =
    $convert.base64Decode(
        'ChZHZXRQcmVzY3JpcHRpb25SZXF1ZXN0EicKD3ByZXNjcmlwdGlvbl9pZBgBIAEoCVIOcHJlc2'
        'NyaXB0aW9uSWQ=');

@$core.Deprecated('Use getPrescriptionResponseDescriptor instead')
const GetPrescriptionResponse$json = {
  '1': 'GetPrescriptionResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `GetPrescriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPrescriptionResponseDescriptor =
    $convert.base64Decode(
        'ChdHZXRQcmVzY3JpcHRpb25SZXNwb25zZRJKCgxwcmVzY3JpcHRpb24YASABKAsyJi5oZWFsdG'
        'hjYXJlLm1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUgxwcmVzY3JpcHRpb24=');

@$core.Deprecated('Use listPrescriptionsRequestDescriptor instead')
const ListPrescriptionsRequest$json = {
  '1': 'ListPrescriptionsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'live_only', '3': 2, '4': 1, '5': 8, '10': 'liveOnly'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListPrescriptionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrescriptionsRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0UHJlc2NyaXB0aW9uc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW'
    '50ZXJJZBIbCglsaXZlX29ubHkYAiABKAhSCGxpdmVPbmx5EhsKCXBhZ2Vfc2l6ZRgDIAEoBVII'
    'cGFnZVNpemU=');

@$core.Deprecated('Use listPrescriptionsResponseDescriptor instead')
const ListPrescriptionsResponse$json = {
  '1': 'ListPrescriptionsResponse',
  '2': [
    {
      '1': 'prescriptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescriptions'
    },
  ],
};

/// Descriptor for `ListPrescriptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPrescriptionsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0UHJlc2NyaXB0aW9uc1Jlc3BvbnNlEkwKDXByZXNjcmlwdGlvbnMYASADKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUg1wcmVzY3JpcHRpb25z');

@$core.Deprecated('Use changeTherapyRequestDescriptor instead')
const ChangeTherapyRequest$json = {
  '1': 'ChangeTherapyRequest',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {
      '1': 'effective_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'effectiveAt'
    },
  ],
};

/// Descriptor for `ChangeTherapyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeTherapyRequestDescriptor = $convert.base64Decode(
    'ChRDaGFuZ2VUaGVyYXB5UmVxdWVzdBInCg9wcmVzY3JpcHRpb25faWQYASABKAlSDnByZXNjcm'
    'lwdGlvbklkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29uEj0KDGVmZmVjdGl2ZV9hdBgDIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC2VmZmVjdGl2ZUF0');

@$core.Deprecated('Use changeTherapyResponseDescriptor instead')
const ChangeTherapyResponse$json = {
  '1': 'ChangeTherapyResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `ChangeTherapyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changeTherapyResponseDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VUaGVyYXB5UmVzcG9uc2USSgoMcHJlc2NyaXB0aW9uGAEgASgLMiYuaGVhbHRoY2'
    'FyZS5tZWRpY2F0aW9uLnYxLlByZXNjcmlwdGlvblIMcHJlc2NyaXB0aW9u');

@$core.Deprecated('Use holdTherapyRequestDescriptor instead')
const HoldTherapyRequest$json = {
  '1': 'HoldTherapyRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.ChangeTherapyRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `HoldTherapyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdTherapyRequestDescriptor = $convert.base64Decode(
    'ChJIb2xkVGhlcmFweVJlcXVlc3QSRgoGY2hhbmdlGAEgASgLMi4uaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLkNoYW5nZVRoZXJhcHlSZXF1ZXN0UgZjaGFuZ2U=');

@$core.Deprecated('Use holdTherapyResponseDescriptor instead')
const HoldTherapyResponse$json = {
  '1': 'HoldTherapyResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `HoldTherapyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List holdTherapyResponseDescriptor = $convert.base64Decode(
    'ChNIb2xkVGhlcmFweVJlc3BvbnNlEkoKDHByZXNjcmlwdGlvbhgBIAEoCzImLmhlYWx0aGNhcm'
    'UubWVkaWNhdGlvbi52MS5QcmVzY3JpcHRpb25SDHByZXNjcmlwdGlvbg==');

@$core.Deprecated('Use restartTherapyRequestDescriptor instead')
const RestartTherapyRequest$json = {
  '1': 'RestartTherapyRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.ChangeTherapyRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `RestartTherapyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartTherapyRequestDescriptor = $convert.base64Decode(
    'ChVSZXN0YXJ0VGhlcmFweVJlcXVlc3QSRgoGY2hhbmdlGAEgASgLMi4uaGVhbHRoY2FyZS5tZW'
    'RpY2F0aW9uLnYxLkNoYW5nZVRoZXJhcHlSZXF1ZXN0UgZjaGFuZ2U=');

@$core.Deprecated('Use restartTherapyResponseDescriptor instead')
const RestartTherapyResponse$json = {
  '1': 'RestartTherapyResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `RestartTherapyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restartTherapyResponseDescriptor =
    $convert.base64Decode(
        'ChZSZXN0YXJ0VGhlcmFweVJlc3BvbnNlEkoKDHByZXNjcmlwdGlvbhgBIAEoCzImLmhlYWx0aG'
        'NhcmUubWVkaWNhdGlvbi52MS5QcmVzY3JpcHRpb25SDHByZXNjcmlwdGlvbg==');

@$core.Deprecated('Use discontinueTherapyRequestDescriptor instead')
const DiscontinueTherapyRequest$json = {
  '1': 'DiscontinueTherapyRequest',
  '2': [
    {
      '1': 'change',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.ChangeTherapyRequest',
      '10': 'change'
    },
  ],
};

/// Descriptor for `DiscontinueTherapyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discontinueTherapyRequestDescriptor =
    $convert.base64Decode(
        'ChlEaXNjb250aW51ZVRoZXJhcHlSZXF1ZXN0EkYKBmNoYW5nZRgBIAEoCzIuLmhlYWx0aGNhcm'
        'UubWVkaWNhdGlvbi52MS5DaGFuZ2VUaGVyYXB5UmVxdWVzdFIGY2hhbmdl');

@$core.Deprecated('Use discontinueTherapyResponseDescriptor instead')
const DiscontinueTherapyResponse$json = {
  '1': 'DiscontinueTherapyResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `DiscontinueTherapyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discontinueTherapyResponseDescriptor =
    $convert.base64Decode(
        'ChpEaXNjb250aW51ZVRoZXJhcHlSZXNwb25zZRJKCgxwcmVzY3JpcHRpb24YASABKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUgxwcmVzY3JpcHRpb24=');

@$core.Deprecated('Use verifyPrescriptionRequestDescriptor instead')
const VerifyPrescriptionRequest$json = {
  '1': 'VerifyPrescriptionRequest',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'note', '3': 2, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `VerifyPrescriptionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPrescriptionRequestDescriptor =
    $convert.base64Decode(
        'ChlWZXJpZnlQcmVzY3JpcHRpb25SZXF1ZXN0EicKD3ByZXNjcmlwdGlvbl9pZBgBIAEoCVIOcH'
        'Jlc2NyaXB0aW9uSWQSEgoEbm90ZRgCIAEoCVIEbm90ZQ==');

@$core.Deprecated('Use verifyPrescriptionResponseDescriptor instead')
const VerifyPrescriptionResponse$json = {
  '1': 'VerifyPrescriptionResponse',
  '2': [
    {
      '1': 'prescription',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescription'
    },
  ],
};

/// Descriptor for `VerifyPrescriptionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyPrescriptionResponseDescriptor =
    $convert.base64Decode(
        'ChpWZXJpZnlQcmVzY3JpcHRpb25SZXNwb25zZRJKCgxwcmVzY3JpcHRpb24YASABKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUgxwcmVzY3JpcHRpb24=');

@$core.Deprecated('Use verificationQueueRequestDescriptor instead')
const VerificationQueueRequest$json = {
  '1': 'VerificationQueueRequest',
  '2': [
    {'1': 'facility_id', '3': 1, '4': 1, '5': 9, '10': 'facilityId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `VerificationQueueRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationQueueRequestDescriptor =
    $convert.base64Decode(
        'ChhWZXJpZmljYXRpb25RdWV1ZVJlcXVlc3QSHwoLZmFjaWxpdHlfaWQYASABKAlSCmZhY2lsaX'
        'R5SWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZQ==');

@$core.Deprecated('Use verificationQueueResponseDescriptor instead')
const VerificationQueueResponse$json = {
  '1': 'VerificationQueueResponse',
  '2': [
    {
      '1': 'prescriptions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Prescription',
      '10': 'prescriptions'
    },
  ],
};

/// Descriptor for `VerificationQueueResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationQueueResponseDescriptor =
    $convert.base64Decode(
        'ChlWZXJpZmljYXRpb25RdWV1ZVJlc3BvbnNlEkwKDXByZXNjcmlwdGlvbnMYASADKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuUHJlc2NyaXB0aW9uUg1wcmVzY3JpcHRpb25z');

@$core.Deprecated('Use dueDoseDescriptor instead')
const DueDose$json = {
  '1': 'DueDose',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
    {'1': 'order_id', '3': 2, '4': 1, '5': 9, '10': 'orderId'},
    {
      '1': 'scheduled_at',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'scheduledAt'
    },
    {
      '1': 'segment',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.DoseSegment',
      '10': 'segment'
    },
  ],
};

/// Descriptor for `DueDose`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueDoseDescriptor = $convert.base64Decode(
    'CgdEdWVEb3NlEicKD3ByZXNjcmlwdGlvbl9pZBgBIAEoCVIOcHJlc2NyaXB0aW9uSWQSGQoIb3'
    'JkZXJfaWQYAiABKAlSB29yZGVySWQSPQoMc2NoZWR1bGVkX2F0GAMgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILc2NoZWR1bGVkQXQSPwoHc2VnbWVudBgEIAEoCzIlLmhlYWx0aG'
    'NhcmUubWVkaWNhdGlvbi52MS5Eb3NlU2VnbWVudFIHc2VnbWVudA==');

@$core.Deprecated('Use dueDosesRequestDescriptor instead')
const DueDosesRequest$json = {
  '1': 'DueDosesRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'from',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'from'
    },
    {
      '1': 'to',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'to'
    },
  ],
};

/// Descriptor for `DueDosesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueDosesRequestDescriptor = $convert.base64Decode(
    'Cg9EdWVEb3Nlc1JlcXVlc3QSIQoMZW5jb3VudGVyX2lkGAEgASgJUgtlbmNvdW50ZXJJZBIuCg'
    'Rmcm9tGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIEZnJvbRIqCgJ0bxgDIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSAnRv');

@$core.Deprecated('Use dueDosesResponseDescriptor instead')
const DueDosesResponse$json = {
  '1': 'DueDosesResponse',
  '2': [
    {
      '1': 'doses',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.DueDose',
      '10': 'doses'
    },
  ],
};

/// Descriptor for `DueDosesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dueDosesResponseDescriptor = $convert.base64Decode(
    'ChBEdWVEb3Nlc1Jlc3BvbnNlEjcKBWRvc2VzGAEgAygLMiEuaGVhbHRoY2FyZS5tZWRpY2F0aW'
    '9uLnYxLkR1ZURvc2VSBWRvc2Vz');

@$core.Deprecated('Use reconciliationItemDescriptor instead')
const ReconciliationItem$json = {
  '1': 'ReconciliationItem',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 5, '10': 'sequence'},
    {
      '1': 'medication',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'medication'
    },
    {'1': 'dose_text', '3': 3, '4': 1, '5': 9, '10': 'doseText'},
    {'1': 'route', '3': 4, '4': 1, '5': 9, '10': 'route'},
    {
      '1': 'source',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.HomeMedicationSource',
      '10': 'source'
    },
    {
      '1': 'disposition',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.Disposition',
      '10': 'disposition'
    },
    {'1': 'rationale', '3': 7, '4': 1, '5': 9, '10': 'rationale'},
    {
      '1': 'resulting_prescription_id',
      '3': 8,
      '4': 1,
      '5': 9,
      '10': 'resultingPrescriptionId'
    },
    {'1': 'decided_by', '3': 9, '4': 1, '5': 9, '10': 'decidedBy'},
    {
      '1': 'decided_at',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'decidedAt'
    },
  ],
};

/// Descriptor for `ReconciliationItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationItemDescriptor = $convert.base64Decode(
    'ChJSZWNvbmNpbGlhdGlvbkl0ZW0SGgoIc2VxdWVuY2UYASABKAVSCHNlcXVlbmNlEkAKCm1lZG'
    'ljYXRpb24YAiABKAsyIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUgptZWRpY2F0'
    'aW9uEhsKCWRvc2VfdGV4dBgDIAEoCVIIZG9zZVRleHQSFAoFcm91dGUYBCABKAlSBXJvdXRlEk'
    'YKBnNvdXJjZRgFIAEoDjIuLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Ib21lTWVkaWNhdGlv'
    'blNvdXJjZVIGc291cmNlEkcKC2Rpc3Bvc2l0aW9uGAYgASgOMiUuaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLkRpc3Bvc2l0aW9uUgtkaXNwb3NpdGlvbhIcCglyYXRpb25hbGUYByABKAlSCXJh'
    'dGlvbmFsZRI6ChlyZXN1bHRpbmdfcHJlc2NyaXB0aW9uX2lkGAggASgJUhdyZXN1bHRpbmdQcm'
    'VzY3JpcHRpb25JZBIdCgpkZWNpZGVkX2J5GAkgASgJUglkZWNpZGVkQnkSOQoKZGVjaWRlZF9h'
    'dBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWRlY2lkZWRBdA==');

@$core.Deprecated('Use reconciliationDescriptor instead')
const Reconciliation$json = {
  '1': 'Reconciliation',
  '2': [
    {
      '1': 'reconciliation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'reconciliationId'
    },
    {'1': 'patient_id', '3': 2, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 3, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'event',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.ReconciliationEvent',
      '10': 'event'
    },
    {
      '1': 'items',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.ReconciliationItem',
      '10': 'items'
    },
    {'1': 'started_by', '3': 6, '4': 1, '5': 9, '10': 'startedBy'},
    {
      '1': 'started_at',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startedAt'
    },
    {'1': 'completed_by', '3': 8, '4': 1, '5': 9, '10': 'completedBy'},
    {
      '1': 'completed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'completedAt'
    },
    {'1': 'version', '3': 10, '4': 1, '5': 3, '10': 'version'},
  ],
};

/// Descriptor for `Reconciliation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reconciliationDescriptor = $convert.base64Decode(
    'Cg5SZWNvbmNpbGlhdGlvbhIrChFyZWNvbmNpbGlhdGlvbl9pZBgBIAEoCVIQcmVjb25jaWxpYX'
    'Rpb25JZBIdCgpwYXRpZW50X2lkGAIgASgJUglwYXRpZW50SWQSIQoMZW5jb3VudGVyX2lkGAMg'
    'ASgJUgtlbmNvdW50ZXJJZBJDCgVldmVudBgEIAEoDjItLmhlYWx0aGNhcmUubWVkaWNhdGlvbi'
    '52MS5SZWNvbmNpbGlhdGlvbkV2ZW50UgVldmVudBJCCgVpdGVtcxgFIAMoCzIsLmhlYWx0aGNh'
    'cmUubWVkaWNhdGlvbi52MS5SZWNvbmNpbGlhdGlvbkl0ZW1SBWl0ZW1zEh0KCnN0YXJ0ZWRfYn'
    'kYBiABKAlSCXN0YXJ0ZWRCeRI5CgpzdGFydGVkX2F0GAcgASgLMhouZ29vZ2xlLnByb3RvYnVm'
    'LlRpbWVzdGFtcFIJc3RhcnRlZEF0EiEKDGNvbXBsZXRlZF9ieRgIIAEoCVILY29tcGxldGVkQn'
    'kSPQoMY29tcGxldGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29t'
    'cGxldGVkQXQSGAoHdmVyc2lvbhgKIAEoA1IHdmVyc2lvbg==');

@$core.Deprecated('Use startReconciliationRequestDescriptor instead')
const StartReconciliationRequest$json = {
  '1': 'StartReconciliationRequest',
  '2': [
    {'1': 'patient_id', '3': 1, '4': 1, '5': 9, '10': 'patientId'},
    {'1': 'encounter_id', '3': 2, '4': 1, '5': 9, '10': 'encounterId'},
    {
      '1': 'event',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.ReconciliationEvent',
      '10': 'event'
    },
    {
      '1': 'home_medications',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.ReconciliationItem',
      '10': 'homeMedications'
    },
  ],
};

/// Descriptor for `StartReconciliationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startReconciliationRequestDescriptor = $convert.base64Decode(
    'ChpTdGFydFJlY29uY2lsaWF0aW9uUmVxdWVzdBIdCgpwYXRpZW50X2lkGAEgASgJUglwYXRpZW'
    '50SWQSIQoMZW5jb3VudGVyX2lkGAIgASgJUgtlbmNvdW50ZXJJZBJDCgVldmVudBgDIAEoDjIt'
    'LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5SZWNvbmNpbGlhdGlvbkV2ZW50UgVldmVudBJXCh'
    'Bob21lX21lZGljYXRpb25zGAQgAygLMiwuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlJlY29u'
    'Y2lsaWF0aW9uSXRlbVIPaG9tZU1lZGljYXRpb25z');

@$core.Deprecated('Use startReconciliationResponseDescriptor instead')
const StartReconciliationResponse$json = {
  '1': 'StartReconciliationResponse',
  '2': [
    {
      '1': 'reconciliation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Reconciliation',
      '10': 'reconciliation'
    },
  ],
};

/// Descriptor for `StartReconciliationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startReconciliationResponseDescriptor =
    $convert.base64Decode(
        'ChtTdGFydFJlY29uY2lsaWF0aW9uUmVzcG9uc2USUAoOcmVjb25jaWxpYXRpb24YASABKAsyKC'
        '5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuUmVjb25jaWxpYXRpb25SDnJlY29uY2lsaWF0aW9u');

@$core.Deprecated('Use decideReconciliationRequestDescriptor instead')
const DecideReconciliationRequest$json = {
  '1': 'DecideReconciliationRequest',
  '2': [
    {
      '1': 'reconciliation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'reconciliationId'
    },
    {'1': 'sequence', '3': 2, '4': 1, '5': 5, '10': 'sequence'},
    {
      '1': 'disposition',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.Disposition',
      '10': 'disposition'
    },
    {'1': 'rationale', '3': 4, '4': 1, '5': 9, '10': 'rationale'},
    {
      '1': 'resulting_prescription_id',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'resultingPrescriptionId'
    },
  ],
};

/// Descriptor for `DecideReconciliationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideReconciliationRequestDescriptor = $convert.base64Decode(
    'ChtEZWNpZGVSZWNvbmNpbGlhdGlvblJlcXVlc3QSKwoRcmVjb25jaWxpYXRpb25faWQYASABKA'
    'lSEHJlY29uY2lsaWF0aW9uSWQSGgoIc2VxdWVuY2UYAiABKAVSCHNlcXVlbmNlEkcKC2Rpc3Bv'
    'c2l0aW9uGAMgASgOMiUuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLkRpc3Bvc2l0aW9uUgtkaX'
    'Nwb3NpdGlvbhIcCglyYXRpb25hbGUYBCABKAlSCXJhdGlvbmFsZRI6ChlyZXN1bHRpbmdfcHJl'
    'c2NyaXB0aW9uX2lkGAUgASgJUhdyZXN1bHRpbmdQcmVzY3JpcHRpb25JZA==');

@$core.Deprecated('Use decideReconciliationResponseDescriptor instead')
const DecideReconciliationResponse$json = {
  '1': 'DecideReconciliationResponse',
  '2': [
    {
      '1': 'reconciliation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Reconciliation',
      '10': 'reconciliation'
    },
  ],
};

/// Descriptor for `DecideReconciliationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List decideReconciliationResponseDescriptor =
    $convert.base64Decode(
        'ChxEZWNpZGVSZWNvbmNpbGlhdGlvblJlc3BvbnNlElAKDnJlY29uY2lsaWF0aW9uGAEgASgLMi'
        'guaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlJlY29uY2lsaWF0aW9uUg5yZWNvbmNpbGlhdGlv'
        'bg==');

@$core.Deprecated('Use completeReconciliationRequestDescriptor instead')
const CompleteReconciliationRequest$json = {
  '1': 'CompleteReconciliationRequest',
  '2': [
    {
      '1': 'reconciliation_id',
      '3': 1,
      '4': 1,
      '5': 9,
      '10': 'reconciliationId'
    },
  ],
};

/// Descriptor for `CompleteReconciliationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeReconciliationRequestDescriptor =
    $convert.base64Decode(
        'Ch1Db21wbGV0ZVJlY29uY2lsaWF0aW9uUmVxdWVzdBIrChFyZWNvbmNpbGlhdGlvbl9pZBgBIA'
        'EoCVIQcmVjb25jaWxpYXRpb25JZA==');

@$core.Deprecated('Use completeReconciliationResponseDescriptor instead')
const CompleteReconciliationResponse$json = {
  '1': 'CompleteReconciliationResponse',
  '2': [
    {
      '1': 'reconciliation',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Reconciliation',
      '10': 'reconciliation'
    },
  ],
};

/// Descriptor for `CompleteReconciliationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeReconciliationResponseDescriptor =
    $convert.base64Decode(
        'Ch5Db21wbGV0ZVJlY29uY2lsaWF0aW9uUmVzcG9uc2USUAoOcmVjb25jaWxpYXRpb24YASABKA'
        'syKC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuUmVjb25jaWxpYXRpb25SDnJlY29uY2lsaWF0'
        'aW9u');

@$core.Deprecated('Use listReconciliationsRequestDescriptor instead')
const ListReconciliationsRequest$json = {
  '1': 'ListReconciliationsRequest',
  '2': [
    {'1': 'encounter_id', '3': 1, '4': 1, '5': 9, '10': 'encounterId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `ListReconciliationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReconciliationsRequestDescriptor =
    $convert.base64Decode(
        'ChpMaXN0UmVjb25jaWxpYXRpb25zUmVxdWVzdBIhCgxlbmNvdW50ZXJfaWQYASABKAlSC2VuY2'
        '91bnRlcklkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use listReconciliationsResponseDescriptor instead')
const ListReconciliationsResponse$json = {
  '1': 'ListReconciliationsResponse',
  '2': [
    {
      '1': 'reconciliations',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Reconciliation',
      '10': 'reconciliations'
    },
  ],
};

/// Descriptor for `ListReconciliationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReconciliationsResponseDescriptor =
    $convert.base64Decode(
        'ChtMaXN0UmVjb25jaWxpYXRpb25zUmVzcG9uc2USUgoPcmVjb25jaWxpYXRpb25zGAEgAygLMi'
        'guaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlJlY29uY2lsaWF0aW9uUg9yZWNvbmNpbGlhdGlv'
        'bnM=');

@$core.Deprecated('Use substitutionDescriptor instead')
const Substitution$json = {
  '1': 'Substitution',
  '2': [
    {'1': 'substitution_id', '3': 1, '4': 1, '5': 9, '10': 'substitutionId'},
    {'1': 'prescription_id', '3': 2, '4': 1, '5': 9, '10': 'prescriptionId'},
    {
      '1': 'prescribed',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'prescribed'
    },
    {
      '1': 'dispensed',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'dispensed'
    },
    {
      '1': 'kind',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.SubstitutionKind',
      '10': 'kind'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.SubstitutionStatus',
      '10': 'status'
    },
    {'1': 'reason', '3': 7, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'proposed_by', '3': 8, '4': 1, '5': 9, '10': 'proposedBy'},
    {
      '1': 'proposed_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'proposedAt'
    },
    {'1': 'authorized_by', '3': 10, '4': 1, '5': 9, '10': 'authorizedBy'},
    {
      '1': 'authorized_at',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'authorizedAt'
    },
    {
      '1': 'dispensed_at',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'dispensedAt'
    },
  ],
};

/// Descriptor for `Substitution`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List substitutionDescriptor = $convert.base64Decode(
    'CgxTdWJzdGl0dXRpb24SJwoPc3Vic3RpdHV0aW9uX2lkGAEgASgJUg5zdWJzdGl0dXRpb25JZB'
    'InCg9wcmVzY3JpcHRpb25faWQYAiABKAlSDnByZXNjcmlwdGlvbklkEkAKCnByZXNjcmliZWQY'
    'AyABKAsyIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUgpwcmVzY3JpYmVkEj4KCW'
    'Rpc3BlbnNlZBgEIAEoCzIgLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Db2RpbmdSCWRpc3Bl'
    'bnNlZBI+CgRraW5kGAUgASgOMiouaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlN1YnN0aXR1dG'
    'lvbktpbmRSBGtpbmQSRAoGc3RhdHVzGAYgASgOMiwuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYx'
    'LlN1YnN0aXR1dGlvblN0YXR1c1IGc3RhdHVzEhYKBnJlYXNvbhgHIAEoCVIGcmVhc29uEh8KC3'
    'Byb3Bvc2VkX2J5GAggASgJUgpwcm9wb3NlZEJ5EjsKC3Byb3Bvc2VkX2F0GAkgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKcHJvcG9zZWRBdBIjCg1hdXRob3JpemVkX2J5GAogAS'
    'gJUgxhdXRob3JpemVkQnkSPwoNYXV0aG9yaXplZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSDGF1dGhvcml6ZWRBdBI9CgxkaXNwZW5zZWRfYXQYDCABKAsyGi5nb29nbG'
    'UucHJvdG9idWYuVGltZXN0YW1wUgtkaXNwZW5zZWRBdA==');

@$core.Deprecated('Use proposeSubstitutionRequestDescriptor instead')
const ProposeSubstitutionRequest$json = {
  '1': 'ProposeSubstitutionRequest',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
    {
      '1': 'dispensed',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'dispensed'
    },
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.SubstitutionKind',
      '10': 'kind'
    },
    {'1': 'reason', '3': 4, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `ProposeSubstitutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposeSubstitutionRequestDescriptor = $convert.base64Decode(
    'ChpQcm9wb3NlU3Vic3RpdHV0aW9uUmVxdWVzdBInCg9wcmVzY3JpcHRpb25faWQYASABKAlSDn'
    'ByZXNjcmlwdGlvbklkEj4KCWRpc3BlbnNlZBgCIAEoCzIgLmhlYWx0aGNhcmUubWVkaWNhdGlv'
    'bi52MS5Db2RpbmdSCWRpc3BlbnNlZBI+CgRraW5kGAMgASgOMiouaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLlN1YnN0aXR1dGlvbktpbmRSBGtpbmQSFgoGcmVhc29uGAQgASgJUgZyZWFzb24=');

@$core.Deprecated('Use proposeSubstitutionResponseDescriptor instead')
const ProposeSubstitutionResponse$json = {
  '1': 'ProposeSubstitutionResponse',
  '2': [
    {
      '1': 'substitution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitution'
    },
  ],
};

/// Descriptor for `ProposeSubstitutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List proposeSubstitutionResponseDescriptor =
    $convert.base64Decode(
        'ChtQcm9wb3NlU3Vic3RpdHV0aW9uUmVzcG9uc2USSgoMc3Vic3RpdHV0aW9uGAEgASgLMiYuaG'
        'VhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlN1YnN0aXR1dGlvblIMc3Vic3RpdHV0aW9u');

@$core.Deprecated('Use advanceSubstitutionRequestDescriptor instead')
const AdvanceSubstitutionRequest$json = {
  '1': 'AdvanceSubstitutionRequest',
  '2': [
    {'1': 'substitution_id', '3': 1, '4': 1, '5': 9, '10': 'substitutionId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `AdvanceSubstitutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceSubstitutionRequestDescriptor =
    $convert.base64Decode(
        'ChpBZHZhbmNlU3Vic3RpdHV0aW9uUmVxdWVzdBInCg9zdWJzdGl0dXRpb25faWQYASABKAlSDn'
        'N1YnN0aXR1dGlvbklkEhYKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use advanceSubstitutionResponseDescriptor instead')
const AdvanceSubstitutionResponse$json = {
  '1': 'AdvanceSubstitutionResponse',
  '2': [
    {
      '1': 'substitution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitution'
    },
  ],
};

/// Descriptor for `AdvanceSubstitutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advanceSubstitutionResponseDescriptor =
    $convert.base64Decode(
        'ChtBZHZhbmNlU3Vic3RpdHV0aW9uUmVzcG9uc2USSgoMc3Vic3RpdHV0aW9uGAEgASgLMiYuaG'
        'VhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlN1YnN0aXR1dGlvblIMc3Vic3RpdHV0aW9u');

@$core.Deprecated('Use authorizeSubstitutionRequestDescriptor instead')
const AuthorizeSubstitutionRequest$json = {
  '1': 'AuthorizeSubstitutionRequest',
  '2': [
    {
      '1': 'advance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.AdvanceSubstitutionRequest',
      '10': 'advance'
    },
  ],
};

/// Descriptor for `AuthorizeSubstitutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizeSubstitutionRequestDescriptor =
    $convert.base64Decode(
        'ChxBdXRob3JpemVTdWJzdGl0dXRpb25SZXF1ZXN0Ek4KB2FkdmFuY2UYASABKAsyNC5oZWFsdG'
        'hjYXJlLm1lZGljYXRpb24udjEuQWR2YW5jZVN1YnN0aXR1dGlvblJlcXVlc3RSB2FkdmFuY2U=');

@$core.Deprecated('Use authorizeSubstitutionResponseDescriptor instead')
const AuthorizeSubstitutionResponse$json = {
  '1': 'AuthorizeSubstitutionResponse',
  '2': [
    {
      '1': 'substitution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitution'
    },
  ],
};

/// Descriptor for `AuthorizeSubstitutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List authorizeSubstitutionResponseDescriptor =
    $convert.base64Decode(
        'Ch1BdXRob3JpemVTdWJzdGl0dXRpb25SZXNwb25zZRJKCgxzdWJzdGl0dXRpb24YASABKAsyJi'
        '5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuU3Vic3RpdHV0aW9uUgxzdWJzdGl0dXRpb24=');

@$core.Deprecated('Use rejectSubstitutionRequestDescriptor instead')
const RejectSubstitutionRequest$json = {
  '1': 'RejectSubstitutionRequest',
  '2': [
    {
      '1': 'advance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.AdvanceSubstitutionRequest',
      '10': 'advance'
    },
  ],
};

/// Descriptor for `RejectSubstitutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectSubstitutionRequestDescriptor =
    $convert.base64Decode(
        'ChlSZWplY3RTdWJzdGl0dXRpb25SZXF1ZXN0Ek4KB2FkdmFuY2UYASABKAsyNC5oZWFsdGhjYX'
        'JlLm1lZGljYXRpb24udjEuQWR2YW5jZVN1YnN0aXR1dGlvblJlcXVlc3RSB2FkdmFuY2U=');

@$core.Deprecated('Use rejectSubstitutionResponseDescriptor instead')
const RejectSubstitutionResponse$json = {
  '1': 'RejectSubstitutionResponse',
  '2': [
    {
      '1': 'substitution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitution'
    },
  ],
};

/// Descriptor for `RejectSubstitutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectSubstitutionResponseDescriptor =
    $convert.base64Decode(
        'ChpSZWplY3RTdWJzdGl0dXRpb25SZXNwb25zZRJKCgxzdWJzdGl0dXRpb24YASABKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuU3Vic3RpdHV0aW9uUgxzdWJzdGl0dXRpb24=');

@$core.Deprecated('Use dispenseSubstitutionRequestDescriptor instead')
const DispenseSubstitutionRequest$json = {
  '1': 'DispenseSubstitutionRequest',
  '2': [
    {
      '1': 'advance',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.AdvanceSubstitutionRequest',
      '10': 'advance'
    },
  ],
};

/// Descriptor for `DispenseSubstitutionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispenseSubstitutionRequestDescriptor =
    $convert.base64Decode(
        'ChtEaXNwZW5zZVN1YnN0aXR1dGlvblJlcXVlc3QSTgoHYWR2YW5jZRgBIAEoCzI0LmhlYWx0aG'
        'NhcmUubWVkaWNhdGlvbi52MS5BZHZhbmNlU3Vic3RpdHV0aW9uUmVxdWVzdFIHYWR2YW5jZQ==');

@$core.Deprecated('Use dispenseSubstitutionResponseDescriptor instead')
const DispenseSubstitutionResponse$json = {
  '1': 'DispenseSubstitutionResponse',
  '2': [
    {
      '1': 'substitution',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitution'
    },
  ],
};

/// Descriptor for `DispenseSubstitutionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dispenseSubstitutionResponseDescriptor =
    $convert.base64Decode(
        'ChxEaXNwZW5zZVN1YnN0aXR1dGlvblJlc3BvbnNlEkoKDHN1YnN0aXR1dGlvbhgBIAEoCzImLm'
        'hlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5TdWJzdGl0dXRpb25SDHN1YnN0aXR1dGlvbg==');

@$core.Deprecated('Use listSubstitutionsRequestDescriptor instead')
const ListSubstitutionsRequest$json = {
  '1': 'ListSubstitutionsRequest',
  '2': [
    {'1': 'prescription_id', '3': 1, '4': 1, '5': 9, '10': 'prescriptionId'},
  ],
};

/// Descriptor for `ListSubstitutionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSubstitutionsRequestDescriptor =
    $convert.base64Decode(
        'ChhMaXN0U3Vic3RpdHV0aW9uc1JlcXVlc3QSJwoPcHJlc2NyaXB0aW9uX2lkGAEgASgJUg5wcm'
        'VzY3JpcHRpb25JZA==');

@$core.Deprecated('Use listSubstitutionsResponseDescriptor instead')
const ListSubstitutionsResponse$json = {
  '1': 'ListSubstitutionsResponse',
  '2': [
    {
      '1': 'substitutions',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Substitution',
      '10': 'substitutions'
    },
  ],
};

/// Descriptor for `ListSubstitutionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSubstitutionsResponseDescriptor =
    $convert.base64Decode(
        'ChlMaXN0U3Vic3RpdHV0aW9uc1Jlc3BvbnNlEkwKDXN1YnN0aXR1dGlvbnMYASADKAsyJi5oZW'
        'FsdGhjYXJlLm1lZGljYXRpb24udjEuU3Vic3RpdHV0aW9uUg1zdWJzdGl0dXRpb25z');

@$core.Deprecated('Use formularyEntryDescriptor instead')
const FormularyEntry$json = {
  '1': 'FormularyEntry',
  '2': [
    {
      '1': 'medication',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'medication'
    },
    {'1': 'scope', '3': 2, '4': 1, '5': 9, '10': 'scope'},
    {'1': 'scope_id', '3': 3, '4': 1, '5': 9, '10': 'scopeId'},
    {
      '1': 'status',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.FormularyStatus',
      '10': 'status'
    },
    {'1': 'restriction', '3': 5, '4': 1, '5': 9, '10': 'restriction'},
    {'1': 'approval_path', '3': 6, '4': 1, '5': 9, '10': 'approvalPath'},
  ],
};

/// Descriptor for `FormularyEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List formularyEntryDescriptor = $convert.base64Decode(
    'Cg5Gb3JtdWxhcnlFbnRyeRJACgptZWRpY2F0aW9uGAEgASgLMiAuaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLkNvZGluZ1IKbWVkaWNhdGlvbhIUCgVzY29wZRgCIAEoCVIFc2NvcGUSGQoIc2Nv'
    'cGVfaWQYAyABKAlSB3Njb3BlSWQSQQoGc3RhdHVzGAQgASgOMikuaGVhbHRoY2FyZS5tZWRpY2'
    'F0aW9uLnYxLkZvcm11bGFyeVN0YXR1c1IGc3RhdHVzEiAKC3Jlc3RyaWN0aW9uGAUgASgJUgty'
    'ZXN0cmljdGlvbhIjCg1hcHByb3ZhbF9wYXRoGAYgASgJUgxhcHByb3ZhbFBhdGg=');

@$core.Deprecated('Use setFormularyEntryRequestDescriptor instead')
const SetFormularyEntryRequest$json = {
  '1': 'SetFormularyEntryRequest',
  '2': [
    {
      '1': 'entry',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.FormularyEntry',
      '10': 'entry'
    },
  ],
};

/// Descriptor for `SetFormularyEntryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setFormularyEntryRequestDescriptor =
    $convert.base64Decode(
        'ChhTZXRGb3JtdWxhcnlFbnRyeVJlcXVlc3QSPgoFZW50cnkYASABKAsyKC5oZWFsdGhjYXJlLm'
        '1lZGljYXRpb24udjEuRm9ybXVsYXJ5RW50cnlSBWVudHJ5');

@$core.Deprecated('Use setFormularyEntryResponseDescriptor instead')
const SetFormularyEntryResponse$json = {
  '1': 'SetFormularyEntryResponse',
};

/// Descriptor for `SetFormularyEntryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setFormularyEntryResponseDescriptor =
    $convert.base64Decode('ChlTZXRGb3JtdWxhcnlFbnRyeVJlc3BvbnNl');

@$core.Deprecated('Use interactionRuleDescriptor instead')
const InteractionRule$json = {
  '1': 'InteractionRule',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'left',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'left'
    },
    {
      '1': 'right',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'right'
    },
    {
      '1': 'severity',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.Severity',
      '10': 'severity'
    },
    {'1': 'advice', '3': 6, '4': 1, '5': 9, '10': 'advice'},
    {'1': 'management', '3': 7, '4': 1, '5': 9, '10': 'management'},
    {'1': 'active', '3': 8, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `InteractionRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interactionRuleDescriptor = $convert.base64Decode(
    'Cg9JbnRlcmFjdGlvblJ1bGUSFwoHcnVsZV9pZBgBIAEoCVIGcnVsZUlkEhgKB3ZlcnNpb24YAi'
    'ABKAlSB3ZlcnNpb24SNAoEbGVmdBgDIAEoCzIgLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5D'
    'b2RpbmdSBGxlZnQSNgoFcmlnaHQYBCABKAsyIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ2'
    '9kaW5nUgVyaWdodBI+CghzZXZlcml0eRgFIAEoDjIiLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52'
    'MS5TZXZlcml0eVIIc2V2ZXJpdHkSFgoGYWR2aWNlGAYgASgJUgZhZHZpY2USHgoKbWFuYWdlbW'
    'VudBgHIAEoCVIKbWFuYWdlbWVudBIWCgZhY3RpdmUYCCABKAhSBmFjdGl2ZQ==');

@$core.Deprecated('Use setInteractionRuleRequestDescriptor instead')
const SetInteractionRuleRequest$json = {
  '1': 'SetInteractionRuleRequest',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.InteractionRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `SetInteractionRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setInteractionRuleRequestDescriptor =
    $convert.base64Decode(
        'ChlTZXRJbnRlcmFjdGlvblJ1bGVSZXF1ZXN0Ej0KBHJ1bGUYASABKAsyKS5oZWFsdGhjYXJlLm'
        '1lZGljYXRpb24udjEuSW50ZXJhY3Rpb25SdWxlUgRydWxl');

@$core.Deprecated('Use setInteractionRuleResponseDescriptor instead')
const SetInteractionRuleResponse$json = {
  '1': 'SetInteractionRuleResponse',
};

/// Descriptor for `SetInteractionRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setInteractionRuleResponseDescriptor =
    $convert.base64Decode('ChpTZXRJbnRlcmFjdGlvblJ1bGVSZXNwb25zZQ==');

@$core.Deprecated('Use listInteractionRulesRequestDescriptor instead')
const ListInteractionRulesRequest$json = {
  '1': 'ListInteractionRulesRequest',
};

/// Descriptor for `ListInteractionRulesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInteractionRulesRequestDescriptor =
    $convert.base64Decode('ChtMaXN0SW50ZXJhY3Rpb25SdWxlc1JlcXVlc3Q=');

@$core.Deprecated('Use listInteractionRulesResponseDescriptor instead')
const ListInteractionRulesResponse$json = {
  '1': 'ListInteractionRulesResponse',
  '2': [
    {
      '1': 'rules',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.InteractionRule',
      '10': 'rules'
    },
  ],
};

/// Descriptor for `ListInteractionRulesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInteractionRulesResponseDescriptor =
    $convert.base64Decode(
        'ChxMaXN0SW50ZXJhY3Rpb25SdWxlc1Jlc3BvbnNlEj8KBXJ1bGVzGAEgAygLMikuaGVhbHRoY2'
        'FyZS5tZWRpY2F0aW9uLnYxLkludGVyYWN0aW9uUnVsZVIFcnVsZXM=');

@$core.Deprecated('Use doseRuleDescriptor instead')
const DoseRule$json = {
  '1': 'DoseRule',
  '2': [
    {'1': 'rule_id', '3': 1, '4': 1, '5': 9, '10': 'ruleId'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {
      '1': 'scope',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.DoseRuleScope',
      '10': 'scope'
    },
    {
      '1': 'medication',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'medication'
    },
    {
      '1': 'max_creatinine_clearance',
      '3': 5,
      '4': 1,
      '5': 1,
      '10': 'maxCreatinineClearance'
    },
    {'1': 'max_age_years', '3': 6, '4': 1, '5': 1, '10': 'maxAgeYears'},
    {'1': 'advice', '3': 7, '4': 1, '5': 9, '10': 'advice'},
    {'1': 'validated', '3': 8, '4': 1, '5': 8, '10': 'validated'},
    {'1': 'active', '3': 9, '4': 1, '5': 8, '10': 'active'},
  ],
};

/// Descriptor for `DoseRule`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List doseRuleDescriptor = $convert.base64Decode(
    'CghEb3NlUnVsZRIXCgdydWxlX2lkGAEgASgJUgZydWxlSWQSGAoHdmVyc2lvbhgCIAEoCVIHdm'
    'Vyc2lvbhI9CgVzY29wZRgDIAEoDjInLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5Eb3NlUnVs'
    'ZVNjb3BlUgVzY29wZRJACgptZWRpY2F0aW9uGAQgASgLMiAuaGVhbHRoY2FyZS5tZWRpY2F0aW'
    '9uLnYxLkNvZGluZ1IKbWVkaWNhdGlvbhI4ChhtYXhfY3JlYXRpbmluZV9jbGVhcmFuY2UYBSAB'
    'KAFSFm1heENyZWF0aW5pbmVDbGVhcmFuY2USIgoNbWF4X2FnZV95ZWFycxgGIAEoAVILbWF4QW'
    'dlWWVhcnMSFgoGYWR2aWNlGAcgASgJUgZhZHZpY2USHAoJdmFsaWRhdGVkGAggASgIUgl2YWxp'
    'ZGF0ZWQSFgoGYWN0aXZlGAkgASgIUgZhY3RpdmU=');

@$core.Deprecated('Use setDoseRuleRequestDescriptor instead')
const SetDoseRuleRequest$json = {
  '1': 'SetDoseRuleRequest',
  '2': [
    {
      '1': 'rule',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.DoseRule',
      '10': 'rule'
    },
  ],
};

/// Descriptor for `SetDoseRuleRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDoseRuleRequestDescriptor = $convert.base64Decode(
    'ChJTZXREb3NlUnVsZVJlcXVlc3QSNgoEcnVsZRgBIAEoCzIiLmhlYWx0aGNhcmUubWVkaWNhdG'
    'lvbi52MS5Eb3NlUnVsZVIEcnVsZQ==');

@$core.Deprecated('Use setDoseRuleResponseDescriptor instead')
const SetDoseRuleResponse$json = {
  '1': 'SetDoseRuleResponse',
};

/// Descriptor for `SetDoseRuleResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDoseRuleResponseDescriptor =
    $convert.base64Decode('ChNTZXREb3NlUnVsZVJlc3BvbnNl');

@$core.Deprecated('Use terminologyMappingDescriptor instead')
const TerminologyMapping$json = {
  '1': 'TerminologyMapping',
  '2': [
    {
      '1': 'medication',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'medication'
    },
    {
      '1': 'ingredients',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'ingredients'
    },
    {
      '1': 'classes',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'classes'
    },
    {
      '1': 'therapeutic_moiety',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.Coding',
      '10': 'therapeuticMoiety'
    },
    {'1': 'map_version', '3': 5, '4': 1, '5': 9, '10': 'mapVersion'},
  ],
};

/// Descriptor for `TerminologyMapping`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terminologyMappingDescriptor = $convert.base64Decode(
    'ChJUZXJtaW5vbG9neU1hcHBpbmcSQAoKbWVkaWNhdGlvbhgBIAEoCzIgLmhlYWx0aGNhcmUubW'
    'VkaWNhdGlvbi52MS5Db2RpbmdSCm1lZGljYXRpb24SQgoLaW5ncmVkaWVudHMYAiADKAsyIC5o'
    'ZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUgtpbmdyZWRpZW50cxI6CgdjbGFzc2VzGA'
    'MgAygLMiAuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLkNvZGluZ1IHY2xhc3NlcxJPChJ0aGVy'
    'YXBldXRpY19tb2lldHkYBCABKAsyIC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQ29kaW5nUh'
    'F0aGVyYXBldXRpY01vaWV0eRIfCgttYXBfdmVyc2lvbhgFIAEoCVIKbWFwVmVyc2lvbg==');

@$core.Deprecated('Use setTerminologyMappingRequestDescriptor instead')
const SetTerminologyMappingRequest$json = {
  '1': 'SetTerminologyMappingRequest',
  '2': [
    {
      '1': 'mapping',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.TerminologyMapping',
      '10': 'mapping'
    },
  ],
};

/// Descriptor for `SetTerminologyMappingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTerminologyMappingRequestDescriptor =
    $convert.base64Decode(
        'ChxTZXRUZXJtaW5vbG9neU1hcHBpbmdSZXF1ZXN0EkYKB21hcHBpbmcYASABKAsyLC5oZWFsdG'
        'hjYXJlLm1lZGljYXRpb24udjEuVGVybWlub2xvZ3lNYXBwaW5nUgdtYXBwaW5n');

@$core.Deprecated('Use setTerminologyMappingResponseDescriptor instead')
const SetTerminologyMappingResponse$json = {
  '1': 'SetTerminologyMappingResponse',
};

/// Descriptor for `SetTerminologyMappingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setTerminologyMappingResponseDescriptor =
    $convert.base64Decode('Ch1TZXRUZXJtaW5vbG9neU1hcHBpbmdSZXNwb25zZQ==');

@$core.Deprecated('Use medicationPolicyDescriptor instead')
const MedicationPolicy$json = {
  '1': 'MedicationPolicy',
  '2': [
    {
      '1': 'max_overridable',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.healthcare.medication.v1.Severity',
      '10': 'maxOverridable'
    },
    {
      '1': 'verification_required',
      '3': 2,
      '4': 1,
      '5': 8,
      '10': 'verificationRequired'
    },
    {
      '1': 'verification_classes',
      '3': 3,
      '4': 3,
      '5': 9,
      '10': 'verificationClasses'
    },
    {
      '1': 'structured_dose_classes',
      '3': 4,
      '4': 3,
      '5': 9,
      '10': 'structuredDoseClasses'
    },
  ],
};

/// Descriptor for `MedicationPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List medicationPolicyDescriptor = $convert.base64Decode(
    'ChBNZWRpY2F0aW9uUG9saWN5EksKD21heF9vdmVycmlkYWJsZRgBIAEoDjIiLmhlYWx0aGNhcm'
    'UubWVkaWNhdGlvbi52MS5TZXZlcml0eVIObWF4T3ZlcnJpZGFibGUSMwoVdmVyaWZpY2F0aW9u'
    'X3JlcXVpcmVkGAIgASgIUhR2ZXJpZmljYXRpb25SZXF1aXJlZBIxChR2ZXJpZmljYXRpb25fY2'
    'xhc3NlcxgDIAMoCVITdmVyaWZpY2F0aW9uQ2xhc3NlcxI2ChdzdHJ1Y3R1cmVkX2Rvc2VfY2xh'
    'c3NlcxgEIAMoCVIVc3RydWN0dXJlZERvc2VDbGFzc2Vz');

@$core.Deprecated('Use setMedicationPolicyRequestDescriptor instead')
const SetMedicationPolicyRequest$json = {
  '1': 'SetMedicationPolicyRequest',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.MedicationPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `SetMedicationPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setMedicationPolicyRequestDescriptor =
    $convert.base64Decode(
        'ChpTZXRNZWRpY2F0aW9uUG9saWN5UmVxdWVzdBJCCgZwb2xpY3kYASABKAsyKi5oZWFsdGhjYX'
        'JlLm1lZGljYXRpb24udjEuTWVkaWNhdGlvblBvbGljeVIGcG9saWN5');

@$core.Deprecated('Use setMedicationPolicyResponseDescriptor instead')
const SetMedicationPolicyResponse$json = {
  '1': 'SetMedicationPolicyResponse',
};

/// Descriptor for `SetMedicationPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setMedicationPolicyResponseDescriptor =
    $convert.base64Decode('ChtTZXRNZWRpY2F0aW9uUG9saWN5UmVzcG9uc2U=');

@$core.Deprecated('Use getMedicationPolicyRequestDescriptor instead')
const GetMedicationPolicyRequest$json = {
  '1': 'GetMedicationPolicyRequest',
};

/// Descriptor for `GetMedicationPolicyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMedicationPolicyRequestDescriptor =
    $convert.base64Decode('ChpHZXRNZWRpY2F0aW9uUG9saWN5UmVxdWVzdA==');

@$core.Deprecated('Use getMedicationPolicyResponseDescriptor instead')
const GetMedicationPolicyResponse$json = {
  '1': 'GetMedicationPolicyResponse',
  '2': [
    {
      '1': 'policy',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.healthcare.medication.v1.MedicationPolicy',
      '10': 'policy'
    },
  ],
};

/// Descriptor for `GetMedicationPolicyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getMedicationPolicyResponseDescriptor =
    $convert.base64Decode(
        'ChtHZXRNZWRpY2F0aW9uUG9saWN5UmVzcG9uc2USQgoGcG9saWN5GAEgASgLMiouaGVhbHRoY2'
        'FyZS5tZWRpY2F0aW9uLnYxLk1lZGljYXRpb25Qb2xpY3lSBnBvbGljeQ==');

const $core.Map<$core.String, $core.dynamic> MedicationServiceBase$json = {
  '1': 'MedicationService',
  '2': [
    {
      '1': 'Prescribe',
      '2': '.healthcare.medication.v1.PrescribeRequest',
      '3': '.healthcare.medication.v1.PrescribeResponse'
    },
    {
      '1': 'GetPrescription',
      '2': '.healthcare.medication.v1.GetPrescriptionRequest',
      '3': '.healthcare.medication.v1.GetPrescriptionResponse'
    },
    {
      '1': 'ListPrescriptions',
      '2': '.healthcare.medication.v1.ListPrescriptionsRequest',
      '3': '.healthcare.medication.v1.ListPrescriptionsResponse'
    },
    {
      '1': 'HoldTherapy',
      '2': '.healthcare.medication.v1.HoldTherapyRequest',
      '3': '.healthcare.medication.v1.HoldTherapyResponse'
    },
    {
      '1': 'RestartTherapy',
      '2': '.healthcare.medication.v1.RestartTherapyRequest',
      '3': '.healthcare.medication.v1.RestartTherapyResponse'
    },
    {
      '1': 'DiscontinueTherapy',
      '2': '.healthcare.medication.v1.DiscontinueTherapyRequest',
      '3': '.healthcare.medication.v1.DiscontinueTherapyResponse'
    },
    {
      '1': 'VerifyPrescription',
      '2': '.healthcare.medication.v1.VerifyPrescriptionRequest',
      '3': '.healthcare.medication.v1.VerifyPrescriptionResponse'
    },
    {
      '1': 'VerificationQueue',
      '2': '.healthcare.medication.v1.VerificationQueueRequest',
      '3': '.healthcare.medication.v1.VerificationQueueResponse'
    },
    {
      '1': 'DueDoses',
      '2': '.healthcare.medication.v1.DueDosesRequest',
      '3': '.healthcare.medication.v1.DueDosesResponse'
    },
    {
      '1': 'StartReconciliation',
      '2': '.healthcare.medication.v1.StartReconciliationRequest',
      '3': '.healthcare.medication.v1.StartReconciliationResponse'
    },
    {
      '1': 'DecideReconciliation',
      '2': '.healthcare.medication.v1.DecideReconciliationRequest',
      '3': '.healthcare.medication.v1.DecideReconciliationResponse'
    },
    {
      '1': 'CompleteReconciliation',
      '2': '.healthcare.medication.v1.CompleteReconciliationRequest',
      '3': '.healthcare.medication.v1.CompleteReconciliationResponse'
    },
    {
      '1': 'ListReconciliations',
      '2': '.healthcare.medication.v1.ListReconciliationsRequest',
      '3': '.healthcare.medication.v1.ListReconciliationsResponse'
    },
    {
      '1': 'ProposeSubstitution',
      '2': '.healthcare.medication.v1.ProposeSubstitutionRequest',
      '3': '.healthcare.medication.v1.ProposeSubstitutionResponse'
    },
    {
      '1': 'AuthorizeSubstitution',
      '2': '.healthcare.medication.v1.AuthorizeSubstitutionRequest',
      '3': '.healthcare.medication.v1.AuthorizeSubstitutionResponse'
    },
    {
      '1': 'RejectSubstitution',
      '2': '.healthcare.medication.v1.RejectSubstitutionRequest',
      '3': '.healthcare.medication.v1.RejectSubstitutionResponse'
    },
    {
      '1': 'DispenseSubstitution',
      '2': '.healthcare.medication.v1.DispenseSubstitutionRequest',
      '3': '.healthcare.medication.v1.DispenseSubstitutionResponse'
    },
    {
      '1': 'ListSubstitutions',
      '2': '.healthcare.medication.v1.ListSubstitutionsRequest',
      '3': '.healthcare.medication.v1.ListSubstitutionsResponse'
    },
    {
      '1': 'SetFormularyEntry',
      '2': '.healthcare.medication.v1.SetFormularyEntryRequest',
      '3': '.healthcare.medication.v1.SetFormularyEntryResponse'
    },
    {
      '1': 'SetInteractionRule',
      '2': '.healthcare.medication.v1.SetInteractionRuleRequest',
      '3': '.healthcare.medication.v1.SetInteractionRuleResponse'
    },
    {
      '1': 'ListInteractionRules',
      '2': '.healthcare.medication.v1.ListInteractionRulesRequest',
      '3': '.healthcare.medication.v1.ListInteractionRulesResponse'
    },
    {
      '1': 'SetDoseRule',
      '2': '.healthcare.medication.v1.SetDoseRuleRequest',
      '3': '.healthcare.medication.v1.SetDoseRuleResponse'
    },
    {
      '1': 'SetTerminologyMapping',
      '2': '.healthcare.medication.v1.SetTerminologyMappingRequest',
      '3': '.healthcare.medication.v1.SetTerminologyMappingResponse'
    },
    {
      '1': 'SetMedicationPolicy',
      '2': '.healthcare.medication.v1.SetMedicationPolicyRequest',
      '3': '.healthcare.medication.v1.SetMedicationPolicyResponse'
    },
    {
      '1': 'GetMedicationPolicy',
      '2': '.healthcare.medication.v1.GetMedicationPolicyRequest',
      '3': '.healthcare.medication.v1.GetMedicationPolicyResponse'
    },
  ],
};

@$core.Deprecated('Use medicationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    MedicationServiceBase$messageJson = {
  '.healthcare.medication.v1.PrescribeRequest': PrescribeRequest$json,
  '.healthcare.medication.v1.Coding': Coding$json,
  '.healthcare.medication.v1.DoseSegment': DoseSegment$json,
  '.healthcare.medication.v1.Quantity': Quantity$json,
  '.healthcare.medication.v1.Timing': Timing$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.healthcare.medication.v1.StopCondition': StopCondition$json,
  '.healthcare.medication.v1.PrnConstraint': PrnConstraint$json,
  '.healthcare.medication.v1.OverrideAnswer': OverrideAnswer$json,
  '.healthcare.medication.v1.PrescribeResponse': PrescribeResponse$json,
  '.healthcare.medication.v1.Prescription': Prescription$json,
  '.healthcare.medication.v1.TherapyChange': TherapyChange$json,
  '.healthcare.medication.v1.SafetyFinding': SafetyFinding$json,
  '.healthcare.medication.v1.SafetyFinding.InputsEntry':
      SafetyFinding_InputsEntry$json,
  '.healthcare.medication.v1.Override': Override$json,
  '.healthcare.medication.v1.FormularyDecision': FormularyDecision$json,
  '.healthcare.medication.v1.Verification': Verification$json,
  '.healthcare.medication.v1.GetPrescriptionRequest':
      GetPrescriptionRequest$json,
  '.healthcare.medication.v1.GetPrescriptionResponse':
      GetPrescriptionResponse$json,
  '.healthcare.medication.v1.ListPrescriptionsRequest':
      ListPrescriptionsRequest$json,
  '.healthcare.medication.v1.ListPrescriptionsResponse':
      ListPrescriptionsResponse$json,
  '.healthcare.medication.v1.HoldTherapyRequest': HoldTherapyRequest$json,
  '.healthcare.medication.v1.ChangeTherapyRequest': ChangeTherapyRequest$json,
  '.healthcare.medication.v1.HoldTherapyResponse': HoldTherapyResponse$json,
  '.healthcare.medication.v1.RestartTherapyRequest': RestartTherapyRequest$json,
  '.healthcare.medication.v1.RestartTherapyResponse':
      RestartTherapyResponse$json,
  '.healthcare.medication.v1.DiscontinueTherapyRequest':
      DiscontinueTherapyRequest$json,
  '.healthcare.medication.v1.DiscontinueTherapyResponse':
      DiscontinueTherapyResponse$json,
  '.healthcare.medication.v1.VerifyPrescriptionRequest':
      VerifyPrescriptionRequest$json,
  '.healthcare.medication.v1.VerifyPrescriptionResponse':
      VerifyPrescriptionResponse$json,
  '.healthcare.medication.v1.VerificationQueueRequest':
      VerificationQueueRequest$json,
  '.healthcare.medication.v1.VerificationQueueResponse':
      VerificationQueueResponse$json,
  '.healthcare.medication.v1.DueDosesRequest': DueDosesRequest$json,
  '.healthcare.medication.v1.DueDosesResponse': DueDosesResponse$json,
  '.healthcare.medication.v1.DueDose': DueDose$json,
  '.healthcare.medication.v1.StartReconciliationRequest':
      StartReconciliationRequest$json,
  '.healthcare.medication.v1.ReconciliationItem': ReconciliationItem$json,
  '.healthcare.medication.v1.StartReconciliationResponse':
      StartReconciliationResponse$json,
  '.healthcare.medication.v1.Reconciliation': Reconciliation$json,
  '.healthcare.medication.v1.DecideReconciliationRequest':
      DecideReconciliationRequest$json,
  '.healthcare.medication.v1.DecideReconciliationResponse':
      DecideReconciliationResponse$json,
  '.healthcare.medication.v1.CompleteReconciliationRequest':
      CompleteReconciliationRequest$json,
  '.healthcare.medication.v1.CompleteReconciliationResponse':
      CompleteReconciliationResponse$json,
  '.healthcare.medication.v1.ListReconciliationsRequest':
      ListReconciliationsRequest$json,
  '.healthcare.medication.v1.ListReconciliationsResponse':
      ListReconciliationsResponse$json,
  '.healthcare.medication.v1.ProposeSubstitutionRequest':
      ProposeSubstitutionRequest$json,
  '.healthcare.medication.v1.ProposeSubstitutionResponse':
      ProposeSubstitutionResponse$json,
  '.healthcare.medication.v1.Substitution': Substitution$json,
  '.healthcare.medication.v1.AuthorizeSubstitutionRequest':
      AuthorizeSubstitutionRequest$json,
  '.healthcare.medication.v1.AdvanceSubstitutionRequest':
      AdvanceSubstitutionRequest$json,
  '.healthcare.medication.v1.AuthorizeSubstitutionResponse':
      AuthorizeSubstitutionResponse$json,
  '.healthcare.medication.v1.RejectSubstitutionRequest':
      RejectSubstitutionRequest$json,
  '.healthcare.medication.v1.RejectSubstitutionResponse':
      RejectSubstitutionResponse$json,
  '.healthcare.medication.v1.DispenseSubstitutionRequest':
      DispenseSubstitutionRequest$json,
  '.healthcare.medication.v1.DispenseSubstitutionResponse':
      DispenseSubstitutionResponse$json,
  '.healthcare.medication.v1.ListSubstitutionsRequest':
      ListSubstitutionsRequest$json,
  '.healthcare.medication.v1.ListSubstitutionsResponse':
      ListSubstitutionsResponse$json,
  '.healthcare.medication.v1.SetFormularyEntryRequest':
      SetFormularyEntryRequest$json,
  '.healthcare.medication.v1.FormularyEntry': FormularyEntry$json,
  '.healthcare.medication.v1.SetFormularyEntryResponse':
      SetFormularyEntryResponse$json,
  '.healthcare.medication.v1.SetInteractionRuleRequest':
      SetInteractionRuleRequest$json,
  '.healthcare.medication.v1.InteractionRule': InteractionRule$json,
  '.healthcare.medication.v1.SetInteractionRuleResponse':
      SetInteractionRuleResponse$json,
  '.healthcare.medication.v1.ListInteractionRulesRequest':
      ListInteractionRulesRequest$json,
  '.healthcare.medication.v1.ListInteractionRulesResponse':
      ListInteractionRulesResponse$json,
  '.healthcare.medication.v1.SetDoseRuleRequest': SetDoseRuleRequest$json,
  '.healthcare.medication.v1.DoseRule': DoseRule$json,
  '.healthcare.medication.v1.SetDoseRuleResponse': SetDoseRuleResponse$json,
  '.healthcare.medication.v1.SetTerminologyMappingRequest':
      SetTerminologyMappingRequest$json,
  '.healthcare.medication.v1.TerminologyMapping': TerminologyMapping$json,
  '.healthcare.medication.v1.SetTerminologyMappingResponse':
      SetTerminologyMappingResponse$json,
  '.healthcare.medication.v1.SetMedicationPolicyRequest':
      SetMedicationPolicyRequest$json,
  '.healthcare.medication.v1.MedicationPolicy': MedicationPolicy$json,
  '.healthcare.medication.v1.SetMedicationPolicyResponse':
      SetMedicationPolicyResponse$json,
  '.healthcare.medication.v1.GetMedicationPolicyRequest':
      GetMedicationPolicyRequest$json,
  '.healthcare.medication.v1.GetMedicationPolicyResponse':
      GetMedicationPolicyResponse$json,
};

/// Descriptor for `MedicationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List medicationServiceDescriptor = $convert.base64Decode(
    'ChFNZWRpY2F0aW9uU2VydmljZRJkCglQcmVzY3JpYmUSKi5oZWFsdGhjYXJlLm1lZGljYXRpb2'
    '4udjEuUHJlc2NyaWJlUmVxdWVzdBorLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5QcmVzY3Jp'
    'YmVSZXNwb25zZRJ2Cg9HZXRQcmVzY3JpcHRpb24SMC5oZWFsdGhjYXJlLm1lZGljYXRpb24udj'
    'EuR2V0UHJlc2NyaXB0aW9uUmVxdWVzdBoxLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5HZXRQ'
    'cmVzY3JpcHRpb25SZXNwb25zZRJ8ChFMaXN0UHJlc2NyaXB0aW9ucxIyLmhlYWx0aGNhcmUubW'
    'VkaWNhdGlvbi52MS5MaXN0UHJlc2NyaXB0aW9uc1JlcXVlc3QaMy5oZWFsdGhjYXJlLm1lZGlj'
    'YXRpb24udjEuTGlzdFByZXNjcmlwdGlvbnNSZXNwb25zZRJqCgtIb2xkVGhlcmFweRIsLmhlYW'
    'x0aGNhcmUubWVkaWNhdGlvbi52MS5Ib2xkVGhlcmFweVJlcXVlc3QaLS5oZWFsdGhjYXJlLm1l'
    'ZGljYXRpb24udjEuSG9sZFRoZXJhcHlSZXNwb25zZRJzCg5SZXN0YXJ0VGhlcmFweRIvLmhlYW'
    'x0aGNhcmUubWVkaWNhdGlvbi52MS5SZXN0YXJ0VGhlcmFweVJlcXVlc3QaMC5oZWFsdGhjYXJl'
    'Lm1lZGljYXRpb24udjEuUmVzdGFydFRoZXJhcHlSZXNwb25zZRJ/ChJEaXNjb250aW51ZVRoZX'
    'JhcHkSMy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuRGlzY29udGludWVUaGVyYXB5UmVxdWVz'
    'dBo0LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5EaXNjb250aW51ZVRoZXJhcHlSZXNwb25zZR'
    'J/ChJWZXJpZnlQcmVzY3JpcHRpb24SMy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuVmVyaWZ5'
    'UHJlc2NyaXB0aW9uUmVxdWVzdBo0LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5WZXJpZnlQcm'
    'VzY3JpcHRpb25SZXNwb25zZRJ8ChFWZXJpZmljYXRpb25RdWV1ZRIyLmhlYWx0aGNhcmUubWVk'
    'aWNhdGlvbi52MS5WZXJpZmljYXRpb25RdWV1ZVJlcXVlc3QaMy5oZWFsdGhjYXJlLm1lZGljYX'
    'Rpb24udjEuVmVyaWZpY2F0aW9uUXVldWVSZXNwb25zZRJhCghEdWVEb3NlcxIpLmhlYWx0aGNh'
    'cmUubWVkaWNhdGlvbi52MS5EdWVEb3Nlc1JlcXVlc3QaKi5oZWFsdGhjYXJlLm1lZGljYXRpb2'
    '4udjEuRHVlRG9zZXNSZXNwb25zZRKCAQoTU3RhcnRSZWNvbmNpbGlhdGlvbhI0LmhlYWx0aGNh'
    'cmUubWVkaWNhdGlvbi52MS5TdGFydFJlY29uY2lsaWF0aW9uUmVxdWVzdBo1LmhlYWx0aGNhcm'
    'UubWVkaWNhdGlvbi52MS5TdGFydFJlY29uY2lsaWF0aW9uUmVzcG9uc2UShQEKFERlY2lkZVJl'
    'Y29uY2lsaWF0aW9uEjUuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLkRlY2lkZVJlY29uY2lsaW'
    'F0aW9uUmVxdWVzdBo2LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5EZWNpZGVSZWNvbmNpbGlh'
    'dGlvblJlc3BvbnNlEosBChZDb21wbGV0ZVJlY29uY2lsaWF0aW9uEjcuaGVhbHRoY2FyZS5tZW'
    'RpY2F0aW9uLnYxLkNvbXBsZXRlUmVjb25jaWxpYXRpb25SZXF1ZXN0GjguaGVhbHRoY2FyZS5t'
    'ZWRpY2F0aW9uLnYxLkNvbXBsZXRlUmVjb25jaWxpYXRpb25SZXNwb25zZRKCAQoTTGlzdFJlY2'
    '9uY2lsaWF0aW9ucxI0LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5MaXN0UmVjb25jaWxpYXRp'
    'b25zUmVxdWVzdBo1LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5MaXN0UmVjb25jaWxpYXRpb2'
    '5zUmVzcG9uc2USggEKE1Byb3Bvc2VTdWJzdGl0dXRpb24SNC5oZWFsdGhjYXJlLm1lZGljYXRp'
    'b24udjEuUHJvcG9zZVN1YnN0aXR1dGlvblJlcXVlc3QaNS5oZWFsdGhjYXJlLm1lZGljYXRpb2'
    '4udjEuUHJvcG9zZVN1YnN0aXR1dGlvblJlc3BvbnNlEogBChVBdXRob3JpemVTdWJzdGl0dXRp'
    'b24SNi5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuQXV0aG9yaXplU3Vic3RpdHV0aW9uUmVxdW'
    'VzdBo3LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5BdXRob3JpemVTdWJzdGl0dXRpb25SZXNw'
    'b25zZRJ/ChJSZWplY3RTdWJzdGl0dXRpb24SMy5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuUm'
    'VqZWN0U3Vic3RpdHV0aW9uUmVxdWVzdBo0LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5SZWpl'
    'Y3RTdWJzdGl0dXRpb25SZXNwb25zZRKFAQoURGlzcGVuc2VTdWJzdGl0dXRpb24SNS5oZWFsdG'
    'hjYXJlLm1lZGljYXRpb24udjEuRGlzcGVuc2VTdWJzdGl0dXRpb25SZXF1ZXN0GjYuaGVhbHRo'
    'Y2FyZS5tZWRpY2F0aW9uLnYxLkRpc3BlbnNlU3Vic3RpdHV0aW9uUmVzcG9uc2USfAoRTGlzdF'
    'N1YnN0aXR1dGlvbnMSMi5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuTGlzdFN1YnN0aXR1dGlv'
    'bnNSZXF1ZXN0GjMuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLkxpc3RTdWJzdGl0dXRpb25zUm'
    'VzcG9uc2USfAoRU2V0Rm9ybXVsYXJ5RW50cnkSMi5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEu'
    'U2V0Rm9ybXVsYXJ5RW50cnlSZXF1ZXN0GjMuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlNldE'
    'Zvcm11bGFyeUVudHJ5UmVzcG9uc2USfwoSU2V0SW50ZXJhY3Rpb25SdWxlEjMuaGVhbHRoY2Fy'
    'ZS5tZWRpY2F0aW9uLnYxLlNldEludGVyYWN0aW9uUnVsZVJlcXVlc3QaNC5oZWFsdGhjYXJlLm'
    '1lZGljYXRpb24udjEuU2V0SW50ZXJhY3Rpb25SdWxlUmVzcG9uc2UShQEKFExpc3RJbnRlcmFj'
    'dGlvblJ1bGVzEjUuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLkxpc3RJbnRlcmFjdGlvblJ1bG'
    'VzUmVxdWVzdBo2LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5MaXN0SW50ZXJhY3Rpb25SdWxl'
    'c1Jlc3BvbnNlEmoKC1NldERvc2VSdWxlEiwuaGVhbHRoY2FyZS5tZWRpY2F0aW9uLnYxLlNldE'
    'Rvc2VSdWxlUmVxdWVzdBotLmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5TZXREb3NlUnVsZVJl'
    'c3BvbnNlEogBChVTZXRUZXJtaW5vbG9neU1hcHBpbmcSNi5oZWFsdGhjYXJlLm1lZGljYXRpb2'
    '4udjEuU2V0VGVybWlub2xvZ3lNYXBwaW5nUmVxdWVzdBo3LmhlYWx0aGNhcmUubWVkaWNhdGlv'
    'bi52MS5TZXRUZXJtaW5vbG9neU1hcHBpbmdSZXNwb25zZRKCAQoTU2V0TWVkaWNhdGlvblBvbG'
    'ljeRI0LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5TZXRNZWRpY2F0aW9uUG9saWN5UmVxdWVz'
    'dBo1LmhlYWx0aGNhcmUubWVkaWNhdGlvbi52MS5TZXRNZWRpY2F0aW9uUG9saWN5UmVzcG9uc2'
    'USggEKE0dldE1lZGljYXRpb25Qb2xpY3kSNC5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuR2V0'
    'TWVkaWNhdGlvblBvbGljeVJlcXVlc3QaNS5oZWFsdGhjYXJlLm1lZGljYXRpb24udjEuR2V0TW'
    'VkaWNhdGlvblBvbGljeVJlc3BvbnNl');
