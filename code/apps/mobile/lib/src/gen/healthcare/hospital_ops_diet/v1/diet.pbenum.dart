// This is a generated file - do not edit.
//
// Generated from healthcare/hospital_ops_diet/v1/diet.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// How nutrition reaches the patient (SRS-DIET-002).
class Route extends $pb.ProtobufEnum {
  static const Route ROUTE_UNSPECIFIED =
      Route._(0, _omitEnumNames ? '' : 'ROUTE_UNSPECIFIED');
  static const Route ROUTE_ORAL =
      Route._(1, _omitEnumNames ? '' : 'ROUTE_ORAL');

  /// Tube feeding. The regimen is an order in the orders context.
  static const Route ROUTE_ENTERAL =
      Route._(2, _omitEnumNames ? '' : 'ROUTE_ENTERAL');

  /// Intravenous. The bag is a prescription in the medication context.
  static const Route ROUTE_PARENTERAL =
      Route._(3, _omitEnumNames ? '' : 'ROUTE_PARENTERAL');

  /// Nil by mouth. A route rather than a flag on one, because an order
  /// saying "normal diet, and also nil by mouth" is an order two people read
  /// two ways.
  static const Route ROUTE_NPO = Route._(4, _omitEnumNames ? '' : 'ROUTE_NPO');

  static const $core.List<Route> values = <Route>[
    ROUTE_UNSPECIFIED,
    ROUTE_ORAL,
    ROUTE_ENTERAL,
    ROUTE_PARENTERAL,
    ROUTE_NPO,
  ];

  static final $core.List<Route?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Route? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Route._(super.value, super.name);
}

/// Where a diet order stands (SRS-DIET-002, SRS-DIET-003).
class OrderState extends $pb.ProtobufEnum {
  static const OrderState ORDER_STATE_UNSPECIFIED =
      OrderState._(0, _omitEnumNames ? '' : 'ORDER_STATE_UNSPECIFIED');

  /// Placed and not yet safe to cook to: an allergy conflict is open.
  static const OrderState ORDER_STATE_PENDING =
      OrderState._(1, _omitEnumNames ? '' : 'ORDER_STATE_PENDING');
  static const OrderState ORDER_STATE_ACTIVE =
      OrderState._(2, _omitEnumNames ? '' : 'ORDER_STATE_ACTIVE');
  static const OrderState ORDER_STATE_SUPERSEDED =
      OrderState._(3, _omitEnumNames ? '' : 'ORDER_STATE_SUPERSEDED');
  static const OrderState ORDER_STATE_CANCELLED =
      OrderState._(4, _omitEnumNames ? '' : 'ORDER_STATE_CANCELLED');

  static const $core.List<OrderState> values = <OrderState>[
    ORDER_STATE_UNSPECIFIED,
    ORDER_STATE_PENDING,
    ORDER_STATE_ACTIVE,
    ORDER_STATE_SUPERSEDED,
    ORDER_STATE_CANCELLED,
  ];

  static final $core.List<OrderState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static OrderState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderState._(super.value, super.name);
}

/// Where an assessment stands (SRS-DIET-001).
class AssessmentState extends $pb.ProtobufEnum {
  static const AssessmentState ASSESSMENT_STATE_UNSPECIFIED = AssessmentState._(
      0, _omitEnumNames ? '' : 'ASSESSMENT_STATE_UNSPECIFIED');
  static const AssessmentState ASSESSMENT_STATE_DRAFT =
      AssessmentState._(1, _omitEnumNames ? '' : 'ASSESSMENT_STATE_DRAFT');
  static const AssessmentState ASSESSMENT_STATE_SIGNED =
      AssessmentState._(2, _omitEnumNames ? '' : 'ASSESSMENT_STATE_SIGNED');

  static const $core.List<AssessmentState> values = <AssessmentState>[
    ASSESSMENT_STATE_UNSPECIFIED,
    ASSESSMENT_STATE_DRAFT,
    ASSESSMENT_STATE_SIGNED,
  ];

  static final $core.List<AssessmentState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static AssessmentState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AssessmentState._(super.value, super.name);
}

/// Which way a goal wants its measure to move (SRS-DIET-004).
class Direction extends $pb.ProtobufEnum {
  static const Direction DIRECTION_UNSPECIFIED =
      Direction._(0, _omitEnumNames ? '' : 'DIRECTION_UNSPECIFIED');
  static const Direction DIRECTION_INCREASE =
      Direction._(1, _omitEnumNames ? '' : 'DIRECTION_INCREASE');
  static const Direction DIRECTION_DECREASE =
      Direction._(2, _omitEnumNames ? '' : 'DIRECTION_DECREASE');

