// This is a generated file - do not edit.
//
// Generated from healthcare/identity_access/v1/identity.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $0;

import 'identity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'identity.pbenum.dart';

/// The resolved authorization context for the current caller. Returned so the
/// UI can render appropriately — never so the UI can decide (SRS-IAM-003).
class SessionContext extends $pb.GeneratedMessage {
  factory SessionContext({
    $core.String? subjectId,
    $core.String? tenantId,
    $core.String? activeFacilityId,
    $core.Iterable<$core.String>? roles,
    $core.Iterable<$core.String>? permissions,
    PurposeOfUse? purposeOfUse,
    $core.bool? breakGlassActive,
    $0.Timestamp? expiresAt,
  }) {
    final result = create();
    if (subjectId != null) result.subjectId = subjectId;
    if (tenantId != null) result.tenantId = tenantId;
    if (activeFacilityId != null) result.activeFacilityId = activeFacilityId;
    if (roles != null) result.roles.addAll(roles);
    if (permissions != null) result.permissions.addAll(permissions);
    if (purposeOfUse != null) result.purposeOfUse = purposeOfUse;
    if (breakGlassActive != null) result.breakGlassActive = breakGlassActive;
    if (expiresAt != null) result.expiresAt = expiresAt;
    return result;
  }

  SessionContext._();

  factory SessionContext.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SessionContext.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SessionContext',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.identity_access.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'subjectId')
    ..aOS(2, _omitFieldNames ? '' : 'tenantId')
    ..aOS(3, _omitFieldNames ? '' : 'activeFacilityId')
    ..pPS(4, _omitFieldNames ? '' : 'roles')
    ..pPS(5, _omitFieldNames ? '' : 'permissions')
    ..aE<PurposeOfUse>(6, _omitFieldNames ? '' : 'purposeOfUse',
        enumValues: PurposeOfUse.values)
    ..aOB(7, _omitFieldNames ? '' : 'breakGlassActive')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionContext clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SessionContext copyWith(void Function(SessionContext) updates) =>
      super.copyWith((message) => updates(message as SessionContext))
          as SessionContext;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SessionContext create() => SessionContext._();
  @$core.override
  SessionContext createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SessionContext getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SessionContext>(create);
  static SessionContext? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get subjectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set subjectId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSubjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSubjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tenantId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tenantId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTenantId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTenantId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get activeFacilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set activeFacilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActiveFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveFacilityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get roles => $_getList(3);

  /// Flattened effective permissions, e.g. "organization.facility.create".
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get permissions => $_getList(4);

