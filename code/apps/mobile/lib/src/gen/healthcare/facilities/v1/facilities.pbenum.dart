// This is a generated file - do not edit.
//
// Generated from healthcare/facilities/v1/facilities.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The engineering system an asset, work order or alarm belongs to
/// (SRS-FAC-001).
///
/// An enum rather than free text, because the system decides who is called at
/// three in the morning and what the escalation matrix resolves to.
class System extends $pb.ProtobufEnum {
  static const System SYSTEM_UNSPECIFIED =
      System._(0, _omitEnumNames ? '' : 'SYSTEM_UNSPECIFIED');
  static const System SYSTEM_ELECTRICAL =
      System._(1, _omitEnumNames ? '' : 'SYSTEM_ELECTRICAL');
  static const System SYSTEM_HVAC =
      System._(2, _omitEnumNames ? '' : 'SYSTEM_HVAC');
  static const System SYSTEM_PLUMBING =
      System._(3, _omitEnumNames ? '' : 'SYSTEM_PLUMBING');

  /// Detection, suppression and the passive measures.
  static const System SYSTEM_FIRE =
      System._(4, _omitEnumNames ? '' : 'SYSTEM_FIRE');

  /// The one system on this list whose failure reaches a patient in minutes.
  static const System SYSTEM_MEDICAL_GAS =
      System._(5, _omitEnumNames ? '' : 'SYSTEM_MEDICAL_GAS');
  static const System SYSTEM_LIFTS =
      System._(6, _omitEnumNames ? '' : 'SYSTEM_LIFTS');

  /// RO, softeners and the dialysis loop.
  static const System SYSTEM_WATER =
      System._(7, _omitEnumNames ? '' : 'SYSTEM_WATER');

  /// STP and ETP.
  static const System SYSTEM_EFFLUENT =
      System._(8, _omitEnumNames ? '' : 'SYSTEM_EFFLUENT');
  static const System SYSTEM_POWER =
      System._(9, _omitEnumNames ? '' : 'SYSTEM_POWER');
  static const System SYSTEM_OTHER =
      System._(10, _omitEnumNames ? '' : 'SYSTEM_OTHER');

  static const $core.List<System> values = <System>[
    SYSTEM_UNSPECIFIED,
    SYSTEM_ELECTRICAL,
    SYSTEM_HVAC,
    SYSTEM_PLUMBING,
    SYSTEM_FIRE,
    SYSTEM_MEDICAL_GAS,
    SYSTEM_LIFTS,
    SYSTEM_WATER,
    SYSTEM_EFFLUENT,
    SYSTEM_POWER,
    SYSTEM_OTHER,
  ];

  static final $core.List<System?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 10);
  static System? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const System._(super.value, super.name);
}

/// What happens to the hospital when an asset stops (SRS-FAC-001).
class Criticality extends $pb.ProtobufEnum {
  static const Criticality CRITICALITY_UNSPECIFIED =
      Criticality._(0, _omitEnumNames ? '' : 'CRITICALITY_UNSPECIFIED');

  /// Failure threatens somebody within the hour.
  static const Criticality CRITICALITY_LIFE =
      Criticality._(1, _omitEnumNames ? '' : 'CRITICALITY_LIFE');

  /// Failure stops a service.
  static const Criticality CRITICALITY_HIGH =
      Criticality._(2, _omitEnumNames ? '' : 'CRITICALITY_HIGH');
  static const Criticality CRITICALITY_NORMAL =
      Criticality._(3, _omitEnumNames ? '' : 'CRITICALITY_NORMAL');
  static const Criticality CRITICALITY_LOW =
      Criticality._(4, _omitEnumNames ? '' : 'CRITICALITY_LOW');

  static const $core.List<Criticality> values = <Criticality>[
    CRITICALITY_UNSPECIFIED,
    CRITICALITY_LIFE,
    CRITICALITY_HIGH,
    CRITICALITY_NORMAL,
    CRITICALITY_LOW,
  ];

  static final $core.List<Criticality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Criticality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Criticality._(super.value, super.name);
}

/// Where an asset stands (SRS-FAC-001).
class AssetStatus extends $pb.ProtobufEnum {
  static const AssetStatus ASSET_STATUS_UNSPECIFIED =
      AssetStatus._(0, _omitEnumNames ? '' : 'ASSET_STATUS_UNSPECIFIED');
  static const AssetStatus ASSET_STATUS_IN_SERVICE =
      AssetStatus._(1, _omitEnumNames ? '' : 'ASSET_STATUS_IN_SERVICE');

