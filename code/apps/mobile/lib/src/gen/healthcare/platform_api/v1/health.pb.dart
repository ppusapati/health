// This is a generated file - do not edit.
//
// Generated from healthcare/platform_api/v1/health.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class CheckLivenessRequest extends $pb.GeneratedMessage {
  factory CheckLivenessRequest() => create();

  CheckLivenessRequest._();

  factory CheckLivenessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckLivenessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckLivenessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLivenessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLivenessRequest copyWith(void Function(CheckLivenessRequest) updates) =>
      super.copyWith((message) => updates(message as CheckLivenessRequest))
          as CheckLivenessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckLivenessRequest create() => CheckLivenessRequest._();
  @$core.override
  CheckLivenessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckLivenessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckLivenessRequest>(create);
  static CheckLivenessRequest? _defaultInstance;
}

class CheckLivenessResponse extends $pb.GeneratedMessage {
  factory CheckLivenessResponse({
    $core.bool? alive,
  }) {
    final result = create();
    if (alive != null) result.alive = alive;
    return result;
  }

  CheckLivenessResponse._();

  factory CheckLivenessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckLivenessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckLivenessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'alive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLivenessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckLivenessResponse copyWith(
          void Function(CheckLivenessResponse) updates) =>
      super.copyWith((message) => updates(message as CheckLivenessResponse))
          as CheckLivenessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckLivenessResponse create() => CheckLivenessResponse._();
  @$core.override
  CheckLivenessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckLivenessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckLivenessResponse>(create);
  static CheckLivenessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get alive => $_getBF(0);
  @$pb.TagNumber(1)
  set alive($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlive() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlive() => $_clearField(1);
}

class CheckReadinessRequest extends $pb.GeneratedMessage {
  factory CheckReadinessRequest() => create();

  CheckReadinessRequest._();

  factory CheckReadinessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckReadinessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckReadinessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckReadinessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckReadinessRequest copyWith(
          void Function(CheckReadinessRequest) updates) =>
      super.copyWith((message) => updates(message as CheckReadinessRequest))
          as CheckReadinessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckReadinessRequest create() => CheckReadinessRequest._();
  @$core.override
  CheckReadinessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckReadinessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckReadinessRequest>(create);
  static CheckReadinessRequest? _defaultInstance;
}

class CheckReadinessResponse extends $pb.GeneratedMessage {
  factory CheckReadinessResponse({
    $core.bool? ready,
    $core.Iterable<$core.MapEntry<$core.String, $core.bool>>? dependencies,
  }) {
    final result = create();
    if (ready != null) result.ready = ready;
    if (dependencies != null) result.dependencies.addEntries(dependencies);
    return result;
  }

  CheckReadinessResponse._();

  factory CheckReadinessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckReadinessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckReadinessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'ready')
    ..m<$core.String, $core.bool>(2, _omitFieldNames ? '' : 'dependencies',
        entryClassName: 'CheckReadinessResponse.DependenciesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OB,
        packageName: const $pb.PackageName('healthcare.platform_api.v1'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckReadinessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckReadinessResponse copyWith(
          void Function(CheckReadinessResponse) updates) =>
      super.copyWith((message) => updates(message as CheckReadinessResponse))
          as CheckReadinessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckReadinessResponse create() => CheckReadinessResponse._();
  @$core.override
  CheckReadinessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckReadinessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckReadinessResponse>(create);
  static CheckReadinessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get ready => $_getBF(0);
  @$pb.TagNumber(1)
  set ready($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReady() => $_has(0);
  @$pb.TagNumber(1)
  void clearReady() => $_clearField(1);

  /// Per-dependency readiness, e.g. {"postgres": true}.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.bool> get dependencies => $_getMap(1);
}

class GetBuildInfoRequest extends $pb.GeneratedMessage {
  factory GetBuildInfoRequest() => create();

  GetBuildInfoRequest._();

  factory GetBuildInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBuildInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBuildInfoRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBuildInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBuildInfoRequest copyWith(void Function(GetBuildInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetBuildInfoRequest))
          as GetBuildInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBuildInfoRequest create() => GetBuildInfoRequest._();
  @$core.override
  GetBuildInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBuildInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBuildInfoRequest>(create);
  static GetBuildInfoRequest? _defaultInstance;
}

class GetBuildInfoResponse extends $pb.GeneratedMessage {
  factory GetBuildInfoResponse({
    $core.String? version,
    $core.String? commit,
    $core.String? builtAt,
  }) {
    final result = create();
    if (version != null) result.version = version;
    if (commit != null) result.commit = commit;
    if (builtAt != null) result.builtAt = builtAt;
    return result;
  }

  GetBuildInfoResponse._();

  factory GetBuildInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetBuildInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetBuildInfoResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.platform_api.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..aOS(2, _omitFieldNames ? '' : 'commit')
    ..aOS(3, _omitFieldNames ? '' : 'builtAt')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBuildInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetBuildInfoResponse copyWith(void Function(GetBuildInfoResponse) updates) =>
      super.copyWith((message) => updates(message as GetBuildInfoResponse))
          as GetBuildInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBuildInfoResponse create() => GetBuildInfoResponse._();
  @$core.override
  GetBuildInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetBuildInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetBuildInfoResponse>(create);
  static GetBuildInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get commit => $_getSZ(1);
  @$pb.TagNumber(2)
  set commit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCommit() => $_has(1);
  @$pb.TagNumber(2)
  void clearCommit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get builtAt => $_getSZ(2);
  @$pb.TagNumber(3)
  set builtAt($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBuiltAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearBuiltAt() => $_clearField(3);
}

class HealthServiceApi {
  final $pb.RpcClient _client;

  HealthServiceApi(this._client);

  /// Process is up. Never touches dependencies.
  $async.Future<CheckLivenessResponse> checkLiveness(
          $pb.ClientContext? ctx, CheckLivenessRequest request) =>
      _client.invoke<CheckLivenessResponse>(ctx, 'HealthService',
          'CheckLiveness', request, CheckLivenessResponse());

  /// Process can serve traffic. Verifies required dependencies.
  $async.Future<CheckReadinessResponse> checkReadiness(
          $pb.ClientContext? ctx, CheckReadinessRequest request) =>
      _client.invoke<CheckReadinessResponse>(ctx, 'HealthService',
          'CheckReadiness', request, CheckReadinessResponse());

  /// Build/release provenance for support and incident response.
  $async.Future<GetBuildInfoResponse> getBuildInfo(
          $pb.ClientContext? ctx, GetBuildInfoRequest request) =>
      _client.invoke<GetBuildInfoResponse>(ctx, 'HealthService', 'GetBuildInfo',
          request, GetBuildInfoResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
