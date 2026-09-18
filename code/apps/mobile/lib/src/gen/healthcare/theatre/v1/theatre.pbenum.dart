// This is a generated file - do not edit.
//
// Generated from healthcare/theatre/v1/theatre.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How soon the case has to happen (SRS-OT-003).
class Urgency extends $pb.ProtobufEnum {
  static const Urgency URGENCY_UNSPECIFIED =
      Urgency._(0, _omitEnumNames ? '' : 'URGENCY_UNSPECIFIED');
  static const Urgency URGENCY_ELECTIVE =
      Urgency._(1, _omitEnumNames ? '' : 'URGENCY_ELECTIVE');
  static const Urgency URGENCY_URGENT =
      Urgency._(2, _omitEnumNames ? '' : 'URGENCY_URGENT');
  static const Urgency URGENCY_EMERGENCY =
      Urgency._(3, _omitEnumNames ? '' : 'URGENCY_EMERGENCY');

  static const $core.List<Urgency> values = <Urgency>[
    URGENCY_UNSPECIFIED,
    URGENCY_ELECTIVE,
    URGENCY_URGENT,
    URGENCY_EMERGENCY,
  ];

  static final $core.List<Urgency?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Urgency? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Urgency._(super.value, super.name);
}

/// Which side (SRS-OT-002).
class Laterality extends $pb.ProtobufEnum {
  /// The refusal state: a procedure that has sides and has not said which.
  static const Laterality LATERALITY_UNSPECIFIED =
      Laterality._(0, _omitEnumNames ? '' : 'LATERALITY_UNSPECIFIED');
  static const Laterality LATERALITY_NOT_APPLICABLE =
      Laterality._(1, _omitEnumNames ? '' : 'LATERALITY_NOT_APPLICABLE');
  static const Laterality LATERALITY_LEFT =
      Laterality._(2, _omitEnumNames ? '' : 'LATERALITY_LEFT');
  static const Laterality LATERALITY_RIGHT =
      Laterality._(3, _omitEnumNames ? '' : 'LATERALITY_RIGHT');
  static const Laterality LATERALITY_BILATERAL =
      Laterality._(4, _omitEnumNames ? '' : 'LATERALITY_BILATERAL');

  static const $core.List<Laterality> values = <Laterality>[
    LATERALITY_UNSPECIFIED,
    LATERALITY_NOT_APPLICABLE,
    LATERALITY_LEFT,
    LATERALITY_RIGHT,
    LATERALITY_BILATERAL,
  ];

  static final $core.List<Laterality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Laterality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Laterality._(super.value, super.name);
}

class CaseStatus extends $pb.ProtobufEnum {
  static const CaseStatus CASE_STATUS_UNSPECIFIED =
      CaseStatus._(0, _omitEnumNames ? '' : 'CASE_STATUS_UNSPECIFIED');

  /// A request that is not yet complete enough to schedule.
  static const CaseStatus CASE_STATUS_REQUESTED =
      CaseStatus._(1, _omitEnumNames ? '' : 'CASE_STATUS_REQUESTED');
  static const CaseStatus CASE_STATUS_SCHEDULABLE =
      CaseStatus._(2, _omitEnumNames ? '' : 'CASE_STATUS_SCHEDULABLE');
  static const CaseStatus CASE_STATUS_SCHEDULED =
      CaseStatus._(3, _omitEnumNames ? '' : 'CASE_STATUS_SCHEDULED');

  /// Past the pre-operative checklist.
  static const CaseStatus CASE_STATUS_READY =
      CaseStatus._(4, _omitEnumNames ? '' : 'CASE_STATUS_READY');
  static const CaseStatus CASE_STATUS_IN_THEATRE =
      CaseStatus._(5, _omitEnumNames ? '' : 'CASE_STATUS_IN_THEATRE');
  static const CaseStatus CASE_STATUS_COMPLETED =
      CaseStatus._(6, _omitEnumNames ? '' : 'CASE_STATUS_COMPLETED');
  static const CaseStatus CASE_STATUS_POSTPONED =
      CaseStatus._(7, _omitEnumNames ? '' : 'CASE_STATUS_POSTPONED');
  static const CaseStatus CASE_STATUS_CANCELLED =
      CaseStatus._(8, _omitEnumNames ? '' : 'CASE_STATUS_CANCELLED');

