// This is a generated file - do not edit.
//
// Generated from healthcare/nursing/v1/nursing.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Where a charted value came from.
///
/// A monitor artefact and a nurse's count are both "a pulse of 140" and are not
/// equally trustworthy.
class EntrySource extends $pb.ProtobufEnum {
  static const EntrySource ENTRY_SOURCE_UNSPECIFIED =
      EntrySource._(0, _omitEnumNames ? '' : 'ENTRY_SOURCE_UNSPECIFIED');
  static const EntrySource ENTRY_SOURCE_MANUAL =
      EntrySource._(1, _omitEnumNames ? '' : 'ENTRY_SOURCE_MANUAL');
  static const EntrySource ENTRY_SOURCE_DEVICE =
      EntrySource._(2, _omitEnumNames ? '' : 'ENTRY_SOURCE_DEVICE');

  /// Transcribed from a downtime paper chart (SRS-NUR-018).
  static const EntrySource ENTRY_SOURCE_PAPER =
      EntrySource._(3, _omitEnumNames ? '' : 'ENTRY_SOURCE_PAPER');

  /// Reported by the patient — a pain score. Not a measurement.
  static const EntrySource ENTRY_SOURCE_PATIENT =
      EntrySource._(4, _omitEnumNames ? '' : 'ENTRY_SOURCE_PATIENT');

  static const $core.List<EntrySource> values = <EntrySource>[
    ENTRY_SOURCE_UNSPECIFIED,
    ENTRY_SOURCE_MANUAL,
    ENTRY_SOURCE_DEVICE,
    ENTRY_SOURCE_PAPER,
    ENTRY_SOURCE_PATIENT,
  ];

  static final $core.List<EntrySource?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EntrySource? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntrySource._(super.value, super.name);
}

/// Whether fluid went in or out.
class FluidDirection extends $pb.ProtobufEnum {
  static const FluidDirection FLUID_DIRECTION_UNSPECIFIED =
      FluidDirection._(0, _omitEnumNames ? '' : 'FLUID_DIRECTION_UNSPECIFIED');
  static const FluidDirection FLUID_DIRECTION_INTAKE =
      FluidDirection._(1, _omitEnumNames ? '' : 'FLUID_DIRECTION_INTAKE');
  static const FluidDirection FLUID_DIRECTION_OUTPUT =
      FluidDirection._(2, _omitEnumNames ? '' : 'FLUID_DIRECTION_OUTPUT');

  static const $core.List<FluidDirection> values = <FluidDirection>[
    FLUID_DIRECTION_UNSPECIFIED,
    FLUID_DIRECTION_INTAKE,
    FLUID_DIRECTION_OUTPUT,
  ];

  static final $core.List<FluidDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FluidDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FluidDirection._(super.value, super.name);
}

/// What kind of nursing assessment.
class AssessmentKind extends $pb.ProtobufEnum {
  static const AssessmentKind ASSESSMENT_KIND_UNSPECIFIED =
      AssessmentKind._(0, _omitEnumNames ? '' : 'ASSESSMENT_KIND_UNSPECIFIED');
  static const AssessmentKind ASSESSMENT_KIND_ADMISSION =
      AssessmentKind._(1, _omitEnumNames ? '' : 'ASSESSMENT_KIND_ADMISSION');
  static const AssessmentKind ASSESSMENT_KIND_SHIFT =
      AssessmentKind._(2, _omitEnumNames ? '' : 'ASSESSMENT_KIND_SHIFT');
  static const AssessmentKind ASSESSMENT_KIND_FOCUSED =
      AssessmentKind._(3, _omitEnumNames ? '' : 'ASSESSMENT_KIND_FOCUSED');
  static const AssessmentKind ASSESSMENT_KIND_DISCHARGE =
      AssessmentKind._(4, _omitEnumNames ? '' : 'ASSESSMENT_KIND_DISCHARGE');

  static const $core.List<AssessmentKind> values = <AssessmentKind>[
    ASSESSMENT_KIND_UNSPECIFIED,
    ASSESSMENT_KIND_ADMISSION,
    ASSESSMENT_KIND_SHIFT,
    ASSESSMENT_KIND_FOCUSED,
    ASSESSMENT_KIND_DISCHARGE,
  ];

