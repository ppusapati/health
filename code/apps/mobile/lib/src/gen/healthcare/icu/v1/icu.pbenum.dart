// This is a generated file - do not edit.
//
// Generated from healthcare/icu/v1/icu.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Where the patient came from (SRS-ICU-001).
///
/// A quality measure in its own right: an unplanned ward admission is a
/// deterioration somebody may have missed, and a post-operative bed is a plan.
class AdmissionSource extends $pb.ProtobufEnum {
  static const AdmissionSource ADMISSION_SOURCE_UNSPECIFIED = AdmissionSource._(
      0, _omitEnumNames ? '' : 'ADMISSION_SOURCE_UNSPECIFIED');
  static const AdmissionSource ADMISSION_SOURCE_EMERGENCY =
      AdmissionSource._(1, _omitEnumNames ? '' : 'ADMISSION_SOURCE_EMERGENCY');
  static const AdmissionSource ADMISSION_SOURCE_WARD =
      AdmissionSource._(2, _omitEnumNames ? '' : 'ADMISSION_SOURCE_WARD');
  static const AdmissionSource ADMISSION_SOURCE_THEATRE =
      AdmissionSource._(3, _omitEnumNames ? '' : 'ADMISSION_SOURCE_THEATRE');

  /// From another critical-care unit. Names the episode it continues.
  static const AdmissionSource ADMISSION_SOURCE_OTHER_ICU =
      AdmissionSource._(4, _omitEnumNames ? '' : 'ADMISSION_SOURCE_OTHER_ICU');
  static const AdmissionSource ADMISSION_SOURCE_EXTERNAL =
      AdmissionSource._(5, _omitEnumNames ? '' : 'ADMISSION_SOURCE_EXTERNAL');
  static const AdmissionSource ADMISSION_SOURCE_DIRECT =
      AdmissionSource._(6, _omitEnumNames ? '' : 'ADMISSION_SOURCE_DIRECT');

  static const $core.List<AdmissionSource> values = <AdmissionSource>[
    ADMISSION_SOURCE_UNSPECIFIED,
    ADMISSION_SOURCE_EMERGENCY,
    ADMISSION_SOURCE_WARD,
    ADMISSION_SOURCE_THEATRE,
    ADMISSION_SOURCE_OTHER_ICU,
    ADMISSION_SOURCE_EXTERNAL,
    ADMISSION_SOURCE_DIRECT,
  ];

  static final $core.List<AdmissionSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static AdmissionSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AdmissionSource._(super.value, super.name);
}

class EpisodeStatus extends $pb.ProtobufEnum {
  static const EpisodeStatus EPISODE_STATUS_UNSPECIFIED =
      EpisodeStatus._(0, _omitEnumNames ? '' : 'EPISODE_STATUS_UNSPECIFIED');
  static const EpisodeStatus EPISODE_STATUS_OPEN =
      EpisodeStatus._(1, _omitEnumNames ? '' : 'EPISODE_STATUS_OPEN');

  /// Somebody has said this patient no longer needs critical care. The interval
  /// this opens is the unit's discharge delay.
  static const EpisodeStatus EPISODE_STATUS_READY_FOR_TRANSFER =
      EpisodeStatus._(
          2, _omitEnumNames ? '' : 'EPISODE_STATUS_READY_FOR_TRANSFER');
  static const EpisodeStatus EPISODE_STATUS_CLOSED =
      EpisodeStatus._(3, _omitEnumNames ? '' : 'EPISODE_STATUS_CLOSED');

  static const $core.List<EpisodeStatus> values = <EpisodeStatus>[
    EPISODE_STATUS_UNSPECIFIED,
    EPISODE_STATUS_OPEN,
    EPISODE_STATUS_READY_FOR_TRANSFER,
    EPISODE_STATUS_CLOSED,
  ];

  static final $core.List<EpisodeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static EpisodeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EpisodeStatus._(super.value, super.name);
}