  static const $core.List<CaseStatus> values = <CaseStatus>[
    CASE_STATUS_UNSPECIFIED,
    CASE_STATUS_REQUESTED,
    CASE_STATUS_SCHEDULABLE,
    CASE_STATUS_SCHEDULED,
    CASE_STATUS_READY,
    CASE_STATUS_IN_THEATRE,
    CASE_STATUS_COMPLETED,
    CASE_STATUS_POSTPONED,
    CASE_STATUS_CANCELLED,
  ];

  static final $core.List<CaseStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static CaseStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CaseStatus._(super.value, super.name);
}

/// Why a case came off the list (SRS-OT-005).
class CaseCause extends $pb.ProtobufEnum {
  static const CaseCause CASE_CAUSE_UNSPECIFIED =
      CaseCause._(0, _omitEnumNames ? '' : 'CASE_CAUSE_UNSPECIFIED');

  /// Did not attend, not fasted, unwell, declined.
  static const CaseCause CASE_CAUSE_PATIENT =
      CaseCause._(1, _omitEnumNames ? '' : 'CASE_CAUSE_PATIENT');

  /// Condition changed, needs further investigation, no longer indicated.
  static const CaseCause CASE_CAUSE_CLINICAL =
      CaseCause._(2, _omitEnumNames ? '' : 'CASE_CAUSE_CLINICAL');

  /// No bed, no equipment, no staff, the list overran.
  static const CaseCause CASE_CAUSE_RESOURCE =
      CaseCause._(3, _omitEnumNames ? '' : 'CASE_CAUSE_RESOURCE');

  /// Booked in error, consent not obtained, notes missing.
  static const CaseCause CASE_CAUSE_ADMINISTRATIVE =
      CaseCause._(4, _omitEnumNames ? '' : 'CASE_CAUSE_ADMINISTRATIVE');

  static const $core.List<CaseCause> values = <CaseCause>[
    CASE_CAUSE_UNSPECIFIED,
    CASE_CAUSE_PATIENT,
    CASE_CAUSE_CLINICAL,
    CASE_CAUSE_RESOURCE,
    CASE_CAUSE_ADMINISTRATIVE,
  ];

  static final $core.List<CaseCause?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CaseCause? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CaseCause._(super.value, super.name);
}

class BlockKind extends $pb.ProtobufEnum {
  static const BlockKind BLOCK_KIND_UNSPECIFIED =
      BlockKind._(0, _omitEnumNames ? '' : 'BLOCK_KIND_UNSPECIFIED');
  static const BlockKind BLOCK_KIND_LIST =
      BlockKind._(1, _omitEnumNames ? '' : 'BLOCK_KIND_LIST');

  /// Planned closure. Distinct from an unallocated gap, because a room that is
  /// closed is not one somebody can be persuaded to open.
  static const BlockKind BLOCK_KIND_DOWNTIME =
      BlockKind._(2, _omitEnumNames ? '' : 'BLOCK_KIND_DOWNTIME');
  static const BlockKind BLOCK_KIND_EMERGENCY =
      BlockKind._(3, _omitEnumNames ? '' : 'BLOCK_KIND_EMERGENCY');

  static const $core.List<BlockKind> values = <BlockKind>[
    BLOCK_KIND_UNSPECIFIED,
    BLOCK_KIND_LIST,
    BLOCK_KIND_DOWNTIME,
    BLOCK_KIND_EMERGENCY,
  ];

  static final $core.List<BlockKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static BlockKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BlockKind._(super.value, super.name);
}

