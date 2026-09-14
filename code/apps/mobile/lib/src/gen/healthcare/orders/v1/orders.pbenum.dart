// This is a generated file - do not edit.
//
// Generated from healthcare/orders/v1/orders.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// What kind of order this is (SRS-ORD-001).
class OrderType extends $pb.ProtobufEnum {
  static const OrderType ORDER_TYPE_UNSPECIFIED =
      OrderType._(0, _omitEnumNames ? '' : 'ORDER_TYPE_UNSPECIFIED');
  static const OrderType ORDER_TYPE_LABORATORY =
      OrderType._(1, _omitEnumNames ? '' : 'ORDER_TYPE_LABORATORY');
  static const OrderType ORDER_TYPE_IMAGING =
      OrderType._(2, _omitEnumNames ? '' : 'ORDER_TYPE_IMAGING');
  static const OrderType ORDER_TYPE_MEDICATION =
      OrderType._(3, _omitEnumNames ? '' : 'ORDER_TYPE_MEDICATION');
  static const OrderType ORDER_TYPE_PROCEDURE =
      OrderType._(4, _omitEnumNames ? '' : 'ORDER_TYPE_PROCEDURE');
  static const OrderType ORDER_TYPE_DIET =
      OrderType._(5, _omitEnumNames ? '' : 'ORDER_TYPE_DIET');
  static const OrderType ORDER_TYPE_NURSING =
      OrderType._(6, _omitEnumNames ? '' : 'ORDER_TYPE_NURSING');
  static const OrderType ORDER_TYPE_BLOOD_PRODUCT =
      OrderType._(7, _omitEnumNames ? '' : 'ORDER_TYPE_BLOOD_PRODUCT');
  static const OrderType ORDER_TYPE_REFERRAL =
      OrderType._(8, _omitEnumNames ? '' : 'ORDER_TYPE_REFERRAL');
  static const OrderType ORDER_TYPE_ALLIED_HEALTH =
      OrderType._(9, _omitEnumNames ? '' : 'ORDER_TYPE_ALLIED_HEALTH');

  static const $core.List<OrderType> values = <OrderType>[
    ORDER_TYPE_UNSPECIFIED,
    ORDER_TYPE_LABORATORY,
    ORDER_TYPE_IMAGING,
    ORDER_TYPE_MEDICATION,
    ORDER_TYPE_PROCEDURE,
    ORDER_TYPE_DIET,
    ORDER_TYPE_NURSING,
    ORDER_TYPE_BLOOD_PRODUCT,
    ORDER_TYPE_REFERRAL,
    ORDER_TYPE_ALLIED_HEALTH,
  ];

  static final $core.List<OrderType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 9);
  static OrderType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderType._(super.value, super.name);
}

/// Where an order stands (SRS-ORD-005).
class OrderStatus extends $pb.ProtobufEnum {
  static const OrderStatus ORDER_STATUS_UNSPECIFIED =
      OrderStatus._(0, _omitEnumNames ? '' : 'ORDER_STATUS_UNSPECIFIED');

  /// Composed and not submitted. An order set is assembled before any of it is
  /// placed, and a basket downstream could see is one somebody acts on.
  static const OrderStatus ORDER_STATUS_DRAFT =
      OrderStatus._(1, _omitEnumNames ? '' : 'ORDER_STATUS_DRAFT');
  static const OrderStatus ORDER_STATUS_REQUESTED =
      OrderStatus._(2, _omitEnumNames ? '' : 'ORDER_STATUS_REQUESTED');
  static const OrderStatus ORDER_STATUS_ACCEPTED =
      OrderStatus._(3, _omitEnumNames ? '' : 'ORDER_STATUS_ACCEPTED');
  static const OrderStatus ORDER_STATUS_SCHEDULED =
      OrderStatus._(4, _omitEnumNames ? '' : 'ORDER_STATUS_SCHEDULED');

  /// The boundary SRS-ORD-004 turns on: past here something has happened in the
  /// physical world and the order cannot simply be withdrawn.
  static const OrderStatus ORDER_STATUS_IN_PROGRESS =
      OrderStatus._(5, _omitEnumNames ? '' : 'ORDER_STATUS_IN_PROGRESS');
  static const OrderStatus ORDER_STATUS_COMPLETED =
      OrderStatus._(6, _omitEnumNames ? '' : 'ORDER_STATUS_COMPLETED');
  static const OrderStatus ORDER_STATUS_CANCELLED =
      OrderStatus._(7, _omitEnumNames ? '' : 'ORDER_STATUS_CANCELLED');

  /// Never true — placed on the wrong patient. Distinct from cancelled, which
  /// was a real intention withdrawn.
  static const OrderStatus ORDER_STATUS_ENTERED_IN_ERROR =
      OrderStatus._(8, _omitEnumNames ? '' : 'ORDER_STATUS_ENTERED_IN_ERROR');

  static const $core.List<OrderStatus> values = <OrderStatus>[
    ORDER_STATUS_UNSPECIFIED,
    ORDER_STATUS_DRAFT,
    ORDER_STATUS_REQUESTED,
    ORDER_STATUS_ACCEPTED,
    ORDER_STATUS_SCHEDULED,
    ORDER_STATUS_IN_PROGRESS,
    ORDER_STATUS_COMPLETED,
    ORDER_STATUS_CANCELLED,
    ORDER_STATUS_ENTERED_IN_ERROR,
  ];

  static final $core.List<OrderStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 8);
  static OrderStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const OrderStatus._(super.value, super.name);
}

class Priority extends $pb.ProtobufEnum {
  static const Priority PRIORITY_UNSPECIFIED =
      Priority._(0, _omitEnumNames ? '' : 'PRIORITY_UNSPECIFIED');
  static const Priority PRIORITY_ROUTINE =
      Priority._(1, _omitEnumNames ? '' : 'PRIORITY_ROUTINE');
  static const Priority PRIORITY_URGENT =
      Priority._(2, _omitEnumNames ? '' : 'PRIORITY_URGENT');

  /// "Now". Reserved, because an escalation tier everybody uses is not one.
  static const Priority PRIORITY_STAT =
      Priority._(3, _omitEnumNames ? '' : 'PRIORITY_STAT');

  /// At a particular moment rather than as fast as possible. A laboratory that
  /// treats this as stat produces a useless trough level.
  static const Priority PRIORITY_TIMING_CRITICAL =
      Priority._(4, _omitEnumNames ? '' : 'PRIORITY_TIMING_CRITICAL');

  static const $core.List<Priority> values = <Priority>[
    PRIORITY_UNSPECIFIED,
    PRIORITY_ROUTINE,
    PRIORITY_URGENT,
    PRIORITY_STAT,
    PRIORITY_TIMING_CRITICAL,
  ];

  static final $core.List<Priority?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Priority? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Priority._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
