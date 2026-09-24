// This is a generated file - do not edit.
//
// Generated from healthcare/materials/v1/materials.proto.

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

import 'materials.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'materials.pbenum.dart';

/// An amount in minor units, with its currency.
///
/// Never a float: a rupee is a hundred paise, and two identical orders that
/// total differently because of binary fractions is a defect found in an audit.
/// The currency travels with the amount because a hospital buys from more than
/// one country.
class Money extends $pb.GeneratedMessage {
  factory Money({
    $fixnum.Int64? minor,
    $core.String? currency,
  }) {
    final result = create();
    if (minor != null) result.minor = minor;
    if (currency != null) result.currency = currency;
    return result;
  }

  Money._();

  factory Money.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Money.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Money',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'minor')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Money copyWith(void Function(Money) updates) =>
      super.copyWith((message) => updates(message as Money)) as Money;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Money create() => Money._();
  @$core.override
  Money createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Money getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Money>(create);
  static Money? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minor => $_getI64(0);
  @$pb.TagNumber(1)
  set minor($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);
}

/// Where a quantity sits: a location and a status.
///
/// An empty location is outside the hospital — the supplier a receipt came
/// from, the patient a consumable went into.
class Bucket extends $pb.GeneratedMessage {
  factory Bucket({
    $core.String? locationId,
    StockStatus? status,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (status != null) result.status = status;
    return result;
  }

  Bucket._();

  factory Bucket.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bucket.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bucket',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aE<StockStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: StockStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bucket clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bucket copyWith(void Function(Bucket) updates) =>
      super.copyWith((message) => updates(message as Bucket)) as Bucket;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bucket create() => Bucket._();
  @$core.override
  Bucket createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Bucket getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bucket>(create);
  static Bucket? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  StockStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(StockStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);
}

/// One line of the materials master (SRS-MAT-001).
class Item extends $pb.GeneratedMessage {
  factory Item({
    $core.String? itemId,
    $core.String? code,
    $core.String? display,
    $core.String? category,
    $core.String? uom,
    Tracking? tracking,
    PickPolicy? policy,
    $core.bool? perishable,
    $core.bool? inspectOnReceipt,
    $core.bool? consignable,
    $core.bool? active,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (category != null) result.category = category;
    if (uom != null) result.uom = uom;
    if (tracking != null) result.tracking = tracking;
    if (policy != null) result.policy = policy;
    if (perishable != null) result.perishable = perishable;
    if (inspectOnReceipt != null) result.inspectOnReceipt = inspectOnReceipt;
    if (consignable != null) result.consignable = consignable;
    if (active != null) result.active = active;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Item._();

  factory Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Item',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'uom')
    ..aE<Tracking>(6, _omitFieldNames ? '' : 'tracking',
        enumValues: Tracking.values)
    ..aE<PickPolicy>(7, _omitFieldNames ? '' : 'policy',
        enumValues: PickPolicy.values)
    ..aOB(8, _omitFieldNames ? '' : 'perishable')
    ..aOB(9, _omitFieldNames ? '' : 'inspectOnReceipt')
    ..aOB(10, _omitFieldNames ? '' : 'consignable')
    ..aOB(11, _omitFieldNames ? '' : 'active')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Item copyWith(void Function(Item) updates) =>
      super.copyWith((message) => updates(message as Item)) as Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Item create() => Item._();
  @$core.override
  Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Item getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Item>(create);
  static Item? _defaultInstance;

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
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  /// The unit stock is held and issued in, one unit throughout. Purchasing in
  /// boxes is expressed as a pack size on the order line.
  @$pb.TagNumber(5)
  $core.String get uom => $_getSZ(4);
  @$pb.TagNumber(5)
  set uom($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUom() => $_has(4);
  @$pb.TagNumber(5)
  void clearUom() => $_clearField(5);

  @$pb.TagNumber(6)
  Tracking get tracking => $_getN(5);
  @$pb.TagNumber(6)
  set tracking(Tracking value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasTracking() => $_has(5);
  @$pb.TagNumber(6)
  void clearTracking() => $_clearField(6);

  @$pb.TagNumber(7)
  PickPolicy get policy => $_getN(6);
  @$pb.TagNumber(7)
  set policy(PickPolicy value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPolicy() => $_has(6);
  @$pb.TagNumber(7)
  void clearPolicy() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get perishable => $_getBF(7);
  @$pb.TagNumber(8)
  set perishable($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPerishable() => $_has(7);
  @$pb.TagNumber(8)
  void clearPerishable() => $_clearField(8);

  /// Holds a receipt in quarantine until somebody accepts it (SRS-MAT-006).
  @$pb.TagNumber(9)
  $core.bool get inspectOnReceipt => $_getBF(8);
  @$pb.TagNumber(9)
  set inspectOnReceipt($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasInspectOnReceipt() => $_has(8);
  @$pb.TagNumber(9)
  void clearInspectOnReceipt() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get consignable => $_getBF(9);
  @$pb.TagNumber(10)
  set consignable($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasConsignable() => $_has(9);
  @$pb.TagNumber(10)
  void clearConsignable() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get active => $_getBF(10);
  @$pb.TagNumber(11)
  set active($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasActive() => $_has(10);
  @$pb.TagNumber(11)
  void clearActive() => $_clearField(11);

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

/// Somebody the hospital buys from (SRS-MAT-003).
class Supplier extends $pb.GeneratedMessage {
  factory Supplier({
    $core.String? supplierId,
    $core.String? code,
    $core.String? display,
    $core.bool? approved,
    $core.String? contactEmail,
    $core.String? contactPhone,
    $core.int? paymentTermsDays,
    $core.String? currency,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (approved != null) result.approved = approved;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (contactPhone != null) result.contactPhone = contactPhone;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (currency != null) result.currency = currency;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    return result;
  }

  Supplier._();

  factory Supplier.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Supplier.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Supplier',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'display')
    ..aOB(4, _omitFieldNames ? '' : 'approved')
    ..aOS(5, _omitFieldNames ? '' : 'contactEmail')
    ..aOS(6, _omitFieldNames ? '' : 'contactPhone')
    ..aI(7, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aOS(8, _omitFieldNames ? '' : 'currency')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(11, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Supplier clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Supplier copyWith(void Function(Supplier) updates) =>
      super.copyWith((message) => updates(message as Supplier)) as Supplier;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Supplier create() => Supplier._();
  @$core.override
  Supplier createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Supplier getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Supplier>(create);
  static Supplier? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get display => $_getSZ(2);
  @$pb.TagNumber(3)
  set display($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDisplay() => $_has(2);
  @$pb.TagNumber(3)
  void clearDisplay() => $_clearField(3);

  /// Gates who may be quoted and who may be ordered from.
  @$pb.TagNumber(4)
  $core.bool get approved => $_getBF(3);
  @$pb.TagNumber(4)
  set approved($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasApproved() => $_has(3);
  @$pb.TagNumber(4)
  void clearApproved() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contactEmail => $_getSZ(4);
  @$pb.TagNumber(5)
  set contactEmail($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContactEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearContactEmail() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get contactPhone => $_getSZ(5);
  @$pb.TagNumber(6)
  set contactPhone($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContactPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearContactPhone() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get paymentTermsDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set paymentTermsDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPaymentTermsDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearPaymentTermsDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get currency => $_getSZ(7);
  @$pb.TagNumber(8)
  set currency($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCurrency() => $_has(7);
  @$pb.TagNumber(8)
  void clearCurrency() => $_clearField(8);

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

/// One identified quantity of an item (SRS-MAT-005, SRS-MAT-013).
class Lot extends $pb.GeneratedMessage {
  factory Lot({
    $core.String? lotId,
    $core.String? itemId,
    $core.String? code,
    $0.Timestamp? expiry,
    $0.Timestamp? receivedAt,
    Ownership? ownership,
    $core.String? supplierId,
    $core.bool? blocked,
    $core.String? blockedReason,
    $0.Timestamp? blockedAt,
    $core.String? blockedBy,
    $fixnum.Int64? version,
    $core.bool? issuable,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (itemId != null) result.itemId = itemId;
    if (code != null) result.code = code;
    if (expiry != null) result.expiry = expiry;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (ownership != null) result.ownership = ownership;
    if (supplierId != null) result.supplierId = supplierId;
    if (blocked != null) result.blocked = blocked;
    if (blockedReason != null) result.blockedReason = blockedReason;
    if (blockedAt != null) result.blockedAt = blockedAt;
    if (blockedBy != null) result.blockedBy = blockedBy;
    if (version != null) result.version = version;
    if (issuable != null) result.issuable = issuable;
    return result;
  }

  Lot._();

  factory Lot.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Lot.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Lot',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'expiry',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<Ownership>(6, _omitFieldNames ? '' : 'ownership',
        enumValues: Ownership.values)
    ..aOS(7, _omitFieldNames ? '' : 'supplierId')
    ..aOB(8, _omitFieldNames ? '' : 'blocked')
    ..aOS(9, _omitFieldNames ? '' : 'blockedReason')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'blockedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'blockedBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..aOB(13, _omitFieldNames ? '' : 'issuable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Lot clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Lot copyWith(void Function(Lot) updates) =>
      super.copyWith((message) => updates(message as Lot)) as Lot;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Lot create() => Lot._();
  @$core.override
  Lot createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Lot getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Lot>(create);
  static Lot? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  /// The manufacturer's batch or the serial. Empty only for an item counted in
  /// bulk, where the lot carries ownership and the received date and no
  /// identity.
  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get expiry => $_getN(3);
  @$pb.TagNumber(4)
  set expiry($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiry() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiry() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureExpiry() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get receivedAt => $_getN(4);
  @$pb.TagNumber(5)
  set receivedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasReceivedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearReceivedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureReceivedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  Ownership get ownership => $_getN(5);
  @$pb.TagNumber(6)
  set ownership(Ownership value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOwnership() => $_has(5);
  @$pb.TagNumber(6)
  void clearOwnership() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get supplierId => $_getSZ(6);
  @$pb.TagNumber(7)
  set supplierId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSupplierId() => $_has(6);
  @$pb.TagNumber(7)
  void clearSupplierId() => $_clearField(7);

  /// Stops the lot being issued at all. Blocked stock still exists and is still
  /// counted; it is simply not available to anybody.
  @$pb.TagNumber(8)
  $core.bool get blocked => $_getBF(7);
  @$pb.TagNumber(8)
  set blocked($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBlocked() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlocked() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get blockedReason => $_getSZ(8);
  @$pb.TagNumber(9)
  set blockedReason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBlockedReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearBlockedReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get blockedAt => $_getN(9);
  @$pb.TagNumber(10)
  set blockedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBlockedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureBlockedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get blockedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set blockedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBlockedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearBlockedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);

  /// Derived: blocked and expired fail independently, and a client checking
  /// only one would offer stock that looks usable and is not.
  @$pb.TagNumber(13)
  $core.bool get issuable => $_getBF(12);
  @$pb.TagNumber(13)
  set issuable($core.bool value) => $_setBool(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIssuable() => $_has(12);
  @$pb.TagNumber(13)
  void clearIssuable() => $_clearField(13);
}

/// One immutable transfer of quantity between buckets (SRS-MAT-007).
class Movement extends $pb.GeneratedMessage {
  factory Movement({
    $core.String? movementId,
    $core.String? itemId,
    $core.String? lotId,
    Bucket? from,
    Bucket? to,
    $core.int? quantity,
    MovementKind? kind,
    $core.String? reference,
    $core.String? reason,
    $core.String? costCentre,
    $core.String? patientId,
    $core.String? encounterId,
    $0.Timestamp? occurredAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (movementId != null) result.movementId = movementId;
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (quantity != null) result.quantity = quantity;
    if (kind != null) result.kind = kind;
    if (reference != null) result.reference = reference;
    if (reason != null) result.reason = reason;
    if (costCentre != null) result.costCentre = costCentre;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Movement._();

  factory Movement.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Movement.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Movement',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'movementId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'lotId')
    ..aOM<Bucket>(4, _omitFieldNames ? '' : 'from', subBuilder: Bucket.create)
    ..aOM<Bucket>(5, _omitFieldNames ? '' : 'to', subBuilder: Bucket.create)
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aE<MovementKind>(7, _omitFieldNames ? '' : 'kind',
        enumValues: MovementKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'reference')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aOS(10, _omitFieldNames ? '' : 'costCentre')
    ..aOS(11, _omitFieldNames ? '' : 'patientId')
    ..aOS(12, _omitFieldNames ? '' : 'encounterId')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Movement clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Movement copyWith(void Function(Movement) updates) =>
      super.copyWith((message) => updates(message as Movement)) as Movement;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Movement create() => Movement._();
  @$core.override
  Movement createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Movement getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Movement>(create);
  static Movement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get movementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set movementId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMovementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovementId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get lotId => $_getSZ(2);
  @$pb.TagNumber(3)
  set lotId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLotId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLotId() => $_clearField(3);

  @$pb.TagNumber(4)
  Bucket get from => $_getN(3);
  @$pb.TagNumber(4)
  set from(Bucket value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  Bucket ensureFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  Bucket get to => $_getN(4);
  @$pb.TagNumber(5)
  set to(Bucket value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearTo() => $_clearField(5);
  @$pb.TagNumber(5)
  Bucket ensureTo() => $_ensure(4);

  /// Always positive. The direction is the buckets' job.
  @$pb.TagNumber(6)
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  @$pb.TagNumber(7)
  MovementKind get kind => $_getN(6);
  @$pb.TagNumber(7)
  set kind(MovementKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearKind() => $_clearField(7);

  /// The document this movement belongs to: the receipt, the issue, the
  /// transfer, the count.
  @$pb.TagNumber(8)
  $core.String get reference => $_getSZ(7);
  @$pb.TagNumber(8)
  set reference($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasReference() => $_has(7);
  @$pb.TagNumber(8)
  void clearReference() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get costCentre => $_getSZ(9);
  @$pb.TagNumber(10)
  set costCentre($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCostCentre() => $_has(9);
  @$pb.TagNumber(10)
  void clearCostCentre() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get patientId => $_getSZ(10);
  @$pb.TagNumber(11)
  set patientId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasPatientId() => $_has(10);
  @$pb.TagNumber(11)
  void clearPatientId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get encounterId => $_getSZ(11);
  @$pb.TagNumber(12)
  set encounterId($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEncounterId() => $_has(11);
  @$pb.TagNumber(12)
  void clearEncounterId() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get occurredAt => $_getN(12);
  @$pb.TagNumber(13)
  set occurredAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasOccurredAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearOccurredAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureOccurredAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get recordedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set recordedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasRecordedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearRecordedBy() => $_clearField(14);
}

/// What one lot holds in one bucket (SRS-MAT-007).
///
/// Derived by summing the ledger. There is no on-hand field anywhere in this
/// contract, because a second answer to "what do we hold" would eventually
/// disagree with the first.
class Balance extends $pb.GeneratedMessage {
  factory Balance({
    $core.String? itemId,
    $core.String? lotId,
    Bucket? bucket,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (bucket != null) result.bucket = bucket;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  Balance._();

  factory Balance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Balance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Balance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aOM<Bucket>(3, _omitFieldNames ? '' : 'bucket', subBuilder: Bucket.create)
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Balance copyWith(void Function(Balance) updates) =>
      super.copyWith((message) => updates(message as Balance)) as Balance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Balance create() => Balance._();
  @$core.override
  Balance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Balance getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Balance>(create);
  static Balance? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  @$pb.TagNumber(3)
  Bucket get bucket => $_getN(2);
  @$pb.TagNumber(3)
  set bucket(Bucket value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBucket() => $_has(2);
  @$pb.TagNumber(3)
  void clearBucket() => $_clearField(3);
  @$pb.TagNumber(3)
  Bucket ensureBucket() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);
}

/// One item's min-max policy at one location (SRS-MAT-012).
class StockLevel extends $pb.GeneratedMessage {
  factory StockLevel({
    $core.String? itemId,
    $core.String? locationId,
    $core.int? minimum,
    $core.int? maximum,
    $core.int? reorderQuantity,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    if (minimum != null) result.minimum = minimum;
    if (maximum != null) result.maximum = maximum;
    if (reorderQuantity != null) result.reorderQuantity = reorderQuantity;
    return result;
  }

  StockLevel._();

  factory StockLevel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StockLevel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StockLevel',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aI(3, _omitFieldNames ? '' : 'minimum')
    ..aI(4, _omitFieldNames ? '' : 'maximum')
    ..aI(5, _omitFieldNames ? '' : 'reorderQuantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockLevel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StockLevel copyWith(void Function(StockLevel) updates) =>
      super.copyWith((message) => updates(message as StockLevel)) as StockLevel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StockLevel create() => StockLevel._();
  @$core.override
  StockLevel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StockLevel getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StockLevel>(create);
  static StockLevel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  /// The level a reorder is suggested at. Zero means the item is not
  /// replenished automatically here, which is a decision rather than a gap.
  @$pb.TagNumber(3)
  $core.int get minimum => $_getIZ(2);
  @$pb.TagNumber(3)
  set minimum($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMinimum() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinimum() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maximum => $_getIZ(3);
  @$pb.TagNumber(4)
  set maximum($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaximum() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaximum() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get reorderQuantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set reorderQuantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReorderQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearReorderQuantity() => $_clearField(5);
}

/// One item wanted (SRS-MAT-001).
class RequisitionLine extends $pb.GeneratedMessage {
  factory RequisitionLine({
    $core.String? itemId,
    $core.String? itemCode,
    $core.int? quantity,
    $core.String? uom,
    Money? estimatedUnitPrice,
    $core.String? notes,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    if (uom != null) result.uom = uom;
    if (estimatedUnitPrice != null)
      result.estimatedUnitPrice = estimatedUnitPrice;
    if (notes != null) result.notes = notes;
    return result;
  }

  RequisitionLine._();

  factory RequisitionLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RequisitionLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RequisitionLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'itemCode')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOS(4, _omitFieldNames ? '' : 'uom')
    ..aOM<Money>(5, _omitFieldNames ? '' : 'estimatedUnitPrice',
        subBuilder: Money.create)
    ..aOS(6, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequisitionLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RequisitionLine copyWith(void Function(RequisitionLine) updates) =>
      super.copyWith((message) => updates(message as RequisitionLine))
          as RequisitionLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RequisitionLine create() => RequisitionLine._();
  @$core.override
  RequisitionLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RequisitionLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RequisitionLine>(create);
  static RequisitionLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uom => $_getSZ(3);
  @$pb.TagNumber(4)
  set uom($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUom() => $_has(3);
  @$pb.TagNumber(4)
  void clearUom() => $_clearField(4);

  /// What the approval route is costed on before any quote exists.
  @$pb.TagNumber(5)
  Money get estimatedUnitPrice => $_getN(4);
  @$pb.TagNumber(5)
  set estimatedUnitPrice(Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasEstimatedUnitPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearEstimatedUnitPrice() => $_clearField(5);
  @$pb.TagNumber(5)
  Money ensureEstimatedUnitPrice() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get notes => $_getSZ(5);
  @$pb.TagNumber(6)
  set notes($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotes() => $_clearField(6);
}

/// One immutable entry in an approval chain (SRS-MAT-002).
class ApprovalStep extends $pb.GeneratedMessage {
  factory ApprovalStep({
    $core.String? approvalStepId,
    $core.int? level,
    $core.String? role,
    ApprovalDecision? decision,
    $core.String? decider,
    $core.String? note,
    $0.Timestamp? decidedAt,
  }) {
    final result = create();
    if (approvalStepId != null) result.approvalStepId = approvalStepId;
    if (level != null) result.level = level;
    if (role != null) result.role = role;
    if (decision != null) result.decision = decision;
    if (decider != null) result.decider = decider;
    if (note != null) result.note = note;
    if (decidedAt != null) result.decidedAt = decidedAt;
    return result;
  }

  ApprovalStep._();

  factory ApprovalStep.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApprovalStep.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApprovalStep',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalStepId')
    ..aI(2, _omitFieldNames ? '' : 'level')
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aE<ApprovalDecision>(4, _omitFieldNames ? '' : 'decision',
        enumValues: ApprovalDecision.values)
    ..aOS(5, _omitFieldNames ? '' : 'decider')
    ..aOS(6, _omitFieldNames ? '' : 'note')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'decidedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalStep clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalStep copyWith(void Function(ApprovalStep) updates) =>
      super.copyWith((message) => updates(message as ApprovalStep))
          as ApprovalStep;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApprovalStep create() => ApprovalStep._();
  @$core.override
  ApprovalStep createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApprovalStep getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApprovalStep>(create);
  static ApprovalStep? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvalStepId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalStepId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalStepId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalStepId() => $_clearField(1);

  /// The position in the route, from one. Contiguous: a gap means a step was
  /// lost.
  @$pb.TagNumber(2)
  $core.int get level => $_getIZ(1);
  @$pb.TagNumber(2)
  set level($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLevel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLevel() => $_clearField(2);

  /// The role required and the person who decided. Both, because they are
  /// different claims.
  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  ApprovalDecision get decision => $_getN(3);
  @$pb.TagNumber(4)
  set decision(ApprovalDecision value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDecision() => $_has(3);
  @$pb.TagNumber(4)
  void clearDecision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get decider => $_getSZ(4);
  @$pb.TagNumber(5)
  set decider($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDecider() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecider() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get note => $_getSZ(5);
  @$pb.TagNumber(6)
  set note($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNote() => $_has(5);
  @$pb.TagNumber(6)
  void clearNote() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get decidedAt => $_getN(6);
  @$pb.TagNumber(7)
  set decidedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasDecidedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearDecidedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureDecidedAt() => $_ensure(6);
}

/// A request to buy (SRS-MAT-001).
class Requisition extends $pb.GeneratedMessage {
  factory Requisition({
    $core.String? requisitionId,
    $core.String? number,
    $core.String? facilityId,
    RequisitionSource? source,
    $0.Timestamp? needBy,
    $core.String? costCentre,
    $core.String? sourceReference,
    $core.Iterable<RequisitionLine>? lines,
    RequisitionState? state,
    $core.Iterable<ApprovalStep>? approvals,
    $core.String? justification,
    $0.Timestamp? raisedAt,
    $core.String? raisedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (source != null) result.source = source;
    if (needBy != null) result.needBy = needBy;
    if (costCentre != null) result.costCentre = costCentre;
    if (sourceReference != null) result.sourceReference = sourceReference;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (approvals != null) result.approvals.addAll(approvals);
    if (justification != null) result.justification = justification;
    if (raisedAt != null) result.raisedAt = raisedAt;
    if (raisedBy != null) result.raisedBy = raisedBy;
    if (version != null) result.version = version;
    return result;
  }

  Requisition._();

  factory Requisition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Requisition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Requisition',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requisitionId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aE<RequisitionSource>(4, _omitFieldNames ? '' : 'source',
        enumValues: RequisitionSource.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'needBy',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'costCentre')
    ..aOS(7, _omitFieldNames ? '' : 'sourceReference')
    ..pPM<RequisitionLine>(8, _omitFieldNames ? '' : 'lines',
        subBuilder: RequisitionLine.create)
    ..aE<RequisitionState>(9, _omitFieldNames ? '' : 'state',
        enumValues: RequisitionState.values)
    ..pPM<ApprovalStep>(10, _omitFieldNames ? '' : 'approvals',
        subBuilder: ApprovalStep.create)
    ..aOS(11, _omitFieldNames ? '' : 'justification')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'raisedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'raisedBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requisition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Requisition copyWith(void Function(Requisition) updates) =>
      super.copyWith((message) => updates(message as Requisition))
          as Requisition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Requisition create() => Requisition._();
  @$core.override
  Requisition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Requisition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Requisition>(create);
  static Requisition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requisitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requisitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisitionId() => $_clearField(1);

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

  @$pb.TagNumber(4)
  RequisitionSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source(RequisitionSource value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get needBy => $_getN(4);
  @$pb.TagNumber(5)
  set needBy($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasNeedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearNeedBy() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureNeedBy() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get costCentre => $_getSZ(5);
  @$pb.TagNumber(6)
  set costCentre($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostCentre() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostCentre() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get sourceReference => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceReference($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceReference() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceReference() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<RequisitionLine> get lines => $_getList(7);

  @$pb.TagNumber(9)
  RequisitionState get state => $_getN(8);
  @$pb.TagNumber(9)
  set state(RequisitionState value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasState() => $_has(8);
  @$pb.TagNumber(9)
  void clearState() => $_clearField(9);

  /// Appended, never rewritten.
  @$pb.TagNumber(10)
  $pb.PbList<ApprovalStep> get approvals => $_getList(9);

  @$pb.TagNumber(11)
  $core.String get justification => $_getSZ(10);
  @$pb.TagNumber(11)
  set justification($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasJustification() => $_has(10);
  @$pb.TagNumber(11)
  void clearJustification() => $_clearField(11);

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
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// A rule routing a requisition (SRS-MAT-002).
class ApprovalRule extends $pb.GeneratedMessage {
  factory ApprovalRule({
    $core.String? approvalRuleId,
    $fixnum.Int64? minimumValue,
    $core.String? currency,
    $core.String? category,
    $core.String? facilityId,
    $core.Iterable<$core.String>? roles,
  }) {
    final result = create();
    if (approvalRuleId != null) result.approvalRuleId = approvalRuleId;
    if (minimumValue != null) result.minimumValue = minimumValue;
    if (currency != null) result.currency = currency;
    if (category != null) result.category = category;
    if (facilityId != null) result.facilityId = facilityId;
    if (roles != null) result.roles.addAll(roles);
    return result;
  }

  ApprovalRule._();

  factory ApprovalRule.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApprovalRule.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApprovalRule',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalRuleId')
    ..aInt64(2, _omitFieldNames ? '' : 'minimumValue')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..pPS(6, _omitFieldNames ? '' : 'roles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalRule clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApprovalRule copyWith(void Function(ApprovalRule) updates) =>
      super.copyWith((message) => updates(message as ApprovalRule))
          as ApprovalRule;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApprovalRule create() => ApprovalRule._();
  @$core.override
  ApprovalRule createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApprovalRule getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApprovalRule>(create);
  static ApprovalRule? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvalRuleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalRuleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalRuleId() => $_clearField(1);

  /// The threshold this rule applies from, in minor units. Zero applies from
  /// nothing.
  @$pb.TagNumber(2)
  $fixnum.Int64 get minimumValue => $_getI64(1);
  @$pb.TagNumber(2)
  set minimumValue($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinimumValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinimumValue() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  /// Empty matches any.
  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  /// The approvals required, in order. A rule with none is refused: it would
  /// approve everything it matched.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get roles => $_getList(5);
}

/// One item priced in a quote (SRS-MAT-003).
class BidLine extends $pb.GeneratedMessage {
  factory BidLine({
    $core.String? itemId,
    Money? unitPrice,
    $core.int? quantity,
    $core.int? packSize,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (quantity != null) result.quantity = quantity;
    if (packSize != null) result.packSize = packSize;
    return result;
  }

  BidLine._();

  factory BidLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BidLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BidLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: Money.create)
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aI(4, _omitFieldNames ? '' : 'packSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BidLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BidLine copyWith(void Function(BidLine) updates) =>
      super.copyWith((message) => updates(message as BidLine)) as BidLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BidLine create() => BidLine._();
  @$core.override
  BidLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BidLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BidLine>(create);
  static BidLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get unitPrice => $_getN(1);
  @$pb.TagNumber(2)
  set unitPrice(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitPrice() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureUnitPrice() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  /// How many stock units one purchase unit holds. A quote per box of a
  /// hundred and a quote per piece are the same quote until somebody forgets.
  @$pb.TagNumber(4)
  $core.int get packSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set packSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPackSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPackSize() => $_clearField(4);
}

/// One supplier's response to a quotation round (SRS-MAT-003).
class Bid extends $pb.GeneratedMessage {
  factory Bid({
    $core.String? bidId,
    $core.String? rfqId,
    $core.String? supplierId,
    $core.Iterable<BidLine>? lines,
    $core.int? leadTimeDays,
    $core.int? warrantyMonths,
    $core.int? paymentTermsDays,
    $fixnum.Int64? freightMinor,
    $fixnum.Int64? taxMinor,
    $core.String? currency,
    $core.String? notes,
    $0.Timestamp? receivedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (bidId != null) result.bidId = bidId;
    if (rfqId != null) result.rfqId = rfqId;
    if (supplierId != null) result.supplierId = supplierId;
    if (lines != null) result.lines.addAll(lines);
    if (leadTimeDays != null) result.leadTimeDays = leadTimeDays;
    if (warrantyMonths != null) result.warrantyMonths = warrantyMonths;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (freightMinor != null) result.freightMinor = freightMinor;
    if (taxMinor != null) result.taxMinor = taxMinor;
    if (currency != null) result.currency = currency;
    if (notes != null) result.notes = notes;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Bid._();

  factory Bid.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bid.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bid',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bidId')
    ..aOS(2, _omitFieldNames ? '' : 'rfqId')
    ..aOS(3, _omitFieldNames ? '' : 'supplierId')
    ..pPM<BidLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: BidLine.create)
    ..aI(5, _omitFieldNames ? '' : 'leadTimeDays')
    ..aI(6, _omitFieldNames ? '' : 'warrantyMonths')
    ..aI(7, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aInt64(8, _omitFieldNames ? '' : 'freightMinor')
    ..aInt64(9, _omitFieldNames ? '' : 'taxMinor')
    ..aOS(10, _omitFieldNames ? '' : 'currency')
    ..aOS(11, _omitFieldNames ? '' : 'notes')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bid clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bid copyWith(void Function(Bid) updates) =>
      super.copyWith((message) => updates(message as Bid)) as Bid;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bid create() => Bid._();
  @$core.override
  Bid createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Bid getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bid>(create);
  static Bid? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bidId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bidId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBidId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBidId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rfqId => $_getSZ(1);
  @$pb.TagNumber(2)
  set rfqId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRfqId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRfqId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get supplierId => $_getSZ(2);
  @$pb.TagNumber(3)
  set supplierId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSupplierId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSupplierId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<BidLine> get lines => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get leadTimeDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set leadTimeDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLeadTimeDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearLeadTimeDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get warrantyMonths => $_getIZ(5);
  @$pb.TagNumber(6)
  set warrantyMonths($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasWarrantyMonths() => $_has(5);
  @$pb.TagNumber(6)
  void clearWarrantyMonths() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get paymentTermsDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set paymentTermsDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPaymentTermsDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearPaymentTermsDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get freightMinor => $_getI64(7);
  @$pb.TagNumber(8)
  set freightMinor($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFreightMinor() => $_has(7);
  @$pb.TagNumber(8)
  void clearFreightMinor() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get taxMinor => $_getI64(8);
  @$pb.TagNumber(9)
  set taxMinor($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTaxMinor() => $_has(8);
  @$pb.TagNumber(9)
  void clearTaxMinor() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get currency => $_getSZ(9);
  @$pb.TagNumber(10)
  set currency($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasCurrency() => $_has(9);
  @$pb.TagNumber(10)
  void clearCurrency() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get notes => $_getSZ(10);
  @$pb.TagNumber(11)
  set notes($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasNotes() => $_has(10);
  @$pb.TagNumber(11)
  void clearNotes() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get receivedAt => $_getN(11);
  @$pb.TagNumber(12)
  set receivedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasReceivedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearReceivedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureReceivedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get recordedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set recordedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRecordedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearRecordedBy() => $_clearField(13);
}

/// A request for quotation (SRS-MAT-003).
class Rfq extends $pb.GeneratedMessage {
  factory Rfq({
    $core.String? rfqId,
    $core.String? number,
    $core.String? requisitionId,
    $core.Iterable<$core.String>? supplierIds,
    $core.Iterable<RequisitionLine>? lines,
    $0.Timestamp? closesAt,
    $0.Timestamp? issuedAt,
    $core.String? issuedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (rfqId != null) result.rfqId = rfqId;
    if (number != null) result.number = number;
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (supplierIds != null) result.supplierIds.addAll(supplierIds);
    if (lines != null) result.lines.addAll(lines);
    if (closesAt != null) result.closesAt = closesAt;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (version != null) result.version = version;
    return result;
  }

  Rfq._();

  factory Rfq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Rfq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Rfq',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rfqId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'requisitionId')
    ..pPS(4, _omitFieldNames ? '' : 'supplierIds')
    ..pPM<RequisitionLine>(5, _omitFieldNames ? '' : 'lines',
        subBuilder: RequisitionLine.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'closesAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'issuedBy')
    ..aInt64(9, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rfq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Rfq copyWith(void Function(Rfq) updates) =>
      super.copyWith((message) => updates(message as Rfq)) as Rfq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Rfq create() => Rfq._();
  @$core.override
  Rfq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Rfq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Rfq>(create);
  static Rfq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rfqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rfqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRfqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfqId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requisitionId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requisitionId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequisitionId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequisitionId() => $_clearField(3);

  /// Who was asked. Recorded because "we went to three suppliers" is the claim
  /// a procurement audit checks.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get supplierIds => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<RequisitionLine> get lines => $_getList(4);

  @$pb.TagNumber(6)
  $0.Timestamp get closesAt => $_getN(5);
  @$pb.TagNumber(6)
  set closesAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasClosesAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearClosesAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureClosesAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get issuedAt => $_getN(6);
  @$pb.TagNumber(7)
  set issuedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasIssuedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearIssuedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureIssuedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get issuedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set issuedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIssuedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearIssuedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get version => $_getI64(8);
  @$pb.TagNumber(9)
  set version($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearVersion() => $_clearField(9);
}

/// One bid reduced to comparable terms (SRS-MAT-003).
class Comparison extends $pb.GeneratedMessage {
  factory Comparison({
    $core.String? bidId,
    $core.String? supplierId,
    $fixnum.Int64? landedMinor,
    $core.String? currency,
    $fixnum.Int64? unitMinor,
    $core.int? leadTimeDays,
    $core.int? paymentTermsDays,
    $core.int? warrantyMonths,
    $core.Iterable<$core.String>? incomparable,
  }) {
    final result = create();
    if (bidId != null) result.bidId = bidId;
    if (supplierId != null) result.supplierId = supplierId;
    if (landedMinor != null) result.landedMinor = landedMinor;
    if (currency != null) result.currency = currency;
    if (unitMinor != null) result.unitMinor = unitMinor;
    if (leadTimeDays != null) result.leadTimeDays = leadTimeDays;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (warrantyMonths != null) result.warrantyMonths = warrantyMonths;
    if (incomparable != null) result.incomparable.addAll(incomparable);
    return result;
  }

  Comparison._();

  factory Comparison.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Comparison.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Comparison',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'bidId')
    ..aOS(2, _omitFieldNames ? '' : 'supplierId')
    ..aInt64(3, _omitFieldNames ? '' : 'landedMinor')
    ..aOS(4, _omitFieldNames ? '' : 'currency')
    ..aInt64(5, _omitFieldNames ? '' : 'unitMinor')
    ..aI(6, _omitFieldNames ? '' : 'leadTimeDays')
    ..aI(7, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aI(8, _omitFieldNames ? '' : 'warrantyMonths')
    ..pPS(9, _omitFieldNames ? '' : 'incomparable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Comparison clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Comparison copyWith(void Function(Comparison) updates) =>
      super.copyWith((message) => updates(message as Comparison)) as Comparison;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Comparison create() => Comparison._();
  @$core.override
  Comparison createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Comparison getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Comparison>(create);
  static Comparison? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bidId => $_getSZ(0);
  @$pb.TagNumber(1)
  set bidId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBidId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBidId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get supplierId => $_getSZ(1);
  @$pb.TagNumber(2)
  set supplierId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSupplierId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupplierId() => $_clearField(2);

  /// The whole cost of the quoted quantities: price, freight and tax. The
  /// number two quotes are actually compared on.
  @$pb.TagNumber(3)
  $fixnum.Int64 get landedMinor => $_getI64(2);
  @$pb.TagNumber(3)
  set landedMinor($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLandedMinor() => $_has(2);
  @$pb.TagNumber(3)
  void clearLandedMinor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get currency => $_getSZ(3);
  @$pb.TagNumber(4)
  set currency($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCurrency() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrency() => $_clearField(4);

  /// Landed cost per stock unit, which is what makes a quote per box
  /// comparable with a quote per piece.
  @$pb.TagNumber(5)
  $fixnum.Int64 get unitMinor => $_getI64(4);
  @$pb.TagNumber(5)
  set unitMinor($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitMinor() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitMinor() => $_clearField(5);

  /// Carried rather than scored: how a hospital weighs three weeks against
  /// three per cent is its decision.
  @$pb.TagNumber(6)
  $core.int get leadTimeDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set leadTimeDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLeadTimeDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearLeadTimeDays() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get paymentTermsDays => $_getIZ(6);
  @$pb.TagNumber(7)
  set paymentTermsDays($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPaymentTermsDays() => $_has(6);
  @$pb.TagNumber(7)
  void clearPaymentTermsDays() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get warrantyMonths => $_getIZ(7);
  @$pb.TagNumber(8)
  set warrantyMonths($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasWarrantyMonths() => $_has(7);
  @$pb.TagNumber(8)
  void clearWarrantyMonths() => $_clearField(8);

  /// Why a bid could not be normalised, so a buyer sees the reason rather than
  /// a row that quietly sorted last.
  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get incomparable => $_getList(8);
}

/// One item ordered (SRS-MAT-004).
class PurchaseOrderLine extends $pb.GeneratedMessage {
  factory PurchaseOrderLine({
    $core.String? itemId,
    $core.String? itemCode,
    $core.int? quantity,
    $core.int? packSize,
    $core.String? uom,
    Money? unitPrice,
    $fixnum.Int64? taxMinor,
    $fixnum.Int64? discountMinor,
    $0.Timestamp? deliverBy,
    $core.String? notes,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (itemCode != null) result.itemCode = itemCode;
    if (quantity != null) result.quantity = quantity;
    if (packSize != null) result.packSize = packSize;
    if (uom != null) result.uom = uom;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (taxMinor != null) result.taxMinor = taxMinor;
    if (discountMinor != null) result.discountMinor = discountMinor;
    if (deliverBy != null) result.deliverBy = deliverBy;
    if (notes != null) result.notes = notes;
    return result;
  }

  PurchaseOrderLine._();

  factory PurchaseOrderLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurchaseOrderLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseOrderLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'itemCode')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aI(4, _omitFieldNames ? '' : 'packSize')
    ..aOS(5, _omitFieldNames ? '' : 'uom')
    ..aOM<Money>(6, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: Money.create)
    ..aInt64(7, _omitFieldNames ? '' : 'taxMinor')
    ..aInt64(8, _omitFieldNames ? '' : 'discountMinor')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'deliverBy',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseOrderLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseOrderLine copyWith(void Function(PurchaseOrderLine) updates) =>
      super.copyWith((message) => updates(message as PurchaseOrderLine))
          as PurchaseOrderLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurchaseOrderLine create() => PurchaseOrderLine._();
  @$core.override
  PurchaseOrderLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurchaseOrderLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurchaseOrderLine>(create);
  static PurchaseOrderLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCode() => $_clearField(2);

  /// In purchase units; pack_size converts to stock units. Both, because a
  /// receipt is counted in stock units and an invoice is priced in purchase
  /// units.
  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get packSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set packSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPackSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPackSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get uom => $_getSZ(4);
  @$pb.TagNumber(5)
  set uom($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUom() => $_has(4);
  @$pb.TagNumber(5)
  void clearUom() => $_clearField(5);

  @$pb.TagNumber(6)
  Money get unitPrice => $_getN(5);
  @$pb.TagNumber(6)
  set unitPrice(Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasUnitPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnitPrice() => $_clearField(6);
  @$pb.TagNumber(6)
  Money ensureUnitPrice() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get taxMinor => $_getI64(6);
  @$pb.TagNumber(7)
  set taxMinor($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTaxMinor() => $_has(6);
  @$pb.TagNumber(7)
  void clearTaxMinor() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get discountMinor => $_getI64(7);
  @$pb.TagNumber(8)
  set discountMinor($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDiscountMinor() => $_has(7);
  @$pb.TagNumber(8)
  void clearDiscountMinor() => $_clearField(8);

  /// Per line: a hospital orders sutures and a capital item on one order and
  /// expects them weeks apart.
  @$pb.TagNumber(9)
  $0.Timestamp get deliverBy => $_getN(8);
  @$pb.TagNumber(9)
  set deliverBy($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasDeliverBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeliverBy() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureDeliverBy() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => $_clearField(10);
}

/// An order placed with a supplier (SRS-MAT-004).
///
/// Versioned rather than edited: a supplier delivers against the version they
/// were sent.
class PurchaseOrder extends $pb.GeneratedMessage {
  factory PurchaseOrder({
    $core.String? purchaseOrderId,
    $core.String? number,
    $core.String? facilityId,
    $core.String? supplierId,
    $core.String? requisitionId,
    $core.String? bidId,
    $core.int? revision,
    $core.String? chainId,
    $core.String? supersedes,
    $core.String? amendmentReason,
    $core.Iterable<PurchaseOrderLine>? lines,
    PurchaseOrderState? state,
    $core.String? currency,
    $core.int? paymentTermsDays,
    $core.String? deliveryTerms,
    $core.int? toleranceOverPercent,
    $core.int? toleranceShortPercent,
    $0.Timestamp? issuedAt,
    $core.String? issuedBy,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $fixnum.Int64? version,
    Money? total,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (supplierId != null) result.supplierId = supplierId;
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (bidId != null) result.bidId = bidId;
    if (revision != null) result.revision = revision;
    if (chainId != null) result.chainId = chainId;
    if (supersedes != null) result.supersedes = supersedes;
    if (amendmentReason != null) result.amendmentReason = amendmentReason;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (currency != null) result.currency = currency;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (deliveryTerms != null) result.deliveryTerms = deliveryTerms;
    if (toleranceOverPercent != null)
      result.toleranceOverPercent = toleranceOverPercent;
    if (toleranceShortPercent != null)
      result.toleranceShortPercent = toleranceShortPercent;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (version != null) result.version = version;
    if (total != null) result.total = total;
    return result;
  }

  PurchaseOrder._();

  factory PurchaseOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PurchaseOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PurchaseOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'supplierId')
    ..aOS(5, _omitFieldNames ? '' : 'requisitionId')
    ..aOS(6, _omitFieldNames ? '' : 'bidId')
    ..aI(7, _omitFieldNames ? '' : 'revision')
    ..aOS(8, _omitFieldNames ? '' : 'chainId')
    ..aOS(9, _omitFieldNames ? '' : 'supersedes')
    ..aOS(10, _omitFieldNames ? '' : 'amendmentReason')
    ..pPM<PurchaseOrderLine>(11, _omitFieldNames ? '' : 'lines',
        subBuilder: PurchaseOrderLine.create)
    ..aE<PurchaseOrderState>(12, _omitFieldNames ? '' : 'state',
        enumValues: PurchaseOrderState.values)
    ..aOS(13, _omitFieldNames ? '' : 'currency')
    ..aI(14, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aOS(15, _omitFieldNames ? '' : 'deliveryTerms')
    ..aI(16, _omitFieldNames ? '' : 'toleranceOverPercent')
    ..aI(17, _omitFieldNames ? '' : 'toleranceShortPercent')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(19, _omitFieldNames ? '' : 'issuedBy')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(21, _omitFieldNames ? '' : 'createdBy')
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..aOM<Money>(23, _omitFieldNames ? '' : 'total', subBuilder: Money.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PurchaseOrder copyWith(void Function(PurchaseOrder) updates) =>
      super.copyWith((message) => updates(message as PurchaseOrder))
          as PurchaseOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PurchaseOrder create() => PurchaseOrder._();
  @$core.override
  PurchaseOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PurchaseOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PurchaseOrder>(create);
  static PurchaseOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);

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

  @$pb.TagNumber(4)
  $core.String get supplierId => $_getSZ(3);
  @$pb.TagNumber(4)
  set supplierId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSupplierId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupplierId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get requisitionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set requisitionId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasRequisitionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequisitionId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get bidId => $_getSZ(5);
  @$pb.TagNumber(6)
  set bidId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasBidId() => $_has(5);
  @$pb.TagNumber(6)
  void clearBidId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get revision => $_getIZ(6);
  @$pb.TagNumber(7)
  set revision($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRevision() => $_has(6);
  @$pb.TagNumber(7)
  void clearRevision() => $_clearField(7);

  /// The first revision's id, the same down the whole chain. What "every
  /// revision of this order" is read by, and what at-most-one-live is held on.
  @$pb.TagNumber(8)
  $core.String get chainId => $_getSZ(7);
  @$pb.TagNumber(8)
  set chainId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasChainId() => $_has(7);
  @$pb.TagNumber(8)
  void clearChainId() => $_clearField(8);

  /// The immediate predecessor, so the chain also reads backwards one step.
  @$pb.TagNumber(9)
  $core.String get supersedes => $_getSZ(8);
  @$pb.TagNumber(9)
  set supersedes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSupersedes() => $_has(8);
  @$pb.TagNumber(9)
  void clearSupersedes() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get amendmentReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set amendmentReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAmendmentReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearAmendmentReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<PurchaseOrderLine> get lines => $_getList(10);

  @$pb.TagNumber(12)
  PurchaseOrderState get state => $_getN(11);
  @$pb.TagNumber(12)
  set state(PurchaseOrderState value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasState() => $_has(11);
  @$pb.TagNumber(12)
  void clearState() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get currency => $_getSZ(12);
  @$pb.TagNumber(13)
  set currency($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCurrency() => $_has(12);
  @$pb.TagNumber(13)
  void clearCurrency() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get paymentTermsDays => $_getIZ(13);
  @$pb.TagNumber(14)
  set paymentTermsDays($core.int value) => $_setSignedInt32(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPaymentTermsDays() => $_has(13);
  @$pb.TagNumber(14)
  void clearPaymentTermsDays() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get deliveryTerms => $_getSZ(14);
  @$pb.TagNumber(15)
  set deliveryTerms($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDeliveryTerms() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeliveryTerms() => $_clearField(15);

  /// What a receipt may differ by (SRS-MAT-005). On the order rather than
  /// global, because a supplier who ships in cases differs from one who ships
  /// pieces.
  @$pb.TagNumber(16)
  $core.int get toleranceOverPercent => $_getIZ(15);
  @$pb.TagNumber(16)
  set toleranceOverPercent($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasToleranceOverPercent() => $_has(15);
  @$pb.TagNumber(16)
  void clearToleranceOverPercent() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.int get toleranceShortPercent => $_getIZ(16);
  @$pb.TagNumber(17)
  set toleranceShortPercent($core.int value) => $_setSignedInt32(16, value);
  @$pb.TagNumber(17)
  $core.bool hasToleranceShortPercent() => $_has(16);
  @$pb.TagNumber(17)
  void clearToleranceShortPercent() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get issuedAt => $_getN(17);
  @$pb.TagNumber(18)
  set issuedAt($0.Timestamp value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasIssuedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearIssuedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureIssuedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.String get issuedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set issuedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasIssuedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearIssuedBy() => $_clearField(19);

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

  /// Derived, so a client need not total the lines itself and get the tax and
  /// the discount the wrong way round.
  @$pb.TagNumber(23)
  Money get total => $_getN(22);
  @$pb.TagNumber(23)
  set total(Money value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasTotal() => $_has(22);
  @$pb.TagNumber(23)
  void clearTotal() => $_clearField(23);
  @$pb.TagNumber(23)
  Money ensureTotal() => $_ensure(22);
}

/// One item received (SRS-MAT-005).
class ReceiptLine extends $pb.GeneratedMessage {
  factory ReceiptLine({
    $core.String? itemId,
    $core.String? itemCode,
    $core.String? lotCode,
    $0.Timestamp? expiry,
    $core.int? quantityOrdered,
    $core.int? quantityReceived,
    Ownership? ownership,
    $core.String? supplierId,
    $core.String? notes,
    $core.int? discrepancy,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (itemCode != null) result.itemCode = itemCode;
    if (lotCode != null) result.lotCode = lotCode;
    if (expiry != null) result.expiry = expiry;
    if (quantityOrdered != null) result.quantityOrdered = quantityOrdered;
    if (quantityReceived != null) result.quantityReceived = quantityReceived;
    if (ownership != null) result.ownership = ownership;
    if (supplierId != null) result.supplierId = supplierId;
    if (notes != null) result.notes = notes;
    if (discrepancy != null) result.discrepancy = discrepancy;
    return result;
  }

  ReceiptLine._();

  factory ReceiptLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiptLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiptLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'itemCode')
    ..aOS(3, _omitFieldNames ? '' : 'lotCode')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'expiry',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'quantityOrdered')
    ..aI(6, _omitFieldNames ? '' : 'quantityReceived')
    ..aE<Ownership>(7, _omitFieldNames ? '' : 'ownership',
        enumValues: Ownership.values)
    ..aOS(8, _omitFieldNames ? '' : 'supplierId')
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..aI(10, _omitFieldNames ? '' : 'discrepancy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiptLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiptLine copyWith(void Function(ReceiptLine) updates) =>
      super.copyWith((message) => updates(message as ReceiptLine))
          as ReceiptLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiptLine create() => ReceiptLine._();
  @$core.override
  ReceiptLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiptLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiptLine>(create);
  static ReceiptLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCode() => $_clearField(2);

  /// What actually arrived, never assumed from the order: the order says what
  /// was asked for.
  @$pb.TagNumber(3)
  $core.String get lotCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set lotCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLotCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearLotCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get expiry => $_getN(3);
  @$pb.TagNumber(4)
  set expiry($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasExpiry() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpiry() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureExpiry() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get quantityOrdered => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantityOrdered($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantityOrdered() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantityOrdered() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quantityReceived => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantityReceived($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantityReceived() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantityReceived() => $_clearField(6);

  @$pb.TagNumber(7)
  Ownership get ownership => $_getN(6);
  @$pb.TagNumber(7)
  set ownership(Ownership value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasOwnership() => $_has(6);
  @$pb.TagNumber(7)
  void clearOwnership() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get supplierId => $_getSZ(7);
  @$pb.TagNumber(8)
  set supplierId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSupplierId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSupplierId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);

  /// Derived: received less ordered, so the difference reads on the row.
  @$pb.TagNumber(10)
  $core.int get discrepancy => $_getIZ(9);
  @$pb.TagNumber(10)
  set discrepancy($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDiscrepancy() => $_has(9);
  @$pb.TagNumber(10)
  void clearDiscrepancy() => $_clearField(10);
}

/// A goods receipt note (SRS-MAT-005).
class Receipt extends $pb.GeneratedMessage {
  factory Receipt({
    $core.String? receiptId,
    $core.String? number,
    $core.String? purchaseOrderId,
    $core.int? poRevision,
    $core.String? supplierId,
    $core.String? locationId,
    $core.String? deliveryNote,
    $core.String? invoiceRef,
    $core.Iterable<ReceiptLine>? lines,
    $0.Timestamp? receivedAt,
    $core.String? receivedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (receiptId != null) result.receiptId = receiptId;
    if (number != null) result.number = number;
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (poRevision != null) result.poRevision = poRevision;
    if (supplierId != null) result.supplierId = supplierId;
    if (locationId != null) result.locationId = locationId;
    if (deliveryNote != null) result.deliveryNote = deliveryNote;
    if (invoiceRef != null) result.invoiceRef = invoiceRef;
    if (lines != null) result.lines.addAll(lines);
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (receivedBy != null) result.receivedBy = receivedBy;
    if (version != null) result.version = version;
    return result;
  }

  Receipt._();

  factory Receipt.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Receipt.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Receipt',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'receiptId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'purchaseOrderId')
    ..aI(4, _omitFieldNames ? '' : 'poRevision')
    ..aOS(5, _omitFieldNames ? '' : 'supplierId')
    ..aOS(6, _omitFieldNames ? '' : 'locationId')
    ..aOS(7, _omitFieldNames ? '' : 'deliveryNote')
    ..aOS(8, _omitFieldNames ? '' : 'invoiceRef')
    ..pPM<ReceiptLine>(9, _omitFieldNames ? '' : 'lines',
        subBuilder: ReceiptLine.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'receivedBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Receipt clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Receipt copyWith(void Function(Receipt) updates) =>
      super.copyWith((message) => updates(message as Receipt)) as Receipt;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Receipt create() => Receipt._();
  @$core.override
  Receipt createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Receipt getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Receipt>(create);
  static Receipt? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get receiptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set receiptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get purchaseOrderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseOrderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurchaseOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseOrderId() => $_clearField(3);

  /// The revision received against. A receipt that did not say would be
  /// unresolvable the moment an order was amended.
  @$pb.TagNumber(4)
  $core.int get poRevision => $_getIZ(3);
  @$pb.TagNumber(4)
  set poRevision($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPoRevision() => $_has(3);
  @$pb.TagNumber(4)
  void clearPoRevision() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get supplierId => $_getSZ(4);
  @$pb.TagNumber(5)
  set supplierId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSupplierId() => $_has(4);
  @$pb.TagNumber(5)
  void clearSupplierId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get locationId => $_getSZ(5);
  @$pb.TagNumber(6)
  set locationId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationId() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationId() => $_clearField(6);

  /// The supplier's own references, which a three-way match joins on.
  @$pb.TagNumber(7)
  $core.String get deliveryNote => $_getSZ(6);
  @$pb.TagNumber(7)
  set deliveryNote($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDeliveryNote() => $_has(6);
  @$pb.TagNumber(7)
  void clearDeliveryNote() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get invoiceRef => $_getSZ(7);
  @$pb.TagNumber(8)
  set invoiceRef($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInvoiceRef() => $_has(7);
  @$pb.TagNumber(8)
  void clearInvoiceRef() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<ReceiptLine> get lines => $_getList(8);

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

/// One lot a pick recommendation suggests taking from (SRS-MAT-009).
class PickLine extends $pb.GeneratedMessage {
  factory PickLine({
    $core.String? lotId,
    $core.String? lotCode,
    Bucket? bucket,
    $core.int? quantity,
    $0.Timestamp? expiry,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (lotCode != null) result.lotCode = lotCode;
    if (bucket != null) result.bucket = bucket;
    if (quantity != null) result.quantity = quantity;
    if (expiry != null) result.expiry = expiry;
    return result;
  }

  PickLine._();

  factory PickLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PickLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PickLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'lotCode')
    ..aOM<Bucket>(3, _omitFieldNames ? '' : 'bucket', subBuilder: Bucket.create)
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'expiry',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PickLine copyWith(void Function(PickLine) updates) =>
      super.copyWith((message) => updates(message as PickLine)) as PickLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PickLine create() => PickLine._();
  @$core.override
  PickLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PickLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PickLine>(create);
  static PickLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotCode() => $_clearField(2);

  @$pb.TagNumber(3)
  Bucket get bucket => $_getN(2);
  @$pb.TagNumber(3)
  set bucket(Bucket value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBucket() => $_has(2);
  @$pb.TagNumber(3)
  void clearBucket() => $_clearField(3);
  @$pb.TagNumber(3)
  Bucket ensureBucket() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get expiry => $_getN(4);
  @$pb.TagNumber(5)
  set expiry($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasExpiry() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiry() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureExpiry() => $_ensure(4);
}

/// A pick recommendation with what it could not satisfy (SRS-MAT-009).
class Pick extends $pb.GeneratedMessage {
  factory Pick({
    $core.String? itemId,
    $core.Iterable<PickLine>? lines,
    $core.int? short,
    $core.Iterable<$core.String>? skipped,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lines != null) result.lines.addAll(lines);
    if (short != null) result.short = short;
    if (skipped != null) result.skipped.addAll(skipped);
    return result;
  }

  Pick._();

  factory Pick.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Pick.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Pick',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..pPM<PickLine>(2, _omitFieldNames ? '' : 'lines',
        subBuilder: PickLine.create)
    ..aI(3, _omitFieldNames ? '' : 'short')
    ..pPS(4, _omitFieldNames ? '' : 'skipped')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pick clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Pick copyWith(void Function(Pick) updates) =>
      super.copyWith((message) => updates(message as Pick)) as Pick;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Pick create() => Pick._();
  @$core.override
  Pick createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Pick getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Pick>(create);
  static Pick? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PickLine> get lines => $_getList(1);

  /// What the location could not supply. Returned rather than refused: a
  /// storekeeper facing a shortfall needs to know how much to chase.
  @$pb.TagNumber(3)
  $core.int get short => $_getIZ(2);
  @$pb.TagNumber(3)
  set short($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasShort() => $_has(2);
  @$pb.TagNumber(3)
  void clearShort() => $_clearField(3);

  /// Lots passed over and why, so a storekeeper looking at a full shelf and a
  /// short pick can see the reason.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get skipped => $_getList(3);
}

/// What consuming a supplier's stock owes them (SRS-MAT-016).
class LiabilityEvent extends $pb.GeneratedMessage {
  factory LiabilityEvent({
    $core.String? liabilityEventId,
    $core.String? lotId,
    $core.String? itemId,
    $core.String? supplierId,
    $core.int? quantity,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? movementId,
    $0.Timestamp? occurredAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (liabilityEventId != null) result.liabilityEventId = liabilityEventId;
    if (lotId != null) result.lotId = lotId;
    if (itemId != null) result.itemId = itemId;
    if (supplierId != null) result.supplierId = supplierId;
    if (quantity != null) result.quantity = quantity;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (movementId != null) result.movementId = movementId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  LiabilityEvent._();

  factory LiabilityEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiabilityEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiabilityEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'liabilityEventId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aOS(3, _omitFieldNames ? '' : 'itemId')
    ..aOS(4, _omitFieldNames ? '' : 'supplierId')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOS(6, _omitFieldNames ? '' : 'patientId')
    ..aOS(7, _omitFieldNames ? '' : 'encounterId')
    ..aOS(8, _omitFieldNames ? '' : 'movementId')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiabilityEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiabilityEvent copyWith(void Function(LiabilityEvent) updates) =>
      super.copyWith((message) => updates(message as LiabilityEvent))
          as LiabilityEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiabilityEvent create() => LiabilityEvent._();
  @$core.override
  LiabilityEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiabilityEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiabilityEvent>(create);
  static LiabilityEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get liabilityEventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set liabilityEventId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLiabilityEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLiabilityEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get supplierId => $_getSZ(3);
  @$pb.TagNumber(4)
  set supplierId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSupplierId() => $_has(3);
  @$pb.TagNumber(4)
  void clearSupplierId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  /// Why a consignment implant differs from a consignment box of gloves: the
  /// supplier invoices against the case.
  @$pb.TagNumber(6)
  $core.String get patientId => $_getSZ(5);
  @$pb.TagNumber(6)
  set patientId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPatientId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPatientId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get encounterId => $_getSZ(6);
  @$pb.TagNumber(7)
  set encounterId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEncounterId() => $_has(6);
  @$pb.TagNumber(7)
  void clearEncounterId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get movementId => $_getSZ(7);
  @$pb.TagNumber(8)
  set movementId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasMovementId() => $_has(7);
  @$pb.TagNumber(8)
  void clearMovementId() => $_clearField(8);

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

  @$pb.TagNumber(10)
  $core.String get recordedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set recordedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecordedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecordedBy() => $_clearField(10);
}

/// One item moved between stores (SRS-MAT-010).
class TransferLine extends $pb.GeneratedMessage {
  factory TransferLine({
    $core.String? itemId,
    $core.String? lotId,
    $core.int? quantity,
    $core.int? quantityReceived,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (quantity != null) result.quantity = quantity;
    if (quantityReceived != null) result.quantityReceived = quantityReceived;
    return result;
  }

  TransferLine._();

  factory TransferLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aI(4, _omitFieldNames ? '' : 'quantityReceived')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferLine copyWith(void Function(TransferLine) updates) =>
      super.copyWith((message) => updates(message as TransferLine))
          as TransferLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferLine create() => TransferLine._();
  @$core.override
  TransferLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferLine>(create);
  static TransferLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  /// What the destination actually counted in. Short arrival is recorded, not
  /// refused; the missing quantity stays in transit rather than vanishing.
  @$pb.TagNumber(4)
  $core.int get quantityReceived => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantityReceived($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantityReceived() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantityReceived() => $_clearField(4);
}

/// Stock moving between stores (SRS-MAT-010).
class Transfer extends $pb.GeneratedMessage {
  factory Transfer({
    $core.String? transferId,
    $core.String? number,
    $core.String? fromLocation,
    $core.String? toLocation,
    $core.Iterable<TransferLine>? lines,
    TransferState? state,
    $core.String? reason,
    $0.Timestamp? dispatchedAt,
    $core.String? dispatchedBy,
    $0.Timestamp? receivedAt,
    $core.String? receivedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (transferId != null) result.transferId = transferId;
    if (number != null) result.number = number;
    if (fromLocation != null) result.fromLocation = fromLocation;
    if (toLocation != null) result.toLocation = toLocation;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (reason != null) result.reason = reason;
    if (dispatchedAt != null) result.dispatchedAt = dispatchedAt;
    if (dispatchedBy != null) result.dispatchedBy = dispatchedBy;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (receivedBy != null) result.receivedBy = receivedBy;
    if (version != null) result.version = version;
    return result;
  }

  Transfer._();

  factory Transfer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Transfer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transfer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'fromLocation')
    ..aOS(4, _omitFieldNames ? '' : 'toLocation')
    ..pPM<TransferLine>(5, _omitFieldNames ? '' : 'lines',
        subBuilder: TransferLine.create)
    ..aE<TransferState>(6, _omitFieldNames ? '' : 'state',
        enumValues: TransferState.values)
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'dispatchedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'dispatchedBy')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'receivedBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transfer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transfer copyWith(void Function(Transfer) updates) =>
      super.copyWith((message) => updates(message as Transfer)) as Transfer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Transfer create() => Transfer._();
  @$core.override
  Transfer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Transfer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Transfer>(create);
  static Transfer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromLocation => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromLocation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromLocation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toLocation => $_getSZ(3);
  @$pb.TagNumber(4)
  set toLocation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearToLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<TransferLine> get lines => $_getList(4);

  @$pb.TagNumber(6)
  TransferState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(TransferState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get dispatchedAt => $_getN(7);
  @$pb.TagNumber(8)
  set dispatchedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasDispatchedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearDispatchedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureDispatchedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get dispatchedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set dispatchedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDispatchedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearDispatchedBy() => $_clearField(9);

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

/// One item counted (SRS-MAT-011).
class CountLine extends $pb.GeneratedMessage {
  factory CountLine({
    $core.String? itemId,
    $core.String? lotId,
    $core.int? expected,
    $core.int? counted,
    $core.String? reason,
    $core.int? variance,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (expected != null) result.expected = expected;
    if (counted != null) result.counted = counted;
    if (reason != null) result.reason = reason;
    if (variance != null) result.variance = variance;
    return result;
  }

  CountLine._();

  factory CountLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CountLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CountLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aI(3, _omitFieldNames ? '' : 'expected')
    ..aI(4, _omitFieldNames ? '' : 'counted')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..aI(6, _omitFieldNames ? '' : 'variance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CountLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CountLine copyWith(void Function(CountLine) updates) =>
      super.copyWith((message) => updates(message as CountLine)) as CountLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CountLine create() => CountLine._();
  @$core.override
  CountLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CountLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CountLine>(create);
  static CountLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  /// What the ledger said when the count was opened, frozen. Recomputing at
  /// approval would compare the shelf against a balance that has moved since.
  @$pb.TagNumber(3)
  $core.int get expected => $_getIZ(2);
  @$pb.TagNumber(3)
  set expected($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasExpected() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpected() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get counted => $_getIZ(3);
  @$pb.TagNumber(4)
  set counted($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCounted() => $_has(3);
  @$pb.TagNumber(4)
  void clearCounted() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);

  /// Derived: counted less expected.
  @$pb.TagNumber(6)
  $core.int get variance => $_getIZ(5);
  @$pb.TagNumber(6)
  set variance($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVariance() => $_has(5);
  @$pb.TagNumber(6)
  void clearVariance() => $_clearField(6);
}

/// A cycle or physical count (SRS-MAT-011).
class Count extends $pb.GeneratedMessage {
  factory Count({
    $core.String? countId,
    $core.String? number,
    $core.String? locationId,
    $core.bool? cycle,
    $core.Iterable<CountLine>? lines,
    CountState? state,
    $core.String? approvedBy,
    $0.Timestamp? approvedAt,
    $core.String? approvalNote,
    $0.Timestamp? openedAt,
    $core.String? openedBy,
    $0.Timestamp? countedAt,
    $core.String? countedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    if (number != null) result.number = number;
    if (locationId != null) result.locationId = locationId;
    if (cycle != null) result.cycle = cycle;
    if (lines != null) result.lines.addAll(lines);
    if (state != null) result.state = state;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (approvedAt != null) result.approvedAt = approvedAt;
    if (approvalNote != null) result.approvalNote = approvalNote;
    if (openedAt != null) result.openedAt = openedAt;
    if (openedBy != null) result.openedBy = openedBy;
    if (countedAt != null) result.countedAt = countedAt;
    if (countedBy != null) result.countedBy = countedBy;
    if (version != null) result.version = version;
    return result;
  }

  Count._();

  factory Count.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Count.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Count',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOB(4, _omitFieldNames ? '' : 'cycle')
    ..pPM<CountLine>(5, _omitFieldNames ? '' : 'lines',
        subBuilder: CountLine.create)
    ..aE<CountState>(6, _omitFieldNames ? '' : 'state',
        enumValues: CountState.values)
    ..aOS(7, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'approvedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'approvalNote')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'openedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'countedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'countedBy')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Count clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Count copyWith(void Function(Count) updates) =>
      super.copyWith((message) => updates(message as Count)) as Count;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Count create() => Count._();
  @$core.override
  Count createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Count getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Count>(create);
  static Count? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get cycle => $_getBF(3);
  @$pb.TagNumber(4)
  set cycle($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCycle() => $_has(3);
  @$pb.TagNumber(4)
  void clearCycle() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<CountLine> get lines => $_getList(4);

  @$pb.TagNumber(6)
  CountState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(CountState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  /// Required before any adjustment is posted, and never the counter.
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
  $core.String get approvalNote => $_getSZ(8);
  @$pb.TagNumber(9)
  set approvalNote($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasApprovalNote() => $_has(8);
  @$pb.TagNumber(9)
  void clearApprovalNote() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get openedAt => $_getN(9);
  @$pb.TagNumber(10)
  set openedAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasOpenedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearOpenedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureOpenedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get openedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set openedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOpenedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearOpenedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get countedAt => $_getN(11);
  @$pb.TagNumber(12)
  set countedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasCountedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearCountedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureCountedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get countedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set countedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasCountedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearCountedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

/// One thing a storekeeper should look at (SRS-MAT-012).
class Alert extends $pb.GeneratedMessage {
  factory Alert({
    AlertKind? kind,
    $core.String? itemId,
    $core.String? locationId,
    $core.String? lotId,
    $core.int? available,
    $core.int? minimum,
    $core.int? suggestedOrder,
    $0.Timestamp? expiry,
    $core.String? detail,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    if (lotId != null) result.lotId = lotId;
    if (available != null) result.available = available;
    if (minimum != null) result.minimum = minimum;
    if (suggestedOrder != null) result.suggestedOrder = suggestedOrder;
    if (expiry != null) result.expiry = expiry;
    if (detail != null) result.detail = detail;
    return result;
  }

  Alert._();

  factory Alert.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Alert.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Alert',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aE<AlertKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: AlertKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'lotId')
    ..aI(5, _omitFieldNames ? '' : 'available')
    ..aI(6, _omitFieldNames ? '' : 'minimum')
    ..aI(7, _omitFieldNames ? '' : 'suggestedOrder')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'expiry',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alert clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Alert copyWith(void Function(Alert) updates) =>
      super.copyWith((message) => updates(message as Alert)) as Alert;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Alert create() => Alert._();
  @$core.override
  Alert createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Alert getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Alert>(create);
  static Alert? _defaultInstance;

  @$pb.TagNumber(1)
  AlertKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(AlertKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lotId => $_getSZ(3);
  @$pb.TagNumber(4)
  set lotId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLotId() => $_has(3);
  @$pb.TagNumber(4)
  void clearLotId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get available => $_getIZ(4);
  @$pb.TagNumber(5)
  set available($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAvailable() => $_has(4);
  @$pb.TagNumber(5)
  void clearAvailable() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get minimum => $_getIZ(5);
  @$pb.TagNumber(6)
  set minimum($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMinimum() => $_has(5);
  @$pb.TagNumber(6)
  void clearMinimum() => $_clearField(6);

  /// What a top-up would order. Reviewable before it becomes a requisition: a
  /// system that raised the order itself would buy what its own arithmetic
  /// decided.
  @$pb.TagNumber(7)
  $core.int get suggestedOrder => $_getIZ(6);
  @$pb.TagNumber(7)
  set suggestedOrder($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSuggestedOrder() => $_has(6);
  @$pb.TagNumber(7)
  void clearSuggestedOrder() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get expiry => $_getN(7);
  @$pb.TagNumber(8)
  set expiry($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiry() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiry() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureExpiry() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get detail => $_getSZ(8);
  @$pb.TagNumber(9)
  set detail($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDetail() => $_has(8);
  @$pb.TagNumber(9)
  void clearDetail() => $_clearField(9);
}

/// One item a replenishment would order (SRS-MAT-012).
class SuggestedLine extends $pb.GeneratedMessage {
  factory SuggestedLine({
    $core.String? itemId,
    $core.String? itemCode,
    $core.int? available,
    $core.int? minimum,
    $core.int? quantity,
    $core.bool? stockout,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (itemCode != null) result.itemCode = itemCode;
    if (available != null) result.available = available;
    if (minimum != null) result.minimum = minimum;
    if (quantity != null) result.quantity = quantity;
    if (stockout != null) result.stockout = stockout;
    return result;
  }

  SuggestedLine._();

  factory SuggestedLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestedLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestedLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'itemCode')
    ..aI(3, _omitFieldNames ? '' : 'available')
    ..aI(4, _omitFieldNames ? '' : 'minimum')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOB(6, _omitFieldNames ? '' : 'stockout')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestedLine copyWith(void Function(SuggestedLine) updates) =>
      super.copyWith((message) => updates(message as SuggestedLine))
          as SuggestedLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestedLine create() => SuggestedLine._();
  @$core.override
  SuggestedLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuggestedLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestedLine>(create);
  static SuggestedLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get available => $_getIZ(2);
  @$pb.TagNumber(3)
  set available($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAvailable() => $_has(2);
  @$pb.TagNumber(3)
  void clearAvailable() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get minimum => $_getIZ(3);
  @$pb.TagNumber(4)
  set minimum($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinimum() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinimum() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get stockout => $_getBF(5);
  @$pb.TagNumber(6)
  set stockout($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasStockout() => $_has(5);
  @$pb.TagNumber(6)
  void clearStockout() => $_clearField(6);
}

/// One line of a supplier's invoice (SRS-MAT-014).
class InvoiceLine extends $pb.GeneratedMessage {
  factory InvoiceLine({
    $core.String? itemId,
    $core.int? quantity,
    Money? unitPrice,
    $fixnum.Int64? taxMinor,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (quantity != null) result.quantity = quantity;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (taxMinor != null) result.taxMinor = taxMinor;
    return result;
  }

  InvoiceLine._();

  factory InvoiceLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InvoiceLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InvoiceLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: Money.create)
    ..aInt64(4, _omitFieldNames ? '' : 'taxMinor')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InvoiceLine copyWith(void Function(InvoiceLine) updates) =>
      super.copyWith((message) => updates(message as InvoiceLine))
          as InvoiceLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InvoiceLine create() => InvoiceLine._();
  @$core.override
  InvoiceLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InvoiceLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InvoiceLine>(create);
  static InvoiceLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  /// In stock units, so the three documents are compared in one unit.
  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get unitPrice => $_getN(2);
  @$pb.TagNumber(3)
  set unitPrice(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitPrice() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureUnitPrice() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get taxMinor => $_getI64(3);
  @$pb.TagNumber(4)
  set taxMinor($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTaxMinor() => $_has(3);
  @$pb.TagNumber(4)
  void clearTaxMinor() => $_clearField(4);
}

/// A supplier's bill (SRS-MAT-014).
class Invoice extends $pb.GeneratedMessage {
  factory Invoice({
    $core.String? invoiceId,
    $core.String? number,
    $core.String? supplierId,
    $core.String? purchaseOrderId,
    $core.Iterable<InvoiceLine>? lines,
    $core.String? currency,
    $0.Timestamp? receivedAt,
    $core.String? recordedBy,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (number != null) result.number = number;
    if (supplierId != null) result.supplierId = supplierId;
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (lines != null) result.lines.addAll(lines);
    if (currency != null) result.currency = currency;
    if (receivedAt != null) result.receivedAt = receivedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    return result;
  }

  Invoice._();

  factory Invoice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Invoice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Invoice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'supplierId')
    ..aOS(4, _omitFieldNames ? '' : 'purchaseOrderId')
    ..pPM<InvoiceLine>(5, _omitFieldNames ? '' : 'lines',
        subBuilder: InvoiceLine.create)
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'receivedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'recordedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invoice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Invoice copyWith(void Function(Invoice) updates) =>
      super.copyWith((message) => updates(message as Invoice)) as Invoice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Invoice create() => Invoice._();
  @$core.override
  Invoice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Invoice getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Invoice>(create);
  static Invoice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoiceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoiceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get supplierId => $_getSZ(2);
  @$pb.TagNumber(3)
  set supplierId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSupplierId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSupplierId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get purchaseOrderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set purchaseOrderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPurchaseOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPurchaseOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<InvoiceLine> get lines => $_getList(4);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get receivedAt => $_getN(6);
  @$pb.TagNumber(7)
  set receivedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasReceivedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearReceivedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureReceivedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get recordedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set recordedBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRecordedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecordedBy() => $_clearField(8);
}

/// One item's verdict across the three documents (SRS-MAT-014).
class MatchLine extends $pb.GeneratedMessage {
  factory MatchLine({
    $core.String? itemId,
    MatchStatus? status,
    $core.int? ordered,
    $core.int? received,
    $core.int? invoiced,
    $fixnum.Int64? orderedUnitMinor,
    $fixnum.Int64? invoicedUnitMinor,
    $core.String? detail,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (status != null) result.status = status;
    if (ordered != null) result.ordered = ordered;
    if (received != null) result.received = received;
    if (invoiced != null) result.invoiced = invoiced;
    if (orderedUnitMinor != null) result.orderedUnitMinor = orderedUnitMinor;
    if (invoicedUnitMinor != null) result.invoicedUnitMinor = invoicedUnitMinor;
    if (detail != null) result.detail = detail;
    return result;
  }

  MatchLine._();

  factory MatchLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aE<MatchStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: MatchStatus.values)
    ..aI(3, _omitFieldNames ? '' : 'ordered')
    ..aI(4, _omitFieldNames ? '' : 'received')
    ..aI(5, _omitFieldNames ? '' : 'invoiced')
    ..aInt64(6, _omitFieldNames ? '' : 'orderedUnitMinor')
    ..aInt64(7, _omitFieldNames ? '' : 'invoicedUnitMinor')
    ..aOS(8, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchLine copyWith(void Function(MatchLine) updates) =>
      super.copyWith((message) => updates(message as MatchLine)) as MatchLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchLine create() => MatchLine._();
  @$core.override
  MatchLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchLine getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MatchLine>(create);
  static MatchLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  MatchStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(MatchStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get ordered => $_getIZ(2);
  @$pb.TagNumber(3)
  set ordered($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrdered() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrdered() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get received => $_getIZ(3);
  @$pb.TagNumber(4)
  set received($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReceived() => $_has(3);
  @$pb.TagNumber(4)
  void clearReceived() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get invoiced => $_getIZ(4);
  @$pb.TagNumber(5)
  set invoiced($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInvoiced() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvoiced() => $_clearField(5);

  /// Per stock unit, which is the conversion an invoice check gets wrong by
  /// eye.
  @$pb.TagNumber(6)
  $fixnum.Int64 get orderedUnitMinor => $_getI64(5);
  @$pb.TagNumber(6)
  set orderedUnitMinor($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOrderedUnitMinor() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrderedUnitMinor() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get invoicedUnitMinor => $_getI64(6);
  @$pb.TagNumber(7)
  set invoicedUnitMinor($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInvoicedUnitMinor() => $_has(6);
  @$pb.TagNumber(7)
  void clearInvoicedUnitMinor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get detail => $_getSZ(7);
  @$pb.TagNumber(8)
  set detail($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDetail() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetail() => $_clearField(8);
}

/// The whole comparison (SRS-MAT-014).
class MatchResult extends $pb.GeneratedMessage {
  factory MatchResult({
    $core.String? purchaseOrderId,
    $core.String? invoiceId,
    $core.Iterable<MatchLine>? lines,
    $core.bool? matched,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (lines != null) result.lines.addAll(lines);
    if (matched != null) result.matched = matched;
    return result;
  }

  MatchResult._();

  factory MatchResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'invoiceId')
    ..pPM<MatchLine>(3, _omitFieldNames ? '' : 'lines',
        subBuilder: MatchLine.create)
    ..aOB(4, _omitFieldNames ? '' : 'matched')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchResult copyWith(void Function(MatchResult) updates) =>
      super.copyWith((message) => updates(message as MatchResult))
          as MatchResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchResult create() => MatchResult._();
  @$core.override
  MatchResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchResult>(create);
  static MatchResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get invoiceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set invoiceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInvoiceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInvoiceId() => $_clearField(2);

  /// Every line of all three documents, including the ones present in only
  /// one.
  @$pb.TagNumber(3)
  $pb.PbList<MatchLine> get lines => $_getList(2);

  /// True only when every line matched: one wrong line stops the payment.
  @$pb.TagNumber(4)
  $core.bool get matched => $_getBF(3);
  @$pb.TagNumber(4)
  set matched($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMatched() => $_has(3);
  @$pb.TagNumber(4)
  void clearMatched() => $_clearField(4);
}

/// Where a blocked lot has got to and who it reached (SRS-MAT-013).
class RecallList extends $pb.GeneratedMessage {
  factory RecallList({
    $core.String? lotId,
    $core.String? lotCode,
    $core.String? itemId,
    $core.String? reason,
    $core.Iterable<Balance>? holdings,
    $core.Iterable<Movement>? consumptions,
    $core.Iterable<$core.String>? patients,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (lotCode != null) result.lotCode = lotCode;
    if (itemId != null) result.itemId = itemId;
    if (reason != null) result.reason = reason;
    if (holdings != null) result.holdings.addAll(holdings);
    if (consumptions != null) result.consumptions.addAll(consumptions);
    if (patients != null) result.patients.addAll(patients);
    return result;
  }

  RecallList._();

  factory RecallList.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecallList.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecallList',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'lotCode')
    ..aOS(3, _omitFieldNames ? '' : 'itemId')
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..pPM<Balance>(5, _omitFieldNames ? '' : 'holdings',
        subBuilder: Balance.create)
    ..pPM<Movement>(6, _omitFieldNames ? '' : 'consumptions',
        subBuilder: Movement.create)
    ..pPS(7, _omitFieldNames ? '' : 'patients')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallList clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecallList copyWith(void Function(RecallList) updates) =>
      super.copyWith((message) => updates(message as RecallList)) as RecallList;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecallList create() => RecallList._();
  @$core.override
  RecallList createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecallList getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecallList>(create);
  static RecallList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get itemId => $_getSZ(2);
  @$pb.TagNumber(3)
  set itemId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasItemId() => $_has(2);
  @$pb.TagNumber(3)
  void clearItemId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  /// Where the remaining stock is, so somebody can go and get it.
  @$pb.TagNumber(5)
  $pb.PbList<Balance> get holdings => $_getList(4);

  /// The movements that used it, carrying the patient where there was one.
  @$pb.TagNumber(6)
  $pb.PbList<Movement> get consumptions => $_getList(5);

  /// The people it reached, deduplicated: one case using four of a lot is one
  /// patient to contact.
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get patients => $_getList(6);
}

/// The inventory KPIs (SRS-MAT-015).
///
/// Derived from the ledger at the moment they are asked for. A stored KPI is by
/// construction not reproducible from the data it must come from.
class Metrics extends $pb.GeneratedMessage {
  factory Metrics({
    $core.String? itemId,
    $core.String? locationId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? consumedUnits,
    $core.int? openingOnHand,
    $core.int? closingOnHand,
    $core.int? averageOnHand,
    $core.double? turnsPerYear,
    $core.double? daysOnHand,
    $core.int? expiryExposureUnits,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (consumedUnits != null) result.consumedUnits = consumedUnits;
    if (openingOnHand != null) result.openingOnHand = openingOnHand;
    if (closingOnHand != null) result.closingOnHand = closingOnHand;
    if (averageOnHand != null) result.averageOnHand = averageOnHand;
    if (turnsPerYear != null) result.turnsPerYear = turnsPerYear;
    if (daysOnHand != null) result.daysOnHand = daysOnHand;
    if (expiryExposureUnits != null)
      result.expiryExposureUnits = expiryExposureUnits;
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
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'consumedUnits')
    ..aI(6, _omitFieldNames ? '' : 'openingOnHand')
    ..aI(7, _omitFieldNames ? '' : 'closingOnHand')
    ..aI(8, _omitFieldNames ? '' : 'averageOnHand')
    ..aD(9, _omitFieldNames ? '' : 'turnsPerYear')
    ..aD(10, _omitFieldNames ? '' : 'daysOnHand')
    ..aI(11, _omitFieldNames ? '' : 'expiryExposureUnits')
    ..pPS(12, _omitFieldNames ? '' : 'incomplete')
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
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get periodStart => $_getN(2);
  @$pb.TagNumber(3)
  set periodStart($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get periodEnd => $_getN(3);
  @$pb.TagNumber(4)
  set periodEnd($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensurePeriodEnd() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get consumedUnits => $_getIZ(4);
  @$pb.TagNumber(5)
  set consumedUnits($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasConsumedUnits() => $_has(4);
  @$pb.TagNumber(5)
  void clearConsumedUnits() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get openingOnHand => $_getIZ(5);
  @$pb.TagNumber(6)
  set openingOnHand($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasOpeningOnHand() => $_has(5);
  @$pb.TagNumber(6)
  void clearOpeningOnHand() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get closingOnHand => $_getIZ(6);
  @$pb.TagNumber(7)
  set closingOnHand($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasClosingOnHand() => $_has(6);
  @$pb.TagNumber(7)
  void clearClosingOnHand() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get averageOnHand => $_getIZ(7);
  @$pb.TagNumber(8)
  set averageOnHand($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAverageOnHand() => $_has(7);
  @$pb.TagNumber(8)
  void clearAverageOnHand() => $_clearField(8);

  /// Consumption annualised over average on-hand.
  @$pb.TagNumber(9)
  $core.double get turnsPerYear => $_getN(8);
  @$pb.TagNumber(9)
  set turnsPerYear($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTurnsPerYear() => $_has(8);
  @$pb.TagNumber(9)
  void clearTurnsPerYear() => $_clearField(9);

  /// Closing stock divided by the daily consumption rate.
  @$pb.TagNumber(10)
  $core.double get daysOnHand => $_getN(9);
  @$pb.TagNumber(10)
  set daysOnHand($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasDaysOnHand() => $_has(9);
  @$pb.TagNumber(10)
  void clearDaysOnHand() => $_clearField(10);

  /// Stock on hand that expires within the horizon: what will be thrown away
  /// unless it is used.
  @$pb.TagNumber(11)
  $core.int get expiryExposureUnits => $_getIZ(10);
  @$pb.TagNumber(11)
  set expiryExposureUnits($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasExpiryExposureUnits() => $_has(10);
  @$pb.TagNumber(11)
  void clearExpiryExposureUnits() => $_clearField(11);

  /// What a figure could not be built from, so a reader can tell a real zero
  /// from a gap.
  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get incomplete => $_getList(11);
}

/// How much of what was ordered actually arrived (SRS-MAT-015).
class SupplierFillRate extends $pb.GeneratedMessage {
  factory SupplierFillRate({
    $core.String? supplierId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? orderedUnits,
    $core.int? receivedUnits,
    $core.double? fillRate,
    $core.int? onTimeLines,
    $core.int? lateLines,
    $core.Iterable<$core.String>? incomplete,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (orderedUnits != null) result.orderedUnits = orderedUnits;
    if (receivedUnits != null) result.receivedUnits = receivedUnits;
    if (fillRate != null) result.fillRate = fillRate;
    if (onTimeLines != null) result.onTimeLines = onTimeLines;
    if (lateLines != null) result.lateLines = lateLines;
    if (incomplete != null) result.incomplete.addAll(incomplete);
    return result;
  }

  SupplierFillRate._();

  factory SupplierFillRate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SupplierFillRate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SupplierFillRate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'orderedUnits')
    ..aI(5, _omitFieldNames ? '' : 'receivedUnits')
    ..aD(6, _omitFieldNames ? '' : 'fillRate')
    ..aI(7, _omitFieldNames ? '' : 'onTimeLines')
    ..aI(8, _omitFieldNames ? '' : 'lateLines')
    ..pPS(9, _omitFieldNames ? '' : 'incomplete')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SupplierFillRate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SupplierFillRate copyWith(void Function(SupplierFillRate) updates) =>
      super.copyWith((message) => updates(message as SupplierFillRate))
          as SupplierFillRate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SupplierFillRate create() => SupplierFillRate._();
  @$core.override
  SupplierFillRate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SupplierFillRate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SupplierFillRate>(create);
  static SupplierFillRate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodStart => $_getN(1);
  @$pb.TagNumber(2)
  set periodStart($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodStart() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodEnd => $_getN(2);
  @$pb.TagNumber(3)
  set periodEnd($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get orderedUnits => $_getIZ(3);
  @$pb.TagNumber(4)
  set orderedUnits($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderedUnits() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderedUnits() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get receivedUnits => $_getIZ(4);
  @$pb.TagNumber(5)
  set receivedUnits($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReceivedUnits() => $_has(4);
  @$pb.TagNumber(5)
  void clearReceivedUnits() => $_clearField(5);

  /// Capped at one per line: an over-delivery does not make up for a short one.
  @$pb.TagNumber(6)
  $core.double get fillRate => $_getN(5);
  @$pb.TagNumber(6)
  set fillRate($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasFillRate() => $_has(5);
  @$pb.TagNumber(6)
  void clearFillRate() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get onTimeLines => $_getIZ(6);
  @$pb.TagNumber(7)
  set onTimeLines($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasOnTimeLines() => $_has(6);
  @$pb.TagNumber(7)
  void clearOnTimeLines() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get lateLines => $_getIZ(7);
  @$pb.TagNumber(8)
  set lateLines($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLateLines() => $_has(7);
  @$pb.TagNumber(8)
  void clearLateLines() => $_clearField(8);

  @$pb.TagNumber(9)
  $pb.PbList<$core.String> get incomplete => $_getList(8);
}

class AddItemRequest extends $pb.GeneratedMessage {
  factory AddItemRequest({
    $core.String? code,
    $core.String? display,
    $core.String? category,
    $core.String? uom,
    Tracking? tracking,
    PickPolicy? policy,
    $core.bool? perishable,
    $core.bool? inspectOnReceipt,
    $core.bool? consignable,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (category != null) result.category = category;
    if (uom != null) result.uom = uom;
    if (tracking != null) result.tracking = tracking;
    if (policy != null) result.policy = policy;
    if (perishable != null) result.perishable = perishable;
    if (inspectOnReceipt != null) result.inspectOnReceipt = inspectOnReceipt;
    if (consignable != null) result.consignable = consignable;
    return result;
  }

  AddItemRequest._();

  factory AddItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aOS(4, _omitFieldNames ? '' : 'uom')
    ..aE<Tracking>(5, _omitFieldNames ? '' : 'tracking',
        enumValues: Tracking.values)
    ..aE<PickPolicy>(6, _omitFieldNames ? '' : 'policy',
        enumValues: PickPolicy.values)
    ..aOB(7, _omitFieldNames ? '' : 'perishable')
    ..aOB(8, _omitFieldNames ? '' : 'inspectOnReceipt')
    ..aOB(9, _omitFieldNames ? '' : 'consignable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemRequest copyWith(void Function(AddItemRequest) updates) =>
      super.copyWith((message) => updates(message as AddItemRequest))
          as AddItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemRequest create() => AddItemRequest._();
  @$core.override
  AddItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemRequest>(create);
  static AddItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get uom => $_getSZ(3);
  @$pb.TagNumber(4)
  set uom($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUom() => $_has(3);
  @$pb.TagNumber(4)
  void clearUom() => $_clearField(4);

  @$pb.TagNumber(5)
  Tracking get tracking => $_getN(4);
  @$pb.TagNumber(5)
  set tracking(Tracking value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasTracking() => $_has(4);
  @$pb.TagNumber(5)
  void clearTracking() => $_clearField(5);

  @$pb.TagNumber(6)
  PickPolicy get policy => $_getN(5);
  @$pb.TagNumber(6)
  set policy(PickPolicy value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPolicy() => $_has(5);
  @$pb.TagNumber(6)
  void clearPolicy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get perishable => $_getBF(6);
  @$pb.TagNumber(7)
  set perishable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPerishable() => $_has(6);
  @$pb.TagNumber(7)
  void clearPerishable() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get inspectOnReceipt => $_getBF(7);
  @$pb.TagNumber(8)
  set inspectOnReceipt($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasInspectOnReceipt() => $_has(7);
  @$pb.TagNumber(8)
  void clearInspectOnReceipt() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get consignable => $_getBF(8);
  @$pb.TagNumber(9)
  set consignable($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasConsignable() => $_has(8);
  @$pb.TagNumber(9)
  void clearConsignable() => $_clearField(9);
}

class AddItemResponse extends $pb.GeneratedMessage {
  factory AddItemResponse({
    Item? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  AddItemResponse._();

  factory AddItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Item>(1, _omitFieldNames ? '' : 'item', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddItemResponse copyWith(void Function(AddItemResponse) updates) =>
      super.copyWith((message) => updates(message as AddItemResponse))
          as AddItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddItemResponse create() => AddItemResponse._();
  @$core.override
  AddItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddItemResponse>(create);
  static AddItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(Item value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  Item ensureItem() => $_ensure(0);
}

class ReconfigureItemRequest extends $pb.GeneratedMessage {
  factory ReconfigureItemRequest({
    $core.String? itemId,
    $core.String? display,
    $core.String? category,
    PickPolicy? policy,
    $core.bool? inspectOnReceipt,
    $core.bool? consignable,
    $core.bool? active,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (display != null) result.display = display;
    if (category != null) result.category = category;
    if (policy != null) result.policy = policy;
    if (inspectOnReceipt != null) result.inspectOnReceipt = inspectOnReceipt;
    if (consignable != null) result.consignable = consignable;
    if (active != null) result.active = active;
    return result;
  }

  ReconfigureItemRequest._();

  factory ReconfigureItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconfigureItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconfigureItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aE<PickPolicy>(4, _omitFieldNames ? '' : 'policy',
        enumValues: PickPolicy.values)
    ..aOB(5, _omitFieldNames ? '' : 'inspectOnReceipt')
    ..aOB(6, _omitFieldNames ? '' : 'consignable')
    ..aOB(7, _omitFieldNames ? '' : 'active')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconfigureItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconfigureItemRequest copyWith(
          void Function(ReconfigureItemRequest) updates) =>
      super.copyWith((message) => updates(message as ReconfigureItemRequest))
          as ReconfigureItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconfigureItemRequest create() => ReconfigureItemRequest._();
  @$core.override
  ReconfigureItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconfigureItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconfigureItemRequest>(create);
  static ReconfigureItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  PickPolicy get policy => $_getN(3);
  @$pb.TagNumber(4)
  set policy(PickPolicy value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPolicy() => $_has(3);
  @$pb.TagNumber(4)
  void clearPolicy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get inspectOnReceipt => $_getBF(4);
  @$pb.TagNumber(5)
  set inspectOnReceipt($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInspectOnReceipt() => $_has(4);
  @$pb.TagNumber(5)
  void clearInspectOnReceipt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get consignable => $_getBF(5);
  @$pb.TagNumber(6)
  set consignable($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasConsignable() => $_has(5);
  @$pb.TagNumber(6)
  void clearConsignable() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get active => $_getBF(6);
  @$pb.TagNumber(7)
  set active($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearActive() => $_clearField(7);
}

class ReconfigureItemResponse extends $pb.GeneratedMessage {
  factory ReconfigureItemResponse({
    Item? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  ReconfigureItemResponse._();

  factory ReconfigureItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconfigureItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconfigureItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Item>(1, _omitFieldNames ? '' : 'item', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconfigureItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconfigureItemResponse copyWith(
          void Function(ReconfigureItemResponse) updates) =>
      super.copyWith((message) => updates(message as ReconfigureItemResponse))
          as ReconfigureItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconfigureItemResponse create() => ReconfigureItemResponse._();
  @$core.override
  ReconfigureItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconfigureItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconfigureItemResponse>(create);
  static ReconfigureItemResponse? _defaultInstance;

  /// Tracking and unit of measure are deliberately absent: both are the basis
  /// of every movement already in the ledger, and changing either would
  /// silently restate history.
  @$pb.TagNumber(1)
  Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(Item value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  Item ensureItem() => $_ensure(0);
}

class GetItemRequest extends $pb.GeneratedMessage {
  factory GetItemRequest({
    $core.String? itemId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    return result;
  }

  GetItemRequest._();

  factory GetItemRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetItemRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetItemRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemRequest copyWith(void Function(GetItemRequest) updates) =>
      super.copyWith((message) => updates(message as GetItemRequest))
          as GetItemRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetItemRequest create() => GetItemRequest._();
  @$core.override
  GetItemRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetItemRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetItemRequest>(create);
  static GetItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);
}

class GetItemResponse extends $pb.GeneratedMessage {
  factory GetItemResponse({
    Item? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  GetItemResponse._();

  factory GetItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetItemResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Item>(1, _omitFieldNames ? '' : 'item', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetItemResponse copyWith(void Function(GetItemResponse) updates) =>
      super.copyWith((message) => updates(message as GetItemResponse))
          as GetItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetItemResponse create() => GetItemResponse._();
  @$core.override
  GetItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetItemResponse>(create);
  static GetItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(Item value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  Item ensureItem() => $_ensure(0);
}

class ListItemsRequest extends $pb.GeneratedMessage {
  factory ListItemsRequest({
    $core.String? category,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (category != null) result.category = category;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListItemsRequest._();

  factory ListItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsRequest copyWith(void Function(ListItemsRequest) updates) =>
      super.copyWith((message) => updates(message as ListItemsRequest))
          as ListItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemsRequest create() => ListItemsRequest._();
  @$core.override
  ListItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemsRequest>(create);
  static ListItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

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

class ListItemsResponse extends $pb.GeneratedMessage {
  factory ListItemsResponse({
    $core.Iterable<Item>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListItemsResponse._();

  factory ListItemsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListItemsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListItemsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Item>(1, _omitFieldNames ? '' : 'items', subBuilder: Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListItemsResponse copyWith(void Function(ListItemsResponse) updates) =>
      super.copyWith((message) => updates(message as ListItemsResponse))
          as ListItemsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListItemsResponse create() => ListItemsResponse._();
  @$core.override
  ListItemsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListItemsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListItemsResponse>(create);
  static ListItemsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Item> get items => $_getList(0);
}

class AddSupplierRequest extends $pb.GeneratedMessage {
  factory AddSupplierRequest({
    $core.String? code,
    $core.String? display,
    $core.String? contactEmail,
    $core.String? contactPhone,
    $core.int? paymentTermsDays,
    $core.String? currency,
    $core.bool? approved,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    if (contactEmail != null) result.contactEmail = contactEmail;
    if (contactPhone != null) result.contactPhone = contactPhone;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (currency != null) result.currency = currency;
    if (approved != null) result.approved = approved;
    return result;
  }

  AddSupplierRequest._();

  factory AddSupplierRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddSupplierRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSupplierRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'display')
    ..aOS(3, _omitFieldNames ? '' : 'contactEmail')
    ..aOS(4, _omitFieldNames ? '' : 'contactPhone')
    ..aI(5, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aOS(6, _omitFieldNames ? '' : 'currency')
    ..aOB(7, _omitFieldNames ? '' : 'approved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSupplierRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSupplierRequest copyWith(void Function(AddSupplierRequest) updates) =>
      super.copyWith((message) => updates(message as AddSupplierRequest))
          as AddSupplierRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddSupplierRequest create() => AddSupplierRequest._();
  @$core.override
  AddSupplierRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddSupplierRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSupplierRequest>(create);
  static AddSupplierRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get display => $_getSZ(1);
  @$pb.TagNumber(2)
  set display($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplay() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplay() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contactEmail => $_getSZ(2);
  @$pb.TagNumber(3)
  set contactEmail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContactEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearContactEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contactPhone => $_getSZ(3);
  @$pb.TagNumber(4)
  set contactPhone($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContactPhone() => $_has(3);
  @$pb.TagNumber(4)
  void clearContactPhone() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get paymentTermsDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set paymentTermsDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPaymentTermsDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearPaymentTermsDays() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currency => $_getSZ(5);
  @$pb.TagNumber(6)
  set currency($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCurrency() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrency() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get approved => $_getBF(6);
  @$pb.TagNumber(7)
  set approved($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasApproved() => $_has(6);
  @$pb.TagNumber(7)
  void clearApproved() => $_clearField(7);
}

class AddSupplierResponse extends $pb.GeneratedMessage {
  factory AddSupplierResponse({
    Supplier? supplier,
  }) {
    final result = create();
    if (supplier != null) result.supplier = supplier;
    return result;
  }

  AddSupplierResponse._();

  factory AddSupplierResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddSupplierResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddSupplierResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Supplier>(1, _omitFieldNames ? '' : 'supplier',
        subBuilder: Supplier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSupplierResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddSupplierResponse copyWith(void Function(AddSupplierResponse) updates) =>
      super.copyWith((message) => updates(message as AddSupplierResponse))
          as AddSupplierResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddSupplierResponse create() => AddSupplierResponse._();
  @$core.override
  AddSupplierResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddSupplierResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddSupplierResponse>(create);
  static AddSupplierResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Supplier get supplier => $_getN(0);
  @$pb.TagNumber(1)
  set supplier(Supplier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplier() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplier() => $_clearField(1);
  @$pb.TagNumber(1)
  Supplier ensureSupplier() => $_ensure(0);
}

class SetSupplierApprovalRequest extends $pb.GeneratedMessage {
  factory SetSupplierApprovalRequest({
    $core.String? supplierId,
    $core.bool? approved,
    $core.String? reason,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (approved != null) result.approved = approved;
    if (reason != null) result.reason = reason;
    return result;
  }

  SetSupplierApprovalRequest._();

  factory SetSupplierApprovalRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSupplierApprovalRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSupplierApprovalRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOB(2, _omitFieldNames ? '' : 'approved')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSupplierApprovalRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSupplierApprovalRequest copyWith(
          void Function(SetSupplierApprovalRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetSupplierApprovalRequest))
          as SetSupplierApprovalRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSupplierApprovalRequest create() => SetSupplierApprovalRequest._();
  @$core.override
  SetSupplierApprovalRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSupplierApprovalRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSupplierApprovalRequest>(create);
  static SetSupplierApprovalRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get approved => $_getBF(1);
  @$pb.TagNumber(2)
  set approved($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasApproved() => $_has(1);
  @$pb.TagNumber(2)
  void clearApproved() => $_clearField(2);

  /// Required when withdrawing approval: it stops every future order to this
  /// supplier, and somebody will ask why.
  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class SetSupplierApprovalResponse extends $pb.GeneratedMessage {
  factory SetSupplierApprovalResponse({
    Supplier? supplier,
  }) {
    final result = create();
    if (supplier != null) result.supplier = supplier;
    return result;
  }

  SetSupplierApprovalResponse._();

  factory SetSupplierApprovalResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetSupplierApprovalResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetSupplierApprovalResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Supplier>(1, _omitFieldNames ? '' : 'supplier',
        subBuilder: Supplier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSupplierApprovalResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetSupplierApprovalResponse copyWith(
          void Function(SetSupplierApprovalResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetSupplierApprovalResponse))
          as SetSupplierApprovalResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetSupplierApprovalResponse create() =>
      SetSupplierApprovalResponse._();
  @$core.override
  SetSupplierApprovalResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetSupplierApprovalResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetSupplierApprovalResponse>(create);
  static SetSupplierApprovalResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Supplier get supplier => $_getN(0);
  @$pb.TagNumber(1)
  set supplier(Supplier value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplier() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplier() => $_clearField(1);
  @$pb.TagNumber(1)
  Supplier ensureSupplier() => $_ensure(0);
}

class ListSuppliersRequest extends $pb.GeneratedMessage {
  factory ListSuppliersRequest({
    $core.bool? approvedOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (approvedOnly != null) result.approvedOnly = approvedOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListSuppliersRequest._();

  factory ListSuppliersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSuppliersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSuppliersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'approvedOnly')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSuppliersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSuppliersRequest copyWith(void Function(ListSuppliersRequest) updates) =>
      super.copyWith((message) => updates(message as ListSuppliersRequest))
          as ListSuppliersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSuppliersRequest create() => ListSuppliersRequest._();
  @$core.override
  ListSuppliersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSuppliersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSuppliersRequest>(create);
  static ListSuppliersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get approvedOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set approvedOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovedOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovedOnly() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListSuppliersResponse extends $pb.GeneratedMessage {
  factory ListSuppliersResponse({
    $core.Iterable<Supplier>? suppliers,
  }) {
    final result = create();
    if (suppliers != null) result.suppliers.addAll(suppliers);
    return result;
  }

  ListSuppliersResponse._();

  factory ListSuppliersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListSuppliersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListSuppliersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Supplier>(1, _omitFieldNames ? '' : 'suppliers',
        subBuilder: Supplier.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSuppliersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListSuppliersResponse copyWith(
          void Function(ListSuppliersResponse) updates) =>
      super.copyWith((message) => updates(message as ListSuppliersResponse))
          as ListSuppliersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSuppliersResponse create() => ListSuppliersResponse._();
  @$core.override
  ListSuppliersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListSuppliersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListSuppliersResponse>(create);
  static ListSuppliersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Supplier> get suppliers => $_getList(0);
}

class SetStockLevelRequest extends $pb.GeneratedMessage {
  factory SetStockLevelRequest({
    StockLevel? level,
  }) {
    final result = create();
    if (level != null) result.level = level;
    return result;
  }

  SetStockLevelRequest._();

  factory SetStockLevelRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetStockLevelRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetStockLevelRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<StockLevel>(1, _omitFieldNames ? '' : 'level',
        subBuilder: StockLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStockLevelRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStockLevelRequest copyWith(void Function(SetStockLevelRequest) updates) =>
      super.copyWith((message) => updates(message as SetStockLevelRequest))
          as SetStockLevelRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetStockLevelRequest create() => SetStockLevelRequest._();
  @$core.override
  SetStockLevelRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetStockLevelRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetStockLevelRequest>(create);
  static SetStockLevelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  StockLevel get level => $_getN(0);
  @$pb.TagNumber(1)
  set level(StockLevel value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLevel() => $_has(0);
  @$pb.TagNumber(1)
  void clearLevel() => $_clearField(1);
  @$pb.TagNumber(1)
  StockLevel ensureLevel() => $_ensure(0);
}

class SetStockLevelResponse extends $pb.GeneratedMessage {
  factory SetStockLevelResponse() => create();

  SetStockLevelResponse._();

  factory SetStockLevelResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetStockLevelResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetStockLevelResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStockLevelResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetStockLevelResponse copyWith(
          void Function(SetStockLevelResponse) updates) =>
      super.copyWith((message) => updates(message as SetStockLevelResponse))
          as SetStockLevelResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetStockLevelResponse create() => SetStockLevelResponse._();
  @$core.override
  SetStockLevelResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetStockLevelResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetStockLevelResponse>(create);
  static SetStockLevelResponse? _defaultInstance;
}

class ListStockLevelsRequest extends $pb.GeneratedMessage {
  factory ListStockLevelsRequest({
    $core.String? locationId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListStockLevelsRequest._();

  factory ListStockLevelsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStockLevelsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStockLevelsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStockLevelsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStockLevelsRequest copyWith(
          void Function(ListStockLevelsRequest) updates) =>
      super.copyWith((message) => updates(message as ListStockLevelsRequest))
          as ListStockLevelsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStockLevelsRequest create() => ListStockLevelsRequest._();
  @$core.override
  ListStockLevelsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStockLevelsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStockLevelsRequest>(create);
  static ListStockLevelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListStockLevelsResponse extends $pb.GeneratedMessage {
  factory ListStockLevelsResponse({
    $core.Iterable<StockLevel>? levels,
  }) {
    final result = create();
    if (levels != null) result.levels.addAll(levels);
    return result;
  }

  ListStockLevelsResponse._();

  factory ListStockLevelsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListStockLevelsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListStockLevelsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<StockLevel>(1, _omitFieldNames ? '' : 'levels',
        subBuilder: StockLevel.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStockLevelsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListStockLevelsResponse copyWith(
          void Function(ListStockLevelsResponse) updates) =>
      super.copyWith((message) => updates(message as ListStockLevelsResponse))
          as ListStockLevelsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStockLevelsResponse create() => ListStockLevelsResponse._();
  @$core.override
  ListStockLevelsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListStockLevelsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListStockLevelsResponse>(create);
  static ListStockLevelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StockLevel> get levels => $_getList(0);
}

class AddApprovalRuleRequest extends $pb.GeneratedMessage {
  factory AddApprovalRuleRequest({
    $fixnum.Int64? minimumValue,
    $core.String? currency,
    $core.String? category,
    $core.String? facilityId,
    $core.Iterable<$core.String>? roles,
  }) {
    final result = create();
    if (minimumValue != null) result.minimumValue = minimumValue;
    if (currency != null) result.currency = currency;
    if (category != null) result.category = category;
    if (facilityId != null) result.facilityId = facilityId;
    if (roles != null) result.roles.addAll(roles);
    return result;
  }

  AddApprovalRuleRequest._();

  factory AddApprovalRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddApprovalRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddApprovalRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'minimumValue')
    ..aOS(2, _omitFieldNames ? '' : 'currency')
    ..aOS(3, _omitFieldNames ? '' : 'category')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..pPS(5, _omitFieldNames ? '' : 'roles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApprovalRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApprovalRuleRequest copyWith(
          void Function(AddApprovalRuleRequest) updates) =>
      super.copyWith((message) => updates(message as AddApprovalRuleRequest))
          as AddApprovalRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddApprovalRuleRequest create() => AddApprovalRuleRequest._();
  @$core.override
  AddApprovalRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddApprovalRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddApprovalRuleRequest>(create);
  static AddApprovalRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get minimumValue => $_getI64(0);
  @$pb.TagNumber(1)
  set minimumValue($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinimumValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinimumValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get category => $_getSZ(2);
  @$pb.TagNumber(3)
  set category($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get roles => $_getList(4);
}

class AddApprovalRuleResponse extends $pb.GeneratedMessage {
  factory AddApprovalRuleResponse({
    ApprovalRule? rule,
  }) {
    final result = create();
    if (rule != null) result.rule = rule;
    return result;
  }

  AddApprovalRuleResponse._();

  factory AddApprovalRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddApprovalRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddApprovalRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<ApprovalRule>(1, _omitFieldNames ? '' : 'rule',
        subBuilder: ApprovalRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApprovalRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddApprovalRuleResponse copyWith(
          void Function(AddApprovalRuleResponse) updates) =>
      super.copyWith((message) => updates(message as AddApprovalRuleResponse))
          as AddApprovalRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddApprovalRuleResponse create() => AddApprovalRuleResponse._();
  @$core.override
  AddApprovalRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddApprovalRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddApprovalRuleResponse>(create);
  static AddApprovalRuleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ApprovalRule get rule => $_getN(0);
  @$pb.TagNumber(1)
  set rule(ApprovalRule value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRule() => $_has(0);
  @$pb.TagNumber(1)
  void clearRule() => $_clearField(1);
  @$pb.TagNumber(1)
  ApprovalRule ensureRule() => $_ensure(0);
}

class ListApprovalRulesRequest extends $pb.GeneratedMessage {
  factory ListApprovalRulesRequest() => create();

  ListApprovalRulesRequest._();

  factory ListApprovalRulesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListApprovalRulesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListApprovalRulesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListApprovalRulesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListApprovalRulesRequest copyWith(
          void Function(ListApprovalRulesRequest) updates) =>
      super.copyWith((message) => updates(message as ListApprovalRulesRequest))
          as ListApprovalRulesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListApprovalRulesRequest create() => ListApprovalRulesRequest._();
  @$core.override
  ListApprovalRulesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListApprovalRulesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListApprovalRulesRequest>(create);
  static ListApprovalRulesRequest? _defaultInstance;
}

class ListApprovalRulesResponse extends $pb.GeneratedMessage {
  factory ListApprovalRulesResponse({
    $core.Iterable<ApprovalRule>? rules,
  }) {
    final result = create();
    if (rules != null) result.rules.addAll(rules);
    return result;
  }

  ListApprovalRulesResponse._();

  factory ListApprovalRulesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListApprovalRulesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListApprovalRulesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<ApprovalRule>(1, _omitFieldNames ? '' : 'rules',
        subBuilder: ApprovalRule.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListApprovalRulesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListApprovalRulesResponse copyWith(
          void Function(ListApprovalRulesResponse) updates) =>
      super.copyWith((message) => updates(message as ListApprovalRulesResponse))
          as ListApprovalRulesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListApprovalRulesResponse create() => ListApprovalRulesResponse._();
  @$core.override
  ListApprovalRulesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListApprovalRulesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListApprovalRulesResponse>(create);
  static ListApprovalRulesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ApprovalRule> get rules => $_getList(0);
}

class RemoveApprovalRuleRequest extends $pb.GeneratedMessage {
  factory RemoveApprovalRuleRequest({
    $core.String? approvalRuleId,
  }) {
    final result = create();
    if (approvalRuleId != null) result.approvalRuleId = approvalRuleId;
    return result;
  }

  RemoveApprovalRuleRequest._();

  factory RemoveApprovalRuleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveApprovalRuleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveApprovalRuleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'approvalRuleId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveApprovalRuleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveApprovalRuleRequest copyWith(
          void Function(RemoveApprovalRuleRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveApprovalRuleRequest))
          as RemoveApprovalRuleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveApprovalRuleRequest create() => RemoveApprovalRuleRequest._();
  @$core.override
  RemoveApprovalRuleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveApprovalRuleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveApprovalRuleRequest>(create);
  static RemoveApprovalRuleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get approvalRuleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set approvalRuleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasApprovalRuleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearApprovalRuleId() => $_clearField(1);
}

class RemoveApprovalRuleResponse extends $pb.GeneratedMessage {
  factory RemoveApprovalRuleResponse() => create();

  RemoveApprovalRuleResponse._();

  factory RemoveApprovalRuleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveApprovalRuleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveApprovalRuleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveApprovalRuleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveApprovalRuleResponse copyWith(
          void Function(RemoveApprovalRuleResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RemoveApprovalRuleResponse))
          as RemoveApprovalRuleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveApprovalRuleResponse create() => RemoveApprovalRuleResponse._();
  @$core.override
  RemoveApprovalRuleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveApprovalRuleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveApprovalRuleResponse>(create);
  static RemoveApprovalRuleResponse? _defaultInstance;
}

class RaiseRequisitionRequest extends $pb.GeneratedMessage {
  factory RaiseRequisitionRequest({
    $core.String? number,
    $core.String? facilityId,
    RequisitionSource? source,
    $0.Timestamp? needBy,
    $core.String? costCentre,
    $core.String? sourceReference,
    $core.Iterable<RequisitionLine>? lines,
    $core.String? justification,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (source != null) result.source = source;
    if (needBy != null) result.needBy = needBy;
    if (costCentre != null) result.costCentre = costCentre;
    if (sourceReference != null) result.sourceReference = sourceReference;
    if (lines != null) result.lines.addAll(lines);
    if (justification != null) result.justification = justification;
    return result;
  }

  RaiseRequisitionRequest._();

  factory RaiseRequisitionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRequisitionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRequisitionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aE<RequisitionSource>(3, _omitFieldNames ? '' : 'source',
        enumValues: RequisitionSource.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'needBy',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'costCentre')
    ..aOS(6, _omitFieldNames ? '' : 'sourceReference')
    ..pPM<RequisitionLine>(7, _omitFieldNames ? '' : 'lines',
        subBuilder: RequisitionLine.create)
    ..aOS(8, _omitFieldNames ? '' : 'justification')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequisitionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequisitionRequest copyWith(
          void Function(RaiseRequisitionRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseRequisitionRequest))
          as RaiseRequisitionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRequisitionRequest create() => RaiseRequisitionRequest._();
  @$core.override
  RaiseRequisitionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRequisitionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRequisitionRequest>(create);
  static RaiseRequisitionRequest? _defaultInstance;

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
  RequisitionSource get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(RequisitionSource value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get needBy => $_getN(3);
  @$pb.TagNumber(4)
  set needBy($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasNeedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearNeedBy() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureNeedBy() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get costCentre => $_getSZ(4);
  @$pb.TagNumber(5)
  set costCentre($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCostCentre() => $_has(4);
  @$pb.TagNumber(5)
  void clearCostCentre() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get sourceReference => $_getSZ(5);
  @$pb.TagNumber(6)
  set sourceReference($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSourceReference() => $_has(5);
  @$pb.TagNumber(6)
  void clearSourceReference() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<RequisitionLine> get lines => $_getList(6);

  @$pb.TagNumber(8)
  $core.String get justification => $_getSZ(7);
  @$pb.TagNumber(8)
  set justification($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasJustification() => $_has(7);
  @$pb.TagNumber(8)
  void clearJustification() => $_clearField(8);
}

class RaiseRequisitionResponse extends $pb.GeneratedMessage {
  factory RaiseRequisitionResponse({
    Requisition? requisition,
  }) {
    final result = create();
    if (requisition != null) result.requisition = requisition;
    return result;
  }

  RaiseRequisitionResponse._();

  factory RaiseRequisitionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseRequisitionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseRequisitionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Requisition>(1, _omitFieldNames ? '' : 'requisition',
        subBuilder: Requisition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequisitionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseRequisitionResponse copyWith(
          void Function(RaiseRequisitionResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseRequisitionResponse))
          as RaiseRequisitionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseRequisitionResponse create() => RaiseRequisitionResponse._();
  @$core.override
  RaiseRequisitionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseRequisitionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseRequisitionResponse>(create);
  static RaiseRequisitionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Requisition get requisition => $_getN(0);
  @$pb.TagNumber(1)
  set requisition(Requisition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisition() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisition() => $_clearField(1);
  @$pb.TagNumber(1)
  Requisition ensureRequisition() => $_ensure(0);
}

class GetApprovalRouteRequest extends $pb.GeneratedMessage {
  factory GetApprovalRouteRequest({
    $core.String? requisitionId,
  }) {
    final result = create();
    if (requisitionId != null) result.requisitionId = requisitionId;
    return result;
  }

  GetApprovalRouteRequest._();

  factory GetApprovalRouteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetApprovalRouteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetApprovalRouteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requisitionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetApprovalRouteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetApprovalRouteRequest copyWith(
          void Function(GetApprovalRouteRequest) updates) =>
      super.copyWith((message) => updates(message as GetApprovalRouteRequest))
          as GetApprovalRouteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetApprovalRouteRequest create() => GetApprovalRouteRequest._();
  @$core.override
  GetApprovalRouteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetApprovalRouteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetApprovalRouteRequest>(create);
  static GetApprovalRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requisitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requisitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisitionId() => $_clearField(1);
}

class GetApprovalRouteResponse extends $pb.GeneratedMessage {
  factory GetApprovalRouteResponse({
    $core.Iterable<$core.String>? roles,
  }) {
    final result = create();
    if (roles != null) result.roles.addAll(roles);
    return result;
  }

  GetApprovalRouteResponse._();

  factory GetApprovalRouteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetApprovalRouteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetApprovalRouteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'roles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetApprovalRouteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetApprovalRouteResponse copyWith(
          void Function(GetApprovalRouteResponse) updates) =>
      super.copyWith((message) => updates(message as GetApprovalRouteResponse))
          as GetApprovalRouteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetApprovalRouteResponse create() => GetApprovalRouteResponse._();
  @$core.override
  GetApprovalRouteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetApprovalRouteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetApprovalRouteResponse>(create);
  static GetApprovalRouteResponse? _defaultInstance;

  /// Readable before submission, so a requester can see who has to sign rather
  /// than discovering it when the request sits unmoved for a week.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get roles => $_getList(0);
}

class SubmitRequisitionRequest extends $pb.GeneratedMessage {
  factory SubmitRequisitionRequest({
    $core.String? requisitionId,
  }) {
    final result = create();
    if (requisitionId != null) result.requisitionId = requisitionId;
    return result;
  }

  SubmitRequisitionRequest._();

  factory SubmitRequisitionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitRequisitionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitRequisitionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requisitionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequisitionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequisitionRequest copyWith(
          void Function(SubmitRequisitionRequest) updates) =>
      super.copyWith((message) => updates(message as SubmitRequisitionRequest))
          as SubmitRequisitionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitRequisitionRequest create() => SubmitRequisitionRequest._();
  @$core.override
  SubmitRequisitionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitRequisitionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitRequisitionRequest>(create);
  static SubmitRequisitionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requisitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requisitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisitionId() => $_clearField(1);
}

class SubmitRequisitionResponse extends $pb.GeneratedMessage {
  factory SubmitRequisitionResponse({
    Requisition? requisition,
    $core.Iterable<$core.String>? route,
  }) {
    final result = create();
    if (requisition != null) result.requisition = requisition;
    if (route != null) result.route.addAll(route);
    return result;
  }

  SubmitRequisitionResponse._();

  factory SubmitRequisitionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SubmitRequisitionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SubmitRequisitionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Requisition>(1, _omitFieldNames ? '' : 'requisition',
        subBuilder: Requisition.create)
    ..pPS(2, _omitFieldNames ? '' : 'route')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequisitionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SubmitRequisitionResponse copyWith(
          void Function(SubmitRequisitionResponse) updates) =>
      super.copyWith((message) => updates(message as SubmitRequisitionResponse))
          as SubmitRequisitionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitRequisitionResponse create() => SubmitRequisitionResponse._();
  @$core.override
  SubmitRequisitionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SubmitRequisitionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SubmitRequisitionResponse>(create);
  static SubmitRequisitionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Requisition get requisition => $_getN(0);
  @$pb.TagNumber(1)
  set requisition(Requisition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisition() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisition() => $_clearField(1);
  @$pb.TagNumber(1)
  Requisition ensureRequisition() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get route => $_getList(1);
}

class DecideRequisitionRequest extends $pb.GeneratedMessage {
  factory DecideRequisitionRequest({
    $core.String? requisitionId,
    ApprovalDecision? decision,
    $core.String? role,
    $core.String? note,
  }) {
    final result = create();
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (decision != null) result.decision = decision;
    if (role != null) result.role = role;
    if (note != null) result.note = note;
    return result;
  }

  DecideRequisitionRequest._();

  factory DecideRequisitionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideRequisitionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideRequisitionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requisitionId')
    ..aE<ApprovalDecision>(2, _omitFieldNames ? '' : 'decision',
        enumValues: ApprovalDecision.values)
    ..aOS(3, _omitFieldNames ? '' : 'role')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideRequisitionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideRequisitionRequest copyWith(
          void Function(DecideRequisitionRequest) updates) =>
      super.copyWith((message) => updates(message as DecideRequisitionRequest))
          as DecideRequisitionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideRequisitionRequest create() => DecideRequisitionRequest._();
  @$core.override
  DecideRequisitionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideRequisitionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideRequisitionRequest>(create);
  static DecideRequisitionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requisitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requisitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisitionId() => $_clearField(1);

  @$pb.TagNumber(2)
  ApprovalDecision get decision => $_getN(1);
  @$pb.TagNumber(2)
  set decision(ApprovalDecision value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDecision() => $_has(1);
  @$pb.TagNumber(2)
  void clearDecision() => $_clearField(2);

  /// The step being taken. Checked against the route's next step and against
  /// the roles the caller actually holds.
  @$pb.TagNumber(3)
  $core.String get role => $_getSZ(2);
  @$pb.TagNumber(3)
  set role($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRole() => $_has(2);
  @$pb.TagNumber(3)
  void clearRole() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

class DecideRequisitionResponse extends $pb.GeneratedMessage {
  factory DecideRequisitionResponse({
    Requisition? requisition,
    ApprovalStep? step,
  }) {
    final result = create();
    if (requisition != null) result.requisition = requisition;
    if (step != null) result.step = step;
    return result;
  }

  DecideRequisitionResponse._();

  factory DecideRequisitionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DecideRequisitionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DecideRequisitionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Requisition>(1, _omitFieldNames ? '' : 'requisition',
        subBuilder: Requisition.create)
    ..aOM<ApprovalStep>(2, _omitFieldNames ? '' : 'step',
        subBuilder: ApprovalStep.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideRequisitionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DecideRequisitionResponse copyWith(
          void Function(DecideRequisitionResponse) updates) =>
      super.copyWith((message) => updates(message as DecideRequisitionResponse))
          as DecideRequisitionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DecideRequisitionResponse create() => DecideRequisitionResponse._();
  @$core.override
  DecideRequisitionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DecideRequisitionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DecideRequisitionResponse>(create);
  static DecideRequisitionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Requisition get requisition => $_getN(0);
  @$pb.TagNumber(1)
  set requisition(Requisition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisition() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisition() => $_clearField(1);
  @$pb.TagNumber(1)
  Requisition ensureRequisition() => $_ensure(0);

  @$pb.TagNumber(2)
  ApprovalStep get step => $_getN(1);
  @$pb.TagNumber(2)
  set step(ApprovalStep value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStep() => $_has(1);
  @$pb.TagNumber(2)
  void clearStep() => $_clearField(2);
  @$pb.TagNumber(2)
  ApprovalStep ensureStep() => $_ensure(1);
}

class GetRequisitionRequest extends $pb.GeneratedMessage {
  factory GetRequisitionRequest({
    $core.String? requisitionId,
  }) {
    final result = create();
    if (requisitionId != null) result.requisitionId = requisitionId;
    return result;
  }

  GetRequisitionRequest._();

  factory GetRequisitionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRequisitionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequisitionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'requisitionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequisitionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequisitionRequest copyWith(
          void Function(GetRequisitionRequest) updates) =>
      super.copyWith((message) => updates(message as GetRequisitionRequest))
          as GetRequisitionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRequisitionRequest create() => GetRequisitionRequest._();
  @$core.override
  GetRequisitionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRequisitionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequisitionRequest>(create);
  static GetRequisitionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get requisitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set requisitionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisitionId() => $_clearField(1);
}

class GetRequisitionResponse extends $pb.GeneratedMessage {
  factory GetRequisitionResponse({
    Requisition? requisition,
  }) {
    final result = create();
    if (requisition != null) result.requisition = requisition;
    return result;
  }

  GetRequisitionResponse._();

  factory GetRequisitionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRequisitionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRequisitionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Requisition>(1, _omitFieldNames ? '' : 'requisition',
        subBuilder: Requisition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequisitionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRequisitionResponse copyWith(
          void Function(GetRequisitionResponse) updates) =>
      super.copyWith((message) => updates(message as GetRequisitionResponse))
          as GetRequisitionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRequisitionResponse create() => GetRequisitionResponse._();
  @$core.override
  GetRequisitionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRequisitionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRequisitionResponse>(create);
  static GetRequisitionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Requisition get requisition => $_getN(0);
  @$pb.TagNumber(1)
  set requisition(Requisition value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRequisition() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequisition() => $_clearField(1);
  @$pb.TagNumber(1)
  Requisition ensureRequisition() => $_ensure(0);
}

class ListRequisitionsRequest extends $pb.GeneratedMessage {
  factory ListRequisitionsRequest({
    $core.String? state,
    $core.int? pageSize,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListRequisitionsRequest._();

  factory ListRequisitionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequisitionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequisitionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'state')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequisitionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequisitionsRequest copyWith(
          void Function(ListRequisitionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRequisitionsRequest))
          as ListRequisitionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequisitionsRequest create() => ListRequisitionsRequest._();
  @$core.override
  ListRequisitionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRequisitionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequisitionsRequest>(create);
  static ListRequisitionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get state => $_getSZ(0);
  @$pb.TagNumber(1)
  set state($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListRequisitionsResponse extends $pb.GeneratedMessage {
  factory ListRequisitionsResponse({
    $core.Iterable<Requisition>? requisitions,
  }) {
    final result = create();
    if (requisitions != null) result.requisitions.addAll(requisitions);
    return result;
  }

  ListRequisitionsResponse._();

  factory ListRequisitionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRequisitionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRequisitionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Requisition>(1, _omitFieldNames ? '' : 'requisitions',
        subBuilder: Requisition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequisitionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRequisitionsResponse copyWith(
          void Function(ListRequisitionsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRequisitionsResponse))
          as ListRequisitionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRequisitionsResponse create() => ListRequisitionsResponse._();
  @$core.override
  ListRequisitionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRequisitionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRequisitionsResponse>(create);
  static ListRequisitionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Requisition> get requisitions => $_getList(0);
}

class OpenRfqRequest extends $pb.GeneratedMessage {
  factory OpenRfqRequest({
    $core.String? number,
    $core.String? requisitionId,
    $core.Iterable<$core.String>? supplierIds,
    $core.Iterable<RequisitionLine>? lines,
    $0.Timestamp? closesAt,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (supplierIds != null) result.supplierIds.addAll(supplierIds);
    if (lines != null) result.lines.addAll(lines);
    if (closesAt != null) result.closesAt = closesAt;
    return result;
  }

  OpenRfqRequest._();

  factory OpenRfqRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenRfqRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenRfqRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'requisitionId')
    ..pPS(3, _omitFieldNames ? '' : 'supplierIds')
    ..pPM<RequisitionLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: RequisitionLine.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'closesAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRfqRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRfqRequest copyWith(void Function(OpenRfqRequest) updates) =>
      super.copyWith((message) => updates(message as OpenRfqRequest))
          as OpenRfqRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenRfqRequest create() => OpenRfqRequest._();
  @$core.override
  OpenRfqRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenRfqRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenRfqRequest>(create);
  static OpenRfqRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get requisitionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set requisitionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequisitionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequisitionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get supplierIds => $_getList(2);

  /// Empty takes the requisition's lines.
  @$pb.TagNumber(4)
  $pb.PbList<RequisitionLine> get lines => $_getList(3);

  @$pb.TagNumber(5)
  $0.Timestamp get closesAt => $_getN(4);
  @$pb.TagNumber(5)
  set closesAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasClosesAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearClosesAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureClosesAt() => $_ensure(4);
}

class OpenRfqResponse extends $pb.GeneratedMessage {
  factory OpenRfqResponse({
    Rfq? rfq,
  }) {
    final result = create();
    if (rfq != null) result.rfq = rfq;
    return result;
  }

  OpenRfqResponse._();

  factory OpenRfqResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenRfqResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenRfqResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Rfq>(1, _omitFieldNames ? '' : 'rfq', subBuilder: Rfq.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRfqResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenRfqResponse copyWith(void Function(OpenRfqResponse) updates) =>
      super.copyWith((message) => updates(message as OpenRfqResponse))
          as OpenRfqResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenRfqResponse create() => OpenRfqResponse._();
  @$core.override
  OpenRfqResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenRfqResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenRfqResponse>(create);
  static OpenRfqResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Rfq get rfq => $_getN(0);
  @$pb.TagNumber(1)
  set rfq(Rfq value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRfq() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfq() => $_clearField(1);
  @$pb.TagNumber(1)
  Rfq ensureRfq() => $_ensure(0);
}

class RecordBidRequest extends $pb.GeneratedMessage {
  factory RecordBidRequest({
    $core.String? rfqId,
    $core.String? supplierId,
    $core.Iterable<BidLine>? lines,
    $core.int? leadTimeDays,
    $core.int? warrantyMonths,
    $core.int? paymentTermsDays,
    $fixnum.Int64? freightMinor,
    $fixnum.Int64? taxMinor,
    $core.String? currency,
    $core.String? notes,
  }) {
    final result = create();
    if (rfqId != null) result.rfqId = rfqId;
    if (supplierId != null) result.supplierId = supplierId;
    if (lines != null) result.lines.addAll(lines);
    if (leadTimeDays != null) result.leadTimeDays = leadTimeDays;
    if (warrantyMonths != null) result.warrantyMonths = warrantyMonths;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (freightMinor != null) result.freightMinor = freightMinor;
    if (taxMinor != null) result.taxMinor = taxMinor;
    if (currency != null) result.currency = currency;
    if (notes != null) result.notes = notes;
    return result;
  }

  RecordBidRequest._();

  factory RecordBidRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordBidRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordBidRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rfqId')
    ..aOS(2, _omitFieldNames ? '' : 'supplierId')
    ..pPM<BidLine>(3, _omitFieldNames ? '' : 'lines',
        subBuilder: BidLine.create)
    ..aI(4, _omitFieldNames ? '' : 'leadTimeDays')
    ..aI(5, _omitFieldNames ? '' : 'warrantyMonths')
    ..aI(6, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aInt64(7, _omitFieldNames ? '' : 'freightMinor')
    ..aInt64(8, _omitFieldNames ? '' : 'taxMinor')
    ..aOS(9, _omitFieldNames ? '' : 'currency')
    ..aOS(10, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBidRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBidRequest copyWith(void Function(RecordBidRequest) updates) =>
      super.copyWith((message) => updates(message as RecordBidRequest))
          as RecordBidRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordBidRequest create() => RecordBidRequest._();
  @$core.override
  RecordBidRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordBidRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordBidRequest>(create);
  static RecordBidRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rfqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rfqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRfqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfqId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get supplierId => $_getSZ(1);
  @$pb.TagNumber(2)
  set supplierId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSupplierId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupplierId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BidLine> get lines => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get leadTimeDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set leadTimeDays($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLeadTimeDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearLeadTimeDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get warrantyMonths => $_getIZ(4);
  @$pb.TagNumber(5)
  set warrantyMonths($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasWarrantyMonths() => $_has(4);
  @$pb.TagNumber(5)
  void clearWarrantyMonths() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get paymentTermsDays => $_getIZ(5);
  @$pb.TagNumber(6)
  set paymentTermsDays($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPaymentTermsDays() => $_has(5);
  @$pb.TagNumber(6)
  void clearPaymentTermsDays() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get freightMinor => $_getI64(6);
  @$pb.TagNumber(7)
  set freightMinor($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFreightMinor() => $_has(6);
  @$pb.TagNumber(7)
  void clearFreightMinor() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get taxMinor => $_getI64(7);
  @$pb.TagNumber(8)
  set taxMinor($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTaxMinor() => $_has(7);
  @$pb.TagNumber(8)
  void clearTaxMinor() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get currency => $_getSZ(8);
  @$pb.TagNumber(9)
  set currency($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrency() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrency() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get notes => $_getSZ(9);
  @$pb.TagNumber(10)
  set notes($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearNotes() => $_clearField(10);
}

class RecordBidResponse extends $pb.GeneratedMessage {
  factory RecordBidResponse({
    Bid? bid,
  }) {
    final result = create();
    if (bid != null) result.bid = bid;
    return result;
  }

  RecordBidResponse._();

  factory RecordBidResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordBidResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordBidResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Bid>(1, _omitFieldNames ? '' : 'bid', subBuilder: Bid.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBidResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordBidResponse copyWith(void Function(RecordBidResponse) updates) =>
      super.copyWith((message) => updates(message as RecordBidResponse))
          as RecordBidResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordBidResponse create() => RecordBidResponse._();
  @$core.override
  RecordBidResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordBidResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordBidResponse>(create);
  static RecordBidResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Bid get bid => $_getN(0);
  @$pb.TagNumber(1)
  set bid(Bid value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBid() => $_has(0);
  @$pb.TagNumber(1)
  void clearBid() => $_clearField(1);
  @$pb.TagNumber(1)
  Bid ensureBid() => $_ensure(0);
}

class CompareBidsRequest extends $pb.GeneratedMessage {
  factory CompareBidsRequest({
    $core.String? rfqId,
  }) {
    final result = create();
    if (rfqId != null) result.rfqId = rfqId;
    return result;
  }

  CompareBidsRequest._();

  factory CompareBidsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompareBidsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareBidsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rfqId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareBidsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareBidsRequest copyWith(void Function(CompareBidsRequest) updates) =>
      super.copyWith((message) => updates(message as CompareBidsRequest))
          as CompareBidsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareBidsRequest create() => CompareBidsRequest._();
  @$core.override
  CompareBidsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompareBidsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareBidsRequest>(create);
  static CompareBidsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rfqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rfqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRfqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfqId() => $_clearField(1);
}

class CompareBidsResponse extends $pb.GeneratedMessage {
  factory CompareBidsResponse({
    $core.Iterable<Comparison>? comparisons,
  }) {
    final result = create();
    if (comparisons != null) result.comparisons.addAll(comparisons);
    return result;
  }

  CompareBidsResponse._();

  factory CompareBidsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompareBidsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompareBidsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Comparison>(1, _omitFieldNames ? '' : 'comparisons',
        subBuilder: Comparison.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareBidsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompareBidsResponse copyWith(void Function(CompareBidsResponse) updates) =>
      super.copyWith((message) => updates(message as CompareBidsResponse))
          as CompareBidsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareBidsResponse create() => CompareBidsResponse._();
  @$core.override
  CompareBidsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompareBidsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompareBidsResponse>(create);
  static CompareBidsResponse? _defaultInstance;

  /// The comparison, not a winner: which quote to accept weighs lead time
  /// against price against a relationship, and that is a buyer's judgement.
  @$pb.TagNumber(1)
  $pb.PbList<Comparison> get comparisons => $_getList(0);
}

class GetRfqRequest extends $pb.GeneratedMessage {
  factory GetRfqRequest({
    $core.String? rfqId,
  }) {
    final result = create();
    if (rfqId != null) result.rfqId = rfqId;
    return result;
  }

  GetRfqRequest._();

  factory GetRfqRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRfqRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRfqRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'rfqId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRfqRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRfqRequest copyWith(void Function(GetRfqRequest) updates) =>
      super.copyWith((message) => updates(message as GetRfqRequest))
          as GetRfqRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRfqRequest create() => GetRfqRequest._();
  @$core.override
  GetRfqRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRfqRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRfqRequest>(create);
  static GetRfqRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get rfqId => $_getSZ(0);
  @$pb.TagNumber(1)
  set rfqId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRfqId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfqId() => $_clearField(1);
}

class GetRfqResponse extends $pb.GeneratedMessage {
  factory GetRfqResponse({
    Rfq? rfq,
  }) {
    final result = create();
    if (rfq != null) result.rfq = rfq;
    return result;
  }

  GetRfqResponse._();

  factory GetRfqResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRfqResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRfqResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Rfq>(1, _omitFieldNames ? '' : 'rfq', subBuilder: Rfq.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRfqResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRfqResponse copyWith(void Function(GetRfqResponse) updates) =>
      super.copyWith((message) => updates(message as GetRfqResponse))
          as GetRfqResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRfqResponse create() => GetRfqResponse._();
  @$core.override
  GetRfqResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRfqResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRfqResponse>(create);
  static GetRfqResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Rfq get rfq => $_getN(0);
  @$pb.TagNumber(1)
  set rfq(Rfq value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRfq() => $_has(0);
  @$pb.TagNumber(1)
  void clearRfq() => $_clearField(1);
  @$pb.TagNumber(1)
  Rfq ensureRfq() => $_ensure(0);
}

class ListRfqsRequest extends $pb.GeneratedMessage {
  factory ListRfqsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListRfqsRequest._();

  factory ListRfqsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRfqsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRfqsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRfqsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRfqsRequest copyWith(void Function(ListRfqsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRfqsRequest))
          as ListRfqsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRfqsRequest create() => ListRfqsRequest._();
  @$core.override
  ListRfqsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRfqsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRfqsRequest>(create);
  static ListRfqsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListRfqsResponse extends $pb.GeneratedMessage {
  factory ListRfqsResponse({
    $core.Iterable<Rfq>? rfqs,
  }) {
    final result = create();
    if (rfqs != null) result.rfqs.addAll(rfqs);
    return result;
  }

  ListRfqsResponse._();

  factory ListRfqsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRfqsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRfqsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Rfq>(1, _omitFieldNames ? '' : 'rfqs', subBuilder: Rfq.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRfqsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRfqsResponse copyWith(void Function(ListRfqsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRfqsResponse))
          as ListRfqsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRfqsResponse create() => ListRfqsResponse._();
  @$core.override
  ListRfqsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRfqsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRfqsResponse>(create);
  static ListRfqsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Rfq> get rfqs => $_getList(0);
}

class PlaceOrderRequest extends $pb.GeneratedMessage {
  factory PlaceOrderRequest({
    $core.String? number,
    $core.String? facilityId,
    $core.String? supplierId,
    $core.String? requisitionId,
    $core.String? bidId,
    $core.Iterable<PurchaseOrderLine>? lines,
    $core.String? currency,
    $core.int? paymentTermsDays,
    $core.String? deliveryTerms,
    $core.int? toleranceOverPercent,
    $core.int? toleranceShortPercent,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (facilityId != null) result.facilityId = facilityId;
    if (supplierId != null) result.supplierId = supplierId;
    if (requisitionId != null) result.requisitionId = requisitionId;
    if (bidId != null) result.bidId = bidId;
    if (lines != null) result.lines.addAll(lines);
    if (currency != null) result.currency = currency;
    if (paymentTermsDays != null) result.paymentTermsDays = paymentTermsDays;
    if (deliveryTerms != null) result.deliveryTerms = deliveryTerms;
    if (toleranceOverPercent != null)
      result.toleranceOverPercent = toleranceOverPercent;
    if (toleranceShortPercent != null)
      result.toleranceShortPercent = toleranceShortPercent;
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
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'supplierId')
    ..aOS(4, _omitFieldNames ? '' : 'requisitionId')
    ..aOS(5, _omitFieldNames ? '' : 'bidId')
    ..pPM<PurchaseOrderLine>(6, _omitFieldNames ? '' : 'lines',
        subBuilder: PurchaseOrderLine.create)
    ..aOS(7, _omitFieldNames ? '' : 'currency')
    ..aI(8, _omitFieldNames ? '' : 'paymentTermsDays')
    ..aOS(9, _omitFieldNames ? '' : 'deliveryTerms')
    ..aI(10, _omitFieldNames ? '' : 'toleranceOverPercent')
    ..aI(11, _omitFieldNames ? '' : 'toleranceShortPercent')
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
  $core.String get supplierId => $_getSZ(2);
  @$pb.TagNumber(3)
  set supplierId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSupplierId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSupplierId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get requisitionId => $_getSZ(3);
  @$pb.TagNumber(4)
  set requisitionId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRequisitionId() => $_has(3);
  @$pb.TagNumber(4)
  void clearRequisitionId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get bidId => $_getSZ(4);
  @$pb.TagNumber(5)
  set bidId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasBidId() => $_has(4);
  @$pb.TagNumber(5)
  void clearBidId() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<PurchaseOrderLine> get lines => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get currency => $_getSZ(6);
  @$pb.TagNumber(7)
  set currency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCurrency() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrency() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get paymentTermsDays => $_getIZ(7);
  @$pb.TagNumber(8)
  set paymentTermsDays($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPaymentTermsDays() => $_has(7);
  @$pb.TagNumber(8)
  void clearPaymentTermsDays() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deliveryTerms => $_getSZ(8);
  @$pb.TagNumber(9)
  set deliveryTerms($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeliveryTerms() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeliveryTerms() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get toleranceOverPercent => $_getIZ(9);
  @$pb.TagNumber(10)
  set toleranceOverPercent($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasToleranceOverPercent() => $_has(9);
  @$pb.TagNumber(10)
  void clearToleranceOverPercent() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get toleranceShortPercent => $_getIZ(10);
  @$pb.TagNumber(11)
  set toleranceShortPercent($core.int value) => $_setSignedInt32(10, value);
  @$pb.TagNumber(11)
  $core.bool hasToleranceShortPercent() => $_has(10);
  @$pb.TagNumber(11)
  void clearToleranceShortPercent() => $_clearField(11);
}

class PlaceOrderResponse extends $pb.GeneratedMessage {
  factory PlaceOrderResponse({
    PurchaseOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
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
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<PurchaseOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: PurchaseOrder.create)
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

  @$pb.TagNumber(1)
  PurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(PurchaseOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  PurchaseOrder ensureOrder() => $_ensure(0);
}

class IssueOrderRequest extends $pb.GeneratedMessage {
  factory IssueOrderRequest({
    $core.String? purchaseOrderId,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    return result;
  }

  IssueOrderRequest._();

  factory IssueOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueOrderRequest copyWith(void Function(IssueOrderRequest) updates) =>
      super.copyWith((message) => updates(message as IssueOrderRequest))
          as IssueOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueOrderRequest create() => IssueOrderRequest._();
  @$core.override
  IssueOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueOrderRequest>(create);
  static IssueOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);
}

class IssueOrderResponse extends $pb.GeneratedMessage {
  factory IssueOrderResponse({
    PurchaseOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  IssueOrderResponse._();

  factory IssueOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<PurchaseOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: PurchaseOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueOrderResponse copyWith(void Function(IssueOrderResponse) updates) =>
      super.copyWith((message) => updates(message as IssueOrderResponse))
          as IssueOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueOrderResponse create() => IssueOrderResponse._();
  @$core.override
  IssueOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueOrderResponse>(create);
  static IssueOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(PurchaseOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  PurchaseOrder ensureOrder() => $_ensure(0);
}

class AmendOrderRequest extends $pb.GeneratedMessage {
  factory AmendOrderRequest({
    $core.String? purchaseOrderId,
    $core.Iterable<PurchaseOrderLine>? lines,
    $core.String? reason,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (lines != null) result.lines.addAll(lines);
    if (reason != null) result.reason = reason;
    return result;
  }

  AmendOrderRequest._();

  factory AmendOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..pPM<PurchaseOrderLine>(2, _omitFieldNames ? '' : 'lines',
        subBuilder: PurchaseOrderLine.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOrderRequest copyWith(void Function(AmendOrderRequest) updates) =>
      super.copyWith((message) => updates(message as AmendOrderRequest))
          as AmendOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendOrderRequest create() => AmendOrderRequest._();
  @$core.override
  AmendOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendOrderRequest>(create);
  static AmendOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<PurchaseOrderLine> get lines => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class AmendOrderResponse extends $pb.GeneratedMessage {
  factory AmendOrderResponse({
    PurchaseOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  AmendOrderResponse._();

  factory AmendOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AmendOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AmendOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<PurchaseOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: PurchaseOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AmendOrderResponse copyWith(void Function(AmendOrderResponse) updates) =>
      super.copyWith((message) => updates(message as AmendOrderResponse))
          as AmendOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AmendOrderResponse create() => AmendOrderResponse._();
  @$core.override
  AmendOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AmendOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AmendOrderResponse>(create);
  static AmendOrderResponse? _defaultInstance;

  /// A new revision. The earlier one is closed, because a supplier delivering
  /// against either is the failure versioning exists to prevent.
  @$pb.TagNumber(1)
  PurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(PurchaseOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  PurchaseOrder ensureOrder() => $_ensure(0);
}

class GetPurchaseOrderRequest extends $pb.GeneratedMessage {
  factory GetPurchaseOrderRequest({
    $core.String? purchaseOrderId,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    return result;
  }

  GetPurchaseOrderRequest._();

  factory GetPurchaseOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPurchaseOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPurchaseOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPurchaseOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPurchaseOrderRequest copyWith(
          void Function(GetPurchaseOrderRequest) updates) =>
      super.copyWith((message) => updates(message as GetPurchaseOrderRequest))
          as GetPurchaseOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPurchaseOrderRequest create() => GetPurchaseOrderRequest._();
  @$core.override
  GetPurchaseOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPurchaseOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPurchaseOrderRequest>(create);
  static GetPurchaseOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);
}

class GetPurchaseOrderResponse extends $pb.GeneratedMessage {
  factory GetPurchaseOrderResponse({
    PurchaseOrder? order,
  }) {
    final result = create();
    if (order != null) result.order = order;
    return result;
  }

  GetPurchaseOrderResponse._();

  factory GetPurchaseOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPurchaseOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPurchaseOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<PurchaseOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: PurchaseOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPurchaseOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPurchaseOrderResponse copyWith(
          void Function(GetPurchaseOrderResponse) updates) =>
      super.copyWith((message) => updates(message as GetPurchaseOrderResponse))
          as GetPurchaseOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPurchaseOrderResponse create() => GetPurchaseOrderResponse._();
  @$core.override
  GetPurchaseOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPurchaseOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPurchaseOrderResponse>(create);
  static GetPurchaseOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(PurchaseOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  PurchaseOrder ensureOrder() => $_ensure(0);
}

class ListOrderRevisionsRequest extends $pb.GeneratedMessage {
  factory ListOrderRevisionsRequest({
    $core.String? purchaseOrderId,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    return result;
  }

  ListOrderRevisionsRequest._();

  factory ListOrderRevisionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrderRevisionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrderRevisionsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderRevisionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderRevisionsRequest copyWith(
          void Function(ListOrderRevisionsRequest) updates) =>
      super.copyWith((message) => updates(message as ListOrderRevisionsRequest))
          as ListOrderRevisionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrderRevisionsRequest create() => ListOrderRevisionsRequest._();
  @$core.override
  ListOrderRevisionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrderRevisionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrderRevisionsRequest>(create);
  static ListOrderRevisionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);
}

class ListOrderRevisionsResponse extends $pb.GeneratedMessage {
  factory ListOrderRevisionsResponse({
    $core.Iterable<PurchaseOrder>? revisions,
  }) {
    final result = create();
    if (revisions != null) result.revisions.addAll(revisions);
    return result;
  }

  ListOrderRevisionsResponse._();

  factory ListOrderRevisionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListOrderRevisionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListOrderRevisionsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<PurchaseOrder>(1, _omitFieldNames ? '' : 'revisions',
        subBuilder: PurchaseOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderRevisionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListOrderRevisionsResponse copyWith(
          void Function(ListOrderRevisionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListOrderRevisionsResponse))
          as ListOrderRevisionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListOrderRevisionsResponse create() => ListOrderRevisionsResponse._();
  @$core.override
  ListOrderRevisionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListOrderRevisionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListOrderRevisionsResponse>(create);
  static ListOrderRevisionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PurchaseOrder> get revisions => $_getList(0);
}

class ListPurchaseOrdersRequest extends $pb.GeneratedMessage {
  factory ListPurchaseOrdersRequest({
    $core.String? supplierId,
    $core.String? state,
    $core.int? pageSize,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPurchaseOrdersRequest._();

  factory ListPurchaseOrdersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPurchaseOrdersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPurchaseOrdersRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOS(2, _omitFieldNames ? '' : 'state')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPurchaseOrdersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPurchaseOrdersRequest copyWith(
          void Function(ListPurchaseOrdersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPurchaseOrdersRequest))
          as ListPurchaseOrdersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPurchaseOrdersRequest create() => ListPurchaseOrdersRequest._();
  @$core.override
  ListPurchaseOrdersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPurchaseOrdersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPurchaseOrdersRequest>(create);
  static ListPurchaseOrdersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get state => $_getSZ(1);
  @$pb.TagNumber(2)
  set state($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasState() => $_has(1);
  @$pb.TagNumber(2)
  void clearState() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListPurchaseOrdersResponse extends $pb.GeneratedMessage {
  factory ListPurchaseOrdersResponse({
    $core.Iterable<PurchaseOrder>? orders,
  }) {
    final result = create();
    if (orders != null) result.orders.addAll(orders);
    return result;
  }

  ListPurchaseOrdersResponse._();

  factory ListPurchaseOrdersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPurchaseOrdersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPurchaseOrdersResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<PurchaseOrder>(1, _omitFieldNames ? '' : 'orders',
        subBuilder: PurchaseOrder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPurchaseOrdersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPurchaseOrdersResponse copyWith(
          void Function(ListPurchaseOrdersResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListPurchaseOrdersResponse))
          as ListPurchaseOrdersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPurchaseOrdersResponse create() => ListPurchaseOrdersResponse._();
  @$core.override
  ListPurchaseOrdersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPurchaseOrdersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPurchaseOrdersResponse>(create);
  static ListPurchaseOrdersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PurchaseOrder> get orders => $_getList(0);
}

class ReceiveGoodsRequest extends $pb.GeneratedMessage {
  factory ReceiveGoodsRequest({
    $core.String? purchaseOrderId,
    $core.String? number,
    $core.String? locationId,
    $core.String? deliveryNote,
    $core.String? invoiceRef,
    $core.Iterable<ReceiptLine>? lines,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (number != null) result.number = number;
    if (locationId != null) result.locationId = locationId;
    if (deliveryNote != null) result.deliveryNote = deliveryNote;
    if (invoiceRef != null) result.invoiceRef = invoiceRef;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  ReceiveGoodsRequest._();

  factory ReceiveGoodsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveGoodsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveGoodsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aOS(3, _omitFieldNames ? '' : 'locationId')
    ..aOS(4, _omitFieldNames ? '' : 'deliveryNote')
    ..aOS(5, _omitFieldNames ? '' : 'invoiceRef')
    ..pPM<ReceiptLine>(6, _omitFieldNames ? '' : 'lines',
        subBuilder: ReceiptLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveGoodsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveGoodsRequest copyWith(void Function(ReceiveGoodsRequest) updates) =>
      super.copyWith((message) => updates(message as ReceiveGoodsRequest))
          as ReceiveGoodsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveGoodsRequest create() => ReceiveGoodsRequest._();
  @$core.override
  ReceiveGoodsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveGoodsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveGoodsRequest>(create);
  static ReceiveGoodsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set locationId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get deliveryNote => $_getSZ(3);
  @$pb.TagNumber(4)
  set deliveryNote($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDeliveryNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeliveryNote() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get invoiceRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set invoiceRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInvoiceRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvoiceRef() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ReceiptLine> get lines => $_getList(5);
}

class ReceiveGoodsResponse extends $pb.GeneratedMessage {
  factory ReceiveGoodsResponse({
    Receipt? receipt,
    $core.Iterable<$core.String>? short,
    $core.Iterable<$core.String>? quarantined,
  }) {
    final result = create();
    if (receipt != null) result.receipt = receipt;
    if (short != null) result.short.addAll(short);
    if (quarantined != null) result.quarantined.addAll(quarantined);
    return result;
  }

  ReceiveGoodsResponse._();

  factory ReceiveGoodsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveGoodsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveGoodsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Receipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: Receipt.create)
    ..pPS(2, _omitFieldNames ? '' : 'short')
    ..pPS(3, _omitFieldNames ? '' : 'quarantined')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveGoodsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveGoodsResponse copyWith(void Function(ReceiveGoodsResponse) updates) =>
      super.copyWith((message) => updates(message as ReceiveGoodsResponse))
          as ReceiveGoodsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveGoodsResponse create() => ReceiveGoodsResponse._();
  @$core.override
  ReceiveGoodsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveGoodsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveGoodsResponse>(create);
  static ReceiveGoodsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Receipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(Receipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  Receipt ensureReceipt() => $_ensure(0);

  /// Lines beyond the order's short tolerance. Reported rather than refused:
  /// the goods are on the dock whatever the count says.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get short => $_getList(1);

  /// Lines that landed in quarantine, so a storekeeper is not left wondering
  /// why the shelf figure did not move.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get quarantined => $_getList(2);
}

class InspectRequest extends $pb.GeneratedMessage {
  factory InspectRequest({
    $core.String? lotId,
    $core.String? locationId,
    $core.int? quantity,
    $core.bool? accept,
    $core.String? reason,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (locationId != null) result.locationId = locationId;
    if (quantity != null) result.quantity = quantity;
    if (accept != null) result.accept = accept;
    if (reason != null) result.reason = reason;
    return result;
  }

  InspectRequest._();

  factory InspectRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InspectRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InspectRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aOB(4, _omitFieldNames ? '' : 'accept')
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectRequest copyWith(void Function(InspectRequest) updates) =>
      super.copyWith((message) => updates(message as InspectRequest))
          as InspectRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InspectRequest create() => InspectRequest._();
  @$core.override
  InspectRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InspectRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InspectRequest>(create);
  static InspectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get accept => $_getBF(3);
  @$pb.TagNumber(4)
  set accept($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAccept() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccept() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class InspectResponse extends $pb.GeneratedMessage {
  factory InspectResponse({
    Movement? movement,
  }) {
    final result = create();
    if (movement != null) result.movement = movement;
    return result;
  }

  InspectResponse._();

  factory InspectResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InspectResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InspectResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Movement>(1, _omitFieldNames ? '' : 'movement',
        subBuilder: Movement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InspectResponse copyWith(void Function(InspectResponse) updates) =>
      super.copyWith((message) => updates(message as InspectResponse))
          as InspectResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InspectResponse create() => InspectResponse._();
  @$core.override
  InspectResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InspectResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InspectResponse>(create);
  static InspectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Movement get movement => $_getN(0);
  @$pb.TagNumber(1)
  set movement(Movement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMovement() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovement() => $_clearField(1);
  @$pb.TagNumber(1)
  Movement ensureMovement() => $_ensure(0);
}

class GetReceiptRequest extends $pb.GeneratedMessage {
  factory GetReceiptRequest({
    $core.String? receiptId,
  }) {
    final result = create();
    if (receiptId != null) result.receiptId = receiptId;
    return result;
  }

  GetReceiptRequest._();

  factory GetReceiptRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReceiptRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReceiptRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'receiptId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReceiptRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReceiptRequest copyWith(void Function(GetReceiptRequest) updates) =>
      super.copyWith((message) => updates(message as GetReceiptRequest))
          as GetReceiptRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReceiptRequest create() => GetReceiptRequest._();
  @$core.override
  GetReceiptRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReceiptRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReceiptRequest>(create);
  static GetReceiptRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get receiptId => $_getSZ(0);
  @$pb.TagNumber(1)
  set receiptId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReceiptId() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceiptId() => $_clearField(1);
}

class GetReceiptResponse extends $pb.GeneratedMessage {
  factory GetReceiptResponse({
    Receipt? receipt,
  }) {
    final result = create();
    if (receipt != null) result.receipt = receipt;
    return result;
  }

  GetReceiptResponse._();

  factory GetReceiptResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetReceiptResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetReceiptResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Receipt>(1, _omitFieldNames ? '' : 'receipt',
        subBuilder: Receipt.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReceiptResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetReceiptResponse copyWith(void Function(GetReceiptResponse) updates) =>
      super.copyWith((message) => updates(message as GetReceiptResponse))
          as GetReceiptResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReceiptResponse create() => GetReceiptResponse._();
  @$core.override
  GetReceiptResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetReceiptResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetReceiptResponse>(create);
  static GetReceiptResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Receipt get receipt => $_getN(0);
  @$pb.TagNumber(1)
  set receipt(Receipt value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReceipt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReceipt() => $_clearField(1);
  @$pb.TagNumber(1)
  Receipt ensureReceipt() => $_ensure(0);
}

class ListReceiptsRequest extends $pb.GeneratedMessage {
  factory ListReceiptsRequest({
    $core.String? purchaseOrderId,
  }) {
    final result = create();
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    return result;
  }

  ListReceiptsRequest._();

  factory ListReceiptsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReceiptsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReceiptsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'purchaseOrderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReceiptsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReceiptsRequest copyWith(void Function(ListReceiptsRequest) updates) =>
      super.copyWith((message) => updates(message as ListReceiptsRequest))
          as ListReceiptsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReceiptsRequest create() => ListReceiptsRequest._();
  @$core.override
  ListReceiptsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReceiptsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReceiptsRequest>(create);
  static ListReceiptsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseOrderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseOrderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPurchaseOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseOrderId() => $_clearField(1);
}

class ListReceiptsResponse extends $pb.GeneratedMessage {
  factory ListReceiptsResponse({
    $core.Iterable<Receipt>? receipts,
  }) {
    final result = create();
    if (receipts != null) result.receipts.addAll(receipts);
    return result;
  }

  ListReceiptsResponse._();

  factory ListReceiptsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListReceiptsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListReceiptsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Receipt>(1, _omitFieldNames ? '' : 'receipts',
        subBuilder: Receipt.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReceiptsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListReceiptsResponse copyWith(void Function(ListReceiptsResponse) updates) =>
      super.copyWith((message) => updates(message as ListReceiptsResponse))
          as ListReceiptsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReceiptsResponse create() => ListReceiptsResponse._();
  @$core.override
  ListReceiptsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListReceiptsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListReceiptsResponse>(create);
  static ListReceiptsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Receipt> get receipts => $_getList(0);
}

class RecommendPickRequest extends $pb.GeneratedMessage {
  factory RecommendPickRequest({
    $core.String? itemId,
    $core.String? locationId,
    $core.int? quantity,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  RecommendPickRequest._();

  factory RecommendPickRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecommendPickRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecommendPickRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecommendPickRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecommendPickRequest copyWith(void Function(RecommendPickRequest) updates) =>
      super.copyWith((message) => updates(message as RecommendPickRequest))
          as RecommendPickRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecommendPickRequest create() => RecommendPickRequest._();
  @$core.override
  RecommendPickRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecommendPickRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecommendPickRequest>(create);
  static RecommendPickRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);
}

class RecommendPickResponse extends $pb.GeneratedMessage {
  factory RecommendPickResponse({
    Pick? pick,
  }) {
    final result = create();
    if (pick != null) result.pick = pick;
    return result;
  }

  RecommendPickResponse._();

  factory RecommendPickResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecommendPickResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecommendPickResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Pick>(1, _omitFieldNames ? '' : 'pick', subBuilder: Pick.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecommendPickResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecommendPickResponse copyWith(
          void Function(RecommendPickResponse) updates) =>
      super.copyWith((message) => updates(message as RecommendPickResponse))
          as RecommendPickResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecommendPickResponse create() => RecommendPickResponse._();
  @$core.override
  RecommendPickResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecommendPickResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecommendPickResponse>(create);
  static RecommendPickResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Pick get pick => $_getN(0);
  @$pb.TagNumber(1)
  set pick(Pick value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPick() => $_has(0);
  @$pb.TagNumber(1)
  void clearPick() => $_clearField(1);
  @$pb.TagNumber(1)
  Pick ensurePick() => $_ensure(0);
}

class IssueStockRequest extends $pb.GeneratedMessage {
  factory IssueStockRequest({
    $core.String? itemId,
    $core.String? lotId,
    $core.String? fromLocation,
    $core.String? toLocation,
    $core.int? quantity,
    $core.String? costCentre,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? reference,
    $core.String? reason,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (fromLocation != null) result.fromLocation = fromLocation;
    if (toLocation != null) result.toLocation = toLocation;
    if (quantity != null) result.quantity = quantity;
    if (costCentre != null) result.costCentre = costCentre;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (reference != null) result.reference = reference;
    if (reason != null) result.reason = reason;
    return result;
  }

  IssueStockRequest._();

  factory IssueStockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aOS(3, _omitFieldNames ? '' : 'fromLocation')
    ..aOS(4, _omitFieldNames ? '' : 'toLocation')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOS(6, _omitFieldNames ? '' : 'costCentre')
    ..aOS(7, _omitFieldNames ? '' : 'patientId')
    ..aOS(8, _omitFieldNames ? '' : 'encounterId')
    ..aOS(9, _omitFieldNames ? '' : 'reference')
    ..aOS(10, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueStockRequest copyWith(void Function(IssueStockRequest) updates) =>
      super.copyWith((message) => updates(message as IssueStockRequest))
          as IssueStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueStockRequest create() => IssueStockRequest._();
  @$core.override
  IssueStockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueStockRequest>(create);
  static IssueStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  /// Empty lets the item's policy choose, which is what a ward top-up does; an
  /// implant for a named patient names its lot.
  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromLocation => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromLocation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromLocation() => $_clearField(3);

  /// Empty means it left the hospital's stock entirely.
  @$pb.TagNumber(4)
  $core.String get toLocation => $_getSZ(3);
  @$pb.TagNumber(4)
  set toLocation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearToLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get costCentre => $_getSZ(5);
  @$pb.TagNumber(6)
  set costCentre($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostCentre() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostCentre() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get patientId => $_getSZ(6);
  @$pb.TagNumber(7)
  set patientId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPatientId() => $_has(6);
  @$pb.TagNumber(7)
  void clearPatientId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get encounterId => $_getSZ(7);
  @$pb.TagNumber(8)
  set encounterId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEncounterId() => $_has(7);
  @$pb.TagNumber(8)
  void clearEncounterId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reference => $_getSZ(8);
  @$pb.TagNumber(9)
  set reference($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReference() => $_has(8);
  @$pb.TagNumber(9)
  void clearReference() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get reason => $_getSZ(9);
  @$pb.TagNumber(10)
  set reason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearReason() => $_clearField(10);
}

class IssueStockResponse extends $pb.GeneratedMessage {
  factory IssueStockResponse({
    $core.Iterable<Movement>? movements,
    $core.int? short,
    $core.Iterable<$core.String>? skipped,
    $core.String? chargeId,
    $core.Iterable<LiabilityEvent>? liabilities,
  }) {
    final result = create();
    if (movements != null) result.movements.addAll(movements);
    if (short != null) result.short = short;
    if (skipped != null) result.skipped.addAll(skipped);
    if (chargeId != null) result.chargeId = chargeId;
    if (liabilities != null) result.liabilities.addAll(liabilities);
    return result;
  }

  IssueStockResponse._();

  factory IssueStockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IssueStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IssueStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Movement>(1, _omitFieldNames ? '' : 'movements',
        subBuilder: Movement.create)
    ..aI(2, _omitFieldNames ? '' : 'short')
    ..pPS(3, _omitFieldNames ? '' : 'skipped')
    ..aOS(4, _omitFieldNames ? '' : 'chargeId')
    ..pPM<LiabilityEvent>(5, _omitFieldNames ? '' : 'liabilities',
        subBuilder: LiabilityEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IssueStockResponse copyWith(void Function(IssueStockResponse) updates) =>
      super.copyWith((message) => updates(message as IssueStockResponse))
          as IssueStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IssueStockResponse create() => IssueStockResponse._();
  @$core.override
  IssueStockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IssueStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IssueStockResponse>(create);
  static IssueStockResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Movement> get movements => $_getList(0);

  @$pb.TagNumber(2)
  $core.int get short => $_getIZ(1);
  @$pb.TagNumber(2)
  set short($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasShort() => $_has(1);
  @$pb.TagNumber(2)
  void clearShort() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get skipped => $_getList(2);

  /// Links the consumption to what the patient was charged.
  @$pb.TagNumber(4)
  $core.String get chargeId => $_getSZ(3);
  @$pb.TagNumber(4)
  set chargeId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChargeId() => $_has(3);
  @$pb.TagNumber(4)
  void clearChargeId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<LiabilityEvent> get liabilities => $_getList(4);
}

class ReturnStockRequest extends $pb.GeneratedMessage {
  factory ReturnStockRequest({
    $core.String? itemId,
    $core.String? lotId,
    $core.String? fromLocation,
    $core.String? toLocation,
    $core.int? quantity,
    $core.String? costCentre,
    $core.String? reason,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (lotId != null) result.lotId = lotId;
    if (fromLocation != null) result.fromLocation = fromLocation;
    if (toLocation != null) result.toLocation = toLocation;
    if (quantity != null) result.quantity = quantity;
    if (costCentre != null) result.costCentre = costCentre;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReturnStockRequest._();

  factory ReturnStockRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReturnStockRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReturnStockRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'lotId')
    ..aOS(3, _omitFieldNames ? '' : 'fromLocation')
    ..aOS(4, _omitFieldNames ? '' : 'toLocation')
    ..aI(5, _omitFieldNames ? '' : 'quantity')
    ..aOS(6, _omitFieldNames ? '' : 'costCentre')
    ..aOS(7, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnStockRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnStockRequest copyWith(void Function(ReturnStockRequest) updates) =>
      super.copyWith((message) => updates(message as ReturnStockRequest))
          as ReturnStockRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReturnStockRequest create() => ReturnStockRequest._();
  @$core.override
  ReturnStockRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReturnStockRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReturnStockRequest>(create);
  static ReturnStockRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lotId => $_getSZ(1);
  @$pb.TagNumber(2)
  set lotId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLotId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLotId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fromLocation => $_getSZ(2);
  @$pb.TagNumber(3)
  set fromLocation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFromLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearFromLocation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get toLocation => $_getSZ(3);
  @$pb.TagNumber(4)
  set toLocation($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasToLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearToLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get quantity => $_getIZ(4);
  @$pb.TagNumber(5)
  set quantity($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasQuantity() => $_has(4);
  @$pb.TagNumber(5)
  void clearQuantity() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get costCentre => $_getSZ(5);
  @$pb.TagNumber(6)
  set costCentre($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCostCentre() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostCentre() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get reason => $_getSZ(6);
  @$pb.TagNumber(7)
  set reason($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearReason() => $_clearField(7);
}

class ReturnStockResponse extends $pb.GeneratedMessage {
  factory ReturnStockResponse({
    Movement? movement,
  }) {
    final result = create();
    if (movement != null) result.movement = movement;
    return result;
  }

  ReturnStockResponse._();

  factory ReturnStockResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReturnStockResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReturnStockResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Movement>(1, _omitFieldNames ? '' : 'movement',
        subBuilder: Movement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnStockResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReturnStockResponse copyWith(void Function(ReturnStockResponse) updates) =>
      super.copyWith((message) => updates(message as ReturnStockResponse))
          as ReturnStockResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReturnStockResponse create() => ReturnStockResponse._();
  @$core.override
  ReturnStockResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReturnStockResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReturnStockResponse>(create);
  static ReturnStockResponse? _defaultInstance;

  /// Into quarantine, not onto the shelf: stock that has been to a ward and
  /// back has been out of the store's control.
  @$pb.TagNumber(1)
  Movement get movement => $_getN(0);
  @$pb.TagNumber(1)
  set movement(Movement value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasMovement() => $_has(0);
  @$pb.TagNumber(1)
  void clearMovement() => $_clearField(1);
  @$pb.TagNumber(1)
  Movement ensureMovement() => $_ensure(0);
}

class ListBalancesRequest extends $pb.GeneratedMessage {
  factory ListBalancesRequest({
    $core.String? locationId,
    $core.String? itemId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (itemId != null) result.itemId = itemId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListBalancesRequest._();

  factory ListBalancesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBalancesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBalancesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aOS(2, _omitFieldNames ? '' : 'itemId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBalancesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBalancesRequest copyWith(void Function(ListBalancesRequest) updates) =>
      super.copyWith((message) => updates(message as ListBalancesRequest))
          as ListBalancesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBalancesRequest create() => ListBalancesRequest._();
  @$core.override
  ListBalancesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBalancesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBalancesRequest>(create);
  static ListBalancesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListBalancesResponse extends $pb.GeneratedMessage {
  factory ListBalancesResponse({
    $core.Iterable<Balance>? balances,
  }) {
    final result = create();
    if (balances != null) result.balances.addAll(balances);
    return result;
  }

  ListBalancesResponse._();

  factory ListBalancesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBalancesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBalancesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Balance>(1, _omitFieldNames ? '' : 'balances',
        subBuilder: Balance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBalancesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBalancesResponse copyWith(void Function(ListBalancesResponse) updates) =>
      super.copyWith((message) => updates(message as ListBalancesResponse))
          as ListBalancesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBalancesResponse create() => ListBalancesResponse._();
  @$core.override
  ListBalancesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBalancesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBalancesResponse>(create);
  static ListBalancesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Balance> get balances => $_getList(0);
}

class GetAvailableRequest extends $pb.GeneratedMessage {
  factory GetAvailableRequest({
    $core.String? itemId,
    $core.String? locationId,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    return result;
  }

  GetAvailableRequest._();

  factory GetAvailableRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAvailableRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAvailableRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAvailableRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAvailableRequest copyWith(void Function(GetAvailableRequest) updates) =>
      super.copyWith((message) => updates(message as GetAvailableRequest))
          as GetAvailableRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAvailableRequest create() => GetAvailableRequest._();
  @$core.override
  GetAvailableRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAvailableRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAvailableRequest>(create);
  static GetAvailableRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);
}

class GetAvailableResponse extends $pb.GeneratedMessage {
  factory GetAvailableResponse({
    $core.int? available,
  }) {
    final result = create();
    if (available != null) result.available = available;
    return result;
  }

  GetAvailableResponse._();

  factory GetAvailableResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAvailableResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAvailableResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'available')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAvailableResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAvailableResponse copyWith(void Function(GetAvailableResponse) updates) =>
      super.copyWith((message) => updates(message as GetAvailableResponse))
          as GetAvailableResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAvailableResponse create() => GetAvailableResponse._();
  @$core.override
  GetAvailableResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAvailableResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAvailableResponse>(create);
  static GetAvailableResponse? _defaultInstance;

  /// Available-to-promise: the status, the block and the expiry all have to
  /// pass, and each fails on its own.
  @$pb.TagNumber(1)
  $core.int get available => $_getIZ(0);
  @$pb.TagNumber(1)
  set available($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAvailable() => $_has(0);
  @$pb.TagNumber(1)
  void clearAvailable() => $_clearField(1);
}

class ListMovementsRequest extends $pb.GeneratedMessage {
  factory ListMovementsRequest({
    $core.String? itemId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? pageSize,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListMovementsRequest._();

  factory ListMovementsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMovementsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMovementsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMovementsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMovementsRequest copyWith(void Function(ListMovementsRequest) updates) =>
      super.copyWith((message) => updates(message as ListMovementsRequest))
          as ListMovementsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMovementsRequest create() => ListMovementsRequest._();
  @$core.override
  ListMovementsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMovementsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMovementsRequest>(create);
  static ListMovementsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodStart => $_getN(1);
  @$pb.TagNumber(2)
  set periodStart($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodStart() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodEnd => $_getN(2);
  @$pb.TagNumber(3)
  set periodEnd($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListMovementsResponse extends $pb.GeneratedMessage {
  factory ListMovementsResponse({
    $core.Iterable<Movement>? movements,
  }) {
    final result = create();
    if (movements != null) result.movements.addAll(movements);
    return result;
  }

  ListMovementsResponse._();

  factory ListMovementsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListMovementsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListMovementsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Movement>(1, _omitFieldNames ? '' : 'movements',
        subBuilder: Movement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMovementsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListMovementsResponse copyWith(
          void Function(ListMovementsResponse) updates) =>
      super.copyWith((message) => updates(message as ListMovementsResponse))
          as ListMovementsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListMovementsResponse create() => ListMovementsResponse._();
  @$core.override
  ListMovementsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListMovementsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListMovementsResponse>(create);
  static ListMovementsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Movement> get movements => $_getList(0);
}

class DispatchTransferRequest extends $pb.GeneratedMessage {
  factory DispatchTransferRequest({
    $core.String? number,
    $core.String? fromLocation,
    $core.String? toLocation,
    $core.Iterable<TransferLine>? lines,
    $core.String? reason,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (fromLocation != null) result.fromLocation = fromLocation;
    if (toLocation != null) result.toLocation = toLocation;
    if (lines != null) result.lines.addAll(lines);
    if (reason != null) result.reason = reason;
    return result;
  }

  DispatchTransferRequest._();

  factory DispatchTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchTransferRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'fromLocation')
    ..aOS(3, _omitFieldNames ? '' : 'toLocation')
    ..pPM<TransferLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: TransferLine.create)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTransferRequest copyWith(
          void Function(DispatchTransferRequest) updates) =>
      super.copyWith((message) => updates(message as DispatchTransferRequest))
          as DispatchTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchTransferRequest create() => DispatchTransferRequest._();
  @$core.override
  DispatchTransferRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchTransferRequest>(create);
  static DispatchTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fromLocation => $_getSZ(1);
  @$pb.TagNumber(2)
  set fromLocation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFromLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearFromLocation() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toLocation => $_getSZ(2);
  @$pb.TagNumber(3)
  set toLocation($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasToLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearToLocation() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<TransferLine> get lines => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class DispatchTransferResponse extends $pb.GeneratedMessage {
  factory DispatchTransferResponse({
    Transfer? transfer,
  }) {
    final result = create();
    if (transfer != null) result.transfer = transfer;
    return result;
  }

  DispatchTransferResponse._();

  factory DispatchTransferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DispatchTransferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DispatchTransferResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Transfer>(1, _omitFieldNames ? '' : 'transfer',
        subBuilder: Transfer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTransferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DispatchTransferResponse copyWith(
          void Function(DispatchTransferResponse) updates) =>
      super.copyWith((message) => updates(message as DispatchTransferResponse))
          as DispatchTransferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DispatchTransferResponse create() => DispatchTransferResponse._();
  @$core.override
  DispatchTransferResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DispatchTransferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DispatchTransferResponse>(create);
  static DispatchTransferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfer get transfer => $_getN(0);
  @$pb.TagNumber(1)
  set transfer(Transfer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfer() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfer() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfer ensureTransfer() => $_ensure(0);
}

class ReceiveTransferRequest extends $pb.GeneratedMessage {
  factory ReceiveTransferRequest({
    $core.String? transferId,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? counted,
  }) {
    final result = create();
    if (transferId != null) result.transferId = transferId;
    if (counted != null) result.counted.addEntries(counted);
    return result;
  }

  ReceiveTransferRequest._();

  factory ReceiveTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveTransferRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transferId')
    ..m<$core.String, $core.int>(2, _omitFieldNames ? '' : 'counted',
        entryClassName: 'ReceiveTransferRequest.CountedEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.materials.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveTransferRequest copyWith(
          void Function(ReceiveTransferRequest) updates) =>
      super.copyWith((message) => updates(message as ReceiveTransferRequest))
          as ReceiveTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveTransferRequest create() => ReceiveTransferRequest._();
  @$core.override
  ReceiveTransferRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveTransferRequest>(create);
  static ReceiveTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transferId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transferId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransferId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransferId() => $_clearField(1);

  /// What arrived, keyed by "itemID/lotID". A line left out means it all
  /// arrived: a count that has to be retyped line by line is a count nobody
  /// does, and assuming zero would write off a full pallet.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.int> get counted => $_getMap(1);
}

class ReceiveTransferResponse extends $pb.GeneratedMessage {
  factory ReceiveTransferResponse({
    Transfer? transfer,
    $core.Iterable<$core.String>? short,
  }) {
    final result = create();
    if (transfer != null) result.transfer = transfer;
    if (short != null) result.short.addAll(short);
    return result;
  }

  ReceiveTransferResponse._();

  factory ReceiveTransferResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceiveTransferResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceiveTransferResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Transfer>(1, _omitFieldNames ? '' : 'transfer',
        subBuilder: Transfer.create)
    ..pPS(2, _omitFieldNames ? '' : 'short')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveTransferResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceiveTransferResponse copyWith(
          void Function(ReceiveTransferResponse) updates) =>
      super.copyWith((message) => updates(message as ReceiveTransferResponse))
          as ReceiveTransferResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceiveTransferResponse create() => ReceiveTransferResponse._();
  @$core.override
  ReceiveTransferResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceiveTransferResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiveTransferResponse>(create);
  static ReceiveTransferResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfer get transfer => $_getN(0);
  @$pb.TagNumber(1)
  set transfer(Transfer value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfer() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfer() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfer ensureTransfer() => $_ensure(0);

  /// What did not arrive. The missing quantity stays in transit rather than
  /// vanishing from both stores.
  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get short => $_getList(1);
}

class ListTransfersInTransitRequest extends $pb.GeneratedMessage {
  factory ListTransfersInTransitRequest({
    $core.String? toLocation,
    $core.int? pageSize,
  }) {
    final result = create();
    if (toLocation != null) result.toLocation = toLocation;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListTransfersInTransitRequest._();

  factory ListTransfersInTransitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTransfersInTransitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransfersInTransitRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toLocation')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersInTransitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersInTransitRequest copyWith(
          void Function(ListTransfersInTransitRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListTransfersInTransitRequest))
          as ListTransfersInTransitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransfersInTransitRequest create() =>
      ListTransfersInTransitRequest._();
  @$core.override
  ListTransfersInTransitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTransfersInTransitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransfersInTransitRequest>(create);
  static ListTransfersInTransitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toLocation => $_getSZ(0);
  @$pb.TagNumber(1)
  set toLocation($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasToLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearToLocation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListTransfersInTransitResponse extends $pb.GeneratedMessage {
  factory ListTransfersInTransitResponse({
    $core.Iterable<Transfer>? transfers,
  }) {
    final result = create();
    if (transfers != null) result.transfers.addAll(transfers);
    return result;
  }

  ListTransfersInTransitResponse._();

  factory ListTransfersInTransitResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTransfersInTransitResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransfersInTransitResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Transfer>(1, _omitFieldNames ? '' : 'transfers',
        subBuilder: Transfer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersInTransitResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersInTransitResponse copyWith(
          void Function(ListTransfersInTransitResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListTransfersInTransitResponse))
          as ListTransfersInTransitResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransfersInTransitResponse create() =>
      ListTransfersInTransitResponse._();
  @$core.override
  ListTransfersInTransitResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTransfersInTransitResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransfersInTransitResponse>(create);
  static ListTransfersInTransitResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Transfer> get transfers => $_getList(0);
}

class OpenCountRequest extends $pb.GeneratedMessage {
  factory OpenCountRequest({
    $core.String? number,
    $core.String? locationId,
    $core.bool? cycle,
    $core.Iterable<$core.String>? itemIds,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (locationId != null) result.locationId = locationId;
    if (cycle != null) result.cycle = cycle;
    if (itemIds != null) result.itemIds.addAll(itemIds);
    return result;
  }

  OpenCountRequest._();

  factory OpenCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOB(3, _omitFieldNames ? '' : 'cycle')
    ..pPS(4, _omitFieldNames ? '' : 'itemIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCountRequest copyWith(void Function(OpenCountRequest) updates) =>
      super.copyWith((message) => updates(message as OpenCountRequest))
          as OpenCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCountRequest create() => OpenCountRequest._();
  @$core.override
  OpenCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCountRequest>(create);
  static OpenCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get cycle => $_getBF(2);
  @$pb.TagNumber(3)
  set cycle($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCycle() => $_has(2);
  @$pb.TagNumber(3)
  void clearCycle() => $_clearField(3);

  /// Empty counts everything at the location.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get itemIds => $_getList(3);
}

class OpenCountResponse extends $pb.GeneratedMessage {
  factory OpenCountResponse({
    Count? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  OpenCountResponse._();

  factory OpenCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Count>(1, _omitFieldNames ? '' : 'count', subBuilder: Count.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenCountResponse copyWith(void Function(OpenCountResponse) updates) =>
      super.copyWith((message) => updates(message as OpenCountResponse))
          as OpenCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenCountResponse create() => OpenCountResponse._();
  @$core.override
  OpenCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenCountResponse>(create);
  static OpenCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Count get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(Count value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  Count ensureCount() => $_ensure(0);
}

class RecordCountRequest extends $pb.GeneratedMessage {
  factory RecordCountRequest({
    $core.String? countId,
    $core.Iterable<CountLine>? lines,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  RecordCountRequest._();

  factory RecordCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..pPM<CountLine>(2, _omitFieldNames ? '' : 'lines',
        subBuilder: CountLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCountRequest copyWith(void Function(RecordCountRequest) updates) =>
      super.copyWith((message) => updates(message as RecordCountRequest))
          as RecordCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCountRequest create() => RecordCountRequest._();
  @$core.override
  RecordCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCountRequest>(create);
  static RecordCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<CountLine> get lines => $_getList(1);
}

class RecordCountResponse extends $pb.GeneratedMessage {
  factory RecordCountResponse({
    Count? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  RecordCountResponse._();

  factory RecordCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Count>(1, _omitFieldNames ? '' : 'count', subBuilder: Count.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordCountResponse copyWith(void Function(RecordCountResponse) updates) =>
      super.copyWith((message) => updates(message as RecordCountResponse))
          as RecordCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordCountResponse create() => RecordCountResponse._();
  @$core.override
  RecordCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordCountResponse>(create);
  static RecordCountResponse? _defaultInstance;

  /// The expected quantities come from the count as opened, never from the
  /// caller: a client sending its own expectation could make any variance
  /// disappear.
  @$pb.TagNumber(1)
  Count get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(Count value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  Count ensureCount() => $_ensure(0);
}

class ApproveCountRequest extends $pb.GeneratedMessage {
  factory ApproveCountRequest({
    $core.String? countId,
    $core.String? note,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    if (note != null) result.note = note;
    return result;
  }

  ApproveCountRequest._();

  factory ApproveCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCountRequest copyWith(void Function(ApproveCountRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveCountRequest))
          as ApproveCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveCountRequest create() => ApproveCountRequest._();
  @$core.override
  ApproveCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCountRequest>(create);
  static ApproveCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class ApproveCountResponse extends $pb.GeneratedMessage {
  factory ApproveCountResponse({
    Count? count,
    $core.Iterable<Movement>? adjustments,
  }) {
    final result = create();
    if (count != null) result.count = count;
    if (adjustments != null) result.adjustments.addAll(adjustments);
    return result;
  }

  ApproveCountResponse._();

  factory ApproveCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Count>(1, _omitFieldNames ? '' : 'count', subBuilder: Count.create)
    ..pPM<Movement>(2, _omitFieldNames ? '' : 'adjustments',
        subBuilder: Movement.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveCountResponse copyWith(void Function(ApproveCountResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveCountResponse))
          as ApproveCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveCountResponse create() => ApproveCountResponse._();
  @$core.override
  ApproveCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveCountResponse>(create);
  static ApproveCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Count get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(Count value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  Count ensureCount() => $_ensure(0);

  /// The adjustments posted, in the same transaction as the approval.
  @$pb.TagNumber(2)
  $pb.PbList<Movement> get adjustments => $_getList(1);
}

class RejectCountRequest extends $pb.GeneratedMessage {
  factory RejectCountRequest({
    $core.String? countId,
    $core.String? note,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    if (note != null) result.note = note;
    return result;
  }

  RejectCountRequest._();

  factory RejectCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCountRequest copyWith(void Function(RejectCountRequest) updates) =>
      super.copyWith((message) => updates(message as RejectCountRequest))
          as RejectCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectCountRequest create() => RejectCountRequest._();
  @$core.override
  RejectCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectCountRequest>(create);
  static RejectCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class RejectCountResponse extends $pb.GeneratedMessage {
  factory RejectCountResponse({
    Count? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  RejectCountResponse._();

  factory RejectCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Count>(1, _omitFieldNames ? '' : 'count', subBuilder: Count.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectCountResponse copyWith(void Function(RejectCountResponse) updates) =>
      super.copyWith((message) => updates(message as RejectCountResponse))
          as RejectCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectCountResponse create() => RejectCountResponse._();
  @$core.override
  RejectCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectCountResponse>(create);
  static RejectCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Count get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(Count value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  Count ensureCount() => $_ensure(0);
}

class GetCountRequest extends $pb.GeneratedMessage {
  factory GetCountRequest({
    $core.String? countId,
  }) {
    final result = create();
    if (countId != null) result.countId = countId;
    return result;
  }

  GetCountRequest._();

  factory GetCountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'countId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCountRequest copyWith(void Function(GetCountRequest) updates) =>
      super.copyWith((message) => updates(message as GetCountRequest))
          as GetCountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCountRequest create() => GetCountRequest._();
  @$core.override
  GetCountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCountRequest>(create);
  static GetCountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get countId => $_getSZ(0);
  @$pb.TagNumber(1)
  set countId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountId() => $_clearField(1);
}

class GetCountResponse extends $pb.GeneratedMessage {
  factory GetCountResponse({
    Count? count,
  }) {
    final result = create();
    if (count != null) result.count = count;
    return result;
  }

  GetCountResponse._();

  factory GetCountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetCountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetCountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Count>(1, _omitFieldNames ? '' : 'count', subBuilder: Count.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetCountResponse copyWith(void Function(GetCountResponse) updates) =>
      super.copyWith((message) => updates(message as GetCountResponse))
          as GetCountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetCountResponse create() => GetCountResponse._();
  @$core.override
  GetCountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetCountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetCountResponse>(create);
  static GetCountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Count get count => $_getN(0);
  @$pb.TagNumber(1)
  set count(Count value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => $_clearField(1);
  @$pb.TagNumber(1)
  Count ensureCount() => $_ensure(0);
}

class ListCountsRequest extends $pb.GeneratedMessage {
  factory ListCountsRequest({
    $core.String? state,
    $core.int? pageSize,
  }) {
    final result = create();
    if (state != null) result.state = state;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListCountsRequest._();

  factory ListCountsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCountsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCountsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'state')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCountsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCountsRequest copyWith(void Function(ListCountsRequest) updates) =>
      super.copyWith((message) => updates(message as ListCountsRequest))
          as ListCountsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCountsRequest create() => ListCountsRequest._();
  @$core.override
  ListCountsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCountsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCountsRequest>(create);
  static ListCountsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get state => $_getSZ(0);
  @$pb.TagNumber(1)
  set state($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasState() => $_has(0);
  @$pb.TagNumber(1)
  void clearState() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListCountsResponse extends $pb.GeneratedMessage {
  factory ListCountsResponse({
    $core.Iterable<Count>? counts,
  }) {
    final result = create();
    if (counts != null) result.counts.addAll(counts);
    return result;
  }

  ListCountsResponse._();

  factory ListCountsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCountsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCountsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Count>(1, _omitFieldNames ? '' : 'counts', subBuilder: Count.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCountsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCountsResponse copyWith(void Function(ListCountsResponse) updates) =>
      super.copyWith((message) => updates(message as ListCountsResponse))
          as ListCountsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCountsResponse create() => ListCountsResponse._();
  @$core.override
  ListCountsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCountsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCountsResponse>(create);
  static ListCountsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Count> get counts => $_getList(0);
}

class BlockLotRequest extends $pb.GeneratedMessage {
  factory BlockLotRequest({
    $core.String? lotId,
    $core.String? reason,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (reason != null) result.reason = reason;
    return result;
  }

  BlockLotRequest._();

  factory BlockLotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockLotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockLotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockLotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockLotRequest copyWith(void Function(BlockLotRequest) updates) =>
      super.copyWith((message) => updates(message as BlockLotRequest))
          as BlockLotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockLotRequest create() => BlockLotRequest._();
  @$core.override
  BlockLotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockLotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockLotRequest>(create);
  static BlockLotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class BlockLotResponse extends $pb.GeneratedMessage {
  factory BlockLotResponse({
    Lot? lot,
    RecallList? recall,
  }) {
    final result = create();
    if (lot != null) result.lot = lot;
    if (recall != null) result.recall = recall;
    return result;
  }

  BlockLotResponse._();

  factory BlockLotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BlockLotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BlockLotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Lot>(1, _omitFieldNames ? '' : 'lot', subBuilder: Lot.create)
    ..aOM<RecallList>(2, _omitFieldNames ? '' : 'recall',
        subBuilder: RecallList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockLotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BlockLotResponse copyWith(void Function(BlockLotResponse) updates) =>
      super.copyWith((message) => updates(message as BlockLotResponse))
          as BlockLotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockLotResponse create() => BlockLotResponse._();
  @$core.override
  BlockLotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BlockLotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BlockLotResponse>(create);
  static BlockLotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Lot get lot => $_getN(0);
  @$pb.TagNumber(1)
  set lot(Lot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLot() => $_has(0);
  @$pb.TagNumber(1)
  void clearLot() => $_clearField(1);
  @$pb.TagNumber(1)
  Lot ensureLot() => $_ensure(0);

  @$pb.TagNumber(2)
  RecallList get recall => $_getN(1);
  @$pb.TagNumber(2)
  set recall(RecallList value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecall() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecall() => $_clearField(2);
  @$pb.TagNumber(2)
  RecallList ensureRecall() => $_ensure(1);
}

class ReleaseLotRequest extends $pb.GeneratedMessage {
  factory ReleaseLotRequest({
    $core.String? lotId,
    $core.String? note,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    if (note != null) result.note = note;
    return result;
  }

  ReleaseLotRequest._();

  factory ReleaseLotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseLotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseLotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..aOS(2, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLotRequest copyWith(void Function(ReleaseLotRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseLotRequest))
          as ReleaseLotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseLotRequest create() => ReleaseLotRequest._();
  @$core.override
  ReleaseLotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseLotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseLotRequest>(create);
  static ReleaseLotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get note => $_getSZ(1);
  @$pb.TagNumber(2)
  set note($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNote() => $_has(1);
  @$pb.TagNumber(2)
  void clearNote() => $_clearField(2);
}

class ReleaseLotResponse extends $pb.GeneratedMessage {
  factory ReleaseLotResponse({
    Lot? lot,
  }) {
    final result = create();
    if (lot != null) result.lot = lot;
    return result;
  }

  ReleaseLotResponse._();

  factory ReleaseLotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseLotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseLotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Lot>(1, _omitFieldNames ? '' : 'lot', subBuilder: Lot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseLotResponse copyWith(void Function(ReleaseLotResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseLotResponse))
          as ReleaseLotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseLotResponse create() => ReleaseLotResponse._();
  @$core.override
  ReleaseLotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseLotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseLotResponse>(create);
  static ReleaseLotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Lot get lot => $_getN(0);
  @$pb.TagNumber(1)
  set lot(Lot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLot() => $_has(0);
  @$pb.TagNumber(1)
  void clearLot() => $_clearField(1);
  @$pb.TagNumber(1)
  Lot ensureLot() => $_ensure(0);
}

class GetRecallListRequest extends $pb.GeneratedMessage {
  factory GetRecallListRequest({
    $core.String? lotId,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    return result;
  }

  GetRecallListRequest._();

  factory GetRecallListRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecallListRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecallListRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallListRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallListRequest copyWith(void Function(GetRecallListRequest) updates) =>
      super.copyWith((message) => updates(message as GetRecallListRequest))
          as GetRecallListRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecallListRequest create() => GetRecallListRequest._();
  @$core.override
  GetRecallListRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecallListRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecallListRequest>(create);
  static GetRecallListRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);
}

class GetRecallListResponse extends $pb.GeneratedMessage {
  factory GetRecallListResponse({
    RecallList? recall,
  }) {
    final result = create();
    if (recall != null) result.recall = recall;
    return result;
  }

  GetRecallListResponse._();

  factory GetRecallListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRecallListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRecallListResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<RecallList>(1, _omitFieldNames ? '' : 'recall',
        subBuilder: RecallList.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRecallListResponse copyWith(
          void Function(GetRecallListResponse) updates) =>
      super.copyWith((message) => updates(message as GetRecallListResponse))
          as GetRecallListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRecallListResponse create() => GetRecallListResponse._();
  @$core.override
  GetRecallListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRecallListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRecallListResponse>(create);
  static GetRecallListResponse? _defaultInstance;

  /// What the lot reaches, without blocking anything.
  @$pb.TagNumber(1)
  RecallList get recall => $_getN(0);
  @$pb.TagNumber(1)
  set recall(RecallList value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecall() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecall() => $_clearField(1);
  @$pb.TagNumber(1)
  RecallList ensureRecall() => $_ensure(0);
}

class ListBlockedLotsRequest extends $pb.GeneratedMessage {
  factory ListBlockedLotsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListBlockedLotsRequest._();

  factory ListBlockedLotsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockedLotsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockedLotsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockedLotsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockedLotsRequest copyWith(
          void Function(ListBlockedLotsRequest) updates) =>
      super.copyWith((message) => updates(message as ListBlockedLotsRequest))
          as ListBlockedLotsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockedLotsRequest create() => ListBlockedLotsRequest._();
  @$core.override
  ListBlockedLotsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockedLotsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockedLotsRequest>(create);
  static ListBlockedLotsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListBlockedLotsResponse extends $pb.GeneratedMessage {
  factory ListBlockedLotsResponse({
    $core.Iterable<Lot>? lots,
  }) {
    final result = create();
    if (lots != null) result.lots.addAll(lots);
    return result;
  }

  ListBlockedLotsResponse._();

  factory ListBlockedLotsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListBlockedLotsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListBlockedLotsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Lot>(1, _omitFieldNames ? '' : 'lots', subBuilder: Lot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockedLotsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListBlockedLotsResponse copyWith(
          void Function(ListBlockedLotsResponse) updates) =>
      super.copyWith((message) => updates(message as ListBlockedLotsResponse))
          as ListBlockedLotsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListBlockedLotsResponse create() => ListBlockedLotsResponse._();
  @$core.override
  ListBlockedLotsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListBlockedLotsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListBlockedLotsResponse>(create);
  static ListBlockedLotsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Lot> get lots => $_getList(0);
}

class GetLotRequest extends $pb.GeneratedMessage {
  factory GetLotRequest({
    $core.String? lotId,
  }) {
    final result = create();
    if (lotId != null) result.lotId = lotId;
    return result;
  }

  GetLotRequest._();

  factory GetLotRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLotRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLotRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'lotId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLotRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLotRequest copyWith(void Function(GetLotRequest) updates) =>
      super.copyWith((message) => updates(message as GetLotRequest))
          as GetLotRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLotRequest create() => GetLotRequest._();
  @$core.override
  GetLotRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLotRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLotRequest>(create);
  static GetLotRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get lotId => $_getSZ(0);
  @$pb.TagNumber(1)
  set lotId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLotId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLotId() => $_clearField(1);
}

class GetLotResponse extends $pb.GeneratedMessage {
  factory GetLotResponse({
    Lot? lot,
  }) {
    final result = create();
    if (lot != null) result.lot = lot;
    return result;
  }

  GetLotResponse._();

  factory GetLotResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetLotResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetLotResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Lot>(1, _omitFieldNames ? '' : 'lot', subBuilder: Lot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLotResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetLotResponse copyWith(void Function(GetLotResponse) updates) =>
      super.copyWith((message) => updates(message as GetLotResponse))
          as GetLotResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLotResponse create() => GetLotResponse._();
  @$core.override
  GetLotResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetLotResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetLotResponse>(create);
  static GetLotResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Lot get lot => $_getN(0);
  @$pb.TagNumber(1)
  set lot(Lot value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLot() => $_has(0);
  @$pb.TagNumber(1)
  void clearLot() => $_clearField(1);
  @$pb.TagNumber(1)
  Lot ensureLot() => $_ensure(0);
}

class ListLotsRequest extends $pb.GeneratedMessage {
  factory ListLotsRequest({
    $core.String? itemId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListLotsRequest._();

  factory ListLotsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLotsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLotsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLotsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLotsRequest copyWith(void Function(ListLotsRequest) updates) =>
      super.copyWith((message) => updates(message as ListLotsRequest))
          as ListLotsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLotsRequest create() => ListLotsRequest._();
  @$core.override
  ListLotsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLotsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLotsRequest>(create);
  static ListLotsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListLotsResponse extends $pb.GeneratedMessage {
  factory ListLotsResponse({
    $core.Iterable<Lot>? lots,
  }) {
    final result = create();
    if (lots != null) result.lots.addAll(lots);
    return result;
  }

  ListLotsResponse._();

  factory ListLotsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLotsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLotsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Lot>(1, _omitFieldNames ? '' : 'lots', subBuilder: Lot.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLotsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLotsResponse copyWith(void Function(ListLotsResponse) updates) =>
      super.copyWith((message) => updates(message as ListLotsResponse))
          as ListLotsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLotsResponse create() => ListLotsResponse._();
  @$core.override
  ListLotsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLotsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLotsResponse>(create);
  static ListLotsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Lot> get lots => $_getList(0);
}

class ListAlertsRequest extends $pb.GeneratedMessage {
  factory ListAlertsRequest({
    $core.String? locationId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAlertsRequest._();

  factory ListAlertsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlertsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlertsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsRequest copyWith(void Function(ListAlertsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAlertsRequest))
          as ListAlertsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlertsRequest create() => ListAlertsRequest._();
  @$core.override
  ListAlertsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlertsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlertsRequest>(create);
  static ListAlertsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListAlertsResponse extends $pb.GeneratedMessage {
  factory ListAlertsResponse({
    $core.Iterable<Alert>? alerts,
  }) {
    final result = create();
    if (alerts != null) result.alerts.addAll(alerts);
    return result;
  }

  ListAlertsResponse._();

  factory ListAlertsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAlertsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAlertsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<Alert>(1, _omitFieldNames ? '' : 'alerts', subBuilder: Alert.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAlertsResponse copyWith(void Function(ListAlertsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAlertsResponse))
          as ListAlertsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAlertsResponse create() => ListAlertsResponse._();
  @$core.override
  ListAlertsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAlertsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAlertsResponse>(create);
  static ListAlertsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Alert> get alerts => $_getList(0);
}

class SuggestOrderRequest extends $pb.GeneratedMessage {
  factory SuggestOrderRequest({
    $core.String? locationId,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    return result;
  }

  SuggestOrderRequest._();

  factory SuggestOrderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestOrderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestOrderRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestOrderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestOrderRequest copyWith(void Function(SuggestOrderRequest) updates) =>
      super.copyWith((message) => updates(message as SuggestOrderRequest))
          as SuggestOrderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestOrderRequest create() => SuggestOrderRequest._();
  @$core.override
  SuggestOrderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuggestOrderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestOrderRequest>(create);
  static SuggestOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);
}

class SuggestOrderResponse extends $pb.GeneratedMessage {
  factory SuggestOrderResponse({
    $core.String? locationId,
    $core.Iterable<SuggestedLine>? lines,
  }) {
    final result = create();
    if (locationId != null) result.locationId = locationId;
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  SuggestOrderResponse._();

  factory SuggestOrderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuggestOrderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuggestOrderResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'locationId')
    ..pPM<SuggestedLine>(2, _omitFieldNames ? '' : 'lines',
        subBuilder: SuggestedLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestOrderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuggestOrderResponse copyWith(void Function(SuggestOrderResponse) updates) =>
      super.copyWith((message) => updates(message as SuggestOrderResponse))
          as SuggestOrderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuggestOrderResponse create() => SuggestOrderResponse._();
  @$core.override
  SuggestOrderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuggestOrderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuggestOrderResponse>(create);
  static SuggestOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get locationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set locationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocationId() => $_clearField(1);

  /// Reviewable before it becomes a requisition: the system proposes, a person
  /// raises.
  @$pb.TagNumber(2)
  $pb.PbList<SuggestedLine> get lines => $_getList(1);
}

class RecordInvoiceRequest extends $pb.GeneratedMessage {
  factory RecordInvoiceRequest({
    $core.String? number,
    $core.String? supplierId,
    $core.String? purchaseOrderId,
    $core.Iterable<InvoiceLine>? lines,
    $core.String? currency,
  }) {
    final result = create();
    if (number != null) result.number = number;
    if (supplierId != null) result.supplierId = supplierId;
    if (purchaseOrderId != null) result.purchaseOrderId = purchaseOrderId;
    if (lines != null) result.lines.addAll(lines);
    if (currency != null) result.currency = currency;
    return result;
  }

  RecordInvoiceRequest._();

  factory RecordInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'number')
    ..aOS(2, _omitFieldNames ? '' : 'supplierId')
    ..aOS(3, _omitFieldNames ? '' : 'purchaseOrderId')
    ..pPM<InvoiceLine>(4, _omitFieldNames ? '' : 'lines',
        subBuilder: InvoiceLine.create)
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordInvoiceRequest copyWith(void Function(RecordInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as RecordInvoiceRequest))
          as RecordInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordInvoiceRequest create() => RecordInvoiceRequest._();
  @$core.override
  RecordInvoiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordInvoiceRequest>(create);
  static RecordInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get number => $_getSZ(0);
  @$pb.TagNumber(1)
  set number($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNumber() => $_has(0);
  @$pb.TagNumber(1)
  void clearNumber() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get supplierId => $_getSZ(1);
  @$pb.TagNumber(2)
  set supplierId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSupplierId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupplierId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get purchaseOrderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set purchaseOrderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPurchaseOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPurchaseOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<InvoiceLine> get lines => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);
}

class RecordInvoiceResponse extends $pb.GeneratedMessage {
  factory RecordInvoiceResponse({
    Invoice? invoice,
  }) {
    final result = create();
    if (invoice != null) result.invoice = invoice;
    return result;
  }

  RecordInvoiceResponse._();

  factory RecordInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Invoice>(1, _omitFieldNames ? '' : 'invoice',
        subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordInvoiceResponse copyWith(
          void Function(RecordInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as RecordInvoiceResponse))
          as RecordInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordInvoiceResponse create() => RecordInvoiceResponse._();
  @$core.override
  RecordInvoiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordInvoiceResponse>(create);
  static RecordInvoiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Invoice get invoice => $_getN(0);
  @$pb.TagNumber(1)
  set invoice(Invoice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoice() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoice() => $_clearField(1);
  @$pb.TagNumber(1)
  Invoice ensureInvoice() => $_ensure(0);
}

class MatchInvoiceRequest extends $pb.GeneratedMessage {
  factory MatchInvoiceRequest({
    $core.String? invoiceId,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    return result;
  }

  MatchInvoiceRequest._();

  factory MatchInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchInvoiceRequest copyWith(void Function(MatchInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as MatchInvoiceRequest))
          as MatchInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchInvoiceRequest create() => MatchInvoiceRequest._();
  @$core.override
  MatchInvoiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchInvoiceRequest>(create);
  static MatchInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoiceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoiceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);
}

class MatchInvoiceResponse extends $pb.GeneratedMessage {
  factory MatchInvoiceResponse({
    MatchResult? result,
  }) {
    final result$ = create();
    if (result != null) result$.result = result;
    return result$;
  }

  MatchInvoiceResponse._();

  factory MatchInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MatchInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MatchInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<MatchResult>(1, _omitFieldNames ? '' : 'result',
        subBuilder: MatchResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MatchInvoiceResponse copyWith(void Function(MatchInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as MatchInvoiceResponse))
          as MatchInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MatchInvoiceResponse create() => MatchInvoiceResponse._();
  @$core.override
  MatchInvoiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MatchInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MatchInvoiceResponse>(create);
  static MatchInvoiceResponse? _defaultInstance;

  /// Surfaces mismatches; it does not resolve them. The resolution is a human
  /// negotiation, and a system that picked one of the three numbers would pay
  /// the wrong one.
  @$pb.TagNumber(1)
  MatchResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(MatchResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => $_clearField(1);
  @$pb.TagNumber(1)
  MatchResult ensureResult() => $_ensure(0);
}

class GetMetricsRequest extends $pb.GeneratedMessage {
  factory GetMetricsRequest({
    $core.String? itemId,
    $core.String? locationId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
  }) {
    final result = create();
    if (itemId != null) result.itemId = itemId;
    if (locationId != null) result.locationId = locationId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  GetMetricsRequest._();

  factory GetMetricsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMetricsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMetricsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'itemId')
    ..aOS(2, _omitFieldNames ? '' : 'locationId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMetricsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMetricsRequest copyWith(void Function(GetMetricsRequest) updates) =>
      super.copyWith((message) => updates(message as GetMetricsRequest))
          as GetMetricsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMetricsRequest create() => GetMetricsRequest._();
  @$core.override
  GetMetricsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMetricsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMetricsRequest>(create);
  static GetMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get locationId => $_getSZ(1);
  @$pb.TagNumber(2)
  set locationId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocationId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocationId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get periodStart => $_getN(2);
  @$pb.TagNumber(3)
  set periodStart($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get periodEnd => $_getN(3);
  @$pb.TagNumber(4)
  set periodEnd($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPeriodEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeriodEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensurePeriodEnd() => $_ensure(3);
}

class GetMetricsResponse extends $pb.GeneratedMessage {
  factory GetMetricsResponse({
    Metrics? metrics,
  }) {
    final result = create();
    if (metrics != null) result.metrics = metrics;
    return result;
  }

  GetMetricsResponse._();

  factory GetMetricsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMetricsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMetricsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<Metrics>(1, _omitFieldNames ? '' : 'metrics',
        subBuilder: Metrics.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMetricsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMetricsResponse copyWith(void Function(GetMetricsResponse) updates) =>
      super.copyWith((message) => updates(message as GetMetricsResponse))
          as GetMetricsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMetricsResponse create() => GetMetricsResponse._();
  @$core.override
  GetMetricsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMetricsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMetricsResponse>(create);
  static GetMetricsResponse? _defaultInstance;

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

class GetFillRateRequest extends $pb.GeneratedMessage {
  factory GetFillRateRequest({
    $core.String? supplierId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    return result;
  }

  GetFillRateRequest._();

  factory GetFillRateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFillRateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFillRateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFillRateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFillRateRequest copyWith(void Function(GetFillRateRequest) updates) =>
      super.copyWith((message) => updates(message as GetFillRateRequest))
          as GetFillRateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFillRateRequest create() => GetFillRateRequest._();
  @$core.override
  GetFillRateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFillRateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFillRateRequest>(create);
  static GetFillRateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodStart => $_getN(1);
  @$pb.TagNumber(2)
  set periodStart($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodStart() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodEnd => $_getN(2);
  @$pb.TagNumber(3)
  set periodEnd($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodEnd() => $_ensure(2);
}

class GetFillRateResponse extends $pb.GeneratedMessage {
  factory GetFillRateResponse({
    SupplierFillRate? fillRate,
  }) {
    final result = create();
    if (fillRate != null) result.fillRate = fillRate;
    return result;
  }

  GetFillRateResponse._();

  factory GetFillRateResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFillRateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFillRateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOM<SupplierFillRate>(1, _omitFieldNames ? '' : 'fillRate',
        subBuilder: SupplierFillRate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFillRateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFillRateResponse copyWith(void Function(GetFillRateResponse) updates) =>
      super.copyWith((message) => updates(message as GetFillRateResponse))
          as GetFillRateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFillRateResponse create() => GetFillRateResponse._();
  @$core.override
  GetFillRateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFillRateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFillRateResponse>(create);
  static GetFillRateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SupplierFillRate get fillRate => $_getN(0);
  @$pb.TagNumber(1)
  set fillRate(SupplierFillRate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFillRate() => $_has(0);
  @$pb.TagNumber(1)
  void clearFillRate() => $_clearField(1);
  @$pb.TagNumber(1)
  SupplierFillRate ensureFillRate() => $_ensure(0);
}

class ListLiabilitiesRequest extends $pb.GeneratedMessage {
  factory ListLiabilitiesRequest({
    $core.String? supplierId,
    $0.Timestamp? periodStart,
    $0.Timestamp? periodEnd,
    $core.int? pageSize,
  }) {
    final result = create();
    if (supplierId != null) result.supplierId = supplierId;
    if (periodStart != null) result.periodStart = periodStart;
    if (periodEnd != null) result.periodEnd = periodEnd;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListLiabilitiesRequest._();

  factory ListLiabilitiesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLiabilitiesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLiabilitiesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'supplierId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'periodStart',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'periodEnd',
        subBuilder: $0.Timestamp.create)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiabilitiesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiabilitiesRequest copyWith(
          void Function(ListLiabilitiesRequest) updates) =>
      super.copyWith((message) => updates(message as ListLiabilitiesRequest))
          as ListLiabilitiesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLiabilitiesRequest create() => ListLiabilitiesRequest._();
  @$core.override
  ListLiabilitiesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLiabilitiesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLiabilitiesRequest>(create);
  static ListLiabilitiesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get supplierId => $_getSZ(0);
  @$pb.TagNumber(1)
  set supplierId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSupplierId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSupplierId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get periodStart => $_getN(1);
  @$pb.TagNumber(2)
  set periodStart($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeriodStart() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeriodStart() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensurePeriodStart() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get periodEnd => $_getN(2);
  @$pb.TagNumber(3)
  set periodEnd($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPeriodEnd() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeriodEnd() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensurePeriodEnd() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListLiabilitiesResponse extends $pb.GeneratedMessage {
  factory ListLiabilitiesResponse({
    $core.Iterable<LiabilityEvent>? liabilities,
  }) {
    final result = create();
    if (liabilities != null) result.liabilities.addAll(liabilities);
    return result;
  }

  ListLiabilitiesResponse._();

  factory ListLiabilitiesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListLiabilitiesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListLiabilitiesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.materials.v1'),
      createEmptyInstance: create)
    ..pPM<LiabilityEvent>(1, _omitFieldNames ? '' : 'liabilities',
        subBuilder: LiabilityEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiabilitiesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListLiabilitiesResponse copyWith(
          void Function(ListLiabilitiesResponse) updates) =>
      super.copyWith((message) => updates(message as ListLiabilitiesResponse))
          as ListLiabilitiesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLiabilitiesResponse create() => ListLiabilitiesResponse._();
  @$core.override
  ListLiabilitiesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListLiabilitiesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListLiabilitiesResponse>(create);
  static ListLiabilitiesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LiabilityEvent> get liabilities => $_getList(0);
}

/// Materials, procurement and inventory (SRS-MAT-001 … 016).
class MaterialsServiceApi {
  final $pb.RpcClient _client;

  MaterialsServiceApi(this._client);

  /// SRS-MAT-001, SRS-MAT-003, SRS-MAT-012: the masters.
  $async.Future<AddItemResponse> addItem(
          $pb.ClientContext? ctx, AddItemRequest request) =>
      _client.invoke<AddItemResponse>(
          ctx, 'MaterialsService', 'AddItem', request, AddItemResponse());
  $async.Future<ReconfigureItemResponse> reconfigureItem(
          $pb.ClientContext? ctx, ReconfigureItemRequest request) =>
      _client.invoke<ReconfigureItemResponse>(ctx, 'MaterialsService',
          'ReconfigureItem', request, ReconfigureItemResponse());
  $async.Future<GetItemResponse> getItem(
          $pb.ClientContext? ctx, GetItemRequest request) =>
      _client.invoke<GetItemResponse>(
          ctx, 'MaterialsService', 'GetItem', request, GetItemResponse());
  $async.Future<ListItemsResponse> listItems(
          $pb.ClientContext? ctx, ListItemsRequest request) =>
      _client.invoke<ListItemsResponse>(
          ctx, 'MaterialsService', 'ListItems', request, ListItemsResponse());
  $async.Future<AddSupplierResponse> addSupplier(
          $pb.ClientContext? ctx, AddSupplierRequest request) =>
      _client.invoke<AddSupplierResponse>(ctx, 'MaterialsService',
          'AddSupplier', request, AddSupplierResponse());
  $async.Future<SetSupplierApprovalResponse> setSupplierApproval(
          $pb.ClientContext? ctx, SetSupplierApprovalRequest request) =>
      _client.invoke<SetSupplierApprovalResponse>(ctx, 'MaterialsService',
          'SetSupplierApproval', request, SetSupplierApprovalResponse());
  $async.Future<ListSuppliersResponse> listSuppliers(
          $pb.ClientContext? ctx, ListSuppliersRequest request) =>
      _client.invoke<ListSuppliersResponse>(ctx, 'MaterialsService',
          'ListSuppliers', request, ListSuppliersResponse());
  $async.Future<SetStockLevelResponse> setStockLevel(
          $pb.ClientContext? ctx, SetStockLevelRequest request) =>
      _client.invoke<SetStockLevelResponse>(ctx, 'MaterialsService',
          'SetStockLevel', request, SetStockLevelResponse());
  $async.Future<ListStockLevelsResponse> listStockLevels(
          $pb.ClientContext? ctx, ListStockLevelsRequest request) =>
      _client.invoke<ListStockLevelsResponse>(ctx, 'MaterialsService',
          'ListStockLevels', request, ListStockLevelsResponse());
  $async.Future<AddApprovalRuleResponse> addApprovalRule(
          $pb.ClientContext? ctx, AddApprovalRuleRequest request) =>
      _client.invoke<AddApprovalRuleResponse>(ctx, 'MaterialsService',
          'AddApprovalRule', request, AddApprovalRuleResponse());
  $async.Future<ListApprovalRulesResponse> listApprovalRules(
          $pb.ClientContext? ctx, ListApprovalRulesRequest request) =>
      _client.invoke<ListApprovalRulesResponse>(ctx, 'MaterialsService',
          'ListApprovalRules', request, ListApprovalRulesResponse());
  $async.Future<RemoveApprovalRuleResponse> removeApprovalRule(
          $pb.ClientContext? ctx, RemoveApprovalRuleRequest request) =>
      _client.invoke<RemoveApprovalRuleResponse>(ctx, 'MaterialsService',
          'RemoveApprovalRule', request, RemoveApprovalRuleResponse());

  /// SRS-MAT-001, SRS-MAT-002: requisition and its immutable approval chain.
  $async.Future<RaiseRequisitionResponse> raiseRequisition(
          $pb.ClientContext? ctx, RaiseRequisitionRequest request) =>
      _client.invoke<RaiseRequisitionResponse>(ctx, 'MaterialsService',
          'RaiseRequisition', request, RaiseRequisitionResponse());
  $async.Future<GetApprovalRouteResponse> getApprovalRoute(
          $pb.ClientContext? ctx, GetApprovalRouteRequest request) =>
      _client.invoke<GetApprovalRouteResponse>(ctx, 'MaterialsService',
          'GetApprovalRoute', request, GetApprovalRouteResponse());
  $async.Future<SubmitRequisitionResponse> submitRequisition(
          $pb.ClientContext? ctx, SubmitRequisitionRequest request) =>
      _client.invoke<SubmitRequisitionResponse>(ctx, 'MaterialsService',
          'SubmitRequisition', request, SubmitRequisitionResponse());
  $async.Future<DecideRequisitionResponse> decideRequisition(
          $pb.ClientContext? ctx, DecideRequisitionRequest request) =>
      _client.invoke<DecideRequisitionResponse>(ctx, 'MaterialsService',
          'DecideRequisition', request, DecideRequisitionResponse());
  $async.Future<GetRequisitionResponse> getRequisition(
          $pb.ClientContext? ctx, GetRequisitionRequest request) =>
      _client.invoke<GetRequisitionResponse>(ctx, 'MaterialsService',
          'GetRequisition', request, GetRequisitionResponse());
  $async.Future<ListRequisitionsResponse> listRequisitions(
          $pb.ClientContext? ctx, ListRequisitionsRequest request) =>
      _client.invoke<ListRequisitionsResponse>(ctx, 'MaterialsService',
          'ListRequisitions', request, ListRequisitionsResponse());

  /// SRS-MAT-003, SRS-MAT-004: quotation, comparison and the order.
  $async.Future<OpenRfqResponse> openRfq(
          $pb.ClientContext? ctx, OpenRfqRequest request) =>
      _client.invoke<OpenRfqResponse>(
          ctx, 'MaterialsService', 'OpenRfq', request, OpenRfqResponse());
  $async.Future<RecordBidResponse> recordBid(
          $pb.ClientContext? ctx, RecordBidRequest request) =>
      _client.invoke<RecordBidResponse>(
          ctx, 'MaterialsService', 'RecordBid', request, RecordBidResponse());
  $async.Future<CompareBidsResponse> compareBids(
          $pb.ClientContext? ctx, CompareBidsRequest request) =>
      _client.invoke<CompareBidsResponse>(ctx, 'MaterialsService',
          'CompareBids', request, CompareBidsResponse());
  $async.Future<GetRfqResponse> getRfq(
          $pb.ClientContext? ctx, GetRfqRequest request) =>
      _client.invoke<GetRfqResponse>(
          ctx, 'MaterialsService', 'GetRfq', request, GetRfqResponse());
  $async.Future<ListRfqsResponse> listRfqs(
          $pb.ClientContext? ctx, ListRfqsRequest request) =>
      _client.invoke<ListRfqsResponse>(
          ctx, 'MaterialsService', 'ListRfqs', request, ListRfqsResponse());
  $async.Future<PlaceOrderResponse> placeOrder(
          $pb.ClientContext? ctx, PlaceOrderRequest request) =>
      _client.invoke<PlaceOrderResponse>(
          ctx, 'MaterialsService', 'PlaceOrder', request, PlaceOrderResponse());
  $async.Future<IssueOrderResponse> issueOrder(
          $pb.ClientContext? ctx, IssueOrderRequest request) =>
      _client.invoke<IssueOrderResponse>(
          ctx, 'MaterialsService', 'IssueOrder', request, IssueOrderResponse());
  $async.Future<AmendOrderResponse> amendOrder(
          $pb.ClientContext? ctx, AmendOrderRequest request) =>
      _client.invoke<AmendOrderResponse>(
          ctx, 'MaterialsService', 'AmendOrder', request, AmendOrderResponse());
  $async.Future<GetPurchaseOrderResponse> getPurchaseOrder(
          $pb.ClientContext? ctx, GetPurchaseOrderRequest request) =>
      _client.invoke<GetPurchaseOrderResponse>(ctx, 'MaterialsService',
          'GetPurchaseOrder', request, GetPurchaseOrderResponse());
  $async.Future<ListOrderRevisionsResponse> listOrderRevisions(
          $pb.ClientContext? ctx, ListOrderRevisionsRequest request) =>
      _client.invoke<ListOrderRevisionsResponse>(ctx, 'MaterialsService',
          'ListOrderRevisions', request, ListOrderRevisionsResponse());
  $async.Future<ListPurchaseOrdersResponse> listPurchaseOrders(
          $pb.ClientContext? ctx, ListPurchaseOrdersRequest request) =>
      _client.invoke<ListPurchaseOrdersResponse>(ctx, 'MaterialsService',
          'ListPurchaseOrders', request, ListPurchaseOrdersResponse());

  /// SRS-MAT-005, SRS-MAT-006: receipt and inspection.
  $async.Future<ReceiveGoodsResponse> receiveGoods(
          $pb.ClientContext? ctx, ReceiveGoodsRequest request) =>
      _client.invoke<ReceiveGoodsResponse>(ctx, 'MaterialsService',
          'ReceiveGoods', request, ReceiveGoodsResponse());
  $async.Future<InspectResponse> inspect(
          $pb.ClientContext? ctx, InspectRequest request) =>
      _client.invoke<InspectResponse>(
          ctx, 'MaterialsService', 'Inspect', request, InspectResponse());
  $async.Future<GetReceiptResponse> getReceipt(
          $pb.ClientContext? ctx, GetReceiptRequest request) =>
      _client.invoke<GetReceiptResponse>(
          ctx, 'MaterialsService', 'GetReceipt', request, GetReceiptResponse());
  $async.Future<ListReceiptsResponse> listReceipts(
          $pb.ClientContext? ctx, ListReceiptsRequest request) =>
      _client.invoke<ListReceiptsResponse>(ctx, 'MaterialsService',
          'ListReceipts', request, ListReceiptsResponse());

  /// SRS-MAT-007, SRS-MAT-008, SRS-MAT-009: the ledger.
  $async.Future<RecommendPickResponse> recommendPick(
          $pb.ClientContext? ctx, RecommendPickRequest request) =>
      _client.invoke<RecommendPickResponse>(ctx, 'MaterialsService',
          'RecommendPick', request, RecommendPickResponse());
  $async.Future<IssueStockResponse> issueStock(
          $pb.ClientContext? ctx, IssueStockRequest request) =>
      _client.invoke<IssueStockResponse>(
          ctx, 'MaterialsService', 'IssueStock', request, IssueStockResponse());
  $async.Future<ReturnStockResponse> returnStock(
          $pb.ClientContext? ctx, ReturnStockRequest request) =>
      _client.invoke<ReturnStockResponse>(ctx, 'MaterialsService',
          'ReturnStock', request, ReturnStockResponse());
  $async.Future<ListBalancesResponse> listBalances(
          $pb.ClientContext? ctx, ListBalancesRequest request) =>
      _client.invoke<ListBalancesResponse>(ctx, 'MaterialsService',
          'ListBalances', request, ListBalancesResponse());
  $async.Future<GetAvailableResponse> getAvailable(
          $pb.ClientContext? ctx, GetAvailableRequest request) =>
      _client.invoke<GetAvailableResponse>(ctx, 'MaterialsService',
          'GetAvailable', request, GetAvailableResponse());
  $async.Future<ListMovementsResponse> listMovements(
          $pb.ClientContext? ctx, ListMovementsRequest request) =>
      _client.invoke<ListMovementsResponse>(ctx, 'MaterialsService',
          'ListMovements', request, ListMovementsResponse());

  /// SRS-MAT-010, SRS-MAT-011: transfers and counts.
  $async.Future<DispatchTransferResponse> dispatchTransfer(
          $pb.ClientContext? ctx, DispatchTransferRequest request) =>
      _client.invoke<DispatchTransferResponse>(ctx, 'MaterialsService',
          'DispatchTransfer', request, DispatchTransferResponse());
  $async.Future<ReceiveTransferResponse> receiveTransfer(
          $pb.ClientContext? ctx, ReceiveTransferRequest request) =>
      _client.invoke<ReceiveTransferResponse>(ctx, 'MaterialsService',
          'ReceiveTransfer', request, ReceiveTransferResponse());
  $async.Future<ListTransfersInTransitResponse> listTransfersInTransit(
          $pb.ClientContext? ctx, ListTransfersInTransitRequest request) =>
      _client.invoke<ListTransfersInTransitResponse>(ctx, 'MaterialsService',
          'ListTransfersInTransit', request, ListTransfersInTransitResponse());
  $async.Future<OpenCountResponse> openCount(
          $pb.ClientContext? ctx, OpenCountRequest request) =>
      _client.invoke<OpenCountResponse>(
          ctx, 'MaterialsService', 'OpenCount', request, OpenCountResponse());
  $async.Future<RecordCountResponse> recordCount(
          $pb.ClientContext? ctx, RecordCountRequest request) =>
      _client.invoke<RecordCountResponse>(ctx, 'MaterialsService',
          'RecordCount', request, RecordCountResponse());
  $async.Future<ApproveCountResponse> approveCount(
          $pb.ClientContext? ctx, ApproveCountRequest request) =>
      _client.invoke<ApproveCountResponse>(ctx, 'MaterialsService',
          'ApproveCount', request, ApproveCountResponse());
  $async.Future<RejectCountResponse> rejectCount(
          $pb.ClientContext? ctx, RejectCountRequest request) =>
      _client.invoke<RejectCountResponse>(ctx, 'MaterialsService',
          'RejectCount', request, RejectCountResponse());
  $async.Future<GetCountResponse> getCount(
          $pb.ClientContext? ctx, GetCountRequest request) =>
      _client.invoke<GetCountResponse>(
          ctx, 'MaterialsService', 'GetCount', request, GetCountResponse());
  $async.Future<ListCountsResponse> listCounts(
          $pb.ClientContext? ctx, ListCountsRequest request) =>
      _client.invoke<ListCountsResponse>(
          ctx, 'MaterialsService', 'ListCounts', request, ListCountsResponse());

  /// SRS-MAT-013: blocked lots and their recall.
  $async.Future<BlockLotResponse> blockLot(
          $pb.ClientContext? ctx, BlockLotRequest request) =>
      _client.invoke<BlockLotResponse>(
          ctx, 'MaterialsService', 'BlockLot', request, BlockLotResponse());
  $async.Future<ReleaseLotResponse> releaseLot(
          $pb.ClientContext? ctx, ReleaseLotRequest request) =>
      _client.invoke<ReleaseLotResponse>(
          ctx, 'MaterialsService', 'ReleaseLot', request, ReleaseLotResponse());
  $async.Future<GetRecallListResponse> getRecallList(
          $pb.ClientContext? ctx, GetRecallListRequest request) =>
      _client.invoke<GetRecallListResponse>(ctx, 'MaterialsService',
          'GetRecallList', request, GetRecallListResponse());
  $async.Future<ListBlockedLotsResponse> listBlockedLots(
          $pb.ClientContext? ctx, ListBlockedLotsRequest request) =>
      _client.invoke<ListBlockedLotsResponse>(ctx, 'MaterialsService',
          'ListBlockedLots', request, ListBlockedLotsResponse());
  $async.Future<GetLotResponse> getLot(
          $pb.ClientContext? ctx, GetLotRequest request) =>
      _client.invoke<GetLotResponse>(
          ctx, 'MaterialsService', 'GetLot', request, GetLotResponse());
  $async.Future<ListLotsResponse> listLots(
          $pb.ClientContext? ctx, ListLotsRequest request) =>
      _client.invoke<ListLotsResponse>(
          ctx, 'MaterialsService', 'ListLots', request, ListLotsResponse());

  /// SRS-MAT-012, SRS-MAT-014, SRS-MAT-015, SRS-MAT-016.
  $async.Future<ListAlertsResponse> listAlerts(
          $pb.ClientContext? ctx, ListAlertsRequest request) =>
      _client.invoke<ListAlertsResponse>(
          ctx, 'MaterialsService', 'ListAlerts', request, ListAlertsResponse());
  $async.Future<SuggestOrderResponse> suggestOrder(
          $pb.ClientContext? ctx, SuggestOrderRequest request) =>
      _client.invoke<SuggestOrderResponse>(ctx, 'MaterialsService',
          'SuggestOrder', request, SuggestOrderResponse());
  $async.Future<RecordInvoiceResponse> recordInvoice(
          $pb.ClientContext? ctx, RecordInvoiceRequest request) =>
      _client.invoke<RecordInvoiceResponse>(ctx, 'MaterialsService',
          'RecordInvoice', request, RecordInvoiceResponse());
  $async.Future<MatchInvoiceResponse> matchInvoice(
          $pb.ClientContext? ctx, MatchInvoiceRequest request) =>
      _client.invoke<MatchInvoiceResponse>(ctx, 'MaterialsService',
          'MatchInvoice', request, MatchInvoiceResponse());
  $async.Future<GetMetricsResponse> getMetrics(
          $pb.ClientContext? ctx, GetMetricsRequest request) =>
      _client.invoke<GetMetricsResponse>(
          ctx, 'MaterialsService', 'GetMetrics', request, GetMetricsResponse());
  $async.Future<GetFillRateResponse> getFillRate(
          $pb.ClientContext? ctx, GetFillRateRequest request) =>
      _client.invoke<GetFillRateResponse>(ctx, 'MaterialsService',
          'GetFillRate', request, GetFillRateResponse());
  $async.Future<ListLiabilitiesResponse> listLiabilities(
          $pb.ClientContext? ctx, ListLiabilitiesRequest request) =>
      _client.invoke<ListLiabilitiesResponse>(ctx, 'MaterialsService',
          'ListLiabilities', request, ListLiabilitiesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
