// This is a generated file - do not edit.
//
// Generated from healthcare/bloodbank/v1/bloodbank.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The ABO blood group (SRS-BLD-007).
class Abo extends $pb.ProtobufEnum {
  /// Not determined. Never compatible with anything, in either direction.
  static const Abo ABO_UNSPECIFIED =
      Abo._(0, _omitEnumNames ? '' : 'ABO_UNSPECIFIED');
  static const Abo ABO_A = Abo._(1, _omitEnumNames ? '' : 'ABO_A');
  static const Abo ABO_B = Abo._(2, _omitEnumNames ? '' : 'ABO_B');
  static const Abo ABO_AB = Abo._(3, _omitEnumNames ? '' : 'ABO_AB');
  static const Abo ABO_O = Abo._(4, _omitEnumNames ? '' : 'ABO_O');

  static const $core.List<Abo> values = <Abo>[
    ABO_UNSPECIFIED,
    ABO_A,
    ABO_B,
    ABO_AB,
    ABO_O,
  ];

  static final $core.List<Abo?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Abo? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Abo._(super.value, super.name);
}

/// The Rh(D) antigen status.
class RhD extends $pb.ProtobufEnum {
  static const RhD RH_D_UNSPECIFIED =
      RhD._(0, _omitEnumNames ? '' : 'RH_D_UNSPECIFIED');
  static const RhD RH_D_POSITIVE =
      RhD._(1, _omitEnumNames ? '' : 'RH_D_POSITIVE');
  static const RhD RH_D_NEGATIVE =
      RhD._(2, _omitEnumNames ? '' : 'RH_D_NEGATIVE');

  static const $core.List<RhD> values = <RhD>[
    RH_D_UNSPECIFIED,
    RH_D_POSITIVE,
    RH_D_NEGATIVE,
  ];

  static final $core.List<RhD?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static RhD? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RhD._(super.value, super.name);
}

/// What the unit is, which decides which compatibility table applies
/// (SRS-BLD-005).
class ComponentClass extends $pb.ProtobufEnum {
  static const ComponentClass COMPONENT_CLASS_UNSPECIFIED =
      ComponentClass._(0, _omitEnumNames ? '' : 'COMPONENT_CLASS_UNSPECIFIED');
  static const ComponentClass COMPONENT_CLASS_RED_CELLS =
      ComponentClass._(1, _omitEnumNames ? '' : 'COMPONENT_CLASS_RED_CELLS');
  static const ComponentClass COMPONENT_CLASS_PLASMA =
      ComponentClass._(2, _omitEnumNames ? '' : 'COMPONENT_CLASS_PLASMA');
  static const ComponentClass COMPONENT_CLASS_PLATELETS =
      ComponentClass._(3, _omitEnumNames ? '' : 'COMPONENT_CLASS_PLATELETS');
  static const ComponentClass COMPONENT_CLASS_CRYOPRECIPITATE =
      ComponentClass._(
          4, _omitEnumNames ? '' : 'COMPONENT_CLASS_CRYOPRECIPITATE');
  static const ComponentClass COMPONENT_CLASS_WHOLE_BLOOD =
      ComponentClass._(5, _omitEnumNames ? '' : 'COMPONENT_CLASS_WHOLE_BLOOD');

  static const $core.List<ComponentClass> values = <ComponentClass>[
    COMPONENT_CLASS_UNSPECIFIED,
    COMPONENT_CLASS_RED_CELLS,
    COMPONENT_CLASS_PLASMA,
    COMPONENT_CLASS_PLATELETS,
    COMPONENT_CLASS_CRYOPRECIPITATE,
    COMPONENT_CLASS_WHOLE_BLOOD,
  ];

  static final $core.List<ComponentClass?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static ComponentClass? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ComponentClass._(super.value, super.name);
}

/// Where a unit is in its life (SRS-BLD-004, SRS-BLD-005).
class UnitStatus extends $pb.ProtobufEnum {
  static const UnitStatus UNIT_STATUS_UNSPECIFIED =
      UnitStatus._(0, _omitEnumNames ? '' : 'UNIT_STATUS_UNSPECIFIED');