  /// Holding steady is the right goal for most inpatients, and a system that
  /// only knows increase and decrease cannot express it.
  static const Direction DIRECTION_MAINTAIN =
      Direction._(3, _omitEnumNames ? '' : 'DIRECTION_MAINTAIN');

  static const $core.List<Direction> values = <Direction>[
    DIRECTION_UNSPECIFIED,
    DIRECTION_INCREASE,
    DIRECTION_DECREASE,
    DIRECTION_MAINTAIN,
  ];

  static final $core.List<Direction?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Direction? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Direction._(super.value, super.name);
}

/// Where a care plan stands (SRS-DIET-004).
class PlanState extends $pb.ProtobufEnum {
  static const PlanState PLAN_STATE_UNSPECIFIED =
      PlanState._(0, _omitEnumNames ? '' : 'PLAN_STATE_UNSPECIFIED');
  static const PlanState PLAN_STATE_ACTIVE =
      PlanState._(1, _omitEnumNames ? '' : 'PLAN_STATE_ACTIVE');
  static const PlanState PLAN_STATE_CLOSED =
      PlanState._(2, _omitEnumNames ? '' : 'PLAN_STATE_CLOSED');

  static const $core.List<PlanState> values = <PlanState>[
    PLAN_STATE_UNSPECIFIED,
    PLAN_STATE_ACTIVE,
    PLAN_STATE_CLOSED,
  ];

  static final $core.List<PlanState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PlanState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PlanState._(super.value, super.name);
}

/// Which service a census is for (SRS-DIET-005).
class MealCycle extends $pb.ProtobufEnum {
  static const MealCycle MEAL_CYCLE_UNSPECIFIED =
      MealCycle._(0, _omitEnumNames ? '' : 'MEAL_CYCLE_UNSPECIFIED');
  static const MealCycle MEAL_CYCLE_BREAKFAST =
      MealCycle._(1, _omitEnumNames ? '' : 'MEAL_CYCLE_BREAKFAST');
  static const MealCycle MEAL_CYCLE_LUNCH =
      MealCycle._(2, _omitEnumNames ? '' : 'MEAL_CYCLE_LUNCH');
  static const MealCycle MEAL_CYCLE_DINNER =
      MealCycle._(3, _omitEnumNames ? '' : 'MEAL_CYCLE_DINNER');
  static const MealCycle MEAL_CYCLE_SNACK =
      MealCycle._(4, _omitEnumNames ? '' : 'MEAL_CYCLE_SNACK');

  static const $core.List<MealCycle> values = <MealCycle>[
    MEAL_CYCLE_UNSPECIFIED,
    MEAL_CYCLE_BREAKFAST,
    MEAL_CYCLE_LUNCH,
    MEAL_CYCLE_DINNER,
    MEAL_CYCLE_SNACK,
  ];

  static final $core.List<MealCycle?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static MealCycle? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const MealCycle._(super.value, super.name);
}

/// Where a meal census stands (SRS-DIET-005).
class CensusState extends $pb.ProtobufEnum {
  static const CensusState CENSUS_STATE_UNSPECIFIED =
      CensusState._(0, _omitEnumNames ? '' : 'CENSUS_STATE_UNSPECIFIED');
  static const CensusState CENSUS_STATE_DRAFT =
      CensusState._(1, _omitEnumNames ? '' : 'CENSUS_STATE_DRAFT');

  /// The census at production cutoff: what the kitchen cooked to. Never
  /// edited after this; a change produces a new version.
  static const CensusState CENSUS_STATE_FROZEN =
      CensusState._(2, _omitEnumNames ? '' : 'CENSUS_STATE_FROZEN');
  static const CensusState CENSUS_STATE_SUPERSEDED =
      CensusState._(3, _omitEnumNames ? '' : 'CENSUS_STATE_SUPERSEDED');

  static const $core.List<CensusState> values = <CensusState>[
    CENSUS_STATE_UNSPECIFIED,
    CENSUS_STATE_DRAFT,
    CENSUS_STATE_FROZEN,
    CENSUS_STATE_SUPERSEDED,
  ];

  static final $core.List<CensusState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static CensusState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CensusState._(super.value, super.name);
}