  static final $core.List<AssessmentKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static AssessmentKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssessmentKind._(super.value, super.name);
}

/// What a risk scale measures.
class RiskDomain extends $pb.ProtobufEnum {
  static const RiskDomain RISK_DOMAIN_UNSPECIFIED =
      RiskDomain._(0, _omitEnumNames ? '' : 'RISK_DOMAIN_UNSPECIFIED');
  static const RiskDomain RISK_DOMAIN_FALLS =
      RiskDomain._(1, _omitEnumNames ? '' : 'RISK_DOMAIN_FALLS');
  static const RiskDomain RISK_DOMAIN_PRESSURE_INJURY =
      RiskDomain._(2, _omitEnumNames ? '' : 'RISK_DOMAIN_PRESSURE_INJURY');
  static const RiskDomain RISK_DOMAIN_PAIN =
      RiskDomain._(3, _omitEnumNames ? '' : 'RISK_DOMAIN_PAIN');
  static const RiskDomain RISK_DOMAIN_NUTRITION =
      RiskDomain._(4, _omitEnumNames ? '' : 'RISK_DOMAIN_NUTRITION');
  static const RiskDomain RISK_DOMAIN_DETERIORATION =
      RiskDomain._(5, _omitEnumNames ? '' : 'RISK_DOMAIN_DETERIORATION');

  static const $core.List<RiskDomain> values = <RiskDomain>[
    RISK_DOMAIN_UNSPECIFIED,
    RISK_DOMAIN_FALLS,
    RISK_DOMAIN_PRESSURE_INJURY,
    RISK_DOMAIN_PAIN,
    RISK_DOMAIN_NUTRITION,
    RISK_DOMAIN_DETERIORATION,
  ];

  static final $core.List<RiskDomain?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static RiskDomain? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RiskDomain._(super.value, super.name);
}

/// What was inserted.
class DeviceKind extends $pb.ProtobufEnum {
  static const DeviceKind DEVICE_KIND_UNSPECIFIED =
      DeviceKind._(0, _omitEnumNames ? '' : 'DEVICE_KIND_UNSPECIFIED');
  static const DeviceKind DEVICE_KIND_CENTRAL_LINE =
      DeviceKind._(1, _omitEnumNames ? '' : 'DEVICE_KIND_CENTRAL_LINE');
  static const DeviceKind DEVICE_KIND_PERIPHERAL_LINE =
      DeviceKind._(2, _omitEnumNames ? '' : 'DEVICE_KIND_PERIPHERAL_LINE');
  static const DeviceKind DEVICE_KIND_URINARY_CATHETER =
      DeviceKind._(3, _omitEnumNames ? '' : 'DEVICE_KIND_URINARY_CATHETER');
  static const DeviceKind DEVICE_KIND_DRAIN =
      DeviceKind._(4, _omitEnumNames ? '' : 'DEVICE_KIND_DRAIN');
  static const DeviceKind DEVICE_KIND_FEEDING_TUBE =
      DeviceKind._(5, _omitEnumNames ? '' : 'DEVICE_KIND_FEEDING_TUBE');
  static const DeviceKind DEVICE_KIND_ENDOTRACHEAL_TUBE =
      DeviceKind._(6, _omitEnumNames ? '' : 'DEVICE_KIND_ENDOTRACHEAL_TUBE');
  static const DeviceKind DEVICE_KIND_CHEST_TUBE =
      DeviceKind._(7, _omitEnumNames ? '' : 'DEVICE_KIND_CHEST_TUBE');

  static const $core.List<DeviceKind> values = <DeviceKind>[
    DEVICE_KIND_UNSPECIFIED,
    DEVICE_KIND_CENTRAL_LINE,
    DEVICE_KIND_PERIPHERAL_LINE,
    DEVICE_KIND_URINARY_CATHETER,
    DEVICE_KIND_DRAIN,
    DEVICE_KIND_FEEDING_TUBE,
    DEVICE_KIND_ENDOTRACHEAL_TUBE,
    DEVICE_KIND_CHEST_TUBE,
  ];

  static final $core.List<DeviceKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DeviceKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeviceKind._(super.value, super.name);
}