  /// The state every unit starts in. Testing has not completed, so the unit
  /// exists and cannot be given to anybody.
  static const UnitStatus UNIT_STATUS_QUARANTINED =
      UnitStatus._(1, _omitEnumNames ? '' : 'UNIT_STATUS_QUARANTINED');
  static const UnitStatus UNIT_STATUS_AVAILABLE =
      UnitStatus._(2, _omitEnumNames ? '' : 'UNIT_STATUS_AVAILABLE');
  static const UnitStatus UNIT_STATUS_RESERVED =
      UnitStatus._(3, _omitEnumNames ? '' : 'UNIT_STATUS_RESERVED');
  static const UnitStatus UNIT_STATUS_ISSUED =
      UnitStatus._(4, _omitEnumNames ? '' : 'UNIT_STATUS_ISSUED');
  static const UnitStatus UNIT_STATUS_TRANSFUSED =
      UnitStatus._(5, _omitEnumNames ? '' : 'UNIT_STATUS_TRANSFUSED');
  static const UnitStatus UNIT_STATUS_DISCARDED =
      UnitStatus._(6, _omitEnumNames ? '' : 'UNIT_STATUS_DISCARDED');

  /// Returned outside its temperature or time window. Distinct from discarded,
  /// because it is still on the shelf until somebody disposes of it and must
  /// never be allocated in the meantime.
  static const UnitStatus UNIT_STATUS_UNSUITABLE =
      UnitStatus._(7, _omitEnumNames ? '' : 'UNIT_STATUS_UNSUITABLE');

  static const $core.List<UnitStatus> values = <UnitStatus>[
    UNIT_STATUS_UNSPECIFIED,
    UNIT_STATUS_QUARANTINED,
    UNIT_STATUS_AVAILABLE,
    UNIT_STATUS_RESERVED,
    UNIT_STATUS_ISSUED,
    UNIT_STATUS_TRANSFUSED,
    UNIT_STATUS_DISCARDED,
    UNIT_STATUS_UNSUITABLE,
  ];

  static final $core.List<UnitStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static UnitStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UnitStatus._(super.value, super.name);
}

/// Why a unit left inventory (SRS-BLD-013).
///
/// Coded, because SRS-BLD-015's report has to distinguish blood that was wasted
/// from blood that was used: a hospital discarding for want of a fridge and one
/// discarding after a positive test need different fixes.
class DiscardReason extends $pb.ProtobufEnum {
  static const DiscardReason DISCARD_REASON_UNSPECIFIED =
      DiscardReason._(0, _omitEnumNames ? '' : 'DISCARD_REASON_UNSPECIFIED');
  static const DiscardReason DISCARD_REASON_EXPIRED =
      DiscardReason._(1, _omitEnumNames ? '' : 'DISCARD_REASON_EXPIRED');
  static const DiscardReason DISCARD_REASON_TEST_FAILED =
      DiscardReason._(2, _omitEnumNames ? '' : 'DISCARD_REASON_TEST_FAILED');
  static const DiscardReason DISCARD_REASON_TEMPERATURE_BREACH =
      DiscardReason._(
          3, _omitEnumNames ? '' : 'DISCARD_REASON_TEMPERATURE_BREACH');
  static const DiscardReason DISCARD_REASON_OUT_OF_TIME =
      DiscardReason._(4, _omitEnumNames ? '' : 'DISCARD_REASON_OUT_OF_TIME');
  static const DiscardReason DISCARD_REASON_DAMAGED =
      DiscardReason._(5, _omitEnumNames ? '' : 'DISCARD_REASON_DAMAGED');
  static const DiscardReason DISCARD_REASON_RECALLED =
      DiscardReason._(6, _omitEnumNames ? '' : 'DISCARD_REASON_RECALLED');
  static const DiscardReason DISCARD_REASON_REACTION_INVESTIGATION =
      DiscardReason._(
          7, _omitEnumNames ? '' : 'DISCARD_REASON_REACTION_INVESTIGATION');