  @$pb.TagNumber(6)
  PurposeOfUse get purposeOfUse => $_getN(5);
  @$pb.TagNumber(6)
  set purposeOfUse(PurposeOfUse value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPurposeOfUse() => $_has(5);
  @$pb.TagNumber(6)
  void clearPurposeOfUse() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get breakGlassActive => $_getBF(6);
  @$pb.TagNumber(7)
  set breakGlassActive($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBreakGlassActive() => $_has(6);
  @$pb.TagNumber(7)
  void clearBreakGlassActive() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get expiresAt => $_getN(7);
  @$pb.TagNumber(8)
  set expiresAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasExpiresAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearExpiresAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureExpiresAt() => $_ensure(7);
}

class GetSessionContextRequest extends $pb.GeneratedMessage {
  factory GetSessionContextRequest() => create();

  GetSessionContextRequest._();

  factory GetSessionContextRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSessionContextRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSessionContextRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.identity_access.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionContextRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionContextRequest copyWith(
          void Function(GetSessionContextRequest) updates) =>
      super.copyWith((message) => updates(message as GetSessionContextRequest))
          as GetSessionContextRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSessionContextRequest create() => GetSessionContextRequest._();
  @$core.override
  GetSessionContextRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSessionContextRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSessionContextRequest>(create);
  static GetSessionContextRequest? _defaultInstance;
}

class GetSessionContextResponse extends $pb.GeneratedMessage {
  factory GetSessionContextResponse({
    SessionContext? session,
  }) {
    final result = create();
    if (session != null) result.session = session;
    return result;
  }

  GetSessionContextResponse._();

  factory GetSessionContextResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSessionContextResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSessionContextResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.identity_access.v1'),
      createEmptyInstance: create)
    ..aOM<SessionContext>(1, _omitFieldNames ? '' : 'session',
        subBuilder: SessionContext.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionContextResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSessionContextResponse copyWith(
          void Function(GetSessionContextResponse) updates) =>
      super.copyWith((message) => updates(message as GetSessionContextResponse))
          as GetSessionContextResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSessionContextResponse create() => GetSessionContextResponse._();
  @$core.override
  GetSessionContextResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSessionContextResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSessionContextResponse>(create);
  static GetSessionContextResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SessionContext get session => $_getN(0);
  @$pb.TagNumber(1)
  set session(SessionContext value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSession() => $_has(0);
  @$pb.TagNumber(1)
  void clearSession() => $_clearField(1);
  @$pb.TagNumber(1)
  SessionContext ensureSession() => $_ensure(0);
}

class EvaluateAccessRequest extends $pb.GeneratedMessage {
  factory EvaluateAccessRequest({
    $core.String? permission,
    $core.String? facilityId,
  }) {
    final result = create();
    if (permission != null) result.permission = permission;
    if (facilityId != null) result.facilityId = facilityId;
    return result;
  }

  EvaluateAccessRequest._();

  factory EvaluateAccessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateAccessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateAccessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.identity_access.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'permission')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateAccessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateAccessRequest copyWith(
          void Function(EvaluateAccessRequest) updates) =>
      super.copyWith((message) => updates(message as EvaluateAccessRequest))
          as EvaluateAccessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateAccessRequest create() => EvaluateAccessRequest._();
  @$core.override
  EvaluateAccessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateAccessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateAccessRequest>(create);
  static EvaluateAccessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get permission => $_getSZ(0);
  @$pb.TagNumber(1)
  set permission($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPermission() => $_has(0);
  @$pb.TagNumber(1)
  void clearPermission() => $_clearField(1);

  /// Optional facility the action would target.
  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);
}

class EvaluateAccessResponse extends $pb.GeneratedMessage {
  factory EvaluateAccessResponse({
    $core.bool? allowed,
    $core.String? reason,
  }) {
    final result = create();
    if (allowed != null) result.allowed = allowed;
    if (reason != null) result.reason = reason;
    return result;
  }

  EvaluateAccessResponse._();

  factory EvaluateAccessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EvaluateAccessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EvaluateAccessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.identity_access.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'allowed')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateAccessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EvaluateAccessResponse copyWith(
          void Function(EvaluateAccessResponse) updates) =>
      super.copyWith((message) => updates(message as EvaluateAccessResponse))
          as EvaluateAccessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateAccessResponse create() => EvaluateAccessResponse._();
  @$core.override
  EvaluateAccessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EvaluateAccessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EvaluateAccessResponse>(create);
  static EvaluateAccessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get allowed => $_getBF(0);
  @$pb.TagNumber(1)
  set allowed($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAllowed() => $_has(0);
  @$pb.TagNumber(1)
  void clearAllowed() => $_clearField(1);

  /// Stable reason code when denied, e.g. "PERMISSION_NOT_GRANTED".
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class IdentityServiceApi {
  final $pb.RpcClient _client;

  IdentityServiceApi(this._client);

  $async.Future<GetSessionContextResponse> getSessionContext(
          $pb.ClientContext? ctx, GetSessionContextRequest request) =>
      _client.invoke<GetSessionContextResponse>(ctx, 'IdentityService',
          'GetSessionContext', request, GetSessionContextResponse());

  /// Server-side authorization probe. Mirrors the same policy engine the
  /// application layer uses, so UI and server can never diverge.
  $async.Future<EvaluateAccessResponse> evaluateAccess(
          $pb.ClientContext? ctx, EvaluateAccessRequest request) =>
      _client.invoke<EvaluateAccessResponse>(ctx, 'IdentityService',
          'EvaluateAccess', request, EvaluateAccessResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