/// What happened to one pre-operative item (SRS-OT-006).
class PreopState extends $pb.ProtobufEnum {
  static const PreopState PREOP_STATE_UNSPECIFIED =
      PreopState._(0, _omitEnumNames ? '' : 'PREOP_STATE_UNSPECIFIED');
  static const PreopState PREOP_STATE_MET =
      PreopState._(1, _omitEnumNames ? '' : 'PREOP_STATE_MET');
  static const PreopState PREOP_STATE_UNMET =
      PreopState._(2, _omitEnumNames ? '' : 'PREOP_STATE_UNMET');
  static const PreopState PREOP_STATE_WAIVED =
      PreopState._(3, _omitEnumNames ? '' : 'PREOP_STATE_WAIVED');

  /// This case does not need it — no implants for an appendicectomy. Distinct
  /// from met: "we did not need blood" and "the blood is here" are different
  /// facts.
  static const PreopState PREOP_STATE_NOT_APPLICABLE =
      PreopState._(4, _omitEnumNames ? '' : 'PREOP_STATE_NOT_APPLICABLE');

  static const $core.List<PreopState> values = <PreopState>[
    PREOP_STATE_UNSPECIFIED,
    PREOP_STATE_MET,
    PREOP_STATE_UNMET,
    PREOP_STATE_WAIVED,
    PREOP_STATE_NOT_APPLICABLE,
  ];

  static final $core.List<PreopState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static PreopState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PreopState._(super.value, super.name);
}

/// One of the three moments of the surgical safety checklist (SRS-OT-007).
class SafetyPhase extends $pb.ProtobufEnum {
  static const SafetyPhase SAFETY_PHASE_UNSPECIFIED =
      SafetyPhase._(0, _omitEnumNames ? '' : 'SAFETY_PHASE_UNSPECIFIED');

  /// Before induction, with the patient awake.
  static const SafetyPhase SAFETY_PHASE_SIGN_IN =
      SafetyPhase._(1, _omitEnumNames ? '' : 'SAFETY_PHASE_SIGN_IN');

  /// Before incision, with the whole team stopped.
  static const SafetyPhase SAFETY_PHASE_TIME_OUT =
      SafetyPhase._(2, _omitEnumNames ? '' : 'SAFETY_PHASE_TIME_OUT');

  /// Before the patient leaves the room.
  static const SafetyPhase SAFETY_PHASE_SIGN_OUT =
      SafetyPhase._(3, _omitEnumNames ? '' : 'SAFETY_PHASE_SIGN_OUT');

  static const $core.List<SafetyPhase> values = <SafetyPhase>[
    SAFETY_PHASE_UNSPECIFIED,
    SAFETY_PHASE_SIGN_IN,
    SAFETY_PHASE_TIME_OUT,
    SAFETY_PHASE_SIGN_OUT,
  ];

  static final $core.List<SafetyPhase?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SafetyPhase? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SafetyPhase._(super.value, super.name);
}

/// One point in a case's passage through theatre (SRS-OT-008).
class Milestone extends $pb.ProtobufEnum {
  static const Milestone MILESTONE_UNSPECIFIED =
      Milestone._(0, _omitEnumNames ? '' : 'MILESTONE_UNSPECIFIED');
  static const Milestone MILESTONE_PRE_OP =
      Milestone._(1, _omitEnumNames ? '' : 'MILESTONE_PRE_OP');
  static const Milestone MILESTONE_THEATRE_IN =
      Milestone._(2, _omitEnumNames ? '' : 'MILESTONE_THEATRE_IN');
  static const Milestone MILESTONE_ANAESTHESIA_START =
      Milestone._(3, _omitEnumNames ? '' : 'MILESTONE_ANAESTHESIA_START');
  static const Milestone MILESTONE_INCISION =
      Milestone._(4, _omitEnumNames ? '' : 'MILESTONE_INCISION');
  static const Milestone MILESTONE_CLOSURE =
      Milestone._(5, _omitEnumNames ? '' : 'MILESTONE_CLOSURE');
  static const Milestone MILESTONE_THEATRE_OUT =
      Milestone._(6, _omitEnumNames ? '' : 'MILESTONE_THEATRE_OUT');
  static const Milestone MILESTONE_PACU_IN =
      Milestone._(7, _omitEnumNames ? '' : 'MILESTONE_PACU_IN');
  static const Milestone MILESTONE_PACU_OUT =
      Milestone._(8, _omitEnumNames ? '' : 'MILESTONE_PACU_OUT');

