// This is a generated file - do not edit.
//
// Generated from healthcare/scheduling/v1/appointment.proto.

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

import 'appointment.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'appointment.pbenum.dart';

class Resource extends $pb.GeneratedMessage {
  factory Resource({
    $core.String? resourceId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    ResourceType? type,
    $core.String? subjectId,
    $core.String? displayName,
    ResourceStatus? status,
    $core.String? timeZone,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (type != null) result.type = type;
    if (subjectId != null) result.subjectId = subjectId;
    if (displayName != null) result.displayName = displayName;
    if (status != null) result.status = status;
    if (timeZone != null) result.timeZone = timeZone;
    return result;
  }

  Resource._();

  factory Resource.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Resource.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Resource',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<ResourceType>(4, _omitFieldNames ? '' : 'type',
        enumValues: ResourceType.values)
    ..aOS(5, _omitFieldNames ? '' : 'subjectId')
    ..aOS(6, _omitFieldNames ? '' : 'displayName')
    ..aE<ResourceStatus>(7, _omitFieldNames ? '' : 'status',
        enumValues: ResourceStatus.values)
    ..aOS(8, _omitFieldNames ? '' : 'timeZone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resource clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Resource copyWith(void Function(Resource) updates) =>
      super.copyWith((message) => updates(message as Resource)) as Resource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Resource create() => Resource._();
  @$core.override
  Resource createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Resource getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resource>(create);
  static Resource? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  /// The department or specialty, for the "search by specialty" half of
  /// SRS-SCH-003 — how a patient books without knowing a clinician's name.
  @$pb.TagNumber(3)
  $core.String get orgUnitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orgUnitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrgUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrgUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  ResourceType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(ResourceType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => $_clearField(4);

  /// The identity a practitioner's diary belongs to. Empty for a room or a
  /// machine, which are nobody.
  @$pb.TagNumber(5)
  $core.String get subjectId => $_getSZ(4);
  @$pb.TagNumber(5)
  set subjectId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSubjectId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSubjectId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get displayName => $_getSZ(5);
  @$pb.TagNumber(6)
  set displayName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDisplayName() => $_has(5);
  @$pb.TagNumber(6)
  void clearDisplayName() => $_clearField(6);

  @$pb.TagNumber(7)
  ResourceStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(ResourceStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get timeZone => $_getSZ(7);
  @$pb.TagNumber(8)
  set timeZone($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTimeZone() => $_has(7);
  @$pb.TagNumber(8)
  void clearTimeZone() => $_clearField(8);
}

class Schedule extends $pb.GeneratedMessage {
  factory Schedule({
    $core.String? scheduleId,
    $core.String? resourceId,
    $core.String? facilityId,
    VisitType? visitType,
    VisitMode? visitMode,
    $core.int? weekday,
    $core.int? startMinute,
    $core.int? endMinute,
    $core.int? slotMinutes,
    $core.int? capacity,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (scheduleId != null) result.scheduleId = scheduleId;
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (visitType != null) result.visitType = visitType;
    if (visitMode != null) result.visitMode = visitMode;
    if (weekday != null) result.weekday = weekday;
    if (startMinute != null) result.startMinute = startMinute;
    if (endMinute != null) result.endMinute = endMinute;
    if (slotMinutes != null) result.slotMinutes = slotMinutes;
    if (capacity != null) result.capacity = capacity;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  Schedule._();

  factory Schedule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Schedule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Schedule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scheduleId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aE<VisitMode>(5, _omitFieldNames ? '' : 'visitMode',
        enumValues: VisitMode.values)
    ..aI(6, _omitFieldNames ? '' : 'weekday')
    ..aI(7, _omitFieldNames ? '' : 'startMinute')
    ..aI(8, _omitFieldNames ? '' : 'endMinute')
    ..aI(9, _omitFieldNames ? '' : 'slotMinutes')
    ..aI(10, _omitFieldNames ? '' : 'capacity')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Schedule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Schedule copyWith(void Function(Schedule) updates) =>
      super.copyWith((message) => updates(message as Schedule)) as Schedule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Schedule create() => Schedule._();
  @$core.override
  Schedule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Schedule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Schedule>(create);
  static Schedule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scheduleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scheduleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScheduleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScheduleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  @$pb.TagNumber(5)
  VisitMode get visitMode => $_getN(4);
  @$pb.TagNumber(5)
  set visitMode(VisitMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitMode() => $_clearField(5);

  /// 0 is Sunday, matching Go and ISO's weekday-name ordering.
  @$pb.TagNumber(6)
  $core.int get weekday => $_getIZ(5);
  @$pb.TagNumber(6)
  set weekday($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWeekday() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeekday() => $_clearField(6);

  /// Minutes from local midnight. Minutes rather than a time, because a rule has
  /// no date and a zero date carrying a time reads as year 1 in every log.
  @$pb.TagNumber(7)
  $core.int get startMinute => $_getIZ(6);
  @$pb.TagNumber(7)
  set startMinute($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasStartMinute() => $_has(6);
  @$pb.TagNumber(7)
  void clearStartMinute() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get endMinute => $_getIZ(7);
  @$pb.TagNumber(8)
  set endMinute($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEndMinute() => $_has(7);
  @$pb.TagNumber(8)
  void clearEndMinute() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get slotMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set slotMinutes($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSlotMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearSlotMinutes() => $_clearField(9);

  /// How many patients one slot holds. More than one is a group clinic or a
  /// double-booked follow-up list, both of which are real.
  @$pb.TagNumber(10)
  $core.int get capacity => $_getIZ(9);
  @$pb.TagNumber(10)
  set capacity($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCapacity() => $_has(9);
  @$pb.TagNumber(10)
  void clearCapacity() => $_clearField(10);

  /// Local dates; until is exclusive and unset means open-ended.
  @$pb.TagNumber(11)
  $0.Timestamp get effectiveFrom => $_getN(10);
  @$pb.TagNumber(11)
  set effectiveFrom($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasEffectiveFrom() => $_has(10);
  @$pb.TagNumber(11)
  void clearEffectiveFrom() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get effectiveUntil => $_getN(11);
  @$pb.TagNumber(12)
  set effectiveUntil($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasEffectiveUntil() => $_has(11);
  @$pb.TagNumber(12)
  void clearEffectiveUntil() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(11);
}

class ScheduleException extends $pb.GeneratedMessage {
  factory ScheduleException({
    $core.String? exceptionId,
    $core.String? resourceId,
    ExceptionKind? kind,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.String? reason,
    $core.bool? overridable,
    $core.String? createdBy,
  }) {
    final result = create();
    if (exceptionId != null) result.exceptionId = exceptionId;
    if (resourceId != null) result.resourceId = resourceId;
    if (kind != null) result.kind = kind;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (reason != null) result.reason = reason;
    if (overridable != null) result.overridable = overridable;
    if (createdBy != null) result.createdBy = createdBy;
    return result;
  }

  ScheduleException._();

  factory ScheduleException.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScheduleException.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScheduleException',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exceptionId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aE<ExceptionKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ExceptionKind.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOB(7, _omitFieldNames ? '' : 'overridable')
    ..aOS(8, _omitFieldNames ? '' : 'createdBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleException clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScheduleException copyWith(void Function(ScheduleException) updates) =>
      super.copyWith((message) => updates(message as ScheduleException))
          as ScheduleException;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScheduleException create() => ScheduleException._();
  @$core.override
  ScheduleException createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScheduleException getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScheduleException>(create);
  static ScheduleException? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exceptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exceptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExceptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExceptionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  ExceptionKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ExceptionKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get startsAt => $_getN(3);
  @$pb.TagNumber(4)
  set startsAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStartsAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartsAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureStartsAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get endsAt => $_getN(4);
  @$pb.TagNumber(5)
  set endsAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEndsAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearEndsAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureEndsAt() => $_ensure(4);

  /// What a colleague reads when deciding whether to ask for an override.
  /// "Blocked" with no reason gets overridden by default.
  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  /// Annual leave is not overridable; a provisional theatre block often is.
  @$pb.TagNumber(7)
  $core.bool get overridable => $_getBF(6);
  @$pb.TagNumber(7)
  set overridable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverridable() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverridable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get createdBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set createdBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedBy() => $_clearField(8);
}

/// One bookable period. Generated from the roster on every search rather than
/// stored, so the result reflects the roster as it is now.
class Slot extends $pb.GeneratedMessage {
  factory Slot({
    $core.String? resourceId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    VisitType? visitType,
    VisitMode? visitMode,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.int? capacity,
    $core.int? booked,
    $core.int? remaining,
    $core.bool? blocked,
    $core.String? blockedReason,
    ExceptionKind? blockedKind,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (visitType != null) result.visitType = visitType;
    if (visitMode != null) result.visitMode = visitMode;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (capacity != null) result.capacity = capacity;
    if (booked != null) result.booked = booked;
    if (remaining != null) result.remaining = remaining;
    if (blocked != null) result.blocked = blocked;
    if (blockedReason != null) result.blockedReason = blockedReason;
    if (blockedKind != null) result.blockedKind = blockedKind;
    return result;
  }

  Slot._();

  factory Slot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Slot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Slot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aE<VisitMode>(5, _omitFieldNames ? '' : 'visitMode',
        enumValues: VisitMode.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'capacity')
    ..aI(9, _omitFieldNames ? '' : 'booked')
    ..aI(10, _omitFieldNames ? '' : 'remaining')
    ..aOB(11, _omitFieldNames ? '' : 'blocked')
    ..aOS(12, _omitFieldNames ? '' : 'blockedReason')
    ..aE<ExceptionKind>(13, _omitFieldNames ? '' : 'blockedKind',
        enumValues: ExceptionKind.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Slot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Slot copyWith(void Function(Slot) updates) =>
      super.copyWith((message) => updates(message as Slot)) as Slot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Slot create() => Slot._();
  @$core.override
  Slot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Slot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Slot>(create);
  static Slot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orgUnitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orgUnitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrgUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrgUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  @$pb.TagNumber(5)
  VisitMode get visitMode => $_getN(4);
  @$pb.TagNumber(5)
  set visitMode(VisitMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitMode() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get startsAt => $_getN(5);
  @$pb.TagNumber(6)
  set startsAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartsAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartsAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartsAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get endsAt => $_getN(6);
  @$pb.TagNumber(7)
  set endsAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEndsAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndsAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEndsAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get capacity => $_getIZ(7);
  @$pb.TagNumber(8)
  set capacity($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCapacity() => $_has(7);
  @$pb.TagNumber(8)
  void clearCapacity() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get booked => $_getIZ(8);
  @$pb.TagNumber(9)
  set booked($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBooked() => $_has(8);
  @$pb.TagNumber(9)
  void clearBooked() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get remaining => $_getIZ(9);
  @$pb.TagNumber(10)
  set remaining($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRemaining() => $_has(9);
  @$pb.TagNumber(10)
  void clearRemaining() => $_clearField(10);

  /// Present only for a caller holding the override permission, and only where
  /// the block permits an override at all. A scheduler needs to see what they
  /// are booking into and why it was blocked.
  @$pb.TagNumber(11)
  $core.bool get blocked => $_getBF(10);
  @$pb.TagNumber(11)
  set blocked($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBlocked() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlocked() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get blockedReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set blockedReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasBlockedReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearBlockedReason() => $_clearField(12);

  @$pb.TagNumber(13)
  ExceptionKind get blockedKind => $_getN(12);
  @$pb.TagNumber(13)
  set blockedKind(ExceptionKind value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasBlockedKind() => $_has(12);
  @$pb.TagNumber(13)
  void clearBlockedKind() => $_clearField(13);
}

class StatusChange extends $pb.GeneratedMessage {
  factory StatusChange({
    AppointmentStatus? from,
    AppointmentStatus? to,
    $0.Timestamp? at,
    $core.String? by,
    $core.String? reason,
    $core.bool? corrected,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (at != null) result.at = at;
    if (by != null) result.by = by;
    if (reason != null) result.reason = reason;
    if (corrected != null) result.corrected = corrected;
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
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aE<AppointmentStatus>(1, _omitFieldNames ? '' : 'from',
        enumValues: AppointmentStatus.values)
    ..aE<AppointmentStatus>(2, _omitFieldNames ? '' : 'to',
        enumValues: AppointmentStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'by')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'corrected')
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
  AppointmentStatus get from => $_getN(0);
  @$pb.TagNumber(1)
  set from(AppointmentStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  AppointmentStatus get to => $_getN(1);
  @$pb.TagNumber(2)
  set to(AppointmentStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get at => $_getN(2);
  @$pb.TagNumber(3)
  set at($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureAt() => $_ensure(2);

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

  /// A transition the machine would otherwise refuse, made under the "unless
  /// authorized correction" clause of SRS-SCH-008.
  @$pb.TagNumber(6)
  $core.bool get corrected => $_getBF(5);
  @$pb.TagNumber(6)
  set corrected($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCorrected() => $_has(5);
  @$pb.TagNumber(6)
  void clearCorrected() => $_clearField(6);
}

class Appointment extends $pb.GeneratedMessage {
  factory Appointment({
    $core.String? appointmentId,
    $core.String? facilityId,
    $core.String? resourceId,
    $core.String? orgUnitId,
    $core.String? patientId,
    VisitType? visitType,
    VisitMode? visitMode,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    AppointmentStatus? status,
    $core.String? bookedBy,
    $core.String? reason,
    $core.Iterable<StatusChange>? history,
    $core.String? rescheduledFromId,
    $fixnum.Int64? version,
    $core.String? seriesId,
    $core.int? occurrence,
    $core.int? rescheduleCount,
    $core.String? joinUrl,
    $core.String? token,
    ArrivalMode? arrivalMode,
    $0.Timestamp? checkedInAt,
    Priority? priority,
    $core.String? priorityReason,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (facilityId != null) result.facilityId = facilityId;
    if (resourceId != null) result.resourceId = resourceId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (patientId != null) result.patientId = patientId;
    if (visitType != null) result.visitType = visitType;
    if (visitMode != null) result.visitMode = visitMode;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (status != null) result.status = status;
    if (bookedBy != null) result.bookedBy = bookedBy;
    if (reason != null) result.reason = reason;
    if (history != null) result.history.addAll(history);
    if (rescheduledFromId != null) result.rescheduledFromId = rescheduledFromId;
    if (version != null) result.version = version;
    if (seriesId != null) result.seriesId = seriesId;
    if (occurrence != null) result.occurrence = occurrence;
    if (rescheduleCount != null) result.rescheduleCount = rescheduleCount;
    if (joinUrl != null) result.joinUrl = joinUrl;
    if (token != null) result.token = token;
    if (arrivalMode != null) result.arrivalMode = arrivalMode;
    if (checkedInAt != null) result.checkedInAt = checkedInAt;
    if (priority != null) result.priority = priority;
    if (priorityReason != null) result.priorityReason = priorityReason;
    return result;
  }

  Appointment._();

  factory Appointment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Appointment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Appointment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'resourceId')
    ..aOS(4, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(5, _omitFieldNames ? '' : 'patientId')
    ..aE<VisitType>(6, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aE<VisitMode>(7, _omitFieldNames ? '' : 'visitMode',
        enumValues: VisitMode.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aE<AppointmentStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: AppointmentStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'bookedBy')
    ..aOS(12, _omitFieldNames ? '' : 'reason')
    ..pPM<StatusChange>(13, _omitFieldNames ? '' : 'history',
        subBuilder: StatusChange.create)
    ..aOS(14, _omitFieldNames ? '' : 'rescheduledFromId')
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..aOS(16, _omitFieldNames ? '' : 'seriesId')
    ..aI(17, _omitFieldNames ? '' : 'occurrence')
    ..aI(18, _omitFieldNames ? '' : 'rescheduleCount')
    ..aOS(19, _omitFieldNames ? '' : 'joinUrl')
    ..aOS(20, _omitFieldNames ? '' : 'token')
    ..aE<ArrivalMode>(21, _omitFieldNames ? '' : 'arrivalMode',
        enumValues: ArrivalMode.values)
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'checkedInAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Priority>(23, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(24, _omitFieldNames ? '' : 'priorityReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Appointment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Appointment copyWith(void Function(Appointment) updates) =>
      super.copyWith((message) => updates(message as Appointment))
          as Appointment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Appointment create() => Appointment._();
  @$core.override
  Appointment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Appointment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Appointment>(create);
  static Appointment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resourceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resourceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResourceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResourceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orgUnitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orgUnitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrgUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrgUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get patientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set patientId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPatientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPatientId() => $_clearField(5);

  @$pb.TagNumber(6)
  VisitType get visitType => $_getN(5);
  @$pb.TagNumber(6)
  set visitType(VisitType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVisitType() => $_has(5);
  @$pb.TagNumber(6)
  void clearVisitType() => $_clearField(6);

  @$pb.TagNumber(7)
  VisitMode get visitMode => $_getN(6);
  @$pb.TagNumber(7)
  set visitMode(VisitMode value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasVisitMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearVisitMode() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get startsAt => $_getN(7);
  @$pb.TagNumber(8)
  set startsAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartsAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartsAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartsAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get endsAt => $_getN(8);
  @$pb.TagNumber(9)
  set endsAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndsAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndsAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndsAt() => $_ensure(8);

  @$pb.TagNumber(10)
  AppointmentStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(AppointmentStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get bookedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set bookedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBookedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearBookedBy() => $_clearField(11);

  /// Why the patient is coming, as stated at booking. Short and non-clinical: a
  /// diagnosis belongs in the encounter, which far fewer people can see.
  @$pb.TagNumber(12)
  $core.String get reason => $_getSZ(11);
  @$pb.TagNumber(12)
  set reason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearReason() => $_clearField(12);

  /// Every status this appointment has held. SRS-SCH-005 requires it to be
  /// retained: a patient disputing a missed-appointment fee needs the record to
  /// show when they were marked a no-show and by whom.
  @$pb.TagNumber(13)
  $pb.PbList<StatusChange> get history => $_getList(12);

  /// Chains to the appointment this one replaced, so the chronology survives a
  /// reschedule.
  @$pb.TagNumber(14)
  $core.String get rescheduledFromId => $_getSZ(13);
  @$pb.TagNumber(14)
  set rescheduledFromId($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRescheduledFromId() => $_has(13);
  @$pb.TagNumber(14)
  void clearRescheduledFromId() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);

  /// Groups a recurring therapy series (SRS-SCH-013).
  @$pb.TagNumber(16)
  $core.String get seriesId => $_getSZ(15);
  @$pb.TagNumber(16)
  set seriesId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasSeriesId() => $_has(15);
  @$pb.TagNumber(16)
  void clearSeriesId() => $_clearField(16);

  /// This appointment's position in its series, from 1.
  @$pb.TagNumber(17)
  $core.int get occurrence => $_getIZ(16);
  @$pb.TagNumber(17)
  set occurrence($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasOccurrence() => $_has(16);
  @$pb.TagNumber(17)
  void clearOccurrence() => $_clearField(17);

  /// How many times this booking has been moved. Carried forward across the
  /// chain, because a policy capping reschedules is about the patient rather
  /// than about any one row.
  @$pb.TagNumber(18)
  $core.int get rescheduleCount => $_getIZ(17);
  @$pb.TagNumber(18)
  set rescheduleCount($core.int value) => $_setSignedInt32(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRescheduleCount() => $_has(17);
  @$pb.TagNumber(18)
  void clearRescheduleCount() => $_clearField(18);

  /// Where a teleconsult happens (SRS-SCH-015). Empty for an in-person
  /// appointment: one carrying a link invites a patient to stay home.
  @$pb.TagNumber(19)
  $core.String get joinUrl => $_getSZ(18);
  @$pb.TagNumber(19)
  set joinUrl($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasJoinUrl() => $_has(18);
  @$pb.TagNumber(19)
  void clearJoinUrl() => $_clearField(19);

  /// What the patient is called by. Not the appointment id: that is a UUID
  /// nobody can read out across a noisy waiting room.
  @$pb.TagNumber(20)
  $core.String get token => $_getSZ(19);
  @$pb.TagNumber(20)
  set token($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasToken() => $_has(19);
  @$pb.TagNumber(20)
  void clearToken() => $_clearField(20);

  @$pb.TagNumber(21)
  ArrivalMode get arrivalMode => $_getN(20);
  @$pb.TagNumber(21)
  set arrivalMode(ArrivalMode value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasArrivalMode() => $_has(20);
  @$pb.TagNumber(21)
  void clearArrivalMode() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get checkedInAt => $_getN(21);
  @$pb.TagNumber(22)
  set checkedInAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCheckedInAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearCheckedInAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureCheckedInAt() => $_ensure(21);

  @$pb.TagNumber(23)
  Priority get priority => $_getN(22);
  @$pb.TagNumber(23)
  set priority(Priority value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasPriority() => $_has(22);
  @$pb.TagNumber(23)
  void clearPriority() => $_clearField(23);

  /// Shown to queue users, not buried in an audit table: the people waiting can
  /// see that somebody went ahead of them, and a board that shows the move
  /// without the reason produces the argument the reason exists to prevent
  /// (SRS-SCH-011).
  @$pb.TagNumber(24)
  $core.String get priorityReason => $_getSZ(23);
  @$pb.TagNumber(24)
  set priorityReason($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasPriorityReason() => $_has(23);
  @$pb.TagNumber(24)
  void clearPriorityReason() => $_clearField(24);
}

class DefineResourceRequest extends $pb.GeneratedMessage {
  factory DefineResourceRequest({
    $core.String? facilityId,
    $core.String? orgUnitId,
    ResourceType? type,
    $core.String? subjectId,
    $core.String? displayName,
    $core.String? timeZone,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (type != null) result.type = type;
    if (subjectId != null) result.subjectId = subjectId;
    if (displayName != null) result.displayName = displayName;
    if (timeZone != null) result.timeZone = timeZone;
    return result;
  }

  DefineResourceRequest._();

  factory DefineResourceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineResourceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineResourceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<ResourceType>(3, _omitFieldNames ? '' : 'type',
        enumValues: ResourceType.values)
    ..aOS(4, _omitFieldNames ? '' : 'subjectId')
    ..aOS(5, _omitFieldNames ? '' : 'displayName')
    ..aOS(6, _omitFieldNames ? '' : 'timeZone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineResourceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineResourceRequest copyWith(
          void Function(DefineResourceRequest) updates) =>
      super.copyWith((message) => updates(message as DefineResourceRequest))
          as DefineResourceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineResourceRequest create() => DefineResourceRequest._();
  @$core.override
  DefineResourceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineResourceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineResourceRequest>(create);
  static DefineResourceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get orgUnitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orgUnitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrgUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrgUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  ResourceType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(ResourceType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subjectId => $_getSZ(3);
  @$pb.TagNumber(4)
  set subjectId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubjectId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubjectId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get displayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set displayName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplayName() => $_clearField(5);

  /// An IANA zone. A diary is written in local time and nothing else makes sense
  /// to the people reading it.
  @$pb.TagNumber(6)
  $core.String get timeZone => $_getSZ(5);
  @$pb.TagNumber(6)
  set timeZone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTimeZone() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimeZone() => $_clearField(6);
}

class DefineResourceResponse extends $pb.GeneratedMessage {
  factory DefineResourceResponse({
    Resource? resource,
  }) {
    final result = create();
    if (resource != null) result.resource = resource;
    return result;
  }

  DefineResourceResponse._();

  factory DefineResourceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineResourceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineResourceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Resource>(1, _omitFieldNames ? '' : 'resource',
        subBuilder: Resource.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineResourceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineResourceResponse copyWith(
          void Function(DefineResourceResponse) updates) =>
      super.copyWith((message) => updates(message as DefineResourceResponse))
          as DefineResourceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineResourceResponse create() => DefineResourceResponse._();
  @$core.override
  DefineResourceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineResourceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineResourceResponse>(create);
  static DefineResourceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Resource get resource => $_getN(0);
  @$pb.TagNumber(1)
  set resource(Resource value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResource() => $_has(0);
  @$pb.TagNumber(1)
  void clearResource() => $_clearField(1);
  @$pb.TagNumber(1)
  Resource ensureResource() => $_ensure(0);
}

class SetResourceStatusRequest extends $pb.GeneratedMessage {
  factory SetResourceStatusRequest({
    $core.String? resourceId,
    ResourceStatus? status,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (status != null) result.status = status;
    return result;
  }

  SetResourceStatusRequest._();

  factory SetResourceStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetResourceStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetResourceStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aE<ResourceStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: ResourceStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetResourceStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetResourceStatusRequest copyWith(
          void Function(SetResourceStatusRequest) updates) =>
      super.copyWith((message) => updates(message as SetResourceStatusRequest))
          as SetResourceStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetResourceStatusRequest create() => SetResourceStatusRequest._();
  @$core.override
  SetResourceStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetResourceStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetResourceStatusRequest>(create);
  static SetResourceStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ResourceStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(ResourceStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class SetResourceStatusResponse extends $pb.GeneratedMessage {
  factory SetResourceStatusResponse() => create();

  SetResourceStatusResponse._();

  factory SetResourceStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetResourceStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetResourceStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetResourceStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetResourceStatusResponse copyWith(
          void Function(SetResourceStatusResponse) updates) =>
      super.copyWith((message) => updates(message as SetResourceStatusResponse))
          as SetResourceStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetResourceStatusResponse create() => SetResourceStatusResponse._();
  @$core.override
  SetResourceStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetResourceStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetResourceStatusResponse>(create);
  static SetResourceStatusResponse? _defaultInstance;
}

class DefineScheduleRequest extends $pb.GeneratedMessage {
  factory DefineScheduleRequest({
    $core.String? resourceId,
    VisitType? visitType,
    VisitMode? visitMode,
    $core.int? weekday,
    $core.int? startMinute,
    $core.int? endMinute,
    $core.int? slotMinutes,
    $core.int? capacity,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (visitType != null) result.visitType = visitType;
    if (visitMode != null) result.visitMode = visitMode;
    if (weekday != null) result.weekday = weekday;
    if (startMinute != null) result.startMinute = startMinute;
    if (endMinute != null) result.endMinute = endMinute;
    if (slotMinutes != null) result.slotMinutes = slotMinutes;
    if (capacity != null) result.capacity = capacity;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  DefineScheduleRequest._();

  factory DefineScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineScheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aE<VisitType>(2, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aE<VisitMode>(3, _omitFieldNames ? '' : 'visitMode',
        enumValues: VisitMode.values)
    ..aI(4, _omitFieldNames ? '' : 'weekday')
    ..aI(5, _omitFieldNames ? '' : 'startMinute')
    ..aI(6, _omitFieldNames ? '' : 'endMinute')
    ..aI(7, _omitFieldNames ? '' : 'slotMinutes')
    ..aI(8, _omitFieldNames ? '' : 'capacity')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineScheduleRequest copyWith(
          void Function(DefineScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as DefineScheduleRequest))
          as DefineScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineScheduleRequest create() => DefineScheduleRequest._();
  @$core.override
  DefineScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineScheduleRequest>(create);
  static DefineScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  VisitType get visitType => $_getN(1);
  @$pb.TagNumber(2)
  set visitType(VisitType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasVisitType() => $_has(1);
  @$pb.TagNumber(2)
  void clearVisitType() => $_clearField(2);

  @$pb.TagNumber(3)
  VisitMode get visitMode => $_getN(2);
  @$pb.TagNumber(3)
  set visitMode(VisitMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasVisitMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearVisitMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get weekday => $_getIZ(3);
  @$pb.TagNumber(4)
  set weekday($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWeekday() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeekday() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get startMinute => $_getIZ(4);
  @$pb.TagNumber(5)
  set startMinute($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartMinute() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartMinute() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get endMinute => $_getIZ(5);
  @$pb.TagNumber(6)
  set endMinute($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndMinute() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndMinute() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get slotMinutes => $_getIZ(6);
  @$pb.TagNumber(7)
  set slotMinutes($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSlotMinutes() => $_has(6);
  @$pb.TagNumber(7)
  void clearSlotMinutes() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get capacity => $_getIZ(7);
  @$pb.TagNumber(8)
  set capacity($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCapacity() => $_has(7);
  @$pb.TagNumber(8)
  void clearCapacity() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get effectiveFrom => $_getN(8);
  @$pb.TagNumber(9)
  set effectiveFrom($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectiveFrom() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveFrom() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get effectiveUntil => $_getN(9);
  @$pb.TagNumber(10)
  set effectiveUntil($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEffectiveUntil() => $_has(9);
  @$pb.TagNumber(10)
  void clearEffectiveUntil() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(9);
}

class DefineScheduleResponse extends $pb.GeneratedMessage {
  factory DefineScheduleResponse({
    Schedule? schedule,
  }) {
    final result = create();
    if (schedule != null) result.schedule = schedule;
    return result;
  }

  DefineScheduleResponse._();

  factory DefineScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineScheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Schedule>(1, _omitFieldNames ? '' : 'schedule',
        subBuilder: Schedule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineScheduleResponse copyWith(
          void Function(DefineScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as DefineScheduleResponse))
          as DefineScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineScheduleResponse create() => DefineScheduleResponse._();
  @$core.override
  DefineScheduleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineScheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineScheduleResponse>(create);
  static DefineScheduleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Schedule get schedule => $_getN(0);
  @$pb.TagNumber(1)
  set schedule(Schedule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSchedule() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchedule() => $_clearField(1);
  @$pb.TagNumber(1)
  Schedule ensureSchedule() => $_ensure(0);
}

class BlockPeriodRequest extends $pb.GeneratedMessage {
  factory BlockPeriodRequest({
    $core.String? resourceId,
    ExceptionKind? kind,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $core.String? reason,
    $core.bool? overridable,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (kind != null) result.kind = kind;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (reason != null) result.reason = reason;
    if (overridable != null) result.overridable = overridable;
    return result;
  }

  BlockPeriodRequest._();

  factory BlockPeriodRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockPeriodRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockPeriodRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aE<ExceptionKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ExceptionKind.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'overridable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockPeriodRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockPeriodRequest copyWith(void Function(BlockPeriodRequest) updates) =>
      super.copyWith((message) => updates(message as BlockPeriodRequest))
          as BlockPeriodRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockPeriodRequest create() => BlockPeriodRequest._();
  @$core.override
  BlockPeriodRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockPeriodRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockPeriodRequest>(create);
  static BlockPeriodRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  ExceptionKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ExceptionKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startsAt => $_getN(2);
  @$pb.TagNumber(3)
  set startsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartsAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get endsAt => $_getN(3);
  @$pb.TagNumber(4)
  set endsAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEndsAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndsAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureEndsAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get overridable => $_getBF(5);
  @$pb.TagNumber(6)
  set overridable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverridable() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverridable() => $_clearField(6);
}

class BlockPeriodResponse extends $pb.GeneratedMessage {
  factory BlockPeriodResponse({
    ScheduleException? exception,
  }) {
    final result = create();
    if (exception != null) result.exception = exception;
    return result;
  }

  BlockPeriodResponse._();

  factory BlockPeriodResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockPeriodResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockPeriodResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<ScheduleException>(1, _omitFieldNames ? '' : 'exception',
        subBuilder: ScheduleException.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockPeriodResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockPeriodResponse copyWith(void Function(BlockPeriodResponse) updates) =>
      super.copyWith((message) => updates(message as BlockPeriodResponse))
          as BlockPeriodResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockPeriodResponse create() => BlockPeriodResponse._();
  @$core.override
  BlockPeriodResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockPeriodResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockPeriodResponse>(create);
  static BlockPeriodResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ScheduleException get exception => $_getN(0);
  @$pb.TagNumber(1)
  set exception(ScheduleException value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasException() => $_has(0);
  @$pb.TagNumber(1)
  void clearException() => $_clearField(1);
  @$pb.TagNumber(1)
  ScheduleException ensureException() => $_ensure(0);
}

class UnblockPeriodRequest extends $pb.GeneratedMessage {
  factory UnblockPeriodRequest({
    $core.String? exceptionId,
  }) {
    final result = create();
    if (exceptionId != null) result.exceptionId = exceptionId;
    return result;
  }

  UnblockPeriodRequest._();

  factory UnblockPeriodRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnblockPeriodRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnblockPeriodRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'exceptionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockPeriodRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockPeriodRequest copyWith(void Function(UnblockPeriodRequest) updates) =>
      super.copyWith((message) => updates(message as UnblockPeriodRequest))
          as UnblockPeriodRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnblockPeriodRequest create() => UnblockPeriodRequest._();
  @$core.override
  UnblockPeriodRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnblockPeriodRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnblockPeriodRequest>(create);
  static UnblockPeriodRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get exceptionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set exceptionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExceptionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearExceptionId() => $_clearField(1);
}

class UnblockPeriodResponse extends $pb.GeneratedMessage {
  factory UnblockPeriodResponse() => create();

  UnblockPeriodResponse._();

  factory UnblockPeriodResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnblockPeriodResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnblockPeriodResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockPeriodResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnblockPeriodResponse copyWith(
          void Function(UnblockPeriodResponse) updates) =>
      super.copyWith((message) => updates(message as UnblockPeriodResponse))
          as UnblockPeriodResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnblockPeriodResponse create() => UnblockPeriodResponse._();
  @$core.override
  UnblockPeriodResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnblockPeriodResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnblockPeriodResponse>(create);
  static UnblockPeriodResponse? _defaultInstance;
}

class SearchSlotsRequest extends $pb.GeneratedMessage {
  factory SearchSlotsRequest({
    $core.String? facilityId,
    $core.String? orgUnitId,
    $core.String? resourceId,
    VisitType? visitType,
    VisitMode? visitMode,
    $0.Timestamp? from,
    $0.Timestamp? until,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (resourceId != null) result.resourceId = resourceId;
    if (visitType != null) result.visitType = visitType;
    if (visitMode != null) result.visitMode = visitMode;
    if (from != null) result.from = from;
    if (until != null) result.until = until;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  SearchSlotsRequest._();

  factory SearchSlotsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchSlotsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSlotsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(3, _omitFieldNames ? '' : 'resourceId')
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aE<VisitMode>(5, _omitFieldNames ? '' : 'visitMode',
        enumValues: VisitMode.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSlotsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSlotsRequest copyWith(void Function(SearchSlotsRequest) updates) =>
      super.copyWith((message) => updates(message as SearchSlotsRequest))
          as SearchSlotsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchSlotsRequest create() => SearchSlotsRequest._();
  @$core.override
  SearchSlotsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchSlotsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSlotsRequest>(create);
  static SearchSlotsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  /// The specialty or department, which is how a patient who does not know a
  /// clinician's name searches.
  @$pb.TagNumber(2)
  $core.String get orgUnitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set orgUnitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOrgUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrgUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resourceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resourceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResourceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResourceId() => $_clearField(3);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  @$pb.TagNumber(5)
  VisitMode get visitMode => $_getN(4);
  @$pb.TagNumber(5)
  set visitMode(VisitMode value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitMode() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitMode() => $_clearField(5);

  /// Local dates; until is exclusive.
  @$pb.TagNumber(6)
  $0.Timestamp get from => $_getN(5);
  @$pb.TagNumber(6)
  set from($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get until => $_getN(6);
  @$pb.TagNumber(7)
  set until($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUntil() => $_has(6);
  @$pb.TagNumber(7)
  void clearUntil() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureUntil() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get pageSize => $_getIZ(7);
  @$pb.TagNumber(8)
  set pageSize($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageSize() => $_clearField(8);
}

class SearchSlotsResponse extends $pb.GeneratedMessage {
  factory SearchSlotsResponse({
    $core.Iterable<Slot>? slots,
    $core.bool? truncated,
  }) {
    final result = create();
    if (slots != null) result.slots.addAll(slots);
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  SearchSlotsResponse._();

  factory SearchSlotsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchSlotsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchSlotsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPM<Slot>(1, _omitFieldNames ? '' : 'slots', subBuilder: Slot.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSlotsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchSlotsResponse copyWith(void Function(SearchSlotsResponse) updates) =>
      super.copyWith((message) => updates(message as SearchSlotsResponse))
          as SearchSlotsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchSlotsResponse create() => SearchSlotsResponse._();
  @$core.override
  SearchSlotsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchSlotsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchSlotsResponse>(create);
  static SearchSlotsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Slot> get slots => $_getList(0);

  /// The page limit cut the result, so a client can say so rather than implying
  /// the clinic has nothing later.
  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

class BookAppointmentRequest extends $pb.GeneratedMessage {
  factory BookAppointmentRequest({
    $core.String? patientId,
    $core.String? resourceId,
    $0.Timestamp? startsAt,
    VisitType? visitType,
    $core.String? reason,
    $core.bool? override,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (resourceId != null) result.resourceId = resourceId;
    if (startsAt != null) result.startsAt = startsAt;
    if (visitType != null) result.visitType = visitType;
    if (reason != null) result.reason = reason;
    if (override != null) result.override = override;
    return result;
  }

  BookAppointmentRequest._();

  factory BookAppointmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BookAppointmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BookAppointmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'override')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookAppointmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookAppointmentRequest copyWith(
          void Function(BookAppointmentRequest) updates) =>
      super.copyWith((message) => updates(message as BookAppointmentRequest))
          as BookAppointmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BookAppointmentRequest create() => BookAppointmentRequest._();
  @$core.override
  BookAppointmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BookAppointmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BookAppointmentRequest>(create);
  static BookAppointmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// The slot is named by resource, instant and visit type rather than by an
  /// opaque id, because slots are generated rather than stored: an id would have
  /// to be minted at search time and would be meaningless by the time the
  /// patient chose one.
  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startsAt => $_getN(2);
  @$pb.TagNumber(3)
  set startsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartsAt() => $_ensure(2);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  /// Book into a blocked period. Needs the override permission, and works only
  /// where the block said it was overridable.
  @$pb.TagNumber(6)
  $core.bool get override => $_getBF(5);
  @$pb.TagNumber(6)
  set override($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverride() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverride() => $_clearField(6);
}

class BookAppointmentResponse extends $pb.GeneratedMessage {
  factory BookAppointmentResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  BookAppointmentResponse._();

  factory BookAppointmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BookAppointmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BookAppointmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookAppointmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookAppointmentResponse copyWith(
          void Function(BookAppointmentResponse) updates) =>
      super.copyWith((message) => updates(message as BookAppointmentResponse))
          as BookAppointmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BookAppointmentResponse create() => BookAppointmentResponse._();
  @$core.override
  BookAppointmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BookAppointmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BookAppointmentResponse>(create);
  static BookAppointmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

class GetAppointmentRequest extends $pb.GeneratedMessage {
  factory GetAppointmentRequest({
    $core.String? appointmentId,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    return result;
  }

  GetAppointmentRequest._();

  factory GetAppointmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAppointmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAppointmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAppointmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAppointmentRequest copyWith(
          void Function(GetAppointmentRequest) updates) =>
      super.copyWith((message) => updates(message as GetAppointmentRequest))
          as GetAppointmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAppointmentRequest create() => GetAppointmentRequest._();
  @$core.override
  GetAppointmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAppointmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAppointmentRequest>(create);
  static GetAppointmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);
}

class GetAppointmentResponse extends $pb.GeneratedMessage {
  factory GetAppointmentResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  GetAppointmentResponse._();

  factory GetAppointmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAppointmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAppointmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAppointmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAppointmentResponse copyWith(
          void Function(GetAppointmentResponse) updates) =>
      super.copyWith((message) => updates(message as GetAppointmentResponse))
          as GetAppointmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAppointmentResponse create() => GetAppointmentResponse._();
  @$core.override
  GetAppointmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAppointmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAppointmentResponse>(create);
  static GetAppointmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

class ListAppointmentsRequest extends $pb.GeneratedMessage {
  factory ListAppointmentsRequest({
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? resourceId,
    $0.Timestamp? from,
    $0.Timestamp? until,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (resourceId != null) result.resourceId = resourceId;
    if (from != null) result.from = from;
    if (until != null) result.until = until;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAppointmentsRequest._();

  factory ListAppointmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAppointmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAppointmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAppointmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAppointmentsRequest copyWith(
          void Function(ListAppointmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAppointmentsRequest))
          as ListAppointmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAppointmentsRequest create() => ListAppointmentsRequest._();
  @$core.override
  ListAppointmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAppointmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAppointmentsRequest>(create);
  static ListAppointmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resourceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resourceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResourceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResourceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get from => $_getN(3);
  @$pb.TagNumber(4)
  set from($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get until => $_getN(4);
  @$pb.TagNumber(5)
  set until($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearUntil() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureUntil() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);
}

class ListAppointmentsResponse extends $pb.GeneratedMessage {
  factory ListAppointmentsResponse({
    $core.Iterable<Appointment>? appointments,
  }) {
    final result = create();
    if (appointments != null) result.appointments.addAll(appointments);
    return result;
  }

  ListAppointmentsResponse._();

  factory ListAppointmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAppointmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAppointmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPM<Appointment>(1, _omitFieldNames ? '' : 'appointments',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAppointmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAppointmentsResponse copyWith(
          void Function(ListAppointmentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAppointmentsResponse))
          as ListAppointmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAppointmentsResponse create() => ListAppointmentsResponse._();
  @$core.override
  ListAppointmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAppointmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAppointmentsResponse>(create);
  static ListAppointmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Appointment> get appointments => $_getList(0);
}

/// What the policy made of a cancellation or a reschedule (SRS-SCH-005).
///
/// Captured at the moment of the decision, so a policy changed in March cannot
/// retroactively make a February cancellation late. This system never charges
/// anybody: it records whether the notice period was met and leaves the fee to
/// SRS-BIL.
class PolicyOutcome extends $pb.GeneratedMessage {
  factory PolicyOutcome({
    $core.bool? timely,
    $core.int? noticeGivenMinutes,
    $core.int? noticeRequiredMinutes,
    $core.bool? chargeable,
  }) {
    final result = create();
    if (timely != null) result.timely = timely;
    if (noticeGivenMinutes != null)
      result.noticeGivenMinutes = noticeGivenMinutes;
    if (noticeRequiredMinutes != null)
      result.noticeRequiredMinutes = noticeRequiredMinutes;
    if (chargeable != null) result.chargeable = chargeable;
    return result;
  }

  PolicyOutcome._();

  factory PolicyOutcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PolicyOutcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PolicyOutcome',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'timely')
    ..aI(2, _omitFieldNames ? '' : 'noticeGivenMinutes')
    ..aI(3, _omitFieldNames ? '' : 'noticeRequiredMinutes')
    ..aOB(4, _omitFieldNames ? '' : 'chargeable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicyOutcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolicyOutcome copyWith(void Function(PolicyOutcome) updates) =>
      super.copyWith((message) => updates(message as PolicyOutcome))
          as PolicyOutcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolicyOutcome create() => PolicyOutcome._();
  @$core.override
  PolicyOutcome createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PolicyOutcome getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PolicyOutcome>(create);
  static PolicyOutcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get timely => $_getBF(0);
  @$pb.TagNumber(1)
  set timely($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimely() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimely() => $_clearField(1);

  /// Stored rather than derived later: "cancelled 23 hours before" is the fact a
  /// dispute turns on, and recomputing it from two timestamps months later
  /// invites a rounding argument.
  @$pb.TagNumber(2)
  $core.int get noticeGivenMinutes => $_getIZ(1);
  @$pb.TagNumber(2)
  set noticeGivenMinutes($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoticeGivenMinutes() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoticeGivenMinutes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get noticeRequiredMinutes => $_getIZ(2);
  @$pb.TagNumber(3)
  set noticeRequiredMinutes($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNoticeRequiredMinutes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNoticeRequiredMinutes() => $_clearField(3);

  /// Refer to billing. What it costs is SRS-BIL's decision, not this one.
  @$pb.TagNumber(4)
  $core.bool get chargeable => $_getBF(3);
  @$pb.TagNumber(4)
  set chargeable($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChargeable() => $_has(3);
  @$pb.TagNumber(4)
  void clearChargeable() => $_clearField(4);
}

class CancelAppointmentRequest extends $pb.GeneratedMessage {
  factory CancelAppointmentRequest({
    $core.String? appointmentId,
    $core.String? reason,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelAppointmentRequest._();

  factory CancelAppointmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelAppointmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelAppointmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAppointmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAppointmentRequest copyWith(
          void Function(CancelAppointmentRequest) updates) =>
      super.copyWith((message) => updates(message as CancelAppointmentRequest))
          as CancelAppointmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelAppointmentRequest create() => CancelAppointmentRequest._();
  @$core.override
  CancelAppointmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelAppointmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelAppointmentRequest>(create);
  static CancelAppointmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancelAppointmentResponse extends $pb.GeneratedMessage {
  factory CancelAppointmentResponse({
    Appointment? appointment,
    PolicyOutcome? outcome,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  CancelAppointmentResponse._();

  factory CancelAppointmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelAppointmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelAppointmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..aOM<PolicyOutcome>(2, _omitFieldNames ? '' : 'outcome',
        subBuilder: PolicyOutcome.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAppointmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelAppointmentResponse copyWith(
          void Function(CancelAppointmentResponse) updates) =>
      super.copyWith((message) => updates(message as CancelAppointmentResponse))
          as CancelAppointmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelAppointmentResponse create() => CancelAppointmentResponse._();
  @$core.override
  CancelAppointmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelAppointmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelAppointmentResponse>(create);
  static CancelAppointmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);

  @$pb.TagNumber(2)
  PolicyOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(PolicyOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);
  @$pb.TagNumber(2)
  PolicyOutcome ensureOutcome() => $_ensure(1);
}

class RescheduleAppointmentRequest extends $pb.GeneratedMessage {
  factory RescheduleAppointmentRequest({
    $core.String? appointmentId,
    $core.String? resourceId,
    $0.Timestamp? startsAt,
    VisitType? visitType,
    $core.String? reason,
    $core.bool? override,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (resourceId != null) result.resourceId = resourceId;
    if (startsAt != null) result.startsAt = startsAt;
    if (visitType != null) result.visitType = visitType;
    if (reason != null) result.reason = reason;
    if (override != null) result.override = override;
    return result;
  }

  RescheduleAppointmentRequest._();

  factory RescheduleAppointmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RescheduleAppointmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescheduleAppointmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOB(6, _omitFieldNames ? '' : 'override')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleAppointmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleAppointmentRequest copyWith(
          void Function(RescheduleAppointmentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RescheduleAppointmentRequest))
          as RescheduleAppointmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RescheduleAppointmentRequest create() =>
      RescheduleAppointmentRequest._();
  @$core.override
  RescheduleAppointmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RescheduleAppointmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RescheduleAppointmentRequest>(create);
  static RescheduleAppointmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startsAt => $_getN(2);
  @$pb.TagNumber(3)
  set startsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartsAt() => $_ensure(2);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get override => $_getBF(5);
  @$pb.TagNumber(6)
  set override($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverride() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverride() => $_clearField(6);
}

class RescheduleAppointmentResponse extends $pb.GeneratedMessage {
  factory RescheduleAppointmentResponse({
    Appointment? appointment,
    $core.String? previousAppointmentId,
    PolicyOutcome? outcome,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    if (previousAppointmentId != null)
      result.previousAppointmentId = previousAppointmentId;
    if (outcome != null) result.outcome = outcome;
    return result;
  }

  RescheduleAppointmentResponse._();

  factory RescheduleAppointmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RescheduleAppointmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RescheduleAppointmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..aOS(2, _omitFieldNames ? '' : 'previousAppointmentId')
    ..aOM<PolicyOutcome>(3, _omitFieldNames ? '' : 'outcome',
        subBuilder: PolicyOutcome.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleAppointmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RescheduleAppointmentResponse copyWith(
          void Function(RescheduleAppointmentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RescheduleAppointmentResponse))
          as RescheduleAppointmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RescheduleAppointmentResponse create() =>
      RescheduleAppointmentResponse._();
  @$core.override
  RescheduleAppointmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RescheduleAppointmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RescheduleAppointmentResponse>(create);
  static RescheduleAppointmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);

  /// The booking this replaced. Cancelled rather than edited, because
  /// SRS-SCH-005 requires the original to retain its status history.
  @$pb.TagNumber(2)
  $core.String get previousAppointmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set previousAppointmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPreviousAppointmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousAppointmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  PolicyOutcome get outcome => $_getN(2);
  @$pb.TagNumber(3)
  set outcome(PolicyOutcome value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOutcome() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutcome() => $_clearField(3);
  @$pb.TagNumber(3)
  PolicyOutcome ensureOutcome() => $_ensure(2);
}

class SchedulingPolicy extends $pb.GeneratedMessage {
  factory SchedulingPolicy({
    $core.int? noticeHours,
    $core.int? rescheduleNoticeHours,
    $core.int? maxReschedules,
    $core.bool? chargeableWhenLate,
    $core.bool? teleconsultEnabled,
    $core.Iterable<VisitType>? teleconsultVisitTypes,
    $core.bool? teleconsultRequiresConfirmedIdentity,
    $core.Iterable<NotificationKind>? notificationKinds,
    $core.int? reminderHoursBefore,
  }) {
    final result = create();
    if (noticeHours != null) result.noticeHours = noticeHours;
    if (rescheduleNoticeHours != null)
      result.rescheduleNoticeHours = rescheduleNoticeHours;
    if (maxReschedules != null) result.maxReschedules = maxReschedules;
    if (chargeableWhenLate != null)
      result.chargeableWhenLate = chargeableWhenLate;
    if (teleconsultEnabled != null)
      result.teleconsultEnabled = teleconsultEnabled;
    if (teleconsultVisitTypes != null)
      result.teleconsultVisitTypes.addAll(teleconsultVisitTypes);
    if (teleconsultRequiresConfirmedIdentity != null)
      result.teleconsultRequiresConfirmedIdentity =
          teleconsultRequiresConfirmedIdentity;
    if (notificationKinds != null)
      result.notificationKinds.addAll(notificationKinds);
    if (reminderHoursBefore != null)
      result.reminderHoursBefore = reminderHoursBefore;
    return result;
  }

  SchedulingPolicy._();

  factory SchedulingPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SchedulingPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SchedulingPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'noticeHours')
    ..aI(2, _omitFieldNames ? '' : 'rescheduleNoticeHours')
    ..aI(3, _omitFieldNames ? '' : 'maxReschedules')
    ..aOB(4, _omitFieldNames ? '' : 'chargeableWhenLate')
    ..aOB(5, _omitFieldNames ? '' : 'teleconsultEnabled')
    ..pc<VisitType>(
        6, _omitFieldNames ? '' : 'teleconsultVisitTypes', $pb.PbFieldType.KE,
        valueOf: VisitType.valueOf,
        enumValues: VisitType.values,
        defaultEnumValue: VisitType.VISIT_TYPE_UNSPECIFIED)
    ..aOB(7, _omitFieldNames ? '' : 'teleconsultRequiresConfirmedIdentity')
    ..pc<NotificationKind>(
        8, _omitFieldNames ? '' : 'notificationKinds', $pb.PbFieldType.KE,
        valueOf: NotificationKind.valueOf,
        enumValues: NotificationKind.values,
        defaultEnumValue: NotificationKind.NOTIFICATION_KIND_UNSPECIFIED)
    ..aI(9, _omitFieldNames ? '' : 'reminderHoursBefore')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulingPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulingPolicy copyWith(void Function(SchedulingPolicy) updates) =>
      super.copyWith((message) => updates(message as SchedulingPolicy))
          as SchedulingPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SchedulingPolicy create() => SchedulingPolicy._();
  @$core.override
  SchedulingPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SchedulingPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SchedulingPolicy>(create);
  static SchedulingPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get noticeHours => $_getIZ(0);
  @$pb.TagNumber(1)
  set noticeHours($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeHours() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeHours() => $_clearField(1);

  /// Usually shorter than cancellation notice: moving an appointment leaves the
  /// clinic able to refill the slot, while cancelling on the day does not.
  @$pb.TagNumber(2)
  $core.int get rescheduleNoticeHours => $_getIZ(1);
  @$pb.TagNumber(2)
  set rescheduleNoticeHours($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRescheduleNoticeHours() => $_has(1);
  @$pb.TagNumber(2)
  void clearRescheduleNoticeHours() => $_clearField(2);

  /// 0 means unlimited. A booking moved eleven times is a patient who is not
  /// coming, and each move cost a slot somebody else could have used.
  @$pb.TagNumber(3)
  $core.int get maxReschedules => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxReschedules($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaxReschedules() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxReschedules() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get chargeableWhenLate => $_getBF(3);
  @$pb.TagNumber(4)
  set chargeableWhenLate($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChargeableWhenLate() => $_has(3);
  @$pb.TagNumber(4)
  void clearChargeableWhenLate() => $_clearField(4);

  /// Off by default: a facility that has not thought about remote consultations
  /// has not decided which of its clinics can safely run that way.
  @$pb.TagNumber(5)
  $core.bool get teleconsultEnabled => $_getBF(4);
  @$pb.TagNumber(5)
  set teleconsultEnabled($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTeleconsultEnabled() => $_has(4);
  @$pb.TagNumber(5)
  void clearTeleconsultEnabled() => $_clearField(5);

  /// Empty means every visit type the roster offers remotely.
  @$pb.TagNumber(6)
  $pb.PbList<VisitType> get teleconsultVisitTypes => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get teleconsultRequiresConfirmedIdentity => $_getBF(6);
  @$pb.TagNumber(7)
  set teleconsultRequiresConfirmedIdentity($core.bool value) =>
      $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTeleconsultRequiresConfirmedIdentity() => $_has(6);
  @$pb.TagNumber(7)
  void clearTeleconsultRequiresConfirmedIdentity() => $_clearField(7);

  /// Which messages this facility sends (SRS-SCH-012). Empty means none, which
  /// is a real configuration: a clinic whose patients have no phones sends
  /// nothing rather than accumulating failures.
  @$pb.TagNumber(8)
  $pb.PbList<NotificationKind> get notificationKinds => $_getList(7);

  /// When a reminder goes out. Zero disables reminders even where the kind is
  /// enabled, because "remind them at the appointment time" is not a reminder.
  @$pb.TagNumber(9)
  $core.int get reminderHoursBefore => $_getIZ(8);
  @$pb.TagNumber(9)
  set reminderHoursBefore($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReminderHoursBefore() => $_has(8);
  @$pb.TagNumber(9)
  void clearReminderHoursBefore() => $_clearField(9);
}

class SetSchedulingPolicyRequest extends $pb.GeneratedMessage {
  factory SetSchedulingPolicyRequest({
    $core.String? facilityId,
    SchedulingPolicy? policy,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (policy != null) result.policy = policy;
    return result;
  }

  SetSchedulingPolicyRequest._();

  factory SetSchedulingPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSchedulingPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSchedulingPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<SchedulingPolicy>(2, _omitFieldNames ? '' : 'policy',
        subBuilder: SchedulingPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSchedulingPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSchedulingPolicyRequest copyWith(
          void Function(SetSchedulingPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetSchedulingPolicyRequest))
          as SetSchedulingPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSchedulingPolicyRequest create() => SetSchedulingPolicyRequest._();
  @$core.override
  SetSchedulingPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSchedulingPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSchedulingPolicyRequest>(create);
  static SetSchedulingPolicyRequest? _defaultInstance;

  /// Empty applies tenant-wide; naming a facility overrides.
  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  SchedulingPolicy get policy => $_getN(1);
  @$pb.TagNumber(2)
  set policy(SchedulingPolicy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicy() => $_clearField(2);
  @$pb.TagNumber(2)
  SchedulingPolicy ensurePolicy() => $_ensure(1);
}

class SetSchedulingPolicyResponse extends $pb.GeneratedMessage {
  factory SetSchedulingPolicyResponse() => create();

  SetSchedulingPolicyResponse._();

  factory SetSchedulingPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSchedulingPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSchedulingPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSchedulingPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSchedulingPolicyResponse copyWith(
          void Function(SetSchedulingPolicyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetSchedulingPolicyResponse))
          as SetSchedulingPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSchedulingPolicyResponse create() =>
      SetSchedulingPolicyResponse._();
  @$core.override
  SetSchedulingPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSchedulingPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSchedulingPolicyResponse>(create);
  static SetSchedulingPolicyResponse? _defaultInstance;
}

class BookSeriesRequest extends $pb.GeneratedMessage {
  factory BookSeriesRequest({
    $core.String? patientId,
    $core.String? resourceId,
    $0.Timestamp? startsAt,
    VisitType? visitType,
    $core.int? intervalDays,
    $core.int? occurrences,
    $core.String? reason,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (resourceId != null) result.resourceId = resourceId;
    if (startsAt != null) result.startsAt = startsAt;
    if (visitType != null) result.visitType = visitType;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (occurrences != null) result.occurrences = occurrences;
    if (reason != null) result.reason = reason;
    return result;
  }

  BookSeriesRequest._();

  factory BookSeriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BookSeriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BookSeriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aI(5, _omitFieldNames ? '' : 'intervalDays')
    ..aI(6, _omitFieldNames ? '' : 'occurrences')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookSeriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookSeriesRequest copyWith(void Function(BookSeriesRequest) updates) =>
      super.copyWith((message) => updates(message as BookSeriesRequest))
          as BookSeriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BookSeriesRequest create() => BookSeriesRequest._();
  @$core.override
  BookSeriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BookSeriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BookSeriesRequest>(create);
  static BookSeriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startsAt => $_getN(2);
  @$pb.TagNumber(3)
  set startsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartsAt() => $_ensure(2);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  /// Seven for a weekly course, which is most of them.
  @$pb.TagNumber(5)
  $core.int get intervalDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set intervalDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIntervalDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearIntervalDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get occurrences => $_getIZ(5);
  @$pb.TagNumber(6)
  set occurrences($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOccurrences() => $_has(5);
  @$pb.TagNumber(6)
  void clearOccurrences() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);
}

class BookSeriesResponse extends $pb.GeneratedMessage {
  factory BookSeriesResponse({
    $core.String? seriesId,
    $core.Iterable<Appointment>? appointments,
    $core.Iterable<$0.Timestamp>? unavailable,
  }) {
    final result = create();
    if (seriesId != null) result.seriesId = seriesId;
    if (appointments != null) result.appointments.addAll(appointments);
    if (unavailable != null) result.unavailable.addAll(unavailable);
    return result;
  }

  BookSeriesResponse._();

  factory BookSeriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BookSeriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BookSeriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'seriesId')
    ..pPM<Appointment>(2, _omitFieldNames ? '' : 'appointments',
        subBuilder: Appointment.create)
    ..pPM<$0.Timestamp>(3, _omitFieldNames ? '' : 'unavailable',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookSeriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BookSeriesResponse copyWith(void Function(BookSeriesResponse) updates) =>
      super.copyWith((message) => updates(message as BookSeriesResponse))
          as BookSeriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BookSeriesResponse create() => BookSeriesResponse._();
  @$core.override
  BookSeriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BookSeriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BookSeriesResponse>(create);
  static BookSeriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get seriesId => $_getSZ(0);
  @$pb.TagNumber(1)
  set seriesId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeriesId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeriesId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Appointment> get appointments => $_getList(1);

  /// The occurrences whose slot was gone. Reported rather than refused: a
  /// twelve-week course where week seven is full is eleven appointments the
  /// patient should keep.
  @$pb.TagNumber(3)
  $pb.PbList<$0.Timestamp> get unavailable => $_getList(2);
}

class CancelSeriesRequest extends $pb.GeneratedMessage {
  factory CancelSeriesRequest({
    $core.String? seriesId,
    $core.String? fromAppointmentId,
    SeriesScope? scope,
    $core.String? reason,
  }) {
    final result = create();
    if (seriesId != null) result.seriesId = seriesId;
    if (fromAppointmentId != null) result.fromAppointmentId = fromAppointmentId;
    if (scope != null) result.scope = scope;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelSeriesRequest._();

  factory CancelSeriesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSeriesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSeriesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'seriesId')
    ..aOS(2, _omitFieldNames ? '' : 'fromAppointmentId')
    ..aE<SeriesScope>(3, _omitFieldNames ? '' : 'scope',
        enumValues: SeriesScope.values)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSeriesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSeriesRequest copyWith(void Function(CancelSeriesRequest) updates) =>
      super.copyWith((message) => updates(message as CancelSeriesRequest))
          as CancelSeriesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSeriesRequest create() => CancelSeriesRequest._();
  @$core.override
  CancelSeriesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSeriesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSeriesRequest>(create);
  static CancelSeriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get seriesId => $_getSZ(0);
  @$pb.TagNumber(1)
  set seriesId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSeriesId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeriesId() => $_clearField(1);

  /// The occurrence a future-occurrences change pivots on. Empty with
  /// FUTURE_OCCURRENCES means every remaining occurrence.
  @$pb.TagNumber(2)
  $core.String get fromAppointmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromAppointmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromAppointmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromAppointmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  SeriesScope get scope => $_getN(2);
  @$pb.TagNumber(3)
  set scope(SeriesScope value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScope() => $_has(2);
  @$pb.TagNumber(3)
  void clearScope() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class CancelSeriesResponse extends $pb.GeneratedMessage {
  factory CancelSeriesResponse({
    $core.Iterable<$core.String>? cancelledAppointmentIds,
  }) {
    final result = create();
    if (cancelledAppointmentIds != null)
      result.cancelledAppointmentIds.addAll(cancelledAppointmentIds);
    return result;
  }

  CancelSeriesResponse._();

  factory CancelSeriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelSeriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelSeriesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'cancelledAppointmentIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSeriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelSeriesResponse copyWith(void Function(CancelSeriesResponse) updates) =>
      super.copyWith((message) => updates(message as CancelSeriesResponse))
          as CancelSeriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelSeriesResponse create() => CancelSeriesResponse._();
  @$core.override
  CancelSeriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelSeriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelSeriesResponse>(create);
  static CancelSeriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get cancelledAppointmentIds => $_getList(0);
}

class WaitlistEntry extends $pb.GeneratedMessage {
  factory WaitlistEntry({
    $core.String? waitlistId,
    $core.String? patientId,
    $core.String? resourceId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    VisitType? visitType,
    $0.Timestamp? notBefore,
    $0.Timestamp? notAfter,
    $core.String? appointmentId,
    WaitlistStatus? status,
    $0.Timestamp? offeredSlotAt,
    $0.Timestamp? offerExpiresAt,
  }) {
    final result = create();
    if (waitlistId != null) result.waitlistId = waitlistId;
    if (patientId != null) result.patientId = patientId;
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (visitType != null) result.visitType = visitType;
    if (notBefore != null) result.notBefore = notBefore;
    if (notAfter != null) result.notAfter = notAfter;
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (status != null) result.status = status;
    if (offeredSlotAt != null) result.offeredSlotAt = offeredSlotAt;
    if (offerExpiresAt != null) result.offerExpiresAt = offerExpiresAt;
    return result;
  }

  WaitlistEntry._();

  factory WaitlistEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaitlistEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaitlistEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'waitlistId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'resourceId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<VisitType>(6, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'notBefore',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'notAfter',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'appointmentId')
    ..aE<WaitlistStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: WaitlistStatus.values)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'offeredSlotAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'offerExpiresAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaitlistEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaitlistEntry copyWith(void Function(WaitlistEntry) updates) =>
      super.copyWith((message) => updates(message as WaitlistEntry))
          as WaitlistEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaitlistEntry create() => WaitlistEntry._();
  @$core.override
  WaitlistEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WaitlistEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaitlistEntry>(create);
  static WaitlistEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waitlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set waitlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitlistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resourceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set resourceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResourceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearResourceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get orgUnitId => $_getSZ(4);
  @$pb.TagNumber(5)
  set orgUnitId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOrgUnitId() => $_has(4);
  @$pb.TagNumber(5)
  void clearOrgUnitId() => $_clearField(5);

  @$pb.TagNumber(6)
  VisitType get visitType => $_getN(5);
  @$pb.TagNumber(6)
  set visitType(VisitType value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVisitType() => $_has(5);
  @$pb.TagNumber(6)
  void clearVisitType() => $_clearField(6);

  /// A patient who cannot come before Thursday should not be offered Wednesday.
  @$pb.TagNumber(7)
  $0.Timestamp get notBefore => $_getN(6);
  @$pb.TagNumber(7)
  set notBefore($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNotBefore() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotBefore() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureNotBefore() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get notAfter => $_getN(7);
  @$pb.TagNumber(8)
  set notAfter($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasNotAfter() => $_has(7);
  @$pb.TagNumber(8)
  void clearNotAfter() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureNotAfter() => $_ensure(7);

  /// The booking this patient already holds, if any. An earlier slot accepted
  /// becomes a reschedule of it rather than a second booking.
  @$pb.TagNumber(9)
  $core.String get appointmentId => $_getSZ(8);
  @$pb.TagNumber(9)
  set appointmentId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAppointmentId() => $_has(8);
  @$pb.TagNumber(9)
  void clearAppointmentId() => $_clearField(9);

  @$pb.TagNumber(10)
  WaitlistStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(WaitlistStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get offeredSlotAt => $_getN(10);
  @$pb.TagNumber(11)
  set offeredSlotAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasOfferedSlotAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearOfferedSlotAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureOfferedSlotAt() => $_ensure(10);

  /// A slot promised to somebody who has stopped reading their messages is
  /// capacity nobody can use, so the offer expires.
  @$pb.TagNumber(12)
  $0.Timestamp get offerExpiresAt => $_getN(11);
  @$pb.TagNumber(12)
  set offerExpiresAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOfferExpiresAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearOfferExpiresAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureOfferExpiresAt() => $_ensure(11);
}

class JoinWaitlistRequest extends $pb.GeneratedMessage {
  factory JoinWaitlistRequest({
    $core.String? patientId,
    $core.String? resourceId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    VisitType? visitType,
    $0.Timestamp? notBefore,
    $0.Timestamp? notAfter,
    $core.String? appointmentId,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (visitType != null) result.visitType = visitType;
    if (notBefore != null) result.notBefore = notBefore;
    if (notAfter != null) result.notAfter = notAfter;
    if (appointmentId != null) result.appointmentId = appointmentId;
    return result;
  }

  JoinWaitlistRequest._();

  factory JoinWaitlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinWaitlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinWaitlistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'orgUnitId')
    ..aE<VisitType>(5, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'notBefore',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'notAfter',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'appointmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinWaitlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinWaitlistRequest copyWith(void Function(JoinWaitlistRequest) updates) =>
      super.copyWith((message) => updates(message as JoinWaitlistRequest))
          as JoinWaitlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinWaitlistRequest create() => JoinWaitlistRequest._();
  @$core.override
  JoinWaitlistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinWaitlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinWaitlistRequest>(create);
  static JoinWaitlistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orgUnitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orgUnitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrgUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrgUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  VisitType get visitType => $_getN(4);
  @$pb.TagNumber(5)
  set visitType(VisitType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasVisitType() => $_has(4);
  @$pb.TagNumber(5)
  void clearVisitType() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get notBefore => $_getN(5);
  @$pb.TagNumber(6)
  set notBefore($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNotBefore() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotBefore() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureNotBefore() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get notAfter => $_getN(6);
  @$pb.TagNumber(7)
  set notAfter($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasNotAfter() => $_has(6);
  @$pb.TagNumber(7)
  void clearNotAfter() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureNotAfter() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get appointmentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set appointmentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAppointmentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAppointmentId() => $_clearField(8);
}

class JoinWaitlistResponse extends $pb.GeneratedMessage {
  factory JoinWaitlistResponse({
    WaitlistEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  JoinWaitlistResponse._();

  factory JoinWaitlistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory JoinWaitlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JoinWaitlistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<WaitlistEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: WaitlistEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinWaitlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JoinWaitlistResponse copyWith(void Function(JoinWaitlistResponse) updates) =>
      super.copyWith((message) => updates(message as JoinWaitlistResponse))
          as JoinWaitlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JoinWaitlistResponse create() => JoinWaitlistResponse._();
  @$core.override
  JoinWaitlistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static JoinWaitlistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JoinWaitlistResponse>(create);
  static JoinWaitlistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WaitlistEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(WaitlistEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  WaitlistEntry ensureEntry() => $_ensure(0);
}

class OfferWaitlistSlotRequest extends $pb.GeneratedMessage {
  factory OfferWaitlistSlotRequest({
    $core.String? waitlistId,
    $core.String? resourceId,
    $0.Timestamp? startsAt,
    VisitType? visitType,
    $core.int? validForMinutes,
  }) {
    final result = create();
    if (waitlistId != null) result.waitlistId = waitlistId;
    if (resourceId != null) result.resourceId = resourceId;
    if (startsAt != null) result.startsAt = startsAt;
    if (visitType != null) result.visitType = visitType;
    if (validForMinutes != null) result.validForMinutes = validForMinutes;
    return result;
  }

  OfferWaitlistSlotRequest._();

  factory OfferWaitlistSlotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfferWaitlistSlotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferWaitlistSlotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'waitlistId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aE<VisitType>(4, _omitFieldNames ? '' : 'visitType',
        enumValues: VisitType.values)
    ..aI(5, _omitFieldNames ? '' : 'validForMinutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferWaitlistSlotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferWaitlistSlotRequest copyWith(
          void Function(OfferWaitlistSlotRequest) updates) =>
      super.copyWith((message) => updates(message as OfferWaitlistSlotRequest))
          as OfferWaitlistSlotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfferWaitlistSlotRequest create() => OfferWaitlistSlotRequest._();
  @$core.override
  OfferWaitlistSlotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OfferWaitlistSlotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferWaitlistSlotRequest>(create);
  static OfferWaitlistSlotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waitlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set waitlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitlistId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startsAt => $_getN(2);
  @$pb.TagNumber(3)
  set startsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartsAt() => $_ensure(2);

  @$pb.TagNumber(4)
  VisitType get visitType => $_getN(3);
  @$pb.TagNumber(4)
  set visitType(VisitType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasVisitType() => $_has(3);
  @$pb.TagNumber(4)
  void clearVisitType() => $_clearField(4);

  /// How long the offer stands. Zero takes the default.
  @$pb.TagNumber(5)
  $core.int get validForMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set validForMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValidForMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidForMinutes() => $_clearField(5);
}

class OfferWaitlistSlotResponse extends $pb.GeneratedMessage {
  factory OfferWaitlistSlotResponse({
    WaitlistEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  OfferWaitlistSlotResponse._();

  factory OfferWaitlistSlotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OfferWaitlistSlotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OfferWaitlistSlotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<WaitlistEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: WaitlistEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferWaitlistSlotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OfferWaitlistSlotResponse copyWith(
          void Function(OfferWaitlistSlotResponse) updates) =>
      super.copyWith((message) => updates(message as OfferWaitlistSlotResponse))
          as OfferWaitlistSlotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OfferWaitlistSlotResponse create() => OfferWaitlistSlotResponse._();
  @$core.override
  OfferWaitlistSlotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OfferWaitlistSlotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OfferWaitlistSlotResponse>(create);
  static OfferWaitlistSlotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WaitlistEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(WaitlistEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  WaitlistEntry ensureEntry() => $_ensure(0);
}

class AcceptWaitlistOfferRequest extends $pb.GeneratedMessage {
  factory AcceptWaitlistOfferRequest({
    $core.String? waitlistId,
  }) {
    final result = create();
    if (waitlistId != null) result.waitlistId = waitlistId;
    return result;
  }

  AcceptWaitlistOfferRequest._();

  factory AcceptWaitlistOfferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcceptWaitlistOfferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptWaitlistOfferRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'waitlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptWaitlistOfferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptWaitlistOfferRequest copyWith(
          void Function(AcceptWaitlistOfferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AcceptWaitlistOfferRequest))
          as AcceptWaitlistOfferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptWaitlistOfferRequest create() => AcceptWaitlistOfferRequest._();
  @$core.override
  AcceptWaitlistOfferRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcceptWaitlistOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptWaitlistOfferRequest>(create);
  static AcceptWaitlistOfferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waitlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set waitlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitlistId() => $_clearField(1);
}

class AcceptWaitlistOfferResponse extends $pb.GeneratedMessage {
  factory AcceptWaitlistOfferResponse({
    WaitlistEntry? entry,
    Appointment? appointment,
    $core.String? replacedAppointmentId,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    if (appointment != null) result.appointment = appointment;
    if (replacedAppointmentId != null)
      result.replacedAppointmentId = replacedAppointmentId;
    return result;
  }

  AcceptWaitlistOfferResponse._();

  factory AcceptWaitlistOfferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcceptWaitlistOfferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptWaitlistOfferResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<WaitlistEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: WaitlistEntry.create)
    ..aOM<Appointment>(2, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..aOS(3, _omitFieldNames ? '' : 'replacedAppointmentId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptWaitlistOfferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptWaitlistOfferResponse copyWith(
          void Function(AcceptWaitlistOfferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AcceptWaitlistOfferResponse))
          as AcceptWaitlistOfferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptWaitlistOfferResponse create() =>
      AcceptWaitlistOfferResponse._();
  @$core.override
  AcceptWaitlistOfferResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcceptWaitlistOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptWaitlistOfferResponse>(create);
  static AcceptWaitlistOfferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WaitlistEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(WaitlistEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  WaitlistEntry ensureEntry() => $_ensure(0);

  @$pb.TagNumber(2)
  Appointment get appointment => $_getN(1);
  @$pb.TagNumber(2)
  set appointment(Appointment value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAppointment() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppointment() => $_clearField(2);
  @$pb.TagNumber(2)
  Appointment ensureAppointment() => $_ensure(1);

  /// The appointment the patient gave up, if any. Cancelled rather than left
  /// standing: two confirmed bookings is exactly what SRS-SCH-006 forbids.
  @$pb.TagNumber(3)
  $core.String get replacedAppointmentId => $_getSZ(2);
  @$pb.TagNumber(3)
  set replacedAppointmentId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReplacedAppointmentId() => $_has(2);
  @$pb.TagNumber(3)
  void clearReplacedAppointmentId() => $_clearField(3);
}

class DeclineWaitlistOfferRequest extends $pb.GeneratedMessage {
  factory DeclineWaitlistOfferRequest({
    $core.String? waitlistId,
  }) {
    final result = create();
    if (waitlistId != null) result.waitlistId = waitlistId;
    return result;
  }

  DeclineWaitlistOfferRequest._();

  factory DeclineWaitlistOfferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclineWaitlistOfferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclineWaitlistOfferRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'waitlistId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclineWaitlistOfferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclineWaitlistOfferRequest copyWith(
          void Function(DeclineWaitlistOfferRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeclineWaitlistOfferRequest))
          as DeclineWaitlistOfferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclineWaitlistOfferRequest create() =>
      DeclineWaitlistOfferRequest._();
  @$core.override
  DeclineWaitlistOfferRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclineWaitlistOfferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclineWaitlistOfferRequest>(create);
  static DeclineWaitlistOfferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get waitlistId => $_getSZ(0);
  @$pb.TagNumber(1)
  set waitlistId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWaitlistId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWaitlistId() => $_clearField(1);
}

class DeclineWaitlistOfferResponse extends $pb.GeneratedMessage {
  factory DeclineWaitlistOfferResponse({
    WaitlistEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  DeclineWaitlistOfferResponse._();

  factory DeclineWaitlistOfferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclineWaitlistOfferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclineWaitlistOfferResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<WaitlistEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: WaitlistEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclineWaitlistOfferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclineWaitlistOfferResponse copyWith(
          void Function(DeclineWaitlistOfferResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DeclineWaitlistOfferResponse))
          as DeclineWaitlistOfferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclineWaitlistOfferResponse create() =>
      DeclineWaitlistOfferResponse._();
  @$core.override
  DeclineWaitlistOfferResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclineWaitlistOfferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclineWaitlistOfferResponse>(create);
  static DeclineWaitlistOfferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WaitlistEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(WaitlistEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  WaitlistEntry ensureEntry() => $_ensure(0);
}

class ListWaitlistRequest extends $pb.GeneratedMessage {
  factory ListWaitlistRequest({
    $core.String? resourceId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (resourceId != null) result.resourceId = resourceId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListWaitlistRequest._();

  factory ListWaitlistRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaitlistRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaitlistRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'resourceId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitlistRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitlistRequest copyWith(void Function(ListWaitlistRequest) updates) =>
      super.copyWith((message) => updates(message as ListWaitlistRequest))
          as ListWaitlistRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaitlistRequest create() => ListWaitlistRequest._();
  @$core.override
  ListWaitlistRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWaitlistRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaitlistRequest>(create);
  static ListWaitlistRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get resourceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set resourceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResourceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearResourceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListWaitlistResponse extends $pb.GeneratedMessage {
  factory ListWaitlistResponse({
    $core.Iterable<WaitlistEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  ListWaitlistResponse._();

  factory ListWaitlistResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWaitlistResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWaitlistResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPM<WaitlistEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: WaitlistEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitlistResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWaitlistResponse copyWith(void Function(ListWaitlistResponse) updates) =>
      super.copyWith((message) => updates(message as ListWaitlistResponse))
          as ListWaitlistResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWaitlistResponse create() => ListWaitlistResponse._();
  @$core.override
  ListWaitlistResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWaitlistResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWaitlistResponse>(create);
  static ListWaitlistResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WaitlistEntry> get entries => $_getList(0);
}

class ExpireWaitlistOffersRequest extends $pb.GeneratedMessage {
  factory ExpireWaitlistOffersRequest() => create();

  ExpireWaitlistOffersRequest._();

  factory ExpireWaitlistOffersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExpireWaitlistOffersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpireWaitlistOffersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpireWaitlistOffersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpireWaitlistOffersRequest copyWith(
          void Function(ExpireWaitlistOffersRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ExpireWaitlistOffersRequest))
          as ExpireWaitlistOffersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExpireWaitlistOffersRequest create() =>
      ExpireWaitlistOffersRequest._();
  @$core.override
  ExpireWaitlistOffersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExpireWaitlistOffersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExpireWaitlistOffersRequest>(create);
  static ExpireWaitlistOffersRequest? _defaultInstance;
}

class ExpireWaitlistOffersResponse extends $pb.GeneratedMessage {
  factory ExpireWaitlistOffersResponse({
    $fixnum.Int64? expired,
  }) {
    final result = create();
    if (expired != null) result.expired = expired;
    return result;
  }

  ExpireWaitlistOffersResponse._();

  factory ExpireWaitlistOffersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ExpireWaitlistOffersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ExpireWaitlistOffersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'expired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpireWaitlistOffersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ExpireWaitlistOffersResponse copyWith(
          void Function(ExpireWaitlistOffersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ExpireWaitlistOffersResponse))
          as ExpireWaitlistOffersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExpireWaitlistOffersResponse create() =>
      ExpireWaitlistOffersResponse._();
  @$core.override
  ExpireWaitlistOffersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ExpireWaitlistOffersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ExpireWaitlistOffersResponse>(create);
  static ExpireWaitlistOffersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get expired => $_getI64(0);
  @$pb.TagNumber(1)
  set expired($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExpired() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpired() => $_clearField(1);
}

class CheckInRequest extends $pb.GeneratedMessage {
  factory CheckInRequest({
    $core.String? appointmentId,
    $core.String? token,
    ArrivalMode? arrivalMode,
    Priority? priority,
    $core.String? priorityReason,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (token != null) result.token = token;
    if (arrivalMode != null) result.arrivalMode = arrivalMode;
    if (priority != null) result.priority = priority;
    if (priorityReason != null) result.priorityReason = priorityReason;
    return result;
  }

  CheckInRequest._();

  factory CheckInRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(2, _omitFieldNames ? '' : 'token')
    ..aE<ArrivalMode>(3, _omitFieldNames ? '' : 'arrivalMode',
        enumValues: ArrivalMode.values)
    ..aE<Priority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(5, _omitFieldNames ? '' : 'priorityReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInRequest copyWith(void Function(CheckInRequest) updates) =>
      super.copyWith((message) => updates(message as CheckInRequest))
          as CheckInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInRequest create() => CheckInRequest._();
  @$core.override
  CheckInRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInRequest>(create);
  static CheckInRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  /// What the patient will be called by. Left empty the server issues the next
  /// queue number for the facility today, which is what most desks want; a
  /// clinic running its own numbering scheme supplies its own.
  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => $_clearField(2);

  @$pb.TagNumber(3)
  ArrivalMode get arrivalMode => $_getN(2);
  @$pb.TagNumber(3)
  set arrivalMode(ArrivalMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasArrivalMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearArrivalMode() => $_clearField(3);

  /// Unspecified means standard.
  @$pb.TagNumber(4)
  Priority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(Priority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  /// Required whenever the priority is not standard: a walk-in put straight to
  /// the front without one is indistinguishable from queue-jumping.
  @$pb.TagNumber(5)
  $core.String get priorityReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set priorityReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPriorityReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriorityReason() => $_clearField(5);
}

class CheckInResponse extends $pb.GeneratedMessage {
  factory CheckInResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  CheckInResponse._();

  factory CheckInResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckInResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckInResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckInResponse copyWith(void Function(CheckInResponse) updates) =>
      super.copyWith((message) => updates(message as CheckInResponse))
          as CheckInResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckInResponse create() => CheckInResponse._();
  @$core.override
  CheckInResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckInResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckInResponse>(create);
  static CheckInResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

class AdvanceAppointmentRequest extends $pb.GeneratedMessage {
  factory AdvanceAppointmentRequest({
    $core.String? appointmentId,
    AppointmentStatus? to,
    $core.String? reason,
    $core.bool? correction,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (to != null) result.to = to;
    if (reason != null) result.reason = reason;
    if (correction != null) result.correction = correction;
    return result;
  }

  AdvanceAppointmentRequest._();

  factory AdvanceAppointmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceAppointmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceAppointmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aE<AppointmentStatus>(2, _omitFieldNames ? '' : 'to',
        enumValues: AppointmentStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOB(4, _omitFieldNames ? '' : 'correction')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceAppointmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceAppointmentRequest copyWith(
          void Function(AdvanceAppointmentRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceAppointmentRequest))
          as AdvanceAppointmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceAppointmentRequest create() => AdvanceAppointmentRequest._();
  @$core.override
  AdvanceAppointmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceAppointmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceAppointmentRequest>(create);
  static AdvanceAppointmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  AppointmentStatus get to => $_getN(1);
  @$pb.TagNumber(2)
  set to(AppointmentStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

  /// Required for cancellation and no-show, which can cost the patient money,
  /// and for every correction.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  /// A transition the machine would otherwise refuse, under the "unless
  /// authorized correction" clause of SRS-SCH-008. Needs its own permission.
  @$pb.TagNumber(4)
  $core.bool get correction => $_getBF(3);
  @$pb.TagNumber(4)
  set correction($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCorrection() => $_has(3);
  @$pb.TagNumber(4)
  void clearCorrection() => $_clearField(4);
}

class AdvanceAppointmentResponse extends $pb.GeneratedMessage {
  factory AdvanceAppointmentResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  AdvanceAppointmentResponse._();

  factory AdvanceAppointmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceAppointmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceAppointmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceAppointmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceAppointmentResponse copyWith(
          void Function(AdvanceAppointmentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AdvanceAppointmentResponse))
          as AdvanceAppointmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceAppointmentResponse create() => AdvanceAppointmentResponse._();
  @$core.override
  AdvanceAppointmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceAppointmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceAppointmentResponse>(create);
  static AdvanceAppointmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

class ReprioritiseRequest extends $pb.GeneratedMessage {
  factory ReprioritiseRequest({
    $core.String? appointmentId,
    Priority? priority,
    $core.String? reason,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (priority != null) result.priority = priority;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReprioritiseRequest._();

  factory ReprioritiseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReprioritiseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprioritiseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aE<Priority>(2, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseRequest copyWith(void Function(ReprioritiseRequest) updates) =>
      super.copyWith((message) => updates(message as ReprioritiseRequest))
          as ReprioritiseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReprioritiseRequest create() => ReprioritiseRequest._();
  @$core.override
  ReprioritiseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReprioritiseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReprioritiseRequest>(create);
  static ReprioritiseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  Priority get priority => $_getN(1);
  @$pb.TagNumber(2)
  set priority(Priority value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => $_clearField(2);

  /// Mandatory, and shown to queue users rather than buried in an audit table
  /// (SRS-SCH-011).
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class ReprioritiseResponse extends $pb.GeneratedMessage {
  factory ReprioritiseResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  ReprioritiseResponse._();

  factory ReprioritiseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReprioritiseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReprioritiseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReprioritiseResponse copyWith(void Function(ReprioritiseResponse) updates) =>
      super.copyWith((message) => updates(message as ReprioritiseResponse))
          as ReprioritiseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReprioritiseResponse create() => ReprioritiseResponse._();
  @$core.override
  ReprioritiseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReprioritiseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReprioritiseResponse>(create);
  static ReprioritiseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

/// One patient's place in a queue.
class QueuePosition extends $pb.GeneratedMessage {
  factory QueuePosition({
    Appointment? appointment,
    $core.int? position,
    $fixnum.Int64? estimatedWaitSeconds,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    if (position != null) result.position = position;
    if (estimatedWaitSeconds != null)
      result.estimatedWaitSeconds = estimatedWaitSeconds;
    return result;
  }

  QueuePosition._();

  factory QueuePosition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QueuePosition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueuePosition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..aI(2, _omitFieldNames ? '' : 'position')
    ..aInt64(3, _omitFieldNames ? '' : 'estimatedWaitSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueuePosition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueuePosition copyWith(void Function(QueuePosition) updates) =>
      super.copyWith((message) => updates(message as QueuePosition))
          as QueuePosition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueuePosition create() => QueuePosition._();
  @$core.override
  QueuePosition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QueuePosition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueuePosition>(create);
  static QueuePosition? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);

  /// From 1, in the order patients will actually be called.
  @$pb.TagNumber(2)
  $core.int get position => $_getIZ(1);
  @$pb.TagNumber(2)
  set position($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);

  /// How long this patient is likely to wait, in seconds. An estimate, and
  /// labelled as one everywhere it appears (SRS-SCH-009).
  @$pb.TagNumber(3)
  $fixnum.Int64 get estimatedWaitSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set estimatedWaitSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEstimatedWaitSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearEstimatedWaitSeconds() => $_clearField(3);
}

/// The arithmetic behind a waiting time (SRS-SCH-009).
///
/// Returned alongside the queue so a display can say *why* — "about forty
/// minutes, based on four patients ahead and ten minutes each" is something a
/// person can judge; "about forty minutes" is something they can only believe or
/// disbelieve.
class QueueEstimate extends $pb.GeneratedMessage {
  factory QueueEstimate({
    $core.double? serviceMinutes,
    $core.bool? observed,
    $core.int? activeClinicians,
  }) {
    final result = create();
    if (serviceMinutes != null) result.serviceMinutes = serviceMinutes;
    if (observed != null) result.observed = observed;
    if (activeClinicians != null) result.activeClinicians = activeClinicians;
    return result;
  }

  QueueEstimate._();

  factory QueueEstimate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QueueEstimate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QueueEstimate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'serviceMinutes')
    ..aOB(2, _omitFieldNames ? '' : 'observed')
    ..aI(3, _omitFieldNames ? '' : 'activeClinicians')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueueEstimate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QueueEstimate copyWith(void Function(QueueEstimate) updates) =>
      super.copyWith((message) => updates(message as QueueEstimate))
          as QueueEstimate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueueEstimate create() => QueueEstimate._();
  @$core.override
  QueueEstimate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QueueEstimate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueueEstimate>(create);
  static QueueEstimate? _defaultInstance;

  /// The observed average this session, falling back to the rostered slot length
  /// when too little has happened to observe anything.
  @$pb.TagNumber(1)
  $core.double get serviceMinutes => $_getN(0);
  @$pb.TagNumber(1)
  set serviceMinutes($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceMinutes() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceMinutes() => $_clearField(1);

  /// True when the service rate came from consultations actually completed
  /// today, rather than from the roster. A display should be more tentative
  /// about the second.
  @$pb.TagNumber(2)
  $core.bool get observed => $_getBF(1);
  @$pb.TagNumber(2)
  set observed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObserved() => $_has(1);
  @$pb.TagNumber(2)
  void clearObserved() => $_clearField(2);

  /// Two clinicians running a list halve the wait, and an estimate that ignored
  /// them would be wrong by a factor of two on exactly the busiest days.
  @$pb.TagNumber(3)
  $core.int get activeClinicians => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeClinicians($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveClinicians() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveClinicians() => $_clearField(3);
}

class GetQueueRequest extends $pb.GeneratedMessage {
  factory GetQueueRequest({
    $core.String? facilityId,
    $core.String? resourceId,
    $0.Timestamp? from,
    $0.Timestamp? until,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (resourceId != null) result.resourceId = resourceId;
    if (from != null) result.from = from;
    if (until != null) result.until = until;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetQueueRequest._();

  factory GetQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'until',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueRequest copyWith(void Function(GetQueueRequest) updates) =>
      super.copyWith((message) => updates(message as GetQueueRequest))
          as GetQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetQueueRequest create() => GetQueueRequest._();
  @$core.override
  GetQueueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetQueueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQueueRequest>(create);
  static GetQueueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  /// Narrows to one clinician's queue. Empty means the facility's.
  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  /// Empty defaults to the current day in UTC, which is the queue a board shows.
  @$pb.TagNumber(3)
  $0.Timestamp get from => $_getN(2);
  @$pb.TagNumber(3)
  set from($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFrom() => $_has(2);
  @$pb.TagNumber(3)
  void clearFrom() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureFrom() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get until => $_getN(3);
  @$pb.TagNumber(4)
  set until($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUntil() => $_has(3);
  @$pb.TagNumber(4)
  void clearUntil() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureUntil() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class GetQueueResponse extends $pb.GeneratedMessage {
  factory GetQueueResponse({
    $core.Iterable<QueuePosition>? positions,
    QueueEstimate? estimate,
  }) {
    final result = create();
    if (positions != null) result.positions.addAll(positions);
    if (estimate != null) result.estimate = estimate;
    return result;
  }

  GetQueueResponse._();

  factory GetQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPM<QueuePosition>(1, _omitFieldNames ? '' : 'positions',
        subBuilder: QueuePosition.create)
    ..aOM<QueueEstimate>(2, _omitFieldNames ? '' : 'estimate',
        subBuilder: QueueEstimate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetQueueResponse copyWith(void Function(GetQueueResponse) updates) =>
      super.copyWith((message) => updates(message as GetQueueResponse))
          as GetQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetQueueResponse create() => GetQueueResponse._();
  @$core.override
  GetQueueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetQueueResponse>(create);
  static GetQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<QueuePosition> get positions => $_getList(0);

  @$pb.TagNumber(2)
  QueueEstimate get estimate => $_getN(1);
  @$pb.TagNumber(2)
  set estimate(QueueEstimate value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEstimate() => $_has(1);
  @$pb.TagNumber(2)
  void clearEstimate() => $_clearField(2);
  @$pb.TagNumber(2)
  QueueEstimate ensureEstimate() => $_ensure(1);
}

class RegisterWalkInRequest extends $pb.GeneratedMessage {
  factory RegisterWalkInRequest({
    $core.String? patientId,
    $core.String? resourceId,
    $core.String? facilityId,
    $core.String? orgUnitId,
    $core.String? token,
    ArrivalMode? arrivalMode,
    Priority? priority,
    $core.String? priorityReason,
    $core.String? reason,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (resourceId != null) result.resourceId = resourceId;
    if (facilityId != null) result.facilityId = facilityId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (token != null) result.token = token;
    if (arrivalMode != null) result.arrivalMode = arrivalMode;
    if (priority != null) result.priority = priority;
    if (priorityReason != null) result.priorityReason = priorityReason;
    if (reason != null) result.reason = reason;
    return result;
  }

  RegisterWalkInRequest._();

  factory RegisterWalkInRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterWalkInRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterWalkInRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'resourceId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(5, _omitFieldNames ? '' : 'token')
    ..aE<ArrivalMode>(6, _omitFieldNames ? '' : 'arrivalMode',
        enumValues: ArrivalMode.values)
    ..aE<Priority>(7, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(8, _omitFieldNames ? '' : 'priorityReason')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterWalkInRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterWalkInRequest copyWith(
          void Function(RegisterWalkInRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterWalkInRequest))
          as RegisterWalkInRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterWalkInRequest create() => RegisterWalkInRequest._();
  @$core.override
  RegisterWalkInRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterWalkInRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterWalkInRequest>(create);
  static RegisterWalkInRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  /// The clinician or room they will be seen by. Optional: a busy department
  /// triages first and allocates afterwards.
  @$pb.TagNumber(2)
  $core.String get resourceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set resourceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResourceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearResourceId() => $_clearField(2);

  /// Required when no resource is named.
  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get orgUnitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orgUnitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrgUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrgUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get token => $_getSZ(4);
  @$pb.TagNumber(5)
  set token($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasToken() => $_has(4);
  @$pb.TagNumber(5)
  void clearToken() => $_clearField(5);

  /// Defaults to walk-in, and worth stating when it is not.
  @$pb.TagNumber(6)
  ArrivalMode get arrivalMode => $_getN(5);
  @$pb.TagNumber(6)
  set arrivalMode(ArrivalMode value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasArrivalMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearArrivalMode() => $_clearField(6);

  @$pb.TagNumber(7)
  Priority get priority => $_getN(6);
  @$pb.TagNumber(7)
  set priority(Priority value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPriority() => $_has(6);
  @$pb.TagNumber(7)
  void clearPriority() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get priorityReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set priorityReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPriorityReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearPriorityReason() => $_clearField(8);

  /// Why they are here. Required: it is the first thing whoever triages the
  /// queue needs (SRS-SCH-010).
  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);
}

class RegisterWalkInResponse extends $pb.GeneratedMessage {
  factory RegisterWalkInResponse({
    Appointment? appointment,
  }) {
    final result = create();
    if (appointment != null) result.appointment = appointment;
    return result;
  }

  RegisterWalkInResponse._();

  factory RegisterWalkInResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterWalkInResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterWalkInResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Appointment>(1, _omitFieldNames ? '' : 'appointment',
        subBuilder: Appointment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterWalkInResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterWalkInResponse copyWith(
          void Function(RegisterWalkInResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterWalkInResponse))
          as RegisterWalkInResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterWalkInResponse create() => RegisterWalkInResponse._();
  @$core.override
  RegisterWalkInResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterWalkInResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterWalkInResponse>(create);
  static RegisterWalkInResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Appointment get appointment => $_getN(0);
  @$pb.TagNumber(1)
  set appointment(Appointment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointment() => $_clearField(1);
  @$pb.TagNumber(1)
  Appointment ensureAppointment() => $_ensure(0);
}

/// One message about one appointment or one waiting-list offer (SRS-SCH-012).
class Notification extends $pb.GeneratedMessage {
  factory Notification({
    $core.String? notificationId,
    $core.String? appointmentId,
    $core.String? waitlistId,
    $core.String? patientId,
    NotificationKind? kind,
    $core.String? channel,
    DeliveryOutcome? outcome,
    $core.String? detail,
    $0.Timestamp? sendAfter,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId = notificationId;
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (waitlistId != null) result.waitlistId = waitlistId;
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (channel != null) result.channel = channel;
    if (outcome != null) result.outcome = outcome;
    if (detail != null) result.detail = detail;
    if (sendAfter != null) result.sendAfter = sendAfter;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Notification._();

  factory Notification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Notification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Notification',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'notificationId')
    ..aOS(2, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(3, _omitFieldNames ? '' : 'waitlistId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aE<NotificationKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: NotificationKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'channel')
    ..aE<DeliveryOutcome>(7, _omitFieldNames ? '' : 'outcome',
        enumValues: DeliveryOutcome.values)
    ..aOS(8, _omitFieldNames ? '' : 'detail')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'sendAfter',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Notification copyWith(void Function(Notification) updates) =>
      super.copyWith((message) => updates(message as Notification))
          as Notification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Notification create() => Notification._();
  @$core.override
  Notification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Notification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Notification>(create);
  static Notification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);

  /// One of the two is set. A waitlist offer is about an offer rather than about
  /// a booking: there is no appointment yet.
  @$pb.TagNumber(2)
  $core.String get appointmentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set appointmentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppointmentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppointmentId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get waitlistId => $_getSZ(2);
  @$pb.TagNumber(3)
  set waitlistId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWaitlistId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWaitlistId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  NotificationKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(NotificationKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  /// How it was sent — "sms", "email". A string rather than an enum because the
  /// set is the notification service's to know.
  @$pb.TagNumber(6)
  $core.String get channel => $_getSZ(5);
  @$pb.TagNumber(6)
  set channel($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasChannel() => $_has(5);
  @$pb.TagNumber(6)
  void clearChannel() => $_clearField(6);

  @$pb.TagNumber(7)
  DeliveryOutcome get outcome => $_getN(6);
  @$pb.TagNumber(7)
  set outcome(DeliveryOutcome value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOutcome() => $_has(6);
  @$pb.TagNumber(7)
  void clearOutcome() => $_clearField(7);

  /// Explains a failure or a suppression in a sentence somebody at a desk can
  /// act on.
  @$pb.TagNumber(8)
  $core.String get detail => $_getSZ(7);
  @$pb.TagNumber(8)
  set detail($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDetail() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetail() => $_clearField(8);

  /// When the message becomes due. Set for a reminder; unset for anything that
  /// goes immediately.
  @$pb.TagNumber(9)
  $0.Timestamp get sendAfter => $_getN(8);
  @$pb.TagNumber(9)
  set sendAfter($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSendAfter() => $_has(8);
  @$pb.TagNumber(9)
  void clearSendAfter() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureSendAfter() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureUpdatedAt() => $_ensure(10);
}

class RecordDeliveryOutcomeRequest extends $pb.GeneratedMessage {
  factory RecordDeliveryOutcomeRequest({
    $core.String? notificationId,
    DeliveryOutcome? outcome,
    $core.String? detail,
  }) {
    final result = create();
    if (notificationId != null) result.notificationId = notificationId;
    if (outcome != null) result.outcome = outcome;
    if (detail != null) result.detail = detail;
    return result;
  }

  RecordDeliveryOutcomeRequest._();

  factory RecordDeliveryOutcomeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeliveryOutcomeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeliveryOutcomeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'notificationId')
    ..aE<DeliveryOutcome>(2, _omitFieldNames ? '' : 'outcome',
        enumValues: DeliveryOutcome.values)
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeliveryOutcomeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeliveryOutcomeRequest copyWith(
          void Function(RecordDeliveryOutcomeRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordDeliveryOutcomeRequest))
          as RecordDeliveryOutcomeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeliveryOutcomeRequest create() =>
      RecordDeliveryOutcomeRequest._();
  @$core.override
  RecordDeliveryOutcomeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeliveryOutcomeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeliveryOutcomeRequest>(create);
  static RecordDeliveryOutcomeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get notificationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set notificationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNotificationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotificationId() => $_clearField(1);

  @$pb.TagNumber(2)
  DeliveryOutcome get outcome => $_getN(1);
  @$pb.TagNumber(2)
  set outcome(DeliveryOutcome value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOutcome() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutcome() => $_clearField(2);

  /// Required for a failure or a suppression: "failed" alone tells a desk
  /// nothing they can act on.
  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);
}

class RecordDeliveryOutcomeResponse extends $pb.GeneratedMessage {
  factory RecordDeliveryOutcomeResponse({
    Notification? notification,
  }) {
    final result = create();
    if (notification != null) result.notification = notification;
    return result;
  }

  RecordDeliveryOutcomeResponse._();

  factory RecordDeliveryOutcomeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeliveryOutcomeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeliveryOutcomeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOM<Notification>(1, _omitFieldNames ? '' : 'notification',
        subBuilder: Notification.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeliveryOutcomeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeliveryOutcomeResponse copyWith(
          void Function(RecordDeliveryOutcomeResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordDeliveryOutcomeResponse))
          as RecordDeliveryOutcomeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeliveryOutcomeResponse create() =>
      RecordDeliveryOutcomeResponse._();
  @$core.override
  RecordDeliveryOutcomeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeliveryOutcomeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeliveryOutcomeResponse>(create);
  static RecordDeliveryOutcomeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Notification get notification => $_getN(0);
  @$pb.TagNumber(1)
  set notification(Notification value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotification() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotification() => $_clearField(1);
  @$pb.TagNumber(1)
  Notification ensureNotification() => $_ensure(0);
}

class ListNotificationsRequest extends $pb.GeneratedMessage {
  factory ListNotificationsRequest({
    $core.String? appointmentId,
    $core.String? waitlistId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (appointmentId != null) result.appointmentId = appointmentId;
    if (waitlistId != null) result.waitlistId = waitlistId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListNotificationsRequest._();

  factory ListNotificationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotificationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotificationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appointmentId')
    ..aOS(2, _omitFieldNames ? '' : 'waitlistId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsRequest copyWith(
          void Function(ListNotificationsRequest) updates) =>
      super.copyWith((message) => updates(message as ListNotificationsRequest))
          as ListNotificationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotificationsRequest create() => ListNotificationsRequest._();
  @$core.override
  ListNotificationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotificationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotificationsRequest>(create);
  static ListNotificationsRequest? _defaultInstance;

  /// Either names one subject. Both empty returns the queue of messages still
  /// waiting to go out.
  @$pb.TagNumber(1)
  $core.String get appointmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set appointmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppointmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppointmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get waitlistId => $_getSZ(1);
  @$pb.TagNumber(2)
  set waitlistId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWaitlistId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWaitlistId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListNotificationsResponse extends $pb.GeneratedMessage {
  factory ListNotificationsResponse({
    $core.Iterable<Notification>? notifications,
  }) {
    final result = create();
    if (notifications != null) result.notifications.addAll(notifications);
    return result;
  }

  ListNotificationsResponse._();

  factory ListNotificationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNotificationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNotificationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.scheduling.v1'),
      createEmptyInstance: create)
    ..pPM<Notification>(1, _omitFieldNames ? '' : 'notifications',
        subBuilder: Notification.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNotificationsResponse copyWith(
          void Function(ListNotificationsResponse) updates) =>
      super.copyWith((message) => updates(message as ListNotificationsResponse))
          as ListNotificationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNotificationsResponse create() => ListNotificationsResponse._();
  @$core.override
  ListNotificationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNotificationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNotificationsResponse>(create);
  static ListNotificationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Notification> get notifications => $_getList(0);
}

class AppointmentServiceApi {
  final $pb.RpcClient _client;

  AppointmentServiceApi(this._client);

  /// SRS-SCH-001. Rosters are configuration: defining when a clinic runs is
  /// deliberately not bundled with looking inside the diary at who is coming.
  $async.Future<DefineResourceResponse> defineResource(
          $pb.ClientContext? ctx, DefineResourceRequest request) =>
      _client.invoke<DefineResourceResponse>(ctx, 'AppointmentService',
          'DefineResource', request, DefineResourceResponse());
  $async.Future<SetResourceStatusResponse> setResourceStatus(
          $pb.ClientContext? ctx, SetResourceStatusRequest request) =>
      _client.invoke<SetResourceStatusResponse>(ctx, 'AppointmentService',
          'SetResourceStatus', request, SetResourceStatusResponse());
  $async.Future<DefineScheduleResponse> defineSchedule(
          $pb.ClientContext? ctx, DefineScheduleRequest request) =>
      _client.invoke<DefineScheduleResponse>(ctx, 'AppointmentService',
          'DefineSchedule', request, DefineScheduleResponse());

  /// SRS-SCH-002. Blocked capacity cannot be booked without the override
  /// permission, and leave cannot be overridden at all.
  $async.Future<BlockPeriodResponse> blockPeriod(
          $pb.ClientContext? ctx, BlockPeriodRequest request) =>
      _client.invoke<BlockPeriodResponse>(ctx, 'AppointmentService',
          'BlockPeriod', request, BlockPeriodResponse());
  $async.Future<UnblockPeriodResponse> unblockPeriod(
          $pb.ClientContext? ctx, UnblockPeriodRequest request) =>
      _client.invoke<UnblockPeriodResponse>(ctx, 'AppointmentService',
          'UnblockPeriod', request, UnblockPeriodResponse());

  /// SRS-SCH-003. Only bookable capacity is returned, generated from the roster
  /// as it is now rather than from a cache that goes stale the moment it changes.
  $async.Future<SearchSlotsResponse> searchSlots(
          $pb.ClientContext? ctx, SearchSlotsRequest request) =>
      _client.invoke<SearchSlotsResponse>(ctx, 'AppointmentService',
          'SearchSlots', request, SearchSlotsResponse());

  /// SRS-SCH-004. Atomic, and incapable of exceeding configured capacity under
  /// concurrency.
  $async.Future<BookAppointmentResponse> bookAppointment(
          $pb.ClientContext? ctx, BookAppointmentRequest request) =>
      _client.invoke<BookAppointmentResponse>(ctx, 'AppointmentService',
          'BookAppointment', request, BookAppointmentResponse());

  /// SRS-SCH-005. Reschedule and cancel under a policy-driven cutoff. The
  /// original retains its status history: a patient disputing an attendance
  /// record needs to see that the 9th was moved rather than that it silently
  /// became the 16th.
  $async.Future<CancelAppointmentResponse> cancelAppointment(
          $pb.ClientContext? ctx, CancelAppointmentRequest request) =>
      _client.invoke<CancelAppointmentResponse>(ctx, 'AppointmentService',
          'CancelAppointment', request, CancelAppointmentResponse());
  $async.Future<RescheduleAppointmentResponse> rescheduleAppointment(
          $pb.ClientContext? ctx, RescheduleAppointmentRequest request) =>
      _client.invoke<RescheduleAppointmentResponse>(ctx, 'AppointmentService',
          'RescheduleAppointment', request, RescheduleAppointmentResponse());
  $async.Future<SetSchedulingPolicyResponse> setSchedulingPolicy(
          $pb.ClientContext? ctx, SetSchedulingPolicyRequest request) =>
      _client.invoke<SetSchedulingPolicyResponse>(ctx, 'AppointmentService',
          'SetSchedulingPolicy', request, SetSchedulingPolicyResponse());

  /// SRS-SCH-013. A change affects one occurrence or every future one, and never
  /// a past one.
  $async.Future<BookSeriesResponse> bookSeries(
          $pb.ClientContext? ctx, BookSeriesRequest request) =>
      _client.invoke<BookSeriesResponse>(ctx, 'AppointmentService',
          'BookSeries', request, BookSeriesResponse());
  $async.Future<CancelSeriesResponse> cancelSeries(
          $pb.ClientContext? ctx, CancelSeriesRequest request) =>
      _client.invoke<CancelSeriesResponse>(ctx, 'AppointmentService',
          'CancelSeries', request, CancelSeriesResponse());

  /// SRS-SCH-006. An offer holds a slot for a stated period and then stops. It
  /// never consumes the slot: capacity held for somebody who has stopped
  /// reading their messages is capacity nobody can use and nobody can see is
  /// gone.
  $async.Future<JoinWaitlistResponse> joinWaitlist(
          $pb.ClientContext? ctx, JoinWaitlistRequest request) =>
      _client.invoke<JoinWaitlistResponse>(ctx, 'AppointmentService',
          'JoinWaitlist', request, JoinWaitlistResponse());
  $async.Future<OfferWaitlistSlotResponse> offerWaitlistSlot(
          $pb.ClientContext? ctx, OfferWaitlistSlotRequest request) =>
      _client.invoke<OfferWaitlistSlotResponse>(ctx, 'AppointmentService',
          'OfferWaitlistSlot', request, OfferWaitlistSlotResponse());
  $async.Future<AcceptWaitlistOfferResponse> acceptWaitlistOffer(
          $pb.ClientContext? ctx, AcceptWaitlistOfferRequest request) =>
      _client.invoke<AcceptWaitlistOfferResponse>(ctx, 'AppointmentService',
          'AcceptWaitlistOffer', request, AcceptWaitlistOfferResponse());
  $async.Future<DeclineWaitlistOfferResponse> declineWaitlistOffer(
          $pb.ClientContext? ctx, DeclineWaitlistOfferRequest request) =>
      _client.invoke<DeclineWaitlistOfferResponse>(ctx, 'AppointmentService',
          'DeclineWaitlistOffer', request, DeclineWaitlistOfferResponse());
  $async.Future<ListWaitlistResponse> listWaitlist(
          $pb.ClientContext? ctx, ListWaitlistRequest request) =>
      _client.invoke<ListWaitlistResponse>(ctx, 'AppointmentService',
          'ListWaitlist', request, ListWaitlistResponse());
  $async.Future<ExpireWaitlistOffersResponse> expireWaitlistOffers(
          $pb.ClientContext? ctx, ExpireWaitlistOffersRequest request) =>
      _client.invoke<ExpireWaitlistOffersResponse>(ctx, 'AppointmentService',
          'ExpireWaitlistOffers', request, ExpireWaitlistOffersResponse());

  /// SRS-SCH-007. Arrival with a token and an arrival mode. The token is the
  /// clinic's own where it has a scheme, and the next queue number otherwise.
  $async.Future<CheckInResponse> checkIn(
          $pb.ClientContext? ctx, CheckInRequest request) =>
      _client.invoke<CheckInResponse>(
          ctx, 'AppointmentService', 'CheckIn', request, CheckInResponse());

  /// SRS-SCH-008. The queue states, with invalid transitions refused unless the
  /// caller holds the correction permission and states a reason.
  $async.Future<AdvanceAppointmentResponse> advanceAppointment(
          $pb.ClientContext? ctx, AdvanceAppointmentRequest request) =>
      _client.invoke<AdvanceAppointmentResponse>(ctx, 'AppointmentService',
          'AdvanceAppointment', request, AdvanceAppointmentResponse());

  /// SRS-SCH-009. Who is waiting, in the order they will be called, with an
  /// estimated wait for each. The estimate never changes the order.
  $async.Future<GetQueueResponse> getQueue(
          $pb.ClientContext? ctx, GetQueueRequest request) =>
      _client.invoke<GetQueueResponse>(
          ctx, 'AppointmentService', 'GetQueue', request, GetQueueResponse());

  /// SRS-SCH-010. An unscheduled arrival becomes an ordinary appointment, so
  /// every downstream context sees it without knowing about a second kind of
  /// record.
  $async.Future<RegisterWalkInResponse> registerWalkIn(
          $pb.ClientContext? ctx, RegisterWalkInRequest request) =>
      _client.invoke<RegisterWalkInResponse>(ctx, 'AppointmentService',
          'RegisterWalkIn', request, RegisterWalkInResponse());

  /// SRS-SCH-011. A move in the queue, with a mandatory reason shown to queue
  /// users rather than buried in an audit table.
  $async.Future<ReprioritiseResponse> reprioritise(
          $pb.ClientContext? ctx, ReprioritiseRequest request) =>
      _client.invoke<ReprioritiseResponse>(ctx, 'AppointmentService',
          'Reprioritise', request, ReprioritiseResponse());

  /// SRS-SCH-012. Scheduling sends nothing; it records that a message is owed
  /// and what came back. A hospital that sends reminders and does not know which
  /// arrived cannot tell a patient who says they were never told from one who
  /// was.
  $async.Future<RecordDeliveryOutcomeResponse> recordDeliveryOutcome(
          $pb.ClientContext? ctx, RecordDeliveryOutcomeRequest request) =>
      _client.invoke<RecordDeliveryOutcomeResponse>(ctx, 'AppointmentService',
          'RecordDeliveryOutcome', request, RecordDeliveryOutcomeResponse());
  $async.Future<ListNotificationsResponse> listNotifications(
          $pb.ClientContext? ctx, ListNotificationsRequest request) =>
      _client.invoke<ListNotificationsResponse>(ctx, 'AppointmentService',
          'ListNotifications', request, ListNotificationsResponse());
  $async.Future<GetAppointmentResponse> getAppointment(
          $pb.ClientContext? ctx, GetAppointmentRequest request) =>
      _client.invoke<GetAppointmentResponse>(ctx, 'AppointmentService',
          'GetAppointment', request, GetAppointmentResponse());
  $async.Future<ListAppointmentsResponse> listAppointments(
          $pb.ClientContext? ctx, ListAppointmentsRequest request) =>
      _client.invoke<ListAppointmentsResponse>(ctx, 'AppointmentService',
          'ListAppointments', request, ListAppointmentsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