class EpisodeOutcome extends $pb.ProtobufEnum {
  static const EpisodeOutcome EPISODE_OUTCOME_UNSPECIFIED =
      EpisodeOutcome._(0, _omitEnumNames ? '' : 'EPISODE_OUTCOME_UNSPECIFIED');
  static const EpisodeOutcome EPISODE_OUTCOME_WARD =
      EpisodeOutcome._(1, _omitEnumNames ? '' : 'EPISODE_OUTCOME_WARD');
  static const EpisodeOutcome EPISODE_OUTCOME_OTHER_ICU =
      EpisodeOutcome._(2, _omitEnumNames ? '' : 'EPISODE_OUTCOME_OTHER_ICU');
  static const EpisodeOutcome EPISODE_OUTCOME_THEATRE =
      EpisodeOutcome._(3, _omitEnumNames ? '' : 'EPISODE_OUTCOME_THEATRE');
  static const EpisodeOutcome EPISODE_OUTCOME_EXTERNAL_TRANSFER =
      EpisodeOutcome._(
          4, _omitEnumNames ? '' : 'EPISODE_OUTCOME_EXTERNAL_TRANSFER');
  static const EpisodeOutcome EPISODE_OUTCOME_DISCHARGE =
      EpisodeOutcome._(5, _omitEnumNames ? '' : 'EPISODE_OUTCOME_DISCHARGE');
  static const EpisodeOutcome EPISODE_OUTCOME_DEATH =
      EpisodeOutcome._(6, _omitEnumNames ? '' : 'EPISODE_OUTCOME_DEATH');

  static const $core.List<EpisodeOutcome> values = <EpisodeOutcome>[
    EPISODE_OUTCOME_UNSPECIFIED,
    EPISODE_OUTCOME_WARD,
    EPISODE_OUTCOME_OTHER_ICU,
    EPISODE_OUTCOME_THEATRE,
    EPISODE_OUTCOME_EXTERNAL_TRANSFER,
    EPISODE_OUTCOME_DISCHARGE,
    EPISODE_OUTCOME_DEATH,
  ];

  static final $core.List<EpisodeOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static EpisodeOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EpisodeOutcome._(super.value, super.name);
}

