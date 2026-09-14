// This is a generated file - do not edit.
//
// Generated from healthcare/billing/v1/billing.proto.

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

import 'billing.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'billing.pbenum.dart';

/// An amount in minor units with its currency. Inseparable: a number alone has
/// eventually been rendered under the wrong label by every system that stored it
/// that way.
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
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

  /// Signed. Negative is meaningful: a credit note line and a refund are both
  /// negative movements.
  @$pb.TagNumber(1)
  $fixnum.Int64 get minor => $_getI64(0);
  @$pb.TagNumber(1)
  set minor($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMinor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinor() => $_clearField(1);

  /// ISO 4217 alphabetic — "INR", "USD".
  @$pb.TagNumber(2)
  $core.String get currency => $_getSZ(1);
  @$pb.TagNumber(2)
  set currency($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCurrency() => $_has(1);
  @$pb.TagNumber(2)
  void clearCurrency() => $_clearField(2);
}

/// One billable thing, versioned by its effective window (SRS-BIL-001).
class ServiceItem extends $pb.GeneratedMessage {
  factory ServiceItem({
    $core.String? code,
    $core.String? description,
    $core.String? department,
    $core.String? revenueAccount,
    $core.String? taxCode,
    $core.int? taxRateBp,
    $core.bool? taxInclusive,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (description != null) result.description = description;
    if (department != null) result.department = department;
    if (revenueAccount != null) result.revenueAccount = revenueAccount;
    if (taxCode != null) result.taxCode = taxCode;
    if (taxRateBp != null) result.taxRateBp = taxRateBp;
    if (taxInclusive != null) result.taxInclusive = taxInclusive;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    return result;
  }

  ServiceItem._();

  factory ServiceItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ServiceItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ServiceItem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOS(3, _omitFieldNames ? '' : 'department')
    ..aOS(4, _omitFieldNames ? '' : 'revenueAccount')
    ..aOS(5, _omitFieldNames ? '' : 'taxCode')
    ..aI(6, _omitFieldNames ? '' : 'taxRateBp')
    ..aOB(7, _omitFieldNames ? '' : 'taxInclusive')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ServiceItem copyWith(void Function(ServiceItem) updates) =>
      super.copyWith((message) => updates(message as ServiceItem))
          as ServiceItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceItem create() => ServiceItem._();
  @$core.override
  ServiceItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ServiceItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ServiceItem>(create);
  static ServiceItem? _defaultInstance;

  /// Stable across versions. Two entries with one code and different windows are
  /// two versions of one service.
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

  /// Radiology's income is not the ward's.
  @$pb.TagNumber(3)
  $core.String get department => $_getSZ(2);
  @$pb.TagNumber(3)
  set department($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDepartment() => $_has(2);
  @$pb.TagNumber(3)
  void clearDepartment() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get revenueAccount => $_getSZ(3);
  @$pb.TagNumber(4)
  set revenueAccount($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRevenueAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearRevenueAccount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get taxCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set taxCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTaxCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearTaxCode() => $_clearField(5);

  /// Hundredths of a percent: 18% is 1800. Integer for the same reason money is.
  @$pb.TagNumber(6)
  $core.int get taxRateBp => $_getIZ(5);
  @$pb.TagNumber(6)
  set taxRateBp($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTaxRateBp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaxRateBp() => $_clearField(6);

  /// Whether the tariff price already contains the tax. Stated rather than
  /// assumed: both conventions coexist in one hospital.
  @$pb.TagNumber(7)
  $core.bool get taxInclusive => $_getBF(6);
  @$pb.TagNumber(7)
  set taxInclusive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTaxInclusive() => $_has(6);
  @$pb.TagNumber(7)
  void clearTaxInclusive() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get effectiveFrom => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveFrom($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectiveFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveFrom() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(7);

  /// Unset while the version is current.
  @$pb.TagNumber(9)
  $0.Timestamp get effectiveTo => $_getN(8);
  @$pb.TagNumber(9)
  set effectiveTo($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectiveTo() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveTo() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEffectiveTo() => $_ensure(8);
}

/// What a tariff contract is negotiated against (SRS-BIL-002).
///
/// All five axes are optional. One that names none is the standard list price;
/// one that names a payer and a room class is the rate that insurer pays for a
/// private room. The most specific match wins.
class TariffScope extends $pb.GeneratedMessage {
  factory TariffScope({
    $core.String? payerId,
    $core.String? customerId,
    $core.String? facilityId,
    $core.String? roomClass,
    $core.String? serviceCode,
  }) {
    final result = create();
    if (payerId != null) result.payerId = payerId;
    if (customerId != null) result.customerId = customerId;
    if (facilityId != null) result.facilityId = facilityId;
    if (roomClass != null) result.roomClass = roomClass;
    if (serviceCode != null) result.serviceCode = serviceCode;
    return result;
  }

  TariffScope._();

  factory TariffScope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TariffScope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TariffScope',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'payerId')
    ..aOS(2, _omitFieldNames ? '' : 'customerId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOS(4, _omitFieldNames ? '' : 'roomClass')
    ..aOS(5, _omitFieldNames ? '' : 'serviceCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TariffScope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TariffScope copyWith(void Function(TariffScope) updates) =>
      super.copyWith((message) => updates(message as TariffScope))
          as TariffScope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TariffScope create() => TariffScope._();
  @$core.override
  TariffScope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TariffScope getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TariffScope>(create);
  static TariffScope? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get payerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set payerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPayerId() => $_clearField(1);

  /// The corporate account, which is not the same as the payer: a company scheme
  /// and the insurer administering it negotiate separately.
  @$pb.TagNumber(2)
  $core.String get customerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set customerId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCustomerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCustomerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

  /// The same service costs differently in a general ward and a suite.
  @$pb.TagNumber(4)
  $core.String get roomClass => $_getSZ(3);
  @$pb.TagNumber(4)
  set roomClass($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasRoomClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoomClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get serviceCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set serviceCode($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasServiceCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearServiceCode() => $_clearField(5);
}

class TariffLine extends $pb.GeneratedMessage {
  factory TariffLine({
    $core.String? tariffLineId,
    $core.String? contractId,
    $core.String? name,
    TariffScope? scope,
    Money? price,
    $core.int? priority,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
  }) {
    final result = create();
    if (tariffLineId != null) result.tariffLineId = tariffLineId;
    if (contractId != null) result.contractId = contractId;
    if (name != null) result.name = name;
    if (scope != null) result.scope = scope;
    if (price != null) result.price = price;
    if (priority != null) result.priority = priority;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    return result;
  }

  TariffLine._();

  factory TariffLine.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TariffLine.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TariffLine',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tariffLineId')
    ..aOS(2, _omitFieldNames ? '' : 'contractId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOM<TariffScope>(4, _omitFieldNames ? '' : 'scope',
        subBuilder: TariffScope.create)
    ..aOM<Money>(5, _omitFieldNames ? '' : 'price', subBuilder: Money.create)
    ..aI(6, _omitFieldNames ? '' : 'priority')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TariffLine clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TariffLine copyWith(void Function(TariffLine) updates) =>
      super.copyWith((message) => updates(message as TariffLine)) as TariffLine;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TariffLine create() => TariffLine._();
  @$core.override
  TariffLine createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TariffLine getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TariffLine>(create);
  static TariffLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tariffLineId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tariffLineId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTariffLineId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTariffLineId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get contractId => $_getSZ(1);
  @$pb.TagNumber(2)
  set contractId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContractId() => $_has(1);
  @$pb.TagNumber(2)
  void clearContractId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  TariffScope get scope => $_getN(3);
  @$pb.TagNumber(4)
  set scope(TariffScope value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScope() => $_has(3);
  @$pb.TagNumber(4)
  void clearScope() => $_clearField(4);
  @$pb.TagNumber(4)
  TariffScope ensureScope() => $_ensure(3);

  @$pb.TagNumber(5)
  Money get price => $_getN(4);
  @$pb.TagNumber(5)
  set price(Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrice() => $_clearField(5);
  @$pb.TagNumber(5)
  Money ensurePrice() => $_ensure(4);

  /// Breaks a tie between contracts of equal specificity. Explicit rather than
  /// "most recently created", because a resolution that depends on insertion
  /// order changes when data is migrated.
  @$pb.TagNumber(6)
  $core.int get priority => $_getIZ(5);
  @$pb.TagNumber(6)
  set priority($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPriority() => $_has(5);
  @$pb.TagNumber(6)
  void clearPriority() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get effectiveFrom => $_getN(6);
  @$pb.TagNumber(7)
  set effectiveFrom($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEffectiveFrom() => $_has(6);
  @$pb.TagNumber(7)
  void clearEffectiveFrom() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get effectiveTo => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveTo($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectiveTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveTo() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectiveTo() => $_ensure(7);
}

/// The price and which contract produced it (SRS-BIL-002).
class PricingResult extends $pb.GeneratedMessage {
  factory PricingResult({
    Money? price,
    $core.String? contractId,
    $core.String? contract,
    TariffScope? scope,
  }) {
    final result = create();
    if (price != null) result.price = price;
    if (contractId != null) result.contractId = contractId;
    if (contract != null) result.contract = contract;
    if (scope != null) result.scope = scope;
    return result;
  }

  PricingResult._();

  factory PricingResult.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PricingResult.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PricingResult',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Money>(1, _omitFieldNames ? '' : 'price', subBuilder: Money.create)
    ..aOS(2, _omitFieldNames ? '' : 'contractId')
    ..aOS(3, _omitFieldNames ? '' : 'contract')
    ..aOM<TariffScope>(4, _omitFieldNames ? '' : 'scope',
        subBuilder: TariffScope.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PricingResult clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PricingResult copyWith(void Function(PricingResult) updates) =>
      super.copyWith((message) => updates(message as PricingResult))
          as PricingResult;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PricingResult create() => PricingResult._();
  @$core.override
  PricingResult createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PricingResult getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PricingResult>(create);
  static PricingResult? _defaultInstance;

  @$pb.TagNumber(1)
  Money get price => $_getN(0);
  @$pb.TagNumber(1)
  set price(Money value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPrice() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrice() => $_clearField(1);
  @$pb.TagNumber(1)
  Money ensurePrice() => $_ensure(0);

  /// "Which tariff was applied" is the first question of every payer dispute.
  @$pb.TagNumber(2)
  $core.String get contractId => $_getSZ(1);
  @$pb.TagNumber(2)
  set contractId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasContractId() => $_has(1);
  @$pb.TagNumber(2)
  void clearContractId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get contract => $_getSZ(2);
  @$pb.TagNumber(3)
  set contract($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasContract() => $_has(2);
  @$pb.TagNumber(3)
  void clearContract() => $_clearField(3);

  @$pb.TagNumber(4)
  TariffScope get scope => $_getN(3);
  @$pb.TagNumber(4)
  set scope(TariffScope value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScope() => $_has(3);
  @$pb.TagNumber(4)
  void clearScope() => $_clearField(4);
  @$pb.TagNumber(4)
  TariffScope ensureScope() => $_ensure(3);
}

/// A service a package covers (SRS-BIL-004).
class PackageInclusion extends $pb.GeneratedMessage {
  factory PackageInclusion({
    $core.String? serviceCode,
    $core.int? quantity,
  }) {
    final result = create();
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (quantity != null) result.quantity = quantity;
    return result;
  }

  PackageInclusion._();

  factory PackageInclusion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageInclusion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageInclusion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceCode')
    ..aI(2, _omitFieldNames ? '' : 'quantity')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageInclusion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageInclusion copyWith(void Function(PackageInclusion) updates) =>
      super.copyWith((message) => updates(message as PackageInclusion))
          as PackageInclusion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageInclusion create() => PackageInclusion._();
  @$core.override
  PackageInclusion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageInclusion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageInclusion>(create);
  static PackageInclusion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceCode() => $_clearField(1);

  /// The cap. Zero means unlimited within the package, which is a real
  /// contract — "all nursing care".
  @$pb.TagNumber(2)
  $core.int get quantity => $_getIZ(1);
  @$pb.TagNumber(2)
  set quantity($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuantity() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuantity() => $_clearField(2);
}

/// A service billed separately at a contracted price (SRS-BIL-004).
///
/// A price rather than a flag, because that is how implants and high-cost drugs
/// are contracted.
class PackageCarveOut extends $pb.GeneratedMessage {
  factory PackageCarveOut({
    $core.String? serviceCode,
    Money? price,
    $core.String? note,
  }) {
    final result = create();
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (price != null) result.price = price;
    if (note != null) result.note = note;
    return result;
  }

  PackageCarveOut._();

  factory PackageCarveOut.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageCarveOut.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageCarveOut',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceCode')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'price', subBuilder: Money.create)
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageCarveOut clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageCarveOut copyWith(void Function(PackageCarveOut) updates) =>
      super.copyWith((message) => updates(message as PackageCarveOut))
          as PackageCarveOut;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageCarveOut create() => PackageCarveOut._();
  @$core.override
  PackageCarveOut createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageCarveOut getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageCarveOut>(create);
  static PackageCarveOut? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceCode() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get price => $_getN(1);
  @$pb.TagNumber(2)
  set price(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrice() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensurePrice() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);
}

class Package extends $pb.GeneratedMessage {
  factory Package({
    $core.String? code,
    $core.String? name,
    Money? price,
    $core.Iterable<PackageInclusion>? inclusions,
    $core.Iterable<$core.String>? exclusions,
    $core.Iterable<PackageCarveOut>? carveOuts,
    $core.String? roomClass,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (name != null) result.name = name;
    if (price != null) result.price = price;
    if (inclusions != null) result.inclusions.addAll(inclusions);
    if (exclusions != null) result.exclusions.addAll(exclusions);
    if (carveOuts != null) result.carveOuts.addAll(carveOuts);
    if (roomClass != null) result.roomClass = roomClass;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    return result;
  }

  Package._();

  factory Package.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Package.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Package',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'price', subBuilder: Money.create)
    ..pPM<PackageInclusion>(4, _omitFieldNames ? '' : 'inclusions',
        subBuilder: PackageInclusion.create)
    ..pPS(5, _omitFieldNames ? '' : 'exclusions')
    ..pPM<PackageCarveOut>(6, _omitFieldNames ? '' : 'carveOuts',
        subBuilder: PackageCarveOut.create)
    ..aOS(7, _omitFieldNames ? '' : 'roomClass')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Package clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Package copyWith(void Function(Package) updates) =>
      super.copyWith((message) => updates(message as Package)) as Package;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Package create() => Package._();
  @$core.override
  Package createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Package getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Package>(create);
  static Package? _defaultInstance;

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
  Money get price => $_getN(2);
  @$pb.TagNumber(3)
  set price(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPrice() => $_has(2);
  @$pb.TagNumber(3)
  void clearPrice() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensurePrice() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<PackageInclusion> get inclusions => $_getList(3);

  /// Named so a patient is told before admission rather than at discharge.
  /// Explicit rather than implied by absence from the inclusions: "we did not
  /// think about this" and "this is not covered" are different answers.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get exclusions => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<PackageCarveOut> get carveOuts => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get roomClass => $_getSZ(6);
  @$pb.TagNumber(7)
  set roomClass($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRoomClass() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoomClass() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get effectiveFrom => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveFrom($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEffectiveFrom() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveFrom() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEffectiveFrom() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get effectiveTo => $_getN(8);
  @$pb.TagNumber(9)
  set effectiveTo($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasEffectiveTo() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveTo() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureEffectiveTo() => $_ensure(8);
}

/// What a charge came from (SRS-BIL-003).
///
/// System and identifier together are the idempotency key: a redelivered event
/// produces no second charge.
class SourceReference extends $pb.GeneratedMessage {
  factory SourceReference({
    $core.String? system,
    $core.String? id,
    $core.String? detail,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (id != null) result.id = id;
    if (detail != null) result.detail = detail;
    return result;
  }

  SourceReference._();

  factory SourceReference.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SourceReference.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SourceReference',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..aOS(3, _omitFieldNames ? '' : 'detail')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceReference clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceReference copyWith(void Function(SourceReference) updates) =>
      super.copyWith((message) => updates(message as SourceReference))
          as SourceReference;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SourceReference create() => SourceReference._();
  @$core.override
  SourceReference createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SourceReference getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SourceReference>(create);
  static SourceReference? _defaultInstance;

  /// The context that raised it — "orders", "nursing", "scheduling".
  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);

  /// The reference a biller follows back — an order number a ward reads down a
  /// phone. An opaque identifier is not a link anybody can follow.
  @$pb.TagNumber(3)
  $core.String get detail => $_getSZ(2);
  @$pb.TagNumber(3)
  set detail($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDetail() => $_has(2);
  @$pb.TagNumber(3)
  void clearDetail() => $_clearField(3);
}

class Charge extends $pb.GeneratedMessage {
  factory Charge({
    $core.String? chargeId,
    $core.String? accountId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? serviceCode,
    $core.String? description,
    $core.String? department,
    $core.int? quantity,
    Money? unitPrice,
    PricingResult? pricing,
    $core.String? taxCode,
    $core.int? taxRateBp,
    $core.bool? taxInclusive,
    Money? net,
    Money? tax,
    Money? total,
    ChargeOrigin? origin,
    SourceReference? source,
    $core.String? enteredBy,
    $core.String? reason,
    $0.Timestamp? occurredAt,
    $0.Timestamp? postedAt,
    ChargeStatus? status,
    $core.String? packageCode,
    $core.bool? covered,
    $core.String? coverageNote,
    $core.String? invoiceId,
  }) {
    final result = create();
    if (chargeId != null) result.chargeId = chargeId;
    if (accountId != null) result.accountId = accountId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (description != null) result.description = description;
    if (department != null) result.department = department;
    if (quantity != null) result.quantity = quantity;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (pricing != null) result.pricing = pricing;
    if (taxCode != null) result.taxCode = taxCode;
    if (taxRateBp != null) result.taxRateBp = taxRateBp;
    if (taxInclusive != null) result.taxInclusive = taxInclusive;
    if (net != null) result.net = net;
    if (tax != null) result.tax = tax;
    if (total != null) result.total = total;
    if (origin != null) result.origin = origin;
    if (source != null) result.source = source;
    if (enteredBy != null) result.enteredBy = enteredBy;
    if (reason != null) result.reason = reason;
    if (occurredAt != null) result.occurredAt = occurredAt;
    if (postedAt != null) result.postedAt = postedAt;
    if (status != null) result.status = status;
    if (packageCode != null) result.packageCode = packageCode;
    if (covered != null) result.covered = covered;
    if (coverageNote != null) result.coverageNote = coverageNote;
    if (invoiceId != null) result.invoiceId = invoiceId;
    return result;
  }

  Charge._();

  factory Charge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Charge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Charge',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chargeId')
    ..aOS(2, _omitFieldNames ? '' : 'accountId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'facilityId')
    ..aOS(6, _omitFieldNames ? '' : 'serviceCode')
    ..aOS(7, _omitFieldNames ? '' : 'description')
    ..aOS(8, _omitFieldNames ? '' : 'department')
    ..aI(9, _omitFieldNames ? '' : 'quantity')
    ..aOM<Money>(10, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: Money.create)
    ..aOM<PricingResult>(11, _omitFieldNames ? '' : 'pricing',
        subBuilder: PricingResult.create)
    ..aOS(12, _omitFieldNames ? '' : 'taxCode')
    ..aI(13, _omitFieldNames ? '' : 'taxRateBp')
    ..aOB(14, _omitFieldNames ? '' : 'taxInclusive')
    ..aOM<Money>(15, _omitFieldNames ? '' : 'net', subBuilder: Money.create)
    ..aOM<Money>(16, _omitFieldNames ? '' : 'tax', subBuilder: Money.create)
    ..aOM<Money>(17, _omitFieldNames ? '' : 'total', subBuilder: Money.create)
    ..aE<ChargeOrigin>(18, _omitFieldNames ? '' : 'origin',
        enumValues: ChargeOrigin.values)
    ..aOM<SourceReference>(19, _omitFieldNames ? '' : 'source',
        subBuilder: SourceReference.create)
    ..aOS(20, _omitFieldNames ? '' : 'enteredBy')
    ..aOS(21, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(22, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'postedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<ChargeStatus>(24, _omitFieldNames ? '' : 'status',
        enumValues: ChargeStatus.values)
    ..aOS(25, _omitFieldNames ? '' : 'packageCode')
    ..aOB(26, _omitFieldNames ? '' : 'covered')
    ..aOS(27, _omitFieldNames ? '' : 'coverageNote')
    ..aOS(28, _omitFieldNames ? '' : 'invoiceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Charge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Charge copyWith(void Function(Charge) updates) =>
      super.copyWith((message) => updates(message as Charge)) as Charge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Charge create() => Charge._();
  @$core.override
  Charge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Charge getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Charge>(create);
  static Charge? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chargeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set chargeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChargeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChargeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountId() => $_clearField(2);

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
  $core.String get facilityId => $_getSZ(4);
  @$pb.TagNumber(5)
  set facilityId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFacilityId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFacilityId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get serviceCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set serviceCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasServiceCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearServiceCode() => $_clearField(6);

  /// Copied from the service version in force at charge time, so a master edited
  /// afterwards does not restate what was charged.
  @$pb.TagNumber(7)
  $core.String get description => $_getSZ(6);
  @$pb.TagNumber(7)
  set description($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDescription() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescription() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get department => $_getSZ(7);
  @$pb.TagNumber(8)
  set department($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDepartment() => $_has(7);
  @$pb.TagNumber(8)
  void clearDepartment() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get quantity => $_getIZ(8);
  @$pb.TagNumber(9)
  set quantity($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasQuantity() => $_has(8);
  @$pb.TagNumber(9)
  void clearQuantity() => $_clearField(9);

  @$pb.TagNumber(10)
  Money get unitPrice => $_getN(9);
  @$pb.TagNumber(10)
  set unitPrice(Money value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUnitPrice() => $_has(9);
  @$pb.TagNumber(10)
  void clearUnitPrice() => $_clearField(10);
  @$pb.TagNumber(10)
  Money ensureUnitPrice() => $_ensure(9);

  @$pb.TagNumber(11)
  PricingResult get pricing => $_getN(10);
  @$pb.TagNumber(11)
  set pricing(PricingResult value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasPricing() => $_has(10);
  @$pb.TagNumber(11)
  void clearPricing() => $_clearField(11);
  @$pb.TagNumber(11)
  PricingResult ensurePricing() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get taxCode => $_getSZ(11);
  @$pb.TagNumber(12)
  set taxCode($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasTaxCode() => $_has(11);
  @$pb.TagNumber(12)
  void clearTaxCode() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.int get taxRateBp => $_getIZ(12);
  @$pb.TagNumber(13)
  set taxRateBp($core.int value) => $_setSignedInt32(12, value);
  @$pb.TagNumber(13)
  $core.bool hasTaxRateBp() => $_has(12);
  @$pb.TagNumber(13)
  void clearTaxRateBp() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get taxInclusive => $_getBF(13);
  @$pb.TagNumber(14)
  set taxInclusive($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasTaxInclusive() => $_has(13);
  @$pb.TagNumber(14)
  void clearTaxInclusive() => $_clearField(14);

  @$pb.TagNumber(15)
  Money get net => $_getN(14);
  @$pb.TagNumber(15)
  set net(Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasNet() => $_has(14);
  @$pb.TagNumber(15)
  void clearNet() => $_clearField(15);
  @$pb.TagNumber(15)
  Money ensureNet() => $_ensure(14);

  @$pb.TagNumber(16)
  Money get tax => $_getN(15);
  @$pb.TagNumber(16)
  set tax(Money value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasTax() => $_has(15);
  @$pb.TagNumber(16)
  void clearTax() => $_clearField(16);
  @$pb.TagNumber(16)
  Money ensureTax() => $_ensure(15);

  @$pb.TagNumber(17)
  Money get total => $_getN(16);
  @$pb.TagNumber(17)
  set total(Money value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasTotal() => $_has(16);
  @$pb.TagNumber(17)
  void clearTotal() => $_clearField(17);
  @$pb.TagNumber(17)
  Money ensureTotal() => $_ensure(16);

  @$pb.TagNumber(18)
  ChargeOrigin get origin => $_getN(17);
  @$pb.TagNumber(18)
  set origin(ChargeOrigin value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasOrigin() => $_has(17);
  @$pb.TagNumber(18)
  void clearOrigin() => $_clearField(18);

  @$pb.TagNumber(19)
  SourceReference get source => $_getN(18);
  @$pb.TagNumber(19)
  set source(SourceReference value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasSource() => $_has(18);
  @$pb.TagNumber(19)
  void clearSource() => $_clearField(19);
  @$pb.TagNumber(19)
  SourceReference ensureSource() => $_ensure(18);

  @$pb.TagNumber(20)
  $core.String get enteredBy => $_getSZ(19);
  @$pb.TagNumber(20)
  set enteredBy($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasEnteredBy() => $_has(19);
  @$pb.TagNumber(20)
  void clearEnteredBy() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get reason => $_getSZ(20);
  @$pb.TagNumber(21)
  set reason($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasReason() => $_has(20);
  @$pb.TagNumber(21)
  void clearReason() => $_clearField(21);

  /// When the service was delivered, which is what the master and the tariff are
  /// resolved against. Distinct from posted_at: a charge keyed three days later
  /// is still priced at the day of care.
  @$pb.TagNumber(22)
  $0.Timestamp get occurredAt => $_getN(21);
  @$pb.TagNumber(22)
  set occurredAt($0.Timestamp value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasOccurredAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearOccurredAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.Timestamp ensureOccurredAt() => $_ensure(21);

  @$pb.TagNumber(23)
  $0.Timestamp get postedAt => $_getN(22);
  @$pb.TagNumber(23)
  set postedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasPostedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearPostedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensurePostedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  ChargeStatus get status => $_getN(23);
  @$pb.TagNumber(24)
  set status(ChargeStatus value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasStatus() => $_has(23);
  @$pb.TagNumber(24)
  void clearStatus() => $_clearField(24);

  @$pb.TagNumber(25)
  $core.String get packageCode => $_getSZ(24);
  @$pb.TagNumber(25)
  set packageCode($core.String value) => $_setString(24, value);
  @$pb.TagNumber(25)
  $core.bool hasPackageCode() => $_has(24);
  @$pb.TagNumber(25)
  void clearPackageCode() => $_clearField(25);

  @$pb.TagNumber(26)
  $core.bool get covered => $_getBF(25);
  @$pb.TagNumber(26)
  set covered($core.bool value) => $_setBool(25, value);
  @$pb.TagNumber(26)
  $core.bool hasCovered() => $_has(25);
  @$pb.TagNumber(26)
  void clearCovered() => $_clearField(26);

  @$pb.TagNumber(27)
  $core.String get coverageNote => $_getSZ(26);
  @$pb.TagNumber(27)
  set coverageNote($core.String value) => $_setString(26, value);
  @$pb.TagNumber(27)
  $core.bool hasCoverageNote() => $_has(26);
  @$pb.TagNumber(27)
  void clearCoverageNote() => $_clearField(27);

  @$pb.TagNumber(28)
  $core.String get invoiceId => $_getSZ(27);
  @$pb.TagNumber(28)
  set invoiceId($core.String value) => $_setString(27, value);
  @$pb.TagNumber(28)
  $core.bool hasInvoiceId() => $_has(27);
  @$pb.TagNumber(28)
  void clearInvoiceId() => $_clearField(28);
}

/// One entry in the package ledger (SRS-BIL-004).
class Consumption extends $pb.GeneratedMessage {
  factory Consumption({
    $core.String? packageCode,
    $core.String? chargeId,
    $core.String? serviceCode,
    $core.int? quantity,
    CoverageOutcome? outcome,
    $core.String? explanation,
    Money? price,
    $0.Timestamp? recordedAt,
  }) {
    final result = create();
    if (packageCode != null) result.packageCode = packageCode;
    if (chargeId != null) result.chargeId = chargeId;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (quantity != null) result.quantity = quantity;
    if (outcome != null) result.outcome = outcome;
    if (explanation != null) result.explanation = explanation;
    if (price != null) result.price = price;
    if (recordedAt != null) result.recordedAt = recordedAt;
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'packageCode')
    ..aOS(2, _omitFieldNames ? '' : 'chargeId')
    ..aOS(3, _omitFieldNames ? '' : 'serviceCode')
    ..aI(4, _omitFieldNames ? '' : 'quantity')
    ..aE<CoverageOutcome>(5, _omitFieldNames ? '' : 'outcome',
        enumValues: CoverageOutcome.values)
    ..aOS(6, _omitFieldNames ? '' : 'explanation')
    ..aOM<Money>(7, _omitFieldNames ? '' : 'price', subBuilder: Money.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get packageCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set packageCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPackageCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackageCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chargeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set chargeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChargeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChargeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serviceCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  CoverageOutcome get outcome => $_getN(4);
  @$pb.TagNumber(5)
  set outcome(CoverageOutcome value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOutcome() => $_has(4);
  @$pb.TagNumber(5)
  void clearOutcome() => $_clearField(5);

  /// The sentence at the discharge desk.
  @$pb.TagNumber(6)
  $core.String get explanation => $_getSZ(5);
  @$pb.TagNumber(6)
  set explanation($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasExplanation() => $_has(5);
  @$pb.TagNumber(6)
  void clearExplanation() => $_clearField(6);

  @$pb.TagNumber(7)
  Money get price => $_getN(6);
  @$pb.TagNumber(7)
  set price(Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearPrice() => $_clearField(7);
  @$pb.TagNumber(7)
  Money ensurePrice() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get recordedAt => $_getN(7);
  @$pb.TagNumber(8)
  set recordedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasRecordedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearRecordedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureRecordedAt() => $_ensure(7);
}

/// One party's portion, with its provenance (SRS-BIL-014).
class LiabilityShare extends $pb.GeneratedMessage {
  factory LiabilityShare({
    LiabilityParty? party,
    $core.String? partyId,
    Money? amount,
    $core.String? basis,
    $core.String? adjudicationRef,
  }) {
    final result = create();
    if (party != null) result.party = party;
    if (partyId != null) result.partyId = partyId;
    if (amount != null) result.amount = amount;
    if (basis != null) result.basis = basis;
    if (adjudicationRef != null) result.adjudicationRef = adjudicationRef;
    return result;
  }

  LiabilityShare._();

  factory LiabilityShare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LiabilityShare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LiabilityShare',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aE<LiabilityParty>(1, _omitFieldNames ? '' : 'party',
        enumValues: LiabilityParty.values)
    ..aOS(2, _omitFieldNames ? '' : 'partyId')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aOS(4, _omitFieldNames ? '' : 'basis')
    ..aOS(5, _omitFieldNames ? '' : 'adjudicationRef')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiabilityShare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LiabilityShare copyWith(void Function(LiabilityShare) updates) =>
      super.copyWith((message) => updates(message as LiabilityShare))
          as LiabilityShare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LiabilityShare create() => LiabilityShare._();
  @$core.override
  LiabilityShare createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LiabilityShare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LiabilityShare>(create);
  static LiabilityShare? _defaultInstance;

  @$pb.TagNumber(1)
  LiabilityParty get party => $_getN(0);
  @$pb.TagNumber(1)
  set party(LiabilityParty value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasParty() => $_has(0);
  @$pb.TagNumber(1)
  void clearParty() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get partyId => $_getSZ(1);
  @$pb.TagNumber(2)
  set partyId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPartyId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPartyId() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureAmount() => $_ensure(2);

  /// How the share was arrived at — "policy covers 90% up to 500,000",
  /// "co-payment per scheme rules". A share with no stated basis is a number a
  /// patient cannot challenge and a payer cannot reconcile.
  @$pb.TagNumber(4)
  $core.String get basis => $_getSZ(3);
  @$pb.TagNumber(4)
  set basis($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasis() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get adjudicationRef => $_getSZ(4);
  @$pb.TagNumber(5)
  set adjudicationRef($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAdjudicationRef() => $_has(4);
  @$pb.TagNumber(5)
  void clearAdjudicationRef() => $_clearField(5);
}

/// A concession (SRS-BIL-007).
class Discount extends $pb.GeneratedMessage {
  factory Discount({
    $core.int? rateBp,
    Money? amount,
    $core.String? reason,
    $core.String? appliedBy,
    $core.String? approvedBy,
    $0.Timestamp? appliedAt,
    $core.String? approvalRef,
  }) {
    final result = create();
    if (rateBp != null) result.rateBp = rateBp;
    if (amount != null) result.amount = amount;
    if (reason != null) result.reason = reason;
    if (appliedBy != null) result.appliedBy = appliedBy;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (appliedAt != null) result.appliedAt = appliedAt;
    if (approvalRef != null) result.approvalRef = approvalRef;
    return result;
  }

  Discount._();

  factory Discount.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Discount.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Discount',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'rateBp')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'appliedBy')
    ..aOS(5, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'appliedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'approvalRef')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discount clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Discount copyWith(void Function(Discount) updates) =>
      super.copyWith((message) => updates(message as Discount)) as Discount;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Discount create() => Discount._();
  @$core.override
  Discount createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Discount getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Discount>(create);
  static Discount? _defaultInstance;

  /// Either a rate or an amount, never both: a discount expressed two ways is
  /// two numbers that disagree the first time the subtotal changes.
  @$pb.TagNumber(1)
  $core.int get rateBp => $_getIZ(0);
  @$pb.TagNumber(1)
  set rateBp($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRateBp() => $_has(0);
  @$pb.TagNumber(1)
  void clearRateBp() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get appliedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set appliedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAppliedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearAppliedBy() => $_clearField(4);

  /// Set where the concession exceeded the applier's limit.
  @$pb.TagNumber(5)
  $core.String get approvedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasApprovedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get appliedAt => $_getN(5);
  @$pb.TagNumber(6)
  set appliedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAppliedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearAppliedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureAppliedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get approvalRef => $_getSZ(6);
  @$pb.TagNumber(7)
  set approvalRef($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasApprovalRef() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovalRef() => $_clearField(7);
}

/// One line of a document (SRS-BIL-006).
///
/// A snapshot, not a reference. Every value a reader needs is copied on at issue,
/// so the document says the same thing in five years.
class InvoiceLine extends $pb.GeneratedMessage {
  factory InvoiceLine({
    $core.int? sequence,
    $core.String? chargeId,
    $core.String? serviceCode,
    $core.String? description,
    $core.String? department,
    $core.int? quantity,
    Money? unitPrice,
    Money? net,
    $core.String? taxCode,
    $core.int? taxRateBp,
    Money? tax,
    Money? discount,
    Money? total,
    $core.String? packageCode,
    $core.String? coverageNote,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (chargeId != null) result.chargeId = chargeId;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (description != null) result.description = description;
    if (department != null) result.department = department;
    if (quantity != null) result.quantity = quantity;
    if (unitPrice != null) result.unitPrice = unitPrice;
    if (net != null) result.net = net;
    if (taxCode != null) result.taxCode = taxCode;
    if (taxRateBp != null) result.taxRateBp = taxRateBp;
    if (tax != null) result.tax = tax;
    if (discount != null) result.discount = discount;
    if (total != null) result.total = total;
    if (packageCode != null) result.packageCode = packageCode;
    if (coverageNote != null) result.coverageNote = coverageNote;
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'sequence')
    ..aOS(2, _omitFieldNames ? '' : 'chargeId')
    ..aOS(3, _omitFieldNames ? '' : 'serviceCode')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'department')
    ..aI(6, _omitFieldNames ? '' : 'quantity')
    ..aOM<Money>(7, _omitFieldNames ? '' : 'unitPrice',
        subBuilder: Money.create)
    ..aOM<Money>(8, _omitFieldNames ? '' : 'net', subBuilder: Money.create)
    ..aOS(9, _omitFieldNames ? '' : 'taxCode')
    ..aI(10, _omitFieldNames ? '' : 'taxRateBp')
    ..aOM<Money>(11, _omitFieldNames ? '' : 'tax', subBuilder: Money.create)
    ..aOM<Money>(12, _omitFieldNames ? '' : 'discount',
        subBuilder: Money.create)
    ..aOM<Money>(13, _omitFieldNames ? '' : 'total', subBuilder: Money.create)
    ..aOS(14, _omitFieldNames ? '' : 'packageCode')
    ..aOS(15, _omitFieldNames ? '' : 'coverageNote')
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
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  /// Points back for audit. The line does not depend on it.
  @$pb.TagNumber(2)
  $core.String get chargeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set chargeId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChargeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearChargeId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get serviceCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set serviceCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasServiceCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearServiceCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get department => $_getSZ(4);
  @$pb.TagNumber(5)
  set department($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDepartment() => $_has(4);
  @$pb.TagNumber(5)
  void clearDepartment() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get quantity => $_getIZ(5);
  @$pb.TagNumber(6)
  set quantity($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasQuantity() => $_has(5);
  @$pb.TagNumber(6)
  void clearQuantity() => $_clearField(6);

  @$pb.TagNumber(7)
  Money get unitPrice => $_getN(6);
  @$pb.TagNumber(7)
  set unitPrice(Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnitPrice() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnitPrice() => $_clearField(7);
  @$pb.TagNumber(7)
  Money ensureUnitPrice() => $_ensure(6);

  @$pb.TagNumber(8)
  Money get net => $_getN(7);
  @$pb.TagNumber(8)
  set net(Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasNet() => $_has(7);
  @$pb.TagNumber(8)
  void clearNet() => $_clearField(8);
  @$pb.TagNumber(8)
  Money ensureNet() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get taxCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set taxCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTaxCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearTaxCode() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.int get taxRateBp => $_getIZ(9);
  @$pb.TagNumber(10)
  set taxRateBp($core.int value) => $_setSignedInt32(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTaxRateBp() => $_has(9);
  @$pb.TagNumber(10)
  void clearTaxRateBp() => $_clearField(10);

  @$pb.TagNumber(11)
  Money get tax => $_getN(10);
  @$pb.TagNumber(11)
  set tax(Money value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasTax() => $_has(10);
  @$pb.TagNumber(11)
  void clearTax() => $_clearField(11);
  @$pb.TagNumber(11)
  Money ensureTax() => $_ensure(10);

  @$pb.TagNumber(12)
  Money get discount => $_getN(11);
  @$pb.TagNumber(12)
  set discount(Money value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDiscount() => $_has(11);
  @$pb.TagNumber(12)
  void clearDiscount() => $_clearField(12);
  @$pb.TagNumber(12)
  Money ensureDiscount() => $_ensure(11);

  @$pb.TagNumber(13)
  Money get total => $_getN(12);
  @$pb.TagNumber(13)
  set total(Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasTotal() => $_has(12);
  @$pb.TagNumber(13)
  void clearTotal() => $_clearField(13);
  @$pb.TagNumber(13)
  Money ensureTotal() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get packageCode => $_getSZ(13);
  @$pb.TagNumber(14)
  set packageCode($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasPackageCode() => $_has(13);
  @$pb.TagNumber(14)
  void clearPackageCode() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get coverageNote => $_getSZ(14);
  @$pb.TagNumber(15)
  set coverageNote($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCoverageNote() => $_has(14);
  @$pb.TagNumber(15)
  void clearCoverageNote() => $_clearField(15);
}

class Invoice extends $pb.GeneratedMessage {
  factory Invoice({
    $core.String? invoiceId,
    $core.String? number,
    DocumentKind? kind,
    InvoiceStatus? status,
    $core.String? accountId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.int? documentVersion,
    $core.String? supersededBy,
    $core.String? correctsInvoiceId,
    $core.Iterable<InvoiceLine>? lines,
    Money? subtotal,
    Money? discount,
    Money? tax,
    Money? total,
    $core.Iterable<Discount>? discounts,
    $core.Iterable<LiabilityShare>? liability,
    $core.String? payerId,
    $core.String? customerId,
    $core.String? notes,
    $core.String? issuedBy,
    $0.Timestamp? issuedAt,
    $core.String? createdBy,
    $0.Timestamp? createdAt,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (number != null) result.number = number;
    if (kind != null) result.kind = kind;
    if (status != null) result.status = status;
    if (accountId != null) result.accountId = accountId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (documentVersion != null) result.documentVersion = documentVersion;
    if (supersededBy != null) result.supersededBy = supersededBy;
    if (correctsInvoiceId != null) result.correctsInvoiceId = correctsInvoiceId;
    if (lines != null) result.lines.addAll(lines);
    if (subtotal != null) result.subtotal = subtotal;
    if (discount != null) result.discount = discount;
    if (tax != null) result.tax = tax;
    if (total != null) result.total = total;
    if (discounts != null) result.discounts.addAll(discounts);
    if (liability != null) result.liability.addAll(liability);
    if (payerId != null) result.payerId = payerId;
    if (customerId != null) result.customerId = customerId;
    if (notes != null) result.notes = notes;
    if (issuedBy != null) result.issuedBy = issuedBy;
    if (issuedAt != null) result.issuedAt = issuedAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (createdAt != null) result.createdAt = createdAt;
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..aOS(2, _omitFieldNames ? '' : 'number')
    ..aE<DocumentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aE<InvoiceStatus>(4, _omitFieldNames ? '' : 'status',
        enumValues: InvoiceStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'accountId')
    ..aOS(6, _omitFieldNames ? '' : 'patientId')
    ..aOS(7, _omitFieldNames ? '' : 'encounterId')
    ..aOS(8, _omitFieldNames ? '' : 'facilityId')
    ..aI(9, _omitFieldNames ? '' : 'documentVersion')
    ..aOS(10, _omitFieldNames ? '' : 'supersededBy')
    ..aOS(11, _omitFieldNames ? '' : 'correctsInvoiceId')
    ..pPM<InvoiceLine>(12, _omitFieldNames ? '' : 'lines',
        subBuilder: InvoiceLine.create)
    ..aOM<Money>(13, _omitFieldNames ? '' : 'subtotal',
        subBuilder: Money.create)
    ..aOM<Money>(14, _omitFieldNames ? '' : 'discount',
        subBuilder: Money.create)
    ..aOM<Money>(15, _omitFieldNames ? '' : 'tax', subBuilder: Money.create)
    ..aOM<Money>(16, _omitFieldNames ? '' : 'total', subBuilder: Money.create)
    ..pPM<Discount>(17, _omitFieldNames ? '' : 'discounts',
        subBuilder: Discount.create)
    ..pPM<LiabilityShare>(18, _omitFieldNames ? '' : 'liability',
        subBuilder: LiabilityShare.create)
    ..aOS(19, _omitFieldNames ? '' : 'payerId')
    ..aOS(20, _omitFieldNames ? '' : 'customerId')
    ..aOS(21, _omitFieldNames ? '' : 'notes')
    ..aOS(22, _omitFieldNames ? '' : 'issuedBy')
    ..aOM<$0.Timestamp>(23, _omitFieldNames ? '' : 'issuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(24, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(25, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
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

  /// What the patient quotes. From the platform's numbering sequence, so it is
  /// gapless and collision-free.
  @$pb.TagNumber(2)
  $core.String get number => $_getSZ(1);
  @$pb.TagNumber(2)
  set number($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  DocumentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(DocumentKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  InvoiceStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(InvoiceStatus value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get accountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set accountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccountId() => $_clearField(5);

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
  $core.String get facilityId => $_getSZ(7);
  @$pb.TagNumber(8)
  set facilityId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFacilityId() => $_has(7);
  @$pb.TagNumber(8)
  void clearFacilityId() => $_clearField(8);

  /// An estimate re-quoted after the plan changes is a new version, and the
  /// patient was shown the old one.
  @$pb.TagNumber(9)
  $core.int get documentVersion => $_getIZ(8);
  @$pb.TagNumber(9)
  set documentVersion($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDocumentVersion() => $_has(8);
  @$pb.TagNumber(9)
  void clearDocumentVersion() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get supersededBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set supersededBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSupersededBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearSupersededBy() => $_clearField(10);

  /// The document a credit or debit note corrects.
  @$pb.TagNumber(11)
  $core.String get correctsInvoiceId => $_getSZ(10);
  @$pb.TagNumber(11)
  set correctsInvoiceId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCorrectsInvoiceId() => $_has(10);
  @$pb.TagNumber(11)
  void clearCorrectsInvoiceId() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<InvoiceLine> get lines => $_getList(11);

  /// Carried rather than left to the client to sum: a client that recomputed
  /// would eventually round differently and show a figure the hospital never
  /// charged.
  @$pb.TagNumber(13)
  Money get subtotal => $_getN(12);
  @$pb.TagNumber(13)
  set subtotal(Money value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasSubtotal() => $_has(12);
  @$pb.TagNumber(13)
  void clearSubtotal() => $_clearField(13);
  @$pb.TagNumber(13)
  Money ensureSubtotal() => $_ensure(12);

  @$pb.TagNumber(14)
  Money get discount => $_getN(13);
  @$pb.TagNumber(14)
  set discount(Money value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasDiscount() => $_has(13);
  @$pb.TagNumber(14)
  void clearDiscount() => $_clearField(14);
  @$pb.TagNumber(14)
  Money ensureDiscount() => $_ensure(13);

  @$pb.TagNumber(15)
  Money get tax => $_getN(14);
  @$pb.TagNumber(15)
  set tax(Money value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasTax() => $_has(14);
  @$pb.TagNumber(15)
  void clearTax() => $_clearField(15);
  @$pb.TagNumber(15)
  Money ensureTax() => $_ensure(14);

  @$pb.TagNumber(16)
  Money get total => $_getN(15);
  @$pb.TagNumber(16)
  set total(Money value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasTotal() => $_has(15);
  @$pb.TagNumber(16)
  void clearTotal() => $_clearField(16);
  @$pb.TagNumber(16)
  Money ensureTotal() => $_ensure(15);

  @$pb.TagNumber(17)
  $pb.PbList<Discount> get discounts => $_getList(16);

  @$pb.TagNumber(18)
  $pb.PbList<LiabilityShare> get liability => $_getList(17);

  @$pb.TagNumber(19)
  $core.String get payerId => $_getSZ(18);
  @$pb.TagNumber(19)
  set payerId($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasPayerId() => $_has(18);
  @$pb.TagNumber(19)
  void clearPayerId() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get customerId => $_getSZ(19);
  @$pb.TagNumber(20)
  set customerId($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasCustomerId() => $_has(19);
  @$pb.TagNumber(20)
  void clearCustomerId() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get notes => $_getSZ(20);
  @$pb.TagNumber(21)
  set notes($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasNotes() => $_has(20);
  @$pb.TagNumber(21)
  void clearNotes() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get issuedBy => $_getSZ(21);
  @$pb.TagNumber(22)
  set issuedBy($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasIssuedBy() => $_has(21);
  @$pb.TagNumber(22)
  void clearIssuedBy() => $_clearField(22);

  @$pb.TagNumber(23)
  $0.Timestamp get issuedAt => $_getN(22);
  @$pb.TagNumber(23)
  set issuedAt($0.Timestamp value) => $_setField(23, value);
  @$pb.TagNumber(23)
  $core.bool hasIssuedAt() => $_has(22);
  @$pb.TagNumber(23)
  void clearIssuedAt() => $_clearField(23);
  @$pb.TagNumber(23)
  $0.Timestamp ensureIssuedAt() => $_ensure(22);

  @$pb.TagNumber(24)
  $core.String get createdBy => $_getSZ(23);
  @$pb.TagNumber(24)
  set createdBy($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasCreatedBy() => $_has(23);
  @$pb.TagNumber(24)
  void clearCreatedBy() => $_clearField(24);

  @$pb.TagNumber(25)
  $0.Timestamp get createdAt => $_getN(24);
  @$pb.TagNumber(25)
  set createdAt($0.Timestamp value) => $_setField(25, value);
  @$pb.TagNumber(25)
  $core.bool hasCreatedAt() => $_has(24);
  @$pb.TagNumber(25)
  void clearCreatedAt() => $_clearField(25);
  @$pb.TagNumber(25)
  $0.Timestamp ensureCreatedAt() => $_ensure(24);
}

/// One movement on an account (SRS-BIL-012).
///
/// Append-only. A correction is another entry.
class LedgerEntry extends $pb.GeneratedMessage {
  factory LedgerEntry({
    $core.String? entryId,
    $core.String? accountId,
    $core.String? patientId,
    $core.String? encounterId,
    EntryKind? kind,
    Money? amount,
    $core.String? invoiceId,
    $core.String? paymentId,
    $core.String? refundOfPaymentId,
    PaymentMethod? method,
    $core.String? providerRef,
    $core.String? receiptNumber,
    $core.String? shiftId,
    $core.String? reason,
    $core.String? recordedBy,
    $core.String? approvedBy,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (accountId != null) result.accountId = accountId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (amount != null) result.amount = amount;
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (paymentId != null) result.paymentId = paymentId;
    if (refundOfPaymentId != null) result.refundOfPaymentId = refundOfPaymentId;
    if (method != null) result.method = method;
    if (providerRef != null) result.providerRef = providerRef;
    if (receiptNumber != null) result.receiptNumber = receiptNumber;
    if (shiftId != null) result.shiftId = shiftId;
    if (reason != null) result.reason = reason;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  LedgerEntry._();

  factory LedgerEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory LedgerEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LedgerEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOS(2, _omitFieldNames ? '' : 'accountId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aE<EntryKind>(5, _omitFieldNames ? '' : 'kind',
        enumValues: EntryKind.values)
    ..aOM<Money>(6, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aOS(7, _omitFieldNames ? '' : 'invoiceId')
    ..aOS(8, _omitFieldNames ? '' : 'paymentId')
    ..aOS(9, _omitFieldNames ? '' : 'refundOfPaymentId')
    ..aE<PaymentMethod>(10, _omitFieldNames ? '' : 'method',
        enumValues: PaymentMethod.values)
    ..aOS(11, _omitFieldNames ? '' : 'providerRef')
    ..aOS(12, _omitFieldNames ? '' : 'receiptNumber')
    ..aOS(13, _omitFieldNames ? '' : 'shiftId')
    ..aOS(14, _omitFieldNames ? '' : 'reason')
    ..aOS(15, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(16, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LedgerEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LedgerEntry copyWith(void Function(LedgerEntry) updates) =>
      super.copyWith((message) => updates(message as LedgerEntry))
          as LedgerEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LedgerEntry create() => LedgerEntry._();
  @$core.override
  LedgerEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static LedgerEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LedgerEntry>(create);
  static LedgerEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountId() => $_clearField(2);

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
  EntryKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(EntryKind value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  /// Signed: positive increases what the patient owes.
  @$pb.TagNumber(6)
  Money get amount => $_getN(5);
  @$pb.TagNumber(6)
  set amount(Money value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAmount() => $_has(5);
  @$pb.TagNumber(6)
  void clearAmount() => $_clearField(6);
  @$pb.TagNumber(6)
  Money ensureAmount() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get invoiceId => $_getSZ(6);
  @$pb.TagNumber(7)
  set invoiceId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasInvoiceId() => $_has(6);
  @$pb.TagNumber(7)
  void clearInvoiceId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get paymentId => $_getSZ(7);
  @$pb.TagNumber(8)
  set paymentId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasPaymentId() => $_has(7);
  @$pb.TagNumber(8)
  void clearPaymentId() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get refundOfPaymentId => $_getSZ(8);
  @$pb.TagNumber(9)
  set refundOfPaymentId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRefundOfPaymentId() => $_has(8);
  @$pb.TagNumber(9)
  void clearRefundOfPaymentId() => $_clearField(9);

  @$pb.TagNumber(10)
  PaymentMethod get method => $_getN(9);
  @$pb.TagNumber(10)
  set method(PaymentMethod value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasMethod() => $_has(9);
  @$pb.TagNumber(10)
  void clearMethod() => $_clearField(10);

  /// The gateway's or bank's own identifier — what a reconciliation is done
  /// against. Deliberately not a card number or any other secret.
  @$pb.TagNumber(11)
  $core.String get providerRef => $_getSZ(10);
  @$pb.TagNumber(11)
  set providerRef($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasProviderRef() => $_has(10);
  @$pb.TagNumber(11)
  void clearProviderRef() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get receiptNumber => $_getSZ(11);
  @$pb.TagNumber(12)
  set receiptNumber($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasReceiptNumber() => $_has(11);
  @$pb.TagNumber(12)
  void clearReceiptNumber() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get shiftId => $_getSZ(12);
  @$pb.TagNumber(13)
  set shiftId($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasShiftId() => $_has(12);
  @$pb.TagNumber(13)
  void clearShiftId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get reason => $_getSZ(13);
  @$pb.TagNumber(14)
  set reason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearReason() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get recordedBy => $_getSZ(14);
  @$pb.TagNumber(15)
  set recordedBy($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasRecordedBy() => $_has(14);
  @$pb.TagNumber(15)
  void clearRecordedBy() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get approvedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set approvedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasApprovedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearApprovedBy() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get occurredAt => $_getN(16);
  @$pb.TagNumber(17)
  set occurredAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasOccurredAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearOccurredAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureOccurredAt() => $_ensure(16);
}

class Account extends $pb.GeneratedMessage {
  factory Account({
    $core.String? accountId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? facilityId,
    $core.String? currency,
    $core.String? payerId,
    $core.String? customerId,
    $core.String? roomClass,
    $core.String? packageCode,
    AccountStatus? status,
    $core.String? closedBy,
    $0.Timestamp? closedAt,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (facilityId != null) result.facilityId = facilityId;
    if (currency != null) result.currency = currency;
    if (payerId != null) result.payerId = payerId;
    if (customerId != null) result.customerId = customerId;
    if (roomClass != null) result.roomClass = roomClass;
    if (packageCode != null) result.packageCode = packageCode;
    if (status != null) result.status = status;
    if (closedBy != null) result.closedBy = closedBy;
    if (closedAt != null) result.closedAt = closedAt;
    return result;
  }

  Account._();

  factory Account.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Account.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Account',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'facilityId')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..aOS(6, _omitFieldNames ? '' : 'payerId')
    ..aOS(7, _omitFieldNames ? '' : 'customerId')
    ..aOS(8, _omitFieldNames ? '' : 'roomClass')
    ..aOS(9, _omitFieldNames ? '' : 'packageCode')
    ..aE<AccountStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: AccountStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'closedBy')
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Account copyWith(void Function(Account) updates) =>
      super.copyWith((message) => updates(message as Account)) as Account;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Account create() => Account._();
  @$core.override
  Account createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Account getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Account>(create);
  static Account? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

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
  $core.String get facilityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set facilityId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFacilityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearFacilityId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get payerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set payerId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPayerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayerId() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get customerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set customerId($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCustomerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearCustomerId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get roomClass => $_getSZ(7);
  @$pb.TagNumber(8)
  set roomClass($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRoomClass() => $_has(7);
  @$pb.TagNumber(8)
  void clearRoomClass() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get packageCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set packageCode($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasPackageCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearPackageCode() => $_clearField(9);

  @$pb.TagNumber(10)
  AccountStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(AccountStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get closedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set closedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasClosedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearClosedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get closedAt => $_getN(11);
  @$pb.TagNumber(12)
  set closedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasClosedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearClosedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureClosedAt() => $_ensure(11);
}

/// A reason an account cannot close yet (SRS-BIL-013).
class CloseException extends $pb.GeneratedMessage {
  factory CloseException({
    $core.String? check_1,
    $core.String? detail,
    Money? amount,
    $core.Iterable<$core.String>? references,
  }) {
    final result = create();
    if (check_1 != null) result.check_1 = check_1;
    if (detail != null) result.detail = detail;
    if (amount != null) result.amount = amount;
    if (references != null) result.references.addAll(references);
    return result;
  }

  CloseException._();

  factory CloseException.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseException.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseException',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'check')
    ..aOS(2, _omitFieldNames ? '' : 'detail')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..pPS(4, _omitFieldNames ? '' : 'references')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseException clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseException copyWith(void Function(CloseException) updates) =>
      super.copyWith((message) => updates(message as CloseException))
          as CloseException;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseException create() => CloseException._();
  @$core.override
  CloseException createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseException getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseException>(create);
  static CloseException? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get check_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set check_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheck_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheck_1() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get detail => $_getSZ(1);
  @$pb.TagNumber(2)
  set detail($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDetail() => $_has(1);
  @$pb.TagNumber(2)
  void clearDetail() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureAmount() => $_ensure(2);

  /// The records to fix. A worklist that says "something is outstanding"
  /// without saying which is one nobody can work.
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get references => $_getList(3);
}

/// One cashier's session at one drawer (SRS-BIL-015).
class Shift extends $pb.GeneratedMessage {
  factory Shift({
    $core.String? shiftId,
    $core.String? facilityId,
    $core.String? counterId,
    $core.String? cashierId,
    Money? openingFloat,
    $0.Timestamp? openedAt,
    Money? countedCash,
    Money? expectedCash,
    Money? variance,
    ShiftStatus? status,
    $core.String? varianceReason,
    $core.String? approvedBy,
    $0.Timestamp? closedAt,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    if (facilityId != null) result.facilityId = facilityId;
    if (counterId != null) result.counterId = counterId;
    if (cashierId != null) result.cashierId = cashierId;
    if (openingFloat != null) result.openingFloat = openingFloat;
    if (openedAt != null) result.openedAt = openedAt;
    if (countedCash != null) result.countedCash = countedCash;
    if (expectedCash != null) result.expectedCash = expectedCash;
    if (variance != null) result.variance = variance;
    if (status != null) result.status = status;
    if (varianceReason != null) result.varianceReason = varianceReason;
    if (approvedBy != null) result.approvedBy = approvedBy;
    if (closedAt != null) result.closedAt = closedAt;
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOS(3, _omitFieldNames ? '' : 'counterId')
    ..aOS(4, _omitFieldNames ? '' : 'cashierId')
    ..aOM<Money>(5, _omitFieldNames ? '' : 'openingFloat',
        subBuilder: Money.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'openedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<Money>(7, _omitFieldNames ? '' : 'countedCash',
        subBuilder: Money.create)
    ..aOM<Money>(8, _omitFieldNames ? '' : 'expectedCash',
        subBuilder: Money.create)
    ..aOM<Money>(9, _omitFieldNames ? '' : 'variance', subBuilder: Money.create)
    ..aE<ShiftStatus>(10, _omitFieldNames ? '' : 'status',
        enumValues: ShiftStatus.values)
    ..aOS(11, _omitFieldNames ? '' : 'varianceReason')
    ..aOS(12, _omitFieldNames ? '' : 'approvedBy')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'closedAt',
        subBuilder: $0.Timestamp.create)
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
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get counterId => $_getSZ(2);
  @$pb.TagNumber(3)
  set counterId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCounterId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCounterId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get cashierId => $_getSZ(3);
  @$pb.TagNumber(4)
  set cashierId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCashierId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCashierId() => $_clearField(4);

  @$pb.TagNumber(5)
  Money get openingFloat => $_getN(4);
  @$pb.TagNumber(5)
  set openingFloat(Money value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOpeningFloat() => $_has(4);
  @$pb.TagNumber(5)
  void clearOpeningFloat() => $_clearField(5);
  @$pb.TagNumber(5)
  Money ensureOpeningFloat() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get openedAt => $_getN(5);
  @$pb.TagNumber(6)
  set openedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOpenedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOpenedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOpenedAt() => $_ensure(5);

  /// What the cashier physically counted.
  @$pb.TagNumber(7)
  Money get countedCash => $_getN(6);
  @$pb.TagNumber(7)
  set countedCash(Money value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCountedCash() => $_has(6);
  @$pb.TagNumber(7)
  void clearCountedCash() => $_clearField(7);
  @$pb.TagNumber(7)
  Money ensureCountedCash() => $_ensure(6);

  /// The float plus the cash movements recorded against the shift, computed from
  /// the ledger rather than typed — so a cashier cannot make the count agree by
  /// adjusting the expectation.
  @$pb.TagNumber(8)
  Money get expectedCash => $_getN(7);
  @$pb.TagNumber(8)
  set expectedCash(Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpectedCash() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpectedCash() => $_clearField(8);
  @$pb.TagNumber(8)
  Money ensureExpectedCash() => $_ensure(7);

  @$pb.TagNumber(9)
  Money get variance => $_getN(8);
  @$pb.TagNumber(9)
  set variance(Money value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasVariance() => $_has(8);
  @$pb.TagNumber(9)
  void clearVariance() => $_clearField(9);
  @$pb.TagNumber(9)
  Money ensureVariance() => $_ensure(8);

  @$pb.TagNumber(10)
  ShiftStatus get status => $_getN(9);
  @$pb.TagNumber(10)
  set status(ShiftStatus value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasStatus() => $_has(9);
  @$pb.TagNumber(10)
  void clearStatus() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get varianceReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set varianceReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVarianceReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearVarianceReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get approvedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set approvedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasApprovedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearApprovedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get closedAt => $_getN(12);
  @$pb.TagNumber(13)
  set closedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasClosedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearClosedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureClosedAt() => $_ensure(12);
}

class RevenueException extends $pb.GeneratedMessage {
  factory RevenueException({
    ExceptionKind? kind,
    $core.String? accountId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? chargeId,
    SourceReference? source,
    $core.String? detail,
    Money? amount,
    $fixnum.Int64? ageSeconds,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (accountId != null) result.accountId = accountId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (chargeId != null) result.chargeId = chargeId;
    if (source != null) result.source = source;
    if (detail != null) result.detail = detail;
    if (amount != null) result.amount = amount;
    if (ageSeconds != null) result.ageSeconds = ageSeconds;
    return result;
  }

  RevenueException._();

  factory RevenueException.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevenueException.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevenueException',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aE<ExceptionKind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: ExceptionKind.values)
    ..aOS(2, _omitFieldNames ? '' : 'accountId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'chargeId')
    ..aOM<SourceReference>(6, _omitFieldNames ? '' : 'source',
        subBuilder: SourceReference.create)
    ..aOS(7, _omitFieldNames ? '' : 'detail')
    ..aOM<Money>(8, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aInt64(9, _omitFieldNames ? '' : 'ageSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueException clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueException copyWith(void Function(RevenueException) updates) =>
      super.copyWith((message) => updates(message as RevenueException))
          as RevenueException;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevenueException create() => RevenueException._();
  @$core.override
  RevenueException createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevenueException getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevenueException>(create);
  static RevenueException? _defaultInstance;

  @$pb.TagNumber(1)
  ExceptionKind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(ExceptionKind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get accountId => $_getSZ(1);
  @$pb.TagNumber(2)
  set accountId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAccountId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccountId() => $_clearField(2);

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
  $core.String get chargeId => $_getSZ(4);
  @$pb.TagNumber(5)
  set chargeId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasChargeId() => $_has(4);
  @$pb.TagNumber(5)
  void clearChargeId() => $_clearField(5);

  @$pb.TagNumber(6)
  SourceReference get source => $_getN(5);
  @$pb.TagNumber(6)
  set source(SourceReference value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSource() => $_has(5);
  @$pb.TagNumber(6)
  void clearSource() => $_clearField(6);
  @$pb.TagNumber(6)
  SourceReference ensureSource() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get detail => $_getSZ(6);
  @$pb.TagNumber(7)
  set detail($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDetail() => $_has(6);
  @$pb.TagNumber(7)
  void clearDetail() => $_clearField(7);

  @$pb.TagNumber(8)
  Money get amount => $_getN(7);
  @$pb.TagNumber(8)
  set amount(Money value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAmount() => $_has(7);
  @$pb.TagNumber(8)
  void clearAmount() => $_clearField(8);
  @$pb.TagNumber(8)
  Money ensureAmount() => $_ensure(7);

  /// How long it has been outstanding, in seconds. A charge held since yesterday
  /// is a query; one held since last month is a loss.
  @$pb.TagNumber(9)
  $fixnum.Int64 get ageSeconds => $_getI64(8);
  @$pb.TagNumber(9)
  set ageSeconds($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAgeSeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearAgeSeconds() => $_clearField(9);
}

/// A completed clinical service the biller expects to see (SRS-BIL-011).
class BillableEvent extends $pb.GeneratedMessage {
  factory BillableEvent({
    SourceReference? source,
    $core.String? serviceCode,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? accountId,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (accountId != null) result.accountId = accountId;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  BillableEvent._();

  factory BillableEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BillableEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BillableEvent',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<SourceReference>(1, _omitFieldNames ? '' : 'source',
        subBuilder: SourceReference.create)
    ..aOS(2, _omitFieldNames ? '' : 'serviceCode')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'encounterId')
    ..aOS(5, _omitFieldNames ? '' : 'accountId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillableEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillableEvent copyWith(void Function(BillableEvent) updates) =>
      super.copyWith((message) => updates(message as BillableEvent))
          as BillableEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BillableEvent create() => BillableEvent._();
  @$core.override
  BillableEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BillableEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BillableEvent>(create);
  static BillableEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SourceReference get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(SourceReference value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  SourceReference ensureSource() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get serviceCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceCode() => $_clearField(2);

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
  $core.String get accountId => $_getSZ(4);
  @$pb.TagNumber(5)
  set accountId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAccountId() => $_has(4);
  @$pb.TagNumber(5)
  void clearAccountId() => $_clearField(5);

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

/// What a role may give without approval (SRS-BIL-007).
class DiscountLimit extends $pb.GeneratedMessage {
  factory DiscountLimit({
    $core.int? maxRateBp,
    Money? maxAmount,
  }) {
    final result = create();
    if (maxRateBp != null) result.maxRateBp = maxRateBp;
    if (maxAmount != null) result.maxAmount = maxAmount;
    return result;
  }

  DiscountLimit._();

  factory DiscountLimit.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscountLimit.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscountLimit',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'maxRateBp')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'maxAmount',
        subBuilder: Money.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscountLimit clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscountLimit copyWith(void Function(DiscountLimit) updates) =>
      super.copyWith((message) => updates(message as DiscountLimit))
          as DiscountLimit;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscountLimit create() => DiscountLimit._();
  @$core.override
  DiscountLimit createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscountLimit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscountLimit>(create);
  static DiscountLimit? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get maxRateBp => $_getIZ(0);
  @$pb.TagNumber(1)
  set maxRateBp($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMaxRateBp() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxRateBp() => $_clearField(1);

  /// Both bounds apply: 5% of a half-million-rupee bill is not a small decision
  /// even though the rate is.
  @$pb.TagNumber(2)
  Money get maxAmount => $_getN(1);
  @$pb.TagNumber(2)
  set maxAmount(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMaxAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureMaxAmount() => $_ensure(1);
}

class BillingPolicy extends $pb.GeneratedMessage {
  factory BillingPolicy({
    $core.Iterable<$core.MapEntry<$core.String, DiscountLimit>>? discountLimits,
    $core.Iterable<$core.String>? closeChecks,
    $core.bool? allowPayerBalance,
    $fixnum.Int64? varianceThresholdMinor,
    $core.String? currency,
  }) {
    final result = create();
    if (discountLimits != null)
      result.discountLimits.addEntries(discountLimits);
    if (closeChecks != null) result.closeChecks.addAll(closeChecks);
    if (allowPayerBalance != null) result.allowPayerBalance = allowPayerBalance;
    if (varianceThresholdMinor != null)
      result.varianceThresholdMinor = varianceThresholdMinor;
    if (currency != null) result.currency = currency;
    return result;
  }

  BillingPolicy._();

  factory BillingPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BillingPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BillingPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..m<$core.String, DiscountLimit>(1, _omitFieldNames ? '' : 'discountLimits',
        entryClassName: 'BillingPolicy.DiscountLimitsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OM,
        valueCreator: DiscountLimit.create,
        valueDefaultOrMaker: DiscountLimit.getDefault,
        packageName: const $pb.PackageName('healthcare.billing.v1'))
    ..pPS(2, _omitFieldNames ? '' : 'closeChecks')
    ..aOB(3, _omitFieldNames ? '' : 'allowPayerBalance')
    ..aInt64(4, _omitFieldNames ? '' : 'varianceThresholdMinor')
    ..aOS(5, _omitFieldNames ? '' : 'currency')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillingPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BillingPolicy copyWith(void Function(BillingPolicy) updates) =>
      super.copyWith((message) => updates(message as BillingPolicy))
          as BillingPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BillingPolicy create() => BillingPolicy._();
  @$core.override
  BillingPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BillingPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BillingPolicy>(create);
  static BillingPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbMap<$core.String, DiscountLimit> get discountLimits => $_getMap(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get closeChecks => $_getList(1);

  /// An insurer's ninety-day settlement is not a reason to keep a discharged
  /// patient's account open.
  @$pb.TagNumber(3)
  $core.bool get allowPayerBalance => $_getBF(2);
  @$pb.TagNumber(3)
  set allowPayerBalance($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAllowPayerBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearAllowPayerBalance() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get varianceThresholdMinor => $_getI64(3);
  @$pb.TagNumber(4)
  set varianceThresholdMinor($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVarianceThresholdMinor() => $_has(3);
  @$pb.TagNumber(4)
  void clearVarianceThresholdMinor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get currency => $_getSZ(4);
  @$pb.TagNumber(5)
  set currency($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCurrency() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrency() => $_clearField(5);
}

class OpenAccountRequest extends $pb.GeneratedMessage {
  factory OpenAccountRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? currency,
    $core.String? payerId,
    $core.String? customerId,
    $core.String? roomClass,
    $core.String? packageCode,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (currency != null) result.currency = currency;
    if (payerId != null) result.payerId = payerId;
    if (customerId != null) result.customerId = customerId;
    if (roomClass != null) result.roomClass = roomClass;
    if (packageCode != null) result.packageCode = packageCode;
    return result;
  }

  OpenAccountRequest._();

  factory OpenAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenAccountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'currency')
    ..aOS(4, _omitFieldNames ? '' : 'payerId')
    ..aOS(5, _omitFieldNames ? '' : 'customerId')
    ..aOS(6, _omitFieldNames ? '' : 'roomClass')
    ..aOS(7, _omitFieldNames ? '' : 'packageCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenAccountRequest copyWith(void Function(OpenAccountRequest) updates) =>
      super.copyWith((message) => updates(message as OpenAccountRequest))
          as OpenAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenAccountRequest create() => OpenAccountRequest._();
  @$core.override
  OpenAccountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenAccountRequest>(create);
  static OpenAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get currency => $_getSZ(2);
  @$pb.TagNumber(3)
  set currency($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCurrency() => $_has(2);
  @$pb.TagNumber(3)
  void clearCurrency() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get payerId => $_getSZ(3);
  @$pb.TagNumber(4)
  set payerId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPayerId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayerId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get customerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set customerId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCustomerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get roomClass => $_getSZ(5);
  @$pb.TagNumber(6)
  set roomClass($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoomClass() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoomClass() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get packageCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set packageCode($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPackageCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearPackageCode() => $_clearField(7);
}

class OpenAccountResponse extends $pb.GeneratedMessage {
  factory OpenAccountResponse({
    Account? account,
  }) {
    final result = create();
    if (account != null) result.account = account;
    return result;
  }

  OpenAccountResponse._();

  factory OpenAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenAccountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenAccountResponse copyWith(void Function(OpenAccountResponse) updates) =>
      super.copyWith((message) => updates(message as OpenAccountResponse))
          as OpenAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenAccountResponse create() => OpenAccountResponse._();
  @$core.override
  OpenAccountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenAccountResponse>(create);
  static OpenAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class GetAccountRequest extends $pb.GeneratedMessage {
  factory GetAccountRequest({
    $core.String? accountId,
    $core.String? encounterId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (encounterId != null) result.encounterId = encounterId;
    return result;
  }

  GetAccountRequest._();

  factory GetAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountRequest copyWith(void Function(GetAccountRequest) updates) =>
      super.copyWith((message) => updates(message as GetAccountRequest))
          as GetAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountRequest create() => GetAccountRequest._();
  @$core.override
  GetAccountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAccountRequest>(create);
  static GetAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  /// Either identifier. An encounter is what a ward knows; an account is what
  /// billing knows.
  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);
}

class GetAccountResponse extends $pb.GeneratedMessage {
  factory GetAccountResponse({
    Account? account,
  }) {
    final result = create();
    if (account != null) result.account = account;
    return result;
  }

  GetAccountResponse._();

  factory GetAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetAccountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetAccountResponse copyWith(void Function(GetAccountResponse) updates) =>
      super.copyWith((message) => updates(message as GetAccountResponse))
          as GetAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAccountResponse create() => GetAccountResponse._();
  @$core.override
  GetAccountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetAccountResponse>(create);
  static GetAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);
}

class PostChargeRequest extends $pb.GeneratedMessage {
  factory PostChargeRequest({
    $core.String? accountId,
    $core.String? serviceCode,
    $core.int? quantity,
    ChargeOrigin? origin,
    SourceReference? source,
    $core.String? reason,
    $0.Timestamp? occurredAt,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (quantity != null) result.quantity = quantity;
    if (origin != null) result.origin = origin;
    if (source != null) result.source = source;
    if (reason != null) result.reason = reason;
    if (occurredAt != null) result.occurredAt = occurredAt;
    return result;
  }

  PostChargeRequest._();

  factory PostChargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostChargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostChargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceCode')
    ..aI(3, _omitFieldNames ? '' : 'quantity')
    ..aE<ChargeOrigin>(4, _omitFieldNames ? '' : 'origin',
        enumValues: ChargeOrigin.values)
    ..aOM<SourceReference>(5, _omitFieldNames ? '' : 'source',
        subBuilder: SourceReference.create)
    ..aOS(6, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'occurredAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostChargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostChargeRequest copyWith(void Function(PostChargeRequest) updates) =>
      super.copyWith((message) => updates(message as PostChargeRequest))
          as PostChargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostChargeRequest create() => PostChargeRequest._();
  @$core.override
  PostChargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PostChargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostChargeRequest>(create);
  static PostChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  ChargeOrigin get origin => $_getN(3);
  @$pb.TagNumber(4)
  set origin(ChargeOrigin value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOrigin() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrigin() => $_clearField(4);

  @$pb.TagNumber(5)
  SourceReference get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(SourceReference value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);
  @$pb.TagNumber(5)
  SourceReference ensureSource() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get reason => $_getSZ(5);
  @$pb.TagNumber(6)
  set reason($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasReason() => $_has(5);
  @$pb.TagNumber(6)
  void clearReason() => $_clearField(6);

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

class PostChargeResponse extends $pb.GeneratedMessage {
  factory PostChargeResponse({
    Charge? charge,
    $core.bool? alreadyPosted,
    Consumption? consumption,
  }) {
    final result = create();
    if (charge != null) result.charge = charge;
    if (alreadyPosted != null) result.alreadyPosted = alreadyPosted;
    if (consumption != null) result.consumption = consumption;
    return result;
  }

  PostChargeResponse._();

  factory PostChargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PostChargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PostChargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Charge>(1, _omitFieldNames ? '' : 'charge', subBuilder: Charge.create)
    ..aOB(2, _omitFieldNames ? '' : 'alreadyPosted')
    ..aOM<Consumption>(3, _omitFieldNames ? '' : 'consumption',
        subBuilder: Consumption.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostChargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PostChargeResponse copyWith(void Function(PostChargeResponse) updates) =>
      super.copyWith((message) => updates(message as PostChargeResponse))
          as PostChargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PostChargeResponse create() => PostChargeResponse._();
  @$core.override
  PostChargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PostChargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PostChargeResponse>(create);
  static PostChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Charge get charge => $_getN(0);
  @$pb.TagNumber(1)
  set charge(Charge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharge() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharge() => $_clearField(1);
  @$pb.TagNumber(1)
  Charge ensureCharge() => $_ensure(0);

  /// A redelivered clinical event: the charge returned is the one that was
  /// already there, and nothing was written.
  @$pb.TagNumber(2)
  $core.bool get alreadyPosted => $_getBF(1);
  @$pb.TagNumber(2)
  set alreadyPosted($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlreadyPosted() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlreadyPosted() => $_clearField(2);

  @$pb.TagNumber(3)
  Consumption get consumption => $_getN(2);
  @$pb.TagNumber(3)
  set consumption(Consumption value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasConsumption() => $_has(2);
  @$pb.TagNumber(3)
  void clearConsumption() => $_clearField(3);
  @$pb.TagNumber(3)
  Consumption ensureConsumption() => $_ensure(2);
}

class ChangeChargeRequest extends $pb.GeneratedMessage {
  factory ChangeChargeRequest({
    $core.String? chargeId,
    $core.String? reason,
  }) {
    final result = create();
    if (chargeId != null) result.chargeId = chargeId;
    if (reason != null) result.reason = reason;
    return result;
  }

  ChangeChargeRequest._();

  factory ChangeChargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeChargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeChargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chargeId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeChargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeChargeRequest copyWith(void Function(ChangeChargeRequest) updates) =>
      super.copyWith((message) => updates(message as ChangeChargeRequest))
          as ChangeChargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeChargeRequest create() => ChangeChargeRequest._();
  @$core.override
  ChangeChargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeChargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeChargeRequest>(create);
  static ChangeChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chargeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set chargeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChargeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChargeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class ChangeChargeResponse extends $pb.GeneratedMessage {
  factory ChangeChargeResponse({
    Charge? charge,
  }) {
    final result = create();
    if (charge != null) result.charge = charge;
    return result;
  }

  ChangeChargeResponse._();

  factory ChangeChargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChangeChargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChangeChargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Charge>(1, _omitFieldNames ? '' : 'charge', subBuilder: Charge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeChargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChangeChargeResponse copyWith(void Function(ChangeChargeResponse) updates) =>
      super.copyWith((message) => updates(message as ChangeChargeResponse))
          as ChangeChargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChangeChargeResponse create() => ChangeChargeResponse._();
  @$core.override
  ChangeChargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChangeChargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChangeChargeResponse>(create);
  static ChangeChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Charge get charge => $_getN(0);
  @$pb.TagNumber(1)
  set charge(Charge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharge() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharge() => $_clearField(1);
  @$pb.TagNumber(1)
  Charge ensureCharge() => $_ensure(0);
}

/// One request and response type per RPC, which is what lets any of the three
/// gain a field later without changing the other two: voiding a charge raised
/// against the wrong patient and holding one pending a coding query are
/// different acts, and the day one of them needs something the others do not is
/// the day a shared message becomes a breaking change.
class VoidChargeRequest extends $pb.GeneratedMessage {
  factory VoidChargeRequest({
    ChangeChargeRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  VoidChargeRequest._();

  factory VoidChargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoidChargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoidChargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeChargeRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeChargeRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidChargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidChargeRequest copyWith(void Function(VoidChargeRequest) updates) =>
      super.copyWith((message) => updates(message as VoidChargeRequest))
          as VoidChargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidChargeRequest create() => VoidChargeRequest._();
  @$core.override
  VoidChargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoidChargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoidChargeRequest>(create);
  static VoidChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeChargeRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeChargeRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeChargeRequest ensureChange() => $_ensure(0);
}

class VoidChargeResponse extends $pb.GeneratedMessage {
  factory VoidChargeResponse({
    Charge? charge,
  }) {
    final result = create();
    if (charge != null) result.charge = charge;
    return result;
  }

  VoidChargeResponse._();

  factory VoidChargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VoidChargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VoidChargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Charge>(1, _omitFieldNames ? '' : 'charge', subBuilder: Charge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidChargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VoidChargeResponse copyWith(void Function(VoidChargeResponse) updates) =>
      super.copyWith((message) => updates(message as VoidChargeResponse))
          as VoidChargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VoidChargeResponse create() => VoidChargeResponse._();
  @$core.override
  VoidChargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VoidChargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VoidChargeResponse>(create);
  static VoidChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Charge get charge => $_getN(0);
  @$pb.TagNumber(1)
  set charge(Charge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharge() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharge() => $_clearField(1);
  @$pb.TagNumber(1)
  Charge ensureCharge() => $_ensure(0);
}

class HoldChargeRequest extends $pb.GeneratedMessage {
  factory HoldChargeRequest({
    ChangeChargeRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  HoldChargeRequest._();

  factory HoldChargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldChargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldChargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeChargeRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeChargeRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldChargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldChargeRequest copyWith(void Function(HoldChargeRequest) updates) =>
      super.copyWith((message) => updates(message as HoldChargeRequest))
          as HoldChargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldChargeRequest create() => HoldChargeRequest._();
  @$core.override
  HoldChargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldChargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldChargeRequest>(create);
  static HoldChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeChargeRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeChargeRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeChargeRequest ensureChange() => $_ensure(0);
}

class HoldChargeResponse extends $pb.GeneratedMessage {
  factory HoldChargeResponse({
    Charge? charge,
  }) {
    final result = create();
    if (charge != null) result.charge = charge;
    return result;
  }

  HoldChargeResponse._();

  factory HoldChargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HoldChargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HoldChargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Charge>(1, _omitFieldNames ? '' : 'charge', subBuilder: Charge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldChargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HoldChargeResponse copyWith(void Function(HoldChargeResponse) updates) =>
      super.copyWith((message) => updates(message as HoldChargeResponse))
          as HoldChargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HoldChargeResponse create() => HoldChargeResponse._();
  @$core.override
  HoldChargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HoldChargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HoldChargeResponse>(create);
  static HoldChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Charge get charge => $_getN(0);
  @$pb.TagNumber(1)
  set charge(Charge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharge() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharge() => $_clearField(1);
  @$pb.TagNumber(1)
  Charge ensureCharge() => $_ensure(0);
}

class ReleaseChargeRequest extends $pb.GeneratedMessage {
  factory ReleaseChargeRequest({
    ChangeChargeRequest? change,
  }) {
    final result = create();
    if (change != null) result.change = change;
    return result;
  }

  ReleaseChargeRequest._();

  factory ReleaseChargeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseChargeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseChargeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<ChangeChargeRequest>(1, _omitFieldNames ? '' : 'change',
        subBuilder: ChangeChargeRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseChargeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseChargeRequest copyWith(void Function(ReleaseChargeRequest) updates) =>
      super.copyWith((message) => updates(message as ReleaseChargeRequest))
          as ReleaseChargeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseChargeRequest create() => ReleaseChargeRequest._();
  @$core.override
  ReleaseChargeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseChargeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseChargeRequest>(create);
  static ReleaseChargeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ChangeChargeRequest get change => $_getN(0);
  @$pb.TagNumber(1)
  set change(ChangeChargeRequest value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearChange() => $_clearField(1);
  @$pb.TagNumber(1)
  ChangeChargeRequest ensureChange() => $_ensure(0);
}

class ReleaseChargeResponse extends $pb.GeneratedMessage {
  factory ReleaseChargeResponse({
    Charge? charge,
  }) {
    final result = create();
    if (charge != null) result.charge = charge;
    return result;
  }

  ReleaseChargeResponse._();

  factory ReleaseChargeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReleaseChargeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReleaseChargeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Charge>(1, _omitFieldNames ? '' : 'charge', subBuilder: Charge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseChargeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReleaseChargeResponse copyWith(
          void Function(ReleaseChargeResponse) updates) =>
      super.copyWith((message) => updates(message as ReleaseChargeResponse))
          as ReleaseChargeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReleaseChargeResponse create() => ReleaseChargeResponse._();
  @$core.override
  ReleaseChargeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReleaseChargeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReleaseChargeResponse>(create);
  static ReleaseChargeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Charge get charge => $_getN(0);
  @$pb.TagNumber(1)
  set charge(Charge value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCharge() => $_has(0);
  @$pb.TagNumber(1)
  void clearCharge() => $_clearField(1);
  @$pb.TagNumber(1)
  Charge ensureCharge() => $_ensure(0);
}

class ListChargesRequest extends $pb.GeneratedMessage {
  factory ListChargesRequest({
    $core.String? accountId,
    $core.bool? billableOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (billableOnly != null) result.billableOnly = billableOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListChargesRequest._();

  factory ListChargesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChargesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChargesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOB(2, _omitFieldNames ? '' : 'billableOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChargesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChargesRequest copyWith(void Function(ListChargesRequest) updates) =>
      super.copyWith((message) => updates(message as ListChargesRequest))
          as ListChargesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChargesRequest create() => ListChargesRequest._();
  @$core.override
  ListChargesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChargesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChargesRequest>(create);
  static ListChargesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get billableOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set billableOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBillableOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearBillableOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListChargesResponse extends $pb.GeneratedMessage {
  factory ListChargesResponse({
    $core.Iterable<Charge>? charges,
  }) {
    final result = create();
    if (charges != null) result.charges.addAll(charges);
    return result;
  }

  ListChargesResponse._();

  factory ListChargesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListChargesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListChargesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<Charge>(1, _omitFieldNames ? '' : 'charges',
        subBuilder: Charge.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChargesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListChargesResponse copyWith(void Function(ListChargesResponse) updates) =>
      super.copyWith((message) => updates(message as ListChargesResponse))
          as ListChargesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListChargesResponse create() => ListChargesResponse._();
  @$core.override
  ListChargesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListChargesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListChargesResponse>(create);
  static ListChargesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Charge> get charges => $_getList(0);
}

class PackageLedgerRequest extends $pb.GeneratedMessage {
  factory PackageLedgerRequest({
    $core.String? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  PackageLedgerRequest._();

  factory PackageLedgerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageLedgerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageLedgerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageLedgerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageLedgerRequest copyWith(void Function(PackageLedgerRequest) updates) =>
      super.copyWith((message) => updates(message as PackageLedgerRequest))
          as PackageLedgerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageLedgerRequest create() => PackageLedgerRequest._();
  @$core.override
  PackageLedgerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageLedgerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageLedgerRequest>(create);
  static PackageLedgerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class PackageLedgerResponse extends $pb.GeneratedMessage {
  factory PackageLedgerResponse({
    $core.Iterable<Consumption>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  PackageLedgerResponse._();

  factory PackageLedgerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PackageLedgerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PackageLedgerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<Consumption>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: Consumption.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageLedgerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PackageLedgerResponse copyWith(
          void Function(PackageLedgerResponse) updates) =>
      super.copyWith((message) => updates(message as PackageLedgerResponse))
          as PackageLedgerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PackageLedgerResponse create() => PackageLedgerResponse._();
  @$core.override
  PackageLedgerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PackageLedgerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PackageLedgerResponse>(create);
  static PackageLedgerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Consumption> get entries => $_getList(0);
}

class RaiseInvoiceRequest extends $pb.GeneratedMessage {
  factory RaiseInvoiceRequest({
    $core.String? accountId,
    DocumentKind? kind,
    Discount? discount,
    $core.Iterable<LiabilityShare>? liability,
    $core.String? notes,
    $core.bool? issue,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (kind != null) result.kind = kind;
    if (discount != null) result.discount = discount;
    if (liability != null) result.liability.addAll(liability);
    if (notes != null) result.notes = notes;
    if (issue != null) result.issue = issue;
    return result;
  }

  RaiseInvoiceRequest._();

  factory RaiseInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aE<DocumentKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..aOM<Discount>(3, _omitFieldNames ? '' : 'discount',
        subBuilder: Discount.create)
    ..pPM<LiabilityShare>(4, _omitFieldNames ? '' : 'liability',
        subBuilder: LiabilityShare.create)
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..aOB(6, _omitFieldNames ? '' : 'issue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseInvoiceRequest copyWith(void Function(RaiseInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as RaiseInvoiceRequest))
          as RaiseInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseInvoiceRequest create() => RaiseInvoiceRequest._();
  @$core.override
  RaiseInvoiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseInvoiceRequest>(create);
  static RaiseInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  DocumentKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(DocumentKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  Discount get discount => $_getN(2);
  @$pb.TagNumber(3)
  set discount(Discount value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDiscount() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscount() => $_clearField(3);
  @$pb.TagNumber(3)
  Discount ensureDiscount() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<LiabilityShare> get liability => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  /// Finalise in the same call. A draft left behind whenever a client crashed
  /// between two calls is one somebody has to clean up, and it blocks the
  /// account close.
  @$pb.TagNumber(6)
  $core.bool get issue => $_getBF(5);
  @$pb.TagNumber(6)
  set issue($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIssue() => $_has(5);
  @$pb.TagNumber(6)
  void clearIssue() => $_clearField(6);
}

class RaiseInvoiceResponse extends $pb.GeneratedMessage {
  factory RaiseInvoiceResponse({
    Invoice? invoice,
  }) {
    final result = create();
    if (invoice != null) result.invoice = invoice;
    return result;
  }

  RaiseInvoiceResponse._();

  factory RaiseInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RaiseInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RaiseInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Invoice>(1, _omitFieldNames ? '' : 'invoice',
        subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RaiseInvoiceResponse copyWith(void Function(RaiseInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as RaiseInvoiceResponse))
          as RaiseInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RaiseInvoiceResponse create() => RaiseInvoiceResponse._();
  @$core.override
  RaiseInvoiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RaiseInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RaiseInvoiceResponse>(create);
  static RaiseInvoiceResponse? _defaultInstance;

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

class CorrectInvoiceRequest extends $pb.GeneratedMessage {
  factory CorrectInvoiceRequest({
    $core.String? invoiceId,
    DocumentKind? kind,
    $core.Iterable<InvoiceLine>? lines,
    $core.String? reason,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (kind != null) result.kind = kind;
    if (lines != null) result.lines.addAll(lines);
    if (reason != null) result.reason = reason;
    return result;
  }

  CorrectInvoiceRequest._();

  factory CorrectInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..aE<DocumentKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: DocumentKind.values)
    ..pPM<InvoiceLine>(3, _omitFieldNames ? '' : 'lines',
        subBuilder: InvoiceLine.create)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectInvoiceRequest copyWith(
          void Function(CorrectInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as CorrectInvoiceRequest))
          as CorrectInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectInvoiceRequest create() => CorrectInvoiceRequest._();
  @$core.override
  CorrectInvoiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectInvoiceRequest>(create);
  static CorrectInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoiceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoiceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);

  @$pb.TagNumber(2)
  DocumentKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(DocumentKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<InvoiceLine> get lines => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);
}

class CorrectInvoiceResponse extends $pb.GeneratedMessage {
  factory CorrectInvoiceResponse({
    Invoice? note,
  }) {
    final result = create();
    if (note != null) result.note = note;
    return result;
  }

  CorrectInvoiceResponse._();

  factory CorrectInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Invoice>(1, _omitFieldNames ? '' : 'note', subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectInvoiceResponse copyWith(
          void Function(CorrectInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as CorrectInvoiceResponse))
          as CorrectInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectInvoiceResponse create() => CorrectInvoiceResponse._();
  @$core.override
  CorrectInvoiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectInvoiceResponse>(create);
  static CorrectInvoiceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Invoice get note => $_getN(0);
  @$pb.TagNumber(1)
  set note(Invoice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNote() => $_has(0);
  @$pb.TagNumber(1)
  void clearNote() => $_clearField(1);
  @$pb.TagNumber(1)
  Invoice ensureNote() => $_ensure(0);
}

class GetInvoiceRequest extends $pb.GeneratedMessage {
  factory GetInvoiceRequest({
    $core.String? invoiceId,
  }) {
    final result = create();
    if (invoiceId != null) result.invoiceId = invoiceId;
    return result;
  }

  GetInvoiceRequest._();

  factory GetInvoiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInvoiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'invoiceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceRequest copyWith(void Function(GetInvoiceRequest) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceRequest))
          as GetInvoiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInvoiceRequest create() => GetInvoiceRequest._();
  @$core.override
  GetInvoiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceRequest>(create);
  static GetInvoiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get invoiceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set invoiceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInvoiceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInvoiceId() => $_clearField(1);
}

class GetInvoiceResponse extends $pb.GeneratedMessage {
  factory GetInvoiceResponse({
    Invoice? invoice,
  }) {
    final result = create();
    if (invoice != null) result.invoice = invoice;
    return result;
  }

  GetInvoiceResponse._();

  factory GetInvoiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetInvoiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetInvoiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Invoice>(1, _omitFieldNames ? '' : 'invoice',
        subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetInvoiceResponse copyWith(void Function(GetInvoiceResponse) updates) =>
      super.copyWith((message) => updates(message as GetInvoiceResponse))
          as GetInvoiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetInvoiceResponse create() => GetInvoiceResponse._();
  @$core.override
  GetInvoiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetInvoiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetInvoiceResponse>(create);
  static GetInvoiceResponse? _defaultInstance;

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

class ListInvoicesRequest extends $pb.GeneratedMessage {
  factory ListInvoicesRequest({
    $core.String? accountId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListInvoicesRequest._();

  factory ListInvoicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInvoicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvoicesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesRequest copyWith(void Function(ListInvoicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesRequest))
          as ListInvoicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInvoicesRequest create() => ListInvoicesRequest._();
  @$core.override
  ListInvoicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesRequest>(create);
  static ListInvoicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListInvoicesResponse extends $pb.GeneratedMessage {
  factory ListInvoicesResponse({
    $core.Iterable<Invoice>? invoices,
  }) {
    final result = create();
    if (invoices != null) result.invoices.addAll(invoices);
    return result;
  }

  ListInvoicesResponse._();

  factory ListInvoicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListInvoicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListInvoicesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<Invoice>(1, _omitFieldNames ? '' : 'invoices',
        subBuilder: Invoice.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListInvoicesResponse copyWith(void Function(ListInvoicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListInvoicesResponse))
          as ListInvoicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInvoicesResponse create() => ListInvoicesResponse._();
  @$core.override
  ListInvoicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListInvoicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListInvoicesResponse>(create);
  static ListInvoicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Invoice> get invoices => $_getList(0);
}

class ReceivePaymentRequest extends $pb.GeneratedMessage {
  factory ReceivePaymentRequest({
    $core.String? accountId,
    Money? amount,
    PaymentMethod? method,
    $core.String? providerRef,
    $core.String? invoiceId,
    $core.String? shiftId,
    $core.String? idempotencyKey,
    $core.bool? deposit,
    $core.String? reason,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (amount != null) result.amount = amount;
    if (method != null) result.method = method;
    if (providerRef != null) result.providerRef = providerRef;
    if (invoiceId != null) result.invoiceId = invoiceId;
    if (shiftId != null) result.shiftId = shiftId;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (deposit != null) result.deposit = deposit;
    if (reason != null) result.reason = reason;
    return result;
  }

  ReceivePaymentRequest._();

  factory ReceivePaymentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceivePaymentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceivePaymentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aE<PaymentMethod>(3, _omitFieldNames ? '' : 'method',
        enumValues: PaymentMethod.values)
    ..aOS(4, _omitFieldNames ? '' : 'providerRef')
    ..aOS(5, _omitFieldNames ? '' : 'invoiceId')
    ..aOS(6, _omitFieldNames ? '' : 'shiftId')
    ..aOS(7, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOB(8, _omitFieldNames ? '' : 'deposit')
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceivePaymentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceivePaymentRequest copyWith(
          void Function(ReceivePaymentRequest) updates) =>
      super.copyWith((message) => updates(message as ReceivePaymentRequest))
          as ReceivePaymentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceivePaymentRequest create() => ReceivePaymentRequest._();
  @$core.override
  ReceivePaymentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceivePaymentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceivePaymentRequest>(create);
  static ReceivePaymentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureAmount() => $_ensure(1);

  @$pb.TagNumber(3)
  PaymentMethod get method => $_getN(2);
  @$pb.TagNumber(3)
  set method(PaymentMethod value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMethod() => $_has(2);
  @$pb.TagNumber(3)
  void clearMethod() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get providerRef => $_getSZ(3);
  @$pb.TagNumber(4)
  set providerRef($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasProviderRef() => $_has(3);
  @$pb.TagNumber(4)
  void clearProviderRef() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get invoiceId => $_getSZ(4);
  @$pb.TagNumber(5)
  set invoiceId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasInvoiceId() => $_has(4);
  @$pb.TagNumber(5)
  void clearInvoiceId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get shiftId => $_getSZ(5);
  @$pb.TagNumber(6)
  set shiftId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasShiftId() => $_has(5);
  @$pb.TagNumber(6)
  void clearShiftId() => $_clearField(6);

  /// Makes a retried submission one payment. Supplied by the caller, because
  /// only the caller knows that its second attempt is the same attempt.
  @$pb.TagNumber(7)
  $core.String get idempotencyKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set idempotencyKey($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasIdempotencyKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearIdempotencyKey() => $_clearField(7);

  /// An advance taken before care rather than a payment against a bill.
  @$pb.TagNumber(8)
  $core.bool get deposit => $_getBF(7);
  @$pb.TagNumber(8)
  set deposit($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDeposit() => $_has(7);
  @$pb.TagNumber(8)
  void clearDeposit() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);
}

class ReceivePaymentResponse extends $pb.GeneratedMessage {
  factory ReceivePaymentResponse({
    LedgerEntry? entry,
    $core.bool? alreadyReceived,
    Money? balance,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    if (alreadyReceived != null) result.alreadyReceived = alreadyReceived;
    if (balance != null) result.balance = balance;
    return result;
  }

  ReceivePaymentResponse._();

  factory ReceivePaymentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReceivePaymentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReceivePaymentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<LedgerEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: LedgerEntry.create)
    ..aOB(2, _omitFieldNames ? '' : 'alreadyReceived')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'balance', subBuilder: Money.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceivePaymentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReceivePaymentResponse copyWith(
          void Function(ReceivePaymentResponse) updates) =>
      super.copyWith((message) => updates(message as ReceivePaymentResponse))
          as ReceivePaymentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReceivePaymentResponse create() => ReceivePaymentResponse._();
  @$core.override
  ReceivePaymentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReceivePaymentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceivePaymentResponse>(create);
  static ReceivePaymentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LedgerEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(LedgerEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  LedgerEntry ensureEntry() => $_ensure(0);

  /// A retried submission: the entry returned is the one that was already there,
  /// and no money moved twice.
  @$pb.TagNumber(2)
  $core.bool get alreadyReceived => $_getBF(1);
  @$pb.TagNumber(2)
  set alreadyReceived($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAlreadyReceived() => $_has(1);
  @$pb.TagNumber(2)
  void clearAlreadyReceived() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureBalance() => $_ensure(2);
}

class RefundRequest extends $pb.GeneratedMessage {
  factory RefundRequest({
    $core.String? accountId,
    $core.String? paymentId,
    Money? amount,
    $core.String? reason,
    $core.String? shiftId,
    $core.String? approvedBy,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (paymentId != null) result.paymentId = paymentId;
    if (amount != null) result.amount = amount;
    if (reason != null) result.reason = reason;
    if (shiftId != null) result.shiftId = shiftId;
    if (approvedBy != null) result.approvedBy = approvedBy;
    return result;
  }

  RefundRequest._();

  factory RefundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'paymentId')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'amount', subBuilder: Money.create)
    ..aOS(4, _omitFieldNames ? '' : 'reason')
    ..aOS(5, _omitFieldNames ? '' : 'shiftId')
    ..aOS(6, _omitFieldNames ? '' : 'approvedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundRequest copyWith(void Function(RefundRequest) updates) =>
      super.copyWith((message) => updates(message as RefundRequest))
          as RefundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefundRequest create() => RefundRequest._();
  @$core.override
  RefundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundRequest>(create);
  static RefundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  /// The entry being reversed. Mandatory: a refund that names no original is
  /// money leaving with nothing to check it against.
  @$pb.TagNumber(2)
  $core.String get paymentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set paymentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPaymentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaymentId() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureAmount() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get reason => $_getSZ(3);
  @$pb.TagNumber(4)
  set reason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearReason() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get shiftId => $_getSZ(4);
  @$pb.TagNumber(5)
  set shiftId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasShiftId() => $_has(4);
  @$pb.TagNumber(5)
  void clearShiftId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get approvedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set approvedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasApprovedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovedBy() => $_clearField(6);
}

class RefundResponse extends $pb.GeneratedMessage {
  factory RefundResponse({
    LedgerEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  RefundResponse._();

  factory RefundResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RefundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RefundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<LedgerEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: LedgerEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RefundResponse copyWith(void Function(RefundResponse) updates) =>
      super.copyWith((message) => updates(message as RefundResponse))
          as RefundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RefundResponse create() => RefundResponse._();
  @$core.override
  RefundResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RefundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefundResponse>(create);
  static RefundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  LedgerEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(LedgerEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  LedgerEntry ensureEntry() => $_ensure(0);
}

class StatementRequest extends $pb.GeneratedMessage {
  factory StatementRequest({
    $core.String? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  StatementRequest._();

  factory StatementRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatementRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatementRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementRequest copyWith(void Function(StatementRequest) updates) =>
      super.copyWith((message) => updates(message as StatementRequest))
          as StatementRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatementRequest create() => StatementRequest._();
  @$core.override
  StatementRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatementRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatementRequest>(create);
  static StatementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class StatementResponse extends $pb.GeneratedMessage {
  factory StatementResponse({
    Account? account,
    $core.Iterable<LedgerEntry>? entries,
    Money? balance,
    Money? deposits,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (entries != null) result.entries.addAll(entries);
    if (balance != null) result.balance = balance;
    if (deposits != null) result.deposits = deposits;
    return result;
  }

  StatementResponse._();

  factory StatementResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StatementResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StatementResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..pPM<LedgerEntry>(2, _omitFieldNames ? '' : 'entries',
        subBuilder: LedgerEntry.create)
    ..aOM<Money>(3, _omitFieldNames ? '' : 'balance', subBuilder: Money.create)
    ..aOM<Money>(4, _omitFieldNames ? '' : 'deposits', subBuilder: Money.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StatementResponse copyWith(void Function(StatementResponse) updates) =>
      super.copyWith((message) => updates(message as StatementResponse))
          as StatementResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StatementResponse create() => StatementResponse._();
  @$core.override
  StatementResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StatementResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StatementResponse>(create);
  static StatementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<LedgerEntry> get entries => $_getList(1);

  /// Derived from the ledger rather than stored, so the patient-facing figure
  /// and the finance figure cannot disagree.
  @$pb.TagNumber(3)
  Money get balance => $_getN(2);
  @$pb.TagNumber(3)
  set balance(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBalance() => $_has(2);
  @$pb.TagNumber(3)
  void clearBalance() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureBalance() => $_ensure(2);

  /// Reported apart from the balance: a patient with 50,000 on deposit and
  /// 30,000 billed has 20,000 they can ask for back, and a single net figure
  /// hides that.
  @$pb.TagNumber(4)
  Money get deposits => $_getN(3);
  @$pb.TagNumber(4)
  set deposits(Money value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDeposits() => $_has(3);
  @$pb.TagNumber(4)
  void clearDeposits() => $_clearField(4);
  @$pb.TagNumber(4)
  Money ensureDeposits() => $_ensure(3);
}

class CloseAccountRequest extends $pb.GeneratedMessage {
  factory CloseAccountRequest({
    $core.String? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  CloseAccountRequest._();

  factory CloseAccountRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAccountRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAccountRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountRequest copyWith(void Function(CloseAccountRequest) updates) =>
      super.copyWith((message) => updates(message as CloseAccountRequest))
          as CloseAccountRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAccountRequest create() => CloseAccountRequest._();
  @$core.override
  CloseAccountRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAccountRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAccountRequest>(create);
  static CloseAccountRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class CloseAccountResponse extends $pb.GeneratedMessage {
  factory CloseAccountResponse({
    Account? account,
    $core.Iterable<CloseException>? exceptions,
  }) {
    final result = create();
    if (account != null) result.account = account;
    if (exceptions != null) result.exceptions.addAll(exceptions);
    return result;
  }

  CloseAccountResponse._();

  factory CloseAccountResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseAccountResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseAccountResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Account>(1, _omitFieldNames ? '' : 'account',
        subBuilder: Account.create)
    ..pPM<CloseException>(2, _omitFieldNames ? '' : 'exceptions',
        subBuilder: CloseException.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseAccountResponse copyWith(void Function(CloseAccountResponse) updates) =>
      super.copyWith((message) => updates(message as CloseAccountResponse))
          as CloseAccountResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseAccountResponse create() => CloseAccountResponse._();
  @$core.override
  CloseAccountResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseAccountResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseAccountResponse>(create);
  static CloseAccountResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Account get account => $_getN(0);
  @$pb.TagNumber(1)
  set account(Account value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAccount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccount() => $_clearField(1);
  @$pb.TagNumber(1)
  Account ensureAccount() => $_ensure(0);

  /// Empty when the account closed. Otherwise everything in the way, listed.
  @$pb.TagNumber(2)
  $pb.PbList<CloseException> get exceptions => $_getList(1);
}

class CloseReadinessRequest extends $pb.GeneratedMessage {
  factory CloseReadinessRequest({
    $core.String? accountId,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    return result;
  }

  CloseReadinessRequest._();

  factory CloseReadinessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseReadinessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseReadinessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseReadinessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseReadinessRequest copyWith(
          void Function(CloseReadinessRequest) updates) =>
      super.copyWith((message) => updates(message as CloseReadinessRequest))
          as CloseReadinessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseReadinessRequest create() => CloseReadinessRequest._();
  @$core.override
  CloseReadinessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseReadinessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseReadinessRequest>(create);
  static CloseReadinessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);
}

class CloseReadinessResponse extends $pb.GeneratedMessage {
  factory CloseReadinessResponse({
    $core.Iterable<CloseException>? exceptions,
  }) {
    final result = create();
    if (exceptions != null) result.exceptions.addAll(exceptions);
    return result;
  }

  CloseReadinessResponse._();

  factory CloseReadinessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseReadinessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseReadinessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<CloseException>(1, _omitFieldNames ? '' : 'exceptions',
        subBuilder: CloseException.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseReadinessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseReadinessResponse copyWith(
          void Function(CloseReadinessResponse) updates) =>
      super.copyWith((message) => updates(message as CloseReadinessResponse))
          as CloseReadinessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseReadinessResponse create() => CloseReadinessResponse._();
  @$core.override
  CloseReadinessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseReadinessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseReadinessResponse>(create);
  static CloseReadinessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CloseException> get exceptions => $_getList(0);
}

class RevenueIntegrityRequest extends $pb.GeneratedMessage {
  factory RevenueIntegrityRequest({
    $core.String? facilityId,
    $core.Iterable<BillableEvent>? events,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (events != null) result.events.addAll(events);
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  RevenueIntegrityRequest._();

  factory RevenueIntegrityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevenueIntegrityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevenueIntegrityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..pPM<BillableEvent>(2, _omitFieldNames ? '' : 'events',
        subBuilder: BillableEvent.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueIntegrityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueIntegrityRequest copyWith(
          void Function(RevenueIntegrityRequest) updates) =>
      super.copyWith((message) => updates(message as RevenueIntegrityRequest))
          as RevenueIntegrityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevenueIntegrityRequest create() => RevenueIntegrityRequest._();
  @$core.override
  RevenueIntegrityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevenueIntegrityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevenueIntegrityRequest>(create);
  static RevenueIntegrityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  /// The completed services the biller expects to see. Supplied by the caller
  /// because "what was delivered" is the clinical contexts' fact rather than
  /// billing's.
  @$pb.TagNumber(2)
  $pb.PbList<BillableEvent> get events => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class RevenueIntegrityResponse extends $pb.GeneratedMessage {
  factory RevenueIntegrityResponse({
    $core.Iterable<RevenueException>? exceptions,
  }) {
    final result = create();
    if (exceptions != null) result.exceptions.addAll(exceptions);
    return result;
  }

  RevenueIntegrityResponse._();

  factory RevenueIntegrityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RevenueIntegrityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RevenueIntegrityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<RevenueException>(1, _omitFieldNames ? '' : 'exceptions',
        subBuilder: RevenueException.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueIntegrityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RevenueIntegrityResponse copyWith(
          void Function(RevenueIntegrityResponse) updates) =>
      super.copyWith((message) => updates(message as RevenueIntegrityResponse))
          as RevenueIntegrityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevenueIntegrityResponse create() => RevenueIntegrityResponse._();
  @$core.override
  RevenueIntegrityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RevenueIntegrityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RevenueIntegrityResponse>(create);
  static RevenueIntegrityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RevenueException> get exceptions => $_getList(0);
}

class OpenShiftRequest extends $pb.GeneratedMessage {
  factory OpenShiftRequest({
    $core.String? facilityId,
    $core.String? counterId,
    Money? openingFloat,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (counterId != null) result.counterId = counterId;
    if (openingFloat != null) result.openingFloat = openingFloat;
    return result;
  }

  OpenShiftRequest._();

  factory OpenShiftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenShiftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenShiftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOS(2, _omitFieldNames ? '' : 'counterId')
    ..aOM<Money>(3, _omitFieldNames ? '' : 'openingFloat',
        subBuilder: Money.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenShiftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenShiftRequest copyWith(void Function(OpenShiftRequest) updates) =>
      super.copyWith((message) => updates(message as OpenShiftRequest))
          as OpenShiftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenShiftRequest create() => OpenShiftRequest._();
  @$core.override
  OpenShiftRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenShiftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenShiftRequest>(create);
  static OpenShiftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get counterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set counterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  Money get openingFloat => $_getN(2);
  @$pb.TagNumber(3)
  set openingFloat(Money value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasOpeningFloat() => $_has(2);
  @$pb.TagNumber(3)
  void clearOpeningFloat() => $_clearField(3);
  @$pb.TagNumber(3)
  Money ensureOpeningFloat() => $_ensure(2);
}

class OpenShiftResponse extends $pb.GeneratedMessage {
  factory OpenShiftResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  OpenShiftResponse._();

  factory OpenShiftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OpenShiftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OpenShiftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenShiftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OpenShiftResponse copyWith(void Function(OpenShiftResponse) updates) =>
      super.copyWith((message) => updates(message as OpenShiftResponse))
          as OpenShiftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OpenShiftResponse create() => OpenShiftResponse._();
  @$core.override
  OpenShiftResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OpenShiftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OpenShiftResponse>(create);
  static OpenShiftResponse? _defaultInstance;

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

class CloseShiftRequest extends $pb.GeneratedMessage {
  factory CloseShiftRequest({
    $core.String? shiftId,
    Money? counted,
    $core.String? reason,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    if (counted != null) result.counted = counted;
    if (reason != null) result.reason = reason;
    return result;
  }

  CloseShiftRequest._();

  factory CloseShiftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseShiftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseShiftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..aOM<Money>(2, _omitFieldNames ? '' : 'counted', subBuilder: Money.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseShiftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseShiftRequest copyWith(void Function(CloseShiftRequest) updates) =>
      super.copyWith((message) => updates(message as CloseShiftRequest))
          as CloseShiftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseShiftRequest create() => CloseShiftRequest._();
  @$core.override
  CloseShiftRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseShiftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseShiftRequest>(create);
  static CloseShiftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shiftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shiftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShiftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShiftId() => $_clearField(1);

  @$pb.TagNumber(2)
  Money get counted => $_getN(1);
  @$pb.TagNumber(2)
  set counted(Money value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCounted() => $_has(1);
  @$pb.TagNumber(2)
  void clearCounted() => $_clearField(2);
  @$pb.TagNumber(2)
  Money ensureCounted() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class CloseShiftResponse extends $pb.GeneratedMessage {
  factory CloseShiftResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  CloseShiftResponse._();

  factory CloseShiftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CloseShiftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CloseShiftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseShiftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CloseShiftResponse copyWith(void Function(CloseShiftResponse) updates) =>
      super.copyWith((message) => updates(message as CloseShiftResponse))
          as CloseShiftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CloseShiftResponse create() => CloseShiftResponse._();
  @$core.override
  CloseShiftResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CloseShiftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CloseShiftResponse>(create);
  static CloseShiftResponse? _defaultInstance;

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

class ApproveShiftRequest extends $pb.GeneratedMessage {
  factory ApproveShiftRequest({
    $core.String? shiftId,
  }) {
    final result = create();
    if (shiftId != null) result.shiftId = shiftId;
    return result;
  }

  ApproveShiftRequest._();

  factory ApproveShiftRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveShiftRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveShiftRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'shiftId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveShiftRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveShiftRequest copyWith(void Function(ApproveShiftRequest) updates) =>
      super.copyWith((message) => updates(message as ApproveShiftRequest))
          as ApproveShiftRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveShiftRequest create() => ApproveShiftRequest._();
  @$core.override
  ApproveShiftRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveShiftRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveShiftRequest>(create);
  static ApproveShiftRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get shiftId => $_getSZ(0);
  @$pb.TagNumber(1)
  set shiftId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasShiftId() => $_has(0);
  @$pb.TagNumber(1)
  void clearShiftId() => $_clearField(1);
}

class ApproveShiftResponse extends $pb.GeneratedMessage {
  factory ApproveShiftResponse({
    Shift? shift,
  }) {
    final result = create();
    if (shift != null) result.shift = shift;
    return result;
  }

  ApproveShiftResponse._();

  factory ApproveShiftResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApproveShiftResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApproveShiftResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Shift>(1, _omitFieldNames ? '' : 'shift', subBuilder: Shift.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveShiftResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApproveShiftResponse copyWith(void Function(ApproveShiftResponse) updates) =>
      super.copyWith((message) => updates(message as ApproveShiftResponse))
          as ApproveShiftResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveShiftResponse create() => ApproveShiftResponse._();
  @$core.override
  ApproveShiftResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApproveShiftResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApproveShiftResponse>(create);
  static ApproveShiftResponse? _defaultInstance;

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
    $core.String? facilityId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (pageSize != null) result.pageSize = pageSize;
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
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
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
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
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
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

class PublishServiceRequest extends $pb.GeneratedMessage {
  factory PublishServiceRequest({
    ServiceItem? item,
  }) {
    final result = create();
    if (item != null) result.item = item;
    return result;
  }

  PublishServiceRequest._();

  factory PublishServiceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishServiceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishServiceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<ServiceItem>(1, _omitFieldNames ? '' : 'item',
        subBuilder: ServiceItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishServiceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishServiceRequest copyWith(
          void Function(PublishServiceRequest) updates) =>
      super.copyWith((message) => updates(message as PublishServiceRequest))
          as PublishServiceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishServiceRequest create() => PublishServiceRequest._();
  @$core.override
  PublishServiceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishServiceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishServiceRequest>(create);
  static PublishServiceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  ServiceItem get item => $_getN(0);
  @$pb.TagNumber(1)
  set item(ServiceItem value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => $_clearField(1);
  @$pb.TagNumber(1)
  ServiceItem ensureItem() => $_ensure(0);
}

class PublishServiceResponse extends $pb.GeneratedMessage {
  factory PublishServiceResponse() => create();

  PublishServiceResponse._();

  factory PublishServiceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishServiceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishServiceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishServiceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishServiceResponse copyWith(
          void Function(PublishServiceResponse) updates) =>
      super.copyWith((message) => updates(message as PublishServiceResponse))
          as PublishServiceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishServiceResponse create() => PublishServiceResponse._();
  @$core.override
  PublishServiceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishServiceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishServiceResponse>(create);
  static PublishServiceResponse? _defaultInstance;
}

class ListServicesRequest extends $pb.GeneratedMessage {
  factory ListServicesRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListServicesRequest._();

  factory ListServicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListServicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListServicesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServicesRequest copyWith(void Function(ListServicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListServicesRequest))
          as ListServicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListServicesRequest create() => ListServicesRequest._();
  @$core.override
  ListServicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListServicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListServicesRequest>(create);
  static ListServicesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListServicesResponse extends $pb.GeneratedMessage {
  factory ListServicesResponse({
    $core.Iterable<ServiceItem>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  ListServicesResponse._();

  factory ListServicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListServicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListServicesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<ServiceItem>(1, _omitFieldNames ? '' : 'items',
        subBuilder: ServiceItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListServicesResponse copyWith(void Function(ListServicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListServicesResponse))
          as ListServicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListServicesResponse create() => ListServicesResponse._();
  @$core.override
  ListServicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListServicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListServicesResponse>(create);
  static ListServicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ServiceItem> get items => $_getList(0);
}

class PublishTariffRequest extends $pb.GeneratedMessage {
  factory PublishTariffRequest({
    TariffLine? line,
  }) {
    final result = create();
    if (line != null) result.line = line;
    return result;
  }

  PublishTariffRequest._();

  factory PublishTariffRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishTariffRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishTariffRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<TariffLine>(1, _omitFieldNames ? '' : 'line',
        subBuilder: TariffLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTariffRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTariffRequest copyWith(void Function(PublishTariffRequest) updates) =>
      super.copyWith((message) => updates(message as PublishTariffRequest))
          as PublishTariffRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishTariffRequest create() => PublishTariffRequest._();
  @$core.override
  PublishTariffRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishTariffRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishTariffRequest>(create);
  static PublishTariffRequest? _defaultInstance;

  @$pb.TagNumber(1)
  TariffLine get line => $_getN(0);
  @$pb.TagNumber(1)
  set line(TariffLine value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLine() => $_has(0);
  @$pb.TagNumber(1)
  void clearLine() => $_clearField(1);
  @$pb.TagNumber(1)
  TariffLine ensureLine() => $_ensure(0);
}

class PublishTariffResponse extends $pb.GeneratedMessage {
  factory PublishTariffResponse() => create();

  PublishTariffResponse._();

  factory PublishTariffResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishTariffResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishTariffResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTariffResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishTariffResponse copyWith(
          void Function(PublishTariffResponse) updates) =>
      super.copyWith((message) => updates(message as PublishTariffResponse))
          as PublishTariffResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishTariffResponse create() => PublishTariffResponse._();
  @$core.override
  PublishTariffResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishTariffResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishTariffResponse>(create);
  static PublishTariffResponse? _defaultInstance;
}

class ListTariffsRequest extends $pb.GeneratedMessage {
  factory ListTariffsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListTariffsRequest._();

  factory ListTariffsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTariffsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTariffsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTariffsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTariffsRequest copyWith(void Function(ListTariffsRequest) updates) =>
      super.copyWith((message) => updates(message as ListTariffsRequest))
          as ListTariffsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTariffsRequest create() => ListTariffsRequest._();
  @$core.override
  ListTariffsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTariffsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTariffsRequest>(create);
  static ListTariffsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListTariffsResponse extends $pb.GeneratedMessage {
  factory ListTariffsResponse({
    $core.Iterable<TariffLine>? lines,
  }) {
    final result = create();
    if (lines != null) result.lines.addAll(lines);
    return result;
  }

  ListTariffsResponse._();

  factory ListTariffsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTariffsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTariffsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<TariffLine>(1, _omitFieldNames ? '' : 'lines',
        subBuilder: TariffLine.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTariffsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTariffsResponse copyWith(void Function(ListTariffsResponse) updates) =>
      super.copyWith((message) => updates(message as ListTariffsResponse))
          as ListTariffsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTariffsResponse create() => ListTariffsResponse._();
  @$core.override
  ListTariffsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTariffsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTariffsResponse>(create);
  static ListTariffsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TariffLine> get lines => $_getList(0);
}

class QuoteRequest extends $pb.GeneratedMessage {
  factory QuoteRequest({
    $core.String? accountId,
    $core.String? serviceCode,
  }) {
    final result = create();
    if (accountId != null) result.accountId = accountId;
    if (serviceCode != null) result.serviceCode = serviceCode;
    return result;
  }

  QuoteRequest._();

  factory QuoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuoteRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'accountId')
    ..aOS(2, _omitFieldNames ? '' : 'serviceCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteRequest copyWith(void Function(QuoteRequest) updates) =>
      super.copyWith((message) => updates(message as QuoteRequest))
          as QuoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuoteRequest create() => QuoteRequest._();
  @$core.override
  QuoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuoteRequest>(create);
  static QuoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get accountId => $_getSZ(0);
  @$pb.TagNumber(1)
  set accountId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccountId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccountId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceCode => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceCode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasServiceCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceCode() => $_clearField(2);
}

class QuoteResponse extends $pb.GeneratedMessage {
  factory QuoteResponse({
    PricingResult? pricing,
  }) {
    final result = create();
    if (pricing != null) result.pricing = pricing;
    return result;
  }

  QuoteResponse._();

  factory QuoteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory QuoteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'QuoteResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<PricingResult>(1, _omitFieldNames ? '' : 'pricing',
        subBuilder: PricingResult.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  QuoteResponse copyWith(void Function(QuoteResponse) updates) =>
      super.copyWith((message) => updates(message as QuoteResponse))
          as QuoteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QuoteResponse create() => QuoteResponse._();
  @$core.override
  QuoteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static QuoteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QuoteResponse>(create);
  static QuoteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PricingResult get pricing => $_getN(0);
  @$pb.TagNumber(1)
  set pricing(PricingResult value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPricing() => $_has(0);
  @$pb.TagNumber(1)
  void clearPricing() => $_clearField(1);
  @$pb.TagNumber(1)
  PricingResult ensurePricing() => $_ensure(0);
}

class PublishPackageRequest extends $pb.GeneratedMessage {
  factory PublishPackageRequest({
    Package? package,
  }) {
    final result = create();
    if (package != null) result.package = package;
    return result;
  }

  PublishPackageRequest._();

  factory PublishPackageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishPackageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishPackageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<Package>(1, _omitFieldNames ? '' : 'package',
        subBuilder: Package.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishPackageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishPackageRequest copyWith(
          void Function(PublishPackageRequest) updates) =>
      super.copyWith((message) => updates(message as PublishPackageRequest))
          as PublishPackageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishPackageRequest create() => PublishPackageRequest._();
  @$core.override
  PublishPackageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishPackageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishPackageRequest>(create);
  static PublishPackageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Package get package => $_getN(0);
  @$pb.TagNumber(1)
  set package(Package value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearPackage() => $_clearField(1);
  @$pb.TagNumber(1)
  Package ensurePackage() => $_ensure(0);
}

class PublishPackageResponse extends $pb.GeneratedMessage {
  factory PublishPackageResponse() => create();

  PublishPackageResponse._();

  factory PublishPackageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PublishPackageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PublishPackageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishPackageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PublishPackageResponse copyWith(
          void Function(PublishPackageResponse) updates) =>
      super.copyWith((message) => updates(message as PublishPackageResponse))
          as PublishPackageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishPackageResponse create() => PublishPackageResponse._();
  @$core.override
  PublishPackageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PublishPackageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PublishPackageResponse>(create);
  static PublishPackageResponse? _defaultInstance;
}

class ListPackagesRequest extends $pb.GeneratedMessage {
  factory ListPackagesRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListPackagesRequest._();

  factory ListPackagesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPackagesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPackagesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesRequest copyWith(void Function(ListPackagesRequest) updates) =>
      super.copyWith((message) => updates(message as ListPackagesRequest))
          as ListPackagesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPackagesRequest create() => ListPackagesRequest._();
  @$core.override
  ListPackagesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPackagesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPackagesRequest>(create);
  static ListPackagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class ListPackagesResponse extends $pb.GeneratedMessage {
  factory ListPackagesResponse({
    $core.Iterable<Package>? packages,
  }) {
    final result = create();
    if (packages != null) result.packages.addAll(packages);
    return result;
  }

  ListPackagesResponse._();

  factory ListPackagesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPackagesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPackagesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..pPM<Package>(1, _omitFieldNames ? '' : 'packages',
        subBuilder: Package.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPackagesResponse copyWith(void Function(ListPackagesResponse) updates) =>
      super.copyWith((message) => updates(message as ListPackagesResponse))
          as ListPackagesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPackagesResponse create() => ListPackagesResponse._();
  @$core.override
  ListPackagesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPackagesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPackagesResponse>(create);
  static ListPackagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Package> get packages => $_getList(0);
}

class SetBillingPolicyRequest extends $pb.GeneratedMessage {
  factory SetBillingPolicyRequest({
    BillingPolicy? policy,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    return result;
  }

  SetBillingPolicyRequest._();

  factory SetBillingPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetBillingPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBillingPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<BillingPolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: BillingPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBillingPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBillingPolicyRequest copyWith(
          void Function(SetBillingPolicyRequest) updates) =>
      super.copyWith((message) => updates(message as SetBillingPolicyRequest))
          as SetBillingPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBillingPolicyRequest create() => SetBillingPolicyRequest._();
  @$core.override
  SetBillingPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetBillingPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBillingPolicyRequest>(create);
  static SetBillingPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  BillingPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(BillingPolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  BillingPolicy ensurePolicy() => $_ensure(0);
}

class SetBillingPolicyResponse extends $pb.GeneratedMessage {
  factory SetBillingPolicyResponse() => create();

  SetBillingPolicyResponse._();

  factory SetBillingPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetBillingPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetBillingPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBillingPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetBillingPolicyResponse copyWith(
          void Function(SetBillingPolicyResponse) updates) =>
      super.copyWith((message) => updates(message as SetBillingPolicyResponse))
          as SetBillingPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetBillingPolicyResponse create() => SetBillingPolicyResponse._();
  @$core.override
  SetBillingPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetBillingPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetBillingPolicyResponse>(create);
  static SetBillingPolicyResponse? _defaultInstance;
}

class GetBillingPolicyRequest extends $pb.GeneratedMessage {
  factory GetBillingPolicyRequest() => create();

  GetBillingPolicyRequest._();

  factory GetBillingPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBillingPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBillingPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingPolicyRequest copyWith(
          void Function(GetBillingPolicyRequest) updates) =>
      super.copyWith((message) => updates(message as GetBillingPolicyRequest))
          as GetBillingPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBillingPolicyRequest create() => GetBillingPolicyRequest._();
  @$core.override
  GetBillingPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBillingPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBillingPolicyRequest>(create);
  static GetBillingPolicyRequest? _defaultInstance;
}

class GetBillingPolicyResponse extends $pb.GeneratedMessage {
  factory GetBillingPolicyResponse({
    BillingPolicy? policy,
  }) {
    final result = create();
    if (policy != null) result.policy = policy;
    return result;
  }

  GetBillingPolicyResponse._();

  factory GetBillingPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBillingPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBillingPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.billing.v1'),
      createEmptyInstance: create)
    ..aOM<BillingPolicy>(1, _omitFieldNames ? '' : 'policy',
        subBuilder: BillingPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBillingPolicyResponse copyWith(
          void Function(GetBillingPolicyResponse) updates) =>
      super.copyWith((message) => updates(message as GetBillingPolicyResponse))
          as GetBillingPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBillingPolicyResponse create() => GetBillingPolicyResponse._();
  @$core.override
  GetBillingPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBillingPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBillingPolicyResponse>(create);
  static GetBillingPolicyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BillingPolicy get policy => $_getN(0);
  @$pb.TagNumber(1)
  set policy(BillingPolicy value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPolicy() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolicy() => $_clearField(1);
  @$pb.TagNumber(1)
  BillingPolicy ensurePolicy() => $_ensure(0);
}

/// BillingService is the billing context's boundary (SRS-BIL).
class BillingServiceApi {
  final $pb.RpcClient _client;

  BillingServiceApi(this._client);

  /// SRS-BIL-013.
  $async.Future<OpenAccountResponse> openAccount(
          $pb.ClientContext? ctx, OpenAccountRequest request) =>
      _client.invoke<OpenAccountResponse>(
          ctx, 'BillingService', 'OpenAccount', request, OpenAccountResponse());
  $async.Future<GetAccountResponse> getAccount(
          $pb.ClientContext? ctx, GetAccountRequest request) =>
      _client.invoke<GetAccountResponse>(
          ctx, 'BillingService', 'GetAccount', request, GetAccountResponse());

  /// SRS-BIL-003, SRS-BIL-004. Idempotent on the source reference.
  $async.Future<PostChargeResponse> postCharge(
          $pb.ClientContext? ctx, PostChargeRequest request) =>
      _client.invoke<PostChargeResponse>(
          ctx, 'BillingService', 'PostCharge', request, PostChargeResponse());

  /// Three calls rather than one with a status, because the preconditions
  /// differ: a charge on an issued invoice is corrected by a note rather than
  /// voided, and only a held charge is released.
  $async.Future<VoidChargeResponse> voidCharge(
          $pb.ClientContext? ctx, VoidChargeRequest request) =>
      _client.invoke<VoidChargeResponse>(
          ctx, 'BillingService', 'VoidCharge', request, VoidChargeResponse());
  $async.Future<HoldChargeResponse> holdCharge(
          $pb.ClientContext? ctx, HoldChargeRequest request) =>
      _client.invoke<HoldChargeResponse>(
          ctx, 'BillingService', 'HoldCharge', request, HoldChargeResponse());
  $async.Future<ReleaseChargeResponse> releaseCharge(
          $pb.ClientContext? ctx, ReleaseChargeRequest request) =>
      _client.invoke<ReleaseChargeResponse>(ctx, 'BillingService',
          'ReleaseCharge', request, ReleaseChargeResponse());
  $async.Future<ListChargesResponse> listCharges(
          $pb.ClientContext? ctx, ListChargesRequest request) =>
      _client.invoke<ListChargesResponse>(
          ctx, 'BillingService', 'ListCharges', request, ListChargesResponse());
  $async.Future<PackageLedgerResponse> packageLedger(
          $pb.ClientContext? ctx, PackageLedgerRequest request) =>
      _client.invoke<PackageLedgerResponse>(ctx, 'BillingService',
          'PackageLedger', request, PackageLedgerResponse());

  /// SRS-BIL-005, SRS-BIL-006, SRS-BIL-007, SRS-BIL-014.
  $async.Future<RaiseInvoiceResponse> raiseInvoice(
          $pb.ClientContext? ctx, RaiseInvoiceRequest request) =>
      _client.invoke<RaiseInvoiceResponse>(ctx, 'BillingService',
          'RaiseInvoice', request, RaiseInvoiceResponse());

  /// SRS-BIL-010. A correction is a new document, never an edit.
  $async.Future<CorrectInvoiceResponse> correctInvoice(
          $pb.ClientContext? ctx, CorrectInvoiceRequest request) =>
      _client.invoke<CorrectInvoiceResponse>(ctx, 'BillingService',
          'CorrectInvoice', request, CorrectInvoiceResponse());
  $async.Future<GetInvoiceResponse> getInvoice(
          $pb.ClientContext? ctx, GetInvoiceRequest request) =>
      _client.invoke<GetInvoiceResponse>(
          ctx, 'BillingService', 'GetInvoice', request, GetInvoiceResponse());
  $async.Future<ListInvoicesResponse> listInvoices(
          $pb.ClientContext? ctx, ListInvoicesRequest request) =>
      _client.invoke<ListInvoicesResponse>(ctx, 'BillingService',
          'ListInvoices', request, ListInvoicesResponse());

  /// SRS-BIL-008, SRS-BIL-009, SRS-BIL-012.
  $async.Future<ReceivePaymentResponse> receivePayment(
          $pb.ClientContext? ctx, ReceivePaymentRequest request) =>
      _client.invoke<ReceivePaymentResponse>(ctx, 'BillingService',
          'ReceivePayment', request, ReceivePaymentResponse());
  $async.Future<RefundResponse> refund(
          $pb.ClientContext? ctx, RefundRequest request) =>
      _client.invoke<RefundResponse>(
          ctx, 'BillingService', 'Refund', request, RefundResponse());
  $async.Future<StatementResponse> statement(
          $pb.ClientContext? ctx, StatementRequest request) =>
      _client.invoke<StatementResponse>(
          ctx, 'BillingService', 'Statement', request, StatementResponse());

  /// SRS-BIL-013.
  $async.Future<CloseAccountResponse> closeAccount(
          $pb.ClientContext? ctx, CloseAccountRequest request) =>
      _client.invoke<CloseAccountResponse>(ctx, 'BillingService',
          'CloseAccount', request, CloseAccountResponse());
  $async.Future<CloseReadinessResponse> closeReadiness(
          $pb.ClientContext? ctx, CloseReadinessRequest request) =>
      _client.invoke<CloseReadinessResponse>(ctx, 'BillingService',
          'CloseReadiness', request, CloseReadinessResponse());

  /// SRS-BIL-011.
  $async.Future<RevenueIntegrityResponse> revenueIntegrity(
          $pb.ClientContext? ctx, RevenueIntegrityRequest request) =>
      _client.invoke<RevenueIntegrityResponse>(ctx, 'BillingService',
          'RevenueIntegrity', request, RevenueIntegrityResponse());

  /// SRS-BIL-015.
  $async.Future<OpenShiftResponse> openShift(
          $pb.ClientContext? ctx, OpenShiftRequest request) =>
      _client.invoke<OpenShiftResponse>(
          ctx, 'BillingService', 'OpenShift', request, OpenShiftResponse());
  $async.Future<CloseShiftResponse> closeShift(
          $pb.ClientContext? ctx, CloseShiftRequest request) =>
      _client.invoke<CloseShiftResponse>(
          ctx, 'BillingService', 'CloseShift', request, CloseShiftResponse());
  $async.Future<ApproveShiftResponse> approveShift(
          $pb.ClientContext? ctx, ApproveShiftRequest request) =>
      _client.invoke<ApproveShiftResponse>(ctx, 'BillingService',
          'ApproveShift', request, ApproveShiftResponse());
  $async.Future<ListShiftsResponse> listShifts(
          $pb.ClientContext? ctx, ListShiftsRequest request) =>
      _client.invoke<ListShiftsResponse>(
          ctx, 'BillingService', 'ListShifts', request, ListShiftsResponse());

  /// Configuration (SRS-BIL-001, SRS-BIL-002, SRS-BIL-004, SRS-BIL-007).
  $async.Future<PublishServiceResponse> publishService(
          $pb.ClientContext? ctx, PublishServiceRequest request) =>
      _client.invoke<PublishServiceResponse>(ctx, 'BillingService',
          'PublishService', request, PublishServiceResponse());
  $async.Future<ListServicesResponse> listServices(
          $pb.ClientContext? ctx, ListServicesRequest request) =>
      _client.invoke<ListServicesResponse>(ctx, 'BillingService',
          'ListServices', request, ListServicesResponse());
  $async.Future<PublishTariffResponse> publishTariff(
          $pb.ClientContext? ctx, PublishTariffRequest request) =>
      _client.invoke<PublishTariffResponse>(ctx, 'BillingService',
          'PublishTariff', request, PublishTariffResponse());
  $async.Future<ListTariffsResponse> listTariffs(
          $pb.ClientContext? ctx, ListTariffsRequest request) =>
      _client.invoke<ListTariffsResponse>(
          ctx, 'BillingService', 'ListTariffs', request, ListTariffsResponse());
  $async.Future<QuoteResponse> quote(
          $pb.ClientContext? ctx, QuoteRequest request) =>
      _client.invoke<QuoteResponse>(
          ctx, 'BillingService', 'Quote', request, QuoteResponse());
  $async.Future<PublishPackageResponse> publishPackage(
          $pb.ClientContext? ctx, PublishPackageRequest request) =>
      _client.invoke<PublishPackageResponse>(ctx, 'BillingService',
          'PublishPackage', request, PublishPackageResponse());
  $async.Future<ListPackagesResponse> listPackages(
          $pb.ClientContext? ctx, ListPackagesRequest request) =>
      _client.invoke<ListPackagesResponse>(ctx, 'BillingService',
          'ListPackages', request, ListPackagesResponse());
  $async.Future<SetBillingPolicyResponse> setBillingPolicy(
          $pb.ClientContext? ctx, SetBillingPolicyRequest request) =>
      _client.invoke<SetBillingPolicyResponse>(ctx, 'BillingService',
          'SetBillingPolicy', request, SetBillingPolicyResponse());
  $async.Future<GetBillingPolicyResponse> getBillingPolicy(
          $pb.ClientContext? ctx, GetBillingPolicyRequest request) =>
      _client.invoke<GetBillingPolicyResponse>(ctx, 'BillingService',
          'GetBillingPolicy', request, GetBillingPolicyResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