  /// Running and not right. Its own state, because "working" and "working for
  /// now" lead to different decisions.
  static const AssetStatus ASSET_STATUS_DEGRADED =
      AssetStatus._(2, _omitEnumNames ? '' : 'ASSET_STATUS_DEGRADED');
  static const AssetStatus ASSET_STATUS_DOWN =
      AssetStatus._(3, _omitEnumNames ? '' : 'ASSET_STATUS_DOWN');
  static const AssetStatus ASSET_STATUS_DECOMMISSIONED =
      AssetStatus._(4, _omitEnumNames ? '' : 'ASSET_STATUS_DECOMMISSIONED');

  static const $core.List<AssetStatus> values = <AssetStatus>[
    ASSET_STATUS_UNSPECIFIED,
    ASSET_STATUS_IN_SERVICE,
    ASSET_STATUS_DEGRADED,
    ASSET_STATUS_DOWN,
    ASSET_STATUS_DECOMMISSIONED,
  ];

  static final $core.List<AssetStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AssetStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetStatus._(super.value, super.name);
}

/// How fast a work order needs somebody (SRS-FAC-002).
class Priority extends $pb.ProtobufEnum {
  static const Priority PRIORITY_UNSPECIFIED =
      Priority._(0, _omitEnumNames ? '' : 'PRIORITY_UNSPECIFIED');
  static const Priority PRIORITY_EMERGENCY =
      Priority._(1, _omitEnumNames ? '' : 'PRIORITY_EMERGENCY');
  static const Priority PRIORITY_URGENT =
      Priority._(2, _omitEnumNames ? '' : 'PRIORITY_URGENT');
  static const Priority PRIORITY_ROUTINE =
      Priority._(3, _omitEnumNames ? '' : 'PRIORITY_ROUTINE');
  static const Priority PRIORITY_PLANNED =
      Priority._(4, _omitEnumNames ? '' : 'PRIORITY_PLANNED');

  static const $core.List<Priority> values = <Priority>[
    PRIORITY_UNSPECIFIED,
    PRIORITY_EMERGENCY,
    PRIORITY_URGENT,
    PRIORITY_ROUTINE,
    PRIORITY_PLANNED,
  ];

  static final $core.List<Priority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Priority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Priority._(super.value, super.name);
}

/// Where a work order stands (SRS-FAC-002).
class WorkState extends $pb.ProtobufEnum {
  static const WorkState WORK_STATE_UNSPECIFIED =
      WorkState._(0, _omitEnumNames ? '' : 'WORK_STATE_UNSPECIFIED');
  static const WorkState WORK_STATE_RAISED =
      WorkState._(1, _omitEnumNames ? '' : 'WORK_STATE_RAISED');
  static const WorkState WORK_STATE_ASSIGNED =
      WorkState._(2, _omitEnumNames ? '' : 'WORK_STATE_ASSIGNED');
  static const WorkState WORK_STATE_IN_PROGRESS =
      WorkState._(3, _omitEnumNames ? '' : 'WORK_STATE_IN_PROGRESS');

  /// Waiting on something outside the team. A state rather than a flag,
  /// because an order sitting on hold for a fortnight and one being worked on
  /// look identical otherwise.
  static const WorkState WORK_STATE_ON_HOLD =
      WorkState._(4, _omitEnumNames ? '' : 'WORK_STATE_ON_HOLD');

  /// The engineer says it is fixed. Somebody else checks.
  static const WorkState WORK_STATE_RESOLVED =
      WorkState._(5, _omitEnumNames ? '' : 'WORK_STATE_RESOLVED');
  static const WorkState WORK_STATE_CLOSED =
      WorkState._(6, _omitEnumNames ? '' : 'WORK_STATE_CLOSED');
  static const WorkState WORK_STATE_CANCELLED =
      WorkState._(7, _omitEnumNames ? '' : 'WORK_STATE_CANCELLED');

  static const $core.List<WorkState> values = <WorkState>[
    WORK_STATE_UNSPECIFIED,
    WORK_STATE_RAISED,
    WORK_STATE_ASSIGNED,
    WORK_STATE_IN_PROGRESS,
    WORK_STATE_ON_HOLD,
    WORK_STATE_RESOLVED,
    WORK_STATE_CLOSED,
    WORK_STATE_CANCELLED,
  ];

  static final $core.List<WorkState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static WorkState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WorkState._(super.value, super.name);
}