/// Where a flowsheet value came from (SRS-ICU-003).
class ObservationSource extends $pb.ProtobufEnum {
  static const ObservationSource OBSERVATION_SOURCE_UNSPECIFIED =
      ObservationSource._(
          0, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_UNSPECIFIED');
  static const ObservationSource OBSERVATION_SOURCE_MANUAL =
      ObservationSource._(1, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_MANUAL');
  static const ObservationSource OBSERVATION_SOURCE_DEVICE =
      ObservationSource._(2, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_DEVICE');
  static const ObservationSource OBSERVATION_SOURCE_CALCULATED =
      ObservationSource._(
          3, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_CALCULATED');
  static const ObservationSource OBSERVATION_SOURCE_UNKNOWN =
      ObservationSource._(
          4, _omitEnumNames ? '' : 'OBSERVATION_SOURCE_UNKNOWN');

  static const $core.List<ObservationSource> values = <ObservationSource>[
    OBSERVATION_SOURCE_UNSPECIFIED,
    OBSERVATION_SOURCE_MANUAL,
    OBSERVATION_SOURCE_DEVICE,
    OBSERVATION_SOURCE_CALCULATED,
    OBSERVATION_SOURCE_UNKNOWN,
  ];

  static final $core.List<ObservationSource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ObservationSource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ObservationSource._(super.value, super.name);
}

/// How far a value has got towards being chartable (SRS-ICU-003).
class ValidationState extends $pb.ProtobufEnum {
  static const ValidationState VALIDATION_STATE_UNSPECIFIED = ValidationState._(
      0, _omitEnumNames ? '' : 'VALIDATION_STATE_UNSPECIFIED');

  /// A value a person entered. They validated it by typing it.
  static const ValidationState VALIDATION_STATE_NOT_REQUIRED =
      ValidationState._(
          1, _omitEnumNames ? '' : 'VALIDATION_STATE_NOT_REQUIRED');
  static const ValidationState VALIDATION_STATE_PENDING =
      ValidationState._(2, _omitEnumNames ? '' : 'VALIDATION_STATE_PENDING');
  static const ValidationState VALIDATION_STATE_CONFIRMED =
      ValidationState._(3, _omitEnumNames ? '' : 'VALIDATION_STATE_CONFIRMED');
  static const ValidationState VALIDATION_STATE_REJECTED =
      ValidationState._(4, _omitEnumNames ? '' : 'VALIDATION_STATE_REJECTED');

  static const $core.List<ValidationState> values = <ValidationState>[
    VALIDATION_STATE_UNSPECIFIED,
    VALIDATION_STATE_NOT_REQUIRED,
    VALIDATION_STATE_PENDING,
    VALIDATION_STATE_CONFIRMED,
    VALIDATION_STATE_REJECTED,
  ];

  static final $core.List<ValidationState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ValidationState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ValidationState._(super.value, super.name);
}

/// A form of organ support (SRS-ICU-011).
class SupportKind extends $pb.ProtobufEnum {
  static const SupportKind SUPPORT_KIND_UNSPECIFIED =
      SupportKind._(0, _omitEnumNames ? '' : 'SUPPORT_KIND_UNSPECIFIED');
  static const SupportKind SUPPORT_KIND_VENTILATION =
      SupportKind._(1, _omitEnumNames ? '' : 'SUPPORT_KIND_VENTILATION');
  static const SupportKind SUPPORT_KIND_VASOPRESSOR =
      SupportKind._(2, _omitEnumNames ? '' : 'SUPPORT_KIND_VASOPRESSOR');
  static const SupportKind SUPPORT_KIND_RENAL_REPLACEMENT =
      SupportKind._(3, _omitEnumNames ? '' : 'SUPPORT_KIND_RENAL_REPLACEMENT');
  static const SupportKind SUPPORT_KIND_ECMO =
      SupportKind._(4, _omitEnumNames ? '' : 'SUPPORT_KIND_ECMO');
  static const SupportKind SUPPORT_KIND_OTHER =
      SupportKind._(5, _omitEnumNames ? '' : 'SUPPORT_KIND_OTHER');

  static const $core.List<SupportKind> values = <SupportKind>[
    SUPPORT_KIND_UNSPECIFIED,
    SUPPORT_KIND_VENTILATION,
    SUPPORT_KIND_VASOPRESSOR,
    SUPPORT_KIND_RENAL_REPLACEMENT,
    SUPPORT_KIND_ECMO,
    SUPPORT_KIND_OTHER,
  ];

  static final $core.List<SupportKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static SupportKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SupportKind._(super.value, super.name);
}

/// A checklist the unit runs (SRS-ICU-010).
class BundleKind extends $pb.ProtobufEnum {
  static const BundleKind BUNDLE_KIND_UNSPECIFIED =
      BundleKind._(0, _omitEnumNames ? '' : 'BUNDLE_KIND_UNSPECIFIED');
  static const BundleKind BUNDLE_KIND_SEPSIS =
      BundleKind._(1, _omitEnumNames ? '' : 'BUNDLE_KIND_SEPSIS');
  static const BundleKind BUNDLE_KIND_VTE =
      BundleKind._(2, _omitEnumNames ? '' : 'BUNDLE_KIND_VTE');
  static const BundleKind BUNDLE_KIND_DELIRIUM =
      BundleKind._(3, _omitEnumNames ? '' : 'BUNDLE_KIND_DELIRIUM');
  static const BundleKind BUNDLE_KIND_PRESSURE_INJURY =
      BundleKind._(4, _omitEnumNames ? '' : 'BUNDLE_KIND_PRESSURE_INJURY');
  static const BundleKind BUNDLE_KIND_SEDATION =
      BundleKind._(5, _omitEnumNames ? '' : 'BUNDLE_KIND_SEDATION');
  static const BundleKind BUNDLE_KIND_VENTILATOR =
      BundleKind._(6, _omitEnumNames ? '' : 'BUNDLE_KIND_VENTILATOR');
  static const BundleKind BUNDLE_KIND_LOCAL =
      BundleKind._(7, _omitEnumNames ? '' : 'BUNDLE_KIND_LOCAL');

  static const $core.List<BundleKind> values = <BundleKind>[
    BUNDLE_KIND_UNSPECIFIED,
    BUNDLE_KIND_SEPSIS,
    BUNDLE_KIND_VTE,
    BUNDLE_KIND_DELIRIUM,
    BUNDLE_KIND_PRESSURE_INJURY,
    BUNDLE_KIND_SEDATION,
    BUNDLE_KIND_VENTILATOR,
    BUNDLE_KIND_LOCAL,
  ];

  static final $core.List<BundleKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static BundleKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BundleKind._(super.value, super.name);
}

/// What happened to one bundle element.
class BundleItemState extends $pb.ProtobufEnum {
  static const BundleItemState BUNDLE_ITEM_STATE_UNSPECIFIED =
      BundleItemState._(
          0, _omitEnumNames ? '' : 'BUNDLE_ITEM_STATE_UNSPECIFIED');
  static const BundleItemState BUNDLE_ITEM_STATE_DONE =
      BundleItemState._(1, _omitEnumNames ? '' : 'BUNDLE_ITEM_STATE_DONE');

  /// Deliberately not done, with a reason. A patient on therapeutic
  /// anticoagulation does not get VTE prophylaxis, and recording that as a
  /// failure teaches the unit to stop recording.
  static const BundleItemState BUNDLE_ITEM_STATE_EXCEPTION =
      BundleItemState._(2, _omitEnumNames ? '' : 'BUNDLE_ITEM_STATE_EXCEPTION');
  static const BundleItemState BUNDLE_ITEM_STATE_NOT_DONE =
      BundleItemState._(3, _omitEnumNames ? '' : 'BUNDLE_ITEM_STATE_NOT_DONE');

  static const $core.List<BundleItemState> values = <BundleItemState>[
    BUNDLE_ITEM_STATE_UNSPECIFIED,
    BUNDLE_ITEM_STATE_DONE,
    BUNDLE_ITEM_STATE_EXCEPTION,
    BUNDLE_ITEM_STATE_NOT_DONE,
  ];

  static final $core.List<BundleItemState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static BundleItemState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BundleItemState._(super.value, super.name);
}

/// How far treatment goes (SRS-ICU-015).
class CareIntent extends $pb.ProtobufEnum {
  static const CareIntent CARE_INTENT_UNSPECIFIED =
      CareIntent._(0, _omitEnumNames ? '' : 'CARE_INTENT_UNSPECIFIED');
  static const CareIntent CARE_INTENT_FULL_ESCALATION =
      CareIntent._(1, _omitEnumNames ? '' : 'CARE_INTENT_FULL_ESCALATION');
  static const CareIntent CARE_INTENT_LIMITED =
      CareIntent._(2, _omitEnumNames ? '' : 'CARE_INTENT_LIMITED');
  static const CareIntent CARE_INTENT_COMFORT =
      CareIntent._(3, _omitEnumNames ? '' : 'CARE_INTENT_COMFORT');

  static const $core.List<CareIntent> values = <CareIntent>[
    CARE_INTENT_UNSPECIFIED,
    CARE_INTENT_FULL_ESCALATION,
    CARE_INTENT_LIMITED,
    CARE_INTENT_COMFORT,
  ];

  static final $core.List<CareIntent?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CareIntent? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CareIntent._(super.value, super.name);
}

class GoalStatus extends $pb.ProtobufEnum {
  static const GoalStatus GOAL_STATUS_UNSPECIFIED =
      GoalStatus._(0, _omitEnumNames ? '' : 'GOAL_STATUS_UNSPECIFIED');
  static const GoalStatus GOAL_STATUS_OPEN =
      GoalStatus._(1, _omitEnumNames ? '' : 'GOAL_STATUS_OPEN');
  static const GoalStatus GOAL_STATUS_MET =
      GoalStatus._(2, _omitEnumNames ? '' : 'GOAL_STATUS_MET');
  static const GoalStatus GOAL_STATUS_NOT_MET =
      GoalStatus._(3, _omitEnumNames ? '' : 'GOAL_STATUS_NOT_MET');
  static const GoalStatus GOAL_STATUS_CANCELLED =
      GoalStatus._(4, _omitEnumNames ? '' : 'GOAL_STATUS_CANCELLED');

  static const $core.List<GoalStatus> values = <GoalStatus>[
    GOAL_STATUS_UNSPECIFIED,
    GOAL_STATUS_OPEN,
    GOAL_STATUS_MET,
    GOAL_STATUS_NOT_MET,
    GOAL_STATUS_CANCELLED,
  ];

  static final $core.List<GoalStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static GoalStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const GoalStatus._(super.value, super.name);
}

class AlarmSeverity extends $pb.ProtobufEnum {
  static const AlarmSeverity ALARM_SEVERITY_UNSPECIFIED =
      AlarmSeverity._(0, _omitEnumNames ? '' : 'ALARM_SEVERITY_UNSPECIFIED');
  static const AlarmSeverity ALARM_SEVERITY_INFORMATION =
      AlarmSeverity._(1, _omitEnumNames ? '' : 'ALARM_SEVERITY_INFORMATION');
  static const AlarmSeverity ALARM_SEVERITY_WARNING =
      AlarmSeverity._(2, _omitEnumNames ? '' : 'ALARM_SEVERITY_WARNING');
  static const AlarmSeverity ALARM_SEVERITY_URGENT =
      AlarmSeverity._(3, _omitEnumNames ? '' : 'ALARM_SEVERITY_URGENT');

  static const $core.List<AlarmSeverity> values = <AlarmSeverity>[
    ALARM_SEVERITY_UNSPECIFIED,
    ALARM_SEVERITY_INFORMATION,
    ALARM_SEVERITY_WARNING,
    ALARM_SEVERITY_URGENT,
  ];

  static final $core.List<AlarmSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static AlarmSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlarmSeverity._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