  static const $core.List<DiscardReason> values = <DiscardReason>[
    DISCARD_REASON_UNSPECIFIED,
    DISCARD_REASON_EXPIRED,
    DISCARD_REASON_TEST_FAILED,
    DISCARD_REASON_TEMPERATURE_BREACH,
    DISCARD_REASON_OUT_OF_TIME,
    DISCARD_REASON_DAMAGED,
    DISCARD_REASON_RECALLED,
    DISCARD_REASON_REACTION_INVESTIGATION,
  ];

  static final $core.List<DiscardReason?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static DiscardReason? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiscardReason._(super.value, super.name);
}

/// How long a donor may not give (SRS-BLD-002).
class DeferralKind extends $pb.ProtobufEnum {
  static const DeferralKind DEFERRAL_KIND_UNSPECIFIED =
      DeferralKind._(0, _omitEnumNames ? '' : 'DEFERRAL_KIND_UNSPECIFIED');

  /// Ends on a date: a recent tattoo, a low haemoglobin, a trip somewhere with
  /// malaria.
  static const DeferralKind DEFERRAL_KIND_TEMPORARY =
      DeferralKind._(1, _omitEnumNames ? '' : 'DEFERRAL_KIND_TEMPORARY');

  /// Does not. A donor deferred permanently who later donates is the failure
  /// this record exists to prevent.
  static const DeferralKind DEFERRAL_KIND_PERMANENT =
      DeferralKind._(2, _omitEnumNames ? '' : 'DEFERRAL_KIND_PERMANENT');

  static const $core.List<DeferralKind> values = <DeferralKind>[
    DEFERRAL_KIND_UNSPECIFIED,
    DEFERRAL_KIND_TEMPORARY,
    DEFERRAL_KIND_PERMANENT,
  ];

  static final $core.List<DeferralKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static DeferralKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DeferralKind._(super.value, super.name);
}

/// How soon the blood is needed (SRS-BLD-006).
class RequestUrgency extends $pb.ProtobufEnum {
  static const RequestUrgency REQUEST_URGENCY_UNSPECIFIED =
      RequestUrgency._(0, _omitEnumNames ? '' : 'REQUEST_URGENCY_UNSPECIFIED');
  static const RequestUrgency REQUEST_URGENCY_ROUTINE =
      RequestUrgency._(1, _omitEnumNames ? '' : 'REQUEST_URGENCY_ROUTINE');
  static const RequestUrgency REQUEST_URGENCY_URGENT =
      RequestUrgency._(2, _omitEnumNames ? '' : 'REQUEST_URGENCY_URGENT');
  static const RequestUrgency REQUEST_URGENCY_EMERGENCY =
      RequestUrgency._(3, _omitEnumNames ? '' : 'REQUEST_URGENCY_EMERGENCY');

  static const $core.List<RequestUrgency> values = <RequestUrgency>[
    REQUEST_URGENCY_UNSPECIFIED,
    REQUEST_URGENCY_ROUTINE,
    REQUEST_URGENCY_URGENT,
    REQUEST_URGENCY_EMERGENCY,
  ];

  static final $core.List<RequestUrgency?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RequestUrgency? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequestUrgency._(super.value, super.name);
}

class RequestStatus extends $pb.ProtobufEnum {
  static const RequestStatus REQUEST_STATUS_UNSPECIFIED =
      RequestStatus._(0, _omitEnumNames ? '' : 'REQUEST_STATUS_UNSPECIFIED');
  static const RequestStatus REQUEST_STATUS_OPEN =
      RequestStatus._(1, _omitEnumNames ? '' : 'REQUEST_STATUS_OPEN');
  static const RequestStatus REQUEST_STATUS_FULFILLED =
      RequestStatus._(2, _omitEnumNames ? '' : 'REQUEST_STATUS_FULFILLED');
  static const RequestStatus REQUEST_STATUS_CANCELLED =
      RequestStatus._(3, _omitEnumNames ? '' : 'REQUEST_STATUS_CANCELLED');

