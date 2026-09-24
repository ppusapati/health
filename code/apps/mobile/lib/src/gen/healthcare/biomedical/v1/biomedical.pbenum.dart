// This is a generated file - do not edit.
//
// Generated from healthcare/biomedical/v1/biomedical.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How much the hospital depends on one machine (SRS-BIO-001).
class Criticality extends $pb.ProtobufEnum {
  static const Criticality CRITICALITY_UNSPECIFIED =
      Criticality._(0, _omitEnumNames ? '' : 'CRITICALITY_UNSPECIFIED');

  /// Replaceable within a day without anybody noticing.
  static const Criticality CRITICALITY_ROUTINE =
      Criticality._(1, _omitEnumNames ? '' : 'CRITICALITY_ROUTINE');

  /// A department's work slows without it.
  static const Criticality CRITICALITY_IMPORTANT =
      Criticality._(2, _omitEnumNames ? '' : 'CRITICALITY_IMPORTANT');

  /// A service stops without it.
  static const Criticality CRITICALITY_CRITICAL =
      Criticality._(3, _omitEnumNames ? '' : 'CRITICALITY_CRITICAL');

  /// A patient is on it. The level that escalates the moment it goes down.
  static const Criticality CRITICALITY_LIFE_SUPPORT =
      Criticality._(4, _omitEnumNames ? '' : 'CRITICALITY_LIFE_SUPPORT');

  static const $core.List<Criticality> values = <Criticality>[
    CRITICALITY_UNSPECIFIED,
    CRITICALITY_ROUTINE,
    CRITICALITY_IMPORTANT,
    CRITICALITY_CRITICAL,
    CRITICALITY_LIFE_SUPPORT,
  ];

  static final $core.List<Criticality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Criticality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Criticality._(super.value, super.name);
}

/// Where a piece of equipment stands (SRS-BIO-001, SRS-BIO-011).
class AssetStatus extends $pb.ProtobufEnum {
  static const AssetStatus ASSET_STATUS_UNSPECIFIED =
      AssetStatus._(0, _omitEnumNames ? '' : 'ASSET_STATUS_UNSPECIFIED');
  static const AssetStatus ASSET_STATUS_IN_SERVICE =
      AssetStatus._(1, _omitEnumNames ? '' : 'ASSET_STATUS_IN_SERVICE');

  /// Being worked on. Counted, located, and not usable.
  static const AssetStatus ASSET_STATUS_UNDER_MAINTENANCE =
      AssetStatus._(2, _omitEnumNames ? '' : 'ASSET_STATUS_UNDER_MAINTENANCE');

  /// Broken and waiting. Distinct from under maintenance because the wait is
  /// the vendor's and the escalation is different.
  static const AssetStatus ASSET_STATUS_AWAITING_PARTS =
      AssetStatus._(3, _omitEnumNames ? '' : 'ASSET_STATUS_AWAITING_PARTS');

  /// Withdrawn but still owned — condemned, or held pending a decision.
  static const AssetStatus ASSET_STATUS_OUT_OF_SERVICE =
      AssetStatus._(4, _omitEnumNames ? '' : 'ASSET_STATUS_OUT_OF_SERVICE');

  /// Approved for disposal and awaiting it. It can still take a final safety
  /// check, which is often the last thing that happens to one.
  static const AssetStatus ASSET_STATUS_DECOMMISSIONED =
      AssetStatus._(5, _omitEnumNames ? '' : 'ASSET_STATUS_DECOMMISSIONED');

  /// Gone. Set by DisposeAsset and never by a status change, because disposal
  /// needs an approval and sanitisation evidence.
  static const AssetStatus ASSET_STATUS_DISPOSED =
      AssetStatus._(6, _omitEnumNames ? '' : 'ASSET_STATUS_DISPOSED');

  static const $core.List<AssetStatus> values = <AssetStatus>[
    ASSET_STATUS_UNSPECIFIED,
    ASSET_STATUS_IN_SERVICE,
    ASSET_STATUS_UNDER_MAINTENANCE,
    ASSET_STATUS_AWAITING_PARTS,
    ASSET_STATUS_OUT_OF_SERVICE,
    ASSET_STATUS_DECOMMISSIONED,
    ASSET_STATUS_DISPOSED,
  ];

  static final $core.List<AssetStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static AssetStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssetStatus._(super.value, super.name);
}

/// What kind of agreement covers a machine (SRS-BIO-002).
class ContractKind extends $pb.ProtobufEnum {
  static const ContractKind CONTRACT_KIND_UNSPECIFIED =
      ContractKind._(0, _omitEnumNames ? '' : 'CONTRACT_KIND_UNSPECIFIED');
  static const ContractKind CONTRACT_KIND_WARRANTY =
      ContractKind._(1, _omitEnumNames ? '' : 'CONTRACT_KIND_WARRANTY');

