// This is a generated file - do not edit.
//
// Generated from healthcare/biomedical/v1/biomedical.proto.

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

import 'biomedical.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'biomedical.pbenum.dart';

/// Asset is one piece of equipment (SRS-BIO-001).
class Asset extends $pb.GeneratedMessage {
  factory Asset({
    $core.String? assetId,
    $core.String? tag,
    $core.String? udi,
    $core.String? serial,
    $core.String? make,
    $core.String? model,
    $core.String? category,
    Criticality? criticality,
    AssetStatus? status,
    $core.String? locationId,
    $core.String? department,
    $core.Iterable<$core.String>? capabilities,
    $0.Timestamp? acquiredOn,
    $fixnum.Int64? acquisitionCostMinor,
    $core.int? expectedLifeYears,
    $core.bool? calibrationRequired,
    $0.Timestamp? calibrationDue,
    $core.String? calibrationCertificate,
    $core.bool? safetyHold,
    $core.String? safetyHoldReason,
    $core.String? notes,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
    $core.Iterable<$core.String>? unusableReasons,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (tag != null) result.tag = tag;
    if (udi != null) result.udi = udi;
    if (serial != null) result.serial = serial;
    if (make != null) result.make = make;
    if (model != null) result.model = model;
    if (category != null) result.category = category;
    if (criticality != null) result.criticality = criticality;
    if (status != null) result.status = status;
    if (locationId != null) result.locationId = locationId;
    if (department != null) result.department = department;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    if (acquiredOn != null) result.acquiredOn = acquiredOn;
    if (acquisitionCostMinor != null)
      result.acquisitionCostMinor = acquisitionCostMinor;
    if (expectedLifeYears != null) result.expectedLifeYears = expectedLifeYears;
    if (calibrationRequired != null)
      result.calibrationRequired = calibrationRequired;
    if (calibrationDue != null) result.calibrationDue = calibrationDue;
    if (calibrationCertificate != null)
      result.calibrationCertificate = calibrationCertificate;
    if (safetyHold != null) result.safetyHold = safetyHold;
    if (safetyHoldReason != null) result.safetyHoldReason = safetyHoldReason;
    if (notes != null) result.notes = notes;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    if (unusableReasons != null) result.unusableReasons.addAll(unusableReasons);
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'tag')
    ..aOS(3, _omitFieldNames ? '' : 'udi')
    ..aOS(4, _omitFieldNames ? '' : 'serial')
    ..aOS(5, _omitFieldNames ? '' : 'make')
    ..aOS(6, _omitFieldNames ? '' : 'model')
    ..aOS(7, _omitFieldNames ? '' : 'category')
    ..aE<Criticality>(8, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aE<AssetStatus>(9, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'locationId')
    ..aOS(11, _omitFieldNames ? '' : 'department')
    ..pPS(12, _omitFieldNames ? '' : 'capabilities')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'acquiredOn',
        subBuilder: $0.Timestamp.create)
    ..aInt64(14, _omitFieldNames ? '' : 'acquisitionCostMinor')
    ..aI(15, _omitFieldNames ? '' : 'expectedLifeYears')
    ..aOB(16, _omitFieldNames ? '' : 'calibrationRequired')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'calibrationDue',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'calibrationCertificate')
    ..aOB(19, _omitFieldNames ? '' : 'safetyHold')
    ..aOS(20, _omitFieldNames ? '' : 'safetyHoldReason')
    ..aOS(21, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(23, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(24, _omitFieldNames ? '' : 'version')
    ..pPS(25, _omitFieldNames ? '' : 'unusableReasons')
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

  /// The number on the sticker. Unique within the tenant, and what a service
  /// request names.
  @$pb.TagNumber(2)
  $core.String get tag => $_getSZ(1);
  @$pb.TagNumber(2)
  set tag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearTag() => $_clearField(2);

  /// The manufacturer's identifiers. Both, because a recall is announced by
  /// one or the other and a hospital does not get to choose which.
  @$pb.TagNumber(3)
  $core.String get udi => $_getSZ(2);
  @$pb.TagNumber(3)
  set udi($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUdi() => $_has(2);
  @$pb.TagNumber(3)
  void clearUdi() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get serial => $_getSZ(3);
  @$pb.TagNumber(4)
  set serial($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSerial() => $_has(3);
  @$pb.TagNumber(4)
  void clearSerial() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get make => $_getSZ(4);
  @$pb.TagNumber(5)
  set make($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMake() => $_has(4);
  @$pb.TagNumber(5)
  void clearMake() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get model => $_getSZ(5);
  @$pb.TagNumber(6)
  set model($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearModel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get category => $_getSZ(6);
  @$pb.TagNumber(7)
  set category($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCategory() => $_has(6);
  @$pb.TagNumber(7)
  void clearCategory() => $_clearField(7);

  @$pb.TagNumber(8)
  Criticality get criticality => $_getN(7);
  @$pb.TagNumber(8)
  set criticality(Criticality value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCriticality() => $_has(7);
  @$pb.TagNumber(8)
  void clearCriticality() => $_clearField(8);

  @$pb.TagNumber(9)
  AssetStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(AssetStatus value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  /// Where it stands. What SRS-BIO-009's capability read runs over.
  @$pb.TagNumber(10)
  $core.String get locationId => $_getSZ(9);
  @$pb.TagNumber(10)
  set locationId($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLocationId() => $_has(9);
  @$pb.TagNumber(10)
  void clearLocationId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get department => $_getSZ(10);
  @$pb.TagNumber(11)
  set department($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDepartment() => $_has(10);
  @$pb.TagNumber(11)
  void clearDepartment() => $_clearField(11);

  /// What this asset lets a room do. The same vocabulary a theatre matches a
  /// case's requirements against, so one out of service subtracts from it.
  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get capabilities => $_getList(11);

  @$pb.TagNumber(13)
  $0.Timestamp get acquiredOn => $_getN(12);
  @$pb.TagNumber(13)
  set acquiredOn($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasAcquiredOn() => $_has(12);
  @$pb.TagNumber(13)
  void clearAcquiredOn() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureAcquiredOn() => $_ensure(12);

  /// Minor units and an integer, never a float: depreciation and replacement
  /// analysis add these up.
  @$pb.TagNumber(14)
  $fixnum.Int64 get acquisitionCostMinor => $_getI64(13);
  @$pb.TagNumber(14)
  set acquisitionCostMinor($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasAcquisitionCostMinor() => $_has(13);
  @$pb.TagNumber(14)
  void clearAcquisitionCostMinor() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get expectedLifeYears => $_getIZ(14);
  @$pb.TagNumber(15)
  set expectedLifeYears($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasExpectedLifeYears() => $_has(14);
  @$pb.TagNumber(15)
  void clearExpectedLifeYears() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get calibrationRequired => $_getBF(15);
  @$pb.TagNumber(16)
  set calibrationRequired($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCalibrationRequired() => $_has(15);
  @$pb.TagNumber(16)
  void clearCalibrationRequired() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get calibrationDue => $_getN(16);
  @$pb.TagNumber(17)
  set calibrationDue($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasCalibrationDue() => $_has(16);
  @$pb.TagNumber(17)
  void clearCalibrationDue() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureCalibrationDue() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get calibrationCertificate => $_getSZ(17);
  @$pb.TagNumber(18)
  set calibrationCertificate($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasCalibrationCertificate() => $_has(17);
  @$pb.TagNumber(18)
  void clearCalibrationCertificate() => $_clearField(18);

  /// Stopped by a safety notice. Separate from status, because a held asset
  /// may be perfectly serviceable and still must not be used.
  @$pb.TagNumber(19)
  $core.bool get safetyHold => $_getBF(18);
  @$pb.TagNumber(19)
  set safetyHold($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasSafetyHold() => $_has(18);
  @$pb.TagNumber(19)
  void clearSafetyHold() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get safetyHoldReason => $_getSZ(19);
  @$pb.TagNumber(20)
  set safetyHoldReason($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasSafetyHoldReason() => $_has(19);
  @$pb.TagNumber(20)
  void clearSafetyHoldReason() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get notes => $_getSZ(20);
  @$pb.TagNumber(21)
  set notes($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasNotes() => $_has(20);
  @$pb.TagNumber(21)
  void clearNotes() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get createdAt => $_getN(21);
  @$pb.TagNumber(22)
  set createdAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasCreatedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearCreatedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureCreatedAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $core.String get createdBy => $_getSZ(22);
  @$pb.TagNumber(23)
  set createdBy($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasCreatedBy() => $_has(22);
  @$pb.TagNumber(23)
  void clearCreatedBy() => $_clearField(23);

  @$pb.TagNumber(24)
  $fixnum.Int64 get version => $_getI64(23);
  @$pb.TagNumber(24)
  set version($fixnum.Int64 value) => $_setInt64(23, value);
  @$pb.TagNumber(24)
  $core.bool hasVersion() => $_has(23);
  @$pb.TagNumber(24)
  void clearVersion() => $_clearField(24);

  /// Why this asset cannot be used right now, one line per reason. Derived on
  /// read and empty when it is fine. Every reason rather than the first,
  /// because fixing one and finding another is how an engineer loses a day.
  @$pb.TagNumber(25)
  $pb.PbList<$core.String> get unusableReasons => $_getList(24);
}

class RegisterAssetRequest extends $pb.GeneratedMessage {
  factory RegisterAssetRequest({
    $core.String? tag,
    $core.String? udi,
    $core.String? serial,
    $core.String? make,
    $core.String? model,
    $core.String? category,
    Criticality? criticality,
    $core.String? locationId,
    $core.String? department,
    $core.Iterable<$core.String>? capabilities,
    $0.Timestamp? acquiredOn,
    $fixnum.Int64? acquisitionCostMinor,
    $core.int? expectedLifeYears,
    $core.bool? calibrationRequired,
    $0.Timestamp? calibrationDue,
    $core.String? notes,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    if (udi != null) result.udi = udi;
    if (serial != null) result.serial = serial;
    if (make != null) result.make = make;
    if (model != null) result.model = model;
    if (category != null) result.category = category;
    if (criticality != null) result.criticality = criticality;
    if (locationId != null) result.locationId = locationId;
    if (department != null) result.department = department;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    if (acquiredOn != null) result.acquiredOn = acquiredOn;
    if (acquisitionCostMinor != null)
      result.acquisitionCostMinor = acquisitionCostMinor;
    if (expectedLifeYears != null) result.expectedLifeYears = expectedLifeYears;
    if (calibrationRequired != null)
      result.calibrationRequired = calibrationRequired;
    if (calibrationDue != null) result.calibrationDue = calibrationDue;
    if (notes != null) result.notes = notes;
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..aOS(2, _omitFieldNames ? '' : 'udi')
    ..aOS(3, _omitFieldNames ? '' : 'serial')
    ..aOS(4, _omitFieldNames ? '' : 'make')
    ..aOS(5, _omitFieldNames ? '' : 'model')
    ..aOS(6, _omitFieldNames ? '' : 'category')
    ..aE<Criticality>(7, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aOS(8, _omitFieldNames ? '' : 'locationId')
    ..aOS(9, _omitFieldNames ? '' : 'department')
    ..pPS(10, _omitFieldNames ? '' : 'capabilities')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'acquiredOn',
        subBuilder: $0.Timestamp.create)
    ..aInt64(12, _omitFieldNames ? '' : 'acquisitionCostMinor')
    ..aI(13, _omitFieldNames ? '' : 'expectedLifeYears')
    ..aOB(14, _omitFieldNames ? '' : 'calibrationRequired')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'calibrationDue',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'notes')
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
  $core.String get udi => $_getSZ(1);
  @$pb.TagNumber(2)
  set udi($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUdi() => $_has(1);
  @$pb.TagNumber(2)
  void clearUdi() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serial => $_getSZ(2);
  @$pb.TagNumber(3)
  set serial($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSerial() => $_has(2);
  @$pb.TagNumber(3)
  void clearSerial() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get make => $_getSZ(3);
  @$pb.TagNumber(4)
  set make($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMake() => $_has(3);
  @$pb.TagNumber(4)
  void clearMake() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get model => $_getSZ(4);
  @$pb.TagNumber(5)
  set model($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasModel() => $_has(4);
  @$pb.TagNumber(5)
  void clearModel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get category => $_getSZ(5);
  @$pb.TagNumber(6)
  set category($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCategory() => $_has(5);
  @$pb.TagNumber(6)
  void clearCategory() => $_clearField(6);

  @$pb.TagNumber(7)
  Criticality get criticality => $_getN(6);
  @$pb.TagNumber(7)
  set criticality(Criticality value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCriticality() => $_has(6);
  @$pb.TagNumber(7)
  void clearCriticality() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get locationId => $_getSZ(7);
  @$pb.TagNumber(8)
  set locationId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLocationId() => $_has(7);
  @$pb.TagNumber(8)
  void clearLocationId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get department => $_getSZ(8);
  @$pb.TagNumber(9)
  set department($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDepartment() => $_has(8);
  @$pb.TagNumber(9)
  void clearDepartment() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get capabilities => $_getList(9);

  @$pb.TagNumber(11)
  $0.Timestamp get acquiredOn => $_getN(10);
  @$pb.TagNumber(11)
  set acquiredOn($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAcquiredOn() => $_has(10);
  @$pb.TagNumber(11)
  void clearAcquiredOn() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureAcquiredOn() => $_ensure(10);

  @$pb.TagNumber(12)
  $fixnum.Int64 get acquisitionCostMinor => $_getI64(11);
  @$pb.TagNumber(12)
  set acquisitionCostMinor($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAcquisitionCostMinor() => $_has(11);
  @$pb.TagNumber(12)
  void clearAcquisitionCostMinor() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get expectedLifeYears => $_getIZ(12);
  @$pb.TagNumber(13)
  set expectedLifeYears($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasExpectedLifeYears() => $_has(12);
  @$pb.TagNumber(13)
  void clearExpectedLifeYears() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get calibrationRequired => $_getBF(13);
  @$pb.TagNumber(14)
  set calibrationRequired($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCalibrationRequired() => $_has(13);
  @$pb.TagNumber(14)
  void clearCalibrationRequired() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get calibrationDue => $_getN(14);
  @$pb.TagNumber(15)
  set calibrationDue($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCalibrationDue() => $_has(14);
  @$pb.TagNumber(15)
  void clearCalibrationDue() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureCalibrationDue() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get notes => $_getSZ(15);
  @$pb.TagNumber(16)
  set notes($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasNotes() => $_has(15);
  @$pb.TagNumber(16)
  void clearNotes() => $_clearField(16);
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
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

class GetAssetByTagRequest extends $pb.GeneratedMessage {
  factory GetAssetByTagRequest({
    $core.String? tag,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    return result;
  }

  GetAssetByTagRequest._();

  factory GetAssetByTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetByTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetByTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetByTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetByTagRequest copyWith(void Function(GetAssetByTagRequest) updates) =>
      super.copyWith((message) => updates(message as GetAssetByTagRequest))
          as GetAssetByTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetByTagRequest create() => GetAssetByTagRequest._();
  @$core.override
  GetAssetByTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetByTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetByTagRequest>(create);
  static GetAssetByTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);
}

class GetAssetByTagResponse extends $pb.GeneratedMessage {
  factory GetAssetByTagResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  GetAssetByTagResponse._();

  factory GetAssetByTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetByTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetByTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetByTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetByTagResponse copyWith(
          void Function(GetAssetByTagResponse) updates) =>
      super.copyWith((message) => updates(message as GetAssetByTagResponse))
          as GetAssetByTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetByTagResponse create() => GetAssetByTagResponse._();
  @$core.override
  GetAssetByTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetByTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetByTagResponse>(create);
  static GetAssetByTagResponse? _defaultInstance;

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
    $core.String? category,
    AssetStatus? status,
    $core.bool? excludeRetired,
    $core.int? pageSize,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (status != null) result.status = status;
    if (excludeRetired != null) result.excludeRetired = excludeRetired;
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aE<AssetStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOB(3, _omitFieldNames ? '' : 'excludeRetired')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
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
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  AssetStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(AssetStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// Drop decommissioned and disposed equipment, which is what a working list
  /// wants and an audit does not.
  @$pb.TagNumber(3)
  $core.bool get excludeRetired => $_getBF(2);
  @$pb.TagNumber(3)
  set excludeRetired($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExcludeRetired() => $_has(2);
  @$pb.TagNumber(3)
  void clearExcludeRetired() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
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

class MoveAssetRequest extends $pb.GeneratedMessage {
  factory MoveAssetRequest({
    $core.String? assetId,
    AssetStatus? status,
    $core.String? locationId,
    $core.bool? clearLocation,
    $core.String? department,
    $core.String? note,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (status != null) result.status = status;
    if (locationId != null) result.locationId = locationId;
    if (clearLocation != null) result.clearLocation = clearLocation;
    if (department != null) result.department = department;
    if (note != null) result.note = note;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  MoveAssetRequest._();

  factory MoveAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aE<AssetStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: AssetStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOB(4, _omitFieldNames ? '' : 'clearLocation')
    ..aOS(5, _omitFieldNames ? '' : 'department')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aInt64(7, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveAssetRequest copyWith(void Function(MoveAssetRequest) updates) =>
      super.copyWith((message) => updates(message as MoveAssetRequest))
          as MoveAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveAssetRequest create() => MoveAssetRequest._();
  @$core.override
  MoveAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveAssetRequest>(create);
  static MoveAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  /// Leave unspecified to move a machine between rooms without implying it
  /// broke.
  @$pb.TagNumber(2)
  AssetStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(AssetStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  /// Set to move it to nowhere, which an empty location_id does not mean.
  @$pb.TagNumber(4)
  $core.bool get clearLocation => $_getBF(3);
  @$pb.TagNumber(4)
  set clearLocation($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasClearLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearClearLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get department => $_getSZ(4);
  @$pb.TagNumber(5)
  set department($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDepartment() => $_has(4);
  @$pb.TagNumber(5)
  void clearDepartment() => $_clearField(5);

  /// Required for any status other than in-service: a status change with no
  /// reason is a number a replacement analysis cannot act on.
  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get expectedVersion => $_getI64(6);
  @$pb.TagNumber(7)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasExpectedVersion() => $_has(6);
  @$pb.TagNumber(7)
  void clearExpectedVersion() => $_clearField(7);
}

class MoveAssetResponse extends $pb.GeneratedMessage {
  factory MoveAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  MoveAssetResponse._();

  factory MoveAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MoveAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MoveAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MoveAssetResponse copyWith(void Function(MoveAssetResponse) updates) =>
      super.copyWith((message) => updates(message as MoveAssetResponse))
          as MoveAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveAssetResponse create() => MoveAssetResponse._();
  @$core.override
  MoveAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MoveAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MoveAssetResponse>(create);
  static MoveAssetResponse? _defaultInstance;

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

class RecordCalibrationRequest extends $pb.GeneratedMessage {
  factory RecordCalibrationRequest({
    $core.String? assetId,
    $core.String? certificate,
    $0.Timestamp? nextDue,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (certificate != null) result.certificate = certificate;
    if (nextDue != null) result.nextDue = nextDue;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RecordCalibrationRequest._();

  factory RecordCalibrationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCalibrationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCalibrationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'certificate')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'nextDue',
        subBuilder: $0.Timestamp.create)
    ..aInt64(4, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCalibrationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCalibrationRequest copyWith(
          void Function(RecordCalibrationRequest) updates) =>
      super.copyWith((message) => updates(message as RecordCalibrationRequest))
          as RecordCalibrationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCalibrationRequest create() => RecordCalibrationRequest._();
  @$core.override
  RecordCalibrationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCalibrationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCalibrationRequest>(create);
  static RecordCalibrationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  /// The reference an auditor asks for. A calibration recorded without one is
  /// a claim rather than evidence.
  @$pb.TagNumber(2)
  $core.String get certificate => $_getSZ(1);
  @$pb.TagNumber(2)
  set certificate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCertificate() => $_has(1);
  @$pb.TagNumber(2)
  void clearCertificate() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get nextDue => $_getN(2);
  @$pb.TagNumber(3)
  set nextDue($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasNextDue() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextDue() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureNextDue() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get expectedVersion => $_getI64(3);
  @$pb.TagNumber(4)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasExpectedVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedVersion() => $_clearField(4);
}

class RecordCalibrationResponse extends $pb.GeneratedMessage {
  factory RecordCalibrationResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  RecordCalibrationResponse._();

  factory RecordCalibrationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCalibrationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCalibrationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCalibrationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCalibrationResponse copyWith(
          void Function(RecordCalibrationResponse) updates) =>
      super.copyWith((message) => updates(message as RecordCalibrationResponse))
          as RecordCalibrationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCalibrationResponse create() => RecordCalibrationResponse._();
  @$core.override
  RecordCalibrationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCalibrationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCalibrationResponse>(create);
  static RecordCalibrationResponse? _defaultInstance;

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

class HoldAssetRequest extends $pb.GeneratedMessage {
  factory HoldAssetRequest({
    $core.String? assetId,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  HoldAssetRequest._();

  factory HoldAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldAssetRequest copyWith(void Function(HoldAssetRequest) updates) =>
      super.copyWith((message) => updates(message as HoldAssetRequest))
          as HoldAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldAssetRequest create() => HoldAssetRequest._();
  @$core.override
  HoldAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldAssetRequest>(create);
  static HoldAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class HoldAssetResponse extends $pb.GeneratedMessage {
  factory HoldAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  HoldAssetResponse._();

  factory HoldAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldAssetResponse copyWith(void Function(HoldAssetResponse) updates) =>
      super.copyWith((message) => updates(message as HoldAssetResponse))
          as HoldAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldAssetResponse create() => HoldAssetResponse._();
  @$core.override
  HoldAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldAssetResponse>(create);
  static HoldAssetResponse? _defaultInstance;

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

class ReleaseAssetRequest extends $pb.GeneratedMessage {
  factory ReleaseAssetRequest({
    $core.String? assetId,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ReleaseAssetRequest._();

  factory ReleaseAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseAssetRequest copyWith(void Function(ReleaseAssetRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseAssetRequest))
          as ReleaseAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseAssetRequest create() => ReleaseAssetRequest._();
  @$core.override
  ReleaseAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseAssetRequest>(create);
  static ReleaseAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class ReleaseAssetResponse extends $pb.GeneratedMessage {
  factory ReleaseAssetResponse({
    Asset? asset,
  }) {
    final result = create();
    if (asset != null) result.asset = asset;
    return result;
  }

  ReleaseAssetResponse._();

  factory ReleaseAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Asset>(1, _omitFieldNames ? '' : 'asset', subBuilder: Asset.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseAssetResponse copyWith(void Function(ReleaseAssetResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseAssetResponse))
          as ReleaseAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseAssetResponse create() => ReleaseAssetResponse._();
  @$core.override
  ReleaseAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseAssetResponse>(create);
  static ReleaseAssetResponse? _defaultInstance;

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

/// UnusableAsset explains why one machine is not counted (SRS-BIO-009).
class UnusableAsset extends $pb.GeneratedMessage {
  factory UnusableAsset({
    $core.String? tag,
    $core.Iterable<$core.String>? reasons,
  }) {
    final result = create();
    if (tag != null) result.tag = tag;
    if (reasons != null) result.reasons.addAll(reasons);
    return result;
  }

  UnusableAsset._();

  factory UnusableAsset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnusableAsset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnusableAsset',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tag')
    ..pPS(2, _omitFieldNames ? '' : 'reasons')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnusableAsset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnusableAsset copyWith(void Function(UnusableAsset) updates) =>
      super.copyWith((message) => updates(message as UnusableAsset))
          as UnusableAsset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnusableAsset create() => UnusableAsset._();
  @$core.override
  UnusableAsset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnusableAsset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnusableAsset>(create);
  static UnusableAsset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tag => $_getSZ(0);
  @$pb.TagNumber(1)
  set tag($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTag() => $_has(0);
  @$pb.TagNumber(1)
  void clearTag() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get reasons => $_getList(1);
}

class GetLocationCapabilityRequest extends $pb.GeneratedMessage {
  factory GetLocationCapabilityRequest({
    $core.String? locationId,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    return result;
  }

  GetLocationCapabilityRequest._();

  factory GetLocationCapabilityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLocationCapabilityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLocationCapabilityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationCapabilityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationCapabilityRequest copyWith(
          void Function(GetLocationCapabilityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetLocationCapabilityRequest))
          as GetLocationCapabilityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLocationCapabilityRequest create() =>
      GetLocationCapabilityRequest._();
  @$core.override
  GetLocationCapabilityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLocationCapabilityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLocationCapabilityRequest>(create);
  static GetLocationCapabilityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);
}

/// GetLocationCapabilityResponse is what a room can do right now
/// (SRS-BIO-009).
///
/// Derived on read. A stored capability list is stale the moment a machine is
/// wheeled out, and a scheduler offering a slot on one is offering something
/// the hospital cannot deliver.
class GetLocationCapabilityResponse extends $pb.GeneratedMessage {
  factory GetLocationCapabilityResponse({
    $core.String? locationId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? available,
    $core.Iterable<$core.String>? unavailable,
    $core.Iterable<UnusableAsset>? unusable,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (available != null) result.available.addEntries(available);
    if (unavailable != null) result.unavailable.addAll(unavailable);
    if (unusable != null) result.unusable.addAll(unusable);
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  GetLocationCapabilityResponse._();

  factory GetLocationCapabilityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLocationCapabilityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLocationCapabilityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..m<$core.String, $core.int>(2, _omitFieldNames ? '' : 'available',
        entryClassName: 'GetLocationCapabilityResponse.AvailableEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.biomedical.v1'))
    ..pPS(3, _omitFieldNames ? '' : 'unavailable')
    ..pPM<UnusableAsset>(4, _omitFieldNames ? '' : 'unusable',
        subBuilder: UnusableAsset.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationCapabilityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLocationCapabilityResponse copyWith(
          void Function(GetLocationCapabilityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLocationCapabilityResponse))
          as GetLocationCapabilityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLocationCapabilityResponse create() =>
      GetLocationCapabilityResponse._();
  @$core.override
  GetLocationCapabilityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLocationCapabilityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLocationCapabilityResponse>(create);
  static GetLocationCapabilityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  /// Counted, not flagged: two intensifiers means the room survives one going
  /// for service.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.int> get available => $_getMap(1);

  /// What the room claims and cannot deliver.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get unavailable => $_getList(2);

  /// Per asset, so "why can we not do this list" has an answer.
  @$pb.TagNumber(4)
  $pb.PbList<UnusableAsset> get unusable => $_getList(3);

  @$pb.TagNumber(5)
  $0.Timestamp get observedAt => $_getN(4);
  @$pb.TagNumber(5)
  set observedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasObservedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureObservedAt() => $_ensure(4);
}

/// ServiceContract is a warranty, AMC or CMC (SRS-BIO-002).
class ServiceContract extends $pb.GeneratedMessage {
  factory ServiceContract({
    $core.String? contractId,
    $core.String? assetId,
    ContractKind? kind,
    $core.String? reference,
    $core.String? vendorName,
    $core.String? vendorContact,
    $core.String? vendorPhone,
    $core.String? vendorEmail,
    $0.Timestamp? startsOn,
    $0.Timestamp? endsOn,
    $fixnum.Int64? valueMinor,
    $core.int? responseHours,
    $core.int? resolutionHours,
    $core.String? notes,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (contractId != null) result.contractId = contractId;
    if (assetId != null) result.assetId = assetId;
    if (kind != null) result.kind = kind;
    if (reference != null) result.reference = reference;
    if (vendorName != null) result.vendorName = vendorName;
    if (vendorContact != null) result.vendorContact = vendorContact;
    if (vendorPhone != null) result.vendorPhone = vendorPhone;
    if (vendorEmail != null) result.vendorEmail = vendorEmail;
    if (startsOn != null) result.startsOn = startsOn;
    if (endsOn != null) result.endsOn = endsOn;
    if (valueMinor != null) result.valueMinor = valueMinor;
    if (responseHours != null) result.responseHours = responseHours;
    if (resolutionHours != null) result.resolutionHours = resolutionHours;
    if (notes != null) result.notes = notes;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  ServiceContract._();

  factory ServiceContract.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceContract.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceContract',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'contractId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aE<ContractKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: ContractKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'reference')
    ..aOS(5, _omitFieldNames ? '' : 'vendorName')
    ..aOS(6, _omitFieldNames ? '' : 'vendorContact')
    ..aOS(7, _omitFieldNames ? '' : 'vendorPhone')
    ..aOS(8, _omitFieldNames ? '' : 'vendorEmail')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'startsOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'endsOn',
        subBuilder: $0.Timestamp.create)
    ..aInt64(11, _omitFieldNames ? '' : 'valueMinor')
    ..aI(12, _omitFieldNames ? '' : 'responseHours')
    ..aI(13, _omitFieldNames ? '' : 'resolutionHours')
    ..aOS(14, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceContract clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceContract copyWith(void Function(ServiceContract) updates) =>
      super.copyWith((message) => updates(message as ServiceContract))
          as ServiceContract;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceContract create() => ServiceContract._();
  @$core.override
  ServiceContract createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceContract getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceContract>(create);
  static ServiceContract? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contractId => $_getSZ(0);
  @$pb.TagNumber(1)
  set contractId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContractId() => $_has(0);
  @$pb.TagNumber(1)
  void clearContractId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  ContractKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(ContractKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reference => $_getSZ(3);
  @$pb.TagNumber(4)
  set reference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearReference() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get vendorName => $_getSZ(4);
  @$pb.TagNumber(5)
  set vendorName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVendorName() => $_has(4);
  @$pb.TagNumber(5)
  void clearVendorName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get vendorContact => $_getSZ(5);
  @$pb.TagNumber(6)
  set vendorContact($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVendorContact() => $_has(5);
  @$pb.TagNumber(6)
  void clearVendorContact() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get vendorPhone => $_getSZ(6);
  @$pb.TagNumber(7)
  set vendorPhone($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVendorPhone() => $_has(6);
  @$pb.TagNumber(7)
  void clearVendorPhone() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get vendorEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set vendorEmail($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVendorEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearVendorEmail() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get startsOn => $_getN(8);
  @$pb.TagNumber(9)
  set startsOn($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStartsOn() => $_has(8);
  @$pb.TagNumber(9)
  void clearStartsOn() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureStartsOn() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get endsOn => $_getN(9);
  @$pb.TagNumber(10)
  set endsOn($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEndsOn() => $_has(9);
  @$pb.TagNumber(10)
  void clearEndsOn() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEndsOn() => $_ensure(9);

  @$pb.TagNumber(11)
  $fixnum.Int64 get valueMinor => $_getI64(10);
  @$pb.TagNumber(11)
  set valueMinor($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasValueMinor() => $_has(10);
  @$pb.TagNumber(11)
  void clearValueMinor() => $_clearField(11);

  /// What the vendor promised. A ticket's clock comes from here rather than
  /// from a number somebody typed.
  @$pb.TagNumber(12)
  $core.int get responseHours => $_getIZ(11);
  @$pb.TagNumber(12)
  set responseHours($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasResponseHours() => $_has(11);
  @$pb.TagNumber(12)
  void clearResponseHours() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get resolutionHours => $_getIZ(12);
  @$pb.TagNumber(13)
  set resolutionHours($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasResolutionHours() => $_has(12);
  @$pb.TagNumber(13)
  void clearResolutionHours() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get notes => $_getSZ(13);
  @$pb.TagNumber(14)
  set notes($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasNotes() => $_has(13);
  @$pb.TagNumber(14)
  void clearNotes() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureCreatedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get createdBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set createdBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasCreatedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearCreatedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

class RecordContractRequest extends $pb.GeneratedMessage {
  factory RecordContractRequest({
    $core.String? assetId,
    ContractKind? kind,
    $core.String? reference,
    $core.String? vendorName,
    $core.String? vendorContact,
    $core.String? vendorPhone,
    $core.String? vendorEmail,
    $0.Timestamp? startsOn,
    $0.Timestamp? endsOn,
    $fixnum.Int64? valueMinor,
    $core.int? responseHours,
    $core.int? resolutionHours,
    $core.String? notes,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (kind != null) result.kind = kind;
    if (reference != null) result.reference = reference;
    if (vendorName != null) result.vendorName = vendorName;
    if (vendorContact != null) result.vendorContact = vendorContact;
    if (vendorPhone != null) result.vendorPhone = vendorPhone;
    if (vendorEmail != null) result.vendorEmail = vendorEmail;
    if (startsOn != null) result.startsOn = startsOn;
    if (endsOn != null) result.endsOn = endsOn;
    if (valueMinor != null) result.valueMinor = valueMinor;
    if (responseHours != null) result.responseHours = responseHours;
    if (resolutionHours != null) result.resolutionHours = resolutionHours;
    if (notes != null) result.notes = notes;
    return result;
  }

  RecordContractRequest._();

  factory RecordContractRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordContractRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordContractRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aE<ContractKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: ContractKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'reference')
    ..aOS(4, _omitFieldNames ? '' : 'vendorName')
    ..aOS(5, _omitFieldNames ? '' : 'vendorContact')
    ..aOS(6, _omitFieldNames ? '' : 'vendorPhone')
    ..aOS(7, _omitFieldNames ? '' : 'vendorEmail')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startsOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'endsOn',
        subBuilder: $0.Timestamp.create)
    ..aInt64(10, _omitFieldNames ? '' : 'valueMinor')
    ..aI(11, _omitFieldNames ? '' : 'responseHours')
    ..aI(12, _omitFieldNames ? '' : 'resolutionHours')
    ..aOS(13, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordContractRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordContractRequest copyWith(
          void Function(RecordContractRequest) updates) =>
      super.copyWith((message) => updates(message as RecordContractRequest))
          as RecordContractRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordContractRequest create() => RecordContractRequest._();
  @$core.override
  RecordContractRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordContractRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordContractRequest>(create);
  static RecordContractRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  ContractKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(ContractKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reference => $_getSZ(2);
  @$pb.TagNumber(3)
  set reference($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearReference() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get vendorName => $_getSZ(3);
  @$pb.TagNumber(4)
  set vendorName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVendorName() => $_has(3);
  @$pb.TagNumber(4)
  void clearVendorName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get vendorContact => $_getSZ(4);
  @$pb.TagNumber(5)
  set vendorContact($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVendorContact() => $_has(4);
  @$pb.TagNumber(5)
  void clearVendorContact() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get vendorPhone => $_getSZ(5);
  @$pb.TagNumber(6)
  set vendorPhone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVendorPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearVendorPhone() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get vendorEmail => $_getSZ(6);
  @$pb.TagNumber(7)
  set vendorEmail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVendorEmail() => $_has(6);
  @$pb.TagNumber(7)
  void clearVendorEmail() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get startsOn => $_getN(7);
  @$pb.TagNumber(8)
  set startsOn($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartsOn() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartsOn() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartsOn() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get endsOn => $_getN(8);
  @$pb.TagNumber(9)
  set endsOn($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEndsOn() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndsOn() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEndsOn() => $_ensure(8);

  @$pb.TagNumber(10)
  $fixnum.Int64 get valueMinor => $_getI64(9);
  @$pb.TagNumber(10)
  set valueMinor($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasValueMinor() => $_has(9);
  @$pb.TagNumber(10)
  void clearValueMinor() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get responseHours => $_getIZ(10);
  @$pb.TagNumber(11)
  set responseHours($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasResponseHours() => $_has(10);
  @$pb.TagNumber(11)
  void clearResponseHours() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.int get resolutionHours => $_getIZ(11);
  @$pb.TagNumber(12)
  set resolutionHours($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasResolutionHours() => $_has(11);
  @$pb.TagNumber(12)
  void clearResolutionHours() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get notes => $_getSZ(12);
  @$pb.TagNumber(13)
  set notes($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasNotes() => $_has(12);
  @$pb.TagNumber(13)
  void clearNotes() => $_clearField(13);
}

class RecordContractResponse extends $pb.GeneratedMessage {
  factory RecordContractResponse({
    ServiceContract? contract,
  }) {
    final result = create();
    if (contract != null) result.contract = contract;
    return result;
  }

  RecordContractResponse._();

  factory RecordContractResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordContractResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordContractResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceContract>(1, _omitFieldNames ? '' : 'contract',
        subBuilder: ServiceContract.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordContractResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordContractResponse copyWith(
          void Function(RecordContractResponse) updates) =>
      super.copyWith((message) => updates(message as RecordContractResponse))
          as RecordContractResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordContractResponse create() => RecordContractResponse._();
  @$core.override
  RecordContractResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordContractResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordContractResponse>(create);
  static RecordContractResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceContract get contract => $_getN(0);
  @$pb.TagNumber(1)
  set contract(ServiceContract value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContract() => $_has(0);
  @$pb.TagNumber(1)
  void clearContract() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceContract ensureContract() => $_ensure(0);
}

class GetContractRequest extends $pb.GeneratedMessage {
  factory GetContractRequest({
    $core.String? contractId,
  }) {
    final result = create();
    if (contractId != null) result.contractId = contractId;
    return result;
  }

  GetContractRequest._();

  factory GetContractRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetContractRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetContractRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'contractId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContractRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContractRequest copyWith(void Function(GetContractRequest) updates) =>
      super.copyWith((message) => updates(message as GetContractRequest))
          as GetContractRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetContractRequest create() => GetContractRequest._();
  @$core.override
  GetContractRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetContractRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetContractRequest>(create);
  static GetContractRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get contractId => $_getSZ(0);
  @$pb.TagNumber(1)
  set contractId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasContractId() => $_has(0);
  @$pb.TagNumber(1)
  void clearContractId() => $_clearField(1);
}

class GetContractResponse extends $pb.GeneratedMessage {
  factory GetContractResponse({
    ServiceContract? contract,
  }) {
    final result = create();
    if (contract != null) result.contract = contract;
    return result;
  }

  GetContractResponse._();

  factory GetContractResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetContractResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetContractResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceContract>(1, _omitFieldNames ? '' : 'contract',
        subBuilder: ServiceContract.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContractResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetContractResponse copyWith(void Function(GetContractResponse) updates) =>
      super.copyWith((message) => updates(message as GetContractResponse))
          as GetContractResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetContractResponse create() => GetContractResponse._();
  @$core.override
  GetContractResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetContractResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetContractResponse>(create);
  static GetContractResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceContract get contract => $_getN(0);
  @$pb.TagNumber(1)
  set contract(ServiceContract value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContract() => $_has(0);
  @$pb.TagNumber(1)
  void clearContract() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceContract ensureContract() => $_ensure(0);
}

class ListContractsForAssetRequest extends $pb.GeneratedMessage {
  factory ListContractsForAssetRequest({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  ListContractsForAssetRequest._();

  factory ListContractsForAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListContractsForAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContractsForAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractsForAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractsForAssetRequest copyWith(
          void Function(ListContractsForAssetRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListContractsForAssetRequest))
          as ListContractsForAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListContractsForAssetRequest create() =>
      ListContractsForAssetRequest._();
  @$core.override
  ListContractsForAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListContractsForAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContractsForAssetRequest>(create);
  static ListContractsForAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class ListContractsForAssetResponse extends $pb.GeneratedMessage {
  factory ListContractsForAssetResponse({
    $core.Iterable<ServiceContract>? contracts,
  }) {
    final result = create();
    if (contracts != null) result.contracts.addAll(contracts);
    return result;
  }

  ListContractsForAssetResponse._();

  factory ListContractsForAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListContractsForAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListContractsForAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<ServiceContract>(1, _omitFieldNames ? '' : 'contracts',
        subBuilder: ServiceContract.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractsForAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListContractsForAssetResponse copyWith(
          void Function(ListContractsForAssetResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListContractsForAssetResponse))
          as ListContractsForAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListContractsForAssetResponse create() =>
      ListContractsForAssetResponse._();
  @$core.override
  ListContractsForAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListContractsForAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListContractsForAssetResponse>(create);
  static ListContractsForAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceContract> get contracts => $_getList(0);
}

class GetCoverForAssetRequest extends $pb.GeneratedMessage {
  factory GetCoverForAssetRequest({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  GetCoverForAssetRequest._();

  factory GetCoverForAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCoverForAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCoverForAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverForAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverForAssetRequest copyWith(
          void Function(GetCoverForAssetRequest) updates) =>
      super.copyWith((message) => updates(message as GetCoverForAssetRequest))
          as GetCoverForAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCoverForAssetRequest create() => GetCoverForAssetRequest._();
  @$core.override
  GetCoverForAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCoverForAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCoverForAssetRequest>(create);
  static GetCoverForAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

/// GetCoverForAssetResponse names the agreement that applies right now.
///
/// Answered by the server rather than left to the caller, because "the most
/// protective live contract" is a rule and three clients would each get it
/// slightly different.
class GetCoverForAssetResponse extends $pb.GeneratedMessage {
  factory GetCoverForAssetResponse({
    ServiceContract? contract,
    $core.bool? covered,
  }) {
    final result = create();
    if (contract != null) result.contract = contract;
    if (covered != null) result.covered = covered;
    return result;
  }

  GetCoverForAssetResponse._();

  factory GetCoverForAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCoverForAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCoverForAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceContract>(1, _omitFieldNames ? '' : 'contract',
        subBuilder: ServiceContract.create)
    ..aOB(2, _omitFieldNames ? '' : 'covered')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverForAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCoverForAssetResponse copyWith(
          void Function(GetCoverForAssetResponse) updates) =>
      super.copyWith((message) => updates(message as GetCoverForAssetResponse))
          as GetCoverForAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCoverForAssetResponse create() => GetCoverForAssetResponse._();
  @$core.override
  GetCoverForAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCoverForAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCoverForAssetResponse>(create);
  static GetCoverForAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceContract get contract => $_getN(0);
  @$pb.TagNumber(1)
  set contract(ServiceContract value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasContract() => $_has(0);
  @$pb.TagNumber(1)
  void clearContract() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceContract ensureContract() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get covered => $_getBF(1);
  @$pb.TagNumber(2)
  set covered($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCovered() => $_has(1);
  @$pb.TagNumber(2)
  void clearCovered() => $_clearField(2);
}

/// Expiry is one thing coming due (SRS-BIO-002, SRS-BIO-004).
class Expiry extends $pb.GeneratedMessage {
  factory Expiry({
    ExpiryKind? kind,
    $core.String? assetId,
    $core.String? assetTag,
    $core.String? reference,
    $core.String? vendorName,
    $0.Timestamp? expiresOn,
    $core.int? daysRemaining,
    $core.String? detail,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (reference != null) result.reference = reference;
    if (vendorName != null) result.vendorName = vendorName;
    if (expiresOn != null) result.expiresOn = expiresOn;
    if (daysRemaining != null) result.daysRemaining = daysRemaining;
    if (detail != null) result.detail = detail;
    return result;
  }

  Expiry._();

  factory Expiry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Expiry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Expiry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aE<ExpiryKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: ExpiryKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'assetTag')
    ..aOS(4, _omitFieldNames ? '' : 'reference')
    ..aOS(5, _omitFieldNames ? '' : 'vendorName')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'expiresOn',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'daysRemaining')
    ..aOS(8, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expiry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Expiry copyWith(void Function(Expiry) updates) =>
      super.copyWith((message) => updates(message as Expiry)) as Expiry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Expiry create() => Expiry._();
  @$core.override
  Expiry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Expiry getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Expiry>(create);
  static Expiry? _defaultInstance;

  @$pb.TagNumber(1)
  ExpiryKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ExpiryKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  /// The tag, so a reminder names the machine rather than a UUID.
  @$pb.TagNumber(3)
  $core.String get assetTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetTag() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reference => $_getSZ(3);
  @$pb.TagNumber(4)
  set reference($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReference() => $_has(3);
  @$pb.TagNumber(4)
  void clearReference() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get vendorName => $_getSZ(4);
  @$pb.TagNumber(5)
  set vendorName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVendorName() => $_has(4);
  @$pb.TagNumber(5)
  void clearVendorName() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get expiresOn => $_getN(5);
  @$pb.TagNumber(6)
  set expiresOn($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasExpiresOn() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresOn() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureExpiresOn() => $_ensure(5);

  /// Negative once it has lapsed, so one list holds both "renew this" and
  /// "this lapsed a month ago" and a reader can sort by it.
  @$pb.TagNumber(7)
  $core.int get daysRemaining => $_getIZ(6);
  @$pb.TagNumber(7)
  set daysRemaining($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDaysRemaining() => $_has(6);
  @$pb.TagNumber(7)
  void clearDaysRemaining() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get detail => $_getSZ(7);
  @$pb.TagNumber(8)
  set detail($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDetail() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetail() => $_clearField(8);
}

class ListExpiryRemindersRequest extends $pb.GeneratedMessage {
  factory ListExpiryRemindersRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListExpiryRemindersRequest._();

  factory ListExpiryRemindersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExpiryRemindersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExpiryRemindersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiryRemindersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiryRemindersRequest copyWith(
          void Function(ListExpiryRemindersRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListExpiryRemindersRequest))
          as ListExpiryRemindersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExpiryRemindersRequest create() => ListExpiryRemindersRequest._();
  @$core.override
  ListExpiryRemindersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExpiryRemindersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExpiryRemindersRequest>(create);
  static ListExpiryRemindersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListExpiryRemindersResponse extends $pb.GeneratedMessage {
  factory ListExpiryRemindersResponse({
    $core.Iterable<Expiry>? expiries,
  }) {
    final result = create();
    if (expiries != null) result.expiries.addAll(expiries);
    return result;
  }

  ListExpiryRemindersResponse._();

  factory ListExpiryRemindersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListExpiryRemindersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListExpiryRemindersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Expiry>(1, _omitFieldNames ? '' : 'expiries',
        subBuilder: Expiry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiryRemindersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListExpiryRemindersResponse copyWith(
          void Function(ListExpiryRemindersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListExpiryRemindersResponse))
          as ListExpiryRemindersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListExpiryRemindersResponse create() =>
      ListExpiryRemindersResponse._();
  @$core.override
  ListExpiryRemindersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListExpiryRemindersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListExpiryRemindersResponse>(create);
  static ListExpiryRemindersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Expiry> get expiries => $_getList(0);
}

/// PMPlan is a preventive maintenance schedule (SRS-BIO-003).
class PMPlan extends $pb.GeneratedMessage {
  factory PMPlan({
    $core.String? planId,
    $core.String? assetId,
    PlanBasis? basis,
    $core.int? intervalDays,
    $core.int? runtimeHours,
    $core.String? procedure,
    $core.int? estimatedMinutes,
    $0.Timestamp? lastPerformedAt,
    $core.int? lastRuntimeHours,
    $core.bool? active,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (assetId != null) result.assetId = assetId;
    if (basis != null) result.basis = basis;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (runtimeHours != null) result.runtimeHours = runtimeHours;
    if (procedure != null) result.procedure = procedure;
    if (estimatedMinutes != null) result.estimatedMinutes = estimatedMinutes;
    if (lastPerformedAt != null) result.lastPerformedAt = lastPerformedAt;
    if (lastRuntimeHours != null) result.lastRuntimeHours = lastRuntimeHours;
    if (active != null) result.active = active;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  PMPlan._();

  factory PMPlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PMPlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PMPlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aE<PlanBasis>(3, _omitFieldNames ? '' : 'basis',
        enumValues: PlanBasis.values)
    ..aI(4, _omitFieldNames ? '' : 'intervalDays')
    ..aI(5, _omitFieldNames ? '' : 'runtimeHours')
    ..aOS(6, _omitFieldNames ? '' : 'procedure')
    ..aI(7, _omitFieldNames ? '' : 'estimatedMinutes')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'lastPerformedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(9, _omitFieldNames ? '' : 'lastRuntimeHours')
    ..aOB(10, _omitFieldNames ? '' : 'active')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(13, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PMPlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PMPlan copyWith(void Function(PMPlan) updates) =>
      super.copyWith((message) => updates(message as PMPlan)) as PMPlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PMPlan create() => PMPlan._();
  @$core.override
  PMPlan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PMPlan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PMPlan>(create);
  static PMPlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  PlanBasis get basis => $_getN(2);
  @$pb.TagNumber(3)
  set basis(PlanBasis value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBasis() => $_has(2);
  @$pb.TagNumber(3)
  void clearBasis() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get intervalDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set intervalDays($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIntervalDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearIntervalDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get runtimeHours => $_getIZ(4);
  @$pb.TagNumber(5)
  set runtimeHours($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRuntimeHours() => $_has(4);
  @$pb.TagNumber(5)
  void clearRuntimeHours() => $_clearField(5);

  /// What the engineer is meant to do. Carried because a plan that says only
  /// "service it" produces a record that says only "serviced".
  @$pb.TagNumber(6)
  $core.String get procedure => $_getSZ(5);
  @$pb.TagNumber(6)
  set procedure($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasProcedure() => $_has(5);
  @$pb.TagNumber(6)
  void clearProcedure() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get estimatedMinutes => $_getIZ(6);
  @$pb.TagNumber(7)
  set estimatedMinutes($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEstimatedMinutes() => $_has(6);
  @$pb.TagNumber(7)
  void clearEstimatedMinutes() => $_clearField(7);

  /// The baseline the next due date is computed from. Advanced by closing
  /// planned work against the plan, never set directly.
  @$pb.TagNumber(8)
  $0.Timestamp get lastPerformedAt => $_getN(7);
  @$pb.TagNumber(8)
  set lastPerformedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasLastPerformedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastPerformedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureLastPerformedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get lastRuntimeHours => $_getIZ(8);
  @$pb.TagNumber(9)
  set lastRuntimeHours($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLastRuntimeHours() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastRuntimeHours() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get active => $_getBF(9);
  @$pb.TagNumber(10)
  set active($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasActive() => $_has(9);
  @$pb.TagNumber(10)
  void clearActive() => $_clearField(10);

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

class SchedulePlanRequest extends $pb.GeneratedMessage {
  factory SchedulePlanRequest({
    $core.String? assetId,
    PlanBasis? basis,
    $core.int? intervalDays,
    $core.int? runtimeHours,
    $core.String? procedure,
    $core.int? estimatedMinutes,
    $0.Timestamp? lastPerformedAt,
    $core.int? lastRuntimeHours,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (basis != null) result.basis = basis;
    if (intervalDays != null) result.intervalDays = intervalDays;
    if (runtimeHours != null) result.runtimeHours = runtimeHours;
    if (procedure != null) result.procedure = procedure;
    if (estimatedMinutes != null) result.estimatedMinutes = estimatedMinutes;
    if (lastPerformedAt != null) result.lastPerformedAt = lastPerformedAt;
    if (lastRuntimeHours != null) result.lastRuntimeHours = lastRuntimeHours;
    return result;
  }

  SchedulePlanRequest._();

  factory SchedulePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SchedulePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SchedulePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aE<PlanBasis>(2, _omitFieldNames ? '' : 'basis',
        enumValues: PlanBasis.values)
    ..aI(3, _omitFieldNames ? '' : 'intervalDays')
    ..aI(4, _omitFieldNames ? '' : 'runtimeHours')
    ..aOS(5, _omitFieldNames ? '' : 'procedure')
    ..aI(6, _omitFieldNames ? '' : 'estimatedMinutes')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'lastPerformedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'lastRuntimeHours')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulePlanRequest copyWith(void Function(SchedulePlanRequest) updates) =>
      super.copyWith((message) => updates(message as SchedulePlanRequest))
          as SchedulePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SchedulePlanRequest create() => SchedulePlanRequest._();
  @$core.override
  SchedulePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SchedulePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SchedulePlanRequest>(create);
  static SchedulePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  PlanBasis get basis => $_getN(1);
  @$pb.TagNumber(2)
  set basis(PlanBasis value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasBasis() => $_has(1);
  @$pb.TagNumber(2)
  void clearBasis() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get intervalDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set intervalDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIntervalDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntervalDays() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get runtimeHours => $_getIZ(3);
  @$pb.TagNumber(4)
  set runtimeHours($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRuntimeHours() => $_has(3);
  @$pb.TagNumber(4)
  void clearRuntimeHours() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get procedure => $_getSZ(4);
  @$pb.TagNumber(5)
  set procedure($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedure() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedure() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get estimatedMinutes => $_getIZ(5);
  @$pb.TagNumber(6)
  set estimatedMinutes($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEstimatedMinutes() => $_has(5);
  @$pb.TagNumber(6)
  void clearEstimatedMinutes() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get lastPerformedAt => $_getN(6);
  @$pb.TagNumber(7)
  set lastPerformedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLastPerformedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastPerformedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureLastPerformedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.int get lastRuntimeHours => $_getIZ(7);
  @$pb.TagNumber(8)
  set lastRuntimeHours($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLastRuntimeHours() => $_has(7);
  @$pb.TagNumber(8)
  void clearLastRuntimeHours() => $_clearField(8);
}

class SchedulePlanResponse extends $pb.GeneratedMessage {
  factory SchedulePlanResponse({
    PMPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  SchedulePlanResponse._();

  factory SchedulePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SchedulePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SchedulePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<PMPlan>(1, _omitFieldNames ? '' : 'plan', subBuilder: PMPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchedulePlanResponse copyWith(void Function(SchedulePlanResponse) updates) =>
      super.copyWith((message) => updates(message as SchedulePlanResponse))
          as SchedulePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SchedulePlanResponse create() => SchedulePlanResponse._();
  @$core.override
  SchedulePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SchedulePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SchedulePlanResponse>(create);
  static SchedulePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PMPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(PMPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  PMPlan ensurePlan() => $_ensure(0);
}

class RetirePlanRequest extends $pb.GeneratedMessage {
  factory RetirePlanRequest({
    $core.String? planId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  RetirePlanRequest._();

  factory RetirePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetirePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetirePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetirePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetirePlanRequest copyWith(void Function(RetirePlanRequest) updates) =>
      super.copyWith((message) => updates(message as RetirePlanRequest))
          as RetirePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetirePlanRequest create() => RetirePlanRequest._();
  @$core.override
  RetirePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetirePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetirePlanRequest>(create);
  static RetirePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

/// RetirePlanResponse returns the deactivated plan.
///
/// Deactivated rather than deleted: the closed tickets raised under it are the
/// evidence that maintenance was done, and a plan that vanishes takes the
/// compliance history with it.
class RetirePlanResponse extends $pb.GeneratedMessage {
  factory RetirePlanResponse({
    PMPlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  RetirePlanResponse._();

  factory RetirePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetirePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetirePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<PMPlan>(1, _omitFieldNames ? '' : 'plan', subBuilder: PMPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetirePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetirePlanResponse copyWith(void Function(RetirePlanResponse) updates) =>
      super.copyWith((message) => updates(message as RetirePlanResponse))
          as RetirePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetirePlanResponse create() => RetirePlanResponse._();
  @$core.override
  RetirePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetirePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetirePlanResponse>(create);
  static RetirePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PMPlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(PMPlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  PMPlan ensurePlan() => $_ensure(0);
}

class ListPlansRequest extends $pb.GeneratedMessage {
  factory ListPlansRequest({
    $core.String? assetId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPlansRequest._();

  factory ListPlansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansRequest copyWith(void Function(ListPlansRequest) updates) =>
      super.copyWith((message) => updates(message as ListPlansRequest))
          as ListPlansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlansRequest create() => ListPlansRequest._();
  @$core.override
  ListPlansRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlansRequest>(create);
  static ListPlansRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get activeOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set activeOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasActiveOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearActiveOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListPlansResponse extends $pb.GeneratedMessage {
  factory ListPlansResponse({
    $core.Iterable<PMPlan>? plans,
  }) {
    final result = create();
    if (plans != null) result.plans.addAll(plans);
    return result;
  }

  ListPlansResponse._();

  factory ListPlansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPlansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPlansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<PMPlan>(1, _omitFieldNames ? '' : 'plans', subBuilder: PMPlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPlansResponse copyWith(void Function(ListPlansResponse) updates) =>
      super.copyWith((message) => updates(message as ListPlansResponse))
          as ListPlansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPlansResponse create() => ListPlansResponse._();
  @$core.override
  ListPlansResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPlansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPlansResponse>(create);
  static ListPlansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PMPlan> get plans => $_getList(0);
}

/// Due is one planned service and where it stands (SRS-BIO-003).
class Due extends $pb.GeneratedMessage {
  factory Due({
    $core.String? planId,
    $core.String? assetId,
    $core.String? assetTag,
    PlanBasis? basis,
    $core.String? procedure,
    Criticality? criticality,
    DueState? state,
    $0.Timestamp? dueOn,
    $core.int? daysOverdue,
    $core.int? hoursRemaining,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (basis != null) result.basis = basis;
    if (procedure != null) result.procedure = procedure;
    if (criticality != null) result.criticality = criticality;
    if (state != null) result.state = state;
    if (dueOn != null) result.dueOn = dueOn;
    if (daysOverdue != null) result.daysOverdue = daysOverdue;
    if (hoursRemaining != null) result.hoursRemaining = hoursRemaining;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  Due._();

  factory Due.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Due.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Due',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'assetTag')
    ..aE<PlanBasis>(4, _omitFieldNames ? '' : 'basis',
        enumValues: PlanBasis.values)
    ..aOS(5, _omitFieldNames ? '' : 'procedure')
    ..aE<Criticality>(6, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aE<DueState>(7, _omitFieldNames ? '' : 'state',
        enumValues: DueState.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'dueOn',
        subBuilder: $0.Timestamp.create)
    ..aI(9, _omitFieldNames ? '' : 'daysOverdue')
    ..aI(10, _omitFieldNames ? '' : 'hoursRemaining')
    ..aOB(11, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Due clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Due copyWith(void Function(Due) updates) =>
      super.copyWith((message) => updates(message as Due)) as Due;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Due create() => Due._();
  @$core.override
  Due createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Due getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Due>(create);
  static Due? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetTag() => $_clearField(3);

  @$pb.TagNumber(4)
  PlanBasis get basis => $_getN(3);
  @$pb.TagNumber(4)
  set basis(PlanBasis value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasis() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get procedure => $_getSZ(4);
  @$pb.TagNumber(5)
  set procedure($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasProcedure() => $_has(4);
  @$pb.TagNumber(5)
  void clearProcedure() => $_clearField(5);

  @$pb.TagNumber(6)
  Criticality get criticality => $_getN(5);
  @$pb.TagNumber(6)
  set criticality(Criticality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCriticality() => $_has(5);
  @$pb.TagNumber(6)
  void clearCriticality() => $_clearField(6);

  @$pb.TagNumber(7)
  DueState get state => $_getN(6);
  @$pb.TagNumber(7)
  set state(DueState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  /// The calendar date for an interval or risk plan. Unset for a runtime plan,
  /// where the answer is a number of hours rather than a date.
  @$pb.TagNumber(8)
  $0.Timestamp get dueOn => $_getN(7);
  @$pb.TagNumber(8)
  set dueOn($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDueOn() => $_has(7);
  @$pb.TagNumber(8)
  void clearDueOn() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDueOn() => $_ensure(7);

  /// Positive once it has passed. Negative counts down.
  @$pb.TagNumber(9)
  $core.int get daysOverdue => $_getIZ(8);
  @$pb.TagNumber(9)
  set daysOverdue($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDaysOverdue() => $_has(8);
  @$pb.TagNumber(9)
  void clearDaysOverdue() => $_clearField(9);

  /// For a runtime plan: negative once the machine has run past its service.
  @$pb.TagNumber(10)
  $core.int get hoursRemaining => $_getIZ(9);
  @$pb.TagNumber(10)
  set hoursRemaining($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHoursRemaining() => $_has(9);
  @$pb.TagNumber(10)
  void clearHoursRemaining() => $_clearField(10);

  /// A runtime plan with no meter reading. Named rather than reported as
  /// not-due, because only one of "we do not know" and "it is fine" needs
  /// somebody to go and look.
  @$pb.TagNumber(11)
  $core.bool get unanswerable => $_getBF(10);
  @$pb.TagNumber(11)
  set unanswerable($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasUnanswerable() => $_has(10);
  @$pb.TagNumber(11)
  void clearUnanswerable() => $_clearField(11);
}

class ListDueMaintenanceRequest extends $pb.GeneratedMessage {
  factory ListDueMaintenanceRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDueMaintenanceRequest._();

  factory ListDueMaintenanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueMaintenanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueMaintenanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueMaintenanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueMaintenanceRequest copyWith(
          void Function(ListDueMaintenanceRequest) updates) =>
      super.copyWith((message) => updates(message as ListDueMaintenanceRequest))
          as ListDueMaintenanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueMaintenanceRequest create() => ListDueMaintenanceRequest._();
  @$core.override
  ListDueMaintenanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueMaintenanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueMaintenanceRequest>(create);
  static ListDueMaintenanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListDueMaintenanceResponse extends $pb.GeneratedMessage {
  factory ListDueMaintenanceResponse({
    $core.Iterable<Due>? due,
  }) {
    final result = create();
    if (due != null) result.due.addAll(due);
    return result;
  }

  ListDueMaintenanceResponse._();

  factory ListDueMaintenanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueMaintenanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueMaintenanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Due>(1, _omitFieldNames ? '' : 'due', subBuilder: Due.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueMaintenanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueMaintenanceResponse copyWith(
          void Function(ListDueMaintenanceResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueMaintenanceResponse))
          as ListDueMaintenanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueMaintenanceResponse create() => ListDueMaintenanceResponse._();
  @$core.override
  ListDueMaintenanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueMaintenanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueMaintenanceResponse>(create);
  static ListDueMaintenanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Due> get due => $_getList(0);
}

/// PartUsed is one component fitted during a repair (SRS-BIO-006).
class PartUsed extends $pb.GeneratedMessage {
  factory PartUsed({
    $core.String? code,
    $core.String? description,
    $core.String? materialsItemId,
    $core.int? quantity,
    $fixnum.Int64? costMinor,
    $core.bool? coveredByContract,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (description != null) result.description = description;
    if (materialsItemId != null) result.materialsItemId = materialsItemId;
    if (quantity != null) result.quantity = quantity;
    if (costMinor != null) result.costMinor = costMinor;
    if (coveredByContract != null) result.coveredByContract = coveredByContract;
    return result;
  }

  PartUsed._();

  factory PartUsed.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PartUsed.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PartUsed',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'materialsItemId')
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aInt64(5, _omitFieldNames ? '' : 'costMinor')
    ..aOB(6, _omitFieldNames ? '' : 'coveredByContract')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PartUsed clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PartUsed copyWith(void Function(PartUsed) updates) =>
      super.copyWith((message) => updates(message as PartUsed)) as PartUsed;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PartUsed create() => PartUsed._();
  @$core.override
  PartUsed createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PartUsed getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PartUsed>(create);
  static PartUsed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  /// Where the part came from stock, so the two ledgers can be reconciled.
  @$pb.TagNumber(3)
  $core.String get materialsItemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set materialsItemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMaterialsItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaterialsItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get costMinor => $_getI64(4);
  @$pb.TagNumber(5)
  set costMinor($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCostMinor() => $_has(4);
  @$pb.TagNumber(5)
  void clearCostMinor() => $_clearField(5);

  /// That somebody else paid. The number a contract renewal is argued with.
  @$pb.TagNumber(6)
  $core.bool get coveredByContract => $_getBF(5);
  @$pb.TagNumber(6)
  set coveredByContract($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCoveredByContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearCoveredByContract() => $_clearField(6);
}

/// Ticket is one breakdown or service request (SRS-BIO-005, SRS-BIO-006).
class Ticket extends $pb.GeneratedMessage {
  factory Ticket({
    $core.String? ticketId,
    $core.String? number,
    TicketKind? kind,
    $core.String? assetId,
    $core.String? planId,
    $core.String? assetTag,
    $core.String? locationId,
    $core.String? symptom,
    Priority? priority,
    Impact? impact,
    TicketState? state,
    $core.String? ownerId,
    $0.Timestamp? respondBy,
    $0.Timestamp? resolveBy,
    $core.String? contractId,
    $core.String? diagnosis,
    $core.String? workPerformed,
    $core.Iterable<PartUsed>? parts,
    $0.Timestamp? downFrom,
    $0.Timestamp? downUntil,
    $core.int? awaitingPartsMinutes,
    $0.Timestamp? respondedAt,
    $0.Timestamp? resolvedAt,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureNote,
    $core.String? cancelledReason,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (number != null) result.number = number;
    if (kind != null) result.kind = kind;
    if (assetId != null) result.assetId = assetId;
    if (planId != null) result.planId = planId;
    if (assetTag != null) result.assetTag = assetTag;
    if (locationId != null) result.locationId = locationId;
    if (symptom != null) result.symptom = symptom;
    if (priority != null) result.priority = priority;
    if (impact != null) result.impact = impact;
    if (state != null) result.state = state;
    if (ownerId != null) result.ownerId = ownerId;
    if (respondBy != null) result.respondBy = respondBy;
    if (resolveBy != null) result.resolveBy = resolveBy;
    if (contractId != null) result.contractId = contractId;
    if (diagnosis != null) result.diagnosis = diagnosis;
    if (workPerformed != null) result.workPerformed = workPerformed;
    if (parts != null) result.parts.addAll(parts);
    if (downFrom != null) result.downFrom = downFrom;
    if (downUntil != null) result.downUntil = downUntil;
    if (awaitingPartsMinutes != null)
      result.awaitingPartsMinutes = awaitingPartsMinutes;
    if (respondedAt != null) result.respondedAt = respondedAt;
    if (resolvedAt != null) result.resolvedAt = resolvedAt;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureNote != null) result.closureNote = closureNote;
    if (cancelledReason != null) result.cancelledReason = cancelledReason;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (version != null) result.version = version;
    return result;
  }

  Ticket._();

  factory Ticket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ticket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ticket',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aE<TicketKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: TicketKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'assetId')
    ..aOS(5, _omitFieldNames ? '' : 'planId')
    ..aOS(6, _omitFieldNames ? '' : 'assetTag')
    ..aOS(7, _omitFieldNames ? '' : 'locationId')
    ..aOS(8, _omitFieldNames ? '' : 'symptom')
    ..aE<Priority>(9, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aE<Impact>(10, _omitFieldNames ? '' : 'impact', enumValues: Impact.values)
    ..aE<TicketState>(11, _omitFieldNames ? '' : 'state',
        enumValues: TicketState.values)
    ..aOS(12, _omitFieldNames ? '' : 'ownerId')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'respondBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'resolveBy',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'contractId')
    ..aOS(16, _omitFieldNames ? '' : 'diagnosis')
    ..aOS(17, _omitFieldNames ? '' : 'workPerformed')
    ..pPM<PartUsed>(18, _omitFieldNames ? '' : 'parts',
        subBuilder: PartUsed.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'downFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'downUntil',
        subBuilder: $0.Timestamp.create)
    ..aI(21, _omitFieldNames ? '' : 'awaitingPartsMinutes')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'respondedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'resolvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(24, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(25, _omitFieldNames ? '' : 'closedBy')
    ..aOS(26, _omitFieldNames ? '' : 'closureNote')
    ..aOS(27, _omitFieldNames ? '' : 'cancelledReason')
    ..aOM<$0.Timestamp>(28, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(29, _omitFieldNames ? '' : 'raisedBy')
    ..aInt64(30, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ticket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ticket copyWith(void Function(Ticket) updates) =>
      super.copyWith((message) => updates(message as Ticket)) as Ticket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ticket create() => Ticket._();
  @$core.override
  Ticket createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ticket getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ticket>(create);
  static Ticket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  TicketKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(TicketKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get assetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetId() => $_clearField(4);

  /// The plan this work was raised against, where it was. PM compliance is
  /// counted along this: a closed ticket naming no plan is not evidence that a
  /// plan was followed.
  @$pb.TagNumber(5)
  $core.String get planId => $_getSZ(4);
  @$pb.TagNumber(5)
  set planId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPlanId() => $_has(4);
  @$pb.TagNumber(5)
  void clearPlanId() => $_clearField(5);

  /// Carried so a closed ticket still names the machine after the asset is
  /// re-tagged or moved.
  @$pb.TagNumber(6)
  $core.String get assetTag => $_getSZ(5);
  @$pb.TagNumber(6)
  set assetTag($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAssetTag() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssetTag() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get locationId => $_getSZ(6);
  @$pb.TagNumber(7)
  set locationId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLocationId() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocationId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get symptom => $_getSZ(7);
  @$pb.TagNumber(8)
  set symptom($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSymptom() => $_has(7);
  @$pb.TagNumber(8)
  void clearSymptom() => $_clearField(8);

  @$pb.TagNumber(9)
  Priority get priority => $_getN(8);
  @$pb.TagNumber(9)
  set priority(Priority value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasPriority() => $_has(8);
  @$pb.TagNumber(9)
  void clearPriority() => $_clearField(9);

  @$pb.TagNumber(10)
  Impact get impact => $_getN(9);
  @$pb.TagNumber(10)
  set impact(Impact value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasImpact() => $_has(9);
  @$pb.TagNumber(10)
  void clearImpact() => $_clearField(10);

  @$pb.TagNumber(11)
  TicketState get state => $_getN(10);
  @$pb.TagNumber(11)
  set state(TicketState value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasState() => $_has(10);
  @$pb.TagNumber(11)
  void clearState() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get ownerId => $_getSZ(11);
  @$pb.TagNumber(12)
  set ownerId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasOwnerId() => $_has(11);
  @$pb.TagNumber(12)
  void clearOwnerId() => $_clearField(12);

  /// Derived from the asset's live contract and tightened by priority. Frozen
  /// on the ticket, because the contract may lapse before the ticket closes
  /// and the promise that applied is the one it was raised under. Read-only:
  /// a request cannot set them.
  @$pb.TagNumber(13)
  $0.Timestamp get respondBy => $_getN(12);
  @$pb.TagNumber(13)
  set respondBy($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasRespondBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRespondBy() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureRespondBy() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get resolveBy => $_getN(13);
  @$pb.TagNumber(14)
  set resolveBy($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasResolveBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearResolveBy() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureResolveBy() => $_ensure(13);

  /// Which agreement set them, so an SLA breach can be taken to the right
  /// vendor.
  @$pb.TagNumber(15)
  $core.String get contractId => $_getSZ(14);
  @$pb.TagNumber(15)
  set contractId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasContractId() => $_has(14);
  @$pb.TagNumber(15)
  void clearContractId() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get diagnosis => $_getSZ(15);
  @$pb.TagNumber(16)
  set diagnosis($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDiagnosis() => $_has(15);
  @$pb.TagNumber(16)
  void clearDiagnosis() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get workPerformed => $_getSZ(16);
  @$pb.TagNumber(17)
  set workPerformed($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasWorkPerformed() => $_has(16);
  @$pb.TagNumber(17)
  void clearWorkPerformed() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<PartUsed> get parts => $_getList(17);

  /// The outage. Separate from the ticket's own timestamps because a machine
  /// can be reported on Monday and have failed on Friday, and uptime is
  /// measured from when it stopped working.
  @$pb.TagNumber(19)
  $0.Timestamp get downFrom => $_getN(18);
  @$pb.TagNumber(19)
  set downFrom($0.Timestamp value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasDownFrom() => $_has(18);
  @$pb.TagNumber(19)
  void clearDownFrom() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureDownFrom() => $_ensure(18);

  @$pb.TagNumber(20)
  $0.Timestamp get downUntil => $_getN(19);
  @$pb.TagNumber(20)
  set downUntil($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasDownUntil() => $_has(19);
  @$pb.TagNumber(20)
  void clearDownUntil() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureDownUntil() => $_ensure(19);

  @$pb.TagNumber(21)
  $core.int get awaitingPartsMinutes => $_getIZ(20);
  @$pb.TagNumber(21)
  set awaitingPartsMinutes($core.int value) => $_setSignedInt32(20, value);
  @$pb.TagNumber(21)
  $core.bool hasAwaitingPartsMinutes() => $_has(20);
  @$pb.TagNumber(21)
  void clearAwaitingPartsMinutes() => $_clearField(21);

  @$pb.TagNumber(22)
  $0.Timestamp get respondedAt => $_getN(21);
  @$pb.TagNumber(22)
  set respondedAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasRespondedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearRespondedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureRespondedAt() => $_ensure(21);

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

  /// Never the engineer who did the work.
  @$pb.TagNumber(25)
  $core.String get closedBy => $_getSZ(24);
  @$pb.TagNumber(25)
  set closedBy($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasClosedBy() => $_has(24);
  @$pb.TagNumber(25)
  void clearClosedBy() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.String get closureNote => $_getSZ(25);
  @$pb.TagNumber(26)
  set closureNote($core.String value) => $_setString(25, value);
  @$pb.TagNumber(26)
  $core.bool hasClosureNote() => $_has(25);
  @$pb.TagNumber(26)
  void clearClosureNote() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get cancelledReason => $_getSZ(26);
  @$pb.TagNumber(27)
  set cancelledReason($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasCancelledReason() => $_has(26);
  @$pb.TagNumber(27)
  void clearCancelledReason() => $_clearField(27);

  @$pb.TagNumber(28)
  $0.Timestamp get raisedAt => $_getN(27);
  @$pb.TagNumber(28)
  set raisedAt($0.Timestamp value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasRaisedAt() => $_has(27);
  @$pb.TagNumber(28)
  void clearRaisedAt() => $_clearField(28);
  @$pb.TagNumber(28)
  $0.Timestamp ensureRaisedAt() => $_ensure(27);

  @$pb.TagNumber(29)
  $core.String get raisedBy => $_getSZ(28);
  @$pb.TagNumber(29)
  set raisedBy($core.String value) => $_setString(28, value);
  @$pb.TagNumber(29)
  $core.bool hasRaisedBy() => $_has(28);
  @$pb.TagNumber(29)
  void clearRaisedBy() => $_clearField(29);

  @$pb.TagNumber(30)
  $fixnum.Int64 get version => $_getI64(29);
  @$pb.TagNumber(30)
  set version($fixnum.Int64 value) => $_setInt64(29, value);
  @$pb.TagNumber(30)
  $core.bool hasVersion() => $_has(29);
  @$pb.TagNumber(30)
  void clearVersion() => $_clearField(30);
}

class RaiseTicketRequest extends $pb.GeneratedMessage {
  factory RaiseTicketRequest({
    TicketKind? kind,
    $core.String? assetId,
    $core.String? planId,
    $core.String? symptom,
    Priority? priority,
    Impact? impact,
    $0.Timestamp? downFrom,
    $core.String? number,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (assetId != null) result.assetId = assetId;
    if (planId != null) result.planId = planId;
    if (symptom != null) result.symptom = symptom;
    if (priority != null) result.priority = priority;
    if (impact != null) result.impact = impact;
    if (downFrom != null) result.downFrom = downFrom;
    if (number != null) result.number = number;
    return result;
  }

  RaiseTicketRequest._();

  factory RaiseTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aE<TicketKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: TicketKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'planId')
    ..aOS(4, _omitFieldNames ? '' : 'symptom')
    ..aE<Priority>(5, _omitFieldNames ? '' : 'priority',
        enumValues: Priority.values)
    ..aE<Impact>(6, _omitFieldNames ? '' : 'impact', enumValues: Impact.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'downFrom',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'number')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseTicketRequest copyWith(void Function(RaiseTicketRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseTicketRequest))
          as RaiseTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseTicketRequest create() => RaiseTicketRequest._();
  @$core.override
  RaiseTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseTicketRequest>(create);
  static RaiseTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TicketKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(TicketKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  /// Required for preventive work: planned work naming no plan cannot be
  /// counted towards compliance with one.
  @$pb.TagNumber(3)
  $core.String get planId => $_getSZ(2);
  @$pb.TagNumber(3)
  set planId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPlanId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPlanId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get symptom => $_getSZ(3);
  @$pb.TagNumber(4)
  set symptom($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSymptom() => $_has(3);
  @$pb.TagNumber(4)
  void clearSymptom() => $_clearField(4);

  @$pb.TagNumber(5)
  Priority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(Priority value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  Impact get impact => $_getN(5);
  @$pb.TagNumber(6)
  set impact(Impact value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasImpact() => $_has(5);
  @$pb.TagNumber(6)
  void clearImpact() => $_clearField(6);

  /// When the machine actually stopped, where the reporter knows. Unset takes
  /// the moment the ticket was raised, which understates downtime rather than
  /// inventing it.
  @$pb.TagNumber(7)
  $0.Timestamp get downFrom => $_getN(6);
  @$pb.TagNumber(7)
  set downFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDownFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearDownFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDownFrom() => $_ensure(6);

  /// The hospital's own work-order number, where it has one. Left empty the
  /// server assigns it.
  @$pb.TagNumber(8)
  $core.String get number => $_getSZ(7);
  @$pb.TagNumber(8)
  set number($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNumber() => $_has(7);
  @$pb.TagNumber(8)
  void clearNumber() => $_clearField(8);
}

class RaiseTicketResponse extends $pb.GeneratedMessage {
  factory RaiseTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  RaiseTicketResponse._();

  factory RaiseTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseTicketResponse copyWith(void Function(RaiseTicketResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseTicketResponse))
          as RaiseTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseTicketResponse create() => RaiseTicketResponse._();
  @$core.override
  RaiseTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseTicketResponse>(create);
  static RaiseTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class GetTicketRequest extends $pb.GeneratedMessage {
  factory GetTicketRequest({
    $core.String? ticketId,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    return result;
  }

  GetTicketRequest._();

  factory GetTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketRequest copyWith(void Function(GetTicketRequest) updates) =>
      super.copyWith((message) => updates(message as GetTicketRequest))
          as GetTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTicketRequest create() => GetTicketRequest._();
  @$core.override
  GetTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTicketRequest>(create);
  static GetTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);
}

class GetTicketResponse extends $pb.GeneratedMessage {
  factory GetTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  GetTicketResponse._();

  factory GetTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTicketResponse copyWith(void Function(GetTicketResponse) updates) =>
      super.copyWith((message) => updates(message as GetTicketResponse))
          as GetTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTicketResponse create() => GetTicketResponse._();
  @$core.override
  GetTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTicketResponse>(create);
  static GetTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class ListTicketsRequest extends $pb.GeneratedMessage {
  factory ListTicketsRequest({
    $core.String? assetId,
    TicketState? state,
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (state != null) result.state = state;
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListTicketsRequest._();

  factory ListTicketsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTicketsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTicketsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aE<TicketState>(2, _omitFieldNames ? '' : 'state',
        enumValues: TicketState.values)
    ..aOB(3, _omitFieldNames ? '' : 'openOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsRequest copyWith(void Function(ListTicketsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTicketsRequest))
          as ListTicketsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTicketsRequest create() => ListTicketsRequest._();
  @$core.override
  ListTicketsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTicketsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTicketsRequest>(create);
  static ListTicketsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  TicketState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(TicketState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get openOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set openOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOpenOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpenOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListTicketsResponse extends $pb.GeneratedMessage {
  factory ListTicketsResponse({
    $core.Iterable<Ticket>? tickets,
  }) {
    final result = create();
    if (tickets != null) result.tickets.addAll(tickets);
    return result;
  }

  ListTicketsResponse._();

  factory ListTicketsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTicketsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTicketsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Ticket>(1, _omitFieldNames ? '' : 'tickets',
        subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTicketsResponse copyWith(void Function(ListTicketsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTicketsResponse))
          as ListTicketsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTicketsResponse create() => ListTicketsResponse._();
  @$core.override
  ListTicketsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTicketsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTicketsResponse>(create);
  static ListTicketsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Ticket> get tickets => $_getList(0);
}

class AssignTicketRequest extends $pb.GeneratedMessage {
  factory AssignTicketRequest({
    $core.String? ticketId,
    $core.String? ownerId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (ownerId != null) result.ownerId = ownerId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  AssignTicketRequest._();

  factory AssignTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'ownerId')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTicketRequest copyWith(void Function(AssignTicketRequest) updates) =>
      super.copyWith((message) => updates(message as AssignTicketRequest))
          as AssignTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignTicketRequest create() => AssignTicketRequest._();
  @$core.override
  AssignTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignTicketRequest>(create);
  static AssignTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get ownerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set ownerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOwnerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearOwnerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class AssignTicketResponse extends $pb.GeneratedMessage {
  factory AssignTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  AssignTicketResponse._();

  factory AssignTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignTicketResponse copyWith(void Function(AssignTicketResponse) updates) =>
      super.copyWith((message) => updates(message as AssignTicketResponse))
          as AssignTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignTicketResponse create() => AssignTicketResponse._();
  @$core.override
  AssignTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignTicketResponse>(create);
  static AssignTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class StartTicketRequest extends $pb.GeneratedMessage {
  factory StartTicketRequest({
    $core.String? ticketId,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  StartTicketRequest._();

  factory StartTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aInt64(2, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTicketRequest copyWith(void Function(StartTicketRequest) updates) =>
      super.copyWith((message) => updates(message as StartTicketRequest))
          as StartTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTicketRequest create() => StartTicketRequest._();
  @$core.override
  StartTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTicketRequest>(create);
  static StartTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get expectedVersion => $_getI64(1);
  @$pb.TagNumber(2)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedVersion() => $_clearField(2);
}

class StartTicketResponse extends $pb.GeneratedMessage {
  factory StartTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  StartTicketResponse._();

  factory StartTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTicketResponse copyWith(void Function(StartTicketResponse) updates) =>
      super.copyWith((message) => updates(message as StartTicketResponse))
          as StartTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTicketResponse create() => StartTicketResponse._();
  @$core.override
  StartTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTicketResponse>(create);
  static StartTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class AwaitPartsRequest extends $pb.GeneratedMessage {
  factory AwaitPartsRequest({
    $core.String? ticketId,
    $core.String? note,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (note != null) result.note = note;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  AwaitPartsRequest._();

  factory AwaitPartsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AwaitPartsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AwaitPartsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwaitPartsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwaitPartsRequest copyWith(void Function(AwaitPartsRequest) updates) =>
      super.copyWith((message) => updates(message as AwaitPartsRequest))
          as AwaitPartsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AwaitPartsRequest create() => AwaitPartsRequest._();
  @$core.override
  AwaitPartsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AwaitPartsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AwaitPartsRequest>(create);
  static AwaitPartsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class AwaitPartsResponse extends $pb.GeneratedMessage {
  factory AwaitPartsResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  AwaitPartsResponse._();

  factory AwaitPartsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AwaitPartsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AwaitPartsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwaitPartsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AwaitPartsResponse copyWith(void Function(AwaitPartsResponse) updates) =>
      super.copyWith((message) => updates(message as AwaitPartsResponse))
          as AwaitPartsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AwaitPartsResponse create() => AwaitPartsResponse._();
  @$core.override
  AwaitPartsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AwaitPartsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AwaitPartsResponse>(create);
  static AwaitPartsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class CancelTicketRequest extends $pb.GeneratedMessage {
  factory CancelTicketRequest({
    $core.String? ticketId,
    $core.String? reason,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (reason != null) result.reason = reason;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CancelTicketRequest._();

  factory CancelTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTicketRequest copyWith(void Function(CancelTicketRequest) updates) =>
      super.copyWith((message) => updates(message as CancelTicketRequest))
          as CancelTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTicketRequest create() => CancelTicketRequest._();
  @$core.override
  CancelTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelTicketRequest>(create);
  static CancelTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

class CancelTicketResponse extends $pb.GeneratedMessage {
  factory CancelTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  CancelTicketResponse._();

  factory CancelTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTicketResponse copyWith(void Function(CancelTicketResponse) updates) =>
      super.copyWith((message) => updates(message as CancelTicketResponse))
          as CancelTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTicketResponse create() => CancelTicketResponse._();
  @$core.override
  CancelTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelTicketResponse>(create);
  static CancelTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class ResolveTicketRequest extends $pb.GeneratedMessage {
  factory ResolveTicketRequest({
    $core.String? ticketId,
    $core.String? diagnosis,
    $core.String? workPerformed,
    $core.Iterable<PartUsed>? parts,
    $0.Timestamp? backInServiceAt,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (diagnosis != null) result.diagnosis = diagnosis;
    if (workPerformed != null) result.workPerformed = workPerformed;
    if (parts != null) result.parts.addAll(parts);
    if (backInServiceAt != null) result.backInServiceAt = backInServiceAt;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  ResolveTicketRequest._();

  factory ResolveTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'diagnosis')
    ..aOS(3, _omitFieldNames ? '' : 'workPerformed')
    ..pPM<PartUsed>(4, _omitFieldNames ? '' : 'parts',
        subBuilder: PartUsed.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'backInServiceAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(6, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveTicketRequest copyWith(void Function(ResolveTicketRequest) updates) =>
      super.copyWith((message) => updates(message as ResolveTicketRequest))
          as ResolveTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveTicketRequest create() => ResolveTicketRequest._();
  @$core.override
  ResolveTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveTicketRequest>(create);
  static ResolveTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  /// What was wrong. Without it the history says a machine was fixed four
  /// times and nothing about whether it is the same fault.
  @$pb.TagNumber(2)
  $core.String get diagnosis => $_getSZ(1);
  @$pb.TagNumber(2)
  set diagnosis($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDiagnosis() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiagnosis() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get workPerformed => $_getSZ(2);
  @$pb.TagNumber(3)
  set workPerformed($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWorkPerformed() => $_has(2);
  @$pb.TagNumber(3)
  void clearWorkPerformed() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PartUsed> get parts => $_getList(3);

  /// When the machine worked again. Unset takes the moment of resolution.
  @$pb.TagNumber(5)
  $0.Timestamp get backInServiceAt => $_getN(4);
  @$pb.TagNumber(5)
  set backInServiceAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBackInServiceAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearBackInServiceAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureBackInServiceAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get expectedVersion => $_getI64(5);
  @$pb.TagNumber(6)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExpectedVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpectedVersion() => $_clearField(6);
}

class ResolveTicketResponse extends $pb.GeneratedMessage {
  factory ResolveTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  ResolveTicketResponse._();

  factory ResolveTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResolveTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResolveTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResolveTicketResponse copyWith(
          void Function(ResolveTicketResponse) updates) =>
      super.copyWith((message) => updates(message as ResolveTicketResponse))
          as ResolveTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveTicketResponse create() => ResolveTicketResponse._();
  @$core.override
  ResolveTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResolveTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResolveTicketResponse>(create);
  static ResolveTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

class CloseTicketRequest extends $pb.GeneratedMessage {
  factory CloseTicketRequest({
    $core.String? ticketId,
    $core.String? note,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (ticketId != null) result.ticketId = ticketId;
    if (note != null) result.note = note;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CloseTicketRequest._();

  factory CloseTicketRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseTicketRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseTicketRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'ticketId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTicketRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTicketRequest copyWith(void Function(CloseTicketRequest) updates) =>
      super.copyWith((message) => updates(message as CloseTicketRequest))
          as CloseTicketRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseTicketRequest create() => CloseTicketRequest._();
  @$core.override
  CloseTicketRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseTicketRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseTicketRequest>(create);
  static CloseTicketRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get ticketId => $_getSZ(0);
  @$pb.TagNumber(1)
  set ticketId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTicketId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicketId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

/// CloseTicketResponse returns the validated repair.
///
/// The caller is the validator, and it is never the engineer who did the work:
/// a repair signed off by the person who made it is the same claim twice.
class CloseTicketResponse extends $pb.GeneratedMessage {
  factory CloseTicketResponse({
    Ticket? ticket,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    return result;
  }

  CloseTicketResponse._();

  factory CloseTicketResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseTicketResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseTicketResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTicketResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseTicketResponse copyWith(void Function(CloseTicketResponse) updates) =>
      super.copyWith((message) => updates(message as CloseTicketResponse))
          as CloseTicketResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseTicketResponse create() => CloseTicketResponse._();
  @$core.override
  CloseTicketResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseTicketResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseTicketResponse>(create);
  static CloseTicketResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);
}

/// Breach is one work order past the promise it was raised under
/// (SRS-BIO-005).
class Breach extends $pb.GeneratedMessage {
  factory Breach({
    Ticket? ticket,
    $core.bool? responseBreached,
    $core.bool? resolutionBreached,
  }) {
    final result = create();
    if (ticket != null) result.ticket = ticket;
    if (responseBreached != null) result.responseBreached = responseBreached;
    if (resolutionBreached != null)
      result.resolutionBreached = resolutionBreached;
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Ticket>(1, _omitFieldNames ? '' : 'ticket', subBuilder: Ticket.create)
    ..aOB(2, _omitFieldNames ? '' : 'responseBreached')
    ..aOB(3, _omitFieldNames ? '' : 'resolutionBreached')
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
  Ticket get ticket => $_getN(0);
  @$pb.TagNumber(1)
  set ticket(Ticket value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTicket() => $_has(0);
  @$pb.TagNumber(1)
  void clearTicket() => $_clearField(1);
  @$pb.TagNumber(1)
  Ticket ensureTicket() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get responseBreached => $_getBF(1);
  @$pb.TagNumber(2)
  set responseBreached($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResponseBreached() => $_has(1);
  @$pb.TagNumber(2)
  void clearResponseBreached() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get resolutionBreached => $_getBF(2);
  @$pb.TagNumber(3)
  set resolutionBreached($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasResolutionBreached() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionBreached() => $_clearField(3);
}

class ListBreachesRequest extends $pb.GeneratedMessage {
  factory ListBreachesRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListBreachesRequest._();

  factory ListBreachesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBreachesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBreachesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBreachesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBreachesRequest copyWith(void Function(ListBreachesRequest) updates) =>
      super.copyWith((message) => updates(message as ListBreachesRequest))
          as ListBreachesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBreachesRequest create() => ListBreachesRequest._();
  @$core.override
  ListBreachesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBreachesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBreachesRequest>(create);
  static ListBreachesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListBreachesResponse extends $pb.GeneratedMessage {
  factory ListBreachesResponse({
    $core.Iterable<Breach>? breaches,
  }) {
    final result = create();
    if (breaches != null) result.breaches.addAll(breaches);
    return result;
  }

  ListBreachesResponse._();

  factory ListBreachesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBreachesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBreachesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Breach>(1, _omitFieldNames ? '' : 'breaches',
        subBuilder: Breach.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBreachesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBreachesResponse copyWith(void Function(ListBreachesResponse) updates) =>
      super.copyWith((message) => updates(message as ListBreachesResponse))
          as ListBreachesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBreachesResponse create() => ListBreachesResponse._();
  @$core.override
  ListBreachesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBreachesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBreachesResponse>(create);
  static ListBreachesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Breach> get breaches => $_getList(0);
}

/// SafetyNotice is a recall or field safety notice (SRS-BIO-008).
class SafetyNotice extends $pb.GeneratedMessage {
  factory SafetyNotice({
    $core.String? noticeId,
    $core.String? reference,
    NoticeKind? kind,
    $core.String? issuer,
    $core.String? summary,
    $core.String? make,
    $core.String? model,
    $core.String? serialFrom,
    $core.String? serialTo,
    $core.String? affectedUdi,
    $core.bool? holdAffected,
    $core.String? requiredAction,
    $0.Timestamp? dueBy,
    $0.Timestamp? issuedOn,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $0.Timestamp? closedAt,
    $core.String? closedBy,
    $core.String? closureNote,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (issuer != null) result.issuer = issuer;
    if (summary != null) result.summary = summary;
    if (make != null) result.make = make;
    if (model != null) result.model = model;
    if (serialFrom != null) result.serialFrom = serialFrom;
    if (serialTo != null) result.serialTo = serialTo;
    if (affectedUdi != null) result.affectedUdi = affectedUdi;
    if (holdAffected != null) result.holdAffected = holdAffected;
    if (requiredAction != null) result.requiredAction = requiredAction;
    if (dueBy != null) result.dueBy = dueBy;
    if (issuedOn != null) result.issuedOn = issuedOn;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (closedAt != null) result.closedAt = closedAt;
    if (closedBy != null) result.closedBy = closedBy;
    if (closureNote != null) result.closureNote = closureNote;
    if (version != null) result.version = version;
    return result;
  }

  SafetyNotice._();

  factory SafetyNotice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SafetyNotice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SafetyNotice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aE<NoticeKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: NoticeKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'issuer')
    ..aOS(5, _omitFieldNames ? '' : 'summary')
    ..aOS(6, _omitFieldNames ? '' : 'make')
    ..aOS(7, _omitFieldNames ? '' : 'model')
    ..aOS(8, _omitFieldNames ? '' : 'serialFrom')
    ..aOS(9, _omitFieldNames ? '' : 'serialTo')
    ..aOS(10, _omitFieldNames ? '' : 'affectedUdi')
    ..aOB(11, _omitFieldNames ? '' : 'holdAffected')
    ..aOS(12, _omitFieldNames ? '' : 'requiredAction')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'issuedOn',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'raisedBy')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'closedBy')
    ..aOS(19, _omitFieldNames ? '' : 'closureNote')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyNotice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SafetyNotice copyWith(void Function(SafetyNotice) updates) =>
      super.copyWith((message) => updates(message as SafetyNotice))
          as SafetyNotice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SafetyNotice create() => SafetyNotice._();
  @$core.override
  SafetyNotice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SafetyNotice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SafetyNotice>(create);
  static SafetyNotice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reference => $_getSZ(1);
  @$pb.TagNumber(2)
  set reference($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReference() => $_has(1);
  @$pb.TagNumber(2)
  void clearReference() => $_clearField(2);

  @$pb.TagNumber(3)
  NoticeKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(NoticeKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get issuer => $_getSZ(3);
  @$pb.TagNumber(4)
  set issuer($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIssuer() => $_has(3);
  @$pb.TagNumber(4)
  void clearIssuer() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get summary => $_getSZ(4);
  @$pb.TagNumber(5)
  set summary($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSummary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSummary() => $_clearField(5);

  /// How the notice names the equipment it covers, kept as it states them:
  /// the matching is only as good as what was written down, and a reader has
  /// to be able to check it.
  @$pb.TagNumber(6)
  $core.String get make => $_getSZ(5);
  @$pb.TagNumber(6)
  set make($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMake() => $_has(5);
  @$pb.TagNumber(6)
  void clearMake() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get model => $_getSZ(6);
  @$pb.TagNumber(7)
  set model($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasModel() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get serialFrom => $_getSZ(7);
  @$pb.TagNumber(8)
  set serialFrom($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSerialFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearSerialFrom() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get serialTo => $_getSZ(8);
  @$pb.TagNumber(9)
  set serialTo($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSerialTo() => $_has(8);
  @$pb.TagNumber(9)
  void clearSerialTo() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get affectedUdi => $_getSZ(9);
  @$pb.TagNumber(10)
  set affectedUdi($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAffectedUdi() => $_has(9);
  @$pb.TagNumber(10)
  void clearAffectedUdi() => $_clearField(10);

  /// Stop every matched asset. Always true for a recall.
  @$pb.TagNumber(11)
  $core.bool get holdAffected => $_getBF(10);
  @$pb.TagNumber(11)
  set holdAffected($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasHoldAffected() => $_has(10);
  @$pb.TagNumber(11)
  void clearHoldAffected() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get requiredAction => $_getSZ(11);
  @$pb.TagNumber(12)
  set requiredAction($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRequiredAction() => $_has(11);
  @$pb.TagNumber(12)
  void clearRequiredAction() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get dueBy => $_getN(12);
  @$pb.TagNumber(13)
  set dueBy($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasDueBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearDueBy() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureDueBy() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get issuedOn => $_getN(13);
  @$pb.TagNumber(14)
  set issuedOn($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasIssuedOn() => $_has(13);
  @$pb.TagNumber(14)
  void clearIssuedOn() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureIssuedOn() => $_ensure(13);

  @$pb.TagNumber(15)
  $0.Timestamp get raisedAt => $_getN(14);
  @$pb.TagNumber(15)
  set raisedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasRaisedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearRaisedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureRaisedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get raisedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set raisedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRaisedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearRaisedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get closedAt => $_getN(16);
  @$pb.TagNumber(17)
  set closedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasClosedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearClosedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureClosedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get closedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set closedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasClosedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearClosedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get closureNote => $_getSZ(18);
  @$pb.TagNumber(19)
  set closureNote($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasClosureNote() => $_has(18);
  @$pb.TagNumber(19)
  void clearClosureNote() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

/// NoticeTask is what has to be done to one asset under a notice
/// (SRS-BIO-008).
class NoticeTask extends $pb.GeneratedMessage {
  factory NoticeTask({
    $core.String? taskId,
    $core.String? noticeId,
    $core.String? assetId,
    $core.String? assetTag,
    TaskState? state,
    $core.String? note,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (noticeId != null) result.noticeId = noticeId;
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (state != null) result.state = state;
    if (note != null) result.note = note;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    return result;
  }

  NoticeTask._();

  factory NoticeTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NoticeTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NoticeTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'noticeId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..aOS(4, _omitFieldNames ? '' : 'assetTag')
    ..aE<TaskState>(5, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'completedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoticeTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NoticeTask copyWith(void Function(NoticeTask) updates) =>
      super.copyWith((message) => updates(message as NoticeTask)) as NoticeTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NoticeTask create() => NoticeTask._();
  @$core.override
  NoticeTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NoticeTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NoticeTask>(create);
  static NoticeTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get noticeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set noticeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNoticeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNoticeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get assetTag => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetTag($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssetTag() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetTag() => $_clearField(4);

  @$pb.TagNumber(5)
  TaskState get state => $_getN(4);
  @$pb.TagNumber(5)
  set state(TaskState value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasState() => $_has(4);
  @$pb.TagNumber(5)
  void clearState() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get completedAt => $_getN(6);
  @$pb.TagNumber(7)
  set completedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCompletedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompletedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCompletedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get completedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set completedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedBy() => $_clearField(8);
}

class RaiseNoticeRequest extends $pb.GeneratedMessage {
  factory RaiseNoticeRequest({
    $core.String? reference,
    NoticeKind? kind,
    $core.String? issuer,
    $core.String? summary,
    $core.String? make,
    $core.String? model,
    $core.String? serialFrom,
    $core.String? serialTo,
    $core.String? affectedUdi,
    $core.bool? holdAffected,
    $core.String? requiredAction,
    $0.Timestamp? dueBy,
    $0.Timestamp? issuedOn,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (kind != null) result.kind = kind;
    if (issuer != null) result.issuer = issuer;
    if (summary != null) result.summary = summary;
    if (make != null) result.make = make;
    if (model != null) result.model = model;
    if (serialFrom != null) result.serialFrom = serialFrom;
    if (serialTo != null) result.serialTo = serialTo;
    if (affectedUdi != null) result.affectedUdi = affectedUdi;
    if (holdAffected != null) result.holdAffected = holdAffected;
    if (requiredAction != null) result.requiredAction = requiredAction;
    if (dueBy != null) result.dueBy = dueBy;
    if (issuedOn != null) result.issuedOn = issuedOn;
    return result;
  }

  RaiseNoticeRequest._();

  factory RaiseNoticeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseNoticeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseNoticeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aE<NoticeKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: NoticeKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'issuer')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'make')
    ..aOS(6, _omitFieldNames ? '' : 'model')
    ..aOS(7, _omitFieldNames ? '' : 'serialFrom')
    ..aOS(8, _omitFieldNames ? '' : 'serialTo')
    ..aOS(9, _omitFieldNames ? '' : 'affectedUdi')
    ..aOB(10, _omitFieldNames ? '' : 'holdAffected')
    ..aOS(11, _omitFieldNames ? '' : 'requiredAction')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'dueBy',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'issuedOn',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseNoticeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseNoticeRequest copyWith(void Function(RaiseNoticeRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseNoticeRequest))
          as RaiseNoticeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseNoticeRequest create() => RaiseNoticeRequest._();
  @$core.override
  RaiseNoticeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseNoticeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseNoticeRequest>(create);
  static RaiseNoticeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reference => $_getSZ(0);
  @$pb.TagNumber(1)
  set reference($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReference() => $_has(0);
  @$pb.TagNumber(1)
  void clearReference() => $_clearField(1);

  @$pb.TagNumber(2)
  NoticeKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(NoticeKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get issuer => $_getSZ(2);
  @$pb.TagNumber(3)
  set issuer($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIssuer() => $_has(2);
  @$pb.TagNumber(3)
  void clearIssuer() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get make => $_getSZ(4);
  @$pb.TagNumber(5)
  set make($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMake() => $_has(4);
  @$pb.TagNumber(5)
  void clearMake() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get model => $_getSZ(5);
  @$pb.TagNumber(6)
  set model($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasModel() => $_has(5);
  @$pb.TagNumber(6)
  void clearModel() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get serialFrom => $_getSZ(6);
  @$pb.TagNumber(7)
  set serialFrom($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSerialFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearSerialFrom() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get serialTo => $_getSZ(7);
  @$pb.TagNumber(8)
  set serialTo($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSerialTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearSerialTo() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get affectedUdi => $_getSZ(8);
  @$pb.TagNumber(9)
  set affectedUdi($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAffectedUdi() => $_has(8);
  @$pb.TagNumber(9)
  void clearAffectedUdi() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get holdAffected => $_getBF(9);
  @$pb.TagNumber(10)
  set holdAffected($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasHoldAffected() => $_has(9);
  @$pb.TagNumber(10)
  void clearHoldAffected() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get requiredAction => $_getSZ(10);
  @$pb.TagNumber(11)
  set requiredAction($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRequiredAction() => $_has(10);
  @$pb.TagNumber(11)
  void clearRequiredAction() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get dueBy => $_getN(11);
  @$pb.TagNumber(12)
  set dueBy($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDueBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearDueBy() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDueBy() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get issuedOn => $_getN(12);
  @$pb.TagNumber(13)
  set issuedOn($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasIssuedOn() => $_has(12);
  @$pb.TagNumber(13)
  void clearIssuedOn() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureIssuedOn() => $_ensure(12);
}

/// RaiseNoticeResponse carries the tasks the notice produced.
///
/// Matched and held in the same transaction that recorded the notice: a recall
/// recorded now and swept later is a window in which the hospital has been
/// told and the equipment is still in use.
class RaiseNoticeResponse extends $pb.GeneratedMessage {
  factory RaiseNoticeResponse({
    SafetyNotice? notice,
    $core.Iterable<NoticeTask>? tasks,
  }) {
    final result = create();
    if (notice != null) result.notice = notice;
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  RaiseNoticeResponse._();

  factory RaiseNoticeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseNoticeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseNoticeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<SafetyNotice>(1, _omitFieldNames ? '' : 'notice',
        subBuilder: SafetyNotice.create)
    ..pPM<NoticeTask>(2, _omitFieldNames ? '' : 'tasks',
        subBuilder: NoticeTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseNoticeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseNoticeResponse copyWith(void Function(RaiseNoticeResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseNoticeResponse))
          as RaiseNoticeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseNoticeResponse create() => RaiseNoticeResponse._();
  @$core.override
  RaiseNoticeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseNoticeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseNoticeResponse>(create);
  static RaiseNoticeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SafetyNotice get notice => $_getN(0);
  @$pb.TagNumber(1)
  set notice(SafetyNotice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotice() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotice() => $_clearField(1);
  @$pb.TagNumber(1)
  SafetyNotice ensureNotice() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<NoticeTask> get tasks => $_getList(1);
}

class GetNoticeRequest extends $pb.GeneratedMessage {
  factory GetNoticeRequest({
    $core.String? noticeId,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    return result;
  }

  GetNoticeRequest._();

  factory GetNoticeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNoticeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNoticeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoticeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoticeRequest copyWith(void Function(GetNoticeRequest) updates) =>
      super.copyWith((message) => updates(message as GetNoticeRequest))
          as GetNoticeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNoticeRequest create() => GetNoticeRequest._();
  @$core.override
  GetNoticeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNoticeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNoticeRequest>(create);
  static GetNoticeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);
}

class GetNoticeResponse extends $pb.GeneratedMessage {
  factory GetNoticeResponse({
    SafetyNotice? notice,
  }) {
    final result = create();
    if (notice != null) result.notice = notice;
    return result;
  }

  GetNoticeResponse._();

  factory GetNoticeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetNoticeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetNoticeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<SafetyNotice>(1, _omitFieldNames ? '' : 'notice',
        subBuilder: SafetyNotice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoticeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetNoticeResponse copyWith(void Function(GetNoticeResponse) updates) =>
      super.copyWith((message) => updates(message as GetNoticeResponse))
          as GetNoticeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNoticeResponse create() => GetNoticeResponse._();
  @$core.override
  GetNoticeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetNoticeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetNoticeResponse>(create);
  static GetNoticeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SafetyNotice get notice => $_getN(0);
  @$pb.TagNumber(1)
  set notice(SafetyNotice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotice() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotice() => $_clearField(1);
  @$pb.TagNumber(1)
  SafetyNotice ensureNotice() => $_ensure(0);
}

class ListNoticesRequest extends $pb.GeneratedMessage {
  factory ListNoticesRequest({
    $core.bool? openOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (openOnly != null) result.openOnly = openOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListNoticesRequest._();

  factory ListNoticesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNoticesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNoticesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'openOnly')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticesRequest copyWith(void Function(ListNoticesRequest) updates) =>
      super.copyWith((message) => updates(message as ListNoticesRequest))
          as ListNoticesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNoticesRequest create() => ListNoticesRequest._();
  @$core.override
  ListNoticesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNoticesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNoticesRequest>(create);
  static ListNoticesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get openOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set openOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOpenOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearOpenOnly() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListNoticesResponse extends $pb.GeneratedMessage {
  factory ListNoticesResponse({
    $core.Iterable<SafetyNotice>? notices,
  }) {
    final result = create();
    if (notices != null) result.notices.addAll(notices);
    return result;
  }

  ListNoticesResponse._();

  factory ListNoticesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNoticesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNoticesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<SafetyNotice>(1, _omitFieldNames ? '' : 'notices',
        subBuilder: SafetyNotice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticesResponse copyWith(void Function(ListNoticesResponse) updates) =>
      super.copyWith((message) => updates(message as ListNoticesResponse))
          as ListNoticesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNoticesResponse create() => ListNoticesResponse._();
  @$core.override
  ListNoticesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNoticesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNoticesResponse>(create);
  static ListNoticesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SafetyNotice> get notices => $_getList(0);
}

class ListNoticeTasksRequest extends $pb.GeneratedMessage {
  factory ListNoticeTasksRequest({
    $core.String? noticeId,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    return result;
  }

  ListNoticeTasksRequest._();

  factory ListNoticeTasksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNoticeTasksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNoticeTasksRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticeTasksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticeTasksRequest copyWith(
          void Function(ListNoticeTasksRequest) updates) =>
      super.copyWith((message) => updates(message as ListNoticeTasksRequest))
          as ListNoticeTasksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNoticeTasksRequest create() => ListNoticeTasksRequest._();
  @$core.override
  ListNoticeTasksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNoticeTasksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNoticeTasksRequest>(create);
  static ListNoticeTasksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);
}

class ListNoticeTasksResponse extends $pb.GeneratedMessage {
  factory ListNoticeTasksResponse({
    $core.Iterable<NoticeTask>? tasks,
  }) {
    final result = create();
    if (tasks != null) result.tasks.addAll(tasks);
    return result;
  }

  ListNoticeTasksResponse._();

  factory ListNoticeTasksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListNoticeTasksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListNoticeTasksResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<NoticeTask>(1, _omitFieldNames ? '' : 'tasks',
        subBuilder: NoticeTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticeTasksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListNoticeTasksResponse copyWith(
          void Function(ListNoticeTasksResponse) updates) =>
      super.copyWith((message) => updates(message as ListNoticeTasksResponse))
          as ListNoticeTasksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNoticeTasksResponse create() => ListNoticeTasksResponse._();
  @$core.override
  ListNoticeTasksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListNoticeTasksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListNoticeTasksResponse>(create);
  static ListNoticeTasksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NoticeTask> get tasks => $_getList(0);
}

class AdvanceTaskRequest extends $pb.GeneratedMessage {
  factory AdvanceTaskRequest({
    $core.String? taskId,
    TaskState? state,
    $core.String? note,
    $core.bool? releaseHold,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (state != null) result.state = state;
    if (note != null) result.note = note;
    if (releaseHold != null) result.releaseHold = releaseHold;
    return result;
  }

  AdvanceTaskRequest._();

  factory AdvanceTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aE<TaskState>(2, _omitFieldNames ? '' : 'state',
        enumValues: TaskState.values)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOB(4, _omitFieldNames ? '' : 'releaseHold')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceTaskRequest copyWith(void Function(AdvanceTaskRequest) updates) =>
      super.copyWith((message) => updates(message as AdvanceTaskRequest))
          as AdvanceTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceTaskRequest create() => AdvanceTaskRequest._();
  @$core.override
  AdvanceTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceTaskRequest>(create);
  static AdvanceTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  TaskState get state => $_getN(1);
  @$pb.TagNumber(2)
  set state(TaskState value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  /// Required for NOT_AFFECTED: it is the one verdict that ends the enquiry.
  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  /// Lift the asset's safety hold as part of the step. Honoured only once the
  /// work is complete, and only when nothing else holds the machine.
  @$pb.TagNumber(4)
  $core.bool get releaseHold => $_getBF(3);
  @$pb.TagNumber(4)
  set releaseHold($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReleaseHold() => $_has(3);
  @$pb.TagNumber(4)
  void clearReleaseHold() => $_clearField(4);
}

class AdvanceTaskResponse extends $pb.GeneratedMessage {
  factory AdvanceTaskResponse({
    NoticeTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  AdvanceTaskResponse._();

  factory AdvanceTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvanceTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvanceTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<NoticeTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: NoticeTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvanceTaskResponse copyWith(void Function(AdvanceTaskResponse) updates) =>
      super.copyWith((message) => updates(message as AdvanceTaskResponse))
          as AdvanceTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvanceTaskResponse create() => AdvanceTaskResponse._();
  @$core.override
  AdvanceTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvanceTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvanceTaskResponse>(create);
  static AdvanceTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NoticeTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(NoticeTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  NoticeTask ensureTask() => $_ensure(0);
}

class TrackNoticeRequest extends $pb.GeneratedMessage {
  factory TrackNoticeRequest({
    $core.String? noticeId,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    return result;
  }

  TrackNoticeRequest._();

  factory TrackNoticeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackNoticeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackNoticeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackNoticeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackNoticeRequest copyWith(void Function(TrackNoticeRequest) updates) =>
      super.copyWith((message) => updates(message as TrackNoticeRequest))
          as TrackNoticeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackNoticeRequest create() => TrackNoticeRequest._();
  @$core.override
  TrackNoticeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrackNoticeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackNoticeRequest>(create);
  static TrackNoticeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);
}

/// TrackNoticeResponse reports how far a recall has got (SRS-BIO-008).
class TrackNoticeResponse extends $pb.GeneratedMessage {
  factory TrackNoticeResponse({
    $core.String? noticeId,
    $core.int? total,
    $core.int? outstanding,
    $core.int? inspected,
    $core.int? complete,
    $core.bool? overdue,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    if (total != null) result.total = total;
    if (outstanding != null) result.outstanding = outstanding;
    if (inspected != null) result.inspected = inspected;
    if (complete != null) result.complete = complete;
    if (overdue != null) result.overdue = overdue;
    return result;
  }

  TrackNoticeResponse._();

  factory TrackNoticeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackNoticeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackNoticeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..aI(2, _omitFieldNames ? '' : 'total')
    ..aI(3, _omitFieldNames ? '' : 'outstanding')
    ..aI(4, _omitFieldNames ? '' : 'inspected')
    ..aI(5, _omitFieldNames ? '' : 'complete')
    ..aOB(6, _omitFieldNames ? '' : 'overdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackNoticeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackNoticeResponse copyWith(void Function(TrackNoticeResponse) updates) =>
      super.copyWith((message) => updates(message as TrackNoticeResponse))
          as TrackNoticeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackNoticeResponse create() => TrackNoticeResponse._();
  @$core.override
  TrackNoticeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrackNoticeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackNoticeResponse>(create);
  static TrackNoticeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get total => $_getIZ(1);
  @$pb.TagNumber(2)
  set total($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotal() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotal() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get outstanding => $_getIZ(2);
  @$pb.TagNumber(3)
  set outstanding($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutstanding() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutstanding() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get inspected => $_getIZ(3);
  @$pb.TagNumber(4)
  set inspected($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInspected() => $_has(3);
  @$pb.TagNumber(4)
  void clearInspected() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get complete => $_getIZ(4);
  @$pb.TagNumber(5)
  set complete($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasComplete() => $_has(4);
  @$pb.TagNumber(5)
  void clearComplete() => $_clearField(5);

  /// Past the notice's due date with work still outstanding, which is what an
  /// inspection actually asks about.
  @$pb.TagNumber(6)
  $core.bool get overdue => $_getBF(5);
  @$pb.TagNumber(6)
  set overdue($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOverdue() => $_has(5);
  @$pb.TagNumber(6)
  void clearOverdue() => $_clearField(6);
}

class CloseNoticeRequest extends $pb.GeneratedMessage {
  factory CloseNoticeRequest({
    $core.String? noticeId,
    $core.String? note,
    $fixnum.Int64? expectedVersion,
  }) {
    final result = create();
    if (noticeId != null) result.noticeId = noticeId;
    if (note != null) result.note = note;
    if (expectedVersion != null) result.expectedVersion = expectedVersion;
    return result;
  }

  CloseNoticeRequest._();

  factory CloseNoticeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseNoticeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseNoticeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'noticeId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..aInt64(3, _omitFieldNames ? '' : 'expectedVersion')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseNoticeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseNoticeRequest copyWith(void Function(CloseNoticeRequest) updates) =>
      super.copyWith((message) => updates(message as CloseNoticeRequest))
          as CloseNoticeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseNoticeRequest create() => CloseNoticeRequest._();
  @$core.override
  CloseNoticeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseNoticeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseNoticeRequest>(create);
  static CloseNoticeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get noticeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set noticeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNoticeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoticeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expectedVersion => $_getI64(2);
  @$pb.TagNumber(3)
  set expectedVersion($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpectedVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpectedVersion() => $_clearField(3);
}

/// CloseNoticeResponse returns the signed-off notice.
///
/// Refused while any asset still has work outstanding: a notice closed over
/// unfinished work is a hospital that believes a recall was completed when it
/// was not.
class CloseNoticeResponse extends $pb.GeneratedMessage {
  factory CloseNoticeResponse({
    SafetyNotice? notice,
  }) {
    final result = create();
    if (notice != null) result.notice = notice;
    return result;
  }

  CloseNoticeResponse._();

  factory CloseNoticeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseNoticeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseNoticeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<SafetyNotice>(1, _omitFieldNames ? '' : 'notice',
        subBuilder: SafetyNotice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseNoticeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseNoticeResponse copyWith(void Function(CloseNoticeResponse) updates) =>
      super.copyWith((message) => updates(message as CloseNoticeResponse))
          as CloseNoticeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseNoticeResponse create() => CloseNoticeResponse._();
  @$core.override
  CloseNoticeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseNoticeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseNoticeResponse>(create);
  static CloseNoticeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SafetyNotice get notice => $_getN(0);
  @$pb.TagNumber(1)
  set notice(SafetyNotice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNotice() => $_has(0);
  @$pb.TagNumber(1)
  void clearNotice() => $_clearField(1);
  @$pb.TagNumber(1)
  SafetyNotice ensureNotice() => $_ensure(0);
}

/// Reading is one device telemetry sample (SRS-BIO-010).
class Reading extends $pb.GeneratedMessage {
  factory Reading({
    $core.String? readingId,
    $core.String? assetId,
    $core.String? metric,
    $core.double? value,
    $core.String? unit,
    $core.String? source,
    $core.bool? ingested,
    $0.Timestamp? observedAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (readingId != null) result.readingId = readingId;
    if (assetId != null) result.assetId = assetId;
    if (metric != null) result.metric = metric;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (source != null) result.source = source;
    if (ingested != null) result.ingested = ingested;
    if (observedAt != null) result.observedAt = observedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
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
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'readingId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'metric')
    ..aD(4, _omitFieldNames ? '' : 'value')
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..aOS(6, _omitFieldNames ? '' : 'source')
    ..aOB(7, _omitFieldNames ? '' : 'ingested')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'recordedBy')
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
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  /// What was measured — "runtime_hours", "chamber_temperature_c".
  @$pb.TagNumber(3)
  $core.String get metric => $_getSZ(2);
  @$pb.TagNumber(3)
  set metric($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMetric() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetric() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get value => $_getN(3);
  @$pb.TagNumber(4)
  set value($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  /// The device or gateway that reported it. A hand-entered meter reading and
  /// an ingested one are evidence of different weight.
  @$pb.TagNumber(6)
  $core.String get source => $_getSZ(5);
  @$pb.TagNumber(6)
  set source($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get ingested => $_getBF(6);
  @$pb.TagNumber(7)
  set ingested($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIngested() => $_has(6);
  @$pb.TagNumber(7)
  void clearIngested() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get observedAt => $_getN(7);
  @$pb.TagNumber(8)
  set observedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasObservedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearObservedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureObservedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get recordedAt => $_getN(8);
  @$pb.TagNumber(9)
  set recordedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasRecordedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecordedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureRecordedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get recordedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set recordedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedBy() => $_clearField(10);
}

class NewReading extends $pb.GeneratedMessage {
  factory NewReading({
    $core.String? assetId,
    $core.String? metric,
    $core.double? value,
    $core.String? unit,
    $core.String? source,
    $core.bool? ingested,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (metric != null) result.metric = metric;
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    if (source != null) result.source = source;
    if (ingested != null) result.ingested = ingested;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  NewReading._();

  factory NewReading.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NewReading.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NewReading',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'metric')
    ..aD(3, _omitFieldNames ? '' : 'value')
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..aOS(5, _omitFieldNames ? '' : 'source')
    ..aOB(6, _omitFieldNames ? '' : 'ingested')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewReading clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NewReading copyWith(void Function(NewReading) updates) =>
      super.copyWith((message) => updates(message as NewReading)) as NewReading;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NewReading create() => NewReading._();
  @$core.override
  NewReading createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NewReading getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NewReading>(create);
  static NewReading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metric => $_getSZ(1);
  @$pb.TagNumber(2)
  set metric($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get source => $_getSZ(4);
  @$pb.TagNumber(5)
  set source($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get ingested => $_getBF(5);
  @$pb.TagNumber(6)
  set ingested($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIngested() => $_has(5);
  @$pb.TagNumber(6)
  void clearIngested() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get observedAt => $_getN(6);
  @$pb.TagNumber(7)
  set observedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasObservedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearObservedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureObservedAt() => $_ensure(6);
}

/// AppendReadingsRequest is a batch, because a gateway reports a shift's worth
/// at a time and a half-ingested batch is a meter reading that jumps
/// backwards.
class AppendReadingsRequest extends $pb.GeneratedMessage {
  factory AppendReadingsRequest({
    $core.Iterable<NewReading>? readings,
  }) {
    final result = create();
    if (readings != null) result.readings.addAll(readings);
    return result;
  }

  AppendReadingsRequest._();

  factory AppendReadingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppendReadingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppendReadingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<NewReading>(1, _omitFieldNames ? '' : 'readings',
        subBuilder: NewReading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendReadingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendReadingsRequest copyWith(
          void Function(AppendReadingsRequest) updates) =>
      super.copyWith((message) => updates(message as AppendReadingsRequest))
          as AppendReadingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppendReadingsRequest create() => AppendReadingsRequest._();
  @$core.override
  AppendReadingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppendReadingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppendReadingsRequest>(create);
  static AppendReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NewReading> get readings => $_getList(0);
}

class AppendReadingsResponse extends $pb.GeneratedMessage {
  factory AppendReadingsResponse({
    $core.Iterable<Reading>? readings,
  }) {
    final result = create();
    if (readings != null) result.readings.addAll(readings);
    return result;
  }

  AppendReadingsResponse._();

  factory AppendReadingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppendReadingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppendReadingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Reading>(1, _omitFieldNames ? '' : 'readings',
        subBuilder: Reading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendReadingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendReadingsResponse copyWith(
          void Function(AppendReadingsResponse) updates) =>
      super.copyWith((message) => updates(message as AppendReadingsResponse))
          as AppendReadingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppendReadingsResponse create() => AppendReadingsResponse._();
  @$core.override
  AppendReadingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppendReadingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppendReadingsResponse>(create);
  static AppendReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reading> get readings => $_getList(0);
}

class ListReadingsRequest extends $pb.GeneratedMessage {
  factory ListReadingsRequest({
    $core.String? assetId,
    $core.String? metric,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (metric != null) result.metric = metric;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListReadingsRequest._();

  factory ListReadingsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReadingsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReadingsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'metric')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadingsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadingsRequest copyWith(void Function(ListReadingsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReadingsRequest))
          as ListReadingsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadingsRequest create() => ListReadingsRequest._();
  @$core.override
  ListReadingsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReadingsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReadingsRequest>(create);
  static ListReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get metric => $_getSZ(1);
  @$pb.TagNumber(2)
  set metric($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

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

class ListReadingsResponse extends $pb.GeneratedMessage {
  factory ListReadingsResponse({
    $core.Iterable<Reading>? readings,
  }) {
    final result = create();
    if (readings != null) result.readings.addAll(readings);
    return result;
  }

  ListReadingsResponse._();

  factory ListReadingsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReadingsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReadingsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Reading>(1, _omitFieldNames ? '' : 'readings',
        subBuilder: Reading.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadingsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReadingsResponse copyWith(void Function(ListReadingsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReadingsResponse))
          as ListReadingsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadingsResponse create() => ListReadingsResponse._();
  @$core.override
  ListReadingsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReadingsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReadingsResponse>(create);
  static ListReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Reading> get readings => $_getList(0);
}

/// Metrics are one machine's reliability figures (SRS-BIO-007).
class Metrics extends $pb.GeneratedMessage {
  factory Metrics({
    $core.String? assetId,
    $core.String? assetTag,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? periodMinutes,
    $core.int? downtimeMinutes,
    $core.int? uptimeMinutes,
    $core.double? uptimePercent,
    $core.int? failures,
    $core.int? plannedDowntimeMinutes,
    $core.double? mtbfHours,
    $core.double? mttrHours,
    $core.int? pmDue,
    $core.int? pmDone,
    $core.double? pmCompliance,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (periodMinutes != null) result.periodMinutes = periodMinutes;
    if (downtimeMinutes != null) result.downtimeMinutes = downtimeMinutes;
    if (uptimeMinutes != null) result.uptimeMinutes = uptimeMinutes;
    if (uptimePercent != null) result.uptimePercent = uptimePercent;
    if (failures != null) result.failures = failures;
    if (plannedDowntimeMinutes != null)
      result.plannedDowntimeMinutes = plannedDowntimeMinutes;
    if (mtbfHours != null) result.mtbfHours = mtbfHours;
    if (mttrHours != null) result.mttrHours = mttrHours;
    if (pmDue != null) result.pmDue = pmDue;
    if (pmDone != null) result.pmDone = pmDone;
    if (pmCompliance != null) result.pmCompliance = pmCompliance;
    if (incomplete != null) result.incomplete.addAll(incomplete);
    return result;
  }

  Metrics._();

  factory Metrics.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Metrics.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Metrics',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'assetTag')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'periodMinutes')
    ..aI(6, _omitFieldNames ? '' : 'downtimeMinutes')
    ..aI(7, _omitFieldNames ? '' : 'uptimeMinutes')
    ..aD(8, _omitFieldNames ? '' : 'uptimePercent')
    ..aI(9, _omitFieldNames ? '' : 'failures')
    ..aI(10, _omitFieldNames ? '' : 'plannedDowntimeMinutes')
    ..aD(11, _omitFieldNames ? '' : 'mtbfHours')
    ..aD(12, _omitFieldNames ? '' : 'mttrHours')
    ..aI(13, _omitFieldNames ? '' : 'pmDue')
    ..aI(14, _omitFieldNames ? '' : 'pmDone')
    ..aD(15, _omitFieldNames ? '' : 'pmCompliance')
    ..pPS(16, _omitFieldNames ? '' : 'incomplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metrics clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Metrics copyWith(void Function(Metrics) updates) =>
      super.copyWith((message) => updates(message as Metrics)) as Metrics;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Metrics create() => Metrics._();
  @$core.override
  Metrics createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Metrics getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Metrics>(create);
  static Metrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetTag => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetTag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetTag() => $_clearField(2);

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
  $core.int get periodMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set periodMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPeriodMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearPeriodMinutes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get downtimeMinutes => $_getIZ(5);
  @$pb.TagNumber(6)
  set downtimeMinutes($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDowntimeMinutes() => $_has(5);
  @$pb.TagNumber(6)
  void clearDowntimeMinutes() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get uptimeMinutes => $_getIZ(6);
  @$pb.TagNumber(7)
  set uptimeMinutes($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasUptimeMinutes() => $_has(6);
  @$pb.TagNumber(7)
  void clearUptimeMinutes() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get uptimePercent => $_getN(7);
  @$pb.TagNumber(8)
  set uptimePercent($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasUptimePercent() => $_has(7);
  @$pb.TagNumber(8)
  void clearUptimePercent() => $_clearField(8);

  /// Breakdowns only. Counting planned work would make a well-maintained
  /// machine look unreliable.
  @$pb.TagNumber(9)
  $core.int get failures => $_getIZ(8);
  @$pb.TagNumber(9)
  set failures($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFailures() => $_has(8);
  @$pb.TagNumber(9)
  void clearFailures() => $_clearField(9);

  /// Time out for scheduled work, reported beside the unplanned kind rather
  /// than mixed into it.
  @$pb.TagNumber(10)
  $core.int get plannedDowntimeMinutes => $_getIZ(9);
  @$pb.TagNumber(10)
  set plannedDowntimeMinutes($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasPlannedDowntimeMinutes() => $_has(9);
  @$pb.TagNumber(10)
  void clearPlannedDowntimeMinutes() => $_clearField(10);

  /// Zero failures gives zero rather than infinity, and is read alongside
  /// failures rather than as "never fails".
  @$pb.TagNumber(11)
  $core.double get mtbfHours => $_getN(10);
  @$pb.TagNumber(11)
  set mtbfHours($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasMtbfHours() => $_has(10);
  @$pb.TagNumber(11)
  void clearMtbfHours() => $_clearField(11);

  /// Over the repairs that finished. A machine still broken has no repair time
  /// yet, and including it would make this fall every time a ticket was left
  /// open.
  @$pb.TagNumber(12)
  $core.double get mttrHours => $_getN(11);
  @$pb.TagNumber(12)
  set mttrHours($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasMttrHours() => $_has(11);
  @$pb.TagNumber(12)
  void clearMttrHours() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get pmDue => $_getIZ(12);
  @$pb.TagNumber(13)
  set pmDue($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasPmDue() => $_has(12);
  @$pb.TagNumber(13)
  void clearPmDue() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get pmDone => $_getIZ(13);
  @$pb.TagNumber(14)
  set pmDone($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPmDone() => $_has(13);
  @$pb.TagNumber(14)
  void clearPmDone() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get pmCompliance => $_getN(14);
  @$pb.TagNumber(15)
  set pmCompliance($core.double value) => $_setDouble(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPmCompliance() => $_has(14);
  @$pb.TagNumber(15)
  void clearPmCompliance() => $_clearField(15);

  /// What a figure could not be built from, so a reader can tell a real zero
  /// from a gap.
  @$pb.TagNumber(16)
  $pb.PbList<$core.String> get incomplete => $_getList(15);
}

class GetAssetMetricsRequest extends $pb.GeneratedMessage {
  factory GetAssetMetricsRequest({
    $core.String? assetId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetAssetMetricsRequest._();

  factory GetAssetMetricsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetMetricsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetMetricsRequest copyWith(
          void Function(GetAssetMetricsRequest) updates) =>
      super.copyWith((message) => updates(message as GetAssetMetricsRequest))
          as GetAssetMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetMetricsRequest create() => GetAssetMetricsRequest._();
  @$core.override
  GetAssetMetricsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetMetricsRequest>(create);
  static GetAssetMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

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

class GetAssetMetricsResponse extends $pb.GeneratedMessage {
  factory GetAssetMetricsResponse({
    Metrics? metrics,
  }) {
    final result = create();
    if (metrics != null) result.metrics = metrics;
    return result;
  }

  GetAssetMetricsResponse._();

  factory GetAssetMetricsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAssetMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAssetMetricsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Metrics>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: Metrics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAssetMetricsResponse copyWith(
          void Function(GetAssetMetricsResponse) updates) =>
      super.copyWith((message) => updates(message as GetAssetMetricsResponse))
          as GetAssetMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetMetricsResponse create() => GetAssetMetricsResponse._();
  @$core.override
  GetAssetMetricsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAssetMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAssetMetricsResponse>(create);
  static GetAssetMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Metrics get metrics => $_getN(0);
  @$pb.TagNumber(1)
  set metrics(Metrics value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMetrics() => $_has(0);
  @$pb.TagNumber(1)
  void clearMetrics() => $_clearField(1);
  @$pb.TagNumber(1)
  Metrics ensureMetrics() => $_ensure(0);
}

/// FleetLine is one asset's place in the ranking (SRS-BIO-007).
class FleetLine extends $pb.GeneratedMessage {
  factory FleetLine({
    $core.String? assetId,
    $core.String? assetTag,
    Criticality? criticality,
    Metrics? metrics,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (criticality != null) result.criticality = criticality;
    if (metrics != null) result.metrics = metrics;
    return result;
  }

  FleetLine._();

  factory FleetLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FleetLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FleetLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'assetTag')
    ..aE<Criticality>(3, _omitFieldNames ? '' : 'criticality',
        enumValues: Criticality.values)
    ..aOM<Metrics>(4, _omitFieldNames ? '' : 'metrics',
        subBuilder: Metrics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FleetLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FleetLine copyWith(void Function(FleetLine) updates) =>
      super.copyWith((message) => updates(message as FleetLine)) as FleetLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FleetLine create() => FleetLine._();
  @$core.override
  FleetLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FleetLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FleetLine>(create);
  static FleetLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetTag => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetTag($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetTag() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetTag() => $_clearField(2);

  @$pb.TagNumber(3)
  Criticality get criticality => $_getN(2);
  @$pb.TagNumber(3)
  set criticality(Criticality value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCriticality() => $_has(2);
  @$pb.TagNumber(3)
  void clearCriticality() => $_clearField(3);

  @$pb.TagNumber(4)
  Metrics get metrics => $_getN(3);
  @$pb.TagNumber(4)
  set metrics(Metrics value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMetrics() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetrics() => $_clearField(4);
  @$pb.TagNumber(4)
  Metrics ensureMetrics() => $_ensure(3);
}

class GetFleetMetricsRequest extends $pb.GeneratedMessage {
  factory GetFleetMetricsRequest({
    $core.String? category,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetFleetMetricsRequest._();

  factory GetFleetMetricsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFleetMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFleetMetricsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFleetMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFleetMetricsRequest copyWith(
          void Function(GetFleetMetricsRequest) updates) =>
      super.copyWith((message) => updates(message as GetFleetMetricsRequest))
          as GetFleetMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFleetMetricsRequest create() => GetFleetMetricsRequest._();
  @$core.override
  GetFleetMetricsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFleetMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFleetMetricsRequest>(create);
  static GetFleetMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

/// GetFleetMetricsResponse ranks worst uptime first.
///
/// By uptime rather than by failure count: a machine that failed once for a
/// week is a worse problem than one that failed five times for an hour, and a
/// list sorted the other way puts the wrong one at the top.
class GetFleetMetricsResponse extends $pb.GeneratedMessage {
  factory GetFleetMetricsResponse({
    $core.Iterable<FleetLine>? lines,
  }) {
    final result = create();
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  GetFleetMetricsResponse._();

  factory GetFleetMetricsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFleetMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFleetMetricsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<FleetLine>(1, _omitFieldNames ? '' : 'lines',
        subBuilder: FleetLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFleetMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFleetMetricsResponse copyWith(
          void Function(GetFleetMetricsResponse) updates) =>
      super.copyWith((message) => updates(message as GetFleetMetricsResponse))
          as GetFleetMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFleetMetricsResponse create() => GetFleetMetricsResponse._();
  @$core.override
  GetFleetMetricsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFleetMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFleetMetricsResponse>(create);
  static GetFleetMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FleetLine> get lines => $_getList(0);
}

/// Disposal is one asset leaving the hospital (SRS-BIO-011).
class Disposal extends $pb.GeneratedMessage {
  factory Disposal({
    $core.String? disposalId,
    $core.String? assetId,
    $core.String? assetTag,
    $core.String? method,
    $core.String? reason,
    $core.String? requestedBy,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.bool? sanitisationRequired,
    $core.String? sanitisationMethod,
    $core.String? sanitisationCertificate,
    $core.String? sanitisedBy,
    $core.String? recipient,
    $fixnum.Int64? proceedsMinor,
    $0.Timestamp? disposedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (disposalId != null) result.disposalId = disposalId;
    if (assetId != null) result.assetId = assetId;
    if (assetTag != null) result.assetTag = assetTag;
    if (method != null) result.method = method;
    if (reason != null) result.reason = reason;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (sanitisationRequired != null)
      result.sanitisationRequired = sanitisationRequired;
    if (sanitisationMethod != null)
      result.sanitisationMethod = sanitisationMethod;
    if (sanitisationCertificate != null)
      result.sanitisationCertificate = sanitisationCertificate;
    if (sanitisedBy != null) result.sanitisedBy = sanitisedBy;
    if (recipient != null) result.recipient = recipient;
    if (proceedsMinor != null) result.proceedsMinor = proceedsMinor;
    if (disposedAt != null) result.disposedAt = disposedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Disposal._();

  factory Disposal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Disposal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Disposal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'disposalId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..aOS(3, _omitFieldNames ? '' : 'assetTag')
    ..aOS(4, _omitFieldNames ? '' : 'method')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aOS(6, _omitFieldNames ? '' : 'requestedBy')
    ..aOS(7, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(9, _omitFieldNames ? '' : 'sanitisationRequired')
    ..aOS(10, _omitFieldNames ? '' : 'sanitisationMethod')
    ..aOS(11, _omitFieldNames ? '' : 'sanitisationCertificate')
    ..aOS(12, _omitFieldNames ? '' : 'sanitisedBy')
    ..aOS(13, _omitFieldNames ? '' : 'recipient')
    ..aInt64(14, _omitFieldNames ? '' : 'proceedsMinor')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'disposedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Disposal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Disposal copyWith(void Function(Disposal) updates) =>
      super.copyWith((message) => updates(message as Disposal)) as Disposal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Disposal create() => Disposal._();
  @$core.override
  Disposal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Disposal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Disposal>(create);
  static Disposal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get disposalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set disposalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDisposalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisposalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetTag => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetTag($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssetTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetTag() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get method => $_getSZ(3);
  @$pb.TagNumber(4)
  set method($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMethod() => $_has(3);
  @$pb.TagNumber(4)
  void clearMethod() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get requestedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set requestedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRequestedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearRequestedBy() => $_clearField(6);

  /// Never the requester, and never a name the client supplied: it is the
  /// authenticated caller.
  @$pb.TagNumber(7)
  $core.String get approvedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set approvedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasApprovedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovedBy() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get approvedAt => $_getN(7);
  @$pb.TagNumber(8)
  set approvedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureApprovedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.bool get sanitisationRequired => $_getBF(8);
  @$pb.TagNumber(9)
  set sanitisationRequired($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSanitisationRequired() => $_has(8);
  @$pb.TagNumber(9)
  void clearSanitisationRequired() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sanitisationMethod => $_getSZ(9);
  @$pb.TagNumber(10)
  set sanitisationMethod($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSanitisationMethod() => $_has(9);
  @$pb.TagNumber(10)
  void clearSanitisationMethod() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get sanitisationCertificate => $_getSZ(10);
  @$pb.TagNumber(11)
  set sanitisationCertificate($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSanitisationCertificate() => $_has(10);
  @$pb.TagNumber(11)
  void clearSanitisationCertificate() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get sanitisedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set sanitisedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSanitisedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearSanitisedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get recipient => $_getSZ(12);
  @$pb.TagNumber(13)
  set recipient($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRecipient() => $_has(12);
  @$pb.TagNumber(13)
  void clearRecipient() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get proceedsMinor => $_getI64(13);
  @$pb.TagNumber(14)
  set proceedsMinor($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasProceedsMinor() => $_has(13);
  @$pb.TagNumber(14)
  void clearProceedsMinor() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get disposedAt => $_getN(14);
  @$pb.TagNumber(15)
  set disposedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasDisposedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearDisposedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureDisposedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get recordedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set recordedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasRecordedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearRecordedBy() => $_clearField(16);
}

class DisposeAssetRequest extends $pb.GeneratedMessage {
  factory DisposeAssetRequest({
    $core.String? assetId,
    $core.String? method,
    $core.String? reason,
    $core.String? requestedBy,
    $core.bool? sanitisationRequired,
    $core.String? sanitisationMethod,
    $core.String? sanitisationCertificate,
    $core.String? sanitisedBy,
    $core.String? recipient,
    $fixnum.Int64? proceedsMinor,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    if (method != null) result.method = method;
    if (reason != null) result.reason = reason;
    if (requestedBy != null) result.requestedBy = requestedBy;
    if (sanitisationRequired != null)
      result.sanitisationRequired = sanitisationRequired;
    if (sanitisationMethod != null)
      result.sanitisationMethod = sanitisationMethod;
    if (sanitisationCertificate != null)
      result.sanitisationCertificate = sanitisationCertificate;
    if (sanitisedBy != null) result.sanitisedBy = sanitisedBy;
    if (recipient != null) result.recipient = recipient;
    if (proceedsMinor != null) result.proceedsMinor = proceedsMinor;
    return result;
  }

  DisposeAssetRequest._();

  factory DisposeAssetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisposeAssetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisposeAssetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..aOS(2, _omitFieldNames ? '' : 'method')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'requestedBy')
    ..aOB(5, _omitFieldNames ? '' : 'sanitisationRequired')
    ..aOS(6, _omitFieldNames ? '' : 'sanitisationMethod')
    ..aOS(7, _omitFieldNames ? '' : 'sanitisationCertificate')
    ..aOS(8, _omitFieldNames ? '' : 'sanitisedBy')
    ..aOS(9, _omitFieldNames ? '' : 'recipient')
    ..aInt64(10, _omitFieldNames ? '' : 'proceedsMinor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeAssetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeAssetRequest copyWith(void Function(DisposeAssetRequest) updates) =>
      super.copyWith((message) => updates(message as DisposeAssetRequest))
          as DisposeAssetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisposeAssetRequest create() => DisposeAssetRequest._();
  @$core.override
  DisposeAssetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisposeAssetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisposeAssetRequest>(create);
  static DisposeAssetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get method => $_getSZ(1);
  @$pb.TagNumber(2)
  set method($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMethod() => $_has(1);
  @$pb.TagNumber(2)
  void clearMethod() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  /// Who asked for it. The approver is the caller, so naming yourself here is
  /// refused rather than recorded.
  @$pb.TagNumber(4)
  $core.String get requestedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set requestedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequestedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequestedBy() => $_clearField(4);

  /// True for anything that held patient data.
  @$pb.TagNumber(5)
  $core.bool get sanitisationRequired => $_getBF(4);
  @$pb.TagNumber(5)
  set sanitisationRequired($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSanitisationRequired() => $_has(4);
  @$pb.TagNumber(5)
  void clearSanitisationRequired() => $_clearField(5);

  /// The evidence, required where sanitisation is: a disposal recorded without
  /// them is a hard drive in a skip.
  @$pb.TagNumber(6)
  $core.String get sanitisationMethod => $_getSZ(5);
  @$pb.TagNumber(6)
  set sanitisationMethod($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSanitisationMethod() => $_has(5);
  @$pb.TagNumber(6)
  void clearSanitisationMethod() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sanitisationCertificate => $_getSZ(6);
  @$pb.TagNumber(7)
  set sanitisationCertificate($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSanitisationCertificate() => $_has(6);
  @$pb.TagNumber(7)
  void clearSanitisationCertificate() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sanitisedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set sanitisedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSanitisedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearSanitisedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get recipient => $_getSZ(8);
  @$pb.TagNumber(9)
  set recipient($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecipient() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecipient() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get proceedsMinor => $_getI64(9);
  @$pb.TagNumber(10)
  set proceedsMinor($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasProceedsMinor() => $_has(9);
  @$pb.TagNumber(10)
  void clearProceedsMinor() => $_clearField(10);
}

class DisposeAssetResponse extends $pb.GeneratedMessage {
  factory DisposeAssetResponse({
    Disposal? disposal,
  }) {
    final result = create();
    if (disposal != null) result.disposal = disposal;
    return result;
  }

  DisposeAssetResponse._();

  factory DisposeAssetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisposeAssetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisposeAssetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Disposal>(1, _omitFieldNames ? '' : 'disposal',
        subBuilder: Disposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeAssetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisposeAssetResponse copyWith(void Function(DisposeAssetResponse) updates) =>
      super.copyWith((message) => updates(message as DisposeAssetResponse))
          as DisposeAssetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisposeAssetResponse create() => DisposeAssetResponse._();
  @$core.override
  DisposeAssetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisposeAssetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisposeAssetResponse>(create);
  static DisposeAssetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Disposal get disposal => $_getN(0);
  @$pb.TagNumber(1)
  set disposal(Disposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDisposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisposal() => $_clearField(1);
  @$pb.TagNumber(1)
  Disposal ensureDisposal() => $_ensure(0);
}

class GetDisposalRequest extends $pb.GeneratedMessage {
  factory GetDisposalRequest({
    $core.String? assetId,
  }) {
    final result = create();
    if (assetId != null) result.assetId = assetId;
    return result;
  }

  GetDisposalRequest._();

  factory GetDisposalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDisposalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDisposalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assetId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDisposalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDisposalRequest copyWith(void Function(GetDisposalRequest) updates) =>
      super.copyWith((message) => updates(message as GetDisposalRequest))
          as GetDisposalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDisposalRequest create() => GetDisposalRequest._();
  @$core.override
  GetDisposalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDisposalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDisposalRequest>(create);
  static GetDisposalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assetId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetId() => $_clearField(1);
}

class GetDisposalResponse extends $pb.GeneratedMessage {
  factory GetDisposalResponse({
    Disposal? disposal,
  }) {
    final result = create();
    if (disposal != null) result.disposal = disposal;
    return result;
  }

  GetDisposalResponse._();

  factory GetDisposalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDisposalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDisposalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<Disposal>(1, _omitFieldNames ? '' : 'disposal',
        subBuilder: Disposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDisposalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDisposalResponse copyWith(void Function(GetDisposalResponse) updates) =>
      super.copyWith((message) => updates(message as GetDisposalResponse))
          as GetDisposalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDisposalResponse create() => GetDisposalResponse._();
  @$core.override
  GetDisposalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDisposalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDisposalResponse>(create);
  static GetDisposalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Disposal get disposal => $_getN(0);
  @$pb.TagNumber(1)
  set disposal(Disposal value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDisposal() => $_has(0);
  @$pb.TagNumber(1)
  void clearDisposal() => $_clearField(1);
  @$pb.TagNumber(1)
  Disposal ensureDisposal() => $_ensure(0);
}

class ListDisposalsRequest extends $pb.GeneratedMessage {
  factory ListDisposalsRequest({
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDisposalsRequest._();

  factory ListDisposalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDisposalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDisposalsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisposalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisposalsRequest copyWith(void Function(ListDisposalsRequest) updates) =>
      super.copyWith((message) => updates(message as ListDisposalsRequest))
          as ListDisposalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDisposalsRequest create() => ListDisposalsRequest._();
  @$core.override
  ListDisposalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDisposalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDisposalsRequest>(create);
  static ListDisposalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get from => $_getN(0);
  @$pb.TagNumber(1)
  set from($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureFrom() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get to => $_getN(1);
  @$pb.TagNumber(2)
  set to($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureTo() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListDisposalsResponse extends $pb.GeneratedMessage {
  factory ListDisposalsResponse({
    $core.Iterable<Disposal>? disposals,
  }) {
    final result = create();
    if (disposals != null) result.disposals.addAll(disposals);
    return result;
  }

  ListDisposalsResponse._();

  factory ListDisposalsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDisposalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDisposalsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.biomedical.v1'),
      createEmptyInstance: create)
    ..pPM<Disposal>(1, _omitFieldNames ? '' : 'disposals',
        subBuilder: Disposal.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisposalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDisposalsResponse copyWith(
          void Function(ListDisposalsResponse) updates) =>
      super.copyWith((message) => updates(message as ListDisposalsResponse))
          as ListDisposalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDisposalsResponse create() => ListDisposalsResponse._();
  @$core.override
  ListDisposalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDisposalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDisposalsResponse>(create);
  static ListDisposalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Disposal> get disposals => $_getList(0);
}

/// BiomedicalService is the biomedical engineering contract
/// (SRS-BIO-001 … 011).
class BiomedicalServiceApi {
  final $pb.RpcClient _client;

  BiomedicalServiceApi(this._client);

  /// The equipment register (SRS-BIO-001).
  $async.Future<RegisterAssetResponse> registerAsset(
          $pb.ClientContext? ctx, RegisterAssetRequest request) =>
      _client.invoke<RegisterAssetResponse>(ctx, 'BiomedicalService',
          'RegisterAsset', request, RegisterAssetResponse());
  $async.Future<GetAssetResponse> getAsset(
          $pb.ClientContext? ctx, GetAssetRequest request) =>
      _client.invoke<GetAssetResponse>(
          ctx, 'BiomedicalService', 'GetAsset', request, GetAssetResponse());
  $async.Future<GetAssetByTagResponse> getAssetByTag(
          $pb.ClientContext? ctx, GetAssetByTagRequest request) =>
      _client.invoke<GetAssetByTagResponse>(ctx, 'BiomedicalService',
          'GetAssetByTag', request, GetAssetByTagResponse());
  $async.Future<ListAssetsResponse> listAssets(
          $pb.ClientContext? ctx, ListAssetsRequest request) =>
      _client.invoke<ListAssetsResponse>(ctx, 'BiomedicalService', 'ListAssets',
          request, ListAssetsResponse());
  $async.Future<MoveAssetResponse> moveAsset(
          $pb.ClientContext? ctx, MoveAssetRequest request) =>
      _client.invoke<MoveAssetResponse>(
          ctx, 'BiomedicalService', 'MoveAsset', request, MoveAssetResponse());

  /// Calibration (SRS-BIO-004).
  $async.Future<RecordCalibrationResponse> recordCalibration(
          $pb.ClientContext? ctx, RecordCalibrationRequest request) =>
      _client.invoke<RecordCalibrationResponse>(ctx, 'BiomedicalService',
          'RecordCalibration', request, RecordCalibrationResponse());

  /// Equipment availability, which is what a room can be scheduled for
  /// (SRS-BIO-009).
  $async.Future<GetLocationCapabilityResponse> getLocationCapability(
          $pb.ClientContext? ctx, GetLocationCapabilityRequest request) =>
      _client.invoke<GetLocationCapabilityResponse>(ctx, 'BiomedicalService',
          'GetLocationCapability', request, GetLocationCapabilityResponse());

  /// Service contracts and renewal (SRS-BIO-002).
  $async.Future<RecordContractResponse> recordContract(
          $pb.ClientContext? ctx, RecordContractRequest request) =>
      _client.invoke<RecordContractResponse>(ctx, 'BiomedicalService',
          'RecordContract', request, RecordContractResponse());
  $async.Future<GetContractResponse> getContract(
          $pb.ClientContext? ctx, GetContractRequest request) =>
      _client.invoke<GetContractResponse>(ctx, 'BiomedicalService',
          'GetContract', request, GetContractResponse());
  $async.Future<ListContractsForAssetResponse> listContractsForAsset(
          $pb.ClientContext? ctx, ListContractsForAssetRequest request) =>
      _client.invoke<ListContractsForAssetResponse>(ctx, 'BiomedicalService',
          'ListContractsForAsset', request, ListContractsForAssetResponse());
  $async.Future<GetCoverForAssetResponse> getCoverForAsset(
          $pb.ClientContext? ctx, GetCoverForAssetRequest request) =>
      _client.invoke<GetCoverForAssetResponse>(ctx, 'BiomedicalService',
          'GetCoverForAsset', request, GetCoverForAssetResponse());
  $async.Future<ListExpiryRemindersResponse> listExpiryReminders(
          $pb.ClientContext? ctx, ListExpiryRemindersRequest request) =>
      _client.invoke<ListExpiryRemindersResponse>(ctx, 'BiomedicalService',
          'ListExpiryReminders', request, ListExpiryRemindersResponse());

  /// Preventive maintenance (SRS-BIO-003).
  $async.Future<SchedulePlanResponse> schedulePlan(
          $pb.ClientContext? ctx, SchedulePlanRequest request) =>
      _client.invoke<SchedulePlanResponse>(ctx, 'BiomedicalService',
          'SchedulePlan', request, SchedulePlanResponse());
  $async.Future<RetirePlanResponse> retirePlan(
          $pb.ClientContext? ctx, RetirePlanRequest request) =>
      _client.invoke<RetirePlanResponse>(ctx, 'BiomedicalService', 'RetirePlan',
          request, RetirePlanResponse());
  $async.Future<ListPlansResponse> listPlans(
          $pb.ClientContext? ctx, ListPlansRequest request) =>
      _client.invoke<ListPlansResponse>(
          ctx, 'BiomedicalService', 'ListPlans', request, ListPlansResponse());
  $async.Future<ListDueMaintenanceResponse> listDueMaintenance(
          $pb.ClientContext? ctx, ListDueMaintenanceRequest request) =>
      _client.invoke<ListDueMaintenanceResponse>(ctx, 'BiomedicalService',
          'ListDueMaintenance', request, ListDueMaintenanceResponse());

  /// Breakdown and service work (SRS-BIO-005, SRS-BIO-006).
  $async.Future<RaiseTicketResponse> raiseTicket(
          $pb.ClientContext? ctx, RaiseTicketRequest request) =>
      _client.invoke<RaiseTicketResponse>(ctx, 'BiomedicalService',
          'RaiseTicket', request, RaiseTicketResponse());
  $async.Future<GetTicketResponse> getTicket(
          $pb.ClientContext? ctx, GetTicketRequest request) =>
      _client.invoke<GetTicketResponse>(
          ctx, 'BiomedicalService', 'GetTicket', request, GetTicketResponse());
  $async.Future<ListTicketsResponse> listTickets(
          $pb.ClientContext? ctx, ListTicketsRequest request) =>
      _client.invoke<ListTicketsResponse>(ctx, 'BiomedicalService',
          'ListTickets', request, ListTicketsResponse());
  $async.Future<AssignTicketResponse> assignTicket(
          $pb.ClientContext? ctx, AssignTicketRequest request) =>
      _client.invoke<AssignTicketResponse>(ctx, 'BiomedicalService',
          'AssignTicket', request, AssignTicketResponse());
  $async.Future<StartTicketResponse> startTicket(
          $pb.ClientContext? ctx, StartTicketRequest request) =>
      _client.invoke<StartTicketResponse>(ctx, 'BiomedicalService',
          'StartTicket', request, StartTicketResponse());
  $async.Future<AwaitPartsResponse> awaitParts(
          $pb.ClientContext? ctx, AwaitPartsRequest request) =>
      _client.invoke<AwaitPartsResponse>(ctx, 'BiomedicalService', 'AwaitParts',
          request, AwaitPartsResponse());
  $async.Future<CancelTicketResponse> cancelTicket(
          $pb.ClientContext? ctx, CancelTicketRequest request) =>
      _client.invoke<CancelTicketResponse>(ctx, 'BiomedicalService',
          'CancelTicket', request, CancelTicketResponse());
  $async.Future<ResolveTicketResponse> resolveTicket(
          $pb.ClientContext? ctx, ResolveTicketRequest request) =>
      _client.invoke<ResolveTicketResponse>(ctx, 'BiomedicalService',
          'ResolveTicket', request, ResolveTicketResponse());
  $async.Future<CloseTicketResponse> closeTicket(
          $pb.ClientContext? ctx, CloseTicketRequest request) =>
      _client.invoke<CloseTicketResponse>(ctx, 'BiomedicalService',
          'CloseTicket', request, CloseTicketResponse());
  $async.Future<ListBreachesResponse> listBreaches(
          $pb.ClientContext? ctx, ListBreachesRequest request) =>
      _client.invoke<ListBreachesResponse>(ctx, 'BiomedicalService',
          'ListBreaches', request, ListBreachesResponse());

  /// Recalls and field safety notices (SRS-BIO-008).
  $async.Future<RaiseNoticeResponse> raiseNotice(
          $pb.ClientContext? ctx, RaiseNoticeRequest request) =>
      _client.invoke<RaiseNoticeResponse>(ctx, 'BiomedicalService',
          'RaiseNotice', request, RaiseNoticeResponse());
  $async.Future<GetNoticeResponse> getNotice(
          $pb.ClientContext? ctx, GetNoticeRequest request) =>
      _client.invoke<GetNoticeResponse>(
          ctx, 'BiomedicalService', 'GetNotice', request, GetNoticeResponse());
  $async.Future<ListNoticesResponse> listNotices(
          $pb.ClientContext? ctx, ListNoticesRequest request) =>
      _client.invoke<ListNoticesResponse>(ctx, 'BiomedicalService',
          'ListNotices', request, ListNoticesResponse());
  $async.Future<ListNoticeTasksResponse> listNoticeTasks(
          $pb.ClientContext? ctx, ListNoticeTasksRequest request) =>
      _client.invoke<ListNoticeTasksResponse>(ctx, 'BiomedicalService',
          'ListNoticeTasks', request, ListNoticeTasksResponse());
  $async.Future<AdvanceTaskResponse> advanceTask(
          $pb.ClientContext? ctx, AdvanceTaskRequest request) =>
      _client.invoke<AdvanceTaskResponse>(ctx, 'BiomedicalService',
          'AdvanceTask', request, AdvanceTaskResponse());
  $async.Future<TrackNoticeResponse> trackNotice(
          $pb.ClientContext? ctx, TrackNoticeRequest request) =>
      _client.invoke<TrackNoticeResponse>(ctx, 'BiomedicalService',
          'TrackNotice', request, TrackNoticeResponse());
  $async.Future<CloseNoticeResponse> closeNotice(
          $pb.ClientContext? ctx, CloseNoticeRequest request) =>
      _client.invoke<CloseNoticeResponse>(ctx, 'BiomedicalService',
          'CloseNotice', request, CloseNoticeResponse());

  /// Safety holds (SRS-BIO-008).
  $async.Future<HoldAssetResponse> holdAsset(
          $pb.ClientContext? ctx, HoldAssetRequest request) =>
      _client.invoke<HoldAssetResponse>(
          ctx, 'BiomedicalService', 'HoldAsset', request, HoldAssetResponse());
  $async.Future<ReleaseAssetResponse> releaseAsset(
          $pb.ClientContext? ctx, ReleaseAssetRequest request) =>
      _client.invoke<ReleaseAssetResponse>(ctx, 'BiomedicalService',
          'ReleaseAsset', request, ReleaseAssetResponse());

  /// Device telemetry (SRS-BIO-010).
  $async.Future<AppendReadingsResponse> appendReadings(
          $pb.ClientContext? ctx, AppendReadingsRequest request) =>
      _client.invoke<AppendReadingsResponse>(ctx, 'BiomedicalService',
          'AppendReadings', request, AppendReadingsResponse());
  $async.Future<ListReadingsResponse> listReadings(
          $pb.ClientContext? ctx, ListReadingsRequest request) =>
      _client.invoke<ListReadingsResponse>(ctx, 'BiomedicalService',
          'ListReadings', request, ListReadingsResponse());

  /// Uptime and reliability (SRS-BIO-007).
  $async.Future<GetAssetMetricsResponse> getAssetMetrics(
          $pb.ClientContext? ctx, GetAssetMetricsRequest request) =>
      _client.invoke<GetAssetMetricsResponse>(ctx, 'BiomedicalService',
          'GetAssetMetrics', request, GetAssetMetricsResponse());
  $async.Future<GetFleetMetricsResponse> getFleetMetrics(
          $pb.ClientContext? ctx, GetFleetMetricsRequest request) =>
      _client.invoke<GetFleetMetricsResponse>(ctx, 'BiomedicalService',
          'GetFleetMetrics', request, GetFleetMetricsResponse());

  /// Disposal (SRS-BIO-011).
  $async.Future<DisposeAssetResponse> disposeAsset(
          $pb.ClientContext? ctx, DisposeAssetRequest request) =>
      _client.invoke<DisposeAssetResponse>(ctx, 'BiomedicalService',
          'DisposeAsset', request, DisposeAssetResponse());
  $async.Future<GetDisposalResponse> getDisposal(
          $pb.ClientContext? ctx, GetDisposalRequest request) =>
      _client.invoke<GetDisposalResponse>(ctx, 'BiomedicalService',
          'GetDisposal', request, GetDisposalResponse());
  $async.Future<ListDisposalsResponse> listDisposals(
          $pb.ClientContext? ctx, ListDisposalsRequest request) =>
      _client.invoke<ListDisposalsResponse>(ctx, 'BiomedicalService',
          'ListDisposals', request, ListDisposalsResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