  static const $core.List<Milestone> values = <Milestone>[
    MILESTONE_UNSPECIFIED,
    MILESTONE_PRE_OP,
    MILESTONE_THEATRE_IN,
    MILESTONE_ANAESTHESIA_START,
    MILESTONE_INCISION,
    MILESTONE_CLOSURE,
    MILESTONE_THEATRE_OUT,
    MILESTONE_PACU_IN,
    MILESTONE_PACU_OUT,
  ];

  static final $core.List<Milestone?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static Milestone? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Milestone._(super.value, super.name);
}

/// A coded delay cause (SRS-OT-014).
///
/// Coded because the requirement asks for analytics without free-text-only
/// classification: the fixes for a late surgeon and a missing set of
/// instruments are different departments' work.
class DelayReason extends $pb.ProtobufEnum {
  static const DelayReason DELAY_REASON_UNSPECIFIED =
      DelayReason._(0, _omitEnumNames ? '' : 'DELAY_REASON_UNSPECIFIED');
  static const DelayReason DELAY_REASON_PATIENT =
      DelayReason._(1, _omitEnumNames ? '' : 'DELAY_REASON_PATIENT');
  static const DelayReason DELAY_REASON_SURGEON =
      DelayReason._(2, _omitEnumNames ? '' : 'DELAY_REASON_SURGEON');
  static const DelayReason DELAY_REASON_ANAESTHESIA =
      DelayReason._(3, _omitEnumNames ? '' : 'DELAY_REASON_ANAESTHESIA');
  static const DelayReason DELAY_REASON_NURSING =
      DelayReason._(4, _omitEnumNames ? '' : 'DELAY_REASON_NURSING');
  static const DelayReason DELAY_REASON_EQUIPMENT =
      DelayReason._(5, _omitEnumNames ? '' : 'DELAY_REASON_EQUIPMENT');
  static const DelayReason DELAY_REASON_INSTRUMENTS =
      DelayReason._(6, _omitEnumNames ? '' : 'DELAY_REASON_INSTRUMENTS');
  static const DelayReason DELAY_REASON_CLEANING =
      DelayReason._(7, _omitEnumNames ? '' : 'DELAY_REASON_CLEANING');
  static const DelayReason DELAY_REASON_BED =
      DelayReason._(8, _omitEnumNames ? '' : 'DELAY_REASON_BED');
  static const DelayReason DELAY_REASON_PORTERS =
      DelayReason._(9, _omitEnumNames ? '' : 'DELAY_REASON_PORTERS');
  static const DelayReason DELAY_REASON_PREVIOUS_CASE =
      DelayReason._(10, _omitEnumNames ? '' : 'DELAY_REASON_PREVIOUS_CASE');
  static const DelayReason DELAY_REASON_EMERGENCY_INSERTION = DelayReason._(
      11, _omitEnumNames ? '' : 'DELAY_REASON_EMERGENCY_INSERTION');
  static const DelayReason DELAY_REASON_OTHER =
      DelayReason._(12, _omitEnumNames ? '' : 'DELAY_REASON_OTHER');

  static const $core.List<DelayReason> values = <DelayReason>[
    DELAY_REASON_UNSPECIFIED,
    DELAY_REASON_PATIENT,
    DELAY_REASON_SURGEON,
    DELAY_REASON_ANAESTHESIA,
    DELAY_REASON_NURSING,
    DELAY_REASON_EQUIPMENT,
    DELAY_REASON_INSTRUMENTS,
    DELAY_REASON_CLEANING,
    DELAY_REASON_BED,
    DELAY_REASON_PORTERS,
    DELAY_REASON_PREVIOUS_CASE,
    DELAY_REASON_EMERGENCY_INSERTION,
    DELAY_REASON_OTHER,
  ];

  static final $core.List<DelayReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 12);
  static DelayReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DelayReason._(super.value, super.name);
}