class Laterality extends $pb.ProtobufEnum {
  static const Laterality LATERALITY_UNSPECIFIED =
      Laterality._(0, _omitEnumNames ? '' : 'LATERALITY_UNSPECIFIED');
  static const Laterality LATERALITY_LEFT =
      Laterality._(1, _omitEnumNames ? '' : 'LATERALITY_LEFT');
  static const Laterality LATERALITY_RIGHT =
      Laterality._(2, _omitEnumNames ? '' : 'LATERALITY_RIGHT');
  static const Laterality LATERALITY_BILATERAL =
      Laterality._(3, _omitEnumNames ? '' : 'LATERALITY_BILATERAL');
  static const Laterality LATERALITY_NOT_APPLICABLE =
      Laterality._(4, _omitEnumNames ? '' : 'LATERALITY_NOT_APPLICABLE');

  static const $core.List<Laterality> values = <Laterality>[
    LATERALITY_UNSPECIFIED,
    LATERALITY_LEFT,
    LATERALITY_RIGHT,
    LATERALITY_BILATERAL,
    LATERALITY_NOT_APPLICABLE,
  ];

  static final $core.List<Laterality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Laterality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Laterality._(super.value, super.name);
}

/// Where a medication order stands.
class OrderStatus extends $pb.ProtobufEnum {
  static const OrderStatus ORDER_STATUS_UNSPECIFIED =
      OrderStatus._(0, _omitEnumNames ? '' : 'ORDER_STATUS_UNSPECIFIED');
  static const OrderStatus ORDER_STATUS_DRAFT =
      OrderStatus._(1, _omitEnumNames ? '' : 'ORDER_STATUS_DRAFT');
  static const OrderStatus ORDER_STATUS_ACTIVE =
      OrderStatus._(2, _omitEnumNames ? '' : 'ORDER_STATUS_ACTIVE');
  static const OrderStatus ORDER_STATUS_HELD =
      OrderStatus._(3, _omitEnumNames ? '' : 'ORDER_STATUS_HELD');
  static const OrderStatus ORDER_STATUS_COMPLETED =
      OrderStatus._(4, _omitEnumNames ? '' : 'ORDER_STATUS_COMPLETED');
  static const OrderStatus ORDER_STATUS_CANCELLED =
      OrderStatus._(5, _omitEnumNames ? '' : 'ORDER_STATUS_CANCELLED');

  static const $core.List<OrderStatus> values = <OrderStatus>[
    ORDER_STATUS_UNSPECIFIED,
    ORDER_STATUS_DRAFT,
    ORDER_STATUS_ACTIVE,
    ORDER_STATUS_HELD,
    ORDER_STATUS_COMPLETED,
    ORDER_STATUS_CANCELLED,
  ];

  static final $core.List<OrderStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static OrderStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderStatus._(super.value, super.name);
}

