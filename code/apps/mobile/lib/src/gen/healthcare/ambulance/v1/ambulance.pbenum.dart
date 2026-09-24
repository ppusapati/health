// This is a generated file - do not edit.
//
// Generated from healthcare/ambulance/v1/ambulance.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// What an ambulance can do (SRS-AMB-002).
class VehicleKind extends $pb.ProtobufEnum {
  static const VehicleKind VEHICLE_KIND_UNSPECIFIED =
      VehicleKind._(0, _omitEnumNames ? '' : 'VEHICLE_KIND_UNSPECIFIED');

  /// Advanced life support: a paramedic crew, a monitor, a defibrillator and
  /// drugs.
  static const VehicleKind VEHICLE_KIND_ALS =
      VehicleKind._(1, _omitEnumNames ? '' : 'VEHICLE_KIND_ALS');
  static const VehicleKind VEHICLE_KIND_BLS =
      VehicleKind._(2, _omitEnumNames ? '' : 'VEHICLE_KIND_BLS');

  /// Carries a stable patient between sites. Not a response vehicle, and no
  /// override sends one to an emergency.
  static const VehicleKind VEHICLE_KIND_TRANSPORT =
      VehicleKind._(3, _omitEnumNames ? '' : 'VEHICLE_KIND_TRANSPORT');

  /// An incubator transport.
  static const VehicleKind VEHICLE_KIND_NEONATAL =
      VehicleKind._(4, _omitEnumNames ? '' : 'VEHICLE_KIND_NEONATAL');

  static const $core.List<VehicleKind> values = <VehicleKind>[
    VEHICLE_KIND_UNSPECIFIED,
    VEHICLE_KIND_ALS,
    VEHICLE_KIND_BLS,
    VEHICLE_KIND_TRANSPORT,
    VEHICLE_KIND_NEONATAL,
  ];

  static final $core.List<VehicleKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static VehicleKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VehicleKind._(super.value, super.name);
}

/// Where a vehicle stands (SRS-AMB-002).
class VehicleState extends $pb.ProtobufEnum {
  static const VehicleState VEHICLE_STATE_UNSPECIFIED =
      VehicleState._(0, _omitEnumNames ? '' : 'VEHICLE_STATE_UNSPECIFIED');

  /// Off the run: maintenance, repair, or not staffed. Where a vehicle
  /// starts, because one that appeared as available the moment somebody
  /// typed its plate is one a dispatcher can send before anybody looked
  /// inside it.
  static const VehicleState VEHICLE_STATE_OUT_OF_SERVICE =
      VehicleState._(1, _omitEnumNames ? '' : 'VEHICLE_STATE_OUT_OF_SERVICE');
  static const VehicleState VEHICLE_STATE_AVAILABLE =
      VehicleState._(2, _omitEnumNames ? '' : 'VEHICLE_STATE_AVAILABLE');
  static const VehicleState VEHICLE_STATE_ON_TRIP =
      VehicleState._(3, _omitEnumNames ? '' : 'VEHICLE_STATE_ON_TRIP');

  /// Sold or scrapped. Kept, because the trips it ran are still trips.
  static const VehicleState VEHICLE_STATE_RETIRED =
      VehicleState._(4, _omitEnumNames ? '' : 'VEHICLE_STATE_RETIRED');

  static const $core.List<VehicleState> values = <VehicleState>[
    VEHICLE_STATE_UNSPECIFIED,
    VEHICLE_STATE_OUT_OF_SERVICE,
    VEHICLE_STATE_AVAILABLE,
    VEHICLE_STATE_ON_TRIP,
    VEHICLE_STATE_RETIRED,
  ];

  static final $core.List<VehicleState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static VehicleState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VehicleState._(super.value, super.name);
}

/// What somebody on the vehicle is qualified to do (SRS-AMB-002).
class CrewRole extends $pb.ProtobufEnum {
  static const CrewRole CREW_ROLE_UNSPECIFIED =
      CrewRole._(0, _omitEnumNames ? '' : 'CREW_ROLE_UNSPECIFIED');

