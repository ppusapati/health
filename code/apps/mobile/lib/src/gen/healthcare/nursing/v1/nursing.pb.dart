// This is a generated file - do not edit.
//
// Generated from healthcare/nursing/v1/nursing.proto.

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

import 'nursing.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'nursing.pbenum.dart';

/// A coded concept from a terminology.
///
/// System and code together, never code alone.
class Coding extends $pb.GeneratedMessage {
  factory Coding({
    $core.String? system,
    $core.String? version,
    $core.String? code,
    $core.String? display,
  }) {
    final result = create();
    if (system != null) result.system = system;
    if (version != null) result.version = version;
    if (code != null) result.code = code;
    if (display != null) result.display = display;
    return result;
  }

  Coding._();

  factory Coding.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Coding.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Coding',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'system')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOS(4, _omitFieldNames ? '' : 'display')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Coding copyWith(void Function(Coding) updates) =>
      super.copyWith((message) => updates(message as Coding)) as Coding;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Coding create() => Coding._();
  @$core.override
  Coding createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Coding getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coding>(create);
  static Coding? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get system => $_getSZ(0);
  @$pb.TagNumber(1)
  set system($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSystem() => $_has(0);
  @$pb.TagNumber(1)
  void clearSystem() => $_clearField(1);

  /// Pins the release: codes have been reassigned between revisions.
  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  /// A bare code on a screen is a screen clinicians stop reading.
  @$pb.TagNumber(4)
  $core.String get display => $_getSZ(3);
  @$pb.TagNumber(4)
  set display($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDisplay() => $_has(3);
  @$pb.TagNumber(4)
  void clearDisplay() => $_clearField(4);
}

/// A measured value with its unit.
///
/// Inseparable: a potassium of 5 is ordinary in mmol/L and lethal in g/L.
class Quantity extends $pb.GeneratedMessage {
  factory Quantity({
    $core.double? value,
    $core.String? unit,
  }) {
    final result = create();
    if (value != null) result.value = value;
    if (unit != null) result.unit = unit;
    return result;
  }

  Quantity._();

  factory Quantity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Quantity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Quantity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'value')
    ..aOS(2, _omitFieldNames ? '' : 'unit')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Quantity copyWith(void Function(Quantity) updates) =>
      super.copyWith((message) => updates(message as Quantity)) as Quantity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Quantity create() => Quantity._();
  @$core.override
  Quantity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Quantity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Quantity>(create);
  static Quantity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get value => $_getN(0);
  @$pb.TagNumber(1)
  set value($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unit => $_getSZ(1);
  @$pb.TagNumber(2)
  set unit($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnit() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnit() => $_clearField(2);
}

/// One charted observation (SRS-NUR-003).
class FlowsheetEntry extends $pb.GeneratedMessage {
  factory FlowsheetEntry({
    $core.String? entryId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    Quantity? value,
    $core.String? textValue,
    Coding? codedValue,
    $0.Timestamp? observedAt,
    $0.Timestamp? recordedAt,
    EntrySource? source,
    $core.String? deviceId,
    $core.String? recordedBy,
    $core.String? lateEntryReason,
    $core.bool? late,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (entryId != null) result.entryId = entryId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (value != null) result.value = value;
    if (textValue != null) result.textValue = textValue;
    if (codedValue != null) result.codedValue = codedValue;
    if (observedAt != null) result.observedAt = observedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (source != null) result.source = source;
    if (deviceId != null) result.deviceId = deviceId;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (lateEntryReason != null) result.lateEntryReason = lateEntryReason;
    if (late != null) result.late = late;
    if (version != null) result.version = version;
    return result;
  }

  FlowsheetEntry._();

  factory FlowsheetEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FlowsheetEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FlowsheetEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entryId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOM<Quantity>(5, _omitFieldNames ? '' : 'value',
        subBuilder: Quantity.create)
    ..aOS(6, _omitFieldNames ? '' : 'textValue')
    ..aOM<Coding>(7, _omitFieldNames ? '' : 'codedValue',
        subBuilder: Coding.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EntrySource>(10, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOS(11, _omitFieldNames ? '' : 'deviceId')
    ..aOS(12, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(13, _omitFieldNames ? '' : 'lateEntryReason')
    ..aOB(14, _omitFieldNames ? '' : 'late')
    ..aInt64(15, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlowsheetEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FlowsheetEntry copyWith(void Function(FlowsheetEntry) updates) =>
      super.copyWith((message) => updates(message as FlowsheetEntry))
          as FlowsheetEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FlowsheetEntry create() => FlowsheetEntry._();
  @$core.override
  FlowsheetEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FlowsheetEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FlowsheetEntry>(create);
  static FlowsheetEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entryId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEntryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntryId() => $_clearField(1);

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
  Coding get code => $_getN(3);
  @$pb.TagNumber(4)
  set code(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearCode() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCode() => $_ensure(3);

  @$pb.TagNumber(5)
  Quantity get value => $_getN(4);
  @$pb.TagNumber(5)
  set value(Quantity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearValue() => $_clearField(5);
  @$pb.TagNumber(5)
  Quantity ensureValue() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get textValue => $_getSZ(5);
  @$pb.TagNumber(6)
  set textValue($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTextValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearTextValue() => $_clearField(6);

  @$pb.TagNumber(7)
  Coding get codedValue => $_getN(6);
  @$pb.TagNumber(7)
  set codedValue(Coding value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasCodedValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearCodedValue() => $_clearField(7);
  @$pb.TagNumber(7)
  Coding ensureCodedValue() => $_ensure(6);

  /// When the observation was true of the patient. Supplied by the nurse and
  /// never defaulted to the clock.
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

  /// When it reached the record. Server-assigned.
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
  EntrySource get source => $_getN(9);
  @$pb.TagNumber(10)
  set source(EntrySource value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSource() => $_has(9);
  @$pb.TagNumber(10)
  void clearSource() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get deviceId => $_getSZ(10);
  @$pb.TagNumber(11)
  set deviceId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDeviceId() => $_has(10);
  @$pb.TagNumber(11)
  void clearDeviceId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get recordedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set recordedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRecordedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearRecordedBy() => $_clearField(12);

  /// Required when the entry is late, because "the nurse was busy" and "found
  /// on paper during downtime" lead to different conclusions in a review.
  @$pb.TagNumber(13)
  $core.String get lateEntryReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set lateEntryReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasLateEntryReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearLateEntryReason() => $_clearField(13);

  /// Server-computed from the two times. On the wire so a chart can mark the
  /// entry without reimplementing the threshold.
  @$pb.TagNumber(14)
  $core.bool get late => $_getBF(13);
  @$pb.TagNumber(14)
  set late($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasLate() => $_has(13);
  @$pb.TagNumber(14)
  void clearLate() => $_clearField(14);

  @$pb.TagNumber(15)
  $fixnum.Int64 get version => $_getI64(14);
  @$pb.TagNumber(15)
  set version($fixnum.Int64 value) => $_setInt64(14, value);
  @$pb.TagNumber(15)
  $core.bool hasVersion() => $_has(14);
  @$pb.TagNumber(15)
  void clearVersion() => $_clearField(15);
}

class ChartObservationRequest extends $pb.GeneratedMessage {
  factory ChartObservationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? code,
    Quantity? value,
    $core.String? textValue,
    Coding? codedValue,
    $0.Timestamp? observedAt,
    EntrySource? source,
    $core.String? deviceId,
    $core.String? lateEntryReason,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (code != null) result.code = code;
    if (value != null) result.value = value;
    if (textValue != null) result.textValue = textValue;
    if (codedValue != null) result.codedValue = codedValue;
    if (observedAt != null) result.observedAt = observedAt;
    if (source != null) result.source = source;
    if (deviceId != null) result.deviceId = deviceId;
    if (lateEntryReason != null) result.lateEntryReason = lateEntryReason;
    return result;
  }

  ChartObservationRequest._();

  factory ChartObservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartObservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartObservationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'code', subBuilder: Coding.create)
    ..aOM<Quantity>(4, _omitFieldNames ? '' : 'value',
        subBuilder: Quantity.create)
    ..aOS(5, _omitFieldNames ? '' : 'textValue')
    ..aOM<Coding>(6, _omitFieldNames ? '' : 'codedValue',
        subBuilder: Coding.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aE<EntrySource>(8, _omitFieldNames ? '' : 'source',
        enumValues: EntrySource.values)
    ..aOS(9, _omitFieldNames ? '' : 'deviceId')
    ..aOS(10, _omitFieldNames ? '' : 'lateEntryReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartObservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartObservationRequest copyWith(
          void Function(ChartObservationRequest) updates) =>
      super.copyWith((message) => updates(message as ChartObservationRequest))
          as ChartObservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartObservationRequest create() => ChartObservationRequest._();
  @$core.override
  ChartObservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartObservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartObservationRequest>(create);
  static ChartObservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get code => $_getN(2);
  @$pb.TagNumber(3)
  set code(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCode() => $_ensure(2);

  @$pb.TagNumber(4)
  Quantity get value => $_getN(3);
  @$pb.TagNumber(4)
  set value(Quantity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearValue() => $_clearField(4);
  @$pb.TagNumber(4)
  Quantity ensureValue() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get textValue => $_getSZ(4);
  @$pb.TagNumber(5)
  set textValue($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTextValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearTextValue() => $_clearField(5);

  @$pb.TagNumber(6)
  Coding get codedValue => $_getN(5);
  @$pb.TagNumber(6)
  set codedValue(Coding value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCodedValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearCodedValue() => $_clearField(6);
  @$pb.TagNumber(6)
  Coding ensureCodedValue() => $_ensure(5);

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

  @$pb.TagNumber(8)
  EntrySource get source => $_getN(7);
  @$pb.TagNumber(8)
  set source(EntrySource value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearSource() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get deviceId => $_getSZ(8);
  @$pb.TagNumber(9)
  set deviceId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDeviceId() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeviceId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get lateEntryReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set lateEntryReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLateEntryReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearLateEntryReason() => $_clearField(10);
}

class ChartObservationResponse extends $pb.GeneratedMessage {
  factory ChartObservationResponse({
    FlowsheetEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  ChartObservationResponse._();

  factory ChartObservationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChartObservationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChartObservationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<FlowsheetEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: FlowsheetEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartObservationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChartObservationResponse copyWith(
          void Function(ChartObservationResponse) updates) =>
      super.copyWith((message) => updates(message as ChartObservationResponse))
          as ChartObservationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChartObservationResponse create() => ChartObservationResponse._();
  @$core.override
  ChartObservationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChartObservationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChartObservationResponse>(create);
  static ChartObservationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FlowsheetEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(FlowsheetEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  FlowsheetEntry ensureEntry() => $_ensure(0);
}

class GetFlowsheetRequest extends $pb.GeneratedMessage {
  factory GetFlowsheetRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? code,
    $0.Timestamp? observedFrom,
    $0.Timestamp? observedTo,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (code != null) result.code = code;
    if (observedFrom != null) result.observedFrom = observedFrom;
    if (observedTo != null) result.observedTo = observedTo;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetFlowsheetRequest._();

  factory GetFlowsheetRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFlowsheetRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFlowsheetRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'observedFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'observedTo',
        subBuilder: $0.Timestamp.create)
    ..aI(6, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFlowsheetRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFlowsheetRequest copyWith(void Function(GetFlowsheetRequest) updates) =>
      super.copyWith((message) => updates(message as GetFlowsheetRequest))
          as GetFlowsheetRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFlowsheetRequest create() => GetFlowsheetRequest._();
  @$core.override
  GetFlowsheetRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFlowsheetRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFlowsheetRequest>(create);
  static GetFlowsheetRequest? _defaultInstance;

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
  $core.String get code => $_getSZ(2);
  @$pb.TagNumber(3)
  set code($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearCode() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get observedFrom => $_getN(3);
  @$pb.TagNumber(4)
  set observedFrom($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasObservedFrom() => $_has(3);
  @$pb.TagNumber(4)
  void clearObservedFrom() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureObservedFrom() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get observedTo => $_getN(4);
  @$pb.TagNumber(5)
  set observedTo($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasObservedTo() => $_has(4);
  @$pb.TagNumber(5)
  void clearObservedTo() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureObservedTo() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.int get pageSize => $_getIZ(5);
  @$pb.TagNumber(6)
  set pageSize($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPageSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageSize() => $_clearField(6);
}

class GetFlowsheetResponse extends $pb.GeneratedMessage {
  factory GetFlowsheetResponse({
    $core.Iterable<FlowsheetEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  GetFlowsheetResponse._();

  factory GetFlowsheetResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFlowsheetResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFlowsheetResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<FlowsheetEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: FlowsheetEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFlowsheetResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFlowsheetResponse copyWith(void Function(GetFlowsheetResponse) updates) =>
      super.copyWith((message) => updates(message as GetFlowsheetResponse))
          as GetFlowsheetResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFlowsheetResponse create() => GetFlowsheetResponse._();
  @$core.override
  GetFlowsheetResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFlowsheetResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFlowsheetResponse>(create);
  static GetFlowsheetResponse? _defaultInstance;

  /// Ordered by observation time, oldest first: the chart is a picture of the
  /// patient, not of the typing.
  @$pb.TagNumber(1)
  $pb.PbList<FlowsheetEntry> get entries => $_getList(0);
}

/// One recorded volume (SRS-NUR-004).
class FluidEntry extends $pb.GeneratedMessage {
  factory FluidEntry({
    $core.String? fluidId,
    $core.String? patientId,
    $core.String? encounterId,
    FluidDirection? direction,
    $core.String? category,
    $core.double? volumeMl,
    $0.Timestamp? observedAt,
    $0.Timestamp? recordedAt,
    $core.String? recordedBy,
    $core.String? supersededById,
    $core.String? supersedesId,
    $core.String? amendmentReason,
    $core.String? voidedReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (fluidId != null) result.fluidId = fluidId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (direction != null) result.direction = direction;
    if (category != null) result.category = category;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (observedAt != null) result.observedAt = observedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (recordedBy != null) result.recordedBy = recordedBy;
    if (supersededById != null) result.supersededById = supersededById;
    if (supersedesId != null) result.supersedesId = supersedesId;
    if (amendmentReason != null) result.amendmentReason = amendmentReason;
    if (voidedReason != null) result.voidedReason = voidedReason;
    if (version != null) result.version = version;
    return result;
  }

  FluidEntry._();

  factory FluidEntry.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FluidEntry.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FluidEntry',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fluidId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<FluidDirection>(4, _omitFieldNames ? '' : 'direction',
        enumValues: FluidDirection.values)
    ..aOS(5, _omitFieldNames ? '' : 'category')
    ..aD(6, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'recordedBy')
    ..aOS(10, _omitFieldNames ? '' : 'supersededById')
    ..aOS(11, _omitFieldNames ? '' : 'supersedesId')
    ..aOS(12, _omitFieldNames ? '' : 'amendmentReason')
    ..aOS(13, _omitFieldNames ? '' : 'voidedReason')
    ..aInt64(14, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FluidEntry clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FluidEntry copyWith(void Function(FluidEntry) updates) =>
      super.copyWith((message) => updates(message as FluidEntry)) as FluidEntry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FluidEntry create() => FluidEntry._();
  @$core.override
  FluidEntry createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FluidEntry getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FluidEntry>(create);
  static FluidEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fluidId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fluidId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFluidId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFluidId() => $_clearField(1);

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
  FluidDirection get direction => $_getN(3);
  @$pb.TagNumber(4)
  set direction(FluidDirection value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirection() => $_clearField(4);

  /// Oral, intravenous, urine, drain. The balance is reported by category,
  /// because "2,400 ml out" means something different when it is all drain loss.
  @$pb.TagNumber(5)
  $core.String get category => $_getSZ(4);
  @$pb.TagNumber(5)
  set category($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearCategory() => $_clearField(5);

  /// Always millilitres, converted on the way in.
  @$pb.TagNumber(6)
  $core.double get volumeMl => $_getN(5);
  @$pb.TagNumber(6)
  set volumeMl($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasVolumeMl() => $_has(5);
  @$pb.TagNumber(6)
  void clearVolumeMl() => $_clearField(6);

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

  @$pb.TagNumber(9)
  $core.String get recordedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set recordedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecordedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecordedBy() => $_clearField(9);

  /// The amendment trail (SRS-NUR-004). A correction is a new entry; this one
  /// stays, because the shift total handed over was computed from it.
  @$pb.TagNumber(10)
  $core.String get supersededById => $_getSZ(9);
  @$pb.TagNumber(10)
  set supersededById($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSupersededById() => $_has(9);
  @$pb.TagNumber(10)
  void clearSupersededById() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get supersedesId => $_getSZ(10);
  @$pb.TagNumber(11)
  set supersedesId($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSupersedesId() => $_has(10);
  @$pb.TagNumber(11)
  void clearSupersedesId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get amendmentReason => $_getSZ(11);
  @$pb.TagNumber(12)
  set amendmentReason($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAmendmentReason() => $_has(11);
  @$pb.TagNumber(12)
  void clearAmendmentReason() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get voidedReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set voidedReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasVoidedReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearVoidedReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get version => $_getI64(13);
  @$pb.TagNumber(14)
  set version($fixnum.Int64 value) => $_setInt64(13, value);
  @$pb.TagNumber(14)
  $core.bool hasVersion() => $_has(13);
  @$pb.TagNumber(14)
  void clearVersion() => $_clearField(14);
}

class RecordFluidRequest extends $pb.GeneratedMessage {
  factory RecordFluidRequest({
    $core.String? patientId,
    $core.String? encounterId,
    FluidDirection? direction,
    $core.String? category,
    $core.double? volumeMl,
    $0.Timestamp? observedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (direction != null) result.direction = direction;
    if (category != null) result.category = category;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (observedAt != null) result.observedAt = observedAt;
    return result;
  }

  RecordFluidRequest._();

  factory RecordFluidRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordFluidRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordFluidRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<FluidDirection>(3, _omitFieldNames ? '' : 'direction',
        enumValues: FluidDirection.values)
    ..aOS(4, _omitFieldNames ? '' : 'category')
    ..aD(5, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFluidRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFluidRequest copyWith(void Function(RecordFluidRequest) updates) =>
      super.copyWith((message) => updates(message as RecordFluidRequest))
          as RecordFluidRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordFluidRequest create() => RecordFluidRequest._();
  @$core.override
  RecordFluidRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordFluidRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordFluidRequest>(create);
  static RecordFluidRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  FluidDirection get direction => $_getN(2);
  @$pb.TagNumber(3)
  set direction(FluidDirection value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearDirection() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get category => $_getSZ(3);
  @$pb.TagNumber(4)
  set category($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get volumeMl => $_getN(4);
  @$pb.TagNumber(5)
  set volumeMl($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeMl() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get observedAt => $_getN(5);
  @$pb.TagNumber(6)
  set observedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasObservedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearObservedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureObservedAt() => $_ensure(5);
}

class RecordFluidResponse extends $pb.GeneratedMessage {
  factory RecordFluidResponse({
    FluidEntry? entry,
  }) {
    final result = create();
    if (entry != null) result.entry = entry;
    return result;
  }

  RecordFluidResponse._();

  factory RecordFluidResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordFluidResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordFluidResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<FluidEntry>(1, _omitFieldNames ? '' : 'entry',
        subBuilder: FluidEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFluidResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordFluidResponse copyWith(void Function(RecordFluidResponse) updates) =>
      super.copyWith((message) => updates(message as RecordFluidResponse))
          as RecordFluidResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordFluidResponse create() => RecordFluidResponse._();
  @$core.override
  RecordFluidResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordFluidResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordFluidResponse>(create);
  static RecordFluidResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FluidEntry get entry => $_getN(0);
  @$pb.TagNumber(1)
  set entry(FluidEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEntry() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntry() => $_clearField(1);
  @$pb.TagNumber(1)
  FluidEntry ensureEntry() => $_ensure(0);
}

/// Correcting a volume produces a replacement. There is no UpdateFluidEntry:
/// the original is evidence.
class CorrectFluidRequest extends $pb.GeneratedMessage {
  factory CorrectFluidRequest({
    $core.String? fluidId,
    $core.double? volumeMl,
    $core.String? reason,
  }) {
    final result = create();
    if (fluidId != null) result.fluidId = fluidId;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (reason != null) result.reason = reason;
    return result;
  }

  CorrectFluidRequest._();

  factory CorrectFluidRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectFluidRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectFluidRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fluidId')
    ..aD(2, _omitFieldNames ? '' : 'volumeMl')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectFluidRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectFluidRequest copyWith(void Function(CorrectFluidRequest) updates) =>
      super.copyWith((message) => updates(message as CorrectFluidRequest))
          as CorrectFluidRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectFluidRequest create() => CorrectFluidRequest._();
  @$core.override
  CorrectFluidRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectFluidRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectFluidRequest>(create);
  static CorrectFluidRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fluidId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fluidId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFluidId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFluidId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get volumeMl => $_getN(1);
  @$pb.TagNumber(2)
  set volumeMl($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVolumeMl() => $_has(1);
  @$pb.TagNumber(2)
  void clearVolumeMl() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class CorrectFluidResponse extends $pb.GeneratedMessage {
  factory CorrectFluidResponse({
    FluidEntry? correction,
  }) {
    final result = create();
    if (correction != null) result.correction = correction;
    return result;
  }

  CorrectFluidResponse._();

  factory CorrectFluidResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CorrectFluidResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CorrectFluidResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<FluidEntry>(1, _omitFieldNames ? '' : 'correction',
        subBuilder: FluidEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectFluidResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CorrectFluidResponse copyWith(void Function(CorrectFluidResponse) updates) =>
      super.copyWith((message) => updates(message as CorrectFluidResponse))
          as CorrectFluidResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CorrectFluidResponse create() => CorrectFluidResponse._();
  @$core.override
  CorrectFluidResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CorrectFluidResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CorrectFluidResponse>(create);
  static CorrectFluidResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FluidEntry get correction => $_getN(0);
  @$pb.TagNumber(1)
  set correction(FluidEntry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCorrection() => $_has(0);
  @$pb.TagNumber(1)
  void clearCorrection() => $_clearField(1);
  @$pb.TagNumber(1)
  FluidEntry ensureCorrection() => $_ensure(0);
}

/// A running total over a period (SRS-NUR-004).
class FluidBalance extends $pb.GeneratedMessage {
  factory FluidBalance({
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.double? intakeMl,
    $core.double? outputMl,
    $core.double? netMl,
    $core.Iterable<$core.MapEntry<$core.String, $core.double>>? byCategory,
    $core.int? counted,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (intakeMl != null) result.intakeMl = intakeMl;
    if (outputMl != null) result.outputMl = outputMl;
    if (netMl != null) result.netMl = netMl;
    if (byCategory != null) result.byCategory.addEntries(byCategory);
    if (counted != null) result.counted = counted;
    return result;
  }

  FluidBalance._();

  factory FluidBalance.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FluidBalance.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FluidBalance',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aD(3, _omitFieldNames ? '' : 'intakeMl')
    ..aD(4, _omitFieldNames ? '' : 'outputMl')
    ..aD(5, _omitFieldNames ? '' : 'netMl')
    ..m<$core.String, $core.double>(6, _omitFieldNames ? '' : 'byCategory',
        entryClassName: 'FluidBalance.ByCategoryEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OD,
        packageName: const $pb.PackageName('healthcare.nursing.v1'))
    ..aI(7, _omitFieldNames ? '' : 'counted')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FluidBalance clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FluidBalance copyWith(void Function(FluidBalance) updates) =>
      super.copyWith((message) => updates(message as FluidBalance))
          as FluidBalance;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FluidBalance create() => FluidBalance._();
  @$core.override
  FluidBalance createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FluidBalance getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FluidBalance>(create);
  static FluidBalance? _defaultInstance;

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
  $core.double get intakeMl => $_getN(2);
  @$pb.TagNumber(3)
  set intakeMl($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasIntakeMl() => $_has(2);
  @$pb.TagNumber(3)
  void clearIntakeMl() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get outputMl => $_getN(3);
  @$pb.TagNumber(4)
  set outputMl($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputMl() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputMl() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get netMl => $_getN(4);
  @$pb.TagNumber(5)
  set netMl($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNetMl() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetMl() => $_clearField(5);

  /// The breakdown, keyed "intake:oral", "output:drain".
  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.double> get byCategory => $_getMap(5);

  @$pb.TagNumber(7)
  $core.int get counted => $_getIZ(6);
  @$pb.TagNumber(7)
  set counted($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasCounted() => $_has(6);
  @$pb.TagNumber(7)
  void clearCounted() => $_clearField(7);
}

class GetFluidBalanceRequest extends $pb.GeneratedMessage {
  factory GetFluidBalanceRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetFluidBalanceRequest._();

  factory GetFluidBalanceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFluidBalanceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFluidBalanceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidBalanceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidBalanceRequest copyWith(
          void Function(GetFluidBalanceRequest) updates) =>
      super.copyWith((message) => updates(message as GetFluidBalanceRequest))
          as GetFluidBalanceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFluidBalanceRequest create() => GetFluidBalanceRequest._();
  @$core.override
  GetFluidBalanceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFluidBalanceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFluidBalanceRequest>(create);
  static GetFluidBalanceRequest? _defaultInstance;

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
}

class GetFluidBalanceResponse extends $pb.GeneratedMessage {
  factory GetFluidBalanceResponse({
    FluidBalance? balance,
  }) {
    final result = create();
    if (balance != null) result.balance = balance;
    return result;
  }

  GetFluidBalanceResponse._();

  factory GetFluidBalanceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFluidBalanceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFluidBalanceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<FluidBalance>(1, _omitFieldNames ? '' : 'balance',
        subBuilder: FluidBalance.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidBalanceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidBalanceResponse copyWith(
          void Function(GetFluidBalanceResponse) updates) =>
      super.copyWith((message) => updates(message as GetFluidBalanceResponse))
          as GetFluidBalanceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFluidBalanceResponse create() => GetFluidBalanceResponse._();
  @$core.override
  GetFluidBalanceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFluidBalanceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFluidBalanceResponse>(create);
  static GetFluidBalanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FluidBalance get balance => $_getN(0);
  @$pb.TagNumber(1)
  set balance(FluidBalance value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => $_clearField(1);
  @$pb.TagNumber(1)
  FluidBalance ensureBalance() => $_ensure(0);
}

class GetFluidTrailRequest extends $pb.GeneratedMessage {
  factory GetFluidTrailRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $0.Timestamp? from,
    $0.Timestamp? to,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetFluidTrailRequest._();

  factory GetFluidTrailRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFluidTrailRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFluidTrailRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidTrailRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidTrailRequest copyWith(void Function(GetFluidTrailRequest) updates) =>
      super.copyWith((message) => updates(message as GetFluidTrailRequest))
          as GetFluidTrailRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFluidTrailRequest create() => GetFluidTrailRequest._();
  @$core.override
  GetFluidTrailRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFluidTrailRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFluidTrailRequest>(create);
  static GetFluidTrailRequest? _defaultInstance;

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

class GetFluidTrailResponse extends $pb.GeneratedMessage {
  factory GetFluidTrailResponse({
    $core.Iterable<FluidEntry>? entries,
  }) {
    final result = create();
    if (entries != null) result.entries.addAll(entries);
    return result;
  }

  GetFluidTrailResponse._();

  factory GetFluidTrailResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFluidTrailResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFluidTrailResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<FluidEntry>(1, _omitFieldNames ? '' : 'entries',
        subBuilder: FluidEntry.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidTrailResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFluidTrailResponse copyWith(
          void Function(GetFluidTrailResponse) updates) =>
      super.copyWith((message) => updates(message as GetFluidTrailResponse))
          as GetFluidTrailResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFluidTrailResponse create() => GetFluidTrailResponse._();
  @$core.override
  GetFluidTrailResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFluidTrailResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFluidTrailResponse>(create);
  static GetFluidTrailResponse? _defaultInstance;

  /// Superseded and voided entries included: this is the audit view.
  @$pb.TagNumber(1)
  $pb.PbList<FluidEntry> get entries => $_getList(0);
}

/// One heading and the questions under it.
class TemplateSection extends $pb.GeneratedMessage {
  factory TemplateSection({
    $core.String? heading,
    $core.bool? required,
    $core.Iterable<$core.String>? prompts,
  }) {
    final result = create();
    if (heading != null) result.heading = heading;
    if (required != null) result.required = required;
    if (prompts != null) result.prompts.addAll(prompts);
    return result;
  }

  TemplateSection._();

  factory TemplateSection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TemplateSection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TemplateSection',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'heading')
    ..aOB(2, _omitFieldNames ? '' : 'required')
    ..pPS(3, _omitFieldNames ? '' : 'prompts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateSection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TemplateSection copyWith(void Function(TemplateSection) updates) =>
      super.copyWith((message) => updates(message as TemplateSection))
          as TemplateSection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TemplateSection create() => TemplateSection._();
  @$core.override
  TemplateSection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TemplateSection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TemplateSection>(create);
  static TemplateSection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get heading => $_getSZ(0);
  @$pb.TagNumber(1)
  set heading($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeading() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeading() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get required => $_getBF(1);
  @$pb.TagNumber(2)
  set required($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequired() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequired() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get prompts => $_getList(2);
}

/// A versioned assessment structure (SRS-NUR-001).
class AssessmentTemplate extends $pb.GeneratedMessage {
  factory AssessmentTemplate({
    $core.String? templateId,
    $core.String? version,
    $core.String? name,
    $core.int? minAgeYears,
    $core.int? maxAgeYears,
    $core.String? serviceCode,
    $core.Iterable<TemplateSection>? sections,
    $core.bool? retired,
  }) {
    final result = create();
    if (templateId != null) result.templateId = templateId;
    if (version != null) result.version = version;
    if (name != null) result.name = name;
    if (minAgeYears != null) result.minAgeYears = minAgeYears;
    if (maxAgeYears != null) result.maxAgeYears = maxAgeYears;
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (sections != null) result.sections.addAll(sections);
    if (retired != null) result.retired = retired;
    return result;
  }

  AssessmentTemplate._();

  factory AssessmentTemplate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssessmentTemplate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssessmentTemplate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aI(4, _omitFieldNames ? '' : 'minAgeYears')
    ..aI(5, _omitFieldNames ? '' : 'maxAgeYears')
    ..aOS(6, _omitFieldNames ? '' : 'serviceCode')
    ..pPM<TemplateSection>(7, _omitFieldNames ? '' : 'sections',
        subBuilder: TemplateSection.create)
    ..aOB(8, _omitFieldNames ? '' : 'retired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessmentTemplate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessmentTemplate copyWith(void Function(AssessmentTemplate) updates) =>
      super.copyWith((message) => updates(message as AssessmentTemplate))
          as AssessmentTemplate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssessmentTemplate create() => AssessmentTemplate._();
  @$core.override
  AssessmentTemplate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssessmentTemplate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssessmentTemplate>(create);
  static AssessmentTemplate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  /// Age band and service, which is what "age/service-specific" means. A
  /// max_age_years of zero means no upper bound.
  @$pb.TagNumber(4)
  $core.int get minAgeYears => $_getIZ(3);
  @$pb.TagNumber(4)
  set minAgeYears($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMinAgeYears() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinAgeYears() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get maxAgeYears => $_getIZ(4);
  @$pb.TagNumber(5)
  set maxAgeYears($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMaxAgeYears() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxAgeYears() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get serviceCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set serviceCode($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasServiceCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearServiceCode() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<TemplateSection> get sections => $_getList(6);

  /// A retired template can be read on old assessments but not chosen for a new
  /// one.
  @$pb.TagNumber(8)
  $core.bool get retired => $_getBF(7);
  @$pb.TagNumber(8)
  set retired($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRetired() => $_has(7);
  @$pb.TagNumber(8)
  void clearRetired() => $_clearField(8);
}

class DefineAssessmentTemplateRequest extends $pb.GeneratedMessage {
  factory DefineAssessmentTemplateRequest({
    AssessmentTemplate? template,
  }) {
    final result = create();
    if (template != null) result.template = template;
    return result;
  }

  DefineAssessmentTemplateRequest._();

  factory DefineAssessmentTemplateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineAssessmentTemplateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineAssessmentTemplateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<AssessmentTemplate>(1, _omitFieldNames ? '' : 'template',
        subBuilder: AssessmentTemplate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineAssessmentTemplateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineAssessmentTemplateRequest copyWith(
          void Function(DefineAssessmentTemplateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DefineAssessmentTemplateRequest))
          as DefineAssessmentTemplateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineAssessmentTemplateRequest create() =>
      DefineAssessmentTemplateRequest._();
  @$core.override
  DefineAssessmentTemplateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineAssessmentTemplateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineAssessmentTemplateRequest>(
          create);
  static DefineAssessmentTemplateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  AssessmentTemplate get template => $_getN(0);
  @$pb.TagNumber(1)
  set template(AssessmentTemplate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplate() => $_clearField(1);
  @$pb.TagNumber(1)
  AssessmentTemplate ensureTemplate() => $_ensure(0);
}

class DefineAssessmentTemplateResponse extends $pb.GeneratedMessage {
  factory DefineAssessmentTemplateResponse({
    AssessmentTemplate? template,
  }) {
    final result = create();
    if (template != null) result.template = template;
    return result;
  }

  DefineAssessmentTemplateResponse._();

  factory DefineAssessmentTemplateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineAssessmentTemplateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineAssessmentTemplateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<AssessmentTemplate>(1, _omitFieldNames ? '' : 'template',
        subBuilder: AssessmentTemplate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineAssessmentTemplateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineAssessmentTemplateResponse copyWith(
          void Function(DefineAssessmentTemplateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DefineAssessmentTemplateResponse))
          as DefineAssessmentTemplateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineAssessmentTemplateResponse create() =>
      DefineAssessmentTemplateResponse._();
  @$core.override
  DefineAssessmentTemplateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineAssessmentTemplateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineAssessmentTemplateResponse>(
          create);
  static DefineAssessmentTemplateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AssessmentTemplate get template => $_getN(0);
  @$pb.TagNumber(1)
  set template(AssessmentTemplate value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplate() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplate() => $_clearField(1);
  @$pb.TagNumber(1)
  AssessmentTemplate ensureTemplate() => $_ensure(0);
}

class ListAssessmentTemplatesRequest extends $pb.GeneratedMessage {
  factory ListAssessmentTemplatesRequest({
    $core.String? serviceCode,
    $core.bool? includeRetired,
    $core.int? pageSize,
  }) {
    final result = create();
    if (serviceCode != null) result.serviceCode = serviceCode;
    if (includeRetired != null) result.includeRetired = includeRetired;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAssessmentTemplatesRequest._();

  factory ListAssessmentTemplatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssessmentTemplatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssessmentTemplatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceCode')
    ..aOB(2, _omitFieldNames ? '' : 'includeRetired')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentTemplatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentTemplatesRequest copyWith(
          void Function(ListAssessmentTemplatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListAssessmentTemplatesRequest))
          as ListAssessmentTemplatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssessmentTemplatesRequest create() =>
      ListAssessmentTemplatesRequest._();
  @$core.override
  ListAssessmentTemplatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssessmentTemplatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssessmentTemplatesRequest>(create);
  static ListAssessmentTemplatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceCode($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasServiceCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeRetired => $_getBF(1);
  @$pb.TagNumber(2)
  set includeRetired($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIncludeRetired() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeRetired() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListAssessmentTemplatesResponse extends $pb.GeneratedMessage {
  factory ListAssessmentTemplatesResponse({
    $core.Iterable<AssessmentTemplate>? templates,
  }) {
    final result = create();
    if (templates != null) result.templates.addAll(templates);
    return result;
  }

  ListAssessmentTemplatesResponse._();

  factory ListAssessmentTemplatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssessmentTemplatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssessmentTemplatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<AssessmentTemplate>(1, _omitFieldNames ? '' : 'templates',
        subBuilder: AssessmentTemplate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentTemplatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentTemplatesResponse copyWith(
          void Function(ListAssessmentTemplatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListAssessmentTemplatesResponse))
          as ListAssessmentTemplatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssessmentTemplatesResponse create() =>
      ListAssessmentTemplatesResponse._();
  @$core.override
  ListAssessmentTemplatesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssessmentTemplatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssessmentTemplatesResponse>(
          create);
  static ListAssessmentTemplatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AssessmentTemplate> get templates => $_getList(0);
}

class RetireAssessmentTemplateRequest extends $pb.GeneratedMessage {
  factory RetireAssessmentTemplateRequest({
    $core.String? templateId,
    $core.String? version,
  }) {
    final result = create();
    if (templateId != null) result.templateId = templateId;
    if (version != null) result.version = version;
    return result;
  }

  RetireAssessmentTemplateRequest._();

  factory RetireAssessmentTemplateRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireAssessmentTemplateRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireAssessmentTemplateRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'templateId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireAssessmentTemplateRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireAssessmentTemplateRequest copyWith(
          void Function(RetireAssessmentTemplateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as RetireAssessmentTemplateRequest))
          as RetireAssessmentTemplateRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireAssessmentTemplateRequest create() =>
      RetireAssessmentTemplateRequest._();
  @$core.override
  RetireAssessmentTemplateRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireAssessmentTemplateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireAssessmentTemplateRequest>(
          create);
  static RetireAssessmentTemplateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get templateId => $_getSZ(0);
  @$pb.TagNumber(1)
  set templateId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTemplateId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemplateId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class RetireAssessmentTemplateResponse extends $pb.GeneratedMessage {
  factory RetireAssessmentTemplateResponse() => create();

  RetireAssessmentTemplateResponse._();

  factory RetireAssessmentTemplateResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetireAssessmentTemplateResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetireAssessmentTemplateResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireAssessmentTemplateResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetireAssessmentTemplateResponse copyWith(
          void Function(RetireAssessmentTemplateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as RetireAssessmentTemplateResponse))
          as RetireAssessmentTemplateResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetireAssessmentTemplateResponse create() =>
      RetireAssessmentTemplateResponse._();
  @$core.override
  RetireAssessmentTemplateResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetireAssessmentTemplateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetireAssessmentTemplateResponse>(
          create);
  static RetireAssessmentTemplateResponse? _defaultInstance;
}

class Answer extends $pb.GeneratedMessage {
  factory Answer({
    $core.String? heading,
    $core.String? prompt,
    $core.String? value,
    Coding? coded,
  }) {
    final result = create();
    if (heading != null) result.heading = heading;
    if (prompt != null) result.prompt = prompt;
    if (value != null) result.value = value;
    if (coded != null) result.coded = coded;
    return result;
  }

  Answer._();

  factory Answer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Answer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Answer',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'heading')
    ..aOS(2, _omitFieldNames ? '' : 'prompt')
    ..aOS(3, _omitFieldNames ? '' : 'value')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'coded', subBuilder: Coding.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Answer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Answer copyWith(void Function(Answer) updates) =>
      super.copyWith((message) => updates(message as Answer)) as Answer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Answer create() => Answer._();
  @$core.override
  Answer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Answer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Answer>(create);
  static Answer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get heading => $_getSZ(0);
  @$pb.TagNumber(1)
  set heading($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHeading() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeading() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get prompt => $_getSZ(1);
  @$pb.TagNumber(2)
  set prompt($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPrompt() => $_has(1);
  @$pb.TagNumber(2)
  void clearPrompt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get value => $_getSZ(2);
  @$pb.TagNumber(3)
  set value($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get coded => $_getN(3);
  @$pb.TagNumber(4)
  set coded(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasCoded() => $_has(3);
  @$pb.TagNumber(4)
  void clearCoded() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureCoded() => $_ensure(3);
}

/// One completed nursing assessment (SRS-NUR-001).
class Assessment extends $pb.GeneratedMessage {
  factory Assessment({
    $core.String? assessmentId,
    $core.String? patientId,
    $core.String? encounterId,
    AssessmentKind? kind,
    $core.String? templateId,
    $core.String? templateVersion,
    $core.Iterable<Answer>? answers,
    $0.Timestamp? assessedAt,
    $0.Timestamp? recordedAt,
    $core.String? assessedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (assessmentId != null) result.assessmentId = assessmentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (templateId != null) result.templateId = templateId;
    if (templateVersion != null) result.templateVersion = templateVersion;
    if (answers != null) result.answers.addAll(answers);
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (version != null) result.version = version;
    return result;
  }

  Assessment._();

  factory Assessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Assessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Assessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<AssessmentKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: AssessmentKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'templateId')
    ..aOS(6, _omitFieldNames ? '' : 'templateVersion')
    ..pPM<Answer>(7, _omitFieldNames ? '' : 'answers',
        subBuilder: Answer.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'assessedBy')
    ..aInt64(11, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Assessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Assessment copyWith(void Function(Assessment) updates) =>
      super.copyWith((message) => updates(message as Assessment)) as Assessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Assessment create() => Assessment._();
  @$core.override
  Assessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Assessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Assessment>(create);
  static Assessment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assessmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assessmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessmentId() => $_clearField(1);

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
  AssessmentKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(AssessmentKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  /// Stored, not resolved at read time: a template edited afterwards would
  /// otherwise silently restate what was asked.
  @$pb.TagNumber(5)
  $core.String get templateId => $_getSZ(4);
  @$pb.TagNumber(5)
  set templateId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTemplateId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemplateId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get templateVersion => $_getSZ(5);
  @$pb.TagNumber(6)
  set templateVersion($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTemplateVersion() => $_has(5);
  @$pb.TagNumber(6)
  void clearTemplateVersion() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<Answer> get answers => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get assessedAt => $_getN(7);
  @$pb.TagNumber(8)
  set assessedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasAssessedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssessedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureAssessedAt() => $_ensure(7);

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
  $core.String get assessedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set assessedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasAssessedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearAssessedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get version => $_getI64(10);
  @$pb.TagNumber(11)
  set version($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVersion() => $_has(10);
  @$pb.TagNumber(11)
  void clearVersion() => $_clearField(11);
}

class RecordAssessmentRequest extends $pb.GeneratedMessage {
  factory RecordAssessmentRequest({
    $core.String? patientId,
    $core.String? encounterId,
    AssessmentKind? kind,
    $core.String? templateId,
    $core.String? templateVersion,
    $core.Iterable<Answer>? answers,
    $0.Timestamp? assessedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (templateId != null) result.templateId = templateId;
    if (templateVersion != null) result.templateVersion = templateVersion;
    if (answers != null) result.answers.addAll(answers);
    if (assessedAt != null) result.assessedAt = assessedAt;
    return result;
  }

  RecordAssessmentRequest._();

  factory RecordAssessmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAssessmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAssessmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<AssessmentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: AssessmentKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'templateId')
    ..aOS(5, _omitFieldNames ? '' : 'templateVersion')
    ..pPM<Answer>(6, _omitFieldNames ? '' : 'answers',
        subBuilder: Answer.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAssessmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAssessmentRequest copyWith(
          void Function(RecordAssessmentRequest) updates) =>
      super.copyWith((message) => updates(message as RecordAssessmentRequest))
          as RecordAssessmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAssessmentRequest create() => RecordAssessmentRequest._();
  @$core.override
  RecordAssessmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAssessmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAssessmentRequest>(create);
  static RecordAssessmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  AssessmentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(AssessmentKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get templateId => $_getSZ(3);
  @$pb.TagNumber(4)
  set templateId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemplateId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemplateId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get templateVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set templateVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTemplateVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearTemplateVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Answer> get answers => $_getList(5);

  @$pb.TagNumber(7)
  $0.Timestamp get assessedAt => $_getN(6);
  @$pb.TagNumber(7)
  set assessedAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasAssessedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearAssessedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureAssessedAt() => $_ensure(6);
}

class RecordAssessmentResponse extends $pb.GeneratedMessage {
  factory RecordAssessmentResponse({
    Assessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  RecordAssessmentResponse._();

  factory RecordAssessmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordAssessmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordAssessmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Assessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: Assessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAssessmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordAssessmentResponse copyWith(
          void Function(RecordAssessmentResponse) updates) =>
      super.copyWith((message) => updates(message as RecordAssessmentResponse))
          as RecordAssessmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordAssessmentResponse create() => RecordAssessmentResponse._();
  @$core.override
  RecordAssessmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordAssessmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordAssessmentResponse>(create);
  static RecordAssessmentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Assessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(Assessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  Assessment ensureAssessment() => $_ensure(0);
}

class ListAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListAssessmentsRequest({
    $core.String? encounterId,
    $core.String? patientId,
    AssessmentKind? kind,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (kind != null) result.kind = kind;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAssessmentsRequest._();

  factory ListAssessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssessmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aE<AssessmentKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: AssessmentKind.values)
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentsRequest copyWith(
          void Function(ListAssessmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAssessmentsRequest))
          as ListAssessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssessmentsRequest create() => ListAssessmentsRequest._();
  @$core.override
  ListAssessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssessmentsRequest>(create);
  static ListAssessmentsRequest? _defaultInstance;

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
  AssessmentKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(AssessmentKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListAssessmentsResponse({
    $core.Iterable<Assessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListAssessmentsResponse._();

  factory ListAssessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssessmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Assessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: Assessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssessmentsResponse copyWith(
          void Function(ListAssessmentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAssessmentsResponse))
          as ListAssessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssessmentsResponse create() => ListAssessmentsResponse._();
  @$core.override
  ListAssessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssessmentsResponse>(create);
  static ListAssessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Assessment> get assessments => $_getList(0);
}

/// One factor a scale takes. The bounds catch a mis-keyed 40 in a 1–4 field
/// where it happens, rather than as a patient at implausible risk.
class RiskInput extends $pb.GeneratedMessage {
  factory RiskInput({
    $core.String? key,
    $core.String? label,
    $core.int? min,
    $core.int? max,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (min != null) result.min = min;
    if (max != null) result.max = max;
    return result;
  }

  RiskInput._();

  factory RiskInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RiskInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RiskInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aI(3, _omitFieldNames ? '' : 'min')
    ..aI(4, _omitFieldNames ? '' : 'max')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskInput copyWith(void Function(RiskInput) updates) =>
      super.copyWith((message) => updates(message as RiskInput)) as RiskInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RiskInput create() => RiskInput._();
  @$core.override
  RiskInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RiskInput getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RiskInput>(create);
  static RiskInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get min => $_getIZ(2);
  @$pb.TagNumber(3)
  set min($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMin() => $_has(2);
  @$pb.TagNumber(3)
  void clearMin() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get max => $_getIZ(3);
  @$pb.TagNumber(4)
  set max($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMax() => $_has(3);
  @$pb.TagNumber(4)
  void clearMax() => $_clearField(4);
}

/// A total mapped onto a category.
class RiskBand extends $pb.GeneratedMessage {
  factory RiskBand({
    $core.int? from,
    $core.int? to,
    $core.String? label,
    $core.bool? escalate,
  }) {
    final result = create();
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    if (label != null) result.label = label;
    if (escalate != null) result.escalate = escalate;
    return result;
  }

  RiskBand._();

  factory RiskBand.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RiskBand.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RiskBand',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'from')
    ..aI(2, _omitFieldNames ? '' : 'to')
    ..aOS(3, _omitFieldNames ? '' : 'label')
    ..aOB(4, _omitFieldNames ? '' : 'escalate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskBand clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskBand copyWith(void Function(RiskBand) updates) =>
      super.copyWith((message) => updates(message as RiskBand)) as RiskBand;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RiskBand create() => RiskBand._();
  @$core.override
  RiskBand createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RiskBand getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RiskBand>(create);
  static RiskBand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get from => $_getIZ(0);
  @$pb.TagNumber(1)
  set from($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFrom() => $_has(0);
  @$pb.TagNumber(1)
  void clearFrom() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get to => $_getIZ(1);
  @$pb.TagNumber(2)
  set to($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearTo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get label => $_getSZ(2);
  @$pb.TagNumber(3)
  set label($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLabel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLabel() => $_clearField(3);

  /// The band that requires action rather than observation.
  @$pb.TagNumber(4)
  $core.bool get escalate => $_getBF(3);
  @$pb.TagNumber(4)
  set escalate($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEscalate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEscalate() => $_clearField(4);
}

/// A named, versioned scoring instrument (SRS-NUR-005).
class RiskScale extends $pb.GeneratedMessage {
  factory RiskScale({
    $core.String? scaleId,
    $core.String? version,
    $core.String? name,
    RiskDomain? domain,
    $core.Iterable<RiskInput>? inputs,
    $core.Iterable<RiskBand>? bands,
    $fixnum.Int64? reassessAfterSeconds,
    $core.bool? retired,
  }) {
    final result = create();
    if (scaleId != null) result.scaleId = scaleId;
    if (version != null) result.version = version;
    if (name != null) result.name = name;
    if (domain != null) result.domain = domain;
    if (inputs != null) result.inputs.addAll(inputs);
    if (bands != null) result.bands.addAll(bands);
    if (reassessAfterSeconds != null)
      result.reassessAfterSeconds = reassessAfterSeconds;
    if (retired != null) result.retired = retired;
    return result;
  }

  RiskScale._();

  factory RiskScale.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RiskScale.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RiskScale',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scaleId')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aE<RiskDomain>(4, _omitFieldNames ? '' : 'domain',
        enumValues: RiskDomain.values)
    ..pPM<RiskInput>(5, _omitFieldNames ? '' : 'inputs',
        subBuilder: RiskInput.create)
    ..pPM<RiskBand>(6, _omitFieldNames ? '' : 'bands',
        subBuilder: RiskBand.create)
    ..aInt64(7, _omitFieldNames ? '' : 'reassessAfterSeconds')
    ..aOB(8, _omitFieldNames ? '' : 'retired')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskScale clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskScale copyWith(void Function(RiskScale) updates) =>
      super.copyWith((message) => updates(message as RiskScale)) as RiskScale;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RiskScale create() => RiskScale._();
  @$core.override
  RiskScale createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RiskScale getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RiskScale>(create);
  static RiskScale? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scaleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set scaleId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScaleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearScaleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  RiskDomain get domain => $_getN(3);
  @$pb.TagNumber(4)
  set domain(RiskDomain value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDomain() => $_has(3);
  @$pb.TagNumber(4)
  void clearDomain() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<RiskInput> get inputs => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<RiskBand> get bands => $_getList(5);

  /// How long a score stays current. A Braden from four days ago is not an
  /// assessment of today's patient.
  @$pb.TagNumber(7)
  $fixnum.Int64 get reassessAfterSeconds => $_getI64(6);
  @$pb.TagNumber(7)
  set reassessAfterSeconds($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasReassessAfterSeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearReassessAfterSeconds() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get retired => $_getBF(7);
  @$pb.TagNumber(8)
  set retired($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasRetired() => $_has(7);
  @$pb.TagNumber(8)
  void clearRetired() => $_clearField(8);
}

class DefineRiskScaleRequest extends $pb.GeneratedMessage {
  factory DefineRiskScaleRequest({
    RiskScale? scale,
  }) {
    final result = create();
    if (scale != null) result.scale = scale;
    return result;
  }

  DefineRiskScaleRequest._();

  factory DefineRiskScaleRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineRiskScaleRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineRiskScaleRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<RiskScale>(1, _omitFieldNames ? '' : 'scale',
        subBuilder: RiskScale.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineRiskScaleRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineRiskScaleRequest copyWith(
          void Function(DefineRiskScaleRequest) updates) =>
      super.copyWith((message) => updates(message as DefineRiskScaleRequest))
          as DefineRiskScaleRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineRiskScaleRequest create() => DefineRiskScaleRequest._();
  @$core.override
  DefineRiskScaleRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineRiskScaleRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineRiskScaleRequest>(create);
  static DefineRiskScaleRequest? _defaultInstance;

  @$pb.TagNumber(1)
  RiskScale get scale => $_getN(0);
  @$pb.TagNumber(1)
  set scale(RiskScale value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearScale() => $_clearField(1);
  @$pb.TagNumber(1)
  RiskScale ensureScale() => $_ensure(0);
}

class DefineRiskScaleResponse extends $pb.GeneratedMessage {
  factory DefineRiskScaleResponse({
    RiskScale? scale,
  }) {
    final result = create();
    if (scale != null) result.scale = scale;
    return result;
  }

  DefineRiskScaleResponse._();

  factory DefineRiskScaleResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DefineRiskScaleResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DefineRiskScaleResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<RiskScale>(1, _omitFieldNames ? '' : 'scale',
        subBuilder: RiskScale.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineRiskScaleResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DefineRiskScaleResponse copyWith(
          void Function(DefineRiskScaleResponse) updates) =>
      super.copyWith((message) => updates(message as DefineRiskScaleResponse))
          as DefineRiskScaleResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DefineRiskScaleResponse create() => DefineRiskScaleResponse._();
  @$core.override
  DefineRiskScaleResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DefineRiskScaleResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DefineRiskScaleResponse>(create);
  static DefineRiskScaleResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RiskScale get scale => $_getN(0);
  @$pb.TagNumber(1)
  set scale(RiskScale value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasScale() => $_has(0);
  @$pb.TagNumber(1)
  void clearScale() => $_clearField(1);
  @$pb.TagNumber(1)
  RiskScale ensureScale() => $_ensure(0);
}

/// One scored assessment (SRS-NUR-005).
class RiskAssessment extends $pb.GeneratedMessage {
  factory RiskAssessment({
    $core.String? riskId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? scaleId,
    $core.String? scaleVersion,
    RiskDomain? domain,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? inputs,
    $core.int? total,
    $core.String? band,
    $core.bool? escalate,
    $0.Timestamp? assessedAt,
    $0.Timestamp? recordedAt,
    $core.String? assessedBy,
    $0.Timestamp? dueAt,
    $core.String? supersededById,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (riskId != null) result.riskId = riskId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (scaleId != null) result.scaleId = scaleId;
    if (scaleVersion != null) result.scaleVersion = scaleVersion;
    if (domain != null) result.domain = domain;
    if (inputs != null) result.inputs.addEntries(inputs);
    if (total != null) result.total = total;
    if (band != null) result.band = band;
    if (escalate != null) result.escalate = escalate;
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (dueAt != null) result.dueAt = dueAt;
    if (supersededById != null) result.supersededById = supersededById;
    if (version != null) result.version = version;
    return result;
  }

  RiskAssessment._();

  factory RiskAssessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RiskAssessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RiskAssessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'riskId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'scaleId')
    ..aOS(5, _omitFieldNames ? '' : 'scaleVersion')
    ..aE<RiskDomain>(6, _omitFieldNames ? '' : 'domain',
        enumValues: RiskDomain.values)
    ..m<$core.String, $core.int>(7, _omitFieldNames ? '' : 'inputs',
        entryClassName: 'RiskAssessment.InputsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.nursing.v1'))
    ..aI(8, _omitFieldNames ? '' : 'total')
    ..aOS(9, _omitFieldNames ? '' : 'band')
    ..aOB(10, _omitFieldNames ? '' : 'escalate')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'assessedBy')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'supersededById')
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskAssessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RiskAssessment copyWith(void Function(RiskAssessment) updates) =>
      super.copyWith((message) => updates(message as RiskAssessment))
          as RiskAssessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RiskAssessment create() => RiskAssessment._();
  @$core.override
  RiskAssessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RiskAssessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RiskAssessment>(create);
  static RiskAssessment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get riskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set riskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRiskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRiskId() => $_clearField(1);

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
  $core.String get scaleId => $_getSZ(3);
  @$pb.TagNumber(4)
  set scaleId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScaleId() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get scaleVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set scaleVersion($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasScaleVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearScaleVersion() => $_clearField(5);

  @$pb.TagNumber(6)
  RiskDomain get domain => $_getN(5);
  @$pb.TagNumber(6)
  set domain(RiskDomain value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDomain() => $_has(5);
  @$pb.TagNumber(6)
  void clearDomain() => $_clearField(6);

  /// The inputs as answered. Stored with the total, because a total on its own
  /// cannot be checked, explained or recomputed.
  @$pb.TagNumber(7)
  $pb.PbMap<$core.String, $core.int> get inputs => $_getMap(6);

  @$pb.TagNumber(8)
  $core.int get total => $_getIZ(7);
  @$pb.TagNumber(8)
  set total($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasTotal() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotal() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get band => $_getSZ(8);
  @$pb.TagNumber(9)
  set band($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBand() => $_has(8);
  @$pb.TagNumber(9)
  void clearBand() => $_clearField(9);

  /// The band's flag captured at the time: a retune must not rewrite what the
  /// nurse was told.
  @$pb.TagNumber(10)
  $core.bool get escalate => $_getBF(9);
  @$pb.TagNumber(10)
  set escalate($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEscalate() => $_has(9);
  @$pb.TagNumber(10)
  void clearEscalate() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get assessedAt => $_getN(10);
  @$pb.TagNumber(11)
  set assessedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasAssessedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearAssessedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureAssessedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $0.Timestamp get recordedAt => $_getN(11);
  @$pb.TagNumber(12)
  set recordedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasRecordedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearRecordedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureRecordedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get assessedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set assessedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAssessedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearAssessedBy() => $_clearField(13);

  /// When the score stops being current.
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

  /// A recalculation never overwrites.
  @$pb.TagNumber(15)
  $core.String get supersededById => $_getSZ(14);
  @$pb.TagNumber(15)
  set supersededById($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSupersededById() => $_has(14);
  @$pb.TagNumber(15)
  void clearSupersededById() => $_clearField(15);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

class ScoreRiskRequest extends $pb.GeneratedMessage {
  factory ScoreRiskRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? scaleId,
    $core.String? scaleVersion,
    $core.Iterable<$core.MapEntry<$core.String, $core.int>>? inputs,
    $0.Timestamp? assessedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (scaleId != null) result.scaleId = scaleId;
    if (scaleVersion != null) result.scaleVersion = scaleVersion;
    if (inputs != null) result.inputs.addEntries(inputs);
    if (assessedAt != null) result.assessedAt = assessedAt;
    return result;
  }

  ScoreRiskRequest._();

  factory ScoreRiskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScoreRiskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScoreRiskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'scaleId')
    ..aOS(4, _omitFieldNames ? '' : 'scaleVersion')
    ..m<$core.String, $core.int>(5, _omitFieldNames ? '' : 'inputs',
        entryClassName: 'ScoreRiskRequest.InputsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O3,
        packageName: const $pb.PackageName('healthcare.nursing.v1'))
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreRiskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreRiskRequest copyWith(void Function(ScoreRiskRequest) updates) =>
      super.copyWith((message) => updates(message as ScoreRiskRequest))
          as ScoreRiskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScoreRiskRequest create() => ScoreRiskRequest._();
  @$core.override
  ScoreRiskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScoreRiskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScoreRiskRequest>(create);
  static ScoreRiskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get scaleId => $_getSZ(2);
  @$pb.TagNumber(3)
  set scaleId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScaleId() => $_has(2);
  @$pb.TagNumber(3)
  void clearScaleId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get scaleVersion => $_getSZ(3);
  @$pb.TagNumber(4)
  set scaleVersion($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasScaleVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleVersion() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.int> get inputs => $_getMap(4);

  @$pb.TagNumber(6)
  $0.Timestamp get assessedAt => $_getN(5);
  @$pb.TagNumber(6)
  set assessedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAssessedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearAssessedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureAssessedAt() => $_ensure(5);
}

class ScoreRiskResponse extends $pb.GeneratedMessage {
  factory ScoreRiskResponse({
    RiskAssessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  ScoreRiskResponse._();

  factory ScoreRiskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScoreRiskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScoreRiskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<RiskAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: RiskAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreRiskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScoreRiskResponse copyWith(void Function(ScoreRiskResponse) updates) =>
      super.copyWith((message) => updates(message as ScoreRiskResponse))
          as ScoreRiskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScoreRiskResponse create() => ScoreRiskResponse._();
  @$core.override
  ScoreRiskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScoreRiskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScoreRiskResponse>(create);
  static ScoreRiskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  RiskAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(RiskAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  RiskAssessment ensureAssessment() => $_ensure(0);
}

class ListRiskAssessmentsRequest extends $pb.GeneratedMessage {
  factory ListRiskAssessmentsRequest({
    $core.String? patientId,
    RiskDomain? domain,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (domain != null) result.domain = domain;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListRiskAssessmentsRequest._();

  factory ListRiskAssessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRiskAssessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRiskAssessmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aE<RiskDomain>(2, _omitFieldNames ? '' : 'domain',
        enumValues: RiskDomain.values)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRiskAssessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRiskAssessmentsRequest copyWith(
          void Function(ListRiskAssessmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListRiskAssessmentsRequest))
          as ListRiskAssessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRiskAssessmentsRequest create() => ListRiskAssessmentsRequest._();
  @$core.override
  ListRiskAssessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRiskAssessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRiskAssessmentsRequest>(create);
  static ListRiskAssessmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  RiskDomain get domain => $_getN(1);
  @$pb.TagNumber(2)
  set domain(RiskDomain value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDomain() => $_has(1);
  @$pb.TagNumber(2)
  void clearDomain() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListRiskAssessmentsResponse extends $pb.GeneratedMessage {
  factory ListRiskAssessmentsResponse({
    $core.Iterable<RiskAssessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListRiskAssessmentsResponse._();

  factory ListRiskAssessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRiskAssessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRiskAssessmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<RiskAssessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: RiskAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRiskAssessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRiskAssessmentsResponse copyWith(
          void Function(ListRiskAssessmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListRiskAssessmentsResponse))
          as ListRiskAssessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRiskAssessmentsResponse create() =>
      ListRiskAssessmentsResponse._();
  @$core.override
  ListRiskAssessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRiskAssessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRiskAssessmentsResponse>(create);
  static ListRiskAssessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RiskAssessment> get assessments => $_getList(0);
}

class ListDueReassessmentsRequest extends $pb.GeneratedMessage {
  factory ListDueReassessmentsRequest({
    $core.String? encounterId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDueReassessmentsRequest._();

  factory ListDueReassessmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueReassessmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueReassessmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueReassessmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueReassessmentsRequest copyWith(
          void Function(ListDueReassessmentsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueReassessmentsRequest))
          as ListDueReassessmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueReassessmentsRequest create() =>
      ListDueReassessmentsRequest._();
  @$core.override
  ListDueReassessmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueReassessmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueReassessmentsRequest>(create);
  static ListDueReassessmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class ListDueReassessmentsResponse extends $pb.GeneratedMessage {
  factory ListDueReassessmentsResponse({
    $core.Iterable<RiskAssessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  ListDueReassessmentsResponse._();

  factory ListDueReassessmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDueReassessmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDueReassessmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<RiskAssessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: RiskAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueReassessmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDueReassessmentsResponse copyWith(
          void Function(ListDueReassessmentsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListDueReassessmentsResponse))
          as ListDueReassessmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDueReassessmentsResponse create() =>
      ListDueReassessmentsResponse._();
  @$core.override
  ListDueReassessmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDueReassessmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDueReassessmentsResponse>(create);
  static ListDueReassessmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RiskAssessment> get assessments => $_getList(0);
}

/// One episode of looking after a device. Never a proxy for the device being in
/// place.
class DeviceCare extends $pb.GeneratedMessage {
  factory DeviceCare({
    $core.String? careId,
    $core.String? kind,
    $core.String? finding,
    $core.double? outputMl,
    $0.Timestamp? performedAt,
    $core.String? performedBy,
  }) {
    final result = create();
    if (careId != null) result.careId = careId;
    if (kind != null) result.kind = kind;
    if (finding != null) result.finding = finding;
    if (outputMl != null) result.outputMl = outputMl;
    if (performedAt != null) result.performedAt = performedAt;
    if (performedBy != null) result.performedBy = performedBy;
    return result;
  }

  DeviceCare._();

  factory DeviceCare.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeviceCare.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeviceCare',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'careId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'finding')
    ..aD(4, _omitFieldNames ? '' : 'outputMl')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'performedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceCare clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeviceCare copyWith(void Function(DeviceCare) updates) =>
      super.copyWith((message) => updates(message as DeviceCare)) as DeviceCare;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceCare create() => DeviceCare._();
  @$core.override
  DeviceCare createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeviceCare getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceCare>(create);
  static DeviceCare? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get careId => $_getSZ(0);
  @$pb.TagNumber(1)
  set careId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCareId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCareId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get finding => $_getSZ(2);
  @$pb.TagNumber(3)
  set finding($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFinding() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinding() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get outputMl => $_getN(3);
  @$pb.TagNumber(4)
  set outputMl($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputMl() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputMl() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get performedAt => $_getN(4);
  @$pb.TagNumber(5)
  set performedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPerformedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPerformedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensurePerformedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get performedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set performedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPerformedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearPerformedBy() => $_clearField(6);
}

/// One line, tube, drain or catheter (SRS-NUR-006).
class Device extends $pb.GeneratedMessage {
  factory Device({
    $core.String? deviceId,
    $core.String? patientId,
    $core.String? encounterId,
    DeviceKind? kind,
    $core.String? site,
    Laterality? laterality,
    $core.String? size,
    $core.String? lot,
    $0.Timestamp? insertedAt,
    $core.String? insertedBy,
    $0.Timestamp? removedAt,
    $core.String? removedBy,
    $core.String? removalReason,
    $core.Iterable<DeviceCare>? care,
    $core.int? deviceDays,
    $fixnum.Int64? dwellSeconds,
    $core.bool? surveillanceDevice,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (site != null) result.site = site;
    if (laterality != null) result.laterality = laterality;
    if (size != null) result.size = size;
    if (lot != null) result.lot = lot;
    if (insertedAt != null) result.insertedAt = insertedAt;
    if (insertedBy != null) result.insertedBy = insertedBy;
    if (removedAt != null) result.removedAt = removedAt;
    if (removedBy != null) result.removedBy = removedBy;
    if (removalReason != null) result.removalReason = removalReason;
    if (care != null) result.care.addAll(care);
    if (deviceDays != null) result.deviceDays = deviceDays;
    if (dwellSeconds != null) result.dwellSeconds = dwellSeconds;
    if (surveillanceDevice != null)
      result.surveillanceDevice = surveillanceDevice;
    if (version != null) result.version = version;
    return result;
  }

  Device._();

  factory Device.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Device.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Device',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<DeviceKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: DeviceKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'site')
    ..aE<Laterality>(6, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(7, _omitFieldNames ? '' : 'size')
    ..aOS(8, _omitFieldNames ? '' : 'lot')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'insertedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'insertedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'removedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'removedBy')
    ..aOS(13, _omitFieldNames ? '' : 'removalReason')
    ..pPM<DeviceCare>(14, _omitFieldNames ? '' : 'care',
        subBuilder: DeviceCare.create)
    ..aI(15, _omitFieldNames ? '' : 'deviceDays')
    ..aInt64(16, _omitFieldNames ? '' : 'dwellSeconds')
    ..aOB(17, _omitFieldNames ? '' : 'surveillanceDevice')
    ..aInt64(18, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Device copyWith(void Function(Device) updates) =>
      super.copyWith((message) => updates(message as Device)) as Device;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Device create() => Device._();
  @$core.override
  Device createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Device getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Device>(create);
  static Device? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

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
  DeviceKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(DeviceKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get site => $_getSZ(4);
  @$pb.TagNumber(5)
  set site($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSite() => $_has(4);
  @$pb.TagNumber(5)
  void clearSite() => $_clearField(5);

  @$pb.TagNumber(6)
  Laterality get laterality => $_getN(5);
  @$pb.TagNumber(6)
  set laterality(Laterality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLaterality() => $_has(5);
  @$pb.TagNumber(6)
  void clearLaterality() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get size => $_getSZ(6);
  @$pb.TagNumber(7)
  set size($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSize() => $_has(6);
  @$pb.TagNumber(7)
  void clearSize() => $_clearField(7);

  /// Identifies the product, so a recall can find the patients.
  @$pb.TagNumber(8)
  $core.String get lot => $_getSZ(7);
  @$pb.TagNumber(8)
  set lot($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLot() => $_has(7);
  @$pb.TagNumber(8)
  void clearLot() => $_clearField(8);

  /// The canonical dates. Device-days are computed from these and nothing else.
  @$pb.TagNumber(9)
  $0.Timestamp get insertedAt => $_getN(8);
  @$pb.TagNumber(9)
  set insertedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasInsertedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearInsertedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureInsertedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get insertedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set insertedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasInsertedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearInsertedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get removedAt => $_getN(10);
  @$pb.TagNumber(11)
  set removedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasRemovedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearRemovedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureRemovedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $core.String get removedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set removedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasRemovedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearRemovedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get removalReason => $_getSZ(12);
  @$pb.TagNumber(13)
  set removalReason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasRemovalReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearRemovalReason() => $_clearField(13);

  @$pb.TagNumber(14)
  $pb.PbList<DeviceCare> get care => $_getList(13);

  /// Server-computed. The denominator of a published infection rate, counted
  /// once per calendar day the device was in place, insertion and removal days
  /// included.
  @$pb.TagNumber(15)
  $core.int get deviceDays => $_getIZ(14);
  @$pb.TagNumber(15)
  set deviceDays($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasDeviceDays() => $_has(14);
  @$pb.TagNumber(15)
  void clearDeviceDays() => $_clearField(15);

  /// Dwell to the minute, because a 72-hour cannula limit rounded to days lets a
  /// line sit two days past it.
  @$pb.TagNumber(16)
  $fixnum.Int64 get dwellSeconds => $_getI64(15);
  @$pb.TagNumber(16)
  set dwellSeconds($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasDwellSeconds() => $_has(15);
  @$pb.TagNumber(16)
  void clearDwellSeconds() => $_clearField(16);

  /// Whether this kind counts towards a published infection rate.
  @$pb.TagNumber(17)
  $core.bool get surveillanceDevice => $_getBF(16);
  @$pb.TagNumber(17)
  set surveillanceDevice($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasSurveillanceDevice() => $_has(16);
  @$pb.TagNumber(17)
  void clearSurveillanceDevice() => $_clearField(17);

  @$pb.TagNumber(18)
  $fixnum.Int64 get version => $_getI64(17);
  @$pb.TagNumber(18)
  set version($fixnum.Int64 value) => $_setInt64(17, value);
  @$pb.TagNumber(18)
  $core.bool hasVersion() => $_has(17);
  @$pb.TagNumber(18)
  void clearVersion() => $_clearField(18);
}

class InsertDeviceRequest extends $pb.GeneratedMessage {
  factory InsertDeviceRequest({
    $core.String? patientId,
    $core.String? encounterId,
    DeviceKind? kind,
    $core.String? site,
    Laterality? laterality,
    $core.String? size,
    $core.String? lot,
    $0.Timestamp? insertedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (site != null) result.site = site;
    if (laterality != null) result.laterality = laterality;
    if (size != null) result.size = size;
    if (lot != null) result.lot = lot;
    if (insertedAt != null) result.insertedAt = insertedAt;
    return result;
  }

  InsertDeviceRequest._();

  factory InsertDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InsertDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InsertDeviceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<DeviceKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: DeviceKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'site')
    ..aE<Laterality>(5, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aOS(6, _omitFieldNames ? '' : 'size')
    ..aOS(7, _omitFieldNames ? '' : 'lot')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'insertedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InsertDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InsertDeviceRequest copyWith(void Function(InsertDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as InsertDeviceRequest))
          as InsertDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InsertDeviceRequest create() => InsertDeviceRequest._();
  @$core.override
  InsertDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InsertDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertDeviceRequest>(create);
  static InsertDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  DeviceKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(DeviceKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get site => $_getSZ(3);
  @$pb.TagNumber(4)
  set site($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSite() => $_has(3);
  @$pb.TagNumber(4)
  void clearSite() => $_clearField(4);

  @$pb.TagNumber(5)
  Laterality get laterality => $_getN(4);
  @$pb.TagNumber(5)
  set laterality(Laterality value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLaterality() => $_has(4);
  @$pb.TagNumber(5)
  void clearLaterality() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get size => $_getSZ(5);
  @$pb.TagNumber(6)
  set size($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get lot => $_getSZ(6);
  @$pb.TagNumber(7)
  set lot($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLot() => $_has(6);
  @$pb.TagNumber(7)
  void clearLot() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get insertedAt => $_getN(7);
  @$pb.TagNumber(8)
  set insertedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasInsertedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearInsertedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureInsertedAt() => $_ensure(7);
}

class InsertDeviceResponse extends $pb.GeneratedMessage {
  factory InsertDeviceResponse({
    Device? device,
  }) {
    final result = create();
    if (device != null) result.device = device;
    return result;
  }

  InsertDeviceResponse._();

  factory InsertDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InsertDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InsertDeviceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'device', subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InsertDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InsertDeviceResponse copyWith(void Function(InsertDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as InsertDeviceResponse))
          as InsertDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InsertDeviceResponse create() => InsertDeviceResponse._();
  @$core.override
  InsertDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InsertDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InsertDeviceResponse>(create);
  static InsertDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensureDevice() => $_ensure(0);
}

class RemoveDeviceRequest extends $pb.GeneratedMessage {
  factory RemoveDeviceRequest({
    $core.String? deviceId,
    $0.Timestamp? removedAt,
    $core.String? reason,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (removedAt != null) result.removedAt = removedAt;
    if (reason != null) result.reason = reason;
    return result;
  }

  RemoveDeviceRequest._();

  factory RemoveDeviceRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveDeviceRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveDeviceRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'removedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveDeviceRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveDeviceRequest copyWith(void Function(RemoveDeviceRequest) updates) =>
      super.copyWith((message) => updates(message as RemoveDeviceRequest))
          as RemoveDeviceRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveDeviceRequest create() => RemoveDeviceRequest._();
  @$core.override
  RemoveDeviceRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveDeviceRequest>(create);
  static RemoveDeviceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get removedAt => $_getN(1);
  @$pb.TagNumber(2)
  set removedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRemovedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemovedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureRemovedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RemoveDeviceResponse extends $pb.GeneratedMessage {
  factory RemoveDeviceResponse({
    Device? device,
  }) {
    final result = create();
    if (device != null) result.device = device;
    return result;
  }

  RemoveDeviceResponse._();

  factory RemoveDeviceResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemoveDeviceResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemoveDeviceResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Device>(1, _omitFieldNames ? '' : 'device', subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveDeviceResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemoveDeviceResponse copyWith(void Function(RemoveDeviceResponse) updates) =>
      super.copyWith((message) => updates(message as RemoveDeviceResponse))
          as RemoveDeviceResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveDeviceResponse create() => RemoveDeviceResponse._();
  @$core.override
  RemoveDeviceResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemoveDeviceResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemoveDeviceResponse>(create);
  static RemoveDeviceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Device get device => $_getN(0);
  @$pb.TagNumber(1)
  set device(Device value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  Device ensureDevice() => $_ensure(0);
}

class RecordDeviceCareRequest extends $pb.GeneratedMessage {
  factory RecordDeviceCareRequest({
    $core.String? deviceId,
    $core.String? kind,
    $core.String? finding,
    $core.double? outputMl,
    $0.Timestamp? performedAt,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (kind != null) result.kind = kind;
    if (finding != null) result.finding = finding;
    if (outputMl != null) result.outputMl = outputMl;
    if (performedAt != null) result.performedAt = performedAt;
    return result;
  }

  RecordDeviceCareRequest._();

  factory RecordDeviceCareRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeviceCareRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeviceCareRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'kind')
    ..aOS(3, _omitFieldNames ? '' : 'finding')
    ..aD(4, _omitFieldNames ? '' : 'outputMl')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'performedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceCareRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceCareRequest copyWith(
          void Function(RecordDeviceCareRequest) updates) =>
      super.copyWith((message) => updates(message as RecordDeviceCareRequest))
          as RecordDeviceCareRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeviceCareRequest create() => RecordDeviceCareRequest._();
  @$core.override
  RecordDeviceCareRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeviceCareRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeviceCareRequest>(create);
  static RecordDeviceCareRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get kind => $_getSZ(1);
  @$pb.TagNumber(2)
  set kind($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get finding => $_getSZ(2);
  @$pb.TagNumber(3)
  set finding($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFinding() => $_has(2);
  @$pb.TagNumber(3)
  void clearFinding() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get outputMl => $_getN(3);
  @$pb.TagNumber(4)
  set outputMl($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutputMl() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutputMl() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get performedAt => $_getN(4);
  @$pb.TagNumber(5)
  set performedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPerformedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearPerformedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensurePerformedAt() => $_ensure(4);
}

class RecordDeviceCareResponse extends $pb.GeneratedMessage {
  factory RecordDeviceCareResponse() => create();

  RecordDeviceCareResponse._();

  factory RecordDeviceCareResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordDeviceCareResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordDeviceCareResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceCareResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordDeviceCareResponse copyWith(
          void Function(RecordDeviceCareResponse) updates) =>
      super.copyWith((message) => updates(message as RecordDeviceCareResponse))
          as RecordDeviceCareResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordDeviceCareResponse create() => RecordDeviceCareResponse._();
  @$core.override
  RecordDeviceCareResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordDeviceCareResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordDeviceCareResponse>(create);
  static RecordDeviceCareResponse? _defaultInstance;
}

class ListDevicesRequest extends $pb.GeneratedMessage {
  factory ListDevicesRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.bool? inPlaceOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (inPlaceOnly != null) result.inPlaceOnly = inPlaceOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDevicesRequest._();

  factory ListDevicesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDevicesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOB(3, _omitFieldNames ? '' : 'inPlaceOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesRequest copyWith(void Function(ListDevicesRequest) updates) =>
      super.copyWith((message) => updates(message as ListDevicesRequest))
          as ListDevicesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDevicesRequest create() => ListDevicesRequest._();
  @$core.override
  ListDevicesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDevicesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesRequest>(create);
  static ListDevicesRequest? _defaultInstance;

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
  $core.bool get inPlaceOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set inPlaceOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasInPlaceOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearInPlaceOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListDevicesResponse extends $pb.GeneratedMessage {
  factory ListDevicesResponse({
    $core.Iterable<Device>? devices,
  }) {
    final result = create();
    if (devices != null) result.devices.addAll(devices);
    return result;
  }

  ListDevicesResponse._();

  factory ListDevicesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDevicesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDevicesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Device>(1, _omitFieldNames ? '' : 'devices',
        subBuilder: Device.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDevicesResponse copyWith(void Function(ListDevicesResponse) updates) =>
      super.copyWith((message) => updates(message as ListDevicesResponse))
          as ListDevicesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse create() => ListDevicesResponse._();
  @$core.override
  ListDevicesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDevicesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDevicesResponse>(create);
  static ListDevicesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Device> get devices => $_getList(0);
}

/// What the nursing context needs to know about an order.
///
/// A projection of the medication context, not a copy: nursing needs what to
/// give, when, and whether a pharmacist has verified it.
class MedicationOrder extends $pb.GeneratedMessage {
  factory MedicationOrder({
    $core.String? orderId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? medication,
    Quantity? dose,
    $core.String? route,
    $core.String? frequency,
    OrderStatus? status,
    $core.bool? verified,
    $core.String? verifiedBy,
    $0.Timestamp? verifiedAt,
    $core.bool? prn,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (medication != null) result.medication = medication;
    if (dose != null) result.dose = dose;
    if (route != null) result.route = route;
    if (frequency != null) result.frequency = frequency;
    if (status != null) result.status = status;
    if (verified != null) result.verified = verified;
    if (verifiedBy != null) result.verifiedBy = verifiedBy;
    if (verifiedAt != null) result.verifiedAt = verifiedAt;
    if (prn != null) result.prn = prn;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
    return result;
  }

  MedicationOrder._();

  factory MedicationOrder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MedicationOrder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MedicationOrder',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..aOM<Quantity>(5, _omitFieldNames ? '' : 'dose',
        subBuilder: Quantity.create)
    ..aOS(6, _omitFieldNames ? '' : 'route')
    ..aOS(7, _omitFieldNames ? '' : 'frequency')
    ..aE<OrderStatus>(8, _omitFieldNames ? '' : 'status',
        enumValues: OrderStatus.values)
    ..aOB(9, _omitFieldNames ? '' : 'verified')
    ..aOS(10, _omitFieldNames ? '' : 'verifiedBy')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'verifiedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(12, _omitFieldNames ? '' : 'prn')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'endsAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedicationOrder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MedicationOrder copyWith(void Function(MedicationOrder) updates) =>
      super.copyWith((message) => updates(message as MedicationOrder))
          as MedicationOrder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MedicationOrder create() => MedicationOrder._();
  @$core.override
  MedicationOrder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MedicationOrder getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<MedicationOrder>(create);
  static MedicationOrder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

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
  Coding get medication => $_getN(3);
  @$pb.TagNumber(4)
  set medication(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasMedication() => $_has(3);
  @$pb.TagNumber(4)
  void clearMedication() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureMedication() => $_ensure(3);

  @$pb.TagNumber(5)
  Quantity get dose => $_getN(4);
  @$pb.TagNumber(5)
  set dose(Quantity value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDose() => $_has(4);
  @$pb.TagNumber(5)
  void clearDose() => $_clearField(5);
  @$pb.TagNumber(5)
  Quantity ensureDose() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get route => $_getSZ(5);
  @$pb.TagNumber(6)
  set route($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoute() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoute() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get frequency => $_getSZ(6);
  @$pb.TagNumber(7)
  set frequency($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasFrequency() => $_has(6);
  @$pb.TagNumber(7)
  void clearFrequency() => $_clearField(7);

  @$pb.TagNumber(8)
  OrderStatus get status => $_getN(7);
  @$pb.TagNumber(8)
  set status(OrderStatus value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStatus() => $_has(7);
  @$pb.TagNumber(8)
  void clearStatus() => $_clearField(8);

  /// The pharmacist's check. A separate field rather than a status value,
  /// because an order can be active and unverified and that distinction is what
  /// SRS-NUR-007 is about.
  @$pb.TagNumber(9)
  $core.bool get verified => $_getBF(8);
  @$pb.TagNumber(9)
  set verified($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasVerified() => $_has(8);
  @$pb.TagNumber(9)
  void clearVerified() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get verifiedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set verifiedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVerifiedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearVerifiedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get verifiedAt => $_getN(10);
  @$pb.TagNumber(11)
  set verifiedAt($0.Timestamp value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasVerifiedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearVerifiedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureVerifiedAt() => $_ensure(10);

  /// As-needed: no schedule, which is why duplicate protection needs a second
  /// mechanism.
  @$pb.TagNumber(12)
  $core.bool get prn => $_getBF(11);
  @$pb.TagNumber(12)
  set prn($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasPrn() => $_has(11);
  @$pb.TagNumber(12)
  void clearPrn() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get startsAt => $_getN(12);
  @$pb.TagNumber(13)
  set startsAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStartsAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartsAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureStartsAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get endsAt => $_getN(13);
  @$pb.TagNumber(14)
  set endsAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEndsAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndsAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEndsAt() => $_ensure(13);
}

/// The barcode check (SRS-NUR-008).
class Verification extends $pb.GeneratedMessage {
  factory Verification({
    $core.String? patientScanned,
    $core.String? medicationScanned,
    $core.bool? performed,
    $0.Timestamp? scannedAt,
  }) {
    final result = create();
    if (patientScanned != null) result.patientScanned = patientScanned;
    if (medicationScanned != null) result.medicationScanned = medicationScanned;
    if (performed != null) result.performed = performed;
    if (scannedAt != null) result.scannedAt = scannedAt;
    return result;
  }

  Verification._();

  factory Verification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Verification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Verification',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientScanned')
    ..aOS(2, _omitFieldNames ? '' : 'medicationScanned')
    ..aOB(3, _omitFieldNames ? '' : 'performed')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'scannedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Verification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Verification copyWith(void Function(Verification) updates) =>
      super.copyWith((message) => updates(message as Verification))
          as Verification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Verification create() => Verification._();
  @$core.override
  Verification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Verification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Verification>(create);
  static Verification? _defaultInstance;

  /// Read from the wristband, compared against the order's patient rather than
  /// against what the screen is showing — the screen is what the check exists to
  /// doubt.
  @$pb.TagNumber(1)
  $core.String get patientScanned => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientScanned($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientScanned() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientScanned() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get medicationScanned => $_getSZ(1);
  @$pb.TagNumber(2)
  set medicationScanned($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMedicationScanned() => $_has(1);
  @$pb.TagNumber(2)
  void clearMedicationScanned() => $_clearField(2);

  /// Distinguishes "the workflow ran and matched" from "the workflow did not
  /// run", which a pair of empty strings cannot.
  @$pb.TagNumber(3)
  $core.bool get performed => $_getBF(2);
  @$pb.TagNumber(3)
  set performed($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPerformed() => $_has(2);
  @$pb.TagNumber(3)
  void clearPerformed() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get scannedAt => $_getN(3);
  @$pb.TagNumber(4)
  set scannedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasScannedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearScannedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureScannedAt() => $_ensure(3);
}

/// An administration completed despite a failed or absent check (SRS-NUR-008).
///
/// Stored as well as audited: the audit trail answers "who did this", and this
/// answers "how often, on which ward, for which drugs".
class Override extends $pb.GeneratedMessage {
  factory Override({
    $core.String? reason,
    $core.String? by,
    $0.Timestamp? at,
    $core.bool? patientMismatch,
    $core.bool? medicationMismatch,
    $core.bool? notScanned,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    if (by != null) result.by = by;
    if (at != null) result.at = at;
    if (patientMismatch != null) result.patientMismatch = patientMismatch;
    if (medicationMismatch != null)
      result.medicationMismatch = medicationMismatch;
    if (notScanned != null) result.notScanned = notScanned;
    return result;
  }

  Override._();

  factory Override.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Override.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Override',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..aOS(2, _omitFieldNames ? '' : 'by')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'at',
        subBuilder: $0.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'patientMismatch')
    ..aOB(5, _omitFieldNames ? '' : 'medicationMismatch')
    ..aOB(6, _omitFieldNames ? '' : 'notScanned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Override clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Override copyWith(void Function(Override) updates) =>
      super.copyWith((message) => updates(message as Override)) as Override;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Override create() => Override._();
  @$core.override
  Override createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Override getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Override>(create);
  static Override? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get by => $_getSZ(1);
  @$pb.TagNumber(2)
  set by($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get at => $_getN(2);
  @$pb.TagNumber(3)
  set at($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureAt() => $_ensure(2);

  /// What did not match, captured at the time. The wristband gets reprinted; the
  /// report must still show what the nurse was looking at.
  @$pb.TagNumber(4)
  $core.bool get patientMismatch => $_getBF(3);
  @$pb.TagNumber(4)
  set patientMismatch($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientMismatch() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientMismatch() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get medicationMismatch => $_getBF(4);
  @$pb.TagNumber(5)
  set medicationMismatch($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMedicationMismatch() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedicationMismatch() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get notScanned => $_getBF(5);
  @$pb.TagNumber(6)
  set notScanned($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasNotScanned() => $_has(5);
  @$pb.TagNumber(6)
  void clearNotScanned() => $_clearField(6);
}

/// One dose's record (SRS-NUR-009).
class Administration extends $pb.GeneratedMessage {
  factory Administration({
    $core.String? administrationId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? orderId,
    Coding? medication,
    Quantity? scheduledDose,
    $0.Timestamp? scheduledAt,
    Quantity? givenDose,
    $0.Timestamp? givenAt,
    $core.String? route,
    $core.String? site,
    AdministrationOutcome? outcome,
    $core.String? reason,
    Verification? verification,
    Override? override,
    $core.String? idempotencyKey,
    $core.bool? recordedOffline,
    $core.String? administeredBy,
    $core.String? witnessedBy,
    $0.Timestamp? recordedAt,
    $core.bool? late,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (administrationId != null) result.administrationId = administrationId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (orderId != null) result.orderId = orderId;
    if (medication != null) result.medication = medication;
    if (scheduledDose != null) result.scheduledDose = scheduledDose;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (givenDose != null) result.givenDose = givenDose;
    if (givenAt != null) result.givenAt = givenAt;
    if (route != null) result.route = route;
    if (site != null) result.site = site;
    if (outcome != null) result.outcome = outcome;
    if (reason != null) result.reason = reason;
    if (verification != null) result.verification = verification;
    if (override != null) result.override = override;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (recordedOffline != null) result.recordedOffline = recordedOffline;
    if (administeredBy != null) result.administeredBy = administeredBy;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (late != null) result.late = late;
    if (version != null) result.version = version;
    return result;
  }

  Administration._();

  factory Administration.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Administration.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Administration',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'administrationId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'orderId')
    ..aOM<Coding>(5, _omitFieldNames ? '' : 'medication',
        subBuilder: Coding.create)
    ..aOM<Quantity>(6, _omitFieldNames ? '' : 'scheduledDose',
        subBuilder: Quantity.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<Quantity>(8, _omitFieldNames ? '' : 'givenDose',
        subBuilder: Quantity.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'route')
    ..aOS(11, _omitFieldNames ? '' : 'site')
    ..aE<AdministrationOutcome>(12, _omitFieldNames ? '' : 'outcome',
        enumValues: AdministrationOutcome.values)
    ..aOS(13, _omitFieldNames ? '' : 'reason')
    ..aOM<Verification>(14, _omitFieldNames ? '' : 'verification',
        subBuilder: Verification.create)
    ..aOM<Override>(15, _omitFieldNames ? '' : 'override',
        subBuilder: Override.create)
    ..aOS(16, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOB(17, _omitFieldNames ? '' : 'recordedOffline')
    ..aOS(18, _omitFieldNames ? '' : 'administeredBy')
    ..aOS(19, _omitFieldNames ? '' : 'witnessedBy')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(21, _omitFieldNames ? '' : 'late')
    ..aInt64(22, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Administration clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Administration copyWith(void Function(Administration) updates) =>
      super.copyWith((message) => updates(message as Administration))
          as Administration;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Administration create() => Administration._();
  @$core.override
  Administration createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Administration getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Administration>(create);
  static Administration? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get administrationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set administrationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAdministrationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdministrationId() => $_clearField(1);

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
  $core.String get orderId => $_getSZ(3);
  @$pb.TagNumber(4)
  set orderId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOrderId() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderId() => $_clearField(4);

  @$pb.TagNumber(5)
  Coding get medication => $_getN(4);
  @$pb.TagNumber(5)
  set medication(Coding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasMedication() => $_has(4);
  @$pb.TagNumber(5)
  void clearMedication() => $_clearField(5);
  @$pb.TagNumber(5)
  Coding ensureMedication() => $_ensure(4);

  /// What the order asked for.
  @$pb.TagNumber(6)
  Quantity get scheduledDose => $_getN(5);
  @$pb.TagNumber(6)
  set scheduledDose(Quantity value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasScheduledDose() => $_has(5);
  @$pb.TagNumber(6)
  void clearScheduledDose() => $_clearField(6);
  @$pb.TagNumber(6)
  Quantity ensureScheduledDose() => $_ensure(5);

  @$pb.TagNumber(7)
  $0.Timestamp get scheduledAt => $_getN(6);
  @$pb.TagNumber(7)
  set scheduledAt($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasScheduledAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearScheduledAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureScheduledAt() => $_ensure(6);

  /// What actually happened. Both kept, which is the whole of SRS-NUR-009.
  @$pb.TagNumber(8)
  Quantity get givenDose => $_getN(7);
  @$pb.TagNumber(8)
  set givenDose(Quantity value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasGivenDose() => $_has(7);
  @$pb.TagNumber(8)
  void clearGivenDose() => $_clearField(8);
  @$pb.TagNumber(8)
  Quantity ensureGivenDose() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get givenAt => $_getN(8);
  @$pb.TagNumber(9)
  set givenAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasGivenAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearGivenAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureGivenAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get route => $_getSZ(9);
  @$pb.TagNumber(10)
  set route($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRoute() => $_has(9);
  @$pb.TagNumber(10)
  void clearRoute() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get site => $_getSZ(10);
  @$pb.TagNumber(11)
  set site($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSite() => $_has(10);
  @$pb.TagNumber(11)
  void clearSite() => $_clearField(11);

  @$pb.TagNumber(12)
  AdministrationOutcome get outcome => $_getN(11);
  @$pb.TagNumber(12)
  set outcome(AdministrationOutcome value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasOutcome() => $_has(11);
  @$pb.TagNumber(12)
  void clearOutcome() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get reason => $_getSZ(12);
  @$pb.TagNumber(13)
  set reason($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasReason() => $_has(12);
  @$pb.TagNumber(13)
  void clearReason() => $_clearField(13);

  @$pb.TagNumber(14)
  Verification get verification => $_getN(13);
  @$pb.TagNumber(14)
  set verification(Verification value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasVerification() => $_has(13);
  @$pb.TagNumber(14)
  void clearVerification() => $_clearField(14);
  @$pb.TagNumber(14)
  Verification ensureVerification() => $_ensure(13);

  @$pb.TagNumber(15)
  Override get override => $_getN(14);
  @$pb.TagNumber(15)
  set override(Override value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasOverride() => $_has(14);
  @$pb.TagNumber(15)
  void clearOverride() => $_clearField(15);
  @$pb.TagNumber(15)
  Override ensureOverride() => $_ensure(14);

  /// Deduplicates a replayed PRN submission during downtime reconciliation,
  /// where there is no scheduled time to key on (SRS-NUR-018).
  @$pb.TagNumber(16)
  $core.String get idempotencyKey => $_getSZ(15);
  @$pb.TagNumber(16)
  set idempotencyKey($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasIdempotencyKey() => $_has(15);
  @$pb.TagNumber(16)
  void clearIdempotencyKey() => $_clearField(16);

  /// A record reconstructed from paper hours later is weaker evidence than one
  /// charted at the bedside, and a reviewer should see which they are reading.
  @$pb.TagNumber(17)
  $core.bool get recordedOffline => $_getBF(16);
  @$pb.TagNumber(17)
  set recordedOffline($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasRecordedOffline() => $_has(16);
  @$pb.TagNumber(17)
  void clearRecordedOffline() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get administeredBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set administeredBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasAdministeredBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearAdministeredBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get witnessedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set witnessedBy($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasWitnessedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearWitnessedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $0.Timestamp get recordedAt => $_getN(19);
  @$pb.TagNumber(20)
  set recordedAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasRecordedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearRecordedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureRecordedAt() => $_ensure(19);

  /// Server-computed from the scheduled and actual times against the facility's
  /// policy.
  @$pb.TagNumber(21)
  $core.bool get late => $_getBF(20);
  @$pb.TagNumber(21)
  set late($core.bool value) => $_setBool(20, value);
  @$pb.TagNumber(21)
  $core.bool hasLate() => $_has(20);
  @$pb.TagNumber(21)
  void clearLate() => $_clearField(21);

  @$pb.TagNumber(22)
  $fixnum.Int64 get version => $_getI64(21);
  @$pb.TagNumber(22)
  set version($fixnum.Int64 value) => $_setInt64(21, value);
  @$pb.TagNumber(22)
  $core.bool hasVersion() => $_has(21);
  @$pb.TagNumber(22)
  void clearVersion() => $_clearField(22);
}

/// What a facility requires before a dose is completed (SRS-NUR-008).
class AdministrationPolicy extends $pb.GeneratedMessage {
  factory AdministrationPolicy({
    $core.bool? barcodeRequired,
    $core.bool? overrideAllowed,
    $fixnum.Int64? lateAfterSeconds,
  }) {
    final result = create();
    if (barcodeRequired != null) result.barcodeRequired = barcodeRequired;
    if (overrideAllowed != null) result.overrideAllowed = overrideAllowed;
    if (lateAfterSeconds != null) result.lateAfterSeconds = lateAfterSeconds;
    return result;
  }

  AdministrationPolicy._();

  factory AdministrationPolicy.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdministrationPolicy.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdministrationPolicy',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'barcodeRequired')
    ..aOB(2, _omitFieldNames ? '' : 'overrideAllowed')
    ..aInt64(3, _omitFieldNames ? '' : 'lateAfterSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministrationPolicy clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministrationPolicy copyWith(void Function(AdministrationPolicy) updates) =>
      super.copyWith((message) => updates(message as AdministrationPolicy))
          as AdministrationPolicy;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdministrationPolicy create() => AdministrationPolicy._();
  @$core.override
  AdministrationPolicy createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdministrationPolicy getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdministrationPolicy>(create);
  static AdministrationPolicy? _defaultInstance;

  /// On by default: a safety control that has to be switched on is a control
  /// that is off in the wards that most need it.
  @$pb.TagNumber(1)
  $core.bool get barcodeRequired => $_getBF(0);
  @$pb.TagNumber(1)
  set barcodeRequired($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBarcodeRequired() => $_has(0);
  @$pb.TagNumber(1)
  void clearBarcodeRequired() => $_clearField(1);

  /// A facility that turns this off has decided a mismatch is never given
  /// through, which is a defensible position the system must be able to hold.
  @$pb.TagNumber(2)
  $core.bool get overrideAllowed => $_getBF(1);
  @$pb.TagNumber(2)
  set overrideAllowed($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOverrideAllowed() => $_has(1);
  @$pb.TagNumber(2)
  void clearOverrideAllowed() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get lateAfterSeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set lateAfterSeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLateAfterSeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearLateAfterSeconds() => $_clearField(3);
}

/// One entry on the medication round (SRS-NUR-007).
class DueDose extends $pb.GeneratedMessage {
  factory DueDose({
    MedicationOrder? order,
    $0.Timestamp? scheduledAt,
    Administration? given,
    $core.bool? outstanding,
    $core.bool? overdue,
  }) {
    final result = create();
    if (order != null) result.order = order;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (given != null) result.given = given;
    if (outstanding != null) result.outstanding = outstanding;
    if (overdue != null) result.overdue = overdue;
    return result;
  }

  DueDose._();

  factory DueDose.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DueDose.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DueDose',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<MedicationOrder>(1, _omitFieldNames ? '' : 'order',
        subBuilder: MedicationOrder.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<Administration>(3, _omitFieldNames ? '' : 'given',
        subBuilder: Administration.create)
    ..aOB(4, _omitFieldNames ? '' : 'outstanding')
    ..aOB(5, _omitFieldNames ? '' : 'overdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDose clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DueDose copyWith(void Function(DueDose) updates) =>
      super.copyWith((message) => updates(message as DueDose)) as DueDose;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DueDose create() => DueDose._();
  @$core.override
  DueDose createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DueDose getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DueDose>(create);
  static DueDose? _defaultInstance;

  @$pb.TagNumber(1)
  MedicationOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order(MedicationOrder value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => $_clearField(1);
  @$pb.TagNumber(1)
  MedicationOrder ensureOrder() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get scheduledAt => $_getN(1);
  @$pb.TagNumber(2)
  set scheduledAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasScheduledAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearScheduledAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureScheduledAt() => $_ensure(1);

  /// What has already been given. A round that does not show this invites the
  /// dose being given twice.
  @$pb.TagNumber(3)
  Administration get given => $_getN(2);
  @$pb.TagNumber(3)
  set given(Administration value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasGiven() => $_has(2);
  @$pb.TagNumber(3)
  void clearGiven() => $_clearField(3);
  @$pb.TagNumber(3)
  Administration ensureGiven() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get outstanding => $_getBF(3);
  @$pb.TagNumber(4)
  set outstanding($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasOutstanding() => $_has(3);
  @$pb.TagNumber(4)
  void clearOutstanding() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get overdue => $_getBF(4);
  @$pb.TagNumber(5)
  set overdue($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverdue() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdue() => $_clearField(5);
}

class GetMedicationRoundRequest extends $pb.GeneratedMessage {
  factory GetMedicationRoundRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? facilityId,
    $0.Timestamp? from,
    $0.Timestamp? to,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (facilityId != null) result.facilityId = facilityId;
    if (from != null) result.from = from;
    if (to != null) result.to = to;
    return result;
  }

  GetMedicationRoundRequest._();

  factory GetMedicationRoundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMedicationRoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMedicationRoundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationRoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationRoundRequest copyWith(
          void Function(GetMedicationRoundRequest) updates) =>
      super.copyWith((message) => updates(message as GetMedicationRoundRequest))
          as GetMedicationRoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMedicationRoundRequest create() => GetMedicationRoundRequest._();
  @$core.override
  GetMedicationRoundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMedicationRoundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMedicationRoundRequest>(create);
  static GetMedicationRoundRequest? _defaultInstance;

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
  $core.String get facilityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set facilityId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFacilityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFacilityId() => $_clearField(3);

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
}

class GetMedicationRoundResponse extends $pb.GeneratedMessage {
  factory GetMedicationRoundResponse({
    $core.Iterable<DueDose>? doses,
    AdministrationPolicy? policy,
  }) {
    final result = create();
    if (doses != null) result.doses.addAll(doses);
    if (policy != null) result.policy = policy;
    return result;
  }

  GetMedicationRoundResponse._();

  factory GetMedicationRoundResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetMedicationRoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetMedicationRoundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<DueDose>(1, _omitFieldNames ? '' : 'doses',
        subBuilder: DueDose.create)
    ..aOM<AdministrationPolicy>(2, _omitFieldNames ? '' : 'policy',
        subBuilder: AdministrationPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationRoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetMedicationRoundResponse copyWith(
          void Function(GetMedicationRoundResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetMedicationRoundResponse))
          as GetMedicationRoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetMedicationRoundResponse create() => GetMedicationRoundResponse._();
  @$core.override
  GetMedicationRoundResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetMedicationRoundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetMedicationRoundResponse>(create);
  static GetMedicationRoundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DueDose> get doses => $_getList(0);

  @$pb.TagNumber(2)
  AdministrationPolicy get policy => $_getN(1);
  @$pb.TagNumber(2)
  set policy(AdministrationPolicy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicy() => $_clearField(2);
  @$pb.TagNumber(2)
  AdministrationPolicy ensurePolicy() => $_ensure(1);
}

class AdministerRequest extends $pb.GeneratedMessage {
  factory AdministerRequest({
    $core.String? orderId,
    $core.String? facilityId,
    $0.Timestamp? scheduledAt,
    Quantity? givenDose,
    $0.Timestamp? givenAt,
    $core.String? route,
    $core.String? site,
    AdministrationOutcome? outcome,
    $core.String? reason,
    Verification? verification,
    $core.String? overrideReason,
    $core.String? witnessedBy,
    $core.String? idempotencyKey,
    $core.bool? offline,
  }) {
    final result = create();
    if (orderId != null) result.orderId = orderId;
    if (facilityId != null) result.facilityId = facilityId;
    if (scheduledAt != null) result.scheduledAt = scheduledAt;
    if (givenDose != null) result.givenDose = givenDose;
    if (givenAt != null) result.givenAt = givenAt;
    if (route != null) result.route = route;
    if (site != null) result.site = site;
    if (outcome != null) result.outcome = outcome;
    if (reason != null) result.reason = reason;
    if (verification != null) result.verification = verification;
    if (overrideReason != null) result.overrideReason = overrideReason;
    if (witnessedBy != null) result.witnessedBy = witnessedBy;
    if (idempotencyKey != null) result.idempotencyKey = idempotencyKey;
    if (offline != null) result.offline = offline;
    return result;
  }

  AdministerRequest._();

  factory AdministerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdministerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdministerRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'orderId')
    ..aOS(2, _omitFieldNames ? '' : 'facilityId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'scheduledAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<Quantity>(4, _omitFieldNames ? '' : 'givenDose',
        subBuilder: Quantity.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'givenAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'route')
    ..aOS(7, _omitFieldNames ? '' : 'site')
    ..aE<AdministrationOutcome>(8, _omitFieldNames ? '' : 'outcome',
        enumValues: AdministrationOutcome.values)
    ..aOS(9, _omitFieldNames ? '' : 'reason')
    ..aOM<Verification>(10, _omitFieldNames ? '' : 'verification',
        subBuilder: Verification.create)
    ..aOS(11, _omitFieldNames ? '' : 'overrideReason')
    ..aOS(12, _omitFieldNames ? '' : 'witnessedBy')
    ..aOS(13, _omitFieldNames ? '' : 'idempotencyKey')
    ..aOB(14, _omitFieldNames ? '' : 'offline')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministerRequest copyWith(void Function(AdministerRequest) updates) =>
      super.copyWith((message) => updates(message as AdministerRequest))
          as AdministerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdministerRequest create() => AdministerRequest._();
  @$core.override
  AdministerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdministerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdministerRequest>(create);
  static AdministerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOrderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get facilityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set facilityId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFacilityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFacilityId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get scheduledAt => $_getN(2);
  @$pb.TagNumber(3)
  set scheduledAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasScheduledAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearScheduledAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureScheduledAt() => $_ensure(2);

  @$pb.TagNumber(4)
  Quantity get givenDose => $_getN(3);
  @$pb.TagNumber(4)
  set givenDose(Quantity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasGivenDose() => $_has(3);
  @$pb.TagNumber(4)
  void clearGivenDose() => $_clearField(4);
  @$pb.TagNumber(4)
  Quantity ensureGivenDose() => $_ensure(3);

  @$pb.TagNumber(5)
  $0.Timestamp get givenAt => $_getN(4);
  @$pb.TagNumber(5)
  set givenAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasGivenAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearGivenAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureGivenAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get route => $_getSZ(5);
  @$pb.TagNumber(6)
  set route($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRoute() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoute() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get site => $_getSZ(6);
  @$pb.TagNumber(7)
  set site($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSite() => $_has(6);
  @$pb.TagNumber(7)
  void clearSite() => $_clearField(7);

  @$pb.TagNumber(8)
  AdministrationOutcome get outcome => $_getN(7);
  @$pb.TagNumber(8)
  set outcome(AdministrationOutcome value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasOutcome() => $_has(7);
  @$pb.TagNumber(8)
  void clearOutcome() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get reason => $_getSZ(8);
  @$pb.TagNumber(9)
  set reason($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReason() => $_has(8);
  @$pb.TagNumber(9)
  void clearReason() => $_clearField(9);

  @$pb.TagNumber(10)
  Verification get verification => $_getN(9);
  @$pb.TagNumber(10)
  set verification(Verification value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasVerification() => $_has(9);
  @$pb.TagNumber(10)
  void clearVerification() => $_clearField(10);
  @$pb.TagNumber(10)
  Verification ensureVerification() => $_ensure(9);

  /// Supplied only when the nurse has decided to proceed past a failed or absent
  /// check. Its presence changes which permission is required.
  @$pb.TagNumber(11)
  $core.String get overrideReason => $_getSZ(10);
  @$pb.TagNumber(11)
  set overrideReason($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasOverrideReason() => $_has(10);
  @$pb.TagNumber(11)
  void clearOverrideReason() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get witnessedBy => $_getSZ(11);
  @$pb.TagNumber(12)
  set witnessedBy($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasWitnessedBy() => $_has(11);
  @$pb.TagNumber(12)
  void clearWitnessedBy() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get idempotencyKey => $_getSZ(12);
  @$pb.TagNumber(13)
  set idempotencyKey($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasIdempotencyKey() => $_has(12);
  @$pb.TagNumber(13)
  void clearIdempotencyKey() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.bool get offline => $_getBF(13);
  @$pb.TagNumber(14)
  set offline($core.bool value) => $_setBool(13, value);
  @$pb.TagNumber(14)
  $core.bool hasOffline() => $_has(13);
  @$pb.TagNumber(14)
  void clearOffline() => $_clearField(14);
}

class AdministerResponse extends $pb.GeneratedMessage {
  factory AdministerResponse({
    Administration? administration,
  }) {
    final result = create();
    if (administration != null) result.administration = administration;
    return result;
  }

  AdministerResponse._();

  factory AdministerResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdministerResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdministerResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Administration>(1, _omitFieldNames ? '' : 'administration',
        subBuilder: Administration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministerResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdministerResponse copyWith(void Function(AdministerResponse) updates) =>
      super.copyWith((message) => updates(message as AdministerResponse))
          as AdministerResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdministerResponse create() => AdministerResponse._();
  @$core.override
  AdministerResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdministerResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdministerResponse>(create);
  static AdministerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Administration get administration => $_getN(0);
  @$pb.TagNumber(1)
  set administration(Administration value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdministration() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdministration() => $_clearField(1);
  @$pb.TagNumber(1)
  Administration ensureAdministration() => $_ensure(0);
}

class ListAdministrationsRequest extends $pb.GeneratedMessage {
  factory ListAdministrationsRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.String? orderId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (orderId != null) result.orderId = orderId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAdministrationsRequest._();

  factory ListAdministrationsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdministrationsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdministrationsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdministrationsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdministrationsRequest copyWith(
          void Function(ListAdministrationsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ListAdministrationsRequest))
          as ListAdministrationsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdministrationsRequest create() => ListAdministrationsRequest._();
  @$core.override
  ListAdministrationsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdministrationsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdministrationsRequest>(create);
  static ListAdministrationsRequest? _defaultInstance;

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
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class ListAdministrationsResponse extends $pb.GeneratedMessage {
  factory ListAdministrationsResponse({
    $core.Iterable<Administration>? administrations,
  }) {
    final result = create();
    if (administrations != null) result.administrations.addAll(administrations);
    return result;
  }

  ListAdministrationsResponse._();

  factory ListAdministrationsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAdministrationsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAdministrationsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Administration>(1, _omitFieldNames ? '' : 'administrations',
        subBuilder: Administration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdministrationsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAdministrationsResponse copyWith(
          void Function(ListAdministrationsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ListAdministrationsResponse))
          as ListAdministrationsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAdministrationsResponse create() =>
      ListAdministrationsResponse._();
  @$core.override
  ListAdministrationsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAdministrationsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAdministrationsResponse>(create);
  static ListAdministrationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Administration> get administrations => $_getList(0);
}

class GetOverrideReportRequest extends $pb.GeneratedMessage {
  factory GetOverrideReportRequest({
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

  GetOverrideReportRequest._();

  factory GetOverrideReportRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOverrideReportRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverrideReportRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'from',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'to',
        subBuilder: $0.Timestamp.create)
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverrideReportRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverrideReportRequest copyWith(
          void Function(GetOverrideReportRequest) updates) =>
      super.copyWith((message) => updates(message as GetOverrideReportRequest))
          as GetOverrideReportRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOverrideReportRequest create() => GetOverrideReportRequest._();
  @$core.override
  GetOverrideReportRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOverrideReportRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverrideReportRequest>(create);
  static GetOverrideReportRequest? _defaultInstance;

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

class GetOverrideReportResponse extends $pb.GeneratedMessage {
  factory GetOverrideReportResponse({
    $core.Iterable<Administration>? administrations,
  }) {
    final result = create();
    if (administrations != null) result.administrations.addAll(administrations);
    return result;
  }

  GetOverrideReportResponse._();

  factory GetOverrideReportResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetOverrideReportResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetOverrideReportResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Administration>(1, _omitFieldNames ? '' : 'administrations',
        subBuilder: Administration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverrideReportResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetOverrideReportResponse copyWith(
          void Function(GetOverrideReportResponse) updates) =>
      super.copyWith((message) => updates(message as GetOverrideReportResponse))
          as GetOverrideReportResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetOverrideReportResponse create() => GetOverrideReportResponse._();
  @$core.override
  GetOverrideReportResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetOverrideReportResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetOverrideReportResponse>(create);
  static GetOverrideReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Administration> get administrations => $_getList(0);
}

class SetAdministrationPolicyRequest extends $pb.GeneratedMessage {
  factory SetAdministrationPolicyRequest({
    $core.String? facilityId,
    AdministrationPolicy? policy,
  }) {
    final result = create();
    if (facilityId != null) result.facilityId = facilityId;
    if (policy != null) result.policy = policy;
    return result;
  }

  SetAdministrationPolicyRequest._();

  factory SetAdministrationPolicyRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAdministrationPolicyRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAdministrationPolicyRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'facilityId')
    ..aOM<AdministrationPolicy>(2, _omitFieldNames ? '' : 'policy',
        subBuilder: AdministrationPolicy.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAdministrationPolicyRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAdministrationPolicyRequest copyWith(
          void Function(SetAdministrationPolicyRequest) updates) =>
      super.copyWith(
              (message) => updates(message as SetAdministrationPolicyRequest))
          as SetAdministrationPolicyRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAdministrationPolicyRequest create() =>
      SetAdministrationPolicyRequest._();
  @$core.override
  SetAdministrationPolicyRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAdministrationPolicyRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAdministrationPolicyRequest>(create);
  static SetAdministrationPolicyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get facilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set facilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFacilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFacilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  AdministrationPolicy get policy => $_getN(1);
  @$pb.TagNumber(2)
  set policy(AdministrationPolicy value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicy() => $_clearField(2);
  @$pb.TagNumber(2)
  AdministrationPolicy ensurePolicy() => $_ensure(1);
}

class SetAdministrationPolicyResponse extends $pb.GeneratedMessage {
  factory SetAdministrationPolicyResponse() => create();

  SetAdministrationPolicyResponse._();

  factory SetAdministrationPolicyResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAdministrationPolicyResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAdministrationPolicyResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAdministrationPolicyResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAdministrationPolicyResponse copyWith(
          void Function(SetAdministrationPolicyResponse) updates) =>
      super.copyWith(
              (message) => updates(message as SetAdministrationPolicyResponse))
          as SetAdministrationPolicyResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAdministrationPolicyResponse create() =>
      SetAdministrationPolicyResponse._();
  @$core.override
  SetAdministrationPolicyResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAdministrationPolicyResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAdministrationPolicyResponse>(
          create);
  static SetAdministrationPolicyResponse? _defaultInstance;
}

/// One piece of nursing work (SRS-NUR-011).
class NursingTask extends $pb.GeneratedMessage {
  factory NursingTask({
    $core.String? taskId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? description,
    TaskPriority? priority,
    $0.Timestamp? dueAt,
    $core.String? sourceKind,
    $core.String? sourceId,
    $fixnum.Int64? recurEverySeconds,
    $0.Timestamp? recurUntil,
    TaskStatus? status,
    $core.String? evidence,
    $0.Timestamp? completedAt,
    $core.String? completedBy,
    $core.String? notDoneReason,
    $core.String? assignedTo,
    $0.Timestamp? escalatedAt,
    $core.String? escalatedTo,
    $core.bool? overdue,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (description != null) result.description = description;
    if (priority != null) result.priority = priority;
    if (dueAt != null) result.dueAt = dueAt;
    if (sourceKind != null) result.sourceKind = sourceKind;
    if (sourceId != null) result.sourceId = sourceId;
    if (recurEverySeconds != null) result.recurEverySeconds = recurEverySeconds;
    if (recurUntil != null) result.recurUntil = recurUntil;
    if (status != null) result.status = status;
    if (evidence != null) result.evidence = evidence;
    if (completedAt != null) result.completedAt = completedAt;
    if (completedBy != null) result.completedBy = completedBy;
    if (notDoneReason != null) result.notDoneReason = notDoneReason;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (escalatedAt != null) result.escalatedAt = escalatedAt;
    if (escalatedTo != null) result.escalatedTo = escalatedTo;
    if (overdue != null) result.overdue = overdue;
    if (version != null) result.version = version;
    return result;
  }

  NursingTask._();

  factory NursingTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NursingTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NursingTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aE<TaskPriority>(5, _omitFieldNames ? '' : 'priority',
        enumValues: TaskPriority.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'sourceKind')
    ..aOS(8, _omitFieldNames ? '' : 'sourceId')
    ..aInt64(9, _omitFieldNames ? '' : 'recurEverySeconds')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'recurUntil',
        subBuilder: $0.Timestamp.create)
    ..aE<TaskStatus>(11, _omitFieldNames ? '' : 'status',
        enumValues: TaskStatus.values)
    ..aOS(12, _omitFieldNames ? '' : 'evidence')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'completedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(14, _omitFieldNames ? '' : 'completedBy')
    ..aOS(15, _omitFieldNames ? '' : 'notDoneReason')
    ..aOS(16, _omitFieldNames ? '' : 'assignedTo')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'escalatedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'escalatedTo')
    ..aOB(19, _omitFieldNames ? '' : 'overdue')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NursingTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NursingTask copyWith(void Function(NursingTask) updates) =>
      super.copyWith((message) => updates(message as NursingTask))
          as NursingTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NursingTask create() => NursingTask._();
  @$core.override
  NursingTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NursingTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NursingTask>(create);
  static NursingTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

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
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  TaskPriority get priority => $_getN(4);
  @$pb.TagNumber(5)
  set priority(TaskPriority value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get dueAt => $_getN(5);
  @$pb.TagNumber(6)
  set dueAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasDueAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearDueAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureDueAt() => $_ensure(5);

  /// Where the task came from, so completing it can close what raised it.
  @$pb.TagNumber(7)
  $core.String get sourceKind => $_getSZ(6);
  @$pb.TagNumber(7)
  set sourceKind($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSourceKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearSourceKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceId => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceId($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasSourceId() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceId() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get recurEverySeconds => $_getI64(8);
  @$pb.TagNumber(9)
  set recurEverySeconds($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecurEverySeconds() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecurEverySeconds() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get recurUntil => $_getN(9);
  @$pb.TagNumber(10)
  set recurUntil($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasRecurUntil() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecurUntil() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureRecurUntil() => $_ensure(9);

  @$pb.TagNumber(11)
  TaskStatus get status => $_getN(10);
  @$pb.TagNumber(11)
  set status(TaskStatus value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(11)
  void clearStatus() => $_clearField(11);

  /// What was observed or done, not merely that a box was ticked.
  @$pb.TagNumber(12)
  $core.String get evidence => $_getSZ(11);
  @$pb.TagNumber(12)
  set evidence($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasEvidence() => $_has(11);
  @$pb.TagNumber(12)
  void clearEvidence() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get completedAt => $_getN(12);
  @$pb.TagNumber(13)
  set completedAt($0.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCompletedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompletedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCompletedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.String get completedBy => $_getSZ(13);
  @$pb.TagNumber(14)
  set completedBy($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCompletedBy() => $_has(13);
  @$pb.TagNumber(14)
  void clearCompletedBy() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get notDoneReason => $_getSZ(14);
  @$pb.TagNumber(15)
  set notDoneReason($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasNotDoneReason() => $_has(14);
  @$pb.TagNumber(15)
  void clearNotDoneReason() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get assignedTo => $_getSZ(15);
  @$pb.TagNumber(16)
  set assignedTo($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasAssignedTo() => $_has(15);
  @$pb.TagNumber(16)
  void clearAssignedTo() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get escalatedAt => $_getN(16);
  @$pb.TagNumber(17)
  set escalatedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasEscalatedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearEscalatedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureEscalatedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get escalatedTo => $_getSZ(17);
  @$pb.TagNumber(18)
  set escalatedTo($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasEscalatedTo() => $_has(17);
  @$pb.TagNumber(18)
  void clearEscalatedTo() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get overdue => $_getBF(18);
  @$pb.TagNumber(19)
  set overdue($core.bool value) => $_setBool(18, value);
  @$pb.TagNumber(19)
  $core.bool hasOverdue() => $_has(18);
  @$pb.TagNumber(19)
  void clearOverdue() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

class CreateTaskRequest extends $pb.GeneratedMessage {
  factory CreateTaskRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? description,
    TaskPriority? priority,
    $0.Timestamp? dueAt,
    $fixnum.Int64? recurEverySeconds,
    $0.Timestamp? recurUntil,
    $core.String? assignedTo,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (description != null) result.description = description;
    if (priority != null) result.priority = priority;
    if (dueAt != null) result.dueAt = dueAt;
    if (recurEverySeconds != null) result.recurEverySeconds = recurEverySeconds;
    if (recurUntil != null) result.recurUntil = recurUntil;
    if (assignedTo != null) result.assignedTo = assignedTo;
    return result;
  }

  CreateTaskRequest._();

  factory CreateTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aE<TaskPriority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: TaskPriority.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(6, _omitFieldNames ? '' : 'recurEverySeconds')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'recurUntil',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'assignedTo')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTaskRequest copyWith(void Function(CreateTaskRequest) updates) =>
      super.copyWith((message) => updates(message as CreateTaskRequest))
          as CreateTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTaskRequest create() => CreateTaskRequest._();
  @$core.override
  CreateTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTaskRequest>(create);
  static CreateTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  TaskPriority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(TaskPriority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get dueAt => $_getN(4);
  @$pb.TagNumber(5)
  set dueAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDueAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearDueAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureDueAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $fixnum.Int64 get recurEverySeconds => $_getI64(5);
  @$pb.TagNumber(6)
  set recurEverySeconds($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRecurEverySeconds() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecurEverySeconds() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get recurUntil => $_getN(6);
  @$pb.TagNumber(7)
  set recurUntil($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasRecurUntil() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecurUntil() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureRecurUntil() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get assignedTo => $_getSZ(7);
  @$pb.TagNumber(8)
  set assignedTo($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAssignedTo() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssignedTo() => $_clearField(8);
}

class CreateTaskResponse extends $pb.GeneratedMessage {
  factory CreateTaskResponse({
    NursingTask? task,
  }) {
    final result = create();
    if (task != null) result.task = task;
    return result;
  }

  CreateTaskResponse._();

  factory CreateTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<NursingTask>(1, _omitFieldNames ? '' : 'task',
        subBuilder: NursingTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateTaskResponse copyWith(void Function(CreateTaskResponse) updates) =>
      super.copyWith((message) => updates(message as CreateTaskResponse))
          as CreateTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateTaskResponse create() => CreateTaskResponse._();
  @$core.override
  CreateTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateTaskResponse>(create);
  static CreateTaskResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NursingTask get task => $_getN(0);
  @$pb.TagNumber(1)
  set task(NursingTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTask() => $_has(0);
  @$pb.TagNumber(1)
  void clearTask() => $_clearField(1);
  @$pb.TagNumber(1)
  NursingTask ensureTask() => $_ensure(0);
}

class CompleteTaskRequest extends $pb.GeneratedMessage {
  factory CompleteTaskRequest({
    $core.String? taskId,
    $core.String? evidence,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (evidence != null) result.evidence = evidence;
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
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'evidence')
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
  $core.String get evidence => $_getSZ(1);
  @$pb.TagNumber(2)
  set evidence($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEvidence() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvidence() => $_clearField(2);
}

class CompleteTaskResponse extends $pb.GeneratedMessage {
  factory CompleteTaskResponse({
    NursingTask? next,
  }) {
    final result = create();
    if (next != null) result.next = next;
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
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<NursingTask>(1, _omitFieldNames ? '' : 'next',
        subBuilder: NursingTask.create)
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

  /// The next occurrence, where the task recurs. Absent for a one-off.
  @$pb.TagNumber(1)
  NursingTask get next => $_getN(0);
  @$pb.TagNumber(1)
  set next(NursingTask value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasNext() => $_has(0);
  @$pb.TagNumber(1)
  void clearNext() => $_clearField(1);
  @$pb.TagNumber(1)
  NursingTask ensureNext() => $_ensure(0);
}

class SkipTaskRequest extends $pb.GeneratedMessage {
  factory SkipTaskRequest({
    $core.String? taskId,
    $core.String? reason,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (reason != null) result.reason = reason;
    return result;
  }

  SkipTaskRequest._();

  factory SkipTaskRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SkipTaskRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkipTaskRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipTaskRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipTaskRequest copyWith(void Function(SkipTaskRequest) updates) =>
      super.copyWith((message) => updates(message as SkipTaskRequest))
          as SkipTaskRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SkipTaskRequest create() => SkipTaskRequest._();
  @$core.override
  SkipTaskRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SkipTaskRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SkipTaskRequest>(create);
  static SkipTaskRequest? _defaultInstance;

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
}

class SkipTaskResponse extends $pb.GeneratedMessage {
  factory SkipTaskResponse() => create();

  SkipTaskResponse._();

  factory SkipTaskResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SkipTaskResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SkipTaskResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipTaskResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SkipTaskResponse copyWith(void Function(SkipTaskResponse) updates) =>
      super.copyWith((message) => updates(message as SkipTaskResponse))
          as SkipTaskResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SkipTaskResponse create() => SkipTaskResponse._();
  @$core.override
  SkipTaskResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SkipTaskResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SkipTaskResponse>(create);
  static SkipTaskResponse? _defaultInstance;
}

class GetWorklistRequest extends $pb.GeneratedMessage {
  factory GetWorklistRequest({
    $core.String? encounterId,
    $core.String? assignedTo,
    $core.bool? pendingOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (assignedTo != null) result.assignedTo = assignedTo;
    if (pendingOnly != null) result.pendingOnly = pendingOnly;
    if (pageSize != null) result.pageSize = pageSize;
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
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'assignedTo')
    ..aOB(3, _omitFieldNames ? '' : 'pendingOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
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
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assignedTo => $_getSZ(1);
  @$pb.TagNumber(2)
  set assignedTo($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAssignedTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssignedTo() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get pendingOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set pendingOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPendingOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearPendingOnly() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pageSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set pageSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPageSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageSize() => $_clearField(4);
}

class GetWorklistResponse extends $pb.GeneratedMessage {
  factory GetWorklistResponse({
    $core.Iterable<NursingTask>? tasks,
  }) {
    final result = create();
    if (tasks != null) result.tasks.addAll(tasks);
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
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<NursingTask>(1, _omitFieldNames ? '' : 'tasks',
        subBuilder: NursingTask.create)
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

  /// Most urgent first, then by how overdue.
  @$pb.TagNumber(1)
  $pb.PbList<NursingTask> get tasks => $_getList(0);
}

class EscalateOverdueWorkRequest extends $pb.GeneratedMessage {
  factory EscalateOverdueWorkRequest({
    $core.String? escalateTo,
    $core.int? pageSize,
  }) {
    final result = create();
    if (escalateTo != null) result.escalateTo = escalateTo;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  EscalateOverdueWorkRequest._();

  factory EscalateOverdueWorkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueWorkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueWorkRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'escalateTo')
    ..aI(2, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueWorkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueWorkRequest copyWith(
          void Function(EscalateOverdueWorkRequest) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueWorkRequest))
          as EscalateOverdueWorkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueWorkRequest create() => EscalateOverdueWorkRequest._();
  @$core.override
  EscalateOverdueWorkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueWorkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueWorkRequest>(create);
  static EscalateOverdueWorkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get escalateTo => $_getSZ(0);
  @$pb.TagNumber(1)
  set escalateTo($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEscalateTo() => $_has(0);
  @$pb.TagNumber(1)
  void clearEscalateTo() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);
}

class EscalateOverdueWorkResponse extends $pb.GeneratedMessage {
  factory EscalateOverdueWorkResponse({
    $core.Iterable<NursingTask>? escalated,
  }) {
    final result = create();
    if (escalated != null) result.escalated.addAll(escalated);
    return result;
  }

  EscalateOverdueWorkResponse._();

  factory EscalateOverdueWorkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EscalateOverdueWorkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EscalateOverdueWorkResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<NursingTask>(1, _omitFieldNames ? '' : 'escalated',
        subBuilder: NursingTask.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueWorkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EscalateOverdueWorkResponse copyWith(
          void Function(EscalateOverdueWorkResponse) updates) =>
      super.copyWith(
              (message) => updates(message as EscalateOverdueWorkResponse))
          as EscalateOverdueWorkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EscalateOverdueWorkResponse create() =>
      EscalateOverdueWorkResponse._();
  @$core.override
  EscalateOverdueWorkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EscalateOverdueWorkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EscalateOverdueWorkResponse>(create);
  static EscalateOverdueWorkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NursingTask> get escalated => $_getList(0);
}

/// A measurable target.
class PlanGoal extends $pb.GeneratedMessage {
  factory PlanGoal({
    $core.String? goalId,
    $core.String? description,
    $0.Timestamp? targetDate,
    $core.bool? met,
    $core.String? evaluation,
  }) {
    final result = create();
    if (goalId != null) result.goalId = goalId;
    if (description != null) result.description = description;
    if (targetDate != null) result.targetDate = targetDate;
    if (met != null) result.met = met;
    if (evaluation != null) result.evaluation = evaluation;
    return result;
  }

  PlanGoal._();

  factory PlanGoal.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanGoal.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanGoal',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'goalId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'targetDate',
        subBuilder: $0.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'met')
    ..aOS(5, _omitFieldNames ? '' : 'evaluation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanGoal clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanGoal copyWith(void Function(PlanGoal) updates) =>
      super.copyWith((message) => updates(message as PlanGoal)) as PlanGoal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanGoal create() => PlanGoal._();
  @$core.override
  PlanGoal createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanGoal getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlanGoal>(create);
  static PlanGoal? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get goalId => $_getSZ(0);
  @$pb.TagNumber(1)
  set goalId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasGoalId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGoalId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get targetDate => $_getN(2);
  @$pb.TagNumber(3)
  set targetDate($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTargetDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTargetDate() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get met => $_getBF(3);
  @$pb.TagNumber(4)
  set met($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMet() => $_has(3);
  @$pb.TagNumber(4)
  void clearMet() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get evaluation => $_getSZ(4);
  @$pb.TagNumber(5)
  set evaluation($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEvaluation() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvaluation() => $_clearField(5);
}

/// A planned nursing action. The frequency is what turns the plan into work.
class Intervention extends $pb.GeneratedMessage {
  factory Intervention({
    $core.String? interventionId,
    $core.String? description,
    $fixnum.Int64? everySeconds,
    TaskPriority? priority,
    $core.String? owner,
  }) {
    final result = create();
    if (interventionId != null) result.interventionId = interventionId;
    if (description != null) result.description = description;
    if (everySeconds != null) result.everySeconds = everySeconds;
    if (priority != null) result.priority = priority;
    if (owner != null) result.owner = owner;
    return result;
  }

  Intervention._();

  factory Intervention.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Intervention.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Intervention',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'interventionId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aInt64(3, _omitFieldNames ? '' : 'everySeconds')
    ..aE<TaskPriority>(4, _omitFieldNames ? '' : 'priority',
        enumValues: TaskPriority.values)
    ..aOS(5, _omitFieldNames ? '' : 'owner')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Intervention clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Intervention copyWith(void Function(Intervention) updates) =>
      super.copyWith((message) => updates(message as Intervention))
          as Intervention;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Intervention create() => Intervention._();
  @$core.override
  Intervention createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Intervention getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Intervention>(create);
  static Intervention? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get interventionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set interventionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasInterventionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearInterventionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  /// Zero means continuous or as-needed, and schedules nothing.
  @$pb.TagNumber(3)
  $fixnum.Int64 get everySeconds => $_getI64(2);
  @$pb.TagNumber(3)
  set everySeconds($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEverySeconds() => $_has(2);
  @$pb.TagNumber(3)
  void clearEverySeconds() => $_clearField(3);

  @$pb.TagNumber(4)
  TaskPriority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(TaskPriority value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get owner => $_getSZ(4);
  @$pb.TagNumber(5)
  set owner($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOwner() => $_has(4);
  @$pb.TagNumber(5)
  void clearOwner() => $_clearField(5);
}

class PlanProblem extends $pb.GeneratedMessage {
  factory PlanProblem({
    $core.String? problemId,
    $core.String? description,
    Coding? coded,
    $core.Iterable<PlanGoal>? goals,
    $core.Iterable<Intervention>? interventions,
    $core.bool? resolved,
  }) {
    final result = create();
    if (problemId != null) result.problemId = problemId;
    if (description != null) result.description = description;
    if (coded != null) result.coded = coded;
    if (goals != null) result.goals.addAll(goals);
    if (interventions != null) result.interventions.addAll(interventions);
    if (resolved != null) result.resolved = resolved;
    return result;
  }

  PlanProblem._();

  factory PlanProblem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PlanProblem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PlanProblem',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'problemId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'coded', subBuilder: Coding.create)
    ..pPM<PlanGoal>(4, _omitFieldNames ? '' : 'goals',
        subBuilder: PlanGoal.create)
    ..pPM<Intervention>(5, _omitFieldNames ? '' : 'interventions',
        subBuilder: Intervention.create)
    ..aOB(6, _omitFieldNames ? '' : 'resolved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanProblem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PlanProblem copyWith(void Function(PlanProblem) updates) =>
      super.copyWith((message) => updates(message as PlanProblem))
          as PlanProblem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlanProblem create() => PlanProblem._();
  @$core.override
  PlanProblem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PlanProblem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PlanProblem>(create);
  static PlanProblem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get problemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set problemId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasProblemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProblemId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get coded => $_getN(2);
  @$pb.TagNumber(3)
  set coded(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCoded() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoded() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureCoded() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<PlanGoal> get goals => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<Intervention> get interventions => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get resolved => $_getBF(5);
  @$pb.TagNumber(6)
  set resolved($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasResolved() => $_has(5);
  @$pb.TagNumber(6)
  void clearResolved() => $_clearField(6);
}

/// A nursing plan of care (SRS-NUR-002).
class CarePlan extends $pb.GeneratedMessage {
  factory CarePlan({
    $core.String? planId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? title,
    $core.Iterable<PlanProblem>? problems,
    PlanStatus? status,
    $0.Timestamp? createdAt,
    $core.String? createdBy,
    $0.Timestamp? reviewedAt,
    $core.String? reviewedBy,
    $core.String? evaluation,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (title != null) result.title = title;
    if (problems != null) result.problems.addAll(problems);
    if (status != null) result.status = status;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdBy != null) result.createdBy = createdBy;
    if (reviewedAt != null) result.reviewedAt = reviewedAt;
    if (reviewedBy != null) result.reviewedBy = reviewedBy;
    if (evaluation != null) result.evaluation = evaluation;
    if (version != null) result.version = version;
    return result;
  }

  CarePlan._();

  factory CarePlan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CarePlan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CarePlan',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'title')
    ..pPM<PlanProblem>(5, _omitFieldNames ? '' : 'problems',
        subBuilder: PlanProblem.create)
    ..aE<PlanStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: PlanStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'createdBy')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'reviewedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(11, _omitFieldNames ? '' : 'evaluation')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CarePlan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CarePlan copyWith(void Function(CarePlan) updates) =>
      super.copyWith((message) => updates(message as CarePlan)) as CarePlan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CarePlan create() => CarePlan._();
  @$core.override
  CarePlan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CarePlan getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CarePlan>(create);
  static CarePlan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

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
  $core.String get title => $_getSZ(3);
  @$pb.TagNumber(4)
  set title($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearTitle() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<PlanProblem> get problems => $_getList(4);

  @$pb.TagNumber(6)
  PlanStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(PlanStatus value) => $_setField(6, value);
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
  $core.String get createdBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set createdBy($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedBy() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get reviewedAt => $_getN(8);
  @$pb.TagNumber(9)
  set reviewedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasReviewedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureReviewedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get reviewedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set reviewedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasReviewedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearReviewedBy() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get evaluation => $_getSZ(10);
  @$pb.TagNumber(11)
  set evaluation($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasEvaluation() => $_has(10);
  @$pb.TagNumber(11)
  void clearEvaluation() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

class CreateCarePlanRequest extends $pb.GeneratedMessage {
  factory CreateCarePlanRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? title,
    $core.Iterable<PlanProblem>? problems,
    $0.Timestamp? scheduleUntil,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (title != null) result.title = title;
    if (problems != null) result.problems.addAll(problems);
    if (scheduleUntil != null) result.scheduleUntil = scheduleUntil;
    return result;
  }

  CreateCarePlanRequest._();

  factory CreateCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..pPM<PlanProblem>(4, _omitFieldNames ? '' : 'problems',
        subBuilder: PlanProblem.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'scheduleUntil',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanRequest copyWith(
          void Function(CreateCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as CreateCarePlanRequest))
          as CreateCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCarePlanRequest create() => CreateCarePlanRequest._();
  @$core.override
  CreateCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateCarePlanRequest>(create);
  static CreateCarePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<PlanProblem> get problems => $_getList(3);

  /// How far ahead to schedule the plan's work. A shift by default; a week at
  /// most.
  @$pb.TagNumber(5)
  $0.Timestamp get scheduleUntil => $_getN(4);
  @$pb.TagNumber(5)
  set scheduleUntil($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasScheduleUntil() => $_has(4);
  @$pb.TagNumber(5)
  void clearScheduleUntil() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureScheduleUntil() => $_ensure(4);
}

class CreateCarePlanResponse extends $pb.GeneratedMessage {
  factory CreateCarePlanResponse({
    CarePlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  CreateCarePlanResponse._();

  factory CreateCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateCarePlanResponse copyWith(
          void Function(CreateCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as CreateCarePlanResponse))
          as CreateCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCarePlanResponse create() => CreateCarePlanResponse._();
  @$core.override
  CreateCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateCarePlanResponse>(create);
  static CreateCarePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CarePlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(CarePlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  CarePlan ensurePlan() => $_ensure(0);
}

class ReviewCarePlanRequest extends $pb.GeneratedMessage {
  factory ReviewCarePlanRequest({
    $core.String? planId,
    $core.String? evaluation,
  }) {
    final result = create();
    if (planId != null) result.planId = planId;
    if (evaluation != null) result.evaluation = evaluation;
    return result;
  }

  ReviewCarePlanRequest._();

  factory ReviewCarePlanRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewCarePlanRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewCarePlanRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'planId')
    ..aOS(2, _omitFieldNames ? '' : 'evaluation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCarePlanRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCarePlanRequest copyWith(
          void Function(ReviewCarePlanRequest) updates) =>
      super.copyWith((message) => updates(message as ReviewCarePlanRequest))
          as ReviewCarePlanRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewCarePlanRequest create() => ReviewCarePlanRequest._();
  @$core.override
  ReviewCarePlanRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewCarePlanRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewCarePlanRequest>(create);
  static ReviewCarePlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get planId => $_getSZ(0);
  @$pb.TagNumber(1)
  set planId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPlanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlanId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get evaluation => $_getSZ(1);
  @$pb.TagNumber(2)
  set evaluation($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEvaluation() => $_has(1);
  @$pb.TagNumber(2)
  void clearEvaluation() => $_clearField(2);
}

class ReviewCarePlanResponse extends $pb.GeneratedMessage {
  factory ReviewCarePlanResponse({
    CarePlan? plan,
  }) {
    final result = create();
    if (plan != null) result.plan = plan;
    return result;
  }

  ReviewCarePlanResponse._();

  factory ReviewCarePlanResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReviewCarePlanResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReviewCarePlanResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<CarePlan>(1, _omitFieldNames ? '' : 'plan',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCarePlanResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReviewCarePlanResponse copyWith(
          void Function(ReviewCarePlanResponse) updates) =>
      super.copyWith((message) => updates(message as ReviewCarePlanResponse))
          as ReviewCarePlanResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewCarePlanResponse create() => ReviewCarePlanResponse._();
  @$core.override
  ReviewCarePlanResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReviewCarePlanResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReviewCarePlanResponse>(create);
  static ReviewCarePlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  CarePlan get plan => $_getN(0);
  @$pb.TagNumber(1)
  set plan(CarePlan value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlan() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlan() => $_clearField(1);
  @$pb.TagNumber(1)
  CarePlan ensurePlan() => $_ensure(0);
}

class ListCarePlansRequest extends $pb.GeneratedMessage {
  factory ListCarePlansRequest({
    $core.String? encounterId,
    $core.String? patientId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListCarePlansRequest._();

  factory ListCarePlansRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCarePlansRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCarePlansRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOB(3, _omitFieldNames ? '' : 'activeOnly')
    ..aI(4, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCarePlansRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCarePlansRequest copyWith(void Function(ListCarePlansRequest) updates) =>
      super.copyWith((message) => updates(message as ListCarePlansRequest))
          as ListCarePlansRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCarePlansRequest create() => ListCarePlansRequest._();
  @$core.override
  ListCarePlansRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCarePlansRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCarePlansRequest>(create);
  static ListCarePlansRequest? _defaultInstance;

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
}

class ListCarePlansResponse extends $pb.GeneratedMessage {
  factory ListCarePlansResponse({
    $core.Iterable<CarePlan>? plans,
  }) {
    final result = create();
    if (plans != null) result.plans.addAll(plans);
    return result;
  }

  ListCarePlansResponse._();

  factory ListCarePlansResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListCarePlansResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListCarePlansResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<CarePlan>(1, _omitFieldNames ? '' : 'plans',
        subBuilder: CarePlan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCarePlansResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListCarePlansResponse copyWith(
          void Function(ListCarePlansResponse) updates) =>
      super.copyWith((message) => updates(message as ListCarePlansResponse))
          as ListCarePlansResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListCarePlansResponse create() => ListCarePlansResponse._();
  @$core.override
  ListCarePlansResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListCarePlansResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListCarePlansResponse>(create);
  static ListCarePlansResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CarePlan> get plans => $_getList(0);
}

/// The working period a handover runs between.
class Shift extends $pb.GeneratedMessage {
  factory Shift({
    $core.String? code,
    $0.Timestamp? startsAt,
    $0.Timestamp? endsAt,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (startsAt != null) result.startsAt = startsAt;
    if (endsAt != null) result.endsAt = endsAt;
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
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'startsAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'endsAt',
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
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get startsAt => $_getN(1);
  @$pb.TagNumber(2)
  set startsAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStartsAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartsAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureStartsAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get endsAt => $_getN(2);
  @$pb.TagNumber(3)
  set endsAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEndsAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndsAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureEndsAt() => $_ensure(2);
}

class HandoverDevice extends $pb.GeneratedMessage {
  factory HandoverDevice({
    $core.String? deviceId,
    DeviceKind? kind,
    $core.String? site,
    $0.Timestamp? insertedAt,
    $core.int? deviceDays,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (kind != null) result.kind = kind;
    if (site != null) result.site = site;
    if (insertedAt != null) result.insertedAt = insertedAt;
    if (deviceDays != null) result.deviceDays = deviceDays;
    return result;
  }

  HandoverDevice._();

  factory HandoverDevice.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandoverDevice.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandoverDevice',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aE<DeviceKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: DeviceKind.values)
    ..aOS(3, _omitFieldNames ? '' : 'site')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'insertedAt',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'deviceDays')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoverDevice clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoverDevice copyWith(void Function(HandoverDevice) updates) =>
      super.copyWith((message) => updates(message as HandoverDevice))
          as HandoverDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandoverDevice create() => HandoverDevice._();
  @$core.override
  HandoverDevice createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandoverDevice getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandoverDevice>(create);
  static HandoverDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  DeviceKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(DeviceKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get site => $_getSZ(2);
  @$pb.TagNumber(3)
  set site($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSite() => $_has(2);
  @$pb.TagNumber(3)
  void clearSite() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get insertedAt => $_getN(3);
  @$pb.TagNumber(4)
  set insertedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasInsertedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearInsertedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureInsertedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get deviceDays => $_getIZ(4);
  @$pb.TagNumber(5)
  set deviceDays($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeviceDays() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeviceDays() => $_clearField(5);
}

class HandoverTask extends $pb.GeneratedMessage {
  factory HandoverTask({
    $core.String? taskId,
    $core.String? description,
    TaskPriority? priority,
    $0.Timestamp? dueAt,
    $core.bool? overdue,
  }) {
    final result = create();
    if (taskId != null) result.taskId = taskId;
    if (description != null) result.description = description;
    if (priority != null) result.priority = priority;
    if (dueAt != null) result.dueAt = dueAt;
    if (overdue != null) result.overdue = overdue;
    return result;
  }

  HandoverTask._();

  factory HandoverTask.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HandoverTask.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HandoverTask',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskId')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..aE<TaskPriority>(3, _omitFieldNames ? '' : 'priority',
        enumValues: TaskPriority.values)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'dueAt',
        subBuilder: $0.Timestamp.create)
    ..aOB(5, _omitFieldNames ? '' : 'overdue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoverTask clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HandoverTask copyWith(void Function(HandoverTask) updates) =>
      super.copyWith((message) => updates(message as HandoverTask))
          as HandoverTask;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HandoverTask create() => HandoverTask._();
  @$core.override
  HandoverTask createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HandoverTask getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HandoverTask>(create);
  static HandoverTask? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskId => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTaskId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  TaskPriority get priority => $_getN(2);
  @$pb.TagNumber(3)
  set priority(TaskPriority value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get dueAt => $_getN(3);
  @$pb.TagNumber(4)
  set dueAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDueAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearDueAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureDueAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get overdue => $_getBF(4);
  @$pb.TagNumber(5)
  set overdue($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOverdue() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverdue() => $_clearField(5);
}

/// One shift's handover for one patient (SRS-NUR-010).
///
/// A stored snapshot rather than a live view: rendered live, the handover
/// acknowledged at 20:00 shows something different at 23:00.
class Handover extends $pb.GeneratedMessage {
  factory Handover({
    $core.String? handoverId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? unitId,
    Shift? fromShift,
    Shift? toShift,
    $core.String? situation,
    $core.String? background,
    $core.String? assessment,
    $core.String? recommendation,
    $core.Iterable<$core.String>? criticalRisks,
    $core.Iterable<$core.String>? outstanding,
    $core.Iterable<HandoverDevice>? devices,
    $core.Iterable<HandoverTask>? pendingTasks,
    $0.Timestamp? composedAt,
    $core.String? composedBy,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedBy,
    $core.String? questions,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (handoverId != null) result.handoverId = handoverId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (unitId != null) result.unitId = unitId;
    if (fromShift != null) result.fromShift = fromShift;
    if (toShift != null) result.toShift = toShift;
    if (situation != null) result.situation = situation;
    if (background != null) result.background = background;
    if (assessment != null) result.assessment = assessment;
    if (recommendation != null) result.recommendation = recommendation;
    if (criticalRisks != null) result.criticalRisks.addAll(criticalRisks);
    if (outstanding != null) result.outstanding.addAll(outstanding);
    if (devices != null) result.devices.addAll(devices);
    if (pendingTasks != null) result.pendingTasks.addAll(pendingTasks);
    if (composedAt != null) result.composedAt = composedAt;
    if (composedBy != null) result.composedBy = composedBy;
    if (acknowledgedAt != null) result.acknowledgedAt = acknowledgedAt;
    if (acknowledgedBy != null) result.acknowledgedBy = acknowledgedBy;
    if (questions != null) result.questions = questions;
    if (version != null) result.version = version;
    return result;
  }

  Handover._();

  factory Handover.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Handover.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Handover',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'handoverId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'unitId')
    ..aOM<Shift>(5, _omitFieldNames ? '' : 'fromShift',
        subBuilder: Shift.create)
    ..aOM<Shift>(6, _omitFieldNames ? '' : 'toShift', subBuilder: Shift.create)
    ..aOS(7, _omitFieldNames ? '' : 'situation')
    ..aOS(8, _omitFieldNames ? '' : 'background')
    ..aOS(9, _omitFieldNames ? '' : 'assessment')
    ..aOS(10, _omitFieldNames ? '' : 'recommendation')
    ..pPS(11, _omitFieldNames ? '' : 'criticalRisks')
    ..pPS(12, _omitFieldNames ? '' : 'outstanding')
    ..pPM<HandoverDevice>(13, _omitFieldNames ? '' : 'devices',
        subBuilder: HandoverDevice.create)
    ..pPM<HandoverTask>(14, _omitFieldNames ? '' : 'pendingTasks',
        subBuilder: HandoverTask.create)
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'composedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(16, _omitFieldNames ? '' : 'composedBy')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'acknowledgedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(18, _omitFieldNames ? '' : 'acknowledgedBy')
    ..aOS(19, _omitFieldNames ? '' : 'questions')
    ..aInt64(20, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Handover clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Handover copyWith(void Function(Handover) updates) =>
      super.copyWith((message) => updates(message as Handover)) as Handover;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Handover create() => Handover._();
  @$core.override
  Handover createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Handover getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Handover>(create);
  static Handover? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get handoverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set handoverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHandoverId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandoverId() => $_clearField(1);

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
  $core.String get unitId => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitId() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitId() => $_clearField(4);

  @$pb.TagNumber(5)
  Shift get fromShift => $_getN(4);
  @$pb.TagNumber(5)
  set fromShift(Shift value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasFromShift() => $_has(4);
  @$pb.TagNumber(5)
  void clearFromShift() => $_clearField(5);
  @$pb.TagNumber(5)
  Shift ensureFromShift() => $_ensure(4);

  @$pb.TagNumber(6)
  Shift get toShift => $_getN(5);
  @$pb.TagNumber(6)
  set toShift(Shift value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasToShift() => $_has(5);
  @$pb.TagNumber(6)
  void clearToShift() => $_clearField(6);
  @$pb.TagNumber(6)
  Shift ensureToShift() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get situation => $_getSZ(6);
  @$pb.TagNumber(7)
  set situation($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSituation() => $_has(6);
  @$pb.TagNumber(7)
  void clearSituation() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get background => $_getSZ(7);
  @$pb.TagNumber(8)
  set background($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBackground() => $_has(7);
  @$pb.TagNumber(8)
  void clearBackground() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get assessment => $_getSZ(8);
  @$pb.TagNumber(9)
  set assessment($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAssessment() => $_has(8);
  @$pb.TagNumber(9)
  void clearAssessment() => $_clearField(9);

  /// The part the incoming nurse acts on.
  @$pb.TagNumber(10)
  $core.String get recommendation => $_getSZ(9);
  @$pb.TagNumber(10)
  set recommendation($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasRecommendation() => $_has(9);
  @$pb.TagNumber(10)
  void clearRecommendation() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get criticalRisks => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get outstanding => $_getList(11);

  /// Captured by the server from the ward's state, so a handover cannot quietly
  /// omit the line that has been in for nine days.
  @$pb.TagNumber(13)
  $pb.PbList<HandoverDevice> get devices => $_getList(12);

  @$pb.TagNumber(14)
  $pb.PbList<HandoverTask> get pendingTasks => $_getList(13);

  @$pb.TagNumber(15)
  $0.Timestamp get composedAt => $_getN(14);
  @$pb.TagNumber(15)
  set composedAt($0.Timestamp value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasComposedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearComposedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureComposedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $core.String get composedBy => $_getSZ(15);
  @$pb.TagNumber(16)
  set composedBy($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasComposedBy() => $_has(15);
  @$pb.TagNumber(16)
  void clearComposedBy() => $_clearField(16);

  /// The acceptance criterion, and the reason this is a record rather than a
  /// report.
  @$pb.TagNumber(17)
  $0.Timestamp get acknowledgedAt => $_getN(16);
  @$pb.TagNumber(17)
  set acknowledgedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasAcknowledgedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearAcknowledgedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(16);

  @$pb.TagNumber(18)
  $core.String get acknowledgedBy => $_getSZ(17);
  @$pb.TagNumber(18)
  set acknowledgedBy($core.String value) => $_setString(17, value);
  @$pb.TagNumber(18)
  $core.bool hasAcknowledgedBy() => $_has(17);
  @$pb.TagNumber(18)
  void clearAcknowledgedBy() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get questions => $_getSZ(18);
  @$pb.TagNumber(19)
  set questions($core.String value) => $_setString(18, value);
  @$pb.TagNumber(19)
  $core.bool hasQuestions() => $_has(18);
  @$pb.TagNumber(19)
  void clearQuestions() => $_clearField(19);

  @$pb.TagNumber(20)
  $fixnum.Int64 get version => $_getI64(19);
  @$pb.TagNumber(20)
  set version($fixnum.Int64 value) => $_setInt64(19, value);
  @$pb.TagNumber(20)
  $core.bool hasVersion() => $_has(19);
  @$pb.TagNumber(20)
  void clearVersion() => $_clearField(20);
}

class ComposeHandoverRequest extends $pb.GeneratedMessage {
  factory ComposeHandoverRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? unitId,
    Shift? fromShift,
    Shift? toShift,
    $core.String? situation,
    $core.String? background,
    $core.String? assessment,
    $core.String? recommendation,
    $core.Iterable<$core.String>? criticalRisks,
    $core.Iterable<$core.String>? outstanding,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (unitId != null) result.unitId = unitId;
    if (fromShift != null) result.fromShift = fromShift;
    if (toShift != null) result.toShift = toShift;
    if (situation != null) result.situation = situation;
    if (background != null) result.background = background;
    if (assessment != null) result.assessment = assessment;
    if (recommendation != null) result.recommendation = recommendation;
    if (criticalRisks != null) result.criticalRisks.addAll(criticalRisks);
    if (outstanding != null) result.outstanding.addAll(outstanding);
    return result;
  }

  ComposeHandoverRequest._();

  factory ComposeHandoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComposeHandoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComposeHandoverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'unitId')
    ..aOM<Shift>(4, _omitFieldNames ? '' : 'fromShift',
        subBuilder: Shift.create)
    ..aOM<Shift>(5, _omitFieldNames ? '' : 'toShift', subBuilder: Shift.create)
    ..aOS(6, _omitFieldNames ? '' : 'situation')
    ..aOS(7, _omitFieldNames ? '' : 'background')
    ..aOS(8, _omitFieldNames ? '' : 'assessment')
    ..aOS(9, _omitFieldNames ? '' : 'recommendation')
    ..pPS(10, _omitFieldNames ? '' : 'criticalRisks')
    ..pPS(11, _omitFieldNames ? '' : 'outstanding')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeHandoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeHandoverRequest copyWith(
          void Function(ComposeHandoverRequest) updates) =>
      super.copyWith((message) => updates(message as ComposeHandoverRequest))
          as ComposeHandoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComposeHandoverRequest create() => ComposeHandoverRequest._();
  @$core.override
  ComposeHandoverRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComposeHandoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComposeHandoverRequest>(create);
  static ComposeHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitId => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitId() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitId() => $_clearField(3);

  @$pb.TagNumber(4)
  Shift get fromShift => $_getN(3);
  @$pb.TagNumber(4)
  set fromShift(Shift value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFromShift() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromShift() => $_clearField(4);
  @$pb.TagNumber(4)
  Shift ensureFromShift() => $_ensure(3);

  @$pb.TagNumber(5)
  Shift get toShift => $_getN(4);
  @$pb.TagNumber(5)
  set toShift(Shift value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasToShift() => $_has(4);
  @$pb.TagNumber(5)
  void clearToShift() => $_clearField(5);
  @$pb.TagNumber(5)
  Shift ensureToShift() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get situation => $_getSZ(5);
  @$pb.TagNumber(6)
  set situation($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSituation() => $_has(5);
  @$pb.TagNumber(6)
  void clearSituation() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get background => $_getSZ(6);
  @$pb.TagNumber(7)
  set background($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasBackground() => $_has(6);
  @$pb.TagNumber(7)
  void clearBackground() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get assessment => $_getSZ(7);
  @$pb.TagNumber(8)
  set assessment($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasAssessment() => $_has(7);
  @$pb.TagNumber(8)
  void clearAssessment() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get recommendation => $_getSZ(8);
  @$pb.TagNumber(9)
  set recommendation($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasRecommendation() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecommendation() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get criticalRisks => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get outstanding => $_getList(10);
}

class ComposeHandoverResponse extends $pb.GeneratedMessage {
  factory ComposeHandoverResponse({
    Handover? handover,
  }) {
    final result = create();
    if (handover != null) result.handover = handover;
    return result;
  }

  ComposeHandoverResponse._();

  factory ComposeHandoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ComposeHandoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ComposeHandoverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Handover>(1, _omitFieldNames ? '' : 'handover',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeHandoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ComposeHandoverResponse copyWith(
          void Function(ComposeHandoverResponse) updates) =>
      super.copyWith((message) => updates(message as ComposeHandoverResponse))
          as ComposeHandoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComposeHandoverResponse create() => ComposeHandoverResponse._();
  @$core.override
  ComposeHandoverResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ComposeHandoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ComposeHandoverResponse>(create);
  static ComposeHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Handover get handover => $_getN(0);
  @$pb.TagNumber(1)
  set handover(Handover value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHandover() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandover() => $_clearField(1);
  @$pb.TagNumber(1)
  Handover ensureHandover() => $_ensure(0);
}

class AcknowledgeHandoverRequest extends $pb.GeneratedMessage {
  factory AcknowledgeHandoverRequest({
    $core.String? handoverId,
    $core.String? questions,
  }) {
    final result = create();
    if (handoverId != null) result.handoverId = handoverId;
    if (questions != null) result.questions = questions;
    return result;
  }

  AcknowledgeHandoverRequest._();

  factory AcknowledgeHandoverRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeHandoverRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeHandoverRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'handoverId')
    ..aOS(2, _omitFieldNames ? '' : 'questions')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeHandoverRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeHandoverRequest copyWith(
          void Function(AcknowledgeHandoverRequest) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeHandoverRequest))
          as AcknowledgeHandoverRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeHandoverRequest create() => AcknowledgeHandoverRequest._();
  @$core.override
  AcknowledgeHandoverRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeHandoverRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeHandoverRequest>(create);
  static AcknowledgeHandoverRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get handoverId => $_getSZ(0);
  @$pb.TagNumber(1)
  set handoverId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHandoverId() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandoverId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get questions => $_getSZ(1);
  @$pb.TagNumber(2)
  set questions($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasQuestions() => $_has(1);
  @$pb.TagNumber(2)
  void clearQuestions() => $_clearField(2);
}

class AcknowledgeHandoverResponse extends $pb.GeneratedMessage {
  factory AcknowledgeHandoverResponse({
    Handover? handover,
  }) {
    final result = create();
    if (handover != null) result.handover = handover;
    return result;
  }

  AcknowledgeHandoverResponse._();

  factory AcknowledgeHandoverResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcknowledgeHandoverResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcknowledgeHandoverResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Handover>(1, _omitFieldNames ? '' : 'handover',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeHandoverResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcknowledgeHandoverResponse copyWith(
          void Function(AcknowledgeHandoverResponse) updates) =>
      super.copyWith(
              (message) => updates(message as AcknowledgeHandoverResponse))
          as AcknowledgeHandoverResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeHandoverResponse create() =>
      AcknowledgeHandoverResponse._();
  @$core.override
  AcknowledgeHandoverResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeHandoverResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcknowledgeHandoverResponse>(create);
  static AcknowledgeHandoverResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Handover get handover => $_getN(0);
  @$pb.TagNumber(1)
  set handover(Handover value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHandover() => $_has(0);
  @$pb.TagNumber(1)
  void clearHandover() => $_clearField(1);
  @$pb.TagNumber(1)
  Handover ensureHandover() => $_ensure(0);
}

class ListHandoversRequest extends $pb.GeneratedMessage {
  factory ListHandoversRequest({
    $core.String? encounterId,
    $core.bool? unacknowledgedOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (unacknowledgedOnly != null)
      result.unacknowledgedOnly = unacknowledgedOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListHandoversRequest._();

  factory ListHandoversRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHandoversRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHandoversRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOB(2, _omitFieldNames ? '' : 'unacknowledgedOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHandoversRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHandoversRequest copyWith(void Function(ListHandoversRequest) updates) =>
      super.copyWith((message) => updates(message as ListHandoversRequest))
          as ListHandoversRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHandoversRequest create() => ListHandoversRequest._();
  @$core.override
  ListHandoversRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHandoversRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHandoversRequest>(create);
  static ListHandoversRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get unacknowledgedOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set unacknowledgedOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnacknowledgedOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnacknowledgedOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListHandoversResponse extends $pb.GeneratedMessage {
  factory ListHandoversResponse({
    $core.Iterable<Handover>? handovers,
  }) {
    final result = create();
    if (handovers != null) result.handovers.addAll(handovers);
    return result;
  }

  ListHandoversResponse._();

  factory ListHandoversResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListHandoversResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListHandoversResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Handover>(1, _omitFieldNames ? '' : 'handovers',
        subBuilder: Handover.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHandoversResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListHandoversResponse copyWith(
          void Function(ListHandoversResponse) updates) =>
      super.copyWith((message) => updates(message as ListHandoversResponse))
          as ListHandoversResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListHandoversResponse create() => ListHandoversResponse._();
  @$core.override
  ListHandoversResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListHandoversResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListHandoversResponse>(create);
  static ListHandoversResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Handover> get handovers => $_getList(0);
}

/// The clinician's order for a restraint (SRS-NUR-013).
///
/// Time-bounded by construction: expires_at is not optional.
class RestraintAuthorization extends $pb.GeneratedMessage {
  factory RestraintAuthorization({
    $core.String? authorizedBy,
    $0.Timestamp? authorizedAt,
    $0.Timestamp? expiresAt,
    $core.String? indication,
  }) {
    final result = create();
    if (authorizedBy != null) result.authorizedBy = authorizedBy;
    if (authorizedAt != null) result.authorizedAt = authorizedAt;
    if (expiresAt != null) result.expiresAt = expiresAt;
    if (indication != null) result.indication = indication;
    return result;
  }

  RestraintAuthorization._();

  factory RestraintAuthorization.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestraintAuthorization.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestraintAuthorization',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'authorizedBy')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'authorizedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'expiresAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'indication')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestraintAuthorization clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestraintAuthorization copyWith(
          void Function(RestraintAuthorization) updates) =>
      super.copyWith((message) => updates(message as RestraintAuthorization))
          as RestraintAuthorization;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestraintAuthorization create() => RestraintAuthorization._();
  @$core.override
  RestraintAuthorization createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestraintAuthorization getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestraintAuthorization>(create);
  static RestraintAuthorization? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get authorizedBy => $_getSZ(0);
  @$pb.TagNumber(1)
  set authorizedBy($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAuthorizedBy() => $_has(0);
  @$pb.TagNumber(1)
  void clearAuthorizedBy() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get authorizedAt => $_getN(1);
  @$pb.TagNumber(2)
  set authorizedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorizedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorizedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAuthorizedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get expiresAt => $_getN(2);
  @$pb.TagNumber(3)
  set expiresAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasExpiresAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpiresAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureExpiresAt() => $_ensure(2);

  /// The behaviour that justified it. "Agitated" is not an indication.
  @$pb.TagNumber(4)
  $core.String get indication => $_getSZ(3);
  @$pb.TagNumber(4)
  set indication($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIndication() => $_has(3);
  @$pb.TagNumber(4)
  void clearIndication() => $_clearField(4);
}

class RestraintCheck extends $pb.GeneratedMessage {
  factory RestraintCheck({
    $core.String? checkId,
    $0.Timestamp? observedAt,
    $core.String? observedBy,
    $core.String? findings,
    $core.String? continuedReason,
  }) {
    final result = create();
    if (checkId != null) result.checkId = checkId;
    if (observedAt != null) result.observedAt = observedAt;
    if (observedBy != null) result.observedBy = observedBy;
    if (findings != null) result.findings = findings;
    if (continuedReason != null) result.continuedReason = continuedReason;
    return result;
  }

  RestraintCheck._();

  factory RestraintCheck.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestraintCheck.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestraintCheck',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'checkId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'observedBy')
    ..aOS(4, _omitFieldNames ? '' : 'findings')
    ..aOS(5, _omitFieldNames ? '' : 'continuedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestraintCheck clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestraintCheck copyWith(void Function(RestraintCheck) updates) =>
      super.copyWith((message) => updates(message as RestraintCheck))
          as RestraintCheck;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestraintCheck create() => RestraintCheck._();
  @$core.override
  RestraintCheck createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestraintCheck getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestraintCheck>(create);
  static RestraintCheck? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get checkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set checkId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCheckId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCheckId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get observedAt => $_getN(1);
  @$pb.TagNumber(2)
  set observedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasObservedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureObservedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get observedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set observedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasObservedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearObservedBy() => $_clearField(3);

  /// Circulation, skin integrity, hydration, toileting and behaviour.
  @$pb.TagNumber(4)
  $core.String get findings => $_getSZ(3);
  @$pb.TagNumber(4)
  set findings($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFindings() => $_has(3);
  @$pb.TagNumber(4)
  void clearFindings() => $_clearField(4);

  /// A check that never asks whether the restraint is still needed keeps
  /// patients restrained.
  @$pb.TagNumber(5)
  $core.String get continuedReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set continuedReason($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasContinuedReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearContinuedReason() => $_clearField(5);
}

/// One episode of restraint (SRS-NUR-013).
class Restraint extends $pb.GeneratedMessage {
  factory Restraint({
    $core.String? restraintId,
    $core.String? patientId,
    $core.String? encounterId,
    RestraintKind? kind,
    $core.String? description,
    RestraintAuthorization? authorization,
    $core.Iterable<RestraintAuthorization>? renewals,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $fixnum.Int64? monitorEverySeconds,
    $core.Iterable<RestraintCheck>? monitoring,
    $0.Timestamp? discontinuedAt,
    $core.String? discontinuedBy,
    $core.String? discontinuedReason,
    $core.bool? authorizationExpired,
    $core.bool? monitoringOverdue,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (restraintId != null) result.restraintId = restraintId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (description != null) result.description = description;
    if (authorization != null) result.authorization = authorization;
    if (renewals != null) result.renewals.addAll(renewals);
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (monitorEverySeconds != null)
      result.monitorEverySeconds = monitorEverySeconds;
    if (monitoring != null) result.monitoring.addAll(monitoring);
    if (discontinuedAt != null) result.discontinuedAt = discontinuedAt;
    if (discontinuedBy != null) result.discontinuedBy = discontinuedBy;
    if (discontinuedReason != null)
      result.discontinuedReason = discontinuedReason;
    if (authorizationExpired != null)
      result.authorizationExpired = authorizationExpired;
    if (monitoringOverdue != null) result.monitoringOverdue = monitoringOverdue;
    if (version != null) result.version = version;
    return result;
  }

  Restraint._();

  factory Restraint.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Restraint.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Restraint',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'restraintId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aE<RestraintKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: RestraintKind.values)
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..aOM<RestraintAuthorization>(6, _omitFieldNames ? '' : 'authorization',
        subBuilder: RestraintAuthorization.create)
    ..pPM<RestraintAuthorization>(7, _omitFieldNames ? '' : 'renewals',
        subBuilder: RestraintAuthorization.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'startedBy')
    ..aInt64(10, _omitFieldNames ? '' : 'monitorEverySeconds')
    ..pPM<RestraintCheck>(11, _omitFieldNames ? '' : 'monitoring',
        subBuilder: RestraintCheck.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'discontinuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'discontinuedBy')
    ..aOS(14, _omitFieldNames ? '' : 'discontinuedReason')
    ..aOB(15, _omitFieldNames ? '' : 'authorizationExpired')
    ..aOB(16, _omitFieldNames ? '' : 'monitoringOverdue')
    ..aInt64(17, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Restraint clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Restraint copyWith(void Function(Restraint) updates) =>
      super.copyWith((message) => updates(message as Restraint)) as Restraint;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Restraint create() => Restraint._();
  @$core.override
  Restraint createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Restraint getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Restraint>(create);
  static Restraint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get restraintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set restraintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraintId() => $_clearField(1);

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
  RestraintKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(RestraintKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(4);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(4);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  RestraintAuthorization get authorization => $_getN(5);
  @$pb.TagNumber(6)
  set authorization(RestraintAuthorization value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasAuthorization() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuthorization() => $_clearField(6);
  @$pb.TagNumber(6)
  RestraintAuthorization ensureAuthorization() => $_ensure(5);

  /// Appended, because how many times a restraint has been renewed is the
  /// number a review board asks for.
  @$pb.TagNumber(7)
  $pb.PbList<RestraintAuthorization> get renewals => $_getList(6);

  @$pb.TagNumber(8)
  $0.Timestamp get startedAt => $_getN(7);
  @$pb.TagNumber(8)
  set startedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get startedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set startedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStartedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearStartedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get monitorEverySeconds => $_getI64(9);
  @$pb.TagNumber(10)
  set monitorEverySeconds($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasMonitorEverySeconds() => $_has(9);
  @$pb.TagNumber(10)
  void clearMonitorEverySeconds() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<RestraintCheck> get monitoring => $_getList(10);

  @$pb.TagNumber(12)
  $0.Timestamp get discontinuedAt => $_getN(11);
  @$pb.TagNumber(12)
  set discontinuedAt($0.Timestamp value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasDiscontinuedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDiscontinuedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDiscontinuedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $core.String get discontinuedBy => $_getSZ(12);
  @$pb.TagNumber(13)
  set discontinuedBy($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasDiscontinuedBy() => $_has(12);
  @$pb.TagNumber(13)
  void clearDiscontinuedBy() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get discontinuedReason => $_getSZ(13);
  @$pb.TagNumber(14)
  set discontinuedReason($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasDiscontinuedReason() => $_has(13);
  @$pb.TagNumber(14)
  void clearDiscontinuedReason() => $_clearField(14);

  /// An expired authorization does not make the restraint inactive: the patient
  /// is still restrained, and what has lapsed is the permission.
  @$pb.TagNumber(15)
  $core.bool get authorizationExpired => $_getBF(14);
  @$pb.TagNumber(15)
  set authorizationExpired($core.bool value) => $_setBool(14, value);
  @$pb.TagNumber(15)
  $core.bool hasAuthorizationExpired() => $_has(14);
  @$pb.TagNumber(15)
  void clearAuthorizationExpired() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get monitoringOverdue => $_getBF(15);
  @$pb.TagNumber(16)
  set monitoringOverdue($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasMonitoringOverdue() => $_has(15);
  @$pb.TagNumber(16)
  void clearMonitoringOverdue() => $_clearField(16);

  @$pb.TagNumber(17)
  $fixnum.Int64 get version => $_getI64(16);
  @$pb.TagNumber(17)
  set version($fixnum.Int64 value) => $_setInt64(16, value);
  @$pb.TagNumber(17)
  $core.bool hasVersion() => $_has(16);
  @$pb.TagNumber(17)
  void clearVersion() => $_clearField(17);
}

class ApplyRestraintRequest extends $pb.GeneratedMessage {
  factory ApplyRestraintRequest({
    $core.String? patientId,
    $core.String? encounterId,
    RestraintKind? kind,
    $core.String? description,
    RestraintAuthorization? authorization,
    $0.Timestamp? startedAt,
    $fixnum.Int64? monitorEverySeconds,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (kind != null) result.kind = kind;
    if (description != null) result.description = description;
    if (authorization != null) result.authorization = authorization;
    if (startedAt != null) result.startedAt = startedAt;
    if (monitorEverySeconds != null)
      result.monitorEverySeconds = monitorEverySeconds;
    return result;
  }

  ApplyRestraintRequest._();

  factory ApplyRestraintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyRestraintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyRestraintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aE<RestraintKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: RestraintKind.values)
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOM<RestraintAuthorization>(5, _omitFieldNames ? '' : 'authorization',
        subBuilder: RestraintAuthorization.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aInt64(7, _omitFieldNames ? '' : 'monitorEverySeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRestraintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRestraintRequest copyWith(
          void Function(ApplyRestraintRequest) updates) =>
      super.copyWith((message) => updates(message as ApplyRestraintRequest))
          as ApplyRestraintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyRestraintRequest create() => ApplyRestraintRequest._();
  @$core.override
  ApplyRestraintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyRestraintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyRestraintRequest>(create);
  static ApplyRestraintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  RestraintKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(RestraintKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  RestraintAuthorization get authorization => $_getN(4);
  @$pb.TagNumber(5)
  set authorization(RestraintAuthorization value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasAuthorization() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthorization() => $_clearField(5);
  @$pb.TagNumber(5)
  RestraintAuthorization ensureAuthorization() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get startedAt => $_getN(5);
  @$pb.TagNumber(6)
  set startedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStartedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get monitorEverySeconds => $_getI64(6);
  @$pb.TagNumber(7)
  set monitorEverySeconds($fixnum.Int64 value) => $_setInt64(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMonitorEverySeconds() => $_has(6);
  @$pb.TagNumber(7)
  void clearMonitorEverySeconds() => $_clearField(7);
}

class ApplyRestraintResponse extends $pb.GeneratedMessage {
  factory ApplyRestraintResponse({
    Restraint? restraint,
  }) {
    final result = create();
    if (restraint != null) result.restraint = restraint;
    return result;
  }

  ApplyRestraintResponse._();

  factory ApplyRestraintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ApplyRestraintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ApplyRestraintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Restraint>(1, _omitFieldNames ? '' : 'restraint',
        subBuilder: Restraint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRestraintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ApplyRestraintResponse copyWith(
          void Function(ApplyRestraintResponse) updates) =>
      super.copyWith((message) => updates(message as ApplyRestraintResponse))
          as ApplyRestraintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApplyRestraintResponse create() => ApplyRestraintResponse._();
  @$core.override
  ApplyRestraintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ApplyRestraintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ApplyRestraintResponse>(create);
  static ApplyRestraintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Restraint get restraint => $_getN(0);
  @$pb.TagNumber(1)
  set restraint(Restraint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraint() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraint() => $_clearField(1);
  @$pb.TagNumber(1)
  Restraint ensureRestraint() => $_ensure(0);
}

class RenewRestraintRequest extends $pb.GeneratedMessage {
  factory RenewRestraintRequest({
    $core.String? restraintId,
    RestraintAuthorization? authorization,
  }) {
    final result = create();
    if (restraintId != null) result.restraintId = restraintId;
    if (authorization != null) result.authorization = authorization;
    return result;
  }

  RenewRestraintRequest._();

  factory RenewRestraintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenewRestraintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenewRestraintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'restraintId')
    ..aOM<RestraintAuthorization>(2, _omitFieldNames ? '' : 'authorization',
        subBuilder: RestraintAuthorization.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenewRestraintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenewRestraintRequest copyWith(
          void Function(RenewRestraintRequest) updates) =>
      super.copyWith((message) => updates(message as RenewRestraintRequest))
          as RenewRestraintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenewRestraintRequest create() => RenewRestraintRequest._();
  @$core.override
  RenewRestraintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenewRestraintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenewRestraintRequest>(create);
  static RenewRestraintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get restraintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set restraintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraintId() => $_clearField(1);

  @$pb.TagNumber(2)
  RestraintAuthorization get authorization => $_getN(1);
  @$pb.TagNumber(2)
  set authorization(RestraintAuthorization value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAuthorization() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthorization() => $_clearField(2);
  @$pb.TagNumber(2)
  RestraintAuthorization ensureAuthorization() => $_ensure(1);
}

class RenewRestraintResponse extends $pb.GeneratedMessage {
  factory RenewRestraintResponse({
    Restraint? restraint,
  }) {
    final result = create();
    if (restraint != null) result.restraint = restraint;
    return result;
  }

  RenewRestraintResponse._();

  factory RenewRestraintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RenewRestraintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RenewRestraintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Restraint>(1, _omitFieldNames ? '' : 'restraint',
        subBuilder: Restraint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenewRestraintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RenewRestraintResponse copyWith(
          void Function(RenewRestraintResponse) updates) =>
      super.copyWith((message) => updates(message as RenewRestraintResponse))
          as RenewRestraintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RenewRestraintResponse create() => RenewRestraintResponse._();
  @$core.override
  RenewRestraintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RenewRestraintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RenewRestraintResponse>(create);
  static RenewRestraintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Restraint get restraint => $_getN(0);
  @$pb.TagNumber(1)
  set restraint(Restraint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraint() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraint() => $_clearField(1);
  @$pb.TagNumber(1)
  Restraint ensureRestraint() => $_ensure(0);
}

class CheckRestraintRequest extends $pb.GeneratedMessage {
  factory CheckRestraintRequest({
    $core.String? restraintId,
    $0.Timestamp? observedAt,
    $core.String? findings,
    $core.String? continuedReason,
  }) {
    final result = create();
    if (restraintId != null) result.restraintId = restraintId;
    if (observedAt != null) result.observedAt = observedAt;
    if (findings != null) result.findings = findings;
    if (continuedReason != null) result.continuedReason = continuedReason;
    return result;
  }

  CheckRestraintRequest._();

  factory CheckRestraintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRestraintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRestraintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'restraintId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'findings')
    ..aOS(4, _omitFieldNames ? '' : 'continuedReason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRestraintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRestraintRequest copyWith(
          void Function(CheckRestraintRequest) updates) =>
      super.copyWith((message) => updates(message as CheckRestraintRequest))
          as CheckRestraintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRestraintRequest create() => CheckRestraintRequest._();
  @$core.override
  CheckRestraintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRestraintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRestraintRequest>(create);
  static CheckRestraintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get restraintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set restraintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get observedAt => $_getN(1);
  @$pb.TagNumber(2)
  set observedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasObservedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureObservedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get findings => $_getSZ(2);
  @$pb.TagNumber(3)
  set findings($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFindings() => $_has(2);
  @$pb.TagNumber(3)
  void clearFindings() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get continuedReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set continuedReason($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContinuedReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearContinuedReason() => $_clearField(4);
}

class CheckRestraintResponse extends $pb.GeneratedMessage {
  factory CheckRestraintResponse() => create();

  CheckRestraintResponse._();

  factory CheckRestraintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CheckRestraintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CheckRestraintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRestraintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CheckRestraintResponse copyWith(
          void Function(CheckRestraintResponse) updates) =>
      super.copyWith((message) => updates(message as CheckRestraintResponse))
          as CheckRestraintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckRestraintResponse create() => CheckRestraintResponse._();
  @$core.override
  CheckRestraintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CheckRestraintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CheckRestraintResponse>(create);
  static CheckRestraintResponse? _defaultInstance;
}

class DiscontinueRestraintRequest extends $pb.GeneratedMessage {
  factory DiscontinueRestraintRequest({
    $core.String? restraintId,
    $0.Timestamp? discontinuedAt,
    $core.String? reason,
  }) {
    final result = create();
    if (restraintId != null) result.restraintId = restraintId;
    if (discontinuedAt != null) result.discontinuedAt = discontinuedAt;
    if (reason != null) result.reason = reason;
    return result;
  }

  DiscontinueRestraintRequest._();

  factory DiscontinueRestraintRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscontinueRestraintRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscontinueRestraintRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'restraintId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'discontinuedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueRestraintRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueRestraintRequest copyWith(
          void Function(DiscontinueRestraintRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DiscontinueRestraintRequest))
          as DiscontinueRestraintRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscontinueRestraintRequest create() =>
      DiscontinueRestraintRequest._();
  @$core.override
  DiscontinueRestraintRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscontinueRestraintRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscontinueRestraintRequest>(create);
  static DiscontinueRestraintRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get restraintId => $_getSZ(0);
  @$pb.TagNumber(1)
  set restraintId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraintId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraintId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get discontinuedAt => $_getN(1);
  @$pb.TagNumber(2)
  set discontinuedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDiscontinuedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearDiscontinuedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureDiscontinuedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class DiscontinueRestraintResponse extends $pb.GeneratedMessage {
  factory DiscontinueRestraintResponse({
    Restraint? restraint,
  }) {
    final result = create();
    if (restraint != null) result.restraint = restraint;
    return result;
  }

  DiscontinueRestraintResponse._();

  factory DiscontinueRestraintResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscontinueRestraintResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscontinueRestraintResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Restraint>(1, _omitFieldNames ? '' : 'restraint',
        subBuilder: Restraint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueRestraintResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscontinueRestraintResponse copyWith(
          void Function(DiscontinueRestraintResponse) updates) =>
      super.copyWith(
              (message) => updates(message as DiscontinueRestraintResponse))
          as DiscontinueRestraintResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscontinueRestraintResponse create() =>
      DiscontinueRestraintResponse._();
  @$core.override
  DiscontinueRestraintResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscontinueRestraintResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscontinueRestraintResponse>(create);
  static DiscontinueRestraintResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Restraint get restraint => $_getN(0);
  @$pb.TagNumber(1)
  set restraint(Restraint value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRestraint() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestraint() => $_clearField(1);
  @$pb.TagNumber(1)
  Restraint ensureRestraint() => $_ensure(0);
}

class ListRestraintsRequest extends $pb.GeneratedMessage {
  factory ListRestraintsRequest({
    $core.String? encounterId,
    $core.bool? activeOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListRestraintsRequest._();

  factory ListRestraintsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRestraintsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRestraintsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOB(2, _omitFieldNames ? '' : 'activeOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRestraintsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRestraintsRequest copyWith(
          void Function(ListRestraintsRequest) updates) =>
      super.copyWith((message) => updates(message as ListRestraintsRequest))
          as ListRestraintsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRestraintsRequest create() => ListRestraintsRequest._();
  @$core.override
  ListRestraintsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRestraintsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRestraintsRequest>(create);
  static ListRestraintsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get encounterId => $_getSZ(0);
  @$pb.TagNumber(1)
  set encounterId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEncounterId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEncounterId() => $_clearField(1);

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

class ListRestraintsResponse extends $pb.GeneratedMessage {
  factory ListRestraintsResponse({
    $core.Iterable<Restraint>? restraints,
  }) {
    final result = create();
    if (restraints != null) result.restraints.addAll(restraints);
    return result;
  }

  ListRestraintsResponse._();

  factory ListRestraintsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListRestraintsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListRestraintsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Restraint>(1, _omitFieldNames ? '' : 'restraints',
        subBuilder: Restraint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRestraintsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListRestraintsResponse copyWith(
          void Function(ListRestraintsResponse) updates) =>
      super.copyWith((message) => updates(message as ListRestraintsResponse))
          as ListRestraintsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRestraintsResponse create() => ListRestraintsResponse._();
  @$core.override
  ListRestraintsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListRestraintsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListRestraintsResponse>(create);
  static ListRestraintsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Restraint> get restraints => $_getList(0);
}

class GetRestraintAlertsRequest extends $pb.GeneratedMessage {
  factory GetRestraintAlertsRequest({
    $core.int? pageSize,
  }) {
    final result = create();
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetRestraintAlertsRequest._();

  factory GetRestraintAlertsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRestraintAlertsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRestraintAlertsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRestraintAlertsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRestraintAlertsRequest copyWith(
          void Function(GetRestraintAlertsRequest) updates) =>
      super.copyWith((message) => updates(message as GetRestraintAlertsRequest))
          as GetRestraintAlertsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRestraintAlertsRequest create() => GetRestraintAlertsRequest._();
  @$core.override
  GetRestraintAlertsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRestraintAlertsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRestraintAlertsRequest>(create);
  static GetRestraintAlertsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageSize => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageSize($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPageSize() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageSize() => $_clearField(1);
}

class GetRestraintAlertsResponse extends $pb.GeneratedMessage {
  factory GetRestraintAlertsResponse({
    $core.Iterable<Restraint>? restraints,
  }) {
    final result = create();
    if (restraints != null) result.restraints.addAll(restraints);
    return result;
  }

  GetRestraintAlertsResponse._();

  factory GetRestraintAlertsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetRestraintAlertsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetRestraintAlertsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<Restraint>(1, _omitFieldNames ? '' : 'restraints',
        subBuilder: Restraint.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRestraintAlertsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetRestraintAlertsResponse copyWith(
          void Function(GetRestraintAlertsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetRestraintAlertsResponse))
          as GetRestraintAlertsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRestraintAlertsResponse create() => GetRestraintAlertsResponse._();
  @$core.override
  GetRestraintAlertsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetRestraintAlertsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetRestraintAlertsResponse>(create);
  static GetRestraintAlertsResponse? _defaultInstance;

  /// Still-active restraints whose authorization has lapsed.
  @$pb.TagNumber(1)
  $pb.PbList<Restraint> get restraints => $_getList(0);
}

/// One set of monitoring observations (SRS-NUR-014).
@$core.Deprecated('This message is deprecated')
class TransfusionObservation extends $pb.GeneratedMessage {
  factory TransfusionObservation({
    $core.String? observationId,
    $0.Timestamp? observedAt,
    $core.String? observedBy,
    $core.double? temperatureC,
    $core.int? pulse,
    $core.int? systolicBp,
    $core.int? respiratoryRate,
    $core.bool? baseline,
    $core.String? notes,
  }) {
    final result = create();
    if (observationId != null) result.observationId = observationId;
    if (observedAt != null) result.observedAt = observedAt;
    if (observedBy != null) result.observedBy = observedBy;
    if (temperatureC != null) result.temperatureC = temperatureC;
    if (pulse != null) result.pulse = pulse;
    if (systolicBp != null) result.systolicBp = systolicBp;
    if (respiratoryRate != null) result.respiratoryRate = respiratoryRate;
    if (baseline != null) result.baseline = baseline;
    if (notes != null) result.notes = notes;
    return result;
  }

  TransfusionObservation._();

  factory TransfusionObservation.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransfusionObservation.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransfusionObservation',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'observationId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'observedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'observedBy')
    ..aD(4, _omitFieldNames ? '' : 'temperatureC')
    ..aI(5, _omitFieldNames ? '' : 'pulse')
    ..aI(6, _omitFieldNames ? '' : 'systolicBp')
    ..aI(7, _omitFieldNames ? '' : 'respiratoryRate')
    ..aOB(8, _omitFieldNames ? '' : 'baseline')
    ..aOS(9, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransfusionObservation clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransfusionObservation copyWith(
          void Function(TransfusionObservation) updates) =>
      super.copyWith((message) => updates(message as TransfusionObservation))
          as TransfusionObservation;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransfusionObservation create() => TransfusionObservation._();
  @$core.override
  TransfusionObservation createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransfusionObservation getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransfusionObservation>(create);
  static TransfusionObservation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get observationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set observationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get observedAt => $_getN(1);
  @$pb.TagNumber(2)
  set observedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasObservedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureObservedAt() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get observedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set observedBy($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasObservedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearObservedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get temperatureC => $_getN(3);
  @$pb.TagNumber(4)
  set temperatureC($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTemperatureC() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperatureC() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pulse => $_getIZ(4);
  @$pb.TagNumber(5)
  set pulse($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPulse() => $_has(4);
  @$pb.TagNumber(5)
  void clearPulse() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get systolicBp => $_getIZ(5);
  @$pb.TagNumber(6)
  set systolicBp($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSystolicBp() => $_has(5);
  @$pb.TagNumber(6)
  void clearSystolicBp() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get respiratoryRate => $_getIZ(6);
  @$pb.TagNumber(7)
  set respiratoryRate($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRespiratoryRate() => $_has(6);
  @$pb.TagNumber(7)
  void clearRespiratoryRate() => $_clearField(7);

  /// The pre-transfusion set, without which a temperature of 38.1 cannot be read
  /// as a rise.
  @$pb.TagNumber(8)
  $core.bool get baseline => $_getBF(7);
  @$pb.TagNumber(8)
  set baseline($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBaseline() => $_has(7);
  @$pb.TagNumber(8)
  void clearBaseline() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get notes => $_getSZ(8);
  @$pb.TagNumber(9)
  set notes($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasNotes() => $_has(8);
  @$pb.TagNumber(9)
  void clearNotes() => $_clearField(9);
}

@$core.Deprecated('This message is deprecated')
class TransfusionReaction extends $pb.GeneratedMessage {
  factory TransfusionReaction({
    $0.Timestamp? reportedAt,
    $core.String? reportedBy,
    $core.String? features,
    $core.String? actionTaken,
    $core.bool? unitReturned,
  }) {
    final result = create();
    if (reportedAt != null) result.reportedAt = reportedAt;
    if (reportedBy != null) result.reportedBy = reportedBy;
    if (features != null) result.features = features;
    if (actionTaken != null) result.actionTaken = actionTaken;
    if (unitReturned != null) result.unitReturned = unitReturned;
    return result;
  }

  TransfusionReaction._();

  factory TransfusionReaction.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransfusionReaction.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransfusionReaction',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'reportedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(2, _omitFieldNames ? '' : 'reportedBy')
    ..aOS(3, _omitFieldNames ? '' : 'features')
    ..aOS(4, _omitFieldNames ? '' : 'actionTaken')
    ..aOB(5, _omitFieldNames ? '' : 'unitReturned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransfusionReaction clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransfusionReaction copyWith(void Function(TransfusionReaction) updates) =>
      super.copyWith((message) => updates(message as TransfusionReaction))
          as TransfusionReaction;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransfusionReaction create() => TransfusionReaction._();
  @$core.override
  TransfusionReaction createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransfusionReaction getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransfusionReaction>(create);
  static TransfusionReaction? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get reportedAt => $_getN(0);
  @$pb.TagNumber(1)
  set reportedAt($0.Timestamp value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReportedAt() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportedAt() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureReportedAt() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get reportedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set reportedBy($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReportedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearReportedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get features => $_getSZ(2);
  @$pb.TagNumber(3)
  set features($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFeatures() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeatures() => $_clearField(3);

  /// The first action — stop, keep the line open — is the one that matters.
  @$pb.TagNumber(4)
  $core.String get actionTaken => $_getSZ(3);
  @$pb.TagNumber(4)
  set actionTaken($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasActionTaken() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionTaken() => $_clearField(4);

  /// The step that gets forgotten and the one the investigation needs.
  @$pb.TagNumber(5)
  $core.bool get unitReturned => $_getBF(4);
  @$pb.TagNumber(5)
  set unitReturned($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasUnitReturned() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitReturned() => $_clearField(5);
}

/// One blood-product episode (SRS-NUR-014).
@$core.Deprecated('This message is deprecated')
class Transfusion extends $pb.GeneratedMessage {
  factory Transfusion({
    $core.String? transfusionId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? unitNumber,
    Coding? product,
    $core.String? aboGroup,
    $core.String? rhd,
    $core.double? volumeMl,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $core.String? checkedBy,
    $core.Iterable<TransfusionObservation>? observations,
    TransfusionStatus? status,
    $0.Timestamp? endedAt,
    TransfusionReaction? reaction,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (transfusionId != null) result.transfusionId = transfusionId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (product != null) result.product = product;
    if (aboGroup != null) result.aboGroup = aboGroup;
    if (rhd != null) result.rhd = rhd;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (checkedBy != null) result.checkedBy = checkedBy;
    if (observations != null) result.observations.addAll(observations);
    if (status != null) result.status = status;
    if (endedAt != null) result.endedAt = endedAt;
    if (reaction != null) result.reaction = reaction;
    if (version != null) result.version = version;
    return result;
  }

  Transfusion._();

  factory Transfusion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Transfusion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Transfusion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transfusionId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'unitNumber')
    ..aOM<Coding>(5, _omitFieldNames ? '' : 'product',
        subBuilder: Coding.create)
    ..aOS(6, _omitFieldNames ? '' : 'aboGroup')
    ..aOS(7, _omitFieldNames ? '' : 'rhd')
    ..aD(8, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'startedBy')
    ..aOS(11, _omitFieldNames ? '' : 'checkedBy')
    ..pPM<TransfusionObservation>(12, _omitFieldNames ? '' : 'observations',
        subBuilder: TransfusionObservation.create)
    ..aE<TransfusionStatus>(13, _omitFieldNames ? '' : 'status',
        enumValues: TransfusionStatus.values)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<TransfusionReaction>(15, _omitFieldNames ? '' : 'reaction',
        subBuilder: TransfusionReaction.create)
    ..aInt64(16, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transfusion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Transfusion copyWith(void Function(Transfusion) updates) =>
      super.copyWith((message) => updates(message as Transfusion))
          as Transfusion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Transfusion create() => Transfusion._();
  @$core.override
  Transfusion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Transfusion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Transfusion>(create);
  static Transfusion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transfusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transfusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusionId() => $_clearField(1);

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

  /// The pack's own identifier, which links this to the blood bank and forward
  /// to a look-back investigation.
  @$pb.TagNumber(4)
  $core.String get unitNumber => $_getSZ(3);
  @$pb.TagNumber(4)
  set unitNumber($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitNumber() => $_clearField(4);

  @$pb.TagNumber(5)
  Coding get product => $_getN(4);
  @$pb.TagNumber(5)
  set product(Coding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasProduct() => $_has(4);
  @$pb.TagNumber(5)
  void clearProduct() => $_clearField(5);
  @$pb.TagNumber(5)
  Coding ensureProduct() => $_ensure(4);

  /// As issued, not as the patient's record says: what matters in a reaction
  /// investigation is what was hung.
  @$pb.TagNumber(6)
  $core.String get aboGroup => $_getSZ(5);
  @$pb.TagNumber(6)
  set aboGroup($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAboGroup() => $_has(5);
  @$pb.TagNumber(6)
  void clearAboGroup() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get rhd => $_getSZ(6);
  @$pb.TagNumber(7)
  set rhd($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasRhd() => $_has(6);
  @$pb.TagNumber(7)
  void clearRhd() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get volumeMl => $_getN(7);
  @$pb.TagNumber(8)
  set volumeMl($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(8)
  $core.bool hasVolumeMl() => $_has(7);
  @$pb.TagNumber(8)
  void clearVolumeMl() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get startedAt => $_getN(8);
  @$pb.TagNumber(9)
  set startedAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasStartedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearStartedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureStartedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get startedBy => $_getSZ(9);
  @$pb.TagNumber(10)
  set startedBy($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasStartedBy() => $_has(9);
  @$pb.TagNumber(10)
  void clearStartedBy() => $_clearField(10);

  /// The second person at the bedside check.
  @$pb.TagNumber(11)
  $core.String get checkedBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set checkedBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasCheckedBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearCheckedBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<TransfusionObservation> get observations => $_getList(11);

  @$pb.TagNumber(13)
  TransfusionStatus get status => $_getN(12);
  @$pb.TagNumber(13)
  set status(TransfusionStatus value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStatus() => $_has(12);
  @$pb.TagNumber(13)
  void clearStatus() => $_clearField(13);

  @$pb.TagNumber(14)
  $0.Timestamp get endedAt => $_getN(13);
  @$pb.TagNumber(14)
  set endedAt($0.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEndedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureEndedAt() => $_ensure(13);

  @$pb.TagNumber(15)
  TransfusionReaction get reaction => $_getN(14);
  @$pb.TagNumber(15)
  set reaction(TransfusionReaction value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasReaction() => $_has(14);
  @$pb.TagNumber(15)
  void clearReaction() => $_clearField(15);
  @$pb.TagNumber(15)
  TransfusionReaction ensureReaction() => $_ensure(14);

  @$pb.TagNumber(16)
  $fixnum.Int64 get version => $_getI64(15);
  @$pb.TagNumber(16)
  set version($fixnum.Int64 value) => $_setInt64(15, value);
  @$pb.TagNumber(16)
  $core.bool hasVersion() => $_has(15);
  @$pb.TagNumber(16)
  void clearVersion() => $_clearField(16);
}

@$core.Deprecated('This message is deprecated')
class StartTransfusionRequest extends $pb.GeneratedMessage {
  factory StartTransfusionRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? unitNumber,
    Coding? product,
    $core.String? aboGroup,
    $core.String? rhd,
    $core.double? volumeMl,
    $0.Timestamp? startedAt,
    $core.String? checkedBy,
    TransfusionObservation? baseline,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (unitNumber != null) result.unitNumber = unitNumber;
    if (product != null) result.product = product;
    if (aboGroup != null) result.aboGroup = aboGroup;
    if (rhd != null) result.rhd = rhd;
    if (volumeMl != null) result.volumeMl = volumeMl;
    if (startedAt != null) result.startedAt = startedAt;
    if (checkedBy != null) result.checkedBy = checkedBy;
    if (baseline != null) result.baseline = baseline;
    return result;
  }

  StartTransfusionRequest._();

  factory StartTransfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTransfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTransfusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'unitNumber')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'product',
        subBuilder: Coding.create)
    ..aOS(5, _omitFieldNames ? '' : 'aboGroup')
    ..aOS(6, _omitFieldNames ? '' : 'rhd')
    ..aD(7, _omitFieldNames ? '' : 'volumeMl')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'checkedBy')
    ..aOM<TransfusionObservation>(10, _omitFieldNames ? '' : 'baseline',
        subBuilder: TransfusionObservation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionRequest copyWith(
          void Function(StartTransfusionRequest) updates) =>
      super.copyWith((message) => updates(message as StartTransfusionRequest))
          as StartTransfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTransfusionRequest create() => StartTransfusionRequest._();
  @$core.override
  StartTransfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTransfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTransfusionRequest>(create);
  static StartTransfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get unitNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set unitNumber($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUnitNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnitNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  Coding get product => $_getN(3);
  @$pb.TagNumber(4)
  set product(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasProduct() => $_has(3);
  @$pb.TagNumber(4)
  void clearProduct() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureProduct() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get aboGroup => $_getSZ(4);
  @$pb.TagNumber(5)
  set aboGroup($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAboGroup() => $_has(4);
  @$pb.TagNumber(5)
  void clearAboGroup() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get rhd => $_getSZ(5);
  @$pb.TagNumber(6)
  set rhd($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasRhd() => $_has(5);
  @$pb.TagNumber(6)
  void clearRhd() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get volumeMl => $_getN(6);
  @$pb.TagNumber(7)
  set volumeMl($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasVolumeMl() => $_has(6);
  @$pb.TagNumber(7)
  void clearVolumeMl() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get startedAt => $_getN(7);
  @$pb.TagNumber(8)
  set startedAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasStartedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureStartedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get checkedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set checkedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCheckedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearCheckedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  TransfusionObservation get baseline => $_getN(9);
  @$pb.TagNumber(10)
  set baseline(TransfusionObservation value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasBaseline() => $_has(9);
  @$pb.TagNumber(10)
  void clearBaseline() => $_clearField(10);
  @$pb.TagNumber(10)
  TransfusionObservation ensureBaseline() => $_ensure(9);
}

@$core.Deprecated('This message is deprecated')
class StartTransfusionResponse extends $pb.GeneratedMessage {
  factory StartTransfusionResponse({
    Transfusion? transfusion,
  }) {
    final result = create();
    if (transfusion != null) result.transfusion = transfusion;
    return result;
  }

  StartTransfusionResponse._();

  factory StartTransfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StartTransfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StartTransfusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Transfusion>(1, _omitFieldNames ? '' : 'transfusion',
        subBuilder: Transfusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StartTransfusionResponse copyWith(
          void Function(StartTransfusionResponse) updates) =>
      super.copyWith((message) => updates(message as StartTransfusionResponse))
          as StartTransfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTransfusionResponse create() => StartTransfusionResponse._();
  @$core.override
  StartTransfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StartTransfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StartTransfusionResponse>(create);
  static StartTransfusionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfusion get transfusion => $_getN(0);
  @$pb.TagNumber(1)
  set transfusion(Transfusion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusion() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfusion ensureTransfusion() => $_ensure(0);
}

@$core.Deprecated('This message is deprecated')
class ObserveTransfusionRequest extends $pb.GeneratedMessage {
  factory ObserveTransfusionRequest({
    $core.String? transfusionId,
    TransfusionObservation? observation,
  }) {
    final result = create();
    if (transfusionId != null) result.transfusionId = transfusionId;
    if (observation != null) result.observation = observation;
    return result;
  }

  ObserveTransfusionRequest._();

  factory ObserveTransfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveTransfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveTransfusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transfusionId')
    ..aOM<TransfusionObservation>(2, _omitFieldNames ? '' : 'observation',
        subBuilder: TransfusionObservation.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveTransfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveTransfusionRequest copyWith(
          void Function(ObserveTransfusionRequest) updates) =>
      super.copyWith((message) => updates(message as ObserveTransfusionRequest))
          as ObserveTransfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveTransfusionRequest create() => ObserveTransfusionRequest._();
  @$core.override
  ObserveTransfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveTransfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveTransfusionRequest>(create);
  static ObserveTransfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transfusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transfusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusionId() => $_clearField(1);

  @$pb.TagNumber(2)
  TransfusionObservation get observation => $_getN(1);
  @$pb.TagNumber(2)
  set observation(TransfusionObservation value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasObservation() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservation() => $_clearField(2);
  @$pb.TagNumber(2)
  TransfusionObservation ensureObservation() => $_ensure(1);
}

@$core.Deprecated('This message is deprecated')
class ObserveTransfusionResponse extends $pb.GeneratedMessage {
  factory ObserveTransfusionResponse({
    Transfusion? transfusion,
  }) {
    final result = create();
    if (transfusion != null) result.transfusion = transfusion;
    return result;
  }

  ObserveTransfusionResponse._();

  factory ObserveTransfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObserveTransfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObserveTransfusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Transfusion>(1, _omitFieldNames ? '' : 'transfusion',
        subBuilder: Transfusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveTransfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObserveTransfusionResponse copyWith(
          void Function(ObserveTransfusionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as ObserveTransfusionResponse))
          as ObserveTransfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObserveTransfusionResponse create() => ObserveTransfusionResponse._();
  @$core.override
  ObserveTransfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObserveTransfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObserveTransfusionResponse>(create);
  static ObserveTransfusionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfusion get transfusion => $_getN(0);
  @$pb.TagNumber(1)
  set transfusion(Transfusion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusion() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfusion ensureTransfusion() => $_ensure(0);
}

/// Stopping and reporting are one operation, because they are one act at the
/// bedside and splitting them creates a window in which the system believes
/// blood is still running into a patient having a reaction.
@$core.Deprecated('This message is deprecated')
class ReportTransfusionReactionRequest extends $pb.GeneratedMessage {
  factory ReportTransfusionReactionRequest({
    $core.String? transfusionId,
    $core.String? features,
    $core.String? actionTaken,
    $core.bool? unitReturned,
  }) {
    final result = create();
    if (transfusionId != null) result.transfusionId = transfusionId;
    if (features != null) result.features = features;
    if (actionTaken != null) result.actionTaken = actionTaken;
    if (unitReturned != null) result.unitReturned = unitReturned;
    return result;
  }

  ReportTransfusionReactionRequest._();

  factory ReportTransfusionReactionRequest.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportTransfusionReactionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportTransfusionReactionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transfusionId')
    ..aOS(2, _omitFieldNames ? '' : 'features')
    ..aOS(3, _omitFieldNames ? '' : 'actionTaken')
    ..aOB(4, _omitFieldNames ? '' : 'unitReturned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportTransfusionReactionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportTransfusionReactionRequest copyWith(
          void Function(ReportTransfusionReactionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as ReportTransfusionReactionRequest))
          as ReportTransfusionReactionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportTransfusionReactionRequest create() =>
      ReportTransfusionReactionRequest._();
  @$core.override
  ReportTransfusionReactionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportTransfusionReactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportTransfusionReactionRequest>(
          create);
  static ReportTransfusionReactionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transfusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transfusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get features => $_getSZ(1);
  @$pb.TagNumber(2)
  set features($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFeatures() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeatures() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actionTaken => $_getSZ(2);
  @$pb.TagNumber(3)
  set actionTaken($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActionTaken() => $_has(2);
  @$pb.TagNumber(3)
  void clearActionTaken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get unitReturned => $_getBF(3);
  @$pb.TagNumber(4)
  set unitReturned($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasUnitReturned() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnitReturned() => $_clearField(4);
}

@$core.Deprecated('This message is deprecated')
class ReportTransfusionReactionResponse extends $pb.GeneratedMessage {
  factory ReportTransfusionReactionResponse({
    Transfusion? transfusion,
  }) {
    final result = create();
    if (transfusion != null) result.transfusion = transfusion;
    return result;
  }

  ReportTransfusionReactionResponse._();

  factory ReportTransfusionReactionResponse.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReportTransfusionReactionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReportTransfusionReactionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Transfusion>(1, _omitFieldNames ? '' : 'transfusion',
        subBuilder: Transfusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportTransfusionReactionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportTransfusionReactionResponse copyWith(
          void Function(ReportTransfusionReactionResponse) updates) =>
      super.copyWith((message) =>
              updates(message as ReportTransfusionReactionResponse))
          as ReportTransfusionReactionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportTransfusionReactionResponse create() =>
      ReportTransfusionReactionResponse._();
  @$core.override
  ReportTransfusionReactionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReportTransfusionReactionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReportTransfusionReactionResponse>(
          create);
  static ReportTransfusionReactionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfusion get transfusion => $_getN(0);
  @$pb.TagNumber(1)
  set transfusion(Transfusion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusion() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfusion ensureTransfusion() => $_ensure(0);
}

@$core.Deprecated('This message is deprecated')
class CompleteTransfusionRequest extends $pb.GeneratedMessage {
  factory CompleteTransfusionRequest({
    $core.String? transfusionId,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (transfusionId != null) result.transfusionId = transfusionId;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  CompleteTransfusionRequest._();

  factory CompleteTransfusionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteTransfusionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteTransfusionRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'transfusionId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTransfusionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTransfusionRequest copyWith(
          void Function(CompleteTransfusionRequest) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteTransfusionRequest))
          as CompleteTransfusionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteTransfusionRequest create() => CompleteTransfusionRequest._();
  @$core.override
  CompleteTransfusionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteTransfusionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteTransfusionRequest>(create);
  static CompleteTransfusionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get transfusionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set transfusionId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get endedAt => $_getN(1);
  @$pb.TagNumber(2)
  set endedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEndedAt() => $_ensure(1);
}

@$core.Deprecated('This message is deprecated')
class CompleteTransfusionResponse extends $pb.GeneratedMessage {
  factory CompleteTransfusionResponse({
    Transfusion? transfusion,
  }) {
    final result = create();
    if (transfusion != null) result.transfusion = transfusion;
    return result;
  }

  CompleteTransfusionResponse._();

  factory CompleteTransfusionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CompleteTransfusionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CompleteTransfusionResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<Transfusion>(1, _omitFieldNames ? '' : 'transfusion',
        subBuilder: Transfusion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTransfusionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CompleteTransfusionResponse copyWith(
          void Function(CompleteTransfusionResponse) updates) =>
      super.copyWith(
              (message) => updates(message as CompleteTransfusionResponse))
          as CompleteTransfusionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompleteTransfusionResponse create() =>
      CompleteTransfusionResponse._();
  @$core.override
  CompleteTransfusionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CompleteTransfusionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CompleteTransfusionResponse>(create);
  static CompleteTransfusionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Transfusion get transfusion => $_getN(0);
  @$pb.TagNumber(1)
  set transfusion(Transfusion value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTransfusion() => $_has(0);
  @$pb.TagNumber(1)
  void clearTransfusion() => $_clearField(1);
  @$pb.TagNumber(1)
  Transfusion ensureTransfusion() => $_ensure(0);
}

/// A photograph of a wound is a photograph of a patient (SRS-NUR-012).
class WoundImage extends $pb.GeneratedMessage {
  factory WoundImage({
    $core.String? imageId,
    $core.String? consentId,
    $core.String? storageKey,
    $core.String? contentType,
    $0.Timestamp? capturedAt,
    $core.String? capturedBy,
    $core.int? sequence,
  }) {
    final result = create();
    if (imageId != null) result.imageId = imageId;
    if (consentId != null) result.consentId = consentId;
    if (storageKey != null) result.storageKey = storageKey;
    if (contentType != null) result.contentType = contentType;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (capturedBy != null) result.capturedBy = capturedBy;
    if (sequence != null) result.sequence = sequence;
    return result;
  }

  WoundImage._();

  factory WoundImage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WoundImage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WoundImage',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'imageId')
    ..aOS(2, _omitFieldNames ? '' : 'consentId')
    ..aOS(3, _omitFieldNames ? '' : 'storageKey')
    ..aOS(4, _omitFieldNames ? '' : 'contentType')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'capturedBy')
    ..aI(7, _omitFieldNames ? '' : 'sequence')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WoundImage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WoundImage copyWith(void Function(WoundImage) updates) =>
      super.copyWith((message) => updates(message as WoundImage)) as WoundImage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WoundImage create() => WoundImage._();
  @$core.override
  WoundImage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WoundImage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WoundImage>(create);
  static WoundImage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get imageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set imageId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasImageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearImageId() => $_clearField(1);

  /// Points at the clinical consent covering photography. Not a boolean: a
  /// boolean cannot be checked against a consent that was later withdrawn.
  @$pb.TagNumber(2)
  $core.String get consentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set consentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConsentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsentId() => $_clearField(2);

  /// Addresses the bytes. The bytes never travel through this contract.
  @$pb.TagNumber(3)
  $core.String get storageKey => $_getSZ(2);
  @$pb.TagNumber(3)
  set storageKey($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStorageKey() => $_has(2);
  @$pb.TagNumber(3)
  void clearStorageKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get capturedAt => $_getN(4);
  @$pb.TagNumber(5)
  set capturedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCapturedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCapturedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCapturedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get capturedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set capturedBy($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasCapturedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearCapturedBy() => $_clearField(6);

  /// A series of images is the evidence of healing, so an image is added and
  /// never replaced.
  @$pb.TagNumber(7)
  $core.int get sequence => $_getIZ(6);
  @$pb.TagNumber(7)
  set sequence($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasSequence() => $_has(6);
  @$pb.TagNumber(7)
  void clearSequence() => $_clearField(7);
}

/// One assessment of a wound or pressure area (SRS-NUR-012).
class WoundAssessment extends $pb.GeneratedMessage {
  factory WoundAssessment({
    $core.String? woundAssessmentId,
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? woundId,
    $core.String? location,
    Coding? bodyMapCode,
    Laterality? laterality,
    WoundKind? kind,
    $core.String? stage,
    $core.double? lengthMm,
    $core.double? widthMm,
    $core.double? depthMm,
    $core.String? appearance,
    $core.String? exudate,
    $core.String? surroundingSkin,
    $core.int? painScore,
    $core.bool? painScoreRecorded,
    $core.Iterable<WoundImage>? images,
    $core.double? areaMm2,
    $0.Timestamp? assessedAt,
    $0.Timestamp? recordedAt,
    $core.String? assessedBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (woundAssessmentId != null) result.woundAssessmentId = woundAssessmentId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (woundId != null) result.woundId = woundId;
    if (location != null) result.location = location;
    if (bodyMapCode != null) result.bodyMapCode = bodyMapCode;
    if (laterality != null) result.laterality = laterality;
    if (kind != null) result.kind = kind;
    if (stage != null) result.stage = stage;
    if (lengthMm != null) result.lengthMm = lengthMm;
    if (widthMm != null) result.widthMm = widthMm;
    if (depthMm != null) result.depthMm = depthMm;
    if (appearance != null) result.appearance = appearance;
    if (exudate != null) result.exudate = exudate;
    if (surroundingSkin != null) result.surroundingSkin = surroundingSkin;
    if (painScore != null) result.painScore = painScore;
    if (painScoreRecorded != null) result.painScoreRecorded = painScoreRecorded;
    if (images != null) result.images.addAll(images);
    if (areaMm2 != null) result.areaMm2 = areaMm2;
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (recordedAt != null) result.recordedAt = recordedAt;
    if (assessedBy != null) result.assessedBy = assessedBy;
    if (version != null) result.version = version;
    return result;
  }

  WoundAssessment._();

  factory WoundAssessment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WoundAssessment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WoundAssessment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'woundAssessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOS(4, _omitFieldNames ? '' : 'woundId')
    ..aOS(5, _omitFieldNames ? '' : 'location')
    ..aOM<Coding>(6, _omitFieldNames ? '' : 'bodyMapCode',
        subBuilder: Coding.create)
    ..aE<Laterality>(7, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aE<WoundKind>(8, _omitFieldNames ? '' : 'kind',
        enumValues: WoundKind.values)
    ..aOS(9, _omitFieldNames ? '' : 'stage')
    ..aD(10, _omitFieldNames ? '' : 'lengthMm')
    ..aD(11, _omitFieldNames ? '' : 'widthMm')
    ..aD(12, _omitFieldNames ? '' : 'depthMm')
    ..aOS(13, _omitFieldNames ? '' : 'appearance')
    ..aOS(14, _omitFieldNames ? '' : 'exudate')
    ..aOS(15, _omitFieldNames ? '' : 'surroundingSkin')
    ..aI(16, _omitFieldNames ? '' : 'painScore')
    ..aOB(17, _omitFieldNames ? '' : 'painScoreRecorded')
    ..pPM<WoundImage>(18, _omitFieldNames ? '' : 'images',
        subBuilder: WoundImage.create)
    ..aD(19, _omitFieldNames ? '' : 'areaMm2')
    ..aOM<$0.Timestamp>(20, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(21, _omitFieldNames ? '' : 'recordedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(22, _omitFieldNames ? '' : 'assessedBy')
    ..aInt64(23, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WoundAssessment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WoundAssessment copyWith(void Function(WoundAssessment) updates) =>
      super.copyWith((message) => updates(message as WoundAssessment))
          as WoundAssessment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WoundAssessment create() => WoundAssessment._();
  @$core.override
  WoundAssessment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WoundAssessment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WoundAssessment>(create);
  static WoundAssessment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get woundAssessmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set woundAssessmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWoundAssessmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWoundAssessmentId() => $_clearField(1);

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

  /// Groups the assessments of one wound over time.
  @$pb.TagNumber(4)
  $core.String get woundId => $_getSZ(3);
  @$pb.TagNumber(4)
  set woundId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasWoundId() => $_has(3);
  @$pb.TagNumber(4)
  void clearWoundId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get location => $_getSZ(4);
  @$pb.TagNumber(5)
  set location($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLocation() => $_has(4);
  @$pb.TagNumber(5)
  void clearLocation() => $_clearField(5);

  @$pb.TagNumber(6)
  Coding get bodyMapCode => $_getN(5);
  @$pb.TagNumber(6)
  set bodyMapCode(Coding value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasBodyMapCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearBodyMapCode() => $_clearField(6);
  @$pb.TagNumber(6)
  Coding ensureBodyMapCode() => $_ensure(5);

  @$pb.TagNumber(7)
  Laterality get laterality => $_getN(6);
  @$pb.TagNumber(7)
  set laterality(Laterality value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLaterality() => $_has(6);
  @$pb.TagNumber(7)
  void clearLaterality() => $_clearField(7);

  @$pb.TagNumber(8)
  WoundKind get kind => $_getN(7);
  @$pb.TagNumber(8)
  set kind(WoundKind value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasKind() => $_has(7);
  @$pb.TagNumber(8)
  void clearKind() => $_clearField(8);

  /// Required for a pressure injury: one charted without a stage is one nobody
  /// reports.
  @$pb.TagNumber(9)
  $core.String get stage => $_getSZ(8);
  @$pb.TagNumber(9)
  set stage($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasStage() => $_has(8);
  @$pb.TagNumber(9)
  void clearStage() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get lengthMm => $_getN(9);
  @$pb.TagNumber(10)
  set lengthMm($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasLengthMm() => $_has(9);
  @$pb.TagNumber(10)
  void clearLengthMm() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get widthMm => $_getN(10);
  @$pb.TagNumber(11)
  set widthMm($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasWidthMm() => $_has(10);
  @$pb.TagNumber(11)
  void clearWidthMm() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get depthMm => $_getN(11);
  @$pb.TagNumber(12)
  set depthMm($core.double value) => $_setDouble(11, value);
  @$pb.TagNumber(12)
  $core.bool hasDepthMm() => $_has(11);
  @$pb.TagNumber(12)
  void clearDepthMm() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get appearance => $_getSZ(12);
  @$pb.TagNumber(13)
  set appearance($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasAppearance() => $_has(12);
  @$pb.TagNumber(13)
  void clearAppearance() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get exudate => $_getSZ(13);
  @$pb.TagNumber(14)
  set exudate($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasExudate() => $_has(13);
  @$pb.TagNumber(14)
  void clearExudate() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get surroundingSkin => $_getSZ(14);
  @$pb.TagNumber(15)
  set surroundingSkin($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasSurroundingSkin() => $_has(14);
  @$pb.TagNumber(15)
  void clearSurroundingSkin() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.int get painScore => $_getIZ(15);
  @$pb.TagNumber(16)
  set painScore($core.int value) => $_setSignedInt32(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPainScore() => $_has(15);
  @$pb.TagNumber(16)
  void clearPainScore() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.bool get painScoreRecorded => $_getBF(16);
  @$pb.TagNumber(17)
  set painScoreRecorded($core.bool value) => $_setBool(16, value);
  @$pb.TagNumber(17)
  $core.bool hasPainScoreRecorded() => $_has(16);
  @$pb.TagNumber(17)
  void clearPainScoreRecorded() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<WoundImage> get images => $_getList(17);

  @$pb.TagNumber(19)
  $core.double get areaMm2 => $_getN(18);
  @$pb.TagNumber(19)
  set areaMm2($core.double value) => $_setDouble(18, value);
  @$pb.TagNumber(19)
  $core.bool hasAreaMm2() => $_has(18);
  @$pb.TagNumber(19)
  void clearAreaMm2() => $_clearField(19);

  @$pb.TagNumber(20)
  $0.Timestamp get assessedAt => $_getN(19);
  @$pb.TagNumber(20)
  set assessedAt($0.Timestamp value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasAssessedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearAssessedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.Timestamp ensureAssessedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $0.Timestamp get recordedAt => $_getN(20);
  @$pb.TagNumber(21)
  set recordedAt($0.Timestamp value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasRecordedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearRecordedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.Timestamp ensureRecordedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $core.String get assessedBy => $_getSZ(21);
  @$pb.TagNumber(22)
  set assessedBy($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasAssessedBy() => $_has(21);
  @$pb.TagNumber(22)
  void clearAssessedBy() => $_clearField(22);

  @$pb.TagNumber(23)
  $fixnum.Int64 get version => $_getI64(22);
  @$pb.TagNumber(23)
  set version($fixnum.Int64 value) => $_setInt64(22, value);
  @$pb.TagNumber(23)
  $core.bool hasVersion() => $_has(22);
  @$pb.TagNumber(23)
  void clearVersion() => $_clearField(23);
}

class AssessWoundRequest extends $pb.GeneratedMessage {
  factory AssessWoundRequest({
    $core.String? patientId,
    $core.String? encounterId,
    $core.String? woundId,
    $core.String? location,
    Coding? bodyMapCode,
    Laterality? laterality,
    WoundKind? kind,
    $core.String? stage,
    $core.double? lengthMm,
    $core.double? widthMm,
    $core.double? depthMm,
    $core.String? appearance,
    $core.String? exudate,
    $core.String? surroundingSkin,
    $core.int? painScore,
    $core.bool? painScoreRecorded,
    $0.Timestamp? assessedAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (woundId != null) result.woundId = woundId;
    if (location != null) result.location = location;
    if (bodyMapCode != null) result.bodyMapCode = bodyMapCode;
    if (laterality != null) result.laterality = laterality;
    if (kind != null) result.kind = kind;
    if (stage != null) result.stage = stage;
    if (lengthMm != null) result.lengthMm = lengthMm;
    if (widthMm != null) result.widthMm = widthMm;
    if (depthMm != null) result.depthMm = depthMm;
    if (appearance != null) result.appearance = appearance;
    if (exudate != null) result.exudate = exudate;
    if (surroundingSkin != null) result.surroundingSkin = surroundingSkin;
    if (painScore != null) result.painScore = painScore;
    if (painScoreRecorded != null) result.painScoreRecorded = painScoreRecorded;
    if (assessedAt != null) result.assessedAt = assessedAt;
    return result;
  }

  AssessWoundRequest._();

  factory AssessWoundRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssessWoundRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssessWoundRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOS(3, _omitFieldNames ? '' : 'woundId')
    ..aOS(4, _omitFieldNames ? '' : 'location')
    ..aOM<Coding>(5, _omitFieldNames ? '' : 'bodyMapCode',
        subBuilder: Coding.create)
    ..aE<Laterality>(6, _omitFieldNames ? '' : 'laterality',
        enumValues: Laterality.values)
    ..aE<WoundKind>(7, _omitFieldNames ? '' : 'kind',
        enumValues: WoundKind.values)
    ..aOS(8, _omitFieldNames ? '' : 'stage')
    ..aD(9, _omitFieldNames ? '' : 'lengthMm')
    ..aD(10, _omitFieldNames ? '' : 'widthMm')
    ..aD(11, _omitFieldNames ? '' : 'depthMm')
    ..aOS(12, _omitFieldNames ? '' : 'appearance')
    ..aOS(13, _omitFieldNames ? '' : 'exudate')
    ..aOS(14, _omitFieldNames ? '' : 'surroundingSkin')
    ..aI(15, _omitFieldNames ? '' : 'painScore')
    ..aOB(16, _omitFieldNames ? '' : 'painScoreRecorded')
    ..aOM<$0.Timestamp>(17, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessWoundRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessWoundRequest copyWith(void Function(AssessWoundRequest) updates) =>
      super.copyWith((message) => updates(message as AssessWoundRequest))
          as AssessWoundRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssessWoundRequest create() => AssessWoundRequest._();
  @$core.override
  AssessWoundRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssessWoundRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssessWoundRequest>(create);
  static AssessWoundRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get woundId => $_getSZ(2);
  @$pb.TagNumber(3)
  set woundId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWoundId() => $_has(2);
  @$pb.TagNumber(3)
  void clearWoundId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get location => $_getSZ(3);
  @$pb.TagNumber(4)
  set location($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);

  @$pb.TagNumber(5)
  Coding get bodyMapCode => $_getN(4);
  @$pb.TagNumber(5)
  set bodyMapCode(Coding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasBodyMapCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearBodyMapCode() => $_clearField(5);
  @$pb.TagNumber(5)
  Coding ensureBodyMapCode() => $_ensure(4);

  @$pb.TagNumber(6)
  Laterality get laterality => $_getN(5);
  @$pb.TagNumber(6)
  set laterality(Laterality value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLaterality() => $_has(5);
  @$pb.TagNumber(6)
  void clearLaterality() => $_clearField(6);

  @$pb.TagNumber(7)
  WoundKind get kind => $_getN(6);
  @$pb.TagNumber(7)
  set kind(WoundKind value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasKind() => $_has(6);
  @$pb.TagNumber(7)
  void clearKind() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get stage => $_getSZ(7);
  @$pb.TagNumber(8)
  set stage($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasStage() => $_has(7);
  @$pb.TagNumber(8)
  void clearStage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get lengthMm => $_getN(8);
  @$pb.TagNumber(9)
  set lengthMm($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasLengthMm() => $_has(8);
  @$pb.TagNumber(9)
  void clearLengthMm() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get widthMm => $_getN(9);
  @$pb.TagNumber(10)
  set widthMm($core.double value) => $_setDouble(9, value);
  @$pb.TagNumber(10)
  $core.bool hasWidthMm() => $_has(9);
  @$pb.TagNumber(10)
  void clearWidthMm() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get depthMm => $_getN(10);
  @$pb.TagNumber(11)
  set depthMm($core.double value) => $_setDouble(10, value);
  @$pb.TagNumber(11)
  $core.bool hasDepthMm() => $_has(10);
  @$pb.TagNumber(11)
  void clearDepthMm() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get appearance => $_getSZ(11);
  @$pb.TagNumber(12)
  set appearance($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasAppearance() => $_has(11);
  @$pb.TagNumber(12)
  void clearAppearance() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get exudate => $_getSZ(12);
  @$pb.TagNumber(13)
  set exudate($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasExudate() => $_has(12);
  @$pb.TagNumber(13)
  void clearExudate() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get surroundingSkin => $_getSZ(13);
  @$pb.TagNumber(14)
  set surroundingSkin($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasSurroundingSkin() => $_has(13);
  @$pb.TagNumber(14)
  void clearSurroundingSkin() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get painScore => $_getIZ(14);
  @$pb.TagNumber(15)
  set painScore($core.int value) => $_setSignedInt32(14, value);
  @$pb.TagNumber(15)
  $core.bool hasPainScore() => $_has(14);
  @$pb.TagNumber(15)
  void clearPainScore() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.bool get painScoreRecorded => $_getBF(15);
  @$pb.TagNumber(16)
  set painScoreRecorded($core.bool value) => $_setBool(15, value);
  @$pb.TagNumber(16)
  $core.bool hasPainScoreRecorded() => $_has(15);
  @$pb.TagNumber(16)
  void clearPainScoreRecorded() => $_clearField(16);

  @$pb.TagNumber(17)
  $0.Timestamp get assessedAt => $_getN(16);
  @$pb.TagNumber(17)
  set assessedAt($0.Timestamp value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasAssessedAt() => $_has(16);
  @$pb.TagNumber(17)
  void clearAssessedAt() => $_clearField(17);
  @$pb.TagNumber(17)
  $0.Timestamp ensureAssessedAt() => $_ensure(16);
}

class AssessWoundResponse extends $pb.GeneratedMessage {
  factory AssessWoundResponse({
    WoundAssessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  AssessWoundResponse._();

  factory AssessWoundResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssessWoundResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssessWoundResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<WoundAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: WoundAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessWoundResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssessWoundResponse copyWith(void Function(AssessWoundResponse) updates) =>
      super.copyWith((message) => updates(message as AssessWoundResponse))
          as AssessWoundResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssessWoundResponse create() => AssessWoundResponse._();
  @$core.override
  AssessWoundResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssessWoundResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssessWoundResponse>(create);
  static AssessWoundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WoundAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(WoundAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  WoundAssessment ensureAssessment() => $_ensure(0);
}

class AttachWoundImageRequest extends $pb.GeneratedMessage {
  factory AttachWoundImageRequest({
    $core.String? woundAssessmentId,
    $core.String? consentId,
    @$core.Deprecated('This field is deprecated.') $core.String? storageKey,
    $core.String? contentType,
    $0.Timestamp? capturedAt,
    $core.List<$core.int>? content,
  }) {
    final result = create();
    if (woundAssessmentId != null) result.woundAssessmentId = woundAssessmentId;
    if (consentId != null) result.consentId = consentId;
    if (storageKey != null) result.storageKey = storageKey;
    if (contentType != null) result.contentType = contentType;
    if (capturedAt != null) result.capturedAt = capturedAt;
    if (content != null) result.content = content;
    return result;
  }

  AttachWoundImageRequest._();

  factory AttachWoundImageRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachWoundImageRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachWoundImageRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'woundAssessmentId')
    ..aOS(2, _omitFieldNames ? '' : 'consentId')
    ..aOS(3, _omitFieldNames ? '' : 'storageKey')
    ..aOS(4, _omitFieldNames ? '' : 'contentType')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'capturedAt',
        subBuilder: $0.Timestamp.create)
    ..a<$core.List<$core.int>>(
        6, _omitFieldNames ? '' : 'content', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachWoundImageRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachWoundImageRequest copyWith(
          void Function(AttachWoundImageRequest) updates) =>
      super.copyWith((message) => updates(message as AttachWoundImageRequest))
          as AttachWoundImageRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachWoundImageRequest create() => AttachWoundImageRequest._();
  @$core.override
  AttachWoundImageRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachWoundImageRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachWoundImageRequest>(create);
  static AttachWoundImageRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get woundAssessmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set woundAssessmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWoundAssessmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearWoundAssessmentId() => $_clearField(1);

  /// Checked against the clinical consent record rather than taken on trust.
  @$pb.TagNumber(2)
  $core.String get consentId => $_getSZ(1);
  @$pb.TagNumber(2)
  set consentId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasConsentId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConsentId() => $_clearField(2);

  /// Superseded by content, and refused rather than ignored if set. A
  /// caller-supplied key can address another tenant's object or nothing at all,
  /// and the assessment would still look complete. Kept on the wire so an old
  /// client gets an error naming the problem rather than a field number that
  /// quietly changed meaning.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(3)
  $core.String get storageKey => $_getSZ(2);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(3)
  set storageKey($core.String value) => $_setString(2, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(3)
  $core.bool hasStorageKey() => $_has(2);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(3)
  void clearStorageKey() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get contentType => $_getSZ(3);
  @$pb.TagNumber(4)
  set contentType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasContentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentType() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get capturedAt => $_getN(4);
  @$pb.TagNumber(5)
  set capturedAt($0.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasCapturedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCapturedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCapturedAt() => $_ensure(4);

  /// The photograph itself.
  ///
  /// The bytes, not a key naming where the caller already put them: a
  /// caller-supplied key can address another tenant's object or nothing at all,
  /// and the assessment would still look complete. The server writes the bytes
  /// and chooses the key, so the image on the record is one it has seen.
  @$pb.TagNumber(6)
  $core.List<$core.int> get content => $_getN(5);
  @$pb.TagNumber(6)
  set content($core.List<$core.int> value) => $_setBytes(5, value);
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);
  @$pb.TagNumber(6)
  void clearContent() => $_clearField(6);
}

class AttachWoundImageResponse extends $pb.GeneratedMessage {
  factory AttachWoundImageResponse({
    WoundAssessment? assessment,
  }) {
    final result = create();
    if (assessment != null) result.assessment = assessment;
    return result;
  }

  AttachWoundImageResponse._();

  factory AttachWoundImageResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AttachWoundImageResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AttachWoundImageResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<WoundAssessment>(1, _omitFieldNames ? '' : 'assessment',
        subBuilder: WoundAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachWoundImageResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AttachWoundImageResponse copyWith(
          void Function(AttachWoundImageResponse) updates) =>
      super.copyWith((message) => updates(message as AttachWoundImageResponse))
          as AttachWoundImageResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AttachWoundImageResponse create() => AttachWoundImageResponse._();
  @$core.override
  AttachWoundImageResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AttachWoundImageResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AttachWoundImageResponse>(create);
  static AttachWoundImageResponse? _defaultInstance;

  @$pb.TagNumber(1)
  WoundAssessment get assessment => $_getN(0);
  @$pb.TagNumber(1)
  set assessment(WoundAssessment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssessment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssessment() => $_clearField(1);
  @$pb.TagNumber(1)
  WoundAssessment ensureAssessment() => $_ensure(0);
}

class GetWoundHistoryRequest extends $pb.GeneratedMessage {
  factory GetWoundHistoryRequest({
    $core.String? patientId,
    $core.String? woundId,
    $core.int? pageSize,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (woundId != null) result.woundId = woundId;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  GetWoundHistoryRequest._();

  factory GetWoundHistoryRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWoundHistoryRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWoundHistoryRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'woundId')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWoundHistoryRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWoundHistoryRequest copyWith(
          void Function(GetWoundHistoryRequest) updates) =>
      super.copyWith((message) => updates(message as GetWoundHistoryRequest))
          as GetWoundHistoryRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWoundHistoryRequest create() => GetWoundHistoryRequest._();
  @$core.override
  GetWoundHistoryRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWoundHistoryRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWoundHistoryRequest>(create);
  static GetWoundHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get woundId => $_getSZ(1);
  @$pb.TagNumber(2)
  set woundId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasWoundId() => $_has(1);
  @$pb.TagNumber(2)
  void clearWoundId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class GetWoundHistoryResponse extends $pb.GeneratedMessage {
  factory GetWoundHistoryResponse({
    $core.Iterable<WoundAssessment>? assessments,
  }) {
    final result = create();
    if (assessments != null) result.assessments.addAll(assessments);
    return result;
  }

  GetWoundHistoryResponse._();

  factory GetWoundHistoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetWoundHistoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetWoundHistoryResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<WoundAssessment>(1, _omitFieldNames ? '' : 'assessments',
        subBuilder: WoundAssessment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWoundHistoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetWoundHistoryResponse copyWith(
          void Function(GetWoundHistoryResponse) updates) =>
      super.copyWith((message) => updates(message as GetWoundHistoryResponse))
          as GetWoundHistoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetWoundHistoryResponse create() => GetWoundHistoryResponse._();
  @$core.override
  GetWoundHistoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetWoundHistoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetWoundHistoryResponse>(create);
  static GetWoundHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<WoundAssessment> get assessments => $_getList(0);
}

/// One episode of patient or family teaching (SRS-NUR-015).
class EducationRecord extends $pb.GeneratedMessage {
  factory EducationRecord({
    $core.String? educationId,
    $core.String? patientId,
    $core.String? encounterId,
    Coding? topic,
    Learner? learner,
    $core.String? learnerName,
    $core.String? method,
    Understanding? understanding,
    $core.String? barriers,
    $0.Timestamp? taughtAt,
    $core.String? taughtBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (educationId != null) result.educationId = educationId;
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (topic != null) result.topic = topic;
    if (learner != null) result.learner = learner;
    if (learnerName != null) result.learnerName = learnerName;
    if (method != null) result.method = method;
    if (understanding != null) result.understanding = understanding;
    if (barriers != null) result.barriers = barriers;
    if (taughtAt != null) result.taughtAt = taughtAt;
    if (taughtBy != null) result.taughtBy = taughtBy;
    if (version != null) result.version = version;
    return result;
  }

  EducationRecord._();

  factory EducationRecord.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EducationRecord.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EducationRecord',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'educationId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(4, _omitFieldNames ? '' : 'topic', subBuilder: Coding.create)
    ..aE<Learner>(5, _omitFieldNames ? '' : 'learner',
        enumValues: Learner.values)
    ..aOS(6, _omitFieldNames ? '' : 'learnerName')
    ..aOS(7, _omitFieldNames ? '' : 'method')
    ..aE<Understanding>(8, _omitFieldNames ? '' : 'understanding',
        enumValues: Understanding.values)
    ..aOS(9, _omitFieldNames ? '' : 'barriers')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'taughtAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(11, _omitFieldNames ? '' : 'taughtBy')
    ..aInt64(12, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EducationRecord clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EducationRecord copyWith(void Function(EducationRecord) updates) =>
      super.copyWith((message) => updates(message as EducationRecord))
          as EducationRecord;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EducationRecord create() => EducationRecord._();
  @$core.override
  EducationRecord createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EducationRecord getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EducationRecord>(create);
  static EducationRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get educationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set educationId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEducationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEducationId() => $_clearField(1);

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
  Coding get topic => $_getN(3);
  @$pb.TagNumber(4)
  set topic(Coding value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTopic() => $_has(3);
  @$pb.TagNumber(4)
  void clearTopic() => $_clearField(4);
  @$pb.TagNumber(4)
  Coding ensureTopic() => $_ensure(3);

  @$pb.TagNumber(5)
  Learner get learner => $_getN(4);
  @$pb.TagNumber(5)
  set learner(Learner value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLearner() => $_has(4);
  @$pb.TagNumber(5)
  void clearLearner() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get learnerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set learnerName($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLearnerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLearnerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get method => $_getSZ(6);
  @$pb.TagNumber(7)
  set method($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasMethod() => $_has(6);
  @$pb.TagNumber(7)
  void clearMethod() => $_clearField(7);

  @$pb.TagNumber(8)
  Understanding get understanding => $_getN(7);
  @$pb.TagNumber(8)
  set understanding(Understanding value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasUnderstanding() => $_has(7);
  @$pb.TagNumber(8)
  void clearUnderstanding() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get barriers => $_getSZ(8);
  @$pb.TagNumber(9)
  set barriers($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasBarriers() => $_has(8);
  @$pb.TagNumber(9)
  void clearBarriers() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get taughtAt => $_getN(9);
  @$pb.TagNumber(10)
  set taughtAt($0.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasTaughtAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearTaughtAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureTaughtAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $core.String get taughtBy => $_getSZ(10);
  @$pb.TagNumber(11)
  set taughtBy($core.String value) => $_setString(10, value);
  @$pb.TagNumber(11)
  $core.bool hasTaughtBy() => $_has(10);
  @$pb.TagNumber(11)
  void clearTaughtBy() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get version => $_getI64(11);
  @$pb.TagNumber(12)
  set version($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasVersion() => $_has(11);
  @$pb.TagNumber(12)
  void clearVersion() => $_clearField(12);
}

class RecordEducationRequest extends $pb.GeneratedMessage {
  factory RecordEducationRequest({
    $core.String? patientId,
    $core.String? encounterId,
    Coding? topic,
    Learner? learner,
    $core.String? learnerName,
    $core.String? method,
    Understanding? understanding,
    $core.String? barriers,
    $0.Timestamp? taughtAt,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (topic != null) result.topic = topic;
    if (learner != null) result.learner = learner;
    if (learnerName != null) result.learnerName = learnerName;
    if (method != null) result.method = method;
    if (understanding != null) result.understanding = understanding;
    if (barriers != null) result.barriers = barriers;
    if (taughtAt != null) result.taughtAt = taughtAt;
    return result;
  }

  RecordEducationRequest._();

  factory RecordEducationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEducationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEducationRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aOM<Coding>(3, _omitFieldNames ? '' : 'topic', subBuilder: Coding.create)
    ..aE<Learner>(4, _omitFieldNames ? '' : 'learner',
        enumValues: Learner.values)
    ..aOS(5, _omitFieldNames ? '' : 'learnerName')
    ..aOS(6, _omitFieldNames ? '' : 'method')
    ..aE<Understanding>(7, _omitFieldNames ? '' : 'understanding',
        enumValues: Understanding.values)
    ..aOS(8, _omitFieldNames ? '' : 'barriers')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'taughtAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEducationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEducationRequest copyWith(
          void Function(RecordEducationRequest) updates) =>
      super.copyWith((message) => updates(message as RecordEducationRequest))
          as RecordEducationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEducationRequest create() => RecordEducationRequest._();
  @$core.override
  RecordEducationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEducationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEducationRequest>(create);
  static RecordEducationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  @$pb.TagNumber(3)
  Coding get topic => $_getN(2);
  @$pb.TagNumber(3)
  set topic(Coding value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasTopic() => $_has(2);
  @$pb.TagNumber(3)
  void clearTopic() => $_clearField(3);
  @$pb.TagNumber(3)
  Coding ensureTopic() => $_ensure(2);

  @$pb.TagNumber(4)
  Learner get learner => $_getN(3);
  @$pb.TagNumber(4)
  set learner(Learner value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLearner() => $_has(3);
  @$pb.TagNumber(4)
  void clearLearner() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get learnerName => $_getSZ(4);
  @$pb.TagNumber(5)
  set learnerName($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLearnerName() => $_has(4);
  @$pb.TagNumber(5)
  void clearLearnerName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get method => $_getSZ(5);
  @$pb.TagNumber(6)
  set method($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasMethod() => $_has(5);
  @$pb.TagNumber(6)
  void clearMethod() => $_clearField(6);

  @$pb.TagNumber(7)
  Understanding get understanding => $_getN(6);
  @$pb.TagNumber(7)
  set understanding(Understanding value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUnderstanding() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnderstanding() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get barriers => $_getSZ(7);
  @$pb.TagNumber(8)
  set barriers($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasBarriers() => $_has(7);
  @$pb.TagNumber(8)
  void clearBarriers() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.Timestamp get taughtAt => $_getN(8);
  @$pb.TagNumber(9)
  set taughtAt($0.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasTaughtAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearTaughtAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureTaughtAt() => $_ensure(8);
}

class RecordEducationResponse extends $pb.GeneratedMessage {
  factory RecordEducationResponse({
    EducationRecord? record,
  }) {
    final result = create();
    if (record != null) result.record = record;
    return result;
  }

  RecordEducationResponse._();

  factory RecordEducationResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RecordEducationResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RecordEducationResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<EducationRecord>(1, _omitFieldNames ? '' : 'record',
        subBuilder: EducationRecord.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEducationResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordEducationResponse copyWith(
          void Function(RecordEducationResponse) updates) =>
      super.copyWith((message) => updates(message as RecordEducationResponse))
          as RecordEducationResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordEducationResponse create() => RecordEducationResponse._();
  @$core.override
  RecordEducationResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RecordEducationResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RecordEducationResponse>(create);
  static RecordEducationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  EducationRecord get record => $_getN(0);
  @$pb.TagNumber(1)
  set record(EducationRecord value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRecord() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecord() => $_clearField(1);
  @$pb.TagNumber(1)
  EducationRecord ensureRecord() => $_ensure(0);
}

class ReadinessCriterion extends $pb.GeneratedMessage {
  factory ReadinessCriterion({
    $core.String? key,
    $core.String? label,
    $core.bool? met,
    $core.String? note,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (label != null) result.label = label;
    if (met != null) result.met = met;
    if (note != null) result.note = note;
    return result;
  }

  ReadinessCriterion._();

  factory ReadinessCriterion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReadinessCriterion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReadinessCriterion',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'label')
    ..aOB(3, _omitFieldNames ? '' : 'met')
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessCriterion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReadinessCriterion copyWith(void Function(ReadinessCriterion) updates) =>
      super.copyWith((message) => updates(message as ReadinessCriterion))
          as ReadinessCriterion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReadinessCriterion create() => ReadinessCriterion._();
  @$core.override
  ReadinessCriterion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReadinessCriterion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReadinessCriterion>(create);
  static ReadinessCriterion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get label => $_getSZ(1);
  @$pb.TagNumber(2)
  set label($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLabel() => $_has(1);
  @$pb.TagNumber(2)
  void clearLabel() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get met => $_getBF(2);
  @$pb.TagNumber(3)
  set met($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMet() => $_has(2);
  @$pb.TagNumber(3)
  void clearMet() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

/// The nursing view of whether a patient can go home (SRS-NUR-015).
///
/// Assembled from the record rather than from a checklist somebody ticks, so a
/// criterion cannot be marked met by asserting it.
class DischargeReadiness extends $pb.GeneratedMessage {
  factory DischargeReadiness({
    $core.Iterable<ReadinessCriterion>? criteria,
    $core.bool? ready,
    $0.Timestamp? assessedAt,
    $core.String? assessedBy,
  }) {
    final result = create();
    if (criteria != null) result.criteria.addAll(criteria);
    if (ready != null) result.ready = ready;
    if (assessedAt != null) result.assessedAt = assessedAt;
    if (assessedBy != null) result.assessedBy = assessedBy;
    return result;
  }

  DischargeReadiness._();

  factory DischargeReadiness.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DischargeReadiness.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DischargeReadiness',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<ReadinessCriterion>(1, _omitFieldNames ? '' : 'criteria',
        subBuilder: ReadinessCriterion.create)
    ..aOB(2, _omitFieldNames ? '' : 'ready')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'assessedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(4, _omitFieldNames ? '' : 'assessedBy')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeReadiness clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DischargeReadiness copyWith(void Function(DischargeReadiness) updates) =>
      super.copyWith((message) => updates(message as DischargeReadiness))
          as DischargeReadiness;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DischargeReadiness create() => DischargeReadiness._();
  @$core.override
  DischargeReadiness createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DischargeReadiness getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DischargeReadiness>(create);
  static DischargeReadiness? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ReadinessCriterion> get criteria => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get ready => $_getBF(1);
  @$pb.TagNumber(2)
  set ready($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReady() => $_has(1);
  @$pb.TagNumber(2)
  void clearReady() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get assessedAt => $_getN(2);
  @$pb.TagNumber(3)
  set assessedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasAssessedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssessedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureAssessedAt() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get assessedBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set assessedBy($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAssessedBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssessedBy() => $_clearField(4);
}

class GetDischargeReadinessRequest extends $pb.GeneratedMessage {
  factory GetDischargeReadinessRequest({
    $core.String? encounterId,
    $core.String? patientId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  GetDischargeReadinessRequest._();

  factory GetDischargeReadinessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDischargeReadinessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDischargeReadinessRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDischargeReadinessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDischargeReadinessRequest copyWith(
          void Function(GetDischargeReadinessRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDischargeReadinessRequest))
          as GetDischargeReadinessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDischargeReadinessRequest create() =>
      GetDischargeReadinessRequest._();
  @$core.override
  GetDischargeReadinessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDischargeReadinessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDischargeReadinessRequest>(create);
  static GetDischargeReadinessRequest? _defaultInstance;

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
}

class GetDischargeReadinessResponse extends $pb.GeneratedMessage {
  factory GetDischargeReadinessResponse({
    DischargeReadiness? readiness,
  }) {
    final result = create();
    if (readiness != null) result.readiness = readiness;
    return result;
  }

  GetDischargeReadinessResponse._();

  factory GetDischargeReadinessResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDischargeReadinessResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDischargeReadinessResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<DischargeReadiness>(1, _omitFieldNames ? '' : 'readiness',
        subBuilder: DischargeReadiness.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDischargeReadinessResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDischargeReadinessResponse copyWith(
          void Function(GetDischargeReadinessResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetDischargeReadinessResponse))
          as GetDischargeReadinessResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDischargeReadinessResponse create() =>
      GetDischargeReadinessResponse._();
  @$core.override
  GetDischargeReadinessResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDischargeReadinessResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDischargeReadinessResponse>(create);
  static GetDischargeReadinessResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DischargeReadiness get readiness => $_getN(0);
  @$pb.TagNumber(1)
  set readiness(DischargeReadiness value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReadiness() => $_has(0);
  @$pb.TagNumber(1)
  void clearReadiness() => $_clearField(1);
  @$pb.TagNumber(1)
  DischargeReadiness ensureReadiness() => $_ensure(0);
}

/// One nurse's responsibility for one patient (SRS-NUR-017).
class NurseAssignment extends $pb.GeneratedMessage {
  factory NurseAssignment({
    $core.String? assignmentId,
    $core.String? unitId,
    $core.String? bedId,
    $core.String? patientId,
    $core.String? nurseId,
    CareRelationship? relationship,
    $0.Timestamp? effectiveFrom,
    $0.Timestamp? effectiveTo,
    $core.String? assignedBy,
    $core.String? endedReason,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (unitId != null) result.unitId = unitId;
    if (bedId != null) result.bedId = bedId;
    if (patientId != null) result.patientId = patientId;
    if (nurseId != null) result.nurseId = nurseId;
    if (relationship != null) result.relationship = relationship;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    if (assignedBy != null) result.assignedBy = assignedBy;
    if (endedReason != null) result.endedReason = endedReason;
    if (version != null) result.version = version;
    return result;
  }

  NurseAssignment._();

  factory NurseAssignment.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory NurseAssignment.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NurseAssignment',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assignmentId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'bedId')
    ..aOS(4, _omitFieldNames ? '' : 'patientId')
    ..aOS(5, _omitFieldNames ? '' : 'nurseId')
    ..aE<CareRelationship>(6, _omitFieldNames ? '' : 'relationship',
        enumValues: CareRelationship.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'assignedBy')
    ..aOS(10, _omitFieldNames ? '' : 'endedReason')
    ..aInt64(11, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NurseAssignment clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NurseAssignment copyWith(void Function(NurseAssignment) updates) =>
      super.copyWith((message) => updates(message as NurseAssignment))
          as NurseAssignment;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NurseAssignment create() => NurseAssignment._();
  @$core.override
  NurseAssignment createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static NurseAssignment getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NurseAssignment>(create);
  static NurseAssignment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assignmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assignmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bedId => $_getSZ(2);
  @$pb.TagNumber(3)
  set bedId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBedId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBedId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get patientId => $_getSZ(3);
  @$pb.TagNumber(4)
  set patientId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPatientId() => $_has(3);
  @$pb.TagNumber(4)
  void clearPatientId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get nurseId => $_getSZ(4);
  @$pb.TagNumber(5)
  set nurseId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNurseId() => $_has(4);
  @$pb.TagNumber(5)
  void clearNurseId() => $_clearField(5);

  @$pb.TagNumber(6)
  CareRelationship get relationship => $_getN(5);
  @$pb.TagNumber(6)
  set relationship(CareRelationship value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasRelationship() => $_has(5);
  @$pb.TagNumber(6)
  void clearRelationship() => $_clearField(6);

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

  @$pb.TagNumber(9)
  $core.String get assignedBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set assignedBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasAssignedBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearAssignedBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get endedReason => $_getSZ(9);
  @$pb.TagNumber(10)
  set endedReason($core.String value) => $_setString(9, value);
  @$pb.TagNumber(10)
  $core.bool hasEndedReason() => $_has(9);
  @$pb.TagNumber(10)
  void clearEndedReason() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get version => $_getI64(10);
  @$pb.TagNumber(11)
  set version($fixnum.Int64 value) => $_setInt64(10, value);
  @$pb.TagNumber(11)
  $core.bool hasVersion() => $_has(10);
  @$pb.TagNumber(11)
  void clearVersion() => $_clearField(11);
}

class AssignNurseRequest extends $pb.GeneratedMessage {
  factory AssignNurseRequest({
    $core.String? unitId,
    $core.String? bedId,
    $core.String? patientId,
    $core.String? nurseId,
    CareRelationship? relationship,
    $0.Timestamp? effectiveFrom,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (bedId != null) result.bedId = bedId;
    if (patientId != null) result.patientId = patientId;
    if (nurseId != null) result.nurseId = nurseId;
    if (relationship != null) result.relationship = relationship;
    if (effectiveFrom != null) result.effectiveFrom = effectiveFrom;
    return result;
  }

  AssignNurseRequest._();

  factory AssignNurseRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignNurseRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignNurseRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'bedId')
    ..aOS(3, _omitFieldNames ? '' : 'patientId')
    ..aOS(4, _omitFieldNames ? '' : 'nurseId')
    ..aE<CareRelationship>(5, _omitFieldNames ? '' : 'relationship',
        enumValues: CareRelationship.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'effectiveFrom',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignNurseRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignNurseRequest copyWith(void Function(AssignNurseRequest) updates) =>
      super.copyWith((message) => updates(message as AssignNurseRequest))
          as AssignNurseRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignNurseRequest create() => AssignNurseRequest._();
  @$core.override
  AssignNurseRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignNurseRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignNurseRequest>(create);
  static AssignNurseRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get bedId => $_getSZ(1);
  @$pb.TagNumber(2)
  set bedId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBedId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBedId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get patientId => $_getSZ(2);
  @$pb.TagNumber(3)
  set patientId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatientId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatientId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get nurseId => $_getSZ(3);
  @$pb.TagNumber(4)
  set nurseId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNurseId() => $_has(3);
  @$pb.TagNumber(4)
  void clearNurseId() => $_clearField(4);

  @$pb.TagNumber(5)
  CareRelationship get relationship => $_getN(4);
  @$pb.TagNumber(5)
  set relationship(CareRelationship value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRelationship() => $_has(4);
  @$pb.TagNumber(5)
  void clearRelationship() => $_clearField(5);

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
}

class AssignNurseResponse extends $pb.GeneratedMessage {
  factory AssignNurseResponse({
    NurseAssignment? assignment,
  }) {
    final result = create();
    if (assignment != null) result.assignment = assignment;
    return result;
  }

  AssignNurseResponse._();

  factory AssignNurseResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AssignNurseResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AssignNurseResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<NurseAssignment>(1, _omitFieldNames ? '' : 'assignment',
        subBuilder: NurseAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignNurseResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AssignNurseResponse copyWith(void Function(AssignNurseResponse) updates) =>
      super.copyWith((message) => updates(message as AssignNurseResponse))
          as AssignNurseResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignNurseResponse create() => AssignNurseResponse._();
  @$core.override
  AssignNurseResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AssignNurseResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AssignNurseResponse>(create);
  static AssignNurseResponse? _defaultInstance;

  @$pb.TagNumber(1)
  NurseAssignment get assignment => $_getN(0);
  @$pb.TagNumber(1)
  set assignment(NurseAssignment value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignment() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignment() => $_clearField(1);
  @$pb.TagNumber(1)
  NurseAssignment ensureAssignment() => $_ensure(0);
}

class EndAssignmentRequest extends $pb.GeneratedMessage {
  factory EndAssignmentRequest({
    $core.String? assignmentId,
    $0.Timestamp? effectiveTo,
    $core.String? reason,
  }) {
    final result = create();
    if (assignmentId != null) result.assignmentId = assignmentId;
    if (effectiveTo != null) result.effectiveTo = effectiveTo;
    if (reason != null) result.reason = reason;
    return result;
  }

  EndAssignmentRequest._();

  factory EndAssignmentRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndAssignmentRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndAssignmentRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'assignmentId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'effectiveTo',
        subBuilder: $0.Timestamp.create)
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAssignmentRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAssignmentRequest copyWith(void Function(EndAssignmentRequest) updates) =>
      super.copyWith((message) => updates(message as EndAssignmentRequest))
          as EndAssignmentRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndAssignmentRequest create() => EndAssignmentRequest._();
  @$core.override
  EndAssignmentRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndAssignmentRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndAssignmentRequest>(create);
  static EndAssignmentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get assignmentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set assignmentId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAssignmentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssignmentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get effectiveTo => $_getN(1);
  @$pb.TagNumber(2)
  set effectiveTo($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEffectiveTo() => $_has(1);
  @$pb.TagNumber(2)
  void clearEffectiveTo() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEffectiveTo() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class EndAssignmentResponse extends $pb.GeneratedMessage {
  factory EndAssignmentResponse() => create();

  EndAssignmentResponse._();

  factory EndAssignmentResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndAssignmentResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndAssignmentResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAssignmentResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndAssignmentResponse copyWith(
          void Function(EndAssignmentResponse) updates) =>
      super.copyWith((message) => updates(message as EndAssignmentResponse))
          as EndAssignmentResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndAssignmentResponse create() => EndAssignmentResponse._();
  @$core.override
  EndAssignmentResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndAssignmentResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndAssignmentResponse>(create);
  static EndAssignmentResponse? _defaultInstance;
}

/// Answered as of a time, because the question an incident review asks is "who
/// was looking after this patient at 03:40".
class ListAssignmentsRequest extends $pb.GeneratedMessage {
  factory ListAssignmentsRequest({
    $core.String? unitId,
    $core.String? patientId,
    $core.String? nurseId,
    $0.Timestamp? asOf,
    $core.int? pageSize,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (patientId != null) result.patientId = patientId;
    if (nurseId != null) result.nurseId = nurseId;
    if (asOf != null) result.asOf = asOf;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListAssignmentsRequest._();

  factory ListAssignmentsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssignmentsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssignmentsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..aOS(3, _omitFieldNames ? '' : 'nurseId')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'asOf',
        subBuilder: $0.Timestamp.create)
    ..aI(5, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsRequest copyWith(
          void Function(ListAssignmentsRequest) updates) =>
      super.copyWith((message) => updates(message as ListAssignmentsRequest))
          as ListAssignmentsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssignmentsRequest create() => ListAssignmentsRequest._();
  @$core.override
  ListAssignmentsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssignmentsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssignmentsRequest>(create);
  static ListAssignmentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get patientId => $_getSZ(1);
  @$pb.TagNumber(2)
  set patientId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPatientId() => $_has(1);
  @$pb.TagNumber(2)
  void clearPatientId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nurseId => $_getSZ(2);
  @$pb.TagNumber(3)
  set nurseId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNurseId() => $_has(2);
  @$pb.TagNumber(3)
  void clearNurseId() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get asOf => $_getN(3);
  @$pb.TagNumber(4)
  set asOf($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasAsOf() => $_has(3);
  @$pb.TagNumber(4)
  void clearAsOf() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureAsOf() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);
}

class ListAssignmentsResponse extends $pb.GeneratedMessage {
  factory ListAssignmentsResponse({
    $core.Iterable<NurseAssignment>? assignments,
  }) {
    final result = create();
    if (assignments != null) result.assignments.addAll(assignments);
    return result;
  }

  ListAssignmentsResponse._();

  factory ListAssignmentsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListAssignmentsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListAssignmentsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<NurseAssignment>(1, _omitFieldNames ? '' : 'assignments',
        subBuilder: NurseAssignment.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListAssignmentsResponse copyWith(
          void Function(ListAssignmentsResponse) updates) =>
      super.copyWith((message) => updates(message as ListAssignmentsResponse))
          as ListAssignmentsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssignmentsResponse create() => ListAssignmentsResponse._();
  @$core.override
  ListAssignmentsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListAssignmentsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListAssignmentsResponse>(create);
  static ListAssignmentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<NurseAssignment> get assignments => $_getList(0);
}

/// The named factors a workload figure is built from (SRS-NUR-016).
class AcuityInputs extends $pb.GeneratedMessage {
  factory AcuityInputs({
    $core.int? dependencyScore,
    $core.int? openTasks,
    $core.int? overdueTasks,
    $core.int? devices,
    $core.int? highRisk,
    $core.bool? isolation,
  }) {
    final result = create();
    if (dependencyScore != null) result.dependencyScore = dependencyScore;
    if (openTasks != null) result.openTasks = openTasks;
    if (overdueTasks != null) result.overdueTasks = overdueTasks;
    if (devices != null) result.devices = devices;
    if (highRisk != null) result.highRisk = highRisk;
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  AcuityInputs._();

  factory AcuityInputs.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcuityInputs.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcuityInputs',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'dependencyScore')
    ..aI(2, _omitFieldNames ? '' : 'openTasks')
    ..aI(3, _omitFieldNames ? '' : 'overdueTasks')
    ..aI(4, _omitFieldNames ? '' : 'devices')
    ..aI(5, _omitFieldNames ? '' : 'highRisk')
    ..aOB(6, _omitFieldNames ? '' : 'isolation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityInputs clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityInputs copyWith(void Function(AcuityInputs) updates) =>
      super.copyWith((message) => updates(message as AcuityInputs))
          as AcuityInputs;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcuityInputs create() => AcuityInputs._();
  @$core.override
  AcuityInputs createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcuityInputs getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcuityInputs>(create);
  static AcuityInputs? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get dependencyScore => $_getIZ(0);
  @$pb.TagNumber(1)
  set dependencyScore($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDependencyScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearDependencyScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get openTasks => $_getIZ(1);
  @$pb.TagNumber(2)
  set openTasks($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenTasks() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenTasks() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get overdueTasks => $_getIZ(2);
  @$pb.TagNumber(3)
  set overdueTasks($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverdueTasks() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverdueTasks() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get devices => $_getIZ(3);
  @$pb.TagNumber(4)
  set devices($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDevices() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevices() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get highRisk => $_getIZ(4);
  @$pb.TagNumber(5)
  set highRisk($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHighRisk() => $_has(4);
  @$pb.TagNumber(5)
  void clearHighRisk() => $_clearField(5);

  /// Adds the time cost of donning and doffing, which is substantial and
  /// invisible in every other measure.
  @$pb.TagNumber(6)
  $core.bool get isolation => $_getBF(5);
  @$pb.TagNumber(6)
  set isolation($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsolation() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsolation() => $_clearField(6);
}

class AcuityWeights extends $pb.GeneratedMessage {
  factory AcuityWeights({
    $core.int? dependency,
    $core.int? openTask,
    $core.int? overdueTask,
    $core.int? device,
    $core.int? highRisk,
    $core.int? isolation,
  }) {
    final result = create();
    if (dependency != null) result.dependency = dependency;
    if (openTask != null) result.openTask = openTask;
    if (overdueTask != null) result.overdueTask = overdueTask;
    if (device != null) result.device = device;
    if (highRisk != null) result.highRisk = highRisk;
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  AcuityWeights._();

  factory AcuityWeights.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcuityWeights.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcuityWeights',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'dependency')
    ..aI(2, _omitFieldNames ? '' : 'openTask')
    ..aI(3, _omitFieldNames ? '' : 'overdueTask')
    ..aI(4, _omitFieldNames ? '' : 'device')
    ..aI(5, _omitFieldNames ? '' : 'highRisk')
    ..aI(6, _omitFieldNames ? '' : 'isolation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityWeights clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityWeights copyWith(void Function(AcuityWeights) updates) =>
      super.copyWith((message) => updates(message as AcuityWeights))
          as AcuityWeights;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcuityWeights create() => AcuityWeights._();
  @$core.override
  AcuityWeights createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcuityWeights getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcuityWeights>(create);
  static AcuityWeights? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get dependency => $_getIZ(0);
  @$pb.TagNumber(1)
  set dependency($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDependency() => $_has(0);
  @$pb.TagNumber(1)
  void clearDependency() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get openTask => $_getIZ(1);
  @$pb.TagNumber(2)
  set openTask($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOpenTask() => $_has(1);
  @$pb.TagNumber(2)
  void clearOpenTask() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get overdueTask => $_getIZ(2);
  @$pb.TagNumber(3)
  set overdueTask($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOverdueTask() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverdueTask() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get device => $_getIZ(3);
  @$pb.TagNumber(4)
  set device($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasDevice() => $_has(3);
  @$pb.TagNumber(4)
  void clearDevice() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get highRisk => $_getIZ(4);
  @$pb.TagNumber(5)
  set highRisk($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasHighRisk() => $_has(4);
  @$pb.TagNumber(5)
  void clearHighRisk() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get isolation => $_getIZ(5);
  @$pb.TagNumber(6)
  set isolation($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasIsolation() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsolation() => $_clearField(6);
}

class PatientAcuity extends $pb.GeneratedMessage {
  factory PatientAcuity({
    $core.String? patientId,
    AcuityInputs? inputs,
    $core.int? score,
    AcuityWeights? weights,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (inputs != null) result.inputs = inputs;
    if (score != null) result.score = score;
    if (weights != null) result.weights = weights;
    return result;
  }

  PatientAcuity._();

  factory PatientAcuity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PatientAcuity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PatientAcuity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOM<AcuityInputs>(2, _omitFieldNames ? '' : 'inputs',
        subBuilder: AcuityInputs.create)
    ..aI(3, _omitFieldNames ? '' : 'score')
    ..aOM<AcuityWeights>(4, _omitFieldNames ? '' : 'weights',
        subBuilder: AcuityWeights.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientAcuity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PatientAcuity copyWith(void Function(PatientAcuity) updates) =>
      super.copyWith((message) => updates(message as PatientAcuity))
          as PatientAcuity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PatientAcuity create() => PatientAcuity._();
  @$core.override
  PatientAcuity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PatientAcuity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PatientAcuity>(create);
  static PatientAcuity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  AcuityInputs get inputs => $_getN(1);
  @$pb.TagNumber(2)
  set inputs(AcuityInputs value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasInputs() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputs() => $_clearField(2);
  @$pb.TagNumber(2)
  AcuityInputs ensureInputs() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get score => $_getIZ(2);
  @$pb.TagNumber(3)
  set score($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearScore() => $_clearField(3);

  /// Carried with the figure, so two wards' numbers are comparable only when
  /// they were computed the same way.
  @$pb.TagNumber(4)
  AcuityWeights get weights => $_getN(3);
  @$pb.TagNumber(4)
  set weights(AcuityWeights value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasWeights() => $_has(3);
  @$pb.TagNumber(4)
  void clearWeights() => $_clearField(4);
  @$pb.TagNumber(4)
  AcuityWeights ensureWeights() => $_ensure(3);
}

/// A ward's workload picture (SRS-NUR-016).
///
/// A report, and nothing more. It carries no staffing recommendation and
/// triggers no assignment.
class UnitAcuity extends $pb.GeneratedMessage {
  factory UnitAcuity({
    $core.String? unitId,
    $0.Timestamp? asOf,
    $core.Iterable<PatientAcuity>? patients,
    $core.int? nursesOnDuty,
    $core.int? total,
    $core.double? perNurse,
    $core.bool? perNurseAvailable,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (asOf != null) result.asOf = asOf;
    if (patients != null) result.patients.addAll(patients);
    if (nursesOnDuty != null) result.nursesOnDuty = nursesOnDuty;
    if (total != null) result.total = total;
    if (perNurse != null) result.perNurse = perNurse;
    if (perNurseAvailable != null) result.perNurseAvailable = perNurseAvailable;
    return result;
  }

  UnitAcuity._();

  factory UnitAcuity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UnitAcuity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UnitAcuity',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'asOf',
        subBuilder: $0.Timestamp.create)
    ..pPM<PatientAcuity>(3, _omitFieldNames ? '' : 'patients',
        subBuilder: PatientAcuity.create)
    ..aI(4, _omitFieldNames ? '' : 'nursesOnDuty')
    ..aI(5, _omitFieldNames ? '' : 'total')
    ..aD(6, _omitFieldNames ? '' : 'perNurse')
    ..aOB(7, _omitFieldNames ? '' : 'perNurseAvailable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitAcuity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UnitAcuity copyWith(void Function(UnitAcuity) updates) =>
      super.copyWith((message) => updates(message as UnitAcuity)) as UnitAcuity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnitAcuity create() => UnitAcuity._();
  @$core.override
  UnitAcuity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UnitAcuity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UnitAcuity>(create);
  static UnitAcuity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get asOf => $_getN(1);
  @$pb.TagNumber(2)
  set asOf($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasAsOf() => $_has(1);
  @$pb.TagNumber(2)
  void clearAsOf() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureAsOf() => $_ensure(1);

  /// Busiest first: the list exists to direct attention.
  @$pb.TagNumber(3)
  $pb.PbList<PatientAcuity> get patients => $_getList(2);

  /// Counted from live assignments, not from a roster: a roster says who was
  /// meant to be there.
  @$pb.TagNumber(4)
  $core.int get nursesOnDuty => $_getIZ(3);
  @$pb.TagNumber(4)
  set nursesOnDuty($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasNursesOnDuty() => $_has(3);
  @$pb.TagNumber(4)
  void clearNursesOnDuty() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get total => $_getIZ(4);
  @$pb.TagNumber(5)
  set total($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotal() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotal() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get perNurse => $_getN(5);
  @$pb.TagNumber(6)
  set perNurse($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPerNurse() => $_has(5);
  @$pb.TagNumber(6)
  void clearPerNurse() => $_clearField(6);

  /// False when nobody is on duty. A ward with no nurses assigned is not a ward
  /// with zero workload per nurse.
  @$pb.TagNumber(7)
  $core.bool get perNurseAvailable => $_getBF(6);
  @$pb.TagNumber(7)
  set perNurseAvailable($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPerNurseAvailable() => $_has(6);
  @$pb.TagNumber(7)
  void clearPerNurseAvailable() => $_clearField(7);
}

class AcuityPatientInput extends $pb.GeneratedMessage {
  factory AcuityPatientInput({
    $core.String? patientId,
    $core.String? encounterId,
    $core.int? dependencyScore,
    $core.bool? isolation,
  }) {
    final result = create();
    if (patientId != null) result.patientId = patientId;
    if (encounterId != null) result.encounterId = encounterId;
    if (dependencyScore != null) result.dependencyScore = dependencyScore;
    if (isolation != null) result.isolation = isolation;
    return result;
  }

  AcuityPatientInput._();

  factory AcuityPatientInput.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcuityPatientInput.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcuityPatientInput',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'patientId')
    ..aOS(2, _omitFieldNames ? '' : 'encounterId')
    ..aI(3, _omitFieldNames ? '' : 'dependencyScore')
    ..aOB(4, _omitFieldNames ? '' : 'isolation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityPatientInput clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcuityPatientInput copyWith(void Function(AcuityPatientInput) updates) =>
      super.copyWith((message) => updates(message as AcuityPatientInput))
          as AcuityPatientInput;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcuityPatientInput create() => AcuityPatientInput._();
  @$core.override
  AcuityPatientInput createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcuityPatientInput getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcuityPatientInput>(create);
  static AcuityPatientInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get patientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set patientId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPatientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPatientId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get encounterId => $_getSZ(1);
  @$pb.TagNumber(2)
  set encounterId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEncounterId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEncounterId() => $_clearField(2);

  /// Assessed rather than derived, so the caller supplies them; everything else
  /// is counted from the record.
  @$pb.TagNumber(3)
  $core.int get dependencyScore => $_getIZ(2);
  @$pb.TagNumber(3)
  set dependencyScore($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDependencyScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearDependencyScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isolation => $_getBF(3);
  @$pb.TagNumber(4)
  set isolation($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsolation() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsolation() => $_clearField(4);
}

class GetUnitAcuityRequest extends $pb.GeneratedMessage {
  factory GetUnitAcuityRequest({
    $core.String? unitId,
    $core.Iterable<AcuityPatientInput>? patients,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (patients != null) result.patients.addAll(patients);
    return result;
  }

  GetUnitAcuityRequest._();

  factory GetUnitAcuityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitAcuityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitAcuityRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..pPM<AcuityPatientInput>(2, _omitFieldNames ? '' : 'patients',
        subBuilder: AcuityPatientInput.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitAcuityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitAcuityRequest copyWith(void Function(GetUnitAcuityRequest) updates) =>
      super.copyWith((message) => updates(message as GetUnitAcuityRequest))
          as GetUnitAcuityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitAcuityRequest create() => GetUnitAcuityRequest._();
  @$core.override
  GetUnitAcuityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitAcuityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitAcuityRequest>(create);
  static GetUnitAcuityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<AcuityPatientInput> get patients => $_getList(1);
}

class GetUnitAcuityResponse extends $pb.GeneratedMessage {
  factory GetUnitAcuityResponse({
    UnitAcuity? acuity,
  }) {
    final result = create();
    if (acuity != null) result.acuity = acuity;
    return result;
  }

  GetUnitAcuityResponse._();

  factory GetUnitAcuityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetUnitAcuityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetUnitAcuityResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<UnitAcuity>(1, _omitFieldNames ? '' : 'acuity',
        subBuilder: UnitAcuity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitAcuityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetUnitAcuityResponse copyWith(
          void Function(GetUnitAcuityResponse) updates) =>
      super.copyWith((message) => updates(message as GetUnitAcuityResponse))
          as GetUnitAcuityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUnitAcuityResponse create() => GetUnitAcuityResponse._();
  @$core.override
  GetUnitAcuityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetUnitAcuityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetUnitAcuityResponse>(create);
  static GetUnitAcuityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  UnitAcuity get acuity => $_getN(0);
  @$pb.TagNumber(1)
  set acuity(UnitAcuity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAcuity() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcuity() => $_clearField(1);
  @$pb.TagNumber(1)
  UnitAcuity ensureAcuity() => $_ensure(0);
}

class SetAcuityWeightsRequest extends $pb.GeneratedMessage {
  factory SetAcuityWeightsRequest({
    $core.String? unitId,
    AcuityWeights? weights,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (weights != null) result.weights = weights;
    return result;
  }

  SetAcuityWeightsRequest._();

  factory SetAcuityWeightsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAcuityWeightsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAcuityWeightsRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOM<AcuityWeights>(2, _omitFieldNames ? '' : 'weights',
        subBuilder: AcuityWeights.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAcuityWeightsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAcuityWeightsRequest copyWith(
          void Function(SetAcuityWeightsRequest) updates) =>
      super.copyWith((message) => updates(message as SetAcuityWeightsRequest))
          as SetAcuityWeightsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAcuityWeightsRequest create() => SetAcuityWeightsRequest._();
  @$core.override
  SetAcuityWeightsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAcuityWeightsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAcuityWeightsRequest>(create);
  static SetAcuityWeightsRequest? _defaultInstance;

  /// Empty applies the weights to every unit in the tenant.
  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  AcuityWeights get weights => $_getN(1);
  @$pb.TagNumber(2)
  set weights(AcuityWeights value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWeights() => $_has(1);
  @$pb.TagNumber(2)
  void clearWeights() => $_clearField(2);
  @$pb.TagNumber(2)
  AcuityWeights ensureWeights() => $_ensure(1);
}

class SetAcuityWeightsResponse extends $pb.GeneratedMessage {
  factory SetAcuityWeightsResponse() => create();

  SetAcuityWeightsResponse._();

  factory SetAcuityWeightsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SetAcuityWeightsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SetAcuityWeightsResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAcuityWeightsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SetAcuityWeightsResponse copyWith(
          void Function(SetAcuityWeightsResponse) updates) =>
      super.copyWith((message) => updates(message as SetAcuityWeightsResponse))
          as SetAcuityWeightsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SetAcuityWeightsResponse create() => SetAcuityWeightsResponse._();
  @$core.override
  SetAcuityWeightsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SetAcuityWeightsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetAcuityWeightsResponse>(create);
  static SetAcuityWeightsResponse? _defaultInstance;
}

/// One period during which a unit worked on paper (SRS-NUR-018).
class DowntimeEpisode extends $pb.GeneratedMessage {
  factory DowntimeEpisode({
    $core.String? episodeId,
    $core.String? unitId,
    $core.String? reason,
    $0.Timestamp? startedAt,
    $core.String? startedBy,
    $0.Timestamp? endedAt,
    $core.String? endedBy,
    $0.Timestamp? reconciledAt,
    $core.String? reconciledBy,
    $fixnum.Int64? version,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (unitId != null) result.unitId = unitId;
    if (reason != null) result.reason = reason;
    if (startedAt != null) result.startedAt = startedAt;
    if (startedBy != null) result.startedBy = startedBy;
    if (endedAt != null) result.endedAt = endedAt;
    if (endedBy != null) result.endedBy = endedBy;
    if (reconciledAt != null) result.reconciledAt = reconciledAt;
    if (reconciledBy != null) result.reconciledBy = reconciledBy;
    if (version != null) result.version = version;
    return result;
  }

  DowntimeEpisode._();

  factory DowntimeEpisode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DowntimeEpisode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DowntimeEpisode',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'startedBy')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'endedBy')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'reconciledAt',
        subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'reconciledBy')
    ..aInt64(10, _omitFieldNames ? '' : 'version')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DowntimeEpisode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DowntimeEpisode copyWith(void Function(DowntimeEpisode) updates) =>
      super.copyWith((message) => updates(message as DowntimeEpisode))
          as DowntimeEpisode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DowntimeEpisode create() => DowntimeEpisode._();
  @$core.override
  DowntimeEpisode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DowntimeEpisode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DowntimeEpisode>(create);
  static DowntimeEpisode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get startedAt => $_getN(3);
  @$pb.TagNumber(4)
  set startedAt($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStartedAt() => $_has(3);
  @$pb.TagNumber(4)
  void clearStartedAt() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureStartedAt() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get startedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set startedBy($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get endedAt => $_getN(5);
  @$pb.TagNumber(6)
  set endedAt($0.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEndedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureEndedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get endedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set endedBy($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEndedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearEndedBy() => $_clearField(7);

  /// Separate from ended_at, because the system coming back and the paper being
  /// typed in are hours apart and the gap is where the record is incomplete.
  @$pb.TagNumber(8)
  $0.Timestamp get reconciledAt => $_getN(7);
  @$pb.TagNumber(8)
  set reconciledAt($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasReconciledAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearReconciledAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureReconciledAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get reconciledBy => $_getSZ(8);
  @$pb.TagNumber(9)
  set reconciledBy($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasReconciledBy() => $_has(8);
  @$pb.TagNumber(9)
  void clearReconciledBy() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get version => $_getI64(9);
  @$pb.TagNumber(10)
  set version($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasVersion() => $_has(9);
  @$pb.TagNumber(10)
  void clearVersion() => $_clearField(10);
}

class DeclareDowntimeRequest extends $pb.GeneratedMessage {
  factory DeclareDowntimeRequest({
    $core.String? unitId,
    $core.String? reason,
    $0.Timestamp? startedAt,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (reason != null) result.reason = reason;
    if (startedAt != null) result.startedAt = startedAt;
    return result;
  }

  DeclareDowntimeRequest._();

  factory DeclareDowntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclareDowntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclareDowntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'startedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareDowntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareDowntimeRequest copyWith(
          void Function(DeclareDowntimeRequest) updates) =>
      super.copyWith((message) => updates(message as DeclareDowntimeRequest))
          as DeclareDowntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclareDowntimeRequest create() => DeclareDowntimeRequest._();
  @$core.override
  DeclareDowntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclareDowntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclareDowntimeRequest>(create);
  static DeclareDowntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get startedAt => $_getN(2);
  @$pb.TagNumber(3)
  set startedAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureStartedAt() => $_ensure(2);
}

class DeclareDowntimeResponse extends $pb.GeneratedMessage {
  factory DeclareDowntimeResponse({
    DowntimeEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  DeclareDowntimeResponse._();

  factory DeclareDowntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeclareDowntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeclareDowntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<DowntimeEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: DowntimeEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareDowntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeclareDowntimeResponse copyWith(
          void Function(DeclareDowntimeResponse) updates) =>
      super.copyWith((message) => updates(message as DeclareDowntimeResponse))
          as DeclareDowntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeclareDowntimeResponse create() => DeclareDowntimeResponse._();
  @$core.override
  DeclareDowntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeclareDowntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeclareDowntimeResponse>(create);
  static DeclareDowntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DowntimeEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(DowntimeEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  DowntimeEpisode ensureEpisode() => $_ensure(0);
}

class EndDowntimeRequest extends $pb.GeneratedMessage {
  factory EndDowntimeRequest({
    $core.String? episodeId,
    $0.Timestamp? endedAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (endedAt != null) result.endedAt = endedAt;
    return result;
  }

  EndDowntimeRequest._();

  factory EndDowntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndDowntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndDowntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endedAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDowntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDowntimeRequest copyWith(void Function(EndDowntimeRequest) updates) =>
      super.copyWith((message) => updates(message as EndDowntimeRequest))
          as EndDowntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndDowntimeRequest create() => EndDowntimeRequest._();
  @$core.override
  EndDowntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndDowntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndDowntimeRequest>(create);
  static EndDowntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get endedAt => $_getN(1);
  @$pb.TagNumber(2)
  set endedAt($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEndedAt() => $_ensure(1);
}

class EndDowntimeResponse extends $pb.GeneratedMessage {
  factory EndDowntimeResponse({
    DowntimeEpisode? episode,
  }) {
    final result = create();
    if (episode != null) result.episode = episode;
    return result;
  }

  EndDowntimeResponse._();

  factory EndDowntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EndDowntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EndDowntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOM<DowntimeEpisode>(1, _omitFieldNames ? '' : 'episode',
        subBuilder: DowntimeEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDowntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EndDowntimeResponse copyWith(void Function(EndDowntimeResponse) updates) =>
      super.copyWith((message) => updates(message as EndDowntimeResponse))
          as EndDowntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EndDowntimeResponse create() => EndDowntimeResponse._();
  @$core.override
  EndDowntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EndDowntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EndDowntimeResponse>(create);
  static EndDowntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DowntimeEpisode get episode => $_getN(0);
  @$pb.TagNumber(1)
  set episode(DowntimeEpisode value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisode() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisode() => $_clearField(1);
  @$pb.TagNumber(1)
  DowntimeEpisode ensureEpisode() => $_ensure(0);
}

class ReconcileDowntimeRequest extends $pb.GeneratedMessage {
  factory ReconcileDowntimeRequest({
    $core.String? episodeId,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    return result;
  }

  ReconcileDowntimeRequest._();

  factory ReconcileDowntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileDowntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileDowntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileDowntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileDowntimeRequest copyWith(
          void Function(ReconcileDowntimeRequest) updates) =>
      super.copyWith((message) => updates(message as ReconcileDowntimeRequest))
          as ReconcileDowntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileDowntimeRequest create() => ReconcileDowntimeRequest._();
  @$core.override
  ReconcileDowntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileDowntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileDowntimeRequest>(create);
  static ReconcileDowntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);
}

class ReconcileDowntimeResponse extends $pb.GeneratedMessage {
  factory ReconcileDowntimeResponse({
    $core.String? episodeId,
    $core.String? unitId,
    $0.Timestamp? runAt,
  }) {
    final result = create();
    if (episodeId != null) result.episodeId = episodeId;
    if (unitId != null) result.unitId = unitId;
    if (runAt != null) result.runAt = runAt;
    return result;
  }

  ReconcileDowntimeResponse._();

  factory ReconcileDowntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ReconcileDowntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ReconcileDowntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'episodeId')
    ..aOS(2, _omitFieldNames ? '' : 'unitId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'runAt',
        subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileDowntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReconcileDowntimeResponse copyWith(
          void Function(ReconcileDowntimeResponse) updates) =>
      super.copyWith((message) => updates(message as ReconcileDowntimeResponse))
          as ReconcileDowntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReconcileDowntimeResponse create() => ReconcileDowntimeResponse._();
  @$core.override
  ReconcileDowntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ReconcileDowntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReconcileDowntimeResponse>(create);
  static ReconcileDowntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get episodeId => $_getSZ(0);
  @$pb.TagNumber(1)
  set episodeId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEpisodeId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEpisodeId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get unitId => $_getSZ(1);
  @$pb.TagNumber(2)
  set unitId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnitId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnitId() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get runAt => $_getN(2);
  @$pb.TagNumber(3)
  set runAt($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRunAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearRunAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureRunAt() => $_ensure(2);
}

class ListDowntimeRequest extends $pb.GeneratedMessage {
  factory ListDowntimeRequest({
    $core.String? unitId,
    $core.bool? unreconciledOnly,
    $core.int? pageSize,
  }) {
    final result = create();
    if (unitId != null) result.unitId = unitId;
    if (unreconciledOnly != null) result.unreconciledOnly = unreconciledOnly;
    if (pageSize != null) result.pageSize = pageSize;
    return result;
  }

  ListDowntimeRequest._();

  factory ListDowntimeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDowntimeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDowntimeRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'unitId')
    ..aOB(2, _omitFieldNames ? '' : 'unreconciledOnly')
    ..aI(3, _omitFieldNames ? '' : 'pageSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDowntimeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDowntimeRequest copyWith(void Function(ListDowntimeRequest) updates) =>
      super.copyWith((message) => updates(message as ListDowntimeRequest))
          as ListDowntimeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDowntimeRequest create() => ListDowntimeRequest._();
  @$core.override
  ListDowntimeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDowntimeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDowntimeRequest>(create);
  static ListDowntimeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get unitId => $_getSZ(0);
  @$pb.TagNumber(1)
  set unitId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUnitId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUnitId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get unreconciledOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set unreconciledOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUnreconciledOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearUnreconciledOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);
}

class ListDowntimeResponse extends $pb.GeneratedMessage {
  factory ListDowntimeResponse({
    $core.Iterable<DowntimeEpisode>? episodes,
  }) {
    final result = create();
    if (episodes != null) result.episodes.addAll(episodes);
    return result;
  }

  ListDowntimeResponse._();

  factory ListDowntimeResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListDowntimeResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListDowntimeResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<DowntimeEpisode>(1, _omitFieldNames ? '' : 'episodes',
        subBuilder: DowntimeEpisode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDowntimeResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListDowntimeResponse copyWith(void Function(ListDowntimeResponse) updates) =>
      super.copyWith((message) => updates(message as ListDowntimeResponse))
          as ListDowntimeResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDowntimeResponse create() => ListDowntimeResponse._();
  @$core.override
  ListDowntimeResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListDowntimeResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListDowntimeResponse>(create);
  static ListDowntimeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DowntimeEpisode> get episodes => $_getList(0);
}

/// A pair of unscheduled doses that may be one event typed twice.
///
/// Reported, never rejected: two doses of PRN morphine an hour apart can be
/// entirely correct.
class SuspectedDuplicate extends $pb.GeneratedMessage {
  factory SuspectedDuplicate({
    $core.String? firstId,
    $core.String? secondId,
    $core.String? orderId,
    $fixnum.Int64? apartSeconds,
  }) {
    final result = create();
    if (firstId != null) result.firstId = firstId;
    if (secondId != null) result.secondId = secondId;
    if (orderId != null) result.orderId = orderId;
    if (apartSeconds != null) result.apartSeconds = apartSeconds;
    return result;
  }

  SuspectedDuplicate._();

  factory SuspectedDuplicate.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SuspectedDuplicate.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SuspectedDuplicate',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstId')
    ..aOS(2, _omitFieldNames ? '' : 'secondId')
    ..aOS(3, _omitFieldNames ? '' : 'orderId')
    ..aInt64(4, _omitFieldNames ? '' : 'apartSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuspectedDuplicate clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SuspectedDuplicate copyWith(void Function(SuspectedDuplicate) updates) =>
      super.copyWith((message) => updates(message as SuspectedDuplicate))
          as SuspectedDuplicate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SuspectedDuplicate create() => SuspectedDuplicate._();
  @$core.override
  SuspectedDuplicate createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SuspectedDuplicate getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SuspectedDuplicate>(create);
  static SuspectedDuplicate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstId => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get secondId => $_getSZ(1);
  @$pb.TagNumber(2)
  set secondId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSecondId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSecondId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get orderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set orderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOrderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrderId() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get apartSeconds => $_getI64(3);
  @$pb.TagNumber(4)
  set apartSeconds($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasApartSeconds() => $_has(3);
  @$pb.TagNumber(4)
  void clearApartSeconds() => $_clearField(4);
}

class GetSuspectedDuplicatesRequest extends $pb.GeneratedMessage {
  factory GetSuspectedDuplicatesRequest({
    $core.String? encounterId,
    $core.String? patientId,
  }) {
    final result = create();
    if (encounterId != null) result.encounterId = encounterId;
    if (patientId != null) result.patientId = patientId;
    return result;
  }

  GetSuspectedDuplicatesRequest._();

  factory GetSuspectedDuplicatesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSuspectedDuplicatesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSuspectedDuplicatesRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'encounterId')
    ..aOS(2, _omitFieldNames ? '' : 'patientId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuspectedDuplicatesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuspectedDuplicatesRequest copyWith(
          void Function(GetSuspectedDuplicatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetSuspectedDuplicatesRequest))
          as GetSuspectedDuplicatesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSuspectedDuplicatesRequest create() =>
      GetSuspectedDuplicatesRequest._();
  @$core.override
  GetSuspectedDuplicatesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSuspectedDuplicatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSuspectedDuplicatesRequest>(create);
  static GetSuspectedDuplicatesRequest? _defaultInstance;

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
}

class GetSuspectedDuplicatesResponse extends $pb.GeneratedMessage {
  factory GetSuspectedDuplicatesResponse({
    $core.Iterable<SuspectedDuplicate>? duplicates,
  }) {
    final result = create();
    if (duplicates != null) result.duplicates.addAll(duplicates);
    return result;
  }

  GetSuspectedDuplicatesResponse._();

  factory GetSuspectedDuplicatesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSuspectedDuplicatesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSuspectedDuplicatesResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'healthcare.nursing.v1'),
      createEmptyInstance: create)
    ..pPM<SuspectedDuplicate>(1, _omitFieldNames ? '' : 'duplicates',
        subBuilder: SuspectedDuplicate.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuspectedDuplicatesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSuspectedDuplicatesResponse copyWith(
          void Function(GetSuspectedDuplicatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetSuspectedDuplicatesResponse))
          as GetSuspectedDuplicatesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSuspectedDuplicatesResponse create() =>
      GetSuspectedDuplicatesResponse._();
  @$core.override
  GetSuspectedDuplicatesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSuspectedDuplicatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSuspectedDuplicatesResponse>(create);
  static GetSuspectedDuplicatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SuspectedDuplicate> get duplicates => $_getList(0);
}

class NursingServiceApi {
  final $pb.RpcClient _client;

  NursingServiceApi(this._client);

  /// The bedside chart (SRS-NUR-003, SRS-NUR-004).
  $async.Future<ChartObservationResponse> chartObservation(
          $pb.ClientContext? ctx, ChartObservationRequest request) =>
      _client.invoke<ChartObservationResponse>(ctx, 'NursingService',
          'ChartObservation', request, ChartObservationResponse());
  $async.Future<GetFlowsheetResponse> getFlowsheet(
          $pb.ClientContext? ctx, GetFlowsheetRequest request) =>
      _client.invoke<GetFlowsheetResponse>(ctx, 'NursingService',
          'GetFlowsheet', request, GetFlowsheetResponse());
  $async.Future<RecordFluidResponse> recordFluid(
          $pb.ClientContext? ctx, RecordFluidRequest request) =>
      _client.invoke<RecordFluidResponse>(
          ctx, 'NursingService', 'RecordFluid', request, RecordFluidResponse());
  $async.Future<CorrectFluidResponse> correctFluid(
          $pb.ClientContext? ctx, CorrectFluidRequest request) =>
      _client.invoke<CorrectFluidResponse>(ctx, 'NursingService',
          'CorrectFluid', request, CorrectFluidResponse());
  $async.Future<GetFluidBalanceResponse> getFluidBalance(
          $pb.ClientContext? ctx, GetFluidBalanceRequest request) =>
      _client.invoke<GetFluidBalanceResponse>(ctx, 'NursingService',
          'GetFluidBalance', request, GetFluidBalanceResponse());
  $async.Future<GetFluidTrailResponse> getFluidTrail(
          $pb.ClientContext? ctx, GetFluidTrailRequest request) =>
      _client.invoke<GetFluidTrailResponse>(ctx, 'NursingService',
          'GetFluidTrail', request, GetFluidTrailResponse());

  /// Assessments and risk scores (SRS-NUR-001, SRS-NUR-005).
  $async.Future<DefineAssessmentTemplateResponse> defineAssessmentTemplate(
          $pb.ClientContext? ctx, DefineAssessmentTemplateRequest request) =>
      _client.invoke<DefineAssessmentTemplateResponse>(
          ctx,
          'NursingService',
          'DefineAssessmentTemplate',
          request,
          DefineAssessmentTemplateResponse());
  $async.Future<ListAssessmentTemplatesResponse> listAssessmentTemplates(
          $pb.ClientContext? ctx, ListAssessmentTemplatesRequest request) =>
      _client.invoke<ListAssessmentTemplatesResponse>(
          ctx,
          'NursingService',
          'ListAssessmentTemplates',
          request,
          ListAssessmentTemplatesResponse());
  $async.Future<RetireAssessmentTemplateResponse> retireAssessmentTemplate(
          $pb.ClientContext? ctx, RetireAssessmentTemplateRequest request) =>
      _client.invoke<RetireAssessmentTemplateResponse>(
          ctx,
          'NursingService',
          'RetireAssessmentTemplate',
          request,
          RetireAssessmentTemplateResponse());
  $async.Future<RecordAssessmentResponse> recordAssessment(
          $pb.ClientContext? ctx, RecordAssessmentRequest request) =>
      _client.invoke<RecordAssessmentResponse>(ctx, 'NursingService',
          'RecordAssessment', request, RecordAssessmentResponse());
  $async.Future<ListAssessmentsResponse> listAssessments(
          $pb.ClientContext? ctx, ListAssessmentsRequest request) =>
      _client.invoke<ListAssessmentsResponse>(ctx, 'NursingService',
          'ListAssessments', request, ListAssessmentsResponse());
  $async.Future<DefineRiskScaleResponse> defineRiskScale(
          $pb.ClientContext? ctx, DefineRiskScaleRequest request) =>
      _client.invoke<DefineRiskScaleResponse>(ctx, 'NursingService',
          'DefineRiskScale', request, DefineRiskScaleResponse());
  $async.Future<ScoreRiskResponse> scoreRisk(
          $pb.ClientContext? ctx, ScoreRiskRequest request) =>
      _client.invoke<ScoreRiskResponse>(
          ctx, 'NursingService', 'ScoreRisk', request, ScoreRiskResponse());
  $async.Future<ListRiskAssessmentsResponse> listRiskAssessments(
          $pb.ClientContext? ctx, ListRiskAssessmentsRequest request) =>
      _client.invoke<ListRiskAssessmentsResponse>(ctx, 'NursingService',
          'ListRiskAssessments', request, ListRiskAssessmentsResponse());
  $async.Future<ListDueReassessmentsResponse> listDueReassessments(
          $pb.ClientContext? ctx, ListDueReassessmentsRequest request) =>
      _client.invoke<ListDueReassessmentsResponse>(ctx, 'NursingService',
          'ListDueReassessments', request, ListDueReassessmentsResponse());

  /// Devices (SRS-NUR-006).
  $async.Future<InsertDeviceResponse> insertDevice(
          $pb.ClientContext? ctx, InsertDeviceRequest request) =>
      _client.invoke<InsertDeviceResponse>(ctx, 'NursingService',
          'InsertDevice', request, InsertDeviceResponse());
  $async.Future<RemoveDeviceResponse> removeDevice(
          $pb.ClientContext? ctx, RemoveDeviceRequest request) =>
      _client.invoke<RemoveDeviceResponse>(ctx, 'NursingService',
          'RemoveDevice', request, RemoveDeviceResponse());
  $async.Future<RecordDeviceCareResponse> recordDeviceCare(
          $pb.ClientContext? ctx, RecordDeviceCareRequest request) =>
      _client.invoke<RecordDeviceCareResponse>(ctx, 'NursingService',
          'RecordDeviceCare', request, RecordDeviceCareResponse());
  $async.Future<ListDevicesResponse> listDevices(
          $pb.ClientContext? ctx, ListDevicesRequest request) =>
      _client.invoke<ListDevicesResponse>(
          ctx, 'NursingService', 'ListDevices', request, ListDevicesResponse());

  /// The medication administration record
  /// (SRS-NUR-007, SRS-NUR-008, SRS-NUR-009).
  $async.Future<GetMedicationRoundResponse> getMedicationRound(
          $pb.ClientContext? ctx, GetMedicationRoundRequest request) =>
      _client.invoke<GetMedicationRoundResponse>(ctx, 'NursingService',
          'GetMedicationRound', request, GetMedicationRoundResponse());
  $async.Future<AdministerResponse> administer(
          $pb.ClientContext? ctx, AdministerRequest request) =>
      _client.invoke<AdministerResponse>(
          ctx, 'NursingService', 'Administer', request, AdministerResponse());
  $async.Future<ListAdministrationsResponse> listAdministrations(
          $pb.ClientContext? ctx, ListAdministrationsRequest request) =>
      _client.invoke<ListAdministrationsResponse>(ctx, 'NursingService',
          'ListAdministrations', request, ListAdministrationsResponse());
  $async.Future<GetOverrideReportResponse> getOverrideReport(
          $pb.ClientContext? ctx, GetOverrideReportRequest request) =>
      _client.invoke<GetOverrideReportResponse>(ctx, 'NursingService',
          'GetOverrideReport', request, GetOverrideReportResponse());
  $async.Future<SetAdministrationPolicyResponse> setAdministrationPolicy(
          $pb.ClientContext? ctx, SetAdministrationPolicyRequest request) =>
      _client.invoke<SetAdministrationPolicyResponse>(
          ctx,
          'NursingService',
          'SetAdministrationPolicy',
          request,
          SetAdministrationPolicyResponse());

  /// Care plans and the worklist (SRS-NUR-002, SRS-NUR-011).
  $async.Future<CreateCarePlanResponse> createCarePlan(
          $pb.ClientContext? ctx, CreateCarePlanRequest request) =>
      _client.invoke<CreateCarePlanResponse>(ctx, 'NursingService',
          'CreateCarePlan', request, CreateCarePlanResponse());
  $async.Future<ReviewCarePlanResponse> reviewCarePlan(
          $pb.ClientContext? ctx, ReviewCarePlanRequest request) =>
      _client.invoke<ReviewCarePlanResponse>(ctx, 'NursingService',
          'ReviewCarePlan', request, ReviewCarePlanResponse());
  $async.Future<ListCarePlansResponse> listCarePlans(
          $pb.ClientContext? ctx, ListCarePlansRequest request) =>
      _client.invoke<ListCarePlansResponse>(ctx, 'NursingService',
          'ListCarePlans', request, ListCarePlansResponse());
  $async.Future<CreateTaskResponse> createTask(
          $pb.ClientContext? ctx, CreateTaskRequest request) =>
      _client.invoke<CreateTaskResponse>(
          ctx, 'NursingService', 'CreateTask', request, CreateTaskResponse());
  $async.Future<CompleteTaskResponse> completeTask(
          $pb.ClientContext? ctx, CompleteTaskRequest request) =>
      _client.invoke<CompleteTaskResponse>(ctx, 'NursingService',
          'CompleteTask', request, CompleteTaskResponse());
  $async.Future<SkipTaskResponse> skipTask(
          $pb.ClientContext? ctx, SkipTaskRequest request) =>
      _client.invoke<SkipTaskResponse>(
          ctx, 'NursingService', 'SkipTask', request, SkipTaskResponse());
  $async.Future<GetWorklistResponse> getWorklist(
          $pb.ClientContext? ctx, GetWorklistRequest request) =>
      _client.invoke<GetWorklistResponse>(
          ctx, 'NursingService', 'GetWorklist', request, GetWorklistResponse());
  $async.Future<EscalateOverdueWorkResponse> escalateOverdueWork(
          $pb.ClientContext? ctx, EscalateOverdueWorkRequest request) =>
      _client.invoke<EscalateOverdueWorkResponse>(ctx, 'NursingService',
          'EscalateOverdueWork', request, EscalateOverdueWorkResponse());

  /// Handover (SRS-NUR-010).
  $async.Future<ComposeHandoverResponse> composeHandover(
          $pb.ClientContext? ctx, ComposeHandoverRequest request) =>
      _client.invoke<ComposeHandoverResponse>(ctx, 'NursingService',
          'ComposeHandover', request, ComposeHandoverResponse());
  $async.Future<AcknowledgeHandoverResponse> acknowledgeHandover(
          $pb.ClientContext? ctx, AcknowledgeHandoverRequest request) =>
      _client.invoke<AcknowledgeHandoverResponse>(ctx, 'NursingService',
          'AcknowledgeHandover', request, AcknowledgeHandoverResponse());
  $async.Future<ListHandoversResponse> listHandovers(
          $pb.ClientContext? ctx, ListHandoversRequest request) =>
      _client.invoke<ListHandoversResponse>(ctx, 'NursingService',
          'ListHandovers', request, ListHandoversResponse());

  /// Restraints and transfusion (SRS-NUR-013, SRS-NUR-014).
  $async.Future<ApplyRestraintResponse> applyRestraint(
          $pb.ClientContext? ctx, ApplyRestraintRequest request) =>
      _client.invoke<ApplyRestraintResponse>(ctx, 'NursingService',
          'ApplyRestraint', request, ApplyRestraintResponse());
  $async.Future<RenewRestraintResponse> renewRestraint(
          $pb.ClientContext? ctx, RenewRestraintRequest request) =>
      _client.invoke<RenewRestraintResponse>(ctx, 'NursingService',
          'RenewRestraint', request, RenewRestraintResponse());
  $async.Future<CheckRestraintResponse> checkRestraint(
          $pb.ClientContext? ctx, CheckRestraintRequest request) =>
      _client.invoke<CheckRestraintResponse>(ctx, 'NursingService',
          'CheckRestraint', request, CheckRestraintResponse());
  $async.Future<DiscontinueRestraintResponse> discontinueRestraint(
          $pb.ClientContext? ctx, DiscontinueRestraintRequest request) =>
      _client.invoke<DiscontinueRestraintResponse>(ctx, 'NursingService',
          'DiscontinueRestraint', request, DiscontinueRestraintResponse());
  $async.Future<ListRestraintsResponse> listRestraints(
          $pb.ClientContext? ctx, ListRestraintsRequest request) =>
      _client.invoke<ListRestraintsResponse>(ctx, 'NursingService',
          'ListRestraints', request, ListRestraintsResponse());
  $async.Future<GetRestraintAlertsResponse> getRestraintAlerts(
          $pb.ClientContext? ctx, GetRestraintAlertsRequest request) =>
      _client.invoke<GetRestraintAlertsResponse>(ctx, 'NursingService',
          'GetRestraintAlerts', request, GetRestraintAlertsResponse());

  /// Transfusions moved to the blood bank (SRS-NUR-014, migration 0047). These
  /// four remain on the wire because removing them would break every client
  /// built against this version (SRS-API-002); each refuses and names the
  /// healthcare.bloodbank.v1.BloodBankService call that replaces it. They go in
  /// nursing v2.
  @$core.Deprecated('This method is deprecated')
  $async.Future<StartTransfusionResponse> startTransfusion(
          $pb.ClientContext? ctx, StartTransfusionRequest request) =>
      _client.invoke<StartTransfusionResponse>(ctx, 'NursingService',
          'StartTransfusion', request, StartTransfusionResponse());
  @$core.Deprecated('This method is deprecated')
  $async.Future<ObserveTransfusionResponse> observeTransfusion(
          $pb.ClientContext? ctx, ObserveTransfusionRequest request) =>
      _client.invoke<ObserveTransfusionResponse>(ctx, 'NursingService',
          'ObserveTransfusion', request, ObserveTransfusionResponse());
  @$core.Deprecated('This method is deprecated')
  $async.Future<ReportTransfusionReactionResponse> reportTransfusionReaction(
          $pb.ClientContext? ctx, ReportTransfusionReactionRequest request) =>
      _client.invoke<ReportTransfusionReactionResponse>(
          ctx,
          'NursingService',
          'ReportTransfusionReaction',
          request,
          ReportTransfusionReactionResponse());
  @$core.Deprecated('This method is deprecated')
  $async.Future<CompleteTransfusionResponse> completeTransfusion(
          $pb.ClientContext? ctx, CompleteTransfusionRequest request) =>
      _client.invoke<CompleteTransfusionResponse>(ctx, 'NursingService',
          'CompleteTransfusion', request, CompleteTransfusionResponse());

  /// Wounds, education and discharge (SRS-NUR-012, SRS-NUR-015).
  $async.Future<AssessWoundResponse> assessWound(
          $pb.ClientContext? ctx, AssessWoundRequest request) =>
      _client.invoke<AssessWoundResponse>(
          ctx, 'NursingService', 'AssessWound', request, AssessWoundResponse());
  $async.Future<AttachWoundImageResponse> attachWoundImage(
          $pb.ClientContext? ctx, AttachWoundImageRequest request) =>
      _client.invoke<AttachWoundImageResponse>(ctx, 'NursingService',
          'AttachWoundImage', request, AttachWoundImageResponse());
  $async.Future<GetWoundHistoryResponse> getWoundHistory(
          $pb.ClientContext? ctx, GetWoundHistoryRequest request) =>
      _client.invoke<GetWoundHistoryResponse>(ctx, 'NursingService',
          'GetWoundHistory', request, GetWoundHistoryResponse());
  $async.Future<RecordEducationResponse> recordEducation(
          $pb.ClientContext? ctx, RecordEducationRequest request) =>
      _client.invoke<RecordEducationResponse>(ctx, 'NursingService',
          'RecordEducation', request, RecordEducationResponse());
  $async.Future<GetDischargeReadinessResponse> getDischargeReadiness(
          $pb.ClientContext? ctx, GetDischargeReadinessRequest request) =>
      _client.invoke<GetDischargeReadinessResponse>(ctx, 'NursingService',
          'GetDischargeReadiness', request, GetDischargeReadinessResponse());

  /// Assignment and acuity (SRS-NUR-016, SRS-NUR-017).
  $async.Future<AssignNurseResponse> assignNurse(
          $pb.ClientContext? ctx, AssignNurseRequest request) =>
      _client.invoke<AssignNurseResponse>(
          ctx, 'NursingService', 'AssignNurse', request, AssignNurseResponse());
  $async.Future<EndAssignmentResponse> endAssignment(
          $pb.ClientContext? ctx, EndAssignmentRequest request) =>
      _client.invoke<EndAssignmentResponse>(ctx, 'NursingService',
          'EndAssignment', request, EndAssignmentResponse());
  $async.Future<ListAssignmentsResponse> listAssignments(
          $pb.ClientContext? ctx, ListAssignmentsRequest request) =>
      _client.invoke<ListAssignmentsResponse>(ctx, 'NursingService',
          'ListAssignments', request, ListAssignmentsResponse());
  $async.Future<GetUnitAcuityResponse> getUnitAcuity(
          $pb.ClientContext? ctx, GetUnitAcuityRequest request) =>
      _client.invoke<GetUnitAcuityResponse>(ctx, 'NursingService',
          'GetUnitAcuity', request, GetUnitAcuityResponse());
  $async.Future<SetAcuityWeightsResponse> setAcuityWeights(
          $pb.ClientContext? ctx, SetAcuityWeightsRequest request) =>
      _client.invoke<SetAcuityWeightsResponse>(ctx, 'NursingService',
          'SetAcuityWeights', request, SetAcuityWeightsResponse());

  /// Downtime (SRS-NUR-018).
  $async.Future<DeclareDowntimeResponse> declareDowntime(
          $pb.ClientContext? ctx, DeclareDowntimeRequest request) =>
      _client.invoke<DeclareDowntimeResponse>(ctx, 'NursingService',
          'DeclareDowntime', request, DeclareDowntimeResponse());
  $async.Future<EndDowntimeResponse> endDowntime(
          $pb.ClientContext? ctx, EndDowntimeRequest request) =>
      _client.invoke<EndDowntimeResponse>(
          ctx, 'NursingService', 'EndDowntime', request, EndDowntimeResponse());
  $async.Future<ReconcileDowntimeResponse> reconcileDowntime(
          $pb.ClientContext? ctx, ReconcileDowntimeRequest request) =>
      _client.invoke<ReconcileDowntimeResponse>(ctx, 'NursingService',
          'ReconcileDowntime', request, ReconcileDowntimeResponse());
  $async.Future<ListDowntimeResponse> listDowntime(
          $pb.ClientContext? ctx, ListDowntimeRequest request) =>
      _client.invoke<ListDowntimeResponse>(ctx, 'NursingService',
          'ListDowntime', request, ListDowntimeResponse());
  $async.Future<GetSuspectedDuplicatesResponse> getSuspectedDuplicates(
          $pb.ClientContext? ctx, GetSuspectedDuplicatesRequest request) =>
      _client.invoke<GetSuspectedDuplicatesResponse>(ctx, 'NursingService',
          'GetSuspectedDuplicates', request, GetSuspectedDuplicatesResponse());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