/// What happened to a scheduled dose (SRS-NUR-009).
class AdministrationOutcome extends $pb.ProtobufEnum {
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_UNSPECIFIED =
      AdministrationOutcome._(
          0, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_UNSPECIFIED');
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_ADMINISTERED =
      AdministrationOutcome._(
          1, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_ADMINISTERED');

  /// Not given and will not be: the order was stopped, the drug unavailable.
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_NOT_ADMINISTERED =
      AdministrationOutcome._(
          2, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_NOT_ADMINISTERED');

  /// A clinical decision to withhold this dose. Distinct from not-administered
  /// because holding is an act of judgement somebody is answerable for.
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_HELD =
      AdministrationOutcome._(
          3, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_HELD');

  /// The patient's decision, which is not the nurse's to record as a hold.
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_REFUSED =
      AdministrationOutcome._(
          4, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_REFUSED');

  /// Given, outside the window. Its own outcome because the nurse asserting it
  /// was late is different evidence from a report deriving it.
  static const AdministrationOutcome ADMINISTRATION_OUTCOME_DELAYED =
      AdministrationOutcome._(
          5, _omitEnumNames ? '' : 'ADMINISTRATION_OUTCOME_DELAYED');

  static const $core.List<AdministrationOutcome> values =
      <AdministrationOutcome>[
    ADMINISTRATION_OUTCOME_UNSPECIFIED,
    ADMINISTRATION_OUTCOME_ADMINISTERED,
    ADMINISTRATION_OUTCOME_NOT_ADMINISTERED,
    ADMINISTRATION_OUTCOME_HELD,
    ADMINISTRATION_OUTCOME_REFUSED,
    ADMINISTRATION_OUTCOME_DELAYED,
  ];

  static final $core.List<AdministrationOutcome?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AdministrationOutcome? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AdministrationOutcome._(super.value, super.name);
}

/// How urgent a piece of nursing work is.
class TaskPriority extends $pb.ProtobufEnum {
  static const TaskPriority TASK_PRIORITY_UNSPECIFIED =
      TaskPriority._(0, _omitEnumNames ? '' : 'TASK_PRIORITY_UNSPECIFIED');
  static const TaskPriority TASK_PRIORITY_ROUTINE =
      TaskPriority._(1, _omitEnumNames ? '' : 'TASK_PRIORITY_ROUTINE');
  static const TaskPriority TASK_PRIORITY_URGENT =
      TaskPriority._(2, _omitEnumNames ? '' : 'TASK_PRIORITY_URGENT');

  /// The tier that escalates. Reserved for work where being late is itself
  /// harm.
  static const TaskPriority TASK_PRIORITY_CRITICAL =
      TaskPriority._(3, _omitEnumNames ? '' : 'TASK_PRIORITY_CRITICAL');

  static const $core.List<TaskPriority> values = <TaskPriority>[
    TASK_PRIORITY_UNSPECIFIED,
    TASK_PRIORITY_ROUTINE,
    TASK_PRIORITY_URGENT,
    TASK_PRIORITY_CRITICAL,
  ];

  static final $core.List<TaskPriority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TaskPriority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskPriority._(super.value, super.name);
}

class TaskStatus extends $pb.ProtobufEnum {
  static const TaskStatus TASK_STATUS_UNSPECIFIED =
      TaskStatus._(0, _omitEnumNames ? '' : 'TASK_STATUS_UNSPECIFIED');
  static const TaskStatus TASK_STATUS_PENDING =
      TaskStatus._(1, _omitEnumNames ? '' : 'TASK_STATUS_PENDING');
  static const TaskStatus TASK_STATUS_DONE =
      TaskStatus._(2, _omitEnumNames ? '' : 'TASK_STATUS_DONE');

  /// Deliberately not carried out. Distinct from pending, because a task nobody
  /// did and a task somebody decided against are different facts.
  static const TaskStatus TASK_STATUS_NOT_DONE =
      TaskStatus._(3, _omitEnumNames ? '' : 'TASK_STATUS_NOT_DONE');
  static const TaskStatus TASK_STATUS_CANCELLED =
      TaskStatus._(4, _omitEnumNames ? '' : 'TASK_STATUS_CANCELLED');

  static const $core.List<TaskStatus> values = <TaskStatus>[
    TASK_STATUS_UNSPECIFIED,
    TASK_STATUS_PENDING,
    TASK_STATUS_DONE,
    TASK_STATUS_NOT_DONE,
    TASK_STATUS_CANCELLED,
  ];

  static final $core.List<TaskStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TaskStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskStatus._(super.value, super.name);
}

class PlanStatus extends $pb.ProtobufEnum {
  static const PlanStatus PLAN_STATUS_UNSPECIFIED =
      PlanStatus._(0, _omitEnumNames ? '' : 'PLAN_STATUS_UNSPECIFIED');
  static const PlanStatus PLAN_STATUS_ACTIVE =
      PlanStatus._(1, _omitEnumNames ? '' : 'PLAN_STATUS_ACTIVE');
  static const PlanStatus PLAN_STATUS_COMPLETED =
      PlanStatus._(2, _omitEnumNames ? '' : 'PLAN_STATUS_COMPLETED');
  static const PlanStatus PLAN_STATUS_CANCELLED =
      PlanStatus._(3, _omitEnumNames ? '' : 'PLAN_STATUS_CANCELLED');

  static const $core.List<PlanStatus> values = <PlanStatus>[
    PLAN_STATUS_UNSPECIFIED,
    PLAN_STATUS_ACTIVE,
    PLAN_STATUS_COMPLETED,
    PLAN_STATUS_CANCELLED,
  ];

  static final $core.List<PlanStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlanStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlanStatus._(super.value, super.name);
}

class RestraintKind extends $pb.ProtobufEnum {
  static const RestraintKind RESTRAINT_KIND_UNSPECIFIED =
      RestraintKind._(0, _omitEnumNames ? '' : 'RESTRAINT_KIND_UNSPECIFIED');
  static const RestraintKind RESTRAINT_KIND_PHYSICAL =
      RestraintKind._(1, _omitEnumNames ? '' : 'RESTRAINT_KIND_PHYSICAL');
  static const RestraintKind RESTRAINT_KIND_CHEMICAL =
      RestraintKind._(2, _omitEnumNames ? '' : 'RESTRAINT_KIND_CHEMICAL');
  static const RestraintKind RESTRAINT_KIND_SECLUSION =
      RestraintKind._(3, _omitEnumNames ? '' : 'RESTRAINT_KIND_SECLUSION');

  static const $core.List<RestraintKind> values = <RestraintKind>[
    RESTRAINT_KIND_UNSPECIFIED,
    RESTRAINT_KIND_PHYSICAL,
    RESTRAINT_KIND_CHEMICAL,
    RESTRAINT_KIND_SECLUSION,
  ];

  static final $core.List<RestraintKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RestraintKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RestraintKind._(super.value, super.name);
}

@$core.Deprecated('This enum is deprecated')
class TransfusionStatus extends $pb.ProtobufEnum {
  static const TransfusionStatus TRANSFUSION_STATUS_UNSPECIFIED =
      TransfusionStatus._(
          0, _omitEnumNames ? '' : 'TRANSFUSION_STATUS_UNSPECIFIED');
  static const TransfusionStatus TRANSFUSION_STATUS_IN_PROGRESS =
      TransfusionStatus._(
          1, _omitEnumNames ? '' : 'TRANSFUSION_STATUS_IN_PROGRESS');
  static const TransfusionStatus TRANSFUSION_STATUS_COMPLETED =
      TransfusionStatus._(
          2, _omitEnumNames ? '' : 'TRANSFUSION_STATUS_COMPLETED');

  /// Halted for a suspected reaction. Distinct from completed: the unit did not
  /// go in, and the remainder goes back to the laboratory.
  static const TransfusionStatus TRANSFUSION_STATUS_STOPPED =
      TransfusionStatus._(
          3, _omitEnumNames ? '' : 'TRANSFUSION_STATUS_STOPPED');

  static const $core.List<TransfusionStatus> values = <TransfusionStatus>[
    TRANSFUSION_STATUS_UNSPECIFIED,
    TRANSFUSION_STATUS_IN_PROGRESS,
    TRANSFUSION_STATUS_COMPLETED,
    TRANSFUSION_STATUS_STOPPED,
  ];

  static final $core.List<TransfusionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TransfusionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TransfusionStatus._(super.value, super.name);
}

class WoundKind extends $pb.ProtobufEnum {
  static const WoundKind WOUND_KIND_UNSPECIFIED =
      WoundKind._(0, _omitEnumNames ? '' : 'WOUND_KIND_UNSPECIFIED');
  static const WoundKind WOUND_KIND_PRESSURE_INJURY =
      WoundKind._(1, _omitEnumNames ? '' : 'WOUND_KIND_PRESSURE_INJURY');
  static const WoundKind WOUND_KIND_SURGICAL =
      WoundKind._(2, _omitEnumNames ? '' : 'WOUND_KIND_SURGICAL');
  static const WoundKind WOUND_KIND_TRAUMA =
      WoundKind._(3, _omitEnumNames ? '' : 'WOUND_KIND_TRAUMA');
  static const WoundKind WOUND_KIND_BURN =
      WoundKind._(4, _omitEnumNames ? '' : 'WOUND_KIND_BURN');
  static const WoundKind WOUND_KIND_ULCER =
      WoundKind._(5, _omitEnumNames ? '' : 'WOUND_KIND_ULCER');
  static const WoundKind WOUND_KIND_OTHER =
      WoundKind._(6, _omitEnumNames ? '' : 'WOUND_KIND_OTHER');

  static const $core.List<WoundKind> values = <WoundKind>[
    WOUND_KIND_UNSPECIFIED,
    WOUND_KIND_PRESSURE_INJURY,
    WOUND_KIND_SURGICAL,
    WOUND_KIND_TRAUMA,
    WOUND_KIND_BURN,
    WOUND_KIND_ULCER,
    WOUND_KIND_OTHER,
  ];

  static final $core.List<WoundKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static WoundKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const WoundKind._(super.value, super.name);
}

class Learner extends $pb.ProtobufEnum {
  static const Learner LEARNER_UNSPECIFIED =
      Learner._(0, _omitEnumNames ? '' : 'LEARNER_UNSPECIFIED');
  static const Learner LEARNER_PATIENT =
      Learner._(1, _omitEnumNames ? '' : 'LEARNER_PATIENT');
  static const Learner LEARNER_FAMILY =
      Learner._(2, _omitEnumNames ? '' : 'LEARNER_FAMILY');
  static const Learner LEARNER_CARER =
      Learner._(3, _omitEnumNames ? '' : 'LEARNER_CARER');

  static const $core.List<Learner> values = <Learner>[
    LEARNER_UNSPECIFIED,
    LEARNER_PATIENT,
    LEARNER_FAMILY,
    LEARNER_CARER,
  ];

  static final $core.List<Learner?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Learner? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Learner._(super.value, super.name);
}

/// How well the teaching landed. The outcome, and the reason the record exists:
/// teaching delivered is not teaching received.
class Understanding extends $pb.ProtobufEnum {
  static const Understanding UNDERSTANDING_UNSPECIFIED =
      Understanding._(0, _omitEnumNames ? '' : 'UNDERSTANDING_UNSPECIFIED');

  /// The strongest: the learner did it back.
  static const Understanding UNDERSTANDING_DEMONSTRATED =
      Understanding._(1, _omitEnumNames ? '' : 'UNDERSTANDING_DEMONSTRATED');
  static const Understanding UNDERSTANDING_VERBALISED =
      Understanding._(2, _omitEnumNames ? '' : 'UNDERSTANDING_VERBALISED');

  /// Not a failure; the finding that schedules the next session.
  static const Understanding UNDERSTANDING_NEEDS_REINFORCEMENT =
      Understanding._(
          3, _omitEnumNames ? '' : 'UNDERSTANDING_NEEDS_REINFORCEMENT');
  static const Understanding UNDERSTANDING_UNABLE_TO_ASSESS = Understanding._(
      4, _omitEnumNames ? '' : 'UNDERSTANDING_UNABLE_TO_ASSESS');

  static const $core.List<Understanding> values = <Understanding>[
    UNDERSTANDING_UNSPECIFIED,
    UNDERSTANDING_DEMONSTRATED,
    UNDERSTANDING_VERBALISED,
    UNDERSTANDING_NEEDS_REINFORCEMENT,
    UNDERSTANDING_UNABLE_TO_ASSESS,
  ];

  static final $core.List<Understanding?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Understanding? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Understanding._(super.value, super.name);
}

/// The kind of nursing responsibility. Authorization asks about the
/// relationship, not merely the presence of a row.
class CareRelationship extends $pb.ProtobufEnum {
  static const CareRelationship CARE_RELATIONSHIP_UNSPECIFIED =
      CareRelationship._(
          0, _omitEnumNames ? '' : 'CARE_RELATIONSHIP_UNSPECIFIED');
  static const CareRelationship CARE_RELATIONSHIP_PRIMARY =
      CareRelationship._(1, _omitEnumNames ? '' : 'CARE_RELATIONSHIP_PRIMARY');
  static const CareRelationship CARE_RELATIONSHIP_ASSOCIATE =
      CareRelationship._(
          2, _omitEnumNames ? '' : 'CARE_RELATIONSHIP_ASSOCIATE');
  static const CareRelationship CARE_RELATIONSHIP_COVERING =
      CareRelationship._(3, _omitEnumNames ? '' : 'CARE_RELATIONSHIP_COVERING');
  static const CareRelationship CARE_RELATIONSHIP_IN_CHARGE =
      CareRelationship._(
          4, _omitEnumNames ? '' : 'CARE_RELATIONSHIP_IN_CHARGE');

  static const $core.List<CareRelationship> values = <CareRelationship>[
    CARE_RELATIONSHIP_UNSPECIFIED,
    CARE_RELATIONSHIP_PRIMARY,
    CARE_RELATIONSHIP_ASSOCIATE,
    CARE_RELATIONSHIP_COVERING,
    CARE_RELATIONSHIP_IN_CHARGE,
  ];

  static final $core.List<CareRelationship?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CareRelationship? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CareRelationship._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