  /// Not a clinical role here. Not about competence — plenty of drivers are
  /// trained — but the person recorded as having given a drug has to be
  /// somebody the service says may give it.
  static const CrewRole CREW_ROLE_DRIVER =
      CrewRole._(1, _omitEnumNames ? '' : 'CREW_ROLE_DRIVER');
  static const CrewRole CREW_ROLE_EMT =
      CrewRole._(2, _omitEnumNames ? '' : 'CREW_ROLE_EMT');
  static const CrewRole CREW_ROLE_PARAMEDIC =
      CrewRole._(3, _omitEnumNames ? '' : 'CREW_ROLE_PARAMEDIC');
  static const CrewRole CREW_ROLE_NURSE =
      CrewRole._(4, _omitEnumNames ? '' : 'CREW_ROLE_NURSE');
  static const CrewRole CREW_ROLE_DOCTOR =
      CrewRole._(5, _omitEnumNames ? '' : 'CREW_ROLE_DOCTOR');

  static const $core.List<CrewRole> values = <CrewRole>[
    CREW_ROLE_UNSPECIFIED,
    CREW_ROLE_DRIVER,
    CREW_ROLE_EMT,
    CREW_ROLE_PARAMEDIC,
    CREW_ROLE_NURSE,
    CREW_ROLE_DOCTOR,
  ];

  static final $core.List<CrewRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CrewRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CrewRole._(super.value, super.name);
}

/// Where a crew shift stands (SRS-AMB-002).
class ShiftState extends $pb.ProtobufEnum {
  static const ShiftState SHIFT_STATE_UNSPECIFIED =
      ShiftState._(0, _omitEnumNames ? '' : 'SHIFT_STATE_UNSPECIFIED');
  static const ShiftState SHIFT_STATE_PLANNED =
      ShiftState._(1, _omitEnumNames ? '' : 'SHIFT_STATE_PLANNED');
  static const ShiftState SHIFT_STATE_ON_DUTY =
      ShiftState._(2, _omitEnumNames ? '' : 'SHIFT_STATE_ON_DUTY');
  static const ShiftState SHIFT_STATE_ENDED =
      ShiftState._(3, _omitEnumNames ? '' : 'SHIFT_STATE_ENDED');

  static const $core.List<ShiftState> values = <ShiftState>[
    SHIFT_STATE_UNSPECIFIED,
    SHIFT_STATE_PLANNED,
    SHIFT_STATE_ON_DUTY,
    SHIFT_STATE_ENDED,
  ];

  static final $core.List<ShiftState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static ShiftState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ShiftState._(super.value, super.name);
}

/// How a readiness check came out (SRS-AMB-006).
class CheckState extends $pb.ProtobufEnum {
  static const CheckState CHECK_STATE_UNSPECIFIED =
      CheckState._(0, _omitEnumNames ? '' : 'CHECK_STATE_UNSPECIFIED');
  static const CheckState CHECK_STATE_PASSED =
      CheckState._(1, _omitEnumNames ? '' : 'CHECK_STATE_PASSED');
  static const CheckState CHECK_STATE_FAILED =
      CheckState._(2, _omitEnumNames ? '' : 'CHECK_STATE_FAILED');

  /// Failed and waved through by a second person. Its own state rather than
  /// a pass, so a readiness report cannot count it as one.
  static const CheckState CHECK_STATE_OVERRIDDEN =
      CheckState._(3, _omitEnumNames ? '' : 'CHECK_STATE_OVERRIDDEN');

  static const $core.List<CheckState> values = <CheckState>[
    CHECK_STATE_UNSPECIFIED,
    CHECK_STATE_PASSED,
    CHECK_STATE_FAILED,
    CHECK_STATE_OVERRIDDEN,
  ];

  static final $core.List<CheckState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CheckState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CheckState._(super.value, super.name);
}

/// How soon the ambulance is needed (SRS-AMB-001).
class Priority extends $pb.ProtobufEnum {
  static const Priority PRIORITY_UNSPECIFIED =
      Priority._(0, _omitEnumNames ? '' : 'PRIORITY_UNSPECIFIED');
  static const Priority PRIORITY_IMMEDIATE =
      Priority._(1, _omitEnumNames ? '' : 'PRIORITY_IMMEDIATE');
  static const Priority PRIORITY_URGENT =
      Priority._(2, _omitEnumNames ? '' : 'PRIORITY_URGENT');
  static const Priority PRIORITY_ROUTINE =
      Priority._(3, _omitEnumNames ? '' : 'PRIORITY_ROUTINE');

  static const $core.List<Priority> values = <Priority>[
    PRIORITY_UNSPECIFIED,
    PRIORITY_IMMEDIATE,
    PRIORITY_URGENT,
    PRIORITY_ROUTINE,
  ];

  static final $core.List<Priority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Priority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Priority._(super.value, super.name);
}