/// Work a hospital chose to do, or is required to do (SRS-FAC-003).
class MaintenanceKind extends $pb.ProtobufEnum {
  static const MaintenanceKind MAINTENANCE_KIND_UNSPECIFIED = MaintenanceKind._(
      0, _omitEnumNames ? '' : 'MAINTENANCE_KIND_UNSPECIFIED');
  static const MaintenanceKind MAINTENANCE_KIND_PREVENTIVE =
      MaintenanceKind._(1, _omitEnumNames ? '' : 'MAINTENANCE_KIND_PREVENTIVE');

  /// An inspection somebody outside the hospital requires. Closes with a
  /// certificate rather than a note, and cannot be waived.
  static const MaintenanceKind MAINTENANCE_KIND_STATUTORY =
      MaintenanceKind._(2, _omitEnumNames ? '' : 'MAINTENANCE_KIND_STATUTORY');

  static const $core.List<MaintenanceKind> values = <MaintenanceKind>[
    MAINTENANCE_KIND_UNSPECIFIED,
    MAINTENANCE_KIND_PREVENTIVE,
    MAINTENANCE_KIND_STATUTORY,
  ];

  static final $core.List<MaintenanceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static MaintenanceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MaintenanceKind._(super.value, super.name);
}

/// What makes a schedule due (SRS-FAC-003, SRS-FAC-007).
class Trigger extends $pb.ProtobufEnum {
  static const Trigger TRIGGER_UNSPECIFIED =
      Trigger._(0, _omitEnumNames ? '' : 'TRIGGER_UNSPECIFIED');
  static const Trigger TRIGGER_CALENDAR =
      Trigger._(1, _omitEnumNames ? '' : 'TRIGGER_CALENDAR');

  /// Every N running hours, for plant whose wear follows use.
  static const Trigger TRIGGER_RUNTIME =
      Trigger._(2, _omitEnumNames ? '' : 'TRIGGER_RUNTIME');

  /// Whichever comes first.
  static const Trigger TRIGGER_EITHER =
      Trigger._(3, _omitEnumNames ? '' : 'TRIGGER_EITHER');

  static const $core.List<Trigger> values = <Trigger>[
    TRIGGER_UNSPECIFIED,
    TRIGGER_CALENDAR,
    TRIGGER_RUNTIME,
    TRIGGER_EITHER,
  ];

  static final $core.List<Trigger?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Trigger? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Trigger._(super.value, super.name);
}

/// Where one occurrence of a schedule stands (SRS-FAC-003).
class TaskState extends $pb.ProtobufEnum {
  static const TaskState TASK_STATE_UNSPECIFIED =
      TaskState._(0, _omitEnumNames ? '' : 'TASK_STATE_UNSPECIFIED');
  static const TaskState TASK_STATE_PLANNED =
      TaskState._(1, _omitEnumNames ? '' : 'TASK_STATE_PLANNED');
  static const TaskState TASK_STATE_DONE =
      TaskState._(2, _omitEnumNames ? '' : 'TASK_STATE_DONE');

  /// The window closed. Kept rather than deleted: the reportable fact is the
  /// inspection that did not happen.
  static const TaskState TASK_STATE_MISSED =
      TaskState._(3, _omitEnumNames ? '' : 'TASK_STATE_MISSED');
  static const TaskState TASK_STATE_WAIVED =
      TaskState._(4, _omitEnumNames ? '' : 'TASK_STATE_WAIVED');

  static const $core.List<TaskState> values = <TaskState>[
    TASK_STATE_UNSPECIFIED,
    TASK_STATE_PLANNED,
    TASK_STATE_DONE,
    TASK_STATE_MISSED,
    TASK_STATE_WAIVED,
  ];

  static final $core.List<TaskState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskState._(super.value, super.name);
}

/// Where a number came from (SRS-FAC-009).
class Source extends $pb.ProtobufEnum {
  static const Source SOURCE_UNSPECIFIED =
      Source._(0, _omitEnumNames ? '' : 'SOURCE_UNSPECIFIED');
  static const Source SOURCE_MANUAL =
      Source._(1, _omitEnumNames ? '' : 'SOURCE_MANUAL');
  static const Source SOURCE_SCADA =
      Source._(2, _omitEnumNames ? '' : 'SOURCE_SCADA');
  static const Source SOURCE_BMS =
      Source._(3, _omitEnumNames ? '' : 'SOURCE_BMS');
  static const Source SOURCE_AMI =
      Source._(4, _omitEnumNames ? '' : 'SOURCE_AMI');
  static const Source SOURCE_VENDOR =
      Source._(5, _omitEnumNames ? '' : 'SOURCE_VENDOR');

