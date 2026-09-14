// This is a generated file - do not edit.
//
// Generated from healthcare/orders/v1/orders.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'orders.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'orders.pbenum.dart';

/// A coded concept from a terminology.
class Coding extends $pb.GeneratedMessage {
  factory Coding({
    $core.String? system,
    $core.String? version,
    $core.String? code,
    $core.String? display,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (version != null) result.version = version;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    return result;
  }

  Coding._();

  factory Coding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Coding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding copyWith(void Function(Coding) updates) =>
      super.copyWith((message) => updates(message as Coding)) as Coding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Coding create() => Coding._();
  @$core.override
  Coding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Coding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coding>(create);
  static Coding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  /// Pins the release: codes have been reassigned between revisions.
  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// A bare code on a screen is a screen clinicians stop reading.
  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);
}

/// When an order should happen (SRS-ORD-008).
///
/// Structured rather than a sentence: the acceptance criterion is that
/// downstream receives normalized timing, and a laboratory that parses
/// "6 hourly starting tomorrow" will parse it differently from the pharmacy.
class Timing extends $pb.GeneratedMessage {
  factory Timing({
    $0.Timestamp? startAt,
    $0.Timestamp? endAt,
    $fixnum.Int64? frequencySeconds,
    $core.int? count,
    $core.Iterable<$core.int>? daysOfWeek,
    $core.Iterable<$core.int>? timesOfDay,
    $core.bool? prn,
    $fixnum.Int64? durationSeconds,
  }) {
    final result = create();
    if (startAt != null) result.startAt = startAt;
    if (endAt != null) result.endAt = endAt;
    if (frequencySeconds != null) result.frequencySeconds = frequencySeconds;
    if (count != null) result.count = count;
    if (daysOfWeek != null) result.daysOfWeek.addAll(daysOfWeek);
    if (timesOfDay != null) result.timesOfDay.addAll(timesOfDay);
    if (prn != null) result.prn = prn;
    if (durationSeconds != null) result.durationSeconds = durationSeconds;
    return result;
  }

  Timing._();