  static const $core.List<RequestStatus> values = <RequestStatus>[
    REQUEST_STATUS_UNSPECIFIED,
    REQUEST_STATUS_OPEN,
    REQUEST_STATUS_FULFILLED,
    REQUEST_STATUS_CANCELLED,
  ];

  static final $core.List<RequestStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RequestStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequestStatus._(super.value, super.name);
}

/// Why a unit may not be reserved for a patient (SRS-BLD-007, SRS-BLD-008).
class MatchRefusal extends $pb.ProtobufEnum {
  static const MatchRefusal MATCH_REFUSAL_UNSPECIFIED =
      MatchRefusal._(0, _omitEnumNames ? '' : 'MATCH_REFUSAL_UNSPECIFIED');
  static const MatchRefusal MATCH_REFUSAL_UNIT_NOT_ALLOCATABLE = MatchRefusal._(
      1, _omitEnumNames ? '' : 'MATCH_REFUSAL_UNIT_NOT_ALLOCATABLE');
  static const MatchRefusal MATCH_REFUSAL_UNIT_EXPIRED =
      MatchRefusal._(2, _omitEnumNames ? '' : 'MATCH_REFUSAL_UNIT_EXPIRED');

  /// The patient has no valid grouping sample. Reported separately from
  /// incompatibility, because the fix is another tube rather than other blood.
  static const MatchRefusal MATCH_REFUSAL_NO_VALID_SAMPLE =
      MatchRefusal._(3, _omitEnumNames ? '' : 'MATCH_REFUSAL_NO_VALID_SAMPLE');
  static const MatchRefusal MATCH_REFUSAL_GROUP_INCOMPATIBLE = MatchRefusal._(
      4, _omitEnumNames ? '' : 'MATCH_REFUSAL_GROUP_INCOMPATIBLE');
  static const MatchRefusal MATCH_REFUSAL_WRONG_COMPONENT_TYPE = MatchRefusal._(
      5, _omitEnumNames ? '' : 'MATCH_REFUSAL_WRONG_COMPONENT_TYPE');
  static const MatchRefusal MATCH_REFUSAL_MISSING_SPECIAL_REQUIREMENT =
      MatchRefusal._(
          6, _omitEnumNames ? '' : 'MATCH_REFUSAL_MISSING_SPECIAL_REQUIREMENT');
  static const MatchRefusal MATCH_REFUSAL_CROSSMATCH_REACTIVE = MatchRefusal._(
      7, _omitEnumNames ? '' : 'MATCH_REFUSAL_CROSSMATCH_REACTIVE');

  static const $core.List<MatchRefusal> values = <MatchRefusal>[
    MATCH_REFUSAL_UNSPECIFIED,
    MATCH_REFUSAL_UNIT_NOT_ALLOCATABLE,
    MATCH_REFUSAL_UNIT_EXPIRED,
    MATCH_REFUSAL_NO_VALID_SAMPLE,
    MATCH_REFUSAL_GROUP_INCOMPATIBLE,
    MATCH_REFUSAL_WRONG_COMPONENT_TYPE,
    MATCH_REFUSAL_MISSING_SPECIAL_REQUIREMENT,
    MATCH_REFUSAL_CROSSMATCH_REACTIVE,
  ];

  static final $core.List<MatchRefusal?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static MatchRefusal? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MatchRefusal._(super.value, super.name);
}