  /// Derived rather than measured. Its own source because a calculated figure
  /// inherits every error in its inputs.
  static const Source SOURCE_CALCULATED =
      Source._(6, _omitEnumNames ? '' : 'SOURCE_CALCULATED');

  static const $core.List<Source> values = <Source>[
    SOURCE_UNSPECIFIED,
    SOURCE_MANUAL,
    SOURCE_SCADA,
    SOURCE_BMS,
    SOURCE_AMI,
    SOURCE_VENDOR,
    SOURCE_CALCULATED,
  ];

  static final $core.List<Source?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static Source? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Source._(super.value, super.name);
}

/// What a meter measures (SRS-FAC-009).
class Utility extends $pb.ProtobufEnum {
  static const Utility UTILITY_UNSPECIFIED =
      Utility._(0, _omitEnumNames ? '' : 'UTILITY_UNSPECIFIED');
  static const Utility UTILITY_ELECTRICITY =
      Utility._(1, _omitEnumNames ? '' : 'UTILITY_ELECTRICITY');
  static const Utility UTILITY_WATER =
      Utility._(2, _omitEnumNames ? '' : 'UTILITY_WATER');
  static const Utility UTILITY_DIESEL =
      Utility._(3, _omitEnumNames ? '' : 'UTILITY_DIESEL');
  static const Utility UTILITY_OXYGEN =
      Utility._(4, _omitEnumNames ? '' : 'UTILITY_OXYGEN');
  static const Utility UTILITY_LPG =
      Utility._(5, _omitEnumNames ? '' : 'UTILITY_LPG');
  static const Utility UTILITY_STEAM =
      Utility._(6, _omitEnumNames ? '' : 'UTILITY_STEAM');

  /// What leaves rather than what arrives, metered because the consent to
  /// discharge has a number in it.
  static const Utility UTILITY_EFFLUENT =
      Utility._(7, _omitEnumNames ? '' : 'UTILITY_EFFLUENT');

  static const $core.List<Utility> values = <Utility>[
    UTILITY_UNSPECIFIED,
    UTILITY_ELECTRICITY,
    UTILITY_WATER,
    UTILITY_DIESEL,
    UTILITY_OXYGEN,
    UTILITY_LPG,
    UTILITY_STEAM,
    UTILITY_EFFLUENT,
  ];

  static final $core.List<Utility?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static Utility? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Utility._(super.value, super.name);
}

/// Where a planned shutdown stands (SRS-FAC-004).
class OutageState extends $pb.ProtobufEnum {
  static const OutageState OUTAGE_STATE_UNSPECIFIED =
      OutageState._(0, _omitEnumNames ? '' : 'OUTAGE_STATE_UNSPECIFIED');
  static const OutageState OUTAGE_STATE_PLANNED =
      OutageState._(1, _omitEnumNames ? '' : 'OUTAGE_STATE_PLANNED');
  static const OutageState OUTAGE_STATE_APPROVED =
      OutageState._(2, _omitEnumNames ? '' : 'OUTAGE_STATE_APPROVED');
  static const OutageState OUTAGE_STATE_IN_EFFECT =
      OutageState._(3, _omitEnumNames ? '' : 'OUTAGE_STATE_IN_EFFECT');
  static const OutageState OUTAGE_STATE_RESTORED =
      OutageState._(4, _omitEnumNames ? '' : 'OUTAGE_STATE_RESTORED');
  static const OutageState OUTAGE_STATE_CANCELLED =
      OutageState._(5, _omitEnumNames ? '' : 'OUTAGE_STATE_CANCELLED');

  static const $core.List<OutageState> values = <OutageState>[
    OUTAGE_STATE_UNSPECIFIED,
    OUTAGE_STATE_PLANNED,
    OUTAGE_STATE_APPROVED,
    OUTAGE_STATE_IN_EFFECT,
    OUTAGE_STATE_RESTORED,
    OUTAGE_STATE_CANCELLED,
  ];

  static final $core.List<OutageState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static OutageState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OutageState._(super.value, super.name);
}

