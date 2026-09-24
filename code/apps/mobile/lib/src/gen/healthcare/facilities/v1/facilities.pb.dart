// This is a generated file - do not edit.
//
// Generated from healthcare/facilities/v1/facilities.proto.

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

import 'facilities.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'facilities.pbenum.dart';

/// One piece of facilities plant (SRS-FAC-001).
class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? assetId,
    $core.String? tag,
    $core.String? name,
    System? system,
    Criticality? criticality,
    $core.String? parentId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? locationNote,
    AssetStatus? status,
    $core.String? statusReason,
    $0.Timestamp? statusAt,
    $core.String? manufacturer,
    $core.String? model,
    $core.String? serialNumber,
    $0.Timestamp? commissionedAt,
    $core.int? runtimeHours,
    $0.Timestamp? runtimeAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (tag != null) result.tag = tag;
    if (name != null) result.name = name;
    if (system != null) result.system = system;
    if (criticality != null) result.criticality = criticality;
    if (parentId != null) result.parentId = parentId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (status != null) result.status = status;
    if (statusReason != null) result.statusReason = statusReason;
    if (statusAt != null) result.statusAt = statusAt;
    if (manufacturer != null) result.manufacturer = manufacturer;
    if (model != null) result.model = model;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (commissionedAt != null) result.commissionedAt = commissionedAt;
    if (runtimeHours != null) result.runtimeHours = runtimeHours;
    if (runtimeAt != null) result.runtimeAt = runtimeAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Asset._();

  factory Asset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Asset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Asset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'tag')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<System>(4, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Criticality>(5, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aOS(6, _omitFieldNames ? '' : 'parentId')
    ..aOS(7, _omitFieldNames ? '' : 'facilityId')
    ..aOS(8, _omitFieldNames ? '' : 'locationId')
    ..aOS(9, _omitFieldNames ? '' : 'locationNote')
    ..aE<AssetStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'statusReason')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'statusAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(14, _omitFieldNames ? '' : 'model')
    ..aOS(15, _omitFieldNames ? '' : 'serialNumber')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'commissionedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(17, _omitFieldNames ? '' : 'runtimeHours')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'runtimeAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(21, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Asset copyWith(void Function(Asset) updates) =>
      super.copyWith((message) => updates(message as Asset)) as Asset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Asset create() => Asset._();
  @$core.override
  Asset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Asset getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Asset>(create);
  static Asset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  /// What is stencilled on the machine.
  @$pb.TagNumber(2)
  $core.String get tag => $_getSZ(1);
  @$pb.TagNumber(2)
  set tag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearTag() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  System get system => $_getN(3);
  @$pb.TagNumber(4)
  set system(System value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystem() => $_clearField(4);

  @$pb.TagNumber(5)
  Criticality get criticality => $_getN(4);
  @$pb.TagNumber(5)
  set criticality(Criticality value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCriticality() => $_has(4);
  @$pb.TagNumber(5)
  void clearCriticality() => $_clearField(5);

  /// The asset this one is part of. The hierarchy is this field and nothing
  /// else: a second tree would disagree with it.
  @$pb.TagNumber(6)
  $core.String get parentId => $_getSZ(5);
  @$pb.TagNumber(6)
  set parentId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasParentId() => $_has(5);
  @$pb.TagNumber(6)
  void clearParentId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get facilityId => $_getSZ(6);
  @$pb.TagNumber(7)
  set facilityId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFacilityId() => $_has(6);
  @$pb.TagNumber(7)
  void clearFacilityId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get locationId => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationId() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationId() => $_clearField(8);

  /// Where it actually is when the org unit is not precise enough.
  @$pb.TagNumber(9)
  $core.String get locationNote => $_getSZ(8);
  @$pb.TagNumber(9)
  set locationNote($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLocationNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearLocationNote() => $_clearField(9);

  @$pb.TagNumber(10)
  AssetStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(AssetStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get statusReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set statusReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasStatusReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatusReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get statusAt => $_getN(11);
  @$pb.TagNumber(12)
  set statusAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasStatusAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStatusAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureStatusAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get manufacturer => $_getSZ(12);
  @$pb.TagNumber(13)
  set manufacturer($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasManufacturer() => $_has(12);
  @$pb.TagNumber(13)
  void clearManufacturer() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get model => $_getSZ(13);
  @$pb.TagNumber(14)
  set model($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasModel() => $_has(13);
  @$pb.TagNumber(14)
  void clearModel() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get serialNumber => $_getSZ(14);
  @$pb.TagNumber(15)
  set serialNumber($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSerialNumber() => $_has(14);
  @$pb.TagNumber(15)
  void clearSerialNumber() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get commissionedAt => $_getN(15);
  @$pb.TagNumber(16)
  set commissionedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasCommissionedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearCommissionedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureCommissionedAt() => $_ensure(15);

  /// Derived from the readings rather than typed, so it cannot disagree with
  /// them.
  @$pb.TagNumber(17)
  $core.int get runtimeHours => $_getIZ(16);
  @$pb.TagNumber(17)
  set runtimeHours($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRuntimeHours() => $_has(16);
  @$pb.TagNumber(17)
  void clearRuntimeHours() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get runtimeAt => $_getN(17);
  @$pb.TagNumber(18)
  set runtimeAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasRuntimeAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearRuntimeAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureRuntimeAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get createdAt => $_getN(18);
  @$pb.TagNumber(19)
  set createdAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasCreatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearCreatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureCreatedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get createdBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set createdBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $fixnum.Int64 get version => $_getI64(20);
  @$pb.TagNumber(21)
  set version($fixnum.Int64 value) => $_setInt64(20, value);
  @$pb.TagNumber(21)
  $core.bool hasVersion() => $_has(20);
  @$pb.TagNumber(21)
  void clearVersion() => $_clearField(21);
}

class RegisterAssetRequest extends $pb.GeneratedMessage {
  factory RegisterAssetRequest({
    $core.String? tag,
    $core.String? name,
    System? system,
    Criticality? criticality,
    $core.String? parentId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? locationNote,
    $core.String? manufacturer,
    $core.String? model,
    $core.String? serialNumber,
    $0.Timestamp? commissionedAt,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    if (name != null) result.name = name;
    if (system != null) result.system = system;
    if (criticality != null) result.criticality = criticality;
    if (parentId != null) result.parentId = parentId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (manufacturer != null) result.manufacturer = manufacturer;
    if (model != null) result.model = model;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (commissionedAt != null) result.commissionedAt = commissionedAt;
    return result;
  }

  RegisterAssetRequest._();

  factory RegisterAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<System>(3, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Criticality>(4, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aOS(5, _omitFieldNames ? '' : 'parentId')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'locationId')
    ..aOS(8, _omitFieldNames ? '' : 'locationNote')
    ..aOS(9, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(10, _omitFieldNames ? '' : 'model')
    ..aOS(11, _omitFieldNames ? '' : 'serialNumber')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'commissionedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterAssetRequest copyWith(void Function(RegisterAssetRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterAssetRequest))
          as RegisterAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterAssetRequest create() => RegisterAssetRequest._();
  @$core.override
  RegisterAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterAssetRequest>(create);
  static RegisterAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  System get system => $_getN(2);
  @$pb.TagNumber(3)
  set system(System value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  Criticality get criticality => $_getN(3);
  @$pb.TagNumber(4)
  set criticality(Criticality value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCriticality() => $_has(3);
  @$pb.TagNumber(4)
  void clearCriticality() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get parentId => $_getSZ(4);
  @$pb.TagNumber(5)
  set parentId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasParentId() => $_has(4);
  @$pb.TagNumber(5)
  void clearParentId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get locationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set locationId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLocationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocationId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get locationNote => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationNote($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationNote() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationNote() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get manufacturer => $_getSZ(8);
  @$pb.TagNumber(9)
  set manufacturer($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasManufacturer() => $_has(8);
  @$pb.TagNumber(9)
  void clearManufacturer() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get model => $_getSZ(9);
  @$pb.TagNumber(10)
  set model($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasModel() => $_has(9);
  @$pb.TagNumber(10)
  void clearModel() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get serialNumber => $_getSZ(10);
  @$pb.TagNumber(11)
  set serialNumber($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSerialNumber() => $_has(10);
  @$pb.TagNumber(11)
  void clearSerialNumber() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get commissionedAt => $_getN(11);
  @$pb.TagNumber(12)
  set commissionedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCommissionedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCommissionedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCommissionedAt() => $_ensure(11);
}

class RegisterAssetResponse extends $pb.GeneratedMessage {
  factory RegisterAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  RegisterAssetResponse._();

  factory RegisterAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterAssetResponse copyWith(
          void Function(RegisterAssetResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterAssetResponse))
          as RegisterAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterAssetResponse create() => RegisterAssetResponse._();
  @$core.override
  RegisterAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterAssetResponse>(create);
  static RegisterAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class SetAssetStatusRequest extends $pb.GeneratedMessage {
  factory SetAssetStatusRequest({
    $core.String? assetId,
    AssetStatus? status,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (status != null) result.status = status;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  SetAssetStatusRequest._();

  factory SetAssetStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAssetStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAssetStatusRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aE<AssetStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAssetStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAssetStatusRequest copyWith(
          void Function(SetAssetStatusRequest) updates) =>
      super.copyWith((message) => updates(message as SetAssetStatusRequest))
          as SetAssetStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAssetStatusRequest create() => SetAssetStatusRequest._();
  @$core.override
  SetAssetStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAssetStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAssetStatusRequest>(create);
  static SetAssetStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  AssetStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(AssetStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// Required for anything other than in service. A machine marked down for no
  /// recorded reason is one nobody can chase.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class SetAssetStatusResponse extends $pb.GeneratedMessage {
  factory SetAssetStatusResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  SetAssetStatusResponse._();

  factory SetAssetStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAssetStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAssetStatusResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAssetStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAssetStatusResponse copyWith(
          void Function(SetAssetStatusResponse) updates) =>
      super.copyWith((message) => updates(message as SetAssetStatusResponse))
          as SetAssetStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAssetStatusResponse create() => SetAssetStatusResponse._();
  @$core.override
  SetAssetStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAssetStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAssetStatusResponse>(create);
  static SetAssetStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class GetAssetRequest extends $pb.GeneratedMessage {
  factory GetAssetRequest({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  GetAssetRequest._();

  factory GetAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetRequest copyWith(void Function(GetAssetRequest) updates) =>
      super.copyWith((message) => updates(message as GetAssetRequest))
          as GetAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetRequest create() => GetAssetRequest._();
  @$core.override
  GetAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetRequest>(create);
  static GetAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class GetAssetResponse extends $pb.GeneratedMessage {
  factory GetAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  GetAssetResponse._();

  factory GetAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetResponse copyWith(void Function(GetAssetResponse) updates) =>
      super.copyWith((message) => updates(message as GetAssetResponse))
          as GetAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetResponse create() => GetAssetResponse._();
  @$core.override
  GetAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetResponse>(create);
  static GetAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Asset get asset => $_getN(0);
  @$pb.TagNumber(1)
  set asset(Asset value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAsset() => $_has(0);
  @$pb.TagNumber(1)
  void clearAsset() => $_clearField(1);
  @$pb.TagNumber(1)
  Asset ensureAsset() => $_ensure(0);
}

class ListAssetsRequest extends $pb.GeneratedMessage {
  factory ListAssetsRequest({
    $core.String? facilityId,
    System? system,
    AssetStatus? status,
    $core.String? parentId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (status != null) result.status = status;
    if (parentId != null) result.parentId = parentId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAssetsRequest._();

  factory ListAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssetsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(2, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<AssetStatus>(3, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOS(4, _omitFieldNames ? '' : 'parentId')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsRequest copyWith(void Function(ListAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAssetsRequest))
          as ListAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest create() => ListAssetsRequest._();
  @$core.override
  ListAssetsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssetsRequest>(create);
  static ListAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  System get system => $_getN(1);
  @$pb.TagNumber(2)
  set system(System value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystem() => $_clearField(2);

  @$pb.TagNumber(3)
  AssetStatus get status => $_getN(2);
  @$pb.TagNumber(3)
  set status(AssetStatus value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get parentId => $_getSZ(3);
  @$pb.TagNumber(4)
  set parentId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasParentId() => $_has(3);
  @$pb.TagNumber(4)
  void clearParentId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListAssetsResponse extends $pb.GeneratedMessage {
  factory ListAssetsResponse({
    $core.Iterable<Asset>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  ListAssetsResponse._();

  factory ListAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssetsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssetsResponse copyWith(void Function(ListAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAssetsResponse))
          as ListAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse create() => ListAssetsResponse._();
  @$core.override
  ListAssetsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssetsResponse>(create);
  static ListAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);
}

class GetAssetTreeRequest extends $pb.GeneratedMessage {
  factory GetAssetTreeRequest({
    $core.String? rootId,
  }) {
    final result = create();
    if (rootId != null) result.rootId = rootId;
    return result;
  }

  GetAssetTreeRequest._();

  factory GetAssetTreeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetTreeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetTreeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rootId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetTreeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetTreeRequest copyWith(void Function(GetAssetTreeRequest) updates) =>
      super.copyWith((message) => updates(message as GetAssetTreeRequest))
          as GetAssetTreeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetTreeRequest create() => GetAssetTreeRequest._();
  @$core.override
  GetAssetTreeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetTreeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetTreeRequest>(create);
  static GetAssetTreeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rootId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rootId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRootId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRootId() => $_clearField(1);
}

class GetAssetTreeResponse extends $pb.GeneratedMessage {
  factory GetAssetTreeResponse({
    $core.Iterable<Asset>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  GetAssetTreeResponse._();

  factory GetAssetTreeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetTreeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetTreeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetTreeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetTreeResponse copyWith(void Function(GetAssetTreeResponse) updates) =>
      super.copyWith((message) => updates(message as GetAssetTreeResponse))
          as GetAssetTreeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetTreeResponse create() => GetAssetTreeResponse._();
  @$core.override
  GetAssetTreeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetTreeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetTreeResponse>(create);
  static GetAssetTreeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);
}

class ListDownAssetsRequest extends $pb.GeneratedMessage {
  factory ListDownAssetsRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListDownAssetsRequest._();

  factory ListDownAssetsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDownAssetsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDownAssetsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownAssetsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownAssetsRequest copyWith(
          void Function(ListDownAssetsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDownAssetsRequest))
          as ListDownAssetsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDownAssetsRequest create() => ListDownAssetsRequest._();
  @$core.override
  ListDownAssetsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDownAssetsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDownAssetsRequest>(create);
  static ListDownAssetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

/// Most critical first, then longest down. A list in tag order puts the oxygen
/// manifold below the car park barrier.
class ListDownAssetsResponse extends $pb.GeneratedMessage {
  factory ListDownAssetsResponse({
    $core.Iterable<Asset>? assets,
  }) {
    final result = create();
    if (assets != null) result.assets.addAll(assets);
    return result;
  }

  ListDownAssetsResponse._();

  factory ListDownAssetsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDownAssetsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDownAssetsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Asset>(1, _omitFieldNames ? '' : 'assets', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownAssetsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDownAssetsResponse copyWith(
          void Function(ListDownAssetsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDownAssetsResponse))
          as ListDownAssetsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDownAssetsResponse create() => ListDownAssetsResponse._();
  @$core.override
  ListDownAssetsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDownAssetsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDownAssetsResponse>(create);
  static ListDownAssetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Asset> get assets => $_getList(0);
}

/// A configured kind of maintenance work (SRS-FAC-010).
class WorkClass extends $pb.GeneratedMessage {
  factory WorkClass({
    $core.String? code,
    $core.String? name,
    $core.bool? requiresPermit,
    $core.bool? requiresLoto,
    $core.bool? active,
    $core.String? note,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (requiresPermit != null) result.requiresPermit = requiresPermit;
    if (requiresLoto != null) result.requiresLoto = requiresLoto;
    if (active != null) result.active = active;
    if (note != null) result.note = note;
    return result;
  }

  WorkClass._();

  factory WorkClass.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkClass.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkClass',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'requiresPermit')
    ..aOB(4, _omitFieldNames ? '' : 'requiresLoto')
    ..aOB(5, _omitFieldNames ? '' : 'active')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkClass clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkClass copyWith(void Function(WorkClass) updates) =>
      super.copyWith((message) => updates(message as WorkClass)) as WorkClass;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkClass create() => WorkClass._();
  @$core.override
  WorkClass createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WorkClass getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkClass>(create);
  static WorkClass? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// No work of this class starts without a permit to work.
  @$pb.TagNumber(3)
  $core.bool get requiresPermit => $_getBF(2);
  @$pb.TagNumber(3)
  set requiresPermit($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiresPermit() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiresPermit() => $_clearField(3);

  /// The energy source is isolated, locked and tagged, and the tag recorded.
  /// Separate from the permit because they are separate controls.
  @$pb.TagNumber(4)
  $core.bool get requiresLoto => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresLoto($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiresLoto() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresLoto() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get active => $_getBF(4);
  @$pb.TagNumber(5)
  set active($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearActive() => $_clearField(5);

  /// Required when either flag is set. A class marked unsafe without a reason
  /// is one the next person to review the list will quietly unmark.
  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);
}

class SetWorkClassRequest extends $pb.GeneratedMessage {
  factory SetWorkClassRequest({
    $core.String? code,
    $core.String? name,
    $core.bool? requiresPermit,
    $core.bool? requiresLoto,
    $core.bool? active,
    $core.String? note,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (requiresPermit != null) result.requiresPermit = requiresPermit;
    if (requiresLoto != null) result.requiresLoto = requiresLoto;
    if (active != null) result.active = active;
    if (note != null) result.note = note;
    return result;
  }

  SetWorkClassRequest._();

  factory SetWorkClassRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetWorkClassRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetWorkClassRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'requiresPermit')
    ..aOB(4, _omitFieldNames ? '' : 'requiresLoto')
    ..aOB(5, _omitFieldNames ? '' : 'active')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWorkClassRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWorkClassRequest copyWith(void Function(SetWorkClassRequest) updates) =>
      super.copyWith((message) => updates(message as SetWorkClassRequest))
          as SetWorkClassRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetWorkClassRequest create() => SetWorkClassRequest._();
  @$core.override
  SetWorkClassRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetWorkClassRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetWorkClassRequest>(create);
  static SetWorkClassRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get requiresPermit => $_getBF(2);
  @$pb.TagNumber(3)
  set requiresPermit($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequiresPermit() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequiresPermit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get requiresLoto => $_getBF(3);
  @$pb.TagNumber(4)
  set requiresLoto($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequiresLoto() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequiresLoto() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get active => $_getBF(4);
  @$pb.TagNumber(5)
  set active($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearActive() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);
}

class SetWorkClassResponse extends $pb.GeneratedMessage {
  factory SetWorkClassResponse({
    WorkClass? workClass,
  }) {
    final result = create();
    if (workClass != null) result.workClass = workClass;
    return result;
  }

  SetWorkClassResponse._();

  factory SetWorkClassResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetWorkClassResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetWorkClassResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkClass>(1, _omitFieldNames ? '' : 'workClass',
        subBuilder: WorkClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWorkClassResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetWorkClassResponse copyWith(void Function(SetWorkClassResponse) updates) =>
      super.copyWith((message) => updates(message as SetWorkClassResponse))
          as SetWorkClassResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetWorkClassResponse create() => SetWorkClassResponse._();
  @$core.override
  SetWorkClassResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetWorkClassResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetWorkClassResponse>(create);
  static SetWorkClassResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkClass get workClass => $_getN(0);
  @$pb.TagNumber(1)
  set workClass(WorkClass value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkClass() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkClass() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkClass ensureWorkClass() => $_ensure(0);
}

class ListWorkClassesRequest extends $pb.GeneratedMessage {
  factory ListWorkClassesRequest() => create();

  ListWorkClassesRequest._();

  factory ListWorkClassesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkClassesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkClassesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkClassesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkClassesRequest copyWith(
          void Function(ListWorkClassesRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorkClassesRequest))
          as ListWorkClassesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkClassesRequest create() => ListWorkClassesRequest._();
  @$core.override
  ListWorkClassesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorkClassesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkClassesRequest>(create);
  static ListWorkClassesRequest? _defaultInstance;
}

class ListWorkClassesResponse extends $pb.GeneratedMessage {
  factory ListWorkClassesResponse({
    $core.Iterable<WorkClass>? workClasses,
  }) {
    final result = create();
    if (workClasses != null) result.workClasses.addAll(workClasses);
    return result;
  }

  ListWorkClassesResponse._();

  factory ListWorkClassesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkClassesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkClassesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<WorkClass>(1, _omitFieldNames ? '' : 'workClasses',
        subBuilder: WorkClass.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkClassesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkClassesResponse copyWith(
          void Function(ListWorkClassesResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorkClassesResponse))
          as ListWorkClassesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkClassesResponse create() => ListWorkClassesResponse._();
  @$core.override
  ListWorkClassesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorkClassesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkClassesResponse>(create);
  static ListWorkClassesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkClass> get workClasses => $_getList(0);
}

/// One piece of facilities work (SRS-FAC-002).
class WorkOrder extends $pb.GeneratedMessage {
  factory WorkOrder({
    $core.String? workOrderId,
    $core.String? number,
    $core.String? facilityId,
    $core.String? assetId,
    System? system,
    $core.String? locationId,
    $core.String? locationNote,
    $core.String? fault,
    $core.String? impact,
    Priority? priority,
    $core.String? classCode,
    $core.bool? classRequiresPermit,
    $core.bool? classRequiresLoto,
    $core.String? ownerTeam,
    $core.String? ownerUserId,
    WorkState? state,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $0.Timestamp? respondBy,
    $0.Timestamp? resolveBy,
    $0.Timestamp? respondedAt,
    $0.Timestamp? startedAt,
    $0.Timestamp? resolvedAt,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? permitRef,
    $core.String? permitIssuedBy,
    $core.String? lotoRef,
    $core.String? lotoAppliedBy,
    $core.String? completionNote,
    $core.String? rootCause,
    $core.int? downtimeMinutes,
    $core.String? holdReason,
    $core.String? cancelReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (assetId != null) result.assetId = assetId;
    if (system != null) result.system = system;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (fault != null) result.fault = fault;
    if (impact != null) result.impact = impact;
    if (priority != null) result.priority = priority;
    if (classCode != null) result.classCode = classCode;
    if (classRequiresPermit != null)
      result.classRequiresPermit = classRequiresPermit;
    if (classRequiresLoto != null) result.classRequiresLoto = classRequiresLoto;
    if (ownerTeam != null) result.ownerTeam = ownerTeam;
    if (ownerUserId != null) result.ownerUserId = ownerUserId;
    if (state != null) result.state = state;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (respondBy != null) result.respondBy = respondBy;
    if (resolveBy != null) result.resolveBy = resolveBy;
    if (respondedAt != null) result.respondedAt = respondedAt;
    if (startedAt != null) result.startedAt = startedAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (permitRef != null) result.permitRef = permitRef;
    if (permitIssuedBy != null) result.permitIssuedBy = permitIssuedBy;
    if (lotoRef != null) result.lotoRef = lotoRef;
    if (lotoAppliedBy != null) result.lotoAppliedBy = lotoAppliedBy;
    if (completionNote != null) result.completionNote = completionNote;
    if (rootCause != null) result.rootCause = rootCause;
    if (downtimeMinutes != null) result.downtimeMinutes = downtimeMinutes;
    if (holdReason != null) result.holdReason = holdReason;
    if (cancelReason != null) result.cancelReason = cancelReason;
    if (version != null) result.version = version;
    return result;
  }

  WorkOrder._();

  factory WorkOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WorkOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WorkOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'assetId')
    ..aE<System>(5, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aOS(6, _omitFieldNames ? '' : 'locationId')
    ..aOS(7, _omitFieldNames ? '' : 'locationNote')
    ..aOS(8, _omitFieldNames ? '' : 'fault')
    ..aOS(9, _omitFieldNames ? '' : 'impact')
    ..aE<Priority>(10, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(11, _omitFieldNames ? '' : 'classCode')
    ..aOB(12, _omitFieldNames ? '' : 'classRequiresPermit')
    ..aOB(13, _omitFieldNames ? '' : 'classRequiresLoto')
    ..aOS(14, _omitFieldNames ? '' : 'ownerTeam')
    ..aOS(15, _omitFieldNames ? '' : 'ownerUserId')
    ..aE<WorkState>(16, _omitFieldNames ? '' : 'state',
        enumValues: WorkState.values)
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'raisedBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'respondBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'resolveBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'respondedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(24, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(25, _omitFieldNames ? '' : 'closedBy')
    ..aOS(26, _omitFieldNames ? '' : 'permitRef')
    ..aOS(27, _omitFieldNames ? '' : 'permitIssuedBy')
    ..aOS(28, _omitFieldNames ? '' : 'lotoRef')
    ..aOS(29, _omitFieldNames ? '' : 'lotoAppliedBy')
    ..aOS(30, _omitFieldNames ? '' : 'completionNote')
    ..aOS(31, _omitFieldNames ? '' : 'rootCause')
    ..aI(32, _omitFieldNames ? '' : 'downtimeMinutes')
    ..aOS(33, _omitFieldNames ? '' : 'holdReason')
    ..aOS(34, _omitFieldNames ? '' : 'cancelReason')
    ..aInt64(35, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WorkOrder copyWith(void Function(WorkOrder) updates) =>
      super.copyWith((message) => updates(message as WorkOrder)) as WorkOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WorkOrder create() => WorkOrder._();
  @$core.override
  WorkOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WorkOrder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WorkOrder>(create);
  static WorkOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  /// The human reference a ward quotes on the phone.
  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  /// The plant this is about, where there is one. A ceiling leaking into a
  /// ward is real work with no asset behind it.
  @$pb.TagNumber(4)
  $core.String get assetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  System get system => $_getN(4);
  @$pb.TagNumber(5)
  set system(System value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSystem() => $_has(4);
  @$pb.TagNumber(5)
  void clearSystem() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get locationNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set locationNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLocationNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocationNote() => $_clearField(7);

  /// What is wrong.
  @$pb.TagNumber(8)
  $core.String get fault => $_getSZ(7);
  @$pb.TagNumber(8)
  set fault($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFault() => $_has(7);
  @$pb.TagNumber(8)
  void clearFault() => $_clearField(8);

  /// What it is stopping. The field that decides priority honestly.
  @$pb.TagNumber(9)
  $core.String get impact => $_getSZ(8);
  @$pb.TagNumber(9)
  set impact($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasImpact() => $_has(8);
  @$pb.TagNumber(9)
  void clearImpact() => $_clearField(9);

  @$pb.TagNumber(10)
  Priority get priority => $_getN(9);
  @$pb.TagNumber(10)
  set priority(Priority value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasPriority() => $_has(9);
  @$pb.TagNumber(10)
  void clearPriority() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get classCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set classCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClassCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearClassCode() => $_clearField(11);

  /// Copied from the class and held to it by the database, so that "an unsafe
  /// class cannot close without its paperwork" is a rule about one row.
  @$pb.TagNumber(12)
  $core.bool get classRequiresPermit => $_getBF(11);
  @$pb.TagNumber(12)
  set classRequiresPermit($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasClassRequiresPermit() => $_has(11);
  @$pb.TagNumber(12)
  void clearClassRequiresPermit() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get classRequiresLoto => $_getBF(12);
  @$pb.TagNumber(13)
  set classRequiresLoto($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasClassRequiresLoto() => $_has(12);
  @$pb.TagNumber(13)
  void clearClassRequiresLoto() => $_clearField(13);

  /// Resolved when the order is raised, so a ticket always has an owner.
  @$pb.TagNumber(14)
  $core.String get ownerTeam => $_getSZ(13);
  @$pb.TagNumber(14)
  set ownerTeam($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOwnerTeam() => $_has(13);
  @$pb.TagNumber(14)
  void clearOwnerTeam() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get ownerUserId => $_getSZ(14);
  @$pb.TagNumber(15)
  set ownerUserId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasOwnerUserId() => $_has(14);
  @$pb.TagNumber(15)
  void clearOwnerUserId() => $_clearField(15);

  @$pb.TagNumber(16)
  WorkState get state => $_getN(15);
  @$pb.TagNumber(16)
  set state(WorkState value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasState() => $_has(15);
  @$pb.TagNumber(16)
  void clearState() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get raisedAt => $_getN(16);
  @$pb.TagNumber(17)
  set raisedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRaisedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearRaisedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureRaisedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get raisedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set raisedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRaisedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearRaisedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get respondBy => $_getN(18);
  @$pb.TagNumber(19)
  set respondBy($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasRespondBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearRespondBy() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureRespondBy() => $_ensure(18);

  @$pb.TagNumber(20)
  $0.Timestamp get resolveBy => $_getN(19);
  @$pb.TagNumber(20)
  set resolveBy($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasResolveBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearResolveBy() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureResolveBy() => $_ensure(19);

  @$pb.TagNumber(21)
  $0.Timestamp get respondedAt => $_getN(20);
  @$pb.TagNumber(21)
  set respondedAt($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasRespondedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearRespondedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureRespondedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $0.Timestamp get startedAt => $_getN(21);
  @$pb.TagNumber(22)
  set startedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasStartedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearStartedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureStartedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $0.Timestamp get resolvedAt => $_getN(22);
  @$pb.TagNumber(23)
  set resolvedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasResolvedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearResolvedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensureResolvedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $0.Timestamp get closedAt => $_getN(23);
  @$pb.TagNumber(24)
  set closedAt($0.Timestamp value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasClosedAt() => $_has(23);
  @$pb.TagNumber(24)
  void clearClosedAt() => $_clearField(24);
  @$pb.TagNumber(24)
  $0.Timestamp ensureClosedAt() => $_ensure(23);

  @$pb.TagNumber(25)
  $core.String get closedBy => $_getSZ(24);
  @$pb.TagNumber(25)
  set closedBy($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasClosedBy() => $_has(24);
  @$pb.TagNumber(25)
  void clearClosedBy() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get permitRef => $_getSZ(25);
  @$pb.TagNumber(26)
  set permitRef($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasPermitRef() => $_has(25);
  @$pb.TagNumber(26)
  void clearPermitRef() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get permitIssuedBy => $_getSZ(26);
  @$pb.TagNumber(27)
  set permitIssuedBy($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasPermitIssuedBy() => $_has(26);
  @$pb.TagNumber(27)
  void clearPermitIssuedBy() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get lotoRef => $_getSZ(27);
  @$pb.TagNumber(28)
  set lotoRef($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasLotoRef() => $_has(27);
  @$pb.TagNumber(28)
  void clearLotoRef() => $_clearField(28);

  @$pb.TagNumber(29)
  $core.String get lotoAppliedBy => $_getSZ(28);
  @$pb.TagNumber(29)
  set lotoAppliedBy($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasLotoAppliedBy() => $_has(28);
  @$pb.TagNumber(29)
  void clearLotoAppliedBy() => $_clearField(29);

  @$pb.TagNumber(30)
  $core.String get completionNote => $_getSZ(29);
  @$pb.TagNumber(30)
  set completionNote($core.String value) => $_setString(29, value);
  @$pb.TagNumber(30)
  $core.bool hasCompletionNote() => $_has(29);
  @$pb.TagNumber(30)
  void clearCompletionNote() => $_clearField(30);

  @$pb.TagNumber(31)
  $core.String get rootCause => $_getSZ(30);
  @$pb.TagNumber(31)
  set rootCause($core.String value) => $_setString(30, value);
  @$pb.TagNumber(31)
  $core.bool hasRootCause() => $_has(30);
  @$pb.TagNumber(31)
  void clearRootCause() => $_clearField(31);

  /// How long the asset was unavailable. A KPI input rather than something
  /// derived from the timestamps: an order raised on Friday and worked on
  /// Monday did not have the chiller down all weekend.
  @$pb.TagNumber(32)
  $core.int get downtimeMinutes => $_getIZ(31);
  @$pb.TagNumber(32)
  set downtimeMinutes($core.int value) => $_setSignedInt32(31, value);
  @$pb.TagNumber(32)
  $core.bool hasDowntimeMinutes() => $_has(31);
  @$pb.TagNumber(32)
  void clearDowntimeMinutes() => $_clearField(32);

  @$pb.TagNumber(33)
  $core.String get holdReason => $_getSZ(32);
  @$pb.TagNumber(33)
  set holdReason($core.String value) => $_setString(32, value);
  @$pb.TagNumber(33)
  $core.bool hasHoldReason() => $_has(32);
  @$pb.TagNumber(33)
  void clearHoldReason() => $_clearField(33);

  @$pb.TagNumber(34)
  $core.String get cancelReason => $_getSZ(33);
  @$pb.TagNumber(34)
  set cancelReason($core.String value) => $_setString(33, value);
  @$pb.TagNumber(34)
  $core.bool hasCancelReason() => $_has(33);
  @$pb.TagNumber(34)
  void clearCancelReason() => $_clearField(34);

  @$pb.TagNumber(35)
  $fixnum.Int64 get version => $_getI64(34);
  @$pb.TagNumber(35)
  set version($fixnum.Int64 value) => $_setInt64(34, value);
  @$pb.TagNumber(35)
  $core.bool hasVersion() => $_has(34);
  @$pb.TagNumber(35)
  void clearVersion() => $_clearField(35);
}

/// What a work order has missed (SRS-FAC-002).
class Breach extends $pb.GeneratedMessage {
  factory Breach({
    $core.bool? response,
    $core.bool? resolution,
    $core.int? responseLateMinutes,
    $core.int? resolutionLateMinutes,
  }) {
    final result = create();
    if (response != null) result.response = response;
    if (resolution != null) result.resolution = resolution;
    if (responseLateMinutes != null)
      result.responseLateMinutes = responseLateMinutes;
    if (resolutionLateMinutes != null)
      result.resolutionLateMinutes = resolutionLateMinutes;
    return result;
  }

  Breach._();

  factory Breach.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Breach.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Breach',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'response')
    ..aOB(2, _omitFieldNames ? '' : 'resolution')
    ..aI(3, _omitFieldNames ? '' : 'responseLateMinutes')
    ..aI(4, _omitFieldNames ? '' : 'resolutionLateMinutes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Breach clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Breach copyWith(void Function(Breach) updates) =>
      super.copyWith((message) => updates(message as Breach)) as Breach;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Breach create() => Breach._();
  @$core.override
  Breach createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Breach getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Breach>(create);
  static Breach? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get response => $_getBF(0);
  @$pb.TagNumber(1)
  set response($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasResponse() => $_has(0);
  @$pb.TagNumber(1)
  void clearResponse() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get resolution => $_getBF(1);
  @$pb.TagNumber(2)
  set resolution($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResolution() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolution() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get responseLateMinutes => $_getIZ(2);
  @$pb.TagNumber(3)
  set responseLateMinutes($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResponseLateMinutes() => $_has(2);
  @$pb.TagNumber(3)
  void clearResponseLateMinutes() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get resolutionLateMinutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set resolutionLateMinutes($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResolutionLateMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearResolutionLateMinutes() => $_clearField(4);
}

class RaiseWorkRequest extends $pb.GeneratedMessage {
  factory RaiseWorkRequest({
    $core.String? number,
    $core.String? facilityId,
    $core.String? assetId,
    System? system,
    $core.String? locationId,
    $core.String? locationNote,
    $core.String? fault,
    $core.String? impact,
    Priority? priority,
    $core.String? classCode,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (assetId != null) result.assetId = assetId;
    if (system != null) result.system = system;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (fault != null) result.fault = fault;
    if (impact != null) result.impact = impact;
    if (priority != null) result.priority = priority;
    if (classCode != null) result.classCode = classCode;
    return result;
  }

  RaiseWorkRequest._();

  factory RaiseWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aE<System>(4, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'locationNote')
    ..aOS(7, _omitFieldNames ? '' : 'fault')
    ..aOS(8, _omitFieldNames ? '' : 'impact')
    ..aE<Priority>(9, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(10, _omitFieldNames ? '' : 'classCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseWorkRequest copyWith(void Function(RaiseWorkRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseWorkRequest))
          as RaiseWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseWorkRequest create() => RaiseWorkRequest._();
  @$core.override
  RaiseWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseWorkRequest>(create);
  static RaiseWorkRequest? _defaultInstance;

  /// Left empty, the service mints one.
  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  /// Ignored when asset_id is set: the asset knows its own system, and taking
  /// it from the caller would let a ticket about the oxygen manifold be filed
  /// as plumbing and escalate to nobody.
  @$pb.TagNumber(4)
  System get system => $_getN(3);
  @$pb.TagNumber(4)
  set system(System value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystem() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get fault => $_getSZ(6);
  @$pb.TagNumber(7)
  set fault($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFault() => $_has(6);
  @$pb.TagNumber(7)
  void clearFault() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get impact => $_getSZ(7);
  @$pb.TagNumber(8)
  set impact($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasImpact() => $_has(7);
  @$pb.TagNumber(8)
  void clearImpact() => $_clearField(8);

  @$pb.TagNumber(9)
  Priority get priority => $_getN(8);
  @$pb.TagNumber(9)
  set priority(Priority value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPriority() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriority() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get classCode => $_getSZ(9);
  @$pb.TagNumber(10)
  set classCode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasClassCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearClassCode() => $_clearField(10);
}

class RaiseWorkResponse extends $pb.GeneratedMessage {
  factory RaiseWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  RaiseWorkResponse._();

  factory RaiseWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseWorkResponse copyWith(void Function(RaiseWorkResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseWorkResponse))
          as RaiseWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseWorkResponse create() => RaiseWorkResponse._();
  @$core.override
  RaiseWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseWorkResponse>(create);
  static RaiseWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

class AssignWorkRequest extends $pb.GeneratedMessage {
  factory AssignWorkRequest({
    $core.String? workOrderId,
    $core.String? userId,
    $core.String? team,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (userId != null) result.userId = userId;
    if (team != null) result.team = team;
    if (version != null) result.version = version;
    return result;
  }

  AssignWorkRequest._();

  factory AssignWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'userId')
    ..aOS(3, _omitFieldNames ? '' : 'team')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignWorkRequest copyWith(void Function(AssignWorkRequest) updates) =>
      super.copyWith((message) => updates(message as AssignWorkRequest))
          as AssignWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignWorkRequest create() => AssignWorkRequest._();
  @$core.override
  AssignWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignWorkRequest>(create);
  static AssignWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get userId => $_getSZ(1);
  @$pb.TagNumber(2)
  set userId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get team => $_getSZ(2);
  @$pb.TagNumber(3)
  set team($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTeam() => $_has(2);
  @$pb.TagNumber(3)
  void clearTeam() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class AssignWorkResponse extends $pb.GeneratedMessage {
  factory AssignWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  AssignWorkResponse._();

  factory AssignWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignWorkResponse copyWith(void Function(AssignWorkResponse) updates) =>
      super.copyWith((message) => updates(message as AssignWorkResponse))
          as AssignWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignWorkResponse create() => AssignWorkResponse._();
  @$core.override
  AssignWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignWorkResponse>(create);
  static AssignWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

/// Begins the work, with the paperwork that makes it safe (SRS-FAC-010).
///
/// A class that needs a permit additionally needs fac.permit, which is a
/// different question from "may do maintenance" with a shorter answer.
class StartWorkRequest extends $pb.GeneratedMessage {
  factory StartWorkRequest({
    $core.String? workOrderId,
    $core.String? permitRef,
    $core.String? permitIssuedBy,
    $core.String? lotoRef,
    $core.String? lotoAppliedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (permitRef != null) result.permitRef = permitRef;
    if (permitIssuedBy != null) result.permitIssuedBy = permitIssuedBy;
    if (lotoRef != null) result.lotoRef = lotoRef;
    if (lotoAppliedBy != null) result.lotoAppliedBy = lotoAppliedBy;
    if (version != null) result.version = version;
    return result;
  }

  StartWorkRequest._();

  factory StartWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'permitRef')
    ..aOS(3, _omitFieldNames ? '' : 'permitIssuedBy')
    ..aOS(4, _omitFieldNames ? '' : 'lotoRef')
    ..aOS(5, _omitFieldNames ? '' : 'lotoAppliedBy')
    ..aInt64(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWorkRequest copyWith(void Function(StartWorkRequest) updates) =>
      super.copyWith((message) => updates(message as StartWorkRequest))
          as StartWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWorkRequest create() => StartWorkRequest._();
  @$core.override
  StartWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWorkRequest>(create);
  static StartWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get permitRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set permitRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPermitRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermitRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get permitIssuedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set permitIssuedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPermitIssuedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearPermitIssuedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lotoRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set lotoRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLotoRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearLotoRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get lotoAppliedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set lotoAppliedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLotoAppliedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearLotoAppliedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class StartWorkResponse extends $pb.GeneratedMessage {
  factory StartWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  StartWorkResponse._();

  factory StartWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWorkResponse copyWith(void Function(StartWorkResponse) updates) =>
      super.copyWith((message) => updates(message as StartWorkResponse))
          as StartWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWorkResponse create() => StartWorkResponse._();
  @$core.override
  StartWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWorkResponse>(create);
  static StartWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

class HoldWorkRequest extends $pb.GeneratedMessage {
  factory HoldWorkRequest({
    $core.String? workOrderId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  HoldWorkRequest._();

  factory HoldWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldWorkRequest copyWith(void Function(HoldWorkRequest) updates) =>
      super.copyWith((message) => updates(message as HoldWorkRequest))
          as HoldWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldWorkRequest create() => HoldWorkRequest._();
  @$core.override
  HoldWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldWorkRequest>(create);
  static HoldWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  /// What the work is waiting for. An order on hold for no recorded reason
  /// never comes off hold, because nobody knows what to chase.
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

class HoldWorkResponse extends $pb.GeneratedMessage {
  factory HoldWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  HoldWorkResponse._();

  factory HoldWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldWorkResponse copyWith(void Function(HoldWorkResponse) updates) =>
      super.copyWith((message) => updates(message as HoldWorkResponse))
          as HoldWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldWorkResponse create() => HoldWorkResponse._();
  @$core.override
  HoldWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldWorkResponse>(create);
  static HoldWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

class ResolveWorkRequest extends $pb.GeneratedMessage {
  factory ResolveWorkRequest({
    $core.String? workOrderId,
    $core.String? note,
    $core.String? rootCause,
    $core.int? downtimeMinutes,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (note != null) result.note = note;
    if (rootCause != null) result.rootCause = rootCause;
    if (downtimeMinutes != null) result.downtimeMinutes = downtimeMinutes;
    if (version != null) result.version = version;
    return result;
  }

  ResolveWorkRequest._();

  factory ResolveWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aOS(3, _omitFieldNames ? '' : 'rootCause')
    ..aI(4, _omitFieldNames ? '' : 'downtimeMinutes')
    ..aInt64(5, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveWorkRequest copyWith(void Function(ResolveWorkRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveWorkRequest))
          as ResolveWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveWorkRequest create() => ResolveWorkRequest._();
  @$core.override
  ResolveWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveWorkRequest>(create);
  static ResolveWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rootCause => $_getSZ(2);
  @$pb.TagNumber(3)
  set rootCause($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRootCause() => $_has(2);
  @$pb.TagNumber(3)
  void clearRootCause() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get downtimeMinutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set downtimeMinutes($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDowntimeMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearDowntimeMinutes() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get version => $_getI64(4);
  @$pb.TagNumber(5)
  set version($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => $_clearField(5);
}

class ResolveWorkResponse extends $pb.GeneratedMessage {
  factory ResolveWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  ResolveWorkResponse._();

  factory ResolveWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveWorkResponse copyWith(void Function(ResolveWorkResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveWorkResponse))
          as ResolveWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveWorkResponse create() => ResolveWorkResponse._();
  @$core.override
  ResolveWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveWorkResponse>(create);
  static ResolveWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

/// Signs off resolved work. It takes no permit fields: the paperwork was
/// demanded at StartWork, and asking again here would be asking after it could
/// have helped.
class CloseWorkRequest extends $pb.GeneratedMessage {
  factory CloseWorkRequest({
    $core.String? workOrderId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (version != null) result.version = version;
    return result;
  }

  CloseWorkRequest._();

  factory CloseWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseWorkRequest copyWith(void Function(CloseWorkRequest) updates) =>
      super.copyWith((message) => updates(message as CloseWorkRequest))
          as CloseWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseWorkRequest create() => CloseWorkRequest._();
  @$core.override
  CloseWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseWorkRequest>(create);
  static CloseWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class CloseWorkResponse extends $pb.GeneratedMessage {
  factory CloseWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  CloseWorkResponse._();

  factory CloseWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseWorkResponse copyWith(void Function(CloseWorkResponse) updates) =>
      super.copyWith((message) => updates(message as CloseWorkResponse))
          as CloseWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseWorkResponse create() => CloseWorkResponse._();
  @$core.override
  CloseWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseWorkResponse>(create);
  static CloseWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

class CancelWorkRequest extends $pb.GeneratedMessage {
  factory CancelWorkRequest({
    $core.String? workOrderId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  CancelWorkRequest._();

  factory CancelWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelWorkRequest copyWith(void Function(CancelWorkRequest) updates) =>
      super.copyWith((message) => updates(message as CancelWorkRequest))
          as CancelWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelWorkRequest create() => CancelWorkRequest._();
  @$core.override
  CancelWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelWorkRequest>(create);
  static CancelWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);

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

class CancelWorkResponse extends $pb.GeneratedMessage {
  factory CancelWorkResponse({
    WorkOrder? workOrder,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    return result;
  }

  CancelWorkResponse._();

  factory CancelWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelWorkResponse copyWith(void Function(CancelWorkResponse) updates) =>
      super.copyWith((message) => updates(message as CancelWorkResponse))
          as CancelWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelWorkResponse create() => CancelWorkResponse._();
  @$core.override
  CancelWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelWorkResponse>(create);
  static CancelWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);
}

class GetWorkRequest extends $pb.GeneratedMessage {
  factory GetWorkRequest({
    $core.String? workOrderId,
  }) {
    final result = create();
    if (workOrderId != null) result.workOrderId = workOrderId;
    return result;
  }

  GetWorkRequest._();

  factory GetWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorkRequest copyWith(void Function(GetWorkRequest) updates) =>
      super.copyWith((message) => updates(message as GetWorkRequest))
          as GetWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorkRequest create() => GetWorkRequest._();
  @$core.override
  GetWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorkRequest>(create);
  static GetWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get workOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set workOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrderId() => $_clearField(1);
}

class GetWorkResponse extends $pb.GeneratedMessage {
  factory GetWorkResponse({
    WorkOrder? workOrder,
    Breach? breach,
  }) {
    final result = create();
    if (workOrder != null) result.workOrder = workOrder;
    if (breach != null) result.breach = breach;
    return result;
  }

  GetWorkResponse._();

  factory GetWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..aOM<Breach>(2, _omitFieldNames ? '' : 'breach', subBuilder: Breach.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWorkResponse copyWith(void Function(GetWorkResponse) updates) =>
      super.copyWith((message) => updates(message as GetWorkResponse))
          as GetWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWorkResponse create() => GetWorkResponse._();
  @$core.override
  GetWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWorkResponse>(create);
  static GetWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WorkOrder get workOrder => $_getN(0);
  @$pb.TagNumber(1)
  set workOrder(WorkOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  WorkOrder ensureWorkOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  Breach get breach => $_getN(1);
  @$pb.TagNumber(2)
  set breach(Breach value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBreach() => $_has(1);
  @$pb.TagNumber(2)
  void clearBreach() => $_clearField(2);
  @$pb.TagNumber(2)
  Breach ensureBreach() => $_ensure(1);
}

class ListWorkRequest extends $pb.GeneratedMessage {
  factory ListWorkRequest({
    $core.String? facilityId,
    $core.String? assetId,
    System? system,
    WorkState? state,
    $core.bool? openOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (assetId != null) result.assetId = assetId;
    if (system != null) result.system = system;
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListWorkRequest._();

  factory ListWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aE<System>(3, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<WorkState>(4, _omitFieldNames ? '' : 'state',
        enumValues: WorkState.values)
    ..aOB(5, _omitFieldNames ? '' : 'openOnly')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkRequest copyWith(void Function(ListWorkRequest) updates) =>
      super.copyWith((message) => updates(message as ListWorkRequest))
          as ListWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkRequest create() => ListWorkRequest._();
  @$core.override
  ListWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkRequest>(create);
  static ListWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  System get system => $_getN(2);
  @$pb.TagNumber(3)
  set system(System value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  WorkState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(WorkState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get openOnly => $_getBF(4);
  @$pb.TagNumber(5)
  set openOnly($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOpenOnly() => $_has(4);
  @$pb.TagNumber(5)
  void clearOpenOnly() => $_clearField(5);

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
}

class ListWorkResponse extends $pb.GeneratedMessage {
  factory ListWorkResponse({
    $core.Iterable<WorkOrder>? workOrders,
  }) {
    final result = create();
    if (workOrders != null) result.workOrders.addAll(workOrders);
    return result;
  }

  ListWorkResponse._();

  factory ListWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrders',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWorkResponse copyWith(void Function(ListWorkResponse) updates) =>
      super.copyWith((message) => updates(message as ListWorkResponse))
          as ListWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWorkResponse create() => ListWorkResponse._();
  @$core.override
  ListWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWorkResponse>(create);
  static ListWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WorkOrder> get workOrders => $_getList(0);
}

class GetWorklistRequest extends $pb.GeneratedMessage {
  factory GetWorklistRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
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
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
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

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

/// Breaches first, then by priority, then oldest.
class GetWorklistResponse extends $pb.GeneratedMessage {
  factory GetWorklistResponse({
    $core.Iterable<WorkOrder>? workOrders,
  }) {
    final result = create();
    if (workOrders != null) result.workOrders.addAll(workOrders);
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
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<WorkOrder>(1, _omitFieldNames ? '' : 'workOrders',
        subBuilder: WorkOrder.create)
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

  @$pb.TagNumber(1)
  $pb.PbList<WorkOrder> get workOrders => $_getList(0);
}

/// A recurring maintenance or inspection obligation (SRS-FAC-003).
class Schedule extends $pb.GeneratedMessage {
  factory Schedule({
    $core.String? scheduleId,
    $core.String? assetId,
    $core.String? facilityId,
    $core.String? title,
    MaintenanceKind? kind,
    Trigger? trigger,
    $core.int? intervalDays,
    $core.int? intervalRuntimeHours,
    $core.String? authority,
    $core.bool? requiresEvidence,
    $core.String? workClassCode,
    $core.int? graceDays,
    $core.bool? active,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (scheduleId != null) result.scheduleId = scheduleId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (title != null) result.title = title;
    if (kind != null) result.kind = kind;
    if (trigger != null) result.trigger = trigger;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (intervalRuntimeHours != null)
      result.intervalRuntimeHours = intervalRuntimeHours;
    if (authority != null) result.authority = authority;
    if (requiresEvidence != null) result.requiresEvidence = requiresEvidence;
    if (workClassCode != null) result.workClassCode = workClassCode;
    if (graceDays != null) result.graceDays = graceDays;
    if (active != null) result.active = active;
    if (version != null) result.version = version;
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
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scheduleId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aE<MaintenanceKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: MaintenanceKind.values)
    ..aE<Trigger>(6, _omitFieldNames ? '' : 'trigger',
        enumValues: Trigger.values)
    ..aI(7, _omitFieldNames ? '' : 'intervalDays')
    ..aI(8, _omitFieldNames ? '' : 'intervalRuntimeHours')
    ..aOS(9, _omitFieldNames ? '' : 'authority')
    ..aOB(10, _omitFieldNames ? '' : 'requiresEvidence')
    ..aOS(11, _omitFieldNames ? '' : 'workClassCode')
    ..aI(12, _omitFieldNames ? '' : 'graceDays')
    ..aOB(13, _omitFieldNames ? '' : 'active')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
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
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  MaintenanceKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(MaintenanceKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  Trigger get trigger => $_getN(5);
  @$pb.TagNumber(6)
  set trigger(Trigger value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTrigger() => $_has(5);
  @$pb.TagNumber(6)
  void clearTrigger() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get intervalDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set intervalDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIntervalDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearIntervalDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get intervalRuntimeHours => $_getIZ(7);
  @$pb.TagNumber(8)
  set intervalRuntimeHours($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIntervalRuntimeHours() => $_has(7);
  @$pb.TagNumber(8)
  void clearIntervalRuntimeHours() => $_clearField(8);

  /// Who requires a statutory inspection. Required for one: "statutory" with
  /// nobody named is a schedule that will be deferred like any other.
  @$pb.TagNumber(9)
  $core.String get authority => $_getSZ(8);
  @$pb.TagNumber(9)
  set authority($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAuthority() => $_has(8);
  @$pb.TagNumber(9)
  void clearAuthority() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get requiresEvidence => $_getBF(9);
  @$pb.TagNumber(10)
  set requiresEvidence($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRequiresEvidence() => $_has(9);
  @$pb.TagNumber(10)
  void clearRequiresEvidence() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get workClassCode => $_getSZ(10);
  @$pb.TagNumber(11)
  set workClassCode($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWorkClassCode() => $_has(10);
  @$pb.TagNumber(11)
  void clearWorkClassCode() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get graceDays => $_getIZ(11);
  @$pb.TagNumber(12)
  set graceDays($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasGraceDays() => $_has(11);
  @$pb.TagNumber(12)
  void clearGraceDays() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get active => $_getBF(12);
  @$pb.TagNumber(13)
  set active($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasActive() => $_has(12);
  @$pb.TagNumber(13)
  void clearActive() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One occurrence of a schedule (SRS-FAC-003, SRS-FAC-007).
class Task extends $pb.GeneratedMessage {
  factory Task({
    $core.String? taskId,
    $core.String? scheduleId,
    $core.String? assetId,
    $core.String? facilityId,
    $core.String? title,
    MaintenanceKind? scheduleKind,
    $core.bool? scheduleRequiresEvidence,
    $0.Timestamp? dueAt,
    $core.int? dueRuntimeHours,
    Trigger? triggeredBy,
    TaskState? state,
    $0.Timestamp? doneAt,
    $core.String? doneBy,
    $core.String? findings,
    $core.String? evidenceRef,
    $core.String? certificateRef,
    $0.Timestamp? certificateExpiresAt,
    $core.String? waivedReason,
    $core.String? workOrderId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (scheduleId != null) result.scheduleId = scheduleId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (title != null) result.title = title;
    if (scheduleKind != null) result.scheduleKind = scheduleKind;
    if (scheduleRequiresEvidence != null)
      result.scheduleRequiresEvidence = scheduleRequiresEvidence;
    if (dueAt != null) result.dueAt = dueAt;
    if (dueRuntimeHours != null) result.dueRuntimeHours = dueRuntimeHours;
    if (triggeredBy != null) result.triggeredBy = triggeredBy;
    if (state != null) result.state = state;
    if (doneAt != null) result.doneAt = doneAt;
    if (doneBy != null) result.doneBy = doneBy;
    if (findings != null) result.findings = findings;
    if (evidenceRef != null) result.evidenceRef = evidenceRef;
    if (certificateRef != null) result.certificateRef = certificateRef;
    if (certificateExpiresAt != null)
      result.certificateExpiresAt = certificateExpiresAt;
    if (waivedReason != null) result.waivedReason = waivedReason;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (version != null) result.version = version;
    return result;
  }

  Task._();

  factory Task.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Task.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Task',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'scheduleId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aE<MaintenanceKind>(6, _omitFieldNames ? '' : 'scheduleKind',
        enumValues: MaintenanceKind.values)
    ..aOB(7, _omitFieldNames ? '' : 'scheduleRequiresEvidence')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aI(9, _omitFieldNames ? '' : 'dueRuntimeHours')
    ..aE<Trigger>(10, _omitFieldNames ? '' : 'triggeredBy',
        enumValues: Trigger.values)
    ..aE<TaskState>(11, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'doneAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'doneBy')
    ..aOS(14, _omitFieldNames ? '' : 'findings')
    ..aOS(15, _omitFieldNames ? '' : 'evidenceRef')
    ..aOS(16, _omitFieldNames ? '' : 'certificateRef')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'certificateExpiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'waivedReason')
    ..aOS(19, _omitFieldNames ? '' : 'workOrderId')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Task clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Task copyWith(void Function(Task) updates) =>
      super.copyWith((message) => updates(message as Task)) as Task;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Task create() => Task._();
  @$core.override
  Task createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Task getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Task>(create);
  static Task? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get scheduleId => $_getSZ(1);
  @$pb.TagNumber(2)
  set scheduleId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduleId() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduleId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  /// Copied from the schedule and held to it, so that "a completed statutory
  /// inspection carries a certificate" is a rule about one row.
  @$pb.TagNumber(6)
  MaintenanceKind get scheduleKind => $_getN(5);
  @$pb.TagNumber(6)
  set scheduleKind(MaintenanceKind value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasScheduleKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearScheduleKind() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get scheduleRequiresEvidence => $_getBF(6);
  @$pb.TagNumber(7)
  set scheduleRequiresEvidence($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasScheduleRequiresEvidence() => $_has(6);
  @$pb.TagNumber(7)
  void clearScheduleRequiresEvidence() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get dueAt => $_getN(7);
  @$pb.TagNumber(8)
  set dueAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDueAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDueAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDueAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get dueRuntimeHours => $_getIZ(8);
  @$pb.TagNumber(9)
  set dueRuntimeHours($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDueRuntimeHours() => $_has(8);
  @$pb.TagNumber(9)
  void clearDueRuntimeHours() => $_clearField(9);

  /// Which trigger brought it due. SRS-FAC-007's evidence that a runtime
  /// trigger works.
  @$pb.TagNumber(10)
  Trigger get triggeredBy => $_getN(9);
  @$pb.TagNumber(10)
  set triggeredBy(Trigger value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTriggeredBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearTriggeredBy() => $_clearField(10);

  @$pb.TagNumber(11)
  TaskState get state => $_getN(10);
  @$pb.TagNumber(11)
  set state(TaskState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get doneAt => $_getN(11);
  @$pb.TagNumber(12)
  set doneAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDoneAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDoneAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDoneAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get doneBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set doneBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDoneBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearDoneBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get findings => $_getSZ(13);
  @$pb.TagNumber(14)
  set findings($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasFindings() => $_has(13);
  @$pb.TagNumber(14)
  void clearFindings() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get evidenceRef => $_getSZ(14);
  @$pb.TagNumber(15)
  set evidenceRef($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasEvidenceRef() => $_has(14);
  @$pb.TagNumber(15)
  void clearEvidenceRef() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get certificateRef => $_getSZ(15);
  @$pb.TagNumber(16)
  set certificateRef($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCertificateRef() => $_has(15);
  @$pb.TagNumber(16)
  void clearCertificateRef() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get certificateExpiresAt => $_getN(16);
  @$pb.TagNumber(17)
  set certificateExpiresAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCertificateExpiresAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearCertificateExpiresAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureCertificateExpiresAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get waivedReason => $_getSZ(17);
  @$pb.TagNumber(18)
  set waivedReason($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasWaivedReason() => $_has(17);
  @$pb.TagNumber(18)
  void clearWaivedReason() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get workOrderId => $_getSZ(18);
  @$pb.TagNumber(19)
  set workOrderId($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasWorkOrderId() => $_has(18);
  @$pb.TagNumber(19)
  void clearWorkOrderId() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

class AddScheduleRequest extends $pb.GeneratedMessage {
  factory AddScheduleRequest({
    $core.String? assetId,
    $core.String? facilityId,
    $core.String? title,
    MaintenanceKind? kind,
    Trigger? trigger,
    $core.int? intervalDays,
    $core.int? intervalRuntimeHours,
    $core.String? authority,
    $core.bool? requiresEvidence,
    $core.String? workClassCode,
    $core.int? graceDays,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (title != null) result.title = title;
    if (kind != null) result.kind = kind;
    if (trigger != null) result.trigger = trigger;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (intervalRuntimeHours != null)
      result.intervalRuntimeHours = intervalRuntimeHours;
    if (authority != null) result.authority = authority;
    if (requiresEvidence != null) result.requiresEvidence = requiresEvidence;
    if (workClassCode != null) result.workClassCode = workClassCode;
    if (graceDays != null) result.graceDays = graceDays;
    return result;
  }

  AddScheduleRequest._();

  factory AddScheduleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddScheduleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddScheduleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aE<MaintenanceKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: MaintenanceKind.values)
    ..aE<Trigger>(5, _omitFieldNames ? '' : 'trigger',
        enumValues: Trigger.values)
    ..aI(6, _omitFieldNames ? '' : 'intervalDays')
    ..aI(7, _omitFieldNames ? '' : 'intervalRuntimeHours')
    ..aOS(8, _omitFieldNames ? '' : 'authority')
    ..aOB(9, _omitFieldNames ? '' : 'requiresEvidence')
    ..aOS(10, _omitFieldNames ? '' : 'workClassCode')
    ..aI(11, _omitFieldNames ? '' : 'graceDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddScheduleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddScheduleRequest copyWith(void Function(AddScheduleRequest) updates) =>
      super.copyWith((message) => updates(message as AddScheduleRequest))
          as AddScheduleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddScheduleRequest create() => AddScheduleRequest._();
  @$core.override
  AddScheduleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddScheduleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddScheduleRequest>(create);
  static AddScheduleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  MaintenanceKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(MaintenanceKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  Trigger get trigger => $_getN(4);
  @$pb.TagNumber(5)
  set trigger(Trigger value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTrigger() => $_has(4);
  @$pb.TagNumber(5)
  void clearTrigger() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get intervalDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set intervalDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIntervalDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearIntervalDays() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get intervalRuntimeHours => $_getIZ(6);
  @$pb.TagNumber(7)
  set intervalRuntimeHours($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIntervalRuntimeHours() => $_has(6);
  @$pb.TagNumber(7)
  void clearIntervalRuntimeHours() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get authority => $_getSZ(7);
  @$pb.TagNumber(8)
  set authority($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAuthority() => $_has(7);
  @$pb.TagNumber(8)
  void clearAuthority() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get requiresEvidence => $_getBF(8);
  @$pb.TagNumber(9)
  set requiresEvidence($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRequiresEvidence() => $_has(8);
  @$pb.TagNumber(9)
  void clearRequiresEvidence() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get workClassCode => $_getSZ(9);
  @$pb.TagNumber(10)
  set workClassCode($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWorkClassCode() => $_has(9);
  @$pb.TagNumber(10)
  void clearWorkClassCode() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get graceDays => $_getIZ(10);
  @$pb.TagNumber(11)
  set graceDays($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasGraceDays() => $_has(10);
  @$pb.TagNumber(11)
  void clearGraceDays() => $_clearField(11);
}

class AddScheduleResponse extends $pb.GeneratedMessage {
  factory AddScheduleResponse({
    Schedule? schedule,
  }) {
    final result = create();
    if (schedule != null) result.schedule = schedule;
    return result;
  }

  AddScheduleResponse._();

  factory AddScheduleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddScheduleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddScheduleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Schedule>(1, _omitFieldNames ? '' : 'schedule',
        subBuilder: Schedule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddScheduleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddScheduleResponse copyWith(void Function(AddScheduleResponse) updates) =>
      super.copyWith((message) => updates(message as AddScheduleResponse))
          as AddScheduleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddScheduleResponse create() => AddScheduleResponse._();
  @$core.override
  AddScheduleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddScheduleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddScheduleResponse>(create);
  static AddScheduleResponse? _defaultInstance;

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

class ListSchedulesRequest extends $pb.GeneratedMessage {
  factory ListSchedulesRequest({
    $core.String? assetId,
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListSchedulesRequest._();

  factory ListSchedulesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSchedulesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSchedulesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSchedulesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSchedulesRequest copyWith(void Function(ListSchedulesRequest) updates) =>
      super.copyWith((message) => updates(message as ListSchedulesRequest))
          as ListSchedulesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSchedulesRequest create() => ListSchedulesRequest._();
  @$core.override
  ListSchedulesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSchedulesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSchedulesRequest>(create);
  static ListSchedulesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

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

class ListSchedulesResponse extends $pb.GeneratedMessage {
  factory ListSchedulesResponse({
    $core.Iterable<Schedule>? schedules,
  }) {
    final result = create();
    if (schedules != null) result.schedules.addAll(schedules);
    return result;
  }

  ListSchedulesResponse._();

  factory ListSchedulesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSchedulesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSchedulesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Schedule>(1, _omitFieldNames ? '' : 'schedules',
        subBuilder: Schedule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSchedulesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSchedulesResponse copyWith(
          void Function(ListSchedulesResponse) updates) =>
      super.copyWith((message) => updates(message as ListSchedulesResponse))
          as ListSchedulesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSchedulesResponse create() => ListSchedulesResponse._();
  @$core.override
  ListSchedulesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSchedulesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSchedulesResponse>(create);
  static ListSchedulesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Schedule> get schedules => $_getList(0);
}

/// Plans an occurrence for every schedule that has come round.
class PlanDueRequest extends $pb.GeneratedMessage {
  factory PlanDueRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  PlanDueRequest._();

  factory PlanDueRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanDueRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanDueRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanDueRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanDueRequest copyWith(void Function(PlanDueRequest) updates) =>
      super.copyWith((message) => updates(message as PlanDueRequest))
          as PlanDueRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanDueRequest create() => PlanDueRequest._();
  @$core.override
  PlanDueRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanDueRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanDueRequest>(create);
  static PlanDueRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class PlanDueResponse extends $pb.GeneratedMessage {
  factory PlanDueResponse({
    $core.Iterable<Task>? tasks,
  }) {
    final result = create();
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  PlanDueResponse._();

  factory PlanDueResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanDueResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanDueResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Task>(1, _omitFieldNames ? '' : 'tasks', subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanDueResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanDueResponse copyWith(void Function(PlanDueResponse) updates) =>
      super.copyWith((message) => updates(message as PlanDueResponse))
          as PlanDueResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanDueResponse create() => PlanDueResponse._();
  @$core.override
  PlanDueResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanDueResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanDueResponse>(create);
  static PlanDueResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Task> get tasks => $_getList(0);
}

class CompleteTaskRequest extends $pb.GeneratedMessage {
  factory CompleteTaskRequest({
    $core.String? taskId,
    $core.String? findings,
    $core.String? evidenceRef,
    $core.String? certificateRef,
    $0.Timestamp? certificateExpiresAt,
    $core.String? workOrderId,
    $core.int? runtimeHours,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (findings != null) result.findings = findings;
    if (evidenceRef != null) result.evidenceRef = evidenceRef;
    if (certificateRef != null) result.certificateRef = certificateRef;
    if (certificateExpiresAt != null)
      result.certificateExpiresAt = certificateExpiresAt;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (runtimeHours != null) result.runtimeHours = runtimeHours;
    if (version != null) result.version = version;
    return result;
  }

  CompleteTaskRequest._();

  factory CompleteTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'findings')
    ..aOS(3, _omitFieldNames ? '' : 'evidenceRef')
    ..aOS(4, _omitFieldNames ? '' : 'certificateRef')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'certificateExpiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'workOrderId')
    ..aI(7, _omitFieldNames ? '' : 'runtimeHours')
    ..aInt64(8, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTaskRequest copyWith(void Function(CompleteTaskRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteTaskRequest))
          as CompleteTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteTaskRequest create() => CompleteTaskRequest._();
  @$core.override
  CompleteTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteTaskRequest>(create);
  static CompleteTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get findings => $_getSZ(1);
  @$pb.TagNumber(2)
  set findings($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFindings() => $_has(1);
  @$pb.TagNumber(2)
  void clearFindings() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get evidenceRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set evidenceRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidenceRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidenceRef() => $_clearField(3);

  /// Both required for a statutory inspection. A certificate with no expiry is
  /// one nobody renews.
  @$pb.TagNumber(4)
  $core.String get certificateRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set certificateRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCertificateRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearCertificateRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get certificateExpiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set certificateExpiresAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCertificateExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCertificateExpiresAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCertificateExpiresAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get workOrderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set workOrderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWorkOrderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearWorkOrderId() => $_clearField(6);

  /// Left zero, the asset's own counter is used: the two disagreeing is how
  /// the next service fires at the wrong time.
  @$pb.TagNumber(7)
  $core.int get runtimeHours => $_getIZ(6);
  @$pb.TagNumber(7)
  set runtimeHours($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRuntimeHours() => $_has(6);
  @$pb.TagNumber(7)
  void clearRuntimeHours() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get version => $_getI64(7);
  @$pb.TagNumber(8)
  set version($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVersion() => $_has(7);
  @$pb.TagNumber(8)
  void clearVersion() => $_clearField(8);
}

class CompleteTaskResponse extends $pb.GeneratedMessage {
  factory CompleteTaskResponse({
    Task? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  CompleteTaskResponse._();

  factory CompleteTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Task>(1, _omitFieldNames ? '' : 'task', subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTaskResponse copyWith(void Function(CompleteTaskResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteTaskResponse))
          as CompleteTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteTaskResponse create() => CompleteTaskResponse._();
  @$core.override
  CompleteTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteTaskResponse>(create);
  static CompleteTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Task get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(Task value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  Task ensureTask() => $_ensure(0);
}

/// A statutory inspection cannot be waived, and there is no field here that
/// changes that. If it genuinely cannot happen, the schedule is what changes.
class WaiveTaskRequest extends $pb.GeneratedMessage {
  factory WaiveTaskRequest({
    $core.String? taskId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  WaiveTaskRequest._();

  factory WaiveTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaiveTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaiveTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveTaskRequest copyWith(void Function(WaiveTaskRequest) updates) =>
      super.copyWith((message) => updates(message as WaiveTaskRequest))
          as WaiveTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveTaskRequest create() => WaiveTaskRequest._();
  @$core.override
  WaiveTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WaiveTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaiveTaskRequest>(create);
  static WaiveTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

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

class WaiveTaskResponse extends $pb.GeneratedMessage {
  factory WaiveTaskResponse({
    Task? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  WaiveTaskResponse._();

  factory WaiveTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WaiveTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WaiveTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Task>(1, _omitFieldNames ? '' : 'task', subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WaiveTaskResponse copyWith(void Function(WaiveTaskResponse) updates) =>
      super.copyWith((message) => updates(message as WaiveTaskResponse))
          as WaiveTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WaiveTaskResponse create() => WaiveTaskResponse._();
  @$core.override
  WaiveTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WaiveTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WaiveTaskResponse>(create);
  static WaiveTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Task get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(Task value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  Task ensureTask() => $_ensure(0);
}

class ListTasksRequest extends $pb.GeneratedMessage {
  factory ListTasksRequest({
    $core.String? scheduleId,
    $core.String? assetId,
    $core.String? facilityId,
    TaskState? state,
    MaintenanceKind? kind,
    $core.int? pageSize,
  }) {
    final result = create();
    if (scheduleId != null) result.scheduleId = scheduleId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (state != null) result.state = state;
    if (kind != null) result.kind = kind;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListTasksRequest._();

  factory ListTasksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTasksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTasksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scheduleId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<TaskState>(4, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aE<MaintenanceKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: MaintenanceKind.values)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTasksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTasksRequest copyWith(void Function(ListTasksRequest) updates) =>
      super.copyWith((message) => updates(message as ListTasksRequest))
          as ListTasksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTasksRequest create() => ListTasksRequest._();
  @$core.override
  ListTasksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTasksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTasksRequest>(create);
  static ListTasksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scheduleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scheduleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScheduleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScheduleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  TaskState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(TaskState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  MaintenanceKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(MaintenanceKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);
}

class ListTasksResponse extends $pb.GeneratedMessage {
  factory ListTasksResponse({
    $core.Iterable<Task>? tasks,
  }) {
    final result = create();
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  ListTasksResponse._();

  factory ListTasksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTasksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTasksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Task>(1, _omitFieldNames ? '' : 'tasks', subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTasksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTasksResponse copyWith(void Function(ListTasksResponse) updates) =>
      super.copyWith((message) => updates(message as ListTasksResponse))
          as ListTasksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTasksResponse create() => ListTasksResponse._();
  @$core.override
  ListTasksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTasksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTasksResponse>(create);
  static ListTasksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Task> get tasks => $_getList(0);
}

/// The due/overdue picture (SRS-FAC-003).
class MaintenanceReport extends $pb.GeneratedMessage {
  factory MaintenanceReport({
    $core.int? planned,
    $core.int? overdue,
    $core.int? done,
    $core.int? missed,
    $core.int? waived,
    $core.int? statutoryOverdue,
    $core.int? evidenceMissing,
    $core.Iterable<Task>? overdueTasks,
  }) {
    final result = create();
    if (planned != null) result.planned = planned;
    if (overdue != null) result.overdue = overdue;
    if (done != null) result.done = done;
    if (missed != null) result.missed = missed;
    if (waived != null) result.waived = waived;
    if (statutoryOverdue != null) result.statutoryOverdue = statutoryOverdue;
    if (evidenceMissing != null) result.evidenceMissing = evidenceMissing;
    if (overdueTasks != null) result.overdueTasks.addAll(overdueTasks);
    return result;
  }

  MaintenanceReport._();

  factory MaintenanceReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MaintenanceReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MaintenanceReport',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'planned')
    ..aI(2, _omitFieldNames ? '' : 'overdue')
    ..aI(3, _omitFieldNames ? '' : 'done')
    ..aI(4, _omitFieldNames ? '' : 'missed')
    ..aI(5, _omitFieldNames ? '' : 'waived')
    ..aI(6, _omitFieldNames ? '' : 'statutoryOverdue')
    ..aI(7, _omitFieldNames ? '' : 'evidenceMissing')
    ..pPM<Task>(8, _omitFieldNames ? '' : 'overdueTasks',
        subBuilder: Task.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MaintenanceReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MaintenanceReport copyWith(void Function(MaintenanceReport) updates) =>
      super.copyWith((message) => updates(message as MaintenanceReport))
          as MaintenanceReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MaintenanceReport create() => MaintenanceReport._();
  @$core.override
  MaintenanceReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MaintenanceReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MaintenanceReport>(create);
  static MaintenanceReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get planned => $_getIZ(0);
  @$pb.TagNumber(1)
  set planned($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanned() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanned() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get overdue => $_getIZ(1);
  @$pb.TagNumber(2)
  set overdue($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOverdue() => $_has(1);
  @$pb.TagNumber(2)
  void clearOverdue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get done => $_getIZ(2);
  @$pb.TagNumber(3)
  set done($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDone() => $_has(2);
  @$pb.TagNumber(3)
  void clearDone() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get missed => $_getIZ(3);
  @$pb.TagNumber(4)
  set missed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMissed() => $_has(3);
  @$pb.TagNumber(4)
  void clearMissed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get waived => $_getIZ(4);
  @$pb.TagNumber(5)
  set waived($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWaived() => $_has(4);
  @$pb.TagNumber(5)
  void clearWaived() => $_clearField(5);

  /// Counted separately because it is a different kind of problem: the rest is
  /// housekeeping, this is an operating licence.
  @$pb.TagNumber(6)
  $core.int get statutoryOverdue => $_getIZ(5);
  @$pb.TagNumber(6)
  set statutoryOverdue($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStatutoryOverdue() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatutoryOverdue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get evidenceMissing => $_getIZ(6);
  @$pb.TagNumber(7)
  set evidenceMissing($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEvidenceMissing() => $_has(6);
  @$pb.TagNumber(7)
  void clearEvidenceMissing() => $_clearField(7);

  /// Statutory first, then oldest.
  @$pb.TagNumber(8)
  $pb.PbList<Task> get overdueTasks => $_getList(7);
}

class GetMaintenanceReportRequest extends $pb.GeneratedMessage {
  factory GetMaintenanceReportRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetMaintenanceReportRequest._();

  factory GetMaintenanceReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMaintenanceReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMaintenanceReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaintenanceReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaintenanceReportRequest copyWith(
          void Function(GetMaintenanceReportRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetMaintenanceReportRequest))
          as GetMaintenanceReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMaintenanceReportRequest create() =>
      GetMaintenanceReportRequest._();
  @$core.override
  GetMaintenanceReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMaintenanceReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMaintenanceReportRequest>(create);
  static GetMaintenanceReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetMaintenanceReportResponse extends $pb.GeneratedMessage {
  factory GetMaintenanceReportResponse({
    MaintenanceReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetMaintenanceReportResponse._();

  factory GetMaintenanceReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMaintenanceReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMaintenanceReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<MaintenanceReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: MaintenanceReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaintenanceReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMaintenanceReportResponse copyWith(
          void Function(GetMaintenanceReportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetMaintenanceReportResponse))
          as GetMaintenanceReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMaintenanceReportResponse create() =>
      GetMaintenanceReportResponse._();
  @$core.override
  GetMaintenanceReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMaintenanceReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMaintenanceReportResponse>(create);
  static GetMaintenanceReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  MaintenanceReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(MaintenanceReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  MaintenanceReport ensureReport() => $_ensure(0);
}

/// One reading of an asset's hour counter (SRS-FAC-007).
class RuntimeReading extends $pb.GeneratedMessage {
  factory RuntimeReading({
    $core.String? readingId,
    $core.String? assetId,
    $core.int? hours,
    $0.Timestamp? readAt,
    Source? source,
    $core.String? sourceRef,
    $core.String? recordedBy,
    $core.bool? counterReplaced,
    $core.String? note,
  }) {
    final result = create();
    if (readingId != null) result.readingId = readingId;
    if (assetId != null) result.assetId = assetId;
    if (hours != null) result.hours = hours;
    if (readAt != null) result.readAt = readAt;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (counterReplaced != null) result.counterReplaced = counterReplaced;
    if (note != null) result.note = note;
    return result;
  }

  RuntimeReading._();

  factory RuntimeReading.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RuntimeReading.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RuntimeReading',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aI(3, _omitFieldNames ? '' : 'hours')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'readAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Source>(5, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(6, _omitFieldNames ? '' : 'sourceRef')
    ..aOS(7, _omitFieldNames ? '' : 'recordedBy')
    ..aOB(8, _omitFieldNames ? '' : 'counterReplaced')
    ..aOS(9, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeReading clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RuntimeReading copyWith(void Function(RuntimeReading) updates) =>
      super.copyWith((message) => updates(message as RuntimeReading))
          as RuntimeReading;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RuntimeReading create() => RuntimeReading._();
  @$core.override
  RuntimeReading createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RuntimeReading getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RuntimeReading>(create);
  static RuntimeReading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  /// The counter as read, not hours since the last reading.
  @$pb.TagNumber(3)
  $core.int get hours => $_getIZ(2);
  @$pb.TagNumber(3)
  set hours($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHours() => $_has(2);
  @$pb.TagNumber(3)
  void clearHours() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get readAt => $_getN(3);
  @$pb.TagNumber(4)
  set readAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReadAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearReadAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureReadAt() => $_ensure(3);

  @$pb.TagNumber(5)
  Source get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(Source value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceRef() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get recordedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set recordedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordedBy() => $_clearField(7);

  /// The one legitimate reason a cumulative reading goes backwards.
  @$pb.TagNumber(8)
  $core.bool get counterReplaced => $_getBF(7);
  @$pb.TagNumber(8)
  set counterReplaced($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCounterReplaced() => $_has(7);
  @$pb.TagNumber(8)
  void clearCounterReplaced() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get note => $_getSZ(8);
  @$pb.TagNumber(9)
  set note($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearNote() => $_clearField(9);
}

class RecordRuntimeRequest extends $pb.GeneratedMessage {
  factory RecordRuntimeRequest({
    $core.String? assetId,
    $core.int? hours,
    $0.Timestamp? readAt,
    Source? source,
    $core.String? sourceRef,
    $core.bool? counterReplaced,
    $core.String? note,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (hours != null) result.hours = hours;
    if (readAt != null) result.readAt = readAt;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (counterReplaced != null) result.counterReplaced = counterReplaced;
    if (note != null) result.note = note;
    return result;
  }

  RecordRuntimeRequest._();

  factory RecordRuntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordRuntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordRuntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aI(2, _omitFieldNames ? '' : 'hours')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'readAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Source>(4, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourceRef')
    ..aOB(6, _omitFieldNames ? '' : 'counterReplaced')
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRuntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRuntimeRequest copyWith(void Function(RecordRuntimeRequest) updates) =>
      super.copyWith((message) => updates(message as RecordRuntimeRequest))
          as RecordRuntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordRuntimeRequest create() => RecordRuntimeRequest._();
  @$core.override
  RecordRuntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordRuntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordRuntimeRequest>(create);
  static RecordRuntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get hours => $_getIZ(1);
  @$pb.TagNumber(2)
  set hours($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHours() => $_has(1);
  @$pb.TagNumber(2)
  void clearHours() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get readAt => $_getN(2);
  @$pb.TagNumber(3)
  set readAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureReadAt() => $_ensure(2);

  @$pb.TagNumber(4)
  Source get source => $_getN(3);
  @$pb.TagNumber(4)
  set source(Source value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get counterReplaced => $_getBF(5);
  @$pb.TagNumber(6)
  set counterReplaced($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCounterReplaced() => $_has(5);
  @$pb.TagNumber(6)
  void clearCounterReplaced() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);
}

class RecordRuntimeResponse extends $pb.GeneratedMessage {
  factory RecordRuntimeResponse({
    RuntimeReading? reading,
  }) {
    final result = create();
    if (reading != null) result.reading = reading;
    return result;
  }

  RecordRuntimeResponse._();

  factory RecordRuntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordRuntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordRuntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<RuntimeReading>(1, _omitFieldNames ? '' : 'reading',
        subBuilder: RuntimeReading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRuntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordRuntimeResponse copyWith(
          void Function(RecordRuntimeResponse) updates) =>
      super.copyWith((message) => updates(message as RecordRuntimeResponse))
          as RecordRuntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordRuntimeResponse create() => RecordRuntimeResponse._();
  @$core.override
  RecordRuntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordRuntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordRuntimeResponse>(create);
  static RecordRuntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RuntimeReading get reading => $_getN(0);
  @$pb.TagNumber(1)
  set reading(RuntimeReading value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReading() => $_has(0);
  @$pb.TagNumber(1)
  void clearReading() => $_clearField(1);
  @$pb.TagNumber(1)
  RuntimeReading ensureReading() => $_ensure(0);
}

/// A utility shutdown permit and the interruption it covers (SRS-FAC-004).
class Outage extends $pb.GeneratedMessage {
  factory Outage({
    $core.String? outageId,
    $core.String? reference,
    $core.String? facilityId,
    System? system,
    $core.String? title,
    $core.String? reason,
    $0.Timestamp? plannedFrom,
    $0.Timestamp? plannedTo,
    $0.Timestamp? actualFrom,
    $0.Timestamp? actualTo,
    OutageState? state,
    $core.String? requestedBy,
    $0.Timestamp? requestedAt,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.String? permitRef,
    $core.String? contingency,
    $core.String? restoredBy,
    $core.String? cancelReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (reference != null) result.reference = reference;
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (title != null) result.title = title;
    if (reason != null) result.reason = reason;
    if (plannedFrom != null) result.plannedFrom = plannedFrom;
    if (plannedTo != null) result.plannedTo = plannedTo;
    if (actualFrom != null) result.actualFrom = actualFrom;
    if (actualTo != null) result.actualTo = actualTo;
    if (state != null) result.state = state;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (requestedAt != null) result.requestedAt = requestedAt;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (permitRef != null) result.permitRef = permitRef;
    if (contingency != null) result.contingency = contingency;
    if (restoredBy != null) result.restoredBy = restoredBy;
    if (cancelReason != null) result.cancelReason = cancelReason;
    if (version != null) result.version = version;
    return result;
  }

  Outage._();

  factory Outage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Outage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Outage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(4, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'plannedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'plannedTo',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'actualFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'actualTo',
        subBuilder: $0.Timestamp.create)
    ..aE<OutageState>(11, _omitFieldNames ? '' : 'state',
        enumValues: OutageState.values)
    ..aOS(12, _omitFieldNames ? '' : 'requestedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'requestedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'permitRef')
    ..aOS(17, _omitFieldNames ? '' : 'contingency')
    ..aOS(18, _omitFieldNames ? '' : 'restoredBy')
    ..aOS(19, _omitFieldNames ? '' : 'cancelReason')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Outage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Outage copyWith(void Function(Outage) updates) =>
      super.copyWith((message) => updates(message as Outage)) as Outage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Outage create() => Outage._();
  @$core.override
  Outage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Outage getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Outage>(create);
  static Outage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

  /// The permit number the estates office writes in its book.
  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  System get system => $_getN(3);
  @$pb.TagNumber(4)
  set system(System value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSystem() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystem() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  /// Why the supply has to go off. The part a ward asks about when it objects.
  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get plannedFrom => $_getN(6);
  @$pb.TagNumber(7)
  set plannedFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlannedFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlannedFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePlannedFrom() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get plannedTo => $_getN(7);
  @$pb.TagNumber(8)
  set plannedTo($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasPlannedTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlannedTo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensurePlannedTo() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get actualFrom => $_getN(8);
  @$pb.TagNumber(9)
  set actualFrom($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasActualFrom() => $_has(8);
  @$pb.TagNumber(9)
  void clearActualFrom() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureActualFrom() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get actualTo => $_getN(9);
  @$pb.TagNumber(10)
  set actualTo($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasActualTo() => $_has(9);
  @$pb.TagNumber(10)
  void clearActualTo() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureActualTo() => $_ensure(9);

  @$pb.TagNumber(11)
  OutageState get state => $_getN(10);
  @$pb.TagNumber(11)
  set state(OutageState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get requestedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set requestedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequestedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequestedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get requestedAt => $_getN(12);
  @$pb.TagNumber(13)
  set requestedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRequestedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearRequestedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRequestedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get approvedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set approvedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasApprovedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearApprovedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get approvedAt => $_getN(14);
  @$pb.TagNumber(15)
  set approvedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasApprovedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearApprovedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureApprovedAt() => $_ensure(14);

  /// The safety permit the isolation is done under, which is not the same as
  /// this outage's own reference.
  @$pb.TagNumber(16)
  $core.String get permitRef => $_getSZ(15);
  @$pb.TagNumber(16)
  set permitRef($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPermitRef() => $_has(15);
  @$pb.TagNumber(16)
  void clearPermitRef() => $_clearField(16);

  /// What covers the affected areas while the supply is off.
  @$pb.TagNumber(17)
  $core.String get contingency => $_getSZ(16);
  @$pb.TagNumber(17)
  set contingency($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasContingency() => $_has(16);
  @$pb.TagNumber(17)
  void clearContingency() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get restoredBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set restoredBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasRestoredBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearRestoredBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get cancelReason => $_getSZ(18);
  @$pb.TagNumber(19)
  set cancelReason($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCancelReason() => $_has(18);
  @$pb.TagNumber(19)
  void clearCancelReason() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

/// One department a shutdown reaches (SRS-FAC-004).
class OutageArea extends $pb.GeneratedMessage {
  factory OutageArea({
    $core.String? areaId,
    $core.String? outageId,
    $core.String? orgUnitId,
    $core.String? name,
    $core.bool? critical,
    $0.Timestamp? notifiedAt,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedBy,
    $core.String? objection,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (areaId != null) result.areaId = areaId;
    if (outageId != null) result.outageId = outageId;
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (name != null) result.name = name;
    if (critical != null) result.critical = critical;
    if (notifiedAt != null) result.notifiedAt = notifiedAt;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (objection != null) result.objection = objection;
    if (version != null) result.version = version;
    return result;
  }

  OutageArea._();

  factory OutageArea.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OutageArea.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OutageArea',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'areaId')
    ..aOS(2, _omitFieldNames ? '' : 'outageId')
    ..aOS(3, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOB(5, _omitFieldNames ? '' : 'critical')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'notifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOS(9, _omitFieldNames ? '' : 'objection')
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OutageArea clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OutageArea copyWith(void Function(OutageArea) updates) =>
      super.copyWith((message) => updates(message as OutageArea)) as OutageArea;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OutageArea create() => OutageArea._();
  @$core.override
  OutageArea createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OutageArea getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OutageArea>(create);
  static OutageArea? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get areaId => $_getSZ(0);
  @$pb.TagNumber(1)
  set areaId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAreaId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAreaId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get outageId => $_getSZ(1);
  @$pb.TagNumber(2)
  set outageId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOutageId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutageId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orgUnitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orgUnitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrgUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrgUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// An area that cannot simply be told. A critical area has to answer before
  /// the supply goes off.
  @$pb.TagNumber(5)
  $core.bool get critical => $_getBF(4);
  @$pb.TagNumber(5)
  set critical($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCritical() => $_has(4);
  @$pb.TagNumber(5)
  void clearCritical() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get notifiedAt => $_getN(5);
  @$pb.TagNumber(6)
  set notifiedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasNotifiedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotifiedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureNotifiedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get acknowledgedAt => $_getN(6);
  @$pb.TagNumber(7)
  set acknowledgedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAcknowledgedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearAcknowledgedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get acknowledgedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set acknowledgedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAcknowledgedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearAcknowledgedBy() => $_clearField(8);

  /// What the area said if it said no. Recorded rather than enforced: a ward
  /// cannot veto a statutory shutdown, but the objection on the record changes
  /// how the conversation goes.
  @$pb.TagNumber(9)
  $core.String get objection => $_getSZ(8);
  @$pb.TagNumber(9)
  set objection($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasObjection() => $_has(8);
  @$pb.TagNumber(9)
  void clearObjection() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

class AreaInput extends $pb.GeneratedMessage {
  factory AreaInput({
    $core.String? orgUnitId,
    $core.String? name,
    $core.bool? critical,
  }) {
    final result = create();
    if (orgUnitId != null) result.orgUnitId = orgUnitId;
    if (name != null) result.name = name;
    if (critical != null) result.critical = critical;
    return result;
  }

  AreaInput._();

  factory AreaInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AreaInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AreaInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orgUnitId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOB(3, _omitFieldNames ? '' : 'critical')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AreaInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AreaInput copyWith(void Function(AreaInput) updates) =>
      super.copyWith((message) => updates(message as AreaInput)) as AreaInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AreaInput create() => AreaInput._();
  @$core.override
  AreaInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AreaInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AreaInput>(create);
  static AreaInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orgUnitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orgUnitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrgUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrgUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get critical => $_getBF(2);
  @$pb.TagNumber(3)
  set critical($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCritical() => $_has(2);
  @$pb.TagNumber(3)
  void clearCritical() => $_clearField(3);
}

/// The areas are declared with the outage, because the permit is approved
/// against a set of consequences and adding one afterwards would mean it was
/// approved against a different set.
class PlanOutageRequest extends $pb.GeneratedMessage {
  factory PlanOutageRequest({
    $core.String? reference,
    $core.String? facilityId,
    System? system,
    $core.String? title,
    $core.String? reason,
    $0.Timestamp? plannedFrom,
    $0.Timestamp? plannedTo,
    $core.String? contingency,
    $core.Iterable<AreaInput>? areas,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (title != null) result.title = title;
    if (reason != null) result.reason = reason;
    if (plannedFrom != null) result.plannedFrom = plannedFrom;
    if (plannedTo != null) result.plannedTo = plannedTo;
    if (contingency != null) result.contingency = contingency;
    if (areas != null) result.areas.addAll(areas);
    return result;
  }

  PlanOutageRequest._();

  factory PlanOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(3, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'plannedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'plannedTo',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'contingency')
    ..pPM<AreaInput>(9, _omitFieldNames ? '' : 'areas',
        subBuilder: AreaInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanOutageRequest copyWith(void Function(PlanOutageRequest) updates) =>
      super.copyWith((message) => updates(message as PlanOutageRequest))
          as PlanOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanOutageRequest create() => PlanOutageRequest._();
  @$core.override
  PlanOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanOutageRequest>(create);
  static PlanOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  System get system => $_getN(2);
  @$pb.TagNumber(3)
  set system(System value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSystem() => $_has(2);
  @$pb.TagNumber(3)
  void clearSystem() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get plannedFrom => $_getN(5);
  @$pb.TagNumber(6)
  set plannedFrom($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPlannedFrom() => $_has(5);
  @$pb.TagNumber(6)
  void clearPlannedFrom() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensurePlannedFrom() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get plannedTo => $_getN(6);
  @$pb.TagNumber(7)
  set plannedTo($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPlannedTo() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlannedTo() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensurePlannedTo() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get contingency => $_getSZ(7);
  @$pb.TagNumber(8)
  set contingency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasContingency() => $_has(7);
  @$pb.TagNumber(8)
  void clearContingency() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<AreaInput> get areas => $_getList(8);
}

class PlanOutageResponse extends $pb.GeneratedMessage {
  factory PlanOutageResponse({
    Outage? outage,
    $core.Iterable<OutageArea>? areas,
    $core.Iterable<Outage>? overlapping,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    if (areas != null) result.areas.addAll(areas);
    if (overlapping != null) result.overlapping.addAll(overlapping);
    return result;
  }

  PlanOutageResponse._();

  factory PlanOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..pPM<OutageArea>(2, _omitFieldNames ? '' : 'areas',
        subBuilder: OutageArea.create)
    ..pPM<Outage>(3, _omitFieldNames ? '' : 'overlapping',
        subBuilder: Outage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanOutageResponse copyWith(void Function(PlanOutageResponse) updates) =>
      super.copyWith((message) => updates(message as PlanOutageResponse))
          as PlanOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanOutageResponse create() => PlanOutageResponse._();
  @$core.override
  PlanOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanOutageResponse>(create);
  static PlanOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<OutageArea> get areas => $_getList(1);

  /// Live shutdowns of the same system whose windows cross this one. A warning
  /// rather than a refusal: two isolations of one system over different wards
  /// are perfectly reasonable.
  @$pb.TagNumber(3)
  $pb.PbList<Outage> get overlapping => $_getList(2);
}

/// Signs the permit and notifies every declared area, in one call. A permit
/// signed today with the telling left for tomorrow is a permit signed without
/// it.
class ApproveOutageRequest extends $pb.GeneratedMessage {
  factory ApproveOutageRequest({
    $core.String? outageId,
    $core.String? permitRef,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (permitRef != null) result.permitRef = permitRef;
    if (version != null) result.version = version;
    return result;
  }

  ApproveOutageRequest._();

  factory ApproveOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aOS(2, _omitFieldNames ? '' : 'permitRef')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveOutageRequest copyWith(void Function(ApproveOutageRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveOutageRequest))
          as ApproveOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveOutageRequest create() => ApproveOutageRequest._();
  @$core.override
  ApproveOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveOutageRequest>(create);
  static ApproveOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get permitRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set permitRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPermitRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearPermitRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class ApproveOutageResponse extends $pb.GeneratedMessage {
  factory ApproveOutageResponse({
    Outage? outage,
    $core.Iterable<OutageArea>? areas,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    if (areas != null) result.areas.addAll(areas);
    return result;
  }

  ApproveOutageResponse._();

  factory ApproveOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..pPM<OutageArea>(2, _omitFieldNames ? '' : 'areas',
        subBuilder: OutageArea.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveOutageResponse copyWith(
          void Function(ApproveOutageResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveOutageResponse))
          as ApproveOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveOutageResponse create() => ApproveOutageResponse._();
  @$core.override
  ApproveOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveOutageResponse>(create);
  static ApproveOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<OutageArea> get areas => $_getList(1);
}

class AcknowledgeOutageRequest extends $pb.GeneratedMessage {
  factory AcknowledgeOutageRequest({
    $core.String? outageId,
    $core.String? areaId,
    $core.String? objection,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (areaId != null) result.areaId = areaId;
    if (objection != null) result.objection = objection;
    if (version != null) result.version = version;
    return result;
  }

  AcknowledgeOutageRequest._();

  factory AcknowledgeOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aOS(2, _omitFieldNames ? '' : 'areaId')
    ..aOS(3, _omitFieldNames ? '' : 'objection')
    ..aInt64(4, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOutageRequest copyWith(
          void Function(AcknowledgeOutageRequest) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeOutageRequest))
          as AcknowledgeOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeOutageRequest create() => AcknowledgeOutageRequest._();
  @$core.override
  AcknowledgeOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeOutageRequest>(create);
  static AcknowledgeOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get areaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set areaId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get objection => $_getSZ(2);
  @$pb.TagNumber(3)
  set objection($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasObjection() => $_has(2);
  @$pb.TagNumber(3)
  void clearObjection() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get version => $_getI64(3);
  @$pb.TagNumber(4)
  set version($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);
}

class AcknowledgeOutageResponse extends $pb.GeneratedMessage {
  factory AcknowledgeOutageResponse({
    OutageArea? area,
  }) {
    final result = create();
    if (area != null) result.area = area;
    return result;
  }

  AcknowledgeOutageResponse._();

  factory AcknowledgeOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<OutageArea>(1, _omitFieldNames ? '' : 'area',
        subBuilder: OutageArea.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeOutageResponse copyWith(
          void Function(AcknowledgeOutageResponse) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeOutageResponse))
          as AcknowledgeOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeOutageResponse create() => AcknowledgeOutageResponse._();
  @$core.override
  AcknowledgeOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeOutageResponse>(create);
  static AcknowledgeOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  OutageArea get area => $_getN(0);
  @$pb.TagNumber(1)
  set area(OutageArea value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArea() => $_has(0);
  @$pb.TagNumber(1)
  void clearArea() => $_clearField(1);
  @$pb.TagNumber(1)
  OutageArea ensureArea() => $_ensure(0);
}

/// Records the supply going off. Every critical area must have answered.
class StartOutageRequest extends $pb.GeneratedMessage {
  factory StartOutageRequest({
    $core.String? outageId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (version != null) result.version = version;
    return result;
  }

  StartOutageRequest._();

  factory StartOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOutageRequest copyWith(void Function(StartOutageRequest) updates) =>
      super.copyWith((message) => updates(message as StartOutageRequest))
          as StartOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOutageRequest create() => StartOutageRequest._();
  @$core.override
  StartOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOutageRequest>(create);
  static StartOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class StartOutageResponse extends $pb.GeneratedMessage {
  factory StartOutageResponse({
    Outage? outage,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    return result;
  }

  StartOutageResponse._();

  factory StartOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartOutageResponse copyWith(void Function(StartOutageResponse) updates) =>
      super.copyWith((message) => updates(message as StartOutageResponse))
          as StartOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartOutageResponse create() => StartOutageResponse._();
  @$core.override
  StartOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartOutageResponse>(create);
  static StartOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);
}

class RestoreOutageRequest extends $pb.GeneratedMessage {
  factory RestoreOutageRequest({
    $core.String? outageId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (version != null) result.version = version;
    return result;
  }

  RestoreOutageRequest._();

  factory RestoreOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreOutageRequest copyWith(void Function(RestoreOutageRequest) updates) =>
      super.copyWith((message) => updates(message as RestoreOutageRequest))
          as RestoreOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreOutageRequest create() => RestoreOutageRequest._();
  @$core.override
  RestoreOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestoreOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreOutageRequest>(create);
  static RestoreOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class RestoreOutageResponse extends $pb.GeneratedMessage {
  factory RestoreOutageResponse({
    Outage? outage,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    return result;
  }

  RestoreOutageResponse._();

  factory RestoreOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreOutageResponse copyWith(
          void Function(RestoreOutageResponse) updates) =>
      super.copyWith((message) => updates(message as RestoreOutageResponse))
          as RestoreOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreOutageResponse create() => RestoreOutageResponse._();
  @$core.override
  RestoreOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestoreOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreOutageResponse>(create);
  static RestoreOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);
}

class CancelOutageRequest extends $pb.GeneratedMessage {
  factory CancelOutageRequest({
    $core.String? outageId,
    $core.String? reason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    if (reason != null) result.reason = reason;
    if (version != null) result.version = version;
    return result;
  }

  CancelOutageRequest._();

  factory CancelOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOutageRequest copyWith(void Function(CancelOutageRequest) updates) =>
      super.copyWith((message) => updates(message as CancelOutageRequest))
          as CancelOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelOutageRequest create() => CancelOutageRequest._();
  @$core.override
  CancelOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelOutageRequest>(create);
  static CancelOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);

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

class CancelOutageResponse extends $pb.GeneratedMessage {
  factory CancelOutageResponse({
    Outage? outage,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    return result;
  }

  CancelOutageResponse._();

  factory CancelOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelOutageResponse copyWith(void Function(CancelOutageResponse) updates) =>
      super.copyWith((message) => updates(message as CancelOutageResponse))
          as CancelOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelOutageResponse create() => CancelOutageResponse._();
  @$core.override
  CancelOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelOutageResponse>(create);
  static CancelOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);
}

class GetOutageRequest extends $pb.GeneratedMessage {
  factory GetOutageRequest({
    $core.String? outageId,
  }) {
    final result = create();
    if (outageId != null) result.outageId = outageId;
    return result;
  }

  GetOutageRequest._();

  factory GetOutageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOutageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOutageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'outageId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOutageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOutageRequest copyWith(void Function(GetOutageRequest) updates) =>
      super.copyWith((message) => updates(message as GetOutageRequest))
          as GetOutageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOutageRequest create() => GetOutageRequest._();
  @$core.override
  GetOutageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOutageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOutageRequest>(create);
  static GetOutageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get outageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set outageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOutageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutageId() => $_clearField(1);
}

class GetOutageResponse extends $pb.GeneratedMessage {
  factory GetOutageResponse({
    Outage? outage,
    $core.Iterable<OutageArea>? areas,
  }) {
    final result = create();
    if (outage != null) result.outage = outage;
    if (areas != null) result.areas.addAll(areas);
    return result;
  }

  GetOutageResponse._();

  factory GetOutageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOutageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOutageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Outage>(1, _omitFieldNames ? '' : 'outage', subBuilder: Outage.create)
    ..pPM<OutageArea>(2, _omitFieldNames ? '' : 'areas',
        subBuilder: OutageArea.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOutageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOutageResponse copyWith(void Function(GetOutageResponse) updates) =>
      super.copyWith((message) => updates(message as GetOutageResponse))
          as GetOutageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOutageResponse create() => GetOutageResponse._();
  @$core.override
  GetOutageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOutageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOutageResponse>(create);
  static GetOutageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Outage get outage => $_getN(0);
  @$pb.TagNumber(1)
  set outage(Outage value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOutage() => $_has(0);
  @$pb.TagNumber(1)
  void clearOutage() => $_clearField(1);
  @$pb.TagNumber(1)
  Outage ensureOutage() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<OutageArea> get areas => $_getList(1);
}

class ListOutagesRequest extends $pb.GeneratedMessage {
  factory ListOutagesRequest({
    $core.String? facilityId,
    System? system,
    $core.bool? liveOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListOutagesRequest._();

  factory ListOutagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(2, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aOB(3, _omitFieldNames ? '' : 'liveOnly')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutagesRequest copyWith(void Function(ListOutagesRequest) updates) =>
      super.copyWith((message) => updates(message as ListOutagesRequest))
          as ListOutagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutagesRequest create() => ListOutagesRequest._();
  @$core.override
  ListOutagesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutagesRequest>(create);
  static ListOutagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  System get system => $_getN(1);
  @$pb.TagNumber(2)
  set system(System value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystem() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get liveOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set liveOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLiveOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearLiveOnly() => $_clearField(3);

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
}

class ListOutagesResponse extends $pb.GeneratedMessage {
  factory ListOutagesResponse({
    $core.Iterable<Outage>? outages,
  }) {
    final result = create();
    if (outages != null) result.outages.addAll(outages);
    return result;
  }

  ListOutagesResponse._();

  factory ListOutagesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOutagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOutagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Outage>(1, _omitFieldNames ? '' : 'outages',
        subBuilder: Outage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOutagesResponse copyWith(void Function(ListOutagesResponse) updates) =>
      super.copyWith((message) => updates(message as ListOutagesResponse))
          as ListOutagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOutagesResponse create() => ListOutagesResponse._();
  @$core.override
  ListOutagesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOutagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOutagesResponse>(create);
  static ListOutagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Outage> get outages => $_getList(0);
}

/// One event from a facility gateway (SRS-FAC-005).
///
/// There is no work order state on this message and no assignee. The alarm and
/// the maintenance lifecycle stay distinct because neither can express the
/// other's.
class Alarm extends $pb.GeneratedMessage {
  factory Alarm({
    $core.String? alarmId,
    $core.String? gatewayId,
    $core.String? pointRef,
    $core.String? externalId,
    $core.String? assetId,
    $core.String? facilityId,
    System? system,
    Severity? severity,
    $core.String? message,
    Source? source,
    $0.Timestamp? raisedAt,
    $0.Timestamp? clearedAt,
    AlarmState? state,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedBy,
    $core.String? workOrderId,
    $0.Timestamp? linkedAt,
    $core.String? linkedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (alarmId != null) result.alarmId = alarmId;
    if (gatewayId != null) result.gatewayId = gatewayId;
    if (pointRef != null) result.pointRef = pointRef;
    if (externalId != null) result.externalId = externalId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (severity != null) result.severity = severity;
    if (message != null) result.message = message;
    if (source != null) result.source = source;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (clearedAt != null) result.clearedAt = clearedAt;
    if (state != null) result.state = state;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (linkedAt != null) result.linkedAt = linkedAt;
    if (linkedBy != null) result.linkedBy = linkedBy;
    if (version != null) result.version = version;
    return result;
  }

  Alarm._();

  factory Alarm.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Alarm.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Alarm',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alarmId')
    ..aOS(2, _omitFieldNames ? '' : 'gatewayId')
    ..aOS(3, _omitFieldNames ? '' : 'pointRef')
    ..aOS(4, _omitFieldNames ? '' : 'externalId')
    ..aOS(5, _omitFieldNames ? '' : 'assetId')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(7, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(8, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(9, _omitFieldNames ? '' : 'message')
    ..aE<Source>(10, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'clearedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<AlarmState>(13, _omitFieldNames ? '' : 'state',
        enumValues: AlarmState.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOS(16, _omitFieldNames ? '' : 'workOrderId')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'linkedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'linkedBy')
    ..aInt64(19, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarm clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alarm copyWith(void Function(Alarm) updates) =>
      super.copyWith((message) => updates(message as Alarm)) as Alarm;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alarm create() => Alarm._();
  @$core.override
  Alarm createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Alarm getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alarm>(create);
  static Alarm? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alarmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alarmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get gatewayId => $_getSZ(1);
  @$pb.TagNumber(2)
  set gatewayId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGatewayId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGatewayId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pointRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set pointRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPointRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearPointRef() => $_clearField(3);

  /// The gateway's own identifier. A gateway reconnecting after a network drop
  /// replays its buffer, and this is what recognises it.
  @$pb.TagNumber(4)
  $core.String get externalId => $_getSZ(3);
  @$pb.TagNumber(4)
  set externalId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExternalId() => $_has(3);
  @$pb.TagNumber(4)
  void clearExternalId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get assetId => $_getSZ(4);
  @$pb.TagNumber(5)
  set assetId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssetId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssetId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  @$pb.TagNumber(7)
  System get system => $_getN(6);
  @$pb.TagNumber(7)
  set system(System value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSystem() => $_has(6);
  @$pb.TagNumber(7)
  void clearSystem() => $_clearField(7);

  @$pb.TagNumber(8)
  Severity get severity => $_getN(7);
  @$pb.TagNumber(8)
  set severity(Severity value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSeverity() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeverity() => $_clearField(8);

  /// The gateway's text, kept as it arrived: a rewritten alarm message cannot
  /// be matched against the panel.
  @$pb.TagNumber(9)
  $core.String get message => $_getSZ(8);
  @$pb.TagNumber(9)
  set message($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasMessage() => $_has(8);
  @$pb.TagNumber(9)
  void clearMessage() => $_clearField(9);

  @$pb.TagNumber(10)
  Source get source => $_getN(9);
  @$pb.TagNumber(10)
  set source(Source value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSource() => $_has(9);
  @$pb.TagNumber(10)
  void clearSource() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get raisedAt => $_getN(10);
  @$pb.TagNumber(11)
  set raisedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRaisedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRaisedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRaisedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get clearedAt => $_getN(11);
  @$pb.TagNumber(12)
  set clearedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasClearedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearClearedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureClearedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  AlarmState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state(AlarmState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get acknowledgedAt => $_getN(13);
  @$pb.TagNumber(14)
  set acknowledgedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasAcknowledgedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearAcknowledgedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get acknowledgedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set acknowledgedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAcknowledgedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearAcknowledgedBy() => $_clearField(15);

  /// Written once. Repointing it would rewrite the answer to "what did we do
  /// about the gas alarm on the 14th".
  @$pb.TagNumber(16)
  $core.String get workOrderId => $_getSZ(15);
  @$pb.TagNumber(16)
  set workOrderId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasWorkOrderId() => $_has(15);
  @$pb.TagNumber(16)
  void clearWorkOrderId() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get linkedAt => $_getN(16);
  @$pb.TagNumber(17)
  set linkedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasLinkedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearLinkedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureLinkedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get linkedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set linkedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasLinkedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearLinkedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $fixnum.Int64 get version => $_getI64(18);
  @$pb.TagNumber(19)
  set version($fixnum.Int64 value) => $_setInt64(18, value);
  @$pb.TagNumber(19)
  $core.bool hasVersion() => $_has(18);
  @$pb.TagNumber(19)
  void clearVersion() => $_clearField(19);
}

/// Which alarms raise work, and what the resulting work looks like
/// (SRS-FAC-005's "when configured").
class AlarmRule extends $pb.GeneratedMessage {
  factory AlarmRule({
    $core.String? facilityId,
    System? system,
    Severity? minSeverity,
    Priority? priority,
    $core.String? classCode,
    $core.String? ownerTeam,
    $core.bool? active,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (minSeverity != null) result.minSeverity = minSeverity;
    if (priority != null) result.priority = priority;
    if (classCode != null) result.classCode = classCode;
    if (ownerTeam != null) result.ownerTeam = ownerTeam;
    if (active != null) result.active = active;
    return result;
  }

  AlarmRule._();

  factory AlarmRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AlarmRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AlarmRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(2, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(3, _omitFieldNames ? '' : 'minSeverity',
        enumValues: Severity.values)
    ..aE<Priority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(5, _omitFieldNames ? '' : 'classCode')
    ..aOS(6, _omitFieldNames ? '' : 'ownerTeam')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AlarmRule copyWith(void Function(AlarmRule) updates) =>
      super.copyWith((message) => updates(message as AlarmRule)) as AlarmRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AlarmRule create() => AlarmRule._();
  @$core.override
  AlarmRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AlarmRule getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AlarmRule>(create);
  static AlarmRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  System get system => $_getN(1);
  @$pb.TagNumber(2)
  set system(System value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystem() => $_clearField(2);

  /// The quietest alarm that raises work.
  @$pb.TagNumber(3)
  Severity get minSeverity => $_getN(2);
  @$pb.TagNumber(3)
  set minSeverity(Severity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMinSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  Priority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(Priority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get classCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set classCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClassCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearClassCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerTeam => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerTeam($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerTeam() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerTeam() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);
}

/// A person who has noticed something wrong raises a work order. Alarms come
/// from plant: SOURCE_MANUAL is refused here.
class IngestAlarmRequest extends $pb.GeneratedMessage {
  factory IngestAlarmRequest({
    $core.String? gatewayId,
    $core.String? pointRef,
    $core.String? externalId,
    $core.String? assetId,
    $core.String? facilityId,
    System? system,
    Severity? severity,
    $core.String? message,
    Source? source,
    $0.Timestamp? raisedAt,
  }) {
    final result = create();
    if (gatewayId != null) result.gatewayId = gatewayId;
    if (pointRef != null) result.pointRef = pointRef;
    if (externalId != null) result.externalId = externalId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (severity != null) result.severity = severity;
    if (message != null) result.message = message;
    if (source != null) result.source = source;
    if (raisedAt != null) result.raisedAt = raisedAt;
    return result;
  }

  IngestAlarmRequest._();

  factory IngestAlarmRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngestAlarmRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestAlarmRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'gatewayId')
    ..aOS(2, _omitFieldNames ? '' : 'pointRef')
    ..aOS(3, _omitFieldNames ? '' : 'externalId')
    ..aOS(4, _omitFieldNames ? '' : 'assetId')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(6, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(7, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(8, _omitFieldNames ? '' : 'message')
    ..aE<Source>(9, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestAlarmRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestAlarmRequest copyWith(void Function(IngestAlarmRequest) updates) =>
      super.copyWith((message) => updates(message as IngestAlarmRequest))
          as IngestAlarmRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestAlarmRequest create() => IngestAlarmRequest._();
  @$core.override
  IngestAlarmRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngestAlarmRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestAlarmRequest>(create);
  static IngestAlarmRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get gatewayId => $_getSZ(0);
  @$pb.TagNumber(1)
  set gatewayId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGatewayId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGatewayId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pointRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set pointRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPointRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearPointRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get externalId => $_getSZ(2);
  @$pb.TagNumber(3)
  set externalId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExternalId() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get assetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  System get system => $_getN(5);
  @$pb.TagNumber(6)
  set system(System value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSystem() => $_has(5);
  @$pb.TagNumber(6)
  void clearSystem() => $_clearField(6);

  @$pb.TagNumber(7)
  Severity get severity => $_getN(6);
  @$pb.TagNumber(7)
  set severity(Severity value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSeverity() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeverity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get message => $_getSZ(7);
  @$pb.TagNumber(8)
  set message($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  Source get source => $_getN(8);
  @$pb.TagNumber(9)
  set source(Source value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSource() => $_has(8);
  @$pb.TagNumber(9)
  void clearSource() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get raisedAt => $_getN(9);
  @$pb.TagNumber(10)
  set raisedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRaisedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRaisedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRaisedAt() => $_ensure(9);
}

class IngestAlarmResponse extends $pb.GeneratedMessage {
  factory IngestAlarmResponse({
    Alarm? alarm,
    WorkOrder? workOrder,
    $core.bool? raisedWork,
    $core.bool? duplicate,
  }) {
    final result = create();
    if (alarm != null) result.alarm = alarm;
    if (workOrder != null) result.workOrder = workOrder;
    if (raisedWork != null) result.raisedWork = raisedWork;
    if (duplicate != null) result.duplicate = duplicate;
    return result;
  }

  IngestAlarmResponse._();

  factory IngestAlarmResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IngestAlarmResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IngestAlarmResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Alarm>(1, _omitFieldNames ? '' : 'alarm', subBuilder: Alarm.create)
    ..aOM<WorkOrder>(2, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..aOB(3, _omitFieldNames ? '' : 'raisedWork')
    ..aOB(4, _omitFieldNames ? '' : 'duplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestAlarmResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IngestAlarmResponse copyWith(void Function(IngestAlarmResponse) updates) =>
      super.copyWith((message) => updates(message as IngestAlarmResponse))
          as IngestAlarmResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestAlarmResponse create() => IngestAlarmResponse._();
  @$core.override
  IngestAlarmResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IngestAlarmResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IngestAlarmResponse>(create);
  static IngestAlarmResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alarm get alarm => $_getN(0);
  @$pb.TagNumber(1)
  set alarm(Alarm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarm() => $_clearField(1);
  @$pb.TagNumber(1)
  Alarm ensureAlarm() => $_ensure(0);

  /// Present when a configured rule raised one.
  @$pb.TagNumber(2)
  WorkOrder get workOrder => $_getN(1);
  @$pb.TagNumber(2)
  set workOrder(WorkOrder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  WorkOrder ensureWorkOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get raisedWork => $_getBF(2);
  @$pb.TagNumber(3)
  set raisedWork($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRaisedWork() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaisedWork() => $_clearField(3);

  /// The gateway replayed something already recorded. Not an error.
  @$pb.TagNumber(4)
  $core.bool get duplicate => $_getBF(3);
  @$pb.TagNumber(4)
  set duplicate($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDuplicate() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuplicate() => $_clearField(4);
}

/// Records the plant no longer asserting the alarm. It does not close work.
class ClearAlarmRequest extends $pb.GeneratedMessage {
  factory ClearAlarmRequest({
    $core.String? alarmId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (alarmId != null) result.alarmId = alarmId;
    if (version != null) result.version = version;
    return result;
  }

  ClearAlarmRequest._();

  factory ClearAlarmRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearAlarmRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearAlarmRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alarmId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlarmRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlarmRequest copyWith(void Function(ClearAlarmRequest) updates) =>
      super.copyWith((message) => updates(message as ClearAlarmRequest))
          as ClearAlarmRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearAlarmRequest create() => ClearAlarmRequest._();
  @$core.override
  ClearAlarmRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearAlarmRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearAlarmRequest>(create);
  static ClearAlarmRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alarmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alarmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class ClearAlarmResponse extends $pb.GeneratedMessage {
  factory ClearAlarmResponse({
    Alarm? alarm,
  }) {
    final result = create();
    if (alarm != null) result.alarm = alarm;
    return result;
  }

  ClearAlarmResponse._();

  factory ClearAlarmResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ClearAlarmResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ClearAlarmResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Alarm>(1, _omitFieldNames ? '' : 'alarm', subBuilder: Alarm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlarmResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ClearAlarmResponse copyWith(void Function(ClearAlarmResponse) updates) =>
      super.copyWith((message) => updates(message as ClearAlarmResponse))
          as ClearAlarmResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClearAlarmResponse create() => ClearAlarmResponse._();
  @$core.override
  ClearAlarmResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ClearAlarmResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ClearAlarmResponse>(create);
  static ClearAlarmResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alarm get alarm => $_getN(0);
  @$pb.TagNumber(1)
  set alarm(Alarm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarm() => $_clearField(1);
  @$pb.TagNumber(1)
  Alarm ensureAlarm() => $_ensure(0);
}

/// Allowed on a cleared alarm: a pressure dip at 3am that cleared itself still
/// needs somebody to have looked at it.
class AcknowledgeAlarmRequest extends $pb.GeneratedMessage {
  factory AcknowledgeAlarmRequest({
    $core.String? alarmId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (alarmId != null) result.alarmId = alarmId;
    if (version != null) result.version = version;
    return result;
  }

  AcknowledgeAlarmRequest._();

  factory AcknowledgeAlarmRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeAlarmRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeAlarmRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alarmId')
    ..aInt64(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlarmRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlarmRequest copyWith(
          void Function(AcknowledgeAlarmRequest) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeAlarmRequest))
          as AcknowledgeAlarmRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlarmRequest create() => AcknowledgeAlarmRequest._();
  @$core.override
  AcknowledgeAlarmRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlarmRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeAlarmRequest>(create);
  static AcknowledgeAlarmRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alarmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alarmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get version => $_getI64(1);
  @$pb.TagNumber(2)
  set version($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class AcknowledgeAlarmResponse extends $pb.GeneratedMessage {
  factory AcknowledgeAlarmResponse({
    Alarm? alarm,
  }) {
    final result = create();
    if (alarm != null) result.alarm = alarm;
    return result;
  }

  AcknowledgeAlarmResponse._();

  factory AcknowledgeAlarmResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeAlarmResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeAlarmResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Alarm>(1, _omitFieldNames ? '' : 'alarm', subBuilder: Alarm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlarmResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeAlarmResponse copyWith(
          void Function(AcknowledgeAlarmResponse) updates) =>
      super.copyWith((message) => updates(message as AcknowledgeAlarmResponse))
          as AcknowledgeAlarmResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlarmResponse create() => AcknowledgeAlarmResponse._();
  @$core.override
  AcknowledgeAlarmResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeAlarmResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeAlarmResponse>(create);
  static AcknowledgeAlarmResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alarm get alarm => $_getN(0);
  @$pb.TagNumber(1)
  set alarm(Alarm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarm() => $_clearField(1);
  @$pb.TagNumber(1)
  Alarm ensureAlarm() => $_ensure(0);
}

class LinkAlarmWorkRequest extends $pb.GeneratedMessage {
  factory LinkAlarmWorkRequest({
    $core.String? alarmId,
    $core.String? workOrderId,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (alarmId != null) result.alarmId = alarmId;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (version != null) result.version = version;
    return result;
  }

  LinkAlarmWorkRequest._();

  factory LinkAlarmWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkAlarmWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkAlarmWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'alarmId')
    ..aOS(2, _omitFieldNames ? '' : 'workOrderId')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkAlarmWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkAlarmWorkRequest copyWith(void Function(LinkAlarmWorkRequest) updates) =>
      super.copyWith((message) => updates(message as LinkAlarmWorkRequest))
          as LinkAlarmWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkAlarmWorkRequest create() => LinkAlarmWorkRequest._();
  @$core.override
  LinkAlarmWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkAlarmWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkAlarmWorkRequest>(create);
  static LinkAlarmWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get alarmId => $_getSZ(0);
  @$pb.TagNumber(1)
  set alarmId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarmId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarmId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workOrderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class LinkAlarmWorkResponse extends $pb.GeneratedMessage {
  factory LinkAlarmWorkResponse({
    Alarm? alarm,
  }) {
    final result = create();
    if (alarm != null) result.alarm = alarm;
    return result;
  }

  LinkAlarmWorkResponse._();

  factory LinkAlarmWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinkAlarmWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinkAlarmWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Alarm>(1, _omitFieldNames ? '' : 'alarm', subBuilder: Alarm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkAlarmWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinkAlarmWorkResponse copyWith(
          void Function(LinkAlarmWorkResponse) updates) =>
      super.copyWith((message) => updates(message as LinkAlarmWorkResponse))
          as LinkAlarmWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkAlarmWorkResponse create() => LinkAlarmWorkResponse._();
  @$core.override
  LinkAlarmWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinkAlarmWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinkAlarmWorkResponse>(create);
  static LinkAlarmWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Alarm get alarm => $_getN(0);
  @$pb.TagNumber(1)
  set alarm(Alarm value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAlarm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlarm() => $_clearField(1);
  @$pb.TagNumber(1)
  Alarm ensureAlarm() => $_ensure(0);
}

class SetAlarmRuleRequest extends $pb.GeneratedMessage {
  factory SetAlarmRuleRequest({
    $core.String? facilityId,
    System? system,
    Severity? minSeverity,
    Priority? priority,
    $core.String? classCode,
    $core.String? ownerTeam,
    $core.bool? active,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (minSeverity != null) result.minSeverity = minSeverity;
    if (priority != null) result.priority = priority;
    if (classCode != null) result.classCode = classCode;
    if (ownerTeam != null) result.ownerTeam = ownerTeam;
    if (active != null) result.active = active;
    return result;
  }

  SetAlarmRuleRequest._();

  factory SetAlarmRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAlarmRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlarmRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(2, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(3, _omitFieldNames ? '' : 'minSeverity',
        enumValues: Severity.values)
    ..aE<Priority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aOS(5, _omitFieldNames ? '' : 'classCode')
    ..aOS(6, _omitFieldNames ? '' : 'ownerTeam')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlarmRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlarmRuleRequest copyWith(void Function(SetAlarmRuleRequest) updates) =>
      super.copyWith((message) => updates(message as SetAlarmRuleRequest))
          as SetAlarmRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAlarmRuleRequest create() => SetAlarmRuleRequest._();
  @$core.override
  SetAlarmRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAlarmRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlarmRuleRequest>(create);
  static SetAlarmRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  System get system => $_getN(1);
  @$pb.TagNumber(2)
  set system(System value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystem() => $_clearField(2);

  @$pb.TagNumber(3)
  Severity get minSeverity => $_getN(2);
  @$pb.TagNumber(3)
  set minSeverity(Severity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMinSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  Priority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(Priority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get classCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set classCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasClassCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearClassCode() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get ownerTeam => $_getSZ(5);
  @$pb.TagNumber(6)
  set ownerTeam($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnerTeam() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnerTeam() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);
}

class SetAlarmRuleResponse extends $pb.GeneratedMessage {
  factory SetAlarmRuleResponse({
    AlarmRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  SetAlarmRuleResponse._();

  factory SetAlarmRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAlarmRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAlarmRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<AlarmRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: AlarmRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlarmRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAlarmRuleResponse copyWith(void Function(SetAlarmRuleResponse) updates) =>
      super.copyWith((message) => updates(message as SetAlarmRuleResponse))
          as SetAlarmRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAlarmRuleResponse create() => SetAlarmRuleResponse._();
  @$core.override
  SetAlarmRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAlarmRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAlarmRuleResponse>(create);
  static SetAlarmRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AlarmRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(AlarmRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  AlarmRule ensureRule() => $_ensure(0);
}

class ListAlarmsRequest extends $pb.GeneratedMessage {
  factory ListAlarmsRequest({
    $core.String? facilityId,
    System? system,
    AlarmState? state,
    $core.bool? unansweredOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (system != null) result.system = system;
    if (state != null) result.state = state;
    if (unansweredOnly != null) result.unansweredOnly = unansweredOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAlarmsRequest._();

  factory ListAlarmsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlarmsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlarmsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<System>(2, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<AlarmState>(3, _omitFieldNames ? '' : 'state',
        enumValues: AlarmState.values)
    ..aOB(4, _omitFieldNames ? '' : 'unansweredOnly')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlarmsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlarmsRequest copyWith(void Function(ListAlarmsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAlarmsRequest))
          as ListAlarmsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlarmsRequest create() => ListAlarmsRequest._();
  @$core.override
  ListAlarmsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlarmsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlarmsRequest>(create);
  static ListAlarmsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  System get system => $_getN(1);
  @$pb.TagNumber(2)
  set system(System value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSystem() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystem() => $_clearField(2);

  @$pb.TagNumber(3)
  AlarmState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(AlarmState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  /// Cleared alarms included: one that came and went without anybody
  /// acknowledging it is the one worth looking at.
  @$pb.TagNumber(4)
  $core.bool get unansweredOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set unansweredOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnansweredOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnansweredOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get from => $_getN(4);
  @$pb.TagNumber(5)
  set from($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFrom() => $_has(4);
  @$pb.TagNumber(5)
  void clearFrom() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureFrom() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get to => $_getN(5);
  @$pb.TagNumber(6)
  set to($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTo() => $_has(5);
  @$pb.TagNumber(6)
  void clearTo() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureTo() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.int get pageSize => $_getIZ(6);
  @$pb.TagNumber(7)
  set pageSize($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPageSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearPageSize() => $_clearField(7);
}

class ListAlarmsResponse extends $pb.GeneratedMessage {
  factory ListAlarmsResponse({
    $core.Iterable<Alarm>? alarms,
  }) {
    final result = create();
    if (alarms != null) result.alarms.addAll(alarms);
    return result;
  }

  ListAlarmsResponse._();

  factory ListAlarmsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlarmsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlarmsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Alarm>(1, _omitFieldNames ? '' : 'alarms', subBuilder: Alarm.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlarmsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlarmsResponse copyWith(void Function(ListAlarmsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAlarmsResponse))
          as ListAlarmsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlarmsResponse create() => ListAlarmsResponse._();
  @$core.override
  ListAlarmsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlarmsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlarmsResponse>(create);
  static ListAlarmsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alarm> get alarms => $_getList(0);
}

/// A fire or life-safety finding (SRS-FAC-008).
class Deficiency extends $pb.GeneratedMessage {
  factory Deficiency({
    $core.String? deficiencyId,
    $core.String? taskId,
    $core.String? assetId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? locationNote,
    System? system,
    Severity? severity,
    $core.String? finding,
    $core.String? standard,
    DeficiencyState? state,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $0.Timestamp? dueAt,
    $core.String? workOrderId,
    $core.String? mitigationNote,
    $0.Timestamp? mitigatedAt,
    $core.String? mitigatedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureEvidenceRef,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (taskId != null) result.taskId = taskId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (system != null) result.system = system;
    if (severity != null) result.severity = severity;
    if (finding != null) result.finding = finding;
    if (standard != null) result.standard = standard;
    if (state != null) result.state = state;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (dueAt != null) result.dueAt = dueAt;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (mitigationNote != null) result.mitigationNote = mitigationNote;
    if (mitigatedAt != null) result.mitigatedAt = mitigatedAt;
    if (mitigatedBy != null) result.mitigatedBy = mitigatedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureEvidenceRef != null)
      result.closureEvidenceRef = closureEvidenceRef;
    if (version != null) result.version = version;
    return result;
  }

  Deficiency._();

  factory Deficiency.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Deficiency.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Deficiency',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'locationId')
    ..aOS(6, _omitFieldNames ? '' : 'locationNote')
    ..aE<System>(7, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(8, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(9, _omitFieldNames ? '' : 'finding')
    ..aOS(10, _omitFieldNames ? '' : 'standard')
    ..aE<DeficiencyState>(11, _omitFieldNames ? '' : 'state',
        enumValues: DeficiencyState.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'raisedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(16, _omitFieldNames ? '' : 'mitigationNote')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'mitigatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'mitigatedBy')
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(20, _omitFieldNames ? '' : 'closedBy')
    ..aOS(21, _omitFieldNames ? '' : 'closureEvidenceRef')
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Deficiency clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Deficiency copyWith(void Function(Deficiency) updates) =>
      super.copyWith((message) => updates(message as Deficiency)) as Deficiency;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Deficiency create() => Deficiency._();
  @$core.override
  Deficiency createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Deficiency getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Deficiency>(create);
  static Deficiency? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationNote => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationNote($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationNote() => $_clearField(6);

  @$pb.TagNumber(7)
  System get system => $_getN(6);
  @$pb.TagNumber(7)
  set system(System value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSystem() => $_has(6);
  @$pb.TagNumber(7)
  void clearSystem() => $_clearField(7);

  @$pb.TagNumber(8)
  Severity get severity => $_getN(7);
  @$pb.TagNumber(8)
  set severity(Severity value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSeverity() => $_has(7);
  @$pb.TagNumber(8)
  void clearSeverity() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get finding => $_getSZ(8);
  @$pb.TagNumber(9)
  set finding($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFinding() => $_has(8);
  @$pb.TagNumber(9)
  void clearFinding() => $_clearField(9);

  /// The clause it breaches. What turns "the door does not shut" into
  /// something a hospital can be held to.
  @$pb.TagNumber(10)
  $core.String get standard => $_getSZ(9);
  @$pb.TagNumber(10)
  set standard($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStandard() => $_has(9);
  @$pb.TagNumber(10)
  void clearStandard() => $_clearField(10);

  @$pb.TagNumber(11)
  DeficiencyState get state => $_getN(10);
  @$pb.TagNumber(11)
  set state(DeficiencyState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get raisedAt => $_getN(11);
  @$pb.TagNumber(12)
  set raisedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRaisedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearRaisedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureRaisedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get raisedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set raisedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRaisedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRaisedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get dueAt => $_getN(13);
  @$pb.TagNumber(14)
  set dueAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDueAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearDueAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureDueAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get workOrderId => $_getSZ(14);
  @$pb.TagNumber(15)
  set workOrderId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasWorkOrderId() => $_has(14);
  @$pb.TagNumber(15)
  void clearWorkOrderId() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get mitigationNote => $_getSZ(15);
  @$pb.TagNumber(16)
  set mitigationNote($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasMitigationNote() => $_has(15);
  @$pb.TagNumber(16)
  void clearMitigationNote() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get mitigatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set mitigatedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasMitigatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearMitigatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureMitigatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get mitigatedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set mitigatedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasMitigatedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearMitigatedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.Timestamp get closedAt => $_getN(18);
  @$pb.TagNumber(19)
  set closedAt($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasClosedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearClosedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureClosedAt() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get closedBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set closedBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasClosedBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearClosedBy() => $_clearField(20);

  /// A critical finding does not close on somebody's word.
  @$pb.TagNumber(21)
  $core.String get closureEvidenceRef => $_getSZ(20);
  @$pb.TagNumber(21)
  set closureEvidenceRef($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasClosureEvidenceRef() => $_has(20);
  @$pb.TagNumber(21)
  void clearClosureEvidenceRef() => $_clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(22)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(22)
  void clearVersion() => $_clearField(22);
}

/// A critical finding with no work_order_id gets one raised for it: a critical
/// deficiency that is only a note is one nobody is assigned to.
class RaiseDeficiencyRequest extends $pb.GeneratedMessage {
  factory RaiseDeficiencyRequest({
    $core.String? taskId,
    $core.String? assetId,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? locationNote,
    System? system,
    Severity? severity,
    $core.String? finding,
    $core.String? standard,
    $0.Timestamp? dueAt,
    $core.String? workOrderId,
    $core.String? classCode,
    Priority? priority,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (assetId != null) result.assetId = assetId;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (locationNote != null) result.locationNote = locationNote;
    if (system != null) result.system = system;
    if (severity != null) result.severity = severity;
    if (finding != null) result.finding = finding;
    if (standard != null) result.standard = standard;
    if (dueAt != null) result.dueAt = dueAt;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (classCode != null) result.classCode = classCode;
    if (priority != null) result.priority = priority;
    return result;
  }

  RaiseDeficiencyRequest._();

  factory RaiseDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'locationId')
    ..aOS(5, _omitFieldNames ? '' : 'locationNote')
    ..aE<System>(6, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aE<Severity>(7, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOS(8, _omitFieldNames ? '' : 'finding')
    ..aOS(9, _omitFieldNames ? '' : 'standard')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(12, _omitFieldNames ? '' : 'classCode')
    ..aE<Priority>(13, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficiencyRequest copyWith(
          void Function(RaiseDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseDeficiencyRequest))
          as RaiseDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseDeficiencyRequest create() => RaiseDeficiencyRequest._();
  @$core.override
  RaiseDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseDeficiencyRequest>(create);
  static RaiseDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get locationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set locationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocationId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get locationNote => $_getSZ(4);
  @$pb.TagNumber(5)
  set locationNote($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocationNote() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocationNote() => $_clearField(5);

  @$pb.TagNumber(6)
  System get system => $_getN(5);
  @$pb.TagNumber(6)
  set system(System value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSystem() => $_has(5);
  @$pb.TagNumber(6)
  void clearSystem() => $_clearField(6);

  @$pb.TagNumber(7)
  Severity get severity => $_getN(6);
  @$pb.TagNumber(7)
  set severity(Severity value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSeverity() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeverity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get finding => $_getSZ(7);
  @$pb.TagNumber(8)
  set finding($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFinding() => $_has(7);
  @$pb.TagNumber(8)
  void clearFinding() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get standard => $_getSZ(8);
  @$pb.TagNumber(9)
  set standard($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStandard() => $_has(8);
  @$pb.TagNumber(9)
  void clearStandard() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get dueAt => $_getN(9);
  @$pb.TagNumber(10)
  set dueAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasDueAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearDueAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureDueAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get workOrderId => $_getSZ(10);
  @$pb.TagNumber(11)
  set workOrderId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWorkOrderId() => $_has(10);
  @$pb.TagNumber(11)
  void clearWorkOrderId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get classCode => $_getSZ(11);
  @$pb.TagNumber(12)
  set classCode($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasClassCode() => $_has(11);
  @$pb.TagNumber(12)
  void clearClassCode() => $_clearField(12);

  @$pb.TagNumber(13)
  Priority get priority => $_getN(12);
  @$pb.TagNumber(13)
  set priority(Priority value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasPriority() => $_has(12);
  @$pb.TagNumber(13)
  void clearPriority() => $_clearField(13);
}

class RaiseDeficiencyResponse extends $pb.GeneratedMessage {
  factory RaiseDeficiencyResponse({
    Deficiency? deficiency,
    WorkOrder? workOrder,
    $core.bool? raisedWork,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    if (workOrder != null) result.workOrder = workOrder;
    if (raisedWork != null) result.raisedWork = raisedWork;
    return result;
  }

  RaiseDeficiencyResponse._();

  factory RaiseDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..aOM<WorkOrder>(2, _omitFieldNames ? '' : 'workOrder',
        subBuilder: WorkOrder.create)
    ..aOB(3, _omitFieldNames ? '' : 'raisedWork')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseDeficiencyResponse copyWith(
          void Function(RaiseDeficiencyResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseDeficiencyResponse))
          as RaiseDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseDeficiencyResponse create() => RaiseDeficiencyResponse._();
  @$core.override
  RaiseDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseDeficiencyResponse>(create);
  static RaiseDeficiencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);

  @$pb.TagNumber(2)
  WorkOrder get workOrder => $_getN(1);
  @$pb.TagNumber(2)
  set workOrder(WorkOrder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrder() => $_clearField(2);
  @$pb.TagNumber(2)
  WorkOrder ensureWorkOrder() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.bool get raisedWork => $_getBF(2);
  @$pb.TagNumber(3)
  set raisedWork($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRaisedWork() => $_has(2);
  @$pb.TagNumber(3)
  void clearRaisedWork() => $_clearField(3);
}

/// Records an interim measure. It closes nothing: a fire watch is not a repair.
class MitigateDeficiencyRequest extends $pb.GeneratedMessage {
  factory MitigateDeficiencyRequest({
    $core.String? deficiencyId,
    $core.String? note,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (note != null) result.note = note;
    if (version != null) result.version = version;
    return result;
  }

  MitigateDeficiencyRequest._();

  factory MitigateDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MitigateDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MitigateDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MitigateDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MitigateDeficiencyRequest copyWith(
          void Function(MitigateDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as MitigateDeficiencyRequest))
          as MitigateDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MitigateDeficiencyRequest create() => MitigateDeficiencyRequest._();
  @$core.override
  MitigateDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MitigateDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MitigateDeficiencyRequest>(create);
  static MitigateDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class MitigateDeficiencyResponse extends $pb.GeneratedMessage {
  factory MitigateDeficiencyResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  MitigateDeficiencyResponse._();

  factory MitigateDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MitigateDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MitigateDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MitigateDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MitigateDeficiencyResponse copyWith(
          void Function(MitigateDeficiencyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as MitigateDeficiencyResponse))
          as MitigateDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MitigateDeficiencyResponse create() => MitigateDeficiencyResponse._();
  @$core.override
  MitigateDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MitigateDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MitigateDeficiencyResponse>(create);
  static MitigateDeficiencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

class CloseDeficiencyRequest extends $pb.GeneratedMessage {
  factory CloseDeficiencyRequest({
    $core.String? deficiencyId,
    $core.String? evidenceRef,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (deficiencyId != null) result.deficiencyId = deficiencyId;
    if (evidenceRef != null) result.evidenceRef = evidenceRef;
    if (version != null) result.version = version;
    return result;
  }

  CloseDeficiencyRequest._();

  factory CloseDeficiencyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseDeficiencyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseDeficiencyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deficiencyId')
    ..aOS(2, _omitFieldNames ? '' : 'evidenceRef')
    ..aInt64(3, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDeficiencyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDeficiencyRequest copyWith(
          void Function(CloseDeficiencyRequest) updates) =>
      super.copyWith((message) => updates(message as CloseDeficiencyRequest))
          as CloseDeficiencyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseDeficiencyRequest create() => CloseDeficiencyRequest._();
  @$core.override
  CloseDeficiencyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseDeficiencyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseDeficiencyRequest>(create);
  static CloseDeficiencyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deficiencyId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deficiencyId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiencyId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiencyId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get evidenceRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set evidenceRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEvidenceRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvidenceRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get version => $_getI64(2);
  @$pb.TagNumber(3)
  set version($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersion() => $_clearField(3);
}

class CloseDeficiencyResponse extends $pb.GeneratedMessage {
  factory CloseDeficiencyResponse({
    Deficiency? deficiency,
  }) {
    final result = create();
    if (deficiency != null) result.deficiency = deficiency;
    return result;
  }

  CloseDeficiencyResponse._();

  factory CloseDeficiencyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseDeficiencyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseDeficiencyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Deficiency>(1, _omitFieldNames ? '' : 'deficiency',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDeficiencyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseDeficiencyResponse copyWith(
          void Function(CloseDeficiencyResponse) updates) =>
      super.copyWith((message) => updates(message as CloseDeficiencyResponse))
          as CloseDeficiencyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseDeficiencyResponse create() => CloseDeficiencyResponse._();
  @$core.override
  CloseDeficiencyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseDeficiencyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseDeficiencyResponse>(create);
  static CloseDeficiencyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Deficiency get deficiency => $_getN(0);
  @$pb.TagNumber(1)
  set deficiency(Deficiency value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeficiency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeficiency() => $_clearField(1);
  @$pb.TagNumber(1)
  Deficiency ensureDeficiency() => $_ensure(0);
}

/// No time window, deliberately.
class ListDeficienciesRequest extends $pb.GeneratedMessage {
  factory ListDeficienciesRequest({
    $core.String? facilityId,
    $core.String? taskId,
    Severity? severity,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (taskId != null) result.taskId = taskId;
    if (severity != null) result.severity = severity;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDeficienciesRequest._();

  factory ListDeficienciesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeficienciesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeficienciesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'taskId')
    ..aE<Severity>(3, _omitFieldNames ? '' : 'severity',
        enumValues: Severity.values)
    ..aOB(4, _omitFieldNames ? '' : 'openOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesRequest copyWith(
          void Function(ListDeficienciesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDeficienciesRequest))
          as ListDeficienciesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeficienciesRequest create() => ListDeficienciesRequest._();
  @$core.override
  ListDeficienciesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeficienciesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeficienciesRequest>(create);
  static ListDeficienciesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskId => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTaskId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskId() => $_clearField(2);

  @$pb.TagNumber(3)
  Severity get severity => $_getN(2);
  @$pb.TagNumber(3)
  set severity(Severity value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSeverity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get openOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set openOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOpenOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpenOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListDeficienciesResponse extends $pb.GeneratedMessage {
  factory ListDeficienciesResponse({
    $core.Iterable<Deficiency>? deficiencies,
  }) {
    final result = create();
    if (deficiencies != null) result.deficiencies.addAll(deficiencies);
    return result;
  }

  ListDeficienciesResponse._();

  factory ListDeficienciesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDeficienciesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDeficienciesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Deficiency>(1, _omitFieldNames ? '' : 'deficiencies',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDeficienciesResponse copyWith(
          void Function(ListDeficienciesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDeficienciesResponse))
          as ListDeficienciesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeficienciesResponse create() => ListDeficienciesResponse._();
  @$core.override
  ListDeficienciesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDeficienciesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDeficienciesResponse>(create);
  static ListDeficienciesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Deficiency> get deficiencies => $_getList(0);
}

/// SRS-FAC-008's acceptance as a call: every open critical finding,
/// unmitigated first, with no window and no cursor.
class ListOpenCriticalRequest extends $pb.GeneratedMessage {
  factory ListOpenCriticalRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListOpenCriticalRequest._();

  factory ListOpenCriticalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenCriticalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenCriticalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenCriticalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenCriticalRequest copyWith(
          void Function(ListOpenCriticalRequest) updates) =>
      super.copyWith((message) => updates(message as ListOpenCriticalRequest))
          as ListOpenCriticalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenCriticalRequest create() => ListOpenCriticalRequest._();
  @$core.override
  ListOpenCriticalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenCriticalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenCriticalRequest>(create);
  static ListOpenCriticalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class ListOpenCriticalResponse extends $pb.GeneratedMessage {
  factory ListOpenCriticalResponse({
    $core.Iterable<Deficiency>? deficiencies,
  }) {
    final result = create();
    if (deficiencies != null) result.deficiencies.addAll(deficiencies);
    return result;
  }

  ListOpenCriticalResponse._();

  factory ListOpenCriticalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOpenCriticalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOpenCriticalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Deficiency>(1, _omitFieldNames ? '' : 'deficiencies',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenCriticalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOpenCriticalResponse copyWith(
          void Function(ListOpenCriticalResponse) updates) =>
      super.copyWith((message) => updates(message as ListOpenCriticalResponse))
          as ListOpenCriticalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOpenCriticalResponse create() => ListOpenCriticalResponse._();
  @$core.override
  ListOpenCriticalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOpenCriticalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOpenCriticalResponse>(create);
  static ListOpenCriticalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Deficiency> get deficiencies => $_getList(0);
}

/// The findings that stop an inspection being signed off.
class ListBlockingRequest extends $pb.GeneratedMessage {
  factory ListBlockingRequest({
    $core.String? taskId,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    return result;
  }

  ListBlockingRequest._();

  factory ListBlockingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockingRequest copyWith(void Function(ListBlockingRequest) updates) =>
      super.copyWith((message) => updates(message as ListBlockingRequest))
          as ListBlockingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockingRequest create() => ListBlockingRequest._();
  @$core.override
  ListBlockingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockingRequest>(create);
  static ListBlockingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);
}

class ListBlockingResponse extends $pb.GeneratedMessage {
  factory ListBlockingResponse({
    $core.Iterable<Deficiency>? deficiencies,
  }) {
    final result = create();
    if (deficiencies != null) result.deficiencies.addAll(deficiencies);
    return result;
  }

  ListBlockingResponse._();

  factory ListBlockingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Deficiency>(1, _omitFieldNames ? '' : 'deficiencies',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockingResponse copyWith(void Function(ListBlockingResponse) updates) =>
      super.copyWith((message) => updates(message as ListBlockingResponse))
          as ListBlockingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockingResponse create() => ListBlockingResponse._();
  @$core.override
  ListBlockingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockingResponse>(create);
  static ListBlockingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Deficiency> get deficiencies => $_getList(0);
}

class SafetyReport extends $pb.GeneratedMessage {
  factory SafetyReport({
    $core.int? openCritical,
    $core.int? mitigated,
    $core.int? overdue,
    $core.int? closedInWindow,
    $core.int? oldestOpenDays,
    $core.Iterable<Deficiency>? findings,
  }) {
    final result = create();
    if (openCritical != null) result.openCritical = openCritical;
    if (mitigated != null) result.mitigated = mitigated;
    if (overdue != null) result.overdue = overdue;
    if (closedInWindow != null) result.closedInWindow = closedInWindow;
    if (oldestOpenDays != null) result.oldestOpenDays = oldestOpenDays;
    if (findings != null) result.findings.addAll(findings);
    return result;
  }

  SafetyReport._();

  factory SafetyReport.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SafetyReport.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SafetyReport',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'openCritical')
    ..aI(2, _omitFieldNames ? '' : 'mitigated')
    ..aI(3, _omitFieldNames ? '' : 'overdue')
    ..aI(4, _omitFieldNames ? '' : 'closedInWindow')
    ..aI(5, _omitFieldNames ? '' : 'oldestOpenDays')
    ..pPM<Deficiency>(6, _omitFieldNames ? '' : 'findings',
        subBuilder: Deficiency.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyReport clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyReport copyWith(void Function(SafetyReport) updates) =>
      super.copyWith((message) => updates(message as SafetyReport))
          as SafetyReport;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SafetyReport create() => SafetyReport._();
  @$core.override
  SafetyReport createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SafetyReport getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SafetyReport>(create);
  static SafetyReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get openCritical => $_getIZ(0);
  @$pb.TagNumber(1)
  set openCritical($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpenCritical() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpenCritical() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get mitigated => $_getIZ(1);
  @$pb.TagNumber(2)
  set mitigated($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMitigated() => $_has(1);
  @$pb.TagNumber(2)
  void clearMitigated() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get overdue => $_getIZ(2);
  @$pb.TagNumber(3)
  set overdue($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverdue() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverdue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get closedInWindow => $_getIZ(3);
  @$pb.TagNumber(4)
  set closedInWindow($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClosedInWindow() => $_has(3);
  @$pb.TagNumber(4)
  void clearClosedInWindow() => $_clearField(4);

  /// How long the oldest unclosed critical finding has been outstanding. One
  /// number a board can be shown and cannot misread.
  @$pb.TagNumber(5)
  $core.int get oldestOpenDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set oldestOpenDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOldestOpenDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearOldestOpenDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Deficiency> get findings => $_getList(5);
}

class GetSafetyReportRequest extends $pb.GeneratedMessage {
  factory GetSafetyReportRequest({
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetSafetyReportRequest._();

  factory GetSafetyReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSafetyReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSafetyReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSafetyReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSafetyReportRequest copyWith(
          void Function(GetSafetyReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetSafetyReportRequest))
          as GetSafetyReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSafetyReportRequest create() => GetSafetyReportRequest._();
  @$core.override
  GetSafetyReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSafetyReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSafetyReportRequest>(create);
  static GetSafetyReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get from => $_getN(1);
  @$pb.TagNumber(2)
  set from($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTo() => $_ensure(2);
}

class GetSafetyReportResponse extends $pb.GeneratedMessage {
  factory GetSafetyReportResponse({
    SafetyReport? report,
  }) {
    final result = create();
    if (report != null) result.report = report;
    return result;
  }

  GetSafetyReportResponse._();

  factory GetSafetyReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSafetyReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSafetyReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<SafetyReport>(1, _omitFieldNames ? '' : 'report',
        subBuilder: SafetyReport.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSafetyReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSafetyReportResponse copyWith(
          void Function(GetSafetyReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetSafetyReportResponse))
          as GetSafetyReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSafetyReportResponse create() => GetSafetyReportResponse._();
  @$core.override
  GetSafetyReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSafetyReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSafetyReportResponse>(create);
  static GetSafetyReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SafetyReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(SafetyReport value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  SafetyReport ensureReport() => $_ensure(0);
}

/// One measuring point (SRS-FAC-009).
class Meter extends $pb.GeneratedMessage {
  factory Meter({
    $core.String? meterId,
    $core.String? code,
    $core.String? name,
    Utility? utility,
    $core.String? unit,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? assetId,
    Source? source,
    $core.String? sourceRef,
    $core.bool? cumulative,
    $core.int? registerMax,
    $core.bool? active,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (meterId != null) result.meterId = meterId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (utility != null) result.utility = utility;
    if (unit != null) result.unit = unit;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (assetId != null) result.assetId = assetId;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (cumulative != null) result.cumulative = cumulative;
    if (registerMax != null) result.registerMax = registerMax;
    if (active != null) result.active = active;
    if (version != null) result.version = version;
    return result;
  }

  Meter._();

  factory Meter.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Meter.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Meter',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meterId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<Utility>(4, _omitFieldNames ? '' : 'utility',
        enumValues: Utility.values)
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'locationId')
    ..aOS(8, _omitFieldNames ? '' : 'assetId')
    ..aE<Source>(9, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(10, _omitFieldNames ? '' : 'sourceRef')
    ..aOB(11, _omitFieldNames ? '' : 'cumulative')
    ..aI(12, _omitFieldNames ? '' : 'registerMax')
    ..aOB(13, _omitFieldNames ? '' : 'active')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Meter clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Meter copyWith(void Function(Meter) updates) =>
      super.copyWith((message) => updates(message as Meter)) as Meter;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Meter create() => Meter._();
  @$core.override
  Meter createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Meter getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Meter>(create);
  static Meter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  Utility get utility => $_getN(3);
  @$pb.TagNumber(4)
  set utility(Utility value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUtility() => $_has(3);
  @$pb.TagNumber(4)
  void clearUtility() => $_clearField(4);

  /// The unit every reading on this meter is in. Readings are integers in this
  /// unit; a meter that reads in fractions declares a finer unit.
  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get locationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set locationId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLocationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocationId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get assetId => $_getSZ(7);
  @$pb.TagNumber(8)
  set assetId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAssetId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssetId() => $_clearField(8);

  /// How this meter is normally read. A reading may declare a different one.
  @$pb.TagNumber(9)
  Source get source => $_getN(8);
  @$pb.TagNumber(9)
  set source(Source value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasSource() => $_has(8);
  @$pb.TagNumber(9)
  void clearSource() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourceRef => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourceRef($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSourceRef() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceRef() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get cumulative => $_getBF(10);
  @$pb.TagNumber(11)
  set cumulative($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCumulative() => $_has(10);
  @$pb.TagNumber(11)
  void clearCumulative() => $_clearField(11);

  /// Where a cumulative register wraps back to zero. Zero means it does not.
  @$pb.TagNumber(12)
  $core.int get registerMax => $_getIZ(11);
  @$pb.TagNumber(12)
  set registerMax($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRegisterMax() => $_has(11);
  @$pb.TagNumber(12)
  void clearRegisterMax() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.bool get active => $_getBF(12);
  @$pb.TagNumber(13)
  set active($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasActive() => $_has(12);
  @$pb.TagNumber(13)
  void clearActive() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One meter reading (SRS-FAC-009).
class Reading extends $pb.GeneratedMessage {
  factory Reading({
    $core.String? readingId,
    $core.String? meterId,
    $core.int? value,
    $0.Timestamp? readAt,
    Source? source,
    $core.String? sourceRef,
    $core.String? recordedBy,
    $core.bool? rolledOver,
    $core.String? note,
  }) {
    final result = create();
    if (readingId != null) result.readingId = readingId;
    if (meterId != null) result.meterId = meterId;
    if (value != null) result.value = value;
    if (readAt != null) result.readAt = readAt;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (rolledOver != null) result.rolledOver = rolledOver;
    if (note != null) result.note = note;
    return result;
  }

  Reading._();

  factory Reading.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Reading.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Reading',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOS(2, _omitFieldNames ? '' : 'meterId')
    ..aI(3, _omitFieldNames ? '' : 'value')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'readAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Source>(5, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(6, _omitFieldNames ? '' : 'sourceRef')
    ..aOS(7, _omitFieldNames ? '' : 'recordedBy')
    ..aOB(8, _omitFieldNames ? '' : 'rolledOver')
    ..aOS(9, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reading clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Reading copyWith(void Function(Reading) updates) =>
      super.copyWith((message) => updates(message as Reading)) as Reading;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Reading create() => Reading._();
  @$core.override
  Reading createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Reading getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reading>(create);
  static Reading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get readingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set readingId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReadingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get meterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set meterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMeterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMeterId() => $_clearField(2);

  /// In the meter's declared unit.
  @$pb.TagNumber(3)
  $core.int get value => $_getIZ(2);
  @$pb.TagNumber(3)
  set value($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get readAt => $_getN(3);
  @$pb.TagNumber(4)
  set readAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasReadAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearReadAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureReadAt() => $_ensure(3);

  /// This reading's provenance, which may differ from the meter's.
  @$pb.TagNumber(5)
  Source get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(Source value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceRef => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceRef($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceRef() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceRef() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get recordedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set recordedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecordedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecordedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get rolledOver => $_getBF(7);
  @$pb.TagNumber(8)
  set rolledOver($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRolledOver() => $_has(7);
  @$pb.TagNumber(8)
  void clearRolledOver() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get note => $_getSZ(8);
  @$pb.TagNumber(9)
  set note($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearNote() => $_clearField(9);
}

class AddMeterRequest extends $pb.GeneratedMessage {
  factory AddMeterRequest({
    $core.String? code,
    $core.String? name,
    Utility? utility,
    $core.String? unit,
    $core.String? facilityId,
    $core.String? locationId,
    $core.String? assetId,
    Source? source,
    $core.String? sourceRef,
    $core.bool? cumulative,
    $core.int? registerMax,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (utility != null) result.utility = utility;
    if (unit != null) result.unit = unit;
    if (facilityId != null) result.facilityId = facilityId;
    if (locationId != null) result.locationId = locationId;
    if (assetId != null) result.assetId = assetId;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (cumulative != null) result.cumulative = cumulative;
    if (registerMax != null) result.registerMax = registerMax;
    return result;
  }

  AddMeterRequest._();

  factory AddMeterRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMeterRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMeterRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<Utility>(3, _omitFieldNames ? '' : 'utility',
        enumValues: Utility.values)
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'locationId')
    ..aOS(7, _omitFieldNames ? '' : 'assetId')
    ..aE<Source>(8, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(9, _omitFieldNames ? '' : 'sourceRef')
    ..aOB(10, _omitFieldNames ? '' : 'cumulative')
    ..aI(11, _omitFieldNames ? '' : 'registerMax')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMeterRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMeterRequest copyWith(void Function(AddMeterRequest) updates) =>
      super.copyWith((message) => updates(message as AddMeterRequest))
          as AddMeterRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMeterRequest create() => AddMeterRequest._();
  @$core.override
  AddMeterRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMeterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMeterRequest>(create);
  static AddMeterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  Utility get utility => $_getN(2);
  @$pb.TagNumber(3)
  set utility(Utility value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUtility() => $_has(2);
  @$pb.TagNumber(3)
  void clearUtility() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get assetId => $_getSZ(6);
  @$pb.TagNumber(7)
  set assetId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAssetId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssetId() => $_clearField(7);

  @$pb.TagNumber(8)
  Source get source => $_getN(7);
  @$pb.TagNumber(8)
  set source(Source value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get sourceRef => $_getSZ(8);
  @$pb.TagNumber(9)
  set sourceRef($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSourceRef() => $_has(8);
  @$pb.TagNumber(9)
  void clearSourceRef() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get cumulative => $_getBF(9);
  @$pb.TagNumber(10)
  set cumulative($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCumulative() => $_has(9);
  @$pb.TagNumber(10)
  void clearCumulative() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get registerMax => $_getIZ(10);
  @$pb.TagNumber(11)
  set registerMax($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRegisterMax() => $_has(10);
  @$pb.TagNumber(11)
  void clearRegisterMax() => $_clearField(11);
}

class AddMeterResponse extends $pb.GeneratedMessage {
  factory AddMeterResponse({
    Meter? meter,
  }) {
    final result = create();
    if (meter != null) result.meter = meter;
    return result;
  }

  AddMeterResponse._();

  factory AddMeterResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddMeterResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddMeterResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Meter>(1, _omitFieldNames ? '' : 'meter', subBuilder: Meter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMeterResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddMeterResponse copyWith(void Function(AddMeterResponse) updates) =>
      super.copyWith((message) => updates(message as AddMeterResponse))
          as AddMeterResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddMeterResponse create() => AddMeterResponse._();
  @$core.override
  AddMeterResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddMeterResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddMeterResponse>(create);
  static AddMeterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Meter get meter => $_getN(0);
  @$pb.TagNumber(1)
  set meter(Meter value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMeter() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeter() => $_clearField(1);
  @$pb.TagNumber(1)
  Meter ensureMeter() => $_ensure(0);
}

class RecordMeterReadingRequest extends $pb.GeneratedMessage {
  factory RecordMeterReadingRequest({
    $core.String? meterId,
    $core.int? value,
    $0.Timestamp? readAt,
    Source? source,
    $core.String? sourceRef,
    $core.bool? rolledOver,
    $core.String? note,
  }) {
    final result = create();
    if (meterId != null) result.meterId = meterId;
    if (value != null) result.value = value;
    if (readAt != null) result.readAt = readAt;
    if (source != null) result.source = source;
    if (sourceRef != null) result.sourceRef = sourceRef;
    if (rolledOver != null) result.rolledOver = rolledOver;
    if (note != null) result.note = note;
    return result;
  }

  RecordMeterReadingRequest._();

  factory RecordMeterReadingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMeterReadingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMeterReadingRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meterId')
    ..aI(2, _omitFieldNames ? '' : 'value')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'readAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Source>(4, _omitFieldNames ? '' : 'source', enumValues: Source.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourceRef')
    ..aOB(6, _omitFieldNames ? '' : 'rolledOver')
    ..aOS(7, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMeterReadingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMeterReadingRequest copyWith(
          void Function(RecordMeterReadingRequest) updates) =>
      super.copyWith((message) => updates(message as RecordMeterReadingRequest))
          as RecordMeterReadingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMeterReadingRequest create() => RecordMeterReadingRequest._();
  @$core.override
  RecordMeterReadingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMeterReadingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMeterReadingRequest>(create);
  static RecordMeterReadingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get value => $_getIZ(1);
  @$pb.TagNumber(2)
  set value($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get readAt => $_getN(2);
  @$pb.TagNumber(3)
  set readAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReadAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReadAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureReadAt() => $_ensure(2);

  /// Left unspecified, the meter's usual source is used.
  @$pb.TagNumber(4)
  Source get source => $_getN(3);
  @$pb.TagNumber(4)
  set source(Source value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get rolledOver => $_getBF(5);
  @$pb.TagNumber(6)
  set rolledOver($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRolledOver() => $_has(5);
  @$pb.TagNumber(6)
  void clearRolledOver() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get note => $_getSZ(6);
  @$pb.TagNumber(7)
  set note($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearNote() => $_clearField(7);
}

class RecordMeterReadingResponse extends $pb.GeneratedMessage {
  factory RecordMeterReadingResponse({
    Reading? reading,
  }) {
    final result = create();
    if (reading != null) result.reading = reading;
    return result;
  }

  RecordMeterReadingResponse._();

  factory RecordMeterReadingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordMeterReadingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordMeterReadingResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Reading>(1, _omitFieldNames ? '' : 'reading',
        subBuilder: Reading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMeterReadingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordMeterReadingResponse copyWith(
          void Function(RecordMeterReadingResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RecordMeterReadingResponse))
          as RecordMeterReadingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordMeterReadingResponse create() => RecordMeterReadingResponse._();
  @$core.override
  RecordMeterReadingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordMeterReadingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordMeterReadingResponse>(create);
  static RecordMeterReadingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Reading get reading => $_getN(0);
  @$pb.TagNumber(1)
  set reading(Reading value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReading() => $_has(0);
  @$pb.TagNumber(1)
  void clearReading() => $_clearField(1);
  @$pb.TagNumber(1)
  Reading ensureReading() => $_ensure(0);
}

class ListMetersRequest extends $pb.GeneratedMessage {
  factory ListMetersRequest({
    $core.String? facilityId,
    Utility? utility,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (utility != null) result.utility = utility;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListMetersRequest._();

  factory ListMetersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMetersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMetersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aE<Utility>(2, _omitFieldNames ? '' : 'utility',
        enumValues: Utility.values)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetersRequest copyWith(void Function(ListMetersRequest) updates) =>
      super.copyWith((message) => updates(message as ListMetersRequest))
          as ListMetersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMetersRequest create() => ListMetersRequest._();
  @$core.override
  ListMetersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMetersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMetersRequest>(create);
  static ListMetersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  Utility get utility => $_getN(1);
  @$pb.TagNumber(2)
  set utility(Utility value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUtility() => $_has(1);
  @$pb.TagNumber(2)
  void clearUtility() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListMetersResponse extends $pb.GeneratedMessage {
  factory ListMetersResponse({
    $core.Iterable<Meter>? meters,
  }) {
    final result = create();
    if (meters != null) result.meters.addAll(meters);
    return result;
  }

  ListMetersResponse._();

  factory ListMetersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMetersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMetersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Meter>(1, _omitFieldNames ? '' : 'meters', subBuilder: Meter.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMetersResponse copyWith(void Function(ListMetersResponse) updates) =>
      super.copyWith((message) => updates(message as ListMetersResponse))
          as ListMetersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMetersResponse create() => ListMetersResponse._();
  @$core.override
  ListMetersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMetersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMetersResponse>(create);
  static ListMetersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Meter> get meters => $_getList(0);
}

/// What a meter recorded over a window, with its provenance (SRS-FAC-009).
class Consumption extends $pb.GeneratedMessage {
  factory Consumption({
    $core.String? meterId,
    Utility? utility,
    $core.String? unit,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? quantity,
    $core.int? readings,
    $core.Iterable<Source>? sources,
    $core.bool? estimated,
    $core.int? rollovers,
  }) {
    final result = create();
    if (meterId != null) result.meterId = meterId;
    if (utility != null) result.utility = utility;
    if (unit != null) result.unit = unit;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (quantity != null) result.quantity = quantity;
    if (readings != null) result.readings = readings;
    if (sources != null) result.sources.addAll(sources);
    if (estimated != null) result.estimated = estimated;
    if (rollovers != null) result.rollovers = rollovers;
    return result;
  }

  Consumption._();

  factory Consumption.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Consumption.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Consumption',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meterId')
    ..aE<Utility>(2, _omitFieldNames ? '' : 'utility',
        enumValues: Utility.values)
    ..aOS(3, _omitFieldNames ? '' : 'unit')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aI(7, _omitFieldNames ? '' : 'readings')
    ..pc<Source>(8, _omitFieldNames ? '' : 'sources', $pb.PbFieldType.KE,
        valueOf: Source.valueOf,
        enumValues: Source.values,
        defaultEnumValue: Source.SOURCE_UNSPECIFIED)
    ..aOB(9, _omitFieldNames ? '' : 'estimated')
    ..aI(10, _omitFieldNames ? '' : 'rollovers')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Consumption clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Consumption copyWith(void Function(Consumption) updates) =>
      super.copyWith((message) => updates(message as Consumption))
          as Consumption;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Consumption create() => Consumption._();
  @$core.override
  Consumption createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Consumption getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Consumption>(create);
  static Consumption? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeterId() => $_clearField(1);

  @$pb.TagNumber(2)
  Utility get utility => $_getN(1);
  @$pb.TagNumber(2)
  set utility(Utility value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUtility() => $_has(1);
  @$pb.TagNumber(2)
  void clearUtility() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unit => $_getSZ(2);
  @$pb.TagNumber(3)
  set unit($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnit() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnit() => $_clearField(3);

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
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  /// How many readings the figure rests on. A month's consumption from two
  /// readings is an average, not a series.
  @$pb.TagNumber(7)
  $core.int get readings => $_getIZ(6);
  @$pb.TagNumber(7)
  set readings($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReadings() => $_has(6);
  @$pb.TagNumber(7)
  void clearReadings() => $_clearField(7);

  /// The distinct provenances that contributed.
  @$pb.TagNumber(8)
  $pb.PbList<Source> get sources => $_getList(7);

  /// Set when any contributing reading was typed or derived rather than
  /// measured.
  @$pb.TagNumber(9)
  $core.bool get estimated => $_getBF(8);
  @$pb.TagNumber(9)
  set estimated($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasEstimated() => $_has(8);
  @$pb.TagNumber(9)
  void clearEstimated() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get rollovers => $_getIZ(9);
  @$pb.TagNumber(10)
  set rollovers($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRollovers() => $_has(9);
  @$pb.TagNumber(10)
  void clearRollovers() => $_clearField(10);
}

class GetConsumptionRequest extends $pb.GeneratedMessage {
  factory GetConsumptionRequest({
    $core.String? meterId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (meterId != null) result.meterId = meterId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetConsumptionRequest._();

  factory GetConsumptionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetConsumptionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConsumptionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'meterId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConsumptionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConsumptionRequest copyWith(
          void Function(GetConsumptionRequest) updates) =>
      super.copyWith((message) => updates(message as GetConsumptionRequest))
          as GetConsumptionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConsumptionRequest create() => GetConsumptionRequest._();
  @$core.override
  GetConsumptionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetConsumptionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConsumptionRequest>(create);
  static GetConsumptionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get meterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set meterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMeterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMeterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get from => $_getN(1);
  @$pb.TagNumber(2)
  set from($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTo() => $_ensure(2);
}

class GetConsumptionResponse extends $pb.GeneratedMessage {
  factory GetConsumptionResponse({
    Consumption? consumption,
    $core.bool? available,
  }) {
    final result = create();
    if (consumption != null) result.consumption = consumption;
    if (available != null) result.available = available;
    return result;
  }

  GetConsumptionResponse._();

  factory GetConsumptionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetConsumptionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetConsumptionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Consumption>(1, _omitFieldNames ? '' : 'consumption',
        subBuilder: Consumption.create)
    ..aOB(2, _omitFieldNames ? '' : 'available')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConsumptionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetConsumptionResponse copyWith(
          void Function(GetConsumptionResponse) updates) =>
      super.copyWith((message) => updates(message as GetConsumptionResponse))
          as GetConsumptionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetConsumptionResponse create() => GetConsumptionResponse._();
  @$core.override
  GetConsumptionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetConsumptionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetConsumptionResponse>(create);
  static GetConsumptionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Consumption get consumption => $_getN(0);
  @$pb.TagNumber(1)
  set consumption(Consumption value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasConsumption() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsumption() => $_clearField(1);
  @$pb.TagNumber(1)
  Consumption ensureConsumption() => $_ensure(0);

  /// False when the series could not produce a trustworthy figure — one
  /// reading of a counting register, or a counter that went backwards without
  /// declaring a rollover.
  @$pb.TagNumber(2)
  $core.bool get available => $_getBF(1);
  @$pb.TagNumber(2)
  set available($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAvailable() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailable() => $_clearField(2);
}

/// How long a system was unavailable (SRS-FAC-009).
class Downtime extends $pb.GeneratedMessage {
  factory Downtime({
    System? system,
    $core.int? minutes,
    $core.int? incidents,
    $core.Iterable<$core.String>? workOrderIds,
    $core.int? unmeasured,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (minutes != null) result.minutes = minutes;
    if (incidents != null) result.incidents = incidents;
    if (workOrderIds != null) result.workOrderIds.addAll(workOrderIds);
    if (unmeasured != null) result.unmeasured = unmeasured;
    return result;
  }

  Downtime._();

  factory Downtime.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Downtime.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Downtime',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aE<System>(1, _omitFieldNames ? '' : 'system', enumValues: System.values)
    ..aI(2, _omitFieldNames ? '' : 'minutes')
    ..aI(3, _omitFieldNames ? '' : 'incidents')
    ..pPS(4, _omitFieldNames ? '' : 'workOrderIds')
    ..aI(5, _omitFieldNames ? '' : 'unmeasured')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Downtime clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Downtime copyWith(void Function(Downtime) updates) =>
      super.copyWith((message) => updates(message as Downtime)) as Downtime;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Downtime create() => Downtime._();
  @$core.override
  Downtime createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Downtime getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Downtime>(create);
  static Downtime? _defaultInstance;

  @$pb.TagNumber(1)
  System get system => $_getN(0);
  @$pb.TagNumber(1)
  set system(System value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minutes => $_getIZ(1);
  @$pb.TagNumber(2)
  set minutes($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinutes() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinutes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get incidents => $_getIZ(2);
  @$pb.TagNumber(3)
  set incidents($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIncidents() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncidents() => $_clearField(3);

  /// The provenance. A downtime KPI with no way back to the incidents cannot
  /// be investigated.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get workOrderIds => $_getList(3);

  /// Closed orders on down assets that recorded no downtime, so a
  /// suspiciously low figure declares its own gap.
  @$pb.TagNumber(5)
  $core.int get unmeasured => $_getIZ(4);
  @$pb.TagNumber(5)
  set unmeasured($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnmeasured() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnmeasured() => $_clearField(5);
}

class GetDowntimeRequest extends $pb.GeneratedMessage {
  factory GetDowntimeRequest({
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetDowntimeRequest._();

  factory GetDowntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDowntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDowntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDowntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDowntimeRequest copyWith(void Function(GetDowntimeRequest) updates) =>
      super.copyWith((message) => updates(message as GetDowntimeRequest))
          as GetDowntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDowntimeRequest create() => GetDowntimeRequest._();
  @$core.override
  GetDowntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDowntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDowntimeRequest>(create);
  static GetDowntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get from => $_getN(1);
  @$pb.TagNumber(2)
  set from($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureFrom() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get to => $_getN(2);
  @$pb.TagNumber(3)
  set to($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearTo() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTo() => $_ensure(2);
}

class GetDowntimeResponse extends $pb.GeneratedMessage {
  factory GetDowntimeResponse({
    $core.Iterable<Downtime>? downtime,
  }) {
    final result = create();
    if (downtime != null) result.downtime.addAll(downtime);
    return result;
  }

  GetDowntimeResponse._();

  factory GetDowntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDowntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDowntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Downtime>(1, _omitFieldNames ? '' : 'downtime',
        subBuilder: Downtime.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDowntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDowntimeResponse copyWith(void Function(GetDowntimeResponse) updates) =>
      super.copyWith((message) => updates(message as GetDowntimeResponse))
          as GetDowntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDowntimeResponse create() => GetDowntimeResponse._();
  @$core.override
  GetDowntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDowntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDowntimeResponse>(create);
  static GetDowntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Downtime> get downtime => $_getList(0);
}

class SLAPerformance extends $pb.GeneratedMessage {
  factory SLAPerformance({
    $core.int? open,
    $core.int? responseBreaches,
    $core.int? resolutionBreaches,
    $core.Iterable<WorkOrder>? worstOpen,
  }) {
    final result = create();
    if (open != null) result.open = open;
    if (responseBreaches != null) result.responseBreaches = responseBreaches;
    if (resolutionBreaches != null)
      result.resolutionBreaches = resolutionBreaches;
    if (worstOpen != null) result.worstOpen.addAll(worstOpen);
    return result;
  }

  SLAPerformance._();

  factory SLAPerformance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SLAPerformance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SLAPerformance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'open')
    ..aI(2, _omitFieldNames ? '' : 'responseBreaches')
    ..aI(3, _omitFieldNames ? '' : 'resolutionBreaches')
    ..pPM<WorkOrder>(4, _omitFieldNames ? '' : 'worstOpen',
        subBuilder: WorkOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SLAPerformance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SLAPerformance copyWith(void Function(SLAPerformance) updates) =>
      super.copyWith((message) => updates(message as SLAPerformance))
          as SLAPerformance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SLAPerformance create() => SLAPerformance._();
  @$core.override
  SLAPerformance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SLAPerformance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SLAPerformance>(create);
  static SLAPerformance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get open => $_getIZ(0);
  @$pb.TagNumber(1)
  set open($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpen() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpen() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get responseBreaches => $_getIZ(1);
  @$pb.TagNumber(2)
  set responseBreaches($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResponseBreaches() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponseBreaches() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get resolutionBreaches => $_getIZ(2);
  @$pb.TagNumber(3)
  set resolutionBreaches($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolutionBreaches() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionBreaches() => $_clearField(3);

  /// The open work furthest past its target, which is what somebody should
  /// look at rather than a percentage nobody acts on.
  @$pb.TagNumber(4)
  $pb.PbList<WorkOrder> get worstOpen => $_getList(3);
}

class GetPerformanceRequest extends $pb.GeneratedMessage {
  factory GetPerformanceRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  GetPerformanceRequest._();

  factory GetPerformanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPerformanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPerformanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerformanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerformanceRequest copyWith(
          void Function(GetPerformanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetPerformanceRequest))
          as GetPerformanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPerformanceRequest create() => GetPerformanceRequest._();
  @$core.override
  GetPerformanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPerformanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPerformanceRequest>(create);
  static GetPerformanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class GetPerformanceResponse extends $pb.GeneratedMessage {
  factory GetPerformanceResponse({
    SLAPerformance? performance,
  }) {
    final result = create();
    if (performance != null) result.performance = performance;
    return result;
  }

  GetPerformanceResponse._();

  factory GetPerformanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPerformanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPerformanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<SLAPerformance>(1, _omitFieldNames ? '' : 'performance',
        subBuilder: SLAPerformance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerformanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPerformanceResponse copyWith(
          void Function(GetPerformanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetPerformanceResponse))
          as GetPerformanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPerformanceResponse create() => GetPerformanceResponse._();
  @$core.override
  GetPerformanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPerformanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPerformanceResponse>(create);
  static GetPerformanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SLAPerformance get performance => $_getN(0);
  @$pb.TagNumber(1)
  set performance(SLAPerformance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPerformance() => $_has(0);
  @$pb.TagNumber(1)
  void clearPerformance() => $_clearField(1);
  @$pb.TagNumber(1)
  SLAPerformance ensurePerformance() => $_ensure(0);
}

/// A contractor attendance (SRS-FAC-011).
class Visit extends $pb.GeneratedMessage {
  factory Visit({
    $core.String? visitId,
    $core.String? vendorName,
    $core.String? vendorRef,
    $core.String? contactName,
    $core.Iterable<$core.String>? technicians,
    $core.String? facilityId,
    $core.String? workOrderId,
    $core.String? assetId,
    $core.String? taskId,
    $core.bool? workRequiresPermit,
    $core.String? inductionRef,
    $core.String? purpose,
    VisitState? state,
    $0.Timestamp? signedInAt,
    $core.String? signedInBy,
    $0.Timestamp? signedOutAt,
    $core.String? signedOutBy,
    $core.String? serviceReportRef,
    $core.String? reportSummary,
    $core.Iterable<$core.String>? partsUsed,
    $core.String? followUp,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (vendorName != null) result.vendorName = vendorName;
    if (vendorRef != null) result.vendorRef = vendorRef;
    if (contactName != null) result.contactName = contactName;
    if (technicians != null) result.technicians.addAll(technicians);
    if (facilityId != null) result.facilityId = facilityId;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (assetId != null) result.assetId = assetId;
    if (taskId != null) result.taskId = taskId;
    if (workRequiresPermit != null)
      result.workRequiresPermit = workRequiresPermit;
    if (inductionRef != null) result.inductionRef = inductionRef;
    if (purpose != null) result.purpose = purpose;
    if (state != null) result.state = state;
    if (signedInAt != null) result.signedInAt = signedInAt;
    if (signedInBy != null) result.signedInBy = signedInBy;
    if (signedOutAt != null) result.signedOutAt = signedOutAt;
    if (signedOutBy != null) result.signedOutBy = signedOutBy;
    if (serviceReportRef != null) result.serviceReportRef = serviceReportRef;
    if (reportSummary != null) result.reportSummary = reportSummary;
    if (partsUsed != null) result.partsUsed.addAll(partsUsed);
    if (followUp != null) result.followUp = followUp;
    if (version != null) result.version = version;
    return result;
  }

  Visit._();

  factory Visit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Visit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Visit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'vendorName')
    ..aOS(3, _omitFieldNames ? '' : 'vendorRef')
    ..aOS(4, _omitFieldNames ? '' : 'contactName')
    ..pPS(5, _omitFieldNames ? '' : 'technicians')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aOS(7, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(8, _omitFieldNames ? '' : 'assetId')
    ..aOS(9, _omitFieldNames ? '' : 'taskId')
    ..aOB(10, _omitFieldNames ? '' : 'workRequiresPermit')
    ..aOS(11, _omitFieldNames ? '' : 'inductionRef')
    ..aOS(12, _omitFieldNames ? '' : 'purpose')
    ..aE<VisitState>(13, _omitFieldNames ? '' : 'state',
        enumValues: VisitState.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'signedInAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'signedInBy')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'signedOutAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'signedOutBy')
    ..aOS(18, _omitFieldNames ? '' : 'serviceReportRef')
    ..aOS(19, _omitFieldNames ? '' : 'reportSummary')
    ..pPS(20, _omitFieldNames ? '' : 'partsUsed')
    ..aOS(21, _omitFieldNames ? '' : 'followUp')
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Visit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Visit copyWith(void Function(Visit) updates) =>
      super.copyWith((message) => updates(message as Visit)) as Visit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Visit create() => Visit._();
  @$core.override
  Visit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Visit getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Visit>(create);
  static Visit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vendorName => $_getSZ(1);
  @$pb.TagNumber(2)
  set vendorName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVendorName() => $_has(1);
  @$pb.TagNumber(2)
  void clearVendorName() => $_clearField(2);

  /// The contract or purchase order this visit is under.
  @$pb.TagNumber(3)
  $core.String get vendorRef => $_getSZ(2);
  @$pb.TagNumber(3)
  set vendorRef($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVendorRef() => $_has(2);
  @$pb.TagNumber(3)
  void clearVendorRef() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contactName => $_getSZ(3);
  @$pb.TagNumber(4)
  set contactName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactName() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactName() => $_clearField(4);

  /// The people who actually came. Names rather than accounts: a contractor's
  /// engineer has no login here.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get technicians => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  /// At least one of the three. A visit against nothing is a visitor log
  /// entry, which is a different system's problem.
  @$pb.TagNumber(7)
  $core.String get workOrderId => $_getSZ(6);
  @$pb.TagNumber(7)
  set workOrderId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWorkOrderId() => $_has(6);
  @$pb.TagNumber(7)
  void clearWorkOrderId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get assetId => $_getSZ(7);
  @$pb.TagNumber(8)
  set assetId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAssetId() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssetId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get taskId => $_getSZ(8);
  @$pb.TagNumber(9)
  set taskId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTaskId() => $_has(8);
  @$pb.TagNumber(9)
  void clearTaskId() => $_clearField(9);

  /// Read from the work order rather than taken from the caller: a contractor
  /// asked at the gate whether their work needs a permit will say no.
  @$pb.TagNumber(10)
  $core.bool get workRequiresPermit => $_getBF(9);
  @$pb.TagNumber(10)
  set workRequiresPermit($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWorkRequiresPermit() => $_has(9);
  @$pb.TagNumber(10)
  void clearWorkRequiresPermit() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get inductionRef => $_getSZ(10);
  @$pb.TagNumber(11)
  set inductionRef($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasInductionRef() => $_has(10);
  @$pb.TagNumber(11)
  void clearInductionRef() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get purpose => $_getSZ(11);
  @$pb.TagNumber(12)
  set purpose($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPurpose() => $_has(11);
  @$pb.TagNumber(12)
  void clearPurpose() => $_clearField(12);

  @$pb.TagNumber(13)
  VisitState get state => $_getN(12);
  @$pb.TagNumber(13)
  set state(VisitState value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasState() => $_has(12);
  @$pb.TagNumber(13)
  void clearState() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get signedInAt => $_getN(13);
  @$pb.TagNumber(14)
  set signedInAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasSignedInAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearSignedInAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureSignedInAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get signedInBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set signedInBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSignedInBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearSignedInBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get signedOutAt => $_getN(15);
  @$pb.TagNumber(16)
  set signedOutAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSignedOutAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearSignedOutAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureSignedOutAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get signedOutBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set signedOutBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSignedOutBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearSignedOutBy() => $_clearField(17);

  /// Required to sign out. The reference points at a PDF nobody will open; the
  /// summary is what appears in the asset's history.
  @$pb.TagNumber(18)
  $core.String get serviceReportRef => $_getSZ(17);
  @$pb.TagNumber(18)
  set serviceReportRef($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasServiceReportRef() => $_has(17);
  @$pb.TagNumber(18)
  void clearServiceReportRef() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get reportSummary => $_getSZ(18);
  @$pb.TagNumber(19)
  set reportSummary($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasReportSummary() => $_has(18);
  @$pb.TagNumber(19)
  void clearReportSummary() => $_clearField(19);

  @$pb.TagNumber(20)
  $pb.PbList<$core.String> get partsUsed => $_getList(19);

  /// Work the contractor says is still needed. Captured because it is
  /// otherwise said out loud in a corridor and lost.
  @$pb.TagNumber(21)
  $core.String get followUp => $_getSZ(20);
  @$pb.TagNumber(21)
  set followUp($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasFollowUp() => $_has(20);
  @$pb.TagNumber(21)
  void clearFollowUp() => $_clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(22)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(22)
  void clearVersion() => $_clearField(22);
}

class SignInVendorRequest extends $pb.GeneratedMessage {
  factory SignInVendorRequest({
    $core.String? vendorName,
    $core.String? vendorRef,
    $core.String? contactName,
    $core.Iterable<$core.String>? technicians,
    $core.String? facilityId,
    $core.String? workOrderId,
    $core.String? assetId,
    $core.String? taskId,
    $core.String? inductionRef,
    $core.String? purpose,
  }) {
    final result = create();
    if (vendorName != null) result.vendorName = vendorName;
    if (vendorRef != null) result.vendorRef = vendorRef;
    if (contactName != null) result.contactName = contactName;
    if (technicians != null) result.technicians.addAll(technicians);
    if (facilityId != null) result.facilityId = facilityId;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (assetId != null) result.assetId = assetId;
    if (taskId != null) result.taskId = taskId;
    if (inductionRef != null) result.inductionRef = inductionRef;
    if (purpose != null) result.purpose = purpose;
    return result;
  }

  SignInVendorRequest._();

  factory SignInVendorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignInVendorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignInVendorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'vendorName')
    ..aOS(2, _omitFieldNames ? '' : 'vendorRef')
    ..aOS(3, _omitFieldNames ? '' : 'contactName')
    ..pPS(4, _omitFieldNames ? '' : 'technicians')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(7, _omitFieldNames ? '' : 'assetId')
    ..aOS(8, _omitFieldNames ? '' : 'taskId')
    ..aOS(9, _omitFieldNames ? '' : 'inductionRef')
    ..aOS(10, _omitFieldNames ? '' : 'purpose')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInVendorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInVendorRequest copyWith(void Function(SignInVendorRequest) updates) =>
      super.copyWith((message) => updates(message as SignInVendorRequest))
          as SignInVendorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignInVendorRequest create() => SignInVendorRequest._();
  @$core.override
  SignInVendorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignInVendorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignInVendorRequest>(create);
  static SignInVendorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get vendorName => $_getSZ(0);
  @$pb.TagNumber(1)
  set vendorName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVendorName() => $_has(0);
  @$pb.TagNumber(1)
  void clearVendorName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get vendorRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set vendorRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVendorRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearVendorRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contactName => $_getSZ(2);
  @$pb.TagNumber(3)
  set contactName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContactName() => $_has(2);
  @$pb.TagNumber(3)
  void clearContactName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get technicians => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get workOrderId => $_getSZ(5);
  @$pb.TagNumber(6)
  set workOrderId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWorkOrderId() => $_has(5);
  @$pb.TagNumber(6)
  void clearWorkOrderId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get assetId => $_getSZ(6);
  @$pb.TagNumber(7)
  set assetId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasAssetId() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssetId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get taskId => $_getSZ(7);
  @$pb.TagNumber(8)
  set taskId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTaskId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTaskId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get inductionRef => $_getSZ(8);
  @$pb.TagNumber(9)
  set inductionRef($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInductionRef() => $_has(8);
  @$pb.TagNumber(9)
  void clearInductionRef() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get purpose => $_getSZ(9);
  @$pb.TagNumber(10)
  set purpose($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPurpose() => $_has(9);
  @$pb.TagNumber(10)
  void clearPurpose() => $_clearField(10);
}

class SignInVendorResponse extends $pb.GeneratedMessage {
  factory SignInVendorResponse({
    Visit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  SignInVendorResponse._();

  factory SignInVendorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignInVendorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignInVendorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Visit>(1, _omitFieldNames ? '' : 'visit', subBuilder: Visit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInVendorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignInVendorResponse copyWith(void Function(SignInVendorResponse) updates) =>
      super.copyWith((message) => updates(message as SignInVendorResponse))
          as SignInVendorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignInVendorResponse create() => SignInVendorResponse._();
  @$core.override
  SignInVendorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignInVendorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignInVendorResponse>(create);
  static SignInVendorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Visit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(Visit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  Visit ensureVisit() => $_ensure(0);
}

class SignOutVendorRequest extends $pb.GeneratedMessage {
  factory SignOutVendorRequest({
    $core.String? visitId,
    $core.String? serviceReportRef,
    $core.String? reportSummary,
    $core.Iterable<$core.String>? partsUsed,
    $core.String? followUp,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (visitId != null) result.visitId = visitId;
    if (serviceReportRef != null) result.serviceReportRef = serviceReportRef;
    if (reportSummary != null) result.reportSummary = reportSummary;
    if (partsUsed != null) result.partsUsed.addAll(partsUsed);
    if (followUp != null) result.followUp = followUp;
    if (version != null) result.version = version;
    return result;
  }

  SignOutVendorRequest._();

  factory SignOutVendorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOutVendorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOutVendorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'visitId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceReportRef')
    ..aOS(3, _omitFieldNames ? '' : 'reportSummary')
    ..pPS(4, _omitFieldNames ? '' : 'partsUsed')
    ..aOS(5, _omitFieldNames ? '' : 'followUp')
    ..aInt64(6, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutVendorRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutVendorRequest copyWith(void Function(SignOutVendorRequest) updates) =>
      super.copyWith((message) => updates(message as SignOutVendorRequest))
          as SignOutVendorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOutVendorRequest create() => SignOutVendorRequest._();
  @$core.override
  SignOutVendorRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignOutVendorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOutVendorRequest>(create);
  static SignOutVendorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get visitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set visitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVisitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceReportRef => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceReportRef($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceReportRef() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceReportRef() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reportSummary => $_getSZ(2);
  @$pb.TagNumber(3)
  set reportSummary($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReportSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearReportSummary() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get partsUsed => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get followUp => $_getSZ(4);
  @$pb.TagNumber(5)
  set followUp($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFollowUp() => $_has(4);
  @$pb.TagNumber(5)
  void clearFollowUp() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get version => $_getI64(5);
  @$pb.TagNumber(6)
  set version($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearVersion() => $_clearField(6);
}

class SignOutVendorResponse extends $pb.GeneratedMessage {
  factory SignOutVendorResponse({
    Visit? visit,
  }) {
    final result = create();
    if (visit != null) result.visit = visit;
    return result;
  }

  SignOutVendorResponse._();

  factory SignOutVendorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SignOutVendorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SignOutVendorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOM<Visit>(1, _omitFieldNames ? '' : 'visit', subBuilder: Visit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutVendorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SignOutVendorResponse copyWith(
          void Function(SignOutVendorResponse) updates) =>
      super.copyWith((message) => updates(message as SignOutVendorResponse))
          as SignOutVendorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignOutVendorResponse create() => SignOutVendorResponse._();
  @$core.override
  SignOutVendorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SignOutVendorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignOutVendorResponse>(create);
  static SignOutVendorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Visit get visit => $_getN(0);
  @$pb.TagNumber(1)
  set visit(Visit value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVisit() => $_has(0);
  @$pb.TagNumber(1)
  void clearVisit() => $_clearField(1);
  @$pb.TagNumber(1)
  Visit ensureVisit() => $_ensure(0);
}

class ListVendorVisitsRequest extends $pb.GeneratedMessage {
  factory ListVendorVisitsRequest({
    $core.String? facilityId,
    $core.String? workOrderId,
    $core.String? assetId,
    $core.bool? onSiteOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (workOrderId != null) result.workOrderId = workOrderId;
    if (assetId != null) result.assetId = assetId;
    if (onSiteOnly != null) result.onSiteOnly = onSiteOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListVendorVisitsRequest._();

  factory ListVendorVisitsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVendorVisitsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVendorVisitsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'workOrderId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOB(4, _omitFieldNames ? '' : 'onSiteOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVendorVisitsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVendorVisitsRequest copyWith(
          void Function(ListVendorVisitsRequest) updates) =>
      super.copyWith((message) => updates(message as ListVendorVisitsRequest))
          as ListVendorVisitsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVendorVisitsRequest create() => ListVendorVisitsRequest._();
  @$core.override
  ListVendorVisitsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVendorVisitsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVendorVisitsRequest>(create);
  static ListVendorVisitsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get workOrderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set workOrderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWorkOrderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWorkOrderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  /// Longest on site first: the order that surfaces the visit somebody forgot
  /// to sign out, and the list a roll call needs.
  @$pb.TagNumber(4)
  $core.bool get onSiteOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set onSiteOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOnSiteOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearOnSiteOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListVendorVisitsResponse extends $pb.GeneratedMessage {
  factory ListVendorVisitsResponse({
    $core.Iterable<Visit>? visits,
  }) {
    final result = create();
    if (visits != null) result.visits.addAll(visits);
    return result;
  }

  ListVendorVisitsResponse._();

  factory ListVendorVisitsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListVendorVisitsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListVendorVisitsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.facilities.v1'),
      createEmptyInstance: create)
    ..pPM<Visit>(1, _omitFieldNames ? '' : 'visits', subBuilder: Visit.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVendorVisitsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListVendorVisitsResponse copyWith(
          void Function(ListVendorVisitsResponse) updates) =>
      super.copyWith((message) => updates(message as ListVendorVisitsResponse))
          as ListVendorVisitsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListVendorVisitsResponse create() => ListVendorVisitsResponse._();
  @$core.override
  ListVendorVisitsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListVendorVisitsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListVendorVisitsResponse>(create);
  static ListVendorVisitsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Visit> get visits => $_getList(0);
}

/// Facilities engineering operations (SRS-FAC-001 … 011).
class FacilitiesServiceApi {
  final $pb.RpcClient _client;

  FacilitiesServiceApi(this._client);

  /// Assets (SRS-FAC-001).
  $async.Future<RegisterAssetResponse> registerAsset(
          $pb.ClientContext? ctx, RegisterAssetRequest request) =>
      _client.invoke<RegisterAssetResponse>(ctx, 'FacilitiesService',
          'RegisterAsset', request, RegisterAssetResponse());
  $async.Future<SetAssetStatusResponse> setAssetStatus(
          $pb.ClientContext? ctx, SetAssetStatusRequest request) =>
      _client.invoke<SetAssetStatusResponse>(ctx, 'FacilitiesService',
          'SetAssetStatus', request, SetAssetStatusResponse());
  $async.Future<GetAssetResponse> getAsset(
          $pb.ClientContext? ctx, GetAssetRequest request) =>
      _client.invoke<GetAssetResponse>(
          ctx, 'FacilitiesService', 'GetAsset', request, GetAssetResponse());
  $async.Future<ListAssetsResponse> listAssets(
          $pb.ClientContext? ctx, ListAssetsRequest request) =>
      _client.invoke<ListAssetsResponse>(ctx, 'FacilitiesService', 'ListAssets',
          request, ListAssetsResponse());
  $async.Future<GetAssetTreeResponse> getAssetTree(
          $pb.ClientContext? ctx, GetAssetTreeRequest request) =>
      _client.invoke<GetAssetTreeResponse>(ctx, 'FacilitiesService',
          'GetAssetTree', request, GetAssetTreeResponse());
  $async.Future<ListDownAssetsResponse> listDownAssets(
          $pb.ClientContext? ctx, ListDownAssetsRequest request) =>
      _client.invoke<ListDownAssetsResponse>(ctx, 'FacilitiesService',
          'ListDownAssets', request, ListDownAssetsResponse());

  /// Work classes and the permit contract (SRS-FAC-010).
  $async.Future<SetWorkClassResponse> setWorkClass(
          $pb.ClientContext? ctx, SetWorkClassRequest request) =>
      _client.invoke<SetWorkClassResponse>(ctx, 'FacilitiesService',
          'SetWorkClass', request, SetWorkClassResponse());
  $async.Future<ListWorkClassesResponse> listWorkClasses(
          $pb.ClientContext? ctx, ListWorkClassesRequest request) =>
      _client.invoke<ListWorkClassesResponse>(ctx, 'FacilitiesService',
          'ListWorkClasses', request, ListWorkClassesResponse());

  /// Work orders (SRS-FAC-002).
  $async.Future<RaiseWorkResponse> raiseWork(
          $pb.ClientContext? ctx, RaiseWorkRequest request) =>
      _client.invoke<RaiseWorkResponse>(
          ctx, 'FacilitiesService', 'RaiseWork', request, RaiseWorkResponse());
  $async.Future<AssignWorkResponse> assignWork(
          $pb.ClientContext? ctx, AssignWorkRequest request) =>
      _client.invoke<AssignWorkResponse>(ctx, 'FacilitiesService', 'AssignWork',
          request, AssignWorkResponse());
  $async.Future<StartWorkResponse> startWork(
          $pb.ClientContext? ctx, StartWorkRequest request) =>
      _client.invoke<StartWorkResponse>(
          ctx, 'FacilitiesService', 'StartWork', request, StartWorkResponse());
  $async.Future<HoldWorkResponse> holdWork(
          $pb.ClientContext? ctx, HoldWorkRequest request) =>
      _client.invoke<HoldWorkResponse>(
          ctx, 'FacilitiesService', 'HoldWork', request, HoldWorkResponse());
  $async.Future<ResolveWorkResponse> resolveWork(
          $pb.ClientContext? ctx, ResolveWorkRequest request) =>
      _client.invoke<ResolveWorkResponse>(ctx, 'FacilitiesService',
          'ResolveWork', request, ResolveWorkResponse());
  $async.Future<CloseWorkResponse> closeWork(
          $pb.ClientContext? ctx, CloseWorkRequest request) =>
      _client.invoke<CloseWorkResponse>(
          ctx, 'FacilitiesService', 'CloseWork', request, CloseWorkResponse());
  $async.Future<CancelWorkResponse> cancelWork(
          $pb.ClientContext? ctx, CancelWorkRequest request) =>
      _client.invoke<CancelWorkResponse>(ctx, 'FacilitiesService', 'CancelWork',
          request, CancelWorkResponse());
  $async.Future<GetWorkResponse> getWork(
          $pb.ClientContext? ctx, GetWorkRequest request) =>
      _client.invoke<GetWorkResponse>(
          ctx, 'FacilitiesService', 'GetWork', request, GetWorkResponse());
  $async.Future<ListWorkResponse> listWork(
          $pb.ClientContext? ctx, ListWorkRequest request) =>
      _client.invoke<ListWorkResponse>(
          ctx, 'FacilitiesService', 'ListWork', request, ListWorkResponse());
  $async.Future<GetWorklistResponse> getWorklist(
          $pb.ClientContext? ctx, GetWorklistRequest request) =>
      _client.invoke<GetWorklistResponse>(ctx, 'FacilitiesService',
          'GetWorklist', request, GetWorklistResponse());

  /// Preventive and statutory maintenance (SRS-FAC-003, SRS-FAC-007).
  $async.Future<AddScheduleResponse> addSchedule(
          $pb.ClientContext? ctx, AddScheduleRequest request) =>
      _client.invoke<AddScheduleResponse>(ctx, 'FacilitiesService',
          'AddSchedule', request, AddScheduleResponse());
  $async.Future<ListSchedulesResponse> listSchedules(
          $pb.ClientContext? ctx, ListSchedulesRequest request) =>
      _client.invoke<ListSchedulesResponse>(ctx, 'FacilitiesService',
          'ListSchedules', request, ListSchedulesResponse());
  $async.Future<PlanDueResponse> planDue(
          $pb.ClientContext? ctx, PlanDueRequest request) =>
      _client.invoke<PlanDueResponse>(
          ctx, 'FacilitiesService', 'PlanDue', request, PlanDueResponse());
  $async.Future<CompleteTaskResponse> completeTask(
          $pb.ClientContext? ctx, CompleteTaskRequest request) =>
      _client.invoke<CompleteTaskResponse>(ctx, 'FacilitiesService',
          'CompleteTask', request, CompleteTaskResponse());
  $async.Future<WaiveTaskResponse> waiveTask(
          $pb.ClientContext? ctx, WaiveTaskRequest request) =>
      _client.invoke<WaiveTaskResponse>(
          ctx, 'FacilitiesService', 'WaiveTask', request, WaiveTaskResponse());
  $async.Future<ListTasksResponse> listTasks(
          $pb.ClientContext? ctx, ListTasksRequest request) =>
      _client.invoke<ListTasksResponse>(
          ctx, 'FacilitiesService', 'ListTasks', request, ListTasksResponse());
  $async.Future<GetMaintenanceReportResponse> getMaintenanceReport(
          $pb.ClientContext? ctx, GetMaintenanceReportRequest request) =>
      _client.invoke<GetMaintenanceReportResponse>(ctx, 'FacilitiesService',
          'GetMaintenanceReport', request, GetMaintenanceReportResponse());
  $async.Future<RecordRuntimeResponse> recordRuntime(
          $pb.ClientContext? ctx, RecordRuntimeRequest request) =>
      _client.invoke<RecordRuntimeResponse>(ctx, 'FacilitiesService',
          'RecordRuntime', request, RecordRuntimeResponse());

  /// Planned utility shutdowns (SRS-FAC-004).
  $async.Future<PlanOutageResponse> planOutage(
          $pb.ClientContext? ctx, PlanOutageRequest request) =>
      _client.invoke<PlanOutageResponse>(ctx, 'FacilitiesService', 'PlanOutage',
          request, PlanOutageResponse());
  $async.Future<ApproveOutageResponse> approveOutage(
          $pb.ClientContext? ctx, ApproveOutageRequest request) =>
      _client.invoke<ApproveOutageResponse>(ctx, 'FacilitiesService',
          'ApproveOutage', request, ApproveOutageResponse());
  $async.Future<AcknowledgeOutageResponse> acknowledgeOutage(
          $pb.ClientContext? ctx, AcknowledgeOutageRequest request) =>
      _client.invoke<AcknowledgeOutageResponse>(ctx, 'FacilitiesService',
          'AcknowledgeOutage', request, AcknowledgeOutageResponse());
  $async.Future<StartOutageResponse> startOutage(
          $pb.ClientContext? ctx, StartOutageRequest request) =>
      _client.invoke<StartOutageResponse>(ctx, 'FacilitiesService',
          'StartOutage', request, StartOutageResponse());
  $async.Future<RestoreOutageResponse> restoreOutage(
          $pb.ClientContext? ctx, RestoreOutageRequest request) =>
      _client.invoke<RestoreOutageResponse>(ctx, 'FacilitiesService',
          'RestoreOutage', request, RestoreOutageResponse());
  $async.Future<CancelOutageResponse> cancelOutage(
          $pb.ClientContext? ctx, CancelOutageRequest request) =>
      _client.invoke<CancelOutageResponse>(ctx, 'FacilitiesService',
          'CancelOutage', request, CancelOutageResponse());
  $async.Future<GetOutageResponse> getOutage(
          $pb.ClientContext? ctx, GetOutageRequest request) =>
      _client.invoke<GetOutageResponse>(
          ctx, 'FacilitiesService', 'GetOutage', request, GetOutageResponse());
  $async.Future<ListOutagesResponse> listOutages(
          $pb.ClientContext? ctx, ListOutagesRequest request) =>
      _client.invoke<ListOutagesResponse>(ctx, 'FacilitiesService',
          'ListOutages', request, ListOutagesResponse());

  /// Plant alarms (SRS-FAC-005, SRS-FAC-006).
  $async.Future<IngestAlarmResponse> ingestAlarm(
          $pb.ClientContext? ctx, IngestAlarmRequest request) =>
      _client.invoke<IngestAlarmResponse>(ctx, 'FacilitiesService',
          'IngestAlarm', request, IngestAlarmResponse());
  $async.Future<ClearAlarmResponse> clearAlarm(
          $pb.ClientContext? ctx, ClearAlarmRequest request) =>
      _client.invoke<ClearAlarmResponse>(ctx, 'FacilitiesService', 'ClearAlarm',
          request, ClearAlarmResponse());
  $async.Future<AcknowledgeAlarmResponse> acknowledgeAlarm(
          $pb.ClientContext? ctx, AcknowledgeAlarmRequest request) =>
      _client.invoke<AcknowledgeAlarmResponse>(ctx, 'FacilitiesService',
          'AcknowledgeAlarm', request, AcknowledgeAlarmResponse());
  $async.Future<LinkAlarmWorkResponse> linkAlarmWork(
          $pb.ClientContext? ctx, LinkAlarmWorkRequest request) =>
      _client.invoke<LinkAlarmWorkResponse>(ctx, 'FacilitiesService',
          'LinkAlarmWork', request, LinkAlarmWorkResponse());
  $async.Future<SetAlarmRuleResponse> setAlarmRule(
          $pb.ClientContext? ctx, SetAlarmRuleRequest request) =>
      _client.invoke<SetAlarmRuleResponse>(ctx, 'FacilitiesService',
          'SetAlarmRule', request, SetAlarmRuleResponse());
  $async.Future<ListAlarmsResponse> listAlarms(
          $pb.ClientContext? ctx, ListAlarmsRequest request) =>
      _client.invoke<ListAlarmsResponse>(ctx, 'FacilitiesService', 'ListAlarms',
          request, ListAlarmsResponse());

  /// Fire and life safety (SRS-FAC-008).
  $async.Future<RaiseDeficiencyResponse> raiseDeficiency(
          $pb.ClientContext? ctx, RaiseDeficiencyRequest request) =>
      _client.invoke<RaiseDeficiencyResponse>(ctx, 'FacilitiesService',
          'RaiseDeficiency', request, RaiseDeficiencyResponse());
  $async.Future<MitigateDeficiencyResponse> mitigateDeficiency(
          $pb.ClientContext? ctx, MitigateDeficiencyRequest request) =>
      _client.invoke<MitigateDeficiencyResponse>(ctx, 'FacilitiesService',
          'MitigateDeficiency', request, MitigateDeficiencyResponse());
  $async.Future<CloseDeficiencyResponse> closeDeficiency(
          $pb.ClientContext? ctx, CloseDeficiencyRequest request) =>
      _client.invoke<CloseDeficiencyResponse>(ctx, 'FacilitiesService',
          'CloseDeficiency', request, CloseDeficiencyResponse());
  $async.Future<ListDeficienciesResponse> listDeficiencies(
          $pb.ClientContext? ctx, ListDeficienciesRequest request) =>
      _client.invoke<ListDeficienciesResponse>(ctx, 'FacilitiesService',
          'ListDeficiencies', request, ListDeficienciesResponse());
  $async.Future<ListOpenCriticalResponse> listOpenCritical(
          $pb.ClientContext? ctx, ListOpenCriticalRequest request) =>
      _client.invoke<ListOpenCriticalResponse>(ctx, 'FacilitiesService',
          'ListOpenCritical', request, ListOpenCriticalResponse());
  $async.Future<ListBlockingResponse> listBlocking(
          $pb.ClientContext? ctx, ListBlockingRequest request) =>
      _client.invoke<ListBlockingResponse>(ctx, 'FacilitiesService',
          'ListBlocking', request, ListBlockingResponse());
  $async.Future<GetSafetyReportResponse> getSafetyReport(
          $pb.ClientContext? ctx, GetSafetyReportRequest request) =>
      _client.invoke<GetSafetyReportResponse>(ctx, 'FacilitiesService',
          'GetSafetyReport', request, GetSafetyReportResponse());

  /// Utility metering and KPIs (SRS-FAC-009).
  $async.Future<AddMeterResponse> addMeter(
          $pb.ClientContext? ctx, AddMeterRequest request) =>
      _client.invoke<AddMeterResponse>(
          ctx, 'FacilitiesService', 'AddMeter', request, AddMeterResponse());
  $async.Future<RecordMeterReadingResponse> recordMeterReading(
          $pb.ClientContext? ctx, RecordMeterReadingRequest request) =>
      _client.invoke<RecordMeterReadingResponse>(ctx, 'FacilitiesService',
          'RecordMeterReading', request, RecordMeterReadingResponse());
  $async.Future<ListMetersResponse> listMeters(
          $pb.ClientContext? ctx, ListMetersRequest request) =>
      _client.invoke<ListMetersResponse>(ctx, 'FacilitiesService', 'ListMeters',
          request, ListMetersResponse());
  $async.Future<GetConsumptionResponse> getConsumption(
          $pb.ClientContext? ctx, GetConsumptionRequest request) =>
      _client.invoke<GetConsumptionResponse>(ctx, 'FacilitiesService',
          'GetConsumption', request, GetConsumptionResponse());
  $async.Future<GetDowntimeResponse> getDowntime(
          $pb.ClientContext? ctx, GetDowntimeRequest request) =>
      _client.invoke<GetDowntimeResponse>(ctx, 'FacilitiesService',
          'GetDowntime', request, GetDowntimeResponse());
  $async.Future<GetPerformanceResponse> getPerformance(
          $pb.ClientContext? ctx, GetPerformanceRequest request) =>
      _client.invoke<GetPerformanceResponse>(ctx, 'FacilitiesService',
          'GetPerformance', request, GetPerformanceResponse());

  /// Contractor attendance (SRS-FAC-011).
  $async.Future<SignInVendorResponse> signInVendor(
          $pb.ClientContext? ctx, SignInVendorRequest request) =>
      _client.invoke<SignInVendorResponse>(ctx, 'FacilitiesService',
          'SignInVendor', request, SignInVendorResponse());
  $async.Future<SignOutVendorResponse> signOutVendor(
          $pb.ClientContext? ctx, SignOutVendorRequest request) =>
      _client.invoke<SignOutVendorResponse>(ctx, 'FacilitiesService',
          'SignOutVendor', request, SignOutVendorResponse());
  $async.Future<ListVendorVisitsResponse> listVendorVisits(
          $pb.ClientContext? ctx, ListVendorVisitsRequest request) =>
      _client.invoke<ListVendorVisitsResponse>(ctx, 'FacilitiesService',
          'ListVendorVisits', request, ListVendorVisitsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