/// Why a bedside check failed (SRS-BLD-010).
class BedsideRefusal extends $pb.ProtobufEnum {
  static const BedsideRefusal BEDSIDE_REFUSAL_UNSPECIFIED =
      BedsideRefusal._(0, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_UNSPECIFIED');
  static const BedsideRefusal BEDSIDE_REFUSAL_WRONG_UNIT =
      BedsideRefusal._(1, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_WRONG_UNIT');
  static const BedsideRefusal BEDSIDE_REFUSAL_WRONG_PATIENT = BedsideRefusal._(
      2, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_WRONG_PATIENT');
  static const BedsideRefusal BEDSIDE_REFUSAL_GROUP_MISMATCH = BedsideRefusal._(
      3, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_GROUP_MISMATCH');

  /// One person checking alone is the commonest root cause in every published
  /// wrong-blood incident.
  static const BedsideRefusal BEDSIDE_REFUSAL_SOLO_CHECK =
      BedsideRefusal._(4, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_SOLO_CHECK');
  static const BedsideRefusal BEDSIDE_REFUSAL_UNIT_EXPIRED =
      BedsideRefusal._(5, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_UNIT_EXPIRED');
  static const BedsideRefusal BEDSIDE_REFUSAL_NOT_ISSUED =
      BedsideRefusal._(6, _omitEnumNames ? '' : 'BEDSIDE_REFUSAL_NOT_ISSUED');

  static const $core.List<BedsideRefusal> values = <BedsideRefusal>[
    BEDSIDE_REFUSAL_UNSPECIFIED,
    BEDSIDE_REFUSAL_WRONG_UNIT,
    BEDSIDE_REFUSAL_WRONG_PATIENT,
    BEDSIDE_REFUSAL_GROUP_MISMATCH,
    BEDSIDE_REFUSAL_SOLO_CHECK,
    BEDSIDE_REFUSAL_UNIT_EXPIRED,
    BEDSIDE_REFUSAL_NOT_ISSUED,
  ];

  static final $core.List<BedsideRefusal?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static BedsideRefusal? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const BedsideRefusal._(super.value, super.name);
}

class EpisodeStatus extends $pb.ProtobufEnum {
  static const EpisodeStatus EPISODE_STATUS_UNSPECIFIED =
      EpisodeStatus._(0, _omitEnumNames ? '' : 'EPISODE_STATUS_UNSPECIFIED');
  static const EpisodeStatus EPISODE_STATUS_RUNNING =
      EpisodeStatus._(1, _omitEnumNames ? '' : 'EPISODE_STATUS_RUNNING');
  static const EpisodeStatus EPISODE_STATUS_INTERRUPTED =
      EpisodeStatus._(2, _omitEnumNames ? '' : 'EPISODE_STATUS_INTERRUPTED');
  static const EpisodeStatus EPISODE_STATUS_COMPLETED =
      EpisodeStatus._(3, _omitEnumNames ? '' : 'EPISODE_STATUS_COMPLETED');

  /// Abandoned part-way. Distinct from completed, because the volume given and
  /// the unit's fate differ.
  static const EpisodeStatus EPISODE_STATUS_STOPPED =
      EpisodeStatus._(4, _omitEnumNames ? '' : 'EPISODE_STATUS_STOPPED');

  static const $core.List<EpisodeStatus> values = <EpisodeStatus>[
    EPISODE_STATUS_UNSPECIFIED,
    EPISODE_STATUS_RUNNING,
    EPISODE_STATUS_INTERRUPTED,
    EPISODE_STATUS_COMPLETED,
    EPISODE_STATUS_STOPPED,
  ];

  static final $core.List<EpisodeStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EpisodeStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EpisodeStatus._(super.value, super.name);
}

class ReactionSeverity extends $pb.ProtobufEnum {
  static const ReactionSeverity REACTION_SEVERITY_UNSPECIFIED =
      ReactionSeverity._(
          0, _omitEnumNames ? '' : 'REACTION_SEVERITY_UNSPECIFIED');
  static const ReactionSeverity REACTION_SEVERITY_MILD =
      ReactionSeverity._(1, _omitEnumNames ? '' : 'REACTION_SEVERITY_MILD');
  static const ReactionSeverity REACTION_SEVERITY_MODERATE =
      ReactionSeverity._(2, _omitEnumNames ? '' : 'REACTION_SEVERITY_MODERATE');
  static const ReactionSeverity REACTION_SEVERITY_SEVERE =
      ReactionSeverity._(3, _omitEnumNames ? '' : 'REACTION_SEVERITY_SEVERE');

  /// Counted separately by every haemovigilance scheme. A system with no code
  /// for it records a death as severe.
  static const ReactionSeverity REACTION_SEVERITY_FATAL =
      ReactionSeverity._(4, _omitEnumNames ? '' : 'REACTION_SEVERITY_FATAL');

  static const $core.List<ReactionSeverity> values = <ReactionSeverity>[
    REACTION_SEVERITY_UNSPECIFIED,
    REACTION_SEVERITY_MILD,
    REACTION_SEVERITY_MODERATE,
    REACTION_SEVERITY_SEVERE,
    REACTION_SEVERITY_FATAL,
  ];

  static final $core.List<ReactionSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReactionSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReactionSeverity._(super.value, super.name);
}

class InvestigationState extends $pb.ProtobufEnum {
  static const InvestigationState INVESTIGATION_STATE_UNSPECIFIED =
      InvestigationState._(
          0, _omitEnumNames ? '' : 'INVESTIGATION_STATE_UNSPECIFIED');
  static const InvestigationState INVESTIGATION_STATE_OPEN =
      InvestigationState._(1, _omitEnumNames ? '' : 'INVESTIGATION_STATE_OPEN');
  static const InvestigationState INVESTIGATION_STATE_CONCLUDED =
      InvestigationState._(
          2, _omitEnumNames ? '' : 'INVESTIGATION_STATE_CONCLUDED');

  static const $core.List<InvestigationState> values = <InvestigationState>[
    INVESTIGATION_STATE_UNSPECIFIED,
    INVESTIGATION_STATE_OPEN,
    INVESTIGATION_STATE_CONCLUDED,
  ];

  static final $core.List<InvestigationState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static InvestigationState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InvestigationState._(super.value, super.name);
}

class ReservationStatus extends $pb.ProtobufEnum {
  static const ReservationStatus RESERVATION_STATUS_UNSPECIFIED =
      ReservationStatus._(
          0, _omitEnumNames ? '' : 'RESERVATION_STATUS_UNSPECIFIED');
  static const ReservationStatus RESERVATION_STATUS_HELD =
      ReservationStatus._(1, _omitEnumNames ? '' : 'RESERVATION_STATUS_HELD');
  static const ReservationStatus RESERVATION_STATUS_ISSUED =
      ReservationStatus._(2, _omitEnumNames ? '' : 'RESERVATION_STATUS_ISSUED');
  static const ReservationStatus RESERVATION_STATUS_RELEASED =
      ReservationStatus._(
          3, _omitEnumNames ? '' : 'RESERVATION_STATUS_RELEASED');
  static const ReservationStatus RESERVATION_STATUS_EXPIRED =
      ReservationStatus._(
          4, _omitEnumNames ? '' : 'RESERVATION_STATUS_EXPIRED');

  static const $core.List<ReservationStatus> values = <ReservationStatus>[
    RESERVATION_STATUS_UNSPECIFIED,
    RESERVATION_STATUS_HELD,
    RESERVATION_STATUS_ISSUED,
    RESERVATION_STATUS_RELEASED,
    RESERVATION_STATUS_EXPIRED,
  ];

  static final $core.List<ReservationStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static ReservationStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ReservationStatus._(super.value, super.name);
}

class StockAlertKind extends $pb.ProtobufEnum {
  static const StockAlertKind STOCK_ALERT_KIND_UNSPECIFIED =
      StockAlertKind._(0, _omitEnumNames ? '' : 'STOCK_ALERT_KIND_UNSPECIFIED');
  static const StockAlertKind STOCK_ALERT_KIND_LOW_STOCK =
      StockAlertKind._(1, _omitEnumNames ? '' : 'STOCK_ALERT_KIND_LOW_STOCK');
  static const StockAlertKind STOCK_ALERT_KIND_EXPIRING =
      StockAlertKind._(2, _omitEnumNames ? '' : 'STOCK_ALERT_KIND_EXPIRING');

  static const $core.List<StockAlertKind> values = <StockAlertKind>[
    STOCK_ALERT_KIND_UNSPECIFIED,
    STOCK_ALERT_KIND_LOW_STOCK,
    STOCK_ALERT_KIND_EXPIRING,
  ];

  static final $core.List<StockAlertKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static StockAlertKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const StockAlertKind._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
