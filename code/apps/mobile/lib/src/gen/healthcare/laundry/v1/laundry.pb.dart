// This is a generated file - do not edit.
//
// Generated from healthcare/laundry/v1/laundry.proto.

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

import 'laundry.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'laundry.pbenum.dart';

/// One thing the hospital launders (SRS-LND-001).
class LinenItem extends $pb.GeneratedMessage {
  factory LinenItem({
    $core.String? itemId,
    $core.String? code,
    $core.String? name,
    LinenCategory? category,
    $core.int? unitWeightG,
    $core.int? replacementCostMinor,
    $core.bool? tracked,
    $core.bool? active,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (category != null) result.category = category;
    if (unitWeightG != null) result.unitWeightG = unitWeightG;
    if (replacementCostMinor != null)
      result.replacementCostMinor = replacementCostMinor;
    if (tracked != null) result.tracked = tracked;
    if (active != null) result.active = active;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  LinenItem._();

  factory LinenItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinenItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinenItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<LinenCategory>(4, _omitFieldNames ? '' : 'category',
        enumValues: LinenCategory.values)
    ..aI(5, _omitFieldNames ? '' : 'unitWeightG')
    ..aI(6, _omitFieldNames ? '' : 'replacementCostMinor')
    ..aOB(7, _omitFieldNames ? '' : 'tracked')
    ..aOB(8, _omitFieldNames ? '' : 'active')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(11, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenItem copyWith(void Function(LinenItem) updates) =>
      super.copyWith((message) => updates(message as LinenItem)) as LinenItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinenItem create() => LinenItem._();
  @$core.override
  LinenItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinenItem getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinenItem>(create);
  static LinenItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

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
  LinenCategory get category => $_getN(3);
  @$pb.TagNumber(4)
  set category(LinenCategory value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  /// The dry weight of one piece, used to reconcile a declared count against
  /// a weighed bag. Zero means nobody has weighed one.
  @$pb.TagNumber(5)
  $core.int get unitWeightG => $_getIZ(4);
  @$pb.TagNumber(5)
  set unitWeightG($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitWeightG() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitWeightG() => $_clearField(5);

  /// Minor currency units.
  @$pb.TagNumber(6)
  $core.int get replacementCostMinor => $_getIZ(5);
  @$pb.TagNumber(6)
  set replacementCostMinor($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReplacementCostMinor() => $_has(5);
  @$pb.TagNumber(6)
  void clearReplacementCostMinor() => $_clearField(6);

  /// Carries an RFID or barcode tag (SRS-LND-007).
  @$pb.TagNumber(7)
  $core.bool get tracked => $_getBF(6);
  @$pb.TagNumber(7)
  set tracked($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTracked() => $_has(6);
  @$pb.TagNumber(7)
  void clearTracked() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get active => $_getBF(7);
  @$pb.TagNumber(8)
  set active($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasActive() => $_has(7);
  @$pb.TagNumber(8)
  void clearActive() => $_clearField(8);

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
  $core.String get createdBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set createdBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCreatedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get version => $_getI64(10);
  @$pb.TagNumber(11)
  set version($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVersion() => $_has(10);
  @$pb.TagNumber(11)
  void clearVersion() => $_clearField(11);
}

/// One item's par for one unit (SRS-LND-001).
class ParLine extends $pb.GeneratedMessage {
  factory ParLine({
    $core.String? itemCode,
    $core.int? quantity,
    $core.int? reorderAt,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    if (reorderAt != null) result.reorderAt = reorderAt;
    return result;
  }

  ParLine._();

  factory ParLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..aI(3, _omitFieldNames ? '' : 'reorderAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParLine copyWith(void Function(ParLine) updates) =>
      super.copyWith((message) => updates(message as ParLine)) as ParLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParLine create() => ParLine._();
  @$core.override
  ParLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParLine>(create);
  static ParLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  /// The number of pieces the unit should hold.
  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  /// The level at which a top-up is raised. Zero means top up whenever the
  /// unit is below par.
  @$pb.TagNumber(3)
  $core.int get reorderAt => $_getIZ(2);
  @$pb.TagNumber(3)
  set reorderAt($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReorderAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReorderAt() => $_clearField(3);
}

/// A unit's linen holding, effective-dated (SRS-LND-001).
class ParLevel extends $pb.GeneratedMessage {
  factory ParLevel({
    $core.String? parId,
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    $core.int? revision,
    $core.Iterable<ParLine>? lines,
    $core.bool? approved,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? supersededAt,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (parId != null) result.parId = parId;
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (revision != null) result.revision = revision;
    if (lines != null) result.lines.addAll(lines);
    if (approved != null) result.approved = approved;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (supersededAt != null) result.supersededAt = supersededAt;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  ParLevel._();

  factory ParLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ParLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ParLevel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'unitName')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aI(5, _omitFieldNames ? '' : 'revision')
    ..pPM<ParLine>(6, _omitFieldNames ? '' : 'lines',
        subBuilder: ParLine.create)
    ..aOB(7, _omitFieldNames ? '' : 'approved')
    ..aOS(8, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'supersededAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ParLevel copyWith(void Function(ParLevel) updates) =>
      super.copyWith((message) => updates(message as ParLevel)) as ParLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ParLevel create() => ParLevel._();
  @$core.override
  ParLevel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ParLevel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ParLevel>(create);
  static ParLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitName => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get revision => $_getIZ(4);
  @$pb.TagNumber(5)
  set revision($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRevision() => $_has(4);
  @$pb.TagNumber(5)
  void clearRevision() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ParLine> get lines => $_getList(5);

  @$pb.TagNumber(7)
  $core.bool get approved => $_getBF(6);
  @$pb.TagNumber(7)
  set approved($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasApproved() => $_has(6);
  @$pb.TagNumber(7)
  void clearApproved() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get approvedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set approvedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasApprovedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get approvedAt => $_getN(8);
  @$pb.TagNumber(9)
  set approvedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureApprovedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get effectiveFrom => $_getN(9);
  @$pb.TagNumber(10)
  set effectiveFrom($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasEffectiveFrom() => $_has(9);
  @$pb.TagNumber(10)
  void clearEffectiveFrom() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get supersededAt => $_getN(10);
  @$pb.TagNumber(11)
  set supersededAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasSupersededAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearSupersededAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureSupersededAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get createdAt => $_getN(11);
  @$pb.TagNumber(12)
  set createdAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCreatedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCreatedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCreatedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get createdBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set createdBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCreatedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One item's declared count in a collection (SRS-LND-002).
class CollectionLine extends $pb.GeneratedMessage {
  factory CollectionLine({
    $core.String? itemCode,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  CollectionLine._();

  factory CollectionLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CollectionLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CollectionLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CollectionLine copyWith(void Function(CollectionLine) updates) =>
      super.copyWith((message) => updates(message as CollectionLine))
          as CollectionLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CollectionLine create() => CollectionLine._();
  @$core.override
  CollectionLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CollectionLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CollectionLine>(create);
  static CollectionLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  /// What the source unit counted. For an infected collection it is a
  /// declaration and stays one.
  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

/// Soiled linen taken from one unit (SRS-LND-002).
class LinenCollection extends $pb.GeneratedMessage {
  factory LinenCollection({
    $core.String? collectionId,
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    SoilClass? soilClass,
    $core.String? handling,
    $core.int? bagCount,
    $core.int? weightG,
    $core.Iterable<CollectionLine>? lines,
    CollectionState? state,
    $core.String? batchId,
    $core.String? cancelReason,
    $0.Timestamp? collectedAt,
    $core.String? collectedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (soilClass != null) result.soilClass = soilClass;
    if (handling != null) result.handling = handling;
    if (bagCount != null) result.bagCount = bagCount;
    if (weightG != null) result.weightG = weightG;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (batchId != null) result.batchId = batchId;
    if (cancelReason != null) result.cancelReason = cancelReason;
    if (collectedAt != null) result.collectedAt = collectedAt;
    if (collectedBy != null) result.collectedBy = collectedBy;
    if (version != null) result.version = version;
    return result;
  }

  LinenCollection._();

  factory LinenCollection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinenCollection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinenCollection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'unitName')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aE<SoilClass>(5, _omitFieldNames ? '' : 'soilClass',
        enumValues: SoilClass.values)
    ..aOS(6, _omitFieldNames ? '' : 'handling')
    ..aI(7, _omitFieldNames ? '' : 'bagCount')
    ..aI(8, _omitFieldNames ? '' : 'weightG')
    ..pPM<CollectionLine>(9, _omitFieldNames ? '' : 'lines',
        subBuilder: CollectionLine.create)
    ..aE<CollectionState>(10, _omitFieldNames ? '' : 'state',
        enumValues: CollectionState.values)
    ..aOS(11, _omitFieldNames ? '' : 'batchId')
    ..aOS(12, _omitFieldNames ? '' : 'cancelReason')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'collectedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'collectedBy')
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenCollection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenCollection copyWith(void Function(LinenCollection) updates) =>
      super.copyWith((message) => updates(message as LinenCollection))
          as LinenCollection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinenCollection create() => LinenCollection._();
  @$core.override
  LinenCollection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinenCollection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinenCollection>(create);
  static LinenCollection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitName => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  SoilClass get soilClass => $_getN(4);
  @$pb.TagNumber(5)
  set soilClass(SoilClass value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSoilClass() => $_has(4);
  @$pb.TagNumber(5)
  void clearSoilClass() => $_clearField(5);

  /// The instruction the worklist has to show, derived from the class rather
  /// than typed beside it (SRS-LND-005).
  @$pb.TagNumber(6)
  $core.String get handling => $_getSZ(5);
  @$pb.TagNumber(6)
  set handling($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasHandling() => $_has(5);
  @$pb.TagNumber(6)
  void clearHandling() => $_clearField(6);

  /// How many sealed bags came over.
  @$pb.TagNumber(7)
  $core.int get bagCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set bagCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBagCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearBagCount() => $_clearField(7);

  /// What the bags weighed. The laundry's own number, taken without opening
  /// anything.
  @$pb.TagNumber(8)
  $core.int get weightG => $_getIZ(7);
  @$pb.TagNumber(8)
  set weightG($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWeightG() => $_has(7);
  @$pb.TagNumber(8)
  void clearWeightG() => $_clearField(8);

  /// Empty is ordinary for an infected collection recorded by bag and weight
  /// alone.
  @$pb.TagNumber(9)
  $pb.PbList<CollectionLine> get lines => $_getList(8);

  @$pb.TagNumber(10)
  CollectionState get state => $_getN(9);
  @$pb.TagNumber(10)
  set state(CollectionState value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasState() => $_has(9);
  @$pb.TagNumber(10)
  void clearState() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get batchId => $_getSZ(10);
  @$pb.TagNumber(11)
  set batchId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBatchId() => $_has(10);
  @$pb.TagNumber(11)
  void clearBatchId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get cancelReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set cancelReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasCancelReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearCancelReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get collectedAt => $_getN(12);
  @$pb.TagNumber(13)
  set collectedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCollectedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCollectedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCollectedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get collectedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set collectedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCollectedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearCollectedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);
}

/// Something that went wrong in a wash (SRS-LND-003).
class BatchException extends $pb.GeneratedMessage {
  factory BatchException({
    $core.String? code,
    $core.String? detail,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (detail != null) result.detail = detail;
    return result;
  }

  BatchException._();

  factory BatchException.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BatchException.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BatchException',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchException clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BatchException copyWith(void Function(BatchException) updates) =>
      super.copyWith((message) => updates(message as BatchException))
          as BatchException;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BatchException create() => BatchException._();
  @$core.override
  BatchException createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BatchException getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BatchException>(create);
  static BatchException? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);
}

/// One wash load (SRS-LND-003).
class WashBatch extends $pb.GeneratedMessage {
  factory WashBatch({
    $core.String? batchId,
    $core.String? reference,
    $core.String? facilityId,
    $core.String? machineId,
    WashCycle? cycle,
    $core.bool? infected,
    $core.Iterable<$core.String>? collectionIds,
    $core.int? weightG,
    BatchState? state,
    $core.String? outcome,
    $core.Iterable<BatchException>? exceptions,
    $core.int? peakTemperatureC,
    $core.int? holdMinutes,
    $core.String? rewashBatchId,
    $core.String? rewashOfBatchId,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    if (reference != null) result.reference = reference;
    if (facilityId != null) result.facilityId = facilityId;
    if (machineId != null) result.machineId = machineId;
    if (cycle != null) result.cycle = cycle;
    if (infected != null) result.infected = infected;
    if (collectionIds != null) result.collectionIds.addAll(collectionIds);
    if (weightG != null) result.weightG = weightG;
    if (state != null) result.state = state;
    if (outcome != null) result.outcome = outcome;
    if (exceptions != null) result.exceptions.addAll(exceptions);
    if (peakTemperatureC != null) result.peakTemperatureC = peakTemperatureC;
    if (holdMinutes != null) result.holdMinutes = holdMinutes;
    if (rewashBatchId != null) result.rewashBatchId = rewashBatchId;
    if (rewashOfBatchId != null) result.rewashOfBatchId = rewashOfBatchId;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  WashBatch._();

  factory WashBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WashBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WashBatch',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..aOS(2, _omitFieldNames ? '' : 'reference')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'machineId')
    ..aE<WashCycle>(5, _omitFieldNames ? '' : 'cycle',
        enumValues: WashCycle.values)
    ..aOB(6, _omitFieldNames ? '' : 'infected')
    ..pPS(7, _omitFieldNames ? '' : 'collectionIds')
    ..aI(8, _omitFieldNames ? '' : 'weightG')
    ..aE<BatchState>(9, _omitFieldNames ? '' : 'state',
        enumValues: BatchState.values)
    ..aOS(10, _omitFieldNames ? '' : 'outcome')
    ..pPM<BatchException>(11, _omitFieldNames ? '' : 'exceptions',
        subBuilder: BatchException.create)
    ..aI(12, _omitFieldNames ? '' : 'peakTemperatureC')
    ..aI(13, _omitFieldNames ? '' : 'holdMinutes')
    ..aOS(14, _omitFieldNames ? '' : 'rewashBatchId')
    ..aOS(15, _omitFieldNames ? '' : 'rewashOfBatchId')
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(19, _omitFieldNames ? '' : 'completedBy')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(21, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WashBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WashBatch copyWith(void Function(WashBatch) updates) =>
      super.copyWith((message) => updates(message as WashBatch)) as WashBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WashBatch create() => WashBatch._();
  @$core.override
  WashBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WashBatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WashBatch>(create);
  static WashBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);

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
  $core.String get machineId => $_getSZ(3);
  @$pb.TagNumber(4)
  set machineId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMachineId() => $_has(3);
  @$pb.TagNumber(4)
  void clearMachineId() => $_clearField(4);

  @$pb.TagNumber(5)
  WashCycle get cycle => $_getN(4);
  @$pb.TagNumber(5)
  set cycle(WashCycle value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCycle() => $_has(4);
  @$pb.TagNumber(5)
  void clearCycle() => $_clearField(5);

  /// Whether the load carries sealed infected linen. Derived from what went
  /// in rather than set.
  @$pb.TagNumber(6)
  $core.bool get infected => $_getBF(5);
  @$pb.TagNumber(6)
  set infected($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInfected() => $_has(5);
  @$pb.TagNumber(6)
  void clearInfected() => $_clearField(6);

  /// Which units' linen is in this load, and therefore who to tell when it
  /// fails.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get collectionIds => $_getList(6);

  @$pb.TagNumber(8)
  $core.int get weightG => $_getIZ(7);
  @$pb.TagNumber(8)
  set weightG($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWeightG() => $_has(7);
  @$pb.TagNumber(8)
  void clearWeightG() => $_clearField(8);

  @$pb.TagNumber(9)
  BatchState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(BatchState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get outcome => $_getSZ(9);
  @$pb.TagNumber(10)
  set outcome($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOutcome() => $_has(9);
  @$pb.TagNumber(10)
  void clearOutcome() => $_clearField(10);

  /// Recorded on a pass as well as a failure: a load that passed with the
  /// probe out of calibration is one somebody wants to know about.
  @$pb.TagNumber(11)
  $pb.PbList<BatchException> get exceptions => $_getList(10);

  /// Whole degrees.
  @$pb.TagNumber(12)
  $core.int get peakTemperatureC => $_getIZ(11);
  @$pb.TagNumber(12)
  set peakTemperatureC($core.int value) => $_setSignedInt32(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPeakTemperatureC() => $_has(11);
  @$pb.TagNumber(12)
  void clearPeakTemperatureC() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get holdMinutes => $_getIZ(12);
  @$pb.TagNumber(13)
  set holdMinutes($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasHoldMinutes() => $_has(12);
  @$pb.TagNumber(13)
  void clearHoldMinutes() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get rewashBatchId => $_getSZ(13);
  @$pb.TagNumber(14)
  set rewashBatchId($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRewashBatchId() => $_has(13);
  @$pb.TagNumber(14)
  void clearRewashBatchId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get rewashOfBatchId => $_getSZ(14);
  @$pb.TagNumber(15)
  set rewashOfBatchId($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRewashOfBatchId() => $_has(14);
  @$pb.TagNumber(15)
  void clearRewashOfBatchId() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get startedAt => $_getN(15);
  @$pb.TagNumber(16)
  set startedAt($0.Timestamp value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasStartedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearStartedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureStartedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get startedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set startedBy($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStartedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearStartedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get completedAt => $_getN(17);
  @$pb.TagNumber(18)
  set completedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasCompletedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCompletedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCompletedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.String get completedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set completedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasCompletedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearCompletedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $0.Timestamp get createdAt => $_getN(19);
  @$pb.TagNumber(20)
  set createdAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureCreatedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $core.String get createdBy => $_getSZ(20);
  @$pb.TagNumber(21)
  set createdBy($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasCreatedBy() => $_has(20);
  @$pb.TagNumber(21)
  void clearCreatedBy() => $_clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(22)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(22)
  void clearVersion() => $_clearField(22);
}

/// One item's count in a clean-linen issue (SRS-LND-004).
class IssueLine extends $pb.GeneratedMessage {
  factory IssueLine({
    $core.String? itemCode,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  IssueLine._();

  factory IssueLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLine copyWith(void Function(IssueLine) updates) =>
      super.copyWith((message) => updates(message as IssueLine)) as IssueLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueLine create() => IssueLine._();
  @$core.override
  IssueLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IssueLine>(create);
  static IssueLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

/// Clean linen going back to a unit (SRS-LND-004).
class LinenIssue extends $pb.GeneratedMessage {
  factory LinenIssue({
    $core.String? issueId,
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    $core.String? batchId,
    $core.String? batchReference,
    $core.Iterable<IssueLine>? lines,
    $0.Timestamp? issuedAt,
    $core.String? issuedBy,
    $0.Timestamp? receivedAt,
    $core.String? receivedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (batchId != null) result.batchId = batchId;
    if (batchReference != null) result.batchReference = batchReference;
    if (lines != null) result.lines.addAll(lines);
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (receivedBy != null) result.receivedBy = receivedBy;
    if (version != null) result.version = version;
    return result;
  }

  LinenIssue._();

  factory LinenIssue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinenIssue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinenIssue',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'unitName')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'batchId')
    ..aOS(6, _omitFieldNames ? '' : 'batchReference')
    ..pPM<IssueLine>(7, _omitFieldNames ? '' : 'lines',
        subBuilder: IssueLine.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'issuedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'receivedBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenIssue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenIssue copyWith(void Function(LinenIssue) updates) =>
      super.copyWith((message) => updates(message as LinenIssue)) as LinenIssue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinenIssue create() => LinenIssue._();
  @$core.override
  LinenIssue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinenIssue getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinenIssue>(create);
  static LinenIssue? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitName => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  /// The wash this came out of. That link is what makes "which wards got
  /// linen from the load that failed" answerable.
  @$pb.TagNumber(5)
  $core.String get batchId => $_getSZ(4);
  @$pb.TagNumber(5)
  set batchId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBatchId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBatchId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get batchReference => $_getSZ(5);
  @$pb.TagNumber(6)
  set batchReference($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBatchReference() => $_has(5);
  @$pb.TagNumber(6)
  void clearBatchReference() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<IssueLine> get lines => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get issuedAt => $_getN(7);
  @$pb.TagNumber(8)
  set issuedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureIssuedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get issuedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set issuedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasIssuedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearIssuedBy() => $_clearField(9);

  /// Empty until the unit signs for it, and never the same person who issued
  /// it.
  @$pb.TagNumber(10)
  $0.Timestamp get receivedAt => $_getN(9);
  @$pb.TagNumber(10)
  set receivedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasReceivedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearReceivedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureReceivedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get receivedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set receivedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasReceivedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearReceivedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

/// Linen written off or gone missing (SRS-LND-006).
class LossRecord extends $pb.GeneratedMessage {
  factory LossRecord({
    $core.String? lossId,
    $core.String? unitId,
    $core.String? facilityId,
    $core.String? itemCode,
    $core.int? quantity,
    LossKind? kind,
    $core.String? reason,
    $core.int? valueMinor,
    LossState? state,
    $core.bool? approvalRequired,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.String? decisionNote,
    $0.Timestamp? reportedAt,
    $core.String? reportedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (lossId != null) result.lossId = lossId;
    if (unitId != null) result.unitId = unitId;
    if (facilityId != null) result.facilityId = facilityId;
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    if (valueMinor != null) result.valueMinor = valueMinor;
    if (state != null) result.state = state;
    if (approvalRequired != null) result.approvalRequired = approvalRequired;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (decisionNote != null) result.decisionNote = decisionNote;
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (version != null) result.version = version;
    return result;
  }

  LossRecord._();

  factory LossRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LossRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LossRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lossId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'itemCode')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aE<LossKind>(6, _omitFieldNames ? '' : 'kind',
        enumValues: LossKind.values)
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aI(8, _omitFieldNames ? '' : 'valueMinor')
    ..aE<LossState>(9, _omitFieldNames ? '' : 'state',
        enumValues: LossState.values)
    ..aOB(10, _omitFieldNames ? '' : 'approvalRequired')
    ..aOS(11, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'decisionNote')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'reportedBy')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LossRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LossRecord copyWith(void Function(LossRecord) updates) =>
      super.copyWith((message) => updates(message as LossRecord)) as LossRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LossRecord create() => LossRecord._();
  @$core.override
  LossRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LossRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LossRecord>(create);
  static LossRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lossId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lossId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLossId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLossId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemCode() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  LossKind get kind => $_getN(5);
  @$pb.TagNumber(6)
  set kind(LossKind value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasKind() => $_has(5);
  @$pb.TagNumber(6)
  void clearKind() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  /// The replacement cost at the time, in minor units. Pinned rather than
  /// computed on read.
  @$pb.TagNumber(8)
  $core.int get valueMinor => $_getIZ(7);
  @$pb.TagNumber(8)
  set valueMinor($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasValueMinor() => $_has(7);
  @$pb.TagNumber(8)
  void clearValueMinor() => $_clearField(8);

  @$pb.TagNumber(9)
  LossState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(LossState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  /// Whether the value crosses the hospital's threshold. Every write-off
  /// still needs a second person; this decides which ones are chased.
  @$pb.TagNumber(10)
  $core.bool get approvalRequired => $_getBF(9);
  @$pb.TagNumber(10)
  set approvalRequired($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasApprovalRequired() => $_has(9);
  @$pb.TagNumber(10)
  void clearApprovalRequired() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get approvedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set approvedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasApprovedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearApprovedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get approvedAt => $_getN(11);
  @$pb.TagNumber(12)
  set approvedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasApprovedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearApprovedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureApprovedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get decisionNote => $_getSZ(12);
  @$pb.TagNumber(13)
  set decisionNote($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDecisionNote() => $_has(12);
  @$pb.TagNumber(13)
  void clearDecisionNote() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get reportedAt => $_getN(13);
  @$pb.TagNumber(14)
  set reportedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasReportedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearReportedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureReportedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get reportedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set reportedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasReportedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearReportedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

/// One scan of a tagged item (SRS-LND-007).
class TrackedMovement extends $pb.GeneratedMessage {
  factory TrackedMovement({
    $core.String? location,
    $core.String? holderId,
    $core.String? note,
    $core.String? recordedBy,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (location != null) result.location = location;
    if (holderId != null) result.holderId = holderId;
    if (note != null) result.note = note;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  TrackedMovement._();

  factory TrackedMovement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackedMovement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackedMovement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'location')
    ..aOS(2, _omitFieldNames ? '' : 'holderId')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackedMovement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackedMovement copyWith(void Function(TrackedMovement) updates) =>
      super.copyWith((message) => updates(message as TrackedMovement))
          as TrackedMovement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackedMovement create() => TrackedMovement._();
  @$core.override
  TrackedMovement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrackedMovement getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackedMovement>(create);
  static TrackedMovement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get location => $_getSZ(0);
  @$pb.TagNumber(1)
  set location($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);

  /// Empty for a location read, which is most of them: a portal scan at the
  /// laundry door says where, not who.
  @$pb.TagNumber(2)
  $core.String get holderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set holderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHolderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearHolderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  /// The authenticated caller, never the reader.
  @$pb.TagNumber(4)
  $core.String get recordedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set recordedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRecordedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearRecordedBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get occurredAt => $_getN(4);
  @$pb.TagNumber(5)
  set occurredAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOccurredAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearOccurredAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureOccurredAt() => $_ensure(4);
}

/// A tagged piece of linen or a uniform (SRS-LND-007).
class TrackedItem extends $pb.GeneratedMessage {
  factory TrackedItem({
    $core.String? trackedId,
    $core.String? tagId,
    TagKind? tagKind,
    $core.String? itemCode,
    $core.String? assignedTo,
    $core.String? facilityId,
    TrackedState? state,
    $core.Iterable<TrackedMovement>? movements,
    $core.String? retiredReason,
    $0.Timestamp? registeredAt,
    $core.String? registeredBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (trackedId != null) result.trackedId = trackedId;
    if (tagId != null) result.tagId = tagId;
    if (tagKind != null) result.tagKind = tagKind;
    if (itemCode != null) result.itemCode = itemCode;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (facilityId != null) result.facilityId = facilityId;
    if (state != null) result.state = state;
    if (movements != null) result.movements.addAll(movements);
    if (retiredReason != null) result.retiredReason = retiredReason;
    if (registeredAt != null) result.registeredAt = registeredAt;
    if (registeredBy != null) result.registeredBy = registeredBy;
    if (version != null) result.version = version;
    return result;
  }

  TrackedItem._();

  factory TrackedItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrackedItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrackedItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackedId')
    ..aOS(2, _omitFieldNames ? '' : 'tagId')
    ..aE<TagKind>(3, _omitFieldNames ? '' : 'tagKind',
        enumValues: TagKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'itemCode')
    ..aOS(5, _omitFieldNames ? '' : 'assignedTo')
    ..aOS(6, _omitFieldNames ? '' : 'facilityId')
    ..aE<TrackedState>(7, _omitFieldNames ? '' : 'state',
        enumValues: TrackedState.values)
    ..pPM<TrackedMovement>(8, _omitFieldNames ? '' : 'movements',
        subBuilder: TrackedMovement.create)
    ..aOS(9, _omitFieldNames ? '' : 'retiredReason')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'registeredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'registeredBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackedItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrackedItem copyWith(void Function(TrackedItem) updates) =>
      super.copyWith((message) => updates(message as TrackedItem))
          as TrackedItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrackedItem create() => TrackedItem._();
  @$core.override
  TrackedItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrackedItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrackedItem>(create);
  static TrackedItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tagId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tagId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTagId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTagId() => $_clearField(2);

  @$pb.TagNumber(3)
  TagKind get tagKind => $_getN(2);
  @$pb.TagNumber(3)
  set tagKind(TagKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTagKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearTagKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get itemCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set itemCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasItemCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearItemCode() => $_clearField(4);

  /// The person a uniform belongs to. Separate from whoever currently has it.
  @$pb.TagNumber(5)
  $core.String get assignedTo => $_getSZ(4);
  @$pb.TagNumber(5)
  set assignedTo($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAssignedTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearAssignedTo() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get facilityId => $_getSZ(5);
  @$pb.TagNumber(6)
  set facilityId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFacilityId() => $_has(5);
  @$pb.TagNumber(6)
  void clearFacilityId() => $_clearField(6);

  @$pb.TagNumber(7)
  TrackedState get state => $_getN(6);
  @$pb.TagNumber(7)
  set state(TrackedState value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasState() => $_has(6);
  @$pb.TagNumber(7)
  void clearState() => $_clearField(7);

  /// Append-only, oldest first.
  @$pb.TagNumber(8)
  $pb.PbList<TrackedMovement> get movements => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get retiredReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set retiredReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRetiredReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearRetiredReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get registeredAt => $_getN(9);
  @$pb.TagNumber(10)
  set registeredAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRegisteredAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearRegisteredAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRegisteredAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get registeredBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set registeredBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasRegisteredBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearRegisteredBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

/// Where a tagged item was last seen (SRS-LND-007).
class Custody extends $pb.GeneratedMessage {
  factory Custody({
    $core.String? location,
    $core.String? holderId,
    $core.String? recordedBy,
    $0.Timestamp? occurredAt,
    $core.bool? known,
  }) {
    final result = create();
    if (location != null) result.location = location;
    if (holderId != null) result.holderId = holderId;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (known != null) result.known = known;
    return result;
  }

  Custody._();

  factory Custody.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Custody.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Custody',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'location')
    ..aOS(2, _omitFieldNames ? '' : 'holderId')
    ..aOS(3, _omitFieldNames ? '' : 'recordedBy')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(5, _omitFieldNames ? '' : 'known')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Custody clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Custody copyWith(void Function(Custody) updates) =>
      super.copyWith((message) => updates(message as Custody)) as Custody;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Custody create() => Custody._();
  @$core.override
  Custody createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Custody getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Custody>(create);
  static Custody? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get location => $_getSZ(0);
  @$pb.TagNumber(1)
  set location($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get holderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set holderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHolderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearHolderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recordedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set recordedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRecordedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecordedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get occurredAt => $_getN(3);
  @$pb.TagNumber(4)
  set occurredAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOccurredAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearOccurredAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureOccurredAt() => $_ensure(3);

  /// False for an item nobody has scanned since it was registered. Reported
  /// rather than defaulting to the laundry.
  @$pb.TagNumber(5)
  $core.bool get known => $_getBF(4);
  @$pb.TagNumber(5)
  set known($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasKnown() => $_has(4);
  @$pb.TagNumber(5)
  void clearKnown() => $_clearField(5);
}

class ConfigureLinenItemRequest extends $pb.GeneratedMessage {
  factory ConfigureLinenItemRequest({
    $core.String? code,
    $core.String? name,
    LinenCategory? category,
    $core.int? unitWeightG,
    $core.int? replacementCostMinor,
    $core.bool? tracked,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (category != null) result.category = category;
    if (unitWeightG != null) result.unitWeightG = unitWeightG;
    if (replacementCostMinor != null)
      result.replacementCostMinor = replacementCostMinor;
    if (tracked != null) result.tracked = tracked;
    return result;
  }

  ConfigureLinenItemRequest._();

  factory ConfigureLinenItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureLinenItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureLinenItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aE<LinenCategory>(3, _omitFieldNames ? '' : 'category',
        enumValues: LinenCategory.values)
    ..aI(4, _omitFieldNames ? '' : 'unitWeightG')
    ..aI(5, _omitFieldNames ? '' : 'replacementCostMinor')
    ..aOB(6, _omitFieldNames ? '' : 'tracked')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLinenItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLinenItemRequest copyWith(
          void Function(ConfigureLinenItemRequest) updates) =>
      super.copyWith((message) => updates(message as ConfigureLinenItemRequest))
          as ConfigureLinenItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureLinenItemRequest create() => ConfigureLinenItemRequest._();
  @$core.override
  ConfigureLinenItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureLinenItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureLinenItemRequest>(create);
  static ConfigureLinenItemRequest? _defaultInstance;

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
  LinenCategory get category => $_getN(2);
  @$pb.TagNumber(3)
  set category(LinenCategory value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get unitWeightG => $_getIZ(3);
  @$pb.TagNumber(4)
  set unitWeightG($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitWeightG() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitWeightG() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get replacementCostMinor => $_getIZ(4);
  @$pb.TagNumber(5)
  set replacementCostMinor($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReplacementCostMinor() => $_has(4);
  @$pb.TagNumber(5)
  void clearReplacementCostMinor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get tracked => $_getBF(5);
  @$pb.TagNumber(6)
  set tracked($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTracked() => $_has(5);
  @$pb.TagNumber(6)
  void clearTracked() => $_clearField(6);
}

class ConfigureLinenItemResponse extends $pb.GeneratedMessage {
  factory ConfigureLinenItemResponse({
    LinenItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  ConfigureLinenItemResponse._();

  factory ConfigureLinenItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConfigureLinenItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConfigureLinenItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: LinenItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLinenItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConfigureLinenItemResponse copyWith(
          void Function(ConfigureLinenItemResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ConfigureLinenItemResponse))
          as ConfigureLinenItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConfigureLinenItemResponse create() => ConfigureLinenItemResponse._();
  @$core.override
  ConfigureLinenItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConfigureLinenItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConfigureLinenItemResponse>(create);
  static ConfigureLinenItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(LinenItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenItem ensureItem() => $_ensure(0);
}

class RetireLinenItemRequest extends $pb.GeneratedMessage {
  factory RetireLinenItemRequest({
    $core.String? itemId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  RetireLinenItemRequest._();

  factory RetireLinenItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireLinenItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireLinenItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireLinenItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireLinenItemRequest copyWith(
          void Function(RetireLinenItemRequest) updates) =>
      super.copyWith((message) => updates(message as RetireLinenItemRequest))
          as RetireLinenItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireLinenItemRequest create() => RetireLinenItemRequest._();
  @$core.override
  RetireLinenItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireLinenItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireLinenItemRequest>(create);
  static RetireLinenItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);
}

class RetireLinenItemResponse extends $pb.GeneratedMessage {
  factory RetireLinenItemResponse({
    LinenItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  RetireLinenItemResponse._();

  factory RetireLinenItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireLinenItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireLinenItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: LinenItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireLinenItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireLinenItemResponse copyWith(
          void Function(RetireLinenItemResponse) updates) =>
      super.copyWith((message) => updates(message as RetireLinenItemResponse))
          as RetireLinenItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireLinenItemResponse create() => RetireLinenItemResponse._();
  @$core.override
  RetireLinenItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireLinenItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireLinenItemResponse>(create);
  static RetireLinenItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(LinenItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenItem ensureItem() => $_ensure(0);
}

class ListLinenItemsRequest extends $pb.GeneratedMessage {
  factory ListLinenItemsRequest({
    LinenCategory? category,
    $core.bool? trackedOnly,
    $core.bool? activeOnly,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (trackedOnly != null) result.trackedOnly = trackedOnly;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListLinenItemsRequest._();

  factory ListLinenItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aE<LinenCategory>(1, _omitFieldNames ? '' : 'category',
        enumValues: LinenCategory.values)
    ..aOB(2, _omitFieldNames ? '' : 'trackedOnly')
    ..aOB(3, _omitFieldNames ? '' : 'activeOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenItemsRequest copyWith(
          void Function(ListLinenItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListLinenItemsRequest))
          as ListLinenItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenItemsRequest create() => ListLinenItemsRequest._();
  @$core.override
  ListLinenItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenItemsRequest>(create);
  static ListLinenItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  LinenCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(LinenCategory value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get trackedOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set trackedOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrackedOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrackedOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get activeOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set activeOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveOnly() => $_clearField(3);

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

class ListLinenItemsResponse extends $pb.GeneratedMessage {
  factory ListLinenItemsResponse({
    $core.Iterable<LinenItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListLinenItemsResponse._();

  factory ListLinenItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<LinenItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: LinenItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenItemsResponse copyWith(
          void Function(ListLinenItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListLinenItemsResponse))
          as ListLinenItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenItemsResponse create() => ListLinenItemsResponse._();
  @$core.override
  ListLinenItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenItemsResponse>(create);
  static ListLinenItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LinenItem> get items => $_getList(0);
}

class SetParLevelRequest extends $pb.GeneratedMessage {
  factory SetParLevelRequest({
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    $core.Iterable<ParLine>? lines,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  SetParLevelRequest._();

  factory SetParLevelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetParLevelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetParLevelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'unitName')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..pPM<ParLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: ParLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParLevelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParLevelRequest copyWith(void Function(SetParLevelRequest) updates) =>
      super.copyWith((message) => updates(message as SetParLevelRequest))
          as SetParLevelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetParLevelRequest create() => SetParLevelRequest._();
  @$core.override
  SetParLevelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetParLevelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetParLevelRequest>(create);
  static SetParLevelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitName => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ParLine> get lines => $_getList(3);
}

class SetParLevelResponse extends $pb.GeneratedMessage {
  factory SetParLevelResponse({
    ParLevel? par,
  }) {
    final result = create();
    if (par != null) result.par = par;
    return result;
  }

  SetParLevelResponse._();

  factory SetParLevelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetParLevelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetParLevelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<ParLevel>(1, _omitFieldNames ? '' : 'par',
        subBuilder: ParLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParLevelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetParLevelResponse copyWith(void Function(SetParLevelResponse) updates) =>
      super.copyWith((message) => updates(message as SetParLevelResponse))
          as SetParLevelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetParLevelResponse create() => SetParLevelResponse._();
  @$core.override
  SetParLevelResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetParLevelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetParLevelResponse>(create);
  static SetParLevelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParLevel get par => $_getN(0);
  @$pb.TagNumber(1)
  set par(ParLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPar() => $_has(0);
  @$pb.TagNumber(1)
  void clearPar() => $_clearField(1);
  @$pb.TagNumber(1)
  ParLevel ensurePar() => $_ensure(0);
}

class ApproveParLevelRequest extends $pb.GeneratedMessage {
  factory ApproveParLevelRequest({
    $core.String? parId,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (parId != null) result.parId = parId;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  ApproveParLevelRequest._();

  factory ApproveParLevelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveParLevelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveParLevelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'parId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveParLevelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveParLevelRequest copyWith(
          void Function(ApproveParLevelRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveParLevelRequest))
          as ApproveParLevelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveParLevelRequest create() => ApproveParLevelRequest._();
  @$core.override
  ApproveParLevelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveParLevelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveParLevelRequest>(create);
  static ApproveParLevelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get parId => $_getSZ(0);
  @$pb.TagNumber(1)
  set parId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasParId() => $_has(0);
  @$pb.TagNumber(1)
  void clearParId() => $_clearField(1);

  /// When the par takes effect. Empty means now.
  @$pb.TagNumber(2)
  $0.Timestamp get effectiveFrom => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveFrom($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveFrom() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(1);
}

class ApproveParLevelResponse extends $pb.GeneratedMessage {
  factory ApproveParLevelResponse({
    ParLevel? par,
  }) {
    final result = create();
    if (par != null) result.par = par;
    return result;
  }

  ApproveParLevelResponse._();

  factory ApproveParLevelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveParLevelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveParLevelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<ParLevel>(1, _omitFieldNames ? '' : 'par',
        subBuilder: ParLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveParLevelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveParLevelResponse copyWith(
          void Function(ApproveParLevelResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveParLevelResponse))
          as ApproveParLevelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveParLevelResponse create() => ApproveParLevelResponse._();
  @$core.override
  ApproveParLevelResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveParLevelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveParLevelResponse>(create);
  static ApproveParLevelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParLevel get par => $_getN(0);
  @$pb.TagNumber(1)
  set par(ParLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPar() => $_has(0);
  @$pb.TagNumber(1)
  void clearPar() => $_clearField(1);
  @$pb.TagNumber(1)
  ParLevel ensurePar() => $_ensure(0);
}

class GetParInForceRequest extends $pb.GeneratedMessage {
  factory GetParInForceRequest({
    $core.String? unitId,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    return result;
  }

  GetParInForceRequest._();

  factory GetParInForceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetParInForceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParInForceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParInForceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParInForceRequest copyWith(void Function(GetParInForceRequest) updates) =>
      super.copyWith((message) => updates(message as GetParInForceRequest))
          as GetParInForceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetParInForceRequest create() => GetParInForceRequest._();
  @$core.override
  GetParInForceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetParInForceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParInForceRequest>(create);
  static GetParInForceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);
}

class GetParInForceResponse extends $pb.GeneratedMessage {
  factory GetParInForceResponse({
    ParLevel? par,
  }) {
    final result = create();
    if (par != null) result.par = par;
    return result;
  }

  GetParInForceResponse._();

  factory GetParInForceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetParInForceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetParInForceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<ParLevel>(1, _omitFieldNames ? '' : 'par',
        subBuilder: ParLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParInForceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetParInForceResponse copyWith(
          void Function(GetParInForceResponse) updates) =>
      super.copyWith((message) => updates(message as GetParInForceResponse))
          as GetParInForceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetParInForceResponse create() => GetParInForceResponse._();
  @$core.override
  GetParInForceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetParInForceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetParInForceResponse>(create);
  static GetParInForceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ParLevel get par => $_getN(0);
  @$pb.TagNumber(1)
  set par(ParLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPar() => $_has(0);
  @$pb.TagNumber(1)
  void clearPar() => $_clearField(1);
  @$pb.TagNumber(1)
  ParLevel ensurePar() => $_ensure(0);
}

class ListParLevelsRequest extends $pb.GeneratedMessage {
  factory ListParLevelsRequest({
    $core.String? facilityId,
    $core.String? unitId,
    $core.bool? liveOnly,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (liveOnly != null) result.liveOnly = liveOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListParLevelsRequest._();

  factory ListParLevelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListParLevelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListParLevelsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOB(3, _omitFieldNames ? '' : 'liveOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..aI(5, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParLevelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParLevelsRequest copyWith(void Function(ListParLevelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListParLevelsRequest))
          as ListParLevelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListParLevelsRequest create() => ListParLevelsRequest._();
  @$core.override
  ListParLevelsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListParLevelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListParLevelsRequest>(create);
  static ListParLevelsRequest? _defaultInstance;

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
  $core.bool get liveOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set liveOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLiveOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearLiveOnly() => $_clearField(3);

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

class ListParLevelsResponse extends $pb.GeneratedMessage {
  factory ListParLevelsResponse({
    $core.Iterable<ParLevel>? pars,
  }) {
    final result = create();
    if (pars != null) result.pars.addAll(pars);
    return result;
  }

  ListParLevelsResponse._();

  factory ListParLevelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListParLevelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListParLevelsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<ParLevel>(1, _omitFieldNames ? '' : 'pars',
        subBuilder: ParLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParLevelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListParLevelsResponse copyWith(
          void Function(ListParLevelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListParLevelsResponse))
          as ListParLevelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListParLevelsResponse create() => ListParLevelsResponse._();
  @$core.override
  ListParLevelsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListParLevelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListParLevelsResponse>(create);
  static ListParLevelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ParLevel> get pars => $_getList(0);
}

class RecordCollectionRequest extends $pb.GeneratedMessage {
  factory RecordCollectionRequest({
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    SoilClass? soilClass,
    $core.int? bagCount,
    $core.int? weightG,
    $core.Iterable<CollectionLine>? lines,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (soilClass != null) result.soilClass = soilClass;
    if (bagCount != null) result.bagCount = bagCount;
    if (weightG != null) result.weightG = weightG;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  RecordCollectionRequest._();

  factory RecordCollectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCollectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCollectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'unitName')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<SoilClass>(4, _omitFieldNames ? '' : 'soilClass',
        enumValues: SoilClass.values)
    ..aI(5, _omitFieldNames ? '' : 'bagCount')
    ..aI(6, _omitFieldNames ? '' : 'weightG')
    ..pPM<CollectionLine>(7, _omitFieldNames ? '' : 'lines',
        subBuilder: CollectionLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCollectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCollectionRequest copyWith(
          void Function(RecordCollectionRequest) updates) =>
      super.copyWith((message) => updates(message as RecordCollectionRequest))
          as RecordCollectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCollectionRequest create() => RecordCollectionRequest._();
  @$core.override
  RecordCollectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCollectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCollectionRequest>(create);
  static RecordCollectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitName => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitName() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  SoilClass get soilClass => $_getN(3);
  @$pb.TagNumber(4)
  set soilClass(SoilClass value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSoilClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearSoilClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get bagCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set bagCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBagCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearBagCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get weightG => $_getIZ(5);
  @$pb.TagNumber(6)
  set weightG($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWeightG() => $_has(5);
  @$pb.TagNumber(6)
  void clearWeightG() => $_clearField(6);

  /// Leave empty for an infected collection recorded by bag and weight.
  @$pb.TagNumber(7)
  $pb.PbList<CollectionLine> get lines => $_getList(6);
}

class RecordCollectionResponse extends $pb.GeneratedMessage {
  factory RecordCollectionResponse({
    LinenCollection? collection,
  }) {
    final result = create();
    if (collection != null) result.collection = collection;
    return result;
  }

  RecordCollectionResponse._();

  factory RecordCollectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCollectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCollectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenCollection>(1, _omitFieldNames ? '' : 'collection',
        subBuilder: LinenCollection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCollectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCollectionResponse copyWith(
          void Function(RecordCollectionResponse) updates) =>
      super.copyWith((message) => updates(message as RecordCollectionResponse))
          as RecordCollectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCollectionResponse create() => RecordCollectionResponse._();
  @$core.override
  RecordCollectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCollectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCollectionResponse>(create);
  static RecordCollectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenCollection get collection => $_getN(0);
  @$pb.TagNumber(1)
  set collection(LinenCollection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCollection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollection() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenCollection ensureCollection() => $_ensure(0);
}

class RecountCollectionRequest extends $pb.GeneratedMessage {
  factory RecountCollectionRequest({
    $core.String? collectionId,
    $core.Iterable<CollectionLine>? lines,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  RecountCollectionRequest._();

  factory RecountCollectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecountCollectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecountCollectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..pPM<CollectionLine>(2, _omitFieldNames ? '' : 'lines',
        subBuilder: CollectionLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecountCollectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecountCollectionRequest copyWith(
          void Function(RecountCollectionRequest) updates) =>
      super.copyWith((message) => updates(message as RecountCollectionRequest))
          as RecountCollectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecountCollectionRequest create() => RecountCollectionRequest._();
  @$core.override
  RecountCollectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecountCollectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecountCollectionRequest>(create);
  static RecountCollectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CollectionLine> get lines => $_getList(1);
}

class RecountCollectionResponse extends $pb.GeneratedMessage {
  factory RecountCollectionResponse({
    LinenCollection? collection,
  }) {
    final result = create();
    if (collection != null) result.collection = collection;
    return result;
  }

  RecountCollectionResponse._();

  factory RecountCollectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecountCollectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecountCollectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenCollection>(1, _omitFieldNames ? '' : 'collection',
        subBuilder: LinenCollection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecountCollectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecountCollectionResponse copyWith(
          void Function(RecountCollectionResponse) updates) =>
      super.copyWith((message) => updates(message as RecountCollectionResponse))
          as RecountCollectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecountCollectionResponse create() => RecountCollectionResponse._();
  @$core.override
  RecountCollectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecountCollectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecountCollectionResponse>(create);
  static RecountCollectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenCollection get collection => $_getN(0);
  @$pb.TagNumber(1)
  set collection(LinenCollection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCollection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollection() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenCollection ensureCollection() => $_ensure(0);
}

class CancelCollectionRequest extends $pb.GeneratedMessage {
  factory CancelCollectionRequest({
    $core.String? collectionId,
    $core.String? reason,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    if (reason != null) result.reason = reason;
    return result;
  }

  CancelCollectionRequest._();

  factory CancelCollectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelCollectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelCollectionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCollectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCollectionRequest copyWith(
          void Function(CancelCollectionRequest) updates) =>
      super.copyWith((message) => updates(message as CancelCollectionRequest))
          as CancelCollectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelCollectionRequest create() => CancelCollectionRequest._();
  @$core.override
  CancelCollectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelCollectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelCollectionRequest>(create);
  static CancelCollectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class CancelCollectionResponse extends $pb.GeneratedMessage {
  factory CancelCollectionResponse({
    LinenCollection? collection,
  }) {
    final result = create();
    if (collection != null) result.collection = collection;
    return result;
  }

  CancelCollectionResponse._();

  factory CancelCollectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelCollectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelCollectionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenCollection>(1, _omitFieldNames ? '' : 'collection',
        subBuilder: LinenCollection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCollectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelCollectionResponse copyWith(
          void Function(CancelCollectionResponse) updates) =>
      super.copyWith((message) => updates(message as CancelCollectionResponse))
          as CancelCollectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelCollectionResponse create() => CancelCollectionResponse._();
  @$core.override
  CancelCollectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelCollectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelCollectionResponse>(create);
  static CancelCollectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenCollection get collection => $_getN(0);
  @$pb.TagNumber(1)
  set collection(LinenCollection value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCollection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollection() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenCollection ensureCollection() => $_ensure(0);
}

class ListCollectionsRequest extends $pb.GeneratedMessage {
  factory ListCollectionsRequest({
    $core.String? facilityId,
    $core.String? unitId,
    SoilClass? soilClass,
    $core.Iterable<CollectionState>? states,
    $core.String? batchId,
    $core.bool? pendingOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (soilClass != null) result.soilClass = soilClass;
    if (states != null) result.states.addAll(states);
    if (batchId != null) result.batchId = batchId;
    if (pendingOnly != null) result.pendingOnly = pendingOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListCollectionsRequest._();

  factory ListCollectionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aE<SoilClass>(3, _omitFieldNames ? '' : 'soilClass',
        enumValues: SoilClass.values)
    ..pc<CollectionState>(
        4, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: CollectionState.valueOf,
        enumValues: CollectionState.values,
        defaultEnumValue: CollectionState.COLLECTION_STATE_UNSPECIFIED)
    ..aOS(5, _omitFieldNames ? '' : 'batchId')
    ..aOB(6, _omitFieldNames ? '' : 'pendingOnly')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(9, _omitFieldNames ? '' : 'pageSize')
    ..aI(10, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionsRequest copyWith(
          void Function(ListCollectionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCollectionsRequest))
          as ListCollectionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionsRequest create() => ListCollectionsRequest._();
  @$core.override
  ListCollectionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCollectionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionsRequest>(create);
  static ListCollectionsRequest? _defaultInstance;

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
  SoilClass get soilClass => $_getN(2);
  @$pb.TagNumber(3)
  set soilClass(SoilClass value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSoilClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearSoilClass() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<CollectionState> get states => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get batchId => $_getSZ(4);
  @$pb.TagNumber(5)
  set batchId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBatchId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBatchId() => $_clearField(5);

  /// Only what is waiting to be washed. Comes back infected-first.
  @$pb.TagNumber(6)
  $core.bool get pendingOnly => $_getBF(5);
  @$pb.TagNumber(6)
  set pendingOnly($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPendingOnly() => $_has(5);
  @$pb.TagNumber(6)
  void clearPendingOnly() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get from => $_getN(6);
  @$pb.TagNumber(7)
  set from($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureFrom() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get to => $_getN(7);
  @$pb.TagNumber(8)
  set to($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearTo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureTo() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.int get pageSize => $_getIZ(8);
  @$pb.TagNumber(9)
  set pageSize($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPageSize() => $_has(8);
  @$pb.TagNumber(9)
  void clearPageSize() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get offset => $_getIZ(9);
  @$pb.TagNumber(10)
  set offset($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasOffset() => $_has(9);
  @$pb.TagNumber(10)
  void clearOffset() => $_clearField(10);
}

class ListCollectionsResponse extends $pb.GeneratedMessage {
  factory ListCollectionsResponse({
    $core.Iterable<LinenCollection>? collections,
  }) {
    final result = create();
    if (collections != null) result.collections.addAll(collections);
    return result;
  }

  ListCollectionsResponse._();

  factory ListCollectionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCollectionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCollectionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<LinenCollection>(1, _omitFieldNames ? '' : 'collections',
        subBuilder: LinenCollection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCollectionsResponse copyWith(
          void Function(ListCollectionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListCollectionsResponse))
          as ListCollectionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCollectionsResponse create() => ListCollectionsResponse._();
  @$core.override
  ListCollectionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCollectionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCollectionsResponse>(create);
  static ListCollectionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LinenCollection> get collections => $_getList(0);
}

class CheckCollectionWeightRequest extends $pb.GeneratedMessage {
  factory CheckCollectionWeightRequest({
    $core.String? collectionId,
  }) {
    final result = create();
    if (collectionId != null) result.collectionId = collectionId;
    return result;
  }

  CheckCollectionWeightRequest._();

  factory CheckCollectionWeightRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckCollectionWeightRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckCollectionWeightRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'collectionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCollectionWeightRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCollectionWeightRequest copyWith(
          void Function(CheckCollectionWeightRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CheckCollectionWeightRequest))
          as CheckCollectionWeightRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckCollectionWeightRequest create() =>
      CheckCollectionWeightRequest._();
  @$core.override
  CheckCollectionWeightRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckCollectionWeightRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckCollectionWeightRequest>(create);
  static CheckCollectionWeightRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get collectionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set collectionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCollectionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCollectionId() => $_clearField(1);
}

class CheckCollectionWeightResponse extends $pb.GeneratedMessage {
  factory CheckCollectionWeightResponse({
    $core.int? declaredPieces,
    $core.int? expectedG,
    $core.int? actualG,
    $core.int? varianceG,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (declaredPieces != null) result.declaredPieces = declaredPieces;
    if (expectedG != null) result.expectedG = expectedG;
    if (actualG != null) result.actualG = actualG;
    if (varianceG != null) result.varianceG = varianceG;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  CheckCollectionWeightResponse._();

  factory CheckCollectionWeightResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckCollectionWeightResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckCollectionWeightResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'declaredPieces')
    ..aI(2, _omitFieldNames ? '' : 'expectedG')
    ..aI(3, _omitFieldNames ? '' : 'actualG')
    ..aI(4, _omitFieldNames ? '' : 'varianceG')
    ..aOB(5, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCollectionWeightResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckCollectionWeightResponse copyWith(
          void Function(CheckCollectionWeightResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CheckCollectionWeightResponse))
          as CheckCollectionWeightResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckCollectionWeightResponse create() =>
      CheckCollectionWeightResponse._();
  @$core.override
  CheckCollectionWeightResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckCollectionWeightResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckCollectionWeightResponse>(create);
  static CheckCollectionWeightResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get declaredPieces => $_getIZ(0);
  @$pb.TagNumber(1)
  set declaredPieces($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeclaredPieces() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeclaredPieces() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get expectedG => $_getIZ(1);
  @$pb.TagNumber(2)
  set expectedG($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedG() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedG() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get actualG => $_getIZ(2);
  @$pb.TagNumber(3)
  set actualG($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActualG() => $_has(2);
  @$pb.TagNumber(3)
  void clearActualG() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get varianceG => $_getIZ(3);
  @$pb.TagNumber(4)
  set varianceG($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVarianceG() => $_has(3);
  @$pb.TagNumber(4)
  void clearVarianceG() => $_clearField(4);

  /// A collection with nothing declared, or items whose unit weight nobody
  /// has recorded. Reported rather than a variance of everything.
  @$pb.TagNumber(5)
  $core.bool get unanswerable => $_getBF(4);
  @$pb.TagNumber(5)
  set unanswerable($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnanswerable() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnanswerable() => $_clearField(5);
}

class OpenWashBatchRequest extends $pb.GeneratedMessage {
  factory OpenWashBatchRequest({
    $core.String? reference,
    $core.String? facilityId,
    $core.String? machineId,
    WashCycle? cycle,
    $core.String? rewashOfBatchId,
  }) {
    final result = create();
    if (reference != null) result.reference = reference;
    if (facilityId != null) result.facilityId = facilityId;
    if (machineId != null) result.machineId = machineId;
    if (cycle != null) result.cycle = cycle;
    if (rewashOfBatchId != null) result.rewashOfBatchId = rewashOfBatchId;
    return result;
  }

  OpenWashBatchRequest._();

  factory OpenWashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenWashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenWashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reference')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'machineId')
    ..aE<WashCycle>(4, _omitFieldNames ? '' : 'cycle',
        enumValues: WashCycle.values)
    ..aOS(5, _omitFieldNames ? '' : 'rewashOfBatchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenWashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenWashBatchRequest copyWith(void Function(OpenWashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as OpenWashBatchRequest))
          as OpenWashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenWashBatchRequest create() => OpenWashBatchRequest._();
  @$core.override
  OpenWashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenWashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenWashBatchRequest>(create);
  static OpenWashBatchRequest? _defaultInstance;

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
  $core.String get machineId => $_getSZ(2);
  @$pb.TagNumber(3)
  set machineId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMachineId() => $_has(2);
  @$pb.TagNumber(3)
  void clearMachineId() => $_clearField(3);

  @$pb.TagNumber(4)
  WashCycle get cycle => $_getN(3);
  @$pb.TagNumber(4)
  set cycle(WashCycle value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCycle() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycle() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get rewashOfBatchId => $_getSZ(4);
  @$pb.TagNumber(5)
  set rewashOfBatchId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRewashOfBatchId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRewashOfBatchId() => $_clearField(5);
}

class OpenWashBatchResponse extends $pb.GeneratedMessage {
  factory OpenWashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  OpenWashBatchResponse._();

  factory OpenWashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenWashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenWashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenWashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenWashBatchResponse copyWith(
          void Function(OpenWashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as OpenWashBatchResponse))
          as OpenWashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenWashBatchResponse create() => OpenWashBatchResponse._();
  @$core.override
  OpenWashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenWashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenWashBatchResponse>(create);
  static OpenWashBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class LoadWashBatchRequest extends $pb.GeneratedMessage {
  factory LoadWashBatchRequest({
    $core.String? batchId,
    $core.String? collectionId,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    if (collectionId != null) result.collectionId = collectionId;
    return result;
  }

  LoadWashBatchRequest._();

  factory LoadWashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadWashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadWashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..aOS(2, _omitFieldNames ? '' : 'collectionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadWashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadWashBatchRequest copyWith(void Function(LoadWashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as LoadWashBatchRequest))
          as LoadWashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadWashBatchRequest create() => LoadWashBatchRequest._();
  @$core.override
  LoadWashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadWashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadWashBatchRequest>(create);
  static LoadWashBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get collectionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set collectionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCollectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCollectionId() => $_clearField(2);
}

class LoadWashBatchResponse extends $pb.GeneratedMessage {
  factory LoadWashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  LoadWashBatchResponse._();

  factory LoadWashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LoadWashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoadWashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadWashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LoadWashBatchResponse copyWith(
          void Function(LoadWashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as LoadWashBatchResponse))
          as LoadWashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoadWashBatchResponse create() => LoadWashBatchResponse._();
  @$core.override
  LoadWashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LoadWashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoadWashBatchResponse>(create);
  static LoadWashBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class StartWashBatchRequest extends $pb.GeneratedMessage {
  factory StartWashBatchRequest({
    $core.String? batchId,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    return result;
  }

  StartWashBatchRequest._();

  factory StartWashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWashBatchRequest copyWith(
          void Function(StartWashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as StartWashBatchRequest))
          as StartWashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWashBatchRequest create() => StartWashBatchRequest._();
  @$core.override
  StartWashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWashBatchRequest>(create);
  static StartWashBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);
}

class StartWashBatchResponse extends $pb.GeneratedMessage {
  factory StartWashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  StartWashBatchResponse._();

  factory StartWashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartWashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartWashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartWashBatchResponse copyWith(
          void Function(StartWashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as StartWashBatchResponse))
          as StartWashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartWashBatchResponse create() => StartWashBatchResponse._();
  @$core.override
  StartWashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartWashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartWashBatchResponse>(create);
  static StartWashBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class CompleteWashBatchRequest extends $pb.GeneratedMessage {
  factory CompleteWashBatchRequest({
    $core.String? batchId,
    $core.bool? passed,
    $core.String? outcome,
    $core.int? peakTemperatureC,
    $core.int? holdMinutes,
    $core.Iterable<BatchException>? exceptions,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    if (passed != null) result.passed = passed;
    if (outcome != null) result.outcome = outcome;
    if (peakTemperatureC != null) result.peakTemperatureC = peakTemperatureC;
    if (holdMinutes != null) result.holdMinutes = holdMinutes;
    if (exceptions != null) result.exceptions.addAll(exceptions);
    return result;
  }

  CompleteWashBatchRequest._();

  factory CompleteWashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteWashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteWashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..aOB(2, _omitFieldNames ? '' : 'passed')
    ..aOS(3, _omitFieldNames ? '' : 'outcome')
    ..aI(4, _omitFieldNames ? '' : 'peakTemperatureC')
    ..aI(5, _omitFieldNames ? '' : 'holdMinutes')
    ..pPM<BatchException>(6, _omitFieldNames ? '' : 'exceptions',
        subBuilder: BatchException.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteWashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteWashBatchRequest copyWith(
          void Function(CompleteWashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as CompleteWashBatchRequest))
          as CompleteWashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteWashBatchRequest create() => CompleteWashBatchRequest._();
  @$core.override
  CompleteWashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteWashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteWashBatchRequest>(create);
  static CompleteWashBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get passed => $_getBF(1);
  @$pb.TagNumber(2)
  set passed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPassed() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassed() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get outcome => $_getSZ(2);
  @$pb.TagNumber(3)
  set outcome($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOutcome() => $_has(2);
  @$pb.TagNumber(3)
  void clearOutcome() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get peakTemperatureC => $_getIZ(3);
  @$pb.TagNumber(4)
  set peakTemperatureC($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeakTemperatureC() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeakTemperatureC() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get holdMinutes => $_getIZ(4);
  @$pb.TagNumber(5)
  set holdMinutes($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHoldMinutes() => $_has(4);
  @$pb.TagNumber(5)
  void clearHoldMinutes() => $_clearField(5);

  /// Required when the wash did not pass.
  @$pb.TagNumber(6)
  $pb.PbList<BatchException> get exceptions => $_getList(5);
}

class CompleteWashBatchResponse extends $pb.GeneratedMessage {
  factory CompleteWashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  CompleteWashBatchResponse._();

  factory CompleteWashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteWashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteWashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteWashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteWashBatchResponse copyWith(
          void Function(CompleteWashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as CompleteWashBatchResponse))
          as CompleteWashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteWashBatchResponse create() => CompleteWashBatchResponse._();
  @$core.override
  CompleteWashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteWashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteWashBatchResponse>(create);
  static CompleteWashBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class RewashBatchRequest extends $pb.GeneratedMessage {
  factory RewashBatchRequest({
    $core.String? failedBatchId,
    $core.String? intoBatchId,
  }) {
    final result = create();
    if (failedBatchId != null) result.failedBatchId = failedBatchId;
    if (intoBatchId != null) result.intoBatchId = intoBatchId;
    return result;
  }

  RewashBatchRequest._();

  factory RewashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RewashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RewashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'failedBatchId')
    ..aOS(2, _omitFieldNames ? '' : 'intoBatchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RewashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RewashBatchRequest copyWith(void Function(RewashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as RewashBatchRequest))
          as RewashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RewashBatchRequest create() => RewashBatchRequest._();
  @$core.override
  RewashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RewashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RewashBatchRequest>(create);
  static RewashBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get failedBatchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set failedBatchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFailedBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFailedBatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get intoBatchId => $_getSZ(1);
  @$pb.TagNumber(2)
  set intoBatchId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIntoBatchId() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntoBatchId() => $_clearField(2);
}

class RewashBatchResponse extends $pb.GeneratedMessage {
  factory RewashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  RewashBatchResponse._();

  factory RewashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RewashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RewashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RewashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RewashBatchResponse copyWith(void Function(RewashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as RewashBatchResponse))
          as RewashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RewashBatchResponse create() => RewashBatchResponse._();
  @$core.override
  RewashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RewashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RewashBatchResponse>(create);
  static RewashBatchResponse? _defaultInstance;

  /// The replacement batch. The failed one keeps its failure.
  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class GetWashBatchRequest extends $pb.GeneratedMessage {
  factory GetWashBatchRequest({
    $core.String? batchId,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    return result;
  }

  GetWashBatchRequest._();

  factory GetWashBatchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWashBatchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWashBatchRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashBatchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashBatchRequest copyWith(void Function(GetWashBatchRequest) updates) =>
      super.copyWith((message) => updates(message as GetWashBatchRequest))
          as GetWashBatchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWashBatchRequest create() => GetWashBatchRequest._();
  @$core.override
  GetWashBatchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWashBatchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWashBatchRequest>(create);
  static GetWashBatchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);
}

class GetWashBatchResponse extends $pb.GeneratedMessage {
  factory GetWashBatchResponse({
    WashBatch? batch,
  }) {
    final result = create();
    if (batch != null) result.batch = batch;
    return result;
  }

  GetWashBatchResponse._();

  factory GetWashBatchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWashBatchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWashBatchResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashBatch>(1, _omitFieldNames ? '' : 'batch',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashBatchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashBatchResponse copyWith(void Function(GetWashBatchResponse) updates) =>
      super.copyWith((message) => updates(message as GetWashBatchResponse))
          as GetWashBatchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWashBatchResponse create() => GetWashBatchResponse._();
  @$core.override
  GetWashBatchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWashBatchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWashBatchResponse>(create);
  static GetWashBatchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashBatch get batch => $_getN(0);
  @$pb.TagNumber(1)
  set batch(WashBatch value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBatch() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatch() => $_clearField(1);
  @$pb.TagNumber(1)
  WashBatch ensureBatch() => $_ensure(0);
}

class ListWashBatchesRequest extends $pb.GeneratedMessage {
  factory ListWashBatchesRequest({
    $core.String? facilityId,
    $core.String? machineId,
    WashCycle? cycle,
    $core.Iterable<BatchState>? states,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (machineId != null) result.machineId = machineId;
    if (cycle != null) result.cycle = cycle;
    if (states != null) result.states.addAll(states);
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListWashBatchesRequest._();

  factory ListWashBatchesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWashBatchesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWashBatchesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'machineId')
    ..aE<WashCycle>(3, _omitFieldNames ? '' : 'cycle',
        enumValues: WashCycle.values)
    ..pc<BatchState>(4, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: BatchState.valueOf,
        enumValues: BatchState.values,
        defaultEnumValue: BatchState.BATCH_STATE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aI(8, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWashBatchesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWashBatchesRequest copyWith(
          void Function(ListWashBatchesRequest) updates) =>
      super.copyWith((message) => updates(message as ListWashBatchesRequest))
          as ListWashBatchesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWashBatchesRequest create() => ListWashBatchesRequest._();
  @$core.override
  ListWashBatchesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWashBatchesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWashBatchesRequest>(create);
  static ListWashBatchesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get machineId => $_getSZ(1);
  @$pb.TagNumber(2)
  set machineId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMachineId() => $_has(1);
  @$pb.TagNumber(2)
  void clearMachineId() => $_clearField(2);

  @$pb.TagNumber(3)
  WashCycle get cycle => $_getN(2);
  @$pb.TagNumber(3)
  set cycle(WashCycle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCycle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCycle() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<BatchState> get states => $_getList(3);

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

  @$pb.TagNumber(8)
  $core.int get offset => $_getIZ(7);
  @$pb.TagNumber(8)
  set offset($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOffset() => $_has(7);
  @$pb.TagNumber(8)
  void clearOffset() => $_clearField(8);
}

class ListWashBatchesResponse extends $pb.GeneratedMessage {
  factory ListWashBatchesResponse({
    $core.Iterable<WashBatch>? batches,
  }) {
    final result = create();
    if (batches != null) result.batches.addAll(batches);
    return result;
  }

  ListWashBatchesResponse._();

  factory ListWashBatchesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListWashBatchesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListWashBatchesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<WashBatch>(1, _omitFieldNames ? '' : 'batches',
        subBuilder: WashBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWashBatchesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListWashBatchesResponse copyWith(
          void Function(ListWashBatchesResponse) updates) =>
      super.copyWith((message) => updates(message as ListWashBatchesResponse))
          as ListWashBatchesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListWashBatchesResponse create() => ListWashBatchesResponse._();
  @$core.override
  ListWashBatchesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListWashBatchesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListWashBatchesResponse>(create);
  static ListWashBatchesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WashBatch> get batches => $_getList(0);
}

class ListAffectedUnitsRequest extends $pb.GeneratedMessage {
  factory ListAffectedUnitsRequest({
    $core.String? batchId,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    return result;
  }

  ListAffectedUnitsRequest._();

  factory ListAffectedUnitsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAffectedUnitsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAffectedUnitsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffectedUnitsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffectedUnitsRequest copyWith(
          void Function(ListAffectedUnitsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAffectedUnitsRequest))
          as ListAffectedUnitsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAffectedUnitsRequest create() => ListAffectedUnitsRequest._();
  @$core.override
  ListAffectedUnitsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAffectedUnitsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAffectedUnitsRequest>(create);
  static ListAffectedUnitsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);
}

class ListAffectedUnitsResponse extends $pb.GeneratedMessage {
  factory ListAffectedUnitsResponse({
    $core.Iterable<$core.String>? unitIds,
  }) {
    final result = create();
    if (unitIds != null) result.unitIds.addAll(unitIds);
    return result;
  }

  ListAffectedUnitsResponse._();

  factory ListAffectedUnitsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAffectedUnitsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAffectedUnitsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'unitIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffectedUnitsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAffectedUnitsResponse copyWith(
          void Function(ListAffectedUnitsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAffectedUnitsResponse))
          as ListAffectedUnitsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAffectedUnitsResponse create() => ListAffectedUnitsResponse._();
  @$core.override
  ListAffectedUnitsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAffectedUnitsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAffectedUnitsResponse>(create);
  static ListAffectedUnitsResponse? _defaultInstance;

  /// Empty unless the batch failed: the question only arises then.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get unitIds => $_getList(0);
}

class IssueLinenRequest extends $pb.GeneratedMessage {
  factory IssueLinenRequest({
    $core.String? batchId,
    $core.String? unitId,
    $core.String? unitName,
    $core.String? facilityId,
    $core.Iterable<IssueLine>? lines,
  }) {
    final result = create();
    if (batchId != null) result.batchId = batchId;
    if (unitId != null) result.unitId = unitId;
    if (unitName != null) result.unitName = unitName;
    if (facilityId != null) result.facilityId = facilityId;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  IssueLinenRequest._();

  factory IssueLinenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueLinenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueLinenRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'batchId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'unitName')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..pPM<IssueLine>(5, _omitFieldNames ? '' : 'lines',
        subBuilder: IssueLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLinenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLinenRequest copyWith(void Function(IssueLinenRequest) updates) =>
      super.copyWith((message) => updates(message as IssueLinenRequest))
          as IssueLinenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueLinenRequest create() => IssueLinenRequest._();
  @$core.override
  IssueLinenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueLinenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueLinenRequest>(create);
  static IssueLinenRequest? _defaultInstance;

  /// The wash the linen came out of. Refused unless it passed.
  @$pb.TagNumber(1)
  $core.String get batchId => $_getSZ(0);
  @$pb.TagNumber(1)
  set batchId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBatchId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBatchId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitName => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitName() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<IssueLine> get lines => $_getList(4);
}

class IssueLinenResponse extends $pb.GeneratedMessage {
  factory IssueLinenResponse({
    LinenIssue? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  IssueLinenResponse._();

  factory IssueLinenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueLinenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueLinenResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenIssue>(1, _omitFieldNames ? '' : 'issue',
        subBuilder: LinenIssue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLinenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueLinenResponse copyWith(void Function(IssueLinenResponse) updates) =>
      super.copyWith((message) => updates(message as IssueLinenResponse))
          as IssueLinenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueLinenResponse create() => IssueLinenResponse._();
  @$core.override
  IssueLinenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueLinenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueLinenResponse>(create);
  static IssueLinenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenIssue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(LinenIssue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenIssue ensureIssue() => $_ensure(0);
}

class ReceiveLinenRequest extends $pb.GeneratedMessage {
  factory ReceiveLinenRequest({
    $core.String? issueId,
  }) {
    final result = create();
    if (issueId != null) result.issueId = issueId;
    return result;
  }

  ReceiveLinenRequest._();

  factory ReceiveLinenRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveLinenRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveLinenRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'issueId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveLinenRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveLinenRequest copyWith(void Function(ReceiveLinenRequest) updates) =>
      super.copyWith((message) => updates(message as ReceiveLinenRequest))
          as ReceiveLinenRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveLinenRequest create() => ReceiveLinenRequest._();
  @$core.override
  ReceiveLinenRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveLinenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveLinenRequest>(create);
  static ReceiveLinenRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get issueId => $_getSZ(0);
  @$pb.TagNumber(1)
  set issueId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIssueId() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssueId() => $_clearField(1);
}

class ReceiveLinenResponse extends $pb.GeneratedMessage {
  factory ReceiveLinenResponse({
    LinenIssue? issue,
  }) {
    final result = create();
    if (issue != null) result.issue = issue;
    return result;
  }

  ReceiveLinenResponse._();

  factory ReceiveLinenResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveLinenResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveLinenResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenIssue>(1, _omitFieldNames ? '' : 'issue',
        subBuilder: LinenIssue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveLinenResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveLinenResponse copyWith(void Function(ReceiveLinenResponse) updates) =>
      super.copyWith((message) => updates(message as ReceiveLinenResponse))
          as ReceiveLinenResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveLinenResponse create() => ReceiveLinenResponse._();
  @$core.override
  ReceiveLinenResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveLinenResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveLinenResponse>(create);
  static ReceiveLinenResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenIssue get issue => $_getN(0);
  @$pb.TagNumber(1)
  set issue(LinenIssue value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasIssue() => $_has(0);
  @$pb.TagNumber(1)
  void clearIssue() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenIssue ensureIssue() => $_ensure(0);
}

class ListLinenIssuesRequest extends $pb.GeneratedMessage {
  factory ListLinenIssuesRequest({
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? batchId,
    $core.bool? outstandingOnly,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (batchId != null) result.batchId = batchId;
    if (outstandingOnly != null) result.outstandingOnly = outstandingOnly;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListLinenIssuesRequest._();

  factory ListLinenIssuesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenIssuesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenIssuesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'batchId')
    ..aOB(4, _omitFieldNames ? '' : 'outstandingOnly')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(7, _omitFieldNames ? '' : 'pageSize')
    ..aI(8, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenIssuesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenIssuesRequest copyWith(
          void Function(ListLinenIssuesRequest) updates) =>
      super.copyWith((message) => updates(message as ListLinenIssuesRequest))
          as ListLinenIssuesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenIssuesRequest create() => ListLinenIssuesRequest._();
  @$core.override
  ListLinenIssuesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenIssuesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenIssuesRequest>(create);
  static ListLinenIssuesRequest? _defaultInstance;

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
  $core.String get batchId => $_getSZ(2);
  @$pb.TagNumber(3)
  set batchId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBatchId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBatchId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get outstandingOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set outstandingOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutstandingOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutstandingOnly() => $_clearField(4);

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

  @$pb.TagNumber(8)
  $core.int get offset => $_getIZ(7);
  @$pb.TagNumber(8)
  set offset($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasOffset() => $_has(7);
  @$pb.TagNumber(8)
  void clearOffset() => $_clearField(8);
}

class ListLinenIssuesResponse extends $pb.GeneratedMessage {
  factory ListLinenIssuesResponse({
    $core.Iterable<LinenIssue>? issues,
  }) {
    final result = create();
    if (issues != null) result.issues.addAll(issues);
    return result;
  }

  ListLinenIssuesResponse._();

  factory ListLinenIssuesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenIssuesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenIssuesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<LinenIssue>(1, _omitFieldNames ? '' : 'issues',
        subBuilder: LinenIssue.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenIssuesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenIssuesResponse copyWith(
          void Function(ListLinenIssuesResponse) updates) =>
      super.copyWith((message) => updates(message as ListLinenIssuesResponse))
          as ListLinenIssuesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenIssuesResponse create() => ListLinenIssuesResponse._();
  @$core.override
  ListLinenIssuesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenIssuesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenIssuesResponse>(create);
  static ListLinenIssuesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LinenIssue> get issues => $_getList(0);
}

class ItemCount extends $pb.GeneratedMessage {
  factory ItemCount({
    $core.String? itemCode,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  ItemCount._();

  factory ItemCount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ItemCount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ItemCount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemCount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ItemCount copyWith(void Function(ItemCount) updates) =>
      super.copyWith((message) => updates(message as ItemCount)) as ItemCount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ItemCount create() => ItemCount._();
  @$core.override
  ItemCount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ItemCount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemCount>(create);
  static ItemCount? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

class Shortfall extends $pb.GeneratedMessage {
  factory Shortfall({
    $core.String? itemCode,
    $core.int? par,
    $core.int? onHand,
    $core.int? short,
  }) {
    final result = create();
    if (itemCode != null) result.itemCode = itemCode;
    if (par != null) result.par = par;
    if (onHand != null) result.onHand = onHand;
    if (short != null) result.short = short;
    return result;
  }

  Shortfall._();

  factory Shortfall.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Shortfall.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Shortfall',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemCode')
    ..aI(2, _omitFieldNames ? '' : 'par')
    ..aI(3, _omitFieldNames ? '' : 'onHand')
    ..aI(4, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shortfall clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Shortfall copyWith(void Function(Shortfall) updates) =>
      super.copyWith((message) => updates(message as Shortfall)) as Shortfall;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Shortfall create() => Shortfall._();
  @$core.override
  Shortfall createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Shortfall getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Shortfall>(create);
  static Shortfall? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get par => $_getIZ(1);
  @$pb.TagNumber(2)
  set par($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPar() => $_has(1);
  @$pb.TagNumber(2)
  void clearPar() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get onHand => $_getIZ(2);
  @$pb.TagNumber(3)
  set onHand($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOnHand() => $_has(2);
  @$pb.TagNumber(3)
  void clearOnHand() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get short => $_getIZ(3);
  @$pb.TagNumber(4)
  set short($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasShort() => $_has(3);
  @$pb.TagNumber(4)
  void clearShort() => $_clearField(4);
}

class GetUnitStockRequest extends $pb.GeneratedMessage {
  factory GetUnitStockRequest({
    $core.String? unitId,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    return result;
  }

  GetUnitStockRequest._();

  factory GetUnitStockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitStockRequest copyWith(void Function(GetUnitStockRequest) updates) =>
      super.copyWith((message) => updates(message as GetUnitStockRequest))
          as GetUnitStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitStockRequest create() => GetUnitStockRequest._();
  @$core.override
  GetUnitStockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitStockRequest>(create);
  static GetUnitStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);
}

class GetUnitStockResponse extends $pb.GeneratedMessage {
  factory GetUnitStockResponse({
    $core.Iterable<ItemCount>? onHand,
    $core.Iterable<ItemCount>? issued,
    $core.Iterable<ItemCount>? returned,
    $core.Iterable<ItemCount>? writtenOff,
    $core.int? unreconciledReturns,
    $core.Iterable<Shortfall>? shortfalls,
    ParLevel? parInForce,
    $core.bool? noPar,
    $core.bool? truncated,
  }) {
    final result = create();
    if (onHand != null) result.onHand.addAll(onHand);
    if (issued != null) result.issued.addAll(issued);
    if (returned != null) result.returned.addAll(returned);
    if (writtenOff != null) result.writtenOff.addAll(writtenOff);
    if (unreconciledReturns != null)
      result.unreconciledReturns = unreconciledReturns;
    if (shortfalls != null) result.shortfalls.addAll(shortfalls);
    if (parInForce != null) result.parInForce = parInForce;
    if (noPar != null) result.noPar = noPar;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetUnitStockResponse._();

  factory GetUnitStockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<ItemCount>(1, _omitFieldNames ? '' : 'onHand',
        subBuilder: ItemCount.create)
    ..pPM<ItemCount>(2, _omitFieldNames ? '' : 'issued',
        subBuilder: ItemCount.create)
    ..pPM<ItemCount>(3, _omitFieldNames ? '' : 'returned',
        subBuilder: ItemCount.create)
    ..pPM<ItemCount>(4, _omitFieldNames ? '' : 'writtenOff',
        subBuilder: ItemCount.create)
    ..aI(5, _omitFieldNames ? '' : 'unreconciledReturns')
    ..pPM<Shortfall>(6, _omitFieldNames ? '' : 'shortfalls',
        subBuilder: Shortfall.create)
    ..aOM<ParLevel>(7, _omitFieldNames ? '' : 'parInForce',
        subBuilder: ParLevel.create)
    ..aOB(8, _omitFieldNames ? '' : 'noPar')
    ..aOB(9, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitStockResponse copyWith(void Function(GetUnitStockResponse) updates) =>
      super.copyWith((message) => updates(message as GetUnitStockResponse))
          as GetUnitStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitStockResponse create() => GetUnitStockResponse._();
  @$core.override
  GetUnitStockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitStockResponse>(create);
  static GetUnitStockResponse? _defaultInstance;

  /// Issued minus returned minus written off, derived from the movements.
  @$pb.TagNumber(1)
  $pb.PbList<ItemCount> get onHand => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<ItemCount> get issued => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<ItemCount> get returned => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<ItemCount> get writtenOff => $_getList(3);

  /// Returns the laundry could not attribute to an item, which is every
  /// sealed infected bag recorded by weight alone.
  @$pb.TagNumber(5)
  $core.int get unreconciledReturns => $_getIZ(4);
  @$pb.TagNumber(5)
  set unreconciledReturns($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnreconciledReturns() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnreconciledReturns() => $_clearField(5);

  /// Empty when the unit is at or above par on everything, rather than a
  /// list of zeroes.
  @$pb.TagNumber(6)
  $pb.PbList<Shortfall> get shortfalls => $_getList(5);

  @$pb.TagNumber(7)
  ParLevel get parInForce => $_getN(6);
  @$pb.TagNumber(7)
  set parInForce(ParLevel value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasParInForce() => $_has(6);
  @$pb.TagNumber(7)
  void clearParInForce() => $_clearField(7);
  @$pb.TagNumber(7)
  ParLevel ensureParInForce() => $_ensure(6);

  /// A unit nobody has set a par for. Reported rather than an empty
  /// shortfall list, which reads as a ward that has everything it needs.
  @$pb.TagNumber(8)
  $core.bool get noPar => $_getBF(7);
  @$pb.TagNumber(8)
  set noPar($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasNoPar() => $_has(7);
  @$pb.TagNumber(8)
  void clearNoPar() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get truncated => $_getBF(8);
  @$pb.TagNumber(9)
  set truncated($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTruncated() => $_has(8);
  @$pb.TagNumber(9)
  void clearTruncated() => $_clearField(9);
}

class ReportLinenLossRequest extends $pb.GeneratedMessage {
  factory ReportLinenLossRequest({
    $core.String? unitId,
    $core.String? facilityId,
    $core.String? itemCode,
    $core.int? quantity,
    LossKind? kind,
    $core.String? reason,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (facilityId != null) result.facilityId = facilityId;
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    if (kind != null) result.kind = kind;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReportLinenLossRequest._();

  factory ReportLinenLossRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportLinenLossRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportLinenLossRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'itemCode')
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aE<LossKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: LossKind.values)
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinenLossRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinenLossRequest copyWith(
          void Function(ReportLinenLossRequest) updates) =>
      super.copyWith((message) => updates(message as ReportLinenLossRequest))
          as ReportLinenLossRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportLinenLossRequest create() => ReportLinenLossRequest._();
  @$core.override
  ReportLinenLossRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportLinenLossRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportLinenLossRequest>(create);
  static ReportLinenLossRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  LossKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(LossKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  /// Required. A write-off with no reason is a number in an annual report
  /// that nobody can act on.
  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);
}

class ReportLinenLossResponse extends $pb.GeneratedMessage {
  factory ReportLinenLossResponse({
    LossRecord? loss,
  }) {
    final result = create();
    if (loss != null) result.loss = loss;
    return result;
  }

  ReportLinenLossResponse._();

  factory ReportLinenLossResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportLinenLossResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportLinenLossResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LossRecord>(1, _omitFieldNames ? '' : 'loss',
        subBuilder: LossRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinenLossResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportLinenLossResponse copyWith(
          void Function(ReportLinenLossResponse) updates) =>
      super.copyWith((message) => updates(message as ReportLinenLossResponse))
          as ReportLinenLossResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportLinenLossResponse create() => ReportLinenLossResponse._();
  @$core.override
  ReportLinenLossResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportLinenLossResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportLinenLossResponse>(create);
  static ReportLinenLossResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LossRecord get loss => $_getN(0);
  @$pb.TagNumber(1)
  set loss(LossRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLoss() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoss() => $_clearField(1);
  @$pb.TagNumber(1)
  LossRecord ensureLoss() => $_ensure(0);
}

class ApproveLinenLossRequest extends $pb.GeneratedMessage {
  factory ApproveLinenLossRequest({
    $core.String? lossId,
    $core.bool? approve,
    $core.String? note,
  }) {
    final result = create();
    if (lossId != null) result.lossId = lossId;
    if (approve != null) result.approve = approve;
    if (note != null) result.note = note;
    return result;
  }

  ApproveLinenLossRequest._();

  factory ApproveLinenLossRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLinenLossRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLinenLossRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lossId')
    ..aOB(2, _omitFieldNames ? '' : 'approve')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLinenLossRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLinenLossRequest copyWith(
          void Function(ApproveLinenLossRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveLinenLossRequest))
          as ApproveLinenLossRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLinenLossRequest create() => ApproveLinenLossRequest._();
  @$core.override
  ApproveLinenLossRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLinenLossRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLinenLossRequest>(create);
  static ApproveLinenLossRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lossId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lossId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLossId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLossId() => $_clearField(1);

  /// False refuses the write-off, which needs a note saying why.
  @$pb.TagNumber(2)
  $core.bool get approve => $_getBF(1);
  @$pb.TagNumber(2)
  set approve($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApprove() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprove() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class ApproveLinenLossResponse extends $pb.GeneratedMessage {
  factory ApproveLinenLossResponse({
    LossRecord? loss,
  }) {
    final result = create();
    if (loss != null) result.loss = loss;
    return result;
  }

  ApproveLinenLossResponse._();

  factory ApproveLinenLossResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveLinenLossResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveLinenLossResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LossRecord>(1, _omitFieldNames ? '' : 'loss',
        subBuilder: LossRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLinenLossResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveLinenLossResponse copyWith(
          void Function(ApproveLinenLossResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveLinenLossResponse))
          as ApproveLinenLossResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLinenLossResponse create() => ApproveLinenLossResponse._();
  @$core.override
  ApproveLinenLossResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveLinenLossResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveLinenLossResponse>(create);
  static ApproveLinenLossResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LossRecord get loss => $_getN(0);
  @$pb.TagNumber(1)
  set loss(LossRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLoss() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoss() => $_clearField(1);
  @$pb.TagNumber(1)
  LossRecord ensureLoss() => $_ensure(0);
}

class RecoverLinenLossRequest extends $pb.GeneratedMessage {
  factory RecoverLinenLossRequest({
    $core.String? lossId,
    $core.String? note,
  }) {
    final result = create();
    if (lossId != null) result.lossId = lossId;
    if (note != null) result.note = note;
    return result;
  }

  RecoverLinenLossRequest._();

  factory RecoverLinenLossRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecoverLinenLossRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecoverLinenLossRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lossId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoverLinenLossRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoverLinenLossRequest copyWith(
          void Function(RecoverLinenLossRequest) updates) =>
      super.copyWith((message) => updates(message as RecoverLinenLossRequest))
          as RecoverLinenLossRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecoverLinenLossRequest create() => RecoverLinenLossRequest._();
  @$core.override
  RecoverLinenLossRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecoverLinenLossRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecoverLinenLossRequest>(create);
  static RecoverLinenLossRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lossId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lossId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLossId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLossId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class RecoverLinenLossResponse extends $pb.GeneratedMessage {
  factory RecoverLinenLossResponse({
    LossRecord? loss,
  }) {
    final result = create();
    if (loss != null) result.loss = loss;
    return result;
  }

  RecoverLinenLossResponse._();

  factory RecoverLinenLossResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecoverLinenLossResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecoverLinenLossResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LossRecord>(1, _omitFieldNames ? '' : 'loss',
        subBuilder: LossRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoverLinenLossResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecoverLinenLossResponse copyWith(
          void Function(RecoverLinenLossResponse) updates) =>
      super.copyWith((message) => updates(message as RecoverLinenLossResponse))
          as RecoverLinenLossResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecoverLinenLossResponse create() => RecoverLinenLossResponse._();
  @$core.override
  RecoverLinenLossResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecoverLinenLossResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecoverLinenLossResponse>(create);
  static RecoverLinenLossResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LossRecord get loss => $_getN(0);
  @$pb.TagNumber(1)
  set loss(LossRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLoss() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoss() => $_clearField(1);
  @$pb.TagNumber(1)
  LossRecord ensureLoss() => $_ensure(0);
}

class ListLinenLossesRequest extends $pb.GeneratedMessage {
  factory ListLinenLossesRequest({
    $core.String? facilityId,
    $core.String? unitId,
    $core.String? itemCode,
    LossKind? kind,
    $core.Iterable<LossState>? states,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (unitId != null) result.unitId = unitId;
    if (itemCode != null) result.itemCode = itemCode;
    if (kind != null) result.kind = kind;
    if (states != null) result.states.addAll(states);
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListLinenLossesRequest._();

  factory ListLinenLossesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenLossesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenLossesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'itemCode')
    ..aE<LossKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: LossKind.values)
    ..pc<LossState>(5, _omitFieldNames ? '' : 'states', $pb.PbFieldType.KE,
        valueOf: LossState.valueOf,
        enumValues: LossState.values,
        defaultEnumValue: LossState.LOSS_STATE_UNSPECIFIED)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(8, _omitFieldNames ? '' : 'pageSize')
    ..aI(9, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenLossesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenLossesRequest copyWith(
          void Function(ListLinenLossesRequest) updates) =>
      super.copyWith((message) => updates(message as ListLinenLossesRequest))
          as ListLinenLossesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenLossesRequest create() => ListLinenLossesRequest._();
  @$core.override
  ListLinenLossesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenLossesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenLossesRequest>(create);
  static ListLinenLossesRequest? _defaultInstance;

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
  $core.String get itemCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemCode() => $_clearField(3);

  @$pb.TagNumber(4)
  LossKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(LossKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<LossState> get states => $_getList(4);

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

class ListLinenLossesResponse extends $pb.GeneratedMessage {
  factory ListLinenLossesResponse({
    $core.Iterable<LossRecord>? losses,
  }) {
    final result = create();
    if (losses != null) result.losses.addAll(losses);
    return result;
  }

  ListLinenLossesResponse._();

  factory ListLinenLossesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLinenLossesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLinenLossesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<LossRecord>(1, _omitFieldNames ? '' : 'losses',
        subBuilder: LossRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenLossesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLinenLossesResponse copyWith(
          void Function(ListLinenLossesResponse) updates) =>
      super.copyWith((message) => updates(message as ListLinenLossesResponse))
          as ListLinenLossesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLinenLossesResponse create() => ListLinenLossesResponse._();
  @$core.override
  ListLinenLossesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLinenLossesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLinenLossesResponse>(create);
  static ListLinenLossesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LossRecord> get losses => $_getList(0);
}

class ListPendingLossApprovalsRequest extends $pb.GeneratedMessage {
  factory ListPendingLossApprovalsRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListPendingLossApprovalsRequest._();

  factory ListPendingLossApprovalsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPendingLossApprovalsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPendingLossApprovalsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingLossApprovalsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingLossApprovalsRequest copyWith(
          void Function(ListPendingLossApprovalsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListPendingLossApprovalsRequest))
          as ListPendingLossApprovalsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPendingLossApprovalsRequest create() =>
      ListPendingLossApprovalsRequest._();
  @$core.override
  ListPendingLossApprovalsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPendingLossApprovalsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPendingLossApprovalsRequest>(
          create);
  static ListPendingLossApprovalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class ListPendingLossApprovalsResponse extends $pb.GeneratedMessage {
  factory ListPendingLossApprovalsResponse({
    $core.Iterable<LossRecord>? losses,
  }) {
    final result = create();
    if (losses != null) result.losses.addAll(losses);
    return result;
  }

  ListPendingLossApprovalsResponse._();

  factory ListPendingLossApprovalsResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPendingLossApprovalsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPendingLossApprovalsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<LossRecord>(1, _omitFieldNames ? '' : 'losses',
        subBuilder: LossRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingLossApprovalsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPendingLossApprovalsResponse copyWith(
          void Function(ListPendingLossApprovalsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPendingLossApprovalsResponse))
          as ListPendingLossApprovalsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPendingLossApprovalsResponse create() =>
      ListPendingLossApprovalsResponse._();
  @$core.override
  ListPendingLossApprovalsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPendingLossApprovalsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPendingLossApprovalsResponse>(
          create);
  static ListPendingLossApprovalsResponse? _defaultInstance;

  /// Largest first: a hundred sheets matters more than four, and a queue in
  /// report order buries it.
  @$pb.TagNumber(1)
  $pb.PbList<LossRecord> get losses => $_getList(0);
}

class RegisterTagRequest extends $pb.GeneratedMessage {
  factory RegisterTagRequest({
    $core.String? tagId,
    TagKind? tagKind,
    $core.String? itemCode,
    $core.String? assignedTo,
    $core.String? facilityId,
  }) {
    final result = create();
    if (tagId != null) result.tagId = tagId;
    if (tagKind != null) result.tagKind = tagKind;
    if (itemCode != null) result.itemCode = itemCode;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  RegisterTagRequest._();

  factory RegisterTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tagId')
    ..aE<TagKind>(2, _omitFieldNames ? '' : 'tagKind',
        enumValues: TagKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'itemCode')
    ..aOS(4, _omitFieldNames ? '' : 'assignedTo')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterTagRequest copyWith(void Function(RegisterTagRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterTagRequest))
          as RegisterTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterTagRequest create() => RegisterTagRequest._();
  @$core.override
  RegisterTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterTagRequest>(create);
  static RegisterTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  TagKind get tagKind => $_getN(1);
  @$pb.TagNumber(2)
  set tagKind(TagKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTagKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearTagKind() => $_clearField(2);

  /// Refused unless the master calls this item tracked.
  @$pb.TagNumber(3)
  $core.String get itemCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get assignedTo => $_getSZ(3);
  @$pb.TagNumber(4)
  set assignedTo($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssignedTo() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssignedTo() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);
}

class RegisterTagResponse extends $pb.GeneratedMessage {
  factory RegisterTagResponse({
    TrackedItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  RegisterTagResponse._();

  factory RegisterTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RegisterTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RegisterTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<TrackedItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: TrackedItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RegisterTagResponse copyWith(void Function(RegisterTagResponse) updates) =>
      super.copyWith((message) => updates(message as RegisterTagResponse))
          as RegisterTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegisterTagResponse create() => RegisterTagResponse._();
  @$core.override
  RegisterTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RegisterTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterTagResponse>(create);
  static RegisterTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackedItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(TrackedItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  TrackedItem ensureItem() => $_ensure(0);
}

class RecordTagScanRequest extends $pb.GeneratedMessage {
  factory RecordTagScanRequest({
    $core.String? tagId,
    $core.String? location,
    $core.String? holderId,
    $core.String? note,
  }) {
    final result = create();
    if (tagId != null) result.tagId = tagId;
    if (location != null) result.location = location;
    if (holderId != null) result.holderId = holderId;
    if (note != null) result.note = note;
    return result;
  }

  RecordTagScanRequest._();

  factory RecordTagScanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTagScanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTagScanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tagId')
    ..aOS(2, _omitFieldNames ? '' : 'location')
    ..aOS(3, _omitFieldNames ? '' : 'holderId')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTagScanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTagScanRequest copyWith(void Function(RecordTagScanRequest) updates) =>
      super.copyWith((message) => updates(message as RecordTagScanRequest))
          as RecordTagScanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTagScanRequest create() => RecordTagScanRequest._();
  @$core.override
  RecordTagScanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTagScanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTagScanRequest>(create);
  static RecordTagScanRequest? _defaultInstance;

  /// What came off the reader. A scan arrives as a tag, not an identifier.
  @$pb.TagNumber(1)
  $core.String get tagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTagId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get location => $_getSZ(1);
  @$pb.TagNumber(2)
  set location($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocation() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get holderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set holderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHolderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearHolderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class RecordTagScanResponse extends $pb.GeneratedMessage {
  factory RecordTagScanResponse({
    TrackedItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  RecordTagScanResponse._();

  factory RecordTagScanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordTagScanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordTagScanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<TrackedItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: TrackedItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTagScanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordTagScanResponse copyWith(
          void Function(RecordTagScanResponse) updates) =>
      super.copyWith((message) => updates(message as RecordTagScanResponse))
          as RecordTagScanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordTagScanResponse create() => RecordTagScanResponse._();
  @$core.override
  RecordTagScanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordTagScanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordTagScanResponse>(create);
  static RecordTagScanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackedItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(TrackedItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  TrackedItem ensureItem() => $_ensure(0);
}

class RetireTagRequest extends $pb.GeneratedMessage {
  factory RetireTagRequest({
    $core.String? trackedId,
    $core.String? reason,
  }) {
    final result = create();
    if (trackedId != null) result.trackedId = trackedId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RetireTagRequest._();

  factory RetireTagRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireTagRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireTagRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trackedId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTagRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTagRequest copyWith(void Function(RetireTagRequest) updates) =>
      super.copyWith((message) => updates(message as RetireTagRequest))
          as RetireTagRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireTagRequest create() => RetireTagRequest._();
  @$core.override
  RetireTagRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireTagRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireTagRequest>(create);
  static RetireTagRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trackedId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trackedId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTrackedId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrackedId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class RetireTagResponse extends $pb.GeneratedMessage {
  factory RetireTagResponse({
    TrackedItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  RetireTagResponse._();

  factory RetireTagResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireTagResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireTagResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<TrackedItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: TrackedItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTagResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireTagResponse copyWith(void Function(RetireTagResponse) updates) =>
      super.copyWith((message) => updates(message as RetireTagResponse))
          as RetireTagResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireTagResponse create() => RetireTagResponse._();
  @$core.override
  RetireTagResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireTagResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireTagResponse>(create);
  static RetireTagResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackedItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(TrackedItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  TrackedItem ensureItem() => $_ensure(0);
}

class GetTagCustodyRequest extends $pb.GeneratedMessage {
  factory GetTagCustodyRequest({
    $core.String? tagId,
  }) {
    final result = create();
    if (tagId != null) result.tagId = tagId;
    return result;
  }

  GetTagCustodyRequest._();

  factory GetTagCustodyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTagCustodyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTagCustodyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tagId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTagCustodyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTagCustodyRequest copyWith(void Function(GetTagCustodyRequest) updates) =>
      super.copyWith((message) => updates(message as GetTagCustodyRequest))
          as GetTagCustodyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTagCustodyRequest create() => GetTagCustodyRequest._();
  @$core.override
  GetTagCustodyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTagCustodyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTagCustodyRequest>(create);
  static GetTagCustodyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tagId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tagId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTagId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTagId() => $_clearField(1);
}

class GetTagCustodyResponse extends $pb.GeneratedMessage {
  factory GetTagCustodyResponse({
    TrackedItem? item,
    Custody? custody,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (custody != null) result.custody = custody;
    return result;
  }

  GetTagCustodyResponse._();

  factory GetTagCustodyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTagCustodyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTagCustodyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<TrackedItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: TrackedItem.create)
    ..aOM<Custody>(2, _omitFieldNames ? '' : 'custody',
        subBuilder: Custody.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTagCustodyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTagCustodyResponse copyWith(
          void Function(GetTagCustodyResponse) updates) =>
      super.copyWith((message) => updates(message as GetTagCustodyResponse))
          as GetTagCustodyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTagCustodyResponse create() => GetTagCustodyResponse._();
  @$core.override
  GetTagCustodyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTagCustodyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTagCustodyResponse>(create);
  static GetTagCustodyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TrackedItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(TrackedItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  TrackedItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  Custody get custody => $_getN(1);
  @$pb.TagNumber(2)
  set custody(Custody value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCustody() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustody() => $_clearField(2);
  @$pb.TagNumber(2)
  Custody ensureCustody() => $_ensure(1);
}

class ListTrackedItemsRequest extends $pb.GeneratedMessage {
  factory ListTrackedItemsRequest({
    $core.String? facilityId,
    $core.String? itemCode,
    $core.String? assignedTo,
    $core.bool? inServiceOnly,
    $core.int? pageSize,
    $core.int? offset,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (itemCode != null) result.itemCode = itemCode;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (inServiceOnly != null) result.inServiceOnly = inServiceOnly;
    if (pageSize != null) result.pageSize = pageSize;
    if (offset != null) result.offset = offset;
    return result;
  }

  ListTrackedItemsRequest._();

  factory ListTrackedItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTrackedItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTrackedItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'itemCode')
    ..aOS(3, _omitFieldNames ? '' : 'assignedTo')
    ..aOB(4, _omitFieldNames ? '' : 'inServiceOnly')
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..aI(6, _omitFieldNames ? '' : 'offset')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTrackedItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTrackedItemsRequest copyWith(
          void Function(ListTrackedItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTrackedItemsRequest))
          as ListTrackedItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTrackedItemsRequest create() => ListTrackedItemsRequest._();
  @$core.override
  ListTrackedItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTrackedItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTrackedItemsRequest>(create);
  static ListTrackedItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assignedTo => $_getSZ(2);
  @$pb.TagNumber(3)
  set assignedTo($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAssignedTo() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssignedTo() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get inServiceOnly => $_getBF(3);
  @$pb.TagNumber(4)
  set inServiceOnly($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasInServiceOnly() => $_has(3);
  @$pb.TagNumber(4)
  void clearInServiceOnly() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get offset => $_getIZ(5);
  @$pb.TagNumber(6)
  set offset($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOffset() => $_has(5);
  @$pb.TagNumber(6)
  void clearOffset() => $_clearField(6);
}

class ListTrackedItemsResponse extends $pb.GeneratedMessage {
  factory ListTrackedItemsResponse({
    $core.Iterable<TrackedItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListTrackedItemsResponse._();

  factory ListTrackedItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTrackedItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTrackedItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<TrackedItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: TrackedItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTrackedItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTrackedItemsResponse copyWith(
          void Function(ListTrackedItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTrackedItemsResponse))
          as ListTrackedItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTrackedItemsResponse create() => ListTrackedItemsResponse._();
  @$core.override
  ListTrackedItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTrackedItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTrackedItemsResponse>(create);
  static ListTrackedItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TrackedItem> get items => $_getList(0);
}

class StaleTrackedItem extends $pb.GeneratedMessage {
  factory StaleTrackedItem({
    TrackedItem? item,
    Custody? custody,
    $core.int? quietDays,
    $core.bool? neverSeen,
  }) {
    final result = create();
    if (item != null) result.item = item;
    if (custody != null) result.custody = custody;
    if (quietDays != null) result.quietDays = quietDays;
    if (neverSeen != null) result.neverSeen = neverSeen;
    return result;
  }

  StaleTrackedItem._();

  factory StaleTrackedItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StaleTrackedItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StaleTrackedItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<TrackedItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: TrackedItem.create)
    ..aOM<Custody>(2, _omitFieldNames ? '' : 'custody',
        subBuilder: Custody.create)
    ..aI(3, _omitFieldNames ? '' : 'quietDays')
    ..aOB(4, _omitFieldNames ? '' : 'neverSeen')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaleTrackedItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaleTrackedItem copyWith(void Function(StaleTrackedItem) updates) =>
      super.copyWith((message) => updates(message as StaleTrackedItem))
          as StaleTrackedItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StaleTrackedItem create() => StaleTrackedItem._();
  @$core.override
  StaleTrackedItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StaleTrackedItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StaleTrackedItem>(create);
  static StaleTrackedItem? _defaultInstance;

  @$pb.TagNumber(1)
  TrackedItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(TrackedItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  TrackedItem ensureItem() => $_ensure(0);

  @$pb.TagNumber(2)
  Custody get custody => $_getN(1);
  @$pb.TagNumber(2)
  set custody(Custody value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCustody() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustody() => $_clearField(2);
  @$pb.TagNumber(2)
  Custody ensureCustody() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get quietDays => $_getIZ(2);
  @$pb.TagNumber(3)
  set quietDays($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuietDays() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuietDays() => $_clearField(3);

  /// Nobody has scanned it at all since registration. Appears first: a tag
  /// that never read once is more likely to be a tag that does not work than
  /// a garment in a cupboard.
  @$pb.TagNumber(4)
  $core.bool get neverSeen => $_getBF(3);
  @$pb.TagNumber(4)
  set neverSeen($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNeverSeen() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeverSeen() => $_clearField(4);
}

class ListStaleTrackedItemsRequest extends $pb.GeneratedMessage {
  factory ListStaleTrackedItemsRequest({
    $core.String? facilityId,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  ListStaleTrackedItemsRequest._();

  factory ListStaleTrackedItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStaleTrackedItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStaleTrackedItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleTrackedItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleTrackedItemsRequest copyWith(
          void Function(ListStaleTrackedItemsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListStaleTrackedItemsRequest))
          as ListStaleTrackedItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStaleTrackedItemsRequest create() =>
      ListStaleTrackedItemsRequest._();
  @$core.override
  ListStaleTrackedItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStaleTrackedItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStaleTrackedItemsRequest>(create);
  static ListStaleTrackedItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);
}

class ListStaleTrackedItemsResponse extends $pb.GeneratedMessage {
  factory ListStaleTrackedItemsResponse({
    $core.Iterable<StaleTrackedItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListStaleTrackedItemsResponse._();

  factory ListStaleTrackedItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStaleTrackedItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStaleTrackedItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..pPM<StaleTrackedItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: StaleTrackedItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleTrackedItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStaleTrackedItemsResponse copyWith(
          void Function(ListStaleTrackedItemsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListStaleTrackedItemsResponse))
          as ListStaleTrackedItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStaleTrackedItemsResponse create() =>
      ListStaleTrackedItemsResponse._();
  @$core.override
  ListStaleTrackedItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStaleTrackedItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStaleTrackedItemsResponse>(create);
  static ListStaleTrackedItemsResponse? _defaultInstance;

  /// A report and nothing else. Nothing here writes an item off.
  @$pb.TagNumber(1)
  $pb.PbList<StaleTrackedItem> get items => $_getList(0);
}

class WashSummary extends $pb.GeneratedMessage {
  factory WashSummary({
    $core.int? run,
    $core.int? passed,
    $core.int? failed,
    $core.int? rewashed,
    $core.int? inFlight,
    $core.int? infected,
    $core.int? weightKg,
    $core.int? withExceptions,
    $core.bool? unanswerable,
  }) {
    final result = create();
    if (run != null) result.run = run;
    if (passed != null) result.passed = passed;
    if (failed != null) result.failed = failed;
    if (rewashed != null) result.rewashed = rewashed;
    if (inFlight != null) result.inFlight = inFlight;
    if (infected != null) result.infected = infected;
    if (weightKg != null) result.weightKg = weightKg;
    if (withExceptions != null) result.withExceptions = withExceptions;
    if (unanswerable != null) result.unanswerable = unanswerable;
    return result;
  }

  WashSummary._();

  factory WashSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WashSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WashSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'run')
    ..aI(2, _omitFieldNames ? '' : 'passed')
    ..aI(3, _omitFieldNames ? '' : 'failed')
    ..aI(4, _omitFieldNames ? '' : 'rewashed')
    ..aI(5, _omitFieldNames ? '' : 'inFlight')
    ..aI(6, _omitFieldNames ? '' : 'infected')
    ..aI(7, _omitFieldNames ? '' : 'weightKg')
    ..aI(8, _omitFieldNames ? '' : 'withExceptions')
    ..aOB(9, _omitFieldNames ? '' : 'unanswerable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WashSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WashSummary copyWith(void Function(WashSummary) updates) =>
      super.copyWith((message) => updates(message as WashSummary))
          as WashSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WashSummary create() => WashSummary._();
  @$core.override
  WashSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WashSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WashSummary>(create);
  static WashSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get run => $_getIZ(0);
  @$pb.TagNumber(1)
  set run($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRun() => $_has(0);
  @$pb.TagNumber(1)
  void clearRun() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.int get rewashed => $_getIZ(3);
  @$pb.TagNumber(4)
  set rewashed($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRewashed() => $_has(3);
  @$pb.TagNumber(4)
  void clearRewashed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get inFlight => $_getIZ(4);
  @$pb.TagNumber(5)
  set inFlight($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInFlight() => $_has(4);
  @$pb.TagNumber(5)
  void clearInFlight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get infected => $_getIZ(5);
  @$pb.TagNumber(6)
  set infected($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasInfected() => $_has(5);
  @$pb.TagNumber(6)
  void clearInfected() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get weightKg => $_getIZ(6);
  @$pb.TagNumber(7)
  set weightKg($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWeightKg() => $_has(6);
  @$pb.TagNumber(7)
  void clearWeightKg() => $_clearField(7);

  /// Batches that recorded an exception, passed or failed. Counted apart
  /// from the failures: a load that passed with a probe fault is the one
  /// that tells a hospital its next load will not.
  @$pb.TagNumber(8)
  $core.int get withExceptions => $_getIZ(7);
  @$pb.TagNumber(8)
  set withExceptions($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWithExceptions() => $_has(7);
  @$pb.TagNumber(8)
  void clearWithExceptions() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get unanswerable => $_getBF(8);
  @$pb.TagNumber(9)
  set unanswerable($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasUnanswerable() => $_has(8);
  @$pb.TagNumber(9)
  void clearUnanswerable() => $_clearField(9);
}

class GetWashReportRequest extends $pb.GeneratedMessage {
  factory GetWashReportRequest({
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

  GetWashReportRequest._();

  factory GetWashReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWashReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWashReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashReportRequest copyWith(void Function(GetWashReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetWashReportRequest))
          as GetWashReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWashReportRequest create() => GetWashReportRequest._();
  @$core.override
  GetWashReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWashReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWashReportRequest>(create);
  static GetWashReportRequest? _defaultInstance;

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

class GetWashReportResponse extends $pb.GeneratedMessage {
  factory GetWashReportResponse({
    WashSummary? summary,
    $core.bool? truncated,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetWashReportResponse._();

  factory GetWashReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWashReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWashReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<WashSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: WashSummary.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWashReportResponse copyWith(
          void Function(GetWashReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetWashReportResponse))
          as GetWashReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWashReportResponse create() => GetWashReportResponse._();
  @$core.override
  GetWashReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWashReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWashReportResponse>(create);
  static GetWashReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WashSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(WashSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  WashSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

class LinenLossSummary extends $pb.GeneratedMessage {
  factory LinenLossSummary({
    $core.int? reported,
    $core.int? pieces,
    $core.int? valueMinor,
    $core.int? condemned,
    $core.int? damaged,
    $core.int? missing,
    $core.int? recovered,
    $core.int? awaitingApproval,
    $core.int? rejected,
  }) {
    final result = create();
    if (reported != null) result.reported = reported;
    if (pieces != null) result.pieces = pieces;
    if (valueMinor != null) result.valueMinor = valueMinor;
    if (condemned != null) result.condemned = condemned;
    if (damaged != null) result.damaged = damaged;
    if (missing != null) result.missing = missing;
    if (recovered != null) result.recovered = recovered;
    if (awaitingApproval != null) result.awaitingApproval = awaitingApproval;
    if (rejected != null) result.rejected = rejected;
    return result;
  }

  LinenLossSummary._();

  factory LinenLossSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LinenLossSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LinenLossSummary',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'reported')
    ..aI(2, _omitFieldNames ? '' : 'pieces')
    ..aI(3, _omitFieldNames ? '' : 'valueMinor')
    ..aI(4, _omitFieldNames ? '' : 'condemned')
    ..aI(5, _omitFieldNames ? '' : 'damaged')
    ..aI(6, _omitFieldNames ? '' : 'missing')
    ..aI(7, _omitFieldNames ? '' : 'recovered')
    ..aI(8, _omitFieldNames ? '' : 'awaitingApproval')
    ..aI(9, _omitFieldNames ? '' : 'rejected')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenLossSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LinenLossSummary copyWith(void Function(LinenLossSummary) updates) =>
      super.copyWith((message) => updates(message as LinenLossSummary))
          as LinenLossSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinenLossSummary create() => LinenLossSummary._();
  @$core.override
  LinenLossSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LinenLossSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LinenLossSummary>(create);
  static LinenLossSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get reported => $_getIZ(0);
  @$pb.TagNumber(1)
  set reported($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReported() => $_has(0);
  @$pb.TagNumber(1)
  void clearReported() => $_clearField(1);

  /// Approved write-offs only.
  @$pb.TagNumber(2)
  $core.int get pieces => $_getIZ(1);
  @$pb.TagNumber(2)
  set pieces($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPieces() => $_has(1);
  @$pb.TagNumber(2)
  void clearPieces() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get valueMinor => $_getIZ(2);
  @$pb.TagNumber(3)
  set valueMinor($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValueMinor() => $_has(2);
  @$pb.TagNumber(3)
  void clearValueMinor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get condemned => $_getIZ(3);
  @$pb.TagNumber(4)
  set condemned($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCondemned() => $_has(3);
  @$pb.TagNumber(4)
  void clearCondemned() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get damaged => $_getIZ(4);
  @$pb.TagNumber(5)
  set damaged($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDamaged() => $_has(4);
  @$pb.TagNumber(5)
  void clearDamaged() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get missing => $_getIZ(5);
  @$pb.TagNumber(6)
  set missing($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMissing() => $_has(5);
  @$pb.TagNumber(6)
  void clearMissing() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get recovered => $_getIZ(6);
  @$pb.TagNumber(7)
  set recovered($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRecovered() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecovered() => $_clearField(7);

  /// Reported beside the totals rather than folded in, because a large
  /// figure here means the totals are understated.
  @$pb.TagNumber(8)
  $core.int get awaitingApproval => $_getIZ(7);
  @$pb.TagNumber(8)
  set awaitingApproval($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAwaitingApproval() => $_has(7);
  @$pb.TagNumber(8)
  void clearAwaitingApproval() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get rejected => $_getIZ(8);
  @$pb.TagNumber(9)
  set rejected($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRejected() => $_has(8);
  @$pb.TagNumber(9)
  void clearRejected() => $_clearField(9);
}

class GetLinenLossReportRequest extends $pb.GeneratedMessage {
  factory GetLinenLossReportRequest({
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

  GetLinenLossReportRequest._();

  factory GetLinenLossReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLinenLossReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinenLossReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinenLossReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinenLossReportRequest copyWith(
          void Function(GetLinenLossReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetLinenLossReportRequest))
          as GetLinenLossReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLinenLossReportRequest create() => GetLinenLossReportRequest._();
  @$core.override
  GetLinenLossReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLinenLossReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinenLossReportRequest>(create);
  static GetLinenLossReportRequest? _defaultInstance;

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

class GetLinenLossReportResponse extends $pb.GeneratedMessage {
  factory GetLinenLossReportResponse({
    LinenLossSummary? summary,
    $core.bool? truncated,
  }) {
    final result = create();
    if (summary != null) result.summary = summary;
    if (truncated != null) result.truncated = truncated;
    return result;
  }

  GetLinenLossReportResponse._();

  factory GetLinenLossReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLinenLossReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLinenLossReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.laundry.v1'),
      createEmptyInstance: create)
    ..aOM<LinenLossSummary>(1, _omitFieldNames ? '' : 'summary',
        subBuilder: LinenLossSummary.create)
    ..aOB(2, _omitFieldNames ? '' : 'truncated')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinenLossReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLinenLossReportResponse copyWith(
          void Function(GetLinenLossReportResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetLinenLossReportResponse))
          as GetLinenLossReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLinenLossReportResponse create() => GetLinenLossReportResponse._();
  @$core.override
  GetLinenLossReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLinenLossReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLinenLossReportResponse>(create);
  static GetLinenLossReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LinenLossSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(LinenLossSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  LinenLossSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get truncated => $_getBF(1);
  @$pb.TagNumber(2)
  set truncated($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTruncated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTruncated() => $_clearField(2);
}

/// Laundry and linen (SRS-LND-001 … 007).
class LaundryServiceApi {
  final $pb.RpcClient _client;

  LaundryServiceApi(this._client);

  /// Linen item master and unit par levels (SRS-LND-001).
  $async.Future<ConfigureLinenItemResponse> configureLinenItem(
          $pb.ClientContext? ctx, ConfigureLinenItemRequest request) =>
      _client.invoke<ConfigureLinenItemResponse>(ctx, 'LaundryService',
          'ConfigureLinenItem', request, ConfigureLinenItemResponse());
  $async.Future<RetireLinenItemResponse> retireLinenItem(
          $pb.ClientContext? ctx, RetireLinenItemRequest request) =>
      _client.invoke<RetireLinenItemResponse>(ctx, 'LaundryService',
          'RetireLinenItem', request, RetireLinenItemResponse());
  $async.Future<ListLinenItemsResponse> listLinenItems(
          $pb.ClientContext? ctx, ListLinenItemsRequest request) =>
      _client.invoke<ListLinenItemsResponse>(ctx, 'LaundryService',
          'ListLinenItems', request, ListLinenItemsResponse());
  $async.Future<SetParLevelResponse> setParLevel(
          $pb.ClientContext? ctx, SetParLevelRequest request) =>
      _client.invoke<SetParLevelResponse>(
          ctx, 'LaundryService', 'SetParLevel', request, SetParLevelResponse());
  $async.Future<ApproveParLevelResponse> approveParLevel(
          $pb.ClientContext? ctx, ApproveParLevelRequest request) =>
      _client.invoke<ApproveParLevelResponse>(ctx, 'LaundryService',
          'ApproveParLevel', request, ApproveParLevelResponse());
  $async.Future<GetParInForceResponse> getParInForce(
          $pb.ClientContext? ctx, GetParInForceRequest request) =>
      _client.invoke<GetParInForceResponse>(ctx, 'LaundryService',
          'GetParInForce', request, GetParInForceResponse());
  $async.Future<ListParLevelsResponse> listParLevels(
          $pb.ClientContext? ctx, ListParLevelsRequest request) =>
      _client.invoke<ListParLevelsResponse>(ctx, 'LaundryService',
          'ListParLevels', request, ListParLevelsResponse());

  /// Soiled collection (SRS-LND-002, SRS-LND-005).
  $async.Future<RecordCollectionResponse> recordCollection(
          $pb.ClientContext? ctx, RecordCollectionRequest request) =>
      _client.invoke<RecordCollectionResponse>(ctx, 'LaundryService',
          'RecordCollection', request, RecordCollectionResponse());
  $async.Future<RecountCollectionResponse> recountCollection(
          $pb.ClientContext? ctx, RecountCollectionRequest request) =>
      _client.invoke<RecountCollectionResponse>(ctx, 'LaundryService',
          'RecountCollection', request, RecountCollectionResponse());
  $async.Future<CancelCollectionResponse> cancelCollection(
          $pb.ClientContext? ctx, CancelCollectionRequest request) =>
      _client.invoke<CancelCollectionResponse>(ctx, 'LaundryService',
          'CancelCollection', request, CancelCollectionResponse());
  $async.Future<ListCollectionsResponse> listCollections(
          $pb.ClientContext? ctx, ListCollectionsRequest request) =>
      _client.invoke<ListCollectionsResponse>(ctx, 'LaundryService',
          'ListCollections', request, ListCollectionsResponse());
  $async.Future<CheckCollectionWeightResponse> checkCollectionWeight(
          $pb.ClientContext? ctx, CheckCollectionWeightRequest request) =>
      _client.invoke<CheckCollectionWeightResponse>(ctx, 'LaundryService',
          'CheckCollectionWeight', request, CheckCollectionWeightResponse());

  /// Wash batches (SRS-LND-003, SRS-LND-005).
  $async.Future<OpenWashBatchResponse> openWashBatch(
          $pb.ClientContext? ctx, OpenWashBatchRequest request) =>
      _client.invoke<OpenWashBatchResponse>(ctx, 'LaundryService',
          'OpenWashBatch', request, OpenWashBatchResponse());
  $async.Future<LoadWashBatchResponse> loadWashBatch(
          $pb.ClientContext? ctx, LoadWashBatchRequest request) =>
      _client.invoke<LoadWashBatchResponse>(ctx, 'LaundryService',
          'LoadWashBatch', request, LoadWashBatchResponse());
  $async.Future<StartWashBatchResponse> startWashBatch(
          $pb.ClientContext? ctx, StartWashBatchRequest request) =>
      _client.invoke<StartWashBatchResponse>(ctx, 'LaundryService',
          'StartWashBatch', request, StartWashBatchResponse());
  $async.Future<CompleteWashBatchResponse> completeWashBatch(
          $pb.ClientContext? ctx, CompleteWashBatchRequest request) =>
      _client.invoke<CompleteWashBatchResponse>(ctx, 'LaundryService',
          'CompleteWashBatch', request, CompleteWashBatchResponse());
  $async.Future<RewashBatchResponse> rewashBatch(
          $pb.ClientContext? ctx, RewashBatchRequest request) =>
      _client.invoke<RewashBatchResponse>(
          ctx, 'LaundryService', 'RewashBatch', request, RewashBatchResponse());
  $async.Future<GetWashBatchResponse> getWashBatch(
          $pb.ClientContext? ctx, GetWashBatchRequest request) =>
      _client.invoke<GetWashBatchResponse>(ctx, 'LaundryService',
          'GetWashBatch', request, GetWashBatchResponse());
  $async.Future<ListWashBatchesResponse> listWashBatches(
          $pb.ClientContext? ctx, ListWashBatchesRequest request) =>
      _client.invoke<ListWashBatchesResponse>(ctx, 'LaundryService',
          'ListWashBatches', request, ListWashBatchesResponse());
  $async.Future<ListAffectedUnitsResponse> listAffectedUnits(
          $pb.ClientContext? ctx, ListAffectedUnitsRequest request) =>
      _client.invoke<ListAffectedUnitsResponse>(ctx, 'LaundryService',
          'ListAffectedUnits', request, ListAffectedUnitsResponse());

  /// Clean linen issue and unit stock (SRS-LND-004).
  $async.Future<IssueLinenResponse> issueLinen(
          $pb.ClientContext? ctx, IssueLinenRequest request) =>
      _client.invoke<IssueLinenResponse>(
          ctx, 'LaundryService', 'IssueLinen', request, IssueLinenResponse());
  $async.Future<ReceiveLinenResponse> receiveLinen(
          $pb.ClientContext? ctx, ReceiveLinenRequest request) =>
      _client.invoke<ReceiveLinenResponse>(ctx, 'LaundryService',
          'ReceiveLinen', request, ReceiveLinenResponse());
  $async.Future<ListLinenIssuesResponse> listLinenIssues(
          $pb.ClientContext? ctx, ListLinenIssuesRequest request) =>
      _client.invoke<ListLinenIssuesResponse>(ctx, 'LaundryService',
          'ListLinenIssues', request, ListLinenIssuesResponse());
  $async.Future<GetUnitStockResponse> getUnitStock(
          $pb.ClientContext? ctx, GetUnitStockRequest request) =>
      _client.invoke<GetUnitStockResponse>(ctx, 'LaundryService',
          'GetUnitStock', request, GetUnitStockResponse());

  /// Condemned, damaged and missing linen (SRS-LND-006).
  $async.Future<ReportLinenLossResponse> reportLinenLoss(
          $pb.ClientContext? ctx, ReportLinenLossRequest request) =>
      _client.invoke<ReportLinenLossResponse>(ctx, 'LaundryService',
          'ReportLinenLoss', request, ReportLinenLossResponse());
  $async.Future<ApproveLinenLossResponse> approveLinenLoss(
          $pb.ClientContext? ctx, ApproveLinenLossRequest request) =>
      _client.invoke<ApproveLinenLossResponse>(ctx, 'LaundryService',
          'ApproveLinenLoss', request, ApproveLinenLossResponse());
  $async.Future<RecoverLinenLossResponse> recoverLinenLoss(
          $pb.ClientContext? ctx, RecoverLinenLossRequest request) =>
      _client.invoke<RecoverLinenLossResponse>(ctx, 'LaundryService',
          'RecoverLinenLoss', request, RecoverLinenLossResponse());
  $async.Future<ListLinenLossesResponse> listLinenLosses(
          $pb.ClientContext? ctx, ListLinenLossesRequest request) =>
      _client.invoke<ListLinenLossesResponse>(ctx, 'LaundryService',
          'ListLinenLosses', request, ListLinenLossesResponse());
  $async.Future<ListPendingLossApprovalsResponse> listPendingLossApprovals(
          $pb.ClientContext? ctx, ListPendingLossApprovalsRequest request) =>
      _client.invoke<ListPendingLossApprovalsResponse>(
          ctx,
          'LaundryService',
          'ListPendingLossApprovals',
          request,
          ListPendingLossApprovalsResponse());

  /// Tagged linen and uniforms (SRS-LND-007).
  $async.Future<RegisterTagResponse> registerTag(
          $pb.ClientContext? ctx, RegisterTagRequest request) =>
      _client.invoke<RegisterTagResponse>(
          ctx, 'LaundryService', 'RegisterTag', request, RegisterTagResponse());
  $async.Future<RecordTagScanResponse> recordTagScan(
          $pb.ClientContext? ctx, RecordTagScanRequest request) =>
      _client.invoke<RecordTagScanResponse>(ctx, 'LaundryService',
          'RecordTagScan', request, RecordTagScanResponse());
  $async.Future<RetireTagResponse> retireTag(
          $pb.ClientContext? ctx, RetireTagRequest request) =>
      _client.invoke<RetireTagResponse>(
          ctx, 'LaundryService', 'RetireTag', request, RetireTagResponse());
  $async.Future<GetTagCustodyResponse> getTagCustody(
          $pb.ClientContext? ctx, GetTagCustodyRequest request) =>
      _client.invoke<GetTagCustodyResponse>(ctx, 'LaundryService',
          'GetTagCustody', request, GetTagCustodyResponse());
  $async.Future<ListTrackedItemsResponse> listTrackedItems(
          $pb.ClientContext? ctx, ListTrackedItemsRequest request) =>
      _client.invoke<ListTrackedItemsResponse>(ctx, 'LaundryService',
          'ListTrackedItems', request, ListTrackedItemsResponse());
  $async.Future<ListStaleTrackedItemsResponse> listStaleTrackedItems(
          $pb.ClientContext? ctx, ListStaleTrackedItemsRequest request) =>
      _client.invoke<ListStaleTrackedItemsResponse>(ctx, 'LaundryService',
          'ListStaleTrackedItems', request, ListStaleTrackedItemsResponse());

  /// Reporting (SRS-LND-003, SRS-LND-006).
  $async.Future<GetWashReportResponse> getWashReport(
          $pb.ClientContext? ctx, GetWashReportRequest request) =>
      _client.invoke<GetWashReportResponse>(ctx, 'LaundryService',
          'GetWashReport', request, GetWashReportResponse());
  $async.Future<GetLinenLossReportResponse> getLinenLossReport(
          $pb.ClientContext? ctx, GetLinenLossReportRequest request) =>
      _client.invoke<GetLinenLossReportResponse>(ctx, 'LaundryService',
          'GetLinenLossReport', request, GetLinenLossReportResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
