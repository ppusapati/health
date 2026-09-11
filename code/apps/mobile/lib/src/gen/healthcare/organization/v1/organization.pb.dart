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
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
