// This is a generated file - do not edit.
//
// Generated from healthcare/organization/v1/organization.proto.

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

import '../../common/v1/common.pb.dart' as $1;
import 'organization.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'organization.pbenum.dart';

/// SRS-PLT-001. tenant_id is opaque and immutable; display name is not a key.
class Tenant extends $pb.GeneratedMessage {
  factory Tenant({
    $core.String? tenantId,
    $core.String? displayName,
    $core.String? legalJurisdiction,
    $core.String? defaultLocale,
    $core.String? timeZone,
    TenantStatus? status,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (tenantId != null) result.tenantId = tenantId;
    if (displayName != null) result.displayName = displayName;
    if (legalJurisdiction != null) result.legalJurisdiction = legalJurisdiction;
    if (defaultLocale != null) result.defaultLocale = defaultLocale;
    if (timeZone != null) result.timeZone = timeZone;
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    return result;
  }

  Tenant._();

  factory Tenant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Tenant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Tenant',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tenantId')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'legalJurisdiction')
    ..aOS(4, _omitFieldNames ? '' : 'defaultLocale')
    ..aOS(5, _omitFieldNames ? '' : 'timeZone')
    ..aE<TenantStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: TenantStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(9, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tenant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Tenant copyWith(void Function(Tenant) updates) =>
      super.copyWith((message) => updates(message as Tenant)) as Tenant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Tenant create() => Tenant._();
  @$core.override
  Tenant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Tenant getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Tenant>(create);
  static Tenant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tenantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tenantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenantId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  /// ISO 3166-1 alpha-2 of the governing jurisdiction.
  @$pb.TagNumber(3)
  $core.String get legalJurisdiction => $_getSZ(2);
  @$pb.TagNumber(3)
  set legalJurisdiction($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLegalJurisdiction() => $_has(2);
  @$pb.TagNumber(3)
  void clearLegalJurisdiction() => $_clearField(3);

  /// BCP-47, e.g. "en-IN".
  @$pb.TagNumber(4)
  $core.String get defaultLocale => $_getSZ(3);
  @$pb.TagNumber(4)
  set defaultLocale($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDefaultLocale() => $_has(3);
  @$pb.TagNumber(4)
  void clearDefaultLocale() => $_clearField(4);

  /// IANA zone, e.g. "Asia/Kolkata".
  @$pb.TagNumber(5)
  $core.String get timeZone => $_getSZ(4);
  @$pb.TagNumber(5)
  set timeZone($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTimeZone() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimeZone() => $_clearField(5);

  @$pb.TagNumber(6)
  TenantStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(TenantStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);

  /// Optimistic concurrency token.
  @$pb.TagNumber(9)
  $fixnum.Int64 get version => $_getI64(8);
  @$pb.TagNumber(9)
  set version($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);
}

/// SRS-PLT-002 / SRS-PLT-004 / SRS-PLT-007.
class Facility extends $pb.GeneratedMessage {
  factory Facility({
    $core.String? facilityId,
    $core.String? tenantId,
    $core.String? code,
    $core.String? displayName,
    FacilityType? type,
    FacilityStatus? status,
    $core.String? timeZone,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (tenantId != null) result.tenantId = tenantId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (type != null) result.type = type;
    if (status != null) result.status = status;
    if (timeZone != null) result.timeZone = timeZone;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    if (version != null) result.version = version;
    return result;
  }

  Facility._();

  factory Facility.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Facility.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Facility',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'tenantId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aE<FacilityType>(5, _omitFieldNames ? '' : 'type',
        enumValues: FacilityType.values)
    ..aE<FacilityStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: FacilityStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'timeZone')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Facility clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Facility copyWith(void Function(Facility) updates) =>
      super.copyWith((message) => updates(message as Facility)) as Facility;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Facility create() => Facility._();
  @$core.override
  Facility createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Facility getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Facility>(create);
  static Facility? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tenantId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tenantId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTenantId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTenantId() => $_clearField(2);

  /// Tenant-scoped unique business code. Renaming display_name must not break
  /// references, so code and name are distinct (SRS-PLT-007).
  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  FacilityType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(FacilityType value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  FacilityStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(FacilityStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get timeZone => $_getSZ(6);
  @$pb.TagNumber(7)
  set timeZone($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTimeZone() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeZone() => $_clearField(7);

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

  @$pb.TagNumber(9)
  $0.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureUpdatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

/// BedClass is a tenant's own category of accommodation and the charge it maps
/// to. A catalogue rather than an enumeration: "deluxe" and "twin sharing" are
/// commercial decisions, not something this contract can list in advance.
class BedClass extends $pb.GeneratedMessage {
  factory BedClass({
    $core.String? classId,
    $core.String? code,
    $core.String? displayName,
    $core.String? chargeCode,
    $core.String? status,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (classId != null) result.classId = classId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (chargeCode != null) result.chargeCode = chargeCode;
    if (status != null) result.status = status;
    if (version != null) result.version = version;
    return result;
  }

  BedClass._();

  factory BedClass.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedClass.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedClass',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'classId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..aOS(4, _omitFieldNames ? '' : 'chargeCode')
    ..aOS(5, _omitFieldNames ? '' : 'status')
    ..aInt64(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedClass clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedClass copyWith(void Function(BedClass) updates) =>
      super.copyWith((message) => updates(message as BedClass)) as BedClass;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedClass create() => BedClass._();
  @$core.override
  BedClass createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedClass getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BedClass>(create);
  static BedClass? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get classId => $_getSZ(0);
  @$pb.TagNumber(1)
  set classId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasClassId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClassId() => $_clearField(1);

  /// The key. It appears in tariff imports and on printed estimates, so it is
  /// stable while the display name is not (SRS-PLT-007).
  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);

  /// Required. What billing raises the accommodation charge against; a class
  /// that maps to nothing is a stay nobody can bill.
  @$pb.TagNumber(4)
  $core.String get chargeCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set chargeCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChargeCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearChargeCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get status => $_getSZ(4);
  @$pb.TagNumber(5)
  set status($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

/// Room is a physical space that holds beds. It carries the class, so every bed
/// in it is charged the same way.
class Room extends $pb.GeneratedMessage {
  factory Room({
    $core.String? roomId,
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? code,
    $core.String? displayName,
    $core.String? classCode,
    GenderPolicy? genderPolicy,
    IsolationCapability? isolation,
    $core.String? status,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (classCode != null) result.classCode = classCode;
    if (genderPolicy != null) result.genderPolicy = genderPolicy;
    if (isolation != null) result.isolation = isolation;
    if (status != null) result.status = status;
    if (version != null) result.version = version;
    return result;
  }

  Room._();

  factory Room.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Room.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Room',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'unitId')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'displayName')
    ..aOS(6, _omitFieldNames ? '' : 'classCode')
    ..aE<GenderPolicy>(7, _omitFieldNames ? '' : 'genderPolicy',
        enumValues: GenderPolicy.values)
    ..aE<IsolationCapability>(8, _omitFieldNames ? '' : 'isolation',
        enumValues: IsolationCapability.values)
    ..aOS(9, _omitFieldNames ? '' : 'status')
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Room copyWith(void Function(Room) updates) =>
      super.copyWith((message) => updates(message as Room)) as Room;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Room create() => Room._();
  @$core.override
  Room createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Room getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Room>(create);
  static Room? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  /// The ward or department: the hierarchy level above the room.
  @$pb.TagNumber(3)
  $core.String get unitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get displayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set displayName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplayName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get classCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set classCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasClassCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearClassCode() => $_clearField(6);

  @$pb.TagNumber(7)
  GenderPolicy get genderPolicy => $_getN(6);
  @$pb.TagNumber(7)
  set genderPolicy(GenderPolicy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasGenderPolicy() => $_has(6);
  @$pb.TagNumber(7)
  void clearGenderPolicy() => $_clearField(7);

  @$pb.TagNumber(8)
  IsolationCapability get isolation => $_getN(7);
  @$pb.TagNumber(8)
  set isolation(IsolationCapability value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIsolation() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsolation() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get status => $_getSZ(8);
  @$pb.TagNumber(9)
  set status($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

/// Bed is one physical bed.
class Bed extends $pb.GeneratedMessage {
  factory Bed({
    $core.String? bedId,
    $core.String? roomId,
    $core.String? facilityId,
    $core.String? code,
    $core.String? displayName,
    $core.String? status,
    BedAvailability? availability,
    $core.String? unavailableReason,
    $fixnum.Int64? version,
    $core.bool? usable,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    if (roomId != null) result.roomId = roomId;
    if (facilityId != null) result.facilityId = facilityId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (status != null) result.status = status;
    if (availability != null) result.availability = availability;
    if (unavailableReason != null) result.unavailableReason = unavailableReason;
    if (version != null) result.version = version;
    if (usable != null) result.usable = usable;
    return result;
  }

  Bed._();

  factory Bed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bed',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..aOS(2, _omitFieldNames ? '' : 'roomId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'code')
    ..aOS(5, _omitFieldNames ? '' : 'displayName')
    ..aOS(6, _omitFieldNames ? '' : 'status')
    ..aE<BedAvailability>(7, _omitFieldNames ? '' : 'availability',
        enumValues: BedAvailability.values)
    ..aOS(8, _omitFieldNames ? '' : 'unavailableReason')
    ..aInt64(9, _omitFieldNames ? '' : 'version')
    ..aOB(10, _omitFieldNames ? '' : 'usable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bed copyWith(void Function(Bed) updates) =>
      super.copyWith((message) => updates(message as Bed)) as Bed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bed create() => Bed._();
  @$core.override
  Bed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Bed getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bed>(create);
  static Bed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get roomId => $_getSZ(1);
  @$pb.TagNumber(2)
  set roomId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoomId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoomId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get code => $_getSZ(3);
  @$pb.TagNumber(4)
  set code($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get displayName => $_getSZ(4);
  @$pb.TagNumber(5)
  set displayName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDisplayName() => $_has(4);
  @$pb.TagNumber(5)
  void clearDisplayName() => $_clearField(5);

  /// Physical existence: active or retired. Retirement is terminal
  /// (SRS-PLT-015).
  @$pb.TagNumber(6)
  $core.String get status => $_getSZ(5);
  @$pb.TagNumber(6)
  set status($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  BedAvailability get availability => $_getN(6);
  @$pb.TagNumber(7)
  set availability(BedAvailability value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAvailability() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvailability() => $_clearField(7);

  /// Why, for the states that are somebody's decision rather than a
  /// consequence.
  @$pb.TagNumber(8)
  $core.String get unavailableReason => $_getSZ(7);
  @$pb.TagNumber(8)
  set unavailableReason($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUnavailableReason() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnavailableReason() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get version => $_getI64(8);
  @$pb.TagNumber(9)
  set version($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);

  /// Both halves together: the bed exists and is free. Derived rather than
  /// stored, so it cannot disagree with the two fields above.
  @$pb.TagNumber(10)
  $core.bool get usable => $_getBF(9);
  @$pb.TagNumber(10)
  set usable($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasUsable() => $_has(9);
  @$pb.TagNumber(10)
  void clearUsable() => $_clearField(10);
}

/// BedPlace is one row of a ward's board: a bed, its room and what it costs.
class BedPlace extends $pb.GeneratedMessage {
  factory BedPlace({
    Bed? bed,
    Room? room,
    BedClass? class_3,
  }) {
    final result = create();
    if (bed != null) result.bed = bed;
    if (room != null) result.room = room;
    if (class_3 != null) result.class_3 = class_3;
    return result;
  }

  BedPlace._();

  factory BedPlace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedPlace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedPlace',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Bed>(1, _omitFieldNames ? '' : 'bed', subBuilder: Bed.create)
    ..aOM<Room>(2, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..aOM<BedClass>(3, _omitFieldNames ? '' : 'class',
        subBuilder: BedClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedPlace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedPlace copyWith(void Function(BedPlace) updates) =>
      super.copyWith((message) => updates(message as BedPlace)) as BedPlace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedPlace create() => BedPlace._();
  @$core.override
  BedPlace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedPlace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BedPlace>(create);
  static BedPlace? _defaultInstance;

  @$pb.TagNumber(1)
  Bed get bed => $_getN(0);
  @$pb.TagNumber(1)
  set bed(Bed value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBed() => $_has(0);
  @$pb.TagNumber(1)
  void clearBed() => $_clearField(1);
  @$pb.TagNumber(1)
  Bed ensureBed() => $_ensure(0);

  @$pb.TagNumber(2)
  Room get room => $_getN(1);
  @$pb.TagNumber(2)
  set room(Room value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoom() => $_clearField(2);
  @$pb.TagNumber(2)
  Room ensureRoom() => $_ensure(1);

  @$pb.TagNumber(3)
  BedClass get class_3 => $_getN(2);
  @$pb.TagNumber(3)
  set class_3(BedClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasClass_3() => $_has(2);
  @$pb.TagNumber(3)
  void clearClass_3() => $_clearField(3);
  @$pb.TagNumber(3)
  BedClass ensureClass_3() => $_ensure(2);
}

/// CommissionOrgUnit is the hierarchy level a room hangs from (SRS-PLT-005).
///
/// It is here because the bed master needs it: a room belongs to a ward, and
/// until now org units could only be created through the repository, so
/// commissioning a ward over the wire was impossible.
class CommissionOrgUnitRequest extends $pb.GeneratedMessage {
  factory CommissionOrgUnitRequest({
    $core.String? facilityId,
    $core.String? unitType,
    $core.String? code,
    $core.String? displayName,
    $core.String? parentUnitId,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveUntil,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitType != null) result.unitType = unitType;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (parentUnitId != null) result.parentUnitId = parentUnitId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveUntil != null) result.effectiveUntil = effectiveUntil;
    return result;
  }

  CommissionOrgUnitRequest._();

  factory CommissionOrgUnitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionOrgUnitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionOrgUnitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitType')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aOS(5, _omitFieldNames ? '' : 'parentUnitId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'effectiveUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionOrgUnitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionOrgUnitRequest copyWith(
          void Function(CommissionOrgUnitRequest) updates) =>
      super.copyWith((message) => updates(message as CommissionOrgUnitRequest))
          as CommissionOrgUnitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionOrgUnitRequest create() => CommissionOrgUnitRequest._();
  @$core.override
  CommissionOrgUnitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionOrgUnitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionOrgUnitRequest>(create);
  static CommissionOrgUnitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  /// department, specialty, cost_center, service_unit or care_location.
  @$pb.TagNumber(2)
  $core.String get unitType => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitType($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitType() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get parentUnitId => $_getSZ(4);
  @$pb.TagNumber(5)
  set parentUnitId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParentUnitId() => $_has(4);
  @$pb.TagNumber(5)
  void clearParentUnitId() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get effectiveFrom => $_getN(5);
  @$pb.TagNumber(6)
  set effectiveFrom($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEffectiveFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearEffectiveFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get effectiveUntil => $_getN(6);
  @$pb.TagNumber(7)
  set effectiveUntil($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEffectiveUntil() => $_has(6);
  @$pb.TagNumber(7)
  void clearEffectiveUntil() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEffectiveUntil() => $_ensure(6);
}

class CommissionOrgUnitResponse extends $pb.GeneratedMessage {
  factory CommissionOrgUnitResponse({
    $core.String? unitId,
    $core.String? code,
    $core.String? displayName,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  CommissionOrgUnitResponse._();

  factory CommissionOrgUnitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionOrgUnitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionOrgUnitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionOrgUnitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionOrgUnitResponse copyWith(
          void Function(CommissionOrgUnitResponse) updates) =>
      super.copyWith((message) => updates(message as CommissionOrgUnitResponse))
          as CommissionOrgUnitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionOrgUnitResponse create() => CommissionOrgUnitResponse._();
  @$core.override
  CommissionOrgUnitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionOrgUnitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionOrgUnitResponse>(create);
  static CommissionOrgUnitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);
}

class DefineBedClassRequest extends $pb.GeneratedMessage {
  factory DefineBedClassRequest({
    $core.String? code,
    $core.String? displayName,
    $core.String? chargeCode,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (chargeCode != null) result.chargeCode = chargeCode;
    return result;
  }

  DefineBedClassRequest._();

  factory DefineBedClassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineBedClassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineBedClassRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'chargeCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineBedClassRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineBedClassRequest copyWith(
          void Function(DefineBedClassRequest) updates) =>
      super.copyWith((message) => updates(message as DefineBedClassRequest))
          as DefineBedClassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineBedClassRequest create() => DefineBedClassRequest._();
  @$core.override
  DefineBedClassRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineBedClassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineBedClassRequest>(create);
  static DefineBedClassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get chargeCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set chargeCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChargeCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearChargeCode() => $_clearField(3);
}

class DefineBedClassResponse extends $pb.GeneratedMessage {
  factory DefineBedClassResponse({
    BedClass? class_1,
  }) {
    final result = create();
    if (class_1 != null) result.class_1 = class_1;
    return result;
  }

  DefineBedClassResponse._();

  factory DefineBedClassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineBedClassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineBedClassResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<BedClass>(1, _omitFieldNames ? '' : 'class',
        subBuilder: BedClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineBedClassResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineBedClassResponse copyWith(
          void Function(DefineBedClassResponse) updates) =>
      super.copyWith((message) => updates(message as DefineBedClassResponse))
          as DefineBedClassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineBedClassResponse create() => DefineBedClassResponse._();
  @$core.override
  DefineBedClassResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineBedClassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineBedClassResponse>(create);
  static DefineBedClassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BedClass get class_1 => $_getN(0);
  @$pb.TagNumber(1)
  set class_1(BedClass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasClass_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearClass_1() => $_clearField(1);
  @$pb.TagNumber(1)
  BedClass ensureClass_1() => $_ensure(0);
}

class ListBedClassesRequest extends $pb.GeneratedMessage {
  factory ListBedClassesRequest() => create();

  ListBedClassesRequest._();

  factory ListBedClassesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBedClassesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBedClassesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBedClassesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBedClassesRequest copyWith(
          void Function(ListBedClassesRequest) updates) =>
      super.copyWith((message) => updates(message as ListBedClassesRequest))
          as ListBedClassesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBedClassesRequest create() => ListBedClassesRequest._();
  @$core.override
  ListBedClassesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBedClassesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBedClassesRequest>(create);
  static ListBedClassesRequest? _defaultInstance;
}

class ListBedClassesResponse extends $pb.GeneratedMessage {
  factory ListBedClassesResponse({
    $core.Iterable<BedClass>? classes,
  }) {
    final result = create();
    if (classes != null) result.classes.addAll(classes);
    return result;
  }

  ListBedClassesResponse._();

  factory ListBedClassesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBedClassesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBedClassesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..pPM<BedClass>(1, _omitFieldNames ? '' : 'classes',
        subBuilder: BedClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBedClassesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBedClassesResponse copyWith(
          void Function(ListBedClassesResponse) updates) =>
      super.copyWith((message) => updates(message as ListBedClassesResponse))
          as ListBedClassesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBedClassesResponse create() => ListBedClassesResponse._();
  @$core.override
  ListBedClassesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBedClassesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBedClassesResponse>(create);
  static ListBedClassesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BedClass> get classes => $_getList(0);
}

class CommissionRoomRequest extends $pb.GeneratedMessage {
  factory CommissionRoomRequest({
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? code,
    $core.String? displayName,
    $core.String? classCode,
    GenderPolicy? genderPolicy,
    IsolationCapability? isolation,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (classCode != null) result.classCode = classCode;
    if (genderPolicy != null) result.genderPolicy = genderPolicy;
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  CommissionRoomRequest._();

  factory CommissionRoomRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionRoomRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionRoomRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'displayName')
    ..aOS(5, _omitFieldNames ? '' : 'classCode')
    ..aE<GenderPolicy>(6, _omitFieldNames ? '' : 'genderPolicy',
        enumValues: GenderPolicy.values)
    ..aE<IsolationCapability>(7, _omitFieldNames ? '' : 'isolation',
        enumValues: IsolationCapability.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionRoomRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionRoomRequest copyWith(
          void Function(CommissionRoomRequest) updates) =>
      super.copyWith((message) => updates(message as CommissionRoomRequest))
          as CommissionRoomRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionRoomRequest create() => CommissionRoomRequest._();
  @$core.override
  CommissionRoomRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionRoomRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionRoomRequest>(create);
  static CommissionRoomRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get displayName => $_getSZ(3);
  @$pb.TagNumber(4)
  set displayName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplayName() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplayName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get classCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set classCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClassCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearClassCode() => $_clearField(5);

  @$pb.TagNumber(6)
  GenderPolicy get genderPolicy => $_getN(5);
  @$pb.TagNumber(6)
  set genderPolicy(GenderPolicy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasGenderPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearGenderPolicy() => $_clearField(6);

  @$pb.TagNumber(7)
  IsolationCapability get isolation => $_getN(6);
  @$pb.TagNumber(7)
  set isolation(IsolationCapability value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIsolation() => $_has(6);
  @$pb.TagNumber(7)
  void clearIsolation() => $_clearField(7);
}

class CommissionRoomResponse extends $pb.GeneratedMessage {
  factory CommissionRoomResponse({
    Room? room,
  }) {
    final result = create();
    if (room != null) result.room = room;
    return result;
  }

  CommissionRoomResponse._();

  factory CommissionRoomResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionRoomResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionRoomResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Room>(1, _omitFieldNames ? '' : 'room', subBuilder: Room.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionRoomResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionRoomResponse copyWith(
          void Function(CommissionRoomResponse) updates) =>
      super.copyWith((message) => updates(message as CommissionRoomResponse))
          as CommissionRoomResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionRoomResponse create() => CommissionRoomResponse._();
  @$core.override
  CommissionRoomResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionRoomResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionRoomResponse>(create);
  static CommissionRoomResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Room get room => $_getN(0);
  @$pb.TagNumber(1)
  set room(Room value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoom() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoom() => $_clearField(1);
  @$pb.TagNumber(1)
  Room ensureRoom() => $_ensure(0);
}

class CommissionBedRequest extends $pb.GeneratedMessage {
  factory CommissionBedRequest({
    $core.String? roomId,
    $core.String? code,
    $core.String? displayName,
  }) {
    final result = create();
    if (roomId != null) result.roomId = roomId;
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    return result;
  }

  CommissionBedRequest._();

  factory CommissionBedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionBedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionBedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'roomId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'displayName')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionBedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionBedRequest copyWith(void Function(CommissionBedRequest) updates) =>
      super.copyWith((message) => updates(message as CommissionBedRequest))
          as CommissionBedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionBedRequest create() => CommissionBedRequest._();
  @$core.override
  CommissionBedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionBedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionBedRequest>(create);
  static CommissionBedRequest? _defaultInstance;

  /// The facility is taken from the room rather than sent, so a bed cannot be
  /// put in a facility its own room is not in.
  @$pb.TagNumber(1)
  $core.String get roomId => $_getSZ(0);
  @$pb.TagNumber(1)
  set roomId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRoomId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoomId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get displayName => $_getSZ(2);
  @$pb.TagNumber(3)
  set displayName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplayName() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplayName() => $_clearField(3);
}

class CommissionBedResponse extends $pb.GeneratedMessage {
  factory CommissionBedResponse({
    Bed? bed,
  }) {
    final result = create();
    if (bed != null) result.bed = bed;
    return result;
  }

  CommissionBedResponse._();

  factory CommissionBedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CommissionBedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommissionBedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Bed>(1, _omitFieldNames ? '' : 'bed', subBuilder: Bed.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionBedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommissionBedResponse copyWith(
          void Function(CommissionBedResponse) updates) =>
      super.copyWith((message) => updates(message as CommissionBedResponse))
          as CommissionBedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommissionBedResponse create() => CommissionBedResponse._();
  @$core.override
  CommissionBedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CommissionBedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommissionBedResponse>(create);
  static CommissionBedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bed get bed => $_getN(0);
  @$pb.TagNumber(1)
  set bed(Bed value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBed() => $_has(0);
  @$pb.TagNumber(1)
  void clearBed() => $_clearField(1);
  @$pb.TagNumber(1)
  Bed ensureBed() => $_ensure(0);
}

class SetBedAvailabilityRequest extends $pb.GeneratedMessage {
  factory SetBedAvailabilityRequest({
    $core.String? bedId,
    BedAvailability? availability,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    if (availability != null) result.availability = availability;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  SetBedAvailabilityRequest._();

  factory SetBedAvailabilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetBedAvailabilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBedAvailabilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..aE<BedAvailability>(2, _omitFieldNames ? '' : 'availability',
        enumValues: BedAvailability.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBedAvailabilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBedAvailabilityRequest copyWith(
          void Function(SetBedAvailabilityRequest) updates) =>
      super.copyWith((message) => updates(message as SetBedAvailabilityRequest))
          as SetBedAvailabilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBedAvailabilityRequest create() => SetBedAvailabilityRequest._();
  @$core.override
  SetBedAvailabilityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetBedAvailabilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBedAvailabilityRequest>(create);
  static SetBedAvailabilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);

  @$pb.TagNumber(2)
  BedAvailability get availability => $_getN(1);
  @$pb.TagNumber(2)
  set availability(BedAvailability value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAvailability() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailability() => $_clearField(2);

  /// Required when blocking or taking out of service, which are decisions
  /// somebody has to be able to review.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class SetBedAvailabilityResponse extends $pb.GeneratedMessage {
  factory SetBedAvailabilityResponse({
    Bed? bed,
  }) {
    final result = create();
    if (bed != null) result.bed = bed;
    return result;
  }

  SetBedAvailabilityResponse._();

  factory SetBedAvailabilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetBedAvailabilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBedAvailabilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Bed>(1, _omitFieldNames ? '' : 'bed', subBuilder: Bed.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBedAvailabilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBedAvailabilityResponse copyWith(
          void Function(SetBedAvailabilityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetBedAvailabilityResponse))
          as SetBedAvailabilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBedAvailabilityResponse create() => SetBedAvailabilityResponse._();
  @$core.override
  SetBedAvailabilityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetBedAvailabilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBedAvailabilityResponse>(create);
  static SetBedAvailabilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bed get bed => $_getN(0);
  @$pb.TagNumber(1)
  set bed(Bed value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBed() => $_has(0);
  @$pb.TagNumber(1)
  void clearBed() => $_clearField(1);
  @$pb.TagNumber(1)
  Bed ensureBed() => $_ensure(0);
}

class RetireBedRequest extends $pb.GeneratedMessage {
  factory RetireBedRequest({
    $core.String? bedId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (bedId != null) result.bedId = bedId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RetireBedRequest._();

  factory RetireBedRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireBedRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireBedRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bedId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireBedRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireBedRequest copyWith(void Function(RetireBedRequest) updates) =>
      super.copyWith((message) => updates(message as RetireBedRequest))
          as RetireBedRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireBedRequest create() => RetireBedRequest._();
  @$core.override
  RetireBedRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireBedRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireBedRequest>(create);
  static RetireBedRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

class RetireBedResponse extends $pb.GeneratedMessage {
  factory RetireBedResponse({
    Bed? bed,
  }) {
    final result = create();
    if (bed != null) result.bed = bed;
    return result;
  }

  RetireBedResponse._();

  factory RetireBedResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireBedResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireBedResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Bed>(1, _omitFieldNames ? '' : 'bed', subBuilder: Bed.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireBedResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireBedResponse copyWith(void Function(RetireBedResponse) updates) =>
      super.copyWith((message) => updates(message as RetireBedResponse))
          as RetireBedResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireBedResponse create() => RetireBedResponse._();
  @$core.override
  RetireBedResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireBedResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireBedResponse>(create);
  static RetireBedResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bed get bed => $_getN(0);
  @$pb.TagNumber(1)
  set bed(Bed value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBed() => $_has(0);
  @$pb.TagNumber(1)
  void clearBed() => $_clearField(1);
  @$pb.TagNumber(1)
  Bed ensureBed() => $_ensure(0);
}

class BedBoardRequest extends $pb.GeneratedMessage {
  factory BedBoardRequest({
    $core.String? facilityId,
    $core.String? unitId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  BedBoardRequest._();

  factory BedBoardRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedBoardRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedBoardRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedBoardRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedBoardRequest copyWith(void Function(BedBoardRequest) updates) =>
      super.copyWith((message) => updates(message as BedBoardRequest))
          as BedBoardRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedBoardRequest create() => BedBoardRequest._();
  @$core.override
  BedBoardRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedBoardRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BedBoardRequest>(create);
  static BedBoardRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  /// Empty means every ward in the facility.
  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class BedBoardResponse extends $pb.GeneratedMessage {
  factory BedBoardResponse({
    $core.Iterable<BedPlace>? places,
  }) {
    final result = create();
    if (places != null) result.places.addAll(places);
    return result;
  }

  BedBoardResponse._();

  factory BedBoardResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BedBoardResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BedBoardResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..pPM<BedPlace>(1, _omitFieldNames ? '' : 'places',
        subBuilder: BedPlace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedBoardResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BedBoardResponse copyWith(void Function(BedBoardResponse) updates) =>
      super.copyWith((message) => updates(message as BedBoardResponse))
          as BedBoardResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BedBoardResponse create() => BedBoardResponse._();
  @$core.override
  BedBoardResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BedBoardResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BedBoardResponse>(create);
  static BedBoardResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BedPlace> get places => $_getList(0);
}

class CreateTenantRequest extends $pb.GeneratedMessage {
  factory CreateTenantRequest({
    $core.String? displayName,
    $core.String? legalJurisdiction,
    $core.String? defaultLocale,
    $core.String? timeZone,
  }) {
    final result = create();
    if (displayName != null) result.displayName = displayName;
    if (legalJurisdiction != null) result.legalJurisdiction = legalJurisdiction;
    if (defaultLocale != null) result.defaultLocale = defaultLocale;
    if (timeZone != null) result.timeZone = timeZone;
    return result;
  }

  CreateTenantRequest._();

  factory CreateTenantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTenantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTenantRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'displayName')
    ..aOS(2, _omitFieldNames ? '' : 'legalJurisdiction')
    ..aOS(3, _omitFieldNames ? '' : 'defaultLocale')
    ..aOS(4, _omitFieldNames ? '' : 'timeZone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTenantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTenantRequest copyWith(void Function(CreateTenantRequest) updates) =>
      super.copyWith((message) => updates(message as CreateTenantRequest))
          as CreateTenantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTenantRequest create() => CreateTenantRequest._();
  @$core.override
  CreateTenantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTenantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTenantRequest>(create);
  static CreateTenantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get displayName => $_getSZ(0);
  @$pb.TagNumber(1)
  set displayName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisplayName() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisplayName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get legalJurisdiction => $_getSZ(1);
  @$pb.TagNumber(2)
  set legalJurisdiction($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLegalJurisdiction() => $_has(1);
  @$pb.TagNumber(2)
  void clearLegalJurisdiction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get defaultLocale => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultLocale($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDefaultLocale() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultLocale() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get timeZone => $_getSZ(3);
  @$pb.TagNumber(4)
  set timeZone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeZone() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeZone() => $_clearField(4);
}

class CreateTenantResponse extends $pb.GeneratedMessage {
  factory CreateTenantResponse({
    Tenant? tenant,
  }) {
    final result = create();
    if (tenant != null) result.tenant = tenant;
    return result;
  }

  CreateTenantResponse._();

  factory CreateTenantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTenantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTenantResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Tenant>(1, _omitFieldNames ? '' : 'tenant', subBuilder: Tenant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTenantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTenantResponse copyWith(void Function(CreateTenantResponse) updates) =>
      super.copyWith((message) => updates(message as CreateTenantResponse))
          as CreateTenantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTenantResponse create() => CreateTenantResponse._();
  @$core.override
  CreateTenantResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTenantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTenantResponse>(create);
  static CreateTenantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tenant get tenant => $_getN(0);
  @$pb.TagNumber(1)
  set tenant(Tenant value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTenant() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenant() => $_clearField(1);
  @$pb.TagNumber(1)
  Tenant ensureTenant() => $_ensure(0);
}

class GetTenantRequest extends $pb.GeneratedMessage {
  factory GetTenantRequest({
    $core.String? tenantId,
  }) {
    final result = create();
    if (tenantId != null) result.tenantId = tenantId;
    return result;
  }

  GetTenantRequest._();

  factory GetTenantRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTenantRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTenantRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tenantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantRequest copyWith(void Function(GetTenantRequest) updates) =>
      super.copyWith((message) => updates(message as GetTenantRequest))
          as GetTenantRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTenantRequest create() => GetTenantRequest._();
  @$core.override
  GetTenantRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTenantRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTenantRequest>(create);
  static GetTenantRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tenantId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tenantId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTenantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenantId() => $_clearField(1);
}

class GetTenantResponse extends $pb.GeneratedMessage {
  factory GetTenantResponse({
    Tenant? tenant,
  }) {
    final result = create();
    if (tenant != null) result.tenant = tenant;
    return result;
  }

  GetTenantResponse._();

  factory GetTenantResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTenantResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTenantResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Tenant>(1, _omitFieldNames ? '' : 'tenant', subBuilder: Tenant.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTenantResponse copyWith(void Function(GetTenantResponse) updates) =>
      super.copyWith((message) => updates(message as GetTenantResponse))
          as GetTenantResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTenantResponse create() => GetTenantResponse._();
  @$core.override
  GetTenantResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTenantResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTenantResponse>(create);
  static GetTenantResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Tenant get tenant => $_getN(0);
  @$pb.TagNumber(1)
  set tenant(Tenant value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTenant() => $_has(0);
  @$pb.TagNumber(1)
  void clearTenant() => $_clearField(1);
  @$pb.TagNumber(1)
  Tenant ensureTenant() => $_ensure(0);
}

class CreateFacilityRequest extends $pb.GeneratedMessage {
  factory CreateFacilityRequest({
    $core.String? code,
    $core.String? displayName,
    FacilityType? type,
    $core.String? timeZone,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (displayName != null) result.displayName = displayName;
    if (type != null) result.type = type;
    if (timeZone != null) result.timeZone = timeZone;
    return result;
  }

  CreateFacilityRequest._();

  factory CreateFacilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFacilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFacilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aE<FacilityType>(3, _omitFieldNames ? '' : 'type',
        enumValues: FacilityType.values)
    ..aOS(4, _omitFieldNames ? '' : 'timeZone')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFacilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFacilityRequest copyWith(
          void Function(CreateFacilityRequest) updates) =>
      super.copyWith((message) => updates(message as CreateFacilityRequest))
          as CreateFacilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFacilityRequest create() => CreateFacilityRequest._();
  @$core.override
  CreateFacilityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFacilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFacilityRequest>(create);
  static CreateFacilityRequest? _defaultInstance;

  /// Note: tenant scope comes from the authenticated transport metadata, never
  /// from the request body (SRS-IAM-013, Domain/Data spec §6 "Metadata").
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  FacilityType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(FacilityType value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get timeZone => $_getSZ(3);
  @$pb.TagNumber(4)
  set timeZone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTimeZone() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimeZone() => $_clearField(4);
}

class CreateFacilityResponse extends $pb.GeneratedMessage {
  factory CreateFacilityResponse({
    Facility? facility,
  }) {
    final result = create();
    if (facility != null) result.facility = facility;
    return result;
  }

  CreateFacilityResponse._();

  factory CreateFacilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFacilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFacilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Facility>(1, _omitFieldNames ? '' : 'facility',
        subBuilder: Facility.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFacilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFacilityResponse copyWith(
          void Function(CreateFacilityResponse) updates) =>
      super.copyWith((message) => updates(message as CreateFacilityResponse))
          as CreateFacilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFacilityResponse create() => CreateFacilityResponse._();
  @$core.override
  CreateFacilityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFacilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFacilityResponse>(create);
  static CreateFacilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Facility get facility => $_getN(0);
  @$pb.TagNumber(1)
  set facility(Facility value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFacility() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacility() => $_clearField(1);
  @$pb.TagNumber(1)
  Facility ensureFacility() => $_ensure(0);
}

class GetFacilityRequest extends $pb.GeneratedMessage {
  factory GetFacilityRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetFacilityRequest._();

  factory GetFacilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFacilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFacilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFacilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFacilityRequest copyWith(void Function(GetFacilityRequest) updates) =>
      super.copyWith((message) => updates(message as GetFacilityRequest))
          as GetFacilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFacilityRequest create() => GetFacilityRequest._();
  @$core.override
  GetFacilityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFacilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFacilityRequest>(create);
  static GetFacilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetFacilityResponse extends $pb.GeneratedMessage {
  factory GetFacilityResponse({
    Facility? facility,
  }) {
    final result = create();
    if (facility != null) result.facility = facility;
    return result;
  }

  GetFacilityResponse._();

  factory GetFacilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFacilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFacilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<Facility>(1, _omitFieldNames ? '' : 'facility',
        subBuilder: Facility.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFacilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFacilityResponse copyWith(void Function(GetFacilityResponse) updates) =>
      super.copyWith((message) => updates(message as GetFacilityResponse))
          as GetFacilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFacilityResponse create() => GetFacilityResponse._();
  @$core.override
  GetFacilityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFacilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFacilityResponse>(create);
  static GetFacilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Facility get facility => $_getN(0);
  @$pb.TagNumber(1)
  set facility(Facility value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFacility() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacility() => $_clearField(1);
  @$pb.TagNumber(1)
  Facility ensureFacility() => $_ensure(0);
}

class ListFacilitiesRequest extends $pb.GeneratedMessage {
  factory ListFacilitiesRequest({
    $1.PageRequest? page,
    FacilityStatus? status,
  }) {
    final result = create();
    if (page != null) result.page = page;
    if (status != null) result.status = status;
    return result;
  }

  ListFacilitiesRequest._();

  factory ListFacilitiesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFacilitiesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFacilitiesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..aOM<$1.PageRequest>(1, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageRequest.create)
    ..aE<FacilityStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: FacilityStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFacilitiesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFacilitiesRequest copyWith(
          void Function(ListFacilitiesRequest) updates) =>
      super.copyWith((message) => updates(message as ListFacilitiesRequest))
          as ListFacilitiesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFacilitiesRequest create() => ListFacilitiesRequest._();
  @$core.override
  ListFacilitiesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFacilitiesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFacilitiesRequest>(create);
  static ListFacilitiesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.PageRequest get page => $_getN(0);
  @$pb.TagNumber(1)
  set page($1.PageRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPage() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.PageRequest ensurePage() => $_ensure(0);

  /// Optional status filter; unspecified returns active and inactive.
  @$pb.TagNumber(2)
  FacilityStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(FacilityStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

class ListFacilitiesResponse extends $pb.GeneratedMessage {
  factory ListFacilitiesResponse({
    $core.Iterable<Facility>? facilities,
    $1.PageResponse? page,
  }) {
    final result = create();
    if (facilities != null) result.facilities.addAll(facilities);
    if (page != null) result.page = page;
    return result;
  }

  ListFacilitiesResponse._();

  factory ListFacilitiesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFacilitiesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFacilitiesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.organization.v1'),
      createEmptyInstance: create)
    ..pPM<Facility>(1, _omitFieldNames ? '' : 'facilities',
        subBuilder: Facility.create)
    ..aOM<$1.PageResponse>(2, _omitFieldNames ? '' : 'page',
        subBuilder: $1.PageResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFacilitiesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFacilitiesResponse copyWith(
          void Function(ListFacilitiesResponse) updates) =>
      super.copyWith((message) => updates(message as ListFacilitiesResponse))
          as ListFacilitiesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFacilitiesResponse create() => ListFacilitiesResponse._();
  @$core.override
  ListFacilitiesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFacilitiesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFacilitiesResponse>(create);
  static ListFacilitiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Facility> get facilities => $_getList(0);

  @$pb.TagNumber(2)
  $1.PageResponse get page => $_getN(1);
  @$pb.TagNumber(2)
  set page($1.PageResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPage() => $_has(1);
  @$pb.TagNumber(2)
  void clearPage() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PageResponse ensurePage() => $_ensure(1);
}

class OrganizationServiceApi {
  final $pb.RpcClient _client;

  OrganizationServiceApi(this._client);

  /// SRS-PLT-001. Platform-operator scope; emits organization.tenant_provisioned.
  $async.Future<CreateTenantResponse> createTenant(
          $pb.ClientContext? ctx, CreateTenantRequest request) =>
      _client.invoke<CreateTenantResponse>(ctx, 'OrganizationService',
          'CreateTenant', request, CreateTenantResponse());
  $async.Future<GetTenantResponse> getTenant(
          $pb.ClientContext? ctx, GetTenantRequest request) =>
      _client.invoke<GetTenantResponse>(ctx, 'OrganizationService', 'GetTenant',
          request, GetTenantResponse());

  /// SRS-PLT-004. Tenant-admin scope; emits organization.facility_created.
  $async.Future<CreateFacilityResponse> createFacility(
          $pb.ClientContext? ctx, CreateFacilityRequest request) =>
      _client.invoke<CreateFacilityResponse>(ctx, 'OrganizationService',
          'CreateFacility', request, CreateFacilityResponse());
  $async.Future<GetFacilityResponse> getFacility(
          $pb.ClientContext? ctx, GetFacilityRequest request) =>
      _client.invoke<GetFacilityResponse>(ctx, 'OrganizationService',
          'GetFacility', request, GetFacilityResponse());
  $async.Future<ListFacilitiesResponse> listFacilities(
          $pb.ClientContext? ctx, ListFacilitiesRequest request) =>
      _client.invoke<ListFacilitiesResponse>(ctx, 'OrganizationService',
          'ListFacilities', request, ListFacilitiesResponse());

  /// SRS-PLT-006. Commissioning the estate is a tenant-admin action; moving a
  /// bed in and out of use is ward work and takes a different permission.
  $async.Future<CommissionOrgUnitResponse> commissionOrgUnit(
          $pb.ClientContext? ctx, CommissionOrgUnitRequest request) =>
      _client.invoke<CommissionOrgUnitResponse>(ctx, 'OrganizationService',
          'CommissionOrgUnit', request, CommissionOrgUnitResponse());
  $async.Future<DefineBedClassResponse> defineBedClass(
          $pb.ClientContext? ctx, DefineBedClassRequest request) =>
      _client.invoke<DefineBedClassResponse>(ctx, 'OrganizationService',
          'DefineBedClass', request, DefineBedClassResponse());
  $async.Future<ListBedClassesResponse> listBedClasses(
          $pb.ClientContext? ctx, ListBedClassesRequest request) =>
      _client.invoke<ListBedClassesResponse>(ctx, 'OrganizationService',
          'ListBedClasses', request, ListBedClassesResponse());
  $async.Future<CommissionRoomResponse> commissionRoom(
          $pb.ClientContext? ctx, CommissionRoomRequest request) =>
      _client.invoke<CommissionRoomResponse>(ctx, 'OrganizationService',
          'CommissionRoom', request, CommissionRoomResponse());
  $async.Future<CommissionBedResponse> commissionBed(
          $pb.ClientContext? ctx, CommissionBedRequest request) =>
      _client.invoke<CommissionBedResponse>(ctx, 'OrganizationService',
          'CommissionBed', request, CommissionBedResponse());
  $async.Future<SetBedAvailabilityResponse> setBedAvailability(
          $pb.ClientContext? ctx, SetBedAvailabilityRequest request) =>
      _client.invoke<SetBedAvailabilityResponse>(ctx, 'OrganizationService',
          'SetBedAvailability', request, SetBedAvailabilityResponse());
  $async.Future<RetireBedResponse> retireBed(
          $pb.ClientContext? ctx, RetireBedRequest request) =>
      _client.invoke<RetireBedResponse>(ctx, 'OrganizationService', 'RetireBed',
          request, RetireBedResponse());
  $async.Future<BedBoardResponse> bedBoard(
          $pb.ClientContext? ctx, BedBoardRequest request) =>
      _client.invoke<BedBoardResponse>(
          ctx, 'OrganizationService', 'BedBoard', request, BedBoardResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