  factory Timing.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Timing.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Timing',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'startAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(3, _omitFieldNames ? '' : 'frequencySeconds')
    ..aI(4, _omitFieldNames ? '' : 'count')
    ..p<$core.int>(5, _omitFieldNames ? '' : 'daysOfWeek', $pb.PbFieldType.K3)
    ..p<$core.int>(6, _omitFieldNames ? '' : 'timesOfDay', $pb.PbFieldType.K3)
    ..aOB(7, _omitFieldNames ? '' : 'prn')
    ..aInt64(8, _omitFieldNames ? '' : 'durationSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timing clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timing copyWith(void Function(Timing) updates) =>
      super.copyWith((message) => updates(message as Timing)) as Timing;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Timing create() => Timing._();
  @$core.override
  Timing createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Timing getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timing>(create);
  static Timing? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get startAt => $_getN(0);
  @$pb.TagNumber(1)
  set startAt($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartAt() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureStartAt() => $_ensure(0);

  /// Zero means open-ended, which is valid for a standing order.
  @$pb.TagNumber(2)
  $0.Timestamp get endAt => $_getN(1);
  @$pb.TagNumber(2)
  set endAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEndAt() => $_ensure(1);

  /// How often, in seconds. Zero means once.
  @$pb.TagNumber(3)
  $fixnum.Int64 get frequencySeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set frequencySeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFrequencySeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrequencySeconds() => $_clearField(3);

  /// Bounds a repeat by number rather than by time: "three doses".
  @$pb.TagNumber(4)
  $core.int get count => $_getIZ(3);
  @$pb.TagNumber(4)
  set count($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearCount() => $_clearField(4);

  /// 0-6 from Sunday. Empty means every day.
  @$pb.TagNumber(5)
  $pb.PbList<$core.int> get daysOfWeek => $_getList(4);

  /// Minutes after midnight in the facility's zone. A four-times-daily drug is
  /// given on the ward round, not every six hours from whenever it was
  /// prescribed — and the difference matters for a drug that must not be given
  /// overnight.
  @$pb.TagNumber(6)
  $pb.PbList<$core.int> get timesOfDay => $_getList(5);

  /// As-needed: no schedule.
  @$pb.TagNumber(7)
  $core.bool get prn => $_getBF(6);
  @$pb.TagNumber(7)
  set prn($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPrn() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrn() => $_clearField(7);

  /// How long each occurrence runs, for an order that is not instantaneous.
  @$pb.TagNumber(8)
  $fixnum.Int64 get durationSeconds => $_getI64(7);
  @$pb.TagNumber(8)
  set durationSeconds($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDurationSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearDurationSeconds() => $_clearField(8);
}

/// A clinician proceeding past a duplicate warning (SRS-ORD-009).
class DuplicateOverride extends $pb.GeneratedMessage {
  factory DuplicateOverride({
    $core.Iterable<$core.String>? againstOrderIds,
    $core.String? reason,
    $core.String? by,
    $0.Timestamp? at,
  }) {
    final result = create();
    if (againstOrderIds != null) result.againstOrderIds.addAll(againstOrderIds);
    if (reason != null) result.reason = reason;
    if (by != null) result.by = by;
    if (at != null) result.at = at;
    return result;
  }

  DuplicateOverride._();

  factory DuplicateOverride.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DuplicateOverride.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateOverride',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'againstOrderIds')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'by')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateOverride clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateOverride copyWith(void Function(DuplicateOverride) updates) =>
      super.copyWith((message) => updates(message as DuplicateOverride))
          as DuplicateOverride;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DuplicateOverride create() => DuplicateOverride._();
  @$core.override
  DuplicateOverride createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DuplicateOverride getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DuplicateOverride>(create);
  static DuplicateOverride? _defaultInstance;

  /// The live orders the requester was shown. Stored rather than recomputed:
  /// they usually complete afterwards, and a recomputing report would show every
  /// override as having overridden nothing.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get againstOrderIds => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get by => $_getSZ(2);
  @$pb.TagNumber(3)
  set by($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get at => $_getN(3);
  @$pb.TagNumber(4)
  set at($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAt() => $_ensure(3);
}

/// One step in an order's life (SRS-ORD-005, SRS-ORD-010).
class StatusChange extends $pb.GeneratedMessage {
  factory StatusChange({
    $core.String? changeId,
    OrderStatus? from,
    OrderStatus? to,
    $core.String? by,
    $core.String? reason,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (changeId != null) result.changeId = changeId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (by != null) result.by = by;
    if (reason != null) result.reason = reason;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  StatusChange._();

  factory StatusChange.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatusChange.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatusChange',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'changeId')
    ..aE<OrderStatus>(2, _omitFieldNames ? '' : 'from',
        enumValues: OrderStatus.values)
    ..aE<OrderStatus>(3, _omitFieldNames ? '' : 'to',
        enumValues: OrderStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'by')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChange clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatusChange copyWith(void Function(StatusChange) updates) =>
      super.copyWith((message) => updates(message as StatusChange))
          as StatusChange;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatusChange create() => StatusChange._();
  @$core.override
  StatusChange createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatusChange getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatusChange>(create);
  static StatusChange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get changeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set changeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChangeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChangeId() => $_clearField(1);

  @$pb.TagNumber(2)
  OrderStatus get from => $_getN(1);
  @$pb.TagNumber(2)
  set from(OrderStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderStatus get to => $_getN(2);
  @$pb.TagNumber(3)
  set to(OrderStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);

  /// A downstream service is a subject like any other, so an acceptance by the
  /// laboratory names its analyser.
  @$pb.TagNumber(4)
  $core.String get by => $_getSZ(3);
  @$pb.TagNumber(4)
  set by($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get occurredAt => $_getN(5);
  @$pb.TagNumber(6)
  set occurredAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOccurredAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOccurredAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOccurredAt() => $_ensure(5);
}

/// One request for something to be done (SRS-ORD-001).
class Order extends $pb.GeneratedMessage {
  factory Order({
    $core.String? orderId,
    $core.String? number,
    OrderType? type,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? requesterId,
    $core.String? enteredById,
    $core.String? targetService,
    Coding? code,
    $core.String? detail,
    $core.String? indication,
    Coding? indicationCode,
    Priority? priority,
    Timing? timing,
    $core.String? conditionalInstruction,
    OrderStatus? status,
    $core.Iterable<StatusChange>? history,
    $core.String? orderSetId,
    $core.String? orderSetVersion,
    $core.String? favouriteId,
    $0.Timestamp? cancellationRequestedAt,
    $core.String? cancellationRequestedBy,
    $core.String? cancellationReason,
    DuplicateOverride? duplicateOverride,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (number != null) result.number = number;
    if (type != null) result.type = type;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (requesterId != null) result.requesterId = requesterId;
    if (enteredById != null) result.enteredById = enteredById;
    if (targetService != null) result.targetService = targetService;
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (indicationCode != null) result.indicationCode = indicationCode;
    if (priority != null) result.priority = priority;
    if (timing != null) result.timing = timing;
    if (conditionalInstruction != null)
      result.conditionalInstruction = conditionalInstruction;
    if (status != null) result.status = status;
    if (history != null) result.history.addAll(history);
    if (orderSetId != null) result.orderSetId = orderSetId;
    if (orderSetVersion != null) result.orderSetVersion = orderSetVersion;
    if (favouriteId != null) result.favouriteId = favouriteId;
    if (cancellationRequestedAt != null)
      result.cancellationRequestedAt = cancellationRequestedAt;
    if (cancellationRequestedBy != null)
      result.cancellationRequestedBy = cancellationRequestedBy;
    if (cancellationReason != null)
      result.cancellationReason = cancellationReason;
    if (duplicateOverride != null) result.duplicateOverride = duplicateOverride;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    return result;
  }

  Order._();

  factory Order.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Order.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Order',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aE<OrderType>(3, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'requesterId')
    ..aOS(8, _omitFieldNames ? '' : 'enteredById')
    ..aOS(9, _omitFieldNames ? '' : 'targetService')
    ..aOM<Coding>(10, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(11, _omitFieldNames ? '' : 'detail')
    ..aOS(12, _omitFieldNames ? '' : 'indication')
    ..aOM<Coding>(13, _omitFieldNames ? '' : 'indicationCode',
        subBuilder: Coding.create)
    ..aE<Priority>(14, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOM<Timing>(15, _omitFieldNames ? '' : 'timing',
        subBuilder: Timing.create)
    ..aOS(16, _omitFieldNames ? '' : 'conditionalInstruction')
    ..aE<OrderStatus>(17, _omitFieldNames ? '' : 'status',
        enumValues: OrderStatus.values)
    ..pPM<StatusChange>(18, _omitFieldNames ? '' : 'history',
        subBuilder: StatusChange.create)
    ..aOS(19, _omitFieldNames ? '' : 'orderSetId')
    ..aOS(20, _omitFieldNames ? '' : 'orderSetVersion')
    ..aOS(21, _omitFieldNames ? '' : 'favouriteId')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'cancellationRequestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(23, _omitFieldNames ? '' : 'cancellationRequestedBy')
    ..aOS(24, _omitFieldNames ? '' : 'cancellationReason')
    ..aOM<DuplicateOverride>(25, _omitFieldNames ? '' : 'duplicateOverride',
        subBuilder: DuplicateOverride.create)
    ..aOM<$0.Timestamp>(26, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(27, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(28, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Order copyWith(void Function(Order) updates) =>
      super.copyWith((message) => updates(message as Order)) as Order;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  @$core.override
  Order createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  /// The human-readable identifier a ward reads down a phone.
  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(OrderType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get encounterId => $_getSZ(4);
  @$pb.TagNumber(5)
  set encounterId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEncounterId() => $_has(4);
  @$pb.TagNumber(5)
  void clearEncounterId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  /// Who is answerable, and who typed it. Not always the same person: a verbal
  /// order taken by a nurse.
  @$pb.TagNumber(7)
  $core.String get requesterId => $_getSZ(6);
  @$pb.TagNumber(7)
  set requesterId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRequesterId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRequesterId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get enteredById => $_getSZ(7);
  @$pb.TagNumber(8)
  set enteredById($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEnteredById() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnteredById() => $_clearField(8);

  /// Derived from the type and stored, so a routing-table change does not
  /// re-route orders already in flight.
  @$pb.TagNumber(9)
  $core.String get targetService => $_getSZ(8);
  @$pb.TagNumber(9)
  set targetService($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTargetService() => $_has(8);
  @$pb.TagNumber(9)
  void clearTargetService() => $_clearField(9);

  @$pb.TagNumber(10)
  Coding get code => $_getN(9);
  @$pb.TagNumber(10)
  set code(Coding value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearCode() => $_clearField(10);
  @$pb.TagNumber(10)
  Coding ensureCode() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get detail => $_getSZ(10);
  @$pb.TagNumber(11)
  set detail($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDetail() => $_has(10);
  @$pb.TagNumber(11)
  void clearDetail() => $_clearField(11);

  /// Why (SRS-ORD-007). Required by policy for the types a tenant configures.
  @$pb.TagNumber(12)
  $core.String get indication => $_getSZ(11);
  @$pb.TagNumber(12)
  set indication($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasIndication() => $_has(11);
  @$pb.TagNumber(12)
  void clearIndication() => $_clearField(12);

  @$pb.TagNumber(13)
  Coding get indicationCode => $_getN(12);
  @$pb.TagNumber(13)
  set indicationCode(Coding value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasIndicationCode() => $_has(12);
  @$pb.TagNumber(13)
  void clearIndicationCode() => $_clearField(13);
  @$pb.TagNumber(13)
  Coding ensureIndicationCode() => $_ensure(12);

  @$pb.TagNumber(14)
  Priority get priority => $_getN(13);
  @$pb.TagNumber(14)
  set priority(Priority value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPriority() => $_has(13);
  @$pb.TagNumber(14)
  void clearPriority() => $_clearField(14);

  @$pb.TagNumber(15)
  Timing get timing => $_getN(14);
  @$pb.TagNumber(15)
  set timing(Timing value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasTiming() => $_has(14);
  @$pb.TagNumber(15)
  void clearTiming() => $_clearField(15);
  @$pb.TagNumber(15)
  Timing ensureTiming() => $_ensure(14);

  /// "If the potassium is under 3.5" — named separately so a receiver cannot
  /// mistake a condition for an instruction.
  @$pb.TagNumber(16)
  $core.String get conditionalInstruction => $_getSZ(15);
  @$pb.TagNumber(16)
  set conditionalInstruction($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasConditionalInstruction() => $_has(15);
  @$pb.TagNumber(16)
  void clearConditionalInstruction() => $_clearField(16);

  @$pb.TagNumber(17)
  OrderStatus get status => $_getN(16);
  @$pb.TagNumber(17)
  set status(OrderStatus value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasStatus() => $_has(16);
  @$pb.TagNumber(17)
  void clearStatus() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<StatusChange> get history => $_getList(17);

  /// SRS-ORD-003's provenance. The version is stored, not referenced: a set
  /// edited afterwards must not restate what was ordered.
  @$pb.TagNumber(19)
  $core.String get orderSetId => $_getSZ(18);
  @$pb.TagNumber(19)
  set orderSetId($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasOrderSetId() => $_has(18);
  @$pb.TagNumber(19)
  void clearOrderSetId() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get orderSetVersion => $_getSZ(19);
  @$pb.TagNumber(20)
  set orderSetVersion($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasOrderSetVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearOrderSetVersion() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get favouriteId => $_getSZ(20);
  @$pb.TagNumber(21)
  set favouriteId($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasFavouriteId() => $_has(20);
  @$pb.TagNumber(21)
  void clearFavouriteId() => $_clearField(21);

  /// SRS-ORD-004's corrective workflow. A request, not a status: the order stays
  /// where the performing service put it.
  @$pb.TagNumber(22)
  $0.Timestamp get cancellationRequestedAt => $_getN(21);
  @$pb.TagNumber(22)
  set cancellationRequestedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCancellationRequestedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearCancellationRequestedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureCancellationRequestedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get cancellationRequestedBy => $_getSZ(22);
  @$pb.TagNumber(23)
  set cancellationRequestedBy($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasCancellationRequestedBy() => $_has(22);
  @$pb.TagNumber(23)
  void clearCancellationRequestedBy() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get cancellationReason => $_getSZ(23);
  @$pb.TagNumber(24)
  set cancellationReason($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasCancellationReason() => $_has(23);
  @$pb.TagNumber(24)
  void clearCancellationReason() => $_clearField(24);

  @$pb.TagNumber(25)
  DuplicateOverride get duplicateOverride => $_getN(24);
  @$pb.TagNumber(25)
  set duplicateOverride(DuplicateOverride value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasDuplicateOverride() => $_has(24);
  @$pb.TagNumber(25)
  void clearDuplicateOverride() => $_clearField(25);
  @$pb.TagNumber(25)
  DuplicateOverride ensureDuplicateOverride() => $_ensure(24);

  @$pb.TagNumber(26)
  $0.Timestamp get createdAt => $_getN(25);
  @$pb.TagNumber(26)
  set createdAt($0.Timestamp value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasCreatedAt() => $_has(25);
  @$pb.TagNumber(26)
  void clearCreatedAt() => $_clearField(26);
  @$pb.TagNumber(26)
  $0.Timestamp ensureCreatedAt() => $_ensure(25);

  @$pb.TagNumber(27)
  $0.Timestamp get updatedAt => $_getN(26);
  @$pb.TagNumber(27)
  set updatedAt($0.Timestamp value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasUpdatedAt() => $_has(26);
  @$pb.TagNumber(27)
  void clearUpdatedAt() => $_clearField(27);
  @$pb.TagNumber(27)
  $0.Timestamp ensureUpdatedAt() => $_ensure(26);

  @$pb.TagNumber(28)
  $fixnum.Int64 get version => $_getI64(27);
  @$pb.TagNumber(28)
  set version($fixnum.Int64 value) => $_setInt64(27, value);
  @$pb.TagNumber(28)
  $core.bool hasVersion() => $_has(27);
  @$pb.TagNumber(28)
  void clearVersion() => $_clearField(28);
}

/// What a clinician is shown when an order repeats a live one (SRS-ORD-009).
class DuplicateWarning extends $pb.GeneratedMessage {
  factory DuplicateWarning({
    $core.Iterable<Order>? existing,
    $core.bool? overridable,
    $fixnum.Int64? windowSeconds,
  }) {
    final result = create();
    if (existing != null) result.existing.addAll(existing);
    if (overridable != null) result.overridable = overridable;
    if (windowSeconds != null) result.windowSeconds = windowSeconds;
    return result;
  }

  DuplicateWarning._();

  factory DuplicateWarning.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DuplicateWarning.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DuplicateWarning',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'existing', subBuilder: Order.create)
    ..aOB(2, _omitFieldNames ? '' : 'overridable')
    ..aInt64(3, _omitFieldNames ? '' : 'windowSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateWarning clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DuplicateWarning copyWith(void Function(DuplicateWarning) updates) =>
      super.copyWith((message) => updates(message as DuplicateWarning))
          as DuplicateWarning;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DuplicateWarning create() => DuplicateWarning._();
  @$core.override
  DuplicateWarning createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DuplicateWarning getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DuplicateWarning>(create);
  static DuplicateWarning? _defaultInstance;

  /// Shown in full rather than counted: "a duplicate exists" without saying
  /// which one is a warning nobody can act on.
  @$pb.TagNumber(1)
  $pb.PbList<Order> get existing => $_getList(0);

  /// Whether proceeding is allowed at all.
  @$pb.TagNumber(2)
  $core.bool get overridable => $_getBF(1);
  @$pb.TagNumber(2)
  set overridable($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOverridable() => $_has(1);
  @$pb.TagNumber(2)
  void clearOverridable() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get windowSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set windowSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWindowSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindowSeconds() => $_clearField(3);
}

class PlaceOrderRequest extends $pb.GeneratedMessage {
  factory PlaceOrderRequest({
    OrderType? type,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    $core.String? detail,
    $core.String? indication,
    Coding? indicationCode,
    Priority? priority,
    Timing? timing,
    $core.String? conditionalInstruction,
    $core.String? enteredById,
    $core.String? acknowledgeDuplicates,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (indicationCode != null) result.indicationCode = indicationCode;
    if (priority != null) result.priority = priority;
    if (timing != null) result.timing = timing;
    if (conditionalInstruction != null)
      result.conditionalInstruction = conditionalInstruction;
    if (enteredById != null) result.enteredById = enteredById;
    if (acknowledgeDuplicates != null)
      result.acknowledgeDuplicates = acknowledgeDuplicates;
    return result;
  }

  PlaceOrderRequest._();

  factory PlaceOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aE<OrderType>(1, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..aOS(6, _omitFieldNames ? '' : 'indication')
    ..aOM<Coding>(7, _omitFieldNames ? '' : 'indicationCode',
        subBuilder: Coding.create)
    ..aE<Priority>(8, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOM<Timing>(9, _omitFieldNames ? '' : 'timing', subBuilder: Timing.create)
    ..aOS(10, _omitFieldNames ? '' : 'conditionalInstruction')
    ..aOS(11, _omitFieldNames ? '' : 'enteredById')
    ..aOS(12, _omitFieldNames ? '' : 'acknowledgeDuplicates')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceOrderRequest copyWith(void Function(PlaceOrderRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceOrderRequest))
          as PlaceOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceOrderRequest create() => PlaceOrderRequest._();
  @$core.override
  PlaceOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceOrderRequest>(create);
  static PlaceOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrderType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(OrderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encounterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set encounterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncounterId() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get indication => $_getSZ(5);
  @$pb.TagNumber(6)
  set indication($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIndication() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndication() => $_clearField(6);

  @$pb.TagNumber(7)
  Coding get indicationCode => $_getN(6);
  @$pb.TagNumber(7)
  set indicationCode(Coding value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIndicationCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearIndicationCode() => $_clearField(7);
  @$pb.TagNumber(7)
  Coding ensureIndicationCode() => $_ensure(6);

  @$pb.TagNumber(8)
  Priority get priority => $_getN(7);
  @$pb.TagNumber(8)
  set priority(Priority value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPriority() => $_has(7);
  @$pb.TagNumber(8)
  void clearPriority() => $_clearField(8);

  @$pb.TagNumber(9)
  Timing get timing => $_getN(8);
  @$pb.TagNumber(9)
  set timing(Timing value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTiming() => $_has(8);
  @$pb.TagNumber(9)
  void clearTiming() => $_clearField(9);
  @$pb.TagNumber(9)
  Timing ensureTiming() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get conditionalInstruction => $_getSZ(9);
  @$pb.TagNumber(10)
  set conditionalInstruction($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConditionalInstruction() => $_has(9);
  @$pb.TagNumber(10)
  void clearConditionalInstruction() => $_clearField(10);

  /// Names the person at the keyboard where that differs from the requester.
  @$pb.TagNumber(11)
  $core.String get enteredById => $_getSZ(10);
  @$pb.TagNumber(11)
  set enteredById($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEnteredById() => $_has(10);
  @$pb.TagNumber(11)
  void clearEnteredById() => $_clearField(11);

  /// The clinician answering a duplicate warning. Empty means they have not been
  /// shown one, and a duplicate is reported rather than placed.
  @$pb.TagNumber(12)
  $core.String get acknowledgeDuplicates => $_getSZ(11);
  @$pb.TagNumber(12)
  set acknowledgeDuplicates($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAcknowledgeDuplicates() => $_has(11);
  @$pb.TagNumber(12)
  void clearAcknowledgeDuplicates() => $_clearField(12);
}

class PlaceOrderResponse extends $pb.GeneratedMessage {
  factory PlaceOrderResponse({
    Order? order,
    DuplicateWarning? warning,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (warning != null) result.warning = warning;
    return result;
  }

  PlaceOrderResponse._();

  factory PlaceOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..aOM<DuplicateWarning>(2, _omitFieldNames ? '' : 'warning',
        subBuilder: DuplicateWarning.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceOrderResponse copyWith(void Function(PlaceOrderResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceOrderResponse))
          as PlaceOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceOrderResponse create() => PlaceOrderResponse._();
  @$core.override
  PlaceOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceOrderResponse>(create);
  static PlaceOrderResponse? _defaultInstance;

  /// Exactly one of these is set. A warning means nothing was placed.
  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  DuplicateWarning get warning => $_getN(1);
  @$pb.TagNumber(2)
  set warning(DuplicateWarning value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWarning() => $_has(1);
  @$pb.TagNumber(2)
  void clearWarning() => $_clearField(2);
  @$pb.TagNumber(2)
  DuplicateWarning ensureWarning() => $_ensure(1);
}

class GetOrderRequest extends $pb.GeneratedMessage {
  factory GetOrderRequest({
    $core.String? orderId,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    return result;
  }

  GetOrderRequest._();

  factory GetOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderRequest copyWith(void Function(GetOrderRequest) updates) =>
      super.copyWith((message) => updates(message as GetOrderRequest))
          as GetOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOrderRequest create() => GetOrderRequest._();
  @$core.override
  GetOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrderRequest>(create);
  static GetOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);
}

class GetOrderResponse extends $pb.GeneratedMessage {
  factory GetOrderResponse({
    Order? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  GetOrderResponse._();

  factory GetOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOrderResponse copyWith(void Function(GetOrderResponse) updates) =>
      super.copyWith((message) => updates(message as GetOrderResponse))
          as GetOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOrderResponse create() => GetOrderResponse._();
  @$core.override
  GetOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOrderResponse>(create);
  static GetOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);
}

class ListOrdersRequest extends $pb.GeneratedMessage {
  factory ListOrdersRequest({
    $core.String? patientId,
    $core.String? encounterId,
    OrderType? type,
    $core.bool? liveOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (type != null) result.type = type;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOrdersRequest._();

  factory ListOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrdersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<OrderType>(3, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOB(4, _omitFieldNames ? '' : 'liveOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrdersRequest copyWith(void Function(ListOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListOrdersRequest))
          as ListOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrdersRequest create() => ListOrdersRequest._();
  @$core.override
  ListOrdersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrdersRequest>(create);
  static ListOrdersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(OrderType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  /// Hides finished orders. Off by default: a chart shows what was ordered, not
  /// only what is outstanding.
  @$pb.TagNumber(4)
  $core.bool get liveOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set liveOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLiveOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearLiveOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListOrdersResponse extends $pb.GeneratedMessage {
  factory ListOrdersResponse({
    $core.Iterable<Order>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  ListOrdersResponse._();

  factory ListOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrdersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders', subBuilder: Order.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrdersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrdersResponse copyWith(void Function(ListOrdersResponse) updates) =>
      super.copyWith((message) => updates(message as ListOrdersResponse))
          as ListOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrdersResponse create() => ListOrdersResponse._();
  @$core.override
  ListOrdersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrdersResponse>(create);
  static ListOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);
}

class GetWorklistRequest extends $pb.GeneratedMessage {
  factory GetWorklistRequest({
    $core.String? service,
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (service != null) result.service = service;
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetWorklistRequest._();

  factory GetWorklistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorklistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorklistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'service')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistRequest copyWith(void Function(GetWorklistRequest) updates) =>
      super.copyWith((message) => updates(message as GetWorklistRequest))
          as GetWorklistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorklistRequest create() => GetWorklistRequest._();
  @$core.override
  GetWorklistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorklistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorklistRequest>(create);
  static GetWorklistRequest? _defaultInstance;

  /// The performing service: laboratory, imaging, pharmacy, blood_bank,
  /// dietetics, nursing, procedures, referrals, allied_health.
  @$pb.TagNumber(1)
  $core.String get service => $_getSZ(0);
  @$pb.TagNumber(1)
  set service($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class GetWorklistResponse extends $pb.GeneratedMessage {
  factory GetWorklistResponse({
    $core.Iterable<Order>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  GetWorklistResponse._();

  factory GetWorklistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorklistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorklistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'orders', subBuilder: Order.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorklistResponse copyWith(void Function(GetWorklistResponse) updates) =>
      super.copyWith((message) => updates(message as GetWorklistResponse))
          as GetWorklistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorklistResponse create() => GetWorklistResponse._();
  @$core.override
  GetWorklistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorklistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorklistResponse>(create);
  static GetWorklistResponse? _defaultInstance;

  /// Most urgent first.
  @$pb.TagNumber(1)
  $pb.PbList<Order> get orders => $_getList(0);
}

class CancelOrderRequest extends $pb.GeneratedMessage {
  factory CancelOrderRequest({
    $core.String? orderId,
    $core.String? reason,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelOrderRequest._();

  factory CancelOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderRequest copyWith(void Function(CancelOrderRequest) updates) =>
      super.copyWith((message) => updates(message as CancelOrderRequest))
          as CancelOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelOrderRequest create() => CancelOrderRequest._();
  @$core.override
  CancelOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelOrderRequest>(create);
  static CancelOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancelOrderResponse extends $pb.GeneratedMessage {
  factory CancelOrderResponse({
    Order? order,
    $core.bool? cancellationRequested,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (cancellationRequested != null)
      result.cancellationRequested = cancellationRequested;
    return result;
  }

  CancelOrderResponse._();

  factory CancelOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..aOB(2, _omitFieldNames ? '' : 'cancellationRequested')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOrderResponse copyWith(void Function(CancelOrderResponse) updates) =>
      super.copyWith((message) => updates(message as CancelOrderResponse))
          as CancelOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelOrderResponse create() => CancelOrderResponse._();
  @$core.override
  CancelOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelOrderResponse>(create);
  static CancelOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);

  /// True where the order was already executing and the cancellation became a
  /// request for the performing service to answer (SRS-ORD-004). A client that
  /// ignored this would tell a ward that a transfusion had stopped when it had
  /// not.
  @$pb.TagNumber(2)
  $core.bool get cancellationRequested => $_getBF(1);
  @$pb.TagNumber(2)
  set cancellationRequested($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCancellationRequested() => $_has(1);
  @$pb.TagNumber(2)
  void clearCancellationRequested() => $_clearField(2);
}

class RetractOrderRequest extends $pb.GeneratedMessage {
  factory RetractOrderRequest({
    $core.String? orderId,
    $core.String? reason,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RetractOrderRequest._();

  factory RetractOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractOrderRequest copyWith(void Function(RetractOrderRequest) updates) =>
      super.copyWith((message) => updates(message as RetractOrderRequest))
          as RetractOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractOrderRequest create() => RetractOrderRequest._();
  @$core.override
  RetractOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractOrderRequest>(create);
  static RetractOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RetractOrderResponse extends $pb.GeneratedMessage {
  factory RetractOrderResponse({
    Order? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  RetractOrderResponse._();

  factory RetractOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetractOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetractOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetractOrderResponse copyWith(void Function(RetractOrderResponse) updates) =>
      super.copyWith((message) => updates(message as RetractOrderResponse))
          as RetractOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetractOrderResponse create() => RetractOrderResponse._();
  @$core.override
  RetractOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetractOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetractOrderResponse>(create);
  static RetractOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);
}

/// A performing service reporting what it did (SRS-ORD-006).
class AcknowledgeOrderRequest extends $pb.GeneratedMessage {
  factory AcknowledgeOrderRequest({
    $core.String? orderId,
    $core.String? service,
    $core.String? deliveryId,
    OrderStatus? status,
    $core.String? reason,
    $core.String? performerId,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (service != null) result.service = service;
    if (deliveryId != null) result.deliveryId = deliveryId;
    if (status != null) result.status = status;
    if (reason != null) result.reason = reason;
    if (performerId != null) result.performerId = performerId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  AcknowledgeOrderRequest._();

  factory AcknowledgeOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'service')
    ..aOS(3, _omitFieldNames ? '' : 'deliveryId')
    ..aE<OrderStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: OrderStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'performerId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOrderRequest copyWith(
          void Function(AcknowledgeOrderRequest) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeOrderRequest))
          as AcknowledgeOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeOrderRequest create() => AcknowledgeOrderRequest._();
  @$core.override
  AcknowledgeOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeOrderRequest>(create);
  static AcknowledgeOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  /// Checked against the order's target, so the kitchen cannot accept a
  /// blood-product order.
  @$pb.TagNumber(2)
  $core.String get service => $_getSZ(1);
  @$pb.TagNumber(2)
  set service($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasService() => $_has(1);
  @$pb.TagNumber(2)
  void clearService() => $_clearField(2);

  /// The bus's identifier for this delivery, and the deduplication key: the same
  /// delivery replayed carries the same identifier. Without it, a replay is
  /// indistinguishable from a new acknowledgement.
  @$pb.TagNumber(3)
  $core.String get deliveryId => $_getSZ(2);
  @$pb.TagNumber(3)
  set deliveryId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeliveryId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeliveryId() => $_clearField(3);

  @$pb.TagNumber(4)
  OrderStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(OrderStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  /// The person or system inside the service. An analyser is a legitimate
  /// answer.
  @$pb.TagNumber(6)
  $core.String get performerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set performerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPerformerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPerformerId() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get occurredAt => $_getN(6);
  @$pb.TagNumber(7)
  set occurredAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOccurredAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearOccurredAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureOccurredAt() => $_ensure(6);
}

class AcknowledgeOrderResponse extends $pb.GeneratedMessage {
  factory AcknowledgeOrderResponse({
    Order? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  AcknowledgeOrderResponse._();

  factory AcknowledgeOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOrderResponse copyWith(
          void Function(AcknowledgeOrderResponse) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeOrderResponse))
          as AcknowledgeOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeOrderResponse create() => AcknowledgeOrderResponse._();
  @$core.override
  AcknowledgeOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeOrderResponse>(create);
  static AcknowledgeOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);
}

/// One order a set offers (SRS-ORD-003).
class Component extends $pb.GeneratedMessage {
  factory Component({
    $core.String? componentId,
    OrderType? type,
    Coding? code,
    $core.String? detail,
    $core.String? indication,
    Priority? priority,
    Timing? timing,
    $core.bool? selectedByDefault,
    $core.bool? mandatory,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (type != null) result.type = type;
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (priority != null) result.priority = priority;
    if (timing != null) result.timing = timing;
    if (selectedByDefault != null) result.selectedByDefault = selectedByDefault;
    if (mandatory != null) result.mandatory = mandatory;
    return result;
  }

  Component._();

  factory Component.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Component.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Component',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aE<OrderType>(2, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOS(5, _omitFieldNames ? '' : 'indication')
    ..aE<Priority>(6, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOM<Timing>(7, _omitFieldNames ? '' : 'timing', subBuilder: Timing.create)
    ..aOB(8, _omitFieldNames ? '' : 'selectedByDefault')
    ..aOB(9, _omitFieldNames ? '' : 'mandatory')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Component clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Component copyWith(void Function(Component) updates) =>
      super.copyWith((message) => updates(message as Component)) as Component;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Component create() => Component._();
  @$core.override
  Component createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Component getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Component>(create);
  static Component? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  OrderType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(OrderType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  /// The visible defaults. Defaults rather than fixed values: a clinician may
  /// change any of them.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get indication => $_getSZ(4);
  @$pb.TagNumber(5)
  set indication($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIndication() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndication() => $_clearField(5);

  @$pb.TagNumber(6)
  Priority get priority => $_getN(5);
  @$pb.TagNumber(6)
  set priority(Priority value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPriority() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriority() => $_clearField(6);

  @$pb.TagNumber(7)
  Timing get timing => $_getN(6);
  @$pb.TagNumber(7)
  set timing(Timing value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTiming() => $_has(6);
  @$pb.TagNumber(7)
  void clearTiming() => $_clearField(7);
  @$pb.TagNumber(7)
  Timing ensureTiming() => $_ensure(6);

  /// Whether the box is ticked when the set opens. An unticked component is
  /// offered; a ticked one is what the institution recommends.
  @$pb.TagNumber(8)
  $core.bool get selectedByDefault => $_getBF(7);
  @$pb.TagNumber(8)
  set selectedByDefault($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSelectedByDefault() => $_has(7);
  @$pb.TagNumber(8)
  void clearSelectedByDefault() => $_clearField(8);

  /// Cannot be unticked — a group-and-save with a blood-product order. Rare and
  /// deliberate: a set where everything is mandatory has no selection at all.
  @$pb.TagNumber(9)
  $core.bool get mandatory => $_getBF(8);
  @$pb.TagNumber(9)
  set mandatory($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMandatory() => $_has(8);
  @$pb.TagNumber(9)
  void clearMandatory() => $_clearField(9);
}

/// An institutional bundle of orders (SRS-ORD-003).
class OrderSet extends $pb.GeneratedMessage {
  factory OrderSet({
    $core.String? setId,
    $core.String? version,
    $core.String? name,
    $core.String? specialty,
    $core.Iterable<Component>? components,
    $core.bool? retired,
    $core.String? createdBy,
    $0.Timestamp? createdAt,
  }) {
    final result = create();
    if (setId != null) result.setId = setId;
    if (version != null) result.version = version;
    if (name != null) result.name = name;
    if (specialty != null) result.specialty = specialty;
    if (components != null) result.components.addAll(components);
    if (retired != null) result.retired = retired;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
    return result;
  }

  OrderSet._();

  factory OrderSet.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OrderSet.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OrderSet',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'specialty')
    ..pPM<Component>(5, _omitFieldNames ? '' : 'components',
        subBuilder: Component.create)
    ..aOB(6, _omitFieldNames ? '' : 'retired')
    ..aOS(7, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderSet clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OrderSet copyWith(void Function(OrderSet) updates) =>
      super.copyWith((message) => updates(message as OrderSet)) as OrderSet;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OrderSet create() => OrderSet._();
  @$core.override
  OrderSet createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OrderSet getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OrderSet>(create);
  static OrderSet? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setId => $_getSZ(0);
  @$pb.TagNumber(1)
  set setId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get specialty => $_getSZ(3);
  @$pb.TagNumber(4)
  set specialty($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpecialty() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpecialty() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Component> get components => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get retired => $_getBF(5);
  @$pb.TagNumber(6)
  set retired($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRetired() => $_has(5);
  @$pb.TagNumber(6)
  void clearRetired() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get createdBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set createdBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCreatedAt() => $_ensure(7);
}

class DefineOrderSetRequest extends $pb.GeneratedMessage {
  factory DefineOrderSetRequest({
    OrderSet? set,
  }) {
    final result = create();
    if (set != null) result.set = set;
    return result;
  }

  DefineOrderSetRequest._();

  factory DefineOrderSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineOrderSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineOrderSetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<OrderSet>(1, _omitFieldNames ? '' : 'set',
        subBuilder: OrderSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineOrderSetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineOrderSetRequest copyWith(
          void Function(DefineOrderSetRequest) updates) =>
      super.copyWith((message) => updates(message as DefineOrderSetRequest))
          as DefineOrderSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineOrderSetRequest create() => DefineOrderSetRequest._();
  @$core.override
  DefineOrderSetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineOrderSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineOrderSetRequest>(create);
  static DefineOrderSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrderSet get set => $_getN(0);
  @$pb.TagNumber(1)
  set set(OrderSet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearSet() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderSet ensureSet() => $_ensure(0);
}

class DefineOrderSetResponse extends $pb.GeneratedMessage {
  factory DefineOrderSetResponse({
    OrderSet? set,
  }) {
    final result = create();
    if (set != null) result.set = set;
    return result;
  }

  DefineOrderSetResponse._();

  factory DefineOrderSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineOrderSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineOrderSetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<OrderSet>(1, _omitFieldNames ? '' : 'set',
        subBuilder: OrderSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineOrderSetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineOrderSetResponse copyWith(
          void Function(DefineOrderSetResponse) updates) =>
      super.copyWith((message) => updates(message as DefineOrderSetResponse))
          as DefineOrderSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineOrderSetResponse create() => DefineOrderSetResponse._();
  @$core.override
  DefineOrderSetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineOrderSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineOrderSetResponse>(create);
  static DefineOrderSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OrderSet get set => $_getN(0);
  @$pb.TagNumber(1)
  set set(OrderSet value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSet() => $_has(0);
  @$pb.TagNumber(1)
  void clearSet() => $_clearField(1);
  @$pb.TagNumber(1)
  OrderSet ensureSet() => $_ensure(0);
}

class ListOrderSetsRequest extends $pb.GeneratedMessage {
  factory ListOrderSetsRequest({
    $core.String? specialty,
    $core.bool? includeRetired,
    $core.int? pageSize,
  }) {
    final result = create();
    if (specialty != null) result.specialty = specialty;
    if (includeRetired != null) result.includeRetired = includeRetired;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOrderSetsRequest._();

  factory ListOrderSetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrderSetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrderSetsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'specialty')
    ..aOB(2, _omitFieldNames ? '' : 'includeRetired')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderSetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderSetsRequest copyWith(void Function(ListOrderSetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOrderSetsRequest))
          as ListOrderSetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrderSetsRequest create() => ListOrderSetsRequest._();
  @$core.override
  ListOrderSetsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrderSetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrderSetsRequest>(create);
  static ListOrderSetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get specialty => $_getSZ(0);
  @$pb.TagNumber(1)
  set specialty($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSpecialty() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpecialty() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeRetired => $_getBF(1);
  @$pb.TagNumber(2)
  set includeRetired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeRetired() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeRetired() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListOrderSetsResponse extends $pb.GeneratedMessage {
  factory ListOrderSetsResponse({
    $core.Iterable<OrderSet>? sets,
  }) {
    final result = create();
    if (sets != null) result.sets.addAll(sets);
    return result;
  }

  ListOrderSetsResponse._();

  factory ListOrderSetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrderSetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrderSetsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<OrderSet>(1, _omitFieldNames ? '' : 'sets',
        subBuilder: OrderSet.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderSetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderSetsResponse copyWith(
          void Function(ListOrderSetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListOrderSetsResponse))
          as ListOrderSetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrderSetsResponse create() => ListOrderSetsResponse._();
  @$core.override
  ListOrderSetsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrderSetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrderSetsResponse>(create);
  static ListOrderSetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<OrderSet> get sets => $_getList(0);
}

class RetireOrderSetRequest extends $pb.GeneratedMessage {
  factory RetireOrderSetRequest({
    $core.String? setId,
    $core.String? version,
  }) {
    final result = create();
    if (setId != null) result.setId = setId;
    if (version != null) result.version = version;
    return result;
  }

  RetireOrderSetRequest._();

  factory RetireOrderSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireOrderSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireOrderSetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireOrderSetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireOrderSetRequest copyWith(
          void Function(RetireOrderSetRequest) updates) =>
      super.copyWith((message) => updates(message as RetireOrderSetRequest))
          as RetireOrderSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireOrderSetRequest create() => RetireOrderSetRequest._();
  @$core.override
  RetireOrderSetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireOrderSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireOrderSetRequest>(create);
  static RetireOrderSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setId => $_getSZ(0);
  @$pb.TagNumber(1)
  set setId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class RetireOrderSetResponse extends $pb.GeneratedMessage {
  factory RetireOrderSetResponse() => create();

  RetireOrderSetResponse._();

  factory RetireOrderSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireOrderSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireOrderSetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireOrderSetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireOrderSetResponse copyWith(
          void Function(RetireOrderSetResponse) updates) =>
      super.copyWith((message) => updates(message as RetireOrderSetResponse))
          as RetireOrderSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireOrderSetResponse create() => RetireOrderSetResponse._();
  @$core.override
  RetireOrderSetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireOrderSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireOrderSetResponse>(create);
  static RetireOrderSetResponse? _defaultInstance;
}

/// What a clinician chose from a set.
class Selection extends $pb.GeneratedMessage {
  factory Selection({
    $core.String? componentId,
    $core.String? detail,
    $core.String? indication,
    Priority? priority,
    Timing? timing,
  }) {
    final result = create();
    if (componentId != null) result.componentId = componentId;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (priority != null) result.priority = priority;
    if (timing != null) result.timing = timing;
    return result;
  }

  Selection._();

  factory Selection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Selection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Selection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..aOS(3, _omitFieldNames ? '' : 'indication')
    ..aE<Priority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOM<Timing>(5, _omitFieldNames ? '' : 'timing', subBuilder: Timing.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Selection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Selection copyWith(void Function(Selection) updates) =>
      super.copyWith((message) => updates(message as Selection)) as Selection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Selection create() => Selection._();
  @$core.override
  Selection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Selection getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Selection>(create);
  static Selection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  /// Empty fields keep the set's suggestion.
  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get indication => $_getSZ(2);
  @$pb.TagNumber(3)
  set indication($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIndication() => $_has(2);
  @$pb.TagNumber(3)
  void clearIndication() => $_clearField(3);

  @$pb.TagNumber(4)
  Priority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(Priority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  Timing get timing => $_getN(4);
  @$pb.TagNumber(5)
  set timing(Timing value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTiming() => $_has(4);
  @$pb.TagNumber(5)
  void clearTiming() => $_clearField(5);
  @$pb.TagNumber(5)
  Timing ensureTiming() => $_ensure(4);
}

class PlaceFromOrderSetRequest extends $pb.GeneratedMessage {
  factory PlaceFromOrderSetRequest({
    $core.String? setId,
    $core.String? setVersion,
    $core.String? patientId,
    $core.String? encounterId,
    $core.Iterable<Selection>? selections,
    $core.String? acknowledgeDuplicates,
    $core.String? enteredById,
  }) {
    final result = create();
    if (setId != null) result.setId = setId;
    if (setVersion != null) result.setVersion = setVersion;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (selections != null) result.selections.addAll(selections);
    if (acknowledgeDuplicates != null)
      result.acknowledgeDuplicates = acknowledgeDuplicates;
    if (enteredById != null) result.enteredById = enteredById;
    return result;
  }

  PlaceFromOrderSetRequest._();

  factory PlaceFromOrderSetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceFromOrderSetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceFromOrderSetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'setId')
    ..aOS(2, _omitFieldNames ? '' : 'setVersion')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..pPM<Selection>(5, _omitFieldNames ? '' : 'selections',
        subBuilder: Selection.create)
    ..aOS(6, _omitFieldNames ? '' : 'acknowledgeDuplicates')
    ..aOS(7, _omitFieldNames ? '' : 'enteredById')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromOrderSetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromOrderSetRequest copyWith(
          void Function(PlaceFromOrderSetRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceFromOrderSetRequest))
          as PlaceFromOrderSetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceFromOrderSetRequest create() => PlaceFromOrderSetRequest._();
  @$core.override
  PlaceFromOrderSetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceFromOrderSetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceFromOrderSetRequest>(create);
  static PlaceFromOrderSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get setId => $_getSZ(0);
  @$pb.TagNumber(1)
  set setId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get setVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set setVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSetVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearSetVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get encounterId => $_getSZ(3);
  @$pb.TagNumber(4)
  set encounterId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEncounterId() => $_has(3);
  @$pb.TagNumber(4)
  void clearEncounterId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<Selection> get selections => $_getList(4);

  /// Answers the duplicate warning for every component at once. One reason for
  /// the basket: a clinician working through a fifteen-item admission set who
  /// had to justify each duplicate separately would stop reading the warnings.
  @$pb.TagNumber(6)
  $core.String get acknowledgeDuplicates => $_getSZ(5);
  @$pb.TagNumber(6)
  set acknowledgeDuplicates($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAcknowledgeDuplicates() => $_has(5);
  @$pb.TagNumber(6)
  void clearAcknowledgeDuplicates() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get enteredById => $_getSZ(6);
  @$pb.TagNumber(7)
  set enteredById($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEnteredById() => $_has(6);
  @$pb.TagNumber(7)
  void clearEnteredById() => $_clearField(7);
}

class PlaceFromOrderSetResponse extends $pb.GeneratedMessage {
  factory PlaceFromOrderSetResponse({
    $core.Iterable<Order>? placed,
    $core.Iterable<$core.MapEntry<$core.String, DuplicateWarning>>? warnings,
  }) {
    final result = create();
    if (placed != null) result.placed.addAll(placed);
    if (warnings != null) result.warnings.addEntries(warnings);
    return result;
  }

  PlaceFromOrderSetResponse._();

  factory PlaceFromOrderSetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceFromOrderSetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceFromOrderSetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<Order>(1, _omitFieldNames ? '' : 'placed', subBuilder: Order.create)
    ..m<$core.String, DuplicateWarning>(2, _omitFieldNames ? '' : 'warnings',
        entryClassName: 'PlaceFromOrderSetResponse.WarningsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: DuplicateWarning.create,
        valueDefaultOrMaker: DuplicateWarning.getDefault,
        packageName: const $pb.PackageName('healthcare.orders.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromOrderSetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromOrderSetResponse copyWith(
          void Function(PlaceFromOrderSetResponse) updates) =>
      super.copyWith((message) => updates(message as PlaceFromOrderSetResponse))
          as PlaceFromOrderSetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceFromOrderSetResponse create() => PlaceFromOrderSetResponse._();
  @$core.override
  PlaceFromOrderSetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceFromOrderSetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceFromOrderSetResponse>(create);
  static PlaceFromOrderSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Order> get placed => $_getList(0);

  /// The components that duplicate something live, keyed by code. Reported
  /// alongside what was placed, because a clinician needs to see which two of
  /// the fifteen need a decision — not have the whole basket refused.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, DuplicateWarning> get warnings => $_getMap(1);
}

/// One clinician's saved order (SRS-ORD-012).
///
/// Never shared: a shared shortcut with no review is an order set that escaped
/// governance. There is deliberately no owner field on the wire — a favourite is
/// always the caller's own.
class Favourite extends $pb.GeneratedMessage {
  factory Favourite({
    $core.String? favouriteId,
    $core.String? name,
    OrderType? type,
    Coding? code,
    $core.String? detail,
    $core.String? indication,
    Priority? priority,
    Timing? timing,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final result = create();
    if (favouriteId != null) result.favouriteId = favouriteId;
    if (name != null) result.name = name;
    if (type != null) result.type = type;
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (priority != null) result.priority = priority;
    if (timing != null) result.timing = timing;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Favourite._();

  factory Favourite.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Favourite.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Favourite',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'favouriteId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<OrderType>(3, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'detail')
    ..aOS(6, _omitFieldNames ? '' : 'indication')
    ..aE<Priority>(7, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOM<Timing>(8, _omitFieldNames ? '' : 'timing', subBuilder: Timing.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Favourite clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Favourite copyWith(void Function(Favourite) updates) =>
      super.copyWith((message) => updates(message as Favourite)) as Favourite;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Favourite create() => Favourite._();
  @$core.override
  Favourite createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Favourite getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Favourite>(create);
  static Favourite? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get favouriteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set favouriteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFavouriteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavouriteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  OrderType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(OrderType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get detail => $_getSZ(4);
  @$pb.TagNumber(5)
  set detail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDetail() => $_has(4);
  @$pb.TagNumber(5)
  void clearDetail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get indication => $_getSZ(5);
  @$pb.TagNumber(6)
  set indication($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIndication() => $_has(5);
  @$pb.TagNumber(6)
  void clearIndication() => $_clearField(6);

  @$pb.TagNumber(7)
  Priority get priority => $_getN(6);
  @$pb.TagNumber(7)
  set priority(Priority value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPriority() => $_has(6);
  @$pb.TagNumber(7)
  void clearPriority() => $_clearField(7);

  @$pb.TagNumber(8)
  Timing get timing => $_getN(7);
  @$pb.TagNumber(8)
  set timing(Timing value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTiming() => $_has(7);
  @$pb.TagNumber(8)
  void clearTiming() => $_clearField(8);
  @$pb.TagNumber(8)
  Timing ensureTiming() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureUpdatedAt() => $_ensure(9);
}

class SaveFavouriteRequest extends $pb.GeneratedMessage {
  factory SaveFavouriteRequest({
    Favourite? favourite,
  }) {
    final result = create();
    if (favourite != null) result.favourite = favourite;
    return result;
  }

  SaveFavouriteRequest._();

  factory SaveFavouriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveFavouriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveFavouriteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Favourite>(1, _omitFieldNames ? '' : 'favourite',
        subBuilder: Favourite.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveFavouriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveFavouriteRequest copyWith(void Function(SaveFavouriteRequest) updates) =>
      super.copyWith((message) => updates(message as SaveFavouriteRequest))
          as SaveFavouriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveFavouriteRequest create() => SaveFavouriteRequest._();
  @$core.override
  SaveFavouriteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveFavouriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveFavouriteRequest>(create);
  static SaveFavouriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Favourite get favourite => $_getN(0);
  @$pb.TagNumber(1)
  set favourite(Favourite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFavourite() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavourite() => $_clearField(1);
  @$pb.TagNumber(1)
  Favourite ensureFavourite() => $_ensure(0);
}

class SaveFavouriteResponse extends $pb.GeneratedMessage {
  factory SaveFavouriteResponse({
    Favourite? favourite,
  }) {
    final result = create();
    if (favourite != null) result.favourite = favourite;
    return result;
  }

  SaveFavouriteResponse._();

  factory SaveFavouriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SaveFavouriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SaveFavouriteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Favourite>(1, _omitFieldNames ? '' : 'favourite',
        subBuilder: Favourite.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveFavouriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SaveFavouriteResponse copyWith(
          void Function(SaveFavouriteResponse) updates) =>
      super.copyWith((message) => updates(message as SaveFavouriteResponse))
          as SaveFavouriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveFavouriteResponse create() => SaveFavouriteResponse._();
  @$core.override
  SaveFavouriteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SaveFavouriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SaveFavouriteResponse>(create);
  static SaveFavouriteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Favourite get favourite => $_getN(0);
  @$pb.TagNumber(1)
  set favourite(Favourite value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFavourite() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavourite() => $_clearField(1);
  @$pb.TagNumber(1)
  Favourite ensureFavourite() => $_ensure(0);
}

class ListFavouritesRequest extends $pb.GeneratedMessage {
  factory ListFavouritesRequest({
    OrderType? type,
    $core.int? pageSize,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListFavouritesRequest._();

  factory ListFavouritesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFavouritesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFavouritesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aE<OrderType>(1, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavouritesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavouritesRequest copyWith(
          void Function(ListFavouritesRequest) updates) =>
      super.copyWith((message) => updates(message as ListFavouritesRequest))
          as ListFavouritesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFavouritesRequest create() => ListFavouritesRequest._();
  @$core.override
  ListFavouritesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFavouritesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFavouritesRequest>(create);
  static ListFavouritesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrderType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(OrderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListFavouritesResponse extends $pb.GeneratedMessage {
  factory ListFavouritesResponse({
    $core.Iterable<Favourite>? favourites,
  }) {
    final result = create();
    if (favourites != null) result.favourites.addAll(favourites);
    return result;
  }

  ListFavouritesResponse._();

  factory ListFavouritesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFavouritesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFavouritesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..pPM<Favourite>(1, _omitFieldNames ? '' : 'favourites',
        subBuilder: Favourite.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavouritesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFavouritesResponse copyWith(
          void Function(ListFavouritesResponse) updates) =>
      super.copyWith((message) => updates(message as ListFavouritesResponse))
          as ListFavouritesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFavouritesResponse create() => ListFavouritesResponse._();
  @$core.override
  ListFavouritesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFavouritesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFavouritesResponse>(create);
  static ListFavouritesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Favourite> get favourites => $_getList(0);
}

class DeleteFavouriteRequest extends $pb.GeneratedMessage {
  factory DeleteFavouriteRequest({
    $core.String? favouriteId,
  }) {
    final result = create();
    if (favouriteId != null) result.favouriteId = favouriteId;
    return result;
  }

  DeleteFavouriteRequest._();

  factory DeleteFavouriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFavouriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFavouriteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'favouriteId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteRequest copyWith(
          void Function(DeleteFavouriteRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteFavouriteRequest))
          as DeleteFavouriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteRequest create() => DeleteFavouriteRequest._();
  @$core.override
  DeleteFavouriteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFavouriteRequest>(create);
  static DeleteFavouriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get favouriteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set favouriteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFavouriteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavouriteId() => $_clearField(1);
}

class DeleteFavouriteResponse extends $pb.GeneratedMessage {
  factory DeleteFavouriteResponse() => create();

  DeleteFavouriteResponse._();

  factory DeleteFavouriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFavouriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFavouriteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteResponse copyWith(
          void Function(DeleteFavouriteResponse) updates) =>
      super.copyWith((message) => updates(message as DeleteFavouriteResponse))
          as DeleteFavouriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteResponse create() => DeleteFavouriteResponse._();
  @$core.override
  DeleteFavouriteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFavouriteResponse>(create);
  static DeleteFavouriteResponse? _defaultInstance;
}

/// Applies a favourite and places the order. The favourite supplies values and
/// the policy still applies, so a shortcut saved before the tenant made
/// indications mandatory is refused rather than quietly placed (SRS-ORD-012).
class PlaceFromFavouriteRequest extends $pb.GeneratedMessage {
  factory PlaceFromFavouriteRequest({
    $core.String? favouriteId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? detail,
    $core.String? indication,
    Priority? priority,
    $core.String? acknowledgeDuplicates,
    $core.String? enteredById,
  }) {
    final result = create();
    if (favouriteId != null) result.favouriteId = favouriteId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (detail != null) result.detail = detail;
    if (indication != null) result.indication = indication;
    if (priority != null) result.priority = priority;
    if (acknowledgeDuplicates != null)
      result.acknowledgeDuplicates = acknowledgeDuplicates;
    if (enteredById != null) result.enteredById = enteredById;
    return result;
  }

  PlaceFromFavouriteRequest._();

  factory PlaceFromFavouriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceFromFavouriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceFromFavouriteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'favouriteId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'detail')
    ..aOS(5, _omitFieldNames ? '' : 'indication')
    ..aE<Priority>(6, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(7, _omitFieldNames ? '' : 'acknowledgeDuplicates')
    ..aOS(8, _omitFieldNames ? '' : 'enteredById')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromFavouriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromFavouriteRequest copyWith(
          void Function(PlaceFromFavouriteRequest) updates) =>
      super.copyWith((message) => updates(message as PlaceFromFavouriteRequest))
          as PlaceFromFavouriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceFromFavouriteRequest create() => PlaceFromFavouriteRequest._();
  @$core.override
  PlaceFromFavouriteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceFromFavouriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceFromFavouriteRequest>(create);
  static PlaceFromFavouriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get favouriteId => $_getSZ(0);
  @$pb.TagNumber(1)
  set favouriteId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFavouriteId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFavouriteId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get encounterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set encounterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEncounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEncounterId() => $_clearField(3);

  /// The caller may still override what the favourite suggests.
  @$pb.TagNumber(4)
  $core.String get detail => $_getSZ(3);
  @$pb.TagNumber(4)
  set detail($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDetail() => $_has(3);
  @$pb.TagNumber(4)
  void clearDetail() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get indication => $_getSZ(4);
  @$pb.TagNumber(5)
  set indication($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIndication() => $_has(4);
  @$pb.TagNumber(5)
  void clearIndication() => $_clearField(5);

  @$pb.TagNumber(6)
  Priority get priority => $_getN(5);
  @$pb.TagNumber(6)
  set priority(Priority value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPriority() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriority() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get acknowledgeDuplicates => $_getSZ(6);
  @$pb.TagNumber(7)
  set acknowledgeDuplicates($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAcknowledgeDuplicates() => $_has(6);
  @$pb.TagNumber(7)
  void clearAcknowledgeDuplicates() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get enteredById => $_getSZ(7);
  @$pb.TagNumber(8)
  set enteredById($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEnteredById() => $_has(7);
  @$pb.TagNumber(8)
  void clearEnteredById() => $_clearField(8);
}

class PlaceFromFavouriteResponse extends $pb.GeneratedMessage {
  factory PlaceFromFavouriteResponse({
    Order? order,
    DuplicateWarning? warning,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (warning != null) result.warning = warning;
    return result;
  }

  PlaceFromFavouriteResponse._();

  factory PlaceFromFavouriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlaceFromFavouriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlaceFromFavouriteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aOM<Order>(1, _omitFieldNames ? '' : 'order', subBuilder: Order.create)
    ..aOM<DuplicateWarning>(2, _omitFieldNames ? '' : 'warning',
        subBuilder: DuplicateWarning.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromFavouriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlaceFromFavouriteResponse copyWith(
          void Function(PlaceFromFavouriteResponse) updates) =>
      super.copyWith(
              (message) => updates(message as PlaceFromFavouriteResponse))
          as PlaceFromFavouriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceFromFavouriteResponse create() => PlaceFromFavouriteResponse._();
  @$core.override
  PlaceFromFavouriteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlaceFromFavouriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlaceFromFavouriteResponse>(create);
  static PlaceFromFavouriteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Order get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(Order value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  Order ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  DuplicateWarning get warning => $_getN(1);
  @$pb.TagNumber(2)
  set warning(DuplicateWarning value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWarning() => $_has(1);
  @$pb.TagNumber(2)
  void clearWarning() => $_clearField(2);
  @$pb.TagNumber(2)
  DuplicateWarning ensureWarning() => $_ensure(1);
}

/// What a tenant requires before an order of this type may be placed
/// (SRS-ORD-002, SRS-ORD-007).
class SetOrderPolicyRequest extends $pb.GeneratedMessage {
  factory SetOrderPolicyRequest({
    OrderType? type,
    $core.bool? indicationRequired,
    $core.bool? structuredTimingRequired,
    $core.String? requiredPrivilege,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (indicationRequired != null)
      result.indicationRequired = indicationRequired;
    if (structuredTimingRequired != null)
      result.structuredTimingRequired = structuredTimingRequired;
    if (requiredPrivilege != null) result.requiredPrivilege = requiredPrivilege;
    return result;
  }

  SetOrderPolicyRequest._();

  factory SetOrderPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetOrderPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetOrderPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aE<OrderType>(1, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aOB(2, _omitFieldNames ? '' : 'indicationRequired')
    ..aOB(3, _omitFieldNames ? '' : 'structuredTimingRequired')
    ..aOS(4, _omitFieldNames ? '' : 'requiredPrivilege')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOrderPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOrderPolicyRequest copyWith(
          void Function(SetOrderPolicyRequest) updates) =>
      super.copyWith((message) => updates(message as SetOrderPolicyRequest))
          as SetOrderPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetOrderPolicyRequest create() => SetOrderPolicyRequest._();
  @$core.override
  SetOrderPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetOrderPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetOrderPolicyRequest>(create);
  static SetOrderPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrderType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(OrderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// Per type, because the answer genuinely differs: an indication for a CT scan
  /// justifies a radiation dose a national body audits, and one for a diet order
  /// is a field nobody fills in honestly once it is mandatory.
  @$pb.TagNumber(2)
  $core.bool get indicationRequired => $_getBF(1);
  @$pb.TagNumber(2)
  set indicationRequired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIndicationRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearIndicationRequired() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get structuredTimingRequired => $_getBF(2);
  @$pb.TagNumber(3)
  set structuredTimingRequired($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStructuredTimingRequired() => $_has(2);
  @$pb.TagNumber(3)
  void clearStructuredTimingRequired() => $_clearField(3);

  /// The privilege a requester needs, or empty for none.
  @$pb.TagNumber(4)
  $core.String get requiredPrivilege => $_getSZ(3);
  @$pb.TagNumber(4)
  set requiredPrivilege($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiredPrivilege() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiredPrivilege() => $_clearField(4);
}

class SetOrderPolicyResponse extends $pb.GeneratedMessage {
  factory SetOrderPolicyResponse() => create();

  SetOrderPolicyResponse._();

  factory SetOrderPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetOrderPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetOrderPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOrderPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetOrderPolicyResponse copyWith(
          void Function(SetOrderPolicyResponse) updates) =>
      super.copyWith((message) => updates(message as SetOrderPolicyResponse))
          as SetOrderPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetOrderPolicyResponse create() => SetOrderPolicyResponse._();
  @$core.override
  SetOrderPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetOrderPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetOrderPolicyResponse>(create);
  static SetOrderPolicyResponse? _defaultInstance;
}

/// How a tenant decides two orders are the same (SRS-ORD-009).
class SetDuplicateRuleRequest extends $pb.GeneratedMessage {
  factory SetDuplicateRuleRequest({
    OrderType? type,
    $fixnum.Int64? withinSeconds,
    $core.bool? sameCodeOnly,
    $core.bool? overridable,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (withinSeconds != null) result.withinSeconds = withinSeconds;
    if (sameCodeOnly != null) result.sameCodeOnly = sameCodeOnly;
    if (overridable != null) result.overridable = overridable;
    return result;
  }

  SetDuplicateRuleRequest._();

  factory SetDuplicateRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetDuplicateRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDuplicateRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..aE<OrderType>(1, _omitFieldNames ? '' : 'type',
        enumValues: OrderType.values)
    ..aInt64(2, _omitFieldNames ? '' : 'withinSeconds')
    ..aOB(3, _omitFieldNames ? '' : 'sameCodeOnly')
    ..aOB(4, _omitFieldNames ? '' : 'overridable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDuplicateRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDuplicateRuleRequest copyWith(
          void Function(SetDuplicateRuleRequest) updates) =>
      super.copyWith((message) => updates(message as SetDuplicateRuleRequest))
          as SetDuplicateRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetDuplicateRuleRequest create() => SetDuplicateRuleRequest._();
  @$core.override
  SetDuplicateRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetDuplicateRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDuplicateRuleRequest>(create);
  static SetDuplicateRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  OrderType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(OrderType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  /// Zero disables the check for this type.
  @$pb.TagNumber(2)
  $fixnum.Int64 get withinSeconds => $_getI64(1);
  @$pb.TagNumber(2)
  set withinSeconds($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWithinSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearWithinSeconds() => $_clearField(2);

  /// Off means any order of this type in the window counts, which is right for a
  /// diet order — a patient has one diet — and wrong for a laboratory order.
  @$pb.TagNumber(3)
  $core.bool get sameCodeOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set sameCodeOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSameCodeOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearSameCodeOnly() => $_clearField(3);

  /// False refuses outright. Note that the requirement says the system shows a
  /// warning "rather than arbitrary suppression", so a tenant setting this to
  /// false is choosing a stricter policy than the requirement describes.
  @$pb.TagNumber(4)
  $core.bool get overridable => $_getBF(3);
  @$pb.TagNumber(4)
  set overridable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverridable() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverridable() => $_clearField(4);
}

class SetDuplicateRuleResponse extends $pb.GeneratedMessage {
  factory SetDuplicateRuleResponse() => create();

  SetDuplicateRuleResponse._();

  factory SetDuplicateRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetDuplicateRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetDuplicateRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.orders.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDuplicateRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetDuplicateRuleResponse copyWith(
          void Function(SetDuplicateRuleResponse) updates) =>
      super.copyWith((message) => updates(message as SetDuplicateRuleResponse))
          as SetDuplicateRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetDuplicateRuleResponse create() => SetDuplicateRuleResponse._();
  @$core.override
  SetDuplicateRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetDuplicateRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDuplicateRuleResponse>(create);
  static SetDuplicateRuleResponse? _defaultInstance;
}

class OrderServiceApi {
  final $pb.RpcClient _client;

  OrderServiceApi(this._client);

  /// Placing and reading (SRS-ORD-001, SRS-ORD-002, SRS-ORD-009).
  $async.Future<PlaceOrderResponse> placeOrder(
          $pb.ClientContext? ctx, PlaceOrderRequest request) =>
      _client.invoke<PlaceOrderResponse>(
          ctx, 'OrderService', 'PlaceOrder', request, PlaceOrderResponse());
  $async.Future<GetOrderResponse> getOrder(
          $pb.ClientContext? ctx, GetOrderRequest request) =>
      _client.invoke<GetOrderResponse>(
          ctx, 'OrderService', 'GetOrder', request, GetOrderResponse());
  $async.Future<ListOrdersResponse> listOrders(
          $pb.ClientContext? ctx, ListOrdersRequest request) =>
      _client.invoke<ListOrdersResponse>(
          ctx, 'OrderService', 'ListOrders', request, ListOrdersResponse());
  $async.Future<GetWorklistResponse> getWorklist(
          $pb.ClientContext? ctx, GetWorklistRequest request) =>
      _client.invoke<GetWorklistResponse>(
          ctx, 'OrderService', 'GetWorklist', request, GetWorklistResponse());

  /// Stopping (SRS-ORD-004, SRS-ORD-005).
  $async.Future<CancelOrderResponse> cancelOrder(
          $pb.ClientContext? ctx, CancelOrderRequest request) =>
      _client.invoke<CancelOrderResponse>(
          ctx, 'OrderService', 'CancelOrder', request, CancelOrderResponse());
  $async.Future<RetractOrderResponse> retractOrder(
          $pb.ClientContext? ctx, RetractOrderRequest request) =>
      _client.invoke<RetractOrderResponse>(
          ctx, 'OrderService', 'RetractOrder', request, RetractOrderResponse());

  /// The performing service's side (SRS-ORD-006).
  $async.Future<AcknowledgeOrderResponse> acknowledgeOrder(
          $pb.ClientContext? ctx, AcknowledgeOrderRequest request) =>
      _client.invoke<AcknowledgeOrderResponse>(ctx, 'OrderService',
          'AcknowledgeOrder', request, AcknowledgeOrderResponse());

  /// Order sets (SRS-ORD-003).
  $async.Future<DefineOrderSetResponse> defineOrderSet(
          $pb.ClientContext? ctx, DefineOrderSetRequest request) =>
      _client.invoke<DefineOrderSetResponse>(ctx, 'OrderService',
          'DefineOrderSet', request, DefineOrderSetResponse());
  $async.Future<ListOrderSetsResponse> listOrderSets(
          $pb.ClientContext? ctx, ListOrderSetsRequest request) =>
      _client.invoke<ListOrderSetsResponse>(ctx, 'OrderService',
          'ListOrderSets', request, ListOrderSetsResponse());
  $async.Future<RetireOrderSetResponse> retireOrderSet(
          $pb.ClientContext? ctx, RetireOrderSetRequest request) =>
      _client.invoke<RetireOrderSetResponse>(ctx, 'OrderService',
          'RetireOrderSet', request, RetireOrderSetResponse());
  $async.Future<PlaceFromOrderSetResponse> placeFromOrderSet(
          $pb.ClientContext? ctx, PlaceFromOrderSetRequest request) =>
      _client.invoke<PlaceFromOrderSetResponse>(ctx, 'OrderService',
          'PlaceFromOrderSet', request, PlaceFromOrderSetResponse());

  /// Favourites (SRS-ORD-012).
  $async.Future<SaveFavouriteResponse> saveFavourite(
          $pb.ClientContext? ctx, SaveFavouriteRequest request) =>
      _client.invoke<SaveFavouriteResponse>(ctx, 'OrderService',
          'SaveFavourite', request, SaveFavouriteResponse());
  $async.Future<ListFavouritesResponse> listFavourites(
          $pb.ClientContext? ctx, ListFavouritesRequest request) =>
      _client.invoke<ListFavouritesResponse>(ctx, 'OrderService',
          'ListFavourites', request, ListFavouritesResponse());
  $async.Future<DeleteFavouriteResponse> deleteFavourite(
          $pb.ClientContext? ctx, DeleteFavouriteRequest request) =>
      _client.invoke<DeleteFavouriteResponse>(ctx, 'OrderService',
          'DeleteFavourite', request, DeleteFavouriteResponse());
  $async.Future<PlaceFromFavouriteResponse> placeFromFavourite(
          $pb.ClientContext? ctx, PlaceFromFavouriteRequest request) =>
      _client.invoke<PlaceFromFavouriteResponse>(ctx, 'OrderService',
          'PlaceFromFavourite', request, PlaceFromFavouriteResponse());

  /// Configuration (SRS-ORD-002, SRS-ORD-007, SRS-ORD-009).
  $async.Future<SetOrderPolicyResponse> setOrderPolicy(
          $pb.ClientContext? ctx, SetOrderPolicyRequest request) =>
      _client.invoke<SetOrderPolicyResponse>(ctx, 'OrderService',
          'SetOrderPolicy', request, SetOrderPolicyResponse());
  $async.Future<SetDuplicateRuleResponse> setDuplicateRule(
          $pb.ClientContext? ctx, SetDuplicateRuleRequest request) =>
      _client.invoke<SetDuplicateRuleResponse>(ctx, 'OrderService',
          'SetDuplicateRule', request, SetDuplicateRuleResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