/// Why the ambulance is wanted (SRS-AMB-001, SRS-AMB-007).
class RequestKind extends $pb.ProtobufEnum {
  static const RequestKind REQUEST_KIND_UNSPECIFIED =
      RequestKind._(0, _omitEnumNames ? '' : 'REQUEST_KIND_UNSPECIFIED');
  static const RequestKind REQUEST_KIND_EMERGENCY =
      RequestKind._(1, _omitEnumNames ? '' : 'REQUEST_KIND_EMERGENCY');

  /// Between two hospitals. Both ends are named and they are not the same
  /// hospital.
  static const RequestKind REQUEST_KIND_INTERFACILITY =
      RequestKind._(2, _omitEnumNames ? '' : 'REQUEST_KIND_INTERFACILITY');
  static const RequestKind REQUEST_KIND_DISCHARGE =
      RequestKind._(3, _omitEnumNames ? '' : 'REQUEST_KIND_DISCHARGE');

  static const $core.List<RequestKind> values = <RequestKind>[
    REQUEST_KIND_UNSPECIFIED,
    REQUEST_KIND_EMERGENCY,
    REQUEST_KIND_INTERFACILITY,
    REQUEST_KIND_DISCHARGE,
  ];

  static final $core.List<RequestKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static RequestKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequestKind._(super.value, super.name);
}

/// Where a call stands (SRS-AMB-001).
class RequestState extends $pb.ProtobufEnum {
  static const RequestState REQUEST_STATE_UNSPECIFIED =
      RequestState._(0, _omitEnumNames ? '' : 'REQUEST_STATE_UNSPECIFIED');
  static const RequestState REQUEST_STATE_QUEUED =
      RequestState._(1, _omitEnumNames ? '' : 'REQUEST_STATE_QUEUED');
  static const RequestState REQUEST_STATE_ASSIGNED =
      RequestState._(2, _omitEnumNames ? '' : 'REQUEST_STATE_ASSIGNED');
  static const RequestState REQUEST_STATE_COMPLETED =
      RequestState._(3, _omitEnumNames ? '' : 'REQUEST_STATE_COMPLETED');
  static const RequestState REQUEST_STATE_CANCELLED =
      RequestState._(4, _omitEnumNames ? '' : 'REQUEST_STATE_CANCELLED');

  static const $core.List<RequestState> values = <RequestState>[
    REQUEST_STATE_UNSPECIFIED,
    REQUEST_STATE_QUEUED,
    REQUEST_STATE_ASSIGNED,
    REQUEST_STATE_COMPLETED,
    REQUEST_STATE_CANCELLED,
  ];

  static final $core.List<RequestState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RequestState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RequestState._(super.value, super.name);
}

/// A point on a trip's timeline (SRS-AMB-003).
///
/// In order. A timeline that accepted them out of order would have a crew
/// leaving a scene before it arrived, and an on-scene time below zero.
class Milestone extends $pb.ProtobufEnum {
  static const Milestone MILESTONE_UNSPECIFIED =
      Milestone._(0, _omitEnumNames ? '' : 'MILESTONE_UNSPECIFIED');
  static const Milestone MILESTONE_DISPATCHED =
      Milestone._(1, _omitEnumNames ? '' : 'MILESTONE_DISPATCHED');
  static const Milestone MILESTONE_MOBILE =
      Milestone._(2, _omitEnumNames ? '' : 'MILESTONE_MOBILE');
  static const Milestone MILESTONE_AT_SCENE =
      Milestone._(3, _omitEnumNames ? '' : 'MILESTONE_AT_SCENE');
  static const Milestone MILESTONE_WITH_PATIENT =
      Milestone._(4, _omitEnumNames ? '' : 'MILESTONE_WITH_PATIENT');
  static const Milestone MILESTONE_LEFT_SCENE =
      Milestone._(5, _omitEnumNames ? '' : 'MILESTONE_LEFT_SCENE');
  static const Milestone MILESTONE_AT_DESTINATION =
      Milestone._(6, _omitEnumNames ? '' : 'MILESTONE_AT_DESTINATION');
  static const Milestone MILESTONE_HANDOVER =
      Milestone._(7, _omitEnumNames ? '' : 'MILESTONE_HANDOVER');

  /// Going clear finishes the trip and puts the vehicle back on the run.
  static const Milestone MILESTONE_CLEAR =
      Milestone._(8, _omitEnumNames ? '' : 'MILESTONE_CLEAR');