  /// Annual maintenance: labour, parts charged separately.
  static const ContractKind CONTRACT_KIND_AMC =
      ContractKind._(2, _omitEnumNames ? '' : 'CONTRACT_KIND_AMC');

  /// Comprehensive: labour and parts. The most protective of the three.
  static const ContractKind CONTRACT_KIND_CMC =
      ContractKind._(3, _omitEnumNames ? '' : 'CONTRACT_KIND_CMC');

  static const $core.List<ContractKind> values = <ContractKind>[
    CONTRACT_KIND_UNSPECIFIED,
    CONTRACT_KIND_WARRANTY,
    CONTRACT_KIND_AMC,
    CONTRACT_KIND_CMC,
  ];

  static final $core.List<ContractKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ContractKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ContractKind._(super.value, super.name);
}

/// What a maintenance plan counts (SRS-BIO-003).
class PlanBasis extends $pb.ProtobufEnum {
  static const PlanBasis PLAN_BASIS_UNSPECIFIED =
      PlanBasis._(0, _omitEnumNames ? '' : 'PLAN_BASIS_UNSPECIFIED');

  /// Calendar days since the last service.
  static const PlanBasis PLAN_BASIS_INTERVAL =
      PlanBasis._(1, _omitEnumNames ? '' : 'PLAN_BASIS_INTERVAL');

  /// Hours the machine has run, from its meter.
  static const PlanBasis PLAN_BASIS_RUNTIME =
      PlanBasis._(2, _omitEnumNames ? '' : 'PLAN_BASIS_RUNTIME');

  /// A calendar interval set by a risk assessment rather than by the
  /// manufacturer. Separate from INTERVAL so the reason is on the record.
  static const PlanBasis PLAN_BASIS_RISK =
      PlanBasis._(3, _omitEnumNames ? '' : 'PLAN_BASIS_RISK');

  static const $core.List<PlanBasis> values = <PlanBasis>[
    PLAN_BASIS_UNSPECIFIED,
    PLAN_BASIS_INTERVAL,
    PLAN_BASIS_RUNTIME,
    PLAN_BASIS_RISK,
  ];

  static final $core.List<PlanBasis?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PlanBasis? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlanBasis._(super.value, super.name);
}

/// Where one planned service stands (SRS-BIO-003).
class DueState extends $pb.ProtobufEnum {
  static const DueState DUE_STATE_UNSPECIFIED =
      DueState._(0, _omitEnumNames ? '' : 'DUE_STATE_UNSPECIFIED');
  static const DueState DUE_STATE_NOT_DUE =
      DueState._(1, _omitEnumNames ? '' : 'DUE_STATE_NOT_DUE');
  static const DueState DUE_STATE_DUE_SOON =
      DueState._(2, _omitEnumNames ? '' : 'DUE_STATE_DUE_SOON');
  static const DueState DUE_STATE_DUE =
      DueState._(3, _omitEnumNames ? '' : 'DUE_STATE_DUE');
  static const DueState DUE_STATE_OVERDUE =
      DueState._(4, _omitEnumNames ? '' : 'DUE_STATE_OVERDUE');

  static const $core.List<DueState> values = <DueState>[
    DUE_STATE_UNSPECIFIED,
    DUE_STATE_NOT_DUE,
    DUE_STATE_DUE_SOON,
    DUE_STATE_DUE,
    DUE_STATE_OVERDUE,
  ];

  static final $core.List<DueState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static DueState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DueState._(super.value, super.name);
}

/// Why the engineer is there (SRS-BIO-005, SRS-BIO-007).
class TicketKind extends $pb.ProtobufEnum {
  static const TicketKind TICKET_KIND_UNSPECIFIED =
      TicketKind._(0, _omitEnumNames ? '' : 'TICKET_KIND_UNSPECIFIED');

  /// A breakdown. The only kind that counts as a failure.
  static const TicketKind TICKET_KIND_CORRECTIVE =
      TicketKind._(1, _omitEnumNames ? '' : 'TICKET_KIND_CORRECTIVE');

  /// Scheduled work against a plan, which it must name.
  static const TicketKind TICKET_KIND_PREVENTIVE =
      TicketKind._(2, _omitEnumNames ? '' : 'TICKET_KIND_PREVENTIVE');
  static const TicketKind TICKET_KIND_CALIBRATION =
      TicketKind._(3, _omitEnumNames ? '' : 'TICKET_KIND_CALIBRATION');
  static const TicketKind TICKET_KIND_INSPECTION =
      TicketKind._(4, _omitEnumNames ? '' : 'TICKET_KIND_INSPECTION');

