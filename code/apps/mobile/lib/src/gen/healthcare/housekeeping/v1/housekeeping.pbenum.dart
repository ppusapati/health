// This is a generated file - do not edit.
//
// Generated from healthcare/housekeeping/v1/housekeeping.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How much a place matters when it is not clean (SRS-HKP-001).
///
/// An enum rather than a number: a hospital that could type "7" would have
/// four wards on seven and nobody able to say what seven meant.
class RiskClass extends $pb.ProtobufEnum {
  static const RiskClass RISK_CLASS_UNSPECIFIED =
      RiskClass._(0, _omitEnumNames ? '' : 'RISK_CLASS_UNSPECIFIED');

  /// Theatres, critical care, isolation rooms, the sterile services clean
  /// room. An overdue clean here is escalated rather than queued.
  static const RiskClass RISK_CLASS_VERY_HIGH =
      RiskClass._(1, _omitEnumNames ? '' : 'RISK_CLASS_VERY_HIGH');

  /// Inpatient wards, treatment rooms, the emergency department.
  static const RiskClass RISK_CLASS_HIGH =
      RiskClass._(2, _omitEnumNames ? '' : 'RISK_CLASS_HIGH');

  /// Outpatient areas, corridors, waiting rooms.
  static const RiskClass RISK_CLASS_MODERATE =
      RiskClass._(3, _omitEnumNames ? '' : 'RISK_CLASS_MODERATE');

  /// Offices and non-clinical storage.
  static const RiskClass RISK_CLASS_LOW =
      RiskClass._(4, _omitEnumNames ? '' : 'RISK_CLASS_LOW');

  static const $core.List<RiskClass> values = <RiskClass>[
    RISK_CLASS_UNSPECIFIED,
    RISK_CLASS_VERY_HIGH,
    RISK_CLASS_HIGH,
    RISK_CLASS_MODERATE,
    RISK_CLASS_LOW,
  ];

  static final $core.List<RiskClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RiskClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RiskClass._(super.value, super.name);
}

/// Why a clean is happening (SRS-HKP-002, SRS-HKP-006).
class TaskKind extends $pb.ProtobufEnum {
  static const TaskKind TASK_KIND_UNSPECIFIED =
      TaskKind._(0, _omitEnumNames ? '' : 'TASK_KIND_UNSPECIFIED');

  /// The scheduled clean the configuration says is due.
  static const TaskKind TASK_KIND_ROUTINE =
      TaskKind._(1, _omitEnumNames ? '' : 'TASK_KIND_ROUTINE');

  /// The clean between one patient and the next. A bed is out of service
  /// until it is done.
  static const TaskKind TASK_KIND_TERMINAL =
      TaskKind._(2, _omitEnumNames ? '' : 'TASK_KIND_TERMINAL');

  /// Blood, body fluid or a chemical. Restricted.
  static const TaskKind TASK_KIND_SPILL =
      TaskKind._(3, _omitEnumNames ? '' : 'TASK_KIND_SPILL');

  /// A periodic deep clean, usually scheduled out of hours.
  static const TaskKind TASK_KIND_DEEP =
      TaskKind._(4, _omitEnumNames ? '' : 'TASK_KIND_DEEP');

  static const $core.List<TaskKind> values = <TaskKind>[
    TASK_KIND_UNSPECIFIED,
    TASK_KIND_ROUTINE,
    TASK_KIND_TERMINAL,
    TASK_KIND_SPILL,
    TASK_KIND_DEEP,
  ];

  static final $core.List<TaskKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskKind._(super.value, super.name);
}

/// Where a cleaning task stands (SRS-HKP-004).
class TaskState extends $pb.ProtobufEnum {
  static const TaskState TASK_STATE_UNSPECIFIED =
      TaskState._(0, _omitEnumNames ? '' : 'TASK_STATE_UNSPECIFIED');
  static const TaskState TASK_STATE_OPEN =
      TaskState._(1, _omitEnumNames ? '' : 'TASK_STATE_OPEN');
  static const TaskState TASK_STATE_IN_PROGRESS =
      TaskState._(2, _omitEnumNames ? '' : 'TASK_STATE_IN_PROGRESS');

  /// The work done and the checklist answered. Not the end: a task in a place
  /// the hospital verifies is not finished until a supervisor says so.
  static const TaskState TASK_STATE_COMPLETED =
      TaskState._(3, _omitEnumNames ? '' : 'TASK_STATE_COMPLETED');
  static const TaskState TASK_STATE_VERIFIED =
      TaskState._(4, _omitEnumNames ? '' : 'TASK_STATE_VERIFIED');

  /// A task that should not have been raised.
  static const TaskState TASK_STATE_CANCELLED =
      TaskState._(5, _omitEnumNames ? '' : 'TASK_STATE_CANCELLED');

  static const $core.List<TaskState> values = <TaskState>[
    TASK_STATE_UNSPECIFIED,
    TASK_STATE_OPEN,
    TASK_STATE_IN_PROGRESS,
    TASK_STATE_COMPLETED,
    TASK_STATE_VERIFIED,
    TASK_STATE_CANCELLED,
  ];

  static final $core.List<TaskState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TaskState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskState._(super.value, super.name);
}

/// Where a bed's cleaning hold stands (SRS-HKP-003).
class HoldState extends $pb.ProtobufEnum {
  static const HoldState HOLD_STATE_UNSPECIFIED =
      HoldState._(0, _omitEnumNames ? '' : 'HOLD_STATE_UNSPECIFIED');

  /// A bed out of service until the terminal clean is done.
  static const HoldState HOLD_STATE_OPEN =
      HoldState._(1, _omitEnumNames ? '' : 'HOLD_STATE_OPEN');

  /// A hold the clean finished.
  static const HoldState HOLD_STATE_RELEASED =
      HoldState._(2, _omitEnumNames ? '' : 'HOLD_STATE_RELEASED');

  /// A hold somebody lifted without the clean finishing. Its own state, so a
  /// hospital cannot count it as a clean.
  static const HoldState HOLD_STATE_OVERRIDDEN =
      HoldState._(3, _omitEnumNames ? '' : 'HOLD_STATE_OVERRIDDEN');

  static const $core.List<HoldState> values = <HoldState>[
    HOLD_STATE_UNSPECIFIED,
    HOLD_STATE_OPEN,
    HOLD_STATE_RELEASED,
    HOLD_STATE_OVERRIDDEN,
  ];

  static final $core.List<HoldState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static HoldState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HoldState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