class NoteStatus extends $pb.ProtobufEnum {
  static const NoteStatus NOTE_STATUS_UNSPECIFIED =
      NoteStatus._(0, _omitEnumNames ? '' : 'NOTE_STATUS_UNSPECIFIED');
  static const NoteStatus NOTE_STATUS_DRAFT =
      NoteStatus._(1, _omitEnumNames ? '' : 'NOTE_STATUS_DRAFT');
  static const NoteStatus NOTE_STATUS_SIGNED =
      NoteStatus._(2, _omitEnumNames ? '' : 'NOTE_STATUS_SIGNED');
  static const NoteStatus NOTE_STATUS_AMENDED =
      NoteStatus._(3, _omitEnumNames ? '' : 'NOTE_STATUS_AMENDED');
  static const NoteStatus NOTE_STATUS_SUPERSEDED =
      NoteStatus._(4, _omitEnumNames ? '' : 'NOTE_STATUS_SUPERSEDED');

  static const $core.List<NoteStatus> values = <NoteStatus>[
    NOTE_STATUS_UNSPECIFIED,
    NOTE_STATUS_DRAFT,
    NOTE_STATUS_SIGNED,
    NOTE_STATUS_AMENDED,
    NOTE_STATUS_SUPERSEDED,
  ];

  static final $core.List<NoteStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static NoteStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const NoteStatus._(super.value, super.name);
}

class UsageKind extends $pb.ProtobufEnum {
  static const UsageKind USAGE_KIND_UNSPECIFIED =
      UsageKind._(0, _omitEnumNames ? '' : 'USAGE_KIND_UNSPECIFIED');
  static const UsageKind USAGE_KIND_CONSUMABLE =
      UsageKind._(1, _omitEnumNames ? '' : 'USAGE_KIND_CONSUMABLE');

  /// Stays in the patient. Carries a serial or a lot, because a recall is
  /// traced patient by patient.
  static const UsageKind USAGE_KIND_IMPLANT =
      UsageKind._(2, _omitEnumNames ? '' : 'USAGE_KIND_IMPLANT');

  static const $core.List<UsageKind> values = <UsageKind>[
    USAGE_KIND_UNSPECIFIED,
    USAGE_KIND_CONSUMABLE,
    USAGE_KIND_IMPLANT,
  ];

  static final $core.List<UsageKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static UsageKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UsageKind._(super.value, super.name);
}

/// What a theatre is doing (SRS-OT-013).
class RoomStage extends $pb.ProtobufEnum {
  static const RoomStage ROOM_STAGE_UNSPECIFIED =
      RoomStage._(0, _omitEnumNames ? '' : 'ROOM_STAGE_UNSPECIFIED');
  static const RoomStage ROOM_STAGE_EMPTY =
      RoomStage._(1, _omitEnumNames ? '' : 'ROOM_STAGE_EMPTY');
  static const RoomStage ROOM_STAGE_NEXT_CASE_READY =
      RoomStage._(2, _omitEnumNames ? '' : 'ROOM_STAGE_NEXT_CASE_READY');
  static const RoomStage ROOM_STAGE_IN_USE =
      RoomStage._(3, _omitEnumNames ? '' : 'ROOM_STAGE_IN_USE');

  /// Between cases: the patient has left and the next has not arrived. The
  /// interval a theatre manager watches.
  static const RoomStage ROOM_STAGE_TURNOVER =
      RoomStage._(4, _omitEnumNames ? '' : 'ROOM_STAGE_TURNOVER');
  static const RoomStage ROOM_STAGE_CLOSED =
      RoomStage._(5, _omitEnumNames ? '' : 'ROOM_STAGE_CLOSED');

  static const $core.List<RoomStage> values = <RoomStage>[
    ROOM_STAGE_UNSPECIFIED,
    ROOM_STAGE_EMPTY,
    ROOM_STAGE_NEXT_CASE_READY,
    ROOM_STAGE_IN_USE,
    ROOM_STAGE_TURNOVER,
    ROOM_STAGE_CLOSED,
  ];

  static final $core.List<RoomStage?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static RoomStage? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RoomStage._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
