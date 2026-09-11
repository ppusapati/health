// This is a generated file - do not edit.
//
// Generated from healthcare/common/v1/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Stable, machine-readable failure detail carried alongside the Connect status.
/// The display message is a client concern; `code` is the contract.
class ErrorDetail extends $pb.GeneratedMessage {
  factory ErrorDetail({
    $core.String? code,
    $core.Iterable<FieldViolation>? fieldViolations,
    $core.bool? retryable,
    $core.String? correlationId,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (fieldViolations != null) result.fieldViolations.addAll(fieldViolations);
    if (retryable != null) result.retryable = retryable;
    if (correlationId != null) result.correlationId = correlationId;
    return result;
  }

  ErrorDetail._();

  factory ErrorDetail.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorDetail.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorDetail',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.common.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..pPM<FieldViolation>(2, _omitFieldNames ? '' : 'fieldViolations',
        subBuilder: FieldViolation.create)
    ..aOB(3, _omitFieldNames ? '' : 'retryable')
    ..aOS(4, _omitFieldNames ? '' : 'correlationId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorDetail clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorDetail copyWith(void Function(ErrorDetail) updates) =>
      super.copyWith((message) => updates(message as ErrorDetail))
          as ErrorDetail;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorDetail create() => ErrorDetail._();
  @$core.override
  ErrorDetail createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorDetail getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorDetail>(create);
  static ErrorDetail? _defaultInstance;

  /// Stable domain error code, e.g. "ORG_FACILITY_CODE_TAKEN".
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  /// Field-level violations for INVALID_ARGUMENT.
  @$pb.TagNumber(2)
  $pb.PbList<FieldViolation> get fieldViolations => $_getList(1);

  /// Whether a bounded retry of the identical request is safe.
  @$pb.TagNumber(3)
  $core.bool get retryable => $_getBF(2);
  @$pb.TagNumber(3)
  set retryable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRetryable() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetryable() => $_clearField(3);

  /// Correlation ID the caller can quote to support.
  @$pb.TagNumber(4)
  $core.String get correlationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set correlationId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCorrelationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCorrelationId() => $_clearField(4);
}

class FieldViolation extends $pb.GeneratedMessage {
  factory FieldViolation({
    $core.String? field_1,
    $core.String? reason,
  }) {
    final result = create();
    if (field_1 != null) result.field_1 = field_1;
    if (reason != null) result.reason = reason;
    return result;
  }

  FieldViolation._();

  factory FieldViolation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FieldViolation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FieldViolation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.common.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'field')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldViolation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldViolation copyWith(void Function(FieldViolation) updates) =>
      super.copyWith((message) => updates(message as FieldViolation))
          as FieldViolation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldViolation create() => FieldViolation._();
  @$core.override
  FieldViolation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FieldViolation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FieldViolation>(create);
  static FieldViolation? _defaultInstance;

  /// Dotted path to the offending field, e.g. "facility.code".
  @$pb.TagNumber(1)
  $core.String get field_1 => $_getSZ(0);
  @$pb.TagNumber(1)
  set field_1($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasField_1() => $_has(0);
  @$pb.TagNumber(1)
  void clearField_1() => $_clearField(1);

  /// Stable reason code, not prose.
  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Cursor pagination. Page numbers are deliberately not offered: the underlying
/// datasets are unstable under concurrent writes.
class PageRequest extends $pb.GeneratedMessage {
  factory PageRequest({
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    if (pageToken != null) result.pageToken = pageToken;
    return result;
  }

  PageRequest._();

  factory PageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.common.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..aOS(2, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageRequest copyWith(void Function(PageRequest) updates) =>
      super.copyWith((message) => updates(message as PageRequest))
          as PageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageRequest create() => PageRequest._();
  @$core.override
  PageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageRequest>(create);
  static PageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get pageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set pageToken($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageToken() => $_clearField(2);
}

class PageResponse extends $pb.GeneratedMessage {
  factory PageResponse({
    $core.String? nextPageToken,
  }) {
    final result = create();
    if (nextPageToken != null) result.nextPageToken = nextPageToken;
    return result;
  }

  PageResponse._();

  factory PageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.common.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'nextPageToken')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PageResponse copyWith(void Function(PageResponse) updates) =>
      super.copyWith((message) => updates(message as PageResponse))
          as PageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PageResponse create() => PageResponse._();
  @$core.override
  PageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PageResponse>(create);
  static PageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nextPageToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set nextPageToken($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasNextPageToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearNextPageToken() => $_clearField(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