  static const $core.List<TicketKind> values = <TicketKind>[
    TICKET_KIND_UNSPECIFIED,
    TICKET_KIND_CORRECTIVE,
    TICKET_KIND_PREVENTIVE,
    TICKET_KIND_CALIBRATION,
    TICKET_KIND_INSPECTION,
  ];

  static final $core.List<TicketKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TicketKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TicketKind._(super.value, super.name);
}

/// How fast the hospital needs it back (SRS-BIO-005).
class Priority extends $pb.ProtobufEnum {
  static const Priority PRIORITY_UNSPECIFIED =
      Priority._(0, _omitEnumNames ? '' : 'PRIORITY_UNSPECIFIED');
  static const Priority PRIORITY_LOW =
      Priority._(1, _omitEnumNames ? '' : 'PRIORITY_LOW');
  static const Priority PRIORITY_NORMAL =
      Priority._(2, _omitEnumNames ? '' : 'PRIORITY_NORMAL');
  static const Priority PRIORITY_HIGH =
      Priority._(3, _omitEnumNames ? '' : 'PRIORITY_HIGH');

  /// Equipment a patient is on now.
  static const Priority PRIORITY_EMERGENCY =
      Priority._(4, _omitEnumNames ? '' : 'PRIORITY_EMERGENCY');

  static const $core.List<Priority> values = <Priority>[
    PRIORITY_UNSPECIFIED,
    PRIORITY_LOW,
    PRIORITY_NORMAL,
    PRIORITY_HIGH,
    PRIORITY_EMERGENCY,
  ];

  static final $core.List<Priority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Priority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Priority._(super.value, super.name);
}

/// What the fault is doing to the service (SRS-BIO-005).
class Impact extends $pb.ProtobufEnum {
  static const Impact IMPACT_UNSPECIFIED =
      Impact._(0, _omitEnumNames ? '' : 'IMPACT_UNSPECIFIED');
  static const Impact IMPACT_NONE =
      Impact._(1, _omitEnumNames ? '' : 'IMPACT_NONE');
  static const Impact IMPACT_DEGRADED =
      Impact._(2, _omitEnumNames ? '' : 'IMPACT_DEGRADED');
  static const Impact IMPACT_SERVICE_STOPPED =
      Impact._(3, _omitEnumNames ? '' : 'IMPACT_SERVICE_STOPPED');
  static const Impact IMPACT_PATIENT_AFFECTED =
      Impact._(4, _omitEnumNames ? '' : 'IMPACT_PATIENT_AFFECTED');

  static const $core.List<Impact> values = <Impact>[
    IMPACT_UNSPECIFIED,
    IMPACT_NONE,
    IMPACT_DEGRADED,
    IMPACT_SERVICE_STOPPED,
    IMPACT_PATIENT_AFFECTED,
  ];

  static final $core.List<Impact?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Impact? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Impact._(super.value, super.name);
}

/// Where a work order stands (SRS-BIO-005, SRS-BIO-006).
class TicketState extends $pb.ProtobufEnum {
  static const TicketState TICKET_STATE_UNSPECIFIED =
      TicketState._(0, _omitEnumNames ? '' : 'TICKET_STATE_UNSPECIFIED');
  static const TicketState TICKET_STATE_OPEN =
      TicketState._(1, _omitEnumNames ? '' : 'TICKET_STATE_OPEN');
  static const TicketState TICKET_STATE_ASSIGNED =
      TicketState._(2, _omitEnumNames ? '' : 'TICKET_STATE_ASSIGNED');
  static const TicketState TICKET_STATE_IN_PROGRESS =
      TicketState._(3, _omitEnumNames ? '' : 'TICKET_STATE_IN_PROGRESS');

  /// Waiting on a part. The resolution clock is stopped: an SLA measures what
  /// the service provider controls, and a manufacturer's lead time is a supply
  /// problem reported as an engineering one.
  static const TicketState TICKET_STATE_AWAITING_PARTS =
      TicketState._(4, _omitEnumNames ? '' : 'TICKET_STATE_AWAITING_PARTS');
  static const TicketState TICKET_STATE_RESOLVED =
      TicketState._(5, _omitEnumNames ? '' : 'TICKET_STATE_RESOLVED');

  /// Closed is the validation, and never by the engineer who did the work.
  static const TicketState TICKET_STATE_CLOSED =
      TicketState._(6, _omitEnumNames ? '' : 'TICKET_STATE_CLOSED');
  static const TicketState TICKET_STATE_CANCELLED =
      TicketState._(7, _omitEnumNames ? '' : 'TICKET_STATE_CANCELLED');