/// How loud an alarm or a finding is (SRS-FAC-005, SRS-FAC-008).
class Severity extends $pb.ProtobufEnum {
  static const Severity SEVERITY_UNSPECIFIED =
      Severity._(0, _omitEnumNames ? '' : 'SEVERITY_UNSPECIFIED');
  static const Severity SEVERITY_CRITICAL =
      Severity._(1, _omitEnumNames ? '' : 'SEVERITY_CRITICAL');
  static const Severity SEVERITY_MAJOR =
      Severity._(2, _omitEnumNames ? '' : 'SEVERITY_MAJOR');
  static const Severity SEVERITY_MINOR =
      Severity._(3, _omitEnumNames ? '' : 'SEVERITY_MINOR');

  /// Worth recording and not worth telling anybody about.
  static const Severity SEVERITY_INFO =
      Severity._(4, _omitEnumNames ? '' : 'SEVERITY_INFO');

  static const $core.List<Severity> values = <Severity>[
    SEVERITY_UNSPECIFIED,
    SEVERITY_CRITICAL,
    SEVERITY_MAJOR,
    SEVERITY_MINOR,
    SEVERITY_INFO,
  ];

  static final $core.List<Severity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Severity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Severity._(super.value, super.name);
}

/// What the plant is currently saying (SRS-FAC-005).
///
/// Two states, and acknowledgement is deliberately not one of them: an alarm
/// still sounding that somebody has seen is a real situation, and a single
/// state field forces it to be misfiled.
class AlarmState extends $pb.ProtobufEnum {
  static const AlarmState ALARM_STATE_UNSPECIFIED =
      AlarmState._(0, _omitEnumNames ? '' : 'ALARM_STATE_UNSPECIFIED');
  static const AlarmState ALARM_STATE_ACTIVE =
      AlarmState._(1, _omitEnumNames ? '' : 'ALARM_STATE_ACTIVE');
  static const AlarmState ALARM_STATE_CLEARED =
      AlarmState._(2, _omitEnumNames ? '' : 'ALARM_STATE_CLEARED');

  static const $core.List<AlarmState> values = <AlarmState>[
    ALARM_STATE_UNSPECIFIED,
    ALARM_STATE_ACTIVE,
    ALARM_STATE_CLEARED,
  ];

  static final $core.List<AlarmState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AlarmState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AlarmState._(super.value, super.name);
}

/// Where a fire or life-safety finding stands (SRS-FAC-008).
class DeficiencyState extends $pb.ProtobufEnum {
  static const DeficiencyState DEFICIENCY_STATE_UNSPECIFIED = DeficiencyState._(
      0, _omitEnumNames ? '' : 'DEFICIENCY_STATE_UNSPECIFIED');
  static const DeficiencyState DEFICIENCY_STATE_OPEN =
      DeficiencyState._(1, _omitEnumNames ? '' : 'DEFICIENCY_STATE_OPEN');

  /// An interim measure is in place. Explicitly not closure: a mitigation
  /// recorded as a fix is a fire watch nobody stands down.
  static const DeficiencyState DEFICIENCY_STATE_MITIGATED =
      DeficiencyState._(2, _omitEnumNames ? '' : 'DEFICIENCY_STATE_MITIGATED');
  static const DeficiencyState DEFICIENCY_STATE_CLOSED =
      DeficiencyState._(3, _omitEnumNames ? '' : 'DEFICIENCY_STATE_CLOSED');

  static const $core.List<DeficiencyState> values = <DeficiencyState>[
    DEFICIENCY_STATE_UNSPECIFIED,
    DEFICIENCY_STATE_OPEN,
    DEFICIENCY_STATE_MITIGATED,
    DEFICIENCY_STATE_CLOSED,
  ];

  static final $core.List<DeficiencyState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DeficiencyState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeficiencyState._(super.value, super.name);
}

/// Where a contractor visit stands (SRS-FAC-011).
class VisitState extends $pb.ProtobufEnum {
  static const VisitState VISIT_STATE_UNSPECIFIED =
      VisitState._(0, _omitEnumNames ? '' : 'VISIT_STATE_UNSPECIFIED');
  static const VisitState VISIT_STATE_ON_SITE =
      VisitState._(1, _omitEnumNames ? '' : 'VISIT_STATE_ON_SITE');
  static const VisitState VISIT_STATE_DEPARTED =
      VisitState._(2, _omitEnumNames ? '' : 'VISIT_STATE_DEPARTED');

  static const $core.List<VisitState> values = <VisitState>[
    VISIT_STATE_UNSPECIFIED,
    VISIT_STATE_ON_SITE,
    VISIT_STATE_DEPARTED,
  ];

  static final $core.List<VisitState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static VisitState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VisitState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