  static const $core.List<Milestone> values = <Milestone>[
    MILESTONE_UNSPECIFIED,
    MILESTONE_DISPATCHED,
    MILESTONE_MOBILE,
    MILESTONE_AT_SCENE,
    MILESTONE_WITH_PATIENT,
    MILESTONE_LEFT_SCENE,
    MILESTONE_AT_DESTINATION,
    MILESTONE_HANDOVER,
    MILESTONE_CLEAR,
  ];

  static final $core.List<Milestone?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static Milestone? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Milestone._(super.value, super.name);
}

/// Where a trip stands (SRS-AMB-003).
class TripState extends $pb.ProtobufEnum {
  static const TripState TRIP_STATE_UNSPECIFIED =
      TripState._(0, _omitEnumNames ? '' : 'TRIP_STATE_UNSPECIFIED');
  static const TripState TRIP_STATE_ACTIVE =
      TripState._(1, _omitEnumNames ? '' : 'TRIP_STATE_ACTIVE');
  static const TripState TRIP_STATE_COMPLETED =
      TripState._(2, _omitEnumNames ? '' : 'TRIP_STATE_COMPLETED');

  /// Stood down before it finished. Counted apart from a completed trip: a
  /// service cancelling calls after arriving has a different problem from
  /// one cancelling them before.
  static const TripState TRIP_STATE_ABORTED =
      TripState._(3, _omitEnumNames ? '' : 'TRIP_STATE_ABORTED');

  static const $core.List<TripState> values = <TripState>[
    TRIP_STATE_UNSPECIFIED,
    TRIP_STATE_ACTIVE,
    TRIP_STATE_COMPLETED,
    TRIP_STATE_ABORTED,
  ];

  static final $core.List<TripState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static TripState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TripState._(super.value, super.name);
}

/// What kind of line the crew recorded (SRS-AMB-004).
class EntryKind extends $pb.ProtobufEnum {
  static const EntryKind ENTRY_KIND_UNSPECIFIED =
      EntryKind._(0, _omitEnumNames ? '' : 'ENTRY_KIND_UNSPECIFIED');
  static const EntryKind ENTRY_KIND_OBSERVATION =
      EntryKind._(1, _omitEnumNames ? '' : 'ENTRY_KIND_OBSERVATION');
  static const EntryKind ENTRY_KIND_INTERVENTION =
      EntryKind._(2, _omitEnumNames ? '' : 'ENTRY_KIND_INTERVENTION');
  static const EntryKind ENTRY_KIND_MEDICATION =
      EntryKind._(3, _omitEnumNames ? '' : 'ENTRY_KIND_MEDICATION');
  static const EntryKind ENTRY_KIND_NOTE =
      EntryKind._(4, _omitEnumNames ? '' : 'ENTRY_KIND_NOTE');

  static const $core.List<EntryKind> values = <EntryKind>[
    ENTRY_KIND_UNSPECIFIED,
    ENTRY_KIND_OBSERVATION,
    ENTRY_KIND_INTERVENTION,
    ENTRY_KIND_MEDICATION,
    ENTRY_KIND_NOTE,
  ];

  static final $core.List<EntryKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static EntryKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntryKind._(super.value, super.name);
}

/// Where a handover stands (SRS-AMB-004, SRS-AMB-007).
class HandoverState extends $pb.ProtobufEnum {
  static const HandoverState HANDOVER_STATE_UNSPECIFIED =
      HandoverState._(0, _omitEnumNames ? '' : 'HANDOVER_STATE_UNSPECIFIED');
  static const HandoverState HANDOVER_STATE_DRAFT =
      HandoverState._(1, _omitEnumNames ? '' : 'HANDOVER_STATE_DRAFT');

  /// Given by the crew and not yet taken. A crew standing in a corridor with
  /// a patient nobody has accepted is an ambulance not answering calls.
  static const HandoverState HANDOVER_STATE_GIVEN =
      HandoverState._(2, _omitEnumNames ? '' : 'HANDOVER_STATE_GIVEN');
  static const HandoverState HANDOVER_STATE_ACCEPTED =
      HandoverState._(3, _omitEnumNames ? '' : 'HANDOVER_STATE_ACCEPTED');

  static const $core.List<HandoverState> values = <HandoverState>[
    HANDOVER_STATE_UNSPECIFIED,
    HANDOVER_STATE_DRAFT,
    HANDOVER_STATE_GIVEN,
    HANDOVER_STATE_ACCEPTED,
  ];

  static final $core.List<HandoverState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static HandoverState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const HandoverState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