/// Where one patient's tray stands (SRS-DIET-006, SRS-DIET-009).
class TrayState extends $pb.ProtobufEnum {
  static const TrayState TRAY_STATE_UNSPECIFIED =
      TrayState._(0, _omitEnumNames ? '' : 'TRAY_STATE_UNSPECIFIED');
  static const TrayState TRAY_STATE_PLANNED =
      TrayState._(1, _omitEnumNames ? '' : 'TRAY_STATE_PLANNED');
  static const TrayState TRAY_STATE_PREPARED =
      TrayState._(2, _omitEnumNames ? '' : 'TRAY_STATE_PREPARED');
  static const TrayState TRAY_STATE_DISPATCHED =
      TrayState._(3, _omitEnumNames ? '' : 'TRAY_STATE_DISPATCHED');
  static const TrayState TRAY_STATE_DELIVERED =
      TrayState._(4, _omitEnumNames ? '' : 'TRAY_STATE_DELIVERED');

  /// Offered and declined.
  static const TrayState TRAY_STATE_REFUSED =
      TrayState._(5, _omitEnumNames ? '' : 'TRAY_STATE_REFUSED');

  /// Never reached the patient. A clinical fact rather than a logistics one:
  /// a patient who missed three meals has not eaten for a day.
  static const TrayState TRAY_STATE_MISSED =
      TrayState._(6, _omitEnumNames ? '' : 'TRAY_STATE_MISSED');

  /// Stopped by the dispatch check. The reason is always set, because the
  /// common one is that the patient is now nil by mouth.
  static const TrayState TRAY_STATE_WITHHELD =
      TrayState._(7, _omitEnumNames ? '' : 'TRAY_STATE_WITHHELD');

  static const $core.List<TrayState> values = <TrayState>[
    TRAY_STATE_UNSPECIFIED,
    TRAY_STATE_PLANNED,
    TRAY_STATE_PREPARED,
    TRAY_STATE_DISPATCHED,
    TRAY_STATE_DELIVERED,
    TRAY_STATE_REFUSED,
    TRAY_STATE_MISSED,
    TRAY_STATE_WITHHELD,
  ];

  static final $core.List<TrayState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static TrayState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TrayState._(super.value, super.name);
}

/// How nutrition support is delivered (SRS-DIET-007).
class SupportKind extends $pb.ProtobufEnum {
  static const SupportKind SUPPORT_KIND_UNSPECIFIED =
      SupportKind._(0, _omitEnumNames ? '' : 'SUPPORT_KIND_UNSPECIFIED');
  static const SupportKind SUPPORT_KIND_ENTERAL =
      SupportKind._(1, _omitEnumNames ? '' : 'SUPPORT_KIND_ENTERAL');
  static const SupportKind SUPPORT_KIND_PARENTERAL =
      SupportKind._(2, _omitEnumNames ? '' : 'SUPPORT_KIND_PARENTERAL');

  static const $core.List<SupportKind> values = <SupportKind>[
    SUPPORT_KIND_UNSPECIFIED,
    SUPPORT_KIND_ENTERAL,
    SUPPORT_KIND_PARENTERAL,
  ];

  static final $core.List<SupportKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SupportKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SupportKind._(super.value, super.name);
}

/// Where a support plan stands (SRS-DIET-007).
class SupportState extends $pb.ProtobufEnum {
  static const SupportState SUPPORT_STATE_UNSPECIFIED =
      SupportState._(0, _omitEnumNames ? '' : 'SUPPORT_STATE_UNSPECIFIED');

  /// The dietitian's plan with no order behind it. Nothing is running: this
  /// state exists so a plan cannot be mistaken for a feed.
  static const SupportState SUPPORT_STATE_PLANNED =
      SupportState._(1, _omitEnumNames ? '' : 'SUPPORT_STATE_PLANNED');
  static const SupportState SUPPORT_STATE_ACTIVE =
      SupportState._(2, _omitEnumNames ? '' : 'SUPPORT_STATE_ACTIVE');
  static const SupportState SUPPORT_STATE_STOPPED =
      SupportState._(3, _omitEnumNames ? '' : 'SUPPORT_STATE_STOPPED');

  static const $core.List<SupportState> values = <SupportState>[
    SUPPORT_STATE_UNSPECIFIED,
    SUPPORT_STATE_PLANNED,
    SUPPORT_STATE_ACTIVE,
    SUPPORT_STATE_STOPPED,
  ];

  static final $core.List<SupportState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SupportState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SupportState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