  static const $core.List<TicketState> values = <TicketState>[
    TICKET_STATE_UNSPECIFIED,
    TICKET_STATE_OPEN,
    TICKET_STATE_ASSIGNED,
    TICKET_STATE_IN_PROGRESS,
    TICKET_STATE_AWAITING_PARTS,
    TICKET_STATE_RESOLVED,
    TICKET_STATE_CLOSED,
    TICKET_STATE_CANCELLED,
  ];

  static final $core.List<TicketState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static TicketState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TicketState._(super.value, super.name);
}

/// What kind of safety notice this is (SRS-BIO-008).
class NoticeKind extends $pb.ProtobufEnum {
  static const NoticeKind NOTICE_KIND_UNSPECIFIED =
      NoticeKind._(0, _omitEnumNames ? '' : 'NOTICE_KIND_UNSPECIFIED');

  /// A recall always holds the equipment it matches.
  static const NoticeKind NOTICE_KIND_RECALL =
      NoticeKind._(1, _omitEnumNames ? '' : 'NOTICE_KIND_RECALL');
  static const NoticeKind NOTICE_KIND_FIELD_SAFETY =
      NoticeKind._(2, _omitEnumNames ? '' : 'NOTICE_KIND_FIELD_SAFETY');
  static const NoticeKind NOTICE_KIND_ADVISORY =
      NoticeKind._(3, _omitEnumNames ? '' : 'NOTICE_KIND_ADVISORY');

  static const $core.List<NoticeKind> values = <NoticeKind>[
    NOTICE_KIND_UNSPECIFIED,
    NOTICE_KIND_RECALL,
    NOTICE_KIND_FIELD_SAFETY,
    NOTICE_KIND_ADVISORY,
  ];

  static final $core.List<NoticeKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static NoticeKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NoticeKind._(super.value, super.name);
}

/// What has been done to one asset under a notice (SRS-BIO-008).
class TaskState extends $pb.ProtobufEnum {
  static const TaskState TASK_STATE_UNSPECIFIED =
      TaskState._(0, _omitEnumNames ? '' : 'TASK_STATE_UNSPECIFIED');
  static const TaskState TASK_STATE_OUTSTANDING =
      TaskState._(1, _omitEnumNames ? '' : 'TASK_STATE_OUTSTANDING');
  static const TaskState TASK_STATE_INSPECTED =
      TaskState._(2, _omitEnumNames ? '' : 'TASK_STATE_INSPECTED');
  static const TaskState TASK_STATE_CORRECTED =
      TaskState._(3, _omitEnumNames ? '' : 'TASK_STATE_CORRECTED');

  /// The one verdict that ends the enquiry, so it is the one that needs a
  /// reason.
  static const TaskState TASK_STATE_NOT_AFFECTED =
      TaskState._(4, _omitEnumNames ? '' : 'TASK_STATE_NOT_AFFECTED');
  static const TaskState TASK_STATE_QUARANTINED =
      TaskState._(5, _omitEnumNames ? '' : 'TASK_STATE_QUARANTINED');

  static const $core.List<TaskState> values = <TaskState>[
    TASK_STATE_UNSPECIFIED,
    TASK_STATE_OUTSTANDING,
    TASK_STATE_INSPECTED,
    TASK_STATE_CORRECTED,
    TASK_STATE_NOT_AFFECTED,
    TASK_STATE_QUARANTINED,
  ];

  static final $core.List<TaskState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static TaskState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TaskState._(super.value, super.name);
}

/// What is coming due (SRS-BIO-002, SRS-BIO-004).
class ExpiryKind extends $pb.ProtobufEnum {
  static const ExpiryKind EXPIRY_KIND_UNSPECIFIED =
      ExpiryKind._(0, _omitEnumNames ? '' : 'EXPIRY_KIND_UNSPECIFIED');
  static const ExpiryKind EXPIRY_KIND_CONTRACT =
      ExpiryKind._(1, _omitEnumNames ? '' : 'EXPIRY_KIND_CONTRACT');
  static const ExpiryKind EXPIRY_KIND_CALIBRATION =
      ExpiryKind._(2, _omitEnumNames ? '' : 'EXPIRY_KIND_CALIBRATION');

  static const $core.List<ExpiryKind> values = <ExpiryKind>[
    EXPIRY_KIND_UNSPECIFIED,
    EXPIRY_KIND_CONTRACT,
    EXPIRY_KIND_CALIBRATION,
  ];

  static final $core.List<ExpiryKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ExpiryKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExpiryKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
