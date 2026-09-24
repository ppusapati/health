// This is a generated file - do not edit.
//
// Generated from healthcare/ambulance/v1/ambulance.proto.

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

import 'ambulance.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'ambulance.pbenum.dart';

/// One ambulance (SRS-AMB-002).
class Vehicle extends $pb.GeneratedMessage {
  factory Vehicle({
    $core.String? vehicleId,
    $core.String? registration,
    $core.String? callSign,
    VehicleKind? kind,
    $core.String? facilityId,
    $core.String? baseId,
    $core.Iterable<$core.String>? capabilities,
    VehicleState? state,
    $0.Timestamp? readyUntil,
    $core.String? outOfServiceReason,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (registration != null) result.registration = registration;
    if (callSign != null) result.callSign = callSign;
    if (kind != null) result.kind = kind;
    if (facilityId != null) result.facilityId = facilityId;
    if (baseId != null) result.baseId = baseId;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    if (state != null) result.state = state;
    if (readyUntil != null) result.readyUntil = readyUntil;
    if (outOfServiceReason != null)
      result.outOfServiceReason = outOfServiceReason;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Vehicle._();

  factory Vehicle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Vehicle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Vehicle',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'registration')
    ..aOS(3, _omitFieldNames ? '' : 'callSign')
    ..aE<VehicleKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: VehicleKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'baseId')
    ..pPS(7, _omitFieldNames ? '' : 'capabilities')
    ..aE<VehicleState>(8, _omitFieldNames ? '' : 'state',
        enumValues: VehicleState.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'readyUntil',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'outOfServiceReason')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vehicle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Vehicle copyWith(void Function(Vehicle) updates) =>
      super.copyWith((message) => updates(message as Vehicle)) as Vehicle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vehicle create() => Vehicle._();
  @$core.override
  Vehicle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Vehicle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vehicle>(create);
  static Vehicle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get registration => $_getSZ(1);
  @$pb.TagNumber(2)
  set registration($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRegistration() => $_has(1);
  @$pb.TagNumber(2)
  void clearRegistration() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get callSign => $_getSZ(2);
  @$pb.TagNumber(3)
  set callSign($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCallSign() => $_has(2);
  @$pb.TagNumber(3)
  void clearCallSign() => $_clearField(3);

  @$pb.TagNumber(4)
  VehicleKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(VehicleKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get baseId => $_getSZ(5);
  @$pb.TagNumber(6)
  set baseId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBaseId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBaseId() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get capabilities => $_getList(6);

  @$pb.TagNumber(8)
  VehicleState get state => $_getN(7);
  @$pb.TagNumber(8)
  set state(VehicleState value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasState() => $_has(7);
  @$pb.TagNumber(8)
  void clearState() => $_clearField(8);

  /// When the readiness check that put it on the run expires. Derived rather
  /// than stored as a flag, so a check that lapsed overnight makes the
  /// vehicle unready without anybody remembering to say so.
  @$pb.TagNumber(9)
  $0.Timestamp get readyUntil => $_getN(8);
  @$pb.TagNumber(9)
  set readyUntil($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReadyUntil() => $_has(8);
  @$pb.TagNumber(9)
  void clearReadyUntil() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureReadyUntil() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get outOfServiceReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set outOfServiceReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOutOfServiceReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutOfServiceReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureCreatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get createdBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set createdBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $fixnum.Int64 get version => $_getI64(12);
  @$pb.TagNumber(13)
  set version($fixnum.Int64 value) => $_setInt64(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVersion() => $_has(12);
  @$pb.TagNumber(13)
  void clearVersion() => $_clearField(13);
}

/// One person rostered to a vehicle (SRS-AMB-002).
class CrewMember extends $pb.GeneratedMessage {
  factory CrewMember({
    $core.String? subjectId,
    $core.String? displayName,
    CrewRole? role,
    $core.String? registrationNumber,
  }) {
    final result = create();
    if (subjectId != null) result.subjectId = subjectId;
    if (displayName != null) result.displayName = displayName;
    if (role != null) result.role = role;
    if (registrationNumber != null)
      result.registrationNumber = registrationNumber;
    return result;
  }

  CrewMember._();

  factory CrewMember.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CrewMember.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CrewMember',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subjectId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aE<CrewRole>(3, _omitFieldNames ? '' : 'role',
        enumValues: CrewRole.values)
    ..aOS(4, _omitFieldNames ? '' : 'registrationNumber')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrewMember clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CrewMember copyWith(void Function(CrewMember) updates) =>
      super.copyWith((message) => updates(message as CrewMember)) as CrewMember;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CrewMember create() => CrewMember._();
  @$core.override
  CrewMember createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CrewMember getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CrewMember>(create);
  static CrewMember? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subjectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subjectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  CrewRole get role => $_getN(2);
  @$pb.TagNumber(3)
  set role(CrewRole value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  /// Their professional registration where the role has one, so a
  /// prehospital record names a registrant rather than a login.
  @$pb.TagNumber(4)
  $core.String get registrationNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set registrationNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRegistrationNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegistrationNumber() => $_clearField(4);
}

/// A crew on a vehicle for a period (SRS-AMB-002).
class Shift extends $pb.GeneratedMessage {
  factory Shift({
    $core.String? shiftId,
    $core.String? vehicleId,
    $core.String? facilityId,
    $core.Iterable<CrewMember>? crew,
    ShiftState? state,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
    $0.Timestamp? startedAt,
    $0.Timestamp? endedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (crew != null) result.crew.addAll(crew);
    if (state != null) result.state = state;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    if (startedAt != null) result.startedAt = startedAt;
    if (endedAt != null) result.endedAt = endedAt;
    if (version != null) result.version = version;
    return result;
  }

  Shift._();

  factory Shift.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Shift.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Shift',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..pPM<CrewMember>(4, _omitFieldNames ? '' : 'crew',
        subBuilder: CrewMember.create)
    ..aE<ShiftState>(5, _omitFieldNames ? '' : 'state',
        enumValues: ShiftState.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shift clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shift copyWith(void Function(Shift) updates) =>
      super.copyWith((message) => updates(message as Shift)) as Shift;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Shift create() => Shift._();
  @$core.override
  Shift createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Shift getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Shift>(create);
  static Shift? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shiftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shiftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShiftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShiftId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<CrewMember> get crew => $_getList(3);

  @$pb.TagNumber(5)
  ShiftState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(ShiftState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

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
  $0.Timestamp get startedAt => $_getN(7);
  @$pb.TagNumber(8)
  set startedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get endedAt => $_getN(8);
  @$pb.TagNumber(9)
  set endedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

/// One thing a readiness check asks about (SRS-AMB-006).
class ChecklistItem extends $pb.GeneratedMessage {
  factory ChecklistItem({
    $core.String? code,
    $core.String? label,
    $core.bool? critical,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (critical != null) result.critical = critical;
    return result;
  }

  ChecklistItem._();

  factory ChecklistItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChecklistItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChecklistItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'critical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChecklistItem copyWith(void Function(ChecklistItem) updates) =>
      super.copyWith((message) => updates(message as ChecklistItem))
          as ChecklistItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChecklistItem create() => ChecklistItem._();
  @$core.override
  ChecklistItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChecklistItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChecklistItem>(create);
  static ChecklistItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  /// A missing critical item fails the check. A missing blanket does not.
  @$pb.TagNumber(3)
  $core.bool get critical => $_getBF(2);
  @$pb.TagNumber(3)
  set critical($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCritical() => $_has(2);
  @$pb.TagNumber(3)
  void clearCritical() => $_clearField(3);
}

/// The answer (SRS-AMB-006).
class ItemOutcome extends $pb.GeneratedMessage {
  factory ItemOutcome({
    $core.String? code,
    $core.bool? present,
    $core.String? note,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (present != null) result.present = present;
    if (note != null) result.note = note;
    return result;
  }

  ItemOutcome._();

  factory ItemOutcome.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ItemOutcome.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemOutcome',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOB(2, _omitFieldNames ? '' : 'present')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemOutcome clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemOutcome copyWith(void Function(ItemOutcome) updates) =>
      super.copyWith((message) => updates(message as ItemOutcome))
          as ItemOutcome;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ItemOutcome create() => ItemOutcome._();
  @$core.override
  ItemOutcome createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ItemOutcome getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ItemOutcome>(create);
  static ItemOutcome? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get present => $_getBF(1);
  @$pb.TagNumber(2)
  set present($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPresent() => $_has(1);
  @$pb.TagNumber(2)
  void clearPresent() => $_clearField(2);

  /// Required when the item is not there: a missing item with no note is
  /// indistinguishable from one nobody looked for.
  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

/// A readiness check made against a vehicle (SRS-AMB-006).
class ReadinessCheck extends $pb.GeneratedMessage {
  factory ReadinessCheck({
    $core.String? checkId,
    $core.String? vehicleId,
    $core.String? shiftId,
    $core.String? facilityId,
    $core.Iterable<ChecklistItem>? items,
    $core.Iterable<ItemOutcome>? outcomes,
    $core.int? oxygenBar,
    $core.int? oxygenMinimumBar,
    CheckState? state,
    $core.Iterable<$core.String>? missing,
    $core.String? overrideBy,
    $core.String? overrideReason,
    $0.Timestamp? overrideAt,
    $0.Timestamp? validUntil,
    $0.Timestamp? checkedAt,
    $core.String? checkedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (checkId != null) result.checkId = checkId;
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (shiftId != null) result.shiftId = shiftId;
    if (facilityId != null) result.facilityId = facilityId;
    if (items != null) result.items.addAll(items);
    if (outcomes != null) result.outcomes.addAll(outcomes);
    if (oxygenBar != null) result.oxygenBar = oxygenBar;
    if (oxygenMinimumBar != null) result.oxygenMinimumBar = oxygenMinimumBar;
    if (state != null) result.state = state;
    if (missing != null) result.missing.addAll(missing);
    if (overrideBy != null) result.overrideBy = overrideBy;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (overrideAt != null) result.overrideAt = overrideAt;
    if (validUntil != null) result.validUntil = validUntil;
    if (checkedAt != null) result.checkedAt = checkedAt;
    if (checkedBy != null) result.checkedBy = checkedBy;
    if (version != null) result.version = version;
    return result;
  }

  ReadinessCheck._();

  factory ReadinessCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadinessCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadinessCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkId')
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'shiftId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..pPM<ChecklistItem>(5, _omitFieldNames ? '' : 'items',
        subBuilder: ChecklistItem.create)
    ..pPM<ItemOutcome>(6, _omitFieldNames ? '' : 'outcomes',
        subBuilder: ItemOutcome.create)
    ..aI(7, _omitFieldNames ? '' : 'oxygenBar')
    ..aI(8, _omitFieldNames ? '' : 'oxygenMinimumBar')
    ..aE<CheckState>(9, _omitFieldNames ? '' : 'state',
        enumValues: CheckState.values)
    ..pPS(10, _omitFieldNames ? '' : 'missing')
    ..aOS(11, _omitFieldNames ? '' : 'overrideBy')
    ..aOS(12, _omitFieldNames ? '' : 'overrideReason')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'overrideAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'validUntil',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'checkedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'checkedBy')
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessCheck copyWith(void Function(ReadinessCheck) updates) =>
      super.copyWith((message) => updates(message as ReadinessCheck))
          as ReadinessCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadinessCheck create() => ReadinessCheck._();
  @$core.override
  ReadinessCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadinessCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadinessCheck>(create);
  static ReadinessCheck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get shiftId => $_getSZ(2);
  @$pb.TagNumber(3)
  set shiftId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShiftId() => $_has(2);
  @$pb.TagNumber(3)
  void clearShiftId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ChecklistItem> get items => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<ItemOutcome> get outcomes => $_getList(5);

  /// Oxygen is a level rather than a tick: "present" is true of a cylinder
  /// with forty bar left in it, and that cylinder will not finish a long
  /// transfer.
  @$pb.TagNumber(7)
  $core.int get oxygenBar => $_getIZ(6);
  @$pb.TagNumber(7)
  set oxygenBar($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOxygenBar() => $_has(6);
  @$pb.TagNumber(7)
  void clearOxygenBar() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get oxygenMinimumBar => $_getIZ(7);
  @$pb.TagNumber(8)
  set oxygenMinimumBar($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOxygenMinimumBar() => $_has(7);
  @$pb.TagNumber(8)
  void clearOxygenMinimumBar() => $_clearField(8);

  @$pb.TagNumber(9)
  CheckState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(CheckState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  /// The critical items that were not there, so a service can see what to
  /// buy rather than only that a vehicle failed.
  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get missing => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get overrideBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set overrideBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOverrideBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearOverrideBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get overrideReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set overrideReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOverrideReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearOverrideReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get overrideAt => $_getN(12);
  @$pb.TagNumber(13)
  set overrideAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOverrideAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearOverrideAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureOverrideAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get validUntil => $_getN(13);
  @$pb.TagNumber(14)
  set validUntil($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasValidUntil() => $_has(13);
  @$pb.TagNumber(14)
  void clearValidUntil() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureValidUntil() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get checkedAt => $_getN(14);
  @$pb.TagNumber(15)
  set checkedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCheckedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCheckedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureCheckedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get checkedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set checkedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCheckedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearCheckedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

/// A call for an ambulance (SRS-AMB-001).
class Request extends $pb.GeneratedMessage {
  factory Request({
    $core.String? requestId,
    RequestKind? kind,
    Priority? priority,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? originName,
    $core.String? originAddress,
    $core.String? originFacilityId,
    $core.String? destinationName,
    $core.String? destinationAddress,
    $core.String? destinationFacilityId,
    $core.String? clinicalNeed,
    $core.Iterable<$core.String>? requiredCapabilities,
    RequestState? state,
    $core.String? tripId,
    $core.String? cancelReason,
    $core.String? cancelledBy,
    $0.Timestamp? cancelledAt,
    $0.Timestamp? requestedAt,
    $core.String? requestedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (kind != null) result.kind = kind;
    if (priority != null) result.priority = priority;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (originName != null) result.originName = originName;
    if (originAddress != null) result.originAddress = originAddress;
    if (originFacilityId != null) result.originFacilityId = originFacilityId;
    if (destinationName != null) result.destinationName = destinationName;
    if (destinationAddress != null)
      result.destinationAddress = destinationAddress;
    if (destinationFacilityId != null)
      result.destinationFacilityId = destinationFacilityId;
    if (clinicalNeed != null) result.clinicalNeed = clinicalNeed;
    if (requiredCapabilities != null)
      result.requiredCapabilities.addAll(requiredCapabilities);
    if (state != null) result.state = state;
    if (tripId != null) result.tripId = tripId;
    if (cancelReason != null) result.cancelReason = cancelReason;
    if (cancelledBy != null) result.cancelledBy = cancelledBy;
    if (cancelledAt != null) result.cancelledAt = cancelledAt;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (version != null) result.version = version;
    return result;
  }

  Request._();

  factory Request.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Request.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Request',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aE<RequestKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: RequestKind.values)
    ..aE<Priority>(3, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aOS(6, _omitFieldNames ? '' : 'originName')
    ..aOS(7, _omitFieldNames ? '' : 'originAddress')
    ..aOS(8, _omitFieldNames ? '' : 'originFacilityId')
    ..aOS(9, _omitFieldNames ? '' : 'destinationName')
    ..aOS(10, _omitFieldNames ? '' : 'destinationAddress')
    ..aOS(11, _omitFieldNames ? '' : 'destinationFacilityId')
    ..aOS(12, _omitFieldNames ? '' : 'clinicalNeed')
    ..pPS(13, _omitFieldNames ? '' : 'requiredCapabilities')
    ..aE<RequestState>(14, _omitFieldNames ? '' : 'state',
        enumValues: RequestState.values)
    ..aOS(15, _omitFieldNames ? '' : 'tripId')
    ..aOS(16, _omitFieldNames ? '' : 'cancelReason')
    ..aOS(17, _omitFieldNames ? '' : 'cancelledBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'cancelledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'requestedBy')
    ..aInt64(21, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Request copyWith(void Function(Request) updates) =>
      super.copyWith((message) => updates(message as Request)) as Request;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Request create() => Request._();
  @$core.override
  Request createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Request getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Request>(create);
  static Request? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  RequestKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(RequestKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  Priority get priority => $_getN(2);
  @$pb.TagNumber(3)
  set priority(Priority value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => $_clearField(3);

  /// Empty for a call to a street with nobody identified yet, which is most
  /// emergency calls at the moment they are taken.
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
  $core.String get originName => $_getSZ(5);
  @$pb.TagNumber(6)
  set originName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOriginName() => $_has(5);
  @$pb.TagNumber(6)
  void clearOriginName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get originAddress => $_getSZ(6);
  @$pb.TagNumber(7)
  set originAddress($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOriginAddress() => $_has(6);
  @$pb.TagNumber(7)
  void clearOriginAddress() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get originFacilityId => $_getSZ(7);
  @$pb.TagNumber(8)
  set originFacilityId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOriginFacilityId() => $_has(7);
  @$pb.TagNumber(8)
  void clearOriginFacilityId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get destinationName => $_getSZ(8);
  @$pb.TagNumber(9)
  set destinationName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDestinationName() => $_has(8);
  @$pb.TagNumber(9)
  void clearDestinationName() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get destinationAddress => $_getSZ(9);
  @$pb.TagNumber(10)
  set destinationAddress($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDestinationAddress() => $_has(9);
  @$pb.TagNumber(10)
  void clearDestinationAddress() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get destinationFacilityId => $_getSZ(10);
  @$pb.TagNumber(11)
  set destinationFacilityId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDestinationFacilityId() => $_has(10);
  @$pb.TagNumber(11)
  void clearDestinationFacilityId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get clinicalNeed => $_getSZ(11);
  @$pb.TagNumber(12)
  set clinicalNeed($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasClinicalNeed() => $_has(11);
  @$pb.TagNumber(12)
  void clearClinicalNeed() => $_clearField(12);

  @$pb.TagNumber(13)
  $pb.PbList<$core.String> get requiredCapabilities => $_getList(12);

  @$pb.TagNumber(14)
  RequestState get state => $_getN(13);
  @$pb.TagNumber(14)
  set state(RequestState value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasState() => $_has(13);
  @$pb.TagNumber(14)
  void clearState() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get tripId => $_getSZ(14);
  @$pb.TagNumber(15)
  set tripId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasTripId() => $_has(14);
  @$pb.TagNumber(15)
  void clearTripId() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get cancelReason => $_getSZ(15);
  @$pb.TagNumber(16)
  set cancelReason($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCancelReason() => $_has(15);
  @$pb.TagNumber(16)
  void clearCancelReason() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get cancelledBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set cancelledBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasCancelledBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCancelledBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get cancelledAt => $_getN(17);
  @$pb.TagNumber(18)
  set cancelledAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCancelledAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCancelledAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCancelledAt() => $_ensure(17);

  /// The clock every response-time figure is measured from.
  @$pb.TagNumber(19)
  $0.Timestamp get requestedAt => $_getN(18);
  @$pb.TagNumber(19)
  set requestedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRequestedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearRequestedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureRequestedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get requestedBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set requestedBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasRequestedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearRequestedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get version => $_getI64(20);
  @$pb.TagNumber(21)
  set version($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVersion() => $_has(20);
  @$pb.TagNumber(21)
  void clearVersion() => $_clearField(21);
}

/// One point on a trip's timeline (SRS-AMB-003).
class MilestoneRecord extends $pb.GeneratedMessage {
  factory MilestoneRecord({
    Milestone? milestone,
    $0.Timestamp? occurredAt,
    $core.String? recordedBy,
    $core.String? note,
    $0.Timestamp? amendsAt,
    $core.String? amendReason,
    $0.Timestamp? amendedAt,
  }) {
    final result = create();
    if (milestone != null) result.milestone = milestone;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (note != null) result.note = note;
    if (amendsAt != null) result.amendsAt = amendsAt;
    if (amendReason != null) result.amendReason = amendReason;
    if (amendedAt != null) result.amendedAt = amendedAt;
    return result;
  }

  MilestoneRecord._();

  factory MilestoneRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MilestoneRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MilestoneRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aE<Milestone>(1, _omitFieldNames ? '' : 'milestone',
        enumValues: Milestone.values)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'amendsAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'amendReason')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'amendedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MilestoneRecord copyWith(void Function(MilestoneRecord) updates) =>
      super.copyWith((message) => updates(message as MilestoneRecord))
          as MilestoneRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MilestoneRecord create() => MilestoneRecord._();
  @$core.override
  MilestoneRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MilestoneRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MilestoneRecord>(create);
  static MilestoneRecord? _defaultInstance;

  @$pb.TagNumber(1)
  Milestone get milestone => $_getN(0);
  @$pb.TagNumber(1)
  set milestone(Milestone value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMilestone() => $_has(0);
  @$pb.TagNumber(1)
  void clearMilestone() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get occurredAt => $_getN(1);
  @$pb.TagNumber(2)
  set occurredAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasOccurredAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearOccurredAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureOccurredAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get recordedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  /// Set on a correction: the value this record supersedes, why, and when
  /// the correction was made. Both records are kept.
  @$pb.TagNumber(5)
  $0.Timestamp get amendsAt => $_getN(4);
  @$pb.TagNumber(5)
  set amendsAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAmendsAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmendsAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureAmendsAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get amendReason => $_getSZ(5);
  @$pb.TagNumber(6)
  set amendReason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAmendReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmendReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get amendedAt => $_getN(6);
  @$pb.TagNumber(7)
  set amendedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAmendedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearAmendedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureAmendedAt() => $_ensure(6);
}

/// A vehicle answering a call (SRS-AMB-003).
class Trip extends $pb.GeneratedMessage {
  factory Trip({
    $core.String? tripId,
    $core.String? requestId,
    $core.String? vehicleId,
    $core.String? shiftId,
    $core.String? facilityId,
    $core.Iterable<$core.String>? crewSubjects,
    $core.String? overrideBy,
    $core.String? overrideReason,
    TripState? state,
    $core.Iterable<MilestoneRecord>? milestones,
    $core.String? abortReason,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? endedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (requestId != null) result.requestId = requestId;
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (shiftId != null) result.shiftId = shiftId;
    if (facilityId != null) result.facilityId = facilityId;
    if (crewSubjects != null) result.crewSubjects.addAll(crewSubjects);
    if (overrideBy != null) result.overrideBy = overrideBy;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (state != null) result.state = state;
    if (milestones != null) result.milestones.addAll(milestones);
    if (abortReason != null) result.abortReason = abortReason;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (endedAt != null) result.endedAt = endedAt;
    if (version != null) result.version = version;
    return result;
  }

  Trip._();

  factory Trip.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Trip.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trip',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aOS(2, _omitFieldNames ? '' : 'requestId')
    ..aOS(3, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(4, _omitFieldNames ? '' : 'shiftId')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..pPS(6, _omitFieldNames ? '' : 'crewSubjects')
    ..aOS(7, _omitFieldNames ? '' : 'overrideBy')
    ..aOS(8, _omitFieldNames ? '' : 'overrideReason')
    ..aE<TripState>(9, _omitFieldNames ? '' : 'state',
        enumValues: TripState.values)
    ..pPM<MilestoneRecord>(10, _omitFieldNames ? '' : 'milestones',
        subBuilder: MilestoneRecord.create)
    ..aOS(11, _omitFieldNames ? '' : 'abortReason')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trip clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trip copyWith(void Function(Trip) updates) =>
      super.copyWith((message) => updates(message as Trip)) as Trip;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Trip create() => Trip._();
  @$core.override
  Trip createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Trip getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trip>(create);
  static Trip? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requestId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get vehicleId => $_getSZ(2);
  @$pb.TagNumber(3)
  set vehicleId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVehicleId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVehicleId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get shiftId => $_getSZ(3);
  @$pb.TagNumber(4)
  set shiftId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShiftId() => $_has(3);
  @$pb.TagNumber(4)
  void clearShiftId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  /// Who was on board, pinned at dispatch. A crew list read back off the
  /// shift next month is the crew the shift has then.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get crewSubjects => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get overrideBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set overrideBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverrideBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverrideBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get overrideReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set overrideReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOverrideReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearOverrideReason() => $_clearField(8);

  @$pb.TagNumber(9)
  TripState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(TripState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<MilestoneRecord> get milestones => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get abortReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set abortReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasAbortReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearAbortReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get startedAt => $_getN(11);
  @$pb.TagNumber(12)
  set startedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStartedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureStartedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get startedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set startedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasStartedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get endedAt => $_getN(13);
  @$pb.TagNumber(14)
  set endedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEndedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEndedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);
}

/// One line the crew recorded (SRS-AMB-004).
class Entry extends $pb.GeneratedMessage {
  factory Entry({
    $core.String? entryId,
    EntryKind? kind,
    $core.String? code,
    $core.String? label,
    $core.String? value,
    $core.String? unit,
    $core.int? doseAmount,
    $core.String? doseUnit,
    $core.String? route,
    $core.String? narrative,
    $core.String? recordedBy,
    CrewRole? recordedRole,
    $0.Timestamp? recordedAt,
    $0.Timestamp? enteredAt,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (kind != null) result.kind = kind;
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (doseAmount != null) result.doseAmount = doseAmount;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (route != null) result.route = route;
    if (narrative != null) result.narrative = narrative;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (recordedRole != null) result.recordedRole = recordedRole;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (enteredAt != null) result.enteredAt = enteredAt;
    return result;
  }

  Entry._();

  factory Entry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Entry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Entry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aE<EntryKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: EntryKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'unit')
    ..aI(7, _omitFieldNames ? '' : 'doseAmount')
    ..aOS(8, _omitFieldNames ? '' : 'doseUnit')
    ..aOS(9, _omitFieldNames ? '' : 'route')
    ..aOS(10, _omitFieldNames ? '' : 'narrative')
    ..aOS(11, _omitFieldNames ? '' : 'recordedBy')
    ..aE<CrewRole>(12, _omitFieldNames ? '' : 'recordedRole',
        enumValues: CrewRole.values)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'enteredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Entry copyWith(void Function(Entry) updates) =>
      super.copyWith((message) => updates(message as Entry)) as Entry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Entry create() => Entry._();
  @$core.override
  Entry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Entry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Entry>(create);
  static Entry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  EntryKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(EntryKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get unit => $_getSZ(5);
  @$pb.TagNumber(6)
  set unit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnit() => $_clearField(6);

  /// In the unit named beside it, as an integer: 5 mg is 5, not 4.999999.
  @$pb.TagNumber(7)
  $core.int get doseAmount => $_getIZ(6);
  @$pb.TagNumber(7)
  set doseAmount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDoseAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearDoseAmount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get doseUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set doseUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDoseUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearDoseUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get route => $_getSZ(8);
  @$pb.TagNumber(9)
  set route($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRoute() => $_has(8);
  @$pb.TagNumber(9)
  void clearRoute() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get narrative => $_getSZ(9);
  @$pb.TagNumber(10)
  set narrative($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNarrative() => $_has(9);
  @$pb.TagNumber(10)
  void clearNarrative() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get recordedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set recordedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedBy() => $_clearField(11);

  /// Pinned at the time. A paramedic who becomes a manager next year still
  /// gave that drug as a paramedic.
  @$pb.TagNumber(12)
  CrewRole get recordedRole => $_getN(11);
  @$pb.TagNumber(12)
  set recordedRole(CrewRole value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRecordedRole() => $_has(11);
  @$pb.TagNumber(12)
  void clearRecordedRole() => $_clearField(12);

  /// When it happened, and when somebody typed it. A record written up two
  /// hours later is a different thing from one written at the time.
  @$pb.TagNumber(13)
  $0.Timestamp get recordedAt => $_getN(12);
  @$pb.TagNumber(13)
  set recordedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRecordedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearRecordedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRecordedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get enteredAt => $_getN(13);
  @$pb.TagNumber(14)
  set enteredAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEnteredAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEnteredAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEnteredAt() => $_ensure(13);
}

/// The crew's account of a journey (SRS-AMB-004, SRS-AMB-007).
class PrehospitalRecord extends $pb.GeneratedMessage {
  factory PrehospitalRecord({
    $core.String? recordId,
    $core.String? tripId,
    $core.String? requestId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? presentingComplaint,
    $core.String? impression,
    $core.Iterable<Entry>? entries,
    HandoverState? state,
    $core.String? sendingSummary,
    $core.String? givenBy,
    CrewRole? givenRole,
    $0.Timestamp? givenAt,
    $core.String? acceptedBy,
    $0.Timestamp? acceptedAt,
    $core.String? acceptedNote,
    $core.Iterable<$core.String>? documentRefs,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (tripId != null) result.tripId = tripId;
    if (requestId != null) result.requestId = requestId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (presentingComplaint != null)
      result.presentingComplaint = presentingComplaint;
    if (impression != null) result.impression = impression;
    if (entries != null) result.entries.addAll(entries);
    if (state != null) result.state = state;
    if (sendingSummary != null) result.sendingSummary = sendingSummary;
    if (givenBy != null) result.givenBy = givenBy;
    if (givenRole != null) result.givenRole = givenRole;
    if (givenAt != null) result.givenAt = givenAt;
    if (acceptedBy != null) result.acceptedBy = acceptedBy;
    if (acceptedAt != null) result.acceptedAt = acceptedAt;
    if (acceptedNote != null) result.acceptedNote = acceptedNote;
    if (documentRefs != null) result.documentRefs.addAll(documentRefs);
    if (version != null) result.version = version;
    return result;
  }

  PrehospitalRecord._();

  factory PrehospitalRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PrehospitalRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PrehospitalRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..aOS(3, _omitFieldNames ? '' : 'requestId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'encounterId')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'presentingComplaint')
    ..aOS(8, _omitFieldNames ? '' : 'impression')
    ..pPM<Entry>(9, _omitFieldNames ? '' : 'entries', subBuilder: Entry.create)
    ..aE<HandoverState>(10, _omitFieldNames ? '' : 'state',
        enumValues: HandoverState.values)
    ..aOS(11, _omitFieldNames ? '' : 'sendingSummary')
    ..aOS(12, _omitFieldNames ? '' : 'givenBy')
    ..aE<CrewRole>(13, _omitFieldNames ? '' : 'givenRole',
        enumValues: CrewRole.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'acceptedBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'acceptedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'acceptedNote')
    ..pPS(18, _omitFieldNames ? '' : 'documentRefs')
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrehospitalRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PrehospitalRecord copyWith(void Function(PrehospitalRecord) updates) =>
      super.copyWith((message) => updates(message as PrehospitalRecord))
          as PrehospitalRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PrehospitalRecord create() => PrehospitalRecord._();
  @$core.override
  PrehospitalRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PrehospitalRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PrehospitalRecord>(create);
  static PrehospitalRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requestId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requestId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  /// Set when the receiving clinician accepts the handover. This is the
  /// attachment SRS-AMB-004 asks for.
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

  @$pb.TagNumber(7)
  $core.String get presentingComplaint => $_getSZ(6);
  @$pb.TagNumber(7)
  set presentingComplaint($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPresentingComplaint() => $_has(6);
  @$pb.TagNumber(7)
  void clearPresentingComplaint() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get impression => $_getSZ(7);
  @$pb.TagNumber(8)
  set impression($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasImpression() => $_has(7);
  @$pb.TagNumber(8)
  void clearImpression() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<Entry> get entries => $_getList(8);

  @$pb.TagNumber(10)
  HandoverState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(HandoverState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get sendingSummary => $_getSZ(10);
  @$pb.TagNumber(11)
  set sendingSummary($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSendingSummary() => $_has(10);
  @$pb.TagNumber(11)
  void clearSendingSummary() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get givenBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set givenBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGivenBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearGivenBy() => $_clearField(12);

  @$pb.TagNumber(13)
  CrewRole get givenRole => $_getN(12);
  @$pb.TagNumber(13)
  set givenRole(CrewRole value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGivenRole() => $_has(12);
  @$pb.TagNumber(13)
  void clearGivenRole() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get givenAt => $_getN(13);
  @$pb.TagNumber(14)
  set givenAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasGivenAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearGivenAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureGivenAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get acceptedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set acceptedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAcceptedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearAcceptedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get acceptedAt => $_getN(15);
  @$pb.TagNumber(16)
  set acceptedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasAcceptedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearAcceptedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureAcceptedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get acceptedNote => $_getSZ(16);
  @$pb.TagNumber(17)
  set acceptedNote($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasAcceptedNote() => $_has(16);
  @$pb.TagNumber(17)
  void clearAcceptedNote() => $_clearField(17);

  /// References, not copies: a second copy of a referral goes stale the
  /// first time somebody corrects one.
  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get documentRefs => $_getList(17);

  @$pb.TagNumber(19)
  $fixnum.Int64 get version => $_getI64(18);
  @$pb.TagNumber(19)
  set version($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearVersion() => $_clearField(19);
}

/// Where a vehicle was at a moment (SRS-AMB-005).
///
/// No patient identifier, deliberately: the link is through the trip.
class Ping extends $pb.GeneratedMessage {
  factory Ping({
    $core.String? pingId,
    $core.String? vehicleId,
    $core.String? tripId,
    $core.int? latitudeMicro,
    $core.int? longitudeMicro,
    $core.int? speedKph,
    $core.int? headingDegrees,
    $core.int? accuracyMetres,
    $core.String? source,
    $0.Timestamp? occurredAt,
    $0.Timestamp? retainUntil,
  }) {
    final result = create();
    if (pingId != null) result.pingId = pingId;
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    if (latitudeMicro != null) result.latitudeMicro = latitudeMicro;
    if (longitudeMicro != null) result.longitudeMicro = longitudeMicro;
    if (speedKph != null) result.speedKph = speedKph;
    if (headingDegrees != null) result.headingDegrees = headingDegrees;
    if (accuracyMetres != null) result.accuracyMetres = accuracyMetres;
    if (source != null) result.source = source;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (retainUntil != null) result.retainUntil = retainUntil;
    return result;
  }

  Ping._();

  factory Ping.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ping.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ping',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'pingId')
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'tripId')
    ..aI(4, _omitFieldNames ? '' : 'latitudeMicro')
    ..aI(5, _omitFieldNames ? '' : 'longitudeMicro')
    ..aI(6, _omitFieldNames ? '' : 'speedKph')
    ..aI(7, _omitFieldNames ? '' : 'headingDegrees')
    ..aI(8, _omitFieldNames ? '' : 'accuracyMetres')
    ..aOS(9, _omitFieldNames ? '' : 'source')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'retainUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ping copyWith(void Function(Ping) updates) =>
      super.copyWith((message) => updates(message as Ping)) as Ping;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ping create() => Ping._();
  @$core.override
  Ping createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ping getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ping>(create);
  static Ping? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get pingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set pingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get tripId => $_getSZ(2);
  @$pb.TagNumber(3)
  set tripId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTripId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTripId() => $_clearField(3);

  /// Micro-degrees as integers. 13.082680 is 13082680 and stays that way.
  @$pb.TagNumber(4)
  $core.int get latitudeMicro => $_getIZ(3);
  @$pb.TagNumber(4)
  set latitudeMicro($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLatitudeMicro() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitudeMicro() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get longitudeMicro => $_getIZ(4);
  @$pb.TagNumber(5)
  set longitudeMicro($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLongitudeMicro() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitudeMicro() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get speedKph => $_getIZ(5);
  @$pb.TagNumber(6)
  set speedKph($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSpeedKph() => $_has(5);
  @$pb.TagNumber(6)
  void clearSpeedKph() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get headingDegrees => $_getIZ(6);
  @$pb.TagNumber(7)
  set headingDegrees($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHeadingDegrees() => $_has(6);
  @$pb.TagNumber(7)
  void clearHeadingDegrees() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get accuracyMetres => $_getIZ(7);
  @$pb.TagNumber(8)
  set accuracyMetres($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAccuracyMetres() => $_has(7);
  @$pb.TagNumber(8)
  void clearAccuracyMetres() => $_clearField(8);

  /// Which box or provider said so. A position with no provenance is one
  /// nobody can question when it is wrong.
  @$pb.TagNumber(9)
  $core.String get source => $_getSZ(8);
  @$pb.TagNumber(9)
  set source($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSource() => $_has(8);
  @$pb.TagNumber(9)
  void clearSource() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get occurredAt => $_getN(9);
  @$pb.TagNumber(10)
  set occurredAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOccurredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearOccurredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureOccurredAt() => $_ensure(9);

  /// When this ping stops being kept. A property of the row rather than of
  /// whatever the purge job was last told.
  @$pb.TagNumber(11)
  $0.Timestamp get retainUntil => $_getN(10);
  @$pb.TagNumber(11)
  set retainUntil($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRetainUntil() => $_has(10);
  @$pb.TagNumber(11)
  void clearRetainUntil() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRetainUntil() => $_ensure(10);
}

/// Where a vehicle is now (SRS-AMB-005).
class Position extends $pb.GeneratedMessage {
  factory Position({
    $core.String? vehicleId,
    $core.int? latitudeMicro,
    $core.int? longitudeMicro,
    $core.int? speedKph,
    $core.int? accuracyMetres,
    $core.String? source,
    $0.Timestamp? occurredAt,
    $core.bool? stale,
    $core.bool? known,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (latitudeMicro != null) result.latitudeMicro = latitudeMicro;
    if (longitudeMicro != null) result.longitudeMicro = longitudeMicro;
    if (speedKph != null) result.speedKph = speedKph;
    if (accuracyMetres != null) result.accuracyMetres = accuracyMetres;
    if (source != null) result.source = source;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (stale != null) result.stale = stale;
    if (known != null) result.known = known;
    return result;
  }

  Position._();

  factory Position.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Position.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Position',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aI(2, _omitFieldNames ? '' : 'latitudeMicro')
    ..aI(3, _omitFieldNames ? '' : 'longitudeMicro')
    ..aI(4, _omitFieldNames ? '' : 'speedKph')
    ..aI(5, _omitFieldNames ? '' : 'accuracyMetres')
    ..aOS(6, _omitFieldNames ? '' : 'source')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'stale')
    ..aOB(9, _omitFieldNames ? '' : 'known')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Position copyWith(void Function(Position) updates) =>
      super.copyWith((message) => updates(message as Position)) as Position;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  @$core.override
  Position createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get latitudeMicro => $_getIZ(1);
  @$pb.TagNumber(2)
  set latitudeMicro($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLatitudeMicro() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitudeMicro() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get longitudeMicro => $_getIZ(2);
  @$pb.TagNumber(3)
  set longitudeMicro($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLongitudeMicro() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitudeMicro() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get speedKph => $_getIZ(3);
  @$pb.TagNumber(4)
  set speedKph($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeedKph() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeedKph() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get accuracyMetres => $_getIZ(4);
  @$pb.TagNumber(5)
  set accuracyMetres($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAccuracyMetres() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccuracyMetres() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get source => $_getSZ(5);
  @$pb.TagNumber(6)
  set source($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

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

  /// The last position is older than the deployment's staleness threshold. A
  /// dispatcher who can see the vehicle was last heard from eleven minutes
  /// ago knows something a blank screen does not tell them.
  @$pb.TagNumber(8)
  $core.bool get stale => $_getBF(7);
  @$pb.TagNumber(8)
  set stale($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStale() => $_has(7);
  @$pb.TagNumber(8)
  void clearStale() => $_clearField(8);

  /// False when nothing is in retention for this vehicle. Reported rather
  /// than defaulting to its base, which would put an ambulance somewhere it
  /// is not.
  @$pb.TagNumber(9)
  $core.bool get known => $_getBF(8);
  @$pb.TagNumber(9)
  set known($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasKnown() => $_has(8);
  @$pb.TagNumber(9)
  void clearKnown() => $_clearField(9);
}

/// A provider's estimate (SRS-AMB-005).
///
/// Never computed here. A straight-line guess looks like an ETA and is not
/// one, and a dispatcher would hold a bed against it.
class ETA extends $pb.GeneratedMessage {
  factory ETA({
    $core.String? vehicleId,
    $core.String? tripId,
    $core.int? seconds,
    $core.int? distanceMetres,
    $core.String? source,
    $0.Timestamp? occurredAt,
    $core.bool? known,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    if (seconds != null) result.seconds = seconds;
    if (distanceMetres != null) result.distanceMetres = distanceMetres;
    if (source != null) result.source = source;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (known != null) result.known = known;
    return result;
  }

  ETA._();

  factory ETA.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ETA.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ETA',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..aI(3, _omitFieldNames ? '' : 'seconds')
    ..aI(4, _omitFieldNames ? '' : 'distanceMetres')
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(7, _omitFieldNames ? '' : 'known')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ETA clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ETA copyWith(void Function(ETA) updates) =>
      super.copyWith((message) => updates(message as ETA)) as ETA;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ETA create() => ETA._();
  @$core.override
  ETA createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ETA getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ETA>(create);
  static ETA? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get seconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set seconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get distanceMetres => $_getIZ(3);
  @$pb.TagNumber(4)
  set distanceMetres($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDistanceMetres() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistanceMetres() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

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

  @$pb.TagNumber(7)
  $core.bool get known => $_getBF(6);
  @$pb.TagNumber(7)
  set known($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasKnown() => $_has(6);
  @$pb.TagNumber(7)
  void clearKnown() => $_clearField(7);
}

/// How long one trip took at each stage (SRS-AMB-008).
///
/// Each figure carries whether it is known. A trip whose timeline has a gap
/// has a response time nobody can compute, and the figure is withheld rather
/// than reported as zero.
class TripMetrics extends $pb.GeneratedMessage {
  factory TripMetrics({
    $core.String? tripId,
    $core.int? responseSeconds,
    $core.bool? responseKnown,
    $core.int? onSceneSeconds,
    $core.bool? onSceneKnown,
    $core.int? transportSeconds,
    $core.bool? transportKnown,
    $core.int? handoverSeconds,
    $core.bool? handoverKnown,
    $core.int? turnaroundSeconds,
    $core.bool? turnaroundKnown,
    $core.int? totalSeconds,
    $core.bool? totalKnown,
    $core.Iterable<Milestone>? gaps,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (responseSeconds != null) result.responseSeconds = responseSeconds;
    if (responseKnown != null) result.responseKnown = responseKnown;
    if (onSceneSeconds != null) result.onSceneSeconds = onSceneSeconds;
    if (onSceneKnown != null) result.onSceneKnown = onSceneKnown;
    if (transportSeconds != null) result.transportSeconds = transportSeconds;
    if (transportKnown != null) result.transportKnown = transportKnown;
    if (handoverSeconds != null) result.handoverSeconds = handoverSeconds;
    if (handoverKnown != null) result.handoverKnown = handoverKnown;
    if (turnaroundSeconds != null) result.turnaroundSeconds = turnaroundSeconds;
    if (turnaroundKnown != null) result.turnaroundKnown = turnaroundKnown;
    if (totalSeconds != null) result.totalSeconds = totalSeconds;
    if (totalKnown != null) result.totalKnown = totalKnown;
    if (gaps != null) result.gaps.addAll(gaps);
    return result;
  }

  TripMetrics._();

  factory TripMetrics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TripMetrics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TripMetrics',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aI(2, _omitFieldNames ? '' : 'responseSeconds')
    ..aOB(3, _omitFieldNames ? '' : 'responseKnown')
    ..aI(4, _omitFieldNames ? '' : 'onSceneSeconds')
    ..aOB(5, _omitFieldNames ? '' : 'onSceneKnown')
    ..aI(6, _omitFieldNames ? '' : 'transportSeconds')
    ..aOB(7, _omitFieldNames ? '' : 'transportKnown')
    ..aI(8, _omitFieldNames ? '' : 'handoverSeconds')
    ..aOB(9, _omitFieldNames ? '' : 'handoverKnown')
    ..aI(10, _omitFieldNames ? '' : 'turnaroundSeconds')
    ..aOB(11, _omitFieldNames ? '' : 'turnaroundKnown')
    ..aI(12, _omitFieldNames ? '' : 'totalSeconds')
    ..aOB(13, _omitFieldNames ? '' : 'totalKnown')
    ..pc<Milestone>(14, _omitFieldNames ? '' : 'gaps', $pb.PbFieldType.KE,
        valueOf: Milestone.valueOf,
        enumValues: Milestone.values,
        defaultEnumValue: Milestone.MILESTONE_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripMetrics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TripMetrics copyWith(void Function(TripMetrics) updates) =>
      super.copyWith((message) => updates(message as TripMetrics))
          as TripMetrics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TripMetrics create() => TripMetrics._();
  @$core.override
  TripMetrics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TripMetrics getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TripMetrics>(create);
  static TripMetrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get responseSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set responseSeconds($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResponseSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponseSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get responseKnown => $_getBF(2);
  @$pb.TagNumber(3)
  set responseKnown($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResponseKnown() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponseKnown() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get onSceneSeconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set onSceneSeconds($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOnSceneSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnSceneSeconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get onSceneKnown => $_getBF(4);
  @$pb.TagNumber(5)
  set onSceneKnown($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOnSceneKnown() => $_has(4);
  @$pb.TagNumber(5)
  void clearOnSceneKnown() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get transportSeconds => $_getIZ(5);
  @$pb.TagNumber(6)
  set transportSeconds($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTransportSeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearTransportSeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get transportKnown => $_getBF(6);
  @$pb.TagNumber(7)
  set transportKnown($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTransportKnown() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransportKnown() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get handoverSeconds => $_getIZ(7);
  @$pb.TagNumber(8)
  set handoverSeconds($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasHandoverSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearHandoverSeconds() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get handoverKnown => $_getBF(8);
  @$pb.TagNumber(9)
  set handoverKnown($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasHandoverKnown() => $_has(8);
  @$pb.TagNumber(9)
  void clearHandoverKnown() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get turnaroundSeconds => $_getIZ(9);
  @$pb.TagNumber(10)
  set turnaroundSeconds($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTurnaroundSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearTurnaroundSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get turnaroundKnown => $_getBF(10);
  @$pb.TagNumber(11)
  set turnaroundKnown($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTurnaroundKnown() => $_has(10);
  @$pb.TagNumber(11)
  void clearTurnaroundKnown() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get totalSeconds => $_getIZ(11);
  @$pb.TagNumber(12)
  set totalSeconds($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTotalSeconds() => $_has(11);
  @$pb.TagNumber(12)
  void clearTotalSeconds() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get totalKnown => $_getBF(12);
  @$pb.TagNumber(13)
  set totalKnown($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTotalKnown() => $_has(12);
  @$pb.TagNumber(13)
  void clearTotalKnown() => $_clearField(13);

  /// The points this trip never recorded.
  @$pb.TagNumber(14)
  $pb.PbList<Milestone> get gaps => $_getList(13);
}

/// A distribution over one interval (SRS-AMB-008).
class Interval extends $pb.GeneratedMessage {
  factory Interval({
    $core.int? measured,
    $core.int? meanSeconds,
    $core.int? medianSeconds,
    $core.int? p90Seconds,
    $core.int? longestSeconds,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (measured != null) result.measured = measured;
    if (meanSeconds != null) result.meanSeconds = meanSeconds;
    if (medianSeconds != null) result.medianSeconds = medianSeconds;
    if (p90Seconds != null) result.p90Seconds = p90Seconds;
    if (longestSeconds != null) result.longestSeconds = longestSeconds;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  Interval._();

  factory Interval.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Interval.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Interval',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'measured')
    ..aI(2, _omitFieldNames ? '' : 'meanSeconds')
    ..aI(3, _omitFieldNames ? '' : 'medianSeconds')
    ..aI(4, _omitFieldNames ? '' : 'p90Seconds')
    ..aI(5, _omitFieldNames ? '' : 'longestSeconds')
    ..aOB(6, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interval clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Interval copyWith(void Function(Interval) updates) =>
      super.copyWith((message) => updates(message as Interval)) as Interval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Interval create() => Interval._();
  @$core.override
  Interval createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Interval getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Interval>(create);
  static Interval? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get measured => $_getIZ(0);
  @$pb.TagNumber(1)
  set measured($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeasured() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeasured() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get meanSeconds => $_getIZ(1);
  @$pb.TagNumber(2)
  set meanSeconds($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMeanSeconds() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeanSeconds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get medianSeconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set medianSeconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMedianSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearMedianSeconds() => $_clearField(3);

  /// A mean handover time hides the sixty-minute wait; the centile does not.
  @$pb.TagNumber(4)
  $core.int get p90Seconds => $_getIZ(3);
  @$pb.TagNumber(4)
  set p90Seconds($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasP90Seconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearP90Seconds() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get longestSeconds => $_getIZ(4);
  @$pb.TagNumber(5)
  set longestSeconds($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLongestSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongestSeconds() => $_clearField(5);

  /// Nothing in the window could be measured. Reported rather than a mean of
  /// zero, which reads as a service that arrives instantly.
  @$pb.TagNumber(6)
  $core.bool get unanswerable => $_getBF(5);
  @$pb.TagNumber(6)
  set unanswerable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnanswerable() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnanswerable() => $_clearField(6);
}

/// What a service reports about itself (SRS-AMB-008).
class ServiceSummary extends $pb.GeneratedMessage {
  factory ServiceSummary({
    $core.int? requests,
    $core.int? dispatched,
    $core.int? completed,
    $core.int? aborted,
    $core.int? cancelled,
    $core.int? cancelledAfterDispatch,
    $core.int? overridden,
    $core.int? incompleteTimelines,
    $core.int? vehiclesSeen,
    $fixnum.Int64? utilisationSeconds,
    Interval? response,
    Interval? onScene,
    Interval? handover,
    Interval? turnaround,
  }) {
    final result = create();
    if (requests != null) result.requests = requests;
    if (dispatched != null) result.dispatched = dispatched;
    if (completed != null) result.completed = completed;
    if (aborted != null) result.aborted = aborted;
    if (cancelled != null) result.cancelled = cancelled;
    if (cancelledAfterDispatch != null)
      result.cancelledAfterDispatch = cancelledAfterDispatch;
    if (overridden != null) result.overridden = overridden;
    if (incompleteTimelines != null)
      result.incompleteTimelines = incompleteTimelines;
    if (vehiclesSeen != null) result.vehiclesSeen = vehiclesSeen;
    if (utilisationSeconds != null)
      result.utilisationSeconds = utilisationSeconds;
    if (response != null) result.response = response;
    if (onScene != null) result.onScene = onScene;
    if (handover != null) result.handover = handover;
    if (turnaround != null) result.turnaround = turnaround;
    return result;
  }

  ServiceSummary._();

  factory ServiceSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'requests')
    ..aI(2, _omitFieldNames ? '' : 'dispatched')
    ..aI(3, _omitFieldNames ? '' : 'completed')
    ..aI(4, _omitFieldNames ? '' : 'aborted')
    ..aI(5, _omitFieldNames ? '' : 'cancelled')
    ..aI(6, _omitFieldNames ? '' : 'cancelledAfterDispatch')
    ..aI(7, _omitFieldNames ? '' : 'overridden')
    ..aI(8, _omitFieldNames ? '' : 'incompleteTimelines')
    ..aI(9, _omitFieldNames ? '' : 'vehiclesSeen')
    ..aInt64(10, _omitFieldNames ? '' : 'utilisationSeconds')
    ..aOM<Interval>(11, _omitFieldNames ? '' : 'response',
        subBuilder: Interval.create)
    ..aOM<Interval>(12, _omitFieldNames ? '' : 'onScene',
        subBuilder: Interval.create)
    ..aOM<Interval>(13, _omitFieldNames ? '' : 'handover',
        subBuilder: Interval.create)
    ..aOM<Interval>(14, _omitFieldNames ? '' : 'turnaround',
        subBuilder: Interval.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceSummary copyWith(void Function(ServiceSummary) updates) =>
      super.copyWith((message) => updates(message as ServiceSummary))
          as ServiceSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceSummary create() => ServiceSummary._();
  @$core.override
  ServiceSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceSummary>(create);
  static ServiceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get requests => $_getIZ(0);
  @$pb.TagNumber(1)
  set requests($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequests() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequests() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get dispatched => $_getIZ(1);
  @$pb.TagNumber(2)
  set dispatched($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDispatched() => $_has(1);
  @$pb.TagNumber(2)
  void clearDispatched() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get completed => $_getIZ(2);
  @$pb.TagNumber(3)
  set completed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCompleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompleted() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get aborted => $_getIZ(3);
  @$pb.TagNumber(4)
  set aborted($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAborted() => $_has(3);
  @$pb.TagNumber(4)
  void clearAborted() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get cancelled => $_getIZ(4);
  @$pb.TagNumber(5)
  set cancelled($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCancelled() => $_has(4);
  @$pb.TagNumber(5)
  void clearCancelled() => $_clearField(5);

  /// "We cancelled a fifth of our calls" and "a fifth of our calls stood
  /// down after we arrived" are different problems.
  @$pb.TagNumber(6)
  $core.int get cancelledAfterDispatch => $_getIZ(5);
  @$pb.TagNumber(6)
  set cancelledAfterDispatch($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCancelledAfterDispatch() => $_has(5);
  @$pb.TagNumber(6)
  void clearCancelledAfterDispatch() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get overridden => $_getIZ(6);
  @$pb.TagNumber(7)
  set overridden($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOverridden() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverridden() => $_clearField(7);

  /// Trips whose timeline has a gap. Reported beside the figures rather than
  /// hidden, because a service whose worst calls have incomplete timelines
  /// would otherwise report the best response times in the region.
  @$pb.TagNumber(8)
  $core.int get incompleteTimelines => $_getIZ(7);
  @$pb.TagNumber(8)
  set incompleteTimelines($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIncompleteTimelines() => $_has(7);
  @$pb.TagNumber(8)
  void clearIncompleteTimelines() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get vehiclesSeen => $_getIZ(8);
  @$pb.TagNumber(9)
  set vehiclesSeen($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVehiclesSeen() => $_has(8);
  @$pb.TagNumber(9)
  void clearVehiclesSeen() => $_clearField(9);

  /// Total time vehicles spent on trips in the window. Divided by the hours
  /// the fleet was rostered, this is utilisation; the two are kept apart
  /// because a service that rosters four vehicles and runs two has a
  /// different problem from one that rosters two and runs them ragged.
  @$pb.TagNumber(10)
  $fixnum.Int64 get utilisationSeconds => $_getI64(9);
  @$pb.TagNumber(10)
  set utilisationSeconds($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUtilisationSeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearUtilisationSeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  Interval get response => $_getN(10);
  @$pb.TagNumber(11)
  set response(Interval value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasResponse() => $_has(10);
  @$pb.TagNumber(11)
  void clearResponse() => $_clearField(11);
  @$pb.TagNumber(11)
  Interval ensureResponse() => $_ensure(10);

  @$pb.TagNumber(12)
  Interval get onScene => $_getN(11);
  @$pb.TagNumber(12)
  set onScene(Interval value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOnScene() => $_has(11);
  @$pb.TagNumber(12)
  void clearOnScene() => $_clearField(12);
  @$pb.TagNumber(12)
  Interval ensureOnScene() => $_ensure(11);

  @$pb.TagNumber(13)
  Interval get handover => $_getN(12);
  @$pb.TagNumber(13)
  set handover(Interval value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasHandover() => $_has(12);
  @$pb.TagNumber(13)
  void clearHandover() => $_clearField(13);
  @$pb.TagNumber(13)
  Interval ensureHandover() => $_ensure(12);

  @$pb.TagNumber(14)
  Interval get turnaround => $_getN(13);
  @$pb.TagNumber(14)
  set turnaround(Interval value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasTurnaround() => $_has(13);
  @$pb.TagNumber(14)
  void clearTurnaround() => $_clearField(14);
  @$pb.TagNumber(14)
  Interval ensureTurnaround() => $_ensure(13);
}

/// How a fleet is doing its readiness checks (SRS-AMB-006).
class ReadinessSummary extends $pb.GeneratedMessage {
  factory ReadinessSummary({
    $core.int? checked,
    $core.int? passed,
    $core.int? failed,
    $core.int? overridden,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? missingByItem,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (checked != null) result.checked = checked;
    if (passed != null) result.passed = passed;
    if (failed != null) result.failed = failed;
    if (overridden != null) result.overridden = overridden;
    if (missingByItem != null) result.missingByItem.addEntries(missingByItem);
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  ReadinessSummary._();

  factory ReadinessSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadinessSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadinessSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'checked')
    ..aI(2, _omitFieldNames ? '' : 'passed')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..aI(4, _omitFieldNames ? '' : 'overridden')
    ..m<$core.String, $core.int>(5, _omitFieldNames ? '' : 'missingByItem',
        entryClassName: 'ReadinessSummary.MissingByItemEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.ambulance.v1'))
    ..aOB(6, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessSummary copyWith(void Function(ReadinessSummary) updates) =>
      super.copyWith((message) => updates(message as ReadinessSummary))
          as ReadinessSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadinessSummary create() => ReadinessSummary._();
  @$core.override
  ReadinessSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadinessSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadinessSummary>(create);
  static ReadinessSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get checked => $_getIZ(0);
  @$pb.TagNumber(1)
  set checked($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChecked() => $_has(0);
  @$pb.TagNumber(1)
  void clearChecked() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get passed => $_getIZ(1);
  @$pb.TagNumber(2)
  set passed($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassed() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get failed => $_getIZ(2);
  @$pb.TagNumber(3)
  set failed($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailed() => $_clearField(3);

  /// Counted apart from a pass. A fleet where every check is overridden
  /// would otherwise read as a fleet that passes every check.
  @$pb.TagNumber(4)
  $core.int get overridden => $_getIZ(3);
  @$pb.TagNumber(4)
  set overridden($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverridden() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverridden() => $_clearField(4);

  /// Which critical items were missing, and how often. The number that tells
  /// a service what to buy.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.int> get missingByItem => $_getMap(4);

  @$pb.TagNumber(6)
  $core.bool get unanswerable => $_getBF(5);
  @$pb.TagNumber(6)
  set unanswerable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnanswerable() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnanswerable() => $_clearField(6);
}

class RegisterVehicleRequest extends $pb.GeneratedMessage {
  factory RegisterVehicleRequest({
    $core.String? registration,
    $core.String? callSign,
    VehicleKind? kind,
    $core.String? facilityId,
    $core.String? baseId,
    $core.Iterable<$core.String>? capabilities,
  }) {
    final result = create();
    if (registration != null) result.registration = registration;
    if (callSign != null) result.callSign = callSign;
    if (kind != null) result.kind = kind;
    if (facilityId != null) result.facilityId = facilityId;
    if (baseId != null) result.baseId = baseId;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    return result;
  }

  RegisterVehicleRequest._();

  factory RegisterVehicleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterVehicleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterVehicleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'registration')
    ..aOS(2, _omitFieldNames ? '' : 'callSign')
    ..aE<VehicleKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: VehicleKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'baseId')
    ..pPS(6, _omitFieldNames ? '' : 'capabilities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterVehicleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterVehicleRequest copyWith(
          void Function(RegisterVehicleRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterVehicleRequest))
          as RegisterVehicleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterVehicleRequest create() => RegisterVehicleRequest._();
  @$core.override
  RegisterVehicleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterVehicleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterVehicleRequest>(create);
  static RegisterVehicleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get registration => $_getSZ(0);
  @$pb.TagNumber(1)
  set registration($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRegistration() => $_has(0);
  @$pb.TagNumber(1)
  void clearRegistration() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get callSign => $_getSZ(1);
  @$pb.TagNumber(2)
  set callSign($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCallSign() => $_has(1);
  @$pb.TagNumber(2)
  void clearCallSign() => $_clearField(2);

  @$pb.TagNumber(3)
  VehicleKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(VehicleKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get baseId => $_getSZ(4);
  @$pb.TagNumber(5)
  set baseId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBaseId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBaseId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get capabilities => $_getList(5);
}

class RegisterVehicleResponse extends $pb.GeneratedMessage {
  factory RegisterVehicleResponse({
    Vehicle? vehicle,
  }) {
    final result = create();
    if (vehicle != null) result.vehicle = vehicle;
    return result;
  }

  RegisterVehicleResponse._();

  factory RegisterVehicleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterVehicleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterVehicleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Vehicle>(1, _omitFieldNames ? '' : 'vehicle',
        subBuilder: Vehicle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterVehicleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterVehicleResponse copyWith(
          void Function(RegisterVehicleResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterVehicleResponse))
          as RegisterVehicleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterVehicleResponse create() => RegisterVehicleResponse._();
  @$core.override
  RegisterVehicleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterVehicleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterVehicleResponse>(create);
  static RegisterVehicleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Vehicle get vehicle => $_getN(0);
  @$pb.TagNumber(1)
  set vehicle(Vehicle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicle() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicle() => $_clearField(1);
  @$pb.TagNumber(1)
  Vehicle ensureVehicle() => $_ensure(0);
}

class SetVehicleStateRequest extends $pb.GeneratedMessage {
  factory SetVehicleStateRequest({
    $core.String? vehicleId,
    VehicleState? state,
    $core.String? checkId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (state != null) result.state = state;
    if (checkId != null) result.checkId = checkId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  SetVehicleStateRequest._();

  factory SetVehicleStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetVehicleStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetVehicleStateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aE<VehicleState>(2, _omitFieldNames ? '' : 'state',
        enumValues: VehicleState.values)
    ..aOS(3, _omitFieldNames ? '' : 'checkId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aInt64(5, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVehicleStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVehicleStateRequest copyWith(
          void Function(SetVehicleStateRequest) updates) =>
      super.copyWith((message) => updates(message as SetVehicleStateRequest))
          as SetVehicleStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetVehicleStateRequest create() => SetVehicleStateRequest._();
  @$core.override
  SetVehicleStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetVehicleStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetVehicleStateRequest>(create);
  static SetVehicleStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  VehicleState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(VehicleState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  /// The passed readiness check the vehicle goes on the run behind.
  /// Required for AVAILABLE, and the check is read back rather than trusted.
  @$pb.TagNumber(3)
  $core.String get checkId => $_getSZ(2);
  @$pb.TagNumber(3)
  set checkId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCheckId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCheckId() => $_clearField(3);

  /// Required for OUT_OF_SERVICE and RETIRED: a vehicle off the run for no
  /// recorded reason is one nobody can chase back on.
  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get version => $_getI64(4);
  @$pb.TagNumber(5)
  set version($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);
}

class SetVehicleStateResponse extends $pb.GeneratedMessage {
  factory SetVehicleStateResponse({
    Vehicle? vehicle,
  }) {
    final result = create();
    if (vehicle != null) result.vehicle = vehicle;
    return result;
  }

  SetVehicleStateResponse._();

  factory SetVehicleStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetVehicleStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetVehicleStateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Vehicle>(1, _omitFieldNames ? '' : 'vehicle',
        subBuilder: Vehicle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVehicleStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetVehicleStateResponse copyWith(
          void Function(SetVehicleStateResponse) updates) =>
      super.copyWith((message) => updates(message as SetVehicleStateResponse))
          as SetVehicleStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetVehicleStateResponse create() => SetVehicleStateResponse._();
  @$core.override
  SetVehicleStateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetVehicleStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetVehicleStateResponse>(create);
  static SetVehicleStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Vehicle get vehicle => $_getN(0);
  @$pb.TagNumber(1)
  set vehicle(Vehicle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicle() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicle() => $_clearField(1);
  @$pb.TagNumber(1)
  Vehicle ensureVehicle() => $_ensure(0);
}

class GetVehicleRequest extends $pb.GeneratedMessage {
  factory GetVehicleRequest({
    $core.String? vehicleId,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    return result;
  }

  GetVehicleRequest._();

  factory GetVehicleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVehicleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVehicleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleRequest copyWith(void Function(GetVehicleRequest) updates) =>
      super.copyWith((message) => updates(message as GetVehicleRequest))
          as GetVehicleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVehicleRequest create() => GetVehicleRequest._();
  @$core.override
  GetVehicleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVehicleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVehicleRequest>(create);
  static GetVehicleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);
}

class GetVehicleResponse extends $pb.GeneratedMessage {
  factory GetVehicleResponse({
    Vehicle? vehicle,
  }) {
    final result = create();
    if (vehicle != null) result.vehicle = vehicle;
    return result;
  }

  GetVehicleResponse._();

  factory GetVehicleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVehicleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVehicleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Vehicle>(1, _omitFieldNames ? '' : 'vehicle',
        subBuilder: Vehicle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehicleResponse copyWith(void Function(GetVehicleResponse) updates) =>
      super.copyWith((message) => updates(message as GetVehicleResponse))
          as GetVehicleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVehicleResponse create() => GetVehicleResponse._();
  @$core.override
  GetVehicleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVehicleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVehicleResponse>(create);
  static GetVehicleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Vehicle get vehicle => $_getN(0);
  @$pb.TagNumber(1)
  set vehicle(Vehicle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicle() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicle() => $_clearField(1);
  @$pb.TagNumber(1)
  Vehicle ensureVehicle() => $_ensure(0);
}

class ListVehiclesRequest extends $pb.GeneratedMessage {
  factory ListVehiclesRequest({
    $core.Iterable<VehicleState>? states,
    $core.Iterable<VehicleKind>? kinds,
    $core.String? facilityId,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (kinds != null) result.kinds.addAll(kinds);
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListVehiclesRequest._();

  factory ListVehiclesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVehiclesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVehiclesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<VehicleState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: VehicleState.valueOf,
        enumValues: VehicleState.values,
        defaultEnumValue: VehicleState.VEHICLE_STATE_UNSPECIFIED)
    ..pc<VehicleKind>(2, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: VehicleKind.valueOf,
        enumValues: VehicleKind.values,
        defaultEnumValue: VehicleKind.VEHICLE_KIND_UNSPECIFIED)
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVehiclesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVehiclesRequest copyWith(void Function(ListVehiclesRequest) updates) =>
      super.copyWith((message) => updates(message as ListVehiclesRequest))
          as ListVehiclesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVehiclesRequest create() => ListVehiclesRequest._();
  @$core.override
  ListVehiclesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVehiclesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVehiclesRequest>(create);
  static ListVehiclesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<VehicleState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<VehicleKind> get kinds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get offset => $_getIZ(4);
  @$pb.TagNumber(5)
  set offset($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOffset() => $_has(4);
  @$pb.TagNumber(5)
  void clearOffset() => $_clearField(5);
}

class ListVehiclesResponse extends $pb.GeneratedMessage {
  factory ListVehiclesResponse({
    $core.Iterable<Vehicle>? vehicles,
  }) {
    final result = create();
    if (vehicles != null) result.vehicles.addAll(vehicles);
    return result;
  }

  ListVehiclesResponse._();

  factory ListVehiclesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVehiclesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVehiclesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Vehicle>(1, _omitFieldNames ? '' : 'vehicles',
        subBuilder: Vehicle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVehiclesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVehiclesResponse copyWith(void Function(ListVehiclesResponse) updates) =>
      super.copyWith((message) => updates(message as ListVehiclesResponse))
          as ListVehiclesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVehiclesResponse create() => ListVehiclesResponse._();
  @$core.override
  ListVehiclesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVehiclesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVehiclesResponse>(create);
  static ListVehiclesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Vehicle> get vehicles => $_getList(0);
}

class RosterShiftRequest extends $pb.GeneratedMessage {
  factory RosterShiftRequest({
    $core.String? vehicleId,
    $core.String? facilityId,
    $core.Iterable<CrewMember>? crew,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (crew != null) result.crew.addAll(crew);
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    return result;
  }

  RosterShiftRequest._();

  factory RosterShiftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RosterShiftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RosterShiftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..pPM<CrewMember>(3, _omitFieldNames ? '' : 'crew',
        subBuilder: CrewMember.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RosterShiftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RosterShiftRequest copyWith(void Function(RosterShiftRequest) updates) =>
      super.copyWith((message) => updates(message as RosterShiftRequest))
          as RosterShiftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RosterShiftRequest create() => RosterShiftRequest._();
  @$core.override
  RosterShiftRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RosterShiftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RosterShiftRequest>(create);
  static RosterShiftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CrewMember> get crew => $_getList(2);

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
}

class RosterShiftResponse extends $pb.GeneratedMessage {
  factory RosterShiftResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  RosterShiftResponse._();

  factory RosterShiftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RosterShiftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RosterShiftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RosterShiftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RosterShiftResponse copyWith(void Function(RosterShiftResponse) updates) =>
      super.copyWith((message) => updates(message as RosterShiftResponse))
          as RosterShiftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RosterShiftResponse create() => RosterShiftResponse._();
  @$core.override
  RosterShiftResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RosterShiftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RosterShiftResponse>(create);
  static RosterShiftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Shift get shift => $_getN(0);
  @$pb.TagNumber(1)
  set shift(Shift value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasShift() => $_has(0);
  @$pb.TagNumber(1)
  void clearShift() => $_clearField(1);
  @$pb.TagNumber(1)
  Shift ensureShift() => $_ensure(0);
}

class SetShiftStateRequest extends $pb.GeneratedMessage {
  factory SetShiftStateRequest({
    $core.String? shiftId,
    ShiftState? state,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    if (state != null) result.state = state;
    if (version != null) result.version = version;
    return result;
  }

  SetShiftStateRequest._();

  factory SetShiftStateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetShiftStateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetShiftStateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..aE<ShiftState>(2, _omitFieldNames ? '' : 'state',
        enumValues: ShiftState.values)
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetShiftStateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetShiftStateRequest copyWith(void Function(SetShiftStateRequest) updates) =>
      super.copyWith((message) => updates(message as SetShiftStateRequest))
          as SetShiftStateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetShiftStateRequest create() => SetShiftStateRequest._();
  @$core.override
  SetShiftStateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetShiftStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetShiftStateRequest>(create);
  static SetShiftStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shiftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shiftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShiftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShiftId() => $_clearField(1);

  @$pb.TagNumber(2)
  ShiftState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(ShiftState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class SetShiftStateResponse extends $pb.GeneratedMessage {
  factory SetShiftStateResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  SetShiftStateResponse._();

  factory SetShiftStateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetShiftStateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetShiftStateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetShiftStateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetShiftStateResponse copyWith(
          void Function(SetShiftStateResponse) updates) =>
      super.copyWith((message) => updates(message as SetShiftStateResponse))
          as SetShiftStateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetShiftStateResponse create() => SetShiftStateResponse._();
  @$core.override
  SetShiftStateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetShiftStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetShiftStateResponse>(create);
  static SetShiftStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Shift get shift => $_getN(0);
  @$pb.TagNumber(1)
  set shift(Shift value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasShift() => $_has(0);
  @$pb.TagNumber(1)
  void clearShift() => $_clearField(1);
  @$pb.TagNumber(1)
  Shift ensureShift() => $_ensure(0);
}

class GetShiftRequest extends $pb.GeneratedMessage {
  factory GetShiftRequest({
    $core.String? shiftId,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    return result;
  }

  GetShiftRequest._();

  factory GetShiftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetShiftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShiftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShiftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShiftRequest copyWith(void Function(GetShiftRequest) updates) =>
      super.copyWith((message) => updates(message as GetShiftRequest))
          as GetShiftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShiftRequest create() => GetShiftRequest._();
  @$core.override
  GetShiftRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetShiftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShiftRequest>(create);
  static GetShiftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shiftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shiftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShiftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShiftId() => $_clearField(1);
}

class GetShiftResponse extends $pb.GeneratedMessage {
  factory GetShiftResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  GetShiftResponse._();

  factory GetShiftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetShiftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetShiftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShiftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetShiftResponse copyWith(void Function(GetShiftResponse) updates) =>
      super.copyWith((message) => updates(message as GetShiftResponse))
          as GetShiftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShiftResponse create() => GetShiftResponse._();
  @$core.override
  GetShiftResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetShiftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetShiftResponse>(create);
  static GetShiftResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Shift get shift => $_getN(0);
  @$pb.TagNumber(1)
  set shift(Shift value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasShift() => $_has(0);
  @$pb.TagNumber(1)
  void clearShift() => $_clearField(1);
  @$pb.TagNumber(1)
  Shift ensureShift() => $_ensure(0);
}

class ListShiftsRequest extends $pb.GeneratedMessage {
  factory ListShiftsRequest({
    $core.String? vehicleId,
    $core.String? facilityId,
    $core.Iterable<ShiftState>? states,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (states != null) result.states.addAll(states);
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListShiftsRequest._();

  factory ListShiftsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListShiftsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListShiftsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..pc<ShiftState>(3, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: ShiftState.valueOf,
        enumValues: ShiftState.values,
        defaultEnumValue: ShiftState.SHIFT_STATE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListShiftsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListShiftsRequest copyWith(void Function(ListShiftsRequest) updates) =>
      super.copyWith((message) => updates(message as ListShiftsRequest))
          as ListShiftsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListShiftsRequest create() => ListShiftsRequest._();
  @$core.override
  ListShiftsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListShiftsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListShiftsRequest>(create);
  static ListShiftsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ShiftState> get states => $_getList(2);

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
  $0.Timestamp get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get offset => $_getIZ(6);
  @$pb.TagNumber(7)
  set offset($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);
}

class ListShiftsResponse extends $pb.GeneratedMessage {
  factory ListShiftsResponse({
    $core.Iterable<Shift>? shifts,
  }) {
    final result = create();
    if (shifts != null) result.shifts.addAll(shifts);
    return result;
  }

  ListShiftsResponse._();

  factory ListShiftsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListShiftsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListShiftsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Shift>(1, _omitFieldNames ? '' : 'shifts', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListShiftsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListShiftsResponse copyWith(void Function(ListShiftsResponse) updates) =>
      super.copyWith((message) => updates(message as ListShiftsResponse))
          as ListShiftsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListShiftsResponse create() => ListShiftsResponse._();
  @$core.override
  ListShiftsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListShiftsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListShiftsResponse>(create);
  static ListShiftsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Shift> get shifts => $_getList(0);
}

class RecordReadinessCheckRequest extends $pb.GeneratedMessage {
  factory RecordReadinessCheckRequest({
    $core.String? vehicleId,
    $core.String? shiftId,
    $core.String? facilityId,
    $core.Iterable<ChecklistItem>? items,
    $core.Iterable<ItemOutcome>? outcomes,
    $core.int? oxygenBar,
    $core.int? oxygenMinimumBar,
    $core.int? validForSeconds,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (shiftId != null) result.shiftId = shiftId;
    if (facilityId != null) result.facilityId = facilityId;
    if (items != null) result.items.addAll(items);
    if (outcomes != null) result.outcomes.addAll(outcomes);
    if (oxygenBar != null) result.oxygenBar = oxygenBar;
    if (oxygenMinimumBar != null) result.oxygenMinimumBar = oxygenMinimumBar;
    if (validForSeconds != null) result.validForSeconds = validForSeconds;
    return result;
  }

  RecordReadinessCheckRequest._();

  factory RecordReadinessCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordReadinessCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordReadinessCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'shiftId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..pPM<ChecklistItem>(4, _omitFieldNames ? '' : 'items',
        subBuilder: ChecklistItem.create)
    ..pPM<ItemOutcome>(5, _omitFieldNames ? '' : 'outcomes',
        subBuilder: ItemOutcome.create)
    ..aI(6, _omitFieldNames ? '' : 'oxygenBar')
    ..aI(7, _omitFieldNames ? '' : 'oxygenMinimumBar')
    ..aI(8, _omitFieldNames ? '' : 'validForSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordReadinessCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordReadinessCheckRequest copyWith(
          void Function(RecordReadinessCheckRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordReadinessCheckRequest))
          as RecordReadinessCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordReadinessCheckRequest create() =>
      RecordReadinessCheckRequest._();
  @$core.override
  RecordReadinessCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordReadinessCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordReadinessCheckRequest>(create);
  static RecordReadinessCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shiftId => $_getSZ(1);
  @$pb.TagNumber(2)
  set shiftId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShiftId() => $_has(1);
  @$pb.TagNumber(2)
  void clearShiftId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ChecklistItem> get items => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<ItemOutcome> get outcomes => $_getList(4);

  @$pb.TagNumber(6)
  $core.int get oxygenBar => $_getIZ(5);
  @$pb.TagNumber(6)
  set oxygenBar($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOxygenBar() => $_has(5);
  @$pb.TagNumber(6)
  void clearOxygenBar() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get oxygenMinimumBar => $_getIZ(6);
  @$pb.TagNumber(7)
  set oxygenMinimumBar($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOxygenMinimumBar() => $_has(6);
  @$pb.TagNumber(7)
  void clearOxygenMinimumBar() => $_clearField(7);

  /// How long the check holds for. A check that never lapses is a vehicle
  /// checked once in March.
  @$pb.TagNumber(8)
  $core.int get validForSeconds => $_getIZ(7);
  @$pb.TagNumber(8)
  set validForSeconds($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValidForSeconds() => $_has(7);
  @$pb.TagNumber(8)
  void clearValidForSeconds() => $_clearField(8);
}

class RecordReadinessCheckResponse extends $pb.GeneratedMessage {
  factory RecordReadinessCheckResponse({
    ReadinessCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  RecordReadinessCheckResponse._();

  factory RecordReadinessCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordReadinessCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordReadinessCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ReadinessCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: ReadinessCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordReadinessCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordReadinessCheckResponse copyWith(
          void Function(RecordReadinessCheckResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordReadinessCheckResponse))
          as RecordReadinessCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordReadinessCheckResponse create() =>
      RecordReadinessCheckResponse._();
  @$core.override
  RecordReadinessCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordReadinessCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordReadinessCheckResponse>(create);
  static RecordReadinessCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReadinessCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(ReadinessCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  ReadinessCheck ensureCheck_1() => $_ensure(0);
}

class OverrideReadinessCheckRequest extends $pb.GeneratedMessage {
  factory OverrideReadinessCheckRequest({
    $core.String? checkId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (checkId != null) result.checkId = checkId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  OverrideReadinessCheckRequest._();

  factory OverrideReadinessCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideReadinessCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideReadinessCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideReadinessCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideReadinessCheckRequest copyWith(
          void Function(OverrideReadinessCheckRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OverrideReadinessCheckRequest))
          as OverrideReadinessCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideReadinessCheckRequest create() =>
      OverrideReadinessCheckRequest._();
  @$core.override
  OverrideReadinessCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideReadinessCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideReadinessCheckRequest>(create);
  static OverrideReadinessCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class OverrideReadinessCheckResponse extends $pb.GeneratedMessage {
  factory OverrideReadinessCheckResponse({
    ReadinessCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  OverrideReadinessCheckResponse._();

  factory OverrideReadinessCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OverrideReadinessCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OverrideReadinessCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ReadinessCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: ReadinessCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideReadinessCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OverrideReadinessCheckResponse copyWith(
          void Function(OverrideReadinessCheckResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OverrideReadinessCheckResponse))
          as OverrideReadinessCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OverrideReadinessCheckResponse create() =>
      OverrideReadinessCheckResponse._();
  @$core.override
  OverrideReadinessCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OverrideReadinessCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OverrideReadinessCheckResponse>(create);
  static OverrideReadinessCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReadinessCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(ReadinessCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  ReadinessCheck ensureCheck_1() => $_ensure(0);
}

class GetReadinessCheckRequest extends $pb.GeneratedMessage {
  factory GetReadinessCheckRequest({
    $core.String? checkId,
  }) {
    final result = create();
    if (checkId != null) result.checkId = checkId;
    return result;
  }

  GetReadinessCheckRequest._();

  factory GetReadinessCheckRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessCheckRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessCheckRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessCheckRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessCheckRequest copyWith(
          void Function(GetReadinessCheckRequest) updates) =>
      super.copyWith((message) => updates(message as GetReadinessCheckRequest))
          as GetReadinessCheckRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessCheckRequest create() => GetReadinessCheckRequest._();
  @$core.override
  GetReadinessCheckRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessCheckRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessCheckRequest>(create);
  static GetReadinessCheckRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckId() => $_clearField(1);
}

class GetReadinessCheckResponse extends $pb.GeneratedMessage {
  factory GetReadinessCheckResponse({
    ReadinessCheck? check_1,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    return result;
  }

  GetReadinessCheckResponse._();

  factory GetReadinessCheckResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessCheckResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessCheckResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ReadinessCheck>(1, _omitFieldNames ? '' : 'check',
        subBuilder: ReadinessCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessCheckResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessCheckResponse copyWith(
          void Function(GetReadinessCheckResponse) updates) =>
      super.copyWith((message) => updates(message as GetReadinessCheckResponse))
          as GetReadinessCheckResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessCheckResponse create() => GetReadinessCheckResponse._();
  @$core.override
  GetReadinessCheckResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessCheckResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessCheckResponse>(create);
  static GetReadinessCheckResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReadinessCheck get check_1 => $_getN(0);
  @$pb.TagNumber(1)
  set check_1(ReadinessCheck value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);
  @$pb.TagNumber(1)
  ReadinessCheck ensureCheck_1() => $_ensure(0);
}

class ListReadinessChecksRequest extends $pb.GeneratedMessage {
  factory ListReadinessChecksRequest({
    $core.String? vehicleId,
    $core.String? facilityId,
    $core.Iterable<CheckState>? states,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (states != null) result.states.addAll(states);
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListReadinessChecksRequest._();

  factory ListReadinessChecksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReadinessChecksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReadinessChecksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..pc<CheckState>(3, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: CheckState.valueOf,
        enumValues: CheckState.values,
        defaultEnumValue: CheckState.CHECK_STATE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadinessChecksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadinessChecksRequest copyWith(
          void Function(ListReadinessChecksRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListReadinessChecksRequest))
          as ListReadinessChecksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadinessChecksRequest create() => ListReadinessChecksRequest._();
  @$core.override
  ListReadinessChecksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReadinessChecksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReadinessChecksRequest>(create);
  static ListReadinessChecksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<CheckState> get states => $_getList(2);

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
  $0.Timestamp get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get offset => $_getIZ(6);
  @$pb.TagNumber(7)
  set offset($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);
}

class ListReadinessChecksResponse extends $pb.GeneratedMessage {
  factory ListReadinessChecksResponse({
    $core.Iterable<ReadinessCheck>? checks,
  }) {
    final result = create();
    if (checks != null) result.checks.addAll(checks);
    return result;
  }

  ListReadinessChecksResponse._();

  factory ListReadinessChecksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReadinessChecksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReadinessChecksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<ReadinessCheck>(1, _omitFieldNames ? '' : 'checks',
        subBuilder: ReadinessCheck.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadinessChecksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadinessChecksResponse copyWith(
          void Function(ListReadinessChecksResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListReadinessChecksResponse))
          as ListReadinessChecksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadinessChecksResponse create() =>
      ListReadinessChecksResponse._();
  @$core.override
  ListReadinessChecksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReadinessChecksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReadinessChecksResponse>(create);
  static ListReadinessChecksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReadinessCheck> get checks => $_getList(0);
}

class GetReadinessSummaryRequest extends $pb.GeneratedMessage {
  factory GetReadinessSummaryRequest({
    $core.String? vehicleId,
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetReadinessSummaryRequest._();

  factory GetReadinessSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessSummaryRequest copyWith(
          void Function(GetReadinessSummaryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetReadinessSummaryRequest))
          as GetReadinessSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessSummaryRequest create() => GetReadinessSummaryRequest._();
  @$core.override
  GetReadinessSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessSummaryRequest>(create);
  static GetReadinessSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

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
  $0.Timestamp get to => $_getN(3);
  @$pb.TagNumber(4)
  set to($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTo() => $_ensure(3);
}

class GetReadinessSummaryResponse extends $pb.GeneratedMessage {
  factory GetReadinessSummaryResponse({
    ReadinessSummary? summary,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    return result;
  }

  GetReadinessSummaryResponse._();

  factory GetReadinessSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReadinessSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReadinessSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ReadinessSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: ReadinessSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReadinessSummaryResponse copyWith(
          void Function(GetReadinessSummaryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetReadinessSummaryResponse))
          as GetReadinessSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReadinessSummaryResponse create() =>
      GetReadinessSummaryResponse._();
  @$core.override
  GetReadinessSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReadinessSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReadinessSummaryResponse>(create);
  static GetReadinessSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ReadinessSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(ReadinessSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  ReadinessSummary ensureSummary() => $_ensure(0);
}

class RaiseRequestRequest extends $pb.GeneratedMessage {
  factory RaiseRequestRequest({
    RequestKind? kind,
    Priority? priority,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? originName,
    $core.String? originAddress,
    $core.String? originFacilityId,
    $core.String? destinationName,
    $core.String? destinationAddress,
    $core.String? destinationFacilityId,
    $core.String? clinicalNeed,
    $core.Iterable<$core.String>? requiredCapabilities,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (priority != null) result.priority = priority;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (originName != null) result.originName = originName;
    if (originAddress != null) result.originAddress = originAddress;
    if (originFacilityId != null) result.originFacilityId = originFacilityId;
    if (destinationName != null) result.destinationName = destinationName;
    if (destinationAddress != null)
      result.destinationAddress = destinationAddress;
    if (destinationFacilityId != null)
      result.destinationFacilityId = destinationFacilityId;
    if (clinicalNeed != null) result.clinicalNeed = clinicalNeed;
    if (requiredCapabilities != null)
      result.requiredCapabilities.addAll(requiredCapabilities);
    return result;
  }

  RaiseRequestRequest._();

  factory RaiseRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRequestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aE<RequestKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: RequestKind.values)
    ..aE<Priority>(2, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'originName')
    ..aOS(6, _omitFieldNames ? '' : 'originAddress')
    ..aOS(7, _omitFieldNames ? '' : 'originFacilityId')
    ..aOS(8, _omitFieldNames ? '' : 'destinationName')
    ..aOS(9, _omitFieldNames ? '' : 'destinationAddress')
    ..aOS(10, _omitFieldNames ? '' : 'destinationFacilityId')
    ..aOS(11, _omitFieldNames ? '' : 'clinicalNeed')
    ..pPS(12, _omitFieldNames ? '' : 'requiredCapabilities')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequestRequest copyWith(void Function(RaiseRequestRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseRequestRequest))
          as RaiseRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRequestRequest create() => RaiseRequestRequest._();
  @$core.override
  RaiseRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRequestRequest>(create);
  static RaiseRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  RequestKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(RequestKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  Priority get priority => $_getN(1);
  @$pb.TagNumber(2)
  set priority(Priority value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPriority() => $_has(1);
  @$pb.TagNumber(2)
  void clearPriority() => $_clearField(2);

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
  $core.String get originName => $_getSZ(4);
  @$pb.TagNumber(5)
  set originName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginName() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get originAddress => $_getSZ(5);
  @$pb.TagNumber(6)
  set originAddress($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOriginAddress() => $_has(5);
  @$pb.TagNumber(6)
  void clearOriginAddress() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get originFacilityId => $_getSZ(6);
  @$pb.TagNumber(7)
  set originFacilityId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOriginFacilityId() => $_has(6);
  @$pb.TagNumber(7)
  void clearOriginFacilityId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get destinationName => $_getSZ(7);
  @$pb.TagNumber(8)
  set destinationName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDestinationName() => $_has(7);
  @$pb.TagNumber(8)
  void clearDestinationName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get destinationAddress => $_getSZ(8);
  @$pb.TagNumber(9)
  set destinationAddress($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDestinationAddress() => $_has(8);
  @$pb.TagNumber(9)
  void clearDestinationAddress() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get destinationFacilityId => $_getSZ(9);
  @$pb.TagNumber(10)
  set destinationFacilityId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDestinationFacilityId() => $_has(9);
  @$pb.TagNumber(10)
  void clearDestinationFacilityId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get clinicalNeed => $_getSZ(10);
  @$pb.TagNumber(11)
  set clinicalNeed($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClinicalNeed() => $_has(10);
  @$pb.TagNumber(11)
  void clearClinicalNeed() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get requiredCapabilities => $_getList(11);
}

class RaiseRequestResponse extends $pb.GeneratedMessage {
  factory RaiseRequestResponse({
    Request? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  RaiseRequestResponse._();

  factory RaiseRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRequestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Request>(1, _omitFieldNames ? '' : 'request',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequestResponse copyWith(void Function(RaiseRequestResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseRequestResponse))
          as RaiseRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRequestResponse create() => RaiseRequestResponse._();
  @$core.override
  RaiseRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRequestResponse>(create);
  static RaiseRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Request get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(Request value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  Request ensureRequest() => $_ensure(0);
}

class CancelRequestRequest extends $pb.GeneratedMessage {
  factory CancelRequestRequest({
    $core.String? requestId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  CancelRequestRequest._();

  factory CancelRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRequestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequestRequest copyWith(void Function(CancelRequestRequest) updates) =>
      super.copyWith((message) => updates(message as CancelRequestRequest))
          as CancelRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRequestRequest create() => CancelRequestRequest._();
  @$core.override
  CancelRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRequestRequest>(create);
  static CancelRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class CancelRequestResponse extends $pb.GeneratedMessage {
  factory CancelRequestResponse({
    Request? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  CancelRequestResponse._();

  factory CancelRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelRequestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Request>(1, _omitFieldNames ? '' : 'request',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelRequestResponse copyWith(
          void Function(CancelRequestResponse) updates) =>
      super.copyWith((message) => updates(message as CancelRequestResponse))
          as CancelRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelRequestResponse create() => CancelRequestResponse._();
  @$core.override
  CancelRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelRequestResponse>(create);
  static CancelRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Request get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(Request value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  Request ensureRequest() => $_ensure(0);
}

class GetRequestRequest extends $pb.GeneratedMessage {
  factory GetRequestRequest({
    $core.String? requestId,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    return result;
  }

  GetRequestRequest._();

  factory GetRequestRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRequestRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequestRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequestRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequestRequest copyWith(void Function(GetRequestRequest) updates) =>
      super.copyWith((message) => updates(message as GetRequestRequest))
          as GetRequestRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRequestRequest create() => GetRequestRequest._();
  @$core.override
  GetRequestRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRequestRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequestRequest>(create);
  static GetRequestRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);
}

class GetRequestResponse extends $pb.GeneratedMessage {
  factory GetRequestResponse({
    Request? request,
  }) {
    final result = create();
    if (request != null) result.request = request;
    return result;
  }

  GetRequestResponse._();

  factory GetRequestResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRequestResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequestResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Request>(1, _omitFieldNames ? '' : 'request',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequestResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequestResponse copyWith(void Function(GetRequestResponse) updates) =>
      super.copyWith((message) => updates(message as GetRequestResponse))
          as GetRequestResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRequestResponse create() => GetRequestResponse._();
  @$core.override
  GetRequestResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRequestResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequestResponse>(create);
  static GetRequestResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Request get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(Request value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  Request ensureRequest() => $_ensure(0);
}

class ListRequestsRequest extends $pb.GeneratedMessage {
  factory ListRequestsRequest({
    $core.Iterable<RequestState>? states,
    $core.Iterable<Priority>? priorities,
    $core.Iterable<RequestKind>? kinds,
    $core.String? facilityId,
    $core.String? patientId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (priorities != null) result.priorities.addAll(priorities);
    if (kinds != null) result.kinds.addAll(kinds);
    if (facilityId != null) result.facilityId = facilityId;
    if (patientId != null) result.patientId = patientId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListRequestsRequest._();

  factory ListRequestsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequestsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequestsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<RequestState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: RequestState.valueOf,
        enumValues: RequestState.values,
        defaultEnumValue: RequestState.REQUEST_STATE_UNSPECIFIED)
    ..pc<Priority>(2, _omitFieldNames ? '' : 'priorities', $pb.PbFieldType.KE,
        valueOf: Priority.valueOf,
        enumValues: Priority.values,
        defaultEnumValue: Priority.PRIORITY_UNSPECIFIED)
    ..pc<RequestKind>(3, _omitFieldNames ? '' : 'kinds', $pb.PbFieldType.KE,
        valueOf: RequestKind.valueOf,
        enumValues: RequestKind.values,
        defaultEnumValue: RequestKind.REQUEST_KIND_UNSPECIFIED)
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'patientId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'pageSize')
    ..aI(9, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequestsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequestsRequest copyWith(void Function(ListRequestsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequestsRequest))
          as ListRequestsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequestsRequest create() => ListRequestsRequest._();
  @$core.override
  ListRequestsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRequestsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequestsRequest>(create);
  static ListRequestsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RequestState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<Priority> get priorities => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<RequestKind> get kinds => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get patientId => $_getSZ(4);
  @$pb.TagNumber(5)
  set patientId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPatientId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPatientId() => $_clearField(5);

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
  $0.Timestamp get to => $_getN(6);
  @$pb.TagNumber(7)
  set to($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearTo() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureTo() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get pageSize => $_getIZ(7);
  @$pb.TagNumber(8)
  set pageSize($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPageSize() => $_has(7);
  @$pb.TagNumber(8)
  void clearPageSize() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get offset => $_getIZ(8);
  @$pb.TagNumber(9)
  set offset($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasOffset() => $_has(8);
  @$pb.TagNumber(9)
  void clearOffset() => $_clearField(9);
}

class ListRequestsResponse extends $pb.GeneratedMessage {
  factory ListRequestsResponse({
    $core.Iterable<Request>? requests,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    return result;
  }

  ListRequestsResponse._();

  factory ListRequestsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequestsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequestsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Request>(1, _omitFieldNames ? '' : 'requests',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequestsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequestsResponse copyWith(void Function(ListRequestsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRequestsResponse))
          as ListRequestsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequestsResponse create() => ListRequestsResponse._();
  @$core.override
  ListRequestsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRequestsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequestsResponse>(create);
  static ListRequestsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Request> get requests => $_getList(0);
}

class GetDispatchQueueRequest extends $pb.GeneratedMessage {
  factory GetDispatchQueueRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetDispatchQueueRequest._();

  factory GetDispatchQueueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDispatchQueueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDispatchQueueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDispatchQueueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDispatchQueueRequest copyWith(
          void Function(GetDispatchQueueRequest) updates) =>
      super.copyWith((message) => updates(message as GetDispatchQueueRequest))
          as GetDispatchQueueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDispatchQueueRequest create() => GetDispatchQueueRequest._();
  @$core.override
  GetDispatchQueueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDispatchQueueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDispatchQueueRequest>(create);
  static GetDispatchQueueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

/// Priority first, then the oldest call waiting.
class GetDispatchQueueResponse extends $pb.GeneratedMessage {
  factory GetDispatchQueueResponse({
    $core.Iterable<Request>? requests,
  }) {
    final result = create();
    if (requests != null) result.requests.addAll(requests);
    return result;
  }

  GetDispatchQueueResponse._();

  factory GetDispatchQueueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDispatchQueueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDispatchQueueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Request>(1, _omitFieldNames ? '' : 'requests',
        subBuilder: Request.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDispatchQueueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDispatchQueueResponse copyWith(
          void Function(GetDispatchQueueResponse) updates) =>
      super.copyWith((message) => updates(message as GetDispatchQueueResponse))
          as GetDispatchQueueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDispatchQueueResponse create() => GetDispatchQueueResponse._();
  @$core.override
  GetDispatchQueueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDispatchQueueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDispatchQueueResponse>(create);
  static GetDispatchQueueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Request> get requests => $_getList(0);
}

class DispatchRequest extends $pb.GeneratedMessage {
  factory DispatchRequest({
    $core.String? requestId,
    $core.String? vehicleId,
    $core.String? shiftId,
    $core.String? overrideReason,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (shiftId != null) result.shiftId = shiftId;
    if (overrideReason != null) result.overrideReason = overrideReason;
    return result;
  }

  DispatchRequest._();

  factory DispatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requestId')
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'shiftId')
    ..aOS(4, _omitFieldNames ? '' : 'overrideReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchRequest copyWith(void Function(DispatchRequest) updates) =>
      super.copyWith((message) => updates(message as DispatchRequest))
          as DispatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchRequest create() => DispatchRequest._();
  @$core.override
  DispatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchRequest>(create);
  static DispatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requestId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requestId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get shiftId => $_getSZ(2);
  @$pb.TagNumber(3)
  set shiftId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShiftId() => $_has(2);
  @$pb.TagNumber(3)
  void clearShiftId() => $_clearField(3);

  /// Required when a rule would refuse the dispatch, and refused without the
  /// override permission. The overriding person is the caller.
  @$pb.TagNumber(4)
  $core.String get overrideReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set overrideReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOverrideReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearOverrideReason() => $_clearField(4);
}

class DispatchResponse extends $pb.GeneratedMessage {
  factory DispatchResponse({
    Trip? trip,
  }) {
    final result = create();
    if (trip != null) result.trip = trip;
    return result;
  }

  DispatchResponse._();

  factory DispatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Trip>(1, _omitFieldNames ? '' : 'trip', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchResponse copyWith(void Function(DispatchResponse) updates) =>
      super.copyWith((message) => updates(message as DispatchResponse))
          as DispatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchResponse create() => DispatchResponse._();
  @$core.override
  DispatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchResponse>(create);
  static DispatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trip get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(Trip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => $_clearField(1);
  @$pb.TagNumber(1)
  Trip ensureTrip() => $_ensure(0);
}

class RecordTripMilestoneRequest extends $pb.GeneratedMessage {
  factory RecordTripMilestoneRequest({
    $core.String? tripId,
    Milestone? milestone,
    $0.Timestamp? occurredAt,
    $core.String? note,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (milestone != null) result.milestone = milestone;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (note != null) result.note = note;
    if (version != null) result.version = version;
    return result;
  }

  RecordTripMilestoneRequest._();

  factory RecordTripMilestoneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTripMilestoneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTripMilestoneRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aE<Milestone>(2, _omitFieldNames ? '' : 'milestone',
        enumValues: Milestone.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..aInt64(5, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTripMilestoneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTripMilestoneRequest copyWith(
          void Function(RecordTripMilestoneRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordTripMilestoneRequest))
          as RecordTripMilestoneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTripMilestoneRequest create() => RecordTripMilestoneRequest._();
  @$core.override
  RecordTripMilestoneRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTripMilestoneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTripMilestoneRequest>(create);
  static RecordTripMilestoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  Milestone get milestone => $_getN(1);
  @$pb.TagNumber(2)
  set milestone(Milestone value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMilestone() => $_has(1);
  @$pb.TagNumber(2)
  void clearMilestone() => $_clearField(2);

  /// Defaults to now.
  @$pb.TagNumber(3)
  $0.Timestamp get occurredAt => $_getN(2);
  @$pb.TagNumber(3)
  set occurredAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureOccurredAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get version => $_getI64(4);
  @$pb.TagNumber(5)
  set version($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);
}

class RecordTripMilestoneResponse extends $pb.GeneratedMessage {
  factory RecordTripMilestoneResponse({
    Trip? trip,
  }) {
    final result = create();
    if (trip != null) result.trip = trip;
    return result;
  }

  RecordTripMilestoneResponse._();

  factory RecordTripMilestoneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTripMilestoneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTripMilestoneResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Trip>(1, _omitFieldNames ? '' : 'trip', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTripMilestoneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTripMilestoneResponse copyWith(
          void Function(RecordTripMilestoneResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordTripMilestoneResponse))
          as RecordTripMilestoneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTripMilestoneResponse create() =>
      RecordTripMilestoneResponse._();
  @$core.override
  RecordTripMilestoneResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTripMilestoneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTripMilestoneResponse>(create);
  static RecordTripMilestoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trip get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(Trip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => $_clearField(1);
  @$pb.TagNumber(1)
  Trip ensureTrip() => $_ensure(0);
}

class AmendTripMilestoneRequest extends $pb.GeneratedMessage {
  factory AmendTripMilestoneRequest({
    $core.String? tripId,
    Milestone? milestone,
    $0.Timestamp? occurredAt,
    $core.String? reason,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (milestone != null) result.milestone = milestone;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (reason != null) result.reason = reason;
    return result;
  }

  AmendTripMilestoneRequest._();

  factory AmendTripMilestoneRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendTripMilestoneRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendTripMilestoneRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aE<Milestone>(2, _omitFieldNames ? '' : 'milestone',
        enumValues: Milestone.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendTripMilestoneRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendTripMilestoneRequest copyWith(
          void Function(AmendTripMilestoneRequest) updates) =>
      super.copyWith((message) => updates(message as AmendTripMilestoneRequest))
          as AmendTripMilestoneRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendTripMilestoneRequest create() => AmendTripMilestoneRequest._();
  @$core.override
  AmendTripMilestoneRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendTripMilestoneRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendTripMilestoneRequest>(create);
  static AmendTripMilestoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  Milestone get milestone => $_getN(1);
  @$pb.TagNumber(2)
  set milestone(Milestone value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMilestone() => $_has(1);
  @$pb.TagNumber(2)
  void clearMilestone() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get occurredAt => $_getN(2);
  @$pb.TagNumber(3)
  set occurredAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOccurredAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearOccurredAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureOccurredAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class AmendTripMilestoneResponse extends $pb.GeneratedMessage {
  factory AmendTripMilestoneResponse({
    Trip? trip,
  }) {
    final result = create();
    if (trip != null) result.trip = trip;
    return result;
  }

  AmendTripMilestoneResponse._();

  factory AmendTripMilestoneResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendTripMilestoneResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendTripMilestoneResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Trip>(1, _omitFieldNames ? '' : 'trip', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendTripMilestoneResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendTripMilestoneResponse copyWith(
          void Function(AmendTripMilestoneResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AmendTripMilestoneResponse))
          as AmendTripMilestoneResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendTripMilestoneResponse create() => AmendTripMilestoneResponse._();
  @$core.override
  AmendTripMilestoneResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendTripMilestoneResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendTripMilestoneResponse>(create);
  static AmendTripMilestoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trip get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(Trip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => $_clearField(1);
  @$pb.TagNumber(1)
  Trip ensureTrip() => $_ensure(0);
}

class AbortTripRequest extends $pb.GeneratedMessage {
  factory AbortTripRequest({
    $core.String? tripId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  AbortTripRequest._();

  factory AbortTripRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AbortTripRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AbortTripRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AbortTripRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AbortTripRequest copyWith(void Function(AbortTripRequest) updates) =>
      super.copyWith((message) => updates(message as AbortTripRequest))
          as AbortTripRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AbortTripRequest create() => AbortTripRequest._();
  @$core.override
  AbortTripRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AbortTripRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AbortTripRequest>(create);
  static AbortTripRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class AbortTripResponse extends $pb.GeneratedMessage {
  factory AbortTripResponse({
    Trip? trip,
  }) {
    final result = create();
    if (trip != null) result.trip = trip;
    return result;
  }

  AbortTripResponse._();

  factory AbortTripResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AbortTripResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AbortTripResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Trip>(1, _omitFieldNames ? '' : 'trip', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AbortTripResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AbortTripResponse copyWith(void Function(AbortTripResponse) updates) =>
      super.copyWith((message) => updates(message as AbortTripResponse))
          as AbortTripResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AbortTripResponse create() => AbortTripResponse._();
  @$core.override
  AbortTripResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AbortTripResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AbortTripResponse>(create);
  static AbortTripResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trip get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(Trip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => $_clearField(1);
  @$pb.TagNumber(1)
  Trip ensureTrip() => $_ensure(0);
}

class GetTripRequest extends $pb.GeneratedMessage {
  factory GetTripRequest({
    $core.String? tripId,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    return result;
  }

  GetTripRequest._();

  factory GetTripRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTripRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTripRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripRequest copyWith(void Function(GetTripRequest) updates) =>
      super.copyWith((message) => updates(message as GetTripRequest))
          as GetTripRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTripRequest create() => GetTripRequest._();
  @$core.override
  GetTripRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTripRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTripRequest>(create);
  static GetTripRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);
}

class GetTripResponse extends $pb.GeneratedMessage {
  factory GetTripResponse({
    Trip? trip,
  }) {
    final result = create();
    if (trip != null) result.trip = trip;
    return result;
  }

  GetTripResponse._();

  factory GetTripResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTripResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTripResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Trip>(1, _omitFieldNames ? '' : 'trip', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripResponse copyWith(void Function(GetTripResponse) updates) =>
      super.copyWith((message) => updates(message as GetTripResponse))
          as GetTripResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTripResponse create() => GetTripResponse._();
  @$core.override
  GetTripResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTripResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTripResponse>(create);
  static GetTripResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Trip get trip => $_getN(0);
  @$pb.TagNumber(1)
  set trip(Trip value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTrip() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrip() => $_clearField(1);
  @$pb.TagNumber(1)
  Trip ensureTrip() => $_ensure(0);
}

class ListTripsRequest extends $pb.GeneratedMessage {
  factory ListTripsRequest({
    $core.Iterable<TripState>? states,
    $core.String? vehicleId,
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListTripsRequest._();

  factory ListTripsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTripsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTripsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<TripState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: TripState.valueOf,
        enumValues: TripState.values,
        defaultEnumValue: TripState.TRIP_STATE_UNSPECIFIED)
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTripsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTripsRequest copyWith(void Function(ListTripsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTripsRequest))
          as ListTripsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTripsRequest create() => ListTripsRequest._();
  @$core.override
  ListTripsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTripsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTripsRequest>(create);
  static ListTripsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TripState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

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
  $0.Timestamp get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get offset => $_getIZ(6);
  @$pb.TagNumber(7)
  set offset($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);
}

class ListTripsResponse extends $pb.GeneratedMessage {
  factory ListTripsResponse({
    $core.Iterable<Trip>? trips,
  }) {
    final result = create();
    if (trips != null) result.trips.addAll(trips);
    return result;
  }

  ListTripsResponse._();

  factory ListTripsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTripsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTripsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Trip>(1, _omitFieldNames ? '' : 'trips', subBuilder: Trip.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTripsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTripsResponse copyWith(void Function(ListTripsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTripsResponse))
          as ListTripsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTripsResponse create() => ListTripsResponse._();
  @$core.override
  ListTripsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTripsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTripsResponse>(create);
  static ListTripsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Trip> get trips => $_getList(0);
}

class GetTimelineGapsRequest extends $pb.GeneratedMessage {
  factory GetTimelineGapsRequest({
    $core.String? tripId,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    return result;
  }

  GetTimelineGapsRequest._();

  factory GetTimelineGapsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineGapsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineGapsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineGapsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineGapsRequest copyWith(
          void Function(GetTimelineGapsRequest) updates) =>
      super.copyWith((message) => updates(message as GetTimelineGapsRequest))
          as GetTimelineGapsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineGapsRequest create() => GetTimelineGapsRequest._();
  @$core.override
  GetTimelineGapsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTimelineGapsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineGapsRequest>(create);
  static GetTimelineGapsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);
}

class GetTimelineGapsResponse extends $pb.GeneratedMessage {
  factory GetTimelineGapsResponse({
    $core.Iterable<Milestone>? gaps,
  }) {
    final result = create();
    if (gaps != null) result.gaps.addAll(gaps);
    return result;
  }

  GetTimelineGapsResponse._();

  factory GetTimelineGapsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTimelineGapsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTimelineGapsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<Milestone>(1, _omitFieldNames ? '' : 'gaps', $pb.PbFieldType.KE,
        valueOf: Milestone.valueOf,
        enumValues: Milestone.values,
        defaultEnumValue: Milestone.MILESTONE_UNSPECIFIED)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineGapsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTimelineGapsResponse copyWith(
          void Function(GetTimelineGapsResponse) updates) =>
      super.copyWith((message) => updates(message as GetTimelineGapsResponse))
          as GetTimelineGapsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTimelineGapsResponse create() => GetTimelineGapsResponse._();
  @$core.override
  GetTimelineGapsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTimelineGapsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTimelineGapsResponse>(create);
  static GetTimelineGapsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Milestone> get gaps => $_getList(0);
}

class OpenPrehospitalRecordRequest extends $pb.GeneratedMessage {
  factory OpenPrehospitalRecordRequest({
    $core.String? tripId,
    $core.String? patientId,
    $core.String? facilityId,
    $core.String? presentingComplaint,
    $core.Iterable<$core.String>? documentRefs,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (presentingComplaint != null)
      result.presentingComplaint = presentingComplaint;
    if (documentRefs != null) result.documentRefs.addAll(documentRefs);
    return result;
  }

  OpenPrehospitalRecordRequest._();

  factory OpenPrehospitalRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenPrehospitalRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenPrehospitalRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'presentingComplaint')
    ..pPS(5, _omitFieldNames ? '' : 'documentRefs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenPrehospitalRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenPrehospitalRecordRequest copyWith(
          void Function(OpenPrehospitalRecordRequest) updates) =>
      super.copyWith(
              (message) => updates(message as OpenPrehospitalRecordRequest))
          as OpenPrehospitalRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenPrehospitalRecordRequest create() =>
      OpenPrehospitalRecordRequest._();
  @$core.override
  OpenPrehospitalRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenPrehospitalRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenPrehospitalRecordRequest>(create);
  static OpenPrehospitalRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get presentingComplaint => $_getSZ(3);
  @$pb.TagNumber(4)
  set presentingComplaint($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPresentingComplaint() => $_has(3);
  @$pb.TagNumber(4)
  void clearPresentingComplaint() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get documentRefs => $_getList(4);
}

class OpenPrehospitalRecordResponse extends $pb.GeneratedMessage {
  factory OpenPrehospitalRecordResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  OpenPrehospitalRecordResponse._();

  factory OpenPrehospitalRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenPrehospitalRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenPrehospitalRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenPrehospitalRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenPrehospitalRecordResponse copyWith(
          void Function(OpenPrehospitalRecordResponse) updates) =>
      super.copyWith(
              (message) => updates(message as OpenPrehospitalRecordResponse))
          as OpenPrehospitalRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenPrehospitalRecordResponse create() =>
      OpenPrehospitalRecordResponse._();
  @$core.override
  OpenPrehospitalRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenPrehospitalRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenPrehospitalRecordResponse>(create);
  static OpenPrehospitalRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class RecordPrehospitalEntryRequest extends $pb.GeneratedMessage {
  factory RecordPrehospitalEntryRequest({
    $core.String? recordId,
    EntryKind? kind,
    $core.String? code,
    $core.String? label,
    $core.String? value,
    $core.String? unit,
    $core.int? doseAmount,
    $core.String? doseUnit,
    $core.String? route,
    $core.String? narrative,
    $0.Timestamp? recordedAt,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (kind != null) result.kind = kind;
    if (code != null) result.code = code;
    if (label != null) result.label = label;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (doseAmount != null) result.doseAmount = doseAmount;
    if (doseUnit != null) result.doseUnit = doseUnit;
    if (route != null) result.route = route;
    if (narrative != null) result.narrative = narrative;
    if (recordedAt != null) result.recordedAt = recordedAt;
    return result;
  }

  RecordPrehospitalEntryRequest._();

  factory RecordPrehospitalEntryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPrehospitalEntryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPrehospitalEntryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aE<EntryKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: EntryKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'label')
    ..aOS(5, _omitFieldNames ? '' : 'value')
    ..aOS(6, _omitFieldNames ? '' : 'unit')
    ..aI(7, _omitFieldNames ? '' : 'doseAmount')
    ..aOS(8, _omitFieldNames ? '' : 'doseUnit')
    ..aOS(9, _omitFieldNames ? '' : 'route')
    ..aOS(10, _omitFieldNames ? '' : 'narrative')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPrehospitalEntryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPrehospitalEntryRequest copyWith(
          void Function(RecordPrehospitalEntryRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RecordPrehospitalEntryRequest))
          as RecordPrehospitalEntryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPrehospitalEntryRequest create() =>
      RecordPrehospitalEntryRequest._();
  @$core.override
  RecordPrehospitalEntryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPrehospitalEntryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPrehospitalEntryRequest>(create);
  static RecordPrehospitalEntryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  EntryKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(EntryKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get label => $_getSZ(3);
  @$pb.TagNumber(4)
  set label($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get value => $_getSZ(4);
  @$pb.TagNumber(5)
  set value($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get unit => $_getSZ(5);
  @$pb.TagNumber(6)
  set unit($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasUnit() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnit() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get doseAmount => $_getIZ(6);
  @$pb.TagNumber(7)
  set doseAmount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDoseAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearDoseAmount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get doseUnit => $_getSZ(7);
  @$pb.TagNumber(8)
  set doseUnit($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDoseUnit() => $_has(7);
  @$pb.TagNumber(8)
  void clearDoseUnit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get route => $_getSZ(8);
  @$pb.TagNumber(9)
  set route($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRoute() => $_has(8);
  @$pb.TagNumber(9)
  void clearRoute() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get narrative => $_getSZ(9);
  @$pb.TagNumber(10)
  set narrative($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNarrative() => $_has(9);
  @$pb.TagNumber(10)
  void clearNarrative() => $_clearField(10);

  /// When it happened. Defaults to now.
  @$pb.TagNumber(11)
  $0.Timestamp get recordedAt => $_getN(10);
  @$pb.TagNumber(11)
  set recordedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRecordedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRecordedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRecordedAt() => $_ensure(10);
}

class RecordPrehospitalEntryResponse extends $pb.GeneratedMessage {
  factory RecordPrehospitalEntryResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  RecordPrehospitalEntryResponse._();

  factory RecordPrehospitalEntryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPrehospitalEntryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPrehospitalEntryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPrehospitalEntryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPrehospitalEntryResponse copyWith(
          void Function(RecordPrehospitalEntryResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordPrehospitalEntryResponse))
          as RecordPrehospitalEntryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPrehospitalEntryResponse create() =>
      RecordPrehospitalEntryResponse._();
  @$core.override
  RecordPrehospitalEntryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPrehospitalEntryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPrehospitalEntryResponse>(create);
  static RecordPrehospitalEntryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class AttachTransferDocumentRequest extends $pb.GeneratedMessage {
  factory AttachTransferDocumentRequest({
    $core.String? recordId,
    $core.String? documentRef,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (documentRef != null) result.documentRef = documentRef;
    return result;
  }

  AttachTransferDocumentRequest._();

  factory AttachTransferDocumentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachTransferDocumentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachTransferDocumentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'documentRef')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachTransferDocumentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachTransferDocumentRequest copyWith(
          void Function(AttachTransferDocumentRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AttachTransferDocumentRequest))
          as AttachTransferDocumentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachTransferDocumentRequest create() =>
      AttachTransferDocumentRequest._();
  @$core.override
  AttachTransferDocumentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachTransferDocumentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachTransferDocumentRequest>(create);
  static AttachTransferDocumentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get documentRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set documentRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDocumentRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearDocumentRef() => $_clearField(2);
}

class AttachTransferDocumentResponse extends $pb.GeneratedMessage {
  factory AttachTransferDocumentResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  AttachTransferDocumentResponse._();

  factory AttachTransferDocumentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachTransferDocumentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachTransferDocumentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachTransferDocumentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachTransferDocumentResponse copyWith(
          void Function(AttachTransferDocumentResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AttachTransferDocumentResponse))
          as AttachTransferDocumentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachTransferDocumentResponse create() =>
      AttachTransferDocumentResponse._();
  @$core.override
  AttachTransferDocumentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachTransferDocumentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachTransferDocumentResponse>(create);
  static AttachTransferDocumentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class GiveHandoverRequest extends $pb.GeneratedMessage {
  factory GiveHandoverRequest({
    $core.String? recordId,
    $core.String? summary,
    $core.String? impression,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (summary != null) result.summary = summary;
    if (impression != null) result.impression = impression;
    if (version != null) result.version = version;
    return result;
  }

  GiveHandoverRequest._();

  factory GiveHandoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GiveHandoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GiveHandoverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'summary')
    ..aOS(3, _omitFieldNames ? '' : 'impression')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GiveHandoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GiveHandoverRequest copyWith(void Function(GiveHandoverRequest) updates) =>
      super.copyWith((message) => updates(message as GiveHandoverRequest))
          as GiveHandoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GiveHandoverRequest create() => GiveHandoverRequest._();
  @$core.override
  GiveHandoverRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GiveHandoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GiveHandoverRequest>(create);
  static GiveHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get summary => $_getSZ(1);
  @$pb.TagNumber(2)
  set summary($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSummary() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get impression => $_getSZ(2);
  @$pb.TagNumber(3)
  set impression($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasImpression() => $_has(2);
  @$pb.TagNumber(3)
  void clearImpression() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class GiveHandoverResponse extends $pb.GeneratedMessage {
  factory GiveHandoverResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  GiveHandoverResponse._();

  factory GiveHandoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GiveHandoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GiveHandoverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GiveHandoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GiveHandoverResponse copyWith(void Function(GiveHandoverResponse) updates) =>
      super.copyWith((message) => updates(message as GiveHandoverResponse))
          as GiveHandoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GiveHandoverResponse create() => GiveHandoverResponse._();
  @$core.override
  GiveHandoverResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GiveHandoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GiveHandoverResponse>(create);
  static GiveHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class AcceptHandoverRequest extends $pb.GeneratedMessage {
  factory AcceptHandoverRequest({
    $core.String? recordId,
    $core.String? encounterId,
    $core.String? note,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    if (encounterId != null) result.encounterId = encounterId;
    if (note != null) result.note = note;
    if (version != null) result.version = version;
    return result;
  }

  AcceptHandoverRequest._();

  factory AcceptHandoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcceptHandoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptHandoverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptHandoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptHandoverRequest copyWith(
          void Function(AcceptHandoverRequest) updates) =>
      super.copyWith((message) => updates(message as AcceptHandoverRequest))
          as AcceptHandoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptHandoverRequest create() => AcceptHandoverRequest._();
  @$core.override
  AcceptHandoverRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcceptHandoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptHandoverRequest>(create);
  static AcceptHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);

  /// The encounter the crew's account attaches to.
  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class AcceptHandoverResponse extends $pb.GeneratedMessage {
  factory AcceptHandoverResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  AcceptHandoverResponse._();

  factory AcceptHandoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcceptHandoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptHandoverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptHandoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptHandoverResponse copyWith(
          void Function(AcceptHandoverResponse) updates) =>
      super.copyWith((message) => updates(message as AcceptHandoverResponse))
          as AcceptHandoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptHandoverResponse create() => AcceptHandoverResponse._();
  @$core.override
  AcceptHandoverResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcceptHandoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptHandoverResponse>(create);
  static AcceptHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class GetPrehospitalRecordRequest extends $pb.GeneratedMessage {
  factory GetPrehospitalRecordRequest({
    $core.String? recordId,
  }) {
    final result = create();
    if (recordId != null) result.recordId = recordId;
    return result;
  }

  GetPrehospitalRecordRequest._();

  factory GetPrehospitalRecordRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPrehospitalRecordRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPrehospitalRecordRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recordId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrehospitalRecordRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrehospitalRecordRequest copyWith(
          void Function(GetPrehospitalRecordRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetPrehospitalRecordRequest))
          as GetPrehospitalRecordRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPrehospitalRecordRequest create() =>
      GetPrehospitalRecordRequest._();
  @$core.override
  GetPrehospitalRecordRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPrehospitalRecordRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPrehospitalRecordRequest>(create);
  static GetPrehospitalRecordRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recordId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recordId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRecordId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecordId() => $_clearField(1);
}

class GetPrehospitalRecordResponse extends $pb.GeneratedMessage {
  factory GetPrehospitalRecordResponse({
    PrehospitalRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  GetPrehospitalRecordResponse._();

  factory GetPrehospitalRecordResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPrehospitalRecordResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPrehospitalRecordResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrehospitalRecordResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPrehospitalRecordResponse copyWith(
          void Function(GetPrehospitalRecordResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetPrehospitalRecordResponse))
          as GetPrehospitalRecordResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPrehospitalRecordResponse create() =>
      GetPrehospitalRecordResponse._();
  @$core.override
  GetPrehospitalRecordResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPrehospitalRecordResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPrehospitalRecordResponse>(create);
  static GetPrehospitalRecordResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PrehospitalRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(PrehospitalRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  PrehospitalRecord ensureRecord() => $_ensure(0);
}

class ListPrehospitalRecordsRequest extends $pb.GeneratedMessage {
  factory ListPrehospitalRecordsRequest({
    $core.Iterable<HandoverState>? states,
    $core.String? facilityId,
    $core.String? patientId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (facilityId != null) result.facilityId = facilityId;
    if (patientId != null) result.patientId = patientId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListPrehospitalRecordsRequest._();

  factory ListPrehospitalRecordsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrehospitalRecordsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrehospitalRecordsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<HandoverState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: HandoverState.valueOf,
        enumValues: HandoverState.values,
        defaultEnumValue: HandoverState.HANDOVER_STATE_UNSPECIFIED)
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..aI(7, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrehospitalRecordsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrehospitalRecordsRequest copyWith(
          void Function(ListPrehospitalRecordsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPrehospitalRecordsRequest))
          as ListPrehospitalRecordsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrehospitalRecordsRequest create() =>
      ListPrehospitalRecordsRequest._();
  @$core.override
  ListPrehospitalRecordsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrehospitalRecordsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrehospitalRecordsRequest>(create);
  static ListPrehospitalRecordsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<HandoverState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

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
  $0.Timestamp get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get offset => $_getIZ(6);
  @$pb.TagNumber(7)
  set offset($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);
}

class ListPrehospitalRecordsResponse extends $pb.GeneratedMessage {
  factory ListPrehospitalRecordsResponse({
    $core.Iterable<PrehospitalRecord>? records,
  }) {
    final result = create();
    if (records != null) result.records.addAll(records);
    return result;
  }

  ListPrehospitalRecordsResponse._();

  factory ListPrehospitalRecordsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPrehospitalRecordsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPrehospitalRecordsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<PrehospitalRecord>(1, _omitFieldNames ? '' : 'records',
        subBuilder: PrehospitalRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrehospitalRecordsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPrehospitalRecordsResponse copyWith(
          void Function(ListPrehospitalRecordsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPrehospitalRecordsResponse))
          as ListPrehospitalRecordsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPrehospitalRecordsResponse create() =>
      ListPrehospitalRecordsResponse._();
  @$core.override
  ListPrehospitalRecordsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPrehospitalRecordsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPrehospitalRecordsResponse>(create);
  static ListPrehospitalRecordsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PrehospitalRecord> get records => $_getList(0);
}

class RecordPingRequest extends $pb.GeneratedMessage {
  factory RecordPingRequest({
    $core.String? vehicleId,
    $core.String? tripId,
    $core.int? latitudeMicro,
    $core.int? longitudeMicro,
    $core.int? speedKph,
    $core.int? headingDegrees,
    $core.int? accuracyMetres,
    $core.String? source,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    if (latitudeMicro != null) result.latitudeMicro = latitudeMicro;
    if (longitudeMicro != null) result.longitudeMicro = longitudeMicro;
    if (speedKph != null) result.speedKph = speedKph;
    if (headingDegrees != null) result.headingDegrees = headingDegrees;
    if (accuracyMetres != null) result.accuracyMetres = accuracyMetres;
    if (source != null) result.source = source;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  RecordPingRequest._();

  factory RecordPingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..aI(3, _omitFieldNames ? '' : 'latitudeMicro')
    ..aI(4, _omitFieldNames ? '' : 'longitudeMicro')
    ..aI(5, _omitFieldNames ? '' : 'speedKph')
    ..aI(6, _omitFieldNames ? '' : 'headingDegrees')
    ..aI(7, _omitFieldNames ? '' : 'accuracyMetres')
    ..aOS(8, _omitFieldNames ? '' : 'source')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPingRequest copyWith(void Function(RecordPingRequest) updates) =>
      super.copyWith((message) => updates(message as RecordPingRequest))
          as RecordPingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPingRequest create() => RecordPingRequest._();
  @$core.override
  RecordPingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPingRequest>(create);
  static RecordPingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get latitudeMicro => $_getIZ(2);
  @$pb.TagNumber(3)
  set latitudeMicro($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLatitudeMicro() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitudeMicro() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get longitudeMicro => $_getIZ(3);
  @$pb.TagNumber(4)
  set longitudeMicro($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLongitudeMicro() => $_has(3);
  @$pb.TagNumber(4)
  void clearLongitudeMicro() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get speedKph => $_getIZ(4);
  @$pb.TagNumber(5)
  set speedKph($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSpeedKph() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpeedKph() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get headingDegrees => $_getIZ(5);
  @$pb.TagNumber(6)
  set headingDegrees($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHeadingDegrees() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeadingDegrees() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get accuracyMetres => $_getIZ(6);
  @$pb.TagNumber(7)
  set accuracyMetres($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAccuracyMetres() => $_has(6);
  @$pb.TagNumber(7)
  void clearAccuracyMetres() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get source => $_getSZ(7);
  @$pb.TagNumber(8)
  set source($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get occurredAt => $_getN(8);
  @$pb.TagNumber(9)
  set occurredAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasOccurredAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearOccurredAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureOccurredAt() => $_ensure(8);
}

class RecordPingResponse extends $pb.GeneratedMessage {
  factory RecordPingResponse({
    Ping? ping,
  }) {
    final result = create();
    if (ping != null) result.ping = ping;
    return result;
  }

  RecordPingResponse._();

  factory RecordPingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordPingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordPingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Ping>(1, _omitFieldNames ? '' : 'ping', subBuilder: Ping.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordPingResponse copyWith(void Function(RecordPingResponse) updates) =>
      super.copyWith((message) => updates(message as RecordPingResponse))
          as RecordPingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordPingResponse create() => RecordPingResponse._();
  @$core.override
  RecordPingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordPingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordPingResponse>(create);
  static RecordPingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ping get ping => $_getN(0);
  @$pb.TagNumber(1)
  set ping(Ping value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPing() => $_has(0);
  @$pb.TagNumber(1)
  void clearPing() => $_clearField(1);
  @$pb.TagNumber(1)
  Ping ensurePing() => $_ensure(0);
}

class RecordETARequest extends $pb.GeneratedMessage {
  factory RecordETARequest({
    $core.String? vehicleId,
    $core.String? tripId,
    $core.int? seconds,
    $core.int? distanceMetres,
    $core.String? source,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    if (seconds != null) result.seconds = seconds;
    if (distanceMetres != null) result.distanceMetres = distanceMetres;
    if (source != null) result.source = source;
    return result;
  }

  RecordETARequest._();

  factory RecordETARequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordETARequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordETARequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..aI(3, _omitFieldNames ? '' : 'seconds')
    ..aI(4, _omitFieldNames ? '' : 'distanceMetres')
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordETARequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordETARequest copyWith(void Function(RecordETARequest) updates) =>
      super.copyWith((message) => updates(message as RecordETARequest))
          as RecordETARequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordETARequest create() => RecordETARequest._();
  @$core.override
  RecordETARequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordETARequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordETARequest>(create);
  static RecordETARequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get seconds => $_getIZ(2);
  @$pb.TagNumber(3)
  set seconds($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get distanceMetres => $_getIZ(3);
  @$pb.TagNumber(4)
  set distanceMetres($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDistanceMetres() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistanceMetres() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);
}

class RecordETAResponse extends $pb.GeneratedMessage {
  factory RecordETAResponse({
    ETA? eta,
  }) {
    final result = create();
    if (eta != null) result.eta = eta;
    return result;
  }

  RecordETAResponse._();

  factory RecordETAResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordETAResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordETAResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ETA>(1, _omitFieldNames ? '' : 'eta', subBuilder: ETA.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordETAResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordETAResponse copyWith(void Function(RecordETAResponse) updates) =>
      super.copyWith((message) => updates(message as RecordETAResponse))
          as RecordETAResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordETAResponse create() => RecordETAResponse._();
  @$core.override
  RecordETAResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordETAResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordETAResponse>(create);
  static RecordETAResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ETA get eta => $_getN(0);
  @$pb.TagNumber(1)
  set eta(ETA value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEta() => $_has(0);
  @$pb.TagNumber(1)
  void clearEta() => $_clearField(1);
  @$pb.TagNumber(1)
  ETA ensureEta() => $_ensure(0);
}

class GetVehiclePositionRequest extends $pb.GeneratedMessage {
  factory GetVehiclePositionRequest({
    $core.String? vehicleId,
    $core.String? tripId,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    return result;
  }

  GetVehiclePositionRequest._();

  factory GetVehiclePositionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVehiclePositionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVehiclePositionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehiclePositionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehiclePositionRequest copyWith(
          void Function(GetVehiclePositionRequest) updates) =>
      super.copyWith((message) => updates(message as GetVehiclePositionRequest))
          as GetVehiclePositionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVehiclePositionRequest create() => GetVehiclePositionRequest._();
  @$core.override
  GetVehiclePositionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVehiclePositionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVehiclePositionRequest>(create);
  static GetVehiclePositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);
}

class GetVehiclePositionResponse extends $pb.GeneratedMessage {
  factory GetVehiclePositionResponse({
    Position? position,
    ETA? eta,
  }) {
    final result = create();
    if (position != null) result.position = position;
    if (eta != null) result.eta = eta;
    return result;
  }

  GetVehiclePositionResponse._();

  factory GetVehiclePositionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetVehiclePositionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetVehiclePositionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<Position>(1, _omitFieldNames ? '' : 'position',
        subBuilder: Position.create)
    ..aOM<ETA>(2, _omitFieldNames ? '' : 'eta', subBuilder: ETA.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehiclePositionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetVehiclePositionResponse copyWith(
          void Function(GetVehiclePositionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetVehiclePositionResponse))
          as GetVehiclePositionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetVehiclePositionResponse create() => GetVehiclePositionResponse._();
  @$core.override
  GetVehiclePositionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetVehiclePositionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetVehiclePositionResponse>(create);
  static GetVehiclePositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Position get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(Position value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);
  @$pb.TagNumber(1)
  Position ensurePosition() => $_ensure(0);

  @$pb.TagNumber(2)
  ETA get eta => $_getN(1);
  @$pb.TagNumber(2)
  set eta(ETA value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEta() => $_has(1);
  @$pb.TagNumber(2)
  void clearEta() => $_clearField(2);
  @$pb.TagNumber(2)
  ETA ensureEta() => $_ensure(1);
}

class ListPingsRequest extends $pb.GeneratedMessage {
  factory ListPingsRequest({
    $core.String? vehicleId,
    $core.String? tripId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (tripId != null) result.tripId = tripId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPingsRequest._();

  factory ListPingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(2, _omitFieldNames ? '' : 'tripId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPingsRequest copyWith(void Function(ListPingsRequest) updates) =>
      super.copyWith((message) => updates(message as ListPingsRequest))
          as ListPingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPingsRequest create() => ListPingsRequest._();
  @$core.override
  ListPingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPingsRequest>(create);
  static ListPingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vehicleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set vehicleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tripId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tripId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTripId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTripId() => $_clearField(2);

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
  $0.Timestamp get to => $_getN(3);
  @$pb.TagNumber(4)
  set to($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearTo() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTo() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListPingsResponse extends $pb.GeneratedMessage {
  factory ListPingsResponse({
    $core.Iterable<Ping>? pings,
  }) {
    final result = create();
    if (pings != null) result.pings.addAll(pings);
    return result;
  }

  ListPingsResponse._();

  factory ListPingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pPM<Ping>(1, _omitFieldNames ? '' : 'pings', subBuilder: Ping.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPingsResponse copyWith(void Function(ListPingsResponse) updates) =>
      super.copyWith((message) => updates(message as ListPingsResponse))
          as ListPingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPingsResponse create() => ListPingsResponse._();
  @$core.override
  ListPingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPingsResponse>(create);
  static ListPingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Ping> get pings => $_getList(0);
}

class PurgeExpiredPingsRequest extends $pb.GeneratedMessage {
  factory PurgeExpiredPingsRequest() => create();

  PurgeExpiredPingsRequest._();

  factory PurgeExpiredPingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurgeExpiredPingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurgeExpiredPingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeExpiredPingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeExpiredPingsRequest copyWith(
          void Function(PurgeExpiredPingsRequest) updates) =>
      super.copyWith((message) => updates(message as PurgeExpiredPingsRequest))
          as PurgeExpiredPingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurgeExpiredPingsRequest create() => PurgeExpiredPingsRequest._();
  @$core.override
  PurgeExpiredPingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurgeExpiredPingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurgeExpiredPingsRequest>(create);
  static PurgeExpiredPingsRequest? _defaultInstance;
}

class PurgeExpiredPingsResponse extends $pb.GeneratedMessage {
  factory PurgeExpiredPingsResponse({
    $fixnum.Int64? removed,
  }) {
    final result = create();
    if (removed != null) result.removed = removed;
    return result;
  }

  PurgeExpiredPingsResponse._();

  factory PurgeExpiredPingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurgeExpiredPingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurgeExpiredPingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'removed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeExpiredPingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurgeExpiredPingsResponse copyWith(
          void Function(PurgeExpiredPingsResponse) updates) =>
      super.copyWith((message) => updates(message as PurgeExpiredPingsResponse))
          as PurgeExpiredPingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurgeExpiredPingsResponse create() => PurgeExpiredPingsResponse._();
  @$core.override
  PurgeExpiredPingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurgeExpiredPingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurgeExpiredPingsResponse>(create);
  static PurgeExpiredPingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get removed => $_getI64(0);
  @$pb.TagNumber(1)
  set removed($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRemoved() => $_has(0);
  @$pb.TagNumber(1)
  void clearRemoved() => $_clearField(1);
}

class GetTripMetricsRequest extends $pb.GeneratedMessage {
  factory GetTripMetricsRequest({
    $core.String? tripId,
  }) {
    final result = create();
    if (tripId != null) result.tripId = tripId;
    return result;
  }

  GetTripMetricsRequest._();

  factory GetTripMetricsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTripMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTripMetricsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tripId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripMetricsRequest copyWith(
          void Function(GetTripMetricsRequest) updates) =>
      super.copyWith((message) => updates(message as GetTripMetricsRequest))
          as GetTripMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTripMetricsRequest create() => GetTripMetricsRequest._();
  @$core.override
  GetTripMetricsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTripMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTripMetricsRequest>(create);
  static GetTripMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tripId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tripId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTripId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTripId() => $_clearField(1);
}

class GetTripMetricsResponse extends $pb.GeneratedMessage {
  factory GetTripMetricsResponse({
    TripMetrics? metrics,
  }) {
    final result = create();
    if (metrics != null) result.metrics = metrics;
    return result;
  }

  GetTripMetricsResponse._();

  factory GetTripMetricsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTripMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTripMetricsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<TripMetrics>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: TripMetrics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTripMetricsResponse copyWith(
          void Function(GetTripMetricsResponse) updates) =>
      super.copyWith((message) => updates(message as GetTripMetricsResponse))
          as GetTripMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTripMetricsResponse create() => GetTripMetricsResponse._();
  @$core.override
  GetTripMetricsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTripMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTripMetricsResponse>(create);
  static GetTripMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TripMetrics get metrics => $_getN(0);
  @$pb.TagNumber(1)
  set metrics(TripMetrics value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetrics() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetrics() => $_clearField(1);
  @$pb.TagNumber(1)
  TripMetrics ensureMetrics() => $_ensure(0);
}

class GetServiceSummaryRequest extends $pb.GeneratedMessage {
  factory GetServiceSummaryRequest({
    $core.Iterable<TripState>? states,
    $core.String? vehicleId,
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (states != null) result.states.addAll(states);
    if (vehicleId != null) result.vehicleId = vehicleId;
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetServiceSummaryRequest._();

  factory GetServiceSummaryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServiceSummaryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServiceSummaryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..pc<TripState>(1, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: TripState.valueOf,
        enumValues: TripState.values,
        defaultEnumValue: TripState.TRIP_STATE_UNSPECIFIED)
    ..aOS(2, _omitFieldNames ? '' : 'vehicleId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceSummaryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceSummaryRequest copyWith(
          void Function(GetServiceSummaryRequest) updates) =>
      super.copyWith((message) => updates(message as GetServiceSummaryRequest))
          as GetServiceSummaryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceSummaryRequest create() => GetServiceSummaryRequest._();
  @$core.override
  GetServiceSummaryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServiceSummaryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServiceSummaryRequest>(create);
  static GetServiceSummaryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TripState> get states => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get vehicleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set vehicleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVehicleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVehicleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

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
  $0.Timestamp get to => $_getN(4);
  @$pb.TagNumber(5)
  set to($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTo() => $_ensure(4);
}

class GetServiceSummaryResponse extends $pb.GeneratedMessage {
  factory GetServiceSummaryResponse({
    ServiceSummary? summary,
    $core.bool? truncated,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetServiceSummaryResponse._();

  factory GetServiceSummaryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetServiceSummaryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetServiceSummaryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: ServiceSummary.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceSummaryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetServiceSummaryResponse copyWith(
          void Function(GetServiceSummaryResponse) updates) =>
      super.copyWith((message) => updates(message as GetServiceSummaryResponse))
          as GetServiceSummaryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceSummaryResponse create() => GetServiceSummaryResponse._();
  @$core.override
  GetServiceSummaryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetServiceSummaryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetServiceSummaryResponse>(create);
  static GetServiceSummaryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(ServiceSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceSummary ensureSummary() => $_ensure(0);

  /// The window held more rows than one report may read, so these figures
  /// come from part of it.
  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

class SweepWaitingHandoversRequest extends $pb.GeneratedMessage {
  factory SweepWaitingHandoversRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  SweepWaitingHandoversRequest._();

  factory SweepWaitingHandoversRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepWaitingHandoversRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepWaitingHandoversRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepWaitingHandoversRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepWaitingHandoversRequest copyWith(
          void Function(SweepWaitingHandoversRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SweepWaitingHandoversRequest))
          as SweepWaitingHandoversRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepWaitingHandoversRequest create() =>
      SweepWaitingHandoversRequest._();
  @$core.override
  SweepWaitingHandoversRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepWaitingHandoversRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepWaitingHandoversRequest>(create);
  static SweepWaitingHandoversRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class SweepWaitingHandoversResponse extends $pb.GeneratedMessage {
  factory SweepWaitingHandoversResponse({
    $core.int? raised,
  }) {
    final result = create();
    if (raised != null) result.raised = raised;
    return result;
  }

  SweepWaitingHandoversResponse._();

  factory SweepWaitingHandoversResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SweepWaitingHandoversResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SweepWaitingHandoversResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.ambulance.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'raised')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepWaitingHandoversResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SweepWaitingHandoversResponse copyWith(
          void Function(SweepWaitingHandoversResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SweepWaitingHandoversResponse))
          as SweepWaitingHandoversResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SweepWaitingHandoversResponse create() =>
      SweepWaitingHandoversResponse._();
  @$core.override
  SweepWaitingHandoversResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SweepWaitingHandoversResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SweepWaitingHandoversResponse>(create);
  static SweepWaitingHandoversResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get raised => $_getIZ(0);
  @$pb.TagNumber(1)
  set raised($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRaised() => $_has(0);
  @$pb.TagNumber(1)
  void clearRaised() => $_clearField(1);
}

/// Ambulance and fleet operations (SRS-AMB-001 … 008).
class AmbulanceServiceApi {
  final $pb.RpcClient _client;

  AmbulanceServiceApi(this._client);

  /// SRS-AMB-002.
  $async.Future<RegisterVehicleResponse> registerVehicle(
          $pb.ClientContext? ctx, RegisterVehicleRequest request) =>
      _client.invoke<RegisterVehicleResponse>(ctx, 'AmbulanceService',
          'RegisterVehicle', request, RegisterVehicleResponse());
  $async.Future<SetVehicleStateResponse> setVehicleState(
          $pb.ClientContext? ctx, SetVehicleStateRequest request) =>
      _client.invoke<SetVehicleStateResponse>(ctx, 'AmbulanceService',
          'SetVehicleState', request, SetVehicleStateResponse());
  $async.Future<GetVehicleResponse> getVehicle(
          $pb.ClientContext? ctx, GetVehicleRequest request) =>
      _client.invoke<GetVehicleResponse>(
          ctx, 'AmbulanceService', 'GetVehicle', request, GetVehicleResponse());
  $async.Future<ListVehiclesResponse> listVehicles(
          $pb.ClientContext? ctx, ListVehiclesRequest request) =>
      _client.invoke<ListVehiclesResponse>(ctx, 'AmbulanceService',
          'ListVehicles', request, ListVehiclesResponse());
  $async.Future<RosterShiftResponse> rosterShift(
          $pb.ClientContext? ctx, RosterShiftRequest request) =>
      _client.invoke<RosterShiftResponse>(ctx, 'AmbulanceService',
          'RosterShift', request, RosterShiftResponse());
  $async.Future<SetShiftStateResponse> setShiftState(
          $pb.ClientContext? ctx, SetShiftStateRequest request) =>
      _client.invoke<SetShiftStateResponse>(ctx, 'AmbulanceService',
          'SetShiftState', request, SetShiftStateResponse());
  $async.Future<GetShiftResponse> getShift(
          $pb.ClientContext? ctx, GetShiftRequest request) =>
      _client.invoke<GetShiftResponse>(
          ctx, 'AmbulanceService', 'GetShift', request, GetShiftResponse());
  $async.Future<ListShiftsResponse> listShifts(
          $pb.ClientContext? ctx, ListShiftsRequest request) =>
      _client.invoke<ListShiftsResponse>(
          ctx, 'AmbulanceService', 'ListShifts', request, ListShiftsResponse());

  /// SRS-AMB-006.
  $async.Future<RecordReadinessCheckResponse> recordReadinessCheck(
          $pb.ClientContext? ctx, RecordReadinessCheckRequest request) =>
      _client.invoke<RecordReadinessCheckResponse>(ctx, 'AmbulanceService',
          'RecordReadinessCheck', request, RecordReadinessCheckResponse());
  $async.Future<OverrideReadinessCheckResponse> overrideReadinessCheck(
          $pb.ClientContext? ctx, OverrideReadinessCheckRequest request) =>
      _client.invoke<OverrideReadinessCheckResponse>(ctx, 'AmbulanceService',
          'OverrideReadinessCheck', request, OverrideReadinessCheckResponse());
  $async.Future<GetReadinessCheckResponse> getReadinessCheck(
          $pb.ClientContext? ctx, GetReadinessCheckRequest request) =>
      _client.invoke<GetReadinessCheckResponse>(ctx, 'AmbulanceService',
          'GetReadinessCheck', request, GetReadinessCheckResponse());
  $async.Future<ListReadinessChecksResponse> listReadinessChecks(
          $pb.ClientContext? ctx, ListReadinessChecksRequest request) =>
      _client.invoke<ListReadinessChecksResponse>(ctx, 'AmbulanceService',
          'ListReadinessChecks', request, ListReadinessChecksResponse());
  $async.Future<GetReadinessSummaryResponse> getReadinessSummary(
          $pb.ClientContext? ctx, GetReadinessSummaryRequest request) =>
      _client.invoke<GetReadinessSummaryResponse>(ctx, 'AmbulanceService',
          'GetReadinessSummary', request, GetReadinessSummaryResponse());

  /// SRS-AMB-001.
  $async.Future<RaiseRequestResponse> raiseRequest(
          $pb.ClientContext? ctx, RaiseRequestRequest request) =>
      _client.invoke<RaiseRequestResponse>(ctx, 'AmbulanceService',
          'RaiseRequest', request, RaiseRequestResponse());
  $async.Future<CancelRequestResponse> cancelRequest(
          $pb.ClientContext? ctx, CancelRequestRequest request) =>
      _client.invoke<CancelRequestResponse>(ctx, 'AmbulanceService',
          'CancelRequest', request, CancelRequestResponse());
  $async.Future<GetRequestResponse> getRequest(
          $pb.ClientContext? ctx, GetRequestRequest request) =>
      _client.invoke<GetRequestResponse>(
          ctx, 'AmbulanceService', 'GetRequest', request, GetRequestResponse());
  $async.Future<ListRequestsResponse> listRequests(
          $pb.ClientContext? ctx, ListRequestsRequest request) =>
      _client.invoke<ListRequestsResponse>(ctx, 'AmbulanceService',
          'ListRequests', request, ListRequestsResponse());
  $async.Future<GetDispatchQueueResponse> getDispatchQueue(
          $pb.ClientContext? ctx, GetDispatchQueueRequest request) =>
      _client.invoke<GetDispatchQueueResponse>(ctx, 'AmbulanceService',
          'GetDispatchQueue', request, GetDispatchQueueResponse());

  /// SRS-AMB-003.
  $async.Future<DispatchResponse> dispatch(
          $pb.ClientContext? ctx, DispatchRequest request) =>
      _client.invoke<DispatchResponse>(
          ctx, 'AmbulanceService', 'Dispatch', request, DispatchResponse());
  $async.Future<RecordTripMilestoneResponse> recordTripMilestone(
          $pb.ClientContext? ctx, RecordTripMilestoneRequest request) =>
      _client.invoke<RecordTripMilestoneResponse>(ctx, 'AmbulanceService',
          'RecordTripMilestone', request, RecordTripMilestoneResponse());
  $async.Future<AmendTripMilestoneResponse> amendTripMilestone(
          $pb.ClientContext? ctx, AmendTripMilestoneRequest request) =>
      _client.invoke<AmendTripMilestoneResponse>(ctx, 'AmbulanceService',
          'AmendTripMilestone', request, AmendTripMilestoneResponse());
  $async.Future<AbortTripResponse> abortTrip(
          $pb.ClientContext? ctx, AbortTripRequest request) =>
      _client.invoke<AbortTripResponse>(
          ctx, 'AmbulanceService', 'AbortTrip', request, AbortTripResponse());
  $async.Future<GetTripResponse> getTrip(
          $pb.ClientContext? ctx, GetTripRequest request) =>
      _client.invoke<GetTripResponse>(
          ctx, 'AmbulanceService', 'GetTrip', request, GetTripResponse());
  $async.Future<ListTripsResponse> listTrips(
          $pb.ClientContext? ctx, ListTripsRequest request) =>
      _client.invoke<ListTripsResponse>(
          ctx, 'AmbulanceService', 'ListTrips', request, ListTripsResponse());
  $async.Future<GetTimelineGapsResponse> getTimelineGaps(
          $pb.ClientContext? ctx, GetTimelineGapsRequest request) =>
      _client.invoke<GetTimelineGapsResponse>(ctx, 'AmbulanceService',
          'GetTimelineGaps', request, GetTimelineGapsResponse());

  /// SRS-AMB-004 and SRS-AMB-007.
  $async.Future<OpenPrehospitalRecordResponse> openPrehospitalRecord(
          $pb.ClientContext? ctx, OpenPrehospitalRecordRequest request) =>
      _client.invoke<OpenPrehospitalRecordResponse>(ctx, 'AmbulanceService',
          'OpenPrehospitalRecord', request, OpenPrehospitalRecordResponse());
  $async.Future<RecordPrehospitalEntryResponse> recordPrehospitalEntry(
          $pb.ClientContext? ctx, RecordPrehospitalEntryRequest request) =>
      _client.invoke<RecordPrehospitalEntryResponse>(ctx, 'AmbulanceService',
          'RecordPrehospitalEntry', request, RecordPrehospitalEntryResponse());
  $async.Future<AttachTransferDocumentResponse> attachTransferDocument(
          $pb.ClientContext? ctx, AttachTransferDocumentRequest request) =>
      _client.invoke<AttachTransferDocumentResponse>(ctx, 'AmbulanceService',
          'AttachTransferDocument', request, AttachTransferDocumentResponse());
  $async.Future<GiveHandoverResponse> giveHandover(
          $pb.ClientContext? ctx, GiveHandoverRequest request) =>
      _client.invoke<GiveHandoverResponse>(ctx, 'AmbulanceService',
          'GiveHandover', request, GiveHandoverResponse());
  $async.Future<AcceptHandoverResponse> acceptHandover(
          $pb.ClientContext? ctx, AcceptHandoverRequest request) =>
      _client.invoke<AcceptHandoverResponse>(ctx, 'AmbulanceService',
          'AcceptHandover', request, AcceptHandoverResponse());
  $async.Future<GetPrehospitalRecordResponse> getPrehospitalRecord(
          $pb.ClientContext? ctx, GetPrehospitalRecordRequest request) =>
      _client.invoke<GetPrehospitalRecordResponse>(ctx, 'AmbulanceService',
          'GetPrehospitalRecord', request, GetPrehospitalRecordResponse());
  $async.Future<ListPrehospitalRecordsResponse> listPrehospitalRecords(
          $pb.ClientContext? ctx, ListPrehospitalRecordsRequest request) =>
      _client.invoke<ListPrehospitalRecordsResponse>(ctx, 'AmbulanceService',
          'ListPrehospitalRecords', request, ListPrehospitalRecordsResponse());
  $async.Future<SweepWaitingHandoversResponse> sweepWaitingHandovers(
          $pb.ClientContext? ctx, SweepWaitingHandoversRequest request) =>
      _client.invoke<SweepWaitingHandoversResponse>(ctx, 'AmbulanceService',
          'SweepWaitingHandovers', request, SweepWaitingHandoversResponse());

  /// SRS-AMB-005.
  $async.Future<RecordPingResponse> recordPing(
          $pb.ClientContext? ctx, RecordPingRequest request) =>
      _client.invoke<RecordPingResponse>(
          ctx, 'AmbulanceService', 'RecordPing', request, RecordPingResponse());
  $async.Future<RecordETAResponse> recordETA(
          $pb.ClientContext? ctx, RecordETARequest request) =>
      _client.invoke<RecordETAResponse>(
          ctx, 'AmbulanceService', 'RecordETA', request, RecordETAResponse());
  $async.Future<GetVehiclePositionResponse> getVehiclePosition(
          $pb.ClientContext? ctx, GetVehiclePositionRequest request) =>
      _client.invoke<GetVehiclePositionResponse>(ctx, 'AmbulanceService',
          'GetVehiclePosition', request, GetVehiclePositionResponse());
  $async.Future<ListPingsResponse> listPings(
          $pb.ClientContext? ctx, ListPingsRequest request) =>
      _client.invoke<ListPingsResponse>(
          ctx, 'AmbulanceService', 'ListPings', request, ListPingsResponse());
  $async.Future<PurgeExpiredPingsResponse> purgeExpiredPings(
          $pb.ClientContext? ctx, PurgeExpiredPingsRequest request) =>
      _client.invoke<PurgeExpiredPingsResponse>(ctx, 'AmbulanceService',
          'PurgeExpiredPings', request, PurgeExpiredPingsResponse());

  /// SRS-AMB-008.
  $async.Future<GetTripMetricsResponse> getTripMetrics(
          $pb.ClientContext? ctx, GetTripMetricsRequest request) =>
      _client.invoke<GetTripMetricsResponse>(ctx, 'AmbulanceService',
          'GetTripMetrics', request, GetTripMetricsResponse());
  $async.Future<GetServiceSummaryResponse> getServiceSummary(
          $pb.ClientContext? ctx, GetServiceSummaryRequest request) =>
      _client.invoke<GetServiceSummaryResponse>(ctx, 'AmbulanceService',
          'GetServiceSummary', request, GetServiceSummaryResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
